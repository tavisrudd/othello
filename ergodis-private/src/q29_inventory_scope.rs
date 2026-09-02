//! Exact magnitude-inventory scope for the unrestricted q29 shell.
//!
//! Write each even q29 coefficient as `x_j = 2 y_j`.  A canonical row has
//! 29 entries in `[-9, 9]`, signed sum zero (or one for block zero), and the
//! four row energies sum to 505.  The search seed's odd-support tuple
//! `(3, 4, 4, 2)` is only one scope.  This module enumerates every realizable
//! per-row `(energy, odd support)` scope and counts the underlying unsigned
//! magnitude inventories without assuming that tuple.
//!
//! A magnitude inventory is admitted only when an exact bounded subset-sum
//! replay constructs signs with the required row sum.  The replay uses a
//! `u128` bitset: Cauchy--Schwarz bounds the total magnitude by
//! `floor(sqrt(29 * 505)) = 121`.  Enumeration is an explicit nine-frame
//! odometer; there is no recursion and no allocation after workspace setup.

pub const Q29_ROW_LENGTH: usize = 29;
pub const Q29_MAX_MAGNITUDE: usize = 9;
pub const Q29_TOTAL_ENERGY: usize = 505;
pub const Q29_SUPPORT_VALUES: usize = 30;
const ROW_KINDS: usize = 2;
const ENERGY_VALUES: usize = Q29_TOTAL_ENERGY + 1;
const ROW_TABLE_LEN: usize = ROW_KINDS * Q29_SUPPORT_VALUES * ENERGY_VALUES;
const PAIR_ENERGY_WORDS: usize = ENERGY_VALUES.div_ceil(64);
const SUPPORT_PAIRS: usize = Q29_SUPPORT_VALUES * Q29_SUPPORT_VALUES;
const PAIR_MASK_LEN: usize = 2 * SUPPORT_PAIRS * PAIR_ENERGY_WORDS;
const SUFFIX_TABLE_LEN: usize = 5 * ENERGY_VALUES;
pub const Q29_INVENTORY_WORKSPACE_BYTES: usize = (ROW_TABLE_LEN + PAIR_MASK_LEN)
    * core::mem::size_of::<u64>()
    + ROW_TABLE_LEN * core::mem::size_of::<u32>()
    + SUFFIX_TABLE_LEN * core::mem::size_of::<u128>();

pub const Q29_INVENTORY_PROVENANCE: &str =
    "ExactComputational: exhaustive unsigned magnitude odometer; exact u128 subset-sum sign replay; canonical q29/energy-505 semantics";

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29InventoryError {
    CoefficientOutOfRange,
    WrongRowSum,
    WrongCombinedEnergy,
    ArithmeticOverflow,
    UncompiledWorkspace,
    EmptySamplingDomain,
    InsufficientOutputCapacity,
}

/// Canonical, directly extracted row inventory.  No feature name or supplied
/// metadata participates in extraction.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29RowInventory {
    pub magnitude_counts: [u8; 10],
    pub energy: u16,
    pub signed_sum: i16,
    pub odd_support: u8,
    pub _pad: u8,
}

const _: () = assert!(core::mem::size_of::<Q29RowInventory>() == 16);
const _: () = assert!(core::mem::align_of::<Q29RowInventory>() == 2);

/// Opaque outer-profile coordinate for evolve.  A generic sampler can mix
/// uniform-over-scope, inventory-weighted, and inverse-frequency draws using
/// this record without knowing q29 theorem names or a preferred support mask.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29MagnitudeScope {
    pub magnitude_inventory_count: u64,
    pub energy: u16,
    pub odd_support: u8,
    pub signed_sum: i8,
    pub _pad: [u8; 4],
}

const _: () = assert!(core::mem::size_of::<Q29MagnitudeScope>() == 16);
const _: () = assert!(core::mem::align_of::<Q29MagnitudeScope>() == 8);

/// Generic scope-learning observation.  The visit count is search policy
/// state only and has no proof authority.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29VisitedScope {
    pub scope: Q29MagnitudeScope,
    pub visits: u32,
    pub _pad: [u8; 12],
}

const _: () = assert!(core::mem::size_of::<Q29VisitedScope>() == 32);
const _: () = assert!(core::mem::align_of::<Q29VisitedScope>() == 8);

#[repr(u8)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29OuterProfilePolicy {
    UniformScope = 0,
    MagnitudeMultiplicity = 1,
    Novelty = 2,
}

/// A cold-generated exact starting point.  The 192-byte shape can be copied
/// once into a worker-local hot state; sampling and bookkeeping stay outside
/// the mutation loop.
#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29OuterProfileSeed {
    pub scopes: [Q29MagnitudeScope; 4],
    pub rows: [[i8; Q29_ROW_LENGTH]; 4],
    pub policy: Q29OuterProfilePolicy,
    pub _pad: [u8; 11],
}

const _: () = assert!(core::mem::size_of::<Q29OuterProfileSeed>() == 192);
const _: () = assert!(core::mem::align_of::<Q29OuterProfileSeed>() == 64);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29InventoryCensus {
    pub sum_zero_magnitude_inventories: u64,
    pub sum_one_magnitude_inventories: u64,
    pub sum_zero_energy_support_scopes: u16,
    pub sum_one_energy_support_scopes: u16,
    pub feasible_ordered_odd_support_scopes: u32,
    pub all_energy_505_magnitude_quartets: u128,
    pub support_3_4_4_2_magnitude_quartets: u128,
    pub seed_energy_support_scope_magnitude_quartets: u128,
    pub exact_seed_inventory_quartets: u8,
    pub workspace_bytes: u32,
    pub provenance: &'static str,
}

/// Cold owner of the fixed-size tables used by the allocation-free kernels.
/// The boxed slices are allocated and length-checked once in `new`.
pub struct Q29InventoryWorkspace {
    row_counts: Box<[u64]>,
    pair_energy_masks: Box<[u64]>,
    scope_visits: Box<[u32]>,
    suffix_ways: Box<[u128]>,
}

impl Q29InventoryWorkspace {
    #[must_use]
    pub fn new() -> Self {
        Self {
            row_counts: vec![0_u64; ROW_TABLE_LEN].into_boxed_slice(),
            pair_energy_masks: vec![0_u64; PAIR_MASK_LEN].into_boxed_slice(),
            scope_visits: vec![0_u32; ROW_TABLE_LEN].into_boxed_slice(),
            suffix_ways: vec![0_u128; SUFFIX_TABLE_LEN].into_boxed_slice(),
        }
    }

    #[must_use]
    pub fn magnitude_inventory_count(
        &self,
        signed_sum: i16,
        energy: usize,
        odd_support: usize,
    ) -> u64 {
        let kind = match signed_sum {
            0 => 0,
            1 => 1,
            _ => return 0,
        };
        if energy > Q29_TOTAL_ENERGY || odd_support >= Q29_SUPPORT_VALUES {
            return 0;
        }
        self.row_counts[row_index(kind, energy, odd_support)]
    }
}

/// Rotate the three admitted discovery policies without a branch in the
/// subsequent evolve mutation loop.
pub fn sample_rotating_q29_outer_profile_seed(
    workspace: &mut Q29InventoryWorkspace,
    random: &mut u64,
    epoch: u64,
) -> Result<Q29OuterProfileSeed, Q29InventoryError> {
    let policy = match epoch % 3 {
        0 => Q29OuterProfilePolicy::UniformScope,
        1 => Q29OuterProfilePolicy::MagnitudeMultiplicity,
        _ => Q29OuterProfilePolicy::Novelty,
    };
    sample_q29_outer_profile_seed(workspace, random, policy)
}

/// Sample four exact row profiles whose energies sum to 505, reconstruct one
/// valid sign pattern per exactly unranked magnitude inventory, and randomly
/// place the resulting signed values.  All allocations belong to setup.
pub fn sample_q29_outer_profile_seed(
    workspace: &mut Q29InventoryWorkspace,
    random: &mut u64,
    policy: Q29OuterProfilePolicy,
) -> Result<Q29OuterProfileSeed, Q29InventoryError> {
    if total_row_inventories(&workspace.row_counts, 1) == 0 {
        return Err(Q29InventoryError::UncompiledWorkspace);
    }
    compile_suffix_ways(workspace, policy)?;
    let total = workspace.suffix_ways[suffix_index(0, Q29_TOTAL_ENERGY)];
    if total == 0 {
        return Err(Q29InventoryError::EmptySamplingDomain);
    }

    let mut remaining_energy = Q29_TOTAL_ENERGY;
    let mut scopes = [Q29MagnitudeScope {
        magnitude_inventory_count: 0,
        energy: 0,
        odd_support: 0,
        signed_sum: 0,
        _pad: [0; 4],
    }; 4];
    let mut selected_indices = [0_usize; 4];
    let mut inventory_ranks = [0_u64; 4];
    for row in 0..4 {
        let kind = usize::from(row == 0);
        let mut rank = sample_below(
            random,
            workspace.suffix_ways[suffix_index(row, remaining_energy)],
        );
        let mut selected = false;
        'scope: for odd_support in 0..Q29_SUPPORT_VALUES {
            for energy in 0..=remaining_energy {
                let index = row_index(kind, energy, odd_support);
                let count = workspace.row_counts[index];
                if count == 0 {
                    continue;
                }
                let weight = scope_weight(policy, count, workspace.scope_visits[index]);
                let contribution = weight
                    .checked_mul(
                        workspace.suffix_ways[suffix_index(row + 1, remaining_energy - energy)],
                    )
                    .ok_or(Q29InventoryError::ArithmeticOverflow)?;
                if rank < contribution {
                    scopes[row] = Q29MagnitudeScope {
                        magnitude_inventory_count: count,
                        energy: energy as u16,
                        odd_support: odd_support as u8,
                        signed_sum: i8::from(row == 0),
                        _pad: [0; 4],
                    };
                    selected_indices[row] = index;
                    inventory_ranks[row] = sample_below(random, u128::from(count)) as u64;
                    remaining_energy -= energy;
                    selected = true;
                    break 'scope;
                }
                rank -= contribution;
            }
        }
        if !selected {
            return Err(Q29InventoryError::EmptySamplingDomain);
        }
    }
    if remaining_energy != 0 {
        return Err(Q29InventoryError::EmptySamplingDomain);
    }
    // Freeze novelty weights for the whole conditional draw.  Mutating these
    // before row four would invalidate the suffix counts used by `rank`.
    for &index in &selected_indices {
        workspace.scope_visits[index] = workspace.scope_visits[index].saturating_add(1);
    }

    let mut rows = [[0_i8; Q29_ROW_LENGTH]; 4];
    for row in 0..4 {
        let mut counts = [0_u8; 10];
        unrank_magnitude_inventory(
            usize::from(row == 0),
            usize::from(scopes[row].energy),
            usize::from(scopes[row].odd_support),
            inventory_ranks[row],
            &mut counts,
        )?;
        reconstruct_signs_and_place(&counts, i16::from(row == 0), random, &mut rows[row])?;
    }
    // Typed direct replay is deliberately inside the boundary: sampled
    // metadata never authorizes a seed that its original coefficients reject.
    let replay = extract_q29_inventories(&rows)?;
    for row in 0..4 {
        if replay[row].energy != scopes[row].energy
            || replay[row].odd_support != scopes[row].odd_support
        {
            return Err(Q29InventoryError::EmptySamplingDomain);
        }
    }
    Ok(Q29OuterProfileSeed {
        scopes,
        rows,
        policy,
        _pad: [0; 11],
    })
}

impl Default for Q29InventoryWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

/// Visit every reachable per-row `(energy, odd support)` coordinate and its
/// exact number of magnitude inventories.  This is the generic cold boundary
/// intended for evolve outer-profile sampling; no preferred scope is baked in.
pub fn for_each_reachable_row_scope(
    workspace: &Q29InventoryWorkspace,
    signed_sum: i16,
    mut visitor: impl FnMut(Q29MagnitudeScope),
) {
    let kind = match signed_sum {
        0 => 0,
        1 => 1,
        _ => return,
    };
    for odd_support in 0..Q29_SUPPORT_VALUES {
        for energy in 0..ENERGY_VALUES {
            let magnitude_inventory_count =
                workspace.row_counts[row_index(kind, energy, odd_support)];
            if magnitude_inventory_count != 0 {
                visitor(Q29MagnitudeScope {
                    magnitude_inventory_count,
                    energy: energy as u16,
                    odd_support: odd_support as u8,
                    signed_sum: signed_sum as i8,
                    _pad: [0; 4],
                });
            }
        }
    }
}

/// Visit learned scope frequencies without exposing q29-specific field names
/// to an evolve consumer.  Zero-visit coordinates are omitted.
pub fn for_each_visited_row_scope(
    workspace: &Q29InventoryWorkspace,
    mut visitor: impl FnMut(Q29VisitedScope),
) {
    for kind in 0..ROW_KINDS {
        for odd_support in 0..Q29_SUPPORT_VALUES {
            for energy in 0..ENERGY_VALUES {
                let index = row_index(kind, energy, odd_support);
                let visits = workspace.scope_visits[index];
                if visits != 0 {
                    visitor(Q29VisitedScope {
                        scope: Q29MagnitudeScope {
                            magnitude_inventory_count: workspace.row_counts[index],
                            energy: energy as u16,
                            odd_support: odd_support as u8,
                            signed_sum: kind as i8,
                            _pad: [0; 4],
                        },
                        visits,
                        _pad: [0; 12],
                    });
                }
            }
        }
    }
}

/// Extract the typed canonical inventory directly from four q29 `y` rows.
pub fn extract_q29_inventories(
    rows: &[[i8; Q29_ROW_LENGTH]; 4],
) -> Result<[Q29RowInventory; 4], Q29InventoryError> {
    let mut output = [Q29RowInventory {
        magnitude_counts: [0; 10],
        energy: 0,
        signed_sum: 0,
        odd_support: 0,
        _pad: 0,
    }; 4];
    let mut combined_energy = 0_u16;
    for block in 0..4 {
        for &value in &rows[block] {
            if !(-9..=9).contains(&value) {
                return Err(Q29InventoryError::CoefficientOutOfRange);
            }
            let magnitude = usize::from(value.unsigned_abs());
            output[block].magnitude_counts[magnitude] += 1;
            output[block].energy += u16::from(value.unsigned_abs()).pow(2);
            output[block].signed_sum += i16::from(value);
            output[block].odd_support += u8::from(magnitude & 1 != 0);
        }
        if output[block].signed_sum != i16::from(block == 0) {
            return Err(Q29InventoryError::WrongRowSum);
        }
        combined_energy += output[block].energy;
    }
    if usize::from(combined_energy) != Q29_TOTAL_ENERGY {
        return Err(Q29InventoryError::WrongCombinedEnergy);
    }
    Ok(output)
}

/// Exhaustively compile both per-row magnitude-inventory tables and the
/// induced four-row energy-505 scope census.
pub fn census_q29_inventory_scopes(
    workspace: &mut Q29InventoryWorkspace,
) -> Result<Q29InventoryCensus, Q29InventoryError> {
    workspace.row_counts.fill(0);
    enumerate_magnitude_inventories(&mut workspace.row_counts);

    let sum_zero_magnitude_inventories = total_row_inventories(&workspace.row_counts, 0);
    let sum_one_magnitude_inventories = total_row_inventories(&workspace.row_counts, 1);
    let sum_zero_energy_support_scopes = count_row_scopes(&workspace.row_counts, 0);
    let sum_one_energy_support_scopes = count_row_scopes(&workspace.row_counts, 1);
    let all_energy_505_magnitude_quartets = count_all_quartets(&workspace.row_counts)?;
    let support_3_4_4_2_magnitude_quartets =
        count_fixed_support_quartets(&workspace.row_counts, [3, 4, 4, 2])?;
    let seed_energy_support_scope_magnitude_quartets = [
        workspace.magnitude_inventory_count(1, 123, 3),
        workspace.magnitude_inventory_count(0, 128, 4),
        workspace.magnitude_inventory_count(0, 128, 4),
        workspace.magnitude_inventory_count(0, 126, 2),
    ]
    .into_iter()
    .try_fold(1_u128, |product, count| {
        product
            .checked_mul(u128::from(count))
            .ok_or(Q29InventoryError::ArithmeticOverflow)
    })?;

    compile_pair_energy_masks(&workspace.row_counts, &mut workspace.pair_energy_masks);
    let feasible_ordered_odd_support_scopes =
        count_feasible_support_scopes(&workspace.pair_energy_masks);

    Ok(Q29InventoryCensus {
        sum_zero_magnitude_inventories,
        sum_one_magnitude_inventories,
        sum_zero_energy_support_scopes,
        sum_one_energy_support_scopes,
        feasible_ordered_odd_support_scopes,
        all_energy_505_magnitude_quartets,
        support_3_4_4_2_magnitude_quartets,
        seed_energy_support_scope_magnitude_quartets,
        // The current seed chooses one exact magnitude inventory in this
        // support scope.  This field makes that extra scoping explicit.
        exact_seed_inventory_quartets: 1,
        workspace_bytes: Q29_INVENTORY_WORKSPACE_BYTES as u32,
        provenance: Q29_INVENTORY_PROVENANCE,
    })
}

/// Visit every feasible ordered odd-support tuple.  The row-energy witnesses
/// remain in the compiled pair masks, so this scans the exact four-row energy
/// condition rather than using a range relaxation.
pub fn for_each_feasible_odd_support_scope(
    workspace: &Q29InventoryWorkspace,
    mut visitor: impl FnMut([u8; 4]),
) {
    for s0 in (1..Q29_SUPPORT_VALUES).step_by(2) {
        for s1 in (0..Q29_SUPPORT_VALUES).step_by(2) {
            let left = pair_mask(&workspace.pair_energy_masks, 0, s0, s1);
            for s2 in (0..Q29_SUPPORT_VALUES).step_by(2) {
                for s3 in (0..Q29_SUPPORT_VALUES).step_by(2) {
                    let right = pair_mask(&workspace.pair_energy_masks, 1, s2, s3);
                    if complementary_energy_exists(left, right) {
                        visitor([s0 as u8, s1 as u8, s2 as u8, s3 as u8]);
                    }
                }
            }
        }
    }
}

fn row_index(kind: usize, energy: usize, support: usize) -> usize {
    (kind * Q29_SUPPORT_VALUES + support) * ENERGY_VALUES + energy
}

fn enumerate_magnitude_inventories(row_counts: &mut [u64]) {
    // Explicit DFS frames for magnitudes 1..9.  Magnitude zero is the unused
    // capacity, hence every leaf represents exactly one 10-count inventory.
    let mut counts = [0_u8; 10];
    let mut next_count = [0_u8; 10];
    let mut remaining_slots = [0_u8; 10];
    let mut remaining_energy = [0_u16; 10];
    let mut total_magnitude = [0_u16; 10];
    let mut odd_support = [0_u8; 10];
    let mut depth = 1_usize;
    remaining_slots[1] = Q29_ROW_LENGTH as u8;
    remaining_energy[1] = Q29_TOTAL_ENERGY as u16;

    loop {
        let square = (depth * depth) as u16;
        let maximum = usize::min(
            usize::from(remaining_slots[depth]),
            usize::from(remaining_energy[depth] / square),
        ) as u8;
        if next_count[depth] <= maximum {
            let count = next_count[depth];
            next_count[depth] += 1;
            counts[depth] = count;
            if depth == Q29_MAX_MAGNITUDE {
                counts[0] = remaining_slots[depth] - count;
                let energy = usize::from(remaining_energy[depth] - u16::from(count) * square);
                let used_energy = Q29_TOTAL_ENERGY - energy;
                let magnitude_sum = total_magnitude[depth] + u16::from(count) * depth as u16;
                let support = odd_support[depth] + u8::from(depth & 1 != 0) * count;
                let reachable = subset_sums(&counts);
                if signed_sum_reachable(reachable, magnitude_sum, 0) {
                    let index = row_index(0, used_energy, usize::from(support));
                    row_counts[index] += 1;
                }
                if signed_sum_reachable(reachable, magnitude_sum, 1) {
                    let index = row_index(1, used_energy, usize::from(support));
                    row_counts[index] += 1;
                }
            } else {
                let child = depth + 1;
                remaining_slots[child] = remaining_slots[depth] - count;
                remaining_energy[child] = remaining_energy[depth] - u16::from(count) * square;
                total_magnitude[child] = total_magnitude[depth] + u16::from(count) * depth as u16;
                odd_support[child] = odd_support[depth] + u8::from(depth & 1 != 0) * count;
                next_count[child] = 0;
                depth = child;
            }
        } else if depth == 1 {
            break;
        } else {
            depth -= 1;
        }
    }
}

/// Exact lexicographic unranking within one reachable row scope.  This is a
/// cold seed operation; it reuses the same bounded odometer and sign predicate
/// as the complete census and admits every counted magnitude inventory.
fn unrank_magnitude_inventory(
    kind: usize,
    wanted_energy: usize,
    wanted_support: usize,
    mut rank: u64,
    output: &mut [u8; 10],
) -> Result<(), Q29InventoryError> {
    let mut counts = [0_u8; 10];
    let mut next_count = [0_u8; 10];
    let mut remaining_slots = [0_u8; 10];
    let mut remaining_energy = [0_u16; 10];
    let mut total_magnitude = [0_u16; 10];
    let mut odd_support = [0_u8; 10];
    let mut depth = 1_usize;
    remaining_slots[1] = Q29_ROW_LENGTH as u8;
    remaining_energy[1] = Q29_TOTAL_ENERGY as u16;

    loop {
        let square = (depth * depth) as u16;
        let maximum = usize::min(
            usize::from(remaining_slots[depth]),
            usize::from(remaining_energy[depth] / square),
        ) as u8;
        if next_count[depth] <= maximum {
            let count = next_count[depth];
            next_count[depth] += 1;
            counts[depth] = count;
            if depth == Q29_MAX_MAGNITUDE {
                counts[0] = remaining_slots[depth] - count;
                let unused_energy =
                    usize::from(remaining_energy[depth] - u16::from(count) * square);
                let energy = Q29_TOTAL_ENERGY - unused_energy;
                let magnitude_sum = total_magnitude[depth] + u16::from(count) * depth as u16;
                let support = odd_support[depth] + u8::from(depth & 1 != 0) * count;
                if energy == wanted_energy
                    && usize::from(support) == wanted_support
                    && signed_sum_reachable(subset_sums(&counts), magnitude_sum, kind as u16)
                {
                    if rank == 0 {
                        *output = counts;
                        return Ok(());
                    }
                    rank -= 1;
                }
            } else {
                let child = depth + 1;
                remaining_slots[child] = remaining_slots[depth] - count;
                remaining_energy[child] = remaining_energy[depth] - u16::from(count) * square;
                total_magnitude[child] = total_magnitude[depth] + u16::from(count) * depth as u16;
                odd_support[child] = odd_support[depth] + u8::from(depth & 1 != 0) * count;
                next_count[child] = 0;
                depth = child;
            }
        } else if depth == 1 {
            break;
        } else {
            depth -= 1;
        }
    }
    Err(Q29InventoryError::EmptySamplingDomain)
}

fn suffix_index(row: usize, remaining_energy: usize) -> usize {
    row * ENERGY_VALUES + remaining_energy
}

fn scope_weight(policy: Q29OuterProfilePolicy, count: u64, visits: u32) -> u128 {
    match policy {
        Q29OuterProfilePolicy::UniformScope => 1,
        Q29OuterProfilePolicy::MagnitudeMultiplicity => u128::from(count),
        Q29OuterProfilePolicy::Novelty => 1 + u128::from(4_096 / visits.saturating_add(1)),
    }
}

fn compile_suffix_ways(
    workspace: &mut Q29InventoryWorkspace,
    policy: Q29OuterProfilePolicy,
) -> Result<(), Q29InventoryError> {
    workspace.suffix_ways.fill(0);
    workspace.suffix_ways[suffix_index(4, 0)] = 1;
    let row_counts = &workspace.row_counts;
    let scope_visits = &workspace.scope_visits;
    let suffix_ways = &mut workspace.suffix_ways;
    for row in (0..4).rev() {
        let kind = usize::from(row == 0);
        for remaining in 0..ENERGY_VALUES {
            let mut ways = 0_u128;
            for odd_support in 0..Q29_SUPPORT_VALUES {
                for energy in 0..=remaining {
                    let index = row_index(kind, energy, odd_support);
                    let count = row_counts[index];
                    if count == 0 {
                        continue;
                    }
                    let contribution = scope_weight(policy, count, scope_visits[index])
                        .checked_mul(suffix_ways[suffix_index(row + 1, remaining - energy)])
                        .ok_or(Q29InventoryError::ArithmeticOverflow)?;
                    ways = ways
                        .checked_add(contribution)
                        .ok_or(Q29InventoryError::ArithmeticOverflow)?;
                }
            }
            suffix_ways[suffix_index(row, remaining)] = ways;
        }
    }
    Ok(())
}

#[inline(always)]
fn next_random(random: &mut u64) -> u64 {
    *random ^= *random << 13;
    *random ^= *random >> 7;
    *random ^= *random << 17;
    *random
}

fn sample_below(random: &mut u64, bound: u128) -> u128 {
    debug_assert!(bound != 0);
    let zone = u128::MAX - u128::MAX % bound;
    loop {
        let value = (u128::from(next_random(random)) << 64) | u128::from(next_random(random));
        if value < zone {
            return value % bound;
        }
    }
}

fn reconstruct_signs_and_place(
    counts: &[u8; 10],
    target: i16,
    random: &mut u64,
    output: &mut [i8; Q29_ROW_LENGTH],
) -> Result<(), Q29InventoryError> {
    let mut magnitudes = [0_i8; Q29_ROW_LENGTH];
    let mut length = 0_usize;
    let mut total = 0_u16;
    for (magnitude, &count) in counts.iter().enumerate().skip(1) {
        for _ in 0..count {
            magnitudes[length] = magnitude as i8;
            length += 1;
            total += magnitude as u16;
        }
    }
    let target = u16::try_from(target).map_err(|_| Q29InventoryError::EmptySamplingDomain)?;
    if total < target || (total - target) & 1 != 0 {
        return Err(Q29InventoryError::EmptySamplingDomain);
    }
    let mut prefix = [0_u128; Q29_ROW_LENGTH + 1];
    prefix[0] = 1;
    for index in 0..length {
        prefix[index + 1] = prefix[index] | (prefix[index] << usize::from(magnitudes[index] as u8));
    }
    let mut negative_sum = usize::from((total - target) / 2);
    if prefix[length] & (1_u128 << negative_sum) == 0 {
        return Err(Q29InventoryError::EmptySamplingDomain);
    }
    output.fill(0);
    for index in (0..length).rev() {
        let magnitude = usize::from(magnitudes[index] as u8);
        let can_positive = prefix[index] & (1_u128 << negative_sum) != 0;
        let can_negative = negative_sum >= magnitude
            && prefix[index] & (1_u128 << (negative_sum - magnitude)) != 0;
        let choose_negative = can_negative && (!can_positive || next_random(random) & 1 != 0);
        if choose_negative {
            output[index] = -magnitudes[index];
            negative_sum -= magnitude;
        } else if can_positive {
            output[index] = magnitudes[index];
        } else {
            return Err(Q29InventoryError::EmptySamplingDomain);
        }
    }
    if negative_sum != 0 {
        return Err(Q29InventoryError::EmptySamplingDomain);
    }
    for tail in (1..Q29_ROW_LENGTH).rev() {
        let swap = (next_random(random) as usize) % (tail + 1);
        output.swap(tail, swap);
    }
    Ok(())
}

#[inline(always)]
fn subset_sums(counts: &[u8; 10]) -> u128 {
    let mut reachable = 1_u128;
    for (magnitude, &count) in counts.iter().enumerate().skip(1) {
        let mut consumed = 0_u8;
        let mut chunk = 1_u8;
        while consumed < count {
            let take = chunk.min(count - consumed);
            reachable |= reachable << (magnitude * usize::from(take));
            consumed += take;
            chunk = chunk.saturating_mul(2);
        }
    }
    reachable
}

#[inline(always)]
fn signed_sum_reachable(reachable: u128, total: u16, target: u16) -> bool {
    total >= target
        && (total - target) & 1 == 0
        && reachable & (1_u128 << ((total - target) / 2)) != 0
}

fn total_row_inventories(row_counts: &[u64], kind: usize) -> u64 {
    let mut total = 0_u64;
    for support in 0..Q29_SUPPORT_VALUES {
        for energy in 0..ENERGY_VALUES {
            total += row_counts[row_index(kind, energy, support)];
        }
    }
    total
}

fn count_row_scopes(row_counts: &[u64], kind: usize) -> u16 {
    let mut total = 0_u16;
    for support in 0..Q29_SUPPORT_VALUES {
        for energy in 0..ENERGY_VALUES {
            total += u16::from(row_counts[row_index(kind, energy, support)] != 0);
        }
    }
    total
}

fn energy_counts(row_counts: &[u64], kind: usize) -> [u128; ENERGY_VALUES] {
    let mut output = [0_u128; ENERGY_VALUES];
    for support in 0..Q29_SUPPORT_VALUES {
        for energy in 0..ENERGY_VALUES {
            output[energy] += u128::from(row_counts[row_index(kind, energy, support)]);
        }
    }
    output
}

fn convolve_truncated(
    left: &[u128; ENERGY_VALUES],
    right: &[u128; ENERGY_VALUES],
) -> Result<[u128; ENERGY_VALUES], Q29InventoryError> {
    let mut output = [0_u128; ENERGY_VALUES];
    for left_energy in 0..ENERGY_VALUES {
        if left[left_energy] == 0 {
            continue;
        }
        for right_energy in 0..(ENERGY_VALUES - left_energy) {
            if right[right_energy] == 0 {
                continue;
            }
            let product = left[left_energy]
                .checked_mul(right[right_energy])
                .ok_or(Q29InventoryError::ArithmeticOverflow)?;
            output[left_energy + right_energy] = output[left_energy + right_energy]
                .checked_add(product)
                .ok_or(Q29InventoryError::ArithmeticOverflow)?;
        }
    }
    Ok(output)
}

fn count_all_quartets(row_counts: &[u64]) -> Result<u128, Q29InventoryError> {
    let sum_one = energy_counts(row_counts, 1);
    let sum_zero = energy_counts(row_counts, 0);
    let two = convolve_truncated(&sum_one, &sum_zero)?;
    let three = convolve_truncated(&two, &sum_zero)?;
    let four = convolve_truncated(&three, &sum_zero)?;
    Ok(four[Q29_TOTAL_ENERGY])
}

fn support_energy_counts(row_counts: &[u64], kind: usize, support: usize) -> [u128; ENERGY_VALUES] {
    let mut output = [0_u128; ENERGY_VALUES];
    for energy in 0..ENERGY_VALUES {
        output[energy] = u128::from(row_counts[row_index(kind, energy, support)]);
    }
    output
}

fn count_fixed_support_quartets(
    row_counts: &[u64],
    supports: [usize; 4],
) -> Result<u128, Q29InventoryError> {
    let row0 = support_energy_counts(row_counts, 1, supports[0]);
    let row1 = support_energy_counts(row_counts, 0, supports[1]);
    let row2 = support_energy_counts(row_counts, 0, supports[2]);
    let row3 = support_energy_counts(row_counts, 0, supports[3]);
    let two = convolve_truncated(&row0, &row1)?;
    let three = convolve_truncated(&two, &row2)?;
    let four = convolve_truncated(&three, &row3)?;
    Ok(four[Q29_TOTAL_ENERGY])
}

fn compile_pair_energy_masks(row_counts: &[u64], pair_masks: &mut [u64]) {
    pair_masks.fill(0);
    for side in 0..2 {
        let first_kind = usize::from(side == 0);
        for first_support in 0..Q29_SUPPORT_VALUES {
            for second_support in 0..Q29_SUPPORT_VALUES {
                let output = pair_mask_mut(pair_masks, side, first_support, second_support);
                for first_energy in 0..ENERGY_VALUES {
                    if row_counts[row_index(first_kind, first_energy, first_support)] == 0 {
                        continue;
                    }
                    for second_energy in 0..(ENERGY_VALUES - first_energy) {
                        if row_counts[row_index(0, second_energy, second_support)] != 0 {
                            let energy = first_energy + second_energy;
                            output[energy / 64] |= 1_u64 << (energy % 64);
                        }
                    }
                }
            }
        }
    }
}

fn pair_mask_index(side: usize, first_support: usize, second_support: usize) -> usize {
    (side * SUPPORT_PAIRS + first_support * Q29_SUPPORT_VALUES + second_support) * PAIR_ENERGY_WORDS
}

fn pair_mask(masks: &[u64], side: usize, first_support: usize, second_support: usize) -> &[u64] {
    let start = pair_mask_index(side, first_support, second_support);
    &masks[start..start + PAIR_ENERGY_WORDS]
}

fn pair_mask_mut(
    masks: &mut [u64],
    side: usize,
    first_support: usize,
    second_support: usize,
) -> &mut [u64] {
    let start = pair_mask_index(side, first_support, second_support);
    &mut masks[start..start + PAIR_ENERGY_WORDS]
}

fn complementary_energy_exists(left: &[u64], right: &[u64]) -> bool {
    for energy in 0..=Q29_TOTAL_ENERGY {
        if left[energy / 64] & (1_u64 << (energy % 64)) != 0 {
            let complement = Q29_TOTAL_ENERGY - energy;
            if right[complement / 64] & (1_u64 << (complement % 64)) != 0 {
                return true;
            }
        }
    }
    false
}

fn count_feasible_support_scopes(pair_masks: &[u64]) -> u32 {
    let mut count = 0_u32;
    for s0 in (1..Q29_SUPPORT_VALUES).step_by(2) {
        for s1 in (0..Q29_SUPPORT_VALUES).step_by(2) {
            let left = pair_mask(pair_masks, 0, s0, s1);
            for s2 in (0..Q29_SUPPORT_VALUES).step_by(2) {
                for s3 in (0..Q29_SUPPORT_VALUES).step_by(2) {
                    let right = pair_mask(pair_masks, 1, s2, s3);
                    count += u32::from(complementary_energy_exists(left, right));
                }
            }
        }
    }
    count
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn direct_sign_reachable(counts: &[u8; 10], target: i16) -> bool {
        let mut values = [0_i8; Q29_ROW_LENGTH];
        let mut length = 0;
        for (magnitude, &count) in counts.iter().enumerate().skip(1) {
            for _ in 0..count {
                values[length] = magnitude as i8;
                length += 1;
            }
        }
        let limit = 1_u64 << length;
        for signs in 0..limit {
            let mut sum = 0_i16;
            for (index, &value) in values[..length].iter().enumerate() {
                sum += if signs & (1_u64 << index) == 0 {
                    i16::from(value)
                } else {
                    -i16::from(value)
                };
            }
            if sum == target {
                return true;
            }
        }
        false
    }

    #[test]
    fn subset_sum_matches_independent_sign_oracle_on_small_inventories() {
        let mut counts = [0_u8; 10];
        for encoded in 0..4_u32.pow(5) {
            let mut rest = encoded;
            let mut total = 0_u16;
            for magnitude in 1..=5 {
                counts[magnitude] = (rest % 4) as u8;
                rest /= 4;
                total += u16::from(counts[magnitude]) * magnitude as u16;
            }
            let reachable = subset_sums(&counts);
            assert_eq!(
                signed_sum_reachable(reachable, total, 0),
                direct_sign_reachable(&counts, 0)
            );
            assert_eq!(
                signed_sum_reachable(reachable, total, 1),
                direct_sign_reachable(&counts, 1)
            );
        }
    }

    #[test]
    fn canonical_extractor_accepts_seed_and_rejects_semantic_forgery() {
        let signed: [[(usize, i8); 6]; 4] = [
            [(13, 2), (13, -2), (1, 3), (1, -3), (1, 1), (0, -1)],
            [(13, 2), (12, -2), (1, 3), (2, -3), (1, 1), (0, -1)],
            [(13, 2), (12, -2), (1, 3), (2, -3), (1, 1), (0, -1)],
            [(12, 2), (15, -2), (2, 3), (0, -3), (0, 1), (0, -1)],
        ];
        let mut rows = [[0_i8; Q29_ROW_LENGTH]; 4];
        for block in 0..4 {
            let mut cursor = 0;
            for &(count, value) in &signed[block] {
                for _ in 0..count {
                    rows[block][cursor] = value;
                    cursor += 1;
                }
            }
            assert_eq!(cursor, Q29_ROW_LENGTH);
        }
        let inventories = extract_q29_inventories(&rows).unwrap();
        assert_eq!(
            inventories.map(|inventory| inventory.odd_support),
            [3, 4, 4, 2]
        );
        rows[0][0] = 10;
        assert_eq!(
            extract_q29_inventories(&rows),
            Err(Q29InventoryError::CoefficientOutOfRange)
        );
    }

    #[test]
    fn compiled_census_is_allocation_free_after_workspace_setup() {
        let mut workspace = Q29InventoryWorkspace::new();
        let (census, allocations) =
            tracked_allocations(|| census_q29_inventory_scopes(&mut workspace));
        assert_eq!(allocations, 0);
        let census = census.unwrap();
        assert_eq!(census.sum_zero_magnitude_inventories, 9_267_965);
        assert_eq!(census.workspace_bytes, 520_000);
        assert_eq!(census.sum_one_magnitude_inventories, 9_347_927);
        assert_eq!(census.sum_zero_energy_support_scopes, 1_786);
        assert_eq!(census.sum_one_energy_support_scopes, 1_789);
        assert_eq!(census.feasible_ordered_odd_support_scopes, 25_312);
        assert_eq!(
            census.all_energy_505_magnitude_quartets,
            1_306_548_399_670_892_351
        );
        assert_eq!(
            census.support_3_4_4_2_magnitude_quartets,
            79_533_805_645_248
        );
        assert_eq!(
            census.seed_energy_support_scope_magnitude_quartets,
            1_821_919_960
        );
    }

    #[test]
    fn visitor_count_matches_census_and_contains_seed_scope() {
        let mut workspace = Q29InventoryWorkspace::new();
        let census = census_q29_inventory_scopes(&mut workspace).unwrap();
        let mut count = 0_u32;
        let mut saw_seed = false;
        for_each_feasible_odd_support_scope(&workspace, |scope| {
            count += 1;
            saw_seed |= scope == [3, 4, 4, 2];
        });
        assert_eq!(count, census.feasible_ordered_odd_support_scopes);
        assert!(saw_seed);

        let mut sum_zero_scopes = 0_u16;
        let mut sum_one_scopes = 0_u16;
        for_each_reachable_row_scope(&workspace, 0, |_| sum_zero_scopes += 1);
        for_each_reachable_row_scope(&workspace, 1, |_| sum_one_scopes += 1);
        assert_eq!(sum_zero_scopes, census.sum_zero_energy_support_scopes);
        assert_eq!(sum_one_scopes, census.sum_one_energy_support_scopes);
    }

    #[test]
    fn rotating_outer_sampler_replays_canonical_rows_without_allocating() {
        let mut workspace = Q29InventoryWorkspace::new();
        assert_eq!(
            sample_rotating_q29_outer_profile_seed(&mut workspace, &mut 7, 0),
            Err(Q29InventoryError::UncompiledWorkspace)
        );
        census_q29_inventory_scopes(&mut workspace).unwrap();
        let mut random = 0x7f4a_7c15_9e37_79b9;
        let (seeds, allocations) = tracked_allocations(|| {
            let mut seeds = [Q29OuterProfileSeed {
                scopes: [Q29MagnitudeScope {
                    magnitude_inventory_count: 0,
                    energy: 0,
                    odd_support: 0,
                    signed_sum: 0,
                    _pad: [0; 4],
                }; 4],
                rows: [[0; Q29_ROW_LENGTH]; 4],
                policy: Q29OuterProfilePolicy::UniformScope,
                _pad: [0; 11],
            }; 9];
            for (epoch, seed) in seeds.iter_mut().enumerate() {
                *seed = sample_rotating_q29_outer_profile_seed(
                    &mut workspace,
                    &mut random,
                    epoch as u64,
                )
                .unwrap();
            }
            seeds
        });
        assert_eq!(allocations, 0);
        for (epoch, seed) in seeds.iter().enumerate() {
            assert_eq!(seed.policy as usize, epoch % 3);
            let replay = extract_q29_inventories(&seed.rows).unwrap();
            assert_eq!(replay.iter().map(|row| row.energy).sum::<u16>(), 505);
            for row in 0..4 {
                assert_eq!(replay[row].energy, seed.scopes[row].energy);
                assert_eq!(replay[row].odd_support, seed.scopes[row].odd_support);
                assert_eq!(replay[row].signed_sum, i16::from(row == 0));
            }
        }
        let mut visit_total = 0_u32;
        for_each_visited_row_scope(&workspace, |observation| {
            visit_total += observation.visits;
        });
        assert_eq!(visit_total, 36);
    }

    #[test]
    fn unranking_reaches_distinct_inventories_and_novelty_weights_stay_frozen() {
        let mut workspace = Q29InventoryWorkspace::new();
        census_q29_inventory_scopes(&mut workspace).unwrap();
        let count = workspace.magnitude_inventory_count(1, 123, 3);
        assert!(count > 1);
        let mut first = [0_u8; 10];
        let mut last = [0_u8; 10];
        unrank_magnitude_inventory(1, 123, 3, 0, &mut first).unwrap();
        unrank_magnitude_inventory(1, 123, 3, count - 1, &mut last).unwrap();
        assert_ne!(first, last);

        let mut random = 0xd1b5_4a32_d192_ed03;
        for _ in 0..16 {
            let seed = sample_q29_outer_profile_seed(
                &mut workspace,
                &mut random,
                Q29OuterProfilePolicy::Novelty,
            )
            .unwrap();
            extract_q29_inventories(&seed.rows).unwrap();
        }
    }
}
