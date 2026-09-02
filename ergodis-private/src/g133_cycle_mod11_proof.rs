//! Sealed evolve-to-proof adapter for the g133 three-cycle obstruction.
//!
//! Evolution supplies only a candidate affine residue.  The registered
//! extractor independently regenerates the canonical q6 survivor corpus,
//! derives its structural three-cycle interfaces, and requires agreement
//! between hash-table and ordered-vector joins before issuing negative
//! coverage.  No presentation field or stored root certificate is trusted.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g133_exact_shift_proof::{
    synthesize_g133_exact_shift_proof_with_corpus, G133ExactShiftBinding, G133ExactShiftProof,
    G133ExactShiftProofError,
};
use crate::g133_sparse_defect::{
    map_g133_cycle_mod11_refined_cells, oracle_g133_cycle_mod11_cells,
    scout_g133_cycle_mod11_cells, G133CellRootRepresentative, G133CycleMod11OracleReport,
    G133CycleMod11RefinedCellReport, G133CycleMod11Report, G133SparseError,
};
use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

const EXTRACTOR_ID: [u8; 16] = *b"c1016-g133-c11-1";
const EXTRACTOR_VERSION: u16 = 1;
const SOURCE_SEMANTICS: &[u8] = b"bordered GS order 2092; carrier 522; multiplier 133; canonical Z18 ten-slot projection; exact q6 survivor cells; C_r=sum_{j congruent r mod 3}x_j; sum_r C_r^2=P0+2P3+2P6+P9; evolved affine feature -2P3-P9=P0+2P6-sum_r C_r^2 mod 11; total target 3; primary open-address join; independent ordered-vector join";
const SHIFT: u8 = 6;
const MODULUS: u8 = 11;
const Q3_COEFFICIENT: i8 = -2;
const Q9_COEFFICIENT: i8 = -1;
const TARGET_RESIDUE: u8 = 3;

const FACT_REGISTERED: u8 = 0;
const FACT_EVOLVED_FEATURE_REEXTRACTED: u8 = 1;
const FACT_THREE_CYCLE_IDENTITY: u8 = 2;
const FACT_CANONICAL_Q6_COVERAGE: u8 = 3;
const FACT_PRIMARY_EXCLUSION: u8 = 4;
const FACT_INDEPENDENT_REPLAY: u8 = 5;
const FACT_NECESSARY_EXCLUSION: u8 = 6;

const RULES: [RuleSpec; 6] = [
    RuleSpec::registered(
        0x63_b0,
        1 << FACT_REGISTERED,
        FACT_EVOLVED_FEATURE_REEXTRACTED,
    ),
    RuleSpec::registered(
        0x63_b1,
        1 << FACT_EVOLVED_FEATURE_REEXTRACTED,
        FACT_THREE_CYCLE_IDENTITY,
    ),
    RuleSpec::registered(
        0x63_b2,
        (1 << FACT_REGISTERED) | (1 << FACT_THREE_CYCLE_IDENTITY),
        FACT_CANONICAL_Q6_COVERAGE,
    ),
    RuleSpec::registered(
        0x63_b3,
        1 << FACT_CANONICAL_Q6_COVERAGE,
        FACT_PRIMARY_EXCLUSION,
    ),
    RuleSpec::registered(
        0x63_b4,
        1 << FACT_CANONICAL_Q6_COVERAGE,
        FACT_INDEPENDENT_REPLAY,
    ),
    RuleSpec::registered(
        0x63_b5,
        (1 << FACT_PRIMARY_EXCLUSION) | (1 << FACT_INDEPENDENT_REPLAY),
        FACT_NECESSARY_EXCLUSION,
    ),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G133CycleMod11Binding {
    descriptor: ExtractorDescriptor,
}

impl G133CycleMod11Binding {
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
pub struct G133CycleMod11Observation {
    pub modulus: u8,
    pub q3_coefficient: i8,
    pub q9_coefficient: i8,
    pub target_residue: u8,
    pub provenance: ProvenanceClass,
}

impl G133CycleMod11Observation {
    #[must_use]
    pub const fn evolved_candidate() -> Self {
        Self {
            modulus: MODULUS,
            q3_coefficient: Q3_COEFFICIENT,
            q9_coefficient: Q9_COEFFICIENT,
            target_residue: TARGET_RESIDUE,
            provenance: ProvenanceClass::ObservedEvolved,
        }
    }
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G133CycleMod11Proof {
    pub binding: G133CycleMod11Binding,
    pub q6_proof: G133ExactShiftProof,
    pub modulus: u8,
    pub q3_coefficient: i8,
    pub q9_coefficient: i8,
    pub target_residue: u8,
    pub q6_cells: u32,
    pub structural_cells: u32,
    pub covered_roots: u64,
    pub unique_typed_masks: u16,
    pub maximum_pair_keys: u32,
    pub primary_workspace_bytes: u64,
    pub oracle_workspace_bytes: u64,
    pub coverage_digest: [u8; 32],
    pub transcript: Box<[RuleApplication]>,
    pub identity_provenance: ProvenanceClass,
    pub coverage_provenance: ProvenanceClass,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G133CycleMod11ProofError {
    #[error("g133 cycle-mod11 extractor is not registered")]
    UnregisteredExtractor,
    #[error("evolved observation disagrees with canonical cycle semantics")]
    SemanticMismatch,
    #[error("canonical q6 survivor-cell coverage is inconsistent")]
    Q6CoverageMismatch,
    #[error("structural cycle refinement does not exactly cover the q6 survivors")]
    RefinementMismatch,
    #[error("primary and independent cycle joins disagree in their summaries")]
    ReplaySummaryMismatch,
    #[error("primary and independent cycle joins disagree on a cell")]
    ReplayCellMismatch,
    #[error("stored compact proof does not match independently regenerated semantics")]
    ProofMismatch,
    #[error("stored q6 prerequisite differs from its canonical regeneration")]
    Q6ProofMismatch,
    #[error("stored replay workspace metadata differs from canonical regeneration")]
    WorkspaceMismatch,
    #[error("stored coverage commitment differs from canonical regeneration")]
    CoverageDigestMismatch,
    #[error("proof provenance cannot authorize negative coverage")]
    UnauthorizedProvenance,
    #[error(transparent)]
    ExactShift(#[from] G133ExactShiftProofError),
    #[error(transparent)]
    Sparse(#[from] G133SparseError),
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

struct CanonicalReplay {
    q6_proof: G133ExactShiftProof,
    refined: G133CycleMod11RefinedCellReport,
    primary: G133CycleMod11Report,
    oracle: G133CycleMod11OracleReport,
    coverage_digest: [u8; 32],
}

fn canonical_replay() -> Result<CanonicalReplay, G133CycleMod11ProofError> {
    let (q6_proof, corpus) =
        synthesize_g133_exact_shift_proof_with_corpus(G133ExactShiftBinding::registered(SHIFT)?)?;
    let mut cell_ids = Vec::new();
    cell_ids
        .try_reserve_exact(corpus.report.exact_shift_class_cells as usize)
        .map_err(|_| G133CycleMod11ProofError::Q6CoverageMismatch)?;
    let mut survivor_weight = 0_u64;
    for row in &corpus.rows {
        if row.survives {
            cell_ids.push(row.id);
            survivor_weight = survivor_weight
                .checked_add(row.weight)
                .ok_or(G133CycleMod11ProofError::Q6CoverageMismatch)?;
        }
    }
    if survivor_weight != q6_proof.survivors
        || cell_ids.is_empty()
        || cell_ids.windows(2).any(|pair| pair[0] >= pair[1])
    {
        return Err(G133CycleMod11ProofError::Q6CoverageMismatch);
    }
    let refined = map_g133_cycle_mod11_refined_cells(&cell_ids)?;
    let covered_roots = refined.rows.iter().try_fold(0_u64, |total, row| {
        total
            .checked_add(row.mod4_roots)
            .ok_or(G133CycleMod11ProofError::RefinementMismatch)
    })?;
    if refined.supplied_q6_cells != cell_ids.len() as u32
        || refined.matched_mod4_roots != q6_proof.survivors
        || covered_roots != q6_proof.survivors
        || refined.split_q6_classes != 0
        || refined.maximum_cycle_classes_per_q6_class != 1
    {
        return Err(G133CycleMod11ProofError::RefinementMismatch);
    }
    let mut representatives = Vec::new();
    representatives
        .try_reserve_exact(refined.rows.len())
        .map_err(|_| G133CycleMod11ProofError::RefinementMismatch)?;
    for row in &refined.rows {
        representatives.push(G133CellRootRepresentative {
            masks: row.masks,
            cell_id: row.cycle_cell_id,
            reserved: 0,
        });
    }
    let primary = scout_g133_cycle_mod11_cells(&representatives)?;
    let oracle = oracle_g133_cycle_mod11_cells(&representatives)?;
    if primary.cells != refined.refined_cycle_cells
        || oracle.cells != refined.refined_cycle_cells
        || primary.excluded_cells != primary.cells
        || oracle.excluded_cells != oracle.cells
        || primary.compatible_cells != 0
        || oracle.compatible_cells != 0
        || primary.unique_typed_masks != oracle.unique_typed_masks
        || primary.total_configurations != oracle.total_configurations
        || primary.maximum_pair_keys != oracle.maximum_pair_keys
        || primary.rows.len() != oracle.rows.len()
    {
        return Err(G133CycleMod11ProofError::ReplaySummaryMismatch);
    }
    let mut hasher = Sha256::new();
    hasher.update(b"c1016-g133-cycle-mod11-coverage-v1");
    hasher.update(q6_proof.candidate_digest);
    hasher.update(covered_roots.to_le_bytes());
    for ((cell, primary_row), oracle_row) in
        refined.rows.iter().zip(&primary.rows).zip(&oracle.rows)
    {
        if cell.cycle_cell_id != primary_row.cell_id
            || cell.cycle_cell_id != oracle_row.cell_id
            || cell.masks != primary_row.masks
            || cell.masks != oracle_row.masks
            || primary_row.pairing != oracle_row.pairing
            || primary_row.right_pair_keys != oracle_row.right_pair_keys
            || primary_row.mod11_compatible != oracle_row.mod11_compatible
        {
            return Err(G133CycleMod11ProofError::ReplayCellMismatch);
        }
        hasher.update(cell.q6_cell_id.to_le_bytes());
        hasher.update(cell.cycle_cell_id.to_le_bytes());
        for mask in cell.masks {
            hasher.update(mask.to_le_bytes());
        }
        for class in cell.cycle_classes {
            hasher.update(class.to_le_bytes());
        }
        hasher.update(cell.mod4_roots.to_le_bytes());
        hasher.update(primary_row.right_pair_keys.to_le_bytes());
        hasher.update([u8::from(primary_row.mod11_compatible)]);
    }
    Ok(CanonicalReplay {
        q6_proof,
        refined,
        primary,
        oracle,
        coverage_digest: hasher.finalize().into(),
    })
}

pub fn synthesize_g133_cycle_mod11_proof(
    binding: G133CycleMod11Binding,
    observation: G133CycleMod11Observation,
) -> Result<G133CycleMod11Proof, G133CycleMod11ProofError> {
    if !binding.is_registered() {
        return Err(G133CycleMod11ProofError::UnregisteredExtractor);
    }
    if observation != G133CycleMod11Observation::evolved_candidate() {
        return Err(G133CycleMod11ProofError::SemanticMismatch);
    }
    let replay = canonical_replay()?;
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED,
        1 << FACT_NECESSARY_EXCLUSION,
        &RULES,
        RULES.len() as u32,
    )?;
    Ok(G133CycleMod11Proof {
        binding,
        q6_proof: replay.q6_proof,
        modulus: MODULUS,
        q3_coefficient: Q3_COEFFICIENT,
        q9_coefficient: Q9_COEFFICIENT,
        target_residue: TARGET_RESIDUE,
        q6_cells: replay.refined.supplied_q6_cells,
        structural_cells: replay.refined.refined_cycle_cells,
        covered_roots: replay.refined.matched_mod4_roots,
        unique_typed_masks: replay.primary.unique_typed_masks,
        maximum_pair_keys: replay.primary.maximum_pair_keys,
        primary_workspace_bytes: replay.primary.workspace_bytes,
        oracle_workspace_bytes: replay.oracle.workspace_bytes,
        coverage_digest: replay.coverage_digest,
        transcript: derivation.applications,
        identity_provenance: ProvenanceClass::ProvedStructural,
        coverage_provenance: ProvenanceClass::ExactComputational,
        provenance: ProvenanceClass::ExactComputational,
    })
}

pub fn verify_g133_cycle_mod11_proof(
    proof: &G133CycleMod11Proof,
) -> Result<(), G133CycleMod11ProofError> {
    if !proof.binding.is_registered() {
        return Err(G133CycleMod11ProofError::UnregisteredExtractor);
    }
    if proof.identity_provenance != ProvenanceClass::ProvedStructural
        || proof.coverage_provenance != ProvenanceClass::ExactComputational
        || proof.provenance != ProvenanceClass::ExactComputational
        || !proof.provenance.permits_negative_coverage()
    {
        return Err(G133CycleMod11ProofError::UnauthorizedProvenance);
    }
    let replay = canonical_replay()?;
    if proof.q6_proof != replay.q6_proof {
        return Err(G133CycleMod11ProofError::Q6ProofMismatch);
    }
    if proof.modulus != MODULUS
        || proof.q3_coefficient != Q3_COEFFICIENT
        || proof.q9_coefficient != Q9_COEFFICIENT
        || proof.target_residue != TARGET_RESIDUE
        || proof.q6_cells != replay.refined.supplied_q6_cells
        || proof.structural_cells != replay.refined.refined_cycle_cells
        || proof.covered_roots != replay.refined.matched_mod4_roots
        || proof.unique_typed_masks != replay.primary.unique_typed_masks
        || proof.maximum_pair_keys != replay.primary.maximum_pair_keys
    {
        return Err(G133CycleMod11ProofError::ProofMismatch);
    }
    if proof.primary_workspace_bytes != replay.primary.workspace_bytes
        || proof.oracle_workspace_bytes != replay.oracle.workspace_bytes
    {
        return Err(G133CycleMod11ProofError::WorkspaceMismatch);
    }
    if proof.coverage_digest != replay.coverage_digest {
        return Err(G133CycleMod11ProofError::CoverageDigestMismatch);
    }
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_NECESSARY_EXCLUSION,
        &RULES,
        &proof.transcript,
    )?;
    Ok(())
}

pub fn derive_g133_cycle_mod11_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED,
        1 << FACT_NECESSARY_EXCLUSION,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_g133_cycle_mod11_rules(
    transcript: &[RuleApplication],
) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED,
        1 << FACT_NECESSARY_EXCLUSION,
        &RULES,
        transcript,
    )
}

fn descriptor() -> ExtractorDescriptor {
    let mut parameter_hasher = Sha256::new();
    parameter_hasher.update(2_092_u16.to_le_bytes());
    parameter_hasher.update(522_u16.to_le_bytes());
    parameter_hasher.update(133_u16.to_le_bytes());
    parameter_hasher.update([18_u8, SHIFT, MODULUS]);
    parameter_hasher.update(Q3_COEFFICIENT.to_le_bytes());
    parameter_hasher.update(Q9_COEFFICIENT.to_le_bytes());
    parameter_hasher.update([TARGET_RESIDUE]);
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        parameter_hasher.finalize().into(),
        Sha256::digest(SOURCE_SEMANTICS).into(),
    )
}

pub(crate) fn evolve_rule_system() -> (&'static [RuleSpec], u64, u64) {
    (&RULES, 1 << FACT_REGISTERED, 1 << FACT_NECESSARY_EXCLUSION)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn forged_evolved_semantics_fail_closed_before_replay() {
        let mut observation = G133CycleMod11Observation::evolved_candidate();
        observation.q9_coefficient = 1;
        assert_eq!(
            synthesize_g133_cycle_mod11_proof(G133CycleMod11Binding::registered(), observation),
            Err(G133CycleMod11ProofError::SemanticMismatch)
        );
        let mut observation = G133CycleMod11Observation::evolved_candidate();
        observation.provenance = ProvenanceClass::HeuristicSearch;
        assert_eq!(
            synthesize_g133_cycle_mod11_proof(G133CycleMod11Binding::registered(), observation),
            Err(G133CycleMod11ProofError::SemanticMismatch)
        );
    }

    #[test]
    fn forged_binding_fails_closed_before_replay() {
        let mut value = serde_json::to_value(G133CycleMod11Binding::registered()).unwrap();
        value["descriptor"]["version"] = serde_json::json!(999);
        let binding: G133CycleMod11Binding = serde_json::from_value(value).unwrap();
        assert_eq!(
            synthesize_g133_cycle_mod11_proof(
                binding,
                G133CycleMod11Observation::evolved_candidate(),
            ),
            Err(G133CycleMod11ProofError::UnregisteredExtractor)
        );
    }

    #[test]
    fn cycle_mod11_rule_kernel_allocates_nothing() {
        let mut workspace = [RuleApplication::EMPTY; RULES.len()];
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                let (_, used) = derive_g133_cycle_mod11_rules_into(&mut workspace).unwrap();
                replay_g133_cycle_mod11_rules(&workspace[..used]).unwrap();
            }
        });
        assert_eq!(allocations, 0);
    }
}
