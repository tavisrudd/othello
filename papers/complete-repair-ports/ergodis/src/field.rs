use thiserror::Error;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum FieldError {
    #[error("the modulus must be prime and lie in 2..=251")]
    InvalidModulus,
    #[error("zero has no multiplicative inverse")]
    ZeroInverse,
    #[error("field element lies outside the canonical encoding")]
    InvalidElement,
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

const fn is_prime(value: u8) -> bool {
    if value < 2 {
        return false;
    }
    let mut divisor = 2u8;
    while (divisor as u16) * (divisor as u16) <= value as u16 {
        if value % divisor == 0 {
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
}
