"""Drive a self-play game with a chosen engine, printing each turn."""
from __future__ import annotations

from othello.core import Board, Move, winner
from othello.display import (
    format_board, format_score, player_name, move_name, BLACK_DOT_FG, RESET,
)
from othello.game import Engine, Depth, best_by_side
from othello.ai.alphabeta import AlphaBeta


def play_game(board: Board, engine: Engine | None = None,
              depth: Depth = None) -> Board:
    engine = AlphaBeta() if engine is None else engine
    last_move: Move | None = None
    turn = 1

    while not board.is_terminal():
        print()
        print(f"turn {turn}: {player_name(board.to_move)} to move")
        print(format_board(board, last_move=last_move))

        scored = engine.scores(board, depth)
        for move, score in scored:
            text = format_score(score)
            if score > 0:                       # black-favouring -> black-dot colour
                text = f"{BLACK_DOT_FG}{text}{RESET}"
            print(f"{move_name(move):>4} {text}")

        best_move = best_by_side(board, scored)
        print(f"best: {move_name(best_move)}")

        board = board.make_move(best_move)
        last_move = best_move
        turn += 1

    print()
    print("terminal")
    print(format_board(board, show_valid_moves=False, last_move=last_move))

    print(f"black: {board.black.bit_count()}")
    print(f"white: {board.white.bit_count()}")

    win = winner(board)
    print("winner: draw" if win is None else f"winner: {player_name(win)}")

    return board
