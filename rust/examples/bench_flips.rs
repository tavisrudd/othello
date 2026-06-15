//! Validate + microbenchmark `flips_outflank` against the scalar walk
//! (`flips_for_move`).  cargo run --release --example bench_flips

use std::time::Instant;

use othello::core::{flips_for_move, flips_outflank, legal_moves};

struct Lcg(u64);
impl Lcg {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        self.0 = x;
        x.wrapping_mul(0x2545_F491_4F6C_DD1D)
    }
}

fn main() {
    // Build a realistic set of (move, player, opp) from random positions.
    let mut rng = Lcg(0x1234_5678);
    let mut cases: Vec<(u64, u64, u64)> = Vec::new();
    while cases.len() < 1 << 16 {
        let player = rng.next();
        let opp = rng.next() & !player;
        let mut m = legal_moves(player, opp);
        while m != 0 {
            let mv = m & m.wrapping_neg();
            m ^= mv;
            assert_eq!(
                flips_for_move(mv, player, opp),
                flips_outflank(mv, player, opp),
                "mismatch mv={mv:#x} p={player:#x} o={opp:#x}"
            );
            cases.push((mv, player, opp));
        }
    }
    println!(
        "validated outflank == walk over {} legal moves\n",
        cases.len()
    );

    let reps = 400usize;
    let mut acc = 0u64;
    let t = Instant::now();
    for _ in 0..reps {
        for &(mv, p, o) in &cases {
            acc ^= flips_for_move(mv, p, o); // production: the walk
        }
    }
    let walk_ns = t.elapsed().as_nanos() as f64 / (reps * cases.len()) as f64;

    let t = Instant::now();
    for _ in 0..reps {
        for &(mv, p, o) in &cases {
            acc ^= flips_outflank(mv, p, o); // experiment
        }
    }
    let out_ns = t.elapsed().as_nanos() as f64 / (reps * cases.len()) as f64;

    std::hint::black_box(acc);
    println!("walk     flips (production): {walk_ns:6.2} ns/call");
    println!(
        "outflank flips (experiment): {out_ns:6.2} ns/call   ({:.2}x)",
        walk_ns / out_ns
    );
    println!("\nNB: outflank wins this random-board microbench but is ~4% slower");
    println!("in real self-play (short flip runs -> the walk's early-exit wins).");
}
