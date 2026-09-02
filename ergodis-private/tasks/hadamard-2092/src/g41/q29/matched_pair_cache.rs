use std::fs::File;
use std::io::{BufWriter, Write};
use std::path::PathBuf;
use std::sync::atomic::{AtomicUsize, Ordering};

use anyhow::{ensure, Context, Result};
use clap::Args as ClapArgs;
use ergodis_private::g41_q29_exact_tablebase::{
    compile_g41_q29_aggregate_block_tablebase, G41Q29ExactProfile,
};
use ergodis_private::g41_q29_pair_target_cache::{
    read_g41_q29_pair_target_cache, verify_g41_q29_pair_target_source,
    G41Q29PairTargetSourceBinding,
};
use ergodis_private::g41_q29_profile_shard::{
    collect_g41_q29_profile_shard_matches_from_targets, compile_g41_q29_projection_index,
    G41Q29MatchedPair, G41Q29PairTargetIndex,
};
use serde::Serialize;
use sha2::{Digest, Sha256};

const RADIX: usize = 524;
const SHARDS: usize = RADIX * RADIX;
const MAGIC: [u8; 8] = *b"G41MPR01";
const SEMANTICS: &[u8] = b"ergodis-private/g41-q29-matched-profile-pairs/v1; carrier=522; quotient=29; exact seven-coordinate profile sums; target indices bound to G41PTG01 canonical target order; sides 0=A+C and 1=B+B; B archetype bits 1=B1 and 2=B5; every record independently replays against committed source profiles";

#[derive(ClapArgs)]
pub struct Arguments {
    #[arg(long)]
    target_cache: PathBuf,
    #[arg(long)]
    output: PathBuf,
    #[arg(long, default_value_t = 18)]
    threads: usize,
    #[arg(long, default_value_t = 524_288)]
    capacity_per_thread: usize,
}

struct Worker {
    matching: [u64; 3],
    pairs: Vec<G41Q29MatchedPair>,
}

#[derive(Serialize)]
struct Report {
    threads: u8,
    projection_coordinates: [u8; 2],
    target_cache_digest: [u8; 32],
    source: G41Q29PairTargetSourceBinding,
    matching_pair_records: [u64; 3],
    retained_pair_records: u64,
    exact_profile_quartets: [u64; 2],
    record_digest: [u8; 32],
    output_bytes: u64,
    maximum_worker_records: u32,
    authority: &'static str,
    provenance: &'static str,
}

fn source_binding(
    tables: &[ergodis_private::g41_q29_exact_tablebase::G41Q29AggregateBlockTablebase; 4],
) -> G41Q29PairTargetSourceBinding {
    G41Q29PairTargetSourceBinding {
        signatures: tables.each_ref().map(|table| table.report.signature),
        profile_counts: tables.each_ref().map(|table| table.profiles.len() as u32),
        profile_digests: tables.each_ref().map(|table| table.report.profile_digest),
    }
}

fn pair_sum(first: G41Q29ExactProfile, second: G41Q29ExactProfile) -> Option<[u16; 7]> {
    let mut output = [0_u16; 7];
    for (coordinate, value) in output.iter_mut().enumerate() {
        *value = first.coordinate(coordinate) + second.coordinate(coordinate);
        if *value > 523 {
            return None;
        }
    }
    Some(output)
}

fn replay_record(
    record: G41Q29MatchedPair,
    targets: &[ergodis_private::g41_q29_profile_shard::G41Q29PairTarget],
    tables: &[ergodis_private::g41_q29_exact_tablebase::G41Q29AggregateBlockTablebase; 4],
) -> bool {
    let (first, second) = if record.side == 0 {
        (&tables[0].profiles, &tables[3].profiles)
    } else if record.archetype_bits == 1 {
        (&tables[1].profiles, &tables[1].profiles)
    } else if record.archetype_bits == 2 {
        (&tables[2].profiles, &tables[2].profiles)
    } else {
        return false;
    };
    let Some(&first) = first.get(record.first as usize) else {
        return false;
    };
    let Some(&second) = second.get(record.second as usize) else {
        return false;
    };
    let Some(sum) = pair_sum(first, second) else {
        return false;
    };
    let Some(target) = targets.get(record.target as usize) else {
        return false;
    };
    let expected = if record.side == 0 {
        target.coordinates
    } else {
        target.coordinates.map(|value| 523 - value)
    };
    sum == expected
        && record._pad == 0
        && record.archetype_bits & target.archetype_bits == record.archetype_bits
}

fn quartet_counts(pairs: &[G41Q29MatchedPair]) -> Result<[u64; 2]> {
    let mut counts = [0_u64; 2];
    let mut cursor = 0_usize;
    while cursor < pairs.len() {
        let target = pairs[cursor].target;
        let end = pairs[cursor..].partition_point(|pair| pair.target == target) + cursor;
        let split = pairs[cursor..end].partition_point(|pair| pair.side == 0) + cursor;
        // the index is the B archetype number: it selects the archetype bit and its counter slot
        #[allow(clippy::needless_range_loop)]
        for archetype in 0..2 {
            let bit = 1_u8 << archetype;
            let left = pairs[cursor..split]
                .iter()
                .filter(|pair| pair.archetype_bits & bit != 0)
                .count() as u64;
            let right = pairs[split..end]
                .iter()
                .filter(|pair| pair.archetype_bits == bit)
                .count() as u64;
            counts[archetype] = counts[archetype]
                .checked_add(
                    left.checked_mul(right)
                        .context("quartet product overflow")?,
                )
                .context("quartet count overflow")?;
        }
        cursor = end;
    }
    Ok(counts)
}

fn update_record(hasher: &mut Sha256, record: G41Q29MatchedPair) {
    hasher.update(record.target.to_le_bytes());
    hasher.update(record.first.to_le_bytes());
    hasher.update(record.second.to_le_bytes());
    hasher.update([record.archetype_bits, record.side]);
    hasher.update(record._pad.to_le_bytes());
}

fn record_key(record: &G41Q29MatchedPair) -> (u32, u8, u8, u32, u32) {
    (
        record.target,
        record.side,
        record.archetype_bits,
        record.first,
        record.second,
    )
}

pub fn run(args: Arguments) -> Result<()> {
    ensure!((1..=32).contains(&args.threads));
    ensure!(args.capacity_per_thread > 0);
    let tables = [
        compile_g41_q29_aggregate_block_tablebase([8, 3, 15, 15])?,
        compile_g41_q29_aggregate_block_tablebase([1, 9, 14, 14])?,
        compile_g41_q29_aggregate_block_tablebase([5, 8, 14, 14])?,
        compile_g41_q29_aggregate_block_tablebase([9, 7, 14, 14])?,
    ];
    let source = source_binding(&tables);
    let cache = read_g41_q29_pair_target_cache(File::open(&args.target_cache)?)?;
    verify_g41_q29_pair_target_source(&cache, source)?;
    let target_index = G41Q29PairTargetIndex::compile(&cache.targets)?;
    let indices = [
        compile_g41_q29_projection_index::<0, 2>(&tables[0].profiles)?,
        compile_g41_q29_projection_index::<0, 2>(&tables[1].profiles)?,
        compile_g41_q29_projection_index::<0, 2>(&tables[2].profiles)?,
        compile_g41_q29_projection_index::<0, 2>(&tables[3].profiles)?,
    ];
    let next = AtomicUsize::new(0);
    let workers = std::thread::scope(|scope| -> Result<Vec<Worker>> {
        let mut handles = Vec::with_capacity(args.threads);
        for _ in 0..args.threads {
            handles.push(scope.spawn(|| -> Result<Worker> {
                let mut worker = Worker {
                    matching: [0; 3],
                    pairs: Vec::with_capacity(args.capacity_per_thread),
                };
                loop {
                    let shard = next.fetch_add(1, Ordering::Relaxed);
                    if shard >= SHARDS {
                        break;
                    }
                    let counts = collect_g41_q29_profile_shard_matches_from_targets::<0, 2>(
                        [&tables[0].profiles, &tables[3].profiles],
                        [&tables[1].profiles, &tables[2].profiles],
                        [&indices[0], &indices[3]],
                        [&indices[1], &indices[2]],
                        [(shard / RADIX) as u16, (shard % RADIX) as u16],
                        &target_index,
                        &mut worker.pairs,
                        args.capacity_per_thread,
                    )?;
                    // the index is the pair-side channel shared by the worker tally and the shard counts
                    #[allow(clippy::needless_range_loop)]
                    for side in 0..3 {
                        worker.matching[side] = worker.matching[side]
                            .checked_add(counts[side])
                            .context("worker match count overflow")?;
                    }
                }
                Ok(worker)
            }));
        }
        handles
            .into_iter()
            .map(|handle| {
                handle
                    .join()
                    .map_err(|_| anyhow::anyhow!("matched-pair worker panicked"))?
            })
            .collect()
    })?;
    let maximum_worker_records = workers
        .iter()
        .map(|worker| worker.pairs.len())
        .max()
        .unwrap_or(0) as u32;
    let mut matching = [0_u64; 3];
    let total_pairs = workers.iter().map(|worker| worker.pairs.len()).sum();
    let mut pairs = Vec::with_capacity(total_pairs);
    for worker in workers {
        // the index is the pair-side channel shared by the merged tally and each worker tally
        #[allow(clippy::needless_range_loop)]
        for side in 0..3 {
            matching[side] = matching[side]
                .checked_add(worker.matching[side])
                .context("merged match count overflow")?;
        }
        pairs.extend_from_slice(&worker.pairs);
    }
    ensure!(matching.iter().sum::<u64>() as usize == pairs.len());
    pairs.sort_unstable_by_key(record_key);
    ensure!(pairs
        .windows(2)
        .all(|pair| record_key(&pair[0]) < record_key(&pair[1])));
    ensure!(
        pairs
            .iter()
            .copied()
            .all(|record| replay_record(record, &cache.targets, &tables)),
        "matched-pair independent replay failed"
    );
    let exact_profile_quartets = quartet_counts(&pairs)?;
    ensure!(exact_profile_quartets == [149_884, 2_205_896]);
    let mut hasher = Sha256::new();
    for &record in &pairs {
        update_record(&mut hasher, record);
    }
    let record_digest: [u8; 32] = hasher.finalize().into();
    let mut writer = BufWriter::new(File::create(&args.output)?);
    writer.write_all(&MAGIC)?;
    writer.write_all(&(SEMANTICS.len() as u32).to_le_bytes())?;
    writer.write_all(SEMANTICS)?;
    writer.write_all(&cache.report.target_digest)?;
    writer.write_all(&(pairs.len() as u64).to_le_bytes())?;
    writer.write_all(&record_digest)?;
    for record in pairs.iter().copied() {
        writer.write_all(&record.target.to_le_bytes())?;
        writer.write_all(&record.first.to_le_bytes())?;
        writer.write_all(&record.second.to_le_bytes())?;
        writer.write_all(&[record.archetype_bits, record.side])?;
        writer.write_all(&record._pad.to_le_bytes())?;
    }
    writer.flush()?;
    let output_bytes = std::fs::metadata(&args.output)?.len();
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            threads: args.threads as u8,
            projection_coordinates: [0, 2],
            target_cache_digest: cache.report.target_digest,
            source,
            matching_pair_records: matching,
            retained_pair_records: pairs.len() as u64,
            exact_profile_quartets,
            record_digest,
            output_bytes,
            maximum_worker_records,
            authority: "sealed discovery cache candidate; negative authority remains disabled until the typed reader rebinds semantics, target order, source profile commitments, payload digest, and direct record replay",
            provenance: "complete 18-worker exact-key scan over all 274,576 projection shards; hot pair loops append into presized worker-owned vectors with no allocation; all retained records independently replay all seven profile coordinates and their merged multiplicity equals the independent full q29 campaign",
        },
    )?;
    println!();
    Ok(())
}
