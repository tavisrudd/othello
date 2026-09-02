use anyhow::{anyhow, ensure, Result};
use clap::Args as ClapArgs;
use ergodis_private::g41_q29_evolve::{
    replay_g41_q29_selection, G41Q29Selection, G41Q29SelectionReplayReport,
};
use ergodis_private::g41_q29_exact_tablebase::{
    compile_g41_q29_aggregate_block_tablebase, lift_g41_q29_exact_block_profile,
    G41Q29BlockProfileLiftReport, G41Q29ExactProfile,
};
use serde::Serialize;

const ROOT_ID: u32 = 3_494_740;
const MASKS: [u8; 4] = [20, 13, 21, 13];
const DIGITS: [u32; 4] = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
const PROFILE_INDICES: [u32; 4] = [79_074, 20_395, 329, 567_565];

#[derive(ClapArgs)]
pub struct Arguments {
    #[arg(long, default_value_t = ROOT_ID)]
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
    lifts: Vec<G41Q29BlockProfileLiftReport>,
    replay: G41Q29SelectionReplayReport,
    provenance: &'static str,
}

pub fn run(args: Arguments) -> Result<()> {
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
    let mut lifts = Vec::with_capacity(4);
    let mut orbit_masks = [0_u16; 24];
    for block in 0..4 {
        let lift = lift_g41_q29_exact_block_profile(masks[block], digits[block], targets[block])?
            .ok_or_else(|| {
            anyhow!("exact block membership did not reconstruct a profile state")
        })?;
        orbit_masks[block * 6..(block + 1) * 6].copy_from_slice(&lift.orbit_masks);
        lifts.push(lift);
    }
    let selection = G41Q29Selection {
        root_id: args.root_id,
        digits,
        orbit_masks,
    };
    let replay = replay_g41_q29_selection(selection)?;
    let replayed_profiles: [[u16; 7]; 4] = std::array::from_fn(|block| lifts[block].target_profile);
    if replay.q29_block_defects != replayed_profiles || replay.q29_residual != 0 {
        return Err(anyhow!(
            "lifted orbit masks failed exact q29 profile replay"
        ));
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            lifts,
            replay,
            provenance: "exact aggregate-profile hit lifted through the first matching sealed quotient interface; each block reconstructs concrete fine-orbit masks, then an independent word-level replay checks row sums and all 521 nonzero PAF equations",
        },
    )?;
    println!();
    Ok(())
}
