use std::collections::BTreeMap;
use std::fs::File;
use std::path::PathBuf;

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_q29_exact_tablebase::{
    compile_g41_q29_aggregate_block_tablebase, G41Q29AggregateBlockTablebase,
};
use ergodis_private::g41_q29_matched_pair_cache::read_g41_q29_matched_pair_cache;
use ergodis_private::g41_q29_pair_target_cache::{
    read_g41_q29_pair_target_cache, verify_g41_q29_pair_target_source,
    G41Q29PairTargetSourceBinding,
};
use ergodis_private::g41_q29_q58_energy::{
    compile_g41_q29_q58_energy_tablebase, G41Q29Q58EnergyTablebase,
};
use ergodis_private::g41_q29_source_pair_graph::{G41Q29SourcePair, G41Q29SourcePairEdge};
use ergodis_private::g41_q58_exact_tablebase::Q58_ANTI_ENERGY_WORDS;
use serde::{Deserialize, Serialize};

const TARGET: usize = 523;
const BEHAVIORS: usize = 11;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    target_cache: PathBuf,
    #[arg(long)]
    matched_pair_cache: PathBuf,
    #[arg(long)]
    behavior_census: PathBuf,
    #[arg(long)]
    source_graph: PathBuf,
}

#[derive(Clone, Copy, Deserialize)]
struct SpecBehavior {
    mask: u8,
    digits: u32,
    behavior: u16,
}

#[derive(Deserialize)]
struct BehaviorInput {
    behavior_classes: u16,
    specs: Vec<SpecBehavior>,
}

#[derive(Deserialize)]
struct SourceGraphFile {
    translation_canonical: SourceGraph,
}

#[derive(Deserialize)]
struct SourceGraph {
    ac_pairs: Vec<G41Q29SourcePair>,
    bd_pairs: Vec<G41Q29SourcePair>,
    edges: Vec<G41Q29SourcePairEdge>,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Serialize)]
struct BehaviorEdge {
    ac: [u16; 2],
    bd: [u16; 2],
}

struct BehaviorTable {
    class: usize,
    table: G41Q29Q58EnergyTablebase,
    energy_class_by_profile: Vec<u16>,
}

#[derive(Serialize)]
struct BehaviorReport {
    behavior: u16,
    class: &'static str,
    representative_mask: u8,
    representative_digits: u32,
    reachable_profiles: u32,
    energy_support_classes: u32,
    profile_digest: [u8; 32],
}

#[derive(Serialize)]
struct EdgeReport {
    behavior: BehaviorEdge,
    source_edges: u32,
    source_interfaces: u32,
    q58_survivors: [u64; 2],
}

#[derive(Serialize)]
struct Report {
    hypothesis: &'static str,
    behaviors: Vec<BehaviorReport>,
    behavior_edges: u16,
    source_edges: u32,
    q58_source_jobs: u64,
    edges: Vec<EdgeReport>,
    provenance: &'static str,
}

fn source_binding(tables: &[G41Q29AggregateBlockTablebase; 4]) -> G41Q29PairTargetSourceBinding {
    G41Q29PairTargetSourceBinding {
        signatures: tables.each_ref().map(|table| table.report.signature),
        profile_counts: tables.each_ref().map(|table| table.profiles.len() as u32),
        profile_digests: tables.each_ref().map(|table| table.report.profile_digest),
    }
}

fn behavior_class(behavior: usize) -> Result<usize> {
    match behavior {
        0 | 3 | 10 => Ok(0),
        6..=8 => Ok(1),
        1 | 4 | 5 => Ok(2),
        2 | 9 => Ok(3),
        _ => anyhow::bail!("unknown q87 behavior"),
    }
}

fn support_values(support: &[u64; Q58_ANTI_ENERGY_WORDS]) -> Vec<u16> {
    let mut values = Vec::new();
    for value in 0..=TARGET {
        if support[value / 64] & (1_u64 << (value % 64)) != 0 {
            values.push(value as u16);
        }
    }
    values
}

fn four_supports_reach_target(supports: [&[u64; Q58_ANTI_ENERGY_WORDS]; 4]) -> bool {
    let values = supports.map(support_values);
    let mut right = [false; TARGET + 1];
    for &third in &values[2] {
        for &fourth in &values[3] {
            let sum = usize::from(third + fourth);
            if sum <= TARGET {
                right[sum] = true;
            }
        }
    }
    for &first in &values[0] {
        for &second in &values[1] {
            let sum = usize::from(first + second);
            if sum <= TARGET && right[TARGET - sum] {
                return true;
            }
        }
    }
    false
}

fn main() -> Result<()> {
    let args = Args::parse();
    let aggregate = [
        compile_g41_q29_aggregate_block_tablebase([8, 3, 15, 15])?,
        compile_g41_q29_aggregate_block_tablebase([1, 9, 14, 14])?,
        compile_g41_q29_aggregate_block_tablebase([5, 8, 14, 14])?,
        compile_g41_q29_aggregate_block_tablebase([9, 7, 14, 14])?,
    ];
    let source = source_binding(&aggregate);
    let targets = read_g41_q29_pair_target_cache(File::open(args.target_cache)?)?;
    verify_g41_q29_pair_target_source(&targets, source)?;
    let matched = read_g41_q29_matched_pair_cache(
        File::open(args.matched_pair_cache)?,
        &targets,
        source,
        &aggregate,
    )?;
    let behavior_input: BehaviorInput = serde_json::from_reader(File::open(args.behavior_census)?)?;
    ensure!(usize::from(behavior_input.behavior_classes) == BEHAVIORS);
    let mut behavior_by_spec = BTreeMap::new();
    let mut representatives = [None; BEHAVIORS];
    for spec in behavior_input.specs {
        ensure!(behavior_by_spec
            .insert((spec.mask, spec.digits), spec.behavior)
            .is_none());
        representatives[usize::from(spec.behavior)].get_or_insert((spec.mask, spec.digits));
    }
    let mut tables = Vec::with_capacity(BEHAVIORS);
    let mut behavior_reports = Vec::with_capacity(BEHAVIORS);
    for (behavior, representative) in representatives.into_iter().enumerate() {
        let (mask, digits) = representative.context("behavior lacks representative")?;
        let table = compile_g41_q29_q58_energy_tablebase(mask, digits)?;
        let class = behavior_class(behavior)?;
        let mut energy_class_by_profile = vec![u16::MAX; aggregate[class].profiles.len()];
        for profile in table.profiles.iter() {
            let index = aggregate[class]
                .profiles
                .binary_search(&profile.profile)
                .map_err(|_| {
                    anyhow::anyhow!(
                        "q58 behavior {behavior} representative ({mask},{digits}) emitted a profile outside aggregate class {class}"
                    )
                })?;
            ensure!(energy_class_by_profile[index] == u16::MAX);
            energy_class_by_profile[index] = profile.energy_class;
        }
        behavior_reports.push(BehaviorReport {
            behavior: behavior as u16,
            class: ["A", "B1", "B5", "C"][class],
            representative_mask: mask,
            representative_digits: digits,
            reachable_profiles: table.profiles.len() as u32,
            energy_support_classes: table.report.distinct_energy_supports,
            profile_digest: table.report.profile_digest,
        });
        tables.push(BehaviorTable {
            class,
            table,
            energy_class_by_profile,
        });
    }

    let source_graph: SourceGraphFile = serde_json::from_reader(File::open(args.source_graph)?)?;
    let graph = source_graph.translation_canonical;
    let pair_behavior = |pair: G41Q29SourcePair| -> Result<[u16; 2]> {
        let mut result = [0_u16; 2];
        for index in 0..2 {
            result[index] = *behavior_by_spec
                .get(&(pair.blocks[index].mask, pair.blocks[index].digits))
                .context("source spec absent from behavior census")?;
        }
        result.sort_unstable();
        Ok(result)
    };
    let ac_behavior = graph
        .ac_pairs
        .iter()
        .copied()
        .map(pair_behavior)
        .collect::<Result<Vec<_>>>()?;
    let bd_behavior = graph
        .bd_pairs
        .iter()
        .copied()
        .map(pair_behavior)
        .collect::<Result<Vec<_>>>()?;
    let mut edge_types = BTreeMap::<BehaviorEdge, (u32, u32)>::new();
    for edge in &graph.edges {
        let behavior = BehaviorEdge {
            ac: ac_behavior[edge.ac_pair as usize],
            bd: bd_behavior[edge.bd_pair as usize],
        };
        let counts = edge_types.entry(behavior).or_default();
        counts.0 += 1;
        counts.1 += edge.witnessed_interfaces;
    }

    let mut compatibility = BTreeMap::<(BehaviorEdge, usize, bool, bool, [u16; 4]), bool>::new();
    for &behavior in edge_types.keys() {
        for archetype in 0..2 {
            let b_class = archetype + 1;
            for swap_ac in [false, true] {
                for swap_bd in [false, true] {
                    let ids = [
                        behavior.ac[usize::from(swap_ac)],
                        behavior.bd[usize::from(swap_bd)],
                        behavior.ac[usize::from(!swap_ac)],
                        behavior.bd[usize::from(!swap_bd)],
                    ];
                    if [0, b_class, 3, b_class]
                        .into_iter()
                        .zip(ids)
                        .any(|(class, behavior)| tables[usize::from(behavior)].class != class)
                    {
                        continue;
                    }
                    let class_counts = ids.map(|id| {
                        tables[usize::from(id)]
                            .table
                            .report
                            .energy_support_classes
                            .len() as u16
                    });
                    for first in 0..class_counts[0] {
                        for second in 0..class_counts[1] {
                            for third in 0..class_counts[2] {
                                for fourth in 0..class_counts[3] {
                                    let classes = [first, second, third, fourth];
                                    let supports = std::array::from_fn(|block| {
                                        &tables[usize::from(ids[block])]
                                            .table
                                            .report
                                            .energy_support_classes[usize::from(classes[block])]
                                        .support
                                    });
                                    compatibility.insert(
                                        (behavior, archetype, swap_ac, swap_bd, classes),
                                        four_supports_reach_target(supports),
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    let mut reports = Vec::with_capacity(edge_types.len());
    let mut q58_source_jobs = 0_u64;
    for (behavior, (source_edges, source_interfaces)) in edge_types {
        let mut q58_survivors = [0_u64; 2];
        for archetype in 0..2 {
            let bit = 1_u8 << archetype;
            let b_class = archetype + 1;
            let mut cursor = 0_usize;
            while cursor < matched.records.len() {
                let target = matched.records[cursor].target;
                let end = matched.records[cursor..]
                    .partition_point(|record| record.target == target)
                    + cursor;
                let split = matched.records[cursor..end].partition_point(|record| record.side == 0)
                    + cursor;
                for ac in matched.records[cursor..split]
                    .iter()
                    .filter(|record| record.archetype_bits & bit != 0)
                {
                    for bd in matched.records[split..end]
                        .iter()
                        .filter(|record| record.archetype_bits == bit)
                    {
                        let mut accepted = false;
                        for swap_ac in [false, true] {
                            for swap_bd in [false, true] {
                                let ids = [
                                    behavior.ac[usize::from(swap_ac)],
                                    behavior.bd[usize::from(swap_bd)],
                                    behavior.ac[usize::from(!swap_ac)],
                                    behavior.bd[usize::from(!swap_bd)],
                                ];
                                if [0, b_class, 3, b_class]
                                    .into_iter()
                                    .zip(ids)
                                    .any(|(class, id)| tables[usize::from(id)].class != class)
                                {
                                    continue;
                                }
                                let profile_indices = [ac.first, bd.first, ac.second, bd.second];
                                let classes = std::array::from_fn(|block| {
                                    tables[usize::from(ids[block])].energy_class_by_profile
                                        [profile_indices[block] as usize]
                                });
                                if classes.contains(&u16::MAX) {
                                    continue;
                                }
                                accepted |= compatibility
                                    .get(&(behavior, archetype, swap_ac, swap_bd, classes))
                                    .copied()
                                    .unwrap_or(false);
                            }
                        }
                        q58_survivors[archetype] += u64::from(accepted);
                    }
                }
                cursor = end;
            }
        }
        q58_source_jobs = q58_source_jobs
            .checked_add(
                q58_survivors
                    .iter()
                    .sum::<u64>()
                    .checked_mul(u64::from(source_edges))
                    .context("source job product overflow")?,
            )
            .context("source job sum overflow")?;
        reports.push(EdgeReport {
            behavior,
            source_edges,
            source_interfaces,
            q58_survivors,
        });
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            hypothesis: "q87 energy-support behavior also determines the exact q29-profile-to-q58-energy-support table; representative compilation is discovery-only until every member or a structural intertwining proof is checked",
            behaviors: behavior_reports,
            behavior_edges: reports.len() as u16,
            source_edges: graph.edges.len() as u32,
            q58_source_jobs,
            edges: reports,
            provenance: "complete sealed q29 quartet replay through representative source-behavior q58 energy tables; every table independently rebinds by exact profile equality to one aggregate class, both commutative assignments are tested, and the result is discovery scheduling evidence rather than negative authority until behavior-wide semantic equivalence is proved",
        },
    )?;
    println!();
    Ok(())
}
