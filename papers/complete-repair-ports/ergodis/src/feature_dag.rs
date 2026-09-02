//! Bounded, typed feature terms for theorem evolution.
//!
//! Nodes are deterministically hash-consed and carry degree and evaluation-cost
//! bounds. A caller-owned workspace evaluates rows without allocation.

use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const FEATURE_DAG_SNAPSHOT_VERSION: u16 = 1;
pub const FEATURE_PRESENTATION_TRANSITION_VERSION: u16 = 1;
pub const DIAGNOSTIC_FEATURE_DAG_BUNDLE_VERSION: u16 = 1;
pub const MAX_FEATURE_PRESENTATION_ROWS: usize = 4_096;
pub const MAX_FEATURE_PRESENTATION_CELLS: usize = 1_048_576;
pub const MAX_OBSERVED_FEATURE_SUPPORT_ROWS: usize = 4_096;
pub const MAX_OBSERVED_FEATURE_SUPPORT_CELLS: usize = 1_048_576;
pub const MAX_OBSERVED_FEATURE_SUPPORT_VALUES: usize = 1_048_576;

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(transparent)]
pub struct FeatureId(u32);

impl FeatureId {
    pub fn index(self) -> usize {
        self.0 as usize
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, Ord, PartialEq, PartialOrd, Serialize)]
pub struct FeatureZeroConjunction {
    pub left: FeatureId,
    pub right: FeatureId,
}

impl FeatureZeroConjunction {
    pub fn new(left: FeatureId, right: FeatureId) -> Self {
        let (left, right) = ordered(left, right);
        Self { left, right }
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(tag = "op", rename_all = "kebab-case", deny_unknown_fields)]
pub enum FeatureOp {
    Input { index: u16 },
    Constant { value: i64 },
    Add { left: FeatureId, right: FeatureId },
    Sub { left: FeatureId, right: FeatureId },
    Mul { left: FeatureId, right: FeatureId },
    Mod { source: FeatureId, modulus: u16 },
    Abs { source: FeatureId },
    GaussianNorm { left: FeatureId, right: FeatureId },
    EisensteinNorm { left: FeatureId, right: FeatureId },
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FeatureNode {
    pub op: FeatureOp,
    pub degree: u8,
    pub evaluation_cost: u32,
}

/// Runtime-selected degree-two expansion over raw scalar inputs.
#[derive(Clone, Copy, Debug)]
pub struct RawFeatureExpansion<'a> {
    pub input_indices: Option<&'a [u16]>,
    pub moduli: &'a [u16],
    pub include_abs: bool,
    pub include_sums: bool,
    pub include_differences: bool,
    pub include_products: bool,
    pub include_gaussian_norms: bool,
    pub include_eisenstein_norms: bool,
    pub include_affine_lifts: bool,
}

/// Runtime-selected features aimed at one positive/false-positive conflict.
#[derive(Clone, Copy, Debug)]
pub struct ConflictFeatureExpansion<'a> {
    pub input_indices: Option<&'a [u16]>,
    pub moduli: &'a [u16],
    pub maximum_candidates: usize,
}

/// Stable serialized form of a feature DAG.
#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct FeatureDagSnapshot {
    pub version: u16,
    pub input_count: u16,
    pub maximum_degree: u8,
    pub operations: Box<[FeatureOp]>,
}

/// Canonical identity of one bounded row-major integer presentation.
#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct FeaturePresentationBinding {
    pub rows: u32,
    pub columns: u32,
    pub values_blake3: [u8; 32],
}

/// Independently replayable transition from source fields to all DAG nodes.
///
/// This artifact proves only that the deterministic feature computation was
/// replayed exactly. It grants no theorem or pruning authority.
#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct FeaturePresentationTransition {
    pub version: u16,
    pub proof_authority: bool,
    pub source: FeaturePresentationBinding,
    pub feature_dag_blake3: [u8; 32],
    pub target: FeaturePresentationBinding,
}

/// Restartable diagnostic feature program bound to an exact presentation transition.
#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct DiagnosticFeatureDagBundle {
    pub version: u16,
    pub proof_authority: bool,
    pub dag: FeatureDagSnapshot,
    pub transition: FeaturePresentationTransition,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum FeaturePresentationTransitionError {
    #[error("feature presentation bounds are invalid")]
    Bounds,
    #[error("feature presentation dimensions do not match its values")]
    Shape,
    #[error("feature presentation transition version is unsupported")]
    Version,
    #[error("feature presentation transition cannot carry proof authority")]
    InvalidProofAuthority,
    #[error("feature presentation transition binding does not match replay")]
    Binding,
    #[error("feature DAG snapshot could not be encoded canonically")]
    Encoding,
    #[error(transparent)]
    Feature(#[from] FeatureDagError),
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum DiagnosticFeatureDagBundleError {
    #[error("diagnostic feature DAG bundle version is unsupported")]
    Version,
    #[error("diagnostic feature DAG bundle cannot carry proof authority")]
    InvalidProofAuthority,
    #[error("diagnostic feature DAG bundle does not match its transition")]
    Binding,
    #[error(transparent)]
    Feature(#[from] FeatureDagError),
    #[error(transparent)]
    Transition(#[from] FeaturePresentationTransitionError),
}

impl Default for RawFeatureExpansion<'static> {
    fn default() -> Self {
        Self {
            input_indices: None,
            moduli: &[],
            include_abs: true,
            include_sums: true,
            include_differences: true,
            include_products: true,
            include_gaussian_norms: false,
            include_eisenstein_norms: false,
            include_affine_lifts: false,
        }
    }
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum FeatureDagError {
    #[error("feature DAG bounds must be positive")]
    EmptyBound,
    #[error("feature input index is out of range")]
    InputOutOfRange,
    #[error("feature node belongs to no node in this DAG")]
    UnknownNode,
    #[error("feature term exceeds the configured degree bound")]
    DegreeExceeded,
    #[error("feature DAG reached its configured node bound")]
    NodeLimit,
    #[error("conflict-derived feature expansion exceeds its candidate bound")]
    CandidateLimit,
    #[error("feature evaluation cost overflowed")]
    CostOverflow,
    #[error("feature modulus must be positive")]
    ZeroModulus,
    #[error("feature input row has the wrong width")]
    InputWidth,
    #[error("feature workspace has the wrong capacity")]
    WorkspaceWidth,
    #[error("feature arithmetic overflowed")]
    ArithmeticOverflow,
    #[error("unsupported feature DAG snapshot version")]
    SnapshotVersion,
    #[error("feature DAG snapshot is not topological and canonical")]
    NonCanonicalSnapshot,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FeatureBankBounds {
    pub maximum_rows: usize,
    pub maximum_bitmap_words: usize,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FeaturePredicateCensus {
    pub rows: u64,
    pub expected: u64,
    pub surviving: u64,
    pub false_negatives: u64,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum FeatureBankError {
    #[error("feature-bank bounds must be positive")]
    EmptyBound,
    #[error("feature bank requires at least one corpus row")]
    EmptyCorpus,
    #[error("feature-bank row matrix has the wrong size")]
    Shape,
    #[error("feature bank exceeds its configured row or bitmap bound")]
    TooLarge,
    #[error("expected-label bitmap has the wrong width")]
    LabelWidth,
    #[error("expected-label bitmap sets bits beyond the row domain")]
    LabelTail,
    #[error(transparent)]
    Evaluation(#[from] FeatureDagError),
}

/// Column-major bitmaps for predicates of the form `feature == 0`.
pub struct FeatureZeroBank {
    rows: usize,
    words: usize,
    features: usize,
    zero: Box<[u64]>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FeatureZeroClassMember {
    pub candidate: FeatureId,
    pub representative: FeatureId,
}

/// Exact full-corpus equivalence classes for predicates `feature == 0`.
pub struct FeatureZeroQuotient {
    input_candidates: usize,
    representatives: Box<[FeatureId]>,
    members: Box<[FeatureZeroClassMember]>,
}

impl FeatureZeroQuotient {
    pub fn input_candidates(&self) -> usize {
        self.input_candidates
    }

    pub fn class_count(&self) -> usize {
        self.representatives.len()
    }

    pub fn eliminated(&self) -> usize {
        self.input_candidates - self.class_count()
    }

    pub fn representatives(&self) -> &[FeatureId] {
        &self.representatives
    }

    pub fn members(&self) -> &[FeatureZeroClassMember] {
        &self.members
    }

    pub fn representative(&self, candidate: FeatureId) -> Option<FeatureId> {
        self.members
            .binary_search_by_key(&candidate, |member| member.candidate)
            .ok()
            .map(|index| self.members[index].representative)
    }
}

/// Bit-packed raw-input dependencies for every feature node.
pub struct FeatureScopeBank {
    input_count: usize,
    words: usize,
    features: usize,
    scopes: Box<[u64]>,
}

impl FeatureScopeBank {
    pub fn compile(
        dag: &FeatureDag,
        maximum_bitmap_words: usize,
    ) -> Result<Self, FeatureBankError> {
        if maximum_bitmap_words == 0 {
            return Err(FeatureBankError::EmptyBound);
        }
        let input_count = dag.input_count();
        let words = input_count.div_ceil(64);
        let bitmap_words = dag
            .len()
            .checked_mul(words)
            .ok_or(FeatureBankError::TooLarge)?;
        if bitmap_words > maximum_bitmap_words {
            return Err(FeatureBankError::TooLarge);
        }
        let mut scopes = vec![0_u64; bitmap_words];
        for (feature, node) in dag.nodes.iter().enumerate() {
            let destination = feature * words;
            match node.op {
                FeatureOp::Input { index } => {
                    let index = usize::from(index);
                    scopes[destination + index / 64] |= 1_u64 << (index % 64);
                }
                FeatureOp::Constant { .. } => {}
                FeatureOp::Mod { source, .. } | FeatureOp::Abs { source } => {
                    copy_scope(&mut scopes, words, destination, source.index());
                }
                FeatureOp::Add { left, right }
                | FeatureOp::Sub { left, right }
                | FeatureOp::Mul { left, right }
                | FeatureOp::GaussianNorm { left, right }
                | FeatureOp::EisensteinNorm { left, right } => {
                    union_scopes(&mut scopes, words, destination, left.index(), right.index());
                }
            }
        }
        Ok(Self {
            input_count,
            words,
            features: dag.len(),
            scopes: scopes.into_boxed_slice(),
        })
    }

    pub fn input_count(&self) -> usize {
        self.input_count
    }

    pub fn features(&self) -> usize {
        self.features
    }

    pub fn bitmap_words(&self) -> usize {
        self.scopes.len()
    }

    pub fn scope_mask(&self, feature: FeatureId) -> Option<&[u64]> {
        (feature.index() < self.features)
            .then(|| &self.scopes[feature.index() * self.words..(feature.index() + 1) * self.words])
    }

    pub fn scope_size(&self, feature: FeatureId) -> Option<u32> {
        self.scope_mask(feature)
            .map(|scope| scope.iter().map(|word| word.count_ones()).sum())
    }

    pub fn conjunction_scope_size(&self, conjunction: FeatureZeroConjunction) -> Option<u32> {
        let left = self.scope_mask(conjunction.left)?;
        let right = self.scope_mask(conjunction.right)?;
        Some(
            left.iter()
                .zip(right)
                .map(|(&left, &right)| (left | right).count_ones())
                .sum(),
        )
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct ObservedFeatureSupportBounds {
    pub maximum_rows: usize,
    pub maximum_cells: usize,
    pub maximum_values_per_feature: usize,
    pub maximum_total_values: usize,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct FeatureSupportRange {
    start: u32,
    length: u32,
}

const _: () = assert!(std::mem::size_of::<FeatureSupportRange>() == 8);
const _: () = assert!(std::mem::align_of::<FeatureSupportRange>() == 4);

pub struct ObservedFeatureSupportBank {
    selected_rows: usize,
    ranges: Box<[FeatureSupportRange]>,
    values: Box<[i64]>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FeatureSupportScore {
    pub feature: FeatureId,
    pub support_size: u32,
    pub evaluation_cost: u32,
    pub scope_size: u32,
    pub downstream_compatibility: u32,
}

const _: () = assert!(std::mem::size_of::<FeatureSupportScore>() == 20);
const _: () = assert!(std::mem::align_of::<FeatureSupportScore>() == 4);

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum ObservedFeatureSupportError {
    #[error("observed feature-support bounds must be positive")]
    InvalidBounds,
    #[error("observed feature-support corpus or reachability bitmap has the wrong shape")]
    Shape,
    #[error("observed feature-support reachability bitmap has invalid tail bits")]
    ReachabilityTail,
    #[error("observed feature-support compilation exceeds its configured bound")]
    TooLarge,
    #[error("observed feature-support candidates are noncanonical")]
    NonCanonicalCandidates,
    #[error(transparent)]
    Evaluation(#[from] FeatureDagError),
}

impl ObservedFeatureSupportBank {
    pub fn compile(
        dag: &FeatureDag,
        rows: &[i64],
        reachable: Option<&[u64]>,
        bounds: ObservedFeatureSupportBounds,
    ) -> Result<Self, ObservedFeatureSupportError> {
        if bounds.maximum_rows == 0
            || bounds.maximum_rows > MAX_OBSERVED_FEATURE_SUPPORT_ROWS
            || bounds.maximum_cells == 0
            || bounds.maximum_cells > MAX_OBSERVED_FEATURE_SUPPORT_CELLS
            || bounds.maximum_values_per_feature == 0
            || bounds.maximum_values_per_feature > MAX_OBSERVED_FEATURE_SUPPORT_VALUES
            || bounds.maximum_total_values == 0
            || bounds.maximum_total_values > MAX_OBSERVED_FEATURE_SUPPORT_VALUES
        {
            return Err(ObservedFeatureSupportError::InvalidBounds);
        }
        if dag.is_empty()
            || rows.is_empty()
            || rows.len() % dag.input_count() != 0
            || rows.len() / dag.input_count() > bounds.maximum_rows
        {
            return Err(ObservedFeatureSupportError::Shape);
        }
        let row_count = rows.len() / dag.input_count();
        let words = row_count.div_ceil(64);
        if let Some(mask) = reachable {
            if mask.len() != words {
                return Err(ObservedFeatureSupportError::Shape);
            }
            if row_count % 64 != 0
                && mask
                    .last()
                    .is_some_and(|&word| word & !((1_u64 << (row_count % 64)) - 1) != 0)
            {
                return Err(ObservedFeatureSupportError::ReachabilityTail);
            }
        }
        let selected_rows = reachable.map_or(row_count, |mask| {
            mask.iter().map(|word| word.count_ones() as usize).sum()
        });
        if selected_rows == 0 {
            return Err(ObservedFeatureSupportError::Shape);
        }
        let cells = selected_rows
            .checked_mul(dag.len())
            .ok_or(ObservedFeatureSupportError::TooLarge)?;
        if cells > bounds.maximum_cells {
            return Err(ObservedFeatureSupportError::TooLarge);
        }
        let mut matrix = Vec::with_capacity(cells);
        let mut workspace = dag.workspace();
        for (row_index, inputs) in rows.chunks_exact(dag.input_count()).enumerate() {
            let selected = reachable
                .is_none_or(|mask| mask[row_index / 64] & (1_u64 << (row_index % 64)) != 0);
            if selected {
                matrix.extend_from_slice(dag.evaluate(inputs, &mut workspace)?);
            }
        }
        let mut ranges = Vec::with_capacity(dag.len());
        let mut values = Vec::new();
        let mut scratch = Vec::with_capacity(selected_rows);
        for feature in 0..dag.len() {
            scratch.clear();
            scratch.extend((0..selected_rows).map(|row| matrix[row * dag.len() + feature]));
            scratch.sort_unstable();
            scratch.dedup();
            let total_values = values
                .len()
                .checked_add(scratch.len())
                .ok_or(ObservedFeatureSupportError::TooLarge)?;
            if scratch.len() > bounds.maximum_values_per_feature
                || total_values > bounds.maximum_total_values
            {
                return Err(ObservedFeatureSupportError::TooLarge);
            }
            ranges.push(FeatureSupportRange {
                start: u32::try_from(values.len())
                    .map_err(|_| ObservedFeatureSupportError::TooLarge)?,
                length: u32::try_from(scratch.len())
                    .map_err(|_| ObservedFeatureSupportError::TooLarge)?,
            });
            values.extend_from_slice(&scratch);
        }
        Ok(Self {
            selected_rows,
            ranges: ranges.into_boxed_slice(),
            values: values.into_boxed_slice(),
        })
    }

    pub fn selected_rows(&self) -> usize {
        self.selected_rows
    }

    pub fn support(&self, feature: FeatureId) -> Option<&[i64]> {
        let range = *self.ranges.get(feature.index())?;
        let start = range.start as usize;
        Some(&self.values[start..start + range.length as usize])
    }

    pub fn pareto_frontier(
        &self,
        dag: &FeatureDag,
        scopes: &FeatureScopeBank,
        candidates: &[FeatureId],
        downstream_compatibility: &[u32],
        maximum_points: usize,
    ) -> Result<Box<[FeatureSupportScore]>, ObservedFeatureSupportError> {
        if maximum_points == 0 || candidates.len() != downstream_compatibility.len() {
            return Err(ObservedFeatureSupportError::InvalidBounds);
        }
        if candidates.windows(2).any(|pair| pair[0] >= pair[1]) {
            return Err(ObservedFeatureSupportError::NonCanonicalCandidates);
        }
        let mut scores = Vec::with_capacity(candidates.len().min(maximum_points));
        for (&feature, &compatibility) in candidates.iter().zip(downstream_compatibility) {
            let support = self
                .support(feature)
                .ok_or(ObservedFeatureSupportError::Shape)?;
            let node = dag
                .node(feature)
                .ok_or(ObservedFeatureSupportError::Shape)?;
            let scope_size = scopes
                .scope_size(feature)
                .ok_or(ObservedFeatureSupportError::Shape)?;
            scores.push(FeatureSupportScore {
                feature,
                support_size: u32::try_from(support.len())
                    .map_err(|_| ObservedFeatureSupportError::TooLarge)?,
                evaluation_cost: node.evaluation_cost,
                scope_size,
                downstream_compatibility: compatibility,
            });
        }
        let mut frontier = Vec::new();
        for (index, &score) in scores.iter().enumerate() {
            if scores
                .iter()
                .enumerate()
                .any(|(other_index, &other)| other_index != index && dominates(other, score))
            {
                continue;
            }
            if frontier.len() == maximum_points {
                return Err(ObservedFeatureSupportError::TooLarge);
            }
            frontier.push(score);
        }
        frontier.sort_unstable_by_key(|score| score.feature);
        Ok(frontier.into_boxed_slice())
    }
}

fn dominates(left: FeatureSupportScore, right: FeatureSupportScore) -> bool {
    left.support_size <= right.support_size
        && left.evaluation_cost <= right.evaluation_cost
        && left.scope_size <= right.scope_size
        && left.downstream_compatibility >= right.downstream_compatibility
        && (left.support_size < right.support_size
            || left.evaluation_cost < right.evaluation_cost
            || left.scope_size < right.scope_size
            || left.downstream_compatibility > right.downstream_compatibility)
}

fn copy_scope(scopes: &mut [u64], words: usize, destination: usize, source: usize) {
    let source = source * words;
    for offset in 0..words {
        scopes[destination + offset] = scopes[source + offset];
    }
}

fn union_scopes(scopes: &mut [u64], words: usize, destination: usize, left: usize, right: usize) {
    let left = left * words;
    let right = right * words;
    for offset in 0..words {
        scopes[destination + offset] = scopes[left + offset] | scopes[right + offset];
    }
}

impl FeatureZeroBank {
    pub fn compile(
        dag: &FeatureDag,
        row_values: &[i64],
        bounds: FeatureBankBounds,
    ) -> Result<Self, FeatureBankError> {
        if bounds.maximum_rows == 0 || bounds.maximum_bitmap_words == 0 {
            return Err(FeatureBankError::EmptyBound);
        }
        if row_values.len() % dag.input_count() != 0 {
            return Err(FeatureBankError::Shape);
        }
        let rows = row_values.len() / dag.input_count();
        if rows == 0 {
            return Err(FeatureBankError::EmptyCorpus);
        }
        let words = rows.div_ceil(64);
        let bitmap_words = dag
            .len()
            .checked_mul(words)
            .ok_or(FeatureBankError::TooLarge)?;
        if rows > bounds.maximum_rows || bitmap_words > bounds.maximum_bitmap_words {
            return Err(FeatureBankError::TooLarge);
        }
        let mut zero = vec![0_u64; bitmap_words];
        let mut workspace = dag.workspace();
        for (row, inputs) in row_values.chunks_exact(dag.input_count()).enumerate() {
            let values = dag.evaluate(inputs, &mut workspace)?;
            for (feature, &value) in values.iter().enumerate() {
                zero[feature * words + row / 64] |= u64::from(value == 0) << (row % 64);
            }
        }
        Ok(Self {
            rows,
            words,
            features: dag.len(),
            zero: zero.into_boxed_slice(),
        })
    }

    pub fn rows(&self) -> usize {
        self.rows
    }

    pub fn features(&self) -> usize {
        self.features
    }

    pub fn bitmap_words(&self) -> usize {
        self.zero.len()
    }

    pub fn zero_mask(&self, feature: FeatureId) -> Option<&[u64]> {
        (feature.index() < self.features)
            .then(|| &self.zero[feature.index() * self.words..(feature.index() + 1) * self.words])
    }

    /// Quotient candidates by exact equality of their full-corpus zero masks.
    ///
    /// Within one class the lowest evaluation-cost node is retained, followed
    /// by degree and structural ID tie-breaks. No sample hash or collision
    /// assumption is used.
    pub fn quotient_zero_predicates(
        &self,
        dag: &FeatureDag,
        candidates: &[FeatureId],
        maximum_candidates: usize,
    ) -> Result<FeatureZeroQuotient, FeatureBankError> {
        if maximum_candidates == 0 {
            return Err(FeatureBankError::EmptyBound);
        }
        if candidates.len() > maximum_candidates {
            return Err(FeatureBankError::TooLarge);
        }
        if dag.len() != self.features {
            return Err(FeatureBankError::Shape);
        }
        let mut candidates = candidates.to_vec();
        candidates.sort_unstable();
        candidates.dedup();
        if candidates
            .iter()
            .any(|&candidate| self.zero_mask(candidate).is_none())
        {
            return Err(FeatureBankError::Shape);
        }
        candidates.sort_unstable_by(|&left, &right| {
            self.zero_mask(left)
                .unwrap()
                .cmp(self.zero_mask(right).unwrap())
                .then_with(|| {
                    let left = dag.node(left).unwrap();
                    let right = dag.node(right).unwrap();
                    left.evaluation_cost
                        .cmp(&right.evaluation_cost)
                        .then_with(|| left.degree.cmp(&right.degree))
                })
                .then_with(|| left.cmp(&right))
        });
        let input_candidates = candidates.len();
        let mut representatives = Vec::new();
        let mut members = Vec::with_capacity(input_candidates);
        let mut first = 0_usize;
        while first < candidates.len() {
            let representative = candidates[first];
            let mut end = first + 1;
            while end < candidates.len()
                && self.zero_mask(candidates[end]) == self.zero_mask(representative)
            {
                end += 1;
            }
            representatives.push(representative);
            members.extend(candidates[first..end].iter().map(|&candidate| {
                FeatureZeroClassMember {
                    candidate,
                    representative,
                }
            }));
            first = end;
        }
        representatives.sort_unstable();
        members.sort_unstable_by_key(|member| member.candidate);
        Ok(FeatureZeroQuotient {
            input_candidates,
            representatives: representatives.into_boxed_slice(),
            members: members.into_boxed_slice(),
        })
    }

    pub fn score_necessary_zero(
        &self,
        feature: FeatureId,
        expected: &[u64],
    ) -> Result<FeaturePredicateCensus, FeatureBankError> {
        let expected_count = self.validate_expected(expected)?;
        let selected = self.zero_mask(feature).ok_or(FeatureBankError::Shape)?;
        let mut surviving = 0_u64;
        let mut false_negatives = 0_u64;
        for (&selected, &expected) in selected.iter().zip(expected) {
            surviving += u64::from(selected.count_ones());
            false_negatives += u64::from((expected & !selected).count_ones());
        }
        Ok(FeaturePredicateCensus {
            rows: self.rows as u64,
            expected: expected_count,
            surviving,
            false_negatives,
        })
    }

    /// Score `(left == 0) && (right == 0)` without materializing its bitmap.
    pub fn score_necessary_zero_conjunction(
        &self,
        conjunction: FeatureZeroConjunction,
        expected: &[u64],
    ) -> Result<FeaturePredicateCensus, FeatureBankError> {
        let expected_count = self.validate_expected(expected)?;
        let left = self
            .zero_mask(conjunction.left)
            .ok_or(FeatureBankError::Shape)?;
        let right = self
            .zero_mask(conjunction.right)
            .ok_or(FeatureBankError::Shape)?;
        let mut surviving = 0_u64;
        let mut false_negatives = 0_u64;
        for ((&left, &right), &expected) in left.iter().zip(right).zip(expected) {
            let selected = left & right;
            surviving += u64::from(selected.count_ones());
            false_negatives += u64::from((expected & !selected).count_ones());
        }
        Ok(FeaturePredicateCensus {
            rows: self.rows as u64,
            expected: expected_count,
            surviving,
            false_negatives,
        })
    }

    fn validate_expected(&self, expected: &[u64]) -> Result<u64, FeatureBankError> {
        if expected.len() != self.words {
            return Err(FeatureBankError::LabelWidth);
        }
        if self.rows % 64 != 0
            && expected
                .last()
                .is_some_and(|&word| word & !((1_u64 << (self.rows % 64)) - 1) != 0)
        {
            return Err(FeatureBankError::LabelTail);
        }
        Ok(expected
            .iter()
            .map(|word| u64::from(word.count_ones()))
            .sum())
    }
}

pub struct FeatureDag {
    input_count: u16,
    maximum_degree: u8,
    maximum_nodes: usize,
    nodes: Vec<FeatureNode>,
    interned: BTreeMap<FeatureOp, FeatureId>,
}

impl FeatureDag {
    pub fn new(
        input_count: u16,
        maximum_degree: u8,
        maximum_nodes: usize,
    ) -> Result<Self, FeatureDagError> {
        if input_count == 0 || maximum_degree == 0 || maximum_nodes == 0 {
            return Err(FeatureDagError::EmptyBound);
        }
        Ok(Self {
            input_count,
            maximum_degree,
            maximum_nodes,
            nodes: Vec::with_capacity(maximum_nodes.min(4096)),
            interned: BTreeMap::new(),
        })
    }

    pub fn input_count(&self) -> usize {
        usize::from(self.input_count)
    }

    pub fn len(&self) -> usize {
        self.nodes.len()
    }

    pub fn is_empty(&self) -> bool {
        self.nodes.is_empty()
    }

    pub fn nodes(&self) -> &[FeatureNode] {
        &self.nodes
    }

    pub fn snapshot(&self) -> FeatureDagSnapshot {
        FeatureDagSnapshot {
            version: FEATURE_DAG_SNAPSHOT_VERSION,
            input_count: self.input_count,
            maximum_degree: self.maximum_degree,
            operations: self
                .nodes
                .iter()
                .map(|node| node.op)
                .collect::<Vec<_>>()
                .into_boxed_slice(),
        }
    }

    pub fn from_snapshot(
        snapshot: &FeatureDagSnapshot,
        maximum_nodes: usize,
    ) -> Result<Self, FeatureDagError> {
        if snapshot.version != FEATURE_DAG_SNAPSHOT_VERSION {
            return Err(FeatureDagError::SnapshotVersion);
        }
        if maximum_nodes < snapshot.operations.len() {
            return Err(FeatureDagError::NodeLimit);
        }
        let mut dag = Self::new(snapshot.input_count, snapshot.maximum_degree, maximum_nodes)?;
        for (ordinal, &op) in snapshot.operations.iter().enumerate() {
            let id = match op {
                FeatureOp::Input { index } => dag.input(index)?,
                FeatureOp::Constant { value } => dag.constant(value)?,
                FeatureOp::Add { left, right } => dag.add(left, right)?,
                FeatureOp::Sub { left, right } => dag.sub(left, right)?,
                FeatureOp::Mul { left, right } => dag.mul(left, right)?,
                FeatureOp::Mod { source, modulus } => dag.modulo(source, modulus)?,
                FeatureOp::Abs { source } => dag.abs(source)?,
                FeatureOp::GaussianNorm { left, right } => dag.gaussian_norm(left, right)?,
                FeatureOp::EisensteinNorm { left, right } => dag.eisenstein_norm(left, right)?,
            };
            if id.index() != ordinal || dag.node(id).is_none_or(|node| node.op != op) {
                return Err(FeatureDagError::NonCanonicalSnapshot);
            }
        }
        Ok(dag)
    }

    pub fn diagnostic_bundle(
        &self,
        transition: FeaturePresentationTransition,
    ) -> Result<DiagnosticFeatureDagBundle, DiagnosticFeatureDagBundleError> {
        if transition.proof_authority {
            return Err(DiagnosticFeatureDagBundleError::InvalidProofAuthority);
        }
        if transition.version != FEATURE_PRESENTATION_TRANSITION_VERSION
            || transition.feature_dag_blake3 != self.presentation_digest()?
        {
            return Err(DiagnosticFeatureDagBundleError::Binding);
        }
        Ok(DiagnosticFeatureDagBundle {
            version: DIAGNOSTIC_FEATURE_DAG_BUNDLE_VERSION,
            proof_authority: false,
            dag: self.snapshot(),
            transition,
        })
    }

    pub fn restore_diagnostic_bundle(
        bundle: &DiagnosticFeatureDagBundle,
        maximum_nodes: usize,
        source: &[i64],
        target: &[i64],
    ) -> Result<Self, DiagnosticFeatureDagBundleError> {
        if bundle.version != DIAGNOSTIC_FEATURE_DAG_BUNDLE_VERSION {
            return Err(DiagnosticFeatureDagBundleError::Version);
        }
        if bundle.proof_authority || bundle.transition.proof_authority {
            return Err(DiagnosticFeatureDagBundleError::InvalidProofAuthority);
        }
        let dag = Self::from_snapshot(&bundle.dag, maximum_nodes)?;
        dag.verify_presentation_transition(source, target, &bundle.transition)?;
        Ok(dag)
    }

    pub fn node(&self, id: FeatureId) -> Option<&FeatureNode> {
        self.nodes.get(id.index())
    }

    pub fn input(&mut self, index: u16) -> Result<FeatureId, FeatureDagError> {
        if index >= self.input_count {
            return Err(FeatureDagError::InputOutOfRange);
        }
        self.intern(FeatureOp::Input { index }, 1, 1)
    }

    pub fn constant(&mut self, value: i64) -> Result<FeatureId, FeatureDagError> {
        self.intern(FeatureOp::Constant { value }, 0, 1)
    }

    pub fn add(&mut self, left: FeatureId, right: FeatureId) -> Result<FeatureId, FeatureDagError> {
        let (left, right) = ordered(left, right);
        let (degree, cost) = self.binary_metadata(left, right, false, 1)?;
        self.intern(FeatureOp::Add { left, right }, degree, cost)
    }

    pub fn sub(&mut self, left: FeatureId, right: FeatureId) -> Result<FeatureId, FeatureDagError> {
        let (degree, cost) = self.binary_metadata(left, right, false, 1)?;
        self.intern(FeatureOp::Sub { left, right }, degree, cost)
    }

    pub fn mul(&mut self, left: FeatureId, right: FeatureId) -> Result<FeatureId, FeatureDagError> {
        let (left, right) = ordered(left, right);
        let (degree, cost) = self.binary_metadata(left, right, true, 1)?;
        self.intern(FeatureOp::Mul { left, right }, degree, cost)
    }

    pub fn modulo(
        &mut self,
        source: FeatureId,
        modulus: u16,
    ) -> Result<FeatureId, FeatureDagError> {
        if modulus == 0 {
            return Err(FeatureDagError::ZeroModulus);
        }
        let node = self.require(source)?;
        let cost = plus(node.evaluation_cost, 1)?;
        self.intern(FeatureOp::Mod { source, modulus }, node.degree, cost)
    }

    pub fn abs(&mut self, source: FeatureId) -> Result<FeatureId, FeatureDagError> {
        let node = self.require(source)?;
        let cost = plus(node.evaluation_cost, 1)?;
        self.intern(FeatureOp::Abs { source }, node.degree, cost)
    }

    pub fn gaussian_norm(
        &mut self,
        left: FeatureId,
        right: FeatureId,
    ) -> Result<FeatureId, FeatureDagError> {
        let (left, right) = ordered(left, right);
        let (degree, cost) = self.norm_metadata(left, right, 3)?;
        self.intern(FeatureOp::GaussianNorm { left, right }, degree, cost)
    }

    pub fn eisenstein_norm(
        &mut self,
        left: FeatureId,
        right: FeatureId,
    ) -> Result<FeatureId, FeatureDagError> {
        let (left, right) = ordered(left, right);
        let (degree, cost) = self.norm_metadata(left, right, 5)?;
        self.intern(FeatureOp::EisensteinNorm { left, right }, degree, cost)
    }

    /// Expand raw inputs into a deterministic candidate feature bank.
    ///
    /// Every created term is also reduced modulo each requested modulus. The
    /// configured DAG node bound stops an over-large runtime attack surface.
    pub fn expand_raw_degree_two(
        &mut self,
        expansion: RawFeatureExpansion<'_>,
    ) -> Result<Box<[FeatureId]>, FeatureDagError> {
        if expansion.moduli.contains(&0) {
            return Err(FeatureDagError::ZeroModulus);
        }
        let mut input_indices = expansion.input_indices.map_or_else(
            || (0..self.input_count).collect::<Vec<_>>(),
            <[u16]>::to_vec,
        );
        input_indices.sort_unstable();
        input_indices.dedup();
        if input_indices.iter().any(|&index| index >= self.input_count) {
            return Err(FeatureDagError::InputOutOfRange);
        }
        let raw = input_indices
            .into_iter()
            .map(|index| self.input(index))
            .collect::<Result<Vec<_>, _>>()?;
        let mut candidates = raw.clone();
        let mut nonlinear = Vec::new();
        for &source in &raw {
            if expansion.include_abs {
                let term = self.abs(source)?;
                self.push_with_residues(term, expansion.moduli, &mut candidates)?;
            }
            for &modulus in expansion.moduli {
                candidates.push(self.modulo(source, modulus)?);
            }
        }
        for (left_index, &left) in raw.iter().enumerate() {
            for (right_index, &right) in raw.iter().enumerate().skip(left_index) {
                if expansion.include_sums {
                    let term = self.add(left, right)?;
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_products {
                    let term = self.mul(left, right)?;
                    nonlinear.push(term);
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_gaussian_norms {
                    let term = self.gaussian_norm(left, right)?;
                    nonlinear.push(term);
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_eisenstein_norms {
                    let term = self.eisenstein_norm(left, right)?;
                    nonlinear.push(term);
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_differences && left_index != right_index {
                    for (minuend, subtrahend) in [(left, right), (right, left)] {
                        let term = self.sub(minuend, subtrahend)?;
                        self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                    }
                }
            }
        }
        if expansion.include_affine_lifts {
            nonlinear.sort_unstable();
            nonlinear.dedup();
            for term in nonlinear {
                for &source in &raw {
                    for lifted in [
                        self.add(term, source)?,
                        self.sub(term, source)?,
                        self.sub(source, term)?,
                    ] {
                        self.push_with_residues(lifted, expansion.moduli, &mut candidates)?;
                    }
                }
            }
        }
        candidates.sort_unstable();
        candidates.dedup();
        Ok(candidates.into_boxed_slice())
    }

    /// Generate differences that separate one labelled conflict.
    ///
    /// A proposed exact difference is zero on `positive` and nonzero on
    /// `false_positive`. Modular differences satisfy the analogous congruence.
    /// The candidate bound is checked before any node is added.
    pub fn expand_conflict_differences(
        &mut self,
        positive: &[i64],
        false_positive: &[i64],
        expansion: ConflictFeatureExpansion<'_>,
    ) -> Result<Box<[FeatureId]>, FeatureDagError> {
        if positive.len() != self.input_count() || false_positive.len() != self.input_count() {
            return Err(FeatureDagError::InputWidth);
        }
        if expansion.maximum_candidates == 0 {
            return Err(FeatureDagError::CandidateLimit);
        }
        if expansion.moduli.contains(&0) {
            return Err(FeatureDagError::ZeroModulus);
        }
        let mut input_indices = expansion.input_indices.map_or_else(
            || (0..self.input_count).collect::<Vec<_>>(),
            <[u16]>::to_vec,
        );
        input_indices.sort_unstable();
        input_indices.dedup();
        if input_indices.iter().any(|&index| index >= self.input_count) {
            return Err(FeatureDagError::InputOutOfRange);
        }
        let mut moduli = expansion.moduli.to_vec();
        moduli.sort_unstable();
        moduli.dedup();
        let mut proposals = Vec::<(u16, u16, Option<u16>)>::new();
        for (left_position, &left) in input_indices.iter().enumerate() {
            for &right in input_indices.iter().skip(left_position + 1) {
                let positive_delta = i128::from(positive[usize::from(left)])
                    - i128::from(positive[usize::from(right)]);
                let negative_delta = i128::from(false_positive[usize::from(left)])
                    - i128::from(false_positive[usize::from(right)]);
                if positive_delta == 0 && negative_delta != 0 {
                    push_conflict_proposal(
                        &mut proposals,
                        (left, right, None),
                        expansion.maximum_candidates,
                    )?;
                }
                for &modulus in &moduli {
                    let modulus = i128::from(modulus);
                    if positive_delta.rem_euclid(modulus) == 0
                        && negative_delta.rem_euclid(modulus) != 0
                    {
                        push_conflict_proposal(
                            &mut proposals,
                            (left, right, Some(modulus as u16)),
                            expansion.maximum_candidates,
                        )?;
                    }
                }
            }
        }
        let mut candidates = Vec::with_capacity(proposals.len());
        for (left, right, modulus) in proposals {
            let left = self.input(left)?;
            let right = self.input(right)?;
            let difference = self.sub(left, right)?;
            candidates.push(match modulus {
                Some(modulus) => self.modulo(difference, modulus)?,
                None => difference,
            });
        }
        candidates.sort_unstable();
        candidates.dedup();
        Ok(candidates.into_boxed_slice())
    }

    pub fn workspace(&self) -> FeatureWorkspace {
        FeatureWorkspace {
            values: vec![0; self.nodes.len()],
        }
    }

    pub fn evaluate<'a>(
        &self,
        inputs: &[i64],
        workspace: &'a mut FeatureWorkspace,
    ) -> Result<&'a [i64], FeatureDagError> {
        if inputs.len() != self.input_count() {
            return Err(FeatureDagError::InputWidth);
        }
        if workspace.values.len() != self.nodes.len() {
            return Err(FeatureDagError::WorkspaceWidth);
        }
        for (index, node) in self.nodes.iter().enumerate() {
            let get = |id: FeatureId| workspace.values[id.index()];
            let result = match node.op {
                FeatureOp::Input { index } => inputs[usize::from(index)],
                FeatureOp::Constant { value } => value,
                FeatureOp::Add { left, right } => get(left)
                    .checked_add(get(right))
                    .ok_or(FeatureDagError::ArithmeticOverflow)?,
                FeatureOp::Sub { left, right } => get(left)
                    .checked_sub(get(right))
                    .ok_or(FeatureDagError::ArithmeticOverflow)?,
                FeatureOp::Mul { left, right } => get(left)
                    .checked_mul(get(right))
                    .ok_or(FeatureDagError::ArithmeticOverflow)?,
                FeatureOp::Mod { source, modulus } => get(source).rem_euclid(i64::from(modulus)),
                FeatureOp::Abs { source } => get(source)
                    .checked_abs()
                    .ok_or(FeatureDagError::ArithmeticOverflow)?,
                FeatureOp::GaussianNorm { left, right } => norm(get(left), get(right), false)?,
                FeatureOp::EisensteinNorm { left, right } => norm(get(left), get(right), true)?,
            };
            workspace.values[index] = result;
        }
        Ok(&workspace.values)
    }

    /// Materialize the exact row-major values of every DAG node.
    ///
    /// This is a bounded cold-path operation for theorem evolution and replay;
    /// it is not called by a solve worker.
    pub fn derive_presentation_transition(
        &self,
        source: &[i64],
        rows: usize,
    ) -> Result<(Box<[i64]>, FeaturePresentationTransition), FeaturePresentationTransitionError>
    {
        let (source_cells, target_cells) = self.presentation_shapes(rows)?;
        if source.len() != source_cells {
            return Err(FeaturePresentationTransitionError::Shape);
        }
        let source_binding = presentation_binding(source, rows, self.input_count())?;
        let mut target = Vec::with_capacity(target_cells);
        let mut workspace = self.workspace();
        for inputs in source.chunks_exact(self.input_count()) {
            target.extend_from_slice(self.evaluate(inputs, &mut workspace)?);
        }
        let target = target.into_boxed_slice();
        let transition = FeaturePresentationTransition {
            version: FEATURE_PRESENTATION_TRANSITION_VERSION,
            proof_authority: false,
            source: source_binding,
            feature_dag_blake3: self.presentation_digest()?,
            target: presentation_binding(&target, rows, self.len())?,
        };
        Ok((target, transition))
    }

    /// Replay and verify a previously materialized presentation transition.
    pub fn verify_presentation_transition(
        &self,
        source: &[i64],
        target: &[i64],
        transition: &FeaturePresentationTransition,
    ) -> Result<(), FeaturePresentationTransitionError> {
        if transition.version != FEATURE_PRESENTATION_TRANSITION_VERSION {
            return Err(FeaturePresentationTransitionError::Version);
        }
        if transition.proof_authority {
            return Err(FeaturePresentationTransitionError::InvalidProofAuthority);
        }
        let rows = transition.source.rows as usize;
        let (source_cells, target_cells) = self.presentation_shapes(rows)?;
        if source.len() != source_cells || target.len() != target_cells {
            return Err(FeaturePresentationTransitionError::Shape);
        }
        if transition.source != presentation_binding(source, rows, self.input_count())?
            || transition.target != presentation_binding(target, rows, self.len())?
            || transition.feature_dag_blake3 != self.presentation_digest()?
        {
            return Err(FeaturePresentationTransitionError::Binding);
        }
        let mut workspace = self.workspace();
        for (inputs, expected) in source
            .chunks_exact(self.input_count())
            .zip(target.chunks_exact(self.len()))
        {
            if self.evaluate(inputs, &mut workspace)? != expected {
                return Err(FeaturePresentationTransitionError::Binding);
            }
        }
        Ok(())
    }

    fn presentation_shapes(
        &self,
        rows: usize,
    ) -> Result<(usize, usize), FeaturePresentationTransitionError> {
        if rows == 0 || rows > MAX_FEATURE_PRESENTATION_ROWS || self.is_empty() {
            return Err(FeaturePresentationTransitionError::Bounds);
        }
        let source_cells = rows
            .checked_mul(self.input_count())
            .ok_or(FeaturePresentationTransitionError::Bounds)?;
        let target_cells = rows
            .checked_mul(self.len())
            .ok_or(FeaturePresentationTransitionError::Bounds)?;
        if source_cells > MAX_FEATURE_PRESENTATION_CELLS
            || target_cells > MAX_FEATURE_PRESENTATION_CELLS
        {
            return Err(FeaturePresentationTransitionError::Bounds);
        }
        Ok((source_cells, target_cells))
    }

    fn presentation_digest(&self) -> Result<[u8; 32], FeaturePresentationTransitionError> {
        let bytes = serde_json::to_vec(&self.snapshot())
            .map_err(|_| FeaturePresentationTransitionError::Encoding)?;
        Ok(*blake3::hash(&bytes).as_bytes())
    }

    fn require(&self, id: FeatureId) -> Result<FeatureNode, FeatureDagError> {
        self.node(id).copied().ok_or(FeatureDagError::UnknownNode)
    }

    fn push_with_residues(
        &mut self,
        term: FeatureId,
        moduli: &[u16],
        output: &mut Vec<FeatureId>,
    ) -> Result<(), FeatureDagError> {
        output.push(term);
        for &modulus in moduli {
            output.push(self.modulo(term, modulus)?);
        }
        Ok(())
    }

    fn binary_metadata(
        &self,
        left: FeatureId,
        right: FeatureId,
        mul: bool,
        own: u32,
    ) -> Result<(u8, u32), FeatureDagError> {
        let left = self.require(left)?;
        let right = self.require(right)?;
        let degree = if mul {
            left.degree
                .checked_add(right.degree)
                .ok_or(FeatureDagError::DegreeExceeded)?
        } else {
            left.degree.max(right.degree)
        };
        Ok((
            degree,
            plus(plus(left.evaluation_cost, right.evaluation_cost)?, own)?,
        ))
    }

    fn norm_metadata(
        &self,
        left: FeatureId,
        right: FeatureId,
        own: u32,
    ) -> Result<(u8, u32), FeatureDagError> {
        let left = self.require(left)?;
        let right = self.require(right)?;
        let degree = left
            .degree
            .max(right.degree)
            .checked_mul(2)
            .ok_or(FeatureDagError::DegreeExceeded)?;
        Ok((
            degree,
            plus(plus(left.evaluation_cost, right.evaluation_cost)?, own)?,
        ))
    }

    fn intern(
        &mut self,
        op: FeatureOp,
        degree: u8,
        evaluation_cost: u32,
    ) -> Result<FeatureId, FeatureDagError> {
        if degree > self.maximum_degree {
            return Err(FeatureDagError::DegreeExceeded);
        }
        if let Some(&id) = self.interned.get(&op) {
            return Ok(id);
        }
        if self.nodes.len() == self.maximum_nodes || self.nodes.len() > u32::MAX as usize {
            return Err(FeatureDagError::NodeLimit);
        }
        let id = FeatureId(self.nodes.len() as u32);
        self.nodes.push(FeatureNode {
            op,
            degree,
            evaluation_cost,
        });
        self.interned.insert(op, id);
        Ok(id)
    }
}

pub struct FeatureWorkspace {
    values: Vec<i64>,
}

impl FeatureWorkspace {
    pub fn value(&self, id: FeatureId) -> Option<i64> {
        self.values.get(id.index()).copied()
    }
}

fn ordered(left: FeatureId, right: FeatureId) -> (FeatureId, FeatureId) {
    if left <= right {
        (left, right)
    } else {
        (right, left)
    }
}

fn push_conflict_proposal(
    proposals: &mut Vec<(u16, u16, Option<u16>)>,
    proposal: (u16, u16, Option<u16>),
    maximum_candidates: usize,
) -> Result<(), FeatureDagError> {
    if proposals.len() == maximum_candidates {
        return Err(FeatureDagError::CandidateLimit);
    }
    proposals.push(proposal);
    Ok(())
}

fn plus(left: u32, right: u32) -> Result<u32, FeatureDagError> {
    left.checked_add(right).ok_or(FeatureDagError::CostOverflow)
}

fn norm(left: i64, right: i64, eisenstein: bool) -> Result<i64, FeatureDagError> {
    let left_square = left
        .checked_mul(left)
        .ok_or(FeatureDagError::ArithmeticOverflow)?;
    let right_square = right
        .checked_mul(right)
        .ok_or(FeatureDagError::ArithmeticOverflow)?;
    let partial = if eisenstein {
        left_square.checked_sub(
            left.checked_mul(right)
                .ok_or(FeatureDagError::ArithmeticOverflow)?,
        )
    } else {
        Some(left_square)
    };
    partial
        .and_then(|value| value.checked_add(right_square))
        .ok_or(FeatureDagError::ArithmeticOverflow)
}

fn presentation_binding(
    values: &[i64],
    rows: usize,
    columns: usize,
) -> Result<FeaturePresentationBinding, FeaturePresentationTransitionError> {
    let rows = u32::try_from(rows).map_err(|_| FeaturePresentationTransitionError::Bounds)?;
    let columns = u32::try_from(columns).map_err(|_| FeaturePresentationTransitionError::Bounds)?;
    let mut hasher = blake3::Hasher::new();
    hasher.update(b"ergodis-feature-presentation-v1\0");
    hasher.update(&rows.to_le_bytes());
    hasher.update(&columns.to_le_bytes());
    for value in values {
        hasher.update(&value.to_le_bytes());
    }
    Ok(FeaturePresentationBinding {
        rows,
        columns,
        values_blake3: *hasher.finalize().as_bytes(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn interns_commutative_terms_and_enforces_degree() {
        let mut dag = FeatureDag::new(2, 2, 16).unwrap();
        let x = dag.input(0).unwrap();
        let y = dag.input(1).unwrap();
        let xy = dag.mul(x, y).unwrap();
        assert_eq!(xy, dag.mul(y, x).unwrap());
        assert_eq!(dag.node(xy).unwrap().degree, 2);
        assert_eq!(dag.mul(xy, x), Err(FeatureDagError::DegreeExceeded));
    }

    #[test]
    fn evaluates_residues_and_norms_without_rebuilding() {
        let mut dag = FeatureDag::new(2, 2, 16).unwrap();
        let x = dag.input(0).unwrap();
        let y = dag.input(1).unwrap();
        let residue = dag.modulo(x, 7).unwrap();
        let gaussian = dag.gaussian_norm(x, y).unwrap();
        let eisenstein = dag.eisenstein_norm(x, y).unwrap();
        let mut workspace = dag.workspace();
        dag.evaluate(&[-2, 3], &mut workspace).unwrap();
        assert_eq!(workspace.value(residue), Some(5));
        assert_eq!(workspace.value(gaussian), Some(13));
        assert_eq!(workspace.value(eisenstein), Some(19));
    }

    #[test]
    fn rejects_stale_workspace_and_checked_overflow() {
        let mut dag = FeatureDag::new(1, 2, 8).unwrap();
        let x = dag.input(0).unwrap();
        let mut workspace = dag.workspace();
        let _square = dag.mul(x, x).unwrap();
        assert_eq!(
            dag.evaluate(&[2], &mut workspace),
            Err(FeatureDagError::WorkspaceWidth)
        );
        workspace = dag.workspace();
        assert_eq!(
            dag.evaluate(&[i64::MAX], &mut workspace),
            Err(FeatureDagError::ArithmeticOverflow)
        );
    }

    #[test]
    fn prepared_row_evaluation_allocates_nothing() {
        let mut dag = FeatureDag::new(2, 2, 16).unwrap();
        let x = dag.input(0).unwrap();
        let y = dag.input(1).unwrap();
        let _residue = dag.modulo(x, 7).unwrap();
        let _norm = dag.eisenstein_norm(x, y).unwrap();
        let mut workspace = dag.workspace();
        let (result, events) = crate::test_alloc::measure_current_thread_allocations(|| {
            dag.evaluate(&[11, -4], &mut workspace).map(|_| ())
        });
        result.unwrap();
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn runtime_expansion_builds_raw_degree_two_bank() {
        let mut dag = FeatureDag::new(2, 2, 128).unwrap();
        let candidates = dag
            .expand_raw_degree_two(RawFeatureExpansion {
                moduli: &[3, 7],
                include_gaussian_norms: true,
                include_eisenstein_norms: true,
                ..RawFeatureExpansion::default()
            })
            .unwrap();
        assert!(candidates.len() > 20);
        assert!(dag
            .nodes()
            .iter()
            .any(|node| matches!(node.op, FeatureOp::Mod { modulus: 7, .. })));
        assert!(dag
            .nodes()
            .iter()
            .any(|node| matches!(node.op, FeatureOp::EisensteinNorm { .. })));
        assert!(dag.nodes().iter().all(|node| node.degree <= 2));
    }

    #[test]
    fn runtime_expansion_respects_selected_input_scope() {
        let mut dag = FeatureDag::new(4, 2, 128).unwrap();
        let candidates = dag
            .expand_raw_degree_two(RawFeatureExpansion {
                input_indices: Some(&[3, 1, 3]),
                ..RawFeatureExpansion::default()
            })
            .unwrap();
        let scopes = FeatureScopeBank::compile(&dag, dag.len()).unwrap();
        assert!(candidates.iter().all(|&candidate| {
            let mask = scopes.scope_mask(candidate).unwrap()[0];
            mask != 0 && mask & !0b1010 == 0
        }));
        assert_eq!(
            dag.expand_raw_degree_two(RawFeatureExpansion {
                input_indices: Some(&[4]),
                ..RawFeatureExpansion::default()
            }),
            Err(FeatureDagError::InputOutOfRange)
        );
    }

    #[test]
    fn conflict_expansion_generates_only_separating_differences() {
        let mut dag = FeatureDag::new(3, 2, 64).unwrap();
        let positive = [3_i64, 3, 5];
        let false_positive = [3_i64, 4, 8];
        let candidates = dag
            .expand_conflict_differences(
                &positive,
                &false_positive,
                ConflictFeatureExpansion {
                    input_indices: None,
                    moduli: &[3, 2, 2],
                    maximum_candidates: 8,
                },
            )
            .unwrap();
        assert!(!candidates.is_empty());
        let mut workspace = dag.workspace();
        let positive_values = dag.evaluate(&positive, &mut workspace).unwrap().to_vec();
        let negative_values = dag
            .evaluate(&false_positive, &mut workspace)
            .unwrap()
            .to_vec();
        assert!(candidates.iter().all(|candidate| {
            positive_values[candidate.index()] == 0 && negative_values[candidate.index()] != 0
        }));
    }

    #[test]
    fn conflict_expansion_preflights_its_candidate_bound() {
        let mut dag = FeatureDag::new(3, 2, 64).unwrap();
        let before = dag.len();
        assert_eq!(
            dag.expand_conflict_differences(
                &[3, 3, 5],
                &[3, 4, 8],
                ConflictFeatureExpansion {
                    input_indices: None,
                    moduli: &[2, 3],
                    maximum_candidates: 1,
                },
            ),
            Err(FeatureDagError::CandidateLimit)
        );
        assert_eq!(dag.len(), before);
    }

    #[test]
    fn scope_bank_tracks_transitive_dependencies_compactly() {
        let mut dag = FeatureDag::new(70, 2, 128).unwrap();
        let x = dag.input(1).unwrap();
        let y = dag.input(65).unwrap();
        let constant = dag.constant(7).unwrap();
        let sum = dag.add(x, y).unwrap();
        let shifted = dag.sub(sum, constant).unwrap();
        let bank = FeatureScopeBank::compile(&dag, dag.len() * 2).unwrap();
        assert_eq!(bank.input_count(), 70);
        assert_eq!(bank.features(), dag.len());
        assert_eq!(bank.scope_mask(constant), Some(&[0, 0][..]));
        assert_eq!(
            bank.scope_mask(shifted),
            Some(&[1_u64 << 1, 1_u64 << 1][..])
        );
        assert_eq!(bank.scope_size(shifted), Some(2));
    }

    #[test]
    fn observed_support_projection_and_downstream_pareto_are_exact() {
        let mut dag = FeatureDag::new(2, 2, 16).unwrap();
        let left = dag.input(0).unwrap();
        let right = dag.input(1).unwrap();
        let sum = dag.add(left, right).unwrap();
        let product = dag.mul(left, right).unwrap();
        let rows = [0, 0, 1, 0, 0, 1, 1, 1];
        let supports = ObservedFeatureSupportBank::compile(
            &dag,
            &rows,
            Some(&[0b0111]),
            ObservedFeatureSupportBounds {
                maximum_rows: 4,
                maximum_cells: 12,
                maximum_values_per_feature: 4,
                maximum_total_values: 8,
            },
        )
        .unwrap();
        assert_eq!(supports.selected_rows(), 3);
        assert_eq!(supports.support(left), Some(&[0, 1][..]));
        assert_eq!(supports.support(sum), Some(&[0, 1][..]));
        assert_eq!(supports.support(product), Some(&[0][..]));
        assert!(matches!(
            ObservedFeatureSupportBank::compile(
                &dag,
                &rows,
                Some(&[1_u64 << 4]),
                ObservedFeatureSupportBounds {
                    maximum_rows: 4,
                    maximum_cells: 12,
                    maximum_values_per_feature: 4,
                    maximum_total_values: 8,
                },
            ),
            Err(ObservedFeatureSupportError::ReachabilityTail)
        ));

        let scopes = FeatureScopeBank::compile(&dag, dag.len()).unwrap();
        let frontier = supports
            .pareto_frontier(
                &dag,
                &scopes,
                &[left, right, sum, product],
                &[0, 1, 5, 5],
                4,
            )
            .unwrap();
        assert_eq!(
            frontier
                .iter()
                .map(|score| score.feature)
                .collect::<Vec<_>>(),
            vec![right, product]
        );
    }

    #[test]
    fn snapshot_round_trip_preserves_ids_and_values() {
        let mut dag = FeatureDag::new(2, 2, 128).unwrap();
        dag.expand_raw_degree_two(RawFeatureExpansion {
            moduli: &[5],
            include_eisenstein_norms: true,
            ..RawFeatureExpansion::default()
        })
        .unwrap();
        let encoded = serde_json::to_vec(&dag.snapshot()).unwrap();
        let snapshot: FeatureDagSnapshot = serde_json::from_slice(&encoded).unwrap();
        let restored = FeatureDag::from_snapshot(&snapshot, 128).unwrap();
        assert_eq!(restored.nodes(), dag.nodes());
        let mut left = dag.workspace();
        let mut right = restored.workspace();
        assert_eq!(
            dag.evaluate(&[-9, 4], &mut left).unwrap(),
            restored.evaluate(&[-9, 4], &mut right).unwrap()
        );
    }

    #[test]
    fn snapshot_rejects_duplicate_and_future_nodes() {
        let duplicate = FeatureDagSnapshot {
            version: FEATURE_DAG_SNAPSHOT_VERSION,
            input_count: 1,
            maximum_degree: 2,
            operations: vec![FeatureOp::Input { index: 0 }; 2].into_boxed_slice(),
        };
        assert!(matches!(
            FeatureDag::from_snapshot(&duplicate, 8),
            Err(FeatureDagError::NonCanonicalSnapshot)
        ));
        let future = FeatureDagSnapshot {
            version: FEATURE_DAG_SNAPSHOT_VERSION,
            input_count: 1,
            maximum_degree: 2,
            operations: vec![FeatureOp::Abs {
                source: FeatureId(1),
            }]
            .into_boxed_slice(),
        };
        assert!(matches!(
            FeatureDag::from_snapshot(&future, 8),
            Err(FeatureDagError::UnknownNode)
        ));
    }

    #[test]
    fn zero_bank_scores_necessary_predicates_from_bitmaps() {
        let mut dag = FeatureDag::new(1, 2, 8).unwrap();
        let x = dag.input(0).unwrap();
        let bank = FeatureZeroBank::compile(
            &dag,
            &[-2, 0, 3],
            FeatureBankBounds {
                maximum_rows: 3,
                maximum_bitmap_words: 1,
            },
        )
        .unwrap();
        assert_eq!(bank.zero_mask(x), Some(&[0b010][..]));
        let census = bank.score_necessary_zero(x, &[0b010]).unwrap();
        assert_eq!(
            census,
            FeaturePredicateCensus {
                rows: 3,
                expected: 1,
                surviving: 1,
                false_negatives: 0,
            }
        );
        assert_eq!(
            bank.score_necessary_zero(x, &[1_u64 << 63]),
            Err(FeatureBankError::LabelTail)
        );
    }

    #[test]
    fn zero_bank_scores_conjunctions_without_materializing_pairs() {
        let mut dag = FeatureDag::new(2, 2, 8).unwrap();
        let x = dag.input(0).unwrap();
        let y = dag.input(1).unwrap();
        let rows = [0_i64, 0, 0, 1, 1, 0, 1, 1];
        let bank = FeatureZeroBank::compile(
            &dag,
            &rows,
            FeatureBankBounds {
                maximum_rows: 4,
                maximum_bitmap_words: 2,
            },
        )
        .unwrap();
        let conjunction = FeatureZeroConjunction::new(y, x);
        assert_eq!(conjunction, FeatureZeroConjunction { left: x, right: y });
        assert_eq!(
            bank.score_necessary_zero(x, &[0b0001]).unwrap().surviving,
            2
        );
        let census = bank
            .score_necessary_zero_conjunction(conjunction, &[0b0001])
            .unwrap();
        assert_eq!(census.surviving, 1);
        assert_eq!(census.false_negatives, 0);
        let scopes = FeatureScopeBank::compile(&dag, 2).unwrap();
        assert_eq!(scopes.conjunction_scope_size(conjunction), Some(2));
    }

    #[test]
    fn zero_quotient_keeps_cheapest_exact_observational_representative() {
        let mut dag = FeatureDag::new(2, 2, 16).unwrap();
        let x = dag.input(0).unwrap();
        let y = dag.input(1).unwrap();
        let absolute_x = dag.abs(x).unwrap();
        let square_x = dag.mul(x, x).unwrap();
        let rows = [-2_i64, 1, 0, 1, 3, 0, 0, 2];
        let bank = FeatureZeroBank::compile(
            &dag,
            &rows,
            FeatureBankBounds {
                maximum_rows: 4,
                maximum_bitmap_words: dag.len(),
            },
        )
        .unwrap();
        let quotient = bank
            .quotient_zero_predicates(&dag, &[square_x, y, absolute_x, x, x], 5)
            .unwrap();
        assert_eq!(quotient.input_candidates(), 4);
        assert_eq!(quotient.class_count(), 2);
        assert_eq!(quotient.eliminated(), 2);
        assert_eq!(quotient.representative(x), Some(x));
        assert_eq!(quotient.representative(absolute_x), Some(x));
        assert_eq!(quotient.representative(square_x), Some(x));
        assert_eq!(quotient.representative(y), Some(y));
    }

    #[test]
    fn zero_bank_rejects_an_empty_observation_corpus() {
        let mut dag = FeatureDag::new(1, 1, 2).unwrap();
        dag.input(0).unwrap();
        assert_eq!(
            FeatureZeroBank::compile(
                &dag,
                &[],
                FeatureBankBounds {
                    maximum_rows: 1,
                    maximum_bitmap_words: 1,
                },
            )
            .map(|_| ()),
            Err(FeatureBankError::EmptyCorpus)
        );
    }

    #[test]
    fn zero_bank_rescoring_allocates_nothing() {
        let mut dag = FeatureDag::new(2, 2, 64).unwrap();
        let candidates = dag
            .expand_raw_degree_two(RawFeatureExpansion {
                moduli: &[3],
                ..RawFeatureExpansion::default()
            })
            .unwrap();
        let rows = (0_i64..32)
            .flat_map(|left| [left, 31 - left])
            .collect::<Vec<_>>();
        let bank = FeatureZeroBank::compile(
            &dag,
            &rows,
            FeatureBankBounds {
                maximum_rows: 32,
                maximum_bitmap_words: dag.len(),
            },
        )
        .unwrap();
        let expected = [0x0000_0000_0000_ffff];
        let (_, events) = crate::test_alloc::measure_current_thread_allocations(|| {
            for &candidate in candidates.iter() {
                std::hint::black_box(bank.score_necessary_zero(candidate, &expected).unwrap());
            }
            for pair in candidates.windows(2) {
                let conjunction = FeatureZeroConjunction::new(pair[0], pair[1]);
                std::hint::black_box(
                    bank.score_necessary_zero_conjunction(conjunction, &expected)
                        .unwrap(),
                );
            }
        });
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn presentation_transition_round_trips_and_rejects_forgery() {
        let mut dag = FeatureDag::new(2, 1, 8).unwrap();
        let left = dag.input(0).unwrap();
        let right = dag.input(1).unwrap();
        dag.add(left, right).unwrap();
        dag.sub(left, right).unwrap();
        let source = [2, 3, -1, 4];

        let (target, transition) = dag.derive_presentation_transition(&source, 2).unwrap();
        assert_eq!(&*target, &[2, 3, 5, -1, -1, 4, 3, -5]);
        dag.verify_presentation_transition(&source, &target, &transition)
            .unwrap();
        let encoded = serde_json::to_vec(&transition).unwrap();
        let decoded: FeaturePresentationTransition = serde_json::from_slice(&encoded).unwrap();
        assert_eq!(decoded, transition);

        let bundle = dag.diagnostic_bundle(transition).unwrap();
        let restored = FeatureDag::restore_diagnostic_bundle(&bundle, 8, &source, &target).unwrap();
        assert_eq!(restored.snapshot(), dag.snapshot());
        let encoded = serde_json::to_vec(&bundle).unwrap();
        let decoded: DiagnosticFeatureDagBundle = serde_json::from_slice(&encoded).unwrap();
        assert_eq!(decoded, bundle);

        let mut forged_target = target.clone();
        forged_target[7] = -4;
        assert_eq!(
            dag.verify_presentation_transition(&source, &forged_target, &transition),
            Err(FeaturePresentationTransitionError::Binding)
        );
        let mut forged_authority = transition;
        forged_authority.proof_authority = true;
        assert_eq!(
            dag.verify_presentation_transition(&source, &target, &forged_authority),
            Err(FeaturePresentationTransitionError::InvalidProofAuthority)
        );
        let mut forged_bundle = bundle;
        forged_bundle.proof_authority = true;
        assert!(matches!(
            FeatureDag::restore_diagnostic_bundle(&forged_bundle, 8, &source, &target),
            Err(DiagnosticFeatureDagBundleError::InvalidProofAuthority)
        ));
    }

    #[test]
    fn presentation_transition_enforces_cold_resource_bounds() {
        let mut dag = FeatureDag::new(1, 1, 1).unwrap();
        dag.input(0).unwrap();
        assert_eq!(
            dag.derive_presentation_transition(&[], 0),
            Err(FeaturePresentationTransitionError::Bounds)
        );
        assert_eq!(
            dag.derive_presentation_transition(&[], MAX_FEATURE_PRESENTATION_ROWS + 1),
            Err(FeaturePresentationTransitionError::Bounds)
        );
    }
}
