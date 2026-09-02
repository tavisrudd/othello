use std::sync::atomic::AtomicBool;
use std::sync::Mutex;

use anyhow::{ensure, Result};
use clap::Parser;
use ergodis_private::g53_search::{
    G53QuotientPrefixSeed, G53QuotientShell, G53SearchConfig, G53SearchOutcome, G53SearchRunner,
};
use serde::Serialize;

#[derive(Parser)]
struct Arguments {
    #[arg(long, default_value_t = 1)]
    threads: usize,
    #[arg(long, default_value_t = 1_000_000)]
    iterations_per_thread: u64,
    #[arg(long, default_value_t = 1)]
    seed: u64,
    #[arg(long, default_value_t = 0)]
    initial_shift_orbits: u8,
    #[arg(long, default_value_t = 8)]
    shift_orbit_step: u8,
    #[arg(long, default_value_t = 1)]
    initial_quotient_shifts: u8,
    #[arg(long, default_value_t = 3)]
    quotient_shift_step: u8,
    #[arg(long, default_value_t = 8)]
    advance_mean_square: u16,
    #[arg(long, default_value_t = 250_000)]
    restart_after: u64,
    #[arg(long, default_value_t = 1)]
    temperature: u64,
    #[arg(long, default_value_t = 1)]
    subgroup_energy_weight: u32,
    #[arg(long, default_value_t = 1)]
    quotient_paf_weight: u32,
    /// Hex-encoded, directly validated Z/18 quotient-shell seed from an
    /// earlier discovery-only shell-mining run.
    #[arg(long)]
    initial_quotient_shell: Option<String>,
    /// Hex selection for a directly replayed exact quotient-prefix checkpoint.
    #[arg(long, requires = "initial_quotient_prefix_shifts")]
    initial_quotient_prefix: Option<String>,
    #[arg(long, requires = "initial_quotient_prefix")]
    initial_quotient_prefix_shifts: Option<u8>,
    /// Mine an exact quotient shell and return it without enabling subgroup or
    /// fine-PAF constraints. Output remains heuristic discovery evidence.
    #[arg(long, default_value_t = false)]
    stop_at_quotient_shell: bool,
    #[arg(long, default_value_t = 3)]
    quotient_prefix_retry_limit: u8,
    #[arg(long, default_value_t = 0)]
    cross_block_move_interval: u8,
    #[arg(long, default_value_t = 0)]
    quotient_slot_swap_interval: u8,
    #[arg(long, default_value_t = false)]
    mod7_locked: bool,
    /// Rejected diversification control: eight exact q0 lifts per modular
    /// root instead of the canonical first lift.
    #[arg(long, default_value_t = false)]
    mod7_q0_lift_bank: bool,
    /// Discovery control sampled across exact q0 block-energy fibres.
    #[arg(long, default_value_t = false)]
    mod7_diverse_q0_bank: bool,
    /// Sampled exact-q0 intersection with q1--q6 modulo 49.
    #[arg(long, default_value_t = false)]
    q0_mod49_sample: bool,
    /// Exact-row q0--q6 mod-49 initializer; discovery guidance only.
    #[arg(long, default_value_t = false)]
    mod49_q7_seed: bool,
}

#[derive(Serialize)]
struct ThreadRecord {
    thread: usize,
    iterations: u64,
    restarts: u64,
    active_shift_orbits: u8,
    active_subgroup_identities: u8,
    active_quotient_shifts: u8,
    best_objective: i64,
    best_active_quotient_residuals: [i32; 10],
    best_mod7_root_masks: Option<[u16; 4]>,
    best_quotient_selection: String,
    deepest_exact_quotient_prefix: u8,
    deepest_exact_mod7_root_masks: Option<[u16; 4]>,
    deepest_exact_quotient_selection: String,
    quotient_shell: Option<String>,
}

#[derive(Serialize)]
struct SearchRecord {
    schema: &'static str,
    provenance: &'static str,
    generator: u32,
    carrier: u32,
    threads: usize,
    iterations_per_thread: u64,
    records: Vec<ThreadRecord>,
    witness_minus_sets: Option<Vec<String>>,
}

fn thread_seed(seed: u64, thread: usize) -> u64 {
    let mut value = seed ^ (thread as u64).wrapping_mul(0xd1b5_4a32_d192_ed03);
    value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
    value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
    value ^ (value >> 31)
}

fn main() -> Result<()> {
    let arguments = Arguments::parse();
    ensure!((1..=64).contains(&arguments.threads));
    ensure!(!arguments.mod7_q0_lift_bank || arguments.mod7_locked);
    ensure!(!arguments.mod7_diverse_q0_bank || arguments.mod7_locked);
    ensure!(!arguments.q0_mod49_sample || arguments.mod7_locked);
    ensure!(!arguments.mod49_q7_seed || arguments.mod7_locked);
    ensure!(
        usize::from(arguments.mod49_q7_seed)
            + usize::from(arguments.mod7_q0_lift_bank)
            + usize::from(arguments.mod7_diverse_q0_bank)
            + usize::from(arguments.q0_mod49_sample)
            <= 1
    );
    let initial_quotient_shell = arguments
        .initial_quotient_shell
        .as_deref()
        .map(G53QuotientShell::from_hex)
        .transpose()?;
    let initial_quotient_prefix = arguments
        .initial_quotient_prefix
        .as_deref()
        .map(G53QuotientShell::from_hex)
        .transpose()?
        .zip(arguments.initial_quotient_prefix_shifts)
        .map(|(selection, exact_shifts)| G53QuotientPrefixSeed {
            selection,
            exact_shifts,
        });
    ensure!(!(initial_quotient_shell.is_some() && initial_quotient_prefix.is_some()));
    let stop = AtomicBool::new(false);
    let outcomes = Mutex::new(Vec::<(usize, G53SearchOutcome)>::with_capacity(
        arguments.threads,
    ));
    let mod7_q0_lift_bank = arguments.mod7_q0_lift_bank;
    let mod7_diverse_q0_bank = arguments.mod7_diverse_q0_bank;
    let q0_mod49_sample = arguments.q0_mod49_sample;
    let mod49_q7_seed = arguments.mod49_q7_seed;
    std::thread::scope(|scope| {
        for thread in 0..arguments.threads {
            let outcomes = &outcomes;
            let stop = &stop;
            let config = G53SearchConfig {
                seed: thread_seed(arguments.seed, thread),
                iterations: arguments.iterations_per_thread,
                initial_shift_orbits: arguments.initial_shift_orbits,
                shift_orbit_step: arguments.shift_orbit_step,
                initial_quotient_shifts: arguments.initial_quotient_shifts,
                quotient_shift_step: arguments.quotient_shift_step,
                advance_mean_square: arguments.advance_mean_square,
                restart_after: arguments.restart_after,
                temperature: arguments.temperature,
                subgroup_energy_weight: arguments.subgroup_energy_weight,
                quotient_paf_weight: arguments.quotient_paf_weight,
                initial_quotient_shell,
                initial_quotient_prefix,
                stop_at_quotient_shell: arguments.stop_at_quotient_shell,
                quotient_prefix_retry_limit: arguments.quotient_prefix_retry_limit,
                cross_block_move_interval: arguments.cross_block_move_interval,
                quotient_slot_swap_interval: arguments.quotient_slot_swap_interval,
                mod7_locked: arguments.mod7_locked,
                mod49_q7_seed: arguments.mod49_q7_seed,
            };
            scope.spawn(move || {
                let runner = if mod49_q7_seed {
                    G53SearchRunner::compile_with_mod49_q7_seed()
                } else if q0_mod49_sample {
                    G53SearchRunner::compile_with_q0_mod49_sample()
                } else if mod7_diverse_q0_bank {
                    G53SearchRunner::compile_with_diverse_q0_bank()
                } else if mod7_q0_lift_bank {
                    G53SearchRunner::compile_with_q0_lift_bank()
                } else {
                    G53SearchRunner::compile()
                };
                let outcome = runner
                    .and_then(|mut runner| runner.run(config, stop))
                    .expect("fixed g53 search configuration must compile");
                outcomes.lock().unwrap().push((thread, outcome));
            });
        }
    });
    let mut outcomes = outcomes.into_inner().unwrap();
    outcomes.sort_unstable_by_key(|(thread, _)| *thread);
    let witness = outcomes
        .iter()
        .find_map(|(_, outcome)| outcome.witness.as_deref())
        .map(|blocks| {
            blocks
                .iter()
                .map(|block| {
                    block
                        .iter()
                        .map(|&minus| if minus == 0 { '+' } else { '-' })
                        .collect::<String>()
                })
                .collect::<Vec<_>>()
        });
    let records = outcomes
        .into_iter()
        .map(|(thread, outcome)| ThreadRecord {
            thread,
            iterations: outcome.iterations,
            restarts: outcome.restarts,
            active_shift_orbits: outcome.active_shift_orbits,
            active_subgroup_identities: outcome.active_subgroup_identities,
            active_quotient_shifts: outcome.active_quotient_shifts,
            best_objective: outcome.best_objective,
            best_active_quotient_residuals: outcome.best_active_quotient_residuals,
            best_mod7_root_masks: outcome.best_mod7_root_masks,
            best_quotient_selection: outcome.best_quotient_selection.to_hex(),
            deepest_exact_quotient_prefix: outcome.deepest_exact_quotient_prefix,
            deepest_exact_mod7_root_masks: outcome.deepest_exact_mod7_root_masks,
            deepest_exact_quotient_selection: outcome.deepest_exact_quotient_selection.to_hex(),
            quotient_shell: outcome.quotient_shell.map(G53QuotientShell::to_hex),
        })
        .collect();
    println!(
        "{}",
        serde_json::to_string(&SearchRecord {
            schema: "ergodis-private-c1016-g53-local-search-v2",
            provenance: "heuristic-search; negative output has no coverage authority",
            generator: 53,
            carrier: 522,
            threads: arguments.threads,
            iterations_per_thread: arguments.iterations_per_thread,
            records,
            witness_minus_sets: witness,
        })?
    );
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn thread_seeds_are_distinct_and_not_stream_offsets() {
        let seeds = (0..64)
            .map(|thread| thread_seed(101, thread))
            .collect::<Vec<_>>();
        for (index, &seed) in seeds.iter().enumerate() {
            assert!(!seeds[..index].contains(&seed));
            assert!(!seeds[..index]
                .iter()
                .any(|&prior| prior.wrapping_add(0x9e37_79b9_7f4a_7c15) == seed));
        }
    }
}
