//! Exact marginal order-87 mixed-character energy above q29 coefficients.
//!
//! Each residue modulo 29 has three lifts modulo 87.  For lift counts
//! `(a,b,c)`, the squared Eisenstein magnitude is
//! `a^2+b^2+c^2-ab-bc-ca`.  Fine-orbit slot choices give an exact local
//! triple sumset at each q29 multiplier coordinate.  Convolving only the
//! resulting coordinate energies deliberately forgets cross-coordinate
//! allocation correlations, so the output is necessary but not sufficient.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_evolve::{
    compile_inventory, digit_counts, FineInventory, FineOrbit, G41Q29EvolveError, Q29_COSETS,
};

const SLOTS: usize = 6;
const COORDINATES: usize = 8;
const LIFT_RADIX: usize = 7;
const TRIPLES: usize = LIFT_RADIX * LIFT_RADIX * LIFT_RADIX;
const TRIPLE_WORDS: usize = TRIPLES.div_ceil(64);
const ENERGY_TARGET: usize = 523;
pub const Q87_ENERGY_WORDS: usize = (ENERGY_TARGET + 1).div_ceil(64);
const Q87_ENERGY_LAST_WORD_MASK: u64 = (1_u64 << ((ENERGY_TARGET + 1) % 64)) - 1;
const _: () = assert!(524_u64 * 524 * 524 <= u32::MAX as u64);

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q87EnergyError {
    #[error("g41 q87 energy semantics are invalid")]
    SemanticMismatch,
    #[error(transparent)]
    Evolve(#[from] G41Q29EvolveError),
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q87EnergyReport {
    pub mask: u8,
    pub digits: u32,
    pub q29_coefficients: [u8; COORDINATES],
    pub coordinate_triples: [u16; COORDINATES],
    pub coordinate_energy_masks: [u64; COORDINATES],
    pub coordinate_energy_residues_mod9: [u8; COORDINATES],
    pub energy_values: u16,
    pub minimum_energy: u16,
    pub maximum_energy: u16,
    pub energy_step: u16,
    pub complete_arithmetic_progression: bool,
    pub energy_support: [u64; Q87_ENERGY_WORDS],
    pub workspace_bytes: u32,
    pub provenance: &'static str,
}

/// Source-bound marginal q87 table for repeated q29 coefficient queries.
/// Construction performs all six-slot subset convolutions once; each query is
/// fixed-width, allocation-free, and selects only precomputed exact fibres.
pub struct G41Q87EnergySpecTable {
    mask: u8,
    digits: u32,
    coefficient_energy_masks: [[u64; 19]; COORDINATES],
    coefficient_triples: [[u16; 19]; COORDINATES],
}

const EXTRACTOR_IDENTITY: &str = "ergodis-private/g41-q87-eisenstein-energy/v1; carrier=522; multiplier=41; q29-three-lift semantics; exact six-slot marginal sumsets; SDS target=1043-520=523";

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q87EnergyProof {
    extractor_digest: [u8; 32],
    source_digest: [u8; 32],
    compatible_energy_quartets: u32,
    energy_bases: [u16; 4],
    energy_step: u16,
    total_defect: u16,
}

impl G41Q87EnergyProof {
    pub fn compatible_energy_quartets(&self) -> u32 {
        self.compatible_energy_quartets
    }

    pub fn source_digest(&self) -> [u8; 32] {
        self.source_digest
    }

    pub fn energy_normal_form(&self) -> ([u16; 4], u16, u16) {
        (self.energy_bases, self.energy_step, self.total_defect)
    }
}

#[inline(always)]
const fn triple_index(values: [u8; 3]) -> usize {
    (values[0] as usize * LIFT_RADIX + values[1] as usize) * LIFT_RADIX + values[2] as usize
}

#[inline(always)]
fn triple_at(index: usize) -> [u8; 3] {
    [
        (index / (LIFT_RADIX * LIFT_RADIX)) as u8,
        ((index / LIFT_RADIX) % LIFT_RADIX) as u8,
        (index % LIFT_RADIX) as u8,
    ]
}

#[inline(always)]
fn set_triple(support: &mut [u64; TRIPLE_WORDS], values: [u8; 3]) {
    let index = triple_index(values);
    support[index / 64] |= 1_u64 << (index % 64);
}

#[inline(always)]
fn has_triple(support: &[u64; TRIPLE_WORDS], index: usize) -> bool {
    support[index / 64] & (1_u64 << (index % 64)) != 0
}

fn q87_lifts(coordinate: usize) -> [usize; 3] {
    let residue = if coordinate == 0 {
        0
    } else {
        Q29_COSETS[coordinate - 1][0]
    };
    [residue, residue + 29, residue + 58]
}

fn orbit_triple(orbit: &FineOrbit, coordinate: usize) -> [u8; 3] {
    let lifts = q87_lifts(coordinate);
    std::array::from_fn(|lift| {
        orbit.points[..usize::from(orbit.len)]
            .iter()
            .filter(|&&point| usize::from(point) % 87 == lifts[lift])
            .count() as u8
    })
}

fn slot_support(
    inventory: &FineInventory,
    slot: usize,
    count: u8,
    coordinate: usize,
) -> [u64; TRIPLE_WORDS] {
    let mut support = [0_u64; TRIPLE_WORDS];
    let length = inventory.large_len[slot];
    for subset in 0_u16..1_u16 << length {
        if subset.count_ones() != u32::from(count) {
            continue;
        }
        let mut values = [0_u8; 3];
        for orbit in 0..length {
            if subset & (1 << orbit) != 0 {
                let contribution =
                    orbit_triple(&inventory.large[slot][usize::from(orbit)], coordinate);
                for lift in 0..3 {
                    values[lift] += contribution[lift];
                }
            }
        }
        if values.into_iter().all(|value| value < LIFT_RADIX as u8) {
            set_triple(&mut support, values);
        }
    }
    support
}

fn convolve_triples(
    left: &[u64; TRIPLE_WORDS],
    right: &[u64; TRIPLE_WORDS],
) -> [u64; TRIPLE_WORDS] {
    let mut output = [0_u64; TRIPLE_WORDS];
    for left_index in 0..TRIPLES {
        if !has_triple(left, left_index) {
            continue;
        }
        let first = triple_at(left_index);
        for right_index in 0..TRIPLES {
            if !has_triple(right, right_index) {
                continue;
            }
            let second = triple_at(right_index);
            let values = std::array::from_fn(|lift| first[lift] + second[lift]);
            if values.into_iter().all(|value| value < LIFT_RADIX as u8) {
                set_triple(&mut output, values);
            }
        }
    }
    output
}

fn coordinate_support(
    inventory: &FineInventory,
    mask: u8,
    counts: [u8; SLOTS],
    coordinate: usize,
) -> [u64; TRIPLE_WORDS] {
    let mut initial = [0_u8; 3];
    for slot in 0..SLOTS {
        if mask & (1 << slot) != 0 {
            let contribution = orbit_triple(&inventory.small[slot], coordinate);
            for lift in 0..3 {
                initial[lift] += contribution[lift];
            }
        }
    }
    let mut support = [0_u64; TRIPLE_WORDS];
    set_triple(&mut support, initial);
    for slot in 0..SLOTS {
        support = convolve_triples(
            &support,
            &slot_support(inventory, slot, counts[slot], coordinate),
        );
    }
    support
}

#[inline(always)]
fn eisenstein_energy(values: [u8; 3]) -> usize {
    let [a, b, c] = values.map(i32::from);
    (a * a + b * b + c * c - a * b - b * c - c * a) as usize
}

const fn gcd(mut first: u16, mut second: u16) -> u16 {
    while second != 0 {
        let remainder = first % second;
        first = second;
        second = remainder;
    }
    first
}

#[inline(always)]
fn include_shifted_energy(
    target: &mut [u64; Q87_ENERGY_WORDS],
    source: &[u64; Q87_ENERGY_WORDS],
    shift: usize,
) {
    let word_shift = shift / 64;
    let bit_shift = shift % 64;
    for source_word in 0..Q87_ENERGY_WORDS - word_shift {
        let value = source[source_word];
        let target_word = source_word + word_shift;
        target[target_word] |= value << bit_shift;
        if bit_shift != 0 && target_word + 1 < Q87_ENERGY_WORDS {
            target[target_word + 1] |= value >> (64 - bit_shift);
        }
    }
    target[Q87_ENERGY_WORDS - 1] &= Q87_ENERGY_LAST_WORD_MASK;
}

impl G41Q87EnergySpecTable {
    pub fn compile(mask: u8, digits: u32) -> Result<Self, G41Q87EnergyError> {
        if mask >= 64 {
            return Err(G41Q87EnergyError::SemanticMismatch);
        }
        let inventory = compile_inventory()?;
        let counts = digit_counts(digits);
        if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
            return Err(G41Q87EnergyError::SemanticMismatch);
        }
        let mut coefficient_energy_masks = [[0_u64; 19]; COORDINATES];
        let mut coefficient_triples = [[0_u16; 19]; COORDINATES];
        for coordinate in 0..COORDINATES {
            let support = coordinate_support(&inventory, mask, counts, coordinate);
            for index in 0..TRIPLES {
                if !has_triple(&support, index) {
                    continue;
                }
                let values = triple_at(index);
                let coefficient = values.into_iter().map(usize::from).sum::<usize>();
                if coefficient >= 19 {
                    return Err(G41Q87EnergyError::SemanticMismatch);
                }
                coefficient_triples[coordinate][coefficient] += 1;
                coefficient_energy_masks[coordinate][coefficient] |=
                    1_u64 << eisenstein_energy(values);
            }
        }
        Ok(Self {
            mask,
            digits,
            coefficient_energy_masks,
            coefficient_triples,
        })
    }

    pub fn energy_support(
        &self,
        q29_coefficients: [u8; COORDINATES],
    ) -> Result<[u64; Q87_ENERGY_WORDS], G41Q87EnergyError> {
        if q29_coefficients.iter().any(|&value| value > 18) {
            return Err(G41Q87EnergyError::SemanticMismatch);
        }
        let mut energy_support = [0_u64; Q87_ENERGY_WORDS];
        energy_support[0] = 1;
        for (coordinate, &coefficient) in q29_coefficients.iter().enumerate() {
            let mut energies = self.coefficient_energy_masks[coordinate][usize::from(coefficient)];
            if energies == 0 {
                return Err(G41Q87EnergyError::SemanticMismatch);
            }
            let weight = if coordinate == 0 { 1 } else { 4 };
            let mut next = [0_u64; Q87_ENERGY_WORDS];
            while energies != 0 {
                let energy = energies.trailing_zeros() as usize * weight;
                energies &= energies - 1;
                include_shifted_energy(&mut next, &energy_support, energy);
            }
            energy_support = next;
        }
        Ok(energy_support)
    }

    /// Commits to the complete coefficient-to-energy behavior while omitting
    /// the source presentation. Equal values therefore identify a reusable
    /// semantic table, not merely equal mask/digit labels.
    pub fn behavior_digest(&self) -> [u8; 32] {
        let mut hasher = Sha256::new();
        hasher.update(b"ergodis-private/g41-q87-energy-spec-behavior/v1");
        for coordinate in 0..COORDINATES {
            for coefficient in 0..19 {
                hasher.update(self.coefficient_energy_masks[coordinate][coefficient].to_le_bytes());
                hasher.update(self.coefficient_triples[coordinate][coefficient].to_le_bytes());
            }
        }
        hasher.finalize().into()
    }

    pub fn report(
        &self,
        q29_coefficients: [u8; COORDINATES],
    ) -> Result<G41Q87EnergyReport, G41Q87EnergyError> {
        let energy_support = self.energy_support(q29_coefficients)?;
        let coordinate_energy_masks = std::array::from_fn(|coordinate| {
            self.coefficient_energy_masks[coordinate][usize::from(q29_coefficients[coordinate])]
        });
        let coordinate_triples = std::array::from_fn(|coordinate| {
            self.coefficient_triples[coordinate][usize::from(q29_coefficients[coordinate])]
        });
        let coordinate_energy_residues_mod9 = coordinate_energy_masks.map(|energies| {
            let first_energy = energies.trailing_zeros() as u8;
            if (0..64).all(|energy| {
                energies & (1_u64 << energy) == 0 || energy % 9 == u32::from(first_energy % 9)
            }) {
                first_energy % 9
            } else {
                u8::MAX
            }
        });
        let mut energy_values = 0_u16;
        let mut minimum_energy = u16::MAX;
        let mut maximum_energy = 0_u16;
        let mut previous_energy = None;
        let mut energy_step = 0_u16;
        for energy in 0..=ENERGY_TARGET {
            if energy_support[energy / 64] & (1_u64 << (energy % 64)) != 0 {
                energy_values += 1;
                minimum_energy = minimum_energy.min(energy as u16);
                maximum_energy = maximum_energy.max(energy as u16);
                if let Some(previous) = previous_energy {
                    energy_step = gcd(energy_step, energy as u16 - previous);
                }
                previous_energy = Some(energy as u16);
            }
        }
        if energy_values == 0 {
            minimum_energy = 0;
        }
        let complete_arithmetic_progression = energy_values == 1
            || (energy_step != 0
                && (maximum_energy - minimum_energy) / energy_step + 1 == energy_values);
        Ok(G41Q87EnergyReport {
            mask: self.mask,
            digits: self.digits,
            q29_coefficients,
            coordinate_triples,
            coordinate_energy_masks,
            coordinate_energy_residues_mod9,
            energy_values,
            minimum_energy,
            maximum_energy,
            energy_step,
            complete_arithmetic_progression,
            energy_support,
            workspace_bytes: (std::mem::size_of::<Self>()
                + 2 * Q87_ENERGY_WORDS * std::mem::size_of::<u64>())
                as u32,
            provenance: "exact source-bound marginal q87 table; six-slot three-lift sumsets are compiled once per canonical block specification, coefficient queries select exact fibres and convolve fixed-width Eisenstein energies without allocation; cross-coordinate correlations are deliberately forgotten, so this is a necessary condition only",
        })
    }
}

pub fn compile_g41_q87_energy_support(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
) -> Result<G41Q87EnergyReport, G41Q87EnergyError> {
    G41Q87EnergySpecTable::compile(mask, digits)?.report(q29_coefficients)
}

fn energy_values(report: &G41Q87EnergyReport) -> impl Iterator<Item = usize> + '_ {
    (0..=ENERGY_TARGET)
        .filter(|&energy| report.energy_support[energy / 64] & (1_u64 << (energy % 64)) != 0)
}

fn compatible_energy_quartets(reports: &[G41Q87EnergyReport; 4]) -> u32 {
    let mut left = [0_u16; ENERGY_TARGET + 1];
    let mut right = [0_u16; ENERGY_TARGET + 1];
    for first in energy_values(&reports[0]) {
        for second in energy_values(&reports[2]) {
            if first + second <= ENERGY_TARGET {
                left[first + second] += 1;
            }
        }
    }
    for first in energy_values(&reports[1]) {
        for second in energy_values(&reports[3]) {
            if first + second <= ENERGY_TARGET {
                right[first + second] += 1;
            }
        }
    }
    (0..=ENERGY_TARGET)
        .map(|energy| u32::from(left[energy]) * u32::from(right[ENERGY_TARGET - energy]))
        .sum()
}

fn source_digest(reports: &[G41Q87EnergyReport; 4]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    for report in reports {
        hasher.update([report.mask]);
        hasher.update(report.digits.to_le_bytes());
        hasher.update(report.q29_coefficients);
        for &word in &report.energy_support {
            hasher.update(word.to_le_bytes());
        }
    }
    hasher.finalize().into()
}

pub fn issue_g41_q87_energy_proof(
    masks: [u8; 4],
    digits: [u32; 4],
    q29_coefficients: [[u8; COORDINATES]; 4],
) -> Result<G41Q87EnergyProof, G41Q87EnergyError> {
    let reports = [
        compile_g41_q87_energy_support(masks[0], digits[0], q29_coefficients[0])?,
        compile_g41_q87_energy_support(masks[1], digits[1], q29_coefficients[1])?,
        compile_g41_q87_energy_support(masks[2], digits[2], q29_coefficients[2])?,
        compile_g41_q87_energy_support(masks[3], digits[3], q29_coefficients[3])?,
    ];
    let energy_step = reports[0].energy_step;
    if energy_step == 0
        || reports.iter().any(|report| {
            !report.complete_arithmetic_progression
                || report.energy_step != energy_step
                || report.coordinate_energy_masks[0].count_ones() != 1
                || report
                    .coordinate_energy_residues_mod9
                    .into_iter()
                    .any(|residue| residue >= 9)
        })
    {
        return Err(G41Q87EnergyError::SemanticMismatch);
    }
    let energy_bases = std::array::from_fn(|block| reports[block].minimum_energy);
    let base_sum: u16 = energy_bases.iter().sum();
    let residual = (ENERGY_TARGET as u16)
        .checked_sub(base_sum)
        .ok_or(G41Q87EnergyError::SemanticMismatch)?;
    if residual % energy_step != 0 {
        return Err(G41Q87EnergyError::SemanticMismatch);
    }
    Ok(G41Q87EnergyProof {
        extractor_digest: Sha256::digest(EXTRACTOR_IDENTITY.as_bytes()).into(),
        source_digest: source_digest(&reports),
        compatible_energy_quartets: compatible_energy_quartets(&reports),
        energy_bases,
        energy_step,
        total_defect: residual / energy_step,
    })
}

pub fn verify_g41_q87_energy_proof(
    proof: &G41Q87EnergyProof,
    masks: [u8; 4],
    digits: [u32; 4],
    q29_coefficients: [[u8; COORDINATES]; 4],
) -> Result<bool, G41Q87EnergyError> {
    Ok(*proof == issue_g41_q87_energy_proof(masks, digits, q29_coefficients)?)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn eisenstein_energy_is_permutation_invariant() {
        assert_eq!(eisenstein_energy([1, 2, 5]), 13);
        assert_eq!(eisenstein_energy([5, 1, 2]), 13);
        assert_eq!(eisenstein_energy([2, 5, 1]), 13);
    }

    #[test]
    fn word_shift_matches_independent_scalar_support_for_every_shift() {
        let mut source = [0_u64; Q87_ENERGY_WORDS];
        for value in 0..=ENERGY_TARGET {
            if value % 7 == 1 || value % 11 == 3 {
                source[value / 64] |= 1_u64 << (value % 64);
            }
        }
        for shift in 0..=ENERGY_TARGET {
            let mut actual = [0_u64; Q87_ENERGY_WORDS];
            include_shifted_energy(&mut actual, &source, shift);
            let mut expected = [0_u64; Q87_ENERGY_WORDS];
            for value in 0..=ENERGY_TARGET - shift {
                if source[value / 64] & (1_u64 << (value % 64)) != 0 {
                    let target = value + shift;
                    expected[target / 64] |= 1_u64 << (target % 64);
                }
            }
            assert_eq!(actual, expected, "shift {shift}");
        }
    }

    #[test]
    fn concrete_interface_support_is_bounded_and_hot_reads_allocate_nothing() {
        let report =
            compile_g41_q87_energy_support(20, 2_215_340, [8, 9, 7, 10, 9, 5, 11, 12]).unwrap();
        assert!(report.coordinate_triples.into_iter().all(|count| count > 0));
        assert!(report.energy_values > 0);
        assert_eq!(report.energy_step, 36);
        assert!(report.complete_arithmetic_progression);
        assert!(report
            .coordinate_energy_residues_mod9
            .into_iter()
            .all(|residue| residue < 9));
        let (_, allocations) = tracked_allocations(|| {
            for energy in 0..=ENERGY_TARGET {
                std::hint::black_box(
                    report.energy_support[energy / 64] & (1_u64 << (energy % 64)) != 0,
                );
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn reusable_spec_table_matches_direct_report_and_queries_without_allocation() {
        let coefficients = [8, 9, 7, 10, 9, 5, 11, 12];
        let table = G41Q87EnergySpecTable::compile(20, 2_215_340).unwrap();
        let (actual, allocations) = tracked_allocations(|| table.report(coefficients).unwrap());
        assert_eq!(allocations, 0);
        let inventory = compile_inventory().unwrap();
        let counts = digit_counts(2_215_340);
        for coordinate in 0..COORDINATES {
            let support = coordinate_support(&inventory, 20, counts, coordinate);
            let mut direct_mask = 0_u64;
            let mut direct_triples = 0_u16;
            for index in 0..TRIPLES {
                if !has_triple(&support, index) {
                    continue;
                }
                let values = triple_at(index);
                if values.into_iter().map(u16::from).sum::<u16>()
                    == u16::from(coefficients[coordinate])
                {
                    direct_triples += 1;
                    direct_mask |= 1_u64 << eisenstein_energy(values);
                }
            }
            assert_eq!(actual.coordinate_energy_masks[coordinate], direct_mask);
            assert_eq!(actual.coordinate_triples[coordinate], direct_triples);
        }
    }

    #[test]
    fn reusable_spec_table_rejects_an_empty_or_out_of_range_coefficient_fibre() {
        let table = G41Q87EnergySpecTable::compile(20, 2_215_340).unwrap();
        assert_eq!(
            table.energy_support([19; 8]),
            Err(G41Q87EnergyError::SemanticMismatch)
        );
        let mut missing = None;
        'outer: for coordinate in 0..COORDINATES {
            for coefficient in 0_u8..=18 {
                let mut values = [8_u8; COORDINATES];
                values[coordinate] = coefficient;
                if table.energy_support(values).is_err() {
                    missing = Some(values);
                    break 'outer;
                }
            }
        }
        assert!(missing.is_some());
    }

    #[test]
    fn direct_fine_orbit_word_energy_lies_in_compiled_marginal_support() {
        let inventory = compile_inventory().unwrap();
        let mask = 20_u8;
        let digits = 2_215_340_u32;
        let orbit_masks = [29_u16, 109, 6_321, 134, 998, 5_663];
        assert_eq!(
            digit_counts(digits),
            orbit_masks.map(|orbits| orbits.count_ones() as u8)
        );
        let mut word = [0_u8; 522];
        let mut write = |orbit: &FineOrbit| {
            for &point in &orbit.points[..usize::from(orbit.len)] {
                assert_eq!(word[usize::from(point)], 0);
                word[usize::from(point)] = 1;
            }
        };
        for slot in 0..SLOTS {
            if mask & (1 << slot) != 0 {
                write(&inventory.small[slot]);
            }
            for orbit in 0..inventory.large_len[slot] {
                if orbit_masks[slot] & (1 << orbit) != 0 {
                    write(&inventory.large[slot][usize::from(orbit)]);
                }
            }
        }
        let mut q29_coefficients = [0_u8; COORDINATES];
        let mut direct_energy = 0_usize;
        for coordinate in 0..COORDINATES {
            let lifts = q87_lifts(coordinate);
            let values: [u8; 3] = std::array::from_fn(|lift| {
                (lifts[lift]..522)
                    .step_by(87)
                    .map(|point| word[point])
                    .sum()
            });
            q29_coefficients[coordinate] = values.into_iter().sum();
            direct_energy += if coordinate == 0 { 1 } else { 4 } * eisenstein_energy(values);
        }
        let report = compile_g41_q87_energy_support(mask, digits, q29_coefficients).unwrap();
        assert!(direct_energy <= ENERGY_TARGET);
        assert_ne!(
            report.energy_support[direct_energy / 64] & (1_u64 << (direct_energy % 64)),
            0
        );
    }

    #[test]
    fn sealed_energy_proof_recomputes_sources_and_rejects_forgery() {
        let masks = [20, 13, 21, 13];
        let digits = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
        let coefficients = [
            [8, 9, 7, 10, 9, 5, 11, 12],
            [5, 8, 12, 10, 10, 8, 9, 7],
            [9, 9, 9, 9, 10, 9, 10, 7],
            [5, 10, 8, 5, 9, 12, 14, 6],
        ];
        let proof = issue_g41_q87_energy_proof(masks, digits, coefficients).unwrap();
        assert_eq!(proof.compatible_energy_quartets(), 35);
        assert_eq!(proof.energy_normal_form(), ([101, 93, 24, 161], 36, 4));
        assert!(verify_g41_q87_energy_proof(&proof, masks, digits, coefficients).unwrap());
        let mut forged = proof.clone();
        forged.source_digest[0] ^= 1;
        assert!(!verify_g41_q87_energy_proof(&forged, masks, digits, coefficients).unwrap());
        let mut forged = proof.clone();
        forged.compatible_energy_quartets += 1;
        assert!(!verify_g41_q87_energy_proof(&forged, masks, digits, coefficients).unwrap());
    }
}
