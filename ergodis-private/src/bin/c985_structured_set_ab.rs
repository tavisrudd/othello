use clap::{Parser, ValueEnum};
use ergodis::structured_integer_set::{
    StructuredIntegerSet, StructuredSetBounds, StructuredSumCertificate,
};
use std::hint::black_box;

#[derive(Clone, Copy, Debug, ValueEnum)]
enum Mode {
    Flat,
    Structured,
}

#[derive(Debug, Parser)]
struct Cli {
    #[arg(long, value_enum)]
    mode: Mode,
    #[arg(long, default_value_t = 2_000)]
    rounds: u64,
    #[arg(long, default_value_t = 257)]
    queries: u16,
}

fn main() {
    let cli = Cli::parse();
    let bounds = StructuredSetBounds {
        maximum_modulus: 256,
        maximum_holes: 256,
        maximum_span: 20_000,
    };
    let left_residues = (0_u16..64)
        .filter(|residue| residue % 3 != 1)
        .collect::<Vec<_>>();
    let right_residues = (0_u16..64)
        .filter(|residue| residue % 5 != 2)
        .collect::<Vec<_>>();
    let left_holes = canonical_holes(0, 16_383, 64, &left_residues, 47, 96);
    let right_holes = canonical_holes(0, 16_383, 64, &right_residues, 61, 96);
    let left = StructuredIntegerSet::compile(
        0,
        16_383,
        64,
        &left_residues,
        &left_holes,
        bounds,
    )
    .unwrap();
    let right = StructuredIntegerSet::compile(
        0,
        16_383,
        64,
        &right_residues,
        &right_holes,
        bounds,
    )
    .unwrap();

    let mut checksum = 0_u64;
    for round in 0..cli.rounds {
        for query in 0..cli.queries {
            let target = 14_824_i64 + i64::from(query) + (round % 31) as i64;
            let certificate = match cli.mode {
                Mode::Flat => flat_sum_certificate(&left, &right, black_box(target)),
                Mode::Structured => left.sum_certificate(&right, black_box(target)),
            };
            checksum = checksum
                .rotate_left(7)
                .wrapping_add(certificate.pair_count)
                .wrapping_add(certificate.witness.map_or(0, |pair| pair[0] as u64));
        }
    }
    black_box(checksum);
    println!(
        "mode={:?} rounds={} queries={} checksum={checksum}",
        cli.mode, cli.rounds, cli.queries
    );
}

fn canonical_holes(
    minimum: i64,
    maximum: i64,
    modulus: u16,
    residues: &[u16],
    stride: usize,
    limit: usize,
) -> Vec<i64> {
    (minimum..=maximum)
        .filter(|&value| residues.binary_search(&(value.rem_euclid(i64::from(modulus)) as u16)).is_ok())
        .step_by(stride)
        .take(limit)
        .collect()
}

#[inline(never)]
fn flat_sum_certificate(
    left: &StructuredIntegerSet,
    right: &StructuredIntegerSet,
    target: i64,
) -> StructuredSumCertificate {
    let mut pair_count = 0_u64;
    let mut witness = None;
    for value in left.iter() {
        let complement = i128::from(target) - i128::from(value);
        let Ok(complement) = i64::try_from(complement) else {
            continue;
        };
        if right.contains(complement) {
            pair_count += 1;
            witness.get_or_insert([value, complement]);
        }
    }
    StructuredSumCertificate {
        target,
        pair_count,
        witness,
    }
}
