"""8x8 Othello: game core plus interchangeable AI engines.

    from othello import init_early_game, AlphaBeta, play_game
    play_game(init_early_game(), AlphaBeta(), depth=6)
"""
from othello.core import (
    Bit, Player, BLACK, WHITE,
    Bitmap, Moves, Move, Square, SquareName, Score,
    PASS, MIN_SCORE, MAX_SCORE, FULL, MoveSpec,
    parse_square_name, format_square, square_to_move, move_to_square, format_move,
    parse_move, parse_board, Board, winner,
)
from othello.display import (
    format_board, format_score, player_name, move_name,
)
from othello.game import (
    GameState, Engine, Depth, MoveScores, CacheKey,
    iter_moves, iter_actions, best_by_side,
)
from othello.fixtures import (
    init_early_game,
    init_near_terminal_game_white_win,
    init_near_terminal_game_black_win,
    init_near_terminal_game_either_can_win,
    STARTS,
)
from othello.ai.minimax import Minimax
from othello.ai.alphabeta import AlphaBeta
from othello.ai.alphabeta_move_ordering import AlphaBetaOrdered
from othello.ai.cython_alphabeta import CythonAlphaBeta, CythonAlphaBetaOrdered
from othello.ai import ENGINES
from othello.play import play_game
from othello.cli import main

__all__ = [
    "Bit", "Player", "BLACK", "WHITE",
    "Bitmap", "Moves", "Move", "Square", "SquareName", "Score",
    "PASS", "MIN_SCORE", "MAX_SCORE", "FULL", "MoveSpec",
    "parse_square_name", "format_square", "square_to_move", "move_to_square",
    "format_move", "parse_move", "parse_board", "Board", "winner",
    "format_board", "format_score", "player_name", "move_name",
    "GameState", "Engine", "Depth", "MoveScores", "CacheKey",
    "iter_moves", "iter_actions", "best_by_side",
    "init_early_game", "init_near_terminal_game_white_win",
    "init_near_terminal_game_black_win", "init_near_terminal_game_either_can_win",
    "STARTS", "Minimax", "AlphaBeta", "AlphaBetaOrdered",
    "CythonAlphaBeta", "CythonAlphaBetaOrdered", "ENGINES",
    "play_game", "main",
]
