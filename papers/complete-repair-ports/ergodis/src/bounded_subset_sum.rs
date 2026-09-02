//! Exact bounded signed-multiset subset sums for cold theorem templates.
//!
//! Compilation proves all dimensions and work caps. Evaluation reuses a
//! caller-owned workspace, records reachability as packed bits, and allocates
//! nothing.

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const BOUNDED_SUBSET_SUM_SNAPSHOT_VERSION: u16 = 1;
pub const MAX_SUBSET_SUM_ITEMS: usize = 4_096;
pub const MAX_SUBSET_SUM_WIDTH: usize = 1_048_576;
pub const MAX_SUBSET_SUM_REACHABILITY_WORDS: usize = 4_194_304;
pub const MAX_SUBSET_SUM_TRANSITIONS: u64 = 134_217_728;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct BoundedSubsetSumBounds {
    pub maximum_items: usize,
    pub maximum_sum_width: usize,
    pub maximum_reachability_words: usize,
    pub maximum_transitions: u64,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct BoundedSubsetSumSnapshot {
    pub version: u16,
    pub target: i64,
    pub weights: Box<[i64]>,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct BoundedSubsetSumPlan {
    target: i64,
    weights: Box<[i64]>,
    minimum_sum: i64,
    maximum_sum: i64,
    width: usize,
    bitmap_words: usize,
    windows: Box<[SubsetSumWindow]>,
    transition_bound: u64,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct SubsetSumWindow {
    start: u32,
    end: u32,
}

const _: () = assert!(std::mem::size_of::<SubsetSumWindow>() == 8);
const _: () = assert!(std::mem::align_of::<SubsetSumWindow>() == 4);

impl SubsetSumWindow {
    fn range(self) -> std::ops::Range<usize> {
        self.start as usize..self.end as usize
    }

    fn contains(self, index: usize) -> bool {
        self.start as usize <= index && index < self.end as usize
    }

    fn len(self) -> usize {
        (self.end - self.start) as usize
    }
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct BoundedSubsetSumWorkspace {
    counts: Box<[u64]>,
    scratch: Box<[u64]>,
    reachability: Box<[u64]>,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct BoundedSubsetSumCertificate {
    pub target: i64,
    pub subset_count: u64,
    pub witness_words: Box<[u64]>,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum BoundedSubsetSumError {
    #[error("bounded subset-sum limits are invalid")]
    InvalidBounds,
    #[error("bounded subset-sum weights are empty or noncanonical")]
    InvalidWeights,
    #[error("bounded subset-sum range overflowed or exceeds its width cap")]
    SumRange,
    #[error("bounded subset-sum work exceeds its configured cap")]
    WorkLimit,
    #[error("bounded subset-sum workspace has the wrong shape")]
    WorkspaceShape,
    #[error("bounded subset-sum witness has the wrong shape")]
    WitnessShape,
    #[error("bounded subset-sum count overflowed")]
    CountOverflow,
    #[error("bounded subset-sum snapshot version is unsupported")]
    SnapshotVersion,
    #[error("bounded subset-sum certificate does not replay")]
    InvalidCertificate,
}

impl BoundedSubsetSumPlan {
    pub fn compile(
        weights: &[i64],
        target: i64,
        bounds: BoundedSubsetSumBounds,
    ) -> Result<Self, BoundedSubsetSumError> {
        validate_bounds(bounds)?;
        if weights.is_empty()
            || weights.len() > bounds.maximum_items
            || weights.windows(2).any(|pair| pair[0] > pair[1])
        {
            return Err(BoundedSubsetSumError::InvalidWeights);
        }
        let minimum_sum =
            weights
                .iter()
                .filter(|&&weight| weight < 0)
                .try_fold(0_i64, |sum, &weight| {
                    sum.checked_add(weight)
                        .ok_or(BoundedSubsetSumError::SumRange)
                })?;
        let maximum_sum =
            weights
                .iter()
                .filter(|&&weight| weight > 0)
                .try_fold(0_i64, |sum, &weight| {
                    sum.checked_add(weight)
                        .ok_or(BoundedSubsetSumError::SumRange)
                })?;
        let span = i128::from(maximum_sum) - i128::from(minimum_sum) + 1;
        let width = usize::try_from(span).map_err(|_| BoundedSubsetSumError::SumRange)?;
        if width == 0 || width > bounds.maximum_sum_width {
            return Err(BoundedSubsetSumError::SumRange);
        }
        let bitmap_words = width.div_ceil(64);
        let reachability_words = bitmap_words
            .checked_mul(weights.len() + 1)
            .ok_or(BoundedSubsetSumError::WorkLimit)?;
        let windows = continuation_windows(weights, target, minimum_sum, maximum_sum)?;
        let transitions = windows[..weights.len()]
            .iter()
            .try_fold(0_u64, |total, window| {
                u64::try_from(window.len())
                    .ok()
                    .and_then(|width| width.checked_mul(2))
                    .and_then(|width| total.checked_add(width))
                    .ok_or(BoundedSubsetSumError::WorkLimit)
            })?;
        if reachability_words > bounds.maximum_reachability_words
            || transitions > bounds.maximum_transitions
        {
            return Err(BoundedSubsetSumError::WorkLimit);
        }
        Ok(Self {
            target,
            weights: weights.into(),
            minimum_sum,
            maximum_sum,
            width,
            bitmap_words,
            windows,
            transition_bound: transitions,
        })
    }

    pub fn from_snapshot(
        snapshot: &BoundedSubsetSumSnapshot,
        bounds: BoundedSubsetSumBounds,
    ) -> Result<Self, BoundedSubsetSumError> {
        if snapshot.version != BOUNDED_SUBSET_SUM_SNAPSHOT_VERSION {
            return Err(BoundedSubsetSumError::SnapshotVersion);
        }
        Self::compile(&snapshot.weights, snapshot.target, bounds)
    }

    pub fn snapshot(&self) -> BoundedSubsetSumSnapshot {
        BoundedSubsetSumSnapshot {
            version: BOUNDED_SUBSET_SUM_SNAPSHOT_VERSION,
            target: self.target,
            weights: self.weights.clone(),
        }
    }

    pub fn workspace(&self) -> BoundedSubsetSumWorkspace {
        BoundedSubsetSumWorkspace {
            counts: vec![0; self.width].into_boxed_slice(),
            scratch: vec![0; self.width].into_boxed_slice(),
            reachability: vec![0; self.bitmap_words * (self.weights.len() + 1)].into_boxed_slice(),
        }
    }

    pub fn witness_words(&self) -> usize {
        self.weights.len().div_ceil(64)
    }

    pub fn transition_bound(&self) -> u64 {
        self.transition_bound
    }

    pub fn solve_into(
        &self,
        workspace: &mut BoundedSubsetSumWorkspace,
        witness_words: &mut [u64],
    ) -> Result<u64, BoundedSubsetSumError> {
        if workspace.counts.len() != self.width
            || workspace.scratch.len() != self.width
            || workspace.reachability.len() != self.bitmap_words * (self.weights.len() + 1)
        {
            return Err(BoundedSubsetSumError::WorkspaceShape);
        }
        if witness_words.len() != self.witness_words() {
            return Err(BoundedSubsetSumError::WitnessShape);
        }
        workspace.counts.fill(0);
        workspace.reachability.fill(0);
        witness_words.fill(0);
        if !self.windows[0].contains(self.index(0).expect("compiled range contains zero")) {
            return Ok(0);
        }
        let zero = self.index(0).expect("compiled range contains zero");
        workspace.counts[zero] = 1;
        set_bit(&mut workspace.reachability[..self.bitmap_words], zero);

        for (item, &weight) in self.weights.iter().enumerate() {
            let current = self.windows[item];
            let next = self.windows[item + 1];
            if next.start == next.end {
                return Ok(0);
            }
            workspace.scratch[next.range()].fill(0);
            for index in current.range() {
                let count = workspace.counts[index];
                if count == 0 {
                    continue;
                }
                if next.contains(index) {
                    workspace.scratch[index] = workspace.scratch[index]
                        .checked_add(count)
                        .ok_or(BoundedSubsetSumError::CountOverflow)?;
                }
                let sum = self.sum(index);
                let included = sum
                    .checked_add(weight)
                    .and_then(|sum| self.index(sum))
                    .expect("compiled subset transition stays in the total range");
                if next.contains(included) {
                    workspace.scratch[included] = workspace.scratch[included]
                        .checked_add(count)
                        .ok_or(BoundedSubsetSumError::CountOverflow)?;
                }
            }
            std::mem::swap(&mut workspace.counts, &mut workspace.scratch);
            let row = &mut workspace.reachability
                [(item + 1) * self.bitmap_words..(item + 2) * self.bitmap_words];
            for index in next.range() {
                let count = workspace.counts[index];
                if count != 0 {
                    set_bit(row, index);
                }
            }
        }

        let Some(target_index) = self.index(self.target) else {
            return Ok(0);
        };
        let count = workspace.counts[target_index];
        if count == 0 {
            return Ok(0);
        }
        let mut sum = self.target;
        for item in (0..self.weights.len()).rev() {
            let previous =
                &workspace.reachability[item * self.bitmap_words..(item + 1) * self.bitmap_words];
            if self
                .index(sum)
                .is_some_and(|index| get_bit(previous, index))
            {
                continue;
            }
            sum = sum
                .checked_sub(self.weights[item])
                .ok_or(BoundedSubsetSumError::InvalidCertificate)?;
            let previous_index = self
                .index(sum)
                .ok_or(BoundedSubsetSumError::InvalidCertificate)?;
            if !get_bit(previous, previous_index) {
                return Err(BoundedSubsetSumError::InvalidCertificate);
            }
            witness_words[item / 64] |= 1_u64 << (item % 64);
        }
        if sum != 0 {
            return Err(BoundedSubsetSumError::InvalidCertificate);
        }
        Ok(count)
    }

    pub fn certificate(
        &self,
        workspace: &mut BoundedSubsetSumWorkspace,
    ) -> Result<BoundedSubsetSumCertificate, BoundedSubsetSumError> {
        let mut witness_words = vec![0; self.witness_words()].into_boxed_slice();
        let subset_count = self.solve_into(workspace, &mut witness_words)?;
        Ok(BoundedSubsetSumCertificate {
            target: self.target,
            subset_count,
            witness_words,
        })
    }

    pub fn verify_certificate(
        &self,
        workspace: &mut BoundedSubsetSumWorkspace,
        certificate: &BoundedSubsetSumCertificate,
    ) -> Result<(), BoundedSubsetSumError> {
        if certificate.target != self.target
            || certificate.witness_words.len() != self.witness_words()
            || self.weights.len() % 64 != 0
                && certificate
                    .witness_words
                    .last()
                    .is_some_and(|&word| word & !((1_u64 << (self.weights.len() % 64)) - 1) != 0)
        {
            return Err(BoundedSubsetSumError::InvalidCertificate);
        }
        let mut expected = vec![0; self.witness_words()].into_boxed_slice();
        let count = self.solve_into(workspace, &mut expected)?;
        if count != certificate.subset_count
            || (count == 0 && certificate.witness_words.iter().any(|&word| word != 0))
        {
            return Err(BoundedSubsetSumError::InvalidCertificate);
        }
        if count != 0 {
            let sum = self
                .weights
                .iter()
                .enumerate()
                .filter(|(index, _)| {
                    certificate.witness_words[index / 64] & (1_u64 << (index % 64)) != 0
                })
                .try_fold(0_i64, |sum, (_, &weight)| sum.checked_add(weight))
                .ok_or(BoundedSubsetSumError::InvalidCertificate)?;
            if sum != self.target {
                return Err(BoundedSubsetSumError::InvalidCertificate);
            }
        }
        Ok(())
    }

    fn index(&self, sum: i64) -> Option<usize> {
        if sum < self.minimum_sum || sum > self.maximum_sum {
            return None;
        }
        usize::try_from(i128::from(sum) - i128::from(self.minimum_sum)).ok()
    }

    fn sum(&self, index: usize) -> i64 {
        i64::try_from(i128::from(self.minimum_sum) + index as i128)
            .expect("compiled subset-sum index lies in i64")
    }
}

fn continuation_windows(
    weights: &[i64],
    target: i64,
    minimum_sum: i64,
    maximum_sum: i64,
) -> Result<Box<[SubsetSumWindow]>, BoundedSubsetSumError> {
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
            SubsetSumWindow { start: 0, end: 0 }
        } else {
            let start = u32::try_from(lower - i128::from(minimum_sum))
                .map_err(|_| BoundedSubsetSumError::SumRange)?;
            let end = u32::try_from(upper - i128::from(minimum_sum) + 1)
                .map_err(|_| BoundedSubsetSumError::SumRange)?;
            SubsetSumWindow { start, end }
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
    Ok(windows.into_boxed_slice())
}

fn validate_bounds(bounds: BoundedSubsetSumBounds) -> Result<(), BoundedSubsetSumError> {
    if bounds.maximum_items == 0
        || bounds.maximum_items > MAX_SUBSET_SUM_ITEMS
        || bounds.maximum_sum_width == 0
        || bounds.maximum_sum_width > MAX_SUBSET_SUM_WIDTH
        || bounds.maximum_reachability_words == 0
        || bounds.maximum_reachability_words > MAX_SUBSET_SUM_REACHABILITY_WORDS
        || bounds.maximum_transitions == 0
        || bounds.maximum_transitions > MAX_SUBSET_SUM_TRANSITIONS
    {
        return Err(BoundedSubsetSumError::InvalidBounds);
    }
    Ok(())
}

fn set_bit(words: &mut [u64], index: usize) {
    words[index / 64] |= 1_u64 << (index % 64);
}

fn get_bit(words: &[u64], index: usize) -> bool {
    words[index / 64] & (1_u64 << (index % 64)) != 0
}

#[cfg(test)]
mod tests {
    use super::*;

    const BOUNDS: BoundedSubsetSumBounds = BoundedSubsetSumBounds {
        maximum_items: 32,
        maximum_sum_width: 1_024,
        maximum_reachability_words: 1_024,
        maximum_transitions: 32_768,
    };

    #[test]
    fn signed_multiset_count_and_witness_replay() {
        let plan = BoundedSubsetSumPlan::compile(&[-3, -1, 0, 2, 2, 5], 4, BOUNDS).unwrap();
        let mut workspace = plan.workspace();
        let certificate = plan.certificate(&mut workspace).unwrap();
        assert_eq!(certificate.subset_count, 8);
        plan.verify_certificate(&mut workspace, &certificate)
            .unwrap();
        let snapshot = plan.snapshot();
        let encoded = serde_json::to_vec(&snapshot).unwrap();
        let decoded: BoundedSubsetSumSnapshot = serde_json::from_slice(&encoded).unwrap();
        assert_eq!(
            BoundedSubsetSumPlan::from_snapshot(&decoded, BOUNDS).unwrap(),
            plan
        );
    }

    #[test]
    fn agrees_with_exhaustive_small_multisets() {
        for target in -5..=7 {
            let weights = [-2, -1, 1, 2, 2, 3];
            let plan = BoundedSubsetSumPlan::compile(&weights, target, BOUNDS).unwrap();
            let mut workspace = plan.workspace();
            let mut witness = vec![0; plan.witness_words()];
            let actual = plan.solve_into(&mut workspace, &mut witness).unwrap();
            let expected = (0_u64..1_u64 << weights.len())
                .filter(|mask| {
                    weights
                        .iter()
                        .enumerate()
                        .filter(|(index, _)| mask & (1_u64 << index) != 0)
                        .map(|(_, &weight)| weight)
                        .sum::<i64>()
                        == target
                })
                .count() as u64;
            assert_eq!(actual, expected, "target {target}");
        }
    }

    #[test]
    fn solve_hot_section_allocates_nothing() {
        let plan = BoundedSubsetSumPlan::compile(&[-3, -1, 0, 2, 2, 5], 4, BOUNDS).unwrap();
        let mut workspace = plan.workspace();
        let mut witness = vec![0; plan.witness_words()];
        let (_, events) = crate::test_alloc::measure_current_thread_allocations(|| {
            for _ in 0..1_000 {
                std::hint::black_box(plan.solve_into(&mut workspace, &mut witness).unwrap());
            }
        });
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn forged_certificate_and_overflow_fail_closed() {
        let plan = BoundedSubsetSumPlan::compile(&[1, 2, 3], 3, BOUNDS).unwrap();
        let mut workspace = plan.workspace();
        let mut certificate = plan.certificate(&mut workspace).unwrap();
        certificate.witness_words[0] = 1;
        assert_eq!(
            plan.verify_certificate(&mut workspace, &certificate),
            Err(BoundedSubsetSumError::InvalidCertificate)
        );

        let zeros = vec![0; 64];
        let wide_bounds = BoundedSubsetSumBounds {
            maximum_items: 64,
            maximum_sum_width: 1,
            maximum_reachability_words: 65,
            maximum_transitions: 128,
        };
        let overflow = BoundedSubsetSumPlan::compile(&zeros, 0, wide_bounds).unwrap();
        assert_eq!(
            overflow.solve_into(&mut overflow.workspace(), &mut [0]),
            Err(BoundedSubsetSumError::CountOverflow)
        );
    }
}
