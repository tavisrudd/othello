//! Exact binary-matrix liftability from two transverse compressed margins.
//!
//! This is the Gale--Ryser criterion presented as a bounded, allocation-free
//! kernel.  It is useful whenever two exact quotient projections are the row
//! and column sums of one binary incidence table.  The kernel recomputes the
//! canonical degree semantics from signed compressed coefficients; no named
//! feature or externally supplied verdict has proof authority.

use thiserror::Error;

pub const Q18_ROWS: usize = 18;
pub const Q29_COLUMNS: usize = 29;

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18Q29Margins {
    pub q18_signed: [i8; Q18_ROWS],
    pub q29_signed: [i8; Q29_COLUMNS],
    _padding: [u8; 17],
}

const _: () = assert!(std::mem::size_of::<Q18Q29Margins>() == 64);
const _: () = assert!(std::mem::align_of::<Q18Q29Margins>() == 64);

impl Q18Q29Margins {
    #[must_use]
    pub const fn new(q18_signed: [i8; Q18_ROWS], q29_signed: [i8; Q29_COLUMNS]) -> Self {
        Self {
            q18_signed,
            q29_signed,
            _padding: [0; 17],
        }
    }
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18Q29MarginWorkspace {
    sorted_row_degrees: [u8; Q18_ROWS],
    _padding: [u8; 46],
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18Q29ConstructWorkspace {
    row_degrees: [u8; Q18_ROWS],
    column_degrees: [u8; Q29_COLUMNS],
    column_order: [u8; Q29_COLUMNS],
    processed_rows: [u8; Q18_ROWS],
    _padding: [u8; 34],
}

const _: () = assert!(std::mem::size_of::<Q18Q29ConstructWorkspace>() == 128);
const _: () = assert!(std::mem::align_of::<Q18Q29ConstructWorkspace>() == 64);

impl Q18Q29ConstructWorkspace {
    pub const ZERO: Self = Self {
        row_degrees: [0; Q18_ROWS],
        column_degrees: [0; Q29_COLUMNS],
        column_order: [0; Q29_COLUMNS],
        processed_rows: [0; Q18_ROWS],
        _padding: [0; 34],
    };
}

const _: () = assert!(std::mem::size_of::<Q18Q29MarginWorkspace>() == 64);
const _: () = assert!(std::mem::align_of::<Q18Q29MarginWorkspace>() == 64);

impl Q18Q29MarginWorkspace {
    pub const ZERO: Self = Self {
        sorted_row_degrees: [0; Q18_ROWS],
        _padding: [0; 46],
    };
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum BinaryMarginLiftError {
    #[error("q18 coefficient is not an odd integer in [-29, 29]")]
    InvalidQ18Coefficient,
    #[error("q29 coefficient is not an even integer in [-18, 18]")]
    InvalidQ29Coefficient,
    #[error("row and column totals differ")]
    UnequalTotals,
}

/// Decide whether the two compressed views have a common binary lift.
///
/// With `x[a,b]` in `{0,1}`, the signed q18 coefficient is
/// `2 sum_b x[a,b] - 29`, and the signed q29 coefficient is
/// `2 sum_a x[a,b] - 18`.  Gale--Ryser says that a common lift exists exactly
/// when the totals agree and, after sorting the row degrees decreasingly,
///
/// `sum_{i < k} r_i <= sum_j min(k, c_j)` for every `k=1,...,18`.
///
/// The caller owns the fixed workspace.  This function allocates nothing and
/// uses an iterative insertion sort because the row count is exactly 18.
pub fn q18_q29_binary_margin_lift_exists(
    margins: &Q18Q29Margins,
    workspace: &mut Q18Q29MarginWorkspace,
) -> Result<bool, BinaryMarginLiftError> {
    let mut row_total = 0_u16;
    for (slot, &signed) in margins.q18_signed.iter().enumerate() {
        if !(-29..=29).contains(&signed) || signed & 1 == 0 {
            return Err(BinaryMarginLiftError::InvalidQ18Coefficient);
        }
        let degree = ((i16::from(signed) + 29) / 2) as u8;
        workspace.sorted_row_degrees[slot] = degree;
        row_total += u16::from(degree);
    }

    let mut column_degrees = [0_u8; Q29_COLUMNS];
    let mut column_total = 0_u16;
    for (slot, &signed) in margins.q29_signed.iter().enumerate() {
        if !(-18..=18).contains(&signed) || signed & 1 != 0 {
            return Err(BinaryMarginLiftError::InvalidQ29Coefficient);
        }
        let degree = ((i16::from(signed) + 18) / 2) as u8;
        column_degrees[slot] = degree;
        column_total += u16::from(degree);
    }
    if row_total != column_total {
        return Err(BinaryMarginLiftError::UnequalTotals);
    }

    for index in 1..Q18_ROWS {
        let value = workspace.sorted_row_degrees[index];
        let mut cursor = index;
        while cursor != 0 && workspace.sorted_row_degrees[cursor - 1] < value {
            workspace.sorted_row_degrees[cursor] = workspace.sorted_row_degrees[cursor - 1];
            cursor -= 1;
        }
        workspace.sorted_row_degrees[cursor] = value;
    }

    let mut left = 0_u16;
    for prefix in 1..=Q18_ROWS {
        left += u16::from(workspace.sorted_row_degrees[prefix - 1]);
        let mut right = 0_u16;
        for &degree in &column_degrees {
            right += u16::from(degree.min(prefix as u8));
        }
        if left > right {
            return Ok(false);
        }
    }
    Ok(true)
}

/// Construct one canonical binary matrix with the supplied transverse
/// margins. Rows are emitted as 29-bit words. This is a boundary constructor,
/// not a claim that an arbitrary margin lift satisfies mixed CRT PAFs.
pub fn construct_q18_q29_binary_margin_lift(
    margins: &Q18Q29Margins,
    workspace: &mut Q18Q29ConstructWorkspace,
) -> Result<Option<[u32; Q18_ROWS]>, BinaryMarginLiftError> {
    let mut decision_workspace = Q18Q29MarginWorkspace::ZERO;
    if !q18_q29_binary_margin_lift_exists(margins, &mut decision_workspace)? {
        return Ok(None);
    }
    workspace.processed_rows.fill(0);
    for row in 0..Q18_ROWS {
        workspace.row_degrees[row] = ((i16::from(margins.q18_signed[row]) + 29) / 2) as u8;
    }
    for column in 0..Q29_COLUMNS {
        workspace.column_degrees[column] = ((i16::from(margins.q29_signed[column]) + 18) / 2) as u8;
        workspace.column_order[column] = column as u8;
    }
    let mut matrix = [0_u32; Q18_ROWS];
    for _ in 0..Q18_ROWS {
        let mut selected_row = usize::MAX;
        for row in 0..Q18_ROWS {
            if workspace.processed_rows[row] == 0
                && (selected_row == usize::MAX
                    || workspace.row_degrees[row] > workspace.row_degrees[selected_row])
            {
                selected_row = row;
            }
        }
        workspace.processed_rows[selected_row] = 1;
        for index in 1..Q29_COLUMNS {
            let column = workspace.column_order[index];
            let mut cursor = index;
            while cursor != 0
                && workspace.column_degrees[usize::from(workspace.column_order[cursor - 1])]
                    < workspace.column_degrees[usize::from(column)]
            {
                workspace.column_order[cursor] = workspace.column_order[cursor - 1];
                cursor -= 1;
            }
            workspace.column_order[cursor] = column;
        }
        let degree = usize::from(workspace.row_degrees[selected_row]);
        for &column in &workspace.column_order[..degree] {
            let column = usize::from(column);
            if workspace.column_degrees[column] == 0 {
                return Ok(None);
            }
            workspace.column_degrees[column] -= 1;
            matrix[selected_row] |= 1_u32 << column;
        }
    }
    if workspace.column_degrees.iter().any(|&degree| degree != 0) {
        return Ok(None);
    }
    Ok(Some(matrix))
}

#[cfg(test)]
mod tests {
    use std::collections::HashSet;

    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn generic_gale_ryser(rows: &[u8], columns: &[u8]) -> bool {
        if rows.iter().map(|&x| u16::from(x)).sum::<u16>()
            != columns.iter().map(|&x| u16::from(x)).sum::<u16>()
        {
            return false;
        }
        let mut sorted = rows.to_vec();
        sorted.sort_unstable_by(|left, right| right.cmp(left));
        for prefix in 1..=rows.len() {
            let left = sorted[..prefix].iter().map(|&x| u16::from(x)).sum::<u16>();
            let right = columns
                .iter()
                .map(|&x| u16::from(x.min(prefix as u8)))
                .sum::<u16>();
            if left > right {
                return false;
            }
        }
        true
    }

    #[test]
    fn exhaustive_small_margins_match_direct_matrix_enumeration() {
        for row_count in 1_usize..=4 {
            for column_count in 1_usize..=4 {
                let mut reachable = HashSet::new();
                for matrix in 0_u32..(1_u32 << (row_count * column_count)) {
                    let mut rows = [0_u8; 4];
                    let mut columns = [0_u8; 4];
                    for row in 0..row_count {
                        for column in 0..column_count {
                            if matrix & (1 << (row * column_count + column)) != 0 {
                                rows[row] += 1;
                                columns[column] += 1;
                            }
                        }
                    }
                    reachable.insert((rows, columns));
                }

                let row_states = (column_count + 1).pow(row_count as u32);
                let column_states = (row_count + 1).pow(column_count as u32);
                for mut row_code in 0..row_states {
                    let mut rows = [0_u8; 4];
                    for degree in rows.iter_mut().take(row_count) {
                        *degree = (row_code % (column_count + 1)) as u8;
                        row_code /= column_count + 1;
                    }
                    for mut column_code in 0..column_states {
                        let mut columns = [0_u8; 4];
                        for degree in columns.iter_mut().take(column_count) {
                            *degree = (column_code % (row_count + 1)) as u8;
                            column_code /= row_count + 1;
                        }
                        assert_eq!(
                            generic_gale_ryser(&rows[..row_count], &columns[..column_count]),
                            reachable.contains(&(rows, columns))
                        );
                    }
                }
            }
        }
    }

    #[test]
    fn q18_q29_kernel_accepts_constructed_tables_and_rejects_known_obstruction() {
        let mut q18 = [-29_i8; Q18_ROWS];
        let mut q29 = [-18_i8; Q29_COLUMNS];
        for row in 0..Q18_ROWS {
            for column in 0..Q29_COLUMNS {
                if (3 * row + 5 * column) % 7 < 3 {
                    q18[row] += 2;
                    q29[column] += 2;
                }
            }
        }
        let mut workspace = Q18Q29MarginWorkspace::ZERO;
        assert!(
            q18_q29_binary_margin_lift_exists(&Q18Q29Margins::new(q18, q29), &mut workspace)
                .unwrap()
        );

        // Degrees r=(29,29,0,...), c=(18,18,18,1,1,1,1,0,...,0) have equal
        // total 58, but the two largest rows demand 58 incidences while the
        // column-side prefix capacity is only 10.
        let mut bad_rows = [-29_i8; Q18_ROWS];
        bad_rows[0] = 29;
        bad_rows[1] = 29;
        let mut bad_columns = [-18_i8; Q29_COLUMNS];
        bad_columns[0] = 18;
        bad_columns[1] = 18;
        bad_columns[2] = 18;
        bad_columns[3..7].fill(-16);
        let bad = Q18Q29Margins::new(bad_rows, bad_columns);
        assert!(!q18_q29_binary_margin_lift_exists(&bad, &mut workspace).unwrap());
    }

    #[test]
    fn q18_q29_hot_kernel_allocates_nothing() {
        let mut q18 = [-1; Q18_ROWS];
        q18[..Q18_ROWS / 2].fill(1);
        let margins = Q18Q29Margins::new(q18, [0; Q29_COLUMNS]);
        let mut workspace = Q18Q29MarginWorkspace::ZERO;
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..4_096 {
                assert!(q18_q29_binary_margin_lift_exists(&margins, &mut workspace).unwrap());
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn canonical_constructor_replays_both_labelled_margins_without_allocation() {
        let mut q18 = [-29_i8; Q18_ROWS];
        let mut q29 = [-18_i8; Q29_COLUMNS];
        for row in 0..Q18_ROWS {
            for column in 0..Q29_COLUMNS {
                if (5 * row + 7 * column) % 11 < 4 {
                    q18[row] += 2;
                    q29[column] += 2;
                }
            }
        }
        let margins = Q18Q29Margins::new(q18, q29);
        let mut workspace = Q18Q29ConstructWorkspace::ZERO;
        let (matrix, allocations) = tracked_allocations(|| {
            construct_q18_q29_binary_margin_lift(&margins, &mut workspace)
                .unwrap()
                .unwrap()
        });
        assert_eq!(allocations, 0);
        for row in 0..Q18_ROWS {
            assert_eq!(
                2 * matrix[row].count_ones() as i16 - 29,
                i16::from(q18[row])
            );
        }
        for column in 0..Q29_COLUMNS {
            let degree = matrix
                .iter()
                .filter(|&&row| row & (1_u32 << column) != 0)
                .count();
            assert_eq!(2 * degree as i16 - 18, i16::from(q29[column]));
        }
    }

    #[test]
    fn malformed_signed_semantics_fail_closed() {
        let mut workspace = Q18Q29MarginWorkspace::ZERO;
        let mut margins = Q18Q29Margins::new([-1; Q18_ROWS], [0; Q29_COLUMNS]);
        margins.q18_signed[0] = 0;
        assert_eq!(
            q18_q29_binary_margin_lift_exists(&margins, &mut workspace),
            Err(BinaryMarginLiftError::InvalidQ18Coefficient)
        );
        margins.q18_signed[0] = -1;
        margins.q29_signed[0] = 1;
        assert_eq!(
            q18_q29_binary_margin_lift_exists(&margins, &mut workspace),
            Err(BinaryMarginLiftError::InvalidQ29Coefficient)
        );
    }
}
