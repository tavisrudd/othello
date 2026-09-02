use std::fs::File;
use std::path::PathBuf;

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_q174_joint::G41Q174SourceFeasibilityWorkspace;
use serde::Deserialize;
use serde_json::json;
use sha2::{Digest, Sha256};

#[derive(Parser)]
struct Args {
    input: PathBuf,
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

fn main() -> Result<()> {
    let args = Args::parse();
    let input: Input = serde_json::from_reader(
        File::open(&args.input).with_context(|| format!("open {}", args.input.display()))?,
    )?;
    let mut checked = [0_u64; 4];
    let mut feasible = [0_u64; 4];
    let mut workspace_bytes = [0_u64; 4];
    let mut digest = Sha256::new();
    for block in 0..4 {
        let mut workspace =
            G41Q174SourceFeasibilityWorkspace::new(input.masks[block], input.digits[block])?;
        workspace_bytes[block] = workspace.workspace_bytes();
        for fibre in &input.target_fibres[block].states_by_target {
            for &state in fibre {
                checked[block] += 1;
                let source_feasible = workspace.check(input.q29_coefficients[block], state)?;
                feasible[block] += u64::from(source_feasible);
                digest.update((block as u8).to_le_bytes());
                digest.update(state.to_le_bytes());
                digest.update([source_feasible as u8]);
            }
        }
        ensure!(
            checked[block] == feasible[block],
            "sealed target fibre contained an infeasible state"
        );
    }
    serde_json::to_writer_pretty(
        std::io::stdout(),
        &json!({
            "checked_states": checked,
            "feasible_states": feasible,
            "workspace_bytes": workspace_bytes,
            "result_digest": <[u8; 32]>::from(digest.finalize()),
            "provenance": "independent replay of every packed state in a sealed target-fibre artifact through the structural q174 source-membership DP; the JSON presentation supplies candidates only and cannot authorize absence",
        }),
    )?;
    println!();
    Ok(())
}
