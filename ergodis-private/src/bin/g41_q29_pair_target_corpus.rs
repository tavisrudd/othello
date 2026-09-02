use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::PathBuf;

use anyhow::{ensure, Result};
use clap::Parser;
use ergodis_private::g41_q29_pair_target_cache::read_g41_q29_pair_target_cache;
use ergodis_private::raw_feature_evolve::expand_pairwise_differences;
use serde::Serialize;
use serde_json::json;
use sha2::{Digest, Sha256};

const RAW_FIELDS: usize = 7;
const EXPANDED_FIELDS: usize = RAW_FIELDS + RAW_FIELDS * (RAW_FIELDS - 1) / 2;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    cache: PathBuf,
    #[arg(long)]
    output: PathBuf,
    #[arg(long, default_value_t = 8_192)]
    rows_per_class: usize,
}

#[derive(Serialize)]
struct Report {
    rows: u32,
    b1_rows: u32,
    b5_rows: u32,
    shared_targets_excluded: u32,
    opaque_fields: u8,
    field_decoder: Vec<String>,
    source_digest: [u8; 32],
    provenance: &'static str,
}

#[derive(Clone, Copy)]
struct SplitMix64(u64);

impl SplitMix64 {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9e37_79b9_7f4a_7c15);
        let mut value = self.0;
        value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
        value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
        value ^ (value >> 31)
    }
}

fn rank(digest: [u8; 32], coordinates: [u16; 7], class: u8) -> u64 {
    let mut hasher = Sha256::new();
    hasher.update(b"c1016-q29-pair-target-row-rank-v1");
    hasher.update(digest);
    for coordinate in coordinates {
        hasher.update(coordinate.to_le_bytes());
    }
    hasher.update([class]);
    let digest = hasher.finalize();
    u64::from_le_bytes(digest[..8].try_into().unwrap())
}

fn main() -> Result<()> {
    let args = Args::parse();
    ensure!((1..=65_536).contains(&args.rows_per_class));
    let cache = read_g41_q29_pair_target_cache(File::open(args.cache)?)?;
    let mut selected: [Vec<(u64, [u16; 7])>; 2] = std::array::from_fn(|_| Vec::new());
    let mut shared_targets_excluded = 0_u32;
    for target in &cache.targets {
        let class = match target.archetype_bits {
            1 => 0,
            2 => 1,
            3 => {
                shared_targets_excluded += 1;
                continue;
            }
            _ => unreachable!("cache reader validates archetype bits"),
        };
        selected[class].push((
            rank(cache.report.target_digest, target.coordinates, class as u8),
            target.coordinates,
        ));
    }
    for rows in &mut selected {
        ensure!(rows.len() >= args.rows_per_class);
        if rows.len() > args.rows_per_class {
            rows.select_nth_unstable_by_key(args.rows_per_class, |&(rank, coordinates)| {
                (rank, coordinates)
            });
            rows.truncate(args.rows_per_class);
        }
        rows.sort_unstable();
    }
    let mut origins: Vec<String> = (0..RAW_FIELDS)
        .map(|coordinate| format!("raw_{coordinate}"))
        .collect();
    for left in 0..RAW_FIELDS {
        for right in left + 1..RAW_FIELDS {
            origins.push(format!("difference_{left}_{right}"));
        }
    }
    let mut permutation: Vec<usize> = (0..EXPANDED_FIELDS).collect();
    let mut seed = u64::from_le_bytes(cache.report.target_digest[..8].try_into().unwrap());
    let mut rng = SplitMix64(seed);
    for upper in (1..permutation.len()).rev() {
        let lower = (rng.next() % (upper as u64 + 1)) as usize;
        permutation.swap(lower, upper);
    }
    seed = rng.0;
    let fields: Vec<String> = (0..EXPANDED_FIELDS)
        .map(|index| format!("f{index:03}"))
        .collect();
    let field_decoder: Vec<String> = permutation
        .iter()
        .map(|&source| origins[source].clone())
        .collect();
    let generator_digest: [u8; 32] = Sha256::digest(
        [
            b"c1016-q29-pair-target-opaque-corpus-v1".as_slice(),
            &cache.report.target_digest,
            &seed.to_le_bytes(),
        ]
        .concat(),
    )
    .into();
    let generator_hex: String = generator_digest
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect();
    let file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(args.output)?;
    let mut writer = BufWriter::with_capacity(256 * 1024, file);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": "opaque-q29-pair-targets-v1",
            "problem": "opaque-binary-pair-target-class",
            "fields": fields,
            "rows": 2 * args.rows_per_class,
            "generator": {
                "name": "c1016-generic-raw-difference-expander",
                "version": "1",
                "digest": generator_hex,
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    let mut expanded = [0_i64; EXPANDED_FIELDS];
    let mut presented = [0_i64; EXPANDED_FIELDS];
    let mut row_id = 0_u64;
    for (class, rows) in selected.iter().enumerate() {
        for &(_, coordinates) in rows {
            let raw = coordinates.map(i64::from);
            assert_eq!(
                expand_pairwise_differences(&raw, &mut expanded),
                EXPANDED_FIELDS
            );
            for (target, &source) in permutation.iter().enumerate() {
                presented[target] = expanded[source];
            }
            serde_json::to_writer(
                &mut writer,
                &json!({
                    "id": row_id,
                    "expected": class == 1,
                    "values": presented,
                }),
            )?;
            writer.write_all(b"\n")?;
            row_id += 1;
        }
    }
    writer.flush()?;
    println!(
        "{}",
        serde_json::to_string(&Report {
            rows: row_id as u32,
            b1_rows: selected[0].len() as u32,
            b5_rows: selected[1].len() as u32,
            shared_targets_excluded,
            opaque_fields: EXPANDED_FIELDS as u8,
            field_decoder,
            source_digest: cache.report.target_digest,
            provenance: "discovery-only balanced deterministic sample of sealed q29 pair targets; Ergodis sees only source-permuted anonymous raw coordinates and pairwise differences, while archetype meanings are retained solely for post-discovery decoding",
        })?
    );
    Ok(())
}
