//! Play the adversarial Non-Attacking Queens game (Noon & Van Brummelen, 2006).
//!
//! Two players alternately place a queen so no two attack each other (no shared
//! row, column, or diagonal); whoever cannot move loses. The engine plays
//! perfectly (any winning move when one exists). See `--help` (and `<cmd>
//! --help`) for the modes; squares are named file+rank, e.g. `d1` (file A..
//! left→right, rank 1..n bottom→top). Boards up to 16×16.

use std::io::{self, IsTerminal, Write};
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread;
use std::time::{Duration, Instant};

use clap::builder::PossibleValuesParser;
use clap::{Parser, Subcommand};
use signal_hook::consts::{SIGINT, SIGTERM, SIGUSR1};
use signal_hook::iterator::Signals;

use othello::queens::{
    make_solver, Bits, Nimber, Parallel, Queens, Solver, Tt, MAX_N, SOLVER_NAMES,
};

/// Nimbers (and the win/loss values for n=0..13) of OEIS A344227 — used to
/// cross-check the solver against the published Sprague-Grundy sequence.
const A344227: [u8; 14] = [0, 1, 1, 2, 1, 3, 1, 2, 3, 1, 0, 1, 0, 1];

/// Estimated **distinct positions the win/loss search visits** -- its
/// transposition-table working set -- for the empty n×n board, indexed by n.
/// Even boards are searched; odd boards are O(1) (centre + 180° mirror, no
/// search) so 0. Exact (hash set) for n ≤ 12, HyperLogLog for n=14, and
/// extrapolated for n=16 (Chunk 1: growth accelerates ~11×→46× per step,
/// central estimate ~9.2e9). Re-measure any entry with `queens count <n> --exact`
/// (or `--parallel` for the big ones). These size the table -- see `tt_bits`.
const DISTINCT_POSITIONS: [u64; 17] = [
    0,             // n=0
    0,             // n=1  (trivial)
    2,             // n=2
    0,             // n=3  (odd → O(1))
    5,             // n=4
    0,             // n=5  (odd)
    28,            // n=6
    0,             // n=7  (odd)
    626,           // n=8
    0,             // n=9  (odd)
    94_097,        // n=10
    0,             // n=11 (odd)
    1_060_726,     // n=12
    0,             // n=13 (odd)
    49_346_012,    // n=14 (HyperLogLog, ±0.2%)
    0,             // n=15 (odd)
    9_200_000_000, // n=16 (extrapolated; exceeds any single-box table)
];

/// Upper bound on the transposition-table size: `2^28` slots ≈ 10.7 GB. The n=16
/// working set dwarfs any single-box table (Chunk 1), so its table is pinned here
/// and thrashes; raise it with `QUEENS_TT_BITS` if you have the RAM.
const MAX_TT_BITS: u32 = 28;

/// Transposition-table size in bits (`2^bits` slots ≈ `2^bits × 40` bytes), sized
/// from the measured working set [`DISTINCT_POSITIONS`] to keep the direct-mapped
/// table lightly loaded (low eviction ⇒ low re-expansion ≈ 1.0×): generous
/// headroom for small boards (RAM is cheap there), little for the large
/// RAM-bound ones, clamped to `[14, MAX_TT_BITS]`. `QUEENS_TT_BITS` overrides. A
/// too-small table never errs (a miss just recomputes), it only thrashes -- watch
/// that with `solve --distinct`.
fn tt_bits(n: u32) -> u32 {
    if let Some(b) = std::env::var("QUEENS_TT_BITS")
        .ok()
        .and_then(|s| s.parse().ok())
    {
        return b;
    }
    let card = DISTINCT_POSITIONS.get(n as usize).copied().unwrap_or(0);
    if card == 0 {
        return 14; // odd boards (O(1)) and tiny boards need only a minimal table
    }
    // Headroom (extra power-of-two factors over the working set). Small boards get
    // plenty -- a low load factor means ~no eviction, so re-expansion ≈ 1.0× --
    // since RAM is cheap there; large boards (n ≥ 14) get little and lean on
    // MAX_TT_BITS, where some eviction is the price of fitting (watch it with
    // `solve --distinct`).
    let headroom = if card <= 4_000_000 { 4 } else { 1 };
    (card.next_power_of_two().trailing_zeros() + headroom).clamp(14, MAX_TT_BITS)
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
        /// Also estimate the *distinct* positions (HyperLogLog) so the report
        /// shows how much the search re-expands -- the transposition table's
        /// thrash: nodes ÷ distinct. Adds a little per-node overhead (memo /
        /// symmetry / parallel only).
        #[arg(long)]
        distinct: bool,
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
        distinct: false,
    });
    match cmd {
        Cmd::Solve {
            n,
            solver,
            distinct,
        } => solve(&Queens::new(n), &solver, distinct),
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

/// Render the board: `Q` = queen, dark-red `.` = attacked (illegal), green `.` =
/// available. Queens are coloured like chess pieces by their square's
/// checkerboard parity (a1 is a dark square): dark squares get the "black" queen
/// in the same dark grey the Python board uses (256-colour 240), light squares
/// the "white" one.
fn render(q: &Queens, queens: Bits, blocked: Bits) {
    for r in (0..q.n).rev() {
        print!("{:>2} ", r + 1);
        for c in 0..q.n {
            let sq = q.square(r, c);
            if queens.get(sq) {
                let q = if (r + c).is_multiple_of(2) {
                    "\x1b[38;5;240mQ" // dark square ⇒ black queen (Python's grey)
                } else {
                    "\x1b[38;5;255mQ" // light square ⇒ white queen
                };
                print!(" {q}\x1b[0m");
            } else if blocked.get(sq) {
                print!(" \x1b[38;5;88m.\x1b[0m"); // attacked: dark red
            } else {
                print!(" \x1b[92m.\x1b[0m"); // available: green
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

/// Braille spinner frames for the live progress line.
const SPINNER: [&str; 10] = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];

/// An integer with thousands separators: `1234567` → `"1,234,567"`.
fn commas(n: u64) -> String {
    let digits = n.to_string();
    let mut out = String::with_capacity(digits.len() + digits.len() / 3);
    for (i, ch) in digits.char_indices() {
        if i > 0 && (digits.len() - i).is_multiple_of(3) {
            out.push(',');
        }
        out.push(ch);
    }
    out
}

/// A node-search rate, scaled to the unit that keeps it legible: M/s for a fast
/// solver, K/s for a slow one, plain /s for a crawl (e.g. `pn`, which is far too
/// slow to register on the M/s scale — it would read a flat `0.0M/s`).
fn fmt_rate(nodes: u64, secs: f64) -> String {
    let rate = if secs > 0.0 { nodes as f64 / secs } else { 0.0 };
    if rate >= 1e6 {
        format!("{:.2}M/s", rate / 1e6)
    } else if rate >= 1e3 {
        format!("{:.1}K/s", rate / 1e3)
    } else {
        format!("{rate:.0}/s")
    }
}

/// A one-line on-demand report for a running solve (SIGUSR1) or its termination
/// (SIGINT/SIGTERM), printed to stderr.
fn status_report(label: &str, n: u32, solver: &dyn Solver, start: Instant) -> String {
    let secs = start.elapsed().as_secs_f64();
    let nodes = solver.nodes();
    format!(
        "[queens {n}×{n}] {label}: {} nodes searched in {secs:.1}s ({})",
        commas(nodes),
        fmt_rate(nodes, secs)
    )
}

/// The terminal width (stderr), or 80 columns if stderr is not a terminal.
fn term_cols() -> usize {
    terminal_size::terminal_size_of(io::stderr()).map_or(80, |(w, _)| w.0 as usize)
}

/// The live, in-place progress line (stderr): a spinner, a determinate bar over
/// the resolved root moves when the solver exposes them (a second-player win
/// must refute them all, so it fills to 100%), and live node/elapsed/rate.
fn progress_bar(n: u32, solver: &dyn Solver, start: Instant) -> String {
    let secs = start.elapsed().as_secs_f64();
    let node_count = solver.nodes();
    let rate = fmt_rate(node_count, secs);
    let nodes = commas(node_count);
    let spin = SPINNER[((secs * 8.0) as usize) % SPINNER.len()];
    // With --distinct, show the live re-expansion ratio (nodes ÷ distinct) -- the
    // table's thrash climbing in real time as it saturates.
    let reexp = match solver.report() {
        Some(rep) if rep.estimate >= 1.0 => {
            format!(" · {:.1}× re-exp", node_count as f64 / rep.estimate)
        }
        _ => String::new(),
    };
    match solver.root_progress() {
        Some((done, total)) => {
            const W: u64 = 24;
            let filled = (done * W / total) as usize;
            let bar: String = "█".repeat(filled) + &"░".repeat(W as usize - filled);
            format!("{spin} {n}×{n} [{bar}] {done}/{total} roots · {nodes} nodes{reexp} · {secs:.0}s · {rate}")
        }
        None => format!("{spin} {n}×{n} · {nodes} nodes{reexp} · {secs:.0}s · {rate}"),
    }
}

/// Background watcher for a running solve: each tick it drains arrived signals
/// (SIGUSR1 → progress dump; SIGINT/SIGTERM → "how far we got" report, then
/// exit) and, when `bar`, repaints the in-place progress line. Polling keeps it
/// the sole stderr writer with no work in async-signal context. Stops when the
/// solve sets `done`.
fn watch(
    signals: &mut Signals,
    solver: &dyn Solver,
    n: u32,
    start: Instant,
    bar: bool,
    done: &AtomicBool,
) {
    let clear = || {
        if bar {
            eprint!("\r\x1b[K"); // carriage return + clear-to-end-of-line
        }
    };
    loop {
        for sig in signals.pending() {
            clear();
            match sig {
                SIGINT | SIGTERM => {
                    let what = if sig == SIGINT {
                        "interrupted (SIGINT)"
                    } else {
                        "terminated (SIGTERM)"
                    };
                    eprintln!("{}", status_report(what, n, solver, start));
                    std::process::exit(128 + sig); // 130 (SIGINT) / 143 (SIGTERM)
                }
                _ => eprintln!(
                    "{}",
                    status_report("in progress (SIGUSR1)", n, solver, start)
                ),
            }
        }
        if done.load(Ordering::Relaxed) {
            break;
        }
        if bar {
            // Truncate to the terminal width so the line never wraps (a wrapped
            // line defeats the `\r` overwrite and leaves garbage); the glyphs are
            // all one column wide, so chars == columns. Clear to end-of-line after,
            // since this line may be shorter than the last.
            let cols = term_cols().saturating_sub(1);
            let line: String = progress_bar(n, solver, start).chars().take(cols).collect();
            eprint!("\r{line}\x1b[K");
            io::stderr().flush().ok();
        }
        // Park rather than sleep so the solve can wake us the instant it finishes
        // (no fixed tick of latency on fast solves); the timeout keeps the bar and
        // signal polling live for long ones.
        thread::park_timeout(Duration::from_millis(100));
    }
    clear();
    io::stderr().flush().ok();
}

fn solve(q: &Queens, solver_name: &str, distinct: bool) {
    let bits = tt_bits(q.n);
    // --distinct reports the re-expansion ratio (nodes ÷ distinct). For even
    // boards n ≤ 12 the distinct count is already known *exactly* (the table), so
    // we report that and skip the live counter; only n ≥ 14 needs a HyperLogLog
    // estimate (and only the table-backed solvers carry one).
    let live_count = distinct && q.n.is_multiple_of(2) && q.n > 12;
    let solver: Box<dyn Solver> = match (live_count, solver_name) {
        (true, "parallel") => Box::new(Parallel::new_counting(bits, 16)),
        (true, "symmetry") => Box::new(Tt::new_counting(bits, true, 16, false)),
        (true, "memo") => Box::new(Tt::new_counting(bits, false, 16, false)),
        (true, other) => {
            eprintln!("--distinct estimates need memo/symmetry/parallel; ignoring for {other}.");
            make_solver(other, bits).unwrap()
        }
        (false, name) => make_solver(name, bits).unwrap(),
    };
    let t = Instant::now();
    let n = q.n;
    // A live progress bar only when the solve may run a while and stderr is a
    // real terminal (so piped output and tests stay clean).
    let bar = n > 8 && io::stderr().is_terminal();

    // One scoped watcher thread (so it can borrow the solver read-only) polls
    // for signals and repaints the bar: SIGUSR1 dumps progress, SIGINT/SIGTERM
    // report how far the search got and exit, and the live node counter the
    // solver bumps keeps the bar meaningful even within one long root move.
    let mut signals = Signals::new([SIGINT, SIGTERM, SIGUSR1]).ok();
    let done = AtomicBool::new(false);
    let (first_wins, pv) = thread::scope(|scope| {
        let watcher = signals.as_mut().map(|signals| {
            let solver = solver.as_ref();
            let done = &done;
            scope.spawn(move || watch(signals, solver, n, t, bar, done))
        });
        let first_wins = solver.first_player_wins(q);
        let pv = q.principal_variation(solver.as_ref());
        done.store(true, Ordering::Relaxed);
        if let Some(watcher) = &watcher {
            watcher.thread().unpark(); // wake it now so the scope joins promptly
        }
        (first_wins, pv)
    });

    let elapsed = t.elapsed().as_secs_f64();
    let winner = if first_wins { "first" } else { "second" };
    println!(
        "On the {n}×{n} board the {winner} player wins with perfect play.",
        n = q.n,
    );
    let names: Vec<String> = pv.iter().map(|&s| name(q, s)).collect();
    println!("An optimal line ({} moves): {}", pv.len(), names.join("  "));
    // A dim, secondary line: search cost plus approach-specific stats (table
    // fill, nimber value, proof numbers, …) that each solver reports.
    let mut summary = format!(
        "solver {}: searched {} nodes in {elapsed:.3}s",
        solver.name(),
        commas(solver.nodes()),
    );
    let stats = solver.stats();
    if !stats.is_empty() {
        summary.push_str(" · ");
        summary.push_str(&stats);
    }
    println!("\x1b[90m({summary})\x1b[0m");
    // With --distinct: how much of the search was re-expansion (TT thrash)?
    // Distinct comes from the live HyperLogLog (n ≥ 14) or, for the boards the
    // table knows exactly (even n ≤ 12), the exact count -- no fuzzy estimate.
    if distinct && q.n.is_multiple_of(2) {
        let nodes = solver.nodes() as f64;
        let (distinct, label) = match solver.report() {
            Some(rep) => (
                rep.estimate,
                format!(
                    "≈ {} (HLL ±{:.1}%)",
                    commas(rep.estimate as u64),
                    1.04 / (rep.registers as f64).sqrt() * 100.0
                ),
            ),
            None => {
                let exact = DISTINCT_POSITIONS[q.n as usize] as f64;
                (exact, format!("{} (exact)", commas(exact as u64)))
            }
        };
        println!(
            "\x1b[90m(distinct {label} positions · {:.2}× re-expansion, {:.1}% recomputed)\x1b[0m",
            nodes / distinct,
            (1.0 - distinct / nodes) * 100.0,
        );
    }

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
    let nodes = solver.nodes();
    println!("  winner: {winner} player");
    println!(
        "  nodes searched (TT misses, incl. re-expansion): {}",
        commas(nodes)
    );
    let err = 1.04 / (rep.registers as f64).sqrt();
    println!(
        "  distinct positions (HLL, ±{:.2}% std err): {}  ({:.3} M)",
        err * 100.0,
        commas(rep.estimate as u64),
        rep.estimate / 1e6,
    );
    if let Some(exact) = rep.exact {
        let rel = (rep.estimate - exact as f64) / exact as f64 * 100.0;
        println!(
            "  distinct positions (exact hash set):          {}  ({:.3} M)",
            commas(exact),
            exact as f64 / 1e6,
        );
        println!("  HLL error vs exact: {rel:+.2}%");
    }
    // Re-expansion = total expansions ÷ distinct: 1.0 means the table held the
    // whole working set; higher means eviction forced recompute (TT thrash).
    let distinct = rep.exact.map(|e| e as f64).unwrap_or(rep.estimate);
    println!(
        "  re-expansion: {:.2}× ({:.1}% recomputed)",
        nodes as f64 / distinct,
        (1.0 - distinct / nodes as f64) * 100.0,
    );
    println!("  elapsed: {elapsed:.3}s");
}

/// Warm the shared table with one parallel root solve so the per-move `best_move`
/// calls in self-play / play hit it. `best_move` goes through the *sequential*
/// `Solver::wins`, so without this the first even-board move would re-search the
/// whole tree single-core -- far slower than `solve`, which warms the table the
/// same way via `first_player_wins`. Odd boards are O(1) (no search to warm).
fn warm_table(q: &Queens, solver: &dyn Solver) {
    if !q.is_odd() {
        eprintln!("(solving the {n}×{n} game…)", n = q.n);
        solver.first_player_wins(q);
    }
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
    warm_table(q, solver.as_ref());
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
    warm_table(q, solver.as_ref());

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
