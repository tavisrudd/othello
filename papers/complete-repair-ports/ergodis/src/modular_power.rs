//! Compact exact certificates for independence of integer matrix powers.
//!
//! Reducing an integer matrix modulo a prime and finding a nonzero minor in
//! `I, A, ..., A^(r-1)` proves that those powers are independent over the
//! rationals.  This is the reusable computational part of many spectral-
//! generation arguments.  Equality with a particular ambient algebra still
//! requires a separately justified dimension bound and containment theorem.

use thiserror::Error;

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ModularPowerCertificate {
    modulus: u32,
    order: u32,
    power_count: u32,
    pivot_entries: Box<[u32]>,
}

impl ModularPowerCertificate {
    #[must_use]
    pub fn modulus(&self) -> u32 {
        self.modulus
    }

    #[must_use]
    pub fn order(&self) -> u32 {
        self.order
    }

    #[must_use]
    pub fn power_count(&self) -> u32 {
        self.power_count
    }

    /// Flattened row-major matrix coordinates defining the nonzero minor.
    #[must_use]
    pub fn pivot_entries(&self) -> &[u32] {
        &self.pivot_entries
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum ModularPowerError {
    #[error("matrix order, entry count, or requested power count is invalid")]
    Shape,
    #[error("modulus is not prime")]
    NotPrime,
    #[error("matrix powers have modular rank {rank}, below the requested count")]
    Dependent { rank: u32 },
    #[error("power-independence certificate is invalid")]
    Certificate,
}

/// Find a compact nonzero-minor certificate for `I, A, ..., A^(r-1)`.
///
/// `entries` are row-major signed integer entries.  Compilation is a cold
/// algebraic front end and may allocate; no solve-loop state is involved.
pub fn certify_integer_matrix_powers(
    order: usize,
    entries: &[i64],
    power_count: usize,
    modulus: u32,
) -> Result<ModularPowerCertificate, ModularPowerError> {
    validate_shape(order, entries.len(), power_count)?;
    if !is_prime(modulus) {
        return Err(ModularPowerError::NotPrime);
    }
    let width = order.checked_mul(order).ok_or(ModularPowerError::Shape)?;
    let reduced = entries
        .iter()
        .map(|&entry| i128::from(entry).rem_euclid(i128::from(modulus)) as u32)
        .collect::<Box<_>>();
    let powers = matrix_powers(order, &reduced, power_count, modulus);
    let mut echelon = powers.to_vec();
    let pivots = row_reduce(&mut echelon, power_count, width, modulus);
    if pivots.len() != power_count {
        return Err(ModularPowerError::Dependent {
            rank: pivots.len() as u32,
        });
    }
    Ok(ModularPowerCertificate {
        modulus,
        order: order as u32,
        power_count: power_count as u32,
        pivot_entries: pivots.into_boxed_slice(),
    })
}

/// Replay a certificate by reconstructing only its square witness minor.
pub fn verify_integer_matrix_powers(
    entries: &[i64],
    certificate: &ModularPowerCertificate,
) -> Result<(), ModularPowerError> {
    let order = certificate.order as usize;
    let power_count = certificate.power_count as usize;
    validate_shape(order, entries.len(), power_count)?;
    if !is_prime(certificate.modulus) || certificate.pivot_entries.len() != power_count {
        return Err(ModularPowerError::Certificate);
    }
    let width = order
        .checked_mul(order)
        .ok_or(ModularPowerError::Certificate)?;
    if certificate
        .pivot_entries
        .iter()
        .any(|&entry| entry as usize >= width)
    {
        return Err(ModularPowerError::Certificate);
    }
    let reduced = entries
        .iter()
        .map(|&entry| i128::from(entry).rem_euclid(i128::from(certificate.modulus)) as u32)
        .collect::<Box<_>>();
    let powers = matrix_powers(order, &reduced, power_count, certificate.modulus);
    let mut minor = vec![0_u32; power_count * power_count];
    for power in 0..power_count {
        for (column, &entry) in certificate.pivot_entries.iter().enumerate() {
            minor[power * power_count + column] = powers[power * width + entry as usize];
        }
    }
    if row_reduce(&mut minor, power_count, power_count, certificate.modulus).len() != power_count {
        return Err(ModularPowerError::Certificate);
    }
    Ok(())
}

fn validate_shape(
    order: usize,
    entry_count: usize,
    power_count: usize,
) -> Result<(), ModularPowerError> {
    if order == 0
        || power_count == 0
        || power_count > order
        || order.checked_mul(order) != Some(entry_count)
        || u32::try_from(order).is_err()
        || u32::try_from(power_count).is_err()
    {
        return Err(ModularPowerError::Shape);
    }
    Ok(())
}

fn matrix_powers(order: usize, matrix: &[u32], count: usize, modulus: u32) -> Box<[u32]> {
    let width = order * order;
    let mut powers = vec![0_u32; count * width];
    for index in 0..order {
        powers[index * order + index] = 1;
    }
    let modulus = u64::from(modulus);
    for power in 1..count {
        let (before, after) = powers.split_at_mut(power * width);
        let previous = &before[(power - 1) * width..power * width];
        let next = &mut after[..width];
        for row in 0..order {
            for column in 0..order {
                let mut value = 0_u64;
                for inner in 0..order {
                    value = (value
                        + u64::from(previous[row * order + inner])
                            * u64::from(matrix[inner * order + column]))
                        % modulus;
                }
                next[row * order + column] = value as u32;
            }
        }
    }
    powers.into_boxed_slice()
}

fn row_reduce(data: &mut [u32], rows: usize, cols: usize, modulus: u32) -> Vec<u32> {
    let mut pivot_row = 0_usize;
    let modulus64 = u64::from(modulus);
    let mut pivots = Vec::with_capacity(rows);
    for column in 0..cols {
        let Some(found) = (pivot_row..rows).find(|&row| data[row * cols + column] != 0) else {
            continue;
        };
        if found != pivot_row {
            for entry in 0..cols {
                data.swap(found * cols + entry, pivot_row * cols + entry);
            }
        }
        let inverse = pow_mod(data[pivot_row * cols + column], modulus - 2, modulus);
        for entry in column..cols {
            data[pivot_row * cols + entry] =
                (u64::from(data[pivot_row * cols + entry]) * u64::from(inverse) % modulus64) as u32;
        }
        for row in 0..rows {
            if row == pivot_row {
                continue;
            }
            let factor = data[row * cols + column];
            if factor == 0 {
                continue;
            }
            for entry in column..cols {
                let product =
                    u64::from(factor) * u64::from(data[pivot_row * cols + entry]) % modulus64;
                data[row * cols + entry] = ((u64::from(data[row * cols + entry]) + modulus64
                    - product)
                    % modulus64) as u32;
            }
        }
        pivots.push(column as u32);
        pivot_row += 1;
        if pivot_row == rows {
            break;
        }
    }
    pivots
}

fn pow_mod(mut base: u32, mut exponent: u32, modulus: u32) -> u32 {
    let modulus64 = u64::from(modulus);
    let mut result = 1_u64;
    let mut base64 = u64::from(base);
    while exponent != 0 {
        if exponent & 1 != 0 {
            result = result * base64 % modulus64;
        }
        base64 = base64 * base64 % modulus64;
        exponent >>= 1;
    }
    base = result as u32;
    base
}

fn is_prime(value: u32) -> bool {
    if value < 2 {
        return false;
    }
    if value == 2 {
        return true;
    }
    if value.is_multiple_of(2) {
        return false;
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
    fn certifies_three_independent_diagonal_powers() {
        let matrix = [1, 0, 0, 0, 2, 0, 0, 0, 3];
        let certificate = certify_integer_matrix_powers(3, &matrix, 3, 101).unwrap();
        assert_eq!(certificate.power_count(), 3);
        verify_integer_matrix_powers(&matrix, &certificate).unwrap();
    }

    #[test]
    fn reports_dependent_powers() {
        let identity = [1, 0, 0, 1];
        assert_eq!(
            certify_integer_matrix_powers(2, &identity, 2, 101),
            Err(ModularPowerError::Dependent { rank: 1 })
        );
    }

    #[test]
    fn rejects_a_tampered_minor() {
        let matrix = [1, 0, 0, 0, 2, 0, 0, 0, 3];
        let mut certificate = certify_integer_matrix_powers(3, &matrix, 3, 101).unwrap();
        certificate.pivot_entries[1] = certificate.pivot_entries[0];
        assert_eq!(
            verify_integer_matrix_powers(&matrix, &certificate),
            Err(ModularPowerError::Certificate)
        );
    }
}
