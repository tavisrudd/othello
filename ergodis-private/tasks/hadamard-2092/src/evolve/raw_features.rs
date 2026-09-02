use std::path::PathBuf;

use anyhow::{Context, Result};
use clap::Args as ClapArgs;
use ergodis_private::banked_semantic_evolve::banked_semantic_systems;
use ergodis_private::raw_feature_evolve::write_raw_feature_campaign;
use sha2::{Digest, Sha256};

#[derive(Debug, ClapArgs)]
pub struct Arguments {
    #[arg(long)]
    output_dir: PathBuf,
}

fn source_digest(slug: &str) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(b"c1016-banked-semantic-source-v1");
    hasher.update(slug.as_bytes());
    hasher.finalize().into()
}

pub fn run(args: Arguments) -> Result<()> {
    std::fs::create_dir_all(&args.output_dir).context("cannot create output directory")?;
    let mut reports = Vec::with_capacity(2 * banked_semantic_systems().len());
    for (index, system) in banked_semantic_systems().iter().enumerate() {
        let corpus = format!("corpus-{index:02}");
        let digest = source_digest(system.slug);
        reports.push(write_raw_feature_campaign(
            system.slug,
            "train",
            0x1016_2092_0000_0000_u64 ^ index as u64,
            digest,
            &args.output_dir.join(format!("{corpus}-train.jsonl")),
        )?);
        reports.push(write_raw_feature_campaign(
            system.slug,
            "holdout",
            0x2092_1016_ffff_ffff_u64 ^ index as u64,
            digest,
            &args.output_dir.join(format!("{corpus}-holdout.jsonl")),
        )?);
    }
    println!("{}", serde_json::to_string_pretty(&reports)?);
    Ok(())
}
