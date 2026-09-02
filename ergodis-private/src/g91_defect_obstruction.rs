//! Structural q0 obstruction for the private g91 order-2092 multiplier shard.
//!
//! Multiplication by 91 is the identity modulo 18.  In each residue fibre it
//! has one singleton and two size-14 orbits, so every block count is
//! `B=e+14k`, with `e` binary and `k` in `{0,1,2}`.  The quotient zero-shift
//! equation forces defect energy 34 above the `k=1` background, whereas every
//! nonbackground coordinate costs 13 or 15.  The equation
//! `13 n27 + 15 n29 = 34` has no bounded nonnegative solution.

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

const EXTRACTOR_ID: [u8; 16] = *b"c1016-g91-q0-001";
const EXTRACTOR_VERSION: u16 = 1;
const SOURCE_SEMANTICS: &[u8] = b"bordered GS order 2092; carrier 522; multiplier 91; identity action on Z18; one singleton and two size-14 orbit families per residue";
const CARRIER: u16 = 522;
const QUOTIENT: u16 = 18;
const BLOCKS: u8 = 4;
const ROW_WEIGHT_TOTAL: u32 = 1_043;
const INTERSECTION: u32 = 520;
const SIGNED_ENERGY: u32 = 1_976;
const DEFECT_TARGET: u32 = 34;

const FACT_REGISTERED: u8 = 0;
const FACT_ORBIT_PROJECTION: u8 = 1;
const FACT_QUOTIENT_Q0: u8 = 2;
const FACT_SIGNED_ENERGY: u8 = 3;
const FACT_DEFECT_EQUATION: u8 = 4;
const FACT_EMPTY_ENDPOINT: u8 = 5;
const FACT_G91_EXCLUDED: u8 = 6;

const RULES: [RuleSpec; 6] = [
    RuleSpec::registered(0x91_00, 1 << FACT_REGISTERED, FACT_ORBIT_PROJECTION),
    RuleSpec::registered(0x91_01, 1 << FACT_REGISTERED, FACT_QUOTIENT_Q0),
    RuleSpec::registered(
        0x91_02,
        (1 << FACT_ORBIT_PROJECTION) | (1 << FACT_QUOTIENT_Q0),
        FACT_SIGNED_ENERGY,
    ),
    RuleSpec::registered(0x91_03, 1 << FACT_SIGNED_ENERGY, FACT_DEFECT_EQUATION),
    RuleSpec::registered(0x91_04, 1 << FACT_DEFECT_EQUATION, FACT_EMPTY_ENDPOINT),
    RuleSpec::registered(0x91_05, 1 << FACT_EMPTY_ENDPOINT, FACT_G91_EXCLUDED),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G91DefectBinding {
    descriptor: ExtractorDescriptor,
}

impl G91DefectBinding {
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
pub struct G91DefectObservation {
    pub signed_energy: u32,
    pub defect_target: u32,
    pub solution_count: u8,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G91DefectProof {
    pub binding: G91DefectBinding,
    pub quotient_proof: QuotientPafProof,
    pub signed_energy: u32,
    pub defect_target: u32,
    pub candidates_tested: u8,
    pub solution_count: u8,
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G91DefectError {
    #[error("g91 defect extractor is not registered")]
    UnregisteredExtractor,
    #[error("evolved g91 observation disagrees with canonical semantics")]
    SemanticMismatch,
    #[error("proof provenance cannot authorize the structural obstruction")]
    UnauthorizedProvenance,
    #[error("g91 multiplier orbits do not have the claimed Z18 projection")]
    OrbitProjection,
    #[error("g91 structural arithmetic overflowed")]
    Arithmetic,
    #[error(transparent)]
    Quotient(#[from] QuotientPafError),
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_g91_defect_proof(
    binding: G91DefectBinding,
    observation: G91DefectObservation,
) -> Result<G91DefectProof, G91DefectError> {
    if !binding.is_registered() {
        return Err(G91DefectError::UnregisteredExtractor);
    }
    if observation
        != (G91DefectObservation {
            signed_energy: SIGNED_ENERGY,
            defect_target: DEFECT_TARGET,
            solution_count: 0,
            provenance: ProvenanceClass::ObservedEvolved,
        })
    {
        return Err(G91DefectError::SemanticMismatch);
    }
    verify_orbit_projection()?;
    let quotient_proof = canonical_quotient_proof()?;
    let endpoint = solve_bounded_linear_combination(&[13, 15], &[2, 2], DEFECT_TARGET, 9, 1)?;
    if endpoint.candidates_tested != 9 || !endpoint.solutions.is_empty() {
        return Err(G91DefectError::SemanticMismatch);
    }
    verify_scalar_semantics(&quotient_proof)?;
    independent_endpoint_oracle()?;
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED,
        1 << FACT_G91_EXCLUDED,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = G91DefectProof {
        binding,
        quotient_proof,
        signed_energy: SIGNED_ENERGY,
        defect_target: DEFECT_TARGET,
        candidates_tested: endpoint.candidates_tested as u8,
        solution_count: 0,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ProvedStructural,
    };
    verify_g91_defect_proof(&proof)?;
    Ok(proof)
}

pub fn verify_g91_defect_proof(proof: &G91DefectProof) -> Result<(), G91DefectError> {
    if !proof.binding.is_registered() {
        return Err(G91DefectError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ProvedStructural {
        return Err(G91DefectError::UnauthorizedProvenance);
    }
    verify_orbit_projection()?;
    verify_quotient_paf_proof(&proof.quotient_proof)?;
    verify_scalar_semantics(&proof.quotient_proof)?;
    let endpoint = solve_bounded_linear_combination(&[13, 15], &[2, 2], DEFECT_TARGET, 9, 1)?;
    independent_endpoint_oracle()?;
    if proof.quotient_proof != canonical_quotient_proof()?
        || proof.signed_energy != SIGNED_ENERGY
        || proof.defect_target != DEFECT_TARGET
        || proof.candidates_tested != 9
        || proof.solution_count != 0
        || endpoint.candidates_tested != 9
        || !endpoint.solutions.is_empty()
    {
        return Err(G91DefectError::SemanticMismatch);
    }
    replay_g91_defect_rules(&proof.transcript)?;
    Ok(())
}

fn verify_orbit_projection() -> Result<(), G91DefectError> {
    let partition = CyclicMultiplierOrbitPartition::compile(u32::from(CARRIER), 91)
        .map_err(|_| G91DefectError::OrbitProjection)?;
    let mut families = [[0_u8; 2]; QUOTIENT as usize];
    for orbit in 0..partition.orbit_count() as usize {
        let representative = partition.representatives()[orbit] as usize;
        let mut point = representative;
        let residue = representative % QUOTIENT as usize;
        let mut size = 0_u8;
        loop {
            if point % QUOTIENT as usize != residue {
                return Err(G91DefectError::OrbitProjection);
            }
            size += 1;
            point = point * 91 % CARRIER as usize;
            if point == representative {
                break;
            }
        }
        let family = match size {
            1 => 0,
            14 => 1,
            _ => return Err(G91DefectError::OrbitProjection),
        };
        families[residue][family] += 1;
    }
    if families != [[1, 2]; QUOTIENT as usize] {
        return Err(G91DefectError::OrbitProjection);
    }
    Ok(())
}

fn canonical_quotient_proof() -> Result<QuotientPafProof, G91DefectError> {
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

fn verify_scalar_semantics(proof: &QuotientPafProof) -> Result<(), G91DefectError> {
    let signed_energy = i64::from(BLOCKS) * i64::from(QUOTIENT) * 29 * 29
        - 4 * 29 * i64::from(ROW_WEIGHT_TOTAL)
        + 4 * i64::try_from(proof.zero_shift_target).map_err(|_| G91DefectError::Arithmetic)?;
    if signed_energy != i64::from(SIGNED_ENERGY)
        || (signed_energy - i64::from(BLOCKS) * i64::from(QUOTIENT)) / 56
            != i64::from(DEFECT_TARGET)
    {
        return Err(G91DefectError::SemanticMismatch);
    }
    Ok(())
}

fn independent_endpoint_oracle() -> Result<(), G91DefectError> {
    for n27 in 0_u32..=2 {
        for n29 in 0_u32..=2 {
            if 13 * n27 + 15 * n29 == DEFECT_TARGET {
                return Err(G91DefectError::SemanticMismatch);
            }
        }
    }
    Ok(())
}

pub fn derive_g91_defect_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED,
        1 << FACT_G91_EXCLUDED,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_g91_defect_rules(transcript: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_G91_EXCLUDED,
        &RULES,
        transcript,
    )
}

fn descriptor() -> ExtractorDescriptor {
    let mut parameters = Sha256::new();
    parameters.update(CARRIER.to_le_bytes());
    parameters.update(91_u16.to_le_bytes());
    parameters.update(QUOTIENT.to_le_bytes());
    parameters.update([BLOCKS]);
    let parameter_digest = parameters.finalize().into();
    let source_commitment = Sha256::digest(SOURCE_SEMANTICS).into();
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        parameter_digest,
        source_commitment,
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    fn observation() -> G91DefectObservation {
        G91DefectObservation {
            signed_energy: SIGNED_ENERGY,
            defect_target: DEFECT_TARGET,
            solution_count: 0,
            provenance: ProvenanceClass::ObservedEvolved,
        }
    }

    #[test]
    fn evolved_observation_becomes_structural_q0_obstruction() {
        let proof =
            synthesize_g91_defect_proof(G91DefectBinding::registered(), observation()).unwrap();
        assert_eq!(proof.candidates_tested, 9);
        assert_eq!(proof.solution_count, 0);
        verify_g91_defect_proof(&proof).unwrap();
    }

    #[test]
    fn forged_observation_binding_and_provenance_fail() {
        let mut false_observation = observation();
        false_observation.solution_count = 1;
        assert_eq!(
            synthesize_g91_defect_proof(G91DefectBinding::registered(), false_observation),
            Err(G91DefectError::SemanticMismatch)
        );
        let mut binding = G91DefectBinding::registered();
        binding.descriptor = ExtractorDescriptor::registered([0; 16], 1, [0; 32], [0; 32]);
        assert_eq!(
            synthesize_g91_defect_proof(binding, observation()),
            Err(G91DefectError::UnregisteredExtractor)
        );
        let mut proof =
            synthesize_g91_defect_proof(G91DefectBinding::registered(), observation()).unwrap();
        proof.provenance = ProvenanceClass::ObservedEvolved;
        assert_eq!(
            verify_g91_defect_proof(&proof),
            Err(G91DefectError::UnauthorizedProvenance)
        );
    }
}
