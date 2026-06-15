"""Black-centered alpha-beta with a bound-tracking transposition table.

Pruning makes a node's value a *bound* rather than the exact value, so each
cache entry carries a flag (EXACT / LOWER / UPPER). The key pins the remaining
depth, so an entry is reused only at the same horizon; for full searches
(depth=None) the depth component is constant and transpositions still share
entries. Full-window search returns exact values, so move choice matches plain
minimax.
"""
from __future__ import annotations
from typing import Final, Literal
from collections.abc import Iterable

from othello.core import BLACK, Move, Score, MIN_SCORE, MAX_SCORE
from othello.game import (
    GameState, Engine, Depth, MoveScores, CacheKey, iter_actions, child_depth,
)

type Bound = Literal["exact", "lower", "upper"]
EXACT: Final[Bound] = "exact"
LOWER: Final[Bound] = "lower"     # true value >= stored (search failed high)
UPPER: Final[Bound] = "upper"     # true value <= stored (search failed low)

type Entry = tuple[Score, Bound]
type BoundCache = dict[CacheKey, Entry]


class AlphaBeta(Engine):
    name = "alphabeta"

    def __init__(self) -> None:
        self.cache: BoundCache = {}

    def reset(self) -> None:
        self.cache.clear()

    def order_moves(self, state: GameState, depth: Depth) -> Iterable[Move]:
        # Hook for subclasses: searching likely-best moves first yields earlier
        # cutoffs. `depth` is the remaining depth at this node, so an override
        # can skip ordering where the subtree is too small to pay for it. Order
        # never changes the value, only the node count.
        return iter_actions(state)

    def value(self, state: GameState, depth: Depth = None,
              alpha: Score = MIN_SCORE, beta: Score = MAX_SCORE) -> Score:
        key: CacheKey = (state.cache_key, depth)
        alpha_orig, beta_orig = alpha, beta

        entry = self.cache.get(key)
        if entry is not None:
            value, flag = entry
            if flag == EXACT:
                return value
            if flag == LOWER:
                alpha = max(alpha, value)        # true value >= stored
            else:                                # UPPER: true value <= stored
                beta = min(beta, value)
            if alpha >= beta:
                return value

        if state.is_terminal() or (depth is not None and depth <= 0):
            value = state.utility(BLACK)         # exact at terminal; heuristic at horizon
            self.cache[key] = (value, EXACT)
            return value

        child = child_depth(depth)
        if state.to_move == BLACK:               # maximiser
            value = MIN_SCORE
            for move in self.order_moves(state, depth):
                value = max(value, self.value(
                    state._make_move_unchecked(move), child, alpha, beta))
                alpha = max(alpha, value)
                if alpha >= beta:                # beta cutoff (fail-high)
                    break
            flag = UPPER if value <= alpha_orig else LOWER if value >= beta else EXACT
        else:                                    # minimiser (WHITE)
            value = MAX_SCORE
            for move in self.order_moves(state, depth):
                value = min(value, self.value(
                    state._make_move_unchecked(move), child, alpha, beta))
                beta = min(beta, value)
                if alpha >= beta:                # alpha cutoff (fail-low)
                    break
            flag = LOWER if value >= beta_orig else UPPER if value <= alpha else EXACT

        self.cache[key] = (value, flag)
        return value

    def scores(self, state: GameState, depth: Depth = None) -> MoveScores:
        # Each root child is searched with a full window, so every reported
        # score is exact (no root-sibling pruning); the shared cache still lets
        # later children reuse transpositions found by earlier ones.
        if state.is_terminal():
            raise ValueError("alphabeta: no scores for a terminal state")
        child = child_depth(depth)
        return [(move, self.value(state._make_move_unchecked(move), child))
                for move in iter_actions(state)]
