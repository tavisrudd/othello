//! Allocation-free symmetric scalar features for blind private evolve corpora.
//!
//! The expander has no domain labels or target predicate. It exposes elementary
//! permutation invariants so that a later learner can discover useful scopes
//! without depending on the presentation order of a tuple.

/// Copies `raw` and appends its sum, sum of squares, minimum, and maximum.
///
/// Returns `None` for an empty input, insufficient output space, or arithmetic
/// overflow. The caller owns the workspace; the hot path does not allocate.
#[inline(always)]
pub fn expand_symmetric_scalar_features(raw: &[i64], output: &mut [i64]) -> Option<usize> {
    let width = raw.len().checked_add(4)?;
    if raw.is_empty() || output.len() < width {
        return None;
    }

    output[..raw.len()].copy_from_slice(raw);
    let mut sum = 0_i64;
    let mut sum_squares = 0_i64;
    let mut minimum = raw[0];
    let mut maximum = raw[0];
    for &value in raw {
        sum = sum.checked_add(value)?;
        sum_squares = sum_squares.checked_add(value.checked_mul(value)?)?;
        minimum = minimum.min(value);
        maximum = maximum.max(value);
    }
    output[raw.len()..width].copy_from_slice(&[sum, sum_squares, minimum, maximum]);
    Some(width)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn symmetric_suffix_is_permutation_invariant_and_allocation_free() {
        let mut first = [0_i64; 8];
        let mut second = [0_i64; 8];
        let (_, allocations) = tracked_allocations(|| {
            assert_eq!(
                expand_symmetric_scalar_features(&[1, 3, 1, 2], &mut first),
                Some(8)
            );
            assert_eq!(
                expand_symmetric_scalar_features(&[2, 1, 3, 1], &mut second),
                Some(8)
            );
        });
        assert_eq!(allocations, 0);
        assert_eq!(&first[4..], &[7, 15, 1, 3]);
        assert_eq!(&first[4..], &second[4..]);
    }

    #[test]
    fn invalid_inputs_and_overflow_fail_closed() {
        let mut output = [0_i64; 8];
        assert_eq!(expand_symmetric_scalar_features(&[], &mut output), None);
        assert_eq!(
            expand_symmetric_scalar_features(&[1, 2, 3, 4], &mut output[..7]),
            None
        );
        assert_eq!(
            expand_symmetric_scalar_features(&[i64::MAX, 1], &mut output),
            None
        );
        assert_eq!(
            expand_symmetric_scalar_features(&[i64::MAX], &mut output),
            None
        );
    }
}
