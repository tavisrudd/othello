//! Allocation-free repeated Hall tests over caller-supplied CSR graphs.
//!
//! The kernel this module used to own was promoted into the public core as
//! `ergodis::hall`'s sparse backend (C1054), which now runs the same algorithm
//! over either a CSR pool or dense bitmap rows and selects between them from
//! measured density. Nothing is reimplemented here: this is the private
//! crate's stable calling shape over the core kernel, kept so that
//! `hall-certify`, `certiis`, `c80-hall-rematch`, and the `plane12` scouts
//! continue to compile and to produce byte-identical certificates.

pub use ergodis::hall::{HallError, HallOutcome};

/// Reusable storage for exact bipartite matching and Hall-deficit extraction.
///
/// `solve` performs no allocation after construction. The deficient set is the
/// alternating-reachable left set from all unmatched vertices after a maximum
/// matching; its neighborhood is the corresponding reachable right set. That
/// set is independent of which maximum matching was found, so it is the same
/// under either core layout.
pub struct HallWorkspace {
    inner: ergodis::hall::HallWorkspace,
}

impl HallWorkspace {
    #[must_use]
    pub fn new(max_left: usize, max_right: usize) -> Self {
        let max_left = u32::try_from(max_left).expect("left capacity exceeds compact storage");
        let max_right = u32::try_from(max_right).expect("right capacity exceeds compact storage");
        assert!(max_left < u32::MAX && max_right < u32::MAX);
        Self {
            inner: ergodis::hall::HallWorkspace::new(max_left, max_right)
                .expect("Hall workspace allocation"),
        }
    }

    pub fn solve(
        &mut self,
        left_count: usize,
        right_count: usize,
        offsets: &[u32],
        neighbors: &[u32],
    ) -> Result<HallOutcome, HallError> {
        if left_count > self.inner.max_left() as usize {
            return Err(HallError::LeftCapacity);
        }
        if right_count > self.inner.max_right() as usize {
            return Err(HallError::RightCapacity);
        }
        let view = ergodis::hall::SparseHallView::new(
            left_count as u32,
            right_count as u32,
            offsets,
            neighbors,
        )?;
        Ok(ergodis::hall::solve_hall_sparse(view, &mut self.inner)?.outcome())
    }

    #[must_use]
    pub fn matching(&self, left_count: usize) -> &[u32] {
        &self.inner.matching()[..left_count]
    }

    #[must_use]
    pub fn deficient_left(&self) -> &[u32] {
        self.inner.deficient_left_indices()
    }

    #[must_use]
    pub fn deficient_right(&self) -> &[u32] {
        self.inner.deficient_right_indices()
    }
}

#[cfg(test)]
mod tests {
    use super::{HallError, HallOutcome, HallWorkspace};

    const NONE: u32 = u32::MAX;

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
    fn repeated_solves_reuse_storage_and_reject_bad_graphs() {
        let mut workspace = HallWorkspace::new(4, 4);
        let pointer = workspace.inner.matching().as_ptr();
        for _ in 0..100 {
            assert_eq!(
                workspace.solve(2, 2, &[0, 1, 2], &[0, 1]).unwrap(),
                HallOutcome::Saturated
            );
        }
        assert_eq!(workspace.inner.matching().as_ptr(), pointer);
        assert_eq!(
            workspace.solve(1, 1, &[0, 1], &[1]),
            Err(HallError::InvalidEndpoint)
        );
        assert_eq!(
            workspace.solve(8, 1, &[0, 1], &[0]),
            Err(HallError::LeftCapacity)
        );
        assert_eq!(
            workspace.solve(1, 8, &[0, 1], &[0]),
            Err(HallError::RightCapacity)
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
