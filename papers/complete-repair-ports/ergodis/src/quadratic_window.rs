//! Exact integer windows for concave quadratic obstructions.
//!
//! Many counting arguments reduce feasibility to `q(a-q) >= b`.  Solving
//! this with floating-point roots risks an off-by-one precisely at the sharp
//! boundary.  This kernel returns the exact nonnegative integer interval with
//! overflow-safe `u128` arithmetic and no allocation.

use std::ops::RangeInclusive;

/// Return every nonnegative integer `q` satisfying `q * (a - q) >= b`.
///
/// Values above `a` cannot satisfy the corresponding monic inequality
/// `q^2 - a*q + b <= 0`, so the answer is either empty or one closed interval.
#[must_use]
pub fn concave_quadratic_window(a: u64, b: u64) -> Option<RangeInclusive<u64>> {
    let midpoint = a / 2;
    if product(midpoint, a - midpoint) < u128::from(b) {
        return None;
    }
    let mut low = 0_u64;
    let mut high = midpoint;
    while low < high {
        let middle = low + (high - low) / 2;
        if product(middle, a - middle) >= u128::from(b) {
            high = middle;
        } else {
            low = middle + 1;
        }
    }
    Some(low..=a - low)
}

#[inline]
fn product(left: u64, right: u64) -> u128 {
    u128::from(left) * u128::from(right)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn extracts_exact_integral_upper_root() {
        // k=6, d=1 in the bounded-degree window: a=15, beta_6=44.
        assert_eq!(concave_quadratic_window(15, 44), Some(4..=11));
    }

    #[test]
    fn detects_an_empty_window() {
        assert_eq!(concave_quadratic_window(5, 7), None);
    }

    #[test]
    fn handles_zero_and_u64_scale_without_overflow() {
        assert_eq!(concave_quadratic_window(9, 0), Some(0..=9));
        let a = u64::MAX;
        let window = concave_quadratic_window(a, u64::MAX).unwrap();
        assert!(*window.start() > 0);
        assert_eq!(*window.end(), a - *window.start());
    }
}
