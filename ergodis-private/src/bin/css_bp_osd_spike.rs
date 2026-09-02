use anyhow::{bail, Context, Result};
use clap::{Parser, ValueEnum};
use ergodis::bp_osd::{BinaryParityCheck, BpOsdConfig, BpOsdWorkspace, OsdMethod};
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::PathBuf;
use std::time::Instant;

#[derive(Debug, Parser)]
#[command(about = "Private BP+OSD CSS logical-witness application spike")]
struct Args {
    #[arg(long)]
    input: PathBuf,
    #[arg(long, default_value_t = 1)]
    threads: usize,
    #[arg(long, value_enum, default_value_t = Method::Zero)]
    method: Method,
    #[arg(long, default_value_t = 10)]
    osd_order: usize,
    #[arg(long, default_value_t = 300)]
    iterations: usize,
    #[arg(long, default_value_t = 0.002)]
    error_rate: f64,
    #[arg(long, default_value_t = 0.625)]
    min_sum_scale: f64,
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

#[derive(Debug, Default)]
struct LocalResult {
    attempted: usize,
    satisfied: usize,
    replayed: usize,
    best_weight: Option<usize>,
    best_target: Option<usize>,
    best_support: Vec<usize>,
    candidate_checksum: u64,
}

#[derive(Debug, Serialize)]
struct Report<'a> {
    schema: &'static str,
    label: &'a str,
    coordinate_count: u16,
    physical_checks: usize,
    logical_observations: usize,
    threads: usize,
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

fn solve_stride(
    problem: &SparseProblem,
    codes: &[BinaryParityCheck],
    config: BpOsdConfig,
    method: OsdMethod,
    first: usize,
    stride: usize,
) -> Result<LocalResult> {
    let mut local = LocalResult::default();
    for target in (first..codes.len()).step_by(stride) {
        let code = &codes[target];
        let mut workspace = BpOsdWorkspace::new(code, config, method)?;
        let mut syndrome = vec![0_u8; code.check_count()];
        *syndrome
            .last_mut()
            .context("logical target row is missing")? = 1;
        let result = workspace.decode_bytes(code, &syndrome)?;
        local.attempted += 1;
        local.satisfied += usize::from(result.syndrome_satisfied);
        local.candidate_checksum ^= checksum(result.candidate, target);
        if result.syndrome_satisfied && independently_replays(problem, result.candidate) {
            local.replayed += 1;
            if local
                .best_weight
                .is_none_or(|weight| result.weight < weight)
            {
                local.best_weight = Some(result.weight);
                local.best_target = Some(target);
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
    Ok(local)
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

fn main() -> Result<()> {
    let args = Args::parse();
    if args.threads == 0 || args.threads > 12 {
        bail!("--threads must be in 1..=12");
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
    let config = BpOsdConfig {
        error_rate: args.error_rate,
        maximum_iterations: args.iterations,
        min_sum_scale: args.min_sum_scale,
    };
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
    let started = Instant::now();
    let workers = args.threads.min(codes.len());
    let locals = std::thread::scope(|scope| {
        let problem_ref = &problem;
        let codes_ref = &codes;
        let mut handles = Vec::with_capacity(workers);
        for first in 0..workers {
            handles.push(scope.spawn(move || {
                solve_stride(problem_ref, codes_ref, config, method, first, workers)
            }));
        }
        handles
            .into_iter()
            .map(|handle| handle.join().expect("BP worker panicked"))
            .collect::<Result<Vec<_>>>()
    })?;
    let mut total = LocalResult::default();
    for local in locals {
        merge(&mut total, local);
    }
    let report = Report {
        schema: "ergodis-private-css-bp-osd-spike-v1",
        label: &problem.label,
        coordinate_count: problem.coordinate_count,
        physical_checks: problem.physical_checks.len(),
        logical_observations: problem.logical_observations.len(),
        threads: workers,
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
        elapsed_seconds: started.elapsed().as_secs_f64(),
    };
    println!("{}", serde_json::to_string(&report)?);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

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
}
