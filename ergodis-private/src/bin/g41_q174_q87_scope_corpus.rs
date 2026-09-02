use std::fs::{self, File};
use std::io::{BufWriter, Write};
use std::path::PathBuf;

use anyhow::{Context, Result};
use serde::Deserialize;
use serde_json::json;
use sha2::{Digest, Sha256};

#[derive(Deserialize)]
struct Scope {
    shifts: Vec<u8>,
    surviving_profile_quartets: u8,
}

#[derive(Deserialize)]
struct Input {
    source_digest: [u8; 32],
    candidate_classes: Vec<u8>,
    minimum_additional_classes: Option<u8>,
    sufficient_scopes: Vec<Scope>,
}

fn main() -> Result<()> {
    let input_path = PathBuf::from(
        std::env::args_os()
            .nth(1)
            .context("expected scope-evolution report path")?,
    );
    let output_path = PathBuf::from(
        std::env::args_os()
            .nth(2)
            .context("expected corpus output path")?,
    );
    let source = fs::read(input_path)?;
    let input: Input = serde_json::from_slice(&source)?;
    anyhow::ensure!(
        !input.candidate_classes.is_empty() && input.candidate_classes.len() <= 20,
        "candidate class width is invalid"
    );
    let width = input
        .minimum_additional_classes
        .context("scope evolution found no sufficient width")?;
    let mut sufficient = Vec::new();
    for scope in &input.sufficient_scopes {
        if scope.shifts.len() != usize::from(width) || scope.surviving_profile_quartets != 0 {
            continue;
        }
        let mut mask = 0_u64;
        for shift in &scope.shifts {
            let index = input
                .candidate_classes
                .iter()
                .position(|candidate| candidate == shift)
                .context("sufficient scope contains an unknown class")?;
            mask |= 1_u64 << index;
        }
        sufficient.push(mask);
    }
    sufficient.sort_unstable();
    sufficient.dedup();
    let row_masks: Vec<u64> = (1_u64..1_u64 << input.candidate_classes.len())
        .filter(|mask| mask.count_ones() == u32::from(width))
        .collect();
    anyhow::ensure!(
        !sufficient.is_empty() && sufficient.len() < row_masks.len(),
        "scope corpus lost one label"
    );
    let mut permutation: Vec<usize> = (0..input.candidate_classes.len()).collect();
    let mut seed = u64::from_le_bytes(input.source_digest[..8].try_into().unwrap());
    for upper in (1..permutation.len()).rev() {
        seed ^= seed >> 12;
        seed ^= seed << 25;
        seed ^= seed >> 27;
        let lower = (seed.wrapping_mul(0x2545_f491_4f6c_dd1d) % (upper as u64 + 1)) as usize;
        permutation.swap(lower, upper);
    }
    let fields: Vec<String> = (0..permutation.len())
        .map(|index| format!("f{index:03}"))
        .collect();
    let mut field_to_candidate_class = vec![0_u8; permutation.len()];
    for (candidate, &field) in permutation.iter().enumerate() {
        field_to_candidate_class[field] = input.candidate_classes[candidate];
    }
    let commitment: [u8; 32] = Sha256::digest(source).into();
    let commitment_hex: String = commitment
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect();
    let mut writer = BufWriter::with_capacity(64 * 1024, File::create(output_path)?);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": "opaque-exact-scope-candidates-v1",
            "problem": "opaque-minimum-sufficient-scope",
            "fields": fields,
            "rows": row_masks.len(),
            "generator": {
                "name": "c1016-generic-candidate-identity-expander",
                "version": "1",
                "digest": commitment_hex,
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    for (id, &mask) in row_masks.iter().enumerate() {
        let mut values = vec![0_i64; permutation.len()];
        for (candidate, &field) in permutation.iter().enumerate() {
            values[field] = i64::from(mask & (1_u64 << candidate) != 0);
        }
        serde_json::to_writer(
            &mut writer,
            &json!({
                "id": id,
                "expected": sufficient.binary_search(&mask).is_ok(),
                "values": values,
            }),
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    println!(
        "{}",
        serde_json::to_string(&json!({
            "rows": row_masks.len(),
            "positive_rows": sufficient.len(),
            "scope_width": width,
            "opaque_fields": fields.len(),
            "field_to_candidate_class": field_to_candidate_class,
            "source_commitment": commitment,
            "provenance": "generic opaque fixed-width mask presentation of exact candidate-scope evaluations; field permutation is source-bound, labels are copied from the exact bounded evaluator, and no shift number or theorem name is presented to Ergodis",
        }))?
    );
    Ok(())
}
