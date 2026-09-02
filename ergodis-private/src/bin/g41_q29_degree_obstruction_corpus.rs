use std::collections::{BTreeSet, BinaryHeap};
use std::fs::{self, OpenOptions};
use std::io::{BufWriter, Write};
use std::path::{Path, PathBuf};

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_exact_tablebase::{
    canonical_g41_q29_block_spec, compile_g41_q29_aggregate_block_tablebase,
    compile_g41_q29_fixed_zero_defect_tablebase, g41_q29_degree_sequence_decomposition_feasible,
    g41_q29_slot_aggregate_signature,
};
use ergodis_private::symmetric_feature_evolve::expand_symmetric_scalar_features;
use serde::Deserialize;
use serde_json::json;
use sha2::{Digest, Sha256};

const FIELDS: usize = 20;
const ORDINARY_ROWS: usize = 4_096;
const OBSTRUCTION_REPLICAS: usize = 128;
type RankedRow = (u8, u64, u64, [i64; FIELDS]);

#[derive(Parser)]
struct Args {
    #[arg(long)]
    witness_cache: PathBuf,
    #[arg(long)]
    participation: PathBuf,
    #[arg(long)]
    output_dir: PathBuf,
}

#[derive(Deserialize)]
struct Participation {
    source_profiles: [u32; 4],
    source_profile_digests: [[u8; 32]; 4],
    participating_profile_indices: Option<[Vec<u32>; 4]>,
}

fn digit_counts(digits: u32) -> [u8; 6] {
    [
        (digits & 7) as u8,
        ((digits >> 3) & 7) as u8,
        ((digits >> 6) & 15) as u8,
        ((digits >> 10) & 15) as u8,
        ((digits >> 14) & 15) as u8,
        ((digits >> 18) & 15) as u8,
    ]
}

fn features(digits: u32, coefficients: [u8; 8]) -> Result<[i64; FIELDS]> {
    let counts = digit_counts(digits).map(i64::from);
    let nonzero: [i64; 7] =
        std::array::from_fn(|coordinate| i64::from(coefficients[coordinate + 1]));
    let mut expanded = [0_i64; 20];
    let width = expand_symmetric_scalar_features(&nonzero, &mut expanded)
        .context("coefficient symmetric expansion failed")?;
    let mut output = [0_i64; FIELDS];
    output[..4].copy_from_slice(&expanded[width - 4..width]);
    let mut cursor = 4;
    for pair in 0..3 {
        let raw = [counts[2 * pair], counts[2 * pair + 1]];
        let width = expand_symmetric_scalar_features(&raw, &mut expanded)
            .context("pair symmetric expansion failed")?;
        output[cursor..cursor + 4].copy_from_slice(&expanded[width - 4..width]);
        cursor += 4;
    }
    let width = expand_symmetric_scalar_features(&counts, &mut expanded)
        .context("digit symmetric expansion failed")?;
    output[cursor..cursor + 4].copy_from_slice(&expanded[width - 4..width]);
    Ok(output)
}

fn mix(mut value: u64) -> u64 {
    value ^= value >> 30;
    value = value.wrapping_mul(0xbf58_476d_1ce4_e5b9);
    value ^= value >> 27;
    value = value.wrapping_mul(0x94d0_49bb_1331_11eb);
    value ^ (value >> 31)
}

fn row_hash(digits: u32, coefficients: [u8; 8], source: [u8; 32]) -> u64 {
    let mut packed = u64::from(digits);
    for (coordinate, value) in coefficients.into_iter().enumerate() {
        packed ^= u64::from(value) << (5 * coordinate);
    }
    let mut source_prefix = [0_u8; 8];
    source_prefix.copy_from_slice(&source[..8]);
    packed ^= u64::from_le_bytes(source_prefix);
    mix(packed)
}

fn write_corpus(
    path: &Path,
    split: &str,
    ordinary: &BinaryHeap<RankedRow>,
    obstruction: [i64; FIELDS],
    permutation: [usize; FIELDS],
    source_digest: [u8; 32],
) -> Result<()> {
    let rows = ordinary.len() + OBSTRUCTION_REPLICAS;
    let fields: Vec<String> = (0..FIELDS).map(|field| format!("f{field:03}")).collect();
    let file = OpenOptions::new().write(true).create_new(true).open(path)?;
    let mut writer = BufWriter::with_capacity(256 * 1024, file);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": format!("opaque-symmetric-degree-obstruction-{split}-v3"),
            "problem": "opaque-bounded-degree-sequence-obstruction",
            "fields": fields,
            "rows": rows,
            "generator": {
                "name": "c1016-generic-symmetric-degree-obstruction",
                "version": "3",
                "digest": source_digest.iter().map(|byte| format!("{byte:02x}")).collect::<String>(),
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    let mut id = 0_u64;
    for (_, _, _, values) in ordinary.iter() {
        let mut presented = [0_i64; FIELDS];
        for source in 0..FIELDS {
            presented[permutation[source]] = values[source];
        }
        serde_json::to_writer(
            &mut writer,
            &json!({"id": id, "expected": false, "values": presented}),
        )?;
        writer.write_all(b"\n")?;
        id += 1;
    }
    for _ in 0..OBSTRUCTION_REPLICAS {
        let mut presented = [0_i64; FIELDS];
        for source in 0..FIELDS {
            presented[permutation[source]] = obstruction[source];
        }
        serde_json::to_writer(
            &mut writer,
            &json!({"id": id, "expected": true, "values": presented}),
        )?;
        writer.write_all(b"\n")?;
        id += 1;
    }
    writer.flush()?;
    Ok(())
}

fn write_exhaustive_holdout(
    path: &Path,
    digits: &BTreeSet<u32>,
    coefficients: &[[u8; 8]],
    excluded: (u32, [u8; 8]),
    permutation: [usize; FIELDS],
    source_digest: [u8; 32],
) -> Result<()> {
    let rows = digits
        .len()
        .checked_mul(coefficients.len())
        .and_then(|rows| rows.checked_sub(1))
        .context("exhaustive holdout row count overflow")?;
    let fields: Vec<String> = (0..FIELDS).map(|field| format!("f{field:03}")).collect();
    let file = OpenOptions::new().write(true).create_new(true).open(path)?;
    let mut writer = BufWriter::with_capacity(256 * 1024, file);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": "opaque-symmetric-degree-obstruction-holdout-v3",
            "problem": "opaque-bounded-degree-sequence-obstruction",
            "fields": fields,
            "rows": rows,
            "generator": {
                "name": "c1016-generic-symmetric-degree-obstruction",
                "version": "3",
                "digest": source_digest.iter().map(|byte| format!("{byte:02x}")).collect::<String>(),
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    let mut id = 0_u64;
    for &digit_value in digits {
        for &coefficient_values in coefficients {
            if (digit_value, coefficient_values) == excluded {
                continue;
            }
            let values = features(digit_value, coefficient_values)?;
            let mut presented = [0_i64; FIELDS];
            for source in 0..FIELDS {
                presented[permutation[source]] = values[source];
            }
            let expected =
                !g41_q29_degree_sequence_decomposition_feasible(digit_value, coefficient_values)?;
            serde_json::to_writer(
                &mut writer,
                &json!({"id": id, "expected": expected, "values": presented}),
            )?;
            writer.write_all(b"\n")?;
            id += 1;
        }
    }
    ensure!(id == rows as u64);
    writer.flush()?;
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    let witness_bytes = fs::read(&args.witness_cache)?;
    let participation_bytes = fs::read(&args.participation)?;
    let mut hasher = Sha256::new();
    hasher.update(&witness_bytes);
    hasher.update(&participation_bytes);
    let source_digest: [u8; 32] = hasher.finalize().into();
    let source = read_g41_digit_witness_cache(witness_bytes.as_slice())?;
    let participation: Participation = serde_json::from_slice(&participation_bytes)?;
    let indices = participation
        .participating_profile_indices
        .context("participation artifact omitted exact indices")?;
    let aggregate = compile_g41_q29_aggregate_block_tablebase([8, 3, 15, 15])?;
    ensure!(aggregate.profiles.len() as u32 == participation.source_profiles[0]);
    ensure!(aggregate.report.profile_digest == participation.source_profile_digests[0]);
    let fixed = compile_g41_q29_fixed_zero_defect_tablebase(260, 8)?;
    let mut coefficients = Vec::with_capacity(indices[0].len());
    for &index in &indices[0] {
        let profile = *aggregate
            .profiles
            .get(index as usize)
            .context("A participation index is outside its profile table")?;
        let fibre = fixed.coefficient_fibre(profile)?;
        ensure!(fibre.len == 1);
        coefficients.push(fibre.coefficient_values[0]);
    }
    let mut digits = BTreeSet::new();
    for witness in &source.witnesses {
        for block in 0..4 {
            let (mask, value, _) =
                canonical_g41_q29_block_spec(witness.masks[block], witness.digits[block])?;
            if g41_q29_slot_aggregate_signature(mask, value)?[0] == 8 {
                digits.insert(value);
            }
        }
    }
    ensure!(digits.len() == 112);

    let mut obstructions = Vec::new();
    for &digits in &digits {
        for &coefficients in &coefficients {
            let values = features(digits, coefficients)?;
            if !g41_q29_degree_sequence_decomposition_feasible(digits, coefficients)? {
                obstructions.push((digits, coefficients, values));
            }
        }
    }
    ensure!(obstructions.len() == 2);
    obstructions.sort_unstable_by_key(|entry| entry.0);
    ensure!(obstructions[0].2 == obstructions[1].2);
    let obstruction_features = obstructions[0].2;
    let mut ordinary: [BinaryHeap<RankedRow>; 2] =
        std::array::from_fn(|_| BinaryHeap::with_capacity(ORDINARY_ROWS + 1));
    for &digits in &digits {
        for &coefficients in &coefficients {
            if !g41_q29_degree_sequence_decomposition_feasible(digits, coefficients)? {
                continue;
            }
            let values = features(digits, coefficients)?;
            let different = values
                .iter()
                .zip(obstruction_features)
                .filter(|(left, right)| **left != *right)
                .count() as u8;
            let distance = values
                .iter()
                .zip(obstruction_features)
                .map(|(&left, right)| left.abs_diff(right))
                .try_fold(0_u64, u64::checked_add)
                .context("feature distance overflow")?;
            let hash = row_hash(digits, coefficients, source_digest);
            let split = (hash & 1) as usize;
            ordinary[split].push((different, distance, hash >> 1, values));
            if ordinary[split].len() > ORDINARY_ROWS {
                ordinary[split].pop();
            }
        }
    }
    ensure!(ordinary.iter().all(|rows| rows.len() == ORDINARY_ROWS));
    ensure!(ordinary
        .iter()
        .flat_map(|rows| rows.iter())
        .all(|(_, _, _, values)| *values != obstructions[0].2));

    let mut permutation = std::array::from_fn(|index| index);
    let mut seed_bytes = [0_u8; 8];
    seed_bytes.copy_from_slice(&source_digest[8..16]);
    let mut seed = u64::from_le_bytes(seed_bytes);
    for upper in (1..FIELDS).rev() {
        seed = mix(seed);
        let lower = (seed % (upper as u64 + 1)) as usize;
        permutation.swap(lower, upper);
    }
    fs::create_dir_all(&args.output_dir)?;
    write_corpus(
        &args.output_dir.join("degree-obstruction-train.jsonl"),
        "train",
        &ordinary[0],
        obstructions[0].2,
        permutation,
        source_digest,
    )?;
    write_exhaustive_holdout(
        &args.output_dir.join("degree-obstruction-holdout.jsonl"),
        &digits,
        &coefficients,
        (obstructions[0].0, obstructions[0].1),
        permutation,
        source_digest,
    )?;
    println!(
        "{}",
        serde_json::to_string(&json!({
            "source_digest": source_digest,
            "grouped_rows_scanned": digits.len() * coefficients.len(),
            "ordinary_training_rows": ORDINARY_ROWS,
            "exhaustive_holdout_rows": digits.len() * coefficients.len() - 1,
            "obstruction_replicas_per_split": OBSTRUCTION_REPLICAS,
            "obstruction_keys": obstructions.iter().map(|(digits, coefficients, _)| json!({"digits": digits, "coefficient_values": coefficients})).collect::<Vec<_>>(),
            "opaque_fields": FIELDS,
            "provenance": "source-bound actual A-class grouped domain; labels come only from the diagnostic capacitated degree-sequence predicate; generic symmetric expansions erase coefficient order and within-equivalent-pair order before one opaque field permutation; training uses one obstruction and source-hash-partitioned nearest feasible CEGAR boundary counterexamples; holdout exhausts every source key except the training obstruction",
        }))?
    );
    Ok(())
}
