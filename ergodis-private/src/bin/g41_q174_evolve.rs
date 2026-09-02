use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_evolve::evolve_g41_q174_discovery_from_interfaces;
use std::fs::File;
use std::path::PathBuf;

#[derive(Debug, Parser)]
#[command(about = "Discovery-only q174 evolution for the C1016/G41 source family")]
struct Args {
    #[arg(long)]
    witness_cache: PathBuf,
    #[arg(long, default_value_t = 18)]
    threads: usize,
    #[arg(long, default_value_t = 180)]
    attempts: u64,
    #[arg(long, default_value_t = 1_000)]
    mutations_per_attempt: u32,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();
    let interfaces = read_g41_digit_witness_cache(File::open(args.witness_cache)?)?;
    let report = evolve_g41_q174_discovery_from_interfaces(
        &interfaces.witnesses,
        args.threads,
        args.attempts,
        args.mutations_per_attempt,
    )?;
    println!("{}", serde_json::to_string_pretty(&report)?);
    Ok(())
}
