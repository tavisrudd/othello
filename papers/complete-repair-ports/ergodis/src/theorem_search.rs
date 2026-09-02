//! Deterministic bounded evolution of candidate sufficient conditions.
//!
//! This is a runner-neutral campaign engine, not a solver hot path. The intended
//! live owner is a low-priority campaign-daemon worker; replay binaries may call
//! it offline for deterministic acceptance tests. Candidates are ranked by exact
//! false positives, covered true examples, and declared syntax cost. Long runs
//! can stream trials to bounded evidence storage instead of retaining them.

use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const SEPARATING_REPLAY_CORE_SNAPSHOT_VERSION: u16 = 1;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct EvolutionConfig {
    pub generations: usize,
    pub beam_width: usize,
    pub max_candidates: usize,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct ImplicationScore {
    pub examples: u32,
    pub conclusion_true: u32,
    pub covered_true: u32,
    pub false_positives: u32,
    pub complexity: u32,
}

/// Exact census reduction used to rank pruning theorems across shards.
///
/// Ordering should use [`CensusReduction::preferred_cmp`]. The floating-point
/// bit count is deliberately reporting-only.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct CensusReduction {
    initial: u64,
    surviving: u64,
}

impl CensusReduction {
    pub fn new(initial: u64, surviving: u64) -> Result<Self, CensusReductionError> {
        if initial == 0 {
            return Err(CensusReductionError::EmptyCensus);
        }
        if surviving > initial {
            return Err(CensusReductionError::SurvivorOverflow);
        }
        Ok(Self { initial, surviving })
    }

    pub fn initial(self) -> u64 {
        self.initial
    }

    pub fn surviving(self) -> u64 {
        self.surviving
    }

    pub fn pruned(self) -> u64 {
        self.initial - self.surviving
    }

    /// Compare with the stronger reduction first.
    pub fn preferred_cmp(self, other: Self) -> std::cmp::Ordering {
        match (self.surviving, other.surviving) {
            (0, 0) => std::cmp::Ordering::Equal,
            (0, _) => std::cmp::Ordering::Less,
            (_, 0) => std::cmp::Ordering::Greater,
            _ => ((other.initial as u128) * (self.surviving as u128))
                .cmp(&((self.initial as u128) * (other.surviving as u128))),
        }
    }

    pub fn reduction_bits(self) -> f64 {
        if self.surviving == 0 {
            f64::INFINITY
        } else {
            (self.initial as f64).log2() - (self.surviving as f64).log2()
        }
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum CensusReductionError {
    #[error("census must contain at least one candidate")]
    EmptyCensus,
    #[error("surviving census exceeds its initial size")]
    SurvivorOverflow,
}

impl ImplicationScore {
    pub fn sound(self) -> bool {
        self.false_positives == 0
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CandidateTrial<C> {
    pub generation: u32,
    pub candidate: C,
    pub score: ImplicationScore,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct EvolutionResult<C> {
    pub trials: Box<[CandidateTrial<C>]>,
    pub best_sound: Option<CandidateTrial<C>>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct EvolutionSummary<C> {
    pub trials: usize,
    pub best_sound: Option<CandidateTrial<C>>,
}

/// One evaluated candidate from the runner-neutral evolution engine.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RankedCandidateTrial<C, S> {
    pub generation: u32,
    pub candidate: C,
    pub score: S,
}

/// Bounded-memory result from runner-neutral ranked evolution.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RankedEvolutionSummary<C, S> {
    pub trials: usize,
    pub best_admitted: Option<RankedCandidateTrial<C, S>>,
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum EvolutionError {
    #[error("evolution bounds must all be positive")]
    EmptyBound,
    #[error("evolution generation count exceeds u32")]
    GenerationOverflow,
    #[error("evolution driver selected more parents than the beam bound")]
    ParentOverflow,
}

#[derive(Debug, Error)]
pub enum EvolutionRunError<E> {
    #[error(transparent)]
    Evolution(#[from] EvolutionError),
    #[error("candidate evidence sink failed")]
    Sink(E),
}

#[derive(Debug, Error)]
pub enum RankedEvolutionRunError<DriverError, SinkError> {
    #[error(transparent)]
    Evolution(#[from] EvolutionError),
    #[error("evolution driver failed")]
    Driver(DriverError),
    #[error("candidate evidence sink failed")]
    Sink(SinkError),
}

/// Policy hooks for the runner-neutral bounded evolution machine.
///
/// The runner owns generation/candidate bounds, structural deduplication,
/// trial numbering, retained-best admission, and evidence streaming. A driver
/// owns domain evaluation, parent selection, and mutation. This permits a
/// daemon to retain multiple semantic niches without flattening them into one
/// global beam score.
pub trait RankedEvolutionDriver<C, S> {
    type Error;

    fn begin_generation(
        &mut self,
        _generation: u32,
    ) -> Result<std::ops::ControlFlow<()>, Self::Error> {
        Ok(std::ops::ControlFlow::Continue(()))
    }

    fn should_continue(
        &mut self,
        _generation: u32,
        _completed_trials: usize,
    ) -> Result<bool, Self::Error> {
        Ok(true)
    }

    fn evaluate(&mut self, generation: u32, candidate: &C) -> Result<S, Self::Error>;

    fn compare_scores(&self, left: &S, right: &S) -> std::cmp::Ordering;

    fn admitted(&self, score: &S) -> bool;

    fn select_parents(
        &mut self,
        generation: u32,
        trials: &mut [RankedCandidateTrial<C, S>],
        beam_width: usize,
        output: &mut Vec<C>,
    ) -> Result<(), Self::Error>;

    fn mutate(
        &mut self,
        generation: u32,
        parent: &C,
        output: &mut Vec<C>,
    ) -> Result<(), Self::Error>;
}

/// Drive bounded evolution with domain-specific generation selection.
pub fn drive_ranked_evolution_streaming<C, S, Driver, Sink, SinkError>(
    seeds: impl IntoIterator<Item = C>,
    config: EvolutionConfig,
    driver: &mut Driver,
    mut sink: Sink,
) -> Result<RankedEvolutionSummary<C, S>, RankedEvolutionRunError<Driver::Error, SinkError>>
where
    C: Clone + Ord,
    S: Clone,
    Driver: RankedEvolutionDriver<C, S>,
    Sink: FnMut(&RankedCandidateTrial<C, S>) -> Result<(), SinkError>,
{
    if config.generations == 0 || config.beam_width == 0 || config.max_candidates == 0 {
        return Err(EvolutionError::EmptyBound.into());
    }
    if config.generations > u32::MAX as usize {
        return Err(EvolutionError::GenerationOverflow.into());
    }
    let mut seen = BTreeSet::new();
    let mut current = seeds.into_iter().collect::<Vec<_>>();
    let mut trial_count = 0_usize;
    let mut best_admitted: Option<RankedCandidateTrial<C, S>> = None;
    let mut parents = Vec::with_capacity(config.beam_width);
    let mut mutations = Vec::new();

    'generations: for generation in 0..config.generations {
        let generation = generation as u32;
        if driver
            .begin_generation(generation)
            .map_err(RankedEvolutionRunError::Driver)?
            .is_break()
        {
            break;
        }
        current.sort_unstable();
        current.dedup();
        let mut ranked = Vec::new();
        for candidate in current.drain(..) {
            if trial_count == config.max_candidates
                || !driver
                    .should_continue(generation, trial_count)
                    .map_err(RankedEvolutionRunError::Driver)?
            {
                break 'generations;
            }
            if !seen.insert(candidate.clone()) {
                continue;
            }
            let trial = RankedCandidateTrial {
                generation,
                score: driver
                    .evaluate(generation, &candidate)
                    .map_err(RankedEvolutionRunError::Driver)?,
                candidate,
            };
            if driver.admitted(&trial.score)
                && best_admitted.as_ref().is_none_or(|best| {
                    driver
                        .compare_scores(&trial.score, &best.score)
                        .then_with(|| trial.candidate.cmp(&best.candidate))
                        .is_lt()
                })
            {
                best_admitted = Some(trial.clone());
            }
            sink(&trial).map_err(RankedEvolutionRunError::Sink)?;
            ranked.push(trial);
            trial_count += 1;
        }
        if trial_count == config.max_candidates || generation as usize + 1 == config.generations {
            break;
        }
        parents.clear();
        driver
            .select_parents(generation, &mut ranked, config.beam_width, &mut parents)
            .map_err(RankedEvolutionRunError::Driver)?;
        if parents.len() > config.beam_width {
            return Err(EvolutionError::ParentOverflow.into());
        }
        for parent in &parents {
            mutations.clear();
            driver
                .mutate(generation, parent, &mut mutations)
                .map_err(RankedEvolutionRunError::Driver)?;
            current.extend(
                mutations
                    .drain(..)
                    .filter(|candidate| !seen.contains(candidate)),
            );
        }
    }
    Ok(RankedEvolutionSummary {
        trials: trial_count,
        best_admitted,
    })
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct DecisionListConfig {
    pub maximum_rules: usize,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct DecisionListRule<C> {
    pub candidate: C,
    pub newly_covered: u32,
    pub complexity: u32,
}

/// A cascade of independently sound sufficient conditions.
///
/// Rules may overlap syntactically, but `newly_covered` counts only examples
/// not matched by an earlier rule. The effective branches of the cascade are
/// therefore disjoint.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SoundDecisionList<C> {
    pub rules: Box<[DecisionListRule<C>]>,
    pub examples: u32,
    pub conclusion_true: u32,
    pub covered_true: u32,
}

impl<C> SoundDecisionList<C> {
    pub fn complete(&self) -> bool {
        self.covered_true == self.conclusion_true
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum DecisionListError {
    #[error("decision-list rule bound must be positive")]
    EmptyBound,
    #[error("decision-list example census exceeds u32")]
    TooManyExamples,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SoundTheoremPoint<C> {
    pub candidate: C,
    pub covered_true: u64,
    pub evaluation_cost: u32,
    coverage: Box<[u64]>,
}

impl<C> SoundTheoremPoint<C> {
    pub fn coverage(&self) -> &[u64] {
        &self.coverage
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum TheoremArchiveAdmission {
    Inserted { removed: usize, novel_rows: u64 },
    RejectedUnsound { false_positives: u64 },
    RejectedDominated,
    RejectedNoNovelCoverage,
    RejectedCapacity,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum TheoremArchiveError {
    #[error("theorem archive bounds must be positive")]
    EmptyBound,
    #[error("theorem archive bitmap has the wrong width")]
    BitmapWidth,
    #[error("theorem archive bitmap sets bits beyond the row domain")]
    BitmapTail,
}

/// Bounded exact archive of sound pruning theorems.
///
/// Coverage is stored as one bit per corpus row. Dominance requires coverage
/// set inclusion and no greater evaluation cost, rather than comparing counts
/// alone. This preserves complementary rules. Dalmatian admission requires a
/// previously uncovered positive unless the new rule replaces dominated
/// archive points.
pub struct SoundTheoremArchive<C> {
    rows: usize,
    maximum_points: usize,
    conclusion: Box<[u64]>,
    covered_union: Box<[u64]>,
    points: Vec<SoundTheoremPoint<C>>,
}

impl<C: Clone + Ord> SoundTheoremArchive<C> {
    pub fn new(
        rows: usize,
        conclusion: &[u64],
        maximum_points: usize,
    ) -> Result<Self, TheoremArchiveError> {
        if rows == 0 || maximum_points == 0 {
            return Err(TheoremArchiveError::EmptyBound);
        }
        validate_archive_bitmap(rows, conclusion)?;
        Ok(Self {
            rows,
            maximum_points,
            conclusion: conclusion.into(),
            covered_union: vec![0_u64; conclusion.len()].into_boxed_slice(),
            points: Vec::with_capacity(maximum_points),
        })
    }

    pub fn points(&self) -> &[SoundTheoremPoint<C>] {
        &self.points
    }

    pub fn covered_union(&self) -> &[u64] {
        &self.covered_union
    }

    pub fn admit(
        &mut self,
        candidate: C,
        coverage: &[u64],
        evaluation_cost: u32,
    ) -> Result<TheoremArchiveAdmission, TheoremArchiveError> {
        validate_archive_bitmap(self.rows, coverage)?;
        let false_positives = coverage
            .iter()
            .zip(&self.conclusion)
            .map(|(&coverage, &conclusion)| u64::from((coverage & !conclusion).count_ones()))
            .sum();
        if false_positives != 0 {
            return Ok(TheoremArchiveAdmission::RejectedUnsound { false_positives });
        }
        if self.points.iter().any(|point| {
            coverage_superset(point.coverage(), coverage)
                && (point.evaluation_cost < evaluation_cost
                    || (point.evaluation_cost == evaluation_cost && point.candidate <= candidate))
        }) {
            return Ok(TheoremArchiveAdmission::RejectedDominated);
        }
        let novel_rows = coverage
            .iter()
            .zip(&self.covered_union)
            .map(|(&coverage, &covered)| u64::from((coverage & !covered).count_ones()))
            .sum();
        let removed = self
            .points
            .iter()
            .filter(|point| {
                coverage_superset(coverage, point.coverage())
                    && (evaluation_cost < point.evaluation_cost
                        || (evaluation_cost == point.evaluation_cost
                            && candidate < point.candidate))
            })
            .count();
        if novel_rows == 0 && removed == 0 {
            return Ok(TheoremArchiveAdmission::RejectedNoNovelCoverage);
        }
        if self.points.len() - removed + 1 > self.maximum_points {
            return Ok(TheoremArchiveAdmission::RejectedCapacity);
        }
        self.points.retain(|point| {
            !(coverage_superset(coverage, point.coverage())
                && (evaluation_cost < point.evaluation_cost
                    || (evaluation_cost == point.evaluation_cost && candidate < point.candidate)))
        });
        let covered_true = coverage
            .iter()
            .map(|word| u64::from(word.count_ones()))
            .sum();
        self.points.push(SoundTheoremPoint {
            candidate,
            covered_true,
            evaluation_cost,
            coverage: coverage.into(),
        });
        self.points
            .sort_unstable_by(|left, right| left.candidate.cmp(&right.candidate));
        self.covered_union.fill(0);
        for point in &self.points {
            for (covered, &word) in self.covered_union.iter_mut().zip(point.coverage()) {
                *covered |= word;
            }
        }
        Ok(TheoremArchiveAdmission::Inserted {
            removed,
            novel_rows,
        })
    }
}

fn validate_archive_bitmap(rows: usize, bitmap: &[u64]) -> Result<(), TheoremArchiveError> {
    if bitmap.len() != rows.div_ceil(64) {
        return Err(TheoremArchiveError::BitmapWidth);
    }
    if rows % 64 != 0
        && bitmap
            .last()
            .is_some_and(|&word| word & !((1_u64 << (rows % 64)) - 1) != 0)
    {
        return Err(TheoremArchiveError::BitmapTail);
    }
    Ok(())
}

fn coverage_superset(left: &[u64], right: &[u64]) -> bool {
    left.iter()
        .zip(right)
        .all(|(&left, &right)| left & right == right)
}

#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd)]
pub enum FailureCoreKind {
    Unsound,
    Incomplete,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct FailureCore<K> {
    pub key: K,
    pub kind: FailureCoreKind,
    coverage: Box<[u64]>,
}

impl<K> FailureCore<K> {
    pub fn coverage(&self) -> &[u64] {
        &self.coverage
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum FailureCoreAdmission {
    Inserted {
        inserted: usize,
        removed: usize,
        false_positives: u64,
        false_negatives: u64,
    },
    RejectedNoFailure,
    RejectedRedundant {
        false_positives: u64,
        false_negatives: u64,
    },
    RejectedCapacity,
}

/// Bounded antichain of exact corpus failures.
///
/// Keys should be canonical plan-normal-form hashes. Coverage inclusion is the
/// checked weakening order: a generalization of an unsound core still covers
/// its false positive, while a specialization of an incomplete core still
/// misses its false negative. The bank contracts proposal space only; it does
/// not grant proof authority to a retained theorem.
pub struct FailureCoreBank<K> {
    rows: usize,
    maximum_cores: usize,
    conclusion: Box<[u64]>,
    cores: Vec<FailureCore<K>>,
}

impl<K: Clone + Ord> FailureCoreBank<K> {
    pub fn new(
        rows: usize,
        conclusion: &[u64],
        maximum_cores: usize,
    ) -> Result<Self, TheoremArchiveError> {
        if rows == 0 || maximum_cores == 0 {
            return Err(TheoremArchiveError::EmptyBound);
        }
        validate_archive_bitmap(rows, conclusion)?;
        Ok(Self {
            rows,
            maximum_cores,
            conclusion: conclusion.into(),
            cores: Vec::with_capacity(maximum_cores),
        })
    }

    pub fn cores(&self) -> &[FailureCore<K>] {
        &self.cores
    }

    pub fn blocking_core(
        &self,
        proposal_coverage: &[u64],
    ) -> Result<Option<&FailureCore<K>>, TheoremArchiveError> {
        validate_archive_bitmap(self.rows, proposal_coverage)?;
        Ok(self.cores.iter().find(|core| match core.kind {
            FailureCoreKind::Unsound => coverage_superset(proposal_coverage, core.coverage()),
            FailureCoreKind::Incomplete => coverage_superset(core.coverage(), proposal_coverage),
        }))
    }

    pub fn admit_failure(
        &mut self,
        key: K,
        coverage: &[u64],
    ) -> Result<FailureCoreAdmission, TheoremArchiveError> {
        validate_archive_bitmap(self.rows, coverage)?;
        let false_positives = coverage
            .iter()
            .zip(&self.conclusion)
            .map(|(&coverage, &conclusion)| u64::from((coverage & !conclusion).count_ones()))
            .sum();
        let false_negatives = coverage
            .iter()
            .zip(&self.conclusion)
            .map(|(&coverage, &conclusion)| u64::from((conclusion & !coverage).count_ones()))
            .sum();
        let mut kinds = [None, None];
        if false_positives != 0 {
            kinds[0] = Some(FailureCoreKind::Unsound);
        }
        if false_negatives != 0 {
            kinds[1] = Some(FailureCoreKind::Incomplete);
        }
        if kinds.iter().all(Option::is_none) {
            return Ok(FailureCoreAdmission::RejectedNoFailure);
        }

        let mut inserted = 0_usize;
        let mut removed = 0_usize;
        for kind in kinds.into_iter().flatten() {
            let redundant = self.cores.iter().any(|core| {
                core.kind == kind && core_subsumes_candidate(core, kind, &key, coverage)
            });
            if !redundant {
                inserted += 1;
                removed += self
                    .cores
                    .iter()
                    .filter(|core| {
                        core.kind == kind && candidate_subsumes_core(kind, &key, coverage, core)
                    })
                    .count();
            }
        }
        if inserted == 0 {
            return Ok(FailureCoreAdmission::RejectedRedundant {
                false_positives,
                false_negatives,
            });
        }
        if self.cores.len() - removed + inserted > self.maximum_cores {
            return Ok(FailureCoreAdmission::RejectedCapacity);
        }
        for kind in kinds.into_iter().flatten() {
            if self.cores.iter().any(|core| {
                core.kind == kind && core_subsumes_candidate(core, kind, &key, coverage)
            }) {
                continue;
            }
            self.cores.retain(|core| {
                core.kind != kind || !candidate_subsumes_core(kind, &key, coverage, core)
            });
            self.cores.push(FailureCore {
                key: key.clone(),
                kind,
                coverage: coverage.into(),
            });
        }
        self.cores.sort_unstable_by(|left, right| {
            left.kind.cmp(&right.kind).then(left.key.cmp(&right.key))
        });
        Ok(FailureCoreAdmission::Inserted {
            inserted,
            removed,
            false_positives,
            false_negatives,
        })
    }
}

fn core_subsumes_candidate<K: Ord>(
    core: &FailureCore<K>,
    kind: FailureCoreKind,
    key: &K,
    coverage: &[u64],
) -> bool {
    let inclusion = match kind {
        FailureCoreKind::Unsound => coverage_superset(coverage, core.coverage()),
        FailureCoreKind::Incomplete => coverage_superset(core.coverage(), coverage),
    };
    inclusion && (core.coverage() != coverage || &core.key <= key)
}

fn candidate_subsumes_core<K: Ord>(
    kind: FailureCoreKind,
    key: &K,
    coverage: &[u64],
    core: &FailureCore<K>,
) -> bool {
    let inclusion = match kind {
        FailureCoreKind::Unsound => coverage_superset(core.coverage(), coverage),
        FailureCoreKind::Incomplete => coverage_superset(coverage, core.coverage()),
    };
    inclusion && (core.coverage() != coverage || key < &core.key)
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub struct ReplayRowCount {
    pub row: u32,
    pub failures: u32,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct SeparatingReplayCoreSnapshot {
    pub version: u16,
    pub row_count: u32,
    pub maximum_rows: u32,
    pub failure_counts: Box<[ReplayRowCount]>,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum SeparatingReplayCoreError {
    #[error("separating replay-core bounds must be positive")]
    EmptyBound,
    #[error("separating replay corpus exceeds u32 row IDs")]
    TooManyRows,
    #[error("separating replay row is out of range")]
    RowOutOfRange,
    #[error("separating replay failure counter overflowed")]
    CounterOverflow,
    #[error("separating replay examples have the wrong width")]
    ExampleWidth,
    #[error("unsupported separating replay-core snapshot version")]
    SnapshotVersion,
    #[error("separating replay-core snapshot is not canonical")]
    NonCanonicalSnapshot,
}

/// Persistent bounded front of repeatedly violated corpus rows.
///
/// The front is evaluated hardest-first. A mismatch is a conclusive rejection;
/// a pass only permits the mandatory full-corpus replay and never grants
/// theorem authority.
pub struct SeparatingReplayCore {
    row_count: usize,
    maximum_rows: usize,
    failure_counts: Box<[u32]>,
    rows: Vec<u32>,
}

impl SeparatingReplayCore {
    pub fn new(row_count: usize, maximum_rows: usize) -> Result<Self, SeparatingReplayCoreError> {
        if row_count == 0 || maximum_rows == 0 {
            return Err(SeparatingReplayCoreError::EmptyBound);
        }
        if row_count > u32::MAX as usize {
            return Err(SeparatingReplayCoreError::TooManyRows);
        }
        let maximum_rows = maximum_rows.min(row_count);
        Ok(Self {
            row_count,
            maximum_rows,
            failure_counts: vec![0_u32; row_count].into_boxed_slice(),
            rows: Vec::with_capacity(maximum_rows.min(row_count)),
        })
    }

    pub fn rows(&self) -> &[u32] {
        &self.rows
    }

    pub fn failure_count(&self, row: u32) -> Option<u32> {
        self.failure_counts.get(row as usize).copied()
    }

    pub fn observe_failure(&mut self, row: u32) -> Result<(), SeparatingReplayCoreError> {
        let count = self
            .failure_counts
            .get_mut(row as usize)
            .ok_or(SeparatingReplayCoreError::RowOutOfRange)?;
        *count = count
            .checked_add(1)
            .ok_or(SeparatingReplayCoreError::CounterOverflow)?;
        if self.rows.contains(&row) {
            sort_replay_rows(&mut self.rows, &self.failure_counts);
        } else if self.rows.len() < self.maximum_rows {
            self.rows.push(row);
            sort_replay_rows(&mut self.rows, &self.failure_counts);
        } else if replay_row_cmp(row, *self.rows.last().unwrap(), &self.failure_counts).is_lt() {
            *self.rows.last_mut().unwrap() = row;
            sort_replay_rows(&mut self.rows, &self.failure_counts);
        }
        Ok(())
    }

    pub fn first_mismatch<C, E, Predict, Expected>(
        &self,
        candidate: &C,
        examples: &[E],
        predict: Predict,
        expected: Expected,
    ) -> Result<Option<u32>, SeparatingReplayCoreError>
    where
        Predict: Fn(&C, &E) -> bool,
        Expected: Fn(&E) -> bool,
    {
        if examples.len() != self.row_count {
            return Err(SeparatingReplayCoreError::ExampleWidth);
        }
        Ok(self.rows.iter().copied().find(|&row| {
            let example = &examples[row as usize];
            predict(candidate, example) != expected(example)
        }))
    }

    pub fn snapshot(&self) -> SeparatingReplayCoreSnapshot {
        let failure_counts = self
            .failure_counts
            .iter()
            .enumerate()
            .filter(|(_, failures)| **failures != 0)
            .map(|(row, &failures)| ReplayRowCount {
                row: row as u32,
                failures,
            })
            .collect::<Vec<_>>()
            .into_boxed_slice();
        SeparatingReplayCoreSnapshot {
            version: SEPARATING_REPLAY_CORE_SNAPSHOT_VERSION,
            row_count: self.row_count as u32,
            maximum_rows: self.maximum_rows as u32,
            failure_counts,
        }
    }

    pub fn from_snapshot(
        snapshot: &SeparatingReplayCoreSnapshot,
    ) -> Result<Self, SeparatingReplayCoreError> {
        if snapshot.version != SEPARATING_REPLAY_CORE_SNAPSHOT_VERSION {
            return Err(SeparatingReplayCoreError::SnapshotVersion);
        }
        let mut core = Self::new(snapshot.row_count as usize, snapshot.maximum_rows as usize)?;
        let mut previous = None;
        for entry in snapshot.failure_counts.iter().copied() {
            if entry.failures == 0
                || entry.row >= snapshot.row_count
                || previous.is_some_and(|previous| entry.row <= previous)
            {
                return Err(SeparatingReplayCoreError::NonCanonicalSnapshot);
            }
            core.failure_counts[entry.row as usize] = entry.failures;
            previous = Some(entry.row);
        }
        for entry in snapshot.failure_counts.iter() {
            if core.rows.len() < core.maximum_rows {
                core.rows.push(entry.row);
                sort_replay_rows(&mut core.rows, &core.failure_counts);
            } else if replay_row_cmp(entry.row, *core.rows.last().unwrap(), &core.failure_counts)
                .is_lt()
            {
                *core.rows.last_mut().unwrap() = entry.row;
                sort_replay_rows(&mut core.rows, &core.failure_counts);
            }
        }
        Ok(core)
    }
}

fn sort_replay_rows(rows: &mut [u32], failure_counts: &[u32]) {
    rows.sort_unstable_by(|&left, &right| replay_row_cmp(left, right, failure_counts));
}

fn replay_row_cmp(left: u32, right: u32, failure_counts: &[u32]) -> std::cmp::Ordering {
    failure_counts[right as usize]
        .cmp(&failure_counts[left as usize])
        .then_with(|| left.cmp(&right))
}

/// Greedily assemble a deterministic cascade from independently sound rules.
///
/// Candidate soundness is replayed against every example instead of trusted
/// from prior evolution metadata. Each round chooses the rule covering the
/// most previously uncovered true examples, then the lowest declared
/// complexity and structural candidate order. Rules with any false positive
/// are excluded, so every prefix and the final disjunction are sound.
pub fn assemble_sound_decision_list<C, E, Covers, Conclusion, Complexity>(
    candidates: impl IntoIterator<Item = C>,
    examples: &[E],
    config: DecisionListConfig,
    covers: Covers,
    conclusion: Conclusion,
    complexity: Complexity,
) -> Result<SoundDecisionList<C>, DecisionListError>
where
    C: Clone + Ord,
    Covers: Fn(&C, &E) -> bool,
    Conclusion: Fn(&E) -> bool,
    Complexity: Fn(&C) -> u32,
{
    if config.maximum_rules == 0 {
        return Err(DecisionListError::EmptyBound);
    }
    let example_count =
        u32::try_from(examples.len()).map_err(|_| DecisionListError::TooManyExamples)?;
    let labels = examples.iter().map(&conclusion).collect::<Vec<_>>();
    let conclusion_true = u32::try_from(labels.iter().filter(|&&label| label).count())
        .map_err(|_| DecisionListError::TooManyExamples)?;
    let mut candidates = candidates.into_iter().collect::<Vec<_>>();
    candidates.sort_unstable();
    candidates.dedup();
    let mut covered = vec![false; examples.len()];
    let mut rules = Vec::with_capacity(config.maximum_rules.min(candidates.len()));

    while rules.len() < config.maximum_rules {
        let mut best: Option<(usize, u32, u32)> = None;
        for (index, candidate) in candidates.iter().enumerate() {
            let mut newly_covered = 0_u32;
            let mut sound = true;
            for ((example, &label), &already_covered) in examples.iter().zip(&labels).zip(&covered)
            {
                if covers(candidate, example) {
                    if !label {
                        sound = false;
                        break;
                    }
                    newly_covered += u32::from(!already_covered);
                }
            }
            if !sound || newly_covered == 0 {
                continue;
            }
            let candidate_complexity = complexity(candidate);
            if best
                .as_ref()
                .is_none_or(|&(best_index, best_gain, best_complexity)| {
                    newly_covered
                        .cmp(&best_gain)
                        .reverse()
                        .then_with(|| candidate_complexity.cmp(&best_complexity))
                        .then_with(|| candidate.cmp(&candidates[best_index]))
                        .is_lt()
                })
            {
                best = Some((index, newly_covered, candidate_complexity));
            }
        }
        let Some((index, newly_covered, candidate_complexity)) = best else {
            break;
        };
        let candidate = candidates.remove(index);
        for ((example, &label), covered) in examples.iter().zip(&labels).zip(&mut covered) {
            *covered |= label && covers(&candidate, example);
        }
        rules.push(DecisionListRule {
            candidate,
            newly_covered,
            complexity: candidate_complexity,
        });
        if rules.iter().map(|rule| rule.newly_covered).sum::<u32>() == conclusion_true {
            break;
        }
    }
    let covered_true = rules.iter().map(|rule| rule.newly_covered).sum();
    Ok(SoundDecisionList {
        rules: rules.into_boxed_slice(),
        examples: example_count,
        conclusion_true,
        covered_true,
    })
}

/// Closure adapter for the default globally ranked beam policy.
struct ClosureEvolutionDriver<C, S, Mutate, Evaluate, Compare, Admitted> {
    mutate: Mutate,
    evaluate: Evaluate,
    compare_scores: Compare,
    admitted: Admitted,
    marker: std::marker::PhantomData<fn(C) -> S>,
}

impl<C, S, Mutate, Evaluate, Compare, Admitted> RankedEvolutionDriver<C, S>
    for ClosureEvolutionDriver<C, S, Mutate, Evaluate, Compare, Admitted>
where
    C: Clone + Ord,
    Mutate: Fn(&C, &mut Vec<C>),
    Evaluate: Fn(&C) -> S,
    Compare: Fn(&S, &S) -> std::cmp::Ordering,
    Admitted: Fn(&S) -> bool,
{
    type Error = std::convert::Infallible;

    fn evaluate(&mut self, _generation: u32, candidate: &C) -> Result<S, Self::Error> {
        Ok((self.evaluate)(candidate))
    }

    fn compare_scores(&self, left: &S, right: &S) -> std::cmp::Ordering {
        (self.compare_scores)(left, right)
    }

    fn admitted(&self, score: &S) -> bool {
        (self.admitted)(score)
    }

    fn select_parents(
        &mut self,
        _generation: u32,
        trials: &mut [RankedCandidateTrial<C, S>],
        beam_width: usize,
        output: &mut Vec<C>,
    ) -> Result<(), Self::Error> {
        trials.sort_unstable_by(|left, right| {
            (self.compare_scores)(&left.score, &right.score)
                .then_with(|| left.candidate.cmp(&right.candidate))
        });
        output.extend(
            trials
                .iter()
                .take(beam_width)
                .map(|trial| trial.candidate.clone()),
        );
        Ok(())
    }

    fn mutate(
        &mut self,
        _generation: u32,
        parent: &C,
        output: &mut Vec<C>,
    ) -> Result<(), Self::Error> {
        (self.mutate)(parent, output);
        Ok(())
    }
}

/// Evolve arbitrary ranked candidates while streaming every completed trial.
///
/// `compare_scores` returns the preferred score first, as in a sorting
/// comparator. Structural candidate order is the deterministic final tie
/// breaker. `admitted` defines which candidates may become the retained best;
/// inadmissible candidates may still survive in the beam and generate useful
/// mutations.
#[allow(clippy::too_many_arguments)]
pub fn evolve_ranked_streaming<C, S, Mutate, Evaluate, Compare, Admitted, Sink, SinkError>(
    seeds: impl IntoIterator<Item = C>,
    config: EvolutionConfig,
    mutate: Mutate,
    evaluate: Evaluate,
    compare_scores: Compare,
    admitted: Admitted,
    mut sink: Sink,
) -> Result<RankedEvolutionSummary<C, S>, EvolutionRunError<SinkError>>
where
    C: Clone + Ord,
    S: Clone,
    Mutate: Fn(&C, &mut Vec<C>),
    Evaluate: Fn(&C) -> S,
    Compare: Fn(&S, &S) -> std::cmp::Ordering,
    Admitted: Fn(&S) -> bool,
    Sink: FnMut(&RankedCandidateTrial<C, S>) -> Result<(), SinkError>,
{
    let mut driver = ClosureEvolutionDriver {
        mutate,
        evaluate,
        compare_scores,
        admitted,
        marker: std::marker::PhantomData,
    };
    match drive_ranked_evolution_streaming(seeds, config, &mut driver, &mut sink) {
        Ok(summary) => Ok(summary),
        Err(RankedEvolutionRunError::Evolution(error)) => Err(error.into()),
        Err(RankedEvolutionRunError::Driver(never)) => match never {},
        Err(RankedEvolutionRunError::Sink(error)) => Err(EvolutionRunError::Sink(error)),
    }
}

pub fn evolve_implications<C, E, Mutate, Covers, Conclusion, Complexity>(
    seeds: impl IntoIterator<Item = C>,
    examples: &[E],
    config: EvolutionConfig,
    mutate: Mutate,
    covers: Covers,
    conclusion: Conclusion,
    complexity: Complexity,
) -> Result<EvolutionResult<C>, EvolutionError>
where
    C: Clone + Ord,
    Mutate: Fn(&C, &mut Vec<C>),
    Covers: Fn(&C, &E) -> bool,
    Conclusion: Fn(&E) -> bool,
    Complexity: Fn(&C) -> u32,
{
    let mut trials = Vec::new();
    let result = evolve_implications_streaming(
        seeds,
        examples,
        config,
        mutate,
        covers,
        conclusion,
        complexity,
        |trial| {
            trials.push(trial.clone());
            Ok::<_, std::convert::Infallible>(())
        },
    );
    let summary = match result {
        Ok(summary) => summary,
        Err(EvolutionRunError::Evolution(error)) => return Err(error),
        Err(EvolutionRunError::Sink(never)) => match never {},
    };
    Ok(EvolutionResult {
        trials: trials.into_boxed_slice(),
        best_sound: summary.best_sound,
    })
}

/// Evolve candidates while handing each completed trial to a caller-owned sink.
///
/// Only the current generation, the structural deduplication set, and the best
/// sound trial remain resident. A JSONL/file sink can therefore retain a long
/// audit trail with bounded process memory.
#[allow(clippy::too_many_arguments)]
pub fn evolve_implications_streaming<
    C,
    E,
    Mutate,
    Covers,
    Conclusion,
    Complexity,
    Sink,
    SinkError,
>(
    seeds: impl IntoIterator<Item = C>,
    examples: &[E],
    config: EvolutionConfig,
    mutate: Mutate,
    covers: Covers,
    conclusion: Conclusion,
    complexity: Complexity,
    mut sink: Sink,
) -> Result<EvolutionSummary<C>, EvolutionRunError<SinkError>>
where
    C: Clone + Ord,
    Mutate: Fn(&C, &mut Vec<C>),
    Covers: Fn(&C, &E) -> bool,
    Conclusion: Fn(&E) -> bool,
    Complexity: Fn(&C) -> u32,
    Sink: FnMut(&CandidateTrial<C>) -> Result<(), SinkError>,
{
    let conclusion_true = examples.iter().filter(|row| conclusion(row)).count() as u32;
    let summary = evolve_ranked_streaming(
        seeds,
        config,
        mutate,
        |candidate| {
            let mut score = ImplicationScore {
                examples: examples.len() as u32,
                conclusion_true,
                complexity: complexity(candidate),
                ..ImplicationScore::default()
            };
            for example in examples {
                if covers(candidate, example) {
                    if conclusion(example) {
                        score.covered_true += 1;
                    } else {
                        score.false_positives += 1;
                    }
                }
            }
            score
        },
        compare_implication_scores,
        |score| score.sound(),
        |trial| {
            sink(&CandidateTrial {
                generation: trial.generation,
                candidate: trial.candidate.clone(),
                score: trial.score,
            })
        },
    )?;
    Ok(EvolutionSummary {
        trials: summary.trials,
        best_sound: summary.best_admitted.map(|trial| CandidateTrial {
            generation: trial.generation,
            candidate: trial.candidate,
            score: trial.score,
        }),
    })
}

fn compare_implication_scores(
    left: &ImplicationScore,
    right: &ImplicationScore,
) -> std::cmp::Ordering {
    left.false_positives
        .cmp(&right.false_positives)
        .then_with(|| right.covered_true.cmp(&left.covered_true))
        .then_with(|| left.complexity.cmp(&right.complexity))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn evolves_to_the_broadest_sound_threshold() {
        let examples = [(0_u8, false), (1, false), (2, true), (3, true)];
        let result = evolve_implications(
            [0_u8],
            &examples,
            EvolutionConfig {
                generations: 4,
                beam_width: 2,
                max_candidates: 8,
            },
            |threshold, output| output.push(threshold + 1),
            |threshold, example| example.0 >= *threshold,
            |example| example.1,
            |threshold| *threshold as u32,
        )
        .unwrap();
        assert_eq!(result.best_sound.unwrap().candidate, 2);
    }

    #[test]
    fn streams_trials_without_retaining_the_audit() {
        let examples = [(0_u8, false), (1, false), (2, true), (3, true)];
        let mut streamed = Vec::new();
        let summary = evolve_implications_streaming(
            [0_u8],
            &examples,
            EvolutionConfig {
                generations: 4,
                beam_width: 2,
                max_candidates: 8,
            },
            |threshold, output| output.push(threshold + 1),
            |threshold, example| example.0 >= *threshold,
            |example| example.1,
            |threshold| *threshold as u32,
            |trial| {
                streamed.push((trial.generation, trial.candidate));
                Ok::<_, std::convert::Infallible>(())
            },
        )
        .unwrap();
        assert_eq!(summary.trials, streamed.len());
        assert_eq!(summary.best_sound.unwrap().candidate, 2);
    }

    #[test]
    fn generic_engine_separates_ranking_from_admission() {
        let mut streamed = Vec::new();
        let summary = evolve_ranked_streaming(
            [0_u8],
            EvolutionConfig {
                generations: 4,
                beam_width: 1,
                max_candidates: 4,
            },
            |candidate, output| output.push(candidate + 1),
            |candidate| (u8::MAX - candidate, *candidate >= 2),
            |left, right| left.0.cmp(&right.0),
            |score| score.1,
            |trial| {
                streamed.push(trial.candidate);
                Ok::<_, std::convert::Infallible>(())
            },
        )
        .unwrap();
        assert_eq!(streamed, [0, 1, 2, 3]);
        assert_eq!(summary.best_admitted.unwrap().candidate, 3);
    }

    #[test]
    fn generic_driver_can_select_multiple_semantic_niches() {
        struct ParityNiches;

        impl RankedEvolutionDriver<u8, u8> for ParityNiches {
            type Error = std::convert::Infallible;

            fn evaluate(&mut self, _generation: u32, candidate: &u8) -> Result<u8, Self::Error> {
                Ok(*candidate)
            }

            fn compare_scores(&self, left: &u8, right: &u8) -> std::cmp::Ordering {
                left.cmp(right)
            }

            fn admitted(&self, _score: &u8) -> bool {
                true
            }

            fn select_parents(
                &mut self,
                _generation: u32,
                trials: &mut [RankedCandidateTrial<u8, u8>],
                _beam_width: usize,
                output: &mut Vec<u8>,
            ) -> Result<(), Self::Error> {
                output.push(
                    trials
                        .iter()
                        .filter(|trial| trial.candidate % 2 == 0)
                        .map(|trial| trial.candidate)
                        .min()
                        .unwrap(),
                );
                output.push(
                    trials
                        .iter()
                        .filter(|trial| trial.candidate % 2 == 1)
                        .map(|trial| trial.candidate)
                        .max()
                        .unwrap(),
                );
                Ok(())
            }

            fn mutate(
                &mut self,
                _generation: u32,
                parent: &u8,
                output: &mut Vec<u8>,
            ) -> Result<(), Self::Error> {
                output.push(parent + 4);
                Ok(())
            }
        }

        let mut driver = ParityNiches;
        let mut streamed = Vec::new();
        let summary = drive_ranked_evolution_streaming(
            [0_u8, 1, 2, 3],
            EvolutionConfig {
                generations: 2,
                beam_width: 2,
                max_candidates: 8,
            },
            &mut driver,
            |trial| {
                streamed.push(trial.candidate);
                Ok::<_, std::convert::Infallible>(())
            },
        )
        .unwrap();
        assert_eq!(streamed, [0, 1, 2, 3, 4, 7]);
        assert_eq!(summary.best_admitted.unwrap().candidate, 0);
    }

    #[test]
    fn generic_driver_fails_closed_on_parent_overflow() {
        struct TooManyParents;

        impl RankedEvolutionDriver<u8, ()> for TooManyParents {
            type Error = std::convert::Infallible;

            fn evaluate(&mut self, _generation: u32, _candidate: &u8) -> Result<(), Self::Error> {
                Ok(())
            }

            fn compare_scores(&self, _left: &(), _right: &()) -> std::cmp::Ordering {
                std::cmp::Ordering::Equal
            }

            fn admitted(&self, _score: &()) -> bool {
                true
            }

            fn select_parents(
                &mut self,
                _generation: u32,
                _trials: &mut [RankedCandidateTrial<u8, ()>],
                _beam_width: usize,
                output: &mut Vec<u8>,
            ) -> Result<(), Self::Error> {
                output.extend([0, 1]);
                Ok(())
            }

            fn mutate(
                &mut self,
                _generation: u32,
                _parent: &u8,
                _output: &mut Vec<u8>,
            ) -> Result<(), Self::Error> {
                Ok(())
            }
        }

        let mut driver = TooManyParents;
        assert!(matches!(
            drive_ranked_evolution_streaming(
                [0_u8],
                EvolutionConfig {
                    generations: 2,
                    beam_width: 1,
                    max_candidates: 2,
                },
                &mut driver,
                |_| Ok::<_, std::convert::Infallible>(()),
            ),
            Err(RankedEvolutionRunError::Evolution(
                EvolutionError::ParentOverflow
            ))
        ));
    }

    #[test]
    fn census_reduction_orders_exact_ratios_before_reporting_bits() {
        let half = CensusReduction::new(u64::MAX - 1, (u64::MAX - 1) / 2).unwrap();
        let quarter = CensusReduction::new(u64::MAX - 3, (u64::MAX - 3) / 4).unwrap();
        let empty = CensusReduction::new(17, 0).unwrap();
        assert!(quarter.preferred_cmp(half).is_lt());
        assert!(empty.preferred_cmp(quarter).is_lt());
        assert_eq!(CensusReduction::new(16, 8).unwrap().reduction_bits(), 1.0);
        assert!(empty.reduction_bits().is_infinite());
    }

    #[test]
    fn assembles_disjoint_effective_branches_from_sound_rules() {
        let examples = [(0_u8, false), (1, true), (2, true), (3, true), (4, false)];
        let rules = [(0_u8, 4_u8), (1, 2), (1, 3), (2, 4), (3, 4)];
        let list = assemble_sound_decision_list(
            rules,
            &examples,
            DecisionListConfig { maximum_rules: 3 },
            |&(start, end), &(value, _)| start <= value && value < end,
            |&(_, conclusion)| conclusion,
            |&(start, end)| u32::from(end - start),
        )
        .unwrap();
        assert!(list.complete());
        assert_eq!(list.conclusion_true, 3);
        assert_eq!(list.covered_true, 3);
        assert_eq!(list.rules.len(), 2);
        assert_eq!(list.rules[0].candidate, (1, 3));
        assert_eq!(list.rules[0].newly_covered, 2);
        assert_eq!(list.rules[1].newly_covered, 1);
        assert_eq!(
            list.rules
                .iter()
                .map(|rule| rule.newly_covered)
                .sum::<u32>(),
            3
        );
    }

    #[test]
    fn decision_list_respects_rule_bound_and_rejects_unsound_coverage() {
        let examples = [(0_u8, false), (1, true), (2, true), (3, true)];
        let list = assemble_sound_decision_list(
            [(0_u8, 4_u8), (1, 2), (2, 3), (3, 4)],
            &examples,
            DecisionListConfig { maximum_rules: 2 },
            |&(start, end), &(value, _)| start <= value && value < end,
            |&(_, conclusion)| conclusion,
            |_| 1,
        )
        .unwrap();
        assert_eq!(list.rules.len(), 2);
        assert_eq!(list.covered_true, 2);
        assert!(!list.complete());
        assert!(list.rules.iter().all(|rule| rule.candidate.0 != 0));
        assert_eq!(
            assemble_sound_decision_list(
                [0_u8],
                &examples,
                DecisionListConfig { maximum_rules: 0 },
                |_, _| false,
                |&(_, conclusion)| conclusion,
                |_| 0,
            ),
            Err(DecisionListError::EmptyBound)
        );
    }

    #[test]
    fn theorem_archive_combines_dalmatian_novelty_with_exact_dominance() {
        let mut archive = SoundTheoremArchive::new(5, &[0b0_0111], 3).unwrap();
        assert_eq!(
            archive.admit("first", &[0b0_0001], 3).unwrap(),
            TheoremArchiveAdmission::Inserted {
                removed: 0,
                novel_rows: 1,
            }
        );
        assert_eq!(
            archive.admit("second", &[0b0_0010], 2).unwrap(),
            TheoremArchiveAdmission::Inserted {
                removed: 0,
                novel_rows: 1,
            }
        );
        assert_eq!(
            archive.admit("unsound", &[0b1_0000], 1).unwrap(),
            TheoremArchiveAdmission::RejectedUnsound { false_positives: 1 }
        );
        assert_eq!(
            archive.admit("expensive-first", &[0b0_0001], 4).unwrap(),
            TheoremArchiveAdmission::RejectedDominated
        );
        assert_eq!(
            archive.admit("redundant-union", &[0b0_0011], 10).unwrap(),
            TheoremArchiveAdmission::RejectedNoNovelCoverage
        );
        assert_eq!(
            archive.admit("combined", &[0b0_0011], 1).unwrap(),
            TheoremArchiveAdmission::Inserted {
                removed: 2,
                novel_rows: 0,
            }
        );
        assert_eq!(
            archive.admit("third", &[0b0_0100], 5).unwrap(),
            TheoremArchiveAdmission::Inserted {
                removed: 0,
                novel_rows: 1,
            }
        );
        assert_eq!(archive.covered_union(), &[0b0_0111]);
        assert_eq!(archive.points().len(), 2);
        assert_eq!(archive.points()[0].candidate, "combined");
        assert_eq!(archive.points()[0].covered_true, 2);
    }

    #[test]
    fn theorem_archive_preserves_complements_and_fails_closed_at_capacity() {
        let mut archive = SoundTheoremArchive::new(3, &[0b111], 1).unwrap();
        assert!(matches!(
            archive.admit(0_u8, &[0b001], 1).unwrap(),
            TheoremArchiveAdmission::Inserted { .. }
        ));
        assert_eq!(
            archive.admit(1_u8, &[0b010], 1).unwrap(),
            TheoremArchiveAdmission::RejectedCapacity
        );
        assert_eq!(archive.covered_union(), &[0b001]);
        assert_eq!(archive.points().len(), 1);
        assert_eq!(
            SoundTheoremArchive::<u8>::new(3, &[1_u64 << 63], 1)
                .err()
                .unwrap(),
            TheoremArchiveError::BitmapTail
        );
    }

    #[test]
    fn failure_cores_contract_generalizations_and_specializations() {
        let mut bank = FailureCoreBank::new(4, &[0b0011], 4).unwrap();
        assert_eq!(
            bank.admit_failure("unsound", &[0b0111]).unwrap(),
            FailureCoreAdmission::Inserted {
                inserted: 1,
                removed: 0,
                false_positives: 1,
                false_negatives: 0,
            }
        );
        let blocker = bank.blocking_core(&[0b1111]).unwrap().unwrap();
        assert_eq!(blocker.key, "unsound");
        assert_eq!(blocker.kind, FailureCoreKind::Unsound);
        assert_eq!(
            bank.admit_failure("unsound-generalization", &[0b1111])
                .unwrap(),
            FailureCoreAdmission::RejectedRedundant {
                false_positives: 2,
                false_negatives: 0,
            }
        );

        assert_eq!(
            bank.admit_failure("incomplete", &[0b0001]).unwrap(),
            FailureCoreAdmission::Inserted {
                inserted: 1,
                removed: 0,
                false_positives: 0,
                false_negatives: 1,
            }
        );
        let blocker = bank.blocking_core(&[0]).unwrap().unwrap();
        assert_eq!(blocker.key, "incomplete");
        assert_eq!(blocker.kind, FailureCoreKind::Incomplete);
        assert_eq!(
            bank.admit_failure("complete", &[0b0011]).unwrap(),
            FailureCoreAdmission::RejectedNoFailure
        );
        assert_eq!(bank.cores().len(), 2);
    }

    #[test]
    fn failure_core_antichain_replaces_weaker_failures_atomically() {
        let mut bank = FailureCoreBank::new(4, &[0b0011], 4).unwrap();
        bank.admit_failure("broad-unsound", &[0b1111]).unwrap();
        let admission = bank.admit_failure("narrow-unsound", &[0b0100]).unwrap();
        assert_eq!(
            admission,
            FailureCoreAdmission::Inserted {
                inserted: 2,
                removed: 1,
                false_positives: 1,
                false_negatives: 2,
            }
        );
        assert_eq!(bank.cores().len(), 2);

        let mut capacity = FailureCoreBank::new(4, &[0b0011], 1).unwrap();
        assert_eq!(
            capacity.admit_failure("two-failures", &[0b0100]).unwrap(),
            FailureCoreAdmission::RejectedCapacity
        );
        assert!(capacity.cores().is_empty());
    }

    #[test]
    fn separating_replay_core_keeps_hard_rows_and_rejects_early() {
        let mut core = SeparatingReplayCore::new(5, 2).unwrap();
        core.observe_failure(3).unwrap();
        core.observe_failure(1).unwrap();
        core.observe_failure(3).unwrap();
        core.observe_failure(4).unwrap();
        assert_eq!(core.rows(), &[3, 1]);
        assert_eq!(core.failure_count(3), Some(2));

        let examples = [false, false, true, true, false];
        let calls = std::cell::Cell::new(0_usize);
        let mismatch = core
            .first_mismatch(
                &(),
                &examples,
                |_, expected| {
                    calls.set(calls.get() + 1);
                    !expected
                },
                |expected| *expected,
            )
            .unwrap();
        assert_eq!(mismatch, Some(3));
        assert_eq!(calls.get(), 1);
    }

    #[test]
    fn separating_replay_core_snapshot_is_sparse_and_canonical() {
        let mut core = SeparatingReplayCore::new(8, 2).unwrap();
        for row in [6_u32, 2, 6, 4, 2, 6] {
            core.observe_failure(row).unwrap();
        }
        let snapshot = core.snapshot();
        assert_eq!(
            snapshot.failure_counts.as_ref(),
            [
                ReplayRowCount {
                    row: 2,
                    failures: 2,
                },
                ReplayRowCount {
                    row: 4,
                    failures: 1,
                },
                ReplayRowCount {
                    row: 6,
                    failures: 3,
                },
            ]
        );
        let encoded = serde_json::to_vec(&snapshot).unwrap();
        let decoded: SeparatingReplayCoreSnapshot = serde_json::from_slice(&encoded).unwrap();
        let restored = SeparatingReplayCore::from_snapshot(&decoded).unwrap();
        assert_eq!(restored.rows(), &[6, 2]);
        assert_eq!(restored.failure_count(4), Some(1));

        let mut noncanonical = decoded;
        noncanonical.failure_counts.swap(0, 1);
        assert_eq!(
            SeparatingReplayCore::from_snapshot(&noncanonical)
                .err()
                .unwrap(),
            SeparatingReplayCoreError::NonCanonicalSnapshot
        );
    }
}
