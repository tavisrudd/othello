use ergodis::{CostTable, Matrix, Prime, RankBoundedContextCache};
use serde::Serialize;
use std::hint::black_box;
use std::io::{BufWriter, Write};
use std::time::Instant;

#[derive(Serialize)]
struct Record {
    ambient_dimension: usize,
    maximum_rank: usize,
    states: u64,
    restriction_edges: u64,
    payload_bytes: u64,
    candidates: u64,
    contexts_per_batch: usize,
    cached_query_ns: Vec<f64>,
    envelope_query_ns: Vec<f64>,
    lazy_first_batch_ns: Vec<f64>,
    envelope_first_batch_ns: Vec<f64>,
    query_geometric_mean_speedup: f64,
    query_paired_log_t: f64,
}

fn rank_table() -> CostTable {
    CostTable::from_entries::<2>(
        1,
        2,
        (0usize..4).map(|bits| {
            let data = vec![(bits & 1) as u8, ((bits >> 1) & 1) as u8];
            let cost = data.iter().filter(|&&entry| entry != 0).count() as u32;
            (Matrix::new::<2>(1, 2, data).unwrap(), cost)
        }),
    )
    .unwrap()
}

fn contexts() -> Vec<Matrix> {
    let dimension = 6;
    let mut contexts = Vec::with_capacity(32);
    for tail in 0..32usize {
        let mut data = vec![0u8; 5 * dimension];
        for row in 0..5 {
            data[row * dimension] = ((tail >> row) & 1) as u8;
            data[row * dimension + row + 1] = 1;
        }
        contexts.push(Matrix::new::<2>(5, dimension, data).unwrap());
    }
    contexts
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
    let table = rank_table();
    let contexts = contexts();
    let mut warm_cache = RankBoundedContextCache::<Prime<2>>::new(&table, &table, 6, 0, 2).unwrap();
    let envelope = warm_cache.compile_full_span_envelope(5, 2_451).unwrap();
    for context in &contexts {
        assert_eq!(
            warm_cache.context_cost_cached(context).unwrap().cost,
            envelope.context_cost::<Prime<2>>(context).unwrap().cost
        );
    }
    let storage = envelope.storage();
    let mut cached_query_ns = Vec::with_capacity(rounds);
    let mut envelope_query_ns = Vec::with_capacity(rounds);
    let mut lazy_first_batch_ns = Vec::with_capacity(rounds);
    let mut envelope_first_batch_ns = Vec::with_capacity(rounds);

    for round in 0..rounds {
        let mut cached_query = || {
            elapsed(|| {
                let mut checksum = 0_u32;
                for context in &contexts {
                    checksum += warm_cache.context_cost_cached(context).unwrap().cost;
                }
                black_box(checksum);
            })
        };
        let envelope_query = || {
            elapsed(|| {
                let mut checksum = 0_u32;
                for context in &contexts {
                    checksum += envelope.context_cost::<Prime<2>>(context).unwrap().cost;
                }
                black_box(checksum);
            })
        };
        let lazy_first = || {
            elapsed(|| {
                let mut cache =
                    RankBoundedContextCache::<Prime<2>>::new(&table, &table, 6, 0, 2).unwrap();
                let mut checksum = 0_u32;
                for context in &contexts {
                    checksum += cache.context_cost_cached(context).unwrap().cost;
                }
                black_box(checksum);
            })
        };
        let envelope_first = || {
            elapsed(|| {
                let mut cache =
                    RankBoundedContextCache::<Prime<2>>::new(&table, &table, 6, 0, 2).unwrap();
                let compiled = cache.compile_full_span_envelope(5, 2_451).unwrap();
                let mut checksum = 0_u32;
                for context in &contexts {
                    checksum += compiled.context_cost::<Prime<2>>(context).unwrap().cost;
                }
                black_box(checksum);
            })
        };
        if round & 1 == 0 {
            cached_query_ns.push(cached_query());
            envelope_query_ns.push(envelope_query());
            lazy_first_batch_ns.push(lazy_first());
            envelope_first_batch_ns.push(envelope_first());
        } else {
            envelope_first_batch_ns.push(envelope_first());
            lazy_first_batch_ns.push(lazy_first());
            envelope_query_ns.push(envelope_query());
            cached_query_ns.push(cached_query());
        }
    }
    let (query_geometric_mean_speedup, query_paired_log_t) =
        paired_log_stats(&cached_query_ns, &envelope_query_ns);
    let record = Record {
        ambient_dimension: 6,
        maximum_rank: 5,
        states: storage.states,
        restriction_edges: storage.restriction_edges,
        payload_bytes: storage.payload_bytes,
        candidates: envelope.compilation_work().generator_candidates,
        contexts_per_batch: contexts.len(),
        cached_query_ns,
        envelope_query_ns,
        lazy_first_batch_ns,
        envelope_first_batch_ns,
        query_geometric_mean_speedup,
        query_paired_log_t,
    };
    let mut writer: Box<dyn Write> = match arguments.next() {
        Some(path) => Box::new(BufWriter::new(std::fs::File::create(path).unwrap())),
        None => Box::new(BufWriter::new(std::io::stdout().lock())),
    };
    serde_json::to_writer_pretty(&mut writer, &record).unwrap();
    writeln!(writer).unwrap();
}
