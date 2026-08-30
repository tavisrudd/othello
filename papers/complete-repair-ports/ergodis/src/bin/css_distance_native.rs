use anyhow::{bail, Context, Result};
use clap::Parser;
#[cfg(feature = "large-css")]
use ergodis::{CompiledColossalCssDistance, CompiledHugeCssDistance, CompiledLargeCssDistance};
use ergodis::{CompiledCssDistance, CompiledExtraWideCssDistance, CompiledWideCssDistance, Matrix};
use serde::{Deserialize, Serialize};
use std::fmt::Write as _;
use std::fs::{File, OpenOptions};
use std::io::{BufReader, BufWriter, Write};
use std::path::PathBuf;
#[cfg(feature = "parallel")]
use std::sync::atomic::{AtomicBool, Ordering};
#[cfg(feature = "parallel")]
use std::sync::Arc;
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
    /// Pin Rayon workers, in worker-index order, to these comma-separated Linux CPU IDs.
    #[arg(long, value_delimiter = ',')]
    worker_cpus: Vec<usize>,
    /// Worker-local bound mailbox polling interval; zero disables mid-branch polling.
    #[arg(long, default_value_t = 4096)]
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
    search_kernel: &'static str,
    threads: usize,
    worker_cpus: &'a [usize],
    pulse_interval: u64,
    search_seconds: &'a [f64],
    round_stats: &'a [ergodis::ConnectedSearchStats],
    result: &'a ergodis::BoundedCssDistanceResult,
}

enum Backend {
    Compact(CompiledCssDistance),
    Wide(CompiledWideCssDistance),
    ExtraWide(CompiledExtraWideCssDistance),
    #[cfg(feature = "large-css")]
    Large(CompiledLargeCssDistance),
    #[cfg(feature = "large-css")]
    Huge(CompiledHugeCssDistance),
    #[cfg(feature = "large-css")]
    Colossal(CompiledColossalCssDistance),
}

fn search_kernel(wide: bool) -> &'static str {
    if !wide {
        return "portable-compact";
    }
    #[cfg(target_arch = "x86_64")]
    if std::arch::is_x86_feature_detected!("avx")
        && std::arch::is_x86_feature_detected!("avx2")
        && std::arch::is_x86_feature_detected!("bmi1")
        && std::arch::is_x86_feature_detected!("bmi2")
        && std::arch::is_x86_feature_detected!("lzcnt")
        && std::arch::is_x86_feature_detected!("popcnt")
    {
        return "x86-64-avx2-bmi-popcnt";
    }
    "portable-wide"
}

#[cfg(all(feature = "parallel", target_os = "linux"))]
fn pin_current_thread(cpu: usize) -> bool {
    let mut set = unsafe { std::mem::zeroed::<libc::cpu_set_t>() };
    unsafe {
        libc::CPU_ZERO(&mut set);
        libc::CPU_SET(cpu, &mut set);
        libc::sched_setaffinity(
            0,
            std::mem::size_of::<libc::cpu_set_t>(),
            std::ptr::addr_of!(set),
        ) == 0
    }
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

fn binary_rank(rows: &[Vec<u16>], columns: usize) -> usize {
    let word_count = columns.div_ceil(64);
    let mut pivots: Vec<Option<Box<[u64]>>> = vec![None; columns];
    let mut rank = 0usize;
    for row in rows {
        let mut words = vec![0u64; word_count];
        for &coordinate in row {
            let coordinate = usize::from(coordinate);
            words[coordinate / 64] ^= 1u64 << (coordinate % 64);
        }
        while let Some(pivot) = words
            .iter()
            .rposition(|&word| word != 0)
            .map(|word| 64 * word + 63 - words[word].leading_zeros() as usize)
        {
            let Some(prior) = &pivots[pivot] else {
                pivots[pivot] = Some(words.into_boxed_slice());
                rank += 1;
                break;
            };
            for (left, &right) in words.iter_mut().zip(prior.iter()) {
                *left ^= right;
            }
        }
    }
    rank
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
    let physical_rank = binary_rank(&problem.physical_checks, columns);
    let wide_problem = columns > 256 || physical_rank > 128;
    let colossal_problem = columns > 1536 || physical_rank > 704;
    let huge_problem =
        !colossal_problem && (columns > 832 || physical_rank > 384 || logical.rows() > 64);
    let large_problem =
        !colossal_problem && !huge_problem && (columns > 384 || physical_rank > 192);
    let extra_wide_problem = !large_problem && columns > 320;
    let preparation_start = Instant::now();
    let (compiled, preparation_mode) = if let Some(path) = &args.compiled_in {
        let file = File::open(path)
            .with_context(|| format!("opening compiled artifact {}", path.display()))?;
        if colossal_problem {
            #[cfg(feature = "large-css")]
            {
                (
                    Backend::Colossal(CompiledColossalCssDistance::read_artifact(
                        &physical,
                        &logical,
                        BufReader::new(file),
                    )?),
                    "colossal-artifact-load",
                )
            }
            #[cfg(not(feature = "large-css"))]
            {
                bail!("colossal CSS instances require --features large-css")
            }
        } else if huge_problem {
            #[cfg(feature = "large-css")]
            {
                (
                    Backend::Huge(CompiledHugeCssDistance::read_artifact(
                        &physical,
                        &logical,
                        BufReader::new(file),
                    )?),
                    "huge-artifact-load",
                )
            }
            #[cfg(not(feature = "large-css"))]
            {
                bail!("huge CSS instances require --features large-css")
            }
        } else if large_problem {
            #[cfg(feature = "large-css")]
            {
                (
                    Backend::Large(CompiledLargeCssDistance::read_artifact(
                        &physical,
                        &logical,
                        BufReader::new(file),
                    )?),
                    "large-artifact-load",
                )
            }
            #[cfg(not(feature = "large-css"))]
            {
                bail!("instances above 384 coordinates or rank 192 require --features large-css")
            }
        } else if extra_wide_problem {
            (
                Backend::ExtraWide(CompiledExtraWideCssDistance::read_artifact(
                    &physical,
                    &logical,
                    BufReader::new(file),
                )?),
                "extra-wide-artifact-load",
            )
        } else if wide_problem {
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
    } else if colossal_problem {
        #[cfg(feature = "large-css")]
        {
            (
                Backend::Colossal(CompiledColossalCssDistance::compile(&physical, &logical)?),
                "colossal-compile",
            )
        }
        #[cfg(not(feature = "large-css"))]
        {
            bail!("colossal CSS instances require --features large-css")
        }
    } else if huge_problem {
        #[cfg(feature = "large-css")]
        {
            (
                Backend::Huge(CompiledHugeCssDistance::compile(&physical, &logical)?),
                "huge-compile",
            )
        }
        #[cfg(not(feature = "large-css"))]
        {
            bail!("huge CSS instances require --features large-css")
        }
    } else if large_problem {
        #[cfg(feature = "large-css")]
        {
            (
                Backend::Large(CompiledLargeCssDistance::compile(&physical, &logical)?),
                "large-compile",
            )
        }
        #[cfg(not(feature = "large-css"))]
        {
            bail!("instances above 384 coordinates or rank 192 require --features large-css")
        }
    } else if extra_wide_problem {
        (
            Backend::ExtraWide(CompiledExtraWideCssDistance::compile(&physical, &logical)?),
            "extra-wide-compile",
        )
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
            Backend::ExtraWide(compiled) => compiled.write_artifact(BufWriter::new(file))?,
            #[cfg(feature = "large-css")]
            Backend::Large(compiled) => compiled.write_artifact(BufWriter::new(file))?,
            #[cfg(feature = "large-css")]
            Backend::Huge(compiled) => compiled.write_artifact(BufWriter::new(file))?,
            #[cfg(feature = "large-css")]
            Backend::Colossal(compiled) => compiled.write_artifact(BufWriter::new(file))?,
        }
        Some(start.elapsed().as_secs_f64())
    } else {
        None
    };
    let artifact_payload_blake3 = match &compiled {
        Backend::Compact(compiled) => compiled.artifact_payload_blake3(),
        Backend::Wide(compiled) => compiled.artifact_payload_blake3(),
        Backend::ExtraWide(compiled) => compiled.artifact_payload_blake3(),
        #[cfg(feature = "large-css")]
        Backend::Large(compiled) => compiled.artifact_payload_blake3(),
        #[cfg(feature = "large-css")]
        Backend::Huge(compiled) => compiled.artifact_payload_blake3(),
        #[cfg(feature = "large-css")]
        Backend::Colossal(compiled) => compiled.artifact_payload_blake3(),
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
    let thread_pool = {
        if !args.worker_cpus.is_empty() && args.worker_cpus.len() != args.threads {
            bail!(
                "worker CPU count {} does not match thread count {}",
                args.worker_cpus.len(),
                args.threads
            );
        }
        #[cfg(not(target_os = "linux"))]
        if !args.worker_cpus.is_empty() {
            bail!("worker CPU affinity is currently supported only on Linux");
        }
        let mut builder = rayon::ThreadPoolBuilder::new().num_threads(args.threads);
        #[cfg(target_os = "linux")]
        let affinity_failed = Arc::new(AtomicBool::new(false));
        #[cfg(target_os = "linux")]
        if !args.worker_cpus.is_empty() {
            if args
                .worker_cpus
                .iter()
                .any(|&cpu| cpu >= libc::CPU_SETSIZE as usize)
            {
                bail!("worker CPU ID exceeds the Linux cpu_set_t capacity");
            }
            let mut unique_cpus = args.worker_cpus.clone();
            unique_cpus.sort_unstable();
            if unique_cpus.windows(2).any(|pair| pair[0] == pair[1]) {
                bail!("worker CPU IDs must be unique");
            }
            let worker_cpus = Arc::new(args.worker_cpus.clone());
            let failed = Arc::clone(&affinity_failed);
            builder = builder.start_handler(move |worker| {
                if !pin_current_thread(worker_cpus[worker]) {
                    failed.store(true, Ordering::Relaxed);
                }
            });
        }
        let pool = builder.build()?;
        #[cfg(target_os = "linux")]
        if !args.worker_cpus.is_empty() {
            pool.broadcast(|_| ());
            if affinity_failed.load(Ordering::Relaxed) {
                bail!("failed to pin one or more Rayon workers");
            }
        }
        pool
    };
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
            Backend::ExtraWide(compiled) => thread_pool.install(|| {
                compiled.search_bounded_syndrome_parallel_pulsed(
                    &problem.anchors,
                    maximum_weight,
                    args.pulse_interval,
                )
            })?,
            #[cfg(feature = "large-css")]
            Backend::Large(compiled) => thread_pool.install(|| {
                compiled.search_bounded_syndrome_parallel_pulsed(
                    &problem.anchors,
                    maximum_weight,
                    args.pulse_interval,
                )
            })?,
            #[cfg(feature = "large-css")]
            Backend::Huge(compiled) => thread_pool.install(|| {
                compiled.search_bounded_syndrome_parallel_pulsed(
                    &problem.anchors,
                    maximum_weight,
                    args.pulse_interval,
                )
            })?,
            #[cfg(feature = "large-css")]
            Backend::Colossal(compiled) => thread_pool.install(|| {
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
            Backend::ExtraWide(compiled) => {
                compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
            }
            #[cfg(feature = "large-css")]
            Backend::Large(compiled) => {
                compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
            }
            #[cfg(feature = "large-css")]
            Backend::Huge(compiled) => {
                compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
            }
            #[cfg(feature = "large-css")]
            Backend::Colossal(compiled) => {
                compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
            }
        };
        search_seconds.push(search_start.elapsed().as_secs_f64());
        round_stats.push(round_result.stats);
        if let Some(reference) = &result {
            if reference.distance != round_result.distance
                || reference.searched_maximum_weight != round_result.searched_maximum_weight
            {
                bail!("native search returned different exact optima across rounds");
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
        search_kernel: search_kernel(wide_problem),
        threads: args.threads,
        worker_cpus: &args.worker_cpus,
        pulse_interval: args.pulse_interval,
        search_seconds: &search_seconds,
        round_stats: &round_stats,
        result: &result,
    };
    emit(&record, args.evidence.as_ref())
}
