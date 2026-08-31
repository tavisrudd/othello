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
    if config.generations == 0 || config.beam_width == 0 || config.max_candidates == 0 {
        return Err(EvolutionError::EmptyBound.into());
    }
    let conclusion_true = examples.iter().filter(|row| conclusion(row)).count() as u32;
    let mut seen = BTreeSet::new();
    let mut current = seeds.into_iter().collect::<Vec<_>>();
    let mut trial_count = 0_usize;
    let mut best_sound = None;
    let mut mutations = Vec::new();

    for generation in 0..config.generations {
        current.sort_unstable();
        current.dedup();
        let mut ranked = Vec::new();
        for candidate in current.drain(..) {
            if trial_count == config.max_candidates || !seen.insert(candidate.clone()) {
                continue;
            }
            let mut score = ImplicationScore {
                examples: examples.len() as u32,
                conclusion_true,
                complexity: complexity(&candidate),
                ..ImplicationScore::default()
            };
            for example in examples {
                if covers(&candidate, example) {
                    if conclusion(example) {
                        score.covered_true += 1;
                    } else {
                        score.false_positives += 1;
                    }
                }
            }
            let trial = CandidateTrial {
                generation: generation as u32,
                candidate,
                score,
            };
            if trial.score.sound() && best_sound.as_ref().is_none_or(|best| better(&trial, best)) {
                best_sound = Some(trial.clone());
            }
            sink(&trial).map_err(EvolutionRunError::Sink)?;
            ranked.push(trial.clone());
            trial_count += 1;
        }
        if trial_count == config.max_candidates || generation + 1 == config.generations {
            break;
        }
        ranked.sort_unstable_by(compare_trials);
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
    Ok(EvolutionSummary {
        trials: trial_count,
        best_sound,
    })
}

fn better<C>(left: &CandidateTrial<C>, right: &CandidateTrial<C>) -> bool {
    left.score.covered_true > right.score.covered_true
        || (left.score.covered_true == right.score.covered_true
            && left.score.complexity < right.score.complexity)
}

fn compare_trials<C: Ord>(
    left: &CandidateTrial<C>,
    right: &CandidateTrial<C>,
) -> std::cmp::Ordering {
    left.score
        .false_positives
        .cmp(&right.score.false_positives)
        .then_with(|| right.score.covered_true.cmp(&left.score.covered_true))
        .then_with(|| left.score.complexity.cmp(&right.score.complexity))
        .then_with(|| left.candidate.cmp(&right.candidate))
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
}
