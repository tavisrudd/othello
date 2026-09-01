use thiserror::Error;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum FieldError {
    #[error("the modulus must be prime and lie in 2..=251")]
    InvalidModulus,
    #[error("zero has no multiplicative inverse")]
    ZeroInverse,
    #[error("field element lies outside the canonical encoding")]
    InvalidElement,
    #[error("extension degree must be positive and the field order must fit in 256 elements")]
    InvalidExtensionDegree,
    #[error("the modulus must be monic, reduced, and irreducible over the prime field")]
    InvalidExtensionModulus,
}

mod private {
    pub trait Sealed {}
}

/// Monomorphized arithmetic over a finite field whose elements fit in one byte.
///
/// Implementations use a canonical integer encoding in `0..ORDER`. CLI field
/// dispatch happens before client loops, so arithmetic carries no runtime tag.
pub trait FiniteField: private::Sealed + Copy + Send + Sync + 'static {
    const ORDER: u8;
    const CHARACTERISTIC: u8;

    fn validate() -> Result<(), FieldError>;

    fn add(left: u8, right: u8) -> u8;

    fn sub(left: u8, right: u8) -> u8;

    fn mul(left: u8, right: u8) -> u8;

    fn inverse(value: u8) -> Result<u8, FieldError>;
}

/// Monomorphized arithmetic for a small prime field.
///
/// The modulus is resolved at the call site, not tested inside client loops.
#[derive(Debug, Clone, Copy, Default)]
pub struct Prime<const P: u8>;

impl<const P: u8> private::Sealed for Prime<P> {}

impl<const P: u8> Prime<P> {
    pub fn validate() -> Result<(), FieldError> {
        if P < 2 || !is_prime(P) {
            return Err(FieldError::InvalidModulus);
        }
        Ok(())
    }

    #[inline(always)]
    pub fn add(left: u8, right: u8) -> u8 {
        let sum = left as u16 + right as u16;
        (sum % P as u16) as u8
    }

    #[inline(always)]
    pub fn sub(left: u8, right: u8) -> u8 {
        ((left as u16 + P as u16 - right as u16) % P as u16) as u8
    }

    #[inline(always)]
    pub fn mul(left: u8, right: u8) -> u8 {
        ((left as u16 * right as u16) % P as u16) as u8
    }

    pub fn inverse(value: u8) -> Result<u8, FieldError> {
        if value == 0 {
            return Err(FieldError::ZeroInverse);
        }
        Ok(Self::pow(value, P as u16 - 2))
    }

    #[inline]
    pub fn pow(mut base: u8, mut exponent: u16) -> u8 {
        let mut result = 1u8;
        while exponent != 0 {
            if exponent & 1 != 0 {
                result = Self::mul(result, base);
            }
            base = Self::mul(base, base);
            exponent >>= 1;
        }
        result
    }
}

impl<const P: u8> FiniteField for Prime<P> {
    const ORDER: u8 = P;
    const CHARACTERISTIC: u8 = P;

    #[inline]
    fn validate() -> Result<(), FieldError> {
        Self::validate()
    }

    #[inline(always)]
    fn add(left: u8, right: u8) -> u8 {
        Self::add(left, right)
    }

    #[inline(always)]
    fn sub(left: u8, right: u8) -> u8 {
        Self::sub(left, right)
    }

    #[inline(always)]
    fn mul(left: u8, right: u8) -> u8 {
        Self::mul(left, right)
    }

    #[inline]
    fn inverse(value: u8) -> Result<u8, FieldError> {
        Self::inverse(value)
    }
}

/// Canonical polynomial-basis arithmetic for
/// `GF(4) = GF(2)[a] / (a^2 + a + 1)`.
///
/// The low bit is the coefficient of `1` and the high bit is the coefficient
/// of `a`: `0`, `1`, `a`, and `a + 1` are encoded as `0`, `1`, `2`, and `3`.
#[derive(Debug, Clone, Copy, Default)]
pub struct Gf4;

impl private::Sealed for Gf4 {}

impl FiniteField for Gf4 {
    const ORDER: u8 = 4;
    const CHARACTERISTIC: u8 = 2;

    #[inline]
    fn validate() -> Result<(), FieldError> {
        Ok(())
    }

    #[inline(always)]
    fn add(left: u8, right: u8) -> u8 {
        left ^ right
    }

    #[inline(always)]
    fn sub(left: u8, right: u8) -> u8 {
        left ^ right
    }

    #[inline(always)]
    fn mul(left: u8, right: u8) -> u8 {
        let left_constant = left & 1;
        let left_alpha = left >> 1;
        let right_constant = right & 1;
        let right_alpha = right >> 1;
        let alpha_product = left_alpha & right_alpha;
        let constant = (left_constant & right_constant) ^ alpha_product;
        let alpha = (left_constant & right_alpha) ^ (left_alpha & right_constant) ^ alpha_product;
        constant | (alpha << 1)
    }

    #[inline]
    fn inverse(value: u8) -> Result<u8, FieldError> {
        match value {
            0 => Err(FieldError::ZeroInverse),
            1 => Ok(1),
            2 => Ok(3),
            3 => Ok(2),
            _ => Err(FieldError::InvalidElement),
        }
    }
}

/// Table-backed arithmetic for a runtime-selected field `GF(p^h)` of order at
/// most 256.
///
/// This type is deliberately a finite *field*, not an arbitrary algebra with
/// `p^h` elements.  In particular, `SmallField::new(2, 2)` constructs `GF(4)`;
/// it does not describe `Z/4Z` or `F_2[u]/(u^2)`.  Elements are stored as raw
/// bytes, so callers importing externally encoded algebra data must establish
/// that field identity before using it with this type.
///
/// Elements use the polynomial-basis encoding
/// `a_0 + a_1 x + ... + a_(h-1) x^(h-1) -> sum a_i p^i`. Construction is a
/// cold operation: it locates or validates an irreducible monic modulus and
/// builds flat addition, subtraction, multiplication, and inverse tables.
/// Arithmetic thereafter allocates nothing and performs one indexed lookup.
#[derive(Clone, Debug)]
pub struct SmallField {
    order: u16,
    characteristic: u8,
    degree: u8,
    modulus: Box<[u8]>,
    add: Box<[u8]>,
    subtract: Box<[u8]>,
    multiply: Box<[u8]>,
    inverse: Box<[u8]>,
}

impl SmallField {
    /// Construct the canonical field using the lexicographically first monic
    /// irreducible polynomial in polynomial-basis encoding.
    ///
    /// The arguments identify `GF(characteristic^degree)`, not merely an
    /// algebra of that cardinality.  Equal-cardinality rings are not accepted
    /// or inferred by this constructor.
    pub fn new(characteristic: u8, degree: u8) -> Result<Self, FieldError> {
        extension_order(characteristic, degree)?;
        let modulus =
            first_irreducible(characteristic, degree).ok_or(FieldError::InvalidExtensionModulus)?;
        Self::from_modulus(characteristic, &modulus[..=usize::from(degree)])
    }

    /// Construct a field from low-to-high coefficients of a monic irreducible
    /// polynomial. The slice length is `h + 1`.
    pub fn from_modulus(characteristic: u8, modulus: &[u8]) -> Result<Self, FieldError> {
        let degree = modulus
            .len()
            .checked_sub(1)
            .and_then(|degree| u8::try_from(degree).ok())
            .ok_or(FieldError::InvalidExtensionDegree)?;
        let order = extension_order(characteristic, degree)?;
        if modulus.last() != Some(&1)
            || modulus
                .iter()
                .any(|&coefficient| coefficient >= characteristic)
            || !polynomial_is_irreducible(characteristic, modulus)
        {
            return Err(FieldError::InvalidExtensionModulus);
        }
        let table_len = usize::from(order) * usize::from(order);
        let mut add = vec![0; table_len];
        let mut subtract = vec![0; table_len];
        let mut multiply = vec![0; table_len];
        for left in 0..order {
            for right in 0..order {
                let slot = usize::from(left) * usize::from(order) + usize::from(right);
                add[slot] = extension_add(left, right, characteristic, degree, false);
                subtract[slot] = extension_add(left, right, characteristic, degree, true);
                multiply[slot] = extension_multiply(left, right, characteristic, degree, modulus);
            }
        }
        let mut inverse = vec![0; usize::from(order)];
        for value in 1..order {
            let row = usize::from(value) * usize::from(order);
            let candidate = (1..order)
                .find(|&candidate| multiply[row + usize::from(candidate)] == 1)
                .ok_or(FieldError::InvalidExtensionModulus)?;
            inverse[usize::from(value)] = candidate as u8;
        }
        Ok(Self {
            order,
            characteristic,
            degree,
            modulus: modulus.into(),
            add: add.into_boxed_slice(),
            subtract: subtract.into_boxed_slice(),
            multiply: multiply.into_boxed_slice(),
            inverse: inverse.into_boxed_slice(),
        })
    }

    #[inline]
    pub const fn order(&self) -> u16 {
        self.order
    }

    #[inline]
    pub const fn characteristic(&self) -> u8 {
        self.characteristic
    }

    #[inline]
    pub const fn degree(&self) -> u8 {
        self.degree
    }

    #[inline]
    pub fn modulus(&self) -> &[u8] {
        &self.modulus
    }

    #[inline(always)]
    pub fn add(&self, left: u8, right: u8) -> u8 {
        self.add[self.table_index(left, right)]
    }

    #[inline(always)]
    pub fn sub(&self, left: u8, right: u8) -> u8 {
        self.subtract[self.table_index(left, right)]
    }

    #[inline(always)]
    pub fn mul(&self, left: u8, right: u8) -> u8 {
        self.multiply[self.table_index(left, right)]
    }

    #[inline]
    pub fn inverse(&self, value: u8) -> Result<u8, FieldError> {
        if value == 0 {
            return Err(FieldError::ZeroInverse);
        }
        self.inverse
            .get(usize::from(value))
            .copied()
            .ok_or(FieldError::InvalidElement)
    }

    #[inline]
    pub fn pow(&self, mut base: u8, mut exponent: u16) -> u8 {
        let mut result = 1;
        while exponent != 0 {
            if exponent & 1 != 0 {
                result = self.mul(result, base);
            }
            base = self.mul(base, base);
            exponent >>= 1;
        }
        result
    }

    #[inline(always)]
    fn table_index(&self, left: u8, right: u8) -> usize {
        let left = usize::from(left);
        let right = usize::from(right);
        let order = usize::from(self.order);
        assert!(
            left < order && right < order,
            "field element is not reduced"
        );
        left * order + right
    }
}

fn extension_order(characteristic: u8, degree: u8) -> Result<u16, FieldError> {
    if !is_prime(characteristic) {
        return Err(FieldError::InvalidModulus);
    }
    if degree == 0 {
        return Err(FieldError::InvalidExtensionDegree);
    }
    let mut order = 1u16;
    for _ in 0..degree {
        order = order
            .checked_mul(u16::from(characteristic))
            .filter(|&order| order <= 256)
            .ok_or(FieldError::InvalidExtensionDegree)?;
    }
    Ok(order)
}

fn first_irreducible(characteristic: u8, degree: u8) -> Option<[u8; 9]> {
    let degree = usize::from(degree);
    if degree > 8 {
        return None;
    }
    let candidate_count = usize::from(characteristic).pow(degree as u32);
    for encoded in 0..candidate_count {
        let mut value = encoded;
        let mut candidate = [0u8; 9];
        for coefficient in &mut candidate[..degree] {
            *coefficient = (value % usize::from(characteristic)) as u8;
            value /= usize::from(characteristic);
        }
        candidate[degree] = 1;
        if polynomial_is_irreducible(characteristic, &candidate[..=degree]) {
            return Some(candidate);
        }
    }
    None
}

fn polynomial_is_irreducible(characteristic: u8, polynomial: &[u8]) -> bool {
    let degree = polynomial.len() - 1;
    if degree == 1 {
        return true;
    }
    if polynomial[0] == 0 {
        return false;
    }
    for divisor_degree in 1..=degree / 2 {
        let divisor_count = usize::from(characteristic).pow(divisor_degree as u32);
        for encoded in 0..divisor_count {
            let mut value = encoded;
            let mut divisor = [0u8; 9];
            for coefficient in &mut divisor[..divisor_degree] {
                *coefficient = (value % usize::from(characteristic)) as u8;
                value /= usize::from(characteristic);
            }
            divisor[divisor_degree] = 1;
            if polynomial_divides(characteristic, polynomial, &divisor[..=divisor_degree]) {
                return false;
            }
        }
    }
    true
}

fn polynomial_divides(characteristic: u8, polynomial: &[u8], divisor: &[u8]) -> bool {
    let divisor_degree = divisor.len() - 1;
    let mut remainder = [0u8; 9];
    remainder[..polynomial.len()].copy_from_slice(polynomial);
    for power in (divisor_degree..polynomial.len()).rev() {
        let leading = remainder[power];
        if leading == 0 {
            continue;
        }
        let shift = power - divisor_degree;
        for index in 0..=divisor_degree {
            let product = u16::from(leading) * u16::from(divisor[index]);
            remainder[shift + index] = ((u16::from(remainder[shift + index])
                + u16::from(characteristic)
                - product % u16::from(characteristic))
                % u16::from(characteristic)) as u8;
        }
    }
    remainder[..divisor_degree].iter().all(|&value| value == 0)
}

fn extension_add(left: u16, right: u16, characteristic: u8, degree: u8, subtract: bool) -> u8 {
    let characteristic = u16::from(characteristic);
    let mut left = left;
    let mut right = right;
    let mut encoded = 0u16;
    let mut place = 1u16;
    for _ in 0..degree {
        let left_coefficient = left % characteristic;
        let right_coefficient = right % characteristic;
        let coefficient = if subtract {
            (left_coefficient + characteristic - right_coefficient) % characteristic
        } else {
            (left_coefficient + right_coefficient) % characteristic
        };
        encoded += coefficient * place;
        place *= characteristic;
        left /= characteristic;
        right /= characteristic;
    }
    encoded as u8
}

fn extension_multiply(
    mut left: u16,
    mut right: u16,
    characteristic: u8,
    degree: u8,
    modulus: &[u8],
) -> u8 {
    let degree = usize::from(degree);
    let characteristic_u16 = u16::from(characteristic);
    let mut left_coefficients = [0u16; 8];
    let mut right_coefficients = [0u16; 8];
    for index in 0..degree {
        left_coefficients[index] = left % characteristic_u16;
        right_coefficients[index] = right % characteristic_u16;
        left /= characteristic_u16;
        right /= characteristic_u16;
    }
    let mut product = [0u16; 15];
    for (left_index, &left_coefficient) in left_coefficients[..degree].iter().enumerate() {
        for (right_index, &right_coefficient) in right_coefficients[..degree].iter().enumerate() {
            let slot = left_index + right_index;
            product[slot] =
                (product[slot] + left_coefficient * right_coefficient) % characteristic_u16;
        }
    }
    for power in (degree..=(2 * degree - 2)).rev() {
        let leading = product[power];
        if leading == 0 {
            continue;
        }
        let shift = power - degree;
        for index in 0..degree {
            let reduction = leading * u16::from(modulus[index]) % characteristic_u16;
            product[shift + index] =
                (product[shift + index] + characteristic_u16 - reduction) % characteristic_u16;
        }
    }
    let mut encoded = 0u16;
    let mut place = 1u16;
    for coefficient in &product[..degree] {
        encoded += *coefficient * place;
        place *= characteristic_u16;
    }
    encoded as u8
}

const fn is_prime(value: u8) -> bool {
    if value < 2 {
        return false;
    }
    let mut divisor = 2u8;
    while (divisor as u16) * (divisor as u16) <= value as u16 {
        if value.is_multiple_of(divisor) {
            return false;
        }
        divisor += 1;
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn inverses_replay_for_small_primes() {
        Prime::<2>::validate().unwrap();
        Prime::<251>::validate().unwrap();
        assert!(Prime::<9>::validate().is_err());
        for value in 1..7 {
            assert_eq!(
                Prime::<7>::mul(value, Prime::<7>::inverse(value).unwrap()),
                1
            );
        }
    }

    #[test]
    fn gf4_exhaustively_satisfies_field_laws() {
        for a in 0..4 {
            assert_eq!(Gf4::add(a, 0), a);
            assert_eq!(Gf4::mul(a, 0), 0);
            assert_eq!(Gf4::mul(a, 1), a);
            for b in 0..4 {
                assert!(Gf4::add(a, b) < 4);
                assert!(Gf4::mul(a, b) < 4);
                assert_eq!(Gf4::add(a, b), Gf4::add(b, a));
                assert_eq!(Gf4::mul(a, b), Gf4::mul(b, a));
                for c in 0..4 {
                    assert_eq!(Gf4::add(Gf4::add(a, b), c), Gf4::add(a, Gf4::add(b, c)));
                    assert_eq!(Gf4::mul(Gf4::mul(a, b), c), Gf4::mul(a, Gf4::mul(b, c)));
                    assert_eq!(
                        Gf4::mul(a, Gf4::add(b, c)),
                        Gf4::add(Gf4::mul(a, b), Gf4::mul(a, c))
                    );
                }
            }
            if a != 0 {
                assert_eq!(Gf4::mul(a, Gf4::inverse(a).unwrap()), 1);
            }
        }
        assert_eq!(Gf4::mul(2, 2), 3);
        assert_eq!(Gf4::mul(2, 3), 1);
        assert_eq!(Gf4::inverse(4), Err(FieldError::InvalidElement));
    }

    #[test]
    fn runtime_prime_power_fields_cover_campaign_orders() {
        for (characteristic, degree, order) in [
            (2, 3, 8),
            (3, 2, 9),
            (2, 4, 16),
            (5, 2, 25),
            (3, 3, 27),
            (2, 5, 32),
            (2, 6, 64),
        ] {
            let field = SmallField::new(characteristic, degree).unwrap();
            assert_eq!(field.order(), order);
            for left in 0..order as u8 {
                assert_eq!(field.add(left, 0), left);
                assert_eq!(field.mul(left, 0), 0);
                assert_eq!(field.mul(left, 1), left);
                if left != 0 {
                    assert_eq!(field.mul(left, field.inverse(left).unwrap()), 1);
                }
                for right in 0..order as u8 {
                    assert!(u16::from(field.add(left, right)) < order);
                    assert!(u16::from(field.mul(left, right)) < order);
                    assert_eq!(field.add(left, right), field.add(right, left));
                    assert_eq!(field.mul(left, right), field.mul(right, left));
                    assert_eq!(field.sub(field.add(left, right), right), left);
                }
            }
        }
    }

    #[test]
    fn runtime_field_validates_moduli_and_matches_gf4_encoding() {
        assert!(SmallField::new(6, 1).is_err());
        assert!(SmallField::new(2, 0).is_err());
        assert!(SmallField::new(3, 6).is_err());
        assert!(SmallField::from_modulus(2, &[1, 0, 1]).is_err());
        let field = SmallField::new(2, 2).unwrap();
        assert_eq!(field.modulus(), &[1, 1, 1]);
        for left in 0..4 {
            for right in 0..4 {
                assert_eq!(field.add(left, right), Gf4::add(left, right));
                assert_eq!(field.mul(left, right), Gf4::mul(left, right));
            }
        }
        let largest = SmallField::new(2, 8).unwrap();
        assert_eq!(largest.order(), 256);
        assert_eq!(largest.mul(255, largest.inverse(255).unwrap()), 1);
    }
}
