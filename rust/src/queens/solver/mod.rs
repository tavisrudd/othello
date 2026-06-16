//! The solver lineage: the `Solver` trait, the per-node key knobs shared by
//! the table-backed solvers, and the `make_solver` factory.

use crate::queens::*;

mod incremental;
mod memo;
mod naive;
mod nimber;
mod parallel;
mod pn;

pub use incremental::Incremental;
pub use memo::{BranchingStats, Tt};
pub use naive::Naive;
pub use nimber::Nimber;
pub use parallel::Parallel;
pub use pn::Pn;

// --------------------------------------------------------------------------- //
// Solver lineage
// --------------------------------------------------------------------------- //

/// A win/loss solver for the Non-Attacking Queens game. Implementors compute
/// `wins` (the value for the player to move); the rest is provided.
pub trait Solver: Sync {
    /// The solver's name (for the CLI / reporting).
    fn name(&self) -> &'static str;

    /// Does the player to move win from `blocked` under perfect play?
    fn wins(&self, q: &Queens, blocked: Bits) -> bool;

    /// Does the first player win the empty board? The default is a plain
    /// `wins(empty)`; [`Parallel`] overrides it with the odd-board O(1) theorem
    /// and root parallelism.
    fn first_player_wins(&self, q: &Queens) -> bool {
        self.wins(q, Bits::empty())
    }

    /// Nodes searched (TT misses), for reporting. `0` if not tracked.
    fn nodes(&self) -> u64 {
        0
    }

    /// Per-node branching / cutoff tally, if built with [`Tt::with_branching`]
    /// (`count --branching`). `None` for an ordinary solve.
    fn branching_stats(&self) -> Option<BranchingStats> {
        None
    }

    /// Transposition-table byte footprint (the memory cap). `0` if none.
    fn cap_bytes(&self) -> u64 {
        0
    }

    /// Distinct-position measurement, if this solver was built with counting
    /// enabled (see [`Tt::new_counting`]). `None` for an ordinary solve.
    fn report(&self) -> Option<CountReport> {
        None
    }

    /// The exact working set (canonical key, win/loss value), for cold post-search
    /// analysis (`count --iso`). `None` unless an exact distinct set was kept.
    fn working_set(&self) -> Option<Vec<(Bits, u8)>> {
        None
    }

    /// Root-move progress as `(resolved, total)` for a live indicator, or `None`
    /// if the solver does not track it. Only meaningful mid-`first_player_wins`.
    fn root_progress(&self) -> Option<(u64, u64)> {
        None
    }

    /// Extra, approach-specific stats for the solve summary -- e.g. table fill
    /// for the memo solvers, the Sprague-Grundy value for `nimber`, the root
    /// proof/disproof numbers for `pn`. Empty by default (e.g. tableless `naive`).
    fn stats(&self) -> String {
        String::new()
    }

    /// The transposition table, if this solver has one -- so a checkpoint can dump
    /// it mid-search (`QueensTt::dump_image`). `None` for tableless solvers (`naive`).
    fn tt(&self) -> Option<&QueensTt> {
        None
    }
}

/// Which canonical key the search uses per node. `D4` is the production key
/// (`pos_key`, the dihedral-canonical `available` mask). `GraphIr`/`GraphCanon` are
/// the **graph-isomorphism** keys (session-6 lever #7) -- they merge ~3.4× more
/// positions (every isomorphic available-graph), but cost ~µs/node vs `pos_key`'s
/// ~ns, so this is a measurement/spike toggle (`QUEENS_KEY=ir|canon`), not yet the
/// default. Only meaningful for the canonical solvers (`canon == true`).
#[derive(Clone, Copy, PartialEq)]
pub(crate) enum KeyMode {
    D4,
    GraphIr,
    GraphCanon,
    GraphComp,
    GraphFast,
}

/// Resolve the key mode once at construction (never per node -- an env read in the
/// hot loop serialises the rayon workers). `QUEENS_KEY=ir|canon|comp` opts into a
/// graph-isomorphism key; anything else keeps the production D4 key.
fn key_mode() -> KeyMode {
    match std::env::var("QUEENS_KEY").as_deref() {
        Ok("ir") => KeyMode::GraphIr,
        Ok("canon") => KeyMode::GraphCanon,
        Ok("comp") => KeyMode::GraphComp,
        Ok("fast") => KeyMode::GraphFast,
        _ => KeyMode::D4,
    }
}

/// Pack a 64-bit graph-isomorphism key into the table's 256-bit key slot, tagged with
/// a sentinel bit (255) that no real `available` mask sets for n ≤ 15 -- so graph keys
/// and D4 masks occupy disjoint key spaces and never collide when **selective** keying
/// mixes them. (n=16 uses all 256 bits; a wider namespace would be needed there.)
#[inline]
fn graph_bits(h: u64) -> Bits {
    Bits([h, 0, 0, 1u64 << 63])
}

/// Resolve the selective-keying threshold once: with `QUEENS_KEY_MAX=k`, only positions
/// whose available-graph has ≤ k vertices use the (costly) graph key; larger graphs fall
/// back to the cheap D4 key. Safe because transpositions are strictly intra-ply, and the
/// choice is a pure function of the position (its available popcount). Default: no limit.
fn key_max_avail() -> u32 {
    std::env::var("QUEENS_KEY_MAX")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(u32::MAX)
}

/// Plies from the root that [`Parallel`] fans across rayon (resolved once at startup,
/// never per node). `QUEENS_PAR_DEPTH` overrides; default `3`. Below this depth the
/// search recurses sequentially (full α-β cutoff). Higher exposes more parallelism --
/// keeping the dominant root-0 ("elder brother") subtree off a single core at n=16,
/// where that subtree is the entire feasible runtime -- at the cost of some speculation
/// at the OR (prove-a-win) levels; the AND (prove-a-loss) levels, the bulk of a
/// second-player win, parallelise with no speculation.
fn par_depth() -> u32 {
    std::env::var("QUEENS_PAR_DEPTH")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(3)
        .max(1)
}

/// `QUEENS_PAR_MIN_AVAIL` override (resolved once at construction). `None` ⇒ auto by
/// board size (see [`min_avail_for`]). The size split keeps a *big* deep prove-a-loss
/// node fanning so an idle core can steal a straggler -- the #20 tail fix; available
/// count is a cheap proxy for subtree size (it shrinks with depth).
fn par_min_avail_override() -> Option<u32> {
    std::env::var("QUEENS_PAR_MIN_AVAIL")
        .ok()
        .and_then(|s| s.parse().ok())
}

/// The size-split threshold for board `n`: a node below [`par_depth`] keeps splitting
/// while its available count stays above this, else it goes sequential. The auto
/// default is **on only for n ≥ 15** (`96`) and **off below** (`u32::MAX`): the fixed
/// `par_depth` schedule is already well-tuned on the short small-board searches (where
/// extra splitting is pure overhead -- it regresses n=14 ~3%), and only the n=16 tail
/// -- few roots left, all parallelism intra-root, sequential stragglers draining cores
/// -- needs the deeper split. Rayon pays the split cost only on an actual steal, so at
/// n=16 it is ~free while saturated and pays off precisely at the tail. `over` (the env
/// override) wins when set; set it huge (≥ n²) to force the pure fixed-`par_depth` form.
fn min_avail_for(over: Option<u32>, n: u32) -> u32 {
    over.unwrap_or(if n >= 15 { 96 } else { u32::MAX })
}

/// CLI solver names, simplest → most sophisticated (`nimber` computes the full
/// Sprague-Grundy value; `pn` is df-pn proof-number search).
pub const SOLVER_NAMES: [&str; 7] = [
    "naive",
    "memo",
    "symmetry",
    "parallel",
    "incremental",
    "nimber",
    "pn",
];

/// Build a solver by name with a `2^bits`-slot table (ignored by `naive`).
pub fn make_solver(name: &str, bits: u32) -> Option<Box<dyn Solver>> {
    match name {
        "naive" => Some(Box::new(Naive::new())),
        "memo" => Some(Box::new(Tt::new(bits, false))),
        "symmetry" => Some(Box::new(Tt::new(bits, true))),
        "parallel" => Some(Box::new(Parallel::new(bits))),
        "incremental" => Some(Box::new(Incremental::new(bits))),
        "nimber" => Some(Box::new(Nimber::new(bits))),
        "pn" => Some(Box::new(Pn::new(bits))),
        _ => None,
    }
}
