//! Exact finite-value histograms and structural aggregate identities.
//!
//! A compiled domain turns a bounded group into multiplicities. The universal
//! count identities then reconstruct its basic symmetric aggregates. Repeated
//! evaluation uses caller-owned counts and allocates nothing.

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const GROUP_HISTOGRAM_SNAPSHOT_VERSION: u16 = 1;
pub const MAX_GROUP_HISTOGRAM_INPUTS: usize = 4_096;
pub const MAX_GROUP_HISTOGRAM_MEMBERS: usize = 256;
pub const MAX_GROUP_HISTOGRAM_VALUES: usize = 256;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct GroupHistogramBounds {
    pub maximum_members: usize,
    pub maximum_values: usize,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct GroupHistogramSummary {
    pub sum: i64,
    pub sum_squares: i64,
    pub equal_pair_count: u32,
    pub member_count: u16,
    pub distinct_count: u16,
}

const _: () = assert!(std::mem::size_of::<GroupHistogramSummary>() == 24);
const _: () = assert!(std::mem::align_of::<GroupHistogramSummary>() == 8);

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct GroupHistogramSnapshot {
    pub version: u16,
    pub input_width: u16,
    pub members: Box<[u16]>,
    pub values: Box<[i64]>,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct GroupHistogramPlan {
    input_width: u16,
    members: Box<[u16]>,
    values: Box<[i64]>,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct GroupHistogramCertificate {
    pub summary: GroupHistogramSummary,
    pub counts: Box<[u16]>,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum GroupHistogramError {
    #[error("group histogram bounds are invalid")]
    InvalidBounds,
    #[error("group histogram input width is invalid")]
    InvalidInputWidth,
    #[error("group histogram members are empty, out of range, or noncanonical")]
    InvalidMembers,
    #[error("group histogram values are empty or noncanonical")]
    InvalidValues,
    #[error("group histogram row or count workspace has the wrong width")]
    Shape,
    #[error("group histogram encountered a value outside its declared finite domain")]
    ValueOutsideDomain,
    #[error("group histogram arithmetic overflowed")]
    ArithmeticOverflow,
    #[error("group histogram snapshot version is unsupported")]
    SnapshotVersion,
    #[error("group histogram certificate does not replay")]
    InvalidCertificate,
}

impl GroupHistogramPlan {
    pub fn compile(
        input_width: usize,
        members: &[u16],
        values: &[i64],
        bounds: GroupHistogramBounds,
    ) -> Result<Self, GroupHistogramError> {
        if bounds.maximum_members == 0
            || bounds.maximum_members > MAX_GROUP_HISTOGRAM_MEMBERS
            || bounds.maximum_values == 0
            || bounds.maximum_values > MAX_GROUP_HISTOGRAM_VALUES
        {
            return Err(GroupHistogramError::InvalidBounds);
        }
        if input_width == 0 || input_width > MAX_GROUP_HISTOGRAM_INPUTS {
            return Err(GroupHistogramError::InvalidInputWidth);
        }
        if members.is_empty()
            || members.len() > bounds.maximum_members
            || members.windows(2).any(|pair| pair[0] >= pair[1])
            || members
                .last()
                .is_some_and(|&member| usize::from(member) >= input_width)
        {
            return Err(GroupHistogramError::InvalidMembers);
        }
        if values.is_empty()
            || values.len() > bounds.maximum_values
            || values.windows(2).any(|pair| pair[0] >= pair[1])
        {
            return Err(GroupHistogramError::InvalidValues);
        }
        Ok(Self {
            input_width: u16::try_from(input_width)
                .map_err(|_| GroupHistogramError::InvalidInputWidth)?,
            members: members.into(),
            values: values.into(),
        })
    }

    pub fn from_snapshot(
        snapshot: &GroupHistogramSnapshot,
        bounds: GroupHistogramBounds,
    ) -> Result<Self, GroupHistogramError> {
        if snapshot.version != GROUP_HISTOGRAM_SNAPSHOT_VERSION {
            return Err(GroupHistogramError::SnapshotVersion);
        }
        Self::compile(
            usize::from(snapshot.input_width),
            &snapshot.members,
            &snapshot.values,
            bounds,
        )
    }

    pub fn snapshot(&self) -> GroupHistogramSnapshot {
        GroupHistogramSnapshot {
            version: GROUP_HISTOGRAM_SNAPSHOT_VERSION,
            input_width: self.input_width,
            members: self.members.clone(),
            values: self.values.clone(),
        }
    }

    pub fn value_count(&self) -> usize {
        self.values.len()
    }

    pub fn evaluate(
        &self,
        inputs: &[i64],
        counts: &mut [u16],
    ) -> Result<GroupHistogramSummary, GroupHistogramError> {
        if inputs.len() != usize::from(self.input_width) || counts.len() != self.values.len() {
            return Err(GroupHistogramError::Shape);
        }
        counts.fill(0);
        for &member in &self.members {
            let value = inputs[usize::from(member)];
            let index = self
                .values
                .binary_search(&value)
                .map_err(|_| GroupHistogramError::ValueOutsideDomain)?;
            counts[index] = counts[index]
                .checked_add(1)
                .ok_or(GroupHistogramError::ArithmeticOverflow)?;
        }
        summary_from_counts(&self.values, counts)
    }

    pub fn certificate(
        &self,
        inputs: &[i64],
    ) -> Result<GroupHistogramCertificate, GroupHistogramError> {
        let mut counts = vec![0; self.values.len()].into_boxed_slice();
        let summary = self.evaluate(inputs, &mut counts)?;
        Ok(GroupHistogramCertificate { summary, counts })
    }

    pub fn verify_certificate(
        &self,
        inputs: &[i64],
        workspace: &mut [u16],
        certificate: &GroupHistogramCertificate,
    ) -> Result<(), GroupHistogramError> {
        if certificate.counts.len() != self.values.len() {
            return Err(GroupHistogramError::InvalidCertificate);
        }
        let summary = self.evaluate(inputs, workspace)?;
        if workspace != certificate.counts.as_ref() || summary != certificate.summary {
            return Err(GroupHistogramError::InvalidCertificate);
        }
        Ok(())
    }
}

fn summary_from_counts(
    values: &[i64],
    counts: &[u16],
) -> Result<GroupHistogramSummary, GroupHistogramError> {
    let mut sum = 0_i64;
    let mut sum_squares = 0_i64;
    let mut equal_pair_count = 0_u32;
    let mut member_count = 0_u16;
    let mut distinct_count = 0_u16;
    for (&value, &count) in values.iter().zip(counts) {
        member_count = member_count
            .checked_add(count)
            .ok_or(GroupHistogramError::ArithmeticOverflow)?;
        distinct_count = distinct_count
            .checked_add(u16::from(count != 0))
            .ok_or(GroupHistogramError::ArithmeticOverflow)?;
        let count_i64 = i64::from(count);
        sum = sum
            .checked_add(
                value
                    .checked_mul(count_i64)
                    .ok_or(GroupHistogramError::ArithmeticOverflow)?,
            )
            .ok_or(GroupHistogramError::ArithmeticOverflow)?;
        let square = value
            .checked_mul(value)
            .ok_or(GroupHistogramError::ArithmeticOverflow)?;
        sum_squares = sum_squares
            .checked_add(
                square
                    .checked_mul(count_i64)
                    .ok_or(GroupHistogramError::ArithmeticOverflow)?,
            )
            .ok_or(GroupHistogramError::ArithmeticOverflow)?;
        let count = u32::from(count);
        equal_pair_count = equal_pair_count
            .checked_add(count * count.saturating_sub(1) / 2)
            .ok_or(GroupHistogramError::ArithmeticOverflow)?;
    }
    Ok(GroupHistogramSummary {
        sum,
        sum_squares,
        equal_pair_count,
        member_count,
        distinct_count,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    const BOUNDS: GroupHistogramBounds = GroupHistogramBounds {
        maximum_members: 16,
        maximum_values: 16,
    };

    fn plan() -> GroupHistogramPlan {
        GroupHistogramPlan::compile(7, &[0, 1, 2, 3, 4, 5, 6], &[-1, 0, 2, 3, 4], BOUNDS).unwrap()
    }

    #[test]
    fn histogram_reconstructs_symmetric_aggregates() {
        let plan = plan();
        let inputs = [2, -1, 2, 4, 0, -1, 3];
        let certificate = plan.certificate(&inputs).unwrap();
        assert_eq!(&*certificate.counts, &[2, 1, 2, 1, 1]);
        assert_eq!(
            certificate.summary,
            GroupHistogramSummary {
                sum: 9,
                sum_squares: 35,
                equal_pair_count: 2,
                member_count: 7,
                distinct_count: 5,
            }
        );
        plan.verify_certificate(&inputs, &mut [0; 5], &certificate)
            .unwrap();
        let snapshot = plan.snapshot();
        assert_eq!(
            GroupHistogramPlan::from_snapshot(&snapshot, BOUNDS).unwrap(),
            plan
        );
    }

    #[test]
    fn unexpected_values_and_forged_counts_fail_closed() {
        let plan = plan();
        assert_eq!(
            plan.evaluate(&[2, -1, 2, 4, 0, -1, 9], &mut [0; 5]),
            Err(GroupHistogramError::ValueOutsideDomain)
        );
        let inputs = [2, -1, 2, 4, 0, -1, 3];
        let mut certificate = plan.certificate(&inputs).unwrap();
        certificate.counts[0] -= 1;
        assert_eq!(
            plan.verify_certificate(&inputs, &mut [0; 5], &certificate),
            Err(GroupHistogramError::InvalidCertificate)
        );
    }

    #[test]
    fn repeated_histogram_evaluation_allocates_nothing() {
        let plan = plan();
        let inputs = [2, -1, 2, 4, 0, -1, 3];
        let mut counts = [0_u16; 5];
        let (_, events) = crate::test_alloc::measure_current_thread_allocations(|| {
            for _ in 0..1_000 {
                std::hint::black_box(plan.evaluate(&inputs, &mut counts).unwrap());
            }
        });
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }
}
