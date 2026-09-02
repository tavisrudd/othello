use std::hint::black_box;

use ergodis_private::q29_mod9_generator::{generate_q29_mod9_rows, Q29Mod9GeneratorWorkspace};

fn main() {
    let repetitions = std::env::args()
        .nth(1)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(10_000);
    let mut workspace = Q29Mod9GeneratorWorkspace::new().expect("fixed field setup");
    let mut checksum = 0_u64;
    for seed in 1..=repetitions {
        let generated = generate_q29_mod9_rows(black_box(seed), &mut workspace)
            .expect("constructive mod9 shell generator");
        checksum = checksum.wrapping_add(u64::from(generated.rows[3][28]));
    }
    println!("repetitions={repetitions} checksum={checksum}");
    println!("workspace_bytes=2432");
    println!("provenance=ProvedStructuralGenerator; every output direct-replayed mod9");
}
