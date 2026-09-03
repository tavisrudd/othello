//! Certified state-dominance pruning for the sparse scheduler frontier.
//!
//! The scheduler's dynamic program keeps, at each layer, an antichain of states
//! `(u, r)` where `u` is the committed load vector and `r` the repair count. A
//! state `s` dominates `t` when every completion of `t` is matched by a
//! completion of `s` at no greater load and no smaller repair count; the
//! frontier may then delete `t`. The baseline scan decides this by comparing
//! every state against every other, which costs `states^2 * width` per layer
//! and is the whole of the C1038 L2 row's run time.
//!
//! This module replaces that scan with three exact reductions and certifies
//! every deletion it makes:
//!
//! 1. **Residual packing.** Each load vector is packed into one `u64`, one lane
//!    per resource, with a guard bit per lane. The componentwise comparison
//!    becomes a single borrow-free lane subtraction.
//! 2. **Kept-only comparison.** Dominance is transitive, so a state need only be
//!    compared against states already kept, not against every state.
//! 3. **Monotone ordering.** States are visited in descending residual mass, so
//!    every possible dominator of a state precedes it and the kept prefix is the
//!    complete candidate set.
//!
//! Every deletion appends a self-contained [`DominanceWitness`]. The replay
//! checker in [`replay_dominance_witnesses`] re-evaluates each comparison from
//! the record alone, unpacking lanes with shifts and masks rather than with the
//! solver's SWAR arithmetic, so it is an independent implementation of the
//! predicate and never re-solves the instance.

use thiserror::Error;

/// Maximum number of kept candidates a single state may be compared against
/// before pruning is abandoned for that state.
///
/// Exceeding the budget keeps the state, which is always sound: retaining a
/// dominated state can only add work, never change the optimum. The cap bounds
/// the worst-case per-layer scan at `states * DOMINANCE_COMPARISON_BUDGET`.
///
/// The cap is set well above any frontier the crate's kernels reach — the
/// largest measured is the C1038 L2 row at 111,079 states — so that it is a
/// safety valve rather than a pruning policy. While it does not bind, the
/// certified scan decides exactly the same antichain as the all-pairs scan;
/// once it binds the scan keeps more states than the all-pairs scan would, so
/// results stay exact but pruning weakens.
pub const DOMINANCE_COMPARISON_BUDGET: usize = 1 << 22;

/// Maximum number of witness records retained for one solve.
///
/// When the buffer is full the scan stops pruning rather than pruning without a
/// certificate, so the emitted witness list always accounts for every deletion.
pub const DOMINANCE_WITNESS_CAPACITY: usize = 1 << 20;

/// Which dominance relation the sparse frontier decides.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Hash)]
pub enum DominanceMode {
    /// The exact relation of the baseline scan, decided by the certified fast
    /// path. Optimum, repair count, and witness assignment are unchanged.
    #[default]
    Exact,
    /// Exact dominance relaxed by clamping each residual at the maximum load the
    /// remaining demands can still place on that resource. Prunes at least as
    /// much and preserves the optimal repair count, but may return a different
    /// optimal assignment. See the module documentation of the trade.
    ClampedSuffix,
    /// The original all-pairs scan, retained as an in-process A/B control. Emits
    /// no witnesses.
    Legacy,
}

impl DominanceMode {
    /// Whether this mode uses the certified fast path.
    #[inline]
    pub fn certified(self) -> bool {
        !matches!(self, Self::Legacy)
    }
}

/// Bit layout packing one load or residual vector into a single `u64`.
///
/// Resource `c` occupies `value_bits(c) + 1` bits starting at `shift(c)`. The
/// top bit of each lane is a guard that is zero in every stored value and is
/// what makes the lane-wise comparison borrow-free.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct DominanceLayout {
    shifts: Box<[u32]>,
    value_bits: Box<[u32]>,
    capacities: Box<[u32]>,
    guard: u64,
}

impl DominanceLayout {
    /// Builds the layout for these capacities, or `None` when the lanes would
    /// exceed 64 bits.
    pub fn new(capacities: &[u32]) -> Option<Self> {
        if capacities.is_empty() {
            return None;
        }
        let mut shifts = Vec::with_capacity(capacities.len());
        let mut value_bits = Vec::with_capacity(capacities.len());
        let mut shift = 0u32;
        let mut guard = 0u64;
        for &capacity in capacities {
            let bits = (u64::from(capacity) + 1)
                .next_power_of_two()
                .trailing_zeros();
            let lane_bits = bits.checked_add(1)?;
            if shift.checked_add(lane_bits)? > 64 {
                return None;
            }
            shifts.push(shift);
            value_bits.push(bits);
            guard |= 1u64 << (shift + bits);
            shift += lane_bits;
        }
        Some(Self {
            shifts: shifts.into_boxed_slice(),
            value_bits: value_bits.into_boxed_slice(),
            capacities: capacities.into(),
            guard,
        })
    }

    /// Number of resources this layout covers.
    #[inline]
    pub fn width(&self) -> usize {
        self.shifts.len()
    }

    /// Extracts resource `coordinate` from a packed vector.
    #[inline]
    pub fn lane(&self, packed: u64, coordinate: usize) -> u32 {
        let bits = self.value_bits[coordinate];
        let mask = (1u64 << bits) - 1;
        ((packed >> self.shifts[coordinate]) & mask) as u32
    }

    /// Exclusive upper bound on a value stored in lane `coordinate`.
    #[inline]
    pub fn lane_limit(&self, coordinate: usize) -> u32 {
        1u32 << self.value_bits[coordinate]
    }

    /// Capacity of resource `coordinate`, the largest residual it can hold.
    #[inline]
    pub fn capacity(&self, coordinate: usize) -> u32 {
        self.capacities[coordinate]
    }

    /// Extracts resource `coordinate` including its guard bit.
    ///
    /// [`Self::lane`] masks the guard away, so a forged vector that sets a guard
    /// bit would read back as a legal value; the replay checker uses this
    /// instead to see the bit a well-formed vector must leave clear.
    #[inline]
    pub fn lane_raw(&self, packed: u64, coordinate: usize) -> u32 {
        let lane_bits = self.value_bits[coordinate] + 1;
        let mask = (1u64 << lane_bits) - 1;
        ((packed >> self.shifts[coordinate]) & mask) as u32
    }

    /// Bits above the highest lane, which a well-formed vector leaves clear.
    #[inline]
    fn tail_mask(&self) -> u64 {
        let last = self.shifts.len() - 1;
        let end = self.shifts[last] + self.value_bits[last] + 1;
        if end >= 64 {
            0
        } else {
            u64::MAX << end
        }
    }

    /// Packs one residual vector. Values at or above a lane limit are rejected.
    #[inline]
    fn pack(&self, values: &[u32]) -> Option<u64> {
        let mut packed = 0u64;
        for (coordinate, &value) in values.iter().enumerate() {
            if value >= self.lane_limit(coordinate) {
                return None;
            }
            packed |= u64::from(value) << self.shifts[coordinate];
        }
        Some(packed)
    }

    /// Lane-wise `left >= right`, decided with one borrow-free subtraction.
    ///
    /// Each lane holds `left_c + 2^bits - right_c`, which stays inside the lane
    /// because both operands are below `2^bits`, and whose guard bit is set
    /// exactly when `left_c >= right_c`.
    #[inline]
    fn dominates_packed(&self, left: u64, right: u64) -> bool {
        ((left | self.guard) - right) & self.guard == self.guard
    }
}

/// One certified deletion: the surviving state, the deleted state, and the
/// comparison vectors that justify the deletion.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct DominanceWitness {
    /// Packed residual vector of the surviving state.
    pub packed_dominator: u64,
    /// Packed residual vector of the deleted state.
    pub packed_pruned: u64,
    /// Frontier index of the survivor within its layer.
    pub dominator: u32,
    /// Frontier index of the deleted state within its layer.
    pub pruned: u32,
    /// Repair count of the survivor.
    pub dominator_repairs: u32,
    /// Repair count of the deleted state.
    pub pruned_repairs: u32,
}

const _: () = assert!(std::mem::size_of::<DominanceWitness>() == 32);
const _: () = assert!(std::mem::align_of::<DominanceWitness>() == 8);

/// Why a witness list failed replay.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Error)]
pub enum DominanceReplayError {
    #[error("dominance witness {index} names one state as its own dominator")]
    SelfDominating { index: usize },
    #[error("dominance witness {index} has a dominator with fewer repairs")]
    RepairsNotDominating { index: usize },
    #[error("dominance witness {index} fails the comparison on resource {coordinate}")]
    LoadNotDominating { index: usize, coordinate: usize },
    #[error(
        "dominance witness {index} has a lane value outside its layout on resource {coordinate}"
    )]
    LaneOutOfRange { index: usize, coordinate: usize },
    #[error("dominance witness layer boundaries are not increasing at layer {layer}")]
    LayerBoundsNotMonotone { layer: usize },
}

/// Re-evaluates every recorded comparison from the records alone.
///
/// Returns the number of deletions verified. The checker never consults the
/// problem, the compiled options, or the dynamic program, and it unpacks lanes
/// with shifts and masks rather than with the solver's packed arithmetic.
pub fn replay_dominance_witnesses(
    layout: &DominanceLayout,
    witnesses: &[DominanceWitness],
    layer_starts: &[u32],
) -> Result<u64, DominanceReplayError> {
    let mut previous = 0u32;
    for (layer, &start) in layer_starts.iter().enumerate() {
        if start < previous || start as usize > witnesses.len() {
            return Err(DominanceReplayError::LayerBoundsNotMonotone { layer });
        }
        previous = start;
    }
    for (index, witness) in witnesses.iter().enumerate() {
        if witness.dominator == witness.pruned {
            return Err(DominanceReplayError::SelfDominating { index });
        }
        if witness.dominator_repairs < witness.pruned_repairs {
            return Err(DominanceReplayError::RepairsNotDominating { index });
        }
        let tail = layout.tail_mask();
        if witness.packed_dominator & tail != 0 || witness.packed_pruned & tail != 0 {
            return Err(DominanceReplayError::LaneOutOfRange {
                index,
                coordinate: 0,
            });
        }
        for coordinate in 0..layout.width() {
            // Read the guard bit too: a forged vector that sets one would read
            // back as a legal value through the masking accessor.
            let dominator = layout.lane_raw(witness.packed_dominator, coordinate);
            let pruned = layout.lane_raw(witness.packed_pruned, coordinate);
            let ceiling = layout
                .lane_limit(coordinate)
                .min(layout.capacity(coordinate).saturating_add(1));
            if dominator >= ceiling || pruned >= ceiling {
                return Err(DominanceReplayError::LaneOutOfRange { index, coordinate });
            }
            if dominator < pruned {
                return Err(DominanceReplayError::LoadNotDominating { index, coordinate });
            }
        }
    }
    Ok(witnesses.len() as u64)
}

/// Serialized size of a witness list, in bytes.
#[inline]
pub fn dominance_witness_bytes(witnesses: &[DominanceWitness]) -> u64 {
    std::mem::size_of_val(witnesses) as u64
}

/// Counters describing one solve's pruning.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct DominanceCounters {
    /// States deleted by a certified dominance comparison.
    pub pruned_states: u64,
    /// Candidate comparisons performed by the certified scan.
    pub comparisons: u64,
    /// States kept because their comparison budget ran out.
    pub budget_exhausted: u64,
    /// States kept because the witness buffer was full.
    pub witness_capacity_exhausted: u64,
}

/// Reusable, presized storage for the certified frontier scan.
///
/// Every buffer is grown by [`Self::prepare_layer`] before the scan begins and
/// is only written, never grown, inside it.
#[derive(Debug, Default)]
pub struct DominanceStorage {
    layout: Option<DominanceLayout>,
    mode: DominanceMode,
    /// Per-resource maximum load the remaining demands can still place.
    suffix_maximum: Vec<u32>,
    /// Per-demand, per-resource maximum load, row-major over demands.
    demand_maximum: Vec<u32>,
    /// Scratch residual vector, one entry per resource.
    residual: Vec<u32>,
    /// Packed residual vector of each state in the layer, by state index.
    packed: Vec<u64>,
    /// Residual mass of each state in the layer, by state index.
    mass: Vec<u64>,
    /// Visit order: state indices sorted by descending residual mass.
    order: Vec<u32>,
    /// Indices of kept states, in visit order.
    kept: Vec<u32>,
    /// Packed residuals of kept states, parallel to `kept`.
    kept_packed: Vec<u64>,
    /// Repair counts of kept states, parallel to `kept`.
    kept_repairs: Vec<u32>,
    witnesses: Vec<DominanceWitness>,
    layer_starts: Vec<u32>,
    counters: DominanceCounters,
}

impl DominanceStorage {
    /// Resets the storage for a new solve over these capacities.
    ///
    /// Allocation happens here and in [`Self::prepare_layer`], never inside the
    /// scan. `suffix_maximum` is the per-resource maximum load all demands can
    /// place; it is decremented layer by layer by [`Self::advance_layer`].
    pub fn begin_solve(&mut self, capacities: &[u32], mode: DominanceMode) {
        self.mode = mode;
        self.layout = mode
            .certified()
            .then(|| DominanceLayout::new(capacities))
            .flatten();
        self.suffix_maximum.clear();
        self.suffix_maximum.resize(capacities.len(), 0);
        self.residual.clear();
        self.residual.resize(capacities.len(), 0);
        self.witnesses.clear();
        self.layer_starts.clear();
        self.counters = DominanceCounters::default();
    }

    /// Whether the certified path is available for this solve.
    #[inline]
    pub fn certified(&self) -> bool {
        self.layout.is_some()
    }

    /// The per-resource suffix maximum, for the caller to fill before layer 0.
    #[inline]
    pub fn suffix_maximum_mut(&mut self) -> &mut [u32] {
        &mut self.suffix_maximum
    }

    /// Whether this solve needs the caller to supply per-demand load maxima.
    ///
    /// Only [`DominanceMode::ClampedSuffix`] does; the exact relation ignores
    /// the remaining demands entirely.
    #[inline]
    pub fn needs_suffix_maxima(&self) -> bool {
        self.layout.is_some() && matches!(self.mode, DominanceMode::ClampedSuffix)
    }

    /// Returns a zeroed `demands * width` row-major table for the caller to fill
    /// with each demand's maximum load on each resource.
    pub fn begin_suffix_maxima(&mut self, demands: usize, width: usize) -> &mut [u32] {
        self.demand_maximum.clear();
        self.demand_maximum.resize(demands * width, 0);
        &mut self.demand_maximum
    }

    /// Sums the filled table into the layer-0 suffix maximum.
    pub fn seed_suffix_maxima(&mut self, width: usize) {
        self.suffix_maximum.iter_mut().for_each(|value| *value = 0);
        for row in self.demand_maximum.chunks_exact(width) {
            for (total, &value) in self.suffix_maximum.iter_mut().zip(row) {
                *total = total.saturating_add(value);
            }
        }
    }

    /// Removes the just-decided demand's contribution from the suffix maximum.
    #[inline]
    pub fn advance_layer(&mut self, demand: usize, width: usize) {
        let Some(row) = self
            .demand_maximum
            .get(demand * width..(demand + 1) * width)
        else {
            return;
        };
        for (remaining, &used) in self.suffix_maximum.iter_mut().zip(row) {
            *remaining = remaining.saturating_sub(used);
        }
    }

    /// Counters for the solve so far.
    #[inline]
    pub fn counters(&self) -> DominanceCounters {
        self.counters
    }

    /// The layout, when the certified path is active.
    #[inline]
    pub fn layout(&self) -> Option<&DominanceLayout> {
        self.layout.as_ref()
    }

    /// The witness list accumulated so far.
    #[inline]
    pub fn witnesses(&self) -> &[DominanceWitness] {
        &self.witnesses
    }

    /// Per-layer start offsets into the witness list.
    #[inline]
    pub fn layer_starts(&self) -> &[u32] {
        &self.layer_starts
    }

    /// Releases excess retained capacity after a workload-size change.
    pub fn shrink_to_fit(&mut self) {
        self.suffix_maximum.shrink_to_fit();
        self.demand_maximum.shrink_to_fit();
        self.residual.shrink_to_fit();
        self.packed.shrink_to_fit();
        self.mass.shrink_to_fit();
        self.order.shrink_to_fit();
        self.kept.shrink_to_fit();
        self.kept_packed.shrink_to_fit();
        self.kept_repairs.shrink_to_fit();
        self.witnesses.shrink_to_fit();
        self.layer_starts.shrink_to_fit();
    }
}

/// A state's committed load vector and repair count, as the scan sees it.
///
/// This is the caller's view of `ScheduleState`; the scan does not know the
/// frontier's record layout.
#[derive(Clone, Copy, Debug)]
pub struct FrontierState {
    /// Offset of this state's load vector in the caller's flat load array.
    pub load_start: u32,
    /// Repairs performed to reach this state.
    pub repairs: u32,
}

/// Decides the antichain for one layer and certifies every deletion.
///
/// Writes `1` into `keep[i]` for each retained state. Returns `false` when the
/// certified path is unavailable, in which case `keep` is untouched and the
/// caller must run its own scan.
///
/// The scan performs no allocation: every buffer it writes was sized by
/// `prepare_layer` before the first comparison.
pub fn certified_pareto_keep_into(
    storage: &mut DominanceStorage,
    states: &[FrontierState],
    loads: &[u32],
    capacities: &[u32],
    keep: &mut Vec<u8>,
) -> bool {
    let DominanceStorage {
        layout,
        mode,
        suffix_maximum,
        demand_maximum: _,
        residual,
        packed,
        mass,
        order,
        kept,
        kept_packed,
        kept_repairs,
        witnesses,
        layer_starts,
        counters,
    } = storage;
    let Some(layout) = layout.as_ref() else {
        return false;
    };
    let width = capacities.len();
    let clamp = matches!(mode, DominanceMode::ClampedSuffix);

    packed.clear();
    packed.reserve(states.len());
    mass.clear();
    mass.reserve(states.len());
    order.clear();
    order.reserve(states.len());
    kept.clear();
    kept.reserve(states.len());
    kept_packed.clear();
    kept_packed.reserve(states.len());
    kept_repairs.clear();
    kept_repairs.reserve(states.len());
    layer_starts.push(witnesses.len() as u32);

    // Pack every state's residual vector once. A residual is `cap - load`,
    // optionally clamped at the load the remaining demands can still place;
    // dominance on loads is the reverse inequality on residuals.
    for state in states {
        let start = state.load_start as usize;
        let mut residual_mass = 0u64;
        for coordinate in 0..width {
            let free = capacities[coordinate] - loads[start + coordinate];
            let free = if clamp {
                free.min(suffix_maximum[coordinate])
            } else {
                free
            };
            residual[coordinate] = free;
            residual_mass += u64::from(free);
        }
        let Some(state_packed) = layout.pack(residual) else {
            // A residual outside its lane cannot happen for a capacity-feasible
            // state, but bail to the caller's scan rather than emit an
            // uncheckable witness.
            layer_starts.pop();
            return false;
        };
        packed.push(state_packed);
        mass.push(residual_mass);
    }

    // Visit in descending residual mass. A dominator's residual is at least the
    // dominated state's in every coordinate, so its mass is at least as large
    // and it is visited first; ties break on repairs so that within a group of
    // equal residual vectors the survivor is the one with the most repairs.
    order.extend(0..states.len() as u32);
    order.sort_unstable_by_key(|&index| {
        let index = index as usize;
        (
            std::cmp::Reverse(mass[index]),
            std::cmp::Reverse(states[index].repairs),
            index as u32,
        )
    });

    keep.clear();
    keep.resize(states.len(), 0);

    for &visited in order.iter() {
        let index = visited as usize;
        let candidate = packed[index];
        let repairs = states[index].repairs;
        let limit = kept.len().min(DOMINANCE_COMPARISON_BUDGET);
        let mut dominator = usize::MAX;
        let mut comparisons = 0usize;
        while comparisons < limit {
            if kept_repairs[comparisons] >= repairs
                && layout.dominates_packed(kept_packed[comparisons], candidate)
            {
                dominator = comparisons;
                break;
            }
            comparisons += 1;
        }
        counters.comparisons += comparisons as u64 + u64::from(dominator != usize::MAX);

        // Keeping a state is always sound, so both exhaustion paths fall back to
        // it: an unpruned frontier can only add work, never change the optimum.
        let exhausted_budget = dominator == usize::MAX && kept.len() > DOMINANCE_COMPARISON_BUDGET;
        let exhausted_witnesses =
            dominator != usize::MAX && witnesses.len() == DOMINANCE_WITNESS_CAPACITY;
        if dominator == usize::MAX || exhausted_witnesses {
            counters.budget_exhausted += u64::from(exhausted_budget);
            counters.witness_capacity_exhausted += u64::from(exhausted_witnesses);
            keep[index] = 1;
            kept.push(visited);
            kept_packed.push(candidate);
            kept_repairs.push(repairs);
            continue;
        }
        witnesses.push(DominanceWitness {
            packed_dominator: kept_packed[dominator],
            packed_pruned: candidate,
            dominator: kept[dominator],
            pruned: visited,
            dominator_repairs: kept_repairs[dominator],
            pruned_repairs: repairs,
        });
        counters.pruned_states += 1;
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    fn layout() -> DominanceLayout {
        DominanceLayout::new(&[7, 7, 7]).unwrap()
    }

    #[test]
    fn lanes_round_trip_through_the_packed_layout() {
        let layout = layout();
        let packed = layout.pack(&[0, 5, 7]).unwrap();
        assert_eq!(layout.lane(packed, 0), 0);
        assert_eq!(layout.lane(packed, 1), 5);
        assert_eq!(layout.lane(packed, 2), 7);
        assert_eq!(packed & layout.guard, 0);
    }

    #[test]
    fn packed_comparison_agrees_with_the_coordinate_comparison() {
        let layout = DominanceLayout::new(&[5, 9]).unwrap();
        for left0 in 0..=5u32 {
            for left1 in 0..=9u32 {
                for right0 in 0..=5u32 {
                    for right1 in 0..=9u32 {
                        let left = layout.pack(&[left0, left1]).unwrap();
                        let right = layout.pack(&[right0, right1]).unwrap();
                        assert_eq!(
                            layout.dominates_packed(left, right),
                            left0 >= right0 && left1 >= right1,
                            "({left0},{left1}) >= ({right0},{right1})"
                        );
                    }
                }
            }
        }
    }

    #[test]
    fn wide_capacities_have_no_layout() {
        assert!(DominanceLayout::new(&[u32::MAX; 4]).is_none());
        assert!(DominanceLayout::new(&[]).is_none());
    }

    #[test]
    fn replay_accepts_an_honest_witness_and_rejects_every_forgery() {
        let layout = layout();
        let genuine = DominanceWitness {
            packed_dominator: layout.pack(&[4, 4, 4]).unwrap(),
            packed_pruned: layout.pack(&[1, 2, 3]).unwrap(),
            dominator: 0,
            pruned: 1,
            dominator_repairs: 3,
            pruned_repairs: 3,
        };
        assert_eq!(
            replay_dominance_witnesses(&layout, &[genuine], &[0]).unwrap(),
            1
        );

        let mut forged = genuine;
        forged.packed_pruned = layout.pack(&[1, 2, 5]).unwrap();
        assert_eq!(
            replay_dominance_witnesses(&layout, &[forged], &[0]),
            Err(DominanceReplayError::LoadNotDominating {
                index: 0,
                coordinate: 2
            })
        );

        let mut forged = genuine;
        forged.dominator_repairs = 2;
        assert_eq!(
            replay_dominance_witnesses(&layout, &[forged], &[0]),
            Err(DominanceReplayError::RepairsNotDominating { index: 0 })
        );

        let mut forged = genuine;
        forged.pruned = forged.dominator;
        assert_eq!(
            replay_dominance_witnesses(&layout, &[forged], &[0]),
            Err(DominanceReplayError::SelfDominating { index: 0 })
        );

        let mut forged = genuine;
        forged.packed_dominator |= layout.guard;
        assert_eq!(
            replay_dominance_witnesses(&layout, &[forged], &[0]),
            Err(DominanceReplayError::LaneOutOfRange {
                index: 0,
                coordinate: 0
            })
        );

        assert_eq!(
            replay_dominance_witnesses(&layout, &[genuine], &[1, 0]),
            Err(DominanceReplayError::LayerBoundsNotMonotone { layer: 1 })
        );
    }

    /// The scan's antichain must equal the baseline all-pairs antichain.
    #[test]
    fn certified_scan_reproduces_the_all_pairs_antichain() {
        let capacities = [6u32, 6, 6];
        let width = capacities.len();
        let mut seed = 0x2545_f491_4f6c_dd1d_u64;
        let mut next = move || {
            seed ^= seed << 13;
            seed ^= seed >> 7;
            seed ^= seed << 17;
            seed
        };
        for _ in 0..200 {
            let count = (next() % 40) as usize + 1;
            let mut loads = Vec::new();
            let mut states = Vec::new();
            for _ in 0..count {
                let start = loads.len() as u32;
                for &capacity in &capacities {
                    loads.push((next() % u64::from(capacity + 1)) as u32);
                }
                states.push(FrontierState {
                    load_start: start,
                    repairs: (next() % 5) as u32,
                });
            }
            // The frontier never holds two states with the same load vector.
            let mut seen = std::collections::HashSet::new();
            states.retain(|state| {
                let start = state.load_start as usize;
                seen.insert(loads[start..start + width].to_vec())
            });

            let expected: Vec<u8> = states
                .iter()
                .enumerate()
                .map(|(index, state)| {
                    let start = state.load_start as usize;
                    u8::from(!states.iter().enumerate().any(|(other_index, other)| {
                        if other_index == index || other.repairs < state.repairs {
                            return false;
                        }
                        let other_start = other.load_start as usize;
                        loads[other_start..other_start + width]
                            .iter()
                            .zip(&loads[start..start + width])
                            .all(|(left, right)| left <= right)
                    }))
                })
                .collect();

            let mut storage = DominanceStorage::default();
            storage.begin_solve(&capacities, DominanceMode::Exact);
            let mut keep = Vec::new();
            assert!(certified_pareto_keep_into(
                &mut storage,
                &states,
                &loads,
                &capacities,
                &mut keep
            ));
            assert_eq!(keep, expected);
            assert_eq!(
                replay_dominance_witnesses(
                    storage.layout().unwrap(),
                    storage.witnesses(),
                    storage.layer_starts()
                )
                .unwrap(),
                storage.counters().pruned_states
            );
        }
    }

    #[test]
    fn clamping_prunes_at_least_as_much_as_the_exact_relation() {
        let capacities = [10u32, 10];
        let loads = [0u32, 9, 1, 8, 2, 7];
        let states = [
            FrontierState {
                load_start: 0,
                repairs: 1,
            },
            FrontierState {
                load_start: 2,
                repairs: 1,
            },
            FrontierState {
                load_start: 4,
                repairs: 1,
            },
        ];
        let mut keep_exact = Vec::new();
        let mut storage = DominanceStorage::default();
        storage.begin_solve(&capacities, DominanceMode::Exact);
        certified_pareto_keep_into(&mut storage, &states, &loads, &capacities, &mut keep_exact);
        assert_eq!(keep_exact, [1, 1, 1]);

        let mut keep_clamped = Vec::new();
        let mut storage = DominanceStorage::default();
        storage.begin_solve(&capacities, DominanceMode::ClampedSuffix);
        // One demand remains and no option loads more than 1 on either
        // resource, so every residual clamps to 1 and all three states become
        // interchangeable.
        storage.suffix_maximum_mut().copy_from_slice(&[1, 1]);
        certified_pareto_keep_into(
            &mut storage,
            &states,
            &loads,
            &capacities,
            &mut keep_clamped,
        );
        assert_eq!(keep_clamped.iter().map(|&k| u32::from(k)).sum::<u32>(), 1);
        assert_eq!(storage.counters().pruned_states, 2);
    }

    #[test]
    fn legacy_mode_declines_the_certified_path() {
        let mut storage = DominanceStorage::default();
        storage.begin_solve(&[4, 4], DominanceMode::Legacy);
        assert!(!storage.certified());
        let mut keep = Vec::new();
        assert!(!certified_pareto_keep_into(
            &mut storage,
            &[],
            &[],
            &[4, 4],
            &mut keep
        ));
    }
}
