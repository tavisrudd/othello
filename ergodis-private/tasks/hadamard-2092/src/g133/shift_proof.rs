use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::g133_exact_shift_proof::{
    synthesize_g133_exact_shift_proof, verify_g133_exact_shift_proof, G133ExactShiftBinding,
};

#[derive(ClapArgs)]
pub struct Arguments {
    /// SHIFT
    shift: u8,
}

pub fn run(arguments: Arguments) -> Result<()> {
    let shift = arguments.shift;
    let binding = G133ExactShiftBinding::registered(shift)?;
    let proof = synthesize_g133_exact_shift_proof(binding)?;
    verify_g133_exact_shift_proof(&proof)?;
    println!("{}", serde_json::to_string_pretty(&proof)?);
    Ok(())
}
