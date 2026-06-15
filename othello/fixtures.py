"""Starting positions for play and tests."""
from __future__ import annotations
from othello.core import Board, BLACK, FULL, square_to_move

def init_early_game() -> Board:
    BLACK_START = square_to_move('D5') | square_to_move('E4')
    WHITE_START = square_to_move('D4') | square_to_move('E5')
    return Board(black=BLACK_START, white=WHITE_START, to_move=BLACK)

def init_near_terminal_game_white_win() -> Board:
    EMPTY_START = (
        square_to_move("A1")
        | square_to_move("E1")
        | square_to_move("A2")
        | square_to_move("B7")
        | square_to_move("A8")
        | square_to_move("B8")
    )
    BLACK_START = (
        square_to_move("F1")
        | square_to_move("E2")
        | square_to_move("D3")
        | square_to_move("F3")
        | square_to_move("C4")
        | square_to_move("F4")
        | square_to_move("B5")
        | square_to_move("F5")
        | square_to_move("C6")
        | square_to_move("C7")
        | square_to_move("D7")
        | square_to_move("E7")
        | square_to_move("C8")
        | square_to_move("D8")
        | square_to_move("E8")
    )
    WHITE_START = FULL ^ BLACK_START ^ EMPTY_START
    return Board(black=BLACK_START, white=WHITE_START, to_move=BLACK)

def init_near_terminal_game_black_win() -> Board:
    BLACK_START = 0x0DEFEF236143030F
    WHITE_START = 0x9010105C9CBCFCE0
    return Board(black=BLACK_START, white=WHITE_START, to_move=BLACK)

def init_near_terminal_game_either_can_win() -> Board:
    BLACK_START = 0x0DEFEF236143032F
    WHITE_START = 0x9010105C9CBCFCC0
    return Board(black=BLACK_START, white=WHITE_START, to_move=BLACK)

# Named starts for the CLI (--start).
STARTS = {
    "early": init_early_game,
    "white-win": init_near_terminal_game_white_win,
    "black-win": init_near_terminal_game_black_win,
    "either": init_near_terminal_game_either_can_win,
}
