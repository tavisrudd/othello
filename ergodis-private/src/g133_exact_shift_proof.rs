//! Sealed parametric exact-shift proof for the private g133 order-2092 shard.
//!
//! The proof stores only bounded scalar metadata, a survivor commitment, and
//! a six-step structural transcript. Verification recompiles both independent
//! pair images and directly reconstructs every retained root; no pair table or
//! root list is accepted as authority.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g133_sparse_defect::{
    compile_g133_exact_shift_cell_corpus, G133ExactShiftCellCorpus, G133ExactShiftCellRow,
    G133SparseError, G133SparseExactShiftReport,
};
use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

const EXTRACTOR_ID: [u8; 16] = *b"c1016-g133-xs-01";
const EXTRACTOR_VERSION: u16 = 2;
const SOURCE_SEMANTICS: &[u8] = b"bordered GS order 2092; carrier 522; multiplier 133; canonical Z18 ten-slot projection; exact row/q0/q1/scalar-shift interior-gap join; independent pairwise and shifted-bitset sumset compilers; canonical interval/residue/hole identity; survival iff base sumset pairs differ from hole-covered pairs; direct survivor replay";
const REGISTERED_SHIFTS: [u8; 4] = [2, 3, 6, 9];

const FACT_REGISTERED: u8 = 0;
const FACT_CANONICAL_ORBITS: u8 = 1;
const FACT_EXACT_PRIMARY: u8 = 2;
const FACT_INDEPENDENT_ORACLE: u8 = 3;
const FACT_GAP_MECHANISM: u8 = 4;
const FACT_DIRECT_REPLAY: u8 = 5;
const FACT_NECESSARY_REDUCTION: u8 = 6;

const RULES: [RuleSpec; 6] = [
    RuleSpec::registered(0x6330, 1 << FACT_REGISTERED, FACT_CANONICAL_ORBITS),
    RuleSpec::registered(
        0x6331,
        (1 << FACT_REGISTERED) | (1 << FACT_CANONICAL_ORBITS),
        FACT_EXACT_PRIMARY,
    ),
    RuleSpec::registered(
        0x6332,
        (1 << FACT_REGISTERED) | (1 << FACT_CANONICAL_ORBITS),
        FACT_INDEPENDENT_ORACLE,
    ),
    RuleSpec::registered(
        0x6333,
        (1 << FACT_EXACT_PRIMARY) | (1 << FACT_INDEPENDENT_ORACLE),
        FACT_GAP_MECHANISM,
    ),
    RuleSpec::registered(
        0x6334,
        (1 << FACT_EXACT_PRIMARY) | (1 << FACT_GAP_MECHANISM),
        FACT_DIRECT_REPLAY,
    ),
    RuleSpec::registered(0x6335, 1 << FACT_DIRECT_REPLAY, FACT_NECESSARY_REDUCTION),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G133ExactShiftBinding {
    descriptor: ExtractorDescriptor,
    shift: u8,
}

impl G133ExactShiftBinding {
    pub fn registered(shift: u8) -> Result<Self, G133ExactShiftProofError> {
        if !REGISTERED_SHIFTS.contains(&shift) {
            return Err(G133ExactShiftProofError::UnsupportedShift);
        }
        Ok(Self {
            descriptor: descriptor(shift),
            shift,
        })
    }

    #[must_use]
    pub const fn shift(self) -> u8 {
        self.shift
    }

    fn is_registered(self) -> bool {
        REGISTERED_SHIFTS.contains(&self.shift) && self.descriptor == descriptor(self.shift)
    }
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G133ExactShiftProof {
    pub binding: G133ExactShiftBinding,
    pub q0_q1_roots: u64,
    pub survivors: u64,
    pub exclusions: u64,
    pub q0_q1_class_cells: u32,
    pub survivor_class_cells: u32,
    pub candidate_digest: [u8; 32],
    pub mechanism_rows: u32,
    pub mechanism_digest: [u8; 32],
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G133ExactShiftProofError {
    #[error("shift is not a registered canonical g133 scalar representative")]
    UnsupportedShift,
    #[error("g133 exact-shift extractor is not registered")]
    UnregisteredExtractor,
    #[error("proof provenance cannot authorize the exact-shift reduction")]
    UnauthorizedProvenance,
    #[error("exact-shift primary/oracle/replay semantics disagree")]
    SemanticMismatch,
    #[error(transparent)]
    Sparse(#[from] G133SparseError),
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

fn report_is_authoritative(report: &G133SparseExactShiftReport, shift: u8) -> bool {
    report.shift == shift
        && report.exact_shift_candidates < report.q0_q1_roots
        && report.exact_shift_reduction == report.q0_q1_roots - report.exact_shift_candidates
        && report.exact_shift_class_cells <= report.q0_q1_class_cells
        && report.independent_pair_oracle
}

fn mechanism_commitment(
    rows: &[G133ExactShiftCellRow],
) -> Result<(u32, [u8; 32]), G133ExactShiftProofError> {
    let count =
        u32::try_from(rows.len()).map_err(|_| G133ExactShiftProofError::SemanticMismatch)?;
    let mut hasher = Sha256::new();
    hasher.update(b"c1016-g133-gap-mechanism-v1");
    for row in rows {
        if row.weight == 0 || (row.base_sumset_pairs != row.hole_covered_pairs) != row.survives {
            return Err(G133ExactShiftProofError::SemanticMismatch);
        }
        hasher.update(row.id.to_le_bytes());
        hasher.update(row.weight.to_le_bytes());
        hasher.update(row.base_sumset_pairs.to_le_bytes());
        hasher.update(row.hole_covered_pairs.to_le_bytes());
        hasher.update([u8::from(row.survives)]);
    }
    Ok((count, hasher.finalize().into()))
}

pub fn synthesize_g133_exact_shift_proof(
    binding: G133ExactShiftBinding,
) -> Result<G133ExactShiftProof, G133ExactShiftProofError> {
    Ok(synthesize_g133_exact_shift_proof_with_corpus(binding)?.0)
}

pub(crate) fn synthesize_g133_exact_shift_proof_with_corpus(
    binding: G133ExactShiftBinding,
) -> Result<(G133ExactShiftProof, G133ExactShiftCellCorpus), G133ExactShiftProofError> {
    if !binding.is_registered() {
        return Err(G133ExactShiftProofError::UnregisteredExtractor);
    }
    let corpus = compile_g133_exact_shift_cell_corpus(usize::from(binding.shift))?;
    let report = &corpus.report;
    if !report_is_authoritative(&report, binding.shift) {
        return Err(G133ExactShiftProofError::SemanticMismatch);
    }
    let (mechanism_rows, mechanism_digest) = mechanism_commitment(&corpus.rows)?;
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = G133ExactShiftProof {
        binding,
        q0_q1_roots: report.q0_q1_roots,
        survivors: report.exact_shift_candidates,
        exclusions: report.exact_shift_reduction,
        q0_q1_class_cells: report.q0_q1_class_cells,
        survivor_class_cells: report.exact_shift_class_cells,
        candidate_digest: report.candidate_digest,
        mechanism_rows,
        mechanism_digest,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ExactComputational,
    };
    Ok((proof, corpus))
}

pub fn verify_g133_exact_shift_proof(
    proof: &G133ExactShiftProof,
) -> Result<(), G133ExactShiftProofError> {
    if !proof.binding.is_registered() {
        return Err(G133ExactShiftProofError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ExactComputational {
        return Err(G133ExactShiftProofError::UnauthorizedProvenance);
    }
    let corpus = compile_g133_exact_shift_cell_corpus(usize::from(proof.binding.shift))?;
    let report = &corpus.report;
    let (mechanism_rows, mechanism_digest) = mechanism_commitment(&corpus.rows)?;
    if !report_is_authoritative(&report, proof.binding.shift)
        || proof.q0_q1_roots != report.q0_q1_roots
        || proof.survivors != report.exact_shift_candidates
        || proof.exclusions != report.exact_shift_reduction
        || proof.q0_q1_class_cells != report.q0_q1_class_cells
        || proof.survivor_class_cells != report.exact_shift_class_cells
        || proof.candidate_digest != report.candidate_digest
        || proof.mechanism_rows != mechanism_rows
        || proof.mechanism_digest != mechanism_digest
    {
        return Err(G133ExactShiftProofError::SemanticMismatch);
    }
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        &proof.transcript,
    )?;
    Ok(())
}

pub fn derive_g133_exact_shift_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_g133_exact_shift_rules(
    transcript: &[RuleApplication],
) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        transcript,
    )
}

fn descriptor(shift: u8) -> ExtractorDescriptor {
    let mut parameter_hasher = Sha256::new();
    parameter_hasher.update(522_u16.to_le_bytes());
    parameter_hasher.update(133_u16.to_le_bytes());
    parameter_hasher.update([shift]);
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        parameter_hasher.finalize().into(),
        Sha256::digest(SOURCE_SEMANTICS).into(),
    )
}

pub(crate) fn evolve_rule_system() -> (&'static [RuleSpec], u64, u64) {
    (&RULES, 1 << FACT_REGISTERED, 1 << FACT_NECESSARY_REDUCTION)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn skeleton() -> G133ExactShiftProof {
        G133ExactShiftProof {
            binding: G133ExactShiftBinding::registered(6).unwrap(),
            q0_q1_roots: 1,
            survivors: 0,
            exclusions: 1,
            q0_q1_class_cells: 1,
            survivor_class_cells: 0,
            candidate_digest: [0; 32],
            mechanism_rows: 0,
            mechanism_digest: [0; 32],
            transcript: Box::new([]),
            provenance: ProvenanceClass::ExactComputational,
        }
    }

    #[test]
    fn noncanonical_shift_and_forged_semantics_fail_closed() {
        assert_eq!(
            G133ExactShiftBinding::registered(4),
            Err(G133ExactShiftProofError::UnsupportedShift)
        );
        let mut proof = skeleton();
        proof.binding.shift = 3;
        assert_eq!(
            verify_g133_exact_shift_proof(&proof),
            Err(G133ExactShiftProofError::UnregisteredExtractor)
        );
        let mut proof = skeleton();
        proof.provenance = ProvenanceClass::ObservedEvolved;
        assert_eq!(
            verify_g133_exact_shift_proof(&proof),
            Err(G133ExactShiftProofError::UnauthorizedProvenance)
        );
    }

    #[test]
    fn forged_gap_mechanism_row_fails_closed() {
        let row = G133ExactShiftCellRow {
            id: 0,
            weight: 1,
            survives: true,
            block_configurations: [0; 4],
            block_energy_values: [0; 4],
            block_q1_profiles: [0; 4],
            block_shift_profiles: [0; 4],
            left_pair_keys: 0,
            left_pair_values: 0,
            right_pair_keys: 0,
            right_pair_values: 0,
            left_pair_holes: 0,
            right_pair_holes: 0,
            left_interval_keys: 0,
            right_interval_keys: 0,
            left_maximum_holes: 0,
            right_maximum_holes: 0,
            left_residue_bits: 0,
            right_residue_bits: 0,
            base_sumset_pairs: 0,
            hole_covered_pairs: 0,
        };
        assert_eq!(
            mechanism_commitment(&[row]),
            Err(G133ExactShiftProofError::SemanticMismatch)
        );
    }

    #[test]
    fn exact_shift_rule_kernel_allocates_nothing() {
        let mut workspace = [RuleApplication::EMPTY; RULES.len()];
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                let (_, used) = derive_g133_exact_shift_rules_into(&mut workspace).unwrap();
                replay_g133_exact_shift_rules(&workspace[..used]).unwrap();
            }
        });
        assert_eq!(allocations, 0);
    }
}
