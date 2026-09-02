//! Bounded permutation-invariant aggregation over typed feature groups.
//!
//! Plans are compiled and validated off path. Repeated row evaluation writes
//! into caller-owned storage without allocation or recursion.

use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const MAX_AGGREGATION_INPUTS: usize = 4_096;
pub const MAX_AGGREGATION_GROUPS: usize = 64;
pub const MAX_AGGREGATION_MEMBERS: usize = 256;
pub const MAX_AGGREGATION_OUTPUTS: usize = 512;
pub const GROUP_AGGREGATION_SNAPSHOT_VERSION: u16 = 1;
pub const MAX_AGGREGATION_PROPOSAL_ROWS: usize = 4_096;
pub const MAX_AGGREGATION_PROPOSED_VALUES: usize = 64;
pub const MAX_AGGREGATION_PROPOSAL_CELLS: usize = 1_048_576;

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

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct GroupAggregationProposalBounds {
    pub plan: GroupAggregationBounds,
    pub maximum_rows: usize,
    pub maximum_count_values_per_group: usize,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct GroupScopeProposalBounds {
    pub maximum_rows: usize,
    pub maximum_cells: usize,
    pub maximum_groups: usize,
    pub maximum_members_per_group: usize,
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
    #[error("group aggregation proposal corpus has the wrong shape or exceeds its bound")]
    ProposalCorpus,
    #[error("group scope proposal exceeds its configured bound")]
    ScopeProposalLimit,
}

/// Propose diagnostic groups whose columns have exactly equal empirical marginals.
///
/// Equality is checked on sorted column values after digest bucketing, so hash
/// collisions cannot merge unequal columns. The result suggests coordinates to
/// test; it does not prove a symmetry or exchangeability theorem.
pub fn propose_equal_marginal_scopes(
    input_width: usize,
    rows: &[i64],
    bounds: GroupScopeProposalBounds,
) -> Result<Box<[Box<[u16]>]>, GroupAggregationError> {
    if input_width == 0
        || input_width > MAX_AGGREGATION_INPUTS
        || bounds.maximum_rows == 0
        || bounds.maximum_rows > MAX_AGGREGATION_PROPOSAL_ROWS
        || bounds.maximum_cells == 0
        || bounds.maximum_cells > MAX_AGGREGATION_PROPOSAL_CELLS
        || bounds.maximum_groups == 0
        || bounds.maximum_groups > MAX_AGGREGATION_GROUPS
        || bounds.maximum_members_per_group < 2
        || bounds.maximum_members_per_group > MAX_AGGREGATION_MEMBERS
        || rows.is_empty()
        || rows.len() % input_width != 0
    {
        return Err(GroupAggregationError::ProposalCorpus);
    }
    let row_count = rows.len() / input_width;
    if row_count > bounds.maximum_rows || rows.len() > bounds.maximum_cells {
        return Err(GroupAggregationError::ScopeProposalLimit);
    }
    let mut columns = vec![0_i64; rows.len()];
    for (row_index, row) in rows.chunks_exact(input_width).enumerate() {
        for (column, &value) in row.iter().enumerate() {
            columns[column * row_count + row_index] = value;
        }
    }
    let mut descriptors = Vec::with_capacity(input_width);
    for column in 0..input_width {
        let values = &mut columns[column * row_count..(column + 1) * row_count];
        values.sort_unstable();
        let mut hasher = blake3::Hasher::new();
        hasher.update(b"ergodis-equal-marginal-v1\0");
        for value in values.iter() {
            hasher.update(&value.to_le_bytes());
        }
        descriptors.push((*hasher.finalize().as_bytes(), column));
    }
    descriptors.sort_unstable_by(|left, right| {
        left.0.cmp(&right.0).then_with(|| {
            let left_values = &columns[left.1 * row_count..(left.1 + 1) * row_count];
            let right_values = &columns[right.1 * row_count..(right.1 + 1) * row_count];
            left_values.cmp(right_values)
        })
    });
    let mut scopes = Vec::new();
    let mut start = 0;
    while start < descriptors.len() {
        let (_, representative) = descriptors[start];
        let representative_values =
            &columns[representative * row_count..(representative + 1) * row_count];
        let mut end = start + 1;
        while end < descriptors.len() {
            let (digest, column) = descriptors[end];
            let values = &columns[column * row_count..(column + 1) * row_count];
            if digest != descriptors[start].0 || values != representative_values {
                break;
            }
            end += 1;
        }
        let members = end - start;
        if members >= 2 {
            if members > bounds.maximum_members_per_group || scopes.len() == bounds.maximum_groups {
                return Err(GroupAggregationError::ScopeProposalLimit);
            }
            let mut scope = descriptors[start..end]
                .iter()
                .map(|&(_, column)| u16::try_from(column).expect("bounded input width fits u16"))
                .collect::<Vec<_>>();
            scope.sort_unstable();
            scopes.push(scope.into_boxed_slice());
        }
        start = end;
    }
    scopes.sort_unstable_by(|left, right| left[0].cmp(&right[0]));
    Ok(scopes.into_boxed_slice())
}

impl GroupAggregationPlan {
    pub fn propose_from_rows(
        input_width: usize,
        scopes: &[Box<[u16]>],
        rows: &[i64],
        bounds: GroupAggregationProposalBounds,
    ) -> Result<Self, GroupAggregationError> {
        if input_width == 0
            || input_width > MAX_AGGREGATION_INPUTS
            || bounds.maximum_rows == 0
            || bounds.maximum_rows > MAX_AGGREGATION_PROPOSAL_ROWS
            || bounds.maximum_count_values_per_group > MAX_AGGREGATION_PROPOSED_VALUES
            || bounds.plan.maximum_groups == 0
            || bounds.plan.maximum_groups > MAX_AGGREGATION_GROUPS
            || bounds.plan.maximum_members_per_group == 0
            || bounds.plan.maximum_members_per_group > MAX_AGGREGATION_MEMBERS
            || bounds.plan.maximum_outputs == 0
            || bounds.plan.maximum_outputs > MAX_AGGREGATION_OUTPUTS
            || rows.is_empty()
            || rows.len() % input_width != 0
            || rows.len() / input_width > bounds.maximum_rows
        {
            return Err(GroupAggregationError::ProposalCorpus);
        }
        if scopes.is_empty() || scopes.len() > bounds.plan.maximum_groups {
            return Err(GroupAggregationError::InvalidSpecification);
        }
        let mut groups = Vec::with_capacity(scopes.len());
        for scope in scopes {
            if scope.is_empty()
                || scope.len() > bounds.plan.maximum_members_per_group
                || scope.windows(2).any(|pair| pair[0] >= pair[1])
                || scope
                    .last()
                    .is_some_and(|&member| usize::from(member) >= input_width)
            {
                return Err(GroupAggregationError::InvalidMembers);
            }
            let mut observations = Vec::with_capacity(rows.len() / input_width * scope.len());
            for row in rows.chunks_exact(input_width) {
                for &member in scope.iter() {
                    observations.push(row[usize::from(member)]);
                }
            }
            observations.sort_unstable();
            let mut values = BTreeSet::new();
            let samples = bounds.maximum_count_values_per_group;
            if samples == 1 {
                values.insert(observations[observations.len() / 2]);
            } else if samples > 1 {
                for sample in 0..samples {
                    let index = sample * (observations.len() - 1) / (samples - 1);
                    values.insert(observations[index]);
                }
            }
            let mut operations = vec![
                GroupAggregateOp::Sum,
                GroupAggregateOp::SumSquares,
                GroupAggregateOp::Minimum,
                GroupAggregateOp::Maximum,
            ];
            operations.extend(
                values
                    .into_iter()
                    .map(|value| GroupAggregateOp::CountEqual { value }),
            );
            operations.extend([
                GroupAggregateOp::EqualPairCount,
                GroupAggregateOp::DistinctCount,
            ]);
            groups.push(GroupAggregateSpec {
                members: scope.clone(),
                operations: operations.into_boxed_slice(),
            });
        }
        Self::compile(input_width, &groups, bounds.plan)
    }

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

    const PROPOSAL_BOUNDS: GroupAggregationProposalBounds = GroupAggregationProposalBounds {
        plan: BOUNDS,
        maximum_rows: 16,
        maximum_count_values_per_group: 2,
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
    fn proposal_profiles_bounded_values_without_a_conclusion() {
        let scope = (0_u16..7).collect::<Vec<_>>().into_boxed_slice();
        let plan = GroupAggregationPlan::propose_from_rows(
            7,
            &[scope],
            &[2, -1, 2, 4, 0, -1, 3, 9, 8, 7, 6, 5, 4, 3],
            PROPOSAL_BOUNDS,
        )
        .unwrap();
        assert_eq!(
            &*plan.groups()[0].operations,
            &[
                GroupAggregateOp::Sum,
                GroupAggregateOp::SumSquares,
                GroupAggregateOp::Minimum,
                GroupAggregateOp::Maximum,
                GroupAggregateOp::CountEqual { value: -1 },
                GroupAggregateOp::CountEqual { value: 9 },
                GroupAggregateOp::EqualPairCount,
                GroupAggregateOp::DistinctCount,
            ]
        );
        let scopes = [plan.groups()[0].members.clone()];
        assert_eq!(
            GroupAggregationPlan::propose_from_rows(7, &scopes, &[], PROPOSAL_BOUNDS),
            Err(GroupAggregationError::ProposalCorpus)
        );
    }

    #[test]
    fn equal_marginal_scope_proposal_is_exact_and_order_independent() {
        let scopes = propose_equal_marginal_scopes(
            4,
            &[1, 5, 3, 5, 2, 5, 1, 6, 3, 6, 2, 5],
            GroupScopeProposalBounds {
                maximum_rows: 3,
                maximum_cells: 12,
                maximum_groups: 2,
                maximum_members_per_group: 2,
            },
        )
        .unwrap();
        assert_eq!(scopes.len(), 2);
        assert_eq!(&*scopes[0], &[0, 2]);
        assert_eq!(&*scopes[1], &[1, 3]);
        assert_eq!(
            propose_equal_marginal_scopes(
                4,
                &[1, 5, 3, 5, 2, 5, 1, 6, 3, 6, 2, 5],
                GroupScopeProposalBounds {
                    maximum_rows: 3,
                    maximum_cells: 11,
                    maximum_groups: 2,
                    maximum_members_per_group: 2,
                },
            ),
            Err(GroupAggregationError::ScopeProposalLimit)
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
