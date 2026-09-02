use std::fs;
use std::hint::black_box;
use std::path::PathBuf;

use anyhow::{ensure, Result};
use clap::{Parser, ValueEnum};
use ergodis_private::g41_q29_exact_tablebase::{
    decompose_g41_q29_exact_block_coefficients_full_reset_control,
    decompose_g41_q29_exact_block_coefficients_with_workspace,
    g41_q29_degree_sequence_decomposition_feasible, G41Q29DirectLiftWorkspace,
};
use serde::Deserialize;
use serde_json::json;

#[derive(Clone, Copy, ValueEnum)]
enum Mode {
    Sparse,
    Full,
    Degree,
}

#[derive(Parser)]
struct Args {
    #[arg(long)]
    source: PathBuf,
    #[arg(long, value_enum)]
    mode: Mode,
    #[arg(long, default_value_t = 10_000)]
    iterations: u32,
    #[arg(long, default_value_t = 0)]
    block: u8,
}

#[derive(Deserialize)]
struct Input {
    digits: [u32; 4],
    q29_coefficients: [[u8; 8]; 4],
}

fn run_sparse(
    iterations: u32,
    digits: u32,
    coefficients: [u8; 8],
    workspace: &mut G41Q29DirectLiftWorkspace,
) -> Result<u32> {
    let mut hits = 0_u32;
    for _ in 0..iterations {
        let decomposition = decompose_g41_q29_exact_block_coefficients_with_workspace(
            digits,
            coefficients,
            workspace,
        )?;
        hits += u32::from(black_box(decomposition).is_some());
    }
    Ok(hits)
}

fn run_full(
    iterations: u32,
    digits: u32,
    coefficients: [u8; 8],
    workspace: &mut G41Q29DirectLiftWorkspace,
) -> Result<u32> {
    let mut hits = 0_u32;
    for _ in 0..iterations {
        let decomposition = decompose_g41_q29_exact_block_coefficients_full_reset_control(
            digits,
            coefficients,
            workspace,
        )?;
        hits += u32::from(black_box(decomposition).is_some());
    }
    Ok(hits)
}

fn run_degree(iterations: u32, digits: u32, coefficients: [u8; 8]) -> Result<u32> {
    let mut hits = 0_u32;
    for _ in 0..iterations {
        hits += u32::from(black_box(g41_q29_degree_sequence_decomposition_feasible(
            digits,
            coefficients,
        )?));
    }
    Ok(hits)
}

fn main() -> Result<()> {
    let args = Args::parse();
    ensure!(args.iterations != 0 && args.iterations <= 10_000_000);
    ensure!(args.block < 4);
    let source = fs::read(args.source)?;
    let input: Input = serde_json::from_slice(&source)?;
    let block = usize::from(args.block);
    let digits = input.digits[block];
    let coefficients = input.q29_coefficients[block];
    let mut workspace = G41Q29DirectLiftWorkspace::new(digits)?;
    let hits = match args.mode {
        Mode::Sparse => run_sparse(args.iterations, digits, coefficients, &mut workspace)?,
        Mode::Full => run_full(args.iterations, digits, coefficients, &mut workspace)?,
        Mode::Degree => run_degree(args.iterations, digits, coefficients)?,
    };
    println!(
        "{}",
        serde_json::to_string(&json!({
            "mode": match args.mode { Mode::Sparse => "sparse", Mode::Full => "full", Mode::Degree => "degree" },
            "block": args.block,
            "iterations": args.iterations,
            "hits": hits,
            "workspace_bytes": workspace.bytes(),
            "provenance": "source-bound repeated exact decomposition control; mode is selected once outside the monomorphized reconstruction kernel in each call, fixed workspace is preallocated, and black-boxed exact hit parity is required",
        }))?
    );
    Ok(())
}
