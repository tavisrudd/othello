use std::fs::{self, File};
use std::io::{BufWriter, Write};
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use ergodis_private::g41_q87_exact_energy::census_g41_q87_reachable_energy_vectors;
use serde_json::json;
use sha2::{Digest, Sha256};

const BLOCK: usize = 2;
const MASK: u8 = 21;
const DIGITS: u32 = 1_957_340;
const COEFFICIENTS: [u8; 8] = [9, 9, 9, 9, 10, 9, 10, 7];
const COORDINATES: usize = 8;
const SUBSETS: usize = (1 << COORDINATES) - 1;

fn values(mask: u64) -> Vec<u8> {
    let mut output = Vec::with_capacity(mask.count_ones() as usize);
    let mut remaining = mask;
    while remaining != 0 {
        output.push(remaining.trailing_zeros() as u8);
        remaining &= remaining - 1;
    }
    output
}

fn split(vector: [u8; COORDINATES]) -> usize {
    let mut hash = 0xcbf2_9ce4_8422_2325_u64;
    for value in vector {
        hash ^= u64::from(value);
        hash = hash.wrapping_mul(0x100_0000_01b3);
    }
    ((hash >> 19) & 1) as usize
}

fn features(vector: [u8; COORDINATES], choices: &[Vec<u8>; COORDINATES]) -> Vec<i64> {
    let ranks: [u8; COORDINATES] = std::array::from_fn(|coordinate| {
        choices[coordinate]
            .binary_search(&vector[coordinate])
            .expect("marginal value was used to construct the vector") as u8
    });
    let mut output = Vec::with_capacity(2 * SUBSETS);
    for family in [vector, ranks] {
        for feature in 0..SUBSETS {
            // Multiplication by 73 permutes 0..255, hiding the subset order
            // while retaining the complete theorem-agnostic grammar.
            let mask = ((feature * 73) % SUBSETS + 1) as u16;
            let sum = (0..COORDINATES)
                .filter(|&coordinate| mask & (1 << coordinate) != 0)
                .map(|coordinate| i64::from(family[coordinate]))
                .sum();
            output.push(sum);
        }
    }
    output
}

fn write_corpus(
    path: &Path,
    split_name: &str,
    expected_split: usize,
    choices: &[Vec<u8>; COORDINATES],
    reachable: &[[u8; COORDINATES]],
    commitment: &str,
) -> Result<(u64, u64)> {
    let fields: Vec<String> = (0..2 * SUBSETS)
        .map(|field| format!("f{field:03}"))
        .collect();
    let mut rows = Vec::new();
    let mut cursor = [0_usize; COORDINATES];
    loop {
        let vector = std::array::from_fn(|coordinate| choices[coordinate][cursor[coordinate]]);
        if split(vector) == expected_split {
            rows.push((vector, reachable.binary_search(&vector).is_ok()));
        }
        let mut coordinate = 0;
        while coordinate < COORDINATES {
            cursor[coordinate] += 1;
            if cursor[coordinate] < choices[coordinate].len() {
                break;
            }
            cursor[coordinate] = 0;
            coordinate += 1;
        }
        if coordinate == COORDINATES {
            break;
        }
    }
    let positives = rows.iter().filter(|(_, expected)| *expected).count() as u64;
    let negatives = rows.len() as u64 - positives;
    if positives == 0 || negatives == 0 {
        anyhow::bail!("q87 reachability split lost one label");
    }
    let mut writer = BufWriter::new(File::create(path)?);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": format!("opaque-q87-reachability-{split_name}-v1"),
            "problem": "opaque-reachable-feature-vector",
            "fields": fields,
            "rows": rows.len(),
            "generator": {
                "name": "c1016-generic-complete-subset-observation-expander",
                "version": "1",
                "digest": commitment,
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    for (id, (vector, expected)) in rows.into_iter().enumerate() {
        serde_json::to_writer(
            &mut writer,
            &json!({
                "id": id,
                "expected": expected,
                "values": features(vector, choices),
            }),
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    Ok((positives, negatives))
}

fn main() -> Result<()> {
    let output = PathBuf::from(
        std::env::args_os()
            .nth(1)
            .context("expected output directory")?,
    );
    fs::create_dir_all(&output)?;
    let reachability = census_g41_q87_reachable_energy_vectors(MASK, DIGITS, COEFFICIENTS)?;
    let choices = reachability.coordinate_energy_masks.map(values);
    let encoded = serde_json::to_vec(&reachability)?;
    let commitment = format!("{:x}", Sha256::digest(encoded));
    let train = write_corpus(
        &output.join("q87-reachability-train.jsonl"),
        "train",
        0,
        &choices,
        &reachability.vectors,
        &commitment,
    )?;
    let holdout = write_corpus(
        &output.join("q87-reachability-holdout.jsonl"),
        "holdout",
        1,
        &choices,
        &reachability.vectors,
        &commitment,
    )?;
    serde_json::to_writer(
        std::io::stdout(),
        &json!({
            "block": BLOCK,
            "marginal_vectors": choices.iter().map(Vec::len).product::<usize>(),
            "reachable_vectors": reachability.vectors.len(),
            "train": {"positives": train.0, "negatives": train.1},
            "holdout": {"positives": holdout.0, "negatives": holdout.1},
            "features": 2 * SUBSETS,
            "source_commitment": commitment,
            "provenance": "complete q87 block-two marginal local-energy-vector domain labelled by exact source-state reachability; deterministic disjoint train/holdout split; all anonymously permuted nonempty subset sums of raw energies and within-coordinate ranks; no target exclusion is encoded in the feature generator",
        }),
    )?;
    println!();
    Ok(())
}
