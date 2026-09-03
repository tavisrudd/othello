//! C1060 phase 1: per-layer census of the L2 layered dynamic program.
//!
//! Reports, for every layer of the six-resource L2 instance, how many distinct
//! reachable load states the layered dynamic program carries, and how many of
//! them survive a *valid* Lagrangian completion bound at the fixed dual vector
//! the C1060 certified route uses. The survivor column is the realizable
//! pruning of route (a); it is a lower bound on the ideal pruning ceiling,
//! because the Lagrangian bound never underestimates the optimal completion.
//!
//! usage: c1060_l2_diagnosis

use std::collections::HashMap;

use ergodis::scheduler_bound::{LagrangianDual, DUAL_DENOMINATOR};

/// Rebuilds the L2 instance byte-identically to `negative_control_tier`.
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

fn l2() -> (Vec<u32>, Vec<Vec<Vec<u32>>>) {
    let mut rng = SplitMix64(0x0C10_3802);
    let families: Vec<Vec<Vec<u32>>> = (0..18)
        .map(|_| {
            (0..4)
                .map(|_| (0..6).map(|_| 1 + rng.below(9) as u32).collect())
                .collect()
        })
        .collect();
    (vec![40_u32; 6], families)
}

fn pack(loads: &[u32]) -> u64 {
    loads
        .iter()
        .fold(0_u64, |key, &load| key << 8 | u64::from(load))
}

fn main() {
    let (capacities, families) = l2();
    let width = capacities.len();
    let dual = LagrangianDual::fit(&capacities, &families, 3_000).expect("L2 is inside the bounds");
    let optimum = 10_u32;

    println!(
        "dual y (numerators over {DUAL_DENOMINATOR}): {:?}",
        dual.multipliers()
    );
    println!(
        "root bound numerator {} = {:.6}, floor {}",
        dual.bound_numerator(&capacities, 0),
        dual.bound_numerator(&capacities, 0) as f64 / DUAL_DENOMINATOR as f64,
        dual.bound(&capacities, 0)
    );
    println!("layer  states  survivors  cut_fraction");

    // layer 0 carries the empty schedule only
    let mut layer: HashMap<u64, u32> = HashMap::new();
    layer.insert(pack(&vec![0_u32; width]), 0);
    let mut unpacked = vec![0_u32; width];
    let mut residual = vec![0_u32; width];

    for (demand, options) in families.iter().enumerate() {
        let mut next: HashMap<u64, u32> = HashMap::new();
        for (&key, &repairs) in &layer {
            next.entry(key)
                .and_modify(|best| *best = (*best).max(repairs))
                .or_insert(repairs);
            for option in options {
                let mut feasible = true;
                let mut moved = 0_u64;
                for coordinate in 0..width {
                    let used = (key >> (8 * (width - 1 - coordinate)) & 0xff) as u32;
                    let sum = used + option[coordinate];
                    if sum > capacities[coordinate] {
                        feasible = false;
                        break;
                    }
                    moved = moved << 8 | u64::from(sum);
                }
                if !feasible {
                    continue;
                }
                next.entry(moved)
                    .and_modify(|best| *best = (*best).max(repairs + 1))
                    .or_insert(repairs + 1);
            }
        }

        // Survivors under the Lagrangian completion bound: a state is kept
        // only if its repairs plus the certified bound on the remaining
        // demands can still reach the optimum.
        let mut survivors = 0_u64;
        for (&key, &repairs) in &next {
            for coordinate in 0..width {
                unpacked[coordinate] = (key >> (8 * (width - 1 - coordinate)) & 0xff) as u32;
                residual[coordinate] = capacities[coordinate] - unpacked[coordinate];
            }
            if repairs + dual.bound(&residual, demand + 1) >= optimum {
                survivors += 1;
            }
        }

        let states = next.len() as u64;
        println!(
            "{:5}  {states:9}  {survivors:9}  {:.4}",
            demand + 1,
            1.0 - survivors as f64 / states as f64
        );
        layer = next;
    }
}
