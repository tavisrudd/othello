use thiserror::Error;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum FieldError {
    #[error("the modulus must be prime and lie in 2..=251")]
    InvalidModulus,
    #[error("zero has no multiplicative inverse")]
    ZeroInverse,
}

/// Monomorphized arithmetic for a small prime field.
///
/// The modulus is resolved at the call site, not tested inside client loops.
#[derive(Debug, Clone, Copy, Default)]
pub struct Prime<const P: u8>;

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
}
