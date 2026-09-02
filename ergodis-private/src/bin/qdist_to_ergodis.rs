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
    /// Discover a verified global, block-cyclic, or two-block torus action.
    #[arg(long)]
    discover_symmetry: bool,
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
    coordinate_generators: Vec<Vec<u16>>,
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
    symmetry_kind: Option<&'static str>,
    symmetry_parameters: Vec<usize>,
    symmetry_orbits: usize,
}

#[derive(Debug)]
struct Symmetry {
    kind: &'static str,
    parameters: Vec<usize>,
    generators: Vec<Vec<u16>>,
    anchors: Vec<u16>,
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
        args.discover_symmetry,
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
    discover_symmetry: bool,
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
    let (physical_input, physical_basis, stabilizer, logical_input, direction_name) =
        match direction {
            Direction::Z => (&hx.rows, &hx_basis, &hz_basis, &gz.rows, "z"),
            Direction::X => (&hz.rows, &hz_basis, &hx_basis, &gx.rows, "x"),
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
    let mut combined = physical_basis.clone();
    combined.extend(logical_basis.iter().cloned());
    let observable_basis = row_basis(&combined, columns);
    if observable_basis.len() != physical_basis.len() + encoded_dimension {
        bail!("logical observations are not independent modulo physical checks");
    }
    let symmetry =
        discover_symmetry.then(|| find_symmetry(physical_basis, &observable_basis, columns));
    let symmetry = symmetry.flatten();
    let (anchors, coordinate_generators, anchor_policy) = symmetry.as_ref().map_or_else(
        || {
            (
                (0..columns).map(|coordinate| coordinate as u16).collect(),
                Vec::new(),
                "all-coordinates-no-symmetry-assumed",
            )
        },
        |symmetry| {
            (
                symmetry.anchors.clone(),
                symmetry.generators.clone(),
                "verified-coordinate-orbit-transversal",
            )
        },
    );
    let [hx_path, hz_path, gx_path, gz_path] = paths;
    Ok(SparseProblem {
        label,
        coordinate_count: columns as u16,
        physical_checks: physical_input
            .iter()
            .map(|row| sparse(row, columns))
            .collect(),
        logical_observations: logical_basis
            .iter()
            .map(|row| sparse(row, columns))
            .collect(),
        anchors,
        coordinate_generators,
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
            anchor_policy,
            symmetry_kind: symmetry.as_ref().map(|symmetry| symmetry.kind),
            symmetry_parameters: symmetry
                .as_ref()
                .map_or_else(Vec::new, |symmetry| symmetry.parameters.clone()),
            symmetry_orbits: symmetry
                .as_ref()
                .map_or(columns, |symmetry| symmetry.anchors.len()),
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

fn find_symmetry(
    physical_basis: &[Vec<u64>],
    observable_basis: &[Vec<u64>],
    columns: usize,
) -> Option<Symmetry> {
    let physical_pivots = pivot_lookup(physical_basis, columns);
    let observable_pivots = pivot_lookup(observable_basis, columns);
    let mut candidates = Vec::new();

    for step in 1..columns {
        if columns % step != 0 {
            continue;
        }
        let generator = global_shift(columns, step);
        consider_symmetry(
            &mut candidates,
            "global-shift",
            vec![step],
            vec![generator],
            physical_basis,
            &physical_pivots,
            observable_basis,
            &observable_pivots,
            columns,
        );
    }

    for block_size in (2..columns).rev() {
        if columns % block_size != 0 {
            continue;
        }
        for step in 1..block_size {
            if block_size % step != 0 {
                continue;
            }
            let generator = shift_blocks(columns, block_size, step);
            consider_symmetry(
                &mut candidates,
                if step == 1 {
                    "block-cyclic"
                } else {
                    "block-step"
                },
                if step == 1 {
                    vec![block_size]
                } else {
                    vec![block_size, step]
                },
                vec![generator],
                physical_basis,
                &physical_pivots,
                observable_basis,
                &observable_pivots,
                columns,
            );
        }
    }

    if columns % 2 == 0 {
        let block_size = columns / 2;
        for rows in 2..block_size {
            if block_size % rows != 0 {
                continue;
            }
            let cols = block_size / rows;
            if cols < 2 {
                continue;
            }
            let generators = vec![
                torus_shift(columns, rows, cols, true),
                torus_shift(columns, rows, cols, false),
            ];
            consider_symmetry(
                &mut candidates,
                "two-block-torus",
                vec![rows, cols],
                generators,
                physical_basis,
                &physical_pivots,
                observable_basis,
                &observable_pivots,
                columns,
            );
        }
    }
    combine_symmetries(candidates, columns)
}

#[allow(clippy::too_many_arguments)]
fn consider_symmetry(
    candidates: &mut Vec<Symmetry>,
    kind: &'static str,
    parameters: Vec<usize>,
    generators: Vec<Vec<u16>>,
    physical_basis: &[Vec<u64>],
    physical_pivots: &[Option<&[u64]>],
    observable_basis: &[Vec<u64>],
    observable_pivots: &[Option<&[u64]>],
    columns: usize,
) {
    if !generators.iter().all(|generator| {
        permutation_preserves_space(physical_basis, physical_pivots, generator, columns)
            && permutation_preserves_space(observable_basis, observable_pivots, generator, columns)
    }) {
        return;
    }
    if candidates.iter().any(|candidate| {
        candidate.generators.len() == generators.len()
            && candidate
                .generators
                .iter()
                .zip(&generators)
                .all(|(left, right)| left == right)
    }) {
        return;
    }
    candidates.push(Symmetry {
        kind,
        parameters,
        anchors: orbit_anchors(&generators, columns),
        generators,
    });
}

fn combine_symmetries(mut candidates: Vec<Symmetry>, columns: usize) -> Option<Symmetry> {
    let mut generators = Vec::new();
    let mut selected = Vec::new();
    let mut orbit_count = columns;
    loop {
        let best = candidates
            .iter()
            .enumerate()
            .filter_map(|(index, candidate)| {
                let mut combined = generators.clone();
                combined.extend(candidate.generators.iter().cloned());
                let count = orbit_anchors(&combined, columns).len();
                (count < orbit_count).then_some((
                    count,
                    candidate.generators.len(),
                    candidate.kind,
                    candidate.parameters.as_slice(),
                    index,
                ))
            })
            .min();
        let Some((next_count, _, _, _, index)) = best else {
            break;
        };
        let candidate = candidates.swap_remove(index);
        orbit_count = next_count;
        generators.extend(candidate.generators.iter().cloned());
        selected.push(candidate);
    }
    if generators.is_empty() {
        return None;
    }
    let (kind, parameters) = if selected.len() == 1 {
        (selected[0].kind, selected[0].parameters.clone())
    } else {
        ("combined-generated-action", vec![selected.len()])
    };
    Some(Symmetry {
        kind,
        parameters,
        anchors: orbit_anchors(&generators, columns),
        generators,
    })
}

fn pivot_lookup<'a>(basis: &'a [Vec<u64>], columns: usize) -> Vec<Option<&'a [u64]>> {
    let mut pivots: Vec<Option<&'a [u64]>> = vec![None; columns];
    for row in basis {
        if let Some(pivot) = highest_set_bit(row) {
            pivots[pivot] = Some(row.as_slice());
        }
    }
    pivots
}

fn permutation_preserves_space(
    basis: &[Vec<u64>],
    pivots: &[Option<&[u64]>],
    permutation: &[u16],
    columns: usize,
) -> bool {
    let mut scratch = vec![0_u64; columns.div_ceil(64)];
    for row in basis {
        scratch.fill(0);
        permute_row_into(row, permutation, &mut scratch);
        loop {
            let Some(pivot) = highest_set_bit(&scratch) else {
                break;
            };
            let Some(prior) = pivots[pivot] else {
                return false;
            };
            xor_assign(&mut scratch, prior);
        }
    }
    true
}

fn permute_row_into(row: &[u64], permutation: &[u16], output: &mut [u64]) {
    for (word_index, &word) in row.iter().enumerate() {
        let mut remaining = word;
        while remaining != 0 {
            let bit = remaining.trailing_zeros() as usize;
            remaining &= remaining - 1;
            let source = word_index * 64 + bit;
            if source >= permutation.len() {
                continue;
            }
            let target = usize::from(permutation[source]);
            output[target / 64] |= 1_u64 << (target % 64);
        }
    }
}

fn global_shift(columns: usize, step: usize) -> Vec<u16> {
    (0..columns)
        .map(|coordinate| ((coordinate + step) % columns) as u16)
        .collect()
}

fn shift_blocks(columns: usize, block_size: usize, step: usize) -> Vec<u16> {
    (0..columns)
        .map(|coordinate| {
            let block = coordinate / block_size;
            let offset = coordinate % block_size;
            (block * block_size + (offset + step) % block_size) as u16
        })
        .collect()
}

fn torus_shift(columns: usize, rows: usize, cols: usize, row_axis: bool) -> Vec<u16> {
    let block_size = rows * cols;
    debug_assert_eq!(columns, 2 * block_size);
    (0..columns)
        .map(|coordinate| {
            let block = coordinate / block_size;
            let offset = coordinate % block_size;
            let mut row = offset / cols;
            let mut col = offset % cols;
            if row_axis {
                row = (row + 1) % rows;
            } else {
                col = (col + 1) % cols;
            }
            (block * block_size + row * cols + col) as u16
        })
        .collect()
}

fn orbit_anchors(generators: &[Vec<u16>], columns: usize) -> Vec<u16> {
    let mut parent = (0..columns).collect::<Vec<_>>();
    for generator in generators {
        for (source, &target) in generator.iter().enumerate() {
            union(&mut parent, source, usize::from(target));
        }
    }
    let mut seen = vec![false; columns];
    let mut anchors = Vec::new();
    for coordinate in 0..columns {
        let root = find_root(&mut parent, coordinate);
        if !seen[root] {
            seen[root] = true;
            anchors.push(coordinate as u16);
        }
    }
    anchors
}

fn find_root(parent: &mut [usize], mut node: usize) -> usize {
    let mut root = node;
    while parent[root] != root {
        root = parent[root];
    }
    while parent[node] != node {
        let next = parent[node];
        parent[node] = root;
        node = next;
    }
    root
}

fn union(parent: &mut [usize], left: usize, right: usize) {
    let left = find_root(parent, left);
    let right = find_root(parent, right);
    if left != right {
        parent[right] = left;
    }
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

    #[test]
    fn discovers_and_materializes_a_verified_block_action() {
        let physical = Vec::new();
        let observable = vec![vec![0b0000_1111]];
        let symmetry = find_symmetry(&physical, &observable, 8).unwrap();
        assert_eq!(symmetry.kind, "block-cyclic");
        assert_eq!(symmetry.parameters, [4]);
        assert_eq!(symmetry.anchors, [0, 4]);
        assert_eq!(orbit_anchors(&symmetry.generators, 8), [0, 4]);

        let pivots = pivot_lookup(&observable, 8);
        assert!(permutation_preserves_space(
            &observable,
            &pivots,
            &symmetry.generators[0],
            8
        ));
        assert!(!permutation_preserves_space(
            &observable,
            &pivots,
            &global_shift(8, 1),
            8
        ));
    }

    #[test]
    fn combines_individually_verified_generators_when_orbits_sharpen() {
        let pair_flip = shift_blocks(10, 2, 1);
        let parity_cycle = shift_blocks(10, 10, 2);
        let symmetry = combine_symmetries(
            vec![
                Symmetry {
                    kind: "pair-flip",
                    parameters: Vec::new(),
                    anchors: orbit_anchors(std::slice::from_ref(&pair_flip), 10),
                    generators: vec![pair_flip],
                },
                Symmetry {
                    kind: "parity-cycle",
                    parameters: Vec::new(),
                    anchors: orbit_anchors(std::slice::from_ref(&parity_cycle), 10),
                    generators: vec![parity_cycle],
                },
            ],
            10,
        )
        .unwrap();
        assert_eq!(symmetry.kind, "combined-generated-action");
        assert_eq!(symmetry.generators.len(), 2);
        assert_eq!(symmetry.anchors, [0]);
    }

    #[test]
    fn import_preserves_the_sparse_physical_presentation() {
        let hx = Matrix {
            columns: 4,
            rows: vec![vec![0b0011], vec![0b0011]],
        };
        let hz = Matrix {
            columns: 4,
            rows: vec![vec![0b1100]],
        };
        let gx = Matrix {
            columns: 4,
            rows: vec![vec![0b0100]],
        };
        let gz = Matrix {
            columns: 4,
            rows: vec![vec![0b0001], vec![0b1100]],
        };
        let null = Path::new("/dev/null");
        let problem = compile_problem(
            "dependent-check-control".to_owned(),
            Direction::Z,
            2,
            "0".repeat(40),
            false,
            [null; 4],
            [&hx, &hz, &gx, &gz],
        )
        .unwrap();
        assert_eq!(problem.physical_checks, [vec![0, 1], vec![0, 1]]);
        assert_eq!(problem.metadata.hx_rows, 2);
        assert_eq!(problem.metadata.hx_rank, 1);
    }
}
