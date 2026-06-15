//! Strength match between two engines. For each of N diversified openings, play
//! two games with colours swapped (controls for first-move advantage) and tally
//! wins. The two sides may search to *different* depths, which is how a
//! time-matched comparison is run (e.g. `strong++` deeper vs `strong+`).
//!
//!   cargo run --release --example match -- [depth] [openings] [A] [B] [depthB]
//!
//! Defaults: depth 6, 40 openings, A=`strong++`, B=`strong+`, depthB=depth.
//! Reports A's colour-balanced score and the wall-clock each engine spent
//! searching (so an equal-time, unequal-depth comparison is legible).

use std::time::{Duration, Instant};

use othello::engines::make_engine;
use othello::{init_early_game, iter_moves, winner, Board, Player, BLACK};

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

/// A diversified, legal start: `plies` random moves from the opening.
fn random_opening(seed: u64, plies: usize) -> Board {
    let mut rng = Lcg(seed.wrapping_mul(0x9E37_79B9) | 1);
    let mut b = init_early_game();
    for _ in 0..plies {
        if b.is_terminal() {
            break;
        }
        let acts = iter_moves(b.actions());
        let mv = if acts.is_empty() {
            othello::PASS
        } else {
            acts[(rng.next() as usize) % acts.len()]
        };
        b = b.make_move(mv).unwrap();
    }
    b
}

/// Play `black` (depth `bd`) vs `white` (depth `wd`); accumulate each engine's
/// search time into `bt`/`wt`. Returns the winner (None = draw).
fn play_out(
    start: Board,
    black: &str,
    bd: i32,
    white: &str,
    wd: i32,
    bt: &mut Duration,
    wt: &mut Duration,
) -> Option<Player> {
    let mut be = make_engine(black).unwrap();
    let mut we = make_engine(white).unwrap();
    let mut b = start;
    while !b.is_terminal() {
        let t = Instant::now();
        let mv = if b.to_move == BLACK {
            let m = be.best_move(&b, Some(bd)).unwrap();
            *bt += t.elapsed();
            m
        } else {
            let m = we.best_move(&b, Some(wd)).unwrap();
            *wt += t.elapsed();
            m
        };
        b = b.make_move(mv).unwrap();
    }
    winner(&b)
}

fn main() {
    let mut a = std::env::args().skip(1);
    let depth: i32 = a.next().and_then(|s| s.parse().ok()).unwrap_or(6);
    let openings: u64 = a.next().and_then(|s| s.parse().ok()).unwrap_or(40);
    let na = a.next().unwrap_or_else(|| "strong++".into());
    let nb = a.next().unwrap_or_else(|| "strong+".into());
    let db: i32 = a.next().and_then(|s| s.parse().ok()).unwrap_or(depth);
    let da = depth;

    let (mut awins, mut bwins, mut draw) = (0u32, 0u32, 0u32);
    let mut games = 0u32;
    let (mut at, mut bt) = (Duration::ZERO, Duration::ZERO);

    for seed in 0..openings {
        let start = random_opening(seed, 6);
        if start.is_terminal() {
            continue;
        }
        // Game 1: A is Black (depth da), B is White (depth db).
        match play_out(start, &na, da, &nb, db, &mut at, &mut bt) {
            Some(p) if p == BLACK => awins += 1,
            Some(_) => bwins += 1,
            None => draw += 1,
        }
        // Game 2: colours swapped (A White, B Black).
        match play_out(start, &nb, db, &na, da, &mut bt, &mut at) {
            Some(p) if p == BLACK => bwins += 1,
            Some(_) => awins += 1,
            None => draw += 1,
        }
        games += 2;
    }

    let score = awins as f64 + 0.5 * draw as f64;
    let depth_note = if da == db {
        format!("depth {da}")
    } else {
        format!("{na} @ {da} vs {nb} @ {db}")
    };
    println!("{na} vs {nb} @ {depth_note} over {games} games (colour-balanced):");
    println!("  {na} wins: {awins}");
    println!("  {nb} wins: {bwins}");
    println!("  draws    : {draw}");
    println!(
        "  {na} score: {:.1}/{} ({:.1}%)",
        score,
        games,
        100.0 * score / games as f64
    );
    println!(
        "  search time: {na} {:.2}s   {nb} {:.2}s   (ratio {:.2}x)",
        at.as_secs_f64(),
        bt.as_secs_f64(),
        at.as_secs_f64() / bt.as_secs_f64().max(1e-9),
    );
}
