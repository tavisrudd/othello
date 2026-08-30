//! Allocation-free hot-loop kernels for semantic finite-set profiling.
//!
//! Domain adapters compile incidence families to bit masks once.  Search then
//! streams object masks through [`MaxOverlapProfiler`] and may enumerate fixed
//! cardinality universes with [`for_each_k_subset`].  Neither hot loop allocates.

/// Profiles maximum intersection with a precompiled family of subsets.
#[derive(Debug, Clone)]
pub struct MaxOverlapProfiler {
    family: Box<[u64]>,
    histogram: Box<[u64]>,
}

impl MaxOverlapProfiler {
    #[must_use]
    pub fn new(family: Vec<u64>, maximum_object_size: usize) -> Self {
        assert!(!family.is_empty(), "semantic family must be nonempty");
        Self {
            family: family.into_boxed_slice(),
            histogram: vec![0; maximum_object_size + 1].into_boxed_slice(),
        }
    }

    /// Observe one object. This method performs no allocation.
    #[inline]
    pub fn observe(&mut self, object: u64, weight: u64) -> u32 {
        let mut maximum = 0_u32;
        for &member in &self.family {
            maximum = maximum.max((object & member).count_ones());
        }
        self.histogram[maximum as usize] += weight;
        maximum
    }

    #[must_use]
    pub fn histogram(&self) -> &[u64] {
        &self.histogram
    }

    pub fn clear(&mut self) {
        self.histogram.fill(0);
    }
}

/// Visit every `k`-subset of an `n`-element universe as a `u64` mask.
///
/// The combination storage is allocated once before the first callback.  The
/// enumeration is iterative and stack-safe; the steady-state loop allocates
/// nothing.  The callback should preserve that property when used in search.
pub fn for_each_k_subset(n: usize, k: usize, mut visit: impl FnMut(u64)) {
    assert!(n <= 64, "u64 subset universe exceeds 64 elements");
    if k > n {
        return;
    }
    if k == 0 {
        visit(0);
        return;
    }
    let mut indices: Vec<usize> = (0..k).collect();
    loop {
        let mut mask = 0_u64;
        for &index in &indices {
            mask |= 1_u64 << index;
        }
        visit(mask);

        let mut pivot = k;
        while pivot > 0 {
            pivot -= 1;
            if indices[pivot] != pivot + n - k {
                break;
            }
        }
        if pivot == 0 && indices[0] == n - k {
            break;
        }
        indices[pivot] += 1;
        for index in (pivot + 1)..k {
            indices[index] = indices[index - 1] + 1;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn overlap_profile_is_weighted_and_reusable() {
        let mut profiler = MaxOverlapProfiler::new(vec![0b000_111, 0b111_000], 3);
        assert_eq!(profiler.observe(0b001_011, 2), 2);
        assert_eq!(profiler.observe(0b000_111, 3), 3);
        assert_eq!(profiler.histogram(), &[0, 0, 2, 3]);
        profiler.clear();
        assert_eq!(profiler.histogram(), &[0, 0, 0, 0]);
    }

    #[test]
    fn iterative_subset_enumerator_is_complete() {
        let mut count = 0_u64;
        let mut union = 0_u64;
        for_each_k_subset(9, 3, |mask| {
            assert_eq!(mask.count_ones(), 3);
            count += 1;
            union |= mask;
        });
        assert_eq!(count, 84);
        assert_eq!(union, (1_u64 << 9) - 1);
    }

    #[test]
    fn subset_enumerator_handles_boundaries() {
        let mut masks = Vec::new();
        for_each_k_subset(4, 0, |mask| masks.push(mask));
        assert_eq!(masks, [0]);
        masks.clear();
        for_each_k_subset(4, 5, |mask| masks.push(mask));
        assert!(masks.is_empty());
    }
}
