//! Exact bounded compilation of permutation-invariant group summaries.
//!
//! This is a cold compiler for theorem-search inputs.  It turns flat child
//! rows into one dense row per parent key, so the ordinary row evaluator can
//! search relations among counts, sums, and extrema without doing cross-row
//! work in its evaluation loop.

use thiserror::Error;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum MultisetStatistic {
    Count,
    Sum { field: usize },
    Minimum { field: usize },
    Maximum { field: usize },
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct MultisetBounds {
    pub max_rows: usize,
    pub max_groups: usize,
    pub max_output_cells: usize,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct MultisetAggregateTable {
    group_keys: Box<[i64]>,
    values: Box<[i64]>,
    width: usize,
}

impl MultisetAggregateTable {
    pub fn groups(&self) -> usize {
        self.group_keys.len()
    }

    pub fn width(&self) -> usize {
        self.width
    }

    pub fn group_key(&self, group: usize) -> i64 {
        self.group_keys[group]
    }

    pub fn row(&self, group: usize) -> &[i64] {
        &self.values[group * self.width..(group + 1) * self.width]
    }

    pub fn group_keys(&self) -> &[i64] {
        &self.group_keys
    }

    pub fn values(&self) -> &[i64] {
        &self.values
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum MultisetAggregateError {
    #[error("multiset row matrix has the wrong size")]
    Shape,
    #[error("multiset aggregation bounds must be positive")]
    EmptyBound,
    #[error("multiset aggregation exceeds a configured bound")]
    TooLarge,
    #[error("multiset statistic references a missing field")]
    InvalidField,
    #[error("multiset aggregate overflows i64")]
    Overflow,
}

/// Compile exact group summaries in ascending key order.
///
/// Child rows may arrive in any order.  Equal keys define one multiset, and
/// row order within that multiset has no effect on the result.  Compilation
/// allocates only bounded scratch and output; the returned dense table is
/// directly consumable by a row-oriented theorem evaluator.
pub fn compile_bounded_multiset_aggregates(
    group_keys: &[i64],
    row_values: &[i64],
    row_width: usize,
    statistics: &[MultisetStatistic],
    bounds: MultisetBounds,
) -> Result<MultisetAggregateTable, MultisetAggregateError> {
    if bounds.max_rows == 0 || bounds.max_groups == 0 || bounds.max_output_cells == 0 {
        return Err(MultisetAggregateError::EmptyBound);
    }
    if row_width == 0
        || statistics.is_empty()
        || row_values.len() != group_keys.len().saturating_mul(row_width)
    {
        return Err(MultisetAggregateError::Shape);
    }
    if group_keys.len() > bounds.max_rows || group_keys.len() > u32::MAX as usize {
        return Err(MultisetAggregateError::TooLarge);
    }
    for statistic in statistics {
        let field = match statistic {
            MultisetStatistic::Count => continue,
            MultisetStatistic::Sum { field }
            | MultisetStatistic::Minimum { field }
            | MultisetStatistic::Maximum { field } => *field,
        };
        if field >= row_width {
            return Err(MultisetAggregateError::InvalidField);
        }
    }
    if group_keys.is_empty() {
        return Ok(MultisetAggregateTable {
            group_keys: Box::new([]),
            values: Box::new([]),
            width: statistics.len(),
        });
    }

    let mut order = (0..group_keys.len() as u32).collect::<Vec<_>>();
    order.sort_unstable_by_key(|&row| (group_keys[row as usize], row));
    let groups = 1 + order
        .windows(2)
        .filter(|rows| group_keys[rows[0] as usize] != group_keys[rows[1] as usize])
        .count();
    let cells = groups
        .checked_mul(statistics.len())
        .ok_or(MultisetAggregateError::TooLarge)?;
    if groups > bounds.max_groups || cells > bounds.max_output_cells {
        return Err(MultisetAggregateError::TooLarge);
    }

    let mut output_keys = Vec::with_capacity(groups);
    let mut output = Vec::with_capacity(cells);
    let mut start = 0_usize;
    while start < order.len() {
        let key = group_keys[order[start] as usize];
        let mut end = start + 1;
        while end < order.len() && group_keys[order[end] as usize] == key {
            end += 1;
        }
        output_keys.push(key);
        for statistic in statistics {
            let value = match *statistic {
                MultisetStatistic::Count => {
                    i64::try_from(end - start).map_err(|_| MultisetAggregateError::Overflow)?
                }
                MultisetStatistic::Sum { field } => {
                    let mut total = 0_i64;
                    for &row in &order[start..end] {
                        total = total
                            .checked_add(row_values[row as usize * row_width + field])
                            .ok_or(MultisetAggregateError::Overflow)?;
                    }
                    total
                }
                MultisetStatistic::Minimum { field } => {
                    let mut minimum = i64::MAX;
                    for &row in &order[start..end] {
                        minimum = minimum.min(row_values[row as usize * row_width + field]);
                    }
                    minimum
                }
                MultisetStatistic::Maximum { field } => {
                    let mut maximum = i64::MIN;
                    for &row in &order[start..end] {
                        maximum = maximum.max(row_values[row as usize * row_width + field]);
                    }
                    maximum
                }
            };
            output.push(value);
        }
        start = end;
    }
    debug_assert_eq!(output_keys.len(), groups);
    debug_assert_eq!(output.len(), cells);
    Ok(MultisetAggregateTable {
        group_keys: output_keys.into_boxed_slice(),
        values: output.into_boxed_slice(),
        width: statistics.len(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    const BOUNDS: MultisetBounds = MultisetBounds {
        max_rows: 64,
        max_groups: 16,
        max_output_cells: 128,
    };

    #[test]
    fn compiles_unsorted_multisets_into_canonical_dense_rows() {
        let table = compile_bounded_multiset_aggregates(
            &[9, 3, 9, 3, 9],
            &[4, 8, 2, 7, -1, 6, 5, 0, 3, 9],
            2,
            &[
                MultisetStatistic::Count,
                MultisetStatistic::Sum { field: 0 },
                MultisetStatistic::Minimum { field: 1 },
                MultisetStatistic::Maximum { field: 1 },
            ],
            BOUNDS,
        )
        .unwrap();
        assert_eq!(table.group_keys(), &[3, 9]);
        assert_eq!(table.row(0), &[2, 7, 0, 7]);
        assert_eq!(table.row(1), &[3, 6, 6, 9]);
    }

    #[test]
    fn permutation_of_children_and_groups_preserves_output() {
        let statistics = [
            MultisetStatistic::Count,
            MultisetStatistic::Sum { field: 0 },
            MultisetStatistic::Minimum { field: 0 },
        ];
        let left = compile_bounded_multiset_aggregates(
            &[2, 1, 2, 1],
            &[5, 7, 3, 11],
            1,
            &statistics,
            BOUNDS,
        )
        .unwrap();
        let right = compile_bounded_multiset_aggregates(
            &[1, 2, 1, 2],
            &[11, 3, 7, 5],
            1,
            &statistics,
            BOUNDS,
        )
        .unwrap();
        assert_eq!(left, right);
    }

    #[test]
    fn rejects_bounds_and_overflow_before_returning_partial_output() {
        assert_eq!(
            compile_bounded_multiset_aggregates(
                &[0, 1],
                &[1, 2],
                1,
                &[MultisetStatistic::Count],
                MultisetBounds {
                    max_rows: 2,
                    max_groups: 1,
                    max_output_cells: 2,
                },
            ),
            Err(MultisetAggregateError::TooLarge)
        );
        assert_eq!(
            compile_bounded_multiset_aggregates(
                &[0, 0],
                &[i64::MAX, 1],
                1,
                &[MultisetStatistic::Sum { field: 0 }],
                BOUNDS,
            ),
            Err(MultisetAggregateError::Overflow)
        );
    }
}
