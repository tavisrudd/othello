//! Plays N full depth-8 self-play games via `best_move` (no I/O), for profiling:
//!     cargo build --release --example profile_game
//!     perf record -g target/release/examples/profile_game 20
//!     perf report --stdio | head -40

use othello::engines::make_engine;
use othello::init_early_game;

fn main() {
    let games: usize = std::env::args()
        .nth(1)
        .and_then(|s| s.parse().ok())
        .unwrap_or(20);
    let depth: i32 = std::env::args()
        .nth(2)
        .and_then(|s| s.parse().ok())
        .unwrap_or(8);
    let mut sink = 0u64;
    for _ in 0..games {
        let mut engine = make_engine("strong").unwrap();
        let mut b = init_early_game();
        while !b.is_terminal() {
            let mv = engine.best_move(&b, Some(depth)).unwrap();
            b = b.make_move(mv).unwrap();
            sink ^= b.black ^ b.white;
        }
    }
    println!("{sink}");
}
