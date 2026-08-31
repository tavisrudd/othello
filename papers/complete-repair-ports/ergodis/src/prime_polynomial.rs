//! Exact polynomial-function reduction and additive recurrence over prime fields.
//!
//! The identity `x^p = x` reduces every polynomial function on `F_p` to
//! degree below `p`. Forward differences then evaluate all field points using
//! modular additions only: no multiplication, division, recursion, or
//! allocation occurs after compilation.

use thiserror::Error;

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum PrimePolynomialError {
    #[error("modulus is not prime")]
    NotPrime,
    #[error("a coefficient is outside the prime field")]
    UnreducedCoefficient,
}

/// Return the canonical degree-below-`p` representative of a polynomial
/// function on `F_p`. Coefficients are ascending and must already be reduced.
pub fn reduce_prime_polynomial_function(
    modulus: u32,
    coefficients: &[u32],
) -> Result<Box<[u32]>, PrimePolynomialError> {
    validate(modulus, coefficients)?;
    if coefficients.is_empty() {
        return Ok(Box::new([]));
    }
    let width = coefficients.len().min(modulus as usize);
    let mut reduced = vec![0_u32; width].into_boxed_slice();
    for (exponent, &coefficient) in coefficients.iter().enumerate() {
        if coefficient == 0 {
            continue;
        }
        let target = if exponent == 0 {
            0
        } else {
            1 + (exponent - 1) % (modulus as usize - 1)
        };
        reduced[target] = add_mod(reduced[target], coefficient, modulus);
    }
    let length = reduced
        .iter()
        .rposition(|&coefficient| coefficient != 0)
        .map_or(0, |degree| degree + 1);
    let mut reduced = Vec::from(reduced);
    reduced.truncate(length);
    Ok(reduced.into_boxed_slice())
}

/// Presized recurrence for enumerating a polynomial function on `F_p`.
#[repr(C)]
#[derive(Clone, Debug)]
pub struct PrimePolynomialRecurrence {
    initial_differences: Box<[u32]>,
    differences: Box<[u32]>,
    modulus: u32,
    position: u32,
}

impl PrimePolynomialRecurrence {
    pub fn compile(modulus: u32, coefficients: &[u32]) -> Result<Self, PrimePolynomialError> {
        let coefficients = reduce_prime_polynomial_function(modulus, coefficients)?;
        let width = coefficients.len().max(1);
        let mut values = vec![0_u32; width];
        for (x, value) in values.iter_mut().enumerate() {
            *value = evaluate_reduced(&coefficients, x as u32, modulus);
        }
        let mut initial_differences = Vec::with_capacity(width);
        for remaining in (1..=width).rev() {
            initial_differences.push(values[0]);
            for index in 0..remaining - 1 {
                values[index] = sub_mod(values[index + 1], values[index], modulus);
            }
        }
        let initial_differences = initial_differences.into_boxed_slice();
        Ok(Self {
            differences: initial_differences.clone(),
            initial_differences,
            modulus,
            position: 0,
        })
    }

    #[must_use]
    pub fn modulus(&self) -> u32 {
        self.modulus
    }

    #[must_use]
    pub fn position(&self) -> u32 {
        self.position
    }

    #[must_use]
    pub fn remaining(&self) -> u32 {
        self.modulus - self.position
    }

    /// Return the next value, advancing with only modular additions.
    pub fn next_value(&mut self) -> Option<u32> {
        if self.position == self.modulus {
            return None;
        }
        let value = self.differences[0];
        for index in 0..self.differences.len() - 1 {
            self.differences[index] = add_mod(
                self.differences[index],
                self.differences[index + 1],
                self.modulus,
            );
        }
        self.position += 1;
        Some(value)
    }

    /// Restore the compiled initial state without allocation.
    pub fn rewind(&mut self) {
        self.differences.copy_from_slice(&self.initial_differences);
        self.position = 0;
    }
}

#[inline]
fn add_mod(left: u32, right: u32, modulus: u32) -> u32 {
    let sum = u64::from(left) + u64::from(right);
    if sum >= u64::from(modulus) {
        (sum - u64::from(modulus)) as u32
    } else {
        sum as u32
    }
}

#[inline]
fn sub_mod(left: u32, right: u32, modulus: u32) -> u32 {
    if left >= right {
        left - right
    } else {
        modulus - (right - left)
    }
}

fn evaluate_reduced(coefficients: &[u32], x: u32, modulus: u32) -> u32 {
    let modulus64 = u64::from(modulus);
    let mut value = 0_u64;
    for &coefficient in coefficients.iter().rev() {
        value = (value * u64::from(x) + u64::from(coefficient)) % modulus64;
    }
    value as u32
}

fn validate(modulus: u32, coefficients: &[u32]) -> Result<(), PrimePolynomialError> {
    if !is_prime(modulus) {
        return Err(PrimePolynomialError::NotPrime);
    }
    if coefficients
        .iter()
        .any(|&coefficient| coefficient >= modulus)
    {
        return Err(PrimePolynomialError::UnreducedCoefficient);
    }
    Ok(())
}

fn is_prime(value: u32) -> bool {
    if value < 2 {
        return false;
    }
    if value.is_multiple_of(2) {
        return value == 2;
    }
    let mut divisor = 3_u32;
    while divisor <= value / divisor {
        if value.is_multiple_of(divisor) {
            return false;
        }
        divisor += 2;
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn reduction_mod_x_p_minus_x_preserves_every_field_value() {
        let modulus = 7;
        let coefficients = [3, 2, 0, 0, 0, 0, 0, 5, 4, 1, 0, 0, 0, 6];
        let reduced = reduce_prime_polynomial_function(modulus, &coefficients).unwrap();
        assert!(reduced.len() <= modulus as usize);
        for x in 0..modulus {
            assert_eq!(
                evaluate_reduced(&coefficients, x, modulus),
                evaluate_reduced(&reduced, x, modulus)
            );
        }
    }

    #[test]
    fn recurrence_matches_horner_and_rewinds_without_recompiling() {
        let modulus = 101;
        let coefficients = [3, 2, 5, 7, 11, 13, 17];
        let mut recurrence = PrimePolynomialRecurrence::compile(modulus, &coefficients).unwrap();
        for x in 0..modulus {
            assert_eq!(
                recurrence.next_value(),
                Some(evaluate_reduced(&coefficients, x, modulus))
            );
        }
        assert_eq!(recurrence.next_value(), None);
        recurrence.rewind();
        assert_eq!(recurrence.position(), 0);
        assert_eq!(recurrence.next_value(), Some(coefficients[0]));
    }

    #[test]
    fn constant_and_zero_functions_have_one_cell_recurrences() {
        for coefficients in [&[][..], &[0][..], &[5][..]] {
            let mut recurrence = PrimePolynomialRecurrence::compile(7, coefficients).unwrap();
            let expected = coefficients.first().copied().unwrap_or(0);
            assert_eq!(recurrence.differences.len(), 1);
            for _ in 0..7 {
                assert_eq!(recurrence.next_value(), Some(expected));
            }
        }
    }
}
