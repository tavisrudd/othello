//! Sealed structural proof adapter for the generator-53 CRT reduction.
//!
//! The adapter is deliberately private.  Evolved observations are hypotheses;
//! authority comes only from replaying the registered extractor against the
//! raw multiplier permutation, exact character arithmetic, and the private
//! exact joint-census compiler.

use serde::{Deserialize, Serialize};
use std::sync::OnceLock;
use thiserror::Error;

use crate::hadamard_2092::compile_generator_53_order_two_three_six_twenty_nine_census;
use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

const CARRIER: u16 = 522;
const GENERATOR: u16 = 53;
const CHARACTER_ORDERS: [u8; 4] = [2, 3, 6, 29];
const EXTRACTOR_ID: [u8; 16] = *b"c1016-g53-crt001";
const PARAMETER_DIGEST: [u8; 32] = [
    0x59, 0xd2, 0x82, 0x56, 0xb7, 0xda, 0x70, 0xb2, 0x7f, 0xe6, 0x78, 0x64, 0xd5, 0x4b, 0x36, 0x61,
    0x72, 0xdb, 0xc7, 0x1e, 0x51, 0xa1, 0xb2, 0x19, 0x6c, 0x19, 0x76, 0x1d, 0x3f, 0x87, 0x7d, 0xdd,
];
const SOURCE_COMMITMENT: [u8; 32] = [
    0xa6, 0xdd, 0x52, 0x9e, 0xbd, 0x8c, 0x9e, 0x80, 0x84, 0x87, 0xed, 0xb0, 0x41, 0xdf, 0x39, 0xc7,
    0x92, 0x22, 0xb5, 0xea, 0x6a, 0x12, 0x7e, 0x0a, 0xba, 0xa4, 0x04, 0xc2, 0x14, 0xc8, 0x55, 0xa7,
];

const FACT_OBSERVATION: u8 = 0;
const FACT_BINDING: u8 = 1;
const FACT_RAW_ORBITS: u8 = 2;
const FACT_FIVE_FAMILIES: u8 = 3;
const FACT_SCALES: u8 = 4;
const FACT_RATIONAL_WEIGHTS: u8 = 5;
const FACT_Q29_COORDINATES: u8 = 6;
const FACT_EXACT_CENSUS: u8 = 7;
const FACT_GOAL: u8 = 8;

const RULES: [RuleSpec; 7] = [
    RuleSpec::registered(0x53_01, 1 << FACT_BINDING, FACT_RAW_ORBITS),
    RuleSpec::registered(0x53_02, 1 << FACT_RAW_ORBITS, FACT_FIVE_FAMILIES),
    RuleSpec::registered(0x53_03, 1 << FACT_FIVE_FAMILIES, FACT_SCALES),
    RuleSpec::registered(
        0x53_04,
        (1 << FACT_RAW_ORBITS) | (1 << FACT_SCALES),
        FACT_RATIONAL_WEIGHTS,
    ),
    RuleSpec::registered(
        0x53_05,
        (1 << FACT_FIVE_FAMILIES) | (1 << FACT_SCALES),
        FACT_Q29_COORDINATES,
    ),
    RuleSpec::registered(
        0x53_06,
        (1 << FACT_RATIONAL_WEIGHTS) | (1 << FACT_Q29_COORDINATES),
        FACT_EXACT_CENSUS,
    ),
    RuleSpec::registered(
        0x53_07,
        (1 << FACT_OBSERVATION) | (1 << FACT_EXACT_CENSUS),
        FACT_GOAL,
    ),
];

const COSETS: [[u8; 7]; 4] = [
    [1, 7, 16, 20, 23, 24, 25],
    [2, 3, 11, 14, 17, 19, 21],
    [4, 5, 6, 9, 13, 22, 28],
    [8, 10, 12, 15, 18, 26, 27],
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53ExtractorBinding {
    descriptor: ExtractorDescriptor,
    carrier: u16,
    generator: u16,
    character_orders: [u8; 4],
}

impl G53ExtractorBinding {
    #[must_use]
    pub const fn registered() -> Self {
        Self {
            descriptor: ExtractorDescriptor::registered(
                EXTRACTOR_ID,
                1,
                PARAMETER_DIGEST,
                SOURCE_COMMITMENT,
            ),
            carrier: CARRIER,
            generator: GENERATOR,
            character_orders: CHARACTER_ORDERS,
        }
    }

    fn is_registered(self) -> bool {
        self.descriptor.identity() == EXTRACTOR_ID
            && self.descriptor.version() == 1
            && self.descriptor.parameter_digest() == PARAMETER_DIGEST
            && self.descriptor.source_commitment() == SOURCE_COMMITMENT
            && self.carrier == CARRIER
            && self.generator == GENERATOR
            && self.character_orders == CHARACTER_ORDERS
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct FamilyInventory {
    pub size_one: u8,
    pub size_two: u8,
    pub size_seven: u8,
    pub size_fourteen: u8,
}

const _: () = assert!(std::mem::size_of::<FamilyInventory>() == 4);

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53PresentedClaim {
    pub families: [FamilyInventory; 5],
    pub rational_scales: [u8; 5],
    pub q29_scales: [u8; 5],
    pub rational_profiles: u64,
    pub special_joint_signatures: u32,
    pub zero_joint_signatures: u32,
    pub labelled_assignments: u128,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53StructuralProof {
    pub extractor: G53ExtractorBinding,
    pub claim: G53PresentedClaim,
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53ProofError {
    #[error("generator-53 extractor binding is not registered")]
    UnregisteredExtractor,
    #[error("claim provenance does not authorize the requested proof role")]
    UnauthorizedProvenance,
    #[error("presented structural fields disagree with independent replay")]
    SemanticMismatch,
    #[error("raw multiplier permutation or character arithmetic is inconsistent")]
    ArithmeticReplay,
    #[error("exact private census compilation failed")]
    Census,
    #[error("exact census count does not fit the bound proof schema")]
    CensusOverflow,
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

/// Compile a compact proof from an evolved claim.  The claim is accepted only
/// after every field is independently recomputed; its provenance is then
/// upgraded from `ObservedEvolved` to `ExactComputational`. The orbit and
/// character identities are structural; the exact surviving-count fields are
/// deliberately not mislabeled as theorem-only authority.
pub fn synthesize_g53_structural_proof(
    extractor: G53ExtractorBinding,
    presented: &G53PresentedClaim,
) -> Result<G53StructuralProof, G53ProofError> {
    if !extractor.is_registered() {
        return Err(G53ProofError::UnregisteredExtractor);
    }
    let replayed = replay_raw_claim()?;
    if presented.provenance != ProvenanceClass::ObservedEvolved {
        return Err(G53ProofError::UnauthorizedProvenance);
    }
    if !same_semantics(presented, &replayed) {
        return Err(G53ProofError::SemanticMismatch);
    }
    let initial = (1 << FACT_OBSERVATION) | (1 << FACT_BINDING);
    let derivation = derive_horn_closure(initial, 1 << FACT_GOAL, &RULES, RULES.len() as u32)?;
    Ok(G53StructuralProof {
        extractor,
        claim: replayed,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ExactComputational,
    })
}

/// Replay proof authority without trusting any presented feature name/value.
pub fn verify_g53_structural_proof(proof: &G53StructuralProof) -> Result<(), G53ProofError> {
    if !proof.extractor.is_registered() {
        return Err(G53ProofError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ExactComputational
        || proof.claim.provenance != ProvenanceClass::ExactComputational
    {
        return Err(G53ProofError::UnauthorizedProvenance);
    }
    let replayed = replay_raw_claim()?;
    if proof.claim != replayed {
        return Err(G53ProofError::SemanticMismatch);
    }
    replay_g53_rules(&proof.transcript)?;
    Ok(())
}

/// Zero-allocation Horn compiler kernel.  Raw arithmetic and census replay are
/// intentionally cold proof-compilation stages outside this kernel.
pub fn derive_g53_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        (1 << FACT_OBSERVATION) | (1 << FACT_BINDING),
        1 << FACT_GOAL,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

/// Zero-allocation iterative replay against the sealed rule registry.
pub fn replay_g53_rules(applications: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        (1 << FACT_OBSERVATION) | (1 << FACT_BINDING),
        1 << FACT_GOAL,
        &RULES,
        applications,
    )
}

fn same_semantics(left: &G53PresentedClaim, right: &G53PresentedClaim) -> bool {
    left.families == right.families
        && left.rational_scales == right.rational_scales
        && left.q29_scales == right.q29_scales
        && left.rational_profiles == right.rational_profiles
        && left.special_joint_signatures == right.special_joint_signatures
        && left.zero_joint_signatures == right.zero_joint_signatures
        && left.labelled_assignments == right.labelled_assignments
}

fn replay_raw_claim() -> Result<G53PresentedClaim, G53ProofError> {
    static CLAIM: OnceLock<Result<G53PresentedClaim, G53ProofError>> = OnceLock::new();
    CLAIM.get_or_init(replay_raw_claim_uncached).clone()
}

fn replay_raw_claim_uncached() -> Result<G53PresentedClaim, G53ProofError> {
    let families = replay_orbit_families_and_characters()?;
    // A nonzero q29 family is a seven-fold lift of one Z/18 negation
    // family. Rational character sums therefore scale by seven, whereas its
    // q29 Gaussian-period coefficient is the unscaled selected count.
    let rational_scales = [1, 7, 7, 7, 7];
    let q29_scales = [1; 5];
    replay_q29_autocorrelation_coordinates()?;

    let census = compile_generator_53_order_two_three_six_twenty_nine_census()
        .map_err(|_| G53ProofError::Census)?;
    let labelled_assignments = census
        .labelled_assignments
        .to_str_radix(10)
        .parse::<u128>()
        .map_err(|_| G53ProofError::CensusOverflow)?;
    Ok(G53PresentedClaim {
        families,
        rational_scales,
        q29_scales,
        rational_profiles: census.rational_profiles,
        special_joint_signatures: census.special_joint_signatures,
        zero_joint_signatures: census.zero_joint_signatures,
        labelled_assignments,
        provenance: ProvenanceClass::ExactComputational,
    })
}

fn replay_orbit_families_and_characters() -> Result<[FamilyInventory; 5], G53ProofError> {
    let mut seen = [false; CARRIER as usize];
    let mut inventories = [FamilyInventory {
        size_one: 0,
        size_two: 0,
        size_seven: 0,
        size_fourteen: 0,
    }; 5];
    let mut orbit_points = [0_u16; 14];

    for start in 0..CARRIER {
        if seen[usize::from(start)] {
            continue;
        }
        let mut point = start;
        let mut size = 0_usize;
        loop {
            if size == orbit_points.len() || seen[usize::from(point)] {
                return Err(G53ProofError::ArithmeticReplay);
            }
            seen[usize::from(point)] = true;
            orbit_points[size] = point;
            size += 1;
            point = ((u32::from(point) * u32::from(GENERATOR)) % u32::from(CARRIER)) as u16;
            if point == start {
                break;
            }
        }
        let family = q29_family((start % 29) as u8)?;
        match size {
            1 => inventories[family].size_one += 1,
            2 => inventories[family].size_two += 1,
            7 => inventories[family].size_seven += 1,
            14 => inventories[family].size_fourteen += 1,
            _ => return Err(G53ProofError::ArithmeticReplay),
        }
        let scale = if family == 0 { 1_i16 } else { 7_i16 };
        for order in [2_u8, 3, 6] {
            let mut basis = [0_i16; 2];
            for &member in &orbit_points[..size] {
                let value = character_basis(order, (member % u16::from(order)) as u8);
                basis[0] += value[0];
                basis[1] += value[1];
            }
            if basis[1] != 0 || basis[0] % scale != 0 {
                return Err(G53ProofError::ArithmeticReplay);
            }
        }
    }
    let expected_zero = FamilyInventory {
        size_one: 2,
        size_two: 8,
        size_seven: 0,
        size_fourteen: 0,
    };
    let expected_nonzero = FamilyInventory {
        size_one: 0,
        size_two: 0,
        size_seven: 2,
        size_fourteen: 8,
    };
    if inventories[0] != expected_zero || inventories[1..].iter().any(|&x| x != expected_nonzero) {
        return Err(G53ProofError::ArithmeticReplay);
    }
    Ok(inventories)
}

const fn character_basis(order: u8, residue: u8) -> [i16; 2] {
    match order {
        2 => {
            if residue == 0 {
                [1, 0]
            } else {
                [-1, 0]
            }
        }
        3 => match residue {
            0 => [1, 0],
            1 => [0, 1],
            _ => [-1, -1],
        },
        6 => match residue {
            0 => [1, 0],
            1 => [1, 1],
            2 => [0, 1],
            3 => [-1, 0],
            4 => [-1, -1],
            _ => [0, -1],
        },
        _ => [0, 0],
    }
}

fn q29_family(residue: u8) -> Result<usize, G53ProofError> {
    if residue == 0 {
        return Ok(0);
    }
    COSETS
        .iter()
        .position(|coset| coset.contains(&residue))
        .map(|index| index + 1)
        .ok_or(G53ProofError::ArithmeticReplay)
}

fn replay_q29_autocorrelation_coordinates() -> Result<(), G53ProofError> {
    // Autocorrelation is a quadratic form in the five family counts. Values
    // on the five basis vectors and their ten pairwise sums determine it
    // identically, avoiding a large certificate or exhaustive 19^5 table.
    let mut vector = [0_i32; 5];
    for first in 0..5 {
        vector.fill(0);
        vector[first] = 1;
        check_q29_vector(vector)?;
        for second in first + 1..5 {
            vector[second] = 1;
            check_q29_vector(vector)?;
            vector[second] = 0;
        }
    }
    Ok(())
}

fn check_q29_vector(vector: [i32; 5]) -> Result<(), G53ProofError> {
    let mut coefficients = [0_i32; 29];
    coefficients[0] = vector[0];
    for (count, coset) in vector[1..].iter().copied().zip(COSETS) {
        for residue in coset {
            coefficients[usize::from(residue)] = count;
        }
    }
    let correlation = |shift: usize| -> i32 {
        (0..29)
            .map(|index| coefficients[index] * coefficients[(index + shift) % 29])
            .sum()
    };
    let residue = correlation(1);
    let nonresidue = correlation(2);
    for coset in [COSETS[0], COSETS[2]] {
        for shift in coset {
            if correlation(usize::from(shift)) != residue {
                return Err(G53ProofError::ArithmeticReplay);
            }
        }
    }
    for coset in [COSETS[1], COSETS[3]] {
        for shift in coset {
            if correlation(usize::from(shift)) != nonresidue {
                return Err(G53ProofError::ArithmeticReplay);
            }
        }
    }
    let c0 = correlation(0);
    let constant = 2 * (2 * c0 - residue - nonresidue);
    if constant < 0 {
        return Err(G53ProofError::ArithmeticReplay);
    }
    Ok(())
}

pub(crate) fn evolve_rule_system() -> (&'static [RuleSpec], u64, u64) {
    (
        &RULES,
        (1 << FACT_OBSERVATION) | (1 << FACT_BINDING),
        1 << FACT_GOAL,
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    fn evolved_claim() -> G53PresentedClaim {
        let mut claim = replay_raw_claim().unwrap();
        claim.provenance = ProvenanceClass::ObservedEvolved;
        claim
    }

    #[test]
    fn evolved_g53_claim_becomes_replayed_structural_proof() {
        let proof =
            synthesize_g53_structural_proof(G53ExtractorBinding::registered(), &evolved_claim())
                .unwrap();
        assert_eq!(proof.transcript.len(), RULES.len());
        assert_eq!(
            proof.claim.labelled_assignments,
            64_949_798_014_649_517_492_352_112_253_500_547_072
        );
        verify_g53_structural_proof(&proof).unwrap();
    }

    #[test]
    fn correct_fields_with_false_value_are_rejected() {
        let mut claim = evolved_claim();
        claim.zero_joint_signatures += 1;
        assert_eq!(
            synthesize_g53_structural_proof(G53ExtractorBinding::registered(), &claim),
            Err(G53ProofError::SemanticMismatch)
        );
    }

    #[test]
    fn forged_binding_is_rejected() {
        let mut binding = G53ExtractorBinding::registered();
        binding.generator = 91;
        assert_eq!(
            synthesize_g53_structural_proof(binding, &evolved_claim()),
            Err(G53ProofError::UnregisteredExtractor)
        );
    }

    #[test]
    fn mutated_rule_transcript_is_rejected() {
        let mut proof =
            synthesize_g53_structural_proof(G53ExtractorBinding::registered(), &evolved_claim())
                .unwrap();
        proof.transcript[0].rule ^= 1;
        assert!(matches!(
            verify_g53_structural_proof(&proof),
            Err(G53ProofError::Synthesis(SynthesisError::InvalidTranscript))
        ));
    }

    #[test]
    fn provenance_escalation_is_rejected() {
        let mut proof =
            synthesize_g53_structural_proof(G53ExtractorBinding::registered(), &evolved_claim())
                .unwrap();
        proof.provenance = ProvenanceClass::ProvedStructural;
        assert_eq!(
            verify_g53_structural_proof(&proof),
            Err(G53ProofError::UnauthorizedProvenance)
        );
    }

    #[test]
    fn horn_kernels_use_caller_owned_workspace() {
        let mut workspace = [RuleApplication::EMPTY; 8];
        let (_, used) = derive_g53_rules_into(&mut workspace).unwrap();
        assert_eq!(used, RULES.len());
        replay_g53_rules(&workspace[..used]).unwrap();
    }

    #[test]
    fn raw_orbit_and_q29_oracles_pass_separately() {
        replay_orbit_families_and_characters().unwrap();
        replay_q29_autocorrelation_coordinates().unwrap();
    }
}
