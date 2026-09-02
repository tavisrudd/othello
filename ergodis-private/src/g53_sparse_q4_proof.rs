//! Sealed proof object for the private g53 q0--q4 exclusion.
//!
//! The payload is the ten-row special-mask fibre theorem.  Verification
//! rebuilds the structural defect reduction, the optimized exact fibres, and
//! the independent full-base-five/hash-join oracle.  No pair transcript or
//! large negative certificate is trusted or stored.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g53_defect_profile_proof::{
    synthesize_g53_defect_profile_proof, verify_g53_defect_profile_proof, G53DefectBinding,
    G53DefectError, G53DefectObservation, G53DefectProfileProof,
};
use crate::g53_sparse_prefix::{census_g53_q4_fibres, G53Q4SpecialMaskClass, G53SparsePrefixError};
use crate::g53_sparse_q4_oracle::{verify_g53_sparse_q4_census, G53SparseQ4OracleError};
use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

const EXTRACTOR_ID: [u8; 16] = *b"c1016-g53-q4-001";
const EXTRACTOR_VERSION: u16 = 1;
const SOURCE_SEMANTICS: &[u8] = b"bordered GS order 2092; carrier 522; multiplier 53; Z18 quotient; exact q0-q3 sparse defect fibres and q4 exclusion";
const ROOTS: u16 = 2_496;
const ACTIVE_SHIFTS: u8 = 5;

const FACT_REGISTERED: u8 = 0;
const FACT_DEFECT_THEOREM: u8 = 1;
const FACT_MOD7_ROOTS: u8 = 2;
const FACT_SPARSE_PROFILES: u8 = 3;
const FACT_FOUR_FIBRES: u8 = 4;
const FACT_INDEPENDENT_REPLAY: u8 = 5;
const FACT_Q4_EXCLUSION: u8 = 6;

const RULES: [RuleSpec; 6] = [
    RuleSpec::registered(0x53_40, 1 << FACT_REGISTERED, FACT_DEFECT_THEOREM),
    RuleSpec::registered(0x53_41, 1 << FACT_REGISTERED, FACT_MOD7_ROOTS),
    RuleSpec::registered(
        0x53_42,
        (1 << FACT_DEFECT_THEOREM) | (1 << FACT_MOD7_ROOTS),
        FACT_SPARSE_PROFILES,
    ),
    RuleSpec::registered(0x53_43, 1 << FACT_SPARSE_PROFILES, FACT_FOUR_FIBRES),
    RuleSpec::registered(
        0x53_44,
        (1 << FACT_SPARSE_PROFILES) | (1 << FACT_FOUR_FIBRES),
        FACT_INDEPENDENT_REPLAY,
    ),
    RuleSpec::registered(
        0x53_45,
        (1 << FACT_FOUR_FIBRES) | (1 << FACT_INDEPENDENT_REPLAY),
        FACT_Q4_EXCLUSION,
    ),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53SparseQ4Binding {
    descriptor: ExtractorDescriptor,
}

impl G53SparseQ4Binding {
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

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53SparseQ4Proof {
    pub binding: G53SparseQ4Binding,
    pub defect_proof: G53DefectProfileProof,
    pub roots: u16,
    pub active_shifts: u8,
    pub special_mask_classes: Box<[G53Q4SpecialMaskClass]>,
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53SparseQ4ProofError {
    #[error("g53 sparse-q4 extractor is not registered")]
    UnregisteredExtractor,
    #[error("proof provenance cannot authorize the exact negative census")]
    UnauthorizedProvenance,
    #[error("optimized and independent sparse-q4 semantics disagree")]
    SemanticMismatch,
    #[error(transparent)]
    Defect(#[from] G53DefectError),
    #[error(transparent)]
    Prefix(#[from] G53SparsePrefixError),
    #[error(transparent)]
    Oracle(#[from] G53SparseQ4OracleError),
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_g53_sparse_q4_proof(
    binding: G53SparseQ4Binding,
    threads: usize,
) -> Result<G53SparseQ4Proof, G53SparseQ4ProofError> {
    if !binding.is_registered() {
        return Err(G53SparseQ4ProofError::UnregisteredExtractor);
    }
    let defect_proof = synthesize_g53_defect_profile_proof(
        G53DefectBinding::registered(),
        G53DefectObservation {
            signed_energy: 1_976,
            defect_target: 34,
            profile_count: 10,
            provenance: ProvenanceClass::ObservedEvolved,
        },
    )?;
    let fibres = census_g53_q4_fibres()?;
    let oracle = verify_g53_sparse_q4_census(threads)?;
    if fibres.roots != ROOTS
        || fibres.roots_with_exact_q4 != 0
        || fibres.fibre_classes.len() != 4
        || fibres.special_mask_classes.len() != 10
        || oracle.roots != u32::from(ROOTS)
        || oracle.hits != 0
        || oracle.misses != u32::from(ROOTS)
    {
        return Err(G53SparseQ4ProofError::SemanticMismatch);
    }
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED,
        1 << FACT_Q4_EXCLUSION,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = G53SparseQ4Proof {
        binding,
        defect_proof,
        roots: ROOTS,
        active_shifts: ACTIVE_SHIFTS,
        special_mask_classes: fibres.special_mask_classes,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ExactComputational,
    };
    verify_g53_sparse_q4_proof(&proof, threads)?;
    Ok(proof)
}

pub fn verify_g53_sparse_q4_proof(
    proof: &G53SparseQ4Proof,
    threads: usize,
) -> Result<(), G53SparseQ4ProofError> {
    if !proof.binding.is_registered() {
        return Err(G53SparseQ4ProofError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ExactComputational {
        return Err(G53SparseQ4ProofError::UnauthorizedProvenance);
    }
    verify_g53_defect_profile_proof(&proof.defect_proof)?;
    let fibres = census_g53_q4_fibres()?;
    let oracle = verify_g53_sparse_q4_census(threads)?;
    if proof.roots != ROOTS
        || proof.active_shifts != ACTIVE_SHIFTS
        || proof.special_mask_classes != fibres.special_mask_classes
        || fibres.roots != ROOTS
        || fibres.roots_with_exact_q4 != 0
        || oracle.roots != u32::from(ROOTS)
        || oracle.hits != 0
        || oracle.misses != u32::from(ROOTS)
    {
        return Err(G53SparseQ4ProofError::SemanticMismatch);
    }
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_Q4_EXCLUSION,
        &RULES,
        &proof.transcript,
    )?;
    Ok(())
}

pub fn derive_g53_sparse_q4_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED,
        1 << FACT_Q4_EXCLUSION,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_g53_sparse_q4_rules(transcript: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_Q4_EXCLUSION,
        &RULES,
        transcript,
    )
}

fn descriptor() -> ExtractorDescriptor {
    let parameter_digest =
        Sha256::digest([522_u16.to_le_bytes(), 53_u16.to_le_bytes()].concat()).into();
    let source_commitment = Sha256::digest(SOURCE_SEMANTICS).into();
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        parameter_digest,
        source_commitment,
    )
}

pub(crate) fn evolve_rule_system() -> (&'static [RuleSpec], u64, u64) {
    (&RULES, 1 << FACT_REGISTERED, 1 << FACT_Q4_EXCLUSION)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn skeleton() -> G53SparseQ4Proof {
        G53SparseQ4Proof {
            binding: G53SparseQ4Binding::registered(),
            defect_proof: synthesize_g53_defect_profile_proof(
                G53DefectBinding::registered(),
                G53DefectObservation {
                    signed_energy: 1_976,
                    defect_target: 34,
                    profile_count: 10,
                    provenance: ProvenanceClass::ObservedEvolved,
                },
            )
            .unwrap(),
            roots: ROOTS,
            active_shifts: ACTIVE_SHIFTS,
            special_mask_classes: Box::new([]),
            transcript: Box::new([]),
            provenance: ProvenanceClass::ExactComputational,
        }
    }

    #[test]
    fn forged_binding_and_provenance_fail_before_replay() {
        let mut proof = skeleton();
        proof.binding.descriptor = ExtractorDescriptor::registered([0; 16], 1, [0; 32], [0; 32]);
        assert_eq!(
            verify_g53_sparse_q4_proof(&proof, 1),
            Err(G53SparseQ4ProofError::UnregisteredExtractor)
        );
        let mut proof = skeleton();
        proof.provenance = ProvenanceClass::ObservedEvolved;
        assert_eq!(
            verify_g53_sparse_q4_proof(&proof, 1),
            Err(G53SparseQ4ProofError::UnauthorizedProvenance)
        );
    }
}
