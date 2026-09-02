//! Structural g53 defect-profile theorem synthesized from quotient PAF.
//!
//! The five multiplier-orbit families contribute `B=e+7k` to every Z/18
//! residue marginal.  Combining this with the proved zero-shift quotient-PAF
//! target forces almost every coordinate onto the `k=2` background and leaves
//! only ten bounded defect-magnitude profiles.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::hadamard_2092::CyclicMultiplierOrbitPartition;
use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation,
    solve_bounded_linear_combination, ExtractorDescriptor, ProvenanceClass, RuleApplication,
    RuleSpec, SynthesisError,
};
use crate::quotient_paf_proof::{
    synthesize_quotient_paf_proof, verify_quotient_paf_proof, QuotientPafBinding, QuotientPafError,
    QuotientPafInstance, QuotientPafProof,
};

const EXTRACTOR_ID: [u8; 16] = *b"c1016-g53-def001";
const EXTRACTOR_VERSION: u16 = 1;
const SOURCE_SEMANTICS: &[u8] = b"g53 Z522 orbit projection to Z18: one scale-1 and four scale-7 families per negation coordinate; quotient PAF zero fibre";
const CARRIER: u16 = 522;
const QUOTIENT: u16 = 18;
const BLOCKS: u8 = 4;
const ROW_WEIGHT_TOTAL: u32 = 1_043;
const INTERSECTION: u32 = 520;
#[cfg(test)]
const SIGNED_ENERGY: u32 = 1_976;
#[cfg(test)]
const DEFECT_TARGET: u32 = 34;
const DEFECT_WEIGHTS: [u16; 4] = [15, 13, 4, 3];
const DEFECT_BOUNDS: [u16; 4] = [2, 2, 8, 11];

const FACT_REGISTERED_EXTRACTOR: u8 = 0;
const FACT_FIVE_FAMILY_PROJECTION: u8 = 1;
const FACT_QUOTIENT_ZERO_SHIFT: u8 = 2;
const FACT_SIGNED_ENERGY: u8 = 3;
const FACT_DEFECT_EQUATION: u8 = 4;
const FACT_TEN_PROFILES: u8 = 5;
const FACT_BACKGROUND_BOUND: u8 = 6;

const RULES: [RuleSpec; 6] = [
    RuleSpec::registered(
        0x53_d1,
        1 << FACT_REGISTERED_EXTRACTOR,
        FACT_FIVE_FAMILY_PROJECTION,
    ),
    RuleSpec::registered(
        0x53_d2,
        1 << FACT_REGISTERED_EXTRACTOR,
        FACT_QUOTIENT_ZERO_SHIFT,
    ),
    RuleSpec::registered(
        0x53_d3,
        (1 << FACT_FIVE_FAMILY_PROJECTION) | (1 << FACT_QUOTIENT_ZERO_SHIFT),
        FACT_SIGNED_ENERGY,
    ),
    RuleSpec::registered(0x53_d4, 1 << FACT_SIGNED_ENERGY, FACT_DEFECT_EQUATION),
    RuleSpec::registered(0x53_d5, 1 << FACT_DEFECT_EQUATION, FACT_TEN_PROFILES),
    RuleSpec::registered(0x53_d6, 1 << FACT_TEN_PROFILES, FACT_BACKGROUND_BOUND),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53DefectBinding {
    descriptor: ExtractorDescriptor,
}

impl G53DefectBinding {
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
pub struct G53DefectObservation {
    pub signed_energy: u32,
    pub defect_target: u32,
    pub profile_count: u8,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53DefectProfileProof {
    pub binding: G53DefectBinding,
    pub quotient_proof: QuotientPafProof,
    /// `[n29,n27,n15,n13]` in deterministic odometer order.
    pub profiles: Box<[[u8; 4]]>,
    pub maximum_defect_entries: u8,
    pub minimum_background_coordinates: u8,
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53DefectError {
    #[error("g53 defect extractor is not registered")]
    UnregisteredExtractor,
    #[error("evolved defect observation disagrees with canonical semantics")]
    SemanticMismatch,
    #[error("proof provenance cannot authorize a structural theorem")]
    UnauthorizedProvenance,
    #[error("raw g53 multiplier orbits do not have the five-family projection")]
    OrbitProjection,
    #[error("structural arithmetic overflowed")]
    ArithmeticOverflow,
    #[error(transparent)]
    Quotient(#[from] QuotientPafError),
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_g53_defect_profile_proof(
    binding: G53DefectBinding,
    observation: G53DefectObservation,
) -> Result<G53DefectProfileProof, G53DefectError> {
    if !binding.is_registered() {
        return Err(G53DefectError::UnregisteredExtractor);
    }
    let (signed_energy, defect_target) = derive_scalar_semantics()?;
    if observation.provenance != ProvenanceClass::ObservedEvolved
        || observation.signed_energy != signed_energy
        || observation.defect_target != defect_target
        || observation.profile_count != 10
    {
        return Err(G53DefectError::SemanticMismatch);
    }
    verify_five_family_projection()?;
    let quotient_proof = canonical_quotient_proof()?;
    let profiles = derive_profiles()?;
    let (maximum_defect_entries, minimum_background_coordinates) =
        derive_background_bounds(&profiles)?;
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_BACKGROUND_BOUND,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = G53DefectProfileProof {
        binding,
        quotient_proof,
        profiles,
        maximum_defect_entries,
        minimum_background_coordinates,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ProvedStructural,
    };
    verify_g53_defect_profile_proof(&proof)?;
    Ok(proof)
}

pub fn verify_g53_defect_profile_proof(
    proof: &G53DefectProfileProof,
) -> Result<(), G53DefectError> {
    if !proof.binding.is_registered() {
        return Err(G53DefectError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ProvedStructural {
        return Err(G53DefectError::UnauthorizedProvenance);
    }
    verify_five_family_projection()?;
    verify_quotient_paf_proof(&proof.quotient_proof)?;
    let profiles = derive_profiles()?;
    let bounds = derive_background_bounds(&profiles)?;
    if proof.quotient_proof != canonical_quotient_proof()?
        || proof.profiles != profiles
        || (
            proof.maximum_defect_entries,
            proof.minimum_background_coordinates,
        ) != bounds
    {
        return Err(G53DefectError::SemanticMismatch);
    }
    replay_g53_defect_rules(&proof.transcript)?;
    Ok(())
}

pub fn derive_g53_defect_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_BACKGROUND_BOUND,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_g53_defect_rules(transcript: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_BACKGROUND_BOUND,
        &RULES,
        transcript,
    )
}

fn canonical_quotient_proof() -> Result<QuotientPafProof, G53DefectError> {
    Ok(synthesize_quotient_paf_proof(
        QuotientPafBinding::registered(QuotientPafInstance {
            carrier: CARRIER,
            quotient_order: QUOTIENT,
            block_count: BLOCKS,
            row_weight_total: ROW_WEIGHT_TOTAL,
            uniform_nonzero_intersection: INTERSECTION,
        })?,
    )?)
}

fn derive_profiles() -> Result<Box<[[u8; 4]]>, G53DefectError> {
    let (_, defect_target) = derive_scalar_semantics()?;
    let endpoint = solve_bounded_linear_combination(
        &DEFECT_WEIGHTS,
        &DEFECT_BOUNDS,
        defect_target,
        1_000,
        16,
    )?;
    if endpoint.solutions.len() != 10 {
        return Err(G53DefectError::SemanticMismatch);
    }
    let mut profiles = Vec::with_capacity(endpoint.solutions.len());
    for solution in &endpoint.solutions {
        profiles.push(std::array::from_fn(|index| solution.values[index] as u8));
    }
    Ok(profiles.into_boxed_slice())
}

fn derive_scalar_semantics() -> Result<(u32, u32), G53DefectError> {
    let quotient = canonical_quotient_proof()?;
    let signed_energy = i64::from(BLOCKS) * i64::from(QUOTIENT) * 29 * 29
        - 4 * 29 * i64::from(ROW_WEIGHT_TOTAL)
        + 4 * i64::try_from(quotient.zero_shift_target)
            .map_err(|_| G53DefectError::ArithmeticOverflow)?;
    let signed_energy =
        u32::try_from(signed_energy).map_err(|_| G53DefectError::ArithmeticOverflow)?;
    let baseline = u32::from(BLOCKS) * u32::from(QUOTIENT);
    let excess = signed_energy
        .checked_sub(baseline)
        .ok_or(G53DefectError::ArithmeticOverflow)?;
    if excess % 56 != 0 {
        return Err(G53DefectError::SemanticMismatch);
    }
    Ok((signed_energy, excess / 56))
}

fn derive_background_bounds(profiles: &[[u8; 4]]) -> Result<(u8, u8), G53DefectError> {
    let maximum_entries = profiles
        .iter()
        .map(|profile| profile.iter().copied().sum::<u8>())
        .max()
        .ok_or(G53DefectError::SemanticMismatch)?;
    let singleton_defects = maximum_entries.min(8);
    let independent_defects = singleton_defects + (maximum_entries - singleton_defects) / 2;
    let minimum_background = 40_u8
        .checked_sub(independent_defects)
        .ok_or(G53DefectError::ArithmeticOverflow)?;
    Ok((maximum_entries, minimum_background))
}

fn verify_five_family_projection() -> Result<(), G53DefectError> {
    let partition = CyclicMultiplierOrbitPartition::compile(u32::from(CARRIER), 53)
        .map_err(|_| G53DefectError::OrbitProjection)?;
    let mut family_counts = [[0_u8; 2]; 10];
    for orbit in 0..partition.orbit_count() as usize {
        let representative = partition.representatives()[orbit] as usize;
        let mut histogram = [0_u8; QUOTIENT as usize];
        let mut point = representative;
        loop {
            histogram[point % QUOTIENT as usize] += 1;
            point = point * 53 % CARRIER as usize;
            if point == representative {
                break;
            }
        }
        let scale = if representative % 29 == 0 { 1 } else { 7 };
        let mut residues = [0_usize; 2];
        let mut used = 0_usize;
        for (residue, &count) in histogram.iter().enumerate() {
            if count != 0 {
                if used == residues.len() || usize::from(count) != scale {
                    return Err(G53DefectError::OrbitProjection);
                }
                residues[used] = residue;
                used += 1;
            }
        }
        if used == 0 || used > 2 || (used == 2 && residues[1] != QUOTIENT as usize - residues[0]) {
            return Err(G53DefectError::OrbitProjection);
        }
        let slot = residues[0].min(QUOTIENT as usize - residues[0]);
        family_counts[slot][usize::from(scale == 7)] += 1;
    }
    if family_counts != [[1, 4]; 10] {
        return Err(G53DefectError::OrbitProjection);
    }
    Ok(())
}

fn descriptor() -> ExtractorDescriptor {
    let mut parameter_hasher = Sha256::new();
    parameter_hasher.update(CARRIER.to_le_bytes());
    parameter_hasher.update(QUOTIENT.to_le_bytes());
    parameter_hasher.update([BLOCKS]);
    parameter_hasher.update(ROW_WEIGHT_TOTAL.to_le_bytes());
    parameter_hasher.update(INTERSECTION.to_le_bytes());
    parameter_hasher.update([1_u8, 7, 7, 7, 7]);
    let parameter_digest = parameter_hasher.finalize().into();
    let source_commitment = Sha256::digest(SOURCE_SEMANTICS).into();
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        parameter_digest,
        source_commitment,
    )
}

pub(crate) fn evolve_rule_system() -> (&'static [RuleSpec], u64, u64) {
    (
        &RULES,
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_BACKGROUND_BOUND,
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    fn observation() -> G53DefectObservation {
        G53DefectObservation {
            signed_energy: SIGNED_ENERGY,
            defect_target: DEFECT_TARGET,
            profile_count: 10,
            provenance: ProvenanceClass::ObservedEvolved,
        }
    }

    #[test]
    fn evolved_defect_pattern_becomes_compact_structural_proof() {
        let proof =
            synthesize_g53_defect_profile_proof(G53DefectBinding::registered(), observation())
                .unwrap();
        assert_eq!(proof.profiles.len(), 10);
        assert_eq!(proof.minimum_background_coordinates, 31);
        verify_g53_defect_profile_proof(&proof).unwrap();
    }

    #[test]
    fn profile_list_matches_independent_four_loop_oracle() {
        let profiles = derive_profiles().unwrap();
        let mut oracle = Vec::new();
        for n29 in 0_u8..=2 {
            for n27 in 0_u8..=2 {
                for n15 in 0_u8..=8 {
                    for n13 in 0_u8..=11 {
                        if 15 * u32::from(n29)
                            + 13 * u32::from(n27)
                            + 4 * u32::from(n15)
                            + 3 * u32::from(n13)
                            == DEFECT_TARGET
                        {
                            oracle.push([n29, n27, n15, n13]);
                        }
                    }
                }
            }
        }
        assert_eq!(profiles.as_ref(), oracle.as_slice());
    }

    #[test]
    fn false_observation_forged_binding_and_mutated_proof_fail() {
        let mut false_observation = observation();
        false_observation.profile_count = 9;
        assert_eq!(
            synthesize_g53_defect_profile_proof(G53DefectBinding::registered(), false_observation),
            Err(G53DefectError::SemanticMismatch)
        );

        let mut binding = G53DefectBinding::registered();
        binding.descriptor = ExtractorDescriptor::registered([0; 16], 1, [0; 32], [0; 32]);
        assert_eq!(
            synthesize_g53_defect_profile_proof(binding, observation()),
            Err(G53DefectError::UnregisteredExtractor)
        );

        let mut proof =
            synthesize_g53_defect_profile_proof(G53DefectBinding::registered(), observation())
                .unwrap();
        proof.provenance = ProvenanceClass::HeuristicSearch;
        assert_eq!(
            verify_g53_defect_profile_proof(&proof),
            Err(G53DefectError::UnauthorizedProvenance)
        );
    }
}
