#!/usr/bin/env python3
"""Text visualizations of exact winning lines in the odd-q residual cap game.

The board is the residual affine grid after the two fixed projective directions
have been played.  Values are exact normal-play values; validation recomputes
cap legality directly from determinants instead of using the solver line masks.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from collections import Counter
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path
from typing import Iterable

from gf import GF


INF = "inf"
ZERO = 0


def load_intrusion_census():
    path = Path(__file__).with_name("2026-07-08-intrusion-census.py")
    spec = importlib.util.spec_from_file_location("intrusion_census_c23", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    return mod


def mex(values: set[int]) -> int:
    g = 0
    while g in values:
        g += 1
    return g


def dawson_tables(maxn: int) -> tuple[list[int], list[int]]:
    gp = [0] * (maxn + 1)
    for n in range(1, maxn + 1):
        opts = set()
        for i in range(n):
            left = max(i - 1, 0)
            right = max(n - (i + 2), 0)
            opts.add(gp[left] ^ gp[right])
        gp[n] = mex(opts)
    gc = [0] * (maxn + 1)
    for n in range(3, maxn + 1):
        gc[n] = mex({gp[n - 3]})
    return gp, gc


@dataclass(frozen=True)
class Move:
    cell: int
    role: str


@dataclass
class Line:
    ident: str
    q: int
    seed_mask: int
    moves: list[Move]
    start_value: str
    note: str


class ResidualGridGame:
    def __init__(self, q: int):
        self.q = q
        self.F = GF(q)
        self.full_mask = (1 << (q * q)) - 1
        self.row_dir = (1, 0, 0)
        self.col_dir = (0, 1, 0)
        self.points = [self.row_dir, self.col_dir] + [
            (r, c, 1) for r in range(q) for c in range(q)
        ]
        self.line_masks = self._build_line_masks()
        self.conic_cell = {t: t * q + self.F.inv(t) for t in range(1, q)}
        self.cell_param = {v: k for k, v in self.conic_cell.items()}
        self.conic_mask = sum(1 << c for c in self.conic_cell.values())
        self.params: list[int | str] = [INF, ZERO] + list(range(1, q))
        self.conic_point: dict[int | str, tuple[int, int, int]] = {
            INF: self.row_dir,
            ZERO: self.col_dir,
        }
        self.conic_point.update({t: self.points[c + 2] for t, c in self.conic_cell.items()})
        self.gp, self.gc = dawson_tables(q + 3)

    def add(self, a: int, b: int) -> int:
        return self.F.add(a, b)

    def sub(self, a: int, b: int) -> int:
        return self.F.sub(a, b)

    def mul(self, a: int, b: int) -> int:
        return self.F.mul(a, b)

    def det(self, a: tuple[int, int, int], b: tuple[int, int, int],
            c: tuple[int, int, int]) -> int:
        f = self.F
        term0 = f.mul(a[0], f.sub(f.mul(b[1], c[2]), f.mul(b[2], c[1])))
        term1 = f.mul(a[1], f.sub(f.mul(b[0], c[2]), f.mul(b[2], c[0])))
        term2 = f.mul(a[2], f.sub(f.mul(b[0], c[1]), f.mul(b[1], c[0])))
        return f.add(f.sub(term0, term1), term2)

    def collinear(self, a: tuple[int, int, int], b: tuple[int, int, int],
                  c: tuple[int, int, int]) -> bool:
        return self.det(a, b, c) == 0

    def _build_line_masks(self) -> list[list[int]]:
        n = len(self.points)
        out = [[0] * n for _ in range(n)]
        affine = self.points[2:]
        for i in range(n):
            for j in range(i + 1, n):
                mask = 0
                pi, pj = self.points[i], self.points[j]
                for c, p in enumerate(affine):
                    if self.collinear(p, pi, pj):
                        mask |= 1 << c
                out[i][j] = mask
                out[j][i] = mask
        return out

    @staticmethod
    def iter_bits(mask: int) -> Iterable[tuple[int, int]]:
        while mask:
            bit = mask & -mask
            yield bit, bit.bit_length() - 1
            mask ^= bit

    def cell_tuple(self, c: int) -> tuple[int, int]:
        return divmod(c, self.q)

    def cell_name(self, c: int) -> str:
        r, col = self.cell_tuple(c)
        return f"({r},{col})"

    def bit_for_cell(self, cell: tuple[int, int]) -> int:
        return 1 << (cell[0] * self.q + cell[1])

    def is_conic_cell(self, c: int) -> bool:
        return c in self.cell_param

    def conic_mask_from_t4(self, t4: tuple[int, ...]) -> int:
        mask = 0
        for t in t4:
            mask |= 1 << self.conic_cell[t]
        return mask

    @lru_cache(maxsize=None)
    def legal_mask(self, mask: int) -> int:
        pts = [0, 1]
        for _bit, c in self.iter_bits(mask):
            pts.append(c + 2)
        forbidden = mask
        for i, pi in enumerate(pts):
            row = self.line_masks[pi]
            for pj in pts[i + 1:]:
                forbidden |= row[pj]
        return self.full_mask & ~forbidden

    @lru_cache(maxsize=None)
    def value(self, mask: int) -> bool:
        moves = self.legal_mask(mask)
        if moves == 0:
            return False
        for bit, _c in self.iter_bits(moves):
            if not self.value(mask | bit):
                return True
        return False

    def direct_cap(self, mask: int) -> bool:
        pts = [self.row_dir, self.col_dir]
        for _bit, c in self.iter_bits(mask):
            pts.append(self.points[c + 2])
        if len(pts) != len(set(pts)):
            return False
        for i in range(len(pts)):
            for j in range(i + 1, len(pts)):
                for k in range(j + 1, len(pts)):
                    if self.collinear(pts[i], pts[j], pts[k]):
                        return False
        return True

    def direct_legal_moves(self, mask: int) -> list[int]:
        out = []
        occupied = mask
        for c in range(self.q * self.q):
            bit = 1 << c
            if occupied & bit:
                continue
            if self.direct_cap(mask | bit):
                out.append(c)
        return out

    def sigma(self, xcell: int, s: int | str) -> int | str:
        x = self.points[xcell + 2]
        p = self.conic_point[s]
        hits = [t for t in self.params if self.collinear(x, p, self.conic_point[t])]
        if len(hits) == 1:
            return s
        assert len(hits) == 2 and s in hits, (self.q, xcell, s, hits)
        return hits[0] if hits[1] == s else hits[1]

    def sigma_perm(self, xcell: int) -> dict[int | str, int | str]:
        return {s: self.sigma(xcell, s) for s in self.params}

    def prod_order(self, a: dict[int | str, int | str], b: dict[int | str, int | str]) -> int:
        from math import gcd

        comp = {s: a[b[s]] for s in self.params}
        order = 1
        seen = set()
        for s in self.params:
            if s in seen:
                continue
            t = s
            n = 0
            while True:
                seen.add(t)
                t = comp[t]
                n += 1
                if t == s:
                    break
            order = order * n // gcd(order, n)
        return order

    @staticmethod
    def param_key(x: int | str) -> int:
        return 10**9 if x == INF else int(x)

    def spectrum(self, live: frozenset[int], sigmas: list[dict[int | str, int | str]]) \
            -> tuple[tuple[str, int], ...]:
        adj = {s: set() for s in live}
        for sg in sigmas:
            for s in live:
                t = sg[s]
                if t != s and t in live:
                    adj[s].add(t)
        comps = []
        seen = set()
        for s in sorted(live, key=self.param_key):
            if s in seen:
                continue
            stack = [s]
            comp = set()
            while stack:
                u = stack.pop()
                if u in comp:
                    continue
                comp.add(u)
                seen.add(u)
                stack.extend(adj[u] - comp)
            edges = sum(len(adj[u] & comp) for u in comp) // 2
            n = len(comp)
            if edges == n:
                comps.append(("cycle", n))
            elif edges == n - 1:
                comps.append(("path", n))
            else:
                comps.append(("bad", n))
        return tuple(sorted(comps))

    def dawson_xor(self, comps: tuple[tuple[str, int], ...]) -> int:
        out = 0
        for kind, n in comps:
            if kind == "path":
                out ^= self.gp[n]
            elif kind == "cycle":
                out ^= self.gc[n]
            else:
                out ^= 999999
        return out

    def zone_graph(self, mask: int) -> tuple[list[int], list[int], int]:
        zone = [c for _bit, c in self.iter_bits(self.legal_mask(mask) & ~self.conic_mask)]
        adj = [0] * len(zone)
        edges = 0
        for i, z in enumerate(zone):
            live_after = self.legal_mask(mask | (1 << z))
            for j in range(i + 1, len(zone)):
                w = zone[j]
                if not (live_after & (1 << w)):
                    adj[i] |= 1 << j
                    adj[j] |= 1 << i
                    edges += 1
        return zone, adj, edges

    def nk_grundy(self, adj: list[int]) -> int:
        n = len(adj)

        @lru_cache(maxsize=None)
        def g(mask: int) -> int:
            if mask == 0:
                return 0
            opts = set()
            bits = mask
            while bits:
                bit = bits & -bits
                i = bit.bit_length() - 1
                opts.add(g(mask & ~(bit | adj[i])))
                bits ^= bit
            return mex(opts)

        return g((1 << n) - 1)

    def state_features(self, mask: int) -> dict[str, object]:
        legal = self.legal_mask(mask)
        live = frozenset(t for t, c in self.conic_cell.items() if legal & (1 << c))
        intruders = [c for _bit, c in self.iter_bits(mask & ~self.conic_mask)]
        sigmas = [self.sigma_perm(c) for c in intruders]
        comps = self.spectrum(live, sigmas)
        zone, adj, edges = self.zone_graph(mask)
        return {
            "spectrum": comps,
            "defxor": self.dawson_xor(comps),
            "zone_size": len(zone),
            "zone_edges": edges,
            "zone_grundy": self.nk_grundy(adj),
        }


def choose_winning_move(game: ResidualGridGame, mask: int, prefer_intruder: bool = False) -> int:
    legal = [c for _bit, c in game.iter_bits(game.legal_mask(mask))]
    if prefer_intruder:
        legal.sort(key=lambda c: (game.is_conic_cell(c), c))
    for c in legal:
        if not game.value(mask | (1 << c)):
            return c
    raise RuntimeError(f"no winning move from q={game.q} mask={mask:x}")


def extend_from_p_position(game: ResidualGridGame, mask: int) -> list[Move]:
    assert not game.value(mask)
    moves: list[Move] = []
    while True:
        legal = [c for _bit, c in game.iter_bits(game.legal_mask(mask))]
        if not legal:
            return moves
        opp = legal[0]
        assert game.value(mask | (1 << opp))
        moves.append(Move(opp, "opp"))
        mask |= 1 << opp
        reply = choose_winning_move(game, mask)
        moves.append(Move(reply, "reply"))
        mask |= 1 << reply
        assert not game.value(mask)


def defense_line(game: ResidualGridGame) -> Line:
    assert not game.value(0)
    first = 0
    mask = 1 << first
    moves = [Move(first, "opp")]
    reply = choose_winning_move(game, mask)
    moves.append(Move(reply, "reply"))
    mask |= 1 << reply
    moves.extend(extend_from_p_position(game, mask))
    return Line(
        ident=f"defense-q{game.q}",
        q=game.q,
        seed_mask=0,
        moves=moves,
        start_value="P",
        note="Residual empty-grid defense; first move fixed to (0,0) by axis-affine symmetry.",
    )


def bucket_t4(bucket) -> tuple[int, ...]:
    return tuple(sorted(x for x in bucket.sample_six if x not in (INF, ZERO)))


def intrusion_line(game: ResidualGridGame, bucket, ident: str) -> Line:
    t4 = bucket_t4(bucket)
    seed = game.conic_mask_from_t4(t4)
    assert game.value(seed), (game.q, bucket)
    first = choose_winning_move(game, seed, prefer_intruder=True)
    if game.is_conic_cell(first):
        raise RuntimeError(f"{ident}: selected winning move is conic, not intrusion")
    mask = seed | (1 << first)
    moves = [Move(first, "win-intrusion")]
    moves.extend(extend_from_p_position(game, mask))
    return Line(
        ident=ident,
        q=game.q,
        seed_mask=seed,
        moves=moves,
        start_value="N",
        note=f"N on-conic bucket, sample_six={bucket.sample_six}, size={bucket.size}, cls={bucket.sample_cls}.",
    )


def validate_line(game: ResidualGridGame, line: Line) -> dict[str, object]:
    mask = line.seed_mask
    assert game.direct_cap(mask), line.ident
    assert ("N" if game.value(mask) else "P") == line.start_value, line.ident
    for mv in line.moves:
        bit = 1 << mv.cell
        assert not (mask & bit), (line.ident, mv)
        assert game.direct_cap(mask | bit), (line.ident, mv, game.cell_name(mv.cell))
        cached_legal = game.legal_mask(mask)
        direct_legal = sum(1 << c for c in game.direct_legal_moves(mask))
        assert cached_legal == direct_legal, (line.ident, mv)
        if mv.role in {"reply", "win-intrusion"}:
            assert game.value(mask), (line.ident, mv.role, game.cell_name(mv.cell))
            assert not game.value(mask | bit), (line.ident, mv.role, game.cell_name(mv.cell))
        elif mv.role == "opp":
            assert not game.value(mask), (line.ident, mv.role, game.cell_name(mv.cell))
            assert game.value(mask | bit), (line.ident, mv.role, game.cell_name(mv.cell))
        mask |= bit
    terminal_direct = game.direct_legal_moves(mask)
    assert game.legal_mask(mask) == 0, line.ident
    assert terminal_direct == [], line.ident
    assert not game.value(mask), line.ident
    return {
        "plies": len(line.moves),
        "terminal_size": mask.bit_count() + 2,
        "terminal_affine": mask.bit_count(),
        "terminal_maximal": True,
    }


def move_table(game: ResidualGridGame, line: Line) -> list[str]:
    rows = ["| ply | role | cell | value after |", "|---:|---|---|---|"]
    mask = line.seed_mask
    for i, mv in enumerate(line.moves, 1):
        mask |= 1 << mv.cell
        rows.append(
            f"| {i} | `{mv.role}` | `{game.cell_name(mv.cell)}` | "
            f"{'N' if game.value(mask) else 'P'} |"
        )
    return rows


def format_snapshot(game: ResidualGridGame, mask: int) -> str:
    f = game.state_features(mask)
    return (
        f"value={'N' if game.value(mask) else 'P'}; "
        f"spectrum={f['spectrum']}; defXOR={f['defxor']}; "
        f"zone={f['zone_size']} edges={f['zone_edges']} G={f['zone_grundy']}"
    )


def render_board(game: ResidualGridGame, mask: int, seed_mask: int,
                 move_numbers: dict[int, int]) -> str:
    legal = game.legal_mask(mask)
    lines = [
        f"infinity: row-dir=F col-dir=F     q={game.q}",
        "     " + " ".join(f"{c:>3}" for c in range(game.q)),
    ]
    for r in range(game.q):
        cells = []
        for c in range(game.q):
            idx = r * game.q + c
            bit = 1 << idx
            if idx in move_numbers:
                txt = f"{move_numbers[idx]:>3}"
            elif seed_mask & bit:
                txt = "  S"
            elif mask & bit:
                txt = "  ?"
            elif legal & bit:
                txt = "  ·" if game.is_conic_cell(idx) else "  z"
            else:
                txt = "  x"
            cells.append(txt)
        lines.append(f"{r:>3}: " + " ".join(cells))
    return "\n".join(lines)


def diagram_blocks(game: ResidualGridGame, line: Line) -> list[str]:
    blocks = []
    mask = line.seed_mask
    nums: dict[int, int] = {}
    blocks.append(
        f"initial: {format_snapshot(game, mask)}\n\n"
        f"```text\n{render_board(game, mask, line.seed_mask, nums)}\n```"
    )
    for i, mv in enumerate(line.moves, 1):
        mask |= 1 << mv.cell
        nums[mv.cell] = i
        if i % 2 == 0 or i == len(line.moves):
            blocks.append(
                f"after ply {i}: {format_snapshot(game, mask)}\n\n"
                f"```text\n{render_board(game, mask, line.seed_mask, nums)}\n```"
            )
    return blocks


def emit_markdown(lines: list[Line], validations: dict[str, dict[str, object]],
                  games: dict[int, ResidualGridGame]) -> str:
    out = [
        "# Odd-q Cap-Game Winning-Line Text Visualizations",
        "",
        "Generated by `notes/2026-07-08-cap-winline-viz.py`.",
        "",
        "Legend: `S` = seeded on-conic S4 cell, odd/even numbers are subsequent moves, "
        "`·` = currently legal standard-conic cell, `z` = currently legal off-conic intruder-zone cell, "
        "`x` = dead/cap-blocked cell.  The two fixed infinity directions are shown in the header.",
        "",
        "Validation gate: every move was replayed by a determinant-based cap checker, every terminal "
        "position was checked maximal, and exact solver values were checked at all strategic moves.",
        "",
        "## Summary",
        "",
        "| line | q | start | plies | terminal projective size | note |",
        "|---|---:|---|---:|---:|---|",
    ]
    for line in lines:
        v = validations[line.ident]
        out.append(
            f"| `{line.ident}` | {line.q} | {line.start_value} | {v['plies']} | "
            f"{v['terminal_size']} | {line.note} |"
        )
    defense = [line for line in lines if line.ident.startswith("defense-")]
    n_lines = [line for line in lines if "N-bucket" in line.ident]
    first_intrusions = [
        f"{line.ident}: `{games[line.q].cell_name(line.moves[0].cell)}`"
        for line in n_lines
    ]
    out.extend([
        "",
        "## First Observations",
        "",
        "- In every normalized residual defense line, the reply to `(0,0)` is `(1,1)`. "
        "For q >= 7 the next displayed reply is the row/column swap `(2,3) -> (3,2)`; "
        "q=5 is the small-board exception in this deterministic lexicographic line.",
        "- The q=9 and q=11 residual defenses both terminate after six affine plies, "
        "so the displayed defense is still a short pairing/repair pattern rather than a long search tail.",
        "- The N-bucket wins are visibly intrusion-led: "
        + ", ".join(first_intrusions) + ".",
        "- All displayed q=17 N-bucket lines finish at projective size 11 after five plies from the S4 root. "
        "The diagrams make the zone collapse easy to inspect against the C20 `defXOR` and zone-Grundy snapshots.",
        "",
        "## Lines",
        "",
    ])
    for line in lines:
        game = games[line.q]
        out.extend([
            f"### {line.ident}",
            "",
            line.note,
            "",
            *move_table(game, line),
            "",
        ])
        out.extend(diagram_blocks(game, line))
        out.append("")
    return "\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="notes/2026-07-08-codex-winline-viz.md")
    ap.add_argument("--feat11", default="notes/data/codex-feat11-c15.out")
    ap.add_argument("--feat17", default="notes/data/codex-feat17.out")
    ap.add_argument("--defense-qs", default="3,5,7,9,11")
    args = ap.parse_args()

    repo = Path(__file__).resolve().parents[1]
    out_path = Path(args.out)
    if not out_path.is_absolute():
        out_path = repo / out_path
    feat11 = Path(args.feat11)
    if not feat11.is_absolute():
        feat11 = repo / feat11
    feat17 = Path(args.feat17)
    if not feat17.is_absolute():
        feat17 = repo / feat17

    ic = load_intrusion_census()
    buckets = ic.parse_logs([str(feat11), str(feat17)])

    games: dict[int, ResidualGridGame] = {}

    def game(q: int) -> ResidualGridGame:
        if q not in games:
            games[q] = ResidualGridGame(q)
        return games[q]

    lines: list[Line] = []
    for q in [int(x) for x in args.defense_qs.split(",") if x]:
        lines.append(defense_line(game(q)))

    q11_n = [b for b in buckets if b.q == 11 and b.label == "N"]
    for i, b in enumerate(q11_n, 1):
        lines.append(intrusion_line(game(11), b, f"q11-N-bucket-{i}"))

    q17_n = [b for b in buckets if b.q == 17 and b.label == "N"]
    for i, b in enumerate(q17_n, 1):
        lines.append(intrusion_line(game(17), b, f"q17-N-bucket-{i}"))

    validations = {line.ident: validate_line(game(line.q), line) for line in lines}
    out_path.write_text(emit_markdown(lines, validations, games), encoding="utf-8")

    print(f"wrote {out_path}")
    print(json.dumps({
        "lines": len(lines),
        "by_q": Counter(line.q for line in lines),
        "validations": validations,
    }, indent=2, sort_keys=True, default=dict))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
