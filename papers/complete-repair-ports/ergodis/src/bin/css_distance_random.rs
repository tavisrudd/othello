use anyhow::{bail, Context, Result};
use clap::Parser;
use rayon::prelude::*;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Read, Write};
use std::path::PathBuf;
use std::sync::atomic::{AtomicBool, Ordering};
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

fn verify_witness(problem: &SparseProblem, witness: &[u16]) -> Result<()> {
    if witness.is_empty() {
        bail!("a reported CSS witness must be nonempty");
    }
    let columns = usize::from(problem.coordinate_count);
    let mut selected = vec![false; columns];
    for &coordinate in witness {
        let coordinate = usize::from(coordinate);
        if coordinate >= columns || selected[coordinate] {
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

    #[cfg(test)]
    fn trial<'a>(&'a mut self, spec: TrialSpec<'_>) -> Option<&'a [u16]> {
        self.trial_impl::<false>(spec, spec.target_weight + 1)
    }

    #[cfg(test)]
    fn trial_best<'a>(
        &'a mut self,
        spec: TrialSpec<'_>,
        incumbent_weight: usize,
    ) -> Option<&'a [u16]> {
        self.trial_impl::<true>(spec, incumbent_weight)
    }

    fn trial_impl<'a, const RETAIN_BEST: bool>(
        &'a mut self,
        spec: TrialSpec<'_>,
        incumbent_weight: usize,
    ) -> Option<&'a [u16]> {
        let TrialSpec {
            base,
            words,
            rank,
            logical_columns,
            logical_words,
            target_weight: _,
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
        let mut best_weight = incumbent_weight;
        let mut improved = false;
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
            if usize::from(weight) < best_weight && logical.iter().any(|&word| word != 0) {
                self.witness.clear();
                for coordinate in 0..self.order.len() {
                    if kernel[coordinate / 64] & (1u64 << (coordinate % 64)) != 0 {
                        self.witness.push(coordinate as u16);
                    }
                }
                if !RETAIN_BEST {
                    return Some(&self.witness);
                }
                best_weight = usize::from(weight);
                improved = true;
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
                        if weight >= best_weight {
                            break;
                        }
                    }
                    if weight >= best_weight {
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
                    if !RETAIN_BEST {
                        return Some(&self.witness);
                    }
                    best_weight = weight;
                    improved = true;
                }
            }
        }
        improved.then_some(&self.witness)
    }
}

struct WorkerOutcome {
    completed: u64,
    witness: Vec<u16>,
}

fn run_worker<const RETAIN_BEST: bool>(
    assigned: u64,
    worker_seed: u64,
    columns: usize,
    rank: usize,
    spec: TrialSpec<'_>,
    stop: &AtomicBool,
) -> WorkerOutcome {
    let mut worker = Worker::new(
        spec.base.len(),
        columns,
        rank,
        spec.words,
        spec.logical_words,
        worker_seed,
    );
    let mut local_completed = 0_u64;
    let mut local_best = Vec::with_capacity(columns);
    let mut local_bound = columns + 1;
    for _ in 0..assigned {
        if local_completed & 63 == 0 && stop.load(Ordering::Relaxed) {
            break;
        }
        let bound = if RETAIN_BEST {
            local_bound
        } else {
            spec.target_weight + 1
        };
        let found = worker.trial_impl::<RETAIN_BEST>(spec, bound);
        local_completed += 1;
        if let Some(witness) = found {
            if witness.len() < local_bound {
                local_bound = witness.len();
                local_best.clear();
                local_best.extend_from_slice(witness);
            }
            if witness.len() <= spec.target_weight {
                stop.store(true, Ordering::Relaxed);
                break;
            }
        }
    }
    WorkerOutcome {
        completed: local_completed,
        witness: local_best,
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
    let trials_per_worker = args.trials.div_ceil(args.threads as u64);
    let start = Instant::now();
    let run = |worker_index| {
        let first_trial = worker_index as u64 * trials_per_worker;
        let assigned = args
            .trials
            .saturating_sub(first_trial)
            .min(trials_per_worker);
        let worker_seed = args.seed ^ (worker_index as u64 + 1).wrapping_mul(0x9e37_79b9_7f4a_7c15);
        (
            assigned,
            worker_seed,
            TrialSpec {
                base: &basis,
                words,
                rank,
                logical_columns: &logical_columns,
                logical_words,
                target_weight: usize::from(args.target_weight),
                osd_order: args.osd_order,
                osd_window: args.osd_window,
            },
        )
    };
    let outcomes = pool.install(|| {
        if args.best_effort {
            (0..args.threads)
                .into_par_iter()
                .map(|worker_index| {
                    let (assigned, worker_seed, spec) = run(worker_index);
                    run_worker::<true>(assigned, worker_seed, columns, rank, spec, &stop)
                })
                .collect::<Vec<_>>()
        } else {
            (0..args.threads)
                .into_par_iter()
                .map(|worker_index| {
                    let (assigned, worker_seed, spec) = run(worker_index);
                    run_worker::<false>(assigned, worker_seed, columns, rank, spec, &stop)
                })
                .collect::<Vec<_>>()
        }
    });
    let completed = outcomes
        .iter()
        .map(|outcome| outcome.completed)
        .sum::<u64>();
    let witness = outcomes
        .into_iter()
        .filter(|outcome| !outcome.witness.is_empty())
        .min_by(|left, right| {
            (left.witness.len(), &left.witness).cmp(&(right.witness.len(), &right.witness))
        })
        .map(|outcome| outcome.witness);
    if let Some(support) = &witness {
        verify_witness(&problem, support)
            .context("independently replaying random-search witness")?;
    }
    let witness_replayed = witness.as_ref().map(|_| true);
    let result = RandomResult {
        distance_upper_bound: witness.as_ref().map(|support| support.len() as u16),
        witness: witness.unwrap_or_default(),
    };
    let evidence = Evidence {
        schema: "ergodis-css-distance-random-is-v3",
        label: &problem.label,
        coordinate_count: problem.coordinate_count,
        physical_rank: rank,
        logical_observations: problem.logical_observations.len(),
        requested_trials: args.trials,
        completed_trials: completed,
        target_weight: args.target_weight,
        seed: args.seed,
        threads: args.threads,
        elapsed_seconds: start.elapsed().as_secs_f64(),
        input_sha256: format!("{:x}", Sha256::digest(&input_bytes)),
        method: "random information set; systematic kernel basis; bounded OSD combinations",
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
    use std::alloc::{GlobalAlloc, Layout, System};
    use std::cell::Cell;

    struct CountingAllocator;

    thread_local! {
        static COUNTING: Cell<bool> = const { Cell::new(false) };
        static EVENTS: Cell<(u64, u64, u64)> = const { Cell::new((0, 0, 0)) };
    }

    fn count_event(slot: usize) {
        let _ = COUNTING.try_with(|counting| {
            if counting.get() {
                EVENTS.with(|events| {
                    let mut counts = events.get();
                    match slot {
                        0 => counts.0 += 1,
                        1 => counts.1 += 1,
                        _ => counts.2 += 1,
                    }
                    events.set(counts);
                });
            }
        });
    }

    unsafe impl GlobalAlloc for CountingAllocator {
        unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
            count_event(0);
            // SAFETY: this allocator only observes calls before delegating unchanged.
            unsafe { System.alloc(layout) }
        }

        unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
            count_event(0);
            // SAFETY: this allocator only observes calls before delegating unchanged.
            unsafe { System.alloc_zeroed(layout) }
        }

        unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, size: usize) -> *mut u8 {
            count_event(1);
            // SAFETY: pointer, layout, and size are forwarded unchanged to System.
            unsafe { System.realloc(ptr, layout, size) }
        }

        unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
            count_event(2);
            // SAFETY: pointer and layout are forwarded unchanged to System.
            unsafe { System.dealloc(ptr, layout) }
        }
    }

    #[global_allocator]
    static ALLOCATOR: CountingAllocator = CountingAllocator;

    fn measure_allocations<T>(operation: impl FnOnce() -> T) -> (T, (u64, u64, u64)) {
        EVENTS.with(|events| events.set((0, 0, 0)));
        COUNTING.with(|counting| counting.set(true));
        let result = operation();
        COUNTING.with(|counting| counting.set(false));
        (result, EVENTS.with(Cell::get))
    }

    #[test]
    fn witness_replay_rejects_physical_and_logical_failures() {
        let problem = SparseProblem {
            label: "fixture".to_owned(),
            coordinate_count: 4,
            physical_checks: vec![vec![0, 1]],
            logical_observations: vec![vec![2]],
        };
        verify_witness(&problem, &[2]).unwrap();
        assert!(verify_witness(&problem, &[0]).is_err());
        assert!(verify_witness(&problem, &[0, 1]).is_err());
        assert!(verify_witness(&problem, &[2, 2]).is_err());
    }

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

    #[test]
    fn best_effort_retains_a_witness_above_the_stop_target() {
        let rows = vec![vec![0, 1]];
        let (physical, words) = sparse_rows(&rows, 3).unwrap();
        let basis = canonical_row_basis(physical, rows.len(), words, 3);
        let observations = vec![vec![0]];
        let (logical, logical_words) = logical_columns(&observations, 3).unwrap();
        let spec = TrialSpec {
            base: &basis,
            words,
            rank: 1,
            logical_columns: &logical,
            logical_words,
            target_weight: 1,
            osd_order: 2,
            osd_window: 16,
        };
        let mut targeted = Worker::new(basis.len(), 3, 1, words, logical_words, 7);
        assert_eq!(targeted.trial(spec), None);
        let mut best_effort = Worker::new(basis.len(), 3, 1, words, logical_words, 7);
        assert_eq!(best_effort.trial_best(spec, 4), Some(&[0, 1][..]));
    }

    #[test]
    fn repeated_upper_bound_trials_allocate_nothing() {
        let rows = vec![vec![0, 1, 2, 3], vec![1, 2, 4, 5], vec![0, 3, 4, 5]];
        let (physical, words) = sparse_rows(&rows, 8).unwrap();
        let basis = canonical_row_basis(physical, rows.len(), words, 8);
        let observations = vec![vec![0, 2, 4, 6], vec![1, 3, 5, 7]];
        let (logical, logical_words) = logical_columns(&observations, 8).unwrap();
        let spec = TrialSpec {
            base: &basis,
            words,
            rank: basis.len() / words,
            logical_columns: &logical,
            logical_words,
            target_weight: 1,
            osd_order: 2,
            osd_window: 8,
        };
        let mut worker = Worker::new(basis.len(), 8, spec.rank, words, logical_words, 17);
        let (_, events) = measure_allocations(|| {
            for _ in 0..256 {
                let _ = worker.trial_impl::<true>(spec, 9);
            }
        });
        assert_eq!(events, (0, 0, 0));
    }
}
