use std::fs::{create_dir_all, File};
use std::io::{BufWriter, Write};
use std::path::PathBuf;

use anyhow::{Context, Result};
use clap::Parser;
use ergodis_private::g41_q174_joint::prove_g41_q174_coset_complement_symmetry;
use serde::Deserialize;
use serde_json::json;
use sha2::{Digest, Sha256};

#[derive(Parser)]
struct Args {
    input: PathBuf,
    output_dir: PathBuf,
}

#[derive(Deserialize)]
struct Input {
    target_fibres: [TargetFibre; 4],
}

#[derive(Deserialize)]
struct TargetFibre {
    states_by_target: Vec<Vec<u128>>,
}

fn lane(state: u128, lane: u8) -> u8 {
    ((state >> (2 * usize::from(lane))) & 3) as u8
}

fn write_corpus(
    path: &PathBuf,
    header: &serde_json::Value,
    rows: &[serde_json::Value],
) -> Result<()> {
    let mut output = BufWriter::new(File::create(path)?);
    serde_json::to_writer(&mut output, header)?;
    output.write_all(b"\n")?;
    for row in rows {
        serde_json::to_writer(&mut output, row)?;
        output.write_all(b"\n")?;
    }
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    let source =
        std::fs::read(&args.input).with_context(|| format!("read {}", args.input.display()))?;
    let source_digest: [u8; 32] = Sha256::digest(&source).into();
    let input: Input = serde_json::from_slice(&source)?;
    let proof = prove_g41_q174_coset_complement_symmetry()?;
    let permutation = [3_usize, 0, 6, 1, 5, 2, 4];
    let fields: Vec<_> = (0..7).map(|field| format!("f{field:03}")).collect();
    let mut train = Vec::new();
    let mut holdout = Vec::new();
    let mut id = 0_u64;
    for (block, block_fibres) in input.target_fibres.iter().enumerate() {
        for (target, states) in block_fibres.states_by_target.iter().enumerate() {
            for &state in states {
                let mut semantic = [0_i64; 7];
                for coordinate in 0..7 {
                    let mut pattern = 0_u8;
                    let mut binary = true;
                    for (index, &changed_lane) in proof.changed_lanes[coordinate].iter().enumerate()
                    {
                        match lane(state, changed_lane) {
                            0 => {}
                            3 => pattern |= 1 << index,
                            _ => binary = false,
                        }
                    }
                    let applicable = binary
                        && proof.valid_pattern_masks[coordinate]
                            [..usize::from(proof.valid_pattern_counts[coordinate])]
                            .contains(&pattern);
                    let generator = u128::from(proof.generator_words[coordinate][0])
                        | (u128::from(proof.generator_words[coordinate][1]) << 64);
                    semantic[coordinate] = i64::from(applicable && state ^ generator < state);
                }
                let values: [i64; 7] = std::array::from_fn(|field| semantic[permutation[field]]);
                let expected = values == [0; 7];
                let row = json!({"id": id, "expected": expected, "values": values});
                let mut split = Sha256::new();
                split.update(source_digest);
                split.update((block as u8).to_le_bytes());
                split.update((target as u16).to_le_bytes());
                split.update(state.to_le_bytes());
                if split.finalize()[0] % 5 == 0 {
                    holdout.push(row);
                } else {
                    train.push(row);
                }
                id += 1;
            }
        }
    }
    create_dir_all(&args.output_dir)?;
    let mut generator_hasher = Sha256::new();
    generator_hasher.update(source_digest);
    generator_hasher.update(proof.proof_commitment);
    generator_hasher.update(permutation.map(|value| value as u8));
    let generator_digest = generator_hasher
        .finalize()
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect::<String>();
    let generator = json!({
        "name": "c1016-q174-proved-flip-canonicality",
        "version": "1",
        "digest": generator_digest,
    });
    let train_header = json!({
        "schema": "ergodis-campaign-data-v0",
        "presentation": "opaque-q174-flip-canonical-train-v1",
        "problem": "opaque-q174-profile-fibre-canonicality",
        "fields": fields,
        "rows": train.len(),
        "generator": generator,
    });
    let holdout_header = json!({
        "schema": "ergodis-campaign-data-v0",
        "presentation": "opaque-q174-flip-canonical-holdout-v1",
        "problem": "opaque-q174-profile-fibre-canonicality",
        "fields": fields,
        "rows": holdout.len(),
        "generator": generator,
    });
    write_corpus(
        &args.output_dir.join("q174-flip-canonical-train.jsonl"),
        &train_header,
        &train,
    )?;
    write_corpus(
        &args.output_dir.join("q174-flip-canonical-holdout.jsonl"),
        &holdout_header,
        &holdout,
    )?;
    serde_json::to_writer_pretty(
        std::io::stdout(),
        &json!({
            "training_rows": train.len(),
            "holdout_rows": holdout.len(),
            "total_rows": id,
            "source_digest": source_digest,
            "proof_commitment": proof.proof_commitment,
            "field_permutation": permutation,
            "authority": "discovery-only corpus; the sealed symbolic/source-balance proof is authoritative",
        }),
    )?;
    println!();
    Ok(())
}
