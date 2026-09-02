use std::collections::BTreeMap;
use std::fs::File;
use std::path::PathBuf;

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_q29_exact_tablebase::{
    compile_g41_q29_aggregate_block_tablebase, compile_g41_q29_fixed_zero_defect_tablebase,
    G41Q29AggregateBlockTablebase,
};
use ergodis_private::g41_q29_matched_pair_cache::read_g41_q29_matched_pair_cache;
use ergodis_private::g41_q29_pair_target_cache::{
    read_g41_q29_pair_target_cache, verify_g41_q29_pair_target_source,
    G41Q29PairTargetSourceBinding,
};
use ergodis_private::g41_q29_source_pair_graph::{G41Q29SourcePair, G41Q29SourcePairEdge};
use ergodis_private::g41_q87_energy::{G41Q87EnergySpecTable, Q87_ENERGY_WORDS};
use serde::{Deserialize, Serialize};

const TARGET: u16 = 523;
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

#[derive(Clone, Copy, Default)]
struct Envelope {
    minimum: u16,
    maximum: u16,
    step: u16,
    valid: bool,
}

#[derive(Serialize)]
struct EdgeReport {
    behavior: BehaviorEdge,
    source_edges: u32,
    source_interfaces: u32,
    exact_q29_quartets: [u64; 2],
    marginal_survivors: [u64; 2],
}

#[derive(Serialize)]
struct Report {
    behavior_edges: u16,
    source_edges: u32,
    source_interfaces: u32,
    exact_q29_quartets_per_source_edge: [u64; 2],
    marginal_source_jobs: u64,
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

const fn gcd(mut first: u16, mut second: u16) -> u16 {
    while second != 0 {
        let remainder = first % second;
        first = second;
        second = remainder;
    }
    first
}

fn envelope(support: &[u64; Q87_ENERGY_WORDS]) -> Envelope {
    let mut result = Envelope::default();
    let mut previous = None;
    for energy in 0..=usize::from(TARGET) {
        if support[energy / 64] & (1_u64 << (energy % 64)) == 0 {
            continue;
        }
        let energy = energy as u16;
        if !result.valid {
            result.minimum = energy;
            result.valid = true;
        }
        if let Some(previous) = previous {
            result.step = gcd(result.step, energy - previous);
        }
        previous = Some(energy);
        result.maximum = energy;
    }
    result
}

#[inline(always)]
fn marginally_feasible(values: [Envelope; 4]) -> bool {
    if values.iter().any(|value| !value.valid) {
        return false;
    }
    let minimum = values
        .iter()
        .map(|value| u32::from(value.minimum))
        .sum::<u32>();
    let maximum = values
        .iter()
        .map(|value| u32::from(value.maximum))
        .sum::<u32>();
    let target = u32::from(TARGET);
    if target < minimum || target > maximum {
        return false;
    }
    let step = values.iter().fold(0_u16, |acc, value| gcd(acc, value.step));
    step == 0 || (target - minimum) % u32::from(step) == 0
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
    ensure!(matched.report.exact_profile_quartets == [149_884, 2_205_896]);

    let behavior_input: BehaviorInput = serde_json::from_reader(File::open(args.behavior_census)?)?;
    ensure!(usize::from(behavior_input.behavior_classes) == BEHAVIORS);
    let mut behavior_by_spec = BTreeMap::new();
    let mut representatives = [None; BEHAVIORS];
    for spec in behavior_input.specs {
        ensure!(usize::from(spec.behavior) < BEHAVIORS);
        ensure!(behavior_by_spec
            .insert((spec.mask, spec.digits), spec.behavior)
            .is_none());
        representatives[usize::from(spec.behavior)].get_or_insert((spec.mask, spec.digits));
    }
    let tables: [G41Q87EnergySpecTable; BEHAVIORS] = representatives
        .into_iter()
        .map(|spec| {
            let (mask, digits) = spec.context("behavior lacks representative")?;
            G41Q87EnergySpecTable::compile(mask, digits).map_err(Into::into)
        })
        .collect::<Result<Vec<_>>>()?
        .try_into()
        .map_err(|_| anyhow::anyhow!("behavior table count changed"))?;
    let fixed = [
        compile_g41_q29_fixed_zero_defect_tablebase(260, 8)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 1)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 5)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 9)?,
    ];

    let mut used: [Vec<u32>; 4] = std::array::from_fn(|_| Vec::new());
    for record in matched.records.iter() {
        if record.side == 0 {
            used[0].push(record.first);
            used[3].push(record.second);
        } else {
            let class = if record.archetype_bits == 1 { 1 } else { 2 };
            used[class].push(record.first);
            used[class].push(record.second);
        }
    }
    for indices in &mut used {
        indices.sort_unstable();
        indices.dedup();
    }
    let mut positions: [Vec<u32>; 4] =
        std::array::from_fn(|class| vec![u32::MAX; aggregate[class].profiles.len()]);
    for class in 0..4 {
        for (position, &index) in used[class].iter().enumerate() {
            positions[class][index as usize] = position as u32;
        }
    }
    let mut envelopes: Vec<[Vec<Envelope>; 4]> = (0..BEHAVIORS)
        .map(|_| {
            used.each_ref()
                .map(|indices| vec![Envelope::default(); indices.len()])
        })
        .collect();
    for behavior in 0..BEHAVIORS {
        for class in 0..4 {
            for (position, &index) in used[class].iter().enumerate() {
                let profile = aggregate[class].profiles[index as usize];
                let fibre = fixed[class].coefficient_fibre(profile)?;
                let mut support = [0_u64; Q87_ENERGY_WORDS];
                for coefficients in &fibre.coefficient_values[..usize::from(fibre.len)] {
                    if let Ok(candidate) = tables[behavior].energy_support(*coefficients) {
                        for (target, source) in support.iter_mut().zip(candidate) {
                            *target |= source;
                        }
                    }
                }
                envelopes[behavior][class][position] = envelope(&support);
            }
        }
    }
    let get_envelope = |behavior: u16, class: usize, profile: u32| -> Envelope {
        let position = positions[class][profile as usize];
        debug_assert_ne!(position, u32::MAX);
        envelopes[usize::from(behavior)][class][position as usize]
    };

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
    ensure!(edge_types.len() == 28);

    let mut reports = Vec::with_capacity(edge_types.len());
    let mut marginal_source_jobs = 0_u64;
    for (behavior, (source_edges, source_interfaces)) in edge_types {
        let mut exact_q29_quartets = [0_u64; 2];
        let mut marginal_survivors = [0_u64; 2];
        for archetype in 0..2 {
            let archetype_bit = 1_u8 << archetype;
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
                    .filter(|record| record.archetype_bits & archetype_bit != 0)
                {
                    let a_first = get_envelope(behavior.ac[0], 0, ac.first);
                    let c_second = get_envelope(behavior.ac[1], 3, ac.second);
                    let a_second = get_envelope(behavior.ac[1], 0, ac.first);
                    let c_first = get_envelope(behavior.ac[0], 3, ac.second);
                    for bd in matched.records[split..end]
                        .iter()
                        .filter(|record| record.archetype_bits == archetype_bit)
                    {
                        exact_q29_quartets[archetype] += 1;
                        let b_first = get_envelope(behavior.bd[0], b_class, bd.first);
                        let d_second = get_envelope(behavior.bd[1], b_class, bd.second);
                        let b_second = get_envelope(behavior.bd[1], b_class, bd.first);
                        let d_first = get_envelope(behavior.bd[0], b_class, bd.second);
                        if marginally_feasible([a_first, b_first, c_second, d_second])
                            || marginally_feasible([a_first, b_second, c_second, d_first])
                            || marginally_feasible([a_second, b_first, c_first, d_second])
                            || marginally_feasible([a_second, b_second, c_first, d_first])
                        {
                            marginal_survivors[archetype] += 1;
                        }
                    }
                }
                cursor = end;
            }
            ensure!(
                exact_q29_quartets[archetype] == matched.report.exact_profile_quartets[archetype]
            );
        }
        let survivors = marginal_survivors.iter().sum::<u64>();
        marginal_source_jobs = marginal_source_jobs
            .checked_add(
                survivors
                    .checked_mul(u64::from(source_edges))
                    .context("source job product overflow")?,
            )
            .context("source job count overflow")?;
        reports.push(EdgeReport {
            behavior,
            source_edges,
            source_interfaces,
            exact_q29_quartets,
            marginal_survivors,
        });
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            behavior_edges: reports.len() as u16,
            source_edges: graph.edges.len() as u32,
            source_interfaces: graph.edges.iter().map(|edge| edge.witnessed_interfaces).sum(),
            exact_q29_quartets_per_source_edge: matched.report.exact_profile_quartets,
            marginal_source_jobs,
            edges: reports,
            provenance: "complete exact q29 quartet multiplicity crossed with every translation-canonical source edge behavior; the q87 marginal envelope is a sound necessary condition computed from the full exact energy support (minimum, maximum, and gcd of all differences), including both commutative B/D assignments; survivors are scheduling candidates, not proof authority",
        },
    )?;
    println!();
    Ok(())
}
