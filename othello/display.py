"""Terminal rendering for boards, moves, and scores (ANSI colour)."""
from __future__ import annotations
from typing import Final, Callable, TypeGuard, cast

from othello.core import (
    Board, Bitmap, Move, Player, Score, PASS, BLACK,
    format_square, format_move,
)

CELL_WIDTH: Final[int] = 2

RESET = "\033[0m"

BLACK_FG = "\033[90m"
WHITE_FG = "\033[97m"      # bright white

BLACK_BG = "\033[97;100m"
WHITE_BG = "\033[30;107m"

BLACK_DOT_FG = "\033[38;5;240m"
WHITE_DOT_FG = "\033[38;5;255m"

EMPTY_CELL = "\033[2;38;5;240m·\033[0m "

BLACK_MARK  = f"{BLACK_DOT_FG}⬤{RESET} "
WHITE_MARK  = f"{WHITE_DOT_FG}⬤{RESET} "

BLACK_LEGAL = f"{BLACK_FG}◌ {RESET}"
WHITE_LEGAL = f"{WHITE_FG}◌ {RESET}"

GREEN_FG = "\033[38;5;46m"
LEGAL_DOT = f"{GREEN_FG}•{RESET} "

RED_BG = "\033[48;5;52m"

BLACK_LAST_MARK = f"{RED_BG}{BLACK_DOT_FG}⬤{RESET} "
WHITE_LAST_MARK = f"{RED_BG}{WHITE_DOT_FG}⬤{RESET} "

type CellRenderer = str | Callable[[int], str]

def is_renderer(x: CellRenderer) -> TypeGuard[Callable[[int], str]]:
    return not isinstance(x, str)

type BitmapLayer = tuple[Bitmap, CellRenderer]


# Rank/file legal-move indicators — replaced by LEGAL_DOT (green dot).
# def black_legal(sq: int) -> str:
#     return f"{BLACK_BG}{format_square(sq):<{CELL_WIDTH}}{RESET}"
#
# def white_legal(sq: int) -> str:
#     return f"{WHITE_BG}{format_square(sq):<{CELL_WIDTH}}{RESET}"


def last_move_renderer(board: Board) -> Callable[[int], str]:
    def render(sq: int) -> str:
        bit = 1 << sq
        if board.black & bit:
            return BLACK_LAST_MARK
        if board.white & bit:
            return WHITE_LAST_MARK
        return f"\033[103m{format_square(sq):<{CELL_WIDTH}}\033[0m"
    return render

def format_board(board: Board, show_valid_moves=True, last_move: Move | None = None) -> str:
    layers: list[BitmapLayer] = []
    if last_move is not None and last_move != PASS:
        if last_move & (last_move - 1):
            raise ValueError(f"last_move is not one-hot: {last_move:#x}")
        layers.append((last_move, last_move_renderer(board)))
    layers.extend([
        (board.black, BLACK_MARK),
        (board.white, WHITE_MARK),
    ])
    if show_valid_moves:
        layers.append((board.actions(), LEGAL_DOT))
    return _format_board(*layers)


def _format_board(*layers: BitmapLayer) -> str:
    out: list[str] = []
    for r in range(7, -1, -1):
        row: list[str] = []
        for c in range(8):
            sq = r * 8 + c
            bit = 1 << sq
            cell: str = EMPTY_CELL
            for bitmap, renderer in layers:
                if bitmap & bit:
                    if is_renderer(renderer):
                        cell = renderer(sq)
                    else:
                        cell = cast(str, renderer)
                    break
            row.append(cell)
        out.append(f"{r + 1:>2}  {' '.join(row)}")
    out.append("    " + " ".join(f"{f:<{CELL_WIDTH}}" for f in "ABCDEFGH"))
    return "\n".join(out)


def player_name(player: Player) -> str:
    return "black" if player == BLACK else "white"

def move_name(move: Move) -> str:
    return "PASS" if move == PASS else format_move(move)

def format_score(score: Score) -> str:
    # Black-centered margin, sign kept, tagged by who it favours: B:+6 = black
    # ahead by 6, W:-4 = white ahead by 4 (black-centered -4), T:0 = tie.
    if score > 0:
        return f"B:{score:+d}"
    if score < 0:
        return f"W:{score:+d}"
    return "T:0"
