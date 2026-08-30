use anyhow::{bail, Context, Result};
use clap::Parser;
use rayon::prelude::*;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Read, Write};
use std::path::PathBuf;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::Mutex;
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
    result: RandomResult,
}

#[derive(Clone, Debug, Default, Serialize)]
struct RandomResult {
    distance_upper_bound: Option<u16>,
    witness: Vec<u16>,
}

#[derive(Clone, Copy)]
struct XorShift64(u64);

impl XorShift64 {
    fn next(&mut self) -> u64 {
        let mut value = self.0;
        value ^= value >> 12;
        value ^= value << 25;
        value ^= value >> 27;
        self.0 = value;
        value.wrapping_mul(0x2545_f491_4f6c_dd1d)
    }

    fn bounded(&mut self, bound: usize) -> usize {
        ((u128::from(self.next()) * bound as u128) >> 64) as usize
    }
}

fn sparse_rows(rows: &[Vec<u16>], columns: usize) -> Result<(Vec<u64>, usize)> {
    let words = columns.div_ceil(64);
    let mut dense = vec![0u64; rows.len() * words];
    for (row_index, row) in rows.iter().enumerate() {
        for &coordinate in row {
            let coordinate = usize::from(coordinate);
            if coordinate >= columns {
                bail!("coordinate {coordinate} is outside a {columns}-column matrix");
            }
            let entry = &mut dense[row_index * words + coordinate / 64];
            let bit = 1u64 << (coordinate % 64);
            if *entry & bit != 0 {
                bail!("row {row_index} repeats coordinate {coordinate}");
            }
            *entry |= bit;
        }
    }
    Ok((dense, words))
}

fn swap_rows(matrix: &mut [u64], words: usize, left: usize, right: usize) {
    if left == right {
        return;
    }
    let left_start = left * words;
    let right_start = right * words;
    for word in 0..words {
        matrix.swap(left_start + word, right_start + word);
    }
}

fn canonical_row_basis(
    mut matrix: Vec<u64>,
    rows: usize,
    words: usize,
    columns: usize,
) -> Vec<u64> {
    let mut rank = 0usize;
    for column in 0..columns {
        let word = column / 64;
        let bit = 1u64 << (column % 64);
        let Some(pivot) = (rank..rows).find(|&row| matrix[row * words + word] & bit != 0) else {
            continue;
        };
        swap_rows(&mut matrix, words, rank, pivot);
        let pivot_start = rank * words;
        for row in 0..rows {
            if row != rank && matrix[row * words + word] & bit != 0 {
                let row_start = row * words;
                for offset in 0..words {
                    matrix[row_start + offset] ^= matrix[pivot_start + offset];
                }
            }
        }
        rank += 1;
        if rank == rows {
            break;
        }
    }
    matrix.truncate(rank * words);
    matrix
}

fn logical_columns(observations: &[Vec<u16>], columns: usize) -> Result<(Vec<u64>, usize)> {
    let logical_words = observations.len().div_ceil(64);
    let mut result = vec![0u64; columns * logical_words];
    for (observation, row) in observations.iter().enumerate() {
        for &coordinate in row {
            let coordinate = usize::from(coordinate);
            if coordinate >= columns {
                bail!("logical coordinate {coordinate} is outside {columns} columns");
            }
            result[coordinate * logical_words + observation / 64] ^= 1u64 << (observation % 64);
        }
    }
    Ok((result, logical_words))
}

struct Worker {
    rng: XorShift64,
    work: Vec<u64>,
    order: Vec<u16>,
    pivots: Vec<u16>,
    pivot_marker: Vec<u8>,
    logical_value: Vec<u64>,
    witness: Vec<u16>,
}

impl Worker {
    fn new(base_len: usize, columns: usize, rank: usize, logical_words: usize, seed: u64) -> Self {
        Self {
            rng: XorShift64(seed | 1),
            work: vec![0; base_len],
            order: (0..columns as u16).collect(),
            pivots: vec![0; rank],
            pivot_marker: vec![0; columns],
            logical_value: vec![0; logical_words],
            witness: Vec::with_capacity(rank + 1),
        }
    }

    fn shuffle(&mut self) {
        for (index, entry) in self.order.iter_mut().enumerate() {
            *entry = index as u16;
        }
        for upper in (1..self.order.len()).rev() {
            let other = self.rng.bounded(upper + 1);
            self.order.swap(upper, other);
        }
    }

    fn trial(
        &mut self,
        base: &[u64],
        words: usize,
        rank: usize,
        logical_columns: &[u64],
        logical_words: usize,
        target_weight: usize,
    ) -> Option<Vec<u16>> {
        self.work.copy_from_slice(base);
        self.shuffle();
        self.pivot_marker.fill(0);
        let mut pivot_count = 0usize;
        for &column in &self.order {
            let column = usize::from(column);
            let word = column / 64;
            let bit = 1u64 << (column % 64);
            let Some(pivot) =
                (pivot_count..rank).find(|&row| self.work[row * words + word] & bit != 0)
            else {
                continue;
            };
            swap_rows(&mut self.work, words, pivot_count, pivot);
            let pivot_start = pivot_count * words;
            for row in 0..rank {
                if row != pivot_count && self.work[row * words + word] & bit != 0 {
                    let row_start = row * words;
                    for offset in 0..words {
                        self.work[row_start + offset] ^= self.work[pivot_start + offset];
                    }
                }
            }
            self.pivots[pivot_count] = column as u16;
            self.pivot_marker[column] = 1;
            pivot_count += 1;
            if pivot_count == rank {
                break;
            }
        }
        debug_assert_eq!(pivot_count, rank);

        for &free in &self.order {
            let free = usize::from(free);
            if self.pivot_marker[free] != 0 {
                continue;
            }
            let word = free / 64;
            let bit = 1u64 << (free % 64);
            let mut weight = 1usize;
            for row in 0..rank {
                weight += usize::from(self.work[row * words + word] & bit != 0);
                if weight > target_weight {
                    break;
                }
            }
            if weight > target_weight {
                continue;
            }

            self.logical_value.fill(0);
            self.witness.clear();
            self.witness.push(free as u16);
            let free_logical = free * logical_words;
            for (left, &right) in self
                .logical_value
                .iter_mut()
                .zip(&logical_columns[free_logical..free_logical + logical_words])
            {
                *left = right;
            }
            for row in 0..rank {
                if self.work[row * words + word] & bit == 0 {
                    continue;
                }
                let pivot = usize::from(self.pivots[row]);
                self.witness.push(pivot as u16);
                let start = pivot * logical_words;
                for (left, &right) in self
                    .logical_value
                    .iter_mut()
                    .zip(&logical_columns[start..start + logical_words])
                {
                    *left ^= right;
                }
            }
            if self.logical_value.iter().any(|&word| word != 0) {
                self.witness.sort_unstable();
                return Some(self.witness.clone());
            }
        }
        None
    }
}

fn main() -> Result<()> {
    let args = Args::parse();
    if args.threads == 0 {
        bail!("--threads must be positive");
    }
    if args.trials == 0 {
        bail!("--trials must be positive");
    }
    let mut input_bytes = Vec::new();
    File::open(&args.input)
        .with_context(|| format!("opening input {}", args.input.display()))?
        .read_to_end(&mut input_bytes)?;
    let problem: SparseProblem =
        serde_json::from_slice(&input_bytes).context("parsing sparse CSS problem")?;
    let columns = usize::from(problem.coordinate_count);
    let (physical, words) = sparse_rows(&problem.physical_checks, columns)?;
    let basis = canonical_row_basis(physical, problem.physical_checks.len(), words, columns);
    let rank = basis.len() / words;
    let (logical_columns, logical_words) = logical_columns(&problem.logical_observations, columns)?;
    let pool = rayon::ThreadPoolBuilder::new()
        .num_threads(args.threads)
        .build()
        .context("building worker pool")?;
    let stop = AtomicBool::new(false);
    let completed = AtomicU64::new(0);
    let winner = Mutex::new(None::<Vec<u16>>);
    let trials_per_worker = args.trials.div_ceil(args.threads as u64);
    let start = Instant::now();
    pool.install(|| {
        (0..args.threads).into_par_iter().for_each(|worker_index| {
            let first_trial = worker_index as u64 * trials_per_worker;
            let assigned = args
                .trials
                .saturating_sub(first_trial)
                .min(trials_per_worker);
            let worker_seed =
                args.seed ^ (worker_index as u64 + 1).wrapping_mul(0x9e37_79b9_7f4a_7c15);
            let mut worker = Worker::new(basis.len(), columns, rank, logical_words, worker_seed);
            for _ in 0..assigned {
                if stop.load(Ordering::Relaxed) {
                    break;
                }
                let found = worker.trial(
                    &basis,
                    words,
                    rank,
                    &logical_columns,
                    logical_words,
                    usize::from(args.target_weight),
                );
                completed.fetch_add(1, Ordering::Relaxed);
                if let Some(witness) = found {
                    if !stop.swap(true, Ordering::Relaxed) {
                        *winner.lock().expect("winner mutex poisoned") = Some(witness);
                    }
                    break;
                }
            }
        });
    });
    let witness = winner.into_inner().expect("winner mutex poisoned");
    let result = RandomResult {
        distance_upper_bound: witness.as_ref().map(|support| support.len() as u16),
        witness: witness.unwrap_or_default(),
    };
    let evidence = Evidence {
        schema: "ergodis-css-distance-random-is-v1",
        label: &problem.label,
        coordinate_count: problem.coordinate_count,
        physical_rank: rank,
        logical_observations: problem.logical_observations.len(),
        requested_trials: args.trials,
        completed_trials: completed.load(Ordering::Relaxed),
        target_weight: args.target_weight,
        seed: args.seed,
        threads: args.threads,
        elapsed_seconds: start.elapsed().as_secs_f64(),
        input_sha256: format!("{:x}", Sha256::digest(&input_bytes)),
        method: "random column order; systematic parity-check basis; inspect induced kernel basis",
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
    fn systematic_trial_finds_nontrivial_free_coordinate() {
        let rows = vec![vec![0, 1]];
        let (physical, words) = sparse_rows(&rows, 3).unwrap();
        let basis = canonical_row_basis(physical, rows.len(), words, 3);
        let observations = vec![vec![2]];
        let (logical, logical_words) = logical_columns(&observations, 3).unwrap();
        let mut worker = Worker::new(basis.len(), 3, 1, logical_words, 7);
        let witness = worker.trial(&basis, words, 1, &logical, logical_words, 1);
        assert_eq!(witness, Some(vec![2]));
    }

    #[test]
    fn systematic_trial_rejects_stabilizer_only_kernel_rows() {
        let rows = vec![vec![0, 1]];
        let (physical, words) = sparse_rows(&rows, 2).unwrap();
        let basis = canonical_row_basis(physical, rows.len(), words, 2);
        let observations = vec![Vec::new()];
        let (logical, logical_words) = logical_columns(&observations, 2).unwrap();
        let mut worker = Worker::new(basis.len(), 2, 1, logical_words, 11);
        assert_eq!(
            worker.trial(&basis, words, 1, &logical, logical_words, 2),
            None
        );
    }
}
