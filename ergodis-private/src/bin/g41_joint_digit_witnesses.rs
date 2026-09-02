use anyhow::Result;
use clap::Parser;
use ergodis_private::g41_joint_quotient_search::enumerate_g41_joint_digit_witnesses;
use serde::Serialize;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    full: bool,
}

#[derive(Serialize)]
struct Summary<'a> {
    roots_examined: u32,
    digit_witnesses: u64,
    minimum_root_witnesses: u32,
    maximum_root_witnesses: u32,
    provenance: &'a str,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let report = enumerate_g41_joint_digit_witnesses()?;
    if args.full {
        serde_json::to_writer(std::io::stdout(), &report)?;
    } else {
        serde_json::to_writer(
            std::io::stdout(),
            &Summary {
                roots_examined: report.roots_examined,
                digit_witnesses: report.digit_witnesses,
                minimum_root_witnesses: report.minimum_root_witnesses,
                maximum_root_witnesses: report.maximum_root_witnesses,
                provenance: report.provenance,
            },
        )?;
    }
    println!();
    Ok(())
}
