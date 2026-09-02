use std::thread;

use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::order6_margin_evolve::{
    evolve_order6_margin_shell, evolve_order6_margin_shell_outer,
    evolve_order6_margin_shell_outer_epochs, evolve_order6_margin_shell_parity,
    Order6MarginEvolveReport, Q29OuterEpochStat,
};
use ergodis_private::q29_inventory_scope::{census_q29_inventory_scopes, Q29InventoryWorkspace};

// Positionals stay `Option<String>`: the original silently fell back to the
// default on a non-numeric argument, and a typed positional would reject it.
#[derive(ClapArgs)]
pub struct Arguments {
    threads: Option<String>,
    mutations: Option<String>,
    seed_mode: Option<String>,
    epoch_mutations: Option<String>,
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
    let seed_mode = arguments.seed_mode.unwrap_or_default();
    let outer_shell = seed_mode == "outer";
    let outer_epochs = seed_mode == "outer-epochs";
    let parity_shell = seed_mode == "parity";
    let epoch_mutations = arguments
        .epoch_mutations
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(1_000_000);
    assert!((1..=18).contains(&threads));
    let mut reports = Vec::<Order6MarginEvolveReport>::with_capacity(threads);
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(threads);
        for worker in 0..threads {
            handles.push(scope.spawn(move || {
                let seed = 0x243f_6a88_85a3_08d3 ^ worker as u64;
                if outer_epochs {
                    let mut workspace = Q29InventoryWorkspace::new();
                    census_q29_inventory_scopes(&mut workspace).unwrap();
                    let epochs = mutations.div_ceil(epoch_mutations) as usize;
                    let mut statistics = vec![Q29OuterEpochStat::ZERO; epochs];
                    evolve_order6_margin_shell_outer_epochs(
                        &mut workspace,
                        seed,
                        mutations,
                        epoch_mutations,
                        &mut statistics,
                    )
                    .unwrap()
                } else if outer_shell {
                    let mut workspace = Q29InventoryWorkspace::new();
                    census_q29_inventory_scopes(&mut workspace).unwrap();
                    evolve_order6_margin_shell_outer(&mut workspace, seed, mutations, worker as u64)
                        .unwrap()
                } else if parity_shell {
                    evolve_order6_margin_shell_parity(seed, mutations)
                } else {
                    evolve_order6_margin_shell(seed, mutations)
                }
            }));
        }
        for handle in handles {
            reports.push(handle.join().unwrap());
        }
    });
    // Phase one is the q29 launch gate.  Preserve its best worker even when a
    // random, not-yet-admitted q58/q87 lift gives another worker a smaller
    // aggregate score.  An exact phase-two hit has both keys zero.
    reports.sort_unstable_by_key(|report| (report.best_score_components[0], report.best_score));
    let report = &reports[0];
    let json = serde_json::json!({
        "seed": report.seed,
        "mutations": report.mutations,
        "accepted": report.accepted,
        "best_score": report.best_score,
        "best_score_components": report.best_score_components,
        "q29_shell_hit": report.q29_shell_hit,
        "phase_two_mutations": report.phase_two_mutations,
        "exact_shell_hit": report.exact_shell_hit,
        "best_counts": report.best_counts.iter().map(|row| row.as_slice()).collect::<Vec<_>>(),
        "best_q29": report.best_q29.iter().map(|row| row.as_slice()).collect::<Vec<_>>(),
        "best_q58": report.best_q58.iter().map(|row| row.as_slice()).collect::<Vec<_>>(),
        "best_q87": report.best_q87.iter().map(|row| row.as_slice()).collect::<Vec<_>>(),
        "provenance": report.provenance,
    });
    println!("{}", serde_json::to_string_pretty(&json).unwrap());
    Ok(())
}
