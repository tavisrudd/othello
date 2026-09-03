//! Diagnostic for the C1038 L2 loss: is the 137-second solve caused by the size
//! of the search, or by the per-state cost of maintaining a six-dimensional
//! Pareto frontier?
//!
//! Scales the demand count of the L2 shape and reports transitions examined,
//! peak frontier size, and nanoseconds per examined transition. If transitions
//! grow linearly while time grows quadratically in the frontier, the cost is
//! dominance maintenance rather than search.
//!
//! Exact columns go to standard output as the canonical artifact; wall times,
//! which are host-dependent, go to standard error.

use ergodis::scheduler::WeightedRepairProblem;

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

fn main() {
    let resources = 6_usize;
    let options = 4_usize;
    let capacity = 40_u32;
    println!("demands\ttransitions\tpeak_states\trepaired");
    for demands in [8_usize, 10, 12, 14, 16, 18] {
        // The same stream prefix as the L2 instance, so smaller rows are
        // genuine prefixes of the measured instance rather than new draws.
        let mut rng = SplitMix64(0x0C10_3802);
        let families: Vec<Vec<Vec<u32>>> = (0..demands)
            .map(|_| {
                (0..options)
                    .map(|_| (0..resources).map(|_| 1 + rng.below(9) as u32).collect())
                    .collect()
            })
            .collect();
        let problem =
            WeightedRepairProblem::from_families(&vec![capacity; resources], &families).unwrap();
        let started = std::time::Instant::now();
        let answer = problem.solve_adaptive().unwrap();
        let elapsed = started.elapsed();
        println!(
            "{demands}\t{}\t{}\t{}",
            answer.transitions_examined,
            answer.peak_pareto_states,
            answer.repaired_count()
        );
        let per_transition = elapsed.as_nanos() as f64 / answer.transitions_examined.max(1) as f64;
        eprintln!(
            "{demands}\t{:.2} ms\t{per_transition:.0} ns/transition",
            elapsed.as_secs_f64() * 1e3
        );
    }
}
