//! Blind relation mining on a cyclic residual orbit, followed by structural replay.
//!
//! Discovery sees anonymous residual coordinates and permutations only.  The
//! q29 adapter separately re-extracts correlations from canonical rows and
//! derives the promoted relation from the global PAF sum identity.

use sha2::{Digest, Sha256};

use crate::{
    feature_synthesis::FeatureOrigin,
    proof_synthesis::{evolve_unique_bounded_relation_modular, SynthesisError},
};

pub const Q29_RELATION_FIELDS: usize = 14;
pub const Q29_RELATION_ORBIT: usize = 14;

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum CyclicResidualRelationError {
    NotMod18Shell,
    InvalidRowSums,
    InvalidPermutation,
    NoUniqueRelation,
    ForgedHypothesis,
    SourceBindingMismatch,
    Synthesis(SynthesisError),
}

impl From<SynthesisError> for CyclicResidualRelationError {
    fn from(value: SynthesisError) -> Self {
        Self::Synthesis(value)
    }
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct CyclicResidualRelationHypothesis<const FIELDS: usize> {
    pub coefficients: [i8; FIELDS],
    pub prime_fields_tested: u8,
    pub orbit_rows: u16,
    pub origin: FeatureOrigin,
    pub blindness_level: u8,
    pub _pad: [u8; 3],
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29Mod18LevelProof {
    pub source_commitment: [u8; 32],
    pub coefficients: [i8; Q29_RELATION_FIELDS],
    pub level: u64,
    pub exact_score_y: u64,
    pub prime_fields_tested: u8,
    pub origin: FeatureOrigin,
    pub provenance: Q29RelationProvenance,
    pub _pad: [u8; 16],
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29RelationProvenance {
    EvolvedThenStructurallyReplayed = 1,
}

/// Mine primitive coefficient-1 relations from anonymous orbit rows.  The
/// permutation table is caller data and is checked before the bounded search.
pub fn mine_permutation_orbit_relation<const FIELDS: usize, const ORBIT: usize>(
    base: [i32; FIELDS],
    permutations: &[[u8; FIELDS]; ORBIT],
    blindness_level: u8,
) -> Result<CyclicResidualRelationHypothesis<FIELDS>, CyclicResidualRelationError> {
    let mut rows = [[0_i32; FIELDS]; ORBIT];
    for (row, permutation) in rows.iter_mut().zip(permutations) {
        let mut seen = 0_u64;
        for (field, &source) in permutation.iter().enumerate() {
            let source = usize::from(source);
            if source >= FIELDS || source >= 64 || seen & (1_u64 << source) != 0 {
                return Err(CyclicResidualRelationError::InvalidPermutation);
            }
            seen |= 1_u64 << source;
            row[field] = base[source];
        }
    }
    let evolved = evolve_unique_bounded_relation_modular(&rows, 1)?
        .ok_or(CyclicResidualRelationError::NoUniqueRelation)?;
    let coefficients = evolved.coefficients;
    Ok(CyclicResidualRelationHypothesis {
        coefficients,
        prime_fields_tested: evolved.primes_tested,
        orbit_rows: ORBIT as u16,
        origin: FeatureOrigin::Evolved,
        blindness_level,
        _pad: [0; 3],
    })
}

#[must_use]
pub fn q29_unit_action_permutations() -> [[u8; Q29_RELATION_FIELDS]; Q29_RELATION_ORBIT] {
    std::array::from_fn(|unit_index| {
        let unit = unit_index + 1;
        std::array::from_fn(|shift_index| {
            let residue = unit * (shift_index + 1) % 29;
            (residue.min(29 - residue) - 1) as u8
        })
    })
}

pub fn evolve_q29_mod18_level_relation(
    rows: &[[i8; 29]; 4],
    blindness_level: u8,
) -> Result<CyclicResidualRelationHypothesis<Q29_RELATION_FIELDS>, CyclicResidualRelationError> {
    let residual = extract_q29_mod18_residual(rows)?;
    mine_permutation_orbit_relation(residual, &q29_unit_action_permutations(), blindness_level)
}

/// Promote an evolved candidate only after independently re-extracting the
/// canonical PAFs and deriving `sum k=0` from `sum_s PAF=(sum row)^2`.
pub fn prove_q29_mod18_level_relation(
    rows: &[[i8; 29]; 4],
    hypothesis: CyclicResidualRelationHypothesis<Q29_RELATION_FIELDS>,
) -> Result<Q29Mod18LevelProof, CyclicResidualRelationError> {
    if hypothesis.origin != FeatureOrigin::Evolved
        || hypothesis.coefficients != [1; Q29_RELATION_FIELDS]
    {
        return Err(CyclicResidualRelationError::ForgedHypothesis);
    }
    let residual = extract_q29_mod18_residual(rows)?;
    let row_sum_squares = rows
        .iter()
        .enumerate()
        .try_fold(0_i64, |sum, (block, row)| {
            let row_sum = row.iter().fold(0_i64, |acc, &value| acc + i64::from(value));
            if row_sum != i64::from(block == 0) {
                return Err(CyclicResidualRelationError::InvalidRowSums);
            }
            Ok(sum + row_sum * row_sum)
        })?;
    let c0 = combined_correlation(rows, 0);
    let structural_sum = (row_sum_squares - i64::from(c0) - 28 * -18) / 36;
    if structural_sum != 0 || residual.iter().map(|&value| i64::from(value)).sum::<i64>() != 0 {
        return Err(CyclicResidualRelationError::ForgedHypothesis);
    }
    let square_sum = residual
        .iter()
        .map(|&value| u64::from(value.unsigned_abs()).pow(2))
        .sum::<u64>();
    if square_sum & 1 != 0 {
        return Err(CyclicResidualRelationError::ForgedHypothesis);
    }
    Ok(Q29Mod18LevelProof {
        source_commitment: source_commitment(rows),
        coefficients: hypothesis.coefficients,
        level: square_sum / 2,
        exact_score_y: 324 * square_sum,
        prime_fields_tested: hypothesis.prime_fields_tested,
        origin: hypothesis.origin,
        provenance: Q29RelationProvenance::EvolvedThenStructurallyReplayed,
        _pad: [0; 16],
    })
}

pub fn replay_q29_mod18_level_proof(
    rows: &[[i8; 29]; 4],
    proof: &Q29Mod18LevelProof,
) -> Result<(), CyclicResidualRelationError> {
    if proof.source_commitment != source_commitment(rows) {
        return Err(CyclicResidualRelationError::SourceBindingMismatch);
    }
    let hypothesis = CyclicResidualRelationHypothesis {
        coefficients: proof.coefficients,
        prime_fields_tested: proof.prime_fields_tested,
        orbit_rows: Q29_RELATION_ORBIT as u16,
        origin: proof.origin,
        blindness_level: 0,
        _pad: [0; 3],
    };
    let replayed = prove_q29_mod18_level_relation(rows, hypothesis)?;
    if replayed.level != proof.level
        || replayed.exact_score_y != proof.exact_score_y
        || proof.provenance != Q29RelationProvenance::EvolvedThenStructurallyReplayed
    {
        return Err(CyclicResidualRelationError::ForgedHypothesis);
    }
    Ok(())
}

fn extract_q29_mod18_residual(
    rows: &[[i8; 29]; 4],
) -> Result<[i32; Q29_RELATION_FIELDS], CyclicResidualRelationError> {
    if combined_correlation(rows, 0) != 505 {
        return Err(CyclicResidualRelationError::NotMod18Shell);
    }
    let mut output = [0_i32; Q29_RELATION_FIELDS];
    for shift in 1..=Q29_RELATION_FIELDS {
        let correlation = combined_correlation(rows, shift);
        if (correlation + 18).rem_euclid(18) != 0 {
            return Err(CyclicResidualRelationError::NotMod18Shell);
        }
        output[shift - 1] = (correlation + 18) / 18;
    }
    Ok(output)
}

fn combined_correlation(rows: &[[i8; 29]; 4], shift: usize) -> i32 {
    let mut total = 0_i32;
    for row in rows {
        for point in 0..29 {
            total += i32::from(row[point]) * i32::from(row[(point + shift) % 29]);
        }
    }
    total
}

fn source_commitment(rows: &[[i8; 29]; 4]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(b"ergodis-private/c1016/q29-mod18-residual/v1");
    for row in rows {
        for &value in row {
            hasher.update(value.to_le_bytes());
        }
    }
    hasher.finalize().into()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        allocation_test::tracked_allocations,
        proof_synthesis::evolve_bounded_homogeneous_relations,
        q29_exact_anneal::{q29_mod18_shell_level, retained_mod18_seed_17737406},
    };

    #[test]
    fn blind_unit_orbit_recovers_then_proves_the_level_relation() {
        let rows = retained_mod18_seed_17737406();
        let hypothesis = evolve_q29_mod18_level_relation(&rows, 0).unwrap();
        assert_eq!(hypothesis.coefficients, [1; Q29_RELATION_FIELDS]);
        let proof = prove_q29_mod18_level_relation(&rows, hypothesis).unwrap();
        let known = q29_mod18_shell_level(&rows).unwrap();
        assert_eq!(proof.level, known.level);
        assert_eq!(proof.exact_score_y, known.exact_score_y);
        replay_q29_mod18_level_proof(&rows, &proof).unwrap();
    }

    #[test]
    fn forged_semantics_and_source_binding_fail_closed() {
        let rows = retained_mod18_seed_17737406();
        let hypothesis = evolve_q29_mod18_level_relation(&rows, 1).unwrap();
        let proof = prove_q29_mod18_level_relation(&rows, hypothesis).unwrap();
        let mut forged_hypothesis = hypothesis;
        forged_hypothesis.coefficients[3] = 0;
        assert_eq!(
            prove_q29_mod18_level_relation(&rows, forged_hypothesis),
            Err(CyclicResidualRelationError::ForgedHypothesis)
        );
        let mut forged_rows = rows;
        forged_rows[0].swap(0, 1);
        assert_eq!(
            replay_q29_mod18_level_proof(&forged_rows, &proof),
            Err(CyclicResidualRelationError::SourceBindingMismatch)
        );
    }

    #[test]
    fn relation_search_hot_loop_allocates_nothing() {
        let rows = retained_mod18_seed_17737406();
        let base = extract_q29_mod18_residual(&rows).unwrap();
        let permutations = q29_unit_action_permutations();
        let (result, allocations) =
            tracked_allocations(|| mine_permutation_orbit_relation(base, &permutations, 0));
        assert_eq!(allocations, 0);
        assert_eq!(result.unwrap().coefficients, [1; Q29_RELATION_FIELDS]);
    }

    #[test]
    fn modular_miner_matches_exhaustive_q29_orbit_oracle() {
        let rows = retained_mod18_seed_17737406();
        let base = extract_q29_mod18_residual(&rows).unwrap();
        let permutations = q29_unit_action_permutations();
        let observations: [[i32; Q29_RELATION_FIELDS]; Q29_RELATION_ORBIT] =
            std::array::from_fn(|orbit| {
                std::array::from_fn(|field| base[usize::from(permutations[orbit][field])])
            });
        let mut exhaustive = [[0_i8; Q29_RELATION_FIELDS]; 8];
        let (_, found) =
            evolve_bounded_homogeneous_relations(&observations, 1, &mut exhaustive).unwrap();
        assert!(exhaustive[..found].contains(&[1; Q29_RELATION_FIELDS]));
        assert_eq!(
            mine_permutation_orbit_relation(base, &permutations, 0)
                .unwrap()
                .coefficients,
            [1; Q29_RELATION_FIELDS]
        );
    }

    #[test]
    fn malformed_action_is_rejected_before_evolution() {
        let mut permutations = q29_unit_action_permutations();
        permutations[4][3] = permutations[4][2];
        assert_eq!(
            mine_permutation_orbit_relation([0; Q29_RELATION_FIELDS], &permutations, 0),
            Err(CyclicResidualRelationError::InvalidPermutation)
        );
    }
}
