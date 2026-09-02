//! Learned coarse q29 pair keys with exact full-signature replay.
//!
//! Ergodis may choose a cheap coordinate mask and comparison order, but that
//! choice has performance authority only.  Every table hit is checked against
//! all fifteen exact cyclic-PAF coordinates before it is returned.

use ergodis::{evolve_ranked_streaming, EvolutionConfig};
use serde::Serialize;
use sha2::{Digest, Sha256};

use crate::proof_synthesis::{ExtractorDescriptor, ProvenanceClass};
use crate::q29_even_moment_proof::retained_q29_y6_root;

pub const Q29_PAIR_COORDINATES: usize = 15;
const ORDER: usize = 29;
const BLOCKS: usize = 4;
const MAX_CORPUS_KEYS: usize = 512;
const EXTRACTOR_ID: [u8; 16] = *b"c1016-q29pair001";
const EXTRACTOR_VERSION: u16 = 1;
const PARAMETER_SEMANTICS: &[u8] = b"ergodis-private/q29-pair-key/v1; carrier=522; compression=18; quotient=29; coordinates=PAF_X(s)+PAF_Y(s), s=0..14; real cyclic symmetry; exact full-key replay mandatory";

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, Ord, PartialOrd, Eq, PartialEq, Serialize)]
pub struct Q29PairKey {
    pub coordinates: [i16; Q29_PAIR_COORDINATES],
    pub _pad: u16,
}

const _: () = assert!(std::mem::size_of::<Q29PairKey>() == 32);
const _: () = assert!(std::mem::align_of::<Q29PairKey>() == 2);

#[repr(C)]
#[derive(Clone, Copy, Debug, Ord, PartialOrd, Eq, PartialEq, Serialize)]
pub struct Q29PairMask {
    pub order: [u8; Q29_PAIR_COORDINATES],
    pub length: u8,
}

const _: () = assert!(std::mem::size_of::<Q29PairMask>() == 16);
const _: () = assert!(std::mem::align_of::<Q29PairMask>() == 1);

impl Q29PairMask {
    #[must_use]
    pub const fn full() -> Self {
        Self {
            order: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
            length: Q29_PAIR_COORDINATES as u8,
        }
    }

    fn singleton(coordinate: u8) -> Self {
        let mut order = [0_u8; Q29_PAIR_COORDINATES];
        order[0] = coordinate;
        Self { order, length: 1 }
    }

    fn contains(self, coordinate: u8) -> bool {
        self.order[..usize::from(self.length)].contains(&coordinate)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
struct Q29PairSlot {
    coordinates: [i16; Q29_PAIR_COORDINATES],
    tag: u16,
}

const _: () = assert!(std::mem::size_of::<Q29PairSlot>() == 32);
const _: () = assert!(std::mem::align_of::<Q29PairSlot>() == 2);

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq, Serialize)]
pub struct Q29PairLookupCounters {
    pub lookups: u64,
    pub probes: u64,
    pub tagged_candidates: u64,
    pub exact_coordinate_comparisons: u64,
    pub exact_hits: u64,
}

pub struct Q29PairTable {
    slots: Box<[Q29PairSlot]>,
    mask: Q29PairMask,
}

impl Q29PairTable {
    pub fn with_capacity(mask: Q29PairMask, keys: usize) -> Option<Self> {
        if keys == 0 || mask.length == 0 || usize::from(mask.length) > Q29_PAIR_COORDINATES {
            return None;
        }
        let slots = keys.checked_mul(2)?.next_power_of_two().max(2);
        Some(Self {
            slots: vec![Q29PairSlot::default(); slots].into_boxed_slice(),
            mask,
        })
    }

    pub fn insert(&mut self, key: Q29PairKey) -> bool {
        let hash = masked_hash(&key, self.mask);
        let tag = hash_tag(hash);
        let mut slot = hash as usize & (self.slots.len() - 1);
        for _ in 0..self.slots.len() {
            let record = &mut self.slots[slot];
            if record.tag == 0 {
                record.coordinates = key.coordinates;
                record.tag = tag;
                return true;
            }
            if record.tag == tag && record.coordinates == key.coordinates {
                return true;
            }
            slot = (slot + 1) & (self.slots.len() - 1);
        }
        false
    }

    /// Allocation-free exact membership lookup.  The learned mask controls
    /// only the bucket; acceptance always compares the complete signature.
    pub fn contains_exact(&self, key: &Q29PairKey, counters: &mut Q29PairLookupCounters) -> bool {
        counters.lookups += 1;
        let hash = masked_hash(key, self.mask);
        let tag = hash_tag(hash);
        let mut slot = hash as usize & (self.slots.len() - 1);
        for _ in 0..self.slots.len() {
            counters.probes += 1;
            let record = &self.slots[slot];
            if record.tag == 0 {
                return false;
            }
            if record.tag == tag {
                counters.tagged_candidates += 1;
                let mut equal = true;
                for coordinate in 0..Q29_PAIR_COORDINATES {
                    counters.exact_coordinate_comparisons += 1;
                    if record.coordinates[coordinate] != key.coordinates[coordinate] {
                        equal = false;
                        break;
                    }
                }
                if equal {
                    counters.exact_hits += 1;
                    return true;
                }
            }
            slot = (slot + 1) & (self.slots.len() - 1);
        }
        false
    }
}

fn hash_tag(hash: u64) -> u16 {
    ((hash >> 32) as u16) | 1
}

fn masked_hash(key: &Q29PairKey, mask: Q29PairMask) -> u64 {
    let mut hash = 0xcbf2_9ce4_8422_2325_u64;
    for &coordinate in &mask.order[..usize::from(mask.length)] {
        hash ^= i64::from(key.coordinates[usize::from(coordinate)]) as u64;
        hash = hash.wrapping_mul(0x100_0000_01b3);
    }
    hash
}

fn full_hash(key: &Q29PairKey) -> u64 {
    masked_hash(key, Q29PairMask::full())
}

fn source_commitment() -> [u8; 32] {
    let mut hash = Sha256::new();
    for row in retained_q29_y6_root() {
        for value in row {
            hash.update(value.to_le_bytes());
        }
    }
    hash.finalize().into()
}

fn extractor_descriptor() -> ExtractorDescriptor {
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        Sha256::digest(PARAMETER_SEMANTICS).into(),
        source_commitment(),
    )
}

#[must_use]
pub fn extract_q29_pair_key(
    rows: &[[i8; ORDER]; BLOCKS],
    first: usize,
    second: usize,
) -> Option<Q29PairKey> {
    if first >= BLOCKS || second >= BLOCKS || first == second {
        return None;
    }
    let mut key = Q29PairKey::default();
    for shift in 0..Q29_PAIR_COORDINATES {
        let mut value = 0_i32;
        for &block in &[first, second] {
            for point in 0..ORDER {
                value +=
                    i32::from(rows[block][point]) * i32::from(rows[block][(point + shift) % ORDER]);
            }
        }
        key.coordinates[shift] = i16::try_from(value).ok()?;
    }
    Some(key)
}

fn retained_corpus() -> Box<[Q29PairKey]> {
    let root = retained_q29_y6_root();
    let mut keys = Vec::with_capacity(2 * (1 + 2 * ORDER * (ORDER - 1) / 2));
    for &(first, second) in &[(0_usize, 1_usize), (2, 3)] {
        keys.push(extract_q29_pair_key(&root, first, second).expect("retained q29 pair"));
        for block in [first, second] {
            for left in 0..ORDER {
                for right in left + 1..ORDER {
                    if root[block][left] == root[block][right] {
                        continue;
                    }
                    let mut rows = root;
                    rows[block].swap(left, right);
                    keys.push(
                        extract_q29_pair_key(&rows, first, second).expect("bounded q29 pair"),
                    );
                }
            }
        }
    }
    keys.sort_unstable();
    keys.dedup();
    keys.sort_unstable_by_key(|key| (full_hash(key), *key));
    keys.truncate(MAX_CORPUS_KEYS);
    keys.into_boxed_slice()
}

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
struct MaskScore {
    false_exact_results: u32,
    coarse_collisions: u64,
    coordinate_tests: u64,
    length: u8,
}

fn score_mask(keys: &[Q29PairKey], fold: usize, mask: Q29PairMask) -> MaskScore {
    let mut score = MaskScore {
        length: mask.length,
        ..MaskScore::default()
    };
    for (query_index, query) in keys.iter().enumerate() {
        if query_index & 1 != fold {
            continue;
        }
        for (stored_index, stored) in keys.iter().enumerate() {
            if stored_index & 1 != fold {
                continue;
            }
            let mut coarse = true;
            for &coordinate in &mask.order[..usize::from(mask.length)] {
                score.coordinate_tests += 1;
                if query.coordinates[usize::from(coordinate)]
                    != stored.coordinates[usize::from(coordinate)]
                {
                    coarse = false;
                    break;
                }
            }
            if coarse {
                let exact = query.coordinates == stored.coordinates;
                score.coarse_collisions += u64::from(!exact);
                score.false_exact_results += u32::from(!exact && query == stored);
            }
        }
    }
    score
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29PairMaskEvolveReport {
    pub descriptor: ExtractorDescriptor,
    pub mask: Q29PairMask,
    pub corpus_keys: u16,
    pub train_extra_collisions: u64,
    pub heldout_extra_collisions: u64,
    pub train_coordinate_tests: u64,
    pub heldout_coordinate_tests: u64,
    pub provenance: ProvenanceClass,
}

/// Evolve a coarse key on one deterministic fold and report its collision
/// behavior on a disjoint held-out fold.  The result never gains theorem or
/// pruning authority.
#[must_use]
pub fn evolve_retained_q29_pair_mask() -> Q29PairMaskEvolveReport {
    let keys = retained_corpus();
    let seeds = (0..Q29_PAIR_COORDINATES as u8).map(Q29PairMask::singleton);
    let summary = evolve_ranked_streaming(
        seeds,
        EvolutionConfig {
            generations: 6,
            beam_width: 12,
            max_candidates: 1_200,
        },
        |candidate, output| {
            for coordinate in 0..Q29_PAIR_COORDINATES as u8 {
                if candidate.contains(coordinate) {
                    continue;
                }
                let mut next = *candidate;
                next.order[usize::from(next.length)] = coordinate;
                next.length += 1;
                output.push(next);
            }
        },
        |candidate| score_mask(&keys, 0, *candidate),
        |left, right| {
            left.false_exact_results
                .cmp(&right.false_exact_results)
                .then_with(|| left.coarse_collisions.cmp(&right.coarse_collisions))
                .then_with(|| left.coordinate_tests.cmp(&right.coordinate_tests))
                .then_with(|| left.length.cmp(&right.length))
        },
        |_score| true,
        |_trial| Ok::<_, std::convert::Infallible>(()),
    )
    .expect("bounded infallible q29 pair-mask evolution");
    let best = summary.best_admitted.expect("nonempty q29 pair-mask seeds");
    let heldout = score_mask(&keys, 1, best.candidate);
    Q29PairMaskEvolveReport {
        descriptor: extractor_descriptor(),
        mask: best.candidate,
        corpus_keys: keys.len() as u16,
        train_extra_collisions: best.score.coarse_collisions,
        heldout_extra_collisions: heldout.coarse_collisions,
        train_coordinate_tests: best.score.coordinate_tests,
        heldout_coordinate_tests: heldout.coordinate_tests,
        provenance: ProvenanceClass::ObservedEvolved,
    }
}

#[must_use]
pub fn retained_q29_pair_corpus() -> Box<[Q29PairKey]> {
    retained_corpus()
}

/// Exact negative oracle: the bordered equations do not imply QT/Williamson
/// pairwise amicability, already at carrier four.
#[must_use]
pub fn bordered_m4_nonamicability_oracle() -> bool {
    const ROWS: [[i8; 4]; 4] = [
        [-1, 1, 1, 1],
        [-1, -1, 1, 1],
        [-1, -1, 1, 1],
        [-1, 1, -1, 1],
    ];
    let row_sums = ROWS.map(|row| row.iter().map(|&value| i16::from(value)).sum::<i16>());
    if row_sums != [2, 0, 0, 0] {
        return false;
    }
    for shift in 1..4 {
        let combined: i16 = ROWS
            .iter()
            .map(|row| {
                (0..4)
                    .map(|point| i16::from(row[point]) * i16::from(row[(point + shift) % 4]))
                    .sum::<i16>()
            })
            .sum();
        if combined != -4 {
            return false;
        }
    }
    let cross = |left: usize, right: usize, shift: usize| -> i16 {
        (0..4)
            .map(|point| i16::from(ROWS[left][point]) * i16::from(ROWS[right][(point + shift) % 4]))
            .sum()
    };
    cross(0, 1, 1) == 2 && cross(1, 0, 1) == -2
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn table_for(mask: Q29PairMask, keys: &[Q29PairKey], fold: usize) -> Q29PairTable {
        let count = keys
            .iter()
            .enumerate()
            .filter(|(index, _)| index & 1 == fold)
            .count();
        let mut table = Q29PairTable::with_capacity(mask, count).expect("bounded pair table");
        for (index, &key) in keys.iter().enumerate() {
            if index & 1 == fold {
                assert!(table.insert(key));
            }
        }
        table
    }

    #[test]
    fn evolved_mask_generalizes_and_exact_lookup_preserves_all_hits() {
        let report = evolve_retained_q29_pair_mask();
        let keys = retained_corpus();
        assert_eq!(report.corpus_keys, 512);
        assert_eq!(report.provenance, ProvenanceClass::ObservedEvolved);
        let table = table_for(report.mask, &keys, 1);
        let mut counters = Q29PairLookupCounters::default();
        for (index, key) in keys.iter().enumerate() {
            if index & 1 == 1 {
                assert!(table.contains_exact(key, &mut counters));
            }
        }
        assert_eq!(counters.exact_hits, 256);
    }

    #[test]
    fn coarse_collision_cannot_become_an_exact_hit() {
        let report = evolve_retained_q29_pair_mask();
        assert!(usize::from(report.mask.length) < Q29_PAIR_COORDINATES);
        let keys = retained_corpus();
        let mut table = Q29PairTable::with_capacity(report.mask, 1).unwrap();
        assert!(table.insert(keys[0]));
        let omitted = (0..Q29_PAIR_COORDINATES as u8)
            .find(|&coordinate| !report.mask.contains(coordinate))
            .unwrap();
        let mut forged = keys[0];
        forged.coordinates[usize::from(omitted)] += 1;
        let mut counters = Q29PairLookupCounters::default();
        assert!(!table.contains_exact(&forged, &mut counters));
        assert_ne!(counters.tagged_candidates, 0);
    }

    #[test]
    fn lookup_hot_loop_allocates_nothing() {
        let report = evolve_retained_q29_pair_mask();
        let keys = retained_corpus();
        let table = table_for(report.mask, &keys, 0);
        let (_, allocations) = tracked_allocations(|| {
            let mut counters = Q29PairLookupCounters::default();
            for _ in 0..32 {
                for (index, key) in keys.iter().enumerate() {
                    if index & 1 == 0 {
                        assert!(table.contains_exact(key, &mut counters));
                    }
                }
            }
            assert_eq!(counters.exact_hits, 32 * 256);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn worker_owned_tables_have_exact_parallel_parity() {
        let report = evolve_retained_q29_pair_mask();
        let keys = retained_corpus();
        let expected = keys.len() as u64 / 2;
        std::thread::scope(|scope| {
            let left = scope.spawn(|| {
                let table = table_for(report.mask, &keys, 0);
                let mut counters = Q29PairLookupCounters::default();
                for (index, key) in keys.iter().enumerate() {
                    if index & 1 == 0 {
                        assert!(table.contains_exact(key, &mut counters));
                    }
                }
                counters
            });
            let right = scope.spawn(|| {
                let table = table_for(report.mask, &keys, 1);
                let mut counters = Q29PairLookupCounters::default();
                for (index, key) in keys.iter().enumerate() {
                    if index & 1 == 1 {
                        assert!(table.contains_exact(key, &mut counters));
                    }
                }
                counters
            });
            assert_eq!(left.join().unwrap().exact_hits, expected);
            assert_eq!(right.join().unwrap().exact_hits, expected);
        });
    }

    #[test]
    fn bordered_counterexample_prevents_unscoped_cpsd_promotion() {
        assert!(bordered_m4_nonamicability_oracle());
    }

    #[test]
    fn descriptor_binds_exact_extractor_and_retained_source() {
        let report = evolve_retained_q29_pair_mask();
        assert_eq!(report.descriptor.identity(), EXTRACTOR_ID);
        assert_eq!(report.descriptor.version(), EXTRACTOR_VERSION);
        assert_eq!(report.descriptor.source_commitment(), source_commitment());
        assert_eq!(report.provenance, ProvenanceClass::ObservedEvolved);
    }
}
