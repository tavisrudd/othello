//! Exact orbit compilation for finite permutation actions.

use crate::observational::{FinitePresentation, GeneratorSpec, ObservationalError};
use thiserror::Error;

/// A finite set acted on by explicitly supplied permutation generators.
pub trait FinitePermutationAction {
    type Error;

    fn point_count(&self) -> u32;
    fn generator_count(&self) -> u32;
    fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error>;
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum OrbitCompileError<E> {
    #[error("permutation-action adapter failed: {0}")]
    Adapter(E),
    #[error("generator {generator} maps point {point} out of range to {target}")]
    Target {
        generator: u32,
        point: u32,
        target: u32,
    },
    #[error("generator {generator} is not a permutation: target {target} is repeated")]
    NotPermutation { generator: u32, target: u32 },
    #[error("orbit certificate has an invalid shape or index")]
    CertificateShape,
    #[error("orbit certificate edge for point {point} does not replay")]
    CertificateEdge { point: u32 },
    #[error("generator {generator} does not preserve the certified orbit of point {point}")]
    NotClosed { generator: u32, point: u32 },
    #[error("orbit {orbit} does not use its least point as representative")]
    NotCanonical { orbit: u32 },
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum OrbitQuotientError {
    #[error("orbit partition and finite presentation have different point counts")]
    PointCount,
    #[error("orbit {orbit} crosses a presentation sort boundary")]
    Sort { orbit: u32 },
    #[error("observation is not constant on orbit {orbit}")]
    Observation { orbit: u32 },
    #[error("context {context} is not well-defined on orbit {orbit}")]
    Context { context: u32, orbit: u32 },
    #[error("orbit partition contains an invalid orbit index")]
    OrbitIndex,
    #[error(transparent)]
    Presentation(#[from] ObservationalError),
}

/// Compact replayable orbit partition.
#[derive(Clone, Debug)]
pub struct OrbitPartition {
    point_orbits: Box<[u32]>,
    representatives: Box<[u32]>,
    predecessor_points: Box<[u32]>,
    predecessor_generators: Box<[u32]>,
    discovery_ranks: Box<[u32]>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct OrbitStorage {
    pub quotient_bytes: usize,
    pub certificate_bytes: usize,
}

impl OrbitPartition {
    pub fn point_orbits(&self) -> &[u32] {
        &self.point_orbits
    }

    pub fn representatives(&self) -> &[u32] {
        &self.representatives
    }

    pub fn orbit(&self, point: u32) -> Option<u32> {
        self.point_orbits.get(point as usize).copied()
    }

    pub fn representative(&self, point: u32) -> Option<u32> {
        self.orbit(point)
            .and_then(|orbit| self.representatives.get(orbit as usize).copied())
    }

    pub fn storage(&self) -> OrbitStorage {
        OrbitStorage {
            quotient_bytes: std::mem::size_of_val(&*self.point_orbits)
                + std::mem::size_of_val(&*self.representatives),
            certificate_bytes: std::mem::size_of_val(&*self.predecessor_points)
                + std::mem::size_of_val(&*self.predecessor_generators)
                + std::mem::size_of_val(&*self.discovery_ranks),
        }
    }
}

/// Quotient a finite interface by a sort-preserving, observation-invariant,
/// context-equivariant orbit partition.
///
/// All obligations are checked on concrete states. The returned presentation
/// retains every original context but stores one transition per source orbit.
pub fn quotient_presentation_by_orbits(
    presentation: &FinitePresentation,
    partition: &OrbitPartition,
) -> Result<FinitePresentation, OrbitQuotientError> {
    let point_count = presentation.observations().len();
    if partition.point_orbits.len() != point_count {
        return Err(OrbitQuotientError::PointCount);
    }
    let orbit_count = partition.representatives.len();
    let mut orbit_sorts = vec![u32::MAX; orbit_count];
    let mut sort_orbits = vec![Vec::new(); presentation.sorts().len()];
    for (sort, range) in presentation.sorts().iter().copied().enumerate() {
        for state in range.start..range.start + range.len {
            let orbit = partition.point_orbits[state as usize];
            let Some(orbit_sort) = orbit_sorts.get_mut(orbit as usize) else {
                return Err(OrbitQuotientError::OrbitIndex);
            };
            if *orbit_sort == u32::MAX {
                *orbit_sort = sort as u32;
                sort_orbits[sort].push(orbit);
            } else if *orbit_sort != sort as u32 {
                return Err(OrbitQuotientError::Sort { orbit });
            }
            let representative = *partition
                .representatives
                .get(orbit as usize)
                .ok_or(OrbitQuotientError::OrbitIndex)?;
            if representative as usize >= point_count {
                return Err(OrbitQuotientError::OrbitIndex);
            }
            if presentation.observations()[state as usize]
                != presentation.observations()[representative as usize]
            {
                return Err(OrbitQuotientError::Observation { orbit });
            }
        }
    }
    if orbit_sorts.contains(&u32::MAX) {
        return Err(OrbitQuotientError::OrbitIndex);
    }

    let mut orbit_states = vec![u32::MAX; orbit_count];
    let mut observations = Vec::with_capacity(orbit_count);
    let mut next_state = 0_u32;
    for orbits in &sort_orbits {
        for &orbit in orbits {
            orbit_states[orbit as usize] = next_state;
            next_state += 1;
            let representative = partition.representatives[orbit as usize];
            observations.push(presentation.observations()[representative as usize]);
        }
    }

    let mut generators = Vec::with_capacity(presentation.generators().len());
    let mut targets_by_orbit = vec![u32::MAX; orbit_count];
    for (context, generator) in presentation.generators().iter().enumerate() {
        targets_by_orbit.fill(u32::MAX);
        let source = presentation.sorts()[generator.source_sort as usize];
        for state in source.start..source.start + source.len {
            let source_orbit = partition.point_orbits[state as usize];
            let target_state = presentation.transition(context as u32, state).ok_or(
                OrbitQuotientError::Context {
                    context: context as u32,
                    orbit: source_orbit,
                },
            )?;
            let target_orbit = partition.point_orbits[target_state as usize];
            let expected = &mut targets_by_orbit[source_orbit as usize];
            if *expected == u32::MAX {
                *expected = target_orbit;
            } else if *expected != target_orbit {
                return Err(OrbitQuotientError::Context {
                    context: context as u32,
                    orbit: source_orbit,
                });
            }
        }
        let source_orbits = &sort_orbits[generator.source_sort as usize];
        let mut transitions = Vec::with_capacity(source_orbits.len());
        for &orbit in source_orbits {
            let target_orbit = targets_by_orbit[orbit as usize];
            let target_state = orbit_states
                .get(target_orbit as usize)
                .copied()
                .filter(|&state| state != u32::MAX)
                .ok_or(OrbitQuotientError::OrbitIndex)?;
            transitions.push(target_state);
        }
        generators.push(GeneratorSpec {
            source_sort: generator.source_sort,
            target_sort: generator.target_sort,
            transitions: transitions.into_boxed_slice(),
        });
    }

    FinitePresentation::new(
        sort_orbits.iter().map(|orbits| orbits.len() as u32),
        observations,
        generators,
    )
    .map_err(Into::into)
}

/// Compile canonical orbits and a spanning-word certificate.
///
/// The algorithm is iterative and allocates five point-sized arrays plus one
/// point-sized queue, independent of the number of group elements.
pub fn compile_permutation_orbits<A: FinitePermutationAction>(
    action: &A,
) -> Result<OrbitPartition, OrbitCompileError<A::Error>> {
    compile_permutation_orbits_internal(action, true)
}

/// Compile after validating generators, but defer certificate replay.
///
/// Use this when the artifact will cross a later trust or persistence boundary
/// where [`verify_permutation_orbits`] is already mandatory.
pub fn compile_permutation_orbits_with_deferred_verification<A: FinitePermutationAction>(
    action: &A,
) -> Result<OrbitPartition, OrbitCompileError<A::Error>> {
    compile_permutation_orbits_internal(action, false)
}

fn compile_permutation_orbits_internal<A: FinitePermutationAction>(
    action: &A,
    verify_immediately: bool,
) -> Result<OrbitPartition, OrbitCompileError<A::Error>> {
    validate_generators(action)?;
    let point_count = action.point_count();
    let point_capacity = point_count as usize;
    let unseen = u32::MAX;
    let mut point_orbits = vec![unseen; point_capacity];
    let mut predecessor_points = vec![unseen; point_capacity];
    let mut predecessor_generators = vec![unseen; point_capacity];
    let mut discovery_ranks = vec![unseen; point_capacity];
    let mut representatives = Vec::with_capacity(point_capacity);
    let mut queue = Vec::with_capacity(point_capacity);

    for representative in 0..point_count {
        if point_orbits[representative as usize] != unseen {
            continue;
        }
        let orbit = representatives.len() as u32;
        representatives.push(representative);
        queue.clear();
        queue.push(representative);
        point_orbits[representative as usize] = orbit;
        predecessor_points[representative as usize] = representative;
        discovery_ranks[representative as usize] = 0;

        let mut head = 0;
        while head < queue.len() {
            let point = queue[head];
            head += 1;
            for generator in 0..action.generator_count() {
                let target = action
                    .apply(generator, point)
                    .map_err(OrbitCompileError::Adapter)?;
                if target >= point_count {
                    return Err(OrbitCompileError::Target {
                        generator,
                        point,
                        target,
                    });
                }
                if point_orbits[target as usize] != unseen {
                    continue;
                }
                point_orbits[target as usize] = orbit;
                predecessor_points[target as usize] = point;
                predecessor_generators[target as usize] = generator;
                discovery_ranks[target as usize] = queue.len() as u32;
                queue.push(target);
            }
        }
    }

    let partition = OrbitPartition {
        point_orbits: point_orbits.into_boxed_slice(),
        representatives: representatives.into_boxed_slice(),
        predecessor_points: predecessor_points.into_boxed_slice(),
        predecessor_generators: predecessor_generators.into_boxed_slice(),
        discovery_ranks: discovery_ranks.into_boxed_slice(),
    };
    if verify_immediately {
        verify_permutation_orbits(action, &partition)?;
    }
    Ok(partition)
}

/// Independently replay an orbit partition and its reachability certificate.
pub fn verify_permutation_orbits<A: FinitePermutationAction>(
    action: &A,
    partition: &OrbitPartition,
) -> Result<(), OrbitCompileError<A::Error>> {
    validate_generators(action)?;
    let point_count = action.point_count() as usize;
    if partition.point_orbits.len() != point_count
        || partition.predecessor_points.len() != point_count
        || partition.predecessor_generators.len() != point_count
        || partition.discovery_ranks.len() != point_count
    {
        return Err(OrbitCompileError::CertificateShape);
    }
    let mut minima = vec![u32::MAX; partition.representatives.len()];
    for point in 0..action.point_count() {
        let orbit = partition.point_orbits[point as usize];
        let Some(minimum) = minima.get_mut(orbit as usize) else {
            return Err(OrbitCompileError::CertificateShape);
        };
        *minimum = (*minimum).min(point);
        let representative = partition.representatives[orbit as usize];
        let predecessor = partition.predecessor_points[point as usize];
        let rank = partition.discovery_ranks[point as usize];
        if point == representative {
            if predecessor != point || rank != 0 {
                return Err(OrbitCompileError::CertificateEdge { point });
            }
        } else {
            let generator = partition.predecessor_generators[point as usize];
            if predecessor >= action.point_count()
                || generator >= action.generator_count()
                || partition.point_orbits[predecessor as usize] != orbit
                || partition.discovery_ranks[predecessor as usize] >= rank
                || action
                    .apply(generator, predecessor)
                    .map_err(OrbitCompileError::Adapter)?
                    != point
            {
                return Err(OrbitCompileError::CertificateEdge { point });
            }
        }
        for generator in 0..action.generator_count() {
            let target = action
                .apply(generator, point)
                .map_err(OrbitCompileError::Adapter)?;
            if target >= action.point_count() {
                return Err(OrbitCompileError::Target {
                    generator,
                    point,
                    target,
                });
            }
            if partition.point_orbits[target as usize] != orbit {
                return Err(OrbitCompileError::NotClosed { generator, point });
            }
        }
    }
    for (orbit, (&representative, &minimum)) in partition
        .representatives
        .iter()
        .zip(minima.iter())
        .enumerate()
    {
        if representative != minimum {
            return Err(OrbitCompileError::NotCanonical {
                orbit: orbit as u32,
            });
        }
    }
    Ok(())
}

fn validate_generators<A: FinitePermutationAction>(
    action: &A,
) -> Result<(), OrbitCompileError<A::Error>> {
    let point_count = action.point_count();
    let words = (point_count as usize).div_ceil(64);
    let mut seen = vec![0_u64; words];
    for generator in 0..action.generator_count() {
        seen.fill(0);
        for point in 0..point_count {
            let target = action
                .apply(generator, point)
                .map_err(OrbitCompileError::Adapter)?;
            if target >= point_count {
                return Err(OrbitCompileError::Target {
                    generator,
                    point,
                    target,
                });
            }
            let word = &mut seen[target as usize / 64];
            let bit = 1_u64 << (target % 64);
            if *word & bit != 0 {
                return Err(OrbitCompileError::NotPermutation { generator, target });
            }
            *word |= bit;
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::observational::GeneratorSpec;
    use std::convert::Infallible;

    struct TableAction<const N: usize, const G: usize>([[u32; N]; G]);

    impl<const N: usize, const G: usize> FinitePermutationAction for TableAction<N, G> {
        type Error = Infallible;

        fn point_count(&self) -> u32 {
            N as u32
        }

        fn generator_count(&self) -> u32 {
            G as u32
        }

        fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error> {
            Ok(self.0[generator as usize][point as usize])
        }
    }

    #[test]
    fn generators_compile_canonical_orbits_and_replay_certificate() {
        let action = TableAction([[1, 2, 3, 0, 5, 4], [0, 3, 2, 1, 4, 5]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        assert_eq!(partition.representatives(), &[0, 4]);
        assert_eq!(partition.point_orbits(), &[0, 0, 0, 0, 1, 1]);
        assert_eq!(partition.representative(3), Some(0));
        assert_eq!(partition.representative(5), Some(4));
        assert_eq!(
            partition.storage(),
            OrbitStorage {
                quotient_bytes: 32,
                certificate_bytes: 72
            }
        );
        verify_permutation_orbits(&action, &partition).unwrap();

        let deferred = compile_permutation_orbits_with_deferred_verification(&action).unwrap();
        assert_eq!(deferred.point_orbits(), partition.point_orbits());
        assert_eq!(deferred.representatives(), partition.representatives());
        verify_permutation_orbits(&action, &deferred).unwrap();
    }

    #[test]
    fn non_permutations_are_rejected_before_orbit_search() {
        let action = TableAction([[0, 0, 2]]);
        assert_eq!(
            compile_permutation_orbits(&action).unwrap_err(),
            OrbitCompileError::NotPermutation {
                generator: 0,
                target: 0
            }
        );
    }

    #[test]
    fn verifier_rejects_corrupted_reachability_and_closure() {
        let action = TableAction([[1, 2, 3, 0]]);
        let mut edge = compile_permutation_orbits(&action).unwrap();
        edge.predecessor_points[2] = 2;
        assert_eq!(
            verify_permutation_orbits(&action, &edge),
            Err(OrbitCompileError::CertificateEdge { point: 2 })
        );

        let mut closure = compile_permutation_orbits(&action).unwrap();
        closure.point_orbits[3] = 1;
        closure.representatives = vec![0, 3].into_boxed_slice();
        assert!(matches!(
            verify_permutation_orbits(&action, &closure),
            Err(OrbitCompileError::NotClosed { .. })
                | Err(OrbitCompileError::CertificateEdge { .. })
        ));
    }

    #[test]
    fn invariant_presentation_quotients_to_one_state_per_orbit() {
        let action = TableAction([[1, 2, 3, 0, 5, 4], [0, 3, 2, 1, 4, 5]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        let generators = action.0.map(|transitions| GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: transitions.into(),
        });
        let presentation = FinitePresentation::new([6], [7, 7, 7, 7, 9, 9], generators).unwrap();
        let quotient = quotient_presentation_by_orbits(&presentation, &partition).unwrap();

        assert_eq!(quotient.sorts()[0].len, 2);
        assert_eq!(quotient.observations(), &[7, 9]);
        for context in 0..2 {
            assert_eq!(quotient.transition(context, 0), Some(0));
            assert_eq!(quotient.transition(context, 1), Some(1));
        }
    }

    #[test]
    fn quotient_rejects_noninvariant_observations() {
        let action = TableAction([[1, 0]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        let presentation = FinitePresentation::new([2], [0, 1], []).unwrap();
        assert!(matches!(
            quotient_presentation_by_orbits(&presentation, &partition),
            Err(OrbitQuotientError::Observation { orbit: 0 })
        ));
    }

    #[test]
    fn quotient_rejects_contexts_that_do_not_descend_to_orbits() {
        let action = TableAction([[1, 0, 2]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        let presentation = FinitePresentation::new(
            [3],
            [0, 0, 0],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: [0, 2, 2].into(),
            }],
        )
        .unwrap();
        assert!(matches!(
            quotient_presentation_by_orbits(&presentation, &partition),
            Err(OrbitQuotientError::Context {
                context: 0,
                orbit: 0
            })
        ));
    }

    #[test]
    fn quotient_rejects_orbits_crossing_typed_sorts() {
        let action = TableAction([[1, 0]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        let presentation = FinitePresentation::new([1, 1], [0, 0], []).unwrap();
        assert!(matches!(
            quotient_presentation_by_orbits(&presentation, &partition),
            Err(OrbitQuotientError::Sort { orbit: 0 })
        ));
    }

    fn next_permutation(values: &mut [u32]) -> bool {
        let Some(pivot) = (0..values.len().saturating_sub(1))
            .rev()
            .find(|&index| values[index] < values[index + 1])
        else {
            return false;
        };
        let successor = (pivot + 1..values.len())
            .rev()
            .find(|&index| values[pivot] < values[index])
            .unwrap();
        values.swap(pivot, successor);
        values[pivot + 1..].reverse();
        true
    }

    #[test]
    fn all_pairs_of_four_point_permutations_match_transitive_closure() {
        let mut permutations = Vec::with_capacity(24);
        let mut permutation = [0, 1, 2, 3];
        loop {
            permutations.push(permutation);
            if !next_permutation(&mut permutation) {
                break;
            }
        }
        assert_eq!(permutations.len(), 24);

        for &first in &permutations {
            for &second in &permutations {
                let action = TableAction([first, second]);
                let partition = compile_permutation_orbits(&action).unwrap();
                let mut reachable = [[false; 4]; 4];
                for point in 0..4 {
                    reachable[point][point] = true;
                    reachable[point][first[point] as usize] = true;
                    reachable[point][second[point] as usize] = true;
                }
                for middle in 0..4 {
                    for left in 0..4 {
                        for right in 0..4 {
                            reachable[left][right] |=
                                reachable[left][middle] && reachable[middle][right];
                        }
                    }
                }
                for (point, row) in reachable.iter().enumerate() {
                    let expected = (0..4).find(|&candidate| row[candidate]).unwrap() as u32;
                    assert_eq!(partition.representative(point as u32), Some(expected));
                }
            }
        }
    }
}
