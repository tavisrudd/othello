use anyhow::{anyhow, ensure, Result};
use clap::Parser;
use ergodis_private::g41_q29_exact_tablebase::{
    compile_g41_q29_aggregate_block_tablebase, compile_g41_q29_exact_block_tablebase,
    G41Q29ExactProfile,
};
use serde::Serialize;

const MASKS: [u8; 4] = [20, 13, 21, 13];
const DIGITS: [u32; 4] = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
const PROFILE_INDICES: [u32; 4] = [79_074, 20_395, 329, 567_565];

#[derive(Parser)]
struct Args {
    #[arg(long, default_value_t = 3_494_740)]
    root_id: u32,
    #[arg(long, default_value_t = 5)]
    middle_small: u8,
    #[arg(long, value_delimiter = ',', num_args = 4)]
    masks: Vec<u8>,
    #[arg(long, value_delimiter = ',', num_args = 4)]
    digits: Vec<u32>,
    #[arg(long, value_delimiter = ',', num_args = 4)]
    profile_indices: Vec<u32>,
}

#[derive(Serialize)]
struct Report {
    root_id: u32,
    masks: [u8; 4],
    digits: [u32; 4],
    target_profiles: [[u16; 7]; 4],
    exact_profile_counts: [u32; 4],
    exact_membership: [bool; 4],
    provenance: &'static str,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let masks: [u8; 4] = if args.masks.is_empty() {
        MASKS
    } else {
        args.masks
            .try_into()
            .map_err(|_| anyhow!("masks requires four values"))?
    };
    let digits: [u32; 4] = if args.digits.is_empty() {
        DIGITS
    } else {
        args.digits
            .try_into()
            .map_err(|_| anyhow!("digits requires four values"))?
    };
    let profile_indices: [u32; 4] = if args.profile_indices.is_empty() {
        PROFILE_INDICES
    } else {
        args.profile_indices
            .try_into()
            .map_err(|_| anyhow!("profile-indices requires four values"))?
    };
    let a = compile_g41_q29_aggregate_block_tablebase([8, 3, 15, 15])?;
    let middle_signature = match args.middle_small {
        1 => [1, 9, 14, 14],
        5 => [5, 8, 14, 14],
        _ => anyhow::bail!("middle-small must be 1 or 5"),
    };
    let b = compile_g41_q29_aggregate_block_tablebase(middle_signature)?;
    let c = compile_g41_q29_aggregate_block_tablebase([9, 7, 14, 14])?;
    let aggregate = [
        &a.profiles[..],
        &b.profiles[..],
        &c.profiles[..],
        &b.profiles[..],
    ];
    ensure!((0..4).all(|block| (profile_indices[block] as usize) < aggregate[block].len()));
    let targets: [G41Q29ExactProfile; 4] =
        std::array::from_fn(|block| aggregate[block][profile_indices[block] as usize]);
    let target_profiles = std::array::from_fn(|block| {
        std::array::from_fn(|coordinate| targets[block].coordinate(coordinate))
    });
    let mut exact_profile_counts = [0_u32; 4];
    let mut exact_membership = [false; 4];
    for block in 0..4 {
        let table = compile_g41_q29_exact_block_tablebase(masks[block], digits[block])?;
        exact_profile_counts[block] = table.report.exact_correlation_profiles;
        exact_membership[block] = table.profiles.binary_search(&targets[block]).is_ok();
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            root_id: args.root_id,
            masks,
            digits,
            target_profiles,
            exact_profile_counts,
            exact_membership,
            provenance: "exact membership replay of the aggregate q29 hit against the first sealed-cache A+B5+C+B5 raw block interface; membership is block-local only until orbit masks are reconstructed and all original PAF equations replay",
        },
    )?;
    println!();
    Ok(())
}
