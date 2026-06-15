//! The engine ladder, ports of `ai/minimax.py`, `ai/alphabeta.py`,
//! `ai/alphabeta_move_ordering.py`, and `ai/cython_alphabeta.py`.
//!
//! - `Minimax`  -- plain minimax + depth-keyed cache (ground truth).
//! - `AlphaBeta` -- fail-soft alpha-beta + bound-tracking TT (`order=false`),
//!   or mobility move ordering (`order=true`, the `ordered` engine).
//! - `Strong`   -- the native PVS + iterative-deepening + open-addressing TT
//!   engine (the Rust equivalent of `cython-strong`); falls back to the ordered
//!   alpha-beta for `depth=None` (full endgame solve).
//!
//! All four compute identical values; pruning/ordering only change node counts.

use std::collections::HashMap;
use std::hash::{BuildHasherDefault, Hasher};

use rayon::prelude::*;

use crate::core::{Board, Move, Moves, Score, BLACK, MAX_SCORE, MIN_SCORE, PASS};
use crate::eval::{heuristic, utility};
use crate::game::{best_by_side, child_depth, iter_moves, Depth, Engine, MoveScores};
use crate::search::{search_strong, search_strong_move, solve};
use crate::tt::TranspositionTable;

// A small FxHash-style hasher: the cache keys are already well-mixed integers,
// so a multiply-rotate beats SipHash for the reference engines' hot caches.
#[derive(Default)]
pub struct FxHasher {
    hash: u64,
}

impl FxHasher {
    #[inline]
    fn add(&mut self, i: u64) {
        self.hash = (self.hash.rotate_left(5) ^ i).wrapping_mul(0x517c_c1b7_2722_0a95);
    }
}

impl Hasher for FxHasher {
    #[inline]
    fn finish(&self) -> u64 {
        self.hash
    }
    #[inline]
    fn write(&mut self, bytes: &[u8]) {
        for &b in bytes {
            self.add(b as u64);
        }
    }
    #[inline]
    fn write_u8(&mut self, i: u8) {
        self.add(i as u64);
    }
    #[inline]
    fn write_u32(&mut self, i: u32) {
        self.add(i as u64);
    }
    #[inline]
    fn write_i32(&mut self, i: i32) {
        self.add(i as u64);
    }
    #[inline]
    fn write_u64(&mut self, i: u64) {
        self.add(i);
    }
}

type FxBuild = BuildHasherDefault<FxHasher>;
type Map<K, V> = HashMap<K, V, FxBuild>;
type Key = (u64, u64, u8, Depth);

const ORDER_MIN_DEPTH: i32 = 4;

// Bound flags for the alpha-beta TT.
const F_EXACT: u8 = 0;
const F_LOWER: u8 = 1;
const F_UPPER: u8 = 2;

// --------------------------------------------------------------------------- //
// Minimax
// --------------------------------------------------------------------------- //

pub struct Minimax {
    cache: Map<Key, Score>,
}

impl Default for Minimax {
    fn default() -> Self {
        Self::new()
    }
}

impl Minimax {
    pub fn new() -> Self {
        Minimax {
            cache: Map::default(),
        }
    }

    fn value_inner(&mut self, board: &Board, depth: Depth) -> Score {
        let key = (board.black, board.white, board.to_move, depth);
        if let Some(&v) = self.cache.get(&key) {
            return v;
        }
        let score = if matches!(depth, Some(d) if d <= 0) {
            heuristic(board, BLACK) // horizon
        } else if board.is_terminal() {
            utility(board, BLACK) // exact terminal
        } else {
            let child = child_depth(depth);
            let moves = board.actions();
            if board.to_move == BLACK {
                let mut best = MIN_SCORE;
                if moves == 0 {
                    best = best.max(self.value_inner(&board.make_move_unchecked(PASS), child));
                } else {
                    let mut mm = moves;
                    while mm != 0 {
                        let m = mm & mm.wrapping_neg();
                        mm ^= m;
                        let v = self.value_inner(&board.make_move_unchecked(m), child);
                        if v > best {
                            best = v;
                        }
                    }
                }
                best
            } else {
                let mut best = MAX_SCORE;
                if moves == 0 {
                    best = best.min(self.value_inner(&board.make_move_unchecked(PASS), child));
                } else {
                    let mut mm = moves;
                    while mm != 0 {
                        let m = mm & mm.wrapping_neg();
                        mm ^= m;
                        let v = self.value_inner(&board.make_move_unchecked(m), child);
                        if v < best {
                            best = v;
                        }
                    }
                }
                best
            }
        };
        self.cache.insert(key, score);
        score
    }
}

impl Engine for Minimax {
    fn name(&self) -> &'static str {
        "minimax"
    }
    fn default_depth(&self) -> Depth {
        Some(4)
    }
    fn value(&mut self, board: &Board, depth: Depth) -> Score {
        self.value_inner(board, depth)
    }
    fn reset(&mut self) {
        self.cache.clear();
    }
}

// --------------------------------------------------------------------------- //
// AlphaBeta (plain / mobility-ordered)
// --------------------------------------------------------------------------- //

pub struct AlphaBeta {
    cache: Map<Key, (Score, u8)>,
    order: bool,
    name: &'static str,
}

impl AlphaBeta {
    pub fn plain() -> Self {
        AlphaBeta {
            cache: Map::default(),
            order: false,
            name: "alphabeta",
        }
    }
    pub fn ordered() -> Self {
        AlphaBeta {
            cache: Map::default(),
            order: true,
            name: "alphabeta+ordering",
        }
    }

    fn order_moves(&self, board: &Board, moves: Moves, depth: Depth) -> Vec<Move> {
        if !self.order || matches!(depth, Some(d) if d < ORDER_MIN_DEPTH) {
            return iter_moves(moves);
        }
        let mut mv = iter_moves(moves);
        if mv.len() < 2 {
            return mv;
        }
        // Fewest opponent replies first -- restrict the opponent. Stable sort
        // keeps ties in LSB order (matches Python's `sorted`).
        mv.sort_by_key(|&m| board.make_move_unchecked(m).actions().count_ones());
        mv
    }

    pub(crate) fn value_window(
        &mut self,
        board: &Board,
        depth: Depth,
        mut alpha: Score,
        mut beta: Score,
    ) -> Score {
        let key = (board.black, board.white, board.to_move, depth);
        let a0 = alpha;
        let b0 = beta;

        if let Some(&(value, flag)) = self.cache.get(&key) {
            if flag == F_EXACT {
                return value;
            } else if flag == F_LOWER {
                if value > alpha {
                    alpha = value;
                }
            } else if value < beta {
                beta = value;
            }
            if alpha >= beta {
                return value;
            }
        }

        if matches!(depth, Some(d) if d <= 0) {
            let value = heuristic(board, BLACK);
            self.cache.insert(key, (value, F_EXACT));
            return value;
        }

        let moves = board.actions();
        let candidates = if moves == 0 {
            if board.is_terminal() {
                let value = utility(board, BLACK);
                self.cache.insert(key, (value, F_EXACT));
                return value;
            }
            vec![PASS]
        } else {
            self.order_moves(board, moves, depth)
        };

        let child = child_depth(depth);
        let value;
        let flag;
        if board.to_move == BLACK {
            let mut best = MIN_SCORE;
            for m in candidates {
                let v = self.value_window(&board.make_move_unchecked(m), child, alpha, beta);
                if v > best {
                    best = v;
                    if v > alpha {
                        alpha = v;
                        if alpha >= beta {
                            break;
                        }
                    }
                }
            }
            value = best;
            flag = if value <= a0 {
                F_UPPER
            } else if value >= beta {
                F_LOWER
            } else {
                F_EXACT
            };
        } else {
            let mut best = MAX_SCORE;
            for m in candidates {
                let v = self.value_window(&board.make_move_unchecked(m), child, alpha, beta);
                if v < best {
                    best = v;
                    if v < beta {
                        beta = v;
                        if alpha >= beta {
                            break;
                        }
                    }
                }
            }
            value = best;
            flag = if value >= b0 {
                F_LOWER
            } else if value <= alpha {
                F_UPPER
            } else {
                F_EXACT
            };
        }

        self.cache.insert(key, (value, flag));
        value
    }
}

impl Engine for AlphaBeta {
    fn name(&self) -> &'static str {
        self.name
    }
    fn default_depth(&self) -> Depth {
        Some(6)
    }
    fn value(&mut self, board: &Board, depth: Depth) -> Score {
        self.value_window(board, depth, MIN_SCORE, MAX_SCORE)
    }
    fn reset(&mut self) {
        self.cache.clear();
    }
}

// --------------------------------------------------------------------------- //
// Strong (native PVS + iterative deepening + open-addressing TT)
// --------------------------------------------------------------------------- //

/// Default root-parallel fan-out width. Each parallel worker owns a *private*
/// transposition table, so there is no shared mutable state and no lock; the
/// only cross-thread cost is shared-L3 pressure, which we bound by keeping the
/// per-worker tables small (`POOL_BITS`). Start at 8; `OTHELLO_THREADS` raises it.
const DEFAULT_THREADS: usize = 8;

/// Sequential table size (`value`/`best_move`): 2^16 ~= 1.5 MB, stays in one
/// core's L2/L3.
const SEQ_BITS: u32 = 17;
/// Per-worker parallel table size. Smaller so 8 of them coexist in shared L3
/// without churn (8 * 2^13 entries ~= 1.5 MB total, vs 12 MB at 2^16).
const POOL_BITS: u32 = 13;

pub struct Strong {
    tt: TranspositionTable, // value()/best_move/solve: one sequential search
    pool: Vec<TranspositionTable>, // scores(): one preallocated TT per worker
    order: bool,
    threads: usize,
}

impl Default for Strong {
    fn default() -> Self {
        Self::new()
    }
}

impl Strong {
    pub fn new() -> Self {
        let threads = std::env::var("OTHELLO_THREADS")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(DEFAULT_THREADS);
        Self::with_threads(threads)
    }

    pub fn with_threads(threads: usize) -> Self {
        let threads = threads.clamp(1, rayon::current_num_threads().max(1));
        // Preallocate the whole arena up front so no table is grown/zeroed mid
        // search -- allocation never shows up on the hot path.
        let pool = (0..threads)
            .map(|_| TranspositionTable::new(POOL_BITS))
            .collect();
        Strong {
            tt: TranspositionTable::new(SEQ_BITS),
            pool,
            order: true,
            threads,
        }
    }
}

impl Engine for Strong {
    fn name(&self) -> &'static str {
        "strong"
    }
    fn default_depth(&self) -> Depth {
        Some(9)
    }
    fn value(&mut self, board: &Board, depth: Depth) -> Score {
        match depth {
            None => solve(
                board.black,
                board.white,
                board.to_move as i32,
                &mut self.tt,
                self.order,
            ),
            Some(d) => search_strong(
                board.black,
                board.white,
                board.to_move as i32,
                d,
                &mut self.tt,
                self.order,
            ),
        }
    }
    /// Fast play path: a single rooted PVS search (sibling pruning + one
    /// cache-resident TT). LSB-order root + strict `>` => identical move and
    /// tie-break to `best_by_side` over the exact `scores`.
    fn best_move(&mut self, board: &Board, depth: Depth) -> Result<Move, String> {
        if board.is_terminal() {
            return Err(format!("{}: no move from terminal state", self.name()));
        }
        match depth {
            Some(d) => Ok(search_strong_move(
                board.black,
                board.white,
                board.to_move as i32,
                d,
                &mut self.tt,
                self.order,
            )
            .0),
            None => {
                let scored = self.scores(board, None)?;
                Ok(best_by_side(board, &scored))
            }
        }
    }
    /// Root-parallel *exact* scores: each legal move's child is an independent
    /// full-window search (NEG..POS), so values are exact and order-independent
    /// -- identical to the sequential engine, fanned out across up to `threads`
    /// workers (each with its own preallocated, cache-small table).
    fn scores(&mut self, board: &Board, depth: Depth) -> Result<MoveScores, String> {
        if board.is_terminal() {
            return Err(format!("{}: no scores for a terminal state", self.name()));
        }
        let moves = board.actions();
        let children: Vec<(Move, Board)> = if moves == 0 {
            vec![(PASS, board.make_move_unchecked(PASS))] // forced pass
        } else {
            iter_moves(moves)
                .into_iter()
                .map(|m| (m, board.make_move_unchecked(m)))
                .collect()
        };

        let cd = match child_depth(depth) {
            None => {
                // full solve: exact native solver, sharing the big sequential TT
                // across children (cross-child transposition reuse beats fan-out).
                let mut out = MoveScores::with_capacity(children.len());
                for (m, c) in &children {
                    out.push((
                        *m,
                        solve(c.black, c.white, c.to_move as i32, &mut self.tt, self.order),
                    ));
                }
                return Ok(out);
            }
            Some(cd) => cd,
        };

        let want = children.len().min(self.threads).max(1);
        let order = self.order;
        let chunk = children.len().div_ceil(want);
        let partials: Vec<MoveScores> = self.pool[..want]
            .par_iter_mut()
            .zip(children.par_chunks(chunk))
            .map(|(tt, group)| {
                let mut v = MoveScores::with_capacity(group.len());
                for &(m, c) in group {
                    v.push((
                        m,
                        search_strong(c.black, c.white, c.to_move as i32, cd, tt, order),
                    ));
                }
                v
            })
            .collect();
        Ok(partials.concat())
    }
    fn reset(&mut self) {
        self.tt.clear();
        for tt in self.pool.iter_mut() {
            tt.clear();
        }
    }
}

// --------------------------------------------------------------------------- //
// Registry (for the CLI --engine)
// --------------------------------------------------------------------------- //

/// CLI engine names, sorted (matches Python's `sorted(ENGINES)`).
pub const ENGINE_NAMES: [&str; 4] = ["alphabeta", "minimax", "ordered", "strong"];

pub fn make_engine(name: &str) -> Option<Box<dyn Engine>> {
    match name {
        "minimax" => Some(Box::new(Minimax::new())),
        "alphabeta" => Some(Box::new(AlphaBeta::plain())),
        "ordered" => Some(Box::new(AlphaBeta::ordered())),
        "strong" => Some(Box::new(Strong::new())),
        _ => None,
    }
}
