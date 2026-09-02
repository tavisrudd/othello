use std::fs::File;
use std::path::PathBuf;

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_q174_joint::{g41_q174_q87_energy, probe_g41_q174_q87_energy_bounds};
use serde::Deserialize;
use serde_json::json;

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
    let reports = (0..4)
        .map(|block| {
            let mut energies = Vec::new();
            for fibre in &input.target_fibres[block].states_by_target {
                let state = *fibre.first().context("target profile fibre is empty")?;
                let energy = g41_q174_q87_energy(state)?;
                ensure!(
                    fibre
                        .iter()
                        .all(|&candidate| g41_q174_q87_energy(candidate) == Ok(energy)),
                    "target fibre mixes q87 energies"
                );
                energies.push(energy);
            }
            Ok(probe_g41_q174_q87_energy_bounds(
                input.masks[block],
                input.digits[block],
                input.q29_coefficients[block],
                &energies,
            )?)
        })
        .collect::<Result<Vec<_>>>()?;
    serde_json::to_writer_pretty(
        std::io::stdout(),
        &json!({
            "reports": reports,
            "input_role": "candidate presentation only; target energies are independently recomputed from every listed packed state",
        }),
    )?;
    println!();
    Ok(())
}
