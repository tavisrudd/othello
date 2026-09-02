//! Private structural proof for cyclic quotient-PAF aggregation.
//!
//! Residue counts in `Z/qZ` turn their cyclic autocorrelation into the sum of
//! original intersections over the fibre of each quotient shift.  Uniform
//! nonzero intersections therefore give one exact target at quotient shift
//! zero and another at every nonzero quotient shift.  The proof is a generic
//! double count and has no large certificate.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

const EXTRACTOR_ID: [u8; 16] = *b"c1016-quot-paf01";
const EXTRACTOR_VERSION: u16 = 1;
const THEOREM_SOURCE: &[u8] = b"cyclic quotient PAF double count v1: residue autocorrelation at s equals sum of source intersections above s";

const FACT_REGISTERED_INSTANCE: u8 = 0;
const FACT_RESIDUE_PARTITION: u8 = 1;
const FACT_PAIR_FIBRE_BIJECTION: u8 = 2;
const FACT_ZERO_FIBRE_SPLIT: u8 = 3;
const FACT_QUOTIENT_TARGETS: u8 = 4;

const RULES: [RuleSpec; 4] = [
    RuleSpec::registered(
        0xc2_01,
        1 << FACT_REGISTERED_INSTANCE,
        FACT_RESIDUE_PARTITION,
    ),
    RuleSpec::registered(
        0xc2_02,
        1 << FACT_RESIDUE_PARTITION,
        FACT_PAIR_FIBRE_BIJECTION,
    ),
    RuleSpec::registered(
        0xc2_03,
        1 << FACT_PAIR_FIBRE_BIJECTION,
        FACT_ZERO_FIBRE_SPLIT,
    ),
    RuleSpec::registered(0xc2_04, 1 << FACT_ZERO_FIBRE_SPLIT, FACT_QUOTIENT_TARGETS),
];

const FACT_TYPED_CHARACTER_ORDERS: u8 = 0;
const FACT_DIVISOR_SECTORS: u8 = 1;
const FACT_COMPLETE_DUAL_COVERAGE: u8 = 2;
const FACT_QUOTIENT_REDUCTION: u8 = 3;

const COVERAGE_RULES: [RuleSpec; 3] = [
    RuleSpec::registered(
        0xc2_11,
        1 << FACT_TYPED_CHARACTER_ORDERS,
        FACT_DIVISOR_SECTORS,
    ),
    RuleSpec::registered(
        0xc2_12,
        1 << FACT_DIVISOR_SECTORS,
        FACT_COMPLETE_DUAL_COVERAGE,
    ),
    RuleSpec::registered(
        0xc2_13,
        1 << FACT_COMPLETE_DUAL_COVERAGE,
        FACT_QUOTIENT_REDUCTION,
    ),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct QuotientPafInstance {
    pub carrier: u16,
    pub quotient_order: u16,
    pub block_count: u8,
    pub row_weight_total: u32,
    pub uniform_nonzero_intersection: u32,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct QuotientPafBinding {
    descriptor: ExtractorDescriptor,
    instance: QuotientPafInstance,
}

impl QuotientPafBinding {
    pub fn registered(instance: QuotientPafInstance) -> Result<Self, QuotientPafError> {
        validate_instance(instance)?;
        Ok(Self {
            descriptor: descriptor_for(instance),
            instance,
        })
    }

    fn is_registered(self) -> bool {
        validate_instance(self.instance).is_ok() && self.descriptor == descriptor_for(self.instance)
    }
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct QuotientPafProof {
    pub binding: QuotientPafBinding,
    pub zero_shift_target: u64,
    pub nonzero_shift_target: u64,
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct CharacterCoverageObservation {
    pub character_orders: Box<[u16]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct CharacterCoverageProof {
    pub quotient_proof: QuotientPafProof,
    pub character_orders: Box<[u16]>,
    pub covered_nontrivial_characters: u16,
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum QuotientPafError {
    #[error("cyclic quotient instance is invalid")]
    InvalidInstance,
    #[error("quotient-PAF arithmetic overflowed")]
    ArithmeticOverflow,
    #[error("extractor descriptor does not match canonical instance semantics")]
    UnregisteredExtractor,
    #[error("proof provenance cannot authorize a structural theorem")]
    UnauthorizedProvenance,
    #[error("claimed quotient targets disagree with the structural formula")]
    SemanticMismatch,
    #[error("block presentation or caller workspace is invalid")]
    InvalidPresentation,
    #[error("observed character sectors do not cover one quotient dual")]
    IncompleteCharacterCoverage,
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_quotient_paf_proof(
    binding: QuotientPafBinding,
) -> Result<QuotientPafProof, QuotientPafError> {
    if !binding.is_registered() {
        return Err(QuotientPafError::UnregisteredExtractor);
    }
    let (zero_shift_target, nonzero_shift_target) = required_targets(binding.instance)?;
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED_INSTANCE,
        1 << FACT_QUOTIENT_TARGETS,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = QuotientPafProof {
        binding,
        zero_shift_target,
        nonzero_shift_target,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ProvedStructural,
    };
    verify_quotient_paf_proof(&proof)?;
    Ok(proof)
}

pub fn verify_quotient_paf_proof(proof: &QuotientPafProof) -> Result<(), QuotientPafError> {
    if !proof.binding.is_registered() {
        return Err(QuotientPafError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ProvedStructural {
        return Err(QuotientPafError::UnauthorizedProvenance);
    }
    let expected = required_targets(proof.binding.instance)?;
    if (proof.zero_shift_target, proof.nonzero_shift_target) != expected {
        return Err(QuotientPafError::SemanticMismatch);
    }
    replay_quotient_paf_rules(&proof.transcript)?;
    Ok(())
}

/// Convert a typed evolved collection of character sectors into the shorter
/// quotient-PAF theorem when their cyclotomic degrees exhaust the nontrivial
/// dual of one cyclic quotient.
pub fn synthesize_character_coverage_proof(
    binding: QuotientPafBinding,
    observation: &CharacterCoverageObservation,
) -> Result<CharacterCoverageProof, QuotientPafError> {
    if observation.provenance != ProvenanceClass::ObservedEvolved {
        return Err(QuotientPafError::UnauthorizedProvenance);
    }
    let covered = verify_character_coverage(
        binding.instance.quotient_order,
        &observation.character_orders,
    )?;
    let quotient_proof = synthesize_quotient_paf_proof(binding)?;
    let derivation = derive_horn_closure(
        1 << FACT_TYPED_CHARACTER_ORDERS,
        1 << FACT_QUOTIENT_REDUCTION,
        &COVERAGE_RULES,
        COVERAGE_RULES.len() as u32,
    )?;
    let proof = CharacterCoverageProof {
        quotient_proof,
        character_orders: observation.character_orders.clone(),
        covered_nontrivial_characters: covered,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ProvedStructural,
    };
    verify_character_coverage_proof(&proof)?;
    Ok(proof)
}

pub fn verify_character_coverage_proof(
    proof: &CharacterCoverageProof,
) -> Result<(), QuotientPafError> {
    if proof.provenance != ProvenanceClass::ProvedStructural {
        return Err(QuotientPafError::UnauthorizedProvenance);
    }
    verify_quotient_paf_proof(&proof.quotient_proof)?;
    let quotient_order = proof.quotient_proof.binding.instance.quotient_order;
    let covered = verify_character_coverage(quotient_order, &proof.character_orders)?;
    if proof.covered_nontrivial_characters != covered {
        return Err(QuotientPafError::SemanticMismatch);
    }
    replay_horn_derivation(
        1 << FACT_TYPED_CHARACTER_ORDERS,
        1 << FACT_QUOTIENT_REDUCTION,
        &COVERAGE_RULES,
        &proof.transcript,
    )?;
    Ok(())
}

fn verify_character_coverage(quotient_order: u16, orders: &[u16]) -> Result<u16, QuotientPafError> {
    if orders.is_empty() {
        return Err(QuotientPafError::IncompleteCharacterCoverage);
    }
    let mut previous = 0_u16;
    let mut covered = 0_u16;
    for &order in orders {
        if order <= 1 || order <= previous || quotient_order % order != 0 {
            return Err(QuotientPafError::IncompleteCharacterCoverage);
        }
        covered = covered
            .checked_add(euler_phi(order))
            .ok_or(QuotientPafError::ArithmeticOverflow)?;
        previous = order;
    }
    if covered != quotient_order - 1 {
        return Err(QuotientPafError::IncompleteCharacterCoverage);
    }
    Ok(covered)
}

fn euler_phi(mut value: u16) -> u16 {
    let mut result = value;
    let mut prime = 2_u16;
    while prime <= value / prime {
        if value % prime == 0 {
            while value % prime == 0 {
                value /= prime;
            }
            result -= result / prime;
        }
        prime += 1;
    }
    if value > 1 {
        result -= result / value;
    }
    result
}

pub fn derive_quotient_paf_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED_INSTANCE,
        1 << FACT_QUOTIENT_TARGETS,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_quotient_paf_rules(transcript: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED_INSTANCE,
        1 << FACT_QUOTIENT_TARGETS,
        &RULES,
        transcript,
    )
}

pub fn required_targets(instance: QuotientPafInstance) -> Result<(u64, u64), QuotientPafError> {
    validate_instance(instance)?;
    let fibre = u64::from(instance.carrier / instance.quotient_order);
    let lambda = u64::from(instance.uniform_nonzero_intersection);
    let nonzero = fibre
        .checked_mul(lambda)
        .ok_or(QuotientPafError::ArithmeticOverflow)?;
    let zero = (fibre - 1)
        .checked_mul(lambda)
        .and_then(|value| value.checked_add(u64::from(instance.row_weight_total)))
        .ok_or(QuotientPafError::ArithmeticOverflow)?;
    Ok((zero, nonzero))
}

/// Compute all quotient autocorrelations into caller-owned buffers.
pub fn quotient_paf_into(
    instance: QuotientPafInstance,
    blocks: &[u8],
    residue_counts: &mut [u16],
    output: &mut [u64],
) -> Result<(), QuotientPafError> {
    validate_instance(instance)?;
    let carrier = usize::from(instance.carrier);
    let quotient = usize::from(instance.quotient_order);
    let block_count = usize::from(instance.block_count);
    if blocks.len() != carrier * block_count
        || residue_counts.len() < quotient * block_count
        || output.len() < quotient
    {
        return Err(QuotientPafError::InvalidPresentation);
    }
    residue_counts[..quotient * block_count].fill(0);
    output[..quotient].fill(0);
    for block in 0..block_count {
        for point in 0..carrier {
            let bit = blocks[block * carrier + point];
            if bit > 1 {
                return Err(QuotientPafError::InvalidPresentation);
            }
            residue_counts[block * quotient + point % quotient] += u16::from(bit);
        }
        let counts = &residue_counts[block * quotient..(block + 1) * quotient];
        for shift in 0..quotient {
            for residue in 0..quotient {
                output[shift] +=
                    u64::from(counts[residue]) * u64::from(counts[(residue + shift) % quotient]);
            }
        }
    }
    Ok(())
}

fn validate_instance(instance: QuotientPafInstance) -> Result<(), QuotientPafError> {
    if instance.carrier == 0
        || instance.quotient_order == 0
        || instance.carrier % instance.quotient_order != 0
        || instance.block_count == 0
    {
        return Err(QuotientPafError::InvalidInstance);
    }
    Ok(())
}

fn descriptor_for(instance: QuotientPafInstance) -> ExtractorDescriptor {
    let mut parameter_hasher = Sha256::new();
    parameter_hasher.update(instance.carrier.to_le_bytes());
    parameter_hasher.update(instance.quotient_order.to_le_bytes());
    parameter_hasher.update([instance.block_count]);
    parameter_hasher.update(instance.row_weight_total.to_le_bytes());
    parameter_hasher.update(instance.uniform_nonzero_intersection.to_le_bytes());
    let parameter_digest = parameter_hasher.finalize().into();
    let source_commitment = Sha256::digest(THEOREM_SOURCE).into();
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
        1 << FACT_REGISTERED_INSTANCE,
        1 << FACT_QUOTIENT_TARGETS,
    )
}

pub(crate) fn evolve_coverage_rule_system() -> (&'static [RuleSpec], u64, u64) {
    (
        &COVERAGE_RULES,
        1 << FACT_TYPED_CHARACTER_ORDERS,
        1 << FACT_QUOTIENT_REDUCTION,
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn g53_q18_quotient_targets_replay_structurally() {
        let binding = QuotientPafBinding::registered(QuotientPafInstance {
            carrier: 522,
            quotient_order: 18,
            block_count: 4,
            row_weight_total: 1_043,
            uniform_nonzero_intersection: 520,
        })
        .unwrap();
        let proof = synthesize_quotient_paf_proof(binding).unwrap();
        assert_eq!(proof.zero_shift_target, 15_603);
        assert_eq!(proof.nonzero_shift_target, 15_080);
        verify_quotient_paf_proof(&proof).unwrap();
    }

    #[test]
    fn exhaustive_small_quotient_paf_matches_source_fibres() {
        for carrier in 1_u16..=8 {
            for quotient_order in 1_u16..=carrier {
                if carrier % quotient_order != 0 {
                    continue;
                }
                let instance = QuotientPafInstance {
                    carrier,
                    quotient_order,
                    block_count: 1,
                    row_weight_total: 0,
                    uniform_nonzero_intersection: 0,
                };
                let mut counts = [0_u16; 8];
                let mut output = [0_u64; 8];
                let mut block = [0_u8; 8];
                for mask in 0_u16..1_u16 << carrier {
                    for point in 0..usize::from(carrier) {
                        block[point] = ((mask >> point) & 1) as u8;
                    }
                    quotient_paf_into(
                        instance,
                        &block[..usize::from(carrier)],
                        &mut counts[..usize::from(quotient_order)],
                        &mut output[..usize::from(quotient_order)],
                    )
                    .unwrap();
                    for quotient_shift in 0..usize::from(quotient_order) {
                        let mut direct = 0_u64;
                        for source_shift in (quotient_shift..usize::from(carrier))
                            .step_by(usize::from(quotient_order))
                        {
                            for point in 0..usize::from(carrier) {
                                direct += u64::from(
                                    block[point]
                                        * block[(point + source_shift) % usize::from(carrier)],
                                );
                            }
                        }
                        assert_eq!(output[quotient_shift], direct);
                    }
                }
            }
        }
    }

    #[test]
    fn malformed_binding_transcript_and_provenance_fail_closed() {
        let instance = QuotientPafInstance {
            carrier: 522,
            quotient_order: 18,
            block_count: 4,
            row_weight_total: 1_043,
            uniform_nonzero_intersection: 520,
        };
        let mut binding = QuotientPafBinding::registered(instance).unwrap();
        binding.instance.quotient_order = 9;
        assert_eq!(
            synthesize_quotient_paf_proof(binding),
            Err(QuotientPafError::UnregisteredExtractor)
        );

        let mut proof =
            synthesize_quotient_paf_proof(QuotientPafBinding::registered(instance).unwrap())
                .unwrap();
        proof.provenance = ProvenanceClass::ObservedEvolved;
        assert_eq!(
            verify_quotient_paf_proof(&proof),
            Err(QuotientPafError::UnauthorizedProvenance)
        );
        proof.provenance = ProvenanceClass::ProvedStructural;
        proof.transcript[0].rule ^= 1;
        assert!(matches!(
            verify_quotient_paf_proof(&proof),
            Err(QuotientPafError::Synthesis(
                SynthesisError::InvalidTranscript
            ))
        ));
    }

    #[test]
    fn evolved_complete_character_set_synthesizes_quotient_theorem() {
        let binding = QuotientPafBinding::registered(QuotientPafInstance {
            carrier: 522,
            quotient_order: 18,
            block_count: 4,
            row_weight_total: 1_043,
            uniform_nonzero_intersection: 520,
        })
        .unwrap();
        let observation = CharacterCoverageObservation {
            character_orders: vec![2, 3, 6, 9, 18].into_boxed_slice(),
            provenance: ProvenanceClass::ObservedEvolved,
        };
        let proof = synthesize_character_coverage_proof(binding, &observation).unwrap();
        assert_eq!(proof.covered_nontrivial_characters, 17);
        verify_character_coverage_proof(&proof).unwrap();
    }

    #[test]
    fn incomplete_duplicate_or_heuristic_character_sets_fail_closed() {
        let binding = QuotientPafBinding::registered(QuotientPafInstance {
            carrier: 522,
            quotient_order: 18,
            block_count: 4,
            row_weight_total: 1_043,
            uniform_nonzero_intersection: 520,
        })
        .unwrap();
        for orders in [vec![2, 3, 6, 9], vec![2, 3, 6, 9, 9, 18]] {
            assert_eq!(
                synthesize_character_coverage_proof(
                    binding,
                    &CharacterCoverageObservation {
                        character_orders: orders.into_boxed_slice(),
                        provenance: ProvenanceClass::ObservedEvolved,
                    },
                ),
                Err(QuotientPafError::IncompleteCharacterCoverage)
            );
        }
        assert_eq!(
            synthesize_character_coverage_proof(
                binding,
                &CharacterCoverageObservation {
                    character_orders: vec![2, 3, 6, 9, 18].into_boxed_slice(),
                    provenance: ProvenanceClass::HeuristicSearch,
                },
            ),
            Err(QuotientPafError::UnauthorizedProvenance)
        );
    }
}
