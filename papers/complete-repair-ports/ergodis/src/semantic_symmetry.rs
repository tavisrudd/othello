//! Certified coordinate-orbit covers for nonempty-support optimization.
//!
//! This module compiles the backend-neutral part of first-support symmetry
//! breaking.  It certifies coordinate orbits only.  A domain adapter remains
//! responsible for proving that its feasible family and objective are
//! invariant under the supplied action and that feasible supports are nonempty.

use crate::group_action::{
    compile_permutation_orbits, verify_permutation_orbits, FinitePermutationAction,
    OrbitCompileError, OrbitPartition, OrbitStorage,
};

/// One external-solver subproblem, anchored at a canonical coordinate.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct AnchoredSupportSubproblem {
    orbit: u32,
    anchor: u32,
}

const _: () = assert!(std::mem::size_of::<AnchoredSupportSubproblem>() == 8);
const _: () = assert!(std::mem::align_of::<AnchoredSupportSubproblem>() == 4);

impl AnchoredSupportSubproblem {
    pub fn orbit(self) -> u32 {
        self.orbit
    }

    /// Coordinate whose support variable must be fixed to one.
    pub fn anchor(self) -> u32 {
        self.anchor
    }
}

/// A replayable cover of every nonempty support by anchored subproblems.
///
/// If a domain's feasible supports and objective are invariant under the
/// supplied action, optimizing once for each returned anchor is exact.  This
/// type deliberately does not claim or encode that domain-specific premise.
#[derive(Debug)]
pub struct NonemptySupportOrbitCover {
    partition: OrbitPartition,
}

impl NonemptySupportOrbitCover {
    pub fn point_count(&self) -> u32 {
        self.partition.point_orbits().len() as u32
    }

    pub fn subproblem_count(&self) -> u32 {
        self.partition.representatives().len() as u32
    }

    pub fn anchors(&self) -> &[u32] {
        self.partition.representatives()
    }

    /// Return the anchored subproblem covering a support containing `point`.
    pub fn subproblem_for_point(&self, point: u32) -> Option<AnchoredSupportSubproblem> {
        let orbit = self.partition.orbit(point)?;
        let anchor = self.partition.representative(point)?;
        Some(AnchoredSupportSubproblem { orbit, anchor })
    }

    /// Iterate without allocating over the external-solver requests.
    pub fn subproblems(&self) -> impl ExactSizeIterator<Item = AnchoredSupportSubproblem> + '_ {
        self.partition
            .representatives()
            .iter()
            .copied()
            .enumerate()
            .map(|(orbit, anchor)| AnchoredSupportSubproblem {
                orbit: orbit as u32,
                anchor,
            })
    }

    pub fn storage(&self) -> OrbitStorage {
        self.partition.storage()
    }
}

/// Compile and immediately replay a coordinate-orbit cover.
pub fn compile_nonempty_support_orbit_cover<A: FinitePermutationAction>(
    action: &A,
) -> Result<NonemptySupportOrbitCover, OrbitCompileError<A::Error>> {
    let partition = compile_permutation_orbits(action)?;
    Ok(NonemptySupportOrbitCover { partition })
}

/// Independently replay the permutation and orbit-coverage certificate.
pub fn verify_nonempty_support_orbit_cover<A: FinitePermutationAction>(
    action: &A,
    cover: &NonemptySupportOrbitCover,
) -> Result<(), OrbitCompileError<A::Error>> {
    verify_permutation_orbits(action, &cover.partition)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::convert::Infallible;

    /// Product translations on repeated coordinate blocks.
    struct ProductTranslation {
        width: u32,
        height: u32,
        blocks: u32,
    }

    impl FinitePermutationAction for ProductTranslation {
        type Error = Infallible;

        fn point_count(&self) -> u32 {
            self.width * self.height * self.blocks
        }

        fn generator_count(&self) -> u32 {
            2
        }

        fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error> {
            let block_size = self.width * self.height;
            let block = point / block_size;
            let local = point % block_size;
            let x = local % self.width;
            let y = local / self.width;
            let (next_x, next_y) = match generator {
                0 => ((x + 1) % self.width, y),
                1 => (x, (y + 1) % self.height),
                _ => unreachable!(),
            };
            Ok(block * block_size + next_y * self.width + next_x)
        }
    }

    #[test]
    fn gross_translation_shape_compiles_to_two_anchors() {
        let action = ProductTranslation {
            width: 12,
            height: 6,
            blocks: 2,
        };
        let cover = compile_nonempty_support_orbit_cover(&action).unwrap();

        assert_eq!(cover.point_count(), 144);
        assert_eq!(cover.subproblem_count(), 2);
        assert_eq!(cover.anchors(), &[0, 72]);
        assert_eq!(cover.subproblems().len(), 2);
        assert_eq!(cover.subproblem_for_point(71).unwrap().anchor(), 0);
        assert_eq!(cover.subproblem_for_point(143).unwrap().anchor(), 72);
        assert_eq!(cover.subproblem_for_point(144), None);
        verify_nonempty_support_orbit_cover(&action, &cover).unwrap();
    }

    #[test]
    fn anchor_iteration_uses_flat_canonical_records() {
        let action = ProductTranslation {
            width: 3,
            height: 2,
            blocks: 3,
        };
        let cover = compile_nonempty_support_orbit_cover(&action).unwrap();
        let mut expected_orbit = 0;
        let mut expected_anchor = 0;
        for subproblem in cover.subproblems() {
            assert_eq!(subproblem.orbit(), expected_orbit);
            assert_eq!(subproblem.anchor(), expected_anchor);
            expected_orbit += 1;
            expected_anchor += 6;
        }
        assert_eq!(expected_orbit, 3);
    }
}
