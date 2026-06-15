//! Full-game benchmark with the search isolated from TTY I/O.
//!
//! Plays a full depth-8 game into a move arena with **no per-turn output**
//! (`record_game`), times that, then renders the whole game once at the end
//! (`render_recorded`, batched at 100 ms) and times the render separately --
//! showing how much the per-turn `println!` would otherwise add to the "game".
//!
//!     cargo run --release --example bench_game
//!     OTHELLO_TRACE=1 cargo run --release --example bench_game   # per-move spans
//!     cargo run --release --example bench_game -- 8 render        # also print the game
//!
//! With OTHELLO_TRACE=1 a `tracing` subscriber logs every span (`game`,
//! `search` per move, `render`) with its close duration.

use std::io::{self, Write};
use std::time::{Duration, Instant};

use othello::engines::make_engine;
use othello::{init_early_game, record_game, render_recorded};

fn main() {
    let mut args = std::env::args().skip(1);
    let depth: i32 = args.next().and_then(|s| s.parse().ok()).unwrap_or(8);
    let show = args.next().as_deref() == Some("render");

    if std::env::var("OTHELLO_TRACE").is_ok() {
        use tracing_subscriber::fmt::format::FmtSpan;
        tracing_subscriber::fmt()
            .with_span_events(FmtSpan::CLOSE)
            .with_target(false)
            .with_env_filter(
                tracing_subscriber::EnvFilter::try_from_default_env()
                    .unwrap_or_else(|_| "info".into()),
            )
            .init();
    }

    // --- search only: record the whole game into the arena, no I/O ---
    let trials = 15;
    let mut best = f64::INFINITY;
    let mut plies = 0usize;
    let mut last = None;
    for _ in 0..trials {
        let mut engine = make_engine("strong").unwrap();
        let t = Instant::now();
        let rec = record_game(init_early_game(), engine.as_mut(), Some(depth));
        best = best.min(t.elapsed().as_secs_f64() * 1e3);
        plies = rec.moves.len();
        last = Some(rec);
    }
    let rec = last.unwrap();
    println!("record_game (search only, no I/O) @ depth {depth}: {best:.2} ms  ({plies} plies)");

    // --- render the buffered game once, timed separately ---
    let mut sink: Vec<u8> = Vec::new();
    let t = Instant::now();
    render_recorded(&rec, &mut sink, Duration::from_millis(100)).unwrap();
    let render_ms = t.elapsed().as_secs_f64() * 1e3;
    println!(
        "render_recorded (buffered, batched@100ms): {render_ms:.2} ms  ({} bytes)",
        sink.len()
    );

    if show {
        io::stdout().write_all(&sink).unwrap();
    }
}
