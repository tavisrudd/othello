use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{
    verify_css_anchor_transversal, CompiledCssDistance, CompiledExtraWideCssDistance,
    CompiledWideCssDistance, CssSearchShard, Matrix,
};
#[cfg(feature = "large-css")]
use ergodis::{CompiledColossalCssDistance, CompiledHugeCssDistance, CompiledLargeCssDistance};
use serde::{Deserialize, Serialize};
use std::fmt::Write as _;
use std::fs::{File, OpenOptions};
use std::io::{BufReader, BufWriter, Read, Write};
use std::path::{Path, PathBuf};
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
    /// Deterministically select an equivalent independent-check presentation.
    #[arg(long, conflicts_with = "compiled_in")]
    check_presentation_seed: Option<u64>,
    /// Probe this many deterministic presentation seeds plus the default.
    #[arg(
        long,
        default_value_t = 0,
        value_parser = clap::value_parser!(u16).range(0..=64),
        conflicts_with_all = ["compiled_in", "check_presentation_seed"]
    )]
    check_presentation_probes: u16,
    /// Exact radius used only to score check-presentation probes.
    #[arg(long, requires = "check_presentation_probes")]
    check_presentation_probe_weight: Option<u16>,
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
    /// Zero-based member of a deterministic complete search partition.
    #[arg(long, requires = "shard_count")]
    shard_index: Option<u32>,
    /// Number of deterministic search shards (1..=4096).
    #[arg(long, requires = "shard_index")]
    shard_count: Option<u32>,
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
    #[serde(default)]
    coordinate_generators: Vec<Vec<u16>>,
}

#[derive(Debug, Serialize)]
struct RunRecord<'a> {
    schema: &'static str,
    completion_status: &'static str,
    input_blake3: Option<&'a str>,
    executable_blake3: Option<&'a str>,
    label: &'a str,
    coordinate_count: u16,
    physical_checks: usize,
    logical_observations: usize,
    anchors: &'a [u16],
    anchor_verification: &'static str,
    coordinate_generators: usize,
    coordinate_orbits: Option<usize>,
    minimum_orbit_size: Option<u32>,
    maximum_orbit_size: Option<u32>,
    maximum_weight: u16,
    mode: &'static str,
    preparation_mode: &'static str,
    check_presentation_seed: Option<u64>,
    check_presentation_probe: Option<&'a CheckPresentationProbeRecord>,
    preparation_seconds: f64,
    artifact_write_seconds: Option<f64>,
    artifact_payload_blake3: Option<String>,
    search_kernel: &'static str,
    threads: usize,
    worker_cpus: &'a [usize],
    pulse_interval: u64,
    result_scope: &'static str,
    search_shard: Option<CssSearchShard>,
    shard_frontiers: Option<&'a [ShardFrontierRecord]>,
    search_seconds: &'a [f64],
    round_stats: &'a [ergodis::ConnectedSearchStats],
    result: &'a ergodis::BoundedCssDistanceResult,
}

#[derive(Debug, Serialize)]
struct CheckPresentationProbeRecord {
    maximum_weight: u16,
    selected_seed: Option<u64>,
    candidates: Vec<CheckPresentationProbeCandidate>,
}

#[derive(Debug, Serialize)]
struct CheckPresentationProbeCandidate {
    seed: Option<u64>,
    candidates: u64,
    searched_maximum_weight: u16,
    distance: Option<u16>,
    search_seconds: f64,
}

#[derive(Debug, Serialize)]
struct ShardFrontierRecord {
    anchor: u16,
    frontier_branches: u64,
    partition_blake3: String,
    shard_branches: u64,
    shard_sum_le: String,
    shard_xor_le: String,
}

fn hex_bytes(bytes: &[u8]) -> String {
    let mut encoded = String::with_capacity(bytes.len() * 2);
    for byte in bytes {
        write!(&mut encoded, "{byte:02x}").expect("writing to a String cannot fail");
    }
    encoded
}

#[cfg(feature = "parallel")]
fn hex_lanes(lanes: [u64; 4]) -> String {
    let mut bytes = [0_u8; 32];
    for (chunk, lane) in bytes.chunks_exact_mut(8).zip(lanes) {
        chunk.copy_from_slice(&lane.to_le_bytes());
    }
    hex_bytes(&bytes)
}

fn blake3_file(path: &Path) -> Result<String> {
    let file =
        File::open(path).with_context(|| format!("opening {} for hashing", path.display()))?;
    let mut reader = BufReader::new(file);
    let mut hasher = blake3::Hasher::new();
    let mut buffer = [0_u8; 64 * 1024];
    loop {
        let read = reader
            .read(&mut buffer)
            .with_context(|| format!("hashing {}", path.display()))?;
        if read == 0 {
            break;
        }
        hasher.update(&buffer[..read]);
    }
    Ok(hasher.finalize().to_hex().to_string())
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

#[derive(Clone, Copy)]
struct BackendShape {
    wide: bool,
    extra_wide: bool,
    large: bool,
    huge: bool,
    colossal: bool,
}

impl Backend {
    fn check_presentation_seed(&self) -> Option<u64> {
        match self {
            Self::Compact(_) => None,
            Self::Wide(compiled) => compiled.check_presentation_seed(),
            Self::ExtraWide(compiled) => compiled.check_presentation_seed(),
            #[cfg(feature = "large-css")]
            Self::Large(compiled) => compiled.check_presentation_seed(),
            #[cfg(feature = "large-css")]
            Self::Huge(compiled) => compiled.check_presentation_seed(),
            #[cfg(feature = "large-css")]
            Self::Colossal(compiled) => compiled.check_presentation_seed(),
        }
    }

    fn autotuned_preparation_mode(&self) -> &'static str {
        match self {
            Self::Compact(_) => "compile",
            Self::Wide(_) => "wide-presentation-autotune",
            Self::ExtraWide(_) => "extra-wide-presentation-autotune",
            #[cfg(feature = "large-css")]
            Self::Large(_) => "large-presentation-autotune",
            #[cfg(feature = "large-css")]
            Self::Huge(_) => "huge-presentation-autotune",
            #[cfg(feature = "large-css")]
            Self::Colossal(_) => "colossal-presentation-autotune",
        }
    }

    #[cfg(feature = "parallel")]
    fn search_presentation_probe_parallel(
        &self,
        pool: &rayon::ThreadPool,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<ergodis::BoundedCssDistanceResult> {
        pool.install(|| match self {
            Self::Compact(_) => bail!("presentation probes require a wide backend"),
            Self::Wide(compiled) => Ok(compiled.search_bounded_syndrome_parallel_pulsed(
                anchors,
                maximum_weight,
                pulse_interval,
            )?),
            Self::ExtraWide(compiled) => Ok(compiled.search_bounded_syndrome_parallel_pulsed(
                anchors,
                maximum_weight,
                pulse_interval,
            )?),
            #[cfg(feature = "large-css")]
            Self::Large(compiled) => Ok(compiled.search_bounded_syndrome_parallel_pulsed(
                anchors,
                maximum_weight,
                pulse_interval,
            )?),
            #[cfg(feature = "large-css")]
            Self::Huge(compiled) => Ok(compiled.search_bounded_syndrome_parallel_pulsed(
                anchors,
                maximum_weight,
                pulse_interval,
            )?),
            #[cfg(feature = "large-css")]
            Self::Colossal(compiled) => Ok(compiled.search_bounded_syndrome_parallel_pulsed(
                anchors,
                maximum_weight,
                pulse_interval,
            )?),
        })
    }

    #[cfg(not(feature = "parallel"))]
    fn search_presentation_probe_serial(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
    ) -> Result<ergodis::BoundedCssDistanceResult> {
        match self {
            Self::Compact(_) => bail!("presentation probes require a wide backend"),
            Self::Wide(compiled) => {
                Ok(compiled.search_bounded_syndrome_driven(anchors, maximum_weight)?)
            }
            Self::ExtraWide(compiled) => {
                Ok(compiled.search_bounded_syndrome_driven(anchors, maximum_weight)?)
            }
            #[cfg(feature = "large-css")]
            Self::Large(compiled) => {
                Ok(compiled.search_bounded_syndrome_driven(anchors, maximum_weight)?)
            }
            #[cfg(feature = "large-css")]
            Self::Huge(compiled) => {
                Ok(compiled.search_bounded_syndrome_driven(anchors, maximum_weight)?)
            }
            #[cfg(feature = "large-css")]
            Self::Colossal(compiled) => {
                Ok(compiled.search_bounded_syndrome_driven(anchors, maximum_weight)?)
            }
        }
    }
}

fn compile_backend(
    physical: &Matrix,
    logical: &Matrix,
    shape: BackendShape,
    check_presentation_seed: Option<u64>,
) -> Result<(Backend, &'static str)> {
    if shape.colossal {
        #[cfg(feature = "large-css")]
        {
            return if let Some(seed) = check_presentation_seed {
                Ok((
                    Backend::Colossal(
                        CompiledColossalCssDistance::compile_with_check_presentation_seed(
                            physical, logical, seed,
                        )?,
                    ),
                    "colossal-seeded-compile",
                ))
            } else {
                Ok((
                    Backend::Colossal(CompiledColossalCssDistance::compile(physical, logical)?),
                    "colossal-compile",
                ))
            };
        }
        #[cfg(not(feature = "large-css"))]
        bail!("colossal CSS instances require --features large-css");
    }
    if shape.huge {
        #[cfg(feature = "large-css")]
        {
            return if let Some(seed) = check_presentation_seed {
                Ok((
                    Backend::Huge(
                        CompiledHugeCssDistance::compile_with_check_presentation_seed(
                            physical, logical, seed,
                        )?,
                    ),
                    "huge-seeded-compile",
                ))
            } else {
                Ok((
                    Backend::Huge(CompiledHugeCssDistance::compile(physical, logical)?),
                    "huge-compile",
                ))
            };
        }
        #[cfg(not(feature = "large-css"))]
        bail!("huge CSS instances require --features large-css");
    }
    if shape.large {
        #[cfg(feature = "large-css")]
        {
            return if let Some(seed) = check_presentation_seed {
                Ok((
                    Backend::Large(
                        CompiledLargeCssDistance::compile_with_check_presentation_seed(
                            physical, logical, seed,
                        )?,
                    ),
                    "large-seeded-compile",
                ))
            } else {
                Ok((
                    Backend::Large(CompiledLargeCssDistance::compile(physical, logical)?),
                    "large-compile",
                ))
            };
        }
        #[cfg(not(feature = "large-css"))]
        bail!("instances above 384 coordinates or rank 192 require --features large-css");
    }
    if shape.extra_wide {
        return if let Some(seed) = check_presentation_seed {
            Ok((
                Backend::ExtraWide(
                    CompiledExtraWideCssDistance::compile_with_check_presentation_seed(
                        physical, logical, seed,
                    )?,
                ),
                "extra-wide-seeded-compile",
            ))
        } else {
            Ok((
                Backend::ExtraWide(CompiledExtraWideCssDistance::compile(physical, logical)?),
                "extra-wide-compile",
            ))
        };
    }
    if shape.wide {
        return if let Some(seed) = check_presentation_seed {
            Ok((
                Backend::Wide(
                    CompiledWideCssDistance::compile_with_check_presentation_seed(
                        physical, logical, seed,
                    )?,
                ),
                "wide-seeded-compile",
            ))
        } else {
            Ok((
                Backend::Wide(CompiledWideCssDistance::compile(physical, logical)?),
                "wide-compile",
            ))
        };
    }
    if check_presentation_seed.is_some() {
        bail!("check presentation seeds require a syndrome-driven wide backend");
    }
    Ok((
        Backend::Compact(CompiledCssDistance::compile(physical, logical)?),
        "compile",
    ))
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

#[cfg(feature = "parallel")]
fn build_thread_pool(args: &Args) -> Result<rayon::ThreadPool> {
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
    Ok(pool)
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
    let search_shard = match (args.shard_index, args.shard_count) {
        (Some(index), Some(count)) => Some(CssSearchShard::new(index, count)?),
        (None, None) => None,
        _ => unreachable!("clap enforces paired shard arguments"),
    };
    let shard_fingerprints = if search_shard.is_some() {
        let input_blake3 = blake3_file(&args.input)?;
        let executable = std::env::current_exe().context("resolving current executable")?;
        let executable_blake3 = blake3_file(&executable)?;
        Some((input_blake3, executable_blake3))
    } else {
        None
    };
    #[cfg(not(feature = "parallel"))]
    if search_shard.is_some() {
        bail!("search sharding requires the `parallel` feature");
    }
    let file = File::open(&args.input)
        .with_context(|| format!("opening input {}", args.input.display()))?;
    let problem: SparseProblem =
        serde_json::from_reader(BufReader::new(file)).context("parsing sparse CSS problem")?;
    let columns = usize::from(problem.coordinate_count);
    let maximum_weight = args.maximum_weight.unwrap_or(problem.maximum_weight);
    if maximum_weight == 0 {
        bail!("maximum weight must be positive");
    }
    let physical = dense_matrix(&problem.physical_checks, columns)?;
    let logical = dense_matrix(&problem.logical_observations, columns)?;
    let anchor_certificate = if problem.coordinate_generators.is_empty() {
        None
    } else {
        let mut images =
            Vec::with_capacity(problem.coordinate_generators.len().saturating_mul(columns));
        for (generator, row) in problem.coordinate_generators.iter().enumerate() {
            if row.len() != columns {
                bail!(
                    "coordinate generator {generator} has {} images, expected {columns}",
                    row.len()
                );
            }
            images.extend(row.iter().map(|&image| u32::from(image)));
        }
        Some(
            verify_css_anchor_transversal(&physical, &logical, images, &problem.anchors)
                .context("verifying coordinate generators and anchor transversal")?,
        )
    };
    let physical_rank = binary_rank(&problem.physical_checks, columns);
    // Deep searches benefit overwhelmingly from syndrome-driven fail-first
    // branching even when the compact coordinate representation would fit.
    // Keep shallow and genuinely small jobs on the lower-overhead compact path.
    let deep_syndrome_problem = columns >= 96 && maximum_weight >= 12;
    let wide_problem = columns > 256 || physical_rank > 128 || deep_syndrome_problem;
    let colossal_problem = columns > 1536 || physical_rank > 704;
    let huge_problem =
        !colossal_problem && (columns > 832 || physical_rank > 384 || logical.rows() > 64);
    let large_problem =
        !colossal_problem && !huge_problem && (columns > 384 || physical_rank > 192);
    let extra_wide_problem = !large_problem && columns > 320;
    let backend_shape = BackendShape {
        wide: wide_problem,
        extra_wide: extra_wide_problem,
        large: large_problem,
        huge: huge_problem,
        colossal: colossal_problem,
    };
    if args.check_presentation_seed.is_some() && !wide_problem {
        bail!("--check-presentation-seed requires a syndrome-driven wide backend");
    }
    if args.check_presentation_probes > 0 && !wide_problem {
        bail!("--check-presentation-probes requires a syndrome-driven wide backend");
    }
    if args.check_presentation_probes > 0 && search_shard.is_some() {
        bail!("autotune a presentation artifact before launching deterministic shards");
    }
    if args.check_presentation_probes == 0 && args.check_presentation_probe_weight.is_some() {
        bail!("--check-presentation-probe-weight requires positive presentation probes");
    }
    if args
        .check_presentation_probe_weight
        .is_some_and(|weight| weight == 0 || weight > maximum_weight)
    {
        bail!("check-presentation probe weight must lie within the requested search radius");
    }
    if args.check_presentation_probes > 0
        && args.maximum_weight.is_none()
        && !problem.incumbent_support.is_empty()
    {
        bail!("check-presentation probes cannot be combined with incumbent certification");
    }
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
    let thread_pool = build_thread_pool(&args)?;
    let preparation_start = Instant::now();
    let (mut compiled, mut preparation_mode) = if let Some(path) = &args.compiled_in {
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
    } else {
        compile_backend(
            &physical,
            &logical,
            backend_shape,
            args.check_presentation_seed,
        )?
    };
    let mut check_presentation_probe = None;
    if args.check_presentation_probes > 0 {
        let probe_weight = args
            .check_presentation_probe_weight
            .unwrap_or(maximum_weight.clamp(1, 15));
        let mut candidates = Vec::with_capacity(usize::from(args.check_presentation_probes) + 1);
        let search_start = Instant::now();
        #[cfg(feature = "parallel")]
        let baseline_result = compiled.search_presentation_probe_parallel(
            &thread_pool,
            &problem.anchors,
            probe_weight,
            args.pulse_interval,
        )?;
        #[cfg(not(feature = "parallel"))]
        let baseline_result =
            compiled.search_presentation_probe_serial(&problem.anchors, probe_weight)?;
        let baseline_seconds = search_start.elapsed().as_secs_f64();
        let reference_distance = baseline_result.distance;
        let reference_searched_maximum = baseline_result.searched_maximum_weight;
        let mut best_candidates = baseline_result.stats.candidates;
        candidates.push(CheckPresentationProbeCandidate {
            seed: None,
            candidates: best_candidates,
            searched_maximum_weight: reference_searched_maximum,
            distance: reference_distance,
            search_seconds: baseline_seconds,
        });

        for seed in 0..u64::from(args.check_presentation_probes) {
            let (candidate, _) = compile_backend(&physical, &logical, backend_shape, Some(seed))?;
            let search_start = Instant::now();
            #[cfg(feature = "parallel")]
            let result = candidate.search_presentation_probe_parallel(
                &thread_pool,
                &problem.anchors,
                probe_weight,
                args.pulse_interval,
            )?;
            #[cfg(not(feature = "parallel"))]
            let result =
                candidate.search_presentation_probe_serial(&problem.anchors, probe_weight)?;
            let search_seconds = search_start.elapsed().as_secs_f64();
            if result.distance != reference_distance
                || result.searched_maximum_weight != reference_searched_maximum
            {
                bail!("equivalent check presentations returned incompatible exact probe results");
            }
            let candidate_count = result.stats.candidates;
            candidates.push(CheckPresentationProbeCandidate {
                seed: Some(seed),
                candidates: candidate_count,
                searched_maximum_weight: result.searched_maximum_weight,
                distance: result.distance,
                search_seconds,
            });
            if candidate_count < best_candidates {
                best_candidates = candidate_count;
                compiled = candidate;
            }
        }
        preparation_mode = compiled.autotuned_preparation_mode();
        check_presentation_probe = Some(CheckPresentationProbeRecord {
            maximum_weight: probe_weight,
            selected_seed: compiled.check_presentation_seed(),
            candidates,
        });
    }
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
    .map(|digest| hex_bytes(&digest));
    #[cfg(feature = "parallel")]
    let shard_frontiers = if let Some(shard) = search_shard {
        let commitments = match &compiled {
            Backend::Compact(compiled) => {
                compiled.shard_frontier_commitments(&problem.anchors, maximum_weight, shard)?
            }
            Backend::Wide(compiled) => {
                compiled.shard_frontier_commitments(&problem.anchors, maximum_weight, shard)?
            }
            Backend::ExtraWide(compiled) => {
                compiled.shard_frontier_commitments(&problem.anchors, maximum_weight, shard)?
            }
            #[cfg(feature = "large-css")]
            Backend::Large(compiled) => {
                compiled.shard_frontier_commitments(&problem.anchors, maximum_weight, shard)?
            }
            #[cfg(feature = "large-css")]
            Backend::Huge(compiled) => {
                compiled.shard_frontier_commitments(&problem.anchors, maximum_weight, shard)?
            }
            #[cfg(feature = "large-css")]
            Backend::Colossal(compiled) => {
                compiled.shard_frontier_commitments(&problem.anchors, maximum_weight, shard)?
            }
        };
        Some(
            commitments
                .iter()
                .map(|commitment| ShardFrontierRecord {
                    anchor: commitment.anchor(),
                    frontier_branches: commitment.frontier_branches(),
                    partition_blake3: hex_bytes(&commitment.partition_blake3()),
                    shard_branches: commitment.shard_branches(),
                    shard_sum_le: hex_lanes(commitment.shard_sum()),
                    shard_xor_le: hex_lanes(commitment.shard_xor()),
                })
                .collect::<Vec<_>>(),
        )
    } else {
        None
    };
    #[cfg(not(feature = "parallel"))]
    let shard_frontiers: Option<Vec<ShardFrontierRecord>> = None;
    let certify_incumbent = args.maximum_weight.is_none() && !problem.incumbent_support.is_empty();
    if certify_incumbent && search_shard.is_some() {
        bail!("search shards cannot be combined with incumbent certification");
    }
    let mode = if certify_incumbent {
        "certify-incumbent"
    } else if search_shard.is_some() {
        "bounded-search-shard"
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
                    match search_shard {
                        Some(shard) => compiled.search_bounded_parallel_pulsed_shard(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                            shard,
                        ),
                        None => compiled.search_bounded_parallel_pulsed(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                        ),
                    }
                }
            })?,
            Backend::Wide(compiled) => thread_pool.install(|| {
                if certify_incumbent {
                    compiled.certify_incumbent_parallel_pulsed(
                        &problem.anchors,
                        &problem.incumbent_support,
                        args.pulse_interval,
                    )
                } else {
                    match search_shard {
                        Some(shard) => compiled.search_bounded_syndrome_parallel_pulsed_shard(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                            shard,
                        ),
                        None => compiled.search_bounded_syndrome_parallel_pulsed(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                        ),
                    }
                }
            })?,
            Backend::ExtraWide(compiled) => thread_pool.install(|| {
                if certify_incumbent {
                    compiled.certify_incumbent_parallel_pulsed(
                        &problem.anchors,
                        &problem.incumbent_support,
                        args.pulse_interval,
                    )
                } else {
                    match search_shard {
                        Some(shard) => compiled.search_bounded_syndrome_parallel_pulsed_shard(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                            shard,
                        ),
                        None => compiled.search_bounded_syndrome_parallel_pulsed(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                        ),
                    }
                }
            })?,
            #[cfg(feature = "large-css")]
            Backend::Large(compiled) => thread_pool.install(|| {
                if certify_incumbent {
                    compiled.certify_incumbent_parallel_pulsed(
                        &problem.anchors,
                        &problem.incumbent_support,
                        args.pulse_interval,
                    )
                } else {
                    match search_shard {
                        Some(shard) => compiled.search_bounded_syndrome_parallel_pulsed_shard(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                            shard,
                        ),
                        None => compiled.search_bounded_syndrome_parallel_pulsed(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                        ),
                    }
                }
            })?,
            #[cfg(feature = "large-css")]
            Backend::Huge(compiled) => thread_pool.install(|| {
                if certify_incumbent {
                    compiled.certify_incumbent_parallel_pulsed(
                        &problem.anchors,
                        &problem.incumbent_support,
                        args.pulse_interval,
                    )
                } else {
                    match search_shard {
                        Some(shard) => compiled.search_bounded_syndrome_parallel_pulsed_shard(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                            shard,
                        ),
                        None => compiled.search_bounded_syndrome_parallel_pulsed(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                        ),
                    }
                }
            })?,
            #[cfg(feature = "large-css")]
            Backend::Colossal(compiled) => thread_pool.install(|| {
                if certify_incumbent {
                    compiled.certify_incumbent_parallel_pulsed(
                        &problem.anchors,
                        &problem.incumbent_support,
                        args.pulse_interval,
                    )
                } else {
                    match search_shard {
                        Some(shard) => compiled.search_bounded_syndrome_parallel_pulsed_shard(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                            shard,
                        ),
                        None => compiled.search_bounded_syndrome_parallel_pulsed(
                            &problem.anchors,
                            maximum_weight,
                            args.pulse_interval,
                        ),
                    }
                }
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
                if certify_incumbent {
                    compiled.certify_incumbent_syndrome_driven(
                        &problem.anchors,
                        &problem.incumbent_support,
                    )?
                } else {
                    compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
                }
            }
            Backend::ExtraWide(compiled) => {
                if certify_incumbent {
                    compiled.certify_incumbent_syndrome_driven(
                        &problem.anchors,
                        &problem.incumbent_support,
                    )?
                } else {
                    compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
                }
            }
            #[cfg(feature = "large-css")]
            Backend::Large(compiled) => {
                if certify_incumbent {
                    compiled.certify_incumbent_syndrome_driven(
                        &problem.anchors,
                        &problem.incumbent_support,
                    )?
                } else {
                    compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
                }
            }
            #[cfg(feature = "large-css")]
            Backend::Huge(compiled) => {
                if certify_incumbent {
                    compiled.certify_incumbent_syndrome_driven(
                        &problem.anchors,
                        &problem.incumbent_support,
                    )?
                } else {
                    compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
                }
            }
            #[cfg(feature = "large-css")]
            Backend::Colossal(compiled) => {
                if certify_incumbent {
                    compiled.certify_incumbent_syndrome_driven(
                        &problem.anchors,
                        &problem.incumbent_support,
                    )?
                } else {
                    compiled.search_bounded_syndrome_driven(&problem.anchors, maximum_weight)?
                }
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
        schema: "ergodis-css-distance-native-v6",
        completion_status: "complete",
        input_blake3: shard_fingerprints.as_ref().map(|(input, _)| input.as_str()),
        executable_blake3: shard_fingerprints
            .as_ref()
            .map(|(_, executable)| executable.as_str()),
        label: &problem.label,
        coordinate_count: problem.coordinate_count,
        physical_checks: problem.physical_checks.len(),
        logical_observations: problem.logical_observations.len(),
        anchors: &problem.anchors,
        anchor_verification: if anchor_certificate.is_some() {
            "verified-orbit-transversal"
        } else {
            "trusted-input"
        },
        coordinate_generators: problem.coordinate_generators.len(),
        coordinate_orbits: anchor_certificate
            .as_ref()
            .map(|certificate| certificate.partition().representatives().len()),
        minimum_orbit_size: anchor_certificate
            .as_ref()
            .map(|certificate| certificate.minimum_orbit_size()),
        maximum_orbit_size: anchor_certificate
            .as_ref()
            .map(|certificate| certificate.maximum_orbit_size()),
        maximum_weight,
        mode,
        preparation_mode,
        check_presentation_seed: compiled.check_presentation_seed(),
        check_presentation_probe: check_presentation_probe.as_ref(),
        preparation_seconds,
        artifact_write_seconds,
        artifact_payload_blake3,
        search_kernel: search_kernel(wide_problem),
        threads: args.threads,
        worker_cpus: &args.worker_cpus,
        pulse_interval: args.pulse_interval,
        result_scope: if search_shard.is_some() {
            "partial-shard"
        } else {
            "global"
        },
        search_shard,
        shard_frontiers: shard_frontiers.as_deref(),
        search_seconds: &search_seconds,
        round_stats: &round_stats,
        result: &result,
    };
    emit(&record, args.evidence.as_ref())
}
