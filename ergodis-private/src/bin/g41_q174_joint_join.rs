use anyhow::{ensure, Result};
use ergodis_private::g41_q174_grouped_join::{
    scan_g41_q174_grouped_join, G41Q174GroupedJoinReport,
};
use ergodis_private::g41_q174_joint::{
    compile_g41_q174_joint_tablebase, find_g41_q174_allocation_witness,
    replay_g41_q174_q87_defects, G41Q174AllocationWitnessReport, G41Q174JointReport,
    G41Q174JointTablebase, G41Q174Q87ReplayReport,
};
use ergodis_private::g41_q58_exact_tablebase::{
    replay_g41_q58_allocations_original, G41Q58AllocationWitnessReport, G41Q58OriginalReplayReport,
};
use ergodis_private::g41_q58_gram_masks::{
    propose_q29_fourier_gram_witnesses, G41Q58DenseGramPredicate,
};
use serde::Serialize;

const MASKS: [u8; 4] = [20, 13, 21, 13];
const DIGITS: [u32; 4] = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
const COEFFICIENTS: [[u8; 8]; 4] = [
    [8, 9, 7, 10, 9, 5, 11, 12],
    [5, 8, 12, 10, 10, 8, 9, 7],
    [9, 9, 9, 9, 10, 9, 10, 7],
    [5, 10, 8, 5, 9, 12, 14, 6],
];
const SCALES: [i16; 9] = [2, 3, 4, 6, 8, 12, 16, 24, 32];
const DEFAULT_MAXIMUM_LAYER_ENTRIES: u64 = 50_000_000;
const DEFAULT_MAXIMUM_FIBRE_PAIR_ENTRIES: usize = 1_000_000;

#[derive(Serialize)]
struct Report {
    blocks: [G41Q174JointReport; 4],
    proposed_fourier_sources: u16,
    exact_dense_predicates: u16,
    join: G41Q174GroupedJoinReport,
    representative_q87_replays: Vec<RepresentativeQ87Replay>,
    allocation_witnesses: Option<[G41Q174AllocationWitnessReport; 4]>,
    original_replay: Option<G41Q58OriginalReplayReport>,
    provenance: &'static str,
}

#[derive(Serialize)]
struct RepresentativeQ87Replay {
    profile_ids: [u32; 4],
    q174_states: [u128; 4],
    replay: G41Q174Q87ReplayReport,
}

fn budgets() -> Result<(u64, usize)> {
    let mut maximum_layer_entries = DEFAULT_MAXIMUM_LAYER_ENTRIES;
    let mut maximum_matches = 1_usize;
    for argument in std::env::args().skip(1) {
        if let Some(value) = argument.strip_prefix("--maximum-layer-entries=") {
            maximum_layer_entries = value.parse()?;
        } else if let Some(value) = argument.strip_prefix("--maximum-matches=") {
            maximum_matches = value.parse()?;
        } else {
            anyhow::bail!("unknown argument {argument}");
        }
    }
    ensure!(
        maximum_layer_entries > 0,
        "maximum layer budget must be positive"
    );
    ensure!(maximum_matches > 0, "maximum match budget must be positive");
    Ok((maximum_layer_entries, maximum_matches))
}

fn compile_tables() -> Result<[G41Q174JointTablebase; 4]> {
    Ok([
        compile_g41_q174_joint_tablebase(MASKS[0], DIGITS[0], COEFFICIENTS[0])?,
        compile_g41_q174_joint_tablebase(MASKS[1], DIGITS[1], COEFFICIENTS[1])?,
        compile_g41_q174_joint_tablebase(MASKS[2], DIGITS[2], COEFFICIENTS[2])?,
        compile_g41_q174_joint_tablebase(MASKS[3], DIGITS[3], COEFFICIENTS[3])?,
    ])
}

fn compile_predicates() -> Result<(usize, Vec<G41Q58DenseGramPredicate>)> {
    let sources = propose_q29_fourier_gram_witnesses(&SCALES);
    let generated = sources.len();
    let mut predicates = sources
        .into_iter()
        .map(|source| source.compile())
        .collect::<Result<Vec<_>, _>>()?;
    predicates.sort_unstable();
    predicates.dedup();
    Ok((generated, predicates))
}

fn main() -> Result<()> {
    let (maximum_layer_entries, maximum_matches) = budgets()?;
    let tables = compile_tables()?;
    let (proposed_fourier_sources, predicates) = compile_predicates()?;
    let join = scan_g41_q174_grouped_join(
        [
            &tables[0].profiles,
            &tables[1].profiles,
            &tables[2].profiles,
            &tables[3].profiles,
        ],
        &predicates,
        maximum_layer_entries,
        DEFAULT_MAXIMUM_FIBRE_PAIR_ENTRIES,
        maximum_matches,
    )?;
    let representative_q87_replays = join
        .sampled_matches
        .iter()
        .map(|matched| {
            let q174_states = std::array::from_fn(|block| {
                tables[block]
                    .representative_state(matched.profile_ids[block] as usize)
                    .expect("q174 join returned an invalid profile ID")
            });
            Ok(RepresentativeQ87Replay {
                profile_ids: matched.profile_ids,
                q174_states,
                replay: replay_g41_q174_q87_defects(q174_states)?,
            })
        })
        .collect::<Result<Vec<_>>>()?;
    let allocation_witnesses = join.first_match.map(|matched| {
        std::array::from_fn(|block| {
            let state = tables[block]
                .representative_state(matched.profile_ids[block] as usize)
                .expect("q174 join returned an invalid profile ID");
            find_g41_q174_allocation_witness(MASKS[block], DIGITS[block], state)
                .expect("stored q174 representative failed independent allocation replay")
        })
    });
    ensure!(
        allocation_witnesses
            .as_ref()
            .is_none_or(|witnesses| witnesses
                .iter()
                .all(|witness| witness.orbit_masks.is_some())),
        "q174 representative failed source allocation replay"
    );
    let original_replay = allocation_witnesses
        .as_ref()
        .map(|witnesses| {
            let q58_witnesses: [G41Q58AllocationWitnessReport; 4] =
                std::array::from_fn(|block| G41Q58AllocationWitnessReport {
                    mask: witnesses[block].mask,
                    digits: witnesses[block].digits,
                    target_q58_class_coefficients: witnesses[block].q58_class_coefficients,
                    states_after_slot: [0; 6],
                    orbit_masks: witnesses[block].orbit_masks,
                    workspace_bytes: 0,
                    provenance: "q174 allocation witness projected exactly to q58 for independent original-row replay",
                });
            replay_g41_q58_allocations_original(&q58_witnesses)
        })
        .transpose()?;
    let blocks = std::array::from_fn(|block| tables[block].report.clone());
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            blocks,
            proposed_fourier_sources: proposed_fourier_sources as u16,
            exact_dense_predicates: predicates.len() as u16,
            join,
            representative_q87_replays,
            allocation_witnesses,
            original_replay,
            provenance: "four exact q174 common-refinement tables; the exact q58 profile is a canonical outer group and q87 energy plus distinct multiplier classes 4,6,33 is its broad fibre; only complementary q58 groups enter the bounded broad join; evolved class 1 is intentionally deferred to the exact target-fibre endgame because including it broadly exceeds the memory-efficient profile budget; a returned representative remains discovery-only until its q174 state is lifted and every original PAF equation replays",
        },
    )?;
    println!();
    Ok(())
}
