//! Private foundations for tactical-decomposition completion campaigns.
//!
//! This module owns design arithmetic and the reusable level-2 permutation
//! quotient. Orbit-matrix equations and completion adapters remain campaign
//! supplied until a second domain validates a stable public abstraction.

use thiserror::Error;

#[derive(Clone, Copy, Debug, PartialEq, Eq, Error)]
pub enum TacticalCompletionError {
    #[error("tactical design parameters do not define integral 2-design counts")]
    InvalidDesign,
    #[error("the requested action prime is not prime")]
    InvalidPrime,
    #[error("permutation degree exceeds the compact u8 representation")]
    DegreeTooLarge,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TacticalDesignParameters {
    pub points: u32,
    pub block_size: u32,
    pub lambda: u32,
    pub action_prime: u32,
    pub replication: u32,
    pub blocks: u32,
}

impl TacticalDesignParameters {
    pub fn new(
        points: u32,
        block_size: u32,
        lambda: u32,
        action_prime: u32,
    ) -> Result<Self, TacticalCompletionError> {
        if points < 2 || block_size < 2 || block_size > points || lambda == 0 {
            return Err(TacticalCompletionError::InvalidDesign);
        }
        if !is_prime(action_prime) {
            return Err(TacticalCompletionError::InvalidPrime);
        }
        let replication_numerator = u64::from(lambda) * u64::from(points - 1);
        let replication_denominator = u64::from(block_size - 1);
        if !replication_numerator.is_multiple_of(replication_denominator) {
            return Err(TacticalCompletionError::InvalidDesign);
        }
        let replication = replication_numerator / replication_denominator;
        let block_numerator = u64::from(points) * replication;
        if !block_numerator.is_multiple_of(u64::from(block_size)) {
            return Err(TacticalCompletionError::InvalidDesign);
        }
        let blocks = block_numerator / u64::from(block_size);
        Ok(Self {
            points,
            block_size,
            lambda,
            action_prime,
            replication: u32::try_from(replication)
                .map_err(|_| TacticalCompletionError::InvalidDesign)?,
            blocks: u32::try_from(blocks).map_err(|_| TacticalCompletionError::InvalidDesign)?,
        })
    }
}

/// One canonical level-2 permutation under residual conjugation.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct LevelTwoClass {
    pub cycle_lengths: Box<[usize]>,
    pub permutation: Box<[u8]>,
}

/// One representative per conjugacy class of `S_degree`.
///
/// If `distinguished_zero` is true, conjugation fixes label zero. The cycle
/// containing zero is placed first and its length is retained in the class
/// invariant. Integer partitions are generated iteratively, not recursively.
pub fn level_two_classes(
    degree: usize,
    distinguished_zero: bool,
) -> Result<Box<[LevelTwoClass]>, TacticalCompletionError> {
    if degree > usize::from(u8::MAX) {
        return Err(TacticalCompletionError::DegreeTooLarge);
    }
    let mut classes = Vec::new();
    if distinguished_zero {
        for lead in 1..=degree {
            for rest in integer_partitions(degree - lead) {
                let mut cycles = Vec::with_capacity(rest.len() + 1);
                cycles.push(lead);
                cycles.extend_from_slice(&rest);
                classes.push(class_from_cycles(cycles, degree));
            }
        }
    } else {
        for cycles in integer_partitions(degree) {
            classes.push(class_from_cycles(cycles, degree));
        }
    }
    Ok(classes.into_boxed_slice())
}

fn class_from_cycles(cycles: Vec<usize>, degree: usize) -> LevelTwoClass {
    let mut permutation = vec![0u8; degree];
    let mut base = 0usize;
    for &length in &cycles {
        for offset in 0..length {
            permutation[base + offset] = (base + (offset + 1) % length) as u8;
        }
        base += length;
    }
    LevelTwoClass {
        cycle_lengths: cycles.into_boxed_slice(),
        permutation: permutation.into_boxed_slice(),
    }
}

fn integer_partitions(target: usize) -> Vec<Vec<usize>> {
    if target == 0 {
        return vec![Vec::new()];
    }
    let mut storage = vec![0usize; target + 1];
    let mut length = 1usize;
    storage[0] = target;
    let mut partitions = Vec::new();
    loop {
        partitions.push(storage[..length].to_vec());
        let mut remainder = 0usize;
        while length != 0 && storage[length - 1] == 1 {
            remainder += 1;
            length -= 1;
        }
        if length == 0 {
            break;
        }
        storage[length - 1] -= 1;
        remainder += 1;
        while remainder > storage[length - 1] {
            storage[length] = storage[length - 1];
            remainder -= storage[length];
            length += 1;
        }
        storage[length] = remainder;
        length += 1;
    }
    partitions
}

fn is_prime(value: u32) -> bool {
    if value < 2 {
        return false;
    }
    let mut divisor = 2u32;
    while u64::from(divisor) * u64::from(divisor) <= u64::from(value) {
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
    fn plane_parameters_derive_the_symmetric_design_counts() {
        let design = TacticalDesignParameters::new(183, 14, 1, 13).unwrap();
        assert_eq!(design.replication, 14);
        assert_eq!(design.blocks, 183);
        assert!(TacticalDesignParameters::new(183, 14, 1, 12).is_err());
    }

    #[test]
    fn level_two_classes_match_partition_counts_and_valid_permutations() {
        let ordinary = level_two_classes(4, false).unwrap();
        assert_eq!(ordinary.len(), 5);
        let distinguished = level_two_classes(4, true).unwrap();
        assert_eq!(distinguished.len(), 7);
        for class in ordinary.iter().chain(distinguished.iter()) {
            let mut image = class.permutation.to_vec();
            image.sort_unstable();
            assert_eq!(image, [0, 1, 2, 3]);
            assert_eq!(class.cycle_lengths.iter().sum::<usize>(), 4);
        }
    }
}
