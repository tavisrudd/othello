use std::path::PathBuf;

use anyhow::Result;
use clap::Parser;
use ergodis_private::banked_rule_evolve::write_banked_rule_campaign;

#[derive(Debug, Parser)]
struct Args {
    #[arg(long)]
    reduction: String,
    #[arg(long)]
    output: PathBuf,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let report = write_banked_rule_campaign(&args.reduction, &args.output)?;
    println!("{}", serde_json::to_string_pretty(&report)?);
    Ok(())
}
