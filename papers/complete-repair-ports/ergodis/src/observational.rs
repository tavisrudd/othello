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
//! Minimality evidence is policy-selected: canonical recomputation, a compact
//! replayable refinement transcript, or an explicit separator for every
//! separated same-sort concrete pair.

use rustc_hash::{FxHashMap, FxHashSet};
use std::collections::BTreeMap;
use std::collections::VecDeque;
use std::io::{Read, Write};
use thiserror::Error;

type Partition = (Box<[u32]>, Box<[SortRange]>);
type MinimizedPartition = (Box<[u32]>, Box<[SortRange]>, usize);
type WorklistPartition = (
    Box<[u32]>,
    Box<[SortRange]>,
    Box<[SplitRecord]>,
    Option<InverseIndex>,
);
type MultiwayPartition = (
    Box<[u32]>,
    Box<[SortRange]>,
    Box<[MultiwayRecord]>,
    Option<CombinedInverse>,
);
type SeparatorPool = (Box<[SeparatorRecord]>, Box<[u32]>);
type GeneratorSortIndex = (Box<[SortRange]>, Box<[u32]>);
type SplitWorkspace = (Box<[u32]>, Vec<u32>, Vec<u32>, Vec<SortRange>);

fn bitmap_storage(bits: usize) -> Result<Vec<u64>, ObservationalError> {
    let words = bits.checked_add(63).ok_or(ObservationalError::Overflow)? / 64;
    Ok(vec![0_u64; words])
}

#[inline]
fn bitmap_contains(bitmap: &[u64], index: usize) -> bool {
    debug_assert!(index / 64 < bitmap.len());
    bitmap[index / 64] & (1_u64 << (index % 64)) != 0
}

#[inline]
fn bitmap_insert(bitmap: &mut [u64], index: usize) {
    debug_assert!(index / 64 < bitmap.len());
    bitmap[index / 64] |= 1_u64 << (index % 64);
}

#[inline]
fn bitmap_remove(bitmap: &mut [u64], index: usize) {
    debug_assert!(index / 64 < bitmap.len());
    bitmap[index / 64] &= !(1_u64 << (index % 64));
}

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
    #[error("layered generator {generator} does not point to a later sort")]
    LayeredGeneratorOrder { generator: usize },
    #[error("restricted presentation names unknown generator {generator}")]
    UnknownGenerator { generator: u32 },
    #[error("restricted presentation repeats generator {generator}")]
    DuplicateGenerator { generator: u32 },
    #[error("a context language needs at least one state")]
    NoLanguageStates,
    #[error("context-language initial state {state} is out of range")]
    LanguageInitialState { state: u32 },
    #[error("context-language accepting state {state} is out of range")]
    LanguageAcceptingState { state: u32 },
    #[error("context language has {actual} transitions, expected {expected}")]
    LanguageTransitionCount { expected: usize, actual: usize },
    #[error("context-language transition {transition} targets an unknown state")]
    LanguageTransitionTarget { transition: usize },
    #[error("compiled artifact has an invalid shape")]
    CompiledShape,
    #[error("compiled artifact does not define a sort-respecting partition")]
    Partition,
    #[error("compiled class {class} is not observation-constant")]
    ObservationMismatch { class: u32 },
    #[error("generator {generator} is not compatible with class {class}")]
    GeneratorMismatch { generator: u32, class: u32 },
    #[error("generator {generator} is not type-preserving and cannot be iterated")]
    GeneratorNotEndomorphism { generator: u32 },
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
    generator_sort_ranges: Box<[SortRange]>,
    generator_ids_by_sort: Box<[u32]>,
}

/// An exact presentation for the submonoid generated by a selected context
/// alphabet, together with the map back to the original generator IDs.
#[derive(Clone, Debug)]
pub struct RestrictedPresentation {
    presentation: FinitePresentation,
    original_generator_ids: Box<[u32]>,
}

/// A deterministic finite recognizer for admissible generator words.
#[derive(Clone, Debug)]
pub struct FiniteContextLanguage {
    state_count: u32,
    initial_state: u32,
    accepting: Box<[u64]>,
    transitions: Box<[u32]>,
}

impl FiniteContextLanguage {
    pub fn new(
        state_count: u32,
        initial_state: u32,
        accepting_states: &[u32],
        generator_count: u32,
        transitions: impl Into<Box<[u32]>>,
    ) -> Result<Self, ObservationalError> {
        if state_count == 0 {
            return Err(ObservationalError::NoLanguageStates);
        }
        if initial_state >= state_count {
            return Err(ObservationalError::LanguageInitialState {
                state: initial_state,
            });
        }
        let expected = (state_count as usize)
            .checked_mul(generator_count as usize)
            .ok_or(ObservationalError::Overflow)?;
        let transitions = transitions.into();
        if transitions.len() != expected {
            return Err(ObservationalError::LanguageTransitionCount {
                expected,
                actual: transitions.len(),
            });
        }
        for (transition, &target) in transitions.iter().enumerate() {
            if target >= state_count {
                return Err(ObservationalError::LanguageTransitionTarget { transition });
            }
        }
        let mut accepting = bitmap_storage(state_count as usize)?;
        for &state in accepting_states {
            if state >= state_count {
                return Err(ObservationalError::LanguageAcceptingState { state });
            }
            bitmap_insert(&mut accepting, state as usize);
        }
        Ok(Self {
            state_count,
            initial_state,
            accepting: accepting.into_boxed_slice(),
            transitions,
        })
    }

    pub fn state_count(&self) -> u32 {
        self.state_count
    }

    pub fn initial_state(&self) -> u32 {
        self.initial_state
    }

    pub fn is_accepting(&self, state: u32) -> bool {
        state < self.state_count && bitmap_contains(&self.accepting, state as usize)
    }
}

/// Product presentation whose observations expose the underlying output only
/// after a word accepted by the supplied finite context language.
#[derive(Clone, Debug)]
pub struct ContextLanguageProduct {
    presentation: FinitePresentation,
    original_sorts: Box<[SortRange]>,
    language_state_count: u32,
    initial_language_state: u32,
}

impl ContextLanguageProduct {
    pub fn presentation(&self) -> &FinitePresentation {
        &self.presentation
    }

    pub fn product_state(&self, original_state: u32, language_state: u32) -> Option<u32> {
        if language_state >= self.language_state_count {
            return None;
        }
        let sort = self
            .original_sorts
            .partition_point(|range| range.end() <= original_state);
        let original = self.original_sorts.get(sort).copied()?;
        if !original.contains(original_state) {
            return None;
        }
        let product = self.presentation.sorts[sort];
        Some(product.start + language_state * original.len + original_state - original.start)
    }

    pub fn initial_product_state(&self, original_state: u32) -> Option<u32> {
        self.product_state(original_state, self.initial_language_state)
    }

    pub fn decode_product_state(&self, product_state: u32) -> Option<(u32, u32)> {
        let sort = self
            .presentation
            .sorts
            .partition_point(|range| range.end() <= product_state);
        let product = self.presentation.sorts.get(sort).copied()?;
        if !product.contains(product_state) {
            return None;
        }
        let original = self.original_sorts[sort];
        let local = product_state - product.start;
        let language_state = local / original.len;
        let original_state = original.start + local % original.len;
        Some((original_state, language_state))
    }
}

impl RestrictedPresentation {
    pub fn presentation(&self) -> &FinitePresentation {
        &self.presentation
    }

    /// Original generator ID for each generator in the restricted presentation.
    pub fn original_generator_ids(&self) -> &[u32] {
        &self.original_generator_ids
    }

    pub fn into_parts(self) -> (FinitePresentation, Box<[u32]>) {
        (self.presentation, self.original_generator_ids)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct PresentationFingerprint {
    pub low: u64,
    pub high: u64,
}

const _: () = assert!(std::mem::size_of::<PresentationFingerprint>() == 16);
const _: () = assert!(std::mem::align_of::<PresentationFingerprint>() == 8);

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
        let (generator_sort_ranges, generator_ids_by_sort) =
            index_generators_by_sort(sorts.len(), &generators, false)?;
        Ok(Self {
            sorts: sorts.into_boxed_slice(),
            observations,
            generators: generators.into_boxed_slice(),
            transitions: transitions.into_boxed_slice(),
            generator_sort_ranges,
            generator_ids_by_sort,
        })
    }

    pub fn sorts(&self) -> &[SortRange] {
        &self.sorts
    }

    pub fn observations(&self) -> &[u32] {
        &self.observations
    }

    /// Preserve the typed context system while replacing its observations.
    pub fn reobserve(
        &self,
        observations: impl Into<Box<[u32]>>,
    ) -> Result<Self, ObservationalError> {
        let observations = observations.into();
        if observations.len() != self.observations.len() {
            return Err(ObservationalError::ObservationCount {
                expected: self.observations.len(),
                actual: observations.len(),
            });
        }
        Ok(Self {
            sorts: self.sorts.clone(),
            observations,
            generators: self.generators.clone(),
            transitions: self.transitions.clone(),
            generator_sort_ranges: self.generator_sort_ranges.clone(),
            generator_ids_by_sort: self.generator_ids_by_sort.clone(),
        })
    }

    /// Replace observations while moving all context storage unchanged.
    pub fn into_reobserved(
        mut self,
        observations: impl Into<Box<[u32]>>,
    ) -> Result<Self, ObservationalError> {
        let observations = observations.into();
        if observations.len() != self.observations.len() {
            return Err(ObservationalError::ObservationCount {
                expected: self.observations.len(),
                actual: observations.len(),
            });
        }
        self.observations = observations;
        Ok(self)
    }

    pub fn generators(&self) -> &[GeneratorRecord] {
        &self.generators
    }

    /// Restrict admissible contexts to words over `generator_ids`.
    ///
    /// Compilation of the returned presentation computes contextual
    /// equivalence for exactly this generated submonoid. Generator order is
    /// preserved, and [`RestrictedPresentation::original_generator_ids`] maps
    /// quotient transitions and synthesized words back to this presentation.
    pub fn restrict_generators(
        &self,
        generator_ids: &[u32],
    ) -> Result<RestrictedPresentation, ObservationalError> {
        let mut seen = bitmap_storage(self.generators.len())?;
        let mut transition_count = 0_usize;
        for &generator_id in generator_ids {
            let Some(generator) = self.generators.get(generator_id as usize) else {
                return Err(ObservationalError::UnknownGenerator {
                    generator: generator_id,
                });
            };
            if bitmap_contains(&seen, generator_id as usize) {
                return Err(ObservationalError::DuplicateGenerator {
                    generator: generator_id,
                });
            }
            bitmap_insert(&mut seen, generator_id as usize);
            transition_count = transition_count
                .checked_add(generator.transition_len as usize)
                .ok_or(ObservationalError::Overflow)?;
        }

        let mut generators = Vec::with_capacity(generator_ids.len());
        let mut transitions = Vec::with_capacity(transition_count);
        for &generator_id in generator_ids {
            let source = self.generators[generator_id as usize];
            let transition_start =
                u32::try_from(transitions.len()).map_err(|_| ObservationalError::Overflow)?;
            let old_start = source.transition_start as usize;
            let old_end = old_start + source.transition_len as usize;
            transitions.extend_from_slice(&self.transitions[old_start..old_end]);
            generators.push(GeneratorRecord {
                source_sort: source.source_sort,
                target_sort: source.target_sort,
                transition_start,
                transition_len: source.transition_len,
            });
        }
        let (generator_sort_ranges, generator_ids_by_sort) =
            index_generators_by_sort(self.sorts.len(), &generators, false)?;
        Ok(RestrictedPresentation {
            presentation: Self {
                sorts: self.sorts.clone(),
                observations: self.observations.clone(),
                generators: generators.into_boxed_slice(),
                transitions: transitions.into_boxed_slice(),
                generator_sort_ranges,
                generator_ids_by_sort,
            },
            original_generator_ids: generator_ids.into(),
        })
    }

    /// Form the exact product with a finite recognizer for admissible context
    /// words. Nonaccepting recognizer states expose one masked observation;
    /// accepting states expose the original observation equality classes.
    pub fn product_with_context_language(
        &self,
        language: &FiniteContextLanguage,
    ) -> Result<ContextLanguageProduct, ObservationalError> {
        let expected_language_transitions = (language.state_count as usize)
            .checked_mul(self.generators.len())
            .ok_or(ObservationalError::Overflow)?;
        if language.transitions.len() != expected_language_transitions {
            return Err(ObservationalError::LanguageTransitionCount {
                expected: expected_language_transitions,
                actual: language.transitions.len(),
            });
        }

        let mut next = 0_u32;
        let mut sorts = Vec::with_capacity(self.sorts.len());
        for original in self.sorts.iter().copied() {
            let len = original
                .len
                .checked_mul(language.state_count)
                .ok_or(ObservationalError::Overflow)?;
            sorts.push(SortRange { start: next, len });
            next = next.checked_add(len).ok_or(ObservationalError::Overflow)?;
        }

        let mut distinct_outputs = self.observations.to_vec();
        distinct_outputs.sort_unstable();
        distinct_outputs.dedup();
        if distinct_outputs.len() >= u32::MAX as usize {
            return Err(ObservationalError::Overflow);
        }
        let mut observations = Vec::with_capacity(next as usize);
        for original_sort in self.sorts.iter().copied() {
            for language_state in 0..language.state_count {
                if language.is_accepting(language_state) {
                    for original_state in original_sort.start..original_sort.end() {
                        let output = self.observations[original_state as usize];
                        let dense = distinct_outputs
                            .binary_search(&output)
                            .expect("output came from the dense output directory");
                        observations.push(
                            u32::try_from(dense + 1).map_err(|_| ObservationalError::Overflow)?,
                        );
                    }
                } else {
                    observations.resize(
                        observations
                            .len()
                            .checked_add(original_sort.len as usize)
                            .ok_or(ObservationalError::Overflow)?,
                        0,
                    );
                }
            }
        }

        let transition_capacity = self
            .transitions
            .len()
            .checked_mul(language.state_count as usize)
            .ok_or(ObservationalError::Overflow)?;
        let mut generators = Vec::with_capacity(self.generators.len());
        let mut transitions = Vec::with_capacity(transition_capacity);
        for (generator_id, original_generator) in self.generators.iter().copied().enumerate() {
            let source = self.sorts[original_generator.source_sort as usize];
            let target = self.sorts[original_generator.target_sort as usize];
            let product_target = sorts[original_generator.target_sort as usize];
            let transition_start =
                u32::try_from(transitions.len()).map_err(|_| ObservationalError::Overflow)?;
            let old_start = original_generator.transition_start as usize;
            let old_end = old_start + original_generator.transition_len as usize;
            let original_transitions = &self.transitions[old_start..old_end];
            for language_state in 0..language.state_count {
                let next_language = language.transitions
                    [language_state as usize * self.generators.len() + generator_id];
                for &original_target in original_transitions {
                    let target_local = original_target - target.start;
                    transitions
                        .push(product_target.start + next_language * target.len + target_local);
                }
            }
            generators.push(GeneratorRecord {
                source_sort: original_generator.source_sort,
                target_sort: original_generator.target_sort,
                transition_start,
                transition_len: source
                    .len
                    .checked_mul(language.state_count)
                    .ok_or(ObservationalError::Overflow)?,
            });
        }
        let (generator_sort_ranges, generator_ids_by_sort) =
            index_generators_by_sort(sorts.len(), &generators, false)?;
        Ok(ContextLanguageProduct {
            presentation: Self {
                sorts: sorts.into_boxed_slice(),
                observations: observations.into_boxed_slice(),
                generators: generators.into_boxed_slice(),
                transitions: transitions.into_boxed_slice(),
                generator_sort_ranges,
                generator_ids_by_sort,
            },
            original_sorts: self.sorts.clone(),
            language_state_count: language.state_count,
            initial_language_state: language.initial_state,
        })
    }

    pub fn state_count(&self) -> usize {
        self.observations.len()
    }

    /// Stable non-cryptographic identity for the exact sorts, observations,
    /// generators, and transition tables supplied to the compiler.
    pub fn fingerprint(&self) -> PresentationFingerprint {
        let mut hash = [0xcbf2_9ce4_8422_2325_u64, 0x6c62_272e_07bb_0142_u64];
        fingerprint_word(&mut hash, self.sorts.len() as u32);
        for range in &self.sorts {
            fingerprint_word(&mut hash, range.start);
            fingerprint_word(&mut hash, range.len);
        }
        fingerprint_word(&mut hash, self.observations.len() as u32);
        for &observation in &self.observations {
            fingerprint_word(&mut hash, observation);
        }
        fingerprint_word(&mut hash, self.generators.len() as u32);
        for generator in &self.generators {
            fingerprint_word(&mut hash, generator.source_sort);
            fingerprint_word(&mut hash, generator.target_sort);
            fingerprint_word(&mut hash, generator.transition_len);
        }
        fingerprint_word(&mut hash, self.transitions.len() as u32);
        for &transition in &self.transitions {
            fingerprint_word(&mut hash, transition);
        }
        PresentationFingerprint {
            low: hash[0],
            high: hash[1],
        }
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
        let range = self.generator_sort_ranges[sort as usize];
        self.generator_ids_by_sort[range.start as usize..range.end() as usize]
            .iter()
            .copied()
            .map(|generator| (generator, self.generators[generator as usize]))
    }

    #[inline(always)]
    fn generator_ids_from(&self, sort: u32) -> &[u32] {
        let range = self.generator_sort_ranges[sort as usize];
        &self.generator_ids_by_sort[range.start as usize..range.end() as usize]
    }
}

fn index_generators_by_sort(
    sort_count: usize,
    generators: &[GeneratorRecord],
    by_target: bool,
) -> Result<GeneratorSortIndex, ObservationalError> {
    let mut counts = vec![0_u32; sort_count];
    for record in generators {
        let sort = if by_target {
            record.target_sort
        } else {
            record.source_sort
        };
        counts[sort as usize] = counts[sort as usize]
            .checked_add(1)
            .ok_or(ObservationalError::Overflow)?;
    }
    let mut next = 0_u32;
    let mut ranges = Vec::with_capacity(sort_count);
    for &len in &counts {
        ranges.push(SortRange { start: next, len });
        next = next.checked_add(len).ok_or(ObservationalError::Overflow)?;
    }
    let mut cursors = ranges.iter().map(|range| range.start).collect::<Vec<_>>();
    let mut ids = vec![0_u32; generators.len()];
    for (generator, record) in generators.iter().enumerate() {
        let sort = if by_target {
            record.target_sort
        } else {
            record.source_sort
        };
        let cursor = &mut cursors[sort as usize];
        ids[*cursor as usize] =
            u32::try_from(generator).map_err(|_| ObservationalError::Overflow)?;
        *cursor += 1;
    }
    Ok((ranges.into_boxed_slice(), ids.into_boxed_slice()))
}

fn fingerprint_word(hash: &mut [u64; 2], word: u32) {
    for byte in word.to_le_bytes() {
        hash[0] ^= u64::from(byte);
        hash[0] = hash[0].wrapping_mul(0x0000_0100_0000_01b3);
        hash[1] ^= u64::from(byte).wrapping_add(0x9d);
        hash[1] = hash[1].wrapping_mul(0x0000_0100_0000_01e7);
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
    /// Completed synchronous Moore rounds; zero for the worklist backend.
    pub refinement_rounds: usize,
    /// Binary block splits performed by the inverse-worklist backend.
    pub refinement_splits: usize,
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

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CertificatePolicy {
    /// Recompute the canonical minimum partition during verification without
    /// retaining a distinguishing word for every separated concrete pair.
    QuotientOnly,
    /// Retain one replayable record per binary partition split.
    SplitTranscript,
    /// Retain one replayable record per dirty-block multiway refinement.
    MultiwayTranscript,
    /// Select the binary or multiway transcript from presentation shape.
    AdaptiveTranscript,
    /// Retain the bounded-control certificate with one separator per
    /// separated same-sort concrete pair.
    ExhaustivePairAudit,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct SplitRecord {
    pub source_block: u32,
    pub generator: u32,
    pub splitter_block: u32,
    pub new_block: u32,
}

const _: () = assert!(std::mem::size_of::<SplitRecord>() == 16);
const _: () = assert!(std::mem::align_of::<SplitRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct MultiwayRecord {
    pub source_block: u32,
    pub new_block_start: u32,
    pub new_block_count: u32,
}

const _: () = assert!(std::mem::size_of::<MultiwayRecord>() == 12);
const _: () = assert!(std::mem::align_of::<MultiwayRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct InverseRecord {
    index_start: u32,
    index_len: u32,
    mode: u32,
    _pad: u32,
}

const _: () = assert!(std::mem::size_of::<InverseRecord>() == 16);
const _: () = assert!(std::mem::align_of::<InverseRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct InverseTargetRecord {
    target_state: u32,
    source_start: u32,
    source_len: u32,
    _pad: u32,
}

const _: () = assert!(std::mem::size_of::<InverseTargetRecord>() == 16);
const _: () = assert!(std::mem::align_of::<InverseTargetRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct SplitWorkItem {
    block: u32,
    generator: u32,
}

const _: () = assert!(std::mem::size_of::<SplitWorkItem>() == 8);
const _: () = assert!(std::mem::align_of::<SplitWorkItem>() == 4);

trait PendingDirectory {
    fn contains(&self, block: u32, generator: u32) -> bool;
    fn insert(&mut self, block: u32, generator: u32) -> Result<bool, ObservationalError>;
    fn remove(&mut self, block: u32, generator: u32) -> bool;
    fn add_block(&mut self, block: u32, sort: u32) -> Result<(), ObservationalError>;
}

#[repr(C)]
#[derive(Clone, Copy)]
struct PatriciaBranch {
    children: [u32; 2],
    critical_bit: u32,
    next_free: u32,
}

const _: () = assert!(std::mem::size_of::<PatriciaBranch>() == 16);
const _: () = assert!(std::mem::align_of::<PatriciaBranch>() == 4);

struct PatriciaPending {
    leaf_keys: Box<[u64]>,
    branches: Box<[PatriciaBranch]>,
    root: u32,
    free_leaf: u32,
    free_branch: u32,
    len: usize,
}

impl PatriciaPending {
    const NONE: u32 = u32::MAX;
    const LEAF_TAG: u32 = 1 << 31;
    const INDEX_MASK: u32 = Self::LEAF_TAG - 1;

    fn new(max_items: usize) -> Result<Self, ObservationalError> {
        if max_items >= Self::LEAF_TAG as usize {
            return Err(ObservationalError::Overflow);
        }
        let mut leaf_keys = vec![0_u64; max_items];
        for (index, next) in leaf_keys.iter_mut().enumerate() {
            *next = if index + 1 == max_items {
                u64::from(Self::NONE)
            } else {
                (index + 1) as u64
            };
        }
        let branch_count = max_items.saturating_sub(1);
        let mut branches = vec![
            PatriciaBranch {
                children: [Self::NONE; 2],
                critical_bit: u32::MAX,
                next_free: Self::NONE,
            };
            branch_count
        ];
        for (index, branch) in branches.iter_mut().enumerate() {
            branch.next_free = if index + 1 == branch_count {
                Self::NONE
            } else {
                (index + 1) as u32
            };
        }
        Ok(Self {
            leaf_keys: leaf_keys.into_boxed_slice(),
            branches: branches.into_boxed_slice(),
            root: Self::NONE,
            free_leaf: if max_items == 0 { Self::NONE } else { 0 },
            free_branch: if branch_count == 0 { Self::NONE } else { 0 },
            len: 0,
        })
    }

    fn storage_bytes(max_items: usize) -> Result<usize, ObservationalError> {
        if max_items >= Self::LEAF_TAG as usize {
            return Err(ObservationalError::Overflow);
        }
        max_items
            .checked_mul(std::mem::size_of::<u64>())
            .and_then(|bytes| {
                max_items
                    .saturating_sub(1)
                    .checked_mul(std::mem::size_of::<PatriciaBranch>())
                    .and_then(|branches| bytes.checked_add(branches))
            })
            .ok_or(ObservationalError::Overflow)
    }

    fn capacity(&self) -> usize {
        self.leaf_keys.len()
    }

    fn is_leaf(node: u32) -> bool {
        node & Self::LEAF_TAG != 0
    }

    fn leaf(index: u32) -> u32 {
        Self::LEAF_TAG | index
    }

    fn leaf_index(node: u32) -> usize {
        (node & Self::INDEX_MASK) as usize
    }

    fn direction(key: u64, critical_bit: u32) -> usize {
        ((key >> (63 - critical_bit)) & 1) as usize
    }

    fn contains_key(&self, key: u64) -> bool {
        let mut node = self.root;
        if node == Self::NONE {
            return false;
        }
        while !Self::is_leaf(node) {
            let branch = self.branches[node as usize];
            node = branch.children[Self::direction(key, branch.critical_bit)];
        }
        self.leaf_keys[Self::leaf_index(node)] == key
    }

    fn insert_key(&mut self, key: u64) -> Result<bool, ObservationalError> {
        if self.root == Self::NONE {
            let leaf = self.allocate_leaf(key)?;
            self.root = leaf;
            self.len = 1;
            return Ok(true);
        }
        let mut path_nodes = [Self::NONE; 64];
        let mut path_directions = [0_u8; 64];
        let mut depth = 0_usize;
        let mut leaf = self.root;
        while !Self::is_leaf(leaf) {
            let branch = self.branches[leaf as usize];
            let direction = Self::direction(key, branch.critical_bit);
            path_nodes[depth] = leaf;
            path_directions[depth] = direction as u8;
            depth += 1;
            leaf = branch.children[direction];
        }
        let old_key = self.leaf_keys[Self::leaf_index(leaf)];
        if old_key == key {
            return Ok(false);
        }
        if self.len == self.capacity() {
            return Err(ObservationalError::Overflow);
        }
        let critical_bit = (key ^ old_key).leading_zeros();
        let insertion_depth = path_nodes[..depth]
            .iter()
            .position(|&node| self.branches[node as usize].critical_bit >= critical_bit)
            .unwrap_or(depth);
        let (parent, parent_direction) = if insertion_depth == 0 {
            (Self::NONE, 0)
        } else {
            (
                path_nodes[insertion_depth - 1],
                path_directions[insertion_depth - 1] as usize,
            )
        };
        let displaced = if insertion_depth == depth {
            leaf
        } else {
            path_nodes[insertion_depth]
        };
        let new_leaf = self.allocate_leaf(key)?;
        let new_branch = self.allocate_branch()?;
        let direction = Self::direction(key, critical_bit);
        self.branches[new_branch as usize] = PatriciaBranch {
            children: if direction == 0 {
                [new_leaf, displaced]
            } else {
                [displaced, new_leaf]
            },
            critical_bit,
            next_free: Self::NONE,
        };
        if parent == Self::NONE {
            self.root = new_branch;
        } else {
            self.branches[parent as usize].children[parent_direction] = new_branch;
        }
        self.len += 1;
        Ok(true)
    }

    fn remove_key(&mut self, key: u64) -> bool {
        if self.root == Self::NONE {
            return false;
        }
        if Self::is_leaf(self.root) {
            if self.leaf_keys[Self::leaf_index(self.root)] != key {
                return false;
            }
            let leaf = self.root;
            self.root = Self::NONE;
            self.release_leaf(leaf);
            self.len = 0;
            return true;
        }
        let mut grandparent = Self::NONE;
        let mut grandparent_direction = 0_usize;
        let mut parent = Self::NONE;
        let mut direction = 0_usize;
        let mut node = self.root;
        while !Self::is_leaf(node) {
            grandparent = parent;
            grandparent_direction = direction;
            parent = node;
            direction = Self::direction(key, self.branches[node as usize].critical_bit);
            node = self.branches[node as usize].children[direction];
        }
        if self.leaf_keys[Self::leaf_index(node)] != key {
            return false;
        }
        let sibling = self.branches[parent as usize].children[1 - direction];
        if grandparent == Self::NONE {
            self.root = sibling;
        } else {
            self.branches[grandparent as usize].children[grandparent_direction] = sibling;
        }
        self.release_leaf(node);
        self.release_branch(parent);
        self.len -= 1;
        true
    }

    fn allocate_leaf(&mut self, key: u64) -> Result<u32, ObservationalError> {
        let leaf = self.free_leaf;
        if leaf == Self::NONE {
            return Err(ObservationalError::Overflow);
        }
        self.free_leaf = self.leaf_keys[leaf as usize] as u32;
        self.leaf_keys[leaf as usize] = key;
        Ok(Self::leaf(leaf))
    }

    fn release_leaf(&mut self, leaf: u32) {
        let index = Self::leaf_index(leaf);
        self.leaf_keys[index] = u64::from(self.free_leaf);
        self.free_leaf = index as u32;
    }

    fn allocate_branch(&mut self) -> Result<u32, ObservationalError> {
        let branch = self.free_branch;
        if branch == Self::NONE {
            return Err(ObservationalError::Overflow);
        }
        self.free_branch = self.branches[branch as usize].next_free;
        Ok(branch)
    }

    fn release_branch(&mut self, branch: u32) {
        self.branches[branch as usize].next_free = self.free_branch;
        self.free_branch = branch;
    }
}

impl PendingDirectory for PatriciaPending {
    fn contains(&self, block: u32, generator: u32) -> bool {
        self.contains_key(split_work_key(block, generator))
    }

    fn insert(&mut self, block: u32, generator: u32) -> Result<bool, ObservationalError> {
        self.insert_key(split_work_key(block, generator))
    }

    fn remove(&mut self, block: u32, generator: u32) -> bool {
        self.remove_key(split_work_key(block, generator))
    }

    fn add_block(&mut self, _block: u32, _sort: u32) -> Result<(), ObservationalError> {
        Ok(())
    }
}

struct DensePending {
    slots: Box<[u64]>,
    block_starts: Box<[u32]>,
    generator_locals: Box<[u32]>,
    incoming_counts: Box<[u32]>,
    next_slot: u32,
}

impl DensePending {
    fn new(
        presentation: &FinitePresentation,
        initial_block_sorts: &[u32],
        refinement: Option<&RefinementGenerators>,
    ) -> Result<Self, ObservationalError> {
        let index = pending_generator_index(presentation, refinement)?;
        let dense_slots = dense_pending_slots(presentation, &index.incoming_counts)?;
        u32::try_from(dense_slots).map_err(|_| ObservationalError::Overflow)?;
        let mut pending = Self {
            slots: bitmap_storage(dense_slots)?.into_boxed_slice(),
            block_starts: vec![u32::MAX; presentation.state_count()].into_boxed_slice(),
            generator_locals: index.generator_locals,
            incoming_counts: index.incoming_counts,
            next_slot: 0,
        };
        for (block, &sort) in initial_block_sorts.iter().enumerate() {
            pending.add_block(block as u32, sort)?;
        }
        Ok(pending)
    }

    fn slot(&self, block: u32, generator: u32) -> usize {
        debug_assert_ne!(self.block_starts[block as usize], u32::MAX);
        (self.block_starts[block as usize] + self.generator_locals[generator as usize]) as usize
    }
}

impl PendingDirectory for DensePending {
    #[inline(always)]
    fn contains(&self, block: u32, generator: u32) -> bool {
        bitmap_contains(&self.slots, self.slot(block, generator))
    }

    #[inline(always)]
    fn insert(&mut self, block: u32, generator: u32) -> Result<bool, ObservationalError> {
        let slot = self.slot(block, generator);
        if bitmap_contains(&self.slots, slot) {
            return Ok(false);
        }
        bitmap_insert(&mut self.slots, slot);
        Ok(true)
    }

    #[inline(always)]
    fn remove(&mut self, block: u32, generator: u32) -> bool {
        let slot = self.slot(block, generator);
        if !bitmap_contains(&self.slots, slot) {
            return false;
        }
        bitmap_remove(&mut self.slots, slot);
        true
    }

    #[inline(always)]
    fn add_block(&mut self, block: u32, sort: u32) -> Result<(), ObservationalError> {
        let width = self.incoming_counts[sort as usize];
        let end = self
            .next_slot
            .checked_add(width)
            .ok_or(ObservationalError::Overflow)?;
        if end as usize > self.slots.len().saturating_mul(64)
            || self.block_starts[block as usize] != u32::MAX
        {
            return Err(ObservationalError::Overflow);
        }
        self.block_starts[block as usize] = self.next_slot;
        self.next_slot = end;
        Ok(())
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum PendingMode {
    Dense,
    Sparse,
}

struct PendingGeneratorIndex {
    incoming_counts: Box<[u32]>,
    generator_locals: Box<[u32]>,
}

fn pending_generator_index(
    presentation: &FinitePresentation,
    refinement: Option<&RefinementGenerators>,
) -> Result<PendingGeneratorIndex, ObservationalError> {
    let mut incoming_counts = vec![0_u32; presentation.sorts.len()];
    let mut generator_locals = vec![u32::MAX; presentation.generators.len()];
    for sort in 0..presentation.sorts.len() {
        let generators = refinement.map_or_else(
            || presentation.generator_ids_from(sort as u32),
            |directory| directory.ids_from(sort as u32),
        );
        for &generator in generators {
            let record = presentation.generators[generator as usize];
            let count = &mut incoming_counts[record.target_sort as usize];
            generator_locals[generator as usize] = *count;
            *count = count.checked_add(1).ok_or(ObservationalError::Overflow)?;
        }
    }
    Ok(PendingGeneratorIndex {
        incoming_counts: incoming_counts.into_boxed_slice(),
        generator_locals: generator_locals.into_boxed_slice(),
    })
}

fn dense_pending_slots(
    presentation: &FinitePresentation,
    incoming_counts: &[u32],
) -> Result<usize, ObservationalError> {
    presentation.sorts.iter().zip(incoming_counts).try_fold(
        0_usize,
        |slots, (states, &incoming)| {
            slots
                .checked_add(
                    (states.len as usize)
                        .checked_mul(incoming as usize)
                        .ok_or(ObservationalError::Overflow)?,
                )
                .ok_or(ObservationalError::Overflow)
        },
    )
}

fn pending_mode(
    presentation: &FinitePresentation,
    refinement: Option<&RefinementGenerators>,
) -> Result<PendingMode, ObservationalError> {
    let index = pending_generator_index(presentation, refinement)?;
    let dense_slots = dense_pending_slots(presentation, &index.incoming_counts)?;
    let dense_bytes = dense_slots
        .checked_add(63)
        .map(|bits| bits / 64)
        .and_then(|words| words.checked_mul(std::mem::size_of::<u64>()))
        .and_then(|bytes| {
            let words = presentation
                .state_count()
                .checked_add(presentation.generators.len())?
                .checked_add(presentation.sorts.len())?;
            bytes.checked_add(words.checked_mul(std::mem::size_of::<u32>())?)
        })
        .ok_or(ObservationalError::Overflow)?;
    let active_transitions = refinement.map_or(presentation.transitions.len(), |directory| {
        directory
            .ids
            .iter()
            .map(|&generator| presentation.generators[generator as usize].transition_len as usize)
            .sum()
    });
    let sparse_bytes = PatriciaPending::storage_bytes(active_transitions)?;
    Ok(if dense_bytes <= sparse_bytes {
        PendingMode::Dense
    } else {
        PendingMode::Sparse
    })
}

struct InverseIndex {
    records: Box<[InverseRecord]>,
    offsets: Box<[u32]>,
    targets: Box<[InverseTargetRecord]>,
    sources: Box<[u32]>,
}

struct CombinedInverse {
    offsets: Box<[u32]>,
    sources: Box<[u32]>,
}

#[derive(Debug)]
struct IndexedMinHeap {
    classes: Vec<u32>,
    positions: Box<[u32]>,
}

impl IndexedMinHeap {
    fn new(class_count: usize) -> Self {
        Self {
            classes: Vec::with_capacity(class_count),
            positions: vec![u32::MAX; class_count].into_boxed_slice(),
        }
    }

    fn clear(&mut self) {
        self.classes.clear();
        self.positions.fill(u32::MAX);
    }

    fn push_or_decrease(
        &mut self,
        class: u32,
        distances: &[u64],
    ) -> Result<(), ObservationalError> {
        let position = self.positions[class as usize];
        let mut child = if position == u32::MAX {
            if self.classes.len() == self.classes.capacity() {
                return Err(ObservationalError::Overflow);
            }
            self.classes.push(class);
            let position = self.classes.len() - 1;
            self.positions[class as usize] = position as u32;
            position
        } else {
            position as usize
        };
        while child != 0 {
            let parent = (child - 1) / 2;
            if distances[self.classes[parent] as usize] <= distances[class as usize] {
                break;
            }
            let displaced = self.classes[parent];
            self.classes[child] = displaced;
            self.positions[displaced as usize] = child as u32;
            child = parent;
        }
        self.classes[child] = class;
        self.positions[class as usize] = child as u32;
        Ok(())
    }

    fn pop_min(&mut self, distances: &[u64]) -> Option<u32> {
        let minimum = *self.classes.first()?;
        let last = self.classes.pop().expect("nonempty heap");
        self.positions[minimum as usize] = u32::MAX;
        if self.classes.is_empty() {
            return Some(minimum);
        }
        let mut parent = 0_usize;
        while let Some(left) = parent.checked_mul(2).and_then(|value| value.checked_add(1)) {
            if left >= self.classes.len() {
                break;
            }
            let right = left + 1;
            let child = if right < self.classes.len()
                && distances[self.classes[right] as usize] < distances[self.classes[left] as usize]
            {
                right
            } else {
                left
            };
            if distances[last as usize] <= distances[self.classes[child] as usize] {
                break;
            }
            let displaced = self.classes[child];
            self.classes[parent] = displaced;
            self.positions[displaced as usize] = parent as u32;
            parent = child;
        }
        self.classes[parent] = last;
        self.positions[last as usize] = parent as u32;
        Some(minimum)
    }
}

struct RefinementGenerators {
    ranges: Box<[SortRange]>,
    ids: Box<[u32]>,
    aliases: Box<[u32]>,
    transition_starts: Box<[usize]>,
}

struct PowerReductionWorkspace {
    redundant: Vec<u64>,
    expanded: Vec<u64>,
    scratch: Vec<u32>,
}

impl RefinementGenerators {
    fn new(presentation: &FinitePresentation) -> Result<Self, ObservationalError> {
        // A sort in this greatest fixed point is observationally singleton:
        // its immediate observation is constant and every outgoing context
        // remains inside the fixed point.  Generators into such a sort cannot
        // distinguish source states.  Identity, constant, and pointwise-
        // duplicate generators are likewise refinement-neutral.
        let mut singleton = presentation
            .sorts
            .iter()
            .copied()
            .map(|states| {
                let observations =
                    &presentation.observations[states.start as usize..states.end() as usize];
                observations
                    .first()
                    .is_none_or(|first| observations.iter().all(|value| value == first))
            })
            .collect::<Vec<_>>();
        loop {
            let mut changed = false;
            for sort in 0..presentation.sorts.len() {
                if singleton[sort]
                    && presentation
                        .generators_from(sort as u32)
                        .any(|(_, record)| !singleton[record.target_sort as usize])
                {
                    singleton[sort] = false;
                    changed = true;
                }
            }
            if !changed {
                break;
            }
        }

        let mut ids = Vec::with_capacity(presentation.generators.len());
        let mut transition_starts = Vec::with_capacity(presentation.generators.len());
        let mut ranges = Vec::with_capacity(presentation.sorts.len());
        let mut aliases = vec![u32::MAX; presentation.generators.len()];
        let mut power = PowerReductionWorkspace {
            redundant: bitmap_storage(presentation.generators.len())?,
            expanded: bitmap_storage(presentation.generators.len())?,
            scratch: Vec::new(),
        };
        for sort in 0..presentation.sorts.len() {
            let start = u32::try_from(ids.len()).map_err(|_| ObservationalError::Overflow)?;
            let source = presentation.sorts[sort];
            for (generator, record) in presentation.generators_from(sort as u32) {
                if singleton[record.target_sort as usize] {
                    continue;
                }
                let transition_start = record.transition_start as usize;
                let transitions = &presentation.transitions
                    [transition_start..transition_start + record.transition_len as usize];
                if transitions
                    .first()
                    .is_none_or(|first| transitions.iter().all(|target| target == first))
                {
                    continue;
                }
                if record.source_sort == record.target_sort
                    && transitions
                        .iter()
                        .enumerate()
                        .all(|(local, &target)| target == source.start + local as u32)
                {
                    continue;
                }
                let duplicate = ids[start as usize..].iter().copied().find(|&prior| {
                    let prior_record = presentation.generators[prior as usize];
                    let prior_start = prior_record.transition_start as usize;
                    prior_record.target_sort == record.target_sort
                        && presentation.transitions
                            [prior_start..prior_start + prior_record.transition_len as usize]
                            == *transitions
                });
                if let Some(prior) = duplicate {
                    aliases[generator as usize] = prior;
                }
                let composite = duplicate.is_none()
                    && generator_is_retained_composite(presentation, record, transitions, &ids);
                let power = duplicate.is_none()
                    && !composite
                    && generator_is_retained_power(
                        presentation,
                        generator,
                        record,
                        transitions,
                        &ids,
                        &mut power,
                    );
                if duplicate.is_none() && !composite && !power {
                    ids.push(generator);
                    transition_starts.push(transition_start);
                }
            }
            ranges.push(SortRange {
                start,
                len: u32::try_from(ids.len()).map_err(|_| ObservationalError::Overflow)? - start,
            });
        }
        Ok(Self {
            ranges: ranges.into_boxed_slice(),
            ids: ids.into_boxed_slice(),
            aliases: aliases.into_boxed_slice(),
            transition_starts: transition_starts.into_boxed_slice(),
        })
    }

    #[inline(always)]
    fn ids_from(&self, sort: u32) -> &[u32] {
        let range = self.ranges[sort as usize];
        &self.ids[range.start as usize..range.end() as usize]
    }

    #[inline(always)]
    fn transition_starts_from(&self, sort: u32) -> &[usize] {
        let range = self.ranges[sort as usize];
        &self.transition_starts[range.start as usize..range.end() as usize]
    }
}

fn retained_source_width(
    presentation: &FinitePresentation,
    retained: &[u32],
    source_sort: u32,
) -> usize {
    retained
        .iter()
        .filter(|&&generator| {
            presentation.generators[generator as usize].source_sort == source_sort
        })
        .take(5)
        .count()
}

fn generator_is_retained_power(
    presentation: &FinitePresentation,
    candidate_generator: u32,
    candidate: GeneratorRecord,
    candidate_transitions: &[u32],
    retained: &[u32],
    workspace: &mut PowerReductionWorkspace,
) -> bool {
    const MAX_POWER: usize = 32;
    if bitmap_contains(&workspace.redundant, candidate_generator as usize) {
        return true;
    }
    if retained_source_width(presentation, retained, candidate.source_sort) >= 5
        || candidate.source_sort != candidate.target_sort
    {
        return false;
    }
    let source = presentation.sorts[candidate.source_sort as usize];
    for base in retained.iter().copied() {
        let record = presentation.generators[base as usize];
        if record.source_sort != candidate.source_sort
            || record.target_sort != candidate.target_sort
        {
            continue;
        }
        let transition_start = record.transition_start as usize;
        if bitmap_contains(&workspace.expanded, base as usize) {
            continue;
        }
        let mut representative = source.start;
        let representative_target = candidate_transitions[0];
        let mut plausible = false;
        for power in 1..=MAX_POWER {
            representative = presentation.transitions
                [transition_start + (representative - source.start) as usize];
            plausible |= power >= 3 && representative == representative_target;
        }
        if !plausible {
            continue;
        }

        if workspace.scratch.len() < source.len as usize {
            workspace.scratch.resize(source.len as usize, 0);
        }
        let current = &mut workspace.scratch[..source.len as usize];
        for (local, target) in current.iter_mut().enumerate() {
            *target = source.start + local as u32;
        }
        for power in 1..=MAX_POWER {
            for target in current.iter_mut() {
                *target =
                    presentation.transitions[transition_start + (*target - source.start) as usize];
            }
            if power < 3 {
                continue;
            }
            for (generator, candidate_record) in presentation.generators_from(candidate.source_sort)
            {
                if candidate_record.target_sort != candidate.target_sort {
                    continue;
                }
                let start = candidate_record.transition_start as usize;
                let transitions = &presentation.transitions
                    [start..start + candidate_record.transition_len as usize];
                if transitions.first() == current.first() && transitions == current {
                    bitmap_insert(&mut workspace.redundant, generator as usize);
                }
            }
        }
        bitmap_insert(&mut workspace.expanded, base as usize);
        if bitmap_contains(&workspace.redundant, candidate_generator as usize) {
            return true;
        }
    }
    false
}

fn generator_is_retained_composite(
    presentation: &FinitePresentation,
    candidate: GeneratorRecord,
    candidate_transitions: &[u32],
    retained: &[u32],
) -> bool {
    // This reduction exists to recover the exact packed (arity <= 4)
    // backend. Once five independent generators from this source survive,
    // no later removal can restore admission, so do not grow preprocessing
    // quadratically on wide irreducible alphabets.
    if retained_source_width(presentation, retained, candidate.source_sort) >= 5 {
        return false;
    }
    retained.iter().copied().any(|first| {
        let first_record = presentation.generators[first as usize];
        if first_record.source_sort != candidate.source_sort {
            return false;
        }
        let first_start = first_record.transition_start as usize;
        let first_transitions = &presentation.transitions
            [first_start..first_start + first_record.transition_len as usize];
        retained.iter().copied().any(|second| {
            let second_record = presentation.generators[second as usize];
            if second_record.source_sort != first_record.target_sort
                || second_record.target_sort != candidate.target_sort
            {
                return false;
            }
            let intermediate = presentation.sorts[second_record.source_sort as usize];
            let second_start = second_record.transition_start as usize;
            first_transitions.iter().zip(candidate_transitions).all(
                |(&middle_state, &candidate_target)| {
                    let middle_local = (middle_state - intermediate.start) as usize;
                    presentation.transitions[second_start + middle_local] == candidate_target
                },
            )
        })
    })
}

impl CombinedInverse {
    fn new(
        presentation: &FinitePresentation,
        refinement: Option<&RefinementGenerators>,
    ) -> Result<Self, ObservationalError> {
        let mut counts = vec![0_u32; presentation.state_count()];
        let mut source_count = 0_usize;
        for sort in 0..presentation.sorts.len() {
            let generators = refinement.map_or_else(
                || presentation.generator_ids_from(sort as u32),
                |directory| directory.ids_from(sort as u32),
            );
            for &generator in generators {
                let record = presentation.generators[generator as usize];
                let start = record.transition_start as usize;
                let transitions =
                    &presentation.transitions[start..start + record.transition_len as usize];
                source_count = source_count
                    .checked_add(transitions.len())
                    .ok_or(ObservationalError::Overflow)?;
                for &target in transitions {
                    counts[target as usize] = counts[target as usize]
                        .checked_add(1)
                        .ok_or(ObservationalError::Overflow)?;
                }
            }
        }
        let mut offsets = Vec::with_capacity(presentation.state_count().saturating_add(1));
        let mut total = 0_u32;
        for count in &mut counts {
            offsets.push(total);
            total = total
                .checked_add(*count)
                .ok_or(ObservationalError::Overflow)?;
            *count = offsets[offsets.len() - 1];
        }
        offsets.push(total);
        let mut sources = vec![0_u32; source_count];
        for sort in 0..presentation.sorts.len() {
            let generators = refinement.map_or_else(
                || presentation.generator_ids_from(sort as u32),
                |directory| directory.ids_from(sort as u32),
            );
            let source = presentation.sorts[sort];
            for &generator in generators {
                let record = presentation.generators[generator as usize];
                let start = record.transition_start as usize;
                let transitions =
                    &presentation.transitions[start..start + record.transition_len as usize];
                for (local, &target) in transitions.iter().enumerate() {
                    let cursor = &mut counts[target as usize];
                    sources[*cursor as usize] = source.start + local as u32;
                    *cursor += 1;
                }
            }
        }
        Ok(Self {
            offsets: offsets.into_boxed_slice(),
            sources: sources.into_boxed_slice(),
        })
    }

    #[inline(always)]
    fn predecessors(&self, target: u32) -> &[u32] {
        let start = self.offsets[target as usize] as usize;
        let end = self.offsets[target as usize + 1] as usize;
        &self.sources[start..end]
    }

    fn verify(&self, presentation: &FinitePresentation) -> Result<(), ObservationalError> {
        let refinement = presentation
            .generator_sort_ranges
            .iter()
            .any(|range| range.len > 4)
            .then(|| RefinementGenerators::new(presentation))
            .transpose()?;
        let rebuilt = Self::new(presentation, refinement.as_ref())?;
        if self.offsets != rebuilt.offsets || self.sources != rebuilt.sources {
            return Err(ObservationalError::CompiledShape);
        }
        Ok(())
    }
}

enum TargetGeneratorDirectory {
    BySort {
        ranges: Box<[SortRange]>,
        generators: Box<[u32]>,
    },
    ByState {
        offsets: Box<[u32]>,
        generators: Box<[u32]>,
    },
}

impl InverseIndex {
    const DENSE: u32 = 0;
    const SPARSE: u32 = 1;
    const INACTIVE: u32 = 2;

    fn new(presentation: &FinitePresentation) -> Result<Self, ObservationalError> {
        Self::new_prepared(presentation, None)
    }

    fn new_prepared(
        presentation: &FinitePresentation,
        refinement: Option<&RefinementGenerators>,
    ) -> Result<Self, ObservationalError> {
        let active = |sort: usize| {
            refinement.map_or_else(
                || presentation.generator_ids_from(sort as u32),
                |directory| directory.ids_from(sort as u32),
            )
        };
        let max_source = presentation
            .sorts
            .iter()
            .enumerate()
            .filter(|&(sort, _)| !active(sort).is_empty())
            .map(|(_, range)| range.len as usize)
            .max()
            .unwrap_or(0);
        let max_counting_target = presentation
            .sorts
            .iter()
            .enumerate()
            .flat_map(|(sort, _)| active(sort).iter().copied())
            .filter_map(|generator| {
                let record = presentation.generators[generator as usize];
                let source_len = presentation.sorts[record.source_sort as usize].len as usize;
                let target_len = presentation.sorts[record.target_sort as usize].len as usize;
                (target_len <= source_len.saturating_mul(4)).then_some(target_len)
            })
            .max()
            .unwrap_or(0);
        let mut source_scratch = vec![0_u32; max_source];
        // Counting scatter only needs one target-sized array: counts are
        // consumed in place into write cursors before the stable scatter.
        let mut target_cursors = vec![0_u32; max_counting_target];
        let mut records = vec![
            InverseRecord {
                index_start: 0,
                index_len: 0,
                mode: Self::INACTIVE,
                _pad: 0,
            };
            presentation.generators.len()
        ];
        let mut offsets = Vec::new();
        let mut targets = Vec::new();
        let source_capacity = refinement.map_or(presentation.transitions.len(), |directory| {
            directory
                .ids
                .iter()
                .map(|&generator| {
                    presentation.generators[generator as usize].transition_len as usize
                })
                .sum()
        });
        let mut sources: Vec<u32> = Vec::with_capacity(source_capacity);
        for sort in 0..presentation.sorts.len() {
            for &generator in active(sort) {
                let record = presentation.generators[generator as usize];
                let source = presentation.sorts[record.source_sort as usize];
                let target = presentation.sorts[record.target_sort as usize];
                let transition_start = record.transition_start as usize;
                let transition_table = &presentation.transitions
                    [transition_start..transition_start + record.transition_len as usize];
                let use_counting_scatter =
                    target.len as usize <= (source.len as usize).saturating_mul(4);
                let distinct_targets = if use_counting_scatter {
                    let cursors = &mut target_cursors[..target.len as usize];
                    cursors.fill(0);
                    for &target_state in transition_table {
                        cursors[(target_state - target.start) as usize] += 1;
                    }
                    let mut next = 0_u32;
                    let mut distinct = 0_usize;
                    for cursor in cursors.iter_mut() {
                        let count = *cursor;
                        *cursor = next;
                        next += count;
                        distinct += usize::from(count != 0);
                    }
                    for (local, &target_state) in transition_table.iter().enumerate() {
                        let cursor = &mut target_cursors[(target_state - target.start) as usize];
                        source_scratch[*cursor as usize] = source.start + local as u32;
                        *cursor += 1;
                    }
                    distinct
                } else {
                    for (local, slot) in
                        source_scratch[..source.len as usize].iter_mut().enumerate()
                    {
                        *slot = source.start + local as u32;
                    }
                    source_scratch[..source.len as usize].sort_unstable_by_key(|&state| {
                        (transition_table[(state - source.start) as usize], state)
                    });
                    source_scratch[..source.len as usize]
                        .iter()
                        .enumerate()
                        .filter(|&(position, &state)| {
                            position == 0
                                || transition_table[(state - source.start) as usize]
                                    != transition_table
                                        [(source_scratch[position - 1] - source.start) as usize]
                        })
                        .count()
                };
                let dense_bytes = (target.len as usize)
                    .checked_add(1)
                    .and_then(|len| len.checked_mul(std::mem::size_of::<u32>()))
                    .ok_or(ObservationalError::Overflow)?;
                let sparse_bytes = distinct_targets
                    .checked_mul(std::mem::size_of::<InverseTargetRecord>())
                    .ok_or(ObservationalError::Overflow)?;
                let mut position = 0_usize;
                let (index_start, index_len, mode) = if dense_bytes <= sparse_bytes {
                    offsets.reserve_exact(
                        (target.len as usize)
                            .checked_add(1)
                            .ok_or(ObservationalError::Overflow)?,
                    );
                    let index_start =
                        u32::try_from(offsets.len()).map_err(|_| ObservationalError::Overflow)?;
                    for target_state in target.start..target.end() {
                        offsets.push(
                            u32::try_from(sources.len())
                                .map_err(|_| ObservationalError::Overflow)?,
                        );
                        while position < source.len as usize
                            && transition_table[(source_scratch[position] - source.start) as usize]
                                == target_state
                        {
                            sources.push(source_scratch[position]);
                            position += 1;
                        }
                    }
                    offsets.push(
                        u32::try_from(sources.len()).map_err(|_| ObservationalError::Overflow)?,
                    );
                    (
                        index_start,
                        target
                            .len
                            .checked_add(1)
                            .ok_or(ObservationalError::Overflow)?,
                        Self::DENSE,
                    )
                } else {
                    // Grow only when a generator actually uses the sparse directory.
                    // Amortized growth avoids copying the accumulated directory once
                    // per sparse generator while dense-only presentations reserve none.
                    targets.reserve(distinct_targets);
                    let index_start =
                        u32::try_from(targets.len()).map_err(|_| ObservationalError::Overflow)?;
                    while position < source.len as usize {
                        let target_state =
                            transition_table[(source_scratch[position] - source.start) as usize];
                        let source_start = u32::try_from(sources.len())
                            .map_err(|_| ObservationalError::Overflow)?;
                        let group_start = position;
                        while position < source.len as usize
                            && transition_table[(source_scratch[position] - source.start) as usize]
                                == target_state
                        {
                            sources.push(source_scratch[position]);
                            position += 1;
                        }
                        targets.push(InverseTargetRecord {
                            target_state,
                            source_start,
                            source_len: u32::try_from(position - group_start)
                                .map_err(|_| ObservationalError::Overflow)?,
                            _pad: 0,
                        });
                    }
                    let index_len = u32::try_from(targets.len())
                        .map_err(|_| ObservationalError::Overflow)?
                        - index_start;
                    (index_start, index_len, Self::SPARSE)
                };
                records[generator as usize] = InverseRecord {
                    index_start,
                    index_len,
                    mode,
                    _pad: 0,
                };
            }
        }
        Ok(Self {
            records: records.into_boxed_slice(),
            offsets: offsets.into_boxed_slice(),
            targets: targets.into_boxed_slice(),
            sources: sources.into_boxed_slice(),
        })
    }

    #[inline(always)]
    fn predecessors(
        &self,
        presentation: &FinitePresentation,
        generator: u32,
        target_state: u32,
    ) -> &[u32] {
        let record = self.records[generator as usize];
        let generator_record = presentation.generators[generator as usize];
        let target = presentation.sorts[generator_record.target_sort as usize];
        debug_assert!(target.contains(target_state));
        if record.mode == Self::DENSE {
            let local = (target_state - target.start) as usize;
            let start = self.offsets[record.index_start as usize + local] as usize;
            let end = self.offsets[record.index_start as usize + local + 1] as usize;
            &self.sources[start..end]
        } else {
            debug_assert_eq!(record.mode, Self::SPARSE);
            let targets = &self.targets
                [record.index_start as usize..(record.index_start + record.index_len) as usize];
            let Ok(local) = targets.binary_search_by_key(&target_state, |entry| entry.target_state)
            else {
                return &[];
            };
            let entry = targets[local];
            &self.sources
                [entry.source_start as usize..(entry.source_start + entry.source_len) as usize]
        }
    }

    fn verify(&self, presentation: &FinitePresentation) -> Result<(), ObservationalError> {
        let max_source = presentation
            .generators
            .iter()
            .map(|record| presentation.sorts[record.source_sort as usize].len as usize)
            .max()
            .unwrap_or(0);
        let mut seen = vec![0_u8; max_source];
        for (generator, record) in presentation.generators.iter().copied().enumerate() {
            let inverse = self
                .records
                .get(generator)
                .ok_or(ObservationalError::CompiledShape)?;
            let source = presentation.sorts[record.source_sort as usize];
            let target = presentation.sorts[record.target_sort as usize];
            seen[..source.len as usize].fill(0);
            let mut check = |target_state: u32,
                             predecessors: &[u32]|
             -> Result<(), ObservationalError> {
                for &state in predecessors {
                    if !source.contains(state)
                        || presentation.transition(generator as u32, state) != Some(target_state)
                    {
                        return Err(ObservationalError::CompiledShape);
                    }
                    let seen = &mut seen[(state - source.start) as usize];
                    if *seen != 0 {
                        return Err(ObservationalError::CompiledShape);
                    }
                    *seen = 1;
                }
                Ok(())
            };
            if inverse.mode == Self::DENSE {
                if inverse.index_len
                    != target
                        .len
                        .checked_add(1)
                        .ok_or(ObservationalError::CompiledShape)?
                {
                    return Err(ObservationalError::CompiledShape);
                }
                let end = inverse
                    .index_start
                    .checked_add(inverse.index_len)
                    .ok_or(ObservationalError::CompiledShape)?;
                let offsets = self
                    .offsets
                    .get(inverse.index_start as usize..end as usize)
                    .ok_or(ObservationalError::CompiledShape)?;
                for (local, pair) in offsets.windows(2).enumerate() {
                    let predecessors = self
                        .sources
                        .get(pair[0] as usize..pair[1] as usize)
                        .ok_or(ObservationalError::CompiledShape)?;
                    check(target.start + local as u32, predecessors)?;
                }
            } else if inverse.mode == Self::SPARSE {
                let target_end = inverse
                    .index_start
                    .checked_add(inverse.index_len)
                    .ok_or(ObservationalError::CompiledShape)?;
                let targets = self
                    .targets
                    .get(inverse.index_start as usize..target_end as usize)
                    .ok_or(ObservationalError::CompiledShape)?;
                let mut previous_target = None;
                for entry in targets {
                    if !target.contains(entry.target_state)
                        || previous_target.is_some_and(|previous| previous >= entry.target_state)
                    {
                        return Err(ObservationalError::CompiledShape);
                    }
                    previous_target = Some(entry.target_state);
                    let end = entry
                        .source_start
                        .checked_add(entry.source_len)
                        .ok_or(ObservationalError::CompiledShape)?;
                    let predecessors = self
                        .sources
                        .get(entry.source_start as usize..end as usize)
                        .ok_or(ObservationalError::CompiledShape)?;
                    check(entry.target_state, predecessors)?;
                }
            } else {
                return Err(ObservationalError::CompiledShape);
            }
            if seen[..source.len as usize].contains(&0) {
                return Err(ObservationalError::CompiledShape);
            }
        }
        Ok(())
    }
}

impl TargetGeneratorDirectory {
    const SORT_SCAN_MAX_GENERATORS: u32 = 8;

    fn new(
        presentation: &FinitePresentation,
        inverse: &InverseIndex,
        refinement: Option<&RefinementGenerators>,
    ) -> Result<Self, ObservationalError> {
        let (ranges, generators) = if let Some(directory) = refinement {
            let mut counts = vec![0_u32; presentation.sorts.len()];
            for &generator in directory.ids.iter() {
                let target = presentation.generators[generator as usize].target_sort as usize;
                counts[target] = counts[target]
                    .checked_add(1)
                    .ok_or(ObservationalError::Overflow)?;
            }
            let mut ranges = Vec::with_capacity(presentation.sorts.len());
            let mut total = 0_u32;
            for &count in &counts {
                ranges.push(SortRange {
                    start: total,
                    len: count,
                });
                total = total
                    .checked_add(count)
                    .ok_or(ObservationalError::Overflow)?;
            }
            let mut cursors = ranges.iter().map(|range| range.start).collect::<Vec<_>>();
            let mut generators = vec![0_u32; total as usize];
            for &generator in directory.ids.iter() {
                let target = presentation.generators[generator as usize].target_sort as usize;
                generators[cursors[target] as usize] = generator;
                cursors[target] += 1;
            }
            (ranges.into_boxed_slice(), generators.into_boxed_slice())
        } else {
            index_generators_by_sort(presentation.sorts.len(), &presentation.generators, true)?
        };
        if ranges
            .iter()
            .all(|range| range.len <= Self::SORT_SCAN_MAX_GENERATORS)
        {
            return Ok(Self::BySort { ranges, generators });
        }

        let mut counts = vec![0_u32; presentation.state_count()];
        for (generator, record) in inverse.records.iter().copied().enumerate() {
            if record.mode == InverseIndex::INACTIVE {
                continue;
            }
            if record.mode == InverseIndex::DENSE {
                let generator_record = presentation.generators[generator];
                let target = presentation.sorts[generator_record.target_sort as usize];
                let start = record.index_start as usize;
                for local in 0..target.len as usize {
                    if inverse.offsets[start + local] != inverse.offsets[start + local + 1] {
                        counts[target.start as usize + local] = counts
                            [target.start as usize + local]
                            .checked_add(1)
                            .ok_or(ObservationalError::Overflow)?;
                    }
                }
            } else {
                let start = record.index_start as usize;
                let end = start + record.index_len as usize;
                for entry in &inverse.targets[start..end] {
                    counts[entry.target_state as usize] = counts[entry.target_state as usize]
                        .checked_add(1)
                        .ok_or(ObservationalError::Overflow)?;
                }
            }
        }

        let mut offsets = Vec::with_capacity(presentation.state_count().saturating_add(1));
        let mut total = 0_u32;
        for count in &mut counts {
            offsets.push(total);
            total = total
                .checked_add(*count)
                .ok_or(ObservationalError::Overflow)?;
            *count = offsets[offsets.len() - 1];
        }
        offsets.push(total);
        let mut generators = vec![0_u32; total as usize];
        for (generator, record) in inverse.records.iter().copied().enumerate() {
            if record.mode == InverseIndex::INACTIVE {
                continue;
            }
            if record.mode == InverseIndex::DENSE {
                let generator_record = presentation.generators[generator];
                let target = presentation.sorts[generator_record.target_sort as usize];
                let start = record.index_start as usize;
                for local in 0..target.len as usize {
                    if inverse.offsets[start + local] == inverse.offsets[start + local + 1] {
                        continue;
                    }
                    let cursor = &mut counts[target.start as usize + local];
                    generators[*cursor as usize] = generator as u32;
                    *cursor += 1;
                }
            } else {
                let start = record.index_start as usize;
                let end = start + record.index_len as usize;
                for entry in &inverse.targets[start..end] {
                    let cursor = &mut counts[entry.target_state as usize];
                    generators[*cursor as usize] = generator as u32;
                    *cursor += 1;
                }
            }
        }
        Ok(Self::ByState {
            offsets: offsets.into_boxed_slice(),
            generators: generators.into_boxed_slice(),
        })
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct SeparatorStreamMetrics {
    pub separators: usize,
    pub separator_steps: usize,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct WeightedGeneratorWord {
    pub cost: u64,
    pub generators: Box<[u32]>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct WeightedQuotientEdge {
    target: u32,
    generator: u32,
    cost: u64,
}

const _: () = assert!(std::mem::size_of::<WeightedQuotientEdge>() == 16);

/// A theorem-reduced weighted quotient graph reusable across output queries.
///
/// For each source class, generators with the same target class are
/// observationally interchangeable for every continuation. Only the cheapest
/// generator (then the least generator ID) is retained exactly.
#[derive(Clone, Debug)]
pub struct WeightedGeneratorPlan {
    class_outputs: Box<[u32]>,
    offsets: Box<[u32]>,
    edges: Box<[WeightedQuotientEdge]>,
    uncollapsed_edge_count: usize,
}

#[derive(Debug)]
pub struct WeightedGeneratorWorkspace {
    distances: Box<[u64]>,
    parent_classes: Box<[u32]>,
    parent_generators: Box<[u32]>,
    settled: Box<[u64]>,
    heap: IndexedMinHeap,
    generators: Vec<u32>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct WeightedGeneratorWordRef<'a> {
    pub cost: u64,
    pub generators: &'a [u32],
}

impl WeightedGeneratorPlan {
    pub fn class_count(&self) -> usize {
        self.class_outputs.len()
    }

    pub fn uncollapsed_edge_count(&self) -> usize {
        self.uncollapsed_edge_count
    }

    pub fn edge_count(&self) -> usize {
        self.edges.len()
    }

    pub fn workspace(&self) -> Result<WeightedGeneratorWorkspace, ObservationalError> {
        let class_count = self.class_outputs.len();
        Ok(WeightedGeneratorWorkspace {
            distances: vec![u64::MAX; class_count].into_boxed_slice(),
            parent_classes: vec![u32::MAX; class_count].into_boxed_slice(),
            parent_generators: vec![u32::MAX; class_count].into_boxed_slice(),
            settled: bitmap_storage(class_count)?.into_boxed_slice(),
            heap: IndexedMinHeap::new(class_count),
            generators: Vec::with_capacity(class_count),
        })
    }

    /// Find a minimum-cost generator word from `start_class` to any class
    /// exposing `target_output`. The query allocates fixed-size workspaces once
    /// and performs no allocation or growth in its edge-relaxation loop.
    pub fn shortest_word_to_output(
        &self,
        start_class: u32,
        target_output: u32,
    ) -> Result<Option<WeightedGeneratorWord>, ObservationalError> {
        let mut workspace = self.workspace()?;
        Ok(self
            .shortest_word_to_output_in(start_class, target_output, &mut workspace)?
            .map(|word| WeightedGeneratorWord {
                cost: word.cost,
                generators: word.generators.into(),
            }))
    }

    /// Workspace-reusing form of [`Self::shortest_word_to_output`]. There is
    /// no allocation or capacity growth after the workspace has been created.
    pub fn shortest_word_to_output_in<'a>(
        &self,
        start_class: u32,
        target_output: u32,
        workspace: &'a mut WeightedGeneratorWorkspace,
    ) -> Result<Option<WeightedGeneratorWordRef<'a>>, ObservationalError> {
        let class_count = self.class_outputs.len();
        if start_class as usize >= class_count
            || self.offsets.len() != class_count + 1
            || workspace.distances.len() != class_count
            || workspace.parent_classes.len() != class_count
            || workspace.parent_generators.len() != class_count
        {
            return Err(ObservationalError::CompiledShape);
        }
        workspace.distances.fill(u64::MAX);
        workspace.parent_classes.fill(u32::MAX);
        workspace.parent_generators.fill(u32::MAX);
        workspace.settled.fill(0);
        workspace.heap.clear();
        workspace.generators.clear();
        if self.class_outputs[start_class as usize] == target_output {
            return Ok(Some(WeightedGeneratorWordRef {
                cost: 0,
                generators: &workspace.generators,
            }));
        }

        workspace.distances[start_class as usize] = 0;
        workspace
            .heap
            .push_or_decrease(start_class, &workspace.distances)?;
        while let Some(class) = workspace.heap.pop_min(&workspace.distances) {
            if bitmap_contains(&workspace.settled, class as usize) {
                continue;
            }
            bitmap_insert(&mut workspace.settled, class as usize);
            if self.class_outputs[class as usize] == target_output {
                let mut cursor = class;
                while cursor != start_class {
                    if workspace.generators.len() == workspace.generators.capacity() {
                        return Err(ObservationalError::Overflow);
                    }
                    workspace
                        .generators
                        .push(workspace.parent_generators[cursor as usize]);
                    cursor = workspace.parent_classes[cursor as usize];
                }
                workspace.generators.reverse();
                return Ok(Some(WeightedGeneratorWordRef {
                    cost: workspace.distances[class as usize],
                    generators: &workspace.generators,
                }));
            }
            let start = self.offsets[class as usize] as usize;
            let end = self.offsets[class as usize + 1] as usize;
            let Some(outgoing) = self.edges.get(start..end) else {
                return Err(ObservationalError::CompiledShape);
            };
            for edge in outgoing {
                if bitmap_contains(&workspace.settled, edge.target as usize) {
                    continue;
                }
                let candidate = workspace.distances[class as usize]
                    .checked_add(edge.cost)
                    .ok_or(ObservationalError::Overflow)?;
                if candidate < workspace.distances[edge.target as usize] {
                    workspace.distances[edge.target as usize] = candidate;
                    workspace.parent_classes[edge.target as usize] = class;
                    workspace.parent_generators[edge.target as usize] = edge.generator;
                    workspace
                        .heap
                        .push_or_decrease(edge.target, &workspace.distances)?;
                }
            }
        }
        Ok(None)
    }
}

/// The unique finite orbit of an indefinitely repeated type-preserving layer.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct GeneratorOrbit {
    pub states: Box<[u32]>,
    pub cycle_start: u32,
}

impl GeneratorOrbit {
    pub fn prefix(&self) -> &[u32] {
        &self.states[..self.cycle_start as usize]
    }

    pub fn cycle(&self) -> &[u32] {
        &self.states[self.cycle_start as usize..]
    }
}

#[derive(Debug, PartialEq, Eq)]
pub enum SeparatorStreamError<E> {
    Compilation(ObservationalError),
    Sink(E),
}

#[derive(Debug, Error)]
pub enum SeparatorFileError {
    #[error(transparent)]
    Compilation(#[from] ObservationalError),
    #[error("separator stream I/O failed")]
    Io(#[from] std::io::Error),
    #[error("separator stream is malformed")]
    Format,
    #[error("streaming evidence requires a quotient-only compiled artifact")]
    Policy,
}

#[derive(Debug, Error)]
pub enum LayeredAuditError {
    #[error(transparent)]
    Compilation(#[from] ObservationalError),
    #[error("layered audit I/O failed")]
    Io(#[from] std::io::Error),
    #[error("layered audit is malformed")]
    Format,
}

const SEPARATOR_STREAM_MAGIC: &[u8; 8] = b"ERGSEP01";
const LAYERED_AUDIT_MAGIC: &[u8; 8] = b"ERGLAY01";

#[derive(Clone, Debug)]
pub struct CompiledObservation {
    class_ranges: Box<[SortRange]>,
    state_classes: Box<[u32]>,
    class_outputs: Box<[u32]>,
    class_representatives: Box<[u32]>,
    generator_records: Box<[GeneratorRecord]>,
    generator_transitions: Box<[u32]>,
    split_records: Box<[SplitRecord]>,
    multiway_records: Box<[MultiwayRecord]>,
    separators: Box<[SeparatorRecord]>,
    separator_paths: Box<[u32]>,
    certificate_policy: CertificatePolicy,
    metrics: CompilationMetrics,
}

/// Query artifact retaining quotient transitions, concrete class witnesses,
/// and only the explicitly selected concrete entry-state maps.
#[derive(Clone, Debug)]
pub struct FrozenObservation {
    class_ranges: Box<[SortRange]>,
    entry_ranges: Box<[SortRange]>,
    entry_classes: Box<[u32]>,
    class_outputs: Box<[u32]>,
    class_representatives: Box<[u32]>,
    generator_records: Box<[GeneratorRecord]>,
    generator_transitions: Box<[u32]>,
    metrics: CompilationMetrics,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct FrozenObservationStorage {
    pub entry_states: usize,
    pub classes: usize,
    pub payload_bytes: usize,
}

impl FrozenObservation {
    pub fn entry_class(&self, sort: u32, local_state: u32) -> Option<u32> {
        let range = *self.entry_ranges.get(sort as usize)?;
        if local_state >= range.len {
            return None;
        }
        self.entry_classes
            .get((range.start + local_state) as usize)
            .copied()
    }

    pub fn output(&self, class: u32) -> Option<u32> {
        self.class_outputs.get(class as usize).copied()
    }

    pub fn representative(&self, class: u32) -> Option<u32> {
        self.class_representatives.get(class as usize).copied()
    }

    pub fn transition(&self, generator: u32, class: u32) -> Option<u32> {
        let record = *self.generator_records.get(generator as usize)?;
        let source = self.class_ranges[record.source_sort as usize];
        if !source.contains(class) {
            return None;
        }
        self.generator_transitions
            .get((record.transition_start + class - source.start) as usize)
            .copied()
    }

    pub fn metrics(&self) -> CompilationMetrics {
        self.metrics
    }

    pub fn storage(&self) -> FrozenObservationStorage {
        FrozenObservationStorage {
            entry_states: self.entry_classes.len(),
            classes: self.class_outputs.len(),
            payload_bytes: std::mem::size_of_val(&*self.class_ranges)
                + std::mem::size_of_val(&*self.entry_ranges)
                + std::mem::size_of_val(&*self.entry_classes)
                + std::mem::size_of_val(&*self.class_outputs)
                + std::mem::size_of_val(&*self.class_representatives)
                + std::mem::size_of_val(&*self.generator_records)
                + std::mem::size_of_val(&*self.generator_transitions),
        }
    }
}

impl CompiledObservation {
    /// Consume a verified compiler result and retain concrete-state lookup only
    /// for the selected entry sorts. Quotient witnesses remain global raw IDs.
    pub fn into_frozen(
        self,
        state_counts: &[u32],
        entry_sorts: &[u32],
    ) -> Result<FrozenObservation, ObservationalError> {
        if state_counts.len() != self.class_ranges.len() {
            return Err(ObservationalError::CompiledShape);
        }
        let mut raw_ranges = Vec::with_capacity(state_counts.len());
        let mut next = 0_u32;
        for &len in state_counts {
            raw_ranges.push(SortRange { start: next, len });
            next = next.checked_add(len).ok_or(ObservationalError::Overflow)?;
        }
        if next as usize != self.state_classes.len() {
            return Err(ObservationalError::CompiledShape);
        }
        let mut selected = vec![false; state_counts.len()];
        let mut retained = 0_usize;
        for &sort in entry_sorts {
            let Some(slot) = selected.get_mut(sort as usize) else {
                return Err(ObservationalError::CompiledShape);
            };
            if *slot {
                return Err(ObservationalError::CompiledShape);
            }
            *slot = true;
            retained = retained
                .checked_add(state_counts[sort as usize] as usize)
                .ok_or(ObservationalError::Overflow)?;
        }
        let mut entry_ranges = Vec::with_capacity(state_counts.len());
        let mut entry_classes = Vec::with_capacity(retained);
        for (sort, raw_range) in raw_ranges.into_iter().enumerate() {
            let start =
                u32::try_from(entry_classes.len()).map_err(|_| ObservationalError::Overflow)?;
            if selected[sort] {
                entry_classes.extend_from_slice(
                    &self.state_classes[raw_range.start as usize..raw_range.end() as usize],
                );
                entry_ranges.push(SortRange {
                    start,
                    len: raw_range.len,
                });
            } else {
                entry_ranges.push(SortRange { start, len: 0 });
            }
        }
        Ok(FrozenObservation {
            class_ranges: self.class_ranges,
            entry_ranges: entry_ranges.into_boxed_slice(),
            entry_classes: entry_classes.into_boxed_slice(),
            class_outputs: self.class_outputs,
            class_representatives: self.class_representatives,
            generator_records: self.generator_records,
            generator_transitions: self.generator_transitions,
            metrics: self.metrics,
        })
    }
}

/// Generator metadata for an acyclic typed presentation supplied by oracles.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct LayeredGeneratorSpec {
    pub source_sort: u32,
    pub target_sort: u32,
}

/// Compile the exact minimal quotient of a finite layered deterministic
/// system without materializing its observation or transition tables.
///
/// `observation(sort, state)` and `transition(generator, state)` use local
/// state IDs. Every generator must point to a strictly later sort. Reverse
/// induction interns the complete future-response signature at each state;
/// signature words and sort workspaces are allocated once, outside hot loops.
pub fn compile_layered_observational<O, T>(
    state_counts: &[u32],
    generators: &[LayeredGeneratorSpec],
    mut observation: O,
    mut transition: T,
) -> Result<CompiledObservation, ObservationalError>
where
    O: FnMut(u32, u32) -> u32,
    T: FnMut(u32, u32) -> u32,
{
    if state_counts.is_empty() {
        return Err(ObservationalError::NoSorts);
    }
    let mut raw_ranges = Vec::with_capacity(state_counts.len());
    let mut total_states = 0_u32;
    for &len in state_counts {
        raw_ranges.push(SortRange {
            start: total_states,
            len,
        });
        total_states = total_states
            .checked_add(len)
            .ok_or(ObservationalError::Overflow)?;
    }
    let mut outgoing_counts = vec![0_usize; state_counts.len()];
    for (generator, spec) in generators.iter().enumerate() {
        let source = spec.source_sort as usize;
        let target = spec.target_sort as usize;
        if source >= state_counts.len() || target >= state_counts.len() {
            return Err(ObservationalError::GeneratorSort { generator });
        }
        if source >= target {
            return Err(ObservationalError::LayeredGeneratorOrder { generator });
        }
        outgoing_counts[source] = outgoing_counts[source]
            .checked_add(1)
            .ok_or(ObservationalError::Overflow)?;
    }
    let mut outgoing = outgoing_counts
        .into_iter()
        .map(Vec::with_capacity)
        .collect::<Vec<Vec<u32>>>();
    for (generator, spec) in generators.iter().enumerate() {
        let source = spec.source_sort as usize;
        outgoing[source].push(u32::try_from(generator).map_err(|_| ObservationalError::Overflow)?);
    }

    let mut local_state_classes = vec![0_u32; total_states as usize];
    let mut class_counts = vec![0_u32; state_counts.len()];
    let mut local_class_outputs = vec![Vec::<u32>::new(); state_counts.len()];
    let mut local_class_representatives = vec![Vec::<u32>::new(); state_counts.len()];
    for sort in (0..state_counts.len()).rev() {
        let count = state_counts[sort] as usize;
        let width = outgoing[sort]
            .len()
            .checked_add(1)
            .ok_or(ObservationalError::Overflow)?;
        let mut signatures = vec![
            0_u32;
            count
                .checked_mul(width)
                .ok_or(ObservationalError::Overflow)?
        ];
        for state in 0..count {
            let signature = &mut signatures[state * width..(state + 1) * width];
            signature[0] = observation(sort as u32, state as u32);
            for (slot, &generator) in outgoing[sort].iter().enumerate() {
                let target_sort = generators[generator as usize].target_sort as usize;
                let target_state = transition(generator, state as u32);
                let target_range = raw_ranges[target_sort];
                if target_state >= target_range.len {
                    return Err(ObservationalError::TransitionTarget {
                        generator: generator as usize,
                        transition: state,
                    });
                }
                signature[slot + 1] =
                    local_state_classes[(target_range.start + target_state) as usize];
            }
        }
        let range = raw_ranges[sort];
        let lookup_capacity = if count == 0 {
            1
        } else {
            count
                .checked_mul(4)
                .ok_or(ObservationalError::Overflow)?
                .div_ceil(3)
                .checked_next_power_of_two()
                .ok_or(ObservationalError::Overflow)?
        };
        let mut lookup_hashes = vec![0_u64; lookup_capacity];
        let mut lookup_representatives = vec![u32::MAX; lookup_capacity];
        let lookup_mask = lookup_capacity - 1;
        let mut next_class = 0_u32;
        for state in 0..count as u32 {
            let start = state as usize * width;
            let signature = &signatures[start..start + width];
            let hash = layered_signature_hash(signature);
            let mut slot = hash as usize & lookup_mask;
            let class = loop {
                let representative = lookup_representatives[slot];
                if representative == u32::MAX {
                    lookup_hashes[slot] = hash;
                    lookup_representatives[slot] = state;
                    let class = next_class;
                    next_class = next_class
                        .checked_add(1)
                        .ok_or(ObservationalError::Overflow)?;
                    break class;
                }
                let representative_start = representative as usize * width;
                if lookup_hashes[slot] == hash
                    && signatures[representative_start..representative_start + width] == *signature
                {
                    break local_state_classes[(range.start + representative) as usize];
                }
                slot = (slot + 1) & lookup_mask;
            };
            local_state_classes[(range.start + state) as usize] = class;
        }
        local_class_outputs[sort] = Vec::with_capacity(next_class as usize);
        local_class_representatives[sort] = Vec::with_capacity(next_class as usize);
        for state in 0..count as u32 {
            let class = local_state_classes[(range.start + state) as usize];
            if class as usize == local_class_outputs[sort].len() {
                local_class_outputs[sort].push(signatures[state as usize * width]);
                local_class_representatives[sort].push(state);
            }
        }
        debug_assert_eq!(local_class_outputs[sort].len(), next_class as usize);
        class_counts[sort] = next_class;
    }

    fn layered_signature_hash(signature: &[u32]) -> u64 {
        let mut hash = 0x9e37_79b9_7f4a_7c15_u64;
        for &word in signature {
            hash ^= u64::from(word).wrapping_add(0x9e37_79b9);
            hash = hash.rotate_left(27).wrapping_mul(0x94d0_49bb_1331_11eb);
        }
        hash ^ (hash >> 31)
    }

    let mut class_ranges = Vec::with_capacity(state_counts.len());
    let mut total_classes = 0_u32;
    for &len in &class_counts {
        class_ranges.push(SortRange {
            start: total_classes,
            len,
        });
        total_classes = total_classes
            .checked_add(len)
            .ok_or(ObservationalError::Overflow)?;
    }
    for (sort, raw_range) in raw_ranges.iter().copied().enumerate() {
        let class_start = class_ranges[sort].start;
        for class in &mut local_state_classes[raw_range.start as usize..raw_range.end() as usize] {
            *class = class
                .checked_add(class_start)
                .ok_or(ObservationalError::Overflow)?;
        }
    }
    let mut class_outputs = Vec::with_capacity(total_classes as usize);
    let mut class_representatives = Vec::with_capacity(total_classes as usize);
    for (sort, outputs) in local_class_outputs.into_iter().enumerate() {
        class_outputs.extend(outputs);
        let raw_start = raw_ranges[sort].start;
        class_representatives.extend(
            local_class_representatives[sort]
                .iter()
                .map(|&state| raw_start + state),
        );
    }

    let mut generator_records = Vec::with_capacity(generators.len());
    let transition_count = generators.iter().try_fold(0_usize, |count, spec| {
        count
            .checked_add(class_counts[spec.source_sort as usize] as usize)
            .ok_or(ObservationalError::Overflow)
    })?;
    let mut generator_transitions = Vec::with_capacity(transition_count);
    for (generator, spec) in generators.iter().enumerate() {
        let source_sort = spec.source_sort as usize;
        let target_sort = spec.target_sort as usize;
        let transition_start =
            u32::try_from(generator_transitions.len()).map_err(|_| ObservationalError::Overflow)?;
        for &representative in &local_class_representatives[source_sort] {
            let target_state = transition(generator as u32, representative);
            let target_range = raw_ranges[target_sort];
            if target_state >= target_range.len {
                return Err(ObservationalError::TransitionTarget {
                    generator,
                    transition: representative as usize,
                });
            }
            generator_transitions
                .push(local_state_classes[(target_range.start + target_state) as usize]);
        }
        generator_records.push(GeneratorRecord {
            source_sort: spec.source_sort,
            target_sort: spec.target_sort,
            transition_start,
            transition_len: class_counts[source_sort],
        });
    }
    debug_assert_eq!(generator_transitions.len(), transition_count);

    Ok(CompiledObservation {
        class_ranges: class_ranges.into_boxed_slice(),
        state_classes: local_state_classes.into_boxed_slice(),
        class_outputs: class_outputs.into_boxed_slice(),
        class_representatives: class_representatives.into_boxed_slice(),
        generator_records: generator_records.into_boxed_slice(),
        generator_transitions: generator_transitions.into_boxed_slice(),
        split_records: Box::default(),
        multiway_records: Box::default(),
        separators: Box::default(),
        separator_paths: Box::default(),
        certificate_policy: CertificatePolicy::QuotientOnly,
        metrics: CompilationMetrics {
            states: total_states as usize,
            classes: total_classes as usize,
            generators: generators.len(),
            refinement_rounds: state_counts.len(),
            refinement_splits: 0,
            separators: 0,
            separator_steps: 0,
        },
    })
}

/// Independently verify the reverse-induction theorem for a layered artifact
/// directly against observation and transition oracles.
pub fn verify_layered_observational<O, T>(
    state_counts: &[u32],
    generators: &[LayeredGeneratorSpec],
    mut observation: O,
    mut transition: T,
    compiled: &CompiledObservation,
) -> Result<(), ObservationalError>
where
    O: FnMut(u32, u32) -> u32,
    T: FnMut(u32, u32) -> u32,
{
    if state_counts.is_empty() {
        return Err(ObservationalError::NoSorts);
    }
    if compiled.certificate_policy != CertificatePolicy::QuotientOnly
        || !compiled.split_records.is_empty()
        || !compiled.multiway_records.is_empty()
        || !compiled.separators.is_empty()
        || !compiled.separator_paths.is_empty()
        || compiled.class_ranges.len() != state_counts.len()
        || compiled.generator_records.len() != generators.len()
        || compiled.class_outputs.len() != compiled.class_representatives.len()
    {
        return Err(ObservationalError::CompiledShape);
    }
    let mut raw_ranges = Vec::with_capacity(state_counts.len());
    let mut total_states = 0_u32;
    for &len in state_counts {
        raw_ranges.push(SortRange {
            start: total_states,
            len,
        });
        total_states = total_states
            .checked_add(len)
            .ok_or(ObservationalError::Overflow)?;
    }
    if compiled.state_classes.len() != total_states as usize {
        return Err(ObservationalError::CompiledShape);
    }
    let mut total_classes = 0_u32;
    for range in &compiled.class_ranges {
        if range.start != total_classes {
            return Err(ObservationalError::CompiledShape);
        }
        total_classes = range
            .start
            .checked_add(range.len)
            .ok_or(ObservationalError::Overflow)?;
    }
    if total_classes as usize != compiled.class_outputs.len() {
        return Err(ObservationalError::CompiledShape);
    }

    let mut outgoing = vec![Vec::<u32>::new(); state_counts.len()];
    for (generator, spec) in generators.iter().enumerate() {
        let source = spec.source_sort as usize;
        let target = spec.target_sort as usize;
        if source >= state_counts.len() || target >= state_counts.len() {
            return Err(ObservationalError::GeneratorSort { generator });
        }
        if source >= target {
            return Err(ObservationalError::LayeredGeneratorOrder { generator });
        }
        outgoing[source].push(u32::try_from(generator).map_err(|_| ObservationalError::Overflow)?);
    }

    for sort in (0..state_counts.len()).rev() {
        let raw_range = raw_ranges[sort];
        let class_range = compiled.class_ranges[sort];
        let width = outgoing[sort]
            .len()
            .checked_add(1)
            .ok_or(ObservationalError::Overflow)?;
        let signature_words = (class_range.len as usize)
            .checked_mul(width)
            .ok_or(ObservationalError::Overflow)?;
        let mut signatures = vec![u32::MAX; signature_words];
        let mut seen = vec![false; class_range.len as usize];
        let mut expected_representatives = vec![u32::MAX; class_range.len as usize];
        let mut scratch = vec![0_u32; width];
        for state in 0..raw_range.len {
            let raw_state = raw_range.start + state;
            let class = compiled.state_classes[raw_state as usize];
            if !class_range.contains(class) {
                return Err(ObservationalError::Partition);
            }
            scratch[0] = observation(sort as u32, state);
            for (slot, &generator) in outgoing[sort].iter().enumerate() {
                let target_sort = generators[generator as usize].target_sort as usize;
                let target_state = transition(generator, state);
                let target_range = raw_ranges[target_sort];
                if target_state >= target_range.len {
                    return Err(ObservationalError::TransitionTarget {
                        generator: generator as usize,
                        transition: state as usize,
                    });
                }
                let target_class =
                    compiled.state_classes[(target_range.start + target_state) as usize];
                if !compiled.class_ranges[target_sort].contains(target_class) {
                    return Err(ObservationalError::Partition);
                }
                scratch[slot + 1] = target_class;
            }
            let local_class = (class - class_range.start) as usize;
            let stored = &mut signatures[local_class * width..(local_class + 1) * width];
            if seen[local_class] {
                if stored != scratch {
                    return Err(ObservationalError::Partition);
                }
            } else {
                stored.copy_from_slice(&scratch);
                seen[local_class] = true;
                expected_representatives[local_class] = raw_state;
            }
        }
        if seen.iter().any(|&is_seen| !is_seen) {
            return Err(ObservationalError::Partition);
        }
        let mut order = (0..class_range.len).collect::<Vec<_>>();
        order.sort_unstable_by(|&left, &right| {
            let left = left as usize * width;
            let right = right as usize * width;
            signatures[left..left + width].cmp(&signatures[right..right + width])
        });
        for pair in order.windows(2) {
            let left = pair[0] as usize * width;
            let right = pair[1] as usize * width;
            if signatures[left..left + width] == signatures[right..right + width] {
                return Err(ObservationalError::Partition);
            }
        }
        for local_class in 0..class_range.len as usize {
            let class = class_range.start as usize + local_class;
            if compiled.class_outputs[class] != signatures[local_class * width] {
                return Err(ObservationalError::ObservationMismatch {
                    class: class as u32,
                });
            }
            if compiled.class_representatives[class] != expected_representatives[local_class] {
                return Err(ObservationalError::Partition);
            }
        }
    }

    for (generator, spec) in generators.iter().enumerate() {
        let record = compiled.generator_records[generator];
        let source_range = compiled.class_ranges[spec.source_sort as usize];
        if record.source_sort != spec.source_sort
            || record.target_sort != spec.target_sort
            || record.transition_len != source_range.len
        {
            return Err(ObservationalError::CompiledShape);
        }
        for class in source_range.start..source_range.end() {
            let representative = compiled.class_representatives[class as usize];
            let source_state = representative - raw_ranges[spec.source_sort as usize].start;
            let target_state = transition(generator as u32, source_state);
            let target_range = raw_ranges[spec.target_sort as usize];
            if target_state >= target_range.len {
                return Err(ObservationalError::TransitionTarget {
                    generator,
                    transition: source_state as usize,
                });
            }
            let expected = compiled.state_classes[(target_range.start + target_state) as usize];
            if compiled.transition(generator as u32, class) != Some(expected) {
                return Err(ObservationalError::QuotientTransition {
                    generator: generator as u32,
                    class,
                });
            }
        }
    }
    if compiled.metrics.states != total_states as usize
        || compiled.metrics.classes != total_classes as usize
        || compiled.metrics.generators != generators.len()
    {
        return Err(ObservationalError::CompiledShape);
    }
    Ok(())
}

fn write_var_u32<W: Write>(writer: &mut W, mut value: u32) -> std::io::Result<()> {
    let mut bytes = [0_u8; 5];
    let mut len = 0;
    loop {
        let mut byte = (value & 0x7f) as u8;
        value >>= 7;
        if value != 0 {
            byte |= 0x80;
        }
        bytes[len] = byte;
        len += 1;
        if value == 0 {
            return writer.write_all(&bytes[..len]);
        }
    }
}

fn read_var_u32<R: Read>(reader: &mut R) -> Result<u32, LayeredAuditError> {
    let mut value = 0_u32;
    for shift in (0..35).step_by(7) {
        let mut byte = [0_u8; 1];
        reader.read_exact(&mut byte)?;
        let payload = u32::from(byte[0] & 0x7f);
        if shift == 28 && payload > 0x0f {
            return Err(LayeredAuditError::Format);
        }
        value |= payload << shift;
        if byte[0] & 0x80 == 0 {
            return Ok(value);
        }
    }
    Err(LayeredAuditError::Format)
}

fn quotient_fingerprint(
    class_ranges: &[SortRange],
    class_outputs: &[u32],
    class_representatives: &[u32],
    generator_records: &[GeneratorRecord],
    generator_transitions: &[u32],
) -> [u64; 2] {
    let mut hash = [0xcbf2_9ce4_8422_2325_u64, 0x6c62_272e_07bb_0142_u64];
    fingerprint_word(&mut hash, class_ranges.len() as u32);
    for range in class_ranges {
        fingerprint_word(&mut hash, range.start);
        fingerprint_word(&mut hash, range.len);
    }
    fingerprint_word(&mut hash, class_outputs.len() as u32);
    for &word in class_outputs {
        fingerprint_word(&mut hash, word);
    }
    for &word in class_representatives {
        fingerprint_word(&mut hash, word);
    }
    fingerprint_word(&mut hash, generator_records.len() as u32);
    for record in generator_records {
        fingerprint_word(&mut hash, record.source_sort);
        fingerprint_word(&mut hash, record.target_sort);
        fingerprint_word(&mut hash, record.transition_start);
        fingerprint_word(&mut hash, record.transition_len);
    }
    fingerprint_word(&mut hash, generator_transitions.len() as u32);
    for &word in generator_transitions {
        fingerprint_word(&mut hash, word);
    }
    hash
}

/// Stream a compact replay sidecar after independently checking the source
/// oracles. The writer sees only bounded stack buffers; evidence size does not
/// contribute to compiler peak memory.
pub fn write_layered_audit<W, O, T>(
    state_counts: &[u32],
    generators: &[LayeredGeneratorSpec],
    mut observation: O,
    mut transition: T,
    compiled: &CompiledObservation,
    writer: &mut W,
) -> Result<(), LayeredAuditError>
where
    W: Write,
    O: FnMut(u32, u32) -> u32 + Copy,
    T: FnMut(u32, u32) -> u32 + Copy,
{
    verify_layered_observational(state_counts, generators, observation, transition, compiled)?;
    writer.write_all(LAYERED_AUDIT_MAGIC)?;
    write_var_u32(
        writer,
        u32::try_from(state_counts.len()).map_err(|_| ObservationalError::Overflow)?,
    )?;
    write_var_u32(
        writer,
        u32::try_from(generators.len()).map_err(|_| ObservationalError::Overflow)?,
    )?;
    for &count in state_counts {
        write_var_u32(writer, count)?;
    }
    for spec in generators {
        write_var_u32(writer, spec.source_sort)?;
        write_var_u32(writer, spec.target_sort)?;
    }
    let fingerprint = quotient_fingerprint(
        &compiled.class_ranges,
        &compiled.class_outputs,
        &compiled.class_representatives,
        &compiled.generator_records,
        &compiled.generator_transitions,
    );
    for word in fingerprint {
        writer.write_all(&word.to_le_bytes())?;
    }
    let mut raw_start = 0_u32;
    for (sort, &count) in state_counts.iter().enumerate() {
        let class_start = compiled.class_ranges[sort].start;
        for state in 0..count {
            write_var_u32(
                writer,
                compiled.state_classes[(raw_start + state) as usize] - class_start,
            )?;
        }
        raw_start = raw_start
            .checked_add(count)
            .ok_or(ObservationalError::Overflow)?;
    }
    for (sort, &count) in state_counts.iter().enumerate() {
        for state in 0..count {
            write_var_u32(writer, observation(sort as u32, state))?;
            for (generator, spec) in generators.iter().enumerate() {
                if spec.source_sort == sort as u32 {
                    write_var_u32(writer, transition(generator as u32, state))?;
                }
            }
        }
    }
    Ok(())
}

/// Replay a streamed layered sidecar against a frozen artifact without
/// materializing the evidence. Only the compact state-class map and the
/// current stratum's class signatures are retained.
pub fn verify_frozen_layered_audit<R: Read>(
    frozen: &FrozenObservation,
    reader: &mut R,
) -> Result<(), LayeredAuditError> {
    let mut magic = [0_u8; 8];
    reader.read_exact(&mut magic)?;
    if &magic != LAYERED_AUDIT_MAGIC {
        return Err(LayeredAuditError::Format);
    }
    let sort_count = read_var_u32(reader)? as usize;
    let generator_count = read_var_u32(reader)? as usize;
    if sort_count != frozen.class_ranges.len()
        || sort_count != frozen.entry_ranges.len()
        || generator_count != frozen.generator_records.len()
    {
        return Err(LayeredAuditError::Format);
    }
    let mut state_counts = Vec::with_capacity(sort_count);
    let mut raw_ranges = Vec::with_capacity(sort_count);
    let mut total_states = 0_u32;
    for _ in 0..sort_count {
        let count = read_var_u32(reader)?;
        raw_ranges.push(SortRange {
            start: total_states,
            len: count,
        });
        total_states = total_states
            .checked_add(count)
            .ok_or(LayeredAuditError::Format)?;
        state_counts.push(count);
    }
    if total_states as usize != frozen.metrics.states {
        return Err(LayeredAuditError::Format);
    }
    let mut generators = Vec::with_capacity(generator_count);
    let mut outgoing = vec![Vec::<u32>::new(); sort_count];
    for generator in 0..generator_count {
        let spec = LayeredGeneratorSpec {
            source_sort: read_var_u32(reader)?,
            target_sort: read_var_u32(reader)?,
        };
        let source = spec.source_sort as usize;
        let target = spec.target_sort as usize;
        if source >= sort_count || target >= sort_count || source >= target {
            return Err(LayeredAuditError::Format);
        }
        let record = frozen.generator_records[generator];
        if record.source_sort != spec.source_sort || record.target_sort != spec.target_sort {
            return Err(LayeredAuditError::Format);
        }
        outgoing[source].push(u32::try_from(generator).map_err(|_| LayeredAuditError::Format)?);
        generators.push(spec);
    }
    let mut expected_fingerprint = [0_u64; 2];
    for word in &mut expected_fingerprint {
        let mut bytes = [0_u8; 8];
        reader.read_exact(&mut bytes)?;
        *word = u64::from_le_bytes(bytes);
    }
    let actual_fingerprint = quotient_fingerprint(
        &frozen.class_ranges,
        &frozen.class_outputs,
        &frozen.class_representatives,
        &frozen.generator_records,
        &frozen.generator_transitions,
    );
    if expected_fingerprint != actual_fingerprint {
        return Err(LayeredAuditError::Format);
    }

    let mut state_classes = Vec::with_capacity(total_states as usize);
    for (sort, &count) in state_counts.iter().enumerate() {
        let class_range = frozen.class_ranges[sort];
        for _ in 0..count {
            let local_class = read_var_u32(reader)?;
            if local_class >= class_range.len {
                return Err(LayeredAuditError::Format);
            }
            state_classes.push(class_range.start + local_class);
        }
        let entry_range = frozen.entry_ranges[sort];
        if entry_range.len != 0 {
            if entry_range.len != count {
                return Err(LayeredAuditError::Format);
            }
            let raw_range = raw_ranges[sort];
            let retained =
                &frozen.entry_classes[entry_range.start as usize..entry_range.end() as usize];
            if retained != &state_classes[raw_range.start as usize..raw_range.end() as usize] {
                return Err(LayeredAuditError::Format);
            }
        }
    }

    for sort in 0..sort_count {
        let raw_range = raw_ranges[sort];
        let class_range = frozen.class_ranges[sort];
        let width = outgoing[sort]
            .len()
            .checked_add(1)
            .ok_or(LayeredAuditError::Format)?;
        let signature_words = (class_range.len as usize)
            .checked_mul(width)
            .ok_or(LayeredAuditError::Format)?;
        let mut signatures = vec![u32::MAX; signature_words];
        let mut seen = vec![false; class_range.len as usize];
        let mut representatives = vec![u32::MAX; class_range.len as usize];
        let mut scratch = vec![0_u32; width];
        for state in 0..raw_range.len {
            scratch[0] = read_var_u32(reader)?;
            for (slot, &generator) in outgoing[sort].iter().enumerate() {
                let target_sort = generators[generator as usize].target_sort as usize;
                let target_state = read_var_u32(reader)?;
                let target_range = raw_ranges[target_sort];
                if target_state >= target_range.len {
                    return Err(LayeredAuditError::Format);
                }
                scratch[slot + 1] = state_classes[(target_range.start + target_state) as usize];
            }
            let raw_state = raw_range.start + state;
            let class = state_classes[raw_state as usize];
            let local_class = (class - class_range.start) as usize;
            let stored = &mut signatures[local_class * width..(local_class + 1) * width];
            if seen[local_class] {
                if stored != scratch {
                    return Err(LayeredAuditError::Format);
                }
            } else {
                stored.copy_from_slice(&scratch);
                seen[local_class] = true;
                representatives[local_class] = raw_state;
            }
        }
        if seen.iter().any(|&is_seen| !is_seen) {
            return Err(LayeredAuditError::Format);
        }
        let mut order = (0..class_range.len).collect::<Vec<_>>();
        order.sort_unstable_by(|&left, &right| {
            let left = left as usize * width;
            let right = right as usize * width;
            signatures[left..left + width].cmp(&signatures[right..right + width])
        });
        for pair in order.windows(2) {
            let left = pair[0] as usize * width;
            let right = pair[1] as usize * width;
            if signatures[left..left + width] == signatures[right..right + width] {
                return Err(LayeredAuditError::Format);
            }
        }
        for local_class in 0..class_range.len as usize {
            let class = class_range.start + local_class as u32;
            if frozen.class_outputs[class as usize] != signatures[local_class * width]
                || frozen.class_representatives[class as usize] != representatives[local_class]
            {
                return Err(LayeredAuditError::Format);
            }
            for (slot, &generator) in outgoing[sort].iter().enumerate() {
                if frozen.transition(generator, class)
                    != Some(signatures[local_class * width + slot + 1])
                {
                    return Err(LayeredAuditError::Format);
                }
            }
        }
    }
    let mut trailing = [0_u8; 1];
    if reader.read(&mut trailing)? != 0 {
        return Err(LayeredAuditError::Format);
    }
    if frozen.metrics.classes != frozen.class_outputs.len()
        || frozen.metrics.generators != generator_count
    {
        return Err(LayeredAuditError::Format);
    }
    Ok(())
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

    pub fn certificate_policy(&self) -> CertificatePolicy {
        self.certificate_policy
    }

    pub fn split_records(&self) -> &[SplitRecord] {
        &self.split_records
    }

    pub fn multiway_records(&self) -> &[MultiwayRecord] {
        &self.multiway_records
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
                + std::mem::size_of_val(&*self.separator_paths)
                + std::mem::size_of_val(&*self.split_records)
                + std::mem::size_of_val(&*self.multiway_records),
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

    /// Compile a reusable weighted quotient graph, exactly removing parallel
    /// generator edges whose future behavior is identical.
    pub fn compile_weighted_generator_plan(
        &self,
        generator_costs: &[u64],
    ) -> Result<WeightedGeneratorPlan, ObservationalError> {
        if generator_costs.len() != self.generator_records.len() {
            return Err(ObservationalError::CompiledShape);
        }
        let class_count = self.class_outputs.len();
        let (generator_ranges, generator_ids) =
            index_generators_by_sort(self.class_ranges.len(), &self.generator_records, false)?;
        let maximum_out_degree = generator_ranges
            .iter()
            .map(|range| range.len as usize)
            .max()
            .unwrap_or(0);
        let uncollapsed_edge_count =
            self.generator_records
                .iter()
                .try_fold(0_usize, |total, generator| {
                    total
                        .checked_add(generator.transition_len as usize)
                        .ok_or(ObservationalError::Overflow)
                })?;
        let mut offsets = Vec::with_capacity(class_count + 1);
        let mut edges = Vec::with_capacity(uncollapsed_edge_count);
        let mut stamps = vec![u32::MAX; class_count];
        let mut best_costs = vec![u64::MAX; class_count];
        let mut best_generators = vec![u32::MAX; class_count];
        let mut touched = Vec::with_capacity(maximum_out_degree);
        offsets.push(0_u32);

        for class_index in 0..class_count {
            let class = u32::try_from(class_index).map_err(|_| ObservationalError::Overflow)?;
            let sort = self
                .class_ranges
                .partition_point(|range| range.end() <= class);
            let Some(range) = self.class_ranges.get(sort).copied() else {
                return Err(ObservationalError::CompiledShape);
            };
            if !range.contains(class) {
                return Err(ObservationalError::CompiledShape);
            }
            touched.clear();
            let generators = generator_ranges[sort];
            for &generator in &generator_ids[generators.start as usize..generators.end() as usize] {
                let target = self
                    .transition(generator, class)
                    .ok_or(ObservationalError::CompiledShape)?;
                let target_index = target as usize;
                let cost = generator_costs[generator as usize];
                if stamps[target_index] != class {
                    if touched.len() == touched.capacity() {
                        return Err(ObservationalError::Overflow);
                    }
                    stamps[target_index] = class;
                    best_costs[target_index] = cost;
                    best_generators[target_index] = generator;
                    touched.push(target);
                } else if (cost, generator)
                    < (best_costs[target_index], best_generators[target_index])
                {
                    best_costs[target_index] = cost;
                    best_generators[target_index] = generator;
                }
            }
            touched.sort_unstable();
            for &target in &touched {
                if edges.len() == edges.capacity() {
                    return Err(ObservationalError::Overflow);
                }
                edges.push(WeightedQuotientEdge {
                    target,
                    generator: best_generators[target as usize],
                    cost: best_costs[target as usize],
                });
            }
            offsets.push(u32::try_from(edges.len()).map_err(|_| ObservationalError::Overflow)?);
        }
        Ok(WeightedGeneratorPlan {
            class_outputs: self.class_outputs.clone(),
            offsets: offsets.into_boxed_slice(),
            edges: edges.into_boxed_slice(),
            uncollapsed_edge_count,
        })
    }

    /// Compute the exact preperiod and period of a repeated type-preserving
    /// generator. The transition loop is iterative and allocation-free.
    pub fn repeated_generator_orbit(
        &self,
        start_class: u32,
        generator: u32,
    ) -> Result<GeneratorOrbit, ObservationalError> {
        let Some(record) = self.generator_records.get(generator as usize).copied() else {
            return Err(ObservationalError::UnknownGenerator { generator });
        };
        if record.source_sort != record.target_sort {
            return Err(ObservationalError::GeneratorNotEndomorphism { generator });
        }
        let Some(range) = self.class_ranges.get(record.source_sort as usize).copied() else {
            return Err(ObservationalError::CompiledShape);
        };
        if !range.contains(start_class) {
            return Err(ObservationalError::CompiledShape);
        }

        let mut first_seen = vec![u32::MAX; range.len as usize];
        let mut states = Vec::with_capacity(range.len as usize);
        let mut current = start_class;
        loop {
            if !range.contains(current) {
                return Err(ObservationalError::CompiledShape);
            }
            let local = (current - range.start) as usize;
            let seen = first_seen[local];
            if seen != u32::MAX {
                return Ok(GeneratorOrbit {
                    states: states.into_boxed_slice(),
                    cycle_start: seen,
                });
            }
            first_seen[local] =
                u32::try_from(states.len()).map_err(|_| ObservationalError::Overflow)?;
            states.push(current);
            current = self
                .transition(generator, current)
                .ok_or(ObservationalError::CompiledShape)?;
        }
    }

    /// Return a shortest typed generator word from `start_class` to
    /// `target_class`, together with its concrete generator IDs.
    pub fn shortest_generator_word(
        &self,
        start_class: u32,
        target_class: u32,
    ) -> Result<Option<Box<[u32]>>, ObservationalError> {
        let class_count = self.class_outputs.len();
        if start_class as usize >= class_count || target_class as usize >= class_count {
            return Err(ObservationalError::CompiledShape);
        }
        if start_class == target_class {
            return Ok(Some(Box::default()));
        }
        let (generator_ranges, generator_ids) =
            index_generators_by_sort(self.class_ranges.len(), &self.generator_records, false)?;
        let mut parent_classes = vec![u32::MAX; class_count];
        let mut parent_generators = vec![u32::MAX; class_count];
        let mut queue = VecDeque::with_capacity(class_count);
        parent_classes[start_class as usize] = start_class;
        queue.push_back(start_class);
        while let Some(class) = queue.pop_front() {
            let sort = self
                .class_ranges
                .partition_point(|range| range.end() <= class);
            let Some(range) = self.class_ranges.get(sort).copied() else {
                return Err(ObservationalError::CompiledShape);
            };
            if !range.contains(class) {
                return Err(ObservationalError::CompiledShape);
            }
            let generators = generator_ranges[sort];
            for &generator in &generator_ids[generators.start as usize..generators.end() as usize] {
                let next = self
                    .transition(generator, class)
                    .ok_or(ObservationalError::CompiledShape)?;
                if parent_classes[next as usize] != u32::MAX {
                    continue;
                }
                parent_classes[next as usize] = class;
                parent_generators[next as usize] = generator;
                if next == target_class {
                    let mut word = Vec::new();
                    let mut cursor = target_class;
                    while cursor != start_class {
                        word.push(parent_generators[cursor as usize]);
                        cursor = parent_classes[cursor as usize];
                    }
                    word.reverse();
                    return Ok(Some(word.into_boxed_slice()));
                }
                queue.push_back(next);
            }
        }
        Ok(None)
    }

    /// Return a minimum-cost typed generator word for nonnegative generator
    /// costs.
    pub fn shortest_weighted_generator_word(
        &self,
        start_class: u32,
        target_class: u32,
        generator_costs: &[u64],
    ) -> Result<Option<WeightedGeneratorWord>, ObservationalError> {
        let class_count = self.class_outputs.len();
        if start_class as usize >= class_count
            || target_class as usize >= class_count
            || generator_costs.len() != self.generator_records.len()
        {
            return Err(ObservationalError::CompiledShape);
        }
        if start_class == target_class {
            return Ok(Some(WeightedGeneratorWord {
                cost: 0,
                generators: Box::default(),
            }));
        }
        let (generator_ranges, generator_ids) =
            index_generators_by_sort(self.class_ranges.len(), &self.generator_records, false)?;
        let mut distances = vec![u64::MAX; class_count];
        let mut parent_classes = vec![u32::MAX; class_count];
        let mut parent_generators = vec![u32::MAX; class_count];
        let mut settled = bitmap_storage(class_count)?;
        let mut heap = IndexedMinHeap::new(class_count);
        distances[start_class as usize] = 0;
        heap.push_or_decrease(start_class, &distances)?;
        while let Some(class) = heap.pop_min(&distances) {
            if bitmap_contains(&settled, class as usize) {
                continue;
            }
            bitmap_insert(&mut settled, class as usize);
            if class == target_class {
                let mut word = Vec::new();
                let mut cursor = target_class;
                while cursor != start_class {
                    word.push(parent_generators[cursor as usize]);
                    cursor = parent_classes[cursor as usize];
                }
                word.reverse();
                return Ok(Some(WeightedGeneratorWord {
                    cost: distances[class as usize],
                    generators: word.into_boxed_slice(),
                }));
            }
            let sort = self
                .class_ranges
                .partition_point(|range| range.end() <= class);
            let Some(range) = self.class_ranges.get(sort).copied() else {
                return Err(ObservationalError::CompiledShape);
            };
            if !range.contains(class) {
                return Err(ObservationalError::CompiledShape);
            }
            let generators = generator_ranges[sort];
            for &generator in &generator_ids[generators.start as usize..generators.end() as usize] {
                let next = self
                    .transition(generator, class)
                    .ok_or(ObservationalError::CompiledShape)?;
                if bitmap_contains(&settled, next as usize) {
                    continue;
                }
                let candidate = distances[class as usize]
                    .checked_add(generator_costs[generator as usize])
                    .ok_or(ObservationalError::Overflow)?;
                if candidate < distances[next as usize] {
                    distances[next as usize] = candidate;
                    parent_classes[next as usize] = class;
                    parent_generators[next as usize] = generator;
                    heap.push_or_decrease(next, &distances)?;
                }
            }
        }
        Ok(None)
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
    compile_observational_with_policy(presentation, CertificatePolicy::ExhaustivePairAudit)
}

pub fn compile_observational_with_policy(
    presentation: &FinitePresentation,
    certificate_policy: CertificatePolicy,
) -> Result<CompiledObservation, ObservationalError> {
    compile_observational_internal(presentation, certificate_policy, true, None)
}

/// Compile an exact proof-carrying artifact without replaying its certificate
/// in the same call. Call [`verify_compilation`] at the persistence, process,
/// or trust boundary. This avoids duplicate work in validated in-process
/// services while retaining independently replayable evidence.
pub fn compile_observational_with_deferred_verification(
    presentation: &FinitePresentation,
    certificate_policy: CertificatePolicy,
) -> Result<CompiledObservation, ObservationalError> {
    compile_observational_internal(presentation, certificate_policy, false, None)
}

fn compile_observational_internal(
    presentation: &FinitePresentation,
    certificate_policy: CertificatePolicy,
    verify_immediately: bool,
    prepared_refinement: Option<RefinementGenerators>,
) -> Result<CompiledObservation, ObservationalError> {
    if certificate_policy == CertificatePolicy::AdaptiveTranscript {
        let (selected, refinement) = match multiway_admission(presentation)? {
            MultiwayAdmission::Admitted(refinement) => {
                (CertificatePolicy::MultiwayTranscript, refinement)
            }
            MultiwayAdmission::Rejected(refinement) => {
                (CertificatePolicy::SplitTranscript, refinement)
            }
        };
        return compile_observational_internal(
            presentation,
            selected,
            verify_immediately,
            refinement,
        );
    }
    if certificate_policy == CertificatePolicy::QuotientOnly {
        // Quotient-only changes retained evidence, not the proof boundary:
        // construct and independently replay the linear split transcript,
        // then discard it before returning.  This avoids the quadratic
        // synchronous reference refiner on long distinguishing chains.
        let (source_policy, refinement) = match multiway_admission(presentation)? {
            MultiwayAdmission::Admitted(refinement) => {
                (CertificatePolicy::MultiwayTranscript, refinement)
            }
            MultiwayAdmission::Rejected(refinement) => {
                (CertificatePolicy::SplitTranscript, refinement)
            }
        };
        let mut compiled = compile_observational_internal(
            presentation,
            source_policy,
            verify_immediately,
            refinement,
        )?;
        compiled.split_records = Box::default();
        compiled.multiway_records = Box::default();
        compiled.certificate_policy = CertificatePolicy::QuotientOnly;
        compiled.metrics.refinement_splits = 0;
        return Ok(compiled);
    }
    let prepared_refinement = match prepared_refinement {
        Some(refinement) => Some(refinement),
        None if matches!(
            certificate_policy,
            CertificatePolicy::SplitTranscript | CertificatePolicy::MultiwayTranscript
        ) && presentation
            .generator_sort_ranges
            .iter()
            .any(|range| range.len > 4) =>
        {
            Some(RefinementGenerators::new(presentation)?)
        }
        None => None,
    };
    let (
        classes,
        class_ranges,
        refinement_rounds,
        split_records,
        multiway_records,
        verification_inverse,
    ) = match certificate_policy {
        CertificatePolicy::SplitTranscript => {
            let (classes, class_ranges, split_records, inverse) =
                minimize_partition_worklist_prepared(presentation, prepared_refinement.as_ref())?;
            (
                classes,
                class_ranges,
                0,
                split_records,
                Box::default(),
                inverse,
            )
        }
        CertificatePolicy::MultiwayTranscript => {
            let (classes, class_ranges, records, _inverse) =
                minimize_partition_multiway_prepared(presentation, prepared_refinement.as_ref())?;
            (
                classes,
                class_ranges,
                records.len(),
                Box::default(),
                records,
                None,
            )
        }
        CertificatePolicy::ExhaustivePairAudit => {
            let (classes, class_ranges, refinement_rounds) = minimize_partition(presentation)?;
            (
                classes,
                class_ranges,
                refinement_rounds,
                Box::default(),
                Box::default(),
                None,
            )
        }
        CertificatePolicy::QuotientOnly => unreachable!("handled above"),
        CertificatePolicy::AdaptiveTranscript => unreachable!("handled above"),
    };

    emit_compilation(
        presentation,
        classes,
        class_ranges,
        refinement_rounds,
        certificate_policy,
        split_records,
        multiway_records,
        prepared_refinement.as_ref(),
        verification_inverse.as_ref(),
        verify_immediately,
    )
}

enum MultiwayAdmission {
    Rejected(Option<RefinementGenerators>),
    Admitted(Option<RefinementGenerators>),
}

fn multiway_admission(
    presentation: &FinitePresentation,
) -> Result<MultiwayAdmission, ObservationalError> {
    if presentation.state_count() < 4_096 {
        return Ok(MultiwayAdmission::Rejected(None));
    }
    let refinement = if presentation
        .generator_sort_ranges
        .iter()
        .any(|range| range.len > 4)
    {
        let directory = RefinementGenerators::new(presentation)?;
        Some(directory)
    } else {
        None
    };
    for (sort, states) in presentation.sorts.iter().copied().enumerate() {
        if states.len <= 1 {
            continue;
        }
        let outgoing = refinement
            .as_ref()
            .map_or(presentation.generator_sort_ranges[sort].len, |directory| {
                directory.ranges[sort].len
            });
        let raw_outgoing = presentation.generator_sort_ranges[sort].len;
        if outgoing == 1 && raw_outgoing == 1 {
            return Ok(MultiwayAdmission::Rejected(refinement));
        }
        let mut first = None;
        let mut second = None;
        for &observation in &presentation.observations[states.start as usize..states.end() as usize]
        {
            if first == Some(observation) || second == Some(observation) {
                continue;
            }
            if first.is_none() {
                first = Some(observation);
            } else if second.is_none() {
                second = Some(observation);
            } else {
                return Ok(MultiwayAdmission::Rejected(refinement));
            }
        }
    }
    Ok(MultiwayAdmission::Admitted(refinement))
}

#[cfg(test)]
fn multiway_is_admitted(presentation: &FinitePresentation) -> bool {
    matches!(
        multiway_admission(presentation),
        Ok(MultiwayAdmission::Admitted(_))
    )
}

fn minimize_partition(
    presentation: &FinitePresentation,
) -> Result<MinimizedPartition, ObservationalError> {
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
    Ok((classes, class_ranges, refinement_rounds))
}

#[allow(clippy::too_many_arguments)]
fn emit_compilation(
    presentation: &FinitePresentation,
    classes: Box<[u32]>,
    class_ranges: Box<[SortRange]>,
    refinement_rounds: usize,
    certificate_policy: CertificatePolicy,
    split_records: Box<[SplitRecord]>,
    multiway_records: Box<[MultiwayRecord]>,
    refinement: Option<&RefinementGenerators>,
    verification_inverse: Option<&InverseIndex>,
    verify_immediately: bool,
) -> Result<CompiledObservation, ObservationalError> {
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

    let transition_capacity = presentation.generators.iter().enumerate().try_fold(
        0_usize,
        |capacity, (generator_id, generator)| -> Result<usize, ObservationalError> {
            if refinement.is_some_and(|directory| directory.aliases[generator_id] != u32::MAX) {
                return Ok(capacity);
            }
            capacity
                .checked_add(class_ranges[generator.source_sort as usize].len as usize)
                .ok_or(ObservationalError::Overflow)
        },
    )?;
    let mut generator_records: Vec<GeneratorRecord> =
        Vec::with_capacity(presentation.generators.len());
    let mut generator_transitions = Vec::with_capacity(transition_capacity);
    for (generator_id, generator) in presentation.generators.iter().copied().enumerate() {
        let source_states = presentation.sorts[generator.source_sort as usize];
        let target_states = presentation.sorts[generator.target_sort as usize];
        let source_classes = class_ranges[generator.source_sort as usize];
        let target_classes = class_ranges[generator.target_sort as usize];
        let transition_start_in_presentation = generator.transition_start as usize;
        let transitions = &presentation.transitions[transition_start_in_presentation
            ..transition_start_in_presentation + generator.transition_len as usize];
        let alias = refinement.map_or(u32::MAX, |directory| directory.aliases[generator_id]);
        if alias != u32::MAX {
            let prior = generator_records[alias as usize];
            generator_records.push(GeneratorRecord {
                source_sort: generator.source_sort,
                target_sort: generator.target_sort,
                transition_start: prior.transition_start,
                transition_len: prior.transition_len,
            });
            continue;
        }
        let transition_start =
            u32::try_from(generator_transitions.len()).map_err(|_| ObservationalError::Overflow)?;
        if source_classes.len == source_states.len && target_classes.len == target_states.len {
            if target_classes.start == target_states.start {
                generator_transitions.extend_from_slice(transitions);
            } else {
                for &target in transitions {
                    generator_transitions
                        .push(target_classes.start + (target - target_states.start));
                }
            }
        } else {
            for class in source_classes.start..source_classes.end() {
                let representative = representatives[class as usize];
                let local = (representative - source_states.start) as usize;
                let target = transitions[local];
                generator_transitions.push(classes[target as usize]);
            }
        }
        generator_records.push(GeneratorRecord {
            source_sort: generator.source_sort,
            target_sort: generator.target_sort,
            transition_start,
            transition_len: source_classes.len,
        });
    }

    let (separators, separator_paths) = match certificate_policy {
        CertificatePolicy::QuotientOnly
        | CertificatePolicy::SplitTranscript
        | CertificatePolicy::MultiwayTranscript
        | CertificatePolicy::AdaptiveTranscript => (Box::default(), Box::default()),
        CertificatePolicy::ExhaustivePairAudit => {
            let (records, paths) = build_separators(presentation, &classes)?;
            (records, paths)
        }
    };
    let metrics = CompilationMetrics {
        states: presentation.state_count(),
        classes: class_count,
        generators: presentation.generators.len(),
        refinement_rounds,
        refinement_splits: split_records.len()
            + multiway_records
                .iter()
                .map(|record| record.new_block_count as usize)
                .sum::<usize>(),
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
        split_records,
        multiway_records,
        separators,
        separator_paths,
        certificate_policy,
        metrics,
    };
    if verify_immediately {
        verify_compilation_with_inverse(presentation, &compiled, verification_inverse)?;
    }
    Ok(compiled)
}

fn initial_partition(presentation: &FinitePresentation) -> Result<Partition, ObservationalError> {
    let mut classes = vec![u32::MAX; presentation.state_count()];
    let mut ranges = Vec::with_capacity(presentation.sorts.len());
    let max_sort = presentation
        .sorts
        .iter()
        .map(|range| range.len as usize)
        .max()
        .unwrap_or(0);
    let mut state_scratch = vec![0_u32; max_sort];
    let mut canonical = vec![u32::MAX; max_sort];
    let mut next_class = 0_u32;
    for states in presentation.sorts.iter().copied() {
        let class_start = next_class;
        let mut observation_mask = 0_u32;
        for (local, slot) in state_scratch[..states.len as usize].iter_mut().enumerate() {
            *slot = states.start + local as u32;
            observation_mask |= presentation.observations[*slot as usize];
        }
        radix_sort_states_by_observation(
            &presentation.observations,
            &mut state_scratch[..states.len as usize],
            &mut canonical[..states.len as usize],
            observation_mask,
        );
        let mut group_count = 0_usize;
        let mut previous = None;
        for &state in &state_scratch[..states.len as usize] {
            let observation = presentation.observations[state as usize];
            if previous != Some(observation) {
                previous = Some(observation);
                group_count += 1;
            }
            classes[state as usize] = (group_count - 1) as u32;
        }
        canonical[..group_count].fill(u32::MAX);
        for state in states.start..states.end() {
            let local = classes[state as usize] as usize;
            if canonical[local] == u32::MAX {
                canonical[local] = next_class;
                next_class = next_class
                    .checked_add(1)
                    .ok_or(ObservationalError::Overflow)?;
            }
            classes[state as usize] = canonical[local];
        }
        ranges.push(SortRange {
            start: class_start,
            len: next_class - class_start,
        });
    }
    Ok((classes.into_boxed_slice(), ranges.into_boxed_slice()))
}

fn radix_sort_states_by_observation(
    observations: &[u32],
    states: &mut [u32],
    scratch: &mut [u32],
    observation_mask: u32,
) {
    debug_assert_eq!(states.len(), scratch.len());
    let passes = if observation_mask <= u32::from(u8::MAX) {
        1
    } else if observation_mask <= u32::from(u16::MAX) {
        2
    } else if observation_mask <= 0x00ff_ffff {
        3
    } else {
        4
    };
    for pass in 0..passes {
        let shift = pass * 8;
        let mut counts = [0_usize; 256];
        let source: &[u32] = if pass % 2 == 0 { states } else { scratch };
        for &state in source {
            counts[((observations[state as usize] >> shift) & 0xff) as usize] += 1;
        }
        let mut next = 0_usize;
        for count in &mut counts {
            let len = *count;
            *count = next;
            next += len;
        }
        if pass % 2 == 0 {
            for &state in states.iter() {
                let bucket = ((observations[state as usize] >> shift) & 0xff) as usize;
                scratch[counts[bucket]] = state;
                counts[bucket] += 1;
            }
        } else {
            for &state in scratch.iter() {
                let bucket = ((observations[state as usize] >> shift) & 0xff) as usize;
                states[counts[bucket]] = state;
                counts[bucket] += 1;
            }
        }
    }
    if passes % 2 != 0 {
        states.copy_from_slice(scratch);
    }
}

fn refine_partition(
    presentation: &FinitePresentation,
    classes: &[u32],
) -> Result<Partition, ObservationalError> {
    assign_signatures(presentation, |sort, state, signature| {
        signature.push(classes[state as usize]);
        signature.extend(presentation.generators_from(sort).map(|(generator, _)| {
            let target = presentation
                .transition(generator, state)
                .expect("typed total generator");
            classes[target as usize]
        }));
    })
}

fn assign_signatures(
    presentation: &FinitePresentation,
    continuation: impl Fn(u32, u32, &mut Vec<u32>),
) -> Result<Partition, ObservationalError> {
    let mut classes = vec![u32::MAX; presentation.state_count()];
    let mut ranges = Vec::with_capacity(presentation.sorts.len());
    let mut next_class = 0_u32;
    for (sort, range) in presentation.sorts.iter().copied().enumerate() {
        let sort = u32::try_from(sort).map_err(|_| ObservationalError::Overflow)?;
        let class_start = next_class;
        let mut signatures: BTreeMap<Vec<u32>, u32> = BTreeMap::new();
        let outgoing = presentation.generator_sort_ranges[sort as usize].len as usize;
        for state in range.start..range.end() {
            let mut signature = Vec::with_capacity(2 + outgoing);
            signature.push(presentation.observations[state as usize]);
            continuation(sort, state, &mut signature);
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

#[cfg(test)]
fn minimize_partition_worklist(
    presentation: &FinitePresentation,
) -> Result<WorklistPartition, ObservationalError> {
    minimize_partition_worklist_prepared(presentation, None)
}

fn minimize_partition_worklist_prepared(
    presentation: &FinitePresentation,
    refinement: Option<&RefinementGenerators>,
) -> Result<WorklistPartition, ObservationalError> {
    let block_capacity = presentation.state_count();
    let (state_blocks, block_sorts, members, block_ranges) =
        initial_split_workspace(presentation, block_capacity)?;
    let initial_block_count = block_sorts.len();
    let mut omitted_blocks = vec![u32::MAX; presentation.sorts.len()];
    let mut initial_blocks_per_sort = vec![0_u32; presentation.sorts.len()];
    for (block, &sort) in block_sorts.iter().enumerate() {
        initial_blocks_per_sort[sort as usize] += 1;
        let omitted = &mut omitted_blocks[sort as usize];
        if *omitted == u32::MAX || block_ranges[block].len > block_ranges[*omitted as usize].len {
            *omitted = block as u32;
        }
    }
    if presentation
        .generators
        .iter()
        .all(|record| initial_blocks_per_sort[record.target_sort as usize] <= 1)
    {
        let class_ranges = initial_class_ranges(presentation.sorts.len(), &block_sorts)?;
        return Ok((state_blocks, class_ranges, Box::default(), None));
    }
    if initial_block_count > 2
        && partition_is_stable(presentation, &state_blocks, initial_block_count)
    {
        let class_ranges = initial_class_ranges(presentation.sorts.len(), &block_sorts)?;
        return Ok((state_blocks, class_ranges, Box::default(), None));
    }
    let pending_capacity = refinement.map_or(presentation.transitions.len(), |directory| {
        directory
            .ids
            .iter()
            .map(|&generator| presentation.generators[generator as usize].transition_len as usize)
            .sum()
    });
    match pending_mode(presentation, refinement)? {
        PendingMode::Dense => {
            let pending = DensePending::new(presentation, &block_sorts, refinement)?;
            minimize_partition_worklist_with_pending(
                presentation,
                refinement,
                initial_block_count,
                &initial_blocks_per_sort,
                &omitted_blocks,
                state_blocks,
                block_sorts,
                members,
                block_ranges,
                pending,
            )
        }
        PendingMode::Sparse => minimize_partition_worklist_with_pending(
            presentation,
            refinement,
            initial_block_count,
            &initial_blocks_per_sort,
            &omitted_blocks,
            state_blocks,
            block_sorts,
            members,
            block_ranges,
            PatriciaPending::new(pending_capacity)?,
        ),
    }
}

#[allow(clippy::too_many_arguments)]
fn minimize_partition_worklist_with_pending<P: PendingDirectory>(
    presentation: &FinitePresentation,
    refinement: Option<&RefinementGenerators>,
    initial_block_count: usize,
    initial_blocks_per_sort: &[u32],
    omitted_blocks: &[u32],
    mut state_blocks: Box<[u32]>,
    mut block_sorts: Vec<u32>,
    mut members: Vec<u32>,
    mut block_ranges: Vec<SortRange>,
    mut pending: P,
) -> Result<WorklistPartition, ObservationalError> {
    // At most one pending splitter block per forward source edge is useful:
    // for a fixed generator, distinct pending blocks have disjoint nonempty
    // inverse images. The queue therefore needs only one slot per forward edge.
    let block_capacity = presentation.state_count();
    let pending_capacity = refinement.map_or(presentation.transitions.len(), |directory| {
        directory
            .ids
            .iter()
            .map(|&generator| presentation.generators[generator as usize].transition_len as usize)
            .sum()
    });
    let mut queue = VecDeque::with_capacity(pending_capacity);
    for sort in 0..presentation.sorts.len() {
        let generators = refinement.map_or_else(
            || presentation.generator_ids_from(sort as u32),
            |directory| directory.ids_from(sort as u32),
        );
        for &generator in generators {
            let record = presentation.generators[generator as usize];
            if initial_blocks_per_sort[record.target_sort as usize] <= 1 {
                continue;
            }
            let source = presentation.sorts[record.source_sort as usize];
            for source_state in source.start..source.end() {
                let target_state = presentation
                    .transition(generator, source_state)
                    .expect("validated total generator");
                if state_blocks[target_state as usize]
                    == omitted_blocks[record.target_sort as usize]
                {
                    continue;
                }
                push_split_work(
                    &mut queue,
                    &mut pending,
                    SplitWorkItem {
                        block: state_blocks[target_state as usize],
                        generator,
                    },
                )?;
            }
        }
    }
    if queue.is_empty() {
        let class_ranges = initial_class_ranges(presentation.sorts.len(), &block_sorts)?;
        return Ok((state_blocks, class_ranges, Box::default(), None));
    }
    let inverse = InverseIndex::new_prepared(presentation, refinement)?;
    let target_generators = TargetGeneratorDirectory::new(presentation, &inverse, refinement)?;
    let mut marked = bitmap_storage(presentation.state_count())?;
    let mut marked_sources = Vec::with_capacity(presentation.state_count());
    let mut member_positions = vec![0_u32; presentation.state_count()];
    for (position, &state) in members.iter().enumerate() {
        member_positions[state as usize] = position as u32;
    }
    let mut marked_counts = vec![0_u32; block_capacity];
    let mut touched = Vec::with_capacity(block_capacity);
    let mut touched_flags = bitmap_storage(block_capacity)?;
    let mut records = Vec::with_capacity(block_capacity.saturating_sub(initial_block_count));

    while let Some(work) = queue.pop_back() {
        if !pending.remove(work.block, work.generator) {
            return Err(ObservationalError::Partition);
        }
        let splitter = block_ranges[work.block as usize];
        for position in splitter.start..splitter.end() {
            let target_state = members[position as usize];
            for &source_state in inverse.predecessors(presentation, work.generator, target_state) {
                if bitmap_contains(&marked, source_state as usize) {
                    continue;
                }
                bitmap_insert(&mut marked, source_state as usize);
                marked_sources.push(source_state);
                let source_block = state_blocks[source_state as usize] as usize;
                if !bitmap_contains(&touched_flags, source_block) {
                    bitmap_insert(&mut touched_flags, source_block);
                    touched.push(source_block as u32);
                }
            }
        }
        // Keep the splitter's member range immutable while its inverse image
        // is enumerated.  Afterwards each marked source is moved exactly once
        // to the end of its current block.
        for &source_state in &marked_sources {
            let source_block = state_blocks[source_state as usize] as usize;
            let marked_count = &mut marked_counts[source_block];
            let source_position = member_positions[source_state as usize] as usize;
            let marked_position = (block_ranges[source_block].end() - *marked_count - 1) as usize;
            let displaced_state = members[marked_position];
            members.swap(source_position, marked_position);
            member_positions[source_state as usize] = marked_position as u32;
            member_positions[displaced_state as usize] = source_position as u32;
            *marked_count += 1;
        }
        for pass in 0..2 {
            for &source_block in &touched {
                if (source_block == work.block) != (pass == 1) {
                    continue;
                }
                split_marked_block(
                    presentation,
                    &inverse,
                    &target_generators,
                    source_block,
                    marked_counts[source_block as usize],
                    work,
                    &mut state_blocks,
                    &mut block_sorts,
                    &mut members,
                    &mut block_ranges,
                    &mut queue,
                    &mut pending,
                    &mut records,
                )?;
            }
        }
        for source_state in marked_sources.drain(..) {
            bitmap_remove(&mut marked, source_state as usize);
        }
        for source_block in touched.drain(..) {
            marked_counts[source_block as usize] = 0;
            bitmap_remove(&mut touched_flags, source_block as usize);
        }
    }

    if records.len() != block_sorts.len().saturating_sub(initial_block_count) {
        return Err(ObservationalError::Partition);
    }
    let (classes, class_ranges) =
        canonicalize_partition(presentation, state_blocks, block_sorts.len())?;
    Ok((
        classes,
        class_ranges,
        records.into_boxed_slice(),
        Some(inverse),
    ))
}

#[inline(always)]
fn signatures_equal(
    presentation: &FinitePresentation,
    state_blocks: &[u32],
    transition_starts: &[usize],
    source_start: u32,
    left: u32,
    right: u32,
) -> bool {
    let left_local = (left - source_start) as usize;
    let right_local = (right - source_start) as usize;
    transition_starts.iter().copied().all(|start| {
        let left_target = presentation.transitions[start + left_local];
        let right_target = presentation.transitions[start + right_local];
        state_blocks[left_target as usize] == state_blocks[right_target as usize]
    })
}

#[inline(always)]
fn signature_hash(
    presentation: &FinitePresentation,
    state_blocks: &[u32],
    transition_starts: &[usize],
    source_start: u32,
    state: u32,
) -> u64 {
    let mut hash = 0x9e37_79b9_7f4a_7c15_u64;
    let local = (state - source_start) as usize;
    for &start in transition_starts {
        let target = presentation.transitions[start + local];
        hash ^= u64::from(state_blocks[target as usize]).wrapping_add(0x9e37_79b9);
        hash = hash.rotate_left(27).wrapping_mul(0x94d0_49bb_1331_11eb);
    }
    hash
}

fn signature_hash_batch(
    presentation: &FinitePresentation,
    state_blocks: &[u32],
    transition_starts: &[usize],
    source_start: u32,
    states: &[u32],
    hashes: &mut [u64],
) {
    debug_assert_eq!(states.len(), hashes.len());
    hashes.fill(0x9e37_79b9_7f4a_7c15);
    for &start in transition_starts {
        for (&state, hash) in states.iter().zip(hashes.iter_mut()) {
            let target = presentation.transitions[start + (state - source_start) as usize];
            *hash ^= u64::from(state_blocks[target as usize]).wrapping_add(0x9e37_79b9);
            *hash = hash.rotate_left(27).wrapping_mul(0x94d0_49bb_1331_11eb);
        }
    }
    for hash in hashes {
        *hash ^= *hash >> 31;
    }
}

#[inline(always)]
fn packed_signature4(
    presentation: &FinitePresentation,
    state_blocks: &[u32],
    transition_starts: &[usize; 4],
    generator_count: usize,
    source_start: u32,
    state: u32,
) -> (u64, u64, u64) {
    debug_assert!(generator_count <= 4);
    let local = (state - source_start) as usize;
    let class = |index: usize| {
        let target = presentation.transitions[transition_starts[index] + local];
        state_blocks[target as usize]
    };
    let (low, high) = match generator_count {
        0 => (0, 0),
        1 => (u64::from(class(0)), 0),
        2 => (u64::from(class(0)) | u64::from(class(1)) << 32, 0),
        3 => (
            u64::from(class(0)) | u64::from(class(1)) << 32,
            u64::from(class(2)),
        ),
        4 => (
            u64::from(class(0)) | u64::from(class(1)) << 32,
            u64::from(class(2)) | u64::from(class(3)) << 32,
        ),
        _ => unreachable!(),
    };
    let mut hash = low.wrapping_mul(0x9e37_79b9_7f4a_7c15);
    hash ^= high.rotate_left(29).wrapping_mul(0x94d0_49bb_1331_11eb);
    hash ^= hash >> 31;
    (hash, low, high)
}

/// Dirty-block multiway refinement. All workspace is allocated before the
/// loop; a split retains its largest child and schedules predecessors of only
/// the smaller children.
fn minimize_partition_multiway(
    presentation: &FinitePresentation,
) -> Result<MultiwayPartition, ObservationalError> {
    let refinement = presentation
        .generator_sort_ranges
        .iter()
        .any(|range| range.len > 4)
        .then(|| RefinementGenerators::new(presentation))
        .transpose()?;
    minimize_partition_multiway_prepared(presentation, refinement.as_ref())
}

fn minimize_partition_multiway_prepared(
    presentation: &FinitePresentation,
    refinement: Option<&RefinementGenerators>,
) -> Result<MultiwayPartition, ObservationalError> {
    let block_capacity = presentation.state_count();
    let (mut state_blocks, mut block_sorts, mut members, mut block_ranges) =
        initial_split_workspace(presentation, block_capacity)?;
    let initial_block_count = block_sorts.len();
    if partition_is_stable(presentation, &state_blocks, initial_block_count) {
        let ranges = initial_class_ranges(presentation.sorts.len(), &block_sorts)?;
        return Ok((state_blocks, ranges, Box::default(), None));
    }

    let inverse = CombinedInverse::new(presentation, refinement)?;
    let mut positions = vec![0_u32; block_capacity];
    for (position, &state) in members.iter().enumerate() {
        positions[state as usize] = position as u32;
    }
    let mut dirty_starts = Vec::with_capacity(block_capacity);
    let mut queued = bitmap_storage(block_capacity)?;
    let mut queue = VecDeque::with_capacity(block_capacity);
    for (block, range) in block_ranges.iter().copied().enumerate() {
        if range.len > 1 {
            dirty_starts.push(range.start);
            bitmap_insert(&mut queued, block);
            queue.push_back(block as u32);
        } else {
            dirty_starts.push(range.end());
        }
    }

    let hash_capacity = block_capacity
        .max(1)
        .checked_mul(2)
        .and_then(usize::checked_next_power_of_two)
        .ok_or(ObservationalError::Overflow)?;
    let hash_mask = hash_capacity - 1;
    let mut hash_slots = vec![u32::MAX; hash_capacity];
    let mut touched_slots = Vec::with_capacity(block_capacity);
    let mut group_keys_low = vec![0_u64; block_capacity];
    let mut group_keys_high = vec![0_u64; block_capacity];
    let mut group_representatives = vec![0_u32; block_capacity];
    let mut group_counts = vec![0_u32; block_capacity];
    let mut group_cursors = vec![0_u32; block_capacity];
    let mut group_blocks = vec![0_u32; block_capacity];
    let mut state_groups = vec![0_u32; block_capacity];
    let mut wide_hashes = vec![0_u64; block_capacity];
    let mut refiner_scratch = vec![0_u32; block_capacity];
    let mut records = Vec::with_capacity(block_capacity.saturating_sub(initial_block_count));

    while let Some(block) = queue.pop_back() {
        bitmap_remove(&mut queued, block as usize);
        let range = block_ranges[block as usize];
        let dirty_start = dirty_starts[block as usize];
        if dirty_start == range.end() || range.len <= 1 {
            continue;
        }
        let refiner_start = if range.start < dirty_start {
            dirty_start - 1
        } else {
            range.start
        };
        let refiner_len = (range.end() - refiner_start) as usize;
        refiner_scratch[..refiner_len]
            .copy_from_slice(&members[refiner_start as usize..range.end() as usize]);
        let sort = block_sorts[block as usize];
        let generators = refinement.as_ref().map_or_else(
            || presentation.generator_ids_from(sort),
            |directory| directory.ids_from(sort),
        );
        let packed = generators.len() <= 4;
        let source_start = presentation.sorts[sort as usize].start;
        let wide_transition_starts = refinement
            .as_ref()
            .map_or(&[][..], |directory| directory.transition_starts_from(sort));
        let mut transition_starts = [0_usize; 4];
        for (slot, &generator) in transition_starts.iter_mut().zip(generators) {
            *slot = presentation.generators[generator as usize].transition_start as usize;
        }
        let batched = !packed && refiner_len >= 64;
        if batched {
            signature_hash_batch(
                presentation,
                &state_blocks,
                wide_transition_starts,
                source_start,
                &refiner_scratch[..refiner_len],
                &mut wide_hashes[..refiner_len],
            );
        }
        let mut group_count = 0_usize;
        for (refiner_index, &state) in refiner_scratch[..refiner_len].iter().enumerate() {
            let (hash, key_low, key_high) = if packed {
                packed_signature4(
                    presentation,
                    &state_blocks,
                    &transition_starts,
                    generators.len(),
                    source_start,
                    state,
                )
            } else if batched {
                (wide_hashes[refiner_index], 0, 0)
            } else {
                (
                    signature_hash(
                        presentation,
                        &state_blocks,
                        wide_transition_starts,
                        source_start,
                        state,
                    ),
                    0,
                    0,
                )
            };
            let mut slot = hash as usize & hash_mask;
            let group = loop {
                let candidate = hash_slots[slot];
                if candidate == u32::MAX {
                    let group = group_count as u32;
                    hash_slots[slot] = group;
                    touched_slots.push(slot as u32);
                    group_keys_low[group_count] = if packed { key_low } else { hash };
                    group_keys_high[group_count] = key_high;
                    group_representatives[group_count] = state;
                    group_counts[group_count] = 0;
                    group_count += 1;
                    break group;
                }
                let exact = if packed {
                    group_keys_low[candidate as usize] == key_low
                        && group_keys_high[candidate as usize] == key_high
                } else {
                    group_keys_low[candidate as usize] == hash
                        && signatures_equal(
                            presentation,
                            &state_blocks,
                            wide_transition_starts,
                            source_start,
                            state,
                            group_representatives[candidate as usize],
                        )
                };
                if exact {
                    break candidate;
                }
                slot = (slot + 1) & hash_mask;
            };
            state_groups[state as usize] = group;
            group_counts[group as usize] += 1;
        }
        let clean_extra = refiner_start - range.start;
        group_counts[0] = group_counts[0]
            .checked_add(clean_extra)
            .ok_or(ObservationalError::Overflow)?;
        if group_count == 1 {
            dirty_starts[block as usize] = range.end();
            for slot in touched_slots.drain(..) {
                hash_slots[slot as usize] = u32::MAX;
            }
            continue;
        }

        let mut largest_group = 0_usize;
        for group in 1..group_count {
            if group_counts[group] > group_counts[largest_group] {
                largest_group = group;
            }
        }
        let mut next = range.start;
        for group in 0..group_count {
            group_cursors[group] = next;
            next = next
                .checked_add(group_counts[group])
                .ok_or(ObservationalError::Overflow)?;
        }
        group_cursors[0] += clean_extra;
        for &state in &refiner_scratch[..refiner_len] {
            let group = state_groups[state as usize] as usize;
            let position = group_cursors[group] as usize;
            members[position] = state;
            positions[state as usize] = position as u32;
            group_cursors[group] += 1;
        }

        let new_block_start =
            u32::try_from(block_sorts.len()).map_err(|_| ObservationalError::Overflow)?;
        let mut next_block = new_block_start;
        for group in 0..group_count {
            let group_range = SortRange {
                start: group_cursors[group] - group_counts[group],
                len: group_counts[group],
            };
            if group == largest_group {
                group_blocks[group] = block;
                block_ranges[block as usize] = group_range;
                dirty_starts[block as usize] = group_range.end();
            } else {
                if block_sorts.len() == block_sorts.capacity()
                    || block_ranges.len() == block_ranges.capacity()
                    || dirty_starts.len() == dirty_starts.capacity()
                {
                    return Err(ObservationalError::Overflow);
                }
                group_blocks[group] = next_block;
                next_block += 1;
                block_sorts.push(sort);
                block_ranges.push(group_range);
                dirty_starts.push(group_range.end());
            }
        }
        for &group_block in group_blocks.iter().take(group_count) {
            let group_range = block_ranges[group_block as usize];
            if group_block == block {
                continue;
            }
            for position in group_range.start..group_range.end() {
                state_blocks[members[position as usize] as usize] = group_block;
            }
        }
        records.push(MultiwayRecord {
            source_block: block,
            new_block_start,
            new_block_count: next_block - new_block_start,
        });

        for new_block in new_block_start..next_block {
            let new_range = block_ranges[new_block as usize];
            for position in new_range.start..new_range.end() {
                let target_state = members[position as usize];
                for &source_state in inverse.predecessors(target_state) {
                    let source_block = state_blocks[source_state as usize] as usize;
                    let source_range = block_ranges[source_block];
                    if source_range.len <= 1 {
                        continue;
                    }
                    let source_position = positions[source_state as usize];
                    let mid = dirty_starts[source_block];
                    if source_position >= mid {
                        continue;
                    }
                    let new_mid = mid - 1;
                    let displaced = members[new_mid as usize];
                    members.swap(source_position as usize, new_mid as usize);
                    positions[source_state as usize] = new_mid;
                    positions[displaced as usize] = source_position;
                    dirty_starts[source_block] = new_mid;
                    if mid == source_range.end() && !bitmap_contains(&queued, source_block) {
                        if queue.len() == queue.capacity() {
                            return Err(ObservationalError::Overflow);
                        }
                        bitmap_insert(&mut queued, source_block);
                        queue.push_back(source_block as u32);
                    }
                }
            }
        }
        for slot in touched_slots.drain(..) {
            hash_slots[slot as usize] = u32::MAX;
        }
    }

    let (classes, class_ranges) =
        canonicalize_partition(presentation, state_blocks, block_sorts.len())?;
    Ok((
        classes,
        class_ranges,
        records.into_boxed_slice(),
        Some(inverse),
    ))
}

fn partition_is_stable(
    presentation: &FinitePresentation,
    state_blocks: &[u32],
    block_count: usize,
) -> bool {
    let mut expected_targets = vec![u32::MAX; block_count];
    let mut touched = Vec::with_capacity(block_count);
    for (generator, record) in presentation.generators.iter().copied().enumerate() {
        let source = presentation.sorts[record.source_sort as usize];
        for state in source.start..source.end() {
            let source_block = state_blocks[state as usize] as usize;
            let target_state = presentation
                .transition(generator as u32, state)
                .expect("validated total generator");
            let target_block = state_blocks[target_state as usize];
            let expected = &mut expected_targets[source_block];
            if *expected == u32::MAX {
                *expected = target_block;
                touched.push(source_block as u32);
            } else if *expected != target_block {
                return false;
            }
        }
        for block in touched.drain(..) {
            expected_targets[block as usize] = u32::MAX;
        }
    }
    true
}

fn canonicalize_partition(
    presentation: &FinitePresentation,
    mut state_blocks: Box<[u32]>,
    block_count: usize,
) -> Result<Partition, ObservationalError> {
    let mut old_to_new = vec![u32::MAX; block_count];
    let mut ranges = Vec::with_capacity(presentation.sorts.len());
    let mut next_class = 0_u32;
    for states in presentation.sorts.iter().copied() {
        let class_start = next_class;
        for state in states.start..states.end() {
            let old = state_blocks[state as usize] as usize;
            if old_to_new[old] == u32::MAX {
                old_to_new[old] = next_class;
                next_class = next_class
                    .checked_add(1)
                    .ok_or(ObservationalError::Overflow)?;
            }
            state_blocks[state as usize] = old_to_new[old];
        }
        ranges.push(SortRange {
            start: class_start,
            len: next_class - class_start,
        });
    }
    Ok((state_blocks, ranges.into_boxed_slice()))
}

fn initial_class_ranges(
    sort_count: usize,
    block_sorts: &[u32],
) -> Result<Box<[SortRange]>, ObservationalError> {
    let mut counts = vec![0_u32; sort_count];
    for &sort in block_sorts {
        counts[sort as usize] = counts[sort as usize]
            .checked_add(1)
            .ok_or(ObservationalError::Overflow)?;
    }
    let mut next = 0_u32;
    let mut ranges = Vec::with_capacity(sort_count);
    for len in counts {
        ranges.push(SortRange { start: next, len });
        next = next.checked_add(len).ok_or(ObservationalError::Overflow)?;
    }
    Ok(ranges.into_boxed_slice())
}

fn initial_split_workspace(
    presentation: &FinitePresentation,
    block_capacity: usize,
) -> Result<SplitWorkspace, ObservationalError> {
    let (state_blocks, block_sorts) = initial_split_state(presentation, block_capacity)?;
    let block_count = block_sorts.len();
    let mut counts = vec![0_u32; block_count];
    for &block in &state_blocks {
        counts[block as usize] += 1;
    }
    let mut block_ranges = Vec::with_capacity(block_capacity.max(block_count));
    let mut next = 0_u32;
    for count in counts {
        block_ranges.push(SortRange {
            start: next,
            len: count,
        });
        next += count;
    }
    let mut cursors = block_ranges
        .iter()
        .map(|range| range.start)
        .collect::<Vec<_>>();
    let mut members = vec![0_u32; presentation.state_count()];
    for (state, &block) in state_blocks.iter().enumerate() {
        let cursor = &mut cursors[block as usize];
        members[*cursor as usize] = state as u32;
        *cursor += 1;
    }
    Ok((state_blocks, block_sorts, members, block_ranges))
}

#[allow(clippy::too_many_arguments)]
fn split_marked_block<P: PendingDirectory>(
    presentation: &FinitePresentation,
    inverse: &InverseIndex,
    target_generators: &TargetGeneratorDirectory,
    source_block: u32,
    moved_len: u32,
    work: SplitWorkItem,
    state_blocks: &mut [u32],
    block_sorts: &mut Vec<u32>,
    members: &mut [u32],
    block_ranges: &mut Vec<SortRange>,
    queue: &mut VecDeque<SplitWorkItem>,
    pending: &mut P,
    records: &mut Vec<SplitRecord>,
) -> Result<(), ObservationalError> {
    let range = block_ranges[source_block as usize];
    let retained_len = range.len - moved_len;
    if retained_len == 0 || moved_len == 0 {
        return Ok(());
    }
    if block_sorts.len() == block_sorts.capacity()
        || block_ranges.len() == block_ranges.capacity()
        || records.len() == records.capacity()
    {
        return Err(ObservationalError::Overflow);
    }
    let new_block = u32::try_from(block_sorts.len()).map_err(|_| ObservationalError::Overflow)?;
    let new_range = if moved_len <= retained_len {
        block_ranges[source_block as usize].len = retained_len;
        SortRange {
            start: range.start + retained_len,
            len: moved_len,
        }
    } else {
        block_ranges[source_block as usize] = SortRange {
            start: range.start + retained_len,
            len: moved_len,
        };
        SortRange {
            start: range.start,
            len: retained_len,
        }
    };
    block_ranges.push(new_range);
    let sort = block_sorts[source_block as usize];
    block_sorts.push(sort);
    pending.add_block(new_block, sort)?;
    for position in new_range.start as usize..new_range.end() as usize {
        state_blocks[members[position] as usize] = new_block;
    }
    records.push(SplitRecord {
        source_block,
        generator: work.generator,
        splitter_block: work.block,
        new_block,
    });
    schedule_sparse_splitter_block(
        presentation,
        inverse,
        target_generators,
        new_block,
        sort,
        block_ranges,
        members,
        queue,
        pending,
    )?;
    Ok(())
}

fn split_work_key(block: u32, generator: u32) -> u64 {
    (u64::from(block) << 32) | u64::from(generator)
}

#[allow(clippy::too_many_arguments)]
#[inline(always)]
fn schedule_sparse_splitter_block<P: PendingDirectory>(
    presentation: &FinitePresentation,
    inverse: &InverseIndex,
    target_generators: &TargetGeneratorDirectory,
    block: u32,
    target_sort: u32,
    block_ranges: &[SortRange],
    members: &[u32],
    queue: &mut VecDeque<SplitWorkItem>,
    pending: &mut P,
) -> Result<(), ObservationalError> {
    let range = block_ranges[block as usize];
    match target_generators {
        TargetGeneratorDirectory::BySort { ranges, generators } => {
            let generators = &generators[ranges[target_sort as usize].start as usize
                ..ranges[target_sort as usize].end() as usize];
            for position in range.start..range.end() {
                let target_state = members[position as usize];
                for &generator in generators {
                    if inverse
                        .predecessors(presentation, generator, target_state)
                        .is_empty()
                    {
                        continue;
                    }
                    push_split_work(queue, pending, SplitWorkItem { block, generator })?;
                }
            }
        }
        TargetGeneratorDirectory::ByState {
            offsets,
            generators,
        } => {
            for position in range.start..range.end() {
                let target_state = members[position as usize];
                let start = offsets[target_state as usize] as usize;
                let end = offsets[target_state as usize + 1] as usize;
                for &generator in &generators[start..end] {
                    push_split_work(queue, pending, SplitWorkItem { block, generator })?;
                }
            }
        }
    }
    Ok(())
}

#[inline(always)]
fn push_split_work<P: PendingDirectory>(
    queue: &mut VecDeque<SplitWorkItem>,
    pending: &mut P,
    work: SplitWorkItem,
) -> Result<(), ObservationalError> {
    if queue.len() == queue.capacity() {
        if pending.contains(work.block, work.generator) {
            return Ok(());
        }
        return Err(ObservationalError::Overflow);
    }
    if !pending.insert(work.block, work.generator)? {
        return Ok(());
    }
    queue.push_back(work);
    Ok(())
}

fn verify_split_transcript(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
) -> Result<(), ObservationalError> {
    // The generic verifier has already established observation constancy and
    // generator congruence of the compiled partition. Starting from the typed
    // observation partition, every recorded inverse-image split is therefore
    // forced in every stable refinement. Agreement after replay proves that
    // the compiled stable partition is the coarsest one.
    if compiled.split_records.is_empty() {
        // Generic verification has already proved total coverage,
        // observation constancy, typing, and congruence.  With no recorded
        // split, minimality is therefore exactly the assertion that no two
        // same-sort classes share an observation.  Check the class outputs,
        // not a second state-sized reconstruction of the initial partition.
        let max_classes = compiled
            .class_ranges
            .iter()
            .map(|range| range.len as usize)
            .max()
            .unwrap_or(0);
        let mut outputs = vec![0_u32; max_classes];
        for range in compiled.class_ranges.iter().copied() {
            let len = range.len as usize;
            outputs[..len].copy_from_slice(
                &compiled.class_outputs[range.start as usize..range.end() as usize],
            );
            outputs[..len].sort_unstable();
            if outputs[..len].windows(2).any(|pair| pair[0] == pair[1]) {
                return Err(ObservationalError::Partition);
            }
        }
        return Ok(());
    }
    let inverse = InverseIndex::new(presentation)?;
    inverse.verify(presentation)?;
    verify_split_transcript_with_inverse(presentation, compiled, &inverse)
}

fn verify_split_transcript_with_inverse(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
    inverse: &InverseIndex,
) -> Result<(), ObservationalError> {
    if compiled.split_records.is_empty() {
        return verify_split_transcript(presentation, compiled);
    }
    let (mut state_blocks, mut block_sorts, mut members, mut block_ranges) =
        initial_split_workspace(presentation, compiled.class_outputs.len())?;
    let mut member_positions = vec![0_u32; presentation.state_count()];
    for (position, &state) in members.iter().enumerate() {
        member_positions[state as usize] = position as u32;
    }
    let mut moved_sources = Vec::with_capacity(presentation.state_count());
    for &record in &compiled.split_records {
        if record.new_block as usize != block_sorts.len() {
            return Err(ObservationalError::CompiledShape);
        }
        let source_sort = *block_sorts
            .get(record.source_block as usize)
            .ok_or(ObservationalError::CompiledShape)?;
        let splitter_sort = *block_sorts
            .get(record.splitter_block as usize)
            .ok_or(ObservationalError::CompiledShape)?;
        let generator = *presentation
            .generators
            .get(record.generator as usize)
            .ok_or(ObservationalError::CompiledShape)?;
        if generator.source_sort != source_sort || generator.target_sort != splitter_sort {
            return Err(ObservationalError::CompiledShape);
        }
        let source_range = block_ranges[record.source_block as usize];
        let splitter_range = block_ranges[record.splitter_block as usize];
        moved_sources.clear();
        for position in splitter_range.start..splitter_range.end() {
            let target_state = members[position as usize];
            for &source_state in inverse.predecessors(presentation, record.generator, target_state)
            {
                if state_blocks[source_state as usize] == record.source_block {
                    moved_sources.push(source_state);
                }
            }
        }
        if moved_sources.is_empty() || moved_sources.len() == source_range.len as usize {
            return Err(ObservationalError::Partition);
        }
        let mut boundary = source_range.end() as usize;
        for &source_state in &moved_sources {
            boundary -= 1;
            let position = member_positions[source_state as usize] as usize;
            let displaced = members[boundary];
            members.swap(position, boundary);
            member_positions[source_state as usize] = boundary as u32;
            member_positions[displaced as usize] = position as u32;
        }
        if block_sorts.len() == block_sorts.capacity()
            || block_ranges.len() == block_ranges.capacity()
        {
            return Err(ObservationalError::Overflow);
        }
        let retained_len = boundary as u32 - source_range.start;
        let moved_len = source_range.len - retained_len;
        let new_range = if moved_len <= retained_len {
            block_ranges[record.source_block as usize].len = retained_len;
            SortRange {
                start: boundary as u32,
                len: moved_len,
            }
        } else {
            block_ranges[record.source_block as usize] = SortRange {
                start: boundary as u32,
                len: moved_len,
            };
            SortRange {
                start: source_range.start,
                len: retained_len,
            }
        };
        for position in new_range.start..new_range.end() {
            state_blocks[members[position as usize] as usize] = record.new_block;
        }
        block_ranges.push(new_range);
        block_sorts.push(source_sort);
    }
    if block_sorts.len() != compiled.class_outputs.len()
        || !partitions_agree(&state_blocks, &compiled.state_classes)
    {
        return Err(ObservationalError::Partition);
    }
    Ok(())
}

fn initial_split_state(
    presentation: &FinitePresentation,
    block_capacity: usize,
) -> Result<(Box<[u32]>, Vec<u32>), ObservationalError> {
    let (state_blocks, initial_ranges) = initial_partition(presentation)?;
    let initial_count = initial_ranges
        .last()
        .map_or(0, |range| range.end() as usize);
    let mut block_sorts = Vec::with_capacity(block_capacity.max(initial_count));
    block_sorts.resize(initial_count, u32::MAX);
    for (sort, range) in presentation.sorts.iter().copied().enumerate() {
        let sort = u32::try_from(sort).map_err(|_| ObservationalError::Overflow)?;
        for state in range.start..range.end() {
            block_sorts[state_blocks[state as usize] as usize] = sort;
        }
    }
    Ok((state_blocks, block_sorts))
}

fn partitions_agree(left: &[u32], right: &[u32]) -> bool {
    if left.len() != right.len() {
        return false;
    }
    let left_count = left
        .iter()
        .copied()
        .max()
        .map_or(0, |block| block as usize + 1);
    let right_count = right
        .iter()
        .copied()
        .max()
        .map_or(0, |block| block as usize + 1);
    if left_count != right_count {
        return false;
    }
    let mut left_to_right = vec![u32::MAX; left_count];
    let mut right_to_left = vec![u32::MAX; right_count];
    for (&left_block, &right_block) in left.iter().zip(right) {
        let left_slot = &mut left_to_right[left_block as usize];
        let right_slot = &mut right_to_left[right_block as usize];
        if (*left_slot != u32::MAX && *left_slot != right_block)
            || (*right_slot != u32::MAX && *right_slot != left_block)
        {
            return false;
        }
        *left_slot = right_block;
        *right_slot = left_block;
    }
    true
}

fn build_separators(
    presentation: &FinitePresentation,
    classes: &[u32],
) -> Result<SeparatorPool, ObservationalError> {
    let mut records = Vec::new();
    let mut paths = Vec::new();
    match visit_separators(presentation, classes, |mut record, path| {
        record.path_start = u32::try_from(paths.len()).map_err(|_| ObservationalError::Overflow)?;
        paths.extend_from_slice(path);
        records.push(record);
        Ok::<_, ObservationalError>(())
    }) {
        Ok(_) => {}
        Err(SeparatorStreamError::Compilation(error)) | Err(SeparatorStreamError::Sink(error)) => {
            return Err(error)
        }
    }
    Ok((records.into_boxed_slice(), paths.into_boxed_slice()))
}

/// Emit the exhaustive concrete-pair audit in canonical sort/left/right order
/// without retaining its records or paths in the compiled quotient.
///
/// This bounds evidence-generation residency but not the quadratic number of
/// records or the cost of finding each distinguishing path.
pub fn stream_exhaustive_separators<E>(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
    sink: impl FnMut(SeparatorRecord, &[u32]) -> Result<(), E>,
) -> Result<SeparatorStreamMetrics, SeparatorStreamError<E>> {
    verify_compilation(presentation, compiled).map_err(SeparatorStreamError::Compilation)?;
    visit_separators(presentation, &compiled.state_classes, sink)
}

/// Compile a quotient without retaining pair evidence and stream the exhaustive
/// audit directly to an output such as `BufWriter<File>`.
pub fn compile_observational_to_separator_stream(
    presentation: &FinitePresentation,
    output: &mut impl Write,
) -> Result<(CompiledObservation, SeparatorStreamMetrics), SeparatorFileError> {
    let compiled =
        compile_observational_with_policy(presentation, CertificatePolicy::QuotientOnly)?;
    let metrics = write_verified_separator_stream(presentation, &compiled, output)?;
    Ok((compiled, metrics))
}

/// Write a framed, append-only exhaustive separator stream directly to an
/// output such as `BufWriter<File>`.
///
/// The stream has an eight-byte `ERGSEP01` header, presentation identity and
/// dimensions, one framed record/path at a time, and a zero-tagged terminal
/// count footer. An interrupted stream has no valid footer. The presentation
/// fingerprint is a fast identity tag, not a cryptographic authentication
/// mechanism.
pub fn write_exhaustive_separator_stream(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
    output: &mut impl Write,
) -> Result<SeparatorStreamMetrics, SeparatorFileError> {
    if compiled.certificate_policy != CertificatePolicy::QuotientOnly {
        return Err(SeparatorFileError::Policy);
    }
    verify_compilation(presentation, compiled)?;
    write_verified_separator_stream(presentation, compiled, output)
}

fn write_verified_separator_stream(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
    output: &mut impl Write,
) -> Result<SeparatorStreamMetrics, SeparatorFileError> {
    let fingerprint = presentation.fingerprint();
    output.write_all(SEPARATOR_STREAM_MAGIC)?;
    output.write_all(&fingerprint.low.to_le_bytes())?;
    output.write_all(&fingerprint.high.to_le_bytes())?;
    write_stream_u32(
        output,
        u32::try_from(presentation.state_count()).map_err(|_| ObservationalError::Overflow)?,
    )?;
    write_stream_u32(
        output,
        u32::try_from(compiled.class_outputs.len()).map_err(|_| ObservationalError::Overflow)?,
    )?;

    let metrics = match visit_separators(
        presentation,
        &compiled.state_classes,
        |record, path| -> Result<(), std::io::Error> {
            output.write_all(&[1])?;
            write_stream_u32(output, record.left_state)?;
            write_stream_u32(output, record.right_state)?;
            write_stream_u32(output, record.path_len)?;
            write_stream_u32(output, record.left_output)?;
            write_stream_u32(output, record.right_output)?;
            for &generator in path {
                write_stream_u32(output, generator)?;
            }
            Ok(())
        },
    ) {
        Ok(metrics) => metrics,
        Err(SeparatorStreamError::Compilation(error)) => return Err(error.into()),
        Err(SeparatorStreamError::Sink(error)) => return Err(error.into()),
    };
    output.write_all(&[0])?;
    output.write_all(
        &u64::try_from(metrics.separators)
            .map_err(|_| ObservationalError::Overflow)?
            .to_le_bytes(),
    )?;
    output.write_all(
        &u64::try_from(metrics.separator_steps)
            .map_err(|_| ObservationalError::Overflow)?
            .to_le_bytes(),
    )?;
    Ok(metrics)
}

fn write_stream_u32(output: &mut impl Write, word: u32) -> Result<(), std::io::Error> {
    output.write_all(&word.to_le_bytes())
}

/// Verify a canonical exhaustive separator stream directly from a reader
/// without retaining its records or generator paths.
pub fn verify_exhaustive_separator_stream(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
    input: &mut impl Read,
) -> Result<SeparatorStreamMetrics, SeparatorFileError> {
    if compiled.certificate_policy != CertificatePolicy::QuotientOnly {
        return Err(SeparatorFileError::Policy);
    }
    verify_compilation(presentation, compiled)?;
    let mut magic = [0_u8; 8];
    input.read_exact(&mut magic)?;
    if &magic != SEPARATOR_STREAM_MAGIC {
        return Err(SeparatorFileError::Format);
    }
    let fingerprint = presentation.fingerprint();
    if read_stream_u64(input)? != fingerprint.low
        || read_stream_u64(input)? != fingerprint.high
        || read_stream_u32(input)? as usize != presentation.state_count()
        || read_stream_u32(input)? as usize != compiled.class_outputs.len()
    {
        return Err(SeparatorFileError::Format);
    }

    let mut metrics = SeparatorStreamMetrics::default();
    for sort in presentation.sorts.iter().copied() {
        for expected_left in sort.start..sort.end() {
            for expected_right in expected_left + 1..sort.end() {
                if compiled.state_classes[expected_left as usize]
                    == compiled.state_classes[expected_right as usize]
                {
                    continue;
                }
                if read_stream_byte(input)? != 1 {
                    return Err(SeparatorFileError::Format);
                }
                let left = read_stream_u32(input)?;
                let right = read_stream_u32(input)?;
                let path_len = read_stream_u32(input)?;
                let claimed_left_output = read_stream_u32(input)?;
                let claimed_right_output = read_stream_u32(input)?;
                if left != expected_left || right != expected_right {
                    return Err(SeparatorFileError::Format);
                }
                let mut terminal_left = left;
                let mut terminal_right = right;
                for _ in 0..path_len {
                    let generator = read_stream_u32(input)?;
                    terminal_left = presentation
                        .transition(generator, terminal_left)
                        .ok_or(SeparatorFileError::Format)?;
                    terminal_right = presentation
                        .transition(generator, terminal_right)
                        .ok_or(SeparatorFileError::Format)?;
                }
                let left_output = presentation.observations[terminal_left as usize];
                let right_output = presentation.observations[terminal_right as usize];
                if left_output == right_output
                    || left_output != claimed_left_output
                    || right_output != claimed_right_output
                {
                    return Err(SeparatorFileError::Format);
                }
                metrics.separators = metrics
                    .separators
                    .checked_add(1)
                    .ok_or(ObservationalError::Overflow)?;
                metrics.separator_steps = metrics
                    .separator_steps
                    .checked_add(path_len as usize)
                    .ok_or(ObservationalError::Overflow)?;
            }
        }
    }
    if read_stream_byte(input)? != 0
        || read_stream_u64(input)?
            != u64::try_from(metrics.separators).map_err(|_| ObservationalError::Overflow)?
        || read_stream_u64(input)?
            != u64::try_from(metrics.separator_steps).map_err(|_| ObservationalError::Overflow)?
    {
        return Err(SeparatorFileError::Format);
    }
    let mut trailing = [0_u8; 1];
    if input.read(&mut trailing)? != 0 {
        return Err(SeparatorFileError::Format);
    }
    Ok(metrics)
}

fn read_stream_byte(input: &mut impl Read) -> Result<u8, std::io::Error> {
    let mut byte = [0_u8; 1];
    input.read_exact(&mut byte)?;
    Ok(byte[0])
}

fn read_stream_u32(input: &mut impl Read) -> Result<u32, std::io::Error> {
    let mut bytes = [0_u8; 4];
    input.read_exact(&mut bytes)?;
    Ok(u32::from_le_bytes(bytes))
}

fn read_stream_u64(input: &mut impl Read) -> Result<u64, std::io::Error> {
    let mut bytes = [0_u8; 8];
    input.read_exact(&mut bytes)?;
    Ok(u64::from_le_bytes(bytes))
}

fn visit_separators<E>(
    presentation: &FinitePresentation,
    classes: &[u32],
    mut sink: impl FnMut(SeparatorRecord, &[u32]) -> Result<(), E>,
) -> Result<SeparatorStreamMetrics, SeparatorStreamError<E>> {
    let mut metrics = SeparatorStreamMetrics::default();
    let initial_capacity = presentation
        .sorts
        .iter()
        .map(|sort| sort.len as usize)
        .max()
        .unwrap_or(0);
    let mut search = SeparatorSearch::with_capacity(initial_capacity);
    for sort in presentation.sorts.iter().copied() {
        for left in sort.start..sort.end() {
            for right in left + 1..sort.end() {
                if classes[left as usize] == classes[right as usize] {
                    continue;
                }
                let (path, left_output, right_output) =
                    distinguishing_path(presentation, left, right, &mut search)
                        .ok_or(ObservationalError::MissingSeparator { left, right })
                        .map_err(SeparatorStreamError::Compilation)?;
                let path_len = u32::try_from(path.len())
                    .map_err(|_| SeparatorStreamError::Compilation(ObservationalError::Overflow))?;
                let record = SeparatorRecord {
                    left_state: left,
                    right_state: right,
                    path_start: 0,
                    path_len,
                    left_output,
                    right_output,
                };
                sink(record, path).map_err(SeparatorStreamError::Sink)?;
                metrics.separators =
                    metrics
                        .separators
                        .checked_add(1)
                        .ok_or(SeparatorStreamError::Compilation(
                            ObservationalError::Overflow,
                        ))?;
                metrics.separator_steps = metrics.separator_steps.checked_add(path.len()).ok_or(
                    SeparatorStreamError::Compilation(ObservationalError::Overflow),
                )?;
            }
        }
    }
    Ok(metrics)
}

#[derive(Clone, Copy)]
struct SeparatorSearchNode {
    left: u32,
    right: u32,
    parent: u32,
    generator: u32,
}

struct SeparatorSearch {
    nodes: Vec<SeparatorSearchNode>,
    visited: FxHashMap<u64, u32>,
    path: Vec<u32>,
}

impl SeparatorSearch {
    fn with_capacity(capacity: usize) -> Self {
        Self {
            nodes: Vec::with_capacity(capacity),
            visited: FxHashMap::with_capacity_and_hasher(capacity, Default::default()),
            path: Vec::with_capacity(capacity),
        }
    }

    fn clear(&mut self) {
        self.nodes.clear();
        self.visited.clear();
        self.path.clear();
    }
}

#[inline]
fn pair_key(left: u32, right: u32) -> u64 {
    (u64::from(left) << 32) | u64::from(right)
}

fn distinguishing_path<'a>(
    presentation: &FinitePresentation,
    left: u32,
    right: u32,
    search: &'a mut SeparatorSearch,
) -> Option<(&'a [u32], u32, u32)> {
    search.clear();
    search.nodes.push(SeparatorSearchNode {
        left,
        right,
        parent: u32::MAX,
        generator: u32::MAX,
    });
    search.visited.insert(pair_key(left, right), 0);
    let mut head = 0_usize;
    while head < search.nodes.len() {
        let node = search.nodes[head];
        let left_output = presentation.observations[node.left as usize];
        let right_output = presentation.observations[node.right as usize];
        if left_output != right_output {
            let mut cursor = head as u32;
            while search.nodes[cursor as usize].parent != u32::MAX {
                let certificate = search.nodes[cursor as usize];
                search.path.push(certificate.generator);
                cursor = certificate.parent;
            }
            search.path.reverse();
            return Some((&search.path, left_output, right_output));
        }
        let sort = state_sort(&presentation.sorts, node.left)?;
        if state_sort(&presentation.sorts, node.right)? != sort {
            return None;
        }
        for (generator, _) in presentation.generators_from(sort) {
            let next_left = presentation.transition(generator, node.left)?;
            let next_right = presentation.transition(generator, node.right)?;
            let next = u32::try_from(search.nodes.len()).ok()?;
            if let std::collections::hash_map::Entry::Vacant(entry) =
                search.visited.entry(pair_key(next_left, next_right))
            {
                entry.insert(next);
                search.nodes.push(SeparatorSearchNode {
                    left: next_left,
                    right: next_right,
                    parent: head as u32,
                    generator,
                });
            }
        }
        head += 1;
    }
    None
}

pub fn verify_compilation(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
) -> Result<(), ObservationalError> {
    verify_compilation_with_inverse(presentation, compiled, None)
}

fn verify_compilation_with_inverse(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
    verification_inverse: Option<&InverseIndex>,
) -> Result<(), ObservationalError> {
    if compiled.class_ranges.len() != presentation.sorts.len()
        || compiled.state_classes.len() != presentation.state_count()
        || compiled.generator_records.len() != presentation.generators.len()
        || compiled.class_outputs.len() != compiled.class_representatives.len()
    {
        return Err(ObservationalError::CompiledShape);
    }
    let class_count = compiled.class_outputs.len();
    let mut next_class = 0_u32;
    for range in compiled.class_ranges.iter().copied() {
        let Some(end) = range.start.checked_add(range.len) else {
            return Err(ObservationalError::CompiledShape);
        };
        if range.start != next_class || end as usize > class_count {
            return Err(ObservationalError::CompiledShape);
        }
        next_class = end;
    }
    if next_class as usize != class_count {
        return Err(ObservationalError::CompiledShape);
    }
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
        let source_classes = compiled.class_ranges[generator.source_sort as usize];
        let target_classes = compiled.class_ranges[generator.target_sort as usize];
        if target_classes.len == 1 {
            for class in source_classes.start..source_classes.end() {
                if compiled.transition(generator_index as u32, class) != Some(target_classes.start)
                {
                    return Err(ObservationalError::QuotientTransition {
                        generator: generator_index as u32,
                        class,
                    });
                }
            }
            continue;
        }
        let source = presentation.sorts[generator.source_sort as usize];
        let mut expected = vec![u32::MAX; source_classes.len as usize];
        for state in source.start..source.end() {
            let class = compiled.state_classes[state as usize];
            let target = presentation
                .transition(generator_index as u32, state)
                .ok_or(ObservationalError::CompiledShape)?;
            let target_class = compiled.state_classes[target as usize];
            let slot = &mut expected[(class - source_classes.start) as usize];
            if *slot != u32::MAX && *slot != target_class {
                return Err(ObservationalError::GeneratorMismatch {
                    generator: generator_index as u32,
                    class,
                });
            }
            *slot = target_class;
        }
        for (local, target) in expected.into_iter().enumerate() {
            let class = source_classes.start + local as u32;
            if compiled.transition(generator_index as u32, class) != Some(target) {
                return Err(ObservationalError::QuotientTransition {
                    generator: generator_index as u32,
                    class,
                });
            }
        }
    }

    match compiled.certificate_policy {
        CertificatePolicy::QuotientOnly => {
            if !compiled.split_records.is_empty()
                || !compiled.multiway_records.is_empty()
                || !compiled.separators.is_empty()
                || !compiled.separator_paths.is_empty()
            {
                return Err(ObservationalError::CompiledShape);
            }
            let reference = compile_observational_with_policy(
                presentation,
                CertificatePolicy::SplitTranscript,
            )?;
            if reference.state_classes != compiled.state_classes
                || reference.class_ranges != compiled.class_ranges
                || reference.class_outputs != compiled.class_outputs
                || reference.generator_records != compiled.generator_records
                || reference.generator_transitions != compiled.generator_transitions
            {
                return Err(ObservationalError::Partition);
            }
            return Ok(());
        }
        CertificatePolicy::SplitTranscript => {
            if !compiled.multiway_records.is_empty()
                || !compiled.separators.is_empty()
                || !compiled.separator_paths.is_empty()
            {
                return Err(ObservationalError::CompiledShape);
            }
            return if let Some(inverse) = verification_inverse {
                // This index was just constructed from the already-validated
                // presentation and consumed by the compiler. Replay the
                // transcript against it directly. The public verifier still
                // rebuilds and audits every inverse edge before replay.
                verify_split_transcript_with_inverse(presentation, compiled, inverse)
            } else {
                verify_split_transcript(presentation, compiled)
            };
        }
        CertificatePolicy::MultiwayTranscript => {
            if !compiled.split_records.is_empty()
                || !compiled.separators.is_empty()
                || !compiled.separator_paths.is_empty()
            {
                return Err(ObservationalError::CompiledShape);
            }
            let (classes, ranges, records, inverse) = minimize_partition_multiway(presentation)?;
            if verification_inverse.is_none() {
                if let Some(inverse) = inverse {
                    inverse.verify(presentation)?;
                }
            }
            if classes != compiled.state_classes
                || ranges != compiled.class_ranges
                || records != compiled.multiway_records
            {
                return Err(ObservationalError::Partition);
            }
            return Ok(());
        }
        CertificatePolicy::AdaptiveTranscript => {
            return Err(ObservationalError::CompiledShape);
        }
        CertificatePolicy::ExhaustivePairAudit => {
            if !compiled.split_records.is_empty() || !compiled.multiway_records.is_empty() {
                return Err(ObservationalError::CompiledShape);
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
    fn layered_oracle_compiler_matches_generic_minimization() {
        let counts = [4_u32, 5, 3];
        let layered_generators = [
            LayeredGeneratorSpec {
                source_sort: 0,
                target_sort: 1,
            },
            LayeredGeneratorSpec {
                source_sort: 0,
                target_sort: 1,
            },
            LayeredGeneratorSpec {
                source_sort: 1,
                target_sort: 2,
            },
            LayeredGeneratorSpec {
                source_sort: 0,
                target_sort: 2,
            },
        ];
        let local_transition = |generator: u32, state: u32| match generator {
            0 => (state + 1) % 5,
            1 => (2 * state + 1) % 5,
            2 => (state + 1) % 3,
            3 => (2 * state) % 3,
            _ => unreachable!(),
        };
        let observation = |sort: u32, state: u32| (sort + state * state) % 3;
        let direct = compile_layered_observational(
            &counts,
            &layered_generators,
            observation,
            local_transition,
        )
        .unwrap();
        verify_layered_observational(
            &counts,
            &layered_generators,
            observation,
            local_transition,
            &direct,
        )
        .unwrap();
        let mut corrupted = direct.clone();
        corrupted.generator_transitions[0] = u32::MAX;
        assert!(verify_layered_observational(
            &counts,
            &layered_generators,
            observation,
            local_transition,
            &corrupted,
        )
        .is_err());

        let raw_ranges = [0_u32, 4, 9];
        let observations = counts
            .iter()
            .enumerate()
            .flat_map(|(sort, &count)| (0..count).map(move |state| observation(sort as u32, state)))
            .collect::<Vec<_>>();
        let generators = layered_generators
            .iter()
            .enumerate()
            .map(|(generator, spec)| GeneratorSpec {
                source_sort: spec.source_sort,
                target_sort: spec.target_sort,
                transitions: (0..counts[spec.source_sort as usize])
                    .map(|state| {
                        raw_ranges[spec.target_sort as usize]
                            + local_transition(generator as u32, state)
                    })
                    .collect(),
            })
            .collect::<Vec<_>>();
        let presentation = FinitePresentation::new(counts, observations, generators).unwrap();
        let generic =
            compile_observational_with_policy(&presentation, CertificatePolicy::QuotientOnly)
                .unwrap();
        assert_eq!(direct.metrics().classes, generic.metrics().classes);
        for (sort, range) in presentation.sorts().iter().enumerate() {
            let class_range = direct.class_ranges()[sort];
            for left in range.start..range.end() {
                assert!(
                    class_range.contains(direct.state_classes()[left as usize]),
                    "sort={sort} state={left} class={}",
                    direct.state_classes()[left as usize]
                );
                for right in range.start..range.end() {
                    assert_eq!(
                        direct.state_classes()[left as usize]
                            == direct.state_classes()[right as usize],
                        generic.state_classes()[left as usize]
                            == generic.state_classes()[right as usize]
                    );
                }
            }
        }
        for (class, &representative) in direct.class_representatives().iter().enumerate() {
            assert_eq!(
                direct.state_classes()[representative as usize],
                class as u32,
                "class={class} representative={representative}"
            );
        }
        verify_compilation(&presentation, &direct).unwrap();
        let mut audit = Vec::new();
        write_layered_audit(
            &counts,
            &layered_generators,
            observation,
            local_transition,
            &direct,
            &mut audit,
        )
        .unwrap();
        let frozen = direct.into_frozen(&counts, &[0]).unwrap();
        verify_frozen_layered_audit(&frozen, &mut std::io::Cursor::new(&audit)).unwrap();
        let mut corrupted_audit = audit.clone();
        corrupted_audit[0] ^= 1;
        assert!(
            verify_frozen_layered_audit(&frozen, &mut std::io::Cursor::new(corrupted_audit))
                .is_err()
        );
        let mut corrupted_record = audit.clone();
        let last = corrupted_record.len() - 1;
        corrupted_record[last] ^= 1;
        assert!(
            verify_frozen_layered_audit(&frozen, &mut std::io::Cursor::new(corrupted_record))
                .is_err()
        );
        let mut truncated_audit = audit.clone();
        truncated_audit.pop();
        assert!(
            verify_frozen_layered_audit(&frozen, &mut std::io::Cursor::new(truncated_audit))
                .is_err()
        );
        let mut trailing_audit = audit;
        trailing_audit.push(0);
        assert!(
            verify_frozen_layered_audit(&frozen, &mut std::io::Cursor::new(trailing_audit))
                .is_err()
        );
        assert_eq!(frozen.storage().entry_states, counts[0] as usize);
        assert!(frozen.storage().payload_bytes < generic.storage().quotient_bytes);
        for state in 0..counts[0] {
            let class = frozen.entry_class(0, state).unwrap();
            assert_eq!(class, generic.state_classes()[state as usize]);
            let target = frozen.transition(0, class).unwrap();
            assert_eq!(
                frozen.output(target),
                Some(generic.class_outputs()[target as usize])
            );
            assert!(frozen.representative(target).is_some());
        }
    }

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
    fn quotient_only_matches_exhaustive_without_pair_evidence() {
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
        let exhaustive = compile_observational(&presentation).unwrap();
        let quotient_only =
            compile_observational_with_policy(&presentation, CertificatePolicy::QuotientOnly)
                .unwrap();
        let split =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();

        assert_eq!(
            quotient_only.certificate_policy(),
            CertificatePolicy::QuotientOnly
        );
        assert_eq!(quotient_only.state_classes(), exhaustive.state_classes());
        assert_eq!(quotient_only.class_ranges(), exhaustive.class_ranges());
        assert_eq!(quotient_only.class_outputs(), exhaustive.class_outputs());
        assert_eq!(quotient_only.storage().certificate_bytes, 0);
        assert_eq!(quotient_only.metrics().separators, 0);
        let (reference_classes, reference_ranges, reference_rounds) =
            minimize_partition(&presentation).unwrap();
        assert_eq!(quotient_only.state_classes(), &reference_classes[..]);
        assert_eq!(quotient_only.class_ranges(), &reference_ranges[..]);
        assert_eq!(reference_rounds, 1);
        verify_compilation(&presentation, &quotient_only).unwrap();
        assert_eq!(split.state_classes(), exhaustive.state_classes());
        assert_eq!(split.split_records().len(), 1);
        assert_eq!(split.storage().certificate_bytes, 16);
        verify_compilation(&presentation, &split).unwrap();

        let mut corrupt_split = split.clone();
        corrupt_split.split_records[0].new_block += 1;
        assert!(matches!(
            verify_compilation(&presentation, &corrupt_split),
            Err(ObservationalError::CompiledShape)
        ));
        let mut missing_split = split.clone();
        missing_split.split_records = Box::default();
        assert!(matches!(
            verify_compilation(&presentation, &missing_split),
            Err(ObservationalError::Partition)
        ));
        let mut unknown_generator = split.clone();
        unknown_generator.split_records[0].generator = u32::MAX;
        assert!(matches!(
            verify_compilation(&presentation, &unknown_generator),
            Err(ObservationalError::CompiledShape)
        ));

        let mut stream = Vec::new();
        let (streamed_compiled, streamed) =
            compile_observational_to_separator_stream(&presentation, &mut stream).unwrap();
        assert_eq!(
            streamed_compiled.state_classes(),
            exhaustive.state_classes()
        );
        assert_eq!(streamed_compiled.storage().certificate_bytes, 0);
        assert_eq!(streamed.separators, exhaustive.metrics().separators);
        assert_eq!(
            streamed.separator_steps,
            exhaustive.metrics().separator_steps
        );
        assert!(stream.starts_with(SEPARATOR_STREAM_MAGIC));
        let mut footer = vec![0];
        footer.extend_from_slice(&(streamed.separators as u64).to_le_bytes());
        footer.extend_from_slice(&(streamed.separator_steps as u64).to_le_bytes());
        assert!(stream.ends_with(&footer));
        assert_eq!(
            verify_exhaustive_separator_stream(
                &presentation,
                &streamed_compiled,
                &mut stream.as_slice(),
            )
            .unwrap(),
            streamed
        );
        let last = stream.len() - 1;
        stream[last] ^= 1;
        assert!(matches!(
            verify_exhaustive_separator_stream(
                &presentation,
                &streamed_compiled,
                &mut stream.as_slice(),
            ),
            Err(SeparatorFileError::Format)
        ));
        assert!(matches!(
            write_exhaustive_separator_stream(&presentation, &exhaustive, &mut Vec::new()),
            Err(SeparatorFileError::Policy)
        ));
    }

    #[test]
    fn separator_arena_reconstructs_multistep_paths_in_forward_order() {
        let presentation = FinitePresentation::new(
            [8],
            [0, 0, 0, 0, 0, 0, 0, 1],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: [1, 2, 3, 3, 5, 6, 7, 7].into(),
            }],
        )
        .unwrap();
        let mut search = SeparatorSearch::with_capacity(8);
        let (path, left_output, right_output) =
            distinguishing_path(&presentation, 0, 4, &mut search).unwrap();
        assert_eq!(path, &[0, 0, 0]);
        assert_eq!((left_output, right_output), (0, 1));
    }

    #[test]
    fn quotient_only_uses_the_small_half_kernel_on_a_long_chain() {
        const STATES: u32 = 16_384;
        let mut observations = vec![0_u32; STATES as usize];
        observations[STATES as usize - 1] = 1;
        let presentation = FinitePresentation::new(
            [STATES],
            observations,
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0..STATES)
                    .map(|state| (state + 1).min(STATES - 1))
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
            }],
        )
        .unwrap();
        let compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::QuotientOnly)
                .unwrap();
        assert_eq!(compiled.class_outputs().len(), STATES as usize);
        assert!(compiled.split_records().is_empty());
        verify_compilation(&presentation, &compiled).unwrap();
    }

    #[test]
    fn verifier_rejects_classes_shared_across_sorts() {
        let presentation = FinitePresentation::new([1, 1], vec![0, 0], []).unwrap();
        let mut compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::QuotientOnly)
                .unwrap();
        compiled.class_ranges = vec![
            SortRange { start: 0, len: 1 },
            SortRange { start: 0, len: 1 },
        ]
        .into_boxed_slice();
        compiled.state_classes = vec![0, 0].into_boxed_slice();
        compiled.class_outputs = vec![0].into_boxed_slice();
        compiled.class_representatives = vec![0].into_boxed_slice();

        assert_eq!(
            verify_compilation(&presentation, &compiled),
            Err(ObservationalError::CompiledShape)
        );
    }

    #[test]
    fn split_transcript_handles_cycles_and_empty_sorts() {
        let cycle = FinitePresentation::new(
            [3],
            vec![1, 0, 0],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: vec![1, 2, 0].into_boxed_slice(),
            }],
        )
        .unwrap();
        let compiled =
            compile_observational_with_policy(&cycle, CertificatePolicy::SplitTranscript).unwrap();
        assert_eq!(compiled.metrics().classes, 3);
        assert_eq!(compiled.split_records().len(), 1);
        verify_compilation(&cycle, &compiled).unwrap();

        let empty_sort = FinitePresentation::new([0, 2], vec![0, 1], []).unwrap();
        let compiled =
            compile_observational_with_policy(&empty_sort, CertificatePolicy::SplitTranscript)
                .unwrap();
        assert_eq!(compiled.metrics().classes, 2);
        assert!(compiled.split_records().is_empty());
        verify_compilation(&empty_sort, &compiled).unwrap();
    }

    #[test]
    fn multiway_transcript_replays_and_rejects_corruption() {
        let presentation = FinitePresentation::new(
            [6],
            vec![0, 0, 0, 0, 0, 1],
            [
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![1, 2, 3, 4, 5, 5].into_boxed_slice(),
                },
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![2, 3, 4, 5, 5, 5].into_boxed_slice(),
                },
            ],
        )
        .unwrap();
        let mut compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::MultiwayTranscript)
                .unwrap();
        assert_eq!(compiled.class_outputs().len(), 6);
        assert!(!compiled.multiway_records().is_empty());
        verify_compilation(&presentation, &compiled).unwrap();
        compiled.multiway_records[0].new_block_count += 1;
        assert_eq!(
            verify_compilation(&presentation, &compiled),
            Err(ObservationalError::Partition)
        );
    }

    #[test]
    fn adaptive_transcript_dispatch_is_conservative() {
        const STATES: u32 = 4_096;
        let observations = (0..STATES)
            .map(|state| u32::from(state == STATES - 1))
            .collect::<Vec<_>>();
        let four_generators = (0..4)
            .map(|shift| GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0..STATES)
                    .map(|state| (state + shift + 1) % STATES)
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
            })
            .collect::<Vec<_>>();
        let random_shape =
            FinitePresentation::new([STATES], observations.clone(), four_generators).unwrap();
        assert!(multiway_is_admitted(&random_shape));
        let adaptive =
            compile_observational_with_policy(&random_shape, CertificatePolicy::AdaptiveTranscript)
                .unwrap();
        assert_eq!(
            adaptive.certificate_policy(),
            CertificatePolicy::MultiwayTranscript
        );

        let chain = FinitePresentation::new(
            [STATES],
            observations,
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0..STATES)
                    .map(|state| (state + 1).min(STATES - 1))
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
            }],
        )
        .unwrap();
        assert!(!multiway_is_admitted(&chain));
        let adaptive =
            compile_observational_with_policy(&chain, CertificatePolicy::AdaptiveTranscript)
                .unwrap();
        assert_eq!(
            adaptive.certificate_policy(),
            CertificatePolicy::SplitTranscript
        );
    }

    #[test]
    fn theorem_reduction_removes_refinement_neutral_generators() {
        const STATES: u32 = 4_096;
        let shift = |amount| GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: (0..STATES)
                .map(|state| (state + amount) % STATES)
                .collect::<Vec<_>>()
                .into_boxed_slice(),
        };
        let mut observations = vec![0_u32; STATES as usize + 2];
        observations[STATES as usize - 1] = 1;
        let presentation = FinitePresentation::new(
            [STATES, 2],
            observations,
            [
                shift(1),
                shift(2),
                shift(1),
                shift(3),
                shift(0),
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![0; STATES as usize].into_boxed_slice(),
                },
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 1,
                    transitions: (0..STATES)
                        .map(|state| STATES + state % 2)
                        .collect::<Vec<_>>()
                        .into_boxed_slice(),
                },
                GeneratorSpec {
                    source_sort: 1,
                    target_sort: 1,
                    transitions: vec![STATES + 1, STATES].into_boxed_slice(),
                },
            ],
        )
        .unwrap();

        let refinement = RefinementGenerators::new(&presentation).unwrap();
        assert_eq!(refinement.ids_from(0), &[0]);
        assert!(refinement.ids_from(1).is_empty());
        assert!(multiway_is_admitted(&presentation));

        let (multiway_classes, multiway_ranges, _, _) =
            minimize_partition_multiway(&presentation).unwrap();
        let (worklist_classes, worklist_ranges, _, _) =
            minimize_partition_worklist(&presentation).unwrap();
        assert_eq!(multiway_classes, worklist_classes);
        assert_eq!(multiway_ranges, worklist_ranges);
        let compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::AdaptiveTranscript)
                .unwrap();
        assert_eq!(
            compiled.certificate_policy(),
            CertificatePolicy::MultiwayTranscript
        );
        verify_compilation(&presentation, &compiled).unwrap();
    }

    #[test]
    fn binary_backend_indexes_only_the_exact_generator_basis() {
        const STATES: u32 = 4_096;
        let affine = |multiplier: u32, offset: u32| GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: (0..STATES)
                .map(|state| (state.wrapping_mul(multiplier) + offset) & (STATES - 1))
                .collect::<Vec<_>>()
                .into_boxed_slice(),
        };
        let bases = [(3, 1), (5, 7), (9, 11), (13, 17), (17, 19)];
        let generators = bases
            .into_iter()
            .cycle()
            .take(20)
            .map(|(multiplier, offset)| affine(multiplier, offset))
            .collect::<Vec<_>>();
        let observations = (0..STATES)
            .map(|state| u32::from(state == STATES - 1))
            .collect::<Vec<_>>();
        let presentation = FinitePresentation::new([STATES], observations, generators).unwrap();
        let refinement = RefinementGenerators::new(&presentation).unwrap();
        assert_eq!(refinement.ids.len(), bases.len());
        assert!(multiway_is_admitted(&presentation));

        let full_inverse = InverseIndex::new(&presentation).unwrap();
        let basis_inverse = InverseIndex::new_prepared(&presentation, Some(&refinement)).unwrap();
        assert_eq!(full_inverse.sources.len(), 20 * STATES as usize);
        assert_eq!(basis_inverse.sources.len(), bases.len() * STATES as usize);

        let compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();
        assert_eq!(
            compiled.certificate_policy(),
            CertificatePolicy::SplitTranscript
        );
        assert_eq!(
            compiled.generator_transitions.len(),
            bases.len() * STATES as usize
        );
        verify_compilation(&presentation, &compiled).unwrap();
    }

    #[test]
    fn deferred_verification_retains_replayable_adaptive_evidence() {
        let presentation = FinitePresentation::new(
            [8],
            vec![0, 0, 0, 0, 0, 0, 0, 1],
            [
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![1, 2, 3, 4, 5, 6, 7, 7].into_boxed_slice(),
                },
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![2, 3, 4, 5, 6, 7, 7, 7].into_boxed_slice(),
                },
            ],
        )
        .unwrap();
        let immediate =
            compile_observational_with_policy(&presentation, CertificatePolicy::MultiwayTranscript)
                .unwrap();
        let deferred = compile_observational_with_deferred_verification(
            &presentation,
            CertificatePolicy::MultiwayTranscript,
        )
        .unwrap();
        assert_eq!(deferred.state_classes(), immediate.state_classes());
        assert_eq!(deferred.multiway_records(), immediate.multiway_records());
        verify_compilation(&presentation, &deferred).unwrap();
    }

    #[test]
    fn compiled_quotient_synthesizes_a_shortest_typed_generator_word() {
        let presentation = FinitePresentation::new(
            [5, 1],
            vec![0, 1, 2, 3, 4, 9],
            [
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![1, 2, 3, 4, 4].into_boxed_slice(),
                },
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![2, 3, 4, 4, 4].into_boxed_slice(),
                },
            ],
        )
        .unwrap();
        let compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();
        let start = compiled.state_classes()[0];
        let target = compiled.state_classes()[4];
        let word = compiled
            .shortest_generator_word(start, target)
            .unwrap()
            .unwrap();
        assert_eq!(&*word, &[1, 1]);
        let reached = word
            .iter()
            .try_fold(start, |class, &generator| {
                compiled.transition(generator, class)
            })
            .unwrap();
        assert_eq!(reached, target);
        let weighted = compiled
            .shortest_weighted_generator_word(start, target, &[1, 3])
            .unwrap()
            .unwrap();
        assert_eq!(weighted.cost, 4);
        assert_eq!(&*weighted.generators, &[0, 0, 0, 0]);
        assert_eq!(
            compiled
                .shortest_generator_word(start, compiled.state_classes()[5])
                .unwrap(),
            None
        );
    }

    #[test]
    fn weighted_plan_collapses_parallel_contexts_and_targets_an_output() {
        let presentation = FinitePresentation::new(
            [4],
            vec![0, 0, 0, 1],
            [
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![1, 2, 3, 3].into_boxed_slice(),
                },
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![1, 2, 3, 3].into_boxed_slice(),
                },
                GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: vec![2, 3, 3, 3].into_boxed_slice(),
                },
            ],
        )
        .unwrap();
        let compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();
        let plan = compiled
            .compile_weighted_generator_plan(&[9, 2, 5])
            .unwrap();
        assert_eq!(plan.uncollapsed_edge_count(), 12);
        assert!(plan.edge_count() < plan.uncollapsed_edge_count());

        let start = compiled.state_classes()[0];
        let word = plan.shortest_word_to_output(start, 1).unwrap().unwrap();
        assert_eq!(word.cost, 6);
        assert_eq!(&*word.generators, &[1, 1, 1]);
        let final_state = word
            .generators
            .iter()
            .try_fold(0_u32, |state, &generator| {
                presentation.transition(generator, state)
            })
            .unwrap();
        assert_eq!(presentation.observations()[final_state as usize], 1);
    }

    #[test]
    fn split_transcript_matches_bounded_cyclic_corpus() {
        for seed in 0_u64..128 {
            let mut state = seed + 1;
            let states = 1 + (next_fixture_word(&mut state) % 8);
            let generator_count = 1 + (next_fixture_word(&mut state) % 3);
            let observations = (0..states)
                .map(|_| next_fixture_word(&mut state) % 3)
                .collect::<Vec<_>>();
            let generators = (0..generator_count)
                .map(|_| GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: (0..states)
                        .map(|_| next_fixture_word(&mut state) % states)
                        .collect::<Vec<_>>()
                        .into_boxed_slice(),
                })
                .collect::<Vec<_>>();
            let presentation = FinitePresentation::new([states], observations, generators).unwrap();
            let exhaustive = compile_observational(&presentation).unwrap();
            let split = compile_observational_with_policy(
                &presentation,
                CertificatePolicy::SplitTranscript,
            )
            .unwrap();
            let quotient =
                compile_observational_with_policy(&presentation, CertificatePolicy::QuotientOnly)
                    .unwrap();
            let (multiway_classes, multiway_ranges, _, _) =
                minimize_partition_multiway(&presentation).unwrap();
            assert_eq!(split.state_classes(), exhaustive.state_classes());
            assert_eq!(quotient.state_classes(), exhaustive.state_classes());
            assert_eq!(&*multiway_classes, exhaustive.state_classes());
            assert_eq!(&*multiway_ranges, exhaustive.class_ranges());
            assert!(split.split_records().len() <= split.metrics().classes);
            verify_compilation(&presentation, &split).unwrap();
        }
    }

    #[test]
    fn split_transcript_matches_bounded_typed_corpus() {
        for seed in 128_u64..384 {
            let mut fixture = seed + 1;
            let sort_count = 1 + (next_fixture_word(&mut fixture) % 4);
            let sort_sizes = (0..sort_count)
                .map(|_| next_fixture_word(&mut fixture) % 5)
                .collect::<Vec<_>>();
            let state_count = sort_sizes.iter().sum::<u32>();
            let observations = (0..state_count)
                .map(|_| next_fixture_word(&mut fixture) % 4)
                .collect::<Vec<_>>();
            let starts = sort_sizes
                .iter()
                .scan(0_u32, |start, &len| {
                    let current = *start;
                    *start += len;
                    Some(current)
                })
                .collect::<Vec<_>>();
            let mut generators = Vec::new();
            for _ in 0..1 + (next_fixture_word(&mut fixture) % 8) {
                let source_sort = next_fixture_word(&mut fixture) % sort_count;
                let target_sort = next_fixture_word(&mut fixture) % sort_count;
                let source_len = sort_sizes[source_sort as usize];
                let target_len = sort_sizes[target_sort as usize];
                if source_len != 0 && target_len == 0 {
                    continue;
                }
                let target_start = starts[target_sort as usize];
                let transitions = (0..source_len)
                    .map(|_| target_start + next_fixture_word(&mut fixture) % target_len.max(1))
                    .collect::<Vec<_>>()
                    .into_boxed_slice();
                generators.push(GeneratorSpec {
                    source_sort,
                    target_sort,
                    transitions,
                });
            }
            let presentation =
                FinitePresentation::new(sort_sizes, observations, generators).unwrap();
            let reference =
                compile_observational_with_policy(&presentation, CertificatePolicy::QuotientOnly)
                    .unwrap();
            let split = compile_observational_with_policy(
                &presentation,
                CertificatePolicy::SplitTranscript,
            )
            .unwrap();
            let (multiway_classes, multiway_ranges, _, _) =
                minimize_partition_multiway(&presentation).unwrap();
            assert_eq!(split.state_classes(), reference.state_classes());
            assert_eq!(split.class_ranges(), reference.class_ranges());
            assert_eq!(&*multiway_classes, reference.state_classes());
            assert_eq!(&*multiway_ranges, reference.class_ranges());
            verify_compilation(&presentation, &split).unwrap();
        }
    }

    #[test]
    fn sparse_scheduler_handles_target_domain_far_larger_than_edge_set() {
        const TARGET_STATES: u32 = 1 << 18;
        const GENERATORS: usize = 32;
        let mut observations = vec![0_u32; 2 + TARGET_STATES as usize];
        let last_observation = observations.len() - 1;
        observations[last_observation] = 1;
        let generators = (0..GENERATORS).map(|_| GeneratorSpec {
            source_sort: 0,
            target_sort: 1,
            transitions: vec![2, TARGET_STATES + 1].into_boxed_slice(),
        });
        let presentation =
            FinitePresentation::new([2, TARGET_STATES], observations, generators).unwrap();
        assert_eq!(
            pending_mode(&presentation, None).unwrap(),
            PendingMode::Sparse
        );
        let inverse = InverseIndex::new(&presentation).unwrap();
        inverse.verify(&presentation).unwrap();
        assert!(inverse.offsets.is_empty());
        assert_eq!(inverse.targets.len(), 2 * GENERATORS);
        assert_eq!(inverse.sources.len(), 2 * GENERATORS);

        let split =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();
        assert_eq!(split.metrics().states, TARGET_STATES as usize + 2);
        assert_eq!(split.metrics().classes, 4);
        assert_eq!(split.split_records().len(), 1);
        verify_compilation(&presentation, &split).unwrap();
    }

    #[test]
    fn dense_pending_directory_is_selected_for_classical_endomap() {
        const STATES: u32 = 64;
        let mut observations = vec![0_u32; STATES as usize];
        observations[0] = 1;
        let presentation = FinitePresentation::new(
            [STATES],
            observations,
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0..STATES)
                    .map(|state| (state + 1) % STATES)
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
            }],
        )
        .unwrap();
        assert_eq!(
            pending_mode(&presentation, None).unwrap(),
            PendingMode::Dense
        );

        let split =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();
        assert_eq!(split.metrics().classes, STATES as usize);
        assert_eq!(split.split_records().len(), STATES as usize - 2);
        verify_compilation(&presentation, &split).unwrap();
    }

    #[test]
    fn sparse_pending_work_never_grows_its_reserved_storage() {
        let mut queue = VecDeque::with_capacity(4);
        let mut pending = PatriciaPending::new(4).unwrap();
        let queue_capacity = queue.capacity();
        let pending_capacity = pending.capacity();
        for block in 0..4 {
            push_split_work(
                &mut queue,
                &mut pending,
                SplitWorkItem {
                    block,
                    generator: 0,
                },
            )
            .unwrap();
        }
        assert_eq!(queue.capacity(), queue_capacity);
        assert_eq!(pending.capacity(), pending_capacity);
        assert_eq!(queue.len(), 4);
        assert_eq!(pending.len, 4);
    }

    #[test]
    fn patricia_pending_handles_the_fixed_hash_collision_family() {
        let generators = [
            92, 188, 250, 287, 342, 365, 426, 484, 505, 814, 836, 923, 967, 1_144, 1_172, 1_408,
            1_429, 1_710, 1_963, 1_993, 2_024, 2_283, 2_287, 2_633, 2_671, 2_676, 2_698, 2_959,
            3_264, 3_290, 3_406, 3_517, 3_619, 3_686, 3_887, 4_116, 4_146, 4_178, 4_320, 4_350,
            4_405, 4_863, 4_864, 4_879, 5_182, 5_185, 5_805, 6_043, 6_307, 6_340, 6_380, 6_444,
            6_463, 6_885, 7_009, 7_128, 7_200, 7_299, 7_494, 7_541, 7_565, 7_632, 7_768, 7_850,
        ];
        let mut pending = PatriciaPending::new(generators.len()).unwrap();
        for &generator in &generators {
            assert!(pending.insert(2, generator).unwrap());
        }
        assert_eq!(pending.len, generators.len());
        for &generator in &generators {
            assert!(pending.contains(2, generator));
            assert!(pending.remove(2, generator));
        }
        assert_eq!(pending.len, 0);
    }

    #[test]
    fn patricia_pending_matches_btree_set_under_random_updates() {
        let mut pending = PatriciaPending::new(128).unwrap();
        let mut reference = std::collections::BTreeSet::new();
        let mut fixture = 0x5eed_1234_89ab_cdef_u64;
        for _ in 0..20_000 {
            fixture = fixture
                .wrapping_mul(6_364_136_223_846_793_005)
                .wrapping_add(1_442_695_040_888_963_407);
            let block = (fixture >> 40) as u32 % 32;
            let generator = (fixture >> 8) as u32 % 64;
            let key = split_work_key(block, generator);
            match fixture & 3 {
                0 => {
                    let expected = if reference.contains(&key) {
                        Ok(false)
                    } else if reference.len() == 128 {
                        Err(ObservationalError::Overflow)
                    } else {
                        reference.insert(key);
                        Ok(true)
                    };
                    assert_eq!(pending.insert(block, generator), expected);
                }
                1 => assert_eq!(pending.remove(block, generator), reference.remove(&key)),
                _ => assert_eq!(pending.contains(block, generator), reference.contains(&key)),
            }
            assert_eq!(pending.len, reference.len());
        }
    }

    #[test]
    fn split_transcript_requeues_both_children_of_pending_splitter() {
        let observations = vec![2, 0, 2, 2, 1, 1, 1, 0, 2, 1];
        let transitions = [
            [3, 2, 5, 8, 5, 8, 7, 0, 1, 8],
            [1, 0, 3, 8, 3, 6, 3, 2, 1, 4],
            [5, 6, 1, 6, 3, 2, 5, 8, 3, 6],
            [5, 6, 7, 2, 7, 2, 5, 6, 5, 0],
        ];
        let generators = transitions.map(|states| GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: states.into(),
        });
        let presentation = FinitePresentation::new([10], observations, generators).unwrap();
        let reference =
            compile_observational_with_policy(&presentation, CertificatePolicy::QuotientOnly)
                .unwrap();
        let split =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();

        assert_eq!(split.state_classes(), reference.state_classes());
        assert_eq!(split.metrics().classes, 10);
        verify_compilation(&presentation, &split).unwrap();
    }

    #[test]
    fn split_transcript_verifier_rejects_field_corruption_and_truncation() {
        let presentation = FinitePresentation::new(
            [3],
            vec![1, 0, 0],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: vec![1, 2, 0].into_boxed_slice(),
            }],
        )
        .unwrap();
        let compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();
        assert_eq!(compiled.split_records.len(), 1);

        for corrupt in [
            SplitRecord {
                source_block: u32::MAX,
                ..compiled.split_records[0]
            },
            SplitRecord {
                generator: u32::MAX,
                ..compiled.split_records[0]
            },
            SplitRecord {
                splitter_block: u32::MAX,
                ..compiled.split_records[0]
            },
            SplitRecord {
                new_block: u32::MAX,
                ..compiled.split_records[0]
            },
        ] {
            let mut malformed = compiled.clone();
            malformed.split_records = vec![corrupt].into_boxed_slice();
            assert!(verify_compilation(&presentation, &malformed).is_err());
        }

        let mut truncated = compiled;
        truncated.split_records = Box::default();
        assert_eq!(
            verify_compilation(&presentation, &truncated),
            Err(ObservationalError::Partition)
        );
    }

    #[test]
    fn inverse_index_selects_compact_dense_and_sparse_directories() {
        let dense = FinitePresentation::new(
            [8],
            vec![0; 8],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0..8).collect::<Vec<_>>().into_boxed_slice(),
            }],
        )
        .unwrap();
        let dense_inverse = InverseIndex::new(&dense).unwrap();
        assert_eq!(dense_inverse.records[0].mode, InverseIndex::DENSE);
        assert_eq!(dense_inverse.offsets.len(), 9);
        assert!(dense_inverse.targets.is_empty());
        assert!(matches!(
            TargetGeneratorDirectory::new(&dense, &dense_inverse, None).unwrap(),
            TargetGeneratorDirectory::BySort { .. }
        ));
        dense_inverse.verify(&dense).unwrap();

        let high_fan_in = FinitePresentation::new(
            [8],
            vec![0; 8],
            (0..9).map(|_| GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0..8).collect::<Vec<_>>().into_boxed_slice(),
            }),
        )
        .unwrap();
        let high_fan_in_inverse = InverseIndex::new(&high_fan_in).unwrap();
        assert!(matches!(
            TargetGeneratorDirectory::new(&high_fan_in, &high_fan_in_inverse, None).unwrap(),
            TargetGeneratorDirectory::ByState { .. }
        ));

        let sparse = FinitePresentation::new(
            [2, 1_024],
            vec![0; 1_026],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 1,
                transitions: vec![2, 1_025].into_boxed_slice(),
            }],
        )
        .unwrap();
        let sparse_inverse = InverseIndex::new(&sparse).unwrap();
        assert_eq!(sparse_inverse.records[0].mode, InverseIndex::SPARSE);
        assert!(sparse_inverse.offsets.is_empty());
        assert_eq!(sparse_inverse.targets.len(), 2);
        sparse_inverse.verify(&sparse).unwrap();
    }

    #[test]
    fn observation_radix_partition_matches_comparison_sort_at_every_byte_width() {
        let observations = vec![
            0xff00_0001,
            0,
            0x0001_0002,
            0x0000_0103,
            0xff00_0001,
            7,
            0x0001_0002,
            0x0000_0103,
        ];
        let mut states = (0..observations.len() as u32).rev().collect::<Vec<_>>();
        let mut expected = states.clone();
        expected.sort_unstable_by_key(|&state| observations[state as usize]);
        let mut scratch = vec![0_u32; states.len()];
        radix_sort_states_by_observation(
            &observations,
            &mut states,
            &mut scratch,
            observations
                .iter()
                .copied()
                .fold(0, |mask, value| mask | value),
        );
        assert_eq!(
            states
                .iter()
                .map(|&state| observations[state as usize])
                .collect::<Vec<_>>(),
            expected
                .iter()
                .map(|&state| observations[state as usize])
                .collect::<Vec<_>>()
        );
        states.sort_unstable();
        assert_eq!(states, (0..observations.len() as u32).collect::<Vec<_>>());
    }

    #[test]
    fn stable_initial_observation_partition_skips_split_transcript() {
        let presentation = FinitePresentation::new(
            [16],
            (0..16).map(|state| state % 4).collect::<Vec<_>>(),
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0..16)
                    .map(|state| (state + 1) % 16)
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
            }],
        )
        .unwrap();
        let compiled =
            compile_observational_with_policy(&presentation, CertificatePolicy::SplitTranscript)
                .unwrap();
        assert_eq!(compiled.class_outputs.len(), 4);
        assert!(compiled.split_records.is_empty());
        verify_compilation(&presentation, &compiled).unwrap();
    }

    fn next_fixture_word(state: &mut u64) -> u32 {
        *state = state
            .wrapping_mul(6_364_136_223_846_793_005)
            .wrapping_add(1_442_695_040_888_963_407);
        (*state >> 32) as u32
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
