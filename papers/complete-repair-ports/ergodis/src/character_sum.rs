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
    #[error("character order must divide the multiplicative-group order")]
    InvalidCharacterOrder,
    #[error("multiplicative-character class is outside the character order")]
    InvalidCharacterClass,
}

/// Exact coefficients in the basis `1, zeta, ..., zeta^(order-1)`.
///
/// The coefficients deliberately remain unreduced by a cyclotomic polynomial:
/// this makes the result a nonnegative, directly replayable census witness.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RootOfUnityCensus {
    coefficients: Box<[u32]>,
    zero: u32,
}

impl RootOfUnityCensus {
    #[must_use]
    pub fn coefficients(&self) -> &[u32] {
        &self.coefficients
    }

    #[must_use]
    pub fn zero(&self) -> u32 {
        self.zero
    }

    #[must_use]
    pub fn total(&self) -> u64 {
        self.coefficients
            .iter()
            .map(|&count| u64::from(count))
            .sum::<u64>()
            + u64::from(self.zero)
    }
}

/// Exact cyclotomic numbers for one character order, stored row-major.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CyclotomicCensus {
    counts: Box<[u32]>,
    order: u32,
}

impl CyclotomicCensus {
    #[must_use]
    pub fn order(&self) -> u32 {
        self.order
    }

    #[must_use]
    pub fn counts(&self) -> &[u32] {
        &self.counts
    }

    #[must_use]
    pub fn count(&self, left: u32, right: u32) -> Option<u32> {
        if left >= self.order || right >= self.order {
            return None;
        }
        Some(self.counts[(left * self.order + right) as usize])
    }
}

/// A reusable exact multiplicative character of prescribed order over `F_p`.
///
/// Nonzero values store their discrete-log class modulo `order`; zero uses the
/// storage width's maximum-value sentinel. The table is compiled once, so census loops need no
/// exponentiation or hashing. Small character orders use one byte per field
/// element; larger orders widen only as required.
#[derive(Clone, Debug)]
enum CharacterClassTable {
    U8(Box<[u8]>),
    U16(Box<[u16]>),
    U32(Box<[u32]>),
}

impl CharacterClassTable {
    #[inline]
    fn get(&self, value: u32) -> Option<u32> {
        match self {
            Self::U8(classes) => {
                let class = classes[value as usize];
                (class != u8::MAX).then_some(u32::from(class))
            }
            Self::U16(classes) => {
                let class = classes[value as usize];
                (class != u16::MAX).then_some(u32::from(class))
            }
            Self::U32(classes) => {
                let class = classes[value as usize];
                (class != u32::MAX).then_some(class)
            }
        }
    }

    fn bytes(&self) -> usize {
        match self {
            Self::U8(classes) => std::mem::size_of_val(classes.as_ref()),
            Self::U16(classes) => std::mem::size_of_val(classes.as_ref()),
            Self::U32(classes) => std::mem::size_of_val(classes.as_ref()),
        }
    }
}

#[repr(C)]
#[derive(Clone, Debug)]
pub struct PrimeMultiplicativeCharacter {
    class_by_value: CharacterClassTable,
    modulus: u32,
    order: u32,
    generator: u32,
    _reserved: u32,
}

impl PrimeMultiplicativeCharacter {
    pub fn new(modulus: u32, order: u32) -> Result<Self, CharacterSumError> {
        if !is_odd_prime(modulus) {
            return Err(CharacterSumError::NotOddPrime);
        }
        if order == 0 || !(modulus - 1).is_multiple_of(order) {
            return Err(CharacterSumError::InvalidCharacterOrder);
        }
        let generator = primitive_root(modulus);
        let width = usize::try_from(modulus).expect("u32 modulus does not fit usize");
        let class_by_value = if order <= u32::from(u8::MAX) {
            let mut classes = vec![u8::MAX; width].into_boxed_slice();
            fill_character_classes(&mut classes, modulus, order, generator, |value| value as u8);
            CharacterClassTable::U8(classes)
        } else if order <= u32::from(u16::MAX) {
            let mut classes = vec![u16::MAX; width].into_boxed_slice();
            fill_character_classes(&mut classes, modulus, order, generator, |value| {
                value as u16
            });
            CharacterClassTable::U16(classes)
        } else {
            let mut classes = vec![u32::MAX; width].into_boxed_slice();
            fill_character_classes(&mut classes, modulus, order, generator, |value| value);
            CharacterClassTable::U32(classes)
        };
        Ok(Self {
            class_by_value,
            modulus,
            order,
            generator,
            _reserved: 0,
        })
    }

    #[must_use]
    pub fn modulus(&self) -> u32 {
        self.modulus
    }

    #[must_use]
    pub fn order(&self) -> u32 {
        self.order
    }

    #[must_use]
    pub fn generator(&self) -> u32 {
        self.generator
    }

    /// Bytes occupied by the structurally compressed character-class table.
    #[must_use]
    pub fn class_table_bytes(&self) -> usize {
        self.class_by_value.bytes()
    }

    /// Return the root-of-unity exponent, or `None` for zero.
    #[must_use]
    pub fn class_i128(&self, value: i128) -> Option<u32> {
        let reduced = value.rem_euclid(i128::from(self.modulus)) as usize;
        self.class_by_value.get(reduced as u32)
    }

    #[must_use]
    pub fn reduce_coefficients(&self, coefficients: &[i128]) -> Box<[u32]> {
        coefficients
            .iter()
            .map(|&value| value.rem_euclid(i128::from(self.modulus)) as u32)
            .collect::<Vec<_>>()
            .into_boxed_slice()
    }

    /// Census `chi(f(x))` as exact root-of-unity coefficient counts.
    pub fn polynomial_census_reduced(
        &self,
        coefficients: &[u32],
    ) -> Result<RootOfUnityCensus, CharacterSumError> {
        self.polynomial_census_kernel_reduced::<false>(coefficients, 0)
    }

    /// Census `chi(f(x))` only on one multiplicative coset of the input.
    pub fn polynomial_census_on_class_reduced(
        &self,
        input_class: u32,
        coefficients: &[u32],
    ) -> Result<RootOfUnityCensus, CharacterSumError> {
        if input_class >= self.order {
            return Err(CharacterSumError::InvalidCharacterClass);
        }
        self.polynomial_census_kernel_reduced::<true>(coefficients, input_class)
    }

    fn polynomial_census_kernel_reduced<const RESTRICTED: bool>(
        &self,
        coefficients: &[u32],
        input_class: u32,
    ) -> Result<RootOfUnityCensus, CharacterSumError> {
        if coefficients.iter().any(|&value| value >= self.modulus) {
            return Err(CharacterSumError::UnreducedInput);
        }
        let mut census = RootOfUnityCensus {
            coefficients: vec![0; self.order as usize].into_boxed_slice(),
            zero: 0,
        };
        let modulus = u64::from(self.modulus);
        for x in 0..self.modulus {
            if RESTRICTED && self.class_by_value.get(x) != Some(input_class) {
                continue;
            }
            let mut value = 0_u64;
            for &coefficient in coefficients.iter().rev() {
                value = (value * u64::from(x) + u64::from(coefficient)) % modulus;
            }
            self.tally_class(value as u32, &mut census);
        }
        Ok(census)
    }

    /// Return all cyclotomic numbers `|(C_a + 1) intersect C_b|`.
    pub fn cyclotomic_census(&self) -> Result<CyclotomicCensus, CharacterSumError> {
        let cells = self
            .order
            .checked_mul(self.order)
            .ok_or(CharacterSumError::CountOverflow)? as usize;
        let mut counts = vec![0_u32; cells].into_boxed_slice();
        for value in 1..self.modulus {
            let shifted = if value + 1 == self.modulus {
                0
            } else {
                value + 1
            };
            if shifted == 0 {
                continue;
            }
            let left = self.class_by_value.get(value).unwrap();
            let right = self.class_by_value.get(shifted).unwrap();
            counts[(left * self.order + right) as usize] += 1;
        }
        Ok(CyclotomicCensus {
            counts,
            order: self.order,
        })
    }

    /// Exact Jacobi sum `sum_x chi(x)^a chi(1-x)^b`.
    ///
    /// Every multiplicative character, including power zero, is extended by
    /// zero at the field zero. Thus the two excluded terms are retained in the
    /// witness's `zero` count.
    pub fn jacobi_census(&self, left_power: u32, right_power: u32) -> RootOfUnityCensus {
        let mut census = RootOfUnityCensus {
            coefficients: vec![0; self.order as usize].into_boxed_slice(),
            zero: 2,
        };
        let left_power = left_power % self.order;
        let right_power = right_power % self.order;
        for value in 2..self.modulus {
            let left = self.class_by_value.get(value).unwrap();
            let right = self.class_by_value.get(self.modulus - (value - 1)).unwrap();
            let exponent = ((u64::from(left) * u64::from(left_power)
                + u64::from(right) * u64::from(right_power))
                % u64::from(self.order)) as usize;
            census.coefficients[exponent] += 1;
        }
        census
    }

    #[inline]
    fn tally_class(&self, value: u32, census: &mut RootOfUnityCensus) {
        if let Some(class) = self.class_by_value.get(value) {
            census.coefficients[class as usize] += 1;
        } else {
            census.zero += 1;
        }
    }
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

fn fill_character_classes<T: Copy>(
    classes: &mut [T],
    modulus: u32,
    order: u32,
    generator: u32,
    encode: impl Fn(u32) -> T,
) {
    let mut value = 1_u32;
    for exponent in 0..modulus - 1 {
        classes[value as usize] = encode(exponent % order);
        value = mul_mod(value, generator, modulus);
    }
    debug_assert_eq!(value, 1);
}

#[inline]
fn mul_mod(left: u32, right: u32, modulus: u32) -> u32 {
    (u64::from(left) * u64::from(right) % u64::from(modulus)) as u32
}

fn primitive_root(modulus: u32) -> u32 {
    let phi = modulus - 1;
    let mut quotient = phi;
    let mut factors = Vec::new();
    let mut divisor = 2_u32;
    while divisor <= quotient / divisor {
        if quotient.is_multiple_of(divisor) {
            factors.push(divisor);
            while quotient.is_multiple_of(divisor) {
                quotient /= divisor;
            }
        }
        divisor += 1;
    }
    if quotient != 1 {
        factors.push(quotient);
    }
    (2..modulus)
        .find(|&candidate| {
            factors
                .iter()
                .all(|&factor| pow_mod(candidate, phi / factor, modulus) != 1)
        })
        .expect("every finite prime field has a primitive root")
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

    #[test]
    fn higher_character_table_partitions_the_multiplicative_group() {
        let character = PrimeMultiplicativeCharacter::new(7, 3).unwrap();
        assert_eq!(character.modulus(), 7);
        assert_eq!(character.order(), 3);
        assert_eq!(character.class_table_bytes(), 7);
        assert_eq!(character.class_i128(0), None);
        let census = character.polynomial_census_reduced(&[0, 1]).unwrap();
        assert_eq!(census.coefficients(), &[2, 2, 2]);
        assert_eq!(census.zero(), 1);
        assert_eq!(census.total(), 7);
        let restricted = character
            .polynomial_census_on_class_reduced(1, &[0, 1])
            .unwrap();
        assert_eq!(restricted.coefficients(), &[0, 2, 0]);
        assert_eq!(restricted.total(), 2);
    }

    #[test]
    fn cyclotomic_and_jacobi_censuses_are_exact_witnesses() {
        let character = PrimeMultiplicativeCharacter::new(7, 2).unwrap();
        let cyclotomic = character.cyclotomic_census().unwrap();
        assert_eq!(cyclotomic.order(), 2);
        assert_eq!(cyclotomic.counts().iter().sum::<u32>(), 5);
        for left in 0..2 {
            for right in 0..2 {
                let expected = (1..7)
                    .filter(|&value| value + 1 != 7)
                    .filter(|&value| {
                        character.class_i128(i128::from(value)) == Some(left)
                            && character.class_i128(i128::from(value + 1)) == Some(right)
                    })
                    .count() as u32;
                assert_eq!(cyclotomic.count(left, right), Some(expected));
            }
        }
        let jacobi = character.jacobi_census(1, 1);
        assert_eq!(jacobi.total(), 7);
        assert_eq!(jacobi.zero(), 2);
        assert_eq!(jacobi.coefficients().iter().sum::<u32>(), 5);
        assert_eq!(
            i64::from(jacobi.coefficients()[0]) - i64::from(jacobi.coefficients()[1]),
            1
        );
    }

    #[test]
    fn higher_character_rejects_invalid_orders() {
        assert_eq!(
            PrimeMultiplicativeCharacter::new(7, 4).unwrap_err(),
            CharacterSumError::InvalidCharacterOrder
        );
        assert_eq!(
            PrimeMultiplicativeCharacter::new(9, 2).unwrap_err(),
            CharacterSumError::NotOddPrime
        );
    }

    #[test]
    fn order_two_census_recovers_the_quadratic_character_sum() {
        for modulus in [3, 5, 7, 11, 97] {
            let quadratic = PrimeQuadraticCharacter::new(modulus).unwrap();
            let higher = PrimeMultiplicativeCharacter::new(modulus, 2).unwrap();
            let polynomial = higher.reduce_coefficients(&[3, -2, 5, 1]);
            let expected = quadratic.polynomial_census_reduced(&polynomial).unwrap();
            let actual = higher.polynomial_census_reduced(&polynomial).unwrap();
            assert_eq!(actual.zero(), expected.zero());
            assert_eq!(actual.coefficients()[0], expected.positive());
            assert_eq!(actual.coefficients()[1], expected.negative());
        }
    }
}
