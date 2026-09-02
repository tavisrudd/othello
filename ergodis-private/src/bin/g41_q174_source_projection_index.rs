use anyhow::{ensure, Context, Result};
use ergodis_private::g41_q174_joint::probe_g41_q174_source_projection_index;

fn main() -> Result<()> {
    let mut args = std::env::args().skip(1);
    let mask = args.next().context("expected mask")?.parse::<u8>()?;
    let digits = args.next().context("expected digits")?.parse::<u32>()?;
    ensure!(args.next().is_none(), "unexpected trailing argument");
    let report = probe_g41_q174_source_projection_index(mask, digits)?;
    serde_json::to_writer(std::io::stdout(), &report)?;
    println!();
    Ok(())
}
