use std::fs::{self, File};
use std::io::{BufWriter, Write};
use std::path::PathBuf;

use anyhow::{Context, Result};
use serde::Deserialize;
use serde_json::json;
use sha2::{Digest, Sha256};

#[derive(Deserialize)]
struct Attempt {
    left_slots: [u8; 3],
    right_slots: [u8; 3],
    maximum_raw_product: u64,
    failed_side: Option<u8>,
}

#[derive(Deserialize)]
struct Input {
    slot_states: [u32; 6],
    partition_attempts: Vec<Attempt>,
}

fn product(slots: [u8; 3], cardinalities: [u32; 6]) -> u64 {
    slots
        .into_iter()
        .map(|slot| u64::from(cardinalities[usize::from(slot)]))
        .product()
}

fn main() -> Result<()> {
    let input_path = PathBuf::from(
        std::env::args_os()
            .nth(1)
            .context("expected q174 joint report path")?,
    );
    let output_path = PathBuf::from(
        std::env::args_os()
            .nth(2)
            .context("expected corpus output path")?,
    );
    let source = fs::read(input_path)?;
    let input: Input = serde_json::from_slice(&source)?;
    anyhow::ensure!(
        input.partition_attempts.len() >= 2
            && input
                .partition_attempts
                .iter()
                .any(|attempt| attempt.failed_side.is_none())
            && input
                .partition_attempts
                .iter()
                .any(|attempt| attempt.failed_side.is_some()),
        "partition trace lost one label"
    );
    let commitment: [u8; 32] = Sha256::digest(&source).into();
    let mut permutation: Vec<usize> = (0..10).collect();
    let mut seed = u64::from_le_bytes(commitment[..8].try_into().unwrap());
    for upper in (1..permutation.len()).rev() {
        seed ^= seed >> 12;
        seed ^= seed << 25;
        seed ^= seed >> 27;
        let lower = (seed.wrapping_mul(0x2545_f491_4f6c_dd1d) % (upper as u64 + 1)) as usize;
        permutation.swap(lower, upper);
    }
    let fields: Vec<String> = (0..10).map(|field| format!("f{field:03}")).collect();
    let mut writer = BufWriter::with_capacity(16 * 1024, File::create(output_path)?);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": "opaque-q174-partition-attempts-v1",
            "problem": "opaque-bounded-partition-selection",
            "fields": fields,
            "rows": input.partition_attempts.len(),
            "generator": {
                "name": "c1016-q174-partition-trace-expander",
                "version": "1",
                "digest": commitment.iter().map(|byte| format!("{byte:02x}")).collect::<String>(),
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    for (id, attempt) in input.partition_attempts.iter().enumerate() {
        let left_raw = product(attempt.left_slots, input.slot_states);
        let right_raw = product(attempt.right_slots, input.slot_states);
        anyhow::ensure!(
            attempt.maximum_raw_product == left_raw.max(right_raw),
            "partition trace raw score mismatch"
        );
        let mut raw = [0_i64; 10];
        for slot in attempt.left_slots {
            raw[usize::from(slot)] = 1;
        }
        raw[6] = left_raw.try_into()?;
        raw[7] = right_raw.try_into()?;
        raw[8] = attempt.maximum_raw_product.try_into()?;
        raw[9] = left_raw.abs_diff(right_raw).try_into()?;
        let mut values = [0_i64; 10];
        for source_field in 0..10 {
            values[permutation[source_field]] = raw[source_field];
        }
        serde_json::to_writer(
            &mut writer,
            &json!({
                "id": id,
                "expected": attempt.failed_side.is_none(),
                "values": values,
            }),
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    println!(
        "{}",
        serde_json::to_string(&json!({
            "rows": input.partition_attempts.len(),
            "opaque_fields": 10,
            "field_permutation": permutation,
            "source_commitment": commitment,
            "provenance": "opaque source-bound presentation of the bounded planner trace; success labels come only from exact projection-aware side compilation, while the features expose candidate membership and cardinality costs without slot names or the selected partition",
        }))?
    );
    Ok(())
}
