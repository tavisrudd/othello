//! Exact compatibility of the length-18 and length-174 binary projections.
//!
//! Under the CRT presentation `522 = 18 * 29`, a q18 coefficient fixes one
//! row degree of an `18 x 29` binary table.  A q174 coefficient fixes the
//! degree of one three-row column inside a residue class modulo six.  The six
//! resulting `3 x 29` tables are independent at the margin layer.  Gale--Ryser
//! reduces each table to its total and the counts of degree-zero and
//! degree-three columns.

use thiserror::Error;

pub const Q18_ROWS: usize = 18;
pub const Q174_COLUMNS: usize = 174;
pub const Q174_CLASSES: usize = 6;
pub const CRT_COLUMNS: usize = 29;
pub const CLASS_ROWS: usize = 3;
pub const Q174_GS_COMBINED_ENERGY: i32 = 2_080;
pub const Q174_GS_EXTREME_COUNT: u16 = 173;

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18Q174Margins {
    pub q18_signed: [i8; Q18_ROWS],
    pub q174_signed: [i8; Q174_COLUMNS],
}

const _: () = assert!(std::mem::size_of::<Q18Q174Margins>() == 192);
const _: () = assert!(std::mem::align_of::<Q18Q174Margins>() == 64);

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Q174ClassSummary {
    pub total: u16,
    pub zero_columns: u8,
    pub full_columns: u8,
}

const _: () = assert!(std::mem::size_of::<Q174ClassSummary>() == 4);
const _: () = assert!(std::mem::align_of::<Q174ClassSummary>() == 2);

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Q174MarginSummary {
    pub classes: [Q174ClassSummary; Q174_CLASSES],
    _padding: [u8; 8],
}

const _: () = assert!(std::mem::size_of::<Q174MarginSummary>() == 32);
const _: () = assert!(std::mem::align_of::<Q174MarginSummary>() == 2);

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum Q18Q174MarginError {
    #[error("q18 coefficient is not an odd integer in [-29, 29]")]
    InvalidQ18Coefficient,
    #[error("q174 coefficient is not an odd integer in [-3, 3]")]
    InvalidQ174Coefficient,
}

/// Extract the complete q18-compatibility state of a q174 block.
pub fn extract_q174_margin_summary(
    margins: &Q18Q174Margins,
    output: &mut Q174MarginSummary,
) -> Result<(), Q18Q174MarginError> {
    output.classes = [Q174ClassSummary::default(); Q174_CLASSES];
    output._padding = [0; 8];
    for index in 0..Q174_COLUMNS {
        let signed = margins.q174_signed[index];
        if !(-3..=3).contains(&signed) || signed & 1 == 0 {
            return Err(Q18Q174MarginError::InvalidQ174Coefficient);
        }
        let degree = ((i16::from(signed) + 3) / 2) as u8;
        let class = index % Q174_CLASSES;
        let summary = &mut output.classes[class];
        summary.total += u16::from(degree);
        summary.zero_columns += u8::from(degree == 0);
        summary.full_columns += u8::from(degree == CLASS_ROWS as u8);
    }
    Ok(())
}

/// Decide exact common binary liftability of one q18/q174 block.
///
/// For the three q18 row degrees `d1 >= d2 >= d3` in a fixed residue class,
/// Gale--Ryser is equivalent to
///
/// * equal totals;
/// * `zero_columns <= 29 - d1`; and
/// * `full_columns <= d3`.
///
/// The function extracts q174 semantics itself and allocates nothing.
pub fn q18_q174_binary_margin_lift_exists(
    margins: &Q18Q174Margins,
    summary: &mut Q174MarginSummary,
) -> Result<bool, Q18Q174MarginError> {
    extract_q174_margin_summary(margins, summary)?;
    for class in 0..Q174_CLASSES {
        let mut degrees = [0_u8; CLASS_ROWS];
        for row in 0..CLASS_ROWS {
            let signed = margins.q18_signed[class + Q174_CLASSES * row];
            if !(-29..=29).contains(&signed) || signed & 1 == 0 {
                return Err(Q18Q174MarginError::InvalidQ18Coefficient);
            }
            degrees[row] = ((i16::from(signed) + 29) / 2) as u8;
        }
        degrees.sort_unstable_by(|left, right| right.cmp(left));
        let state = summary.classes[class];
        let row_total = degrees.iter().map(|&x| u16::from(x)).sum::<u16>();
        if row_total != state.total
            || state.zero_columns > CRT_COLUMNS as u8 - degrees[0]
            || state.full_columns > degrees[2]
        {
            return Ok(false);
        }
    }
    Ok(true)
}

/// Return the q174 zero-shift energy from the compact extreme-count state.
///
/// Every signed q174 coefficient is one of `-3,-1,1,3`; its square is one
/// plus eight exactly for degree zero or three.  Across four blocks the GS
/// target is therefore equivalent to exactly 173 extreme columns.
#[must_use]
pub fn combined_q174_energy(summaries: &[Q174MarginSummary; 4]) -> i32 {
    let extremes = summaries
        .iter()
        .flat_map(|summary| summary.classes.iter())
        .map(|state| u16::from(state.zero_columns) + u16::from(state.full_columns))
        .sum::<u16>();
    (4 * Q174_COLUMNS) as i32 + 8 * i32::from(extremes)
}

#[must_use]
pub fn q174_gs_energy_target_holds(summaries: &[Q174MarginSummary; 4]) -> bool {
    combined_q174_energy(summaries) == Q174_GS_COMBINED_ENERGY
}

#[cfg(test)]
mod tests {
    use std::collections::HashSet;

    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn generic_three_row_test(rows: [u8; 3], columns: &[u8]) -> bool {
        let mut sorted = rows;
        sorted.sort_unstable_by(|left, right| right.cmp(left));
        let total = columns.iter().map(|&x| u16::from(x)).sum::<u16>();
        let row_total = sorted.iter().map(|&x| u16::from(x)).sum::<u16>();
        row_total == total
            && columns.iter().filter(|&&x| x == 0).count() <= columns.len() - sorted[0] as usize
            && columns.iter().filter(|&&x| x == 3).count() <= sorted[2] as usize
    }

    #[test]
    fn exhaustive_small_three_row_margins_match_direct_tables() {
        for columns_count in 1_usize..=5 {
            let mut reachable = HashSet::new();
            for table in 0_u32..(1_u32 << (3 * columns_count)) {
                let mut rows = [0_u8; 3];
                let mut columns = [0_u8; 5];
                for row in 0..3 {
                    for column in 0..columns_count {
                        if table & (1 << (row * columns_count + column)) != 0 {
                            rows[row] += 1;
                            columns[column] += 1;
                        }
                    }
                }
                reachable.insert((rows, columns));
            }
            for mut row_code in 0..(columns_count + 1).pow(3) {
                let mut rows = [0_u8; 3];
                for degree in &mut rows {
                    *degree = (row_code % (columns_count + 1)) as u8;
                    row_code /= columns_count + 1;
                }
                for mut column_code in 0_usize..4_usize.pow(columns_count as u32) {
                    let mut columns = [0_u8; 5];
                    for degree in columns.iter_mut().take(columns_count) {
                        *degree = (column_code % 4) as u8;
                        column_code /= 4;
                    }
                    assert_eq!(
                        generic_three_row_test(rows, &columns[..columns_count]),
                        reachable.contains(&(rows, columns))
                    );
                }
            }
        }
    }

    #[test]
    fn constructed_crt_tables_lift_and_energy_identity_is_direct() {
        let mut summaries = [Q174MarginSummary::default(); 4];
        for (block, output) in summaries.iter_mut().enumerate() {
            let mut q18 = [-29_i8; Q18_ROWS];
            let mut q174 = [-3_i8; Q174_COLUMNS];
            for row in 0..Q18_ROWS {
                for column in 0..CRT_COLUMNS {
                    if (row + 2 * column + block) % 5 < 2 {
                        q18[row] += 2;
                        let class = row % Q174_CLASSES;
                        let index = (0..Q174_COLUMNS)
                            .find(|&candidate| {
                                candidate % Q174_CLASSES == class
                                    && candidate % CRT_COLUMNS == column
                            })
                            .unwrap();
                        q174[index] += 2;
                    }
                }
            }
            let margins = Q18Q174Margins {
                q18_signed: q18,
                q174_signed: q174,
            };
            assert!(q18_q174_binary_margin_lift_exists(&margins, output).unwrap());
            let direct_energy = q174
                .iter()
                .map(|&x| i32::from(x) * i32::from(x))
                .sum::<i32>();
            let extremes = output
                .classes
                .iter()
                .map(|state| u16::from(state.zero_columns) + u16::from(state.full_columns))
                .sum::<u16>();
            assert_eq!(direct_energy, Q174_COLUMNS as i32 + 8 * i32::from(extremes));
        }
        assert_eq!(
            combined_q174_energy(&summaries),
            summaries
                .iter()
                .flat_map(|summary| summary.classes)
                .map(|state| 174_i32 / 6 + 8 * i32::from(state.zero_columns + state.full_columns))
                .sum::<i32>()
        );
    }

    #[test]
    fn exact_equal_total_obstruction_is_rejected() {
        let mut q18 = [-29_i8; Q18_ROWS];
        q18[0] = 29;
        q18[6] = 29;
        let mut q174 = [-3_i8; Q174_COLUMNS];
        let mut seen = 0_usize;
        for index in 0..Q174_COLUMNS {
            if index % Q174_CLASSES == 0 {
                q174[index] = if seen < 3 {
                    3
                } else if seen < 7 {
                    -1
                } else {
                    -3
                };
                seen += 1;
            }
        }
        let margins = Q18Q174Margins {
            q18_signed: q18,
            q174_signed: q174,
        };
        let mut summary = Q174MarginSummary::default();
        assert!(!q18_q174_binary_margin_lift_exists(&margins, &mut summary).unwrap());
    }

    #[test]
    fn hot_extractor_and_decider_allocate_nothing() {
        let margins = Q18Q174Margins {
            q18_signed: [-29; Q18_ROWS],
            q174_signed: [-3; Q174_COLUMNS],
        };
        let mut summary = Q174MarginSummary::default();
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..4_096 {
                assert!(q18_q174_binary_margin_lift_exists(&margins, &mut summary).unwrap());
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn malformed_semantics_fail_closed() {
        let mut margins = Q18Q174Margins {
            q18_signed: [-29; Q18_ROWS],
            q174_signed: [-3; Q174_COLUMNS],
        };
        let mut summary = Q174MarginSummary::default();
        margins.q174_signed[0] = 0;
        assert_eq!(
            q18_q174_binary_margin_lift_exists(&margins, &mut summary),
            Err(Q18Q174MarginError::InvalidQ174Coefficient)
        );
        margins.q174_signed[0] = -3;
        margins.q18_signed[0] = 0;
        assert_eq!(
            q18_q174_binary_margin_lift_exists(&margins, &mut summary),
            Err(Q18Q174MarginError::InvalidQ18Coefficient)
        );
    }
}
