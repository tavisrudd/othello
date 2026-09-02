use std::fs::{self, File};
use std::path::PathBuf;

use anyhow::{Context, Result};
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_profile_multiset::compile_g41_q29_profile_multiset_report;
use serde::Serialize;
use sha2::{Digest, Sha256};

#[derive(Parser)]
struct Args {
    #[arg(long)]
    cache: PathBuf,
}

#[derive(Serialize)]
struct Report<T> {
    source_cache_digest: [u8; 32],
    proof: T,
    provenance: &'static str,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let source_bytes =
        fs::read(&args.cache).with_context(|| format!("reading {}", args.cache.display()))?;
    let source_cache_digest: [u8; 32] = Sha256::digest(&source_bytes).into();
    drop(source_bytes);
    let source = read_g41_digit_witness_cache(File::open(&args.cache)?)?;
    let proof = compile_g41_q29_profile_multiset_report(&source.witnesses)?;
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            source_cache_digest,
            proof,
            provenance: "typed sealed-cache replay followed by exact aggregate-pair graph reconstruction and canonical four-profile multiset proof; the compact report stores counts rather than an edge certificate",
        },
    )?;
    println!();
    Ok(())
}
