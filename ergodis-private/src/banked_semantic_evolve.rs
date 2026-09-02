//! Discovery-only semantic-coordinate corpora for the fourteen C1016 reductions.
//!
//! The registered adapters expose signed residual coordinates computed from
//! the underlying orbit/norm calculation.  Corpus labels are recomputed from
//! the coordinate tuple, not inferred from names.  Ergodis must recover which
//! coordinates jointly vanish while ignoring the diagnostic coordinates.

use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::Path;

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

const DATA_SCHEMA: &str = "ergodis-campaign-data-v0";
const GENERATOR_NAME: &str = "c1016-banked-semantic-residuals";
const GENERATOR_VERSION: &str = "1";
const RESIDUAL_VALUES: [i64; 3] = [-1, 0, 1];
const MAX_FIELDS: usize = 7;
const OPAQUE_FIELDS: [&str; MAX_FIELDS] = ["x0", "x1", "x2", "x3", "x4", "x5", "x6"];

#[derive(Clone, Copy, Debug)]
pub struct BankedSemanticSystem {
    pub slug: &'static str,
    pub fields: &'static [&'static str],
    /// Bit `i` means field `i` is a necessary zero residual. Other fields are
    /// deliberately irrelevant diagnostic observables.
    pub required_zero_mask: u8,
    pub mechanism: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct BankedSemanticCorpusReport {
    pub reduction: &'static str,
    pub fields: u8,
    pub rows: u32,
    pub positive_rows: u32,
    pub generator_digest: [u8; 32],
    pub mechanism: &'static str,
    pub provenance: &'static str,
}

#[derive(Debug, Error)]
pub enum BankedSemanticEvolveError {
    #[error("unknown banked semantic reduction")]
    UnknownReduction,
    #[error("banked semantic system exceeds its bound or is malformed")]
    InvalidSystem,
    #[error(transparent)]
    Io(#[from] std::io::Error),
    #[error(transparent)]
    Json(#[from] serde_json::Error),
}

#[derive(Serialize)]
struct GeneratorHeader<'a> {
    name: &'a str,
    version: &'a str,
    digest: String,
}

#[derive(Serialize)]
struct DataHeader<'a> {
    schema: &'a str,
    presentation: String,
    problem: String,
    fields: &'a [&'a str],
    rows: usize,
    generator: GeneratorHeader<'a>,
}

#[derive(Serialize)]
struct DataRow<'a> {
    id: u64,
    expected: bool,
    values: &'a [i64],
}

const SYSTEMS: [BankedSemanticSystem; 14] = [
    semantic(
        "order-three-orbit-energy",
        &[
            "eisenstein_rational_residual",
            "eisenstein_radical_residual",
            "orbit_count_diagnostic",
        ],
        0b011,
        "multiplier-orbit residue sums followed by the Eisenstein norm",
    ),
    semantic(
        "joint-d9-d6-local-fibre",
        &[
            "row_marginal_residual",
            "column_marginal_residual",
            "cell_lift_residual",
            "marginal_size_diagnostic",
        ],
        0b0111,
        "CRT 2x3 cell lift with simultaneously prescribed marginals",
    ),
    semantic(
        "galois-fixed-field",
        &[
            "subgroup_action_residual",
            "fixed_field_degree_residual",
            "profile_count_diagnostic",
        ],
        0b011,
        "multiplicative order of the multiplier image on the character field",
    ),
    semantic(
        "orbit-quotiented-paf-residual",
        &[
            "shift_orbit_constancy_residual",
            "ab_cd_residual_mismatch",
            "orbit_size_diagnostic",
        ],
        0b011,
        "PAF constancy on multiplier shift orbits and exact AB/CD residual matching",
    ),
    semantic(
        "g53-joint-q2-q3-q6",
        &[
            "q2_energy_residual",
            "q3_energy_residual",
            "q6_energy_residual",
            "single_sector_diagnostic",
        ],
        0b0111,
        "same-subset coupling of the three rational character sectors",
    ),
    semantic(
        "g41-joint-q9-q18",
        &[
            "q9_norm_residual",
            "q18_norm_residual",
            "galois_pair_residual",
            "q9_only_diagnostic",
        ],
        0b0111,
        "shared-subset joint fixed-field norm at orders nine and eighteen",
    ),
    semantic(
        "translation-normalizer",
        &[
            "commutator_residual",
            "row_sum_residual",
            "paf_transport_residual",
            "fixed_subset_diagnostic",
        ],
        0b0111,
        "commuting translations, independent block action, and Burnside quotient",
    ),
    semantic(
        "g91-quadratic-q29",
        &[
            "quadratic_rational_residual",
            "quadratic_radical_residual",
            "three_square_residual",
            "legendre_class_diagnostic",
        ],
        0b0111,
        "quadratic fixed-field norm and the closed three-square endpoint",
    ),
    semantic(
        "unit-dilation-normalizer",
        &[
            "unit_commutator_residual",
            "common_action_residual",
            "paf_permutation_residual",
            "fixed_subset_diagnostic",
        ],
        0b0111,
        "common unit dilation preserving row sums and permuting PAF equations",
    ),
    semantic(
        "g41-joint-q3-q9-q18",
        &[
            "q3_norm_residual",
            "q9_norm_residual",
            "q18_norm_residual",
            "pairwise_only_diagnostic",
        ],
        0b0111,
        "same-subset coupling of the order 3, 9, and 18 norm equations",
    ),
    semantic(
        "g133-structural-q9",
        &[
            "visible_class_residual",
            "eisenstein_norm_residual",
            "row_sum_residual",
            "invisible_orbit_diagnostic",
        ],
        0b0111,
        "visible residue classes and the explicit order-nine Eisenstein norm",
    ),
    semantic(
        "g133-joint-q3-q9",
        &[
            "q3_norm_residual",
            "q9_norm_residual",
            "shared_orbit_residual",
            "q9_only_diagnostic",
        ],
        0b0111,
        "joint Eisenstein norms over the shared multiplier-orbit inventory",
    ),
    semantic(
        "g91-joint-q3-q29",
        &[
            "eisenstein_norm_residual",
            "quadratic_rational_residual",
            "quadratic_radical_residual",
            "separate_sector_diagnostic",
        ],
        0b0111,
        "CRT coupling of Eisenstein totals and quadratic residue balances",
    ),
    semantic(
        "g53-joint-q29-crt",
        &[
            "q2_q3_q6_profile_residual",
            "q29_rational_residual",
            "q29_radical_residual",
            "family_scale_residual",
            "q58_diagnostic",
        ],
        0b0_1111,
        "five-family CRT orbit algebra joining q29 to the rational q2/q3/q6 profile",
    ),
];

const fn semantic(
    slug: &'static str,
    fields: &'static [&'static str],
    required_zero_mask: u8,
    mechanism: &'static str,
) -> BankedSemanticSystem {
    BankedSemanticSystem {
        slug,
        fields,
        required_zero_mask,
        mechanism,
    }
}

#[must_use]
pub const fn banked_semantic_systems() -> &'static [BankedSemanticSystem; 14] {
    &SYSTEMS
}

#[must_use]
pub const fn opaque_field_name(index: usize) -> &'static str {
    OPAQUE_FIELDS[index]
}

#[inline(always)]
pub(crate) fn semantic_tuple_survives(system: BankedSemanticSystem, values: &[i64]) -> bool {
    let mut required = system.required_zero_mask;
    while required != 0 {
        let index = required.trailing_zeros() as usize;
        if values[index] != 0 {
            return false;
        }
        required &= required - 1;
    }
    true
}

fn validate(system: BankedSemanticSystem) -> Result<(), BankedSemanticEvolveError> {
    let field_mask = (1_u16 << system.fields.len()) - 1;
    if system.fields.is_empty()
        || system.fields.len() > MAX_FIELDS
        || system.required_zero_mask == 0
        || u16::from(system.required_zero_mask) & !field_mask != 0
        || system.fields.iter().any(|field| field.is_empty())
    {
        return Err(BankedSemanticEvolveError::InvalidSystem);
    }
    Ok(())
}

fn row_count(fields: usize) -> usize {
    (0..fields).fold(1_usize, |count, _| count * RESIDUAL_VALUES.len())
}

fn fill_ternary_row(mut row: usize, values: &mut [i64]) {
    for value in values {
        *value = RESIDUAL_VALUES[row % RESIDUAL_VALUES.len()];
        row /= RESIDUAL_VALUES.len();
    }
}

fn digest(system: BankedSemanticSystem) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(GENERATOR_NAME.as_bytes());
    hasher.update(GENERATOR_VERSION.as_bytes());
    hasher.update(system.slug.as_bytes());
    hasher.update([system.required_zero_mask]);
    hasher.update(system.mechanism.as_bytes());
    for field in system.fields {
        hasher.update(field.as_bytes());
        hasher.update([0]);
    }
    hasher.finalize().into()
}

fn digest_hex(digest: [u8; 32]) -> String {
    const HEX: &[u8; 16] = b"0123456789abcdef";
    let mut output = String::with_capacity(64);
    for byte in digest {
        output.push(char::from(HEX[usize::from(byte >> 4)]));
        output.push(char::from(HEX[usize::from(byte & 15)]));
    }
    output
}

pub fn write_banked_semantic_campaign(
    reduction: &str,
    output: &Path,
) -> Result<BankedSemanticCorpusReport, BankedSemanticEvolveError> {
    let system = SYSTEMS
        .iter()
        .copied()
        .find(|system| system.slug == reduction)
        .ok_or(BankedSemanticEvolveError::UnknownReduction)?;
    validate(system)?;
    let rows = row_count(system.fields.len());
    let generator_digest = digest(system);
    let file: File = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)?;
    let mut writer = BufWriter::with_capacity(64 * 1024, file);
    serde_json::to_writer(
        &mut writer,
        &DataHeader {
            schema: DATA_SCHEMA,
            presentation: format!("c1016-{}-semantic-residual-v1", system.slug),
            problem: format!("banked-semantic-{}", system.slug),
            fields: &OPAQUE_FIELDS[..system.fields.len()],
            rows,
            generator: GeneratorHeader {
                name: GENERATOR_NAME,
                version: GENERATOR_VERSION,
                digest: digest_hex(generator_digest),
            },
        },
    )?;
    writer.write_all(b"\n")?;
    let mut values = vec![0_i64; system.fields.len()];
    let mut positive_rows = 0_u32;
    for row in 0..rows {
        fill_ternary_row(row, &mut values);
        let expected = semantic_tuple_survives(system, &values);
        positive_rows += u32::from(expected);
        serde_json::to_writer(
            &mut writer,
            &DataRow {
                id: row as u64,
                expected,
                values: &values,
            },
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    Ok(BankedSemanticCorpusReport {
        reduction: system.slug,
        fields: system.fields.len() as u8,
        rows: rows as u32,
        positive_rows,
        generator_digest,
        mechanism: system.mechanism,
        provenance: "discovery-only exhaustive residual-coordinate corpus; semantic fields require their registered extractor and cannot grant proof authority",
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn registry_covers_the_fourteen_banked_reductions() {
        assert_eq!(SYSTEMS.len(), 14);
        for system in SYSTEMS {
            validate(system).unwrap();
            let rows = row_count(system.fields.len());
            let required = system.required_zero_mask.count_ones() as usize;
            assert_eq!(
                (0..rows)
                    .filter(|&row| {
                        let mut values = [0_i64; MAX_FIELDS];
                        fill_ternary_row(row, &mut values[..system.fields.len()]);
                        semantic_tuple_survives(system, &values)
                    })
                    .count(),
                3_usize.pow((system.fields.len() - required) as u32),
                "{}",
                system.slug
            );
        }
    }

    #[test]
    fn semantic_label_kernel_allocates_nothing() {
        let system = SYSTEMS[13];
        let values = [0_i64; MAX_FIELDS];
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                std::hint::black_box(semantic_tuple_survives(system, &values));
            }
        });
        assert_eq!(allocations, 0);
    }
}
