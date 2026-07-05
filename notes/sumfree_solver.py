#!/usr/bin/env python3
"""Outcome solver for the sum-free achievement game on finite abelian groups.

Groups are products Z_m1 x ... x Z_mk, written additively.  A position A is a
bitmask over group elements.  The legality cache for a sum-free A is:

  S(A) = {a+b : a,b in A}
  D(A) = {a-b : a,b in A}
  T(A) = {x : 2x in A}

Then x is legal iff x is nonzero and x not in A | S(A) | D(A) | T(A).
The implementation validates this condition against a brute Schur-triple scan.

Canonicalization is deliberately conservative.  Every key is either the raw
position or the minimum over an explicitly generated subgroup of genuine group
automorphisms.  Smaller subgroups only reduce fewer states; they never merge
inequivalent positions.
"""

from __future__ import annotations

import argparse
import math
import random
import resource
import sys
import time
from itertools import product
from typing import Iterable, List, Optional, Sequence, Tuple


sys.setrecursionlimit(1 << 22)


Mask = int
Perm = Tuple[int, ...]


def set_mem_limit_mb(mb: Optional[int]) -> None:
    if not mb:
        return
    lim = int(mb) * 1024 * 1024
    resource.setrlimit(resource.RLIMIT_AS, (lim, lim))


def mask_bits(mask: Mask) -> Iterable[int]:
    while mask:
        bit = mask & -mask
        yield bit.bit_length() - 1
        mask ^= bit


class Group:
    def __init__(self, mods: Sequence[int]):
        if not mods or any(m <= 1 for m in mods):
            raise ValueError("mods must be a nonempty list of integers > 1")
        self.mods = tuple(int(m) for m in mods)
        self.elems = list(product(*[range(m) for m in self.mods]))
        self.idx = {e: i for i, e in enumerate(self.elems)}
        self.N = len(self.elems)
        self.zero = self.idx[tuple(0 for _ in self.mods)]
        self.pow2 = [1 << i for i in range(self.N)]

        self.add: List[List[int]] = [
            [
                self.idx[
                    tuple((a + b) % m for a, b, m in zip(self.elems[i], self.elems[j], self.mods))
                ]
                for j in range(self.N)
            ]
            for i in range(self.N)
        ]
        self.neg = [
            self.idx[tuple((-a) % m for a, m in zip(e, self.mods))]
            for e in self.elems
        ]
        self.dbl = [self.add[i][i] for i in range(self.N)]
        self.dblpre = [0] * self.N
        for z, dz in enumerate(self.dbl):
            self.dblpre[dz] |= self.pow2[z]

    def label(self, i: int) -> str:
        return str(self.elems[i])

    def index_of(self, coords: Sequence[int]) -> int:
        return self.idx[tuple(coords)]

    def is_pure_f3(self) -> bool:
        return all(m == 3 for m in self.mods)

    def is_z2_x_f3(self) -> bool:
        return self.mods[0] == 2 and all(m == 3 for m in self.mods[1:])

    def f3_positions(self) -> List[int]:
        if self.is_pure_f3():
            return list(range(len(self.mods)))
        if self.is_z2_x_f3():
            return list(range(1, len(self.mods)))
        return [i for i, m in enumerate(self.mods) if m == 3]

    def gl_matrix_to_perm(self, matrix: Sequence[Sequence[int]], f3_pos: Sequence[int]) -> Perm:
        n = len(f3_pos)
        perm = [0] * self.N
        for i, e in enumerate(self.elems):
            v = [e[p] for p in f3_pos]
            w = [sum(matrix[r][c] * v[c] for c in range(n)) % 3 for r in range(n)]
            out = list(e)
            for k, p in enumerate(f3_pos):
                out[p] = w[k]
            perm[i] = self.idx[tuple(out)]
        return tuple(perm)

    def gl_generators(self, f3_pos: Sequence[int]) -> List[Perm]:
        n = len(f3_pos)
        if n == 0:
            return []
        ident = [[1 if r == c else 0 for c in range(n)] for r in range(n)]
        gens = []
        for i in range(n):
            for j in range(n):
                if i == j:
                    continue
                m = [row[:] for row in ident]
                m[i][j] = 1
                gens.append(self.gl_matrix_to_perm(m, f3_pos))
        d = [row[:] for row in ident]
        d[0][0] = 2
        gens.append(self.gl_matrix_to_perm(d, f3_pos))
        return gens

    def monomial_generators(self, f3_pos: Sequence[int]) -> List[Perm]:
        n = len(f3_pos)
        if n == 0:
            return []
        ident = [[1 if r == c else 0 for c in range(n)] for r in range(n)]
        gens = []
        for i in range(n - 1):
            m = [row[:] for row in ident]
            m[i][i] = m[i + 1][i + 1] = 0
            m[i][i + 1] = m[i + 1][i] = 1
            gens.append(self.gl_matrix_to_perm(m, f3_pos))
        d = [row[:] for row in ident]
        d[0][0] = 2
        gens.append(self.gl_matrix_to_perm(d, f3_pos))
        return gens

    def cyclic_unit_generators(self) -> List[Perm]:
        if len(self.mods) != 1:
            raise ValueError("cyclic_unit_generators needs a cyclic group")
        (m,) = self.mods
        gens = []
        for u in range(2, m):
            if math.gcd(u, m) == 1:
                gens.append(tuple(self.idx[((u * self.elems[i][0]) % m,)] for i in range(self.N)))
        return gens

    def coordinate_subgroup_generators(self) -> List[Perm]:
        """Sound automorphism subgroup for any product: coordinate units + equal-factor swaps."""
        gens: List[Perm] = []
        k = len(self.mods)

        for p, m in enumerate(self.mods):
            for u in range(2, m):
                if math.gcd(u, m) != 1:
                    continue
                perm = []
                for e in self.elems:
                    out = list(e)
                    out[p] = (u * out[p]) % m
                    perm.append(self.idx[tuple(out)])
                gens.append(tuple(perm))

        for i in range(k):
            for j in range(i + 1, k):
                if self.mods[i] != self.mods[j]:
                    continue
                perm = []
                for e in self.elems:
                    out = list(e)
                    out[i], out[j] = out[j], out[i]
                    perm.append(self.idx[tuple(out)])
                gens.append(tuple(perm))
        return gens

    def verify_automorphism(self, perm: Perm) -> None:
        if len(perm) != self.N or sorted(perm) != list(range(self.N)):
            raise ValueError("not a permutation")
        if perm[self.zero] != self.zero:
            raise ValueError("automorphism candidate does not fix zero")
        for i in range(self.N):
            ai = self.add[i]
            pai = self.add[perm[i]]
            for j in range(self.N):
                if perm[ai[j]] != pai[perm[j]]:
                    raise ValueError("automorphism candidate does not preserve addition")


def compose(h: Perm, g: Perm) -> Perm:
    return tuple(h[g[i]] for i in range(len(g)))


def close_group(gens: Sequence[Perm], n: int, cap: int) -> Optional[List[Perm]]:
    ident = tuple(range(n))
    if not gens:
        return [ident]
    seen = {ident}
    elems = [ident]
    frontier = [ident]
    while frontier:
        new_frontier = []
        for g in frontier:
            for h in gens:
                c = compose(h, g)
                if c in seen:
                    continue
                seen.add(c)
                elems.append(c)
                new_frontier.append(c)
                if len(elems) > cap:
                    return None
        frontier = new_frontier
    return elems


def build_canonical_group(group: Group, mode: str, cap: int) -> Tuple[Optional[List[Perm]], str]:
    if mode == "none":
        return None, "none"

    if mode == "auto":
        if group.is_pure_f3():
            dim = len(group.f3_positions())
            mode = "full" if dim <= 3 else "monomial"
        elif group.is_z2_x_f3():
            dim = len(group.f3_positions())
            mode = "full" if dim <= 2 else "monomial"
        elif len(group.mods) == 1:
            mode = "full"
        else:
            mode = "coord"

    if mode == "full":
        if group.is_pure_f3() or group.is_z2_x_f3():
            gens = group.gl_generators(group.f3_positions())
            label = "GL-on-F3-part"
        elif len(group.mods) == 1:
            gens = group.cyclic_unit_generators()
            label = "cyclic-units"
        else:
            gens = group.coordinate_subgroup_generators()
            label = "coordinate-subgroup"
    elif mode == "monomial":
        if not (group.is_pure_f3() or group.is_z2_x_f3()):
            raise ValueError("monomial mode is only implemented for F3^b and Z2 x F3^b")
        gens = group.monomial_generators(group.f3_positions())
        label = "monomial-F3-subgroup"
    elif mode == "coord":
        gens = group.coordinate_subgroup_generators()
        label = "coordinate-subgroup"
    else:
        raise ValueError(f"unknown canonicalization mode {mode!r}")

    for p in gens:
        group.verify_automorphism(p)
    closed = close_group(gens, group.N, cap)
    if closed is None:
        raise MemoryError(f"automorphism subgroup exceeded cap={cap}; use auto/monomial/coord/none")
    return closed, label


class Solver:
    def __init__(
        self,
        group: Group,
        canon_group: Optional[Sequence[Perm]] = None,
        restrict: Optional[Iterable[int]] = None,
        canon_max_size: int = 0,
        progress: int = 0,
    ):
        self.g = group
        self.N = group.N
        self.add = group.add
        self.pow2 = group.pow2
        self.canon_group = list(canon_group) if canon_group is not None else None
        self.canon_max_size = canon_max_size
        self.progress = progress
        self.nodes = 0
        self.t0 = time.time()
        self.last_progress = 0
        self.tt = {}

        allowed = set(restrict) if restrict is not None else None
        self.ground_mask = 0
        for i in range(self.N):
            if i != group.zero and (allowed is None or i in allowed):
                self.ground_mask |= self.pow2[i]

    def sumfree_mask(self, mask: Mask) -> bool:
        bits = list(mask_bits(mask))
        for a in bits:
            aa = self.add[a]
            for b in bits:
                if mask & self.pow2[aa[b]]:
                    return False
        return True

    def compute_state(self, members: Sequence[int]) -> Tuple[Mask, Tuple[int, ...], Mask, Mask, Mask]:
        amask = 0
        for x in members:
            if x < 0 or x >= self.N:
                raise ValueError(f"bad element index {x}")
            if amask & self.pow2[x]:
                raise ValueError(f"duplicate start element {self.g.label(x)}")
            amask |= self.pow2[x]
        if not self.sumfree_mask(amask):
            raise ValueError("starting position is not sum-free")

        s = d = t = 0
        for a in members:
            t |= self.g.dblpre[a]
            for b in members:
                s |= self.pow2[self.add[a][b]]
                d |= self.pow2[self.add[a][self.g.neg[b]]]
        return amask, tuple(members), s, d, t

    def legal_mask(self, amask: Mask, s: Mask, d: Mask, t: Mask) -> Mask:
        return self.ground_mask & ~(amask | s | d | t)

    def brute_legal_mask(self, amask: Mask) -> Mask:
        out = 0
        for x in mask_bits(self.ground_mask & ~amask):
            if self.sumfree_mask(amask | self.pow2[x]):
                out |= self.pow2[x]
        return out

    def child_state(
        self,
        amask: Mask,
        members: Tuple[int, ...],
        s: Mask,
        d: Mask,
        t: Mask,
        x: int,
    ) -> Tuple[Mask, Tuple[int, ...], Mask, Mask, Mask]:
        camask = amask | self.pow2[x]
        cs = s | self.pow2[self.g.dbl[x]]
        cd = d
        ct = t | self.g.dblpre[x]
        addx = self.add[x]
        negx = self.g.neg[x]
        subx = self.add[negx]
        for a in members:
            cs |= self.pow2[addx[a]]
            da = subx[a]  # a - x
            cd |= self.pow2[da] | self.pow2[self.g.neg[da]]
        return camask, members + (x,), cs, cd, ct

    def canon(self, amask: Mask, members: Tuple[int, ...]) -> Mask:
        if self.canon_group is None:
            return amask
        if self.canon_max_size and len(members) > self.canon_max_size:
            return amask
        best = amask
        for perm in self.canon_group:
            img = 0
            for a in members:
                img |= self.pow2[perm[a]]
            if img < best:
                best = img
        return best

    def ordered_children(
        self,
        amask: Mask,
        members: Tuple[int, ...],
        s: Mask,
        d: Mask,
        t: Mask,
        moves: Mask,
    ):
        children = []
        for x in mask_bits(moves):
            camask, cmembers, cs, cd, ct = self.child_state(amask, members, s, d, t, x)
            cmoves = self.legal_mask(camask, cs, cd, ct)
            children.append((cmoves.bit_count(), x, camask, cmembers, cs, cd, ct, cmoves))
        children.sort(key=lambda row: (row[0], row[1]))
        return children

    def maybe_progress(self, depth: int) -> None:
        if not self.progress or self.nodes - self.last_progress < self.progress:
            return
        self.last_progress = self.nodes
        rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
        print(
            f"  ..nodes={self.nodes:>10} tt={len(self.tt):>9} depth={depth:>3} "
            f"rss={rss}MB time={time.time() - self.t0:8.1f}s",
            flush=True,
        )

    def win(
        self,
        amask: Mask,
        members: Tuple[int, ...],
        s: Mask,
        d: Mask,
        t: Mask,
        moves: Mask,
        depth: int,
    ) -> bool:
        self.nodes += 1
        self.maybe_progress(depth)

        key = self.canon(amask, members)
        cached = self.tt.get(key)
        if cached is not None:
            return cached

        for _, _x, camask, cmembers, cs, cd, ct, cmoves in self.ordered_children(
            amask, members, s, d, t, moves
        ):
            if cmoves == 0:
                self.tt[key] = True
                return True
            if not self.win(camask, cmembers, cs, cd, ct, cmoves, depth + 1):
                self.tt[key] = True
                return True

        self.tt[key] = False
        return False

    def root_representatives(self, moves: Mask, start_empty: bool) -> List[int]:
        if not start_empty:
            return list(mask_bits(moves))

        # Known full-automorphism first-move orbits.  These shortcuts are only
        # used from the empty position, where the whole automorphism group acts.
        if self.g.is_pure_f3():
            return [next(mask_bits(moves))]

        if self.g.is_z2_x_f3():
            reps = []
            zero_v = (0,) * (len(self.g.mods) - 1)
            candidates = [
                (1,) + zero_v,
                (0,) + (1,) + (0,) * (len(self.g.mods) - 2),
                (1,) + (1,) + (0,) * (len(self.g.mods) - 2),
            ]
            for c in candidates:
                i = self.g.idx[c]
                if moves & self.pow2[i]:
                    reps.append(i)
            return reps

        if self.canon_group is None:
            return list(mask_bits(moves))

        unseen = set(mask_bits(moves))
        reps = []
        while unseen:
            x = min(unseen)
            reps.append(x)
            orbit = {p[x] for p in self.canon_group}
            unseen.difference_update(orbit)
        return reps

    def solve(self, start: Sequence[int] = ()) -> Tuple[str, Optional[int]]:
        amask, members, s, d, t = self.compute_state(tuple(start))
        moves = self.legal_mask(amask, s, d, t)
        if moves != self.brute_legal_mask(amask):
            raise AssertionError("incremental legal mask disagrees with brute scan at start")
        if moves == 0:
            return "P", None

        reps = self.root_representatives(moves, start_empty=(amask == 0))
        for _cnt, x, camask, cmembers, cs, cd, ct, cmoves in self.ordered_children(
            amask, members, s, d, t, sum(self.pow2[x] for x in reps)
        ):
            if cmoves == 0:
                return "N", x
            if not self.win(camask, cmembers, cs, cd, ct, cmoves, len(members) + 1):
                return "N", x
        return "P", None


def parse_mods(text: str) -> Tuple[int, ...]:
    return tuple(int(x) for x in text.replace("x", ",").split(",") if x)


def parse_start(group: Group, text: str) -> Tuple[int, ...]:
    if not text:
        return ()
    out = []
    for part in text.split(";"):
        coords = tuple(int(x) for x in part.strip().split(",") if x != "")
        if len(coords) != len(group.mods):
            raise ValueError(f"start element {part!r} has wrong dimension")
        out.append(group.idx[coords])
    return tuple(out)


def legality_selftest() -> None:
    cases = [(3,), (4,), (5,), (2, 2), (2, 3), (3, 3), (2, 3, 3)]
    for mods in cases:
        g = Group(mods)
        s = Solver(g)
        total = 0
        if g.N <= 10:
            masks = range(1 << g.N)
        else:
            rng = random.Random(12345 + g.N)
            masks = [rng.randrange(1 << g.N) for _ in range(5000)]
        for mask in masks:
            if not s.sumfree_mask(mask):
                continue
            members = tuple(mask_bits(mask))
            amask, mem, ss, dd, tt = s.compute_state(members)
            got = s.legal_mask(amask, ss, dd, tt)
            want = s.brute_legal_mask(amask)
            if got != want:
                raise AssertionError(f"legal mask mismatch for {mods} mask={mask}")
            total += 1
        print(f"  legality {mods}: checked {total} sum-free positions")


def outcome_gate(mem_mb: int, progress: int = 0) -> None:
    expected = [
        ((3, 3), "N"),
        ((3, 3, 3), "N"),
        ((2, 3, 3), "P"),
        ((2, 3, 3, 3), "P"),
        ((5,), "P"),
        ((6,), "P"),
        ((7,), "P"),
        ((8,), "N"),
        ((9,), "N"),
        ((10,), "N"),
        ((11,), "P"),
        ((2, 2), "P"),
        ((4, 4), "P"),
    ]
    ok = True
    for mods, want in expected:
        g = Group(mods)
        cg, label = build_canonical_group(g, "auto", cap=200_000)
        sv = Solver(g, cg, progress=progress)
        got, first = sv.solve()
        rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
        ok &= got == want
        first_label = "-" if first is None else g.label(first)
        print(
            f"  {'x'.join(map(str, mods)):10s} want={want} got={got} "
            f"first={first_label:12s} canon={label:20s} group={0 if cg is None else len(cg):6d} "
            f"nodes={sv.nodes:8d} tt={len(sv.tt):8d} rss={rss:4d}MB"
        )
    if not ok:
        raise SystemExit("OUTCOME_GATE_FAILED")
    print(f"OUTCOME_GATE_OK under requested cap {mem_mb}MB")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("mods", nargs="?", help="moduli, e.g. 3,3,3 or 2,3,3,3")
    ap.add_argument("--canon", default="auto", choices=["auto", "full", "monomial", "coord", "none"])
    ap.add_argument("--canon-cap", type=int, default=200_000)
    ap.add_argument("--canon-max-size", type=int, default=0)
    ap.add_argument("--start", default="", help="semicolon-separated coords, e.g. '1,0,0;0,1,0'")
    ap.add_argument("--mem-mb", type=int, default=0)
    ap.add_argument("--progress", type=int, default=0)
    ap.add_argument("--selftest", action="store_true")
    ap.add_argument("--gate", action="store_true")
    args = ap.parse_args()

    set_mem_limit_mb(args.mem_mb)

    if args.selftest:
        legality_selftest()
    if args.gate:
        outcome_gate(args.mem_mb or 0, args.progress)
    if args.selftest or args.gate:
        return
    if not args.mods:
        ap.error("mods are required unless --selftest or --gate is used")

    mods = parse_mods(args.mods)
    g = Group(mods)
    cg, label = build_canonical_group(g, args.canon, args.canon_cap)
    start = parse_start(g, args.start)
    sv = Solver(g, cg, canon_max_size=args.canon_max_size, progress=args.progress)
    t0 = time.time()
    outcome, first = sv.solve(start)
    dt = time.time() - t0
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
    group_name = "x".join(f"Z{m}" for m in mods)
    print(f"[{group_name}] |G|={g.N} canon={label} |canon group|={0 if cg is None else len(cg)}")
    print(f"  start={[g.elems[i] for i in start]}")
    print(f"  OUTCOME={outcome} ({'player to move wins' if outcome == 'N' else 'player to move loses'})")
    if first is not None:
        print(f"  winning move={g.label(first)}")
    print(f"  nodes={sv.nodes} tt={len(sv.tt)} time={dt:.2f}s rss={rss}MB")


if __name__ == "__main__":
    main()
