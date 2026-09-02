//! Exact parity quotient for the unrestricted length-29 compressed shell.
//!
//! If `x` is an even compressed row, write `y=x/2` and let `D` be the
//! support of the odd coefficients of `y`.  Reducing periodic
//! autocorrelation modulo two gives
//!
//! `PAF_y(s) = |D intersect (D-s)| (mod 2)`.
//!
//! Hence four q29 rows with combined PAF `(505,-18,...,-18)` necessarily
//! satisfy `sum D_i D_i^* = 1` in `F_2[C_29]`.  The kernel below evaluates
//! that identity directly; no finite-field representation is trusted for
//! proof authority.

pub const Q29_ORDER: usize = 29;
pub const Q29_PARITY_COORDINATES: usize = 15;
pub const Q29_PARITY_KEYS: usize = 1 << 14;
pub const Q29_WEIGHT_TWO: usize = 406;
pub const Q29_WEIGHT_THREE: usize = 3_654;
pub const Q29_WEIGHT_FOUR: usize = 23_751;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29ParityInputError {
    CoefficientOutOfRange,
    CoefficientNotEven,
    WrongRowSum,
    WrongZeroEnergy,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29ParityCensus {
    pub left_pairs: u64,
    pub right_pairs: u64,
    pub compatible_quartets: u64,
    pub occupied_left_keys: u16,
    pub occupied_right_keys: u16,
    pub provenance: &'static str,
}

#[repr(C, align(64))]
pub struct Q29ParityWorkspace {
    weight_two: [u16; Q29_WEIGHT_TWO],
    weight_three: [u16; Q29_WEIGHT_THREE],
    weight_four: [u16; Q29_WEIGHT_FOUR],
    left_counts: [u64; Q29_PARITY_KEYS],
    right_counts: [u64; Q29_PARITY_KEYS],
}

impl Q29ParityWorkspace {
    pub const ZERO: Self = Self {
        weight_two: [0; Q29_WEIGHT_TWO],
        weight_three: [0; Q29_WEIGHT_THREE],
        weight_four: [0; Q29_WEIGHT_FOUR],
        left_counts: [0; Q29_PARITY_KEYS],
        right_counts: [0; Q29_PARITY_KEYS],
    };
}

/// Direct symmetric cyclic-autocorrelation signature over `F_2`.
///
/// Bit zero is the support cardinality parity.  Bits 1--14 are the parity
/// of the ordered intersections at the corresponding nonzero shift; shifts
/// 15--28 repeat these values by inversion.
#[must_use]
#[inline(always)]
pub fn cyclic_autocorrelation_parity(support: u32) -> u16 {
    let support = support & ((1_u32 << Q29_ORDER) - 1);
    let mut signature = 0_u16;
    for shift in 0..Q29_PARITY_COORDINATES {
        let rotated = if shift == 0 {
            support
        } else {
            ((support << shift) | (support >> (Q29_ORDER - shift))) & ((1_u32 << Q29_ORDER) - 1)
        };
        signature |= ((support & rotated).count_ones() as u16 & 1) << shift;
    }
    signature
}

/// Direct necessary parity theorem for a `(3,4,4,2)` odd-support quartet.
#[must_use]
pub fn q29_support_quartet_satisfies_parity(supports: [u32; 4]) -> bool {
    supports.iter().fold(0_u16, |sum, &support| {
        sum ^ cyclic_autocorrelation_parity(support)
    }) == 1
}

/// Recompute the theorem input from canonical signed q29 coefficients.
///
/// This validates the representation boundary before evaluating the parity
/// consequence.  It deliberately does not accept precomputed feature names
/// or support words as pruning authority.
pub fn q29_even_rows_satisfy_parity(
    rows: &[[i8; Q29_ORDER]; 4],
) -> Result<bool, Q29ParityInputError> {
    let mut supports = [0_u32; 4];
    let mut energy = 0_i32;
    for (block, row) in rows.iter().enumerate() {
        let mut row_sum = 0_i32;
        for (column, &coefficient) in row.iter().enumerate() {
            if !(-18..=18).contains(&coefficient) {
                return Err(Q29ParityInputError::CoefficientOutOfRange);
            }
            if coefficient & 1 != 0 {
                return Err(Q29ParityInputError::CoefficientNotEven);
            }
            row_sum += i32::from(coefficient);
            energy += i32::from(coefficient) * i32::from(coefficient);
            supports[block] |= u32::from(((coefficient / 2) & 1) != 0) << column;
        }
        if row_sum != if block == 0 { 2 } else { 0 } {
            return Err(Q29ParityInputError::WrongRowSum);
        }
    }
    if energy != 2_020 {
        return Err(Q29ParityInputError::WrongZeroEnergy);
    }
    Ok(q29_support_quartet_satisfies_parity(supports))
}

/// Count the complete `(3,4) | (4,2)` support join for the currently retained
/// fixed-magnitude inventory stratum.  This is an exact projection census of
/// that stratum, not of every q29 energy inventory.  It is iterative and
/// performs no allocation after the caller supplies the fixed workspace.
pub fn census_q29_support_quartets(workspace: &mut Q29ParityWorkspace) -> Q29ParityCensus {
    fill_weight_signatures::<Q29_WEIGHT_TWO>(2, &mut workspace.weight_two);
    fill_weight_signatures::<Q29_WEIGHT_THREE>(3, &mut workspace.weight_three);
    fill_weight_signatures::<Q29_WEIGHT_FOUR>(4, &mut workspace.weight_four);
    workspace.left_counts.fill(0);
    workspace.right_counts.fill(0);

    for &three in &workspace.weight_three {
        for &four in &workspace.weight_four {
            let key = usize::from((three ^ four) >> 1);
            workspace.left_counts[key] += 1;
        }
    }
    for &four in &workspace.weight_four {
        for &two in &workspace.weight_two {
            let key = usize::from((four ^ two) >> 1);
            workspace.right_counts[key] += 1;
        }
    }

    let mut compatible_quartets = 0_u64;
    let mut occupied_left_keys = 0_u16;
    let mut occupied_right_keys = 0_u16;
    for key in 0..Q29_PARITY_KEYS {
        occupied_left_keys += u16::from(workspace.left_counts[key] != 0);
        occupied_right_keys += u16::from(workspace.right_counts[key] != 0);
        compatible_quartets += workspace.left_counts[key] * workspace.right_counts[key];
    }
    Q29ParityCensus {
        left_pairs: (Q29_WEIGHT_THREE * Q29_WEIGHT_FOUR) as u64,
        right_pairs: (Q29_WEIGHT_FOUR * Q29_WEIGHT_TWO) as u64,
        compatible_quartets,
        occupied_left_keys,
        occupied_right_keys,
        provenance: "ExactStructural; direct F2 cyclic-autocorrelation replay",
    }
}

fn fill_weight_signatures<const OUTPUT: usize>(weight: u32, output: &mut [u16; OUTPUT]) {
    let limit = 1_u32 << Q29_ORDER;
    let mut word = (1_u32 << weight) - 1;
    let mut cursor = 0_usize;
    while word < limit {
        output[cursor] = cyclic_autocorrelation_parity(word);
        cursor += 1;
        let low = word & word.wrapping_neg();
        let next = word + low;
        word = (((next ^ word) >> 2) / low) | next;
    }
    assert_eq!(cursor, OUTPUT);
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn direct_coordinate(support: u32, shift: usize) -> u16 {
        let mut parity = 0_u16;
        for point in 0..Q29_ORDER {
            let successor = (point + shift) % Q29_ORDER;
            parity ^= (((support >> point) & 1) & ((support >> successor) & 1)) as u16;
        }
        parity
    }

    #[test]
    fn packed_signature_matches_independent_coordinate_loop() {
        let mut state = 0x9e37_79b9_u32;
        for _ in 0..4_096 {
            state ^= state << 7;
            state ^= state >> 9;
            state ^= state << 8;
            let support = state & ((1_u32 << Q29_ORDER) - 1);
            let signature = cyclic_autocorrelation_parity(support);
            for shift in 0..Q29_ORDER {
                let packed_shift = if shift <= 14 {
                    shift
                } else {
                    Q29_ORDER - shift
                };
                assert_eq!(
                    (signature >> packed_shift) & 1,
                    direct_coordinate(support, shift)
                );
            }
        }
    }

    #[test]
    fn quartet_checker_replays_all_twenty_nine_coordinates() {
        let supports = [0b111, 0b1111 << 3, 0b1111 << 7, 0b11 << 12];
        let expected = (0..Q29_ORDER).all(|shift| {
            let parity = supports.iter().fold(0_u16, |sum, &support| {
                sum ^ direct_coordinate(support, shift)
            });
            parity == u16::from(shift == 0)
        });
        assert_eq!(q29_support_quartet_satisfies_parity(supports), expected);
    }

    #[test]
    fn canonical_row_extractor_rejects_malformed_semantics() {
        let mut rows = [[4_i8; Q29_ORDER]; 4];
        // Use the exact retained inventory through the same deterministic
        // construction as the search seed.
        let inventories: [[(usize, i8); 6]; 4] = [
            [(13, 4), (13, -4), (1, 6), (1, -6), (1, 2), (0, -2)],
            [(13, 4), (12, -4), (1, 6), (2, -6), (1, 2), (0, -2)],
            [(13, 4), (12, -4), (1, 6), (2, -6), (1, 2), (0, -2)],
            [(12, 4), (15, -4), (2, 6), (0, -6), (0, 2), (0, -2)],
        ];
        for block in 0..4 {
            let mut cursor = 0;
            for &(count, value) in &inventories[block] {
                for _ in 0..count {
                    rows[block][cursor] = value;
                    cursor += 1;
                }
            }
        }
        assert!(q29_even_rows_satisfy_parity(&rows).is_ok());
        rows[0][0] = 3;
        assert_eq!(
            q29_even_rows_satisfy_parity(&rows),
            Err(Q29ParityInputError::CoefficientNotEven)
        );
        rows[0][0] = 20;
        assert_eq!(
            q29_even_rows_satisfy_parity(&rows),
            Err(Q29ParityInputError::CoefficientOutOfRange)
        );
    }

    #[test]
    fn exact_census_is_allocation_free_and_matches_locked_support_counts() {
        let mut workspace = Box::new(Q29ParityWorkspace::ZERO);
        let (report, allocations) =
            tracked_allocations(|| census_q29_support_quartets(&mut workspace));
        assert_eq!(allocations, 0);
        assert_eq!(report.left_pairs, 86_786_154);
        assert_eq!(report.right_pairs, 9_642_906);
        assert_eq!(report.occupied_left_keys, 6_972);
        assert_eq!(report.occupied_right_keys, 2_884);
        assert_eq!(report.compatible_quartets, 217_396_960_970);
    }

    #[test]
    fn two_is_primitive_modulo_twenty_nine() {
        let mut value = 1_u32;
        let mut first_return = 0;
        for exponent in 1..=28 {
            value = (2 * value) % 29;
            if value == 1 && first_return == 0 {
                first_return = exponent;
            }
        }
        assert_eq!(first_return, 28);
    }
}
