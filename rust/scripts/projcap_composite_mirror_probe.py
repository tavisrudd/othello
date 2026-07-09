#!/usr/bin/env python3
"""C32 composite-mirror stuck-free probe for odd projective planes.

The plane policy tested here is the v2 C32 composite:

* choose an affine chart with line at infinity H;
* answer P1's first affine point with an affine seed pair, fixing the reflection
  center c and killing the seed pencil;
* mirror ordinary affine moves by point reflection through c;
* if P1 first plays on H, choose a legal H reply h';
* if P1 later enters one of the two poisoned pencils through c, answer with a
  legal affine point on the paired pencil, so both pencils die.

The verifier treats P1 choices universally and P2 policy choices existentially.
It checks ordinary projective cap legality independently by homogeneous
determinants, not by the residual grid solver.
"""

from __future__ import annotations

import argparse
import functools
import time
from dataclasses import dataclass
from typing import Iterable


class GF:
    def __init__(self, q: int):
        self.q = q
        self.p, self.poly = self._irred(q)
        self.k = len(self.poly) - 1
        self.add = [[0] * q for _ in range(q)]
        self.mul = [[0] * q for _ in range(q)]
        self.neg = [0] * q
        self.inv = [0] * q
        if self.k == 1:
            for a in range(q):
                for b in range(q):
                    self.add[a][b] = (a + b) % q
                    self.mul[a][b] = (a * b) % q
        else:
            for a in range(q):
                da = self._digits(a)
                for b in range(q):
                    db = self._digits(b)
                    s = [(da[i] + db[i]) % self.p for i in range(self.k)]
                    self.add[a][b] = self._undigits(s)
                    prod = [0] * (2 * self.k)
                    for i in range(self.k):
                        for j in range(self.k):
                            prod[i + j] = (prod[i + j] + da[i] * db[j]) % self.p
                    for deg in range(2 * self.k - 1, self.k - 1, -1):
                        coeff = prod[deg]
                        if coeff:
                            prod[deg] = 0
                            for i in range(self.k):
                                prod[deg - self.k + i] = (
                                    prod[deg - self.k + i] - coeff * self.poly[i]
                                ) % self.p
                    self.mul[a][b] = self._undigits(prod[: self.k])
        for a in range(q):
            for b in range(q):
                if self.add[a][b] == 0:
                    self.neg[a] = b
                if a and self.mul[a][b] == 1:
                    self.inv[a] = b
        for a in range(1, q):
            assert self.inv[a] != 0, (q, a)

    @staticmethod
    def _irred(q: int) -> tuple[int, list[int]]:
        if q in (3, 5, 7, 11, 13, 17, 19, 23):
            return q, [0, 1]
        if q == 9:
            return 3, [1, 0, 1]
        if q == 25:
            return 5, [3, 0, 1]
        raise ValueError(f"unsupported q={q}")

    def _digits(self, x: int) -> list[int]:
        d = [0] * self.k
        for i in range(self.k):
            d[i] = x % self.p
            x //= self.p
        return d

    def _undigits(self, d: Iterable[int]) -> int:
        x = 0
        for a in reversed(list(d)):
            x = x * self.p + (a % self.p)
        return x

    def a(self, x: int, y: int) -> int:
        return self.add[x][y]

    def n(self, x: int) -> int:
        return self.neg[x]

    def s(self, x: int, y: int) -> int:
        return self.add[x][self.neg[y]]

    def m(self, x: int, y: int) -> int:
        return self.mul[x][y]

    def div(self, x: int, y: int) -> int:
        assert y != 0
        return self.mul[x][self.inv[y]]


@dataclass(frozen=True)
class Move:
    role: str
    point: int
    reason: str


@dataclass(frozen=True)
class Failure:
    kind: str
    q: int
    seed: int
    state_mask: int
    p1_move: int | None
    trace: tuple[Move, ...]
    detail: str


class Plane:
    def __init__(self, q: int):
        self.q = q
        self.gf = GF(q)
        self.n_aff = q * q
        self.n_h = q + 1
        self.n = self.n_aff + self.n_h
        self.h_offset = self.n_aff
        self.points: list[tuple[int, int, int]] = []
        self.h_vecs: list[tuple[int, int]] = []
        self.h_index: dict[tuple[int, int], int] = {}
        for r in range(q):
            for c in range(q):
                self.points.append((r, c, 1))
        for s in range(q):
            self._add_h_point((1, s))
        self._add_h_point((0, 1))
        self.line_masks = [[0] * self.n for _ in range(self.n)]
        for i in range(self.n):
            for j in range(self.n):
                if i == j:
                    continue
                mask = 0
                for k in range(self.n):
                    if self.collinear(i, j, k):
                        mask |= 1 << k
                self.line_masks[i][j] = mask
        self.all_mask = (1 << self.n) - 1
        self.h_mask = ((1 << self.n_h) - 1) << self.h_offset
        self.aff_mask = (1 << self.n_aff) - 1

    def selfcheck(self) -> None:
        lines = {}
        point_line_count = [0] * self.n
        for i in range(self.n):
            for j in range(i + 1, self.n):
                mask = self.line_masks[i][j]
                lines[mask] = True
        for mask in lines:
            assert mask.bit_count() == self.q + 1, (self.q, mask.bit_count(), self.q + 1)
            for p in self.bits(mask):
                point_line_count[p] += 1
        assert len(lines) == self.n, (self.q, len(lines), self.n)
        assert all(c == self.q + 1 for c in point_line_count), (self.q, sorted(set(point_line_count)))
        mismatches = 0
        for i in range(self.n):
            for j in range(i + 1, self.n):
                line = self.cross_line(self.points[i], self.points[j])
                for k in range(j + 1, self.n):
                    via_line = self.dot_line(line, self.points[k]) == 0
                    if via_line != self.collinear(i, j, k):
                        mismatches += 1
        assert mismatches == 0, (self.q, mismatches)
        print(
            f"CHECK plane q={self.q} lines={len(lines)} line_size={self.q + 1} "
            f"point_line_count={self.q + 1} det_vs_line_mismatches=0"
        )

    def _add_h_point(self, v: tuple[int, int]) -> None:
        norm = self.norm_dir(*v)
        self.h_index[norm] = len(self.h_vecs)
        self.h_vecs.append(norm)
        self.points.append((norm[0], norm[1], 0))

    def norm_dir(self, dr: int, dc: int) -> tuple[int, int]:
        gf = self.gf
        assert dr != 0 or dc != 0
        if dr != 0:
            inv = gf.inv[dr]
            return 1, gf.m(dc, inv)
        inv = gf.inv[dc]
        return 0, gf.m(dc, inv)

    def aff(self, r: int, c: int) -> int:
        return r * self.q + c

    def is_h(self, p: int) -> bool:
        return p >= self.h_offset

    def h_local(self, p: int) -> int:
        assert self.is_h(p)
        return p - self.h_offset

    def h_point(self, h: int) -> int:
        return self.h_offset + h

    def aff_rc(self, p: int) -> tuple[int, int]:
        assert not self.is_h(p)
        return p // self.q, p % self.q

    def det3(self, a: tuple[int, int, int], b: tuple[int, int, int], c: tuple[int, int, int]) -> int:
        gf = self.gf
        a1, a2, a3 = a
        b1, b2, b3 = b
        c1, c2, c3 = c
        t1 = gf.m(a1, gf.s(gf.m(b2, c3), gf.m(b3, c2)))
        t2 = gf.m(a2, gf.s(gf.m(b1, c3), gf.m(b3, c1)))
        t3 = gf.m(a3, gf.s(gf.m(b1, c2), gf.m(b2, c1)))
        return gf.a(gf.s(t1, t2), t3)

    def cross_line(self, a: tuple[int, int, int], b: tuple[int, int, int]) -> tuple[int, int, int]:
        gf = self.gf
        a1, a2, a3 = a
        b1, b2, b3 = b
        return (
            gf.s(gf.m(a2, b3), gf.m(a3, b2)),
            gf.s(gf.m(a3, b1), gf.m(a1, b3)),
            gf.s(gf.m(a1, b2), gf.m(a2, b1)),
        )

    def dot_line(self, line: tuple[int, int, int], point: tuple[int, int, int]) -> int:
        gf = self.gf
        return gf.a(gf.a(gf.m(line[0], point[0]), gf.m(line[1], point[1])), gf.m(line[2], point[2]))

    def collinear(self, i: int, j: int, k: int) -> bool:
        if i == j or i == k or j == k:
            return True
        return self.det3(self.points[i], self.points[j], self.points[k]) == 0

    def legal_moves(self, mask: int) -> tuple[int, ...]:
        forbidden = mask
        pts = self.bits(mask)
        for ai, i in enumerate(pts):
            for j in pts[ai + 1 :]:
                forbidden |= self.line_masks[i][j]
        return tuple(self.bits(self.all_mask & ~forbidden))

    def is_legal_move(self, mask: int, p: int) -> bool:
        if (mask >> p) & 1:
            return False
        pts = self.bits(mask)
        for ai, i in enumerate(pts):
            for j in pts[ai + 1 :]:
                if (self.line_masks[i][j] >> p) & 1:
                    return False
        return True

    @staticmethod
    def bits(mask: int) -> list[int]:
        out = []
        while mask:
            b = mask & -mask
            out.append(b.bit_length() - 1)
            mask ^= b
        return out

    def sigma(self, center: tuple[int, int], p: int) -> int:
        assert not self.is_h(p)
        gf = self.gf
        r, c = self.aff_rc(p)
        return self.aff(gf.s(gf.a(center[0], center[0]), r), gf.s(gf.a(center[1], center[1]), c))

    def direction_from_center(self, center: tuple[int, int], p: int) -> int | None:
        assert not self.is_h(p)
        gf = self.gf
        r, c = self.aff_rc(p)
        dr = gf.s(r, center[0])
        dc = gf.s(c, center[1])
        if dr == 0 and dc == 0:
            return None
        return self.h_index[self.norm_dir(dr, dc)]

    def point_on_pencil(self, center: tuple[int, int], h: int, t: int) -> int:
        gf = self.gf
        dr, dc = self.h_vecs[h]
        return self.aff(gf.a(center[0], gf.m(t, dr)), gf.a(center[1], gf.m(t, dc)))

    def pencil_points(self, center: tuple[int, int], h: int) -> list[int]:
        return [self.point_on_pencil(center, h, t) for t in range(self.q)]

    def fmt(self, p: int) -> str:
        if self.is_h(p):
            a, b = self.h_vecs[p - self.h_offset]
            return f"H({a}:{b})"
        r, c = self.aff_rc(p)
        return f"A({r},{c})"

    def fmt_mask(self, mask: int) -> str:
        return "{" + ", ".join(self.fmt(p) for p in self.bits(mask)) + "}"


class PlanePolicyVerifier:
    def __init__(self, plane: Plane, node_cap: int, trace_limit: int):
        self.plane = plane
        self.node_cap = node_cap
        self.trace_limit = trace_limit
        self.nodes = 0
        self.memo: dict[tuple[int, tuple[int, int] | None], bool] = {}
        self.fail_memo: dict[tuple[int, tuple[int, int] | None], Failure] = {}
        self.obstructions: dict[str, int] = {}

    def record_obstruction(self, kind: str) -> None:
        self.obstructions[kind] = self.obstructions.get(kind, 0) + 1

    def verify_seed(self, seed: int) -> tuple[bool, Failure | None]:
        p = self.plane
        first = p.aff(0, 0)
        y = seed
        assert not p.is_h(y)
        if y == first or not p.is_legal_move(1 << first, y):
            fail = Failure("bad_seed", p.q, seed, 1 << first, first, (), "seed reply is illegal")
            return False, fail
        mask = (1 << first) | (1 << y)
        ok = self._win(
            mask,
            None,
            (Move("P1", first, "normalized first affine move"), Move("P2", y, "seed reply")),
            seed,
        )
        return ok, None if ok else self.fail_memo.get((mask, None))

    def _win(
        self,
        mask: int,
        h_pair: tuple[int, int] | None,
        trace: tuple[Move, ...],
        seed: int,
    ) -> bool:
        key = (mask, h_pair)
        if key in self.memo:
            return self.memo[key]
        self.nodes += 1
        if self.nodes > self.node_cap:
            fail = Failure("node_cap", self.plane.q, seed, mask, None, trace, f"node cap {self.node_cap} hit")
            self.fail_memo[key] = fail
            self.memo[key] = False
            return False

        p = self.plane
        legal = p.legal_moves(mask)
        if not legal:
            self.memo[key] = True
            return True

        for x in legal:
            replies = self.policy_replies(mask, h_pair, x)
            if not replies:
                kind, detail = self.no_reply_kind(mask, h_pair, x)
                self.record_obstruction(kind)
                fail_trace = self.extend_trace(trace, Move("P1", x, "unanswered legal move"))
                fail = Failure(kind, p.q, seed, mask, x, fail_trace, detail)
                self.fail_memo[key] = fail
                self.memo[key] = False
                return False
            branch_ok = False
            branch_fail: Failure | None = None
            for y, nh_pair, reason in replies:
                nmask = mask | (1 << x) | (1 << y)
                ntrace = self.extend_trace(
                    trace,
                    Move("P1", x, self.p1_reason(h_pair, x)),
                    Move("P2", y, reason),
                )
                if self._win(nmask, nh_pair, ntrace, seed):
                    branch_ok = True
                    break
                branch_fail = self.fail_memo.get((nmask, nh_pair))
            if not branch_ok:
                kind = "future_forced_failure"
                self.record_obstruction(kind)
                if branch_fail is None:
                    branch_fail = Failure(kind, p.q, seed, mask, x, trace, "all policy replies lead to failure")
                self.fail_memo[key] = branch_fail
                self.memo[key] = False
                return False

        self.memo[key] = True
        return True

    def extend_trace(self, trace: tuple[Move, ...], *moves: Move) -> tuple[Move, ...]:
        if len(trace) >= self.trace_limit:
            return trace
        room = self.trace_limit - len(trace)
        return trace + moves[:room]

    def selected_h_pair_from_mask(self, mask: int) -> tuple[int, ...]:
        p = self.plane
        return tuple(pnt - p.h_offset for pnt in p.bits(mask & p.h_mask))

    def p1_reason(self, h_pair: tuple[int, int] | None, x: int) -> str:
        p = self.plane
        if p.is_h(x):
            return "line-at-infinity move"
        if h_pair is not None:
            d = p.direction_from_center(self.center, x)
            if d in h_pair:
                return "enters poisoned pencil"
        return "bulk affine move"

    @functools.cached_property
    def center(self) -> tuple[int, int]:
        raise RuntimeError("center property is rebound per seed")

    def set_center(self, center: tuple[int, int]) -> None:
        self.__dict__["center"] = center

    def no_reply_kind(self, mask: int, h_pair: tuple[int, int] | None, x: int) -> tuple[str, str]:
        p = self.plane
        if p.is_h(x):
            legal_h = [h for h in range(p.n_h) if p.is_legal_move(mask | (1 << x), p.h_point(h))]
            return "h_reply_nonexistence", f"no legal H reply; legal_h_after_x={len(legal_h)}"
        d = p.direction_from_center(self.center, x)
        if d is None:
            return "center_move", "center was legal"
        if h_pair is not None and d in h_pair:
            other = h_pair[1] if d == h_pair[0] else h_pair[0]
            candidates = [
                z for z in p.pencil_points(self.center, other)
                if p.is_legal_move(mask | (1 << x), z)
            ]
            return "exception_cell_nonexistence", f"paired pencil has {len(candidates)} legal replies"
        y = p.sigma(self.center, x)
        return "bulk_reply_illegal", f"sigma(x)={p.fmt(y)} is not legal"

    def policy_replies(
        self,
        mask: int,
        h_pair: tuple[int, int] | None,
        x: int,
    ) -> list[tuple[int, tuple[int, int] | None, str]]:
        p = self.plane
        after_x = mask | (1 << x)
        if p.is_h(x):
            if h_pair is not None:
                return []
            xh = p.h_local(x)
            out = []
            for yh in range(p.n_h):
                y = p.h_point(yh)
                if yh != xh and p.is_legal_move(after_x, y):
                    pair = (xh, yh) if xh < yh else (yh, xh)
                    out.append((y, pair, "adaptive H reply"))
            return out

        d = p.direction_from_center(self.center, x)
        if d is None:
            return []
        if h_pair is not None and d in h_pair:
            other = h_pair[1] if d == h_pair[0] else h_pair[0]
            out = []
            for y in p.pencil_points(self.center, other):
                if y != x and p.is_legal_move(after_x, y):
                    out.append((y, h_pair, "double-pencil exception reply"))
            return out

        y = p.sigma(self.center, x)
        if y != x and p.is_legal_move(after_x, y):
            return [(y, h_pair, "bulk reflection reply")]
        return []


def run_plane(q: int, seed_limit: int, node_cap: int, trace_limit: int, seed_log: str) -> None:
    start = time.time()
    p = Plane(q)
    p.selfcheck()
    first = p.aff(0, 0)
    seeds = [z for z in p.legal_moves(1 << first) if not p.is_h(z)]
    if seed_limit:
        seeds = seeds[:seed_limit]
    print(f"PLANE q={q} points={p.n} affine={p.n_aff} H={p.n_h} seeds={len(seeds)}")
    best_fail: Failure | None = None
    total_nodes = 0
    for si, seed in enumerate(seeds):
        gf = p.gf
        sr, sc = p.aff_rc(seed)
        inv2 = gf.inv[2]
        center = (gf.m(sr, inv2), gf.m(sc, inv2))
        verifier = PlanePolicyVerifier(p, node_cap=node_cap, trace_limit=trace_limit)
        verifier.set_center(center)
        ok, fail = verifier.verify_seed(seed)
        total_nodes += verifier.nodes
        obs = " ".join(f"{k}:{v}" for k, v in sorted(verifier.obstructions.items())) or "-"
        if seed_log == "all" or (seed_log == "fail" and not ok):
            print(
                f"SEED q={q} idx={si} y={p.fmt(seed)} center=A({center[0]},{center[1]}) "
                f"ok={int(ok)} nodes={verifier.nodes} memo={len(verifier.memo)} obs={obs}"
            )
        if ok:
            print(
                f"RESULT plane q={q} STUCK_FREE seed={p.fmt(seed)} center=A({center[0]},{center[1]}) "
                f"nodes={verifier.nodes} elapsed={time.time() - start:.3f}s"
            )
            return
        if best_fail is None and fail is not None:
            best_fail = fail
    print(
        f"RESULT plane q={q} NO_STUCK_FREE_SEED tested={len(seeds)} nodes={total_nodes} "
        f"elapsed={time.time() - start:.3f}s"
    )
    if best_fail is not None:
        print_failure(p, best_fail)


class PG43:
    """Minimal PG(4,3) model for the fixed-rho seed-obstruction check."""

    def __init__(self):
        self.q = 3
        self.gf = GF(3)
        self.dim = 4
        self.n_aff = 3 ** 4
        self.h_vecs: list[tuple[int, int, int, int]] = []
        self.h_index: dict[tuple[int, int, int, int], int] = {}
        for raw in range(1, 3 ** 4):
            v = self._digits4(raw)
            nv = self.norm(v)
            if nv not in self.h_index:
                self.h_index[nv] = len(self.h_vecs)
                self.h_vecs.append(nv)
        self.n_h = len(self.h_vecs)
        self.n = self.n_aff + self.n_h
        self.h_offset = self.n_aff
        assert self.n_h == 40
        assert self.n == 121

    def _digits4(self, x: int) -> tuple[int, int, int, int]:
        out = []
        for _ in range(4):
            out.append(x % 3)
            x //= 3
        return tuple(out)  # type: ignore[return-value]

    def _undigits4(self, v: tuple[int, int, int, int]) -> int:
        x = 0
        for a in reversed(v):
            x = x * 3 + a
        return x

    def norm(self, v: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
        gf = self.gf
        for a in v:
            if a != 0:
                inv = gf.inv[a]
                return tuple(gf.m(x, inv) for x in v)  # type: ignore[return-value]
        raise ValueError("zero vector")

    def point_vec(self, p: int) -> tuple[int, int, int, int, int]:
        if p < self.n_aff:
            return (*self._digits4(p), 1)
        return (*self.h_vecs[p - self.h_offset], 0)

    def h_point(self, h: int) -> int:
        return self.h_offset + h

    def rho_h(self, h: int) -> int:
        # C25 elliptic block over F3 with nonsquare d=2:
        # (a,b,c,d) -> (2b,a,2d,c), projectivized.
        gf = self.gf
        a, b, c, d = self.h_vecs[h]
        v = (gf.m(2, b), a, gf.m(2, d), c)
        return self.h_index[self.norm(v)]

    def direction_from_center(self, center: tuple[int, int, int, int], p: int) -> int:
        gf = self.gf
        x = self._digits4(p)
        v = tuple(gf.s(x[i], center[i]) for i in range(4))  # type: ignore[return-value]
        return self.h_index[self.norm(v)]

    def rank(self, rows: list[list[int]]) -> int:
        gf = self.gf
        rows = [r[:] for r in rows if any(r)]
        rank = 0
        col = 0
        while rank < len(rows) and col < len(rows[0]):
            piv = next((r for r in range(rank, len(rows)) if rows[r][col] != 0), None)
            if piv is None:
                col += 1
                continue
            rows[rank], rows[piv] = rows[piv], rows[rank]
            inv = gf.inv[rows[rank][col]]
            rows[rank] = [gf.m(x, inv) for x in rows[rank]]
            for r in range(len(rows)):
                if r == rank or rows[r][col] == 0:
                    continue
                coeff = rows[r][col]
                rows[r] = [gf.s(rows[r][i], gf.m(coeff, rows[rank][i])) for i in range(len(rows[r]))]
            rank += 1
            col += 1
        return rank

    def collinear(self, a: int, b: int, c: int) -> bool:
        return self.rank([list(self.point_vec(a)), list(self.point_vec(b)), list(self.point_vec(c))]) <= 2

    def is_legal_move(self, mask: int, p: int) -> bool:
        if (mask >> p) & 1:
            return False
        pts = Plane.bits(mask)
        for ai, i in enumerate(pts):
            for j in pts[ai + 1 :]:
                if self.collinear(i, j, p):
                    return False
        return True

    def fmt(self, p: int) -> str:
        if p < self.n_aff:
            return f"A{self._digits4(p)}"
        return f"H{self.h_vecs[p - self.h_offset]}"


def run_pg43_seed_obstruction(seed_limit: int) -> None:
    pg = PG43()
    first = 0
    seeds = [s for s in range(1, pg.n_aff)]
    if seed_limit:
        seeds = seeds[:seed_limit]
    failures = 0
    examples = []
    gf = pg.gf
    inv2 = gf.inv[2]
    for seed in seeds:
        sv = pg._digits4(seed)
        center = tuple(gf.m(x, inv2) for x in sv)  # type: ignore[assignment]
        h0 = pg.direction_from_center(center, first)
        h_pre = pg.rho_h(h0)  # rho is an involution, so this is rho^{-1}(h0).
        mask = (1 << first) | (1 << seed)
        p1 = pg.h_point(h_pre)
        reply = pg.h_point(h0)
        p1_legal = pg.is_legal_move(mask, p1)
        reply_legal = pg.is_legal_move(mask | (1 << p1), reply)
        if p1_legal and not reply_legal:
            failures += 1
            if len(examples) < 3:
                examples.append((seed, center, p1, reply))
    print(
        f"PG43_SEED_OBSTRUCTION seeds={len(seeds)} failures={failures} "
        f"points={pg.n} affine={pg.n_aff} H={pg.n_h}"
    )
    for i, (seed, center, p1, reply) in enumerate(examples):
        print(
            f"PG43_FAIL_EXAMPLE {i} seed={pg.fmt(seed)} center=A{center} "
            f"P1={pg.fmt(p1)} rho_reply={pg.fmt(reply)}"
        )


def print_failure(p: Plane, fail: Failure) -> None:
    print(
        f"FAIL q={fail.q} kind={fail.kind} seed={p.fmt(fail.seed)} "
        f"state={p.fmt_mask(fail.state_mask)} detail={fail.detail}"
    )
    if fail.p1_move is not None:
        print(f"FAIL_P1 {p.fmt(fail.p1_move)}")
    for i, mv in enumerate(fail.trace, 1):
        print(f"TRACE {i:02d} {mv.role} {p.fmt(mv.point)}  # {mv.reason}")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--plane", type=int, action="append", default=[])
    ap.add_argument("--no-plane", action="store_true")
    ap.add_argument("--pg43-seed", action="store_true")
    ap.add_argument("--seed-limit", type=int, default=0)
    ap.add_argument("--seed-log", choices=["all", "fail", "none"], default="all")
    ap.add_argument("--node-cap", type=int, default=5_000_000)
    ap.add_argument("--trace-limit", type=int, default=40)
    args = ap.parse_args()
    if not args.no_plane:
        qs = args.plane or [9, 11, 13]
        for q in qs:
            run_plane(q, args.seed_limit, args.node_cap, args.trace_limit, args.seed_log)
    if args.pg43_seed:
        run_pg43_seed_obstruction(args.seed_limit)


if __name__ == "__main__":
    main()
