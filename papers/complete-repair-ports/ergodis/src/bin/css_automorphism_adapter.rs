//! Optional cold adapter from graph-automorphism proposals to verified CSS actions.

use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{
    compile_permutation_orbits, verify_css_anchor_transversal, ExplicitPermutationAction, Matrix,
};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::fs::{File, OpenOptions};
use std::io::{BufReader, BufWriter, Read, Write};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

const PROPOSAL_SCHEMA: &str = "ergodis-css-automorphism-proposal-v1";
const MAX_BACKEND_OUTPUT_BYTES: u64 = 16 * 1024 * 1024;
const MAX_PROPOSAL_BYTES: u64 = 64 * 1024 * 1024;
const MAX_PROPOSAL_GENERATORS: usize = 4096;

#[derive(Debug, Parser)]
#[command(about = "Admit optional CSS automorphism proposals through exact Ergodis checks")]
struct Args {
    #[arg(long)]
    input: PathBuf,
    /// Create an upgraded Ergodis input; existing files are never overwritten.
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
    #[serde(default)]
    coordinate_generators: Vec<Vec<u16>>,
}

#[derive(Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
struct AutomorphismProposal {
    schema: String,
    backend: String,
    input_blake3: String,
    coordinate_count: u16,
    physical_vertices: usize,
    generators: Vec<Vec<u16>>,
}

#[derive(Debug, Serialize)]
struct AdmissionRecord {
    schema: &'static str,
    backend: String,
    proposed_generators: usize,
    admitted_new_generators: usize,
    retained_generators: usize,
    coordinate_orbits: usize,
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

fn write_dreadnaut_problem(
    mut writer: impl Write,
    physical: &[Vec<u16>],
    coordinates: usize,
) -> Result<()> {
    let checks = physical.len();
    if checks == 0 || coordinates == 0 {
        bail!("nauty proposal requires nonempty check and coordinate partitions");
    }
    let vertices = checks
        .checked_add(coordinates)
        .context("Tanner graph vertex count overflow")?;
    writeln!(writer, "As n={vertices} g")?;
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
    writeln!(writer, "+a +p")?;
    writeln!(writer, "x")?;
    writeln!(writer, "q")?;
    writer.flush()?;
    Ok(())
}

fn parse_dreadnaut_generators(output: &[u8], vertices: usize) -> Result<Vec<Vec<usize>>> {
    let text = std::str::from_utf8(output).context("nauty output is not UTF-8")?;
    let mut generators = Vec::new();
    let mut current = Vec::with_capacity(vertices);
    for line in text.lines() {
        let trimmed = line.trim();
        if trimmed.starts_with("level ") {
            if !current.is_empty() {
                if current.len() != vertices {
                    bail!(
                        "nauty generator has {} images, expected {vertices}",
                        current.len()
                    );
                }
                generators.push(std::mem::take(&mut current));
                current.reserve(vertices);
            }
            continue;
        }
        if trimmed.is_empty() {
            continue;
        }
        let parsed = trimmed
            .split_ascii_whitespace()
            .map(str::parse::<usize>)
            .collect::<std::result::Result<Vec<_>, _>>();
        if let Ok(images) = parsed {
            current.extend(images);
        } else if !current.is_empty() {
            bail!("unexpected text inside a wrapped nauty generator");
        }
    }
    if !current.is_empty() {
        bail!("unterminated nauty generator");
    }
    if generators.len() > MAX_PROPOSAL_GENERATORS {
        bail!("nauty returned too many generators");
    }
    Ok(generators)
}

fn coordinate_generators(
    full_generators: Vec<Vec<usize>>,
    checks: usize,
    coordinates: usize,
) -> Result<Vec<Vec<u16>>> {
    let vertices = checks + coordinates;
    let mut output = Vec::with_capacity(full_generators.len());
    for (generator_index, generator) in full_generators.into_iter().enumerate() {
        if generator.len() != vertices {
            bail!("generator {generator_index} has the wrong vertex count");
        }
        if generator[..checks].iter().any(|&image| image >= checks)
            || generator[checks..]
                .iter()
                .any(|&image| image < checks || image >= vertices)
        {
            bail!("generator {generator_index} crosses the Tanner colour partition");
        }
        let mut images = Vec::with_capacity(coordinates);
        for &image in &generator[checks..] {
            images.push(u16::try_from(image - checks).context("coordinate image exceeds u16")?);
        }
        output.push(images);
    }
    Ok(output)
}

fn propose_with_nauty(
    problem: &SparseProblem,
    input_blake3: &str,
    executable: &Path,
) -> Result<AutomorphismProposal> {
    let coordinates = usize::from(problem.coordinate_count);
    let checks = problem.physical_checks.len();
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
        write_dreadnaut_problem(BufWriter::new(stdin), &problem.physical_checks, coordinates)?;
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
    let full = parse_dreadnaut_generators(&bytes, vertices)?;
    Ok(AutomorphismProposal {
        schema: PROPOSAL_SCHEMA.to_owned(),
        backend: "nauty-dreadnaut-full-tanner-v1".to_owned(),
        input_blake3: input_blake3.to_owned(),
        coordinate_count: problem.coordinate_count,
        physical_vertices: checks,
        generators: coordinate_generators(full, checks, coordinates)?,
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

fn read_proposal(path: &Path) -> Result<AutomorphismProposal> {
    let file = File::open(path).with_context(|| format!("opening proposal {}", path.display()))?;
    let mut bytes = Vec::new();
    file.take(MAX_PROPOSAL_BYTES + 1).read_to_end(&mut bytes)?;
    if bytes.len() as u64 > MAX_PROPOSAL_BYTES {
        bail!("automorphism proposal exceeds the byte limit");
    }
    serde_json::from_slice(&bytes).context("parsing automorphism proposal")
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

fn flattened(generators: &[Vec<u16>], coordinates: usize) -> Result<Vec<u32>> {
    let total = generators
        .len()
        .checked_mul(coordinates)
        .context("generator image count overflow")?;
    if generators.len() > MAX_PROPOSAL_GENERATORS
        || total > MAX_PROPOSAL_GENERATORS.saturating_mul(u16::MAX as usize)
    {
        bail!("automorphism proposal exceeds the generator limit");
    }
    let mut images = Vec::with_capacity(total);
    for (index, generator) in generators.iter().enumerate() {
        if generator.len() != coordinates {
            bail!("coordinate generator {index} has the wrong length");
        }
        images.extend(generator.iter().map(|&image| u32::from(image)));
    }
    Ok(images)
}

fn anchors_for(generators: &[Vec<u16>], coordinates: usize) -> Result<Vec<u16>> {
    let action = ExplicitPermutationAction::new(coordinates, flattened(generators, coordinates)?)?;
    let partition = compile_permutation_orbits(&action)?;
    partition
        .representatives()
        .iter()
        .map(|&representative| u16::try_from(representative).context("anchor exceeds u16"))
        .collect()
}

fn admissible_generator(physical: &Matrix, logical: &Matrix, generator: &[u16]) -> Result<bool> {
    let singleton = vec![generator.to_vec()];
    let anchors = anchors_for(&singleton, physical.cols())?;
    Ok(verify_css_anchor_transversal(
        physical,
        logical,
        flattened(&singleton, physical.cols())?,
        &anchors,
    )
    .is_ok())
}

fn main() -> Result<()> {
    let args = Args::parse();
    let input_blake3 = blake3_file(&args.input)?;
    let problem: SparseProblem = serde_json::from_reader(BufReader::new(
        File::open(&args.input).with_context(|| format!("opening {}", args.input.display()))?,
    ))
    .context("parsing sparse CSS problem")?;
    let mut document: Value = serde_json::from_reader(BufReader::new(File::open(&args.input)?))
        .context("parsing preserved CSS input")?;
    let coordinates = usize::from(problem.coordinate_count);
    let physical = dense_matrix(&problem.physical_checks, coordinates)?;
    let logical = dense_matrix(&problem.logical_observations, coordinates)?;

    let proposal = if let Some(path) = &args.proposal_in {
        read_proposal(path)?
    } else {
        propose_with_nauty(&problem, &input_blake3, &args.nauty)?
    };
    if proposal.schema != PROPOSAL_SCHEMA
        || proposal.input_blake3 != input_blake3
        || proposal.coordinate_count != problem.coordinate_count
        || proposal.physical_vertices != problem.physical_checks.len()
        || proposal.backend.len() > 256
    {
        bail!("automorphism proposal is incompatible with the CSS input");
    }
    if let Some(path) = &args.proposal_out {
        write_create_new(path, &proposal)?;
    }

    let mut retained = problem.coordinate_generators;
    let existing = retained.len();
    let mut anchors = anchors_for(&retained, coordinates)?;
    for generator in &proposal.generators {
        if retained.contains(generator) || !admissible_generator(&physical, &logical, generator)? {
            continue;
        }
        retained.push(generator.clone());
        let next_anchors = anchors_for(&retained, coordinates)?;
        if next_anchors.len() < anchors.len() {
            anchors = next_anchors;
        } else {
            retained.pop();
        }
    }
    verify_css_anchor_transversal(
        &physical,
        &logical,
        flattened(&retained, coordinates)?,
        &anchors,
    )
    .context("admitting combined automorphism proposal")?;

    let object = document
        .as_object_mut()
        .context("CSS input must be a JSON object")?;
    object.insert("anchors".to_owned(), serde_json::to_value(&anchors)?);
    object.insert(
        "coordinate_generators".to_owned(),
        serde_json::to_value(&retained)?,
    );
    object.insert(
        "automorphism_admission".to_owned(),
        serde_json::to_value(AdmissionRecord {
            schema: "ergodis-css-automorphism-admission-v1",
            backend: proposal.backend,
            proposed_generators: proposal.generators.len(),
            admitted_new_generators: retained.len() - existing,
            retained_generators: retained.len(),
            coordinate_orbits: anchors.len(),
            verifier: "exact-physical-and-observable-row-spaces",
        })?,
    );
    write_create_new(&args.output, &document)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_full_image_generators_and_extracts_one_colour() {
        let output = b"[fixing partition]\n 0 1\n 3 2\nlevel 2: test\n 1 0 2 3\nlevel 1: test\n";
        let full = parse_dreadnaut_generators(output, 4).unwrap();
        assert_eq!(full, [vec![0, 1, 3, 2], vec![1, 0, 2, 3]]);
        let coordinates = coordinate_generators(full, 2, 2).unwrap();
        assert_eq!(coordinates, [vec![1, 0], vec![0, 1]]);
    }

    #[test]
    fn rejects_partition_crossing_and_incomplete_backend_output() {
        assert!(coordinate_generators(vec![vec![2, 1, 0, 3]], 2, 2).is_err());
        assert!(parse_dreadnaut_generators(b"0 1\nlevel 1: test\n", 4).is_err());
    }

    #[test]
    fn exact_admission_filters_an_observable_breaking_symmetry() {
        let physical = Matrix::new::<2>(1, 4, vec![1, 1, 1, 1]).unwrap();
        let logical = Matrix::new::<2>(1, 4, vec![1, 0, 1, 0]).unwrap();
        assert!(admissible_generator(&physical, &logical, &[2, 3, 0, 1]).unwrap());
        assert!(!admissible_generator(&physical, &logical, &[1, 0, 2, 3]).unwrap());
    }
}
