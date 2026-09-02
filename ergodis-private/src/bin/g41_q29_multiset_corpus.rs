use std::collections::BTreeMap;
use std::fs::{self, File};
use std::io::{BufWriter, Write};
use std::path::PathBuf;

use anyhow::{Context, Result};
use ergodis_private::symmetric_feature_evolve::expand_symmetric_scalar_features;
use serde::Deserialize;
use serde_json::json;
use sha2::{Digest, Sha256};

#[derive(Deserialize)]
struct CensusEntry {
    signature: [u8; 4],
    profile_digest: [u8; 32],
}

#[derive(Deserialize)]
struct Census {
    signatures: Vec<CensusEntry>,
}

#[derive(Deserialize)]
struct Pair {
    signatures: [[u8; 4]; 2],
}

#[derive(Deserialize)]
struct Edge {
    ac_pair: u16,
    bd_pair: u16,
}

#[derive(Deserialize)]
struct Graph {
    ac_pairs: Vec<Pair>,
    bd_pairs: Vec<Pair>,
    edges: Vec<Edge>,
}

fn next_random(seed: &mut u64) -> u64 {
    *seed ^= *seed >> 12;
    *seed ^= *seed << 25;
    *seed ^= *seed >> 27;
    seed.wrapping_mul(0x2545_f491_4f6c_dd1d)
}

fn main() -> Result<()> {
    let graph_path = PathBuf::from(
        std::env::args_os()
            .nth(1)
            .context("expected aggregate-pair graph path")?,
    );
    let census_path = PathBuf::from(
        std::env::args_os()
            .nth(2)
            .context("expected signature-census path")?,
    );
    let output_path = PathBuf::from(
        std::env::args_os()
            .nth(3)
            .context("expected corpus output path")?,
    );
    let graph_bytes = fs::read(graph_path)?;
    let census_bytes = fs::read(census_path)?;
    let graph: Graph = serde_json::from_slice(&graph_bytes)?;
    let census: Census = serde_json::from_slice(&census_bytes)?;
    let mut source_hasher = Sha256::new();
    source_hasher.update(&graph_bytes);
    source_hasher.update(&census_bytes);
    let source_commitment: [u8; 32] = source_hasher.finalize().into();

    let mut digests: Vec<[u8; 32]> = census
        .signatures
        .iter()
        .map(|entry| entry.profile_digest)
        .collect();
    digests.sort_unstable();
    digests.dedup();
    anyhow::ensure!(digests.len() == 4, "profile-class count changed");
    let signature_classes: BTreeMap<[u8; 4], u8> = census
        .signatures
        .iter()
        .map(|entry| {
            let class = digests.binary_search(&entry.profile_digest).unwrap() as u8;
            (entry.signature, class)
        })
        .collect();
    anyhow::ensure!(signature_classes.len() == census.signatures.len());

    let mut rows = Vec::<[u8; 4]>::with_capacity(graph.edges.len());
    for edge in &graph.edges {
        let first = &graph.ac_pairs[usize::from(edge.ac_pair)].signatures;
        let second = &graph.bd_pairs[usize::from(edge.bd_pair)].signatures;
        let mut classes = [
            *signature_classes
                .get(&first[0])
                .context("graph signature missing from census")?,
            *signature_classes
                .get(&first[1])
                .context("graph signature missing from census")?,
            *signature_classes
                .get(&second[0])
                .context("graph signature missing from census")?,
            *signature_classes
                .get(&second[1])
                .context("graph signature missing from census")?,
        ];
        classes.sort_unstable();
        rows.push(classes);
    }
    let mut multisets = rows.clone();
    multisets.sort_unstable();
    multisets.dedup();
    anyhow::ensure!(multisets.len() == 2, "canonical multiset count changed");

    let mut feature_permutation = [0_usize, 1, 2, 3, 4, 5, 6, 7];
    let mut feature_seed = u64::from_le_bytes(source_commitment[8..16].try_into().unwrap());
    for upper in (1..feature_permutation.len()).rev() {
        let lower = (next_random(&mut feature_seed) % (upper as u64 + 1)) as usize;
        feature_permutation.swap(lower, upper);
    }

    let mut writer = BufWriter::with_capacity(256 * 1024, File::create(output_path)?);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": "opaque-four-scalar-symmetric-expansion-v2",
            "problem": "opaque-pair-partition-invariant-classification",
            "fields": ["f000", "f001", "f002", "f003", "f004", "f005", "f006", "f007"],
            "rows": rows.len() * 4,
            "generator": {
                "name": "c1016-q29-profile-multiset-expander",
                "version": "2",
                "digest": source_commitment.iter().map(|byte| format!("{byte:02x}")).collect::<String>(),
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    for (edge, &canonical) in rows.iter().enumerate() {
        for replica in 0..4 {
            let mut raw = canonical.map(i64::from);
            let mut seed = u64::from_le_bytes(source_commitment[..8].try_into().unwrap())
                ^ (edge as u64).wrapping_mul(0x9e37_79b9_7f4a_7c15)
                ^ replica as u64;
            for upper in (1..raw.len()).rev() {
                let lower = (next_random(&mut seed) % (upper as u64 + 1)) as usize;
                raw.swap(lower, upper);
            }
            let mut expanded = [0_i64; 8];
            anyhow::ensure!(
                expand_symmetric_scalar_features(&raw, &mut expanded) == Some(expanded.len()),
                "symmetric feature expansion failed"
            );
            let mut values = [0_i64; 8];
            for (source, &opaque) in feature_permutation.iter().enumerate() {
                values[opaque] = expanded[source];
            }
            serde_json::to_writer(
                &mut writer,
                &json!({
                    "id": 4 * edge + replica,
                    "expected": canonical == multisets[0],
                    "values": values,
                }),
            )?;
            writer.write_all(b"\n")?;
        }
    }
    writer.flush()?;
    println!(
        "{}",
        serde_json::to_string(&json!({
            "source_commitment": source_commitment,
            "digest_classes": digests.len(),
            "canonical_multisets": multisets,
            "source_edges": rows.len(),
            "rows": rows.len() * 4,
            "opaque_fields": 8,
            "provenance": "opaque source-bound presentation derived from exact profile digests and graph edges; the generic expander sees only four independently permuted scalars and emits elementary symmetric statistics before one source-bound opaque field permutation; labels use only sorted multiset identity, and no A/B/C name, pair partition, field scope, or expected rule is exposed",
        }))?
    );
    Ok(())
}
