use std::collections::BTreeMap;
use std::fs::{self, File};
use std::io::{BufWriter, Write};
use std::path::PathBuf;

use anyhow::{Context, Result};
use serde::Deserialize;
use serde_json::json;
use sha2::{Digest, Sha256};

#[derive(Deserialize)]
struct SignatureReport {
    signature: [u8; 4],
    profile_digest: [u8; 32],
}

#[derive(Deserialize)]
struct Census {
    signatures: Vec<SignatureReport>,
}

fn main() -> Result<()> {
    let input_path = PathBuf::from(
        std::env::args_os()
            .nth(1)
            .context("expected signature-census artifact path")?,
    );
    let output_dir = PathBuf::from(
        std::env::args_os()
            .nth(2)
            .context("expected corpus output directory")?,
    );
    let source = fs::read(input_path)?;
    let census: Census = serde_json::from_slice(&source)?;
    anyhow::ensure!(!census.signatures.is_empty(), "empty signature census");
    let commitment: [u8; 32] = Sha256::digest(&source).into();
    let mut classes = BTreeMap::<[u8; 32], usize>::new();
    for entry in &census.signatures {
        if !classes.contains_key(&entry.profile_digest) {
            let next = classes.len();
            classes.insert(entry.profile_digest, next);
        }
    }
    anyhow::ensure!(classes.len() >= 2, "signature census has only one class");
    fs::create_dir_all(&output_dir)?;

    let mut permutation = [0_usize, 1, 2, 3];
    let mut seed = u64::from_le_bytes(commitment[..8].try_into().unwrap());
    for upper in (1..permutation.len()).rev() {
        seed ^= seed >> 12;
        seed ^= seed << 25;
        seed ^= seed >> 27;
        let lower = (seed.wrapping_mul(0x2545_f491_4f6c_dd1d) % (upper as u64 + 1)) as usize;
        permutation.swap(lower, upper);
    }
    let digest_hex = commitment
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect::<String>();
    for (target_digest, class) in &classes {
        let path = output_dir.join(format!("signature-class-{class}.jsonl"));
        let mut writer = BufWriter::with_capacity(16 * 1024, File::create(path)?);
        serde_json::to_writer(
            &mut writer,
            &json!({
                "schema": "ergodis-campaign-data-v0",
                "presentation": format!("opaque-q29-signature-class-{class}-v1"),
                "problem": "opaque-exact-profile-equivalence-class",
                "fields": ["f000", "f001", "f002", "f003"],
                "rows": census.signatures.len(),
                "generator": {
                    "name": "c1016-q29-signature-census-expander",
                    "version": "1",
                    "digest": digest_hex,
                }
            }),
        )?;
        writer.write_all(b"\n")?;
        for (id, entry) in census.signatures.iter().enumerate() {
            let mut values = [0_i64; 4];
            for source_field in 0..4 {
                values[permutation[source_field]] = i64::from(entry.signature[source_field]);
            }
            serde_json::to_writer(
                &mut writer,
                &json!({
                    "id": id,
                    "expected": entry.profile_digest == *target_digest,
                    "values": values,
                }),
            )?;
            writer.write_all(b"\n")?;
        }
        writer.flush()?;
    }
    println!(
        "{}",
        serde_json::to_string(&json!({
            "rows": census.signatures.len(),
            "classes": classes.len(),
            "opaque_fields": 4,
            "field_permutation": permutation,
            "source_commitment": commitment,
            "provenance": "opaque source-bound one-vs-rest presentations; labels are derived only from exact profile-table digests, features contain only permuted raw aggregate-signature integers, and neither theorem names nor expected field scopes are embedded",
        }))?
    );
    Ok(())
}
