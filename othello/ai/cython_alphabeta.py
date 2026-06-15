"""Native (Cython) alpha-beta engines.

The whole search inner loop runs in compiled code (othello._search): no Board
objects, native recursion, inlined make-move. Values are identical to the
Python AlphaBeta / AlphaBetaOrdered (asserted in the test suite), so these are
drop-in faster engines. When the extension isn't built they transparently fall
back to the pure-Python engine, and full searches (depth=None) always delegate
to it (the native search is finite-depth).
"""
from __future__ import annotations

from othello.core import Score
from othello.game import GameState, Engine, Depth, MoveScores, child_depth, iter_actions
from othello.ai.alphabeta import AlphaBeta
from othello.ai.alphabeta_move_ordering import AlphaBetaOrdered

try:
    from othello import _search  # ty: ignore[unresolved-import]  # compiled ext
    HAVE_SEARCH = True
except ImportError:
    HAVE_SEARCH = False


class _NativeEngine(Engine):
    """Shared wiring: native search for finite depth, Python fallback otherwise."""
    _order = 0
    _fallback_cls: type[AlphaBeta] = AlphaBeta   # AlphaBetaOrdered is a subclass

    def __init__(self) -> None:
        self.cache: dict = {}                 # native TT: (b,w,to_move,depth)->(value,flag)
        self.fallback = self._fallback_cls()

    def reset(self) -> None:
        self.cache.clear()
        self.fallback.reset()

    def value(self, state: GameState, depth: Depth = None) -> Score:
        if depth is None or not HAVE_SEARCH:
            return self.fallback.value(state, depth)
        return _search.search(state.black, state.white, state.to_move,  # ty: ignore[unresolved-attribute]
                              depth, self.cache, self._order)

    def scores(self, state: GameState, depth: Depth = None) -> MoveScores:
        if state.is_terminal():
            raise ValueError(f"{self.name}: no scores for a terminal state")
        child = child_depth(depth)
        return [(move, self.value(state._make_move_unchecked(move), child))
                for move in iter_actions(state)]


class CythonAlphaBeta(_NativeEngine):
    name = "cython-alphabeta"
    default_depth = 8
    _order = 0
    _fallback_cls = AlphaBeta


class CythonAlphaBetaOrdered(_NativeEngine):
    name = "cython-alphabeta+ordering"
    default_depth = 8
    _order = 1
    _fallback_cls = AlphaBetaOrdered
