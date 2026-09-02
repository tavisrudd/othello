//! Bounded exact pair-table neighbourhoods for g41 q29 profile joins.

use serde::Serialize;

use crate::g41_q29_exact_tablebase::G41Q29ExactProfile;
use crate::g41_q29_profile_descent::G41Q29ProfileJoinCandidate;

const BLOCKS: usize = 4;
const COORDINATES: usize = 7;
const TARGET: u16 = 523;
pub const MAX_NEIGHBORHOOD: usize = 8_192;

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileEndgameReport {
    pub neighborhood_limit: u16,
    pub neighborhood_sizes: [u16; 4],
    pub left_pairs_generated: u64,
    pub distinct_left_pair_sums: u64,
    pub right_pairs_probed: u64,
    pub hit: Option<G41Q29ProfileJoinCandidate>,
    pub provenance: &'static str,
}

fn profile_values(profile: G41Q29ExactProfile) -> [u16; COORDINATES] {
    std::array::from_fn(|coordinate| profile.coordinate(coordinate))
}

fn distance(left: G41Q29ExactProfile, right: G41Q29ExactProfile) -> u16 {
    (0..COORDINATES)
        .map(|coordinate| {
            left.coordinate(coordinate)
                .abs_diff(right.coordinate(coordinate))
        })
        .sum()
}

fn select_neighborhood(profiles: &[G41Q29ExactProfile], center: u32, limit: usize) -> Vec<u32> {
    let center_profile = profiles[center as usize];
    let mut scored = Vec::with_capacity(profiles.len());
    for (index, &profile) in profiles.iter().enumerate() {
        scored.push((distance(profile, center_profile), index as u32));
    }
    if scored.len() > limit {
        scored.select_nth_unstable_by_key(limit, |&(score, index)| (score, index));
        scored.truncate(limit);
    }
    scored.sort_unstable();
    scored.into_iter().map(|(_, index)| index).collect()
}

#[inline(always)]
fn bounded_sum(
    first: G41Q29ExactProfile,
    second: G41Q29ExactProfile,
) -> Option<G41Q29ExactProfile> {
    let mut values = [0_u16; COORDINATES];
    for coordinate in 0..COORDINATES {
        let sum = first.coordinate(coordinate) + second.coordinate(coordinate);
        if sum > TARGET {
            return None;
        }
        values[coordinate] = sum;
    }
    Some(G41Q29ExactProfile::from_coordinates(values))
}

fn join_neighborhoods_into(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    neighborhoods: [&[u32]; BLOCKS],
    left: &mut Vec<G41Q29ExactProfile>,
) -> (Option<G41Q29ProfileJoinCandidate>, u64, u64) {
    left.clear();
    let mut left_pairs_generated = 0_u64;
    for &first in neighborhoods[0] {
        for &second in neighborhoods[2] {
            if let Some(sum) = bounded_sum(sets[0][first as usize], sets[2][second as usize]) {
                left_pairs_generated += 1;
                left.push(sum);
            }
        }
    }
    left.sort_unstable();
    left.dedup();
    let mut right_pairs_probed = 0_u64;
    for &first in neighborhoods[1] {
        for &second in neighborhoods[3] {
            right_pairs_probed += 1;
            let Some(sum) = bounded_sum(sets[1][first as usize], sets[3][second as usize]) else {
                continue;
            };
            let needed_values = profile_values(sum).map(|value| TARGET - value);
            let needed = G41Q29ExactProfile::from_coordinates(needed_values);
            if left.binary_search(&needed).is_err() {
                continue;
            }
            let mut recovered = None;
            'recover: for &left_first in neighborhoods[0] {
                for &left_second in neighborhoods[2] {
                    if bounded_sum(sets[0][left_first as usize], sets[2][left_second as usize])
                        == Some(needed)
                    {
                        recovered = Some((left_first, left_second));
                        break 'recover;
                    }
                }
            }
            let Some((left_first, left_second)) = recovered else {
                continue;
            };
            let indices = [left_first, first, left_second, second];
            return (
                Some(G41Q29ProfileJoinCandidate {
                    indices,
                    sums: [TARGET; COORDINATES],
                    residual: 0,
                    _pad: [0; 30],
                }),
                left_pairs_generated,
                right_pairs_probed,
            );
        }
    }
    (None, left_pairs_generated, right_pairs_probed)
}

pub fn repair_g41_q29_profile_endgame(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    initial: G41Q29ProfileJoinCandidate,
    limit: usize,
) -> G41Q29ProfileEndgameReport {
    assert!((1..=MAX_NEIGHBORHOOD).contains(&limit));
    assert!((0..BLOCKS).all(|block| (initial.indices[block] as usize) < sets[block].len()));
    let neighborhoods: [Vec<u32>; BLOCKS] = std::array::from_fn(|block| {
        select_neighborhood(sets[block], initial.indices[block], limit)
    });
    let neighborhood_refs = std::array::from_fn(|block| neighborhoods[block].as_slice());
    let capacity = neighborhoods[0].len() * neighborhoods[2].len();
    let mut left = Vec::with_capacity(capacity);
    let (hit, left_pairs_generated, right_pairs_probed) =
        join_neighborhoods_into(sets, neighborhood_refs, &mut left);
    if let Some(candidate) = hit {
        let replayed = std::array::from_fn(|coordinate| {
            (0..BLOCKS)
                .map(|block| sets[block][candidate.indices[block] as usize].coordinate(coordinate))
                .sum::<u16>()
        });
        assert_eq!(replayed, candidate.sums);
    }
    G41Q29ProfileEndgameReport {
        neighborhood_limit: limit as u16,
        neighborhood_sizes: std::array::from_fn(|block| neighborhoods[block].len() as u16),
        left_pairs_generated,
        distinct_left_pair_sums: left.len() as u64,
        right_pairs_probed,
        hit,
        provenance: "discovery-only exact complement join over four independently distance-scoped profile neighbourhoods; the hot table stores only 16-byte sums and recovers indices by replay after a hit; any hit is directly replayed as exact profile sums, while a miss excludes only the reported finite neighbourhood product",
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn profile(values: [u16; 7]) -> G41Q29ExactProfile {
        G41Q29ExactProfile::from_coordinates(values)
    }

    #[test]
    fn local_pair_table_finds_and_replays_hit() {
        let a = [profile([100; 7]), profile([101; 7])];
        let b = [profile([120; 7]), profile([123; 7])];
        let c = [profile([180; 7]), profile([177; 7])];
        let sets: [&[G41Q29ExactProfile]; 4] = [&a, &b, &c, &b];
        let initial = G41Q29ProfileJoinCandidate {
            indices: [1, 0, 0, 0],
            sums: [521; 7],
            residual: 14,
            _pad: [0; 30],
        };
        let report = repair_g41_q29_profile_endgame(sets, initial, 2);
        assert_eq!(report.hit.unwrap().sums, [523; 7]);
    }

    #[test]
    fn preallocated_join_kernel_does_not_allocate() {
        let a = [profile([100; 7])];
        let b = [profile([123; 7])];
        let c = [profile([177; 7])];
        let indices = [0_u32];
        let sets: [&[G41Q29ExactProfile]; 4] = [&a, &b, &c, &b];
        let mut left = Vec::with_capacity(1);
        let ((hit, _, _), allocations) =
            tracked_allocations(|| join_neighborhoods_into(sets, [&indices; 4], &mut left));
        assert!(hit.is_some());
        assert_eq!(allocations, 0);
    }
}
