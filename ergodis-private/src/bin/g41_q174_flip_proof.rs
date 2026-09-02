use anyhow::Result;
use ergodis_private::g41_q174_joint::prove_g41_q174_coset_complement_symmetry;

fn main() -> Result<()> {
    serde_json::to_writer_pretty(
        std::io::stdout(),
        &prove_g41_q174_coset_complement_symmetry()?,
    )?;
    println!();
    Ok(())
}
