//! Allocation-free repeated Hall tests over caller-supplied CSR graphs.

const NONE: u32 = u32::MAX;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum HallOutcome {
    Saturated,
    Deficient {
        left_size: usize,
        neighborhood_size: usize,
    },
}

#[derive(Debug, thiserror::Error, Eq, PartialEq)]
pub enum HallError {
    #[error("left vertex count exceeds workspace capacity")]
    LeftCapacity,
    #[error("right vertex count exceeds workspace capacity")]
    RightCapacity,
    #[error("CSR offsets do not describe the left vertex set")]
    InvalidOffsets,
    #[error("CSR graph contains a right endpoint outside the declared range")]
    InvalidEndpoint,
}

/// Reusable storage for exact bipartite matching and Hall-deficit extraction.
///
/// `solve` performs no allocation after construction. The deficient set is the
/// alternating-reachable left set from all unmatched vertices after a maximum
/// matching; its neighborhood is the corresponding reachable right set.
pub struct HallWorkspace {
    pair_left: Vec<u32>,
    pair_right: Vec<u32>,
    parent_right: Vec<u32>,
    seen_left: Vec<u32>,
    seen_right: Vec<u32>,
    queue: Vec<u32>,
    epoch: u32,
    deficient_left: Vec<u32>,
    deficient_right: Vec<u32>,
}

impl HallWorkspace {
    #[must_use]
    pub fn new(max_left: usize, max_right: usize) -> Self {
        assert!(max_left < NONE as usize && max_right < NONE as usize);
        Self {
            pair_left: vec![NONE; max_left],
            pair_right: vec![NONE; max_right],
            parent_right: vec![NONE; max_right],
            seen_left: vec![0; max_left],
            seen_right: vec![0; max_right],
            queue: vec![0; max_left],
            epoch: 0,
            deficient_left: Vec::with_capacity(max_left),
            deficient_right: Vec::with_capacity(max_right),
        }
    }

    pub fn solve(
        &mut self,
        left_count: usize,
        right_count: usize,
        offsets: &[u32],
        neighbors: &[u32],
    ) -> Result<HallOutcome, HallError> {
        self.validate(left_count, right_count, offsets, neighbors)?;
        self.pair_left[..left_count].fill(NONE);
        self.pair_right[..right_count].fill(NONE);
        self.deficient_left.clear();
        self.deficient_right.clear();

        let mut matched = 0;
        for root in 0..left_count {
            if self.augment(root, right_count, offsets, neighbors) {
                matched += 1;
            }
        }
        if matched == left_count {
            return Ok(HallOutcome::Saturated);
        }

        self.extract_deficiency(left_count, right_count, offsets, neighbors);
        debug_assert!(self.deficient_right.len() < self.deficient_left.len());
        Ok(HallOutcome::Deficient {
            left_size: self.deficient_left.len(),
            neighborhood_size: self.deficient_right.len(),
        })
    }

    #[must_use]
    pub fn matching(&self, left_count: usize) -> &[u32] {
        &self.pair_left[..left_count]
    }

    #[must_use]
    pub fn deficient_left(&self) -> &[u32] {
        &self.deficient_left
    }

    #[must_use]
    pub fn deficient_right(&self) -> &[u32] {
        &self.deficient_right
    }

    fn validate(
        &self,
        left_count: usize,
        right_count: usize,
        offsets: &[u32],
        neighbors: &[u32],
    ) -> Result<(), HallError> {
        if left_count > self.pair_left.len() {
            return Err(HallError::LeftCapacity);
        }
        if right_count > self.pair_right.len() {
            return Err(HallError::RightCapacity);
        }
        if offsets.len() != left_count + 1
            || offsets.first().copied() != Some(0)
            || offsets.last().copied() != Some(neighbors.len() as u32)
            || offsets.windows(2).any(|pair| pair[0] > pair[1])
        {
            return Err(HallError::InvalidOffsets);
        }
        if neighbors.iter().any(|&right| right as usize >= right_count) {
            return Err(HallError::InvalidEndpoint);
        }
        Ok(())
    }

    fn next_epoch(&mut self) -> u32 {
        self.epoch = self.epoch.wrapping_add(1);
        if self.epoch == 0 {
            self.seen_left.fill(0);
            self.seen_right.fill(0);
            self.epoch = 1;
        }
        self.epoch
    }

    fn augment(
        &mut self,
        root: usize,
        _right_count: usize,
        offsets: &[u32],
        neighbors: &[u32],
    ) -> bool {
        let epoch = self.next_epoch();
        let mut head = 0;
        let mut tail = 1;
        self.queue[0] = root as u32;
        self.seen_left[root] = epoch;

        while head < tail {
            let left = self.queue[head] as usize;
            head += 1;
            let begin = offsets[left] as usize;
            let end = offsets[left + 1] as usize;
            for &right_u32 in &neighbors[begin..end] {
                let right = right_u32 as usize;
                if self.pair_left[left] == right_u32 || self.seen_right[right] == epoch {
                    continue;
                }
                self.seen_right[right] = epoch;
                self.parent_right[right] = left as u32;
                let paired_left = self.pair_right[right];
                if paired_left == NONE {
                    self.flip_path(right_u32);
                    return true;
                }
                let paired_left = paired_left as usize;
                if self.seen_left[paired_left] != epoch {
                    self.seen_left[paired_left] = epoch;
                    self.queue[tail] = paired_left as u32;
                    tail += 1;
                }
            }
        }
        false
    }

    fn flip_path(&mut self, mut right: u32) {
        loop {
            let left = self.parent_right[right as usize];
            debug_assert_ne!(left, NONE);
            let previous_right = self.pair_left[left as usize];
            self.pair_left[left as usize] = right;
            self.pair_right[right as usize] = left;
            if previous_right == NONE {
                break;
            }
            right = previous_right;
        }
    }

    fn extract_deficiency(
        &mut self,
        left_count: usize,
        right_count: usize,
        offsets: &[u32],
        neighbors: &[u32],
    ) {
        let epoch = self.next_epoch();
        let mut head = 0;
        let mut tail = 0;
        for left in 0..left_count {
            if self.pair_left[left] == NONE {
                self.seen_left[left] = epoch;
                self.queue[tail] = left as u32;
                tail += 1;
            }
        }
        while head < tail {
            let left = self.queue[head] as usize;
            head += 1;
            for &right_u32 in &neighbors[offsets[left] as usize..offsets[left + 1] as usize] {
                let right = right_u32 as usize;
                if self.pair_left[left] == right_u32 || self.seen_right[right] == epoch {
                    continue;
                }
                self.seen_right[right] = epoch;
                let paired_left = self.pair_right[right];
                if paired_left != NONE && self.seen_left[paired_left as usize] != epoch {
                    self.seen_left[paired_left as usize] = epoch;
                    self.queue[tail] = paired_left;
                    tail += 1;
                }
            }
        }
        for left in 0..left_count {
            if self.seen_left[left] == epoch {
                self.deficient_left.push(left as u32);
            }
        }
        for right in 0..right_count {
            if self.seen_right[right] == epoch {
                self.deficient_right.push(right as u32);
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{HallError, HallOutcome, HallWorkspace, NONE};

    #[test]
    fn returns_saturating_matching() {
        let mut workspace = HallWorkspace::new(3, 3);
        let outcome = workspace.solve(3, 3, &[0, 2, 3, 4], &[0, 1, 1, 2]).unwrap();
        assert_eq!(outcome, HallOutcome::Saturated);
        let matching = workspace.matching(3);
        assert!(matching.iter().all(|&right| right != NONE));
        assert_eq!(
            matching
                .iter()
                .copied()
                .collect::<std::collections::HashSet<_>>()
                .len(),
            3
        );
    }

    #[test]
    fn returns_exact_hall_deficiency() {
        let mut workspace = HallWorkspace::new(4, 3);
        let outcome = workspace
            .solve(4, 3, &[0, 1, 2, 4, 5], &[0, 0, 0, 1, 2])
            .unwrap();
        assert_eq!(
            outcome,
            HallOutcome::Deficient {
                left_size: 2,
                neighborhood_size: 1,
            }
        );
        assert_eq!(workspace.deficient_left(), &[0, 1]);
        assert_eq!(workspace.deficient_right(), &[0]);
    }

    #[test]
    fn repeated_solves_keep_allocations_and_reject_bad_graphs() {
        let mut workspace = HallWorkspace::new(4, 4);
        let capacities = (
            workspace.queue.capacity(),
            workspace.deficient_left.capacity(),
            workspace.deficient_right.capacity(),
        );
        for _ in 0..100 {
            assert_eq!(
                workspace.solve(2, 2, &[0, 1, 2], &[0, 1]).unwrap(),
                HallOutcome::Saturated
            );
        }
        assert_eq!(
            capacities,
            (
                workspace.queue.capacity(),
                workspace.deficient_left.capacity(),
                workspace.deficient_right.capacity(),
            )
        );
        assert_eq!(
            workspace.solve(1, 1, &[0, 1], &[1]),
            Err(HallError::InvalidEndpoint)
        );
    }

    #[test]
    fn exhaustive_four_by_four_matches_brute_force_hall() {
        fn can_saturate(
            left: usize,
            left_count: usize,
            offsets: &[u32],
            neighbors: &[u32],
            used_right: u32,
        ) -> bool {
            if left == left_count {
                return true;
            }
            neighbors[offsets[left] as usize..offsets[left + 1] as usize]
                .iter()
                .any(|&right| {
                    used_right & (1 << right) == 0
                        && can_saturate(
                            left + 1,
                            left_count,
                            offsets,
                            neighbors,
                            used_right | (1 << right),
                        )
                })
        }

        let mut workspace = HallWorkspace::new(4, 4);
        for graph in 0_u32..(1 << 16) {
            let mut offsets = Vec::with_capacity(5);
            let mut neighbors = Vec::with_capacity(16);
            offsets.push(0);
            for left in 0..4 {
                for right in 0..4 {
                    if graph & (1 << (4 * left + right)) != 0 {
                        neighbors.push(right);
                    }
                }
                offsets.push(neighbors.len() as u32);
            }
            let expected = can_saturate(0, 4, &offsets, &neighbors, 0);
            let outcome = workspace.solve(4, 4, &offsets, &neighbors).unwrap();
            assert_eq!(
                outcome == HallOutcome::Saturated,
                expected,
                "graph={graph:#x}"
            );
            if let HallOutcome::Deficient {
                left_size,
                neighborhood_size,
            } = outcome
            {
                let mut exact_neighborhood = 0_u32;
                for &left in workspace.deficient_left() {
                    for &right in &neighbors
                        [offsets[left as usize] as usize..offsets[left as usize + 1] as usize]
                    {
                        exact_neighborhood |= 1 << right;
                    }
                }
                assert_eq!(exact_neighborhood.count_ones() as usize, neighborhood_size);
                assert_eq!(left_size, workspace.deficient_left().len());
                assert!(neighborhood_size < left_size);
            }
        }
    }
}
