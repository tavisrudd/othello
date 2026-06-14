from __future__ import annotations
from typing import (Final, Literal, Callable, TypeGuard, Iterator, cast, Protocol, TypeVar)
from collections.abc import Iterable, Hashable
from dataclasses import dataclass, field
    
#      A  B  C  D  E  F  G  H
# 8 | 38 39 3A 3B 3C 3D 3E 3F
# 7 | 30 31 32 33 34 35 36 37
# 6 | 28 29 2A 2B 2C 2D 2E 2F
# 5 | 20 21 22 23 24 25 26 27
# 4 | 18 19 1A 1B 1C 1D 1E 1F
# 3 | 10 11 12 13 14 15 16 17
# 2 | 08 09 0A 0B 0C 0D 0E 0F
# 1 | 00 01 02 03 04 05 06 07


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
## 

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
        black = self.black.bit_count()
        white = self.white.bit_count()
        if black > white:
            winner = 0
        elif white > black:
            winner = 1
        else:
            return 0
        return 1 if winner == player else -1


    def actions(self) -> Moves:
        player, opponent = self._player_opponent()
        return self._legal_moves(player, opponent)
        
    def make_move(self, move: Move) -> Board:
        if move == PASS:
            if self.actions():
                raise ValueError("cannot pass when legal moves exist")
            if self.is_terminal():
                raise ValueError("cannot pass from terminal state")
            return Board(
                black=self.black,
                white=self.white,
                to_move=WHITE if self.to_move == BLACK else BLACK,
            )
        if move & (move - 1):
            raise ValueError(f"move is not one-hot: {move:#x}")
    
        if not move & self.actions():
            raise ValueError(f"illegal move: {move:#x}")
            
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


    ## 

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
    

def validate_board(board: Board) -> bool:
    return (
        board.black >= 0
        and board.white >= 0
        and (board.black & board.white) == 0
        and (board.black | board.white) <= FULL
    )

        
################################################################################
## Printers

CELL_WIDTH: Final[int] = 2

RESET = "\033[0m"

BLACK_FG = "\033[90m"
WHITE_FG = "\033[97m"      # bright white

BLACK_BG = "\033[97;100m"
WHITE_BG = "\033[30;107m"

EMPTY_CELL = "\033[2;38;5;240m·\033[0m "

BLACK_MARK  = "\033[38;5;240m⬤\033[0m "
WHITE_MARK  = "\033[38;5;255m⬤\033[0m "

BLACK_LEGAL = f"{BLACK_FG}◌ {RESET}"
WHITE_LEGAL = f"{WHITE_FG}◌ {RESET}"

# RED_UNDERLINE = "\033[4;58;5;196m"
# BLACK_LAST_MARK = f"{RED_UNDERLINE}{BLACK_MARK}"
# WHITE_LAST_MARK = f"{RED_UNDERLINE}{WHITE_MARK}"

#RED_BG = "\033[41m"
RED_BG = "\033[48;5;52m"

BLACK_LAST_MARK = f"{RED_BG}\033[38;5;240m⬤{RESET} "
WHITE_LAST_MARK = f"{RED_BG}\033[38;5;255m⬤{RESET} "

type CellRenderer = str | Callable[[int], str]

def is_renderer(x: CellRenderer) -> TypeGuard[Callable[[int], str]]:
    return not isinstance(x, str)

type BitmapLayer = tuple[Bitmap, CellRenderer]


def black_legal(sq: int) -> str:
    return f"{BLACK_BG}{format_square(sq):<{CELL_WIDTH}}{RESET}"

def white_legal(sq: int) -> str:
    return f"{WHITE_BG}{format_square(sq):<{CELL_WIDTH}}{RESET}"


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
        layers.append((
            board.actions(),
            black_legal if board.to_move == BLACK else white_legal,
        ))
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

    
################################################################################

class GameState(Protocol):
    to_move: Player
    def actions(self) -> Moves: ...
    def make_move(self, move: Move) -> GameState: ...
    def is_terminal(self) -> bool: ...
    def utility(self, player: Player) -> Score: ...

    @property
    def cache_key(self) -> Hashable: ...

State = TypeVar("State", bound=GameState)


def iter_moves(moves: Bitmap) -> Iterator[Move]:
    while moves:
        move = moves & -moves
        yield move
        moves ^= move

def iter_actions(state: GameState) -> Iterator[Move]:
    moves = state.actions()
    if moves:
        yield from iter_moves(moves)
    elif not state.is_terminal():
        yield PASS

## root player centered minimax scoring

# def minimax(state: State) -> Move:
#     if state.is_terminal():
#         raise ValueError("minimax called on terminal state")
#     root_player = state.to_move
#     best_move = PASS
#     best_score = MIN_SCORE
#     for move in iter_actions(state):
#         score = min_value(state.make_move(move), root_player)
#         if score > best_score:
#             best_move = move
#             best_score = score
#     return best_move

# def minimax_scores(state: GameState) -> list[tuple[Move, Score]]:
#     if state.is_terminal():
#         raise ValueError("minimax called on terminal state")
#     root_player = state.to_move
#     return [
#         (move, min_value(state.make_move(move), root_player))
#         for move in iter_actions(state)
#     ]

# def max_value(state: GameState, root_player: Player) -> Score:
#     if state.is_terminal():
#         return state.utility(root_player)
#     value = MIN_SCORE
#     for move in iter_actions(state):
#         value = max(value, min_value(state.make_move(move), root_player))
#     return value

# def min_value(state: GameState, root_player: Player) -> Score:
#     if state.is_terminal():
#         return state.utility(root_player)
#     value = MAX_SCORE
#     for move in iter_actions(state):
#         value = min(value, max_value(state.make_move(move), root_player))
#     return value

## black centered minimax scoring
# def black_score(state: GameState) -> Score:
#     return state.utility(BLACK)

type Cache = dict[Hashable, Score]

def minimax_value(state: GameState, cache: Cache) -> Score:
    key = state.cache_key
    if key in cache:
        return cache[key]
    if state.is_terminal():
        score = state.utility(BLACK)
        return score
    values = [minimax_value(state.make_move(move), cache)
              for move in iter_actions(state)]
    score = max(values) if state.to_move == BLACK else min(values)
    cache[key] = score
    return score

def minimax_scores(state: GameState, cache: Cache | None = None) -> list[tuple[Move, Score]]:
    if state.is_terminal():
        raise ValueError("minimax_scores called on terminal state")
    cache = {} if cache is None else cache
    return [
        (move, minimax_value(state.make_move(move), cache))
        for move in iter_actions(state)
    ]

def minimax(state: GameState, cache: Cache | None = None) -> Move:
    if state.is_terminal():
        raise ValueError("minimax called on terminal state")
    cache = {} if cache is None else cache
    scored = minimax_scores(state, cache)
    if state.to_move == BLACK:
        return max(scored, key=lambda x: x[1])[0]
    return min(scored, key=lambda x: x[1])[0]

def play_minimax_game(board: Board) -> Board:
    last_move: Move | None = None
    turn = 1

    while not board.is_terminal():
        print()
        print(f"turn {turn}: {player_name(board.to_move)} to move")
        print(format_board(board, last_move=last_move))

        cache: Cache = {}
        scored = minimax_scores(board, cache)
        
        for move, score in scored:
            print(f"{move_name(move):>4} {score:+d}")
        
        best_move = minimax(board, cache)
        print(f"best: {move_name(best_move)}")

        board = board.make_move(best_move)
        last_move = best_move
        turn += 1

    print()
    print("terminal")
    print(format_board(board, show_valid_moves=False, last_move=last_move))

    black = board.black.bit_count()
    white = board.white.bit_count()
    print(f"black: {black}")
    print(f"white: {white}")

    win = winner(board)
    if win is None:
        print("winner: draw")
    else:
        print(f"winner: {player_name(win)}")

    return board

def player_name(player: Player) -> str:
    return "black" if player == BLACK else "white"

def move_name(move: Move) -> str:
    return "PASS" if move == PASS else format_move(move)

def winner(board: Board) -> Player | None:
    black = board.black.bit_count()
    white = board.white.bit_count()
    if black > white:
        return BLACK
    if white > black:
        return WHITE
    return None

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

def main():
    #board = init_near_terminal_game_white_win()
    #board = init_near_terminal_game_black_win()
    board = init_near_terminal_game_either_can_win()
    board += 'F8'
    play_minimax_game(board)


#if __name__ == '__main__':
main()
