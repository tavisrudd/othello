//! Bounded exact meet-in-the-middle join for q58 anti profiles.
//!
//! The four-block target is `sum energy = 523` and `sum residuals = 0`.
//! Pair energy therefore gives 524 disjoint complementary layers.  Within one
//! layer, seven residuals in `[-523, 523]` occupy 77 bits; together with two
//! 16-bit source-profile IDs, the complete exact join record is one `u128`.

use serde::Serialize;
use thiserror::Error;

use crate::g41_q58_exact_tablebase::G41Q58AntiProfile;
use crate::g41_q58_gram_masks::G41Q58DenseGramPredicate;

const TARGET: u16 = 523;
const ENERGIES: usize = TARGET as usize + 1;
const RESIDUAL_BITS: u32 = 11;
const RESIDUAL_OFFSET: i32 = 523;
const ID_BITS: u32 = 20;
const MAX_PROFILE_IDS: usize = 1 << ID_BITS;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q58ProfileJoinError {
    #[error("q58 profile join semantic binding failed")]
    SemanticMismatch,
    #[error("q58 profile join layer {energy} needs {entries} entries, above budget {budget}")]
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
}

const _: () =
    assert!(std::mem::size_of::<HotProfile>() == 16 && std::mem::align_of::<HotProfile>() == 2);

#[repr(transparent)]
#[derive(Clone, Copy, Default, PartialEq, Eq, PartialOrd, Ord)]
struct PairEntry(u128);

const _: () =
    assert!(std::mem::size_of::<PairEntry>() == 16 && std::mem::align_of::<PairEntry>() == 16);

impl PairEntry {
    #[inline(always)]
    fn new(key: u128, first: u32, second: u32) -> Self {
        Self((key << (2 * ID_BITS)) | (u128::from(first) << ID_BITS) | u128::from(second))
    }

    #[inline(always)]
    fn key(self) -> u128 {
        self.0 >> (2 * ID_BITS)
    }

    fn ids(self) -> [u32; 2] {
        [
            ((self.0 >> ID_BITS) & (MAX_PROFILE_IDS as u128 - 1)) as u32,
            (self.0 & (MAX_PROFILE_IDS as u128 - 1)) as u32,
        ]
    }
}

struct EnergyBins {
    offsets: [u32; ENERGIES + 1],
    ids: Box<[u32]>,
}

impl EnergyBins {
    fn compile(profiles: &[G41Q58AntiProfile]) -> Result<Self, G41Q58ProfileJoinError> {
        if profiles.len() > MAX_PROFILE_IDS {
            return Err(G41Q58ProfileJoinError::SemanticMismatch);
        }
        let mut counts = [0_u32; ENERGIES];
        for &profile in profiles {
            let energy = usize::from(profile.energy());
            if energy >= ENERGIES {
                return Err(G41Q58ProfileJoinError::SemanticMismatch);
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
            let energy = usize::from(profile.energy());
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
    fn compile(source: &[G41Q58AntiProfile]) -> Result<Self, G41Q58ProfileJoinError> {
        let mut profiles = Vec::with_capacity(source.len());
        for &profile in source {
            let energy = i32::from(profile.energy());
            let residuals = std::array::from_fn(|coordinate| profile.residual(coordinate).unwrap());
            if residuals
                .iter()
                .any(|&residual| i32::from(residual).abs() > energy)
            {
                return Err(G41Q58ProfileJoinError::SemanticMismatch);
            }
            let zero_square = profile
                .zero_frequency_square()
                .and_then(|value| u16::try_from(value).ok())
                .ok_or(G41Q58ProfileJoinError::SemanticMismatch)?;
            profiles.push(HotProfile {
                residuals,
                zero_square,
            });
        }
        Ok(Self {
            bins: EnergyBins::compile(source)?,
            profiles: profiles.into_boxed_slice(),
        })
    }
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58ProfileJoinMatch {
    pub profile_ids: [u32; 4],
    pub pair_energy: u16,
    pub pair_residuals: [i16; 7],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58ProfileJoinReport {
    pub layers_visited: u16,
    pub right_pairs_checked: u64,
    pub right_pairs_retained: u64,
    pub left_pairs_checked: u64,
    pub left_pairs_retained: u64,
    pub maximum_layer_entries: u64,
    pub maximum_layer_bytes: u64,
    pub first_match: Option<G41Q58ProfileJoinMatch>,
    pub complete: bool,
    pub provenance: &'static str,
}

#[inline(always)]
fn pair_terms(left: HotProfile, right: HotProfile) -> (u16, [i16; 7]) {
    (
        left.zero_square + right.zero_square,
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
fn residuals_fit_key(residuals: [i16; 7]) -> bool {
    residuals
        .into_iter()
        .all(|residual| i32::from(residual).abs() <= i32::from(TARGET))
}

#[inline(always)]
fn residual_key(residuals: [i16; 7]) -> u128 {
    let mut key = 0_u128;
    for residual in residuals {
        let lane = i32::from(residual) + RESIDUAL_OFFSET;
        debug_assert!((0..1 << RESIDUAL_BITS).contains(&lane));
        key = (key << RESIDUAL_BITS) | lane as u128;
    }
    key
}

fn count_layer(
    first: &CompiledSet,
    second: &CompiledSet,
    energy: u16,
    predicates: &[G41Q58DenseGramPredicate],
) -> (u64, u64) {
    let mut checked = 0_u64;
    let mut retained = 0_u64;
    for first_energy in 0..=usize::from(energy) {
        let second_energy = usize::from(energy) - first_energy;
        for &first_id in first.bins.at(first_energy) {
            let left = first.profiles[first_id as usize];
            for &second_id in second.bins.at(second_energy) {
                checked += 1;
                let right = second.profiles[second_id as usize];
                let (zero_square, residuals) = pair_terms(left, right);
                retained += u64::from(
                    zero_square <= TARGET
                        && residuals_fit_key(residuals)
                        && predicates_hold(energy, residuals, predicates),
                );
            }
        }
    }
    (checked, retained)
}

fn fill_layer(
    first: &CompiledSet,
    second: &CompiledSet,
    energy: u16,
    predicates: &[G41Q58DenseGramPredicate],
    output: &mut [PairEntry],
) -> usize {
    let mut written = 0_usize;
    for first_energy in 0..=usize::from(energy) {
        let second_energy = usize::from(energy) - first_energy;
        for &first_id in first.bins.at(first_energy) {
            let left = first.profiles[first_id as usize];
            for &second_id in second.bins.at(second_energy) {
                let right = second.profiles[second_id as usize];
                let (zero_square, residuals) = pair_terms(left, right);
                if zero_square <= TARGET
                    && residuals_fit_key(residuals)
                    && predicates_hold(energy, residuals, predicates)
                {
                    output[written] = PairEntry::new(residual_key(residuals), first_id, second_id);
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
    energy: u16,
    predicates: &[G41Q58DenseGramPredicate],
    right_entries: &[PairEntry],
) -> (u64, u64, Option<([u32; 2], [u32; 2], [i16; 7])>) {
    let mut checked = 0_u64;
    let mut retained = 0_u64;
    for first_energy in 0..=usize::from(energy) {
        let second_energy = usize::from(energy) - first_energy;
        for &first_id in first.bins.at(first_energy) {
            let left = first.profiles[first_id as usize];
            for &second_id in second.bins.at(second_energy) {
                checked += 1;
                let right = second.profiles[second_id as usize];
                let (zero_square, residuals) = pair_terms(left, right);
                if zero_square > TARGET
                    || !residuals_fit_key(residuals)
                    || !predicates_hold(energy, residuals, predicates)
                {
                    continue;
                }
                retained += 1;
                let target = residual_key(residuals.map(|residual| -residual));
                let position = right_entries.partition_point(|entry| entry.key() < target);
                if position < right_entries.len() && right_entries[position].key() == target {
                    return (
                        checked,
                        retained,
                        Some((
                            [first_id, second_id],
                            right_entries[position].ids(),
                            residuals,
                        )),
                    );
                }
            }
        }
    }
    (checked, retained, None)
}

/// Search the exact profile quartet join.  The supplied predicates may only
/// remove pair terms through their sealed Gram-square semantics.
pub fn search_g41_q58_profile_join(
    profiles: [&[G41Q58AntiProfile]; 4],
    predicates: &[G41Q58DenseGramPredicate],
    maximum_layer_entries: u64,
) -> Result<G41Q58ProfileJoinReport, G41Q58ProfileJoinError> {
    let sets = [
        CompiledSet::compile(profiles[0])?,
        CompiledSet::compile(profiles[1])?,
        CompiledSet::compile(profiles[2])?,
        CompiledSet::compile(profiles[3])?,
    ];
    let mut report = G41Q58ProfileJoinReport {
        layers_visited: 0,
        right_pairs_checked: 0,
        right_pairs_retained: 0,
        left_pairs_checked: 0,
        left_pairs_retained: 0,
        maximum_layer_entries: 0,
        maximum_layer_bytes: 0,
        first_match: None,
        complete: false,
        provenance: "sealed integer Gram predicates; exact complementary energy layers; collision-free 77-bit residual keys; bounded iterative pair scans",
    };
    for layer_index in 0..=TARGET {
        let radius = layer_index / 2;
        let right_energy = if layer_index % 2 == 0 {
            261 - radius
        } else {
            262 + radius
        };
        let (right_checked, right_retained) =
            count_layer(&sets[1], &sets[3], right_energy, predicates);
        report.right_pairs_checked += right_checked;
        report.right_pairs_retained += right_retained;
        report.maximum_layer_entries = report.maximum_layer_entries.max(right_retained);
        report.maximum_layer_bytes = report
            .maximum_layer_bytes
            .max(right_retained * std::mem::size_of::<PairEntry>() as u64);
        if right_retained > maximum_layer_entries || right_retained > usize::MAX as u64 {
            return Err(G41Q58ProfileJoinError::LayerBudget {
                energy: right_energy,
                entries: right_retained,
                budget: maximum_layer_entries,
            });
        }
        let mut right_entries = vec![PairEntry::default(); right_retained as usize];
        let written = fill_layer(
            &sets[1],
            &sets[3],
            right_energy,
            predicates,
            &mut right_entries,
        );
        if written != right_entries.len() {
            return Err(G41Q58ProfileJoinError::SemanticMismatch);
        }
        right_entries.sort_unstable();
        let left_energy = TARGET - right_energy;
        let (left_checked, left_retained, found) =
            find_in_layer(&sets[0], &sets[2], left_energy, predicates, &right_entries);
        report.left_pairs_checked += left_checked;
        report.left_pairs_retained += left_retained;
        report.layers_visited += 1;
        if let Some((left_ids, right_ids, residuals)) = found {
            report.first_match = Some(G41Q58ProfileJoinMatch {
                profile_ids: [left_ids[0], right_ids[0], left_ids[1], right_ids[1]],
                pair_energy: left_energy,
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

    #[test]
    fn residual_key_is_exact_and_complemented_coordinatewise() {
        let first = [-523, -17, -1, 0, 1, 17, 523];
        let second = first.map(|value| -value);
        assert_ne!(residual_key(first), residual_key(second));
        assert_eq!(residual_key([0; 7]), residual_key(second.map(|_| 0)));
        assert!(residuals_fit_key([-523, -17, -1, 0, 1, 17, 523]));
        assert!(!residuals_fit_key([524, 0, 0, 0, 0, 0, 0]));
        assert!(!residuals_fit_key([-524, 0, 0, 0, 0, 0, 0]));
    }

    #[test]
    fn packed_pair_entry_round_trips_exact_ids_and_key() {
        let key = residual_key([-523, -17, -1, 0, 1, 17, 523]);
        let entry = PairEntry::new(key, 786_431, 700_123);
        assert_eq!(entry.key(), key);
        assert_eq!(entry.ids(), [786_431, 700_123]);
    }

    #[test]
    fn presized_fill_kernel_allocates_nothing() {
        let profiles = Box::new([
            HotProfile {
                residuals: [0; 7],
                zero_square: 0,
            },
            HotProfile {
                residuals: [1; 7],
                zero_square: 1,
            },
        ]);
        let mut offsets = [0_u32; ENERGIES + 1];
        offsets[1..].fill(2);
        let set = CompiledSet {
            profiles,
            bins: EnergyBins {
                offsets,
                ids: Box::new([0, 1]),
            },
        };
        let mut output = [PairEntry::default(); 4];
        let (written, allocations) =
            tracked_allocations(|| fill_layer(&set, &set, 0, &[], &mut output));
        assert_eq!(written, 4);
        assert_eq!(allocations, 0);
    }

    #[test]
    fn pair_layer_rejects_residuals_outside_the_collision_free_key_domain() {
        let profiles = Box::new([
            HotProfile {
                residuals: [523; 7],
                zero_square: 0,
            },
            HotProfile {
                residuals: [1; 7],
                zero_square: 0,
            },
        ]);
        let mut offsets = [0_u32; ENERGIES + 1];
        offsets[1..].fill(2);
        let set = CompiledSet {
            profiles,
            bins: EnergyBins {
                offsets,
                ids: Box::new([0, 1]),
            },
        };
        assert_eq!(count_layer(&set, &set, 0, &[]), (4, 1));
        let mut output = [PairEntry::default(); 1];
        assert_eq!(fill_layer(&set, &set, 0, &[], &mut output), 1);
    }
}
