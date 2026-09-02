//! Discovery-only greedy cover synthesis for exact predicates.
//!
//! This module ranks already-typed predicates against observations.  It never
//! creates proof authority: callers must compile and independently verify each
//! selected predicate through its domain extractor.

use serde::Serialize;
use thiserror::Error;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PredicateCoverBudget {
    pub maximum_candidates: usize,
    pub maximum_observations: usize,
    pub maximum_selected: usize,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum PredicateCoverError {
    #[error("predicate-cover input exceeds its explicit budget")]
    Budget,
    #[error("predicate-cover input shape is invalid")]
    Shape,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct PredicateCoverReport {
    pub selected_indices: Box<[u32]>,
    pub marginal_rejections: Box<[u32]>,
    pub initially_uncovered: u32,
    pub finally_uncovered: u32,
    pub provenance: &'static str,
}

/// Greedily order predicates by exact marginal rejection of the remaining
/// observations.  Ties are deterministic by original candidate index.
pub fn synthesize_predicate_cover(
    candidate_count: usize,
    observation_count: usize,
    budget: PredicateCoverBudget,
    mut rejects: impl FnMut(usize, usize) -> bool,
) -> Result<PredicateCoverReport, PredicateCoverError> {
    if candidate_count == 0 || budget.maximum_selected == 0 {
        return Err(PredicateCoverError::Shape);
    }
    if candidate_count > budget.maximum_candidates
        || observation_count > budget.maximum_observations
        || budget.maximum_selected > budget.maximum_candidates
        || candidate_count > u32::MAX as usize
        || observation_count > u32::MAX as usize
    {
        return Err(PredicateCoverError::Budget);
    }
    let mut uncovered = vec![true; observation_count];
    let mut available = vec![true; candidate_count];
    let selected_capacity = budget.maximum_selected.min(candidate_count);
    let mut selected = Vec::with_capacity(selected_capacity);
    let mut gains = Vec::with_capacity(selected_capacity);
    for _ in 0..selected_capacity {
        let mut best_index = 0_usize;
        let mut best_gain = 0_usize;
        for candidate in 0..candidate_count {
            if !available[candidate] {
                continue;
            }
            let mut gain = 0_usize;
            for (observation, &is_uncovered) in uncovered.iter().enumerate() {
                gain += usize::from(is_uncovered && rejects(candidate, observation));
            }
            if gain > best_gain {
                best_index = candidate;
                best_gain = gain;
            }
        }
        if best_gain == 0 {
            break;
        }
        available[best_index] = false;
        for (observation, is_uncovered) in uncovered.iter_mut().enumerate() {
            if *is_uncovered && rejects(best_index, observation) {
                *is_uncovered = false;
            }
        }
        selected.push(best_index as u32);
        gains.push(best_gain as u32);
    }
    Ok(PredicateCoverReport {
        selected_indices: selected.into_boxed_slice(),
        marginal_rejections: gains.into_boxed_slice(),
        initially_uncovered: observation_count as u32,
        finally_uncovered: uncovered.iter().filter(|&&value| value).count() as u32,
        provenance: "discovery-only deterministic greedy cover; selected indices convey no authority beyond each caller-verified typed predicate",
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn blind_cover_learns_later_features_from_remaining_observations() {
        let observations: Vec<u16> = (0..64).collect();
        let masks = [
            0b000001_u16,
            0b000010,
            0b000100,
            0b001000,
            0b010000,
            0b100000,
        ];
        let report = synthesize_predicate_cover(
            masks.len(),
            observations.len(),
            PredicateCoverBudget {
                maximum_candidates: 8,
                maximum_observations: 128,
                maximum_selected: 6,
            },
            |candidate, observation| observations[observation] & masks[candidate] != 0,
        )
        .unwrap();
        assert_eq!(&*report.selected_indices, &[0, 1, 2, 3, 4, 5]);
        assert_eq!(&*report.marginal_rejections, &[32, 16, 8, 4, 2, 1]);
        assert_eq!(report.finally_uncovered, 1);
    }

    #[test]
    fn cover_fails_before_resource_exhaustion() {
        assert_eq!(
            synthesize_predicate_cover(
                9,
                1,
                PredicateCoverBudget {
                    maximum_candidates: 8,
                    maximum_observations: 8,
                    maximum_selected: 4,
                },
                |_, _| false,
            ),
            Err(PredicateCoverError::Budget)
        );
    }

    #[test]
    fn ties_are_stable_and_do_not_encode_domain_knowledge() {
        let report = synthesize_predicate_cover(
            3,
            4,
            PredicateCoverBudget {
                maximum_candidates: 3,
                maximum_observations: 4,
                maximum_selected: 1,
            },
            |candidate, observation| (candidate + observation) % 3 == 0,
        )
        .unwrap();
        assert_eq!(&*report.selected_indices, &[0]);
    }
}
