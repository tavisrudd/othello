//! Negative-control benchmark tier (C1038).
//!
//! Six deterministic instances on the two sides of the compiler's current
//! frontier, three predicted to lose and three predicted to win against the
//! incumbent control, chosen by the predeclared classifier in
//! `docs/ergodis-shape-classifier.md`. This driver both emits an instance as
//! canonical JSON, so the control solves exactly the same instance, and runs
//! the ergodis side of the paired comparison.
//!
//! usage:
//!   negative_control_tier emit  <row>
//!   negative_control_tier solve <row> [repetitions]
//!
//! `<row>` is one of L1 L2 L3 W1 W2 W3.

use std::process::ExitCode;

use ergodis::bounded_subset_sum::{
    BoundedSubsetSumBounds, BoundedSubsetSumPlan, MAX_SUBSET_SUM_ITEMS,
    MAX_SUBSET_SUM_REACHABILITY_WORDS, MAX_SUBSET_SUM_TRANSITIONS, MAX_SUBSET_SUM_WIDTH,
};
use ergodis::scheduler::WeightedRepairProblem;
use ergodis::scheduler_dominance::DominanceMode;

/// SplitMix64: a deterministic, seed-reproducible generator so that the ergodis
/// side and the control side construct byte-identical instances.
struct SplitMix64(u64);

impl SplitMix64 {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }

    /// Uniform on `0..bound`, by rejection, so the stream is width-independent.
    fn below(&mut self, bound: u64) -> u64 {
        assert!(bound > 0);
        let zone = u64::MAX - (u64::MAX % bound);
        loop {
            let draw = self.next();
            if draw < zone {
                return draw % bound;
            }
        }
    }
}

enum Instance {
    SubsetSum {
        weights: Vec<i64>,
        target: i64,
    },
    Scheduler {
        capacities: Vec<u32>,
        families: Vec<Vec<Vec<u32>>>,
        grading: Option<Vec<u32>>,
    },
}

/// L1: generic weights with a dynamic-programming width near one million. On
/// the not-yet-compiled side: the exact state is the arithmetic range of the
/// data rather than its structure.
fn instance_l1() -> Instance {
    let mut rng = SplitMix64(0x0C10_3801);
    let mut weights: Vec<i64> = (0..60).map(|_| 1 + rng.below(32_000) as i64).collect();
    weights.sort_unstable();
    // A target that is attainable by construction: the sum of every third item.
    let target = weights.iter().step_by(3).sum();
    Instance::SubsetSum { weights, target }
}

/// L3: the same kernel one magnitude further out, past the compiled width cap.
/// The predicted outcome is a declared-bounds refusal, which is the boundary
/// this tier exists to publish.
fn instance_l3() -> Instance {
    let mut rng = SplitMix64(0x0C10_3803);
    let mut weights: Vec<i64> = (0..40).map(|_| 1 + rng.below(200_000) as i64).collect();
    weights.sort_unstable();
    let target = weights.iter().step_by(3).sum();
    Instance::SubsetSum { weights, target }
}

/// W1: the same kernel on the compiles-today side. Items drawn from six distinct
/// small weights: a repeated interface, so the compiled width is set by the
/// structure rather than by the magnitude of the data.
fn instance_w1() -> Instance {
    let alphabet = [3_i64, 5, 7, 11, 13, 17];
    let mut rng = SplitMix64(0x0C10_3811);
    // Sixty items keeps the exact subset count inside `u64`; the win comes from
    // the six-symbol alphabet, not from the item count.
    let mut weights: Vec<i64> = (0..60)
        .map(|_| alphabet[rng.below(alphabet.len() as u64) as usize])
        .collect();
    weights.sort_unstable();
    let target = weights.iter().step_by(2).sum();
    Instance::SubsetSum { weights, target }
}

/// L2: six independent resources with generic wide loads and no grading. The
/// Pareto frontier is the state, and it grows with the load range.
fn instance_l2() -> Instance {
    let mut rng = SplitMix64(0x0C10_3802);
    let resources = 6_usize;
    let demands = 18_usize;
    let options = 4_usize;
    let families: Vec<Vec<Vec<u32>>> = (0..demands)
        .map(|_| {
            (0..options)
                .map(|_| (0..resources).map(|_| 1 + rng.below(9) as u32).collect())
                .collect()
        })
        .collect();
    // Capacities admit roughly two thirds of the demands, so the optimum is
    // interior rather than "repair everything".
    let capacities = vec![40_u32; resources];
    Instance::Scheduler {
        capacities,
        families,
        grading: None,
    }
}

/// W2: the balanced graded profile. Every option carries the same weighted
/// mass, so the positive-grading certificate applies and dominance pruning is
/// provably unnecessary: a linear conservation law in the sense of the
/// classifier.
fn instance_w2() -> Instance {
    let mut rng = SplitMix64(0x0C10_3812);
    let weights = vec![1_u32, 2];
    let mass = 6_u32;
    let demands = 400_usize;
    let families: Vec<Vec<Vec<u32>>> = (0..demands)
        .map(|_| {
            (0..4)
                .map(|_| graded_option(&mut rng, &weights, mass))
                .collect()
        })
        .collect();
    Instance::Scheduler {
        capacities: vec![120, 120],
        families,
        grading: Some(weights),
    }
}

/// Draws a load vector whose weighted mass is exactly `mass`.
fn graded_option(rng: &mut SplitMix64, weights: &[u32], mass: u32) -> Vec<u32> {
    loop {
        let a = rng.below(u64::from(mass) + 1) as u32;
        let remaining = mass - a * weights[0];
        if a * weights[0] > mass {
            continue;
        }
        if !remaining.is_multiple_of(weights[1]) {
            continue;
        }
        return vec![a, remaining / weights[1]];
    }
}

/// W3: a repeated interface at scale. Four thousand demands over six distinct
/// demand types and two resources; the compiled model has six option types.
fn instance_w3() -> Instance {
    let types: [[[u32; 2]; 3]; 6] = [
        [[1, 0], [0, 2], [2, 1]],
        [[2, 0], [0, 1], [1, 1]],
        [[0, 3], [3, 0], [1, 2]],
        [[1, 1], [2, 2], [0, 1]],
        [[3, 1], [1, 0], [0, 2]],
        [[2, 2], [0, 3], [1, 1]],
    ];
    let mut rng = SplitMix64(0x0C10_3813);
    let families: Vec<Vec<Vec<u32>>> = (0..4_000)
        .map(|_| {
            let chosen = &types[rng.below(6) as usize];
            chosen.iter().map(|load| load.to_vec()).collect()
        })
        .collect();
    Instance::Scheduler {
        capacities: vec![150, 150],
        families,
        grading: None,
    }
}

fn instance(row: &str) -> Instance {
    match row {
        "L1" => instance_l1(),
        "L2" => instance_l2(),
        "L3" => instance_l3(),
        "W1" => instance_w1(),
        "W2" => instance_w2(),
        "W3" => instance_w3(),
        other => panic!("unknown negative-control row: {other}"),
    }
}

fn emit(row: &str) {
    let value = match instance(row) {
        Instance::SubsetSum { weights, target } => serde_json::json!({
            "row": row,
            "kind": "subset_sum",
            "weights": weights,
            "target": target,
        }),
        Instance::Scheduler {
            capacities,
            families,
            grading,
        } => serde_json::json!({
            "row": row,
            "kind": "scheduler",
            "capacities": capacities,
            "families": families,
            "grading": grading,
        }),
    };
    println!("{value}");
}

fn peak_rss_kib() -> u64 {
    std::fs::read_to_string("/proc/self/status")
        .ok()
        .and_then(|status| {
            status
                .lines()
                .find_map(|line| line.strip_prefix("VmHWM:"))
                .and_then(|value| value.split_whitespace().next().map(str::to_owned))
        })
        .and_then(|value| value.parse().ok())
        .unwrap_or(0)
}

fn subset_sum_bounds() -> BoundedSubsetSumBounds {
    BoundedSubsetSumBounds {
        maximum_items: MAX_SUBSET_SUM_ITEMS,
        maximum_sum_width: MAX_SUBSET_SUM_WIDTH,
        maximum_reachability_words: MAX_SUBSET_SUM_REACHABILITY_WORDS,
        maximum_transitions: MAX_SUBSET_SUM_TRANSITIONS,
    }
}

fn solve(row: &str, repetitions: u32) -> ExitCode {
    let started = std::time::Instant::now();
    let mut status = "ok";
    let mut answer = 0_i64;
    let mut work = 0_u64;
    let mut representation = 0_u64;
    let mut detail = String::new();
    let mut certificate_bytes = 0_u64;
    let mut replay_ns = 0_u128;
    // C1049: certified dominance pruning counters, null for non-scheduler rows.
    let mut dominance = serde_json::Value::Null;

    match instance(row) {
        Instance::SubsetSum { weights, target } => {
            match BoundedSubsetSumPlan::compile(&weights, target, subset_sum_bounds()) {
                Ok(plan) => {
                    representation = plan.transition_bound();
                    let mut workspace = plan.workspace();
                    let mut witness = vec![0_u64; plan.witness_words()];
                    for _ in 0..repetitions {
                        let count = plan
                            .solve_into(&mut workspace, &mut witness)
                            .expect("compiled bounded subset-sum plan solves");
                        answer = i64::from(count > 0);
                        work = work.wrapping_add(count.min(1));
                    }
                    // The certificate is the selected-item bitmask; the
                    // independent replay adds the selected weights and compares
                    // the sum with the target, touching neither the plan nor the
                    // dynamic-programming state.
                    certificate_bytes = 8 * witness.len() as u64;
                    let replay_started = std::time::Instant::now();
                    let mut sum = 0_i64;
                    for (item, &weight) in weights.iter().enumerate() {
                        if witness[item / 64] >> (item % 64) & 1 == 1 {
                            sum += weight;
                        }
                    }
                    assert_eq!(sum, target, "independent subset-sum replay disagrees");
                    replay_ns = replay_started.elapsed().as_nanos();
                }
                Err(error) => {
                    status = "declined";
                    detail = error.to_string();
                }
            }
        }
        Instance::Scheduler {
            capacities,
            families,
            grading,
        } => {
            let problem = match &grading {
                Some(weights) => WeightedRepairProblem::from_families_with_positive_grading(
                    &capacities,
                    &families,
                    weights,
                ),
                None => WeightedRepairProblem::from_families(&capacities, &families),
            };
            match problem {
                Ok(mut problem) => {
                    // C1049: the dominance relation is selectable so one binary
                    // can serve both sides of an in-process A/B.
                    problem.set_dominance_mode(
                        match std::env::var("ERGODIS_DOMINANCE_MODE").as_deref() {
                            Ok("legacy") => DominanceMode::Legacy,
                            Ok("clamped") => DominanceMode::ClampedSuffix,
                            _ => DominanceMode::Exact,
                        },
                    );
                    let mut last = None;
                    for _ in 0..repetitions {
                        let result = problem
                            .solve_adaptive()
                            .expect("compiled weighted repair problem solves");
                        answer = result.repaired_count() as i64;
                        work = work.wrapping_add(result.transitions_examined);
                        representation = representation.max(u64::from(result.peak_pareto_states));
                        last = Some(result);
                    }
                    // The certificate is the assignment: one demand index and
                    // one load vector per repaired demand. The independent
                    // replay re-adds the loads, checks every capacity, and
                    // checks that each load vector is an option of its demand.
                    if let Some(result) = last {
                        certificate_bytes = result
                            .assignment
                            .iter()
                            .map(|choice| 4 + 4 * choice.loads.len() as u64)
                            .sum();
                        let replay_started = std::time::Instant::now();
                        let mut totals = vec![0_u64; capacities.len()];
                        for choice in result.assignment.iter() {
                            let options = &families[choice.demand as usize];
                            assert!(
                                options.iter().any(|option| option[..] == choice.loads[..]),
                                "replayed choice is not an option of its demand"
                            );
                            for (total, &load) in totals.iter_mut().zip(choice.loads.iter()) {
                                *total += u64::from(load);
                            }
                        }
                        for (total, &capacity) in totals.iter().zip(capacities.iter()) {
                            assert!(
                                *total <= u64::from(capacity),
                                "replayed loads exceed capacity"
                            );
                        }
                        // C1049: the dominance certificate is replayed here too.
                        // The checker re-evaluates every recorded comparison
                        // from the records alone; it never re-solves.
                        let dominance_started = std::time::Instant::now();
                        let verified = result
                            .replay_dominance()
                            .expect("every dominance witness replays");
                        let dominance_replay_ns = dominance_started.elapsed().as_nanos();
                        assert_eq!(
                            verified, result.dominance.pruned_states,
                            "the certificate must account for every pruned state"
                        );
                        certificate_bytes += result.dominance_witness_bytes();
                        dominance = serde_json::json!({
                            "pruned_states": result.dominance.pruned_states,
                            "comparisons": result.dominance.comparisons,
                            "budget_exhausted": result.dominance.budget_exhausted,
                            "witness_capacity_exhausted":
                                result.dominance.witness_capacity_exhausted,
                            "witnesses": result.dominance_witnesses.len(),
                            "witness_bytes": result.dominance_witness_bytes(),
                            "verified": verified,
                            "replay_ns": dominance_replay_ns.to_string(),
                        });
                        replay_ns = replay_started.elapsed().as_nanos();
                    }
                }
                Err(error) => {
                    status = "declined";
                    detail = error.to_string();
                }
            }
        }
    }

    let elapsed_ns = started.elapsed().as_nanos();
    let record = serde_json::json!({
        "row": row,
        "side": "ergodis",
        "status": status,
        "detail": detail,
        "repetitions": repetitions,
        "elapsed_ns": elapsed_ns.to_string(),
        "answer": answer,
        "work": work,
        "representation": representation,
        "certificate_bytes": certificate_bytes,
        "replay_ns": replay_ns.to_string(),
        "peak_rss_kib": peak_rss_kib(),
        "dominance": dominance,
    });
    println!("{record}");
    ExitCode::SUCCESS
}

fn main() -> ExitCode {
    let arguments: Vec<String> = std::env::args().skip(1).collect();
    match arguments.first().map(String::as_str) {
        Some("emit") => {
            let row = arguments.get(1).expect("emit needs a row");
            emit(row);
            ExitCode::SUCCESS
        }
        Some("solve") => {
            let row = arguments.get(1).expect("solve needs a row");
            let repetitions = arguments
                .get(2)
                .map(|value| value.parse().expect("repetitions must be an integer"))
                .unwrap_or(1);
            solve(row, repetitions)
        }
        _ => {
            eprintln!("usage: negative_control_tier (emit|solve) <row> [repetitions]");
            ExitCode::from(2)
        }
    }
}
