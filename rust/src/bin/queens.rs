//! Play the adversarial Non-Attacking Queens game (Noon & Van Brummelen, 2006).
//!
//! Two players alternately place a queen so no two attack each other (no shared
//! row, column, or diagonal); whoever cannot move loses. The engine plays
//! perfectly (any winning move when one exists). See `--help` (and `<cmd>
//! --help`) for the modes; squares are named file+rank, e.g. `d1` (file A..
//! left→right, rank 1..n bottom→top). Boards up to 16×16.

use std::io::{self, Write};
use std::time::Instant;

use clap::builder::PossibleValuesParser;
use clap::{Parser, Subcommand};

use othello::queens::{
    make_solver, Bits, Nimber, Parallel, Queens, Solver, Tt, MAX_N, SOLVER_NAMES,
};

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

#[derive(Parser)]
#[command(
    name = "queens",
    about = "Adversarial Non-Attacking Queens game (Noon & Van Brummelen, 2006)."
)]
struct Cli {
    #[command(subcommand)]
    cmd: Option<Cmd>,
}

#[derive(Subcommand)]
enum Cmd {
    /// Who wins the empty n×n board, with an optimal line.
    Solve {
        #[arg(default_value_t = 8, value_parser = clap::value_parser!(u32).range(1..=MAX_N as i64))]
        n: u32,
        /// Solver to use (`parallel`, the default, is the fastest).
        ///
        /// `naive`→`memo`→`symmetry`→`parallel` is a speed ladder, each step
        /// adding one idea; `nimber` (the full Sprague-Grundy value) and `pn`
        /// (df-pn) are heavier, special-purpose solvers, *not* faster.
        #[arg(default_value = "parallel", value_parser = PossibleValuesParser::new(SOLVER_NAMES))]
        solver: String,
    },
    /// The Sprague-Grundy value (nimber) of the board.
    Nimber {
        #[arg(default_value_t = 8, value_parser = clap::value_parser!(u32).range(1..=MAX_N as i64))]
        n: u32,
    },
    /// Count the distinct positions the win/loss search visits (its true TT
    /// working set), via HyperLogLog. Use the counts for n=10/12/14 to
    /// extrapolate n=16's memory needs. Even boards only (odd boards are O(1)).
    Count {
        #[arg(default_value_t = 12, value_parser = clap::value_parser!(u32).range(1..=MAX_N as i64))]
        n: u32,
        /// Use the root-parallel solver (much faster; HyperLogLog only).
        #[arg(long)]
        parallel: bool,
        /// Also keep an exact hash set of distinct keys, to validate the
        /// estimate (sequential solver only; memory grows with the count).
        #[arg(long)]
        exact: bool,
        /// HyperLogLog precision: `2^p` registers (more ⇒ tighter estimate).
        #[arg(long = "hll-p", default_value_t = 16, value_parser = clap::value_parser!(u32).range(4..=18))]
        hll_p: u32,
    },
    /// Watch the engine play an optimal line for both sides.
    #[command(name = "self")]
    SelfPlay {
        #[arg(default_value_t = 8, value_parser = clap::value_parser!(u32).range(1..=MAX_N as i64))]
        n: u32,
        /// Engine to search even boards with (odd boards use the O(1) mirror
        /// strategy regardless). All engines play the same optimal line; this
        /// only changes the search — handy to watch or time the lineage steps.
        #[arg(long, default_value = "parallel", value_parser = PossibleValuesParser::new(SOLVER_NAMES))]
        engine: String,
    },
    /// Play against the engine as player 1 (first) or 2 (second).
    Play {
        #[arg(default_value_t = 8, value_parser = clap::value_parser!(u32).range(1..=MAX_N as i64))]
        n: u32,
        #[arg(default_value_t = 1, value_parser = clap::value_parser!(u32).range(1..=2))]
        player: u32,
    },
}

fn main() {
    let cmd = Cli::parse().cmd.unwrap_or(Cmd::Solve {
        n: 8,
        solver: "parallel".into(),
    });
    match cmd {
        Cmd::Solve { n, solver } => solve(&Queens::new(n), &solver),
        Cmd::Nimber { n } => nimber_mode(&Queens::new(n)),
        Cmd::Count {
            n,
            parallel,
            exact,
            hll_p,
        } => count_mode(&Queens::new(n), parallel, exact, hll_p),
        Cmd::SelfPlay { n, engine } => self_play(&Queens::new(n), &engine),
        Cmd::Play { n, player } => play(&Queens::new(n), player == 1),
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

/// Measure the distinct positions the win/loss search visits -- the table's true
/// working set -- by folding every position the search looks up into a
/// HyperLogLog (and, with `--exact`, a hash set). The counts for n=10/12/14 fit a
/// growth curve that extrapolates n=16's memory needs (the open frontier).
fn count_mode(q: &Queens, parallel: bool, exact: bool, hll_p: u32) {
    if parallel && exact {
        eprintln!(
            "--exact keeps a single shared hash set, which would serialise every \
             worker; use the sequential solver (drop --parallel) for --exact."
        );
        std::process::exit(2);
    }
    if q.is_odd() {
        println!(
            "n={n} is odd: the first player wins in O(1) by the centre + 180° mirror \
             strategy, so there is no search and nothing to count. Use an even n.",
            n = q.n,
        );
        return;
    }
    let bits = tt_bits(q.n);
    // Concrete types (not `make_solver`) so the counting constructors are reachable.
    let solver: Box<dyn Solver> = if parallel {
        Box::new(Parallel::new_counting(bits, hll_p))
    } else {
        Box::new(Tt::new_counting(bits, true, hll_p, exact))
    };
    let how = if parallel { "parallel" } else { "sequential" };
    println!(
        "Counting distinct positions on the {n}×{n} board ({how} search, HLL p={hll_p}{})…",
        if exact { ", exact set" } else { "" },
        n = q.n,
    );

    let t = Instant::now();
    let first_wins = solver.first_player_wins(q);
    let elapsed = t.elapsed().as_secs_f64();
    let rep = solver.report().expect("counting was enabled");

    let winner = if first_wins { "first" } else { "second" };
    println!("  winner: {winner} player");
    println!(
        "  nodes searched (TT misses, incl. re-expansion): {}",
        solver.nodes()
    );
    let err = 1.04 / (rep.registers as f64).sqrt();
    println!(
        "  distinct positions (HLL, ±{:.2}% std err): {:.0}  ({:.3} M)",
        err * 100.0,
        rep.estimate,
        rep.estimate / 1e6,
    );
    if let Some(exact) = rep.exact {
        let rel = (rep.estimate - exact as f64) / exact as f64 * 100.0;
        println!(
            "  distinct positions (exact hash set):          {exact}  ({:.3} M)",
            exact as f64 / 1e6,
        );
        println!("  HLL error vs exact: {rel:+.2}%");
    }
    println!("  elapsed: {elapsed:.3}s");
}

fn self_play(q: &Queens, engine: &str) {
    let solver = make_solver(engine, tt_bits(q.n)).unwrap();
    let mut queens = Bits::empty();
    let mut blocked = Bits::empty();
    let mut ply = 0u32;
    let mut last = None;
    println!(
        "Optimal self-play on the {n}×{n} board (engine: {engine}):\n",
        n = q.n,
    );
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
