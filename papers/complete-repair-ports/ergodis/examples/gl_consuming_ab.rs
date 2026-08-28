use ergodis::observational::{FinitePresentation, GeneratorSpec};
use ergodis::{
    compile_binary_gl_rref, compile_permutation_orbits_with_deferred_verification,
    quotient_presentation_by_binary_gl_rref, quotient_presentation_by_orbits, BinaryGlProbeAction,
    BinaryRightLinearMap, FinitePermutationAction,
};
use serde::Serialize;
use std::hint::black_box;
use std::io::{BufWriter, Write};
use std::time::Instant;

#[derive(Serialize)]
struct ResultRecord {
    rows: usize,
    columns: usize,
    points: u32,
    orbits: u32,
    contexts: usize,
    generic_ns: Vec<f64>,
    naive_rref_ns: Vec<f64>,
    theorem_rref_ns: Vec<f64>,
    theorem_vs_generic_speedup: f64,
    theorem_vs_generic_paired_log_t: f64,
    theorem_vs_naive_rref_speedup: f64,
    theorem_vs_naive_rref_paired_log_t: f64,
}

fn elapsed(operation: impl FnOnce()) -> f64 {
    let start = Instant::now();
    operation();
    start.elapsed().as_nanos() as f64
}

fn paired_log_stats(baseline: &[f64], optimized: &[f64]) -> (f64, f64) {
    let logs: Vec<_> = baseline
        .iter()
        .zip(optimized)
        .map(|(&left, &right)| (left / right).ln())
        .collect();
    let mean = logs.iter().sum::<f64>() / logs.len() as f64;
    let variance =
        logs.iter().map(|value| (value - mean).powi(2)).sum::<f64>() / (logs.len() - 1) as f64;
    (mean.exp(), mean / (variance / logs.len() as f64).sqrt())
}

fn main() {
    let mut arguments = std::env::args().skip(1);
    let rounds = arguments
        .next()
        .map(|value| value.parse().expect("round count must be an integer"))
        .unwrap_or(31);
    let action = BinaryGlProbeAction::new(3, 6).unwrap();
    let canonical = compile_binary_gl_rref(action);
    let contexts = [
        BinaryRightLinearMap::new(6, [2, 4, 8, 16, 32, 1]).unwrap(),
        BinaryRightLinearMap::new(6, [3, 2, 4, 8, 16, 32]).unwrap(),
        BinaryRightLinearMap::new(6, [1, 2, 4, 8, 16, 0]).unwrap(),
    ];
    let observations = (0..action.point_count())
        .map(|point| canonical.representative(point).unwrap())
        .collect::<Vec<_>>();
    let generators = contexts.iter().map(|context| GeneratorSpec {
        source_sort: 0,
        target_sort: 0,
        transitions: (0..action.point_count())
            .map(|point| context.apply(&action, point).unwrap())
            .collect(),
    });
    let presentation =
        FinitePresentation::new([action.point_count()], observations, generators).unwrap();

    for _ in 0..2 {
        let generic = compile_permutation_orbits_with_deferred_verification(&action).unwrap();
        black_box(quotient_presentation_by_orbits(&presentation, &generic).unwrap());
        let rref = compile_binary_gl_rref(action);
        black_box(
            rref.compile_right_linear_presentation(&contexts, |representative| representative)
                .unwrap(),
        );
    }

    let mut generic_ns = Vec::with_capacity(rounds);
    let mut naive_rref_ns = Vec::with_capacity(rounds);
    let mut theorem_rref_ns = Vec::with_capacity(rounds);
    for round in 0..rounds {
        let generic = || {
            elapsed(|| {
                let partition =
                    compile_permutation_orbits_with_deferred_verification(&action).unwrap();
                black_box(quotient_presentation_by_orbits(&presentation, &partition).unwrap());
            })
        };
        let naive = || {
            elapsed(|| {
                let partition = compile_binary_gl_rref(action);
                black_box(
                    quotient_presentation_by_binary_gl_rref(&presentation, &partition).unwrap(),
                );
            })
        };
        let theorem = || {
            elapsed(|| {
                let partition = compile_binary_gl_rref(action);
                black_box(
                    partition
                        .compile_right_linear_presentation(&contexts, |representative| {
                            representative
                        })
                        .unwrap(),
                );
            })
        };
        match round % 3 {
            0 => {
                generic_ns.push(generic());
                theorem_rref_ns.push(theorem());
                naive_rref_ns.push(naive());
            }
            1 => {
                theorem_rref_ns.push(theorem());
                naive_rref_ns.push(naive());
                generic_ns.push(generic());
            }
            _ => {
                naive_rref_ns.push(naive());
                generic_ns.push(generic());
                theorem_rref_ns.push(theorem());
            }
        }
    }
    let (theorem_vs_generic_speedup, theorem_vs_generic_paired_log_t) =
        paired_log_stats(&generic_ns, &theorem_rref_ns);
    let (theorem_vs_naive_rref_speedup, theorem_vs_naive_rref_paired_log_t) =
        paired_log_stats(&naive_rref_ns, &theorem_rref_ns);
    let record = ResultRecord {
        rows: 3,
        columns: 6,
        points: action.point_count(),
        orbits: canonical.orbit_count(),
        contexts: contexts.len(),
        generic_ns,
        naive_rref_ns,
        theorem_rref_ns,
        theorem_vs_generic_speedup,
        theorem_vs_generic_paired_log_t,
        theorem_vs_naive_rref_speedup,
        theorem_vs_naive_rref_paired_log_t,
    };
    let mut writer: Box<dyn Write> = match arguments.next() {
        Some(path) => Box::new(BufWriter::new(std::fs::File::create(path).unwrap())),
        None => Box::new(BufWriter::new(std::io::stdout().lock())),
    };
    serde_json::to_writer_pretty(&mut writer, &record).unwrap();
    writeln!(writer).unwrap();
}
