use std::{fs, path::PathBuf};

use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::binary_margin_lift::{
    construct_q18_q29_binary_margin_lift, Q18Q29ConstructWorkspace, Q18Q29Margins,
};
use ergodis_private::q18_pair_split::{
    verify_q18_gs_reduction, Q18Coefficients, Q18DivisorProjection, Q18PairSplit,
};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

const BLOCKS: usize = 4;
const CARRIER: usize = 522;

#[derive(Deserialize)]
struct Q29Input {
    best_q29: [[i8; 29]; BLOCKS],
}

#[derive(Serialize)]
struct BridgeReport {
    q18_source_commitment: [u8; 32],
    q29_source_commitment: [u8; 32],
    q18_exact: bool,
    q29_exact: bool,
    compatible_blocks: [bool; BLOCKS],
    canonical_matrices: [[u32; 18]; BLOCKS],
    canonical_row_sums: [i32; BLOCKS],
    canonical_full_paf_score: u64,
    canonical_exact: bool,
    provenance: &'static str,
}

#[derive(ClapArgs)]
pub struct Arguments {
    q18: PathBuf,
    q29: PathBuf,
}

pub fn run(arguments: Arguments) -> Result<()> {
    let q18_path = arguments.q18;
    let q29_path = arguments.q29;
    let q18_bytes = fs::read(q18_path).expect("read q18 source");
    let q29_bytes = fs::read(q29_path).expect("read q29 source");
    let q18_rows: [[i8; 18]; BLOCKS] = serde_json::from_slice(&q18_bytes).expect("parse q18");
    let q29: Q29Input = serde_json::from_slice(&q29_bytes).expect("parse q29");

    let q18 = Q18Coefficients { blocks: q18_rows };
    let mut split = Q18PairSplit::ZERO;
    let mut projection = Q18DivisorProjection::ZERO;
    let q18_exact = verify_q18_gs_reduction(&q18, &mut split, &mut projection).is_ok();
    let q29_exact = replay_q29(&q29.best_q29);

    let mut compatible_blocks = [false; BLOCKS];
    let mut canonical_matrices = [[0_u32; 18]; BLOCKS];
    for block in 0..BLOCKS {
        let margins = Q18Q29Margins::new(q18_rows[block], q29.best_q29[block]);
        let mut workspace = Q18Q29ConstructWorkspace::ZERO;
        if let Some(matrix) = construct_q18_q29_binary_margin_lift(&margins, &mut workspace)
            .expect("canonical signed margin semantics")
        {
            compatible_blocks[block] = true;
            canonical_matrices[block] = matrix;
        }
    }
    let (canonical_row_sums, canonical_full_paf_score, canonical_exact) = replay_full(
        &canonical_matrices,
        compatible_blocks.iter().all(|&value| value),
    );
    let report = BridgeReport {
        q18_source_commitment: Sha256::digest(&q18_bytes).into(),
        q29_source_commitment: Sha256::digest(&q29_bytes).into(),
        q18_exact,
        q29_exact,
        compatible_blocks,
        canonical_matrices,
        canonical_row_sums,
        canonical_full_paf_score,
        canonical_exact,
        provenance: "q18=directly replayed exact computational; q29=directly replayed observed/evolved input; margin construction=proved Gale-Ryser/Havel-Hakimi; canonical full-length candidate=direct original-space replay; compatibility grants no PAF pruning authority",
    };
    println!(
        "{}",
        serde_json::to_string_pretty(&report).expect("serialize report")
    );
    Ok(())
}

fn replay_q29(rows: &[[i8; 29]; BLOCKS]) -> bool {
    (0..15).all(|shift| {
        let correlation = rows
            .iter()
            .map(|row| {
                (0..29)
                    .map(|point| i32::from(row[point]) * i32::from(row[(point + shift) % 29]))
                    .sum::<i32>()
            })
            .sum::<i32>();
        correlation == if shift == 0 { 2_020 } else { -72 }
    })
}

fn replay_full(matrices: &[[u32; 18]; BLOCKS], compatible: bool) -> ([i32; BLOCKS], u64, bool) {
    if !compatible {
        return ([0; BLOCKS], u64::MAX, false);
    }
    let sequences: [[i8; CARRIER]; BLOCKS] = std::array::from_fn(|block| {
        std::array::from_fn(|point| {
            let row = point % 18;
            let column = point % 29;
            if matrices[block][row] & (1_u32 << column) == 0 {
                -1
            } else {
                1
            }
        })
    });
    let row_sums = sequences.map(|row| row.iter().map(|&value| i32::from(value)).sum());
    let mut score = 0_u64;
    for shift in 1..CARRIER {
        let correlation = sequences
            .iter()
            .map(|row| {
                (0..CARRIER)
                    .map(|point| i32::from(row[point]) * i32::from(row[(point + shift) % CARRIER]))
                    .sum::<i32>()
            })
            .sum::<i32>();
        score = score.saturating_add((correlation + 4).unsigned_abs().pow(2) as u64);
    }
    let exact = row_sums == [2, 0, 0, 0] && score == 0;
    (row_sums, score, exact)
}
