//! Bounded exact indexing of dense equivalence fibres.
//!
//! A representative is not evidence that a predicate is constant on its
//! fibre.  This module keeps that distinction in the type system and provides
//! a compact CSR index when every member must be retained and examined.

use thiserror::Error;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct DenseFibreBounds {
    pub max_keys: usize,
    pub max_members: usize,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum DenseFibreError {
    #[error("dense fibre bounds must be positive")]
    EmptyBound,
    #[error("dense fibre index exceeds a configured or representable bound")]
    TooLarge,
    #[error("member {member} has key {key}, outside the dense key range 0..{key_count}")]
    InvalidKey {
        member: u32,
        key: u32,
        key_count: u32,
    },
    #[error("dense fibre index has an invalid CSR shape")]
    InvalidShape,
    #[error("member {member} occurs more than once in the dense fibre index")]
    DuplicateMember { member: u32 },
    #[error("member {member} is absent from the dense fibre index")]
    MissingMember { member: u32 },
    #[error(
        "member {member} is stored under key {stored_key}, but its source key is {source_key}"
    )]
    MisclassifiedMember {
        member: u32,
        stored_key: u32,
        source_key: u32,
    },
}

/// An explicitly non-exhaustive choice of one member from a fibre.
#[repr(transparent)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FibreRepresentative(u32);

const _: () = assert!(std::mem::size_of::<FibreRepresentative>() == 4);
const _: () = assert!(std::mem::align_of::<FibreRepresentative>() == 4);

impl FibreRepresentative {
    pub fn member(self) -> u32 {
        self.0
    }
}

/// Every source member carrying one dense key, in source order.
#[repr(transparent)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct ExhaustiveFibre<'a>(&'a [u32]);

const _: () = assert!(std::mem::size_of::<ExhaustiveFibre<'static>>() == 16);
const _: () = assert!(std::mem::align_of::<ExhaustiveFibre<'static>>() == 8);

impl<'a> ExhaustiveFibre<'a> {
    pub fn members(self) -> &'a [u32] {
        self.0
    }

    pub fn len(self) -> usize {
        self.0.len()
    }

    pub fn is_empty(self) -> bool {
        self.0.is_empty()
    }

    pub fn iter(self) -> impl ExactSizeIterator<Item = u32> + 'a {
        self.0.iter().copied()
    }
}

/// Compact row-oriented index of every source member in every dense fibre.
///
/// Construction is cold and bounded. Querying returns borrowed ranges and
/// performs no allocation. Members inside each fibre retain source order.
#[repr(C)]
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct DenseFibreIndex {
    offsets: Box<[u32]>,
    members: Box<[u32]>,
}

const _: () = assert!(std::mem::size_of::<DenseFibreIndex>() == 32);
const _: () = assert!(std::mem::align_of::<DenseFibreIndex>() == 8);

impl DenseFibreIndex {
    pub fn key_count(&self) -> usize {
        self.offsets.len() - 1
    }

    pub fn member_count(&self) -> usize {
        self.members.len()
    }

    pub fn fibre(&self, key: u32) -> Option<ExhaustiveFibre<'_>> {
        let key = usize::try_from(key).ok()?;
        let end = *self.offsets.get(key + 1)? as usize;
        let start = self.offsets[key] as usize;
        Some(ExhaustiveFibre(&self.members[start..end]))
    }

    /// Return one explicitly non-exhaustive member, if the fibre is nonempty.
    pub fn representative(&self, key: u32) -> Option<FibreRepresentative> {
        self.fibre(key)?
            .members()
            .first()
            .copied()
            .map(FibreRepresentative)
    }

    pub fn offsets(&self) -> &[u32] {
        &self.offsets
    }

    pub fn members(&self) -> &[u32] {
        &self.members
    }
}

/// Compile a stable, exhaustive CSR partition from one dense key per member.
///
/// The member identity is its position in `keys`. Empty fibres are retained.
/// The implementation uses exactly two output allocations and no per-fibre
/// container.
pub fn compile_dense_fibres(
    keys: &[u32],
    key_count: u32,
    bounds: DenseFibreBounds,
) -> Result<DenseFibreIndex, DenseFibreError> {
    if bounds.max_keys == 0 || bounds.max_members == 0 {
        return Err(DenseFibreError::EmptyBound);
    }
    let key_count_usize = usize::try_from(key_count).map_err(|_| DenseFibreError::TooLarge)?;
    if key_count_usize > bounds.max_keys
        || keys.len() > bounds.max_members
        || keys.len() > u32::MAX as usize
        || key_count_usize.checked_add(1).is_none()
    {
        return Err(DenseFibreError::TooLarge);
    }

    let mut offsets = vec![0_u32; key_count_usize + 1];
    for (member, &key) in keys.iter().enumerate() {
        let count = usize::try_from(key)
            .ok()
            .and_then(|key| key.checked_add(1))
            .and_then(|key| offsets.get_mut(key));
        let Some(count) = count else {
            return Err(DenseFibreError::InvalidKey {
                member: member as u32,
                key,
                key_count,
            });
        };
        *count = count.checked_add(1).ok_or(DenseFibreError::TooLarge)?;
    }
    for key in 0..key_count_usize {
        offsets[key + 1] = offsets[key + 1]
            .checked_add(offsets[key])
            .ok_or(DenseFibreError::TooLarge)?;
    }

    let mut members = vec![0_u32; keys.len()];
    for (member, &key) in keys.iter().enumerate().rev() {
        let end = &mut offsets[key as usize + 1];
        *end -= 1;
        members[*end as usize] = member as u32;
    }
    for key in 0..key_count_usize {
        offsets[key] = offsets[key + 1];
    }
    offsets[key_count_usize] = keys.len() as u32;

    Ok(DenseFibreIndex {
        offsets: offsets.into_boxed_slice(),
        members: members.into_boxed_slice(),
    })
}

/// Independently replay the CSR partition against its source keys.
pub fn verify_dense_fibres(keys: &[u32], index: &DenseFibreIndex) -> Result<(), DenseFibreError> {
    if index.offsets.is_empty()
        || index.offsets[0] != 0
        || index.offsets.last().copied() != Some(index.members.len() as u32)
        || index.members.len() != keys.len()
        || index.offsets.windows(2).any(|pair| pair[0] > pair[1])
    {
        return Err(DenseFibreError::InvalidShape);
    }
    let mut seen = vec![false; keys.len()];
    for key in 0..index.key_count() {
        let fibre = index
            .fibre(key as u32)
            .ok_or(DenseFibreError::InvalidShape)?;
        for member in fibre.iter() {
            let member_index = member as usize;
            let Some(source_key) = keys.get(member_index).copied() else {
                return Err(DenseFibreError::InvalidShape);
            };
            if std::mem::replace(&mut seen[member_index], true) {
                return Err(DenseFibreError::DuplicateMember { member });
            }
            if source_key != key as u32 {
                return Err(DenseFibreError::MisclassifiedMember {
                    member,
                    stored_key: key as u32,
                    source_key,
                });
            }
        }
    }
    if let Some(member) = seen.iter().position(|&present| !present) {
        return Err(DenseFibreError::MissingMember {
            member: member as u32,
        });
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_alloc::{measure_allocations, HotLoopAllocationGuard};

    const BOUNDS: DenseFibreBounds = DenseFibreBounds {
        max_keys: 16,
        max_members: 256,
    };

    #[test]
    fn retains_every_member_in_source_order() {
        let keys = [2, 0, 2, 1, 2, 0];
        let index = compile_dense_fibres(&keys, 4, BOUNDS).unwrap();
        assert_eq!(index.fibre(0).unwrap().members(), &[1, 5]);
        assert_eq!(index.fibre(1).unwrap().members(), &[3]);
        assert_eq!(index.fibre(2).unwrap().members(), &[0, 2, 4]);
        assert!(index.fibre(3).unwrap().is_empty());
        assert!(index.fibre(4).is_none());
        assert_eq!(index.representative(2).unwrap().member(), 0);
        verify_dense_fibres(&keys, &index).unwrap();
    }

    #[test]
    fn exhaustive_fibre_detects_a_property_missed_by_its_representative() {
        let index = compile_dense_fibres(&[0, 0], 1, BOUNDS).unwrap();
        let property = [false, true];
        assert!(!property[index.representative(0).unwrap().member() as usize]);
        assert!(index
            .fibre(0)
            .unwrap()
            .iter()
            .any(|member| property[member as usize]));
    }

    #[test]
    fn bounded_exhaustive_oracle_matches_direct_grouping() {
        for member_count in 0..=6 {
            for key_count in 1_u32..=3 {
                let assignments = usize::pow(key_count as usize, member_count as u32);
                for mut code in 0..assignments {
                    let mut keys = vec![0_u32; member_count];
                    for key in &mut keys {
                        *key = (code % key_count as usize) as u32;
                        code /= key_count as usize;
                    }
                    let index = compile_dense_fibres(&keys, key_count, BOUNDS).unwrap();
                    verify_dense_fibres(&keys, &index).unwrap();
                    for key in 0..key_count {
                        let direct = keys
                            .iter()
                            .enumerate()
                            .filter_map(|(member, &source_key)| {
                                (source_key == key).then_some(member as u32)
                            })
                            .collect::<Vec<_>>();
                        assert_eq!(index.fibre(key).unwrap().members(), direct);
                    }
                }
            }
        }
    }

    #[test]
    fn malformed_inputs_and_partitions_fail_closed() {
        assert_eq!(
            compile_dense_fibres(
                &[0],
                1,
                DenseFibreBounds {
                    max_keys: 0,
                    max_members: 1,
                }
            ),
            Err(DenseFibreError::EmptyBound)
        );
        assert!(matches!(
            compile_dense_fibres(&[1], 1, BOUNDS),
            Err(DenseFibreError::InvalidKey { .. })
        ));

        let keys = [0, 1];
        let mut duplicate = compile_dense_fibres(&keys, 2, BOUNDS).unwrap();
        duplicate.members[1] = 0;
        assert_eq!(
            verify_dense_fibres(&keys, &duplicate),
            Err(DenseFibreError::DuplicateMember { member: 0 })
        );

        let mut misclassified = compile_dense_fibres(&keys, 2, BOUNDS).unwrap();
        misclassified.members.swap(0, 1);
        assert!(matches!(
            verify_dense_fibres(&keys, &misclassified),
            Err(DenseFibreError::MisclassifiedMember { .. })
        ));
    }

    #[test]
    fn repeated_queries_allocate_nothing() {
        let index = compile_dense_fibres(&[2, 0, 2, 1, 2, 0], 4, BOUNDS).unwrap();
        let (checksum, events) = measure_allocations(|| {
            let _guard = HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for _ in 0..100_000 {
                for key in 0..4 {
                    for member in index.fibre(key).unwrap().iter() {
                        checksum = checksum.wrapping_add(u64::from(member) + u64::from(key));
                    }
                }
            }
            checksum
        });
        assert_ne!(checksum, 0);
        assert_eq!(events.allocations, 0);
        assert_eq!(events.reallocations, 0);
        assert_eq!(events.deallocations, 0);
    }
}
