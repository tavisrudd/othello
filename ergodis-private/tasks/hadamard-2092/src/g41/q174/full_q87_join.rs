use std::fs;
use std::path::PathBuf;

use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::g41_q174_full_q87_join::{
    search_g41_q174_full_q87_join, G41Q174FullQ87JoinReport,
};
use ergodis_private::g41_q174_joint::{
    find_g41_q174_allocation_witness, G41Q174AllocationWitnessReport,
};
use ergodis_private::g41_q58_exact_tablebase::{
    replay_g41_q58_allocations_original, G41Q58AllocationWitnessReport, G41Q58OriginalReplayReport,
};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

const MAXIMUM_PAIR_ENTRIES: usize = 1 << 20;

#[derive(Serialize)]
struct CandidateReplay {
    match_index: u8,
    allocation_witnesses: [G41Q174AllocationWitnessReport; 4],
    original_replay: G41Q58OriginalReplayReport,
}

#[derive(Serialize)]
struct Report {
    source_digest: [u8; 32],
    joins: Vec<G41Q174FullQ87JoinReport>,
    candidate_replays: Vec<CandidateReplay>,
    provenance: &'static str,
}

#[derive(Deserialize)]
struct InputBlock {
    states_by_target: Vec<Vec<u128>>,
}

#[derive(Deserialize)]
struct Input {
    masks: [u8; 4],
    digits: [u32; 4],
    target_indices: Vec<[usize; 4]>,
    target_fibres: Vec<InputBlock>,
}

#[derive(ClapArgs)]
pub struct Arguments {
    /// Target-fibre artifact path.
    path: PathBuf,
}

pub fn run(arguments: Arguments) -> Result<()> {
    let path = arguments.path;
    let source = fs::read(path)?;
    let input: Input = serde_json::from_slice(&source)?;
    let masks = input.masks;
    let digits = input.digits;
    let target_indices = input.target_indices;
    let mut states: Vec<Vec<Vec<u128>>> = input
        .target_fibres
        .into_iter()
        .map(|block| block.states_by_target)
        .collect();
    anyhow::ensure!(states.len() == 4, "target-fibre block count changed");
    for block in &mut states {
        for target in block {
            target.sort_unstable();
            target.dedup();
        }
    }
    let mut joins = Vec::with_capacity(target_indices.len());
    let mut candidate_replays = Vec::new();
    for (match_index, indices) in target_indices.iter().enumerate() {
        let join = search_g41_q174_full_q87_join(
            [
                &states[0][indices[0]],
                &states[1][indices[1]],
                &states[2][indices[2]],
                &states[3][indices[3]],
            ],
            MAXIMUM_PAIR_ENTRIES,
        )?;
        if let Some(candidate) = join.first_states {
            let allocation_witnesses: [G41Q174AllocationWitnessReport; 4] =
                std::array::from_fn(|block| {
                    find_g41_q174_allocation_witness(masks[block], digits[block], candidate[block])
                        .expect("full-q87 target state failed independent source allocation")
                });
            let q58_witnesses: [G41Q58AllocationWitnessReport; 4] = std::array::from_fn(|block| {
                G41Q58AllocationWitnessReport {
                    mask: allocation_witnesses[block].mask,
                    digits: allocation_witnesses[block].digits,
                    target_q58_class_coefficients: allocation_witnesses[block]
                        .q58_class_coefficients,
                    states_after_slot: [0; 6],
                    orbit_masks: allocation_witnesses[block].orbit_masks,
                    workspace_bytes: 0,
                    provenance: "full-q87 target state projected exactly to q58 for independent original-row replay",
                }
            });
            candidate_replays.push(CandidateReplay {
                match_index: match_index as u8,
                allocation_witnesses,
                original_replay: replay_g41_q58_allocations_original(&q58_witnesses)?,
            });
        }
        joins.push(join);
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            source_digest: Sha256::digest(source).into(),
            joins,
            candidate_replays,
            provenance: "discovery replay over a presentation-bound target-fibre artifact; every q87 key is independently recomputed from packed q174 states and any positive is reconstructed to source orbit masks and checked against all 521 original shifts; negative authority requires rerunning the sealed target-fibre compiler rather than trusting this JSON presentation",
        },
    )?;
    println!();
    Ok(())
}
