use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q174_energy_theorem::prove_g41_q174_zero_energy_bound;
use std::fs::File;
use std::path::PathBuf;

#[derive(Debug, Parser)]
#[command(about = "Prove the q174 zero-energy lower bound for exact G41/q18 interfaces")]
struct Args {
    #[arg(long)]
    witness_cache: PathBuf,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();
    let interfaces = read_g41_digit_witness_cache(File::open(args.witness_cache)?)?;
    let report = prove_g41_q174_zero_energy_bound(&interfaces.witnesses)?;
    println!("{}", serde_json::to_string_pretty(&report)?);
    Ok(())
}
