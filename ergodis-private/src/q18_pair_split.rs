//! Sealed structural reduction for the unassumed length-18 GS quotient.
//!
//! This adapter does not assume a multiplier, reflection, or negation symmetry.
//! It splits opposite coordinates into cyclic and negacyclic length-nine
//! channels, and independently projects the same presentation onto every
//! divisor-cycle partition of 18.  All presentation-facing operations use
//! fixed caller-owned storage and allocate nothing.

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, ExtractorDescriptor,
    ProvenanceClass, RuleApplication, RuleSpec, SynthesisError,
};

pub const Q18_ORDER: usize = 18;
pub const Q18_HALF_ORDER: usize = 9;
pub const Q18_BLOCKS: usize = 4;
pub const Q18_DIVISORS: [u8; 6] = [1, 2, 3, 6, 9, 18];

const ROW_SUMS: [i32; Q18_BLOCKS] = [2, 0, 0, 0];
const FULL_PAF_ZERO: i32 = 1_976;
const FULL_PAF_OFF_ZERO: i32 = -116;
const EXTRACTOR_ID: [u8; 16] = *b"c1016-q18split01";
const EXTRACTOR_VERSION: u16 = 1;
const THEOREM_SOURCE: &[u8] = b"q18 opposite-pair split v1: y[j]=u[j]+v[j], y[j+9]=u[j]-v[j]; C_y(s)+C_y(s+9)=4 C_u(s); C_y(s)-C_y(s+9)=4 N_v(s); divisor cycle-square energy is the sum of PAF over the corresponding shift subgroup";

const FACT_REGISTERED_EXTRACTOR: u8 = 0;
const FACT_OPPOSITE_PAIR_BIJECTION: u8 = 1;
const FACT_PAF_SPLIT_IDENTITY: u8 = 2;
const FACT_SPLIT_TARGETS: u8 = 3;
const FACT_DIVISOR_CYCLE_IDENTITY: u8 = 4;
const FACT_DIVISOR_TARGETS: u8 = 5;
const FACT_NECESSARY_REDUCTION: u8 = 6;

const RULES: [RuleSpec; 6] = [
    RuleSpec::registered(
        0x18_01,
        1 << FACT_REGISTERED_EXTRACTOR,
        FACT_OPPOSITE_PAIR_BIJECTION,
    ),
    RuleSpec::registered(
        0x18_02,
        1 << FACT_OPPOSITE_PAIR_BIJECTION,
        FACT_PAF_SPLIT_IDENTITY,
    ),
    RuleSpec::registered(0x18_03, 1 << FACT_PAF_SPLIT_IDENTITY, FACT_SPLIT_TARGETS),
    RuleSpec::registered(
        0x18_04,
        1 << FACT_REGISTERED_EXTRACTOR,
        FACT_DIVISOR_CYCLE_IDENTITY,
    ),
    RuleSpec::registered(
        0x18_05,
        1 << FACT_DIVISOR_CYCLE_IDENTITY,
        FACT_DIVISOR_TARGETS,
    ),
    RuleSpec::registered(
        0x18_06,
        (1 << FACT_SPLIT_TARGETS) | (1 << FACT_DIVISOR_TARGETS),
        FACT_NECESSARY_REDUCTION,
    ),
];

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18Coefficients {
    pub blocks: [[i8; Q18_ORDER]; Q18_BLOCKS],
}

const _: () = assert!(std::mem::size_of::<Q18Coefficients>() == 128);
const _: () = assert!(std::mem::align_of::<Q18Coefficients>() == 64);

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18PairSplit {
    pub cyclic: [[i8; Q18_HALF_ORDER]; Q18_BLOCKS],
    pub negacyclic: [[i8; Q18_HALF_ORDER]; Q18_BLOCKS],
}

const _: () = assert!(std::mem::size_of::<Q18PairSplit>() == 128);
const _: () = assert!(std::mem::align_of::<Q18PairSplit>() == 64);

impl Q18PairSplit {
    pub const ZERO: Self = Self {
        cyclic: [[0; Q18_HALF_ORDER]; Q18_BLOCKS],
        negacyclic: [[0; Q18_HALF_ORDER]; Q18_BLOCKS],
    };
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18DivisorProjection {
    /// Entries correspond to `Q18_DIVISORS` in order.
    pub cycle_square_energies: [i32; 6],
    reserved: [i32; 2],
}

const _: () = assert!(std::mem::size_of::<Q18DivisorProjection>() == 32);
const _: () = assert!(std::mem::align_of::<Q18DivisorProjection>() == 4);

impl Q18DivisorProjection {
    pub const ZERO: Self = Self {
        cycle_square_energies: [0; 6],
        reserved: [0; 2],
    };
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct Q18PairSplitBinding {
    descriptor: ExtractorDescriptor,
}

impl Q18PairSplitBinding {
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
pub struct Q18PairSplitProof {
    pub binding: Q18PairSplitBinding,
    pub cyclic_energy: i32,
    pub negacyclic_energy: i32,
    pub cyclic_off_zero: i32,
    pub negacyclic_off_zero: i32,
    pub divisor_cycle_energies: [i32; 6],
    pub transcript: Box<[RuleApplication]>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum Q18PairSplitError {
    #[error("q18 coefficient is not an odd integer in [-29, 29]")]
    InvalidCoefficient,
    #[error("q18 row sums do not match the registered GS semantics")]
    InvalidRowSums,
    #[error("q18 presentation does not satisfy the registered PAF target")]
    InvalidPafTarget,
    #[error("opposite-pair reconstruction or PAF identity failed")]
    SplitIdentity,
    #[error("divisor-cycle projection identity failed")]
    DivisorIdentity,
    #[error("q18 extractor descriptor is not registered")]
    UnregisteredExtractor,
    #[error("proof provenance cannot authorize this reduction")]
    UnauthorizedProvenance,
    #[error("proof fields disagree with canonical theorem semantics")]
    SemanticMismatch,
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_q18_pair_split_proof(
    binding: Q18PairSplitBinding,
) -> Result<Q18PairSplitProof, Q18PairSplitError> {
    if !binding.is_registered() {
        return Err(Q18PairSplitError::UnregisteredExtractor);
    }
    let (cyclic_energy, negacyclic_energy, cyclic_off_zero, negacyclic_off_zero) =
        required_split_targets();
    let derivation = derive_horn_closure(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        RULES.len() as u32,
    )?;
    let proof = Q18PairSplitProof {
        binding,
        cyclic_energy,
        negacyclic_energy,
        cyclic_off_zero,
        negacyclic_off_zero,
        divisor_cycle_energies: required_divisor_targets(),
        transcript: derivation.applications,
        provenance: ProvenanceClass::ProvedStructural,
    };
    verify_q18_pair_split_proof(&proof)?;
    Ok(proof)
}

pub fn verify_q18_pair_split_proof(proof: &Q18PairSplitProof) -> Result<(), Q18PairSplitError> {
    if !proof.binding.is_registered() {
        return Err(Q18PairSplitError::UnregisteredExtractor);
    }
    if proof.provenance != ProvenanceClass::ProvedStructural {
        return Err(Q18PairSplitError::UnauthorizedProvenance);
    }
    let expected_split = required_split_targets();
    if (
        proof.cyclic_energy,
        proof.negacyclic_energy,
        proof.cyclic_off_zero,
        proof.negacyclic_off_zero,
    ) != expected_split
        || proof.divisor_cycle_energies != required_divisor_targets()
    {
        return Err(Q18PairSplitError::SemanticMismatch);
    }
    replay_q18_pair_split_rules(&proof.transcript)?;
    Ok(())
}

pub fn derive_q18_pair_split_rules_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    derive_horn_closure_into(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        RULES.len() as u32,
        workspace,
    )
}

pub fn replay_q18_pair_split_rules(transcript: &[RuleApplication]) -> Result<u64, SynthesisError> {
    replay_horn_derivation(
        1 << FACT_REGISTERED_EXTRACTOR,
        1 << FACT_NECESSARY_REDUCTION,
        &RULES,
        transcript,
    )
}

/// Split an arbitrary bounded odd q18 coefficient presentation.  Row sums and
/// GS PAF targets are deliberately checked by `verify_q18_gs_reduction`.
pub fn split_q18_coefficients(
    coefficients: &Q18Coefficients,
    output: &mut Q18PairSplit,
) -> Result<(), Q18PairSplitError> {
    for block in 0..Q18_BLOCKS {
        for point in 0..Q18_HALF_ORDER {
            let first = coefficients.blocks[block][point];
            let opposite = coefficients.blocks[block][point + Q18_HALF_ORDER];
            if !valid_coefficient(first) || !valid_coefficient(opposite) {
                return Err(Q18PairSplitError::InvalidCoefficient);
            }
            output.cyclic[block][point] = (first + opposite) / 2;
            output.negacyclic[block][point] = (first - opposite) / 2;
        }
    }
    Ok(())
}

/// Reconstruct the q18 coefficients and fail closed if the split does not
/// encode bounded odd coefficients.  The caller owns the fixed output.
pub fn reconstruct_q18_coefficients(
    split: &Q18PairSplit,
    output: &mut Q18Coefficients,
) -> Result<(), Q18PairSplitError> {
    for block in 0..Q18_BLOCKS {
        for point in 0..Q18_HALF_ORDER {
            let cyclic = i16::from(split.cyclic[block][point]);
            let negacyclic = i16::from(split.negacyclic[block][point]);
            let first = cyclic + negacyclic;
            let opposite = cyclic - negacyclic;
            if !(-29..=29).contains(&first)
                || !(-29..=29).contains(&opposite)
                || first & 1 == 0
                || opposite & 1 == 0
            {
                return Err(Q18PairSplitError::InvalidCoefficient);
            }
            output.blocks[block][point] = first as i8;
            output.blocks[block][point + Q18_HALF_ORDER] = opposite as i8;
        }
    }
    Ok(())
}

/// Compute all divisor-cycle square energies using the fixed divisor order.
pub fn project_q18_divisor_cycles(
    coefficients: &Q18Coefficients,
    output: &mut Q18DivisorProjection,
) -> Result<(), Q18PairSplitError> {
    validate_coefficients(coefficients)?;
    for (slot, &divisor) in Q18_DIVISORS.iter().enumerate() {
        let divisor = usize::from(divisor);
        let mut total = 0_i32;
        for block in 0..Q18_BLOCKS {
            for residue in 0..divisor {
                let mut sum = 0_i32;
                let mut point = residue;
                while point < Q18_ORDER {
                    sum += i32::from(coefficients.blocks[block][point]);
                    point += divisor;
                }
                total += sum * sum;
            }
        }
        output.cycle_square_energies[slot] = total;
    }
    output.reserved = [0; 2];
    Ok(())
}

/// Check the reduced length-nine constraints directly.  This is the pruning
/// endpoint justified by `Q18PairSplitProof`; it also reconstructs and checks
/// the bounded q18 presentation instead of trusting caller-supplied features.
pub fn verify_q18_split_constraints(split: &Q18PairSplit) -> Result<(), Q18PairSplitError> {
    let mut reconstructed = Q18Coefficients {
        blocks: [[0; Q18_ORDER]; Q18_BLOCKS],
    };
    reconstruct_q18_coefficients(split, &mut reconstructed)?;
    validate_row_sums(&reconstructed)?;
    let (cyclic_energy, negacyclic_energy, cyclic_off_zero, negacyclic_off_zero) =
        required_split_targets();
    if combined_cyclic_paf(split, 0) != cyclic_energy
        || combined_negacyclic_paf(split, 0) != negacyclic_energy
    {
        return Err(Q18PairSplitError::InvalidPafTarget);
    }
    for shift in 1..Q18_HALF_ORDER {
        if combined_cyclic_paf(split, shift) != cyclic_off_zero
            || combined_negacyclic_paf(split, shift) != negacyclic_off_zero
        {
            return Err(Q18PairSplitError::InvalidPafTarget);
        }
    }
    Ok(())
}

/// Recompute and check every registered divisor-cycle target from coefficients.
pub fn verify_q18_divisor_constraints(
    coefficients: &Q18Coefficients,
    output: &mut Q18DivisorProjection,
) -> Result<(), Q18PairSplitError> {
    project_q18_divisor_cycles(coefficients, output)?;
    if output.cycle_square_energies == required_divisor_targets() {
        Ok(())
    } else {
        Err(Q18PairSplitError::InvalidPafTarget)
    }
}

/// Verify both structural identities and the registered GS q18 target.  This
/// is a direct presentation check, not trust in a named feature column.
pub fn verify_q18_gs_reduction(
    coefficients: &Q18Coefficients,
    split: &mut Q18PairSplit,
    projection: &mut Q18DivisorProjection,
) -> Result<(), Q18PairSplitError> {
    validate_coefficients(coefficients)?;
    validate_row_sums(coefficients)?;
    let paf = combined_paf(coefficients);
    if paf[0] != FULL_PAF_ZERO || paf[1..].iter().any(|&value| value != FULL_PAF_OFF_ZERO) {
        return Err(Q18PairSplitError::InvalidPafTarget);
    }
    split_q18_coefficients(coefficients, split)?;
    verify_split_identity(coefficients, split)?;
    verify_q18_split_constraints(split).map_err(|_| Q18PairSplitError::SplitIdentity)?;
    project_q18_divisor_cycles(coefficients, projection)?;
    verify_divisor_identity(&paf, projection)?;
    if projection.cycle_square_energies != required_divisor_targets() {
        return Err(Q18PairSplitError::DivisorIdentity);
    }
    Ok(())
}

fn required_split_targets() -> (i32, i32, i32, i32) {
    (
        (FULL_PAF_ZERO + FULL_PAF_OFF_ZERO) / 4,
        (FULL_PAF_ZERO - FULL_PAF_OFF_ZERO) / 4,
        (FULL_PAF_OFF_ZERO + FULL_PAF_OFF_ZERO) / 4,
        0,
    )
}

fn required_divisor_targets() -> [i32; 6] {
    std::array::from_fn(|slot| {
        let subgroup_order = Q18_ORDER as i32 / i32::from(Q18_DIVISORS[slot]);
        FULL_PAF_ZERO + (subgroup_order - 1) * FULL_PAF_OFF_ZERO
    })
}

#[inline(always)]
fn valid_coefficient(value: i8) -> bool {
    (-29..=29).contains(&value) && value & 1 != 0
}

fn validate_coefficients(coefficients: &Q18Coefficients) -> Result<(), Q18PairSplitError> {
    if coefficients
        .blocks
        .iter()
        .flatten()
        .copied()
        .all(valid_coefficient)
    {
        Ok(())
    } else {
        Err(Q18PairSplitError::InvalidCoefficient)
    }
}

fn validate_row_sums(coefficients: &Q18Coefficients) -> Result<(), Q18PairSplitError> {
    for (block, &target) in ROW_SUMS.iter().enumerate() {
        let sum = coefficients.blocks[block]
            .iter()
            .copied()
            .map(i32::from)
            .sum::<i32>();
        if sum != target {
            return Err(Q18PairSplitError::InvalidRowSums);
        }
    }
    Ok(())
}

fn combined_paf(coefficients: &Q18Coefficients) -> [i32; Q18_ORDER] {
    let mut output = [0_i32; Q18_ORDER];
    for block in 0..Q18_BLOCKS {
        for (shift, value) in output.iter_mut().enumerate() {
            for point in 0..Q18_ORDER {
                *value += i32::from(coefficients.blocks[block][point])
                    * i32::from(coefficients.blocks[block][(point + shift) % Q18_ORDER]);
            }
        }
    }
    output
}

fn combined_cyclic_paf(split: &Q18PairSplit, shift: usize) -> i32 {
    let mut total = 0_i32;
    for block in 0..Q18_BLOCKS {
        for point in 0..Q18_HALF_ORDER {
            total += i32::from(split.cyclic[block][point])
                * i32::from(split.cyclic[block][(point + shift) % Q18_HALF_ORDER]);
        }
    }
    total
}

fn combined_negacyclic_paf(split: &Q18PairSplit, shift: usize) -> i32 {
    let mut total = 0_i32;
    for block in 0..Q18_BLOCKS {
        for point in 0..Q18_HALF_ORDER {
            let wrapped = point + shift >= Q18_HALF_ORDER;
            let other = (point + shift) % Q18_HALF_ORDER;
            let product = i32::from(split.negacyclic[block][point])
                * i32::from(split.negacyclic[block][other]);
            total += if wrapped { -product } else { product };
        }
    }
    total
}

fn verify_split_identity(
    coefficients: &Q18Coefficients,
    split: &Q18PairSplit,
) -> Result<(), Q18PairSplitError> {
    let mut reconstructed = Q18Coefficients {
        blocks: [[0; Q18_ORDER]; Q18_BLOCKS],
    };
    reconstruct_q18_coefficients(split, &mut reconstructed)?;
    if reconstructed != *coefficients {
        return Err(Q18PairSplitError::SplitIdentity);
    }
    let paf = combined_paf(coefficients);
    for shift in 0..Q18_HALF_ORDER {
        if paf[shift] + paf[shift + Q18_HALF_ORDER] != 4 * combined_cyclic_paf(split, shift)
            || paf[shift] - paf[shift + Q18_HALF_ORDER] != 4 * combined_negacyclic_paf(split, shift)
        {
            return Err(Q18PairSplitError::SplitIdentity);
        }
    }
    Ok(())
}

fn verify_divisor_identity(
    paf: &[i32; Q18_ORDER],
    projection: &Q18DivisorProjection,
) -> Result<(), Q18PairSplitError> {
    for (slot, &divisor) in Q18_DIVISORS.iter().enumerate() {
        let divisor = usize::from(divisor);
        let mut expected = 0_i32;
        let mut shift = 0_usize;
        while shift < Q18_ORDER {
            expected += paf[shift];
            shift += divisor;
        }
        if projection.cycle_square_energies[slot] != expected {
            return Err(Q18PairSplitError::DivisorIdentity);
        }
    }
    Ok(())
}

fn descriptor() -> ExtractorDescriptor {
    let mut parameter_hasher = Sha256::new();
    parameter_hasher.update([Q18_ORDER as u8, Q18_HALF_ORDER as u8, Q18_BLOCKS as u8]);
    for row_sum in ROW_SUMS {
        parameter_hasher.update(row_sum.to_le_bytes());
    }
    parameter_hasher.update(FULL_PAF_ZERO.to_le_bytes());
    parameter_hasher.update(FULL_PAF_OFF_ZERO.to_le_bytes());
    let parameter_digest = parameter_hasher.finalize().into();
    let source_commitment = Sha256::digest(THEOREM_SOURCE).into();
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
    use crate::allocation_test::tracked_allocations;

    fn direct_paf(word: &[i8], shift: usize) -> i32 {
        (0..word.len())
            .map(|point| i32::from(word[point]) * i32::from(word[(point + shift) % word.len()]))
            .sum()
    }

    fn direct_negacyclic_paf(word: &[i8], shift: usize) -> i32 {
        (0..word.len())
            .map(|point| {
                let product =
                    i32::from(word[point]) * i32::from(word[(point + shift) % word.len()]);
                if point + shift >= word.len() {
                    -product
                } else {
                    product
                }
            })
            .sum()
    }

    #[test]
    fn exhaustive_small_half_orders_match_independent_direct_oracle() {
        const VALUES: [i8; 3] = [-1, 0, 1];
        for half in 1_usize..=4 {
            let states = 3_usize.pow((2 * half) as u32);
            for mut code in 0..states {
                let mut cyclic = [0_i8; 4];
                let mut negacyclic = [0_i8; 4];
                for point in 0..half {
                    cyclic[point] = VALUES[code % 3];
                    code /= 3;
                    negacyclic[point] = VALUES[code % 3];
                    code /= 3;
                }
                let mut source = [0_i8; 8];
                for point in 0..half {
                    source[point] = cyclic[point] + negacyclic[point];
                    source[point + half] = cyclic[point] - negacyclic[point];
                }
                for shift in 0..half {
                    let first = direct_paf(&source[..2 * half], shift);
                    let opposite = direct_paf(&source[..2 * half], shift + half);
                    assert_eq!(first + opposite, 4 * direct_paf(&cyclic[..half], shift));
                    assert_eq!(
                        first - opposite,
                        4 * direct_negacyclic_paf(&negacyclic[..half], shift)
                    );
                }
            }
        }
    }

    #[test]
    fn randomized_q18_split_and_divisor_identities_match_direct_oracles() {
        let mut state = 0x9e37_79b9_7f4a_7c15_u64;
        for _ in 0..2_048 {
            let mut coefficients = Q18Coefficients {
                blocks: [[0; Q18_ORDER]; Q18_BLOCKS],
            };
            for value in coefficients.blocks.iter_mut().flatten() {
                state ^= state << 7;
                state ^= state >> 9;
                state ^= state << 8;
                *value = 2 * (state % 30) as i8 - 29;
            }
            let mut split = Q18PairSplit::ZERO;
            split_q18_coefficients(&coefficients, &mut split).unwrap();
            verify_split_identity(&coefficients, &split).unwrap();
            let mut reconstructed = Q18Coefficients {
                blocks: [[0; Q18_ORDER]; Q18_BLOCKS],
            };
            reconstruct_q18_coefficients(&split, &mut reconstructed).unwrap();
            assert_eq!(reconstructed, coefficients);

            let paf = combined_paf(&coefficients);
            let mut projection = Q18DivisorProjection::ZERO;
            project_q18_divisor_cycles(&coefficients, &mut projection).unwrap();
            verify_divisor_identity(&paf, &projection).unwrap();
        }
    }

    #[test]
    fn canonical_proof_replays_and_mutations_fail_closed() {
        let proof = synthesize_q18_pair_split_proof(Q18PairSplitBinding::registered()).unwrap();
        assert_eq!(proof.cyclic_energy, 465);
        assert_eq!(proof.negacyclic_energy, 523);
        assert_eq!(
            proof.divisor_cycle_energies,
            [4, 1_048, 1_396, 1_744, 1_860, 1_976]
        );
        verify_q18_pair_split_proof(&proof).unwrap();

        let mut bad_provenance = proof.clone();
        bad_provenance.provenance = ProvenanceClass::ObservedEvolved;
        assert_eq!(
            verify_q18_pair_split_proof(&bad_provenance),
            Err(Q18PairSplitError::UnauthorizedProvenance)
        );

        let mut bad_field = proof.clone();
        bad_field.cyclic_energy += 1;
        assert_eq!(
            verify_q18_pair_split_proof(&bad_field),
            Err(Q18PairSplitError::SemanticMismatch)
        );

        let mut bad_binding = proof;
        bad_binding.binding.descriptor = ExtractorDescriptor::registered(
            EXTRACTOR_ID,
            EXTRACTOR_VERSION + 1,
            bad_binding.binding.descriptor.parameter_digest(),
            bad_binding.binding.descriptor.source_commitment(),
        );
        assert_eq!(
            verify_q18_pair_split_proof(&bad_binding),
            Err(Q18PairSplitError::UnregisteredExtractor)
        );
    }

    #[test]
    fn malformed_presentations_and_splits_fail_closed() {
        let mut coefficients = Q18Coefficients {
            blocks: [[1; Q18_ORDER]; Q18_BLOCKS],
        };
        let mut split = Q18PairSplit::ZERO;
        coefficients.blocks[0][0] = 2;
        assert_eq!(
            split_q18_coefficients(&coefficients, &mut split),
            Err(Q18PairSplitError::InvalidCoefficient)
        );

        coefficients.blocks[0][0] = 31;
        assert_eq!(
            split_q18_coefficients(&coefficients, &mut split),
            Err(Q18PairSplitError::InvalidCoefficient)
        );

        coefficients.blocks[0][0] = 1;
        let mut projection = Q18DivisorProjection::ZERO;
        assert_eq!(
            verify_q18_gs_reduction(&coefficients, &mut split, &mut projection),
            Err(Q18PairSplitError::InvalidRowSums)
        );

        for block in 0..Q18_BLOCKS {
            for point in 0..Q18_ORDER {
                coefficients.blocks[block][point] = if point < 9 { 1 } else { -1 };
            }
        }
        coefficients.blocks[0][9] = 1;
        assert_eq!(
            verify_q18_gs_reduction(&coefficients, &mut split, &mut projection),
            Err(Q18PairSplitError::InvalidPafTarget)
        );

        let mut invalid_split = Q18PairSplit::ZERO;
        invalid_split.cyclic[0][0] = 29;
        invalid_split.negacyclic[0][0] = 29;
        let mut output = Q18Coefficients {
            blocks: [[0; Q18_ORDER]; Q18_BLOCKS],
        };
        assert_eq!(
            reconstruct_q18_coefficients(&invalid_split, &mut output),
            Err(Q18PairSplitError::InvalidCoefficient)
        );
    }

    #[test]
    fn presentation_kernels_allocate_nothing() {
        let coefficients = Q18Coefficients {
            blocks: [[1; Q18_ORDER]; Q18_BLOCKS],
        };
        let mut split = Q18PairSplit::ZERO;
        let mut projection = Q18DivisorProjection::ZERO;
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..1_024 {
                split_q18_coefficients(&coefficients, &mut split).unwrap();
                let mut reconstructed = Q18Coefficients {
                    blocks: [[0; Q18_ORDER]; Q18_BLOCKS],
                };
                reconstruct_q18_coefficients(&split, &mut reconstructed).unwrap();
                project_q18_divisor_cycles(&coefficients, &mut projection).unwrap();
                verify_split_identity(&coefficients, &split).unwrap();
                let _ = verify_q18_split_constraints(&split);
                let _ = verify_q18_divisor_constraints(&coefficients, &mut projection);
            }
        });
        assert_eq!(allocations, 0);
    }
}
