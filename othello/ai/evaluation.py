"""Position evaluation for the search engines (kept out of the game core).

`utility` is the exact terminal score -- the disc differential, black-centered
-- used at game-over nodes. `heuristic` is the estimate used at depth-limited
horizon nodes; disc count alone is a poor midgame guide (more discs mid-game is
often bad), so it also weights corners (permanently stable) and mobility (how
many legal moves each side has). The native Cython search inlines the identical
formulas, so all engines agree.
"""
from __future__ import annotations
from othello.core import Board, BLACK, Player, Score
from othello.game import GameState

CORNERS = 0x8100000000000081           # A1, H1, A8, H8
CORNER_WEIGHT = 25
MOBILITY_WEIGHT = 5
DISC_WEIGHT = 1


def utility(state: GameState, player: Player) -> Score:
    diff = state.black.bit_count() - state.white.bit_count()
    return diff if player == BLACK else -diff


def heuristic(state: GameState, player: Player) -> Score:
    black, white = state.black, state.white
    corner = (black & CORNERS).bit_count() - (white & CORNERS).bit_count()
    mobility = (Board._legal_moves(black, white).bit_count()
                - Board._legal_moves(white, black).bit_count())
    disc = black.bit_count() - white.bit_count()
    score = CORNER_WEIGHT * corner + MOBILITY_WEIGHT * mobility + DISC_WEIGHT * disc
    return score if player == BLACK else -score
