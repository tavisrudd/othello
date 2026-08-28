//! Compact observations for application families defined by exact minima.

use thiserror::Error;

#[derive(Debug, Error, PartialEq, Eq)]
pub enum FamilyResponseError {
    #[error("probe-response matrix has length {actual}, expected {expected}")]
    ResponseShape { expected: usize, actual: usize },
    #[error("minima family {family} is empty")]
    EmptyFamily { family: usize },
    #[error("minima family {family} names unknown probe {probe}")]
    UnknownProbe { family: usize, probe: u32 },
    #[error("a response count or offset exceeds compact storage")]
    Overflow,
}

/// Dense state observation IDs plus one flat payload per distinct response.
#[derive(Clone, Debug)]
pub struct FamilyResponseTable {
    observations: Box<[u32]>,
    family_count: u32,
    unique_responses: Box<[u32]>,
}

impl FamilyResponseTable {
    pub fn observations(&self) -> &[u32] {
        &self.observations
    }

    pub fn family_count(&self) -> u32 {
        self.family_count
    }

    pub fn response_count(&self) -> usize {
        if self.family_count == 0 {
            usize::from(!self.observations.is_empty())
        } else {
            self.unique_responses.len() / self.family_count as usize
        }
    }

    pub fn response(&self, observation: u32) -> Option<&[u32]> {
        if observation as usize >= self.response_count() {
            return None;
        }
        let width = self.family_count as usize;
        let start = (observation as usize).checked_mul(width)?;
        self.unique_responses.get(start..start + width)
    }
}

/// Compile exact application observations
/// `response(state, family) = min_{probe in family} value(state, probe)`.
///
/// `probe_responses` is state-major. Construction uses one flat response
/// matrix and a sorted state-index vector; equal potentially large vectors are
/// stored once without duplicate hash-table keys.
pub fn compile_minima_family_responses<T: AsRef<[u32]>>(
    state_count: u32,
    probe_count: u32,
    probe_responses: &[u32],
    families: &[T],
) -> Result<FamilyResponseTable, FamilyResponseError> {
    let expected = (state_count as usize)
        .checked_mul(probe_count as usize)
        .ok_or(FamilyResponseError::Overflow)?;
    if probe_responses.len() != expected {
        return Err(FamilyResponseError::ResponseShape {
            expected,
            actual: probe_responses.len(),
        });
    }
    if families.len() > u32::MAX as usize {
        return Err(FamilyResponseError::Overflow);
    }
    for (family, probes) in families.iter().enumerate() {
        let probes = probes.as_ref();
        if probes.is_empty() {
            return Err(FamilyResponseError::EmptyFamily { family });
        }
        if let Some(&probe) = probes.iter().find(|&&probe| probe >= probe_count) {
            return Err(FamilyResponseError::UnknownProbe { family, probe });
        }
    }

    let family_count = families.len();
    let response_len = (state_count as usize)
        .checked_mul(family_count)
        .ok_or(FamilyResponseError::Overflow)?;
    let mut state_responses = Vec::with_capacity(response_len);
    for state in 0..state_count as usize {
        let row =
            &probe_responses[state * probe_count as usize..(state + 1) * probe_count as usize];
        for family in families {
            let probes = family.as_ref();
            let mut minimum = row[probes[0] as usize];
            for &probe in &probes[1..] {
                minimum = minimum.min(row[probe as usize]);
            }
            state_responses.push(minimum);
        }
    }

    let mut order: Vec<u32> = (0..state_count).collect();
    order.sort_unstable_by(|&left, &right| {
        response_row(&state_responses, family_count, left).cmp(response_row(
            &state_responses,
            family_count,
            right,
        ))
    });
    let mut observations = vec![0_u32; state_count as usize];
    let mut unique_responses = Vec::with_capacity(response_len);
    let mut unique_count = 0_u32;
    for state in order {
        let response = response_row(&state_responses, family_count, state);
        let is_new = unique_count == 0
            || response
                != &unique_responses[(unique_count as usize - 1) * family_count
                    ..unique_count as usize * family_count];
        if is_new {
            unique_responses.extend_from_slice(response);
            unique_count = unique_count
                .checked_add(1)
                .ok_or(FamilyResponseError::Overflow)?;
        }
        observations[state as usize] = unique_count - 1;
    }
    unique_responses.shrink_to_fit();
    Ok(FamilyResponseTable {
        observations: observations.into_boxed_slice(),
        family_count: family_count as u32,
        unique_responses: unique_responses.into_boxed_slice(),
    })
}

fn response_row(responses: &[u32], family_count: usize, state: u32) -> &[u32] {
    let start = state as usize * family_count;
    &responses[start..start + family_count]
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::observational::{compile_observational, FinitePresentation};

    #[test]
    fn minima_families_deduplicate_equal_response_vectors() {
        let table = compile_minima_family_responses(
            3,
            3,
            &[5, 2, 9, 5, 7, 1, 8, 2, 9],
            &[vec![0, 1], vec![2]],
        )
        .unwrap();
        assert_eq!(table.family_count(), 2);
        assert_eq!(table.response_count(), 2);
        assert_eq!(table.observations()[0], table.observations()[2]);
        assert_ne!(table.observations()[0], table.observations()[1]);
        assert_eq!(table.response(table.observations()[0]), Some(&[2, 9][..]));

        let base = FinitePresentation::new([3], [0, 1, 2], []).unwrap();
        let observed = base.reobserve(table.observations().to_vec()).unwrap();
        let compiled = compile_observational(&observed).unwrap();
        assert_eq!(compiled.state_classes()[0], compiled.state_classes()[2]);
    }

    #[test]
    fn malformed_families_are_rejected() {
        assert_eq!(
            compile_minima_family_responses(1, 1, &[7], &[Vec::<u32>::new()]).unwrap_err(),
            FamilyResponseError::EmptyFamily { family: 0 }
        );
        assert_eq!(
            compile_minima_family_responses(1, 1, &[7], &[vec![1]]).unwrap_err(),
            FamilyResponseError::UnknownProbe {
                family: 0,
                probe: 1
            }
        );
        assert_eq!(
            compile_minima_family_responses(2, 2, &[1], &[vec![0]]).unwrap_err(),
            FamilyResponseError::ResponseShape {
                expected: 4,
                actual: 1
            }
        );
    }

    #[test]
    fn empty_observation_alphabet_merges_all_states_without_sentinels() {
        let families: Vec<Vec<u32>> = Vec::new();
        let table = compile_minima_family_responses(2, 0, &[], &families).unwrap();
        assert_eq!(table.observations(), &[0, 0]);
        assert_eq!(table.response_count(), 1);
        assert_eq!(table.response(0), Some(&[][..]));
        assert_eq!(table.response(1), None);
    }
}
