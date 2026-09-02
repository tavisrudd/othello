use std::fmt::Write as _;
use std::fs::OpenOptions;
use std::io::BufWriter;
use std::path::PathBuf;

use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::write_g41_digit_witness_cache;
use ergodis_private::g41_joint_quotient_search::enumerate_g41_joint_digit_witnesses;
use serde::Serialize;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    output: PathBuf,
}

#[derive(Serialize)]
struct Summary<'a> {
    output: &'a PathBuf,
    roots_examined: u32,
    digit_witnesses: u64,
    minimum_root_witnesses: u32,
    maximum_root_witnesses: u32,
    payload_sha256: String,
}

fn main() -> Result<()> {
    let args = Args::parse();
    if args.output.exists() {
        bail!("output already exists: {}", args.output.display());
    }
    let partial = args.output.with_extension("partial");
    let file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(&partial)
        .with_context(|| format!("create {}", partial.display()))?;
    let report = enumerate_g41_joint_digit_witnesses()?;
    let digest = write_g41_digit_witness_cache(&report, BufWriter::new(file))?;
    std::fs::rename(&partial, &args.output)
        .with_context(|| format!("rename {} to {}", partial.display(), args.output.display()))?;
    let mut payload_sha256 = String::with_capacity(64);
    for byte in digest {
        write!(&mut payload_sha256, "{byte:02x}")?;
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Summary {
            output: &args.output,
            roots_examined: report.roots_examined,
            digit_witnesses: report.digit_witnesses,
            minimum_root_witnesses: report.minimum_root_witnesses,
            maximum_root_witnesses: report.maximum_root_witnesses,
            payload_sha256,
        },
    )?;
    println!();
    Ok(())
}
