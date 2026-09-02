use std::thread;

use ergodis_private::q29_exact_anneal::{
    anneal_q29_from_mod18, retained_mod18_seed_17737406, Q29AnnealReport,
};

fn main() {
    let threads = std::env::args()
        .nth(1)
        .and_then(|v| v.parse::<usize>().ok())
        .unwrap_or(18);
    let mutations = std::env::args()
        .nth(2)
        .and_then(|v| v.parse::<u64>().ok())
        .unwrap_or(10_000_000);
    assert!((1..=18).contains(&threads));
    let rows = retained_mod18_seed_17737406();
    let mut reports = Vec::<Q29AnnealReport>::with_capacity(threads);
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(threads);
        for worker in 0..threads {
            handles.push(scope.spawn(move || {
                let seed = 0x9e37_79b9_7f4a_7c15 ^ worker as u64;
                if worker & 1 == 0 {
                    anneal_q29_from_mod18::<true>(&rows, seed, mutations)
                } else {
                    anneal_q29_from_mod18::<false>(&rows, seed, mutations)
                }
            }));
        }
        for handle in handles {
            reports.push(handle.join().unwrap());
        }
    });
    reports.sort_unstable_by_key(|report| report.best_score_y);
    println!("{}", serde_json::to_string_pretty(&reports[0]).unwrap());
}
