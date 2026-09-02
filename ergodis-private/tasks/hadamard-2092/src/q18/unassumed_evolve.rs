use std::thread;

use ergodis_private::q18_unassumed_evolve::{evolve_q18_unassumed, Q18EvolveReport};

use anyhow::Result;
use clap::Args as ClapArgs;

#[derive(ClapArgs)]
pub struct Arguments {
    threads: Option<String>,
    mutations: Option<String>,
}

pub fn run(arguments: Arguments) -> Result<()> {
    let threads = arguments
        .threads
        .and_then(|value| value.parse::<usize>().ok())
        .unwrap_or(1);
    let mutations = arguments
        .mutations
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(1_000_000);
    assert!((1..=18).contains(&threads));
    let mut reports = Vec::<Q18EvolveReport>::with_capacity(threads);
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(threads);
        for worker in 0..threads {
            handles.push(scope.spawn(move || {
                evolve_q18_unassumed(0x9e37_79b9_7f4a_7c15 ^ worker as u64, mutations)
            }));
        }
        for handle in handles {
            reports.push(handle.join().unwrap());
        }
    });
    reports.sort_unstable_by_key(|report| report.best_score);
    println!("{}", serde_json::to_string_pretty(&reports[0]).unwrap());
    Ok(())
}
