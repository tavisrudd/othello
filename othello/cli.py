"""Command-line entry point: `python -m othello [options]`.

Uses argparse (stdlib) to keep the package dependency-free.
"""
from __future__ import annotations
import argparse
import sys

from othello.core import Board, BLACK, WHITE, Player, parse_board
from othello.fixtures import STARTS
from othello.ai import ENGINES
from othello.play import play_game


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
        "--depth", type=_depth, default=6, metavar="N",
        help="plies to search per move ('full' for exact to terminal)",
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
            print(f"{name:12} {ENGINES[name]().name}")
        return 0

    try:
        board = _load_board(args)
    except (OSError, ValueError) as e:
        print(f"error: {e}", file=sys.stderr)
        return 2

    engine = ENGINES[args.engine]()
    play_game(board, engine, depth=args.depth)
    return 0
