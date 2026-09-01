use anyhow::{bail, Context, Result};
use clap::Parser;
use serde::{Deserialize, Serialize};
use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Read, Write};
use std::path::{Path, PathBuf};

const MAX_RECORD_BYTES: u64 = 4 * 1024 * 1024;
const EXPECTED_SCHEMA: &str = "ergodis-css-distance-native-v5";

#[derive(Debug, Parser)]
#[command(about = "Verify complete, compatible CSS distance shard evidence")]
struct Args {
    /// One completed css_distance_native evidence record per shard.
    #[arg(required = true)]
    records: Vec<PathBuf>,
    /// Create a compact verified coverage manifest. Existing files are never overwritten.
    #[arg(long)]
    output: Option<PathBuf>,
}

#[derive(Clone, Copy, Debug, Deserialize)]
struct Shard {
    index: u32,
    count: u32,
}

#[derive(Debug, Deserialize)]
struct RoundStats {
    candidates: u64,
}

#[derive(Debug, Deserialize)]
struct ResultStats {
    candidates: u64,
}

#[derive(Debug, Deserialize)]
struct ShardResult {
    distance: Option<u16>,
    witness: Vec<u16>,
    searched_maximum_weight: u16,
    stats: ResultStats,
}

#[derive(Debug, Deserialize)]
struct ShardRecord {
    schema: String,
    completion_status: String,
    input_blake3: String,
    executable_blake3: String,
    artifact_payload_blake3: Option<String>,
    search_kernel: String,
    maximum_weight: u16,
    mode: String,
    result_scope: String,
    search_shard: Option<Shard>,
    search_seconds: Vec<f64>,
    round_stats: Vec<RoundStats>,
    result: ShardResult,
}

#[derive(Debug, Serialize)]
struct ManifestShard {
    index: u32,
    evidence_blake3: String,
    round_candidates: Vec<u64>,
}

#[derive(Debug, Serialize)]
struct CoverageManifest {
    schema: &'static str,
    verdict: &'static str,
    input_blake3: String,
    executable_blake3: String,
    artifact_payload_blake3: Option<String>,
    search_kernel: String,
    maximum_weight: u16,
    searched_maximum_weight: u16,
    shard_count: u32,
    completed_shards: u32,
    aggregate_distance: Option<u16>,
    aggregate_witness: Vec<u16>,
    total_candidates: u64,
    shards: Vec<ManifestShard>,
}

struct LoadedRecord {
    evidence_blake3: String,
    record: ShardRecord,
}

fn read_record(path: &Path) -> Result<LoadedRecord> {
    let file =
        File::open(path).with_context(|| format!("opening shard record {}", path.display()))?;
    let mut bytes = Vec::new();
    file.take(MAX_RECORD_BYTES + 1)
        .read_to_end(&mut bytes)
        .with_context(|| format!("reading shard record {}", path.display()))?;
    if bytes.len() as u64 > MAX_RECORD_BYTES {
        bail!("shard record {} exceeds the byte limit", path.display());
    }
    let evidence_blake3 = blake3::hash(&bytes).to_hex().to_string();
    let record = serde_json::from_slice(&bytes)
        .with_context(|| format!("parsing shard record {}", path.display()))?;
    Ok(LoadedRecord {
        evidence_blake3,
        record,
    })
}

fn valid_digest(digest: &str) -> bool {
    digest.len() == 64
        && digest
            .bytes()
            .all(|byte| byte.is_ascii_digit() || (b'a'..=b'f').contains(&byte))
}

fn verify(records: Vec<LoadedRecord>) -> Result<CoverageManifest> {
    let Some(first) = records.first() else {
        bail!("at least one shard record is required");
    };
    let first_record = &first.record;
    let first_shard = first_record
        .search_shard
        .context("record is missing search_shard")?;
    if first_shard.count == 0 || first_shard.count > 4096 {
        bail!("invalid shard count {}", first_shard.count);
    }
    let artifact_payload_blake3 = first_record.artifact_payload_blake3.clone();
    let input_blake3 = first_record.input_blake3.clone();
    let executable_blake3 = first_record.executable_blake3.clone();
    let search_kernel = first_record.search_kernel.clone();
    let maximum_weight = first_record.maximum_weight;
    let searched_maximum_weight = first_record.result.searched_maximum_weight;
    if searched_maximum_weight > maximum_weight
        || maximum_weight - searched_maximum_weight > 1
        || (searched_maximum_weight != maximum_weight && maximum_weight & 1 == 0)
    {
        bail!("record has an invalid effective search maximum");
    }
    for (name, digest) in [
        ("input", first_record.input_blake3.as_str()),
        ("executable", first_record.executable_blake3.as_str()),
    ] {
        if !valid_digest(digest) {
            bail!("invalid {name} BLAKE3 digest");
        }
    }
    if artifact_payload_blake3
        .as_deref()
        .is_some_and(|digest| !valid_digest(digest))
    {
        bail!("invalid artifact BLAKE3 digest");
    }

    let mut by_index = Vec::with_capacity(records.len());
    let mut seen = vec![false; first_shard.count as usize];
    let mut total_candidates = 0_u64;
    let mut aggregate: Option<(u16, Vec<u16>)> = None;
    for loaded in records {
        let record = loaded.record;
        if record.schema != EXPECTED_SCHEMA
            || record.completion_status != "complete"
            || record.mode != "bounded-search-shard"
            || record.result_scope != "partial-shard"
        {
            bail!("record is not a completed v5 bounded-search shard");
        }
        let shard = record
            .search_shard
            .context("record is missing search_shard")?;
        if shard.count != first_shard.count || shard.index >= shard.count {
            bail!("record has an incompatible or invalid shard identity");
        }
        if std::mem::replace(&mut seen[shard.index as usize], true) {
            bail!("duplicate shard index {}", shard.index);
        }
        if record.input_blake3 != input_blake3
            || record.executable_blake3 != executable_blake3
            || record.artifact_payload_blake3.as_deref() != artifact_payload_blake3.as_deref()
            || record.search_kernel != search_kernel
            || record.maximum_weight != maximum_weight
            || record.result.searched_maximum_weight != searched_maximum_weight
        {
            bail!("record belongs to a different search identity");
        }
        if record.search_seconds.is_empty()
            || record.search_seconds.len() != record.round_stats.len()
            || record
                .search_seconds
                .iter()
                .any(|seconds| !seconds.is_finite() || *seconds < 0.0)
        {
            bail!("record has incomplete or invalid round evidence");
        }
        if record.result.stats.candidates
            != record
                .round_stats
                .last()
                .expect("nonempty rounds checked above")
                .candidates
        {
            bail!("record result does not replay its final search round");
        }
        match record.result.distance {
            Some(distance)
                if distance <= record.maximum_weight
                    && usize::from(distance) == record.result.witness.len() =>
            {
                let candidate = (distance, record.result.witness);
                if aggregate
                    .as_ref()
                    .is_none_or(|current| (candidate.0, &candidate.1) < (current.0, &current.1))
                {
                    aggregate = Some(candidate);
                }
            }
            None if record.result.witness.is_empty() => {}
            _ => bail!("record has an inconsistent distance witness"),
        }
        let round_candidates = record
            .round_stats
            .into_iter()
            .map(|stats| stats.candidates)
            .collect::<Vec<_>>();
        for &candidates in &round_candidates {
            total_candidates = total_candidates
                .checked_add(candidates)
                .context("aggregate candidate count overflow")?;
        }
        by_index.push(ManifestShard {
            index: shard.index,
            evidence_blake3: loaded.evidence_blake3,
            round_candidates,
        });
    }
    if let Some(missing) = seen.iter().position(|present| !present) {
        bail!("missing shard index {missing}");
    }
    by_index.sort_unstable_by_key(|entry| entry.index);
    let (aggregate_distance, aggregate_witness) = aggregate
        .map(|(distance, witness)| (Some(distance), witness))
        .unwrap_or((None, Vec::new()));
    Ok(CoverageManifest {
        schema: "ergodis-css-distance-shard-coverage-v2",
        verdict: "complete-compatible-cover",
        input_blake3,
        executable_blake3,
        artifact_payload_blake3,
        search_kernel,
        maximum_weight,
        searched_maximum_weight,
        shard_count: first_shard.count,
        completed_shards: first_shard.count,
        aggregate_distance,
        aggregate_witness,
        total_candidates,
        shards: by_index,
    })
}

fn emit(manifest: &CoverageManifest, output: Option<&Path>) -> Result<()> {
    serde_json::to_writer(std::io::stdout().lock(), manifest)?;
    println!();
    if let Some(path) = output {
        let file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(path)
            .with_context(|| format!("creating coverage manifest {}", path.display()))?;
        let mut writer = BufWriter::new(file);
        serde_json::to_writer(&mut writer, manifest)?;
        writer.write_all(b"\n")?;
        writer.flush()?;
    }
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    let records = args
        .records
        .iter()
        .map(|path| read_record(path))
        .collect::<Result<Vec<_>>>()?;
    let manifest = verify(records)?;
    emit(&manifest, args.output.as_deref())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn loaded(index: u32, count: u32) -> LoadedRecord {
        LoadedRecord {
            evidence_blake3: format!("{:064x}", index + 1),
            record: ShardRecord {
                schema: EXPECTED_SCHEMA.to_owned(),
                completion_status: "complete".to_owned(),
                input_blake3: "1".repeat(64),
                executable_blake3: "2".repeat(64),
                artifact_payload_blake3: Some("3".repeat(64)),
                search_kernel: "portable-wide".to_owned(),
                maximum_weight: 8,
                mode: "bounded-search-shard".to_owned(),
                result_scope: "partial-shard".to_owned(),
                search_shard: Some(Shard { index, count }),
                search_seconds: vec![1.0],
                round_stats: vec![RoundStats {
                    candidates: u64::from(index) + 10,
                }],
                result: ShardResult {
                    distance: (index == 1).then_some(3),
                    witness: if index == 1 { vec![0, 2, 4] } else { vec![] },
                    searched_maximum_weight: 8,
                    stats: ResultStats {
                        candidates: u64::from(index) + 10,
                    },
                },
            },
        }
    }

    #[test]
    fn complete_cover_is_sorted_and_aggregated() {
        let manifest = verify(vec![loaded(2, 3), loaded(0, 3), loaded(1, 3)]).unwrap();
        assert_eq!(manifest.completed_shards, 3);
        assert_eq!(manifest.aggregate_distance, Some(3));
        assert_eq!(manifest.aggregate_witness, vec![0, 2, 4]);
        assert_eq!(manifest.total_candidates, 33);
        assert_eq!(
            manifest
                .shards
                .iter()
                .map(|entry| entry.index)
                .collect::<Vec<_>>(),
            vec![0, 1, 2]
        );
    }

    #[test]
    fn missing_duplicate_and_mixed_records_fail_closed() {
        assert!(verify(vec![loaded(0, 2)]).is_err());
        assert!(verify(vec![loaded(0, 2), loaded(0, 2)]).is_err());
        let mut mixed = loaded(1, 2);
        mixed.record.maximum_weight = 10;
        assert!(verify(vec![loaded(0, 2), mixed]).is_err());
    }

    #[test]
    fn incomplete_round_and_inconsistent_witness_fail_closed() {
        let mut incomplete = loaded(1, 2);
        incomplete.record.completion_status = "interrupted".to_owned();
        assert!(verify(vec![loaded(0, 2), incomplete]).is_err());
        let mut bad_witness = loaded(1, 2);
        bad_witness.record.result.witness.pop();
        assert!(verify(vec![loaded(0, 2), bad_witness]).is_err());
    }

    #[test]
    fn odd_requested_maximum_accepts_one_step_parity_normalization() {
        let mut left = loaded(0, 2);
        let mut right = loaded(1, 2);
        left.record.maximum_weight = 9;
        right.record.maximum_weight = 9;
        let manifest = verify(vec![left, right]).unwrap();
        assert_eq!(manifest.maximum_weight, 9);
        assert_eq!(manifest.searched_maximum_weight, 8);
    }

    #[test]
    fn incompatible_or_invalid_effective_maxima_fail_closed() {
        let mut mixed = loaded(1, 2);
        mixed.record.result.searched_maximum_weight = 6;
        assert!(verify(vec![loaded(0, 2), mixed]).is_err());

        let mut skipped_even = loaded(0, 1);
        skipped_even.record.result.searched_maximum_weight = 7;
        assert!(verify(vec![skipped_even]).is_err());

        let mut skipped_two = loaded(0, 1);
        skipped_two.record.maximum_weight = 9;
        skipped_two.record.result.searched_maximum_weight = 7;
        assert!(verify(vec![skipped_two]).is_err());
    }
}
