use clap::Args as ClapArgs;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q174_energy_theorem::prove_g41_q174_zero_energy_bound;
use std::fs::File;
use std::path::PathBuf;

#[derive(Debug, ClapArgs)]
pub struct Arguments {
    #[arg(long)]
    witness_cache: PathBuf,
}

pub fn run(args: Arguments) -> anyhow::Result<()> {
    let interfaces = read_g41_digit_witness_cache(File::open(args.witness_cache)?)?;
    let report = prove_g41_q174_zero_energy_bound(&interfaces.witnesses)?;
    println!("{}", serde_json::to_string_pretty(&report)?);
    Ok(())
}
