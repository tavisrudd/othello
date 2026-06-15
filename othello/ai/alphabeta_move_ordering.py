"""Alpha-beta with mobility-based move ordering.

Alpha-beta prunes far more when the best move is tried first. The cheap, robust
predictor of a strong Othello move at any stage is *mobility*: play the move
that leaves the opponent the fewest replies. (A static corner/edge weight table
was tried and rejected -- it helps in the endgame but hurts in the opening,
where edge moves are weak, so net it explored *more* nodes.)

Computing mobility costs a make-move + legal-move sweep per move, which is only
worth paying where the subtree below is large enough to recoup it. So ordering
is skipped near the leaves (remaining depth < ORDER_MIN_DEPTH); near-leaf nodes
dominate the count, and ordering them was a net wall-clock loss mid-game even
though it cut nodes. With the gate, ordering is a clear net win that grows with
depth. Values (and move choice) are identical to AlphaBeta regardless.
"""
from __future__ import annotations
from typing import Final
from collections.abc import Iterable

from othello.core import Move, Moves
from othello.game import GameState, Depth, iter_moves
from othello.ai.alphabeta import AlphaBeta

ORDER_MIN_DEPTH: Final[int] = 4   # don't order with fewer plies left than this


class AlphaBetaOrdered(AlphaBeta):
    name = "alphabeta+ordering"
    default_depth = 6            # a full self-play game at 7 is slow; 6 for now

    def order_moves(self, state: GameState, moves: Moves, depth: Depth) -> Iterable[Move]:
        if depth is not None and depth < ORDER_MIN_DEPTH:
            return iter_moves(moves)             # too shallow to pay for ordering
        move_list = list(iter_moves(moves))
        if len(move_list) < 2:                   # single move
            return move_list
        # Fewest opponent replies first -- restrict the opponent.
        make = state._make_move_unchecked
        return sorted(move_list, key=lambda m: make(m).actions().bit_count())
