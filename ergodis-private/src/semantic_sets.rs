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

/// Pre-sized open-addressed set for bounded `u64` orbit/canonicalization keys.
///
/// The table allocates only in [`with_max_items`](Self::with_max_items).
/// Insert and lookup use Fibonacci hashing plus linear probing and allocate
/// nothing. `u64::MAX` is reserved as the empty sentinel.
#[derive(Debug, Clone)]
pub struct FixedMaskSet {
    slots: Box<[u64]>,
    mask: usize,
    shift: u32,
    len: usize,
    max_items: usize,
}

impl FixedMaskSet {
    #[must_use]
    pub fn with_max_items(max_items: usize) -> Self {
        assert!(max_items > 0, "fixed mask set must admit at least one item");
        let capacity = max_items
            .checked_mul(2)
            .and_then(usize::checked_next_power_of_two)
            .expect("fixed mask set capacity overflow");
        Self {
            slots: vec![u64::MAX; capacity].into_boxed_slice(),
            mask: capacity - 1,
            shift: u64::BITS - capacity.trailing_zeros(),
            len: 0,
            max_items,
        }
    }

    #[inline]
    fn initial_slot(&self, value: u64) -> usize {
        (value.wrapping_mul(0x9e37_79b9_7f4a_7c15) >> self.shift) as usize
    }

    /// Insert a key, returning whether it was absent. This method allocates
    /// nothing and fails closed if the declared item bound is exceeded.
    #[inline]
    pub fn insert(&mut self, value: u64) -> bool {
        assert_ne!(value, u64::MAX, "u64::MAX is the empty sentinel");
        let mut slot = self.initial_slot(value);
        loop {
            let stored = self.slots[slot];
            if stored == value {
                return false;
            }
            if stored == u64::MAX {
                assert!(
                    self.len < self.max_items,
                    "fixed mask set item bound exceeded"
                );
                self.slots[slot] = value;
                self.len += 1;
                return true;
            }
            slot = (slot + 1) & self.mask;
        }
    }

    #[must_use]
    pub fn len(&self) -> usize {
        self.len
    }

    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.len == 0
    }
}

/// Witness-bearing closure of one mask under finitely many generators.
#[derive(Debug, Clone)]
pub struct OrbitClosure {
    objects: Vec<u64>,
    parents: Vec<u32>,
    generators: Vec<u16>,
}

impl OrbitClosure {
    #[must_use]
    pub fn len(&self) -> usize {
        self.objects.len()
    }

    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.objects.is_empty()
    }

    #[must_use]
    pub fn objects(&self) -> &[u64] {
        &self.objects
    }

    /// Reconstruct a seed-to-object generator word into caller scratch.
    /// Returns `None` for an invalid index or insufficient scratch.
    pub fn transporter_word<'a>(
        &self,
        object_index: usize,
        scratch: &'a mut [u16],
    ) -> Option<&'a [u16]> {
        if object_index >= self.objects.len() {
            return None;
        }
        let mut depth = 0;
        let mut cursor = object_index;
        while self.parents[cursor] != u32::MAX {
            depth += 1;
            cursor = self.parents[cursor] as usize;
        }
        if depth > scratch.len() {
            return None;
        }
        cursor = object_index;
        let mut write = depth;
        while self.parents[cursor] != u32::MAX {
            write -= 1;
            scratch[write] = self.generators[cursor];
            cursor = self.parents[cursor] as usize;
        }
        Some(&scratch[..depth])
    }
}

/// Close one mask under a finite list of generators using pre-sized arenas.
///
/// The traversal is iterative and stack-safe. The queue, membership table,
/// parents, and generator labels allocate once from `max_items`; applying
/// edges and inserting discoveries allocate nothing. Exceeding the declared
/// orbit bound fails closed.
pub fn orbit_closure(
    seed: u64,
    generator_count: usize,
    max_items: usize,
    mut apply: impl FnMut(u64, usize) -> u64,
) -> OrbitClosure {
    assert!(generator_count > 0, "orbit closure needs a generator");
    assert!(generator_count <= u16::MAX as usize);
    assert!(max_items <= u32::MAX as usize);
    let mut seen = FixedMaskSet::with_max_items(max_items);
    let mut objects = Vec::with_capacity(max_items);
    let mut parents = Vec::with_capacity(max_items);
    let mut generators = Vec::with_capacity(max_items);
    seen.insert(seed);
    objects.push(seed);
    parents.push(u32::MAX);
    generators.push(u16::MAX);
    let mut cursor = 0;
    while cursor < objects.len() {
        let object = objects[cursor];
        let parent = cursor as u32;
        cursor += 1;
        for generator in 0..generator_count {
            let image = apply(object, generator);
            if seen.insert(image) {
                assert!(objects.len() < max_items, "orbit exceeds declared bound");
                objects.push(image);
                parents.push(parent);
                generators.push(generator as u16);
            }
        }
    }
    OrbitClosure {
        objects,
        parents,
        generators,
    }
}

/// Maximum-overlap profiler for families that split into 3-way partitions.
///
/// For an object of fixed cardinality `k` and a partition `(A, B, C)`, the
/// third overlap is `k - |object & A| - |object & B|`.  Compilation therefore
/// retains only two masks per partition.  [`observe`](Self::observe) performs
/// no allocation and uses two population counts instead of three.
#[derive(Debug, Clone)]
pub struct TernaryPartitionMaxOverlapProfiler {
    retained: Box<[[u64; 2]]>,
    universe: u64,
    object_size: u32,
    histogram: Box<[u64]>,
    kernel: unsafe fn(&[[u64; 2]], u64, u32) -> u32,
}

#[inline]
unsafe fn ternary_partition_max_generic(
    retained: &[[u64; 2]],
    object: u64,
    object_size: u32,
) -> u32 {
    let mut maximum = 0_u32;
    for &[first, second] in retained {
        let first_overlap = (object & first).count_ones();
        let second_overlap = (object & second).count_ones();
        let third_overlap = object_size - first_overlap - second_overlap;
        maximum = maximum
            .max(first_overlap)
            .max(second_overlap)
            .max(third_overlap);
    }
    maximum
}

#[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
#[target_feature(enable = "popcnt")]
unsafe fn ternary_partition_max_popcnt(
    retained: &[[u64; 2]],
    object: u64,
    object_size: u32,
) -> u32 {
    let mut maximum = 0_u32;
    for &[first, second] in retained {
        let first_overlap = (object & first).count_ones();
        let second_overlap = (object & second).count_ones();
        let third_overlap = object_size - first_overlap - second_overlap;
        maximum = maximum
            .max(first_overlap)
            .max(second_overlap)
            .max(third_overlap);
    }
    maximum
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "popcnt,sse4.1")]
unsafe fn ternary_partition_max_popcnt_sse41(
    retained: &[[u64; 2]],
    object: u64,
    object_size: u32,
) -> u32 {
    use std::arch::x86_64::{
        __m128i, _mm_add_epi32, _mm_max_epu32, _mm_set1_epi32, _mm_set_epi32, _mm_setzero_si128,
        _mm_storeu_si128, _mm_sub_epi32,
    };

    let mut maximum = _mm_setzero_si128();
    let size = _mm_set1_epi32(object_size as i32);
    let mut chunks = retained.chunks_exact(4);
    for chunk in &mut chunks {
        let first = _mm_set_epi32(
            (object & chunk[3][0]).count_ones() as i32,
            (object & chunk[2][0]).count_ones() as i32,
            (object & chunk[1][0]).count_ones() as i32,
            (object & chunk[0][0]).count_ones() as i32,
        );
        let second = _mm_set_epi32(
            (object & chunk[3][1]).count_ones() as i32,
            (object & chunk[2][1]).count_ones() as i32,
            (object & chunk[1][1]).count_ones() as i32,
            (object & chunk[0][1]).count_ones() as i32,
        );
        let third = _mm_sub_epi32(size, _mm_add_epi32(first, second));
        maximum = _mm_max_epu32(maximum, _mm_max_epu32(first, _mm_max_epu32(second, third)));
    }
    let mut lanes = [0_i32; 4];
    // SAFETY: `lanes` provides four writable, properly sized i32 lanes and
    // `_mm_storeu_si128` permits an unaligned destination.
    unsafe { _mm_storeu_si128(lanes.as_mut_ptr().cast::<__m128i>(), maximum) };
    let mut result = lanes.into_iter().max().unwrap_or(0) as u32;
    for &[first, second] in chunks.remainder() {
        let first_overlap = (object & first).count_ones();
        let second_overlap = (object & second).count_ones();
        let third_overlap = object_size - first_overlap - second_overlap;
        result = result
            .max(first_overlap)
            .max(second_overlap)
            .max(third_overlap);
    }
    result
}

fn select_ternary_partition_kernel() -> unsafe fn(&[[u64; 2]], u64, u32) -> u32 {
    #[cfg(target_arch = "x86_64")]
    if std::is_x86_feature_detected!("popcnt") && std::is_x86_feature_detected!("sse4.1") {
        return ternary_partition_max_popcnt_sse41;
    }
    #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
    if std::is_x86_feature_detected!("popcnt") {
        return ternary_partition_max_popcnt;
    }
    ternary_partition_max_generic
}

impl TernaryPartitionMaxOverlapProfiler {
    /// Compile an unordered family of distinct masks into unique 3-way
    /// partitions. Every member must be disjoint from exactly its two partners,
    /// and each resulting triple must partition `universe`.
    pub fn try_new(
        family: Vec<u64>,
        universe: u64,
        object_size: usize,
    ) -> Result<Self, &'static str> {
        if family.is_empty() || family.len() % 3 != 0 {
            return Err("ternary family size must be positive and divisible by three");
        }
        if object_size > universe.count_ones() as usize {
            return Err("object size exceeds universe");
        }
        for (index, &member) in family.iter().enumerate() {
            if member == 0 || member & !universe != 0 {
                return Err("partition member lies outside the universe");
            }
            if family[..index].contains(&member) {
                return Err("ternary family contains a duplicate member");
            }
        }
        let mut used = vec![false; family.len()];
        let mut retained = Vec::with_capacity(family.len() / 3);
        for first_index in 0..family.len() {
            if used[first_index] {
                continue;
            }
            let first = family[first_index];
            let mut partners = [usize::MAX; 2];
            let mut partner_count = 0;
            for (index, &candidate) in family.iter().enumerate() {
                if index == first_index || first & candidate != 0 {
                    continue;
                }
                if partner_count == partners.len() {
                    return Err("partition member has more than two disjoint partners");
                }
                partners[partner_count] = index;
                partner_count += 1;
            }
            if partner_count != 2 {
                return Err("partition member does not have two disjoint partners");
            }
            let [second_index, third_index] = partners;
            if used[second_index]
                || used[third_index]
                || family[second_index] & family[third_index] != 0
                || first | family[second_index] | family[third_index] != universe
            {
                return Err("family does not decompose into unique ternary partitions");
            }
            used[first_index] = true;
            used[second_index] = true;
            used[third_index] = true;
            retained.push([first, family[second_index]]);
        }
        if retained.len() * 3 != family.len() {
            return Err("partition compilation left unused family members");
        }
        Ok(Self {
            retained: retained.into_boxed_slice(),
            universe,
            object_size: object_size as u32,
            histogram: vec![0; object_size + 1].into_boxed_slice(),
            kernel: select_ternary_partition_kernel(),
        })
    }

    /// Observe one fixed-cardinality object. This method performs no allocation.
    #[inline]
    pub fn observe(&mut self, object: u64, weight: u64) -> u32 {
        debug_assert_eq!(object & !self.universe, 0);
        debug_assert_eq!(object.count_ones(), self.object_size);
        // SAFETY: construction selects a kernel only after checking its CPU
        // feature preconditions. Both kernels accept every compiled family.
        let maximum = unsafe { (self.kernel)(&self.retained, object, self.object_size) };
        self.histogram[maximum as usize] += weight;
        maximum
    }

    #[must_use]
    pub fn histogram(&self) -> &[u64] {
        &self.histogram
    }

    #[must_use]
    pub fn partitions(&self) -> usize {
        self.retained.len()
    }

    pub fn clear(&mut self) {
        self.histogram.fill(0);
    }
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
/// Gosper successors enumerate masks in increasing machine-word order.  The
/// loop is iterative, stack-safe, and entirely allocation-free.  The callback
/// should preserve that property when used in search.
#[inline]
pub fn for_each_k_subset(n: usize, k: usize, mut visit: impl FnMut(u64)) {
    assert!(n <= 64, "u64 subset universe exceeds 64 elements");
    if k > n {
        return;
    }
    if k == 0 {
        visit(0);
        return;
    }
    if k == n {
        visit(if n == 64 { u64::MAX } else { (1_u64 << n) - 1 });
        return;
    }
    let low = (1_u64 << k) - 1;
    let last = low << (n - k);
    let mut mask = low;
    loop {
        visit(mask);
        if mask == last {
            break;
        }
        let lowest = mask & mask.wrapping_neg();
        let incremented = mask + lowest;
        let packed_low_ones = ((incremented ^ mask) >> 2) >> lowest.trailing_zeros();
        mask = incremented | packed_low_ones;
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
        for_each_k_subset(64, 64, |mask| masks.push(mask));
        assert_eq!(masks, [u64::MAX]);
    }

    #[test]
    fn subset_enumerator_is_strictly_ordered_without_duplicates() {
        let mut previous = None;
        let mut count = 0;
        for_each_k_subset(12, 5, |mask| {
            if let Some(previous) = previous {
                assert!(previous < mask);
            }
            previous = Some(mask);
            count += 1;
        });
        assert_eq!(count, 792);

        let mut singleton_count = 0;
        for_each_k_subset(64, 1, |mask| {
            assert_eq!(mask.count_ones(), 1);
            singleton_count += 1;
        });
        assert_eq!(singleton_count, 64);

        let mut omitted_singleton_count = 0;
        for_each_k_subset(64, 63, |mask| {
            assert_eq!(mask.count_ones(), 63);
            omitted_singleton_count += 1;
        });
        assert_eq!(omitted_singleton_count, 64);
    }

    #[test]
    fn ternary_partitions_match_direct_overlap_exhaustively() {
        let family = vec![
            0b000_000_111,
            0b000_111_000,
            0b111_000_000,
            0b001_001_001,
            0b010_010_010,
            0b100_100_100,
        ];
        let mut direct = MaxOverlapProfiler::new(family.clone(), 4);
        let mut partitioned =
            TernaryPartitionMaxOverlapProfiler::try_new(family, 0b111_111_111, 4).unwrap();
        assert_eq!(partitioned.partitions(), 2);
        for_each_k_subset(9, 4, |object| {
            let expected = direct.observe(object, 1);
            assert_eq!(partitioned.observe(object, 1), expected);
            // SAFETY: the generic kernel has no CPU feature precondition.
            assert_eq!(
                unsafe { ternary_partition_max_generic(&partitioned.retained, object, 4) },
                expected
            );
            #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
            if std::is_x86_feature_detected!("popcnt") {
                // SAFETY: the feature check satisfies the kernel precondition.
                assert_eq!(
                    unsafe { ternary_partition_max_popcnt(&partitioned.retained, object, 4) },
                    expected
                );
            }
            #[cfg(target_arch = "x86_64")]
            if std::is_x86_feature_detected!("popcnt") && std::is_x86_feature_detected!("sse4.1") {
                // SAFETY: the feature checks satisfy the kernel preconditions.
                assert_eq!(
                    unsafe { ternary_partition_max_popcnt_sse41(&partitioned.retained, object, 4) },
                    expected
                );
            }
        });
        assert_eq!(partitioned.histogram(), direct.histogram());
        partitioned.clear();
        assert_eq!(partitioned.histogram(), &[0; 5]);
    }

    #[test]
    fn malformed_ternary_family_is_rejected() {
        assert!(TernaryPartitionMaxOverlapProfiler::try_new(
            vec![0b001, 0b010, 0b100, 0b001, 0b010, 0b100],
            0b111,
            1,
        )
        .is_err());
    }

    #[test]
    fn fixed_mask_set_handles_duplicates_and_dense_collisions() {
        let mut set = FixedMaskSet::with_max_items(1024);
        assert!(set.is_empty());
        for value in 0..1024_u64 {
            assert!(set.insert(value << 17));
            assert!(!set.insert(value << 17));
        }
        assert_eq!(set.len(), 1024);
    }

    #[test]
    fn orbit_closure_is_iterative_complete_and_bounded() {
        let orbit = orbit_closure(1, 1, 5, |mask, _| ((mask << 1) | (mask >> 4)) & 0b1_1111);
        assert!(!orbit.is_empty());
        assert_eq!(orbit.len(), 5);
        assert_eq!(
            orbit.objects().iter().fold(0, |union, &mask| union | mask),
            0b1_1111
        );
        let mut scratch = [u16::MAX; 4];
        for index in 0..orbit.len() {
            let word = orbit.transporter_word(index, &mut scratch).unwrap();
            assert_eq!(word, vec![0; index]);
        }
        assert!(orbit.transporter_word(orbit.len(), &mut scratch).is_none());
        assert!(orbit.transporter_word(4, &mut scratch[..3]).is_none());
    }

    #[test]
    fn orbit_transporter_words_replay_multiple_generators() {
        let apply = |value: u64, generator: usize| match generator {
            0 => (value + 1) % 6,
            1 => 5 - value,
            _ => unreachable!(),
        };
        let orbit = orbit_closure(0, 2, 6, apply);
        assert_eq!(orbit.len(), 6);
        let mut scratch = [u16::MAX; 6];
        for (index, &expected) in orbit.objects().iter().enumerate() {
            let word = orbit.transporter_word(index, &mut scratch).unwrap();
            let replayed = word
                .iter()
                .fold(0, |value, &generator| apply(value, generator as usize));
            assert_eq!(replayed, expected);
        }
    }
}
