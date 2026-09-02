//! Sealed exact-q2 interior-gap proof for the private g133 order-2092 shard.
//!
//! The proof stores only canonical counts and a survivor-set commitment.
//! Verification rebuilds the bounded exact pair images with two independent
//! kernels and directly reconstructs every retained root.  No pair table or
//! large negative certificate is trusted or serialized.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g133_sparse_defect::{
    scout_g133_sparse_exact_q2, G133SparseError, G133SparseExactQ2Report,
};
use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

const EXTRACTOR_ID: [u8; 16] = *b"c1016-g133-q2-01";
const EXTRACTOR_VERSION: u16 = 1;
const SOURCE_SEMANTICS: &[u8] = b"bordered GS order 2092; carrier 522; multiplier 133; canonical Z18 ten-slot projection; exact row/q0/q1/q2 interior-gap join; independent pairwise and shifted-bitset sumset compilers; direct survivor replay";
const Q0_Q1_ROOTS: u64 = 15_724_800;
const Q2_SURVIVORS: u64 = 15_372_288;
const Q2_EXCLUSIONS: u64 = 352_512;
const Q0_Q1_CLASS_CELLS: u32 = 8_431;
const Q2_CLASS_CELLS: u32 = 1_756;

const FACT_REGISTERED: u8 = 0;
const FACT_CANONICAL_ORBITS: u8 = 1;
const FACT_EXACT_PRIMARY: u8 = 2;
const FACT_INDEPENDENT_ORACLE: u8 = 3;
const FACT_DIRECT_REPLAY: u8 = 4;
const FACT_Q2_REDUCTION: u8 = 5;

const RULES: [RuleSpec; 5] = [
    RuleSpec::registered(0x63_20, 1 << FACT_REGISTERED, FACT_CANONICAL_ORBITS),
    RuleSpec::registered(
        0x63_21,
        (1 << FACT_REGISTERED) | (1 << FACT_CANONICAL_ORBITS),
        FACT_EXACT_PRIMARY,
    ),
    RuleSpec::registered(
        0x63_22,
        (1 << FACT_REGISTERED) | (1 << FACT_CANONICAL_ORBITS),
        FACT_INDEPENDENT_ORACLE,
    ),
    RuleSpec::registered(
        0x63_23,
        (1 << FACT_EXACT_PRIMARY) | (1 << FACT_INDEPENDENT_ORACLE),
        FACT_DIRECT_REPLAY,
    ),
    RuleSpec::registered(0x63_24, 1 << FACT_DIRECT_REPLAY, FACT_Q2_REDUCTION),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G133ExactQ2Binding {
    descriptor: ExtractorDescriptor,
}

impl G133ExactQ2Binding {
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
pub struct G133ExactQ2Proof {
    pub binding: G133ExactQ2Binding,
    pub q0_q1_roots: u64,
    pub q2_survivors: u64,
    pub q2_exclusions: u64,
    pub q0_q1_class_cells: u32,
    pub q2_class_cells: u32,
    pub candidate_digest: [u8; 32],
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G133ExactQ2ProofError {
    #[error("g133 exact-q2 extractor is not registered")]
    UnregisteredExtractor,
    #[error("proof provenance cannot authorize the exact q2 reduction")]
    UnauthorizedProvenance,
    #[error("exact q2 primary/oracle/replay semantics disagree")]
    SemanticMismatch,
    #[error(transparent)]
    Sparse(#[from] G133SparseError),
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

fn report_is_canonical(report: &G133SparseExactQ2Report) -> bool {
    report.q0_q1_roots == Q0_Q1_ROOTS
        && report.exact_q2_candidates == Q2_SURVIVORS
        && report.exact_q2_reduction == Q2_EXCLUSIONS
        && report.q0_q1_class_cells == Q0_Q1_CLASS_CELLS
        && report.exact_q2_class_cells == Q2_CLASS_CELLS
        && report.independent_pair_oracle
}

pub fn synthesize_g133_exact_q2_proof(
    binding: G133ExactQ2Binding,
) -> Result<G133ExactQ2Proof, G133ExactQ2ProofError> {
    if !binding.is_registered() {
        return Err(G133ExactQ2ProofError::UnregisteredExtractor);
    }
    let report = scout_g133_sparse_exact_q2()?;
    if !report_is_canonical(&report) {
        return Err(G133ExactQ2ProofError::SemanticMismatch);
    }
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED,
        1 << FACT_Q2_REDUCTION,
        &RULES,
        RULES.len() as u32,
    )?;
    Ok(G133ExactQ2Proof {
        binding,
        q0_q1_roots: report.q0_q1_roots,
        q2_survivors: report.exact_q2_candidates,
        q2_exclusions: report.exact_q2_reduction,
        q0_q1_class_cells: report.q0_q1_class_cells,
        q2_class_cells: report.exact_q2_class_cells,
        candidate_digest: report.candidate_digest,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ExactComputational,
    })
}

pub fn verify_g133_exact_q2_proof(proof: &G133ExactQ2Proof) -> Result<(), G133ExactQ2ProofError> {
    if !proof.binding.is_registered() {
        return Err(G133ExactQ2ProofError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ExactComputational {
        return Err(G133ExactQ2ProofError::UnauthorizedProvenance);
    }
    let report = scout_g133_sparse_exact_q2()?;
    if !report_is_canonical(&report)
        || proof.q0_q1_roots != report.q0_q1_roots
        || proof.q2_survivors != report.exact_q2_candidates
        || proof.q2_exclusions != report.exact_q2_reduction
        || proof.q0_q1_class_cells != report.q0_q1_class_cells
        || proof.q2_class_cells != report.exact_q2_class_cells
        || proof.candidate_digest != report.candidate_digest
    {
        return Err(G133ExactQ2ProofError::SemanticMismatch);
    }
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_Q2_REDUCTION,
        &RULES,
        &proof.transcript,
    )?;
    Ok(())
}

pub fn derive_g133_exact_q2_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED,
        1 << FACT_Q2_REDUCTION,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_g133_exact_q2_rules(transcript: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_Q2_REDUCTION,
        &RULES,
        transcript,
    )
}

fn descriptor() -> ExtractorDescriptor {
    let parameter_digest =
        Sha256::digest([522_u16.to_le_bytes(), 133_u16.to_le_bytes()].concat()).into();
    let source_commitment = Sha256::digest(SOURCE_SEMANTICS).into();
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        parameter_digest,
        source_commitment,
    )
}

pub(crate) fn evolve_rule_system() -> (&'static [RuleSpec], u64, u64) {
    (&RULES, 1 << FACT_REGISTERED, 1 << FACT_Q2_REDUCTION)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn skeleton() -> G133ExactQ2Proof {
        G133ExactQ2Proof {
            binding: G133ExactQ2Binding::registered(),
            q0_q1_roots: Q0_Q1_ROOTS,
            q2_survivors: Q2_SURVIVORS,
            q2_exclusions: Q2_EXCLUSIONS,
            q0_q1_class_cells: Q0_Q1_CLASS_CELLS,
            q2_class_cells: Q2_CLASS_CELLS,
            candidate_digest: [0; 32],
            transcript: Box::new([]),
            provenance: ProvenanceClass::ExactComputational,
        }
    }

    #[test]
    fn forged_binding_and_provenance_fail_before_expensive_replay() {
        let mut proof = skeleton();
        proof.binding.descriptor = ExtractorDescriptor::registered([0; 16], 1, [0; 32], [0; 32]);
        assert_eq!(
            verify_g133_exact_q2_proof(&proof),
            Err(G133ExactQ2ProofError::UnregisteredExtractor)
        );
        let mut proof = skeleton();
        proof.provenance = ProvenanceClass::ObservedEvolved;
        assert_eq!(
            verify_g133_exact_q2_proof(&proof),
            Err(G133ExactQ2ProofError::UnauthorizedProvenance)
        );
    }

    #[test]
    fn rule_derive_and_replay_allocate_nothing() {
        let mut workspace = [RuleApplication::EMPTY; 8];
        let (_, used) = derive_g133_exact_q2_rules_into(&mut workspace).unwrap();
        let transcript = workspace[..used].to_vec();
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..1_024 {
                let (_, used) = derive_g133_exact_q2_rules_into(&mut workspace).unwrap();
                std::hint::black_box(replay_g133_exact_q2_rules(&transcript[..used]).unwrap());
            }
        });
        assert_eq!(allocations, 0);
    }
}
