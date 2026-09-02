use std::fs::File;
use std::path::PathBuf;

use anyhow::{anyhow, Result};
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_exact_tablebase::g41_q29_slot_aggregate_signature;
use serde::Serialize;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    cache: PathBuf,
    #[arg(long, default_value_t = 5)]
    middle_small: u8,
}

#[derive(Serialize)]
struct Report {
    root_id: u32,
    masks: [u8; 4],
    digits: [u32; 4],
    signatures: [[u8; 4]; 4],
    profile_classes: [u8; 4],
    provenance: &'static str,
}

fn profile_class(signature: [u8; 4], block: usize) -> Option<u8> {
    if block == 0 {
        return (signature[0] == 8).then_some(8);
    }
    let small = signature[0].min(18 - signature[0]);
    matches!(small, 1 | 5 | 9).then_some(small)
}

fn main() -> Result<()> {
    let args = Args::parse();
    let cache = read_g41_digit_witness_cache(File::open(args.cache)?)?;
    for witness in cache.witnesses.iter() {
        let mut signatures = [[0_u8; 4]; 4];
        let mut classes = [0_u8; 4];
        for block in 0..4 {
            signatures[block] =
                g41_q29_slot_aggregate_signature(witness.masks[block], witness.digits[block])?;
            classes[block] = profile_class(signatures[block], block)
                .ok_or_else(|| anyhow!("witness signature is outside the four compiled classes"))?;
        }
        if classes == [8, args.middle_small, 9, args.middle_small] {
            serde_json::to_writer(
                std::io::stdout(),
                &Report {
                    root_id: witness.root_id,
                    masks: witness.masks,
                    digits: witness.digits,
                    signatures,
                    profile_classes: classes,
                    provenance: "first sealed-cache interface in the ordered A+B5+C+B5 aggregate-profile class; exact quotient replay is owned by cache loading, while q29 profile lifting remains pending",
                },
            )?;
            println!();
            return Ok(());
        }
    }
    Err(anyhow!("no A+B5+C+B5 interface exists in the sealed cache"))
}
