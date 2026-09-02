use std::path::PathBuf;

use anyhow::{Context, Result};
use clap::Parser;
use ergodis_private::banked_semantic_evolve::{
    banked_semantic_systems, write_banked_semantic_campaign,
};

#[derive(Debug, Parser)]
struct Args {
    #[arg(long)]
    output_dir: PathBuf,
}

fn main() -> Result<()> {
    let args = Args::parse();
    std::fs::create_dir_all(&args.output_dir).context("cannot create output directory")?;
    let mut reports = Vec::with_capacity(banked_semantic_systems().len());
    for system in banked_semantic_systems() {
        reports.push(write_banked_semantic_campaign(
            system.slug,
            &args.output_dir.join(format!("{}.jsonl", system.slug)),
        )?);
    }
    println!("{}", serde_json::to_string_pretty(&reports)?);
    Ok(())
}
