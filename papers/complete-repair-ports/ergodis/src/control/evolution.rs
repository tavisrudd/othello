use super::{
    vm::evaluate_plan_cascaded, CompiledPlan, ControlError, FeatureBatch,
    FeatureGeneratorProvenance, PlanOp, PlanScope, PlanSpec,
};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::{BTreeMap, BTreeSet, BinaryHeap};
use std::fs::File;
use std::io::{BufRead, BufReader, BufWriter, Write};
use std::path::Path;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::Arc;

const EVOLUTION_EVIDENCE_SCHEMA: &str = "ergodis-evolution-evidence-v0";
const MAX_EVOLUTION_IMPORT_BYTES: u64 = 16 * 1024 * 1024;
const MAX_EVOLUTION_RECORD_BYTES: usize = 256 * 1024;
const MAX_EVOLUTION_FOOTER_BYTES: u64 = 8 * 1024;
const MAX_FAILURE_PROBES: usize = 8;
const MAX_TARGETED_MUTATIONS: usize = 24;
const MAX_HINDSIGHT_FRAGMENTS: usize = 64;
const MAX_HINDSIGHT_SEMANTICS: usize = 256;
const MAX_HINDSIGHT_PROBES_PER_PARENT: usize = 16;
const MAX_HINDSIGHT_FRAGMENTS_PER_PARENT: usize = 4;
const MAX_HINDSIGHT_COMPOSITION_PROBES: usize = 64;
const MAX_HINDSIGHT_COMPOSITION_PROBES_PER_GENERATION: usize = 16;
const MAX_HINDSIGHT_COMPOSITIONS_PER_GENERATION: usize = 8;

#[derive(Clone)]
pub(super) struct EvolutionIdentity {
    pub code_commit: String,
    pub presentation_hash: String,
    pub presentation: String,
    pub problem: String,
    pub fields: Box<[String]>,
    pub generator: Option<FeatureGeneratorProvenance>,
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct EvolutionEvidenceHeader {
    schema: String,
    code_commit: String,
    presentation_hash: String,
    presentation: String,
    problem: String,
    fields: Box<[String]>,
    generator: Option<FeatureGeneratorProvenance>,
}

impl From<&EvolutionIdentity> for EvolutionEvidenceHeader {
    fn from(identity: &EvolutionIdentity) -> Self {
        Self {
            schema: EVOLUTION_EVIDENCE_SCHEMA.into(),
            code_commit: identity.code_commit.clone(),
            presentation_hash: identity.presentation_hash.clone(),
            presentation: identity.presentation.clone(),
            problem: identity.problem.clone(),
            fields: identity.fields.clone(),
            generator: identity.generator.clone(),
        }
    }
}

pub(super) struct EvolutionSeed {
    pub plan: PlanSpec,
    pub parent_hash: Option<String>,
    pub source_hash: Option<String>,
    pub source_evidence: Option<String>,
    pub operator: &'static str,
}

pub(super) struct EvolutionReplayFragment {
    plan: PlanSpec,
    pub semantic_hash: String,
    compiled_hash: String,
    source_evidence: String,
}

pub(super) struct EvolutionReplayArchive {
    pub seeds: Vec<EvolutionSeed>,
    pub fragments: Vec<EvolutionReplayFragment>,
}

struct ImportedCandidate {
    seed: EvolutionSeed,
    incorrect: u64,
    weighted_rows: u64,
    false_positive: u64,
    complexity: usize,
}

#[repr(C, align(64))]
pub(super) struct EvolutionProgress {
    tested: AtomicU64,
    generation: AtomicU64,
    perfect: AtomicU64,
    done: AtomicBool,
    cancelled: AtomicBool,
    _pad: [u8; 30],
}

const _: () = assert!(
    std::mem::size_of::<EvolutionProgress>() == 64
        && std::mem::align_of::<EvolutionProgress>() == 64
);

impl EvolutionProgress {
    pub(super) fn new() -> Self {
        Self {
            tested: AtomicU64::new(0),
            generation: AtomicU64::new(0),
            perfect: AtomicU64::new(0),
            done: AtomicBool::new(false),
            cancelled: AtomicBool::new(false),
            _pad: [0; 30],
        }
    }

    pub(super) fn cancel(&self) {
        self.cancelled.store(true, Ordering::Release);
    }

    pub(super) fn snapshot(&self) -> Value {
        json!({
            "tested": self.tested.load(Ordering::Relaxed),
            "generation": self.generation.load(Ordering::Relaxed),
            "perfect": self.perfect.load(Ordering::Relaxed),
            "done": self.done.load(Ordering::Acquire),
            "cancel_requested": self.cancelled.load(Ordering::Acquire),
        })
    }
}

#[derive(Clone, Copy)]
pub(super) struct EvolutionBounds {
    pub generations: usize,
    pub beam: usize,
    pub max_candidates: usize,
    pub byte_limit: u64,
}

struct ScopeMutationProfile {
    field: String,
    observed_mask: u64,
    positive_majority_mask: u64,
}

struct MutationContext<'a> {
    fields: &'a [String],
    scope_profiles: &'a [ScopeMutationProfile],
    field_index: &'a BTreeMap<&'a str, u16>,
}

struct MutationEmitter<'a> {
    parent_hash: &'a str,
    output: &'a mut Vec<PendingCandidate>,
    limit: usize,
    cursor: usize,
    ordinal: usize,
}

impl MutationEmitter<'_> {
    fn emit(&mut self, operator: &'static str, make_plan: impl FnOnce() -> PlanSpec) -> bool {
        if self.ordinal < self.cursor {
            self.ordinal += 1;
            return false;
        }
        if self.output.len() == self.limit {
            return true;
        }
        self.ordinal += 1;
        self.output.push(PendingCandidate {
            plan: make_plan(),
            parent_hash: Some(self.parent_hash.into()),
            source_hash: None,
            source_evidence: None,
            operator,
        });
        false
    }
}

#[derive(Clone, Copy)]
struct MutationBatch {
    next_cursor: usize,
    exhausted: bool,
}

#[derive(Clone, Copy, Default)]
struct FailureProbe {
    field: u16,
    value: i64,
}

#[derive(Clone)]
struct FailureShape {
    first_mismatch: Option<usize>,
    expected: Option<bool>,
    probes: [FailureProbe; MAX_FAILURE_PROBES],
    probe_count: u8,
}

struct PendingCandidate {
    plan: PlanSpec,
    parent_hash: Option<String>,
    source_hash: Option<String>,
    source_evidence: Option<String>,
    operator: &'static str,
}

#[derive(Clone)]
struct ExpansionParent {
    hash: String,
    outcome_hash: String,
    plan: PlanSpec,
    first_mismatch: Option<usize>,
    score: CandidateScore,
    operator: &'static str,
    niche: SemanticNiche,
    mutation_cursor: usize,
}

#[derive(Clone, Copy)]
struct CandidateScore {
    correct: u64,
    false_positive: u64,
    complexity: usize,
}

#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(rename_all = "kebab-case")]
enum FailureNiche {
    Perfect,
    FalsePositive,
    FalseNegative,
    Mixed,
}

#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd, Serialize)]
struct SemanticNiche {
    operator: &'static str,
    failure: FailureNiche,
    semantic_op_row_log2: u8,
}

impl SemanticNiche {
    fn new(
        operator: &'static str,
        false_positive: u64,
        false_negative: u64,
        semantic_op_rows: u64,
    ) -> Self {
        let failure = match (false_positive != 0, false_negative != 0) {
            (false, false) => FailureNiche::Perfect,
            (true, false) => FailureNiche::FalsePositive,
            (false, true) => FailureNiche::FalseNegative,
            (true, true) => FailureNiche::Mixed,
        };
        Self {
            operator,
            failure,
            semantic_op_row_log2: semantic_op_rows.checked_ilog2().unwrap_or(0) as u8,
        }
    }
}

#[derive(Clone)]
struct RankedCandidate {
    score: CandidateScore,
    outcome_hash: String,
    hash: String,
    plan: PlanSpec,
    first_mismatch: Option<usize>,
    operator: &'static str,
    niche: SemanticNiche,
    mutation_cursor: usize,
    retained: bool,
}

impl RankedCandidate {
    fn from_parent(parent: &ExpansionParent) -> Self {
        Self {
            score: parent.score,
            outcome_hash: parent.outcome_hash.clone(),
            hash: parent.hash.clone(),
            plan: parent.plan.clone(),
            first_mismatch: parent.first_mismatch,
            operator: parent.operator,
            niche: parent.niche,
            mutation_cursor: parent.mutation_cursor,
            retained: true,
        }
    }

    fn to_parent(&self) -> ExpansionParent {
        ExpansionParent {
            hash: self.hash.clone(),
            outcome_hash: self.outcome_hash.clone(),
            plan: self.plan.clone(),
            first_mismatch: self.first_mismatch,
            score: self.score,
            operator: self.operator,
            niche: self.niche,
            mutation_cursor: self.mutation_cursor,
        }
    }
}

struct EliteSelection {
    parents: Vec<ExpansionParent>,
    niche_slots: usize,
    global_slots: usize,
    retained_slots: usize,
    outcome_rejections: usize,
}

struct HindsightFragment {
    semantic_hash: String,
    source_hash: Option<String>,
    compiled_hash: String,
    weighted_true_positive: u64,
    rows_evaluated: u64,
    coverage: PositiveCoverage,
    plan: PlanSpec,
}

enum PositiveCoverage {
    Sparse(Box<[usize]>),
    Dense(Box<[u64]>),
}

impl PositiveCoverage {
    fn from_dense(words: Vec<u64>) -> Self {
        let members = words
            .iter()
            .map(|word| word.count_ones() as usize)
            .sum::<usize>();
        if members.saturating_mul(std::mem::size_of::<usize>())
            < words.len().saturating_mul(std::mem::size_of::<u64>())
        {
            let mut rows = Vec::with_capacity(members);
            for (word_index, &word) in words.iter().enumerate() {
                let mut bits = word;
                while bits != 0 {
                    let bit = bits.trailing_zeros() as usize;
                    bits &= bits - 1;
                    rows.push(word_index * 64 + bit);
                }
            }
            Self::Sparse(rows.into_boxed_slice())
        } else {
            Self::Dense(words.into_boxed_slice())
        }
    }

    fn to_dense(&self, words: usize) -> Result<Vec<u64>, ControlError> {
        match self {
            Self::Dense(dense) if dense.len() == words => Ok(dense.to_vec()),
            Self::Dense(_) => Err(ControlError::Invalid(
                "hindsight dense coverage width mismatch".into(),
            )),
            Self::Sparse(rows) => {
                let mut dense = vec![0_u64; words];
                for &row in rows.iter() {
                    let Some(word) = dense.get_mut(row / 64) else {
                        return Err(ControlError::Invalid(
                            "hindsight sparse coverage row is out of range".into(),
                        ));
                    };
                    *word |= 1_u64 << (row % 64);
                }
                Ok(dense)
            }
        }
    }

    fn contains(&self, row: usize) -> bool {
        match self {
            Self::Sparse(rows) => rows.binary_search(&row).is_ok(),
            Self::Dense(words) => words
                .get(row / 64)
                .is_some_and(|word| word >> (row % 64) & 1 != 0),
        }
    }

    fn try_for_each_row(
        &self,
        mut visit: impl FnMut(usize) -> Result<(), ControlError>,
    ) -> Result<(), ControlError> {
        match self {
            Self::Sparse(rows) => {
                for &row in rows.iter() {
                    visit(row)?;
                }
            }
            Self::Dense(words) => {
                for (word_index, &word) in words.iter().enumerate() {
                    let mut bits = word;
                    while bits != 0 {
                        let bit = bits.trailing_zeros() as usize;
                        bits &= bits - 1;
                        visit(word_index * 64 + bit)?;
                    }
                }
            }
        }
        Ok(())
    }

    fn union_dense(&self, other: &Self, words: usize) -> Result<Vec<u64>, ControlError> {
        let mut union = self.to_dense(words)?;
        other.try_for_each_row(|row| {
            let Some(word) = union.get_mut(row / 64) else {
                return Err(ControlError::Invalid(
                    "hindsight union row is out of range".into(),
                ));
            };
            *word |= 1_u64 << (row % 64);
            Ok(())
        })?;
        Ok(union)
    }
}

struct HindsightComposition {
    fragment: HindsightFragment,
    left_semantic_hash: String,
    right_semantic_hash: String,
}

struct HindsightExtraction {
    fragments: Vec<HindsightFragment>,
    probes: usize,
    rows_evaluated: u64,
    false_positive_rejections: usize,
}

struct CompositionExtraction {
    compositions: Vec<HindsightComposition>,
    probes: usize,
    rows_evaluated: u64,
}

struct PremisePair {
    left: usize,
    right: usize,
    weighted_union: u64,
    marginal_gain: u64,
    semantic_ops: usize,
}

fn premise_pair_cmp(left: &PremisePair, right: &PremisePair) -> std::cmp::Ordering {
    diminishing_ratio_cmp(
        left.marginal_gain,
        left.semantic_ops as u64,
        1,
        right.marginal_gain,
        right.semantic_ops as u64,
        1,
    )
    .reverse()
    .then_with(|| right.weighted_union.cmp(&left.weighted_union))
    .then_with(|| left.semantic_ops.cmp(&right.semantic_ops))
    .then_with(|| left.left.cmp(&right.left))
    .then_with(|| left.right.cmp(&right.right))
}

struct ReplayExtraction {
    fragment: Option<HindsightFragment>,
    rows_evaluated: u64,
}

#[derive(Clone, Copy)]
struct ParentSelectionProfile {
    score: CandidateScore,
    correct_gain_numerator: u64,
    false_positive_reduction_numerator: u64,
    correct_gain_cost: u64,
    false_positive_reduction_cost: u64,
    improved: u64,
    compared_to_parent: u64,
}

struct SelectionEntry<'a> {
    index: usize,
    quota: usize,
    profile: ParentSelectionProfile,
    hash: &'a str,
}

impl PartialEq for SelectionEntry<'_> {
    fn eq(&self, other: &Self) -> bool {
        self.index == other.index && self.quota == other.quota
    }
}

impl Eq for SelectionEntry<'_> {}

impl PartialOrd for SelectionEntry<'_> {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for SelectionEntry<'_> {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        parent_selection_cmp(self.profile, self.quota, other.profile, other.quota)
            .then_with(|| other.hash.cmp(self.hash))
            .then_with(|| other.index.cmp(&self.index))
    }
}

#[derive(Serialize)]
struct CandidateImpact {
    improved: bool,
    correct_gain: u64,
    correct_loss: u64,
    false_positive_reduction: u64,
    false_positive_increase: u64,
}

#[derive(Default, Serialize)]
struct OperatorScorecard {
    trials: u64,
    completed: u64,
    compared_to_parent: u64,
    cascade_rejected: u64,
    improved: u64,
    perfect: u64,
    rows_evaluated: u64,
    semantic_op_rows: u64,
    best_correct_gain: u64,
    best_false_positive_reduction: u64,
    best_correct_gain_per_cost_numerator: u64,
    best_false_positive_reduction_per_cost_numerator: u64,
    best_correct_gain_per_cost_denominator: Option<u64>,
    best_false_positive_reduction_per_cost_denominator: Option<u64>,
    minimum_improving_semantic_op_rows: Option<u64>,
}

type EvolutionRankKey = (std::cmp::Reverse<u64>, u64, usize);

#[inline]
fn evolution_rank_key(correct: u64, false_positive: u64, complexity: usize) -> EvolutionRankKey {
    (std::cmp::Reverse(correct), false_positive, complexity)
}

#[inline]
fn can_enter_beam(
    survivor_keys: &[EvolutionRankKey],
    beam: usize,
    maximum_correct: u64,
    false_positive: u64,
    complexity: usize,
) -> bool {
    survivor_keys.len() < beam
        || evolution_rank_key(maximum_correct, false_positive, complexity)
            <= survivor_keys[survivor_keys.len() - 1]
}

#[inline]
fn fair_share(total: usize, index: usize, count: usize) -> usize {
    debug_assert!(count != 0 && index < count);
    total / count + usize::from(index < total % count)
}

fn diminishing_ratio_cmp(
    left_numerator: u64,
    left_cost: u64,
    left_quota: usize,
    right_numerator: u64,
    right_cost: u64,
    right_quota: usize,
) -> std::cmp::Ordering {
    let left_denominator = u128::from(left_cost.max(1)) * left_quota as u128;
    let right_denominator = u128::from(right_cost.max(1)) * right_quota as u128;
    positive_ratio_cmp(
        u128::from(left_numerator),
        left_denominator,
        u128::from(right_numerator),
        right_denominator,
    )
}

fn positive_ratio_cmp(
    mut left_numerator: u128,
    mut left_denominator: u128,
    mut right_numerator: u128,
    mut right_denominator: u128,
) -> std::cmp::Ordering {
    debug_assert!(left_denominator != 0 && right_denominator != 0);
    let mut reversed = false;
    loop {
        let left_quotient = left_numerator / left_denominator;
        let right_quotient = right_numerator / right_denominator;
        if left_quotient != right_quotient {
            let ordering = left_quotient.cmp(&right_quotient);
            return if reversed {
                ordering.reverse()
            } else {
                ordering
            };
        }
        let left_remainder = left_numerator % left_denominator;
        let right_remainder = right_numerator % right_denominator;
        if left_remainder == 0 || right_remainder == 0 {
            let ordering = left_remainder.cmp(&right_remainder);
            return if reversed {
                ordering.reverse()
            } else {
                ordering
            };
        }
        left_numerator = left_denominator;
        left_denominator = left_remainder;
        right_numerator = right_denominator;
        right_denominator = right_remainder;
        reversed = !reversed;
    }
}

fn parent_selection_cmp(
    left: ParentSelectionProfile,
    left_quota: usize,
    right: ParentSelectionProfile,
    right_quota: usize,
) -> std::cmp::Ordering {
    diminishing_ratio_cmp(
        left.correct_gain_numerator,
        left.correct_gain_cost,
        left_quota,
        right.correct_gain_numerator,
        right.correct_gain_cost,
        right_quota,
    )
    .then_with(|| {
        diminishing_ratio_cmp(
            left.false_positive_reduction_numerator,
            left.false_positive_reduction_cost,
            left_quota,
            right.false_positive_reduction_numerator,
            right.false_positive_reduction_cost,
            right_quota,
        )
    })
    .then_with(|| {
        diminishing_ratio_cmp(
            left.improved,
            left.compared_to_parent,
            left_quota,
            right.improved,
            right.compared_to_parent,
            right_quota,
        )
    })
    .then_with(|| right_quota.cmp(&left_quota))
    .then_with(|| {
        evolution_rank_key(
            right.score.correct,
            right.score.false_positive,
            right.score.complexity,
        )
        .cmp(&evolution_rank_key(
            left.score.correct,
            left.score.false_positive,
            left.score.complexity,
        ))
    })
}

fn maximum_oriented_quotas(
    parents: &[ExpansionParent],
    total: usize,
    scorecards: &BTreeMap<&'static str, OperatorScorecard>,
) -> Vec<usize> {
    if parents.is_empty() {
        return Vec::new();
    }
    debug_assert!(total >= parents.len());
    if parents.len() == 1 {
        return vec![total];
    }
    if total == parents.len() {
        return vec![1; parents.len()];
    }
    if !selection_has_signal(parents, scorecards) {
        return (0..parents.len())
            .map(|index| fair_share(total, index, parents.len()))
            .collect();
    }
    let mut quotas = vec![1_usize; parents.len()];
    let mut heap = parents
        .iter()
        .enumerate()
        .map(|(index, parent)| {
            let scorecard = scorecards.get(parent.operator);
            SelectionEntry {
                index,
                quota: 1,
                profile: ParentSelectionProfile {
                    score: parent.score,
                    correct_gain_numerator: scorecard
                        .map_or(0, |score| score.best_correct_gain_per_cost_numerator),
                    false_positive_reduction_numerator: scorecard.map_or(0, |score| {
                        score.best_false_positive_reduction_per_cost_numerator
                    }),
                    correct_gain_cost: scorecard
                        .and_then(|score| score.best_correct_gain_per_cost_denominator)
                        .unwrap_or(1),
                    false_positive_reduction_cost: scorecard
                        .and_then(|score| score.best_false_positive_reduction_per_cost_denominator)
                        .unwrap_or(1),
                    improved: scorecard.map_or(0, |score| score.improved),
                    compared_to_parent: scorecard.map_or(0, |score| score.compared_to_parent),
                },
                hash: &parent.hash,
            }
        })
        .collect::<BinaryHeap<_>>();
    for _ in parents.len()..total {
        let Some(mut selected) = heap.pop() else {
            return (0..parents.len())
                .map(|index| fair_share(total, index, parents.len()))
                .collect();
        };
        quotas[selected.index] += 1;
        selected.quota += 1;
        heap.push(selected);
    }
    quotas
}

fn selection_has_signal(
    parents: &[ExpansionParent],
    scorecards: &BTreeMap<&'static str, OperatorScorecard>,
) -> bool {
    parents.iter().any(|parent| {
        scorecards
            .get(parent.operator)
            .is_some_and(|score| score.compared_to_parent != 0)
    })
}

fn candidate_impact(child: CandidateScore, parent: CandidateScore) -> CandidateImpact {
    CandidateImpact {
        improved: evolution_rank_key(child.correct, child.false_positive, child.complexity)
            < evolution_rank_key(parent.correct, parent.false_positive, parent.complexity),
        correct_gain: child.correct.saturating_sub(parent.correct),
        correct_loss: parent.correct.saturating_sub(child.correct),
        false_positive_reduction: parent.false_positive.saturating_sub(child.false_positive),
        false_positive_increase: child.false_positive.saturating_sub(parent.false_positive),
    }
}

fn ranked_candidate_cmp(left: &RankedCandidate, right: &RankedCandidate) -> std::cmp::Ordering {
    left.retained
        .cmp(&right.retained)
        .then_with(|| right.score.correct.cmp(&left.score.correct))
        .then_with(|| left.score.false_positive.cmp(&right.score.false_positive))
        .then_with(|| left.score.complexity.cmp(&right.score.complexity))
        .then_with(|| left.plan.name.cmp(&right.plan.name))
        .then_with(|| left.hash.cmp(&right.hash))
}

fn select_semantic_elites(
    mut ranked: Vec<RankedCandidate>,
    retained: &[ExpansionParent],
    beam: usize,
    capacity: usize,
) -> EliteSelection {
    let limit = beam.min(capacity);
    ranked.extend(retained.iter().map(RankedCandidate::from_parent));
    ranked.sort_unstable_by(ranked_candidate_cmp);
    let mut parents = Vec::with_capacity(limit);
    let mut selected = vec![false; ranked.len()];
    let mut selected_hashes = BTreeSet::new();
    let mut selected_outcomes = BTreeSet::new();
    let mut selected_niches = BTreeSet::new();
    let mut retained_slots = 0;

    for (index, candidate) in ranked.iter().enumerate() {
        if parents.len() == limit {
            break;
        }
        if selected_niches.contains(&candidate.niche)
            || selected_outcomes.contains(&candidate.outcome_hash)
            || selected_hashes.contains(&candidate.hash)
        {
            continue;
        }
        selected_niches.insert(candidate.niche);
        selected_outcomes.insert(candidate.outcome_hash.clone());
        selected_hashes.insert(candidate.hash.clone());
        selected[index] = true;
        retained_slots += usize::from(candidate.retained);
        parents.push(candidate.to_parent());
    }
    let niche_slots = parents.len();
    let mut outcome_rejections = 0;
    for (index, candidate) in ranked.iter().enumerate() {
        if parents.len() == limit {
            break;
        }
        if selected[index] || selected_hashes.contains(&candidate.hash) {
            continue;
        }
        if !selected_outcomes.insert(candidate.outcome_hash.clone()) {
            outcome_rejections += 1;
            continue;
        }
        selected_hashes.insert(candidate.hash.clone());
        retained_slots += usize::from(candidate.retained);
        parents.push(candidate.to_parent());
    }
    EliteSelection {
        global_slots: parents.len() - niche_slots,
        parents,
        niche_slots,
        retained_slots,
        outcome_rejections,
    }
}

fn plan_op_arity(op: &PlanOp) -> usize {
    match op {
        PlanOp::Field { .. } | PlanOp::Const { .. } | PlanOp::Bool { .. } => 0,
        PlanOp::Not | PlanOp::Abs => 1,
        PlanOp::Select => 3,
        PlanOp::Add
        | PlanOp::Sub
        | PlanOp::Mul
        | PlanOp::Min
        | PlanOp::Max
        | PlanOp::Eq
        | PlanOp::Ne
        | PlanOp::Lt
        | PlanOp::Le
        | PlanOp::Gt
        | PlanOp::Ge
        | PlanOp::And
        | PlanOp::Or => 2,
    }
}

#[derive(Clone, Copy, Eq, PartialEq)]
enum FragmentKind {
    Integer,
    Boolean,
}

fn fragment_result_kind(op: &PlanOp, operands: &[FragmentKind]) -> Option<FragmentKind> {
    match (op, operands) {
        (PlanOp::Field { .. } | PlanOp::Const { .. }, []) => Some(FragmentKind::Integer),
        (PlanOp::Bool { .. }, []) => Some(FragmentKind::Boolean),
        (PlanOp::Abs, [FragmentKind::Integer])
        | (
            PlanOp::Add | PlanOp::Sub | PlanOp::Mul | PlanOp::Min | PlanOp::Max,
            [FragmentKind::Integer, FragmentKind::Integer],
        ) => Some(FragmentKind::Integer),
        (PlanOp::Not, [FragmentKind::Boolean])
        | (PlanOp::And | PlanOp::Or, [FragmentKind::Boolean, FragmentKind::Boolean])
        | (
            PlanOp::Eq | PlanOp::Ne | PlanOp::Lt | PlanOp::Le | PlanOp::Gt | PlanOp::Ge,
            [FragmentKind::Integer, FragmentKind::Integer],
        ) => Some(FragmentKind::Boolean),
        (PlanOp::Select, [FragmentKind::Boolean, left, right]) if left == right => Some(*left),
        _ => None,
    }
}

fn subexpression_spans(program: &[PlanOp]) -> Vec<(usize, usize)> {
    let mut stack = Vec::<(usize, usize, FragmentKind)>::new();
    let mut spans = Vec::new();
    for (end, op) in program.iter().enumerate() {
        let arity = plan_op_arity(op);
        if stack.len() < arity {
            return Vec::new();
        }
        let start = if arity == 0 {
            end
        } else {
            stack[stack.len() - arity].0
        };
        let mut operands = [FragmentKind::Integer; 3];
        for (target, entry) in operands.iter_mut().zip(&stack[stack.len() - arity..]) {
            *target = entry.2;
        }
        stack.truncate(stack.len() - arity);
        let Some(kind) = fragment_result_kind(op, &operands[..arity]) else {
            return Vec::new();
        };
        stack.push((start, end, kind));
        if kind == FragmentKind::Boolean && end + 1 - start < program.len() {
            spans.push((start, end));
        }
    }
    spans.sort_unstable_by(|left, right| {
        (right.1 + 1 - right.0)
            .cmp(&(left.1 + 1 - left.0))
            .then_with(|| left.0.cmp(&right.0))
            .then_with(|| left.1.cmp(&right.1))
    });
    spans
}

fn semantic_plan_hash(plan: &PlanSpec) -> Result<String, ControlError> {
    let semantic_bytes = serde_json::to_vec(&json!({
        "role": plan.role,
        "output": plan.output,
        "scope": &plan.scope,
        "program": &plan.program,
    }))?;
    Ok(blake3::hash(&semantic_bytes).to_hex().to_string())
}

fn extract_hindsight_fragments(
    parent: &ExpansionParent,
    batch: &FeatureBatch,
    seen: &mut BTreeSet<String>,
) -> Result<HindsightExtraction, ControlError> {
    let mut fragments = Vec::new();
    let mut probes = 0;
    let mut total_rows_evaluated = 0_u64;
    let mut false_positive_rejections = 0;
    for (start, end) in subexpression_spans(&parent.plan.program) {
        if probes == MAX_HINDSIGHT_PROBES_PER_PARENT
            || fragments.len() == MAX_HINDSIGHT_FRAGMENTS_PER_PARENT
        {
            break;
        }
        let plan = PlanSpec {
            schema: parent.plan.schema.clone(),
            name: format!(
                "hindsight-{}-{start}-{end}",
                parent.hash.get(..12).unwrap_or(&parent.hash)
            ),
            role: parent.plan.role,
            output: parent.plan.output,
            scope: parent.plan.scope.clone(),
            program: parent.plan.program[start..=end].to_vec(),
        };
        let semantic_hash = semantic_plan_hash(&plan)?;
        if seen.len() == MAX_HINDSIGHT_SEMANTICS {
            break;
        }
        if !seen.insert(semantic_hash.clone()) {
            continue;
        }
        probes += 1;
        let Ok(compiled) = CompiledPlan::compile(&plan, &batch.fields) else {
            continue;
        };
        let mut weighted_true_positive = 0_u64;
        let mut rows_evaluated = 0_u64;
        let mut coverage = vec![0_u64; batch.rows().div_ceil(64)];
        let mut rejected = false;
        for row in 0..batch.rows() {
            rows_evaluated = rows_evaluated
                .checked_add(1)
                .ok_or_else(|| ControlError::Invalid("hindsight row counter overflow".into()))?;
            total_rows_evaluated = total_rows_evaluated.checked_add(1).ok_or_else(|| {
                ControlError::Invalid("hindsight total row counter overflow".into())
            })?;
            let observed = compiled.evaluate_value_untraced(batch.row(row))? != 0;
            if observed && !batch.expected(row) {
                rejected = true;
                false_positive_rejections += 1;
                break;
            }
            if observed {
                coverage[row / 64] |= 1_u64 << (row % 64);
                weighted_true_positive = weighted_true_positive
                    .checked_add(batch.weights[row])
                    .ok_or_else(|| ControlError::Invalid("hindsight coverage overflow".into()))?;
            }
        }
        if rejected || weighted_true_positive == 0 {
            continue;
        }
        fragments.push(HindsightFragment {
            semantic_hash,
            source_hash: Some(parent.hash.clone()),
            compiled_hash: compiled.hash,
            weighted_true_positive,
            rows_evaluated,
            coverage: PositiveCoverage::from_dense(coverage),
            plan,
        });
    }
    Ok(HindsightExtraction {
        fragments,
        probes,
        rows_evaluated: total_rows_evaluated,
        false_positive_rejections,
    })
}

fn same_plan_scope(left: Option<&PlanScope>, right: Option<&PlanScope>) -> bool {
    match (left, right) {
        (None, None) => true,
        (Some(left), Some(right)) => left.field == right.field && left.mask == right.mask,
        (None, Some(_)) | (Some(_), None) => false,
    }
}

fn compose_hindsight_fragments(
    ledger: &[HindsightFragment],
    batch: &FeatureBatch,
    seen: &mut BTreeSet<String>,
    probe_limit: usize,
) -> Result<CompositionExtraction, ControlError> {
    let mut compositions = Vec::new();
    let mut probes = 0;
    let mut rows_evaluated = 0_u64;
    let mut premise_pairs = Vec::new();
    for left_index in 0..ledger.len() {
        for right_index in left_index + 1..ledger.len() {
            let left = &ledger[left_index];
            let right = &ledger[right_index];
            if left.plan.role != right.plan.role
                || left.plan.output != right.plan.output
                || !same_plan_scope(left.plan.scope.as_ref(), right.plan.scope.as_ref())
            {
                continue;
            }
            let Some(semantic_ops) = left
                .plan
                .program
                .len()
                .checked_add(right.plan.program.len())
                .and_then(|length| length.checked_add(1))
            else {
                continue;
            };
            let mut weighted_union = left.weighted_true_positive;
            right.coverage.try_for_each_row(|row| {
                if !left.coverage.contains(row) {
                    let weight = batch.weights.get(row).copied().ok_or_else(|| {
                        ControlError::Invalid("hindsight premise row is out of range".into())
                    })?;
                    weighted_union = weighted_union.checked_add(weight).ok_or_else(|| {
                        ControlError::Invalid("hindsight premise coverage overflow".into())
                    })?;
                }
                Ok(())
            })?;
            let marginal_gain = weighted_union.saturating_sub(
                left.weighted_true_positive
                    .max(right.weighted_true_positive),
            );
            if marginal_gain != 0 {
                premise_pairs.push(PremisePair {
                    left: left_index,
                    right: right_index,
                    weighted_union,
                    marginal_gain,
                    semantic_ops,
                });
            }
        }
    }
    premise_pairs.sort_unstable_by(premise_pair_cmp);

    for premise in premise_pairs {
        if probes == probe_limit
            || compositions.len() == MAX_HINDSIGHT_COMPOSITIONS_PER_GENERATION
            || seen.len() == MAX_HINDSIGHT_SEMANTICS
        {
            break;
        }
        let left = &ledger[premise.left];
        let right = &ledger[premise.right];
        let mut program = Vec::with_capacity(premise.semantic_ops);
        program.extend(left.plan.program.iter().cloned());
        program.extend(right.plan.program.iter().cloned());
        program.push(PlanOp::Or);
        let plan = PlanSpec {
            schema: left.plan.schema.clone(),
            name: format!(
                "hindsight-or-{}-{}",
                left.semantic_hash.get(..8).unwrap_or(&left.semantic_hash),
                right.semantic_hash.get(..8).unwrap_or(&right.semantic_hash)
            ),
            role: left.plan.role,
            output: left.plan.output,
            scope: left.plan.scope.clone(),
            program,
        };
        let semantic_hash = semantic_plan_hash(&plan)?;
        if !seen.insert(semantic_hash.clone()) {
            continue;
        }
        probes += 1;
        let coverage = left
            .coverage
            .union_dense(&right.coverage, batch.rows().div_ceil(64))?;
        let weighted_true_positive = premise.weighted_union;
        let Ok(compiled) = CompiledPlan::compile(&plan, &batch.fields) else {
            continue;
        };
        let mut replay_coverage = vec![0_u64; coverage.len()];
        let mut replay_weight = 0_u64;
        for row in 0..batch.rows() {
            rows_evaluated = rows_evaluated.checked_add(1).ok_or_else(|| {
                ControlError::Invalid("hindsight composition row overflow".into())
            })?;
            let observed = compiled.evaluate_value_untraced(batch.row(row))? != 0;
            if observed && !batch.expected(row) {
                return Err(ControlError::Invalid(
                    "zero-false-positive composition failed exact replay".into(),
                ));
            }
            if observed {
                replay_coverage[row / 64] |= 1_u64 << (row % 64);
                replay_weight = replay_weight
                    .checked_add(batch.weights[row])
                    .ok_or_else(|| {
                        ControlError::Invalid("hindsight composition coverage overflow".into())
                    })?;
            }
        }
        if replay_coverage != coverage || replay_weight != weighted_true_positive {
            return Err(ControlError::Invalid(
                "hindsight composition bitmap replay mismatch".into(),
            ));
        }
        compositions.push(HindsightComposition {
            fragment: HindsightFragment {
                semantic_hash,
                source_hash: None,
                compiled_hash: compiled.hash,
                weighted_true_positive,
                rows_evaluated: batch.rows() as u64,
                coverage: PositiveCoverage::from_dense(coverage),
                plan,
            },
            left_semantic_hash: left.semantic_hash.clone(),
            right_semantic_hash: right.semantic_hash.clone(),
        });
    }
    Ok(CompositionExtraction {
        compositions,
        probes,
        rows_evaluated,
    })
}

fn replay_hindsight_fragment(
    imported: &EvolutionReplayFragment,
    batch: &FeatureBatch,
) -> Result<ReplayExtraction, ControlError> {
    if semantic_plan_hash(&imported.plan)? != imported.semantic_hash {
        return Err(ControlError::Invalid(
            "replayed hindsight semantic hash mismatch".into(),
        ));
    }
    let compiled = CompiledPlan::compile(&imported.plan, &batch.fields)?;
    if compiled.hash != imported.compiled_hash {
        return Err(ControlError::Invalid(
            "replayed hindsight compiled hash mismatch".into(),
        ));
    }
    let mut coverage = vec![0_u64; batch.rows().div_ceil(64)];
    let mut weighted_true_positive = 0_u64;
    let mut rows_evaluated = 0_u64;
    for row in 0..batch.rows() {
        rows_evaluated = rows_evaluated
            .checked_add(1)
            .ok_or_else(|| ControlError::Invalid("hindsight replay row overflow".into()))?;
        let observed = compiled.evaluate_value_untraced(batch.row(row))? != 0;
        if observed && !batch.expected(row) {
            return Ok(ReplayExtraction {
                fragment: None,
                rows_evaluated,
            });
        }
        if observed {
            coverage[row / 64] |= 1_u64 << (row % 64);
            weighted_true_positive = weighted_true_positive
                .checked_add(batch.weights[row])
                .ok_or_else(|| {
                    ControlError::Invalid("hindsight replay coverage overflow".into())
                })?;
        }
    }
    let fragment = (weighted_true_positive != 0).then(|| HindsightFragment {
        semantic_hash: imported.semantic_hash.clone(),
        source_hash: None,
        compiled_hash: imported.compiled_hash.clone(),
        weighted_true_positive,
        rows_evaluated,
        coverage: PositiveCoverage::from_dense(coverage),
        plan: imported.plan.clone(),
    });
    Ok(ReplayExtraction {
        fragment,
        rows_evaluated,
    })
}

fn imported_candidate_cmp(
    left: &ImportedCandidate,
    right: &ImportedCandidate,
) -> std::cmp::Ordering {
    let left_error = u128::from(left.incorrect) * u128::from(right.weighted_rows);
    let right_error = u128::from(right.incorrect) * u128::from(left.weighted_rows);
    left_error
        .cmp(&right_error)
        .then_with(|| {
            (u128::from(left.false_positive) * u128::from(right.weighted_rows))
                .cmp(&(u128::from(right.false_positive) * u128::from(left.weighted_rows)))
        })
        .then_with(|| left.complexity.cmp(&right.complexity))
        .then_with(|| left.seed.source_hash.cmp(&right.seed.source_hash))
}

pub(super) fn load_evolution_archive(
    path: &Path,
    expected: &EvolutionIdentity,
    seed_limit: usize,
    fragment_limit: usize,
) -> Result<EvolutionReplayArchive, ControlError> {
    if seed_limit == 0 && fragment_limit == 0 {
        return Ok(EvolutionReplayArchive {
            seeds: Vec::new(),
            fragments: Vec::new(),
        });
    }
    let file = File::open(path)?;
    if file.metadata()?.len() > MAX_EVOLUTION_IMPORT_BYTES {
        return Err(ControlError::Invalid(
            "evolution evidence exceeds the import byte bound".into(),
        ));
    }
    let mut lines = BufReader::new(file).lines();
    let header_line = lines
        .next()
        .ok_or_else(|| ControlError::Invalid("empty evolution evidence".into()))??;
    if header_line.len() > MAX_EVOLUTION_RECORD_BYTES {
        return Err(ControlError::Invalid(
            "evolution evidence header exceeds the record bound".into(),
        ));
    }
    let header: EvolutionEvidenceHeader = serde_json::from_str(&header_line)?;
    if header.schema != EVOLUTION_EVIDENCE_SCHEMA
        || header.presentation_hash.len() != 64
        || !header
            .presentation_hash
            .bytes()
            .all(|byte| byte.is_ascii_hexdigit())
        || header.problem != expected.problem
        || header.fields != expected.fields
        || header.generator != expected.generator
        || (header.generator.is_none() && header.presentation_hash != expected.presentation_hash)
    {
        return Err(ControlError::Invalid(
            "evolution evidence is incompatible with this feature batch".into(),
        ));
    }

    let mut selected = Vec::<ImportedCandidate>::with_capacity(seed_limit);
    let mut fragments = Vec::with_capacity(fragment_limit);
    let mut fragment_semantics = BTreeSet::new();
    for line in lines {
        let line = line?;
        if line.len() > MAX_EVOLUTION_RECORD_BYTES {
            return Err(ControlError::Invalid(
                "evolution evidence record exceeds the record bound".into(),
            ));
        }
        let value: Value = serde_json::from_str(&line)?;
        if matches!(
            value.get("type").and_then(Value::as_str),
            Some("hindsight-fragment" | "hindsight-composition" | "hindsight-replay")
        ) {
            let retain_fragment = fragments.len() < fragment_limit;
            let plan: PlanSpec = serde_json::from_value(
                value
                    .get("plan")
                    .cloned()
                    .ok_or_else(|| ControlError::Invalid("hindsight record omits plan".into()))?,
            )?;
            if plan.output != super::PlanOutput::Predicate {
                return Err(ControlError::Invalid(
                    "hindsight record contains a non-predicate plan".into(),
                ));
            }
            let semantic_hash = value
                .get("semantic_hash")
                .and_then(Value::as_str)
                .filter(|hash| {
                    hash.len() == 64 && hash.bytes().all(|byte| byte.is_ascii_hexdigit())
                })
                .ok_or_else(|| {
                    ControlError::Invalid("hindsight record has an invalid semantic hash".into())
                })?;
            if semantic_plan_hash(&plan)? != semantic_hash {
                return Err(ControlError::Invalid(
                    "hindsight semantic hash does not match its plan".into(),
                ));
            }
            let compiled_hash = value
                .get("hash")
                .and_then(Value::as_str)
                .filter(|hash| {
                    hash.len() == 64 && hash.bytes().all(|byte| byte.is_ascii_hexdigit())
                })
                .ok_or_else(|| {
                    ControlError::Invalid("hindsight record has an invalid compiled hash".into())
                })?;
            let compiled = CompiledPlan::compile(&plan, &expected.fields)?;
            if compiled.hash != compiled_hash {
                return Err(ControlError::Invalid(
                    "hindsight compiled hash does not match its plan".into(),
                ));
            }
            if retain_fragment && fragment_semantics.insert(semantic_hash.to_owned()) {
                fragments.push(EvolutionReplayFragment {
                    plan,
                    semantic_hash: semantic_hash.to_owned(),
                    compiled_hash: compiled_hash.to_owned(),
                    source_evidence: path.to_string_lossy().into_owned(),
                });
            }
            continue;
        }
        let Some(evaluation) = value.get("evaluation").and_then(Value::as_object) else {
            continue;
        };
        let weighted_rows = required_u64(evaluation, "weighted_rows")?;
        let weighted_correct = required_u64(evaluation, "weighted_correct")?;
        let false_positive = required_u64(evaluation, "weighted_false_positive")?;
        if weighted_rows == 0 || weighted_correct > weighted_rows || false_positive > weighted_rows
        {
            return Err(ControlError::Invalid(
                "evolution evidence contains an invalid score".into(),
            ));
        }
        let plan: PlanSpec = serde_json::from_value(
            value
                .get("plan")
                .cloned()
                .ok_or_else(|| ControlError::Invalid("evolution record omits plan".into()))?,
        )?;
        let parent_hash = value
            .get("hash")
            .and_then(Value::as_str)
            .filter(|hash| hash.len() == 64 && hash.bytes().all(|byte| byte.is_ascii_hexdigit()))
            .map(str::to_owned)
            .ok_or_else(|| ControlError::Invalid("evolution record has an invalid hash".into()))?;
        let compiled = CompiledPlan::compile(&plan, &expected.fields)?;
        if compiled.hash != parent_hash {
            return Err(ControlError::Invalid(
                "evolution record hash does not match its plan".into(),
            ));
        }
        selected.push(ImportedCandidate {
            incorrect: weighted_rows - weighted_correct,
            weighted_rows,
            false_positive,
            complexity: plan.program.len(),
            seed: EvolutionSeed {
                plan,
                parent_hash: None,
                source_hash: Some(parent_hash),
                source_evidence: Some(path.to_string_lossy().into_owned()),
                operator: "replay",
            },
        });
        selected.sort_unstable_by(imported_candidate_cmp);
        selected.truncate(seed_limit);
    }
    Ok(EvolutionReplayArchive {
        seeds: selected
            .into_iter()
            .map(|candidate| candidate.seed)
            .collect(),
        fragments,
    })
}

fn required_u64(object: &serde_json::Map<String, Value>, field: &str) -> Result<u64, ControlError> {
    object
        .get(field)
        .and_then(Value::as_u64)
        .ok_or_else(|| ControlError::Invalid(format!("evolution score omits {field}")))
}

fn checked_counter_add(
    counter: &mut u64,
    delta: u64,
    name: &'static str,
) -> Result<(), ControlError> {
    *counter = counter
        .checked_add(delta)
        .ok_or_else(|| ControlError::Invalid(format!("evolution {name} counter overflow")))?;
    Ok(())
}

pub(super) fn run_evolution(
    batch: Arc<FeatureBatch>,
    identity: EvolutionIdentity,
    current: Vec<EvolutionSeed>,
    replay_fragments: Vec<EvolutionReplayFragment>,
    output: File,
    bounds: EvolutionBounds,
    progress: Arc<EvolutionProgress>,
) -> Result<Value, ControlError> {
    // SAFETY: setpriority has no pointer arguments; `who = 0` selects only the
    // calling Linux task. Failure is reported in the job summary.
    let low_priority = unsafe { libc::setpriority(libc::PRIO_PROCESS, 0, 10) } == 0;
    let scope_profiles = scope_profiles(&batch)?;
    let field_index = batch
        .fields
        .iter()
        .enumerate()
        .map(|(index, name)| (name.as_str(), index as u16))
        .collect::<BTreeMap<_, _>>();
    let mutation_context = MutationContext {
        fields: &batch.fields,
        scope_profiles: &scope_profiles,
        field_index: &field_index,
    };
    let mut writer = BufWriter::new(output);
    let mut header = serde_json::to_vec(&EvolutionEvidenceHeader::from(&identity))?;
    header.push(b'\n');
    if header.len() as u64 > bounds.byte_limit {
        return Err(ControlError::Invalid(
            "evolution evidence limit cannot hold its identity header".into(),
        ));
    }
    let header_bytes = header.len() as u64;
    let candidate_byte_limit = bounds
        .byte_limit
        .checked_sub(MAX_EVOLUTION_FOOTER_BYTES)
        .filter(|limit| *limit >= header_bytes)
        .ok_or_else(|| {
            ControlError::Invalid(
                "evolution evidence limit cannot hold its header and summary reserve".into(),
            )
        })?;
    writer.write_all(&header)?;
    let mut bytes = header_bytes;
    let mut structural = BTreeSet::new();
    let mut outcome_classes = BTreeMap::new();
    let mut tested = 0_usize;
    let mut perfect = 0_usize;
    let mut structural_rejections = 0_usize;
    let mut outcome_expansion_rejections = 0_usize;
    let mut cascade_rejections = 0_usize;
    let mut rows_evaluated = 0_u64;
    let mut selection_exploration_slots = 0_u64;
    let mut selection_guided_slots = 0_u64;
    let mut selection_balanced_slots = 0_u64;
    let mut semantic_niche_slots = 0_u64;
    let mut global_elite_slots = 0_u64;
    let mut retained_elite_slots = 0_u64;
    let mut hindsight_probes = 0_u64;
    let mut hindsight_rows_evaluated = 0_u64;
    let mut hindsight_false_positive_rejections = 0_u64;
    let mut hindsight_byte_rejections = 0_u64;
    let mut hindsight_composition_probes = 0_u64;
    let mut hindsight_composition_rows = 0_u64;
    let mut hindsight_compositions = 0_u64;
    let mut hindsight_replayed = 0_u64;
    let mut hindsight_replay_rejections = 0_u64;
    let mut hindsight_replay_rows = 0_u64;
    let mut prior_parent_scores = BTreeMap::<String, CandidateScore>::new();
    let mut retained_elites = Vec::<ExpansionParent>::new();
    let mut hindsight_semantics = BTreeSet::<String>::new();
    let mut hindsight_seen = BTreeSet::<String>::new();
    let mut hindsight_ledger = Vec::<HindsightFragment>::new();
    for imported in replay_fragments {
        if hindsight_ledger.len() == MAX_HINDSIGHT_FRAGMENTS
            || hindsight_seen.len() == MAX_HINDSIGHT_SEMANTICS
        {
            break;
        }
        if !hindsight_seen.insert(imported.semantic_hash.clone()) {
            continue;
        }
        let replay = replay_hindsight_fragment(&imported, &batch)?;
        checked_counter_add(
            &mut hindsight_replay_rows,
            replay.rows_evaluated,
            "hindsight replay row",
        )?;
        let Some(fragment) = replay.fragment else {
            checked_counter_add(
                &mut hindsight_replay_rejections,
                1,
                "hindsight replay rejection",
            )?;
            continue;
        };
        let record = json!({
            "type": "hindsight-replay",
            "semantic_hash": &fragment.semantic_hash,
            "source_evidence": &imported.source_evidence,
            "hash": &fragment.compiled_hash,
            "weighted_true_positive": fragment.weighted_true_positive,
            "rows_evaluated": fragment.rows_evaluated,
            "trusted": false,
            "replay_obligation": "compatible-feature-batch",
            "plan": &fragment.plan,
        });
        let mut encoded = serde_json::to_vec(&record)?;
        encoded.push(b'\n');
        if encoded.len() > MAX_EVOLUTION_RECORD_BYTES
            || bytes.saturating_add(encoded.len() as u64) > candidate_byte_limit
        {
            checked_counter_add(
                &mut hindsight_byte_rejections,
                1,
                "hindsight replay byte rejection",
            )?;
            continue;
        }
        writer.write_all(&encoded)?;
        bytes += encoded.len() as u64;
        hindsight_semantics.insert(fragment.semantic_hash.clone());
        hindsight_ledger.push(fragment);
        checked_counter_add(&mut hindsight_replayed, 1, "hindsight replay")?;
    }
    let mut operator_scorecards = BTreeMap::<&'static str, OperatorScorecard>::new();
    let mut best: Option<(u64, u64, usize, PlanSpec)> = None;
    let mut truncated = false;
    let mut current = current
        .into_iter()
        .map(|seed| PendingCandidate {
            plan: seed.plan,
            parent_hash: seed.parent_hash,
            source_hash: seed.source_hash,
            source_evidence: seed.source_evidence,
            operator: seed.operator,
        })
        .collect::<Vec<_>>();

    'generations: for generation in 0..bounds.generations {
        progress
            .generation
            .store(generation as u64, Ordering::Relaxed);
        let mut ranked = Vec::new();
        let mut survivor_keys = Vec::<EvolutionRankKey>::new();
        for pending in current.drain(..) {
            if tested == bounds.max_candidates || progress.cancelled.load(Ordering::Acquire) {
                break 'generations;
            }
            let mut plan = pending.plan;
            let structural_key = format!(
                "{:?}|{:?}|{:?}|{:?}",
                plan.role, plan.output, plan.scope, plan.program
            );
            if !structural.insert(structural_key) {
                structural_rejections += 1;
                continue;
            }
            plan.name = format!("evolve-g{generation}-c{tested}");
            let compiled = CompiledPlan::compile(&plan, &batch.fields)?;
            let parent_score = pending
                .parent_hash
                .as_ref()
                .map(|hash| {
                    prior_parent_scores.get(hash).copied().ok_or_else(|| {
                        ControlError::Invalid(
                            "evolution child does not resolve to an expanded parent".into(),
                        )
                    })
                })
                .transpose()?;
            let can_enter = |false_positive: u64, maximum_correct: u64| {
                can_enter_beam(
                    &survivor_keys,
                    bounds.beam,
                    maximum_correct,
                    false_positive,
                    plan.program.len(),
                )
            };
            let (evaluation, examined) =
                evaluate_plan_cascaded(&batch, &compiled, Some(&can_enter))?;
            rows_evaluated = rows_evaluated.saturating_add(examined as u64);
            let operator_scorecard = operator_scorecards.entry(pending.operator).or_default();
            checked_counter_add(&mut operator_scorecard.trials, 1, "operator trial")?;
            let examined = u64::try_from(examined)
                .map_err(|_| ControlError::Invalid("row count does not fit u64".into()))?;
            checked_counter_add(
                &mut operator_scorecard.rows_evaluated,
                examined,
                "operator row",
            )?;
            let semantic_op_rows = examined
                .checked_mul(compiled.op_count() as u64)
                .ok_or_else(|| ControlError::Invalid("semantic operation count overflow".into()))?;
            checked_counter_add(
                &mut operator_scorecard.semantic_op_rows,
                semantic_op_rows,
                "operator semantic operation",
            )?;
            let Some(evaluation) = evaluation else {
                checked_counter_add(
                    &mut operator_scorecard.cascade_rejected,
                    1,
                    "operator cascade rejection",
                )?;
                let record = json!({
                    "generation": generation,
                    "parent_hash": pending.parent_hash,
                    "source_hash": pending.source_hash,
                    "source_evidence": pending.source_evidence,
                    "operator": pending.operator,
                    "plan": &plan,
                    "hash": &compiled.hash,
                    "evaluation": null,
                    "impact": null,
                    "cost": {
                        "rows_evaluated": examined,
                        "semantic_ops": compiled.op_count(),
                        "semantic_op_rows": semantic_op_rows,
                    },
                    "cascade": {"rejected": true, "rows_evaluated": examined},
                });
                let mut encoded = serde_json::to_vec(&record)?;
                encoded.push(b'\n');
                if bytes.saturating_add(encoded.len() as u64) > candidate_byte_limit {
                    truncated = true;
                    break 'generations;
                }
                writer.write_all(&encoded)?;
                bytes += encoded.len() as u64;
                tested += 1;
                cascade_rejections += 1;
                progress.tested.store(tested as u64, Ordering::Relaxed);
                continue;
            };
            let equivalent_to = outcome_classes.get(&evaluation.outcome_hash).cloned();
            let score = CandidateScore {
                correct: evaluation.weighted_correct,
                false_positive: evaluation.weighted_false_positive,
                complexity: plan.program.len(),
            };
            let impact = parent_score.map(|parent| candidate_impact(score, parent));
            checked_counter_add(&mut operator_scorecard.completed, 1, "operator completion")?;
            if let Some(impact) = &impact {
                checked_counter_add(
                    &mut operator_scorecard.compared_to_parent,
                    1,
                    "operator parent comparison",
                )?;
                if impact.improved {
                    checked_counter_add(
                        &mut operator_scorecard.improved,
                        1,
                        "operator improvement",
                    )?;
                    operator_scorecard.best_correct_gain = operator_scorecard
                        .best_correct_gain
                        .max(impact.correct_gain);
                    operator_scorecard.best_false_positive_reduction = operator_scorecard
                        .best_false_positive_reduction
                        .max(impact.false_positive_reduction);
                    if operator_scorecard
                        .best_correct_gain_per_cost_denominator
                        .is_none_or(|cost| {
                            diminishing_ratio_cmp(
                                impact.correct_gain,
                                semantic_op_rows,
                                1,
                                operator_scorecard.best_correct_gain_per_cost_numerator,
                                cost,
                                1,
                            ) == std::cmp::Ordering::Greater
                        })
                    {
                        operator_scorecard.best_correct_gain_per_cost_numerator =
                            impact.correct_gain;
                        operator_scorecard.best_correct_gain_per_cost_denominator =
                            Some(semantic_op_rows);
                    }
                    if operator_scorecard
                        .best_false_positive_reduction_per_cost_denominator
                        .is_none_or(|cost| {
                            diminishing_ratio_cmp(
                                impact.false_positive_reduction,
                                semantic_op_rows,
                                1,
                                operator_scorecard.best_false_positive_reduction_per_cost_numerator,
                                cost,
                                1,
                            ) == std::cmp::Ordering::Greater
                        })
                    {
                        operator_scorecard.best_false_positive_reduction_per_cost_numerator =
                            impact.false_positive_reduction;
                        operator_scorecard.best_false_positive_reduction_per_cost_denominator =
                            Some(semantic_op_rows);
                    }
                    operator_scorecard.minimum_improving_semantic_op_rows = Some(
                        operator_scorecard
                            .minimum_improving_semantic_op_rows
                            .map_or(semantic_op_rows, |minimum| minimum.min(semantic_op_rows)),
                    );
                }
            }
            if evaluation.weighted_correct == evaluation.weighted_rows {
                checked_counter_add(&mut operator_scorecard.perfect, 1, "operator perfect")?;
            }
            let failure_shape =
                failure_shape(&batch, &plan, evaluation.first_mismatch, &field_index);
            let niche = SemanticNiche::new(
                pending.operator,
                evaluation.weighted_false_positive,
                evaluation.weighted_false_negative,
                semantic_op_rows,
            );
            let failure_record = failure_shape_record(&batch, &failure_shape, &evaluation);
            outcome_classes
                .entry(evaluation.outcome_hash.clone())
                .or_insert_with(|| plan.name.clone());
            let record = json!({
                "generation": generation,
                "parent_hash": pending.parent_hash,
                "source_hash": pending.source_hash,
                "source_evidence": pending.source_evidence,
                "operator": pending.operator,
                "semantic_niche": niche,
                "plan": &plan,
                "hash": &compiled.hash,
                "equivalent_to": equivalent_to,
                "evaluation": &evaluation,
                "impact": impact,
                "cost": {
                    "rows_evaluated": examined,
                    "semantic_ops": compiled.op_count(),
                    "semantic_op_rows": semantic_op_rows,
                },
                "failure_shape": failure_record,
            });
            let mut encoded = serde_json::to_vec(&record)?;
            encoded.push(b'\n');
            if bytes.saturating_add(encoded.len() as u64) > candidate_byte_limit {
                truncated = true;
                break 'generations;
            }
            writer.write_all(&encoded)?;
            bytes += encoded.len() as u64;
            tested += 1;
            if evaluation.weighted_correct == evaluation.weighted_rows {
                perfect += 1;
            }
            let candidate_key = (
                evaluation.weighted_correct,
                evaluation.weighted_false_positive,
                plan.program.len(),
            );
            if best.as_ref().is_none_or(|best| {
                candidate_key.0 > best.0
                    || (candidate_key.0 == best.0 && candidate_key.1 < best.1)
                    || (candidate_key.0 == best.0
                        && candidate_key.1 == best.1
                        && candidate_key.2 < best.2)
            }) {
                best = Some((
                    candidate_key.0,
                    candidate_key.1,
                    candidate_key.2,
                    plan.clone(),
                ));
            }
            survivor_keys.push(evolution_rank_key(
                evaluation.weighted_correct,
                evaluation.weighted_false_positive,
                plan.program.len(),
            ));
            survivor_keys.sort_unstable();
            survivor_keys.truncate(bounds.beam);
            ranked.push(RankedCandidate {
                score,
                outcome_hash: evaluation.outcome_hash,
                hash: compiled.hash,
                plan,
                first_mismatch: evaluation.first_mismatch,
                operator: pending.operator,
                niche,
                mutation_cursor: 0,
                retained: false,
            });
            progress.tested.store(tested as u64, Ordering::Relaxed);
            progress.perfect.store(perfect as u64, Ordering::Relaxed);
        }
        if tested == bounds.max_candidates || generation + 1 == bounds.generations {
            break;
        }
        let expansion_capacity = bounds.max_candidates.saturating_sub(tested);
        let selection =
            select_semantic_elites(ranked, &retained_elites, bounds.beam, expansion_capacity);
        checked_counter_add(
            &mut semantic_niche_slots,
            selection.niche_slots as u64,
            "semantic niche slot",
        )?;
        checked_counter_add(
            &mut global_elite_slots,
            selection.global_slots as u64,
            "global elite slot",
        )?;
        checked_counter_add(
            &mut retained_elite_slots,
            selection.retained_slots as u64,
            "retained elite slot",
        )?;
        outcome_expansion_rejections = outcome_expansion_rejections
            .checked_add(selection.outcome_rejections)
            .ok_or_else(|| ControlError::Invalid("outcome rejection counter overflow".into()))?;
        let parents = selection.parents;
        if parents.is_empty() {
            break;
        }
        for parent in &parents {
            if hindsight_semantics.len() == MAX_HINDSIGHT_FRAGMENTS
                || hindsight_seen.len() == MAX_HINDSIGHT_SEMANTICS
            {
                break;
            }
            let extraction = extract_hindsight_fragments(parent, &batch, &mut hindsight_seen)?;
            checked_counter_add(
                &mut hindsight_probes,
                extraction.probes as u64,
                "hindsight probe",
            )?;
            checked_counter_add(
                &mut hindsight_rows_evaluated,
                extraction.rows_evaluated,
                "hindsight row",
            )?;
            checked_counter_add(
                &mut hindsight_false_positive_rejections,
                extraction.false_positive_rejections as u64,
                "hindsight false-positive rejection",
            )?;
            for fragment in extraction.fragments {
                if hindsight_semantics.len() == MAX_HINDSIGHT_FRAGMENTS {
                    break;
                }
                let record = json!({
                    "type": "hindsight-fragment",
                    "semantic_hash": &fragment.semantic_hash,
                    "source_hash": &fragment.source_hash,
                    "hash": &fragment.compiled_hash,
                    "weighted_true_positive": fragment.weighted_true_positive,
                    "rows_evaluated": fragment.rows_evaluated,
                    "trusted": false,
                    "replay_obligation": "compatible-feature-batch",
                    "plan": &fragment.plan,
                });
                let mut encoded = serde_json::to_vec(&record)?;
                encoded.push(b'\n');
                if encoded.len() > MAX_EVOLUTION_RECORD_BYTES
                    || bytes.saturating_add(encoded.len() as u64) > candidate_byte_limit
                {
                    checked_counter_add(
                        &mut hindsight_byte_rejections,
                        1,
                        "hindsight evidence byte rejection",
                    )?;
                    continue;
                }
                writer.write_all(&encoded)?;
                bytes += encoded.len() as u64;
                hindsight_semantics.insert(fragment.semantic_hash.clone());
                hindsight_ledger.push(fragment);
            }
        }
        let composition_probe_limit = MAX_HINDSIGHT_COMPOSITION_PROBES
            .saturating_sub(hindsight_composition_probes as usize)
            .min(MAX_HINDSIGHT_COMPOSITION_PROBES_PER_GENERATION);
        if hindsight_ledger.len() >= 2
            && hindsight_semantics.len() < MAX_HINDSIGHT_FRAGMENTS
            && hindsight_seen.len() < MAX_HINDSIGHT_SEMANTICS
            && composition_probe_limit != 0
        {
            let extraction = compose_hindsight_fragments(
                &hindsight_ledger,
                &batch,
                &mut hindsight_seen,
                composition_probe_limit,
            )?;
            checked_counter_add(
                &mut hindsight_composition_probes,
                extraction.probes as u64,
                "hindsight composition probe",
            )?;
            checked_counter_add(
                &mut hindsight_composition_rows,
                extraction.rows_evaluated,
                "hindsight composition row",
            )?;
            for composition in extraction.compositions {
                if hindsight_semantics.len() == MAX_HINDSIGHT_FRAGMENTS {
                    break;
                }
                let fragment = &composition.fragment;
                let record = json!({
                    "type": "hindsight-composition",
                    "semantic_hash": &fragment.semantic_hash,
                    "hash": &fragment.compiled_hash,
                    "weighted_true_positive": fragment.weighted_true_positive,
                    "rows_evaluated": fragment.rows_evaluated,
                    "trusted": false,
                    "replay_obligation": "compatible-feature-batch",
                    "derivation": {
                        "rule": "or-zero-false-positive",
                        "parents": [
                            &composition.left_semantic_hash,
                            &composition.right_semantic_hash,
                        ],
                    },
                    "plan": &fragment.plan,
                });
                let mut encoded = serde_json::to_vec(&record)?;
                encoded.push(b'\n');
                if encoded.len() > MAX_EVOLUTION_RECORD_BYTES
                    || bytes.saturating_add(encoded.len() as u64) > candidate_byte_limit
                {
                    checked_counter_add(
                        &mut hindsight_byte_rejections,
                        1,
                        "hindsight composition byte rejection",
                    )?;
                    continue;
                }
                writer.write_all(&encoded)?;
                bytes += encoded.len() as u64;
                hindsight_semantics.insert(fragment.semantic_hash.clone());
                hindsight_ledger.push(composition.fragment);
                checked_counter_add(&mut hindsight_compositions, 1, "hindsight composition")?;
            }
        }
        let guided_selection = selection_has_signal(&parents, &operator_scorecards);
        checked_counter_add(
            &mut selection_exploration_slots,
            parents.len() as u64,
            "selection exploration slot",
        )?;
        checked_counter_add(
            if guided_selection {
                &mut selection_guided_slots
            } else {
                &mut selection_balanced_slots
            },
            expansion_capacity.saturating_sub(parents.len()) as u64,
            "selection surplus slot",
        )?;
        let quotas = maximum_oriented_quotas(&parents, expansion_capacity, &operator_scorecards);
        let mut next_parent_scores = BTreeMap::new();
        let mut next_retained_elites = Vec::with_capacity(parents.len());
        let mut carry = 0_usize;
        for (mut parent, quota) in parents.into_iter().zip(quotas) {
            next_parent_scores.insert(parent.hash.clone(), parent.score);
            let quota = quota.saturating_add(carry);
            let before = current.len();
            let limit = before.saturating_add(quota).min(expansion_capacity);
            let failure_shape =
                failure_shape(&batch, &parent.plan, parent.first_mismatch, &field_index);
            let mutation = mutate_plan(
                &parent.plan,
                &parent.hash,
                &mutation_context,
                &failure_shape,
                &mut current,
                limit,
                parent.mutation_cursor,
            );
            parent.mutation_cursor = mutation.next_cursor;
            if !mutation.exhausted {
                next_retained_elites.push(parent);
            }
            carry = quota.saturating_sub(current.len().saturating_sub(before));
        }
        prior_parent_scores = next_parent_scores;
        retained_elites = next_retained_elites;
    }
    let candidate_bytes = bytes;
    let mut footer_summary = json!({
        "tested": tested,
        "perfect": perfect,
        "outcome_classes": outcome_classes.len(),
        "structural_rejections": structural_rejections,
        "outcome_expansion_rejections": outcome_expansion_rejections,
        "cascade_rejections": cascade_rejections,
        "rows_evaluated": rows_evaluated,
        "selection_exploration_slots": selection_exploration_slots,
        "selection_guided_slots": selection_guided_slots,
        "selection_balanced_slots": selection_balanced_slots,
        "semantic_niche_slots": semantic_niche_slots,
        "global_elite_slots": global_elite_slots,
        "retained_elite_slots": retained_elite_slots,
        "hindsight_fragments": hindsight_semantics.len(),
        "hindsight_semantics_examined": hindsight_seen.len(),
        "hindsight_probes": hindsight_probes,
        "hindsight_rows_evaluated": hindsight_rows_evaluated,
        "hindsight_false_positive_rejections": hindsight_false_positive_rejections,
        "hindsight_byte_rejections": hindsight_byte_rejections,
        "hindsight_composition_probes": hindsight_composition_probes,
        "hindsight_composition_rows": hindsight_composition_rows,
        "hindsight_compositions": hindsight_compositions,
        "hindsight_replayed": hindsight_replayed,
        "hindsight_replay_rejections": hindsight_replay_rejections,
        "hindsight_replay_rows": hindsight_replay_rows,
        "operator_scorecards": &operator_scorecards,
        "bytes": bytes,
        "truncated": truncated,
        "cancelled": progress.cancelled.load(Ordering::Acquire),
        "low_priority": low_priority,
    });
    let mut footer = Vec::new();
    let mut stable = false;
    for _ in 0..4 {
        footer = serde_json::to_vec(&json!({
            "type": "summary",
            "summary": &footer_summary,
        }))?;
        footer.push(b'\n');
        let total_bytes = candidate_bytes
            .checked_add(footer.len() as u64)
            .ok_or_else(|| ControlError::Invalid("evolution evidence byte overflow".into()))?;
        if footer_summary["bytes"].as_u64() == Some(total_bytes) {
            stable = true;
            break;
        }
        footer_summary["bytes"] = Value::from(total_bytes);
    }
    if !stable {
        return Err(ControlError::Invalid(
            "evolution summary byte count did not stabilize".into(),
        ));
    }
    if footer.len() as u64 > MAX_EVOLUTION_FOOTER_BYTES {
        return Err(ControlError::Invalid(
            "evolution summary exceeds its reserved evidence bound".into(),
        ));
    }
    writer.write_all(&footer)?;
    bytes = candidate_bytes + footer.len() as u64;
    writer.flush()?;
    progress.done.store(true, Ordering::Release);
    Ok(json!({
        "tested": tested,
        "perfect": perfect,
        "outcome_classes": outcome_classes.len(),
        "structural_rejections": structural_rejections,
        "outcome_expansion_rejections": outcome_expansion_rejections,
        "cascade_rejections": cascade_rejections,
        "rows_evaluated": rows_evaluated,
        "selection_exploration_slots": selection_exploration_slots,
        "selection_guided_slots": selection_guided_slots,
        "selection_balanced_slots": selection_balanced_slots,
        "semantic_niche_slots": semantic_niche_slots,
        "global_elite_slots": global_elite_slots,
        "retained_elite_slots": retained_elite_slots,
        "hindsight_fragments": hindsight_semantics.len(),
        "hindsight_semantics_examined": hindsight_seen.len(),
        "hindsight_probes": hindsight_probes,
        "hindsight_rows_evaluated": hindsight_rows_evaluated,
        "hindsight_false_positive_rejections": hindsight_false_positive_rejections,
        "hindsight_byte_rejections": hindsight_byte_rejections,
        "hindsight_composition_probes": hindsight_composition_probes,
        "hindsight_composition_rows": hindsight_composition_rows,
        "hindsight_compositions": hindsight_compositions,
        "hindsight_replayed": hindsight_replayed,
        "hindsight_replay_rejections": hindsight_replay_rejections,
        "hindsight_replay_rows": hindsight_replay_rows,
        "operator_scorecards": operator_scorecards,
        "bytes": bytes,
        "truncated": truncated,
        "cancelled": progress.cancelled.load(Ordering::Acquire),
        "low_priority": low_priority,
        "best": best.map(|(correct, false_positive, complexity, plan)| json!({
            "weighted_correct": correct,
            "false_positive": false_positive,
            "complexity": complexity,
            "plan": plan,
        })),
    }))
}

fn failure_shape(
    batch: &FeatureBatch,
    plan: &PlanSpec,
    first_mismatch: Option<usize>,
    field_index: &BTreeMap<&str, u16>,
) -> FailureShape {
    let mut shape = FailureShape {
        first_mismatch,
        expected: first_mismatch.map(|row| batch.expected(row)),
        probes: [FailureProbe::default(); MAX_FAILURE_PROBES],
        probe_count: 0,
    };
    let Some(row) = first_mismatch else {
        return shape;
    };
    let mut add_field = |name: &str| {
        let Some(&field) = field_index.get(name) else {
            return;
        };
        if shape.probes[..shape.probe_count as usize]
            .iter()
            .any(|probe| probe.field == field)
            || shape.probe_count as usize == MAX_FAILURE_PROBES
        {
            return;
        }
        shape.probes[shape.probe_count as usize] = FailureProbe {
            field,
            value: batch.row(row)[field as usize],
        };
        shape.probe_count += 1;
    };
    if let Some(scope) = &plan.scope {
        add_field(&scope.field);
    }
    for op in &plan.program {
        if let PlanOp::Field { name } = op {
            add_field(name);
        }
    }
    shape
}

fn failure_shape_record(
    batch: &FeatureBatch,
    shape: &FailureShape,
    evaluation: &super::Evaluation,
) -> Value {
    let kind = match (
        evaluation.weighted_false_positive != 0,
        evaluation.weighted_false_negative != 0,
    ) {
        (false, false) => "none",
        (true, false) => "false-positive",
        (false, true) => "false-negative",
        (true, true) => "mixed",
    };
    let probes = shape.probes[..shape.probe_count as usize]
        .iter()
        .map(|probe| {
            json!({
                "field": &batch.fields[probe.field as usize],
                "value": probe.value,
            })
        })
        .collect::<Vec<_>>();
    json!({
        "kind": kind,
        "first_mismatch_row": shape.first_mismatch,
        "first_mismatch_id": shape.first_mismatch.map(|row| batch.row_ids[row]),
        "first_mismatch_expected": shape.expected,
        "weighted_false_positive": evaluation.weighted_false_positive,
        "weighted_false_negative": evaluation.weighted_false_negative,
        "probes": probes,
    })
}

fn scope_profiles(batch: &FeatureBatch) -> Result<Vec<ScopeMutationProfile>, ControlError> {
    let mut profiles = Vec::new();
    for field_name in ["root_orbit", "root_candidate"] {
        let Some(field) = batch.fields.iter().position(|name| name == field_name) else {
            continue;
        };
        let mut observed_mask = 0_u64;
        let mut weights = [[0_u64; 2]; 64];
        for row in 0..batch.rows() {
            let value = batch.row(row)[field];
            if !(0..64).contains(&value) {
                continue;
            }
            let value = value as usize;
            observed_mask |= 1_u64 << value;
            let label = usize::from(batch.expected(row));
            weights[value][label] = weights[value][label]
                .checked_add(batch.weights[row])
                .ok_or_else(|| ControlError::Invalid("scope weight overflow".into()))?;
        }
        if observed_mask == 0 {
            continue;
        }
        let positive_majority_mask = weights
            .iter()
            .enumerate()
            .filter(|(_, weight)| weight[1] > weight[0])
            .fold(0_u64, |mask, (value, _)| mask | (1_u64 << value));
        profiles.push(ScopeMutationProfile {
            field: field_name.into(),
            observed_mask,
            positive_majority_mask,
        });
    }
    Ok(profiles)
}

fn push_scoped_child(
    parent: &PlanSpec,
    field: &str,
    mask: u64,
    operator: &'static str,
    emitter: &mut MutationEmitter<'_>,
) -> bool {
    if mask == 0 {
        return false;
    }
    emitter.emit(operator, || {
        let mut child = parent.clone();
        child.scope = Some(PlanScope {
            field: field.to_owned(),
            mask,
        });
        child
    })
}

fn mutate_plan(
    parent: &PlanSpec,
    parent_hash: &str,
    context: &MutationContext<'_>,
    failure_shape: &FailureShape,
    output: &mut Vec<PendingCandidate>,
    limit: usize,
    cursor: usize,
) -> MutationBatch {
    let mut emitter = MutationEmitter {
        parent_hash,
        output,
        limit,
        cursor,
        ordinal: 0,
    };
    if mutate_thresholds_from_failure(parent, context.field_index, failure_shape, &mut emitter) {
        return MutationBatch {
            next_cursor: emitter.ordinal,
            exhausted: false,
        };
    }
    for profile in context.scope_profiles {
        if parent
            .scope
            .as_ref()
            .is_some_and(|scope| scope.field == profile.field)
        {
            let current_mask = parent.scope.as_ref().map_or(0, |scope| scope.mask);
            let mut bits = profile.observed_mask;
            while bits != 0 {
                let bit = bits & bits.wrapping_neg();
                bits ^= bit;
                if push_scoped_child(
                    parent,
                    &profile.field,
                    current_mask ^ bit,
                    "scope-toggle",
                    &mut emitter,
                ) {
                    return MutationBatch {
                        next_cursor: emitter.ordinal,
                        exhausted: false,
                    };
                }
            }
        } else {
            let mut bits = profile.observed_mask;
            while bits != 0 {
                let bit = bits & bits.wrapping_neg();
                bits ^= bit;
                if push_scoped_child(
                    parent,
                    &profile.field,
                    bit,
                    "scope-initialize",
                    &mut emitter,
                ) {
                    return MutationBatch {
                        next_cursor: emitter.ordinal,
                        exhausted: false,
                    };
                }
            }
            if profile.positive_majority_mask != profile.observed_mask
                && push_scoped_child(
                    parent,
                    &profile.field,
                    profile.positive_majority_mask,
                    "scope-majority",
                    &mut emitter,
                )
            {
                return MutationBatch {
                    next_cursor: emitter.ordinal,
                    exhausted: false,
                };
            }
        }
    }
    for (index, op) in parent.program.iter().enumerate() {
        let (operator, replacements): (&'static str, Vec<PlanOp>) = match op {
            PlanOp::Const { value } => (
                "constant-shift",
                [-8, -2, -1, 1, 2, 8]
                    .into_iter()
                    .filter_map(|delta| value.checked_add(delta))
                    .map(|value| PlanOp::Const { value })
                    .collect(),
            ),
            PlanOp::Field { name } => (
                "field-substitute",
                context
                    .fields
                    .iter()
                    .filter(|field| *field != name)
                    .map(|name| PlanOp::Field { name: name.clone() })
                    .collect(),
            ),
            PlanOp::Eq | PlanOp::Ne | PlanOp::Lt | PlanOp::Le | PlanOp::Gt | PlanOp::Ge => (
                "comparison-substitute",
                vec![
                    PlanOp::Eq,
                    PlanOp::Ne,
                    PlanOp::Lt,
                    PlanOp::Le,
                    PlanOp::Gt,
                    PlanOp::Ge,
                ],
            ),
            PlanOp::And => ("boolean-flip", vec![PlanOp::Or]),
            PlanOp::Or => ("boolean-flip", vec![PlanOp::And]),
            _ => ("none", Vec::new()),
        };
        for replacement in replacements {
            if emitter.emit(operator, || {
                let mut child = parent.clone();
                child.program[index] = replacement;
                child
            }) {
                return MutationBatch {
                    next_cursor: emitter.ordinal,
                    exhausted: false,
                };
            }
        }
    }
    MutationBatch {
        next_cursor: emitter.ordinal,
        exhausted: true,
    }
}

fn mutate_thresholds_from_failure(
    parent: &PlanSpec,
    field_index: &BTreeMap<&str, u16>,
    failure_shape: &FailureShape,
    emitter: &mut MutationEmitter<'_>,
) -> bool {
    if failure_shape.first_mismatch.is_none() {
        return false;
    }
    let mut targeted = 0_usize;
    'targets: for index in 0..parent.program.len().saturating_sub(2) {
        let (field, constant, comparison) = match (
            &parent.program[index],
            &parent.program[index + 1],
            &parent.program[index + 2],
        ) {
            (
                PlanOp::Field { name },
                PlanOp::Const { value },
                PlanOp::Eq | PlanOp::Ne | PlanOp::Lt | PlanOp::Le | PlanOp::Gt | PlanOp::Ge,
            ) => (name, *value, &parent.program[index + 2]),
            _ => continue,
        };
        let Some(&field) = field_index.get(field.as_str()) else {
            continue;
        };
        let Some(value) = failure_shape.probes[..failure_shape.probe_count as usize]
            .iter()
            .find(|probe| probe.field == field)
            .map(|probe| probe.value)
        else {
            continue;
        };
        let Some(expected) = failure_shape.expected else {
            return false;
        };
        for replacement in threshold_replacements(comparison, expected, value)
            .into_iter()
            .flatten()
        {
            if replacement == constant {
                continue;
            }
            if targeted == MAX_TARGETED_MUTATIONS {
                break 'targets;
            }
            targeted += 1;
            if emitter.emit("counterexample-threshold", || {
                let mut child = parent.clone();
                child.program[index + 1] = PlanOp::Const { value: replacement };
                child
            }) {
                return true;
            }
        }
    }
    false
}

fn threshold_replacements(comparison: &PlanOp, expected: bool, value: i64) -> [Option<i64>; 2] {
    match (comparison, expected) {
        (PlanOp::Eq, true) | (PlanOp::Ne, false) => [Some(value), None],
        (PlanOp::Eq, false) | (PlanOp::Ne, true) => [value.checked_sub(1), value.checked_add(1)],
        (PlanOp::Lt, true) => [value.checked_add(1), None],
        (PlanOp::Lt, false) | (PlanOp::Le, true) | (PlanOp::Gt, false) | (PlanOp::Ge, true) => {
            [Some(value), None]
        }
        (PlanOp::Le, false) | (PlanOp::Gt, true) => [value.checked_sub(1), None],
        (PlanOp::Ge, false) => [value.checked_add(1), None],
        _ => [None, None],
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn cascade_gate_uses_the_reported_beam_order() {
        let mut survivors = vec![evolution_rank_key(90, 20, 4), evolution_rank_key(80, 0, 4)];
        survivors.sort_unstable();

        // More correct candidates beat a lower-false-positive survivor under
        // the published ordering; the old false-positive-first gate rejected
        // this candidate before its score could be observed.
        assert!(can_enter_beam(&survivors, 2, 85, 10, 4));
        assert!(!can_enter_beam(&survivors, 2, 79, 0, 1));
        assert!(can_enter_beam(&survivors, 2, 80, 0, 3));
    }

    #[test]
    fn counterexample_thresholds_satisfy_the_requested_label() {
        let comparisons = [
            PlanOp::Eq,
            PlanOp::Ne,
            PlanOp::Lt,
            PlanOp::Le,
            PlanOp::Gt,
            PlanOp::Ge,
        ];
        for comparison in &comparisons {
            for expected in [false, true] {
                for value in [i64::MIN, -1, 0, 1, i64::MAX] {
                    for replacement in threshold_replacements(comparison, expected, value)
                        .into_iter()
                        .flatten()
                    {
                        let observed = match comparison {
                            PlanOp::Eq => value == replacement,
                            PlanOp::Ne => value != replacement,
                            PlanOp::Lt => value < replacement,
                            PlanOp::Le => value <= replacement,
                            PlanOp::Gt => value > replacement,
                            PlanOp::Ge => value >= replacement,
                            _ => unreachable!(),
                        };
                        assert_eq!(observed, expected);
                    }
                }
            }
        }
    }

    #[test]
    fn fair_parent_shares_cover_the_budget_without_starvation() {
        for total in 1..100 {
            for count in 1..=total.min(16) {
                let shares = (0..count)
                    .map(|index| fair_share(total, index, count))
                    .collect::<Vec<_>>();
                assert_eq!(shares.iter().sum::<usize>(), total);
                assert!(shares.iter().all(|&share| share != 0));
                assert!(shares.iter().max().unwrap() - shares.iter().min().unwrap() <= 1);
            }
        }
    }

    #[test]
    fn candidate_impact_uses_the_exact_beam_order() {
        let parent = CandidateScore {
            correct: 8,
            false_positive: 1,
            complexity: 2,
        };
        let higher_recall = candidate_impact(
            CandidateScore {
                correct: 9,
                false_positive: 3,
                complexity: 4,
            },
            parent,
        );
        assert!(higher_recall.improved);
        assert_eq!(higher_recall.correct_gain, 1);
        assert_eq!(higher_recall.false_positive_increase, 2);

        let simpler = candidate_impact(
            CandidateScore {
                correct: 8,
                false_positive: 1,
                complexity: 1,
            },
            parent,
        );
        assert!(simpler.improved);

        let worse = candidate_impact(
            CandidateScore {
                correct: 7,
                false_positive: 0,
                complexity: 1,
            },
            parent,
        );
        assert!(!worse.improved);
        assert_eq!(worse.correct_loss, 1);
        assert_eq!(worse.false_positive_reduction, 1);
    }

    fn selector_parent(hash: &str, operator: &'static str) -> ExpansionParent {
        ExpansionParent {
            hash: hash.into(),
            outcome_hash: format!("outcome-{hash}"),
            plan: PlanSpec {
                schema: String::new(),
                name: String::new(),
                role: super::super::PlanRole::Diagnostic,
                output: super::super::PlanOutput::Predicate,
                scope: None,
                program: Vec::new(),
            },
            first_mismatch: None,
            score: CandidateScore {
                correct: 10,
                false_positive: 0,
                complexity: 1,
            },
            operator,
            niche: SemanticNiche::new(operator, 0, 1, 8),
            mutation_cursor: 0,
        }
    }

    fn niche_candidate(
        name: &str,
        correct: u64,
        operator: &'static str,
        expected: Option<bool>,
        cost: u64,
    ) -> RankedCandidate {
        let parent = selector_parent(name, operator);
        let (false_positive, false_negative) = match expected {
            None => (0, 0),
            Some(false) => (1, 0),
            Some(true) => (0, 1),
        };
        RankedCandidate {
            score: CandidateScore {
                correct,
                false_positive: 0,
                complexity: 1,
            },
            outcome_hash: format!("outcome-{name}"),
            hash: parent.hash,
            plan: parent.plan,
            first_mismatch: parent.first_mismatch,
            operator,
            niche: SemanticNiche::new(operator, false_positive, false_negative, cost),
            mutation_cursor: 0,
            retained: false,
        }
    }

    #[test]
    fn semantic_niches_preserve_diverse_elites_before_global_fill() {
        let current = vec![
            niche_candidate("best-a", 10, "constant-delta", Some(true), 8),
            niche_candidate("second-a", 9, "constant-delta", Some(true), 8),
            niche_candidate("best-b", 8, "scope", Some(false), 64),
        ];
        let selection = select_semantic_elites(current, &[], 2, 2);
        assert_eq!(selection.niche_slots, 2);
        assert_eq!(selection.global_slots, 0);
        assert_eq!(selection.parents[0].hash, "best-a");
        assert_eq!(selection.parents[1].hash, "best-b");

        let current = vec![
            niche_candidate("best-a", 10, "constant-delta", Some(true), 8),
            niche_candidate("second-a", 9, "constant-delta", Some(true), 8),
        ];
        let selection = select_semantic_elites(current, &[], 2, 2);
        assert_eq!(selection.niche_slots, 1);
        assert_eq!(selection.global_slots, 1);
        assert_eq!(selection.parents[0].hash, "best-a");
        assert_eq!(selection.parents[1].hash, "second-a");

        let mut retained = selector_parent("retained-b", "scope");
        retained.score.correct = 8;
        retained.mutation_cursor = 7;
        let current = vec![
            niche_candidate("best-a", 10, "constant-delta", Some(true), 8),
            niche_candidate("second-a", 9, "constant-delta", Some(true), 8),
        ];
        let selection = select_semantic_elites(current, &[retained], 2, 2);
        assert_eq!(selection.retained_slots, 1);
        let retained = selection
            .parents
            .iter()
            .find(|parent| parent.hash == "retained-b")
            .unwrap();
        assert_eq!(retained.mutation_cursor, 7);

        let mut same_niche = selector_parent("retained-a", "constant-delta");
        same_niche.score.correct = 20;
        same_niche.mutation_cursor = 5;
        let current = vec![
            niche_candidate("best-a", 10, "constant-delta", Some(true), 8),
            niche_candidate("second-a", 9, "constant-delta", Some(true), 8),
        ];
        let selection = select_semantic_elites(current, &[same_niche], 2, 2);
        assert_eq!(selection.retained_slots, 0);
        assert_eq!(selection.parents[0].hash, "best-a");
        assert_eq!(selection.parents[1].hash, "second-a");
    }

    #[test]
    fn mutation_cursor_resumes_without_duplicate_offspring() {
        let parent = PlanSpec {
            schema: String::new(),
            name: "cursor-parent".into(),
            role: super::super::PlanRole::Diagnostic,
            output: super::super::PlanOutput::Predicate,
            scope: None,
            program: vec![PlanOp::Const { value: 0 }],
        };
        let fields = Vec::new();
        let scopes = Vec::new();
        let field_index = BTreeMap::new();
        let context = MutationContext {
            fields: &fields,
            scope_profiles: &scopes,
            field_index: &field_index,
        };
        let failure = FailureShape {
            first_mismatch: None,
            expected: None,
            probes: [FailureProbe::default(); MAX_FAILURE_PROBES],
            probe_count: 0,
        };
        let mut cursor = 0;
        let mut resumed = Vec::new();
        let mut exhaustion = Vec::new();
        for _ in 0..3 {
            let mut batch_output = Vec::new();
            let batch = mutate_plan(
                &parent,
                "parent",
                &context,
                &failure,
                &mut batch_output,
                2,
                cursor,
            );
            cursor = batch.next_cursor;
            exhaustion.push(batch.exhausted);
            resumed.extend(
                batch_output
                    .into_iter()
                    .map(|candidate| candidate.plan.program),
            );
        }
        assert_eq!(exhaustion, [false, false, true]);
        let mut exhausted_output = Vec::new();
        let exhausted = mutate_plan(
            &parent,
            "parent",
            &context,
            &failure,
            &mut exhausted_output,
            2,
            cursor,
        );
        assert!(exhausted.exhausted);
        assert!(exhausted_output.is_empty());

        let mut complete = Vec::new();
        let complete_batch = mutate_plan(
            &parent,
            "parent",
            &context,
            &failure,
            &mut complete,
            usize::MAX,
            0,
        );
        assert!(complete_batch.exhausted);
        assert_eq!(resumed.len(), 6);
        assert_eq!(
            serde_json::to_value(&resumed).unwrap(),
            serde_json::to_value(
                complete
                    .into_iter()
                    .map(|candidate| candidate.plan.program)
                    .collect::<Vec<_>>()
            )
            .unwrap()
        );
    }

    #[test]
    fn hindsight_extracts_and_streams_only_zero_false_positive_subexpressions() {
        let batch = FeatureBatch {
            presentation: "hindsight".into(),
            problem: "subexpression".into(),
            fields: vec!["x".into(), "y".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0, 1, 2, 3].into_boxed_slice(),
            weights: vec![1, 1, 1, 1].into_boxed_slice(),
            expected: vec![0b0011].into_boxed_slice(),
            values: vec![1, 1, 2, -1, -1, 1, -1, -1].into_boxed_slice(),
        };
        let plan = PlanSpec {
            schema: super::super::PLAN_SCHEMA.into(),
            name: "hindsight-parent".into(),
            role: super::super::PlanRole::Diagnostic,
            output: super::super::PlanOutput::Predicate,
            scope: None,
            program: vec![
                PlanOp::Field { name: "x".into() },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
                PlanOp::Field { name: "y".into() },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
                PlanOp::And,
            ],
        };
        let parent = ExpansionParent {
            hash: "0123456789abcdef".into(),
            outcome_hash: "outcome".into(),
            plan,
            first_mismatch: Some(1),
            score: CandidateScore {
                correct: 3,
                false_positive: 0,
                complexity: 7,
            },
            operator: "seed",
            niche: SemanticNiche::new("seed", 0, 1, 28),
            mutation_cursor: 0,
        };
        let extraction =
            extract_hindsight_fragments(&parent, &batch, &mut BTreeSet::new()).unwrap();
        assert_eq!(extraction.probes, 2);
        assert_eq!(extraction.false_positive_rejections, 1);
        assert_eq!(extraction.fragments.len(), 1);
        assert_eq!(extraction.fragments[0].weighted_true_positive, 2);
        assert_eq!(
            serde_json::to_value(&extraction.fragments[0].plan.program).unwrap(),
            json!([
                {"op": "field", "name": "x"},
                {"op": "const", "value": 0},
                {"op": "gt"}
            ])
        );

        let temporary = tempfile::tempdir().unwrap();
        let evidence_path = temporary.path().join("hindsight.jsonl");
        let identity = EvolutionIdentity {
            code_commit: "test".into(),
            presentation_hash: "0".repeat(64),
            presentation: batch.presentation.clone(),
            problem: batch.problem.clone(),
            fields: batch.fields.clone(),
            generator: None,
        };
        let summary = run_evolution(
            Arc::new(batch),
            identity,
            vec![EvolutionSeed {
                plan: parent.plan,
                parent_hash: None,
                source_hash: None,
                source_evidence: None,
                operator: "seed",
            }],
            Vec::new(),
            File::create(&evidence_path).unwrap(),
            EvolutionBounds {
                generations: 2,
                beam: 1,
                max_candidates: 2,
                byte_limit: 64 * 1024,
            },
            Arc::new(EvolutionProgress::new()),
        )
        .unwrap();
        assert_eq!(summary["hindsight_fragments"], 1);
        let records = std::fs::read_to_string(&evidence_path)
            .unwrap()
            .lines()
            .map(|line| serde_json::from_str::<Value>(line).unwrap())
            .collect::<Vec<_>>();
        let fragment = records
            .iter()
            .find(|record| record["type"] == "hindsight-fragment")
            .unwrap();
        assert_eq!(fragment["trusted"], false);
        assert_eq!(fragment["replay_obligation"], "compatible-feature-batch");
        assert_eq!(fragment["weighted_true_positive"], 2);
        assert_eq!(fragment["source_hash"], records[1]["hash"]);
    }

    #[test]
    fn hindsight_composes_disjoint_sound_fragments_with_exact_replay() {
        let batch = FeatureBatch {
            presentation: "composition".into(),
            problem: "sound-union".into(),
            fields: vec!["x".into(), "y".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0, 1, 2].into_boxed_slice(),
            weights: vec![1, 1, 1].into_boxed_slice(),
            expected: vec![0b0011].into_boxed_slice(),
            values: vec![1, 0, 0, 1, -1, -1].into_boxed_slice(),
        };
        let plan = PlanSpec {
            schema: super::super::PLAN_SCHEMA.into(),
            name: "composition-parent".into(),
            role: super::super::PlanRole::Diagnostic,
            output: super::super::PlanOutput::Predicate,
            scope: None,
            program: vec![
                PlanOp::Field { name: "x".into() },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
                PlanOp::Field { name: "y".into() },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
                PlanOp::Or,
            ],
        };
        let parent = ExpansionParent {
            hash: "fedcba9876543210".into(),
            outcome_hash: "outcome".into(),
            plan,
            first_mismatch: None,
            score: CandidateScore {
                correct: 3,
                false_positive: 0,
                complexity: 7,
            },
            operator: "seed",
            niche: SemanticNiche::new("seed", 0, 0, 21),
            mutation_cursor: 0,
        };
        let mut seen = BTreeSet::new();
        let extracted = extract_hindsight_fragments(&parent, &batch, &mut seen).unwrap();
        assert_eq!(extracted.fragments.len(), 2);
        let composed = compose_hindsight_fragments(
            &extracted.fragments,
            &batch,
            &mut seen,
            MAX_HINDSIGHT_COMPOSITION_PROBES,
        )
        .unwrap();
        assert_eq!(composed.probes, 1);
        assert_eq!(composed.rows_evaluated, 3);
        assert_eq!(composed.compositions.len(), 1);
        assert_eq!(composed.compositions[0].fragment.weighted_true_positive, 2);
        assert_eq!(
            composed.compositions[0].left_semantic_hash,
            extracted.fragments[0].semantic_hash
        );
        assert_eq!(
            composed.compositions[0].right_semantic_hash,
            extracted.fragments[1].semantic_hash
        );
        assert_eq!(
            serde_json::to_value(
                composed.compositions[0]
                    .fragment
                    .plan
                    .program
                    .last()
                    .unwrap()
            )
            .unwrap(),
            json!({"op": "or"})
        );

        let temporary = tempfile::tempdir().unwrap();
        let evidence_path = temporary.path().join("composition.jsonl");
        let identity = EvolutionIdentity {
            code_commit: "test".into(),
            presentation_hash: "1".repeat(64),
            presentation: batch.presentation.clone(),
            problem: batch.problem.clone(),
            fields: batch.fields.clone(),
            generator: None,
        };
        let summary = run_evolution(
            Arc::new(batch),
            identity,
            vec![EvolutionSeed {
                plan: parent.plan,
                parent_hash: None,
                source_hash: None,
                source_evidence: None,
                operator: "seed",
            }],
            Vec::new(),
            File::create(&evidence_path).unwrap(),
            EvolutionBounds {
                generations: 2,
                beam: 1,
                max_candidates: 2,
                byte_limit: 64 * 1024,
            },
            Arc::new(EvolutionProgress::new()),
        )
        .unwrap();
        assert_eq!(summary["hindsight_compositions"], 1);
        let records = std::fs::read_to_string(&evidence_path)
            .unwrap()
            .lines()
            .map(|line| serde_json::from_str::<Value>(line).unwrap())
            .collect::<Vec<_>>();
        let composition = records
            .iter()
            .find(|record| record["type"] == "hindsight-composition")
            .unwrap();
        assert_eq!(composition["trusted"], false);
        assert_eq!(composition["derivation"]["rule"], "or-zero-false-positive");
        assert_eq!(
            composition["derivation"]["parents"]
                .as_array()
                .unwrap()
                .len(),
            2
        );

        let replay_batch = FeatureBatch {
            presentation: "composition".into(),
            problem: "sound-union".into(),
            fields: vec!["x".into(), "y".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0, 1, 2].into_boxed_slice(),
            weights: vec![1, 1, 1].into_boxed_slice(),
            expected: vec![0b0011].into_boxed_slice(),
            values: vec![1, 0, 0, 1, -1, -1].into_boxed_slice(),
        };
        let replay_identity = EvolutionIdentity {
            code_commit: "replay-test".into(),
            presentation_hash: "1".repeat(64),
            presentation: replay_batch.presentation.clone(),
            problem: replay_batch.problem.clone(),
            fields: replay_batch.fields.clone(),
            generator: None,
        };
        let archive = load_evolution_archive(&evidence_path, &replay_identity, 4, 64).unwrap();
        assert_eq!(archive.fragments.len(), 3);
        let corrupt_path = temporary.path().join("corrupt-composition.jsonl");
        let mut corrupted = Vec::new();
        let mut changed = false;
        for line in std::fs::read_to_string(&evidence_path).unwrap().lines() {
            let mut record = serde_json::from_str::<Value>(line).unwrap();
            if !changed && record["type"] == "hindsight-fragment" {
                record["semantic_hash"] = Value::String("0".repeat(64));
                changed = true;
            }
            corrupted.push(serde_json::to_string(&record).unwrap());
        }
        std::fs::write(&corrupt_path, format!("{}\n", corrupted.join("\n"))).unwrap();
        let corruption = match load_evolution_archive(&corrupt_path, &replay_identity, 4, 64) {
            Ok(_) => panic!("corrupted hindsight archive was accepted"),
            Err(error) => error,
        };
        assert!(corruption
            .to_string()
            .contains("hindsight semantic hash does not match"));
        let rejection_batch = FeatureBatch {
            presentation: "changed".into(),
            problem: "sound-union".into(),
            fields: vec!["x".into(), "y".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0].into_boxed_slice(),
            weights: vec![1].into_boxed_slice(),
            expected: vec![0].into_boxed_slice(),
            values: vec![1, 0].into_boxed_slice(),
        };
        let rejected = replay_hindsight_fragment(&archive.fragments[0], &rejection_batch).unwrap();
        assert!(rejected.fragment.is_none());
        assert_eq!(rejected.rows_evaluated, 1);
        let replay_path = temporary.path().join("replayed.jsonl");
        let replay_summary = run_evolution(
            Arc::new(replay_batch),
            replay_identity,
            archive.seeds,
            archive.fragments,
            File::create(&replay_path).unwrap(),
            EvolutionBounds {
                generations: 1,
                beam: 1,
                max_candidates: 1,
                byte_limit: 64 * 1024,
            },
            Arc::new(EvolutionProgress::new()),
        )
        .unwrap();
        assert_eq!(replay_summary["hindsight_replayed"], 3);
        assert_eq!(replay_summary["hindsight_replay_rejections"], 0);
        assert_eq!(
            std::fs::read_to_string(replay_path)
                .unwrap()
                .lines()
                .map(|line| serde_json::from_str::<Value>(line).unwrap())
                .filter(|record| record["type"] == "hindsight-replay")
                .count(),
            3
        );
    }

    #[test]
    fn maximum_oriented_quotas_keep_exploration_and_price_cost() {
        assert_eq!(
            diminishing_ratio_cmp(u64::MAX, u64::MAX, 100_000, u64::MAX - 1, u64::MAX, 100_000,),
            std::cmp::Ordering::Greater
        );
        assert_eq!(
            diminishing_ratio_cmp(3, 2, 7, 9, 6, 7),
            std::cmp::Ordering::Equal
        );
        let parents = [selector_parent("a", "fast"), selector_parent("b", "slow")];
        let empty = BTreeMap::new();
        assert_eq!(maximum_oriented_quotas(&parents, 10, &empty), [5, 5]);

        let mut scorecards = BTreeMap::new();
        scorecards.insert(
            "fast",
            OperatorScorecard {
                improved: 1,
                compared_to_parent: 1,
                best_correct_gain: 8,
                best_correct_gain_per_cost_numerator: 8,
                best_correct_gain_per_cost_denominator: Some(8),
                minimum_improving_semantic_op_rows: Some(8),
                ..OperatorScorecard::default()
            },
        );
        scorecards.insert(
            "slow",
            OperatorScorecard {
                improved: 1,
                compared_to_parent: 1,
                best_correct_gain: 8,
                best_correct_gain_per_cost_numerator: 8,
                best_correct_gain_per_cost_denominator: Some(80),
                minimum_improving_semantic_op_rows: Some(80),
                ..OperatorScorecard::default()
            },
        );
        let quotas = maximum_oriented_quotas(&parents, 10, &scorecards);
        assert_eq!(quotas, [9, 1]);

        let many = (0..256)
            .map(|index| selector_parent(&format!("{index:064x}"), "fast"))
            .collect::<Vec<_>>();
        let quotas = maximum_oriented_quotas(&many, 100_000, &scorecards);
        assert_eq!(quotas.iter().sum::<usize>(), 100_000);
        assert!(quotas.iter().all(|&quota| quota != 0));
        assert!(quotas.iter().max().unwrap() - quotas.iter().min().unwrap() <= 1);
    }

    #[test]
    fn premise_pairs_rank_marginal_coverage_per_semantic_cost() {
        let mut pairs = [
            PremisePair {
                left: 0,
                right: 1,
                weighted_union: 20,
                marginal_gain: 10,
                semantic_ops: 100,
            },
            PremisePair {
                left: 0,
                right: 2,
                weighted_union: 12,
                marginal_gain: 2,
                semantic_ops: 4,
            },
        ];
        pairs.sort_unstable_by(premise_pair_cmp);
        assert_eq!((pairs[0].left, pairs[0].right), (0, 2));
    }
}
