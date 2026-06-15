"""Test suite for the Othello engine and black-centered minimax.

Run with:  uvx pytest    (or:  pytest)
"""
from __future__ import annotations
import random
import subprocess
import sys

import pytest  # ty: ignore[unresolved-import]  # test-only dep, not in `ty` env

import othello as o
from othello import (
    Board, BLACK, WHITE, PASS,
    parse_square_name, format_square, square_to_move, move_to_square, format_move,
    format_score,
    iter_moves, iter_actions, minimax_value, minimax_scores, minimax,
    init_early_game,
    init_near_terminal_game_black_win,
    init_near_terminal_game_white_win,
    init_near_terminal_game_either_can_win,
    winner,
)

ENDGAME_FIXTURES = [
    init_near_terminal_game_black_win,
    init_near_terminal_game_white_win,
    init_near_terminal_game_either_can_win,
]


# --------------------------------------------------------------------------- #
# Independent reference move generation / flips (grid arithmetic, no bitboards)
# --------------------------------------------------------------------------- #

DIRS = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]


def _grid(bm: int) -> set[tuple[int, int]]:
    return {(s // 8, s % 8) for s in range(64) if (bm >> s) & 1}


def ref_legal(player: int, opp: int) -> set[tuple[int, int]]:
    P, O = _grid(player), _grid(opp)
    occ = P | O
    moves: set[tuple[int, int]] = set()
    for r in range(8):
        for c in range(8):
            if (r, c) in occ:
                continue
            for dr, dc in DIRS:
                rr, cc, seen = r + dr, c + dc, 0
                while 0 <= rr < 8 and 0 <= cc < 8 and (rr, cc) in O:
                    rr += dr; cc += dc; seen += 1
                if seen and 0 <= rr < 8 and 0 <= cc < 8 and (rr, cc) in P:
                    moves.add((r, c))
                    break
    return moves


def ref_flips(sq: int, player: int, opp: int) -> set[tuple[int, int]]:
    r, c = sq // 8, sq % 8
    P, O = _grid(player), _grid(opp)
    flips: set[tuple[int, int]] = set()
    for dr, dc in DIRS:
        rr, cc, run = r + dr, c + dc, []
        while 0 <= rr < 8 and 0 <= cc < 8 and (rr, cc) in O:
            run.append((rr, cc)); rr += dr; cc += dc
        if run and 0 <= rr < 8 and 0 <= cc < 8 and (rr, cc) in P:
            flips |= set(run)
    return flips


def random_positions(games: int, seed: int):
    """Yield every position reached by `games` random self-play games."""
    rng = random.Random(seed)
    for _ in range(games):
        b = init_early_game()
        while not b.is_terminal():
            yield b
            b = b.make_move(rng.choice(list(iter_actions(b))))
        yield b


def nocache_value(state, depth):
    """Reference minimax independent of the cache, for cross-checking."""
    if state.is_terminal():
        return state.utility(BLACK)
    if depth is not None and depth <= 0:
        return state.utility(BLACK)
    child = depth if depth is None else depth - 1
    vals = [nocache_value(state._make_move_unchecked(m), child)
            for m in iter_actions(state)]
    return max(vals) if state.to_move == BLACK else min(vals)


# --------------------------------------------------------------------------- #
# Coordinates
# --------------------------------------------------------------------------- #

def test_square_roundtrip():
    for sq in range(64):
        assert parse_square_name(format_square(sq)) == sq


@pytest.mark.parametrize("name,sq", [("A1", 0), ("H1", 7), ("A8", 56), ("H8", 63), ("D5", 35)])
def test_square_names(name, sq):
    assert parse_square_name(name) == sq
    assert format_square(sq) == name


def test_parse_move_case_and_pass():
    assert o.parse_move("PASS") == PASS
    assert o.parse_move(" pass ") == PASS
    assert o.parse_move("d3") == o.parse_move("D3") == square_to_move("D3")


def test_move_square_roundtrip():
    for sq in range(64):
        assert move_to_square(1 << sq) == sq
        assert format_move(1 << sq) == format_square(sq)


@pytest.mark.parametrize("bad", ["", "Z1", "A9", "AA", "12"])
def test_parse_square_name_rejects_garbage(bad):
    with pytest.raises(ValueError):
        parse_square_name(bad)


@pytest.mark.parametrize("score,text", [
    (6, "B:+6"), (1, "B:+1"), (-4, "W:-4"), (-40, "W:-40"), (0, "T:0"),
])
def test_format_score_winner_prefix(score, text):
    assert format_score(score) == text


# --------------------------------------------------------------------------- #
# Opening / move application
# --------------------------------------------------------------------------- #

def test_opening_legal_moves():
    b = init_early_game()
    assert b.to_move == BLACK
    names = {format_move(m) for m in iter_moves(b.actions())}
    assert names == {"C4", "D3", "E6", "F5"}


def test_make_move_flips_and_turn():
    b = init_early_game()
    nb = b + "D3"
    assert nb.to_move == WHITE
    assert nb.black.bit_count() == 4 and nb.white.bit_count() == 1
    assert nb.black & square_to_move("D4")        # captured disc flipped
    assert not nb.white & square_to_move("D4")
    assert (nb.black & nb.white) == 0             # no overlap


def test_make_move_rejects_illegal_and_nonhot():
    b = init_early_game()
    with pytest.raises(ValueError):
        b.make_move(square_to_move("A1"))         # not a legal move
    with pytest.raises(ValueError):
        b.make_move(square_to_move("C4") | square_to_move("D3"))  # not one-hot


def test_make_move_unchecked_matches_make_move():
    n = 0
    for b in random_positions(games=60, seed=1):
        if b.is_terminal():
            continue
        for m in iter_actions(b):
            assert b.make_move(m) == b._make_move_unchecked(m)
            n += 1
    assert n > 1000


# --------------------------------------------------------------------------- #
# Pass handling
# --------------------------------------------------------------------------- #

def _find_forced_pass_position():
    for b in random_positions(games=200, seed=7):
        if not b.is_terminal() and b.actions() == 0:
            return b
    pytest.skip("no forced-pass position sampled")


def test_pass_only_when_no_moves():
    b = init_early_game()
    with pytest.raises(ValueError):
        b.make_move(PASS)                         # moves exist -> cannot pass


def test_forced_pass_flips_turn_only():
    b = _find_forced_pass_position()
    nb = b.make_move(PASS)
    assert nb.to_move != b.to_move
    assert nb.black == b.black and nb.white == b.white
    assert PASS in set(iter_actions(b))


# --------------------------------------------------------------------------- #
# Reference equivalence: legal moves + flips
# --------------------------------------------------------------------------- #

def test_legal_moves_and_flips_match_reference():
    n = 0
    for b in random_positions(games=80, seed=3):
        player, opp = (b.black, b.white) if b.to_move == BLACK else (b.white, b.black)
        got = _grid(b.actions())
        assert got == ref_legal(player, opp)
        for sq in range(64):
            if (b.actions() >> sq) & 1:
                got_flips = _grid(Board._flips_for_move(1 << sq, player, opp))
                assert got_flips == ref_flips(sq, player, opp)
        n += 1
    assert n > 1000


# --------------------------------------------------------------------------- #
# Utility (disc-differential)
# --------------------------------------------------------------------------- #

def test_utility_sign_and_magnitude_at_terminal():
    for b in random_positions(games=120, seed=5):
        if not b.is_terminal():
            continue
        u = b.utility(BLACK)
        w = winner(b)
        assert (u > 0) == (w == BLACK)
        assert (u < 0) == (w == WHITE)
        assert (u == 0) == (w is None)
        assert abs(u) == abs(b.black.bit_count() - b.white.bit_count())


def test_utility_is_player_relative():
    b = init_near_terminal_game_white_win()
    # after fully searching, the value is black-centered; raw terminal counts:
    term = b
    # walk a deterministic full game to a terminal via minimax to compare signs
    while not term.is_terminal():
        term = term.make_move(minimax(term))
    assert term.utility(BLACK) == -term.utility(WHITE)


# --------------------------------------------------------------------------- #
# Minimax + depth-aware cache
# --------------------------------------------------------------------------- #

@pytest.mark.parametrize("init,expected", [
    (init_near_terminal_game_black_win, 6),
    (init_near_terminal_game_white_win, -40),
    (init_near_terminal_game_either_can_win, 4),
])
def test_full_search_values(init, expected):
    assert minimax_value(init(), {}, None) == expected


def test_minimax_value_matches_nocache_endgame_all_depths():
    for init in ENDGAME_FIXTURES:
        b = init()
        for depth in [None, 0, 1, 2, 3, 4, 6]:
            assert minimax_value(b, {}, depth) == nocache_value(b, depth)


def test_minimax_value_matches_nocache_midgame_finite_depths():
    b = init_early_game() + "D3" + "C3"          # full search here is infeasible
    for depth in [0, 1, 2, 3, 4]:
        assert minimax_value(b, {}, depth) == nocache_value(b, depth)


def test_shared_cache_is_depth_isolated():
    # One cache reused across different depths must never return a value
    # computed for a different horizon.
    b = init_early_game() + "D3"
    shared: o.Cache = {}
    for depth in [2, 4, 1, 3, 2, 4]:
        assert minimax_value(b, shared, depth) == nocache_value(b, depth)


def test_depth_none_is_default():
    b = init_near_terminal_game_either_can_win() + "F8"
    assert minimax_value(b, {}, None) == minimax_value(b, {})


def test_minimax_chooses_extreme_for_side_to_move():
    for init in ENDGAME_FIXTURES:
        b = init()
        cache: o.Cache = {}
        scored = minimax_scores(b, cache)
        best = minimax(b, cache)
        best_score = dict(scored)[best]
        if b.to_move == BLACK:
            assert best_score == max(s for _, s in scored)
        else:
            assert best_score == min(s for _, s in scored)


def test_minimax_on_terminal_raises():
    b = init_near_terminal_game_white_win()
    while not b.is_terminal():
        b = b.make_move(minimax(b))
    with pytest.raises(ValueError):
        minimax(b)
    with pytest.raises(ValueError):
        minimax_scores(b)


# --------------------------------------------------------------------------- #
# Import is side-effect free (main() guarded)
# --------------------------------------------------------------------------- #

def test_import_has_no_side_effects():
    out = subprocess.run(
        [sys.executable, "-c", "import othello"],
        cwd=__import__("os").path.dirname(__file__),
        capture_output=True, text=True,
    )
    assert out.returncode == 0
    assert out.stdout == ""
