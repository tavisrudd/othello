//! Allocation-free 2-adic lifting for cyclic autocorrelation.
//!
//! If `c = a + 2^k x`, with every coordinate of `x` binary, then
//!
//! `A_s(c) = A_s(a) + 2^k sum_i(a_i x_{i+s} + x_i a_{i+s}) (mod 2^(k+1))`.
//!
//! Indeed, the omitted term is `2^(2k) A_s(x)`, which is divisible by
//! `2^(k+1)` for `k >= 1`.  Thus every one-bit lift is an affine map over
//! `F_2`; no search tree or certificate transcript is needed to replay it.

use thiserror::Error;

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum TwoAdicAutocorrelationError {
    #[error("the lift exponent must lie in 1..=15")]
    InvalidExponent,
    #[error("a base coefficient is not reduced modulo 2^k")]
    BaseOutOfRange,
    #[error("a lift coordinate is not binary")]
    NonBinaryLift,
    #[error("the cyclic carrier must be nonempty")]
    EmptyCarrier,
    #[error("the orbit-class count must lie in 1..=64")]
    InvalidClassCount,
    #[error("an orbit class or shift is outside the canonical carrier")]
    InvalidOrbitSemantics,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BinaryOrbitQuadraticForm {
    pub class_count: u8,
    pub diagonal: u64,
    /// Row `i` stores coefficients of `x_i x_j`; only bits `j > i` are used.
    pub mixed_upper: [u64; 64],
}

impl BinaryOrbitQuadraticForm {
    pub fn is_zero(&self) -> bool {
        self.diagonal == 0 && self.mixed_upper.iter().all(|&row| row == 0)
    }

    pub fn evaluate(&self, class_bits: u64) -> u8 {
        let mut value = ((self.diagonal & class_bits).count_ones() & 1) as u8;
        let mut first_bits = class_bits;
        while first_bits != 0 {
            let first = first_bits.trailing_zeros() as usize;
            first_bits &= first_bits - 1;
            value ^= ((self.mixed_upper[first] & class_bits).count_ones() & 1) as u8;
        }
        value
    }
}

/// Prove that a weighted binary autocorrelation expression vanishes for every
/// coefficient vector constant on the supplied orbit classes.
///
/// The expression is quadratic over `F_2`.  It is therefore identically zero
/// exactly when it vanishes on every basis vector and every sum of two basis
/// vectors.  This checks that structural criterion directly, using canonical
/// point-to-class semantics rather than observations or a truth-table
/// certificate.  The fixed loops allocate nothing and do not recurse.
pub fn prove_binary_orbit_autocorrelation_invariant<
    const N: usize,
    const CLASSES: usize,
    const SHIFTS: usize,
>(
    point_classes: &[u8; N],
    shifts: &[u16; SHIFTS],
    weights: &[u8; SHIFTS],
) -> Result<bool, TwoAdicAutocorrelationError> {
    Ok(
        synthesize_binary_orbit_autocorrelation_form::<N, CLASSES, SHIFTS>(
            point_classes,
            shifts,
            weights,
        )?
        .is_zero(),
    )
}

/// Synthesize the exact quadratic form behind a weighted binary orbit
/// autocorrelation observation.  The output is at most 520 bytes regardless
/// of the search domain and is independently replayable from canonical orbit
/// semantics.
pub fn synthesize_binary_orbit_autocorrelation_form<
    const N: usize,
    const CLASSES: usize,
    const SHIFTS: usize,
>(
    point_classes: &[u8; N],
    shifts: &[u16; SHIFTS],
    weights: &[u8; SHIFTS],
) -> Result<BinaryOrbitQuadraticForm, TwoAdicAutocorrelationError> {
    if N == 0 {
        return Err(TwoAdicAutocorrelationError::EmptyCarrier);
    }
    if CLASSES == 0 || CLASSES > 64 {
        return Err(TwoAdicAutocorrelationError::InvalidClassCount);
    }
    if point_classes
        .iter()
        .any(|&class| usize::from(class) >= CLASSES)
        || shifts.iter().any(|&shift| usize::from(shift) >= N)
    {
        return Err(TwoAdicAutocorrelationError::InvalidOrbitSemantics);
    }

    let mut form = BinaryOrbitQuadraticForm {
        class_count: CLASSES as u8,
        diagonal: 0,
        mixed_upper: [0; 64],
    };
    for first in 0..CLASSES {
        let first_value = binary_orbit_quadratic(point_classes, shifts, weights, 1_u64 << first);
        form.diagonal |= u64::from(first_value) << first;
        for second in first + 1..CLASSES {
            let input = (1_u64 << first) | (1_u64 << second);
            let mixed = binary_orbit_quadratic(point_classes, shifts, weights, input)
                ^ first_value
                ^ binary_orbit_quadratic(point_classes, shifts, weights, 1_u64 << second);
            form.mixed_upper[first] |= u64::from(mixed) << second;
        }
    }
    Ok(form)
}

fn binary_orbit_quadratic<const N: usize, const SHIFTS: usize>(
    point_classes: &[u8; N],
    shifts: &[u16; SHIFTS],
    weights: &[u8; SHIFTS],
    class_bits: u64,
) -> u8 {
    let mut value = 0_u8;
    for shift_index in 0..SHIFTS {
        if weights[shift_index] & 1 == 0 {
            continue;
        }
        let shift = usize::from(shifts[shift_index]);
        for point in 0..N {
            let left = (class_bits >> point_classes[point]) as u8 & 1;
            let right = (class_bits >> point_classes[(point + shift) % N]) as u8 & 1;
            value ^= left & right;
        }
    }
    value
}

/// Evaluate the theorem-derived autocorrelation lift without allocation.
///
/// The returned value is reduced modulo `2^(k+1)`.  `base` and `lift` are
/// canonical semantic inputs, not trusted derived feature columns.
pub fn lift_autocorrelation<const N: usize>(
    base: &[u16; N],
    lift: &[u8; N],
    shift: usize,
    exponent: u8,
) -> Result<u16, TwoAdicAutocorrelationError> {
    if N == 0 {
        return Err(TwoAdicAutocorrelationError::EmptyCarrier);
    }
    if !(1..=15).contains(&exponent) {
        return Err(TwoAdicAutocorrelationError::InvalidExponent);
    }
    let half_modulus = 1_u16 << exponent;
    let modulus = u32::from(half_modulus) << 1;
    let mut base_correlation = 0_u64;
    let mut cross_parity = 0_u8;
    let shift = shift % N;
    for index in 0..N {
        let other = (index + shift) % N;
        let left = base[index];
        let right = base[other];
        let left_lift = lift[index];
        let right_lift = lift[other];
        if left >= half_modulus || right >= half_modulus {
            return Err(TwoAdicAutocorrelationError::BaseOutOfRange);
        }
        if left_lift > 1 || right_lift > 1 {
            return Err(TwoAdicAutocorrelationError::NonBinaryLift);
        }
        base_correlation += u64::from(left) * u64::from(right);
        cross_parity ^= ((left as u8 & right_lift) ^ (left_lift & right as u8)) & 1;
    }
    let lifted = base_correlation + u64::from(half_modulus) * u64::from(cross_parity);
    Ok((lifted % u64::from(modulus)) as u16)
}

/// Return the total cyclic autocorrelation modulo `2^k` from the row sum.
/// This is the structural identity
/// `sum_s A_s(c) = (sum_i c_i)^2`, obtained by reindexing the double sum.
pub fn autocorrelation_total_from_row_sum(
    row_sum: u64,
    exponent: u8,
) -> Result<u16, TwoAdicAutocorrelationError> {
    if !(1..=15).contains(&exponent) {
        return Err(TwoAdicAutocorrelationError::InvalidExponent);
    }
    let mask = (1_u128 << exponent) - 1;
    Ok((u128::from(row_sum).pow(2) & mask) as u16)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn direct<const N: usize>(base: &[u16; N], lift: &[u8; N], shift: usize, k: u8) -> u16 {
        let high = 1_u32 << k;
        let modulus = high << 1;
        let sum = (0..N).fold(0_u64, |sum, index| {
            let left = u32::from(base[index]) + high * u32::from(lift[index]);
            let other = (index + shift) % N;
            let right = u32::from(base[other]) + high * u32::from(lift[other]);
            sum + u64::from(left) * u64::from(right)
        });
        (sum % u64::from(modulus)) as u16
    }

    #[test]
    fn exhaustive_small_carriers_match_direct_autocorrelation() {
        for exponent in 1..=4 {
            let radix = 1_u32 << exponent;
            for packed_base in 0..radix.pow(3) {
                let mut value = packed_base;
                let mut base = [0_u16; 3];
                for digit in &mut base {
                    *digit = (value % radix) as u16;
                    value /= radix;
                }
                for packed_lift in 0_u8..8 {
                    let lift = [
                        packed_lift & 1,
                        (packed_lift >> 1) & 1,
                        (packed_lift >> 2) & 1,
                    ];
                    for shift in 0..3 {
                        assert_eq!(
                            lift_autocorrelation(&base, &lift, shift, exponent).unwrap(),
                            direct(&base, &lift, shift, exponent)
                        );
                    }
                }
            }
        }
    }

    #[test]
    fn malformed_semantic_inputs_fail_closed() {
        assert_eq!(
            lift_autocorrelation(&[2_u16], &[0], 0, 1),
            Err(TwoAdicAutocorrelationError::BaseOutOfRange)
        );
        assert_eq!(
            lift_autocorrelation(&[0_u16], &[2], 0, 1),
            Err(TwoAdicAutocorrelationError::NonBinaryLift)
        );
        assert_eq!(
            lift_autocorrelation(&[0_u16], &[0], 0, 0),
            Err(TwoAdicAutocorrelationError::InvalidExponent)
        );
    }

    #[test]
    fn row_sum_identity_matches_independent_full_correlation_sum() {
        for exponent in 1..=6 {
            let mask = (1_u64 << exponent) - 1;
            for packed in 0_u32..4096 {
                let coefficients = [
                    u64::from(packed & 15),
                    u64::from((packed >> 4) & 15),
                    u64::from((packed >> 8) & 15),
                ];
                let direct = (0..3).fold(0_u64, |total, shift| {
                    total
                        + (0..3).fold(0_u64, |sum, point| {
                            sum + coefficients[point] * coefficients[(point + shift) % 3]
                        })
                }) & mask;
                assert_eq!(
                    autocorrelation_total_from_row_sum(coefficients.iter().sum(), exponent)
                        .unwrap(),
                    direct as u16
                );
            }
        }
    }

    fn direct_binary_quadratic<const N: usize, const SHIFTS: usize>(
        point_classes: &[u8; N],
        shifts: &[u16; SHIFTS],
        weights: &[u8; SHIFTS],
        class_bits: u64,
    ) -> u8 {
        let coefficients =
            std::array::from_fn::<_, N, _>(|point| (class_bits >> point_classes[point]) as u8 & 1);
        shifts
            .iter()
            .zip(weights)
            .fold(0_u8, |value, (&shift, &weight)| {
                let correlation = (0..N).fold(0_u8, |sum, point| {
                    sum ^ (coefficients[point] & coefficients[(point + usize::from(shift)) % N])
                });
                value ^ (correlation & weight)
            })
    }

    #[test]
    fn quadratic_basis_proof_matches_exhaustive_oracle() {
        let classes = [0_u8, 1, 2, 1, 2, 1, 2];
        for encoded_shifts in 0_u16..343 {
            let mut value = encoded_shifts;
            let shifts = std::array::from_fn(|_| {
                let shift = value % 7;
                value /= 7;
                shift
            });
            for packed_weights in 0_u8..8 {
                let weights = std::array::from_fn(|index| (packed_weights >> index) & 1);
                let proved = prove_binary_orbit_autocorrelation_invariant::<7, 3, 3>(
                    &classes, &shifts, &weights,
                )
                .unwrap();
                let exhaustive = (0_u64..8)
                    .all(|input| direct_binary_quadratic(&classes, &shifts, &weights, input) == 0);
                assert_eq!(proved, exhaustive);
                let form = synthesize_binary_orbit_autocorrelation_form::<7, 3, 3>(
                    &classes, &shifts, &weights,
                )
                .unwrap();
                for input in 0_u64..8 {
                    assert_eq!(
                        form.evaluate(input),
                        direct_binary_quadratic(&classes, &shifts, &weights, input)
                    );
                }
            }
        }
    }

    #[test]
    fn malformed_orbit_semantics_fail_closed() {
        assert_eq!(
            prove_binary_orbit_autocorrelation_invariant::<3, 2, 1>(&[0, 1, 2], &[1], &[1]),
            Err(TwoAdicAutocorrelationError::InvalidOrbitSemantics)
        );
        assert_eq!(
            prove_binary_orbit_autocorrelation_invariant::<3, 2, 1>(&[0, 1, 0], &[3], &[1]),
            Err(TwoAdicAutocorrelationError::InvalidOrbitSemantics)
        );
    }

    #[test]
    fn quadratic_synthesis_and_replay_allocate_nothing() {
        let classes = [0_u8, 1, 2, 1, 2, 1, 2];
        let shifts = [1_u16, 2, 3];
        let weights = [1_u8, 1, 1];
        let (_, allocations) = tracked_allocations(|| {
            for input in 0_u64..1_024 {
                let form = synthesize_binary_orbit_autocorrelation_form::<7, 3, 3>(
                    &classes, &shifts, &weights,
                )
                .unwrap();
                std::hint::black_box(form.evaluate(input & 7));
            }
        });
        assert_eq!(allocations, 0);
    }
}
