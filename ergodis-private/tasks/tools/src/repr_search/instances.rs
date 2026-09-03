//! Instance generation for the C1051 representation-search spike.
//!
//! The primary family is the bounded subset-sum reachability row, taken from an
//! actual `BoundedSubsetSumPlan` solve through the public API. The plan's
//! `reachability` bitmap is a private field, so the rows are recomputed here
//! from the plan's public inputs by the same continuation-window recurrence,
//! and the recomputation is cross-checked exactly against the plan's public
//! `transition_bound()`. That check would fail if the recomputed windows
//! differed from the ones the solve uses.

use anyhow::{bail, Context, Result};
use ergodis::bounded_subset_sum::{
    BoundedSubsetSumBounds, BoundedSubsetSumPlan, MAX_SUBSET_SUM_ITEMS,
    MAX_SUBSET_SUM_REACHABILITY_WORDS, MAX_SUBSET_SUM_TRANSITIONS, MAX_SUBSET_SUM_WIDTH,
};
use ergodis_private::repr_grammar::{Observation, ObservationKind};
use sha2::{Digest, Sha256};

/// One search instance: a training observation plus held-out observations from
/// a different seed, used only for admission.
pub struct Instance {
    pub name: String,
    pub family: &'static str,
    pub training: Observation,
    pub holdout: Vec<Observation>,
    pub fingerprint: String,
    pub note: String,
}

impl Instance {
    fn new(
        name: String,
        family: &'static str,
        training: Observation,
        holdout: Vec<Observation>,
        note: String,
    ) -> Self {
        let fingerprint = fingerprint(&training);
        Self {
            name,
            family,
            training,
            holdout,
            fingerprint,
            note,
        }
    }
}

pub fn fingerprint(observation: &Observation) -> String {
    let mut hasher = Sha256::new();
    hasher.update((observation.kind() as u8).to_le_bytes());
    hasher.update(observation.universe().to_le_bytes());
    hasher.update((observation.len() as u64).to_le_bytes());
    for &value in observation.values() {
        hasher.update(value.to_le_bytes());
    }
    format!("{:x}", hasher.finalize())
}

/// Deterministic 64-bit generator; no seeding from the clock anywhere.
pub struct SplitMix {
    state: u64,
}

impl SplitMix {
    pub fn new(seed: u64) -> Self {
        Self { state: seed }
    }

    pub fn next(&mut self) -> u64 {
        self.state = self.state.wrapping_add(0x9e37_79b9_7f4a_7c15);
        let mut z = self.state;
        z = (z ^ (z >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
        z ^ (z >> 31)
    }

    pub fn below(&mut self, bound: u64) -> u64 {
        self.next() % bound.max(1)
    }
}

fn bounds() -> BoundedSubsetSumBounds {
    BoundedSubsetSumBounds {
        maximum_items: MAX_SUBSET_SUM_ITEMS,
        maximum_sum_width: MAX_SUBSET_SUM_WIDTH,
        maximum_reachability_words: MAX_SUBSET_SUM_REACHABILITY_WORDS,
        maximum_transitions: MAX_SUBSET_SUM_TRANSITIONS,
    }
}

#[derive(Clone, Copy)]
struct Window {
    start: usize,
    end: usize,
}

impl Window {
    fn contains(self, index: usize) -> bool {
        self.start <= index && index < self.end
    }

    fn len(self) -> usize {
        self.end - self.start
    }
}

fn continuation_windows(
    weights: &[i64],
    target: i64,
    minimum_sum: i64,
    maximum_sum: i64,
) -> Vec<Window> {
    let mut prefix_minimum = 0_i64;
    let mut prefix_maximum = 0_i64;
    let mut remaining_minimum = minimum_sum;
    let mut remaining_maximum = maximum_sum;
    let mut windows = Vec::with_capacity(weights.len() + 1);
    for layer in 0..=weights.len() {
        let lower =
            i128::from(prefix_minimum).max(i128::from(target) - i128::from(remaining_maximum));
        let upper =
            i128::from(prefix_maximum).min(i128::from(target) - i128::from(remaining_minimum));
        let window = if lower > upper {
            Window { start: 0, end: 0 }
        } else {
            Window {
                start: (lower - i128::from(minimum_sum)) as usize,
                end: (upper - i128::from(minimum_sum) + 1) as usize,
            }
        };
        windows.push(window);
        if let Some(&weight) = weights.get(layer) {
            if weight < 0 {
                prefix_minimum += weight;
                remaining_minimum -= weight;
            } else if weight > 0 {
                prefix_maximum += weight;
                remaining_maximum -= weight;
            }
        }
    }
    windows
}

/// Recompute the reachability rows of one real solve and return the row at
/// `row_index`, together with the compiled width.
fn reachability_row(weights: &[i64], target: i64, row_index: usize) -> Result<(Vec<i64>, usize)> {
    let plan = BoundedSubsetSumPlan::compile(weights, target, bounds())
        .map_err(|error| anyhow::anyhow!("subset-sum compile failed: {error}"))?;
    let minimum_sum: i64 = weights.iter().copied().filter(|&w| w < 0).sum();
    let maximum_sum: i64 = weights.iter().copied().filter(|&w| w > 0).sum();
    let width = (maximum_sum - minimum_sum + 1) as usize;
    let windows = continuation_windows(weights, target, minimum_sum, maximum_sum);
    let transitions: u64 = windows[..weights.len()]
        .iter()
        .map(|window| 2 * window.len() as u64)
        .sum();
    if transitions != plan.transition_bound() {
        bail!(
            "recomputed continuation windows disagree with the plan: {transitions} vs {}",
            plan.transition_bound()
        );
    }
    // The plan must actually solve, so the row corpus comes from a live solve.
    let mut workspace = plan.workspace();
    plan.certificate(&mut workspace)
        .map_err(|error| anyhow::anyhow!("subset-sum solve failed: {error}"))?;

    let zero = (-minimum_sum) as usize;
    let mut reachable = vec![false; width];
    let mut rows: Vec<Vec<i64>> = Vec::with_capacity(weights.len() + 1);
    if windows[0].contains(zero) {
        reachable[zero] = true;
    }
    rows.push(
        (0..width)
            .filter(|&index| reachable[index])
            .map(|index| index as i64)
            .collect(),
    );
    for (item, &weight) in weights.iter().enumerate() {
        let current = windows[item];
        let next = windows[item + 1];
        let mut updated = vec![false; width];
        for index in current.start..current.end {
            if !reachable[index] {
                continue;
            }
            if next.contains(index) {
                updated[index] = true;
            }
            let included = index as i64 + weight;
            if included >= 0 && (included as usize) < width && next.contains(included as usize) {
                updated[included as usize] = true;
            }
        }
        reachable = updated;
        rows.push(
            (next.start..next.end)
                .filter(|&index| reachable[index])
                .map(|index| index as i64)
                .collect(),
        );
    }
    let row = rows
        .get(row_index)
        .cloned()
        .context("requested reachability row is out of range")?;
    if row.is_empty() {
        bail!("recomputed reachability row {row_index} is empty");
    }
    Ok((row, width))
}

fn subset_sum_weights(items: usize, magnitude: i64, seed: u64) -> Vec<i64> {
    let mut generator = SplitMix::new(seed);
    let mut weights = (0..items)
        .map(|_| generator.below(2 * magnitude as u64 + 1) as i64 - magnitude)
        .collect::<Vec<_>>();
    weights.sort_unstable();
    weights
}

fn subset_sum_instance(name: &str, items: usize, magnitude: i64, seed: u64) -> Result<Instance> {
    let training_weights = subset_sum_weights(items, magnitude, seed);
    let holdout_weights = subset_sum_weights(items, magnitude, seed ^ 0xa5a5_a5a5_a5a5_a5a5);
    let (row, width) = reachability_row(&training_weights, 0, items / 2)?;
    let training = Observation::new(ObservationKind::DenseBitmap, width as u64, row)
        .map_err(|error| anyhow::anyhow!("training row rejected: {error:?}"))?;
    let mut holdout = Vec::new();
    for index in [items / 3, 2 * items / 3] {
        let (row, width) = reachability_row(&holdout_weights, 0, index)?;
        holdout.push(
            Observation::new(ObservationKind::DenseBitmap, width as u64, row)
                .map_err(|error| anyhow::anyhow!("holdout row rejected: {error:?}"))?,
        );
    }
    let note = format!(
        "reachability row {} of a {items}-item, magnitude-{magnitude} plan at target 0; \
         compiled width {width}; recomputed windows verified against transition_bound()",
        items / 2
    );
    Ok(Instance::new(
        name.to_string(),
        "subset-sum-reachability",
        training,
        holdout,
        note,
    ))
}

fn sparse_sorted_ids(count: usize, universe: u64, seed: u64) -> Observation {
    let mut generator = SplitMix::new(seed);
    let mut values = Vec::with_capacity(count);
    let mut seen = std::collections::BTreeSet::new();
    while seen.len() < count {
        seen.insert(generator.below(universe) as i64);
    }
    values.extend(seen);
    Observation::new(ObservationKind::SortedIds, universe, values)
        .expect("sparse ids are strictly increasing and in range")
}

fn clustered_runs(clusters: usize, universe: u64, seed: u64) -> Observation {
    let mut generator = SplitMix::new(seed);
    let mut members = std::collections::BTreeSet::new();
    for _ in 0..clusters {
        let start = generator.below(universe.saturating_sub(256));
        let run = 48 + generator.below(160);
        for offset in 0..run {
            let value = start + offset;
            if value < universe {
                members.insert(value as i64);
            }
        }
    }
    Observation::new(
        ObservationKind::DenseBitmap,
        universe,
        members.into_iter().collect(),
    )
    .expect("clustered runs are strictly increasing and in range")
}

fn small_integer_vector(count: usize, alphabet: u64, seed: u64) -> Observation {
    let mut generator = SplitMix::new(seed);
    let mut values = Vec::with_capacity(count);
    let mut current = generator.below(alphabet) as i64;
    while values.len() < count {
        let run = 1 + generator.below(6) as usize;
        for _ in 0..run {
            if values.len() == count {
                break;
            }
            values.push(current);
        }
        current = generator.below(alphabet) as i64;
    }
    Observation::new(ObservationKind::SmallIntVector, alphabet, values)
        .expect("vector values lie in the alphabet")
}

/// The full instance corpus. Training and held-out observations always come
/// from different seeds.
pub fn corpus() -> Result<Vec<Instance>> {
    let mut instances = vec![
        // Item counts stay at or below 56 so the exact subset count cannot
        // overflow `u64` at target 0; width is grown by magnitude instead.
        subset_sum_instance("subset-sum-24", 24, 9, 0x0000_0000_c105_1001)?,
        subset_sum_instance("subset-sum-40", 40, 40, 0x0000_0000_c105_1002)?,
        subset_sum_instance("subset-sum-56", 56, 90, 0x0000_0000_c105_1003)?,
    ];
    instances.push(Instance::new(
        "sparse-sorted-ids".to_string(),
        "sparse-sorted-ids",
        sparse_sorted_ids(512, 1 << 20, 0x0000_0000_c105_1101),
        vec![
            sparse_sorted_ids(512, 1 << 20, 0x0000_0000_c105_1901),
            sparse_sorted_ids(400, 1 << 20, 0x0000_0000_c105_1902),
        ],
        "512 distinct ids uniform in a 2^20 universe".to_string(),
    ));
    instances.push(Instance::new(
        "clustered-runs".to_string(),
        "clustered-runs",
        clustered_runs(24, 8_192, 0x0000_0000_c105_1201),
        vec![
            clustered_runs(24, 8_192, 0x0000_0000_c105_1a01),
            clustered_runs(18, 8_192, 0x0000_0000_c105_1a02),
        ],
        "24 contiguous runs of 48-207 members in an 8192 universe".to_string(),
    ));
    instances.push(Instance::new(
        "witness-vector".to_string(),
        "small-integer-vector",
        small_integer_vector(1_024, 64, 0x0000_0000_c105_1301),
        vec![
            small_integer_vector(1_024, 64, 0x0000_0000_c105_1b01),
            small_integer_vector(768, 64, 0x0000_0000_c105_1b02),
        ],
        "1024 order-bearing values over a 64-symbol alphabet, in short runs".to_string(),
    ));
    Ok(instances)
}
