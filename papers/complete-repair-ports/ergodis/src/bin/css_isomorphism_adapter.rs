//! Optional cold adapter from graph-isomorphism proposals to verified CSS equivalences.

use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{verify_css_coordinate_equivalence, Matrix};
use serde::{Deserialize, Serialize};
use std::fs::{File, OpenOptions};
use std::io::{BufReader, BufWriter, Read, Write};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

const PROPOSAL_SCHEMA: &str = "ergodis-css-isomorphism-proposal-v1";
const ADMISSION_SCHEMA: &str = "ergodis-css-isomorphism-admission-v1";
const MAX_BACKEND_OUTPUT_BYTES: u64 = 16 * 1024 * 1024;
const MAX_PROPOSAL_BYTES: u64 = 64 * 1024 * 1024;

#[derive(Debug, Parser)]
#[command(about = "Admit an optional CSS isomorphism proposal through exact Ergodis checks")]
struct Args {
    #[arg(long)]
    source: PathBuf,
    #[arg(long)]
    target: PathBuf,
    /// Create an exact admission record; existing files are never overwritten.
    #[arg(long)]
    output: PathBuf,
    /// Read a backend-neutral proposal instead of invoking nauty.
    #[arg(long)]
    proposal_in: Option<PathBuf>,
    /// Retain the bounded backend-neutral proposal before admission.
    #[arg(long)]
    proposal_out: Option<PathBuf>,
    /// Optional nauty `dreadnaut` executable used only when no proposal is supplied.
    #[arg(long, default_value = "dreadnaut")]
    nauty: PathBuf,
}

#[derive(Debug, Deserialize)]
struct SparseProblem {
    coordinate_count: u16,
    physical_checks: Vec<Vec<u16>>,
    logical_observations: Vec<Vec<u16>>,
}

#[derive(Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
struct IsomorphismProposal {
    schema: String,
    backend: String,
    source_blake3: String,
    target_blake3: String,
    coordinate_count: u16,
    physical_vertices: usize,
    coordinate_images: Vec<u16>,
}

#[derive(Debug, Serialize)]
struct AdmissionRecord {
    schema: &'static str,
    backend: String,
    source_blake3: String,
    target_blake3: String,
    coordinate_count: u32,
    physical_rank: u32,
    observable_rank: u32,
    coordinate_images: Vec<u16>,
    verifier: &'static str,
}

fn dense_matrix(rows: &[Vec<u16>], columns: usize) -> Result<Matrix> {
    let mut data = vec![0_u8; rows.len().saturating_mul(columns)];
    for (row_index, row) in rows.iter().enumerate() {
        for &coordinate in row {
            let coordinate = usize::from(coordinate);
            if coordinate >= columns {
                bail!("coordinate {coordinate} is outside a {columns}-column matrix");
            }
            let entry = &mut data[row_index * columns + coordinate];
            if *entry != 0 {
                bail!("row {row_index} repeats coordinate {coordinate}");
            }
            *entry = 1;
        }
    }
    Matrix::new::<2>(rows.len(), columns, data).context("constructing binary matrix")
}

fn write_tanner_graph(
    mut writer: impl Write,
    physical: &[Vec<u16>],
    coordinates: usize,
    include_header: bool,
) -> Result<()> {
    let checks = physical.len();
    if checks == 0 || coordinates == 0 {
        bail!("nauty proposal requires nonempty check and coordinate partitions");
    }
    let vertices = checks
        .checked_add(coordinates)
        .context("Tanner graph vertex count overflow")?;
    if include_header {
        writeln!(writer, "As n={vertices} g")?;
    } else {
        writeln!(writer, "g")?;
    }
    for (check, row) in physical.iter().enumerate() {
        write!(writer, "{check}:")?;
        for &coordinate in row {
            let coordinate = usize::from(coordinate);
            if coordinate >= coordinates {
                bail!("physical coordinate {coordinate} is out of range");
            }
            write!(writer, " {}", checks + coordinate)?;
        }
        writeln!(writer, ";")?;
    }
    writeln!(writer, ".")?;
    writeln!(writer, "f=[0:{}|{}:{}]", checks - 1, checks, vertices - 1)?;
    Ok(())
}

fn write_dreadnaut_problem(
    mut writer: impl Write,
    source: &SparseProblem,
    target: &SparseProblem,
) -> Result<()> {
    let coordinates = usize::from(source.coordinate_count);
    write_tanner_graph(&mut writer, &source.physical_checks, coordinates, true)?;
    writeln!(writer, "+c x @")?;
    write_tanner_graph(&mut writer, &target.physical_checks, coordinates, false)?;
    writeln!(writer, "+c x ##")?;
    writeln!(writer, "q")?;
    writer.flush()?;
    Ok(())
}

fn parse_dreadnaut_isomorphism(output: &[u8], vertices: usize) -> Result<Vec<usize>> {
    const MARKER: &str = "h and h' are identical.";
    let text = std::str::from_utf8(output).context("nauty output is not UTF-8")?;
    let (_, mapping_text) = text
        .split_once(MARKER)
        .context("nauty did not report the two coloured graphs as identical")?;
    let mut images = vec![usize::MAX; vertices];
    let mut mapped = 0_usize;
    for token in mapping_text.split_ascii_whitespace() {
        let Some((left, right)) = token.split_once('-') else {
            continue;
        };
        let Ok(left) = left.parse::<usize>() else {
            continue;
        };
        let right = right
            .parse::<usize>()
            .with_context(|| format!("malformed nauty image {token}"))?;
        if left >= vertices || right >= vertices || images[left] != usize::MAX {
            bail!("nauty returned an invalid or duplicate vertex image");
        }
        images[left] = right;
        mapped += 1;
    }
    if mapped != vertices || images.contains(&usize::MAX) {
        bail!("nauty returned {mapped} vertex images, expected {vertices}");
    }
    Ok(images)
}

fn coordinate_images(full: &[usize], checks: usize, coordinates: usize) -> Result<Vec<u16>> {
    let vertices = checks
        .checked_add(coordinates)
        .context("Tanner graph vertex count overflow")?;
    if full.len() != vertices
        || full[..checks].iter().any(|&image| image >= checks)
        || full[checks..]
            .iter()
            .any(|&image| image < checks || image >= vertices)
    {
        bail!("isomorphism crosses the Tanner colour partition");
    }
    full[checks..]
        .iter()
        .map(|&image| u16::try_from(image - checks).context("coordinate image exceeds u16"))
        .collect()
}

fn propose_with_nauty(
    source: &SparseProblem,
    target: &SparseProblem,
    source_blake3: &str,
    target_blake3: &str,
    executable: &Path,
) -> Result<IsomorphismProposal> {
    if source.coordinate_count != target.coordinate_count
        || source.physical_checks.len() != target.physical_checks.len()
    {
        bail!("nauty requires matching Tanner colour-partition sizes");
    }
    let coordinates = usize::from(source.coordinate_count);
    let checks = source.physical_checks.len();
    let vertices = checks
        .checked_add(coordinates)
        .context("Tanner graph vertex count overflow")?;
    let mut child = Command::new(executable)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::inherit())
        .spawn()
        .with_context(|| format!("launching optional backend {}", executable.display()))?;
    {
        let stdin = child.stdin.take().context("opening nauty stdin")?;
        write_dreadnaut_problem(BufWriter::new(stdin), source, target)?;
    }
    let mut bytes = Vec::new();
    child
        .stdout
        .take()
        .context("opening nauty stdout")?
        .take(MAX_BACKEND_OUTPUT_BYTES + 1)
        .read_to_end(&mut bytes)?;
    if bytes.len() as u64 > MAX_BACKEND_OUTPUT_BYTES {
        child.kill().ok();
        child.wait().ok();
        bail!("nauty output exceeds the byte limit");
    }
    let status = child.wait()?;
    if !status.success() {
        bail!("nauty exited with {status}");
    }
    let full = parse_dreadnaut_isomorphism(&bytes, vertices)?;
    Ok(IsomorphismProposal {
        schema: PROPOSAL_SCHEMA.to_owned(),
        backend: "nauty-dreadnaut-coloured-tanner-v1".to_owned(),
        source_blake3: source_blake3.to_owned(),
        target_blake3: target_blake3.to_owned(),
        coordinate_count: source.coordinate_count,
        physical_vertices: checks,
        coordinate_images: coordinate_images(&full, checks, coordinates)?,
    })
}

fn blake3_file(path: &Path) -> Result<String> {
    let mut file = File::open(path).with_context(|| format!("opening {}", path.display()))?;
    let mut hasher = blake3::Hasher::new();
    let mut buffer = [0_u8; 64 * 1024];
    loop {
        let read = file.read(&mut buffer)?;
        if read == 0 {
            break;
        }
        hasher.update(&buffer[..read]);
    }
    Ok(hasher.finalize().to_hex().to_string())
}

fn read_problem(path: &Path) -> Result<SparseProblem> {
    serde_json::from_reader(BufReader::new(
        File::open(path).with_context(|| format!("opening {}", path.display()))?,
    ))
    .with_context(|| format!("parsing sparse CSS problem {}", path.display()))
}

fn read_proposal(path: &Path) -> Result<IsomorphismProposal> {
    let file = File::open(path).with_context(|| format!("opening proposal {}", path.display()))?;
    let mut bytes = Vec::new();
    file.take(MAX_PROPOSAL_BYTES + 1).read_to_end(&mut bytes)?;
    if bytes.len() as u64 > MAX_PROPOSAL_BYTES {
        bail!("isomorphism proposal exceeds the byte limit");
    }
    serde_json::from_slice(&bytes).context("parsing isomorphism proposal")
}

fn write_create_new(path: &Path, value: &impl Serialize) -> Result<()> {
    let file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(path)
        .with_context(|| format!("creating {}", path.display()))?;
    let mut writer = BufWriter::new(file);
    serde_json::to_writer(&mut writer, value)?;
    writer.write_all(b"\n")?;
    writer.flush()?;
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    let source_blake3 = blake3_file(&args.source)?;
    let target_blake3 = blake3_file(&args.target)?;
    let source = read_problem(&args.source)?;
    let target = read_problem(&args.target)?;
    let coordinates = usize::from(source.coordinate_count);
    if target.coordinate_count != source.coordinate_count {
        bail!("source and target coordinate counts differ");
    }
    let source_physical = dense_matrix(&source.physical_checks, coordinates)?;
    let source_logical = dense_matrix(&source.logical_observations, coordinates)?;
    let target_physical = dense_matrix(&target.physical_checks, coordinates)?;
    let target_logical = dense_matrix(&target.logical_observations, coordinates)?;

    let proposal = if let Some(path) = &args.proposal_in {
        read_proposal(path)?
    } else {
        propose_with_nauty(
            &source,
            &target,
            &source_blake3,
            &target_blake3,
            &args.nauty,
        )?
    };
    if proposal.schema != PROPOSAL_SCHEMA
        || proposal.source_blake3 != source_blake3
        || proposal.target_blake3 != target_blake3
        || proposal.coordinate_count != source.coordinate_count
        || proposal.physical_vertices != source.physical_checks.len()
        || proposal.coordinate_images.len() != coordinates
        || proposal.backend.len() > 256
    {
        bail!("isomorphism proposal is incompatible with the CSS inputs");
    }
    if let Some(path) = &args.proposal_out {
        write_create_new(path, &proposal)?;
    }

    let certificate = verify_css_coordinate_equivalence(
        &source_physical,
        &source_logical,
        &target_physical,
        &target_logical,
        proposal
            .coordinate_images
            .iter()
            .map(|&image| u32::from(image))
            .collect::<Vec<_>>(),
    )
    .context("exactly admitting the coordinate equivalence")?;
    write_create_new(
        &args.output,
        &AdmissionRecord {
            schema: ADMISSION_SCHEMA,
            backend: proposal.backend,
            source_blake3,
            target_blake3,
            coordinate_count: certificate.coordinate_count(),
            physical_rank: certificate.physical_rank(),
            observable_rank: certificate.observable_rank(),
            coordinate_images: proposal.coordinate_images,
            verifier: "exact-physical-and-observable-row-spaces",
        },
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_complete_mapping_and_extracts_coordinate_colour() {
        let output = b"noise\nh and h' are identical.\n0-1 1-0 2-3 3-2\n";
        let full = parse_dreadnaut_isomorphism(output, 4).unwrap();
        assert_eq!(full, [1, 0, 3, 2]);
        assert_eq!(coordinate_images(&full, 2, 2).unwrap(), [1, 0]);
    }

    #[test]
    fn rejects_incomplete_and_partition_crossing_mappings() {
        assert!(parse_dreadnaut_isomorphism(b"not identical\n", 4).is_err());
        assert!(parse_dreadnaut_isomorphism(b"h and h' are identical.\n0-0 1-1 2-2\n", 4).is_err());
        assert!(coordinate_images(&[2, 1, 0, 3], 2, 2).is_err());
    }
}
