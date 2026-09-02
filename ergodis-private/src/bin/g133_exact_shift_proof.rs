use anyhow::{Context, Result};
use ergodis_private::g133_exact_shift_proof::{
    synthesize_g133_exact_shift_proof, verify_g133_exact_shift_proof, G133ExactShiftBinding,
};

fn main() -> Result<()> {
    let shift = std::env::args()
        .nth(1)
        .context("usage: g133_exact_shift_proof SHIFT")?
        .parse::<u8>()
        .context("SHIFT must be an integer")?;
    let binding = G133ExactShiftBinding::registered(shift)?;
    let proof = synthesize_g133_exact_shift_proof(binding)?;
    verify_g133_exact_shift_proof(&proof)?;
    println!("{}", serde_json::to_string_pretty(&proof)?);
    Ok(())
}
