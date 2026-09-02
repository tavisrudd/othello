use ergodis_private::{
    q29_inventory_scope::{
        census_q29_inventory_scopes, sample_q29_outer_profile_seed, Q29InventoryWorkspace,
        Q29OuterProfilePolicy,
    },
    q29_mod3_norm::{ambient_mod3_reduction_ratio, extract_q29_modular_correlation},
};

fn main() {
    let inventory_roots = std::env::args()
        .nth(1)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(16);
    let permutations_per_root = std::env::args()
        .nth(2)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(65_536);
    let kernel_repetitions = std::env::args()
        .nth(3)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(0);
    let mut workspace = Q29InventoryWorkspace::new();
    census_q29_inventory_scopes(&mut workspace).expect("bounded inventory census");
    let mut random = 0x9e37_79b9_7f4a_7c15_u64;
    let mut mod3_prefix = [0_u64; 15];
    let mut mod9_prefix = [0_u64; 15];
    let mut last_rows = [[0_i8; 29]; 4];
    for _ in 0..inventory_roots {
        let seed = sample_q29_outer_profile_seed(
            &mut workspace,
            &mut random,
            Q29OuterProfilePolicy::MagnitudeMultiplicity,
        )
        .expect("typed unrestricted inventory sample");
        last_rows = seed.rows;
        for _ in 0..permutations_per_root {
            for row in &mut last_rows {
                let left = (next_random(&mut random) % 29) as usize;
                let right = (next_random(&mut random) % 29) as usize;
                row.swap(left, right);
            }
            let residues = extract_q29_modular_correlation(&last_rows).expect("direct replay");
            let mod3 = residues.mod3_residues();
            let mod9 = residues.mod9_residues();
            let mut pass3 = true;
            let mut pass9 = true;
            for shift in 0..15 {
                let expected = u8::from(shift == 0);
                pass3 &= mod3[shift] == expected;
                pass9 &= mod9[shift] == expected;
                mod3_prefix[shift] += u64::from(pass3);
                mod9_prefix[shift] += u64::from(pass9);
            }
        }
    }
    let mut checksum = 0_u64;
    for _ in 0..kernel_repetitions {
        let residues = extract_q29_modular_correlation(&last_rows).expect("kernel replay");
        checksum = checksum.wrapping_add(u64::from(residues.mod9_residues()[14]));
    }
    let (numerator, denominator) = ambient_mod3_reduction_ratio();
    println!("inventory_roots={inventory_roots}");
    println!("permutations_per_root={permutations_per_root}");
    println!("samples={}", inventory_roots * permutations_per_root);
    println!("mod3_prefix={mod3_prefix:?}");
    println!("mod9_prefix={mod9_prefix:?}");
    println!("ambient_mod3_reduction={numerator}/{denominator}");
    println!("kernel_repetitions={kernel_repetitions} checksum={checksum}");
    println!("sample_provenance=ObservedSampled; no negative coverage authority");
}

fn next_random(random: &mut u64) -> u64 {
    *random ^= *random << 13;
    *random ^= *random >> 7;
    *random ^= *random << 17;
    *random
}
