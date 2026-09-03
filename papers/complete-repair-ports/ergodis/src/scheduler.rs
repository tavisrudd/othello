use std::hash::{Hash, Hasher};

use rustc_hash::{FxHashMap, FxHasher};
use thiserror::Error;

#[cfg(feature = "parallel")]
use rayon::prelude::*;

const NONE: u32 = u32::MAX;
const MAX_DENSE_LATTICE_STATES: usize = 1 << 24;
/// Largest number of distinct demand families for which the counted-type
/// reduction is attempted.
const COUNTED_TYPE_MAX_KINDS: usize = 64;
/// Average repetition per distinct family below which the counted-type
/// reduction does not pay for its dynamic program.
const COUNTED_TYPE_MIN_REPETITION: usize = 4;
const MAX_GRADED_SHELL_TABLE_CELLS: usize = 1 << 22;
const DENSE_DOMINANCE_WORK_MARGIN: usize = 4;
const DENSE_REACHABLE_BOUND_MARGIN: usize = 4;
const DENSE_ANTICHAIN_OCCUPANCY_DENOMINATOR: usize = 128;
const DENSE_GRADED_NARROW_OCCUPANCY_DENOMINATOR: usize = 4096;
#[cfg(feature = "parallel")]
const PARALLEL_PARETO_WORK: usize = 1 << 16;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum SchedulerError {
    #[error("an option load vector has the wrong width")]
    WidthMismatch,
    #[error("a repair support names an unknown resource")]
    UnknownResource,
    #[error("scheduler input or state exceeds its compact representation")]
    TooLarge,
    #[error("positive grading weights do not certify a common positive option mass")]
    InvalidGrading,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum WeightedSchedulerBackend {
    SparsePareto,
    DenseLattice,
}

#[derive(Clone, Debug, PartialEq, Eq)]
/// Exact witness that every compiled option has the same positive weighted load.
pub struct PositiveGradingCertificate {
    /// Strictly positive helper weights in capacity-coordinate order.
    pub weights: Box<[u32]>,
    /// Common dot product of `weights` with every compiled option load.
    pub option_mass: u64,
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct FamilyRecord {
    option_start: u32,
    option_len: u32,
}

const _: () = assert!(std::mem::size_of::<FamilyRecord>() == 8);
const _: () = assert!(std::mem::align_of::<FamilyRecord>() == 4);

#[derive(Clone, Debug)]
enum OptionLoads {
    U8(Box<[u8]>),
    U16(Box<[u16]>),
    U32(Box<[u32]>),
}

impl OptionLoads {
    #[inline]
    fn get(&self, index: usize) -> u32 {
        match self {
            Self::U8(values) => u32::from(values[index]),
            Self::U16(values) => u32::from(values[index]),
            Self::U32(values) => values[index],
        }
    }
}

enum OptionLoadsBuilder {
    U8(Vec<u8>),
    U16(Vec<u16>),
    U32(Vec<u32>),
}

impl OptionLoadsBuilder {
    fn new(capacities: &[u32], narrow: bool) -> Self {
        if !narrow {
            return Self::U32(Vec::new());
        }
        let maximum = capacities.iter().copied().max().unwrap_or(0);
        if u8::try_from(maximum).is_ok() {
            Self::U8(Vec::new())
        } else if u16::try_from(maximum).is_ok() {
            Self::U16(Vec::new())
        } else {
            Self::U32(Vec::new())
        }
    }

    fn extend(&mut self, loads: &[u32]) {
        match self {
            Self::U8(values) => values.extend(loads.iter().map(|&load| load as u8)),
            Self::U16(values) => values.extend(loads.iter().map(|&load| load as u16)),
            Self::U32(values) => values.extend_from_slice(loads),
        }
    }

    fn finish(self) -> OptionLoads {
        match self {
            Self::U8(values) => OptionLoads::U8(values.into_boxed_slice()),
            Self::U16(values) => OptionLoads::U16(values.into_boxed_slice()),
            Self::U32(values) => OptionLoads::U32(values.into_boxed_slice()),
        }
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct ScheduleState {
    load_start: u32,
    witness: u32,
    repairs: u32,
    aux: u32,
}

const _: () = assert!(std::mem::size_of::<ScheduleState>() == 16);
const _: () = assert!(std::mem::align_of::<ScheduleState>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct GradedDenseState {
    packed_loads: u64,
    witness: u32,
    key_repairs: u32,
}

impl GradedDenseState {
    fn key(self) -> u32 {
        self.key_repairs & GRADED_KEY_MASK
    }

    fn repairs(self) -> u32 {
        self.key_repairs >> 24
    }
}

const _: () = assert!(std::mem::size_of::<GradedDenseState>() == 16);
const _: () = assert!(std::mem::align_of::<GradedDenseState>() == 8);

const GRADED_KEY_MASK: u32 = (1 << 24) - 1;
const GRADED_PARENT_NONE: u32 = GRADED_KEY_MASK;

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct GradedWitnessNode {
    parent: u32,
    option: u32,
}

const _: () = assert!(std::mem::size_of::<GradedWitnessNode>() == 8);
const _: () = assert!(std::mem::align_of::<GradedWitnessNode>() == 4);

#[derive(Clone, Debug)]
struct GradedShellLayout {
    mass_stride: u32,
    rank_prefixes: Box<[u64]>,
    depth_offsets: Box<[u32]>,
    state_space: u32,
}

impl GradedShellLayout {
    fn rank_packed(
        &self,
        packed_loads: u64,
        packed_shifts: &[u32],
        capacities: &[u32],
        grading: &PositiveGradingCertificate,
        repairs: usize,
    ) -> Result<u32, SchedulerError> {
        let target_mass = u64::try_from(repairs)
            .ok()
            .and_then(|depth| depth.checked_mul(grading.option_mass))
            .and_then(|mass| usize::try_from(mass).ok())
            .ok_or(SchedulerError::TooLarge)?;
        let mut remaining = target_mass;
        let mut rank = u64::from(
            *self
                .depth_offsets
                .get(repairs)
                .ok_or(SchedulerError::TooLarge)?,
        );
        for (coordinate, ((&shift, &capacity), &weight)) in packed_shifts
            .iter()
            .zip(capacities)
            .zip(grading.weights.iter())
            .enumerate()
        {
            let value_bits = (u64::from(capacity) + 1)
                .next_power_of_two()
                .trailing_zeros();
            let mask = (1u64 << value_bits) - 1;
            let load = ((packed_loads >> shift) & mask) as usize;
            let weight = weight as usize;
            let used = load.checked_mul(weight).ok_or(SchedulerError::TooLarge)?;
            if used > remaining {
                return Err(SchedulerError::TooLarge);
            }
            if load != 0 {
                let prefix_start = coordinate * self.mass_stride as usize;
                rank += self.rank_prefixes[prefix_start + remaining]
                    - self.rank_prefixes[prefix_start + remaining - used];
            }
            remaining -= used;
        }
        if remaining != 0 || rank >= u64::from(self.state_space) {
            return Err(SchedulerError::TooLarge);
        }
        u32::try_from(rank).map_err(|_| SchedulerError::TooLarge)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct ScheduleWitnessNode {
    parent: u32,
    demand: u32,
    option: u32,
    repairs: u32,
}

const _: () = assert!(std::mem::size_of::<ScheduleWitnessNode>() == 16);
const _: () = assert!(std::mem::align_of::<ScheduleWitnessNode>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct MixedRadixState {
    key: u64,
    witness: u32,
    repairs: u32,
}

const _: () = assert!(std::mem::size_of::<MixedRadixState>() == 16);
const _: () = assert!(std::mem::align_of::<MixedRadixState>() == 8);

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct WeightedRepairChoice {
    pub demand: u32,
    pub loads: Box<[u32]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct WeightedParallelRepairResult {
    pub assignment: Box<[WeightedRepairChoice]>,
    pub unmatched_demands: Box<[u32]>,
    pub total_loads: Box<[u64]>,
    pub transitions_examined: u64,
    pub peak_pareto_states: u32,
}

impl WeightedParallelRepairResult {
    pub fn repaired_count(&self) -> usize {
        self.assignment.len()
    }

    pub fn complete(&self) -> bool {
        self.unmatched_demands.is_empty()
    }
}

/// Reusable allocation storage for repeated exact scheduler solves.
///
/// A workspace may be reused across different problems. It is not part of the
/// result and retains no logical state between calls.
#[derive(Debug, Default)]
pub struct WeightedRepairWorkspace {
    strides: Vec<usize>,
    option_deltas: Vec<usize>,
    packed_shifts: Vec<u32>,
    option_packed: Vec<u64>,
    states: Vec<GradedDenseState>,
    updated: Vec<GradedDenseState>,
    seen: Vec<u64>,
    witnesses: Vec<GradedWitnessNode>,
    lex_codes: Vec<u64>,
    best_options: Vec<(u32, u32)>,
    repaired: Vec<bool>,
    total_loads: Vec<u64>,
    sparse: SparseRepairStorage,
    counted: CountedTypeStorage,
}

/// Reusable storage for the counted-type reduction.
///
/// Every buffer is cleared and resized in place, so a warm workspace performs
/// no allocation on a repeat solve of the same shape.
#[derive(Debug, Default)]
struct CountedTypeStorage {
    /// Flattened option loads of each distinct family, with `kind_key_offset`
    /// delimiting the kinds. Grouping compares against at most
    /// `COUNTED_TYPE_MAX_KINDS` candidates, so no hash map is needed.
    kind_key: Vec<u32>,
    kind_key_offset: Vec<u32>,
    kind_representative: Vec<FamilyRecord>,
    kind_count: Vec<u32>,
    kind_of_demand: Vec<u32>,
    key_scratch: Vec<u32>,
    strides: Vec<u64>,
    option_kind: Vec<u32>,
    option_index: Vec<u32>,
    option_delta: Vec<u64>,
    option_loads: Vec<u32>,
    best: Vec<u32>,
    arrival: Vec<u32>,
    used: Vec<u32>,
    taken: Vec<u32>,
    chosen: Vec<u32>,
    total_loads: Vec<u64>,
}

#[derive(Debug, Default)]
struct SparseRepairStorage {
    loads: Vec<u32>,
    compact_loads: Vec<u32>,
    witnesses: Vec<ScheduleWitnessNode>,
    states: Vec<ScheduleState>,
    updated: Vec<ScheduleState>,
    scratch: Vec<u32>,
    hash_weights: Vec<u64>,
    option_hashes: Vec<u64>,
    heads: EpochHeads,
    keep: Vec<u8>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
struct EpochHead {
    head: u32,
    epoch: u32,
}

const _: () = assert!(std::mem::size_of::<EpochHead>() == 8);
const _: () = assert!(std::mem::align_of::<EpochHead>() == 4);

#[derive(Debug, Default)]
struct EpochHeads {
    buckets: Vec<EpochHead>,
    mask: usize,
    len: usize,
    epoch: u32,
}

impl EpochHeads {
    fn begin_epoch(&mut self) {
        self.len = 0;
        self.epoch = self.epoch.wrapping_add(1);
        if self.epoch == 0 {
            self.buckets.fill(EpochHead::default());
            self.epoch = 1;
        }
    }

    #[inline]
    fn slot(&self, hash: u64) -> usize {
        hash as usize & self.mask
    }

    #[inline]
    fn get(&self, hash: u64) -> Option<u32> {
        if self.buckets.is_empty() {
            return None;
        }
        let bucket = self.buckets[self.slot(hash)];
        (bucket.epoch == self.epoch).then_some(bucket.head)
    }

    #[inline]
    fn insert(&mut self, hash: u64, head: u32) {
        let epoch = self.epoch;
        let slot = self.slot(hash);
        self.buckets[slot] = EpochHead { head, epoch };
        self.len += 1;
    }

    #[inline]
    fn prepare_insert(
        &mut self,
        states: &mut [ScheduleState],
        loads: &[u32],
        hash_weights: &[u64],
    ) {
        if self.buckets.is_empty() || self.len == self.buckets.len() / 2 {
            self.grow(states, loads, hash_weights);
        }
    }

    #[cold]
    fn grow(&mut self, states: &mut [ScheduleState], loads: &[u32], hash_weights: &[u64]) {
        self.buckets = vec![EpochHead::default(); (self.mask + 1).saturating_mul(2).max(16)];
        self.mask = self.buckets.len() - 1;
        self.len = 0;
        for (id, state) in states.iter_mut().enumerate() {
            let hash = fingerprint_load(loads, state.load_start as usize, hash_weights);
            state.aux = self.get(hash).unwrap_or(NONE);
            self.insert(
                hash,
                u32::try_from(id).expect("directory state IDs were checked on insertion"),
            );
        }
    }
}

impl WeightedRepairWorkspace {
    pub fn new() -> Self {
        Self::default()
    }

    /// Releases excess retained capacity after a workload-size change.
    pub fn shrink_to_fit(&mut self) {
        self.strides.shrink_to_fit();
        self.option_deltas.shrink_to_fit();
        self.packed_shifts.shrink_to_fit();
        self.option_packed.shrink_to_fit();
        self.states.shrink_to_fit();
        self.updated.shrink_to_fit();
        self.seen.shrink_to_fit();
        self.witnesses.shrink_to_fit();
        self.lex_codes.shrink_to_fit();
        self.best_options.shrink_to_fit();
        self.counted.kind_key.shrink_to_fit();
        self.counted.kind_key_offset.shrink_to_fit();
        self.counted.kind_representative.shrink_to_fit();
        self.counted.kind_count.shrink_to_fit();
        self.counted.kind_of_demand.shrink_to_fit();
        self.counted.key_scratch.shrink_to_fit();
        self.counted.strides.shrink_to_fit();
        self.counted.option_kind.shrink_to_fit();
        self.counted.option_index.shrink_to_fit();
        self.counted.option_delta.shrink_to_fit();
        self.counted.option_loads.shrink_to_fit();
        self.counted.best.shrink_to_fit();
        self.counted.arrival.shrink_to_fit();
        self.counted.used.shrink_to_fit();
        self.counted.taken.shrink_to_fit();
        self.counted.chosen.shrink_to_fit();
        self.counted.total_loads.shrink_to_fit();
        self.repaired.shrink_to_fit();
        self.total_loads.shrink_to_fit();
        self.sparse.loads.shrink_to_fit();
        self.sparse.compact_loads.shrink_to_fit();
        self.sparse.witnesses.shrink_to_fit();
        self.sparse.states.shrink_to_fit();
        self.sparse.updated.shrink_to_fit();
        self.sparse.scratch.shrink_to_fit();
        self.sparse.hash_weights.shrink_to_fit();
        self.sparse.option_hashes.shrink_to_fit();
        self.sparse.heads.buckets.shrink_to_fit();
        self.sparse.keep.shrink_to_fit();
    }
}

#[derive(Clone, Debug)]
pub struct WeightedRepairProblem {
    capacities: Box<[u32]>,
    families: Box<[FamilyRecord]>,
    option_count: u32,
    option_loads: OptionLoads,
    dense_state_space: u32,
    positive_grading: Option<PositiveGradingCertificate>,
    graded_shell: Option<GradedShellLayout>,
    recommended_backend: WeightedSchedulerBackend,
}

impl WeightedRepairProblem {
    pub fn from_families(
        capacities: &[u32],
        raw_families: &[Vec<Vec<u32>>],
    ) -> Result<Self, SchedulerError> {
        Self::from_materialized_families_impl(capacities, raw_families, None)
    }

    /// Compiles families from arbitrary iterators without materializing a nested
    /// input tree. Each family retains only its current Pareto-minimal antichain.
    pub fn from_family_iterators<I, FI, L>(
        capacities: &[u32],
        raw_families: I,
    ) -> Result<Self, SchedulerError>
    where
        I: IntoIterator<Item = FI>,
        FI: IntoIterator<Item = L>,
        L: AsRef<[u32]>,
    {
        Self::from_family_iterators_impl(capacities, raw_families, None)
    }

    /// Compiles a problem and verifies a caller-supplied positive grading.
    ///
    /// The constructor rejects zero weights, overflow, a zero common mass, or
    /// options having different weighted masses. A valid certificate proves
    /// that every distinct dynamic-programming frontier state is incomparable,
    /// so both exact backends can omit dominance pruning.
    pub fn from_families_with_positive_grading(
        capacities: &[u32],
        raw_families: &[Vec<Vec<u32>>],
        weights: &[u32],
    ) -> Result<Self, SchedulerError> {
        Self::from_materialized_families_impl(capacities, raw_families, Some(weights))
    }

    pub fn from_family_iterators_with_positive_grading<I, FI, L>(
        capacities: &[u32],
        raw_families: I,
        weights: &[u32],
    ) -> Result<Self, SchedulerError>
    where
        I: IntoIterator<Item = FI>,
        FI: IntoIterator<Item = L>,
        L: AsRef<[u32]>,
    {
        Self::from_family_iterators_impl(capacities, raw_families, Some(weights))
    }

    fn from_materialized_families_impl(
        capacities: &[u32],
        raw_families: &[Vec<Vec<u32>>],
        grading_weights: Option<&[u32]>,
    ) -> Result<Self, SchedulerError> {
        u32::try_from(raw_families.len()).map_err(|_| SchedulerError::TooLarge)?;
        let width = capacities.len();
        let raw_option_count = raw_families
            .iter()
            .try_fold(0usize, |sum, family| sum.checked_add(family.len()));
        let narrow_loads = raw_option_count.is_none_or(|options| options > 65_536);
        let mut families = Vec::with_capacity(raw_families.len());
        let mut option_count = 0u32;
        let mut option_loads = OptionLoadsBuilder::new(capacities, narrow_loads);
        for raw_family in raw_families {
            if raw_family.iter().any(|loads| loads.len() != width) {
                return Err(SchedulerError::WidthMismatch);
            }
            let mut canonical: Vec<Vec<u32>> = raw_family
                .iter()
                .filter(|loads| loads.iter().zip(capacities).all(|(load, cap)| load <= cap))
                .cloned()
                .collect();
            canonical.sort_unstable();
            canonical.dedup();
            let minimal = canonical
                .iter()
                .enumerate()
                .filter(|(index, loads)| {
                    !canonical.iter().enumerate().any(|(other_index, other)| {
                        index != &other_index
                            && other
                                .iter()
                                .zip(loads.iter())
                                .all(|(left, right)| left <= right)
                    })
                })
                .map(|(_, loads)| loads)
                .collect::<Vec<_>>();
            let option_start = option_count;
            for loads in &minimal {
                option_loads.extend(loads);
                option_count = option_count
                    .checked_add(1)
                    .ok_or(SchedulerError::TooLarge)?;
            }
            families.push(FamilyRecord {
                option_start,
                option_len: u32::try_from(minimal.len()).map_err(|_| SchedulerError::TooLarge)?,
            });
        }
        Self::finish_compiled_problem(
            capacities,
            families,
            option_count,
            option_loads,
            grading_weights,
        )
    }

    fn from_family_iterators_impl<I, FI, L>(
        capacities: &[u32],
        raw_families: I,
        grading_weights: Option<&[u32]>,
    ) -> Result<Self, SchedulerError>
    where
        I: IntoIterator<Item = FI>,
        FI: IntoIterator<Item = L>,
        L: AsRef<[u32]>,
    {
        let width = capacities.len();
        let raw_families = raw_families.into_iter();
        let mut families = Vec::with_capacity(raw_families.size_hint().0);
        let mut option_count = 0u32;
        let mut option_loads = OptionLoadsBuilder::new(capacities, true);
        for raw_family in raw_families {
            let mut minimal: Vec<Box<[u32]>> = Vec::new();
            for raw_loads in raw_family {
                let loads = raw_loads.as_ref();
                if loads.len() != width {
                    return Err(SchedulerError::WidthMismatch);
                }
                if loads.iter().zip(capacities).any(|(load, cap)| load > cap)
                    || minimal
                        .iter()
                        .any(|other| other.iter().zip(loads).all(|(left, right)| left <= right))
                {
                    continue;
                }
                minimal.retain(|other| {
                    !loads
                        .iter()
                        .zip(other.iter())
                        .all(|(left, right)| left <= right)
                });
                minimal.push(loads.into());
            }
            minimal.sort_unstable();
            let option_start = option_count;
            for loads in &minimal {
                option_loads.extend(loads);
                option_count = option_count
                    .checked_add(1)
                    .ok_or(SchedulerError::TooLarge)?;
            }
            families.push(FamilyRecord {
                option_start,
                option_len: u32::try_from(minimal.len()).map_err(|_| SchedulerError::TooLarge)?,
            });
        }
        u32::try_from(families.len()).map_err(|_| SchedulerError::TooLarge)?;
        Self::finish_compiled_problem(
            capacities,
            families,
            option_count,
            option_loads,
            grading_weights,
        )
    }

    fn finish_compiled_problem(
        capacities: &[u32],
        families: Vec<FamilyRecord>,
        option_count: u32,
        option_loads: OptionLoadsBuilder,
        grading_weights: Option<&[u32]>,
    ) -> Result<Self, SchedulerError> {
        let width = capacities.len();
        let mut problem = Self {
            capacities: capacities.into(),
            families: families.into_boxed_slice(),
            option_count,
            option_loads: option_loads.finish(),
            dense_state_space: 0,
            positive_grading: None,
            graded_shell: None,
            recommended_backend: WeightedSchedulerBackend::SparsePareto,
        };
        problem.dense_state_space = problem
            .compute_dense_state_space()
            .and_then(|space| u32::try_from(space).ok())
            .unwrap_or(0);
        let automatic_weights = vec![1u32; width];
        problem.positive_grading = match grading_weights {
            Some(weights) => Some(
                problem
                    .certify_positive_grading(weights)
                    .ok_or(SchedulerError::InvalidGrading)?,
            ),
            None => problem.certify_positive_grading(&automatic_weights),
        };
        problem.graded_shell = problem.compute_graded_shell_layout();
        problem.recommended_backend = problem.compute_recommended_backend();
        Ok(problem)
    }

    #[inline]
    fn option_load_coordinate(&self, option: u32, coordinate: usize) -> u32 {
        let start = option as usize * self.capacities.len();
        self.option_loads.get(start + coordinate)
    }

    fn option_load_box(&self, option: u32) -> Box<[u32]> {
        (0..self.capacities.len())
            .map(|coordinate| self.option_load_coordinate(option, coordinate))
            .collect()
    }

    fn solve_impl<const DENSE: bool, const PACKED: bool, const WIDE: bool>(
        &self,
        _parallel: bool,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let width = self.capacities.len();
        let (dense_strides, dense_state_space) = if DENSE {
            let mut strides = Vec::with_capacity(width);
            let mut product = 1usize;
            for &capacity in &self.capacities {
                strides.push(product);
                product = product
                    .checked_mul(capacity as usize + 1)
                    .ok_or(SchedulerError::TooLarge)?;
                if product > MAX_DENSE_LATTICE_STATES {
                    return Err(SchedulerError::TooLarge);
                }
            }
            (strides, product)
        } else {
            (Vec::new(), 0)
        };
        let dense_option_deltas = if DENSE {
            (0..self.option_count as usize)
                .map(|option| {
                    dense_strides
                        .iter()
                        .enumerate()
                        .map(|(coordinate, &stride)| {
                            self.option_load_coordinate(option as u32, coordinate) as usize * stride
                        })
                        .sum()
                })
                .collect::<Vec<usize>>()
        } else {
            Vec::new()
        };
        let dense_packed = (DENSE && PACKED)
            .then(|| dense_packed_feasibility(self))
            .flatten();
        let graded_antichain = self.positive_grading.is_some();
        let store_loads = !(DENSE && dense_packed.is_some() && graded_antichain);
        let mut loads = if store_loads {
            vec![0u32; width]
        } else {
            Vec::new()
        };
        let mut witnesses = Vec::<ScheduleWitnessNode>::new();
        let mut states = vec![ScheduleState {
            load_start: 0,
            witness: NONE,
            repairs: 0,
            aux: 0,
        }];
        let mut packed_states = vec![0u128];
        let mut transitions_examined = 0u64;
        let mut peak_pareto_states = 1u32;
        let mut scratch = vec![0u32; width];
        let mut dense_index = if DENSE {
            vec![NONE; dense_state_space]
        } else {
            Vec::new()
        };
        let mut dense_touched = Vec::new();
        if DENSE && graded_antichain {
            dense_index[0] = 0;
        }

        for (demand, family) in self.families.iter().copied().enumerate() {
            let demand = u32::try_from(demand).map_err(|_| SchedulerError::TooLarge)?;
            let layer_witness_start = witnesses.len();
            let mut updated = Vec::with_capacity(states.len());
            let mut updated_packed = dense_packed
                .as_ref()
                .map(|_| packed_states.clone())
                .unwrap_or_default();
            let mut heads = FxHashMap::<u64, u32>::default();
            if !graded_antichain {
                for key in dense_touched.drain(..) {
                    dense_index[key] = NONE;
                }
            }
            for state in states.iter() {
                let mut copied = *state;
                let id = u32::try_from(updated.len()).map_err(|_| SchedulerError::TooLarge)?;
                if DENSE {
                    if !graded_antichain {
                        let key = copied.aux as usize;
                        dense_touched.push(key);
                        dense_index[key] = id;
                    }
                } else {
                    let hash = hash_load(&loads, copied.load_start as usize, width);
                    copied.aux = heads.get(&hash).copied().unwrap_or(NONE);
                    heads.insert(hash, id);
                }
                updated.push(copied);
            }

            for (state_index, state) in states.iter().enumerate() {
                let used_start = state.load_start as usize;
                let option_start = family.option_start;
                let option_end = option_start + family.option_len;
                for option in option_start..option_end {
                    transitions_examined += 1;
                    let candidate_packed =
                        dense_packed.as_ref().map(|(bias, guard, option_packed)| {
                            let packed = if WIDE {
                                packed_states[state_index] + option_packed[option as usize]
                            } else {
                                u128::from(
                                    (packed_states[state_index] as u64)
                                        + (option_packed[option as usize] as u64),
                                )
                            };
                            let feasible = if WIDE {
                                (packed + bias) & guard == 0
                            } else {
                                ((packed as u64) + (*bias as u64)) & (*guard as u64) == 0
                            };
                            (packed, feasible)
                        });
                    let mut feasible = candidate_packed
                        .as_ref()
                        .map(|&(_, feasible)| feasible)
                        .unwrap_or(true);
                    if candidate_packed.is_none() {
                        for coordinate in 0..width {
                            let Some(sum) = loads[used_start + coordinate]
                                .checked_add(self.option_load_coordinate(option, coordinate))
                            else {
                                feasible = false;
                                break;
                            };
                            scratch[coordinate] = sum;
                            feasible &= sum <= self.capacities[coordinate];
                        }
                    }
                    if !feasible {
                        continue;
                    }
                    let repairs = state.repairs + 1;
                    let hash = (!DENSE).then(|| hash_slice(&scratch));
                    let incumbent = if DENSE {
                        let key = state.aux as usize + dense_option_deltas[option as usize];
                        dense_index[key]
                    } else {
                        let hash = hash.expect("flat lookup has a hash");
                        let mut cursor = heads.get(&hash).copied().unwrap_or(NONE);
                        let mut found = NONE;
                        while cursor != NONE {
                            let candidate = updated[cursor as usize];
                            let start = candidate.load_start as usize;
                            if loads[start..start + width] == scratch {
                                found = cursor;
                                break;
                            }
                            cursor = candidate.aux;
                        }
                        found
                    };
                    if incumbent != NONE && updated[incumbent as usize].repairs >= repairs {
                        continue;
                    }
                    let witness =
                        u32::try_from(witnesses.len()).map_err(|_| SchedulerError::TooLarge)?;
                    witnesses.push(ScheduleWitnessNode {
                        parent: state.witness,
                        demand,
                        option,
                        repairs,
                    });
                    if incumbent != NONE {
                        let record = &mut updated[incumbent as usize];
                        record.witness = witness;
                        record.repairs = repairs;
                    } else {
                        if candidate_packed.is_some() && store_loads {
                            for coordinate in 0..width {
                                scratch[coordinate] = loads[used_start + coordinate]
                                    + self.option_load_coordinate(option, coordinate);
                            }
                        }
                        let load_start = if store_loads {
                            let start =
                                u32::try_from(loads.len()).map_err(|_| SchedulerError::TooLarge)?;
                            loads.extend_from_slice(&scratch);
                            start
                        } else {
                            0
                        };
                        let id =
                            u32::try_from(updated.len()).map_err(|_| SchedulerError::TooLarge)?;
                        updated.push(ScheduleState {
                            load_start,
                            witness,
                            repairs,
                            aux: if DENSE {
                                u32::try_from(
                                    state.aux as usize + dense_option_deltas[option as usize],
                                )
                                .map_err(|_| SchedulerError::TooLarge)?
                            } else {
                                hash.and_then(|hash| heads.get(&hash).copied())
                                    .unwrap_or(NONE)
                            },
                        });
                        if let Some((packed, _)) = candidate_packed {
                            updated_packed.push(packed);
                        }
                        if DENSE {
                            let key = state.aux as usize + dense_option_deltas[option as usize];
                            if !graded_antichain {
                                dense_touched.push(key);
                            }
                            dense_index[key] = id;
                        } else {
                            heads.insert(hash.expect("flat insertion has a hash"), id);
                        }
                    }
                }
            }

            if graded_antichain {
                if dense_packed.is_some() {
                    packed_states = updated_packed;
                }
                states = updated;
            } else {
                let dense_work = dense_state_space.saturating_mul(width);
                let quadratic_work = updated
                    .len()
                    .saturating_mul(updated.len())
                    .saturating_mul(width);
                let keep = if DENSE
                    && dense_work.saturating_mul(DENSE_DOMINANCE_WORK_MARGIN) <= quadratic_work
                {
                    dense_pareto_keep(
                        &updated,
                        &loads,
                        &self.capacities,
                        &dense_strides,
                        dense_state_space,
                        _parallel,
                    )
                } else {
                    quadratic_pareto_keep(&updated, &loads, width, _parallel)
                };
                if dense_packed.is_some() {
                    packed_states = updated_packed
                        .into_iter()
                        .zip(&keep)
                        .filter_map(|(packed, &keep)| keep.then_some(packed))
                        .collect();
                }
                states = updated
                    .into_iter()
                    .zip(keep)
                    .filter_map(|(state, keep)| keep.then_some(state))
                    .collect();
                let compact_capacity = states
                    .len()
                    .checked_mul(width)
                    .ok_or(SchedulerError::TooLarge)?;
                let mut compact_loads = Vec::with_capacity(compact_capacity);
                for state in &mut states {
                    let old_start = state.load_start as usize;
                    state.load_start =
                        u32::try_from(compact_loads.len()).map_err(|_| SchedulerError::TooLarge)?;
                    compact_loads.extend_from_slice(&loads[old_start..old_start + width]);
                }
                loads = compact_loads;
            }
            // Every witness born in this layer points only into earlier
            // layers, and no later-layer child exists yet. Retained states
            // therefore identify the complete live subset, which can be
            // compacted in place without a remap table.
            let mut next_witness = layer_witness_start;
            for state in &mut states {
                let witness = state.witness as usize;
                if state.witness == NONE || witness < layer_witness_start {
                    continue;
                }
                witnesses[next_witness] = witnesses[witness];
                state.witness =
                    u32::try_from(next_witness).map_err(|_| SchedulerError::TooLarge)?;
                next_witness += 1;
            }
            witnesses.truncate(next_witness);
            peak_pareto_states = peak_pareto_states
                .max(u32::try_from(states.len()).map_err(|_| SchedulerError::TooLarge)?);
        }

        let best_witness = select_best_witness(
            states.iter().map(|state| (state.repairs, state.witness)),
            &witnesses,
        );
        let chosen = witness_options(best_witness, &witnesses);
        let assignment: Vec<_> = chosen
            .iter()
            .map(|&(demand, option)| WeightedRepairChoice {
                demand,
                loads: self.option_load_box(option),
            })
            .collect();
        let mut repaired = vec![false; self.families.len()];
        for choice in &assignment {
            repaired[choice.demand as usize] = true;
        }
        let unmatched_demands = repaired
            .iter()
            .enumerate()
            .filter_map(|(demand, &done)| (!done).then_some(demand as u32))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        let mut total_loads = vec![0u64; width];
        for choice in &assignment {
            for (total, &load) in total_loads.iter_mut().zip(&choice.loads) {
                *total += u64::from(load);
            }
        }
        Ok(WeightedParallelRepairResult {
            assignment: assignment.into_boxed_slice(),
            unmatched_demands,
            total_loads: total_loads.into_boxed_slice(),
            transitions_examined,
            peak_pareto_states,
        })
    }

    fn solve_sparse_with_storage<const MEASURE_ALLOCATIONS: bool>(
        &self,
        storage: &mut SparseRepairStorage,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let width = self.capacities.len();
        storage.loads.clear();
        storage.loads.resize(width, 0);
        storage.compact_loads.clear();
        storage.witnesses.clear();
        storage.states.clear();
        storage.states.push(ScheduleState {
            load_start: 0,
            witness: NONE,
            repairs: 0,
            aux: 0,
        });
        storage.updated.clear();
        storage.scratch.clear();
        storage.scratch.resize(width, 0);
        storage.hash_weights.clear();
        storage
            .hash_weights
            .extend((0..width).map(load_hash_weight));
        storage.option_hashes.clear();
        for option in 0..self.option_count {
            let mut hash = 0_u64;
            for coordinate in 0..width {
                hash = hash.wrapping_add(
                    u64::from(self.option_load_coordinate(option, coordinate))
                        .wrapping_mul(storage.hash_weights[coordinate]),
                );
            }
            storage.option_hashes.push(hash);
        }
        storage.heads.begin_epoch();
        storage.keep.clear();

        let graded_antichain = self.positive_grading.is_some();
        let mut transitions_examined = 0_u64;
        let mut peak_pareto_states = 1_u32;

        #[cfg(test)]
        let _allocation_guard =
            MEASURE_ALLOCATIONS.then(crate::test_alloc::HotLoopAllocationGuard::enter);

        for (demand, family) in self.families.iter().copied().enumerate() {
            let demand = u32::try_from(demand).map_err(|_| SchedulerError::TooLarge)?;
            let layer_witness_start = storage.witnesses.len();
            storage.updated.clear();
            storage.heads.begin_epoch();
            for state in &storage.states {
                let mut copied = *state;
                storage.heads.prepare_insert(
                    &mut storage.updated,
                    &storage.loads,
                    &storage.hash_weights,
                );
                let id =
                    u32::try_from(storage.updated.len()).map_err(|_| SchedulerError::TooLarge)?;
                let hash = fingerprint_load(
                    &storage.loads,
                    copied.load_start as usize,
                    &storage.hash_weights,
                );
                copied.aux = storage.heads.get(hash).unwrap_or(NONE);
                storage.heads.insert(hash, id);
                storage.updated.push(copied);
            }

            for state in &storage.states {
                let used_start = state.load_start as usize;
                let used_hash = fingerprint_load(&storage.loads, used_start, &storage.hash_weights);
                let option_end = family.option_start + family.option_len;
                for option in family.option_start..option_end {
                    transitions_examined += 1;
                    let mut feasible = true;
                    for coordinate in 0..width {
                        let Some(sum) = storage.loads[used_start + coordinate]
                            .checked_add(self.option_load_coordinate(option, coordinate))
                        else {
                            feasible = false;
                            break;
                        };
                        storage.scratch[coordinate] = sum;
                        feasible &= sum <= self.capacities[coordinate];
                    }
                    if !feasible {
                        continue;
                    }
                    let repairs = state.repairs + 1;
                    let hash = used_hash.wrapping_add(storage.option_hashes[option as usize]);
                    let mut cursor = storage.heads.get(hash).unwrap_or(NONE);
                    let mut incumbent = NONE;
                    while cursor != NONE {
                        let candidate = storage.updated[cursor as usize];
                        let start = candidate.load_start as usize;
                        if storage.loads[start..start + width] == storage.scratch {
                            incumbent = cursor;
                            break;
                        }
                        cursor = candidate.aux;
                    }
                    if incumbent != NONE && storage.updated[incumbent as usize].repairs >= repairs {
                        continue;
                    }
                    let witness = u32::try_from(storage.witnesses.len())
                        .map_err(|_| SchedulerError::TooLarge)?;
                    storage.witnesses.push(ScheduleWitnessNode {
                        parent: state.witness,
                        demand,
                        option,
                        repairs,
                    });
                    if incumbent != NONE {
                        let record = &mut storage.updated[incumbent as usize];
                        record.witness = witness;
                        record.repairs = repairs;
                        continue;
                    }
                    let load_start =
                        u32::try_from(storage.loads.len()).map_err(|_| SchedulerError::TooLarge)?;
                    storage.loads.extend_from_slice(&storage.scratch);
                    storage.heads.prepare_insert(
                        &mut storage.updated,
                        &storage.loads,
                        &storage.hash_weights,
                    );
                    let id = u32::try_from(storage.updated.len())
                        .map_err(|_| SchedulerError::TooLarge)?;
                    storage.updated.push(ScheduleState {
                        load_start,
                        witness,
                        repairs,
                        aux: storage.heads.get(hash).unwrap_or(NONE),
                    });
                    storage.heads.insert(hash, id);
                }
            }

            if graded_antichain {
                std::mem::swap(&mut storage.states, &mut storage.updated);
            } else {
                quadratic_pareto_keep_into(
                    &storage.updated,
                    &storage.loads,
                    width,
                    &mut storage.keep,
                );
                storage.states.clear();
                for (index, &keep) in storage.keep.iter().enumerate() {
                    if keep != 0 {
                        storage.states.push(storage.updated[index]);
                    }
                }
                storage.compact_loads.clear();
                for state in &mut storage.states {
                    let old_start = state.load_start as usize;
                    state.load_start = u32::try_from(storage.compact_loads.len())
                        .map_err(|_| SchedulerError::TooLarge)?;
                    storage
                        .compact_loads
                        .extend_from_slice(&storage.loads[old_start..old_start + width]);
                }
                std::mem::swap(&mut storage.loads, &mut storage.compact_loads);
            }

            let mut next_witness = layer_witness_start;
            for state in &mut storage.states {
                let witness = state.witness as usize;
                if state.witness == NONE || witness < layer_witness_start {
                    continue;
                }
                storage.witnesses[next_witness] = storage.witnesses[witness];
                state.witness =
                    u32::try_from(next_witness).map_err(|_| SchedulerError::TooLarge)?;
                next_witness += 1;
            }
            storage.witnesses.truncate(next_witness);
            peak_pareto_states = peak_pareto_states
                .max(u32::try_from(storage.states.len()).map_err(|_| SchedulerError::TooLarge)?);
        }

        #[cfg(test)]
        drop(_allocation_guard);

        let best_witness = select_best_witness(
            storage
                .states
                .iter()
                .map(|state| (state.repairs, state.witness)),
            &storage.witnesses,
        );
        let chosen = witness_options(best_witness, &storage.witnesses);
        let assignment: Vec<_> = chosen
            .iter()
            .map(|&(demand, option)| WeightedRepairChoice {
                demand,
                loads: self.option_load_box(option),
            })
            .collect();
        let mut repaired = vec![false; self.families.len()];
        for choice in &assignment {
            repaired[choice.demand as usize] = true;
        }
        let unmatched_demands = repaired
            .iter()
            .enumerate()
            .filter_map(|(demand, &done)| (!done).then_some(demand as u32))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        let mut total_loads = vec![0_u64; width];
        for choice in &assignment {
            for (total, &load) in total_loads.iter_mut().zip(&choice.loads) {
                *total += u64::from(load);
            }
        }
        Ok(WeightedParallelRepairResult {
            assignment: assignment.into_boxed_slice(),
            unmatched_demands,
            total_loads: total_loads.into_boxed_slice(),
            transitions_examined,
            peak_pareto_states,
        })
    }

    pub fn solve(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let mut workspace = WeightedRepairWorkspace::new();
        self.solve_sparse_with_storage::<false>(&mut workspace.sparse)
    }

    /// Solve with reusable sparse-front storage.
    pub fn solve_sparse_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        self.solve_sparse_with_storage::<true>(&mut workspace.sparse)
    }

    /// Compatibility entry point for callers selecting a parallel backend.
    ///
    /// Sparse front construction remains serial because retained 1/12-worker
    /// controls found no end-to-end crossover. Adaptive dense solves still use
    /// their profitable parallel kernels.
    #[cfg(feature = "parallel")]
    pub fn solve_parallel(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let mut workspace = WeightedRepairWorkspace::new();
        self.solve_sparse_with_storage::<false>(&mut workspace.sparse)
    }

    /// Sparse solve with reusable storage through the parallel compatibility API.
    #[cfg(feature = "parallel")]
    pub fn solve_sparse_parallel_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        self.solve_sparse_with_storage::<true>(&mut workspace.sparse)
    }

    pub fn solve_adaptive(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let mut counted_workspace = WeightedRepairWorkspace::new();
        if let Some(result) = self.solve_counted_types_with_workspace(&mut counted_workspace)? {
            return Ok(result);
        }
        match self.recommended_backend() {
            WeightedSchedulerBackend::SparsePareto => self.solve(),
            WeightedSchedulerBackend::DenseLattice => self.solve_dense_lattice(),
        }
    }

    /// Selects the exact backend and parallelizes its profitable independent work.
    #[cfg(feature = "parallel")]
    pub fn solve_adaptive_parallel(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let mut workspace = WeightedRepairWorkspace::new();
        self.solve_adaptive_parallel_with_workspace(&mut workspace)
    }

    /// Parallel adaptive solve with reusable storage for fused dense kernels.
    #[cfg(feature = "parallel")]
    pub fn solve_adaptive_parallel_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        match self.recommended_backend() {
            WeightedSchedulerBackend::SparsePareto => {
                self.solve_sparse_parallel_with_workspace(workspace)
            }
            WeightedSchedulerBackend::DenseLattice => {
                self.solve_dense_lattice_parallel_with_workspace(workspace)
            }
        }
    }

    /// Solves adaptively while retaining narrow dense-kernel allocations.
    pub fn solve_adaptive_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        if let Some(result) = self.solve_counted_types_with_workspace(workspace)? {
            return Ok(result);
        }
        match self.recommended_backend() {
            WeightedSchedulerBackend::SparsePareto => self.solve_sparse_with_workspace(workspace),
            WeightedSchedulerBackend::DenseLattice => {
                self.solve_dense_lattice_with_workspace(workspace)
            }
        }
    }

    pub fn recommended_backend(&self) -> WeightedSchedulerBackend {
        self.recommended_backend
    }

    fn compute_recommended_backend(&self) -> WeightedSchedulerBackend {
        let Some(state_space) = self.dense_state_space().or_else(|| {
            self.graded_shell
                .as_ref()
                .map(|shell| shell.state_space as usize)
        }) else {
            return WeightedSchedulerBackend::SparsePareto;
        };
        let threshold = if self.positive_grading.is_some() {
            let denominator = if dense_packed_bits(&self.capacities).is_some_and(|bits| bits <= 64)
            {
                DENSE_GRADED_NARROW_OCCUPANCY_DENOMINATOR
            } else {
                DENSE_ANTICHAIN_OCCUPANCY_DENOMINATOR
            };
            state_space.div_ceil(denominator)
        } else {
            ceil_sqrt(state_space).saturating_mul(DENSE_REACHABLE_BOUND_MARGIN)
        };
        let mut reachable_bound = 1usize;
        for family in &self.families {
            reachable_bound = reachable_bound
                .saturating_mul(family.option_len as usize + 1)
                .min(threshold);
        }
        if reachable_bound >= threshold {
            WeightedSchedulerBackend::DenseLattice
        } else {
            WeightedSchedulerBackend::SparsePareto
        }
    }

    fn dense_state_space(&self) -> Option<usize> {
        (self.dense_state_space != 0).then_some(self.dense_state_space as usize)
    }

    fn compute_dense_state_space(&self) -> Option<usize> {
        self.capacities
            .iter()
            .try_fold(1usize, |product, &capacity| {
                let product = product.checked_mul(capacity as usize + 1)?;
                (product <= MAX_DENSE_LATTICE_STATES).then_some(product)
            })
    }

    pub fn positive_grading(&self) -> Option<&PositiveGradingCertificate> {
        self.positive_grading.as_ref()
    }

    /// Exact number of capacity-feasible load vectors across every attainable
    /// repair-depth grade retained by the shell address space.
    pub fn graded_shell_state_space(&self) -> Option<usize> {
        self.graded_shell
            .as_ref()
            .map(|shell| shell.state_space as usize)
    }

    fn graded_repair_upper_bound(&self) -> Option<usize> {
        let grading = self.positive_grading.as_ref()?;
        let capacity_mass = self
            .capacities
            .iter()
            .zip(&grading.weights)
            .try_fold(0u64, |sum, (&capacity, &weight)| {
                sum.checked_add(u64::from(capacity) * u64::from(weight))
            })?;
        usize::try_from(capacity_mass / grading.option_mass)
            .ok()
            .map(|repairs| repairs.min(self.families.len()))
    }

    fn certify_positive_grading(&self, weights: &[u32]) -> Option<PositiveGradingCertificate> {
        if weights.len() != self.capacities.len() || weights.contains(&0) {
            return None;
        }
        (self.option_count != 0).then_some(())?;
        let expected =
            weights
                .iter()
                .enumerate()
                .try_fold(0u64, |sum, (coordinate, &weight)| {
                    sum.checked_add(
                        u64::from(self.option_load_coordinate(0, coordinate)) * u64::from(weight),
                    )
                })?;
        if expected == 0 {
            return None;
        }
        (0..self.option_count as usize)
            .all(|option| {
                weights
                    .iter()
                    .enumerate()
                    .try_fold(0u64, |sum, (coordinate, &weight)| {
                        sum.checked_add(
                            u64::from(self.option_load_coordinate(option as u32, coordinate))
                                * u64::from(weight),
                        )
                    })
                    == Some(expected)
            })
            .then(|| PositiveGradingCertificate {
                weights: weights.into(),
                option_mass: expected,
            })
    }

    fn compute_graded_shell_layout(&self) -> Option<GradedShellLayout> {
        let grading = self.positive_grading.as_ref()?;
        let maximum_repairs = self.graded_repair_upper_bound()?;
        if maximum_repairs > u8::MAX as usize {
            return None;
        }
        let maximum_mass = u64::try_from(maximum_repairs)
            .ok()?
            .checked_mul(grading.option_mass)?;
        let maximum_mass = usize::try_from(maximum_mass).ok()?;
        let mass_stride = maximum_mass.checked_add(1)?;
        let rows = self.capacities.len().checked_add(1)?;
        let cells = rows.checked_mul(mass_stride)?;
        if cells > MAX_GRADED_SHELL_TABLE_CELLS {
            return None;
        }
        let count_limit = MAX_DENSE_LATTICE_STATES as u64 + 1;
        let mut suffix_counts = vec![0u32; cells];
        let mut rank_prefixes = vec![0u64; cells];
        suffix_counts[self.capacities.len() * mass_stride] = 1;
        for coordinate in (0..self.capacities.len()).rev() {
            let weight = grading.weights[coordinate] as usize;
            let capacity = self.capacities[coordinate] as usize;
            let residue_count = weight.min(mass_stride);
            for residue in 0..residue_count {
                let mut prefix = 0u64;
                for (step, mass) in (residue..=maximum_mass).step_by(weight).enumerate() {
                    prefix += u64::from(suffix_counts[(coordinate + 1) * mass_stride + mass]);
                    rank_prefixes[coordinate * mass_stride + mass] = prefix;
                    let expired = (step > capacity).then(|| {
                        rank_prefixes[coordinate * mass_stride + mass - (capacity + 1) * weight]
                    });
                    suffix_counts[coordinate * mass_stride + mass] =
                        (prefix - expired.unwrap_or(0)).min(count_limit) as u32;
                }
            }
        }
        let mut depth_offsets = Vec::with_capacity(maximum_repairs + 1);
        let mut state_space = 0u64;
        for repairs in 0..=maximum_repairs {
            depth_offsets.push(u32::try_from(state_space).ok()?);
            let mass = u64::try_from(repairs)
                .ok()?
                .checked_mul(grading.option_mass)?;
            let mass = usize::try_from(mass).ok()?;
            state_space = state_space.checked_add(u64::from(suffix_counts[mass]))?;
            if state_space > MAX_DENSE_LATTICE_STATES as u64 {
                return None;
            }
        }
        Some(GradedShellLayout {
            mass_stride: u32::try_from(mass_stride).ok()?,
            rank_prefixes: rank_prefixes.into_boxed_slice(),
            depth_offsets: depth_offsets.into_boxed_slice(),
            state_space: u32::try_from(state_space).ok()?,
        })
    }

    fn solve_graded_dense_narrow<const SHELL: bool>(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        debug_assert!(self.positive_grading.is_some());
        let width = self.capacities.len();
        let shell = SHELL.then_some(self.graded_shell.as_ref()).flatten();
        let dense_state_space = if let Some(shell) = shell {
            shell.state_space as usize
        } else {
            self.dense_state_space().ok_or(SchedulerError::TooLarge)?
        };
        let WeightedRepairWorkspace {
            strides,
            option_deltas,
            packed_shifts,
            option_packed,
            states,
            updated,
            seen,
            witnesses,
            lex_codes,
            best_options,
            repaired,
            total_loads,
            ..
        } = workspace;
        strides.clear();
        if strides.capacity() < width {
            strides.reserve_exact(width);
        }
        let mut product = 1usize;
        for &capacity in &self.capacities {
            strides.push(product);
            product = product
                .checked_mul(capacity as usize + 1)
                .ok_or(SchedulerError::TooLarge)?;
        }
        if !SHELL {
            debug_assert_eq!(product, dense_state_space);
        }
        option_deltas.clear();
        if option_deltas.capacity() < self.option_count as usize {
            option_deltas.reserve_exact(self.option_count as usize);
        }
        for option in 0..self.option_count as usize {
            option_deltas.push(
                strides
                    .iter()
                    .enumerate()
                    .map(|(coordinate, &stride)| {
                        self.option_load_coordinate(option as u32, coordinate) as usize * stride
                    })
                    .sum::<usize>(),
            );
        }
        packed_shifts.clear();
        if packed_shifts.capacity() < width {
            packed_shifts.reserve_exact(width);
        }
        let mut shift = 0u32;
        let mut bias = 0u64;
        let mut guard = 0u64;
        for &capacity in &self.capacities {
            let value_bits = (u64::from(capacity) + 1)
                .next_power_of_two()
                .trailing_zeros();
            let lane_bits = value_bits + 1;
            if shift.checked_add(lane_bits).is_none_or(|end| end > 64) {
                return Err(SchedulerError::TooLarge);
            }
            packed_shifts.push(shift);
            let lane_limit = 1u64 << value_bits;
            bias |= (lane_limit - 1 - u64::from(capacity)) << shift;
            guard |= lane_limit << shift;
            shift += lane_bits;
        }
        option_packed.clear();
        if option_packed.capacity() < self.option_count as usize {
            option_packed.reserve_exact(self.option_count as usize);
        }
        for option in 0..self.option_count as usize {
            option_packed.push(
                packed_shifts
                    .iter()
                    .enumerate()
                    .map(|(coordinate, &shift)| {
                        u64::from(self.option_load_coordinate(option as u32, coordinate)) << shift
                    })
                    .sum(),
            );
        }
        let lex_base = u64::from(self.option_count) + 1;
        let maximum_repairs = self.graded_repair_upper_bound();
        debug_assert!(maximum_repairs.is_some_and(|repairs| repairs <= u8::MAX as usize));
        let lex_codes_fit = maximum_repairs.is_some_and(|repairs| {
            (0..repairs)
                .try_fold(1u64, |span, _| span.checked_mul(lex_base))
                .is_some()
        });

        states.clear();
        states.push(GradedDenseState {
            packed_loads: 0,
            witness: NONE,
            key_repairs: 0,
        });
        updated.clear();
        let seen_words = dense_state_space.div_ceil(u64::BITS as usize);
        seen.resize(seen_words, 0);
        seen.fill(0);
        seen[0] = 1;
        witnesses.clear();
        let mut transitions_examined = 0u64;
        let mut peak_pareto_states = 1u32;

        for family in self.families.iter().copied() {
            let capacity = states
                .len()
                .saturating_mul(family.option_len as usize + 1)
                .min(dense_state_space);
            updated.clear();
            if updated.capacity() < capacity {
                updated.reserve_exact(capacity);
            }
            updated.extend_from_slice(states);
            for state in states.iter() {
                let repairs = state.repairs();
                let option_end = family.option_start + family.option_len;
                for option in family.option_start..option_end {
                    transitions_examined += 1;
                    let packed_loads = state.packed_loads + option_packed[option as usize];
                    if (packed_loads + bias) & guard != 0 {
                        continue;
                    }
                    let key = if let Some(shell) = shell {
                        shell.rank_packed(
                            packed_loads,
                            packed_shifts,
                            &self.capacities,
                            self.positive_grading.as_ref().expect("checked grading"),
                            repairs as usize + 1,
                        )? as usize
                    } else {
                        state.key() as usize + option_deltas[option as usize]
                    };
                    let seen_word = key / u64::BITS as usize;
                    let seen_bit = 1u64 << (key % u64::BITS as usize);
                    if seen[seen_word] & seen_bit != 0 {
                        continue;
                    }
                    let witness =
                        u32::try_from(witnesses.len()).map_err(|_| SchedulerError::TooLarge)?;
                    if witness >= GRADED_PARENT_NONE {
                        return Err(SchedulerError::TooLarge);
                    }
                    witnesses.push(GradedWitnessNode {
                        parent: state.witness,
                        option,
                    });
                    let key = u32::try_from(key).map_err(|_| SchedulerError::TooLarge)?;
                    debug_assert_eq!(key & !GRADED_KEY_MASK, 0);
                    updated.push(GradedDenseState {
                        packed_loads,
                        witness,
                        key_repairs: key | ((repairs + 1) << 24),
                    });
                    seen[seen_word] |= seen_bit;
                }
            }
            std::mem::swap(states, updated);
            peak_pareto_states = peak_pareto_states
                .max(u32::try_from(states.len()).map_err(|_| SchedulerError::TooLarge)?);
        }

        lex_codes.clear();
        if lex_codes_fit {
            if lex_codes.capacity() < witnesses.len() {
                lex_codes.reserve_exact(witnesses.len());
            }
            for node in witnesses.iter().copied() {
                let parent_code = if node.parent == NONE {
                    0
                } else {
                    lex_codes[node.parent as usize]
                };
                lex_codes.push(
                    parent_code
                        .checked_mul(lex_base)
                        .and_then(|code| code.checked_add(u64::from(node.option) + 1))
                        .expect("prechecked lexicographic code span"),
                );
            }
        }

        let mut best = states[0];
        let mut best_repairs = best.repairs();
        if lex_codes_fit {
            let mut best_code = 0u64;
            for &state in &states[1..] {
                let repairs = state.repairs();
                let code = if state.witness == NONE {
                    0
                } else {
                    lex_codes[state.witness as usize]
                };
                if repairs > best_repairs || repairs == best_repairs && code > best_code {
                    best = state;
                    best_repairs = repairs;
                    best_code = code;
                }
            }
        } else {
            for &state in &states[1..] {
                let repairs = state.repairs();
                if repairs > best_repairs
                    || repairs == best_repairs
                        && compare_graded_witnesses(state.witness, best.witness, witnesses).is_gt()
                {
                    best = state;
                    best_repairs = repairs;
                }
            }
        }
        debug_assert_eq!(best_repairs, best.repairs());
        best_options.clear();
        if best_options.capacity() < best_repairs as usize {
            best_options.reserve_exact(best_repairs as usize);
        }
        let mut cursor = best.witness;
        while cursor != NONE {
            let node = witnesses[cursor as usize];
            let demand = self
                .families
                .iter()
                .position(|family| {
                    node.option >= family.option_start
                        && node.option < family.option_start + family.option_len
                })
                .ok_or(SchedulerError::TooLarge)?;
            best_options.push((
                u32::try_from(demand).map_err(|_| SchedulerError::TooLarge)?,
                node.option,
            ));
            cursor = node.parent;
        }
        best_options.reverse();
        let assignment = best_options
            .iter()
            .map(|&(demand, option)| WeightedRepairChoice {
                demand,
                loads: self.option_load_box(option),
            })
            .collect::<Vec<_>>();
        repaired.resize(self.families.len(), false);
        repaired.fill(false);
        total_loads.resize(width, 0);
        total_loads.fill(0);
        for choice in &assignment {
            repaired[choice.demand as usize] = true;
            for (total, &load) in total_loads.iter_mut().zip(&choice.loads) {
                *total += u64::from(load);
            }
        }
        let unmatched_demands = repaired
            .iter()
            .enumerate()
            .filter_map(|(demand, &done)| (!done).then_some(demand as u32))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        Ok(WeightedParallelRepairResult {
            assignment: assignment.into_boxed_slice(),
            unmatched_demands,
            total_loads: total_loads.clone().into_boxed_slice(),
            transitions_examined,
            peak_pareto_states,
        })
    }

    /// Exact counted-type reduction for instances that repeat a small number of
    /// distinct demand families many times.
    ///
    /// Demands whose compiled option sets are identical are interchangeable, so
    /// the optimum depends on the multiset of types rather than on the
    /// individual demands. This solves the relaxation in which each type may be
    /// used any number of times: a dynamic program over the capacity lattice
    /// whose cost is the lattice size times the number of distinct options, and
    /// therefore independent of the demand count. It then checks the recovered
    /// witness against the true multiplicities. A witness that respects every
    /// multiplicity is feasible for the original problem, and since the
    /// relaxation's optimum is an upper bound on the original optimum, such a
    /// witness is exactly optimal. The check is what makes the reduction sound;
    /// nothing here assumes the multiplicities are large.
    ///
    /// Returns `Ok(None)` when the reduction does not apply or does not
    /// certify, in which case the caller uses a general backend. A `None` costs
    /// only the dynamic program, never correctness.
    pub fn solve_counted_types(
        &self,
    ) -> Result<Option<WeightedParallelRepairResult>, SchedulerError> {
        let mut workspace = WeightedRepairWorkspace::new();
        self.solve_counted_types_with_workspace(&mut workspace)
    }

    /// Counted-type reduction reusing caller-owned storage.
    ///
    /// Every buffer is cleared and resized in place, and the dynamic-programming
    /// scan itself allocates nothing, so a warm workspace makes a repeat solve
    /// of the same shape allocation-free.
    pub fn solve_counted_types_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<Option<WeightedParallelRepairResult>, SchedulerError> {
        let width = self.capacities.len();
        if width == 0 || self.families.is_empty() {
            return Ok(None);
        }
        let Some(state_space) = self.dense_state_space() else {
            return Ok(None);
        };
        let storage = &mut workspace.counted;

        // Group families by their compiled option list. Compilation
        // canonicalizes each family to a Pareto-minimal antichain in a fixed
        // order, so identical demands produce identical keys. At most
        // COUNTED_TYPE_MAX_KINDS distinct keys are ever retained, so grouping is
        // a bounded linear scan and needs no hash map.
        storage.kind_key.clear();
        storage.kind_key_offset.clear();
        storage.kind_representative.clear();
        storage.kind_count.clear();
        storage.kind_of_demand.clear();
        storage.kind_key_offset.push(0);
        for family in self.families.iter() {
            storage.key_scratch.clear();
            let option_end = family.option_start + family.option_len;
            for option in family.option_start..option_end {
                for coordinate in 0..width {
                    storage
                        .key_scratch
                        .push(self.option_load_coordinate(option, coordinate));
                }
            }
            let mut found = None;
            for kind in 0..storage.kind_representative.len() {
                let start = storage.kind_key_offset[kind] as usize;
                let end = storage.kind_key_offset[kind + 1] as usize;
                if storage.kind_key[start..end] == storage.key_scratch[..] {
                    found = Some(kind);
                    break;
                }
            }
            match found {
                Some(kind) => {
                    storage.kind_count[kind] += 1;
                    storage.kind_of_demand.push(kind as u32);
                }
                None => {
                    if storage.kind_representative.len() == COUNTED_TYPE_MAX_KINDS {
                        return Ok(None);
                    }
                    storage
                        .kind_of_demand
                        .push(storage.kind_representative.len() as u32);
                    storage.kind_key.extend_from_slice(&storage.key_scratch);
                    storage.kind_key_offset.push(
                        u32::try_from(storage.kind_key.len())
                            .map_err(|_| SchedulerError::TooLarge)?,
                    );
                    storage.kind_representative.push(*family);
                    storage.kind_count.push(1);
                }
            }
        }
        let kinds = storage.kind_representative.len();

        // Profitability gate: the reduction pays for itself only when families
        // repeat heavily. Instances whose families are mostly distinct keep the
        // general backends and their recorded work counts unchanged.
        if self.families.len() < COUNTED_TYPE_MIN_REPETITION * kinds {
            return Ok(None);
        }

        storage.strides.clear();
        storage.strides.resize(width, 0);
        let mut stride = 1u64;
        for coordinate in 0..width {
            storage.strides[coordinate] = stride;
            stride *= u64::from(self.capacities[coordinate]) + 1;
        }

        // Flatten the distinct options and their lattice deltas. A zero-load
        // option would be a self-loop in the forward scan; such an instance is
        // left to the general backends.
        storage.option_kind.clear();
        storage.option_index.clear();
        storage.option_delta.clear();
        storage.option_loads.clear();
        for kind in 0..kinds {
            let family = storage.kind_representative[kind];
            let option_end = family.option_start + family.option_len;
            for option in family.option_start..option_end {
                let mut delta = 0u64;
                let mut fits = true;
                for coordinate in 0..width {
                    let load = u64::from(self.option_load_coordinate(option, coordinate));
                    if load > u64::from(self.capacities[coordinate]) {
                        fits = false;
                        break;
                    }
                    delta += load * storage.strides[coordinate];
                }
                if !fits {
                    continue;
                }
                // A zero-load option would be a self-loop in the forward scan;
                // such an instance is left to the general backends.
                if delta == 0 {
                    return Ok(None);
                }
                storage
                    .option_kind
                    .push(u32::try_from(kind).map_err(|_| SchedulerError::TooLarge)?);
                storage.option_index.push(option);
                storage.option_delta.push(delta);
                for coordinate in 0..width {
                    storage
                        .option_loads
                        .push(self.option_load_coordinate(option, coordinate));
                }
            }
        }
        if storage.option_kind.is_empty() {
            return Ok(None);
        }

        const UNREACHABLE: u32 = u32::MAX;
        storage.best.clear();
        storage.best.resize(state_space, UNREACHABLE);
        storage.arrival.clear();
        storage.arrival.resize(state_space, UNREACHABLE);
        storage.best[0] = 0;
        let mut transitions_examined = 0u64;
        let mut reachable = 0u32;
        let slots = storage.option_kind.len();

        // The guard is scoped to the scan alone: witness reconstruction and
        // result construction below own their output and must allocate.
        {
            #[cfg(test)]
            let _allocation_guard = crate::test_alloc::HotLoopAllocationGuard::enter();

            for key in 0..state_space {
                let repairs = storage.best[key];
                if repairs == UNREACHABLE {
                    continue;
                }
                reachable += 1;
                for slot in 0..slots {
                    let next = key as u64 + storage.option_delta[slot];
                    if next >= state_space as u64 {
                        continue;
                    }
                    let next = next as usize;
                    // A mixed-radix add is a real transition only when no
                    // coordinate carried into the next digit.
                    let mut feasible = true;
                    for coordinate in 0..width {
                        let radix = u64::from(self.capacities[coordinate]) + 1;
                        let used = key as u64 / storage.strides[coordinate] % radix;
                        let load = u64::from(storage.option_loads[slot * width + coordinate]);
                        if used + load >= radix {
                            feasible = false;
                            break;
                        }
                    }
                    if !feasible {
                        continue;
                    }
                    transitions_examined += 1;
                    if storage.best[next] == UNREACHABLE || storage.best[next] < repairs + 1 {
                        storage.best[next] = repairs + 1;
                        storage.arrival[next] = slot as u32;
                    }
                }
            }
        }

        let mut optimum = 0u32;
        let mut optimum_key = 0usize;
        for (key, &repairs) in storage.best.iter().enumerate() {
            if repairs != UNREACHABLE && repairs > optimum {
                optimum = repairs;
                optimum_key = key;
            }
        }

        // Walk the witness back and count how many demands of each type it uses.
        storage.used.clear();
        storage.used.resize(kinds, 0);
        storage.chosen.clear();
        let mut cursor = optimum_key;
        while cursor != 0 {
            let slot = storage.arrival[cursor];
            if slot == UNREACHABLE {
                return Ok(None);
            }
            let slot = slot as usize;
            storage.used[storage.option_kind[slot] as usize] += 1;
            storage.chosen.push(slot as u32);
            cursor -= storage.option_delta[slot] as usize;
        }

        // The certificate: the relaxation drops each type's multiplicity bound,
        // so its optimum is an upper bound on the true optimum. A relaxed
        // witness that respects every multiplicity is feasible for the original
        // problem, and therefore exactly optimal. Without this check the answer
        // would be an upper bound only, so a failure declines rather than
        // returns.
        for kind in 0..kinds {
            if storage.used[kind] > storage.kind_count[kind] {
                return Ok(None);
            }
        }

        storage.taken.clear();
        storage.taken.resize(kinds, 0);
        storage.total_loads.clear();
        storage.total_loads.resize(width, 0);
        let mut assignment = Vec::with_capacity(storage.chosen.len());
        // Hand each used type its own demands, in increasing demand order.
        for index in 0..storage.chosen.len() {
            let slot = storage.chosen[index] as usize;
            let kind = storage.option_kind[slot];
            let mut demand = u32::MAX;
            let mut seen = 0u32;
            for (candidate, &owner) in storage.kind_of_demand.iter().enumerate() {
                if owner == kind {
                    if seen == storage.taken[kind as usize] {
                        demand = candidate as u32;
                        break;
                    }
                    seen += 1;
                }
            }
            if demand == u32::MAX {
                return Ok(None);
            }
            storage.taken[kind as usize] += 1;
            let loads = self.option_load_box(storage.option_index[slot]);
            for (total, &load) in storage.total_loads.iter_mut().zip(loads.iter()) {
                *total += u64::from(load);
            }
            assignment.push(WeightedRepairChoice { demand, loads });
        }
        assignment.sort_unstable_by_key(|choice| choice.demand);

        let mut unmatched_demands = Vec::with_capacity(self.families.len() - assignment.len());
        let mut next = 0usize;
        for demand in 0..self.families.len() as u32 {
            if next < assignment.len() && assignment[next].demand == demand {
                next += 1;
            } else {
                unmatched_demands.push(demand);
            }
        }

        Ok(Some(WeightedParallelRepairResult {
            assignment: assignment.into_boxed_slice(),
            unmatched_demands: unmatched_demands.into_boxed_slice(),
            total_loads: storage.total_loads.clone().into_boxed_slice(),
            transitions_examined,
            peak_pareto_states: reachable,
        }))
    }

    pub fn solve_dense_lattice(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let mut workspace = WeightedRepairWorkspace::new();
        self.solve_dense_lattice_with_workspace(&mut workspace)
    }

    /// Solves with the dense backend while retaining narrow-kernel allocations.
    pub fn solve_dense_lattice_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        if dense_packed_bits(&self.capacities).is_some_and(|bits| bits <= 64) {
            if self
                .graded_repair_upper_bound()
                .is_some_and(|repairs| repairs <= u8::MAX as usize)
            {
                if self.dense_state_space().is_some() {
                    self.solve_graded_dense_narrow::<false>(workspace)
                } else if self.graded_shell.is_some() {
                    self.solve_graded_dense_narrow::<true>(workspace)
                } else {
                    Err(SchedulerError::TooLarge)
                }
            } else {
                self.solve_impl::<true, true, false>(false)
            }
        } else {
            self.solve_impl::<true, true, true>(false)
        }
    }

    #[cfg(feature = "parallel")]
    fn solve_dense_lattice_parallel_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        if dense_packed_bits(&self.capacities).is_some_and(|bits| bits <= 64) {
            if self
                .graded_repair_upper_bound()
                .is_some_and(|repairs| repairs <= u8::MAX as usize)
            {
                self.solve_dense_lattice_with_workspace(workspace)
            } else {
                self.solve_impl::<true, true, false>(true)
            }
        } else {
            self.solve_impl::<true, true, true>(true)
        }
    }

    #[doc(hidden)]
    pub fn solve_graded_shell_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        if dense_packed_bits(&self.capacities).is_none_or(|bits| bits > 64)
            || self.graded_shell.is_none()
        {
            return Err(SchedulerError::TooLarge);
        }
        self.solve_graded_dense_narrow::<true>(workspace)
    }

    #[doc(hidden)]
    pub fn solve_dense_lattice_unpacked(
        &self,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        self.solve_impl::<true, false, false>(false)
    }

    #[doc(hidden)]
    pub fn solve_dense_lattice_wide(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        self.solve_impl::<true, true, true>(false)
    }

    pub fn solve_mixed_radix(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let width = self.capacities.len();
        let mut strides = Vec::with_capacity(width);
        let mut state_space = 1u64;
        for &capacity in &self.capacities {
            strides.push(state_space);
            state_space = state_space
                .checked_mul(u64::from(capacity) + 1)
                .ok_or(SchedulerError::TooLarge)?;
        }
        let mut option_deltas = Vec::with_capacity(self.option_count as usize);
        for option in 0..self.option_count as usize {
            let delta = strides
                .iter()
                .enumerate()
                .try_fold(0u64, |sum, (coordinate, &stride)| {
                    sum.checked_add(
                        u64::from(self.option_load_coordinate(option as u32, coordinate)) * stride,
                    )
                })
                .ok_or(SchedulerError::TooLarge)?;
            option_deltas.push(delta);
        }

        let mut witnesses = Vec::<ScheduleWitnessNode>::new();
        let mut states = vec![MixedRadixState {
            key: 0,
            witness: NONE,
            repairs: 0,
        }];
        let mut transitions_examined = 0u64;
        let mut peak_pareto_states = 1u32;

        for (demand, family) in self.families.iter().copied().enumerate() {
            let mut updated = states.clone();
            let mut index = FxHashMap::<u64, u32>::default();
            for (state_id, state) in updated.iter().enumerate() {
                index.insert(
                    state.key,
                    u32::try_from(state_id).map_err(|_| SchedulerError::TooLarge)?,
                );
            }
            for state in &states {
                let option_start = family.option_start;
                let option_end = option_start + family.option_len;
                for option in option_start..option_end {
                    transitions_examined += 1;
                    let feasible = (0..width).all(|coordinate| {
                        let load = self.option_load_coordinate(option, coordinate);
                        let radix = u64::from(self.capacities[coordinate]) + 1;
                        let used = state.key / strides[coordinate] % radix;
                        u64::from(load) <= u64::from(self.capacities[coordinate]) - used
                    });
                    if !feasible {
                        continue;
                    }
                    let key = state.key + option_deltas[option as usize];
                    let repairs = state.repairs + 1;
                    if let Some(&incumbent) = index.get(&key) {
                        if updated[incumbent as usize].repairs >= repairs {
                            continue;
                        }
                        let witness =
                            u32::try_from(witnesses.len()).map_err(|_| SchedulerError::TooLarge)?;
                        witnesses.push(ScheduleWitnessNode {
                            parent: state.witness,
                            demand: u32::try_from(demand).map_err(|_| SchedulerError::TooLarge)?,
                            option,
                            repairs,
                        });
                        updated[incumbent as usize].repairs = repairs;
                        updated[incumbent as usize].witness = witness;
                    } else {
                        let witness =
                            u32::try_from(witnesses.len()).map_err(|_| SchedulerError::TooLarge)?;
                        witnesses.push(ScheduleWitnessNode {
                            parent: state.witness,
                            demand: u32::try_from(demand).map_err(|_| SchedulerError::TooLarge)?,
                            option,
                            repairs,
                        });
                        let state_id =
                            u32::try_from(updated.len()).map_err(|_| SchedulerError::TooLarge)?;
                        updated.push(MixedRadixState {
                            key,
                            witness,
                            repairs,
                        });
                        index.insert(key, state_id);
                    }
                }
            }

            let decoded_capacity = updated
                .len()
                .checked_mul(width)
                .ok_or(SchedulerError::TooLarge)?;
            let mut decoded = Vec::with_capacity(decoded_capacity);
            for state in &updated {
                decoded.extend(
                    self.capacities
                        .iter()
                        .enumerate()
                        .map(|(coordinate, &cap)| {
                            (state.key / strides[coordinate] % (u64::from(cap) + 1)) as u32
                        }),
                );
            }
            let mut keep = vec![true; updated.len()];
            for (state_index, state) in updated.iter().enumerate() {
                let state_start = state_index * width;
                keep[state_index] = !updated.iter().enumerate().any(|(other_index, other)| {
                    other_index != state_index
                        && other.repairs >= state.repairs
                        && decoded[other_index * width..(other_index + 1) * width]
                            .iter()
                            .zip(&decoded[state_start..state_start + width])
                            .all(|(left, right)| left <= right)
                });
            }
            states = updated
                .into_iter()
                .zip(keep)
                .filter_map(|(state, keep)| keep.then_some(state))
                .collect();
            peak_pareto_states = peak_pareto_states
                .max(u32::try_from(states.len()).map_err(|_| SchedulerError::TooLarge)?);
        }

        let best_witness = select_best_witness(
            states.iter().map(|state| (state.repairs, state.witness)),
            &witnesses,
        );
        self.finish_result(
            best_witness,
            &witnesses,
            transitions_examined,
            peak_pareto_states,
        )
    }

    fn finish_result(
        &self,
        witness: u32,
        witnesses: &[ScheduleWitnessNode],
        transitions_examined: u64,
        peak_pareto_states: u32,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        let chosen = witness_options(witness, witnesses);
        let assignment: Vec<_> = chosen
            .iter()
            .map(|&(demand, option)| WeightedRepairChoice {
                demand,
                loads: self.option_load_box(option),
            })
            .collect();
        let mut repaired = vec![false; self.families.len()];
        let mut total_loads = vec![0u64; self.capacities.len()];
        for choice in &assignment {
            repaired[choice.demand as usize] = true;
            for (total, &load) in total_loads.iter_mut().zip(&choice.loads) {
                *total += u64::from(load);
            }
        }
        let unmatched_demands = repaired
            .iter()
            .enumerate()
            .filter_map(|(demand, &done)| (!done).then_some(demand as u32))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        Ok(WeightedParallelRepairResult {
            assignment: assignment.into_boxed_slice(),
            unmatched_demands,
            total_loads: total_loads.into_boxed_slice(),
            transitions_examined,
            peak_pareto_states,
        })
    }
}

fn ceil_sqrt(value: usize) -> usize {
    let mut low = 0usize;
    let mut high = value;
    while low < high {
        let middle = low + (high - low) / 2;
        if middle != 0 && middle >= value.div_ceil(middle) {
            high = middle;
        } else {
            low = middle + 1;
        }
    }
    low
}

fn dense_packed_bits(capacities: &[u32]) -> Option<u32> {
    capacities.iter().try_fold(0u32, |bits, &capacity| {
        let value_bits = (u64::from(capacity) + 1)
            .next_power_of_two()
            .trailing_zeros();
        bits.checked_add(value_bits + 1)
    })
}

fn dense_packed_feasibility(problem: &WeightedRepairProblem) -> Option<(u128, u128, Vec<u128>)> {
    let mut shifts = Vec::with_capacity(problem.capacities.len());
    let mut shift = 0u32;
    let mut bias = 0u128;
    let mut guard = 0u128;
    for &capacity in &problem.capacities {
        let value_bits = (u64::from(capacity) + 1)
            .next_power_of_two()
            .trailing_zeros();
        let lane_bits = value_bits + 1;
        if shift.checked_add(lane_bits)? > 128 {
            return None;
        }
        shifts.push(shift);
        let lane_limit = 1u128 << value_bits;
        bias |= (lane_limit - 1 - u128::from(capacity)) << shift;
        guard |= lane_limit << shift;
        shift += lane_bits;
    }
    let option_packed = (0..problem.option_count as usize)
        .map(|option| {
            shifts
                .iter()
                .enumerate()
                .map(|(coordinate, &shift)| {
                    u128::from(problem.option_load_coordinate(option as u32, coordinate)) << shift
                })
                .sum()
        })
        .collect();
    Some((bias, guard, option_packed))
}

fn dense_pareto_keep(
    states: &[ScheduleState],
    loads: &[u32],
    capacities: &[u32],
    strides: &[usize],
    state_space: usize,
    _parallel: bool,
) -> Vec<bool> {
    let width = capacities.len();
    let mut keys = Vec::with_capacity(states.len());
    let mut prefix_best = vec![0u32; state_space];
    for state in states {
        let start = state.load_start as usize;
        let key = loads[start..start + width]
            .iter()
            .zip(strides)
            .map(|(&load, &stride)| load as usize * stride)
            .sum::<usize>();
        keys.push(key);
        prefix_best[key] = prefix_best[key].max(state.repairs + 1);
    }
    for (&capacity, &stride) in capacities.iter().zip(strides) {
        let radix = capacity as usize + 1;
        let block = stride * radix;
        #[cfg(feature = "parallel")]
        if _parallel && state_space >= PARALLEL_PARETO_WORK && state_space / block > 1 {
            prefix_best.par_chunks_mut(block).for_each(|values| {
                for digit in 1..radix {
                    let start = digit * stride;
                    for offset in 0..stride {
                        let key = start + offset;
                        values[key] = values[key].max(values[key - stride]);
                    }
                }
            });
            continue;
        }
        for base in (0..state_space).step_by(block) {
            for digit in 1..radix {
                let start = base + digit * stride;
                for offset in 0..stride {
                    let key = start + offset;
                    prefix_best[key] = prefix_best[key].max(prefix_best[key - stride]);
                }
            }
        }
    }
    #[cfg(feature = "parallel")]
    if _parallel && states.len().saturating_mul(width) >= PARALLEL_PARETO_WORK {
        return states
            .par_iter()
            .zip(keys.par_iter().copied())
            .map(|(state, key)| dense_state_is_pareto(state, key, loads, strides, &prefix_best))
            .collect();
    }
    states
        .iter()
        .zip(keys)
        .map(|(state, key)| dense_state_is_pareto(state, key, loads, strides, &prefix_best))
        .collect()
}

fn dense_state_is_pareto(
    state: &ScheduleState,
    key: usize,
    loads: &[u32],
    strides: &[usize],
    prefix_best: &[u32],
) -> bool {
    let start = state.load_start as usize;
    let strict_best = strides
        .iter()
        .enumerate()
        .filter(|&(coordinate, _)| loads[start + coordinate] != 0)
        .map(|(_, &stride)| prefix_best[key - stride])
        .max()
        .unwrap_or(0);
    strict_best < state.repairs + 1
}

fn quadratic_pareto_keep(
    states: &[ScheduleState],
    loads: &[u32],
    width: usize,
    _parallel: bool,
) -> Vec<bool> {
    #[cfg(feature = "parallel")]
    if _parallel
        && states
            .len()
            .saturating_mul(states.len())
            .saturating_mul(width)
            >= PARALLEL_PARETO_WORK
    {
        return states
            .par_iter()
            .enumerate()
            .map(|(index, state)| state_is_pareto(states, loads, width, index, state))
            .collect();
    }
    states
        .iter()
        .enumerate()
        .map(|(index, state)| state_is_pareto(states, loads, width, index, state))
        .collect()
}

fn quadratic_pareto_keep_into(
    states: &[ScheduleState],
    loads: &[u32],
    width: usize,
    keep: &mut Vec<u8>,
) {
    keep.clear();
    keep.resize(states.len(), 0);
    for (index, slot) in keep.iter_mut().enumerate() {
        *slot = u8::from(state_is_pareto(states, loads, width, index, &states[index]));
    }
}

fn state_is_pareto(
    states: &[ScheduleState],
    loads: &[u32],
    width: usize,
    index: usize,
    state: &ScheduleState,
) -> bool {
    let state_start = state.load_start as usize;
    !states.iter().enumerate().any(|(other_index, other)| {
        if other_index == index || other.repairs < state.repairs {
            return false;
        }
        let other_start = other.load_start as usize;
        loads[other_start..other_start + width]
            .iter()
            .zip(&loads[state_start..state_start + width])
            .all(|(left, right)| left <= right)
    })
}

fn load_hash_weight(coordinate: usize) -> u64 {
    let mut value = (coordinate as u64).wrapping_add(0x9e37_79b9_7f4a_7c15);
    value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
    value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
    value ^ (value >> 31)
}

fn fingerprint_load(loads: &[u32], start: usize, weights: &[u64]) -> u64 {
    loads[start..start + weights.len()]
        .iter()
        .zip(weights)
        .fold(0_u64, |hash, (&load, &weight)| {
            hash.wrapping_add(u64::from(load).wrapping_mul(weight))
        })
}

fn hash_slice(load: &[u32]) -> u64 {
    let mut hasher = FxHasher::default();
    load.hash(&mut hasher);
    hasher.finish()
}

fn hash_load(loads: &[u32], start: usize, width: usize) -> u64 {
    hash_slice(&loads[start..start + width])
}

fn witness_options(witness: u32, witnesses: &[ScheduleWitnessNode]) -> Vec<(u32, u32)> {
    let mut result = Vec::new();
    collect_witness_options(witness, witnesses, &mut result);
    result
}

fn select_best_witness(
    states: impl IntoIterator<Item = (u32, u32)>,
    witnesses: &[ScheduleWitnessNode],
) -> u32 {
    let mut best_witness = NONE;
    let mut best_repairs = 0;
    for (repairs, witness) in states {
        if repairs > best_repairs
            || repairs == best_repairs
                && compare_witnesses(witness, best_witness, witnesses).is_gt()
        {
            best_witness = witness;
            best_repairs = repairs;
        }
    }
    best_witness
}

fn compare_witnesses(
    mut left: u32,
    mut right: u32,
    witnesses: &[ScheduleWitnessNode],
) -> std::cmp::Ordering {
    let mut ordering = std::cmp::Ordering::Equal;
    while left != NONE && right != NONE {
        let left_node = witnesses[left as usize];
        let right_node = witnesses[right as usize];
        let suffix_ordering =
            (left_node.demand, left_node.option).cmp(&(right_node.demand, right_node.option));
        if suffix_ordering.is_ne() {
            ordering = suffix_ordering;
        }
        left = left_node.parent;
        right = right_node.parent;
    }
    debug_assert_eq!(left, right, "compared witnesses must have equal depth");
    ordering
}

fn compare_graded_witnesses(
    mut left: u32,
    mut right: u32,
    witnesses: &[GradedWitnessNode],
) -> std::cmp::Ordering {
    let mut ordering = std::cmp::Ordering::Equal;
    while left != NONE && right != NONE {
        let left_node = witnesses[left as usize];
        let right_node = witnesses[right as usize];
        let suffix_ordering = left_node.option.cmp(&right_node.option);
        if suffix_ordering.is_ne() {
            ordering = suffix_ordering;
        }
        left = left_node.parent;
        right = right_node.parent;
    }
    debug_assert_eq!(left, right, "compared witnesses must have equal depth");
    ordering
}

fn collect_witness_options(
    witness: u32,
    witnesses: &[ScheduleWitnessNode],
    result: &mut Vec<(u32, u32)>,
) {
    let mut cursor = witness;
    while cursor != NONE {
        let node = witnesses[cursor as usize];
        result.push((node.demand, node.option));
        cursor = node.parent;
    }
    result.reverse();
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CapacityCut {
    pub resources: Box<[u32]>,
    pub forced_demands: Box<[u32]>,
    pub capacity: u64,
    pub repair_upper_bound: u32,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RepairSupportChoice {
    pub demand: u32,
    pub support: Box<[u32]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ParallelRepairResult {
    pub assignment: Box<[RepairSupportChoice]>,
    pub unmatched_demands: Box<[u32]>,
    pub states_examined: u64,
    pub capacity_cut: CapacityCut,
}

pub fn maximum_parallel_repairs(
    repair_sets: &[Vec<Vec<u32>>],
    capacities: &[u32],
) -> Result<ParallelRepairResult, SchedulerError> {
    u32::try_from(repair_sets.len()).map_err(|_| SchedulerError::TooLarge)?;
    let mut families = Vec::with_capacity(repair_sets.len());
    let mut canonical_supports = Vec::with_capacity(repair_sets.len());
    for raw_family in repair_sets {
        let mut supports = Vec::new();
        for raw_support in raw_family {
            let mut support = raw_support.clone();
            support.sort_unstable();
            support.dedup();
            if support
                .iter()
                .any(|&resource| resource as usize >= capacities.len())
            {
                return Err(SchedulerError::UnknownResource);
            }
            if support
                .iter()
                .all(|&resource| capacities[resource as usize] > 0)
            {
                supports.push(support);
            }
        }
        supports.sort_unstable_by_key(|support| (support.len(), support.clone()));
        supports.dedup();
        let mut minimal: Vec<Vec<u32>> = Vec::new();
        for support in supports {
            if !minimal.iter().any(|other| {
                other.len() < support.len()
                    && other
                        .iter()
                        .all(|resource| support.binary_search(resource).is_ok())
            }) {
                minimal.push(support);
            }
        }
        let loads = minimal
            .iter()
            .map(|support| {
                let mut load = vec![0; capacities.len()];
                for &resource in support {
                    load[resource as usize] = 1;
                }
                load
            })
            .collect();
        canonical_supports.push(minimal);
        families.push(loads);
    }

    let weighted = WeightedRepairProblem::from_families(capacities, &families)?.solve()?;
    let assignment = weighted
        .assignment
        .iter()
        .map(|choice| RepairSupportChoice {
            demand: choice.demand,
            support: choice
                .loads
                .iter()
                .enumerate()
                .filter_map(|(resource, &load)| (load != 0).then_some(resource as u32))
                .collect::<Vec<_>>()
                .into_boxed_slice(),
        })
        .collect::<Vec<_>>()
        .into_boxed_slice();
    let capacity_cut = best_capacity_cut(&canonical_supports, capacities);
    debug_assert!(assignment.len() <= capacity_cut.repair_upper_bound as usize);
    Ok(ParallelRepairResult {
        assignment,
        unmatched_demands: weighted.unmatched_demands,
        states_examined: weighted.transitions_examined,
        capacity_cut,
    })
}

fn best_capacity_cut(families: &[Vec<Vec<u32>>], capacities: &[u32]) -> CapacityCut {
    if capacities.len() > 22 {
        return CapacityCut {
            resources: Box::new([]),
            forced_demands: Box::new([]),
            capacity: 0,
            repair_upper_bound: families.len() as u32,
        };
    }
    let mut best = CapacityCut {
        resources: Box::new([]),
        forced_demands: Box::new([]),
        capacity: 0,
        repair_upper_bound: families.len() as u32,
    };
    for mask in 0u64..(1u64 << capacities.len()) {
        let resources: Vec<_> = (0..capacities.len())
            .filter_map(|resource| ((mask >> resource) & 1 != 0).then_some(resource as u32))
            .collect();
        let forced_demands: Vec<_> = families
            .iter()
            .enumerate()
            .filter_map(|(demand, family)| {
                family
                    .iter()
                    .all(|support| support.iter().any(|&resource| mask >> resource & 1 != 0))
                    .then_some(demand as u32)
            })
            .collect();
        let capacity = resources
            .iter()
            .map(|&resource| u64::from(capacities[resource as usize]))
            .sum();
        let upper = (families.len() as u64)
            .min(families.len() as u64 - forced_demands.len() as u64 + capacity)
            as u32;
        if upper < best.repair_upper_bound {
            best = CapacityCut {
                resources: resources.into_boxed_slice(),
                forced_demands: forced_demands.into_boxed_slice(),
                capacity,
                repair_upper_bound: upper,
            };
        }
    }
    best
}

#[cfg(test)]
mod tests {
    use super::*;
    use proptest::prelude::*;

    #[test]
    fn weighted_loads_distinguish_supports() {
        let problem = WeightedRepairProblem::from_families(
            &[2, 1],
            &[
                vec![vec![2, 0], vec![1, 1]],
                vec![vec![1, 0]],
                vec![vec![0, 1]],
            ],
        )
        .unwrap();
        let answer = problem.solve().unwrap();
        assert_eq!(answer.repaired_count(), 2);
        assert!(answer.total_loads.iter().zip([2, 1]).all(|(x, y)| *x <= y));
    }

    #[test]
    fn iterator_constructor_streams_to_the_canonical_antichain() {
        let families = [
            [[2, 2], [1, 2], [1, 1], [0, 2], [0, 2], [3, 0]],
            [[2, 0], [1, 1], [0, 2], [2, 0], [2, 2], [3, 3]],
        ];
        let problem = WeightedRepairProblem::from_family_iterators(
            &[2, 2],
            families.into_iter().map(IntoIterator::into_iter),
        )
        .unwrap();
        assert_eq!(problem.families.len(), 2);
        assert_eq!(problem.families[0].option_len, 2);
        assert_eq!(problem.families[1].option_len, 3);
        let problem_ref = &problem;
        let stored = (0..problem.option_count)
            .flat_map(|option| {
                (0..2).map(move |coordinate| problem_ref.option_load_coordinate(option, coordinate))
            })
            .collect::<Vec<_>>();
        assert_eq!(stored, [0, 2, 1, 1, 0, 2, 1, 1, 2, 0]);
        assert_eq!(problem.solve_adaptive().unwrap().repaired_count(), 2);
    }

    #[test]
    fn unit_scheduler_returns_cut() {
        let answer =
            maximum_parallel_repairs(&[vec![vec![0]], vec![vec![0]], vec![vec![1]]], &[1, 1])
                .unwrap();
        assert_eq!(answer.assignment.len(), 2);
        assert_eq!(answer.capacity_cut.repair_upper_bound, 2);
    }

    #[test]
    fn uniform_positive_load_mass_certifies_antichain_frontier() {
        let problem = WeightedRepairProblem::from_families(
            &[2, 2],
            &[vec![vec![1, 0], vec![0, 1]], vec![vec![1, 0], vec![0, 1]]],
        )
        .unwrap();
        assert_eq!(problem.positive_grading().unwrap().option_mass, 1);
        assert_eq!(problem.solve_adaptive().unwrap().repaired_count(), 2);
    }

    #[test]
    fn caller_supplied_positive_grading_certifies_nonuniform_loads() {
        let families = [
            vec![vec![2, 0], vec![0, 1]],
            vec![vec![2, 0], vec![0, 1]],
            vec![vec![2, 0], vec![0, 1]],
        ];
        let ungraded = WeightedRepairProblem::from_families(&[4, 4], &families).unwrap();
        assert!(ungraded.positive_grading().is_none());
        let graded =
            WeightedRepairProblem::from_families_with_positive_grading(&[4, 4], &families, &[1, 2])
                .unwrap();
        assert_eq!(graded.positive_grading().unwrap().option_mass, 2);
        assert_eq!(
            graded.solve().unwrap().assignment,
            ungraded.solve().unwrap().assignment
        );
        assert_eq!(
            graded.solve_dense_lattice().unwrap().assignment,
            ungraded.solve().unwrap().assignment
        );
        assert!(matches!(
            WeightedRepairProblem::from_families_with_positive_grading(&[4, 4], &families, &[1, 1],),
            Err(SchedulerError::InvalidGrading)
        ));
        assert!(matches!(
            WeightedRepairProblem::from_families_with_positive_grading(&[4, 4], &families, &[1, 0]),
            Err(SchedulerError::InvalidGrading)
        ));
        assert!(matches!(
            WeightedRepairProblem::from_families_with_positive_grading(&[4, 4], &families, &[1]),
            Err(SchedulerError::InvalidGrading)
        ));
        assert!(matches!(
            WeightedRepairProblem::from_families_with_positive_grading(
                &[4, 4],
                &[vec![vec![0, 0]]],
                &[1, 2],
            ),
            Err(SchedulerError::InvalidGrading)
        ));
    }

    #[test]
    fn graded_shell_layout_counts_bounded_compositions_exactly() {
        let families = [vec![vec![1, 0], vec![0, 1]], vec![vec![1, 0], vec![0, 1]]];
        let problem = WeightedRepairProblem::from_families(&[2, 2], &families).unwrap();
        let shell = problem.graded_shell.as_ref().unwrap();
        assert_eq!(shell.depth_offsets.as_ref(), &[0, 1, 3]);
        assert_eq!(shell.state_space, 6);
        assert_eq!(problem.graded_shell_state_space(), Some(6));
        assert_eq!(problem.dense_state_space(), Some(9));
        let mut workspace = WeightedRepairWorkspace::new();
        assert_eq!(
            problem
                .solve_graded_shell_with_workspace(&mut workspace)
                .unwrap(),
            problem.solve_dense_lattice().unwrap()
        );
    }

    #[test]
    fn graded_shell_ranks_are_contiguous_and_injective() {
        let families = (0..3)
            .map(|_| vec![vec![1, 0], vec![0, 2]])
            .collect::<Vec<_>>();
        let problem =
            WeightedRepairProblem::from_families_with_positive_grading(&[2, 3], &families, &[2, 1])
                .unwrap();
        let shell = problem.graded_shell.as_ref().unwrap();
        let grading = problem.positive_grading.as_ref().unwrap();
        let shifts = [0, 3];
        let mut ranks = Vec::new();
        for repairs in 0..=problem.graded_repair_upper_bound().unwrap() {
            for first in 0..=2u64 {
                for second in 0..=3u64 {
                    if 2 * first + second != repairs as u64 * grading.option_mass {
                        continue;
                    }
                    let packed = first | second << shifts[1];
                    ranks.push(
                        shell
                            .rank_packed(packed, &shifts, &problem.capacities, grading, repairs)
                            .unwrap(),
                    );
                }
            }
        }
        ranks.sort_unstable();
        assert_eq!(ranks, (0..shell.state_space).collect::<Vec<_>>());
    }

    #[test]
    fn graded_shell_extends_dense_solver_beyond_full_box_limit() {
        let families = (0..4)
            .map(|_| vec![vec![1, 0], vec![0, 1]])
            .collect::<Vec<_>>();
        let problem = WeightedRepairProblem::from_families(&[4_096, 4_096], &families).unwrap();
        assert_eq!(problem.dense_state_space(), None);
        assert_eq!(problem.graded_shell.as_ref().unwrap().state_space, 15);
        assert_eq!(
            problem.recommended_backend(),
            WeightedSchedulerBackend::DenseLattice
        );
        assert_eq!(
            problem.solve_dense_lattice().unwrap(),
            problem.solve().unwrap()
        );
        assert_eq!(problem.solve_adaptive().unwrap(), problem.solve().unwrap());
    }

    #[test]
    fn nonuniform_graded_shell_preserves_exact_witness() {
        let families = (0..5)
            .map(|_| vec![vec![2, 0], vec![0, 1]])
            .collect::<Vec<_>>();
        let problem = WeightedRepairProblem::from_families_with_positive_grading(
            &[4_096, 4_096],
            &families,
            &[1, 2],
        )
        .unwrap();
        assert_eq!(problem.dense_state_space(), None);
        assert_eq!(
            problem.solve_dense_lattice().unwrap(),
            problem.solve().unwrap()
        );
    }

    #[test]
    fn graded_dense_witness_code_overflow_uses_exact_fallback() {
        let families = (0..70).map(|_| vec![vec![1]]).collect::<Vec<_>>();
        let problem = WeightedRepairProblem::from_families(&[70], &families).unwrap();
        let sparse = problem.solve().unwrap();
        let dense = problem.solve_dense_lattice().unwrap();
        assert_eq!(dense.assignment, sparse.assignment);
        assert_eq!(dense.total_loads, sparse.total_loads);
        assert_eq!(dense.repaired_count(), 70);
    }

    #[test]
    fn graded_dense_repair_depth_overflow_uses_generic_kernel() {
        let families = (0..256).map(|_| vec![vec![1]]).collect::<Vec<_>>();
        let problem = WeightedRepairProblem::from_families(&[256], &families).unwrap();
        let sparse = problem.solve().unwrap();
        let dense = problem.solve_dense_lattice().unwrap();
        assert_eq!(dense.assignment, sparse.assignment);
        assert_eq!(dense.total_loads, sparse.total_loads);
        assert_eq!(dense.repaired_count(), 256);
    }

    #[test]
    fn workspace_reuse_preserves_exact_results_across_problems() {
        let first = WeightedRepairProblem::from_families(
            &[3, 3],
            &[
                vec![vec![1, 0], vec![0, 1]],
                vec![vec![1, 0], vec![0, 1]],
                vec![vec![1, 0], vec![0, 1]],
                vec![vec![1, 0], vec![0, 1]],
            ],
        )
        .unwrap();
        let second = WeightedRepairProblem::from_families(
            &[2, 2, 2],
            &[
                vec![vec![1, 0, 0], vec![0, 1, 0]],
                vec![vec![0, 0, 1], vec![1, 0, 0]],
                vec![vec![0, 1, 0], vec![0, 0, 1]],
            ],
        )
        .unwrap();
        let mut workspace = WeightedRepairWorkspace::new();
        for problem in [&first, &first, &second, &first] {
            assert_eq!(
                problem
                    .solve_dense_lattice_with_workspace(&mut workspace)
                    .unwrap(),
                problem.solve_dense_lattice().unwrap()
            );
        }
    }

    #[test]
    fn warm_sparse_workspace_allocates_nothing_in_solve_layers() {
        let families = (0..6)
            .map(|_| vec![vec![2, 0], vec![0, 1], vec![1, 2]])
            .collect::<Vec<_>>();
        let problem = WeightedRepairProblem::from_families(&[6, 6], &families).unwrap();
        assert!(problem.positive_grading().is_none());
        let mut workspace = WeightedRepairWorkspace::new();
        let expected = problem.solve_sparse_with_workspace(&mut workspace).unwrap();
        let (answer, events) = crate::test_alloc::measure_allocations(|| {
            problem.solve_sparse_with_workspace(&mut workspace).unwrap()
        });
        assert_eq!(answer, expected);
        assert_eq!(events, Default::default());
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn warm_parallel_sparse_workspace_allocates_nothing_in_solve_layers() {
        let families = (0..8)
            .map(|demand| {
                (0..6)
                    .map(|resource| {
                        let mut loads = vec![0_u32; 6];
                        loads[resource] = 1 + u32::from((demand + resource) % 3 == 0);
                        loads
                    })
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>();
        let problem = WeightedRepairProblem::from_families(&[5; 6], &families).unwrap();
        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(3)
            .build()
            .unwrap();
        let mut workspace = WeightedRepairWorkspace::new();
        let expected = pool.install(|| {
            problem
                .solve_sparse_parallel_with_workspace(&mut workspace)
                .unwrap()
        });
        let (answer, events) = crate::test_alloc::measure_allocations(|| {
            let measurement = crate::test_alloc::current_measurement();
            pool.install(|| {
                measurement.scope(|| {
                    problem
                        .solve_sparse_parallel_with_workspace(&mut workspace)
                        .unwrap()
                })
            })
        });
        assert_eq!(answer, expected);
        assert_eq!(events, Default::default());
    }

    #[test]
    fn integer_ceil_sqrt_handles_square_boundaries() {
        assert_eq!(ceil_sqrt(0), 0);
        assert_eq!(ceil_sqrt(1), 1);
        assert_eq!(ceil_sqrt(15), 4);
        assert_eq!(ceil_sqrt(16), 4);
        assert_eq!(ceil_sqrt(17), 5);
    }

    #[test]
    fn additive_load_fingerprint_matches_materialized_transition() {
        let left = [3_u32, 1, 4, 1, 5, 9, 2, 6];
        let right = [5_u32, 3, 5, 8, 9, 7, 9, 3];
        let sum = std::array::from_fn::<_, 8, _>(|index| left[index] + right[index]);
        let weights = (0..left.len()).map(load_hash_weight).collect::<Vec<_>>();
        assert_eq!(
            fingerprint_load(&sum, 0, &weights),
            fingerprint_load(&left, 0, &weights)
                .wrapping_add(fingerprint_load(&right, 0, &weights))
        );
    }

    /// The counted-type reduction must never change an answer: whenever it
    /// certifies, its optimum equals the general backend's and its assignment is
    /// feasible and drawn from each demand's own options.
    #[test]
    fn counted_type_reduction_agrees_with_the_general_backends() {
        let templates: [&[&[u32]]; 4] = [
            &[&[1, 0], &[0, 2], &[2, 1]],
            &[&[2, 0], &[0, 1], &[1, 1]],
            &[&[0, 3], &[3, 0], &[1, 2]],
            &[&[3, 1], &[1, 0], &[0, 2]],
        ];
        let mut certified = 0;
        for kinds in 1..=4usize {
            for copies in [1usize, 3, 7, 40, 200] {
                for &capacity in &[4u32, 17, 60] {
                    let families: Vec<Vec<Vec<u32>>> = (0..kinds * copies)
                        .map(|demand| {
                            templates[demand % kinds]
                                .iter()
                                .map(|load| load.to_vec())
                                .collect()
                        })
                        .collect();
                    let problem =
                        WeightedRepairProblem::from_families(&[capacity, capacity], &families)
                            .unwrap();
                    let reference = problem.solve_dense_lattice().unwrap();
                    let Some(counted) = problem.solve_counted_types().unwrap() else {
                        continue;
                    };
                    certified += 1;
                    assert_eq!(
                        counted.repaired_count(),
                        reference.repaired_count(),
                        "counted optimum differs at kinds={kinds} copies={copies} capacity={capacity}"
                    );
                    let mut totals = vec![0u64; 2];
                    let mut seen = std::collections::BTreeSet::new();
                    for choice in counted.assignment.iter() {
                        assert!(seen.insert(choice.demand), "a demand was repaired twice");
                        assert!(
                            families[choice.demand as usize]
                                .iter()
                                .any(|option| option[..] == choice.loads[..]),
                            "a choice is not an option of its demand"
                        );
                        for (total, &load) in totals.iter_mut().zip(choice.loads.iter()) {
                            *total += u64::from(load);
                        }
                    }
                    for &total in &totals {
                        assert!(
                            total <= u64::from(capacity),
                            "counted witness exceeds capacity"
                        );
                    }
                    assert_eq!(
                        counted.assignment.len() + counted.unmatched_demands.len(),
                        families.len(),
                        "counted result does not account for every demand"
                    );
                    assert_eq!(totals, counted.total_loads.to_vec());
                }
            }
        }
        assert!(
            certified > 0,
            "the counted reduction never certified on this corpus"
        );
    }

    /// The counted-type dynamic-programming scan must allocate nothing once its
    /// workspace is warm.
    #[test]
    fn warm_counted_type_workspace_allocates_nothing_in_the_scan() {
        let families = (0..64)
            .map(|demand| match demand % 3 {
                0 => vec![vec![1, 0], vec![0, 2]],
                1 => vec![vec![2, 0], vec![1, 1]],
                _ => vec![vec![0, 3], vec![1, 2]],
            })
            .collect::<Vec<_>>();
        let problem = WeightedRepairProblem::from_families(&[12, 12], &families).unwrap();
        let mut workspace = WeightedRepairWorkspace::new();
        let expected = problem
            .solve_counted_types_with_workspace(&mut workspace)
            .unwrap()
            .expect("the counted reduction certifies on this instance");
        // Re-enter the real scan many times after warm-up: a single measured
        // call could hide an allocation that only recurs on a later entry, and
        // a warm workspace must stay warm across repeated solves.
        let (repairs, events) = crate::test_alloc::measure_allocations(|| {
            let mut repairs = 0;
            for _ in 0..64 {
                let answer = problem
                    .solve_counted_types_with_workspace(&mut workspace)
                    .unwrap()
                    .expect("the counted reduction certifies on this instance");
                repairs = answer.repaired_count();
            }
            repairs
        });
        assert_eq!(repairs, expected.repaired_count());
        assert_eq!(events, Default::default());

        // The same workspace must also stay allocation-free when it is reused
        // across a different problem of the same shape.
        let other = WeightedRepairProblem::from_families(&[12, 12], &families[..32]).unwrap();
        let (_, events) = crate::test_alloc::measure_allocations(|| {
            for _ in 0..16 {
                let _ = other
                    .solve_counted_types_with_workspace(&mut workspace)
                    .unwrap();
            }
        });
        assert_eq!(events, Default::default());
    }

    /// Instances whose families are mostly distinct must keep the general
    /// backends, so their recorded work counts are unaffected.
    #[test]
    fn counted_type_reduction_declines_instances_without_repetition() {
        let families: Vec<Vec<Vec<u32>>> = (0..12u32)
            .map(|demand| {
                vec![
                    vec![demand % 5 + 1, demand % 3],
                    vec![demand % 2, demand % 7 + 1],
                ]
            })
            .collect();
        let problem = WeightedRepairProblem::from_families(&[9, 9], &families).unwrap();
        assert!(problem.solve_counted_types().unwrap().is_none());
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn parallel_sparse_solver_matches_the_canonical_result() {
        let families = (0..10)
            .map(|demand| {
                (0..6)
                    .map(|resource| {
                        let mut loads = vec![0u32; 6];
                        loads[resource] = 1 + u32::from((demand + resource) % 3 == 0);
                        loads
                    })
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>();
        let problem = WeightedRepairProblem::from_families(&[5; 6], &families).unwrap();
        let sequential = problem.solve().unwrap();
        let adaptive = problem.solve_adaptive().unwrap();
        assert_eq!(
            problem.recommended_backend(),
            WeightedSchedulerBackend::DenseLattice
        );
        for threads in [1, 2, 12] {
            let pool = rayon::ThreadPoolBuilder::new()
                .num_threads(threads)
                .build()
                .unwrap();
            let mut workspace = WeightedRepairWorkspace::new();
            assert_eq!(
                pool.install(|| problem.solve_parallel().unwrap()),
                sequential
            );
            assert_eq!(
                pool.install(|| problem.solve_adaptive_parallel().unwrap()),
                adaptive
            );
            assert_eq!(
                pool.install(|| {
                    problem
                        .solve_adaptive_parallel_with_workspace(&mut workspace)
                        .unwrap()
                }),
                adaptive
            );
        }
    }

    proptest! {
        #[test]
        fn weighted_repaired_count_matches_brute_force(
            capacities in prop::array::uniform3(0u32..4),
            raw in prop::collection::vec(prop::array::uniform3(0u32..4), 8..=8),
        ) {
            let families: Vec<Vec<Vec<u32>>> = raw
                .chunks_exact(2)
                .map(|family| family.iter().map(|loads| loads.to_vec()).collect())
                .collect();
            let problem = WeightedRepairProblem::from_families(&capacities, &families).unwrap();
            let canonical = problem.solve_impl::<false, false, false>(false).unwrap();
            let answer = problem.solve().unwrap();
            let dense = WeightedRepairProblem::from_families(&capacities, &families)
                .unwrap()
                .solve_dense_lattice()
                .unwrap();
            let adaptive = WeightedRepairProblem::from_families(&capacities, &families)
                .unwrap()
                .solve_adaptive()
                .unwrap();
            let mixed = WeightedRepairProblem::from_families(&capacities, &families)
                .unwrap()
                .solve_mixed_radix()
                .unwrap();
            let mut brute = 0usize;
            for mut code in 0usize..3usize.pow(4) {
                let mut used = [0u32; 3];
                let mut count = 0usize;
                let mut feasible = true;
                for family in &families {
                    let choice = code % 3;
                    code /= 3;
                    if choice == 0 {
                        continue;
                    }
                    count += 1;
                    for coordinate in 0..3 {
                        used[coordinate] += family[choice - 1][coordinate];
                        feasible &= used[coordinate] <= capacities[coordinate];
                    }
                }
                if feasible {
                    brute = brute.max(count);
                }
            }
            prop_assert_eq!(answer.repaired_count(), brute);
            prop_assert_eq!(&answer, &canonical);
            prop_assert_eq!(dense.repaired_count(), brute);
            prop_assert_eq!(&dense.assignment, &answer.assignment);
            prop_assert_eq!(&adaptive.assignment, &answer.assignment);
            prop_assert_eq!(mixed.repaired_count(), brute);
            prop_assert_eq!(&mixed.assignment, &answer.assignment);
            prop_assert!(answer
                .total_loads
                .iter()
                .zip(capacities)
                .all(|(load, capacity)| *load <= u64::from(capacity)));
        }
    }
}
