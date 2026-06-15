"""Command-line entry point: `python -m othello [options]`.

Uses argparse for option parsing.
"""
from __future__ import annotations
import argparse
import sys

from othello.core import Board, BLACK, WHITE, Player, parse_board
from othello.fixtures import STARTS
from othello.ai import ENGINES
from othello.play import play_game


class _EngineDefault:
    def __repr__(self) -> str:        # shown by argparse as the --depth default
        return "engine-specific"

UNSET = _EngineDefault()              # sentinel: --depth not given (None means 'full')


def _depth(value: str) -> int | None:
    if value.lower() in ("full", "none", "exact"):
        return None
    try:
        return int(value)
    except ValueError:
        raise argparse.ArgumentTypeError(f"depth must be an integer or 'full': {value!r}")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="othello",
        description="Play a self-play Othello game with a chosen search engine.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "--engine", choices=sorted(ENGINES), default="ordered",
        help="search engine to play both sides",
    )
    parser.add_argument(
        "--depth", type=_depth, default=UNSET, metavar="N",
        help="plies to search per move ('full' for exact to terminal); "
             "defaults to the engine's own default",
    )
    start = parser.add_mutually_exclusive_group()
    start.add_argument(
        "--start", choices=sorted(STARTS), default="early",
        help="named starting position",
    )
    start.add_argument(
        "--board-file", metavar="PATH",
        help="read the starting position from a text grid ('-' for stdin)",
    )
    parser.add_argument(
        "--to-move", choices=("black", "white"), default=None,
        help="side to move (overrides a board file's directive)",
    )
    parser.add_argument(
        "--list-engines", action="store_true",
        help="list available engines and exit",
    )
    return parser


def _load_board(args: argparse.Namespace) -> Board:
    to_move: Player = WHITE if args.to_move == "white" else BLACK
    if args.board_file:
        text = sys.stdin.read() if args.board_file == "-" else _read(args.board_file)
        board = parse_board(text, to_move=to_move)
        if args.to_move is not None:           # explicit flag wins over file/default
            board = Board(board.black, board.white, to_move)
        return board
    board = STARTS[args.start]()
    if args.to_move is not None:
        board = Board(board.black, board.white, to_move)
    return board


def _read(path: str) -> str:
    with open(path, encoding="utf-8") as f:
        return f.read()


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)

    if args.list_engines:
        for name in sorted(ENGINES):
            cls = ENGINES[name]
            print(f"{name:12} {cls.name:20} default depth {cls.default_depth}")
        return 0

    try:
        board = _load_board(args)
    except (OSError, ValueError) as e:
        print(f"error: {e}", file=sys.stderr)
        return 2

    engine = ENGINES[args.engine]()
    depth = engine.default_depth if args.depth is UNSET else args.depth
    play_game(board, engine, depth=depth)
    return 0
