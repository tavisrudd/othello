//! Exact observational minimization for finite typed deterministic systems.
//!
//! A presentation supplies finite state sorts, observations, and total typed
//! generators.  Compilation identifies exactly those same-sort states that no
//! well-typed generator path can distinguish.  The result carries an
//! independently replayable certificate: every pair placed in different
//! classes has an explicit path ending in different observations.
//!
//! Generators are unary contexts.  A tree or other multi-input algebra must
//! enumerate each admissible one-hole context (including its coarguments) as a
//! generator; grammar or horizon restrictions belong in the sorts.  The
//! compiler proves exactness only for the supplied finite presentation.

use rustc_hash::{FxHashMap, FxHashSet};
use std::collections::{BTreeMap, VecDeque};
use thiserror::Error;

type Partition = (Box<[u32]>, Box<[SortRange]>);
type SeparatorPool = (Box<[SeparatorRecord]>, Box<[u32]>);

#[derive(Debug, Error, PartialEq, Eq)]
pub enum ObservationalError {
    #[error("the presentation needs at least one sort")]
    NoSorts,
    #[error("a count or offset exceeds the compact representation")]
    Overflow,
    #[error("observations have length {actual}, expected {expected}")]
    ObservationCount { expected: usize, actual: usize },
    #[error("generator {generator} names an unknown sort")]
    GeneratorSort { generator: usize },
    #[error("generator {generator} has {actual} transitions, expected {expected}")]
    TransitionCount {
        generator: usize,
        expected: usize,
        actual: usize,
    },
    #[error("generator {generator} transition {transition} leaves its target sort")]
    TransitionTarget { generator: usize, transition: usize },
    #[error("compiled artifact has an invalid shape")]
    CompiledShape,
    #[error("compiled artifact does not define a sort-respecting partition")]
    Partition,
    #[error("compiled class {class} is not observation-constant")]
    ObservationMismatch { class: u32 },
    #[error("generator {generator} is not compatible with class {class}")]
    GeneratorMismatch { generator: u32, class: u32 },
    #[error("compiled transition table disagrees at generator {generator}, class {class}")]
    QuotientTransition { generator: u32, class: u32 },
    #[error("separator certificate {certificate} is malformed")]
    Separator { certificate: usize },
    #[error("states {left} and {right} are separated without a certificate")]
    MissingSeparator { left: u32, right: u32 },
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct SortRange {
    pub start: u32,
    pub len: u32,
}

const _: () = assert!(std::mem::size_of::<SortRange>() == 8);
const _: () = assert!(std::mem::align_of::<SortRange>() == 4);

impl SortRange {
    fn end(self) -> u32 {
        self.start + self.len
    }

    fn contains(self, state: u32) -> bool {
        self.start <= state && state < self.end()
    }
}

#[derive(Clone, Debug)]
pub struct GeneratorSpec {
    pub source_sort: u32,
    pub target_sort: u32,
    /// Global target-state IDs, one for each source state in source-sort order.
    pub transitions: Box<[u32]>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct GeneratorRecord {
    pub source_sort: u32,
    pub target_sort: u32,
    transition_start: u32,
    transition_len: u32,
}

const _: () = assert!(std::mem::size_of::<GeneratorRecord>() == 16);
const _: () = assert!(std::mem::align_of::<GeneratorRecord>() == 4);

#[derive(Clone, Debug)]
pub struct FinitePresentation {
    sorts: Box<[SortRange]>,
    observations: Box<[u32]>,
    generators: Box<[GeneratorRecord]>,
    transitions: Box<[u32]>,
}

impl FinitePresentation {
    pub fn new(
        sort_lengths: impl IntoIterator<Item = u32>,
        observations: impl Into<Box<[u32]>>,
        generator_specs: impl IntoIterator<Item = GeneratorSpec>,
    ) -> Result<Self, ObservationalError> {
        let lengths: Vec<u32> = sort_lengths.into_iter().collect();
        if lengths.is_empty() {
            return Err(ObservationalError::NoSorts);
        }
        let mut next = 0_u32;
        let mut sorts = Vec::with_capacity(lengths.len());
        for len in lengths {
            sorts.push(SortRange { start: next, len });
            next = next.checked_add(len).ok_or(ObservationalError::Overflow)?;
        }
        let observations = observations.into();
        if observations.len() != next as usize {
            return Err(ObservationalError::ObservationCount {
                expected: next as usize,
                actual: observations.len(),
            });
        }

        let mut generators = Vec::new();
        let mut transitions = Vec::new();
        for (generator, spec) in generator_specs.into_iter().enumerate() {
            let Some(source) = sorts.get(spec.source_sort as usize).copied() else {
                return Err(ObservationalError::GeneratorSort { generator });
            };
            let Some(target) = sorts.get(spec.target_sort as usize).copied() else {
                return Err(ObservationalError::GeneratorSort { generator });
            };
            if spec.transitions.len() != source.len as usize {
                return Err(ObservationalError::TransitionCount {
                    generator,
                    expected: source.len as usize,
                    actual: spec.transitions.len(),
                });
            }
            for (transition, &state) in spec.transitions.iter().enumerate() {
                if !target.contains(state) {
                    return Err(ObservationalError::TransitionTarget {
                        generator,
                        transition,
                    });
                }
            }
            let transition_start =
                u32::try_from(transitions.len()).map_err(|_| ObservationalError::Overflow)?;
            let transition_len = source.len;
            transitions.extend_from_slice(&spec.transitions);
            generators.push(GeneratorRecord {
                source_sort: spec.source_sort,
                target_sort: spec.target_sort,
                transition_start,
                transition_len,
            });
        }
        Ok(Self {
            sorts: sorts.into_boxed_slice(),
            observations,
            generators: generators.into_boxed_slice(),
            transitions: transitions.into_boxed_slice(),
        })
    }

    pub fn sorts(&self) -> &[SortRange] {
        &self.sorts
    }

    pub fn observations(&self) -> &[u32] {
        &self.observations
    }

    pub fn generators(&self) -> &[GeneratorRecord] {
        &self.generators
    }

    pub fn state_count(&self) -> usize {
        self.observations.len()
    }

    pub fn transition(&self, generator: u32, state: u32) -> Option<u32> {
        let record = *self.generators.get(generator as usize)?;
        let source = self.sorts[record.source_sort as usize];
        if !source.contains(state) {
            return None;
        }
        let local = state - source.start;
        self.transitions
            .get((record.transition_start + local) as usize)
            .copied()
    }

    fn generators_from(&self, sort: u32) -> impl Iterator<Item = (u32, GeneratorRecord)> + '_ {
        self.generators
            .iter()
            .copied()
            .enumerate()
            .filter(move |(_, generator)| generator.source_sort == sort)
            .map(|(index, generator)| (index as u32, generator))
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct SeparatorRecord {
    pub left_state: u32,
    pub right_state: u32,
    path_start: u32,
    path_len: u32,
    pub left_output: u32,
    pub right_output: u32,
}

const _: () = assert!(std::mem::size_of::<SeparatorRecord>() == 24);
const _: () = assert!(std::mem::align_of::<SeparatorRecord>() == 4);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct CompilationMetrics {
    pub states: usize,
    pub classes: usize,
    pub generators: usize,
    pub refinement_rounds: usize,
    pub separators: usize,
    pub separator_steps: usize,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct CompilationStorage {
    /// Dense quotient data used for evaluation, excluding the certificate.
    pub quotient_bytes: usize,
    /// Pair records and their shared path pool.
    pub certificate_bytes: usize,
}

#[derive(Clone, Debug)]
pub struct CompiledObservation {
    class_ranges: Box<[SortRange]>,
    state_classes: Box<[u32]>,
    class_outputs: Box<[u32]>,
    class_representatives: Box<[u32]>,
    generator_records: Box<[GeneratorRecord]>,
    generator_transitions: Box<[u32]>,
    separators: Box<[SeparatorRecord]>,
    separator_paths: Box<[u32]>,
    metrics: CompilationMetrics,
}

impl CompiledObservation {
    pub fn class_ranges(&self) -> &[SortRange] {
        &self.class_ranges
    }

    pub fn state_classes(&self) -> &[u32] {
        &self.state_classes
    }

    pub fn class_outputs(&self) -> &[u32] {
        &self.class_outputs
    }

    pub fn class_representatives(&self) -> &[u32] {
        &self.class_representatives
    }

    pub fn metrics(&self) -> CompilationMetrics {
        self.metrics
    }

    pub fn storage(&self) -> CompilationStorage {
        CompilationStorage {
            quotient_bytes: std::mem::size_of_val(&*self.class_ranges)
                + std::mem::size_of_val(&*self.state_classes)
                + std::mem::size_of_val(&*self.class_outputs)
                + std::mem::size_of_val(&*self.class_representatives)
                + std::mem::size_of_val(&*self.generator_records)
                + std::mem::size_of_val(&*self.generator_transitions),
            certificate_bytes: std::mem::size_of_val(&*self.separators)
                + std::mem::size_of_val(&*self.separator_paths),
        }
    }

    pub fn transition(&self, generator: u32, class: u32) -> Option<u32> {
        let record = *self.generator_records.get(generator as usize)?;
        let source = self.class_ranges[record.source_sort as usize];
        if !source.contains(class) {
            return None;
        }
        let local = class - source.start;
        self.generator_transitions
            .get((record.transition_start + local) as usize)
            .copied()
    }

    pub fn separators(&self) -> impl Iterator<Item = (SeparatorRecord, &[u32])> {
        self.separators.iter().copied().map(|record| {
            let start = record.path_start as usize;
            let end = start + record.path_len as usize;
            (record, &self.separator_paths[start..end])
        })
    }
}

pub fn compile_observational(
    presentation: &FinitePresentation,
) -> Result<CompiledObservation, ObservationalError> {
    let (mut classes, _) = initial_partition(presentation)?;
    let mut refinement_rounds = 0;
    let class_ranges = loop {
        let (next_classes, next_ranges) = refine_partition(presentation, &classes)?;
        if next_classes == classes {
            break next_ranges;
        }
        classes = next_classes;
        refinement_rounds += 1;
    };

    let class_count = class_ranges.last().map_or(0, |range| range.end() as usize);
    let mut class_outputs = vec![u32::MAX; class_count];
    let mut representatives = vec![u32::MAX; class_count];
    for (state, &class) in classes.iter().enumerate() {
        let slot = &mut representatives[class as usize];
        if *slot == u32::MAX {
            *slot = state as u32;
            class_outputs[class as usize] = presentation.observations[state];
        }
    }

    let mut generator_records = Vec::with_capacity(presentation.generators.len());
    let mut generator_transitions = Vec::new();
    for generator in presentation.generators.iter().copied() {
        let source_classes = class_ranges[generator.source_sort as usize];
        let transition_start =
            u32::try_from(generator_transitions.len()).map_err(|_| ObservationalError::Overflow)?;
        for class in source_classes.start..source_classes.end() {
            let representative = representatives[class as usize];
            let target = presentation
                .transition(generator_records.len() as u32, representative)
                .ok_or(ObservationalError::CompiledShape)?;
            generator_transitions.push(classes[target as usize]);
        }
        generator_records.push(GeneratorRecord {
            source_sort: generator.source_sort,
            target_sort: generator.target_sort,
            transition_start,
            transition_len: source_classes.len,
        });
    }

    let (separators, separator_paths) = build_separators(presentation, &classes)?;
    let metrics = CompilationMetrics {
        states: presentation.state_count(),
        classes: class_count,
        generators: presentation.generators.len(),
        refinement_rounds,
        separators: separators.len(),
        separator_steps: separator_paths.len(),
    };
    let compiled = CompiledObservation {
        class_ranges,
        state_classes: classes,
        class_outputs: class_outputs.into_boxed_slice(),
        class_representatives: representatives.into_boxed_slice(),
        generator_records: generator_records.into_boxed_slice(),
        generator_transitions: generator_transitions.into_boxed_slice(),
        separators,
        separator_paths,
        metrics,
    };
    verify_compilation(presentation, &compiled)?;
    Ok(compiled)
}

fn initial_partition(presentation: &FinitePresentation) -> Result<Partition, ObservationalError> {
    assign_signatures(presentation, |_| Vec::new())
}

fn refine_partition(
    presentation: &FinitePresentation,
    classes: &[u32],
) -> Result<Partition, ObservationalError> {
    assign_signatures(presentation, |state| {
        let sort = state_sort(&presentation.sorts, state).expect("validated state");
        std::iter::once(classes[state as usize])
            .chain(presentation.generators_from(sort).map(|(generator, _)| {
                let target = presentation
                    .transition(generator, state)
                    .expect("typed total generator");
                classes[target as usize]
            }))
            .collect()
    })
}

fn assign_signatures(
    presentation: &FinitePresentation,
    continuation: impl Fn(u32) -> Vec<u32>,
) -> Result<Partition, ObservationalError> {
    let mut classes = vec![u32::MAX; presentation.state_count()];
    let mut ranges = Vec::with_capacity(presentation.sorts.len());
    let mut next_class = 0_u32;
    for range in presentation.sorts.iter().copied() {
        let class_start = next_class;
        let mut signatures: BTreeMap<Vec<u32>, u32> = BTreeMap::new();
        for state in range.start..range.end() {
            let mut signature = Vec::with_capacity(1 + presentation.generators.len());
            signature.push(presentation.observations[state as usize]);
            signature.extend(continuation(state));
            let class = match signatures.get(&signature) {
                Some(&class) => class,
                None => {
                    let class = next_class;
                    next_class = next_class
                        .checked_add(1)
                        .ok_or(ObservationalError::Overflow)?;
                    signatures.insert(signature, class);
                    class
                }
            };
            classes[state as usize] = class;
        }
        ranges.push(SortRange {
            start: class_start,
            len: next_class - class_start,
        });
    }
    Ok((classes.into_boxed_slice(), ranges.into_boxed_slice()))
}

fn state_sort(sorts: &[SortRange], state: u32) -> Option<u32> {
    sorts
        .iter()
        .position(|range| range.contains(state))
        .and_then(|sort| u32::try_from(sort).ok())
}

fn build_separators(
    presentation: &FinitePresentation,
    classes: &[u32],
) -> Result<SeparatorPool, ObservationalError> {
    let mut records = Vec::new();
    let mut paths = Vec::new();
    for sort in presentation.sorts.iter().copied() {
        for left in sort.start..sort.end() {
            for right in left + 1..sort.end() {
                if classes[left as usize] == classes[right as usize] {
                    continue;
                }
                let (path, left_output, right_output) =
                    distinguishing_path(presentation, left, right)
                        .ok_or(ObservationalError::MissingSeparator { left, right })?;
                let path_start =
                    u32::try_from(paths.len()).map_err(|_| ObservationalError::Overflow)?;
                let path_len =
                    u32::try_from(path.len()).map_err(|_| ObservationalError::Overflow)?;
                paths.extend_from_slice(&path);
                records.push(SeparatorRecord {
                    left_state: left,
                    right_state: right,
                    path_start,
                    path_len,
                    left_output,
                    right_output,
                });
            }
        }
    }
    Ok((records.into_boxed_slice(), paths.into_boxed_slice()))
}

fn distinguishing_path(
    presentation: &FinitePresentation,
    left: u32,
    right: u32,
) -> Option<(Vec<u32>, u32, u32)> {
    let mut queue = VecDeque::from([(left, right, Vec::new())]);
    let mut visited = FxHashSet::default();
    visited.insert((left, right));
    while let Some((current_left, current_right, path)) = queue.pop_front() {
        let left_output = presentation.observations[current_left as usize];
        let right_output = presentation.observations[current_right as usize];
        if left_output != right_output {
            return Some((path, left_output, right_output));
        }
        let sort = state_sort(&presentation.sorts, current_left)?;
        if state_sort(&presentation.sorts, current_right)? != sort {
            return None;
        }
        for (generator, _) in presentation.generators_from(sort) {
            let next_left = presentation.transition(generator, current_left)?;
            let next_right = presentation.transition(generator, current_right)?;
            if visited.insert((next_left, next_right)) {
                let mut next_path = path.clone();
                next_path.push(generator);
                queue.push_back((next_left, next_right, next_path));
            }
        }
    }
    None
}

pub fn verify_compilation(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
) -> Result<(), ObservationalError> {
    if compiled.class_ranges.len() != presentation.sorts.len()
        || compiled.state_classes.len() != presentation.state_count()
        || compiled.generator_records.len() != presentation.generators.len()
        || compiled.class_outputs.len() != compiled.class_representatives.len()
    {
        return Err(ObservationalError::CompiledShape);
    }
    let class_count = compiled.class_outputs.len();
    let mut seen_classes = vec![false; class_count];
    for (sort_index, state_range) in presentation.sorts.iter().copied().enumerate() {
        let class_range = compiled.class_ranges[sort_index];
        for state in state_range.start..state_range.end() {
            let class = compiled.state_classes[state as usize];
            if !class_range.contains(class) {
                return Err(ObservationalError::Partition);
            }
            seen_classes[class as usize] = true;
            if compiled.class_outputs[class as usize] != presentation.observations[state as usize] {
                return Err(ObservationalError::ObservationMismatch { class });
            }
        }
    }
    if seen_classes.iter().any(|&seen| !seen) {
        return Err(ObservationalError::Partition);
    }

    for (class, &representative) in compiled.class_representatives.iter().enumerate() {
        if representative as usize >= presentation.state_count()
            || compiled.state_classes[representative as usize] != class as u32
        {
            return Err(ObservationalError::Partition);
        }
    }

    for (generator_index, generator) in presentation.generators.iter().copied().enumerate() {
        let compiled_generator = compiled.generator_records[generator_index];
        if compiled_generator.source_sort != generator.source_sort
            || compiled_generator.target_sort != generator.target_sort
            || compiled_generator.transition_len
                != compiled.class_ranges[generator.source_sort as usize].len
        {
            return Err(ObservationalError::CompiledShape);
        }
        let source = presentation.sorts[generator.source_sort as usize];
        let mut expected: FxHashMap<u32, u32> = FxHashMap::default();
        for state in source.start..source.end() {
            let class = compiled.state_classes[state as usize];
            let target = presentation
                .transition(generator_index as u32, state)
                .ok_or(ObservationalError::CompiledShape)?;
            let target_class = compiled.state_classes[target as usize];
            if expected
                .insert(class, target_class)
                .is_some_and(|old| old != target_class)
            {
                return Err(ObservationalError::GeneratorMismatch {
                    generator: generator_index as u32,
                    class,
                });
            }
        }
        for (class, target) in expected {
            if compiled.transition(generator_index as u32, class) != Some(target) {
                return Err(ObservationalError::QuotientTransition {
                    generator: generator_index as u32,
                    class,
                });
            }
        }
    }

    let mut certified = FxHashSet::default();
    for (certificate, record) in compiled.separators.iter().copied().enumerate() {
        let start = record.path_start as usize;
        let Some(end) = start.checked_add(record.path_len as usize) else {
            return Err(ObservationalError::Separator { certificate });
        };
        let Some(path) = compiled.separator_paths.get(start..end) else {
            return Err(ObservationalError::Separator { certificate });
        };
        if record.left_state >= record.right_state
            || record.right_state as usize >= presentation.state_count()
            || state_sort(&presentation.sorts, record.left_state)
                != state_sort(&presentation.sorts, record.right_state)
            || compiled.state_classes[record.left_state as usize]
                == compiled.state_classes[record.right_state as usize]
            || !certified.insert((record.left_state, record.right_state))
        {
            return Err(ObservationalError::Separator { certificate });
        }
        let mut left = record.left_state;
        let mut right = record.right_state;
        for &generator in path {
            let Some(next_left) = presentation.transition(generator, left) else {
                return Err(ObservationalError::Separator { certificate });
            };
            let Some(next_right) = presentation.transition(generator, right) else {
                return Err(ObservationalError::Separator { certificate });
            };
            left = next_left;
            right = next_right;
        }
        let left_output = presentation.observations[left as usize];
        let right_output = presentation.observations[right as usize];
        if left_output == right_output
            || left_output != record.left_output
            || right_output != record.right_output
        {
            return Err(ObservationalError::Separator { certificate });
        }
    }
    for sort in presentation.sorts.iter().copied() {
        for left in sort.start..sort.end() {
            for right in left + 1..sort.end() {
                if compiled.state_classes[left as usize] != compiled.state_classes[right as usize]
                    && !certified.contains(&(left, right))
                {
                    return Err(ObservationalError::MissingSeparator { left, right });
                }
            }
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn minimizes_and_certifies_a_typed_chain() {
        let presentation = FinitePresentation::new(
            [3, 2],
            vec![0, 0, 0, 0, 1],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 1,
                transitions: vec![3, 4, 3].into_boxed_slice(),
            }],
        )
        .unwrap();
        let compiled = compile_observational(&presentation).unwrap();
        assert_eq!(compiled.metrics().classes, 4);
        assert_eq!(compiled.metrics().refinement_rounds, 1);
        assert_eq!(compiled.state_classes()[0], compiled.state_classes()[2]);
        assert_ne!(compiled.state_classes()[0], compiled.state_classes()[1]);
        verify_compilation(&presentation, &compiled).unwrap();
    }

    #[test]
    fn constructor_rejects_non_total_and_ill_typed_generators() {
        let short = FinitePresentation::new(
            [2, 1],
            vec![0, 0, 1],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 1,
                transitions: vec![2].into_boxed_slice(),
            }],
        );
        assert!(matches!(
            short,
            Err(ObservationalError::TransitionCount { .. })
        ));

        let escaped = FinitePresentation::new(
            [2, 1],
            vec![0, 0, 1],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 1,
                transitions: vec![2, 1].into_boxed_slice(),
            }],
        );
        assert!(matches!(
            escaped,
            Err(ObservationalError::TransitionTarget { .. })
        ));
    }

    #[test]
    fn verifier_rejects_independent_artifact_corruption() {
        let presentation = FinitePresentation::new(
            [3, 2],
            vec![0, 0, 0, 0, 1],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 1,
                transitions: vec![3, 4, 3].into_boxed_slice(),
            }],
        )
        .unwrap();
        let compiled = compile_observational(&presentation).unwrap();

        let mut bad_output = compiled.clone();
        bad_output.class_outputs[0] ^= 1;
        assert!(matches!(
            verify_compilation(&presentation, &bad_output),
            Err(ObservationalError::ObservationMismatch { .. })
        ));

        let mut bad_transition = compiled.clone();
        bad_transition.generator_transitions[0] ^= 1;
        assert!(matches!(
            verify_compilation(&presentation, &bad_transition),
            Err(ObservationalError::QuotientTransition { .. })
        ));

        let mut missing_separator = compiled.clone();
        missing_separator.separators = Vec::new().into_boxed_slice();
        missing_separator.separator_paths = Vec::new().into_boxed_slice();
        assert!(matches!(
            verify_compilation(&presentation, &missing_separator),
            Err(ObservationalError::MissingSeparator { .. })
        ));

        let mut false_separator = compiled;
        false_separator.separators[0].left_output = false_separator.separators[0].right_output;
        assert!(matches!(
            verify_compilation(&presentation, &false_separator),
            Err(ObservationalError::Separator { .. })
        ));

        let mut escaped_path = compile_observational(&presentation).unwrap();
        escaped_path.separators[0].path_start = u32::MAX;
        assert!(matches!(
            verify_compilation(&presentation, &escaped_path),
            Err(ObservationalError::Separator { .. })
        ));
    }
}
