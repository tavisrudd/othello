//! Convert an external QDistSAT matrix stem into a checked Ergodis CSS input.

use std::ffi::{OsStr, OsString};
use std::fs::{self, File, OpenOptions};
use std::io::{BufRead, BufReader, Read, Write};
use std::path::{Path, PathBuf};

use anyhow::{bail, Context, Result};
use clap::{Parser, ValueEnum};
use serde::Serialize;
use sha2::{Digest, Sha256};

const UPSTREAM_URL: &str = "https://github.com/guluchen/QDistSAT";

#[derive(Clone, Copy, Debug, ValueEnum)]
enum Direction {
    X,
    Z,
}

#[derive(Debug, Parser)]
struct Args {
    /// Matrix stem without `_Hx.txt` / `_Hz.txt` / `_Gx.txt` / `_Gz.txt`.
    #[arg(long)]
    stem: PathBuf,
    #[arg(long, value_enum)]
    direction: Direction,
    #[arg(long)]
    maximum_weight: u16,
    #[arg(long)]
    upstream_revision: String,
    #[arg(long)]
    label: Option<String>,
    /// Validate the source matrices without writing an Ergodis problem.
    #[arg(long, conflicts_with = "out")]
    check_only: bool,
    #[arg(long, required_unless_present = "check_only")]
    out: Option<PathBuf>,
}

#[derive(Debug)]
struct Matrix {
    columns: usize,
    rows: Vec<Vec<u64>>,
}

#[derive(Serialize)]
struct SparseProblem {
    label: String,
    coordinate_count: u16,
    physical_checks: Vec<Vec<u16>>,
    logical_observations: Vec<Vec<u16>>,
    anchors: Vec<u16>,
    maximum_weight: u16,
    metadata: Metadata,
}

#[derive(Serialize)]
struct Metadata {
    source_schema: &'static str,
    upstream_url: &'static str,
    upstream_license: &'static str,
    upstream_notice: &'static str,
    upstream_revision: String,
    direction: &'static str,
    hx_sha256: String,
    hz_sha256: String,
    gx_sha256: String,
    gz_sha256: String,
    hx_rows: usize,
    hz_rows: usize,
    hx_rank: usize,
    hz_rank: usize,
    logical_input_rows: usize,
    logical_rank: usize,
    encoded_dimension: usize,
    anchor_policy: &'static str,
}

fn main() -> Result<()> {
    let args = Args::parse();
    if args.maximum_weight == 0 {
        bail!("--maximum-weight must be positive");
    }
    if args.upstream_revision.len() != 40
        || !args
            .upstream_revision
            .bytes()
            .all(|byte| byte.is_ascii_hexdigit())
    {
        bail!("--upstream-revision must be a 40-digit hexadecimal Git commit");
    }
    let hx_path = suffix_path(&args.stem, "_Hx.txt");
    let hz_path = suffix_path(&args.stem, "_Hz.txt");
    let gx_path = suffix_path(&args.stem, "_Gx.txt");
    let gz_path = suffix_path(&args.stem, "_Gz.txt");
    let hx = read_matrix(&hx_path)?;
    let hz = read_matrix(&hz_path)?;
    let gx = read_matrix(&gx_path)?;
    let gz = read_matrix(&gz_path)?;
    let problem = compile_problem(
        args.label
            .unwrap_or_else(|| default_label(&args.stem, args.direction)),
        args.direction,
        args.maximum_weight,
        args.upstream_revision,
        [&hx_path, &hz_path, &gx_path, &gz_path],
        [&hx, &hz, &gx, &gz],
    )?;
    if args.check_only {
        return Ok(());
    }
    let out = args
        .out
        .context("--out is required unless --check-only is set")?;
    let mut encoded = serde_json::to_vec(&problem)?;
    encoded.push(b'\n');
    if out.exists() {
        let prior =
            fs::read(&out).with_context(|| format!("reading existing output {}", out.display()))?;
        if prior == encoded {
            return Ok(());
        }
        bail!("refusing to replace different output {}", out.display());
    }
    if let Some(parent) = out.parent().filter(|parent| !parent.as_os_str().is_empty()) {
        fs::create_dir_all(parent)
            .with_context(|| format!("creating output directory {}", parent.display()))?;
    }
    let mut output = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(&out)
        .with_context(|| format!("creating output {}", out.display()))?;
    output
        .write_all(&encoded)
        .with_context(|| format!("writing output {}", out.display()))?;
    Ok(())
}

fn compile_problem(
    label: String,
    direction: Direction,
    maximum_weight: u16,
    upstream_revision: String,
    paths: [&Path; 4],
    matrices: [&Matrix; 4],
) -> Result<SparseProblem> {
    let [hx, hz, gx, gz] = matrices;
    let columns = hx.columns;
    if columns == 0 || columns > u16::MAX as usize {
        bail!("coordinate count must fit a positive u16");
    }
    for (name, matrix) in [("Hz", hz), ("Gx", gx), ("Gz", gz)] {
        if matrix.columns != columns {
            bail!("{name} has {} columns, expected {columns}", matrix.columns);
        }
    }
    if !orthogonal(&hx.rows, &hz.rows) {
        bail!("Hx and Hz do not commute");
    }
    let hx_basis = row_basis(&hx.rows, columns);
    let hz_basis = row_basis(&hz.rows, columns);
    let encoded_dimension = columns
        .checked_sub(hx_basis.len() + hz_basis.len())
        .context("parity-check ranks exceed the coordinate count")?;
    let (physical, stabilizer, logical_input, direction_name) = match direction {
        Direction::Z => (&hx_basis, &hz_basis, &gz.rows, "z"),
        Direction::X => (&hz_basis, &hx_basis, &gx.rows, "x"),
    };
    if !orthogonal(logical_input, stabilizer) {
        bail!("logical observations do not commute with the stabilizer rows");
    }
    let logical_basis = row_basis(logical_input, columns);
    if logical_basis.len() != encoded_dimension {
        bail!(
            "logical rank {} does not equal encoded dimension {encoded_dimension}",
            logical_basis.len()
        );
    }
    let mut combined = physical.clone();
    combined.extend(logical_basis.iter().cloned());
    if row_basis(&combined, columns).len() != physical.len() + encoded_dimension {
        bail!("logical observations are not independent modulo physical checks");
    }
    let [hx_path, hz_path, gx_path, gz_path] = paths;
    Ok(SparseProblem {
        label,
        coordinate_count: columns as u16,
        physical_checks: physical.iter().map(|row| sparse(row, columns)).collect(),
        logical_observations: logical_basis
            .iter()
            .map(|row| sparse(row, columns))
            .collect(),
        anchors: (0..columns).map(|coordinate| coordinate as u16).collect(),
        maximum_weight,
        metadata: Metadata {
            source_schema: "QDistSAT-dense-binary-v1",
            upstream_url: UPSTREAM_URL,
            upstream_license: "GPL-3.0-or-later",
            upstream_notice: "retain the QDistSAT NOTICE when redistributing derived matrices",
            upstream_revision,
            direction: direction_name,
            hx_sha256: sha256_file(hx_path)?,
            hz_sha256: sha256_file(hz_path)?,
            gx_sha256: sha256_file(gx_path)?,
            gz_sha256: sha256_file(gz_path)?,
            hx_rows: hx.rows.len(),
            hz_rows: hz.rows.len(),
            hx_rank: hx_basis.len(),
            hz_rank: hz_basis.len(),
            logical_input_rows: logical_input.len(),
            logical_rank: logical_basis.len(),
            encoded_dimension,
            anchor_policy: "all-coordinates-no-symmetry-assumed",
        },
    })
}

fn read_matrix(path: &Path) -> Result<Matrix> {
    let file = File::open(path).with_context(|| format!("opening {}", path.display()))?;
    parse_matrix(BufReader::new(file)).with_context(|| format!("parsing {}", path.display()))
}

fn parse_matrix(reader: impl BufRead) -> Result<Matrix> {
    let mut columns = None;
    let mut rows = Vec::new();
    for (line_number, line) in reader.lines().enumerate() {
        let line = line?;
        let body = line.split('#').next().unwrap().trim();
        if body.is_empty() {
            continue;
        }
        let tokens = body.split_whitespace().collect::<Vec<_>>();
        let width = *columns.get_or_insert(tokens.len());
        if width == 0 || tokens.len() != width {
            bail!("line {} has a nonrectangular width", line_number + 1);
        }
        let mut row = vec![0_u64; width.div_ceil(64)];
        for (column, token) in tokens.into_iter().enumerate() {
            match token {
                "0" => {}
                "1" => row[column / 64] |= 1_u64 << (column % 64),
                _ => bail!("line {} contains a nonbinary token", line_number + 1),
            }
        }
        rows.push(row);
    }
    let columns = columns.context("matrix has no data rows")?;
    Ok(Matrix { columns, rows })
}

fn row_basis(rows: &[Vec<u64>], columns: usize) -> Vec<Vec<u64>> {
    let mut pivots = vec![None::<Vec<u64>>; columns];
    for original in rows {
        let mut row = original.clone();
        loop {
            let Some(pivot) = highest_set_bit(&row) else {
                break;
            };
            if let Some(prior) = &pivots[pivot] {
                xor_assign(&mut row, prior);
            } else {
                pivots[pivot] = Some(row);
                break;
            }
        }
    }
    pivots.into_iter().flatten().collect()
}

fn highest_set_bit(row: &[u64]) -> Option<usize> {
    row.iter().enumerate().rev().find_map(|(word, &value)| {
        (value != 0).then(|| word * 64 + 63 - value.leading_zeros() as usize)
    })
}

fn xor_assign(left: &mut [u64], right: &[u64]) {
    for (left, &right) in left.iter_mut().zip(right) {
        *left ^= right;
    }
}

fn orthogonal(left: &[Vec<u64>], right: &[Vec<u64>]) -> bool {
    left.iter().all(|left| {
        right.iter().all(|right| {
            left.iter()
                .zip(right)
                .fold(0_u32, |parity, (&left, &right)| {
                    parity ^ (left & right).count_ones()
                })
                & 1
                == 0
        })
    })
}

fn sparse(row: &[u64], columns: usize) -> Vec<u16> {
    (0..columns)
        .filter(|&column| row[column / 64] & (1_u64 << (column % 64)) != 0)
        .map(|column| column as u16)
        .collect()
}

fn sha256_file(path: &Path) -> Result<String> {
    let mut file = File::open(path).with_context(|| format!("opening {}", path.display()))?;
    let mut digest = Sha256::new();
    let mut buffer = [0_u8; 64 * 1024];
    loop {
        let read = file.read(&mut buffer)?;
        if read == 0 {
            break;
        }
        digest.update(&buffer[..read]);
    }
    let digest = digest.finalize();
    Ok(format!("{digest:x}"))
}

fn suffix_path(stem: &Path, suffix: &str) -> PathBuf {
    let mut value = OsString::from(stem.as_os_str());
    value.push(OsStr::new(suffix));
    PathBuf::from(value)
}

fn default_label(stem: &Path, direction: Direction) -> String {
    format!(
        "{}-{}",
        stem.file_name().and_then(OsStr::to_str).unwrap_or("qdist"),
        match direction {
            Direction::X => "x",
            Direction::Z => "z",
        }
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_binary_rows_and_rejects_bad_tokens() {
        let matrix = parse_matrix(std::io::Cursor::new("1 0 1\n0 1 0 # row\n")).unwrap();
        assert_eq!(matrix.columns, 3);
        assert_eq!(matrix.rows, [vec![0b101], vec![0b010]]);
        assert!(parse_matrix(std::io::Cursor::new("1 2\n")).is_err());
    }

    #[test]
    fn packed_basis_and_commutation_are_exact() {
        let hx = vec![vec![0b0011]];
        let hz = vec![vec![0b1100]];
        let gz = vec![vec![0b0001], vec![0b1100]];
        assert!(orthogonal(&hx, &hz));
        assert!(orthogonal(&gz, &hz));
        assert_eq!(row_basis(&[hx.clone(), hz.clone()].concat(), 4).len(), 2);
        assert_eq!(row_basis(&gz, 4).len(), 2);
        assert_eq!(sparse(&[0b1010], 4), [1, 3]);
    }
}
