use std::fs::File;
use std::path::PathBuf;

use anyhow::{Context, Result};
use clap::Args as ClapArgs;
use ergodis_private::g41_q174_joint::{
    compile_g41_q174_target_fibres, g41_q174_joint_profile, translate_g41_q174_block_spec,
    G41Q174JointProfile, G41Q174TranslationAction,
};
use serde::{Deserialize, Serialize};

const MAXIMUM_TARGET_STATES: usize = 1 << 22;

#[derive(ClapArgs)]
pub struct Arguments {
    input: PathBuf,
    block: usize,
    #[arg(long)]
    translation_control: bool,
}

#[derive(Deserialize)]
struct Input {
    masks: [u8; 4],
    digits: [u32; 4],
    q29_coefficients: [[u8; 8]; 4],
    target_fibres: [TargetFibre; 4],
}

#[derive(Deserialize)]
struct TargetFibre {
    states_by_target: Vec<Vec<u128>>,
}

#[derive(Serialize)]
struct Report {
    block: u8,
    source_targets: u16,
    slot_states: [u32; 6],
    left_slots: [u8; 3],
    right_slots: [u8; 3],
    left_states: u32,
    right_states: u32,
    exact_state_fibres_match: bool,
    pairs_visited: u64,
    q87_target_pairs: u64,
    q87_cache_hits: u64,
    q87_cache_misses: u64,
    q87_cache_entries: u32,
    q58_cache_hits: u64,
    q58_cache_misses: u64,
    q58_cache_collisions: u64,
    matching_pairs: u64,
    unique_states: u64,
    canonical_components: u64,
    workspace_bytes: u64,
    translation_control: bool,
    translation_proof_commitment: Option<[u8; 32]>,
    provenance: &'static str,
}

pub fn run(args: Arguments) -> Result<()> {
    anyhow::ensure!(args.block < 4, "block must be in 0..4");
    let input: Input = serde_json::from_reader(
        File::open(&args.input).with_context(|| format!("open {}", args.input.display()))?,
    )?;
    let mut expected = Vec::<(G41Q174JointProfile, Vec<u128>)>::new();
    for states in &input.target_fibres[args.block].states_by_target {
        let Some(&first) = states.first() else {
            continue;
        };
        let profile = g41_q174_joint_profile(first)?;
        for &state in &states[1..] {
            anyhow::ensure!(
                g41_q174_joint_profile(state)? == profile,
                "presentation fibre mixes exact broad profiles"
            );
        }
        let mut states = states.clone();
        states.sort_unstable();
        states.dedup();
        expected.push((profile, states));
    }
    expected.sort_unstable_by_key(|entry| entry.0);
    anyhow::ensure!(
        expected.windows(2).all(|pair| pair[0].0 < pair[1].0),
        "presentation repeats a target profile"
    );
    let mut targets = Vec::with_capacity(expected.len());
    for &(profile, _) in &expected {
        targets.push(profile);
    }
    let (mask, digits) = if args.translation_control {
        translate_g41_q174_block_spec(input.masks[args.block], input.digits[args.block])?
    } else {
        (input.masks[args.block], input.digits[args.block])
    };
    let mut replay = compile_g41_q174_target_fibres(
        mask,
        digits,
        input.q29_coefficients[args.block],
        &targets,
        MAXIMUM_TARGET_STATES,
    )?;
    let translation = args
        .translation_control
        .then(G41Q174TranslationAction::compile)
        .transpose()?;
    if let Some(action) = &translation {
        for fibre in &mut replay.states_by_target {
            for state in fibre.iter_mut() {
                *state = action.translate(*state)?;
            }
            fibre.sort_unstable();
        }
    }
    let exact_state_fibres_match = replay.states_by_target.len() == expected.len()
        && replay
            .states_by_target
            .iter()
            .zip(&expected)
            .all(|(actual, (_, expected))| actual.as_ref() == expected);
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            block: args.block as u8,
            source_targets: targets.len() as u16,
            slot_states: replay.slot_states,
            left_slots: replay.left_slots,
            right_slots: replay.right_slots,
            left_states: replay.left_states,
            right_states: replay.right_states,
            exact_state_fibres_match,
            pairs_visited: replay.pairs_visited,
            q87_target_pairs: replay.q87_target_pairs,
            q87_cache_hits: replay.q87_cache_hits,
            q87_cache_misses: replay.q87_cache_misses,
            q87_cache_entries: replay.q87_cache_entries,
            q58_cache_hits: replay.q58_cache_hits,
            q58_cache_misses: replay.q58_cache_misses,
            q58_cache_collisions: replay.q58_cache_collisions,
            matching_pairs: replay.matching_pairs,
            unique_states: replay.unique_states,
            canonical_components: replay.canonical_components,
            workspace_bytes: replay.workspace_bytes,
            translation_control: args.translation_control,
            translation_proof_commitment: translation.map(|action| action.proof.proof_commitment),
            provenance: "exact single-block benchmark replay; target profiles are independently re-extracted and equality-checked across every state in each presentation fibre before invoking the source-parameter-bound compiler; in translation-control mode the source specification is translated independently, every regenerated packed q174 state is transported back through the sealed lane permutation, and the sorted state sets are compared exactly with the presentation sets",
        },
    )?;
    println!();
    Ok(())
}
