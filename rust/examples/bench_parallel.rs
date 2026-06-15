//! Parallel scaling of the *exact scores* path (root-parallel, one TT/worker).
//!
//!     cargo run --release --example bench_parallel
//!
//! Reports min ms for `scores` at several depths and thread counts, plus a full
//! self-play game driven by exact scores (what the CLI does). This is the
//! workload that actually parallelizes -- `best_move` (single rooted search) is
//! already sub-millisecond and stays sequential.

use std::time::Instant;

use othello::engines::Strong;
use othello::game::Engine;
use othello::{best_by_side, init_early_game, Board};

fn midgame(plies: usize) -> Board {
    // Deterministic line a few moves deep (more legal moves => more to fan out).
    let mut e = Strong::with_threads(1);
    let mut b = init_early_game();
    for _ in 0..plies {
        if b.is_terminal() {
            break;
        }
        let mv = e.best_move(&b, Some(6)).unwrap();
        b = b.make_move(mv).unwrap();
    }
    b
}

fn best_ms(f: impl Fn() -> u64, trials: usize) -> f64 {
    let mut best = f64::INFINITY;
    let mut sink = 0u64;
    for _ in 0..trials {
        let t = Instant::now();
        sink ^= f();
        best = best.min(t.elapsed().as_secs_f64() * 1e3);
    }
    std::hint::black_box(sink);
    best
}

fn main() {
    let pos = midgame(20);
    let nmoves = othello::iter_moves(pos.actions()).len();
    println!("midgame position: {nmoves} legal moves\n");

    println!("scores(pos, depth) -- min ms over trials, by thread count:");
    println!(
        "{:>7} {:>9} {:>9} {:>9} {:>9} {:>9}",
        "depth", "t=1", "t=2", "t=4", "t=8", "t=16"
    );
    for depth in [8, 10, 11, 12] {
        print!("{depth:>7}");
        for t in [1usize, 2, 4, 8, 16] {
            let mut e = Strong::with_threads(t);
            e.scores(&pos, Some(depth)).ok(); // warm
            let ms = best_ms(
                || {
                    let mut e = Strong::with_threads(t);
                    e.scores(&pos, Some(depth))
                        .unwrap()
                        .iter()
                        .map(|x| x.1 as u64)
                        .sum()
                },
                15,
            );
            print!(" {ms:>9.3}");
        }
        println!();
    }

    println!("\nfull self-play game via exact scores (what the CLI shows):");
    for t in [1usize, 4, 8, 16] {
        let ms = best_ms(
            || {
                let mut e = Strong::with_threads(t);
                let mut b = init_early_game();
                let mut sink = 0u64;
                while !b.is_terminal() {
                    let scored = e.scores(&b, Some(8)).unwrap();
                    let mv = best_by_side(&b, &scored);
                    b = b.make_move(mv).unwrap();
                    sink ^= b.black;
                }
                sink
            },
            8,
        );
        println!("  threads={t:>2}: {ms:8.2} ms");
    }
}
