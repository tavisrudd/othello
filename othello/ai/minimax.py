"""Plain black-centered minimax with a depth-keyed position cache.

No pruning -- the simplest correct engine, and a useful ground-truth baseline.
The value is absolute (black-centered disc differential), so a position's value
is path-independent and the cache can be keyed on the position alone (plus the
remaining depth, since a heuristic-cutoff value must not be reused deeper).
"""
from __future__ import annotations

from othello.core import BLACK, Score
from othello.game import (
    GameState, Engine, Depth, MoveScores, CacheKey, iter_actions, child_depth,
)
from othello.ai.evaluation import utility, heuristic

type ValueCache = dict[CacheKey, Score]


class Minimax(Engine):
    name = "minimax"
    default_depth = 4            # no pruning, so keep the default shallow

    def __init__(self) -> None:
        self.cache: ValueCache = {}

    def reset(self) -> None:
        self.cache.clear()

    def value(self, state: GameState, depth: Depth = None) -> Score:
        key: CacheKey = (state.cache_key, depth)
        cached = self.cache.get(key)
        if cached is not None:
            return cached
        if depth is not None and depth <= 0:
            score = heuristic(state, BLACK)      # positional estimate at the horizon
        elif state.is_terminal():
            score = utility(state, BLACK)        # exact terminal score
        else:
            child = child_depth(depth)
            values = [self.value(state._make_move_unchecked(m), child)
                      for m in iter_actions(state)]
            score = max(values) if state.to_move == BLACK else min(values)
        self.cache[key] = score
        return score

    def scores(self, state: GameState, depth: Depth = None) -> MoveScores:
        if state.is_terminal():
            raise ValueError("minimax: no scores for a terminal state")
        child = child_depth(depth)
        return [(move, self.value(state._make_move_unchecked(move), child))
                for move in iter_actions(state)]
