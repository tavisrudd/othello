//! Exact four-block join for common q174 refinement profiles.

use serde::Serialize;
use thiserror::Error;

use crate::g41_q174_joint::{G41Q174JointProfile, G41_Q174_Q87_SCOPED_DEFECTS};
use crate::g41_q58_gram_masks::G41Q58DenseGramPredicate;

const TARGET: u16 = 523;
const ENERGIES: usize = TARGET as usize + 1;
const ID_BITS: u32 = 20;
const MAX_PROFILE_IDS: usize = 1 << ID_BITS;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q174JointJoinError {
    #[error("q174 joint join semantic binding failed")]
    SemanticMismatch,
    #[error("q174 joint join q58 layer {energy} needs {entries} entries, above budget {budget}")]
    LayerBudget {
        energy: u16,
        entries: u64,
        budget: u64,
    },
}

#[repr(C)]
#[derive(Clone, Copy)]
struct HotProfile {
    residuals: [i16; 7],
    zero_square: u16,
    q87_energy: u16,
    q87_defects: [u16; G41_Q174_Q87_SCOPED_DEFECTS],
}

const _: () = assert!(std::mem::size_of::<HotProfile>() == 22);

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct PairKey {
    q87_energy: u16,
    q87_defects: [u16; G41_Q174_Q87_SCOPED_DEFECTS],
    residuals: [i16; 7],
}

const _: () = assert!(std::mem::size_of::<PairKey>() == 20);

#[repr(C)]
#[derive(Clone, Copy, Default, PartialEq, Eq, PartialOrd, Ord)]
struct PairEntry {
    key: PairKey,
    first: u32,
    second: u32,
}

const _: () = assert!(std::mem::size_of::<PairEntry>() == 28);

impl PairEntry {
    #[inline(always)]
    fn new(key: PairKey, first: u32, second: u32) -> Self {
        Self { key, first, second }
    }

    #[inline(always)]
    fn key(self) -> PairKey {
        self.key
    }

    fn ids(self) -> [u32; 2] {
        [self.first, self.second]
    }
}

struct EnergyBins {
    offsets: [u32; ENERGIES + 1],
    ids: Box<[u32]>,
}

impl EnergyBins {
    fn compile(profiles: &[G41Q174JointProfile]) -> Result<Self, G41Q174JointJoinError> {
        if profiles.len() > MAX_PROFILE_IDS {
            return Err(G41Q174JointJoinError::SemanticMismatch);
        }
        let mut counts = [0_u32; ENERGIES];
        for profile in profiles {
            let energy = usize::from(profile.q58_energy);
            if energy >= ENERGIES {
                return Err(G41Q174JointJoinError::SemanticMismatch);
            }
            counts[energy] += 1;
        }
        let mut offsets = [0_u32; ENERGIES + 1];
        for energy in 0..ENERGIES {
            offsets[energy + 1] = offsets[energy] + counts[energy];
        }
        let mut cursor = offsets;
        let mut ids = vec![0_u32; profiles.len()].into_boxed_slice();
        for (id, profile) in profiles.iter().enumerate() {
            let energy = usize::from(profile.q58_energy);
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

struct CompiledSet {
    profiles: Box<[HotProfile]>,
    bins: EnergyBins,
}

impl CompiledSet {
    fn compile(source: &[G41Q174JointProfile]) -> Result<Self, G41Q174JointJoinError> {
        let mut profiles = Vec::with_capacity(source.len());
        for profile in source {
            let residuals = *profile.q58_residuals.as_array();
            if residuals
                .iter()
                .any(|&residual| i32::from(residual).abs() > i32::from(profile.q58_energy))
            {
                return Err(G41Q174JointJoinError::SemanticMismatch);
            }
            let zero_square: u16 = (i32::from(profile.q58_energy)
                + 4 * residuals.iter().map(|&value| i32::from(value)).sum::<i32>())
            .try_into()
            .map_err(|_| G41Q174JointJoinError::SemanticMismatch)?;
            profiles.push(HotProfile {
                residuals,
                zero_square,
                q87_energy: profile.q87_energy,
                q87_defects: profile.q87_defects,
            });
        }
        Ok(Self {
            bins: EnergyBins::compile(source)?,
            profiles: profiles.into_boxed_slice(),
        })
    }
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174JointJoinMatch {
    pub profile_ids: [u32; 4],
    pub pair_q58_energy: u16,
    pub pair_q87_energy: u16,
    pub pair_q87_defects: [u16; G41_Q174_Q87_SCOPED_DEFECTS],
    pub pair_residuals: [i16; 7],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174JointJoinReport {
    pub layers_visited: u16,
    pub right_pairs_checked: u64,
    pub right_pairs_retained: u64,
    pub left_pairs_checked: u64,
    pub left_pairs_retained: u64,
    pub maximum_layer_entries: u64,
    pub maximum_layer_bytes: u64,
    pub first_match: Option<G41Q174JointJoinMatch>,
    pub complete: bool,
    pub provenance: &'static str,
}

#[inline(always)]
fn pair_terms(
    left: HotProfile,
    right: HotProfile,
) -> (u16, u16, [u16; G41_Q174_Q87_SCOPED_DEFECTS], [i16; 7]) {
    (
        left.zero_square + right.zero_square,
        left.q87_energy + right.q87_energy,
        std::array::from_fn(|coordinate| {
            left.q87_defects[coordinate] + right.q87_defects[coordinate]
        }),
        std::array::from_fn(|coordinate| left.residuals[coordinate] + right.residuals[coordinate]),
    )
}

#[inline(always)]
fn predicates_hold(
    energy: u16,
    residuals: [i16; 7],
    predicates: &[G41Q58DenseGramPredicate],
) -> bool {
    predicates.iter().all(|predicate| {
        predicate.terminal_from_terms(energy, residuals)
            <= i64::from(predicate.norm_square) * i64::from(TARGET)
    })
}

#[inline(always)]
fn residuals_fit(residuals: [i16; 7]) -> bool {
    residuals
        .into_iter()
        .all(|residual| i32::from(residual).abs() <= i32::from(TARGET))
}

#[inline(always)]
fn joint_key(
    q87_energy: u16,
    q87_defects: [u16; G41_Q174_Q87_SCOPED_DEFECTS],
    residuals: [i16; 7],
) -> PairKey {
    PairKey {
        q87_energy,
        q87_defects,
        residuals,
    }
}

fn count_layer(
    first: &CompiledSet,
    second: &CompiledSet,
    q58_energy: u16,
    predicates: &[G41Q58DenseGramPredicate],
) -> (u64, u64) {
    let mut checked = 0_u64;
    let mut retained = 0_u64;
    for first_energy in 0..=usize::from(q58_energy) {
        let second_energy = usize::from(q58_energy) - first_energy;
        for &first_id in first.bins.at(first_energy) {
            let left = first.profiles[first_id as usize];
            for &second_id in second.bins.at(second_energy) {
                checked += 1;
                let right = second.profiles[second_id as usize];
                let (zero_square, q87_energy, q87_defects, residuals) = pair_terms(left, right);
                retained += u64::from(
                    zero_square <= TARGET
                        && q87_energy <= TARGET
                        && q87_defects.into_iter().all(|defect| defect <= TARGET)
                        && residuals_fit(residuals)
                        && predicates_hold(q58_energy, residuals, predicates),
                );
            }
        }
    }
    (checked, retained)
}

fn fill_layer(
    first: &CompiledSet,
    second: &CompiledSet,
    q58_energy: u16,
    predicates: &[G41Q58DenseGramPredicate],
    output: &mut [PairEntry],
) -> usize {
    let mut written = 0;
    for first_energy in 0..=usize::from(q58_energy) {
        let second_energy = usize::from(q58_energy) - first_energy;
        for &first_id in first.bins.at(first_energy) {
            let left = first.profiles[first_id as usize];
            for &second_id in second.bins.at(second_energy) {
                let right = second.profiles[second_id as usize];
                let (zero_square, q87_energy, q87_defects, residuals) = pair_terms(left, right);
                if zero_square <= TARGET
                    && q87_energy <= TARGET
                    && q87_defects.into_iter().all(|defect| defect <= TARGET)
                    && residuals_fit(residuals)
                    && predicates_hold(q58_energy, residuals, predicates)
                {
                    output[written] = PairEntry::new(
                        joint_key(q87_energy, q87_defects, residuals),
                        first_id,
                        second_id,
                    );
                    written += 1;
                }
            }
        }
    }
    written
}

fn find_in_layer(
    first: &CompiledSet,
    second: &CompiledSet,
    q58_energy: u16,
    predicates: &[G41Q58DenseGramPredicate],
    right_entries: &[PairEntry],
) -> (
    u64,
    u64,
    Option<(
        [u32; 2],
        [u32; 2],
        u16,
        [u16; G41_Q174_Q87_SCOPED_DEFECTS],
        [i16; 7],
    )>,
) {
    let mut checked = 0_u64;
    let mut retained = 0_u64;
    for first_energy in 0..=usize::from(q58_energy) {
        let second_energy = usize::from(q58_energy) - first_energy;
        for &first_id in first.bins.at(first_energy) {
            let left = first.profiles[first_id as usize];
            for &second_id in second.bins.at(second_energy) {
                checked += 1;
                let right = second.profiles[second_id as usize];
                let (zero_square, q87_energy, q87_defects, residuals) = pair_terms(left, right);
                if zero_square > TARGET
                    || q87_energy > TARGET
                    || q87_defects.into_iter().any(|defect| defect > TARGET)
                    || !residuals_fit(residuals)
                    || !predicates_hold(q58_energy, residuals, predicates)
                {
                    continue;
                }
                retained += 1;
                let target = joint_key(
                    TARGET - q87_energy,
                    q87_defects.map(|defect| TARGET - defect),
                    residuals.map(|residual| -residual),
                );
                let position = right_entries.partition_point(|entry| entry.key() < target);
                if position < right_entries.len() && right_entries[position].key() == target {
                    return (
                        checked,
                        retained,
                        Some((
                            [first_id, second_id],
                            right_entries[position].ids(),
                            q87_energy,
                            q87_defects,
                            residuals,
                        )),
                    );
                }
            }
        }
    }
    (checked, retained, None)
}

pub fn search_g41_q174_joint_join(
    profiles: [&[G41Q174JointProfile]; 4],
    predicates: &[G41Q58DenseGramPredicate],
    maximum_layer_entries: u64,
) -> Result<G41Q174JointJoinReport, G41Q174JointJoinError> {
    let sets = [
        CompiledSet::compile(profiles[0])?,
        CompiledSet::compile(profiles[1])?,
        CompiledSet::compile(profiles[2])?,
        CompiledSet::compile(profiles[3])?,
    ];
    let mut report = G41Q174JointJoinReport {
        layers_visited: 0,
        right_pairs_checked: 0,
        right_pairs_retained: 0,
        left_pairs_checked: 0,
        left_pairs_retained: 0,
        maximum_layer_entries: 0,
        maximum_layer_bytes: 0,
        first_match: None,
        complete: false,
        provenance: "sealed q58 integer Gram predicates; exact complementary q58 energy layers; collision-free joint key of q87 pair energy and seven q58 residuals; bounded iterative pair scans",
    };
    for layer_index in 0..=TARGET {
        let radius = layer_index / 2;
        let right_q58 = if layer_index % 2 == 0 {
            261 - radius
        } else {
            262 + radius
        };
        let (checked, retained) = count_layer(&sets[1], &sets[3], right_q58, predicates);
        report.right_pairs_checked += checked;
        report.right_pairs_retained += retained;
        report.maximum_layer_entries = report.maximum_layer_entries.max(retained);
        report.maximum_layer_bytes = report
            .maximum_layer_bytes
            .max(retained * std::mem::size_of::<PairEntry>() as u64);
        if retained > maximum_layer_entries || retained > usize::MAX as u64 {
            return Err(G41Q174JointJoinError::LayerBudget {
                energy: right_q58,
                entries: retained,
                budget: maximum_layer_entries,
            });
        }
        let mut right_entries = vec![PairEntry::default(); retained as usize];
        if fill_layer(
            &sets[1],
            &sets[3],
            right_q58,
            predicates,
            &mut right_entries,
        ) != right_entries.len()
        {
            return Err(G41Q174JointJoinError::SemanticMismatch);
        }
        right_entries.sort_unstable();
        let left_q58 = TARGET - right_q58;
        let (checked, retained, found) =
            find_in_layer(&sets[0], &sets[2], left_q58, predicates, &right_entries);
        report.left_pairs_checked += checked;
        report.left_pairs_retained += retained;
        report.layers_visited += 1;
        if let Some((left_ids, right_ids, q87_energy, q87_defects, residuals)) = found {
            report.first_match = Some(G41Q174JointJoinMatch {
                profile_ids: [left_ids[0], right_ids[0], left_ids[1], right_ids[1]],
                pair_q58_energy: left_q58,
                pair_q87_energy: q87_energy,
                pair_q87_defects: q87_defects,
                pair_residuals: residuals,
            });
            return Ok(report);
        }
    }
    report.complete = true;
    Ok(report)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;
    use crate::feature_synthesis::ResidualTuple;

    #[test]
    fn joint_pair_key_round_trips_ids_and_separates_q87_energy() {
        let residuals = [-523, -17, -1, 0, 1, 17, 523];
        let first = PairEntry::new(joint_key(19, [1, 2], residuals), 700_123, 786_431);
        let second = PairEntry::new(joint_key(20, [1, 2], residuals), 700_123, 786_431);
        assert_ne!(first.key(), second.key());
        assert_eq!(first.ids(), [700_123, 786_431]);
    }

    #[test]
    fn presized_joint_fill_allocates_nothing_hot() {
        let source = [G41Q174JointProfile {
            q58_energy: 0,
            q58_residuals: ResidualTuple::from_array([0; 7]),
            q87_energy: 0,
            q87_defects: [0; G41_Q174_Q87_SCOPED_DEFECTS],
        }];
        let set = CompiledSet::compile(&source).unwrap();
        let mut output = [PairEntry::default(); 1];
        let (written, allocations) =
            tracked_allocations(|| fill_layer(&set, &set, 0, &[], &mut output));
        assert_eq!(written, 1);
        assert_eq!(allocations, 0);
    }
}
