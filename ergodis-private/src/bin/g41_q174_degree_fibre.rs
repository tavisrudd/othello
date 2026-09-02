use std::fs::File;
use std::path::PathBuf;

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_q174_degree_fibre::G41Q174DegreeFibreWorkspace;
use serde::Deserialize;
use serde_json::json;

#[derive(Parser)]
struct Args {
    input: PathBuf,
}

#[derive(Deserialize)]
struct Input {
    digits: Vec<u32>,
    q29_coefficients: Vec<[u8; 8]>,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let input: Input = serde_json::from_reader(
        File::open(&args.input).with_context(|| format!("open {}", args.input.display()))?,
    )?;
    ensure!(input.digits.len() == input.q29_coefficients.len());
    let reports = input
        .digits
        .into_iter()
        .zip(input.q29_coefficients)
        .map(|(digits, coefficients)| {
            G41Q174DegreeFibreWorkspace::new(digits)?.census(coefficients)
        })
        .collect::<Result<Vec<_>, _>>()?;
    serde_json::to_writer_pretty(
        std::io::stdout(),
        &json!({
            "reports": reports,
            "authority": "exact structural census and safe q174 source-orientation upper bound; packed-state deduplication and q58/q87 joins remain separate typed stages",
        }),
    )?;
    println!();
    Ok(())
}
