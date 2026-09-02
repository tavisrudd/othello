use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::g41_q174_joint::prove_g41_q174_coset_complement_symmetry;

#[derive(ClapArgs)]
pub struct Arguments {}

pub fn run(_arguments: Arguments) -> Result<()> {
    serde_json::to_writer_pretty(
        std::io::stdout(),
        &prove_g41_q174_coset_complement_symmetry()?,
    )?;
    println!();
    Ok(())
}
