//! Play the adversarial Non-Attacking Queens game (Noon & Van Brummelen, 2006).
//!
//! Two players alternately place a queen so no two attack each other (no shared
//! row, column, or diagonal); whoever cannot move loses. The engine plays
//! perfectly (any winning move when one exists). See `--help` (and `<cmd>
//! --help`) for the modes; squares are named file+rank, e.g. `d1` (file A..
//! left→right, rank 1..n bottom→top). Boards up to 16×16.

use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufReader, BufWriter, IsTerminal, Write};
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread;
use std::time::{Duration, Instant};

use clap::builder::PossibleValuesParser;
use clap::{Parser, Subcommand};
use signal_hook::consts::{SIGINT, SIGTERM, SIGUSR1, SIGUSR2};
use signal_hook::iterator::Signals;

use othello::queens::{
    make_solver, Bits, Nimber, Parallel, Queens, QueensTt, Solver, Tt, MAX_N, SOLVER_NAMES,
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
///
/// Measured on the canonical solver *with* the terminal-child fast path: terminals
/// canonicalise to one shared key (`Bits::ZERO`) that the fast path never looks up,
/// so each count omits exactly that one position (visible on the tiny boards).
const DISTINCT_POSITIONS: [u64; 17] = [
    0,             // n=0
    0,             // n=1  (trivial)
    1,             // n=2
    0,             // n=3  (odd → O(1))
    4,             // n=4
    0,             // n=5  (odd)
    27,            // n=6
    0,             // n=7  (odd)
    625,           // n=8
    0,             // n=9  (odd)
    94_205,        // n=10
    0,             // n=11 (odd)
    1_060_823,     // n=12
    0,             // n=13 (odd)
    49_419_639,    // n=14 (HyperLogLog p=18, ±0.2%)
    0,             // n=15 (odd)
    9_200_000_000, // n=16 (extrapolated; exceeds any single-box table)
];

/// Upper bound on the transposition-table size: `2^31` slots ≈ 17 GB at the
/// Chunk-2 compact 8-byte slot (the dev box has 26 GB). The n=16 working set
/// (~9.2e9) dwarfs even that, so its table is pinned here and thrashes; raise it
/// with `QUEENS_TT_BITS` if you have the RAM.
const MAX_TT_BITS: u32 = 31;

/// Transposition-table size in bits (`2^bits` slots ≈ `2^bits × 8` bytes), sized
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
    /// List available solvers (name, description, parallelism) and exit.
    #[arg(long)]
    list_engines: bool,
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
        /// Write a compressed, resumable TT checkpoint to PATH periodically (see
        /// --checkpoint-every), on a SIGUSR2, and on exit. With no PATH it uses
        /// ./queens-tt-n<N>.zst. **Defaults ON for n=16, OFF below**; resume with
        /// --resume. Table-backed solvers only (parallel / symmetry / memo).
        #[arg(long, value_name = "PATH", num_args = 0..=1, default_missing_value = "")]
        checkpoint: Option<PathBuf>,
        /// Force checkpointing off (overrides the n=16 default).
        #[arg(long, conflicts_with = "checkpoint")]
        no_checkpoint: bool,
        /// Checkpoint cadence, e.g. `5m`, `300s`, `2h` (no suffix = seconds).
        #[arg(long, value_name = "DUR", default_value = "5m", value_parser = parse_duration)]
        checkpoint_every: Duration,
        /// Resume from a checkpoint image: reload the TT and continue warm. The
        /// table is sized by the image, so QUEENS_TT_BITS/SLOTS are ignored.
        #[arg(long, value_name = "PATH")]
        resume: Option<PathBuf>,
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
        /// Measure the graph-isomorphism merge: how many fewer distinct positions
        /// remain if the key canonicalises the *available-graph* up to isomorphism
        /// (1-WL, 1-WL+individualisation, and a true IR canonical form) instead of
        /// just the 8 board symmetries, and whether each merge is win/loss-consistent
        /// (a safe TT key). Implies `--exact`; sequential.
        #[arg(long)]
        iso: bool,
        /// Tally the available-graph's connected-component-size distribution over the
        /// working set -- how much the graph fragments into the tiny components the
        /// `tiny_comp_key` shortcut (#18) targets. Implies `--exact`; sequential.
        #[arg(long)]
        comps: bool,
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
    let cli = Cli::parse();
    if cli.list_engines {
        list_engines();
        return;
    }
    let cmd = cli.cmd.unwrap_or(Cmd::Solve {
        n: 8,
        solver: "parallel".into(),
        distinct: false,
        checkpoint: None,
        no_checkpoint: false,
        checkpoint_every: Duration::from_secs(300),
        resume: None,
    });
    match cmd {
        Cmd::Solve {
            n,
            solver,
            distinct,
            checkpoint,
            no_checkpoint,
            checkpoint_every,
            resume,
        } => solve(
            &Queens::new(n),
            &solver,
            distinct,
            CpOpts {
                checkpoint,
                no_checkpoint,
                every: checkpoint_every,
                resume,
            },
        ),
        Cmd::Nimber { n } => nimber_mode(&Queens::new(n)),
        Cmd::Count {
            n,
            parallel,
            exact,
            iso,
            comps,
            hll_p,
        } => count_mode(
            &Queens::new(n),
            parallel && !iso && !comps,
            exact || iso || comps,
            iso,
            comps,
            hll_p,
        ),
        Cmd::SelfPlay { n, engine } => self_play(&Queens::new(n), &engine),
        Cmd::Play { n, player } => play(&Queens::new(n), player == 1),
    }
}

/// `--list-engines`: a width-aware table of the solver ladder. Every solver
/// computes the exact value to the end of the game, so "default depth" is always
/// "full"; what differs is the technique and the parallelism. Order matches
/// `SOLVER_NAMES`.
fn list_engines() {
    const INFO: [(&str, &str, &str); 6] = [
        (
            "naive",
            "plain negamax win/loss with an α-β cutoff, no memo (ground truth)",
            "sequential",
        ),
        (
            "memo",
            "+ a fixed-size transposition table keyed on the raw board mask",
            "sequential",
        ),
        (
            "symmetry",
            "+ dihedral (8-fold) canonical keys, merging symmetric states",
            "sequential",
        ),
        (
            "parallel",
            "+ rayon root parallelism (Young-Brothers-Wait) and the odd-n O(1) theorem",
            "root-parallel (YBW)",
        ),
        (
            "nimber",
            "full Sprague-Grundy value (nimber) via mex over children, no cutoff",
            "root-parallel",
        ),
        (
            "pn",
            "depth-first proof-number search (Nagai df-pn)",
            "sequential",
        ),
    ];
    let rows: Vec<Vec<String>> = INFO
        .iter()
        .map(|(name, desc, parallelism)| {
            vec![
                name.to_string(),
                desc.to_string(),
                parallelism.to_string(),
                "full".to_string(),
            ]
        })
        .collect();
    print!(
        "{}",
        othello::table::render(
            &["name", "description", "parallelism", "default depth"],
            &rows,
            1, // wrap the description column
        )
    );
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
/// (SIGUSR1 → progress dump; SIGUSR2 → checkpoint now; SIGINT/SIGTERM → checkpoint
/// (if enabled), report "how far we got", then exit), fires the periodic checkpoint
/// when `cp` is due, and, when `bar`, repaints the in-place progress line. Polling
/// keeps it the sole stderr writer with no work in async-signal context. Stops when
/// the solve sets `done`.
fn watch(
    signals: &mut Signals,
    solver: &dyn Solver,
    n: u32,
    start: Instant,
    bar: bool,
    cp: Option<&Checkpoint>,
    done: &AtomicBool,
) {
    let clear = || {
        if bar {
            eprint!("\r\x1b[K"); // carriage return + clear-to-end-of-line
        }
    };
    let mut last_cp = Instant::now();
    loop {
        for sig in signals.pending() {
            clear();
            match sig {
                SIGINT | SIGTERM => {
                    // Save before exiting so a Ctrl-C / preemption keeps the work.
                    if let Some(cp) = cp {
                        do_checkpoint(solver, cp, "interrupt");
                    }
                    let what = if sig == SIGINT {
                        "interrupted (SIGINT)"
                    } else {
                        "terminated (SIGTERM)"
                    };
                    eprintln!("{}", status_report(what, n, solver, start));
                    std::process::exit(128 + sig); // 130 (SIGINT) / 143 (SIGTERM)
                }
                SIGUSR2 => {
                    if let Some(cp) = cp {
                        do_checkpoint(solver, cp, "sigusr2");
                        last_cp = Instant::now();
                    }
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
        // Periodic checkpoint: dump when the cadence is due. Blocks the bar briefly
        // while it streams; sound under live writers (each slot is one atomic u64).
        if let Some(cp) = cp {
            if last_cp.elapsed() >= cp.every {
                clear();
                do_checkpoint(solver, cp, "periodic");
                last_cp = Instant::now();
            }
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

/// Show the live progress bar only for searches that run a while -- n ≥ 14 (over
/// ~1 s) -- and when stderr is a real terminal, so fast solves and piped output
/// (and tests) stay clean.
fn show_bar(n: u32) -> bool {
    n >= 14 && io::stderr().is_terminal()
}

/// Run a search (`work`) while a background watcher handles signals and, when
/// `bar`, paints the live progress bar -- shared by `solve` and the self/play
/// table warm-up. The watcher borrows the solver read-only on a scoped thread;
/// `work` runs on this thread and its result is returned. SIGUSR1 dumps progress,
/// SIGINT/SIGTERM report how far the search got and exit.
fn run_watched<R>(
    solver: &dyn Solver,
    n: u32,
    bar: bool,
    cp: Option<&Checkpoint>,
    work: impl FnOnce() -> R,
) -> R {
    let start = Instant::now();
    let mut signals = Signals::new([SIGINT, SIGTERM, SIGUSR1, SIGUSR2]).ok();
    let done = AtomicBool::new(false);
    thread::scope(|scope| {
        let watcher = signals.as_mut().map(|signals| {
            let done = &done;
            scope.spawn(move || watch(signals, solver, n, start, bar, cp, done))
        });
        let result = work();
        done.store(true, Ordering::Relaxed);
        if let Some(watcher) = &watcher {
            watcher.thread().unpark(); // wake it now so the scope joins promptly
        }
        result
    })
}

/// The re-expansion (TT-thrash) note for a `--distinct` report. Re-expansion is
/// `nodes ÷ distinct` -- expansions per distinct position: `1.0×` means the table
/// held the whole working set, higher means eviction forced recompute. `recomputed`
/// is the share of expansions that were redundant, `(nodes − distinct) ⁄ nodes`,
/// which is only defined when `nodes > distinct`. It can fail to be when `distinct`
/// is a *known reference* count the run is compared against (the exact `n ≤ 12`
/// figures) or merely HyperLogLog estimator noise -- in which case there is simply
/// no thrash, so we say so rather than print a contradictory sub-`1.0×` ratio or a
/// nonsensical negative percentage.
fn reexp_note(nodes: f64, distinct: f64) -> String {
    if nodes <= distinct {
        return "no re-expansion (≈1.0×)".to_string();
    }
    format!(
        "{:.2}× re-expansion, {:.1}% recomputed",
        nodes / distinct,
        (1.0 - distinct / nodes) * 100.0,
    )
}

/// Checkpoint-related CLI options for `solve`, bundled so the signature stays
/// readable. See the `Cmd::Solve` flags for semantics.
struct CpOpts {
    checkpoint: Option<PathBuf>,
    no_checkpoint: bool,
    every: Duration,
    resume: Option<PathBuf>,
}

/// A resolved, active checkpoint: where to write the image, how often, and which
/// board it is (for the header). Built by [`CpOpts::resolve`] only when checkpointing
/// is actually on.
struct Checkpoint {
    path: PathBuf,
    every: Duration,
    n: u32,
}

impl CpOpts {
    /// The default checkpoint path for board `n` (current dir).
    fn default_path(n: u32) -> PathBuf {
        PathBuf::from(format!("queens-tt-n{n}.zst"))
    }

    /// Resolve whether checkpointing is on for this run and where it writes.
    /// Opt-in via `--checkpoint`, **defaulting ON for n=16** and off below;
    /// `--no-checkpoint` forces it off. `None` ⇒ no checkpointing.
    fn resolve(&self, n: u32) -> Option<Checkpoint> {
        if self.no_checkpoint || !(self.checkpoint.is_some() || n == 16) {
            return None;
        }
        let path = self
            .checkpoint
            .clone()
            .filter(|p| !p.as_os_str().is_empty())
            .unwrap_or_else(|| Self::default_path(n));
        Some(Checkpoint {
            path,
            every: self.every,
            n,
        })
    }
}

/// Parse a checkpoint cadence: `<n>[s|m|h]` (no suffix = seconds).
fn parse_duration(s: &str) -> Result<Duration, String> {
    let s = s.trim();
    let split = s.find(|c: char| !c.is_ascii_digit()).unwrap_or(s.len());
    let (num, unit) = s.split_at(split);
    let v: u64 = num
        .parse()
        .map_err(|_| format!("invalid duration '{s}' (want e.g. 5m, 300s, 2h)"))?;
    let secs = match unit {
        "" | "s" => v,
        "m" => v * 60,
        "h" => v * 3600,
        other => return Err(format!("unknown duration unit '{other}' (use s/m/h)")),
    };
    Ok(Duration::from_secs(secs))
}

/// Render a cadence compactly for the status line (`300s` → `5m`).
fn fmt_dur(d: Duration) -> String {
    let s = d.as_secs();
    if s > 0 && s.is_multiple_of(3600) {
        format!("{}h", s / 3600)
    } else if s > 0 && s.is_multiple_of(60) {
        format!("{}m", s / 60)
    } else {
        format!("{s}s")
    }
}

/// A sibling path with `suffix` appended to the full filename (`foo.zst` →
/// `foo.zst.tmp`), for the atomic-write temp + the kept-prior rotation.
fn sibling(path: &Path, suffix: &str) -> PathBuf {
    PathBuf::from(format!("{}{suffix}", path.display()))
}

/// Write `tt` as a compressed image to `path` atomically: encode to `path.tmp`,
/// rotate any existing image to `path.prev`, then rename into place -- so a crash
/// mid-write never corrupts the last good checkpoint. Returns the compressed size.
fn write_checkpoint(tt: &QueensTt, n: u32, path: &Path) -> io::Result<u64> {
    let tmp = sibling(path, ".tmp");
    {
        let mut enc = zstd::Encoder::new(BufWriter::new(File::create(&tmp)?), 3)?;
        tt.dump_image(&mut enc, n as u8)?;
        enc.finish()?.flush()?;
    }
    if path.exists() {
        let _ = std::fs::rename(path, sibling(path, ".prev"));
    }
    std::fs::rename(&tmp, path)?;
    Ok(std::fs::metadata(path)?.len())
}

/// Reload a compressed image into a fresh table (header-validated; hard error on a
/// stale/foreign/ wrong-`n` dump).
fn read_checkpoint(path: &Path, n: u32) -> io::Result<QueensTt> {
    let mut dec = zstd::Decoder::new(BufReader::new(File::open(path)?))?;
    QueensTt::load_image(&mut dec, n as u8)
}

/// Dump the solver's table to its checkpoint path, reporting the outcome on a dim
/// line. A no-op (but warns) if the solver has no table. `reason` tags why
/// (periodic / sigusr2 / interrupt / final).
fn do_checkpoint(solver: &dyn Solver, cp: &Checkpoint, reason: &str) {
    let Some(tt) = solver.tt() else {
        eprintln!("\x1b[90m(checkpoint [{reason}] skipped: solver has no table)\x1b[0m");
        return;
    };
    let t = Instant::now();
    match write_checkpoint(tt, cp.n, &cp.path) {
        Ok(bytes) => eprintln!(
            "\x1b[90m(checkpoint [{reason}]: {} → {:.2} GB in {:.1}s)\x1b[0m",
            cp.path.display(),
            bytes as f64 / 1e9,
            t.elapsed().as_secs_f64(),
        ),
        Err(e) => eprintln!("\x1b[90m(checkpoint [{reason}] FAILED: {e})\x1b[0m"),
    }
}

fn solve(q: &Queens, solver_name: &str, distinct: bool, cp_opts: CpOpts) {
    let bits = tt_bits(q.n);
    // --distinct reports the re-expansion ratio (nodes ÷ distinct). For even
    // boards n ≤ 12 the distinct count is already known *exactly* (the table), so
    // we report that and skip the live counter; only n ≥ 14 needs a HyperLogLog
    // estimate (and only the table-backed solvers carry one).
    let live_count = distinct && q.n.is_multiple_of(2) && q.n > 12;
    // --resume reloads a checkpoint image into the table and wraps the matching
    // table-backed solver around it (warm start); otherwise build a fresh solver.
    let solver: Box<dyn Solver> = match &cp_opts.resume {
        Some(path) => {
            let mut tt = match read_checkpoint(path, q.n) {
                Ok(tt) => tt,
                Err(e) => {
                    eprintln!("resume: cannot load {}: {e}", path.display());
                    std::process::exit(1);
                }
            };
            if live_count {
                tt.attach_counter(16, false);
            }
            eprintln!(
                "\x1b[90m(resumed TT from {} — {})\x1b[0m",
                path.display(),
                tt.summary(),
            );
            match solver_name {
                "parallel" => Box::new(Parallel::from_tt(tt)),
                "symmetry" => Box::new(Tt::from_tt(tt, true)),
                "memo" => Box::new(Tt::from_tt(tt, false)),
                other => {
                    eprintln!("resume needs a table-backed solver (parallel/symmetry/memo); got {other}.");
                    std::process::exit(1);
                }
            }
        }
        None => match (live_count, solver_name) {
            (true, "parallel") => Box::new(Parallel::new_counting(bits, 16)),
            (true, "symmetry") => Box::new(Tt::new_counting(bits, true, 16, false)),
            (true, "memo") => Box::new(Tt::new_counting(bits, false, 16, false)),
            (true, other) => {
                eprintln!("--distinct estimates need memo/symmetry/parallel; ignoring for {other}.");
                make_solver(other, bits).unwrap()
            }
            (false, name) => make_solver(name, bits).unwrap(),
        },
    };
    // Resolve checkpointing (opt-in; defaults on for n=16). Only the table-backed
    // solvers can dump -- warn and disable if checkpointing was asked for otherwise.
    let mut checkpoint = cp_opts.resolve(q.n);
    if checkpoint.is_some() && solver.tt().is_none() {
        eprintln!(
            "checkpoint: {} has no transposition table; checkpointing disabled.",
            solver.name(),
        );
        checkpoint = None;
    }
    if let Some(cp) = &checkpoint {
        eprintln!(
            "\x1b[90m(checkpointing to {} every {} — SIGUSR2 to dump now)\x1b[0m",
            cp.path.display(),
            fmt_dur(cp.every),
        );
    }
    let t = Instant::now();
    let n = q.n;
    // A live progress bar only for the slow boards (a search that runs > ~1 s,
    // i.e. n ≥ 14) and when stderr is a real terminal (so piped output / tests
    // stay clean).
    let bar = show_bar(n);
    // Solve, then PRINT THE VERDICT IMMEDIATELY -- the optimal line below is a
    // separate, cheaper step (parity-aware PV) and must not gate the result; the
    // verdict is settled the moment `first_player_wins` returns (backlog #21).
    let first_wins = run_watched(solver.as_ref(), n, bar, checkpoint.as_ref(), || {
        solver.first_player_wins(q)
    });
    // The search is done -- the table is at its most complete, so take the final
    // checkpoint now (before the cheap PV), so a resume starts from the full result.
    if let Some(cp) = &checkpoint {
        do_checkpoint(solver.as_ref(), cp, "final");
    }
    let elapsed = t.elapsed().as_secs_f64();
    let winner = if first_wins { "first" } else { "second" };
    println!(
        "On the {n}×{n} board the {winner} player wins with perfect play.",
        n = q.n,
    );
    // The optimal line. `principal_variation` is value-aware: a loss ply takes the
    // first legal move with no search, only win plies search (warm TT + α-β cutoff),
    // so this no longer re-searches every root subtree single-core.
    let pv = run_watched(solver.as_ref(), n, bar, None, || {
        q.principal_variation(solver.as_ref(), first_wins)
    });
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
    // Distinct is measured live (HyperLogLog) for n ≥ 14; for even n ≤ 12 we instead
    // compare this run's node count against the *known* exact distinct count (the
    // table), so the figure is labelled as the reference it is, not a fresh measure.
    if distinct && q.n.is_multiple_of(2) {
        let nodes = solver.nodes() as f64;
        let (distinct, label) = match solver.report() {
            Some(rep) => (
                rep.estimate,
                format!(
                    "≈{} (HLL ±{:.1}%)",
                    commas(rep.estimate as u64),
                    1.04 / (rep.registers as f64).sqrt() * 100.0
                ),
            ),
            None => {
                let exact = DISTINCT_POSITIONS[q.n as usize] as f64;
                (exact, format!("{} (known exact)", commas(exact as u64)))
            }
        };
        println!(
            "\x1b[90m(distinct {label} · {})\x1b[0m",
            reexp_note(nodes, distinct),
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
fn count_mode(q: &Queens, parallel: bool, exact: bool, iso: bool, comps: bool, hll_p: u32) {
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
    println!("  {}", reexp_note(nodes as f64, distinct));
    println!("  elapsed: {elapsed:.3}s");

    if iso {
        iso_report(q, solver.as_ref());
    }
    if comps {
        comps_report(q, solver.as_ref());
    }
}

/// `count --comps`: the connected-component-size distribution of the available-graphs
/// over the working set -- the empirical case for the `tiny_comp_key` shortcut (#18).
/// Deep in the search the graph fragments into overwhelmingly tiny components (isolated
/// vertex, edge), which the shortcut keys by sorted degree sequence alone; this reports
/// how dominant that regime is. Drives the *same* decomposition the live key uses, via
/// the `HIST = true` monomorphisation of the graph key (the production `HIST = false`
/// emits no tally), so the sizes measured are exactly the ones the key sees.
fn comps_report(q: &Queens, solver: &dyn Solver) {
    let Some(ws) = solver.working_set() else {
        eprintln!("  (comps: no exact working set captured — needs the sequential exact solver)");
        return;
    };
    let mut hist = vec![0u64; (q.n * q.n) as usize + 1];
    for &(mask, _) in &ws {
        q.tally_components(mask, &mut hist);
    }
    let total: u64 = hist.iter().sum();
    if total == 0 {
        return;
    }
    println!(
        "  available-graph component sizes over {} D4-distinct positions ({} components):",
        commas(ws.len() as u64),
        commas(total),
    );
    let mut cum = 0u64;
    for (k, &c) in hist.iter().enumerate() {
        if c == 0 {
            continue;
        }
        cum += c;
        println!(
            "    k={k:>3}: {:>15}  ({:6.2}%, cum {:6.2}%)",
            commas(c),
            c as f64 / total as f64 * 100.0,
            cum as f64 / total as f64 * 100.0,
        );
    }
}

/// `count --iso`: measure how much the distinct working set would shrink if the TT
/// key canonicalised the **available-graph up to isomorphism** rather than only the 8
/// board symmetries -- the lever-#7 question. Reports three keys of rising strength
/// (1-WL, 1-WL + individualisation, a true IR canonical form) and, for each, whether
/// the merge is **win/loss-consistent** (no class mixing a win with a loss) -- the
/// test of whether it is usable as a safe TT key. Values come from the exact key→value
/// map recorded at `put`, never the lossy TT (whose evictions would fake mixes).
fn iso_report(q: &Queens, solver: &dyn Solver) {
    let Some(ws) = solver.working_set() else {
        eprintln!("  (iso: no exact working set captured — needs the sequential exact solver)");
        return;
    };
    let d4 = ws.len() as f64;
    println!(
        "  graph-iso merge over {} D4-distinct positions (safe = win/loss-consistent):",
        commas(d4 as u64),
    );
    // Two invariants of increasing strength: plain 1-WL, then 1-WL + per-vertex
    // individualisation (much stronger on these WL-hard graphs). A *consistent*
    // invariant (no class mixing a win with a loss) is usable as a safe TT key,
    // delivering its merge directly; a mixed one only brackets the safe merge.
    iso_bracket("1-WL          ", &ws, d4, |k| q.iso_key(k));
    iso_bracket("1-WL + indiv. ", &ws, d4, |k| q.iso_key_ir(k));
    iso_bracket("IR canon      ", &ws, d4, |k| q.iso_key_canon(k));
}

/// Group the D4-canonical working set by `keyfn` and print the achievable safe merge.
/// A win/loss TT key only needs same-key ⇒ same-value, so a value-consistent class is
/// safe to merge; a mixed class (two values under one key) means the invariant is too
/// coarse there. When mixed classes remain, the safe merge a true canon could reach is
/// bracketed: floor un-merges each mixed class to its 2 values, ceiling un-merges it
/// wholesale (depends how WL-conflated vs genuinely non-isomorphic the class is).
fn iso_bracket(label: &str, ws: &[(Bits, u8)], d4: f64, keyfn: impl Fn(Bits) -> u64) {
    let mut by: HashMap<u64, (u64, u8, bool)> = HashMap::new(); // key → (count, first val, mixed?)
    for &(k, val) in ws {
        let e = by.entry(keyfn(k)).or_insert((0, val, false));
        e.0 += 1;
        e.2 |= e.1 != val;
    }
    let distinct = by.len() as f64;
    let mixed = by.values().filter(|&&(_, _, m)| m).count() as u64;
    let consistent = by.values().filter(|&&(_, _, m)| !m).count() as u64;
    let unsafe_keys: u64 = by.values().filter(|&&(_, _, m)| m).map(|&(c, ..)| c).sum();
    if mixed == 0 {
        println!(
            "    {label}: {} distinct → SAFE key, {:.2}× merge (win/loss-consistent, usable as-is)",
            commas(distinct as u64),
            d4 / distinct,
        );
    } else {
        let safe_floor = consistent + 2 * mixed; // mixed class → its 2 values
        let safe_ceiling = consistent + unsafe_keys; // mixed class → all un-merged
        println!(
            "    {label}: {} distinct ({:.2}× raw) — {} mixed classes, {:.1}% keys unsafe; \
             safe merge ∈ [{:.2}×, {:.2}×]",
            commas(distinct as u64),
            d4 / distinct,
            commas(mixed),
            unsafe_keys as f64 / d4 * 100.0,
            d4 / safe_ceiling as f64,
            d4 / safe_floor as f64,
        );
    }
}

/// Warm the shared table with one parallel root solve so the per-move `best_move`
/// calls in self-play / play hit it. `best_move` goes through the *sequential*
/// `Solver::wins`, so without this the first even-board move would re-search the
/// whole tree single-core -- far slower than `solve`, which warms the table the
/// same way via `first_player_wins`. Odd boards are O(1) (no search to warm).
fn warm_table(q: &Queens, solver: &dyn Solver) {
    if q.is_odd() {
        return; // odd: O(1) mirror line, no search to warm
    }
    // Show the bar (and handle signals) for the slow warm-ups (n ≥ 14); the
    // smaller even boards finish in well under a second, no indicator needed.
    run_watched(solver, q.n, show_bar(q.n), None, || {
        solver.first_player_wins(q);
    });
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
