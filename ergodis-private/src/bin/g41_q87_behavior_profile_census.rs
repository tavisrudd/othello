use std::collections::BTreeSet;
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
use ergodis_private::g41_q87_energy::{G41Q87EnergySpecTable, Q87_ENERGY_WORDS};
use serde::{Deserialize, Serialize};

const TARGET: usize = 523;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    target_cache: PathBuf,
    #[arg(long)]
    matched_pair_cache: PathBuf,
    #[arg(long)]
    behavior_census: PathBuf,
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

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Serialize)]
struct Progression {
    minimum: u16,
    maximum: u16,
    step: u16,
}

#[derive(Serialize)]
struct CellReport {
    behavior: u16,
    class: &'static str,
    participating_profiles: u32,
    coefficient_states: u32,
    valid_profiles: u32,
    invalid_profiles: u32,
    non_progression_profiles: u32,
    distinct_progressions: u16,
    progressions: Vec<Progression>,
}

#[derive(Serialize)]
struct Report {
    matched_pair_cache: ergodis_private::g41_q29_matched_pair_cache::G41Q29MatchedPairCacheReport,
    behavior_classes: u16,
    participating_profiles: [u32; 4],
    cells: Vec<CellReport>,
    all_valid_supports_are_progressions: bool,
    provenance: &'static str,
}

fn source_binding(tables: &[G41Q29AggregateBlockTablebase; 4]) -> G41Q29PairTargetSourceBinding {
    G41Q29PairTargetSourceBinding {
        signatures: tables.each_ref().map(|table| table.report.signature),
        profile_counts: tables.each_ref().map(|table| table.profiles.len() as u32),
        profile_digests: tables.each_ref().map(|table| table.report.profile_digest),
    }
}

fn progression(support: &[u64; Q87_ENERGY_WORDS]) -> Option<Progression> {
    let mut minimum = None;
    let mut maximum = 0_u16;
    let mut previous = None;
    let mut step = 0_u16;
    let mut count = 0_u16;
    for energy in 0..=TARGET {
        if support[energy / 64] & (1_u64 << (energy % 64)) == 0 {
            continue;
        }
        let energy = energy as u16;
        minimum.get_or_insert(energy);
        maximum = energy;
        if let Some(previous) = previous {
            step = gcd(step, energy - previous);
        }
        previous = Some(energy);
        count += 1;
    }
    let minimum = minimum?;
    if count == 1 {
        return Some(Progression {
            minimum,
            maximum,
            step: 0,
        });
    }
    (step != 0 && (maximum - minimum) / step + 1 == count).then_some(Progression {
        minimum,
        maximum,
        step,
    })
}

const fn gcd(mut first: u16, mut second: u16) -> u16 {
    while second != 0 {
        let remainder = first % second;
        first = second;
        second = remainder;
    }
    first
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
    let mut representatives = vec![None; usize::from(behavior_input.behavior_classes)];
    for spec in behavior_input.specs {
        let entry = representatives
            .get_mut(usize::from(spec.behavior))
            .context("behavior ID outside declared range")?;
        if entry.is_none() {
            *entry = Some((spec.mask, spec.digits));
        }
    }
    let behavior_tables = representatives
        .into_iter()
        .map(|spec| {
            let (mask, digits) = spec.context("behavior lacks representative")?;
            Ok(G41Q87EnergySpecTable::compile(mask, digits)?)
        })
        .collect::<Result<Vec<_>>>()?;
    let fixed = [
        compile_g41_q29_fixed_zero_defect_tablebase(260, 8)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 1)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 5)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 9)?,
    ];
    let mut profile_indices: [Vec<u32>; 4] = std::array::from_fn(|_| Vec::new());
    for record in matched.records.iter() {
        if record.side == 0 {
            profile_indices[0].push(record.first);
            profile_indices[3].push(record.second);
        } else {
            let class = if record.archetype_bits == 1 { 1 } else { 2 };
            profile_indices[class].push(record.first);
            profile_indices[class].push(record.second);
        }
    }
    for indices in &mut profile_indices {
        indices.sort_unstable();
        indices.dedup();
    }
    let participating_profiles = profile_indices.each_ref().map(|values| values.len() as u32);
    let names = ["A", "B1", "B5", "C"];
    let mut cells = Vec::with_capacity(behavior_tables.len() * 4);
    let mut all_progressions = true;
    for (behavior, table) in behavior_tables.iter().enumerate() {
        for class in 0..4 {
            let mut coefficient_states = 0_u32;
            let mut valid_profiles = 0_u32;
            let mut invalid_profiles = 0_u32;
            let mut non_progression_profiles = 0_u32;
            let mut progressions = BTreeSet::new();
            for &index in &profile_indices[class] {
                let profile = aggregate[class].profiles[index as usize];
                let fibre = fixed[class].coefficient_fibre(profile)?;
                ensure!(fibre.len != 0);
                coefficient_states += u32::from(fibre.len);
                let mut support = [0_u64; Q87_ENERGY_WORDS];
                for coefficients in &fibre.coefficient_values[..usize::from(fibre.len)] {
                    if let Ok(candidate) = table.energy_support(*coefficients) {
                        for (target, source) in support.iter_mut().zip(candidate) {
                            *target |= source;
                        }
                    }
                }
                if support == [0; Q87_ENERGY_WORDS] {
                    invalid_profiles += 1;
                } else if let Some(form) = progression(&support) {
                    valid_profiles += 1;
                    progressions.insert(form);
                } else {
                    valid_profiles += 1;
                    non_progression_profiles += 1;
                    all_progressions = false;
                }
            }
            cells.push(CellReport {
                behavior: behavior as u16,
                class: names[class],
                participating_profiles: profile_indices[class].len() as u32,
                coefficient_states,
                valid_profiles,
                invalid_profiles,
                non_progression_profiles,
                distinct_progressions: progressions.len() as u16,
                progressions: progressions.into_iter().collect(),
            });
        }
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            matched_pair_cache: matched.report,
            behavior_classes: behavior_tables.len() as u16,
            participating_profiles,
            cells,
            all_valid_supports_are_progressions: all_progressions,
            provenance: "complete cross-interface marginal q87 census over every profile endpoint in the sealed q29 matched-pair cache and every exact compiled source behavior; complement fibres are unioned, empty supports are necessary exclusions, and progression claims are checked bit-for-bit rather than inferred from endpoints",
        },
    )?;
    println!();
    Ok(())
}
