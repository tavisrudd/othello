use std::{fs::File, thread};

use ergodis_private::order6_margin_evolve::{
    repair_q29_double_double_single_scope_exact, Order6Q29TripleDoubleWorkspace,
    Q29DoubleDoubleSingleReport,
};
use serde::Deserialize;

#[derive(Deserialize)]
struct Input {
    best_q29: [[i8; 29]; 4],
}

fn main() {
    let path = std::env::args()
        .nth(1)
        .expect("usage: q29_radius5_parallel INPUT.json");
    let input: Input =
        serde_json::from_reader(File::open(path).expect("open input")).expect("parse input");
    let mut reports = Vec::<Q29DoubleDoubleSingleReport>::with_capacity(12);
    let mut hit = None;
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(12);
        for omitted in 0..4 {
            for single in 0..4 {
                if omitted == single {
                    continue;
                }
                handles.push(scope.spawn(move || {
                    let mut left = Order6Q29TripleDoubleWorkspace::new();
                    let mut right = Order6Q29TripleDoubleWorkspace::new();
                    repair_q29_double_double_single_scope_exact(
                        input.best_q29,
                        omitted,
                        single,
                        &mut left,
                        &mut right,
                    )
                    .expect("valid q29 scope")
                }));
            }
        }
        for handle in handles {
            let (report, candidate) = handle.join().expect("scope worker");
            reports.push(report);
            if hit.is_none() {
                hit = candidate;
            }
        }
    });
    reports.sort_unstable_by_key(|report| (report.omitted_block, report.single_block));
    println!(
        "{}",
        serde_json::to_string_pretty(&serde_json::json!({
            "exact_scoped_repair_hit": hit.is_some(),
            "repaired_q29": hit,
            "reports": reports,
            "workers": 12,
            "workspace_bound_bytes": 12_u64 * 2 * 50_622_584,
            "provenance": "ExactComputational over all twelve labelled 2+2+1 block scopes; same-row doubles are sequentially compiled; distinct-row deltas add; full keys contain energy and all fourteen independent q29 PAF coordinates; every hit gets direct replay; a miss has no authority outside this radius-five partition",
        }))
        .expect("serialize report")
    );
}
