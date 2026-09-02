use std::{fs, thread};

use ergodis_private::{
    q18_pair_split::Q18Coefficients,
    q18_unassumed_evolve::{evolve_q18_basin_escape, Q18EvolveReport},
};
use serde::Deserialize;

#[derive(Deserialize)]
struct Input {
    best_coefficients: [[i8; 18]; 4],
}

fn main() {
    let path = std::env::args()
        .nth(1)
        .expect("usage: q18_basin_escape INPUT.json [THREADS] [MUTATIONS]");
    let threads = std::env::args()
        .nth(2)
        .and_then(|value| value.parse::<usize>().ok())
        .unwrap_or(1);
    let mutations = std::env::args()
        .nth(3)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(1_000_000);
    assert!((1..=18).contains(&threads));
    let input: Input = serde_json::from_slice(&fs::read(path).unwrap()).unwrap();
    let base = Q18Coefficients {
        blocks: input.best_coefficients,
    };
    let mut reports = Vec::<Q18EvolveReport>::with_capacity(threads);
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(threads);
        for worker in 0..threads {
            let worker_base = base;
            handles.push(scope.spawn(move || {
                evolve_q18_basin_escape(
                    &worker_base,
                    0xd1b5_4a32_d192_ed03 ^ worker as u64,
                    mutations,
                )
            }));
        }
        for handle in handles {
            reports.push(handle.join().unwrap());
        }
    });
    reports.sort_unstable_by_key(|report| report.best_score);
    println!("{}", serde_json::to_string_pretty(&reports[0]).unwrap());
}
