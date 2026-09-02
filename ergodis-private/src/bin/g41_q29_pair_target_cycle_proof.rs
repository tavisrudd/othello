use std::{fs::File, path::PathBuf};

use anyhow::{ensure, Result};
use clap::Parser;
use ergodis_private::g41_q29_pair_target_cycle::synthesize_g41_q29_coset_cycle;
use ergodis_private::mask_cycle_proof::synthesize_complement_cycle_proof;
use serde::{Deserialize, Serialize};

#[derive(Parser)]
struct Args {
    #[arg(long)]
    scopes: PathBuf,
}

#[derive(Deserialize)]
struct Scope {
    coordinate_mask: u8,
    shared_states: u32,
}

#[derive(Deserialize)]
struct Input {
    source_digest: [u8; 32],
    arity: u8,
    all_scopes: Vec<Scope>,
}

#[derive(Serialize)]
struct Report {
    source_digest: [u8; 32],
    proof: ergodis_private::mask_cycle_proof::ComplementCycleProof,
    coset_action: ergodis_private::g41_q29_pair_target_cycle::G41Q29CosetCycleProof,
    authority: &'static str,
    provenance: &'static str,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let input: Input = serde_json::from_reader(File::open(args.scopes)?)?;
    ensure!(input.arity == 5 && input.all_scopes.len() == 21);
    let masks: Vec<u16> = input
        .all_scopes
        .iter()
        .filter_map(|scope| (scope.shared_states == 0).then_some(u16::from(scope.coordinate_mask)))
        .collect();
    let proof = synthesize_complement_cycle_proof(7, &masks)?;
    let coset_action = synthesize_g41_q29_coset_cycle(&proof)?;
    println!(
        "{}",
        serde_json::to_string(&Report {
            source_digest: input.source_digest,
            proof,
            coset_action,
            authority: "structural authority covers only the cycle shape of the exact evaluator's positive mask set; q29 support disjointness remains bound to independent cache replay",
            provenance: "generic evolve-to-proof conversion from exact successful masks to a compact verified complement-cycle theorem; no q29 coordinate labels or expected cycle are supplied to the synthesizer",
        })?
    );
    Ok(())
}
