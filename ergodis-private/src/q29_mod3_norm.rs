//! Typed q29 group-ring congruence for unrestricted order-2092 discovery.
//!
//! For canonical integer rows `Y_i` the exact q29 shell is
//! `sum_i Y_i Y_i^* = 523 delta_0 - 18 J`.  Reduction modulo three gives
//! `sum_i Y_i Y_i^* = delta_0` in `F_3[C_29]`.  Since `ord_29(3)=28` and
//! `3^14=-1 (mod 29)`, the nontrivial factor is `F_{3^28}` and `*` is its
//! Hermitian involution `z -> z^(3^14)`, with fixed field `F_{3^14}`.
//!
//! Modulo nine the same integral identity still has right side `delta_0`.
//! The mod-nine gate below is a stronger exact necessary predicate.  Its
//! Galois-ring count is structural: residue solutions form a four-variable
//! Hermitian unit sphere, and every residue solution has the same number of
//! lifts because one nonzero coordinate makes the linearized trace equation
//! surjective.

use sha2::{Digest, Sha256};

use crate::{
    proof_synthesis::{ExtractorDescriptor, ProvenanceClass},
    q29_inventory_scope::{extract_q29_inventories, Q29InventoryError, Q29_ROW_LENGTH},
};

const BLOCKS: usize = 4;
const INDEPENDENT_SHIFTS: usize = 15;
const EXTRACTOR_ID: [u8; 16] = *b"c1016-q29m3n0001";
const EXTRACTOR_VERSION: u16 = 1;
const PARAMETER_DIGEST: [u8; 32] = [
    0x9a, 0x2f, 0xae, 0xbf, 0xdc, 0x93, 0x9b, 0x3b, 0xed, 0x14, 0x4e, 0xf8, 0xbc, 0xe2, 0x81, 0x08,
    0x8a, 0x8f, 0x23, 0x86, 0x11, 0xee, 0xfd, 0xdf, 0xe3, 0xf8, 0x27, 0x0f, 0xe4, 0x2c, 0x63, 0x99,
];
const SOURCE_COMMITMENT: [u8; 32] = [
    0xb2, 0x5c, 0x33, 0xb7, 0x9c, 0x31, 0x5f, 0xc6, 0xa7, 0x96, 0x7f, 0x3b, 0xf0, 0xb3, 0x09, 0x47,
    0x5c, 0xb4, 0x5c, 0x84, 0xba, 0x04, 0x12, 0xec, 0x1f, 0x1a, 0xb4, 0x0a, 0x40, 0x8b, 0xf8, 0xef,
];

pub const Q29_MOD3_PROVENANCE: ProvenanceClass = ProvenanceClass::ProvedStructural;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29Mod3Error {
    Inventory(Q29InventoryError),
    NonCanonicalResidue,
}

impl From<Q29InventoryError> for Q29Mod3Error {
    fn from(value: Q29InventoryError) -> Self {
        Self::Inventory(value)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29Mod3Factorization {
    pub multiplicative_order: u8,
    pub nontrivial_degree: u8,
    pub involution_frobenius_power: u8,
    pub fixed_field_degree: u8,
    pub fixed_field_order: u32,
}

const _: () = assert!(core::mem::size_of::<Q29Mod3Factorization>() == 8);

/// Exact symbolic cardinalities for the nontrivial mod-nine component.
///
/// Put `q=3^14`.  The residue Hermitian sphere has `q^7-q^3` points and each
/// point has `q^7` lifts, hence the mod-nine shell has `q^14-q^10` points in
/// an ambient space of size `q^16`.  Exponents are stored instead of expanded
/// integers because the latter intentionally exceed `u128`.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29Mod9ShellStructure {
    pub residue_fixed_field_order: u32,
    pub residue_solution_high_exponent: u8,
    pub residue_solution_low_exponent: u8,
    pub lifts_per_residue_exponent: u8,
    pub solution_high_exponent: u8,
    pub solution_low_exponent: u8,
    pub ambient_exponent: u8,
    pub reduction_numerator_exponent: u8,
    pub reduction_denominator_high_exponent: u8,
    pub reduction_denominator_low_exponent: u8,
    pub provenance: ProvenanceClass,
}

/// The exact structural mod-nine count, in factored powers of `q=3^14`.
#[must_use]
pub const fn q29_mod9_shell_structure() -> Q29Mod9ShellStructure {
    Q29Mod9ShellStructure {
        residue_fixed_field_order: 4_782_969,
        residue_solution_high_exponent: 7,
        residue_solution_low_exponent: 3,
        lifts_per_residue_exponent: 7,
        solution_high_exponent: 14,
        solution_low_exponent: 10,
        ambient_exponent: 16,
        // ambient / shell = q^6 / (q^4-1).
        reduction_numerator_exponent: 6,
        reduction_denominator_high_exponent: 4,
        reduction_denominator_low_exponent: 0,
        provenance: ProvenanceClass::ProvedStructural,
    }
}

/// Additional information removed by the mod-nine lift after mod three.
/// This is `log2(3^14)`; it is reporting metadata, not proof authority.
#[must_use]
pub fn mod9_lift_reduction_bits() -> f64 {
    14.0 * 3.0_f64.log2()
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29ModularCorrelation {
    mod3: [u8; INDEPENDENT_SHIFTS],
    mod9: [u8; INDEPENDENT_SHIFTS],
    accepts_mod3: u8,
    accepts_mod9: u8,
    _pad: [u8; 32],
}

const _: () = assert!(core::mem::size_of::<Q29ModularCorrelation>() == 64);
const _: () = assert!(core::mem::align_of::<Q29ModularCorrelation>() == 64);

impl Q29ModularCorrelation {
    #[must_use]
    pub const fn accepts_mod3(self) -> bool {
        self.accepts_mod3 != 0
    }

    #[must_use]
    pub const fn accepts_mod9(self) -> bool {
        self.accepts_mod9 != 0
    }

    #[must_use]
    pub const fn mod3_residues(self) -> [u8; INDEPENDENT_SHIFTS] {
        self.mod3
    }

    #[must_use]
    pub const fn mod9_residues(self) -> [u8; INDEPENDENT_SHIFTS] {
        self.mod9
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29Mod3Proof {
    descriptor: ExtractorDescriptor,
    source_data_commitment: [u8; 32],
    correlations: Q29ModularCorrelation,
    provenance: ProvenanceClass,
}

#[must_use]
pub const fn q29_mod3_factorization() -> Q29Mod3Factorization {
    Q29Mod3Factorization {
        multiplicative_order: 28,
        nontrivial_degree: 28,
        involution_frobenius_power: 14,
        fixed_field_degree: 14,
        fixed_field_order: 4_782_969,
    }
}

/// Exact ambient-field reduction factor for four unrestricted nontrivial
/// components with fixed augmentations.
///
/// If `q=3^14`, the Hermitian norm equation has `q^7-q^3` solutions among
/// `q^8` four-tuples.  Thus reduction is exactly `q^5/(q^4-1)`.  Both terms
/// fit in `u128`.
#[must_use]
pub const fn ambient_mod3_reduction_ratio() -> (u128, u128) {
    let q = 4_782_969_u128;
    (q.pow(5), q.pow(4) - 1)
}

/// Project a length-29 group-ring element to its nontrivial mod-nine factor.
///
/// In `(Z/9)[T]/(T^29-1)`, quotienting by
/// `Phi_29=1+T+...+T^28` sends the row to the 28 coefficients
/// `row[j]-row[28]`.  This is the bounded algebra interface used by a future
/// residue-first shell generator.
#[must_use]
pub fn nontrivial_component_mod9(row: &[i8; Q29_ROW_LENGTH]) -> [u8; 28] {
    let mut component = [0_u8; 28];
    let tail = i32::from(row[28]);
    for index in 0..28 {
        component[index] = (i32::from(row[index]) - tail).rem_euclid(9) as u8;
    }
    component
}

/// Invert [`nontrivial_component_mod9`] at a prescribed augmentation modulo
/// nine.  The returned entries are canonical residues in `0..=8`.
#[must_use]
pub fn row_residues_from_nontrivial_component_mod9(
    component: &[u8; 28],
    augmentation: u8,
) -> Result<[u8; Q29_ROW_LENGTH], Q29Mod3Error> {
    if augmentation >= 9 || component.iter().any(|&coefficient| coefficient >= 9) {
        return Err(Q29Mod3Error::NonCanonicalResidue);
    }
    let mut sum = 0_u32;
    for &coefficient in component {
        sum += u32::from(coefficient);
    }
    // sum(row) = sum(component) + 29*tail, and 29^-1 = 5 (mod 9).
    let tail = (5 * (i32::from(augmentation) - sum as i32)).rem_euclid(9) as u8;
    let mut row = [tail; Q29_ROW_LENGTH];
    for index in 0..28 {
        row[index] = (u16::from(component[index]) + u16::from(tail)).rem_euclid(9) as u8;
    }
    Ok(row)
}

#[must_use]
pub const fn q29_mod3_descriptor() -> ExtractorDescriptor {
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        PARAMETER_DIGEST,
        SOURCE_COMMITMENT,
    )
}

/// Allocation-free typed extraction from canonical q29 integer rows.
pub fn extract_q29_modular_correlation(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
) -> Result<Q29ModularCorrelation, Q29Mod3Error> {
    extract_q29_inventories(rows)?;
    let mod9 = cyclic_correlations::<9>(rows);
    let mut mod3 = [0_u8; INDEPENDENT_SHIFTS];
    for shift in 0..INDEPENDENT_SHIFTS {
        mod3[shift] = mod9[shift] % 3;
    }
    Ok(Q29ModularCorrelation {
        mod3,
        mod9,
        accepts_mod3: u8::from(is_delta(&mod3)),
        accepts_mod9: u8::from(is_delta(&mod9)),
        _pad: [0; 32],
    })
}

pub fn derive_q29_mod3_proof(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
) -> Result<Q29Mod3Proof, Q29Mod3Error> {
    Ok(Q29Mod3Proof {
        descriptor: q29_mod3_descriptor(),
        source_data_commitment: source_data_commitment(rows),
        correlations: extract_q29_modular_correlation(rows)?,
        provenance: Q29_MOD3_PROVENANCE,
    })
}

/// Recompute canonical semantics and the source-data commitment.  Neither a
/// supplied field name nor serialized residues can authorize pruning.
#[must_use]
pub fn replay_q29_mod3_proof(rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS], proof: &Q29Mod3Proof) -> bool {
    proof.descriptor == q29_mod3_descriptor()
        && proof.provenance == ProvenanceClass::ProvedStructural
        && proof.source_data_commitment == source_data_commitment(rows)
        && extract_q29_modular_correlation(rows)
            .is_ok_and(|correlations| correlations == proof.correlations)
}

#[inline(always)]
fn cyclic_correlations<const MODULUS: i32>(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
) -> [u8; INDEPENDENT_SHIFTS] {
    let mut output = [0_u8; INDEPENDENT_SHIFTS];
    for shift in 0..INDEPENDENT_SHIFTS {
        let mut correlation = 0_i32;
        for row in rows {
            for point in 0..Q29_ROW_LENGTH {
                correlation +=
                    i32::from(row[point]) * i32::from(row[(point + shift) % Q29_ROW_LENGTH]);
            }
        }
        output[shift] = correlation.rem_euclid(MODULUS) as u8;
    }
    output
}

#[inline(always)]
fn is_delta(residues: &[u8; INDEPENDENT_SHIFTS]) -> bool {
    residues[0] == 1 && residues[1..].iter().all(|&residue| residue == 0)
}

fn source_data_commitment(rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS]) -> [u8; 32] {
    let mut digest = Sha256::new();
    digest.update(EXTRACTOR_ID);
    digest.update(EXTRACTOR_VERSION.to_le_bytes());
    for row in rows {
        for &value in row {
            digest.update([value as u8]);
        }
    }
    digest.finalize().into()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        allocation_test::tracked_allocations,
        q29_inventory_scope::{
            census_q29_inventory_scopes, sample_q29_outer_profile_seed, Q29InventoryWorkspace,
            Q29OuterProfilePolicy,
        },
    };

    fn sample(seed: u64) -> [[i8; Q29_ROW_LENGTH]; BLOCKS] {
        let mut workspace = Q29InventoryWorkspace::new();
        census_q29_inventory_scopes(&mut workspace).unwrap();
        let mut random = seed;
        sample_q29_outer_profile_seed(
            &mut workspace,
            &mut random,
            Q29OuterProfilePolicy::UniformScope,
        )
        .unwrap()
        .rows
    }

    fn independent_correlation(
        rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
        shift: usize,
        modulus: i32,
    ) -> u8 {
        let mut product = [0_i32; Q29_ROW_LENGTH];
        for row in rows {
            for left in 0..Q29_ROW_LENGTH {
                for right in 0..Q29_ROW_LENGTH {
                    product[(left + Q29_ROW_LENGTH - right) % Q29_ROW_LENGTH] +=
                        i32::from(row[left]) * i32::from(row[right]);
                }
            }
        }
        product[shift].rem_euclid(modulus) as u8
    }

    #[test]
    fn factorization_order_and_involution_are_exact() {
        let mut value = 1_u32;
        let mut order = 0_u8;
        loop {
            order += 1;
            value = value * 3 % 29;
            if value == 1 {
                break;
            }
        }
        assert_eq!(order, 28);
        assert_eq!(3_u32.pow(14) % 29, 28);
        assert_eq!(q29_mod3_factorization().fixed_field_order, 3_u32.pow(14));
        let mod9 = q29_mod9_shell_structure();
        assert_eq!(mod9.residue_fixed_field_order, 3_u32.pow(14));
        assert_eq!(mod9.solution_high_exponent, 14);
        assert_eq!(mod9.solution_low_exponent, 10);
        assert_eq!(mod9.ambient_exponent, 16);
        assert_eq!(mod9.provenance, ProvenanceClass::ProvedStructural);
    }

    #[test]
    fn nontrivial_component_crt_round_trips_independently() {
        let mut component = [0_u8; 28];
        for (index, value) in component.iter_mut().enumerate() {
            *value = ((5 * index + 7) % 9) as u8;
        }
        for augmentation in 0..9 {
            let row =
                row_residues_from_nontrivial_component_mod9(&component, augmentation).unwrap();
            let direct_sum = row.iter().fold(0_u32, |sum, &value| sum + u32::from(value));
            assert_eq!(direct_sum % 9, u32::from(augmentation));
            for index in 0..28 {
                assert_eq!(
                    (i32::from(row[index]) - i32::from(row[28])).rem_euclid(9),
                    i32::from(component[index])
                );
            }
        }
    }

    #[test]
    fn typed_extractor_matches_independent_group_ring_product() {
        let rows = sample(0x1234_5678_9abc_def0);
        let extracted = extract_q29_modular_correlation(&rows).unwrap();
        for shift in 0..INDEPENDENT_SHIFTS {
            assert_eq!(
                extracted.mod3[shift],
                independent_correlation(&rows, shift, 3)
            );
            assert_eq!(
                extracted.mod9[shift],
                independent_correlation(&rows, shift, 9)
            );
        }
    }

    #[test]
    fn proof_replay_is_bound_to_source_rows() {
        let rows = sample(0xfedc_ba98_7654_3210);
        let proof = derive_q29_mod3_proof(&rows).unwrap();
        assert!(replay_q29_mod3_proof(&rows, &proof));
        let mut changed = rows;
        let unequal = (1..Q29_ROW_LENGTH)
            .find(|&index| changed[0][index] != changed[0][0])
            .expect("a positive-energy row is nonconstant");
        changed[0].swap(0, unequal);
        assert!(!replay_q29_mod3_proof(&changed, &proof));
    }

    #[test]
    fn malformed_canonical_rows_fail_closed() {
        let rows = sample(0x8c03_6d21_2f65_9a47);

        let mut out_of_range = rows;
        out_of_range[0][0] = 10;
        assert_eq!(
            extract_q29_modular_correlation(&out_of_range),
            Err(Q29Mod3Error::Inventory(
                Q29InventoryError::CoefficientOutOfRange
            ))
        );

        let mut wrong_sum = rows;
        wrong_sum[0][0] += if wrong_sum[0][0] < 9 { 1 } else { -1 };
        assert!(matches!(
            extract_q29_modular_correlation(&wrong_sum),
            Err(Q29Mod3Error::Inventory(
                Q29InventoryError::WrongRowSum | Q29InventoryError::WrongCombinedEnergy
            ))
        ));

        let mut noncanonical_component = [0_u8; 28];
        noncanonical_component[7] = 9;
        assert_eq!(
            row_residues_from_nontrivial_component_mod9(&noncanonical_component, 0),
            Err(Q29Mod3Error::NonCanonicalResidue)
        );
        assert_eq!(
            row_residues_from_nontrivial_component_mod9(&[0; 28], 9),
            Err(Q29Mod3Error::NonCanonicalResidue)
        );
    }

    #[test]
    fn modular_kernel_allocates_nothing() {
        let rows = sample(0x55aa_33cc_77ee_11ff);
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..1_000 {
                let _ = extract_q29_modular_correlation(&rows).unwrap();
            }
        });
        assert_eq!(allocations, 0);
    }
}
