use std::collections::BTreeMap;
use std::fs::File;
use std::path::PathBuf;

use anyhow::Result;
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_exact_tablebase::translation_canonical_g41_q29_block_spec;
use ergodis_private::g41_q87_energy::G41Q87EnergySpecTable;
use serde::Serialize;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    cache: PathBuf,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Spec {
    mask: u8,
    digits: u32,
}

#[derive(Serialize)]
struct BehaviorClass {
    digest: [u8; 32],
    block_specs: u16,
    sample_mask: u8,
    sample_digits: u32,
}

#[derive(Serialize)]
struct Report {
    interfaces: u64,
    translation_canonical_block_specs: u16,
    behavior_classes: u16,
    largest_behavior_class: u16,
    classes: Vec<BehaviorClass>,
    specs: Vec<SpecBehavior>,
    table_bytes: u32,
    provenance: &'static str,
}

#[derive(Serialize)]
struct SpecBehavior {
    mask: u8,
    digits: u32,
    digit_counts: [u8; 6],
    behavior: u16,
}

fn unpack_digit_counts(digits: u32) -> [u8; 6] {
    [
        (digits & 7) as u8,
        ((digits >> 3) & 7) as u8,
        ((digits >> 6) & 15) as u8,
        ((digits >> 10) & 15) as u8,
        ((digits >> 14) & 15) as u8,
        ((digits >> 18) & 15) as u8,
    ]
}

fn main() -> Result<()> {
    let args = Args::parse();
    let source = read_g41_digit_witness_cache(File::open(args.cache)?)?;
    let mut specs = Vec::with_capacity(4 * source.witnesses.len());
    for witness in source.witnesses.iter() {
        for block in 0..4 {
            let (mask, digits) = translation_canonical_g41_q29_block_spec(
                witness.masks[block],
                witness.digits[block],
            )?;
            specs.push(Spec { mask, digits });
        }
    }
    specs.sort_unstable();
    specs.dedup();
    let mut grouped = BTreeMap::<[u8; 32], (u16, Spec)>::new();
    let mut compiled = Vec::with_capacity(specs.len());
    for spec in specs.iter().copied() {
        let digest = G41Q87EnergySpecTable::compile(spec.mask, spec.digits)?.behavior_digest();
        let entry = grouped.entry(digest).or_insert((0, spec));
        entry.0 += 1;
        compiled.push((spec, digest));
    }
    let largest_behavior_class = grouped.values().map(|entry| entry.0).max().unwrap_or(0);
    let classes = grouped
        .into_iter()
        .map(|(digest, (block_specs, sample))| BehaviorClass {
            digest,
            block_specs,
            sample_mask: sample.mask,
            sample_digits: sample.digits,
        })
        .collect::<Vec<_>>();
    let class_ids = classes
        .iter()
        .enumerate()
        .map(|(index, class)| (class.digest, index as u16))
        .collect::<BTreeMap<_, _>>();
    let spec_behaviors = compiled
        .into_iter()
        .map(|(spec, digest)| SpecBehavior {
            mask: spec.mask,
            digits: spec.digits,
            digit_counts: unpack_digit_counts(spec.digits),
            behavior: class_ids[&digest],
        })
        .collect();
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            interfaces: source.witnesses.len() as u64,
            translation_canonical_block_specs: specs.len() as u16,
            behavior_classes: classes.len() as u16,
            largest_behavior_class,
            classes,
            specs: spec_behaviors,
            table_bytes: std::mem::size_of::<G41Q87EnergySpecTable>() as u32,
            provenance: "complete sealed-interface census; every translation-canonical block specification is independently compiled into the full 8x19 coefficient-to-q87-energy table, and classes merge only byte-semantically equal table commitments",
        },
    )?;
    println!();
    Ok(())
}
