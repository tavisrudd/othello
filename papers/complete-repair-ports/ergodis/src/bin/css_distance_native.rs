use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{CompiledCssDistance, CompiledWideCssDistance, Matrix};
use serde::{Deserialize, Serialize};
use std::fmt::Write as _;
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
    /// Load a source-bound compiled filter artifact instead of rebuilding it.
    #[arg(long, conflicts_with = "compiled_out")]
    compiled_in: Option<PathBuf>,
    /// Create a compiled filter artifact. Existing files are never overwritten.
    #[arg(long, conflicts_with = "compiled_in")]
    compiled_out: Option<PathBuf>,
    #[arg(long, default_value_t = 1)]
    rounds: u16,
    /// Static anchor-search worker count (requires the `parallel` feature above one).
    #[arg(long, default_value_t = 1)]
    threads: usize,
    /// Worker-local bound mailbox polling interval; zero disables mid-branch polling.
    #[arg(long, default_value_t = 16384)]
    pulse_interval: u64,
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
    preparation_mode: &'static str,
    preparation_seconds: f64,
    artifact_write_seconds: Option<f64>,
    artifact_payload_blake3: Option<String>,
    threads: usize,
    pulse_interval: u64,
    search_seconds: &'a [f64],
    round_stats: &'a [ergodis::ConnectedSearchStats],
    result: &'a ergodis::BoundedCssDistanceResult,
}

enum Backend {
    Compact(CompiledCssDistance),
    Wide(CompiledWideCssDistance),
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
    let wide_problem = columns > 256 || physical.rows() > 128;
    let preparation_start = Instant::now();
    let (compiled, preparation_mode) = if let Some(path) = &args.compiled_in {
        let file = File::open(path)
            .with_context(|| format!("opening compiled artifact {}", path.display()))?;
        if wide_problem {
            (
                Backend::Wide(CompiledWideCssDistance::read_artifact(
                    &physical,
                    &logical,
                    BufReader::new(file),
                )?),
                "wide-artifact-load",
            )
        } else {
            (
                Backend::Compact(CompiledCssDistance::read_artifact(
                    &physical,
                    &logical,
                    BufReader::new(file),
                )?),
                "artifact-load",
            )
        }
    } else if wide_problem {
        (
            Backend::Wide(CompiledWideCssDistance::compile(&physical, &logical)?),
            "wide-compile",
        )
    } else {
        (
            Backend::Compact(CompiledCssDistance::compile(&physical, &logical)?),
            "compile",
        )
    };
    let preparation_seconds = preparation_start.elapsed().as_secs_f64();
    let artifact_write_seconds = if let Some(path) = &args.compiled_out {
        let start = Instant::now();
        let file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(path)
            .with_context(|| format!("creating compiled artifact {}", path.display()))?;
        match &compiled {
            Backend::Compact(compiled) => compiled.write_artifact(BufWriter::new(file))?,
            Backend::Wide(compiled) => compiled.write_artifact(BufWriter::new(file))?,
        }
        Some(start.elapsed().as_secs_f64())
    } else {
        None
    };
    let artifact_payload_blake3 = match &compiled {
        Backend::Compact(compiled) => compiled.artifact_payload_blake3(),
        Backend::Wide(compiled) => compiled.artifact_payload_blake3(),
    }
    .map(|digest| {
        let mut encoded = String::with_capacity(64);
        for byte in digest {
            write!(&mut encoded, "{byte:02x}").expect("writing to a String cannot fail");
        }
        encoded
    });
    let maximum_weight = args.maximum_weight.unwrap_or(problem.maximum_weight);
    if args.rounds == 0 {
        bail!("round count must be positive");
    }
    if args.threads == 0 {
        bail!("thread count must be positive");
    }
    #[cfg(not(feature = "parallel"))]
    if args.threads != 1 {
        bail!("thread counts above one require the `parallel` feature");
    }
    #[cfg(feature = "parallel")]
    let thread_pool = rayon::ThreadPoolBuilder::new()
        .num_threads(args.threads)
        .build()?;
    let certify_incumbent = args.maximum_weight.is_none() && !problem.incumbent_support.is_empty();
    let mode = if certify_incumbent {
        "certify-incumbent"
    } else {
        "bounded-search"
    };
    let mut search_seconds = Vec::with_capacity(usize::from(args.rounds));
    let mut round_stats = Vec::with_capacity(usize::from(args.rounds));
    let mut result: Option<ergodis::BoundedCssDistanceResult> = None;
    for _ in 0..args.rounds {
        let search_start = Instant::now();
        #[cfg(feature = "parallel")]
        let round_result = match &compiled {
            Backend::Compact(compiled) => thread_pool.install(|| {
                if certify_incumbent {
                    compiled.certify_incumbent_parallel_pulsed(
                        &problem.anchors,
                        &problem.incumbent_support,
                        args.pulse_interval,
                    )
                } else {
                    compiled.search_bounded_parallel_pulsed(
                        &problem.anchors,
                        maximum_weight,
                        args.pulse_interval,
                    )
                }
            })?,
            Backend::Wide(compiled) => thread_pool.install(|| {
                compiled.search_bounded_syndrome_parallel_pulsed(
                    &problem.anchors,
                    maximum_weight,
                    args.pulse_interval,
                )
            })?,
        };
        #[cfg(not(feature = "parallel"))]
        let round_result = match &compiled {
            Backend::Compact(compiled) => {
                if certify_incumbent {
                    compiled.certify_incumbent(&problem.anchors, &problem.incumbent_support)
                } else {
                    compiled.search_bounded(&problem.anchors, maximum_weight)
                }?
            }
            Backend::Wide(compiled) => {
                compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
            }
        };
        search_seconds.push(search_start.elapsed().as_secs_f64());
        round_stats.push(round_result.stats);
        if let Some(reference) = &result {
            if reference.distance != round_result.distance
                || reference.witness != round_result.witness
                || reference.searched_maximum_weight != round_result.searched_maximum_weight
            {
                bail!("native search returned different exact answers across rounds");
            }
        } else {
            result = Some(round_result);
        }
    }
    let result = result.expect("positive round count checked above");
    let record = RunRecord {
        schema: "ergodis-css-distance-native-v3",
        label: &problem.label,
        coordinate_count: problem.coordinate_count,
        physical_checks: problem.physical_checks.len(),
        logical_observations: problem.logical_observations.len(),
        anchors: &problem.anchors,
        maximum_weight,
        mode,
        preparation_mode,
        preparation_seconds,
        artifact_write_seconds,
        artifact_payload_blake3,
        threads: args.threads,
        pulse_interval: args.pulse_interval,
        search_seconds: &search_seconds,
        round_stats: &round_stats,
        result: &result,
    };
    emit(&record, args.evidence.as_ref())
}
