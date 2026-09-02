use std::fs::File;
use std::path::PathBuf;
use std::sync::atomic::{AtomicUsize, Ordering};

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_q29_exact_tablebase::compile_g41_q29_aggregate_block_tablebase;
use ergodis_private::g41_q29_pair_target_cache::{
    read_g41_q29_pair_target_cache, verify_g41_q29_pair_target_source,
    G41Q29PairTargetSourceBinding,
};
use ergodis_private::g41_q29_profile_shard::{
    compile_g41_q29_projection_index, mark_g41_q29_profile_shard_participation_from_targets,
    G41Q29PairTargetIndex,
};
use serde::Serialize;
use sha2::{Digest, Sha256};

const RADIX: usize = 524;
const SHARDS: usize = RADIX * RADIX;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    target_cache: PathBuf,
    #[arg(long, default_value_t = 4)]
    threads: usize,
    #[arg(long)]
    emit_indices: bool,
}

struct Worker {
    examined: [u64; 3],
    matching: [u64; 3],
    bits: [Vec<u64>; 4],
}

#[derive(Serialize)]
struct Report {
    threads: u8,
    projection_coordinates: [u8; 2],
    target_cache: ergodis_private::g41_q29_pair_target_cache::G41Q29PairTargetCacheReport,
    target_index_bytes: u64,
    pair_records_examined: [u64; 3],
    matching_pair_records: [u64; 3],
    source_profiles: [u32; 4],
    participating_profiles: [u32; 4],
    participating_profile_indices: Option<[Vec<u32>; 4]>,
    participation_digests: [[u8; 32]; 4],
    authority: &'static str,
    provenance: &'static str,
}

fn bit_words(length: usize) -> Vec<u64> {
    vec![0_u64; length.div_ceil(64)]
}

fn checked_sum(target: &mut u64, value: u64) -> Result<()> {
    *target = target
        .checked_add(value)
        .context("participation counter overflow")?;
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    ensure!((1..=16).contains(&args.threads));
    let a = compile_g41_q29_aggregate_block_tablebase([8, 3, 15, 15])?;
    let b1 = compile_g41_q29_aggregate_block_tablebase([1, 9, 14, 14])?;
    let b5 = compile_g41_q29_aggregate_block_tablebase([5, 8, 14, 14])?;
    let c = compile_g41_q29_aggregate_block_tablebase([9, 7, 14, 14])?;
    let sets = [
        &a.profiles[..],
        &b1.profiles[..],
        &b5.profiles[..],
        &c.profiles[..],
    ];
    let source = G41Q29PairTargetSourceBinding {
        signatures: [
            a.report.signature,
            b1.report.signature,
            b5.report.signature,
            c.report.signature,
        ],
        profile_counts: sets.map(|profiles| profiles.len() as u32),
        profile_digests: [
            a.report.profile_digest,
            b1.report.profile_digest,
            b5.report.profile_digest,
            c.report.profile_digest,
        ],
    };
    let cache = read_g41_q29_pair_target_cache(File::open(args.target_cache)?)?;
    verify_g41_q29_pair_target_source(&cache, source)?;
    let target_index = G41Q29PairTargetIndex::compile(&cache.targets)?;
    let ia = compile_g41_q29_projection_index::<0, 2>(sets[0])?;
    let ib1 = compile_g41_q29_projection_index::<0, 2>(sets[1])?;
    let ib5 = compile_g41_q29_projection_index::<0, 2>(sets[2])?;
    let ic = compile_g41_q29_projection_index::<0, 2>(sets[3])?;
    let next = AtomicUsize::new(0);
    let workers = std::thread::scope(|scope| -> Result<Vec<Worker>> {
        let mut handles = Vec::with_capacity(args.threads);
        for _ in 0..args.threads {
            handles.push(scope.spawn(|| -> Result<Worker> {
                let mut bits = std::array::from_fn(|block| bit_words(sets[block].len()));
                let mut examined = [0_u64; 3];
                let mut matching = [0_u64; 3];
                loop {
                    let shard = next.fetch_add(1, Ordering::Relaxed);
                    if shard >= SHARDS {
                        break;
                    }
                    let [a_bits, b1_bits, b5_bits, c_bits] = &mut bits;
                    let report = mark_g41_q29_profile_shard_participation_from_targets::<0, 2>(
                        [sets[0], sets[3]],
                        [sets[1], sets[2]],
                        [&ia, &ic],
                        [&ib1, &ib5],
                        [(shard / RADIX) as u16, (shard % RADIX) as u16],
                        &target_index,
                        [a_bits, b1_bits, b5_bits, c_bits],
                    )?;
                    for side in 0..3 {
                        checked_sum(&mut examined[side], report.pair_records_examined[side])?;
                        checked_sum(&mut matching[side], report.matching_pair_records[side])?;
                    }
                }
                Ok(Worker {
                    examined,
                    matching,
                    bits,
                })
            }));
        }
        handles
            .into_iter()
            .map(|handle| {
                handle
                    .join()
                    .map_err(|_| anyhow::anyhow!("worker panicked"))?
            })
            .collect()
    })?;
    let mut merged = std::array::from_fn(|block| bit_words(sets[block].len()));
    let mut examined = [0_u64; 3];
    let mut matching = [0_u64; 3];
    for worker in workers {
        for side in 0..3 {
            checked_sum(&mut examined[side], worker.examined[side])?;
            checked_sum(&mut matching[side], worker.matching[side])?;
        }
        for block in 0..4 {
            for (target, source) in merged[block].iter_mut().zip(&worker.bits[block]) {
                *target |= source;
            }
        }
    }
    let participating_profiles = merged
        .each_ref()
        .map(|bits| bits.iter().map(|word| word.count_ones()).sum::<u32>());
    let participation_digests = merged.each_ref().map(|bits| {
        let mut hasher = Sha256::new();
        for word in bits {
            hasher.update(word.to_le_bytes());
        }
        hasher.finalize().into()
    });
    let participating_profile_indices = args.emit_indices.then(|| {
        std::array::from_fn(|block| {
            (0..sets[block].len())
                .filter(|&index| merged[block][index / 64] & (1_u64 << (index % 64)) != 0)
                .map(|index| index as u32)
                .collect()
        })
    });
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            threads: args.threads as u8,
            projection_coordinates: [0, 2],
            target_cache: cache.report,
            target_index_bytes: target_index.bytes(),
            pair_records_examined: examined,
            matching_pair_records: matching,
            source_profiles: sets.map(|profiles| profiles.len() as u32),
            participating_profiles,
            participating_profile_indices,
            participation_digests,
            authority: "discovery-only until equality with the independent direct participation census and source lifts is established",
            provenance: "sealed-cache exact-key participation accelerator; a shared immutable Bloom filter can reject only absent targets, the open-addressed index stores only target-array indices, every positive hit compares all seven coordinates, worker-local endpoint bitsets merge by OR, the hot pair loops allocate zero bytes, and no fingerprint or cache hit can authorize exclusion",
        },
    )?;
    println!();
    Ok(())
}
