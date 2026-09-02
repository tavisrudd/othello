//! Bounded permutation-invariant aggregation over typed feature groups.
//!
//! Plans are compiled and validated off path. Repeated row evaluation writes
//! into caller-owned storage without allocation or recursion.

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const MAX_AGGREGATION_INPUTS: usize = 4_096;
pub const MAX_AGGREGATION_GROUPS: usize = 64;
pub const MAX_AGGREGATION_MEMBERS: usize = 256;
pub const MAX_AGGREGATION_OUTPUTS: usize = 512;
pub const GROUP_AGGREGATION_SNAPSHOT_VERSION: u16 = 1;

#[derive(Clone, Copy, Debug, Deserialize, Eq, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(tag = "op", rename_all = "kebab-case", deny_unknown_fields)]
pub enum GroupAggregateOp {
    Sum,
    SumSquares,
    Minimum,
    Maximum,
    CountEqual { value: i64 },
    EqualPairCount,
    DistinctCount,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct GroupAggregateSpec {
    pub members: Box<[u16]>,
    pub operations: Box<[GroupAggregateOp]>,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct GroupAggregationBounds {
    pub maximum_groups: usize,
    pub maximum_members_per_group: usize,
    pub maximum_outputs: usize,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct GroupAggregationPlan {
    input_width: u16,
    output_width: u16,
    groups: Box<[GroupAggregateSpec]>,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct GroupAggregationPlanSnapshot {
    pub version: u16,
    pub input_width: u16,
    pub groups: Box<[GroupAggregateSpec]>,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum GroupAggregationError {
    #[error("group aggregation bounds are invalid")]
    InvalidBounds,
    #[error("group aggregation input width is invalid")]
    InvalidInputWidth,
    #[error("group aggregation specification is empty or exceeds its bound")]
    InvalidSpecification,
    #[error("group aggregation members are out of range or noncanonical")]
    InvalidMembers,
    #[error("group aggregation operations are noncanonical")]
    InvalidOperations,
    #[error("group aggregation row or output has the wrong width")]
    Shape,
    #[error("group aggregation arithmetic overflowed")]
    ArithmeticOverflow,
    #[error("group aggregation snapshot version is unsupported")]
    SnapshotVersion,
}

impl GroupAggregationPlan {
    pub fn compile(
        input_width: usize,
        groups: &[GroupAggregateSpec],
        bounds: GroupAggregationBounds,
    ) -> Result<Self, GroupAggregationError> {
        if input_width == 0
            || input_width > MAX_AGGREGATION_INPUTS
            || bounds.maximum_groups == 0
            || bounds.maximum_groups > MAX_AGGREGATION_GROUPS
            || bounds.maximum_members_per_group == 0
            || bounds.maximum_members_per_group > MAX_AGGREGATION_MEMBERS
            || bounds.maximum_outputs == 0
            || bounds.maximum_outputs > MAX_AGGREGATION_OUTPUTS
        {
            return Err(GroupAggregationError::InvalidBounds);
        }
        if groups.is_empty() || groups.len() > bounds.maximum_groups {
            return Err(GroupAggregationError::InvalidSpecification);
        }
        let mut output_width = 0_usize;
        for group in groups {
            if group.members.is_empty()
                || group.members.len() > bounds.maximum_members_per_group
                || group.members.windows(2).any(|pair| pair[0] >= pair[1])
                || group
                    .members
                    .last()
                    .is_some_and(|&index| usize::from(index) >= input_width)
            {
                return Err(GroupAggregationError::InvalidMembers);
            }
            if group.operations.is_empty()
                || group.operations.windows(2).any(|pair| pair[0] >= pair[1])
            {
                return Err(GroupAggregationError::InvalidOperations);
            }
            output_width = output_width
                .checked_add(group.operations.len())
                .ok_or(GroupAggregationError::InvalidSpecification)?;
        }
        if output_width > bounds.maximum_outputs {
            return Err(GroupAggregationError::InvalidSpecification);
        }
        Ok(Self {
            input_width: u16::try_from(input_width)
                .map_err(|_| GroupAggregationError::InvalidInputWidth)?,
            output_width: u16::try_from(output_width)
                .map_err(|_| GroupAggregationError::InvalidSpecification)?,
            groups: groups.into(),
        })
    }

    pub fn input_width(&self) -> usize {
        usize::from(self.input_width)
    }

    pub fn output_width(&self) -> usize {
        usize::from(self.output_width)
    }

    pub fn groups(&self) -> &[GroupAggregateSpec] {
        &self.groups
    }

    pub fn snapshot(&self) -> GroupAggregationPlanSnapshot {
        GroupAggregationPlanSnapshot {
            version: GROUP_AGGREGATION_SNAPSHOT_VERSION,
            input_width: self.input_width,
            groups: self.groups.clone(),
        }
    }

    pub fn from_snapshot(
        snapshot: &GroupAggregationPlanSnapshot,
        bounds: GroupAggregationBounds,
    ) -> Result<Self, GroupAggregationError> {
        if snapshot.version != GROUP_AGGREGATION_SNAPSHOT_VERSION {
            return Err(GroupAggregationError::SnapshotVersion);
        }
        Self::compile(usize::from(snapshot.input_width), &snapshot.groups, bounds)
    }

    pub fn evaluate<'a>(
        &self,
        inputs: &[i64],
        outputs: &'a mut [i64],
    ) -> Result<&'a [i64], GroupAggregationError> {
        if inputs.len() != self.input_width() || outputs.len() != self.output_width() {
            return Err(GroupAggregationError::Shape);
        }
        let mut output = 0;
        for group in &self.groups {
            for &operation in &group.operations {
                outputs[output] = evaluate_operation(operation, &group.members, inputs)?;
                output += 1;
            }
        }
        Ok(outputs)
    }

    pub fn evaluate_rows(
        &self,
        inputs: &[i64],
        rows: usize,
        outputs: &mut [i64],
    ) -> Result<(), GroupAggregationError> {
        let input_cells = rows
            .checked_mul(self.input_width())
            .ok_or(GroupAggregationError::Shape)?;
        let output_cells = rows
            .checked_mul(self.output_width())
            .ok_or(GroupAggregationError::Shape)?;
        if rows == 0 || inputs.len() != input_cells || outputs.len() != output_cells {
            return Err(GroupAggregationError::Shape);
        }
        for (input, output) in inputs
            .chunks_exact(self.input_width())
            .zip(outputs.chunks_exact_mut(self.output_width()))
        {
            self.evaluate(input, output)?;
        }
        Ok(())
    }
}

fn evaluate_operation(
    operation: GroupAggregateOp,
    members: &[u16],
    inputs: &[i64],
) -> Result<i64, GroupAggregationError> {
    let value = |index: usize| inputs[usize::from(members[index])];
    match operation {
        GroupAggregateOp::Sum => {
            let mut sum = 0_i64;
            for index in 0..members.len() {
                sum = sum
                    .checked_add(value(index))
                    .ok_or(GroupAggregationError::ArithmeticOverflow)?;
            }
            Ok(sum)
        }
        GroupAggregateOp::SumSquares => {
            let mut sum = 0_i64;
            for index in 0..members.len() {
                let entry = value(index);
                sum = sum
                    .checked_add(
                        entry
                            .checked_mul(entry)
                            .ok_or(GroupAggregationError::ArithmeticOverflow)?,
                    )
                    .ok_or(GroupAggregationError::ArithmeticOverflow)?;
            }
            Ok(sum)
        }
        GroupAggregateOp::Minimum => Ok((0..members.len()).map(value).min().unwrap()),
        GroupAggregateOp::Maximum => Ok((0..members.len()).map(value).max().unwrap()),
        GroupAggregateOp::CountEqual { value: target } => Ok(i64::try_from(
            (0..members.len())
                .filter(|&index| value(index) == target)
                .count(),
        )
        .expect("bounded group size fits i64")),
        GroupAggregateOp::EqualPairCount => {
            let mut pairs = 0_i64;
            for right in 1..members.len() {
                for left in 0..right {
                    pairs += i64::from(value(left) == value(right));
                }
            }
            Ok(pairs)
        }
        GroupAggregateOp::DistinctCount => {
            let mut distinct = 0_i64;
            for right in 0..members.len() {
                let duplicate = (0..right).any(|left| value(left) == value(right));
                distinct += i64::from(!duplicate);
            }
            Ok(distinct)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const BOUNDS: GroupAggregationBounds = GroupAggregationBounds {
        maximum_groups: 4,
        maximum_members_per_group: 16,
        maximum_outputs: 16,
    };

    fn seven_member_plan() -> GroupAggregationPlan {
        GroupAggregationPlan::compile(
            7,
            &[GroupAggregateSpec {
                members: (0_u16..7).collect::<Vec<_>>().into_boxed_slice(),
                operations: vec![
                    GroupAggregateOp::Sum,
                    GroupAggregateOp::SumSquares,
                    GroupAggregateOp::Minimum,
                    GroupAggregateOp::Maximum,
                    GroupAggregateOp::CountEqual { value: 2 },
                    GroupAggregateOp::EqualPairCount,
                    GroupAggregateOp::DistinctCount,
                ]
                .into_boxed_slice(),
            }],
            BOUNDS,
        )
        .unwrap()
    }

    #[test]
    fn seven_member_aggregates_are_permutation_invariant() {
        let plan = seven_member_plan();
        let mut left = [0_i64; 7];
        let mut right = [0_i64; 7];
        plan.evaluate(&[2, -1, 2, 4, 0, -1, 3], &mut left).unwrap();
        plan.evaluate(&[3, 2, -1, 0, 4, 2, -1], &mut right).unwrap();
        assert_eq!(left, right);
        assert_eq!(left, [9, 35, -1, 4, 2, 2, 5]);
        let snapshot = plan.snapshot();
        let encoded = serde_json::to_vec(&snapshot).unwrap();
        let decoded: GroupAggregationPlanSnapshot = serde_json::from_slice(&encoded).unwrap();
        let restored = GroupAggregationPlan::from_snapshot(&decoded, BOUNDS).unwrap();
        assert_eq!(restored, plan);

        let mut rows = [0_i64; 14];
        plan.evaluate_rows(
            &[2, -1, 2, 4, 0, -1, 3, 3, 2, -1, 0, 4, 2, -1],
            2,
            &mut rows,
        )
        .unwrap();
        assert_eq!(&rows[..7], &rows[7..]);
    }

    #[test]
    fn rejects_noncanonical_scopes_and_operations() {
        let duplicate_members = GroupAggregateSpec {
            members: vec![0, 0].into_boxed_slice(),
            operations: vec![GroupAggregateOp::Sum].into_boxed_slice(),
        };
        assert_eq!(
            GroupAggregationPlan::compile(2, &[duplicate_members], BOUNDS),
            Err(GroupAggregationError::InvalidMembers)
        );
        let duplicate_operations = GroupAggregateSpec {
            members: vec![0].into_boxed_slice(),
            operations: vec![GroupAggregateOp::Sum, GroupAggregateOp::Sum].into_boxed_slice(),
        };
        assert_eq!(
            GroupAggregationPlan::compile(2, &[duplicate_operations], BOUNDS),
            Err(GroupAggregationError::InvalidOperations)
        );
    }

    #[test]
    fn repeated_evaluation_allocates_nothing() {
        let plan = seven_member_plan();
        let input = [2, -1, 2, 4, 0, -1, 3];
        let mut output = [0_i64; 7];
        let (_, events) = crate::test_alloc::measure_current_thread_allocations(|| {
            for _ in 0..1_000 {
                std::hint::black_box(plan.evaluate(&input, &mut output).unwrap());
            }
        });
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn arithmetic_and_snapshot_fail_closed() {
        let plan = GroupAggregationPlan::compile(
            2,
            &[GroupAggregateSpec {
                members: vec![0, 1].into_boxed_slice(),
                operations: vec![GroupAggregateOp::Sum].into_boxed_slice(),
            }],
            BOUNDS,
        )
        .unwrap();
        assert_eq!(
            plan.evaluate(&[i64::MAX, 1], &mut [0]),
            Err(GroupAggregationError::ArithmeticOverflow)
        );
        let mut snapshot = plan.snapshot();
        snapshot.version += 1;
        assert_eq!(
            GroupAggregationPlan::from_snapshot(&snapshot, BOUNDS),
            Err(GroupAggregationError::SnapshotVersion)
        );
    }
}
