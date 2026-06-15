//! Strength match: `strong+` vs `strong`. For each of N diversified openings,
//! play two games with colours swapped (controls for first-move advantage) and
//! tally wins. Usage: cargo run --release --example match -- [depth] [openings]

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

fn play_out(start: Board, black: &str, white: &str, depth: i32) -> Option<Player> {
    let mut be = make_engine(black).unwrap();
    let mut we = make_engine(white).unwrap();
    let mut b = start;
    while !b.is_terminal() {
        let mv = if b.to_move == BLACK {
            be.best_move(&b, Some(depth)).unwrap()
        } else {
            we.best_move(&b, Some(depth)).unwrap()
        };
        b = b.make_move(mv).unwrap();
    }
    winner(&b)
}

fn main() {
    let mut a = std::env::args().skip(1);
    let depth: i32 = a.next().and_then(|s| s.parse().ok()).unwrap_or(6);
    let openings: u64 = a.next().and_then(|s| s.parse().ok()).unwrap_or(40);
    let (mut plus, mut base, mut draw) = (0u32, 0u32, 0u32);
    let mut games = 0u32;

    for seed in 0..openings {
        let start = random_opening(seed, 6);
        if start.is_terminal() {
            continue;
        }
        // A: strong+ is Black, strong is White
        match play_out(start, "strong+", "strong", depth) {
            Some(p) if p == BLACK => plus += 1,
            Some(_) => base += 1,
            None => draw += 1,
        }
        // B: colours swapped
        match play_out(start, "strong", "strong+", depth) {
            Some(p) if p == BLACK => base += 1,
            Some(_) => plus += 1,
            None => draw += 1,
        }
        games += 2;
    }

    let score = plus as f64 + 0.5 * draw as f64;
    println!("strong+ vs strong @ depth {depth} over {games} games (colour-balanced):");
    println!("  strong+ wins: {plus}");
    println!("  strong  wins: {base}");
    println!("  draws       : {draw}");
    println!(
        "  strong+ score: {:.1}/{} ({:.1}%)",
        score,
        games,
        100.0 * score / games as f64
    );
}
