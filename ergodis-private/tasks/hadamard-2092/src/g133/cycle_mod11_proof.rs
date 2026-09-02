use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::g133_cycle_mod11_proof::{
    synthesize_g133_cycle_mod11_proof, verify_g133_cycle_mod11_proof, G133CycleMod11Binding,
    G133CycleMod11Observation,
};

#[derive(ClapArgs)]
pub struct Arguments {}

pub fn run(_arguments: Arguments) -> Result<()> {
    let proof = synthesize_g133_cycle_mod11_proof(
        G133CycleMod11Binding::registered(),
        G133CycleMod11Observation::evolved_candidate(),
    )?;
    verify_g133_cycle_mod11_proof(&proof)?;
    println!("{}", serde_json::to_string_pretty(&proof)?);
    Ok(())
}
