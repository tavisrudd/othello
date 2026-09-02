use std::collections::BTreeSet;
use std::fs::File;
use std::path::PathBuf;
use std::sync::atomic::{AtomicUsize, Ordering};

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_exact_tablebase::{
    canonical_g41_q29_block_spec, compile_g41_q29_aggregate_block_tablebase,
    compile_g41_q29_fixed_zero_defect_tablebase, g41_q29_degree_sequence_decomposition_feasible,
    g41_q29_slot_aggregate_signature,
};
use serde::{Deserialize, Serialize};

#[derive(Parser)]
struct Args {
    #[arg(long)]
    witness_cache: PathBuf,
    #[arg(long)]
    participation: PathBuf,
    #[arg(long, default_value_t = 4)]
    threads: usize,
}

#[derive(Deserialize)]
struct Participation {
    source_profiles: [u32; 4],
    source_profile_digests: [[u8; 32]; 4],
    participating_profile_indices: Option<[Vec<u32>; 4]>,
}

#[derive(Clone, Copy, Serialize)]
struct ClassReport {
    class: &'static str,
    participating_profiles: u32,
    participating_coefficient_states: u32,
    canonical_block_specs: u32,
    distinct_digit_vectors: u32,
    raw_spec_replays: u64,
    grouped_decompositions: u64,
    degree_feasible_decompositions: u64,
}

#[derive(Serialize)]
struct Report {
    classes: [ClassReport; 4],
    raw_spec_replays: u64,
    grouped_decompositions: u64,
    degree_feasible_decompositions: u64,
    degree_infeasible_samples: Vec<DegreeInfeasibleSample>,
    maximum_resident_decompositions_when_streamed: u8,
    decomposition_bytes: u8,
    authority: &'static str,
    provenance: &'static str,
}

#[derive(Clone, Copy, Serialize)]
struct DegreeInfeasibleSample {
    class: &'static str,
    digits: u32,
    coefficient_values: [u8; 8],
}

fn class_for_signature(signature: [u8; 4]) -> Result<usize> {
    match signature[0] {
        8 => Ok(0),
        1 => Ok(1),
        5 => Ok(2),
        9 => Ok(3),
        _ => anyhow::bail!("canonical block has an unexpected fixed-zero class"),
    }
}

fn checked_product(left: u32, right: usize) -> Result<u64> {
    u64::from(left)
        .checked_mul(right as u64)
        .context("work-model product overflow")
}

fn main() -> Result<()> {
    let args = Args::parse();
    ensure!((1..=16).contains(&args.threads));
    let participation: Participation = serde_json::from_reader(File::open(args.participation)?)?;
    let indices = participation
        .participating_profile_indices
        .context("participation artifact omitted exact profile indices")?;
    let signatures = [
        [8, 3, 15, 15],
        [1, 9, 14, 14],
        [5, 8, 14, 14],
        [9, 7, 14, 14],
    ];
    let rows = [260_u16, 261, 261, 261];
    let zeros = [8_u8, 1, 5, 9];
    let mut coefficient_values: [Vec<[u8; 8]>; 4] = std::array::from_fn(|_| Vec::new());
    for class in 0..4 {
        let aggregate = compile_g41_q29_aggregate_block_tablebase(signatures[class])?;
        ensure!(aggregate.profiles.len() as u32 == participation.source_profiles[class]);
        ensure!(aggregate.report.profile_digest == participation.source_profile_digests[class]);
        let fixed = compile_g41_q29_fixed_zero_defect_tablebase(rows[class], zeros[class])?;
        for &index in &indices[class] {
            let profile = *aggregate
                .profiles
                .get(index as usize)
                .context("participating profile index is outside its bound table")?;
            let fibre = fixed.coefficient_fibre(profile)?;
            ensure!(fibre.len != 0);
            coefficient_values[class]
                .extend_from_slice(&fibre.coefficient_values[..usize::from(fibre.len)]);
        }
    }

    let source = read_g41_digit_witness_cache(File::open(args.witness_cache)?)?;
    let mut specs: [BTreeSet<(u8, u32)>; 4] = std::array::from_fn(|_| BTreeSet::new());
    for witness in &source.witnesses {
        for block in 0..4 {
            let (mask, digits, _) =
                canonical_g41_q29_block_spec(witness.masks[block], witness.digits[block])?;
            let class = class_for_signature(g41_q29_slot_aggregate_signature(mask, digits)?)?;
            specs[class].insert((mask, digits));
        }
    }
    let digits: [BTreeSet<u32>; 4] =
        std::array::from_fn(|class| specs[class].iter().map(|&(_, digits)| digits).collect());
    let names = ["A", "B1", "B5", "C"];
    let mut classes = [ClassReport {
        class: "",
        participating_profiles: 0,
        participating_coefficient_states: 0,
        canonical_block_specs: 0,
        distinct_digit_vectors: 0,
        raw_spec_replays: 0,
        grouped_decompositions: 0,
        degree_feasible_decompositions: 0,
    }; 4];
    let tasks: Vec<(usize, u32)> = digits
        .iter()
        .enumerate()
        .flat_map(|(class, values)| values.iter().map(move |&digits| (class, digits)))
        .collect();
    let next = AtomicUsize::new(0);
    let degree_counts = std::thread::scope(|scope| -> Result<[u64; 4]> {
        let mut handles = Vec::with_capacity(args.threads);
        for _ in 0..args.threads {
            handles.push(scope.spawn(|| -> Result<[u64; 4]> {
                let mut counts = [0_u64; 4];
                loop {
                    let task = next.fetch_add(1, Ordering::Relaxed);
                    let Some(&(class, digits)) = tasks.get(task) else {
                        break;
                    };
                    for &coefficients in &coefficient_values[class] {
                        counts[class] = counts[class]
                            .checked_add(u64::from(g41_q29_degree_sequence_decomposition_feasible(
                                digits,
                                coefficients,
                            )?))
                            .context("degree-feasible count overflow")?;
                    }
                }
                Ok(counts)
            }));
        }
        let mut merged = [0_u64; 4];
        for handle in handles {
            let counts = handle
                .join()
                .map_err(|_| anyhow::anyhow!("degree worker panicked"))??;
            for class in 0..4 {
                merged[class] = merged[class]
                    .checked_add(counts[class])
                    .context("merged degree-feasible count overflow")?;
            }
        }
        Ok(merged)
    })?;
    for class in 0..4 {
        let coefficient_states = u32::try_from(coefficient_values[class].len())
            .context("coefficient-state count exceeds u32")?;
        classes[class] = ClassReport {
            class: names[class],
            participating_profiles: indices[class].len() as u32,
            participating_coefficient_states: coefficient_states,
            canonical_block_specs: specs[class].len() as u32,
            distinct_digit_vectors: digits[class].len() as u32,
            raw_spec_replays: checked_product(coefficient_states, specs[class].len())?,
            grouped_decompositions: checked_product(coefficient_states, digits[class].len())?,
            degree_feasible_decompositions: degree_counts[class],
        };
    }
    let raw_spec_replays = classes.iter().try_fold(0_u64, |total, class| {
        total
            .checked_add(class.raw_spec_replays)
            .context("raw replay total overflow")
    })?;
    let grouped_decompositions = classes.iter().try_fold(0_u64, |total, class| {
        total
            .checked_add(class.grouped_decompositions)
            .context("grouped decomposition total overflow")
    })?;
    let degree_feasible_decompositions = classes.iter().try_fold(0_u64, |total, class| {
        total
            .checked_add(class.degree_feasible_decompositions)
            .context("degree-feasible total overflow")
    })?;
    let mut degree_infeasible_samples = Vec::with_capacity(16);
    let degree_infeasible_total = grouped_decompositions
        .checked_sub(degree_feasible_decompositions)
        .context("degree-feasible count exceeds grouped domain")?;
    ensure!(degree_infeasible_total <= 16);
    'classes: for class in 0..4 {
        for &digits in &digits[class] {
            for &coefficients in &coefficient_values[class] {
                if !g41_q29_degree_sequence_decomposition_feasible(digits, coefficients)? {
                    ensure!(degree_infeasible_samples.len() < 16);
                    degree_infeasible_samples.push(DegreeInfeasibleSample {
                        class: names[class],
                        digits,
                        coefficient_values: coefficients,
                    });
                    if degree_infeasible_samples.len() as u64 == degree_infeasible_total {
                        break 'classes;
                    }
                }
            }
        }
    }
    ensure!(degree_infeasible_samples.len() as u64 == degree_infeasible_total);
    println!(
        "{}",
        serde_json::to_string_pretty(&Report {
            classes,
            raw_spec_replays,
            grouped_decompositions,
            degree_feasible_decompositions,
            degree_infeasible_samples,
            maximum_resident_decompositions_when_streamed: 1,
            decomposition_bytes: 48,
            authority: "cost model only; the degree-sequence predicate remains diagnostic and no source interface is excluded",
            provenance: "sealed participation indices are rebound to exact aggregate profile digests and fixed-zero coefficient fibres; the sealed all-interface witness cache is replayed and canonicalized; work counts compare per-spec replay, grouped mask-independent decomposition keys, and the structural capacitated Gale-Ryser feasibility predicate",
        })?
    );
    Ok(())
}
