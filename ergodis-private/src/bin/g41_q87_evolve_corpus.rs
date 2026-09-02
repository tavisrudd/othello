use std::fs::{self, File};
use std::io::{BufWriter, Write};
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use ergodis_private::g41_q87_energy::{compile_g41_q87_energy_support, G41Q87EnergyReport};
use serde_json::json;
use sha2::{Digest, Sha256};

const MASKS: [u8; 4] = [20, 13, 21, 13];
const DIGITS: [u32; 4] = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
const COEFFICIENTS: [[u8; 8]; 4] = [
    [8, 9, 7, 10, 9, 5, 11, 12],
    [5, 8, 12, 10, 10, 8, 9, 7],
    [9, 9, 9, 9, 10, 9, 10, 7],
    [5, 10, 8, 5, 9, 12, 14, 6],
];
const TARGET: usize = 523;
const FEATURE_MASKS: [u8; 15] = [9, 3, 12, 5, 10, 6, 1, 14, 7, 8, 2, 13, 4, 11, 15];

fn energy_values(report: &G41Q87EnergyReport) -> Vec<usize> {
    (0..=TARGET)
        .filter(|&energy| report.energy_support[energy / 64] & (1_u64 << (energy % 64)) != 0)
        .collect()
}

fn split(energies: [usize; 4]) -> usize {
    let mut hash = 0xcbf2_9ce4_8422_2325_u64;
    for energy in energies {
        hash ^= energy as u64;
        hash = hash.wrapping_mul(0x100_0000_01b3);
    }
    ((hash >> 17) & 1) as usize
}

fn features(energies: [usize; 4]) -> [i64; FEATURE_MASKS.len()] {
    std::array::from_fn(|feature| {
        (0..4)
            .filter(|&block| FEATURE_MASKS[feature] & (1 << block) != 0)
            .map(|block| energies[block] as i64)
            .sum()
    })
}

fn write_corpus(
    path: &Path,
    split_name: &str,
    expected_split: usize,
    rows: u64,
    energies: &[Vec<usize>; 4],
    commitment: &str,
) -> Result<()> {
    let mut writer = BufWriter::new(File::create(path)?);
    let fields: Vec<String> = (0..FEATURE_MASKS.len())
        .map(|field| format!("f{field:03}"))
        .collect();
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": format!("opaque-subset-sums-{split_name}-v1"),
            "problem": "opaque-subset-sum-invariant",
            "fields": fields,
            "rows": rows,
            "generator": {
                "name": "c1016-generic-bounded-subset-sum-expander",
                "version": "1",
                "digest": commitment,
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    let mut id = 0_u64;
    for &first in &energies[0] {
        for &second in &energies[1] {
            for &third in &energies[2] {
                for &fourth in &energies[3] {
                    let values = [first, second, third, fourth];
                    if split(values) != expected_split {
                        continue;
                    }
                    serde_json::to_writer(
                        &mut writer,
                        &json!({
                            "id": id,
                            "expected": values.into_iter().sum::<usize>() == TARGET,
                            "values": features(values),
                        }),
                    )?;
                    writer.write_all(b"\n")?;
                    id += 1;
                }
            }
        }
    }
    if id != rows {
        anyhow::bail!("q87 corpus row count changed during replay");
    }
    writer.flush()?;
    Ok(())
}

fn main() -> Result<()> {
    let output = PathBuf::from(
        std::env::args_os()
            .nth(1)
            .context("expected output directory")?,
    );
    fs::create_dir_all(&output)?;
    let blocks: [G41Q87EnergyReport; 4] = (0..4)
        .map(|block| {
            compile_g41_q87_energy_support(MASKS[block], DIGITS[block], COEFFICIENTS[block])
        })
        .collect::<Result<Vec<_>, _>>()?
        .try_into()
        .map_err(|_| anyhow::anyhow!("q87 block count changed"))?;
    let encoded = serde_json::to_vec(&blocks)?;
    let commitment = format!("{:x}", Sha256::digest(encoded));
    let energies: [Vec<usize>; 4] = std::array::from_fn(|block| energy_values(&blocks[block]));
    let mut rows = [0_u64; 2];
    let mut positives = [0_u64; 2];
    for &first in &energies[0] {
        for &second in &energies[1] {
            for &third in &energies[2] {
                for &fourth in &energies[3] {
                    let values = [first, second, third, fourth];
                    let partition = split(values);
                    rows[partition] += 1;
                    positives[partition] += u64::from(values.into_iter().sum::<usize>() == TARGET);
                }
            }
        }
    }
    if positives.into_iter().any(|count| count == 0) {
        anyhow::bail!("deterministic q87 split lost all positives");
    }
    write_corpus(
        &output.join("q87-energy-train.jsonl"),
        "train",
        0,
        rows[0],
        &energies,
        &commitment,
    )?;
    write_corpus(
        &output.join("q87-energy-holdout.jsonl"),
        "holdout",
        1,
        rows[1],
        &energies,
        &commitment,
    )?;
    serde_json::to_writer(
        std::io::stdout(),
        &json!({
            "rows": rows,
            "positives": positives,
            "features": FEATURE_MASKS.len(),
            "source_commitment": commitment,
            "provenance": "complete q87 marginal-energy quartet domain; deterministic disjoint train/holdout split; opaque generic nonempty subset-sum features; labels come only from the exact structural total-energy target 523",
        }),
    )?;
    println!();
    Ok(())
}
