//! Sealed private proof for the g41 quotient-root filter.
//!
//! This proof authorizes only the exclusion of roots outside the 768-element
//! necessary-filter intersection.  It does not claim that any retained root
//! has one common lift satisfying every quotient equation.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_defect_scout::{
    census_g41_quotient_filter, oracle_g41_domains, oracle_g41_shift_domains, G41DefectScoutError,
};
use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};
use crate::quotient_paf_proof::{
    synthesize_quotient_paf_proof, verify_quotient_paf_proof, QuotientPafBinding, QuotientPafError,
    QuotientPafInstance, QuotientPafProof,
};

const EXTRACTOR_ID: [u8; 16] = *b"c1016-g41-qf-002";
const EXTRACTOR_VERSION: u16 = 2;
const SOURCE_SEMANTICS: &[u8] = b"bordered GS order 2092; carrier 522; multiplier 41; canonical Z18 six-slot projection; independently exact necessary-filter intersection at q2,q3,q6,q9; q0/q1 are constructive-hit censuses only; survivors have no joint-witness authority";
const REPRESENTATIVE_SHIFTS: [u8; 4] = [2, 3, 6, 9];
const INDIVIDUAL_HITS: [u64; 4] = [1_536, 2_304, 2_304, 4_608];
const SURVIVORS: u64 = 768;
const RAW_ASSIGNMENTS: u64 = 207_360_000;
const SHIFT_PROFILE_COUNTS: [u64; 4] = [93_303, 157_699, 107_715, 146_739];

const FACT_REGISTERED: u8 = 0;
const FACT_QUOTIENT_THEOREM: u8 = 1;
const FACT_ORBIT_REDUCTION: u8 = 2;
const FACT_INDEPENDENT_DOMAINS: u8 = 3;
const FACT_EXACT_FILTERS: u8 = 4;
const FACT_INTERSECTION: u8 = 5;
const FACT_G41_REDUCED: u8 = 6;

const RULES: [RuleSpec; 6] = [
    RuleSpec::registered(0x41_00, 1 << FACT_REGISTERED, FACT_QUOTIENT_THEOREM),
    RuleSpec::registered(0x41_01, 1 << FACT_REGISTERED, FACT_ORBIT_REDUCTION),
    RuleSpec::registered(
        0x41_02,
        (1 << FACT_QUOTIENT_THEOREM) | (1 << FACT_ORBIT_REDUCTION),
        FACT_INDEPENDENT_DOMAINS,
    ),
    RuleSpec::registered(0x41_03, 1 << FACT_INDEPENDENT_DOMAINS, FACT_EXACT_FILTERS),
    RuleSpec::registered(0x41_04, 1 << FACT_EXACT_FILTERS, FACT_INTERSECTION),
    RuleSpec::registered(0x41_05, 1 << FACT_INTERSECTION, FACT_G41_REDUCED),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G41QuotientFilterBinding {
    descriptor: ExtractorDescriptor,
}

impl G41QuotientFilterBinding {
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
pub struct G41QuotientFilterObservation {
    pub individual_shift_hits: [u64; 4],
    pub necessary_filter_survivors: u64,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G41QuotientFilterProof {
    pub binding: G41QuotientFilterBinding,
    pub quotient_proof: QuotientPafProof,
    pub representative_shifts: [u8; 4],
    pub individual_shift_hits: [u64; 4],
    pub necessary_filter_survivors: u64,
    pub root_set_digest: [u8; 32],
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41QuotientFilterProofError {
    #[error("g41 quotient-filter extractor is not registered")]
    UnregisteredExtractor,
    #[error("evolved g41 observation disagrees with canonical semantics")]
    SemanticMismatch,
    #[error("proof provenance cannot authorize the g41 quotient filter")]
    UnauthorizedProvenance,
    #[error(transparent)]
    Scout(#[from] G41DefectScoutError),
    #[error(transparent)]
    Quotient(#[from] QuotientPafError),
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_g41_quotient_filter_proof(
    binding: G41QuotientFilterBinding,
    observation: G41QuotientFilterObservation,
) -> Result<G41QuotientFilterProof, G41QuotientFilterProofError> {
    if !binding.is_registered() {
        return Err(G41QuotientFilterProofError::UnregisteredExtractor);
    }
    if observation
        != (G41QuotientFilterObservation {
            individual_shift_hits: INDIVIDUAL_HITS,
            necessary_filter_survivors: SURVIVORS,
            provenance: ProvenanceClass::ObservedEvolved,
        })
    {
        return Err(G41QuotientFilterProofError::SemanticMismatch);
    }
    let quotient_proof = canonical_quotient_proof()?;
    verify_scalar_semantics(&quotient_proof)?;
    let root_set_digest = replay_filter_and_oracles()?;
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED,
        1 << FACT_G41_REDUCED,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = G41QuotientFilterProof {
        binding,
        quotient_proof,
        representative_shifts: REPRESENTATIVE_SHIFTS,
        individual_shift_hits: INDIVIDUAL_HITS,
        necessary_filter_survivors: SURVIVORS,
        root_set_digest,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ExactComputational,
    };
    verify_g41_quotient_filter_proof(&proof)?;
    Ok(proof)
}

pub fn verify_g41_quotient_filter_proof(
    proof: &G41QuotientFilterProof,
) -> Result<(), G41QuotientFilterProofError> {
    if !proof.binding.is_registered() {
        return Err(G41QuotientFilterProofError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ExactComputational {
        return Err(G41QuotientFilterProofError::UnauthorizedProvenance);
    }
    verify_quotient_paf_proof(&proof.quotient_proof)?;
    verify_scalar_semantics(&proof.quotient_proof)?;
    let digest = replay_filter_and_oracles()?;
    if proof.quotient_proof != canonical_quotient_proof()?
        || proof.representative_shifts != REPRESENTATIVE_SHIFTS
        || proof.individual_shift_hits != INDIVIDUAL_HITS
        || proof.necessary_filter_survivors != SURVIVORS
        || proof.root_set_digest != digest
    {
        return Err(G41QuotientFilterProofError::SemanticMismatch);
    }
    replay_g41_quotient_filter_rules(&proof.transcript)?;
    Ok(())
}

fn replay_filter_and_oracles() -> Result<[u8; 32], G41QuotientFilterProofError> {
    let base = oracle_g41_domains()?;
    if base.raw_assignments_checked != RAW_ASSIGNMENTS
        || base.mod2_roots != 262_144
        || base.constructive_q0_hits != 9_216
        || base.constructive_q1_hits != 4_608
    {
        return Err(G41QuotientFilterProofError::SemanticMismatch);
    }
    for (index, shift) in [2_usize, 3, 6, 9].into_iter().enumerate() {
        let oracle = oracle_g41_shift_domains(shift)?;
        if oracle.raw_assignments_checked != RAW_ASSIGNMENTS
            || oracle.retained_profiles != SHIFT_PROFILE_COUNTS[index]
        {
            return Err(G41QuotientFilterProofError::SemanticMismatch);
        }
    }
    let filter = census_g41_quotient_filter()?;
    if filter.representative_shifts != [0, 1, 2, 3, 6, 9]
        || filter.individual_shift_hits != INDIVIDUAL_HITS
        || filter.necessary_filter_survivors != SURVIVORS
    {
        return Err(G41QuotientFilterProofError::SemanticMismatch);
    }
    let mut digest = Sha256::new();
    digest.update(b"ergodis-private-c1016-g41-quotient-root-set-v1");
    for root in filter.surviving_root_ids.iter() {
        digest.update(root.to_le_bytes());
    }
    Ok(digest.finalize().into())
}

fn canonical_quotient_proof() -> Result<QuotientPafProof, G41QuotientFilterProofError> {
    Ok(synthesize_quotient_paf_proof(
        QuotientPafBinding::registered(QuotientPafInstance {
            carrier: 522,
            quotient_order: 18,
            block_count: 4,
            row_weight_total: 1_043,
            uniform_nonzero_intersection: 520,
        })?,
    )?)
}

fn verify_scalar_semantics(proof: &QuotientPafProof) -> Result<(), G41QuotientFilterProofError> {
    let signed_energy = 4_i64 * 18 * 29 * 29 - 4 * 29 * 1_043
        + 4 * i64::try_from(proof.zero_shift_target)
            .map_err(|_| G41QuotientFilterProofError::SemanticMismatch)?;
    if signed_energy != 1_976 || (signed_energy - 136) / 8 != 230 {
        return Err(G41QuotientFilterProofError::SemanticMismatch);
    }
    Ok(())
}

pub fn derive_g41_quotient_filter_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED,
        1 << FACT_G41_REDUCED,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_g41_quotient_filter_rules(
    transcript: &[RuleApplication],
) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_G41_REDUCED,
        &RULES,
        transcript,
    )
}

fn descriptor() -> ExtractorDescriptor {
    let mut parameters = Sha256::new();
    parameters.update(522_u16.to_le_bytes());
    parameters.update(41_u16.to_le_bytes());
    parameters.update(18_u16.to_le_bytes());
    parameters.update(REPRESENTATIVE_SHIFTS);
    let parameter_digest = parameters.finalize().into();
    let source_commitment = Sha256::digest(SOURCE_SEMANTICS).into();
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        parameter_digest,
        source_commitment,
    )
}

pub(crate) fn evolve_rule_system() -> (&'static [RuleSpec], u64, u64) {
    (&RULES, 1 << FACT_REGISTERED, 1 << FACT_G41_REDUCED)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn observation() -> G41QuotientFilterObservation {
        G41QuotientFilterObservation {
            individual_shift_hits: INDIVIDUAL_HITS,
            necessary_filter_survivors: SURVIVORS,
            provenance: ProvenanceClass::ObservedEvolved,
        }
    }

    #[test]
    fn forged_observations_and_provenance_fail_closed() {
        let forged_binding = G41QuotientFilterBinding {
            descriptor: ExtractorDescriptor::registered(
                *b"c1016-g41-qf-999",
                EXTRACTOR_VERSION,
                [0; 32],
                [0; 32],
            ),
        };
        assert_eq!(
            synthesize_g41_quotient_filter_proof(forged_binding, observation()).unwrap_err(),
            G41QuotientFilterProofError::UnregisteredExtractor
        );
        let mut wrong = observation();
        wrong.necessary_filter_survivors += 1;
        assert_eq!(
            synthesize_g41_quotient_filter_proof(G41QuotientFilterBinding::registered(), wrong)
                .unwrap_err(),
            G41QuotientFilterProofError::SemanticMismatch
        );
        let mut wrong_provenance = observation();
        wrong_provenance.provenance = ProvenanceClass::ProvedStructural;
        assert_eq!(
            synthesize_g41_quotient_filter_proof(
                G41QuotientFilterBinding::registered(),
                wrong_provenance
            )
            .unwrap_err(),
            G41QuotientFilterProofError::SemanticMismatch
        );
    }
}
