use anyhow::Result;
use ergodis_private::g41_q174_grouped_join::scan_g41_q174_grouped_join;
use ergodis_private::g41_q174_joint::{
    compile_g41_q174_joint_tablebase, compile_g41_q174_target_fibres, G41Q174JointProfile,
    G41Q174TargetFibreReport,
};
use ergodis_private::g41_q58_gram_masks::{
    propose_q29_fourier_gram_witnesses, G41Q58DenseGramPredicate,
};
use serde::Serialize;

const MASKS_B5: [u8; 4] = [20, 13, 21, 13];
const DIGITS_B5: [u32; 4] = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
const COEFFICIENTS_B5: [[u8; 8]; 4] = [
    [8, 9, 7, 10, 9, 5, 11, 12],
    [5, 8, 12, 10, 10, 8, 9, 7],
    [9, 9, 9, 9, 10, 9, 10, 7],
    [5, 10, 8, 5, 9, 12, 14, 6],
];
const MASKS_B1: [u8; 4] = [20, 1, 21, 1];
const DIGITS_B1: [u32; 4] = [2_215_340, 2_203_361, 1_957_347, 2_218_467];
const COEFFICIENTS_B1: [[u8; 8]; 4] = [
    [8, 8, 10, 10, 9, 8, 10, 8],
    [1, 12, 6, 10, 7, 9, 11, 10],
    [9, 9, 9, 9, 10, 7, 10, 9],
    [1, 5, 15, 9, 10, 8, 9, 9],
];
const SCALES: [i16; 9] = [2, 3, 4, 6, 8, 12, 16, 24, 32];
const MAXIMUM_LAYER_ENTRIES: u64 = 50_000_000;
const MAXIMUM_FIBRE_PAIR_ENTRIES: usize = 1_000_000;
const MAXIMUM_MATCHES: usize = 256;
const MAXIMUM_TARGET_STATES: usize = 1 << 22;

#[derive(Serialize)]
struct Report {
    masks: [u8; 4],
    digits: [u32; 4],
    q29_coefficients: [[u8; 8]; 4],
    sampled_profile_ids: Vec<[u32; 4]>,
    target_indices: Vec<[u8; 4]>,
    target_fibres: [G41Q174TargetFibreReport; 4],
    provenance: &'static str,
}

fn predicates() -> Result<Vec<G41Q58DenseGramPredicate>> {
    let mut predicates = propose_q29_fourier_gram_witnesses(&SCALES)
        .into_iter()
        .map(|source| source.compile())
        .collect::<Result<Vec<_>, _>>()?;
    predicates.sort_unstable();
    predicates.dedup();
    Ok(predicates)
}

fn main() -> Result<()> {
    let middle_small = match std::env::args().nth(1).as_deref().unwrap_or("5") {
        "1" => true,
        "5" => false,
        _ => anyhow::bail!("middle-small must be 1 or 5"),
    };
    let (masks, digits, coefficients) = if middle_small {
        (MASKS_B1, DIGITS_B1, COEFFICIENTS_B1)
    } else {
        (MASKS_B5, DIGITS_B5, COEFFICIENTS_B5)
    };
    let tables = [
        compile_g41_q174_joint_tablebase(masks[0], digits[0], coefficients[0])?,
        compile_g41_q174_joint_tablebase(masks[1], digits[1], coefficients[1])?,
        compile_g41_q174_joint_tablebase(masks[2], digits[2], coefficients[2])?,
        compile_g41_q174_joint_tablebase(masks[3], digits[3], coefficients[3])?,
    ];
    let predicates = predicates()?;
    let join = scan_g41_q174_grouped_join(
        [
            &tables[0].profiles,
            &tables[1].profiles,
            &tables[2].profiles,
            &tables[3].profiles,
        ],
        &predicates,
        MAXIMUM_LAYER_ENTRIES,
        MAXIMUM_FIBRE_PAIR_ENTRIES,
        MAXIMUM_MATCHES,
    )?;
    let sampled_profile_ids: Vec<[u32; 4]> = join
        .sampled_matches
        .iter()
        .map(|matched| matched.profile_ids)
        .collect();
    let mut targets: [Vec<G41Q174JointProfile>; 4] = std::array::from_fn(|block| {
        sampled_profile_ids
            .iter()
            .map(|ids| tables[block].profiles[ids[block] as usize])
            .collect()
    });
    for block_targets in &mut targets {
        block_targets.sort_unstable();
        block_targets.dedup();
    }
    let target_indices: Vec<[u8; 4]> = sampled_profile_ids
        .iter()
        .map(|ids| {
            std::array::from_fn(|block| {
                targets[block]
                    .binary_search(&tables[block].profiles[ids[block] as usize])
                    .expect("sampled profile disappeared from its target set") as u8
            })
        })
        .collect();
    drop(join);
    drop(tables);
    let target_fibres: [G41Q174TargetFibreReport; 4] = (0..4)
        .map(|block| {
            compile_g41_q174_target_fibres(
                masks[block],
                digits[block],
                coefficients[block],
                &targets[block],
                MAXIMUM_TARGET_STATES,
            )
        })
        .collect::<Result<Vec<_>, _>>()?
        .try_into()
        .map_err(|_| anyhow::anyhow!("target block count changed"))?;
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            masks,
            digits,
            q29_coefficients: coefficients,
            sampled_profile_ids,
            target_indices,
            target_fibres,
            provenance: "discovery-only second-stage lift of every packed q174 state behind all representative matches of the current scoped interface; target profile identities are rebound by exact value before the first tablebases are dropped; no failed representative excludes its profile fibre",
        },
    )?;
    println!();
    Ok(())
}
