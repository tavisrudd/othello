//! Interleaved A/B of the three dominance relations on the C1038 L2 shape.
//!
//! The L2 row loses to CP-SAT by four orders of magnitude, and profiling the
//! retained pre-change binary shows the whole of that time is the all-pairs
//! Pareto scan that maintains the frontier, not the search. This driver scales
//! the demand count and measures the same instance under each relation:
//!
//! * `legacy` — the unchanged all-pairs scan, the control;
//! * `exact` — the certified scan deciding the same relation;
//! * `clamped` — the certified scan deciding the suffix-clamped relation.
//!
//! Rounds are interleaved and the relation order is rotated per round, so drift
//! in host state is shared rather than attributed to one side. Raw samples are
//! streamed as they complete; exact columns are the artifact and wall times are
//! host-dependent.
//!
//! usage: c1049_l2_dominance_ab [rounds] [max_demands]

use ergodis::scheduler::WeightedRepairProblem;
use ergodis::scheduler_dominance::DominanceMode;

struct SplitMix64(u64);

impl SplitMix64 {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }

    fn below(&mut self, bound: u64) -> u64 {
        let zone = u64::MAX - (u64::MAX % bound);
        loop {
            let draw = self.next();
            if draw < zone {
                return draw % bound;
            }
        }
    }
}

/// Builds the L2 shape truncated to `demands`. The generator stream is the L2
/// stream, so a smaller row is a genuine prefix of the measured instance rather
/// than an independent draw.
fn l2_shape(demands: usize) -> WeightedRepairProblem {
    let resources = 6_usize;
    let options = 4_usize;
    let capacity = 40_u32;
    let mut rng = SplitMix64(0x0C10_3802);
    let families: Vec<Vec<Vec<u32>>> = (0..demands)
        .map(|_| {
            (0..options)
                .map(|_| (0..resources).map(|_| 1 + rng.below(9) as u32).collect())
                .collect()
        })
        .collect();
    WeightedRepairProblem::from_families(&vec![capacity; resources], &families).unwrap()
}

fn peak_rss_kib() -> u64 {
    std::fs::read_to_string("/proc/self/status")
        .ok()
        .and_then(|status| {
            status
                .lines()
                .find_map(|line| line.strip_prefix("VmHWM:"))
                .and_then(|value| value.split_whitespace().next()?.parse().ok())
        })
        .unwrap_or(0)
}

fn main() {
    let arguments: Vec<String> = std::env::args().skip(1).collect();
    let rounds: usize = arguments
        .first()
        .map(|value| value.parse().expect("rounds must be an integer"))
        .unwrap_or(3);
    let max_demands: usize = arguments
        .get(1)
        .map(|value| value.parse().expect("max_demands must be an integer"))
        .unwrap_or(18);

    let modes = [
        ("legacy", DominanceMode::Legacy),
        ("exact", DominanceMode::Exact),
        ("clamped", DominanceMode::ClampedSuffix),
    ];
    // A per-cell wall-clock ceiling: a relation that exceeds it at one size is
    // not run at any larger size, and its absence is reported as a lower bound
    // rather than as a completed ratio.
    let cell_budget = std::time::Duration::from_secs(600);
    // Largest size still measured for each relation; a relation that blows the
    // budget at one size is skipped only at larger sizes, never at smaller ones.
    let mut size_ceiling = [usize::MAX; 3];

    println!(
        "round\tdemands\tmode\telapsed_ns\trepaired\ttransitions\tpeak_states\tpruned\tcomparisons\twitness_bytes\tverified\tpeak_rss_kib"
    );
    for round in 0..rounds {
        let mut sizes: Vec<usize> = (8..=max_demands).step_by(2).collect();
        // Rotate the size order too, so the largest cell is not always last.
        let rotation = round % sizes.len().max(1);
        sizes.rotate_left(rotation);
        for demands in sizes {
            for offset in 0..modes.len() {
                // Rotate the relation order per round.
                let index = (offset + round) % modes.len();
                let (name, mode) = modes[index];
                if demands > size_ceiling[index] {
                    continue;
                }
                let problem = l2_shape(demands).with_dominance_mode(mode);
                let started = std::time::Instant::now();
                let answer = problem.solve().expect("the L2 shape solves");
                let elapsed = started.elapsed();
                let verified = answer.replay_dominance().expect("the certificate replays");
                assert_eq!(
                    verified, answer.dominance.pruned_states,
                    "the certificate must account for every pruned state"
                );
                assert_eq!(
                    answer.dominance.budget_exhausted, 0,
                    "the comparison budget must not bind"
                );
                assert_eq!(
                    answer.dominance.witness_capacity_exhausted, 0,
                    "the witness buffer must not fill"
                );
                println!(
                    "{round}\t{demands}\t{name}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}",
                    elapsed.as_nanos(),
                    answer.repaired_count(),
                    answer.transitions_examined,
                    answer.peak_pareto_states,
                    answer.dominance.pruned_states,
                    answer.dominance.comparisons,
                    answer.dominance_witness_bytes(),
                    verified,
                    peak_rss_kib(),
                );
                if elapsed > cell_budget {
                    eprintln!(
                        "retiring {name} after {demands} demands: {:.1} s exceeds the cell budget",
                        elapsed.as_secs_f64()
                    );
                    size_ceiling[index] = size_ceiling[index].min(demands);
                }
            }
        }
    }
}
