use std::collections::BTreeMap;
use std::fs::File;
use std::path::PathBuf;

use anyhow::Result;
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_exact_tablebase::canonical_g41_q29_block_spec;
use ergodis_private::g41_q29_exact_tablebase::g41_q29_slot_aggregate_signature;
use serde::Serialize;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    cache: PathBuf,
}

#[derive(Serialize)]
struct Report {
    roots: u32,
    interfaces: u64,
    raw_block_specs_by_position: [u32; 4],
    raw_aggregate_signatures_by_position: [u32; 4],
    raw_aggregate_signatures: [Vec<[u8; 4]>; 4],
    canonical_block_specs_by_position: [u32; 4],
    canonical_block_specs_global: u32,
    canonical_digit_vectors_global: u32,
    maximum_masks_per_digit_vector: u8,
    canonical_aggregate_signature_specs: Vec<AggregateSignatureCount>,
    canonical_ac_pair_domains: u32,
    canonical_bd_pair_domains: u32,
    canonical_four_block_domains: u32,
    aggregate_ac_pair_domains: u32,
    aggregate_bd_pair_domains: u32,
    aggregate_four_block_domains: u32,
    minimum_root_four_block_domains: u32,
    maximum_root_four_block_domains: u32,
    minimum_root_aggregate_four_block_domains: u32,
    maximum_root_aggregate_four_block_domains: u32,
    maximum_split_imbalance_samples: [BlockSpecSample; 4],
    provenance: &'static str,
}

#[derive(Clone, Copy, Default, Serialize)]
struct BlockSpecSample {
    mask: u8,
    digits: u32,
    digit_counts: [u8; 6],
    maximum_split_imbalance: u8,
}

#[derive(Clone, Copy, Serialize)]
struct AggregateSignatureCount {
    signature: [u8; 4],
    block_specs: u32,
}

fn pack(mask: u8, digits: u32) -> u64 {
    u64::from(digits) | (u64::from(mask) << 32)
}

fn canonical(mask: u8, digits: u32) -> Result<u64> {
    let (mask, digits, _) = canonical_g41_q29_block_spec(mask, digits)?;
    Ok(pack(mask, digits))
}

fn distinct<T: Ord>(values: &mut Vec<T>) -> u32 {
    values.sort_unstable();
    values.dedup();
    values.len() as u32
}

fn unpack_spec(spec: u64) -> BlockSpecSample {
    let digits = spec as u32;
    let counts = [
        (digits & 7) as u8,
        ((digits >> 3) & 7) as u8,
        ((digits >> 6) & 15) as u8,
        ((digits >> 10) & 15) as u8,
        ((digits >> 14) & 15) as u8,
        ((digits >> 18) & 15) as u8,
    ];
    BlockSpecSample {
        mask: (spec >> 32) as u8,
        digits,
        digit_counts: counts,
        maximum_split_imbalance: counts[0]
            .abs_diff(counts[1])
            .max(counts[2].abs_diff(counts[3]))
            .max(counts[4].abs_diff(counts[5])),
    }
}

fn main() -> Result<()> {
    let args = Args::parse();
    let report = read_g41_digit_witness_cache(File::open(args.cache)?)?;
    let count = report.witnesses.len();
    let mut raw: [Vec<u64>; 4] = std::array::from_fn(|_| Vec::with_capacity(count));
    let mut canonical_by_position: [Vec<u64>; 4] =
        std::array::from_fn(|_| Vec::with_capacity(count));
    let mut canonical_global = Vec::with_capacity(4 * count);
    let mut ac_pairs = Vec::with_capacity(count);
    let mut bd_pairs = Vec::with_capacity(count);
    let mut quadruples = Vec::with_capacity(count);
    let mut aggregate_ac_pairs = Vec::with_capacity(count);
    let mut aggregate_bd_pairs = Vec::with_capacity(count);
    let mut aggregate_quadruples = Vec::with_capacity(count);
    let mut minimum_root_four_block_domains = u32::MAX;
    let mut maximum_root_four_block_domains = 0_u32;
    let mut minimum_root_aggregate_four_block_domains = u32::MAX;
    let mut maximum_root_aggregate_four_block_domains = 0_u32;

    for root in 0..report.roots_examined as usize {
        let start = report.root_offsets[root] as usize;
        let end = report.root_offsets[root + 1] as usize;
        let before = quadruples.len();
        let aggregate_before = aggregate_quadruples.len();
        for witness in &report.witnesses[start..end] {
            let specs: [u64; 4] =
                std::array::from_fn(|block| pack(witness.masks[block], witness.digits[block]));
            let mut canonical_specs = [0_u64; 4];
            for block in 0..4 {
                canonical_specs[block] = canonical(witness.masks[block], witness.digits[block])?;
            }
            for block in 0..4 {
                raw[block].push(specs[block]);
                canonical_by_position[block].push(canonical_specs[block]);
                canonical_global.push(canonical_specs[block]);
            }
            let mut ac = [canonical_specs[0], canonical_specs[2]];
            let mut bd = [canonical_specs[1], canonical_specs[3]];
            ac.sort_unstable();
            bd.sort_unstable();
            ac_pairs.push(ac);
            bd_pairs.push(bd);
            quadruples.push(canonical_specs);

            let mut signatures = [[0_u8; 4]; 4];
            for block in 0..4 {
                signatures[block] =
                    g41_q29_slot_aggregate_signature(witness.masks[block], witness.digits[block])?;
            }
            let mut aggregate_ac = [signatures[0], signatures[2]];
            let mut aggregate_bd = [signatures[1], signatures[3]];
            aggregate_ac.sort_unstable();
            aggregate_bd.sort_unstable();
            aggregate_ac_pairs.push(aggregate_ac);
            aggregate_bd_pairs.push(aggregate_bd);
            aggregate_quadruples.push(signatures);
        }
        quadruples[before..].sort_unstable();
        let unique = quadruples[before..]
            .iter()
            .enumerate()
            .filter(|(index, value)| *index == 0 || *value != &quadruples[before + index - 1])
            .count() as u32;
        minimum_root_four_block_domains = minimum_root_four_block_domains.min(unique);
        maximum_root_four_block_domains = maximum_root_four_block_domains.max(unique);
        aggregate_quadruples[aggregate_before..].sort_unstable();
        let aggregate_unique = aggregate_quadruples[aggregate_before..]
            .iter()
            .enumerate()
            .filter(|(index, value)| {
                *index == 0 || *value != &aggregate_quadruples[aggregate_before + index - 1]
            })
            .count() as u32;
        minimum_root_aggregate_four_block_domains =
            minimum_root_aggregate_four_block_domains.min(aggregate_unique);
        maximum_root_aggregate_four_block_domains =
            maximum_root_aggregate_four_block_domains.max(aggregate_unique);
    }

    let raw_block_specs_by_position = std::array::from_fn(|block| distinct(&mut raw[block]));
    let mut raw_aggregate_signatures_by_position = [0_u32; 4];
    let mut raw_aggregate_signatures: [Vec<[u8; 4]>; 4] = std::array::from_fn(|_| Vec::new());
    for block in 0..4 {
        let signatures = &mut raw_aggregate_signatures[block];
        signatures.reserve(raw[block].len());
        for &spec in &raw[block] {
            let sample = unpack_spec(spec);
            signatures.push(g41_q29_slot_aggregate_signature(
                sample.mask,
                sample.digits,
            )?);
        }
        raw_aggregate_signatures_by_position[block] = distinct(signatures);
    }
    let canonical_block_specs_by_position =
        std::array::from_fn(|block| distinct(&mut canonical_by_position[block]));
    let maximum_split_imbalance_samples = std::array::from_fn(|block| {
        raw[block]
            .iter()
            .copied()
            .map(unpack_spec)
            .max_by_key(|sample| sample.maximum_split_imbalance)
            .unwrap_or_default()
    });
    canonical_global.sort_unstable();
    canonical_global.dedup();
    let mut canonical_signature_counts = BTreeMap::<[u8; 4], u32>::new();
    for &spec in &canonical_global {
        let sample = unpack_spec(spec);
        let signature = g41_q29_slot_aggregate_signature(sample.mask, sample.digits)?;
        let count = canonical_signature_counts.entry(signature).or_default();
        *count = count
            .checked_add(1)
            .ok_or_else(|| anyhow::anyhow!("canonical signature count overflow"))?;
    }
    let canonical_aggregate_signature_specs = canonical_signature_counts
        .into_iter()
        .map(|(signature, block_specs)| AggregateSignatureCount {
            signature,
            block_specs,
        })
        .collect();
    let mut canonical_digits: Vec<u32> = canonical_global.iter().map(|&spec| spec as u32).collect();
    canonical_digits.sort_unstable();
    let maximum_masks_per_digit_vector = canonical_digits
        .chunk_by(|left, right| left == right)
        .map(|run| run.len())
        .max()
        .unwrap_or(0)
        .min(usize::from(u8::MAX)) as u8;
    canonical_digits.dedup();
    let output = Report {
        roots: report.roots_examined,
        interfaces: report.digit_witnesses,
        raw_block_specs_by_position,
        raw_aggregate_signatures_by_position,
        raw_aggregate_signatures,
        canonical_block_specs_by_position,
        canonical_block_specs_global: canonical_global.len() as u32,
        canonical_digit_vectors_global: canonical_digits.len() as u32,
        maximum_masks_per_digit_vector,
        canonical_aggregate_signature_specs,
        canonical_ac_pair_domains: distinct(&mut ac_pairs),
        canonical_bd_pair_domains: distinct(&mut bd_pairs),
        canonical_four_block_domains: distinct(&mut quadruples),
        aggregate_ac_pair_domains: distinct(&mut aggregate_ac_pairs),
        aggregate_bd_pair_domains: distinct(&mut aggregate_bd_pairs),
        aggregate_four_block_domains: distinct(&mut aggregate_quadruples),
        minimum_root_four_block_domains,
        maximum_root_four_block_domains,
        minimum_root_aggregate_four_block_domains,
        maximum_root_aggregate_four_block_domains,
        maximum_split_imbalance_samples,
        provenance: "cold exact census over the sealed all-interface cache; complementation-canonical block domains preserve q29 defects; counts estimate exact tablebase reuse and carry no exclusion authority",
    };
    serde_json::to_writer(std::io::stdout(), &output)?;
    println!();
    Ok(())
}
