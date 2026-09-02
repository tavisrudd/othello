use std::path::PathBuf;

use anyhow::Result;
use clap::{Parser, ValueEnum};
use ergodis_private::g133_evolve_adapter::{
    write_g133_exact_shift_campaign_with_label, G133CampaignLabel,
};

#[derive(Clone, Copy, Debug, ValueEnum)]
enum Label {
    Survives,
    Excluded,
}

#[derive(Debug, Parser)]
struct Args {
    #[arg(long)]
    shift: usize,
    #[arg(long)]
    output: PathBuf,
    #[arg(long, value_enum, default_value_t = Label::Survives)]
    label: Label,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let label = match args.label {
        Label::Survives => G133CampaignLabel::Survives,
        Label::Excluded => G133CampaignLabel::Excluded,
    };
    let report = write_g133_exact_shift_campaign_with_label(args.shift, label, &args.output)?;
    println!("{}", serde_json::to_string_pretty(&report)?);
    Ok(())
}
