//! Exact quadratic-character sums over odd prime fields.
//!
//! The residue table uses one bit per field element. Polynomial coefficients
//! are reduced once; the census loop then allocates nothing.
//!
//! ```
//! use ergodis::PrimeQuadraticCharacter;
//!
//! let character = PrimeQuadraticCharacter::new(5)?;
//! let coefficients = character.reduce_coefficients(&[1, 0, 1]); // 1 + x^2
//! let census = character.polynomial_census_reduced(&coefficients)?;
//! assert_eq!((census.positive(), census.negative(), census.zero()), (1, 2, 2));
//! assert_eq!(census.sum(), -1);
//! # Ok::<(), ergodis::CharacterSumError>(())
//! ```

use std::ops::Range;

use thiserror::Error;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum CharacterSumError {
    #[error("modulus is not an odd prime")]
    NotOddPrime,
    #[error("census range is outside the prime field")]
    InvalidRange,
    #[error("a reduced coefficient or linear factor is outside the prime field")]
    UnreducedInput,
    #[error("character-census counts overflow u32")]
    CountOverflow,
    #[error("the zero polynomial has no squarefree degree profile")]
    ZeroPolynomial,
}

/// Degree metadata for a nonzero polynomial over the prime field.
#[repr(C)]
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub struct PolynomialDegeneracy {
    degree: u32,
    repeated_factor_degree: u32,
}

impl PolynomialDegeneracy {
    #[must_use]
    pub fn degree(self) -> u32 {
        self.degree
    }

    #[must_use]
    pub fn repeated_factor_degree(self) -> u32 {
        self.repeated_factor_degree
    }

    #[must_use]
    pub fn is_squarefree(self) -> bool {
        self.repeated_factor_degree == 0
    }
}

const _: () = assert!(
    std::mem::size_of::<PolynomialDegeneracy>() == 8
        && std::mem::align_of::<PolynomialDegeneracy>() == 4
);

/// Counts witnessing an exact quadratic-character sum.
#[repr(C)]
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub struct CharacterCensus {
    positive: u32,
    negative: u32,
    zero: u32,
    _reserved: u32,
}

impl CharacterCensus {
    #[must_use]
    pub fn positive(self) -> u32 {
        self.positive
    }

    #[must_use]
    pub fn negative(self) -> u32 {
        self.negative
    }

    #[must_use]
    pub fn zero(self) -> u32 {
        self.zero
    }

    #[must_use]
    pub fn total(self) -> u32 {
        self.positive + self.negative + self.zero
    }

    #[must_use]
    pub fn sum(self) -> i64 {
        i64::from(self.positive) - i64::from(self.negative)
    }

    /// Combine disjoint range censuses without losing their witnesses.
    pub fn checked_merge(self, other: Self) -> Result<Self, CharacterSumError> {
        let positive = self
            .positive
            .checked_add(other.positive)
            .ok_or(CharacterSumError::CountOverflow)?;
        let negative = self
            .negative
            .checked_add(other.negative)
            .ok_or(CharacterSumError::CountOverflow)?;
        let zero = self
            .zero
            .checked_add(other.zero)
            .ok_or(CharacterSumError::CountOverflow)?;
        positive
            .checked_add(negative)
            .and_then(|subtotal| subtotal.checked_add(zero))
            .ok_or(CharacterSumError::CountOverflow)?;
        Ok(Self {
            positive,
            negative,
            zero,
            _reserved: 0,
        })
    }
}

const _: () = assert!(
    std::mem::size_of::<CharacterCensus>() == 16 && std::mem::align_of::<CharacterCensus>() == 4
);

/// Reusable quadratic-character lookup for one odd prime field.
#[repr(C)]
#[derive(Clone, Debug)]
pub struct PrimeQuadraticCharacter {
    square_bits: Box<[u64]>,
    modulus: u32,
    _reserved32: u32,
    _reserved64: u64,
}

#[cfg(target_pointer_width = "64")]
const _: () = assert!(
    std::mem::size_of::<PrimeQuadraticCharacter>() == 32
        && std::mem::align_of::<PrimeQuadraticCharacter>() == 8
);

impl PrimeQuadraticCharacter {
    pub fn new(modulus: u32) -> Result<Self, CharacterSumError> {
        if !is_odd_prime(modulus) {
            return Err(CharacterSumError::NotOddPrime);
        }
        let width = usize::try_from(modulus).expect("u32 modulus does not fit usize");
        let mut square_bits = vec![0_u64; width.div_ceil(64)].into_boxed_slice();
        let modulus64 = u64::from(modulus);
        for root in 1..=modulus / 2 {
            let root64 = u64::from(root);
            let square = usize::try_from((root64 * root64) % modulus64).unwrap();
            square_bits[square / 64] |= 1_u64 << (square % 64);
        }
        Ok(Self {
            square_bits,
            modulus,
            _reserved32: 0,
            _reserved64: 0,
        })
    }

    #[must_use]
    pub fn modulus(&self) -> u32 {
        self.modulus
    }

    /// Return the Legendre character in `{-1, 0, 1}` for any integer value.
    #[must_use]
    pub fn character_i128(&self, value: i128) -> i8 {
        let reduced = value.rem_euclid(i128::from(self.modulus)) as u32;
        self.character_reduced(reduced)
    }

    /// Reduce ascending integer polynomial coefficients once, outside a census.
    #[must_use]
    pub fn reduce_coefficients(&self, coefficients: &[i128]) -> Box<[u32]> {
        coefficients
            .iter()
            .map(|&value| value.rem_euclid(i128::from(self.modulus)) as u32)
            .collect::<Vec<_>>()
            .into_boxed_slice()
    }

    /// Census `chi(f(x))` on the entire field for ascending reduced coefficients.
    pub fn polynomial_census_reduced(
        &self,
        coefficients: &[u32],
    ) -> Result<CharacterCensus, CharacterSumError> {
        self.polynomial_census_range_reduced(0..self.modulus, coefficients)
    }

    /// Census `chi(f(x))` on a field subrange, suitable for parallel splitting.
    pub fn polynomial_census_range_reduced(
        &self,
        range: Range<u32>,
        coefficients: &[u32],
    ) -> Result<CharacterCensus, CharacterSumError> {
        self.validate_reduced_inputs(&range, coefficients, &[])?;
        Ok(self.polynomial_census_kernel::<false>(range, coefficients, 0, 0))
    }

    /// Census `chi((intercept + slope*x) f(x))` without materializing a product.
    pub fn linear_twist_polynomial_census_reduced(
        &self,
        range: Range<u32>,
        coefficients: &[u32],
        intercept: u32,
        slope: u32,
    ) -> Result<CharacterCensus, CharacterSumError> {
        self.validate_reduced_inputs(&range, coefficients, &[intercept, slope])?;
        Ok(self.polynomial_census_kernel::<true>(range, coefficients, intercept, slope))
    }

    /// Census the character of a product of reduced polynomials.
    ///
    /// Factors are evaluated independently and multiplied modulo the field;
    /// the product polynomial is never materialized and the census allocates
    /// nothing. An empty factor list denotes the constant polynomial one.
    pub fn product_polynomial_census_range_reduced(
        &self,
        range: Range<u32>,
        factors: &[&[u32]],
    ) -> Result<CharacterCensus, CharacterSumError> {
        self.validate_reduced_inputs(&range, &[], &[])?;
        if factors
            .iter()
            .flat_map(|factor| factor.iter())
            .any(|&value| value >= self.modulus)
        {
            return Err(CharacterSumError::UnreducedInput);
        }
        let modulus = u64::from(self.modulus);
        let mut census = CharacterCensus::default();
        for x in range {
            let x64 = u64::from(x);
            let mut product = 1_u64;
            for factor in factors {
                let mut value = 0_u64;
                for &coefficient in factor.iter().rev() {
                    value = (value * x64 + u64::from(coefficient)) % modulus;
                }
                product = product * value % modulus;
            }
            self.tally_reduced(product as u32, &mut census);
        }
        Ok(census)
    }

    /// Compute exact repeated-factor metadata via `gcd(f, f')`.
    ///
    /// This is a cold algebraic preflight and may allocate. It lets callers
    /// detect bad primes before applying a squarefree character-sum bound.
    pub fn polynomial_degeneracy_reduced(
        &self,
        coefficients: &[u32],
    ) -> Result<PolynomialDegeneracy, CharacterSumError> {
        if coefficients.iter().any(|&value| value >= self.modulus) {
            return Err(CharacterSumError::UnreducedInput);
        }
        let polynomial = trimmed(coefficients.to_vec());
        if polynomial.is_empty() {
            return Err(CharacterSumError::ZeroPolynomial);
        }
        let degree = polynomial.len() - 1;
        if degree == 0 {
            return Ok(PolynomialDegeneracy {
                degree: 0,
                repeated_factor_degree: 0,
            });
        }
        let modulus64 = u64::from(self.modulus);
        let derivative = trimmed(
            polynomial
                .iter()
                .enumerate()
                .skip(1)
                .map(|(power, &coefficient)| {
                    (u64::from(coefficient) * (power as u64 % modulus64) % modulus64) as u32
                })
                .collect(),
        );
        let repeated_factor_degree = if derivative.is_empty() {
            degree
        } else {
            polynomial_gcd_degree(polynomial, derivative, self.modulus)
        };
        Ok(PolynomialDegeneracy {
            degree: u32::try_from(degree).map_err(|_| CharacterSumError::CountOverflow)?,
            repeated_factor_degree: u32::try_from(repeated_factor_degree)
                .map_err(|_| CharacterSumError::CountOverflow)?,
        })
    }

    fn validate_reduced_inputs(
        &self,
        range: &Range<u32>,
        coefficients: &[u32],
        extra: &[u32],
    ) -> Result<(), CharacterSumError> {
        if range.start > range.end || range.end > self.modulus {
            return Err(CharacterSumError::InvalidRange);
        }
        if coefficients
            .iter()
            .chain(extra)
            .any(|&value| value >= self.modulus)
        {
            return Err(CharacterSumError::UnreducedInput);
        }
        Ok(())
    }

    fn polynomial_census_kernel<const LINEAR_TWIST: bool>(
        &self,
        range: Range<u32>,
        coefficients: &[u32],
        intercept: u32,
        slope: u32,
    ) -> CharacterCensus {
        let modulus = u64::from(self.modulus);
        let mut census = CharacterCensus::default();
        for x in range {
            let x64 = u64::from(x);
            let mut value = 0_u64;
            for &coefficient in coefficients.iter().rev() {
                value = (value * x64 + u64::from(coefficient)) % modulus;
            }
            if LINEAR_TWIST {
                let factor = (u64::from(intercept) + u64::from(slope) * x64) % modulus;
                value = value * factor % modulus;
            }
            self.tally_reduced(value as u32, &mut census);
        }
        census
    }

    #[inline]
    fn character_reduced(&self, value: u32) -> i8 {
        if value == 0 {
            return 0;
        }
        let index = value as usize;
        if self.square_bits[index / 64] & (1_u64 << (index % 64)) != 0 {
            1
        } else {
            -1
        }
    }

    #[inline]
    fn tally_reduced(&self, value: u32, census: &mut CharacterCensus) {
        if value == 0 {
            census.zero += 1;
            return;
        }
        let index = value as usize;
        if self.square_bits[index / 64] & (1_u64 << (index % 64)) != 0 {
            census.positive += 1;
        } else {
            census.negative += 1;
        }
    }
}

fn trimmed(mut polynomial: Vec<u32>) -> Vec<u32> {
    while polynomial.last() == Some(&0) {
        polynomial.pop();
    }
    polynomial
}

fn polynomial_gcd_degree(mut left: Vec<u32>, mut right: Vec<u32>, modulus: u32) -> usize {
    let modulus64 = u64::from(modulus);
    while !right.is_empty() {
        let inverse = pow_mod(*right.last().unwrap(), modulus - 2, modulus);
        while left.len() >= right.len() {
            let shift = left.len() - right.len();
            let factor = u64::from(*left.last().unwrap()) * u64::from(inverse) % modulus64;
            for (index, &coefficient) in right.iter().enumerate() {
                let product = factor * u64::from(coefficient) % modulus64;
                let slot = &mut left[shift + index];
                *slot = ((u64::from(*slot) + modulus64 - product) % modulus64) as u32;
            }
            left = trimmed(left);
        }
        left = std::mem::replace(&mut right, left);
    }
    left.len().saturating_sub(1)
}

fn pow_mod(base: u32, mut exponent: u32, modulus: u32) -> u32 {
    let modulus64 = u64::from(modulus);
    let mut base = u64::from(base);
    let mut result = 1_u64;
    while exponent != 0 {
        if exponent & 1 != 0 {
            result = result * base % modulus64;
        }
        base = base * base % modulus64;
        exponent >>= 1;
    }
    result as u32
}

fn is_odd_prime(value: u32) -> bool {
    if value < 3 || value.is_multiple_of(2) {
        return false;
    }
    let mut divisor = 3;
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

    fn pow_mod(mut base: u64, mut exponent: u32, modulus: u64) -> u64 {
        let mut result = 1;
        while exponent != 0 {
            if exponent & 1 != 0 {
                result = result * base % modulus;
            }
            base = base * base % modulus;
            exponent >>= 1;
        }
        result
    }

    #[test]
    fn product_twist_matches_materialized_product() {
        let character = PrimeQuadraticCharacter::new(101).unwrap();
        let left = [3, 2, 1];
        let right = [5, 0, 4];
        let product = [15, 10, 17, 8, 4];
        let direct = character
            .product_polynomial_census_range_reduced(0..101, &[&left, &right])
            .unwrap();
        assert_eq!(
            direct,
            character.polynomial_census_reduced(&product).unwrap()
        );
    }

    #[test]
    fn reports_squarefree_and_repeated_factors() {
        let character = PrimeQuadraticCharacter::new(101).unwrap();
        let squarefree = character.polynomial_degeneracy_reduced(&[1, 0, 1]).unwrap();
        assert_eq!(
            (squarefree.degree(), squarefree.repeated_factor_degree()),
            (2, 0)
        );
        let repeated = character.polynomial_degeneracy_reduced(&[1, 2, 1]).unwrap();
        assert_eq!(
            (repeated.degree(), repeated.repeated_factor_degree()),
            (2, 1)
        );
    }

    fn assert_descent_fixture(
        modulus: u32,
        phi: &[i128],
        descended: &[i128],
        expected: (i64, i64, i64),
    ) {
        let character = PrimeQuadraticCharacter::new(modulus).unwrap();
        let phi = character.reduce_coefficients(phi);
        let descended = character.reduce_coefficients(descended);
        let slope = character.reduce_coefficients(&[-4])[0];
        let s = character.polynomial_census_reduced(&phi).unwrap().sum();
        let s1 = character
            .polynomial_census_reduced(&descended)
            .unwrap()
            .sum();
        let s2 = character
            .linear_twist_polynomial_census_reduced(0..character.modulus(), &descended, 1, slope)
            .unwrap()
            .sum();
        assert_eq!((s, s1, s2), expected);
        assert_eq!(s, s1 + s2);
    }

    #[test]
    fn rejects_non_odd_primes() {
        for modulus in [0, 1, 2, 4, 9, 15, 25] {
            assert_eq!(
                PrimeQuadraticCharacter::new(modulus).unwrap_err(),
                CharacterSumError::NotOddPrime
            );
        }
    }

    #[test]
    fn residue_map_matches_euler_criterion() {
        for modulus in [3, 5, 7, 11, 97] {
            let character = PrimeQuadraticCharacter::new(modulus).unwrap();
            for value in 0..modulus {
                let expected = if value == 0 {
                    0
                } else if pow_mod(u64::from(value), (modulus - 1) / 2, u64::from(modulus)) == 1 {
                    1
                } else {
                    -1
                };
                assert_eq!(character.character_i128(i128::from(value)), expected);
            }
            assert_eq!(
                character.character_i128(-1),
                if modulus % 4 == 1 { 1 } else { -1 }
            );
        }
    }

    #[test]
    fn polynomial_census_is_witnessed_and_range_composable() {
        let character = PrimeQuadraticCharacter::new(5).unwrap();
        let coefficients = character.reduce_coefficients(&[1, 0, 1]);
        let full = character.polynomial_census_reduced(&coefficients).unwrap();
        assert_eq!((full.positive(), full.negative(), full.zero()), (1, 2, 2));
        assert_eq!(full.sum(), -1);
        let left = character
            .polynomial_census_range_reduced(0..2, &coefficients)
            .unwrap();
        let right = character
            .polynomial_census_range_reduced(2..5, &coefficients)
            .unwrap();
        assert_eq!(left.checked_merge(right).unwrap(), full);
    }

    #[test]
    fn descent_character_sums_match_independent_integer_oracle() {
        let phi3 = [36, -108, 213, -246, 213, -108, 36];
        let descended3 = [36, -108, 105, -36];
        assert_descent_fixture(5, &phi3, &descended3, (2, -1, 3));
        assert_descent_fixture(7, &phi3, &descended3, (7, 4, 3));
        assert_descent_fixture(11, &phi3, &descended3, (-1, 0, -1));
        assert_descent_fixture(
            7,
            &[
                64, -320, 976, -1984, 3008, -3424, 3008, -1984, 976, -320, 64,
            ],
            &[64, -320, 656, -672, 336, -64],
            (2, -2, 4),
        );
        assert_descent_fixture(
            11,
            &[
                100, -700, 2925, -8450, 18515, -31800, 43765, -48610, 43765, -31800, 18515, -8450,
                2925, -700, 100,
            ],
            &[100, -700, 2225, -4000, 4290, -2640, 825, -100],
            (-7, -6, -1),
        );
    }

    #[test]
    fn invalid_reduced_inputs_fail_closed() {
        let character = PrimeQuadraticCharacter::new(7).unwrap();
        assert_eq!(
            character.polynomial_census_range_reduced(0..8, &[1]),
            Err(CharacterSumError::InvalidRange)
        );
        assert_eq!(
            character.polynomial_census_reduced(&[7]),
            Err(CharacterSumError::UnreducedInput)
        );
    }
}
