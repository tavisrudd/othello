//! Discovery-only evolution of the unrestricted q29/q58/q87 margin shells.
//!
//! Phase one searches a 448-byte q29 quotient seeded on the exact zero-shift
//! energy shell; within-row swaps preserve both that shell and the four row
//! sums.  Only an exact q29 hit is lifted to the q174 `Z/6 x Z/29`
//! triple-count table for q58/q87 evolution.  Exact hits provide the actual
//! margin corpus needed to size the missing order-six residual search.

use crate::q29_inventory_scope::{
    sample_rotating_q29_outer_profile_seed, Q29InventoryError, Q29InventoryWorkspace,
    Q29OuterProfilePolicy, Q29OuterProfileSeed,
};

const BLOCKS: usize = 4;
const CLASSES: usize = 6;
const COLUMNS: usize = 29;
const CELLS: usize = CLASSES * COLUMNS;
const Q29: usize = 29;
const Q58: usize = 58;
const Q87: usize = 87;
const Q29_SHIFTS: usize = 15;
const Q58_SHIFTS: usize = 30;
const Q87_SHIFTS: usize = 44;
const Q29_MOVES: usize = BLOCKS * Q29 * (Q29 - 1);
const Q29_BLOCK_MOVES: usize = Q29 * (Q29 - 1);
const Q29_PAIR_MOVES: usize = Q29_BLOCK_MOVES * Q29_BLOCK_MOVES;
const Q29_TRIPLE_MULTISETS: usize = 4_495;

#[repr(C)]
#[derive(Clone, Copy)]
struct Q29MoveDelta {
    delta: [i16; Q29_SHIFTS - 1],
    block: u8,
    from: u8,
    to: u8,
    _padding: u8,
}

impl Q29MoveDelta {
    const ZERO: Self = Self {
        delta: [0; Q29_SHIFTS - 1],
        block: 0,
        from: 0,
        to: 0,
        _padding: 0,
    };
}

const _: () = assert!(std::mem::size_of::<Q29MoveDelta>() == 32);
const _: () = assert!(std::mem::align_of::<Q29MoveDelta>() == 2);

/// Cold per-reseed observation for generic scope learning.  It contains only
/// anonymous numeric scope coordinates and outcomes, not theorem labels.
#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29OuterEpochStat {
    pub magnitude_inventory_counts: [u64; 4],
    pub initial_q29_score: u64,
    pub best_q29_score: u64,
    pub energies: [u16; 4],
    pub odd_supports: [u8; 4],
    pub policy: Q29OuterProfilePolicy,
    pub _pad: [u8; 3],
}

impl Q29OuterEpochStat {
    pub const ZERO: Self = Self {
        magnitude_inventory_counts: [0; 4],
        initial_q29_score: 0,
        best_q29_score: 0,
        energies: [0; 4],
        odd_supports: [0; 4],
        policy: Q29OuterProfilePolicy::UniformScope,
        _pad: [0; 3],
    };
}

const _: () = assert!(std::mem::size_of::<Q29OuterEpochStat>() == 64);
const _: () = assert!(std::mem::align_of::<Q29OuterEpochStat>() == 64);

#[repr(C)]
#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
struct Q29PairDelta {
    delta: [i16; Q29_SHIFTS - 1],
    left: u16,
    right: u16,
}

const _: () = assert!(std::mem::size_of::<Q29PairDelta>() == 32);
const _: () = assert!(std::mem::align_of::<Q29PairDelta>() == 2);

#[repr(C)]
#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
struct Q29LocalDelta {
    delta: [i16; Q29_SHIFTS - 1],
    moves: u32,
}

const _: () = assert!(std::mem::size_of::<Q29LocalDelta>() == 32);
const _: () = assert!(std::mem::align_of::<Q29LocalDelta>() == 4);

#[repr(C)]
#[derive(Clone, Copy)]
struct Q29ChosenLocal {
    moves: u32,
    block: u8,
    count: u8,
    _padding: [u8; 2],
}

const _: () = assert!(std::mem::size_of::<Q29ChosenLocal>() == 8);
const _: () = assert!(std::mem::align_of::<Q29ChosenLocal>() == 4);

#[inline(always)]
fn q29_mod_power(value: usize, exponent: usize) -> i32 {
    let mut result = 1_i32;
    for _ in 0..exponent {
        result = (result * value as i32) % Q29 as i32;
    }
    result
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct Q29EvenMomentDelta {
    second: u8,
    fourth: u8,
}

const _: () = assert!(std::mem::size_of::<Q29EvenMomentDelta>() == 2);
const _: () = assert!(std::mem::align_of::<Q29EvenMomentDelta>() == 1);

#[repr(C)]
#[derive(Clone, Copy)]
struct Q29TripleMultiset {
    positions: [u8; 3],
    power_sums: [u8; 4],
    _padding: u8,
}

const _: () = assert!(std::mem::size_of::<Q29TripleMultiset>() == 8);
const _: () = assert!(std::mem::align_of::<Q29TripleMultiset>() == 1);

impl Q29TripleMultiset {
    fn new(positions: [usize; 3]) -> Self {
        Self {
            positions: positions.map(|position| position as u8),
            power_sums: std::array::from_fn(|power| {
                positions
                    .iter()
                    .map(|&position| q29_mod_power(position, power + 1))
                    .sum::<i32>()
                    .rem_euclid(Q29 as i32) as u8
            }),
            _padding: 0,
        }
    }
}

/// Cold storage for the exact same-row radius-three repair kernel.  The
/// universal size-three multisets are compiled once; the candidate loop only
/// scans this fixed contiguous table.
pub struct Order6Q29TripleBlockWorkspace {
    patterns: Vec<Q29TripleMultiset>,
}

impl Order6Q29TripleBlockWorkspace {
    #[must_use]
    pub fn new() -> Self {
        let mut patterns = Vec::with_capacity(Q29_TRIPLE_MULTISETS);
        for first in 0..Q29 {
            for second in first..Q29 {
                for third in second..Q29 {
                    patterns.push(Q29TripleMultiset::new([first, second, third]));
                }
            }
        }
        debug_assert_eq!(patterns.len(), Q29_TRIPLE_MULTISETS);
        Self { patterns }
    }

    #[must_use]
    pub fn bytes(&self) -> usize {
        self.patterns.capacity() * std::mem::size_of::<Q29TripleMultiset>()
    }
}

impl Default for Order6Q29TripleBlockWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

const Q29_TRIPLE_DOUBLE_TT_SLOTS: usize = 1 << 21;

/// Cold exact-delta tablebase for the radius-five `3+2` repair slice.  The
/// table key contains energy and every independent q29 PAF coordinate, so one
/// retained preimage per key is sufficient.  Hash collisions are resolved by
/// full-key comparison and therefore have no semantic authority.
pub struct Order6Q29TripleDoubleWorkspace {
    patterns: Vec<Q29TripleMultiset>,
    raw_doubles: Vec<Q29LocalDelta>,
    exact_deltas: Vec<[i16; 16]>,
    slots: Vec<u32>,
}

impl Order6Q29TripleDoubleWorkspace {
    #[must_use]
    pub fn new() -> Self {
        Self {
            patterns: Order6Q29TripleBlockWorkspace::new().patterns,
            raw_doubles: Vec::with_capacity(Q29_PAIR_MOVES),
            exact_deltas: Vec::with_capacity(Q29_PAIR_MOVES),
            slots: vec![0; Q29_TRIPLE_DOUBLE_TT_SLOTS],
        }
    }

    #[must_use]
    pub fn bytes(&self) -> usize {
        self.patterns.capacity() * std::mem::size_of::<Q29TripleMultiset>()
            + self.raw_doubles.capacity() * std::mem::size_of::<Q29LocalDelta>()
            + self.exact_deltas.capacity() * std::mem::size_of::<[i16; 16]>()
            + self.slots.capacity() * std::mem::size_of::<u32>()
    }
}

impl Default for Order6Q29TripleDoubleWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

/// Cold storage for the exact three-distinct-block repair kernel.  Allocation
/// occurs only in construction; repeated repairs clear and reuse the buffer.
pub struct Order6Q29ThreeMoveWorkspace {
    pairs: Vec<Q29PairDelta>,
}

impl Order6Q29ThreeMoveWorkspace {
    #[must_use]
    pub fn new() -> Self {
        Self {
            pairs: Vec::with_capacity(Q29_PAIR_MOVES),
        }
    }

    #[must_use]
    pub fn bytes(&self) -> usize {
        self.pairs.capacity() * std::mem::size_of::<Q29PairDelta>()
    }
}

impl Default for Order6Q29ThreeMoveWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

/// Cold storage for the exact radius-four repair restricted to at most two
/// transfers in each row.  Same-row transfers are compiled sequentially from
/// the changed row, never by adding two root-state deltas.
pub struct Order6Q29RadiusFourWorkspace {
    doubles: [Vec<Q29LocalDelta>; BLOCKS],
    pair_singles: Vec<Q29LocalDelta>,
}

impl Order6Q29RadiusFourWorkspace {
    #[must_use]
    pub fn new() -> Self {
        Self {
            doubles: std::array::from_fn(|_| Vec::with_capacity(Q29_PAIR_MOVES)),
            pair_singles: Vec::with_capacity(Q29_PAIR_MOVES),
        }
    }

    #[must_use]
    pub fn bytes(&self) -> usize {
        (self.doubles.iter().map(Vec::capacity).sum::<usize>() + self.pair_singles.capacity())
            * std::mem::size_of::<Q29LocalDelta>()
    }
}

impl Default for Order6Q29RadiusFourWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

/// Phase-one state contains only the quotient actually observed by the q29
/// objective.  Keeping the 696-cell lift out of this loop removes a large
/// neutral fibre: one q29 transfer is one effective mutation.
#[repr(C, align(64))]
#[derive(Clone, Copy)]
struct Q29PhaseState {
    values: [[i8; Q29]; BLOCKS],
    block_paf: [[i32; Q29_SHIFTS]; BLOCKS],
    combined_paf: [i32; Q29_SHIFTS],
    score: u64,
    _padding: [u8; 20],
}

const _: () = assert!(std::mem::size_of::<Q29PhaseState>() == 448);
const _: () = assert!(std::mem::align_of::<Q29PhaseState>() == 64);

#[repr(C, align(64))]
#[derive(Clone, Copy)]
pub struct Order6MarginEvolveState {
    counts: [[u8; CELLS]; BLOCKS],
    q29: [[i8; Q29]; BLOCKS],
    q58: [[i8; Q58]; BLOCKS],
    q87: [[i8; Q87]; BLOCKS],
    block_q29_paf: [[i32; Q29_SHIFTS]; BLOCKS],
    block_q58_paf: [[i32; Q58_SHIFTS]; BLOCKS],
    block_q87_paf: [[i32; Q87_SHIFTS]; BLOCKS],
    combined_q29_paf: [i32; Q29_SHIFTS],
    combined_q58_paf: [i32; Q58_SHIFTS],
    combined_q87_paf: [i32; Q87_SHIFTS],
    q174_energy: i32,
    score: u64,
    _padding: [u8; 16],
}

const _: () = assert!(std::mem::size_of::<Order6MarginEvolveState>() == 3_200);
const _: () = assert!(std::mem::align_of::<Order6MarginEvolveState>() == 64);

#[derive(Clone, Debug, PartialEq)]
pub struct Order6MarginEvolveReport {
    pub seed: u64,
    pub mutations: u64,
    pub accepted: u64,
    pub best_score: u64,
    pub best_score_components: [u64; 4],
    pub q29_shell_hit: bool,
    pub phase_two_mutations: u64,
    pub exact_shell_hit: bool,
    pub best_counts: [[u8; CELLS]; BLOCKS],
    pub best_q29: [[i8; Q29]; BLOCKS],
    pub best_q58: [[i8; Q58]; BLOCKS],
    pub best_q87: [[i8; Q87]; BLOCKS],
    pub provenance: &'static str,
}

impl Order6MarginEvolveState {
    #[must_use]
    pub fn seeded(mut seed: u64) -> Self {
        let mut counts = [[1_u8; CELLS]; BLOCKS];
        for (block, block_counts) in counts.iter_mut().enumerate() {
            let increments = if block == 0 { 88 } else { 87 };
            let mut positions = std::array::from_fn::<_, CELLS, _>(|index| index as u16);
            for tail in (1..CELLS).rev() {
                let swap = (next_random(&mut seed) as usize) % (tail + 1);
                positions.swap(tail, swap);
            }
            for &cell in &positions[..increments] {
                block_counts[usize::from(cell)] += 1;
            }
        }
        Self::from_counts(counts)
    }

    #[must_use]
    pub fn from_counts(counts: [[u8; CELLS]; BLOCKS]) -> Self {
        let mut state = Self {
            counts,
            q29: [[0; Q29]; BLOCKS],
            q58: [[0; Q58]; BLOCKS],
            q87: [[0; Q87]; BLOCKS],
            block_q29_paf: [[0; Q29_SHIFTS]; BLOCKS],
            block_q58_paf: [[0; Q58_SHIFTS]; BLOCKS],
            block_q87_paf: [[0; Q87_SHIFTS]; BLOCKS],
            combined_q29_paf: [0; Q29_SHIFTS],
            combined_q58_paf: [0; Q58_SHIFTS],
            combined_q87_paf: [0; Q87_SHIFTS],
            q174_energy: 0,
            score: 0,
            _padding: [0; 16],
        };
        for block in 0..BLOCKS {
            for cell in 0..CELLS {
                let signed = 2 * state.counts[block][cell] as i8 - 3;
                let class = cell % CLASSES;
                let column = cell % COLUMNS;
                state.q29[block][column] += signed;
                state.q58[block][(class % 2) * COLUMNS + column] += signed;
                state.q87[block][(class % 3) * COLUMNS + column] += signed;
                state.q174_energy += i32::from(signed) * i32::from(signed);
            }
            state.block_q29_paf[block] = direct_paf::<1, Q29, Q29_SHIFTS>(&state.q29[block]);
            state.block_q58_paf[block] = direct_paf::<2, Q58, Q58_SHIFTS>(&state.q58[block]);
            state.block_q87_paf[block] = direct_paf::<3, Q87, Q87_SHIFTS>(&state.q87[block]);
            for shift in 0..Q29_SHIFTS {
                state.combined_q29_paf[shift] += state.block_q29_paf[block][shift];
            }
            for shift in 0..Q58_SHIFTS {
                state.combined_q58_paf[shift] += state.block_q58_paf[block][shift];
            }
            for shift in 0..Q87_SHIFTS {
                state.combined_q87_paf[shift] += state.block_q87_paf[block][shift];
            }
        }
        state.score = state.recompute_score();
        state
    }

    fn recompute_score(&self) -> u64 {
        self.score_components().iter().sum()
    }

    fn score_components(&self) -> [u64; 4] {
        [
            squared_target_error(&self.combined_q29_paf, 2_020, -72),
            squared_target_error(&self.combined_q58_paf, 2_056, -36),
            squared_target_error(&self.combined_q87_paf, 2_068, -24),
            u64::from((self.q174_energy - 2_080).unsigned_abs()).pow(2),
        ]
    }

    fn apply_transfer(&mut self, block: usize, from: usize, to: usize) {
        let old_from = 2 * self.counts[block][from] as i8 - 3;
        let old_to = 2 * self.counts[block][to] as i8 - 3;
        self.counts[block][from] -= 1;
        self.counts[block][to] += 1;
        let new_from = old_from - 2;
        let new_to = old_to + 2;
        self.q174_energy += i32::from(new_from) * i32::from(new_from)
            + i32::from(new_to) * i32::from(new_to)
            - i32::from(old_from) * i32::from(old_from)
            - i32::from(old_to) * i32::from(old_to);

        let from_class = from % CLASSES;
        let from_column = from % COLUMNS;
        let to_class = to % CLASSES;
        let to_column = to % COLUMNS;
        update_view::<1, Q29, Q29_SHIFTS>(
            &mut self.q29[block],
            &mut self.block_q29_paf[block],
            &mut self.combined_q29_paf,
            from_column,
            to_column,
        );
        update_view::<2, Q58, Q58_SHIFTS>(
            &mut self.q58[block],
            &mut self.block_q58_paf[block],
            &mut self.combined_q58_paf,
            (from_class % 2) * COLUMNS + from_column,
            (to_class % 2) * COLUMNS + to_column,
        );
        update_view::<3, Q87, Q87_SHIFTS>(
            &mut self.q87[block],
            &mut self.block_q87_paf[block],
            &mut self.combined_q87_paf,
            (from_class % 3) * COLUMNS + from_column,
            (to_class % 3) * COLUMNS + to_column,
        );
        self.score = self.recompute_score();
    }
}

impl Q29PhaseState {
    fn seeded_exact(random: &mut u64) -> Self {
        let mut values = [[0_i8; Q29]; BLOCKS];
        let inventories = [
            (13, 13, 1, 1, 1, 0),
            (13, 12, 1, 2, 1, 0),
            (13, 12, 1, 2, 1, 0),
            (12, 15, 2, 0, 0, 0),
        ];
        for (block, &(p4, n4, p6, n6, p2, n2)) in inventories.iter().enumerate() {
            let mut cursor = 0;
            for (count, value) in [(p4, 4), (n4, -4), (p6, 6), (n6, -6), (p2, 2), (n2, -2)] {
                for _ in 0..count {
                    values[block][cursor] = value;
                    cursor += 1;
                }
            }
            debug_assert_eq!(cursor, Q29);
            for tail in (1..Q29).rev() {
                let swap = (next_random(random) as usize) % (tail + 1);
                values[block].swap(tail, swap);
            }
        }
        let state = Self::from_values(values);
        debug_assert_eq!(state.combined_paf[0], 2_020);
        state
    }

    /// Seed on the exact mod-two group-ring shell.  For `y = x / 2`, the
    /// four odd supports have sizes 3, 4, 4, and 2, while the target says
    /// `sum D D* = 1` in `F_2[C_29]`.  The off-zero part is therefore the
    /// equality of two 14-bit cyclic-difference signatures.
    fn seeded_parity_shell(random: &mut u64) -> Self {
        let supports = parity_supports(random);
        let inventories: [[(usize, i8); 6]; BLOCKS] = [
            [(13, 4), (13, -4), (1, 6), (1, -6), (1, 2), (0, -2)],
            [(13, 4), (12, -4), (1, 6), (2, -6), (1, 2), (0, -2)],
            [(13, 4), (12, -4), (1, 6), (2, -6), (1, 2), (0, -2)],
            [(12, 4), (15, -4), (2, 6), (0, -6), (0, 2), (0, -2)],
        ];
        let mut values = [[0_i8; Q29]; BLOCKS];
        for block in 0..BLOCKS {
            let support = supports[block];
            let mut odd = [0_u8; 4];
            let mut even = [0_u8; 27];
            let mut odd_len = 0;
            let mut even_len = 0;
            for column in 0..Q29 {
                if support & (1_u32 << column) != 0 {
                    odd[odd_len] = column as u8;
                    odd_len += 1;
                } else {
                    even[even_len] = column as u8;
                    even_len += 1;
                }
            }
            shuffle_prefix(&mut odd, odd_len, random);
            shuffle_prefix(&mut even, even_len, random);
            let mut odd_cursor = 0;
            let mut even_cursor = 0;
            for &(count, value) in &inventories[block] {
                for _ in 0..count {
                    let index = if matches!(value.abs(), 2 | 6) {
                        let index = usize::from(odd[odd_cursor]);
                        odd_cursor += 1;
                        index
                    } else {
                        let index = usize::from(even[even_cursor]);
                        even_cursor += 1;
                        index
                    };
                    values[block][index] = value;
                }
            }
            debug_assert_eq!(odd_cursor, odd_len);
            debug_assert_eq!(even_cursor, even_len);
        }
        let state = Self::from_values(values);
        debug_assert_eq!(combined_parity_signature(&state.values), 0);
        state
    }

    fn seeded_outer_profile(
        workspace: &mut Q29InventoryWorkspace,
        random: &mut u64,
        epoch: u64,
    ) -> Result<(Self, Q29OuterProfileSeed), Q29InventoryError> {
        let seed = sample_rotating_q29_outer_profile_seed(workspace, random, epoch)?;
        Ok((Self::from_outer_profile_seed(&seed), seed))
    }

    fn from_outer_profile_seed(seed: &Q29OuterProfileSeed) -> Self {
        let mut values = [[0_i8; Q29]; BLOCKS];
        for block in 0..BLOCKS {
            for column in 0..Q29 {
                values[block][column] = 2 * seed.rows[block][column];
            }
        }
        let state = Self::from_values(values);
        debug_assert_eq!(state.combined_paf[0], 2_020);
        state
    }

    fn from_values(values: [[i8; Q29]; BLOCKS]) -> Self {
        let mut state = Self {
            values,
            block_paf: [[0; Q29_SHIFTS]; BLOCKS],
            combined_paf: [0; Q29_SHIFTS],
            score: 0,
            _padding: [0; 20],
        };
        for block in 0..BLOCKS {
            state.block_paf[block] = direct_paf::<1, Q29, Q29_SHIFTS>(&state.values[block]);
            for shift in 0..Q29_SHIFTS {
                state.combined_paf[shift] += state.block_paf[block][shift];
            }
        }
        state.score = squared_target_error(&state.combined_paf, 2_020, -72);
        state
    }

    #[inline(always)]
    fn apply_transfer(&mut self, block: usize, from: usize, to: usize) {
        update_view::<1, Q29, Q29_SHIFTS>(
            &mut self.values[block],
            &mut self.block_paf[block],
            &mut self.combined_paf,
            from,
            to,
        );
        self.score = squared_target_error(&self.combined_paf, 2_020, -72);
    }

    #[inline(always)]
    fn apply_swap(&mut self, block: usize, from: usize, to: usize) {
        swap_view::<1, Q29, Q29_SHIFTS>(
            &mut self.values[block],
            &mut self.block_paf[block],
            &mut self.combined_paf,
            from,
            to,
        );
        self.score = squared_target_error(&self.combined_paf, 2_020, -72);
    }
}

#[must_use]
pub fn evolve_order6_margin_shell(seed: u64, mutations: u64) -> Order6MarginEvolveReport {
    evolve_order6_margin_shell_inner::<false>(seed, mutations)
}

/// Experimental exact-parity-shell seed path.  It is retained as a theorem
/// control, but is not the default: freezing one support fibre measured worse
/// than allowing the support to evolve.
#[must_use]
pub fn evolve_order6_margin_shell_parity(seed: u64, mutations: u64) -> Order6MarginEvolveReport {
    evolve_order6_margin_shell_inner::<true>(seed, mutations)
}

/// Discovery-only search from the exact unrestricted outer-profile sampler.
/// The workspace must first be compiled by `census_q29_inventory_scopes`.
/// Sampling is cold; the existing 448-byte mutation state remains unchanged.
pub fn evolve_order6_margin_shell_outer(
    workspace: &mut Q29InventoryWorkspace,
    seed: u64,
    mutations: u64,
    epoch: u64,
) -> Result<Order6MarginEvolveReport, Q29InventoryError> {
    let mut random = seed;
    let (q29_state, _) = Q29PhaseState::seeded_outer_profile(workspace, &mut random, epoch)?;
    let mut report =
        evolve_order6_margin_shell_from_state::<false>(seed, mutations, random, q29_state);
    report.provenance =
        "ObservedEvolved; exact unrestricted outer-profile seed; direct shell replay; misses have no authority";
    Ok(report)
}

/// Search across many exact outer profiles.  Reseeding occurs only at the
/// cold epoch boundary; each epoch enters the unchanged allocation-free
/// 448-byte mutation kernel.  `statistics` is caller-owned and preflighted.
pub fn evolve_order6_margin_shell_outer_epochs(
    workspace: &mut Q29InventoryWorkspace,
    seed: u64,
    total_mutations: u64,
    epoch_mutations: u64,
    statistics: &mut [Q29OuterEpochStat],
) -> Result<Order6MarginEvolveReport, Q29InventoryError> {
    if total_mutations == 0 || epoch_mutations == 0 {
        return Err(Q29InventoryError::EmptySamplingDomain);
    }
    let epochs = total_mutations.div_ceil(epoch_mutations) as usize;
    if statistics.len() < epochs {
        return Err(Q29InventoryError::InsufficientOutputCapacity);
    }
    let mut coordinator_random = seed;
    let mut remaining = total_mutations;
    let mut best: Option<Order6MarginEvolveReport> = None;
    let mut accepted = 0_u64;
    let mut phase_two_mutations = 0_u64;
    for (epoch, statistic) in statistics[..epochs].iter_mut().enumerate() {
        let run_seed = next_random(&mut coordinator_random);
        let mut run_random = run_seed;
        let (q29_state, outer_seed) =
            Q29PhaseState::seeded_outer_profile(workspace, &mut run_random, epoch as u64)?;
        let initial_q29_score = q29_state.score;
        let mutations = remaining.min(epoch_mutations);
        let report = evolve_order6_margin_shell_from_state::<false>(
            run_seed, mutations, run_random, q29_state,
        );
        *statistic = Q29OuterEpochStat {
            magnitude_inventory_counts: outer_seed
                .scopes
                .map(|scope| scope.magnitude_inventory_count),
            initial_q29_score,
            best_q29_score: report.best_score_components[0],
            energies: outer_seed.scopes.map(|scope| scope.energy),
            odd_supports: outer_seed.scopes.map(|scope| scope.odd_support),
            policy: outer_seed.policy,
            _pad: [0; 3],
        };
        accepted = accepted.saturating_add(report.accepted);
        phase_two_mutations = phase_two_mutations.saturating_add(report.phase_two_mutations);
        let replace = best.as_ref().map_or(true, |current| {
            (report.best_score_components[0], report.best_score)
                < (current.best_score_components[0], current.best_score)
        });
        if replace {
            best = Some(report);
        }
        remaining -= mutations;
    }
    let mut best = best.ok_or(Q29InventoryError::EmptySamplingDomain)?;
    best.mutations = total_mutations;
    best.accepted = accepted;
    best.phase_two_mutations = phase_two_mutations;
    best.provenance = "ObservedEvolved; bounded multi-scope exact outer-profile reseeds; direct shell replay; misses have no authority";
    Ok(best)
}

fn evolve_order6_margin_shell_inner<const PARITY_SHELL: bool>(
    seed: u64,
    mutations: u64,
) -> Order6MarginEvolveReport {
    let mut random = seed;
    let q29_state = if PARITY_SHELL {
        Q29PhaseState::seeded_parity_shell(&mut random)
    } else {
        Q29PhaseState::seeded_exact(&mut random)
    };
    evolve_order6_margin_shell_from_state::<PARITY_SHELL>(seed, mutations, random, q29_state)
}

fn evolve_order6_margin_shell_from_state<const PARITY_SHELL: bool>(
    seed: u64,
    mutations: u64,
    mut random: u64,
    mut q29_state: Q29PhaseState,
) -> Order6MarginEvolveReport {
    let initial =
        Order6MarginEvolveState::from_counts(lift_q29_values(&q29_state.values, &mut random));
    let mut q29_best = q29_state;
    let mut state = initial;
    let mut best = initial;
    let mut phase_two = false;
    let mut phase_two_mutations = 0_u64;
    let mut best_metric = q29_state.score;
    let mut accepted = 0_u64;
    for mutation in 0..mutations {
        if PARITY_SHELL && !phase_two && mutation != 0 && mutation & 0x3ffff == 0 {
            q29_state = Q29PhaseState::seeded_parity_shell(&mut random);
            if q29_state.score < best_metric {
                best_metric = q29_state.score;
                q29_best = q29_state;
            }
        }
        let block = (next_random(&mut random) as usize) & 3;
        let (from, to) = if phase_two {
            phase_two_mutations += 1;
            let column = (next_random(&mut random) as usize) % COLUMNS;
            let from_class = (next_random(&mut random) as usize) % CLASSES;
            let mut to_class = (next_random(&mut random) as usize) % (CLASSES - 1);
            if to_class >= from_class {
                to_class += 1;
            }
            (crt_index(from_class, column), crt_index(to_class, column))
        } else {
            let from = (next_random(&mut random) as usize) % Q29;
            let mut to = (next_random(&mut random) as usize) % (Q29 - 1);
            if to >= from {
                to += 1;
            }
            (from, to)
        };
        if phase_two && (state.counts[block][from] == 0 || state.counts[block][to] == 3) {
            continue;
        }
        if !phase_two
            && (q29_state.values[block][from] == q29_state.values[block][to]
                || (PARITY_SHELL
                    && ((q29_state.values[block][from] / 2) ^ (q29_state.values[block][to] / 2))
                        & 1
                        != 0))
        {
            continue;
        }
        let old_components = if phase_two {
            state.score_components()
        } else {
            [0; 4]
        };
        let old_metric = if phase_two {
            old_components[1] + old_components[2] + old_components[3]
        } else {
            q29_state.score
        };
        if phase_two {
            state.apply_transfer(block, from, to);
        } else {
            q29_state.apply_swap(block, from, to);
            debug_assert_eq!(q29_state.combined_paf[0], 2_020);
        }
        let new_components = if phase_two {
            state.score_components()
        } else {
            [0; 4]
        };
        let new_metric = if phase_two {
            new_components[1] + new_components[2] + new_components[3]
        } else {
            q29_state.score
        };
        let worse = new_metric.saturating_sub(old_metric);
        let phase = mutation & 0xffff;
        let temperature = if phase_two {
            8_192_u64.saturating_sub(phase >> 3).max(8)
        } else {
            1_024_u64.saturating_sub(phase >> 6).max(1)
        };
        let accept = new_metric <= old_metric
            || next_random(&mut random) % temperature.saturating_add(worse) < temperature;
        if accept {
            accepted += 1;
            if new_metric < best_metric {
                best_metric = new_metric;
                if phase_two {
                    best = state;
                } else {
                    q29_best = q29_state;
                }
            }
            if !phase_two && new_metric == 0 {
                phase_two = true;
                state = Order6MarginEvolveState::from_counts(lift_q29_values(
                    &q29_state.values,
                    &mut random,
                ));
                best = state;
                let components = state.score_components();
                best_metric = components[1] + components[2] + components[3];
            } else if phase_two && best_metric == 0 {
                debug_assert_eq!(best.score, 0);
                if best.score == 0 {
                    break;
                }
            }
        } else {
            if phase_two {
                state.apply_transfer(block, to, from);
                debug_assert_eq!(state.score_components(), old_components);
            } else {
                q29_state.apply_swap(block, to, from);
                debug_assert_eq!(q29_state.score, old_metric);
            }
        }
    }
    if !phase_two {
        if q29_best.score <= 4_096 && repair_q29_with_two_distinct_block_moves(&mut q29_best) {
            phase_two = true;
        }
        best = Order6MarginEvolveState::from_counts(lift_q29_values(&q29_best.values, &mut random));
    }
    Order6MarginEvolveReport {
        seed,
        mutations,
        accepted,
        best_score: best.score,
        best_score_components: best.score_components(),
        q29_shell_hit: phase_two,
        phase_two_mutations,
        exact_shell_hit: best.score == 0,
        best_counts: best.counts,
        best_q29: best.q29,
        best_q58: best.q58,
        best_q87: best.q87,
        provenance:
            "ObservedEvolved; exact shell hits require direct replay; misses have no authority",
    }
}

fn parity_supports(random: &mut u64) -> [u32; BLOCKS] {
    // A two-point support has one nonzero cyclic-difference bit.  Thus it is
    // enough to sample the other three supports until their XOR signature is
    // a singleton; the final support is then constructed, not guessed.
    for _ in 0..1_000_000 {
        let d0 = random_subset::<3>(random);
        let d1 = random_subset::<4>(random);
        let d2 = random_subset::<4>(random);
        let needed = parity_signature(d0) ^ parity_signature(d1) ^ parity_signature(d2);
        if needed.count_ones() == 1 {
            let distance = needed.trailing_zeros() as usize + 1;
            let origin = (next_random(random) as usize) % Q29;
            let d3 = (1_u32 << origin) | (1_u32 << ((origin + distance) % Q29));
            debug_assert_eq!(parity_signature(d3), needed);
            return [d0, d1, d2, d3];
        }
    }
    panic!("bounded parity-shell seed search exhausted")
}

fn random_subset<const SIZE: usize>(random: &mut u64) -> u32 {
    let mut support = 0_u32;
    while support.count_ones() < SIZE as u32 {
        support |= 1_u32 << ((next_random(random) as usize) % Q29);
    }
    support
}

fn parity_signature(support: u32) -> u16 {
    crate::q29_parity_support::cyclic_autocorrelation_parity(support) >> 1
}

fn combined_parity_signature(values: &[[i8; Q29]; BLOCKS]) -> u16 {
    values.iter().fold(0_u16, |signature, row| {
        let support = row
            .iter()
            .enumerate()
            .fold(0_u32, |bits, (column, &value)| {
                bits | (u32::from(((value / 2) & 1) != 0) << column)
            });
        signature ^ parity_signature(support)
    })
}

fn shuffle_prefix<const LEN: usize>(values: &mut [u8; LEN], len: usize, random: &mut u64) {
    for tail in (1..len).rev() {
        let swap = (next_random(random) as usize) % (tail + 1);
        values.swap(tail, swap);
    }
}

fn repair_q29_with_two_distinct_block_moves(state: &mut Q29PhaseState) -> bool {
    if state.score == 0 {
        return true;
    }
    let mut moves = [Q29MoveDelta::ZERO; Q29_MOVES];
    let mut move_count = 0;
    for block in 0..BLOCKS {
        for from in 0..Q29 {
            if state.values[block][from] == -18 {
                continue;
            }
            for to in 0..Q29 {
                if from == to || state.values[block][to] == 18 {
                    continue;
                }
                let mut child = *state;
                child.apply_transfer(block, from, to);
                let mut delta = [0_i16; Q29_SHIFTS - 1];
                for shift in 1..Q29_SHIFTS {
                    delta[shift - 1] =
                        (child.combined_paf[shift] - state.combined_paf[shift]) as i16;
                }
                moves[move_count] = Q29MoveDelta {
                    delta,
                    block: block as u8,
                    from: from as u8,
                    to: to as u8,
                    _padding: 0,
                };
                move_count += 1;
            }
        }
    }
    for left_index in 0..move_count {
        let left = moves[left_index];
        for right in &moves[left_index + 1..move_count] {
            if left.block == right.block {
                continue;
            }
            let mut matches = true;
            for shift in 1..Q29_SHIFTS {
                let residual = -72 - state.combined_paf[shift];
                if i32::from(left.delta[shift - 1]) + i32::from(right.delta[shift - 1]) != residual
                {
                    matches = false;
                    break;
                }
            }
            if matches {
                state.apply_transfer(
                    usize::from(left.block),
                    usize::from(left.from),
                    usize::from(left.to),
                );
                state.apply_transfer(
                    usize::from(right.block),
                    usize::from(right.from),
                    usize::from(right.to),
                );
                if state.score == 0 {
                    return true;
                }
                state.apply_transfer(
                    usize::from(right.block),
                    usize::from(right.to),
                    usize::from(right.from),
                );
                state.apply_transfer(
                    usize::from(left.block),
                    usize::from(left.to),
                    usize::from(left.from),
                );
            }
        }
    }
    false
}

/// Exhaust the complete radius-three neighborhood whose transfers touch three
/// distinct blocks.  This is an exact statement only about that neighborhood;
/// a miss has no global search authority.
#[must_use]
pub fn repair_q29_three_distinct_exact(
    values: [[i8; Q29]; BLOCKS],
    workspace: &mut Order6Q29ThreeMoveWorkspace,
) -> Option<[[i8; Q29]; BLOCKS]> {
    let mut state = Q29PhaseState::from_values(values);
    if state.score == 0 {
        return Some(values);
    }
    let mut moves = [[Q29MoveDelta::ZERO; Q29_BLOCK_MOVES]; BLOCKS];
    let mut lengths = [0_usize; BLOCKS];
    for block in 0..BLOCKS {
        for from in 0..Q29 {
            if state.values[block][from] == -18 {
                continue;
            }
            for to in 0..Q29 {
                if from == to || state.values[block][to] == 18 {
                    continue;
                }
                let mut child = state;
                child.apply_transfer(block, from, to);
                let mut delta = [0_i16; Q29_SHIFTS - 1];
                for shift in 1..Q29_SHIFTS {
                    delta[shift - 1] =
                        (child.combined_paf[shift] - state.combined_paf[shift]) as i16;
                }
                moves[block][lengths[block]] = Q29MoveDelta {
                    delta,
                    block: block as u8,
                    from: from as u8,
                    to: to as u8,
                    _padding: 0,
                };
                lengths[block] += 1;
            }
        }
    }
    let residual: [i16; Q29_SHIFTS - 1] =
        std::array::from_fn(|index| (-72 - state.combined_paf[index + 1]) as i16);
    const TRIPLES: [[usize; 3]; 4] = [[0, 1, 2], [0, 1, 3], [0, 2, 3], [1, 2, 3]];
    for blocks in TRIPLES {
        workspace.pairs.clear();
        for (left_index, left) in moves[blocks[0]][..lengths[blocks[0]]].iter().enumerate() {
            for (right_index, right) in moves[blocks[1]][..lengths[blocks[1]]].iter().enumerate() {
                workspace.pairs.push(Q29PairDelta {
                    delta: std::array::from_fn(|index| left.delta[index] + right.delta[index]),
                    left: left_index as u16,
                    right: right_index as u16,
                });
            }
        }
        debug_assert!(workspace.pairs.len() <= Q29_PAIR_MOVES);
        workspace.pairs.sort_unstable();
        for third in &moves[blocks[2]][..lengths[blocks[2]]] {
            let desired: [i16; Q29_SHIFTS - 1] =
                std::array::from_fn(|index| residual[index] - third.delta[index]);
            let mut pair_index = workspace.pairs.partition_point(|pair| pair.delta < desired);
            while pair_index < workspace.pairs.len() && workspace.pairs[pair_index].delta == desired
            {
                let pair = workspace.pairs[pair_index];
                let left = moves[blocks[0]][usize::from(pair.left)];
                let right = moves[blocks[1]][usize::from(pair.right)];
                for movement in [left, right, *third] {
                    state.apply_transfer(
                        usize::from(movement.block),
                        usize::from(movement.from),
                        usize::from(movement.to),
                    );
                }
                if state.score == 0 {
                    return Some(state.values);
                }
                for movement in [*third, right, left] {
                    state.apply_transfer(
                        usize::from(movement.block),
                        usize::from(movement.to),
                        usize::from(movement.from),
                    );
                }
                pair_index += 1;
            }
        }
    }
    None
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Order6Q29RepairError {
    InputOutOfDomain,
    WorkspaceCapacity,
}

#[inline(always)]
fn pack_q29_move(from: usize, to: usize) -> u32 {
    (from as u32) | ((to as u32) << 5)
}

#[inline(always)]
fn q29_delta_from_paf(
    base: &[i32; Q29_SHIFTS],
    child: &[i32; Q29_SHIFTS],
) -> [i16; Q29_SHIFTS - 1] {
    std::array::from_fn(|index| {
        let delta = child[index + 1] - base[index + 1];
        debug_assert!((-608..=608).contains(&delta));
        delta as i16
    })
}

fn compile_q29_radius_two_block(
    root: &[i8; Q29],
    singles: &mut [Q29LocalDelta; Q29_BLOCK_MOVES],
    doubles: &mut Vec<Q29LocalDelta>,
) -> Result<usize, Order6Q29RepairError> {
    let base_paf = direct_paf::<1, Q29, Q29_SHIFTS>(root);
    let mut single_count = 0;
    doubles.clear();
    for first_from in 0..Q29 {
        if root[first_from] == -18 {
            continue;
        }
        for first_to in 0..Q29 {
            if first_from == first_to || root[first_to] == 18 {
                continue;
            }
            let mut first_row = *root;
            let mut first_paf = base_paf;
            let mut first_combined = base_paf;
            update_view::<1, Q29, Q29_SHIFTS>(
                &mut first_row,
                &mut first_paf,
                &mut first_combined,
                first_from,
                first_to,
            );
            let first_code = pack_q29_move(first_from, first_to);
            singles[single_count] = Q29LocalDelta {
                delta: q29_delta_from_paf(&base_paf, &first_paf),
                moves: first_code,
            };
            single_count += 1;
            for second_from in 0..Q29 {
                if first_row[second_from] == -18 {
                    continue;
                }
                for second_to in 0..Q29 {
                    if second_from == second_to || first_row[second_to] == 18 {
                        continue;
                    }
                    if doubles.len() == doubles.capacity() {
                        return Err(Order6Q29RepairError::WorkspaceCapacity);
                    }
                    let mut second_row = first_row;
                    let mut second_paf = first_paf;
                    let mut second_combined = first_paf;
                    update_view::<1, Q29, Q29_SHIFTS>(
                        &mut second_row,
                        &mut second_paf,
                        &mut second_combined,
                        second_from,
                        second_to,
                    );
                    doubles.push(Q29LocalDelta {
                        delta: q29_delta_from_paf(&base_paf, &second_paf),
                        moves: first_code | (pack_q29_move(second_from, second_to) << 10),
                    });
                }
            }
        }
    }
    doubles.sort_unstable();
    Ok(single_count)
}

#[inline(always)]
fn q29_exact_delta_hash(delta: &[i16; 16]) -> usize {
    let mut hash = 0x9e37_79b9_7f4a_7c15_u64;
    for &value in delta {
        hash ^= u64::from(value as u16).wrapping_add(0x9e37_79b9);
        hash = hash.rotate_left(13).wrapping_mul(0xbf58_476d_1ce4_e5b9);
    }
    hash as usize
}

fn compile_q29_exact_double_table(
    row: &[i8; Q29],
    workspace: &mut Order6Q29TripleDoubleWorkspace,
) -> Result<(), Order6Q29RepairError> {
    let mut singles = [Q29LocalDelta {
        delta: [0; Q29_SHIFTS - 1],
        moves: 0,
    }; Q29_BLOCK_MOVES];
    compile_q29_radius_two_block(row, &mut singles, &mut workspace.raw_doubles)?;
    workspace.exact_deltas.clear();
    workspace.slots.fill(0);
    let root_energy = row
        .iter()
        .map(|&value| i32::from(value) * i32::from(value))
        .sum::<i32>();
    for local in &workspace.raw_doubles {
        let mut child = *row;
        if !apply_q29_packed_moves(&mut child, local.moves, 2) {
            return Err(Order6Q29RepairError::InputOutOfDomain);
        }
        let child_energy = child
            .iter()
            .map(|&value| i32::from(value) * i32::from(value))
            .sum::<i32>();
        let mut exact = [0_i16; 16];
        exact[0] = (child_energy - root_energy) as i16;
        exact[1..Q29_SHIFTS].copy_from_slice(&local.delta);
        let index = workspace.exact_deltas.len();
        workspace.exact_deltas.push(exact);
        let mut slot = q29_exact_delta_hash(&exact) & (Q29_TRIPLE_DOUBLE_TT_SLOTS - 1);
        loop {
            let stored = workspace.slots[slot];
            if stored == 0 {
                workspace.slots[slot] = index as u32 + 1;
                break;
            }
            if workspace.exact_deltas[stored as usize - 1] == exact {
                break;
            }
            slot = (slot + 1) & (Q29_TRIPLE_DOUBLE_TT_SLOTS - 1);
        }
    }
    Ok(())
}

#[inline(always)]
fn lookup_q29_exact_double(
    desired: &[i16; 16],
    workspace: &Order6Q29TripleDoubleWorkspace,
) -> Option<u32> {
    let mut slot = q29_exact_delta_hash(desired) & (Q29_TRIPLE_DOUBLE_TT_SLOTS - 1);
    loop {
        let stored = workspace.slots[slot];
        if stored == 0 {
            return None;
        }
        let index = stored as usize - 1;
        if workspace.exact_deltas[index] == *desired {
            return Some(workspace.raw_doubles[index].moves);
        }
        slot = (slot + 1) & (Q29_TRIPLE_DOUBLE_TT_SLOTS - 1);
    }
}

#[inline(always)]
fn q29_matching_range(values: &[Q29LocalDelta], desired: [i16; Q29_SHIFTS - 1]) -> (usize, usize) {
    let start = values.partition_point(|value| value.delta < desired);
    let end = start + values[start..].partition_point(|value| value.delta == desired);
    (start, end)
}

#[inline(always)]
fn q29_residual_minus(
    residual: &[i16; Q29_SHIFTS - 1],
    left: &[i16; Q29_SHIFTS - 1],
) -> [i16; Q29_SHIFTS - 1] {
    std::array::from_fn(|index| residual[index] - left[index])
}

#[inline(always)]
fn q29_residual_minus_two(
    residual: &[i16; Q29_SHIFTS - 1],
    left: &[i16; Q29_SHIFTS - 1],
    right: &[i16; Q29_SHIFTS - 1],
) -> [i16; Q29_SHIFTS - 1] {
    std::array::from_fn(|index| residual[index] - left[index] - right[index])
}

fn fill_q29_pair_singles(
    left: &[Q29LocalDelta],
    right: &[Q29LocalDelta],
    output: &mut Vec<Q29LocalDelta>,
) -> Result<(), Order6Q29RepairError> {
    output.clear();
    for left_move in left {
        for right_move in right {
            if output.len() == output.capacity() {
                return Err(Order6Q29RepairError::WorkspaceCapacity);
            }
            output.push(Q29LocalDelta {
                delta: std::array::from_fn(|index| {
                    left_move.delta[index] + right_move.delta[index]
                }),
                moves: left_move.moves | (right_move.moves << 10),
            });
        }
    }
    output.sort_unstable();
    Ok(())
}

#[inline(always)]
fn apply_q29_packed_moves(row: &mut [i8; Q29], packed: u32, count: usize) -> bool {
    for movement in 0..count {
        let code = packed >> (10 * movement);
        let from = (code & 31) as usize;
        let to = ((code >> 5) & 31) as usize;
        if from >= Q29 || to >= Q29 || from == to || row[from] == -18 || row[to] == 18 {
            return false;
        }
        row[from] -= 2;
        row[to] += 2;
    }
    true
}

fn replay_q29_local_candidate(
    root: &[[i8; Q29]; BLOCKS],
    choices: &[Q29ChosenLocal],
) -> Option<[[i8; Q29]; BLOCKS]> {
    let mut child = *root;
    for choice in choices {
        if !apply_q29_packed_moves(
            &mut child[usize::from(choice.block)],
            choice.moves,
            usize::from(choice.count),
        ) {
            return None;
        }
    }
    let replay = Q29PhaseState::from_values(child);
    (replay.score == 0).then_some(child)
}

#[inline(always)]
fn chosen(block: usize, count: usize, moves: u32) -> Q29ChosenLocal {
    Q29ChosenLocal {
        moves,
        block: block as u8,
        count: count as u8,
        _padding: [0; 2],
    }
}

/// Exhaust the complete transfer neighborhood of total radius at most four
/// subject to at most two transfers in any one row.  A same-row two-transfer
/// delta is compiled by applying both transfers sequentially to that row;
/// additive composition is used only across distinct rows.  Every apparent
/// hit is independently replayed by recomputing all four full q29 PAFs.
pub fn repair_q29_radius_four_at_most_two_per_block_exact(
    values: [[i8; Q29]; BLOCKS],
    workspace: &mut Order6Q29RadiusFourWorkspace,
) -> Result<Option<[[i8; Q29]; BLOCKS]>, Order6Q29RepairError> {
    const ROW_SUMS: [i32; BLOCKS] = [2, 0, 0, 0];
    for block in 0..BLOCKS {
        if values[block]
            .iter()
            .any(|&value| !(-18..=18).contains(&value) || value & 1 != 0)
            || values[block]
                .iter()
                .map(|&value| i32::from(value))
                .sum::<i32>()
                != ROW_SUMS[block]
        {
            return Err(Order6Q29RepairError::InputOutOfDomain);
        }
    }
    let root = Q29PhaseState::from_values(values);
    if root.score == 0 {
        return Ok(Some(values));
    }
    let residual: [i16; Q29_SHIFTS - 1] =
        std::array::from_fn(|index| (-72 - root.combined_paf[index + 1]) as i16);
    let mut singles = [[Q29LocalDelta {
        delta: [0; Q29_SHIFTS - 1],
        moves: 0,
    }; Q29_BLOCK_MOVES]; BLOCKS];
    let mut single_lengths = [0_usize; BLOCKS];
    for block in 0..BLOCKS {
        single_lengths[block] = compile_q29_radius_two_block(
            &root.values[block],
            &mut singles[block],
            &mut workspace.doubles[block],
        )?;
    }

    // Radius one and same-row radius two.
    for block in 0..BLOCKS {
        for movement in &singles[block][..single_lengths[block]] {
            if movement.delta == residual {
                if let Some(hit) =
                    replay_q29_local_candidate(&values, &[chosen(block, 1, movement.moves)])
                {
                    return Ok(Some(hit));
                }
            }
        }
        let (start, end) = q29_matching_range(&workspace.doubles[block], residual);
        for movement in &workspace.doubles[block][start..end] {
            if let Some(hit) =
                replay_q29_local_candidate(&values, &[chosen(block, 2, movement.moves)])
            {
                return Ok(Some(hit));
            }
        }
    }

    // Two distinct single moves; also retain each sorted pair for the
    // three-single and 2+1+1 cases below.
    for left_block in 0..BLOCKS {
        for right_block in left_block + 1..BLOCKS {
            fill_q29_pair_singles(
                &singles[left_block][..single_lengths[left_block]],
                &singles[right_block][..single_lengths[right_block]],
                &mut workspace.pair_singles,
            )?;
            let (start, end) = q29_matching_range(&workspace.pair_singles, residual);
            for pair in &workspace.pair_singles[start..end] {
                let choices = [
                    chosen(left_block, 1, pair.moves & 0x3ff),
                    chosen(right_block, 1, pair.moves >> 10),
                ];
                if let Some(hit) = replay_q29_local_candidate(&values, &choices) {
                    return Ok(Some(hit));
                }
            }
        }
    }

    // Same-row radius two plus one move in a distinct row.
    for double_block in 0..BLOCKS {
        let doubles = &workspace.doubles[double_block];
        for single_block in 0..BLOCKS {
            if single_block == double_block {
                continue;
            }
            for single in &singles[single_block][..single_lengths[single_block]] {
                let desired = q29_residual_minus(&residual, &single.delta);
                let (start, end) = q29_matching_range(doubles, desired);
                for double in &doubles[start..end] {
                    let choices = [
                        chosen(double_block, 2, double.moves),
                        chosen(single_block, 1, single.moves),
                    ];
                    if let Some(hit) = replay_q29_local_candidate(&values, &choices) {
                        return Ok(Some(hit));
                    }
                }
            }
        }
    }

    // Three distinct single moves.
    for omitted in 0..BLOCKS {
        let blocks: [usize; 3] = {
            let mut result = [0; 3];
            let mut cursor = 0;
            for block in 0..BLOCKS {
                if block != omitted {
                    result[cursor] = block;
                    cursor += 1;
                }
            }
            result
        };
        fill_q29_pair_singles(
            &singles[blocks[0]][..single_lengths[blocks[0]]],
            &singles[blocks[1]][..single_lengths[blocks[1]]],
            &mut workspace.pair_singles,
        )?;
        for third in &singles[blocks[2]][..single_lengths[blocks[2]]] {
            let desired = q29_residual_minus(&residual, &third.delta);
            let (start, end) = q29_matching_range(&workspace.pair_singles, desired);
            for pair in &workspace.pair_singles[start..end] {
                let choices = [
                    chosen(blocks[0], 1, pair.moves & 0x3ff),
                    chosen(blocks[1], 1, pair.moves >> 10),
                    chosen(blocks[2], 1, third.moves),
                ];
                if let Some(hit) = replay_q29_local_candidate(&values, &choices) {
                    return Ok(Some(hit));
                }
            }
        }
    }

    // Two same-row radius-two alternatives in distinct rows.
    for left_block in 0..BLOCKS {
        for right_block in left_block + 1..BLOCKS {
            let left = &workspace.doubles[left_block];
            let right = &workspace.doubles[right_block];
            for right_move in right {
                let desired = q29_residual_minus(&residual, &right_move.delta);
                let (start, end) = q29_matching_range(left, desired);
                for left_move in &left[start..end] {
                    let choices = [
                        chosen(left_block, 2, left_move.moves),
                        chosen(right_block, 2, right_move.moves),
                    ];
                    if let Some(hit) = replay_q29_local_candidate(&values, &choices) {
                        return Ok(Some(hit));
                    }
                }
            }
        }
    }

    // Same-row radius two plus two singles in two other rows.
    for double_block in 0..BLOCKS {
        for first_single_block in 0..BLOCKS {
            if first_single_block == double_block {
                continue;
            }
            for second_single_block in first_single_block + 1..BLOCKS {
                if second_single_block == double_block {
                    continue;
                }
                fill_q29_pair_singles(
                    &singles[first_single_block][..single_lengths[first_single_block]],
                    &singles[second_single_block][..single_lengths[second_single_block]],
                    &mut workspace.pair_singles,
                )?;
                for double in &workspace.doubles[double_block] {
                    let desired = q29_residual_minus(&residual, &double.delta);
                    let (start, end) = q29_matching_range(&workspace.pair_singles, desired);
                    for pair in &workspace.pair_singles[start..end] {
                        let choices = [
                            chosen(double_block, 2, double.moves),
                            chosen(first_single_block, 1, pair.moves & 0x3ff),
                            chosen(second_single_block, 1, pair.moves >> 10),
                        ];
                        if let Some(hit) = replay_q29_local_candidate(&values, &choices) {
                            return Ok(Some(hit));
                        }
                    }
                }
            }
        }
    }

    // Four distinct singles.
    fill_q29_pair_singles(
        &singles[0][..single_lengths[0]],
        &singles[1][..single_lengths[1]],
        &mut workspace.pair_singles,
    )?;
    for third in &singles[2][..single_lengths[2]] {
        for fourth in &singles[3][..single_lengths[3]] {
            let desired = q29_residual_minus_two(&residual, &third.delta, &fourth.delta);
            let (start, end) = q29_matching_range(&workspace.pair_singles, desired);
            for pair in &workspace.pair_singles[start..end] {
                let choices = [
                    chosen(0, 1, pair.moves & 0x3ff),
                    chosen(1, 1, pair.moves >> 10),
                    chosen(2, 1, third.moves),
                    chosen(3, 1, fourth.moves),
                ];
                if let Some(hit) = replay_q29_local_candidate(&values, &choices) {
                    return Ok(Some(hit));
                }
            }
        }
    }
    Ok(None)
}

#[inline(always)]
fn q29_sparse_paf_delta_at_shift(root: &[i8; Q29], delta: &[i8; Q29], shift: usize) -> i16 {
    let mut value = 0_i32;
    for position in 0..Q29 {
        let change = i32::from(delta[position]);
        if change != 0 {
            let forward = (position + shift) % Q29;
            let backward = (position + Q29 - shift) % Q29;
            value += change
                * (i32::from(root[forward])
                    + i32::from(root[backward])
                    + i32::from(delta[forward]));
        }
    }
    debug_assert!(i16::try_from(value).is_ok());
    value as i16
}

#[inline(always)]
fn q29_sparse_paf_delta(root: &[i8; Q29], delta: &[i8; Q29]) -> [i16; Q29_SHIFTS - 1] {
    std::array::from_fn(|index| q29_sparse_paf_delta_at_shift(root, delta, index + 1))
}

#[inline(always)]
fn q29_triple_paf_delta_at_shift(
    root: &[i8; Q29],
    delta: &[i8; Q29],
    donors: Q29TripleMultiset,
    recipients: Q29TripleMultiset,
    shift: usize,
) -> i16 {
    let mut value = 0_i32;
    let donor_positions = donors.positions;
    let recipient_positions = recipients.positions;
    for (&position, direction) in donor_positions
        .iter()
        .zip([-2_i32; 3])
        .chain(recipient_positions.iter().zip([2_i32; 3]))
    {
        let position = usize::from(position);
        let forward = (position + shift) % Q29;
        let backward = (position + Q29 - shift) % Q29;
        value += direction
            * (i32::from(root[forward]) + i32::from(root[backward]) + i32::from(delta[forward]));
    }
    debug_assert!(i16::try_from(value).is_ok());
    value as i16
}

#[inline(always)]
fn q29_triple_paf_delta(
    root: &[i8; Q29],
    delta: &[i8; Q29],
    donors: Q29TripleMultiset,
    recipients: Q29TripleMultiset,
) -> [i16; Q29_SHIFTS - 1] {
    std::array::from_fn(|index| {
        q29_triple_paf_delta_at_shift(root, delta, donors, recipients, index + 1)
    })
}

fn compile_q29_single_block_sparse(
    root: &[i8; Q29],
    singles: &mut [Q29LocalDelta; Q29_BLOCK_MOVES],
) -> usize {
    let mut count = 0;
    for from in 0..Q29 {
        if root[from] == -18 {
            continue;
        }
        for to in 0..Q29 {
            if from == to || root[to] == 18 {
                continue;
            }
            let mut delta = [0_i8; Q29];
            delta[from] = -2;
            delta[to] = 2;
            singles[count] = Q29LocalDelta {
                delta: q29_sparse_paf_delta(root, &delta),
                moves: pack_q29_move(from, to),
            };
            count += 1;
        }
    }
    singles[..count].sort_unstable();
    count
}

#[cfg(test)]
fn q29_row_power_moments(root: &[i8; Q29]) -> [i32; 5] {
    let mut moments = [0_i32; 5];
    for (position, &twice_value) in root.iter().enumerate() {
        let value = i32::from(twice_value) / 2;
        let mut power = 1_i32;
        for moment in &mut moments {
            *moment = (*moment + value * power).rem_euclid(Q29 as i32);
            power = (power * position as i32).rem_euclid(Q29 as i32);
        }
    }
    moments
}

#[inline(always)]
fn q29_even_moment_delta_from_power_delta(
    root_moments: &[i32; 5],
    power_delta: [i32; 4],
) -> Q29EvenMomentDelta {
    let [d1, d2, d3, d4] = power_delta;
    let second =
        (2 * root_moments[0] * d2 - 4 * root_moments[1] * d1 - 2 * d1 * d1).rem_euclid(Q29 as i32);
    let fourth = (2 * root_moments[0] * d4
        - 8 * (root_moments[1] * d3 + root_moments[3] * d1 + d1 * d3)
        + 12 * root_moments[2] * d2
        + 6 * d2 * d2)
        .rem_euclid(Q29 as i32);
    Q29EvenMomentDelta {
        second: second as u8,
        fourth: fourth as u8,
    }
}

#[inline(always)]
fn q29_triple_even_moment_delta(
    root_moments: &[i32; 5],
    donors: Q29TripleMultiset,
    recipients: Q29TripleMultiset,
) -> Q29EvenMomentDelta {
    q29_even_moment_delta_from_power_delta(
        root_moments,
        std::array::from_fn(|power| {
            (i32::from(recipients.power_sums[power]) - i32::from(donors.power_sums[power]))
                .rem_euclid(Q29 as i32)
        }),
    )
}

#[inline(always)]
fn q29_single_even_moment_delta(
    root_moments: &[i32; 5],
    movement: Q29LocalDelta,
) -> Q29EvenMomentDelta {
    let from = (movement.moves & 31) as usize;
    let to = ((movement.moves >> 5) & 31) as usize;
    q29_even_moment_delta_from_power_delta(
        root_moments,
        std::array::from_fn(|power| {
            (q29_mod_power(to, power + 1) - q29_mod_power(from, power + 1)).rem_euclid(Q29 as i32)
        }),
    )
}

#[inline(always)]
fn q29_moment_index(signature: Q29EvenMomentDelta) -> usize {
    usize::from(signature.second) * Q29 + usize::from(signature.fourth)
}

#[inline(always)]
fn q29_pattern_fits(root: &[i8; Q29], pattern: Q29TripleMultiset, direction: i8) -> bool {
    let positions = pattern.positions;
    let mut cursor = 0;
    while cursor < positions.len() {
        let position = usize::from(positions[cursor]);
        let mut multiplicity = 1;
        while cursor + multiplicity < positions.len()
            && positions[cursor + multiplicity] == positions[cursor]
        {
            multiplicity += 1;
        }
        let value = root[position] + direction * 2 * multiplicity as i8;
        if !(-18..=18).contains(&value) {
            return false;
        }
        cursor += multiplicity;
    }
    true
}

#[inline(always)]
fn q29_patterns_disjoint(left: Q29TripleMultiset, right: Q29TripleMultiset) -> bool {
    for &left_position in &left.positions {
        for &right_position in &right.positions {
            if left_position == right_position {
                return false;
            }
        }
    }
    true
}

#[cfg(test)]
#[inline(always)]
fn q29_triple_delta(
    root: &[i8; Q29],
    donors: Q29TripleMultiset,
    recipients: Q29TripleMultiset,
    delta: &mut [i8; Q29],
) -> [i16; Q29_SHIFTS - 1] {
    *delta = [0; Q29];
    for &position in &donors.positions {
        delta[usize::from(position)] -= 2;
    }
    for &position in &recipients.positions {
        delta[usize::from(position)] += 2;
    }
    q29_triple_paf_delta(root, delta, donors, recipients)
}

#[inline(always)]
fn q29_triple_moves(donors: Q29TripleMultiset, recipients: Q29TripleMultiset) -> u32 {
    let donor_positions = donors.positions;
    let recipient_positions = recipients.positions;
    pack_q29_move(
        usize::from(donor_positions[0]),
        usize::from(recipient_positions[0]),
    ) | (pack_q29_move(
        usize::from(donor_positions[1]),
        usize::from(recipient_positions[1]),
    ) << 10)
        | (pack_q29_move(
            usize::from(donor_positions[2]),
            usize::from(recipient_positions[2]),
        ) << 20)
}

/// Exhaust the previously uncovered exact-radius-three neighborhood in one
/// row, both alone and with one transfer in a distinct row.  A radius-three
/// row is represented by disjoint donor and recipient size-three multisets;
/// this is the unique net-change representation after cancelling transfers,
/// so it covers every minimal three-transfer row without enumerating path
/// permutations.  Cross-row deltas are additive.  Every apparent hit is
/// independently replayed from the original rows and all q29 PAFs are
/// recomputed.
pub fn repair_q29_triple_block_plus_one_exact(
    values: [[i8; Q29]; BLOCKS],
    workspace: &Order6Q29TripleBlockWorkspace,
) -> Result<Option<[[i8; Q29]; BLOCKS]>, Order6Q29RepairError> {
    const ROW_SUMS: [i32; BLOCKS] = [2, 0, 0, 0];
    for block in 0..BLOCKS {
        if values[block]
            .iter()
            .any(|&value| !(-18..=18).contains(&value) || value & 1 != 0)
            || values[block]
                .iter()
                .map(|&value| i32::from(value))
                .sum::<i32>()
                != ROW_SUMS[block]
        {
            return Err(Order6Q29RepairError::InputOutOfDomain);
        }
    }
    let root = Q29PhaseState::from_values(values);
    if root.score == 0 {
        return Ok(Some(values));
    }
    let residual: [i16; Q29_SHIFTS - 1] =
        std::array::from_fn(|index| (-72 - root.combined_paf[index + 1]) as i16);
    let mut singles = [[Q29LocalDelta {
        delta: [0; Q29_SHIFTS - 1],
        moves: 0,
    }; Q29_BLOCK_MOVES]; BLOCKS];
    let mut single_lengths = [0_usize; BLOCKS];
    for block in 0..BLOCKS {
        single_lengths[block] =
            compile_q29_single_block_sparse(&root.values[block], &mut singles[block]);
    }
    let half_values = root.values.map(|row| row.map(|value| value / 2));
    let canonical_moments = crate::q29_even_moment_proof::extract_q29_even_moments(&half_values)
        .map_err(|_| Order6Q29RepairError::InputOutOfDomain)?;
    let row_moments = std::array::from_fn::<_, BLOCKS, _>(|block| {
        let mut result = [0_i32; 5];
        result[0] = i32::from(ROW_SUMS[block] as i8 / 2);
        for degree in 1..=4 {
            result[degree] = i32::from(
                canonical_moments
                    .row_moment(block, degree)
                    .expect("fixed in-range canonical q29 moment"),
            );
        }
        result
    });
    let required_moments = Q29EvenMomentDelta {
        second: (Q29 as u8 - canonical_moments.t2()) % Q29 as u8,
        fourth: (Q29 as u8 - canonical_moments.t4()) % Q29 as u8,
    };

    // A cheap exact first-coordinate image avoids constructing thirteen more
    // PAF coordinates for triple deltas that cannot be completed by zero or
    // one move outside this row.
    const FIRST_BOUND: i32 = 2_048;
    let mut permitted_first = [false; (2 * FIRST_BOUND + 1) as usize];
    let mark_first = |value: i32, image: &mut [bool; (2 * FIRST_BOUND + 1) as usize]| {
        if (-FIRST_BOUND..=FIRST_BOUND).contains(&value) {
            image[(value + FIRST_BOUND) as usize] = true;
        }
    };
    let mut sparse_delta = [0_i8; Q29];
    let mut permitted_moments = [false; Q29 * Q29];
    for triple_block in 0..BLOCKS {
        permitted_first.fill(false);
        permitted_moments.fill(false);
        mark_first(i32::from(residual[0]), &mut permitted_first);
        permitted_moments[q29_moment_index(required_moments)] = true;
        for single_block in 0..BLOCKS {
            if single_block == triple_block {
                continue;
            }
            for single in &singles[single_block][..single_lengths[single_block]] {
                mark_first(
                    i32::from(residual[0]) - i32::from(single.delta[0]),
                    &mut permitted_first,
                );
                let single_moments =
                    q29_single_even_moment_delta(&row_moments[single_block], *single);
                permitted_moments[q29_moment_index(Q29EvenMomentDelta {
                    second: (required_moments.second + Q29 as u8 - single_moments.second)
                        % Q29 as u8,
                    fourth: (required_moments.fourth + Q29 as u8 - single_moments.fourth)
                        % Q29 as u8,
                })] = true;
            }
        }
        let row = &root.values[triple_block];
        for &donors in &workspace.patterns {
            if !q29_pattern_fits(row, donors, -1) {
                continue;
            }
            for &recipients in &workspace.patterns {
                if !q29_patterns_disjoint(donors, recipients)
                    || !q29_pattern_fits(row, recipients, 1)
                {
                    continue;
                }
                sparse_delta.fill(0);
                for &position in &donors.positions {
                    sparse_delta[usize::from(position)] -= 2;
                }
                for &position in &recipients.positions {
                    sparse_delta[usize::from(position)] += 2;
                }
                let triple_moments =
                    q29_triple_even_moment_delta(&row_moments[triple_block], donors, recipients);
                if !permitted_moments[q29_moment_index(triple_moments)] {
                    continue;
                }
                let first =
                    q29_triple_paf_delta_at_shift(row, &sparse_delta, donors, recipients, 1);
                let first_index = i32::from(first) + FIRST_BOUND;
                if !(0..=2 * FIRST_BOUND).contains(&first_index)
                    || !permitted_first[first_index as usize]
                {
                    continue;
                }
                let triple_delta = q29_triple_paf_delta(row, &sparse_delta, donors, recipients);
                let moves = q29_triple_moves(donors, recipients);
                if triple_delta == residual {
                    if let Some(hit) =
                        replay_q29_local_candidate(&values, &[chosen(triple_block, 3, moves)])
                    {
                        return Ok(Some(hit));
                    }
                }
                for single_block in 0..BLOCKS {
                    if single_block == triple_block {
                        continue;
                    }
                    let desired = q29_residual_minus(&residual, &triple_delta);
                    let (start, end) = q29_matching_range(
                        &singles[single_block][..single_lengths[single_block]],
                        desired,
                    );
                    for single in &singles[single_block][start..end] {
                        let choices = [
                            chosen(triple_block, 3, moves),
                            chosen(single_block, 1, single.moves),
                        ];
                        if let Some(hit) = replay_q29_local_candidate(&values, &choices) {
                            return Ok(Some(hit));
                        }
                    }
                }
            }
        }
    }
    Ok(None)
}

/// Exhaust the exact radius-five slice consisting of three minimal transfers
/// in one row and two sequential transfers in a distinct row.  The double
/// side is an exact PAF tablebase whose key includes the energy coordinate;
/// retaining one preimage per identical full key is therefore sound.
pub fn repair_q29_triple_plus_double_exact(
    values: [[i8; Q29]; BLOCKS],
    workspace: &mut Order6Q29TripleDoubleWorkspace,
) -> Result<Option<[[i8; Q29]; BLOCKS]>, Order6Q29RepairError> {
    const ROW_SUMS: [i32; BLOCKS] = [2, 0, 0, 0];
    for block in 0..BLOCKS {
        if values[block]
            .iter()
            .any(|&value| !(-18..=18).contains(&value) || value & 1 != 0)
            || values[block]
                .iter()
                .map(|&value| i32::from(value))
                .sum::<i32>()
                != ROW_SUMS[block]
        {
            return Err(Order6Q29RepairError::InputOutOfDomain);
        }
    }
    let root = Q29PhaseState::from_values(values);
    if root.score == 0 {
        return Ok(Some(values));
    }
    let residual: [i16; 16] = std::array::from_fn(|index| match index {
        0 => (2_020 - root.combined_paf[0]) as i16,
        1..Q29_SHIFTS => (-72 - root.combined_paf[index]) as i16,
        _ => 0,
    });
    let mut sparse_delta = [0_i8; Q29];
    for double_block in 0..BLOCKS {
        compile_q29_exact_double_table(&root.values[double_block], workspace)?;
        for triple_block in 0..BLOCKS {
            if triple_block == double_block {
                continue;
            }
            let row = &root.values[triple_block];
            for donor_index in 0..workspace.patterns.len() {
                let donors = workspace.patterns[donor_index];
                if !q29_pattern_fits(row, donors, -1) {
                    continue;
                }
                for recipient_index in 0..workspace.patterns.len() {
                    let recipients = workspace.patterns[recipient_index];
                    if !q29_patterns_disjoint(donors, recipients)
                        || !q29_pattern_fits(row, recipients, 1)
                    {
                        continue;
                    }
                    sparse_delta.fill(0);
                    for &position in &donors.positions {
                        sparse_delta[usize::from(position)] -= 2;
                    }
                    for &position in &recipients.positions {
                        sparse_delta[usize::from(position)] += 2;
                    }
                    let energy_delta = row
                        .iter()
                        .zip(&sparse_delta)
                        .map(|(&value, &delta)| {
                            2 * i32::from(value) * i32::from(delta)
                                + i32::from(delta) * i32::from(delta)
                        })
                        .sum::<i32>();
                    let triple_delta = q29_triple_paf_delta(row, &sparse_delta, donors, recipients);
                    let mut desired = [0_i16; 16];
                    desired[0] = residual[0] - energy_delta as i16;
                    for shift in 1..Q29_SHIFTS {
                        desired[shift] = residual[shift] - triple_delta[shift - 1];
                    }
                    let Some(double_moves) = lookup_q29_exact_double(&desired, workspace) else {
                        continue;
                    };
                    let triple_moves = q29_triple_moves(donors, recipients);
                    if let Some(hit) = replay_q29_local_candidate(
                        &values,
                        &[
                            chosen(triple_block, 3, triple_moves),
                            chosen(double_block, 2, double_moves),
                        ],
                    ) {
                        return Ok(Some(hit));
                    }
                }
            }
        }
    }
    Ok(None)
}

fn lift_q29_values(values: &[[i8; Q29]; BLOCKS], random: &mut u64) -> [[u8; CELLS]; BLOCKS] {
    let mut counts = [[0_u8; CELLS]; BLOCKS];
    for block in 0..BLOCKS {
        for column in 0..COLUMNS {
            let units = ((i16::from(values[block][column]) + 18) / 2) as usize;
            let mut slots = std::array::from_fn::<_, 18, _>(|slot| slot as u8);
            for tail in (1..18).rev() {
                let swap = (next_random(random) as usize) % (tail + 1);
                slots.swap(tail, swap);
            }
            for &slot in &slots[..units] {
                counts[block][crt_index(usize::from(slot / 3), column)] += 1;
            }
        }
    }
    counts
}

#[inline(always)]
fn crt_index(class: usize, column: usize) -> usize {
    column + COLUMNS * ((column + CLASSES - class) % CLASSES)
}

fn swap_view<const ROWS: usize, const LEN: usize, const SHIFTS: usize>(
    values: &mut [i8; LEN],
    block_paf: &mut [i32; SHIFTS],
    combined_paf: &mut [i32; SHIFTS],
    from: usize,
    to: usize,
) {
    let old_from = values[from];
    let old_to = values[to];
    values.swap(from, to);
    for shift in 0..SHIFTS {
        let (row_shift, column_shift) = canonical_shift::<ROWS>(shift);
        let predecessor = |index: usize| {
            let row = index / COLUMNS;
            let column = index % COLUMNS;
            ((row + ROWS - row_shift) % ROWS) * COLUMNS
                + (column + COLUMNS - column_shift) % COLUMNS
        };
        let candidates = [from, to, predecessor(from), predecessor(to)];
        let mut delta = 0_i32;
        for (slot, &point) in candidates.iter().enumerate() {
            if candidates[..slot].contains(&point) {
                continue;
            }
            let successor = ((point / COLUMNS + row_shift) % ROWS) * COLUMNS
                + (point % COLUMNS + column_shift) % COLUMNS;
            let before = |index: usize| {
                if index == from {
                    old_from
                } else if index == to {
                    old_to
                } else {
                    values[index]
                }
            };
            delta += i32::from(values[point]) * i32::from(values[successor])
                - i32::from(before(point)) * i32::from(before(successor));
        }
        block_paf[shift] += delta;
        combined_paf[shift] += delta;
    }
}

fn update_view<const ROWS: usize, const LEN: usize, const SHIFTS: usize>(
    values: &mut [i8; LEN],
    block_paf: &mut [i32; SHIFTS],
    combined_paf: &mut [i32; SHIFTS],
    from: usize,
    to: usize,
) {
    if from == to {
        return;
    }
    let old_from = values[from];
    let old_to = values[to];
    values[from] -= 2;
    values[to] += 2;
    for shift in 0..SHIFTS {
        let (row_shift, column_shift) = canonical_shift::<ROWS>(shift);
        let predecessor = |index: usize| {
            let row = index / COLUMNS;
            let column = index % COLUMNS;
            ((row + ROWS - row_shift) % ROWS) * COLUMNS
                + (column + COLUMNS - column_shift) % COLUMNS
        };
        let candidates = [from, to, predecessor(from), predecessor(to)];
        let mut delta = 0_i32;
        for (slot, &point) in candidates.iter().enumerate() {
            if candidates[..slot].contains(&point) {
                continue;
            }
            let successor = ((point / COLUMNS + row_shift) % ROWS) * COLUMNS
                + (point % COLUMNS + column_shift) % COLUMNS;
            let before = |index: usize| {
                if index == from {
                    old_from
                } else if index == to {
                    old_to
                } else {
                    values[index]
                }
            };
            delta += i32::from(values[point]) * i32::from(values[successor])
                - i32::from(before(point)) * i32::from(before(successor));
        }
        block_paf[shift] += delta;
        combined_paf[shift] += delta;
    }
}

fn direct_paf<const ROWS: usize, const LEN: usize, const SHIFTS: usize>(
    values: &[i8; LEN],
) -> [i32; SHIFTS] {
    std::array::from_fn(|shift| {
        let (row_shift, column_shift) = canonical_shift::<ROWS>(shift);
        (0..LEN)
            .map(|point| {
                let successor = ((point / COLUMNS + row_shift) % ROWS) * COLUMNS
                    + (point % COLUMNS + column_shift) % COLUMNS;
                i32::from(values[point]) * i32::from(values[successor])
            })
            .sum()
    })
}

#[inline(always)]
fn canonical_shift<const ROWS: usize>(slot: usize) -> (usize, usize) {
    if ROWS == 1 {
        (0, slot)
    } else if ROWS == 2 {
        (slot / 15, slot % 15)
    } else if slot < 15 {
        (0, slot)
    } else {
        (1, slot - 15)
    }
}

fn squared_target_error(values: &[i32], zero: i32, off_zero: i32) -> u64 {
    values
        .iter()
        .enumerate()
        .map(|(shift, &value)| {
            u64::from((value - if shift == 0 { zero } else { off_zero }).unsigned_abs()).pow(2)
        })
        .sum()
}

#[inline(always)]
fn next_random(state: &mut u64) -> u64 {
    *state ^= *state << 7;
    *state ^= *state >> 9;
    *state ^= *state << 8;
    *state
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn incremental_views_match_full_recomputation() {
        let mut state = Order6MarginEvolveState::seeded(0x1234_5678_9abc_def0);
        let mut random = 0xfedc_ba98_7654_3210;
        for _ in 0..2_048 {
            let block = (next_random(&mut random) as usize) & 3;
            let from = (next_random(&mut random) as usize) % CELLS;
            let to = (next_random(&mut random) as usize) % CELLS;
            if from == to || state.counts[block][from] == 0 || state.counts[block][to] == 3 {
                continue;
            }
            state.apply_transfer(block, from, to);
            let replay = Order6MarginEvolveState::from_counts(state.counts);
            assert_eq!(state.q29, replay.q29);
            assert_eq!(state.q58, replay.q58);
            assert_eq!(state.q87, replay.q87);
            assert_eq!(state.block_q29_paf, replay.block_q29_paf);
            assert_eq!(state.block_q58_paf, replay.block_q58_paf);
            assert_eq!(state.block_q87_paf, replay.block_q87_paf);
            assert_eq!(state.score, replay.score);
        }
    }

    #[test]
    fn mutation_loop_allocates_nothing() {
        let (_, allocations) = tracked_allocations(|| {
            let report = evolve_order6_margin_shell(0x1020_3040_5060_7080, 10_000);
            assert!(report.best_score > 0 || report.exact_shell_hit);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn outer_profile_seed_replays_and_mutates_without_allocating() {
        let mut workspace = Q29InventoryWorkspace::new();
        crate::q29_inventory_scope::census_q29_inventory_scopes(&mut workspace).unwrap();
        for epoch in 0..3 {
            let (report, allocations) = tracked_allocations(|| {
                evolve_order6_margin_shell_outer(
                    &mut workspace,
                    0x8f3d_1c2b_4a59_6877 ^ epoch,
                    10_000,
                    epoch,
                )
                .unwrap()
            });
            assert_eq!(allocations, 0);
            let mut y = [[0_i8; Q29]; BLOCKS];
            for block in 0..BLOCKS {
                for column in 0..Q29 {
                    assert_eq!(report.best_q29[block][column] & 1, 0);
                    y[block][column] = report.best_q29[block][column] / 2;
                }
            }
            crate::q29_inventory_scope::extract_q29_inventories(&y).unwrap();
        }
    }

    #[test]
    fn outer_epoch_coordinator_reseeds_scopes_off_hot_path() {
        let mut workspace = Q29InventoryWorkspace::new();
        crate::q29_inventory_scope::census_q29_inventory_scopes(&mut workspace).unwrap();
        let mut too_short = [Q29OuterEpochStat::ZERO; 2];
        assert_eq!(
            evolve_order6_margin_shell_outer_epochs(
                &mut workspace,
                7,
                30_000,
                10_000,
                &mut too_short,
            ),
            Err(Q29InventoryError::InsufficientOutputCapacity)
        );
        let mut statistics = [Q29OuterEpochStat::ZERO; 3];
        let (report, allocations) = tracked_allocations(|| {
            evolve_order6_margin_shell_outer_epochs(
                &mut workspace,
                0x1319_8a2e_0370_7344,
                30_000,
                10_000,
                &mut statistics,
            )
            .unwrap()
        });
        assert_eq!(allocations, 0);
        assert_eq!(report.mutations, 30_000);
        assert_eq!(
            statistics.map(|statistic| statistic.policy),
            [
                Q29OuterProfilePolicy::UniformScope,
                Q29OuterProfilePolicy::MagnitudeMultiplicity,
                Q29OuterProfilePolicy::Novelty,
            ]
        );
        assert!(statistics
            .windows(2)
            .any(|pair| pair[0].energies != pair[1].energies
                || pair[0].odd_supports != pair[1].odd_supports));
        let mut y = [[0_i8; Q29]; BLOCKS];
        for block in 0..BLOCKS {
            for column in 0..Q29 {
                y[block][column] = report.best_q29[block][column] / 2;
            }
        }
        crate::q29_inventory_scope::extract_q29_inventories(&y).unwrap();
        let direct = Q29PhaseState::from_values(report.best_q29);
        assert_eq!(direct.score, report.best_score_components[0]);
    }

    #[test]
    fn aggregate_q29_phase_matches_direct_recomputation() {
        let mut seed = 0x3141_5926_5358_9793;
        let mut state = Q29PhaseState::seeded_exact(&mut seed);
        assert_eq!(state.combined_paf[0], 2_020);
        assert_eq!(
            state
                .values
                .map(|row| row.iter().map(|&x| i32::from(x)).sum::<i32>()),
            [2, 0, 0, 0]
        );
        let mut random = 0x2718_2818_2845_9045;
        for _ in 0..2_048 {
            let block = (next_random(&mut random) as usize) & 3;
            let from = (next_random(&mut random) as usize) % Q29;
            let to = (next_random(&mut random) as usize) % Q29;
            if from == to || state.values[block][from] == state.values[block][to] {
                continue;
            }
            state.apply_swap(block, from, to);
            let replay = Q29PhaseState::from_values(state.values);
            assert_eq!(state.block_paf, replay.block_paf);
            assert_eq!(state.combined_paf, replay.combined_paf);
            assert_eq!(state.score, replay.score);
        }
    }

    #[test]
    fn every_bounded_q29_value_lifts_exactly() {
        let mut values = [[0_i8; Q29]; BLOCKS];
        for block_values in &mut values {
            for (column, value) in block_values.iter_mut().enumerate() {
                *value = -18 + 2 * (column % 19) as i8;
            }
        }
        let mut random = 0x0123_4567_89ab_cdef;
        let lifted = Order6MarginEvolveState::from_counts(lift_q29_values(&values, &mut random));
        assert_eq!(lifted.q29, values);
    }

    #[test]
    fn distinct_block_transfer_deltas_add_exactly() {
        let mut random = 0x9e37_79b9_7f4a_7c15;
        let state = Q29PhaseState::seeded_exact(&mut random);
        let mut left = state;
        left.apply_transfer(0, 0, 1);
        let mut right = state;
        right.apply_transfer(1, 2, 3);
        let mut joint = state;
        joint.apply_transfer(0, 0, 1);
        joint.apply_transfer(1, 2, 3);
        for shift in 0..Q29_SHIFTS {
            assert_eq!(
                joint.combined_paf[shift] - state.combined_paf[shift],
                left.combined_paf[shift] + right.combined_paf[shift]
                    - 2 * state.combined_paf[shift]
            );
        }
    }

    #[test]
    fn crt_index_is_the_unique_six_by_twenty_nine_coordinate() {
        let mut seen = [false; CELLS];
        for class in 0..CLASSES {
            for column in 0..COLUMNS {
                let index = crt_index(class, column);
                assert_eq!(index % CLASSES, class);
                assert_eq!(index % COLUMNS, column);
                assert!(!seen[index]);
                seen[index] = true;
            }
        }
        assert!(seen.iter().all(|&value| value));
    }

    #[test]
    fn parity_shell_seed_has_exact_support_sizes_and_group_ring_identity() {
        let mut random = 0x6a09_e667_f3bc_c909;
        for _ in 0..256 {
            let state = Q29PhaseState::seeded_parity_shell(&mut random);
            let sizes = state
                .values
                .map(|row| row.iter().filter(|&&value| ((value / 2) & 1) != 0).count());
            assert_eq!(sizes, [3, 4, 4, 2]);
            assert_eq!(combined_parity_signature(&state.values), 0);
            for shift in 1..Q29_SHIFTS {
                assert_eq!((state.combined_paf[shift] / 4 + 18) & 1, 0);
            }
        }
    }

    #[test]
    fn parity_preserving_swaps_keep_group_ring_identity() {
        let mut random = 0xbb67_ae85_84ca_a73b;
        let mut state = Q29PhaseState::seeded_parity_shell(&mut random);
        for _ in 0..8_192 {
            let block = (next_random(&mut random) as usize) & 3;
            let from = (next_random(&mut random) as usize) % Q29;
            let to = (next_random(&mut random) as usize) % Q29;
            if from == to
                || ((state.values[block][from] / 2) ^ (state.values[block][to] / 2)) & 1 != 0
            {
                continue;
            }
            state.apply_swap(block, from, to);
            assert_eq!(combined_parity_signature(&state.values), 0);
        }
    }

    #[test]
    fn exact_three_block_workspace_is_bounded_and_kernel_allocates_nothing() {
        let mut random = 0x3c6e_f372_fe94_f82b;
        let state = Q29PhaseState::seeded_exact(&mut random);
        let mut workspace = Order6Q29ThreeMoveWorkspace::new();
        assert_eq!(workspace.bytes(), 21_099_008);
        let (result, allocations) =
            tracked_allocations(|| repair_q29_three_distinct_exact(state.values, &mut workspace));
        assert_eq!(allocations, 0);
        if let Some(values) = result {
            assert_eq!(Q29PhaseState::from_values(values).score, 0);
        }
    }

    #[test]
    fn same_block_two_move_delta_is_sequential_not_additive() {
        let root = [0_i8; Q29];
        let base = direct_paf::<1, Q29, Q29_SHIFTS>(&root);
        let mut first = root;
        first[0] -= 2;
        first[1] += 2;
        let first_paf = direct_paf::<1, Q29, Q29_SHIFTS>(&first);
        let mut second_alone = root;
        second_alone[1] -= 2;
        second_alone[2] += 2;
        let second_paf = direct_paf::<1, Q29, Q29_SHIFTS>(&second_alone);
        let mut joint = first;
        joint[1] -= 2;
        joint[2] += 2;
        let joint_paf = direct_paf::<1, Q29, Q29_SHIFTS>(&joint);
        assert!((1..Q29_SHIFTS).any(|shift| {
            joint_paf[shift] - base[shift] != first_paf[shift] + second_paf[shift] - 2 * base[shift]
        }));

        let mut singles = [Q29LocalDelta {
            delta: [0; Q29_SHIFTS - 1],
            moves: 0,
        }; Q29_BLOCK_MOVES];
        let mut doubles = Vec::with_capacity(Q29_PAIR_MOVES);
        compile_q29_radius_two_block(&root, &mut singles, &mut doubles).unwrap();
        let packed = pack_q29_move(0, 1) | (pack_q29_move(1, 2) << 10);
        let compiled = doubles.iter().find(|entry| entry.moves == packed).unwrap();
        assert_eq!(compiled.delta, q29_delta_from_paf(&base, &joint_paf));
    }

    #[test]
    fn radius_four_workspace_is_bounded_and_block_compiler_allocates_nothing() {
        let mut workspace = Order6Q29RadiusFourWorkspace::new();
        assert_eq!(workspace.bytes(), 105_495_040);
        let root = [0_i8; Q29];
        let mut singles = [Q29LocalDelta {
            delta: [0; Q29_SHIFTS - 1],
            moves: 0,
        }; Q29_BLOCK_MOVES];
        let (single_count, allocations) = tracked_allocations(|| {
            compile_q29_radius_two_block(&root, &mut singles, &mut workspace.doubles[0]).unwrap()
        });
        assert_eq!(single_count, Q29_BLOCK_MOVES);
        assert_eq!(workspace.doubles[0].len(), Q29_PAIR_MOVES);
        assert_eq!(allocations, 0);
    }

    #[test]
    fn radius_four_repair_fails_closed_outside_domain() {
        let mut workspace = Order6Q29RadiusFourWorkspace::new();
        let mut invalid = [[0_i8; Q29]; BLOCKS];
        invalid[0][0] = 1;
        assert_eq!(
            repair_q29_radius_four_at_most_two_per_block_exact(invalid, &mut workspace),
            Err(Order6Q29RepairError::InputOutOfDomain)
        );
    }

    #[test]
    fn triple_multisets_are_complete_and_canonical() {
        let workspace = Order6Q29TripleBlockWorkspace::new();
        assert_eq!(workspace.patterns.len(), Q29_TRIPLE_MULTISETS);
        assert_eq!(workspace.bytes(), Q29_TRIPLE_MULTISETS * 8);
        assert_eq!(workspace.patterns[0].positions, [0, 0, 0]);
        assert_eq!(
            workspace.patterns[Q29_TRIPLE_MULTISETS - 1].positions,
            [28, 28, 28]
        );
        for pair in workspace.patterns.windows(2) {
            assert!(pair[0].positions < pair[1].positions);
        }
    }

    #[test]
    fn sparse_triple_delta_matches_independent_direct_paf() {
        let workspace = Order6Q29TripleBlockWorkspace::new();
        let mut random = 0x243f_6a88_85a3_08d3;
        let mut checked = 0;
        while checked < 2_048 {
            let mut root = [0_i8; Q29];
            for value in &mut root {
                *value = 2 * ((next_random(&mut random) % 15) as i8 - 7);
            }
            let donors =
                workspace.patterns[(next_random(&mut random) as usize) % workspace.patterns.len()];
            let recipients =
                workspace.patterns[(next_random(&mut random) as usize) % workspace.patterns.len()];
            if !q29_patterns_disjoint(donors, recipients)
                || !q29_pattern_fits(&root, donors, -1)
                || !q29_pattern_fits(&root, recipients, 1)
            {
                continue;
            }
            let mut sparse = [0_i8; Q29];
            let derived = q29_triple_delta(&root, donors, recipients, &mut sparse);
            let mut child = root;
            assert!(apply_q29_packed_moves(
                &mut child,
                q29_triple_moves(donors, recipients),
                3
            ));
            let base_paf = direct_paf::<1, Q29, Q29_SHIFTS>(&root);
            let child_paf = direct_paf::<1, Q29, Q29_SHIFTS>(&child);
            assert_eq!(derived, q29_delta_from_paf(&base_paf, &child_paf));
            checked += 1;
        }
    }

    #[test]
    fn even_moment_formula_matches_direct_cyclic_sum() {
        let mut random = 0x1319_8a2e_0370_7344;
        for _ in 0..1_024 {
            let mut row = [0_i8; Q29];
            for value in &mut row {
                *value = 2 * ((next_random(&mut random) % 15) as i8 - 7);
            }
            let moments = q29_row_power_moments(&row);
            let derived = Q29EvenMomentDelta {
                second: (2 * moments[0] * moments[2] - 2 * moments[1] * moments[1])
                    .rem_euclid(Q29 as i32) as u8,
                fourth: (2 * moments[0] * moments[4] - 8 * moments[1] * moments[3]
                    + 6 * moments[2] * moments[2])
                    .rem_euclid(Q29 as i32) as u8,
            };
            let paf = direct_paf::<1, Q29, Q29_SHIFTS>(&row);
            let mut direct = Q29EvenMomentDelta {
                second: 0,
                fourth: 0,
            };
            for shift in 1..Q29_SHIFTS {
                let half_scale_paf = paf[shift] / 4;
                direct.second = (i32::from(direct.second)
                    + 2 * q29_mod_power(shift, 2) * half_scale_paf)
                    .rem_euclid(Q29 as i32) as u8;
                direct.fourth = (i32::from(direct.fourth)
                    + 2 * q29_mod_power(shift, 4) * half_scale_paf)
                    .rem_euclid(Q29 as i32) as u8;
            }
            assert_eq!(derived, direct);
        }
    }

    #[test]
    fn triple_inner_kernel_allocates_nothing() {
        let workspace = Order6Q29TripleBlockWorkspace::new();
        let root = [0_i8; Q29];
        let (_, allocations) = tracked_allocations(|| {
            let mut checksum = 0_i64;
            let mut sparse = [0_i8; Q29];
            for &donors in &workspace.patterns[..128] {
                for &recipients in &workspace.patterns[..128] {
                    if q29_patterns_disjoint(donors, recipients) {
                        let delta = q29_triple_delta(
                            std::hint::black_box(&root),
                            donors,
                            recipients,
                            &mut sparse,
                        );
                        checksum += i64::from(delta[0]);
                    }
                }
            }
            std::hint::black_box(checksum)
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn triple_repair_fails_closed_outside_domain() {
        let workspace = Order6Q29TripleBlockWorkspace::new();
        let mut invalid = [[0_i8; Q29]; BLOCKS];
        invalid[0][0] = 1;
        assert_eq!(
            repair_q29_triple_block_plus_one_exact(invalid, &workspace),
            Err(Order6Q29RepairError::InputOutOfDomain)
        );
    }

    #[test]
    fn exact_double_table_retains_full_keys_without_allocation() {
        let mut workspace = Order6Q29TripleDoubleWorkspace::new();
        let row = [0_i8; Q29];
        let (_, allocations) = tracked_allocations(|| {
            compile_q29_exact_double_table(&row, &mut workspace).unwrap();
        });
        assert_eq!(allocations, 0);
        assert!(!workspace.exact_deltas.is_empty());
        for &key in workspace.exact_deltas.iter().step_by(257) {
            let moves = lookup_q29_exact_double(&key, &workspace).unwrap();
            let mut child = row;
            assert!(apply_q29_packed_moves(&mut child, moves, 2));
            let base = direct_paf::<1, Q29, Q29_SHIFTS>(&row);
            let changed = direct_paf::<1, Q29, Q29_SHIFTS>(&child);
            assert_eq!(key[0], (changed[0] - base[0]) as i16);
            assert_eq!(&key[1..Q29_SHIFTS], &q29_delta_from_paf(&base, &changed));
        }
    }

    #[test]
    fn triple_plus_double_repair_fails_closed_outside_domain() {
        let mut workspace = Order6Q29TripleDoubleWorkspace::new();
        let mut invalid = [[0_i8; Q29]; BLOCKS];
        invalid[0][0] = 1;
        assert_eq!(
            repair_q29_triple_plus_double_exact(invalid, &mut workspace),
            Err(Order6Q29RepairError::InputOutOfDomain)
        );
    }

    #[test]
    fn retained_root_triple_plus_double_is_exact_and_allocation_free() {
        let half = crate::q29_even_moment_proof::retained_q29_y6_root();
        let values = half.map(|row| row.map(|value| value * 2));
        let mut workspace = Order6Q29TripleDoubleWorkspace::new();
        let (result, allocations) = tracked_allocations(|| {
            repair_q29_triple_plus_double_exact(values, &mut workspace).unwrap()
        });
        assert_eq!(allocations, 0);
        assert!(result.is_none());
    }
}
