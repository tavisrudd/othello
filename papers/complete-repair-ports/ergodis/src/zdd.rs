use num_bigint::BigUint;
use num_traits::{One, Zero};

pub(crate) const EMPTY: u32 = 0;
pub(crate) const UNIT: u32 = 1;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
struct Node {
    low: u32,
    high: u32,
    meta: u32,
}

const _: () = assert!(std::mem::size_of::<Node>() == 12);
const _: () = assert!(std::mem::align_of::<Node>() == 4);

#[inline]
fn node_key(variable: u32, low: u32, high: u32) -> u64 {
    debug_assert!(variable < 1 << 8 && low < 1 << 24 && high < 1 << 24);
    u64::from(variable) | (u64::from(low) << 8) | (u64::from(high) << 32)
}

#[derive(Debug)]
struct UniqueTable {
    buckets: Vec<u32>,
    links: Vec<u32>,
    grow_at: usize,
}

impl UniqueTable {
    fn with_capacities(expected_nodes: usize, link_capacity: usize) -> Self {
        let slots = expected_nodes
            .saturating_mul(10)
            .div_ceil(7)
            .next_power_of_two()
            .max(16);
        Self {
            buckets: vec![EMPTY; slots],
            links: Vec::with_capacity(link_capacity),
            grow_at: slots * 7 / 10,
        }
    }

    #[inline]
    fn slot(&self, key: u64) -> usize {
        ((key.wrapping_mul(0x9e37_79b9_7f4a_7c15) >> 32) as usize) & (self.buckets.len() - 1)
    }

    #[inline(always)]
    fn intern(
        &mut self,
        nodes: &[Node],
        variable: u32,
        low: u32,
        high: u32,
        allow_insert: bool,
    ) -> Option<(u32, bool)> {
        if allow_insert && nodes.len() == self.grow_at {
            self.grow(nodes);
        }
        let key = node_key(variable, low, high);
        let slot = self.slot(key);
        let mut root = self.buckets[slot];
        while root != EMPTY {
            let index = (root - 2) as usize;
            let node = nodes[index];
            if node.meta & 0xff == variable && node.low == low && node.high == high {
                return Some((root, false));
            }
            root = self.links[index];
        }
        if !allow_insert {
            return None;
        }
        let candidate = nodes.len() as u32 + 2;
        self.links.push(self.buckets[slot]);
        self.buckets[slot] = candidate;
        Some((candidate, true))
    }

    #[cold]
    #[inline(never)]
    fn grow(&mut self, nodes: &[Node]) {
        self.buckets.fill(EMPTY);
        self.buckets.resize(self.buckets.len() * 2, EMPTY);
        self.grow_at = self.buckets.len() * 7 / 10;
        for (index, &node) in nodes.iter().enumerate() {
            let root = index as u32 + 2;
            let key = node_key(node.meta & 0xff, node.low, node.high);
            let slot = self.slot(key);
            self.links[index] = self.buckets[slot];
            self.buckets[slot] = root;
        }
    }

    fn capacities(&self) -> (usize, usize) {
        (self.buckets.capacity(), self.links.capacity())
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
#[cfg(test)]
struct MapEntry {
    key: u64,
    value: u32,
    _pad: u32,
}

#[cfg(test)]
const _: () = assert!(std::mem::size_of::<MapEntry>() == 16);
#[cfg(test)]
const _: () = assert!(std::mem::align_of::<MapEntry>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct DirectEntry {
    key_low: u32,
    key_high: u32,
    value: u32,
}

const _: () = assert!(std::mem::size_of::<DirectEntry>() == 12);
const _: () = assert!(std::mem::align_of::<DirectEntry>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct UnionFrame {
    key: u64,
    high_left: u32,
    high_right: u32,
    low: u32,
    variable: u32,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
struct FrontierRange {
    start: u32,
    len: u32,
}

const _: () = assert!(std::mem::size_of::<FrontierRange>() == 8);
const _: () = assert!(std::mem::align_of::<FrontierRange>() == 4);

#[derive(Debug)]
pub(crate) struct AggregatedFrontier {
    pub(crate) codes: Box<[u64]>,
    pub(crate) supports: Box<[Box<[u8]>]>,
    pub(crate) strides: Box<[u64]>,
}

const _: () = assert!(std::mem::size_of::<UnionFrame>() == 24);
const _: () = assert!(std::mem::align_of::<UnionFrame>() == 8);

#[derive(Debug)]
#[cfg(test)]
pub(crate) struct FlatMap {
    entries: Vec<MapEntry>,
    mask: usize,
    len: usize,
    grow_at: usize,
}

#[cfg(test)]
impl FlatMap {
    fn with_capacity(capacity: usize) -> Self {
        let slots = capacity
            .saturating_mul(10)
            .div_ceil(7)
            .next_power_of_two()
            .max(16);
        Self {
            entries: vec![
                MapEntry {
                    key: 0,
                    value: 0,
                    _pad: 0,
                };
                slots
            ],
            mask: slots - 1,
            len: 0,
            grow_at: slots * 7 / 10,
        }
    }

    #[inline]
    fn slot(&self, key: u64) -> usize {
        ((key.wrapping_mul(0x9e37_79b9_7f4a_7c15) >> 32) as usize) & self.mask
    }

    #[inline]
    fn get(&self, key: u64) -> Option<u32> {
        debug_assert_ne!(key, 0);
        let mut slot = self.slot(key);
        loop {
            let entry = self.entries[slot];
            if entry.key == key {
                return Some(entry.value);
            }
            if entry.key == 0 {
                return None;
            }
            slot = (slot + 1) & self.mask;
        }
    }

    fn insert(&mut self, key: u64, value: u32) {
        debug_assert_ne!(key, 0);
        if self.len == self.grow_at {
            self.grow();
        }
        self.insert_without_grow(key, value);
    }

    fn insert_without_grow(&mut self, key: u64, value: u32) {
        let mut slot = self.slot(key);
        loop {
            let entry = &mut self.entries[slot];
            if entry.key == key {
                entry.value = value;
                return;
            }
            if entry.key == 0 {
                *entry = MapEntry {
                    key,
                    value,
                    _pad: 0,
                };
                self.len += 1;
                return;
            }
            slot = (slot + 1) & self.mask;
        }
    }

    fn grow(&mut self) {
        let old = std::mem::replace(
            &mut self.entries,
            vec![
                MapEntry {
                    key: 0,
                    value: 0,
                    _pad: 0,
                };
                (self.mask + 1) * 2
            ],
        );
        self.mask = self.entries.len() - 1;
        self.len = 0;
        self.grow_at = self.entries.len() * 7 / 10;
        for entry in old {
            if entry.key != 0 {
                self.insert_without_grow(entry.key, entry.value);
            }
        }
    }
}

pub(crate) trait ZddMemo: std::fmt::Debug {
    fn with_capacity(capacity: usize) -> Self;
    fn get(&self, key: u64) -> Option<u32>;
    fn insert(&mut self, key: u64, value: u32);
    fn capacity(&self) -> usize;
    fn join_capacity(capacity: usize) -> usize;
    fn avoid_capacity(capacity: usize) -> usize;
}

#[cfg(test)]
impl ZddMemo for FlatMap {
    fn with_capacity(capacity: usize) -> Self {
        Self::with_capacity(capacity)
    }

    #[inline]
    fn get(&self, key: u64) -> Option<u32> {
        self.get(key)
    }

    #[inline]
    fn insert(&mut self, key: u64, value: u32) {
        self.insert(key, value);
    }

    fn capacity(&self) -> usize {
        self.entries.capacity()
    }

    fn join_capacity(capacity: usize) -> usize {
        capacity / 2
    }

    fn avoid_capacity(capacity: usize) -> usize {
        capacity / 2
    }
}

#[derive(Debug)]
pub(crate) struct DirectMemo {
    entries: Vec<DirectEntry>,
    mask: usize,
}

impl ZddMemo for DirectMemo {
    fn with_capacity(capacity: usize) -> Self {
        let slots = capacity.div_ceil(4).next_power_of_two().max(16);
        Self {
            entries: vec![
                DirectEntry {
                    key_low: 0,
                    key_high: 0,
                    value: 0,
                };
                slots
            ],
            mask: slots - 1,
        }
    }

    #[inline]
    fn get(&self, key: u64) -> Option<u32> {
        let entry =
            self.entries[((key.wrapping_mul(0x9e37_79b9_7f4a_7c15) >> 32) as usize) & self.mask];
        (entry.key_low == key as u32 && entry.key_high == (key >> 32) as u32).then_some(entry.value)
    }

    #[inline]
    fn insert(&mut self, key: u64, value: u32) {
        let slot = ((key.wrapping_mul(0x9e37_79b9_7f4a_7c15) >> 32) as usize) & self.mask;
        self.entries[slot] = DirectEntry {
            key_low: key as u32,
            key_high: (key >> 32) as u32,
            value,
        };
    }

    fn capacity(&self) -> usize {
        self.entries.capacity()
    }

    fn join_capacity(capacity: usize) -> usize {
        capacity
    }

    fn avoid_capacity(capacity: usize) -> usize {
        capacity
    }
}

#[derive(Debug)]
pub(crate) struct Zdd<M: ZddMemo> {
    nodes: Vec<Node>,
    unique: UniqueTable,
    union_cache: M,
    join_cache: M,
    avoid_cache: M,
    minimal_cache: Vec<u32>,
    union_stack: Vec<UnionFrame>,
    node_budget: usize,
    operations: u64,
    initial_capacities: [usize; 8],
}

#[cfg(test)]
impl Zdd<FlatMap> {
    #[cfg(test)]
    fn new(node_budget: usize) -> Self {
        Self::with_capacity(node_budget, node_budget.min(1 << 10))
    }
}

impl<M: ZddMemo> Zdd<M> {
    #[cfg(test)]
    pub(crate) fn with_capacity(node_budget: usize, capacity_hint: usize) -> Self {
        Self::with_capacities(node_budget, capacity_hint, capacity_hint)
    }

    pub(crate) fn with_capacities(
        node_budget: usize,
        node_capacity_hint: usize,
        memo_capacity_hint: usize,
    ) -> Self {
        let node_budget = node_budget.min((1 << 24) - 2);
        let node_capacity_hint = node_capacity_hint.min(node_budget);
        let memo_capacity = memo_capacity_hint.min(node_budget);
        let node_capacity = node_capacity_hint
            .saturating_add(node_capacity_hint / 8)
            .saturating_add(2)
            .min(node_budget);
        let mut minimal_cache = Vec::with_capacity(node_capacity + 2);
        minimal_cache.extend([EMPTY, UNIT]);
        let nodes = Vec::with_capacity(node_capacity);
        let unique = UniqueTable::with_capacities(node_capacity_hint, node_capacity);
        let union_cache = M::with_capacity(memo_capacity);
        let join_cache = M::with_capacity(M::join_capacity(memo_capacity));
        let avoid_cache = M::with_capacity(M::avoid_capacity(memo_capacity));
        let union_stack = Vec::with_capacity(256);
        let unique_capacities = unique.capacities();
        let initial_capacities = [
            nodes.capacity(),
            unique_capacities.0,
            unique_capacities.1,
            union_cache.capacity(),
            join_cache.capacity(),
            avoid_cache.capacity(),
            minimal_cache.capacity(),
            union_stack.capacity(),
        ];
        Self {
            nodes,
            unique,
            union_cache,
            join_cache,
            avoid_cache,
            minimal_cache,
            union_stack,
            node_budget,
            operations: 0,
            initial_capacities,
        }
    }

    pub(crate) fn node_count(&self) -> usize {
        self.nodes.len()
    }

    pub(crate) fn node_budget(&self) -> usize {
        self.node_budget
    }

    pub(crate) fn operations(&self) -> u64 {
        self.operations
    }

    pub(crate) fn storage_grew(&self) -> bool {
        let unique_capacities = self.unique.capacities();
        let capacities = [
            self.nodes.capacity(),
            unique_capacities.0,
            unique_capacities.1,
            self.union_cache.capacity(),
            self.join_cache.capacity(),
            self.avoid_cache.capacity(),
            self.minimal_cache.capacity(),
            self.union_stack.capacity(),
        ];
        capacities
            .iter()
            .zip(self.initial_capacities)
            .any(|(&current, initial)| current != initial)
    }

    fn node(&self, root: u32) -> Node {
        self.nodes[(root - 2) as usize]
    }

    fn variable(&self, root: u32) -> u32 {
        if root < 2 {
            u32::MAX
        } else {
            self.node(root).meta & 0xff
        }
    }

    fn split(&self, root: u32, variable: u32) -> (u32, u32) {
        if root >= 2 {
            let node = self.node(root);
            if node.meta & 0xff == variable {
                return (node.low, node.high);
            }
        }
        (root, EMPTY)
    }

    fn pair_key(left: u32, right: u32) -> u64 {
        debug_assert!(left < 1 << 24 && right < 1 << 24);
        u64::from(left) | (u64::from(right) << 24)
    }

    fn commutative_key(left: u32, right: u32) -> u64 {
        if left < right {
            Self::pair_key(left, right)
        } else {
            Self::pair_key(right, left)
        }
    }

    fn make(&mut self, variable: u32, low: u32, high: u32) -> Option<u32> {
        if high == EMPTY {
            return Some(low);
        }
        let (root, inserted) = self.unique.intern(
            &self.nodes,
            variable,
            low,
            high,
            self.nodes.len() < self.node_budget,
        )?;
        if !inserted {
            return Some(root);
        }
        debug_assert_eq!(root, self.nodes.len() as u32 + 2);
        self.nodes.push(Node {
            low,
            high,
            meta: variable | (u32::from(self.contains_empty(low)) << 8),
        });
        self.minimal_cache.push(u32::MAX);
        Some(root)
    }

    pub(crate) fn singleton(&mut self, variable: u32) -> Option<u32> {
        self.make(variable, EMPTY, UNIT)
    }

    pub(crate) fn union(&mut self, mut left: u32, mut right: u32) -> Option<u32> {
        debug_assert!(self.union_stack.is_empty());
        let mut result;
        loop {
            result = loop {
                if left == EMPTY || left == right {
                    break right;
                }
                if right == EMPTY {
                    break left;
                }
                let key = Self::commutative_key(left, right);
                if let Some(root) = self.union_cache.get(key) {
                    break root;
                }
                self.operations += 1;
                let variable = self.variable(left).min(self.variable(right));
                let (left_low, left_high) = self.split(left, variable);
                let (right_low, right_high) = self.split(right, variable);
                self.union_stack.push(UnionFrame {
                    key,
                    high_left: left_high,
                    high_right: right_high,
                    low: u32::MAX,
                    variable,
                });
                left = left_low;
                right = right_low;
            };

            loop {
                let Some(mut frame) = self.union_stack.pop() else {
                    return Some(result);
                };
                if frame.low == u32::MAX {
                    frame.low = result;
                    left = frame.high_left;
                    right = frame.high_right;
                    self.union_stack.push(frame);
                    break;
                }
                let Some(root) = self.make(frame.variable, frame.low, result) else {
                    self.union_stack.clear();
                    return None;
                };
                self.union_cache.insert(frame.key, root);
                result = root;
            }
        }
    }

    pub(crate) fn join(&mut self, left: u32, right: u32) -> Option<u32> {
        if left == EMPTY || right == EMPTY {
            return Some(EMPTY);
        }
        if left == UNIT {
            return Some(right);
        }
        if right == UNIT {
            return Some(left);
        }
        let key = Self::commutative_key(left, right);
        if let Some(root) = self.join_cache.get(key) {
            return Some(root);
        }
        self.operations += 1;
        let variable = self.variable(left).min(self.variable(right));
        let (left_low, left_high) = self.split(left, variable);
        let (right_low, right_high) = self.split(right, variable);
        let low = self.join(left_low, right_low)?;
        let left_only = self.join(left_high, right_low)?;
        let right_only = self.join(left_low, right_high)?;
        let both = self.join(left_high, right_high)?;
        let one_high = self.union(left_only, right_only)?;
        let high = self.union(one_high, both)?;
        let root = self.make(variable, low, high)?;
        self.join_cache.insert(key, root);
        Some(root)
    }

    fn contains_empty(&self, root: u32) -> bool {
        root == UNIT || root >= 2 && self.node(root).meta & 0x100 != 0
    }

    fn avoid_supersets(&mut self, family: u32, subsets: u32) -> Option<u32> {
        if family == EMPTY || subsets == EMPTY {
            return Some(family);
        }
        if family == subsets {
            return Some(EMPTY);
        }
        let key = Self::pair_key(family, subsets);
        if let Some(root) = self.avoid_cache.get(key) {
            return Some(root);
        }
        if self.contains_empty(subsets) {
            return Some(EMPTY);
        }
        if family == UNIT {
            return Some(UNIT);
        }
        self.operations += 1;
        let family_variable = self.variable(family);
        let subset_variable = self.variable(subsets);
        let root = if family_variable < subset_variable {
            let node = self.node(family);
            let low = self.avoid_supersets(node.low, subsets)?;
            let high = self.avoid_supersets(node.high, subsets)?;
            self.make(family_variable, low, high)?
        } else if subset_variable < family_variable {
            let subset_low = self.node(subsets).low;
            self.avoid_supersets(family, subset_low)?
        } else {
            let family_node = self.node(family);
            let subset_node = self.node(subsets);
            let low = self.avoid_supersets(family_node.low, subset_node.low)?;
            let all_subset_tails = self.union(subset_node.low, subset_node.high)?;
            let high = self.avoid_supersets(family_node.high, all_subset_tails)?;
            self.make(family_variable, low, high)?
        };
        self.avoid_cache.insert(key, root);
        Some(root)
    }

    pub(crate) fn minimal(&mut self, root: u32) -> Option<u32> {
        if root < 2 {
            return Some(root);
        }
        if self.contains_empty(root) {
            return Some(UNIT);
        }
        let cached = self.minimal_cache[root as usize];
        if cached != u32::MAX {
            return Some(cached);
        }
        self.operations += 1;
        let node = self.node(root);
        let low = self.minimal(node.low)?;
        let high = self.minimal(node.high)?;
        let high = self.avoid_supersets(high, low)?;
        let minimal = self.make(node.meta & 0xff, low, high)?;
        self.minimal_cache[root as usize] = minimal;
        Some(minimal)
    }

    pub(crate) fn count(&self, root: u32) -> Option<u64> {
        const UNKNOWN: u64 = u64::MAX;

        fn visit<M: ZddMemo>(zdd: &Zdd<M>, root: u32, cache: &mut [u64]) -> Option<u64> {
            if root == EMPTY {
                return Some(0);
            }
            if root == UNIT {
                return Some(1);
            }
            let cached = cache[root as usize];
            if cached != UNKNOWN {
                return Some(cached);
            }
            let node = zdd.node(root);
            let count = visit(zdd, node.low, cache)?.checked_add(visit(zdd, node.high, cache)?)?;
            cache[root as usize] = count;
            Some(count)
        }
        let mut cache = vec![UNKNOWN; self.nodes.len() + 2];
        cache[EMPTY as usize] = 0;
        cache[UNIT as usize] = 1;
        visit(self, root, &mut cache)
    }

    pub(crate) fn first(&self, mut root: u32) -> Option<Box<[u8]>> {
        if root == EMPTY {
            return None;
        }
        let mut support = [0u8; 256];
        let mut len = 0;
        while root >= 2 {
            let node = self.node(root);
            if node.low != EMPTY {
                root = node.low;
            } else {
                support[len] = (node.meta & 0xff) as u8;
                len += 1;
                root = node.high;
            }
        }
        (root == UNIT).then(|| Box::from(&support[..len]))
    }

    pub(crate) fn reliability_counts(
        &mut self,
        root: u32,
        included_variables: &[bool],
    ) -> Option<Box<[BigUint]>> {
        fn binomial_row(size: usize) -> Vec<BigUint> {
            let mut row = Vec::with_capacity(size + 1);
            row.push(BigUint::one());
            for index in 1..=size {
                let next = (&row[index - 1] * (size + 1 - index)) / index;
                row.push(next);
            }
            row
        }

        fn convolve_binomial(values: &[BigUint], gap: usize) -> Vec<BigUint> {
            if gap == 0 {
                return values.to_vec();
            }
            let binomial = binomial_row(gap);
            let mut output = vec![BigUint::zero(); values.len() + gap];
            for (left_index, left) in values.iter().enumerate() {
                for (right_index, right) in binomial.iter().enumerate() {
                    output[left_index + right_index] += left * right;
                }
            }
            output
        }

        fn counts_from<M: ZddMemo>(
            zdd: &mut Zdd<M>,
            root: u32,
            start: usize,
            included_variables: &[bool],
            memo: &mut Vec<Option<Box<[BigUint]>>>,
        ) -> Option<Vec<BigUint>> {
            let variable_count = included_variables.len();
            if start > variable_count {
                return None;
            }
            if root == EMPTY {
                let remaining = included_variables[start..]
                    .iter()
                    .filter(|&&keep| keep)
                    .count();
                return Some(vec![BigUint::zero(); remaining + 1]);
            }
            if root == UNIT {
                let remaining = included_variables[start..]
                    .iter()
                    .filter(|&&keep| keep)
                    .count();
                return Some(binomial_row(remaining));
            }
            let variable = zdd.variable(root) as usize;
            if variable < start || variable >= variable_count || !included_variables[variable] {
                return None;
            }
            if memo.len() <= root as usize {
                memo.resize(root as usize + 1, None);
            }
            let core = if let Some(cached) = &memo[root as usize] {
                cached.to_vec()
            } else {
                let node = zdd.node(root);
                let low = counts_from(zdd, node.low, variable + 1, included_variables, memo)?;
                let high_root = zdd.union(node.low, node.high)?;
                let high = counts_from(zdd, high_root, variable + 1, included_variables, memo)?;
                let tail_size = included_variables[variable + 1..]
                    .iter()
                    .filter(|&&keep| keep)
                    .count();
                let mut counts = vec![BigUint::zero(); tail_size + 2];
                for (weight, count) in low.into_iter().enumerate() {
                    counts[weight] += count;
                }
                for (weight, count) in high.into_iter().enumerate() {
                    counts[weight + 1] += count;
                }
                memo[root as usize] = Some(counts.clone().into_boxed_slice());
                counts
            };
            let gap = included_variables[start..variable]
                .iter()
                .filter(|&&keep| keep)
                .count();
            Some(convolve_binomial(&core, gap))
        }

        counts_from(self, root, 0, included_variables, &mut Vec::new()).map(Vec::into_boxed_slice)
    }

    pub(crate) fn aggregate_frontier(
        &self,
        root: u32,
        resource_of_variable: &[u8],
        capacities: &[u32],
        frontier_budget: usize,
    ) -> Option<AggregatedFrontier> {
        fn dominates(left: u64, right: u64, strides: &[u64], capacities: &[u32]) -> bool {
            strides.iter().zip(capacities).all(|(&stride, &capacity)| {
                let radix = u64::from(capacity) + 1;
                left / stride % radix <= right / stride % radix
            })
        }

        let mut strides = Vec::with_capacity(capacities.len());
        let mut state_space = 1u64;
        for &capacity in capacities {
            strides.push(state_space);
            state_space = state_space.checked_mul(u64::from(capacity) + 1)?;
        }
        let mut reachable = vec![false; self.nodes.len() + 2];
        let mut stack = Vec::with_capacity(256);
        stack.push(root);
        while let Some(current) = stack.pop() {
            if current < 2 || std::mem::replace(&mut reachable[current as usize], true) {
                continue;
            }
            let node = self.node(current);
            stack.push(node.low);
            stack.push(node.high);
        }

        let mut ranges = vec![FrontierRange::default(); self.nodes.len() + 2];
        let mut pool = vec![0u64];
        ranges[UNIT as usize] = FrontierRange { start: 0, len: 1 };
        let mut scratch = Vec::<u64>::new();
        for root_index in 2..ranges.len() {
            if !reachable[root_index] {
                continue;
            }
            let node = self.node(root_index as u32);
            let resource = *resource_of_variable.get((node.meta & 0xff) as usize)? as usize;
            let &stride = strides.get(resource)?;
            let radix = u64::from(*capacities.get(resource)?) + 1;
            let low_range = ranges[node.low as usize];
            let high_range = ranges[node.high as usize];
            let low = &pool[low_range.start as usize..(low_range.start + low_range.len) as usize];
            let high =
                &pool[high_range.start as usize..(high_range.start + high_range.len) as usize];
            scratch.clear();
            let mut low_index = 0;
            let mut high_index = 0;
            while low_index < low.len() || high_index < high.len() {
                while high_index < high.len() && high[high_index] / stride % radix + 1 >= radix {
                    high_index += 1;
                }
                let low_code = low.get(low_index).copied();
                let high_code = high.get(high_index).copied().map(|code| code + stride);
                let next = match (low_code, high_code) {
                    (Some(left), Some(right)) if left <= right => {
                        low_index += 1;
                        left
                    }
                    (Some(_), Some(right)) => {
                        high_index += 1;
                        right
                    }
                    (Some(left), None) => {
                        low_index += 1;
                        left
                    }
                    (None, Some(right)) => {
                        high_index += 1;
                        right
                    }
                    (None, None) => break,
                };
                if scratch.last() == Some(&next)
                    || scratch
                        .iter()
                        .any(|&existing| dominates(existing, next, &strides, capacities))
                {
                    continue;
                }
                scratch.push(next);
                if pool.len().saturating_add(scratch.len()) > frontier_budget {
                    return None;
                }
            }
            let start = u32::try_from(pool.len()).ok()?;
            let len = u32::try_from(scratch.len()).ok()?;
            pool.extend_from_slice(&scratch);
            ranges[root_index] = FrontierRange { start, len };
        }

        let root_range = ranges[root as usize];
        let codes =
            pool[root_range.start as usize..(root_range.start + root_range.len) as usize].to_vec();
        let mut supports = Vec::with_capacity(codes.len());
        for &target_code in &codes {
            let mut current = root;
            let mut code = target_code;
            let mut support = Vec::new();
            while current >= 2 {
                let node = self.node(current);
                let low_range = ranges[node.low as usize];
                let low_codes =
                    &pool[low_range.start as usize..(low_range.start + low_range.len) as usize];
                if low_codes.binary_search(&code).is_ok() {
                    current = node.low;
                    continue;
                }
                let variable = (node.meta & 0xff) as usize;
                let resource = resource_of_variable[variable] as usize;
                let stride = strides[resource];
                if code < stride {
                    return None;
                }
                code -= stride;
                let high_range = ranges[node.high as usize];
                let high_codes =
                    &pool[high_range.start as usize..(high_range.start + high_range.len) as usize];
                if high_codes.binary_search(&code).is_err() {
                    return None;
                }
                support.push(variable as u8);
                current = node.high;
            }
            if current != UNIT || code != 0 {
                return None;
            }
            supports.push(support.into_boxed_slice());
        }
        Some(AggregatedFrontier {
            codes: codes.into_boxed_slice(),
            supports: supports.into_boxed_slice(),
            strides: strides.into_boxed_slice(),
        })
    }

    #[cfg(test)]
    fn collect(&self, root: u32) -> Vec<Vec<u32>> {
        fn visit<M: ZddMemo>(
            zdd: &Zdd<M>,
            root: u32,
            prefix: &mut Vec<u32>,
            output: &mut Vec<Vec<u32>>,
        ) {
            if root == EMPTY {
                return;
            }
            if root == UNIT {
                output.push(prefix.clone());
                return;
            }
            let node = zdd.node(root);
            visit(zdd, node.low, prefix, output);
            prefix.push(node.meta & 0xff);
            visit(zdd, node.high, prefix, output);
            prefix.pop();
        }
        let mut output = Vec::new();
        visit(self, root, &mut Vec::new(), &mut output);
        output.sort();
        output
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn masks<M: ZddMemo>(zdd: &Zdd<M>, root: u32) -> Vec<u8> {
        let mut masks = zdd
            .collect(root)
            .into_iter()
            .map(|support| {
                support
                    .into_iter()
                    .fold(0u8, |mask, variable| mask | (1 << variable))
            })
            .collect::<Vec<_>>();
        masks.sort_unstable();
        masks
    }

    fn mask_family<M: ZddMemo>(zdd: &mut Zdd<M>, masks: &[u8]) -> u32 {
        let supports = masks
            .iter()
            .map(|&mask| {
                (0..4)
                    .filter(|&variable| mask & (1 << variable) != 0)
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>();
        let slices = supports.iter().map(Vec::as_slice).collect::<Vec<_>>();
        family(zdd, &slices)
    }

    fn canonical(mut family: Vec<u8>) -> Vec<u8> {
        family.sort_unstable();
        family.dedup();
        family
    }

    fn minimal_masks(family: &[u8]) -> Vec<u8> {
        canonical(
            family
                .iter()
                .copied()
                .filter(|&candidate| {
                    !family
                        .iter()
                        .any(|&other| other != candidate && other & candidate == other)
                })
                .collect(),
        )
    }

    fn family<M: ZddMemo>(zdd: &mut Zdd<M>, supports: &[&[u32]]) -> u32 {
        let mut root = EMPTY;
        for support in supports {
            let mut singleton = UNIT;
            for &variable in support.iter().rev() {
                singleton = zdd.make(variable, EMPTY, singleton).unwrap();
            }
            root = zdd.union(root, singleton).unwrap();
        }
        root
    }

    #[test]
    fn union_join_and_minimal_match_set_semantics() {
        let mut zdd = Zdd::new(10_000);
        let left = family(&mut zdd, &[&[0], &[1, 2]]);
        let right = family(&mut zdd, &[&[1], &[2, 3]]);
        let union = zdd.union(left, right).unwrap();
        assert_eq!(
            zdd.collect(union),
            vec![vec![0], vec![1], vec![1, 2], vec![2, 3]]
        );
        let join = zdd.join(left, right).unwrap();
        assert_eq!(
            zdd.collect(join),
            vec![vec![0, 1], vec![0, 2, 3], vec![1, 2], vec![1, 2, 3]]
        );
        let minimal = zdd.minimal(union).unwrap();
        assert_eq!(zdd.collect(minimal), vec![vec![0], vec![1], vec![2, 3]]);
    }

    #[test]
    fn count_and_first_do_not_enumerate_the_family() {
        let mut zdd = Zdd::new(10_000);
        let root = family(&mut zdd, &[&[0, 2], &[1, 3], &[0, 3]]);
        assert_eq!(zdd.count(root), Some(3));
        assert_eq!(zdd.first(root).as_deref(), Some([1, 3].as_slice()));
    }

    #[test]
    fn a_family_containing_empty_has_only_empty_as_a_minimum() {
        let mut zdd = Zdd::new(10_000);
        let with_empty = family(&mut zdd, &[&[], &[0, 1]]);
        assert_eq!(zdd.minimal(with_empty), Some(UNIT));
    }

    #[test]
    #[allow(clippy::manual_contains)] // This is a subset test, not equality.
    fn seeded_operations_match_explicit_set_families() {
        #[allow(clippy::manual_contains)] // This is a subset test, not equality.
        fn check<M: ZddMemo>(mut zdd: Zdd<M>, left_masks: &[u8], right_masks: &[u8]) {
            let left = mask_family(&mut zdd, left_masks);
            let right = mask_family(&mut zdd, right_masks);

            let union = zdd.union(left, right).unwrap();
            assert_eq!(
                masks(&zdd, union),
                canonical([left_masks, right_masks].concat())
            );

            let join = zdd.join(left, right).unwrap();
            let expected_join = canonical(
                left_masks
                    .iter()
                    .flat_map(|&left| right_masks.iter().map(move |&right| left | right))
                    .collect(),
            );
            assert_eq!(masks(&zdd, join), expected_join);

            let minimal = zdd.minimal(union).unwrap();
            assert_eq!(masks(&zdd, minimal), minimal_masks(&masks(&zdd, union)));

            let avoided = zdd.avoid_supersets(left, right).unwrap();
            let expected_avoided = canonical(
                left_masks
                    .iter()
                    .copied()
                    .filter(|&candidate| {
                        !right_masks
                            .iter()
                            .any(|&subset| candidate & subset == subset)
                    })
                    .collect(),
            );
            assert_eq!(masks(&zdd, avoided), expected_avoided);
        }

        let mut state = 0x8c67_4a51_29d3_beefu64;
        for _ in 0..256 {
            let mut draw_family = || {
                let len = (state as usize & 7) + 1;
                (0..len)
                    .map(|_| {
                        state = state
                            .wrapping_mul(6_364_136_223_846_793_005)
                            .wrapping_add(1_442_695_040_888_963_407);
                        (state >> 60) as u8
                    })
                    .collect::<Vec<_>>()
            };
            let left_masks = canonical(draw_family());
            let right_masks = canonical(draw_family());
            check(Zdd::<FlatMap>::new(100_000), &left_masks, &right_masks);
            check(
                Zdd::<DirectMemo>::with_capacity(100_000, 64),
                &left_masks,
                &right_masks,
            );
        }
    }
}
