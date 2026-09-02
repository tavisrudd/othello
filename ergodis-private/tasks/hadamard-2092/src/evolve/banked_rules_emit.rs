use std::path::PathBuf;

use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::banked_rule_evolve::write_banked_rule_campaign;

#[derive(Debug, ClapArgs)]
pub struct Arguments {
    #[arg(long)]
    reduction: String,
    #[arg(long)]
    output: PathBuf,
}

pub fn run(args: Arguments) -> Result<()> {
    let report = write_banked_rule_campaign(&args.reduction, &args.output)?;
    println!("{}", serde_json::to_string_pretty(&report)?);
    Ok(())
}
