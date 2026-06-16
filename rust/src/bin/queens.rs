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
use std::sync::{Arc, OnceLock};
use std::thread;
use std::time::{Duration, Instant};

use clap::builder::PossibleValuesParser;
use clap::{Parser, Subcommand};
use signal_hook::consts::{SIGINT, SIGTERM, SIGUSR1, SIGUSR2};
use signal_hook::iterator::Signals;

use othello::burr::{Archive, ShardedArchive};
use othello::queens::{
    for_each_image_entry, make_solver, Bits, Incremental, Nimber, Parallel, Queens, QueensTt,
    Solver, Tt, MAX_N, SOLVER_NAMES,
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
        #[arg(default_value = "incremental", value_parser = PossibleValuesParser::new(SOLVER_NAMES))]
        solver: String,
        /// Also estimate the *distinct* positions (HyperLogLog) so the report
        /// shows how much the search re-expands -- the transposition table's
        /// thrash: nodes ÷ distinct. Adds a little per-node overhead (memo /
        /// symmetry / parallel only).
        #[arg(long)]
        distinct: bool,
        /// Enable a compressed, resumable TT checkpoint at PATH: press **S** (or send
        /// SIGUSR2) to snapshot on demand, plus a save on exit. With no PATH it uses
        /// ./queens-tt-n<N>.zst. **Opt-in** (off by default at every n); resume with
        /// --resume. Table-backed solvers only (parallel / incremental / symmetry / memo).
        #[arg(long, value_name = "PATH", num_args = 0..=1, default_missing_value = "")]
        checkpoint: Option<PathBuf>,
        /// Add an automatic checkpoint cadence on top of the on-demand S/SIGUSR2 saves,
        /// e.g. `30m`, `2h` (no suffix = seconds). Omitted ⇒ no periodic dump (manual
        /// only) -- the dump is costly at n=16, so a cadence is opt-in.
        #[arg(long, value_name = "DUR", value_parser = parse_duration)]
        checkpoint_every: Option<Duration>,
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
        /// Measure the **#9 free-involution P-certificate fire-rate**: the fraction of
        /// distinct loss positions that are 180°-symmetric and off both centre
        /// diagonals (so the mover provably loses with no search). Decides whether
        /// wiring the certificate into the search is worth its per-node cost. Implies
        /// `--exact`; sequential.
        #[arg(long)]
        psym: bool,
        /// Measure the **per-root working set + cross-root transposition rate**: search
        /// each symmetry-distinct first move with a cold exact-counting TT and report
        /// (A) per-root distinct sizes — does the biggest root fit a single-box TT? —
        /// and (B) how many roots touch each position (Σ-per-root ÷ union = the
        /// cross-root reuse a staged freeze-after-each-root cascade must preserve).
        /// Sizes the Chunk-4 staged-cascade lever. Even n only; does its own searches.
        #[arg(long)]
        roots: bool,
        /// Measure **b̄ (canons per distinct node)** and the **win-node cutoff
        /// distribution**: total `node_key` (canon) calls ÷ distinct positions = the
        /// per-node canonicalisation multiplier the theoretical floor turns on, plus how
        /// many moves are tried before the α-β cutoff fires at win nodes (mean ≈ 1 ⇒
        /// move ordering near-optimal ⇒ searched set ≈ minimal proof DAG). Sequential.
        #[arg(long)]
        branching: bool,
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
        #[arg(long, default_value = "incremental", value_parser = PossibleValuesParser::new(SOLVER_NAMES))]
        engine: String,
    },
    /// Play against the engine as player 1 (first) or 2 (second).
    Play {
        #[arg(default_value_t = 8, value_parser = clap::value_parser!(u32).range(1..=MAX_N as i64))]
        n: u32,
        #[arg(default_value_t = 1, value_parser = clap::value_parser!(u32).range(1..=2))]
        player: u32,
    },
    /// Freeze a dumped TT image into an immutable **BuRR archive** (Chunk 4): a
    /// ribbon-retrieval layer storing each solved position's win/loss plus a
    /// membership fingerprint at ~`1.1*(1+fp_bits)` bits/key, with no eviction.
    /// Reads the `.zst` checkpoint `solve --checkpoint` writes.
    Freeze {
        /// Board the dump belongs to (its header is validated against this).
        #[arg(value_parser = clap::value_parser!(u32).range(1..=MAX_N as i64))]
        n: u32,
        /// Path to the dumped TT image (`.zst`).
        image: PathBuf,
        /// Output archive path.
        out: PathBuf,
        /// Membership fingerprint width (bits). A query that mismatches is a miss;
        /// a wrong accept is ~`layers*2^-fp_bits` per out-of-set probe -- size it
        /// against the expected non-member query count (the live-integration cost).
        #[arg(long, default_value_t = 44)]
        fp_bits: u32,
        /// Per-layer ribbon load factor (higher = denser + more bump layers).
        #[arg(long, default_value_t = 0.90)]
        load: f64,
        /// Build in this many key-partitioned shards via that many passes over the
        /// dump -- bounds build RAM to ~`1/shards` of the whole (needed for n=16).
        #[arg(long, default_value_t = 1, value_parser = clap::value_parser!(u32).range(1..=4096))]
        shards: u32,
        /// After building, re-stream the dump and confirm every frozen key
        /// round-trips, then measure the false-positive rate on synthetic non-keys.
        #[arg(long)]
        verify: bool,
    },
    /// Verify a BuRR archive against its source dump: every frozen key round-trips
    /// to its stored win/loss, and report the measured false-positive rate.
    VerifyArchive {
        #[arg(value_parser = clap::value_parser!(u32).range(1..=MAX_N as i64))]
        n: u32,
        /// The source TT image the archive was frozen from.
        image: PathBuf,
        /// The archive built by `freeze`.
        archive: PathBuf,
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
        solver: "incremental".into(),
        distinct: false,
        checkpoint: None,
        checkpoint_every: None,
        resume: None,
    });
    match cmd {
        Cmd::Solve {
            n,
            solver,
            distinct,
            checkpoint,
            checkpoint_every,
            resume,
        } => solve(
            &Queens::new(n),
            &solver,
            distinct,
            CpOpts {
                checkpoint,
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
            psym,
            roots,
            branching,
            hll_p,
        } => {
            let q = Queens::new(n);
            if roots {
                roots_report(&q, hll_p);
            } else {
                count_mode(
                    &q,
                    // branching needs the sequential const-generic path, like the other
                    // exact sub-reports.
                    parallel && !iso && !comps && !psym && !branching,
                    exact || iso || comps || psym,
                    iso,
                    comps,
                    psym,
                    branching,
                    hll_p,
                );
            }
        }
        Cmd::SelfPlay { n, engine } => self_play(&Queens::new(n), &engine),
        Cmd::Play { n, player } => play(&Queens::new(n), player == 1),
        Cmd::Freeze {
            n,
            image,
            out,
            fp_bits,
            load,
            shards,
            verify,
        } => freeze(n, &image, &out, fp_bits, load, shards, verify),
        Cmd::VerifyArchive { n, image, archive } => verify_archive(n, &image, &archive),
    }
}

/// `--list-engines`: a width-aware table of the solver ladder. Every solver
/// computes the exact value to the end of the game, so "default depth" is always
/// "full"; what differs is the technique and the parallelism. Order matches
/// `SOLVER_NAMES`.
fn list_engines() {
    const INFO: [(&str, &str, &str); 7] = [
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
            "incremental",
            "+ DFS-resident incremental canon (8 orientations carried, updated per move) — the default",
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

/// Format an elapsed duration as `XmYs` (or `XhYmZs`, or `S.SSs` under a minute) --
/// readable for the multi-minute n=16 solve and its dumps, where raw seconds (`2025s`)
/// are hard to parse. Sub-minute keeps two decimals so the short n≤14 benches stay precise.
fn fmt_elapsed(secs: f64) -> String {
    if secs < 60.0 {
        return format!("{secs:.2}s");
    }
    let s = secs as u64;
    let (h, m, sec) = (s / 3600, (s % 3600) / 60, s % 60);
    if h > 0 {
        format!("{h}h{m:02}m{sec:02}s")
    } else {
        format!("{m}m{sec:02}s")
    }
}

/// A one-line on-demand report for a running solve (SIGUSR1) or its termination
/// (SIGINT/SIGTERM), printed to stderr.
fn status_report(label: &str, n: u32, solver: &dyn Solver, start: Instant) -> String {
    let secs = start.elapsed().as_secs_f64();
    let nodes = solver.nodes();
    format!(
        "[queens {n}×{n}] {label}: {} nodes searched in {} ({})",
        commas(nodes),
        fmt_elapsed(secs),
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
/// Which phase of `solve` a progress bar is tracking. The **optimal-line** (PV) step
/// runs after the search prints its verdict + stats, so its bar is reset to count only
/// the nodes *that step* walks (`node_base` = the solver's node total when it began),
/// not the billions from the whole search.
#[derive(Clone, Copy)]
enum Phase {
    Search,
    OptimalLine { node_base: u64 },
}

fn progress_bar(n: u32, solver: &dyn Solver, start: Instant, phase: Phase) -> String {
    let secs = start.elapsed().as_secs_f64();
    let node_base = match phase {
        Phase::Search => 0,
        Phase::OptimalLine { node_base } => node_base,
    };
    let node_count = solver.nodes().saturating_sub(node_base);
    let rate = fmt_rate(node_count, secs);
    let nodes = commas(node_count);
    let elapsed = fmt_elapsed(secs);
    let spin = SPINNER[((secs * 8.0) as usize) % SPINNER.len()];
    // The optimal-line step walks one line, not the root fan-out, so it shows just its
    // own node tally -- no roots bar, no re-expansion ratio (those describe the search).
    if let Phase::OptimalLine { .. } = phase {
        return format!("{spin} {n}×{n} optimal line · {nodes} nodes · {elapsed} · {rate}");
    }
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
            format!("{spin} {n}×{n} [{bar}] {done}/{total} roots · {nodes} nodes{reexp} · {elapsed} · {rate}")
        }
        None => format!("{spin} {n}×{n} · {nodes} nodes{reexp} · {elapsed} · {rate}"),
    }
}

/// Background watcher for a running solve: each tick it drains arrived signals
/// (SIGUSR1 → progress dump; SIGUSR2 → checkpoint now; SIGINT/SIGTERM → checkpoint
/// (if enabled), report "how far we got", then exit), fires the periodic checkpoint
/// when `cp` is due, and, when `bar`, repaints the in-place progress line. Polling
/// keeps it the sole stderr writer with no work in async-signal context. Stops when
/// the solve sets `done`.
// Distinct, hard-to-bundle concerns (signal source, solver, bar geometry, checkpoint,
// terminal state, done flag); a context struct would only relocate the same fields.
#[allow(clippy::too_many_arguments)]
fn watch(
    signals: &mut Signals,
    solver: &dyn Solver,
    n: u32,
    start: Instant,
    bar: bool,
    cp: Option<&Checkpoint>,
    kb_orig: Option<libc::termios>,
    phase: Phase,
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
                    let what = if sig == SIGINT {
                        "interrupted (SIGINT)"
                    } else {
                        "terminated (SIGTERM)"
                    };
                    // Save before exiting so a Ctrl-C / preemption keeps the work --
                    // but the n=16 dump is multi-GB and slow, so say what's happening
                    // and how to skip it, then arm the double-interrupt fast path: with
                    // the flag set, a *second* SIGINT/SIGTERM trips
                    // `register_conditional_shutdown` and `_exit`s immediately (mid-dump).
                    if let Some(cp) = cp {
                        eprintln!(
                            "\x1b[33m{what} — saving a resumable checkpoint to {} before exit; \
                             press Ctrl-C again to skip it and exit now.\x1b[0m",
                            cp.path.display(),
                        );
                        let flag = checkpointing_flag();
                        flag.store(true, Ordering::SeqCst);
                        do_checkpoint(solver, cp, "interrupt", n, start, bar);
                        flag.store(false, Ordering::SeqCst);
                    }
                    eprintln!("{}", status_report(what, n, solver, start));
                    if let Some(orig) = &kb_orig {
                        restore_terminal(orig); // leave the terminal usable on exit
                    }
                    std::process::exit(128 + sig); // 130 (SIGINT) / 143 (SIGTERM)
                }
                SIGUSR2 => {
                    if let Some(cp) = cp {
                        do_checkpoint(solver, cp, "sigusr2", n, start, bar);
                        last_cp = Instant::now();
                    }
                }
                _ => eprintln!(
                    "{}",
                    status_report("in progress (SIGUSR1)", n, solver, start)
                ),
            }
        }
        // On-demand snapshot: 'S'/'s' from the terminal triggers a checkpoint, like
        // SIGUSR2 -- caught in cbreak mode without an Enter. `kb_orig` is `Some` only
        // when stdin is a tty AND checkpointing is on, so this is inert otherwise.
        if kb_orig.is_some() && poll_key_s() {
            if let Some(cp) = cp {
                clear();
                do_checkpoint(solver, cp, "keypress", n, start, bar);
                last_cp = Instant::now();
            }
        }
        if done.load(Ordering::Relaxed) {
            break;
        }
        // Periodic checkpoint (opt-in via --checkpoint-every; `None` ⇒ on-demand only).
        // The search keeps running (the dump is lock-free relaxed loads), and
        // `do_checkpoint` keeps the live search bar ticking with the checkpoint progress
        // folded in, so the bar never goes dark while the image streams.
        if let Some(cp) = cp {
            if let Some(every) = cp.every {
                if last_cp.elapsed() >= every {
                    do_checkpoint(solver, cp, "periodic", n, start, bar);
                    last_cp = Instant::now();
                }
            }
        }
        if bar {
            // Truncate to the terminal width so the line never wraps (a wrapped
            // line defeats the `\r` overwrite and leaves garbage); the glyphs are
            // all one column wide, so chars == columns. Clear to end-of-line after,
            // since this line may be shorter than the last.
            let cols = term_cols().saturating_sub(1);
            let line: String = progress_bar(n, solver, start, phase)
                .chars()
                .take(cols)
                .collect();
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

/// Put stdin in **cbreak** mode -- non-canonical, no echo, but ISIG kept so Ctrl-C
/// still raises SIGINT -- and non-blocking, so the watcher can catch a single `S`
/// keypress without an Enter. Returns the original termios to restore on exit, or
/// `None` if stdin is not a tty or the call fails (then the `S` trigger is simply
/// inactive -- SIGUSR2 still works). Caveat: the rare double-Ctrl-C `_exit`
/// (`register_conditional_shutdown`) cannot restore this; a `reset` fixes the echo.
fn enter_cbreak() -> Option<libc::termios> {
    if !io::stdin().is_terminal() {
        return None;
    }
    let fd = libc::STDIN_FILENO;
    // SAFETY: `tcgetattr`/`tcsetattr`/`fcntl` on the stdin fd with a zeroed-then-filled
    // `termios`; all async-signal-safe POSIX calls that only touch terminal/fd flags,
    // never memory we own. Any failure is surfaced as `None` (feature off).
    unsafe {
        let mut orig: libc::termios = std::mem::zeroed();
        if libc::tcgetattr(fd, &mut orig) != 0 {
            return None;
        }
        let mut raw = orig;
        raw.c_lflag &= !((libc::ICANON | libc::ECHO) as libc::tcflag_t); // keep ISIG
        if libc::tcsetattr(fd, libc::TCSANOW, &raw) != 0 {
            return None;
        }
        let flags = libc::fcntl(fd, libc::F_GETFL);
        if flags != -1 {
            libc::fcntl(fd, libc::F_SETFL, flags | libc::O_NONBLOCK);
        }
        Some(orig)
    }
}

/// Undo [`enter_cbreak`]: restore the saved termios and clear stdin's non-blocking
/// flag. Safe to call once on each exit path.
fn restore_terminal(orig: &libc::termios) {
    let fd = libc::STDIN_FILENO;
    // SAFETY: restores the saved termios + clears O_NONBLOCK on stdin; same
    // async-signal-safe POSIX calls as `enter_cbreak`, touching no memory we own.
    unsafe {
        libc::tcsetattr(fd, libc::TCSANOW, orig);
        let flags = libc::fcntl(fd, libc::F_GETFL);
        if flags != -1 {
            libc::fcntl(fd, libc::F_SETFL, flags & !libc::O_NONBLOCK);
        }
    }
}

/// Drain pending stdin bytes (non-blocking) and report whether any is `S`/`s`. ONLY
/// call when [`enter_cbreak`] succeeded -- it set stdin non-blocking, so this never
/// blocks; on a blocking fd a `read` with no input would hang the watcher.
fn poll_key_s() -> bool {
    let mut buf = [0u8; 64];
    let mut hit = false;
    loop {
        // SAFETY: non-blocking `read` into a stack buffer of `buf.len()` bytes; returns
        // <= 0 (EAGAIN) when nothing is pending, since stdin was set `O_NONBLOCK`.
        let nbytes = unsafe {
            libc::read(
                libc::STDIN_FILENO,
                buf.as_mut_ptr() as *mut libc::c_void,
                buf.len(),
            )
        };
        if nbytes <= 0 {
            break;
        }
        let nbytes = nbytes as usize;
        hit |= buf[..nbytes].iter().any(|&b| b == b'S' || b == b's');
        if nbytes < buf.len() {
            break;
        }
    }
    hit
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
    phase: Phase,
    work: impl FnOnce() -> R,
) -> R {
    let start = Instant::now();
    // Arm the double-interrupt fast path up front, before the search starts, so a
    // second Ctrl-C during the exit checkpoint exits immediately (the registration
    // must already be in place when that second signal lands).
    if cp.is_some() {
        checkpointing_flag();
    }
    // With checkpointing on, put the terminal in cbreak so a single `S` keypress
    // snapshots on demand (no Enter). `termios` is `Copy`, so the watcher gets a copy
    // to restore on its SIGINT exit path; we restore the original after a normal solve.
    let kb_orig = if cp.is_some() { enter_cbreak() } else { None };
    let mut signals = Signals::new([SIGINT, SIGTERM, SIGUSR1, SIGUSR2]).ok();
    let done = AtomicBool::new(false);
    let result = thread::scope(|scope| {
        let watcher = signals.as_mut().map(|signals| {
            let done = &done;
            scope.spawn(move || watch(signals, solver, n, start, bar, cp, kb_orig, phase, done))
        });
        let result = work();
        done.store(true, Ordering::Relaxed);
        if let Some(watcher) = &watcher {
            watcher.thread().unpark(); // wake it now so the scope joins promptly
        }
        result
    });
    if let Some(orig) = &kb_orig {
        restore_terminal(orig); // normal-completion restore (the SIGINT path self-restores)
    }
    result
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
    every: Option<Duration>,
    resume: Option<PathBuf>,
}

/// A resolved, active checkpoint: where to write the image, the optional automatic
/// cadence (`None` ⇒ on-demand only), and which board it is (for the header). Built by
/// [`CpOpts::resolve`] only when checkpointing is actually on.
struct Checkpoint {
    path: PathBuf,
    every: Option<Duration>,
    n: u32,
}

impl CpOpts {
    /// The default checkpoint path for board `n` (current dir).
    fn default_path(n: u32) -> PathBuf {
        PathBuf::from(format!("queens-tt-n{n}.zst"))
    }

    /// Resolve whether checkpointing is on for this run and where it writes.
    /// **Opt-in**: on only when `--checkpoint` was given (no n=16 default). `None` ⇒ no
    /// checkpointing. The automatic cadence ([`Checkpoint::every`]) is separately opt-in
    /// via `--checkpoint-every`; without it, saves are on-demand (S / SIGUSR2) + on exit.
    fn resolve(&self, n: u32) -> Option<Checkpoint> {
        let checkpoint = self.checkpoint.as_ref()?;
        let path = Some(checkpoint.clone())
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
/// zstd level for the checkpoint stream. The dump is **CPU-bound**, not IO-bound: a
/// single zstd thread competes with the ~24 rayon search workers, so it crawls under
/// load (~50 MB/s) and only hits NVMe speed (~160 MB/s) when cores free up. Level 1 is
/// the fastest standard level -- far less CPU per byte than the old level 3 -- trading
/// a modestly larger image for a much shorter, less contended dump.
const CHECKPOINT_ZSTD_LEVEL: i32 = 1;

fn write_checkpoint(
    tt: &QueensTt,
    n: u32,
    path: &Path,
    on_block: impl FnMut(u64, u64),
) -> io::Result<u64> {
    let tmp = sibling(path, ".tmp");
    {
        let mut enc =
            zstd::Encoder::new(BufWriter::new(File::create(&tmp)?), CHECKPOINT_ZSTD_LEVEL)?;
        // `on_block(slots_written, total)` per block -- the caller paints progress; the
        // search keeps running (the dump is lock-free relaxed loads on the table).
        tt.dump_image_with(&mut enc, n as u8, on_block)?;
        enc.finish()?.flush()?;
    }
    if path.exists() {
        let _ = std::fs::rename(path, sibling(path, ".prev"));
    }
    std::fs::rename(&tmp, path)?;
    Ok(std::fs::metadata(path)?.len())
}

/// The checkpoint-progress tail appended to the live search bar while a dump streams.
/// Progress is raw slots/bytes processed (the on-disk compressed size is smaller and
/// unknown until the stream finishes), so the search bar keeps ticking alongside the
/// save rather than going dark for the length of a multi-GB dump.
fn dump_suffix(reason: &str, done: u64, total: u64, dump_start: Instant) -> String {
    let frac = if total > 0 {
        done as f64 / total as f64
    } else {
        1.0
    };
    let raw_gb = done as f64 * 8.0 / 1e9;
    let total_gb = total as f64 * 8.0 / 1e9;
    let secs = dump_start.elapsed().as_secs_f64();
    // Plain ASCII (one column per char) so the width-budgeted truncation in the painter
    // is exact -- a wide emoji would overrun the line and defeat the `\r` overwrite.
    format!(
        " · save[{reason}] {:.0}% {raw_gb:.1}/{total_gb:.1} GB {}",
        frac * 100.0,
        fmt_elapsed(secs),
    )
}

/// A flag set only while the *interrupt* checkpoint dump is in flight. A second
/// SIGINT/SIGTERM during that window trips `register_conditional_shutdown` and the
/// process `_exit`s immediately (async-signal-safe), skipping the rest of the dump --
/// so a stuck or slow exit-save is never a trap. Registered once, lazily.
fn checkpointing_flag() -> &'static Arc<AtomicBool> {
    static FLAG: OnceLock<Arc<AtomicBool>> = OnceLock::new();
    FLAG.get_or_init(|| {
        let flag = Arc::new(AtomicBool::new(false));
        let _ = signal_hook::flag::register_conditional_shutdown(SIGINT, 130, Arc::clone(&flag));
        let _ = signal_hook::flag::register_conditional_shutdown(SIGTERM, 143, Arc::clone(&flag));
        flag
    })
}

/// Reload a compressed image into a fresh table (header-validated; hard error on a
/// stale/foreign/ wrong-`n` dump).
fn read_checkpoint(path: &Path, n: u32) -> io::Result<QueensTt> {
    let mut dec = zstd::Decoder::new(BufReader::new(File::open(path)?))?;
    // Paint a load progress bar (the n=16 image is multi-GB to decompress + commit) when
    // stderr is a terminal; throttle to ~100 ms. The search hasn't started yet, so this is
    // the sole stderr writer and the `\r` overwrite is safe.
    let show = io::stderr().is_terminal();
    let start = Instant::now();
    let mut last = Instant::now();
    let mut painted = false;
    let tt = QueensTt::load_image_with(&mut dec, n as u8, |done, total| {
        if !show || (painted && last.elapsed() < Duration::from_millis(100) && done != total) {
            return;
        }
        painted = true;
        last = Instant::now();
        let frac = if total > 0 {
            done as f64 / total as f64
        } else {
            1.0
        };
        const W: usize = 24;
        let filled = (frac * W as f64) as usize;
        let bar: String = "█".repeat(filled) + &"░".repeat(W - filled);
        let line = format!(
            "loading checkpoint [{bar}] {:.0}% · {:.1}/{:.1} GB · {}",
            frac * 100.0,
            done as f64 * 8.0 / 1e9,
            total as f64 * 8.0 / 1e9,
            fmt_elapsed(start.elapsed().as_secs_f64()),
        );
        let cols = term_cols().saturating_sub(1);
        let line: String = line.chars().take(cols).collect();
        eprint!("\r{line}\x1b[K");
        io::stderr().flush().ok();
    })?;
    if painted {
        eprint!("\r\x1b[K"); // clear the bar; the caller prints the resumed-TT line next
        io::stderr().flush().ok();
    }
    Ok(tt)
}

// --------------------------------------------------------------------------- //
// Chunk 4: freeze a dumped TT into an immutable BuRR archive, and verify it.
// --------------------------------------------------------------------------- //

/// Stream a (zstd) TT image, invoking `f(archive_key, val)` per solved position.
/// Each call decompresses the dump once -- the freeze re-reads it per shard to keep
/// build RAM bounded.
fn stream_image<F: FnMut(u64, u8)>(image: &Path, n: u32, f: F) -> io::Result<()> {
    let mut dec = zstd::Decoder::new(BufReader::new(File::open(image)?))?;
    for_each_image_entry(&mut dec, n as u8, f)?;
    Ok(())
}

/// Win/loss is stored 0/1, so the archive carries a 1-bit value. A nimber dump
/// would need more; the freeze rejects it loudly rather than silently truncating.
const ARCHIVE_VAL_BITS: u32 = 1;

/// `freeze`: build an immutable BuRR archive of a dump's solved positions. For
/// `shards == 1` the entries are collected in one pass and built directly; for
/// `shards > 1` the dump is streamed once per shard so the in-flight GE state stays
/// ~`1/shards` of the whole (the n=16 path). The archive is written uncompressed --
/// ribbon layers are high-entropy, so zstd barely helps (unlike the mostly-zero TT).
fn freeze(n: u32, image: &Path, out: &Path, fp_bits: u32, load: f64, shards: u32, verify: bool) {
    let shards = shards as usize;
    let t = Instant::now();
    eprintln!(
        "\x1b[90mfreezing n={n}: {} → {} (val_bits={ARCHIVE_VAL_BITS}, fp_bits={fp_bits}, load={load}, shards={shards})\x1b[0m",
        image.display(),
        out.display(),
    );
    let mut subs: Vec<Archive> = Vec::with_capacity(shards);
    let mut total_seen = 0u64;
    for s in 0..shards {
        let mut pairs: Vec<(u64, u64)> = Vec::new();
        let mut seen = 0u64;
        let res = stream_image(image, n, |key, val| {
            seen += 1;
            if val as u32 > ARCHIVE_VAL_BITS {
                // can't happen for win/loss; guards a mistakenly-frozen nimber dump
                eprintln!("\x1b[31mfreeze: value {val} > {ARCHIVE_VAL_BITS}-bit (nimber dump?); aborting\x1b[0m");
                std::process::exit(1);
            }
            if shards == 1 || ShardedArchive::shard_of(shards, key) == s {
                pairs.push((key, val as u64));
            }
        });
        if let Err(e) = res {
            eprintln!(
                "\x1b[31mfreeze: reading {} failed: {e}\x1b[0m",
                image.display()
            );
            std::process::exit(1);
        }
        total_seen = seen;
        if shards > 1 {
            eprintln!(
                "\x1b[90m  shard {}/{shards}: {} keys, building...\x1b[0m",
                s + 1,
                pairs.len()
            );
        } else {
            eprintln!(
                "\x1b[90m  {} solved positions read; building...\x1b[0m",
                pairs.len()
            );
        }
        subs.push(Archive::build(&pairs, ARCHIVE_VAL_BITS, fp_bits, load));
    }
    let arch = ShardedArchive::from_shards(subs);
    let bytes = match write_archive(&arch, out) {
        Ok(b) => b,
        Err(e) => {
            eprintln!(
                "\x1b[31mfreeze: writing {} failed: {e}\x1b[0m",
                out.display()
            );
            std::process::exit(1);
        }
    };
    let keys = arch.n_keys();
    println!(
        "froze {keys} solved positions ({total_seen} slots) → {:.3} GB archive, \
         {:.2} bits/key, {} shard(s), in {:.1}s",
        bytes as f64 / 1e9,
        arch.bits_per_key(),
        arch.n_shards(),
        t.elapsed().as_secs_f64(),
    );
    println!(
        "  in-RAM archive {:.3} GB ({:.2} bits/key resident) vs dump table at 8 B/slot",
        arch.bits() as f64 / 8.0 / 1e9,
        arch.bits_per_key(),
    );
    if verify {
        run_verify(n, image, &arch);
    }
}

/// Write a sharded archive to `path` (uncompressed; atomic via `.tmp` + rename).
fn write_archive(arch: &ShardedArchive, path: &Path) -> io::Result<u64> {
    let tmp = sibling(path, ".tmp");
    {
        let mut w = BufWriter::new(File::create(&tmp)?);
        arch.write_to(&mut w)?;
        w.flush()?;
    }
    std::fs::rename(&tmp, path)?;
    Ok(std::fs::metadata(path)?.len())
}

/// `verify-archive`: load an archive and check it against its source dump.
fn verify_archive(n: u32, image: &Path, archive_path: &Path) {
    let arch = match File::open(archive_path)
        .and_then(|f| ShardedArchive::read_from(&mut BufReader::new(f)))
    {
        Ok(a) => a,
        Err(e) => {
            eprintln!(
                "\x1b[31mverify: reading {} failed: {e}\x1b[0m",
                archive_path.display()
            );
            std::process::exit(1);
        }
    };
    run_verify(n, image, &arch);
}

/// Re-stream the source dump and confirm every frozen key retrieves its stored
/// win/loss, then measure the false-positive rate on synthetic non-keys. Exits
/// nonzero on any mismatch -- this is the archive's correctness gate.
fn run_verify(n: u32, image: &Path, arch: &ShardedArchive) {
    let t = Instant::now();
    let mut checked = 0u64;
    let mut wrong = 0u64;
    let mut missing = 0u64;
    let res = stream_image(image, n, |key, val| {
        checked += 1;
        match arch.get(key) {
            Some(got) if got == val as u64 => {}
            Some(_) => wrong += 1,
            None => missing += 1,
        }
    });
    if let Err(e) = res {
        eprintln!(
            "\x1b[31mverify: reading {} failed: {e}\x1b[0m",
            image.display()
        );
        std::process::exit(1);
    }
    // False-positive probe: synthetic archive-keys disjoint from the real set
    // (random 64-bit values; the ~billions of real keys are negligible in 2^64).
    let probes = 20_000_000u64;
    let mut fp = 0u64;
    for i in 0..probes {
        let k = splitmix(i ^ 0x1234_5678_9ABC_DEF0);
        if arch.get(k).is_some() {
            fp += 1;
        }
    }
    let fp_rate = fp as f64 / probes as f64;
    println!(
        "verify: {checked} keys checked — {wrong} wrong, {missing} missing ({})",
        if wrong == 0 && missing == 0 {
            "\x1b[32mexact\x1b[0m"
        } else {
            "\x1b[31mFAILED\x1b[0m"
        }
    );
    println!(
        "  false-positive rate {fp_rate:.3e} ({fp}/{probes} non-keys accepted), \
         {:.2} bits/key, {} shard(s), {:.1}s",
        arch.bits_per_key(),
        arch.n_shards(),
        t.elapsed().as_secs_f64(),
    );
    if wrong != 0 || missing != 0 {
        std::process::exit(1);
    }
}

/// SplitMix64 step for the FP probe set (local; the lib mixer is private).
#[inline]
fn splitmix(mut z: u64) -> u64 {
    z = z.wrapping_add(0x9E37_79B9_7F4A_7C15);
    z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
    z ^ (z >> 31)
}

/// Dump the solver's table to its checkpoint path, reporting the outcome on a dim
/// line. A no-op (but warns) if the solver has no table. `reason` tags why
/// (periodic / sigusr2 / interrupt / final).
///
/// While the (multi-GB at n=16) image streams, the **live search bar keeps ticking**
/// with the checkpoint progress folded into the same line: the search runs on the
/// main + rayon threads throughout (the dump is lock-free relaxed loads), and the
/// dump's per-block callback repaints `search_bar + save_suffix` here on the watcher
/// thread. `search_start`/`bar` describe the search bar to keep alive (`bar == false`
/// for piped/non-terminal output, where nothing is painted).
fn do_checkpoint(
    solver: &dyn Solver,
    cp: &Checkpoint,
    reason: &str,
    n: u32,
    search_start: Instant,
    bar: bool,
) {
    let Some(tt) = solver.tt() else {
        eprintln!("\x1b[90m(checkpoint [{reason}] skipped: solver has no table)\x1b[0m");
        return;
    };
    let t = Instant::now();
    let mut last = Instant::now();
    let mut painted = false;
    let res = write_checkpoint(tt, cp.n, &cp.path, |done, total| {
        if !bar || (painted && last.elapsed() < Duration::from_millis(100) && done != total) {
            return;
        }
        painted = true;
        last = Instant::now();
        // Budget the width for the save suffix first, then fill the rest with the live
        // search bar -- so the checkpoint progress is never the part that gets truncated.
        let suffix = dump_suffix(reason, done, total, t);
        let cols = term_cols().saturating_sub(1);
        let keep = cols.saturating_sub(suffix.chars().count());
        let search: String = progress_bar(n, solver, search_start, Phase::Search)
            .chars()
            .take(keep)
            .collect();
        eprint!("\r{search}{suffix}\x1b[K");
        io::stderr().flush().ok();
    });
    if painted {
        eprint!("\r\x1b[K"); // clear the bar line; the summary prints next
        io::stderr().flush().ok();
    }
    match res {
        Ok(bytes) => eprintln!(
            "\x1b[90m(checkpoint [{reason}]: {} → {:.2} GB in {})\x1b[0m",
            cp.path.display(),
            bytes as f64 / 1e9,
            fmt_elapsed(t.elapsed().as_secs_f64()),
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
                "incremental" => Box::new(Incremental::from_tt(tt)),
                "symmetry" => Box::new(Tt::from_tt(tt, true)),
                "memo" => Box::new(Tt::from_tt(tt, false)),
                other => {
                    eprintln!(
                        "resume needs a table-backed solver (parallel/symmetry/memo); got {other}."
                    );
                    std::process::exit(1);
                }
            }
        }
        None => match (live_count, solver_name) {
            (true, "parallel") => Box::new(Parallel::new_counting(bits, 16)),
            (true, "incremental") => Box::new(Incremental::new_counting(bits, 16)),
            (true, "symmetry") => Box::new(Tt::new_counting(bits, true, 16, false)),
            (true, "memo") => Box::new(Tt::new_counting(bits, false, 16, false)),
            (true, other) => {
                eprintln!(
                    "--distinct estimates need memo/symmetry/parallel; ignoring for {other}."
                );
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
        let cadence = match cp.every {
            Some(d) => format!("auto every {}", fmt_dur(d)),
            None => "on demand".to_string(),
        };
        eprintln!(
            "\x1b[90m(checkpoint → {} ({cadence}); press S or send SIGUSR2 to snapshot now)\x1b[0m",
            cp.path.display(),
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
    let first_wins = run_watched(
        solver.as_ref(),
        n,
        bar,
        checkpoint.as_ref(),
        Phase::Search,
        || solver.first_player_wins(q),
    );
    // Capture the search time *before* any post-solve work (final checkpoint, PV) so
    // the reported elapsed is the search, not the multi-minute image dump (#21 spirit).
    let elapsed = t.elapsed().as_secs_f64();
    // The search is done -- the table is at its most complete, so take the final
    // checkpoint now (before the cheap PV), so a resume starts from the full result.
    if let Some(cp) = &checkpoint {
        do_checkpoint(solver.as_ref(), cp, "final", n, t, bar);
    }
    let winner = if first_wins { "first" } else { "second" };
    println!(
        "On the {n}×{n} board the {winner} player wins with perfect play.",
        n = q.n,
    );
    // The search results go out NOW, right under the verdict -- a dim line with the
    // search cost plus approach-specific stats (table fill, nimber value, …). The
    // optimal line below is a separate, cheaper step with its own (reset) bar.
    let mut summary = format!(
        "solver {}: searched {} nodes in {}",
        solver.name(),
        commas(solver.nodes()),
        fmt_elapsed(elapsed),
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
    // Now the optimal line. `principal_variation` is value-aware: a loss ply takes the
    // first legal move with no search, only win plies search (warm TT + α-β cutoff), so
    // it no longer re-searches every root subtree single-core. Its progress bar is reset
    // (`Phase::OptimalLine`) to count only the nodes *this* step walks, not the search's.
    let pv_base = solver.nodes();
    if bar {
        eprintln!(
            "\x1b[90mtracing the optimal line (PV) — the bar below counts only its own nodes…\x1b[0m"
        );
    }
    let pv = run_watched(
        solver.as_ref(),
        n,
        bar,
        None,
        Phase::OptimalLine { node_base: pv_base },
        || q.principal_variation(solver.as_ref(), first_wins),
    );
    let names: Vec<String> = pv.iter().map(|&s| name(q, s)).collect();
    println!("An optimal line ({} moves): {}", pv.len(), names.join("  "));

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
// Cold CLI dispatch: one bool per measurement sub-mode is clearer here than a flags
// struct that exists only to thread straight through to the sub-reports.
#[allow(clippy::too_many_arguments)]
fn count_mode(
    q: &Queens,
    parallel: bool,
    exact: bool,
    iso: bool,
    comps: bool,
    psym: bool,
    branching: bool,
    hll_p: u32,
) {
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
        let tt = Tt::new_counting(bits, true, hll_p, exact);
        Box::new(if branching { tt.with_branching() } else { tt })
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
    if psym {
        psym_report(q, solver.as_ref());
    }
    if branching {
        branching_report(solver.as_ref(), distinct);
    }
}

/// `count --branching`: the per-node canonicalisation multiplier and the move-ordering
/// quality, the two inputs the theoretical floor turns on.
///   - **b̄ = edges (node_key/canon calls) ÷ distinct positions** — every floor estimate
///     is `distinct × b̄ × cost(canon)`, so b̄ is the linear multiplier (and is unmeasured
///     until now).
///   - **win-node cutoff distribution** — at a node that finds a winning move, how many
///     moves were tried first. Mean ≈ 1 ⇒ the static most-blocking order is near-perfect
///     ⇒ the searched set is close to the minimal proof DAG (little for a smarter proof
///     search to recover); a long tail ⇒ ordering waste a DAG-aware df-pn could prune.
fn branching_report(solver: &dyn Solver, distinct: f64) {
    let Some(bs) = solver.branching_stats() else {
        eprintln!("  (branching: stats not captured — needs the sequential --branching solver)");
        return;
    };
    let expanded = solver.nodes().max(1);
    let win = bs.win_nodes.max(1);
    println!("  branching / cutoff (sequential):");
    println!(
        "    expanded nodes (TT misses):           {}",
        commas(expanded)
    );
    println!(
        "    edges keyed (node_key / canon calls): {}",
        commas(bs.edges)
    );
    println!(
        "    b̄ = canons ÷ distinct:                {:.3}",
        bs.edges as f64 / distinct
    );
    println!(
        "    b̄ = canons ÷ expanded node:           {:.3}",
        bs.edges as f64 / expanded as f64
    );
    println!(
        "    win nodes: {}    prove-a-loss nodes: {}",
        commas(bs.win_nodes),
        commas(bs.loss_nodes)
    );
    println!(
        "    mean moves tried before cutoff @ win nodes: {:.3}",
        bs.win_tried_sum as f64 / win as f64
    );
    println!("    win-node cutoff distribution (1 = first available move won):");
    for (k, &c) in bs.win_cut.iter().enumerate() {
        if c == 0 {
            continue;
        }
        let label = if k == 7 {
            "8+".to_string()
        } else {
            (k + 1).to_string()
        };
        println!(
            "      cut@{label:>3}: {:>14}  ({:.2}%)",
            commas(c),
            c as f64 / win as f64 * 100.0
        );
    }
}

/// `count --roots`: per-root working-set sizes (A) and cross-root transposition rate
/// (B) -- the two numbers that decide whether a *staged* cascade (search root-by-root,
/// freeze each root's solved set into the eviction-free BuRR archive, clear the live
/// TT) beats the single shared-TT solve. Each symmetry-distinct first move is searched
/// with a **cold** exact-counting TT (no cross-root cache), so its working set is the
/// full set that root would touch in isolation:
///   (A) the largest cold per-root set is root-0's live-TT requirement under staging
///       (the archive is empty when the first root runs) -- if it overflows a single
///       box's TT, staging cannot stop *its* thrash.
///   (B) Sigma(per-root) / |union| is the cross-root reuse factor: the work a staged
///       solve would re-do per root *without* the archive = exactly what the archive
///       must hold to pay for its query cost. ~1.0 => roots barely overlap (staging
///       cheap, archive optional); >>1.0 => heavy overlap (archive essential).
/// Eviction does not corrupt the counts -- the exact set dedups regardless of TT size.
fn roots_report(q: &Queens, hll_p: u32) {
    use rayon::prelude::*;
    use std::collections::HashMap;
    use std::hash::{Hash, Hasher};

    if q.is_odd() {
        println!(
            "n={n} is odd: first player wins in O(1) (centre + 180° mirror), no search. \
             Use an even n.",
            n = q.n,
        );
        return;
    }
    let firsts = q.distinct_first_moves();
    // Cap the per-root TT at 2^26 (512 MB) -- ample for one root in isolation, and the
    // exact set dedups regardless of TT size, so a smaller table only trades a little
    // eviction-recompute for a far smaller resident footprint per concurrent search.
    let bits = tt_bits(q.n).min(26);
    let nroots = firsts.len();
    // Bound concurrency: each in-flight cold search holds a full exact map (32 B/key),
    // so 28-at-once OOMs the box. A small pool keeps peak RSS to ~`THREADS` maps.
    const THREADS: usize = 6;
    println!(
        "Per-root working set on {n}×{n}: {nroots} symmetry-distinct first moves, \
         cold exact search each (TT 2^{bits}, {THREADS} concurrent)…",
        n = q.n,
    );
    let t = Instant::now();

    // Hash each canonical key to u64 to bound merge memory (collision-negligible:
    // ~tens of M keys in 2^64). The per-root exact map (32 B/key) is dropped as soon as
    // its keys are folded to the 8 B/key vec.
    let fold = |k: &Bits| -> u64 {
        let mut h = std::collections::hash_map::DefaultHasher::new();
        k.hash(&mut h);
        h.finish()
    };
    let pool = rayon::ThreadPoolBuilder::new()
        .num_threads(THREADS)
        .build()
        .expect("rayon pool");
    let sets: Vec<(u32, Vec<u64>)> = pool.install(|| {
        firsts
            .par_iter()
            .map(|&sq| {
                let solver = Tt::new_counting(bits, true, hll_p, true);
                let _ = solver.wins(q, q.place(Bits::empty(), sq));
                let ws = solver.working_set().expect("exact set enabled");
                (sq, ws.iter().map(|(k, _)| fold(k)).collect())
            })
            .collect()
    });

    // (A) per-root sizes, largest first.
    let mut per_root: Vec<(u32, usize)> = sets.iter().map(|(s, v)| (*s, v.len())).collect();
    per_root.sort_by(|a, b| b.1.cmp(&a.1));
    let sum_sizes: usize = per_root.iter().map(|(_, n)| n).sum();

    // (B) multiplicity: how many roots touch each distinct position.
    let mut mult: HashMap<u64, u32> = HashMap::with_capacity(sum_sizes / 2 + 1);
    for (_, keys) in &sets {
        for &k in keys {
            *mult.entry(k).or_insert(0) += 1;
        }
    }
    let union = mult.len().max(1);
    let mut hist = vec![0u64; nroots + 1];
    for &c in mult.values() {
        hist[c as usize] += 1;
    }

    let pct = |x: u64| x as f64 / union as f64 * 100.0;
    println!("\n(A) per-root distinct working set (cold, in isolation):");
    for (sq, n) in per_root.iter().take(8) {
        println!(
            "    sq {:>3} (col {:>2}, row {:>2}):{:>14}  ({:.3} M, {:.1}% of union)",
            sq,
            sq % q.n,
            sq / q.n,
            commas(*n as u64),
            *n as f64 / 1e6,
            pct(*n as u64),
        );
    }
    if nroots > 8 {
        println!("    … {} smaller roots", nroots - 8);
    }
    let max = per_root.first().map(|x| x.1).unwrap_or(0);
    let min = per_root.last().map(|x| x.1).unwrap_or(0);
    println!(
        "    biggest root {} ({:.3} M) = {:.1}% of union · smallest {} ({:.3} M)",
        commas(max as u64),
        max as f64 / 1e6,
        pct(max as u64),
        commas(min as u64),
        min as f64 / 1e6,
    );

    println!("\n(B) cross-root transposition:");
    println!(
        "    union (total distinct):        {:>14}  ({:.3} M)",
        commas(union as u64),
        union as f64 / 1e6,
    );
    println!(
        "    Σ per-root (cold, no sharing): {:>14}  ({:.3} M)",
        commas(sum_sizes as u64),
        sum_sizes as f64 / 1e6,
    );
    println!(
        "    reuse factor Σ/union:          {:>10.2}×",
        sum_sizes as f64 / union as f64
    );
    println!(
        "    touched by exactly 1 root:     {:>14}  ({:.1}% — root-private)",
        commas(hist[1]),
        pct(hist[1]),
    );
    let shared = union as u64 - hist[1];
    println!(
        "    touched by ≥2 roots (shared):  {:>14}  ({:.1}%)",
        commas(shared),
        pct(shared),
    );
    println!(
        "    touched by all {} roots:        {:>14}  ({:.2}%)",
        nroots,
        commas(hist[nroots]),
        pct(hist[nroots]),
    );
    println!("\n  elapsed: {:.1}s", t.elapsed().as_secs_f64());
}

/// `count --psym`: the **#9 free-involution P-certificate fire-rate**. Over the exact
/// working set, count the loss positions that the certificate
/// ([`Queens::is_free_involution_loss`]) proves with no search -- the fraction of
/// prove-a-loss work it could prune -- plus a soundness check that it never fires on a
/// win position. The certificate is checked on the canonical key (it is D4-invariant).
fn psym_report(q: &Queens, solver: &dyn Solver) {
    let Some(ws) = solver.working_set() else {
        eprintln!("  (psym: no exact working set captured — needs the sequential exact solver)");
        return;
    };
    let (mut loss, mut win, mut fire_loss, mut fire_win) = (0u64, 0u64, 0u64, 0u64);
    for &(key, val) in &ws {
        let fires = q.is_free_involution_loss(key);
        if val == 0 {
            loss += 1;
            fire_loss += fires as u64;
        } else {
            win += 1;
            fire_win += fires as u64;
        }
    }
    let total = (loss + win).max(1);
    println!(
        "  #9 free-involution P-certificate over {} D4-distinct positions:",
        commas(loss + win),
    );
    println!(
        "    loss positions:               {:>15}  ({:5.1}% of all)",
        commas(loss),
        loss as f64 / total as f64 * 100.0,
    );
    println!(
        "    fires (prunable loss):        {:>15}  ({:5.1}% of loss, {:5.1}% of all)",
        commas(fire_loss),
        fire_loss as f64 / loss.max(1) as f64 * 100.0,
        fire_loss as f64 / total as f64 * 100.0,
    );
    println!(
        "    fires on a WIN (must be 0):   {:>15}  {}",
        commas(fire_win),
        if fire_win == 0 {
            "✓ sound"
        } else {
            "✗ UNSOUND — certificate fired on a win position!"
        },
    );
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
    run_watched(solver, q.n, show_bar(q.n), None, Phase::Search, || {
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
    let solver = make_solver("incremental", tt_bits(q.n)).unwrap();
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
