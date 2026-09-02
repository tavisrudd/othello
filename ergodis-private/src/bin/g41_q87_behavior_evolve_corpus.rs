use std::fs::{self, File};
use std::io::{BufWriter, Write};
use std::path::{Path, PathBuf};

use anyhow::{ensure, Result};
use clap::Parser;
use serde::Deserialize;
use serde_json::json;
use sha2::{Digest, Sha256};

const CAPACITIES: [u8; 6] = [7, 7, 14, 14, 14, 14];

#[derive(Parser)]
struct Args {
    #[arg(long)]
    census: PathBuf,
    #[arg(long)]
    output: PathBuf,
}

#[derive(Clone, Copy, Deserialize)]
struct Spec {
    mask: u8,
    digits: u32,
    digit_counts: [u8; 6],
    behavior: u16,
}

#[derive(Deserialize)]
struct Input {
    specs: Vec<Spec>,
}

fn features(spec: Spec) -> Vec<i64> {
    let mut values = Vec::with_capacity(116);
    for bit in 0..6 {
        values.push(i64::from((spec.mask >> bit) & 1));
    }
    values.extend(spec.digit_counts.map(i64::from));
    for slot in 0..6 {
        values.push(i64::from(
            spec.digit_counts[slot].min(CAPACITIES[slot] - spec.digit_counts[slot]),
        ));
    }
    for slot in 0..6 {
        for threshold in 0_u8..8 {
            values.push(i64::from(spec.digit_counts[slot] <= threshold));
            values.push(i64::from(
                CAPACITIES[slot] - spec.digit_counts[slot] <= threshold,
            ));
        }
    }
    for pair in 0..3 {
        let first = spec.digit_counts[2 * pair];
        let second = spec.digit_counts[2 * pair + 1];
        values.push(i64::from(first + second));
        values.push(i64::from(first.abs_diff(second)));
    }
    values.push(spec.digit_counts.into_iter().map(i64::from).sum());
    values.push(i64::from(spec.mask.count_ones()));
    values
}

fn negative_split(spec: Spec, target: u16) -> usize {
    let mut value =
        u64::from(spec.digits) ^ (u64::from(spec.mask) << 41) ^ (u64::from(target) << 53);
    value ^= value >> 30;
    value = value.wrapping_mul(0xbf58_476d_1ce4_e5b9);
    value ^= value >> 27;
    (value as usize) & 1
}

fn write_corpus(
    path: &Path,
    specs: &[Spec],
    target: u16,
    split: usize,
    source_commitment: &str,
) -> Result<u64> {
    let mut positives_seen = 0_usize;
    let mut selected = Vec::new();
    for &spec in specs {
        let expected = spec.behavior == target;
        let assigned = if expected {
            let assigned = positives_seen & 1;
            positives_seen += 1;
            assigned
        } else {
            negative_split(spec, target)
        };
        if assigned == split {
            selected.push((spec, expected));
        }
    }
    let width = features(specs[0]).len();
    let fields = (0..width)
        .map(|field| format!("f{field:03}"))
        .collect::<Vec<_>>();
    let mut writer = BufWriter::new(File::create(path)?);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": format!("opaque-q87-behavior-{target}-{split}-v1"),
            "problem": "opaque-source-behavior-equivalence",
            "fields": fields,
            "rows": selected.len(),
            "generator": {
                "name": "c1016-generic-bounded-count-features",
                "version": "1",
                "digest": source_commitment,
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    let mut positives = 0_u64;
    for (id, (spec, expected)) in selected.into_iter().enumerate() {
        positives += u64::from(expected);
        serde_json::to_writer(
            &mut writer,
            &json!({"id": id, "expected": expected, "values": features(spec)}),
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    Ok(positives)
}

fn main() -> Result<()> {
    let args = Args::parse();
    let source = fs::read(&args.census)?;
    let input: Input = serde_json::from_slice(&source)?;
    ensure!(!input.specs.is_empty());
    fs::create_dir_all(&args.output)?;
    let commitment = format!("{:x}", Sha256::digest(&source));
    let mut generated = Vec::new();
    for behavior in 0..=input.specs.iter().map(|spec| spec.behavior).max().unwrap() {
        let positives = input
            .specs
            .iter()
            .filter(|spec| spec.behavior == behavior)
            .count();
        if positives < 2 {
            continue;
        }
        let stem = format!("q87-behavior-{behavior:02}");
        let train = write_corpus(
            &args.output.join(format!("{stem}-train.jsonl")),
            &input.specs,
            behavior,
            0,
            &commitment,
        )?;
        let holdout = write_corpus(
            &args.output.join(format!("{stem}-holdout.jsonl")),
            &input.specs,
            behavior,
            1,
            &commitment,
        )?;
        ensure!(train != 0 && holdout != 0);
        generated.push(behavior);
    }
    serde_json::to_writer(
        std::io::stdout(),
        &json!({
            "specs": input.specs.len(),
            "features": features(input.specs[0]).len(),
            "generated_behavior_corpora": generated,
            "omitted_singleton_behaviors": [0, 2],
            "source_commitment": commitment,
            "provenance": "one-vs-rest deterministic disjoint corpora over generic mask bits, bounded counts, boundary distances, threshold indicators, and pair aggregates; fields and class targets are opaque to Ergodis, singleton classes remain explicit exceptions, and exact table compilation—not the evolved classifier—owns semantic authority",
        }),
    )?;
    println!();
    Ok(())
}
