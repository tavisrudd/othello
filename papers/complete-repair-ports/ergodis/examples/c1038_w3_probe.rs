//! Diagnostic for the C1038 W3 margin: does the weighted repair scheduler
//! quotient identical demand types?
//!
//! Scales the demand count and the capacity of the W3 shape independently. The
//! exact columns — transitions examined, peak Pareto states, repaired count and
//! the number of distinct demand types — are deterministic and are written to
//! standard output as the canonical artifact. Wall times are host-dependent and
//! go to standard error, so the tracked artifact does not drift between runs.

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
    let types: [[[u32; 2]; 3]; 6] = [
        [[1, 0], [0, 2], [2, 1]],
        [[2, 0], [0, 1], [1, 1]],
        [[0, 3], [3, 0], [1, 2]],
        [[1, 1], [2, 2], [0, 1]],
        [[3, 1], [1, 0], [0, 2]],
        [[2, 2], [0, 3], [1, 1]],
    ];
    println!("demands\tcapacity\ttransitions\tpeak_states\trepaired\tdistinct_types");
    for &(demands, capacity) in &[
        (250_usize, 150_u32),
        (500, 150),
        (1_000, 150),
        (2_000, 150),
        (4_000, 150),
        (4_000, 50),
        (4_000, 100),
        (4_000, 200),
    ] {
        let mut rng = SplitMix64(0x0C10_3813);
        let mut seen = std::collections::BTreeSet::new();
        let families: Vec<Vec<Vec<u32>>> = (0..demands)
            .map(|_| {
                let index = rng.below(6) as usize;
                seen.insert(index);
                types[index].iter().map(|load| load.to_vec()).collect()
            })
            .collect();
        let problem =
            WeightedRepairProblem::from_families(&[capacity, capacity], &families).unwrap();
        let started = std::time::Instant::now();
        let answer = problem.solve_adaptive().unwrap();
        let elapsed = started.elapsed().as_secs_f64() * 1e3;
        println!(
            "{demands}\t{capacity}\t{}\t{}\t{}\t{}",
            answer.transitions_examined,
            answer.peak_pareto_states,
            answer.repaired_count(),
            seen.len()
        );
        eprintln!("{demands}\t{capacity}\t{elapsed:.2} ms");
    }
}
