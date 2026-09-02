use anyhow::Result;
use ergodis_private::g41_q174_joint::{
    analyze_g41_q174_q87_interactions, prove_g41_q174_q87_phase_relations,
    prove_g41_q174_translation_261,
};
use serde_json::json;

fn main() -> Result<()> {
    serde_json::to_writer_pretty(
        std::io::stdout(),
        &json!({
            "interaction": analyze_g41_q174_q87_interactions()?,
            "phase_proof": prove_g41_q174_q87_phase_relations()?,
            "translation_proof": prove_g41_q174_translation_261()?,
        }),
    )?;
    println!();
    Ok(())
}
