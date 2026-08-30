//! Exact quotient towers for progressively richer continuation alphabets.
//!
//! Adding admissible contexts can only refine contextual equivalence.  This
//! module compiles that refinement chain once, checks the induced projections,
//! and supports allocation-free selection of the coarsest level containing a
//! query's remaining generators.

use crate::observational::{
    compile_observational_with_policy, verify_compilation, CertificatePolicy, CompiledObservation,
    FinitePresentation, ObservationalError,
};
use thiserror::Error;

#[derive(Debug, Error, PartialEq, Eq)]
pub enum ContinuationHierarchyError {
    #[error("a continuation hierarchy needs at least one level")]
    NoLevels,
    #[error("continuation level {level} is not present")]
    UnknownLevel { level: u32 },
    #[error(transparent)]
    Presentation(#[from] ObservationalError),
    #[error("continuation level {level} omits generator {generator} from its predecessor")]
    NonNested { level: u32, generator: u32 },
    #[error("continuation level {level} does not refine its predecessor at state {state}")]
    NotARefinement { level: u32, state: u32 },
}

/// One exact contextual quotient in a nested continuation hierarchy.
#[derive(Clone, Debug)]
pub struct ContinuationLevel {
    generator_ids: Box<[u32]>,
    compiled: CompiledObservation,
    /// Map from this level's classes to the preceding level's classes.
    /// Empty at level zero.
    parent_classes: Box<[u32]>,
}

impl ContinuationLevel {
    pub fn generator_ids(&self) -> &[u32] {
        &self.generator_ids
    }

    pub fn compiled(&self) -> &CompiledObservation {
        &self.compiled
    }

    pub fn class_count(&self, sort: u32) -> Option<u32> {
        self.compiled
            .class_ranges()
            .get(sort as usize)
            .map(|range| range.len)
    }

    pub fn class_of_state(&self, state: u32) -> Option<u32> {
        self.compiled.state_classes().get(state as usize).copied()
    }

    pub fn representative_state(&self, class: u32) -> Option<u32> {
        self.compiled
            .class_representatives()
            .get(class as usize)
            .copied()
    }
}

/// Coarse-to-fine exact contextual quotients for nested generator alphabets.
#[derive(Clone, Debug)]
pub struct ContinuationHierarchy<'a> {
    presentation: &'a FinitePresentation,
    levels: Box<[ContinuationLevel]>,
    /// First level admitting each original generator, or `u32::MAX`.
    first_level_by_generator: Box<[u32]>,
}

impl ContinuationHierarchy<'_> {
    pub fn level_count(&self) -> usize {
        self.levels.len()
    }

    pub fn level(&self, level: u32) -> Option<&ContinuationLevel> {
        self.levels.get(level as usize)
    }

    /// Reconstruct one restricted presentation and replay its retained proof.
    /// The temporary transition table is released before this call returns.
    pub fn verify_level(&self, level: u32) -> Result<(), ContinuationHierarchyError> {
        let artifact = self
            .levels
            .get(level as usize)
            .ok_or(ContinuationHierarchyError::UnknownLevel { level })?;
        let restricted = self
            .presentation
            .restrict_generators(&artifact.generator_ids)?;
        verify_compilation(restricted.presentation(), &artifact.compiled)?;
        Ok(())
    }

    /// Return the coarsest compiled level containing every named generator.
    /// This performs no allocation and is linear only in the query alphabet.
    pub fn level_for_generators(&self, generators: &[u32]) -> Option<u32> {
        let mut level = 0_u32;
        for &generator in generators {
            let &first = self.first_level_by_generator.get(generator as usize)?;
            if first == u32::MAX {
                return None;
            }
            level = level.max(first);
        }
        Some(level)
    }

    /// Project a fine class to any coarser level without allocation.
    pub fn project_class(&self, mut level: u32, mut class: u32, target: u32) -> Option<u32> {
        if target > level || level as usize >= self.levels.len() {
            return None;
        }
        while level > target {
            class = *self.levels[level as usize]
                .parent_classes
                .get(class as usize)?;
            level -= 1;
        }
        Some(class)
    }
}

/// Compile exact contextual quotients for a nested sequence of generator sets.
///
/// Level zero may already contain generators. Every later set must contain its
/// predecessor. Each retained artifact is independently replayable through
/// [`crate::observational::verify_compilation`].
pub fn compile_continuation_hierarchy<'a>(
    presentation: &'a FinitePresentation,
    generator_levels: &[&[u32]],
    certificate_policy: CertificatePolicy,
) -> Result<ContinuationHierarchy<'a>, ContinuationHierarchyError> {
    if generator_levels.is_empty() {
        return Err(ContinuationHierarchyError::NoLevels);
    }

    let mut levels = Vec::with_capacity(generator_levels.len());
    let mut first_level_by_generator = vec![u32::MAX; presentation.generators().len()];

    for (level_index, &generator_ids) in generator_levels.iter().enumerate() {
        if level_index != 0 {
            let previous = generator_levels[level_index - 1];
            for &generator in previous {
                if !generator_ids.contains(&generator) {
                    return Err(ContinuationHierarchyError::NonNested {
                        level: level_index as u32,
                        generator,
                    });
                }
            }
        }

        let restricted = presentation.restrict_generators(generator_ids)?;
        let compiled =
            compile_observational_with_policy(restricted.presentation(), certificate_policy)?;
        for &generator in generator_ids {
            let first = &mut first_level_by_generator[generator as usize];
            if *first == u32::MAX {
                *first = level_index as u32;
            }
        }

        let parent_classes = if let Some(previous) = levels.last() {
            refinement_projection(previous, &compiled, level_index as u32)?
        } else {
            Box::default()
        };
        levels.push(ContinuationLevel {
            generator_ids: generator_ids.into(),
            compiled,
            parent_classes,
        });
    }

    Ok(ContinuationHierarchy {
        presentation,
        levels: levels.into_boxed_slice(),
        first_level_by_generator: first_level_by_generator.into_boxed_slice(),
    })
}

fn refinement_projection(
    coarse: &ContinuationLevel,
    fine: &CompiledObservation,
    level: u32,
) -> Result<Box<[u32]>, ContinuationHierarchyError> {
    let coarse_classes = coarse.compiled.state_classes();
    let fine_classes = fine.state_classes();
    if coarse_classes.len() != fine_classes.len() {
        return Err(ContinuationHierarchyError::NotARefinement { level, state: 0 });
    }
    let mut parents = vec![u32::MAX; fine.class_representatives().len()];
    for (state, (&fine_class, &coarse_class)) in fine_classes.iter().zip(coarse_classes).enumerate()
    {
        let parent = &mut parents[fine_class as usize];
        if *parent == u32::MAX {
            *parent = coarse_class;
        } else if *parent != coarse_class {
            return Err(ContinuationHierarchyError::NotARefinement {
                level,
                state: state as u32,
            });
        }
    }
    Ok(parents.into_boxed_slice())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::observational::GeneratorSpec;

    fn information_lattice_fixture(q: u32, stratum_sizes: [u32; 3]) -> FinitePresentation {
        assert_eq!(stratum_sizes.into_iter().sum::<u32>(), q);
        let state_count = 2 * q;
        let mut observations = vec![0; state_count as usize];
        observations.extend(0..state_count);

        let target_start = state_count;
        let sheet = (0..state_count)
            .map(|state| target_start + u32::from(state >= q))
            .collect();
        let mut profile = Vec::with_capacity(state_count as usize);
        for sheet_index in 0..2_u32 {
            for (stratum, &size) in stratum_sizes.iter().enumerate() {
                profile.extend(std::iter::repeat_n(
                    target_start + 3 * sheet_index + stratum as u32,
                    size as usize,
                ));
            }
        }
        let identity = (0..state_count).map(|state| target_start + state).collect();
        FinitePresentation::new(
            [state_count, state_count],
            observations,
            [
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 1,
                    transitions: sheet,
                },
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 1,
                    transitions: profile.into_boxed_slice(),
                },
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 1,
                    transitions: identity,
                },
            ],
        )
        .unwrap()
    }

    fn check_information_lattice(q: u32, sizes: [u32; 3]) {
        let presentation = information_lattice_fixture(q, sizes);
        let hierarchy = compile_continuation_hierarchy(
            &presentation,
            &[&[], &[0], &[0, 1], &[0, 1, 2]],
            CertificatePolicy::AdaptiveTranscript,
        )
        .unwrap();
        assert_eq!(hierarchy.level_count(), 4);
        assert_eq!(
            (0..4)
                .map(|level| hierarchy.level(level).unwrap().class_count(0).unwrap())
                .collect::<Vec<_>>(),
            [1, 2, 6, 2 * q]
        );
        assert_eq!(hierarchy.level_for_generators(&[]), Some(0));
        assert_eq!(hierarchy.level_for_generators(&[0]), Some(1));
        assert_eq!(hierarchy.level_for_generators(&[1, 0]), Some(2));
        assert_eq!(hierarchy.level_for_generators(&[2]), Some(3));
        for level in 0..4_u32 {
            hierarchy.verify_level(level).unwrap();
        }
        for state in 0..2 * q {
            let fine = hierarchy.level(3).unwrap().class_of_state(state).unwrap();
            for target in 0..4_u32 {
                let direct = hierarchy
                    .level(target)
                    .unwrap()
                    .class_of_state(state)
                    .unwrap();
                assert_eq!(hierarchy.project_class(3, fine, target), Some(direct));
            }
        }
    }

    #[test]
    fn b3_and_h3_information_lattices_share_one_exact_hierarchy() {
        check_information_lattice(7, [1, 2, 4]);
        check_information_lattice(11, [1, 4, 6]);
    }

    #[test]
    fn rejects_a_non_nested_alphabet() {
        let presentation = information_lattice_fixture(7, [1, 2, 4]);
        assert_eq!(
            compile_continuation_hierarchy(
                &presentation,
                &[&[0, 1], &[1]],
                CertificatePolicy::QuotientOnly,
            )
            .unwrap_err(),
            ContinuationHierarchyError::NonNested {
                level: 1,
                generator: 0,
            }
        );
    }
}
