//! Micro-benchmark for the search. Default: a depth-8 `best_move` from the
//! opening with the `strong` engine (a fresh transposition table each trial).
//!
//!     cargo run --release --example bench            # strong, depth 8
//!     cargo run --release --example bench -- 10      # depth 10
//!     cargo run --release --example bench -- 8 ordered
//!
//! Reports min / median / mean over several trials. The min is the figure to
//! quote (least noise from scheduling / frequency scaling).

use std::time::Instant;

use othello::engines::make_engine;
use othello::search::search_strong;
use othello::{init_early_game, TranspositionTable};

fn main() {
    let mut argv = std::env::args().skip(1);
    let depth: i32 = argv.next().and_then(|s| s.parse().ok()).unwrap_or(8);
    let engine_name = argv.next().unwrap_or_else(|| "strong".into());
    let trials = 25usize;

    let board = init_early_game();

    // --- best_move (what the CLI pays per move): searches each root child ---
    let mut times = Vec::with_capacity(trials);
    let mut last = 0u64;
    for _ in 0..trials {
        let mut engine = make_engine(&engine_name).expect("engine");
        let t = Instant::now();
        let mv = engine.best_move(&board, Some(depth)).expect("move");
        times.push(t.elapsed().as_secs_f64() * 1e3);
        last = mv;
    }
    report(
        &format!("{engine_name} best_move(opening, depth {depth})"),
        &mut times,
    );
    println!("  -> best move bit = {last:#x}");

    // --- full self-play game: every move searched to `depth` (README metric) ---
    {
        let mut times = Vec::with_capacity(trials);
        let mut plies = 0usize;
        for _ in 0..trials {
            let mut engine = make_engine(&engine_name).expect("engine");
            let t = Instant::now();
            let mut b = init_early_game();
            let mut p = 0;
            while !b.is_terminal() {
                let mv = engine.best_move(&b, Some(depth)).expect("move");
                b = b.make_move(mv).expect("legal");
                p += 1;
            }
            times.push(t.elapsed().as_secs_f64() * 1e3);
            plies = p;
        }
        report(
            &format!("{engine_name} full self-play game @ depth {depth}"),
            &mut times,
        );
        println!("  -> {plies} plies");
    }

    // --- raw single-position strong value (one full ID-PVS search) ---
    if engine_name == "strong" {
        let mut times = Vec::with_capacity(trials);
        let mut val = 0i32;
        for _ in 0..trials {
            let mut tt = TranspositionTable::new(16);
            let t = Instant::now();
            val = search_strong(
                board.black,
                board.white,
                board.to_move as i32,
                depth,
                &mut tt,
                true,
            );
            times.push(t.elapsed().as_secs_f64() * 1e3);
        }
        report(
            &format!("strong search_strong(opening, depth {depth})"),
            &mut times,
        );
        println!("  -> black-centred value = {val}");
    }
}

fn report(label: &str, times: &mut [f64]) {
    times.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let n = times.len();
    let min = times[0];
    let median = times[n / 2];
    let mean = times.iter().sum::<f64>() / n as f64;
    let max = times[n - 1];
    println!(
        "{label}\n  min {min:7.3} ms   median {median:7.3} ms   mean {mean:7.3} ms   max {max:7.3} ms   (n={n})"
    );
}
