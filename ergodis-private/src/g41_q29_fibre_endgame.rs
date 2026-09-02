//! Exact full-PAF endgames inside one q29-preserving fine-orbit fibre.

use serde::Serialize;
use thiserror::Error;

use crate::cyclic_quotient_defects::{
    mine_cyclic_quotient_obstruction, supplementary_quotient_residual, CyclicQuotientDefectError,
    CyclicQuotientObstruction, QuotientCoefficients,
};
use crate::g41_joint_quotient_search::{
    census_g41_joint_full_mitm, replay_witness, G41JointQuotientWitness,
};
use crate::g41_q29_evolve::{
    compile_inventory, digit_counts, FineInventory, G41Q29Selection, Q29_COSETS,
};

const BLOCKS: usize = 4;
const SLOTS: usize = 6;
const CARRIER: usize = 522;
const SHIFTS: usize = CARRIER - 1;
const CARRIER_WORDS: usize = CARRIER.div_ceil(64);
const DUPLICATED_WORDS: usize = (2 * CARRIER).div_ceil(64) + 1;
const MAX_FIBRE_DIMENSION_PER_BLOCK: usize = 12;

#[derive(Clone, Debug, Error)]
pub enum G41Q29FibreEndgameError {
    #[error("q29 fibre endgame semantic binding failed")]
    SemanticMismatch,
    #[error("q29 fibre endgame exceeded its fixed state budget")]
    StateBudget,
    #[error(transparent)]
    Quotient(#[from] crate::g41_joint_quotient_search::G41JointQuotientSearchError),
    #[error(transparent)]
    Evolve(#[from] crate::g41_q29_evolve::G41Q29EvolveError),
    #[error(transparent)]
    CyclicQuotient(#[from] CyclicQuotientDefectError),
}

#[repr(C)]
#[derive(Clone, Copy, Default, PartialEq, Eq, PartialOrd, Ord)]
struct PairHashRecord {
    hash: u64,
    states: u32,
    _pad: u32,
}

const _: () = assert!(
    std::mem::size_of::<PairHashRecord>() == 16 && std::mem::align_of::<PairHashRecord>() == 8
);

struct BlockFibreTable {
    masks: Box<[[u16; SLOTS]]>,
    pafs: Box<[u16]>,
    hashes: Box<[u64]>,
    dimension: u8,
}

impl BlockFibreTable {
    fn states(&self) -> usize {
        self.masks.len()
    }

    fn paf(&self, state: usize) -> &[u16] {
        &self.pafs[state * SHIFTS..(state + 1) * SHIFTS]
    }
}

pub struct G41Q29FibrePairWorkspace {
    pairs: Vec<PairHashRecord>,
    capacity: usize,
}

/// Canonically compiled, reusable authority for exact q29-fibre endgames.
///
/// Construction authenticates the quotient survivor set and fine-orbit
/// inventory once. Individual selections are still checked against their
/// quotient witness, digit counts, and independently recomputed q29 defects.
pub struct G41Q29FibreEndgameContext {
    witnesses: Box<[G41JointQuotientWitness]>,
    inventory: FineInventory,
}

impl G41Q29FibreEndgameContext {
    pub fn prepare() -> Result<Self, G41Q29FibreEndgameError> {
        let quotient = census_g41_joint_full_mitm()?;
        Ok(Self {
            witnesses: quotient.witnesses,
            inventory: compile_inventory()?,
        })
    }

    pub fn solve(
        &self,
        selection: G41Q29Selection,
    ) -> Result<G41Q29FibreEndgameReport, G41Q29FibreEndgameError> {
        solve_g41_q29_selection_fibre_with_context(self, selection)
    }

    fn validated_witness(
        &self,
        selection: &G41Q29Selection,
    ) -> Result<G41JointQuotientWitness, G41Q29FibreEndgameError> {
        let root = self
            .witnesses
            .iter()
            .find(|witness| witness.root_id == selection.root_id)
            .ok_or(G41Q29FibreEndgameError::SemanticMismatch)?;
        let witness = G41JointQuotientWitness {
            root_id: root.root_id,
            masks: root.masks,
            digits: selection.digits,
        };
        replay_witness(&witness)?;
        for block in 0..BLOCKS {
            let counts = digit_counts(selection.digits[block]);
            for slot in 0..SLOTS {
                let mask = selection.orbit_masks[block * SLOTS + slot];
                if mask >> self.inventory.large_len[slot] != 0
                    || mask.count_ones() != u32::from(counts[slot])
                {
                    return Err(G41Q29FibreEndgameError::SemanticMismatch);
                }
            }
        }
        if !selection_has_zero_q29_defect(&witness, &self.inventory, selection) {
            return Err(G41Q29FibreEndgameError::SemanticMismatch);
        }
        Ok(witness)
    }

    pub fn quotient_defect_totals<const D: usize>(
        &self,
        selection: G41Q29Selection,
    ) -> Result<[i32; D], G41Q29FibreEndgameError> {
        let witness = self.validated_witness(&selection)?;
        let mut totals = [0_i32; D];
        for block in 0..BLOCKS {
            let bits = block_word(
                &witness,
                &self.inventory,
                block,
                std::array::from_fn(|slot| selection.orbit_masks[block * SLOTS + slot]),
            );
            let word: [u8; CARRIER] = std::array::from_fn(|position| {
                ((bits[position / 64] >> (position % 64)) & 1) as u8
            });
            let quotient = QuotientCoefficients::<D>::compile(&word)?;
            let mut defects = [0_i32; D];
            quotient.defects_into(&mut defects)?;
            for shift in 1..D {
                totals[shift] = totals[shift]
                    .checked_add(defects[shift])
                    .ok_or(G41Q29FibreEndgameError::StateBudget)?;
            }
        }
        Ok(totals)
    }

    pub fn quotient_residual<const D: usize>(
        &self,
        selection: G41Q29Selection,
    ) -> Result<u64, G41Q29FibreEndgameError> {
        let witness = self.validated_witness(&selection)?;
        let mut words = [[0_u8; CARRIER]; BLOCKS];
        for block in 0..BLOCKS {
            let bits = block_word(
                &witness,
                &self.inventory,
                block,
                std::array::from_fn(|slot| selection.orbit_masks[block * SLOTS + slot]),
            );
            for position in 0..CARRIER {
                words[block][position] = ((bits[position / 64] >> (position % 64)) & 1) as u8;
            }
        }
        let quotients = [
            QuotientCoefficients::<D>::compile(&words[0])?,
            QuotientCoefficients::<D>::compile(&words[1])?,
            QuotientCoefficients::<D>::compile(&words[2])?,
            QuotientCoefficients::<D>::compile(&words[3])?,
        ];
        Ok(supplementary_quotient_residual(&quotients, 1_043, 520)?)
    }

    pub fn mine_quotient_obstruction(
        &self,
        selection: G41Q29Selection,
        maximum_modulus: usize,
        blindness_level: u8,
    ) -> Result<Option<CyclicQuotientObstruction>, G41Q29FibreEndgameError> {
        let witness = self.validated_witness(&selection)?;
        let mut words = [[0_u8; CARRIER]; BLOCKS];
        for block in 0..BLOCKS {
            let bits = block_word(
                &witness,
                &self.inventory,
                block,
                std::array::from_fn(|slot| selection.orbit_masks[block * SLOTS + slot]),
            );
            for position in 0..CARRIER {
                words[block][position] = ((bits[position / 64] >> (position % 64)) & 1) as u8;
            }
        }
        Ok(mine_cyclic_quotient_obstruction(
            &words,
            1_043,
            520,
            maximum_modulus,
            blindness_level,
        )?)
    }

    pub fn solve_quotient_fibre<const D: usize>(
        &self,
        selection: G41Q29Selection,
    ) -> Result<G41QuotientFibreEndgameReport, G41Q29FibreEndgameError> {
        let witness = self.validated_witness(&selection)?;
        let tables = [
            compile_block_quotient_fibre::<D>(&witness, &self.inventory, &selection, 0)?,
            compile_block_quotient_fibre::<D>(&witness, &self.inventory, &selection, 1)?,
            compile_block_quotient_fibre::<D>(&witness, &self.inventory, &selection, 2)?,
            compile_block_quotient_fibre::<D>(&witness, &self.inventory, &selection, 3)?,
        ];
        let dimensions = std::array::from_fn(|block| tables[block].dimension);
        let block_states_before_budget =
            std::array::from_fn(|block| tables[block].states_before_budget);
        let block_states_after_budget = std::array::from_fn(|block| tables[block].states() as u32);
        let left_pairs = tables[0]
            .states()
            .checked_mul(tables[2].states())
            .ok_or(G41Q29FibreEndgameError::StateBudget)?;
        let mut workspace = G41Q29FibrePairWorkspace::new(left_pairs.max(1))?;
        let table_refs = [&tables[0], &tables[1], &tables[2], &tables[3]];
        let (hit_states, hash_ranges_replayed, full_profiles_replayed) =
            join_quotient_tables_into::<D>(table_refs, &mut workspace)?;
        let hit = hit_states.map(|states| {
            let mut orbit_masks = [0_u16; 24];
            for block in 0..BLOCKS {
                orbit_masks[block * SLOTS..(block + 1) * SLOTS]
                    .copy_from_slice(&tables[block].masks[states[block]]);
            }
            G41Q29Selection {
                root_id: selection.root_id,
                digits: selection.digits,
                orbit_masks,
            }
        });
        if let Some(candidate) = hit {
            if self.quotient_residual::<D>(candidate)? != 0 {
                return Err(G41Q29FibreEndgameError::SemanticMismatch);
            }
        }
        Ok(G41QuotientFibreEndgameReport {
            modulus: D as u16,
            root_id: selection.root_id,
            dimensions,
            block_states_before_budget,
            block_states_after_budget,
            left_pair_hashes: left_pairs as u64,
            right_pairs_probed: (tables[1].states() * tables[3].states()) as u64,
            hash_ranges_replayed,
            full_profiles_replayed,
            workspace_bytes: workspace.bytes(),
            hit,
            provenance: "exact mixed cyclic-quotient endgame inside one authenticated q29 fibre; every binary orientation is enumerated iteratively, per-block nonnegative defects above 523 are discarded, an additive u64 fingerprint only adds exact replay work, and every hash match is checked over the complete quotient profile",
        })
    }
}

impl G41Q29FibrePairWorkspace {
    pub fn new(capacity: usize) -> Result<Self, G41Q29FibreEndgameError> {
        if capacity == 0 || capacity > u32::MAX as usize {
            return Err(G41Q29FibreEndgameError::StateBudget);
        }
        Ok(Self {
            pairs: Vec::with_capacity(capacity),
            capacity,
        })
    }

    pub fn bytes(&self) -> u64 {
        (self.capacity * std::mem::size_of::<PairHashRecord>()) as u64
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29FibreEndgameReport {
    pub root_id: u32,
    pub dimensions: [u8; 4],
    pub block_states: [u32; 4],
    pub left_pair_hashes: u64,
    pub distinct_left_hashes: u64,
    pub right_pairs_probed: u64,
    pub hash_ranges_replayed: u64,
    pub full_vectors_replayed: u64,
    pub workspace_bytes: u64,
    pub hit: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

fn hash_paf(values: &[u16]) -> u64 {
    let mut hash = 0_u64;
    for (index, &value) in values.iter().enumerate() {
        let coordinate = index as u64 + 1;
        let weight = coordinate
            .wrapping_mul(0x9e37_79b9_7f4a_7c15)
            .rotate_left(17);
        hash = hash.wrapping_add(u64::from(value).wrapping_mul(weight));
    }
    hash
}

fn selection_has_zero_q29_defect(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    selection: &G41Q29Selection,
) -> bool {
    let mut totals = [0_u32; 7];
    for block in 0..BLOCKS {
        let mut coefficients = [0_u16; 29];
        for slot in 0..SLOTS {
            let mut add = |histogram: &[u8; 29]| {
                for coordinate in 0..29 {
                    coefficients[coordinate] += u16::from(histogram[coordinate]);
                }
            };
            if witness.masks[block] & (1 << slot) != 0 {
                add(&inventory.small[slot].residue_histogram);
            }
            let selected = selection.orbit_masks[block * SLOTS + slot];
            for orbit in 0..inventory.large_len[slot] {
                if selected & (1 << orbit) != 0 {
                    add(&inventory.large[slot][usize::from(orbit)].residue_histogram);
                }
            }
        }
        for class in 0..7 {
            let shift = Q29_COSETS[class][0];
            let mut doubled = 0_u32;
            for coordinate in 0..29 {
                let difference =
                    coefficients[coordinate].abs_diff(coefficients[(coordinate + shift) % 29]);
                doubled += u32::from(difference) * u32::from(difference);
            }
            if doubled & 1 != 0 {
                return false;
            }
            totals[class] += doubled / 2;
        }
    }
    totals == [523; 7]
}

fn block_word(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    block: usize,
    masks: [u16; SLOTS],
) -> [u64; CARRIER_WORDS] {
    let mut word = [0_u64; CARRIER_WORDS];
    for slot in 0..SLOTS {
        let mut apply = |points: &[u16]| {
            for &point in points {
                let point = usize::from(point);
                word[point / 64] |= 1_u64 << (point % 64);
            }
        };
        if witness.masks[block] & (1 << slot) != 0 {
            let orbit = &inventory.small[slot];
            apply(&orbit.points[..usize::from(orbit.len)]);
        }
        for orbit in 0..inventory.large_len[slot] {
            if masks[slot] & (1 << orbit) != 0 {
                let orbit = &inventory.large[slot][orbit as usize];
                apply(&orbit.points[..usize::from(orbit.len)]);
            }
        }
    }
    word
}

fn block_paf(word: &[u64; CARRIER_WORDS], output: &mut [u16]) {
    // Materialize two consecutive copies so every cyclic 64-bit window is two
    // shifts and one OR. The sentinel word makes the final unaligned load
    // unconditional. All storage is fixed-size and stack-resident.
    let mut duplicated = [0_u64; DUPLICATED_WORDS];
    for position in 0..CARRIER {
        if word[position / 64] & (1_u64 << (position % 64)) != 0 {
            duplicated[position / 64] |= 1_u64 << (position % 64);
            let copy = position + CARRIER;
            duplicated[copy / 64] |= 1_u64 << (copy % 64);
        }
    }
    for shift in 1..CARRIER {
        let mut paf = 0_u16;
        for (word_index, &source) in word.iter().enumerate() {
            let start = word_index * 64 + shift;
            let index = start / 64;
            let offset = start % 64;
            let mut shifted = duplicated[index] >> offset;
            if offset != 0 {
                shifted |= duplicated[index + 1] << (64 - offset);
            }
            paf += (source & shifted).count_ones() as u16;
        }
        output[shift - 1] = paf;
    }
}

fn fibre_variables(
    inventory: &FineInventory,
    selection: &G41Q29Selection,
    block: usize,
) -> Result<
    (
        [u8; MAX_FIBRE_DIMENSION_PER_BLOCK],
        [u16; MAX_FIBRE_DIMENSION_PER_BLOCK],
        usize,
    ),
    G41Q29FibreEndgameError,
> {
    let mut variable_slots = [0_u8; MAX_FIBRE_DIMENSION_PER_BLOCK];
    let mut variable_masks = [0_u16; MAX_FIBRE_DIMENSION_PER_BLOCK];
    let mut dimension = 0_usize;
    for slot in 0..SLOTS {
        let len = usize::from(inventory.large_len[slot]);
        let mut grouped = [false; 14];
        for first in 0..len {
            if grouped[first] {
                continue;
            }
            let signature = inventory.large[slot][first].residue_histogram;
            let mut group_mask = 0_u16;
            for second in first..len {
                if inventory.large[slot][second].residue_histogram == signature {
                    grouped[second] = true;
                    group_mask |= 1_u16 << second;
                }
            }
            let group_size = group_mask.count_ones();
            if group_size != 1 && group_size != 2 {
                return Err(G41Q29FibreEndgameError::SemanticMismatch);
            }
            if group_size == 2
                && (selection.orbit_masks[block * SLOTS + slot] & group_mask).count_ones() == 1
            {
                if dimension == MAX_FIBRE_DIMENSION_PER_BLOCK {
                    return Err(G41Q29FibreEndgameError::StateBudget);
                }
                variable_slots[dimension] = slot as u8;
                variable_masks[dimension] = group_mask;
                dimension += 1;
            }
        }
    }
    Ok((variable_slots, variable_masks, dimension))
}

fn compile_block_fibre(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    selection: &G41Q29Selection,
    block: usize,
) -> Result<BlockFibreTable, G41Q29FibreEndgameError> {
    let (variable_slots, variable_masks, dimension) = fibre_variables(inventory, selection, block)?;
    let states = 1_usize << dimension;
    let mut masks = Vec::with_capacity(states);
    let mut pafs = vec![0_u16; states * SHIFTS];
    let mut hashes = Vec::with_capacity(states);
    let baseline: [u16; SLOTS] =
        std::array::from_fn(|slot| selection.orbit_masks[block * SLOTS + slot]);
    for state in 0..states {
        let mut state_masks = baseline;
        for variable in 0..dimension {
            if state & (1 << variable) != 0 {
                state_masks[usize::from(variable_slots[variable])] ^= variable_masks[variable];
            }
        }
        let word = block_word(witness, inventory, block, state_masks);
        let row_sum = word
            .iter()
            .map(|value| value.count_ones() as u16)
            .sum::<u16>();
        let expected = if block == 0 { 260 } else { 261 };
        if row_sum != expected {
            return Err(G41Q29FibreEndgameError::SemanticMismatch);
        }
        block_paf(&word, &mut pafs[state * SHIFTS..(state + 1) * SHIFTS]);
        let hash = hash_paf(&pafs[state * SHIFTS..(state + 1) * SHIFTS]);
        masks.push(state_masks);
        hashes.push(hash);
    }
    Ok(BlockFibreTable {
        masks: masks.into_boxed_slice(),
        pafs: pafs.into_boxed_slice(),
        hashes: hashes.into_boxed_slice(),
        dimension: dimension as u8,
    })
}

fn full_vector_matches(tables: [&BlockFibreTable; BLOCKS], states: [usize; BLOCKS]) -> bool {
    (0..SHIFTS).all(|shift| {
        (0..BLOCKS)
            .map(|block| u32::from(tables[block].paf(states[block])[shift]))
            .sum::<u32>()
            == 520
    })
}

fn join_tables_into(
    tables: [&BlockFibreTable; BLOCKS],
    workspace: &mut G41Q29FibrePairWorkspace,
) -> Result<(Option<[usize; BLOCKS]>, u64, u64), G41Q29FibreEndgameError> {
    let left_pairs = tables[0]
        .states()
        .checked_mul(tables[2].states())
        .ok_or(G41Q29FibreEndgameError::StateBudget)?;
    if left_pairs > workspace.capacity {
        return Err(G41Q29FibreEndgameError::StateBudget);
    }
    workspace.pairs.clear();
    for first in 0..tables[0].states() {
        for second in 0..tables[2].states() {
            workspace.pairs.push(PairHashRecord {
                hash: tables[0].hashes[first].wrapping_add(tables[2].hashes[second]),
                states: first as u32 | ((second as u32) << 16),
                _pad: 0,
            });
        }
    }
    workspace.pairs.sort_unstable();
    let target = hash_paf(&[520_u16; SHIFTS]);
    let mut hash_ranges_replayed = 0_u64;
    let mut full_vectors_replayed = 0_u64;
    for first in 0..tables[1].states() {
        for second in 0..tables[3].states() {
            let needed = target
                .wrapping_sub(tables[1].hashes[first])
                .wrapping_sub(tables[3].hashes[second]);
            let start = workspace
                .pairs
                .partition_point(|record| record.hash < needed);
            let end = workspace
                .pairs
                .partition_point(|record| record.hash <= needed);
            if start != end {
                hash_ranges_replayed += 1;
            }
            for record in &workspace.pairs[start..end] {
                full_vectors_replayed += 1;
                let states = [
                    (record.states & 0xffff) as usize,
                    first,
                    (record.states >> 16) as usize,
                    second,
                ];
                if full_vector_matches(tables, states) {
                    return Ok((Some(states), hash_ranges_replayed, full_vectors_replayed));
                }
            }
        }
    }
    Ok((None, hash_ranges_replayed, full_vectors_replayed))
}

struct BlockQuotientFibreTable {
    masks: Box<[[u16; SLOTS]]>,
    defects: Box<[u16]>,
    hashes: Box<[u64]>,
    dimension: u8,
    states_before_budget: u32,
}

impl BlockQuotientFibreTable {
    fn states(&self) -> usize {
        self.masks.len()
    }

    fn defects<const D: usize>(&self, state: usize) -> &[u16] {
        &self.defects[state * (D - 1)..(state + 1) * (D - 1)]
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41QuotientFibreEndgameReport {
    pub modulus: u16,
    pub root_id: u32,
    pub dimensions: [u8; BLOCKS],
    pub block_states_before_budget: [u32; BLOCKS],
    pub block_states_after_budget: [u32; BLOCKS],
    pub left_pair_hashes: u64,
    pub right_pairs_probed: u64,
    pub hash_ranges_replayed: u64,
    pub full_profiles_replayed: u64,
    pub workspace_bytes: u64,
    pub hit: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

fn compile_block_quotient_fibre<const D: usize>(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    selection: &G41Q29Selection,
    block: usize,
) -> Result<BlockQuotientFibreTable, G41Q29FibreEndgameError> {
    if D < 2 || !CARRIER.is_multiple_of(D) {
        return Err(G41Q29FibreEndgameError::SemanticMismatch);
    }
    let (variable_slots, variable_masks, dimension) = fibre_variables(inventory, selection, block)?;
    let states = 1_usize << dimension;
    let baseline: [u16; SLOTS] =
        std::array::from_fn(|slot| selection.orbit_masks[block * SLOTS + slot]);
    let mut masks = Vec::with_capacity(states);
    let mut defects = Vec::with_capacity(states * (D - 1));
    let mut hashes = Vec::with_capacity(states);
    let mut coefficients = [0_u16; D];
    let mut profile = [0_u16; D];
    for state in 0..states {
        let mut state_masks = baseline;
        for variable in 0..dimension {
            if state & (1 << variable) != 0 {
                state_masks[usize::from(variable_slots[variable])] ^= variable_masks[variable];
            }
        }
        let word = block_word(witness, inventory, block, state_masks);
        coefficients.fill(0);
        for position in 0..CARRIER {
            if word[position / 64] & (1_u64 << (position % 64)) != 0 {
                coefficients[position % D] += 1;
            }
        }
        let zero: u32 = coefficients
            .iter()
            .map(|&value| u32::from(value) * u32::from(value))
            .sum();
        let mut within_budget = true;
        for shift in 1..D {
            let shifted: u32 = (0..D)
                .map(|residue| {
                    u32::from(coefficients[residue])
                        * u32::from(coefficients[(residue + shift) % D])
                })
                .sum();
            let value = zero
                .checked_sub(shifted)
                .ok_or(G41Q29FibreEndgameError::SemanticMismatch)?;
            if value > 523 {
                within_budget = false;
                break;
            }
            profile[shift] = value as u16;
        }
        if !within_budget {
            continue;
        }
        masks.push(state_masks);
        defects.extend_from_slice(&profile[1..]);
        hashes.push(hash_paf(&profile[1..]));
    }
    Ok(BlockQuotientFibreTable {
        masks: masks.into_boxed_slice(),
        defects: defects.into_boxed_slice(),
        hashes: hashes.into_boxed_slice(),
        dimension: dimension as u8,
        states_before_budget: states as u32,
    })
}

fn quotient_profiles_match<const D: usize>(
    tables: [&BlockQuotientFibreTable; BLOCKS],
    states: [usize; BLOCKS],
) -> bool {
    (0..D - 1).all(|coordinate| {
        (0..BLOCKS)
            .map(|block| u32::from(tables[block].defects::<D>(states[block])[coordinate]))
            .sum::<u32>()
            == 523
    })
}

fn join_quotient_tables_into<const D: usize>(
    tables: [&BlockQuotientFibreTable; BLOCKS],
    workspace: &mut G41Q29FibrePairWorkspace,
) -> Result<(Option<[usize; BLOCKS]>, u64, u64), G41Q29FibreEndgameError> {
    let left_pairs = tables[0]
        .states()
        .checked_mul(tables[2].states())
        .ok_or(G41Q29FibreEndgameError::StateBudget)?;
    if left_pairs == 0 || left_pairs > workspace.capacity {
        return Ok((None, 0, 0));
    }
    workspace.pairs.clear();
    for first in 0..tables[0].states() {
        for second in 0..tables[2].states() {
            workspace.pairs.push(PairHashRecord {
                hash: tables[0].hashes[first].wrapping_add(tables[2].hashes[second]),
                states: first as u32 | ((second as u32) << 16),
                _pad: 0,
            });
        }
    }
    workspace.pairs.sort_unstable();
    let target = hash_paf(&[523_u16; D][1..]);
    let mut hash_ranges_replayed = 0_u64;
    let mut full_profiles_replayed = 0_u64;
    for first in 0..tables[1].states() {
        for second in 0..tables[3].states() {
            let needed = target
                .wrapping_sub(tables[1].hashes[first])
                .wrapping_sub(tables[3].hashes[second]);
            let start = workspace
                .pairs
                .partition_point(|record| record.hash < needed);
            let end = workspace
                .pairs
                .partition_point(|record| record.hash <= needed);
            if start != end {
                hash_ranges_replayed += 1;
            }
            for record in &workspace.pairs[start..end] {
                full_profiles_replayed += 1;
                let states = [
                    (record.states & 0xffff) as usize,
                    first,
                    (record.states >> 16) as usize,
                    second,
                ];
                if quotient_profiles_match::<D>(tables, states) {
                    return Ok((Some(states), hash_ranges_replayed, full_profiles_replayed));
                }
            }
        }
    }
    Ok((None, hash_ranges_replayed, full_profiles_replayed))
}

fn solve_g41_q29_selection_fibre_with_context(
    context: &G41Q29FibreEndgameContext,
    selection: G41Q29Selection,
) -> Result<G41Q29FibreEndgameReport, G41Q29FibreEndgameError> {
    let witness = context.validated_witness(&selection)?;
    let inventory = &context.inventory;
    let tables = [
        compile_block_fibre(&witness, inventory, &selection, 0)?,
        compile_block_fibre(&witness, inventory, &selection, 1)?,
        compile_block_fibre(&witness, inventory, &selection, 2)?,
        compile_block_fibre(&witness, inventory, &selection, 3)?,
    ];
    let block_states = std::array::from_fn(|block| tables[block].states() as u32);
    let dimensions = std::array::from_fn(|block| tables[block].dimension);
    let left_pairs = tables[0]
        .states()
        .checked_mul(tables[2].states())
        .ok_or(G41Q29FibreEndgameError::StateBudget)?;
    let mut workspace = G41Q29FibrePairWorkspace::new(left_pairs)?;
    let table_refs = [&tables[0], &tables[1], &tables[2], &tables[3]];
    let (hit_states, hash_ranges_replayed, full_vectors_replayed) =
        join_tables_into(table_refs, &mut workspace)?;
    let hit = hit_states.map(|states| {
        let mut orbit_masks = [0_u16; 24];
        for block in 0..BLOCKS {
            orbit_masks[block * SLOTS..(block + 1) * SLOTS]
                .copy_from_slice(&tables[block].masks[states[block]]);
        }
        G41Q29Selection {
            root_id: selection.root_id,
            digits: selection.digits,
            orbit_masks,
        }
    });
    let distinct_left_hashes = workspace
        .pairs
        .windows(2)
        .filter(|pair| pair[0].hash != pair[1].hash)
        .count()
        + usize::from(!workspace.pairs.is_empty());
    Ok(G41Q29FibreEndgameReport {
        root_id: selection.root_id,
        dimensions,
        block_states,
        left_pair_hashes: workspace.pairs.len() as u64,
        distinct_left_hashes: distinct_left_hashes as u64,
        right_pairs_probed: (tables[1].states() * tables[3].states()) as u64,
        hash_ranges_replayed,
        full_vectors_replayed,
        workspace_bytes: workspace.bytes(),
        hit,
        provenance: "exact full-PAF MITM inside one q29-preserving orbit fibre; block tables enumerate every duplicate-orbit choice, one additive u64 fingerprint can only add collision replay, and every matching hash range is checked across all 521 original PAF coordinates",
    })
}

pub fn solve_g41_q29_selection_fibre(
    selection: G41Q29Selection,
) -> Result<G41Q29FibreEndgameReport, G41Q29FibreEndgameError> {
    G41Q29FibreEndgameContext::prepare()?.solve(selection)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn direct_paf(word: &[u64; CARRIER_WORDS]) -> [u16; SHIFTS] {
        let mut output = [0_u16; SHIFTS];
        for shift in 1..CARRIER {
            for position in 0..CARRIER {
                let first = word[position / 64] >> (position % 64) & 1;
                let second_position = (position + shift) % CARRIER;
                let second = word[second_position / 64] >> (second_position % 64) & 1;
                output[shift - 1] += (first & second) as u16;
            }
        }
        output
    }

    #[test]
    fn packed_paf_matches_direct_cyclic_oracle() {
        let mut seed = 0x8c67_5f19_d2a4_b30e_u64;
        for case in 0..8 {
            let mut word = [0_u64; CARRIER_WORDS];
            for position in 0..CARRIER {
                seed ^= seed << 13;
                seed ^= seed >> 7;
                seed ^= seed << 17;
                if seed & 3 == 0 {
                    word[position / 64] |= 1_u64 << (position % 64);
                }
            }
            // Force coverage of both sides of the non-word-aligned cyclic seam.
            word[0] |= 1;
            word[(CARRIER - 1) / 64] |= 1_u64 << ((CARRIER - 1) % 64);
            let expected = direct_paf(&word);
            let mut actual = [0_u16; SHIFTS];
            let ((), allocations) = tracked_allocations(|| block_paf(&word, &mut actual));
            assert_eq!(actual, expected, "case {case}");
            assert_eq!(allocations, 0);
        }
    }

    fn table(vectors: &[[u16; 3]]) -> BlockFibreTable {
        let mut pafs = Vec::new();
        let mut hashes = Vec::new();
        for vector in vectors {
            let mut expanded = [0_u16; SHIFTS];
            expanded[..3].copy_from_slice(vector);
            let hash = hash_paf(&expanded);
            pafs.extend_from_slice(&expanded);
            hashes.push(hash);
        }
        BlockFibreTable {
            masks: vec![[0; 6]; vectors.len()].into_boxed_slice(),
            pafs: pafs.into_boxed_slice(),
            hashes: hashes.into_boxed_slice(),
            dimension: 0,
        }
    }

    #[test]
    fn pair_hash_join_has_zero_hot_allocations() {
        let a = table(&[[100, 100, 100], [101, 99, 100]]);
        let b = table(&[[120, 120, 120], [123, 123, 123]]);
        let c = table(&[[177, 177, 177], [180, 180, 180]]);
        let d = table(&[[123, 123, 123], [120, 120, 120]]);
        let mut workspace = G41Q29FibrePairWorkspace::new(4).unwrap();
        let (result, allocations) =
            tracked_allocations(|| join_tables_into([&a, &b, &c, &d], &mut workspace));
        assert!(result.unwrap().0.is_none());
        assert_eq!(allocations, 0);
    }
}
