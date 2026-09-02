//! Exact small modular reduction for the g53 Z/18 quotient equations.
//!
//! Each multiplier-orbit coordinate has the form `B=e+7k`, where `e` is the
//! scale-one selection bit. Reducing quotient autocorrelation modulo seven
//! therefore removes every scale-seven choice and leaves four symmetric binary
//! words of length 18. This module counts that necessary domain directly; it
//! does not claim sufficiency for the original integer equations.

use std::sync::OnceLock;

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::hadamard_2092::CyclicMultiplierOrbitPartition;
use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

const QUOTIENT_ORDER: usize = 18;
const QUOTIENT_SHIFTS: usize = 10;
const MODULUS: u8 = 7;
const TARGET_RESIDUES: [u8; QUOTIENT_SHIFTS] = [0, 2, 2, 2, 2, 2, 2, 2, 2, 2];
const SYMMETRIC_MASKS: usize = 1 << 10;
const Q0_TARGET: u16 = 15_603;
const LIFT_STATE_BUDGET: usize = 1_000_000;
const EXTRACTOR_ID: [u8; 16] = *b"c1016-g53-m7red1";
const EXTRACTOR_VERSION: u16 = 1;
const SOURCE_SEMANTICS: &[u8] = b"g53 Z18 quotient modular digit reduction v1: B=e+7k; cyclic autocorrelation reduces to e modulo 7; sum_s C(s)=weight^2 makes shift 9 redundant after shifts 0..8";

const FACT_REGISTERED_EXTRACTOR: u8 = 0;
const FACT_FIVE_FAMILY_PROJECTION: u8 = 1;
const FACT_AFFINE_DIGITS: u8 = 2;
const FACT_MODULAR_AUTOCORRELATION: u8 = 3;
const FACT_WEIGHT_RESIDUES: u8 = 4;
const FACT_MASS_IDENTITY: u8 = 5;
const FACT_SHIFT_NINE_REDUNDANT: u8 = 6;
const FACT_EXACT_PREFIX_CENSUS: u8 = 7;
const FACT_NECESSARY_REDUCTION: u8 = 8;

const RULES: [RuleSpec; 8] = [
    RuleSpec::registered(
        0x53_71,
        1 << FACT_REGISTERED_EXTRACTOR,
        FACT_FIVE_FAMILY_PROJECTION,
    ),
    RuleSpec::registered(
        0x53_72,
        1 << FACT_FIVE_FAMILY_PROJECTION,
        FACT_AFFINE_DIGITS,
    ),
    RuleSpec::registered(
        0x53_73,
        1 << FACT_AFFINE_DIGITS,
        FACT_MODULAR_AUTOCORRELATION,
    ),
    RuleSpec::registered(
        0x53_74,
        1 << FACT_REGISTERED_EXTRACTOR,
        FACT_WEIGHT_RESIDUES,
    ),
    RuleSpec::registered(
        0x53_75,
        1 << FACT_MODULAR_AUTOCORRELATION,
        FACT_MASS_IDENTITY,
    ),
    RuleSpec::registered(
        0x53_76,
        (1 << FACT_WEIGHT_RESIDUES) | (1 << FACT_MASS_IDENTITY),
        FACT_SHIFT_NINE_REDUNDANT,
    ),
    RuleSpec::registered(
        0x53_77,
        (1 << FACT_MODULAR_AUTOCORRELATION) | (1 << FACT_WEIGHT_RESIDUES),
        FACT_EXACT_PREFIX_CENSUS,
    ),
    RuleSpec::registered(
        0x53_78,
        (1 << FACT_SHIFT_NINE_REDUNDANT) | (1 << FACT_EXACT_PREFIX_CENSUS),
        FACT_NECESSARY_REDUCTION,
    ),
];

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct BinaryProfile {
    mask: u16,
    autocorrelation: [u8; QUOTIENT_SHIFTS],
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct PairWitness {
    signature: u32,
    first_mask: u16,
    second_mask: u16,
}

const _: () = assert!(std::mem::size_of::<PairWitness>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct LiftState {
    row_weight: u16,
    energy: u16,
    digits: u32,
}

const _: () = assert!(std::mem::size_of::<LiftState>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct EnergyLift {
    digits: u32,
    energy: u16,
    reserved: u16,
}

const _: () = assert!(std::mem::size_of::<EnergyLift>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53Mod7Q0Lift {
    pub scale_one_masks: [u16; 4],
    pub scale_seven_digits: [u32; 4],
}

const _: () = assert!(std::mem::size_of::<G53Mod7Q0Lift>() == 24);

impl G53Mod7Q0Lift {
    #[must_use]
    pub fn scale_seven_count(self, block: usize, slot: usize) -> u8 {
        const POWERS: [u32; 10] = [
            1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
        ];
        ((self.scale_seven_digits[block] / POWERS[slot]) % 5) as u8
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53Mod7PrefixCount {
    pub active_shifts: u8,
    pub special_profiles: u16,
    pub zero_profiles: u16,
    pub ordered_completions: u64,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53Mod7Binding {
    descriptor: ExtractorDescriptor,
}

impl G53Mod7Binding {
    #[must_use]
    pub fn registered() -> Self {
        Self {
            descriptor: descriptor(),
        }
    }

    fn is_registered(self) -> bool {
        self.descriptor == descriptor()
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53Mod7Observation {
    pub prefix_nine_completions: u64,
    pub full_completions: u64,
    pub shift_nine_redundant: bool,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53Mod7Proof {
    pub binding: G53Mod7Binding,
    pub prefix_nine_completions: u64,
    pub full_completions: u64,
    pub raw_modular_assignments: u64,
    pub transcript: Box<[RuleApplication]>,
    pub theorem_provenance: ProvenanceClass,
    pub census_provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53Mod7Error {
    #[error("active quotient prefix is invalid")]
    InvalidPrefix,
    #[error("bounded modular join overflowed")]
    ArithmeticOverflow,
    #[error("bounded modular lift exceeded its explicit state budget")]
    StateBudget,
    #[error("g53 modular extractor is not registered")]
    UnregisteredExtractor,
    #[error("evolved modular observation disagrees with canonical semantics")]
    SemanticMismatch,
    #[error("proof provenance cannot authorize this reduction")]
    UnauthorizedProvenance,
    #[error("raw g53 orbits do not have the required affine digit projection")]
    OrbitProjection,
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_g53_mod7_proof(
    binding: G53Mod7Binding,
    observation: G53Mod7Observation,
) -> Result<G53Mod7Proof, G53Mod7Error> {
    if !binding.is_registered() {
        return Err(G53Mod7Error::UnregisteredExtractor);
    }
    if observation.provenance != ProvenanceClass::ObservedEvolved {
        return Err(G53Mod7Error::UnauthorizedProvenance);
    }
    verify_five_family_projection()?;
    verify_shift_nine_identity()?;
    let prefix_nine = count_g53_mod7_prefix(9)?;
    let full = count_g53_mod7_prefix(10)?;
    if observation.prefix_nine_completions != prefix_nine.ordered_completions
        || observation.full_completions != full.ordered_completions
        || !observation.shift_nine_redundant
        || prefix_nine.ordered_completions != full.ordered_completions
    {
        return Err(G53Mod7Error::SemanticMismatch);
    }
    let raw_modular_assignments = u64::from(prefix_nine.special_profiles)
        .checked_mul(u64::from(prefix_nine.zero_profiles).pow(3))
        .ok_or(G53Mod7Error::ArithmeticOverflow)?;
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = G53Mod7Proof {
        binding,
        prefix_nine_completions: prefix_nine.ordered_completions,
        full_completions: full.ordered_completions,
        raw_modular_assignments,
        transcript: derivation.applications,
        theorem_provenance: ProvenanceClass::ProvedStructural,
        census_provenance: ProvenanceClass::ExactComputational,
    };
    verify_g53_mod7_proof(&proof)?;
    Ok(proof)
}

pub fn verify_g53_mod7_proof(proof: &G53Mod7Proof) -> Result<(), G53Mod7Error> {
    if !proof.binding.is_registered() {
        return Err(G53Mod7Error::UnregisteredExtractor);
    }
    if proof.theorem_provenance != ProvenanceClass::ProvedStructural
        || proof.census_provenance != ProvenanceClass::ExactComputational
    {
        return Err(G53Mod7Error::UnauthorizedProvenance);
    }
    verify_five_family_projection()?;
    verify_shift_nine_identity()?;
    let prefix_nine = count_g53_mod7_prefix(9)?;
    let full = count_g53_mod7_prefix(10)?;
    let raw = u64::from(prefix_nine.special_profiles)
        .checked_mul(u64::from(prefix_nine.zero_profiles).pow(3))
        .ok_or(G53Mod7Error::ArithmeticOverflow)?;
    if proof.prefix_nine_completions != prefix_nine.ordered_completions
        || proof.full_completions != full.ordered_completions
        || proof.prefix_nine_completions != proof.full_completions
        || proof.raw_modular_assignments != raw
    {
        return Err(G53Mod7Error::SemanticMismatch);
    }
    replay_g53_mod7_rules(&proof.transcript)?;
    Ok(())
}

pub fn derive_g53_mod7_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_g53_mod7_rules(transcript: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        transcript,
    )
}

pub fn count_g53_mod7_prefix(active_shifts: u8) -> Result<G53Mod7PrefixCount, G53Mod7Error> {
    let active = usize::from(active_shifts);
    if active == 0 || active > QUOTIENT_SHIFTS {
        return Err(G53Mod7Error::InvalidPrefix);
    }
    let special = compile_profiles(260_u16.rem_euclid(u16::from(MODULUS)) as u8);
    let zero = compile_profiles(261_u16.rem_euclid(u16::from(MODULUS)) as u8);
    let left_capacity = special
        .len()
        .checked_mul(zero.len())
        .ok_or(G53Mod7Error::ArithmeticOverflow)?;
    let right_capacity = zero
        .len()
        .checked_mul(zero.len())
        .ok_or(G53Mod7Error::ArithmeticOverflow)?;
    if left_capacity > SYMMETRIC_MASKS * SYMMETRIC_MASKS
        || right_capacity > SYMMETRIC_MASKS * SYMMETRIC_MASKS
    {
        return Err(G53Mod7Error::ArithmeticOverflow);
    }
    let mut left = Vec::with_capacity(left_capacity);
    for special_profile in &special {
        for zero_profile in &zero {
            left.push(add_packed(
                special_profile.autocorrelation,
                zero_profile.autocorrelation,
                active,
            ));
        }
    }
    let mut right = Vec::with_capacity(right_capacity);
    for first in &zero {
        for second in &zero {
            right.push(add_packed(
                first.autocorrelation,
                second.autocorrelation,
                active,
            ));
        }
    }
    right.sort_unstable();
    let mut ordered_completions = 0_u64;
    for signature in left {
        let complement = complement_packed(signature, active);
        let begin = right.partition_point(|&value| value < complement);
        let end = right.partition_point(|&value| value <= complement);
        ordered_completions = ordered_completions
            .checked_add((end - begin) as u64)
            .ok_or(G53Mod7Error::ArithmeticOverflow)?;
    }
    Ok(G53Mod7PrefixCount {
        active_shifts,
        special_profiles: special.len() as u16,
        zero_profiles: zero.len() as u16,
        ordered_completions,
    })
}

pub fn compile_g53_mod7_assignments() -> Result<Box<[[u16; 4]]>, G53Mod7Error> {
    const ASSIGNMENT_BUDGET: usize = 4_096;
    let count = count_g53_mod7_prefix(QUOTIENT_SHIFTS as u8)?;
    let capacity =
        usize::try_from(count.ordered_completions).map_err(|_| G53Mod7Error::ArithmeticOverflow)?;
    if capacity > ASSIGNMENT_BUDGET {
        return Err(G53Mod7Error::ArithmeticOverflow);
    }
    let special = compile_profiles(1);
    let zero = compile_profiles(2);
    let right_capacity = zero
        .len()
        .checked_mul(zero.len())
        .ok_or(G53Mod7Error::ArithmeticOverflow)?;
    let mut right = Vec::with_capacity(right_capacity);
    for first in &zero {
        for second in &zero {
            right.push(PairWitness {
                signature: add_packed(
                    first.autocorrelation,
                    second.autocorrelation,
                    QUOTIENT_SHIFTS,
                ),
                first_mask: first.mask,
                second_mask: second.mask,
            });
        }
    }
    right.sort_unstable();
    let mut assignments = Vec::with_capacity(capacity);
    for first in &special {
        for second in &zero {
            let left = add_packed(
                first.autocorrelation,
                second.autocorrelation,
                QUOTIENT_SHIFTS,
            );
            let complement = complement_packed(left, QUOTIENT_SHIFTS);
            let begin = right.partition_point(|pair| pair.signature < complement);
            let end = right.partition_point(|pair| pair.signature <= complement);
            for pair in &right[begin..end] {
                assignments.push([first.mask, second.mask, pair.first_mask, pair.second_mask]);
            }
        }
    }
    if assignments.len() != capacity {
        return Err(G53Mod7Error::SemanticMismatch);
    }
    Ok(assignments.into_boxed_slice())
}

const Q0_LIFT_BANK_PER_ASSIGNMENT: usize = 8;

fn compile_g53_mod7_q0_lifts_with_limit(
    per_assignment_limit: usize,
) -> Result<Box<[G53Mod7Q0Lift]>, G53Mod7Error> {
    if per_assignment_limit == 0 || per_assignment_limit > 16 {
        return Err(G53Mod7Error::StateBudget);
    }
    let assignments = compile_g53_mod7_assignments()?;
    let mut workspace = LiftWorkspace::new()?;
    let mut special_lifts = vec![None::<Box<[EnergyLift]>>; SYMMETRIC_MASKS];
    let mut zero_lifts = vec![None::<Box<[EnergyLift]>>; SYMMETRIC_MASKS];
    for assignment in assignments.iter() {
        for (block, &mask) in assignment.iter().enumerate() {
            let cache = if block == 0 {
                &mut special_lifts
            } else {
                &mut zero_lifts
            };
            if cache[usize::from(mask)].is_none() {
                ensure_mask_lifts(
                    cache,
                    mask,
                    if block == 0 { 260 } else { 261 },
                    &mut workspace,
                )?;
            }
        }
    }
    let lift_capacity = assignments
        .len()
        .checked_mul(per_assignment_limit)
        .ok_or(G53Mod7Error::ArithmeticOverflow)?;
    let mut lifts = Vec::with_capacity(lift_capacity);
    let mut right_pairs = Vec::<(u16, u32, u32)>::with_capacity(LIFT_STATE_BUDGET);
    for assignment in assignments.iter() {
        let block_lifts: [&[EnergyLift]; 4] = std::array::from_fn(|block| {
            let cache = if block == 0 {
                &special_lifts
            } else {
                &zero_lifts
            };
            cache[usize::from(assignment[block])]
                .as_deref()
                .expect("every assignment mask was compiled above")
        });
        let right_capacity = block_lifts[2]
            .len()
            .checked_mul(block_lifts[3].len())
            .ok_or(G53Mod7Error::ArithmeticOverflow)?;
        if right_capacity > LIFT_STATE_BUDGET {
            return Err(G53Mod7Error::StateBudget);
        }
        right_pairs.clear();
        for third in block_lifts[2] {
            for fourth in block_lifts[3] {
                let energy = third
                    .energy
                    .checked_add(fourth.energy)
                    .ok_or(G53Mod7Error::ArithmeticOverflow)?;
                if energy <= Q0_TARGET {
                    right_pairs.push((energy, third.digits, fourth.digits));
                }
            }
        }
        right_pairs.sort_unstable();
        let assignment_begin = lifts.len();
        'outer: for first in block_lifts[0] {
            for second in block_lifts[1] {
                let left = first
                    .energy
                    .checked_add(second.energy)
                    .ok_or(G53Mod7Error::ArithmeticOverflow)?;
                let Some(required) = Q0_TARGET.checked_sub(left) else {
                    continue;
                };
                let begin = right_pairs.partition_point(|entry| entry.0 < required);
                let end = right_pairs.partition_point(|entry| entry.0 <= required);
                for &(_, third, fourth) in &right_pairs[begin..end] {
                    lifts.push(G53Mod7Q0Lift {
                        scale_one_masks: *assignment,
                        scale_seven_digits: [first.digits, second.digits, third, fourth],
                    });
                    if lifts.len() - assignment_begin == per_assignment_limit {
                        break 'outer;
                    }
                }
            }
        }
        if lifts.len() == assignment_begin {
            return Err(G53Mod7Error::SemanticMismatch);
        }
    }
    Ok(lifts.into_boxed_slice())
}

pub fn compile_g53_mod7_q0_lifts() -> Result<Box<[G53Mod7Q0Lift]>, G53Mod7Error> {
    compile_g53_mod7_q0_lifts_with_limit(1)
}

fn ensure_mask_lifts(
    cache: &mut [Option<Box<[EnergyLift]>>],
    mask: u16,
    target_row: u16,
    workspace: &mut LiftWorkspace,
) -> Result<(), G53Mod7Error> {
    let class = mask_class(mask);
    let representative = (0_u16..SYMMETRIC_MASKS as u16).find(|&candidate| {
        cache[usize::from(candidate)].is_some() && mask_class(candidate) == class
    });
    let lifts = if let Some(representative) = representative {
        let source = cache[usize::from(representative)]
            .as_deref()
            .expect("the representative was selected from populated cache entries");
        let mut lifts = Vec::with_capacity(source.len());
        for lift in source {
            lifts.push(EnergyLift {
                digits: permute_digits(lift.digits, representative, mask),
                energy: lift.energy,
                reserved: 0,
            });
        }
        lifts
    } else {
        workspace.compile_block(mask, target_row)?
    };
    cache[usize::from(mask)] = Some(lifts.into_boxed_slice());
    Ok(())
}

fn mask_class(mask: u16) -> (u8, u8) {
    let endpoint = (mask & 1 != 0) as u8 + (mask & (1 << 9) != 0) as u8;
    let interior = ((mask >> 1) & 0xff).count_ones() as u8;
    (endpoint, interior)
}

fn permute_digits(digits: u32, source_mask: u16, target_mask: u16) -> u32 {
    const POWERS: [u32; 10] = [
        1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
    ];
    let mut output = 0_u32;
    for positions in [&[0_usize, 9][..], &[1_usize, 2, 3, 4, 5, 6, 7, 8][..]] {
        for bit in 0..=1 {
            let mut source = positions
                .iter()
                .copied()
                .filter(|&slot| usize::from((source_mask >> slot) & 1) == bit);
            let mut target = positions
                .iter()
                .copied()
                .filter(|&slot| usize::from((target_mask >> slot) & 1) == bit);
            loop {
                match (source.next(), target.next()) {
                    (Some(source_slot), Some(target_slot)) => {
                        let digit = (digits / POWERS[source_slot]) % 5;
                        output += digit * POWERS[target_slot];
                    }
                    (None, None) => break,
                    _ => unreachable!("equal mask classes have matching bit multiplicities"),
                }
            }
        }
    }
    output
}

pub fn cached_g53_mod7_q0_lifts() -> Result<&'static [G53Mod7Q0Lift], G53Mod7Error> {
    static LIFTS: OnceLock<Result<Box<[G53Mod7Q0Lift]>, G53Mod7Error>> = OnceLock::new();
    match LIFTS.get_or_init(compile_g53_mod7_q0_lifts) {
        Ok(lifts) => Ok(lifts),
        Err(error) => Err(error.clone()),
    }
}

pub fn cached_g53_mod7_q0_lift_bank() -> Result<&'static [G53Mod7Q0Lift], G53Mod7Error> {
    static LIFTS: OnceLock<Result<Box<[G53Mod7Q0Lift]>, G53Mod7Error>> = OnceLock::new();
    match LIFTS.get_or_init(|| compile_g53_mod7_q0_lifts_with_limit(Q0_LIFT_BANK_PER_ASSIGNMENT)) {
        Ok(lifts) => Ok(lifts),
        Err(error) => Err(error.clone()),
    }
}

struct LiftWorkspace {
    seen: Vec<u16>,
    current: Vec<LiftState>,
    next: Vec<LiftState>,
    generation: u16,
}

impl LiftWorkspace {
    fn new() -> Result<Self, G53Mod7Error> {
        let cells = (usize::from(Q0_TARGET) + 1)
            .checked_mul(262)
            .ok_or(G53Mod7Error::ArithmeticOverflow)?;
        Ok(Self {
            seen: vec![0; cells],
            current: Vec::with_capacity(LIFT_STATE_BUDGET),
            next: Vec::with_capacity(LIFT_STATE_BUDGET),
            generation: 0,
        })
    }

    fn compile_block(
        &mut self,
        mask: u16,
        target_row: u16,
    ) -> Result<Vec<EnergyLift>, G53Mod7Error> {
        const POWERS: [u32; 10] = [
            1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
        ];
        self.current.clear();
        self.current.push(LiftState {
            row_weight: 0,
            energy: 0,
            digits: 0,
        });
        for (slot, &place) in POWERS.iter().enumerate() {
            self.generation = self.generation.wrapping_add(1);
            if self.generation == 0 {
                self.seen.fill(0);
                self.generation = 1;
            }
            self.next.clear();
            let multiplicity = if slot == 0 || slot == 9 { 1_u16 } else { 2_u16 };
            let scale_one = (mask >> slot) & 1;
            for state in &self.current {
                for scale_seven in 0_u16..=4 {
                    let value = scale_one + 7 * scale_seven;
                    let row_weight = state.row_weight + multiplicity * value;
                    let energy = state.energy + multiplicity * value * value;
                    if row_weight > target_row || energy > Q0_TARGET {
                        continue;
                    }
                    let key = usize::from(row_weight) * (usize::from(Q0_TARGET) + 1)
                        + usize::from(energy);
                    if self.seen[key] == self.generation {
                        continue;
                    }
                    self.seen[key] = self.generation;
                    if self.next.len() == LIFT_STATE_BUDGET {
                        return Err(G53Mod7Error::StateBudget);
                    }
                    self.next.push(LiftState {
                        row_weight,
                        energy,
                        digits: state.digits + u32::from(scale_seven) * place,
                    });
                }
            }
            std::mem::swap(&mut self.current, &mut self.next);
        }
        let mut lifts = Vec::new();
        for state in &self.current {
            if state.row_weight == target_row {
                lifts.push(EnergyLift {
                    digits: state.digits,
                    energy: state.energy,
                    reserved: 0,
                });
            }
        }
        lifts.sort_unstable_by_key(|lift| lift.energy);
        Ok(lifts)
    }
}

fn compile_profiles(row_residue: u8) -> Vec<BinaryProfile> {
    let mut profiles = Vec::with_capacity(SYMMETRIC_MASKS / usize::from(MODULUS));
    for mask in 0_u16..SYMMETRIC_MASKS as u16 {
        let word = symmetric_word(mask);
        let weight = word.iter().copied().map(u16::from).sum::<u16>();
        if weight % u16::from(MODULUS) != u16::from(row_residue) {
            continue;
        }
        let mut autocorrelation = [0_u8; QUOTIENT_SHIFTS];
        for shift in 0..QUOTIENT_SHIFTS {
            let value = (0..QUOTIENT_ORDER)
                .map(|position| {
                    u16::from(word[position] * word[(position + shift) % QUOTIENT_ORDER])
                })
                .sum::<u16>();
            autocorrelation[shift] = (value % u16::from(MODULUS)) as u8;
        }
        profiles.push(BinaryProfile {
            mask,
            autocorrelation,
        });
    }
    profiles
}

fn symmetric_word(mask: u16) -> [u8; QUOTIENT_ORDER] {
    let mut word = [0_u8; QUOTIENT_ORDER];
    word[0] = (mask & 1) as u8;
    word[9] = ((mask >> 9) & 1) as u8;
    for slot in 1..9 {
        let bit = ((mask >> slot) & 1) as u8;
        word[slot] = bit;
        word[QUOTIENT_ORDER - slot] = bit;
    }
    word
}

fn add_packed(left: [u8; QUOTIENT_SHIFTS], right: [u8; QUOTIENT_SHIFTS], active: usize) -> u32 {
    let mut packed = 0_u32;
    let mut place = 1_u32;
    for shift in 0..active {
        packed += u32::from((left[shift] + right[shift]) % MODULUS) * place;
        place *= u32::from(MODULUS);
    }
    packed
}

fn complement_packed(mut packed: u32, active: usize) -> u32 {
    let mut complement = 0_u32;
    let mut place = 1_u32;
    for &target in &TARGET_RESIDUES[..active] {
        let digit = (packed % u32::from(MODULUS)) as u8;
        packed /= u32::from(MODULUS);
        complement += u32::from((target + MODULUS - digit) % MODULUS) * place;
        place *= u32::from(MODULUS);
    }
    complement
}

fn verify_shift_nine_identity() -> Result<(), G53Mod7Error> {
    // For cyclic autocorrelation C, sum_s C(s)=weight^2. Symmetry pairs
    // shifts s and 18-s, leaving shift 9 as the only unpaired nonzero shift.
    let row_residues = [1_u8, 2, 2, 2];
    let total_weight_square = row_residues
        .iter()
        .map(|&weight| u16::from(weight) * u16::from(weight))
        .sum::<u16>()
        % u16::from(MODULUS);
    let paired_known = u16::from(TARGET_RESIDUES[0])
        + 2 * TARGET_RESIDUES[1..9]
            .iter()
            .copied()
            .map(u16::from)
            .sum::<u16>();
    let forced_shift_nine = (total_weight_square + u16::from(MODULUS)
        - paired_known % u16::from(MODULUS))
        % u16::from(MODULUS);
    if forced_shift_nine != u16::from(TARGET_RESIDUES[9]) {
        return Err(G53Mod7Error::SemanticMismatch);
    }
    Ok(())
}

fn verify_five_family_projection() -> Result<(), G53Mod7Error> {
    let partition = CyclicMultiplierOrbitPartition::compile(522, 53)
        .map_err(|_| G53Mod7Error::OrbitProjection)?;
    let mut family_counts = [[0_u8; 2]; 10];
    for orbit in 0..partition.orbit_count() as usize {
        let representative = partition.representatives()[orbit] as usize;
        let mut histogram = [0_u8; QUOTIENT_ORDER];
        let mut point = representative;
        loop {
            histogram[point % QUOTIENT_ORDER] += 1;
            point = point * 53 % 522;
            if point == representative {
                break;
            }
        }
        let scale = if representative % 29 == 0 { 1 } else { 7 };
        let mut first_residue = None;
        for (residue, &count) in histogram.iter().enumerate() {
            if count == 0 {
                continue;
            }
            if count != scale {
                return Err(G53Mod7Error::OrbitProjection);
            }
            if let Some(first) = first_residue {
                if residue != QUOTIENT_ORDER - first {
                    return Err(G53Mod7Error::OrbitProjection);
                }
            } else {
                first_residue = Some(residue);
            }
        }
        let residue = first_residue.ok_or(G53Mod7Error::OrbitProjection)?;
        let slot = residue.min(QUOTIENT_ORDER - residue);
        family_counts[slot][usize::from(scale == 7)] += 1;
    }
    if family_counts != [[1, 4]; 10] {
        return Err(G53Mod7Error::OrbitProjection);
    }
    Ok(())
}

fn descriptor() -> ExtractorDescriptor {
    let mut parameter_hasher = Sha256::new();
    parameter_hasher.update(522_u16.to_le_bytes());
    parameter_hasher.update(18_u16.to_le_bytes());
    parameter_hasher.update([4_u8, MODULUS]);
    parameter_hasher.update(1_043_u32.to_le_bytes());
    parameter_hasher.update(520_u32.to_le_bytes());
    parameter_hasher.update([1_u8, 7, 7, 7, 7]);
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        parameter_hasher.finalize().into(),
        Sha256::digest(SOURCE_SEMANTICS).into(),
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::HashMap;

    fn observation() -> G53Mod7Observation {
        G53Mod7Observation {
            prefix_nine_completions: 2_496,
            full_completions: 2_496,
            shift_nine_redundant: true,
            provenance: ProvenanceClass::ObservedEvolved,
        }
    }

    #[test]
    fn binary_words_are_symmetric_and_have_direct_autocorrelation() {
        for mask in 0_u16..SYMMETRIC_MASKS as u16 {
            let word = symmetric_word(mask);
            for position in 0..QUOTIENT_ORDER {
                assert_eq!(
                    word[position],
                    word[(QUOTIENT_ORDER - position) % QUOTIENT_ORDER]
                );
            }
        }
    }

    #[test]
    fn invalid_prefixes_fail_closed() {
        assert_eq!(count_g53_mod7_prefix(0), Err(G53Mod7Error::InvalidPrefix));
        assert_eq!(count_g53_mod7_prefix(11), Err(G53Mod7Error::InvalidPrefix));
    }

    #[test]
    fn evolved_modular_pattern_becomes_replayed_reduction() {
        let proof = synthesize_g53_mod7_proof(G53Mod7Binding::registered(), observation()).unwrap();
        assert_eq!(proof.raw_modular_assignments, 567_980_928);
        assert_eq!(proof.full_completions, 2_496);
        assert_eq!(proof.theorem_provenance, ProvenanceClass::ProvedStructural);
        assert_eq!(proof.census_provenance, ProvenanceClass::ExactComputational);
        verify_g53_mod7_proof(&proof).unwrap();
    }

    #[test]
    fn correct_fields_with_false_values_and_forged_binding_fail() {
        let mut false_observation = observation();
        false_observation.full_completions += 1;
        assert_eq!(
            synthesize_g53_mod7_proof(G53Mod7Binding::registered(), false_observation),
            Err(G53Mod7Error::SemanticMismatch)
        );

        let mut binding = G53Mod7Binding::registered();
        binding.descriptor = ExtractorDescriptor::registered(
            EXTRACTOR_ID,
            EXTRACTOR_VERSION + 1,
            binding.descriptor.parameter_digest(),
            binding.descriptor.source_commitment(),
        );
        assert_eq!(
            synthesize_g53_mod7_proof(binding, observation()),
            Err(G53Mod7Error::UnregisteredExtractor)
        );
    }

    #[test]
    fn provenance_escalation_and_mutated_result_fail() {
        let mut bad_observation = observation();
        bad_observation.provenance = ProvenanceClass::HeuristicSearch;
        assert_eq!(
            synthesize_g53_mod7_proof(G53Mod7Binding::registered(), bad_observation),
            Err(G53Mod7Error::UnauthorizedProvenance)
        );

        let mut proof =
            synthesize_g53_mod7_proof(G53Mod7Binding::registered(), observation()).unwrap();
        proof.census_provenance = ProvenanceClass::ProvedStructural;
        assert_eq!(
            verify_g53_mod7_proof(&proof),
            Err(G53Mod7Error::UnauthorizedProvenance)
        );
        proof.census_provenance = ProvenanceClass::ExactComputational;
        proof.full_completions += 1;
        assert_eq!(
            verify_g53_mod7_proof(&proof),
            Err(G53Mod7Error::SemanticMismatch)
        );
    }

    #[test]
    fn sorted_join_matches_independent_frequency_oracle() {
        let active = QUOTIENT_SHIFTS;
        let special = compile_profiles(1);
        let zero = compile_profiles(2);
        let mut right = HashMap::<u32, u64>::with_capacity(zero.len() * zero.len());
        for first in &zero {
            for second in &zero {
                let key = add_packed(first.autocorrelation, second.autocorrelation, active);
                *right.entry(key).or_default() += 1;
            }
        }
        let mut oracle = 0_u64;
        for first in &special {
            for second in &zero {
                let left = add_packed(first.autocorrelation, second.autocorrelation, active);
                oracle += right
                    .get(&complement_packed(left, active))
                    .copied()
                    .unwrap_or(0);
            }
        }
        assert_eq!(oracle, 2_496);
        assert_eq!(
            count_g53_mod7_prefix(active as u8)
                .unwrap()
                .ordered_completions,
            oracle
        );
    }

    #[test]
    fn compiled_assignments_satisfy_direct_row_and_autocorrelation_oracles() {
        let assignments = compile_g53_mod7_assignments().unwrap();
        assert_eq!(assignments.len(), 2_496);
        for assignment in assignments.iter() {
            let mut total = [0_u16; QUOTIENT_SHIFTS];
            for (block, &mask) in assignment.iter().enumerate() {
                let word = symmetric_word(mask);
                let weight = word.iter().copied().map(u16::from).sum::<u16>();
                assert_eq!(weight % 7, if block == 0 { 1 } else { 2 });
                for shift in 0..QUOTIENT_SHIFTS {
                    total[shift] += (0..QUOTIENT_ORDER)
                        .map(|position| {
                            u16::from(word[position] * word[(position + shift) % QUOTIENT_ORDER])
                        })
                        .sum::<u16>();
                }
            }
            for shift in 0..QUOTIENT_SHIFTS {
                assert_eq!(total[shift] % 7, u16::from(TARGET_RESIDUES[shift]));
            }
        }
    }

    #[test]
    fn q0_lifts_satisfy_direct_row_and_energy_oracle() {
        let lifts = compile_g53_mod7_q0_lifts_with_limit(Q0_LIFT_BANK_PER_ASSIGNMENT).unwrap();
        assert_eq!(lifts.len(), 2_496 * Q0_LIFT_BANK_PER_ASSIGNMENT);
        for &lift in lifts.iter() {
            let mut total_energy = 0_u32;
            for block in 0..4 {
                let mut row = 0_u32;
                for slot in 0..10 {
                    let multiplicity = if slot == 0 || slot == 9 { 1_u32 } else { 2_u32 };
                    let scale_one = u32::from((lift.scale_one_masks[block] >> slot) & 1);
                    let value = scale_one + 7 * u32::from(lift.scale_seven_count(block, slot));
                    row += multiplicity * value;
                    total_energy += multiplicity * value * value;
                }
                assert_eq!(row, if block == 0 { 260 } else { 261 });
            }
            assert_eq!(total_energy, u32::from(Q0_TARGET));
        }
    }
}
