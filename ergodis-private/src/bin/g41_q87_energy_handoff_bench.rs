use anyhow::{ensure, Result};
use clap::{Parser, ValueEnum};
use ergodis_private::g41_q87_energy::{compile_g41_q87_energy_support, G41Q87EnergySpecTable};
use serde::Serialize;

const MASK: u8 = 20;
const DIGITS: u32 = 2_215_340;
const COEFFICIENTS: [[u8; 8]; 2] = [[8, 8, 10, 10, 9, 8, 10, 8], [8, 9, 7, 10, 9, 5, 11, 12]];

#[derive(Clone, Copy, ValueEnum, Serialize)]
#[serde(rename_all = "snake_case")]
enum Mode {
    Recompile,
    Handoff,
}

#[derive(Parser)]
struct Args {
    #[arg(long, value_enum)]
    mode: Mode,
    #[arg(long, default_value_t = 10_000)]
    queries: usize,
}

#[derive(Serialize)]
struct Report {
    mode: Mode,
    queries: u64,
    checksum: u64,
    handoff_bytes: u32,
    provenance: &'static str,
}

fn checksum(words: [u64; 9]) -> u64 {
    words
        .into_iter()
        .fold(0_u64, |sum, word| sum.rotate_left(7) ^ word)
}

fn main() -> Result<()> {
    let args = Args::parse();
    ensure!(args.queries > 0);
    let table = G41Q87EnergySpecTable::compile(MASK, DIGITS)?;
    for coefficients in COEFFICIENTS {
        ensure!(
            table.energy_support(coefficients)?
                == compile_g41_q87_energy_support(MASK, DIGITS, coefficients)?.energy_support
        );
    }
    let mut sum = 0_u64;
    match args.mode {
        Mode::Recompile => {
            for query in 0..args.queries {
                let report = compile_g41_q87_energy_support(MASK, DIGITS, COEFFICIENTS[query & 1])?;
                sum ^= std::hint::black_box(checksum(report.energy_support));
            }
        }
        Mode::Handoff => {
            for query in 0..args.queries {
                let support = table.energy_support(COEFFICIENTS[query & 1])?;
                sum ^= std::hint::black_box(checksum(support));
            }
        }
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            mode: args.mode,
            queries: args.queries as u64,
            checksum: sum,
            handoff_bytes: std::mem::size_of::<G41Q87EnergySpecTable>() as u32,
            provenance: "source-shape-matched repeated q87 marginal energy queries; both modes independently agree before measurement, recompile reconstructs six-slot coordinate sumsets per query, and handoff reuses one source-bound table with a fixed-width allocation-free query",
        },
    )?;
    println!();
    Ok(())
}
