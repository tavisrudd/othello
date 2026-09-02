//! Private structural proof for cyclic-subgroup PAF aggregation.
//!
//! For a subset `X` of a cyclic group and a subgroup `H`, double counting
//! ordered pairs gives
//!
//! `sum_{h in H} |X intersect (X+h)| = sum_C |X intersect C|^2`,
//!
//! where `C` ranges over the cosets of `H`.  Consequently, uniform nonzero
//! PAF/intersection value `lambda` and total row weight `r` force the right
//! side to equal `r + (|H|-1) lambda`.  This is a compact structural theorem,
//! not a census certificate.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

const EXTRACTOR_ID: [u8; 16] = *b"c1016-cyclic-dc1";
const EXTRACTOR_VERSION: u16 = 1;
const THEOREM_SOURCE: &[u8] =
    b"cyclic subgroup ordered-pair double count v1: sum_h |X cap (X+h)| = sum_cosets |X cap C|^2";

const FACT_REGISTERED_INSTANCE: u8 = 0;
const FACT_COSET_PARTITION: u8 = 1;
const FACT_ORDERED_PAIR_BIJECTION: u8 = 2;
const FACT_DIAGONAL_SPLIT: u8 = 3;
const FACT_ENERGY_FORMULA: u8 = 4;

const RULES: [RuleSpec; 4] = [
    RuleSpec::registered(0xc1_01, 1 << FACT_REGISTERED_INSTANCE, FACT_COSET_PARTITION),
    RuleSpec::registered(
        0xc1_02,
        1 << FACT_COSET_PARTITION,
        FACT_ORDERED_PAIR_BIJECTION,
    ),
    RuleSpec::registered(
        0xc1_03,
        1 << FACT_ORDERED_PAIR_BIJECTION,
        FACT_DIAGONAL_SPLIT,
    ),
    RuleSpec::registered(0xc1_04, 1 << FACT_DIAGONAL_SPLIT, FACT_ENERGY_FORMULA),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct SubgroupEnergyInstance {
    pub carrier: u16,
    pub subgroup_order: u16,
    pub block_count: u8,
    pub row_weight_total: u32,
    pub uniform_nonzero_intersection: u32,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct SubgroupEnergyBinding {
    descriptor: ExtractorDescriptor,
    instance: SubgroupEnergyInstance,
}

impl SubgroupEnergyBinding {
    pub fn registered(instance: SubgroupEnergyInstance) -> Result<Self, SubgroupEnergyError> {
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
pub struct SubgroupEnergyProof {
    pub binding: SubgroupEnergyBinding,
    pub required_square_sum: u64,
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum SubgroupEnergyError {
    #[error("cyclic subgroup instance is invalid")]
    InvalidInstance,
    #[error("subgroup-energy arithmetic overflowed")]
    ArithmeticOverflow,
    #[error("extractor descriptor does not match canonical instance semantics")]
    UnregisteredExtractor,
    #[error("proof provenance cannot authorize a structural theorem")]
    UnauthorizedProvenance,
    #[error("claimed subgroup energy disagrees with the structural formula")]
    SemanticMismatch,
    #[error("block presentation or caller workspace is invalid")]
    InvalidPresentation,
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_subgroup_energy_proof(
    binding: SubgroupEnergyBinding,
) -> Result<SubgroupEnergyProof, SubgroupEnergyError> {
    if !binding.is_registered() {
        return Err(SubgroupEnergyError::UnregisteredExtractor);
    }
    let required_square_sum = required_square_sum(binding.instance)?;
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED_INSTANCE,
        1 << FACT_ENERGY_FORMULA,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = SubgroupEnergyProof {
        binding,
        required_square_sum,
        transcript: derivation.applications,
        provenance: ProvenanceClass::ProvedStructural,
    };
    verify_subgroup_energy_proof(&proof)?;
    Ok(proof)
}

pub fn verify_subgroup_energy_proof(
    proof: &SubgroupEnergyProof,
) -> Result<(), SubgroupEnergyError> {
    if !proof.binding.is_registered() {
        return Err(SubgroupEnergyError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ProvedStructural {
        return Err(SubgroupEnergyError::UnauthorizedProvenance);
    }
    if proof.required_square_sum != required_square_sum(proof.binding.instance)? {
        return Err(SubgroupEnergyError::SemanticMismatch);
    }
    replay_subgroup_energy_rules(&proof.transcript)?;
    Ok(())
}

pub fn derive_subgroup_energy_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED_INSTANCE,
        1 << FACT_ENERGY_FORMULA,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_subgroup_energy_rules(transcript: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED_INSTANCE,
        1 << FACT_ENERGY_FORMULA,
        &RULES,
        transcript,
    )
}

pub fn required_square_sum(instance: SubgroupEnergyInstance) -> Result<u64, SubgroupEnergyError> {
    validate_instance(instance)?;
    u64::from(instance.subgroup_order - 1)
        .checked_mul(u64::from(instance.uniform_nonzero_intersection))
        .and_then(|value| value.checked_add(u64::from(instance.row_weight_total)))
        .ok_or(SubgroupEnergyError::ArithmeticOverflow)
}

/// Compute the coset square sum directly into caller-owned storage. `blocks`
/// is a concatenation of `block_count` binary rows of length `carrier`.
pub fn coset_square_sum_into(
    instance: SubgroupEnergyInstance,
    blocks: &[u8],
    coset_counts: &mut [u16],
) -> Result<u64, SubgroupEnergyError> {
    validate_instance(instance)?;
    let carrier = usize::from(instance.carrier);
    let block_count = usize::from(instance.block_count);
    let cosets = carrier / usize::from(instance.subgroup_order);
    if blocks.len() != carrier * block_count || coset_counts.len() < cosets * block_count {
        return Err(SubgroupEnergyError::InvalidPresentation);
    }
    coset_counts[..cosets * block_count].fill(0);
    for block in 0..block_count {
        for point in 0..carrier {
            let bit = blocks[block * carrier + point];
            if bit > 1 {
                return Err(SubgroupEnergyError::InvalidPresentation);
            }
            coset_counts[block * cosets + point % cosets] += u16::from(bit);
        }
    }
    coset_counts[..cosets * block_count]
        .iter()
        .try_fold(0_u64, |sum, &count| {
            sum.checked_add(u64::from(count) * u64::from(count))
                .ok_or(SubgroupEnergyError::ArithmeticOverflow)
        })
}

fn validate_instance(instance: SubgroupEnergyInstance) -> Result<(), SubgroupEnergyError> {
    if instance.carrier == 0
        || instance.subgroup_order == 0
        || instance.carrier % instance.subgroup_order != 0
        || instance.block_count == 0
    {
        return Err(SubgroupEnergyError::InvalidInstance);
    }
    Ok(())
}

fn descriptor_for(instance: SubgroupEnergyInstance) -> ExtractorDescriptor {
    let mut parameter_hasher = Sha256::new();
    parameter_hasher.update(instance.carrier.to_le_bytes());
    parameter_hasher.update(instance.subgroup_order.to_le_bytes());
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
        1 << FACT_ENERGY_FORMULA,
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn g53_four_new_subgroup_reductions_replay_structurally() {
        let expected = [(9, 5_203), (18, 9_883), (58, 30_683), (87, 45_763)];
        for (subgroup_order, required) in expected {
            let binding = SubgroupEnergyBinding::registered(SubgroupEnergyInstance {
                carrier: 522,
                subgroup_order,
                block_count: 4,
                row_weight_total: 1_043,
                uniform_nonzero_intersection: 520,
            })
            .unwrap();
            let proof = synthesize_subgroup_energy_proof(binding).unwrap();
            assert_eq!(proof.required_square_sum, required);
            verify_subgroup_energy_proof(&proof).unwrap();
        }
    }

    #[test]
    fn exhaustive_small_double_count_matches_direct_intersections() {
        for carrier in 1_u16..=8 {
            for subgroup_order in 1_u16..=carrier {
                if carrier % subgroup_order != 0 {
                    continue;
                }
                let instance = SubgroupEnergyInstance {
                    carrier,
                    subgroup_order,
                    block_count: 1,
                    row_weight_total: 0,
                    uniform_nonzero_intersection: 0,
                };
                let cosets = usize::from(carrier / subgroup_order);
                let mut counts = [0_u16; 8];
                let mut block = [0_u8; 8];
                for mask in 0_u16..1_u16 << carrier {
                    for point in 0..usize::from(carrier) {
                        block[point] = ((mask >> point) & 1) as u8;
                    }
                    let square = coset_square_sum_into(
                        instance,
                        &block[..usize::from(carrier)],
                        &mut counts[..cosets],
                    )
                    .unwrap();
                    let step = usize::from(carrier / subgroup_order);
                    let mut direct = 0_u64;
                    for multiple in 0..usize::from(subgroup_order) {
                        let shift = multiple * step;
                        for point in 0..usize::from(carrier) {
                            direct += u64::from(
                                block[point] * block[(point + shift) % usize::from(carrier)],
                            );
                        }
                    }
                    assert_eq!(square, direct);
                }
            }
        }
    }

    #[test]
    fn malformed_binding_and_provenance_fail_closed() {
        let instance = SubgroupEnergyInstance {
            carrier: 522,
            subgroup_order: 9,
            block_count: 4,
            row_weight_total: 1_043,
            uniform_nonzero_intersection: 520,
        };
        let mut binding = SubgroupEnergyBinding::registered(instance).unwrap();
        binding.instance.subgroup_order = 18;
        assert_eq!(
            synthesize_subgroup_energy_proof(binding),
            Err(SubgroupEnergyError::UnregisteredExtractor)
        );

        let mut proof =
            synthesize_subgroup_energy_proof(SubgroupEnergyBinding::registered(instance).unwrap())
                .unwrap();
        proof.provenance = ProvenanceClass::ObservedEvolved;
        assert_eq!(
            verify_subgroup_energy_proof(&proof),
            Err(SubgroupEnergyError::UnauthorizedProvenance)
        );
    }
}
