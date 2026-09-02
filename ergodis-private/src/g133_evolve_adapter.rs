//! Typed discovery-only Ergodis campaign adapter for exact g133 shift cells.

use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::Path;

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g133_sparse_defect::{
    compile_g133_exact_shift_cell_corpus, G133ExactShiftCellCorpus, G133ExactShiftCellRow,
    G133SparseError,
};

const DATA_SCHEMA: &str = "ergodis-campaign-data-v0";
const GENERATOR_NAME: &str = "c1016-g133-exact-shift-cells";
const GENERATOR_VERSION: &str = "4";
const MAX_ROWS: usize = 1 << 20;
const MAX_CELLS: usize = 1 << 25;
pub const G133_EVOLVE_FIELDS: [&str; 30] = [
    "b0_configurations",
    "b1_configurations",
    "b2_configurations",
    "b3_configurations",
    "b0_energy_values",
    "b1_energy_values",
    "b2_energy_values",
    "b3_energy_values",
    "b0_q1_profiles",
    "b1_q1_profiles",
    "b2_q1_profiles",
    "b3_q1_profiles",
    "b0_shift_profiles",
    "b1_shift_profiles",
    "b2_shift_profiles",
    "b3_shift_profiles",
    "left_pair_keys",
    "left_pair_values",
    "right_pair_keys",
    "right_pair_values",
    "left_pair_holes",
    "right_pair_holes",
    "left_interval_keys",
    "right_interval_keys",
    "left_maximum_holes",
    "right_maximum_holes",
    "left_residue_bits",
    "right_residue_bits",
    "base_sumset_pairs",
    "hole_covered_pairs",
];

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub enum G133CampaignLabel {
    Survives,
    Excluded,
}

impl G133CampaignLabel {
    const fn name(self) -> &'static str {
        match self {
            Self::Survives => "survives",
            Self::Excluded => "excluded",
        }
    }

    const fn expected(self, row: &G133ExactShiftCellRow) -> bool {
        match self {
            Self::Survives => row.survives,
            Self::Excluded => !row.survives,
        }
    }
}

#[derive(Debug, Error)]
pub enum G133EvolveAdapterError {
    #[error("g133 campaign corpus exceeds its declared bound")]
    ResourceBound,
    #[error(transparent)]
    Sparse(#[from] G133SparseError),
    #[error(transparent)]
    Io(#[from] std::io::Error),
    #[error(transparent)]
    Json(#[from] serde_json::Error),
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133EvolveAdapterReport {
    pub shift: u8,
    pub label: &'static str,
    pub rows: u32,
    pub weighted_roots: u64,
    pub weighted_survivors: u64,
    pub weighted_exclusions: u64,
    pub generator_digest: [u8; 32],
    pub provenance: &'static str,
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
struct DataRow {
    id: u64,
    weight: u64,
    expected: bool,
    values: [i64; G133_EVOLVE_FIELDS.len()],
}

fn values(row: &G133ExactShiftCellRow) -> [i64; G133_EVOLVE_FIELDS.len()] {
    let mut output = [0_i64; G133_EVOLVE_FIELDS.len()];
    for block in 0..4 {
        output[block] = i64::from(row.block_configurations[block]);
        output[4 + block] = i64::from(row.block_energy_values[block]);
        output[8 + block] = i64::from(row.block_q1_profiles[block]);
        output[12 + block] = i64::from(row.block_shift_profiles[block]);
    }
    output[16] = i64::from(row.left_pair_keys);
    output[17] = i64::from(row.left_pair_values);
    output[18] = i64::from(row.right_pair_keys);
    output[19] = i64::from(row.right_pair_values);
    output[20] = i64::from(row.left_pair_holes);
    output[21] = i64::from(row.right_pair_holes);
    output[22] = i64::from(row.left_interval_keys);
    output[23] = i64::from(row.right_interval_keys);
    output[24] = i64::from(row.left_maximum_holes);
    output[25] = i64::from(row.right_maximum_holes);
    output[26] = i64::from(row.left_residue_bits);
    output[27] = i64::from(row.right_residue_bits);
    output[28] = i64::from(row.base_sumset_pairs);
    output[29] = i64::from(row.hole_covered_pairs);
    output
}

fn generator_digest(corpus: &G133ExactShiftCellCorpus, label: G133CampaignLabel) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(GENERATOR_NAME.as_bytes());
    hasher.update(GENERATOR_VERSION.as_bytes());
    hasher.update(label.name().as_bytes());
    hasher.update([corpus.report.shift]);
    hasher.update(corpus.report.q0_q1_roots.to_le_bytes());
    hasher.update(corpus.report.exact_shift_candidates.to_le_bytes());
    hasher.update(corpus.report.candidate_digest);
    for field in G133_EVOLVE_FIELDS {
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

pub fn write_g133_exact_shift_campaign(
    shift: usize,
    output: &Path,
) -> Result<G133EvolveAdapterReport, G133EvolveAdapterError> {
    write_g133_exact_shift_campaign_with_label(shift, G133CampaignLabel::Survives, output)
}

pub fn write_g133_exact_shift_campaign_with_label(
    shift: usize,
    label: G133CampaignLabel,
    output: &Path,
) -> Result<G133EvolveAdapterReport, G133EvolveAdapterError> {
    let corpus = compile_g133_exact_shift_cell_corpus(shift)?;
    if corpus.rows.len() > MAX_ROWS
        || corpus.rows.len().saturating_mul(G133_EVOLVE_FIELDS.len()) > MAX_CELLS
    {
        return Err(G133EvolveAdapterError::ResourceBound);
    }
    let digest = generator_digest(&corpus, label);
    let weighted_survivors = corpus
        .rows
        .iter()
        .filter(|row| row.survives)
        .try_fold(0_u64, |sum, row| sum.checked_add(row.weight))
        .ok_or(G133EvolveAdapterError::ResourceBound)?;
    if weighted_survivors != corpus.report.exact_shift_candidates {
        return Err(G133EvolveAdapterError::ResourceBound);
    }
    let file: File = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)?;
    let mut writer = BufWriter::with_capacity(64 * 1024, file);
    let header = DataHeader {
        schema: DATA_SCHEMA,
        presentation: format!(
            "c1016-g133-exact-q{}-{}-cells-v4",
            corpus.report.shift,
            label.name()
        ),
        problem: format!("order-2092-g133-q{}-{}", corpus.report.shift, label.name()),
        fields: &G133_EVOLVE_FIELDS,
        rows: corpus.rows.len(),
        generator: GeneratorHeader {
            name: GENERATOR_NAME,
            version: GENERATOR_VERSION,
            digest: digest_hex(digest),
        },
    };
    serde_json::to_writer(&mut writer, &header)?;
    writer.write_all(b"\n")?;
    for row in &corpus.rows {
        serde_json::to_writer(
            &mut writer,
            &DataRow {
                id: u64::from(row.id),
                weight: row.weight,
                expected: label.expected(row),
                values: values(row),
            },
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    Ok(G133EvolveAdapterReport {
        shift: corpus.report.shift,
        label: label.name(),
        rows: corpus.rows.len() as u32,
        weighted_roots: corpus.report.q0_q1_roots,
        weighted_survivors,
        weighted_exclusions: corpus.report.exact_shift_reduction,
        generator_digest: digest,
        provenance: "discovery-only Ergodis feature batch; labels come from sealed-candidate exact computation but evolved predicates have no pruning or certificate authority",
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn feature_projection_excludes_opaque_cell_id_and_label() {
        let row = G133ExactShiftCellRow {
            id: 99,
            weight: 7,
            survives: true,
            block_configurations: [1, 2, 3, 4],
            block_energy_values: [5, 6, 7, 8],
            block_q1_profiles: [9, 10, 11, 12],
            block_shift_profiles: [13, 14, 15, 16],
            left_pair_keys: 17,
            left_pair_values: 18,
            right_pair_keys: 19,
            right_pair_values: 20,
            left_pair_holes: 21,
            right_pair_holes: 22,
            left_interval_keys: 23,
            right_interval_keys: 24,
            left_maximum_holes: 25,
            right_maximum_holes: 26,
            left_residue_bits: 27,
            right_residue_bits: 28,
            base_sumset_pairs: 29,
            hole_covered_pairs: 30,
        };
        assert_eq!(values(&row), std::array::from_fn(|index| index as i64 + 1));
        assert!(G133CampaignLabel::Survives.expected(&row));
        assert!(!G133CampaignLabel::Excluded.expected(&row));
        assert!(!G133_EVOLVE_FIELDS.contains(&"id"));
        assert!(!G133_EVOLVE_FIELDS.contains(&"survives"));
    }
}
