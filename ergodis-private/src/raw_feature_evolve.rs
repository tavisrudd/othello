//! Generic pre-residual feature expansion for blind C1016 evolve controls.
//!
//! The corpus generator observes paired scalar quantities, not their signed
//! residuals. A theorem-agnostic expander emits every raw scalar and every
//! pairwise difference. It receives no rule mask or semantic field name.

use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::Path;

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::banked_semantic_evolve::{banked_semantic_systems, semantic_tuple_survives};

const DATA_SCHEMA: &str = "ergodis-campaign-data-v0";
const GENERATOR_NAME: &str = "c1016-generic-paired-scalar-expander";
const GENERATOR_VERSION: &str = "2";
const ROWS_PER_SPLIT: usize = 1_024;
const MAX_COORDINATES: usize = 7;
const MAX_RAW_FIELDS: usize = 2 * MAX_COORDINATES;
const MAX_EXPANDED_FIELDS: usize = MAX_RAW_FIELDS + MAX_RAW_FIELDS * (MAX_RAW_FIELDS - 1) / 2;

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct RawFeatureCorpusReport {
    pub reduction: &'static str,
    pub split: &'static str,
    pub raw_fields: u8,
    pub expanded_fields: u16,
    pub rows: u32,
    pub positive_rows: u32,
    pub generator_digest: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Debug, Error)]
pub enum RawFeatureEvolveError {
    #[error("unknown banked raw-feature reduction")]
    UnknownReduction,
    #[error("raw-feature system exceeds its fixed bounds")]
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

#[derive(Clone, Copy)]
struct SplitMix64(u64);

impl SplitMix64 {
    #[inline(always)]
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9e37_79b9_7f4a_7c15);
        let mut value = self.0;
        value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
        value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
        value ^ (value >> 31)
    }
}

#[inline(always)]
pub fn expand_pairwise_differences(raw: &[i64], output: &mut [i64]) -> usize {
    let needed = expanded_width(raw.len());
    assert!(output.len() >= needed);
    expand_pairwise_differences_validated(raw, output)
}

#[inline(always)]
const fn expanded_width(raw_fields: usize) -> usize {
    raw_fields + raw_fields * raw_fields.saturating_sub(1) / 2
}

#[inline(always)]
fn expand_pairwise_differences_validated(raw: &[i64], output: &mut [i64]) -> usize {
    output[..raw.len()].copy_from_slice(raw);
    let mut cursor = raw.len();
    for left in 0..raw.len() {
        for right in left + 1..raw.len() {
            output[cursor] = raw[left] - raw[right];
            cursor += 1;
        }
    }
    cursor
}

fn opaque_feature_names(fields: usize) -> Vec<String> {
    (0..fields).map(|index| format!("f{index:03}")).collect()
}

fn feature_permutation(fields: usize, source_digest: [u8; 32]) -> [u16; MAX_EXPANDED_FIELDS] {
    let mut permutation = [0_u16; MAX_EXPANDED_FIELDS];
    for (index, slot) in permutation[..fields].iter_mut().enumerate() {
        *slot = index as u16;
    }
    let mut seed_bytes = [0_u8; 8];
    seed_bytes.copy_from_slice(&source_digest[..8]);
    let mut rng = SplitMix64(u64::from_le_bytes(seed_bytes));
    for upper in (1..fields).rev() {
        let lower = (rng.next() % (upper as u64 + 1)) as usize;
        permutation.swap(lower, upper);
    }
    permutation
}

fn nth_set_bit(mut mask: u8, mut ordinal: u32) -> usize {
    loop {
        let index = mask.trailing_zeros() as usize;
        if ordinal == 0 {
            return index;
        }
        mask &= mask - 1;
        ordinal -= 1;
    }
}

fn digest(slug: &str, split: &str, source_digest: [u8; 32]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(GENERATOR_NAME.as_bytes());
    hasher.update(GENERATOR_VERSION.as_bytes());
    hasher.update(slug.as_bytes());
    hasher.update(split.as_bytes());
    hasher.update(source_digest);
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

pub fn write_raw_feature_campaign(
    reduction: &str,
    split: &'static str,
    seed: u64,
    source_digest: [u8; 32],
    output: &Path,
) -> Result<RawFeatureCorpusReport, RawFeatureEvolveError> {
    if split != "train" && split != "holdout" {
        return Err(RawFeatureEvolveError::InvalidSystem);
    }
    let system = banked_semantic_systems()
        .iter()
        .copied()
        .find(|system| system.slug == reduction)
        .ok_or(RawFeatureEvolveError::UnknownReduction)?;
    let coordinates = system.fields.len();
    if coordinates == 0 || coordinates > MAX_COORDINATES {
        return Err(RawFeatureEvolveError::InvalidSystem);
    }
    let raw_fields = 2 * coordinates;
    let expanded_fields = expanded_width(raw_fields);
    let fields = opaque_feature_names(expanded_fields);
    let permutation = feature_permutation(expanded_fields, source_digest);
    let generator_digest = digest(system.slug, split, source_digest);
    let opaque_corpus = &digest_hex(source_digest)[..16];
    let file: File = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)?;
    let mut writer = BufWriter::with_capacity(256 * 1024, file);
    serde_json::to_writer(
        &mut writer,
        &DataHeader {
            schema: DATA_SCHEMA,
            presentation: format!("opaque-paired-scalars-{opaque_corpus}-{split}-v2"),
            problem: format!("opaque-corpus-{opaque_corpus}"),
            fields: &fields,
            rows: ROWS_PER_SPLIT,
            generator: GeneratorHeader {
                name: GENERATOR_NAME,
                version: GENERATOR_VERSION,
                digest: digest_hex(generator_digest),
            },
        },
    )?;
    writer.write_all(b"\n")?;

    let mut rng = SplitMix64(seed);
    let mut residuals = [0_i64; MAX_COORDINATES];
    let mut raw = [0_i64; MAX_RAW_FIELDS];
    let mut expanded = [0_i64; MAX_EXPANDED_FIELDS];
    let mut presented = [0_i64; MAX_EXPANDED_FIELDS];
    let required_count = system.required_zero_mask.count_ones();
    let mut positive_rows = 0_u32;
    for row in 0..ROWS_PER_SPLIT {
        residuals[..coordinates].fill(0);
        let phase = row as u32 % (required_count + 1);
        if phase != 0 {
            let index = nth_set_bit(system.required_zero_mask, phase - 1);
            residuals[index] = if rng.next() & 1 == 0 { -1 } else { 1 };
        }
        for (index, residual) in residuals[..coordinates].iter_mut().enumerate() {
            if system.required_zero_mask & (1_u8 << index) == 0 {
                *residual = (rng.next() % 5) as i64 - 2;
            }
        }
        for index in 0..coordinates {
            let base = (rng.next() % 2_001) as i64 - 1_000;
            raw[2 * index] = base;
            raw[2 * index + 1] = base - residuals[index];
        }
        let width = expand_pairwise_differences_validated(&raw[..raw_fields], &mut expanded);
        debug_assert_eq!(width, fields.len());
        for (target, &source) in permutation[..width].iter().enumerate() {
            presented[target] = expanded[usize::from(source)];
        }
        let expected = semantic_tuple_survives(system, &residuals[..coordinates]);
        positive_rows += u32::from(expected);
        serde_json::to_writer(
            &mut writer,
            &DataRow {
                id: row as u64,
                expected,
                values: &presented[..width],
            },
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    Ok(RawFeatureCorpusReport {
        reduction: system.slug,
        split,
        raw_fields: raw_fields as u8,
        expanded_fields: fields.len() as u16,
        rows: ROWS_PER_SPLIT as u32,
        positive_rows,
        generator_digest,
        provenance: "discovery-only paired scalar observations expanded by the same exhaustive pairwise-difference grammar; labels are independently recomputed by the registered semantic oracle",
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn pairwise_expander_matches_independent_nested_loop() {
        let raw = [7, -3, 11, 5];
        let mut output = [0_i64; 10];
        assert_eq!(expand_pairwise_differences(&raw, &mut output), 10);
        assert_eq!(&output[..4], &raw);
        assert_eq!(&output[4..], &[10, -4, 2, -14, -8, 6]);
    }

    #[test]
    fn pairwise_expander_allocates_nothing() {
        let raw = [0_i64; MAX_RAW_FIELDS];
        let mut output = [0_i64; MAX_EXPANDED_FIELDS];
        assert!(output.len() >= expanded_width(raw.len()));
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                std::hint::black_box(expand_pairwise_differences_validated(&raw, &mut output));
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn blind_presentation_uses_opaque_permuted_fields() {
        let fields = opaque_feature_names(10);
        assert_eq!(fields[0], "f000");
        assert_eq!(fields[9], "f009");
        assert!(fields
            .iter()
            .all(|field| !field.contains('x') && !field.contains('d')));

        let permutation = feature_permutation(10, [0x5a; 32]);
        let mut sorted = permutation[..10].to_vec();
        sorted.sort_unstable();
        assert_eq!(sorted, (0_u16..10).collect::<Vec<_>>());
        assert_ne!(permutation[..10], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    }
}
