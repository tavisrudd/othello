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
    parse_board, format_score,
    iter_moves, iter_actions, best_by_side,
    Minimax, AlphaBeta, AlphaBetaOrdered,
    CythonAlphaBeta, CythonAlphaBetaOrdered,
    MIN_SCORE, MAX_SCORE,
    init_early_game,
    init_near_terminal_game_black_win,
    init_near_terminal_game_white_win,
    init_near_terminal_game_either_can_win,
    winner,
)
from othello.ai.evaluation import utility, heuristic

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
    """Plain minimax, no cache and no pruning -- the ground truth oracle.

    Mirrors the engines' leaf order: horizon (heuristic) is checked before
    terminal (exact utility)."""
    if depth is not None and depth <= 0:
        return heuristic(state, BLACK)
    if state.is_terminal():
        return utility(state, BLACK)
    child = depth if depth is None else depth - 1
    vals = [nocache_value(state._make_move_unchecked(m), child)
            for m in iter_actions(state)]
    return max(vals) if state.to_move == BLACK else min(vals)


def sample_positions(n: int, seed: int):
    """A spread of distinct non-terminal positions from random self-play."""
    out, seen = [], set()
    for i, b in enumerate(random_positions(games=50, seed=seed)):
        if b.is_terminal() or b.cache_key in seen or i % 3:
            continue
        seen.add(b.cache_key)
        out.append(b)
        if len(out) >= n:
            break
    return out


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


def test_movegen_matches_reference_on_random_boards():
    # Arbitrary disjoint bitboards stress every edge-wrap case -- validates
    # whichever kernels are active (the compiled extension when built, else the
    # pure-Python fallback) against the independent grid reference.
    rng = random.Random(99)
    for _ in range(1500):
        player = rng.getrandbits(64)
        opp = rng.getrandbits(64) & ~player & 0xFFFFFFFFFFFFFFFF
        player &= 0xFFFFFFFFFFFFFFFF
        legal = Board._legal_moves(player, opp)
        assert _grid(legal) == ref_legal(player, opp)
        for sq in range(64):
            if (legal >> sq) & 1:
                assert _grid(Board._flips_for_move(1 << sq, player, opp)) == \
                    ref_flips(sq, player, opp)


# --------------------------------------------------------------------------- #
# Utility (disc-differential)
# --------------------------------------------------------------------------- #

def test_utility_sign_and_magnitude_at_terminal():
    for b in random_positions(games=120, seed=5):
        if not b.is_terminal():
            continue
        u = utility(b, BLACK)
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
    engine = AlphaBeta()
    while not term.is_terminal():
        term = term.make_move(engine.best_move(term))
    assert utility(term, BLACK) == -utility(term, WHITE)


# --------------------------------------------------------------------------- #
# Engines: minimax + depth-aware cache
# --------------------------------------------------------------------------- #

ENGINES = [Minimax, AlphaBeta, AlphaBetaOrdered,
           CythonAlphaBeta, CythonAlphaBetaOrdered]


@pytest.mark.parametrize("Engine", ENGINES)
@pytest.mark.parametrize("init,expected", [
    (init_near_terminal_game_black_win, 6),
    (init_near_terminal_game_white_win, -40),
    (init_near_terminal_game_either_can_win, 4),
])
def test_full_search_values(Engine, init, expected):
    assert Engine().value(init(), None) == expected


@pytest.mark.parametrize("Engine", ENGINES)
def test_value_matches_nocache_endgame_all_depths(Engine):
    for init in ENDGAME_FIXTURES:
        b = init()
        for depth in [None, 0, 1, 2, 3, 4, 6]:
            assert Engine().value(b, depth) == nocache_value(b, depth)


@pytest.mark.parametrize("Engine", ENGINES)
def test_value_matches_nocache_midgame_finite_depths(Engine):
    b = init_early_game() + "D3" + "C3"          # full search here is infeasible
    for depth in [0, 1, 2, 3, 4]:
        assert Engine().value(b, depth) == nocache_value(b, depth)


@pytest.mark.parametrize("Engine", ENGINES)
def test_engine_cache_is_depth_isolated(Engine):
    # One engine (one shared cache) reused across different depths must never
    # return a value computed for a different horizon.
    b = init_early_game() + "D3"
    engine = Engine()
    for depth in [2, 4, 1, 3, 2, 4]:
        assert engine.value(b, depth) == nocache_value(b, depth)


@pytest.mark.parametrize("Engine", ENGINES)
def test_depth_none_is_default(Engine):
    b = init_near_terminal_game_either_can_win() + "F8"
    assert Engine().value(b, None) == Engine().value(b)


@pytest.mark.parametrize("Engine", ENGINES)
def test_best_move_is_extreme_for_side_to_move(Engine):
    for init in ENDGAME_FIXTURES:
        b = init()
        engine = Engine()
        scored = engine.scores(b)
        best_score = dict(scored)[engine.best_move(b)]
        if b.to_move == BLACK:
            assert best_score == max(s for _, s in scored)
        else:
            assert best_score == min(s for _, s in scored)
        assert engine.best_move(b) == best_by_side(b, scored)


@pytest.mark.parametrize("Engine", ENGINES)
def test_engine_on_terminal_raises(Engine):
    b = init_near_terminal_game_white_win()
    engine = Engine()
    while not b.is_terminal():
        b = b.make_move(engine.best_move(b))
    with pytest.raises(ValueError):
        engine.best_move(b)
    with pytest.raises(ValueError):
        engine.scores(b)


def test_engines_agree_on_values():
    # All engines must compute identical values everywhere (pruning and move
    # ordering change only how many nodes are visited, never the value).
    for b in sample_positions(20, seed=21):
        for depth in [1, 2, 3, 4]:
            ref = Minimax().value(b, depth)
            assert AlphaBeta().value(b, depth) == ref
            assert AlphaBetaOrdered().value(b, depth) == ref


# --------------------------------------------------------------------------- #
# Alpha-beta pruning + bound-tracking transposition table
# --------------------------------------------------------------------------- #

def test_alpha_beta_equals_brute_force():
    # Full-window alpha-beta must reproduce plain minimax exactly, on a spread
    # of midgame positions at several depths.
    for b in sample_positions(30, seed=11):
        for depth in [1, 2, 3, 4]:
            assert AlphaBeta().value(b, depth) == nocache_value(b, depth)


def test_in_window_result_is_exact():
    # Any value strictly inside the search window is the exact minimax value.
    for b in sample_positions(20, seed=12):
        for depth in [2, 3]:
            v = nocache_value(b, depth)
            assert AlphaBeta().value(b, depth, v - 1, v + 1) == v
            assert AlphaBeta().value(b, depth, MIN_SCORE, MAX_SCORE) == v


def test_out_of_window_returns_valid_bound():
    # Window above the value -> fail-low -> upper bound (v <= r <= alpha).
    # Window below the value -> fail-high -> lower bound (beta <= r <= v).
    for b in sample_positions(20, seed=13):
        for depth in [2, 3]:
            v = nocache_value(b, depth)
            r_low = AlphaBeta().value(b, depth, v + 1, v + 5)
            assert v <= r_low <= v + 1
            r_high = AlphaBeta().value(b, depth, v - 5, v - 1)
            assert v - 1 <= r_high <= v


def test_bound_entries_do_not_corrupt_exact_queries():
    # The crux of TT + alpha-beta soundness: cache entries left behind by
    # narrow-window searches (which store LOWER/UPPER bounds) must never make a
    # later exact query return a wrong value. One engine == one shared cache.
    for b in sample_positions(20, seed=14):
        for depth in [2, 3]:
            v = nocache_value(b, depth)
            engine = AlphaBeta()
            for a, bb in [(-5, 5), (0, 1), (-50, -40), (v, v + 1), (v - 1, v)]:
                engine.value(b, depth, a, bb)
            assert engine.value(b, depth) == v
            # per-move scores on the polluted cache stay exact too
            for move, score in engine.scores(b, depth):
                assert score == nocache_value(b._make_move_unchecked(move),
                                              depth - 1)


def test_alpha_beta_explores_fewer_nodes_than_plain_minimax(monkeypatch):
    b = init_early_game() + "D3" + "C5"
    depth = 4

    brute_nodes = 0
    def brute(s, d):
        nonlocal brute_nodes
        brute_nodes += 1
        if d is not None and d <= 0:
            return heuristic(s, BLACK)
        if s.is_terminal():
            return utility(s, BLACK)
        cd = d if d is None else d - 1
        vals = [brute(s._make_move_unchecked(m), cd) for m in iter_actions(s)]
        return max(vals) if s.to_move == BLACK else min(vals)
    expected = brute(b, depth)

    engine = AlphaBeta()
    ab_nodes = 0
    real = engine.value
    def counting(*a, **k):
        nonlocal ab_nodes
        ab_nodes += 1
        return real(*a, **k)
    monkeypatch.setattr(engine, "value", counting)   # recursion hits the counter
    got = engine.value(b, depth)
    assert got == expected
    assert ab_nodes < brute_nodes             # pruning + TT visit strictly fewer


def _count_value_nodes(engine, board, depth, monkeypatch):
    nodes = 0
    real = engine.value
    def counting(*a, **k):
        nonlocal nodes
        nodes += 1
        return real(*a, **k)
    monkeypatch.setattr(engine, "value", counting)
    value = engine.value(board, depth)
    return value, nodes


def test_move_ordering_explores_fewer_nodes(monkeypatch):
    b = init_early_game() + "D3" + "C5" + "F6"
    depth = 6
    plain_v, plain_n = _count_value_nodes(AlphaBeta(), b, depth, monkeypatch)
    ord_v, ord_n = _count_value_nodes(AlphaBetaOrdered(), b, depth, monkeypatch)
    assert plain_v == ord_v                   # ordering never changes the value
    assert ord_n < plain_n                    # but reaches it with fewer nodes


def test_native_search_matches_python():
    # Direct check of the compiled search (both order modes) against the Python
    # AlphaBeta. Skipped when the extension isn't built (then the cython engines
    # are exercised through their pure-Python fallback by the ENGINES tests).
    search = pytest.importorskip("othello._search").search
    for b in sample_positions(25, seed=31):
        ref_engine = AlphaBeta()
        for depth in [1, 2, 3, 4, 5]:
            ref = ref_engine.value(b, depth)
            for order in (0, 1):
                assert search(b.black, b.white, b.to_move, depth, {}, order) == ref


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


# --------------------------------------------------------------------------- #
# Board text parsing
# --------------------------------------------------------------------------- #

OPENING_GRID = "\n".join([
    "........",
    "........",
    "........",
    "...BW...",
    "...WB...",
    "........",
    "........",
    "........",
])


def test_parse_board_round_trips_opening():
    assert parse_board(OPENING_GRID) == init_early_game()


def test_parse_board_to_move_default_and_directive():
    empty = "\n".join(["." * 8] * 8)
    assert parse_board(empty).to_move == BLACK
    assert parse_board(empty, to_move=WHITE).to_move == WHITE
    assert parse_board(empty + "\nto_move: white").to_move == WHITE


def test_parse_board_ignores_comments_and_spaces():
    spaced = "# a comment\n" + "\n".join(["B X . . . . . W"] + ["." * 8] * 7)
    b = parse_board(spaced)
    assert b.black & square_to_move("A8") and b.white & square_to_move("H8")


@pytest.mark.parametrize("bad", [
    "\n".join(["." * 8] * 7),                       # 7 rows
    "\n".join(["." * 7] * 8),                       # 7 columns
    "\n".join(["Z" + "." * 7] + ["." * 8] * 7),     # unknown cell
])
def test_parse_board_rejects_malformed(bad):
    with pytest.raises(ValueError):
        parse_board(bad)


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #

def test_cli_parses_core_options():
    args = othello_cli().parse_args(
        ["--engine", "minimax", "--depth", "4", "--start", "either"])
    assert (args.engine, args.depth, args.start) == ("minimax", 4, "either")


def test_cli_depth_full_is_none():
    assert othello_cli().parse_args(["--depth", "full"]).depth is None


def test_cli_depth_defaults_to_engine_when_omitted():
    from othello.cli import UNSET
    from othello.ai import ENGINES
    for name, expected in [("minimax", 4), ("alphabeta", 6), ("ordered", 6)]:
        args = othello_cli().parse_args(["--engine", name])
        assert args.depth is UNSET                       # CLI didn't set it
        resolved = ENGINES[name].default_depth if args.depth is UNSET else args.depth
        assert resolved == expected


def test_cli_start_and_board_file_are_exclusive():
    with pytest.raises(SystemExit):
        othello_cli().parse_args(["--start", "early", "--board-file", "x"])


def test_cli_list_engines(capsys):
    from othello.cli import main
    assert main(["--list-engines"]) == 0
    out = capsys.readouterr().out
    assert "minimax" in out and "ordered" in out


def test_cli_bad_board_file_exits_2():
    from othello.cli import main
    assert main(["--board-file", "/no/such/path/xyz"]) == 2


def test_cli_runs_a_game(capsys):
    from othello.cli import main
    assert main(["--start", "either", "--depth", "2"]) == 0   # near-terminal: fast
    assert "winner:" in capsys.readouterr().out


def test_cli_to_move_overrides_board_file(tmp_path):
    from othello.cli import build_parser, _load_board
    p = tmp_path / "board.txt"
    p.write_text(OPENING_GRID + "\nto_move: black\n")
    args = build_parser().parse_args(["--board-file", str(p), "--to-move", "white"])
    assert _load_board(args).to_move == WHITE


def othello_cli():
    from othello.cli import build_parser
    return build_parser()
