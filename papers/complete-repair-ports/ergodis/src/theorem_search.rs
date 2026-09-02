//! Deterministic bounded evolution of candidate sufficient conditions.
//!
//! This is a runner-neutral campaign engine, not a solver hot path. The intended
//! live owner is a low-priority campaign-daemon worker; replay binaries may call
//! it offline for deterministic acceptance tests. Candidates are ranked by exact
//! false positives, covered true examples, and declared syntax cost. Long runs
//! can stream trials to bounded evidence storage instead of retaining them.

use std::collections::BTreeSet;

use thiserror::Error;

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
}

#[derive(Debug, Error)]
pub enum EvolutionRunError<E> {
    #[error(transparent)]
    Evolution(#[from] EvolutionError),
    #[error("candidate evidence sink failed")]
    Sink(E),
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
    if config.generations == 0 || config.beam_width == 0 || config.max_candidates == 0 {
        return Err(EvolutionError::EmptyBound.into());
    }
    let mut seen = BTreeSet::new();
    let mut current = seeds.into_iter().collect::<Vec<_>>();
    let mut trial_count = 0_usize;
    let mut best_admitted: Option<RankedCandidateTrial<C, S>> = None;
    let mut mutations = Vec::new();

    for generation in 0..config.generations {
        current.sort_unstable();
        current.dedup();
        let mut ranked = Vec::new();
        for candidate in current.drain(..) {
            if trial_count == config.max_candidates || !seen.insert(candidate.clone()) {
                continue;
            }
            let trial = RankedCandidateTrial {
                generation: generation as u32,
                score: evaluate(&candidate),
                candidate,
            };
            if admitted(&trial.score)
                && best_admitted.as_ref().is_none_or(|best| {
                    compare_scores(&trial.score, &best.score)
                        .then_with(|| trial.candidate.cmp(&best.candidate))
                        .is_lt()
                })
            {
                best_admitted = Some(trial.clone());
            }
            sink(&trial).map_err(EvolutionRunError::Sink)?;
            ranked.push(trial);
            trial_count += 1;
        }
        if trial_count == config.max_candidates || generation + 1 == config.generations {
            break;
        }
        ranked.sort_unstable_by(|left, right| {
            compare_scores(&left.score, &right.score)
                .then_with(|| left.candidate.cmp(&right.candidate))
        });
        for parent in ranked.iter().take(config.beam_width) {
            mutations.clear();
            mutate(&parent.candidate, &mut mutations);
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
}
