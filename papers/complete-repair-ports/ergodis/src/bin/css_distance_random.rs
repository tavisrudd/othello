use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{BinaryKernelSearchWorkspace, BinaryKernelTrialOptions, CompiledBinaryKernelSearch};
use rayon::prelude::*;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Read, Write};
use std::path::PathBuf;
use std::time::Instant;

#[derive(Debug, Parser)]
#[command(about = "Random-information-set CSS logical witness search")]
struct Args {
    #[arg(long)]
    input: PathBuf,
    #[arg(long)]
    trials: u64,
    #[arg(long)]
    target_weight: u16,
    #[arg(long, default_value_t = 1)]
    threads: usize,
    #[arg(long, default_value_t = 0x7261_6e64_6973_6431)]
    seed: u64,
    /// Ordered-statistics combination order (1 or 2).
    #[arg(long, default_value_t = 2)]
    osd_order: u8,
    /// Number of lightest systematic kernel rows admitted to order-2 combinations.
    #[arg(long, default_value_t = 96)]
    osd_window: usize,
    /// Exhaust every assigned trial while retaining the lightest verified
    /// witness, even when it is above target-weight.
    #[arg(long)]
    best_effort: bool,
    /// Create a compact JSON evidence record. Existing files are never overwritten.
    #[arg(long)]
    evidence: Option<PathBuf>,
}

#[derive(Debug, Deserialize)]
struct SparseProblem {
    label: String,
    coordinate_count: u16,
    physical_checks: Vec<Vec<u16>>,
    logical_observations: Vec<Vec<u16>>,
}

#[derive(Debug, Serialize)]
struct Evidence<'a> {
    schema: &'static str,
    label: &'a str,
    coordinate_count: u16,
    physical_rank: usize,
    logical_observations: usize,
    requested_trials: u64,
    completed_trials: u64,
    target_weight: u16,
    seed: u64,
    threads: usize,
    elapsed_seconds: f64,
    input_sha256: String,
    method: &'static str,
    osd_order: u8,
    osd_window: usize,
    best_effort: bool,
    witness_replayed: Option<bool>,
    result: RandomResult,
}

#[derive(Clone, Debug, Default, Serialize)]
struct RandomResult {
    distance_upper_bound: Option<u16>,
    witness: Vec<u16>,
}

struct WorkerJob {
    assigned: u64,
    workspace: BinaryKernelSearchWorkspace,
}

struct WorkerOutcome {
    completed: u64,
    witness: Vec<u16>,
}

fn sparse_rows(rows: &[Vec<u16>], columns: usize) -> Result<Vec<u64>> {
    let words = columns.div_ceil(64);
    let mut dense = vec![0_u64; rows.len() * words];
    for (row_index, row) in rows.iter().enumerate() {
        for &coordinate in row {
            let coordinate = usize::from(coordinate);
            if coordinate >= columns {
                bail!("coordinate {coordinate} is outside a {columns}-column matrix");
            }
            let entry = &mut dense[row_index * words + coordinate / 64];
            let bit = 1_u64 << (coordinate % 64);
            if *entry & bit != 0 {
                bail!("row {row_index} repeats coordinate {coordinate}");
            }
            *entry |= bit;
        }
    }
    Ok(dense)
}

fn row_count(rows: &[Vec<u16>], kind: &str) -> Result<u16> {
    u16::try_from(rows.len()).with_context(|| format!("too many {kind} rows"))
}

fn verify_sparse_witness(problem: &SparseProblem, witness: &[u16]) -> Result<()> {
    if witness.is_empty() {
        bail!("a reported CSS witness must be nonempty");
    }
    let mut selected = vec![false; usize::from(problem.coordinate_count)];
    for &coordinate in witness {
        let coordinate = usize::from(coordinate);
        if coordinate >= selected.len() || selected[coordinate] {
            bail!("reported CSS witness is repeated or out of range");
        }
        selected[coordinate] = true;
    }
    if problem.physical_checks.iter().any(|row| {
        row.iter()
            .filter(|&&coordinate| selected[usize::from(coordinate)])
            .count()
            & 1
            != 0
    }) {
        bail!("reported CSS witness has nonzero physical syndrome");
    }
    if !problem.logical_observations.iter().any(|row| {
        row.iter()
            .filter(|&&coordinate| selected[usize::from(coordinate)])
            .count()
            & 1
            != 0
    }) {
        bail!("reported CSS witness has zero logical observation");
    }
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    if args.threads == 0 {
        bail!("--threads must be positive");
    }
    if args.trials == 0 {
        bail!("--trials must be positive");
    }
    let osd_window = u16::try_from(args.osd_window).context("--osd-window exceeds 65535")?;
    let options = BinaryKernelTrialOptions::new(args.target_weight, args.osd_order, osd_window)?;

    let mut input_bytes = Vec::new();
    File::open(&args.input)
        .with_context(|| format!("opening input {}", args.input.display()))?
        .read_to_end(&mut input_bytes)?;
    let problem: SparseProblem =
        serde_json::from_slice(&input_bytes).context("parsing sparse CSS problem")?;
    let columns = usize::from(problem.coordinate_count);
    let physical = sparse_rows(&problem.physical_checks, columns)?;
    let logical = sparse_rows(&problem.logical_observations, columns)?;
    let compiled = CompiledBinaryKernelSearch::compile(
        problem.coordinate_count,
        &physical,
        row_count(&problem.physical_checks, "physical")?,
        &logical,
        row_count(&problem.logical_observations, "logical")?,
    )?;

    let pool = rayon::ThreadPoolBuilder::new()
        .num_threads(args.threads)
        .build()
        .context("building worker pool")?;
    let trials_per_worker = args.trials.div_ceil(args.threads as u64);
    let jobs = (0..args.threads)
        .map(|worker_index| {
            let first_trial = worker_index as u64 * trials_per_worker;
            let assigned = args
                .trials
                .saturating_sub(first_trial)
                .min(trials_per_worker);
            let worker_seed =
                args.seed ^ (worker_index as u64 + 1).wrapping_mul(0x9e37_79b9_7f4a_7c15);
            Ok(WorkerJob {
                assigned,
                workspace: compiled.workspace(worker_seed)?,
            })
        })
        .collect::<Result<Vec<_>>>()?;

    let start = Instant::now();
    let outcomes = pool.install(|| {
        jobs.into_par_iter()
            .map(|mut job| {
                let summary = if args.best_effort {
                    job.workspace
                        .search_best_effort(&compiled, job.assigned, options)
                } else {
                    job.workspace
                        .search_targeted(&compiled, job.assigned, options)
                }?;
                Ok(WorkerOutcome {
                    completed: summary.completed_trials,
                    witness: job.workspace.witness().to_vec(),
                })
            })
            .collect::<Result<Vec<_>>>()
    })?;
    let completed = outcomes.iter().map(|outcome| outcome.completed).sum();
    let witness = outcomes
        .into_iter()
        .filter(|outcome| !outcome.witness.is_empty())
        .min_by(|left, right| {
            (left.witness.len(), &left.witness).cmp(&(right.witness.len(), &right.witness))
        })
        .map(|outcome| outcome.witness);
    if let Some(support) = &witness {
        compiled
            .verify_support(support)
            .context("replaying random-search witness through compiled constraints")?;
        verify_sparse_witness(&problem, support)
            .context("independently replaying random-search witness")?;
    }
    let witness_replayed = witness.as_ref().map(|_| true);
    let result = RandomResult {
        distance_upper_bound: witness.as_ref().map(|support| support.len() as u16),
        witness: witness.unwrap_or_default(),
    };
    let evidence = Evidence {
        schema: "ergodis-css-distance-random-is-v4",
        label: &problem.label,
        coordinate_count: problem.coordinate_count,
        physical_rank: usize::from(compiled.rank()),
        logical_observations: usize::from(compiled.logical_observations()),
        requested_trials: args.trials,
        completed_trials: completed,
        target_weight: args.target_weight,
        seed: args.seed,
        threads: args.threads,
        elapsed_seconds: start.elapsed().as_secs_f64(),
        input_sha256: format!("{:x}", Sha256::digest(&input_bytes)),
        method: "random information set; systematic binary kernel; bounded OSD combinations",
        osd_order: args.osd_order,
        osd_window: args.osd_window,
        best_effort: args.best_effort,
        witness_replayed,
        result,
    };
    serde_json::to_writer(std::io::stdout().lock(), &evidence)?;
    println!();
    if let Some(path) = &args.evidence {
        let file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(path)
            .with_context(|| format!("creating evidence file {}", path.display()))?;
        let mut sink = BufWriter::new(file);
        serde_json::to_writer(&mut sink, &evidence)?;
        sink.write_all(b"\n")?;
        sink.flush()?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sparse_rows_reject_out_of_range_and_duplicate_coordinates() {
        assert!(sparse_rows(&[vec![3]], 3).is_err());
        assert!(sparse_rows(&[vec![1, 1]], 3).is_err());
        assert_eq!(sparse_rows(&[vec![0, 2]], 3).unwrap(), vec![0b101]);
    }

    #[test]
    fn sparse_replay_rejects_physical_and_logical_failures() {
        let problem = SparseProblem {
            label: "fixture".into(),
            coordinate_count: 4,
            physical_checks: vec![vec![0, 1]],
            logical_observations: vec![vec![2]],
        };
        verify_sparse_witness(&problem, &[2]).unwrap();
        assert!(verify_sparse_witness(&problem, &[0]).is_err());
        assert!(verify_sparse_witness(&problem, &[0, 1]).is_err());
        assert!(verify_sparse_witness(&problem, &[2, 2]).is_err());
    }
}
