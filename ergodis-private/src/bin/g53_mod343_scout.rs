use anyhow::Result;
use ergodis_private::g53_mod343_scout::scout_g53_mod343_q4;

fn main() -> Result<()> {
    serde_json::to_writer(std::io::stdout(), &scout_g53_mod343_q4()?)?;
    println!();
    Ok(())
}
