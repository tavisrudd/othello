use ergodis::{
    compile_binary_gl_rref, compile_permutation_orbits_with_deferred_verification,
    BinaryGlProbeAction, FinitePermutationAction,
};
use serde::Serialize;
use std::hint::black_box;
use std::io::{BufWriter, Write};
use std::time::Instant;

#[derive(Serialize)]
struct ShapeResult {
    rows: usize,
    columns: usize,
    points: u32,
    orbits: u32,
    generic_bytes: usize,
    rref_bytes: usize,
    batches_per_round: usize,
    generic_ns: Vec<f64>,
    rref_ns: Vec<f64>,
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

fn measure_shape(rows: usize, columns: usize, rounds: usize, batches: usize) -> ShapeResult {
    let action = BinaryGlProbeAction::new(rows, columns).unwrap();
    let generic = compile_permutation_orbits_with_deferred_verification(&action).unwrap();
    let direct = compile_binary_gl_rref(action);
    assert_eq!(
        generic.representatives().len(),
        direct.orbit_count() as usize
    );

    for _ in 0..4 {
        black_box(compile_permutation_orbits_with_deferred_verification(&action).unwrap());
        black_box(compile_binary_gl_rref(action));
    }

    let mut generic_ns = Vec::with_capacity(rounds);
    let mut rref_ns = Vec::with_capacity(rounds);
    for round in 0..rounds {
        let generic_measurement = || {
            elapsed_per_call(
                || {
                    black_box(
                        compile_permutation_orbits_with_deferred_verification(black_box(&action))
                            .unwrap(),
                    );
                },
                batches,
            )
        };
        let rref_measurement = || {
            elapsed_per_call(
                || {
                    black_box(compile_binary_gl_rref(black_box(action)));
                },
                batches,
            )
        };
        if round & 1 == 0 {
            generic_ns.push(generic_measurement());
            rref_ns.push(rref_measurement());
        } else {
            rref_ns.push(rref_measurement());
            generic_ns.push(generic_measurement());
        }
    }

    let log_ratios: Vec<_> = generic_ns
        .iter()
        .zip(&rref_ns)
        .map(|(&generic, &rref)| (generic / rref).ln())
        .collect();
    let mean = log_ratios.iter().sum::<f64>() / log_ratios.len() as f64;
    let variance = log_ratios
        .iter()
        .map(|value| (value - mean).powi(2))
        .sum::<f64>()
        / (log_ratios.len() - 1) as f64;

    ShapeResult {
        rows,
        columns,
        points: action.point_count(),
        orbits: direct.orbit_count(),
        generic_bytes: generic.storage().quotient_bytes + generic.storage().certificate_bytes,
        rref_bytes: direct.storage_bytes(),
        batches_per_round: batches,
        generic_ns,
        rref_ns,
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
    let results = [
        measure_shape(2, 8, rounds, 8),
        measure_shape(3, 6, rounds, 2),
    ];
    let mut writer: Box<dyn Write> = match arguments.next() {
        Some(path) => Box::new(BufWriter::new(std::fs::File::create(path).unwrap())),
        None => Box::new(BufWriter::new(std::io::stdout().lock())),
    };
    serde_json::to_writer_pretty(&mut writer, &results).unwrap();
    writeln!(writer).unwrap();
}
