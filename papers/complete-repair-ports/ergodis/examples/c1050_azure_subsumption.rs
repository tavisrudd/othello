//! C1050: does the generic counted-type reduction subsume the bespoke Azure
//! LRC(12,2,2) counted compiler?
//!
//! For a grid of Azure upgrade-domain instances this compares three exact
//! paths on the same instance:
//!
//! * `azure_lrc_12_2_2_counted` — the application-specific closed-form
//!   compiler, whose work is bounded by the capacity and which never builds a
//!   `WeightedRepairProblem`;
//! * `azure_lrc_12_2_2_upgrade_domains(..).solve_counted_types()` — the generic
//!   reduction added in C1038, which either certifies an optimum or declines;
//! * `azure_lrc_12_2_2_upgrade_domains(..).solve_adaptive()` — the general
//!   backend, used here as the independent oracle.
//!
//! It reports, per instance, whether the generic reduction certified, whether
//! its optimum agrees, and the wall time of each path including instance
//! construction. Columns are deterministic; wall times go to standard error.
//!
//! Replay:
//! ```text
//! nix shell nixpkgs#cargo nixpkgs#rustc --command \
//!   cargo build --release --example c1050_azure_subsumption
//! taskset -c 3 <shared-target-dir>/release/examples/c1050_azure_subsumption \
//!   > evidence/c1050-azure-subsumption.tsv
//! ```

use std::time::Instant;

use ergodis::applications::{azure_lrc_12_2_2_counted, azure_lrc_12_2_2_upgrade_domains};

fn main() {
    println!(
        "capacity\tdemands\tbespoke_repaired\tbespoke_work\tgeneric_status\tgeneric_repaired\t\
         oracle_repaired\tagree\tbespoke_ns\tgeneric_ns\toracle_ns"
    );

    // Capacities small enough that the dense capacity lattice over nine
    // coordinates can exist at all, plus the published headline capacity.
    let capacities = [1u32, 2, 3, 4, 5, 6, 8, 12, 100_000];
    let demand_counts = [1usize, 3, 6, 12, 24, 60, 240, 1_200, 100_000];

    // The general backend is the independent oracle, but on this layout its
    // cost explodes with the capacity and the demand count (minutes at capacity
    // 8 and 1,200 demands). Each capacity gets a bounded oracle budget; once it
    // is spent the remaining oracle cells at that capacity are reported as
    // skipped rather than run, and the generic-versus-bespoke comparison, which
    // is the actual question, still runs on every cell.
    const ORACLE_BUDGET_NS: u128 = 2_000_000_000;

    for &capacity in &capacities {
        let mut oracle_spent_ns = 0u128;
        for &demands in &demand_counts {
            let capacity_vector = [capacity; 9];

            let start = Instant::now();
            let bespoke = azure_lrc_12_2_2_counted(&capacity_vector, demands);
            let bespoke_ns = start.elapsed().as_nanos();

            // The generic path pays instance construction, which is linear in
            // the demand count, so it is inside the timed region on both of the
            // two generic rows. Very large instances are skipped: the point of
            // the comparison is where the generic path can run at all.
            let buildable = demands <= 20_000 && capacity <= 12;

            let (generic_status, generic_repaired, generic_ns) = if buildable {
                let start = Instant::now();
                let outcome = azure_lrc_12_2_2_upgrade_domains(&capacity_vector, demands)
                    .unwrap()
                    .solve_counted_types()
                    .unwrap();
                let elapsed = start.elapsed().as_nanos();
                match outcome {
                    Some(result) => ("certified", result.repaired_count() as i64, elapsed),
                    None => ("declined", -1, elapsed),
                }
            } else {
                ("not-constructible", -1, 0)
            };

            let oracle_run = buildable && oracle_spent_ns < ORACLE_BUDGET_NS;
            let (oracle_repaired, oracle_ns) = if oracle_run {
                let start = Instant::now();
                let result = azure_lrc_12_2_2_upgrade_domains(&capacity_vector, demands)
                    .unwrap()
                    .solve_adaptive()
                    .unwrap();
                let elapsed = start.elapsed().as_nanos();
                oracle_spent_ns += elapsed;
                (result.repaired_count() as i64, elapsed)
            } else {
                (-1, 0)
            };

            let agree = if !buildable {
                "unmeasured"
            } else if !oracle_run {
                match generic_status {
                    "declined" => "declined-oracle-skipped",
                    _ if generic_repaired == bespoke.repaired_count as i64 => "yes-oracle-skipped",
                    _ => "GENERIC-MISMATCH",
                }
            } else if oracle_repaired != bespoke.repaired_count as i64 {
                "BESPOKE-ORACLE-MISMATCH"
            } else if generic_status == "declined" {
                "declined"
            } else if generic_repaired == bespoke.repaired_count as i64 {
                "yes"
            } else {
                "GENERIC-MISMATCH"
            };

            println!(
                "{capacity}\t{demands}\t{}\t{}\t{generic_status}\t{generic_repaired}\t\
                 {oracle_repaired}\t{agree}\t{bespoke_ns}\t{generic_ns}\t{oracle_ns}",
                bespoke.repaired_count, bespoke.totals_checked
            );
        }
    }
}
