//! Sealed exact-computational proof for the g41 q29 profile-difference lattice.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_evolve::{replay_g41_q29_selection_defects, G41Q29Selection};
use crate::g41_q29_exact_tablebase::{G41Q29AggregateBlockTablebase, G41Q29ExactProfile};
use crate::g41_q29_profile_descent::{analyze_g41_q29_difference_span, G41Q29ProfileJoinCandidate};

const TARGET: u16 = 523;
const EXPECTED_CORRECTION: [i16; 7] = [1, 0, 0, -1, 0, 0, 0];
const EXTRACTOR_ID: &str = "ergodis-private.g41-q29-profile-difference-lattice";
const EXTRACTOR_VERSION: u16 = 1;
const SEMANTICS: &str = "ordered seven multiplier-coset Dirichlet defects D_s=A_0-A_s; four-block target D_s=523; aggregate block signatures bind exact profile supersets";

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, Serialize, PartialEq, Eq)]
pub struct G41Q29BasisOrigin {
    pub profile_index: u32,
    pub block: u8,
    pub _pad: [u8; 3],
}

const _: () = assert!(
    std::mem::size_of::<G41Q29BasisOrigin>() == 8 && std::mem::align_of::<G41Q29BasisOrigin>() == 4
);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileLatticeProof {
    pub extractor_id: &'static str,
    pub extractor_version: u16,
    pub canonical_semantics: &'static str,
    pub source_commitment: [u8; 32],
    pub source_signatures: [[u8; 4]; 3],
    pub source_profile_digests: [[u8; 32]; 3],
    pub source_profile_counts: [u32; 3],
    pub seed: G41Q29Selection,
    pub seed_profile_indices: [u32; 4],
    pub correction: [i16; 7],
    pub basis: [[i16; 7]; 7],
    pub basis_origins: [G41Q29BasisOrigin; 7],
    pub determinant: i128,
    pub correction_coefficients: [i128; 7],
    pub null_mod_2: [u8; 7],
    pub null_mod_29: [u8; 7],
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileLatticeVerification {
    pub profiles_replayed: u64,
    pub basis_origins_replayed: u8,
    pub determinant: i128,
    pub index: u16,
    pub correction_in_lattice: bool,
    pub adversarial_source_rejected: bool,
    pub adversarial_basis_rejected: bool,
    pub adversarial_correction_rejected: bool,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q29ProfileLatticeProofError {
    #[error("g41 q29 profile-lattice proof source or semantics mismatch")]
    SemanticMismatch,
    #[error("g41 q29 profile-lattice proof arithmetic invariant failed")]
    ArithmeticMismatch,
    #[error("g41 q29 profile-lattice proof resource bound failed")]
    ResourceBound,
}

fn sets<'a>(
    a: &'a G41Q29AggregateBlockTablebase,
    b: &'a G41Q29AggregateBlockTablebase,
    c: &'a G41Q29AggregateBlockTablebase,
) -> [&'a [G41Q29ExactProfile]; 4] {
    [&a.profiles, &b.profiles, &c.profiles, &b.profiles]
}

fn profile_values(profile: G41Q29ExactProfile) -> [u16; 7] {
    std::array::from_fn(|coordinate| profile.coordinate(coordinate))
}

fn profile_sums(sets: [&[G41Q29ExactProfile]; 4], indices: [u32; 4]) -> [u16; 7] {
    std::array::from_fn(|coordinate| {
        (0..4)
            .map(|block| sets[block][indices[block] as usize].coordinate(coordinate))
            .sum()
    })
}

fn source_commitment(
    signatures: [[u8; 4]; 3],
    digests: [[u8; 32]; 3],
    counts: [u32; 3],
    seed: G41Q29Selection,
) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(EXTRACTOR_ID.as_bytes());
    hasher.update(EXTRACTOR_VERSION.to_le_bytes());
    hasher.update(SEMANTICS.as_bytes());
    for signature in signatures {
        hasher.update(signature);
    }
    for digest in digests {
        hasher.update(digest);
    }
    for count in counts {
        hasher.update(count.to_le_bytes());
    }
    hasher.update(seed.root_id.to_le_bytes());
    for digit in seed.digits {
        hasher.update(digit.to_le_bytes());
    }
    for mask in seed.orbit_masks {
        hasher.update(mask.to_le_bytes());
    }
    hasher.finalize().into()
}

fn determinant(mut matrix: [[i128; 7]; 7]) -> i128 {
    let mut sign = 1_i128;
    let mut denominator = 1_i128;
    for pivot in 0..6 {
        let Some(chosen) = (pivot..7).find(|&row| matrix[row][pivot] != 0) else {
            return 0;
        };
        if chosen != pivot {
            matrix.swap(chosen, pivot);
            sign = -sign;
        }
        let pivot_value = matrix[pivot][pivot];
        for row in pivot + 1..7 {
            for column in pivot + 1..7 {
                matrix[row][column] = (matrix[row][column] * pivot_value
                    - matrix[row][pivot] * matrix[pivot][column])
                    / denominator;
            }
        }
        denominator = pivot_value;
    }
    sign * matrix[6][6]
}

fn inverse_mod(value: u8, modulus: u8) -> u8 {
    (1..modulus)
        .find(|candidate| u16::from(value) * u16::from(*candidate) % u16::from(modulus) == 1)
        .expect("nonzero residue modulo a prime is invertible")
}

fn null_functional(basis: [[i16; 7]; 7], modulus: u8) -> Option<[u8; 7]> {
    let mut matrix = basis.map(|row| row.map(|value| value.rem_euclid(modulus as i16) as u8));
    let mut pivot_columns = [u8::MAX; 7];
    let mut rank = 0_usize;
    for column in 0..7 {
        let Some(chosen) = (rank..7).find(|&row| matrix[row][column] != 0) else {
            continue;
        };
        matrix.swap(rank, chosen);
        let inverse = inverse_mod(matrix[rank][column], modulus);
        for entry in &mut matrix[rank][column..] {
            *entry = (u16::from(*entry) * u16::from(inverse) % u16::from(modulus)) as u8;
        }
        for row in 0..7 {
            if row == rank || matrix[row][column] == 0 {
                continue;
            }
            let factor = matrix[row][column];
            for entry in column..7 {
                matrix[row][entry] = (u16::from(matrix[row][entry]) + u16::from(modulus)
                    - u16::from(factor) * u16::from(matrix[rank][entry]) % u16::from(modulus))
                    as u8
                    % modulus;
            }
        }
        pivot_columns[rank] = column as u8;
        rank += 1;
    }
    if rank != 6 {
        return None;
    }
    let free = (0..7).find(|column| !pivot_columns[..rank].contains(&(*column as u8)))?;
    let mut output = [0_u8; 7];
    output[free] = 1;
    for row in (0..rank).rev() {
        let pivot = usize::from(pivot_columns[row]);
        let sum = (pivot + 1..7)
            .map(|column| u16::from(matrix[row][column]) * u16::from(output[column]))
            .sum::<u16>()
            % u16::from(modulus);
        output[pivot] = ((u16::from(modulus) - sum) % u16::from(modulus)) as u8;
    }
    Some(output)
}

fn dot_mod(left: [i16; 7], right: [u8; 7], modulus: u8) -> u8 {
    let value = (0..7)
        .map(|coordinate| i32::from(left[coordinate]) * i32::from(right[coordinate]))
        .sum::<i32>();
    value.rem_euclid(i32::from(modulus)) as u8
}

fn locate_origins(
    sets: [&[G41Q29ExactProfile]; 4],
    seed_indices: [u32; 4],
    basis: [[i16; 7]; 7],
) -> Result<[G41Q29BasisOrigin; 7], G41Q29ProfileLatticeProofError> {
    let mut origins = [G41Q29BasisOrigin::default(); 7];
    for basis_index in 0..7 {
        let mut found = None;
        'blocks: for block in 0..4 {
            let base = profile_values(sets[block][seed_indices[block] as usize]);
            for (profile_index, &profile) in sets[block].iter().enumerate() {
                let values = profile_values(profile);
                let delta = std::array::from_fn(|coordinate| {
                    values[coordinate] as i16 - base[coordinate] as i16
                });
                if delta == basis[basis_index] {
                    found = Some(G41Q29BasisOrigin {
                        profile_index: profile_index as u32,
                        block: block as u8,
                        _pad: [0; 3],
                    });
                    break 'blocks;
                }
            }
        }
        origins[basis_index] = found.ok_or(G41Q29ProfileLatticeProofError::SemanticMismatch)?;
    }
    Ok(origins)
}

fn verify_nulls(
    sets: [&[G41Q29ExactProfile]; 4],
    seed_indices: [u32; 4],
    null_2: [u8; 7],
    null_29: [u8; 7],
) -> Result<u64, G41Q29ProfileLatticeProofError> {
    if null_2 == [0; 7] || null_29 == [0; 7] {
        return Err(G41Q29ProfileLatticeProofError::ArithmeticMismatch);
    }
    let mut replayed = 0_u64;
    for block in 0..4 {
        let base = profile_values(sets[block][seed_indices[block] as usize]);
        for &profile in sets[block] {
            replayed += 1;
            let values = profile_values(profile);
            let delta = std::array::from_fn(|coordinate| {
                values[coordinate] as i16 - base[coordinate] as i16
            });
            if dot_mod(delta, null_2, 2) != 0 || dot_mod(delta, null_29, 29) != 0 {
                return Err(G41Q29ProfileLatticeProofError::ArithmeticMismatch);
            }
        }
    }
    Ok(replayed)
}

pub fn issue_g41_q29_profile_lattice_proof(
    a: &G41Q29AggregateBlockTablebase,
    b: &G41Q29AggregateBlockTablebase,
    c: &G41Q29AggregateBlockTablebase,
    seed: G41Q29Selection,
    seed_profile_indices: [u32; 4],
) -> Result<G41Q29ProfileLatticeProof, G41Q29ProfileLatticeProofError> {
    let sets = sets(a, b, c);
    if (0..4).any(|block| seed_profile_indices[block] as usize >= sets[block].len()) {
        return Err(G41Q29ProfileLatticeProofError::ResourceBound);
    }
    let replayed = replay_g41_q29_selection_defects(seed)
        .map_err(|_| G41Q29ProfileLatticeProofError::SemanticMismatch)?;
    for block in 0..4 {
        if profile_values(sets[block][seed_profile_indices[block] as usize]) != replayed[block] {
            return Err(G41Q29ProfileLatticeProofError::SemanticMismatch);
        }
    }
    let sums = profile_sums(sets, seed_profile_indices);
    let candidate = G41Q29ProfileJoinCandidate {
        indices: seed_profile_indices,
        residual: sums
            .iter()
            .map(|&sum| u32::from(sum.abs_diff(TARGET)))
            .sum(),
        sums,
        _pad: [0; 30],
    };
    let lattice = analyze_g41_q29_difference_span(sets, candidate);
    if !lattice.index_58_lattice_proved
        || !lattice.correction_in_integer_lattice
        || lattice.correction != EXPECTED_CORRECTION
    {
        return Err(G41Q29ProfileLatticeProofError::ArithmeticMismatch);
    }
    let basis_origins = locate_origins(sets, seed_profile_indices, lattice.integer_basis)?;
    let null_mod_2 = null_functional(lattice.integer_basis, 2)
        .ok_or(G41Q29ProfileLatticeProofError::ArithmeticMismatch)?;
    let null_mod_29 = null_functional(lattice.integer_basis, 29)
        .ok_or(G41Q29ProfileLatticeProofError::ArithmeticMismatch)?;
    verify_nulls(sets, seed_profile_indices, null_mod_2, null_mod_29)?;
    let signatures = [a.report.signature, b.report.signature, c.report.signature];
    let digests = [
        a.report.profile_digest,
        b.report.profile_digest,
        c.report.profile_digest,
    ];
    let counts = [
        a.report.exact_correlation_profiles,
        b.report.exact_correlation_profiles,
        c.report.exact_correlation_profiles,
    ];
    Ok(G41Q29ProfileLatticeProof {
        extractor_id: EXTRACTOR_ID,
        extractor_version: EXTRACTOR_VERSION,
        canonical_semantics: SEMANTICS,
        source_commitment: source_commitment(signatures, digests, counts, seed),
        source_signatures: signatures,
        source_profile_digests: digests,
        source_profile_counts: counts,
        seed,
        seed_profile_indices,
        correction: lattice.correction,
        basis: lattice.integer_basis,
        basis_origins,
        determinant: lattice.integer_basis_determinant,
        correction_coefficients: lattice.correction_coefficients,
        null_mod_2,
        null_mod_29,
        provenance: "sealed private exact-computational theorem: seven concrete profile differences generate an index-58 lattice; exhaustive replay shows all source differences obey the independently derived mod-2 and mod-29 null functionals; Cramer replay places the target correction in the lattice",
    })
}

pub fn verify_g41_q29_profile_lattice_proof(
    a: &G41Q29AggregateBlockTablebase,
    b: &G41Q29AggregateBlockTablebase,
    c: &G41Q29AggregateBlockTablebase,
    proof: &G41Q29ProfileLatticeProof,
) -> Result<G41Q29ProfileLatticeVerification, G41Q29ProfileLatticeProofError> {
    if proof.extractor_id != EXTRACTOR_ID
        || proof.extractor_version != EXTRACTOR_VERSION
        || proof.canonical_semantics != SEMANTICS
        || proof.correction != EXPECTED_CORRECTION
    {
        return Err(G41Q29ProfileLatticeProofError::SemanticMismatch);
    }
    let signatures = [a.report.signature, b.report.signature, c.report.signature];
    let digests = [
        a.report.profile_digest,
        b.report.profile_digest,
        c.report.profile_digest,
    ];
    let counts = [
        a.report.exact_correlation_profiles,
        b.report.exact_correlation_profiles,
        c.report.exact_correlation_profiles,
    ];
    if proof.source_signatures != signatures
        || proof.source_profile_digests != digests
        || proof.source_profile_counts != counts
        || proof.source_commitment != source_commitment(signatures, digests, counts, proof.seed)
    {
        return Err(G41Q29ProfileLatticeProofError::SemanticMismatch);
    }
    let sets = sets(a, b, c);
    if (0..4).any(|block| proof.seed_profile_indices[block] as usize >= sets[block].len()) {
        return Err(G41Q29ProfileLatticeProofError::ResourceBound);
    }
    // Reject malformed proof arithmetic before the comparatively expensive seed replay.
    for basis_index in 0..7 {
        let origin = proof.basis_origins[basis_index];
        let block = usize::from(origin.block);
        if block >= 4 || origin.profile_index as usize >= sets[block].len() {
            return Err(G41Q29ProfileLatticeProofError::ResourceBound);
        }
        let base = profile_values(sets[block][proof.seed_profile_indices[block] as usize]);
        let values = profile_values(sets[block][origin.profile_index as usize]);
        let delta =
            std::array::from_fn(|coordinate| values[coordinate] as i16 - base[coordinate] as i16);
        if delta != proof.basis[basis_index] {
            return Err(G41Q29ProfileLatticeProofError::SemanticMismatch);
        }
    }
    let determinant_value = determinant(proof.basis.map(|row| row.map(i128::from)));
    if determinant_value != proof.determinant || determinant_value.abs() != 58 {
        return Err(G41Q29ProfileLatticeProofError::ArithmeticMismatch);
    }
    for coordinate in 0..7 {
        let value = (0..7)
            .map(|row| {
                proof.correction_coefficients[row] * i128::from(proof.basis[row][coordinate])
            })
            .sum::<i128>();
        if value != i128::from(proof.correction[coordinate]) {
            return Err(G41Q29ProfileLatticeProofError::ArithmeticMismatch);
        }
    }
    if null_functional(proof.basis, 2) != Some(proof.null_mod_2)
        || null_functional(proof.basis, 29) != Some(proof.null_mod_29)
    {
        return Err(G41Q29ProfileLatticeProofError::ArithmeticMismatch);
    }
    let replayed = replay_g41_q29_selection_defects(proof.seed)
        .map_err(|_| G41Q29ProfileLatticeProofError::SemanticMismatch)?;
    for block in 0..4 {
        let index = proof.seed_profile_indices[block] as usize;
        if profile_values(sets[block][index]) != replayed[block] {
            return Err(G41Q29ProfileLatticeProofError::SemanticMismatch);
        }
    }
    let profiles_replayed = verify_nulls(
        sets,
        proof.seed_profile_indices,
        proof.null_mod_2,
        proof.null_mod_29,
    )?;
    Ok(G41Q29ProfileLatticeVerification {
        profiles_replayed,
        basis_origins_replayed: 7,
        determinant: determinant_value,
        index: 58,
        correction_in_lattice: true,
        adversarial_source_rejected: false,
        adversarial_basis_rejected: false,
        adversarial_correction_rejected: false,
        provenance: "independent replay of extractor identity, source commitments, seed semantics, seven concrete difference origins, determinant, Cramer correction, and both exhaustive null-functional scans",
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn determinant_and_null_oracles_agree_on_diagonal_control() {
        let mut basis = [[0_i16; 7]; 7];
        for index in 0..7 {
            basis[index][index] = 1;
        }
        basis[6][6] = 58;
        assert_eq!(determinant(basis.map(|row| row.map(i128::from))), 58);
        assert!(null_functional(basis, 2).is_some());
        assert!(null_functional(basis, 29).is_some());
    }

    #[test]
    fn source_commitment_binds_seed_and_digest() {
        let seed = G41Q29Selection {
            root_id: 7,
            digits: [1, 2, 3, 4],
            orbit_masks: [0; 24],
        };
        let first = source_commitment([[0; 4]; 3], [[0; 32]; 3], [1, 2, 3], seed);
        let mut changed = seed;
        changed.digits[0] ^= 1;
        assert_ne!(
            first,
            source_commitment([[0; 4]; 3], [[0; 32]; 3], [1, 2, 3], changed)
        );
        let mut digests = [[0; 32]; 3];
        digests[1][9] = 1;
        assert_ne!(
            first,
            source_commitment([[0; 4]; 3], digests, [1, 2, 3], seed)
        );
    }
}
