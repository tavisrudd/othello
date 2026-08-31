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
    /// Ordered-statistics combination order (1 or 2).
    #[arg(long, default_value_t = 2)]
    osd_order: u8,
    /// Number of lightest systematic kernel rows admitted to order-2 combinations.
    #[arg(long, default_value_t = 96)]
    osd_window: usize,
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
    kernel_rows: Vec<u64>,
    kernel_logicals: Vec<u64>,
    kernel_weights: Vec<u16>,
    kernel_order: Vec<u16>,
    witness: Vec<u16>,
}

#[derive(Clone, Copy)]
struct TrialSpec<'a> {
    base: &'a [u64],
    words: usize,
    rank: usize,
    logical_columns: &'a [u64],
    logical_words: usize,
    target_weight: usize,
    osd_order: u8,
    osd_window: usize,
}

impl Worker {
    fn new(
        base_len: usize,
        columns: usize,
        rank: usize,
        words: usize,
        logical_words: usize,
        seed: u64,
    ) -> Self {
        let free_count = columns - rank;
        Self {
            rng: XorShift64(seed | 1),
            work: vec![0; base_len],
            order: (0..columns as u16).collect(),
            pivots: vec![0; rank],
            pivot_marker: vec![0; columns],
            kernel_rows: vec![0; free_count * words],
            kernel_logicals: vec![0; free_count * logical_words],
            kernel_weights: vec![0; free_count],
            kernel_order: vec![0; free_count],
            witness: Vec::with_capacity(columns),
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

    fn trial<'a>(&'a mut self, spec: TrialSpec<'_>) -> Option<&'a [u16]> {
        let TrialSpec {
            base,
            words,
            rank,
            logical_columns,
            logical_words,
            target_weight,
            osd_order,
            osd_window,
        } = spec;
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

        let mut kernel_count = 0usize;
        for &free in &self.order {
            let free = usize::from(free);
            if self.pivot_marker[free] != 0 {
                continue;
            }
            let word = free / 64;
            let bit = 1u64 << (free % 64);
            let kernel = &mut self.kernel_rows[kernel_count * words..(kernel_count + 1) * words];
            kernel.fill(0);
            kernel[word] |= bit;
            let logical = &mut self.kernel_logicals
                [kernel_count * logical_words..(kernel_count + 1) * logical_words];
            logical.fill(0);
            let free_logical = free * logical_words;
            logical.copy_from_slice(&logical_columns[free_logical..free_logical + logical_words]);
            for row in 0..rank {
                if self.work[row * words + word] & bit == 0 {
                    continue;
                }
                let pivot = usize::from(self.pivots[row]);
                kernel[pivot / 64] |= 1u64 << (pivot % 64);
                let start = pivot * logical_words;
                for (left, &right) in logical
                    .iter_mut()
                    .zip(&logical_columns[start..start + logical_words])
                {
                    *left ^= right;
                }
            }
            let weight = kernel.iter().map(|word| word.count_ones() as u16).sum();
            self.kernel_weights[kernel_count] = weight;
            self.kernel_order[kernel_count] = kernel_count as u16;
            if usize::from(weight) <= target_weight && logical.iter().any(|&word| word != 0) {
                self.witness.clear();
                for coordinate in 0..self.order.len() {
                    if kernel[coordinate / 64] & (1u64 << (coordinate % 64)) != 0 {
                        self.witness.push(coordinate as u16);
                    }
                }
                return Some(&self.witness);
            }
            kernel_count += 1;
        }
        if osd_order >= 2 {
            self.kernel_order[..kernel_count]
                .sort_unstable_by_key(|&index| self.kernel_weights[index as usize]);
            let window = kernel_count.min(osd_window);
            for left_position in 0..window {
                let left = self.kernel_order[left_position] as usize;
                let left_words = &self.kernel_rows[left * words..(left + 1) * words];
                let left_logical =
                    &self.kernel_logicals[left * logical_words..(left + 1) * logical_words];
                for right_position in left_position + 1..window {
                    let right = self.kernel_order[right_position] as usize;
                    let right_words = &self.kernel_rows[right * words..(right + 1) * words];
                    let mut weight = 0usize;
                    for (&left_word, &right_word) in left_words.iter().zip(right_words) {
                        weight += (left_word ^ right_word).count_ones() as usize;
                        if weight > target_weight {
                            break;
                        }
                    }
                    if weight > target_weight {
                        continue;
                    }
                    let right_logical =
                        &self.kernel_logicals[right * logical_words..(right + 1) * logical_words];
                    if !left_logical
                        .iter()
                        .zip(right_logical)
                        .any(|(&a, &b)| a ^ b != 0)
                    {
                        continue;
                    }
                    self.witness.clear();
                    for coordinate in 0..self.order.len() {
                        let bit = 1u64 << (coordinate % 64);
                        if (left_words[coordinate / 64] ^ right_words[coordinate / 64]) & bit != 0 {
                            self.witness.push(coordinate as u16);
                        }
                    }
                    return Some(&self.witness);
                }
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
    if !(1..=2).contains(&args.osd_order) {
        bail!("--osd-order must be 1 or 2");
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
            let mut worker = Worker::new(
                basis.len(),
                columns,
                rank,
                words,
                logical_words,
                worker_seed,
            );
            for _ in 0..assigned {
                if stop.load(Ordering::Relaxed) {
                    break;
                }
                let found = worker.trial(TrialSpec {
                    base: &basis,
                    words,
                    rank,
                    logical_columns: &logical_columns,
                    logical_words,
                    target_weight: usize::from(args.target_weight),
                    osd_order: args.osd_order,
                    osd_window: args.osd_window,
                });
                completed.fetch_add(1, Ordering::Relaxed);
                if let Some(witness) = found {
                    if !stop.swap(true, Ordering::Relaxed) {
                        *winner.lock().expect("winner mutex poisoned") = Some(witness.to_vec());
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
        schema: "ergodis-css-distance-random-is-v2",
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
        method: "random information set; systematic kernel basis; bounded OSD combinations",
        osd_order: args.osd_order,
        osd_window: args.osd_window,
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
        let mut worker = Worker::new(basis.len(), 3, 1, words, logical_words, 7);
        let witness = worker.trial(TrialSpec {
            base: &basis,
            words,
            rank: 1,
            logical_columns: &logical,
            logical_words,
            target_weight: 1,
            osd_order: 2,
            osd_window: 16,
        });
        assert_eq!(witness, Some(&[2][..]));
    }

    #[test]
    fn systematic_trial_rejects_stabilizer_only_kernel_rows() {
        let rows = vec![vec![0, 1]];
        let (physical, words) = sparse_rows(&rows, 2).unwrap();
        let basis = canonical_row_basis(physical, rows.len(), words, 2);
        let observations = vec![Vec::new()];
        let (logical, logical_words) = logical_columns(&observations, 2).unwrap();
        let mut worker = Worker::new(basis.len(), 2, 1, words, logical_words, 11);
        assert_eq!(
            worker.trial(TrialSpec {
                base: &basis,
                words,
                rank: 1,
                logical_columns: &logical,
                logical_words,
                target_weight: 2,
                osd_order: 2,
                osd_window: 16,
            }),
            None
        );
    }

    #[test]
    fn order_two_combination_can_beat_every_systematic_basis_row() {
        let rows = vec![vec![0, 2, 3], vec![1, 2, 3]];
        let (physical, words) = sparse_rows(&rows, 4).unwrap();
        let basis = canonical_row_basis(physical, rows.len(), words, 4);
        let observations = vec![vec![2]];
        let (logical, logical_words) = logical_columns(&observations, 4).unwrap();
        let witness = (1..1000).find_map(|seed| {
            let mut order_one = Worker::new(basis.len(), 4, 2, words, logical_words, seed);
            if order_one
                .trial(TrialSpec {
                    base: &basis,
                    words,
                    rank: 2,
                    logical_columns: &logical,
                    logical_words,
                    target_weight: 2,
                    osd_order: 1,
                    osd_window: 4,
                })
                .is_some()
            {
                return None;
            }
            let mut order_two = Worker::new(basis.len(), 4, 2, words, logical_words, seed);
            order_two
                .trial(TrialSpec {
                    base: &basis,
                    words,
                    rank: 2,
                    logical_columns: &logical,
                    logical_words,
                    target_weight: 2,
                    osd_order: 2,
                    osd_window: 4,
                })
                .map(<[u16]>::to_vec)
        });
        assert_eq!(witness, Some(vec![2, 3]));
    }
}
