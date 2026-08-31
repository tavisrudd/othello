//! Exact allocation-free enumeration under first and second integer moments.
//!
//! Prefixes are nondecreasing, so every multiset is visited once.  Exact
//! convex lower and upper envelopes for the remaining sum of squares prune a
//! prefix before descent.  The search is iterative and reuses caller-sized
//! storage.

use thiserror::Error;

#[cfg(test)]
use crate::test_alloc::HotLoopAllocationGuard;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct IntegerMomentProblem {
    pub degree: u32,
    pub sum: i64,
    pub square_sum: i64,
    pub minimum: i32,
    pub maximum: i32,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct IntegerMomentMetrics {
    pub prefixes: u64,
    pub solutions: u64,
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum IntegerMomentError {
    #[error("an integer-moment problem needs positive degree and an ordered value interval")]
    Shape,
    #[error("the integer-moment workspace is too small")]
    Workspace,
    #[error("integer-moment arithmetic overflow")]
    Overflow,
    #[error("the Seidel type-2 filter supports orders 1 through 63")]
    Type2Order,
    #[error("the supplied roots do not have the declared Seidel order")]
    Type2Degree,
}

/// Fixed storage for repeated bounded moment enumerations.
#[derive(Debug)]
pub struct IntegerMomentWorkspace {
    maximum_degree: u32,
    values: Box<[i32]>,
    next_value: Box<[i64]>,
    prefix_sum: Box<[i64]>,
    prefix_square_sum: Box<[i64]>,
}

impl IntegerMomentWorkspace {
    pub fn new(maximum_degree: u32) -> Result<Self, IntegerMomentError> {
        if maximum_degree == 0 {
            return Err(IntegerMomentError::Shape);
        }
        let degree = maximum_degree as usize;
        Ok(Self {
            maximum_degree,
            values: vec![0; degree].into_boxed_slice(),
            next_value: vec![0; degree].into_boxed_slice(),
            prefix_sum: vec![0; degree + 1].into_boxed_slice(),
            prefix_square_sum: vec![0; degree + 1].into_boxed_slice(),
        })
    }
}

/// Enumerate every nondecreasing solution without allocating in the search.
pub fn enumerate_integer_moments(
    problem: IntegerMomentProblem,
    workspace: &mut IntegerMomentWorkspace,
    mut visit: impl FnMut(&[i32]),
) -> Result<IntegerMomentMetrics, IntegerMomentError> {
    #[cfg(test)]
    let _allocation_guard = HotLoopAllocationGuard::enter();
    if problem.degree == 0 || problem.minimum > problem.maximum {
        return Err(IntegerMomentError::Shape);
    }
    if problem.degree > workspace.maximum_degree {
        return Err(IntegerMomentError::Workspace);
    }
    let degree = problem.degree as usize;
    workspace.prefix_sum[0] = 0;
    workspace.prefix_square_sum[0] = 0;
    workspace.next_value[0] = i64::from(problem.minimum);
    let mut depth = 0_usize;
    let mut metrics = IntegerMomentMetrics::default();

    loop {
        if depth == degree {
            if workspace.prefix_sum[depth] == problem.sum
                && workspace.prefix_square_sum[depth] == problem.square_sum
            {
                visit(&workspace.values[..degree]);
                metrics.solutions = metrics
                    .solutions
                    .checked_add(1)
                    .ok_or(IntegerMomentError::Overflow)?;
            }
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }

        let value = workspace.next_value[depth];
        if value > i64::from(problem.maximum) {
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        workspace.next_value[depth] = value.checked_add(1).ok_or(IntegerMomentError::Overflow)?;
        metrics.prefixes = metrics
            .prefixes
            .checked_add(1)
            .ok_or(IntegerMomentError::Overflow)?;

        let value = i32::try_from(value).map_err(|_| IntegerMomentError::Overflow)?;

        let next_sum = workspace.prefix_sum[depth]
            .checked_add(value as i64)
            .ok_or(IntegerMomentError::Overflow)?;
        let square = (value as i64)
            .checked_mul(value as i64)
            .ok_or(IntegerMomentError::Overflow)?;
        let next_square_sum = workspace.prefix_square_sum[depth]
            .checked_add(square)
            .ok_or(IntegerMomentError::Overflow)?;
        let remaining = degree - depth - 1;
        let target_sum = problem
            .sum
            .checked_sub(next_sum)
            .ok_or(IntegerMomentError::Overflow)?;
        let target_square_sum = problem
            .square_sum
            .checked_sub(next_square_sum)
            .ok_or(IntegerMomentError::Overflow)?;
        if !moments_attainable(
            remaining,
            target_sum,
            target_square_sum,
            value,
            problem.maximum,
        )? {
            continue;
        }

        workspace.values[depth] = value;
        workspace.prefix_sum[depth + 1] = next_sum;
        workspace.prefix_square_sum[depth + 1] = next_square_sum;
        depth += 1;
        if depth < degree {
            workspace.next_value[depth] = i64::from(value);
        }
    }
    Ok(metrics)
}

fn moments_attainable(
    count: usize,
    sum: i64,
    square_sum: i64,
    minimum: i32,
    maximum: i32,
) -> Result<bool, IntegerMomentError> {
    if count == 0 {
        return Ok(sum == 0 && square_sum == 0);
    }
    let count = i64::try_from(count).map_err(|_| IntegerMomentError::Overflow)?;
    let minimum = minimum as i64;
    let maximum = maximum as i64;
    let least_sum = count
        .checked_mul(minimum)
        .ok_or(IntegerMomentError::Overflow)?;
    let greatest_sum = count
        .checked_mul(maximum)
        .ok_or(IntegerMomentError::Overflow)?;
    if !(least_sum..=greatest_sum).contains(&sum) || square_sum < 0 {
        return Ok(false);
    }

    let low = sum.div_euclid(count);
    let high_count = sum.rem_euclid(count);
    let low_count = count - high_count;
    let minimum_squares = low_count
        .checked_mul(low.checked_mul(low).ok_or(IntegerMomentError::Overflow)?)
        .and_then(|value| {
            value.checked_add(high_count.checked_mul((low + 1).checked_mul(low + 1)?)?)
        })
        .ok_or(IntegerMomentError::Overflow)?;

    let width = maximum - minimum;
    let excess = sum - least_sum;
    let (high_extremes, middle_excess) = if width == 0 {
        (0, 0)
    } else {
        (excess / width, excess % width)
    };
    let middle_count = i64::from(middle_excess != 0);
    let low_extremes = count - high_extremes - middle_count;
    let mut maximum_squares = high_extremes
        .checked_mul(
            maximum
                .checked_mul(maximum)
                .ok_or(IntegerMomentError::Overflow)?,
        )
        .and_then(|value| {
            value.checked_add(low_extremes.checked_mul(minimum.checked_mul(minimum)?)?)
        })
        .ok_or(IntegerMomentError::Overflow)?;
    if middle_count != 0 {
        let middle = minimum + middle_excess;
        maximum_squares = maximum_squares
            .checked_add(
                middle
                    .checked_mul(middle)
                    .ok_or(IntegerMomentError::Overflow)?,
            )
            .ok_or(IntegerMomentError::Overflow)?;
    }
    Ok((minimum_squares..=maximum_squares).contains(&square_sum))
}

/// Allocation-free 2-adic type-2 check for an integral Seidel spectrum.
///
/// `free_roots` are supplemented by `-5` and optional forced integer roots.
/// Coefficients of `Char_S(x-1)` are accumulated modulo `2^order`, enough to
/// decide every required divisibility through degree 63.
pub fn seidel_integer_spectrum_is_type2(
    order: u32,
    minus_five_multiplicity: u32,
    free_roots: &[i32],
    forced_root: Option<(i32, u32)>,
) -> Result<bool, IntegerMomentError> {
    if !(1..=63).contains(&order) {
        return Err(IntegerMomentError::Type2Order);
    }
    let forced_multiplicity = forced_root.map_or(0, |(_, multiplicity)| multiplicity);
    let free_root_count =
        u32::try_from(free_roots.len()).map_err(|_| IntegerMomentError::Type2Degree)?;
    if minus_five_multiplicity
        .checked_add(free_root_count)
        .and_then(|degree| degree.checked_add(forced_multiplicity))
        != Some(order)
    {
        return Err(IntegerMomentError::Type2Degree);
    }
    let modulus_mask = (1_u64 << order) - 1;
    let mut coefficients = [0_u64; 64];
    coefficients[0] = 1;
    for (degree, root) in std::iter::repeat_n(-5, minus_five_multiplicity as usize)
        .chain(free_roots.iter().copied())
        .chain(
            forced_root
                .into_iter()
                .flat_map(|(root, multiplicity)| std::iter::repeat_n(root, multiplicity as usize)),
        )
        .enumerate()
    {
        let shifted_root = root as i64 + 1;
        let root_mod = shifted_root as u64 & modulus_mask;
        for index in (0..=degree).rev() {
            let coefficient = coefficients[index];
            coefficients[index + 1] =
                coefficients[index + 1].wrapping_add(coefficient) & modulus_mask;
            coefficients[index] =
                0_u64.wrapping_sub(coefficient.wrapping_mul(root_mod)) & modulus_mask;
        }
    }

    let weak = order % 2 == 1;
    for index_from_leading in 1..=order {
        let exponent = if weak {
            index_from_leading - 1
        } else {
            index_from_leading
        };
        if exponent != 0 {
            let divisor_mask = (1_u64 << exponent) - 1;
            let coefficient = coefficients[(order - index_from_leading) as usize];
            if coefficient & divisor_mask != 0 {
                return Ok(false);
            }
        }
    }
    Ok(true)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn count_case(
        problem: IntegerMomentProblem,
        order: u32,
        minus_five: u32,
        forced: Option<(i32, u32)>,
    ) -> (u64, u64) {
        let mut workspace = IntegerMomentWorkspace::new(18).unwrap();
        let mut type2 = 0_u64;
        let metrics = enumerate_integer_moments(problem, &mut workspace, |roots| {
            if seidel_integer_spectrum_is_type2(order, minus_five, roots, forced).unwrap() {
                type2 += 1;
            }
        })
        .unwrap();
        (metrics.solutions, type2)
    }

    #[test]
    fn reproduces_all_c1000_stage_zero_integer_spectrum_counts() {
        let cases = [
            (
                IntegerMomentProblem {
                    degree: 18,
                    sum: 210,
                    square_sum: 2_490,
                    minimum: 6,
                    maximum: 17,
                },
                60,
                42,
                None,
                (177, 6),
            ),
            (
                IntegerMomentProblem {
                    degree: 18,
                    sum: 205,
                    square_sum: 2_397,
                    minimum: 4,
                    maximum: 19,
                },
                59,
                41,
                None,
                (722, 28),
            ),
            (
                IntegerMomentProblem {
                    degree: 18,
                    sum: 200,
                    square_sum: 2_306,
                    minimum: 2,
                    maximum: 20,
                },
                58,
                40,
                None,
                (2_066, 28),
            ),
            (
                IntegerMomentProblem {
                    degree: 12,
                    sum: 144,
                    square_sum: 1_764,
                    minimum: 6,
                    maximum: 18,
                },
                60,
                42,
                Some((11, 6)),
                (68, 6),
            ),
        ];
        for (problem, order, minus_five, forced, expected) in cases {
            assert_eq!(count_case(problem, order, minus_five, forced), expected);
        }
    }

    #[test]
    fn repeated_enumeration_reuses_the_exact_workspace() {
        let problem = IntegerMomentProblem {
            degree: 4,
            sum: 10,
            square_sum: 30,
            minimum: 0,
            maximum: 5,
        };
        let mut workspace = IntegerMomentWorkspace::new(4).unwrap();
        let pointers = (
            workspace.values.as_ptr(),
            workspace.next_value.as_ptr(),
            workspace.prefix_sum.as_ptr(),
        );
        for _ in 0..100 {
            let metrics = enumerate_integer_moments(problem, &mut workspace, |_| {}).unwrap();
            assert_eq!(metrics.solutions, 1); // (1,2,3,4)
        }
        assert_eq!(workspace.values.as_ptr(), pointers.0);
        assert_eq!(workspace.next_value.as_ptr(), pointers.1);
        assert_eq!(workspace.prefix_sum.as_ptr(), pointers.2);
    }

    #[test]
    fn moment_enumeration_loop_allocates_nothing() {
        let problem = IntegerMomentProblem {
            degree: 6,
            sum: 21,
            square_sum: 91,
            minimum: 0,
            maximum: 7,
        };
        let mut workspace = IntegerMomentWorkspace::new(6).unwrap();
        let (metrics, events) = crate::test_alloc::measure_allocations(|| {
            enumerate_integer_moments(problem, &mut workspace, |_| {}).unwrap()
        });
        assert!(metrics.prefixes > 0);
        assert_eq!(metrics.solutions, 3);
        assert_eq!(events, Default::default());
    }
}
