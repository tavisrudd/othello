use std::hash::{Hash, Hasher};

use rustc_hash::{FxHashMap, FxHasher};
use thiserror::Error;

const NONE: u32 = u32::MAX;
const MAX_DENSE_LATTICE_STATES: usize = 1 << 24;
const MAX_GRADED_SHELL_TABLE_CELLS: usize = 1 << 22;
const DENSE_DOMINANCE_WORK_MARGIN: usize = 4;
const DENSE_REACHABLE_BOUND_MARGIN: usize = 4;
const DENSE_ANTICHAIN_OCCUPANCY_DENOMINATOR: usize = 128;
const DENSE_GRADED_NARROW_OCCUPANCY_DENOMINATOR: usize = 4096;

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
    _reserved: [u32; 2],
}

const _: () = assert!(std::mem::size_of::<FamilyRecord>() == 16);
const _: () = assert!(std::mem::align_of::<FamilyRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct OptionRecord {
    load_start: u32,
    _reserved: [u32; 3],
}

const _: () = assert!(std::mem::size_of::<OptionRecord>() == 16);
const _: () = assert!(std::mem::align_of::<OptionRecord>() == 4);

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
        self.repaired.shrink_to_fit();
        self.total_loads.shrink_to_fit();
    }
}

#[derive(Clone, Debug)]
pub struct WeightedRepairProblem {
    capacities: Box<[u32]>,
    families: Box<[FamilyRecord]>,
    options: Box<[OptionRecord]>,
    option_loads: Box<[u32]>,
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
        Self::from_families_impl(capacities, raw_families, None)
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
        Self::from_families_impl(capacities, raw_families, Some(weights))
    }

    fn from_families_impl(
        capacities: &[u32],
        raw_families: &[Vec<Vec<u32>>],
        grading_weights: Option<&[u32]>,
    ) -> Result<Self, SchedulerError> {
        u32::try_from(raw_families.len()).map_err(|_| SchedulerError::TooLarge)?;
        let width = capacities.len();
        let mut families = Vec::with_capacity(raw_families.len());
        let mut options = Vec::new();
        let mut option_loads = Vec::new();
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
            let minimal: Vec<_> = canonical
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
                .collect();
            let option_start =
                u32::try_from(options.len()).map_err(|_| SchedulerError::TooLarge)?;
            for loads in &minimal {
                let load_start =
                    u32::try_from(option_loads.len()).map_err(|_| SchedulerError::TooLarge)?;
                option_loads.extend_from_slice(loads);
                options.push(OptionRecord {
                    load_start,
                    _reserved: [0; 3],
                });
            }
            families.push(FamilyRecord {
                option_start,
                option_len: u32::try_from(minimal.len()).map_err(|_| SchedulerError::TooLarge)?,
                _reserved: [0; 2],
            });
        }
        let mut problem = Self {
            capacities: capacities.into(),
            families: families.into_boxed_slice(),
            options: options.into_boxed_slice(),
            option_loads: option_loads.into_boxed_slice(),
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

    fn option_load(&self, option: u32) -> &[u32] {
        let start = self.options[option as usize].load_start as usize;
        &self.option_loads[start..start + self.capacities.len()]
    }

    fn solve_impl<const DENSE: bool, const PACKED: bool, const WIDE: bool>(
        &self,
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
            self.options
                .iter()
                .enumerate()
                .map(|(option, _)| {
                    self.option_load(option as u32)
                        .iter()
                        .zip(&dense_strides)
                        .map(|(&load, &stride)| load as usize * stride)
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
                        let candidate_load = self.option_load(option);
                        for coordinate in 0..width {
                            let Some(sum) = loads[used_start + coordinate]
                                .checked_add(candidate_load[coordinate])
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
                        demand: u32::try_from(demand).map_err(|_| SchedulerError::TooLarge)?,
                        option,
                        repairs,
                    });
                    if incumbent != NONE {
                        let record = &mut updated[incumbent as usize];
                        record.witness = witness;
                        record.repairs = repairs;
                    } else {
                        if candidate_packed.is_some() && store_loads {
                            let candidate_load = self.option_load(option);
                            for coordinate in 0..width {
                                scratch[coordinate] =
                                    loads[used_start + coordinate] + candidate_load[coordinate];
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
                    )
                } else {
                    let mut keep = vec![true; updated.len()];
                    for (index, state) in updated.iter().enumerate() {
                        let state_start = state.load_start as usize;
                        keep[index] = !updated.iter().enumerate().any(|(other_index, other)| {
                            if other_index == index || other.repairs < state.repairs {
                                return false;
                            }
                            let other_start = other.load_start as usize;
                            loads[other_start..other_start + width]
                                .iter()
                                .zip(&loads[state_start..state_start + width])
                                .all(|(left, right)| left <= right)
                        });
                    }
                    keep
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
                loads: self.option_load(option).into(),
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

    pub fn solve(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        self.solve_impl::<false, false, false>()
    }

    pub fn solve_adaptive(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        match self.recommended_backend() {
            WeightedSchedulerBackend::SparsePareto => self.solve(),
            WeightedSchedulerBackend::DenseLattice => self.solve_dense_lattice(),
        }
    }

    /// Solves adaptively while retaining narrow dense-kernel allocations.
    pub fn solve_adaptive_with_workspace(
        &self,
        workspace: &mut WeightedRepairWorkspace,
    ) -> Result<WeightedParallelRepairResult, SchedulerError> {
        match self.recommended_backend() {
            WeightedSchedulerBackend::SparsePareto => self.solve(),
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
        self.options.first()?;
        let expected = self
            .option_load(0)
            .iter()
            .zip(weights)
            .try_fold(0u64, |sum, (&load, &weight)| {
                sum.checked_add(u64::from(load) * u64::from(weight))
            })?;
        if expected == 0 {
            return None;
        }
        self.options
            .iter()
            .enumerate()
            .all(|(option, _)| {
                self.option_load(option as u32)
                    .iter()
                    .zip(weights)
                    .try_fold(0u64, |sum, (&load, &weight)| {
                        sum.checked_add(u64::from(load) * u64::from(weight))
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
        if option_deltas.capacity() < self.options.len() {
            option_deltas.reserve_exact(self.options.len());
        }
        for option in 0..self.options.len() {
            option_deltas.push(
                self.option_load(option as u32)
                    .iter()
                    .zip(strides.iter())
                    .map(|(&load, &stride)| load as usize * stride)
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
        if option_packed.capacity() < self.options.len() {
            option_packed.reserve_exact(self.options.len());
        }
        for option in 0..self.options.len() {
            option_packed.push(
                self.option_load(option as u32)
                    .iter()
                    .zip(packed_shifts.iter())
                    .map(|(&load, &shift)| u64::from(load) << shift)
                    .sum(),
            );
        }
        let lex_base =
            u64::try_from(self.options.len() + 1).map_err(|_| SchedulerError::TooLarge)?;
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
                loads: self.option_load(option).into(),
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
                self.solve_impl::<true, true, false>()
            }
        } else {
            self.solve_impl::<true, true, true>()
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
        self.solve_impl::<true, false, false>()
    }

    #[doc(hidden)]
    pub fn solve_dense_lattice_wide(&self) -> Result<WeightedParallelRepairResult, SchedulerError> {
        self.solve_impl::<true, true, true>()
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
        let mut option_deltas = Vec::with_capacity(self.options.len());
        for option in 0..self.options.len() {
            let delta = self
                .option_load(option as u32)
                .iter()
                .zip(&strides)
                .try_fold(0u64, |sum, (&load, &stride)| {
                    sum.checked_add(u64::from(load) * stride)
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
                    let option_load = self.option_load(option);
                    let feasible = option_load.iter().enumerate().all(|(coordinate, &load)| {
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
                loads: self.option_load(option).into(),
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
    let option_packed = problem
        .options
        .iter()
        .enumerate()
        .map(|(option, _)| {
            problem
                .option_load(option as u32)
                .iter()
                .zip(&shifts)
                .map(|(&load, &shift)| u128::from(load) << shift)
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
    states
        .iter()
        .zip(keys)
        .map(|(state, key)| {
            let start = state.load_start as usize;
            let strict_best = strides
                .iter()
                .enumerate()
                .filter(|&(coordinate, _)| loads[start + coordinate] != 0)
                .map(|(_, &stride)| prefix_best[key - stride])
                .max()
                .unwrap_or(0);
            strict_best < state.repairs + 1
        })
        .collect()
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
    fn integer_ceil_sqrt_handles_square_boundaries() {
        assert_eq!(ceil_sqrt(0), 0);
        assert_eq!(ceil_sqrt(1), 1);
        assert_eq!(ceil_sqrt(15), 4);
        assert_eq!(ceil_sqrt(16), 4);
        assert_eq!(ceil_sqrt(17), 5);
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
            let answer = WeightedRepairProblem::from_families(&capacities, &families)
                .unwrap()
                .solve()
                .unwrap();
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
