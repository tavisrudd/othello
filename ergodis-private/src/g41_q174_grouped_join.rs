//! Hierarchical exact four-block join for q174 profiles.
//!
//! The q58 profile is the outer sufficient interface.  Exact q87 vectors are
//! retained as fibres and are joined only after complementary q58 groups meet.

use serde::Serialize;
use thiserror::Error;

use crate::g41_q174_joint::{G41Q174JointProfile, G41_Q174_Q87_SCOPED_DEFECTS};
use crate::g41_q58_gram_masks::G41Q58DenseGramPredicate;

const TARGET: u16 = 523;
const ENERGIES: usize = TARGET as usize + 1;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q174GroupedJoinError {
    #[error("q174 grouped join semantic binding failed")]
    SemanticMismatch,
    #[error("q174 grouped join layer {energy} needs {entries} entries, above budget {budget}")]
    LayerBudget {
        energy: u16,
        entries: u64,
        budget: u64,
    },
    #[error("q174 grouped join q87 fibre pair needs {entries} entries, above budget {budget}")]
    FibreBudget { entries: u64, budget: u64 },
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct ResidualKey([i16; 7]);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct Q58Group {
    residuals: ResidualKey,
    energy: u16,
    zero_square: u16,
    start: u32,
    end: u32,
}

const _: () = assert!(std::mem::size_of::<Q58Group>() == 28);

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct GroupPairEntry {
    residuals: ResidualKey,
    first: u32,
    second: u32,
}

const _: () = assert!(std::mem::size_of::<GroupPairEntry>() == 24);

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct Q87Key([u16; 1 + G41_Q174_Q87_SCOPED_DEFECTS]);

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct Q87PairEntry {
    key: Q87Key,
    first: u32,
    second: u32,
}

const _: () = assert!(std::mem::size_of::<Q87PairEntry>() == 16);

struct EnergyBins {
    offsets: [u32; ENERGIES + 1],
    ids: Box<[u32]>,
}

impl EnergyBins {
    fn compile(groups: &[Q58Group]) -> Result<Self, G41Q174GroupedJoinError> {
        let mut counts = [0_u32; ENERGIES];
        for group in groups {
            let energy = usize::from(group.energy);
            if energy >= ENERGIES {
                return Err(G41Q174GroupedJoinError::SemanticMismatch);
            }
            counts[energy] = counts[energy]
                .checked_add(1)
                .ok_or(G41Q174GroupedJoinError::SemanticMismatch)?;
        }
        let mut offsets = [0_u32; ENERGIES + 1];
        for energy in 0..ENERGIES {
            offsets[energy + 1] = offsets[energy]
                .checked_add(counts[energy])
                .ok_or(G41Q174GroupedJoinError::SemanticMismatch)?;
        }
        let mut cursor = offsets;
        let mut ids = vec![0_u32; groups.len()].into_boxed_slice();
        for (id, group) in groups.iter().enumerate() {
            let energy = usize::from(group.energy);
            ids[cursor[energy] as usize] = id as u32;
            cursor[energy] += 1;
        }
        Ok(Self { offsets, ids })
    }

    #[inline(always)]
    fn at(&self, energy: usize) -> &[u32] {
        &self.ids[self.offsets[energy] as usize..self.offsets[energy + 1] as usize]
    }
}

struct CompiledSet<'a> {
    profiles: &'a [G41Q174JointProfile],
    groups: Box<[Q58Group]>,
    bins: EnergyBins,
    maximum_fibre: u32,
}

impl<'a> CompiledSet<'a> {
    fn compile(profiles: &'a [G41Q174JointProfile]) -> Result<Self, G41Q174GroupedJoinError> {
        if profiles.len() > u32::MAX as usize {
            return Err(G41Q174GroupedJoinError::SemanticMismatch);
        }
        let mut groups = Vec::new();
        let mut start = 0_usize;
        while start < profiles.len() {
            let profile = profiles[start];
            let energy = profile.q58_energy;
            let residuals = ResidualKey(*profile.q58_residuals.as_array());
            let mut end = start + 1;
            while end < profiles.len()
                && profiles[end].q58_energy == energy
                && profiles[end].q58_residuals == profile.q58_residuals
            {
                end += 1;
            }
            if start != 0 {
                let previous = profiles[start - 1];
                if (previous.q58_energy, previous.q58_residuals) >= (energy, profile.q58_residuals)
                {
                    return Err(G41Q174GroupedJoinError::SemanticMismatch);
                }
            }
            for candidate in &profiles[start..end] {
                if candidate.q87_energy > TARGET
                    || candidate
                        .q87_defects
                        .into_iter()
                        .any(|defect| defect > TARGET)
                {
                    return Err(G41Q174GroupedJoinError::SemanticMismatch);
                }
            }
            let zero_square: u16 = (i32::from(energy)
                + 4 * residuals
                    .0
                    .iter()
                    .map(|&value| i32::from(value))
                    .sum::<i32>())
            .try_into()
            .map_err(|_| G41Q174GroupedJoinError::SemanticMismatch)?;
            groups.push(Q58Group {
                residuals,
                energy,
                zero_square,
                start: start as u32,
                end: end as u32,
            });
            start = end;
        }
        let groups = groups.into_boxed_slice();
        let maximum_fibre = groups
            .iter()
            .map(|group| group.end - group.start)
            .max()
            .unwrap_or(0);
        Ok(Self {
            bins: EnergyBins::compile(&groups)?,
            profiles,
            groups,
            maximum_fibre,
        })
    }
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174GroupedJoinMatch {
    pub profile_ids: [u32; 4],
    pub pair_q58_energy: u16,
    pub pair_q58_residuals: [i16; 7],
    pub pair_q87: [u16; 1 + G41_Q174_Q87_SCOPED_DEFECTS],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174GroupedJoinReport {
    pub q58_groups: [u32; 4],
    pub maximum_q87_fibres: [u32; 4],
    pub layers_visited: u16,
    pub right_group_pairs_checked: u64,
    pub right_group_pairs_retained: u64,
    pub left_group_pairs_checked: u64,
    pub complementary_group_quartets: u64,
    pub q87_right_pairs_built: u64,
    pub q87_left_pairs_checked: u64,
    pub maximum_layer_entries: u64,
    pub maximum_fibre_pair_entries: u64,
    pub workspace_bytes: u64,
    pub first_match: Option<G41Q174GroupedJoinMatch>,
    pub sampled_matches: Box<[G41Q174GroupedJoinMatch]>,
    pub complete: bool,
    pub provenance: &'static str,
}

#[inline(always)]
fn residual_sum(first: ResidualKey, second: ResidualKey) -> ResidualKey {
    ResidualKey(std::array::from_fn(|i| first.0[i] + second.0[i]))
}

#[inline(always)]
fn predicates_hold(
    energy: u16,
    residuals: ResidualKey,
    predicates: &[G41Q58DenseGramPredicate],
) -> bool {
    residuals
        .0
        .into_iter()
        .all(|value| i32::from(value).abs() <= i32::from(TARGET))
        && predicates.iter().all(|predicate| {
            predicate.terminal_from_terms(energy, residuals.0)
                <= i64::from(predicate.norm_square) * i64::from(TARGET)
        })
}

#[inline(always)]
fn q87_key(profile: G41Q174JointProfile) -> Q87Key {
    Q87Key([
        profile.q87_energy,
        profile.q87_defects[0],
        profile.q87_defects[1],
        profile.q87_defects[2],
    ])
}

#[inline(always)]
fn q87_sum(first: Q87Key, second: Q87Key) -> Option<Q87Key> {
    let mut sum = [0_u16; 1 + G41_Q174_Q87_SCOPED_DEFECTS];
    for coordinate in 0..1 + G41_Q174_Q87_SCOPED_DEFECTS {
        sum[coordinate] = first.0[coordinate] + second.0[coordinate];
        if sum[coordinate] > TARGET {
            return None;
        }
    }
    Some(Q87Key(sum))
}

#[inline(always)]
fn q87_complement(key: Q87Key) -> Q87Key {
    Q87Key(key.0.map(|value| TARGET - value))
}

fn count_group_layer(
    first: &CompiledSet<'_>,
    second: &CompiledSet<'_>,
    energy: u16,
    predicates: &[G41Q58DenseGramPredicate],
) -> (u64, u64) {
    let mut checked = 0_u64;
    let mut retained = 0_u64;
    for first_energy in 0..=usize::from(energy) {
        let second_energy = usize::from(energy) - first_energy;
        for &first_id in first.bins.at(first_energy) {
            let left = first.groups[first_id as usize];
            for &second_id in second.bins.at(second_energy) {
                checked += 1;
                let right = second.groups[second_id as usize];
                let residuals = residual_sum(left.residuals, right.residuals);
                retained += u64::from(
                    left.zero_square + right.zero_square <= TARGET
                        && predicates_hold(energy, residuals, predicates),
                );
            }
        }
    }
    (checked, retained)
}

fn fill_group_layer(
    first: &CompiledSet<'_>,
    second: &CompiledSet<'_>,
    energy: u16,
    predicates: &[G41Q58DenseGramPredicate],
    output: &mut [GroupPairEntry],
) -> usize {
    let mut written = 0_usize;
    for first_energy in 0..=usize::from(energy) {
        let second_energy = usize::from(energy) - first_energy;
        for &first_id in first.bins.at(first_energy) {
            let left = first.groups[first_id as usize];
            for &second_id in second.bins.at(second_energy) {
                let right = second.groups[second_id as usize];
                let residuals = residual_sum(left.residuals, right.residuals);
                if left.zero_square + right.zero_square <= TARGET
                    && predicates_hold(energy, residuals, predicates)
                {
                    output[written] = GroupPairEntry {
                        residuals,
                        first: first_id,
                        second: second_id,
                    };
                    written += 1;
                }
            }
        }
    }
    written
}

fn join_q87_fibres(
    sets: &[CompiledSet<'_>; 4],
    groups: [u32; 4],
    scratch: &mut Vec<Q87PairEntry>,
    mut observe: impl FnMut([u32; 4], Q87Key) -> bool,
) -> Result<(u64, u64, bool), G41Q174GroupedJoinError> {
    scratch.clear();
    let right_first = sets[1].groups[groups[1] as usize];
    let right_second = sets[3].groups[groups[3] as usize];
    let required = u64::from(right_first.end - right_first.start)
        * u64::from(right_second.end - right_second.start);
    if required > scratch.capacity() as u64 {
        return Err(G41Q174GroupedJoinError::FibreBudget {
            entries: required,
            budget: scratch.capacity() as u64,
        });
    }
    for first in right_first.start..right_first.end {
        let first_key = q87_key(sets[1].profiles[first as usize]);
        for second in right_second.start..right_second.end {
            if let Some(key) = q87_sum(first_key, q87_key(sets[3].profiles[second as usize])) {
                scratch.push(Q87PairEntry { key, first, second });
            }
        }
    }
    scratch.sort_unstable();
    let built = scratch.len() as u64;
    let left_first = sets[0].groups[groups[0] as usize];
    let left_second = sets[2].groups[groups[2] as usize];
    let mut checked = 0_u64;
    for first in left_first.start..left_first.end {
        let first_key = q87_key(sets[0].profiles[first as usize]);
        for second in left_second.start..left_second.end {
            checked += 1;
            let Some(key) = q87_sum(first_key, q87_key(sets[2].profiles[second as usize])) else {
                continue;
            };
            let target = q87_complement(key);
            let start = scratch.partition_point(|entry| entry.key < target);
            let end = scratch.partition_point(|entry| entry.key <= target);
            for right in &scratch[start..end] {
                if observe([first, right.first, second, right.second], key) {
                    return Ok((built, checked, true));
                }
            }
        }
    }
    Ok((built, checked, false))
}

pub fn scan_g41_q174_grouped_join(
    profiles: [&[G41Q174JointProfile]; 4],
    predicates: &[G41Q58DenseGramPredicate],
    maximum_layer_entries: u64,
    maximum_fibre_pair_entries: usize,
    maximum_matches: usize,
) -> Result<G41Q174GroupedJoinReport, G41Q174GroupedJoinError> {
    if maximum_layer_entries == 0 || maximum_fibre_pair_entries == 0 || maximum_matches == 0 {
        return Err(G41Q174GroupedJoinError::SemanticMismatch);
    }
    let sets = [
        CompiledSet::compile(profiles[0])?,
        CompiledSet::compile(profiles[1])?,
        CompiledSet::compile(profiles[2])?,
        CompiledSet::compile(profiles[3])?,
    ];
    let mut report = G41Q174GroupedJoinReport {
        q58_groups: sets.each_ref().map(|set| set.groups.len() as u32),
        maximum_q87_fibres: sets.each_ref().map(|set| set.maximum_fibre),
        layers_visited: 0,
        right_group_pairs_checked: 0,
        right_group_pairs_retained: 0,
        left_group_pairs_checked: 0,
        complementary_group_quartets: 0,
        q87_right_pairs_built: 0,
        q87_left_pairs_checked: 0,
        maximum_layer_entries: 0,
        maximum_fibre_pair_entries: 0,
        workspace_bytes: maximum_layer_entries
            .saturating_mul(std::mem::size_of::<GroupPairEntry>() as u64)
            + maximum_fibre_pair_entries as u64
                * std::mem::size_of::<Q87PairEntry>() as u64,
        first_match: None,
        sampled_matches: Box::new([]),
        complete: false,
        provenance: "exact hierarchical q174 join; canonical q58 groups are the outer sufficient interface, q87 energy plus three explicitly bound distinct defect classes form presorted broad fibres, and q87 fibres are consulted only for complementary q58 residual groups; both reusable workspaces are bounded and presized",
    };
    let mut q87_scratch = Vec::with_capacity(maximum_fibre_pair_entries);
    let mut sampled_matches = Vec::with_capacity(maximum_matches);
    for layer_index in 0..=TARGET {
        let radius = layer_index / 2;
        let right_energy = if layer_index % 2 == 0 {
            261 - radius
        } else {
            262 + radius
        };
        let (checked, retained) = count_group_layer(&sets[1], &sets[3], right_energy, predicates);
        report.right_group_pairs_checked += checked;
        report.right_group_pairs_retained += retained;
        report.maximum_layer_entries = report.maximum_layer_entries.max(retained);
        if retained > maximum_layer_entries || retained > usize::MAX as u64 {
            return Err(G41Q174GroupedJoinError::LayerBudget {
                energy: right_energy,
                entries: retained,
                budget: maximum_layer_entries,
            });
        }
        let mut right = vec![GroupPairEntry::default(); retained as usize];
        if fill_group_layer(&sets[1], &sets[3], right_energy, predicates, &mut right) != right.len()
        {
            return Err(G41Q174GroupedJoinError::SemanticMismatch);
        }
        right.sort_unstable();
        let left_energy = TARGET - right_energy;
        for first_energy in 0..=usize::from(left_energy) {
            let second_energy = usize::from(left_energy) - first_energy;
            for &first_id in sets[0].bins.at(first_energy) {
                let first = sets[0].groups[first_id as usize];
                for &second_id in sets[2].bins.at(second_energy) {
                    report.left_group_pairs_checked += 1;
                    let second = sets[2].groups[second_id as usize];
                    let residuals = residual_sum(first.residuals, second.residuals);
                    if first.zero_square + second.zero_square > TARGET
                        || !predicates_hold(left_energy, residuals, predicates)
                    {
                        continue;
                    }
                    let target = ResidualKey(residuals.0.map(|value| -value));
                    let start = right.partition_point(|entry| entry.residuals < target);
                    let end = right.partition_point(|entry| entry.residuals <= target);
                    for entry in &right[start..end] {
                        report.complementary_group_quartets += 1;
                        let right_first = sets[1].groups[entry.first as usize];
                        let right_second = sets[3].groups[entry.second as usize];
                        report.maximum_fibre_pair_entries = report.maximum_fibre_pair_entries.max(
                            u64::from(right_first.end - right_first.start)
                                * u64::from(right_second.end - right_second.start),
                        );
                        let (built, checked, full) = join_q87_fibres(
                            &sets,
                            [first_id, entry.first, second_id, entry.second],
                            &mut q87_scratch,
                            |profile_ids, q87| {
                                sampled_matches.push(G41Q174GroupedJoinMatch {
                                    profile_ids,
                                    pair_q58_energy: left_energy,
                                    pair_q58_residuals: residuals.0,
                                    pair_q87: q87.0,
                                });
                                sampled_matches.len() == maximum_matches
                            },
                        )?;
                        report.q87_right_pairs_built += built;
                        report.q87_left_pairs_checked += checked;
                        if full {
                            report.first_match = sampled_matches.first().copied();
                            report.sampled_matches = sampled_matches.into_boxed_slice();
                            report.layers_visited += 1;
                            return Ok(report);
                        }
                    }
                }
            }
        }
        report.layers_visited += 1;
    }
    report.complete = true;
    report.first_match = sampled_matches.first().copied();
    report.sampled_matches = sampled_matches.into_boxed_slice();
    Ok(report)
}

pub fn search_g41_q174_grouped_join(
    profiles: [&[G41Q174JointProfile]; 4],
    predicates: &[G41Q58DenseGramPredicate],
    maximum_layer_entries: u64,
    maximum_fibre_pair_entries: usize,
) -> Result<G41Q174GroupedJoinReport, G41Q174GroupedJoinError> {
    scan_g41_q174_grouped_join(
        profiles,
        predicates,
        maximum_layer_entries,
        maximum_fibre_pair_entries,
        1,
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;
    use crate::feature_synthesis::ResidualTuple;

    fn profile(residual: i16, q87: [u16; 1 + G41_Q174_Q87_SCOPED_DEFECTS]) -> G41Q174JointProfile {
        G41Q174JointProfile {
            q58_energy: q87[0],
            q58_residuals: ResidualTuple::from_array([residual; 7]),
            q87_energy: q87[0],
            q87_defects: [q87[1], q87[2], q87[3]],
        }
    }

    #[test]
    fn grouped_join_finds_exact_four_coordinate_complement() {
        let blocks = [
            [profile(0, [100; 4])],
            [profile(0, [120; 4])],
            [profile(0, [123; 4])],
            [profile(0, [180; 4])],
        ];
        let report = search_g41_q174_grouped_join(
            [&blocks[0], &blocks[1], &blocks[2], &blocks[3]],
            &[],
            8,
            8,
        )
        .unwrap();
        assert_eq!(report.first_match.unwrap().profile_ids, [0; 4]);
    }

    #[test]
    fn q87_fibre_kernel_allocates_nothing_with_presized_scratch() {
        let blocks = [
            [profile(0, [100; 4])],
            [profile(0, [120; 4])],
            [profile(0, [123; 4])],
            [profile(0, [180; 4])],
        ];
        let sets = [
            CompiledSet::compile(&blocks[0]).unwrap(),
            CompiledSet::compile(&blocks[1]).unwrap(),
            CompiledSet::compile(&blocks[2]).unwrap(),
            CompiledSet::compile(&blocks[3]).unwrap(),
        ];
        let mut scratch = Vec::with_capacity(8);
        let mut found = None;
        let (result, allocations) = tracked_allocations(|| {
            join_q87_fibres(&sets, [0; 4], &mut scratch, |ids, key| {
                found = Some((ids, key));
                true
            })
        });
        assert!(result.unwrap().2);
        assert!(found.is_some());
        assert_eq!(allocations, 0);
    }
}
