use anyhow::{bail, Context, Result};
use clap::{Args as ClapArgs, ValueEnum};
use ergodis::bp_osd::{BinaryParityCheck, BpOsdConfig, BpOsdWorkspace, OsdMethod};
use serde::{Deserialize, Serialize};
use std::fs::{self, OpenOptions};
use std::io::Write;
use std::path::PathBuf;
use std::time::Instant;

#[derive(Debug, ClapArgs)]
pub struct Args {
    #[arg(long)]
    input: PathBuf,
    #[arg(long, default_value_t = 1)]
    threads: usize,
    #[arg(long, default_value_t = 1)]
    rounds: usize,
    #[arg(long, value_enum, default_value_t = Method::Zero)]
    method: Method,
    #[arg(long, default_value_t = 10)]
    osd_order: usize,
    #[arg(long, default_value_t = 300)]
    iterations: usize,
    #[arg(long, value_delimiter = ',')]
    iteration_candidates: Vec<usize>,
    #[arg(long)]
    target_weight: Option<usize>,
    #[arg(long)]
    cost_filter_checkpoints: bool,
    #[arg(long, default_value_t = 0.002)]
    error_rate: f64,
    #[arg(long, default_value_t = 0.625)]
    min_sum_scale: f64,
    /// Create a one-record JSONL evidence file after the decode wave.
    #[arg(long)]
    evidence: Option<PathBuf>,
}

#[derive(Clone, Copy, Debug, ValueEnum)]
enum Method {
    Disabled,
    Zero,
    Combination,
    Exhaustive,
}

#[derive(Debug, Deserialize)]
struct SparseProblem {
    label: String,
    coordinate_count: u16,
    physical_checks: Vec<Vec<u16>>,
    logical_observations: Vec<Vec<u16>>,
}

#[derive(Debug)]
struct LocalResult {
    attempted: usize,
    satisfied: usize,
    replayed: usize,
    best_weight: Option<usize>,
    best_target: Option<usize>,
    best_support: Vec<usize>,
    candidate_checksum: u64,
}

impl LocalResult {
    fn new(bits: usize) -> Self {
        Self {
            attempted: 0,
            satisfied: 0,
            replayed: 0,
            best_weight: None,
            best_target: None,
            best_support: Vec::with_capacity(bits),
            candidate_checksum: 0,
        }
    }
}

struct PreparedTarget<'code> {
    target: usize,
    code: &'code BinaryParityCheck,
    workspace: BpOsdWorkspace,
    syndrome: Vec<u8>,
}

struct WorkerJob<'code> {
    targets: Vec<PreparedTarget<'code>>,
    result: LocalResult,
}

#[derive(Debug, Serialize)]
struct Report<'a> {
    schema: &'static str,
    label: &'a str,
    coordinate_count: u16,
    physical_checks: usize,
    logical_observations: usize,
    threads: usize,
    rounds: usize,
    iteration_candidates: Vec<usize>,
    selected_iterations: usize,
    target_weight: Option<usize>,
    cost_filter_checkpoints: bool,
    method: &'static str,
    osd_order: usize,
    attempted: usize,
    syndrome_satisfied: usize,
    independently_replayed: usize,
    best_weight: Option<usize>,
    best_target: Option<usize>,
    best_support: Vec<usize>,
    candidate_checksum: u64,
    elapsed_seconds: f64,
}

fn parity(row: &[u16], word: &[u8]) -> u8 {
    row.iter()
        .fold(0, |value, &column| value ^ word[usize::from(column)])
}

fn independently_replays(problem: &SparseProblem, word: &[u8]) -> bool {
    problem
        .physical_checks
        .iter()
        .all(|row| parity(row, word) == 0)
        && problem
            .logical_observations
            .iter()
            .any(|row| parity(row, word) != 0)
}

fn checksum(word: &[u8], target: usize) -> u64 {
    let mut hash = 0xcbf29ce484222325_u64 ^ target as u64;
    for (index, &bit) in word.iter().enumerate() {
        hash ^= (index as u64).wrapping_mul(u64::from(bit));
        hash = hash.wrapping_mul(0x100000001b3);
    }
    hash
}

fn solve_chunk(
    problem: &SparseProblem,
    targets: &mut [PreparedTarget<'_>],
    local: &mut LocalResult,
    rounds: usize,
) -> Result<()> {
    for round in 0..rounds {
        for prepared in &mut *targets {
            let result = prepared
                .workspace
                .decode_bytes(prepared.code, &prepared.syndrome)?;
            local.attempted += 1;
            local.satisfied += usize::from(result.syndrome_satisfied);
            let checksum_target = prepared.target ^ round.wrapping_mul(0x9e37_79b9);
            local.candidate_checksum ^= checksum(result.candidate, checksum_target);
            if result.syndrome_satisfied && independently_replays(problem, result.candidate) {
                local.replayed += 1;
                if local
                    .best_weight
                    .is_none_or(|weight| result.weight < weight)
                {
                    local.best_weight = Some(result.weight);
                    local.best_target = Some(prepared.target);
                    local.best_support.clear();
                    local.best_support.extend(
                        result
                            .candidate
                            .iter()
                            .enumerate()
                            .filter_map(|(index, &bit)| (bit != 0).then_some(index)),
                    );
                }
            }
        }
    }
    Ok(())
}

fn merge(total: &mut LocalResult, local: LocalResult) {
    total.attempted += local.attempted;
    total.satisfied += local.satisfied;
    total.replayed += local.replayed;
    total.candidate_checksum ^= local.candidate_checksum;
    if local
        .best_weight
        .is_some_and(|weight| total.best_weight.is_none_or(|best| weight < best))
    {
        total.best_weight = local.best_weight;
        total.best_target = local.best_target;
        total.best_support = local.best_support;
    }
}

fn filter_checkpoints(
    candidates: Vec<usize>,
    bits: usize,
    checks: usize,
    edges: usize,
) -> Vec<usize> {
    if candidates.len() <= 2 {
        return candidates;
    }
    let final_iterations = *candidates.last().unwrap();
    let words = (bits + 1).div_ceil(64);
    let osd_units = checks as u128 * checks as u128 * words as u128;
    let always_keep_from = candidates.len() - 2;
    candidates
        .into_iter()
        .enumerate()
        .filter_map(|(index, candidate)| {
            let saved_bp_units = (final_iterations - candidate) as u128 * edges as u128;
            (index >= always_keep_from || osd_units <= saved_bp_units).then_some(candidate)
        })
        .collect()
}

fn run_wave(
    problem: &SparseProblem,
    codes: &[BinaryParityCheck],
    config: BpOsdConfig,
    method: OsdMethod,
    threads: usize,
    rounds: usize,
) -> Result<(LocalResult, f64)> {
    let bits = usize::from(problem.coordinate_count);
    let workers = threads.min(codes.len());
    let per_worker = codes.len().div_ceil(workers);
    let mut jobs = (0..workers)
        .map(|_| Vec::with_capacity(per_worker))
        .collect::<Vec<_>>();
    for (target, code) in codes.iter().enumerate() {
        let workspace = BpOsdWorkspace::new(code, config, method)?;
        let mut syndrome = vec![0_u8; code.check_count()];
        *syndrome
            .last_mut()
            .context("logical target row is missing")? = 1;
        jobs[target % workers].push(PreparedTarget {
            target,
            code,
            workspace,
            syndrome,
        });
    }
    let jobs = jobs
        .into_iter()
        .map(|targets| WorkerJob {
            targets,
            result: LocalResult::new(bits),
        })
        .collect::<Vec<_>>();
    let started = Instant::now();
    let locals = std::thread::scope(|scope| {
        let mut handles = Vec::with_capacity(workers);
        for mut job in jobs {
            handles.push(scope.spawn(move || {
                solve_chunk(problem, &mut job.targets, &mut job.result, rounds)?;
                Ok(job.result)
            }));
        }
        handles
            .into_iter()
            .map(|handle| handle.join().expect("BP worker panicked"))
            .collect::<Result<Vec<_>>>()
    })?;
    let elapsed = started.elapsed().as_secs_f64();
    let mut total = LocalResult::new(bits);
    for local in locals {
        merge(&mut total, local);
    }
    Ok((total, elapsed))
}

pub fn run(args: Args) -> Result<()> {
    if args.threads == 0 || args.threads > 12 {
        bail!("--threads must be in 1..=12");
    }
    if args.rounds == 0 {
        bail!("--rounds must be positive");
    }
    let bytes =
        fs::read(&args.input).with_context(|| format!("reading {}", args.input.display()))?;
    let problem: SparseProblem = serde_json::from_slice(&bytes).context("parsing input")?;
    if problem.logical_observations.is_empty() {
        bail!("at least one logical observation is required");
    }
    let bits = usize::from(problem.coordinate_count);
    let mut codes = Vec::with_capacity(problem.logical_observations.len());
    for logical in &problem.logical_observations {
        let rows = problem
            .physical_checks
            .iter()
            .chain(std::iter::once(logical))
            .map(|row| row.iter().map(|&column| usize::from(column)).collect());
        codes.push(BinaryParityCheck::from_rows(bits, rows)?);
    }
    let method = match args.method {
        Method::Disabled => OsdMethod::Disabled,
        Method::Zero => OsdMethod::Zero,
        Method::Combination => OsdMethod::CombinationSweep {
            order: args.osd_order,
        },
        Method::Exhaustive => OsdMethod::Exhaustive {
            order: args.osd_order,
        },
    };
    let mut iteration_candidates = if args.iteration_candidates.is_empty() {
        vec![args.iterations]
    } else {
        let mut candidates = args.iteration_candidates.clone();
        candidates.sort_unstable();
        candidates.dedup();
        if candidates.first() == Some(&0) {
            bail!("iteration candidates must be positive");
        }
        candidates
    };
    if args.cost_filter_checkpoints && iteration_candidates.len() > 2 {
        let checks = codes
            .iter()
            .map(BinaryParityCheck::check_count)
            .max()
            .unwrap();
        let edges = codes
            .iter()
            .map(BinaryParityCheck::edge_count)
            .max()
            .unwrap();
        iteration_candidates = filter_checkpoints(iteration_candidates, bits, checks, edges);
    }
    let mut total = LocalResult::new(bits);
    let mut elapsed_seconds = 0.0;
    let mut selected_iterations = iteration_candidates[0];
    for &maximum_iterations in &iteration_candidates {
        let config = BpOsdConfig {
            error_rate: args.error_rate,
            maximum_iterations,
            min_sum_scale: args.min_sum_scale,
        };
        let (wave, elapsed) =
            run_wave(&problem, &codes, config, method, args.threads, args.rounds)?;
        elapsed_seconds += elapsed;
        if wave
            .best_weight
            .is_some_and(|weight| total.best_weight.is_none_or(|best| weight < best))
        {
            selected_iterations = maximum_iterations;
        }
        merge(&mut total, wave);
        if args
            .target_weight
            .is_some_and(|target| total.best_weight.is_some_and(|weight| weight <= target))
        {
            break;
        }
    }
    let workers = args.threads.min(codes.len());
    let report = Report {
        schema: "ergodis-private-css-bp-osd-spike-v2",
        label: &problem.label,
        coordinate_count: problem.coordinate_count,
        physical_checks: problem.physical_checks.len(),
        logical_observations: problem.logical_observations.len(),
        threads: workers,
        rounds: args.rounds,
        iteration_candidates,
        selected_iterations,
        target_weight: args.target_weight,
        cost_filter_checkpoints: args.cost_filter_checkpoints,
        method: match args.method {
            Method::Disabled => "disabled",
            Method::Zero => "osd0",
            Method::Combination => "combination",
            Method::Exhaustive => "exhaustive",
        },
        osd_order: args.osd_order,
        attempted: total.attempted,
        syndrome_satisfied: total.satisfied,
        independently_replayed: total.replayed,
        best_weight: total.best_weight,
        best_target: total.best_target,
        best_support: total.best_support,
        candidate_checksum: total.candidate_checksum,
        elapsed_seconds,
    };
    let encoded = serde_json::to_vec(&report)?;
    let mut stdout = std::io::stdout().lock();
    stdout.write_all(&encoded)?;
    stdout.write_all(b"\n")?;
    if let Some(path) = &args.evidence {
        let mut output = OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(path)
            .with_context(|| format!("creating evidence file {}", path.display()))?;
        output
            .write_all(&encoded)
            .with_context(|| format!("writing evidence file {}", path.display()))?;
        output
            .write_all(b"\n")
            .with_context(|| format!("finishing evidence file {}", path.display()))?;
    }
    Ok(())
}

#[cfg(test)]
#[path = "../../../../papers/complete-repair-ports/ergodis/src/test_alloc.rs"]
mod test_alloc;

#[cfg(test)]
mod tests {
    use super::*;
    use test_alloc::measure_current_thread_allocations;

    fn problem() -> SparseProblem {
        SparseProblem {
            label: "control".into(),
            coordinate_count: 4,
            physical_checks: vec![vec![0, 1], vec![2, 3]],
            logical_observations: vec![vec![0, 2]],
        }
    }

    #[test]
    fn independent_replay_accepts_only_physical_kernel_with_logical_signal() {
        let problem = problem();
        assert!(independently_replays(&problem, &[1, 1, 0, 0]));
        assert!(!independently_replays(&problem, &[1, 0, 0, 0]));
        assert!(!independently_replays(&problem, &[1, 1, 1, 1]));
    }

    #[test]
    fn checksum_binds_target_and_candidate() {
        assert_ne!(checksum(&[1, 0, 1], 0), checksum(&[1, 0, 1], 1));
        assert_ne!(checksum(&[1, 0, 1], 0), checksum(&[0, 1, 1], 0));
    }

    #[test]
    fn checkpoint_cost_filter_keeps_fallbacks_and_drops_expensive_early_probes() {
        assert_eq!(
            filter_checkpoints(vec![1, 8, 300], 288, 145, 900),
            vec![1, 8, 300]
        );
        assert_eq!(
            filter_checkpoints(vec![1, 192, 300], 756, 379, 2_500),
            vec![192, 300]
        );
        assert_eq!(
            filter_checkpoints(vec![4, 20], 10_000, 8_000, 1),
            vec![4, 20]
        );
    }

    #[test]
    fn prepared_solve_loop_allocates_nothing() {
        let problem = problem();
        let rows = problem
            .physical_checks
            .iter()
            .chain(std::iter::once(&problem.logical_observations[0]))
            .map(|row| row.iter().map(|&column| usize::from(column)).collect());
        let code = BinaryParityCheck::from_rows(4, rows).unwrap();
        let workspace = BpOsdWorkspace::new(
            &code,
            BpOsdConfig::default(),
            OsdMethod::CombinationSweep { order: 2 },
        )
        .unwrap();
        let mut targets = [PreparedTarget {
            target: 0,
            code: &code,
            workspace,
            syndrome: vec![0, 0, 1],
        }];
        let mut local = LocalResult::new(4);
        let (result, events) = measure_current_thread_allocations(|| {
            solve_chunk(&problem, &mut targets, &mut local, 1)
        });
        result.unwrap();
        assert_eq!(events.allocations, 0);
        assert_eq!(events.reallocations, 0);
        assert_eq!(events.deallocations, 0);
        assert_eq!(local.replayed, 1);
    }
}
