use std::{fs, process::ExitCode, thread};

use ergodis_private::q29_transfer_anneal::{anneal_q29_transfers, replay_q29_y, Q29TransferReport};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

const BLOCKS: usize = 4;
const ORDER: usize = 29;

#[derive(Deserialize)]
struct OuterInput {
    best_q29: [[i8; ORDER]; BLOCKS],
}

#[derive(Serialize)]
struct ParallelReport {
    source_commitment: [u8; 32],
    workers: usize,
    mutations_per_worker: u64,
    base_seed: u64,
    initial_score_y: u64,
    initial_score_x: u64,
    accepted: u64,
    exact_hits: u64,
    best: Q29TransferReport,
    provenance: &'static str,
}

fn main() -> ExitCode {
    let mut args = std::env::args().skip(1);
    let path = args
        .next()
        .expect("usage: q29_transfer_anneal OUTER.json [workers] [mutations] [seed]");
    let workers = args
        .next()
        .and_then(|value| value.parse::<usize>().ok())
        .unwrap_or(1);
    let mutations = args
        .next()
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(10_000_000);
    let base_seed = args
        .next()
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(0x9e37_79b9_7f4a_7c15);
    assert!((1..=18).contains(&workers));

    let source = fs::read(path).expect("read outer q29 JSON");
    let input: OuterInput = serde_json::from_slice(&source).expect("parse outer q29 JSON");
    let rows_y = x_to_y(&input.best_q29).expect("canonical even x=2y input in [-18,18]");
    let initial = replay_q29_y(&rows_y).expect("bounded q29 y root with row sums (1,0,0,0)");

    let mut reports = Vec::with_capacity(workers);
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(workers);
        for worker in 0..workers {
            let seed =
                base_seed.wrapping_add((worker as u64 + 1).wrapping_mul(0xd1b5_4a32_d192_ed03));
            handles.push(scope.spawn(move || {
                anneal_q29_transfers(&rows_y, seed, mutations).expect("validated shared root")
            }));
        }
        for handle in handles {
            reports.push(handle.join().expect("q29 transfer worker"));
        }
    });
    let accepted = reports.iter().map(|report| report.accepted).sum();
    let exact_hits = reports.iter().filter(|report| report.exact_hit).count() as u64;
    let best = reports
        .into_iter()
        .min_by_key(|report| (report.best_score_y, report.seed))
        .expect("at least one worker");
    let final_replay = replay_q29_y(&best.rows).expect("best candidate remains canonical");
    assert_eq!(best.best_score_y, final_replay.score_y);
    assert_eq!(best.exact_hit, final_replay.exact);

    let report = ParallelReport {
        source_commitment: Sha256::digest(&source).into(),
        workers,
        mutations_per_worker: mutations,
        base_seed,
        initial_score_y: initial.score_y,
        initial_score_x: 16 * initial.score_y,
        accepted,
        exact_hits,
        best,
        provenance: "ObservedEvolved; source-bound x=2y outer root converted only after evenness/range checks; deterministic disjoint workers; exact positives direct-replayed; misses have no negative authority",
    };
    println!(
        "{}",
        serde_json::to_string_pretty(&report).expect("serialize report")
    );
    ExitCode::SUCCESS
}

fn x_to_y(rows_x: &[[i8; ORDER]; BLOCKS]) -> Option<[[i8; ORDER]; BLOCKS]> {
    let mut rows_y = [[0_i8; ORDER]; BLOCKS];
    for block in 0..BLOCKS {
        for point in 0..ORDER {
            let value = rows_x[block][point];
            if !(-18..=18).contains(&value) || value & 1 != 0 {
                return None;
            }
            rows_y[block][point] = value / 2;
        }
    }
    Some(rows_y)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn x_to_y_rejects_odd_and_out_of_range_inputs() {
        let mut rows = [[0_i8; ORDER]; BLOCKS];
        rows[0][0] = 1;
        assert!(x_to_y(&rows).is_none());
        rows[0][0] = 20;
        assert!(x_to_y(&rows).is_none());
    }
}
