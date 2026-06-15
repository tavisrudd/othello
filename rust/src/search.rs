//! Native black-centred alpha-beta over packed bitboards, port of `_search.pyx`.
//!
//! `search` is fail-soft alpha-beta with a bound-tracking TT (stores
//! black-centred values). `search_strong` is iterative-deepening negamax PVS
//! with a hash-move hint table (stores side-to-move values). Both produce the
//! exact same value as the Python engines -- ordering/pruning only change the
//! node count. No `Board` objects: native recursion, inlined make-move.

use crate::core::{flips_for_move, legal_moves};
use crate::eval::heuristic_black;
use crate::tt::TranspositionTable;

const NEG: i32 = -1_000_000_000;
const POS: i32 = 1_000_000_000;
const EXACT: i32 = 0;
const LOWER: i32 = 1;
const UPPER: i32 = 2;
const ORDER_MIN_DEPTH: i32 = 4;
/// Initial aspiration half-window (heuristic units). Iterative-deepening values
/// move little between plies, so a tight window prunes hard; misses widen it.
const ASP_DELTA: i32 = 16;
/// Mobility-order the exact endgame solver only with at least this many empties;
/// below it the subtree is tiny and the sort doesn't pay.
const ENDGAME_ORDER_MIN: i32 = 8;

/// Fail-soft alpha-beta, black-centred. `order` enables mobility move ordering.
#[allow(clippy::too_many_arguments)] // mirrors the packed-bitboard Cython signature
fn ab(
    black: u64,
    white: u64,
    to_move: i32,
    depth: i32,
    mut alpha: i32,
    mut beta: i32,
    tt: &mut TranspositionTable,
    order: bool,
) -> i32 {
    let idx = tt.index(black, white, to_move, depth);
    let a0 = alpha;
    let b0 = beta;

    let e = tt.get(idx);
    if e.used != 0
        && e.black == black
        && e.white == white
        && e.to_move as i32 == to_move
        && e.depth as i32 == depth
    {
        let value = e.value;
        let flag = e.flag as i32;
        if flag == EXACT {
            return value;
        } else if flag == LOWER {
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

    if depth <= 0 {
        let value = heuristic_black(black, white); // horizon heuristic
        tt.store(idx, black, white, to_move, depth, value, EXACT);
        return value;
    }

    let (player, opp) = if to_move == 0 {
        (black, white)
    } else {
        (white, black)
    };
    let mut moves = legal_moves(player, opp);

    if moves == 0 {
        if legal_moves(opp, player) == 0 {
            let value = black.count_ones() as i32 - white.count_ones() as i32; // terminal
            tt.store(idx, black, white, to_move, depth, value, EXACT);
            return value;
        }
        let value = ab(black, white, to_move ^ 1, depth - 1, alpha, beta, tt, order); // pass
        let flag = if to_move == 0 {
            if value <= a0 {
                UPPER
            } else if value >= beta {
                LOWER
            } else {
                EXACT
            }
        } else if value >= b0 {
            LOWER
        } else if value <= alpha {
            UPPER
        } else {
            EXACT
        };
        tt.store(idx, black, white, to_move, depth, value, flag);
        return value;
    }

    let child = depth - 1;
    let mut cb = [0u64; 64];
    let mut cw = [0u64; 64];
    let mut ck = [0i32; 64];
    let mut n = 0usize;
    let ordering = order && depth >= ORDER_MIN_DEPTH;
    while moves != 0 {
        let m = moves & moves.wrapping_neg();
        moves ^= m;
        let fl = flips_for_move(m, player, opp);
        let (nb, nw) = if to_move == 0 {
            (black | m | fl, white & !fl)
        } else {
            (black & !fl, white | m | fl)
        };
        cb[n] = nb;
        cw[n] = nw;
        if ordering {
            ck[n] = if to_move == 0 {
                legal_moves(nw, nb).count_ones() as i32
            } else {
                legal_moves(nb, nw).count_ones() as i32
            };
        }
        n += 1;
    }

    if ordering && n > 1 {
        // insertion sort by ck ascending (fewest opponent replies first)
        for i in 1..n {
            let (ckey, bb, ww) = (ck[i], cb[i], cw[i]);
            let mut j = i;
            while j > 0 && ck[j - 1] > ckey {
                ck[j] = ck[j - 1];
                cb[j] = cb[j - 1];
                cw[j] = cw[j - 1];
                j -= 1;
            }
            ck[j] = ckey;
            cb[j] = bb;
            cw[j] = ww;
        }
    }

    let value;
    let flag;
    if to_move == 0 {
        let mut best = NEG; // maximiser (black)
        for i in 0..n {
            let v = ab(cb[i], cw[i], 1, child, alpha, beta, tt, order);
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
            UPPER
        } else if value >= beta {
            LOWER
        } else {
            EXACT
        };
    } else {
        let mut best = POS; // minimiser (white)
        for i in 0..n {
            let v = ab(cb[i], cw[i], 0, child, alpha, beta, tt, order);
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
            LOWER
        } else if value <= alpha {
            UPPER
        } else {
            EXACT
        };
    }

    tt.store(idx, black, white, to_move, depth, value, flag);
    value
}

/// Black-centred minimax value, `depth` plies; `order=true` enables ordering.
pub fn search(
    black: u64,
    white: u64,
    to_move: i32,
    depth: i32,
    tt: &mut TranspositionTable,
    order: bool,
) -> i32 {
    ab(black, white, to_move, depth, NEG, POS, tt, order)
}

// --------------------------------------------------------------------------- //
// "Strong" search: negamax PVS with a hash-move hint table, iterative deepening.
// Pure search-order tricks, so the value is identical to plain alpha-beta.
// --------------------------------------------------------------------------- //

/// Negamax PVS; returns the value from `to_move`'s perspective.
#[allow(clippy::too_many_arguments)] // mirrors the packed-bitboard Cython signature
fn pvs(
    black: u64,
    white: u64,
    to_move: i32,
    depth: i32,
    mut alpha: i32,
    mut beta: i32,
    tt: &mut TranspositionTable,
    order: bool,
) -> i32 {
    let idx = tt.index(black, white, to_move, depth);
    let a0 = alpha;

    let e = tt.get(idx);
    if e.used != 0
        && e.black == black
        && e.white == white
        && e.to_move as i32 == to_move
        && e.depth as i32 == depth
    {
        let value = e.value;
        let flag = e.flag as i32;
        if flag == EXACT {
            return value;
        } else if flag == LOWER {
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

    if depth <= 0 {
        let hb = heuristic_black(black, white); // horizon heuristic (negamax)
        let value = if to_move == 0 { hb } else { -hb };
        tt.store(idx, black, white, to_move, depth, value, EXACT);
        return value;
    }

    let (player, opp) = if to_move == 0 {
        (black, white)
    } else {
        (white, black)
    };
    let mut moves = legal_moves(player, opp);

    if moves == 0 {
        if legal_moves(opp, player) == 0 {
            let diff = black.count_ones() as i32 - white.count_ones() as i32; // terminal
            let value = if to_move == 0 { diff } else { -diff };
            tt.store(idx, black, white, to_move, depth, value, EXACT);
            return value;
        }
        let value = -pvs(
            black,
            white,
            to_move ^ 1,
            depth - 1,
            -beta,
            -alpha,
            tt,
            order,
        ); // pass
        let flag = if value <= a0 {
            UPPER
        } else if value >= beta {
            LOWER
        } else {
            EXACT
        };
        tt.store(idx, black, white, to_move, depth, value, flag);
        return value;
    }

    let child = depth - 1;
    let ordering = order && depth >= ORDER_MIN_DEPTH;
    let mut value = NEG;
    let mut best = 0u64;

    if ordering {
        // Deep node: materialise all children, mobility-sort, hash-move first.
        let mut cb = [0u64; 64];
        let mut cw = [0u64; 64];
        let mut cm = [0u64; 64];
        let mut ck = [0i32; 64];
        let mut n = 0usize;
        while moves != 0 {
            let m = moves & moves.wrapping_neg();
            moves ^= m;
            let fl = flips_for_move(m, player, opp);
            let (nb, nw) = if to_move == 0 {
                (black | m | fl, white & !fl)
            } else {
                (black & !fl, white | m | fl)
            };
            cb[n] = nb;
            cw[n] = nw;
            cm[n] = m;
            ck[n] = if to_move == 0 {
                legal_moves(nw, nb).count_ones() as i32
            } else {
                legal_moves(nb, nw).count_ones() as i32
            };
            n += 1;
        }
        if n > 1 {
            for i in 1..n {
                let (ckey, bb, ww, mm) = (ck[i], cb[i], cw[i], cm[i]);
                let mut j = i;
                while j > 0 && ck[j - 1] > ckey {
                    ck[j] = ck[j - 1];
                    cb[j] = cb[j - 1];
                    cw[j] = cw[j - 1];
                    cm[j] = cm[j - 1];
                    j -= 1;
                }
                ck[j] = ckey;
                cb[j] = bb;
                cw[j] = ww;
                cm[j] = mm;
            }
        }
        let hint = tt.hint_get(tt.pos_index(black, white, to_move));
        if hint != 0 {
            for i in 0..n {
                if cm[i] == hint {
                    if i != 0 {
                        let (nb, nw, mm) = (cb[i], cw[i], cm[i]);
                        let mut j = i;
                        while j > 0 {
                            cb[j] = cb[j - 1];
                            cw[j] = cw[j - 1];
                            cm[j] = cm[j - 1];
                            j -= 1;
                        }
                        cb[0] = nb;
                        cw[0] = nw;
                        cm[0] = mm;
                    }
                    break;
                }
            }
        }
        best = cm[0];
        for i in 0..n {
            let v = if i == 0 {
                -pvs(cb[i], cw[i], to_move ^ 1, child, -beta, -alpha, tt, order)
            } else {
                let scout = -pvs(
                    cb[i],
                    cw[i],
                    to_move ^ 1,
                    child,
                    -alpha - 1,
                    -alpha,
                    tt,
                    order,
                );
                if alpha < scout && scout < beta {
                    -pvs(cb[i], cw[i], to_move ^ 1, child, -beta, -alpha, tt, order)
                // re-search
                } else {
                    scout
                }
            };
            if v > value {
                value = v;
                best = cm[i];
            }
            if v > alpha {
                alpha = v;
            }
            if alpha >= beta {
                break;
            }
        }
    } else {
        // Shallow node: no mobility ordering. Search the hash move first, then
        // the rest LSB-first, computing flips lazily so cut-off moves cost
        // nothing. Identical move order to the array path => same value/nodes.
        let hint = tt.hint_get(tt.pos_index(black, white, to_move));
        let hint_legal = hint != 0 && moves & hint != 0;
        let mut remaining = if hint_legal { moves & !hint } else { moves };
        let mut first = true;
        loop {
            let m = if first && hint_legal {
                hint
            } else if remaining != 0 {
                let lsb = remaining & remaining.wrapping_neg();
                remaining ^= lsb;
                lsb
            } else {
                break;
            };
            let fl = flips_for_move(m, player, opp);
            let (nb, nw) = if to_move == 0 {
                (black | m | fl, white & !fl)
            } else {
                (black & !fl, white | m | fl)
            };
            let v = if first {
                -pvs(nb, nw, to_move ^ 1, child, -beta, -alpha, tt, order)
            } else {
                let scout = -pvs(nb, nw, to_move ^ 1, child, -alpha - 1, -alpha, tt, order);
                if alpha < scout && scout < beta {
                    -pvs(nb, nw, to_move ^ 1, child, -beta, -alpha, tt, order) // re-search
                } else {
                    scout
                }
            };
            if first || v > value {
                value = v;
                best = m;
            }
            if v > alpha {
                alpha = v;
            }
            first = false;
            if alpha >= beta {
                break;
            }
        }
    }

    let flag = if value <= a0 {
        UPPER
    } else if value >= beta {
        LOWER
    } else {
        EXACT
    };
    tt.store(idx, black, white, to_move, depth, value, flag);
    let pidx = tt.pos_index(black, white, to_move);
    tt.hint_set(pidx, best);
    value
}

/// Iterative-deepening PVS; returns the black-centred value (== `search`).
///
/// NB: stores negamax (side-to-move) values in `tt`, whereas `search` stores
/// black-centred ones -- do not share a `TranspositionTable` between them.
pub fn search_strong(
    black: u64,
    white: u64,
    to_move: i32,
    depth: i32,
    tt: &mut TranspositionTable,
    order: bool,
) -> i32 {
    let mut v;
    if depth <= 0 {
        v = pvs(black, white, to_move, depth, NEG, POS, tt, order);
    } else {
        v = pvs(black, white, to_move, 1, NEG, POS, tt, order); // first iter: full window
        for d in 2..=depth {
            // Aspirate around the previous iteration's value; widen on a miss.
            let mut delta = ASP_DELTA;
            let mut alpha = (v - delta).max(NEG);
            let mut beta = (v + delta).min(POS);
            loop {
                let got = pvs(black, white, to_move, d, alpha, beta, tt, order);
                if got <= alpha && alpha > NEG {
                    alpha = (got - delta).max(NEG);
                    delta = delta.saturating_mul(2);
                } else if got >= beta && beta < POS {
                    beta = (got + delta).min(POS);
                    delta = delta.saturating_mul(2);
                } else {
                    v = got;
                    break;
                }
            }
        }
    }
    if to_move == 0 {
        v
    } else {
        -v
    }
}

/// Root PVS: returns `(best_move_bit, side-to-move value)` for one fixed depth.
///
/// Root moves are tried in LSB order (no reordering) with strict `>` updates, so
/// the chosen move is the *first* one achieving the optimum -- byte-for-byte the
/// same tie-break as `game::best_by_side` over exact `scores`. Children still use
/// the full mobility + hash-move ordering, so deep pruning is unaffected.
#[allow(clippy::too_many_arguments)] // root window for aspiration + tie-break
fn pvs_root(
    black: u64,
    white: u64,
    to_move: i32,
    depth: i32,
    mut alpha: i32,
    beta: i32,
    tt: &mut TranspositionTable,
    order: bool,
) -> (u64, i32) {
    let a0 = alpha;
    let (player, opp) = if to_move == 0 {
        (black, white)
    } else {
        (white, black)
    };
    let moves = legal_moves(player, opp);
    let child = depth - 1;

    if moves == 0 {
        // forced pass (caller guarantees non-terminal)
        let v = -pvs(black, white, to_move ^ 1, child, -beta, -alpha, tt, order);
        return (0, v);
    }

    let mut value = NEG;
    let mut best = 0u64;
    let mut mm = moves;
    let mut first = true;
    while mm != 0 {
        let m = mm & mm.wrapping_neg();
        mm ^= m;
        let fl = flips_for_move(m, player, opp);
        let (nb, nw) = if to_move == 0 {
            (black | m | fl, white & !fl)
        } else {
            (black & !fl, white | m | fl)
        };
        let v = if first {
            -pvs(nb, nw, to_move ^ 1, child, -beta, -alpha, tt, order)
        } else {
            let scout = -pvs(nb, nw, to_move ^ 1, child, -alpha - 1, -alpha, tt, order);
            if alpha < scout && scout < beta {
                -pvs(nb, nw, to_move ^ 1, child, -beta, -alpha, tt, order)
            } else {
                scout
            }
        };
        first = false;
        if v > value {
            value = v;
            best = m;
        }
        if v > alpha {
            alpha = v;
        }
        // Fail-high cutoff only fires on a *failing* aspiration pass (which the
        // caller discards). On a successful pass value < beta, so we search every
        // root move and `best` is the first-LSB maximiser -- the exact tie-break.
        if alpha >= beta {
            break;
        }
    }

    let flag = if value <= a0 {
        UPPER
    } else if value >= beta {
        LOWER
    } else {
        EXACT
    };
    let idx = tt.index(black, white, to_move, depth);
    tt.store(idx, black, white, to_move, depth, value, flag);
    tt.hint_set(tt.pos_index(black, white, to_move), best);
    (best, value)
}

/// Iterative-deepening PVS that returns the best move (and its black-centred
/// value) from a *single* rooted search -- the fast path for actually playing.
pub fn search_strong_move(
    black: u64,
    white: u64,
    to_move: i32,
    depth: i32,
    tt: &mut TranspositionTable,
    order: bool,
) -> (u64, i32) {
    let (mut best, mut v);
    if depth <= 0 {
        let r = pvs_root(black, white, to_move, depth, NEG, POS, tt, order);
        best = r.0;
        v = r.1;
    } else {
        let r = pvs_root(black, white, to_move, 1, NEG, POS, tt, order); // first: full window
        best = r.0;
        v = r.1;
        for d in 2..=depth {
            // Aspirate; only an in-window (exact) pass updates the chosen move,
            // so the deterministic first-LSB-max tie-break is preserved.
            let mut delta = ASP_DELTA;
            let mut alpha = (v - delta).max(NEG);
            let mut beta = (v + delta).min(POS);
            loop {
                let (bm, got) = pvs_root(black, white, to_move, d, alpha, beta, tt, order);
                if got <= alpha && alpha > NEG {
                    alpha = (got - delta).max(NEG);
                    delta = delta.saturating_mul(2);
                } else if got >= beta && beta < POS {
                    beta = (got + delta).min(POS);
                    delta = delta.saturating_mul(2);
                } else {
                    best = bm;
                    v = got;
                    break;
                }
            }
        }
    }
    (best, if to_move == 0 { v } else { -v })
}

// --------------------------------------------------------------------------- //
// Exact endgame solver (the `--depth full` path): negamax to terminal, no
// horizon heuristic. The TT is keyed by the *empty count* -- which is
// path-independent -- so transpositions share fully, and that key also keeps
// these entries disjoint from the depth-keyed PVS entries in a shared table.
// --------------------------------------------------------------------------- //

fn solve_pvs(
    black: u64,
    white: u64,
    to_move: i32,
    mut alpha: i32,
    mut beta: i32,
    tt: &mut TranspositionTable,
    order: bool,
) -> i32 {
    let empties = (!(black | white)).count_ones() as i32;
    let idx = tt.index(black, white, to_move, empties);
    let a0 = alpha;

    let e = tt.get(idx);
    if e.used != 0
        && e.black == black
        && e.white == white
        && e.to_move as i32 == to_move
        && e.depth as i32 == empties
    {
        let value = e.value;
        let flag = e.flag as i32;
        if flag == EXACT {
            return value;
        } else if flag == LOWER {
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

    let (player, opp) = if to_move == 0 {
        (black, white)
    } else {
        (white, black)
    };
    let mut moves = legal_moves(player, opp);

    if moves == 0 {
        if legal_moves(opp, player) == 0 {
            let diff = black.count_ones() as i32 - white.count_ones() as i32; // terminal
            let value = if to_move == 0 { diff } else { -diff };
            tt.store(idx, black, white, to_move, empties, value, EXACT);
            return value;
        }
        let value = -solve_pvs(black, white, to_move ^ 1, -beta, -alpha, tt, order); // pass
        let flag = if value <= a0 {
            UPPER
        } else if value >= beta {
            LOWER
        } else {
            EXACT
        };
        tt.store(idx, black, white, to_move, empties, value, flag);
        return value;
    }

    let ordering = order && empties >= ENDGAME_ORDER_MIN;
    let mut value = NEG;
    let mut best = 0u64;

    if ordering {
        let mut cb = [0u64; 64];
        let mut cw = [0u64; 64];
        let mut cm = [0u64; 64];
        let mut ck = [0i32; 64];
        let mut n = 0usize;
        while moves != 0 {
            let m = moves & moves.wrapping_neg();
            moves ^= m;
            let fl = flips_for_move(m, player, opp);
            let (nb, nw) = if to_move == 0 {
                (black | m | fl, white & !fl)
            } else {
                (black & !fl, white | m | fl)
            };
            cb[n] = nb;
            cw[n] = nw;
            cm[n] = m;
            ck[n] = if to_move == 0 {
                legal_moves(nw, nb).count_ones() as i32
            } else {
                legal_moves(nb, nw).count_ones() as i32
            };
            n += 1;
        }
        if n > 1 {
            for i in 1..n {
                let (ckey, bb, ww, mm) = (ck[i], cb[i], cw[i], cm[i]);
                let mut j = i;
                while j > 0 && ck[j - 1] > ckey {
                    ck[j] = ck[j - 1];
                    cb[j] = cb[j - 1];
                    cw[j] = cw[j - 1];
                    cm[j] = cm[j - 1];
                    j -= 1;
                }
                ck[j] = ckey;
                cb[j] = bb;
                cw[j] = ww;
                cm[j] = mm;
            }
        }
        let hint = tt.hint_get(tt.pos_index(black, white, to_move));
        if hint != 0 {
            for i in 0..n {
                if cm[i] == hint {
                    if i != 0 {
                        let (nb, nw, mm) = (cb[i], cw[i], cm[i]);
                        let mut j = i;
                        while j > 0 {
                            cb[j] = cb[j - 1];
                            cw[j] = cw[j - 1];
                            cm[j] = cm[j - 1];
                            j -= 1;
                        }
                        cb[0] = nb;
                        cw[0] = nw;
                        cm[0] = mm;
                    }
                    break;
                }
            }
        }
        best = cm[0];
        for i in 0..n {
            let v = if i == 0 {
                -solve_pvs(cb[i], cw[i], to_move ^ 1, -beta, -alpha, tt, order)
            } else {
                let scout = -solve_pvs(cb[i], cw[i], to_move ^ 1, -alpha - 1, -alpha, tt, order);
                if alpha < scout && scout < beta {
                    -solve_pvs(cb[i], cw[i], to_move ^ 1, -beta, -alpha, tt, order)
                } else {
                    scout
                }
            };
            if v > value {
                value = v;
                best = cm[i];
            }
            if v > alpha {
                alpha = v;
            }
            if alpha >= beta {
                break;
            }
        }
    } else {
        let hint = tt.hint_get(tt.pos_index(black, white, to_move));
        let hint_legal = hint != 0 && moves & hint != 0;
        let mut remaining = if hint_legal { moves & !hint } else { moves };
        let mut first = true;
        loop {
            let m = if first && hint_legal {
                hint
            } else if remaining != 0 {
                let lsb = remaining & remaining.wrapping_neg();
                remaining ^= lsb;
                lsb
            } else {
                break;
            };
            let fl = flips_for_move(m, player, opp);
            let (nb, nw) = if to_move == 0 {
                (black | m | fl, white & !fl)
            } else {
                (black & !fl, white | m | fl)
            };
            let v = if first {
                -solve_pvs(nb, nw, to_move ^ 1, -beta, -alpha, tt, order)
            } else {
                let scout = -solve_pvs(nb, nw, to_move ^ 1, -alpha - 1, -alpha, tt, order);
                if alpha < scout && scout < beta {
                    -solve_pvs(nb, nw, to_move ^ 1, -beta, -alpha, tt, order)
                } else {
                    scout
                }
            };
            if first || v > value {
                value = v;
                best = m;
            }
            if v > alpha {
                alpha = v;
            }
            first = false;
            if alpha >= beta {
                break;
            }
        }
    }

    let flag = if value <= a0 {
        UPPER
    } else if value >= beta {
        LOWER
    } else {
        EXACT
    };
    let idx = tt.index(black, white, to_move, empties);
    tt.store(idx, black, white, to_move, empties, value, flag);
    tt.hint_set(tt.pos_index(black, white, to_move), best);
    value
}

/// Exact black-centred value to game end -- the `--depth full` solver.
pub fn solve(
    black: u64,
    white: u64,
    to_move: i32,
    tt: &mut TranspositionTable,
    order: bool,
) -> i32 {
    let v = solve_pvs(black, white, to_move, NEG, POS, tt, order);
    if to_move == 0 {
        v
    } else {
        -v
    }
}
