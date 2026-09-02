use std::sync::atomic::{AtomicUsize, Ordering};

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_q29_exact_tablebase::compile_g41_q29_aggregate_block_tablebase;
use ergodis_private::g41_q29_profile_shard::{
    compile_g41_q29_projection_index, mark_g41_q29_profile_shard_participation_dual_streaming,
    G41Q29ProfileParticipationWorkspace,
};
use serde::Serialize;
use sha2::{Digest, Sha256};

const RADIX: usize = 524;
const SHARDS: usize = RADIX * RADIX;

#[derive(Parser)]
struct Args {
    #[arg(long, default_value_t = 4)]
    threads: usize,
    #[arg(long, default_value_t = 16_777_216)]
    capacity: usize,
    #[arg(long)]
    emit_indices: bool,
}

struct Worker {
    quartets: [u128; 2],
    bits: [Vec<u64>; 4],
}

#[derive(Serialize)]
struct Report {
    threads: u8,
    projection_coordinates: [u8; 2],
    source_profiles: [u32; 4],
    source_profile_digests: [[u8; 32]; 4],
    participating_profiles: [u32; 4],
    participating_profile_indices: Option<[Vec<u32>; 4]>,
    participation_digests: [[u8; 32]; 4],
    exact_profile_quartets: [String; 2],
    workspace_bytes_per_thread: u64,
    provenance: &'static str,
}

fn bit_words(length: usize) -> Vec<u64> {
    vec![0_u64; length.div_ceil(64)]
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
    let ia = compile_g41_q29_projection_index::<0, 2>(sets[0])?;
    let ib1 = compile_g41_q29_projection_index::<0, 2>(sets[1])?;
    let ib5 = compile_g41_q29_projection_index::<0, 2>(sets[2])?;
    let ic = compile_g41_q29_projection_index::<0, 2>(sets[3])?;
    let next = AtomicUsize::new(0);
    let workers = std::thread::scope(|scope| -> Result<Vec<Worker>> {
        let mut handles = Vec::with_capacity(args.threads);
        for _ in 0..args.threads {
            handles.push(scope.spawn(|| -> Result<Worker> {
                let mut workspace =
                    G41Q29ProfileParticipationWorkspace::new_streaming(args.capacity)?;
                let mut bits = std::array::from_fn(|block| bit_words(sets[block].len()));
                let mut quartets = [0_u128; 2];
                loop {
                    let shard = next.fetch_add(1, Ordering::Relaxed);
                    if shard >= SHARDS {
                        break;
                    }
                    let [a_bits, b1_bits, b5_bits, c_bits] = &mut bits;
                    let found = mark_g41_q29_profile_shard_participation_dual_streaming::<0, 2>(
                        [sets[0], sets[3]],
                        [sets[1], sets[2]],
                        [&ia, &ic],
                        [&ib1, &ib5],
                        [(shard / RADIX) as u16, (shard % RADIX) as u16],
                        &mut workspace,
                        [a_bits, b1_bits, b5_bits, c_bits],
                    )?;
                    for archetype in 0..2 {
                        quartets[archetype] = quartets[archetype]
                            .checked_add(found[archetype])
                            .context("quartet total overflow")?;
                    }
                }
                Ok(Worker { quartets, bits })
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
    let mut quartets = [0_u128; 2];
    for worker in workers {
        for archetype in 0..2 {
            quartets[archetype] = quartets[archetype]
                .checked_add(worker.quartets[archetype])
                .context("merged quartet total overflow")?;
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
            source_profiles: sets.map(|profiles| profiles.len() as u32),
            source_profile_digests: [
                a.report.profile_digest,
                b1.report.profile_digest,
                b5.report.profile_digest,
                c.report.profile_digest,
            ],
            participating_profiles,
            participating_profile_indices,
            participation_digests,
            exact_profile_quartets: quartets.map(|count| count.to_string()),
            workspace_bytes_per_thread: (args.capacity
                * std::mem::size_of::<(u64, u32, u32)>()) as u64
                + merged
                    .iter()
                    .map(|bits| bits.len() * std::mem::size_of::<u64>())
                    .sum::<usize>() as u64,
            provenance: "exact aggregate q29 participation census; every A+C pair record retains both source profile indices and is sorted once, both cold one-use right archetypes stream against that shared table without retention, all matching quartet endpoints are marked in fixed bitsets, and quartet totals must reproduce the independent multiplicity campaign",
        },
    )?;
    println!();
    Ok(())
}
