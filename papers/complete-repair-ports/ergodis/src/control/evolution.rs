use super::{
    vm::evaluate_plan_cascaded, CompiledPlan, ControlError, FeatureBatch,
    FeatureGeneratorProvenance, PlanOp, PlanScope, PlanSpec, MAX_PLAN_OPS,
};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::{BTreeMap, BTreeSet, BinaryHeap};
use std::fs::File;
use std::io::{BufRead, BufReader, BufWriter, Write};
use std::path::Path;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{Arc, Mutex};

const EVOLUTION_EVIDENCE_SCHEMA: &str = "ergodis-evolution-evidence-v0";
const MAX_EVOLUTION_IMPORT_BYTES: u64 = 16 * 1024 * 1024;
const MAX_EVOLUTION_RECORD_BYTES: usize = 256 * 1024;
const BASE_EVOLUTION_FOOTER_BYTES: u64 = 8 * 1024;
const MAX_FAILURE_PROBES: usize = 8;
const MAX_TARGETED_MUTATIONS: usize = 24;
const MAX_CLAUSE_PROFILE_FIELDS: usize = 16;
const MAX_CLAUSE_PROFILE_VALUES: usize = 8;
const MAX_CLAUSE_PROFILE_ROWS: usize = 4_096;
const MAX_CLAUSE_PROFILES: usize = 16;
const MAX_CLAUSE_PAIR_PROFILES: usize = 8;
const MAX_RELATIONAL_PROFILE_FIELDS: usize = 32;
const MAX_RELATIONAL_PROFILE_VALUES: usize = 8;
const MAX_RELATIONAL_PROFILES: usize = 24;
const MAX_HINDSIGHT_FRAGMENTS: usize = 64;
const MAX_HINDSIGHT_SEMANTICS: usize = 256;
const MAX_HINDSIGHT_PROBES_PER_PARENT: usize = 16;
const MAX_HINDSIGHT_FRAGMENTS_PER_PARENT: usize = 4;
const MAX_HINDSIGHT_COMPOSITION_PROBES: usize = 64;
const MAX_HINDSIGHT_COMPOSITION_PROBES_PER_GENERATION: usize = 16;
const MAX_HINDSIGHT_COMPOSITIONS_PER_GENERATION: usize = 8;
pub(super) const MAX_EVOLUTION_TARGET_FIELDS: usize = 4;
const MAX_EVOLUTION_TARGET_NODES: usize = 64;
const MAX_EVOLUTION_TARGET_EDGES: usize = 256;
const EVOLUTION_TARGET_PROFILE_SCHEMA: &str = "ergodis-evolution-target-profile-v0";

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
    #[serde(default, skip_serializing_if = "target_fields_empty")]
    target_fields: Box<[String]>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    target_profile_hash: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    target_profile: Option<EvolutionTargetProfile>,
}

fn target_fields_empty(fields: &[String]) -> bool {
    fields.is_empty()
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
            target_fields: Box::new([]),
            target_profile_hash: None,
            target_profile: None,
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

pub(super) struct EvolutionBounds {
    pub generations: usize,
    pub beam: usize,
    pub max_candidates: usize,
    pub byte_limit: u64,
    pub target_fields: Box<[usize]>,
    pub target_profile: Option<EvolutionTargetProfile>,
    pub target_profile_mailbox: Arc<Mutex<Option<EvolutionTargetProfile>>>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub(super) struct EvolutionTargetProfile {
    schema: String,
    fields: Box<[String]>,
    nodes: Box<[EvolutionTargetNode]>,
    #[serde(default)]
    edges: Box<[EvolutionTargetEdge]>,
}

#[derive(Clone, Copy, Debug, Default, Eq, Ord, PartialEq, PartialOrd, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub(super) enum EvolutionTargetStrategy {
    #[default]
    Balanced,
    Numeric,
    Structural,
}

impl EvolutionTargetStrategy {
    fn is_balanced(&self) -> bool {
        *self == Self::Balanced
    }

    pub(super) fn parse(value: &str) -> Result<Self, ControlError> {
        match value {
            "balanced" => Ok(Self::Balanced),
            "numeric" => Ok(Self::Numeric),
            "structural" => Ok(Self::Structural),
            _ => Err(ControlError::Invalid(
                "target strategy must be balanced, numeric, or structural".into(),
            )),
        }
    }

    fn as_str(self) -> &'static str {
        match self {
            Self::Balanced => "balanced",
            Self::Numeric => "numeric",
            Self::Structural => "structural",
        }
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct EvolutionTargetNode {
    values: Box<[i64]>,
    mass: u64,
    unit_cost: u64,
    #[serde(default, skip_serializing_if = "EvolutionTargetStrategy::is_balanced")]
    strategy: EvolutionTargetStrategy,
}

#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
enum EvolutionTargetEdgeKind {
    Dependency,
    Continuation,
}

#[derive(Clone, Copy, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct EvolutionTargetEdge {
    from: u16,
    to: u16,
    kind: EvolutionTargetEdgeKind,
}

struct CompiledTargetProfile {
    hash: String,
    class_priorities: Box<[u64]>,
    class_strategies: Box<[EvolutionTargetStrategy]>,
    nodes: usize,
    edges: usize,
}

impl CompiledTargetProfile {
    fn strategy(&self, class: Option<u32>) -> EvolutionTargetStrategy {
        class
            .and_then(|class| self.class_strategies.get(class as usize))
            .copied()
            .unwrap_or_default()
    }
}

fn target_profile_hash(profile: &EvolutionTargetProfile) -> Result<String, ControlError> {
    let encoded = serde_json::to_vec(profile)?;
    Ok(blake3::hash(&encoded).to_hex().to_string())
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd)]
struct TargetKey {
    values: [i64; MAX_EVOLUTION_TARGET_FIELDS],
    len: u8,
    _pad: [u8; 7],
}

const _: () = assert!(std::mem::size_of::<TargetKey>() == 40);
const _: () = assert!(std::mem::align_of::<TargetKey>() == 8);

impl TargetKey {
    fn from_row(row: &[i64], fields: &[usize]) -> Self {
        let mut values = [0_i64; MAX_EVOLUTION_TARGET_FIELDS];
        for (slot, &field) in fields.iter().enumerate() {
            values[slot] = row[field];
        }
        Self {
            values,
            len: fields.len() as u8,
            _pad: [0; 7],
        }
    }

    fn values(&self) -> &[i64] {
        &self.values[..usize::from(self.len)]
    }

    fn from_values(values: &[i64], width: usize) -> Result<Self, ControlError> {
        if values.len() != width || width > MAX_EVOLUTION_TARGET_FIELDS {
            return Err(ControlError::Invalid(
                "evolution target node has the wrong tuple width".into(),
            ));
        }
        let mut key = Self {
            values: [0; MAX_EVOLUTION_TARGET_FIELDS],
            len: width as u8,
            _pad: [0; 7],
        };
        key.values[..width].copy_from_slice(values);
        Ok(key)
    }
}

struct TargetClasses {
    row_classes: Box<[u32]>,
    keys: Box<[TargetKey]>,
}

impl TargetClasses {
    fn compile(batch: &FeatureBatch, fields: &[usize]) -> Result<Self, ControlError> {
        if fields.is_empty() {
            return Ok(Self {
                row_classes: Box::new([]),
                keys: Box::new([]),
            });
        }
        let mut classes = BTreeMap::<TargetKey, u32>::new();
        let mut keys = Vec::<TargetKey>::new();
        let mut row_classes = Vec::with_capacity(batch.weights.len());
        for row in 0..batch.weights.len() {
            let key = TargetKey::from_row(batch.row(row), fields);
            let class = if let Some(&class) = classes.get(&key) {
                class
            } else {
                let class = u32::try_from(keys.len()).map_err(|_| {
                    ControlError::Invalid("too many evolution target classes".into())
                })?;
                keys.push(key);
                classes.insert(key, class);
                class
            };
            row_classes.push(class);
        }
        Ok(Self {
            row_classes: row_classes.into_boxed_slice(),
            keys: keys.into_boxed_slice(),
        })
    }

    fn class(&self, row: usize) -> Option<u32> {
        self.row_classes.get(row).copied()
    }

    fn values(&self, class: u32) -> &[i64] {
        self.keys[class as usize].values()
    }

    fn footer_reserve(&self, target_fields: usize) -> u64 {
        let retained_classes = self.keys.len().min(64) as u64;
        BASE_EVOLUTION_FOOTER_BYTES + retained_classes * (64 + 24 * target_fields as u64)
    }

    fn compile_profile(
        &self,
        profile: &EvolutionTargetProfile,
        expected_fields: &[&str],
    ) -> Result<CompiledTargetProfile, ControlError> {
        if profile.schema != EVOLUTION_TARGET_PROFILE_SCHEMA
            || profile.fields.len() != expected_fields.len()
            || !profile
                .fields
                .iter()
                .zip(expected_fields)
                .all(|(left, right)| left == right)
            || profile.nodes.is_empty()
            || profile.nodes.len() > MAX_EVOLUTION_TARGET_NODES
            || profile.edges.len() > MAX_EVOLUTION_TARGET_EDGES
        {
            return Err(ControlError::Invalid(
                "evolution target profile is incompatible or exceeds its bounds".into(),
            ));
        }
        let mut node_by_key = BTreeMap::<TargetKey, usize>::new();
        let mut direct_work = Vec::with_capacity(profile.nodes.len());
        for (node, spec) in profile.nodes.iter().enumerate() {
            let key = TargetKey::from_values(&spec.values, expected_fields.len())?;
            if spec.mass == 0 || spec.unit_cost == 0 || node_by_key.insert(key, node).is_some() {
                return Err(ControlError::Invalid(
                    "evolution target nodes must be distinct with positive mass and cost".into(),
                ));
            }
            direct_work.push(spec.mass.checked_mul(spec.unit_cost).ok_or_else(|| {
                ControlError::Invalid("evolution target work overflows u64".into())
            })?);
        }
        let mut node_classes = vec![None; profile.nodes.len()];
        for (class, key) in self.keys.iter().enumerate() {
            if let Some(&node) = node_by_key.get(key) {
                node_classes[node] = Some(class);
            }
        }
        if node_classes.iter().any(Option::is_none) {
            return Err(ControlError::Invalid(
                "evolution target profile names a tuple absent from the frozen batch".into(),
            ));
        }
        let mut edge_set = BTreeSet::new();
        let mut reach = (0..profile.nodes.len())
            .map(|node| 1_u64 << node)
            .collect::<Vec<_>>();
        for edge in &profile.edges {
            let from = usize::from(edge.from);
            let to = usize::from(edge.to);
            if from >= profile.nodes.len()
                || to >= profile.nodes.len()
                || from == to
                || !edge_set.insert((edge.from, edge.to))
            {
                return Err(ControlError::Invalid(
                    "evolution target profile has an invalid edge".into(),
                ));
            }
            reach[from] |= 1_u64 << to;
        }
        loop {
            let mut changed = false;
            for node in 0..reach.len() {
                let mut closure = reach[node];
                let mut pending = closure;
                while pending != 0 {
                    let next = pending.trailing_zeros() as usize;
                    pending &= pending - 1;
                    closure |= reach[next];
                }
                changed |= closure != reach[node];
                reach[node] = closure;
            }
            if !changed {
                break;
            }
        }
        let mut class_priorities = vec![0_u64; self.keys.len()];
        let mut class_strategies = vec![EvolutionTargetStrategy::Balanced; self.keys.len()];
        for (node, class) in node_classes.into_iter().enumerate() {
            let class = class.ok_or_else(|| {
                ControlError::Invalid("evolution target profile lost its class binding".into())
            })?;
            let mut priority = 0_u64;
            let mut reachable = reach[node];
            while reachable != 0 {
                let target = reachable.trailing_zeros() as usize;
                reachable &= reachable - 1;
                priority = priority.checked_add(direct_work[target]).ok_or_else(|| {
                    ControlError::Invalid("evolution target priority overflows u64".into())
                })?;
            }
            class_priorities[class] = priority;
            class_strategies[class] = profile.nodes[node].strategy;
        }
        Ok(CompiledTargetProfile {
            hash: target_profile_hash(profile)?,
            class_priorities: class_priorities.into_boxed_slice(),
            class_strategies: class_strategies.into_boxed_slice(),
            nodes: profile.nodes.len(),
            edges: profile.edges.len(),
        })
    }
}

pub(super) struct EvolutionTargetAccumulator {
    fields: Box<[String]>,
    nodes: BTreeMap<TargetKey, (u64, u64, EvolutionTargetStrategy)>,
    edges: BTreeSet<(TargetKey, TargetKey, EvolutionTargetEdgeKind)>,
}

impl EvolutionTargetAccumulator {
    pub(super) fn new(fields: Box<[String]>) -> Result<Self, ControlError> {
        if fields.is_empty()
            || fields.len() > MAX_EVOLUTION_TARGET_FIELDS
            || fields.iter().collect::<BTreeSet<_>>().len() != fields.len()
        {
            return Err(ControlError::Invalid(
                "target profile fields must be distinct and bounded".into(),
            ));
        }
        Ok(Self {
            fields,
            nodes: BTreeMap::new(),
            edges: BTreeSet::new(),
        })
    }

    pub(super) fn observe(
        &mut self,
        values: &[i64],
        mass: u64,
        unit_cost: u64,
        strategy: EvolutionTargetStrategy,
    ) -> Result<bool, ControlError> {
        let key = TargetKey::from_values(values, self.fields.len())?;
        if mass == 0 || unit_cost == 0 || mass.checked_mul(unit_cost).is_none() {
            return Err(ControlError::Invalid(
                "target observation work must be positive and fit u64".into(),
            ));
        }
        if !self.nodes.contains_key(&key) && self.nodes.len() == MAX_EVOLUTION_TARGET_NODES {
            return Err(ControlError::Invalid(
                "target profile node arena is full".into(),
            ));
        }
        Ok(
            self.nodes.insert(key, (mass, unit_cost, strategy))
                != Some((mass, unit_cost, strategy)),
        )
    }

    pub(super) fn connect(
        &mut self,
        from: &[i64],
        to: &[i64],
        kind: &str,
    ) -> Result<bool, ControlError> {
        let from = TargetKey::from_values(from, self.fields.len())?;
        let to = TargetKey::from_values(to, self.fields.len())?;
        let kind = match kind {
            "dependency" => EvolutionTargetEdgeKind::Dependency,
            "continuation" => EvolutionTargetEdgeKind::Continuation,
            _ => {
                return Err(ControlError::Invalid(
                    "target profile edge kind must be dependency or continuation".into(),
                ));
            }
        };
        if from == to || !self.nodes.contains_key(&from) || !self.nodes.contains_key(&to) {
            return Err(ControlError::Invalid(
                "target profile edges require distinct existing nodes".into(),
            ));
        }
        if let Some((_, _, existing_kind)) = self
            .edges
            .iter()
            .find(|(existing_from, existing_to, _)| *existing_from == from && *existing_to == to)
        {
            if *existing_kind == kind {
                return Ok(false);
            }
            return Err(ControlError::Invalid(
                "target profile edge endpoints already have a different kind".into(),
            ));
        }
        let edge = (from, to, kind);
        if self.edges.len() == MAX_EVOLUTION_TARGET_EDGES {
            return Err(ControlError::Invalid(
                "target profile edge arena is full".into(),
            ));
        }
        self.edges.insert(edge);
        Ok(true)
    }

    pub(super) fn snapshot(&self) -> Result<EvolutionTargetProfile, ControlError> {
        if self.nodes.is_empty() {
            return Err(ControlError::Invalid(
                "target profile has no observations".into(),
            ));
        }
        let mut index = BTreeMap::<TargetKey, u16>::new();
        let mut nodes = Vec::with_capacity(self.nodes.len());
        for (key, &(mass, unit_cost, strategy)) in &self.nodes {
            let node = u16::try_from(nodes.len())
                .map_err(|_| ControlError::Invalid("target node index overflow".into()))?;
            index.insert(*key, node);
            nodes.push(EvolutionTargetNode {
                values: key.values().to_vec().into_boxed_slice(),
                mass,
                unit_cost,
                strategy,
            });
        }
        let edges = self
            .edges
            .iter()
            .map(|&(from, to, kind)| {
                Ok(EvolutionTargetEdge {
                    from: *index.get(&from).ok_or_else(|| {
                        ControlError::Invalid("target edge lost its source node".into())
                    })?,
                    to: *index.get(&to).ok_or_else(|| {
                        ControlError::Invalid("target edge lost its destination node".into())
                    })?,
                    kind,
                })
            })
            .collect::<Result<Vec<_>, ControlError>>()?;
        Ok(EvolutionTargetProfile {
            schema: EVOLUTION_TARGET_PROFILE_SCHEMA.into(),
            fields: self.fields.clone(),
            nodes: nodes.into_boxed_slice(),
            edges: edges.into_boxed_slice(),
        })
    }

    pub(super) fn fields(&self) -> &[String] {
        &self.fields
    }

    pub(super) fn contains(&self, values: &[i64]) -> Result<bool, ControlError> {
        Ok(self
            .nodes
            .contains_key(&TargetKey::from_values(values, self.fields.len())?))
    }

    pub(super) fn nodes(&self) -> usize {
        self.nodes.len()
    }

    pub(super) fn edges(&self) -> usize {
        self.edges.len()
    }
}

struct ScopeMutationProfile {
    field: String,
    observed_mask: u64,
    positive_majority_mask: u64,
}

struct MutationContext<'a> {
    fields: &'a [String],
    scope_profiles: &'a [ScopeMutationProfile],
    clause_profiles: &'a [ClauseMutationProfile],
    clause_pair_profiles: &'a [ClausePairMutationProfile],
    relational_profiles: &'a [RelationalMutationProfile],
    field_index: &'a BTreeMap<&'a str, u16>,
}

#[derive(Clone)]
struct ClauseMutationProfile {
    field_index: u16,
    field: String,
    value: i64,
    comparison: PlanOp,
    weighted_correct: u64,
    weighted_false_positive: u64,
}

struct ClausePairMutationProfile {
    left: u8,
    right: u8,
    connector: PlanOp,
    weighted_correct: u64,
    weighted_false_positive: u64,
}

#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd)]
enum RelationalTransform {
    Direct,
    Add,
    Sub,
}

#[derive(Clone)]
struct RelationalMutationProfile {
    left: String,
    right: String,
    transform: RelationalTransform,
    value: i64,
    comparison: PlanOp,
    weighted_correct: u64,
    weighted_false_positive: u64,
}

type RelationalSemanticProfile = (Box<[u64]>, RelationalMutationProfile);

struct MutationEmitter<'a> {
    parent_hash: &'a str,
    source_target_class: Option<u32>,
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
            source_target_class: self.source_target_class,
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

struct MutationRequest<'a> {
    failure_shape: &'a FailureShape,
    strategy: EvolutionTargetStrategy,
    source_target_class: Option<u32>,
    cursor: usize,
}

struct PendingCandidate {
    plan: PlanSpec,
    parent_hash: Option<String>,
    source_hash: Option<String>,
    source_evidence: Option<String>,
    source_target_class: Option<u32>,
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

fn reset_changed_strategy_cursors(
    parents: &mut [ExpansionParent],
    previous: Option<&CompiledTargetProfile>,
    refreshed: &CompiledTargetProfile,
) -> usize {
    let mut resets = 0;
    for parent in parents {
        let previous = previous.map_or_else(EvolutionTargetStrategy::default, |profile| {
            profile.strategy(parent.niche.target_class)
        });
        if previous != refreshed.strategy(parent.niche.target_class) && parent.mutation_cursor != 0
        {
            parent.mutation_cursor = 0;
            resets += 1;
        }
    }
    resets
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
    target_class: Option<u32>,
}

impl SemanticNiche {
    fn new(
        operator: &'static str,
        false_positive: u64,
        false_negative: u64,
        semantic_op_rows: u64,
        target_class: Option<u32>,
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
            target_class,
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
    target_priority: u64,
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
            left.target_priority,
            1,
            left_quota,
            right.target_priority,
            1,
            right_quota,
        )
    })
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
    target_priorities: &[u64],
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
    if !selection_has_signal(parents, scorecards, target_priorities) {
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
                    target_priority: parent
                        .niche
                        .target_class
                        .and_then(|class| target_priorities.get(class as usize).copied())
                        .unwrap_or(0),
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
    target_priorities: &[u64],
) -> bool {
    parents.iter().any(|parent| {
        parent
            .niche
            .target_class
            .and_then(|class| target_priorities.get(class as usize))
            .is_some_and(|&priority| priority != 0)
            || scorecards
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
        PlanOp::Not | PlanOp::Abs | PlanOp::PopCount | PlanOp::Parity | PlanOp::Legendre { .. } => {
            1
        }
        PlanOp::Select => 3,
        PlanOp::Add
        | PlanOp::Sub
        | PlanOp::Mul
        | PlanOp::Mod
        | PlanOp::Div
        | PlanOp::Gcd
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
    let target_profile_valid = match (&header.target_profile_hash, &header.target_profile) {
        (None, None) | (Some(_), None) => true,
        (Some(expected_hash), Some(profile)) => {
            target_profile_hash(profile).is_ok_and(|hash| hash == *expected_hash)
        }
        (None, Some(_)) => false,
    };
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
        || !target_profile_valid
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
    if bounds.target_fields.len() > MAX_EVOLUTION_TARGET_FIELDS
        || bounds
            .target_fields
            .iter()
            .any(|&field| field >= batch.fields.len())
        || bounds
            .target_fields
            .iter()
            .copied()
            .collect::<BTreeSet<_>>()
            .len()
            != bounds.target_fields.len()
    {
        return Err(ControlError::Invalid(
            "evolution target fields are invalid".into(),
        ));
    }
    let target_classes = TargetClasses::compile(&batch, &bounds.target_fields)?;
    let target_fields = bounds
        .target_fields
        .iter()
        .map(|&field| batch.fields[field].as_str())
        .collect::<Vec<_>>();
    let mut target_profile = bounds
        .target_profile
        .as_ref()
        .map(|profile| target_classes.compile_profile(profile, &target_fields))
        .transpose()?;
    // SAFETY: setpriority has no pointer arguments; `who = 0` selects only the
    // calling Linux task. Failure is reported in the job summary.
    let low_priority = unsafe { libc::setpriority(libc::PRIO_PROCESS, 0, 10) } == 0;
    let scope_profiles = scope_profiles(&batch)?;
    let clause_profiles = clause_profiles(&batch)?;
    let clause_pair_profiles = clause_pair_profiles(&batch, &clause_profiles)?;
    let relational_profiles = relational_profiles(&batch)?;
    let field_index = batch
        .fields
        .iter()
        .enumerate()
        .map(|(index, name)| (name.as_str(), index as u16))
        .collect::<BTreeMap<_, _>>();
    let mutation_context = MutationContext {
        fields: &batch.fields,
        scope_profiles: &scope_profiles,
        clause_profiles: &clause_profiles,
        clause_pair_profiles: &clause_pair_profiles,
        relational_profiles: &relational_profiles,
        field_index: &field_index,
    };
    let mut writer = BufWriter::new(output);
    let mut evidence_header = EvolutionEvidenceHeader::from(&identity);
    evidence_header.target_fields = bounds
        .target_fields
        .iter()
        .map(|&field| batch.fields[field].clone())
        .collect();
    evidence_header.target_profile_hash =
        target_profile.as_ref().map(|profile| profile.hash.clone());
    evidence_header.target_profile = bounds.target_profile.clone();
    let mut header = serde_json::to_vec(&evidence_header)?;
    header.push(b'\n');
    if header.len() as u64 > bounds.byte_limit {
        return Err(ControlError::Invalid(
            "evolution evidence limit cannot hold its identity header".into(),
        ));
    }
    let header_bytes = header.len() as u64;
    let footer_reserve = target_classes.footer_reserve(bounds.target_fields.len());
    let candidate_byte_limit = bounds
        .byte_limit
        .checked_sub(footer_reserve)
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
    let mut target_selection_slots = BTreeMap::<u32, u64>::new();
    let mut target_selection_overflow = 0_u64;
    let mut target_profile_surplus_slots = 0_u64;
    let mut target_profile_refreshes = 0_u64;
    let mut target_strategy_parents = BTreeMap::<&'static str, u64>::new();
    let mut target_strategy_cursor_resets = 0_u64;
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
            source_target_class: None,
            operator: seed.operator,
        })
        .collect::<Vec<_>>();

    'generations: for generation in 0..bounds.generations {
        if tested == bounds.max_candidates || progress.cancelled.load(Ordering::Acquire) {
            break;
        }
        progress
            .generation
            .store(generation as u64, Ordering::Relaxed);
        let refreshed_profile = bounds
            .target_profile_mailbox
            .lock()
            .map_err(|_| ControlError::Invalid("target profile mailbox is poisoned".into()))?
            .take();
        if let Some(profile) = refreshed_profile {
            let compiled = target_classes.compile_profile(&profile, &target_fields)?;
            let record = json!({
                "type": "target-profile-refresh",
                "generation": generation,
                "target_profile_hash": &compiled.hash,
                "target_profile": profile,
            });
            let mut encoded = serde_json::to_vec(&record)?;
            encoded.push(b'\n');
            if encoded.len() > MAX_EVOLUTION_RECORD_BYTES
                || bytes.saturating_add(encoded.len() as u64) > candidate_byte_limit
            {
                truncated = true;
                break 'generations;
            }
            writer.write_all(&encoded)?;
            bytes += encoded.len() as u64;
            let resets = reset_changed_strategy_cursors(
                &mut retained_elites,
                target_profile.as_ref(),
                &compiled,
            );
            checked_counter_add(
                &mut target_strategy_cursor_resets,
                u64::try_from(resets).map_err(|_| {
                    ControlError::Invalid("target strategy reset count overflows u64".into())
                })?,
                "target strategy cursor reset",
            )?;
            target_profile = Some(compiled);
            checked_counter_add(&mut target_profile_refreshes, 1, "target profile refresh")?;
        }
        let target_priorities = target_profile
            .as_ref()
            .map_or(&[][..], |profile| profile.class_priorities.as_ref());
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
            let source_target_values = pending
                .source_target_class
                .map(|class| target_classes.values(class));
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
                    "source_target_values": source_target_values,
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
            let target_class = evaluation
                .first_mismatch
                .and_then(|row| target_classes.class(row));
            let target_values = target_class.map(|class| target_classes.values(class));
            let niche = SemanticNiche::new(
                pending.operator,
                evaluation.weighted_false_positive,
                evaluation.weighted_false_negative,
                semantic_op_rows,
                target_class,
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
                "source_target_values": source_target_values,
                "operator": pending.operator,
                "semantic_niche": niche,
                "target_values": target_values,
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
            let Some(class) = parent.niche.target_class else {
                continue;
            };
            if let Some(count) = target_selection_slots.get_mut(&class) {
                checked_counter_add(count, 1, "target selection slot")?;
            } else if target_selection_slots.len() < 64 {
                target_selection_slots.insert(class, 1);
            } else {
                checked_counter_add(
                    &mut target_selection_overflow,
                    1,
                    "target selection overflow",
                )?;
            }
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
        let guided_selection =
            selection_has_signal(&parents, &operator_scorecards, target_priorities);
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
        let quotas = maximum_oriented_quotas(
            &parents,
            expansion_capacity,
            &operator_scorecards,
            target_priorities,
        );
        for (parent, &quota) in parents.iter().zip(&quotas) {
            let profiled = parent
                .niche
                .target_class
                .and_then(|class| target_priorities.get(class as usize))
                .is_some_and(|&priority| priority != 0);
            if profiled {
                checked_counter_add(
                    &mut target_profile_surplus_slots,
                    quota.saturating_sub(1) as u64,
                    "target profile surplus slot",
                )?;
            }
        }
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
            let strategy = target_profile
                .as_ref()
                .map_or_else(EvolutionTargetStrategy::default, |profile| {
                    profile.strategy(parent.niche.target_class)
                });
            checked_counter_add(
                target_strategy_parents
                    .entry(strategy.as_str())
                    .or_default(),
                1,
                "target strategy parent",
            )?;
            let mutation = mutate_plan(
                &parent.plan,
                &parent.hash,
                &mutation_context,
                MutationRequest {
                    failure_shape: &failure_shape,
                    strategy,
                    source_target_class: parent.niche.target_class,
                    cursor: parent.mutation_cursor,
                },
                &mut current,
                limit,
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
    let target_field = (target_fields.len() == 1).then(|| target_fields[0]);
    let target_selection_classes = target_selection_slots
        .iter()
        .map(|(&class, &slots)| {
            json!({
                "class": class,
                "values": target_classes.values(class),
                "slots": slots,
            })
        })
        .collect::<Vec<_>>();
    let target_selection_values = if target_fields.len() == 1 {
        target_selection_slots
            .iter()
            .map(|(&class, &slots)| (target_classes.values(class)[0], slots))
            .collect::<BTreeMap<_, _>>()
    } else {
        BTreeMap::new()
    };
    let target_profile_summary = json!({
        "hash": target_profile.as_ref().map(|profile| profile.hash.as_str()),
        "nodes": target_profile.as_ref().map_or(0, |profile| profile.nodes),
        "edges": target_profile.as_ref().map_or(0, |profile| profile.edges),
        "surplus_slots": target_profile_surplus_slots,
        "refreshes": target_profile_refreshes,
        "strategy_parents": target_strategy_parents,
        "strategy_cursor_resets": target_strategy_cursor_resets,
    });
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
        "target_field": target_field,
        "target_fields": &target_fields,
        "target_selection_slots": &target_selection_values,
        "target_selection_classes": &target_selection_classes,
        "target_selection_overflow": target_selection_overflow,
        "target_profile": &target_profile_summary,
        "clause_profiles": clause_profiles.len(),
        "clause_pair_profiles": clause_pair_profiles.len(),
        "relational_profiles": relational_profiles.len(),
        "clause_profile_rows": batch.rows().min(MAX_CLAUSE_PROFILE_ROWS),
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
    if footer.len() as u64 > footer_reserve {
        return Err(ControlError::Invalid(
            "evolution summary exceeds its reserved evidence bound".into(),
        ));
    }
    writer.write_all(&footer)?;
    bytes = candidate_bytes + footer.len() as u64;
    writer.flush()?;
    progress.done.store(true, Ordering::Release);
    footer_summary["bytes"] = Value::from(bytes);
    footer_summary["best"] = best
        .map(|(correct, false_positive, complexity, plan)| {
            json!({
            "weighted_correct": correct,
            "false_positive": false_positive,
            "complexity": complexity,
            "plan": plan,
            })
        })
        .unwrap_or(Value::Null);
    Ok(footer_summary)
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

fn clause_profile_cmp(
    left: &ClauseMutationProfile,
    right: &ClauseMutationProfile,
) -> std::cmp::Ordering {
    right
        .weighted_correct
        .cmp(&left.weighted_correct)
        .then_with(|| {
            left.weighted_false_positive
                .cmp(&right.weighted_false_positive)
        })
        .then_with(|| left.field.cmp(&right.field))
        .then_with(|| left.value.cmp(&right.value))
        .then_with(|| {
            clause_comparison_rank(&left.comparison).cmp(&clause_comparison_rank(&right.comparison))
        })
}

fn clause_comparison_rank(comparison: &PlanOp) -> u8 {
    match comparison {
        PlanOp::Eq => 0,
        PlanOp::Ne => 1,
        PlanOp::Gt => 2,
        _ => unreachable!(),
    }
}

fn clause_prediction(comparison: &PlanOp, observed: i64, value: i64) -> bool {
    match comparison {
        PlanOp::Eq => observed == value,
        PlanOp::Ne => observed != value,
        PlanOp::Gt => observed > value,
        _ => unreachable!(),
    }
}

fn same_clause_comparison(left: &PlanOp, right: &PlanOp) -> bool {
    matches!(
        (left, right),
        (PlanOp::Eq, PlanOp::Eq) | (PlanOp::Ne, PlanOp::Ne) | (PlanOp::Gt, PlanOp::Gt)
    )
}

fn clause_profile_rows(rows: usize) -> impl Iterator<Item = usize> {
    let sampled = rows.min(MAX_CLAUSE_PROFILE_ROWS);
    (0..sampled)
        .map(move |sample| ((sample as u128 * rows as u128) / sampled.max(1) as u128) as usize)
}

fn clause_profile_values(batch: &FeatureBatch, field: usize) -> Result<Vec<i64>, ControlError> {
    let mut heavy = Vec::<(i64, u64)>::with_capacity(MAX_CLAUSE_PROFILE_VALUES - 2);
    let mut minimum = i64::MAX;
    let mut maximum = i64::MIN;
    for row in clause_profile_rows(batch.rows()) {
        let value = batch.row(row)[field];
        minimum = minimum.min(value);
        maximum = maximum.max(value);
        let weight = batch.weights[row];
        if let Some((_, count)) = heavy.iter_mut().find(|(candidate, _)| *candidate == value) {
            *count = count
                .checked_add(weight)
                .ok_or_else(|| ControlError::Invalid("clause value weight overflow".into()))?;
        } else if heavy.len() < MAX_CLAUSE_PROFILE_VALUES - 2 {
            heavy.push((value, weight));
        } else {
            let replace = heavy
                .iter()
                .enumerate()
                .min_by_key(|(_, (candidate, count))| (*count, *candidate))
                .map(|(index, _)| index)
                .unwrap();
            heavy[replace] = (
                value,
                heavy[replace]
                    .1
                    .checked_add(weight)
                    .ok_or_else(|| ControlError::Invalid("clause value weight overflow".into()))?,
            );
        }
    }
    let mut values = heavy
        .into_iter()
        .map(|(value, _)| value)
        .collect::<Vec<_>>();
    if minimum != i64::MAX {
        values.push(minimum);
        values.push(maximum);
    }
    values.sort_unstable();
    values.dedup();
    Ok(values)
}

fn clause_profiles(batch: &FeatureBatch) -> Result<Vec<ClauseMutationProfile>, ControlError> {
    let sampled = batch.rows().min(MAX_CLAUSE_PROFILE_ROWS);
    if sampled == 0 {
        return Ok(Vec::new());
    }
    let words = sampled.div_ceil(64);
    let mut semantics = BTreeMap::<Box<[u64]>, ClauseMutationProfile>::new();
    for (field, field_name) in batch
        .fields
        .iter()
        .take(MAX_CLAUSE_PROFILE_FIELDS)
        .enumerate()
    {
        for value in clause_profile_values(batch, field)? {
            for comparison in [PlanOp::Eq, PlanOp::Ne, PlanOp::Gt] {
                let mut outcomes = vec![0_u64; words];
                let mut true_rows = 0_usize;
                let mut weighted_correct = 0_u64;
                let mut weighted_false_positive = 0_u64;
                for (sample, row) in clause_profile_rows(batch.rows()).enumerate() {
                    let prediction = clause_prediction(&comparison, batch.row(row)[field], value);
                    if prediction {
                        outcomes[sample / 64] |= 1_u64 << (sample % 64);
                        true_rows += 1;
                    }
                    let weight = batch.weights[row];
                    if prediction == batch.expected(row) {
                        weighted_correct =
                            weighted_correct.checked_add(weight).ok_or_else(|| {
                                ControlError::Invalid("clause profile score overflow".into())
                            })?;
                    }
                    if prediction && !batch.expected(row) {
                        weighted_false_positive =
                            weighted_false_positive.checked_add(weight).ok_or_else(|| {
                                ControlError::Invalid("clause false-positive overflow".into())
                            })?;
                    }
                }
                if true_rows == 0 || true_rows == sampled {
                    continue;
                }
                let profile = ClauseMutationProfile {
                    field_index: u16::try_from(field).map_err(|_| {
                        ControlError::Invalid("clause field index exceeds u16".into())
                    })?,
                    field: field_name.clone(),
                    value,
                    comparison,
                    weighted_correct,
                    weighted_false_positive,
                };
                match semantics.entry(outcomes.into_boxed_slice()) {
                    std::collections::btree_map::Entry::Vacant(entry) => {
                        entry.insert(profile);
                    }
                    std::collections::btree_map::Entry::Occupied(mut entry) => {
                        if clause_profile_cmp(&profile, entry.get()).is_lt() {
                            entry.insert(profile);
                        }
                    }
                }
            }
        }
    }
    let mut profiles = semantics.into_values().collect::<Vec<_>>();
    profiles.sort_by(clause_profile_cmp);
    profiles.truncate(MAX_CLAUSE_PROFILES);
    Ok(profiles)
}

fn relational_profile_cmp(
    left: &RelationalMutationProfile,
    right: &RelationalMutationProfile,
) -> std::cmp::Ordering {
    right
        .weighted_correct
        .cmp(&left.weighted_correct)
        .then_with(|| {
            left.weighted_false_positive
                .cmp(&right.weighted_false_positive)
        })
        .then_with(|| left.transform.cmp(&right.transform))
        .then_with(|| left.left.cmp(&right.left))
        .then_with(|| left.right.cmp(&right.right))
        .then_with(|| left.value.cmp(&right.value))
        .then_with(|| {
            clause_comparison_rank(&left.comparison).cmp(&clause_comparison_rank(&right.comparison))
        })
}

fn relational_value(transform: RelationalTransform, left: i64, right: i64) -> Option<i64> {
    match transform {
        RelationalTransform::Direct => unreachable!(),
        RelationalTransform::Add => left.checked_add(right),
        RelationalTransform::Sub => left.checked_sub(right),
    }
}

fn relational_profile_values(
    batch: &FeatureBatch,
    left: usize,
    right: usize,
    transform: RelationalTransform,
) -> Result<Option<Vec<i64>>, ControlError> {
    let mut counts = BTreeMap::<i64, u64>::new();
    let mut minimum = i64::MAX;
    let mut maximum = i64::MIN;
    for row in clause_profile_rows(batch.rows()) {
        let values = batch.row(row);
        let Some(value) = relational_value(transform, values[left], values[right]) else {
            return Ok(None);
        };
        minimum = minimum.min(value);
        maximum = maximum.max(value);
        let entry = counts.entry(value).or_default();
        *entry = entry
            .checked_add(batch.weights[row])
            .ok_or_else(|| ControlError::Invalid("relational value weight overflow".into()))?;
    }
    let mut ranked = counts.into_iter().collect::<Vec<_>>();
    ranked.sort_unstable_by(|(left_value, left_weight), (right_value, right_weight)| {
        right_weight
            .cmp(left_weight)
            .then_with(|| left_value.cmp(right_value))
    });
    ranked.truncate(MAX_RELATIONAL_PROFILE_VALUES.saturating_sub(2));
    let mut values = ranked
        .into_iter()
        .map(|(value, _)| value)
        .collect::<Vec<_>>();
    if minimum != i64::MAX {
        values.push(minimum);
        values.push(maximum);
    }
    values.sort_unstable();
    values.dedup();
    Ok(Some(values))
}

fn relational_profile(
    batch: &FeatureBatch,
    left: usize,
    right: usize,
    transform: RelationalTransform,
    value: i64,
    comparison: PlanOp,
) -> Result<Option<RelationalSemanticProfile>, ControlError> {
    let sampled = batch.rows().min(MAX_CLAUSE_PROFILE_ROWS);
    let mut outcomes = vec![0_u64; sampled.div_ceil(64)];
    let mut true_rows = 0_usize;
    let mut weighted_correct = 0_u64;
    let mut weighted_false_positive = 0_u64;
    for (sample, row) in clause_profile_rows(batch.rows()).enumerate() {
        let fields = batch.row(row);
        let prediction = if transform == RelationalTransform::Direct {
            clause_prediction(&comparison, fields[left], fields[right])
        } else {
            let Some(observed) = relational_value(transform, fields[left], fields[right]) else {
                return Ok(None);
            };
            clause_prediction(&comparison, observed, value)
        };
        if prediction {
            outcomes[sample / 64] |= 1_u64 << (sample % 64);
            true_rows += 1;
        }
        let weight = batch.weights[row];
        if prediction == batch.expected(row) {
            weighted_correct = weighted_correct
                .checked_add(weight)
                .ok_or_else(|| ControlError::Invalid("relational score overflow".into()))?;
        }
        if prediction && !batch.expected(row) {
            weighted_false_positive =
                weighted_false_positive.checked_add(weight).ok_or_else(|| {
                    ControlError::Invalid("relational false-positive overflow".into())
                })?;
        }
    }
    if true_rows == 0 || true_rows == sampled {
        return Ok(None);
    }
    Ok(Some((
        outcomes.into_boxed_slice(),
        RelationalMutationProfile {
            left: batch.fields[left].clone(),
            right: batch.fields[right].clone(),
            transform,
            value,
            comparison,
            weighted_correct,
            weighted_false_positive,
        },
    )))
}

fn relational_profiles(
    batch: &FeatureBatch,
) -> Result<Vec<RelationalMutationProfile>, ControlError> {
    let sampled = batch.rows().min(MAX_CLAUSE_PROFILE_ROWS);
    let fields = batch.fields.len().min(MAX_RELATIONAL_PROFILE_FIELDS);
    if sampled == 0 || fields < 2 {
        return Ok(Vec::new());
    }
    let mut semantics = BTreeMap::<Box<[u64]>, RelationalMutationProfile>::new();
    let mut retain = |profile: Option<(Box<[u64]>, RelationalMutationProfile)>| {
        let Some((outcomes, profile)) = profile else {
            return;
        };
        match semantics.entry(outcomes) {
            std::collections::btree_map::Entry::Vacant(entry) => {
                entry.insert(profile);
            }
            std::collections::btree_map::Entry::Occupied(mut entry) => {
                if relational_profile_cmp(&profile, entry.get()).is_lt() {
                    entry.insert(profile);
                }
            }
        }
    };
    for left in 0..fields {
        for right in left + 1..fields {
            for comparison in [PlanOp::Eq, PlanOp::Ne, PlanOp::Gt] {
                retain(relational_profile(
                    batch,
                    left,
                    right,
                    RelationalTransform::Direct,
                    0,
                    comparison,
                )?);
            }
            retain(relational_profile(
                batch,
                right,
                left,
                RelationalTransform::Direct,
                0,
                PlanOp::Gt,
            )?);
            for (lhs, rhs, transform) in [
                (left, right, RelationalTransform::Add),
                (left, right, RelationalTransform::Sub),
                (right, left, RelationalTransform::Sub),
            ] {
                let Some(values) = relational_profile_values(batch, lhs, rhs, transform)? else {
                    continue;
                };
                for value in values {
                    for comparison in [PlanOp::Eq, PlanOp::Ne, PlanOp::Gt] {
                        retain(relational_profile(
                            batch, lhs, rhs, transform, value, comparison,
                        )?);
                    }
                }
            }
        }
    }
    let mut profiles = semantics.into_values().collect::<Vec<_>>();
    profiles.sort_by(relational_profile_cmp);
    profiles.truncate(MAX_RELATIONAL_PROFILES);
    Ok(profiles)
}

fn clause_pair_profile_cmp(
    left: &ClausePairMutationProfile,
    right: &ClausePairMutationProfile,
) -> std::cmp::Ordering {
    right
        .weighted_correct
        .cmp(&left.weighted_correct)
        .then_with(|| {
            left.weighted_false_positive
                .cmp(&right.weighted_false_positive)
        })
        .then_with(|| left.left.cmp(&right.left))
        .then_with(|| left.right.cmp(&right.right))
        .then_with(|| {
            let rank = |connector: &PlanOp| u8::from(matches!(connector, PlanOp::Or));
            rank(&left.connector).cmp(&rank(&right.connector))
        })
}

fn clause_pair_profiles(
    batch: &FeatureBatch,
    clauses: &[ClauseMutationProfile],
) -> Result<Vec<ClausePairMutationProfile>, ControlError> {
    let sampled = batch.rows().min(MAX_CLAUSE_PROFILE_ROWS);
    if sampled == 0 {
        return Ok(Vec::new());
    }
    let words = sampled.div_ceil(64);
    let mut semantics = BTreeMap::<Box<[u64]>, ClausePairMutationProfile>::new();
    for left in 0..clauses.len() {
        for right in left + 1..clauses.len() {
            for connector in [PlanOp::And, PlanOp::Or] {
                let mut outcomes = vec![0_u64; words];
                let mut true_rows = 0_usize;
                let mut weighted_correct = 0_u64;
                let mut weighted_false_positive = 0_u64;
                for (sample, row) in clause_profile_rows(batch.rows()).enumerate() {
                    let left_clause = &clauses[left];
                    let right_clause = &clauses[right];
                    let left_prediction = clause_prediction(
                        &left_clause.comparison,
                        batch.row(row)[usize::from(left_clause.field_index)],
                        left_clause.value,
                    );
                    let right_prediction = clause_prediction(
                        &right_clause.comparison,
                        batch.row(row)[usize::from(right_clause.field_index)],
                        right_clause.value,
                    );
                    let prediction = if matches!(connector, PlanOp::And) {
                        left_prediction && right_prediction
                    } else {
                        left_prediction || right_prediction
                    };
                    if prediction {
                        outcomes[sample / 64] |= 1_u64 << (sample % 64);
                        true_rows += 1;
                    }
                    let weight = batch.weights[row];
                    if prediction == batch.expected(row) {
                        weighted_correct =
                            weighted_correct.checked_add(weight).ok_or_else(|| {
                                ControlError::Invalid("clause-pair score overflow".into())
                            })?;
                    }
                    if prediction && !batch.expected(row) {
                        weighted_false_positive =
                            weighted_false_positive.checked_add(weight).ok_or_else(|| {
                                ControlError::Invalid("clause-pair false-positive overflow".into())
                            })?;
                    }
                }
                if true_rows == 0 || true_rows == sampled {
                    continue;
                }
                let profile = ClausePairMutationProfile {
                    left: u8::try_from(left).map_err(|_| {
                        ControlError::Invalid("left clause index exceeds u8".into())
                    })?,
                    right: u8::try_from(right).map_err(|_| {
                        ControlError::Invalid("right clause index exceeds u8".into())
                    })?,
                    connector,
                    weighted_correct,
                    weighted_false_positive,
                };
                match semantics.entry(outcomes.into_boxed_slice()) {
                    std::collections::btree_map::Entry::Vacant(entry) => {
                        entry.insert(profile);
                    }
                    std::collections::btree_map::Entry::Occupied(mut entry) => {
                        if clause_pair_profile_cmp(&profile, entry.get()).is_lt() {
                            entry.insert(profile);
                        }
                    }
                }
            }
        }
    }
    let mut profiles = semantics.into_values().collect::<Vec<_>>();
    profiles.sort_by(clause_pair_profile_cmp);
    profiles.truncate(MAX_CLAUSE_PAIR_PROFILES);
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

#[derive(Clone, Copy, Eq, PartialEq)]
enum MutationFamily {
    Numeric,
    Structural,
}

fn mutate_scopes(
    parent: &PlanSpec,
    context: &MutationContext<'_>,
    emitter: &mut MutationEmitter<'_>,
) -> bool {
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
                    emitter,
                ) {
                    return true;
                }
            }
        } else {
            let mut bits = profile.observed_mask;
            while bits != 0 {
                let bit = bits & bits.wrapping_neg();
                bits ^= bit;
                if push_scoped_child(parent, &profile.field, bit, "scope-initialize", emitter) {
                    return true;
                }
            }
            if profile.positive_majority_mask != profile.observed_mask
                && push_scoped_child(
                    parent,
                    &profile.field,
                    profile.positive_majority_mask,
                    "scope-majority",
                    emitter,
                )
            {
                return true;
            }
        }
    }
    false
}

fn plan_has_clause(parent: &PlanSpec, profile: &ClauseMutationProfile, connector: &PlanOp) -> bool {
    parent.program.windows(4).any(|ops| {
        matches!(&ops[0], PlanOp::Field { name } if name == &profile.field)
            && matches!(ops[1], PlanOp::Const { value } if value == profile.value)
            && same_clause_comparison(&ops[2], &profile.comparison)
            && matches!(
                (&ops[3], connector),
                (PlanOp::And, PlanOp::And) | (PlanOp::Or, PlanOp::Or)
            )
    })
}

fn mutate_clauses(
    parent: &PlanSpec,
    context: &MutationContext<'_>,
    emitter: &mut MutationEmitter<'_>,
) -> bool {
    if parent.program.len().saturating_add(4) > MAX_PLAN_OPS {
        return false;
    }
    for profile in context.clause_profiles {
        for (connector, operator) in [(PlanOp::And, "clause-and"), (PlanOp::Or, "clause-or")] {
            if plan_has_clause(parent, profile, &connector) {
                continue;
            }
            if emitter.emit(operator, || {
                let mut child = parent.clone();
                child.program.push(PlanOp::Field {
                    name: profile.field.clone(),
                });
                child.program.push(PlanOp::Const {
                    value: profile.value,
                });
                child.program.push(profile.comparison.clone());
                child.program.push(connector);
                child
            }) {
                return true;
            }
        }
    }
    false
}

fn relational_program(profile: &RelationalMutationProfile) -> Vec<PlanOp> {
    let mut program = vec![
        PlanOp::Field {
            name: profile.left.clone(),
        },
        PlanOp::Field {
            name: profile.right.clone(),
        },
    ];
    match profile.transform {
        RelationalTransform::Direct => {}
        RelationalTransform::Add => {
            program.push(PlanOp::Add);
            program.push(PlanOp::Const {
                value: profile.value,
            });
        }
        RelationalTransform::Sub => {
            program.push(PlanOp::Sub);
            program.push(PlanOp::Const {
                value: profile.value,
            });
        }
    }
    program.push(profile.comparison.clone());
    program
}

fn mutate_relations(
    parent: &PlanSpec,
    context: &MutationContext<'_>,
    emitter: &mut MutationEmitter<'_>,
) -> bool {
    for profile in context.relational_profiles {
        let relation = relational_program(profile);
        if emitter.emit("relation", || {
            let mut child = parent.clone();
            child.scope = None;
            child.program = relation.clone();
            child
        }) {
            return true;
        }
        if parent.program.len().saturating_add(relation.len() + 1) > MAX_PLAN_OPS {
            continue;
        }
        for (connector, operator) in [(PlanOp::And, "relation-and"), (PlanOp::Or, "relation-or")] {
            if emitter.emit(operator, || {
                let mut child = parent.clone();
                child.program.extend(relation.iter().cloned());
                child.program.push(connector);
                child
            }) {
                return true;
            }
        }
    }
    false
}

fn mutate_clause_pairs(
    parent: &PlanSpec,
    context: &MutationContext<'_>,
    emitter: &mut MutationEmitter<'_>,
) -> bool {
    for pair in context.clause_pair_profiles {
        let left = &context.clause_profiles[usize::from(pair.left)];
        let right = &context.clause_profiles[usize::from(pair.right)];
        let same_program = parent.scope.is_none()
            && matches!(parent.program.as_slice(), [
                PlanOp::Field { name: left_name },
                PlanOp::Const { value: left_value },
                left_comparison,
                PlanOp::Field { name: right_name },
                PlanOp::Const { value: right_value },
                right_comparison,
                connector,
            ] if left_name == &left.field
                && *left_value == left.value
                && same_clause_comparison(left_comparison, &left.comparison)
                && right_name == &right.field
                && *right_value == right.value
                && same_clause_comparison(right_comparison, &right.comparison)
                && matches!((connector, &pair.connector),
                    (PlanOp::And, PlanOp::And) | (PlanOp::Or, PlanOp::Or)));
        if same_program {
            continue;
        }
        let program = vec![
            PlanOp::Field {
                name: left.field.clone(),
            },
            PlanOp::Const { value: left.value },
            left.comparison.clone(),
            PlanOp::Field {
                name: right.field.clone(),
            },
            PlanOp::Const { value: right.value },
            right.comparison.clone(),
            pair.connector.clone(),
        ];
        if emitter.emit("clause-pair", || {
            let mut child = parent.clone();
            child.scope = None;
            child.program = program;
            child
        }) {
            return true;
        }
    }
    false
}

fn mutate_program(
    parent: &PlanSpec,
    context: &MutationContext<'_>,
    family_filter: Option<MutationFamily>,
    emitter: &mut MutationEmitter<'_>,
) -> bool {
    for (index, op) in parent.program.iter().enumerate() {
        let family = match op {
            PlanOp::Const { .. }
            | PlanOp::Eq
            | PlanOp::Ne
            | PlanOp::Lt
            | PlanOp::Le
            | PlanOp::Gt
            | PlanOp::Ge => MutationFamily::Numeric,
            PlanOp::Field { .. } | PlanOp::And | PlanOp::Or => MutationFamily::Structural,
            _ => continue,
        };
        if family_filter.is_some_and(|filter| filter != family) {
            continue;
        }
        match op {
            PlanOp::Const { value } => {
                for delta in [-8, -2, -1, 1, 2, 8] {
                    let Some(value) = value.checked_add(delta) else {
                        continue;
                    };
                    if emitter.emit("constant-shift", || {
                        let mut child = parent.clone();
                        child.program[index] = PlanOp::Const { value };
                        child
                    }) {
                        return true;
                    }
                }
            }
            PlanOp::Field { name } => {
                for replacement in context.fields.iter().filter(|field| *field != name) {
                    if emitter.emit("field-substitute", || {
                        let mut child = parent.clone();
                        child.program[index] = PlanOp::Field {
                            name: replacement.clone(),
                        };
                        child
                    }) {
                        return true;
                    }
                }
            }
            PlanOp::Eq | PlanOp::Ne | PlanOp::Lt | PlanOp::Le | PlanOp::Gt | PlanOp::Ge => {
                for replacement in [
                    PlanOp::Eq,
                    PlanOp::Ne,
                    PlanOp::Lt,
                    PlanOp::Le,
                    PlanOp::Gt,
                    PlanOp::Ge,
                ] {
                    if emitter.emit("comparison-substitute", || {
                        let mut child = parent.clone();
                        child.program[index] = replacement;
                        child
                    }) {
                        return true;
                    }
                }
            }
            PlanOp::And | PlanOp::Or => {
                let replacement = if matches!(op, PlanOp::And) {
                    PlanOp::Or
                } else {
                    PlanOp::And
                };
                if emitter.emit("boolean-flip", || {
                    let mut child = parent.clone();
                    child.program[index] = replacement;
                    child
                }) {
                    return true;
                }
            }
            _ => unreachable!(),
        }
    }
    false
}

fn mutate_plan(
    parent: &PlanSpec,
    parent_hash: &str,
    context: &MutationContext<'_>,
    request: MutationRequest<'_>,
    output: &mut Vec<PendingCandidate>,
    limit: usize,
) -> MutationBatch {
    let mut emitter = MutationEmitter {
        parent_hash,
        source_target_class: request.source_target_class,
        output,
        limit,
        cursor: request.cursor,
        ordinal: 0,
    };
    let stopped = mutate_thresholds_from_failure(
        parent,
        context.field_index,
        request.failure_shape,
        &mut emitter,
    ) || match request.strategy {
        EvolutionTargetStrategy::Balanced => {
            mutate_scopes(parent, context, &mut emitter)
                || mutate_program(parent, context, None, &mut emitter)
                || mutate_relations(parent, context, &mut emitter)
                || mutate_clause_pairs(parent, context, &mut emitter)
                || mutate_clauses(parent, context, &mut emitter)
        }
        EvolutionTargetStrategy::Numeric => {
            mutate_program(parent, context, Some(MutationFamily::Numeric), &mut emitter)
                || mutate_relations(parent, context, &mut emitter)
                || mutate_scopes(parent, context, &mut emitter)
                || mutate_program(
                    parent,
                    context,
                    Some(MutationFamily::Structural),
                    &mut emitter,
                )
                || mutate_clause_pairs(parent, context, &mut emitter)
                || mutate_clauses(parent, context, &mut emitter)
        }
        EvolutionTargetStrategy::Structural => {
            mutate_scopes(parent, context, &mut emitter)
                || mutate_relations(parent, context, &mut emitter)
                || mutate_clause_pairs(parent, context, &mut emitter)
                || mutate_clauses(parent, context, &mut emitter)
                || mutate_program(
                    parent,
                    context,
                    Some(MutationFamily::Structural),
                    &mut emitter,
                )
                || mutate_program(parent, context, Some(MutationFamily::Numeric), &mut emitter)
        }
    };
    MutationBatch {
        next_cursor: emitter.ordinal,
        exhausted: !stopped,
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
            niche: SemanticNiche::new(operator, 0, 1, 8, None),
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
            niche: SemanticNiche::new(operator, false_positive, false_negative, cost, None),
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

        let mut target_zero = niche_candidate("target-zero", 10, "scope", Some(true), 8);
        target_zero.niche.target_class = Some(0);
        let mut target_one = niche_candidate("target-one", 100, "scope", Some(true), 8);
        target_one.niche.target_class = Some(1);
        let selection = select_semantic_elites(vec![target_zero, target_one], &[], 2, 2);
        assert_eq!(selection.niche_slots, 2);
        assert_eq!(selection.global_slots, 0);
        assert_eq!(selection.parents[0].hash, "target-one");
        assert_eq!(selection.parents[1].hash, "target-zero");

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
    fn target_classes_intern_exact_multi_field_tuples() {
        let batch = FeatureBatch {
            presentation: "targets".into(),
            problem: "classes".into(),
            fields: vec!["root".into(), "debt".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0, 1, 2].into_boxed_slice(),
            weights: vec![1, 1, 1].into_boxed_slice(),
            expected: vec![0].into_boxed_slice(),
            values: vec![1, 2, 1, 2, 1, 3].into_boxed_slice(),
        };
        let classes = TargetClasses::compile(&batch, &[0, 1]).unwrap();
        assert_eq!(classes.row_classes.as_ref(), &[0, 0, 1]);
        assert_eq!(classes.values(0), &[1, 2]);
        assert_eq!(classes.values(1), &[1, 3]);

        let disabled = TargetClasses::compile(&batch, &[]).unwrap();
        assert_eq!(disabled.class(0), None);
        assert!(disabled.keys.is_empty());
    }

    #[test]
    fn target_profile_closure_guides_surplus_without_starvation() {
        let batch = FeatureBatch {
            presentation: "targets".into(),
            problem: "profile".into(),
            fields: vec!["root".into(), "debt".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0, 1].into_boxed_slice(),
            weights: vec![1, 1].into_boxed_slice(),
            expected: vec![0].into_boxed_slice(),
            values: vec![1, 2, 1, 3].into_boxed_slice(),
        };
        let classes = TargetClasses::compile(&batch, &[0, 1]).unwrap();
        let profile = EvolutionTargetProfile {
            schema: EVOLUTION_TARGET_PROFILE_SCHEMA.into(),
            fields: vec!["root".into(), "debt".into()].into_boxed_slice(),
            nodes: vec![
                EvolutionTargetNode {
                    values: vec![1, 2].into_boxed_slice(),
                    mass: 2,
                    unit_cost: 1,
                    strategy: EvolutionTargetStrategy::Numeric,
                },
                EvolutionTargetNode {
                    values: vec![1, 3].into_boxed_slice(),
                    mass: 5,
                    unit_cost: 2,
                    strategy: EvolutionTargetStrategy::Structural,
                },
            ]
            .into_boxed_slice(),
            edges: vec![EvolutionTargetEdge {
                from: 0,
                to: 1,
                kind: EvolutionTargetEdgeKind::Continuation,
            }]
            .into_boxed_slice(),
        };
        let compiled = classes
            .compile_profile(&profile, &["root", "debt"])
            .unwrap();
        assert_eq!(compiled.class_priorities.as_ref(), &[12, 10]);
        assert_eq!(
            compiled.class_strategies.as_ref(),
            &[
                EvolutionTargetStrategy::Numeric,
                EvolutionTargetStrategy::Structural,
            ]
        );
        let mut duplicate_edge = profile.clone();
        duplicate_edge.edges = vec![profile.edges[0], profile.edges[0]].into_boxed_slice();
        assert!(classes
            .compile_profile(&duplicate_edge, &["root", "debt"])
            .is_err());
        let mut cycle = profile.clone();
        cycle.edges = vec![
            profile.edges[0],
            EvolutionTargetEdge {
                from: 1,
                to: 0,
                kind: EvolutionTargetEdgeKind::Dependency,
            },
        ]
        .into_boxed_slice();
        let cycle = classes.compile_profile(&cycle, &["root", "debt"]).unwrap();
        assert_eq!(cycle.class_priorities.as_ref(), &[12, 12]);

        let mut low = selector_parent("low", "scope");
        low.niche.target_class = Some(0);
        let mut high = selector_parent("high", "scope");
        high.niche.target_class = Some(1);
        let quotas = maximum_oriented_quotas(&[low, high], 10, &BTreeMap::new(), &[1, 100]);
        assert_eq!(quotas, [1, 9]);
    }

    #[test]
    fn target_profile_rejects_absent_nodes_and_bad_edges() {
        let batch = FeatureBatch {
            presentation: "targets".into(),
            problem: "hostile-profile".into(),
            fields: vec!["root".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0].into_boxed_slice(),
            weights: vec![1].into_boxed_slice(),
            expected: vec![0].into_boxed_slice(),
            values: vec![1].into_boxed_slice(),
        };
        let classes = TargetClasses::compile(&batch, &[0]).unwrap();
        let mut profile = EvolutionTargetProfile {
            schema: EVOLUTION_TARGET_PROFILE_SCHEMA.into(),
            fields: vec!["root".into()].into_boxed_slice(),
            nodes: vec![EvolutionTargetNode {
                values: vec![2].into_boxed_slice(),
                mass: 1,
                unit_cost: 1,
                strategy: EvolutionTargetStrategy::Balanced,
            }]
            .into_boxed_slice(),
            edges: Box::new([]),
        };
        assert!(!serde_json::to_string(&profile)
            .unwrap()
            .contains("strategy"));
        assert!(classes.compile_profile(&profile, &["root"]).is_err());

        profile.nodes[0].values[0] = 1;
        profile.edges = vec![EvolutionTargetEdge {
            from: 0,
            to: 0,
            kind: EvolutionTargetEdgeKind::Dependency,
        }]
        .into_boxed_slice();
        assert!(classes.compile_profile(&profile, &["root"]).is_err());

        profile.edges = Box::new([]);
        profile.nodes[0].mass = 0;
        assert!(classes.compile_profile(&profile, &["root"]).is_err());
        profile.nodes[0].mass = u64::MAX;
        profile.nodes[0].unit_cost = 2;
        assert!(classes.compile_profile(&profile, &["root"]).is_err());

        profile.nodes[0].mass = 1;
        profile.nodes[0].unit_cost = 1;
        profile.nodes = vec![profile.nodes[0].clone(), profile.nodes[0].clone()].into_boxed_slice();
        assert!(classes.compile_profile(&profile, &["root"]).is_err());

        profile.nodes = vec![profile.nodes[0].clone()].into_boxed_slice();
        profile.edges = vec![EvolutionTargetEdge {
            from: 0,
            to: 1,
            kind: EvolutionTargetEdgeKind::Continuation,
        }]
        .into_boxed_slice();
        assert!(classes.compile_profile(&profile, &["root"]).is_err());

        profile.edges = Box::new([]);
        profile.schema = "wrong-schema".into();
        assert!(classes.compile_profile(&profile, &["root"]).is_err());
    }

    #[test]
    fn target_profile_refresh_is_evidenced_before_generation_use() {
        let batch = FeatureBatch {
            presentation: "targets".into(),
            problem: "profile-refresh".into(),
            fields: vec!["root".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0, 1].into_boxed_slice(),
            weights: vec![1, 1].into_boxed_slice(),
            expected: vec![1].into_boxed_slice(),
            values: vec![1, -1].into_boxed_slice(),
        };
        let profile = EvolutionTargetProfile {
            schema: EVOLUTION_TARGET_PROFILE_SCHEMA.into(),
            fields: vec!["root".into()].into_boxed_slice(),
            nodes: vec![EvolutionTargetNode {
                values: vec![1].into_boxed_slice(),
                mass: 7,
                unit_cost: 11,
                strategy: EvolutionTargetStrategy::Numeric,
            }]
            .into_boxed_slice(),
            edges: Box::new([]),
        };
        let expected_hash = target_profile_hash(&profile).unwrap();
        let mailbox = Arc::new(Mutex::new(Some(profile.clone())));
        let identity = EvolutionIdentity {
            code_commit: "profile-refresh-test".into(),
            presentation_hash: "2".repeat(64),
            presentation: batch.presentation.clone(),
            problem: batch.problem.clone(),
            fields: batch.fields.clone(),
            generator: None,
        };
        let seed = PlanSpec {
            schema: super::super::PLAN_SCHEMA.into(),
            name: "root-positive".into(),
            role: super::super::PlanRole::Diagnostic,
            output: super::super::PlanOutput::Predicate,
            scope: None,
            program: vec![
                PlanOp::Field {
                    name: "root".into(),
                },
                PlanOp::Const { value: 2 },
                PlanOp::Gt,
            ],
        };
        let temporary = tempfile::tempdir().unwrap();
        let evidence_path = temporary.path().join("profile-refresh.jsonl");
        let summary = run_evolution(
            Arc::new(batch),
            identity,
            vec![EvolutionSeed {
                plan: seed,
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
                target_fields: vec![0].into_boxed_slice(),
                target_profile: None,
                target_profile_mailbox: mailbox,
            },
            Arc::new(EvolutionProgress::new()),
        )
        .unwrap();
        assert_eq!(summary["target_profile"]["refreshes"], 1);
        assert_eq!(summary["target_profile"]["hash"], expected_hash);
        assert_eq!(summary["target_profile"]["strategy_parents"]["numeric"], 1);
        let records = std::fs::read_to_string(evidence_path)
            .unwrap()
            .lines()
            .map(|line| serde_json::from_str::<Value>(line).unwrap())
            .collect::<Vec<_>>();
        let refreshes = records
            .iter()
            .filter(|record| record["type"] == "target-profile-refresh")
            .collect::<Vec<_>>();
        assert_eq!(refreshes.len(), 1);
        assert_eq!(refreshes[0]["generation"], 0);
        assert_eq!(refreshes[0]["target_profile_hash"], expected_hash);
        assert_eq!(refreshes[0]["target_profile"], json!(profile));
        let repaired = records
            .iter()
            .find(|record| !record["parent_hash"].is_null())
            .unwrap();
        assert_eq!(repaired["source_target_values"], json!([1]));
        assert!(repaired["target_values"].is_null());
        assert_eq!(repaired["evaluation"]["weighted_correct"], 2);
    }

    #[test]
    fn target_accumulator_is_idempotent_and_order_canonical() {
        let fields = vec!["root".into(), "debt".into()].into_boxed_slice();
        let mut left = EvolutionTargetAccumulator::new(fields.clone()).unwrap();
        assert!(left
            .observe(&[2, 3], 7, 11, EvolutionTargetStrategy::Balanced)
            .unwrap());
        assert!(!left
            .observe(&[2, 3], 7, 11, EvolutionTargetStrategy::Balanced)
            .unwrap());
        assert!(left
            .observe(&[1, 4], 5, 13, EvolutionTargetStrategy::Structural)
            .unwrap());
        assert!(left.connect(&[1, 4], &[2, 3], "dependency").unwrap());
        assert!(!left.connect(&[1, 4], &[2, 3], "dependency").unwrap());
        assert!(left.connect(&[1, 4], &[2, 3], "continuation").is_err());

        let mut right = EvolutionTargetAccumulator::new(fields).unwrap();
        right
            .observe(&[1, 4], 5, 13, EvolutionTargetStrategy::Structural)
            .unwrap();
        right
            .observe(&[2, 3], 7, 11, EvolutionTargetStrategy::Balanced)
            .unwrap();
        right.connect(&[1, 4], &[2, 3], "dependency").unwrap();
        let left = left.snapshot().unwrap();
        let right = right.snapshot().unwrap();
        assert_eq!(
            serde_json::to_vec(&left).unwrap(),
            serde_json::to_vec(&right).unwrap()
        );
        assert_eq!(
            target_profile_hash(&left).unwrap(),
            target_profile_hash(&right).unwrap()
        );

        let identity = EvolutionIdentity {
            code_commit: "profile-test".into(),
            presentation_hash: "1".repeat(64),
            presentation: "profile".into(),
            problem: "profile".into(),
            fields: vec!["root".into(), "debt".into()].into_boxed_slice(),
            generator: None,
        };
        let mut header = EvolutionEvidenceHeader::from(&identity);
        header.target_profile = Some(left);
        header.target_profile_hash = Some("0".repeat(64));
        let temporary = tempfile::tempdir().unwrap();
        let path = temporary.path().join("corrupt-profile.jsonl");
        std::fs::write(
            &path,
            format!("{}\n", serde_json::to_string(&header).unwrap()),
        )
        .unwrap();
        assert!(load_evolution_archive(&path, &identity, 1, 1).is_err());
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
            clause_profiles: &[],
            clause_pair_profiles: &[],
            relational_profiles: &[],
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
                MutationRequest {
                    failure_shape: &failure,
                    strategy: EvolutionTargetStrategy::Balanced,
                    source_target_class: None,
                    cursor,
                },
                &mut batch_output,
                2,
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
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Balanced,
                source_target_class: None,
                cursor,
            },
            &mut exhausted_output,
            2,
        );
        assert!(exhausted.exhausted);
        assert!(exhausted_output.is_empty());

        let mut complete = Vec::new();
        let complete_batch = mutate_plan(
            &parent,
            "parent",
            &context,
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Balanced,
                source_target_class: None,
                cursor: 0,
            },
            &mut complete,
            usize::MAX,
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
    fn target_strategy_reorders_but_does_not_prune_mutation_families() {
        let parent = PlanSpec {
            schema: String::new(),
            name: "routed-parent".into(),
            role: super::super::PlanRole::Diagnostic,
            output: super::super::PlanOutput::Predicate,
            scope: None,
            program: vec![
                PlanOp::Field { name: "x".into() },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
            ],
        };
        let fields = vec!["x".into(), "y".into()];
        let scopes = Vec::new();
        let field_index = BTreeMap::new();
        let context = MutationContext {
            fields: &fields,
            scope_profiles: &scopes,
            clause_profiles: &[],
            clause_pair_profiles: &[],
            relational_profiles: &[],
            field_index: &field_index,
        };
        let failure = FailureShape {
            first_mismatch: None,
            expected: None,
            probes: [FailureProbe::default(); MAX_FAILURE_PROBES],
            probe_count: 0,
        };
        let mut numeric_first = Vec::new();
        mutate_plan(
            &parent,
            "parent",
            &context,
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Numeric,
                source_target_class: None,
                cursor: 0,
            },
            &mut numeric_first,
            1,
        );
        assert_eq!(numeric_first[0].operator, "constant-shift");
        let mut structural_first = Vec::new();
        mutate_plan(
            &parent,
            "parent",
            &context,
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Structural,
                source_target_class: None,
                cursor: 0,
            },
            &mut structural_first,
            1,
        );
        assert_eq!(structural_first[0].operator, "field-substitute");

        let mut numeric = Vec::new();
        let numeric_batch = mutate_plan(
            &parent,
            "parent",
            &context,
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Numeric,
                source_target_class: None,
                cursor: 0,
            },
            &mut numeric,
            usize::MAX,
        );
        let mut structural = Vec::new();
        let structural_batch = mutate_plan(
            &parent,
            "parent",
            &context,
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Structural,
                source_target_class: None,
                cursor: 0,
            },
            &mut structural,
            usize::MAX,
        );
        assert!(numeric_batch.exhausted && structural_batch.exhausted);
        let semantics = |candidates: Vec<PendingCandidate>| {
            candidates
                .into_iter()
                .map(|candidate| format!("{:?}", candidate.plan.program))
                .collect::<BTreeSet<_>>()
        };
        assert_eq!(semantics(numeric), semantics(structural));
    }

    #[test]
    fn clause_profiles_are_bounded_and_grow_typed_predicates() {
        let batch = FeatureBatch {
            presentation: "clauses".into(),
            problem: "growth".into(),
            fields: vec!["root_orbit".into(), "branches".into()].into_boxed_slice(),
            generator: None,
            row_ids: (0..5).collect::<Vec<_>>().into_boxed_slice(),
            weights: vec![1; 5].into_boxed_slice(),
            expected: vec![0b1_0011].into_boxed_slice(),
            values: vec![0, 7, 0, 7, 0, 10, 1, 7, 2, 7].into_boxed_slice(),
        };
        let profiles = clause_profiles(&batch).unwrap();
        let pairs = clause_pair_profiles(&batch, &profiles).unwrap();
        assert!(profiles.len() <= MAX_CLAUSE_PROFILES);
        assert!(pairs.len() <= MAX_CLAUSE_PAIR_PROFILES);
        assert!(pairs
            .iter()
            .any(|pair| pair.weighted_correct == 5 && pair.weighted_false_positive == 0));
        assert!(profiles.iter().any(|profile| {
            profile.field == "branches"
                && profile.value == 7
                && matches!(profile.comparison, PlanOp::Eq)
        }));

        let parent = PlanSpec {
            schema: super::super::PLAN_SCHEMA.into(),
            name: "clause-parent".into(),
            role: super::super::PlanRole::Diagnostic,
            output: super::super::PlanOutput::Predicate,
            scope: None,
            program: vec![
                PlanOp::Field {
                    name: "root_orbit".into(),
                },
                PlanOp::Const { value: 1 },
                PlanOp::Gt,
            ],
        };
        let fields = vec!["root_orbit".into(), "branches".into()];
        let scopes = Vec::new();
        let field_index = BTreeMap::new();
        let context = MutationContext {
            fields: &fields,
            scope_profiles: &scopes,
            clause_profiles: &profiles,
            clause_pair_profiles: &pairs,
            relational_profiles: &[],
            field_index: &field_index,
        };
        let failure = FailureShape {
            first_mismatch: None,
            expected: None,
            probes: [FailureProbe::default(); MAX_FAILURE_PROBES],
            probe_count: 0,
        };
        let mut output = Vec::new();
        mutate_plan(
            &parent,
            "parent",
            &context,
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Structural,
                source_target_class: None,
                cursor: 0,
            },
            &mut output,
            1,
        );
        assert_eq!(output.len(), 1);
        assert_eq!(output[0].operator, "clause-pair");
        assert_eq!(output[0].plan.program.len(), 7);
        CompiledPlan::compile(&output[0].plan, &fields).unwrap();

        let strategy_semantics = |strategy| {
            let mut candidates = Vec::new();
            let batch = mutate_plan(
                &parent,
                "parent",
                &context,
                MutationRequest {
                    failure_shape: &failure,
                    strategy,
                    source_target_class: None,
                    cursor: 0,
                },
                &mut candidates,
                usize::MAX,
            );
            assert!(batch.exhausted);
            candidates
                .into_iter()
                .map(|candidate| format!("{:?}", candidate.plan.program))
                .collect::<BTreeSet<_>>()
        };
        assert_eq!(
            strategy_semantics(EvolutionTargetStrategy::Balanced),
            strategy_semantics(EvolutionTargetStrategy::Numeric)
        );
        assert_eq!(
            strategy_semantics(EvolutionTargetStrategy::Balanced),
            strategy_semantics(EvolutionTargetStrategy::Structural)
        );

        let clause_only_context = MutationContext {
            clause_pair_profiles: &[],
            ..context
        };
        output.clear();
        mutate_plan(
            &parent,
            "parent",
            &clause_only_context,
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Structural,
                source_target_class: None,
                cursor: 0,
            },
            &mut output,
            2,
        );
        assert_eq!(output.len(), 2);
        assert_eq!(output[0].operator, "clause-and");
        assert_eq!(output[1].operator, "clause-or");
    }

    #[test]
    fn relational_profiles_grow_exact_field_arithmetic() {
        let batch = FeatureBatch {
            presentation: "relations".into(),
            problem: "sum".into(),
            fields: vec!["left".into(), "right".into()].into_boxed_slice(),
            generator: None,
            row_ids: (0..6).collect::<Vec<_>>().into_boxed_slice(),
            weights: vec![1; 6].into_boxed_slice(),
            expected: vec![0b00_0111].into_boxed_slice(),
            values: vec![1, 9, 2, 8, 3, 7, 1, 8, 2, 9, 4, 7].into_boxed_slice(),
        };
        let profiles = relational_profiles(&batch).unwrap();
        assert!(profiles.len() <= MAX_RELATIONAL_PROFILES);
        let sum = profiles
            .iter()
            .find(|profile| {
                profile.left == "left"
                    && profile.right == "right"
                    && profile.transform == RelationalTransform::Add
                    && profile.value == 10
                    && matches!(profile.comparison, PlanOp::Eq)
            })
            .unwrap();
        assert_eq!(sum.weighted_correct, 6);
        assert_eq!(sum.weighted_false_positive, 0);

        let parent = PlanSpec {
            schema: super::super::PLAN_SCHEMA.into(),
            name: "relation-parent".into(),
            role: super::super::PlanRole::Diagnostic,
            output: super::super::PlanOutput::Predicate,
            scope: None,
            program: vec![PlanOp::Bool { value: true }],
        };
        let scopes = Vec::new();
        let clauses = Vec::new();
        let pairs = Vec::new();
        let field_index = BTreeMap::new();
        let context = MutationContext {
            fields: &batch.fields,
            scope_profiles: &scopes,
            clause_profiles: &clauses,
            clause_pair_profiles: &pairs,
            relational_profiles: &profiles,
            field_index: &field_index,
        };
        let failure = FailureShape {
            first_mismatch: None,
            expected: None,
            probes: [FailureProbe::default(); MAX_FAILURE_PROBES],
            probe_count: 0,
        };
        let mut output = Vec::new();
        mutate_plan(
            &parent,
            "parent",
            &context,
            MutationRequest {
                failure_shape: &failure,
                strategy: EvolutionTargetStrategy::Structural,
                source_target_class: None,
                cursor: 0,
            },
            &mut output,
            1,
        );
        assert_eq!(output[0].operator, "relation");
        let compiled = CompiledPlan::compile(&output[0].plan, &batch.fields).unwrap();
        for row in 0..batch.rows() {
            assert_eq!(
                compiled.evaluate_row(batch.row(row)).unwrap() != 0,
                batch.expected(row)
            );
        }
    }

    #[test]
    fn relational_profiles_reach_late_campaign_fields() {
        let fields = (0..30)
            .map(|field| format!("field-{field:02}"))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        let mut values = vec![0_i64; 8 * fields.len()];
        for row in 0..8 {
            values[row * fields.len() + 28] = row as i64;
            values[row * fields.len() + 29] = if row < 4 { row as i64 } else { row as i64 + 1 };
        }
        let batch = FeatureBatch {
            presentation: "late-relations".into(),
            problem: "field reach".into(),
            fields,
            generator: None,
            row_ids: (0..8).collect::<Vec<_>>().into_boxed_slice(),
            weights: vec![1; 8].into_boxed_slice(),
            expected: vec![0b1111_0000].into_boxed_slice(),
            values: values.into_boxed_slice(),
        };
        let profiles = relational_profiles(&batch).unwrap();
        assert!(profiles.iter().any(|profile| {
            profile.left == "field-28"
                && profile.right == "field-29"
                && profile.transform == RelationalTransform::Direct
                && matches!(profile.comparison, PlanOp::Ne)
                && profile.weighted_correct == 8
                && profile.weighted_false_positive == 0
        }));
    }

    #[test]
    fn target_strategy_refresh_resets_only_changed_retained_cursors() {
        let previous = CompiledTargetProfile {
            hash: "previous".into(),
            class_priorities: vec![1, 1].into_boxed_slice(),
            class_strategies: vec![
                EvolutionTargetStrategy::Balanced,
                EvolutionTargetStrategy::Structural,
            ]
            .into_boxed_slice(),
            nodes: 2,
            edges: 0,
        };
        let refreshed = CompiledTargetProfile {
            hash: "refreshed".into(),
            class_priorities: vec![1, 1].into_boxed_slice(),
            class_strategies: vec![
                EvolutionTargetStrategy::Numeric,
                EvolutionTargetStrategy::Structural,
            ]
            .into_boxed_slice(),
            nodes: 2,
            edges: 0,
        };
        let mut changed = selector_parent("changed", "scope");
        changed.niche.target_class = Some(0);
        changed.mutation_cursor = 7;
        let mut unchanged = selector_parent("unchanged", "scope");
        unchanged.niche.target_class = Some(1);
        unchanged.mutation_cursor = 9;
        let mut unprofiled = selector_parent("unprofiled", "scope");
        unprofiled.mutation_cursor = 11;
        let mut parents = [changed, unchanged, unprofiled];
        assert_eq!(
            reset_changed_strategy_cursors(&mut parents, Some(&previous), &refreshed),
            1
        );
        assert_eq!(parents[0].mutation_cursor, 0);
        assert_eq!(parents[1].mutation_cursor, 9);
        assert_eq!(parents[2].mutation_cursor, 11);
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
            niche: SemanticNiche::new("seed", 0, 1, 28, None),
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
                target_fields: Box::new([]),
                target_profile: None,
                target_profile_mailbox: Arc::new(Mutex::new(None)),
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
            niche: SemanticNiche::new("seed", 0, 0, 21, None),
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
                target_fields: Box::new([]),
                target_profile: None,
                target_profile_mailbox: Arc::new(Mutex::new(None)),
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
                target_fields: Box::new([]),
                target_profile: None,
                target_profile_mailbox: Arc::new(Mutex::new(None)),
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
        assert_eq!(maximum_oriented_quotas(&parents, 10, &empty, &[]), [5, 5]);

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
        let quotas = maximum_oriented_quotas(&parents, 10, &scorecards, &[]);
        assert_eq!(quotas, [9, 1]);

        let many = (0..256)
            .map(|index| selector_parent(&format!("{index:064x}"), "fast"))
            .collect::<Vec<_>>();
        let quotas = maximum_oriented_quotas(&many, 100_000, &scorecards, &[]);
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
