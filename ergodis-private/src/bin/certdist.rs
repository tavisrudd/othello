//! `certdist` — a certified exact minimum-distance service prototype.
//!
//! This binary is a *job-level driver* around the Ergodis CSS distance tools. It
//! adds nothing to the mathematics: every exhaustion is performed by the core's
//! own `css_distance_native`, driven as a subprocess exactly as shipped. What it
//! adds is the operational layer:
//!
//! * a live `[lower, upper]` bracket with per-side provenance, so an interrupted
//!   job still yields a usable answer;
//! * a pluggable, always-recorded upper-bound pass (a built-in multi-threaded
//!   ordered-statistics information-set decoder, the core's own witness finder,
//!   or an arbitrary external command);
//! * durable resume built on the core's deterministic search sharding, so a
//!   multi-hour radius survives a session or machine boundary;
//! * a canonical JSON certificate and a `verify` mode whose cost is measured
//!   against production cost;
//! * an up-front feasibility estimate obtained by *sampling* shards of the
//!   target radius rather than extrapolating a growth model.
//!
//! Nothing under `papers/complete-repair-ports/ergodis/` is read at run time
//! except the two shipped binaries.

use anyhow::{bail, Context, Result};
use clap::{Args as ClapArgs, Parser, Subcommand};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::BTreeSet;
use std::fs;
use std::io::Write as _;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};

// ---------------------------------------------------------------------------
// GF(2) helpers
// ---------------------------------------------------------------------------

#[inline]
fn words_for(columns: usize) -> usize {
    columns.div_ceil(64)
}

fn bits_from(indices: &[u16], words: usize) -> Vec<u64> {
    let mut out = vec![0u64; words];
    for &index in indices {
        let index = usize::from(index);
        out[index / 64] |= 1u64 << (index % 64);
    }
    out
}

#[inline]
fn bit_set(bits: &[u64], index: usize) -> bool {
    bits[index / 64] >> (index % 64) & 1 == 1
}

#[inline]
fn set_bit(bits: &mut [u64], index: usize) {
    bits[index / 64] |= 1u64 << (index % 64);
}

#[inline]
fn xor_assign(target: &mut [u64], source: &[u64]) {
    for (left, &right) in target.iter_mut().zip(source.iter()) {
        *left ^= right;
    }
}

#[inline]
fn popcount(bits: &[u64]) -> u32 {
    bits.iter().map(|word| word.count_ones()).sum()
}

#[inline]
fn is_zero(bits: &[u64]) -> bool {
    bits.iter().all(|&word| word == 0)
}

/// A GF(2) row-echelon basis, used for rank and row-space membership.
struct Echelon {
    words: usize,
    pivots: Vec<Option<Vec<u64>>>,
}

impl Echelon {
    fn new(columns: usize) -> Self {
        Self {
            words: words_for(columns),
            pivots: vec![None; columns],
        }
    }

    /// Reduce `row` against the basis. Returns `Some(pivot)` when the row was
    /// independent and has been absorbed, `None` when it reduced to zero.
    fn insert(&mut self, mut row: Vec<u64>) -> Option<usize> {
        loop {
            let Some(pivot) = self.leading(&row) else {
                return None;
            };
            match &self.pivots[pivot] {
                None => {
                    self.pivots[pivot] = Some(row);
                    return Some(pivot);
                }
                Some(prior) => xor_assign(&mut row, prior),
            }
        }
    }

    fn reduces_to_zero(&self, mut row: Vec<u64>) -> bool {
        loop {
            let Some(pivot) = self.leading(&row) else {
                return true;
            };
            match &self.pivots[pivot] {
                None => return false,
                Some(prior) => xor_assign(&mut row, prior),
            }
        }
    }

    fn leading(&self, row: &[u64]) -> Option<usize> {
        debug_assert_eq!(row.len(), self.words);
        row.iter()
            .rposition(|&word| word != 0)
            .map(|word| 64 * word + 63 - row[word].leading_zeros() as usize)
    }

    fn rank(&self) -> usize {
        self.pivots.iter().filter(|slot| slot.is_some()).count()
    }
}

fn echelon_of(rows: &[Vec<u16>], columns: usize) -> Echelon {
    let words = words_for(columns);
    let mut echelon = Echelon::new(columns);
    for row in rows {
        echelon.insert(bits_from(row, words));
    }
    echelon
}

// ---------------------------------------------------------------------------
// Problem input (the Ergodis native sparse CSS format, read-only)
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Deserialize, Serialize)]
struct SparseProblem {
    label: String,
    coordinate_count: u16,
    physical_checks: Vec<Vec<u16>>,
    logical_observations: Vec<Vec<u16>>,
    anchors: Vec<u16>,
    maximum_weight: u16,
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    incumbent_support: Vec<u16>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    metadata: Option<serde_json::Value>,
}

/// Structural facts recomputed from the input alone. Everything here is cheap
/// and is re-derived by `verify`, so none of it has to be trusted.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
struct CodeIdentity {
    label: String,
    coordinate_count: u16,
    physical_check_rows: usize,
    physical_rank: usize,
    kernel_dimension: usize,
    logical_observation_rows: usize,
    logical_rank: usize,
    anchor_count: usize,
    anchor_reduction_factor_numerator: usize,
    anchor_reduction_factor_denominator: usize,
    all_ones_in_physical_row_space: bool,
    input_sha256: String,
    input_bytes: usize,
}

impl CodeIdentity {
    fn derive(problem: &SparseProblem, raw: &[u8]) -> Self {
        let columns = usize::from(problem.coordinate_count);
        let physical = echelon_of(&problem.physical_checks, columns);
        let physical_rank = physical.rank();
        let logical_rank = echelon_of(&problem.logical_observations, columns).rank();
        let all_ones = {
            let words = words_for(columns);
            let mut row = vec![0u64; words];
            for index in 0..columns {
                set_bit(&mut row, index);
            }
            physical.reduces_to_zero(row)
        };
        Self {
            label: problem.label.clone(),
            coordinate_count: problem.coordinate_count,
            physical_check_rows: problem.physical_checks.len(),
            physical_rank,
            kernel_dimension: columns - physical_rank,
            logical_observation_rows: problem.logical_observations.len(),
            logical_rank,
            anchor_count: problem.anchors.len(),
            anchor_reduction_factor_numerator: columns,
            anchor_reduction_factor_denominator: problem.anchors.len().max(1),
            all_ones_in_physical_row_space: all_ones,
            input_sha256: hex_digest(raw),
            input_bytes: raw.len(),
        }
    }

    fn anchor_reduction(&self) -> f64 {
        self.anchor_reduction_factor_numerator as f64
            / self.anchor_reduction_factor_denominator as f64
    }
}

fn hex_digest(bytes: &[u8]) -> String {
    let mut hasher = Sha256::new();
    hasher.update(bytes);
    hasher
        .finalize()
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect()
}

fn load_problem(path: &Path) -> Result<(SparseProblem, Vec<u8>)> {
    let raw = fs::read(path).with_context(|| format!("reading input {}", path.display()))?;
    let problem: SparseProblem =
        serde_json::from_slice(&raw).with_context(|| format!("parsing {}", path.display()))?;
    Ok((problem, raw))
}

/// Independent re-verification that a support really is a logical operator.
/// This is the only part of an upper bound that has to be believed, and it is
/// recomputed from the input by both `run` and `verify`.
fn classify_support(problem: &SparseProblem, support: &[u16]) -> Result<SupportCheck> {
    let columns = usize::from(problem.coordinate_count);
    let words = words_for(columns);
    let mut seen = BTreeSet::new();
    for &coordinate in support {
        if usize::from(coordinate) >= columns {
            bail!("support coordinate {coordinate} is outside the code");
        }
        if !seen.insert(coordinate) {
            bail!("support repeats coordinate {coordinate}");
        }
    }
    let vector = bits_from(support, words);
    let mut violated = 0usize;
    for row in &problem.physical_checks {
        let row_bits = bits_from(row, words);
        let mut parity = 0u32;
        for (left, right) in vector.iter().zip(row_bits.iter()) {
            parity ^= (left & right).count_ones();
        }
        violated += usize::from(parity & 1 == 1);
    }
    let mut triggered = 0usize;
    for row in &problem.logical_observations {
        let row_bits = bits_from(row, words);
        let mut parity = 0u32;
        for (left, right) in vector.iter().zip(row_bits.iter()) {
            parity ^= (left & right).count_ones();
        }
        triggered += usize::from(parity & 1 == 1);
    }
    Ok(SupportCheck {
        weight: support.len(),
        physical_checks_violated: violated,
        logical_observations_triggered: triggered,
        is_logical_operator: violated == 0 && triggered > 0,
    })
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
struct SupportCheck {
    weight: usize,
    physical_checks_violated: usize,
    logical_observations_triggered: usize,
    is_logical_operator: bool,
}

// ---------------------------------------------------------------------------
// Core run records
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Deserialize, Serialize)]
struct NativeStats {
    candidates: u64,
    connected_supports: u64,
    kernel_supports: u64,
    nontrivial_supports: u64,
    maximum_depth: u16,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
struct NativeResult {
    distance: Option<u16>,
    witness: Vec<u16>,
    searched_maximum_weight: u16,
    stats: NativeStats,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
struct NativeShardId {
    index: u32,
    count: u32,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
struct NativeRecord {
    schema: String,
    label: String,
    coordinate_count: u16,
    maximum_weight: u16,
    mode: String,
    preparation_mode: String,
    #[serde(default)]
    artifact_payload_blake3: Option<String>,
    search_kernel: String,
    threads: usize,
    result_scope: String,
    #[serde(default)]
    search_shard: Option<NativeShardId>,
    search_seconds: Vec<f64>,
    result: NativeResult,
}

// ---------------------------------------------------------------------------
// Child process driving, with peak-RSS sampling
// ---------------------------------------------------------------------------

struct ChildOutcome {
    stdout: Vec<u8>,
    stderr: String,
    wall_seconds: f64,
    peak_rss_kib: u64,
    success: bool,
}

/// Run a child to completion, sampling `/proc/<pid>/status` VmHWM every 100 ms
/// so the reported peak resident set is the kernel's own high-water mark rather
/// than an estimate. A child that exits between samples still reports its final
/// VmHWM if the last sample lands; the figure is therefore a lower bound on the
/// true peak and is labelled as sampled everywhere it is reported.
fn run_child(program: &Path, args: &[String]) -> Result<ChildOutcome> {
    let start = Instant::now();
    let child = Command::new(program)
        .args(args)
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .with_context(|| format!("spawning {}", program.display()))?;
    let pid = child.id();
    let done = Arc::new(AtomicBool::new(false));
    let peak = Arc::new(AtomicU64::new(0));
    let sampler = {
        let done = Arc::clone(&done);
        let peak = Arc::clone(&peak);
        std::thread::spawn(move || {
            while !done.load(Ordering::Relaxed) {
                if let Ok(status) = fs::read_to_string(format!("/proc/{pid}/status")) {
                    for line in status.lines() {
                        if let Some(rest) = line.strip_prefix("VmHWM:") {
                            if let Some(value) = rest.split_whitespace().next() {
                                if let Ok(kib) = value.parse::<u64>() {
                                    peak.fetch_max(kib, Ordering::Relaxed);
                                }
                            }
                        }
                    }
                }
                std::thread::sleep(Duration::from_millis(100));
            }
        })
    };
    let output = child.wait_with_output().context("waiting for child")?;
    done.store(true, Ordering::Relaxed);
    let _ = sampler.join();
    Ok(ChildOutcome {
        stdout: output.stdout,
        stderr: String::from_utf8_lossy(&output.stderr).into_owned(),
        wall_seconds: start.elapsed().as_secs_f64(),
        peak_rss_kib: peak.load(Ordering::Relaxed),
        success: output.status.success(),
    })
}

// ---------------------------------------------------------------------------
// Built-in ordered-statistics information-set decoder (upper-bound source)
// ---------------------------------------------------------------------------

struct Rng(u64);

impl Rng {
    fn new(seed: u64) -> Self {
        Self(seed | 1)
    }
    #[inline]
    fn next_u64(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x.wrapping_mul(0x2545_f491_4f6c_dd1d)
    }
    #[inline]
    fn below(&mut self, bound: usize) -> usize {
        (self.next_u64() % bound as u64) as usize
    }
}

struct OsdProblem {
    columns: usize,
    words: usize,
    logical_words: usize,
    /// Physical checks as sparse coordinate lists (these matrices are LDPC).
    checks: Vec<Vec<u16>>,
    /// For each coordinate, the column of the logical observation matrix.
    logical_columns: Vec<Vec<u64>>,
}

impl OsdProblem {
    fn new(problem: &SparseProblem) -> Self {
        let columns = usize::from(problem.coordinate_count);
        let words = words_for(columns);
        let logical_rows = problem.logical_observations.len();
        let logical_words = words_for(logical_rows.max(1));
        let checks = problem.physical_checks.clone();
        let mut logical_columns = vec![vec![0u64; logical_words]; columns];
        for (row_index, row) in problem.logical_observations.iter().enumerate() {
            for &coordinate in row {
                set_bit(&mut logical_columns[usize::from(coordinate)], row_index);
            }
        }
        Self {
            columns,
            words,
            logical_words,
            checks,
            logical_columns,
        }
    }
}

#[derive(Debug, Clone)]
struct OsdHit {
    weight: u32,
    support: Vec<u16>,
}

/// One information-set trial: random column order, systematic parity-check
/// basis, then all combinations of up to `order` of the `window` lightest
/// induced kernel basis vectors. Order 1 is plain Prange; order >= 2 is
/// ordered-statistics decoding over the induced basis.
fn osd_trial(
    problem: &OsdProblem,
    rng: &mut Rng,
    order: usize,
    window: usize,
    bound: u32,
    scratch: &mut OsdScratch,
) -> Option<OsdHit> {
    let n = problem.columns;
    let words = problem.words;
    let lwords = problem.logical_words;

    // Random column order.
    scratch.perm.clear();
    scratch.perm.extend(0..n as u16);
    for index in (1..n).rev() {
        let swap = rng.below(index + 1);
        scratch.perm.swap(index, swap);
    }
    let mut position = vec![0u32; n];
    for (slot, &coordinate) in scratch.perm.iter().enumerate() {
        position[usize::from(coordinate)] = slot as u32;
    }

    // Permuted parity-check matrix.
    scratch.rows.clear();
    for row in &problem.checks {
        let mut permuted = vec![0u64; words];
        for &coordinate in row {
            set_bit(&mut permuted, position[usize::from(coordinate)] as usize);
        }
        scratch.rows.push(permuted);
    }

    // Reduced row echelon form, pivots taken in increasing permuted-column order.
    let row_count = scratch.rows.len();
    let mut pivot_columns: Vec<usize> = Vec::with_capacity(row_count);
    let mut rank = 0usize;
    for column in 0..n {
        if rank == row_count {
            break;
        }
        let Some(found) = (rank..row_count).find(|&index| bit_set(&scratch.rows[index], column))
        else {
            continue;
        };
        scratch.rows.swap(rank, found);
        let (head, tail) = scratch.rows.split_at_mut(rank + 1);
        let (above, pivot_slice) = head.split_at_mut(rank);
        let pivot_row: &[u64] = &pivot_slice[0];
        for row in tail.iter_mut() {
            if bit_set(row, column) {
                xor_assign(row, pivot_row);
            }
        }
        for row in above.iter_mut() {
            if bit_set(row, column) {
                xor_assign(row, pivot_row);
            }
        }
        pivot_columns.push(column);
        rank += 1;
    }

    // Induced kernel basis, built directly in original coordinates so the
    // logical syndrome can be accumulated in the same pass.
    scratch.basis.clear();
    scratch.basis_logical.clear();
    scratch.basis_weight.clear();
    let pivot_set: BTreeSet<usize> = pivot_columns.iter().copied().collect();
    for free in 0..n {
        if pivot_set.contains(&free) {
            continue;
        }
        let mut vector = vec![0u64; words];
        let mut logical = vec![0u64; lwords];
        let coordinate = usize::from(scratch.perm[free]);
        set_bit(&mut vector, coordinate);
        xor_assign(&mut logical, &problem.logical_columns[coordinate]);
        for (row_index, &pivot) in pivot_columns.iter().enumerate() {
            if bit_set(&scratch.rows[row_index], free) {
                let coordinate = usize::from(scratch.perm[pivot]);
                set_bit(&mut vector, coordinate);
                xor_assign(&mut logical, &problem.logical_columns[coordinate]);
            }
        }
        scratch.basis_weight.push(popcount(&vector));
        scratch.basis.push(vector);
        scratch.basis_logical.push(logical);
    }

    let mut best: Option<OsdHit> = None;
    let mut best_weight = bound;
    let mut consider = |vector: &[u64], logical: &[u64], best: &mut Option<OsdHit>| {
        if is_zero(logical) {
            return;
        }
        let weight = popcount(vector);
        if weight == 0 || weight >= best_weight {
            return;
        }
        best_weight = weight;
        let support = (0..vector.len() * 64)
            .filter(|&index| index < 65536 && bit_set(vector, index))
            .map(|index| index as u16)
            .collect::<Vec<_>>();
        *best = Some(OsdHit { weight, support });
    };

    for index in 0..scratch.basis.len() {
        consider(
            &scratch.basis[index],
            &scratch.basis_logical[index],
            &mut best,
        );
    }
    if order >= 2 && !scratch.basis.is_empty() {
        let mut order_index: Vec<usize> = (0..scratch.basis.len()).collect();
        order_index.sort_unstable_by_key(|&index| scratch.basis_weight[index]);
        order_index.truncate(window.min(scratch.basis.len()));
        let mut combined = vec![0u64; words];
        let mut combined_logical = vec![0u64; lwords];
        for (first_slot, &first) in order_index.iter().enumerate() {
            for &second in &order_index[first_slot + 1..] {
                combined.copy_from_slice(&scratch.basis[first]);
                xor_assign(&mut combined, &scratch.basis[second]);
                combined_logical.copy_from_slice(&scratch.basis_logical[first]);
                xor_assign(&mut combined_logical, &scratch.basis_logical[second]);
                consider(&combined, &combined_logical, &mut best);
                if order >= 3 {
                    for &third in &order_index[first_slot + 1..] {
                        if third <= second {
                            continue;
                        }
                        let mut triple = combined.clone();
                        xor_assign(&mut triple, &scratch.basis[third]);
                        let mut triple_logical = combined_logical.clone();
                        xor_assign(&mut triple_logical, &scratch.basis_logical[third]);
                        consider(&triple, &triple_logical, &mut best);
                    }
                }
            }
        }
    }
    best
}

#[derive(Default)]
struct OsdScratch {
    perm: Vec<u16>,
    rows: Vec<Vec<u64>>,
    basis: Vec<Vec<u64>>,
    basis_logical: Vec<Vec<u64>>,
    basis_weight: Vec<u32>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct UpperRecord {
    source: String,
    parameters: String,
    requested_trials: u64,
    completed_trials: u64,
    seed: u64,
    threads: usize,
    weight: Option<u16>,
    witness: Vec<u16>,
    witness_check: Option<SupportCheck>,
}

#[allow(clippy::too_many_arguments)]
fn builtin_osd(
    problem: &SparseProblem,
    trials: u64,
    order: usize,
    window: usize,
    seed: u64,
    threads: usize,
    target_weight: u16,
    time_budget: f64,
) -> UpperRecord {
    let osd = OsdProblem::new(problem);
    let best: Arc<Mutex<Option<OsdHit>>> = Arc::new(Mutex::new(None));
    let bound = Arc::new(AtomicU64::new(u64::from(target_weight) + 1));
    let completed = Arc::new(AtomicU64::new(0));
    let stop = Arc::new(AtomicBool::new(false));
    let start = Instant::now();
    let threads = threads.max(1);
    std::thread::scope(|scope| {
        for worker in 0..threads {
            let osd = &osd;
            let best = Arc::clone(&best);
            let bound = Arc::clone(&bound);
            let completed = Arc::clone(&completed);
            let stop = Arc::clone(&stop);
            scope.spawn(move || {
                let mut rng = Rng::new(
                    seed ^ (worker as u64).wrapping_mul(0x9e37_79b9_7f4a_7c15).wrapping_add(1),
                );
                let mut scratch = OsdScratch::default();
                loop {
                    if stop.load(Ordering::Relaxed) {
                        break;
                    }
                    let index = completed.fetch_add(1, Ordering::Relaxed);
                    if index >= trials {
                        completed.fetch_sub(1, Ordering::Relaxed);
                        break;
                    }
                    if time_budget > 0.0 && start.elapsed().as_secs_f64() > time_budget {
                        completed.fetch_sub(1, Ordering::Relaxed);
                        stop.store(true, Ordering::Relaxed);
                        break;
                    }
                    let current = bound.load(Ordering::Relaxed) as u32;
                    if let Some(hit) = osd_trial(osd, &mut rng, order, window, current, &mut scratch)
                    {
                        let mut guard = best.lock().unwrap();
                        if guard.as_ref().is_none_or(|prior| hit.weight < prior.weight) {
                            bound.store(u64::from(hit.weight), Ordering::Relaxed);
                            *guard = Some(hit);
                        }
                    }
                }
            });
        }
    });
    let hit = best.lock().unwrap().clone();
    let witness = hit.as_ref().map(|hit| hit.support.clone()).unwrap_or_default();
    let witness_check = (!witness.is_empty())
        .then(|| classify_support(problem, &witness).ok())
        .flatten();
    UpperRecord {
        source: "builtin-osd".to_string(),
        parameters: format!("order={order} window={window} target_weight={target_weight}"),
        requested_trials: trials,
        completed_trials: completed.load(Ordering::Relaxed).min(trials),
        seed,
        threads,
        weight: hit.as_ref().map(|hit| hit.weight as u16),
        witness,
        witness_check,
    }
}

fn core_random(
    problem: &SparseProblem,
    binary: &Path,
    input: &Path,
    trials: u64,
    target_weight: u16,
    threads: usize,
    seed: u64,
    osd_order: u8,
    osd_window: usize,
) -> Result<UpperRecord> {
    let args = vec![
        "--input".to_string(),
        input.display().to_string(),
        "--trials".to_string(),
        trials.to_string(),
        "--target-weight".to_string(),
        target_weight.to_string(),
        "--threads".to_string(),
        threads.to_string(),
        "--seed".to_string(),
        seed.to_string(),
        "--osd-order".to_string(),
        osd_order.to_string(),
        "--osd-window".to_string(),
        osd_window.to_string(),
    ];
    let outcome = run_child(binary, &args)?;
    if !outcome.success {
        bail!("css_distance_random failed: {}", outcome.stderr.trim());
    }
    #[derive(Deserialize)]
    struct RandomResult {
        distance_upper_bound: Option<u16>,
        witness: Vec<u16>,
    }
    #[derive(Deserialize)]
    struct RandomRecord {
        completed_trials: u64,
        result: RandomResult,
    }
    let record: RandomRecord =
        serde_json::from_slice(&outcome.stdout).context("parsing css_distance_random output")?;
    let witness = record.result.witness;
    let witness_check = (!witness.is_empty())
        .then(|| classify_support(problem, &witness).ok())
        .flatten();
    Ok(UpperRecord {
        source: "core-css-distance-random".to_string(),
        parameters: format!(
            "osd_order={osd_order} osd_window={osd_window} target_weight={target_weight}"
        ),
        requested_trials: trials,
        completed_trials: record.completed_trials,
        seed,
        threads,
        weight: record.result.distance_upper_bound,
        witness,
        witness_check,
    })
}

/// Pluggable external upper-bound source. The command is run with the input
/// path appended and must print JSON containing a `witness` array of
/// coordinates. The exact command string is recorded in the certificate.
fn external_upper(problem: &SparseProblem, command: &str, input: &Path) -> Result<UpperRecord> {
    let mut parts = command.split_whitespace().map(str::to_string).collect::<Vec<_>>();
    if parts.is_empty() {
        bail!("empty external upper-bound command");
    }
    let program = PathBuf::from(parts.remove(0));
    parts.push(input.display().to_string());
    let outcome = run_child(&program, &parts)?;
    if !outcome.success {
        bail!("external upper-bound source failed: {}", outcome.stderr.trim());
    }
    #[derive(Deserialize)]
    struct External {
        witness: Vec<u16>,
        #[serde(default)]
        completed_trials: u64,
    }
    let record: External =
        serde_json::from_slice(&outcome.stdout).context("parsing external source output")?;
    let witness_check = (!record.witness.is_empty())
        .then(|| classify_support(problem, &record.witness).ok())
        .flatten();
    Ok(UpperRecord {
        source: format!("external:{command} {}", input.display()),
        parameters: command.to_string(),
        requested_trials: record.completed_trials,
        completed_trials: record.completed_trials,
        seed: 0,
        threads: 0,
        weight: (!record.witness.is_empty()).then(|| record.witness.len() as u16),
        witness: record.witness,
        witness_check,
    })
}

// ---------------------------------------------------------------------------
// Job state on disk
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq)]
struct Toolchain {
    /// SHA-256 of the `css_distance_native` binary that produced every shard
    /// record in this job. Candidate counts drift across core revisions and the
    /// compiled filter format is not forward compatible, so a job resumed under
    /// a different enumerator would silently mix two searches.
    #[serde(default)]
    native_sha256: Option<String>,
    #[serde(default)]
    native_path: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct JobHeader {
    schema: String,
    code: CodeIdentity,
    input_file: String,
    #[serde(default)]
    toolchain: Toolchain,
}

fn job_paths(job: &Path, radius: u16, shards: u32) -> PathBuf {
    job.join(format!("w{radius:03}-n{shards:04}"))
}

fn write_atomic(path: &Path, bytes: &[u8]) -> Result<()> {
    let tmp = path.with_extension("tmp");
    {
        let mut file = fs::File::create(&tmp)
            .with_context(|| format!("creating {}", tmp.display()))?;
        file.write_all(bytes)?;
        file.sync_all()?;
    }
    fs::rename(&tmp, path).with_context(|| format!("renaming into {}", path.display()))?;
    Ok(())
}

fn append_metrics(job: &Path, value: &serde_json::Value) -> Result<()> {
    let path = job.join("metrics.jsonl");
    let mut file = fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(&path)
        .with_context(|| format!("opening {}", path.display()))?;
    writeln!(file, "{value}")?;
    Ok(())
}

/// Compile the source-bound filter artifact once per job. The compile runs at
/// the *target* radius with a 1/4096 shard so the backend selection matches the
/// real search exactly (the core picks compact/wide/extra-wide by a predicate
/// that reads `maximum_weight`) while doing a negligible amount of the work.
fn ensure_filter(
    native: &Path,
    input: &Path,
    job: &Path,
    radius: u16,
    threads: usize,
) -> Result<(PathBuf, NativeRecord, f64)> {
    let artifact = job.join("filter.ergocsl");
    let record_path = job.join("filter.json");
    if artifact.exists() && record_path.exists() {
        let record: NativeRecord = serde_json::from_slice(&fs::read(&record_path)?)
            .context("parsing cached filter record")?;
        if record.maximum_weight == radius {
            return Ok((artifact, record, 0.0));
        }
    }
    // Any partially written artifact from a killed run is ours to discard.
    let _ = fs::remove_file(&artifact);
    let args = vec![
        "--input".to_string(),
        input.display().to_string(),
        "--compiled-out".to_string(),
        artifact.display().to_string(),
        "--maximum-weight".to_string(),
        radius.to_string(),
        "--threads".to_string(),
        threads.to_string(),
        "--shard-index".to_string(),
        "0".to_string(),
        "--shard-count".to_string(),
        "4096".to_string(),
    ];
    let outcome = run_child(native, &args)?;
    if !outcome.success {
        bail!(
            "filter compile failed: {}",
            outcome.stderr.trim().lines().next().unwrap_or("(no stderr)")
        );
    }
    let record: NativeRecord =
        serde_json::from_slice(&outcome.stdout).context("parsing compile record")?;
    write_atomic(&record_path, &outcome.stdout)?;
    append_metrics(
        job,
        &serde_json::json!({
            "step": "compile",
            "radius": radius,
            "wall_seconds": outcome.wall_seconds,
            "peak_rss_kib": outcome.peak_rss_kib,
        }),
    )?;
    Ok((artifact, record, outcome.wall_seconds))
}

struct ShardRun {
    record: NativeRecord,
    wall_seconds: f64,
    peak_rss_kib: u64,
    resumed: bool,
}

#[allow(clippy::too_many_arguments)]
fn run_shard(
    native: &Path,
    input: &Path,
    filter: &Path,
    dir: &Path,
    radius: u16,
    index: u32,
    count: u32,
    threads: usize,
    pulse_interval: u64,
) -> Result<ShardRun> {
    let path = dir.join(format!("shard-{index:04}.json"));
    if let Ok(bytes) = fs::read(&path) {
        if let Ok(record) = serde_json::from_slice::<NativeRecord>(&bytes) {
            let matches = record
                .search_shard
                .as_ref()
                .is_some_and(|shard| shard.index == index && shard.count == count)
                && record.maximum_weight == radius;
            if matches {
                return Ok(ShardRun {
                    record,
                    wall_seconds: 0.0,
                    peak_rss_kib: 0,
                    resumed: true,
                });
            }
        }
    }
    let args = vec![
        "--input".to_string(),
        input.display().to_string(),
        "--compiled-in".to_string(),
        filter.display().to_string(),
        "--maximum-weight".to_string(),
        radius.to_string(),
        "--threads".to_string(),
        threads.to_string(),
        "--pulse-interval".to_string(),
        pulse_interval.to_string(),
        "--shard-index".to_string(),
        index.to_string(),
        "--shard-count".to_string(),
        count.to_string(),
    ];
    let outcome = run_child(native, &args)?;
    if !outcome.success {
        bail!(
            "shard {index}/{count} failed: {}",
            outcome.stderr.trim().lines().next().unwrap_or("(no stderr)")
        );
    }
    let record: NativeRecord =
        serde_json::from_slice(&outcome.stdout).context("parsing shard record")?;
    // Atomic publication: a kill before this point leaves no shard record, so
    // the shard is simply redone on resume. There is no half-complete state.
    write_atomic(&path, &outcome.stdout)?;
    Ok(ShardRun {
        record,
        wall_seconds: outcome.wall_seconds,
        peak_rss_kib: outcome.peak_rss_kib,
        resumed: false,
    })
}

// ---------------------------------------------------------------------------
// Certificate
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Serialize, Deserialize)]
struct ShardRecord {
    index: u32,
    count: u32,
    searched_maximum_weight: u16,
    candidates: u64,
    kernel_supports: u64,
    nontrivial_supports: u64,
    maximum_depth: u16,
    distance: Option<u16>,
    witness: Vec<u16>,
    artifact_payload_blake3: Option<String>,
    search_kernel: String,
    mode: String,
    result_scope: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct LevelRecord {
    requested_radius: u16,
    searched_maximum_weight: u16,
    shard_count: u32,
    shards_present: usize,
    coverage_complete: bool,
    total_candidates: u64,
    total_kernel_supports: u64,
    total_nontrivial_supports: u64,
    minimum_witness_weight: Option<u16>,
    minimum_witness: Vec<u16>,
    shards: Vec<ShardRecord>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Bracket {
    lower: u16,
    lower_provenance: String,
    upper: Option<u16>,
    upper_provenance: String,
    exact: bool,
    admissible_values: Vec<u16>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Certificate {
    schema: String,
    code: CodeIdentity,
    #[serde(default)]
    toolchain: Toolchain,
    parity_consequence: String,
    anchor_soundness: String,
    levels: Vec<LevelRecord>,
    upper_bounds: Vec<UpperRecord>,
    bracket: Bracket,
    replay: Vec<String>,
    trust_boundary: Vec<String>,
}

fn collect_level(dir: &Path, radius: u16, shards: u32) -> Result<Option<LevelRecord>> {
    if !dir.is_dir() {
        return Ok(None);
    }
    let mut records = Vec::new();
    for index in 0..shards {
        let path = dir.join(format!("shard-{index:04}.json"));
        let Ok(bytes) = fs::read(&path) else { continue };
        let record: NativeRecord = serde_json::from_slice(&bytes)
            .with_context(|| format!("parsing {}", path.display()))?;
        records.push((index, record));
    }
    if records.is_empty() {
        return Ok(None);
    }
    let searched = records[0].1.result.searched_maximum_weight;
    let mut level = LevelRecord {
        requested_radius: radius,
        searched_maximum_weight: searched,
        shard_count: shards,
        shards_present: records.len(),
        coverage_complete: records.len() == shards as usize,
        total_candidates: 0,
        total_kernel_supports: 0,
        total_nontrivial_supports: 0,
        minimum_witness_weight: None,
        minimum_witness: Vec::new(),
        shards: Vec::new(),
    };
    for (index, record) in records {
        level.total_candidates += record.result.stats.candidates;
        level.total_kernel_supports += record.result.stats.kernel_supports;
        level.total_nontrivial_supports += record.result.stats.nontrivial_supports;
        if let Some(distance) = record.result.distance {
            if level.minimum_witness_weight.is_none_or(|prior| distance < prior) {
                level.minimum_witness_weight = Some(distance);
                level.minimum_witness = record.result.witness.clone();
            }
        }
        level.shards.push(ShardRecord {
            index,
            count: shards,
            searched_maximum_weight: record.result.searched_maximum_weight,
            candidates: record.result.stats.candidates,
            kernel_supports: record.result.stats.kernel_supports,
            nontrivial_supports: record.result.stats.nontrivial_supports,
            maximum_depth: record.result.stats.maximum_depth,
            distance: record.result.distance,
            witness: record.result.witness,
            artifact_payload_blake3: record.artifact_payload_blake3,
            search_kernel: record.search_kernel,
            mode: record.mode,
            result_scope: record.result_scope,
        });
    }
    Ok(Some(level))
}

fn discover_levels(job: &Path) -> Result<Vec<LevelRecord>> {
    let mut levels = Vec::new();
    let Ok(entries) = fs::read_dir(job) else {
        return Ok(levels);
    };
    let mut names: Vec<String> = entries
        .filter_map(|entry| entry.ok())
        .filter_map(|entry| entry.file_name().into_string().ok())
        .filter(|name| name.starts_with('w') && name.contains("-n"))
        .collect();
    names.sort();
    for name in names {
        let Some((radius_part, shard_part)) = name.split_once("-n") else {
            continue;
        };
        let Ok(radius) = radius_part[1..].parse::<u16>() else {
            continue;
        };
        let Ok(shards) = shard_part.parse::<u32>() else {
            continue;
        };
        if let Some(level) = collect_level(&job.join(&name), radius, shards)? {
            levels.push(level);
        }
    }
    levels.sort_by_key(|level| level.requested_radius);
    Ok(levels)
}

fn build_bracket(code: &CodeIdentity, levels: &[LevelRecord], upper: &[UpperRecord]) -> Bracket {
    let parity = code.all_ones_in_physical_row_space;
    let mut lower = 1u16;
    let mut lower_provenance = "no completed exhaustion; the trivial bound d >= 1".to_string();
    let mut exact_from_search: Option<(u16, u16)> = None;

    for level in levels {
        if !level.coverage_complete {
            continue;
        }
        match level.minimum_witness_weight {
            Some(weight) => {
                // A complete shard cover that found a witness at weight w has
                // exhausted every connected anchored support below w, so w is
                // the exact distance.
                match exact_from_search {
                    Some((prior, _)) if prior <= weight => {}
                    _ => exact_from_search = Some((weight, level.searched_maximum_weight)),
                }
            }
            None => {
                let mut candidate = level.searched_maximum_weight + 1;
                if parity && candidate % 2 == 1 {
                    candidate += 1;
                }
                if candidate > lower {
                    lower = candidate;
                    lower_provenance = format!(
                        "complete {}-shard exhaustion through weight {} found no logical operator{}",
                        level.shard_count,
                        level.searched_maximum_weight,
                        if parity {
                            "; every logical operator of this code has even weight (the all-ones vector lies in the physical row space), so the bound lifts by one further unit"
                        } else {
                            ""
                        }
                    );
                }
            }
        }
    }

    let mut upper_weight: Option<u16> = None;
    let mut upper_provenance = "no witness found".to_string();
    for level in levels {
        if let Some(weight) = level.minimum_witness_weight {
            if upper_weight.is_none_or(|prior| weight < prior) {
                upper_weight = Some(weight);
                upper_provenance = format!(
                    "exhaustive enumeration at radius {} returned a witness",
                    level.requested_radius
                );
            }
        }
    }
    for record in upper {
        let verified = record
            .witness_check
            .as_ref()
            .is_some_and(|check| check.is_logical_operator);
        if !verified {
            continue;
        }
        if let Some(weight) = record.weight {
            if upper_weight.is_none_or(|prior| weight < prior) {
                upper_weight = Some(weight);
                upper_provenance = format!(
                    "{} witness, re-verified from the input (zero physical syndrome, {} logical observations triggered)",
                    record.source,
                    record
                        .witness_check
                        .as_ref()
                        .map(|check| check.logical_observations_triggered)
                        .unwrap_or(0)
                );
            }
        }
    }

    if let Some((weight, searched)) = exact_from_search {
        return Bracket {
            lower: weight,
            lower_provenance: format!(
                "complete shard cover through weight {searched} found its lightest logical operator at weight {weight}, so every lighter connected anchored support was ruled out"
            ),
            upper: Some(weight),
            upper_provenance,
            exact: true,
            admissible_values: vec![weight],
        };
    }

    let admissible = match upper_weight {
        Some(upper) if upper >= lower => {
            let step = if parity { 2 } else { 1 };
            let mut values = Vec::new();
            let mut value = lower;
            while value <= upper {
                values.push(value);
                value += step;
            }
            values
        }
        _ => Vec::new(),
    };
    Bracket {
        lower,
        lower_provenance,
        upper: upper_weight,
        upper_provenance,
        exact: upper_weight == Some(lower),
        admissible_values: admissible,
    }
}

#[derive(Debug, PartialEq, Eq)]
struct VerifiedBracketShape {
    lower: u16,
    upper: Option<u16>,
    exact: bool,
    admissible_values: Vec<u16>,
}

/// Derive only the numeric bracket claims from the source input and records.
/// This intentionally does not call the producer's `build_bracket` routine or
/// trust its cached witness checks/provenance strings.
fn independently_verify_bracket(
    code: &CodeIdentity,
    levels: &[LevelRecord],
    upper_records: &[UpperRecord],
    problem: &SparseProblem,
) -> Result<VerifiedBracketShape> {
    let mut lower = 1_u16;
    let mut exact_from_exhaustion: Option<u16> = None;
    let mut upper: Option<u16> = None;

    for level in levels {
        match (level.minimum_witness_weight, level.minimum_witness.is_empty()) {
            (Some(_), true) | (None, false) => bail!(
                "radius {} has inconsistent witness presence and weight",
                level.requested_radius
            ),
            (Some(weight), false) => {
                let check = classify_support(problem, &level.minimum_witness)?;
                if !check.is_logical_operator || check.weight != usize::from(weight) {
                    bail!(
                        "radius {} witness does not independently replay at weight {weight}",
                        level.requested_radius
                    );
                }
                upper = Some(upper.map_or(weight, |prior| prior.min(weight)));
                if level.coverage_complete {
                    exact_from_exhaustion = Some(
                        exact_from_exhaustion.map_or(weight, |prior| prior.min(weight)),
                    );
                }
            }
            (None, true) if level.coverage_complete => {
                let mut candidate = level
                    .searched_maximum_weight
                    .checked_add(1)
                    .context("lower-bound radius overflows u16")?;
                if code.all_ones_in_physical_row_space && candidate % 2 == 1 {
                    candidate = candidate
                        .checked_add(1)
                        .context("parity-adjusted lower bound overflows u16")?;
                }
                lower = lower.max(candidate);
            }
            (None, true) => {}
        }
    }

    for record in upper_records {
        match (record.weight, record.witness.is_empty()) {
            (Some(_), true) | (None, false) => bail!(
                "upper record {} has inconsistent witness presence and weight",
                record.source
            ),
            (Some(weight), false) => {
                let check = classify_support(problem, &record.witness)?;
                if !check.is_logical_operator || check.weight != usize::from(weight) {
                    bail!(
                        "upper record {} does not independently replay at weight {weight}",
                        record.source
                    );
                }
                upper = Some(upper.map_or(weight, |prior| prior.min(weight)));
            }
            (None, true) => {}
        }
    }

    if let Some(exact) = exact_from_exhaustion {
        return Ok(VerifiedBracketShape {
            lower: exact,
            upper: Some(exact),
            exact: true,
            admissible_values: vec![exact],
        });
    }
    if upper.is_some_and(|value| value < lower) {
        bail!("independently replayed upper bound is below the exhausted lower bound");
    }
    let mut admissible_values = Vec::new();
    if let Some(upper) = upper {
        let step = if code.all_ones_in_physical_row_space {
            2_u16
        } else {
            1_u16
        };
        let mut value = lower;
        loop {
            admissible_values.push(value);
            if value == upper {
                break;
            }
            value = value
                .checked_add(step)
                .context("admissible bracket values overflow u16")?;
            if value > upper {
                break;
            }
        }
    }
    Ok(VerifiedBracketShape {
        lower,
        upper,
        exact: upper == Some(lower),
        admissible_values,
    })
}

fn load_upper_records(job: &Path) -> Result<Vec<UpperRecord>> {
    let dir = job.join("upper");
    let mut records = Vec::new();
    let Ok(entries) = fs::read_dir(&dir) else {
        return Ok(records);
    };
    let mut names: Vec<String> = entries
        .filter_map(|entry| entry.ok())
        .filter_map(|entry| entry.file_name().into_string().ok())
        .filter(|name| name.ends_with(".json"))
        .collect();
    names.sort();
    for name in names {
        let bytes = fs::read(dir.join(&name))?;
        records.push(serde_json::from_slice(&bytes).with_context(|| format!("parsing {name}"))?);
    }
    Ok(records)
}

fn assemble_certificate(job: &Path) -> Result<Certificate> {
    let header: JobHeader = serde_json::from_slice(&fs::read(job.join("job.json"))?)
        .context("parsing job.json")?;
    let levels = discover_levels(job)?;
    let upper = load_upper_records(job)?;
    let bracket = build_bracket(&header.code, &levels, &upper);
    let parity_consequence = if header.code.all_ones_in_physical_row_space {
        "the all-ones vector lies in the row space of the physical checks, so every kernel vector -- hence every logical operator -- has even weight; an exhausted even radius R therefore certifies d >= R + 2".to_string()
    } else {
        "the all-ones vector is outside the row space of the physical checks, so no even-weight parity gate applies; an exhausted radius R certifies only d >= R + 1".to_string()
    };
    let anchor_soundness = if header.code.anchor_count == usize::from(header.code.coordinate_count) {
        "every coordinate is an anchor, so the enumeration is unconditionally complete".to_string()
    } else {
        format!(
            "{} of {} coordinates are anchors, a {:.1}x reduction. Soundness requires that a minimum-weight logical operator has a translate meeting the anchor set, which holds when the anchors are a transversal of the coordinates under a verified coordinate automorphism group. The input format carries no automorphism generators, so certdist takes this from the input generator and cannot re-derive it. THIS IS A TRUSTED INPUT, NOT A CHECKED FACT.",
            header.code.anchor_count,
            header.code.coordinate_count,
            header.code.anchor_reduction()
        )
    };
    Ok(Certificate {
        schema: "certdist-certificate-v1".to_string(),
        code: header.code,
        toolchain: header.toolchain,
        parity_consequence,
        anchor_soundness,
        levels,
        upper_bounds: upper,
        bracket,
        replay: vec![
            "certdist run --input <input.json> --job <job-dir> --radius <R> --shards <N> --native <css_distance_native built with --features large-css,parallel>".to_string(),
            "certdist verify --certificate <certificate.json> --input <input.json>".to_string(),
            "certdist verify --certificate <certificate.json> --input <input.json> --recheck-shards <K> --job <job-dir> --native <binary>".to_string(),
        ],
        trust_boundary: vec![
            "The lower bound is the Ergodis connected-support enumerator's own claim; certdist re-checks only that the shard cover is complete and internally consistent, never that a shard's enumeration was correct. Use --recheck-shards to re-run a sample.".to_string(),
            "The anchor reduction is trusted from the input, not verified (see anchor_soundness).".to_string(),
            "Every upper-bound witness IS independently re-verified from the input over GF(2) by certdist itself, in both run and verify.".to_string(),
        ],
    })
}

fn canonical_json(certificate: &Certificate) -> Result<Vec<u8>> {
    let mut bytes = serde_json::to_vec_pretty(certificate)?;
    bytes.push(b'\n');
    Ok(bytes)
}

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

#[derive(Debug, Parser)]
#[command(
    name = "certdist",
    about = "Certified exact minimum-distance service prototype (job-level driver for the Ergodis CSS distance core)"
)]
struct Cli {
    #[command(subcommand)]
    command: Job,
}

#[derive(Debug, ClapArgs, Clone)]
struct Binaries {
    /// css_distance_native built with --features large-css,parallel.
    #[arg(long, default_value = "~/.cache/ergodis/certdist/core-target/release/css_distance_native")]
    native: String,
    /// css_distance_random from the same build.
    #[arg(long, default_value = "~/.cache/ergodis/certdist/core-target/release/css_distance_random")]
    random_bin: String,
}

impl Binaries {
    fn native(&self) -> PathBuf {
        expand(&self.native)
    }
    fn random(&self) -> PathBuf {
        expand(&self.random_bin)
    }
}

fn expand(path: &str) -> PathBuf {
    if let Some(rest) = path.strip_prefix("~/") {
        if let Ok(home) = std::env::var("HOME") {
            return PathBuf::from(home).join(rest);
        }
    }
    PathBuf::from(path)
}

#[derive(Debug, Subcommand)]
enum Job {
    /// Estimate the cost of a radius before committing to it, by sampling shards.
    Plan {
        #[arg(long)]
        input: PathBuf,
        #[arg(long)]
        job: PathBuf,
        #[arg(long)]
        radius: u16,
        #[arg(long, default_value_t = 64)]
        shards: u32,
        /// Number of shards to actually run as a sample.
        #[arg(long, default_value_t = 3)]
        sample: u32,
        #[arg(long, default_value_t = 8)]
        threads: usize,
        #[arg(long, default_value_t = 4096)]
        pulse_interval: u64,
        #[command(flatten)]
        binaries: Binaries,
    },
    /// Run (or resume) a job: compile once, find an upper bound, exhaust shards.
    Run {
        #[arg(long)]
        input: PathBuf,
        #[arg(long)]
        job: PathBuf,
        #[arg(long)]
        radius: u16,
        #[arg(long, default_value_t = 32)]
        shards: u32,
        #[arg(long, default_value_t = 8)]
        threads: usize,
        #[arg(long, default_value_t = 4096)]
        pulse_interval: u64,
        /// Upper-bound source: none, builtin-osd, core-random, or external:<command>.
        #[arg(long, default_value = "builtin-osd")]
        upper: String,
        #[arg(long, default_value_t = 20000)]
        upper_trials: u64,
        #[arg(long, default_value_t = 2)]
        upper_order: usize,
        #[arg(long, default_value_t = 96)]
        upper_window: usize,
        #[arg(long, default_value_t = 0)]
        upper_threads: usize,
        #[arg(long, default_value_t = 0x63_65_72_74_64_69_73_74)]
        upper_seed: u64,
        /// Heaviest witness the upper pass will accept; 0 means no cap (report
        /// the lightest logical operator found, whatever its weight).
        #[arg(long, default_value_t = 0)]
        upper_target: u16,
        /// Seconds; 0 disables. Stops the upper-bound pass when exceeded.
        #[arg(long, default_value_t = 0.0)]
        upper_time_budget: f64,
        /// Stop cleanly between shards after this many seconds; 0 disables.
        #[arg(long, default_value_t = 0.0)]
        wall_budget: f64,
        #[command(flatten)]
        binaries: Binaries,
    },
    /// Print the live bracket and shard progress of a job.
    Status {
        #[arg(long)]
        job: PathBuf,
    },
    /// Combine the per-direction certificates of one CSS code into a code-level bracket.
    Combine {
        /// One certificate per input side (the `x` and `z` directions).
        #[arg(long, required = true, num_args = 1..)]
        certificate: Vec<PathBuf>,
        #[arg(long)]
        label: String,
        #[arg(long)]
        out: Option<PathBuf>,
    },
    /// Re-check a certificate. Structural checks are cheap; --recheck-shards re-runs search.
    Verify {
        #[arg(long)]
        certificate: PathBuf,
        #[arg(long)]
        input: PathBuf,
        /// Re-run this many shards of the deepest complete level and compare bit-for-bit.
        #[arg(long, default_value_t = 0)]
        recheck_shards: u32,
        #[arg(long)]
        job: Option<PathBuf>,
        #[arg(long, default_value_t = 8)]
        threads: usize,
        #[command(flatten)]
        binaries: Binaries,
    },
}

fn ensure_job(
    job: &Path,
    input: &Path,
    native: &Path,
) -> Result<(SparseProblem, CodeIdentity, PathBuf)> {
    fs::create_dir_all(job).with_context(|| format!("creating {}", job.display()))?;
    let (problem, raw) = load_problem(input)?;
    let code = CodeIdentity::derive(&problem, &raw);
    // Keep a byte-identical copy so the job is self-contained and resumable
    // even if the caller's input path moves.
    let local = job.join("input.json");
    if !local.exists() {
        write_atomic(&local, &raw)?;
    } else {
        let existing = fs::read(&local)?;
        if hex_digest(&existing) != code.input_sha256 {
            bail!(
                "job {} was created for a different input (sha256 mismatch)",
                job.display()
            );
        }
    }
    let toolchain = Toolchain {
        native_sha256: fs::read(native).ok().map(|bytes| hex_digest(&bytes)),
        native_path: Some(native.display().to_string()),
    };
    let header_path = job.join("job.json");
    if let Ok(bytes) = fs::read(&header_path) {
        if let Ok(prior) = serde_json::from_slice::<JobHeader>(&bytes) {
            if let (Some(before), Some(now)) =
                (&prior.toolchain.native_sha256, &toolchain.native_sha256)
            {
                if before != now {
                    bail!(
                        "job {} was built with css_distance_native {before}, but {now} is on the command line. Candidate counts and the compiled filter format both move with the core, so shard records from two enumerators must not be mixed. Start a fresh job directory.",
                        job.display()
                    );
                }
            }
        }
    }
    let header = JobHeader {
        schema: "certdist-job-v1".to_string(),
        code: code.clone(),
        input_file: input.display().to_string(),
        toolchain,
    };
    write_atomic(&header_path, &serde_json::to_vec_pretty(&header)?)?;
    Ok((problem, code, local))
}

fn print_identity(code: &CodeIdentity) {
    println!("code                 {}", code.label);
    println!(
        "coordinates          {}   physical rank {}   kernel dim {}   logical rank {}",
        code.coordinate_count, code.physical_rank, code.kernel_dimension, code.logical_rank
    );
    println!(
        "anchors              {} of {}  ({:.1}x reduction, structure-dependent, trusted from the input)",
        code.anchor_count,
        code.coordinate_count,
        code.anchor_reduction()
    );
    println!(
        "even-weight parity   {}",
        if code.all_ones_in_physical_row_space {
            "yes: an exhausted even radius R certifies d >= R + 2"
        } else {
            "no: an exhausted radius R certifies only d >= R + 1"
        }
    );
    println!("input sha256         {}", code.input_sha256);
}

fn print_bracket(bracket: &Bracket) {
    match bracket.upper {
        Some(upper) if bracket.exact => println!("bracket              d = {upper} (exact)"),
        Some(upper) => println!("bracket              {} <= d <= {}", bracket.lower, upper),
        None => println!("bracket              d >= {} (no witness yet)", bracket.lower),
    }
    println!("  lower             {}", bracket.lower_provenance);
    println!("  upper             {}", bracket.upper_provenance);
    if bracket.admissible_values.len() > 1 {
        println!(
            "  admissible        {:?}",
            bracket.admissible_values
        );
    }
}

fn cmd_plan(
    input: PathBuf,
    job: PathBuf,
    radius: u16,
    shards: u32,
    sample: u32,
    threads: usize,
    pulse_interval: u64,
    binaries: Binaries,
) -> Result<()> {
    let native = binaries.native();
    let (_problem, code, local_input) = ensure_job(&job, &input, &native)?;
    print_identity(&code);
    let compile_start = Instant::now();
    let (filter, filter_record, compile_seconds) =
        ensure_filter(&native, &local_input, &job, radius, threads)?;
    let compile_seconds = if compile_seconds > 0.0 {
        compile_seconds
    } else {
        compile_start.elapsed().as_secs_f64()
    };
    println!(
        "backend              {} / {} (per-shard filter fingerprints are recorded in the certificate)",
        filter_record.preparation_mode, filter_record.search_kernel,
    );
    println!("compile              {compile_seconds:.2} s (cached for the whole job)");

    let dir = job_paths(&job, radius, shards);
    fs::create_dir_all(&dir)?;
    let sample = sample.min(shards).max(1);
    // Sample shards spread across the modular partition, not the first few.
    let stride = (shards / sample).max(1);
    let mut sampled = Vec::new();
    let mut total_seconds = 0.0;
    let mut total_candidates = 0u64;
    let mut peak_rss = 0u64;
    for step in 0..sample {
        let index = (step * stride).min(shards - 1);
        let run = run_shard(
            &native,
            &local_input,
            &filter,
            &dir,
            radius,
            index,
            shards,
            threads,
            pulse_interval,
        )?;
        let seconds = run.record.search_seconds.iter().sum::<f64>();
        total_seconds += seconds;
        total_candidates += run.record.result.stats.candidates;
        peak_rss = peak_rss.max(run.peak_rss_kib);
        println!(
            "  shard {index:4}/{shards}   {:>12} candidates   {:>8.2} s search{}",
            run.record.result.stats.candidates,
            seconds,
            if run.resumed { "  (already on disk)" } else { "" }
        );
        sampled.push((index, seconds, run.record.result.stats.candidates));
    }
    let mean_seconds = total_seconds / sample as f64;
    let projected_search = mean_seconds * shards as f64;
    let spread: Vec<f64> = sampled.iter().map(|entry| entry.1).collect();
    let minimum = spread.iter().cloned().fold(f64::INFINITY, f64::min);
    let maximum = spread.iter().cloned().fold(0.0, f64::max);
    println!();
    println!("feasibility estimate for radius {radius} at shard count {shards}");
    println!(
        "  sampled           {sample} shards, {total_candidates} candidates, {total_seconds:.2} s search"
    );
    println!("  shard spread      {minimum:.2} s .. {maximum:.2} s (modular partition is unbalanced)");
    println!(
        "  projected search  {projected_search:.1} s at {threads} threads per shard, sequential shards"
    );
    println!(
        "  projected wall    {:.3} h sequential at {threads} threads per shard; {:.0} core-seconds of work in total",
        projected_search / 3600.0,
        projected_search * threads as f64
    );
    println!("  sampled peak RSS  {:.1} MiB per shard", peak_rss as f64 / 1024.0);
    println!(
        "  estimator         direct sampling of the target radius; no growth model, no extrapolation across radii"
    );
    println!(
        "  caveat            shards are a modular partition of depth-limited search prefixes and are unbalanced; with {sample} samples the projection carries the spread above"
    );
    append_metrics(
        &job,
        &serde_json::json!({
            "step": "plan",
            "radius": radius,
            "shards": shards,
            "sample": sample,
            "mean_shard_search_seconds": mean_seconds,
            "projected_search_seconds": projected_search,
        }),
    )?;
    Ok(())
}

#[allow(clippy::too_many_arguments)]
fn cmd_run(
    input: PathBuf,
    job: PathBuf,
    radius: u16,
    shards: u32,
    threads: usize,
    pulse_interval: u64,
    upper: String,
    upper_trials: u64,
    upper_order: usize,
    upper_window: usize,
    upper_threads: usize,
    upper_seed: u64,
    upper_target: u16,
    upper_time_budget: f64,
    wall_budget: f64,
    binaries: Binaries,
) -> Result<()> {
    let job_start = Instant::now();
    let native = binaries.native();
    let (problem, code, local_input) = ensure_job(&job, &input, &native)?;
    print_identity(&code);

    // --- upper-bound pass -------------------------------------------------
    if upper != "none" {
        fs::create_dir_all(job.join("upper"))?;
        let target = if upper_target == 0 {
            problem.coordinate_count
        } else {
            upper_target
        };
        let started = Instant::now();
        let record = if upper == "builtin-osd" {
            let threads = if upper_threads == 0 { threads } else { upper_threads };
            builtin_osd(
                &problem,
                upper_trials,
                upper_order,
                upper_window,
                upper_seed,
                threads,
                target,
                upper_time_budget,
            )
        } else if upper == "core-random" {
            core_random(
                &problem,
                &binaries.random(),
                &local_input,
                upper_trials,
                target,
                if upper_threads == 0 { threads } else { upper_threads },
                upper_seed,
                upper_order.min(2) as u8,
                upper_window,
            )?
        } else if let Some(command) = upper.strip_prefix("external:") {
            external_upper(&problem, command, &local_input)?
        } else {
            bail!("unknown upper-bound source {upper}");
        };
        let seconds = started.elapsed().as_secs_f64();
        let stem = record.source.replace([':', '/', ' ', '.'], "_");
        let path = job.join("upper").join(format!("{stem}-{upper_seed:016x}.json"));
        let existing: Option<UpperRecord> = fs::read(&path)
            .ok()
            .and_then(|bytes| serde_json::from_slice(&bytes).ok());
        let keep = match (&existing, &record) {
            (Some(prior), current) => match (prior.weight, current.weight) {
                (Some(a), Some(b)) => {
                    if b < a {
                        current.clone()
                    } else {
                        prior.clone()
                    }
                }
                (Some(_), None) => prior.clone(),
                _ => current.clone(),
            },
            (None, current) => current.clone(),
        };
        write_atomic(&path, &serde_json::to_vec_pretty(&keep)?)?;
        match (&keep.weight, &keep.witness_check) {
            (Some(weight), Some(check)) if check.is_logical_operator => println!(
                "upper pass           {} -> weight {weight} in {} trials, {seconds:.1} s; re-verified ({} physical violations, {} logical observations triggered)",
                keep.source, keep.completed_trials, check.physical_checks_violated, check.logical_observations_triggered
            ),
            (Some(weight), _) => println!(
                "upper pass           {} -> weight {weight}, BUT RE-VERIFICATION FAILED; not used",
                keep.source
            ),
            _ => println!(
                "upper pass           {} -> no witness in {} trials, {seconds:.1} s",
                keep.source, keep.completed_trials
            ),
        }
        append_metrics(
            &job,
            &serde_json::json!({
                "step": "upper",
                "source": keep.source,
                "trials": keep.completed_trials,
                "wall_seconds": seconds,
                "weight": keep.weight,
            }),
        )?;
    }

    // --- exhaustion -------------------------------------------------------
    let (filter, filter_record, _) = ensure_filter(&native, &local_input, &job, radius, threads)?;
    println!(
        "backend              {} / {} (per-shard filter fingerprints are recorded in the certificate)",
        filter_record.preparation_mode, filter_record.search_kernel,
    );
    let dir = job_paths(&job, radius, shards);
    fs::create_dir_all(&dir)?;
    let mut resumed = 0usize;
    let mut executed = 0usize;
    let mut search_seconds = 0.0;
    let mut peak_rss = 0u64;
    let mut stopped_early = false;
    for index in 0..shards {
        if wall_budget > 0.0 && job_start.elapsed().as_secs_f64() > wall_budget {
            println!(
                "wall budget reached after {index} of {shards} shards; job is resumable from disk"
            );
            stopped_early = true;
            break;
        }
        let run = run_shard(
            &native,
            &local_input,
            &filter,
            &dir,
            radius,
            index,
            shards,
            threads,
            pulse_interval,
        )?;
        if run.resumed {
            resumed += 1;
        } else {
            executed += 1;
            search_seconds += run.record.search_seconds.iter().sum::<f64>();
            peak_rss = peak_rss.max(run.peak_rss_kib);
            append_metrics(
                &job,
                &serde_json::json!({
                    "step": "shard",
                    "radius": radius,
                    "shard_index": index,
                    "shard_count": shards,
                    "wall_seconds": run.wall_seconds,
                    "search_seconds": run.record.search_seconds.iter().sum::<f64>(),
                    "peak_rss_kib": run.peak_rss_kib,
                    "candidates": run.record.result.stats.candidates,
                }),
            )?;
        }
    }
    println!(
        "shards               {executed} run, {resumed} resumed from disk, {search_seconds:.2} s search, peak RSS {:.1} MiB",
        peak_rss as f64 / 1024.0
    );

    let certificate = assemble_certificate(&job)?;
    let bytes = canonical_json(&certificate)?;
    write_atomic(&job.join("certificate.json"), &bytes)?;
    print_bracket(&certificate.bracket);
    println!("certificate          {}", job.join("certificate.json").display());
    println!("certificate sha256   {}", hex_digest(&bytes));
    append_metrics(
        &job,
        &serde_json::json!({
            "step": "job",
            "radius": radius,
            "shards": shards,
            "executed": executed,
            "resumed": resumed,
            "search_seconds": search_seconds,
            "wall_seconds": job_start.elapsed().as_secs_f64(),
            "stopped_early": stopped_early,
            "certificate_sha256": hex_digest(&bytes),
        }),
    )?;
    Ok(())
}

fn cmd_status(job: PathBuf) -> Result<()> {
    let certificate = assemble_certificate(&job)?;
    print_identity(&certificate.code);
    for level in &certificate.levels {
        println!(
            "radius {:3}           {} / {} shards, {} candidates{}",
            level.requested_radius,
            level.shards_present,
            level.shard_count,
            level.total_candidates,
            if level.coverage_complete {
                " [complete]"
            } else {
                " [PARTIAL]"
            }
        );
    }
    print_bracket(&certificate.bracket);
    Ok(())
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct SideSummary {
    input_sha256: String,
    label: String,
    lower: u16,
    upper: Option<u16>,
    exact: bool,
    lower_provenance: String,
    upper_provenance: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct CombinedCertificate {
    schema: String,
    label: String,
    rule: String,
    sides: Vec<SideSummary>,
    lower: u16,
    upper: Option<u16>,
    exact: bool,
}

fn cmd_combine(certificates: Vec<PathBuf>, label: String, out: Option<PathBuf>) -> Result<()> {
    let mut sides = Vec::new();
    for path in &certificates {
        let bytes = fs::read(path).with_context(|| format!("reading {}", path.display()))?;
        let parsed: Certificate = serde_json::from_slice(&bytes)
            .with_context(|| format!("parsing {}", path.display()))?;
        sides.push(SideSummary {
            input_sha256: parsed.code.input_sha256.clone(),
            label: parsed.code.label.clone(),
            lower: parsed.bracket.lower,
            upper: parsed.bracket.upper,
            exact: parsed.bracket.exact,
            lower_provenance: parsed.bracket.lower_provenance.clone(),
            upper_provenance: parsed.bracket.upper_provenance.clone(),
        });
    }
    if sides.is_empty() {
        bail!("no certificates given");
    }
    let lower = sides.iter().map(|side| side.lower).min().unwrap();
    let upper = sides.iter().filter_map(|side| side.upper).min();
    let combined = CombinedCertificate {
        schema: "certdist-combined-v1".to_string(),
        label,
        rule: "a CSS code's distance is the minimum of its two side distances, so the code-level lower bound is the minimum of the per-side lower bounds and the code-level upper bound is the minimum of the per-side upper bounds".to_string(),
        sides,
        lower,
        upper,
        exact: upper == Some(lower),
    };
    let mut bytes = serde_json::to_vec_pretty(&combined)?;
    bytes.push(b'\n');
    for side in &combined.sides {
        match side.upper {
            Some(upper) => println!("  side {:<28} {} <= d <= {}", side.label, side.lower, upper),
            None => println!("  side {:<28} d >= {}", side.label, side.lower),
        }
    }
    match combined.upper {
        Some(upper) if combined.exact => println!("{}: d = {upper} (exact)", combined.label),
        Some(upper) => println!("{}: {} <= d <= {}", combined.label, combined.lower, upper),
        None => println!("{}: d >= {}", combined.label, combined.lower),
    }
    if let Some(path) = out {
        write_atomic(&path, &bytes)?;
        println!("combined certificate {} sha256 {}", path.display(), hex_digest(&bytes));
    }
    Ok(())
}

fn cmd_verify(
    certificate: PathBuf,
    input: PathBuf,
    recheck_shards: u32,
    job: Option<PathBuf>,
    threads: usize,
    binaries: Binaries,
) -> Result<()> {
    let start = Instant::now();
    let bytes = fs::read(&certificate)
        .with_context(|| format!("reading {}", certificate.display()))?;
    let parsed: Certificate = serde_json::from_slice(&bytes).context("parsing certificate")?;
    println!("certificate          {}", certificate.display());
    println!("certificate sha256   {}", hex_digest(&bytes));
    println!(
        "enumerator sha256    {}",
        parsed
            .toolchain
            .native_sha256
            .as_deref()
            .unwrap_or("(not recorded)")
    );
    let mut failures: Vec<String> = Vec::new();
    let mut checks = 0usize;

    // 1. Code identity re-derived from the required input.
    let (problem, raw) = load_problem(&input)?;
    let derived = CodeIdentity::derive(&problem, &raw);
    checks += 1;
    if derived != parsed.code {
        failures.push("code identity re-derived from the input does not match the certificate".to_string());
    } else {
        println!("[ok] code identity, rank, kernel dimension, parity gate and input sha256 all re-derived from the input");
    }

    // 2. Shard cover completeness and internal consistency.
    for level in &parsed.levels {
        checks += 1;
        let present: BTreeSet<u32> = level.shards.iter().map(|shard| shard.index).collect();
        let expected: BTreeSet<u32> = (0..level.shard_count).collect();
        if present != expected {
            failures.push(format!(
                "radius {}: shard cover is incomplete ({} of {} present)",
                level.requested_radius,
                present.len(),
                level.shard_count
            ));
            continue;
        }
        let fingerprints: BTreeSet<&str> = level
            .shards
            .iter()
            .filter_map(|shard| shard.artifact_payload_blake3.as_deref())
            .collect();
        if fingerprints.len() > 1 {
            failures.push(format!(
                "radius {}: shards disagree on the compiled filter fingerprint",
                level.requested_radius
            ));
        }
        if level
            .shards
            .iter()
            .any(|shard| shard.searched_maximum_weight != level.searched_maximum_weight)
        {
            failures.push(format!(
                "radius {}: shards disagree on the searched maximum weight",
                level.requested_radius
            ));
        }
        if level.shards.iter().any(|shard| shard.result_scope != "partial-shard") {
            failures.push(format!(
                "radius {}: a shard record does not declare partial-shard scope",
                level.requested_radius
            ));
        }
        let totals = level
            .shards
            .iter()
            .map(|shard| shard.candidates)
            .sum::<u64>();
        if totals != level.total_candidates {
            failures.push(format!(
                "radius {}: candidate totals do not add up",
                level.requested_radius
            ));
        }
        println!(
            "[ok] radius {:3}: complete {}-shard cover, searched weight {}, {} candidates, {} nontrivial supports",
            level.requested_radius,
            level.shard_count,
            level.searched_maximum_weight,
            level.total_candidates,
            level.total_nontrivial_supports
        );
    }

    // 3. Every witness is re-verified from the input over GF(2).
    for level in &parsed.levels {
        if level.minimum_witness.is_empty() {
            continue;
        }
        checks += 1;
        let check = classify_support(&problem, &level.minimum_witness)?;
        if !check.is_logical_operator || Some(check.weight as u16) != level.minimum_witness_weight {
            failures.push(format!(
                "radius {}: enumeration witness is not a logical operator of the claimed weight",
                level.requested_radius
            ));
        } else {
            println!(
                "[ok] radius {:3}: witness of weight {} re-verified (0 physical violations, {} logical observations triggered)",
                level.requested_radius, check.weight, check.logical_observations_triggered
            );
        }
    }
    for record in &parsed.upper_bounds {
        if record.witness.is_empty() {
            continue;
        }
        checks += 1;
        let check = classify_support(&problem, &record.witness)?;
        if !check.is_logical_operator || Some(check.weight as u16) != record.weight {
            failures.push(format!(
                "upper-bound witness from {} is not a logical operator of the claimed weight",
                record.source
            ));
        } else {
            println!(
                "[ok] upper-bound witness from {} has weight {} and is a genuine logical operator",
                record.source, check.weight
            );
        }
    }

    // 4. The numeric bracket is independently derived from replayed witnesses
    // and complete-exhaustion records, not through the producer's builder.
    checks += 1;
    let independently_verified =
        independently_verify_bracket(&derived, &parsed.levels, &parsed.upper_bounds, &problem)?;
    if independently_verified.lower != parsed.bracket.lower
        || independently_verified.upper != parsed.bracket.upper
        || independently_verified.exact != parsed.bracket.exact
        || independently_verified.admissible_values != parsed.bracket.admissible_values
    {
        failures.push(
            "the bracket independently derived from the input and records disagrees with the certificate"
                .to_string(),
        );
    } else {
        println!("[ok] bracket independently derived from replayed witnesses and shard cover");
    }

    let structural_seconds = start.elapsed().as_secs_f64();
    println!();
    print_bracket(&parsed.bracket);
    println!();
    println!("structural verification: {checks} checks in {structural_seconds:.3} s");

    // 5. Optional: re-run shards. This is the only check that re-does search.
    if recheck_shards > 0 {
        let job = job.context("--recheck-shards requires --job")?;
        let Some(level) = parsed
            .levels
            .iter()
            .filter(|level| level.coverage_complete)
            .max_by_key(|level| level.requested_radius)
        else {
            bail!("no complete level to re-check");
        };
        let native = binaries.native();
        let current = hex_digest(
            &fs::read(&native)
                .with_context(|| format!("reading recheck enumerator {}", native.display()))?,
        );
        let recorded = parsed.toolchain.native_sha256.as_deref().context(
            "certificate does not record the enumerator digest required for shard replay",
        )?;
        if recorded != current {
            bail!(
                "recheck enumerator digest {current} does not match certificate digest {recorded}"
            );
        }
        let temp = job.join("recheck");
        fs::create_dir_all(&temp)?;
        let (filter, _, _) = ensure_filter(&native, &job.join("input.json"), &job, level.requested_radius, threads)?;
        let stride = (level.shard_count / recheck_shards).max(1);
        let recheck_start = Instant::now();
        let mut matched = 0usize;
        for step in 0..recheck_shards {
            let index = (step * stride).min(level.shard_count - 1);
            let path = temp.join(format!("shard-{index:04}.json"));
            let _ = fs::remove_file(&path);
            let run = run_shard(
                &native,
                &input,
                &filter,
                &temp,
                level.requested_radius,
                index,
                level.shard_count,
                threads,
                4096,
            )?;
            let claimed = &level.shards[index as usize];
            let stats = &run.record.result.stats;
            // The conclusion of a shard is deterministic; its counters are not.
            // The parallel search shares improved bounds between rayon workers
            // through an asynchronous mailbox, so as soon as a shard finds a
            // witness the pruning -- and therefore the candidate count -- varies
            // run to run at fixed thread count. A witness-free shard has no
            // bound to publish and does reproduce its counters exactly.
            let conclusion_agrees = run.record.result.distance == claimed.distance
                && (stats.nontrivial_supports > 0) == (claimed.nontrivial_supports > 0)
                && run.record.result.searched_maximum_weight == claimed.searched_maximum_weight;
            let counters_agree = stats.candidates == claimed.candidates
                && stats.kernel_supports == claimed.kernel_supports
                && stats.nontrivial_supports == claimed.nontrivial_supports;
            let witness_free = claimed.distance.is_none() && claimed.nontrivial_supports == 0;
            if !conclusion_agrees {
                failures.push(format!(
                    "shard {index} re-run reaches a different conclusion: distance {:?} against {:?} claimed",
                    run.record.result.distance, claimed.distance
                ));
            } else if witness_free && !counters_agree {
                failures.push(format!(
                    "witness-free shard {index} re-run disagrees on counters: {} candidates against {} claimed",
                    stats.candidates, claimed.candidates
                ));
            } else {
                matched += 1;
                if counters_agree {
                    println!(
                        "[ok] shard {index:4} re-run reproduces the conclusion and all {} candidates exactly",
                        claimed.candidates
                    );
                } else {
                    println!(
                        "[ok] shard {index:4} re-run reproduces the conclusion (distance {:?}); counters drift by {} candidates ({:+.3}%), which is expected for a shard that publishes a bound",
                        claimed.distance,
                        stats.candidates.abs_diff(claimed.candidates),
                        100.0 * (stats.candidates as f64 - claimed.candidates as f64)
                            / claimed.candidates as f64
                    );
                }
            }
        }
        let recheck_seconds = recheck_start.elapsed().as_secs_f64();
        println!(
            "shard re-check: {matched} of {recheck_shards} shards reproduced, {recheck_seconds:.2} s ({:.1}% of the level's shard cover)",
            100.0 * f64::from(recheck_shards) / f64::from(level.shard_count)
        );
    }

    if failures.is_empty() {
        println!("VERDICT: certificate verified");
        Ok(())
    } else {
        for failure in &failures {
            println!("[FAIL] {failure}");
        }
        bail!("{} verification failure(s)", failures.len())
    }
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    match cli.command {
        Job::Plan {
            input,
            job,
            radius,
            shards,
            sample,
            threads,
            pulse_interval,
            binaries,
        } => cmd_plan(
            input,
            job,
            radius,
            shards,
            sample,
            threads,
            pulse_interval,
            binaries,
        ),
        Job::Run {
            input,
            job,
            radius,
            shards,
            threads,
            pulse_interval,
            upper,
            upper_trials,
            upper_order,
            upper_window,
            upper_threads,
            upper_seed,
            upper_target,
            upper_time_budget,
            wall_budget,
            binaries,
        } => cmd_run(
            input,
            job,
            radius,
            shards,
            threads,
            pulse_interval,
            upper,
            upper_trials,
            upper_order,
            upper_window,
            upper_threads,
            upper_seed,
            upper_target,
            upper_time_budget,
            wall_budget,
            binaries,
        ),
        Job::Status { job } => cmd_status(job),
        Job::Combine {
            certificate,
            label,
            out,
        } => cmd_combine(certificate, label, out),
        Job::Verify {
            certificate,
            input,
            recheck_shards,
            job,
            threads,
            binaries,
        } => cmd_verify(certificate, input, recheck_shards, job, threads, binaries),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn problem() -> SparseProblem {
        SparseProblem {
            label: "fixture".into(),
            coordinate_count: 3,
            physical_checks: vec![vec![0, 1]],
            logical_observations: vec![vec![2]],
            anchors: vec![0, 1, 2],
            maximum_weight: 3,
            incumbent_support: Vec::new(),
            metadata: None,
        }
    }

    fn empty_level(searched: u16) -> LevelRecord {
        LevelRecord {
            requested_radius: searched,
            searched_maximum_weight: searched,
            shard_count: 1,
            shards_present: 1,
            coverage_complete: true,
            total_candidates: 0,
            total_kernel_supports: 0,
            total_nontrivial_supports: 0,
            minimum_witness_weight: None,
            minimum_witness: Vec::new(),
            shards: Vec::new(),
        }
    }

    #[test]
    fn independent_bracket_ignores_cached_checks_and_replays_supports() {
        let problem = problem();
        let raw = serde_json::to_vec(&problem).unwrap();
        let code = CodeIdentity::derive(&problem, &raw);
        let mut upper = UpperRecord {
            source: "fixture".into(),
            parameters: String::new(),
            requested_trials: 1,
            completed_trials: 1,
            seed: 0,
            threads: 1,
            weight: Some(1),
            witness: vec![2],
            witness_check: Some(SupportCheck {
                weight: 99,
                physical_checks_violated: 99,
                logical_observations_triggered: 0,
                is_logical_operator: false,
            }),
        };
        let shape = independently_verify_bracket(&code, &[], &[upper.clone()], &problem).unwrap();
        assert_eq!(
            shape,
            VerifiedBracketShape {
                lower: 1,
                upper: Some(1),
                exact: true,
                admissible_values: vec![1],
            }
        );
        upper.witness = vec![0];
        assert!(independently_verify_bracket(&code, &[], &[upper], &problem).is_err());
    }

    #[test]
    fn independent_bracket_checks_overflow_and_presence_consistency() {
        let problem = problem();
        let raw = serde_json::to_vec(&problem).unwrap();
        let code = CodeIdentity::derive(&problem, &raw);
        let mut level = empty_level(u16::MAX);
        assert!(independently_verify_bracket(&code, &[level.clone()], &[], &problem).is_err());
        level.searched_maximum_weight = 1;
        level.minimum_witness_weight = Some(1);
        assert!(independently_verify_bracket(&code, &[level], &[], &problem).is_err());
    }
}
