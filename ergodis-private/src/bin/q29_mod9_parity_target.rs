#[path = "../q29_mod9_parity_target.rs"]
mod parity_target;

mod q29_mod9_lift {
    pub use ergodis_private::q29_mod9_lift::*;
}

mod q29_parity_support {
    pub use ergodis_private::q29_parity_support::*;
}

use ergodis_private::{
    q29_mod9_generator::{generate_q29_mod9_rows_low_lift, Q29Mod9GeneratorWorkspace},
    q29_mod9_lift::{compile_q29_mod9_lift_fibre, Q29Mod9LiftWorkspace},
};
use parity_target::{sample_parity_targeted_q29_mod9_lift, Q29ParityTargetWorkspace};

fn main() {
    let shells = std::env::args()
        .nth(1)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(10_000);
    let mut generator = Q29Mod9GeneratorWorkspace::new().expect("fixed field setup");
    let mut lift = Q29Mod9LiftWorkspace::new();
    let mut parity = Q29ParityTargetWorkspace::new();
    let mut liftable = 0_u64;
    let mut hits = 0_u64;
    let mut checksum = 0_u64;
    for seed in 1..=shells {
        let generated = generate_q29_mod9_rows_low_lift(seed, &mut generator).expect("mod9 replay");
        let count = compile_q29_mod9_lift_fibre(&generated.rows, &mut lift).expect("lift compile");
        if count.count == 0 {
            continue;
        }
        liftable += 1;
        let mut random = seed ^ 0x6a09_e667_f3bc_c909;
        if let Some(witness) =
            sample_parity_targeted_q29_mod9_lift(&generated.rows, &lift, &mut parity, &mut random)
                .expect("targeted replay")
        {
            hits += 1;
            checksum = checksum.wrapping_add(witness.rows[0][0] as u8 as u64);
        }
    }
    println!("shells={shells}");
    println!("liftable_fibres={liftable}");
    println!("parity_target_hits={hits}");
    println!("target_workspace_bytes={}", parity.workspace_bytes());
    println!("checksum={checksum}");
    println!("provenance=ObservedBoundedPool; misses have no negative authority; positives direct-replayed");
}

#[cfg(test)]
mod tests {
    use super::*;
    use ergodis_private::{
        q29_mod9_lift::replay_q29_mod9_lift,
        q29_parity_support::q29_support_quartet_satisfies_parity,
    };

    #[test]
    fn bounded_join_finds_and_directly_replays_constructed_fibre() {
        let mut rows = [[0_i8; 29]; 4];
        rows[0][0] = 1;
        for (pair, magnitude) in [8, 8, 8, 6, 4, 2, 2].into_iter().enumerate() {
            rows[0][1 + 2 * pair] = magnitude;
            rows[0][2 + 2 * pair] = -magnitude;
        }
        let residues = rows.map(|row| row.map(|value| value.rem_euclid(9) as u8));
        let mut lift = Q29Mod9LiftWorkspace::new();
        assert_ne!(
            compile_q29_mod9_lift_fibre(&residues, &mut lift)
                .unwrap()
                .count,
            0
        );
        let mut parity = Q29ParityTargetWorkspace::new();
        let mut random = 0x510e_527f_ade6_82d1;
        let witness =
            sample_parity_targeted_q29_mod9_lift(&residues, &lift, &mut parity, &mut random)
                .unwrap()
                .expect("bounded join hit");
        assert!(replay_q29_mod9_lift(&residues, &witness));
        let supports = witness.rows.map(|row| {
            row.iter()
                .enumerate()
                .fold(0_u32, |word, (column, &value)| {
                    word | (u32::from(value & 1 != 0) << column)
                })
        });
        assert!(q29_support_quartet_satisfies_parity(supports));
    }
}
