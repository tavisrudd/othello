use std::convert::Infallible;

use anyhow::Result;
use ergodis::{CyclicOrbitLocks, FinitePermutationAction};
use serde::Serialize;

const LENGTH: u32 = 333;
const GENERATORS: [&[u32]; 6] = [&[1], &[73], &[112], &[10], &[121], &[211]];

struct MultiplierAction<'a> {
    generators: &'a [u32],
}

impl FinitePermutationAction for MultiplierAction<'_> {
    type Error = Infallible;

    fn point_count(&self) -> u32 {
        LENGTH
    }

    fn generator_count(&self) -> u32 {
        self.generators.len() as u32
    }

    fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error> {
        Ok((point * self.generators[generator as usize]) % LENGTH)
    }
}

#[derive(Debug, PartialEq, Eq, Serialize)]
struct CountMultiplicity {
    value: u32,
    multiplicity: u32,
}

#[derive(Debug, PartialEq, Eq, Serialize)]
struct ReplayCase {
    stable_id: u32,
    orbit_size_counts: Vec<CountMultiplicity>,
    locked_position_spectrum: Vec<CountMultiplicity>,
    maximum_locked_positions: u32,
    maximum_lock_shifts: Vec<u32>,
    joint_change_upper_bound: u64,
    excluded: bool,
}

#[derive(Serialize)]
struct ReplayReport {
    schema: &'static str,
    carrier_size: u32,
    required_joint_change: u64,
    cases: Vec<ReplayCase>,
    excluded_ids: Vec<u32>,
}

fn multiplicities(values: &[u32], maximum_value: u32) -> Vec<CountMultiplicity> {
    let mut counts = vec![0_u32; maximum_value as usize + 1];
    for &value in values {
        counts[value as usize] += 1;
    }
    counts
        .into_iter()
        .enumerate()
        .filter_map(|(value, multiplicity)| {
            (multiplicity != 0).then_some(CountMultiplicity {
                value: value as u32,
                multiplicity,
            })
        })
        .collect()
}

fn replay_case(stable_id: u32, generators: &[u32]) -> ReplayCase {
    let action = MultiplierAction { generators };
    let locks = CyclicOrbitLocks::compile(&action).expect("multipliers are permutations");
    let mut locked = vec![0_u32; LENGTH as usize];
    assert!(locks.write_locked_counts(&mut locked));
    let nonzero = &locked[1..];
    let maximum_locked_positions = *nonzero.iter().max().expect("nonzero shifts exist");
    let maximum_lock_shifts: Vec<u32> = nonzero
        .iter()
        .enumerate()
        .filter_map(|(offset, &value)| {
            (value == maximum_locked_positions).then_some(offset as u32 + 1)
        })
        .collect();
    let joint_change_upper_bound = locks
        .joint_change_upper_bound(maximum_lock_shifts[0], 2)
        .expect("maximum shift is valid");
    ReplayCase {
        stable_id,
        orbit_size_counts: multiplicities(locks.orbit_sizes(), LENGTH),
        locked_position_spectrum: multiplicities(nonzero, LENGTH),
        maximum_locked_positions,
        maximum_lock_shifts,
        joint_change_upper_bound,
        excluded: joint_change_upper_bound < u64::from(LENGTH + 1),
    }
}

fn replay() -> ReplayReport {
    let cases: Vec<_> = GENERATORS
        .iter()
        .enumerate()
        .map(|(stable_id, generators)| replay_case(stable_id as u32, generators))
        .collect();
    let excluded_ids = cases
        .iter()
        .filter_map(|case| case.excluded.then_some(case.stable_id))
        .collect();
    ReplayReport {
        schema: "lp333-orbit-lock-ergodis-replay-v1",
        carrier_size: LENGTH,
        required_joint_change: u64::from(LENGTH + 1),
        cases,
        excluded_ids,
    }
}

fn main() -> Result<()> {
    println!("{}", serde_json::to_string_pretty(&replay())?);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;

    fn pairs(values: &[(u32, u32)]) -> Vec<CountMultiplicity> {
        values
            .iter()
            .map(|&(value, multiplicity)| CountMultiplicity {
                value,
                multiplicity,
            })
            .collect()
    }

    #[test]
    fn reproduces_all_six_spectra_and_unique_exclusion() {
        let report = replay();
        let expected_orbits = [
            vec![(1, 333)],
            vec![(1, 9), (2, 162)],
            vec![(1, 111), (3, 74)],
            vec![(1, 9), (3, 108)],
            vec![(1, 3), (3, 110)],
            vec![(1, 3), (3, 110)],
        ];
        let expected_spectra = [
            vec![(0, 332)],
            vec![(0, 296), (9, 36)],
            vec![(0, 330), (222, 2)],
            vec![(0, 296), (18, 36)],
            vec![(0, 222), (6, 110)],
            vec![(0, 222), (6, 110)],
        ];
        for (index, case) in report.cases.iter().enumerate() {
            assert_eq!(case.orbit_size_counts, pairs(&expected_orbits[index]));
            assert_eq!(
                case.locked_position_spectrum,
                pairs(&expected_spectra[index])
            );
        }
        assert_eq!(report.excluded_ids, [2]);
        assert_eq!(report.cases[2].maximum_lock_shifts, [111, 222]);
        assert_eq!(report.cases[2].joint_change_upper_bound, 222);
    }

    #[test]
    fn agrees_with_committed_independent_certificate() {
        let certificate: Value = serde_json::from_str(include_str!(
            "../../../notes/2026-07-31-c740-hadamard-668-residual-orbit-locks.json"
        ))
        .unwrap();
        let report = replay();
        let recorded_cases = certificate["cases"].as_array().unwrap();
        for (case, recorded) in report.cases.iter().zip(recorded_cases) {
            assert_eq!(u64::from(case.stable_id), recorded["id"].as_u64().unwrap());
            assert_eq!(
                u64::from(case.maximum_locked_positions),
                recorded["maximum_locked_positions"].as_u64().unwrap()
            );
            assert_eq!(
                case.joint_change_upper_bound,
                recorded["joint_hamming_upper_bound_at_maximum_lock"]
                    .as_u64()
                    .unwrap()
            );
            let recorded_shifts: Vec<_> = recorded["maximum_lock_shifts"]
                .as_array()
                .unwrap()
                .iter()
                .map(|value| value.as_u64().unwrap() as u32)
                .collect();
            assert_eq!(case.maximum_lock_shifts, recorded_shifts);
        }
    }
}
