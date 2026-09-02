//! Exact sparse-background q0 scout for the private g41 order-2092 shard.
//!
//! The Z18 multiplier projection has six quotient slots of multiplicities
//! `1,1,2,2,6,6`.  The singleton slots have `B=e+4k`; the others have
//! `B=e+2k`.  Relative to their minimum signed square energies 9 and 1, the
//! quotient q0 identity has exact defect budget 230.  This module compiles the
//! resulting bounded six-digit domains and directly replays every survivor.

use serde::Serialize;
use thiserror::Error;

use crate::hadamard_2092::CyclicMultiplierOrbitPartition;

const CARRIER: usize = 522;
const QUOTIENT: usize = 18;
const SLOTS: usize = 6;
const SHIFTS: usize = 10;
const DEFECT_TARGET: usize = 230;
const MAX_DOMAIN_PROFILES: usize = 8_192;
const MAX_Q1_PAIR_PROFILES: usize = 8_192;
const MULTIPLICITIES: [u16; SLOTS] = [1, 1, 2, 2, 6, 6];
const SCALES: [u16; SLOTS] = [4, 4, 2, 2, 2, 2];
const RADICES: [u8; SLOTS] = [8, 8, 15, 15, 15, 15];
const SHIFTS_PACK: [u8; SLOTS] = [0, 3, 6, 10, 14, 18];
const SLOT_RESIDUES: [&[usize]; SLOTS] = [
    &[0],
    &[9],
    &[6, 12],
    &[3, 15],
    &[2, 4, 8, 10, 14, 16],
    &[1, 5, 7, 11, 13, 17],
];

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct BinaryProfile {
    signature: u16,
    mask: u8,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct BinaryPair {
    signature: u16,
    first: u8,
    second: u8,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q1Profile {
    q1: u16,
    energy: u8,
    reserved: u8,
    digits: u32,
}

const _: () =
    assert!(std::mem::size_of::<Q1Profile>() == 8 && std::mem::align_of::<Q1Profile>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q1PairProfile {
    q1: u16,
    first: u16,
    second: u16,
    energy: u8,
    reserved: u8,
}

const _: () = assert!(
    std::mem::size_of::<Q1PairProfile>() == 8 && std::mem::align_of::<Q1PairProfile>() == 2
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct ShiftProfile {
    state: u64,
    digits: u32,
    reserved: u32,
}

const _: () =
    assert!(std::mem::size_of::<ShiftProfile>() == 16 && std::mem::align_of::<ShiftProfile>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct ShiftPairProfile {
    state: u64,
    first: u16,
    second: u16,
    reserved: u32,
}

const _: () = assert!(
    std::mem::size_of::<ShiftPairProfile>() == 16 && std::mem::align_of::<ShiftPairProfile>() == 8
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct PairSlot {
    state: u64,
    witness: u32,
    reserved: u32,
}

const _: () =
    assert!(std::mem::size_of::<PairSlot>() == 16 && std::mem::align_of::<PairSlot>() == 8);

struct PairWorkspace {
    slots: Box<[PairSlot]>,
    touched: Vec<u32>,
}

impl PairWorkspace {
    const CAPACITY: usize = 1 << 20;
    const MAX_STATES: usize = Self::CAPACITY * 3 / 4;

    fn new() -> Result<Self, G41DefectScoutError> {
        let mut slots = Vec::new();
        slots
            .try_reserve_exact(Self::CAPACITY)
            .map_err(|_| G41DefectScoutError::StateBudget)?;
        slots.resize(
            Self::CAPACITY,
            PairSlot {
                state: u64::MAX,
                witness: 0,
                reserved: 0,
            },
        );
        let mut touched = Vec::new();
        touched
            .try_reserve_exact(Self::MAX_STATES)
            .map_err(|_| G41DefectScoutError::StateBudget)?;
        Ok(Self {
            slots: slots.into_boxed_slice(),
            touched,
        })
    }

    fn insert(&mut self, state: u64, witness: u32) -> Result<(), G41DefectScoutError> {
        let mut value = state;
        value ^= value >> 30;
        value = value.wrapping_mul(0xbf58_476d_1ce4_e5b9);
        value ^= value >> 27;
        value = value.wrapping_mul(0x94d0_49bb_1331_11eb);
        value ^= value >> 31;
        let mut slot = value as usize & (Self::CAPACITY - 1);
        loop {
            let entry = &mut self.slots[slot];
            if entry.state == state {
                return Ok(());
            }
            if entry.state == u64::MAX {
                if self.touched.len() == Self::MAX_STATES {
                    return Err(G41DefectScoutError::StateBudget);
                }
                entry.state = state;
                entry.witness = witness;
                self.touched.push(slot as u32);
                return Ok(());
            }
            slot = (slot + 1) & (Self::CAPACITY - 1);
        }
    }

    fn take_profiles(&mut self) -> Result<Box<[ShiftPairProfile]>, G41DefectScoutError> {
        let mut profiles = Vec::new();
        profiles
            .try_reserve_exact(self.touched.len())
            .map_err(|_| G41DefectScoutError::StateBudget)?;
        for &slot in &self.touched {
            let entry = &mut self.slots[slot as usize];
            profiles.push(ShiftPairProfile {
                state: entry.state,
                first: entry.witness as u16,
                second: (entry.witness >> 16) as u16,
                reserved: 0,
            });
            entry.state = u64::MAX;
        }
        self.touched.clear();
        profiles.sort_unstable_by_key(|profile| profile.state);
        Ok(profiles.into_boxed_slice())
    }

    fn clear(&mut self) {
        for &slot in &self.touched {
            self.slots[slot as usize].state = u64::MAX;
        }
        self.touched.clear();
    }
}

/// Allocation probe for the fixed pair-state insertion kernel. Construction
/// owns the bounded 16 MiB table; `exercise` performs no allocation.
pub struct G41PairWorkspaceProbe {
    workspace: PairWorkspace,
}

impl G41PairWorkspaceProbe {
    pub fn new() -> Result<Self, G41DefectScoutError> {
        Ok(Self {
            workspace: PairWorkspace::new()?,
        })
    }

    pub fn exercise(&mut self, iterations: u32) -> Result<u64, G41DefectScoutError> {
        if iterations as usize > PairWorkspace::MAX_STATES {
            return Err(G41DefectScoutError::StateBudget);
        }
        let mut checksum = 0_u64;
        for value in 0..iterations {
            let state = u64::from(value);
            self.workspace.insert(state, value)?;
            checksum ^= state;
        }
        self.workspace.clear();
        Ok(checksum)
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct ShiftClassWitness {
    states: [u64; 4],
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q1Key {
    energy: u8,
    q1: u16,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q1ClassWitness {
    keys: [Q1Key; 4],
}

#[derive(Clone, Debug, PartialEq, Eq)]
struct EnergyDomain {
    witnesses: [u32; DEFECT_TARGET + 1],
    energies: [u64; 4],
    configurations: u32,
    q1_profiles: Box<[Q1Profile]>,
    q1_hash: u64,
    shift_profiles: Option<Box<[ShiftProfile]>>,
    shift_hash: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41DefectScoutReport {
    pub mod2_roots: u64,
    pub constructive_q0_hits: u64,
    pub exhaustive_q0_misses: u64,
    pub block_domains_compiled: u16,
    pub minimum_domain_energies: u16,
    pub maximum_domain_energies: u16,
    pub minimum_domain_configurations: u32,
    pub maximum_domain_configurations: u32,
    pub total_domain_configurations: u64,
    pub minimum_domain_q1_profiles: u32,
    pub maximum_domain_q1_profiles: u32,
    pub total_domain_q1_profiles: u64,
    pub special_q1_classes: u16,
    pub zero_q1_classes: u16,
    pub minimum_q1_pair_profiles: u32,
    pub maximum_q1_pair_profiles: u32,
    pub total_q1_pair_profiles: u64,
    pub constructive_q1_hits: u64,
    pub exhaustive_q1_misses: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41DomainOracleReport {
    pub masks_checked: u16,
    pub raw_assignments_checked: u64,
    pub retained_configurations: u64,
    pub retained_q1_profiles: u64,
    pub mod2_roots: u64,
    pub constructive_q0_hits: u64,
    pub constructive_q1_hits: u64,
    pub retained_pair_profiles: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41ShiftProfileReport {
    pub shift: u8,
    pub block_domains_compiled: u16,
    pub minimum_domain_profiles: u32,
    pub maximum_domain_profiles: u32,
    pub total_domain_profiles: u64,
    pub special_classes: u16,
    pub zero_classes: u16,
    pub profile_bytes: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41ShiftDomainOracleReport {
    pub shift: u8,
    pub masks_checked: u16,
    pub raw_assignments_checked: u64,
    pub retained_profiles: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41ExactShiftReport {
    pub shift: u8,
    pub mod2_roots: u64,
    pub exact_shift_hits: u64,
    pub exact_shift_misses: u64,
    pub special_classes: u16,
    pub zero_classes: u16,
    pub compatible_class_quadruples: u32,
    pub minimum_pair_profiles: u32,
    pub maximum_pair_profiles: u32,
    pub total_pair_profiles: u64,
    pub retained_zero_pair_bytes: u64,
    pub surviving_root_ids: Box<[u32]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41QuotientFilterReport {
    pub representative_shifts: [u8; 6],
    pub mod2_roots: u64,
    pub individual_shift_hits: [u64; 4],
    pub necessary_filter_survivors: u64,
    pub necessary_filter_exclusions: u64,
    pub surviving_root_ids: Box<[u32]>,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41DefectScoutError {
    #[error("g41 Z18 multiplier projection is not canonical")]
    OrbitProjection,
    #[error("g41 bounded state budget exceeded")]
    StateBudget,
    #[error("g41 sparse arithmetic or direct replay failed")]
    SemanticMismatch,
    #[error("g41 direct row replay failed in block {block}: expected {expected}, got {actual}")]
    RowReplay {
        block: u8,
        expected: u16,
        actual: u16,
    },
    #[error("g41 direct q0 replay failed: expected 15603, got {actual}")]
    Q0Replay { actual: u32 },
    #[error("g41 direct q1 replay failed: expected 15080, got {actual}")]
    Q1Replay { actual: u32 },
    #[error("g41 q1 compatibility produced a witness without a q0 lift")]
    Q1WithoutQ0,
}

fn binary_word(mask: u8) -> [u16; QUOTIENT] {
    let mut word = [0_u16; QUOTIENT];
    for (slot, residues) in SLOT_RESIDUES.iter().enumerate() {
        for &residue in *residues {
            word[residue] = u16::from((mask >> slot) & 1);
        }
    }
    word
}

fn paf(word: &[u16; QUOTIENT], shift: usize) -> u32 {
    (0..QUOTIENT)
        .map(|position| u32::from(word[position] * word[(position + shift) % QUOTIENT]))
        .sum()
}

fn signature(word: &[u16; QUOTIENT]) -> u16 {
    let mut output = 0_u16;
    for shift in 0..SHIFTS {
        output |= ((paf(word, shift) & 1) as u16) << shift;
    }
    output
}

fn compile_binary_profiles(row_parity: u16) -> Vec<BinaryProfile> {
    let mut profiles = Vec::with_capacity(32);
    for mask in 0_u8..1 << SLOTS {
        let word = binary_word(mask);
        if word.iter().copied().sum::<u16>() & 1 == row_parity {
            profiles.push(BinaryProfile {
                signature: signature(&word),
                mask,
            });
        }
    }
    profiles
}

fn compile_mod2_frontier() -> (Vec<BinaryProfile>, Vec<BinaryProfile>, Vec<BinaryPair>) {
    let special = compile_binary_profiles(0);
    let zero = compile_binary_profiles(1);
    let mut right = Vec::with_capacity(zero.len() * zero.len());
    for first in &zero {
        for second in &zero {
            right.push(BinaryPair {
                signature: first.signature ^ second.signature,
                first: first.mask,
                second: second.mask,
            });
        }
    }
    right.sort_unstable();
    (special, zero, right)
}

fn defect_cost(slot: usize, base: u16, digit: u16) -> Result<u16, G41DefectScoutError> {
    let value = base + SCALES[slot] * digit;
    let signed = 2 * i32::from(value) - 29;
    let baseline = if slot < 2 { 9 } else { 1 };
    let excess = signed
        .checked_mul(signed)
        .and_then(|square| square.checked_sub(baseline))
        .ok_or(G41DefectScoutError::SemanticMismatch)?;
    if excess < 0 || excess % 8 != 0 {
        return Err(G41DefectScoutError::SemanticMismatch);
    }
    u16::try_from((excess / 8) * i32::from(MULTIPLICITIES[slot]))
        .map_err(|_| G41DefectScoutError::SemanticMismatch)
}

fn pack_digits(digits: &[u8; SLOTS]) -> u32 {
    let mut packed = 0_u32;
    for slot in 0..SLOTS {
        packed |= u32::from(digits[slot]) << SHIFTS_PACK[slot];
    }
    packed
}

fn decode_word(mask: u8, packed: u32) -> [u16; QUOTIENT] {
    let mut word = [0_u16; QUOTIENT];
    for (slot, residues) in SLOT_RESIDUES.iter().enumerate() {
        let bits = if slot < 2 { 3 } else { 4 };
        let digit = ((packed >> SHIFTS_PACK[slot]) & ((1 << bits) - 1)) as u16;
        let value = u16::from((mask >> slot) & 1) + SCALES[slot] * digit;
        for &residue in *residues {
            word[residue] = value;
        }
    }
    word
}

fn set_energy(bits: &mut [u64; 4], energy: usize) {
    bits[energy / 64] |= 1_u64 << (energy % 64);
}

fn has_energy(bits: &[u64; 4], energy: usize) -> bool {
    bits[energy / 64] & (1_u64 << (energy % 64)) != 0
}

fn compile_energy_domain(
    mask: u8,
    row_target: u16,
    extra_shift: Option<usize>,
) -> Result<EnergyDomain, G41DefectScoutError> {
    if extra_shift.is_some_and(|shift| !(2..SHIFTS).contains(&shift)) {
        return Err(G41DefectScoutError::StateBudget);
    }
    let mut next_digit = [0_u8; SLOTS];
    let mut chosen = [0_u8; SLOTS];
    let mut row_prefix = [0_u16; SLOTS + 1];
    let mut energy_prefix = [0_u16; SLOTS + 1];
    let mut maximum_remaining_row = [0_u16; SLOTS + 1];
    for slot in (0..SLOTS).rev() {
        maximum_remaining_row[slot] = maximum_remaining_row[slot + 1]
            + MULTIPLICITIES[slot]
                * (u16::from((mask >> slot) & 1) + SCALES[slot] * u16::from(RADICES[slot] - 1));
    }
    let mut witnesses = [u32::MAX; DEFECT_TARGET + 1];
    let mut energies = [0_u64; 4];
    let mut configurations = 0_u32;
    let mut q1_profiles = Vec::with_capacity(MAX_DOMAIN_PROFILES);
    let mut shift_profiles = Vec::<ShiftProfile>::with_capacity(MAX_DOMAIN_PROFILES);
    let mut depth = 0_usize;
    loop {
        if depth == SLOTS {
            if row_prefix[depth] == row_target {
                let energy = usize::from(energy_prefix[depth]);
                if energy <= DEFECT_TARGET {
                    configurations = configurations
                        .checked_add(1)
                        .ok_or(G41DefectScoutError::StateBudget)?;
                    let packed = pack_digits(&chosen);
                    let q1 = paf(&decode_word(mask, packed), 1);
                    if q1 >= 8_192 {
                        return Err(G41DefectScoutError::StateBudget);
                    }
                    if q1_profiles.len() == MAX_DOMAIN_PROFILES {
                        return Err(G41DefectScoutError::StateBudget);
                    }
                    q1_profiles.push(Q1Profile {
                        q1: q1 as u16,
                        energy: energy as u8,
                        reserved: 0,
                        digits: packed,
                    });
                    if let Some(shift) = extra_shift {
                        if shift_profiles.len() == MAX_DOMAIN_PROFILES {
                            return Err(G41DefectScoutError::StateBudget);
                        }
                        let value = paf(&decode_word(mask, packed), shift);
                        if value >= 8_192 {
                            return Err(G41DefectScoutError::StateBudget);
                        }
                        shift_profiles.push(ShiftProfile {
                            state: ((energy as u64) << 26)
                                | (u64::from(q1 as u16) << 13)
                                | u64::from(value),
                            digits: packed,
                            reserved: 0,
                        });
                    }
                    if witnesses[energy] == u32::MAX {
                        witnesses[energy] = packed;
                        set_energy(&mut energies, energy);
                    }
                }
            }
            depth -= 1;
            continue;
        }
        if next_digit[depth] == RADICES[depth] {
            next_digit[depth] = 0;
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        let digit = next_digit[depth];
        next_digit[depth] += 1;
        let base = u16::from((mask >> depth) & 1);
        let energy = defect_cost(depth, base, u16::from(digit))?;
        let Some(next_energy) = energy_prefix[depth].checked_add(energy) else {
            continue;
        };
        if usize::from(next_energy) > DEFECT_TARGET {
            continue;
        }
        let value = base + SCALES[depth] * u16::from(digit);
        let next_row = row_prefix[depth] + MULTIPLICITIES[depth] * value;
        if next_row > row_target || next_row + maximum_remaining_row[depth + 1] < row_target {
            continue;
        }
        chosen[depth] = digit;
        row_prefix[depth + 1] = next_row;
        energy_prefix[depth + 1] = next_energy;
        depth += 1;
    }
    q1_profiles.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    q1_profiles.dedup_by_key(|profile| (profile.energy, profile.q1));
    let mut q1_hash = 0xcbf2_9ce4_8422_2325_u64;
    for profile in &q1_profiles {
        q1_hash ^= u64::from(profile.energy) | (u64::from(profile.q1) << 8);
        q1_hash = q1_hash.wrapping_mul(0x100_0000_01b3);
    }
    let (shift_profiles, shift_hash) = if extra_shift.is_some() {
        shift_profiles.sort_unstable_by_key(|profile| profile.state);
        shift_profiles.dedup_by_key(|profile| profile.state);
        let mut hash = 0xcbf2_9ce4_8422_2325_u64;
        for profile in &shift_profiles {
            hash ^= profile.state;
            hash = hash.wrapping_mul(0x100_0000_01b3);
        }
        (Some(shift_profiles.into_boxed_slice()), hash)
    } else {
        (None, 0)
    };
    Ok(EnergyDomain {
        witnesses,
        energies,
        configurations,
        q1_profiles: q1_profiles.into_boxed_slice(),
        q1_hash,
        shift_profiles,
        shift_hash,
    })
}

fn pair_witness(first: &EnergyDomain, second: &EnergyDomain, target: usize) -> Option<(u32, u32)> {
    for energy in 0..=target {
        if has_energy(&first.energies, energy) && has_energy(&second.energies, target - energy) {
            return Some((first.witnesses[energy], second.witnesses[target - energy]));
        }
    }
    None
}

fn four_witness(domains: [&EnergyDomain; 4]) -> Option<[u32; 4]> {
    for left_energy in 0..=DEFECT_TARGET {
        let Some((first, second)) = pair_witness(domains[0], domains[1], left_energy) else {
            continue;
        };
        let Some((third, fourth)) =
            pair_witness(domains[2], domains[3], DEFECT_TARGET - left_energy)
        else {
            continue;
        };
        return Some([first, second, third, fourth]);
    }
    None
}

fn q1_domain_equal(left: &EnergyDomain, right: &EnergyDomain) -> bool {
    left.q1_profiles
        .iter()
        .map(|profile| (profile.energy, profile.q1))
        .eq(right
            .q1_profiles
            .iter()
            .map(|profile| (profile.energy, profile.q1)))
}

fn q1_class_representatives(
    domains: &[Option<EnergyDomain>],
) -> Result<Vec<&EnergyDomain>, G41DefectScoutError> {
    let mut representatives = Vec::<&EnergyDomain>::new();
    for domain in domains.iter().flatten() {
        if let Some(representative) = representatives
            .iter()
            .copied()
            .find(|candidate| candidate.q1_hash == domain.q1_hash)
        {
            if !q1_domain_equal(representative, domain) {
                return Err(G41DefectScoutError::SemanticMismatch);
            }
        } else {
            representatives.push(domain);
        }
    }
    Ok(representatives)
}

fn q1_class_map(
    domains: &[Option<EnergyDomain>],
    representatives: &[&EnergyDomain],
) -> Result<[u8; 1 << SLOTS], G41DefectScoutError> {
    let mut classes = [u8::MAX; 1 << SLOTS];
    for (mask, domain) in domains.iter().enumerate() {
        let Some(domain) = domain else {
            continue;
        };
        let class = representatives
            .iter()
            .position(|representative| {
                representative.q1_hash == domain.q1_hash && q1_domain_equal(representative, domain)
            })
            .ok_or(G41DefectScoutError::SemanticMismatch)?;
        classes[mask] = u8::try_from(class).map_err(|_| G41DefectScoutError::StateBudget)?;
    }
    Ok(classes)
}

fn compile_q1_pair_profiles(
    first: &EnergyDomain,
    second: &EnergyDomain,
    seen: &mut [u64],
) -> Result<Box<[Q1PairProfile]>, G41DefectScoutError> {
    seen.fill(0);
    let mut profiles = Vec::with_capacity(MAX_Q1_PAIR_PROFILES);
    for (first_index, left) in first.q1_profiles.iter().enumerate() {
        for (second_index, right) in second.q1_profiles.iter().enumerate() {
            let energy = u16::from(left.energy) + u16::from(right.energy);
            if usize::from(energy) > DEFECT_TARGET {
                continue;
            }
            let energy = energy as u8;
            let Some(q1) = left.q1.checked_add(right.q1) else {
                return Err(G41DefectScoutError::SemanticMismatch);
            };
            if usize::from(q1) >= 16_384 {
                return Err(G41DefectScoutError::StateBudget);
            }
            let state = usize::from(energy) * 16_384 + usize::from(q1);
            let bit = 1_u64 << (state % 64);
            if seen[state / 64] & bit == 0 {
                if profiles.len() == MAX_Q1_PAIR_PROFILES {
                    return Err(G41DefectScoutError::StateBudget);
                }
                seen[state / 64] |= bit;
                profiles.push(Q1PairProfile {
                    q1,
                    first: u16::try_from(first_index)
                        .map_err(|_| G41DefectScoutError::StateBudget)?,
                    second: u16::try_from(second_index)
                        .map_err(|_| G41DefectScoutError::StateBudget)?,
                    energy,
                    reserved: 0,
                });
            }
        }
    }
    profiles.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    Ok(profiles.into_boxed_slice())
}

fn q1_key(domain: &EnergyDomain, index: u16) -> Result<Q1Key, G41DefectScoutError> {
    let profile = domain
        .q1_profiles
        .get(usize::from(index))
        .ok_or(G41DefectScoutError::SemanticMismatch)?;
    Ok(Q1Key {
        energy: profile.energy,
        q1: profile.q1,
    })
}

fn q1_digits(domain: &EnergyDomain, key: Q1Key) -> Result<u32, G41DefectScoutError> {
    let index = domain
        .q1_profiles
        .binary_search_by_key(&(key.energy, key.q1), |profile| {
            (profile.energy, profile.q1)
        })
        .map_err(|_| G41DefectScoutError::SemanticMismatch)?;
    Ok(domain.q1_profiles[index].digits)
}

fn replay_q0_hit(masks: [u8; 4], digits: [u32; 4]) -> Result<(), G41DefectScoutError> {
    let targets = [260_u16, 261, 261, 261];
    let words: [[u16; QUOTIENT]; 4] =
        std::array::from_fn(|block| decode_word(masks[block], digits[block]));
    for block in 0..4 {
        let actual = words[block].iter().copied().sum::<u16>();
        if actual != targets[block] {
            return Err(G41DefectScoutError::RowReplay {
                block: block as u8,
                expected: targets[block],
                actual,
            });
        }
    }
    let actual = words.iter().map(|word| paf(word, 0)).sum::<u32>();
    if actual != 15_603 {
        return Err(G41DefectScoutError::Q0Replay { actual });
    }
    Ok(())
}

fn replay_q1_hit(masks: [u8; 4], digits: [u32; 4]) -> Result<(), G41DefectScoutError> {
    replay_q0_hit(masks, digits)?;
    let words: [[u16; QUOTIENT]; 4] =
        std::array::from_fn(|block| decode_word(masks[block], digits[block]));
    let actual = words.iter().map(|word| paf(word, 1)).sum::<u32>();
    if actual != 15_080 {
        return Err(G41DefectScoutError::Q1Replay { actual });
    }
    Ok(())
}

fn verify_projection() -> Result<(), G41DefectScoutError> {
    let partition = CyclicMultiplierOrbitPartition::compile(CARRIER as u32, 41)
        .map_err(|_| G41DefectScoutError::OrbitProjection)?;
    let mut families = [[0_u8; 2]; SLOTS];
    for orbit in 0..partition.orbit_count() as usize {
        let representative = partition.representatives()[orbit] as usize;
        let mut histogram = [0_u8; QUOTIENT];
        let mut point = representative;
        loop {
            histogram[point % QUOTIENT] += 1;
            point = point * 41 % CARRIER;
            if point == representative {
                break;
            }
        }
        let Some((slot, family)) = SLOT_RESIDUES
            .iter()
            .enumerate()
            .find_map(|(slot, residues)| {
                for (family, scale) in [1_u8, SCALES[slot] as u8].into_iter().enumerate() {
                    if (0..QUOTIENT).all(|residue| {
                        histogram[residue]
                            == if residues.contains(&residue) {
                                scale
                            } else {
                                0
                            }
                    }) {
                        return Some((slot, family));
                    }
                }
                None
            })
        else {
            return Err(G41DefectScoutError::OrbitProjection);
        };
        families[slot][family] += 1;
    }
    if families != [[1, 7], [1, 7], [1, 14], [1, 14], [1, 14], [1, 14]] {
        return Err(G41DefectScoutError::OrbitProjection);
    }
    Ok(())
}

pub fn census_g41_defect_q0() -> Result<G41DefectScoutReport, G41DefectScoutError> {
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod2_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut compiled = 0_u16;
    for profile in &special_profiles {
        special[usize::from(profile.mask)] = Some(compile_energy_domain(profile.mask, 260, None)?);
        compiled += 1;
    }
    for profile in &zero_profiles {
        zero[usize::from(profile.mask)] = Some(compile_energy_domain(profile.mask, 261, None)?);
        compiled += 1;
    }
    let mut minimum_energies = u16::MAX;
    let mut maximum_energies = 0_u16;
    let mut minimum_configurations = u32::MAX;
    let mut maximum_configurations = 0_u32;
    let mut total_configurations = 0_u64;
    let mut minimum_q1_profiles = u32::MAX;
    let mut maximum_q1_profiles = 0_u32;
    let mut total_q1_profiles = 0_u64;
    for domain in special.iter().chain(zero.iter()).flatten() {
        let energies = domain
            .energies
            .iter()
            .map(|word| word.count_ones())
            .sum::<u32>() as u16;
        minimum_energies = minimum_energies.min(energies);
        maximum_energies = maximum_energies.max(energies);
        minimum_configurations = minimum_configurations.min(domain.configurations);
        maximum_configurations = maximum_configurations.max(domain.configurations);
        total_configurations = total_configurations
            .checked_add(u64::from(domain.configurations))
            .ok_or(G41DefectScoutError::StateBudget)?;
        let q1_count = u32::try_from(domain.q1_profiles.len())
            .map_err(|_| G41DefectScoutError::StateBudget)?;
        minimum_q1_profiles = minimum_q1_profiles.min(q1_count);
        maximum_q1_profiles = maximum_q1_profiles.max(q1_count);
        total_q1_profiles = total_q1_profiles
            .checked_add(u64::from(q1_count))
            .ok_or(G41DefectScoutError::StateBudget)?;
    }
    let special_representatives = q1_class_representatives(&special)?;
    let zero_representatives = q1_class_representatives(&zero)?;
    let special_classes = special_representatives.len();
    let zero_classes = zero_representatives.len();
    let special_class_map = q1_class_map(&special, &special_representatives)?;
    let zero_class_map = q1_class_map(&zero, &zero_representatives)?;
    let mut seen = vec![0_u64; (DEFECT_TARGET + 1) * 16_384 / 64];
    let mut special_zero_pairs =
        Vec::<Box<[Q1PairProfile]>>::with_capacity(special_classes * zero_classes);
    let mut zero_zero_pairs =
        Vec::<Box<[Q1PairProfile]>>::with_capacity(zero_classes * zero_classes);
    let mut minimum_pair_profiles = u32::MAX;
    let mut maximum_pair_profiles = 0_u32;
    let mut total_pair_profiles = 0_u64;
    for (left_classes, right_classes, pair_domains) in [
        (
            &special_representatives,
            &zero_representatives,
            &mut special_zero_pairs,
        ),
        (
            &zero_representatives,
            &zero_representatives,
            &mut zero_zero_pairs,
        ),
    ] {
        for &left in left_classes {
            for &right in right_classes {
                let profiles = compile_q1_pair_profiles(left, right, &mut seen)?;
                let count =
                    u32::try_from(profiles.len()).map_err(|_| G41DefectScoutError::StateBudget)?;
                minimum_pair_profiles = minimum_pair_profiles.min(count);
                maximum_pair_profiles = maximum_pair_profiles.max(count);
                total_pair_profiles = total_pair_profiles
                    .checked_add(u64::from(count))
                    .ok_or(G41DefectScoutError::StateBudget)?;
                pair_domains.push(profiles);
            }
        }
    }
    let compatibility_cells = special_classes
        .checked_mul(zero_classes)
        .and_then(|value| value.checked_mul(zero_classes))
        .and_then(|value| value.checked_mul(zero_classes))
        .ok_or(G41DefectScoutError::StateBudget)?;
    let mut q1_compatibility = vec![None::<Q1ClassWitness>; compatibility_cells];
    for special_class in 0..special_classes {
        for first_zero_class in 0..zero_classes {
            let left = &special_zero_pairs[special_class * zero_classes + first_zero_class];
            for second_zero_class in 0..zero_classes {
                for third_zero_class in 0..zero_classes {
                    let right =
                        &zero_zero_pairs[second_zero_class * zero_classes + third_zero_class];
                    let mut witness = None;
                    for left_profile in left.iter() {
                        if usize::from(left_profile.energy) > DEFECT_TARGET
                            || u32::from(left_profile.q1) > 15_080
                        {
                            continue;
                        }
                        let required = (
                            (DEFECT_TARGET - usize::from(left_profile.energy)) as u8,
                            (15_080 - u32::from(left_profile.q1)) as u16,
                        );
                        let Ok(position) = right.binary_search_by_key(&required, |profile| {
                            (profile.energy, profile.q1)
                        }) else {
                            continue;
                        };
                        let right_profile = right[position];
                        witness = Some(Q1ClassWitness {
                            keys: [
                                q1_key(special_representatives[special_class], left_profile.first)?,
                                q1_key(
                                    zero_representatives[first_zero_class],
                                    left_profile.second,
                                )?,
                                q1_key(
                                    zero_representatives[second_zero_class],
                                    right_profile.first,
                                )?,
                                q1_key(
                                    zero_representatives[third_zero_class],
                                    right_profile.second,
                                )?,
                            ],
                        });
                        break;
                    }
                    let index = (((special_class * zero_classes + first_zero_class)
                        * zero_classes
                        + second_zero_class)
                        * zero_classes)
                        + third_zero_class;
                    q1_compatibility[index] = witness;
                }
            }
        }
    }
    let target_signature = 1_u16;
    let mut roots = 0_u64;
    let mut hits = 0_u64;
    let mut q1_hits = 0_u64;
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = target_signature ^ first.signature ^ second.signature;
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                roots = roots
                    .checked_add(1)
                    .ok_or(G41DefectScoutError::StateBudget)?;
                let domains = [
                    special[usize::from(first.mask)].as_ref().unwrap(),
                    zero[usize::from(second.mask)].as_ref().unwrap(),
                    zero[usize::from(pair.first)].as_ref().unwrap(),
                    zero[usize::from(pair.second)].as_ref().unwrap(),
                ];
                let q0_witness = four_witness(domains);
                if let Some(digits) = q0_witness {
                    replay_q0_hit([first.mask, second.mask, pair.first, pair.second], digits)?;
                    hits = hits
                        .checked_add(1)
                        .ok_or(G41DefectScoutError::StateBudget)?;
                }
                let special_class = usize::from(special_class_map[usize::from(first.mask)]);
                let first_zero_class = usize::from(zero_class_map[usize::from(second.mask)]);
                let second_zero_class = usize::from(zero_class_map[usize::from(pair.first)]);
                let third_zero_class = usize::from(zero_class_map[usize::from(pair.second)]);
                if special_class >= special_classes
                    || first_zero_class >= zero_classes
                    || second_zero_class >= zero_classes
                    || third_zero_class >= zero_classes
                {
                    return Err(G41DefectScoutError::SemanticMismatch);
                }
                let index = (((special_class * zero_classes + first_zero_class) * zero_classes
                    + second_zero_class)
                    * zero_classes)
                    + third_zero_class;
                if let Some(witness) = q1_compatibility[index] {
                    if q0_witness.is_none() {
                        return Err(G41DefectScoutError::Q1WithoutQ0);
                    }
                    let mut digits = [0_u32; 4];
                    for block in 0..4 {
                        digits[block] = q1_digits(domains[block], witness.keys[block])?;
                    }
                    replay_q1_hit([first.mask, second.mask, pair.first, pair.second], digits)?;
                    q1_hits = q1_hits
                        .checked_add(1)
                        .ok_or(G41DefectScoutError::StateBudget)?;
                }
            }
        }
    }
    Ok(G41DefectScoutReport {
        mod2_roots: roots,
        constructive_q0_hits: hits,
        exhaustive_q0_misses: roots - hits,
        block_domains_compiled: compiled,
        minimum_domain_energies: minimum_energies,
        maximum_domain_energies: maximum_energies,
        minimum_domain_configurations: minimum_configurations,
        maximum_domain_configurations: maximum_configurations,
        total_domain_configurations: total_configurations,
        minimum_domain_q1_profiles: minimum_q1_profiles,
        maximum_domain_q1_profiles: maximum_q1_profiles,
        total_domain_q1_profiles: total_q1_profiles,
        special_q1_classes: special_classes as u16,
        zero_q1_classes: zero_classes as u16,
        minimum_q1_pair_profiles: minimum_pair_profiles,
        maximum_q1_pair_profiles: maximum_pair_profiles,
        total_q1_pair_profiles: total_pair_profiles,
        constructive_q1_hits: q1_hits,
        exhaustive_q1_misses: roots - q1_hits,
    })
}

fn shift_domain_equal(left: &EnergyDomain, right: &EnergyDomain) -> bool {
    left.shift_profiles
        .as_deref()
        .into_iter()
        .flatten()
        .map(|profile| profile.state)
        .eq(right
            .shift_profiles
            .as_deref()
            .into_iter()
            .flatten()
            .map(|profile| profile.state))
}

fn shift_class_representatives(
    domains: &[Option<EnergyDomain>],
) -> Result<Vec<&EnergyDomain>, G41DefectScoutError> {
    let mut representatives = Vec::<&EnergyDomain>::new();
    for domain in domains.iter().flatten() {
        if domain.shift_profiles.is_none() {
            return Err(G41DefectScoutError::SemanticMismatch);
        }
        if let Some(representative) = representatives
            .iter()
            .copied()
            .find(|candidate| candidate.shift_hash == domain.shift_hash)
        {
            if !shift_domain_equal(representative, domain) {
                return Err(G41DefectScoutError::SemanticMismatch);
            }
        } else {
            representatives.push(domain);
        }
    }
    Ok(representatives)
}

fn shift_class_count(domains: &[Option<EnergyDomain>]) -> Result<u16, G41DefectScoutError> {
    u16::try_from(shift_class_representatives(domains)?.len())
        .map_err(|_| G41DefectScoutError::StateBudget)
}

fn shift_class_map(
    domains: &[Option<EnergyDomain>],
    representatives: &[&EnergyDomain],
) -> Result<[u8; 1 << SLOTS], G41DefectScoutError> {
    let mut classes = [u8::MAX; 1 << SLOTS];
    for (mask, domain) in domains.iter().enumerate() {
        let Some(domain) = domain else {
            continue;
        };
        let class = representatives
            .iter()
            .position(|representative| {
                representative.shift_hash == domain.shift_hash
                    && shift_domain_equal(representative, domain)
            })
            .ok_or(G41DefectScoutError::SemanticMismatch)?;
        classes[mask] = u8::try_from(class).map_err(|_| G41DefectScoutError::StateBudget)?;
    }
    Ok(classes)
}

pub fn census_g41_shift_profiles(
    shift: usize,
) -> Result<G41ShiftProfileReport, G41DefectScoutError> {
    if !(2..SHIFTS).contains(&shift) {
        return Err(G41DefectScoutError::StateBudget);
    }
    verify_projection()?;
    let (special_profiles, zero_profiles, _) = compile_mod2_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut compiled = 0_u16;
    let mut minimum = u32::MAX;
    let mut maximum = 0_u32;
    let mut total = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let domain = compile_energy_domain(profile.mask, row_target, Some(shift))?;
            let count = u32::try_from(
                domain
                    .shift_profiles
                    .as_ref()
                    .ok_or(G41DefectScoutError::SemanticMismatch)?
                    .len(),
            )
            .map_err(|_| G41DefectScoutError::StateBudget)?;
            minimum = minimum.min(count);
            maximum = maximum.max(count);
            total = total
                .checked_add(u64::from(count))
                .ok_or(G41DefectScoutError::StateBudget)?;
            domains[usize::from(profile.mask)] = Some(domain);
            compiled += 1;
        }
    }
    Ok(G41ShiftProfileReport {
        shift: shift as u8,
        block_domains_compiled: compiled,
        minimum_domain_profiles: minimum,
        maximum_domain_profiles: maximum,
        total_domain_profiles: total,
        special_classes: shift_class_count(&special)?,
        zero_classes: shift_class_count(&zero)?,
        profile_bytes: total
            .checked_mul(std::mem::size_of::<ShiftProfile>() as u64)
            .ok_or(G41DefectScoutError::StateBudget)?,
    })
}

fn compile_exact_shift_pairs(
    first: &EnergyDomain,
    second: &EnergyDomain,
    workspace: &mut PairWorkspace,
) -> Result<Box<[ShiftPairProfile]>, G41DefectScoutError> {
    let first_profiles = first
        .shift_profiles
        .as_deref()
        .ok_or(G41DefectScoutError::SemanticMismatch)?;
    let second_profiles = second
        .shift_profiles
        .as_deref()
        .ok_or(G41DefectScoutError::SemanticMismatch)?;
    for (first_index, left) in first_profiles.iter().enumerate() {
        let left_energy = (left.state >> 26) & 255;
        let left_q1 = (left.state >> 13) & 8_191;
        let left_shift = left.state & 8_191;
        for (second_index, right) in second_profiles.iter().enumerate() {
            let energy = left_energy + ((right.state >> 26) & 255);
            if energy > DEFECT_TARGET as u64 {
                continue;
            }
            let q1 = left_q1 + ((right.state >> 13) & 8_191);
            let shifted = left_shift + (right.state & 8_191);
            if q1 >= 16_384 || shifted >= 16_384 {
                return Err(G41DefectScoutError::StateBudget);
            }
            let first_index =
                u16::try_from(first_index).map_err(|_| G41DefectScoutError::StateBudget)?;
            let second_index =
                u16::try_from(second_index).map_err(|_| G41DefectScoutError::StateBudget)?;
            workspace.insert(
                (energy << 28) | (q1 << 14) | shifted,
                u32::from(first_index) | (u32::from(second_index) << 16),
            )?;
        }
    }
    workspace.take_profiles()
}

fn shift_state(domain: &EnergyDomain, index: u16) -> Result<u64, G41DefectScoutError> {
    domain
        .shift_profiles
        .as_deref()
        .and_then(|profiles| profiles.get(usize::from(index)))
        .map(|profile| profile.state)
        .ok_or(G41DefectScoutError::SemanticMismatch)
}

fn shift_digits(domain: &EnergyDomain, state: u64) -> Result<u32, G41DefectScoutError> {
    let profiles = domain
        .shift_profiles
        .as_deref()
        .ok_or(G41DefectScoutError::SemanticMismatch)?;
    let index = profiles
        .binary_search_by_key(&state, |profile| profile.state)
        .map_err(|_| G41DefectScoutError::SemanticMismatch)?;
    Ok(profiles[index].digits)
}

fn replay_shift_hit(
    masks: [u8; 4],
    digits: [u32; 4],
    shift: usize,
) -> Result<(), G41DefectScoutError> {
    replay_q1_hit(masks, digits)?;
    let words: [[u16; QUOTIENT]; 4] =
        std::array::from_fn(|block| decode_word(masks[block], digits[block]));
    if words.iter().map(|word| paf(word, shift)).sum::<u32>() != 15_080 {
        return Err(G41DefectScoutError::SemanticMismatch);
    }
    Ok(())
}

pub fn census_g41_exact_shift(shift: usize) -> Result<G41ExactShiftReport, G41DefectScoutError> {
    if !(2..SHIFTS).contains(&shift) {
        return Err(G41DefectScoutError::StateBudget);
    }
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod2_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for profile in &special_profiles {
        special[usize::from(profile.mask)] =
            Some(compile_energy_domain(profile.mask, 260, Some(shift))?);
    }
    for profile in &zero_profiles {
        zero[usize::from(profile.mask)] =
            Some(compile_energy_domain(profile.mask, 261, Some(shift))?);
    }
    let special_representatives = shift_class_representatives(&special)?;
    let zero_representatives = shift_class_representatives(&zero)?;
    let special_count = special_representatives.len();
    let zero_count = zero_representatives.len();
    let special_classes = shift_class_map(&special, &special_representatives)?;
    let zero_classes = shift_class_map(&zero, &zero_representatives)?;
    let mut zero_pairs = Vec::<Box<[ShiftPairProfile]>>::with_capacity(zero_count * zero_count);
    let mut minimum_pair_profiles = u32::MAX;
    let mut maximum_pair_profiles = 0_u32;
    let mut total_pair_profiles = 0_u64;
    let mut retained_zero_pair_profiles = 0_u64;
    let mut pair_workspace = PairWorkspace::new()?;
    for &first in &zero_representatives {
        for &second in &zero_representatives {
            let pairs = compile_exact_shift_pairs(first, second, &mut pair_workspace)?;
            let count = u32::try_from(pairs.len()).map_err(|_| G41DefectScoutError::StateBudget)?;
            minimum_pair_profiles = minimum_pair_profiles.min(count);
            maximum_pair_profiles = maximum_pair_profiles.max(count);
            total_pair_profiles = total_pair_profiles
                .checked_add(u64::from(count))
                .ok_or(G41DefectScoutError::StateBudget)?;
            retained_zero_pair_profiles = retained_zero_pair_profiles
                .checked_add(u64::from(count))
                .ok_or(G41DefectScoutError::StateBudget)?;
            if retained_zero_pair_profiles > 60_000_000 {
                return Err(G41DefectScoutError::StateBudget);
            }
            zero_pairs.push(pairs);
        }
    }
    let compatibility_cells = special_count
        .checked_mul(zero_count)
        .and_then(|value| value.checked_mul(zero_count))
        .and_then(|value| value.checked_mul(zero_count))
        .ok_or(G41DefectScoutError::StateBudget)?;
    let mut compatibility = vec![None::<ShiftClassWitness>; compatibility_cells];
    let mut compatible_class_quadruples = 0_u32;
    for special_class in 0..special_count {
        for first_zero_class in 0..zero_count {
            let left = compile_exact_shift_pairs(
                special_representatives[special_class],
                zero_representatives[first_zero_class],
                &mut pair_workspace,
            )?;
            let left_count =
                u32::try_from(left.len()).map_err(|_| G41DefectScoutError::StateBudget)?;
            minimum_pair_profiles = minimum_pair_profiles.min(left_count);
            maximum_pair_profiles = maximum_pair_profiles.max(left_count);
            total_pair_profiles = total_pair_profiles
                .checked_add(u64::from(left_count))
                .ok_or(G41DefectScoutError::StateBudget)?;
            for second_zero_class in 0..zero_count {
                for third_zero_class in 0..zero_count {
                    let right = &zero_pairs[second_zero_class * zero_count + third_zero_class];
                    let mut witness = None;
                    for left_profile in left.iter() {
                        let energy = (left_profile.state >> 28) as usize;
                        let q1 = (left_profile.state >> 14) & 16_383;
                        let shifted = left_profile.state & 16_383;
                        if energy > DEFECT_TARGET || q1 > 15_080 || shifted > 15_080 {
                            continue;
                        }
                        let required = (((DEFECT_TARGET - energy) as u64) << 28)
                            | ((15_080 - q1) << 14)
                            | (15_080 - shifted);
                        let Ok(position) =
                            right.binary_search_by_key(&required, |profile| profile.state)
                        else {
                            continue;
                        };
                        let right_profile = right[position];
                        witness = Some(ShiftClassWitness {
                            states: [
                                shift_state(
                                    special_representatives[special_class],
                                    left_profile.first,
                                )?,
                                shift_state(
                                    zero_representatives[first_zero_class],
                                    left_profile.second,
                                )?,
                                shift_state(
                                    zero_representatives[second_zero_class],
                                    right_profile.first,
                                )?,
                                shift_state(
                                    zero_representatives[third_zero_class],
                                    right_profile.second,
                                )?,
                            ],
                        });
                        break;
                    }
                    let index = (((special_class * zero_count + first_zero_class) * zero_count
                        + second_zero_class)
                        * zero_count)
                        + third_zero_class;
                    compatibility[index] = witness;
                    compatible_class_quadruples = compatible_class_quadruples
                        .checked_add(u32::from(witness.is_some()))
                        .ok_or(G41DefectScoutError::StateBudget)?;
                }
            }
        }
    }
    let mut roots = 0_u64;
    let mut hits = 0_u64;
    let mut surviving_root_ids = Vec::<u32>::with_capacity(262_144);
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = 1 ^ first.signature ^ second.signature;
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                roots = roots
                    .checked_add(1)
                    .ok_or(G41DefectScoutError::StateBudget)?;
                let class = (((usize::from(special_classes[usize::from(first.mask)])
                    * zero_count
                    + usize::from(zero_classes[usize::from(second.mask)]))
                    * zero_count
                    + usize::from(zero_classes[usize::from(pair.first)]))
                    * zero_count)
                    + usize::from(zero_classes[usize::from(pair.second)]);
                if let Some(witness) = compatibility[class] {
                    let domains = [
                        special[usize::from(first.mask)].as_ref().unwrap(),
                        zero[usize::from(second.mask)].as_ref().unwrap(),
                        zero[usize::from(pair.first)].as_ref().unwrap(),
                        zero[usize::from(pair.second)].as_ref().unwrap(),
                    ];
                    let mut digits = [0_u32; 4];
                    for block in 0..4 {
                        digits[block] = shift_digits(domains[block], witness.states[block])?;
                    }
                    replay_shift_hit(
                        [first.mask, second.mask, pair.first, pair.second],
                        digits,
                        shift,
                    )?;
                    hits = hits
                        .checked_add(1)
                        .ok_or(G41DefectScoutError::StateBudget)?;
                    surviving_root_ids.push(
                        u32::from(first.mask)
                            | (u32::from(second.mask) << 6)
                            | (u32::from(pair.first) << 12)
                            | (u32::from(pair.second) << 18),
                    );
                }
            }
        }
    }
    surviving_root_ids.sort_unstable();
    Ok(G41ExactShiftReport {
        shift: shift as u8,
        mod2_roots: roots,
        exact_shift_hits: hits,
        exact_shift_misses: roots - hits,
        special_classes: special_count as u16,
        zero_classes: zero_count as u16,
        compatible_class_quadruples,
        minimum_pair_profiles,
        maximum_pair_profiles,
        total_pair_profiles,
        retained_zero_pair_bytes: retained_zero_pair_profiles
            .checked_mul(std::mem::size_of::<ShiftPairProfile>() as u64)
            .ok_or(G41DefectScoutError::StateBudget)?,
        surviving_root_ids: surviving_root_ids.into_boxed_slice(),
    })
}

fn verify_shift_orbits() -> Result<(), G41DefectScoutError> {
    const EXPECTED: [&[u8]; 5] = [
        &[1, 5, 7, 11, 13, 17],
        &[2, 4, 8, 10, 14, 16],
        &[3, 15],
        &[6, 12],
        &[9],
    ];
    for expected in EXPECTED {
        let mut seen = [false; QUOTIENT];
        let mut value = usize::from(expected[0]);
        loop {
            seen[value] = true;
            seen[QUOTIENT - value] = true;
            value = value * (41 % QUOTIENT) % QUOTIENT;
            if seen[value] {
                break;
            }
        }
        if (1..QUOTIENT).any(|shift| seen[shift] != expected.contains(&(shift as u8))) {
            return Err(G41DefectScoutError::SemanticMismatch);
        }
    }
    for residues in SLOT_RESIDUES {
        if !residues
            .iter()
            .all(|&residue| residues.contains(&(residue * (41 % QUOTIENT) % QUOTIENT)))
        {
            return Err(G41DefectScoutError::SemanticMismatch);
        }
    }
    Ok(())
}

fn intersect_sorted(left: &[u32], right: &[u32]) -> Vec<u32> {
    let mut output = Vec::with_capacity(left.len().min(right.len()));
    let mut first = 0_usize;
    let mut second = 0_usize;
    while first < left.len() && second < right.len() {
        match left[first].cmp(&right[second]) {
            std::cmp::Ordering::Less => first += 1,
            std::cmp::Ordering::Greater => second += 1,
            std::cmp::Ordering::Equal => {
                output.push(left[first]);
                first += 1;
                second += 1;
            }
        }
    }
    output
}

/// Compose independently exact necessary filters for every g41 quotient-shift
/// orbit.  A surviving root need not yet have one common digit assignment, so
/// this report is a sound root reduction, not a positive existence witness.
pub fn census_g41_quotient_filter() -> Result<G41QuotientFilterReport, G41DefectScoutError> {
    verify_projection()?;
    verify_shift_orbits()?;
    let shifts = [2_usize, 3, 6, 9];
    let mut individual_shift_hits = [0_u64; 4];
    let mut intersection = Vec::<u32>::new();
    for (index, shift) in shifts.into_iter().enumerate() {
        let report = census_g41_exact_shift(shift)?;
        if report.mod2_roots != 262_144 {
            return Err(G41DefectScoutError::SemanticMismatch);
        }
        individual_shift_hits[index] = report.exact_shift_hits;
        if index == 0 {
            intersection = report.surviving_root_ids.into_vec();
        } else {
            intersection = intersect_sorted(&intersection, &report.surviving_root_ids);
        }
    }
    Ok(G41QuotientFilterReport {
        representative_shifts: [0, 1, 2, 3, 6, 9],
        mod2_roots: 262_144,
        individual_shift_hits,
        necessary_filter_survivors: intersection.len() as u64,
        necessary_filter_exclusions: 262_144 - intersection.len() as u64,
        surviving_root_ids: intersection.into_boxed_slice(),
    })
}

fn oracle_class_representatives<'a>(
    domains: &'a [Option<Box<[(u8, u16)]>>; 1 << SLOTS],
    masks: &[u8],
) -> Result<(Vec<&'a [(u8, u16)]>, [u8; 1 << SLOTS]), G41DefectScoutError> {
    let mut representatives = Vec::<&[(u8, u16)]>::new();
    let mut classes = [u8::MAX; 1 << SLOTS];
    for &mask in masks {
        let domain = domains[usize::from(mask)]
            .as_deref()
            .ok_or(G41DefectScoutError::SemanticMismatch)?;
        let class = if let Some(class) = representatives
            .iter()
            .position(|representative| *representative == domain)
        {
            class
        } else {
            representatives.push(domain);
            representatives.len() - 1
        };
        classes[usize::from(mask)] =
            u8::try_from(class).map_err(|_| G41DefectScoutError::StateBudget)?;
    }
    Ok((representatives, classes))
}

fn oracle_pair_profiles(
    first: &[(u8, u16)],
    second: &[(u8, u16)],
) -> Result<Box<[u32]>, G41DefectScoutError> {
    const MAX_RAW_PAIR_STATES: usize = 10_000_000;
    let raw = first
        .len()
        .checked_mul(second.len())
        .ok_or(G41DefectScoutError::StateBudget)?;
    if raw > MAX_RAW_PAIR_STATES {
        return Err(G41DefectScoutError::StateBudget);
    }
    let mut profiles = Vec::new();
    profiles
        .try_reserve_exact(raw)
        .map_err(|_| G41DefectScoutError::StateBudget)?;
    for &(left_energy, left_q1) in first {
        for &(right_energy, right_q1) in second {
            let energy = u16::from(left_energy) + u16::from(right_energy);
            if usize::from(energy) > DEFECT_TARGET {
                continue;
            }
            let q1 = u32::from(left_q1) + u32::from(right_q1);
            if q1 >= 16_384 {
                return Err(G41DefectScoutError::StateBudget);
            }
            profiles.push((u32::from(energy) << 14) | q1);
        }
    }
    profiles.sort_unstable();
    profiles.dedup();
    Ok(profiles.into_boxed_slice())
}

fn oracle_q0_compatible(left: &[u32], right: &[u32]) -> bool {
    let mut right_energies = [false; DEFECT_TARGET + 1];
    for &state in right {
        right_energies[(state >> 14) as usize] = true;
    }
    left.iter().any(|&state| {
        let energy = (state >> 14) as usize;
        energy <= DEFECT_TARGET && right_energies[DEFECT_TARGET - energy]
    })
}

fn oracle_q1_compatible(left: &[u32], right: &[u32]) -> bool {
    for &state in left {
        let energy = (state >> 14) as usize;
        let q1 = state & 16_383;
        if energy > DEFECT_TARGET || q1 > 15_080 {
            continue;
        }
        let required = (((DEFECT_TARGET - energy) as u32) << 14) | (15_080 - q1);
        if right.binary_search(&required).is_ok() {
            return true;
        }
    }
    false
}

/// Flat mixed-radix differential oracle for all 64 block domains.
///
/// This intentionally does not use the bounded DFS, its prefix bounds, or its
/// defect-cost recurrence.  It directly constructs every quotient word and
/// recomputes row weight, signed energy, q0 defect, and q1.
pub fn oracle_g41_domains() -> Result<G41DomainOracleReport, G41DefectScoutError> {
    verify_projection()?;
    const RAW_PER_MASK: u32 = 8 * 8 * 15 * 15 * 15 * 15;
    let mut states = Vec::<(u8, u16)>::with_capacity(8_192);
    let mut raw = 0_u64;
    let mut retained = 0_u64;
    let mut profiles = 0_u64;
    let mut domains: [Option<Box<[(u8, u16)]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut special_masks = Vec::with_capacity(32);
    let mut zero_masks = Vec::with_capacity(32);
    for mask in 0_u8..1 << SLOTS {
        states.clear();
        let row_target = if binary_word(mask).iter().copied().sum::<u16>() & 1 == 0 {
            special_masks.push(mask);
            260
        } else {
            zero_masks.push(mask);
            261
        };
        let mut configurations = 0_u32;
        for mut code in 0..RAW_PER_MASK {
            raw = raw.checked_add(1).ok_or(G41DefectScoutError::StateBudget)?;
            let mut word = [0_u16; QUOTIENT];
            for (slot, residues) in SLOT_RESIDUES.iter().enumerate() {
                let radix = u32::from(RADICES[slot]);
                let digit = (code % radix) as u16;
                code /= radix;
                let value = u16::from((mask >> slot) & 1) + SCALES[slot] * digit;
                for &residue in *residues {
                    word[residue] = value;
                }
            }
            if word.iter().copied().sum::<u16>() != row_target {
                continue;
            }
            let signed = word
                .iter()
                .map(|&value| {
                    let signed = 2 * i32::from(value) - 29;
                    signed * signed
                })
                .sum::<i32>();
            let excess = signed - (2 * 9 + 16);
            if excess < 0 || excess % 8 != 0 || excess / 8 > DEFECT_TARGET as i32 {
                continue;
            }
            configurations = configurations
                .checked_add(1)
                .ok_or(G41DefectScoutError::StateBudget)?;
            states.push(((excess / 8) as u8, paf(&word, 1) as u16));
        }
        states.sort_unstable();
        states.dedup();
        let optimized = compile_energy_domain(mask, row_target, None)?;
        if configurations != optimized.configurations
            || !states.iter().copied().eq(optimized
                .q1_profiles
                .iter()
                .map(|profile| (profile.energy, profile.q1)))
        {
            return Err(G41DefectScoutError::SemanticMismatch);
        }
        retained = retained
            .checked_add(u64::from(configurations))
            .ok_or(G41DefectScoutError::StateBudget)?;
        profiles = profiles
            .checked_add(states.len() as u64)
            .ok_or(G41DefectScoutError::StateBudget)?;
        domains[usize::from(mask)] = Some(states.clone().into_boxed_slice());
    }
    let (special_representatives, special_classes) =
        oracle_class_representatives(&domains, &special_masks)?;
    let (zero_representatives, zero_classes) = oracle_class_representatives(&domains, &zero_masks)?;
    let special_count = special_representatives.len();
    let zero_count = zero_representatives.len();
    let mut special_zero_pairs = Vec::<Box<[u32]>>::with_capacity(special_count * zero_count);
    let mut zero_zero_pairs = Vec::<Box<[u32]>>::with_capacity(zero_count * zero_count);
    let mut pair_profiles = 0_u64;
    for (left_classes, right_classes, pairs) in [
        (
            &special_representatives,
            &zero_representatives,
            &mut special_zero_pairs,
        ),
        (
            &zero_representatives,
            &zero_representatives,
            &mut zero_zero_pairs,
        ),
    ] {
        for &left in left_classes {
            for &right in right_classes {
                let pair = oracle_pair_profiles(left, right)?;
                pair_profiles = pair_profiles
                    .checked_add(pair.len() as u64)
                    .ok_or(G41DefectScoutError::StateBudget)?;
                pairs.push(pair);
            }
        }
    }
    let compatibility_cells = special_count
        .checked_mul(zero_count)
        .and_then(|value| value.checked_mul(zero_count))
        .and_then(|value| value.checked_mul(zero_count))
        .ok_or(G41DefectScoutError::StateBudget)?;
    let mut q0_compatibility = vec![false; compatibility_cells];
    let mut q1_compatibility = vec![false; compatibility_cells];
    for special_class in 0..special_count {
        for first_zero_class in 0..zero_count {
            let left = &special_zero_pairs[special_class * zero_count + first_zero_class];
            for second_zero_class in 0..zero_count {
                for third_zero_class in 0..zero_count {
                    let right = &zero_zero_pairs[second_zero_class * zero_count + third_zero_class];
                    let index = (((special_class * zero_count + first_zero_class) * zero_count
                        + second_zero_class)
                        * zero_count)
                        + third_zero_class;
                    q0_compatibility[index] = oracle_q0_compatible(left, right);
                    q1_compatibility[index] = oracle_q1_compatible(left, right);
                    if q1_compatibility[index] && !q0_compatibility[index] {
                        return Err(G41DefectScoutError::SemanticMismatch);
                    }
                }
            }
        }
    }
    let mut roots = 0_u64;
    let mut q0_hits = 0_u64;
    let mut q1_hits = 0_u64;
    for &first in &special_masks {
        let first_signature = signature(&binary_word(first));
        for &second in &zero_masks {
            let second_signature = signature(&binary_word(second));
            for &third in &zero_masks {
                let third_signature = signature(&binary_word(third));
                for &fourth in &zero_masks {
                    if first_signature
                        ^ second_signature
                        ^ third_signature
                        ^ signature(&binary_word(fourth))
                        != 1
                    {
                        continue;
                    }
                    roots = roots
                        .checked_add(1)
                        .ok_or(G41DefectScoutError::StateBudget)?;
                    let index = (((usize::from(special_classes[usize::from(first)]) * zero_count
                        + usize::from(zero_classes[usize::from(second)]))
                        * zero_count
                        + usize::from(zero_classes[usize::from(third)]))
                        * zero_count)
                        + usize::from(zero_classes[usize::from(fourth)]);
                    q0_hits = q0_hits
                        .checked_add(u64::from(q0_compatibility[index]))
                        .ok_or(G41DefectScoutError::StateBudget)?;
                    q1_hits = q1_hits
                        .checked_add(u64::from(q1_compatibility[index]))
                        .ok_or(G41DefectScoutError::StateBudget)?;
                }
            }
        }
    }
    Ok(G41DomainOracleReport {
        masks_checked: 1 << SLOTS,
        raw_assignments_checked: raw,
        retained_configurations: retained,
        retained_q1_profiles: profiles,
        mod2_roots: roots,
        constructive_q0_hits: q0_hits,
        constructive_q1_hits: q1_hits,
        retained_pair_profiles: pair_profiles,
    })
}

pub fn oracle_g41_shift_domains(
    shift: usize,
) -> Result<G41ShiftDomainOracleReport, G41DefectScoutError> {
    if !(2..SHIFTS).contains(&shift) {
        return Err(G41DefectScoutError::StateBudget);
    }
    verify_projection()?;
    const RAW_PER_MASK: u32 = 8 * 8 * 15 * 15 * 15 * 15;
    let mut states = Vec::<u64>::with_capacity(8_192);
    let mut raw = 0_u64;
    let mut retained = 0_u64;
    for mask in 0_u8..1 << SLOTS {
        states.clear();
        let row_target = if binary_word(mask).iter().copied().sum::<u16>() & 1 == 0 {
            260
        } else {
            261
        };
        for mut code in 0..RAW_PER_MASK {
            raw = raw.checked_add(1).ok_or(G41DefectScoutError::StateBudget)?;
            let mut word = [0_u16; QUOTIENT];
            for (slot, residues) in SLOT_RESIDUES.iter().enumerate() {
                let radix = u32::from(RADICES[slot]);
                let digit = (code % radix) as u16;
                code /= radix;
                let value = u16::from((mask >> slot) & 1) + SCALES[slot] * digit;
                for &residue in *residues {
                    word[residue] = value;
                }
            }
            if word.iter().copied().sum::<u16>() != row_target {
                continue;
            }
            let signed = word
                .iter()
                .map(|&value| {
                    let signed = 2 * i32::from(value) - 29;
                    signed * signed
                })
                .sum::<i32>();
            let excess = signed - (2 * 9 + 16);
            if excess < 0 || excess % 8 != 0 || excess / 8 > DEFECT_TARGET as i32 {
                continue;
            }
            let q1 = paf(&word, 1);
            let shifted = paf(&word, shift);
            if q1 >= 8_192 || shifted >= 8_192 {
                return Err(G41DefectScoutError::StateBudget);
            }
            states.push(((excess as u64 / 8) << 26) | (u64::from(q1) << 13) | u64::from(shifted));
        }
        states.sort_unstable();
        states.dedup();
        let optimized = compile_energy_domain(mask, row_target, Some(shift))?;
        if !states.iter().copied().eq(optimized
            .shift_profiles
            .as_deref()
            .ok_or(G41DefectScoutError::SemanticMismatch)?
            .iter()
            .map(|profile| profile.state))
        {
            return Err(G41DefectScoutError::SemanticMismatch);
        }
        retained = retained
            .checked_add(states.len() as u64)
            .ok_or(G41DefectScoutError::StateBudget)?;
    }
    Ok(G41ShiftDomainOracleReport {
        shift: shift as u8,
        masks_checked: 1 << SLOTS,
        raw_assignments_checked: raw,
        retained_profiles: retained,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn projection_and_one_domain_replay() {
        verify_projection().unwrap();
        let domain = compile_energy_domain(0, 260, None).unwrap();
        for energy in 0..=DEFECT_TARGET {
            if !has_energy(&domain.energies, energy) {
                continue;
            }
            let word = decode_word(0, domain.witnesses[energy]);
            assert_eq!(word.iter().copied().sum::<u16>(), 260);
            let signed = word
                .iter()
                .map(|&value| {
                    let signed = 2 * i32::from(value) - 29;
                    signed * signed
                })
                .sum::<i32>();
            let baseline = 2 * 9 + 16;
            assert_eq!((signed - baseline) / 8, energy as i32);
        }
    }

    #[test]
    fn shift_orbits_and_sorted_intersection_replay() {
        verify_shift_orbits().unwrap();
        assert_eq!(intersect_sorted(&[1, 2, 4, 9], &[0, 2, 3, 9]), [2, 9]);
    }

    #[test]
    fn fixed_pair_workspace_deduplicates_and_resets() {
        let mut workspace = PairWorkspace::new().unwrap();
        workspace.insert(7, 0x0002_0001).unwrap();
        workspace.insert(3, 0x0004_0003).unwrap();
        workspace.insert(7, 0x0006_0005).unwrap();
        let profiles = workspace.take_profiles().unwrap();
        assert_eq!(profiles.len(), 2);
        assert_eq!(
            (profiles[0].state, profiles[0].first, profiles[0].second),
            (3, 3, 4)
        );
        assert_eq!(
            (profiles[1].state, profiles[1].first, profiles[1].second),
            (7, 1, 2)
        );
        workspace.insert(11, 0x0008_0007).unwrap();
        let profiles = workspace.take_profiles().unwrap();
        assert_eq!(profiles.len(), 1);
        assert_eq!(
            (profiles[0].state, profiles[0].first, profiles[0].second),
            (11, 7, 8)
        );
    }
}
