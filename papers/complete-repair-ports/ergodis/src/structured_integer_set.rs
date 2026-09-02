//! Exact finite integer sets represented as interval/residue bases minus holes.
//!
//! Construction is cold and canonical. Membership, fixed-target sum counting,
//! and witness extraction allocate nothing and require no recursion.

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const MAX_STRUCTURED_SET_MODULUS: u16 = 256;

#[repr(C)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct ResidueMask256 {
    words: [u64; 4],
}

const _: () = assert!(std::mem::size_of::<ResidueMask256>() == 32);
const _: () = assert!(std::mem::align_of::<ResidueMask256>() == 8);

impl ResidueMask256 {
    const fn empty() -> Self {
        Self { words: [0; 4] }
    }

    fn insert(&mut self, residue: u16) {
        self.words[usize::from(residue / 64)] |= 1_u64 << (residue % 64);
    }

    fn contains(self, residue: u16) -> bool {
        self.words[usize::from(residue / 64)] & (1_u64 << (residue % 64)) != 0
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct StructuredSetBounds {
    pub maximum_modulus: u16,
    pub maximum_holes: usize,
    pub maximum_span: u64,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct StructuredIntegerSet {
    minimum: i64,
    maximum: i64,
    modulus: u16,
    residues: ResidueMask256,
    next_allowed_delta: Box<[u16]>,
    holes: Box<[i64]>,
    cardinality: u64,
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct StructuredSumCertificate {
    pub target: i64,
    pub pair_count: u64,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub witness: Option<[i64; 2]>,
}

#[derive(Clone, Copy, Debug, Eq, Error, PartialEq)]
pub enum StructuredSetError {
    #[error("structured-set bounds are invalid")]
    InvalidBounds,
    #[error("structured-set interval is empty or exceeds its span bound")]
    InvalidInterval,
    #[error("structured-set modulus is invalid or exceeds its bound")]
    InvalidModulus,
    #[error("structured-set residues are empty or noncanonical")]
    InvalidResidues,
    #[error("structured-set holes are noncanonical or outside the residue base")]
    InvalidHoles,
    #[error("structured-set cardinality overflowed")]
    CardinalityOverflow,
    #[error("structured sum certificate does not replay")]
    InvalidCertificate,
}

impl StructuredIntegerSet {
    pub fn compile(
        minimum: i64,
        maximum: i64,
        modulus: u16,
        residues: &[u16],
        holes: &[i64],
        bounds: StructuredSetBounds,
    ) -> Result<Self, StructuredSetError> {
        validate_bounds(bounds)?;
        let span = inclusive_span(minimum, maximum)?;
        if span > bounds.maximum_span {
            return Err(StructuredSetError::InvalidInterval);
        }
        if modulus == 0 || modulus > MAX_STRUCTURED_SET_MODULUS || modulus > bounds.maximum_modulus
        {
            return Err(StructuredSetError::InvalidModulus);
        }
        if residues.is_empty()
            || residues.windows(2).any(|pair| pair[0] >= pair[1])
            || residues.iter().any(|&residue| residue >= modulus)
        {
            return Err(StructuredSetError::InvalidResidues);
        }
        if holes.len() > bounds.maximum_holes || holes.windows(2).any(|pair| pair[0] >= pair[1]) {
            return Err(StructuredSetError::InvalidHoles);
        }
        let mut residue_mask = ResidueMask256::empty();
        for &residue in residues {
            residue_mask.insert(residue);
        }
        if holes.iter().any(|&hole| {
            hole < minimum
                || hole > maximum
                || !residue_mask.contains(euclidean_residue(hole, modulus))
        }) {
            return Err(StructuredSetError::InvalidHoles);
        }
        let mut base_cardinality = 0_u64;
        for &residue in residues {
            base_cardinality = base_cardinality
                .checked_add(count_residue(minimum, maximum, modulus, residue)?)
                .ok_or(StructuredSetError::CardinalityOverflow)?;
        }
        let hole_count =
            u64::try_from(holes.len()).map_err(|_| StructuredSetError::CardinalityOverflow)?;
        let cardinality = base_cardinality
            .checked_sub(hole_count)
            .ok_or(StructuredSetError::InvalidHoles)?;
        let mut next_allowed_delta = Vec::with_capacity(usize::from(modulus));
        for start in 0..modulus {
            let delta = (0..modulus)
                .find(|&delta| residue_mask.contains((start + delta) % modulus))
                .expect("a validated residue mask is nonempty");
            next_allowed_delta.push(delta);
        }
        Ok(Self {
            minimum,
            maximum,
            modulus,
            residues: residue_mask,
            next_allowed_delta: next_allowed_delta.into_boxed_slice(),
            holes: holes.into(),
            cardinality,
        })
    }

    pub fn minimum(&self) -> i64 {
        self.minimum
    }

    pub fn maximum(&self) -> i64 {
        self.maximum
    }

    pub fn modulus(&self) -> u16 {
        self.modulus
    }

    pub fn holes(&self) -> &[i64] {
        &self.holes
    }

    pub fn span(&self) -> u64 {
        inclusive_span(self.minimum, self.maximum)
            .expect("compiled structured-set interval is valid")
    }

    pub fn cardinality(&self) -> u64 {
        self.cardinality
    }

    #[inline]
    pub fn contains(&self, value: i64) -> bool {
        value >= self.minimum
            && value <= self.maximum
            && self
                .residues
                .contains(euclidean_residue(value, self.modulus))
            && self.holes.binary_search(&value).is_err()
    }

    pub fn iter(&self) -> StructuredIntegerSetIter<'_> {
        StructuredIntegerSetIter {
            set: self,
            next: self.next_base_at_or_after(self.minimum),
        }
    }

    #[inline]
    fn next_base_at_or_after(&self, start: i64) -> Option<i64> {
        if start > self.maximum {
            return None;
        }
        let residue = euclidean_residue(start, self.modulus);
        let delta = self.next_allowed_delta[usize::from(residue)];
        let candidate = i128::from(start) + i128::from(delta);
        (candidate <= i128::from(self.maximum))
            .then(|| i64::try_from(candidate).expect("candidate lies in a validated i64 interval"))
    }

    pub fn sum_certificate(&self, other: &Self, target: i64) -> StructuredSumCertificate {
        let (scan, probe, swapped) = if self.span() <= other.span() {
            (self, other, false)
        } else {
            (other, self, true)
        };
        let mut pair_count = 0_u64;
        let mut witness = None;
        for scanned in scan.iter() {
            let complement = i128::from(target) - i128::from(scanned);
            let Ok(complement) = i64::try_from(complement) else {
                continue;
            };
            if probe.contains(complement) {
                pair_count += 1;
                if witness.is_none() {
                    witness = Some(if swapped {
                        [complement, scanned]
                    } else {
                        [scanned, complement]
                    });
                }
            }
        }
        StructuredSumCertificate {
            target,
            pair_count,
            witness,
        }
    }

    pub fn verify_sum_certificate(
        &self,
        other: &Self,
        certificate: StructuredSumCertificate,
    ) -> Result<(), StructuredSetError> {
        let replay = self.sum_certificate(other, certificate.target);
        if replay != certificate {
            return Err(StructuredSetError::InvalidCertificate);
        }
        if let Some([left, right]) = certificate.witness {
            if !self.contains(left)
                || !other.contains(right)
                || i128::from(left) + i128::from(right) != i128::from(certificate.target)
            {
                return Err(StructuredSetError::InvalidCertificate);
            }
        }
        Ok(())
    }
}

pub struct StructuredIntegerSetIter<'a> {
    set: &'a StructuredIntegerSet,
    next: Option<i64>,
}

impl Iterator for StructuredIntegerSetIter<'_> {
    type Item = i64;

    fn next(&mut self) -> Option<Self::Item> {
        while let Some(value) = self.next {
            self.next = if value == self.set.maximum {
                None
            } else {
                value
                    .checked_add(1)
                    .and_then(|start| self.set.next_base_at_or_after(start))
            };
            if self.set.holes.binary_search(&value).is_err() {
                return Some(value);
            }
        }
        None
    }
}

fn validate_bounds(bounds: StructuredSetBounds) -> Result<(), StructuredSetError> {
    if bounds.maximum_modulus == 0
        || bounds.maximum_modulus > MAX_STRUCTURED_SET_MODULUS
        || bounds.maximum_span == 0
    {
        Err(StructuredSetError::InvalidBounds)
    } else {
        Ok(())
    }
}

fn inclusive_span(minimum: i64, maximum: i64) -> Result<u64, StructuredSetError> {
    if minimum > maximum {
        return Err(StructuredSetError::InvalidInterval);
    }
    u64::try_from(i128::from(maximum) - i128::from(minimum) + 1)
        .map_err(|_| StructuredSetError::InvalidInterval)
}

fn euclidean_residue(value: i64, modulus: u16) -> u16 {
    value.rem_euclid(i64::from(modulus)) as u16
}

fn count_residue(
    minimum: i64,
    maximum: i64,
    modulus: u16,
    residue: u16,
) -> Result<u64, StructuredSetError> {
    let modulus = i128::from(modulus);
    let minimum = i128::from(minimum);
    let maximum = i128::from(maximum);
    let minimum_residue = minimum.rem_euclid(modulus);
    let offset = (i128::from(residue) - minimum_residue).rem_euclid(modulus);
    let first = minimum + offset;
    if first > maximum {
        return Ok(0);
    }
    u64::try_from((maximum - first) / modulus + 1)
        .map_err(|_| StructuredSetError::CardinalityOverflow)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_alloc::measure_current_thread_allocations;

    const BOUNDS: StructuredSetBounds = StructuredSetBounds {
        maximum_modulus: 256,
        maximum_holes: 64,
        maximum_span: 10_000,
    };

    #[test]
    fn interval_residue_hole_membership_and_cardinality_are_exact() {
        let set = StructuredIntegerSet::compile(-8, 13, 5, &[1, 3], &[-7, 6], BOUNDS).unwrap();
        let expected = (-8_i64..=13)
            .filter(|&value| matches!(value.rem_euclid(5), 1 | 3) && value != -7 && value != 6)
            .collect::<Vec<_>>();
        assert_eq!(set.cardinality(), expected.len() as u64);
        assert_eq!(set.iter().collect::<Vec<_>>(), expected);
        for value in -20..=20 {
            assert_eq!(set.contains(value), expected.contains(&value));
        }
    }

    #[test]
    fn sum_certificate_matches_flat_oracle_and_rejects_forgery() {
        let left =
            StructuredIntegerSet::compile(-20, 40, 7, &[0, 2, 5], &[-14, 9], BOUNDS).unwrap();
        let right = StructuredIntegerSet::compile(-10, 30, 6, &[1, 4], &[7, 22], BOUNDS).unwrap();
        let flat_left = (-20_i64..=40)
            .filter(|&value| matches!(value.rem_euclid(7), 0 | 2 | 5) && ![-14, 9].contains(&value))
            .collect::<Vec<_>>();
        let flat_right = (-10_i64..=30)
            .filter(|&value| matches!(value.rem_euclid(6), 1 | 4) && ![7, 22].contains(&value))
            .collect::<Vec<_>>();
        for target in -40..=75 {
            let expected = flat_left
                .iter()
                .filter(|&&value| {
                    let complement = i128::from(target) - i128::from(value);
                    i64::try_from(complement)
                        .is_ok_and(|value| flat_right.binary_search(&value).is_ok())
                })
                .count() as u64;
            let certificate = left.sum_certificate(&right, target);
            assert_eq!(certificate.pair_count, expected);
            assert_eq!(certificate.witness.is_some(), expected != 0);
            left.verify_sum_certificate(&right, certificate).unwrap();
            let mut forged = certificate;
            forged.pair_count = forged.pair_count.saturating_add(1);
            assert_eq!(
                left.verify_sum_certificate(&right, forged),
                Err(StructuredSetError::InvalidCertificate)
            );
        }
    }

    #[test]
    fn small_residue_presentations_match_direct_enumeration() {
        for modulus in 1_u16..=5 {
            for mask in 1_u16..(1_u16 << modulus) {
                let residues = (0..modulus)
                    .filter(|&residue| mask & (1 << residue) != 0)
                    .collect::<Vec<_>>();
                let base = (-7_i64..=9)
                    .filter(|&value| {
                        residues.contains(&(value.rem_euclid(i64::from(modulus)) as u16))
                    })
                    .collect::<Vec<_>>();
                let holes = base
                    .get(base.len() / 2)
                    .copied()
                    .into_iter()
                    .collect::<Vec<_>>();
                let expected = base
                    .iter()
                    .copied()
                    .filter(|value| holes.binary_search(value).is_err())
                    .collect::<Vec<_>>();
                let set = StructuredIntegerSet::compile(-7, 9, modulus, &residues, &holes, BOUNDS)
                    .unwrap();
                assert_eq!(set.cardinality(), expected.len() as u64);
                assert_eq!(set.iter().collect::<Vec<_>>(), expected);
            }
        }
    }

    #[test]
    fn hot_membership_and_sum_replay_allocate_nothing() {
        let left =
            StructuredIntegerSet::compile(-200, 300, 11, &[0, 3, 7], &[-198, 77], BOUNDS).unwrap();
        let right =
            StructuredIntegerSet::compile(-100, 250, 13, &[1, 4, 9], &[17, 108], BOUNDS).unwrap();
        let (checksum, events) = measure_current_thread_allocations(|| {
            let mut checksum = 0_u64;
            for target in -250..250 {
                let certificate = left.sum_certificate(&right, target);
                left.verify_sum_certificate(&right, certificate).unwrap();
                checksum = checksum.wrapping_add(certificate.pair_count);
            }
            checksum
        });
        assert_ne!(checksum, 0);
        assert_eq!(events.allocations, 0);
        assert_eq!(events.reallocations, 0);
        assert_eq!(events.deallocations, 0);
    }

    #[test]
    fn malformed_presentations_fail_closed() {
        assert_eq!(
            StructuredIntegerSet::compile(0, 10, 3, &[1, 1], &[], BOUNDS),
            Err(StructuredSetError::InvalidResidues)
        );
        assert_eq!(
            StructuredIntegerSet::compile(0, 10, 3, &[1], &[2], BOUNDS),
            Err(StructuredSetError::InvalidHoles)
        );
        assert_eq!(
            StructuredIntegerSet::compile(
                i64::MIN,
                i64::MAX,
                1,
                &[0],
                &[],
                StructuredSetBounds {
                    maximum_span: u64::MAX,
                    ..BOUNDS
                },
            ),
            Err(StructuredSetError::InvalidInterval)
        );
    }
}
