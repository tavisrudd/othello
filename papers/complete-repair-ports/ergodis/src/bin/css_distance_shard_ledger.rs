use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{css_search_semantics_blake3, verify_css_coordinate_equivalence, Matrix};
use serde::{Deserialize, Serialize};
use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Read, Write};
use std::path::{Path, PathBuf};

const MAX_RECORD_BYTES: u64 = 4 * 1024 * 1024;
const MAX_INPUT_BYTES: u64 = 256 * 1024 * 1024;
const MAX_ADMISSION_BYTES: u64 = 64 * 1024 * 1024;
const LEGACY_SCHEMA: &str = "ergodis-css-distance-native-v6";
const EXPECTED_SCHEMA: &str = "ergodis-css-distance-native-v7";

#[derive(Debug, Parser)]
#[command(about = "Verify complete, compatible CSS distance shard evidence")]
struct Args {
    /// One completed css_distance_native evidence record per shard.
    #[arg(required = true)]
    records: Vec<PathBuf>,
    /// Create a compact verified coverage manifest. Existing files are never overwritten.
    #[arg(long)]
    output: Option<PathBuf>,
    /// Source CSS input for optional exact transport of the verified cover.
    #[arg(long)]
    transport_source: Option<PathBuf>,
    /// Target CSS input for optional exact transport of the verified cover.
    #[arg(long)]
    transport_target: Option<PathBuf>,
    /// Exact css_isomorphism_adapter admission record.
    #[arg(long)]
    transport_admission: Option<PathBuf>,
    /// Create a compact transported-cover record. Existing files are never overwritten.
    #[arg(long)]
    transport_output: Option<PathBuf>,
}

#[derive(Debug, Deserialize)]
struct SparseProblem {
    coordinate_count: u16,
    physical_checks: Vec<Vec<u16>>,
    logical_observations: Vec<Vec<u16>>,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct CoordinateAdmission {
    schema: String,
    backend: String,
    source_blake3: String,
    target_blake3: String,
    coordinate_count: u32,
    physical_rank: u32,
    observable_rank: u32,
    coordinate_images: Vec<u16>,
    verifier: String,
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
    #[serde(default)]
    problem_semantics_blake3: Option<String>,
    executable_blake3: String,
    artifact_payload_blake3: Option<String>,
    search_kernel: String,
    #[serde(default)]
    check_presentation_seed: Option<u64>,
    maximum_weight: u16,
    mode: String,
    result_scope: String,
    search_shard: Option<Shard>,
    shard_frontiers: Option<Vec<ShardFrontierRecord>>,
    search_seconds: Vec<f64>,
    round_stats: Vec<RoundStats>,
    result: ShardResult,
}

#[derive(Clone, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct ShardFrontierRecord {
    anchor: u16,
    frontier_branches: u64,
    partition_blake3: String,
    shard_branches: u64,
    shard_sum_le: String,
    shard_xor_le: String,
}

#[derive(Debug, Serialize)]
struct ManifestShard {
    index: u32,
    evidence_blake3: String,
    round_candidates: Vec<u64>,
    frontier_buckets: Vec<ManifestFrontierBucket>,
}

#[derive(Debug, Serialize)]
struct ManifestFrontierBucket {
    anchor: u16,
    branches: u64,
    sum_le: String,
    xor_le: String,
}

#[derive(Debug, Serialize)]
struct ManifestFrontier {
    anchor: u16,
    branches: u64,
    partition_blake3: String,
}

#[derive(Debug, Serialize)]
struct CoverageManifest {
    schema: &'static str,
    verdict: &'static str,
    input_blake3: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    problem_semantics_blake3: Option<String>,
    executable_blake3: String,
    artifact_payload_blake3: Option<String>,
    search_kernel: String,
    check_presentation_seed: Option<u64>,
    maximum_weight: u16,
    searched_maximum_weight: u16,
    shard_count: u32,
    completed_shards: u32,
    aggregate_distance: Option<u16>,
    aggregate_witness: Vec<u16>,
    total_candidates: u64,
    frontiers: Vec<ManifestFrontier>,
    shards: Vec<ManifestShard>,
}

#[derive(Debug, Serialize)]
struct TransportedCoverage {
    schema: &'static str,
    verdict: &'static str,
    source_input_blake3: String,
    target_input_blake3: String,
    source_semantics_blake3: String,
    target_semantics_blake3: String,
    source_coverage_blake3: String,
    coordinate_equivalence_blake3: String,
    coordinate_count: u32,
    physical_rank: u32,
    observable_rank: u32,
    maximum_weight: u16,
    searched_maximum_weight: u16,
    aggregate_distance: Option<u16>,
    aggregate_witness: Vec<u16>,
    verifier: &'static str,
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

fn read_bounded(path: &Path, limit: u64, kind: &str) -> Result<(Vec<u8>, String)> {
    let file = File::open(path).with_context(|| format!("opening {kind} {}", path.display()))?;
    let mut bytes = Vec::new();
    file.take(limit + 1)
        .read_to_end(&mut bytes)
        .with_context(|| format!("reading {kind} {}", path.display()))?;
    if bytes.len() as u64 > limit {
        bail!("{kind} {} exceeds the byte limit", path.display());
    }
    let digest = blake3::hash(&bytes).to_hex().to_string();
    Ok((bytes, digest))
}

fn dense_matrix(rows: &[Vec<u16>], columns: usize) -> Result<Matrix> {
    let mut data = vec![0_u8; rows.len().saturating_mul(columns)];
    for (row_index, row) in rows.iter().enumerate() {
        for &coordinate in row {
            let coordinate = usize::from(coordinate);
            if coordinate >= columns {
                bail!("coordinate {coordinate} is outside a {columns}-column matrix");
            }
            let entry = &mut data[row_index * columns + coordinate];
            if *entry != 0 {
                bail!("row {row_index} repeats coordinate {coordinate}");
            }
            *entry = 1;
        }
    }
    Matrix::new::<2>(rows.len(), columns, data).context("constructing binary matrix")
}

fn replay_witness(problem: &SparseProblem, witness: &[u16]) -> Result<()> {
    let coordinates = usize::from(problem.coordinate_count);
    let mut support = vec![false; coordinates];
    for &coordinate in witness {
        let coordinate = usize::from(coordinate);
        if coordinate >= coordinates || std::mem::replace(&mut support[coordinate], true) {
            bail!("distance witness has an invalid or duplicate coordinate");
        }
    }
    let parity = |row: &[u16]| -> Result<bool> {
        let mut value = false;
        for &coordinate in row {
            let coordinate = usize::from(coordinate);
            if coordinate >= coordinates {
                bail!("CSS row coordinate is out of range");
            }
            value ^= support[coordinate];
        }
        Ok(value)
    };
    for row in &problem.physical_checks {
        if parity(row)? {
            bail!("distance witness violates a physical check");
        }
    }
    if !problem
        .logical_observations
        .iter()
        .map(|row| parity(row))
        .collect::<Result<Vec<_>>>()?
        .into_iter()
        .any(|value| value)
    {
        bail!("distance witness has zero logical observation");
    }
    Ok(())
}

fn transport_coverage(
    manifest: &CoverageManifest,
    source_bytes: &[u8],
    source_blake3: String,
    target_bytes: &[u8],
    target_blake3: String,
    admission_bytes: &[u8],
    admission_blake3: String,
) -> Result<TransportedCoverage> {
    let source: SparseProblem =
        serde_json::from_slice(source_bytes).context("parsing transport source CSS input")?;
    let target: SparseProblem =
        serde_json::from_slice(target_bytes).context("parsing transport target CSS input")?;
    let admission: CoordinateAdmission = serde_json::from_slice(admission_bytes)
        .context("parsing coordinate-equivalence admission")?;
    if admission.schema != "ergodis-css-isomorphism-admission-v1"
        || admission.source_blake3 != source_blake3
        || admission.target_blake3 != target_blake3
        || manifest.input_blake3 != source_blake3
        || admission.coordinate_count != u32::from(source.coordinate_count)
        || target.coordinate_count != source.coordinate_count
        || admission.coordinate_images.len() != usize::from(source.coordinate_count)
        || admission.backend.is_empty()
        || admission.backend.len() > 256
        || admission.verifier != "exact-physical-and-observable-row-spaces"
    {
        bail!("coordinate-equivalence admission is incompatible with the verified cover");
    }
    let coordinates = usize::from(source.coordinate_count);
    let source_physical = dense_matrix(&source.physical_checks, coordinates)?;
    let source_logical = dense_matrix(&source.logical_observations, coordinates)?;
    let target_physical = dense_matrix(&target.physical_checks, coordinates)?;
    let target_logical = dense_matrix(&target.logical_observations, coordinates)?;
    let source_semantics_blake3 = blake3::Hash::from(css_search_semantics_blake3(
        &source_physical,
        &source_logical,
    )?)
    .to_hex()
    .to_string();
    let target_semantics_blake3 = blake3::Hash::from(css_search_semantics_blake3(
        &target_physical,
        &target_logical,
    )?)
    .to_hex()
    .to_string();
    if manifest
        .problem_semantics_blake3
        .as_ref()
        .is_some_and(|digest| digest != &source_semantics_blake3)
    {
        bail!("source semantic digest does not match the verified cover");
    }
    let certificate = verify_css_coordinate_equivalence(
        &source_physical,
        &source_logical,
        &target_physical,
        &target_logical,
        admission
            .coordinate_images
            .iter()
            .map(|&image| u32::from(image))
            .collect::<Vec<_>>(),
    )
    .context("independently replaying the coordinate equivalence")?;
    if certificate.coordinate_count() != admission.coordinate_count
        || certificate.physical_rank() != admission.physical_rank
        || certificate.observable_rank() != admission.observable_rank
    {
        bail!("coordinate-equivalence admission records inconsistent ranks");
    }

    let mut mapped_witness = Vec::new();
    if let Some(distance) = manifest.aggregate_distance {
        if usize::from(distance) != manifest.aggregate_witness.len() {
            bail!("coverage manifest has an inconsistent aggregate witness");
        }
        replay_witness(&source, &manifest.aggregate_witness)?;
        mapped_witness.reserve(manifest.aggregate_witness.len());
        for &coordinate in &manifest.aggregate_witness {
            mapped_witness.push(admission.coordinate_images[usize::from(coordinate)]);
        }
        mapped_witness.sort_unstable();
        replay_witness(&target, &mapped_witness)?;
    } else if !manifest.aggregate_witness.is_empty() {
        bail!("coverage manifest has a witness without a distance");
    }

    let source_coverage_blake3 = blake3::hash(&serde_json::to_vec(manifest)?)
        .to_hex()
        .to_string();
    Ok(TransportedCoverage {
        schema: "ergodis-css-distance-transport-v1",
        verdict: "transported-complete-compatible-cover",
        source_input_blake3: source_blake3,
        target_input_blake3: target_blake3,
        source_semantics_blake3,
        target_semantics_blake3,
        source_coverage_blake3,
        coordinate_equivalence_blake3: admission_blake3,
        coordinate_count: certificate.coordinate_count(),
        physical_rank: certificate.physical_rank(),
        observable_rank: certificate.observable_rank(),
        maximum_weight: manifest.maximum_weight,
        searched_maximum_weight: manifest.searched_maximum_weight,
        aggregate_distance: manifest.aggregate_distance,
        aggregate_witness: mapped_witness,
        verifier: "exact-cover-plus-coordinate-equivalence-v1",
    })
}

fn valid_digest(digest: &str) -> bool {
    digest.len() == 64
        && digest
            .bytes()
            .all(|byte| byte.is_ascii_digit() || (b'a'..=b'f').contains(&byte))
}

fn decode_hex_32(encoded: &str) -> Result<[u8; 32]> {
    if !valid_digest(encoded) {
        bail!("invalid 256-bit lowercase hexadecimal value");
    }
    let mut bytes = [0_u8; 32];
    for (output, pair) in bytes.iter_mut().zip(encoded.as_bytes().chunks_exact(2)) {
        let digit = |byte: u8| match byte {
            b'0'..=b'9' => byte - b'0',
            b'a'..=b'f' => byte - b'a' + 10,
            _ => unreachable!("valid_digest checked lowercase hexadecimal"),
        };
        *output = digit(pair[0]) << 4 | digit(pair[1]);
    }
    Ok(bytes)
}

fn decode_lanes(encoded: &str) -> Result<[u64; 4]> {
    let bytes = decode_hex_32(encoded)?;
    let mut lanes = [0_u64; 4];
    for (lane, chunk) in lanes.iter_mut().zip(bytes.chunks_exact(8)) {
        *lane = u64::from_le_bytes(chunk.try_into().expect("eight-byte lane"));
    }
    Ok(lanes)
}

fn reconstruct_frontier_digest(
    anchor: u16,
    shard_count: u32,
    buckets: &[ShardFrontierRecord],
) -> Result<([u8; 32], u64)> {
    if buckets.len() != shard_count as usize {
        bail!("frontier bucket count does not match shard count");
    }
    let mut partition = blake3::Hasher::new();
    partition.update(b"ergodis-css-shard-frontier-v1\0");
    partition.update(&anchor.to_le_bytes());
    partition.update(&shard_count.to_le_bytes());
    let mut total = 0_u64;
    for (index, bucket) in buckets.iter().enumerate() {
        if bucket.anchor != anchor {
            bail!("frontier bucket anchor mismatch");
        }
        total = total
            .checked_add(bucket.shard_branches)
            .context("frontier branch count overflow")?;
        partition.update(&(index as u32).to_le_bytes());
        partition.update(&bucket.shard_branches.to_le_bytes());
        for word in decode_lanes(&bucket.shard_sum_le)?
            .into_iter()
            .chain(decode_lanes(&bucket.shard_xor_le)?)
        {
            partition.update(&word.to_le_bytes());
        }
    }
    Ok((*partition.finalize().as_bytes(), total))
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
    let first_frontiers = first_record
        .shard_frontiers
        .as_ref()
        .context("record is missing shard_frontiers")?;
    if first_frontiers.is_empty() {
        bail!("record has no anchor frontier commitments");
    }
    let mut frontier_identities = Vec::with_capacity(first_frontiers.len());
    for frontier in first_frontiers {
        if frontier_identities
            .iter()
            .any(|(anchor, _, _): &(u16, u64, String)| *anchor == frontier.anchor)
        {
            bail!(
                "duplicate anchor {} in frontier commitments",
                frontier.anchor
            );
        }
        decode_hex_32(&frontier.partition_blake3)?;
        decode_lanes(&frontier.shard_sum_le)?;
        decode_lanes(&frontier.shard_xor_le)?;
        frontier_identities.push((
            frontier.anchor,
            frontier.frontier_branches,
            frontier.partition_blake3.clone(),
        ));
    }
    let artifact_payload_blake3 = first_record.artifact_payload_blake3.clone();
    let record_schema = first_record.schema.clone();
    if record_schema != EXPECTED_SCHEMA && record_schema != LEGACY_SCHEMA {
        bail!("unsupported CSS shard evidence schema");
    }
    let problem_semantics_blake3 = first_record.problem_semantics_blake3.clone();
    if record_schema == EXPECTED_SCHEMA
        && problem_semantics_blake3
            .as_deref()
            .is_none_or(|digest| !valid_digest(digest))
    {
        bail!("v7 shard evidence is missing a valid semantic digest");
    }
    let input_blake3 = first_record.input_blake3.clone();
    let executable_blake3 = first_record.executable_blake3.clone();
    let search_kernel = first_record.search_kernel.clone();
    let check_presentation_seed = first_record.check_presentation_seed;
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
    let mut frontier_buckets = (0..frontier_identities.len())
        .map(|_| vec![None; first_shard.count as usize])
        .collect::<Vec<Vec<Option<ShardFrontierRecord>>>>();
    let mut total_candidates = 0_u64;
    let mut aggregate: Option<(u16, Vec<u16>)> = None;
    for loaded in records {
        let record = loaded.record;
        if record.schema != record_schema
            || record.completion_status != "complete"
            || record.mode != "bounded-search-shard"
            || record.result_scope != "partial-shard"
        {
            bail!("record is not a completed v6 bounded-search shard");
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
            || record.problem_semantics_blake3 != problem_semantics_blake3
            || record.executable_blake3 != executable_blake3
            || record.artifact_payload_blake3.as_deref() != artifact_payload_blake3.as_deref()
            || record.search_kernel != search_kernel
            || record.check_presentation_seed != check_presentation_seed
            || record.maximum_weight != maximum_weight
            || record.result.searched_maximum_weight != searched_maximum_weight
        {
            bail!("record belongs to a different search identity");
        }
        let frontiers = record
            .shard_frontiers
            .as_ref()
            .context("record is missing shard_frontiers")?;
        if frontiers.len() != frontier_identities.len() {
            bail!("record has a different anchor frontier count");
        }
        for (position, (frontier, identity)) in
            frontiers.iter().zip(frontier_identities.iter()).enumerate()
        {
            if (
                frontier.anchor,
                frontier.frontier_branches,
                &frontier.partition_blake3,
            ) != (identity.0, identity.1, &identity.2)
            {
                bail!("record belongs to a different anchor frontier partition");
            }
            decode_lanes(&frontier.shard_sum_le)?;
            decode_lanes(&frontier.shard_xor_le)?;
            frontier_buckets[position][shard.index as usize] = Some(frontier.clone());
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
            frontier_buckets: frontiers
                .iter()
                .map(|frontier| ManifestFrontierBucket {
                    anchor: frontier.anchor,
                    branches: frontier.shard_branches,
                    sum_le: frontier.shard_sum_le.clone(),
                    xor_le: frontier.shard_xor_le.clone(),
                })
                .collect(),
        });
    }
    if let Some(missing) = seen.iter().position(|present| !present) {
        bail!("missing shard index {missing}");
    }
    by_index.sort_unstable_by_key(|entry| entry.index);
    let mut manifest_frontiers = Vec::with_capacity(frontier_identities.len());
    for ((anchor, expected_branches, expected_digest), buckets) in
        frontier_identities.into_iter().zip(frontier_buckets)
    {
        let buckets = buckets
            .into_iter()
            .collect::<Option<Vec<_>>>()
            .context("missing frontier bucket")?;
        let (reconstructed_digest, reconstructed_branches) =
            reconstruct_frontier_digest(anchor, first_shard.count, &buckets)?;
        if reconstructed_branches != expected_branches
            || reconstructed_digest != decode_hex_32(&expected_digest)?
        {
            bail!("frontier buckets do not reconstruct their partition commitment");
        }
        manifest_frontiers.push(ManifestFrontier {
            anchor,
            branches: expected_branches,
            partition_blake3: expected_digest,
        });
    }
    let (aggregate_distance, aggregate_witness) = aggregate
        .map(|(distance, witness)| (Some(distance), witness))
        .unwrap_or((None, Vec::new()));
    Ok(CoverageManifest {
        schema: if record_schema == EXPECTED_SCHEMA {
            "ergodis-css-distance-shard-coverage-v4"
        } else {
            "ergodis-css-distance-shard-coverage-v3"
        },
        verdict: "complete-compatible-cover",
        input_blake3,
        problem_semantics_blake3,
        executable_blake3,
        artifact_payload_blake3,
        search_kernel,
        check_presentation_seed,
        maximum_weight,
        searched_maximum_weight,
        shard_count: first_shard.count,
        completed_shards: first_shard.count,
        aggregate_distance,
        aggregate_witness,
        total_candidates,
        frontiers: manifest_frontiers,
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

fn emit_transport(record: &TransportedCoverage, path: &Path) -> Result<()> {
    let file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(path)
        .with_context(|| format!("creating transported coverage {}", path.display()))?;
    let mut writer = BufWriter::new(file);
    serde_json::to_writer(&mut writer, record)?;
    writer.write_all(b"\n")?;
    writer.flush()?;
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
    let transport = match (
        args.transport_source.as_deref(),
        args.transport_target.as_deref(),
        args.transport_admission.as_deref(),
        args.transport_output.as_deref(),
    ) {
        (None, None, None, None) => None,
        (Some(source), Some(target), Some(admission), Some(output)) => {
            let (source_bytes, source_blake3) =
                read_bounded(source, MAX_INPUT_BYTES, "transport source")?;
            let (target_bytes, target_blake3) =
                read_bounded(target, MAX_INPUT_BYTES, "transport target")?;
            let (admission_bytes, admission_blake3) =
                read_bounded(admission, MAX_ADMISSION_BYTES, "transport admission")?;
            Some((
                transport_coverage(
                    &manifest,
                    &source_bytes,
                    source_blake3,
                    &target_bytes,
                    target_blake3,
                    &admission_bytes,
                    admission_blake3,
                )?,
                output,
            ))
        }
        _ => bail!("all four --transport-* options must be supplied together"),
    };
    emit(&manifest, args.output.as_deref())?;
    if let Some((record, output)) = transport {
        emit_transport(&record, output)?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn encode_hex(bytes: [u8; 32]) -> String {
        bytes.iter().map(|byte| format!("{byte:02x}")).collect()
    }

    fn encode_lanes(lanes: [u64; 4]) -> String {
        let mut bytes = [0_u8; 32];
        for (chunk, lane) in bytes.chunks_exact_mut(8).zip(lanes) {
            chunk.copy_from_slice(&lane.to_le_bytes());
        }
        encode_hex(bytes)
    }

    fn frontier(index: u32, count: u32) -> ShardFrontierRecord {
        let mut buckets = (0..count)
            .map(|bucket| ShardFrontierRecord {
                anchor: 7,
                frontier_branches: u64::from(count) * 3,
                partition_blake3: String::new(),
                shard_branches: 3,
                shard_sum_le: encode_lanes([u64::from(bucket) + 1, 2, 3, 4]),
                shard_xor_le: encode_lanes([5, 6, 7, u64::from(bucket) + 8]),
            })
            .collect::<Vec<_>>();
        let (digest, branches) = reconstruct_frontier_digest(7, count, &buckets).unwrap();
        let digest = encode_hex(digest);
        for bucket in &mut buckets {
            bucket.frontier_branches = branches;
            bucket.partition_blake3.clone_from(&digest);
        }
        buckets[index as usize].clone()
    }

    fn loaded(index: u32, count: u32) -> LoadedRecord {
        LoadedRecord {
            evidence_blake3: format!("{:064x}", index + 1),
            record: ShardRecord {
                schema: EXPECTED_SCHEMA.to_owned(),
                completion_status: "complete".to_owned(),
                input_blake3: "1".repeat(64),
                problem_semantics_blake3: Some("4".repeat(64)),
                executable_blake3: "2".repeat(64),
                artifact_payload_blake3: Some("3".repeat(64)),
                search_kernel: "portable-wide".to_owned(),
                check_presentation_seed: None,
                maximum_weight: 8,
                mode: "bounded-search-shard".to_owned(),
                result_scope: "partial-shard".to_owned(),
                search_shard: Some(Shard { index, count }),
                shard_frontiers: Some(vec![frontier(index, count)]),
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
        assert_eq!(manifest.frontiers.len(), 1);
        assert_eq!(manifest.frontiers[0].anchor, 7);
        assert_eq!(manifest.frontiers[0].branches, 9);
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
        let mut mixed_seed = loaded(1, 2);
        mixed_seed.record.check_presentation_seed = Some(7);
        assert!(verify(vec![loaded(0, 2), mixed_seed]).is_err());
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

    #[test]
    fn legacy_cover_remains_readable_and_v7_requires_semantics() {
        let mut legacy_left = loaded(0, 2);
        let mut legacy_right = loaded(1, 2);
        for record in [&mut legacy_left, &mut legacy_right] {
            record.record.schema = LEGACY_SCHEMA.to_owned();
            record.record.problem_semantics_blake3 = None;
        }
        let manifest = verify(vec![legacy_left, legacy_right]).unwrap();
        assert_eq!(manifest.schema, "ergodis-css-distance-shard-coverage-v3");
        assert_eq!(manifest.problem_semantics_blake3, None);

        let mut missing = loaded(0, 1);
        missing.record.problem_semantics_blake3 = None;
        assert!(verify(vec![missing]).is_err());
    }

    #[test]
    fn mutated_or_cross_anchor_frontier_buckets_fail_closed() {
        let mut bad_bucket = loaded(1, 2);
        bad_bucket.record.shard_frontiers.as_mut().unwrap()[0].shard_sum_le = "f".repeat(64);
        assert!(verify(vec![loaded(0, 2), bad_bucket]).is_err());

        let mut bad_partition = loaded(1, 2);
        bad_partition.record.shard_frontiers.as_mut().unwrap()[0].partition_blake3 = "a".repeat(64);
        assert!(verify(vec![loaded(0, 2), bad_partition]).is_err());

        let mut wrong_anchor = loaded(1, 2);
        wrong_anchor.record.shard_frontiers.as_mut().unwrap()[0].anchor = 8;
        assert!(verify(vec![loaded(0, 2), wrong_anchor]).is_err());
    }

    fn transport_fixture() -> (CoverageManifest, Vec<u8>, Vec<u8>, Vec<u8>) {
        let source = serde_json::to_vec(&serde_json::json!({
            "coordinate_count": 6,
            "physical_checks": [[1, 3]],
            "logical_observations": [[0]]
        }))
        .unwrap();
        let target = serde_json::to_vec(&serde_json::json!({
            "coordinate_count": 6,
            "physical_checks": [[0, 4]],
            "logical_observations": [[3]]
        }))
        .unwrap();
        let source_digest = blake3::hash(&source).to_hex().to_string();
        let target_digest = blake3::hash(&target).to_hex().to_string();
        let admission = serde_json::to_vec(&serde_json::json!({
            "schema": "ergodis-css-isomorphism-admission-v1",
            "backend": "fixture",
            "source_blake3": source_digest,
            "target_blake3": target_digest,
            "coordinate_count": 6,
            "physical_rank": 1,
            "observable_rank": 2,
            "coordinate_images": [3, 4, 5, 0, 1, 2],
            "verifier": "exact-physical-and-observable-row-spaces"
        }))
        .unwrap();
        let mut manifest = verify(vec![loaded(0, 2), loaded(1, 2)]).unwrap();
        manifest.input_blake3 = blake3::hash(&source).to_hex().to_string();
        let parsed: SparseProblem = serde_json::from_slice(&source).unwrap();
        manifest.problem_semantics_blake3 = Some(
            blake3::Hash::from(
                css_search_semantics_blake3(
                    &dense_matrix(&parsed.physical_checks, 6).unwrap(),
                    &dense_matrix(&parsed.logical_observations, 6).unwrap(),
                )
                .unwrap(),
            )
            .to_hex()
            .to_string(),
        );
        (manifest, source, target, admission)
    }

    #[test]
    fn exact_transport_maps_complete_cover_and_witness() {
        let (manifest, source, target, admission) = transport_fixture();
        let transported = transport_coverage(
            &manifest,
            &source,
            blake3::hash(&source).to_hex().to_string(),
            &target,
            blake3::hash(&target).to_hex().to_string(),
            &admission,
            blake3::hash(&admission).to_hex().to_string(),
        )
        .unwrap();
        assert_eq!(transported.aggregate_distance, Some(3));
        assert_eq!(transported.aggregate_witness, [1, 3, 5]);
        assert_eq!(transported.physical_rank, 1);
        assert_eq!(transported.observable_rank, 2);
    }

    #[test]
    fn transport_rejects_forged_source_and_observable() {
        let (manifest, source, target, admission) = transport_fixture();
        assert!(transport_coverage(
            &manifest,
            &source,
            "0".repeat(64),
            &target,
            blake3::hash(&target).to_hex().to_string(),
            &admission,
            blake3::hash(&admission).to_hex().to_string(),
        )
        .is_err());

        let incompatible_target = serde_json::to_vec(&serde_json::json!({
            "coordinate_count": 6,
            "physical_checks": [[0, 4]],
            "logical_observations": [[2]]
        }))
        .unwrap();
        let mut forged: serde_json::Value = serde_json::from_slice(&admission).unwrap();
        forged["target_blake3"] =
            serde_json::Value::String(blake3::hash(&incompatible_target).to_hex().to_string());
        let forged = serde_json::to_vec(&forged).unwrap();
        assert!(transport_coverage(
            &manifest,
            &source,
            blake3::hash(&source).to_hex().to_string(),
            &incompatible_target,
            blake3::hash(&incompatible_target).to_hex().to_string(),
            &forged,
            blake3::hash(&forged).to_hex().to_string(),
        )
        .is_err());
    }
}
