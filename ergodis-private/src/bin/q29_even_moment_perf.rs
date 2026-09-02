use std::{hint::black_box, thread};

use ergodis_private::q29_even_moment_proof::{
    census_q29_single_swaps, census_q29_trade_quadruple_repairs, census_q29_trade_repairs,
    census_q29_trade_tablebase, census_q29_trade_triple_repairs, detect_q29_six_point_trade,
    extract_q29_even_moments, extract_q29_residual, retained_q29_y6_root,
    Q29TradeTablebaseWorkspace,
};

const ORDER: usize = 29;
const BLOCKS: usize = 4;

#[derive(Clone, Copy)]
enum Mode {
    Moment,
    Direct,
    Census,
    Trade,
    TripleTrade,
    QuadrupleTrade,
    TradeTablebase,
}

fn main() {
    let mut args = std::env::args().skip(1);
    let mode = match args.next().as_deref() {
        Some("moment") => Mode::Moment,
        Some("direct") => Mode::Direct,
        Some("census") => Mode::Census,
        Some("trade") => Mode::Trade,
        Some("triple-trade") => Mode::TripleTrade,
        Some("quadruple-trade") => Mode::QuadrupleTrade,
        Some("trade-tablebase") => Mode::TradeTablebase,
        _ => {
            panic!("usage: q29_even_moment_perf moment|direct|census|trade|triple-trade|quadruple-trade|trade-tablebase [iterations] [threads]")
        }
    };
    let iterations = args
        .next()
        .map_or(1_000_000, |value| value.parse().expect("iterations"));
    let threads = args
        .next()
        .map_or(1, |value| value.parse().expect("threads"));
    assert!(threads > 0 && threads <= 64);

    let rows = retained_q29_y6_root();
    let residual = extract_q29_residual(&rows).expect("retained root");
    let witness = detect_q29_six_point_trade(&residual).expect("retained trade");
    let mut digest = 0_u64;
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(threads);
        for worker in 0..threads {
            handles.push(scope.spawn(move || {
                let mut local = worker as u64;
                match mode {
                    Mode::Moment => {
                        for _ in 0..iterations {
                            let signature = black_box(extract_q29_even_moments(black_box(&rows)))
                                .expect("moment extraction");
                            local ^= u64::from(signature.t2()) << 8 | u64::from(signature.t4());
                        }
                    }
                    Mode::Direct => {
                        for _ in 0..iterations {
                            let (t2, t4) = direct_even_moments(black_box(&rows));
                            local ^= u64::from(t2) << 8 | u64::from(t4);
                        }
                    }
                    Mode::Census => {
                        for _ in 0..iterations {
                            let report = black_box(census_q29_single_swaps(black_box(&rows)))
                                .expect("swap census");
                            local ^= u64::from(report.legal_swaps) << 32
                                | u64::from(report.t2_survivors);
                        }
                    }
                    Mode::Trade => {
                        for _ in 0..iterations {
                            let found = black_box(detect_q29_six_point_trade(black_box(&residual)))
                                .expect("trade detection");
                            let report = black_box(census_q29_trade_repairs(
                                black_box(&rows),
                                black_box(found),
                            ))
                            .expect("trade census");
                            local ^= u64::from(report.energy_preserving_candidates)
                                | u64::from(found.a_mask()) << 16;
                        }
                    }
                    Mode::TripleTrade => {
                        for _ in 0..iterations {
                            let (report, hit) = black_box(census_q29_trade_triple_repairs(
                                black_box(&rows),
                                black_box(witness),
                            ))
                            .expect("triple-trade census");
                            local ^= u64::from(report.energy_preserving_triples)
                                | u64::from(report.moment_preserving_triples) << 32
                                | u64::from(hit.is_some());
                        }
                    }
                    Mode::QuadrupleTrade => {
                        for _ in 0..iterations {
                            let (report, hit) = black_box(census_q29_trade_quadruple_repairs(
                                black_box(&rows),
                                black_box(witness),
                            ))
                            .expect("quadruple-trade census");
                            local ^= report.application_quadruples
                                ^ u64::from(report.energy_preserving_quadruples) << 24
                                ^ u64::from(report.moment_preserving_quadruples) << 48
                                ^ u64::from(hit.is_some());
                        }
                    }
                    Mode::TradeTablebase => {
                        let mut workspace = Q29TradeTablebaseWorkspace::new();
                        for _ in 0..iterations {
                            let (report, hit) = black_box(census_q29_trade_tablebase(
                                black_box(&rows),
                                black_box(witness),
                                &mut workspace,
                            ))
                            .expect("trade tablebase");
                            local ^= u64::from(report.distinct_left_pair_keys)
                                ^ report.right_pair_probes.rotate_left(17)
                                ^ u64::from(hit.is_some());
                        }
                    }
                }
                local
            }));
        }
        for handle in handles {
            digest ^= handle.join().expect("worker");
        }
    });
    black_box(witness);
    if matches!(mode, Mode::TripleTrade) {
        let (report, hit) =
            census_q29_trade_triple_repairs(&rows, witness).expect("triple-trade census summary");
        eprintln!("triple_trade_report={report:?} hit={}", hit.is_some());
    }
    if matches!(mode, Mode::QuadrupleTrade) {
        let (report, hit) = census_q29_trade_quadruple_repairs(&rows, witness)
            .expect("quadruple-trade census summary");
        eprintln!("quadruple_trade_report={report:?} hit={}", hit.is_some());
    }
    if matches!(mode, Mode::TradeTablebase) {
        let mut workspace = Q29TradeTablebaseWorkspace::new();
        let (report, hit) = census_q29_trade_tablebase(&rows, witness, &mut workspace)
            .expect("trade-tablebase summary");
        eprintln!(
            "trade_tablebase_report={report:?} hit={} workspace_bytes={}",
            hit.is_some(),
            workspace.bytes()
        );
    }
    println!(
        "iterations={iterations} threads={threads} total_operations={} digest={digest} provenance=ProvedStructural+ExactComputational(root=ObservedEvolved)",
        iterations * threads
    );
}

#[inline(never)]
fn direct_even_moments(rows: &[[i8; ORDER]; BLOCKS]) -> (u8, u8) {
    let mut t2 = 0_i64;
    let mut t4 = 0_i64;
    for shift in 0..ORDER {
        let mut correlation = 0_i64;
        for row in rows {
            for point in 0..ORDER {
                correlation += i64::from(row[point]) * i64::from(row[(point + shift) % ORDER]);
            }
        }
        let shift = shift as i64;
        t2 += shift.pow(2) * correlation;
        t4 += shift.pow(4) * correlation;
    }
    (t2.rem_euclid(29) as u8, t4.rem_euclid(29) as u8)
}
