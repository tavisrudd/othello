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
#
# Eight ray directions, each a bit shift with an edge mask to stop file wrap.
# Inlined into _legal_moves / _flips_for_move (the search hot path) rather than
# called as functions -- the per-shift call overhead dominated otherwise:
#     east  (x & NOT_H_FILE) << 1      west  (x & NOT_A_FILE) >> 1
#     north  x << 8                    south  x >> 8
#     NE    (x & NOT_H_FILE) << 9      NW    (x & NOT_A_FILE) << 7
#     SE    (x & NOT_H_FILE) >> 7      SW    (x & NOT_A_FILE) >> 9
# (each result is immediately `& opponent`/`& player`/`& empty`, which re-bounds
# it to 64 bits, so no separate FULL mask is needed.)

NOT_A_FILE = 0xFEFEFEFEFEFEFEFE
NOT_H_FILE = 0x7F7F7F7F7F7F7F7F

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

@dataclass(frozen=True, slots=True)
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
        # Kogge-Stone parallel-prefix occluded fill: flood `player` through the
        # contiguous run of `opponent` discs along each of the 8 rays in 3
        # shift-doubling steps (vs 6 linear), then the empty square just past the
        # run is a legal move. `g & opponent` drops the seed, so a move needs the
        # run to be >= 1 disc. Rightward rays mask file-A wrap, leftward file-H.
        empty = ~(player | opponent) & FULL
        moves = 0

        g = player; p = opponent                                     # north
        g |= p & (g << 8);  p &= p << 8
        g |= p & (g << 16); p &= p << 16
        g |= p & (g << 32)
        moves |= ((g & opponent) << 8) & empty

        g = player; p = opponent                                     # south
        g |= p & (g >> 8);  p &= p >> 8
        g |= p & (g >> 16); p &= p >> 16
        g |= p & (g >> 32)
        moves |= ((g & opponent) >> 8) & empty

        ep = opponent & NOT_A_FILE                                   # rightward
        g = player; p = ep                                           # east
        g |= p & (g << 1);  p &= p << 1
        g |= p & (g << 2);  p &= p << 2
        g |= p & (g << 4)
        moves |= (((g & opponent) << 1) & NOT_A_FILE) & empty

        g = player; p = ep                                           # northeast
        g |= p & (g << 9);  p &= p << 9
        g |= p & (g << 18); p &= p << 18
        g |= p & (g << 36)
        moves |= (((g & opponent) << 9) & NOT_A_FILE) & empty

        g = player; p = ep                                           # southeast
        g |= p & (g >> 7);  p &= p >> 7
        g |= p & (g >> 14); p &= p >> 14
        g |= p & (g >> 28)
        moves |= (((g & opponent) >> 7) & NOT_A_FILE) & empty

        wp = opponent & NOT_H_FILE                                   # leftward
        g = player; p = wp                                           # west
        g |= p & (g >> 1);  p &= p >> 1
        g |= p & (g >> 2);  p &= p >> 2
        g |= p & (g >> 4)
        moves |= (((g & opponent) >> 1) & NOT_H_FILE) & empty

        g = player; p = wp                                           # northwest
        g |= p & (g << 7);  p &= p << 7
        g |= p & (g << 14); p &= p << 14
        g |= p & (g << 28)
        moves |= (((g & opponent) << 7) & NOT_H_FILE) & empty

        g = player; p = wp                                           # southwest
        g |= p & (g >> 9);  p &= p >> 9
        g |= p & (g >> 18); p &= p >> 18
        g |= p & (g >> 36)
        moves |= (((g & opponent) >> 9) & NOT_H_FILE) & empty

        return moves

    @staticmethod
    def _flips_for_move(move: Move, player: Bitmap, opponent: Bitmap) -> Bitmap:
        # Per ray: walk the contiguous opponent run from `move`; if it ends on
        # one of ours, capture it. Inlined shifts; the while loop early-exits as
        # soon as the run ends (runs are usually short, so this beats a fixed
        # fill). Only north can shift past bit 63, so it alone needs `& FULL`.
        flips = 0

        x = (move & NOT_H_FILE) << 1                                 # east
        cap = 0
        while x & opponent:
            cap |= x; x = (x & NOT_H_FILE) << 1
        if x & player: flips |= cap

        x = (move & NOT_A_FILE) >> 1                                 # west
        cap = 0
        while x & opponent:
            cap |= x; x = (x & NOT_A_FILE) >> 1
        if x & player: flips |= cap

        x = (move << 8) & FULL                                       # north
        cap = 0
        while x & opponent:
            cap |= x; x = (x << 8) & FULL
        if x & player: flips |= cap

        x = move >> 8                                                # south
        cap = 0
        while x & opponent:
            cap |= x; x = x >> 8
        if x & player: flips |= cap

        x = (move & NOT_H_FILE) << 9                                 # northeast
        cap = 0
        while x & opponent:
            cap |= x; x = (x & NOT_H_FILE) << 9
        if x & player: flips |= cap

        x = (move & NOT_A_FILE) << 7                                 # northwest
        cap = 0
        while x & opponent:
            cap |= x; x = (x & NOT_A_FILE) << 7
        if x & player: flips |= cap

        x = (move & NOT_H_FILE) >> 7                                 # southeast
        cap = 0
        while x & opponent:
            cap |= x; x = (x & NOT_H_FILE) >> 7
        if x & player: flips |= cap

        x = (move & NOT_A_FILE) >> 9                                 # southwest
        cap = 0
        while x & opponent:
            cap |= x; x = (x & NOT_A_FILE) >> 9
        if x & player: flips |= cap

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
