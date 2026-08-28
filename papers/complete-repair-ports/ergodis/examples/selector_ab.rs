use ergodis::{DenseSelector, Prime, SparseSelector};
use serde::Serialize;
use std::hint::black_box;
use std::io::{BufWriter, Write};
use std::time::Instant;

#[derive(Serialize)]
struct DensityResult {
    coefficient_slots: usize,
    terms: usize,
    density: f64,
    dense_bytes: usize,
    sparse_bytes: usize,
    batches_per_round: usize,
    dense_ns: Vec<f64>,
    sparse_ns: Vec<f64>,
    geometric_mean_speedup: f64,
    paired_log_t_score: f64,
}

fn elapsed_per_call(mut operation: impl FnMut(), batches: usize) -> f64 {
    let start = Instant::now();
    for _ in 0..batches {
        operation();
    }
    start.elapsed().as_nanos() as f64 / batches as f64
}

fn measure(term_count: usize, rounds: usize, batches: usize) -> DensityResult {
    const SLOTS: usize = 5_usize.pow(5);
    let mut dense_coefficients = vec![0_u8; SLOTS];
    let mut sparse_terms = Vec::with_capacity(term_count);
    for term in 0..term_count {
        let index = term * SLOTS / term_count;
        let coefficient = (term % 6 + 1) as u8;
        dense_coefficients[index] = coefficient;
        sparse_terms.push((index as u64, coefficient));
    }
    let dense = DenseSelector::<Prime<7>>::new([4; 5], dense_coefficients).unwrap();
    let sparse = SparseSelector::<Prime<7>>::new([4; 5], sparse_terms).unwrap();
    let mut dense_workspace = dense.workspace();
    let mut sparse_workspace = sparse.workspace();
    assert_eq!(
        dense.select_nonzero(&mut dense_workspace).unwrap(),
        sparse.select_nonzero(&mut sparse_workspace).unwrap()
    );

    for _ in 0..8 {
        black_box(dense.select_nonzero(&mut dense_workspace).unwrap());
        black_box(sparse.select_nonzero(&mut sparse_workspace).unwrap());
    }
    let mut dense_ns = Vec::with_capacity(rounds);
    let mut sparse_ns = Vec::with_capacity(rounds);
    for round in 0..rounds {
        let mut dense_measurement = || {
            elapsed_per_call(
                || {
                    black_box(
                        dense
                            .select_nonzero(black_box(&mut dense_workspace))
                            .unwrap(),
                    );
                },
                batches,
            )
        };
        let mut sparse_measurement = || {
            elapsed_per_call(
                || {
                    black_box(
                        sparse
                            .select_nonzero(black_box(&mut sparse_workspace))
                            .unwrap(),
                    );
                },
                batches,
            )
        };
        if round & 1 == 0 {
            dense_ns.push(dense_measurement());
            sparse_ns.push(sparse_measurement());
        } else {
            sparse_ns.push(sparse_measurement());
            dense_ns.push(dense_measurement());
        }
    }
    let log_ratios: Vec<_> = dense_ns
        .iter()
        .zip(&sparse_ns)
        .map(|(&dense, &sparse)| (dense / sparse).ln())
        .collect();
    let mean = log_ratios.iter().sum::<f64>() / log_ratios.len() as f64;
    let variance = log_ratios
        .iter()
        .map(|value| (value - mean).powi(2))
        .sum::<f64>()
        / (log_ratios.len() - 1) as f64;

    DensityResult {
        coefficient_slots: SLOTS,
        terms: term_count,
        density: term_count as f64 / SLOTS as f64,
        dense_bytes: dense.storage_bytes(),
        sparse_bytes: sparse.storage_bytes(),
        batches_per_round: batches,
        dense_ns,
        sparse_ns,
        geometric_mean_speedup: mean.exp(),
        paired_log_t_score: mean / (variance / log_ratios.len() as f64).sqrt(),
    }
}

fn main() {
    let mut arguments = std::env::args().skip(1);
    let rounds = arguments
        .next()
        .map(|value| value.parse().expect("round count must be an integer"))
        .unwrap_or(31);
    let results = [32, 313, 1_563, 3_125].map(|terms| measure(terms, rounds, 64));
    let mut writer: Box<dyn Write> = match arguments.next() {
        Some(path) => Box::new(BufWriter::new(std::fs::File::create(path).unwrap())),
        None => Box::new(BufWriter::new(std::io::stdout().lock())),
    };
    serde_json::to_writer_pretty(&mut writer, &results).unwrap();
    writeln!(writer).unwrap();
}
