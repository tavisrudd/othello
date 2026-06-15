//! Play the adversarial Non-Attacking Queens game (Noon & Van Brummelen, 2006).
//!
//! Two players alternately place a queen so no two attack each other (no shared
//! row, column, or diagonal); whoever cannot move loses. The engine plays
//! perfectly (any winning move when one exists).
//!
//!   queens solve  [n] [solver]  who wins the empty n×n board, with an optimal line
//!   queens nimber [n]           the Sprague-Grundy value (nimber) of the board
//!   queens self   [n]           watch the engine play an optimal line both sides
//!   queens play   [n] [1|2]     play against the engine as player 1 (first) or 2
//!
//! Default: n = 8, you are player 1, solver = parallel. The `solver` arg picks a
//! step of the lineage (naive | memo | symmetry | parallel) -- handy for A/B and
//! for trusting the fast solver against the simple one. Squares are named
//! file+rank, e.g. `d1` (file A.. left→right, rank 1..n bottom→top). Up to 16×16.

use std::io::{self, Write};
use std::time::Instant;

use othello::queens::{make_solver, Bits, Nimber, Queens, Solver, MAX_N, SOLVER_NAMES};

/// Nimbers (and the win/loss values for n=0..13) of OEIS A344227 — used to
/// cross-check the solver against the published Sprague-Grundy sequence.
const A344227: [u8; 14] = [0, 1, 1, 2, 1, 3, 1, 2, 3, 1, 0, 1, 0, 1];

/// Transposition-table size (`2^bits` slots ≈ `2^bits * 40` bytes) -- the memory
/// cap. Scales with the board by default; `QUEENS_TT_BITS` overrides. A too-small
/// table never errs (a miss just recomputes), it only slows down.
fn tt_bits(n: u32) -> u32 {
    if let Some(b) = std::env::var("QUEENS_TT_BITS")
        .ok()
        .and_then(|s| s.parse().ok())
    {
        return b;
    }
    if n.is_multiple_of(2) {
        match n {
            0..=10 => 22, // ≤ 4M slots (~160 MB)
            12 => 26,     // ~67M slots (~2.7 GB)
            _ => 27,      // ~134M slots (~5.4 GB)
        }
    } else {
        10 // odd boards are solved O(1) (centre+mirror) -- no search, tiny table
    }
}

fn main() {
    let mut args = std::env::args().skip(1);
    let mode = args.next().unwrap_or_else(|| "solve".into());
    let n: u32 = args.next().and_then(|s| s.parse().ok()).unwrap_or(8);
    if !(1..=MAX_N).contains(&n) {
        eprintln!("board side must be 1..={MAX_N} (an n×n board must fit in the bitset)");
        std::process::exit(2);
    }
    let q = Queens::new(n);

    match mode.as_str() {
        "solve" => {
            let solver = args.next().unwrap_or_else(|| "parallel".into());
            if !SOLVER_NAMES.contains(&solver.as_str()) {
                eprintln!("unknown solver {solver:?}; use one of {SOLVER_NAMES:?}");
                std::process::exit(2);
            }
            solve(&q, &solver);
        }
        "nimber" => nimber_mode(&q),
        "self" => self_play(&q),
        "play" => {
            let human: u32 = args.next().and_then(|s| s.parse().ok()).unwrap_or(1);
            play(&q, human == 1);
        }
        other => {
            eprintln!("unknown mode {other:?}; use: solve | nimber | self | play");
            std::process::exit(2);
        }
    }
}

/// Square name like `d1`: file letter (column) + rank number (row, 1-based).
fn name(q: &Queens, sq: u32) -> String {
    format!("{}{}", (b'A' + (sq % q.n) as u8) as char, sq / q.n + 1)
}

/// Parse a square name (`d1`, case-insensitive), validated against the board.
fn parse(q: &Queens, s: &str) -> Option<u32> {
    let mut ch = s.trim().chars();
    let file = ch.next()?.to_ascii_uppercase();
    let rank: u32 = ch.as_str().parse().ok()?;
    if !file.is_ascii_alphabetic() || rank < 1 {
        return None;
    }
    let (c, r) = ((file as u8 - b'A') as u32, rank - 1);
    (c < q.n && r < q.n).then(|| q.square(r, c))
}

/// Render the board: `Q` = queen, dim `·` = attacked (illegal), `.` = available.
fn render(q: &Queens, queens: Bits, blocked: Bits) {
    for r in (0..q.n).rev() {
        print!("{:>2} ", r + 1);
        for c in 0..q.n {
            let sq = q.square(r, c);
            if queens.get(sq) {
                print!(" \x1b[1;93mQ\x1b[0m");
            } else if blocked.get(sq) {
                print!(" \x1b[90m·\x1b[0m");
            } else {
                print!(" \x1b[92m.\x1b[0m");
            }
        }
        println!();
    }
    print!("   ");
    for c in 0..q.n {
        print!(" {}", (b'A' + c as u8) as char);
    }
    println!();
}

/// "first" / "second" for a 0-based player index.
fn who(p: u32) -> &'static str {
    if p.is_multiple_of(2) {
        "first"
    } else {
        "second"
    }
}

fn assess(win: bool) -> &'static str {
    if win {
        "winning"
    } else {
        "losing"
    }
}

/// The engine's move and whether it wins, given whose ply it is (`ply` even = the
/// first player) and the opponent's previous move `last`. Odd boards are played by
/// the O(1) centre + 180°-mirror strategy (first player) or any legal move (the
/// lost second player); even boards are searched. Caller guarantees a move exists.
fn engine_move(
    q: &Queens,
    blocked: Bits,
    ply: u32,
    last: Option<u32>,
    solver: &dyn Solver,
) -> (u32, bool) {
    if q.is_odd() {
        if ply.is_multiple_of(2) {
            // First player: take the centre, then mirror the opponent. Winning.
            let sq = match last {
                None => q.center().unwrap(),
                Some(prev) => q.mirror(prev),
            };
            (sq, true)
        } else {
            (q.first_available(blocked).unwrap(), false) // second player: lost
        }
    } else {
        q.best_move(blocked, solver).unwrap() // even board: search
    }
}

fn solve(q: &Queens, solver_name: &str) {
    let solver = make_solver(solver_name, tt_bits(q.n)).unwrap();
    let t = Instant::now();
    let first_wins = solver.first_player_wins(q);
    let pv = q.principal_variation(solver.as_ref());
    let elapsed = t.elapsed().as_secs_f64();
    let winner = if first_wins { "first" } else { "second" };
    println!(
        "On the {n}×{n} board the {winner} player wins with perfect play.",
        n = q.n,
    );
    let names: Vec<String> = pv.iter().map(|&s| name(q, s)).collect();
    println!("An optimal line ({} moves): {}", pv.len(), names.join("  "));
    println!(
        "(solver {}: searched {} nodes in {:.3}s; TT cap ≈ {:.2} GB)",
        solver.name(),
        solver.nodes(),
        elapsed,
        solver.cap_bytes() as f64 / 1e9,
    );

    let mut queens = Bits::empty();
    let mut blocked = Bits::empty();
    for &sq in &pv {
        queens.set(sq);
        blocked = q.place(blocked, sq);
    }
    println!();
    render(q, queens, blocked);
}

fn nimber_mode(q: &Queens) {
    // The nimber must be *searched* even on odd boards (the pairing proves it is
    // non-zero but not its value), and there is no α-β cutoff, so size the table
    // by board size irrespective of parity. `QUEENS_TT_BITS` still overrides.
    let bits = std::env::var("QUEENS_TT_BITS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(match q.n {
            0..=11 => 24,
            12 => 26,
            _ => 27,
        });
    let solver = Nimber::new(bits);
    let t = Instant::now();
    let g = solver.nimber(q);
    let elapsed = t.elapsed().as_secs_f64();
    let winner = if g == 0 { "second" } else { "first" };
    println!(
        "On the {n}×{n} board the Sprague-Grundy value is *{g}  ⇒  {winner} player wins.",
        n = q.n,
    );
    match A344227.get(q.n as usize) {
        Some(&exp) if exp == g => println!("(matches OEIS A344227: *{exp})"),
        Some(&exp) => println!("(MISMATCH vs OEIS A344227: expected *{exp})"),
        None => println!("(beyond OEIS A344227 — a new term)"),
    }
    println!("(searched {} nodes in {:.3}s)", solver.nodes(), elapsed);
}

fn self_play(q: &Queens) {
    let solver = make_solver("parallel", tt_bits(q.n)).unwrap();
    let mut queens = Bits::empty();
    let mut blocked = Bits::empty();
    let mut ply = 0u32;
    let mut last = None;
    println!("Optimal self-play on the {n}×{n} board:\n", n = q.n);
    render(q, queens, blocked);
    while !q.no_moves(blocked) {
        let (sq, win) = engine_move(q, blocked, ply, last, solver.as_ref());
        queens.set(sq);
        blocked = q.place(blocked, sq);
        println!(
            "\nmove {}: {} player plays {}  ({})",
            ply + 1,
            who(ply),
            name(q, sq),
            assess(win),
        );
        render(q, queens, blocked);
        last = Some(sq);
        ply += 1;
    }
    println!(
        "\nNo moves left: the {} player cannot move and loses. \
         The {} player wins after {ply} moves.",
        who(ply),
        who(ply + 1),
    );
}

fn play(q: &Queens, human_first: bool) {
    let solver = make_solver("parallel", tt_bits(q.n)).unwrap();
    let mut queens = Bits::empty();
    let mut blocked = Bits::empty();
    let mut ply = 0u32;
    let mut last = None;
    println!(
        "Non-Attacking Queens on {n}×{n}. You are the {} player. \
         Enter moves like `d1` (or `quit`).\n",
        if human_first { "first" } else { "second" },
        n = q.n,
    );

    loop {
        render(q, queens, blocked);
        if q.no_moves(blocked) {
            // The player to move at `ply` cannot move and loses.
            let loser_is_human = ply.is_multiple_of(2) == human_first;
            println!(
                "\nNo legal moves: the {} player ({}) loses. {} after {ply} moves.",
                who(ply),
                if loser_is_human { "you" } else { "engine" },
                if loser_is_human {
                    "Engine wins"
                } else {
                    "You win"
                },
            );
            return;
        }
        let human_turn = ply.is_multiple_of(2) == human_first;
        let sq = if human_turn {
            match read_move(q, blocked) {
                Some(sq) => sq,
                None => return, // quit / EOF
            }
        } else {
            let (sq, win) = engine_move(q, blocked, ply, last, solver.as_ref());
            println!("\nEngine plays {}  ({}).", name(q, sq), assess(win));
            sq
        };
        queens.set(sq);
        blocked = q.place(blocked, sq);
        last = Some(sq);
        ply += 1;
        println!();
    }
}

/// Prompt the human for a legal move; `None` on quit/EOF.
fn read_move(q: &Queens, blocked: Bits) -> Option<u32> {
    loop {
        print!("\nyour move> ");
        io::stdout().flush().ok();
        let mut line = String::new();
        if io::stdin().read_line(&mut line).ok()? == 0 {
            return None; // EOF
        }
        let s = line.trim();
        if s.eq_ignore_ascii_case("quit") || s.eq_ignore_ascii_case("q") {
            return None;
        }
        match parse(q, s) {
            Some(sq) if q.is_available(blocked, sq) => return Some(sq),
            Some(_) => println!("That square is occupied or attacked. Try again."),
            None => println!("Bad square. Use file+rank like `d1`."),
        }
    }
}
