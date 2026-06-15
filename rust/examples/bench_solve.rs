//! Time the exact endgame solver (`--depth full`) at several empty counts.
//!     cargo run --release --example bench_solve

use std::time::Instant;

use othello::engines::Strong;
use othello::game::Engine;
use othello::{init_early_game, Board};

/// Play forward from the opening to a position with `target_empties` empties,
/// using a shallow search so it's a realistic (not random) endgame.
fn position_with_empties(target_empties: u32) -> Board {
    let mut e = Strong::with_threads(1);
    let mut b = init_early_game();
    while (!(b.black | b.white)).count_ones() > target_empties && !b.is_terminal() {
        let mv = e.best_move(&b, Some(6)).unwrap();
        b = b.make_move(mv).unwrap();
    }
    b
}

fn main() {
    println!("exact solve (depth=full) by empties remaining:");
    // 20+ empties run into seconds (exponential); 18 (~1 s) is a quick cap.
    for empties in [10u32, 12, 14, 16, 18] {
        let b = position_with_empties(empties);
        let actual = (!(b.black | b.white)).count_ones();
        // warm + correctness sample
        let mut e = Strong::with_threads(1);
        let v = e.value(&b, None);
        // timed (fresh engine = cold TT)
        let mut best = f64::INFINITY;
        for _ in 0..3 {
            let mut e = Strong::with_threads(1);
            let t = Instant::now();
            let v2 = e.value(&b, None);
            assert_eq!(v, v2);
            best = best.min(t.elapsed().as_secs_f64() * 1e3);
        }
        println!("  {actual:>2} empties: {best:9.3} ms   (exact value {v:+})");
    }
}
