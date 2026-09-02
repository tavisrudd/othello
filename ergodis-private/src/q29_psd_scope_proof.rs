//! Exact small-principal-minor obstructions for q29 row-repair scopes.
//!
//! Every cyclic autocorrelation vector generates a positive-semidefinite
//! circulant Gram matrix. A negative principal minor is therefore a compact
//! structural impossibility proof for the proposed replacement row.

use ergodis::{evolve_ranked_streaming, EvolutionConfig};
use serde::Serialize;

use crate::proof_synthesis::{ExtractorDescriptor, ProvenanceClass};
use crate::q29_even_moment_proof::retained_q29_y6_root;
use sha2::{Digest, Sha256};

const BLOCKS: usize = 4;
const ORDER: usize = 29;
const TARGET: [i32; 15] = [
    505, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18,
];
const PSD_EXTRACTOR_ID: [u8; 16] = *b"c1016-q29psd0001";
const PSD_EXTRACTOR_VERSION: u16 = 1;
const PSD_PARAMETER_DIGEST: [u8; 32] = [0x29; 32];
const PSD_SEMANTICS_COMMITMENT: [u8; 32] = [0x5d; 32];

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct NegativeMinorWitness {
    pub order: u8,
    pub offsets: [u8; 4],
    pub determinant: i64,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct NegativeQuadraticWitness {
    pub vector: [i8; ORDER],
    pub value: i64,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29PsdScopeReport {
    pub same_row_scopes: u32,
    pub same_row_excluded: u32,
    pub row_plus_single_scopes: u32,
    pub row_plus_single_excluded: u32,
    pub excluded_by_order: [u32; 6],
    pub first_same_row_witness: Option<NegativeMinorWitness>,
    pub first_row_plus_single_witness: Option<NegativeMinorWitness>,
    pub first_quadratic_witness: Option<NegativeQuadraticWitness>,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Copy, Debug, Ord, PartialOrd, Eq, PartialEq, Serialize)]
pub struct Q29QuadraticTemplate {
    pub frequency: u8,
    pub scale: u8,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29QuadraticEvolveReport {
    pub template: Q29QuadraticTemplate,
    pub false_negatives: u32,
    pub excluded_targets: u32,
    pub target_rows: u32,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29PsdScopeProof {
    descriptor: ExtractorDescriptor,
    source_commitment: [u8; 32],
    report: Q29PsdScopeReport,
}

fn psd_descriptor() -> ExtractorDescriptor {
    ExtractorDescriptor::registered(
        PSD_EXTRACTOR_ID,
        PSD_EXTRACTOR_VERSION,
        PSD_PARAMETER_DIGEST,
        PSD_SEMANTICS_COMMITMENT,
    )
}

fn retained_source_commitment() -> [u8; 32] {
    let rows = retained_q29_y6_root();
    let mut hash = Sha256::new();
    for row in rows {
        for value in row {
            hash.update(value.to_le_bytes());
        }
    }
    hash.finalize().into()
}

fn template_vector(template: Q29QuadraticTemplate) -> [i8; ORDER] {
    std::array::from_fn(|point| {
        (f64::from(template.scale)
            * (2.0 * std::f64::consts::PI * f64::from(template.frequency) * point as f64
                / ORDER as f64)
                .cos())
        .round() as i8
    })
}

fn quadratic_value(correlation: &[i32; ORDER], vector: &[i8; ORDER]) -> i64 {
    let mut value = 0_i64;
    for row in 0..ORDER {
        for column in 0..ORDER {
            value += i64::from(vector[row])
                * i64::from(correlation[(column + ORDER - row) % ORDER])
                * i64::from(vector[column]);
        }
    }
    value
}

pub fn replay_negative_q29_quadratic_witness(
    correlation: &[i32; ORDER],
    witness: &NegativeQuadraticWitness,
) -> bool {
    let mut value = 0_i64;
    for row in 0..ORDER {
        for column in 0..ORDER {
            let shift = (column + ORDER - row) % ORDER;
            value += i64::from(witness.vector[row])
                * i64::from(correlation[shift])
                * i64::from(witness.vector[column]);
        }
    }
    value == witness.value && value < 0
}

pub fn first_negative_q29_quadratic_witness(
    correlation: &[i32; ORDER],
) -> Option<NegativeQuadraticWitness> {
    for frequency in 1..=ORDER / 2 {
        for scale in [4.0_f64, 8.0, 16.0, 32.0] {
            let vector = std::array::from_fn(|point| {
                (scale
                    * (2.0 * std::f64::consts::PI * frequency as f64 * point as f64 / ORDER as f64)
                        .cos())
                .round() as i8
            });
            let witness = NegativeQuadraticWitness { vector, value: 0 };
            let mut value = 0_i64;
            for row in 0..ORDER {
                for column in 0..ORDER {
                    value += i64::from(vector[row])
                        * i64::from(correlation[(column + ORDER - row) % ORDER])
                        * i64::from(vector[column]);
                }
            }
            if value < 0 {
                return Some(NegativeQuadraticWitness { value, ..witness });
            }
        }
    }
    None
}

fn paf(row: &[i8; ORDER]) -> [i32; ORDER] {
    std::array::from_fn(|shift| {
        (0..ORDER)
            .map(|point| i32::from(row[point]) * i32::from(row[(point + shift) % ORDER]))
            .sum()
    })
}

fn determinant(correlation: &[i32; ORDER], offsets: &[u8; 4], order: usize) -> i64 {
    let mut permutation = [0_u8, 1, 2, 3];
    let mut total = 0_i64;
    loop {
        let mut term = 1_i64;
        let mut inversions = 0;
        for row in 0..order {
            for later in row + 1..order {
                inversions += usize::from(permutation[row] > permutation[later]);
            }
            let column = usize::from(permutation[row]);
            let shift = (usize::from(offsets[column]) + ORDER - usize::from(offsets[row])) % ORDER;
            term *= i64::from(correlation[shift]);
        }
        total += if inversions & 1 == 0 { term } else { -term };
        let mut pivot = order - 1;
        while pivot != 0 && permutation[pivot - 1] >= permutation[pivot] {
            pivot -= 1;
        }
        if pivot == 0 {
            break;
        }
        let mut swap = order - 1;
        while permutation[swap] <= permutation[pivot - 1] {
            swap -= 1;
        }
        permutation.swap(pivot - 1, swap);
        permutation[pivot..order].reverse();
    }
    total
}

pub fn first_negative_q29_principal_minor(
    correlation: &[i32; ORDER],
) -> Option<NegativeMinorWitness> {
    for second in 1..ORDER {
        let offsets = [0, second as u8, 0, 0];
        let value = determinant(correlation, &offsets, 2);
        if value < 0 {
            return Some(NegativeMinorWitness {
                order: 2,
                offsets,
                determinant: value,
            });
        }
    }
    for second in 1..ORDER {
        for third in second + 1..ORDER {
            let offsets = [0, second as u8, third as u8, 0];
            let value = determinant(correlation, &offsets, 3);
            if value < 0 {
                return Some(NegativeMinorWitness {
                    order: 3,
                    offsets,
                    determinant: value,
                });
            }
        }
    }
    for second in 1..ORDER {
        for third in second + 1..ORDER {
            for fourth in third + 1..ORDER {
                let offsets = [0, second as u8, third as u8, fourth as u8];
                let value = determinant(correlation, &offsets, 4);
                if value < 0 {
                    return Some(NegativeMinorWitness {
                        order: 4,
                        offsets,
                        determinant: value,
                    });
                }
            }
        }
    }
    None
}

/// Test every same-row repair scope and every same-row-plus-one-distinct-row
/// transfer scope around the retained residual-six root.
pub fn census_retained_q29_psd_scopes() -> Q29PsdScopeReport {
    let rows = retained_q29_y6_root();
    let row_paf = rows.map(|row| paf(&row));
    let combined: [i32; ORDER] =
        std::array::from_fn(|shift| row_paf.iter().map(|profile| profile[shift]).sum());
    let residual: [i32; ORDER] =
        std::array::from_fn(|shift| TARGET[shift.min(ORDER - shift)] - combined[shift]);
    let mut report = Q29PsdScopeReport {
        same_row_scopes: BLOCKS as u32,
        same_row_excluded: 0,
        row_plus_single_scopes: 0,
        row_plus_single_excluded: 0,
        excluded_by_order: [0; 6],
        first_same_row_witness: None,
        first_row_plus_single_witness: None,
        first_quadratic_witness: None,
        provenance: ProvenanceClass::ProvedStructural,
    };
    for repaired_block in 0..BLOCKS {
        let target = std::array::from_fn(|shift| row_paf[repaired_block][shift] + residual[shift]);
        if let Some(witness) = first_negative_q29_principal_minor(&target) {
            report.same_row_excluded += 1;
            report.excluded_by_order[usize::from(witness.order)] += 1;
            report.first_same_row_witness.get_or_insert(witness);
        } else if let Some(witness) = first_negative_q29_quadratic_witness(&target) {
            report.same_row_excluded += 1;
            report.excluded_by_order[5] += 1;
            report.first_quadratic_witness.get_or_insert(witness);
        }
        for single_block in 0..BLOCKS {
            if single_block == repaired_block {
                continue;
            }
            for from in 0..ORDER {
                if rows[single_block][from] == -9 {
                    continue;
                }
                for to in 0..ORDER {
                    if from == to || rows[single_block][to] == 9 {
                        continue;
                    }
                    report.row_plus_single_scopes += 1;
                    let mut changed = rows[single_block];
                    changed[from] -= 1;
                    changed[to] += 1;
                    let changed_paf = paf(&changed);
                    let target = std::array::from_fn(|shift| {
                        row_paf[repaired_block][shift] + residual[shift]
                            - (changed_paf[shift] - row_paf[single_block][shift])
                    });
                    if let Some(witness) = first_negative_q29_principal_minor(&target) {
                        report.row_plus_single_excluded += 1;
                        report.excluded_by_order[usize::from(witness.order)] += 1;
                        report.first_row_plus_single_witness.get_or_insert(witness);
                    } else if let Some(witness) = first_negative_q29_quadratic_witness(&target) {
                        report.row_plus_single_excluded += 1;
                        report.excluded_by_order[5] += 1;
                        report.first_quadratic_witness.get_or_insert(witness);
                    }
                }
            }
        }
    }
    report
}

pub fn derive_retained_q29_psd_scope_proof() -> Q29PsdScopeProof {
    Q29PsdScopeProof {
        descriptor: psd_descriptor(),
        source_commitment: retained_source_commitment(),
        report: census_retained_q29_psd_scopes(),
    }
}

pub fn replay_retained_q29_psd_scope_proof(proof: &Q29PsdScopeProof) -> bool {
    proof.descriptor == psd_descriptor()
        && proof.source_commitment == retained_source_commitment()
        && proof.report == census_retained_q29_psd_scopes()
        && proof.report.provenance == ProvenanceClass::ProvedStructural
}

/// Let Ergodis rank anonymous Fourier-shaped integer quadratic templates on
/// the retained repair corpus. The evolved template is diagnostic until its
/// concrete integer vector is replayed exactly; floating point only proposes
/// that vector and has no proof authority.
pub fn evolve_retained_q29_quadratic_template() -> Q29QuadraticEvolveReport {
    #[derive(Clone)]
    struct Score {
        false_negatives: u32,
        excluded: u32,
    }
    let rows = retained_q29_y6_root();
    let actual: [[i32; ORDER]; BLOCKS] = rows.map(|row| paf(&row));
    let combined: [i32; ORDER] =
        std::array::from_fn(|shift| actual.iter().map(|profile| profile[shift]).sum());
    let residual: [i32; ORDER] =
        std::array::from_fn(|shift| TARGET[shift.min(ORDER - shift)] - combined[shift]);
    let mut targets = Vec::<[i32; ORDER]>::with_capacity(9_664);
    for repaired_block in 0..BLOCKS {
        targets.push(std::array::from_fn(|shift| {
            actual[repaired_block][shift] + residual[shift]
        }));
        for single_block in 0..BLOCKS {
            if single_block == repaired_block {
                continue;
            }
            for from in 0..ORDER {
                if rows[single_block][from] == -9 {
                    continue;
                }
                for to in 0..ORDER {
                    if from == to || rows[single_block][to] == 9 {
                        continue;
                    }
                    let mut changed = rows[single_block];
                    changed[from] -= 1;
                    changed[to] += 1;
                    let changed_paf = paf(&changed);
                    targets.push(std::array::from_fn(|shift| {
                        actual[repaired_block][shift] + residual[shift]
                            - (changed_paf[shift] - actual[single_block][shift])
                    }));
                }
            }
        }
    }
    let seeds = (1..=ORDER / 2).flat_map(|frequency| {
        [4_u8, 8, 16, 32].map(move |scale| Q29QuadraticTemplate {
            frequency: frequency as u8,
            scale,
        })
    });
    let summary = evolve_ranked_streaming(
        seeds,
        EvolutionConfig {
            generations: 1,
            beam_width: 56,
            max_candidates: 56,
        },
        |_candidate, _output| {},
        |candidate: &Q29QuadraticTemplate| {
            let vector = template_vector(*candidate);
            Score {
                false_negatives: actual
                    .iter()
                    .filter(|profile| quadratic_value(profile, &vector) < 0)
                    .count() as u32,
                excluded: targets
                    .iter()
                    .filter(|profile| quadratic_value(profile, &vector) < 0)
                    .count() as u32,
            }
        },
        |left, right| {
            left.false_negatives
                .cmp(&right.false_negatives)
                .then_with(|| right.excluded.cmp(&left.excluded))
        },
        |score| score.false_negatives == 0 && score.excluded != 0,
        |_trial| Ok::<_, std::convert::Infallible>(()),
    )
    .expect("bounded infallible q29 template evolution");
    let best = summary
        .best_admitted
        .expect("at least one exact diagnostic template");
    Q29QuadraticEvolveReport {
        template: best.candidate,
        false_negatives: best.score.false_negatives,
        excluded_targets: best.score.excluded,
        target_rows: targets.len() as u32,
        provenance: ProvenanceClass::ObservedEvolved,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn actual_cyclic_gram_profiles_have_no_negative_tested_minor() {
        for row in retained_q29_y6_root() {
            assert!(first_negative_q29_principal_minor(&paf(&row)).is_none());
        }
    }

    #[test]
    fn psd_scope_census_allocates_nothing() {
        let (report, allocations) = tracked_allocations(census_retained_q29_psd_scopes);
        assert_eq!(allocations, 0);
        assert!(report.same_row_excluded <= report.same_row_scopes);
        assert!(report.row_plus_single_excluded <= report.row_plus_single_scopes);
    }

    #[test]
    fn proposed_full_quadratic_witness_replays_exactly() {
        let mut correlation = [0_i32; ORDER];
        correlation[0] = 1;
        correlation[1] = 10;
        correlation[ORDER - 1] = 10;
        let witness = first_negative_q29_quadratic_witness(&correlation).unwrap();
        assert!(replay_negative_q29_quadratic_witness(
            &correlation,
            &witness
        ));
        let mut forged = witness;
        forged.value -= 1;
        assert!(!replay_negative_q29_quadratic_witness(
            &correlation,
            &forged
        ));
    }

    #[test]
    fn ergodis_evolve_finds_a_safe_reducing_quadratic_template() {
        let report = evolve_retained_q29_quadratic_template();
        assert_eq!(report.false_negatives, 0);
        assert!(report.excluded_targets > 0);
        assert_eq!(report.target_rows, 9_664);
        assert_eq!(report.provenance, ProvenanceClass::ObservedEvolved);
    }

    #[test]
    fn sealed_scope_proof_recomputes_and_rejects_forgery() {
        let proof = derive_retained_q29_psd_scope_proof();
        assert!(replay_retained_q29_psd_scope_proof(&proof));
        let mut forged = proof;
        forged.report.row_plus_single_excluded += 1;
        assert!(!replay_retained_q29_psd_scope_proof(&forged));
        let mut wrong_source = proof;
        wrong_source.source_commitment[0] ^= 1;
        assert!(!replay_retained_q29_psd_scope_proof(&wrong_source));
    }
}
