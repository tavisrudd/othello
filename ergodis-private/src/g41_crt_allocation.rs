//! Typed q29-allocation to q87 mixed-CRT feature extraction for g41.
//!
//! The 42 cells are the six sealed quotient slot families crossed with the
//! seven nonzero q29 multiplier cosets. Compilation records the one or two
//! q87 variants inside every q29 cell, exposing rather than erasing the mixed
//! quotient's coupling to binary orbit orientation.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_evolve::{compile_inventory, FineInventory, Q29_COSETS};

const SLOTS: usize = 6;
const CLASSES: usize = 7;
const CELLS: usize = SLOTS * CLASSES;
const MODULUS: usize = 87;
const PROFILE_COORDINATES: usize = 22;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41CrtAllocationError {
    #[error("g41 CRT allocation semantics are invalid")]
    SemanticMismatch,
    #[error(transparent)]
    Evolve(#[from] crate::g41_q29_evolve::G41Q29EvolveError),
}

#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G41Q29Allocation([u8; CELLS]);

impl G41Q29Allocation {
    pub fn cells(&self) -> &[u8; CELLS] {
        &self.0
    }
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q87AllocationProfile {
    pub defects: [u16; PROFILE_COORDINATES],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q87AllocationExtractorReport {
    pub modulus: u16,
    pub cells: u8,
    pub profile_coordinates: u8,
    pub distinct_variant_histograms: u8,
    pub maximum_cell_variants: u8,
    pub cell_variant_class_ids: [[[u8; 2]; CLASSES]; SLOTS],
    pub source_commitment: [u8; 32],
    pub provenance: &'static str,
}

pub struct G41Q87AllocationExtractor {
    inventory: FineInventory,
    histograms: [[[u8; MODULUS]; 2]; CELLS],
    capacities: [u8; CELLS],
    representatives: [u8; PROFILE_COORDINATES],
    report: G41Q87AllocationExtractorReport,
}

fn orbit_histogram(points: &[u16]) -> [u8; MODULUS] {
    let mut histogram = [0_u8; MODULUS];
    for &point in points {
        histogram[usize::from(point) % MODULUS] += 1;
    }
    histogram
}

fn shift_representatives() -> Result<[u8; PROFILE_COORDINATES], G41CrtAllocationError> {
    let mut representatives = [0_u8; PROFILE_COORDINATES];
    let mut seen = [false; MODULUS];
    seen[0] = true;
    let mut used = 0_usize;
    for start in 1..MODULUS {
        if seen[start] {
            continue;
        }
        if used == PROFILE_COORDINATES {
            return Err(G41CrtAllocationError::SemanticMismatch);
        }
        representatives[used] = start as u8;
        used += 1;
        let mut point = start;
        loop {
            seen[point] = true;
            point = point * 41 % MODULUS;
            if point == start {
                break;
            }
        }
    }
    if used != PROFILE_COORDINATES || seen.iter().any(|&value| !value) {
        return Err(G41CrtAllocationError::SemanticMismatch);
    }
    Ok(representatives)
}

impl G41Q87AllocationExtractor {
    pub fn compile() -> Result<Self, G41CrtAllocationError> {
        let inventory = compile_inventory()?;
        let mut histograms = [[[0_u8; MODULUS]; 2]; CELLS];
        let mut capacities = [0_u8; CELLS];
        let mut hasher = Sha256::new();
        hasher.update(b"g41-q29-allocation-to-q87-v1");
        for slot in 0..SLOTS {
            for class in 0..CLASSES {
                let cell = slot * CLASSES + class;
                let representative = Q29_COSETS[class][0];
                let mut found = 0_u8;
                for orbit in 0..inventory.large_len[slot] {
                    let orbit = &inventory.large[slot][usize::from(orbit)];
                    if orbit.residue_histogram[representative] == 0 {
                        continue;
                    }
                    let histogram = orbit_histogram(&orbit.points[..usize::from(orbit.len)]);
                    histograms[cell][usize::from(found)] = histogram;
                    found += 1;
                    hasher.update(orbit.len.to_le_bytes());
                    for &point in &orbit.points[..usize::from(orbit.len)] {
                        hasher.update(point.to_le_bytes());
                    }
                }
                let expected = if slot < 2 { 1 } else { 2 };
                if found != expected {
                    return Err(G41CrtAllocationError::SemanticMismatch);
                }
                capacities[cell] = found;
                hasher.update([slot as u8, class as u8, found]);
                for histogram in &histograms[cell][..usize::from(found)] {
                    hasher.update(histogram);
                }
            }
        }
        let mut variant_class_ids = [[u8::MAX; 2]; CELLS];
        let mut distinct = 0_u8;
        for cell in 0..CELLS {
            for variant in 0..usize::from(capacities[cell]) {
                let mut prior = None;
                for prior_cell in 0..=cell {
                    let limit = if prior_cell == cell {
                        variant
                    } else {
                        usize::from(capacities[prior_cell])
                    };
                    for prior_variant in 0..limit {
                        if histograms[prior_cell][prior_variant] == histograms[cell][variant] {
                            prior = Some(variant_class_ids[prior_cell][prior_variant]);
                            break;
                        }
                    }
                    if prior.is_some() {
                        break;
                    }
                }
                variant_class_ids[cell][variant] = prior.unwrap_or_else(|| {
                    let class = distinct;
                    distinct += 1;
                    class
                });
            }
        }
        let representatives = shift_representatives()?;
        let report = G41Q87AllocationExtractorReport {
            modulus: MODULUS as u16,
            cells: CELLS as u8,
            profile_coordinates: PROFILE_COORDINATES as u8,
            distinct_variant_histograms: distinct,
            maximum_cell_variants: 2,
            cell_variant_class_ids: std::array::from_fn(|slot| {
                std::array::from_fn(|class| variant_class_ids[slot * CLASSES + class])
            }),
            source_commitment: hasher.finalize().into(),
            provenance: "typed canonical g41 orbit extractor; every fine orbit is bound to its q29 allocation cell and independently compiled into one of the cell's sealed q87 variants, exposing rather than erasing mixed-CRT orientation coupling",
        };
        Ok(Self {
            inventory,
            histograms,
            capacities,
            representatives,
            report,
        })
    }

    pub fn report(&self) -> &G41Q87AllocationExtractorReport {
        &self.report
    }

    pub fn cell_variant_histogram(
        &self,
        slot: usize,
        class: usize,
        variant: usize,
    ) -> Option<&[u8; MODULUS]> {
        let cell = slot.checked_mul(CLASSES)?.checked_add(class)?;
        (cell < CELLS && variant < usize::from(self.capacities[cell]))
            .then_some(&self.histograms[cell][variant])
    }

    pub fn extract(
        &self,
        orbit_masks: [u16; SLOTS],
    ) -> Result<G41Q29Allocation, G41CrtAllocationError> {
        let mut cells = [0_u8; CELLS];
        for slot in 0..SLOTS {
            if orbit_masks[slot] >> self.inventory.large_len[slot] != 0 {
                return Err(G41CrtAllocationError::SemanticMismatch);
            }
            for orbit in 0..self.inventory.large_len[slot] {
                if orbit_masks[slot] & (1 << orbit) == 0 {
                    continue;
                }
                let signature = self.inventory.large[slot][usize::from(orbit)].residue_histogram;
                let class = (0..CLASSES)
                    .find(|&class| signature[Q29_COSETS[class][0]] != 0)
                    .ok_or(G41CrtAllocationError::SemanticMismatch)?;
                cells[slot * CLASSES + class] += 1;
            }
        }
        if (0..CELLS).any(|cell| cells[cell] > self.capacities[cell]) {
            return Err(G41CrtAllocationError::SemanticMismatch);
        }
        Ok(G41Q29Allocation(cells))
    }

    pub fn profile(
        &self,
        small_mask: u8,
        orbit_masks: [u16; SLOTS],
    ) -> Result<Option<G41Q87AllocationProfile>, G41CrtAllocationError> {
        if small_mask >= 64 {
            return Err(G41CrtAllocationError::SemanticMismatch);
        }
        let mut coefficients = [0_u16; MODULUS];
        for slot in 0..SLOTS {
            if small_mask & (1 << slot) != 0 {
                let orbit = &self.inventory.small[slot];
                for &point in &orbit.points[..usize::from(orbit.len)] {
                    coefficients[usize::from(point) % MODULUS] += 1;
                }
            }
        }
        for slot in 0..SLOTS {
            if orbit_masks[slot] >> self.inventory.large_len[slot] != 0 {
                return Err(G41CrtAllocationError::SemanticMismatch);
            }
            for orbit in 0..self.inventory.large_len[slot] {
                if orbit_masks[slot] & (1 << orbit) == 0 {
                    continue;
                }
                let orbit = &self.inventory.large[slot][usize::from(orbit)];
                for &point in &orbit.points[..usize::from(orbit.len)] {
                    coefficients[usize::from(point) % MODULUS] += 1;
                }
            }
        }
        let zero: u32 = coefficients
            .iter()
            .map(|&value| u32::from(value) * u32::from(value))
            .sum();
        let mut defects = [0_u16; PROFILE_COORDINATES];
        for (coordinate, &shift) in self.representatives.iter().enumerate() {
            let shifted: u32 = (0..MODULUS)
                .map(|residue| {
                    u32::from(coefficients[residue])
                        * u32::from(coefficients[(residue + usize::from(shift)) % MODULUS])
                })
                .sum();
            let defect = zero
                .checked_sub(shifted)
                .ok_or(G41CrtAllocationError::SemanticMismatch)?;
            if defect > 523 {
                return Ok(None);
            }
            defects[coordinate] = defect as u16;
        }
        Ok(Some(G41Q87AllocationProfile { defects }))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn compiled_extractor_preserves_q87_variants_and_hot_profile_allocates_nothing() {
        let extractor = G41Q87AllocationExtractor::compile().unwrap();
        assert_eq!(extractor.report().cells, 42);
        assert!(extractor.report().distinct_variant_histograms > 7);
        let first_masks = [29, 109, 6_321, 134, 998, 5_663];
        let mut second_masks = first_masks;
        let mut swapped = false;
        for slot in 2..SLOTS {
            for first_orbit in 0..extractor.inventory.large_len[slot] {
                for second_orbit in first_orbit + 1..extractor.inventory.large_len[slot] {
                    let pair = (1_u16 << first_orbit) | (1_u16 << second_orbit);
                    if extractor.inventory.large[slot][usize::from(first_orbit)].residue_histogram
                        == extractor.inventory.large[slot][usize::from(second_orbit)]
                            .residue_histogram
                        && (first_masks[slot] & pair).count_ones() == 1
                    {
                        second_masks[slot] ^= pair;
                        swapped = true;
                        break;
                    }
                }
                if swapped {
                    break;
                }
            }
            if swapped {
                break;
            }
        }
        assert!(swapped);
        let first = extractor.extract(first_masks).unwrap();
        let second = extractor.extract(second_masks).unwrap();
        assert_eq!(first, second);
        let (profile, allocations) = tracked_allocations(|| extractor.profile(20, first_masks));
        assert!(profile.unwrap().is_some());
        assert_eq!(allocations, 0);
    }
}
