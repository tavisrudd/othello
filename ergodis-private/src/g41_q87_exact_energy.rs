//! Exact q87 coefficient-state replay for selected mixed-character energies.
//!
//! Twenty-four three-bit lanes store the three q87 lifts above each of the
//! eight q29 multiplier coordinates.  Six disjoint fine-orbit slots are
//! combined as a three-plus-three MITM; the right side is sorted by its exact
//! q29 projection, packed into the unused high 40 bits of the same `u128`.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_evolve::{
    compile_inventory, digit_counts, FineInventory, FineOrbit, G41Q29EvolveError, Q29_COSETS,
};
use crate::g41_q87_energy::{
    compile_g41_q87_energy_support, issue_g41_q87_energy_proof, G41Q87EnergyError, Q87_ENERGY_WORDS,
};

const SLOTS: usize = 6;
const COORDINATES: usize = 8;
const LIFTS: usize = 3;
const LANE_BITS: u32 = 3;
const STATE_BITS: u32 = (COORDINATES * LIFTS) as u32 * LANE_BITS;
const STATE_MASK: u128 = (1_u128 << STATE_BITS) - 1;
const MAX_SIDE_STATES: usize = 1 << 24;
const TARGET_ENERGY: usize = 523;
const MAX_ENERGY_VECTORS: usize = 1 << 20;
const EXACT_EXTRACTOR_IDENTITY: &str = "ergodis-private:g41-q87-exact-lift:v1; carrier=522; multiplier=41; source=six-disjoint-fine-orbit-slots; state=24x3-bit-q87-coefficients; join=exact-q29-projection-complement; semantics=allowed-energy-defects-for-four-block-SDS-target-523";

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q87ExactEnergyError {
    #[error("g41 q87 exact energy semantics are invalid")]
    SemanticMismatch,
    #[error("g41 q87 exact energy side {side} stage {stage} upper bound {states} exceeded its state budget")]
    StateBudgetAt { side: u8, stage: u8, states: u64 },
    #[error(transparent)]
    Evolve(#[from] G41Q29EvolveError),
    #[error(transparent)]
    Energy(#[from] G41Q87EnergyError),
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q87ExactLiftProof {
    extractor_digest: [u8; 32],
    source_digest: [u8; 32],
    allowed_defect_masks: [u8; 4],
    compatible_energy_quartets: u16,
}

impl G41Q87ExactLiftProof {
    pub fn allowed_defect_masks(&self) -> [u8; 4] {
        self.allowed_defect_masks
    }

    pub fn compatible_energy_quartets(&self) -> u16 {
        self.compatible_energy_quartets
    }

    pub fn digest(&self) -> [u8; 32] {
        let mut hasher = Sha256::new();
        hasher.update(self.extractor_digest);
        hasher.update(self.source_digest);
        hasher.update(self.allowed_defect_masks);
        hasher.update(self.compatible_energy_quartets.to_le_bytes());
        hasher.finalize().into()
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q87ExactEnergyReport {
    pub mask: u8,
    pub digits: u32,
    pub q29_coefficients: [u8; COORDINATES],
    pub slot_states: [u32; SLOTS],
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub left_states: u32,
    pub right_states: u32,
    pub pairs_visited: u64,
    pub requested_energies: u16,
    pub realized_energies: u16,
    pub realized_energy_support: [u64; Q87_ENERGY_WORDS],
    pub exhaustive: bool,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q87ReachableEnergyVectors {
    pub report: G41Q87ExactEnergyReport,
    pub coordinate_energy_masks: [u64; COORDINATES],
    pub vectors: Vec<[u8; COORDINATES]>,
    pub provenance: &'static str,
}

#[inline(always)]
const fn lane(state: u128, coordinate: usize, lift: usize) -> u8 {
    ((state >> (LANE_BITS * (coordinate * LIFTS + lift) as u32)) & 7) as u8
}

#[inline(always)]
fn add_states(first: u128, second: u128) -> u128 {
    first + second
}

fn q87_lifts(coordinate: usize) -> [usize; LIFTS] {
    let residue = if coordinate == 0 {
        0
    } else {
        Q29_COSETS[coordinate - 1][0]
    };
    [residue, residue + 29, residue + 58]
}

fn orbit_state(orbit: &FineOrbit) -> u128 {
    let mut state = 0_u128;
    for coordinate in 0..COORDINATES {
        let lifts = q87_lifts(coordinate);
        for lift in 0..LIFTS {
            let value = orbit.points[..usize::from(orbit.len)]
                .iter()
                .filter(|&&point| usize::from(point) % 87 == lifts[lift])
                .count() as u8;
            state |= u128::from(value) << (LANE_BITS * (coordinate * LIFTS + lift) as u32);
        }
    }
    state
}

fn projection(state: u128) -> [u8; COORDINATES] {
    std::array::from_fn(|coordinate| (0..LIFTS).map(|lift| lane(state, coordinate, lift)).sum())
}

#[inline(always)]
fn projection_within(state: u128, target: [u8; COORDINATES]) -> bool {
    projection(state)
        .into_iter()
        .zip(target)
        .all(|(value, target)| value <= target)
}

fn pack_projection(values: [u8; COORDINATES]) -> Option<u64> {
    let mut packed = 0_u64;
    for value in values {
        if value > 31 {
            return None;
        }
        packed = (packed << 5) | u64::from(value);
    }
    Some(packed)
}

fn complement_projection_key(state: u128, target: [u8; COORDINATES]) -> Option<u64> {
    let values = projection(state);
    let mut complement = [0_u8; COORDINATES];
    for coordinate in 0..COORDINATES {
        complement[coordinate] = target[coordinate].checked_sub(values[coordinate])?;
    }
    pack_projection(complement)
}

fn local_energies(state: u128) -> [u8; COORDINATES] {
    std::array::from_fn(|coordinate| {
        let a = i32::from(lane(state, coordinate, 0));
        let b = i32::from(lane(state, coordinate, 1));
        let c = i32::from(lane(state, coordinate, 2));
        (a * a + b * b + c * c - a * b - b * c - c * a) as u8
    })
}

fn energy_from_locals(locals: [u8; COORDINATES]) -> usize {
    locals
        .into_iter()
        .enumerate()
        .map(|(coordinate, local)| usize::from(local) * if coordinate == 0 { 1 } else { 4 })
        .sum()
}

fn slot_states(inventory: &FineInventory, slot: usize, mask: u8, count: u8) -> Vec<u128> {
    let initial = if mask & (1 << slot) != 0 {
        orbit_state(&inventory.small[slot])
    } else {
        0
    };
    let length = inventory.large_len[slot];
    let mut large_states = [0_u128; 14];
    for orbit in 0..length {
        large_states[usize::from(orbit)] = orbit_state(&inventory.large[slot][usize::from(orbit)]);
    }
    let mut states = Vec::with_capacity(1_usize << length);
    for subset in 0_u16..1_u16 << length {
        if subset.count_ones() != u32::from(count) {
            continue;
        }
        let mut state = initial;
        for orbit in 0..length {
            if subset & (1 << orbit) != 0 {
                state = add_states(state, large_states[usize::from(orbit)]);
            }
        }
        states.push(state);
    }
    states.sort_unstable();
    states.dedup();
    states
}

fn compile_side(
    slots: [&[u128]; 3],
    target: [u8; COORDINATES],
    side: u8,
) -> Result<Vec<u128>, G41Q87ExactEnergyError> {
    let mut current = vec![0_u128];
    for (stage, contributions) in slots.into_iter().enumerate() {
        let raw_upper = current.len().checked_mul(contributions.len()).ok_or(
            G41Q87ExactEnergyError::StateBudgetAt {
                side,
                stage: stage as u8,
                states: u64::MAX,
            },
        )?;
        // The exact q29 projection discards most Cartesian products at the
        // final stage.  Reserve the fixed budget once, then fail on the first
        // retained state beyond it; the raw product bound is not itself a
        // resource requirement.
        let mut next = Vec::with_capacity(raw_upper.min(MAX_SIDE_STATES));
        for &left in &current {
            for &right in contributions {
                let state = add_states(left, right);
                if projection_within(state, target) {
                    if next.len() == MAX_SIDE_STATES {
                        return Err(G41Q87ExactEnergyError::StateBudgetAt {
                            side,
                            stage: stage as u8,
                            states: MAX_SIDE_STATES as u64 + 1,
                        });
                    }
                    next.push(state);
                }
            }
        }
        next.sort_unstable();
        next.dedup();
        current = next;
    }
    Ok(current)
}

fn balanced_partition(cardinalities: [u32; SLOTS]) -> ([usize; 3], [usize; 3]) {
    let mut best_left = [0_usize, 1, 2];
    let mut best_score = u128::MAX;
    for first in 0..SLOTS - 2 {
        for second in first + 1..SLOTS - 1 {
            for third in second + 1..SLOTS {
                // Complementary partitions occur twice.  Keeping slot zero on
                // the left makes the selected representation canonical.
                if first != 0 {
                    continue;
                }
                let left = [first, second, third];
                let mut right = [0_usize; 3];
                let mut cursor = 0;
                for slot in 0..SLOTS {
                    if !left.contains(&slot) {
                        right[cursor] = slot;
                        cursor += 1;
                    }
                }
                let left_product = left
                    .into_iter()
                    .map(|slot| u128::from(cardinalities[slot]))
                    .product::<u128>();
                let right_product = right
                    .into_iter()
                    .map(|slot| u128::from(cardinalities[slot]))
                    .product::<u128>();
                let score = left_product.max(right_product);
                if score < best_score {
                    best_score = score;
                    best_left = left;
                }
            }
        }
    }
    let mut right = [0_usize; 3];
    let mut cursor = 0;
    for slot in 0..SLOTS {
        if !best_left.contains(&slot) {
            right[cursor] = slot;
            cursor += 1;
        }
    }
    // Smaller layers first minimize transient products and expose projection
    // failures before the largest expansion.
    best_left.sort_unstable_by_key(|&slot| cardinalities[slot]);
    right.sort_unstable_by_key(|&slot| cardinalities[slot]);
    (best_left, right)
}

#[inline(always)]
fn support_has(support: &[u64; Q87_ENERGY_WORDS], value: usize) -> bool {
    value <= TARGET_ENERGY && support[value / 64] & (1_u64 << (value % 64)) != 0
}

#[inline(always)]
fn energy_vector_index(locals: [u8; COORDINATES], masks: [u64; COORDINATES]) -> Option<usize> {
    let mut index = 0_usize;
    let mut stride = 1_usize;
    for coordinate in 0..COORDINATES {
        let value = locals[coordinate];
        let bit = 1_u64.checked_shl(u32::from(value))?;
        if masks[coordinate] & bit == 0 {
            return None;
        }
        let below = bit - 1;
        index += (masks[coordinate] & below).count_ones() as usize * stride;
        stride *= masks[coordinate].count_ones() as usize;
    }
    Some(index)
}

fn energy_vector_at(mut index: usize, masks: [u64; COORDINATES]) -> [u8; COORDINATES] {
    std::array::from_fn(|coordinate| {
        let radix = masks[coordinate].count_ones() as usize;
        let rank = index % radix;
        index /= radix;
        let mut remaining = masks[coordinate];
        for _ in 0..rank {
            remaining &= remaining - 1;
        }
        remaining.trailing_zeros() as u8
    })
}

fn census_impl<const COLLECT_VECTORS: bool>(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
    requested_energy_support: [u64; Q87_ENERGY_WORDS],
) -> Result<
    (
        G41Q87ExactEnergyReport,
        [u64; COORDINATES],
        Vec<[u8; COORDINATES]>,
    ),
    G41Q87ExactEnergyError,
> {
    if mask >= 64
        || q29_coefficients.iter().any(|&value| value > 18)
        || requested_energy_support[Q87_ENERGY_WORDS - 1] >> (524 % 64) != 0
    {
        return Err(G41Q87ExactEnergyError::SemanticMismatch);
    }
    let requested_energies: u16 = requested_energy_support
        .iter()
        .map(|word| word.count_ones() as u16)
        .sum();
    if requested_energies == 0 {
        return Err(G41Q87ExactEnergyError::SemanticMismatch);
    }
    let coordinate_energy_masks = if COLLECT_VECTORS {
        compile_g41_q87_energy_support(mask, digits, q29_coefficients)?.coordinate_energy_masks
    } else {
        [0_u64; COORDINATES]
    };
    let energy_vector_count = if COLLECT_VECTORS {
        coordinate_energy_masks
            .iter()
            .try_fold(1_usize, |product, mask| {
                product.checked_mul(mask.count_ones() as usize)
            })
            .filter(|&count| count <= MAX_ENERGY_VECTORS)
            .ok_or(G41Q87ExactEnergyError::StateBudgetAt {
                side: 3,
                stage: 0,
                states: u64::MAX,
            })?
    } else {
        0
    };
    let mut reachable_vectors = vec![0_u64; energy_vector_count.div_ceil(64)];
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q87ExactEnergyError::SemanticMismatch);
    }
    let contributions: [Vec<u128>; SLOTS] =
        std::array::from_fn(|slot| slot_states(&inventory, slot, mask, counts[slot]));
    let slot_state_counts = std::array::from_fn(|slot| contributions[slot].len() as u32);
    let (left_slots, right_slots) = balanced_partition(slot_state_counts);
    let left = compile_side(
        left_slots.map(|slot| contributions[slot].as_slice()),
        q29_coefficients,
        0,
    )?;
    let right = compile_side(
        right_slots.map(|slot| contributions[slot].as_slice()),
        q29_coefficients,
        1,
    )?;
    let mut keyed_right = Vec::with_capacity(right.len());
    for state in right {
        let key =
            pack_projection(projection(state)).ok_or(G41Q87ExactEnergyError::SemanticMismatch)?;
        keyed_right.push((u128::from(key) << STATE_BITS) | state);
    }
    keyed_right.sort_unstable();
    let mut pairs_visited = 0_u64;
    let mut realized_energy_support = [0_u64; Q87_ENERGY_WORDS];
    let mut exhaustive = true;
    'states: for &left_state in &left {
        let Some(key) = complement_projection_key(left_state, q29_coefficients) else {
            continue;
        };
        let start = keyed_right.partition_point(|&entry| (entry >> STATE_BITS) < u128::from(key));
        let end = keyed_right.partition_point(|&entry| (entry >> STATE_BITS) <= u128::from(key));
        for &entry in &keyed_right[start..end] {
            pairs_visited =
                pairs_visited
                    .checked_add(1)
                    .ok_or(G41Q87ExactEnergyError::StateBudgetAt {
                        side: 2,
                        stage: 0,
                        states: u64::MAX,
                    })?;
            let state = add_states(left_state, entry & STATE_MASK);
            let locals = local_energies(state);
            if COLLECT_VECTORS {
                let index = energy_vector_index(locals, coordinate_energy_masks)
                    .ok_or(G41Q87ExactEnergyError::SemanticMismatch)?;
                reachable_vectors[index / 64] |= 1_u64 << (index % 64);
            }
            let value = energy_from_locals(locals);
            if support_has(&requested_energy_support, value) {
                realized_energy_support[value / 64] |= 1_u64 << (value % 64);
                if realized_energy_support == requested_energy_support {
                    exhaustive = false;
                    break 'states;
                }
            }
        }
    }
    let realized_energies: u16 = realized_energy_support
        .iter()
        .map(|word| word.count_ones() as u16)
        .sum();
    let report = G41Q87ExactEnergyReport {
        mask,
        digits,
        q29_coefficients,
        slot_states: slot_state_counts,
        left_slots: left_slots.map(|slot| slot as u8),
        right_slots: right_slots.map(|slot| slot as u8),
        left_states: left.len() as u32,
        right_states: keyed_right.len() as u32,
        pairs_visited,
        requested_energies,
        realized_energies,
        realized_energy_support,
        exhaustive,
        workspace_bytes: contributions
            .iter()
            .map(|states| states.capacity() as u64 * std::mem::size_of::<u128>() as u64)
            .sum::<u64>()
            + left.capacity() as u64 * std::mem::size_of::<u128>() as u64
            + keyed_right.capacity() as u64 * std::mem::size_of::<u128>() as u64
            + reachable_vectors.capacity() as u64 * std::mem::size_of::<u64>() as u64,
        provenance: "exact q87 three-lift coefficient replay from six disjoint fine-orbit slots; bounded iterative three-plus-three MITM; collision-free 40-bit q29 projection complement packed above the 72-bit source state; early stop is permitted only after every requested energy has a concrete source state",
    };
    let vector_count = reachable_vectors
        .iter()
        .map(|word| word.count_ones() as usize)
        .sum();
    let mut vectors = Vec::with_capacity(vector_count);
    if COLLECT_VECTORS {
        for index in 0..energy_vector_count {
            if reachable_vectors[index / 64] & (1_u64 << (index % 64)) != 0 {
                vectors.push(energy_vector_at(index, coordinate_energy_masks));
            }
        }
        vectors.sort_unstable();
    }
    Ok((report, coordinate_energy_masks, vectors))
}

pub fn census_g41_q87_exact_energies(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
    requested_energy_support: [u64; Q87_ENERGY_WORDS],
) -> Result<G41Q87ExactEnergyReport, G41Q87ExactEnergyError> {
    Ok(census_impl::<false>(mask, digits, q29_coefficients, requested_energy_support)?.0)
}

pub fn census_g41_q87_reachable_energy_vectors(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
) -> Result<G41Q87ReachableEnergyVectors, G41Q87ExactEnergyError> {
    let mut impossible = [0_u64; Q87_ENERGY_WORDS];
    impossible[TARGET_ENERGY / 64] = 1_u64 << (TARGET_ENERGY % 64);
    let (report, coordinate_energy_masks, vectors) =
        census_impl::<true>(mask, digits, q29_coefficients, impossible)?;
    if !report.exhaustive || report.realized_energies != 0 {
        return Err(G41Q87ExactEnergyError::SemanticMismatch);
    }
    Ok(G41Q87ReachableEnergyVectors {
        report,
        coordinate_energy_masks,
        vectors,
        provenance: "complete reachable local q87 energy-vector domain from the exact coefficient-state join; marginal coordinate masks come from the independently compiled q87 sumsets; the impossible odd target 523 forces exhaustive enumeration for a single block",
    })
}

fn compatible_defect_quartets(allowed: [u8; 4], total: u16) -> u16 {
    let mut count = 0_u16;
    for first in 0..=total {
        for second in 0..=total - first {
            for third in 0..=total - first - second {
                let fourth = total - first - second - third;
                let values = [first, second, third, fourth];
                if (0..4).all(|block| allowed[block] & (1_u8 << values[block]) != 0) {
                    count += 1;
                }
            }
        }
    }
    count
}

pub fn issue_g41_q87_exact_lift_proof(
    masks: [u8; 4],
    digits: [u32; 4],
    q29_coefficients: [[u8; COORDINATES]; 4],
) -> Result<G41Q87ExactLiftProof, G41Q87ExactEnergyError> {
    let marginal = issue_g41_q87_energy_proof(masks, digits, q29_coefficients)?;
    let (bases, step, total_defect) = marginal.energy_normal_form();
    if total_defect >= 8 {
        return Err(G41Q87ExactEnergyError::SemanticMismatch);
    }
    let mut allowed_defect_masks = [0_u8; 4];
    let mut hasher = Sha256::new();
    for block in 0..4 {
        let mut requested = [0_u64; Q87_ENERGY_WORDS];
        for defect in 0..=total_defect {
            let value = usize::from(bases[block] + step * defect);
            requested[value / 64] |= 1_u64 << (value % 64);
        }
        let report = census_g41_q87_exact_energies(
            masks[block],
            digits[block],
            q29_coefficients[block],
            requested,
        )?;
        for defect in 0..=total_defect {
            let value = usize::from(bases[block] + step * defect);
            if support_has(&report.realized_energy_support, value) {
                allowed_defect_masks[block] |= 1_u8 << defect;
            } else if !report.exhaustive {
                return Err(G41Q87ExactEnergyError::SemanticMismatch);
            }
        }
        hasher.update([report.mask]);
        hasher.update(report.digits.to_le_bytes());
        hasher.update(report.q29_coefficients);
        hasher.update(report.left_slots);
        hasher.update(report.right_slots);
        for word in report.realized_energy_support {
            hasher.update(word.to_le_bytes());
        }
        hasher.update([u8::from(report.exhaustive)]);
    }
    Ok(G41Q87ExactLiftProof {
        extractor_digest: Sha256::digest(EXACT_EXTRACTOR_IDENTITY.as_bytes()).into(),
        source_digest: hasher.finalize().into(),
        allowed_defect_masks,
        compatible_energy_quartets: compatible_defect_quartets(allowed_defect_masks, total_defect),
    })
}

pub fn verify_g41_q87_exact_lift_proof(
    proof: &G41Q87ExactLiftProof,
    masks: [u8; 4],
    digits: [u32; 4],
    q29_coefficients: [[u8; COORDINATES]; 4],
) -> Result<bool, G41Q87ExactEnergyError> {
    Ok(*proof == issue_g41_q87_exact_lift_proof(masks, digits, q29_coefficients)?)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn packed_projection_and_energy_match_direct_three_lift_arithmetic() {
        let values = [
            [1_u8, 2, 3],
            [4, 1, 0],
            [0, 0, 0],
            [2, 2, 2],
            [1, 0, 1],
            [3, 2, 1],
            [0, 4, 2],
            [1, 1, 0],
        ];
        let mut state = 0_u128;
        for coordinate in 0..COORDINATES {
            for lift in 0..LIFTS {
                state |= u128::from(values[coordinate][lift])
                    << (LANE_BITS * (coordinate * LIFTS + lift) as u32);
            }
        }
        assert_eq!(
            projection(state),
            values.map(|triple| triple.into_iter().sum::<u8>())
        );
        let direct: usize = values
            .into_iter()
            .enumerate()
            .map(|(coordinate, [a, b, c])| {
                let [a, b, c] = [a, b, c].map(i32::from);
                let local = a * a + b * b + c * c - a * b - b * c - c * a;
                (if coordinate == 0 { local } else { 4 * local }) as usize
            })
            .sum();
        assert_eq!(energy_from_locals(local_energies(state)), direct);
    }

    #[test]
    fn exact_lift_masks_reduce_the_four_token_endgame_to_eleven_quartets() {
        assert_eq!(
            compatible_defect_quartets([0b1_1110, 0b1_1111, 0b1_1001, 0b1_1111], 4),
            11
        );
    }
}
