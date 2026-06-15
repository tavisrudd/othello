"""AI engines for Othello. Each module implements one search strategy as an
`othello.game.Engine` subclass, so they are interchangeable in `play_game`.
"""
from othello.game import Engine
from othello.ai.minimax import Minimax
from othello.ai.alphabeta import AlphaBeta
from othello.ai.alphabeta_move_ordering import AlphaBetaOrdered

# Registry for the CLI (--engine). Maps a stable cli name to the class.
ENGINES: dict[str, type[Engine]] = {
    "minimax": Minimax,
    "alphabeta": AlphaBeta,
    "ordered": AlphaBetaOrdered,
}

__all__ = ["Minimax", "AlphaBeta", "AlphaBetaOrdered", "ENGINES"]
