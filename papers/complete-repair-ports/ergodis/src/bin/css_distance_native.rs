use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{CompiledCssDistance, Matrix};
use serde::{Deserialize, Serialize};
use std::fs::{File, OpenOptions};
use std::io::{BufReader, BufWriter, Write};
use std::path::PathBuf;
use std::time::Instant;

#[derive(Debug, Parser)]
#[command(about = "Exact connected-support CSS distance search")]
struct Args {
    #[arg(long)]
    input: PathBuf,
    #[arg(long)]
    maximum_weight: Option<u16>,
    /// Create a JSONL evidence stream. Existing files are never overwritten.
    #[arg(long)]
    evidence: Option<PathBuf>,
    #[arg(long, default_value_t = 1)]
    rounds: u16,
}

#[derive(Debug, Deserialize)]
struct SparseProblem {
    label: String,
    coordinate_count: u16,
    physical_checks: Vec<Vec<u16>>,
    logical_observations: Vec<Vec<u16>>,
    anchors: Vec<u16>,
    maximum_weight: u16,
    #[serde(default)]
    incumbent_support: Vec<u16>,
}

#[derive(Debug, Serialize)]
struct RunRecord<'a> {
    schema: &'static str,
    label: &'a str,
    coordinate_count: u16,
    physical_checks: usize,
    logical_observations: usize,
    anchors: &'a [u16],
    maximum_weight: u16,
    mode: &'static str,
    compile_seconds: f64,
    search_seconds: &'a [f64],
    result: &'a ergodis::BoundedCssDistanceResult,
}

fn dense_matrix(rows: &[Vec<u16>], columns: usize) -> Result<Matrix> {
    let mut data = vec![0u8; rows.len().saturating_mul(columns)];
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

fn emit(record: &RunRecord<'_>, path: Option<&PathBuf>) -> Result<()> {
    serde_json::to_writer(std::io::stdout().lock(), record)?;
    println!();
    if let Some(path) = path {
        let file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(path)
            .with_context(|| format!("creating evidence stream {}", path.display()))?;
        let mut sink = BufWriter::new(file);
        serde_json::to_writer(&mut sink, record)?;
        sink.write_all(b"\n")?;
        sink.flush()?;
    }
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    let file = File::open(&args.input)
        .with_context(|| format!("opening input {}", args.input.display()))?;
    let problem: SparseProblem =
        serde_json::from_reader(BufReader::new(file)).context("parsing sparse CSS problem")?;
    let columns = usize::from(problem.coordinate_count);
    let physical = dense_matrix(&problem.physical_checks, columns)?;
    let logical = dense_matrix(&problem.logical_observations, columns)?;
    let compile_start = Instant::now();
    let compiled = CompiledCssDistance::compile(&physical, &logical)?;
    let compile_seconds = compile_start.elapsed().as_secs_f64();
    let maximum_weight = args.maximum_weight.unwrap_or(problem.maximum_weight);
    if args.rounds == 0 {
        bail!("round count must be positive");
    }
    let certify_incumbent = args.maximum_weight.is_none() && !problem.incumbent_support.is_empty();
    let mode = if certify_incumbent {
        "certify-incumbent"
    } else {
        "bounded-search"
    };
    let mut search_seconds = Vec::with_capacity(usize::from(args.rounds));
    let mut result = None;
    for _ in 0..args.rounds {
        let search_start = Instant::now();
        let round_result = if certify_incumbent {
            compiled.certify_incumbent(&problem.anchors, &problem.incumbent_support)?
        } else {
            compiled.search_bounded(&problem.anchors, maximum_weight)?
        };
        search_seconds.push(search_start.elapsed().as_secs_f64());
        if let Some(reference) = &result {
            if reference != &round_result {
                bail!("native search returned different results across rounds");
            }
        } else {
            result = Some(round_result);
        }
    }
    let result = result.expect("positive round count checked above");
    let record = RunRecord {
        schema: "ergodis-css-distance-native-v1",
        label: &problem.label,
        coordinate_count: problem.coordinate_count,
        physical_checks: problem.physical_checks.len(),
        logical_observations: problem.logical_observations.len(),
        anchors: &problem.anchors,
        maximum_weight,
        mode,
        compile_seconds,
        search_seconds: &search_seconds,
        result: &result,
    };
    emit(&record, args.evidence.as_ref())
}
