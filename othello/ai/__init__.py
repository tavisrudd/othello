"""AI engines for Othello. Each module implements one search strategy as an
`othello.game.Engine` subclass, so they are interchangeable in `play_game`.
"""
from othello.game import Engine
from othello.ai.minimax import Minimax
from othello.ai.alphabeta import AlphaBeta
from othello.ai.alphabeta_move_ordering import AlphaBetaOrdered
from othello.ai.cython_alphabeta import CythonAlphaBeta, CythonAlphaBetaOrdered

# Registry for the CLI (--engine). Maps a stable cli name to the class. The
# cython-* engines fall back to their pure-Python equivalent when the compiled
# extension isn't built.
ENGINES: dict[str, type[Engine]] = {
    "minimax": Minimax,
    "alphabeta": AlphaBeta,
    "ordered": AlphaBetaOrdered,
    "cython": CythonAlphaBeta,
    "cython-ordered": CythonAlphaBetaOrdered,
}

__all__ = [
    "Minimax", "AlphaBeta", "AlphaBetaOrdered",
    "CythonAlphaBeta", "CythonAlphaBetaOrdered", "ENGINES",
]
