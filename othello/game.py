"""The generic game interface that AI engines consume.

Defines the `GameState` protocol every engine searches over, move iteration,
the black-centered move-choice rule, and the `Engine` base class.
"""
from __future__ import annotations
from abc import ABC, abstractmethod
from typing import Protocol, Iterator
from collections.abc import Hashable

from othello.core import Player, Move, Moves, Bitmap, Score, PASS, BLACK

type Depth = int | None          # remaining plies to search; None = to terminal
type MoveScores = list[tuple[Move, Score]]
type CacheKey = tuple[Hashable, Depth]


class GameState(Protocol):
    to_move: Player
    def actions(self) -> Moves: ...
    def make_move(self, move: Move) -> GameState: ...
    def _make_move_unchecked(self, move: Move) -> GameState: ...
    def is_terminal(self) -> bool: ...
    def utility(self, player: Player) -> Score: ...

    @property
    def cache_key(self) -> Hashable: ...


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

def child_depth(depth: Depth) -> Depth:
    return depth if depth is None else depth - 1

def best_by_side(state: GameState, scores: MoveScores) -> Move:
    # Scores are black-centered: BLACK maximises, WHITE minimises.
    if state.to_move == BLACK:
        return max(scores, key=lambda x: x[1])[0]
    return min(scores, key=lambda x: x[1])[0]


class Engine(ABC):
    """An AI that scores the legal moves of a state (black-centered)."""
    name: str = "engine"

    @abstractmethod
    def scores(self, state: GameState, depth: Depth = None) -> MoveScores:
        """Per-move black-centered scores; raises on a terminal state."""
        ...

    def best_move(self, state: GameState, depth: Depth = None) -> Move:
        if state.is_terminal():
            raise ValueError(f"{self.name}: no move from terminal state")
        return best_by_side(state, self.scores(state, depth))

    def reset(self) -> None:
        """Drop any cached search state. Override if the engine caches."""
