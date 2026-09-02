use std::fs::File;
use std::path::PathBuf;

use anyhow::{ensure, Result};
use clap::Parser;
use ergodis_private::g41_q174_joint::probe_g41_q174_source_projection_batch;
use ergodis_private::g41_q29_exact_tablebase::{
    compile_g41_q29_aggregate_block_tablebase, compile_g41_q29_fixed_zero_defect_tablebase,
    G41Q29AggregateBlockTablebase,
};
use ergodis_private::g41_q29_matched_pair_cache::read_g41_q29_matched_pair_cache;
use ergodis_private::g41_q29_pair_target_cache::{
    read_g41_q29_pair_target_cache, verify_g41_q29_pair_target_source,
    G41Q29PairTargetSourceBinding,
};

#[derive(Parser)]
struct Args {
    #[arg(long)]
    target_cache: PathBuf,
    #[arg(long)]
    matched_pair_cache: PathBuf,
    #[arg(long)]
    class: usize,
    #[arg(long)]
    mask: u8,
    #[arg(long)]
    digits: u32,
}

fn source_binding(tables: &[G41Q29AggregateBlockTablebase; 4]) -> G41Q29PairTargetSourceBinding {
    G41Q29PairTargetSourceBinding {
        signatures: tables.each_ref().map(|table| table.report.signature),
        profile_counts: tables.each_ref().map(|table| table.profiles.len() as u32),
        profile_digests: tables.each_ref().map(|table| table.report.profile_digest),
    }
}

fn main() -> Result<()> {
    let args = Args::parse();
    ensure!(args.class < 4);
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
    let fixed = [
        compile_g41_q29_fixed_zero_defect_tablebase(260, 8)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 1)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 5)?,
        compile_g41_q29_fixed_zero_defect_tablebase(261, 9)?,
    ];
    let mut profile_indices = Vec::new();
    for record in matched.records.iter() {
        match args.class {
            0 if record.side == 0 => profile_indices.push(record.first),
            3 if record.side == 0 => profile_indices.push(record.second),
            1 | 2 if record.side == 1 && record.archetype_bits == 1_u8 << (args.class - 1) => {
                profile_indices.push(record.first);
                profile_indices.push(record.second);
            }
            _ => {}
        }
    }
    profile_indices.sort_unstable();
    profile_indices.dedup();
    let mut coefficients = Vec::with_capacity(profile_indices.len() * 2);
    for index in profile_indices {
        let profile = aggregate[args.class].profiles[index as usize];
        let fibre = fixed[args.class].coefficient_fibre(profile)?;
        coefficients.extend_from_slice(&fibre.coefficient_values[..usize::from(fibre.len)]);
    }
    coefficients.sort_unstable();
    coefficients.dedup();
    let report = probe_g41_q174_source_projection_batch(args.mask, args.digits, &coefficients)?;
    serde_json::to_writer(std::io::stdout(), &report)?;
    println!();
    Ok(())
}
