//! Exact retained-root q29 `4+1` repair census.
//!
//! Four transfers in one row are represented by disjoint canonical donor and
//! recipient multisets, so paths and cancellations are never enumerated.
//! Labelled single-transfer targets in another row are compiled once, rejected
//! by exact PSD witnesses when possible, and bucketed by the degree-two/four
//! moment signature.  Remaining candidates pass the complete even-moment
//! theorem before a full PAF comparison and direct q29 replay.

use crate::{
    q29_complete_even_moments::extract_q29_complete_even_moments,
    q29_psd_scope_proof::{
        first_negative_q29_principal_minor, first_negative_q29_quadratic_witness,
    },
    q29_transfer_anneal::replay_q29_y,
};
use serde::Serialize;

const BLOCKS: usize = 4;
const ORDER: usize = 29;
const SHIFTS: usize = 15;
const BUCKETS: usize = ORDER * ORDER;

#[repr(C)]
#[derive(Clone, Copy)]
struct TargetRecord {
    required_paf: [i16; SHIFTS],
    required_moments: [u8; 14],
    single_block: u8,
    donor: u8,
    recipient: u8,
    _pad: [u8; 17],
}

const _: () = assert!(core::mem::size_of::<TargetRecord>() == 64);
const _: () = assert!(core::mem::align_of::<TargetRecord>() == 2);

#[repr(C)]
#[derive(Clone, Copy, Default)]
struct BucketRange {
    start: u16,
    end: u16,
    _pad: [u8; 4],
}

const _: () = assert!(core::mem::size_of::<BucketRange>() == 8);
const _: () = assert!(core::mem::align_of::<BucketRange>() == 2);

pub struct Q29FourPlusOneWorkspace {
    targets: [Box<[TargetRecord]>; BLOCKS],
    buckets: [Box<[BucketRange]>; BLOCKS],
    raw_target_count: u64,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29FourPlusOneError {
    InvalidRoot,
    TooManyTargets,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29FourPlusOneReport {
    pub target_count: u64,
    pub psd_rejected_targets: u64,
    pub canonical_states: u64,
    pub first_moment_hits: u64,
    pub energy_target_hits: u64,
    pub complete_moment_hits: u64,
    pub full_paf_checks: u64,
    pub exact_hit: bool,
    pub complete: bool,
    pub witness: Option<[[i8; ORDER]; BLOCKS]>,
    pub workspace_bytes: usize,
    pub provenance: &'static str,
}

impl Q29FourPlusOneWorkspace {
    pub fn compile(root: &[[i8; ORDER]; BLOCKS]) -> Result<Self, Q29FourPlusOneError> {
        if replay_q29_y(root).is_err() {
            return Err(Q29FourPlusOneError::InvalidRoot);
        }
        let row_paf = root.map(|row| direct_paf(&row));
        let mut combined = [0_i16; SHIFTS];
        for row in &row_paf {
            for shift in 0..SHIFTS {
                combined[shift] += row[shift];
            }
        }
        let mut targets: [Vec<TargetRecord>; BLOCKS] = std::array::from_fn(|_| Vec::new());
        let mut raw_target_count = 0_u64;
        for changed_block in 0..BLOCKS {
            for single_block in 0..BLOCKS {
                if single_block == changed_block {
                    continue;
                }
                for donor in 0..ORDER {
                    if root[single_block][donor] <= -9 {
                        continue;
                    }
                    for recipient in 0..ORDER {
                        if donor == recipient || root[single_block][recipient] >= 9 {
                            continue;
                        }
                        raw_target_count += 1;
                        let mut single_row = root[single_block];
                        single_row[donor] -= 1;
                        single_row[recipient] += 1;
                        let single_paf = direct_paf(&single_row);
                        let required_paf = std::array::from_fn(|shift| {
                            row_paf[changed_block][shift] + target_at(shift)
                                - combined[shift]
                                - (single_paf[shift] - row_paf[single_block][shift])
                        });
                        let full = expand_paf(required_paf);
                        if first_negative_q29_principal_minor(&full).is_some()
                            || first_negative_q29_quadratic_witness(&full).is_some()
                        {
                            continue;
                        }
                        targets[changed_block].push(TargetRecord {
                            required_paf,
                            required_moments: correlation_moments(&full),
                            single_block: single_block as u8,
                            donor: donor as u8,
                            recipient: recipient as u8,
                            _pad: [0; 17],
                        });
                    }
                }
            }
            if targets[changed_block].len() > u16::MAX as usize {
                return Err(Q29FourPlusOneError::TooManyTargets);
            }
            targets[changed_block]
                .sort_unstable_by_key(|target| moment_key(target.required_moments));
        }
        let targets = targets.map(Vec::into_boxed_slice);
        let buckets = std::array::from_fn(|block| compile_buckets(&targets[block]));
        Ok(Self {
            targets,
            buckets,
            raw_target_count,
        })
    }

    #[must_use]
    pub fn workspace_bytes(&self) -> usize {
        self.targets
            .iter()
            .map(|x| x.len() * core::mem::size_of::<TargetRecord>())
            .sum::<usize>()
            + BLOCKS * BUCKETS * core::mem::size_of::<BucketRange>()
    }
}

pub fn repair_q29_four_plus_one_exact(
    root: [[i8; ORDER]; BLOCKS],
    workspace: &Q29FourPlusOneWorkspace,
    state_limit: u64,
) -> Q29FourPlusOneReport {
    let mut report = Q29FourPlusOneReport {
        target_count: workspace.targets.iter().map(|x| x.len() as u64).sum(),
        psd_rejected_targets: workspace.raw_target_count
            - workspace.targets.iter().map(|x| x.len() as u64).sum::<u64>(),
        canonical_states: 0,
        first_moment_hits: 0,
        energy_target_hits: 0,
        complete_moment_hits: 0,
        full_paf_checks: 0,
        exact_hit: false,
        complete: true,
        witness: None,
        workspace_bytes: workspace.workspace_bytes(),
        provenance: "ExactComputational scoped to canonical minimal net 4+1 transfers around the source root; PSD and complete even moments are proved necessary gates; every full-key hit direct-replayed; a complete miss has no authority outside this retained-root family",
    };
    let root_moments = root.map(|row| power_moments_four(&row));
    let root_energy = root.map(|row| direct_paf(&row)[0]);
    'blocks: for changed_block in 0..BLOCKS {
        let mut donors = [0_u8; 4];
        loop {
            if multiset_within_lower_bound(&root[changed_block], donors) {
                let donor_powers = multiset_power_sums(donors);
                let mut recipients = [0_u8; 4];
                loop {
                    if disjoint(donors, recipients)
                        && multiset_within_upper_bound(&root[changed_block], recipients)
                    {
                        if report.canonical_states == state_limit {
                            report.complete = false;
                            break 'blocks;
                        }
                        report.canonical_states += 1;
                        let recipient_powers = multiset_power_sums(recipients);
                        let mut moments = root_moments[changed_block];
                        for degree in 1..=4 {
                            moments[degree] = mod29(
                                i32::from(moments[degree]) + i32::from(recipient_powers[degree])
                                    - i32::from(donor_powers[degree]),
                            );
                        }
                        let key = first_two_row_moments(moments);
                        let candidate_energy = root_energy[changed_block]
                            + multiset_energy_delta(&root[changed_block], donors, -1)
                            + multiset_energy_delta(&root[changed_block], recipients, 1);
                        let range = workspace.buckets[changed_block][key];
                        if range.start != range.end {
                            report.first_moment_hits += 1;
                            let mut candidate = root;
                            apply_multiset(&mut candidate[changed_block], donors, -1);
                            apply_multiset(&mut candidate[changed_block], recipients, 1);
                            for target in &workspace.targets[changed_block]
                                [usize::from(range.start)..usize::from(range.end)]
                            {
                                if target.required_paf[0] != candidate_energy {
                                    continue;
                                }
                                report.energy_target_hits += 1;
                                let single_block = usize::from(target.single_block);
                                candidate[single_block][usize::from(target.donor)] -= 1;
                                candidate[single_block][usize::from(target.recipient)] += 1;
                                let signature = extract_q29_complete_even_moments(&candidate);
                                if signature.accepts_exact_target() {
                                    report.complete_moment_hits += 1;
                                    let changed_paf = direct_paf(&candidate[changed_block]);
                                    report.full_paf_checks += 1;
                                    if changed_paf == target.required_paf
                                        && replay_q29_y(&candidate).is_ok_and(|x| x.exact)
                                    {
                                        report.exact_hit = true;
                                        report.witness = Some(candidate);
                                        break 'blocks;
                                    }
                                }
                                candidate[single_block][usize::from(target.donor)] += 1;
                                candidate[single_block][usize::from(target.recipient)] -= 1;
                            }
                        }
                    }
                    if !advance_multiset(&mut recipients) {
                        break;
                    }
                }
            }
            if !advance_multiset(&mut donors) {
                break;
            }
        }
    }
    report
}

fn compile_buckets(targets: &[TargetRecord]) -> Box<[BucketRange]> {
    let mut buckets = vec![BucketRange::default(); BUCKETS].into_boxed_slice();
    let mut cursor = 0_usize;
    for (key, bucket) in buckets.iter_mut().enumerate() {
        let start = cursor;
        while cursor < targets.len() && moment_key(targets[cursor].required_moments) == key {
            cursor += 1;
        }
        bucket.start = start as u16;
        bucket.end = cursor as u16;
    }
    buckets
}

#[inline(always)]
fn advance_multiset(values: &mut [u8; 4]) -> bool {
    let mut slot = 4;
    while slot != 0 {
        slot -= 1;
        if values[slot] < (ORDER - 1) as u8 {
            values[slot] += 1;
            for later in slot + 1..4 {
                values[later] = values[slot];
            }
            return true;
        }
    }
    false
}

#[inline(always)]
fn disjoint(left: [u8; 4], right: [u8; 4]) -> bool {
    !left.iter().any(|value| right.contains(value))
}

#[inline(always)]
fn multiset_within_lower_bound(row: &[i8; ORDER], values: [u8; 4]) -> bool {
    values.iter().enumerate().all(|(slot, &point)| {
        slot != 0 && values[slot - 1] == point
            || row[usize::from(point)] - values.iter().filter(|&&x| x == point).count() as i8 >= -9
    })
}

#[inline(always)]
fn multiset_within_upper_bound(row: &[i8; ORDER], values: [u8; 4]) -> bool {
    values.iter().enumerate().all(|(slot, &point)| {
        slot != 0 && values[slot - 1] == point
            || row[usize::from(point)] + values.iter().filter(|&&x| x == point).count() as i8 <= 9
    })
}

fn apply_multiset(row: &mut [i8; ORDER], values: [u8; 4], direction: i8) {
    for point in values {
        row[usize::from(point)] += direction;
    }
}

#[inline(always)]
fn multiset_energy_delta(row: &[i8; ORDER], values: [u8; 4], direction: i8) -> i16 {
    let mut delta = 0_i16;
    for slot in 0..4 {
        let point = values[slot];
        if slot != 0 && values[slot - 1] == point {
            continue;
        }
        let count = values.iter().filter(|&&value| value == point).count() as i16;
        let value = i16::from(row[usize::from(point)]);
        delta += 2 * i16::from(direction) * value * count + count * count;
    }
    delta
}

const fn point_powers() -> [[u8; 5]; ORDER] {
    let mut result = [[0_u8; 5]; ORDER];
    let mut point = 0;
    while point < ORDER {
        result[point][0] = 1;
        let mut degree = 1;
        while degree <= 4 {
            result[point][degree] =
                (result[point][degree - 1] as u16 * point as u16 % ORDER as u16) as u8;
            degree += 1;
        }
        point += 1;
    }
    result
}

const POWERS: [[u8; 5]; ORDER] = point_powers();

fn power_moments_four(row: &[i8; ORDER]) -> [u8; 5] {
    std::array::from_fn(|degree| {
        mod29(
            (0..ORDER)
                .map(|point| i32::from(row[point]) * i32::from(POWERS[point][degree]))
                .sum(),
        )
    })
}

fn multiset_power_sums(values: [u8; 4]) -> [u8; 5] {
    std::array::from_fn(|degree| {
        mod29(
            values
                .iter()
                .map(|&point| i32::from(POWERS[usize::from(point)][degree]))
                .sum(),
        )
    })
}

#[inline(always)]
fn first_two_row_moments(m: [u8; 5]) -> usize {
    let t2 = mod29(2 * i32::from(m[0]) * i32::from(m[2]) - 2 * i32::from(m[1]).pow(2));
    let t4 = mod29(
        2 * i32::from(m[0]) * i32::from(m[4]) - 8 * i32::from(m[1]) * i32::from(m[3])
            + 6 * i32::from(m[2]).pow(2),
    );
    usize::from(t2) * ORDER + usize::from(t4)
}

#[inline(always)]
fn moment_key(moments: [u8; 14]) -> usize {
    usize::from(moments[0]) * ORDER + usize::from(moments[1])
}

fn correlation_moments(correlation: &[i32; ORDER]) -> [u8; 14] {
    std::array::from_fn(|coordinate| {
        let degree = 2 * (coordinate + 1);
        mod29(
            (0..ORDER)
                .map(|shift| correlation[shift] * mod_pow(shift, degree))
                .sum(),
        )
    })
}

fn mod_pow(value: usize, exponent: usize) -> i32 {
    let mut result = 1_i32;
    for _ in 0..exponent {
        result = result * value as i32 % ORDER as i32;
    }
    result
}

#[inline(always)]
fn mod29(value: i32) -> u8 {
    value.rem_euclid(ORDER as i32) as u8
}

fn direct_paf(row: &[i8; ORDER]) -> [i16; SHIFTS] {
    std::array::from_fn(|shift| {
        (0..ORDER)
            .map(|point| i16::from(row[point]) * i16::from(row[(point + shift) % ORDER]))
            .sum()
    })
}

fn expand_paf(paf: [i16; SHIFTS]) -> [i32; ORDER] {
    std::array::from_fn(|shift| {
        i32::from(if shift < SHIFTS {
            paf[shift]
        } else {
            paf[ORDER - shift]
        })
    })
}

const fn target_at(shift: usize) -> i16 {
    if shift == 0 {
        505
    } else {
        -18
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        allocation_test::tracked_allocations, q29_even_moment_proof::retained_q29_y6_root,
    };

    #[test]
    fn bounded_census_is_allocation_free_and_directly_scored() {
        let root = retained_q29_y6_root();
        let workspace = Q29FourPlusOneWorkspace::compile(&root).unwrap();
        let (_, allocations) = tracked_allocations(|| {
            let report = repair_q29_four_plus_one_exact(root, &workspace, 100_000);
            assert_eq!(report.canonical_states, 100_000);
            assert!(!report.complete);
            assert!(!report.exact_hit);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn first_two_moments_agree_with_direct_correlation() {
        let mut row = retained_q29_y6_root()[2];
        let moments = power_moments_four(&row);
        let direct = correlation_moments(&expand_paf(direct_paf(&row)));
        assert_eq!(first_two_row_moments(moments), moment_key(direct));
        row[0] -= 1;
        row[1] += 1;
        let moments = power_moments_four(&row);
        let direct = correlation_moments(&expand_paf(direct_paf(&row)));
        assert_eq!(first_two_row_moments(moments), moment_key(direct));
    }
}
