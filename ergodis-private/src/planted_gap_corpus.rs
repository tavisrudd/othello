//! Deterministic planted training/direct-model corpus pair for admission tests.
//!
//! The generator plants one latent tie in the training view so that several
//! typed predicates are indistinguishable there while exactly one of them
//! agrees with the direct model. It is a boundary test for the admission
//! lifecycle, not a discovery corpus: no claim of general soundness, of
//! transfer to unplanted corpora, or of discovered mathematics follows from it.
//!
//! Latent state is a residual tuple `r` over [`PLANTED_RESIDUAL_VALUES`]. The
//! truth is `r[0] == 0 && r[1] == 0`; the remaining coordinates are diagnostic.
//! The training view is the sublattice `r[1] == r[2] == r[3]`; the direct-model
//! view is the complete enumeration. Rows present two raw scalars per
//! coordinate whose difference is the residual, expanded by the existing
//! theorem-agnostic pairwise-difference expander and hidden behind opaque
//! permuted field names.

use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::Path;

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::raw_feature_evolve::{
    digest_hex, expand_pairwise_differences, feature_permutation, opaque_feature_names, SplitMix64,
};

const DATA_SCHEMA: &str = "ergodis-campaign-data-v0";
const GENERATOR_NAME: &str = "planted-theorem-gap-corpus";
const GENERATOR_VERSION: &str = "1";

/// Number of latent residual coordinates.
pub const PLANTED_COORDINATES: usize = 5;
/// Two raw scalars are presented per coordinate.
pub const PLANTED_RAW_FIELDS: usize = 2 * PLANTED_COORDINATES;
/// Raw scalars plus every pairwise difference.
pub const PLANTED_EXPANDED_FIELDS: usize =
    PLANTED_RAW_FIELDS + PLANTED_RAW_FIELDS * (PLANTED_RAW_FIELDS - 1) / 2;
/// Residual alphabet, enumerated in this order.
pub const PLANTED_RESIDUAL_VALUES: [i64; 5] = [-2, -1, 0, 1, 2];
/// Coordinates tied to each other in the training view.
pub const PLANTED_TIED_COORDINATES: [usize; 3] = [1, 2, 3];
/// Free coordinates in the training view, in enumeration order.
pub const PLANTED_TRAINING_FREE_COORDINATES: [usize; 2] = [0, 4];

const TRAINING_SEED: u64 = 0x1039_c0de_0000_0001;
const DIRECT_MODEL_SEED: u64 = 0x1039_c0de_ffff_0002;
const BASE_SPAN: u64 = 2_001;
const BASE_OFFSET: i64 = 1_000;

/// Which of the two planted views a corpus file holds.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum PlantedView {
    /// The sublattice the proposer is allowed to see.
    Training,
    /// The complete enumeration admission replays against.
    DirectModel,
}

impl PlantedView {
    pub const fn slug(self) -> &'static str {
        match self {
            Self::Training => "training",
            Self::DirectModel => "direct-model",
        }
    }

    const fn seed(self) -> u64 {
        match self {
            Self::Training => TRAINING_SEED,
            Self::DirectModel => DIRECT_MODEL_SEED,
        }
    }

    /// Number of latent tuples enumerated by this view.
    pub const fn rows(self) -> usize {
        match self {
            Self::Training => PLANTED_RESIDUAL_VALUES
                .len()
                .pow(PLANTED_TRAINING_FREE_COORDINATES.len() as u32 + 1),
            Self::DirectModel => PLANTED_RESIDUAL_VALUES
                .len()
                .pow(PLANTED_COORDINATES as u32),
        }
    }
}

/// The direct-model truth: the reduction the admission checker replays against.
#[inline]
pub fn planted_truth(residuals: &[i64; PLANTED_COORDINATES]) -> bool {
    residuals[0] == 0 && residuals[1] == 0
}

/// The latent residual tuple this view assigns to `row`.
///
/// Enumeration is lexicographic over [`PLANTED_RESIDUAL_VALUES`], most
/// significant coordinate first, so a row index replays without the file.
pub fn planted_residuals(view: PlantedView, row: usize) -> [i64; PLANTED_COORDINATES] {
    let radix = PLANTED_RESIDUAL_VALUES.len();
    let mut residuals = [0_i64; PLANTED_COORDINATES];
    match view {
        PlantedView::DirectModel => {
            let mut remainder = row;
            for slot in residuals.iter_mut().rev() {
                *slot = PLANTED_RESIDUAL_VALUES[remainder % radix];
                remainder /= radix;
            }
        }
        PlantedView::Training => {
            let mut remainder = row;
            let free_low = PLANTED_RESIDUAL_VALUES[remainder % radix];
            remainder /= radix;
            let tie = PLANTED_RESIDUAL_VALUES[remainder % radix];
            remainder /= radix;
            let free_high = PLANTED_RESIDUAL_VALUES[remainder % radix];
            residuals[PLANTED_TRAINING_FREE_COORDINATES[0]] = free_high;
            residuals[PLANTED_TRAINING_FREE_COORDINATES[1]] = free_low;
            for &coordinate in &PLANTED_TIED_COORDINATES {
                residuals[coordinate] = tie;
            }
        }
    }
    residuals
}

/// Independent record of what was planted, for the report and the certificate.
#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct PlantedCorpusReport {
    pub view: &'static str,
    pub rows: u32,
    pub positive_rows: u32,
    pub fields: u16,
    /// Presented index of the expanded field carrying residual `i`.
    pub presented_residual_fields: [u16; PLANTED_COORDINATES],
    /// Presented fields taking a single value across every positive row.
    pub constant_positive_fields: Vec<u16>,
    pub generator_digest: [u8; 32],
    /// SHA-256 of the written corpus file, fingerprinting this view alone.
    pub view_digest: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Debug, Error)]
pub enum PlantedCorpusError {
    #[error("planted corpus presentation lost a residual coordinate")]
    LostResidual,
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
    fields: &'a [String],
    rows: usize,
    generator: GeneratorHeader<'a>,
}

#[derive(Serialize)]
struct DataRow<'a> {
    id: u64,
    expected: bool,
    values: &'a [i64],
}

/// Digest binding both views to one planted family.
pub fn planted_source_digest() -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(GENERATOR_NAME.as_bytes());
    hasher.update(GENERATOR_VERSION.as_bytes());
    hasher.update((PLANTED_COORDINATES as u64).to_le_bytes());
    for &coordinate in &PLANTED_TIED_COORDINATES {
        hasher.update((coordinate as u64).to_le_bytes());
    }
    hasher.finalize().into()
}

fn generator_digest(view: PlantedView) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(planted_source_digest());
    hasher.update(view.slug().as_bytes());
    hasher.update(view.seed().to_le_bytes());
    hasher.finalize().into()
}

/// Presented index of the expanded field holding `a_i - b_i` for each `i`.
///
/// The raw layout is `a_0, b_0, .., a_4, b_4`; the expander appends pairwise
/// differences `raw[l] - raw[r]` for `l < r` in row-major order, so the
/// difference of the adjacent pair `(2i, 2i+1)` sits at a computable offset.
fn residual_field_indices(permutation: &[u16]) -> Option<[u16; PLANTED_COORDINATES]> {
    let mut inverse = [u16::MAX; PLANTED_EXPANDED_FIELDS];
    for (presented, &source) in permutation.iter().enumerate() {
        *inverse.get_mut(usize::from(source))? = presented as u16;
    }
    let mut indices = [0_u16; PLANTED_COORDINATES];
    let mut cursor = PLANTED_RAW_FIELDS;
    let mut expanded = [usize::MAX; PLANTED_COORDINATES];
    for left in 0..PLANTED_RAW_FIELDS {
        for right in left + 1..PLANTED_RAW_FIELDS {
            if right == left + 1 && left % 2 == 0 {
                expanded[left / 2] = cursor;
            }
            cursor += 1;
        }
    }
    for (index, slot) in indices.iter_mut().enumerate() {
        let source = *expanded.get(index)?;
        if source == usize::MAX {
            return None;
        }
        let presented = *inverse.get(source)?;
        if presented == u16::MAX {
            return None;
        }
        *slot = presented;
    }
    Some(indices)
}

/// Write one planted view and return its independent planting record.
pub fn write_planted_view(
    view: PlantedView,
    output: &Path,
) -> Result<PlantedCorpusReport, PlantedCorpusError> {
    let source_digest = planted_source_digest();
    let fields = opaque_feature_names(PLANTED_EXPANDED_FIELDS);
    let permutation = feature_permutation(PLANTED_EXPANDED_FIELDS, source_digest);
    let residual_fields = residual_field_indices(&permutation[..PLANTED_EXPANDED_FIELDS])
        .ok_or(PlantedCorpusError::LostResidual)?;
    let opaque = &digest_hex(source_digest)[..16];
    let rows = view.rows();

    let file: File = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)?;
    let mut writer = BufWriter::with_capacity(256 * 1024, file);
    let mut hasher = Sha256::new();
    let header = serde_json::to_vec(&DataHeader {
        schema: DATA_SCHEMA,
        presentation: format!("planted-gap-{opaque}-{}-v1", view.slug()),
        problem: format!("planted-gap-{opaque}"),
        fields: &fields,
        rows,
        generator: GeneratorHeader {
            name: GENERATOR_NAME,
            version: GENERATOR_VERSION,
            digest: digest_hex(generator_digest(view)),
        },
    })?;
    hasher.update(&header);
    hasher.update(b"\n");
    writer.write_all(&header)?;
    writer.write_all(b"\n")?;

    let mut rng = SplitMix64(view.seed());
    let mut raw = [0_i64; PLANTED_RAW_FIELDS];
    let mut expanded = [0_i64; PLANTED_EXPANDED_FIELDS];
    let mut presented = [0_i64; PLANTED_EXPANDED_FIELDS];
    let mut constants = [None::<i64>; PLANTED_EXPANDED_FIELDS];
    let mut constant_live = [false; PLANTED_EXPANDED_FIELDS];
    let mut positive_rows = 0_u32;
    let mut seen_positive = false;
    for row in 0..rows {
        let residuals = planted_residuals(view, row);
        for (index, &residual) in residuals.iter().enumerate() {
            let base = (rng.next() % BASE_SPAN) as i64 - BASE_OFFSET;
            raw[2 * index] = base;
            raw[2 * index + 1] = base - residual;
        }
        let width = expand_pairwise_differences(&raw, &mut expanded);
        debug_assert_eq!(width, PLANTED_EXPANDED_FIELDS);
        for (target, &source) in permutation[..width].iter().enumerate() {
            presented[target] = expanded[usize::from(source)];
        }
        let expected = planted_truth(&residuals);
        if expected {
            positive_rows += 1;
            if seen_positive {
                for (index, live) in constant_live.iter_mut().enumerate() {
                    *live &= constants[index] == Some(presented[index]);
                }
            } else {
                seen_positive = true;
                for (index, live) in constant_live.iter_mut().enumerate() {
                    constants[index] = Some(presented[index]);
                    *live = true;
                }
            }
        }
        let record = serde_json::to_vec(&DataRow {
            id: row as u64,
            expected,
            values: &presented[..width],
        })?;
        hasher.update(&record);
        hasher.update(b"\n");
        writer.write_all(&record)?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;

    let constant_positive_fields = constant_live
        .iter()
        .enumerate()
        .filter_map(|(index, &live)| live.then_some(index as u16))
        .collect();
    Ok(PlantedCorpusReport {
        view: view.slug(),
        rows: rows as u32,
        positive_rows,
        fields: PLANTED_EXPANDED_FIELDS as u16,
        presented_residual_fields: residual_fields,
        constant_positive_fields,
        generator_digest: generator_digest(view),
        view_digest: hasher.finalize().into(),
        provenance: "planted admission-boundary corpus; the training view is a tied sublattice of the direct-model enumeration and grants no pruning authority",
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn training_view_enumerates_the_tied_sublattice() {
        assert_eq!(PlantedView::Training.rows(), 125);
        assert_eq!(PlantedView::DirectModel.rows(), 3125);
        for row in 0..PlantedView::Training.rows() {
            let residuals = planted_residuals(PlantedView::Training, row);
            assert_eq!(residuals[1], residuals[2]);
            assert_eq!(residuals[2], residuals[3]);
        }
    }

    #[test]
    fn direct_model_enumeration_is_a_bijection_onto_the_alphabet_cube() {
        let mut seen = std::collections::BTreeSet::new();
        for row in 0..PlantedView::DirectModel.rows() {
            assert!(seen.insert(planted_residuals(PlantedView::DirectModel, row)));
        }
        assert_eq!(seen.len(), PlantedView::DirectModel.rows());
    }

    #[test]
    fn unsound_counterexample_families_avoid_the_training_view() {
        let mut counterexamples = 0_usize;
        for row in 0..PlantedView::DirectModel.rows() {
            let residuals = planted_residuals(PlantedView::DirectModel, row);
            if residuals[0] == 0 && residuals[1] != 0 && residuals[2] == 0 {
                counterexamples += 1;
                assert!(residuals[1] != residuals[2]);
            }
        }
        assert_eq!(counterexamples, 100);
    }

    #[test]
    fn residual_fields_are_distinct_under_the_hidden_permutation() {
        let permutation = feature_permutation(PLANTED_EXPANDED_FIELDS, planted_source_digest());
        let indices =
            residual_field_indices(&permutation[..PLANTED_EXPANDED_FIELDS]).expect("residuals");
        let mut sorted = indices.to_vec();
        sorted.sort_unstable();
        sorted.dedup();
        assert_eq!(sorted.len(), PLANTED_COORDINATES);
    }
}
