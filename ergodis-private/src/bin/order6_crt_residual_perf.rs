use std::hint::black_box;

use ergodis_private::order6_crt_residual::{
    eisenstein_energy_target_reachable, Order6EnergyWorkspace, Order6LiftDirectory,
    Order6MarginKey, EISENSTEIN_ENERGY_TARGET, ORDER6_BLOCKS, ORDER6_COLUMNS,
};

fn scalar_energy_target_reachable(
    directory: &Order6LiftDirectory,
    keys: &[[Order6MarginKey; ORDER6_COLUMNS]; ORDER6_BLOCKS],
) -> bool {
    let mut current = [false; EISENSTEIN_ENERGY_TARGET + 1];
    let mut next = [false; EISENSTEIN_ENERGY_TARGET + 1];
    current[0] = true;
    for &key in keys.iter().flatten() {
        next.fill(false);
        for lift in directory.lifts(key).unwrap() {
            let norm = usize::from(lift.residual().norm());
            for total in 0..=EISENSTEIN_ENERGY_TARGET.saturating_sub(norm) {
                next[total + norm] |= current[total];
            }
        }
        std::mem::swap(&mut current, &mut next);
    }
    current[EISENSTEIN_ENERGY_TARGET]
}

fn main() {
    let mode = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "bitset".to_owned());
    let iterations = std::env::args()
        .nth(2)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(500);
    let directory = Order6LiftDirectory::compile().unwrap();
    let mut feasible = Vec::with_capacity(1_666);
    for row0 in 0_i8..=9 {
        for row1 in 0_i8..=9 {
            for column0 in 0_i8..=6 {
                for column1 in 0_i8..=6 {
                    for column2 in 0_i8..=6 {
                        let key = Order6MarginKey::from_signed(
                            [2 * row0 - 9, 2 * row1 - 9],
                            [2 * column0 - 6, 2 * column1 - 6, 2 * column2 - 6],
                        )
                        .unwrap();
                        if !directory.lifts(key).unwrap().is_empty() {
                            feasible.push(key);
                        }
                    }
                }
            }
        }
    }
    assert_eq!(feasible.len(), 1_666);
    let mut keys = [[Order6MarginKey::default(); ORDER6_COLUMNS]; ORDER6_BLOCKS];
    for (slot, key) in keys.iter_mut().flatten().enumerate() {
        *key = feasible[(37 * slot + 101) % feasible.len()];
    }

    let mut checksum = 0_u64;
    match mode.as_str() {
        "bitset" => {
            let mut workspace = Order6EnergyWorkspace::ZERO;
            for round in 0..iterations {
                checksum ^= u64::from(
                    eisenstein_energy_target_reachable(
                        black_box(&directory),
                        black_box(&keys),
                        black_box(&mut workspace),
                    )
                    .unwrap(),
                ) << (round & 31);
            }
        }
        "scalar" => {
            for round in 0..iterations {
                checksum ^= u64::from(scalar_energy_target_reachable(
                    black_box(&directory),
                    black_box(&keys),
                )) << (round & 31);
            }
        }
        _ => panic!("mode must be bitset or scalar"),
    }
    println!("mode={mode} iterations={iterations} checksum={checksum}");
}
