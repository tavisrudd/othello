use std::{fs::File, path::PathBuf};

use anyhow::Result;
use clap::Parser;
use ergodis_private::g41_q29_exact_tablebase::compile_g41_q29_aggregate_block_tablebase;
use ergodis_private::g41_q29_pair_target_cache::{
    read_g41_q29_pair_target_cache, verify_g41_q29_pair_target_source,
    G41Q29PairTargetSourceBinding,
};
use serde::Serialize;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    cache: PathBuf,
}

#[derive(Serialize)]
struct Report {
    cache: ergodis_private::g41_q29_pair_target_cache::G41Q29PairTargetCacheReport,
    b1_targets: u32,
    b5_targets: u32,
    shared_targets: u32,
    provenance: &'static str,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let cache = read_g41_q29_pair_target_cache(File::open(args.cache)?)?;
    let a = compile_g41_q29_aggregate_block_tablebase([8, 3, 15, 15])?;
    let b1 = compile_g41_q29_aggregate_block_tablebase([1, 9, 14, 14])?;
    let b5 = compile_g41_q29_aggregate_block_tablebase([5, 8, 14, 14])?;
    let c = compile_g41_q29_aggregate_block_tablebase([9, 7, 14, 14])?;
    let expected = G41Q29PairTargetSourceBinding {
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
    };
    verify_g41_q29_pair_target_source(&cache, expected)?;
    let mut counts = [0_u32; 3];
    for target in &cache.targets {
        counts[0] += u32::from(target.archetype_bits & 1 != 0);
        counts[1] += u32::from(target.archetype_bits & 2 != 0);
        counts[2] += u32::from(target.archetype_bits == 3);
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            cache: cache.report,
            b1_targets: counts[0],
            b5_targets: counts[1],
            shared_targets: counts[2],
            provenance: "independent cache readback recomputes all four aggregate profile tables and rejects any source signature, count, digest, semantic, order, or payload mismatch; aggregate targets remain discovery-only",
        },
    )?;
    println!();
    Ok(())
}
