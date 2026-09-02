use anyhow::Result;
use ergodis_private::g133_exact_q2_proof::{
    synthesize_g133_exact_q2_proof, verify_g133_exact_q2_proof, G133ExactQ2Binding,
};

fn main() -> Result<()> {
    let proof = synthesize_g133_exact_q2_proof(G133ExactQ2Binding::registered())?;
    verify_g133_exact_q2_proof(&proof)?;
    serde_json::to_writer(std::io::stdout(), &proof)?;
    println!();
    Ok(())
}
