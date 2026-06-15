"""Othello game core: board state, rules, move generation, and coordinates.

No search/AI here -- see othello.ai for engines and othello.game for the
generic game interface they consume.
"""
from __future__ import annotations
from typing import Final, Literal
from collections.abc import Hashable
from dataclasses import dataclass

type Bit = Literal[0, 1]
type Player = Bit
BLACK: Final[Player] = 0
WHITE: Final[Player] = 1

type Bitmap = int
type Moves = Bitmap
type Move = Bitmap
type Square = int
type SquareName = str
type Score = int

PASS: Final[Move] = 0
MIN_SCORE: Final[Score] = -10**9
MAX_SCORE: Final[Score] = 10**9

FULL = 0xFFFFFFFFFFFFFFFF

def parse_square_name(sq: SquareName) -> Square:
    if len(sq) != 2:
        raise ValueError(f"invalid square: {sq!r}")
    file = sq[0].upper()
    rank = sq[1]
    if not ("A" <= file <= "H"):
        raise ValueError(f"invalid file: {file!r}")
    if not ("1" <= rank <= "8"):
        raise ValueError(f"invalid rank: {rank!r}")
    return (int(rank) - 1) * 8 + (ord(file) - ord("A"))

def format_square(square: Square) -> SquareName:
    if not 0 <= square < 64:
        raise ValueError(f"invalid square index: {square}")
    return f"{chr(ord('A') + square % 8)}{square // 8 + 1}"

def square_to_move(square: SquareName) -> Move:
    return 1 << parse_square_name(square)

def move_to_square(move: Move) -> Square:
    return move.bit_length() - 1

def format_move(move: Move) -> SquareName:
    return format_square(move_to_square(move))

################################################################################
## Direction shifts

NOT_A_FILE = 0xFEFEFEFEFEFEFEFE
NOT_H_FILE = 0x7F7F7F7F7F7F7F7F

def east(x):
    return (x & NOT_H_FILE) << 1

def west(x):
    return (x & NOT_A_FILE) >> 1

def north(x):
    return (x << 8) & FULL

def south(x):
    return x >> 8

def northeast(x):
    return (x & NOT_H_FILE) << 9

def northwest(x):
    return (x & NOT_A_FILE) << 7

def southeast(x):
    return (x & NOT_H_FILE) >> 7

def southwest(x):
    return (x & NOT_A_FILE) >> 9

DIRECTIONS = (
    east, west,
    north, south,
    northeast, northwest,
    southeast, southwest,
)

################################################################################
## Moves

type MoveSpec = Move | SquareName

def parse_move(move: MoveSpec) -> Move:
    if isinstance(move, str):
        move = move.strip().upper()
        if move == "PASS":
            return PASS
        return square_to_move(move)
    return move

@dataclass(frozen=True)
class Board:
    black: Bitmap
    white: Bitmap
    to_move: Player

    def __str__(self) -> str:
        from othello.display import format_board   # lazy: display imports core
        return format_board(self)

    @property
    def cache_key(self) -> Hashable:
        return (self.black, self.white, self.to_move)

    @property
    def occupied(self) -> Bitmap:
        return self.black | self.white

    @property
    def empty(self) -> Bitmap:
        return FULL ^ self.occupied

    def is_terminal(self) -> bool:
        black_moves = self._legal_moves(self.black, self.white)
        white_moves = self._legal_moves(self.white, self.black)
        return black_moves == 0 and white_moves == 0

    def utility(self, player: Player) -> Score:
        # Disc differential from `player`'s view (own discs minus opponent's).
        # Its sign already encodes win/loss/draw, so this is a strict refinement
        # of WDL scoring: optimal play maximises the winning margin without ever
        # trading away the outcome, and equal-outcome moves are no longer broken
        # arbitrarily.
        diff = self.black.bit_count() - self.white.bit_count()
        return diff if player == BLACK else -diff

    def actions(self) -> Moves:
        player, opponent = self._player_opponent()
        return self._legal_moves(player, opponent)

    def make_move(self, move: Move) -> Board:
        if move == PASS:
            if self.actions():
                raise ValueError("cannot pass when legal moves exist")
            if self.is_terminal():
                raise ValueError("cannot pass from terminal state")
        else:
            if move & (move - 1):
                raise ValueError(f"move is not one-hot: {move:#x}")
            if not move & self.actions():
                raise ValueError(f"illegal move: {move:#x}")
        return self._make_move_unchecked(move)

    def _make_move_unchecked(self, move: Move) -> Board:
        # Apply `move` without validating legality. `move` must be PASS or a
        # legal one-hot move; the search guarantees this, so this skips the
        # `actions()` recompute (a full legal-move sweep) that `make_move` pays
        # per child.
        if move == PASS:
            return Board(
                black=self.black,
                white=self.white,
                to_move=self.to_move ^ 1,
            )
        if self.to_move == BLACK:
            flips = self._flips_for_move(move, self.black, self.white)
            return Board(
                black=self.black | move | flips,
                white=self.white & ~flips,
                to_move=WHITE,
            )
        else:
            flips = self._flips_for_move(move, self.white, self.black)
            return Board(
                black=self.black & ~flips,
                white=self.white | move | flips,
                to_move=BLACK,
            )

    ## shorthand
    def play(self, move: MoveSpec) -> Board:
        return self.make_move(parse_move(move))

    def __add__(self, move: MoveSpec) -> Board:
        return self.play(move)

    def __iadd__(self, move: MoveSpec) -> Board:
        return self.play(move)

    def _player_opponent(self) -> tuple[Bitmap, Bitmap]:
        return (
            (self.black, self.white)
            if self.to_move == BLACK
            else (self.white, self.black)
        )

    @staticmethod
    def _legal_moves(player: Bitmap, opponent: Bitmap) -> Moves:
        empty = ~(player | opponent) & FULL
        moves = 0
        for shift in DIRECTIONS:
            x = shift(player) & opponent
            for _ in range(6):
                x |= shift(x) & opponent
            moves |= shift(x) & empty
        return moves

    @staticmethod
    def _flips_for_move(move: Move, player: Bitmap, opponent: Bitmap) -> Bitmap:
        flips = 0
        for shift in DIRECTIONS:
            captured = 0
            x = shift(move)
            while x and (x & opponent):
                captured |= x
                x = shift(x)
            if x & player:
                flips |= captured
        return flips

BLACK_CHARS = "BX*"
WHITE_CHARS = "WO"
EMPTY_CHARS = ".-_"

def parse_board(text: str, to_move: Player = BLACK) -> Board:
    """Parse an 8x8 text grid into a Board.

    Rows run top (rank 8) to bottom (rank 1), like the printed board; columns
    A..H left to right. Cells: B/X/* = black, W/O = white, ./-/_ = empty
    (case-insensitive; spaces between cells are ignored). Lines starting with
    '#' are comments. A `to_move: black|white` line sets the side to move and
    overrides the `to_move` argument.
    """
    black = white = 0
    rows: list[str] = []
    side: Player | None = None
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        low = line.lower()
        if low.startswith("to_move") or low.startswith("to-move"):
            value = low.split(":", 1)[-1].strip() or low.split()[-1]
            side = WHITE if value.startswith("w") else BLACK
            continue
        rows.append(line.replace(" ", ""))
    if len(rows) != 8:
        raise ValueError(f"board needs 8 grid rows, got {len(rows)}")
    for i, row in enumerate(rows):
        if len(row) != 8:
            raise ValueError(f"row {i + 1} must have 8 cells, got {row!r}")
        rank = 7 - i                          # top row is rank 8
        for c, ch in enumerate(row):
            bit = 1 << (rank * 8 + c)
            upper = ch.upper()
            if upper in BLACK_CHARS:
                black |= bit
            elif upper in WHITE_CHARS:
                white |= bit
            elif upper not in EMPTY_CHARS:
                raise ValueError(f"bad cell {ch!r} at row {i + 1}, col {c + 1}")
    return Board(black=black, white=white, to_move=side if side is not None else to_move)

def winner(board: Board) -> Player | None:
    black = board.black.bit_count()
    white = board.white.bit_count()
    if black > white:
        return BLACK
    if white > black:
        return WHITE
    return None
