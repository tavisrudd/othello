use std::sync::atomic::{AtomicUsize, Ordering};
use std::{fs::File, path::PathBuf};

use anyhow::{ensure, Context, Result};
use clap::Args as ClapArgs;
use ergodis_private::g41_q29_exact_tablebase::{
    compile_g41_q29_aggregate_block_tablebase, G41Q29AggregateBlockTablebase,
};
use ergodis_private::g41_q29_pair_target_cache::{
    write_g41_q29_pair_target_cache, G41Q29PairTargetCacheReport, G41Q29PairTargetSourceBinding,
};
use ergodis_private::g41_q29_profile_descent::G41Q29ProfileJoinCandidate;
use ergodis_private::g41_q29_profile_shard::{
    collect_g41_q29_pair_targets_dual, compile_g41_q29_projection_index,
    count_g41_q29_profile_shard_dual, G41Q29PairTarget, G41Q29PairTargetWorkspace,
    G41Q29ProfileShardWorkspace,
};
use serde::Serialize;

const RADIX: usize = 524;
const SHARDS: usize = RADIX * RADIX;

#[derive(ClapArgs)]
pub struct Arguments {
    #[arg(long, default_value_t = 0)]
    first_coordinate: usize,
    #[arg(long, default_value_t = 2)]
    second_coordinate: usize,
    #[arg(long, default_value_t = 16)]
    threads: usize,
    #[arg(long, default_value_t = 0)]
    shard_start: usize,
    #[arg(long, default_value_t = SHARDS)]
    shard_end: usize,
    #[arg(long, default_value_t = 16_777_216)]
    capacity: usize,
    #[arg(long, default_value_t = 0)]
    pair_target_capacity: usize,
    #[arg(long, default_value_t = 0)]
    pair_target_output_capacity_per_thread: usize,
    #[arg(long)]
    pair_target_output: Option<PathBuf>,
}

#[derive(Clone, Copy, Serialize)]
struct SampleHit {
    shard: u32,
    left_projection_sum: [u16; 2],
    candidate: G41Q29ProfileJoinCandidate,
}

#[derive(Default)]
struct WorkerReport {
    shards: u32,
    nonempty_left_shards: u32,
    left_pairs_generated: u128,
    right_pairs_probed: [u128; 2],
    exact_profile_quartets: [u128; 2],
    hit_shards: [u32; 2],
    samples: [Option<SampleHit>; 2],
    distinct_pair_targets: [u128; 2],
    union_distinct_pair_targets: u128,
    targets: Vec<G41Q29PairTarget>,
}

#[derive(Serialize)]
struct CampaignReport {
    threads: u8,
    projection_coordinates: [u8; 2],
    shard_range: [u32; 2],
    shards: u32,
    nonempty_left_shards: u32,
    left_pairs_generated: String,
    b1_right_pairs_probed: String,
    b5_right_pairs_probed: String,
    b1_exact_profile_quartets: String,
    b5_exact_profile_quartets: String,
    hit_shards: [u32; 2],
    samples: [Option<SampleHit>; 2],
    distinct_pair_targets: Option<[String; 2]>,
    union_distinct_pair_targets: Option<String>,
    workspace_bytes_per_thread: u64,
    pair_target_workspace_bytes_per_thread: u64,
    source_binding: G41Q29PairTargetSourceBinding,
    pair_target_cache: Option<G41Q29PairTargetCacheReport>,
    authority: &'static str,
    provenance: &'static str,
}

fn checked_merge(total: &mut WorkerReport, mut worker: WorkerReport) -> Result<()> {
    total.shards = total.shards.checked_add(worker.shards).context("shards")?;
    total.nonempty_left_shards = total
        .nonempty_left_shards
        .checked_add(worker.nonempty_left_shards)
        .context("nonempty shards")?;
    total.left_pairs_generated = total
        .left_pairs_generated
        .checked_add(worker.left_pairs_generated)
        .context("left pairs")?;
    for archetype in 0..2 {
        total.right_pairs_probed[archetype] = total.right_pairs_probed[archetype]
            .checked_add(worker.right_pairs_probed[archetype])
            .context("right pairs")?;
        total.exact_profile_quartets[archetype] = total.exact_profile_quartets[archetype]
            .checked_add(worker.exact_profile_quartets[archetype])
            .context("quartets")?;
        total.hit_shards[archetype] = total.hit_shards[archetype]
            .checked_add(worker.hit_shards[archetype])
            .context("hit shards")?;
        if let Some(sample) = worker.samples[archetype] {
            if total.samples[archetype].is_none_or(|previous| sample.shard < previous.shard) {
                total.samples[archetype] = Some(sample);
            }
        }
        total.distinct_pair_targets[archetype] = total.distinct_pair_targets[archetype]
            .checked_add(worker.distinct_pair_targets[archetype])
            .context("distinct pair targets")?;
    }
    total.union_distinct_pair_targets = total
        .union_distinct_pair_targets
        .checked_add(worker.union_distinct_pair_targets)
        .context("union pair targets")?;
    total.targets.append(&mut worker.targets);
    Ok(())
}

fn binding(
    a: &G41Q29AggregateBlockTablebase,
    b1: &G41Q29AggregateBlockTablebase,
    b5: &G41Q29AggregateBlockTablebase,
    c: &G41Q29AggregateBlockTablebase,
) -> G41Q29PairTargetSourceBinding {
    G41Q29PairTargetSourceBinding {
        signatures: [
            a.report.signature,
            b1.report.signature,
            b5.report.signature,
            c.report.signature,
        ],
        profile_counts: [
            a.report.exact_correlation_profiles,
            b1.report.exact_correlation_profiles,
            b5.report.exact_correlation_profiles,
            c.report.exact_correlation_profiles,
        ],
        profile_digests: [
            a.report.profile_digest,
            b1.report.profile_digest,
            b5.report.profile_digest,
            c.report.profile_digest,
        ],
    }
}

fn run_projection<const FIRST: usize, const SECOND: usize>(args: Arguments) -> Result<()> {
    ensure!((1..=32).contains(&args.threads));
    ensure!(args.shard_start < args.shard_end && args.shard_end <= SHARDS);
    ensure!(
        args.pair_target_output.is_none()
            || (args.pair_target_capacity != 0 && args.pair_target_output_capacity_per_thread != 0)
    );

    let a = compile_g41_q29_aggregate_block_tablebase([8, 3, 15, 15])?;
    let b1 = compile_g41_q29_aggregate_block_tablebase([1, 9, 14, 14])?;
    let b5 = compile_g41_q29_aggregate_block_tablebase([5, 8, 14, 14])?;
    let c = compile_g41_q29_aggregate_block_tablebase([9, 7, 14, 14])?;
    let ia = compile_g41_q29_projection_index::<FIRST, SECOND>(&a.profiles)?;
    let ib1 = compile_g41_q29_projection_index::<FIRST, SECOND>(&b1.profiles)?;
    let ib5 = compile_g41_q29_projection_index::<FIRST, SECOND>(&b5.profiles)?;
    let ic = compile_g41_q29_projection_index::<FIRST, SECOND>(&c.profiles)?;
    let next = AtomicUsize::new(args.shard_start);
    let mut total = std::thread::scope(|scope| -> Result<WorkerReport> {
        let mut handles = Vec::with_capacity(args.threads);
        for _ in 0..args.threads {
            handles.push(scope.spawn(|| -> Result<WorkerReport> {
                let mut workspace = G41Q29ProfileShardWorkspace::new(args.capacity)?;
                let mut target_workspace = (args.pair_target_capacity != 0)
                    .then(|| G41Q29PairTargetWorkspace::new(args.pair_target_capacity))
                    .transpose()?;
                let mut worker = WorkerReport::default();
                if args.pair_target_output_capacity_per_thread != 0 {
                    worker.targets =
                        Vec::with_capacity(args.pair_target_output_capacity_per_thread);
                }
                loop {
                    let shard = next.fetch_add(1, Ordering::Relaxed);
                    if shard >= args.shard_end {
                        break;
                    }
                    let left_projection_sum = [(shard / RADIX) as u16, (shard % RADIX) as u16];
                    let report = count_g41_q29_profile_shard_dual::<FIRST, SECOND>(
                        [&a.profiles, &c.profiles],
                        [&b1.profiles, &b5.profiles],
                        [&ia, &ic],
                        [&ib1, &ib5],
                        left_projection_sum,
                        &mut workspace,
                    )?;
                    worker.shards = worker.shards.checked_add(1).context("worker shards")?;
                    worker.nonempty_left_shards += u32::from(report.left_key_entries != 0);
                    worker.left_pairs_generated = worker
                        .left_pairs_generated
                        .checked_add(u128::from(report.left_pairs_generated))
                        .context("worker left pairs")?;
                    for archetype in 0..2 {
                        let probe = &report.probes[archetype];
                        worker.right_pairs_probed[archetype] = worker.right_pairs_probed[archetype]
                            .checked_add(u128::from(probe.right_pairs_probed))
                            .context("worker right pairs")?;
                        worker.exact_profile_quartets[archetype] = worker.exact_profile_quartets
                            [archetype]
                            .checked_add(probe.exact_profile_quartets)
                            .context("worker quartets")?;
                        if probe.exact_profile_quartets != 0 {
                            worker.hit_shards[archetype] = worker.hit_shards[archetype]
                                .checked_add(1)
                                .context("worker hit shards")?;
                            if worker.samples[archetype].is_none() {
                                let candidate = probe
                                    .sample_hit
                                    .context("nonzero multiplicity requires replayed sample")?;
                                worker.samples[archetype] = Some(SampleHit {
                                    shard: shard as u32,
                                    left_projection_sum,
                                    candidate,
                                });
                            }
                        }
                    }
                    if let Some(target_workspace) = &mut target_workspace {
                        let targets = collect_g41_q29_pair_targets_dual::<FIRST, SECOND>(
                            [&b1.profiles, &b5.profiles],
                            [&ib1, &ib5],
                            left_projection_sum,
                            &workspace,
                            target_workspace,
                        )?;
                        worker.distinct_pair_targets[0] = worker.distinct_pair_targets[0]
                            .checked_add(u128::from(targets.b1_distinct_targets))
                            .context("worker B1 pair targets")?;
                        worker.distinct_pair_targets[1] = worker.distinct_pair_targets[1]
                            .checked_add(u128::from(targets.b5_distinct_targets))
                            .context("worker B5 pair targets")?;
                        worker.union_distinct_pair_targets = worker
                            .union_distinct_pair_targets
                            .checked_add(u128::from(targets.union_distinct_targets))
                            .context("worker union pair targets")?;
                        if args.pair_target_output_capacity_per_thread != 0 {
                            target_workspace.append_targets::<FIRST, SECOND>(
                                left_projection_sum,
                                &mut worker.targets,
                                args.pair_target_output_capacity_per_thread,
                            )?;
                        }
                    }
                }
                Ok(worker)
            }));
        }
        let mut total = WorkerReport::default();
        for handle in handles {
            checked_merge(
                &mut total,
                handle.join().expect("campaign worker panicked")?,
            )?;
        }
        Ok(total)
    })?;
    let source_binding = binding(&a, &b1, &b5, &c);
    let pair_target_cache = if let Some(path) = &args.pair_target_output {
        total.targets.sort_unstable();
        total.targets.dedup();
        Some(write_g41_q29_pair_target_cache(
            &total.targets,
            source_binding,
            File::create(path)?,
        )?)
    } else {
        None
    };
    let report = CampaignReport {
        threads: args.threads as u8,
        projection_coordinates: [FIRST as u8, SECOND as u8],
        shard_range: [args.shard_start as u32, args.shard_end as u32],
        shards: total.shards,
        nonempty_left_shards: total.nonempty_left_shards,
        left_pairs_generated: total.left_pairs_generated.to_string(),
        b1_right_pairs_probed: total.right_pairs_probed[0].to_string(),
        b5_right_pairs_probed: total.right_pairs_probed[1].to_string(),
        b1_exact_profile_quartets: total.exact_profile_quartets[0].to_string(),
        b5_exact_profile_quartets: total.exact_profile_quartets[1].to_string(),
        hit_shards: total.hit_shards,
        samples: total.samples,
        distinct_pair_targets: (args.pair_target_capacity != 0)
            .then(|| total.distinct_pair_targets.map(|count| count.to_string())),
        union_distinct_pair_targets: (args.pair_target_capacity != 0)
            .then(|| total.union_distinct_pair_targets.to_string()),
        workspace_bytes_per_thread: (args.capacity * std::mem::size_of::<u64>()) as u64,
        pair_target_workspace_bytes_per_thread: (args.pair_target_capacity
            * std::mem::size_of::<u64>()) as u64,
        source_binding,
        pair_target_cache,
        authority: "discovery-only until every aggregate-class mapping is independently replayed and every source profile hit is lifted through its bound interface",
        provenance: "exact bounded iterative dual-archetype q29 profile campaign; dynamic independent shards, one A+C sort shared across B1+B1 and B5+B5, zero-allocation shard kernel, exact quartet counts, and directly replayed sample profile indices",
    };
    serde_json::to_writer(std::io::stdout(), &report)?;
    println!();
    Ok(())
}

pub fn run(args: Arguments) -> Result<()> {
    match (args.first_coordinate, args.second_coordinate) {
        (0, 1) => run_projection::<0, 1>(args),
        (0, 2) => run_projection::<0, 2>(args),
        (0, 3) => run_projection::<0, 3>(args),
        (1, 4) => run_projection::<1, 4>(args),
        (1, 5) => run_projection::<1, 5>(args),
        (2, 5) => run_projection::<2, 5>(args),
        (3, 6) => run_projection::<3, 6>(args),
        (4, 6) => run_projection::<4, 6>(args),
        _ => anyhow::bail!("coordinates must be the legacy control or one evolved q29 cycle edge"),
    }
}
