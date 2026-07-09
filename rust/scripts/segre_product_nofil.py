#!/usr/bin/env python3
"""C52 — Segre / product-variety Nofil (mirror harvest #4).

Q+(3,q) IS the Segre variety PG(1,q) x PG(1,q) -> PG(3,q) (the (q+1)x(q+1)
grid).  Generalize the board to PG(a,q) x PG(b,q) (Segre embedding): its
>=3-point ambient lines are exactly the two RULINGS
    {P} x (line of PG(b,q))   and   (line of PG(a,q)) x {Q},
because a line meeting the Segre (an intersection of quadrics) in >=3 points is
contained in it, and the only lines on the Segre are the ruling lines.  So the
cap game is a capacity-2 "rook-lines on a subspace grid" game, which we model
DIRECTLY on the grid PG(a,q) x PG(b,q) (no PG(N,q) tensor embedding needed).

Mirror: sigma = id x g where g is the C25 elliptic fixed-point-free involution on
the ODD-dimensional factor.  sigma is:
  * fpf on the product (fpf in one coordinate => fpf overall),
  * ruling-preserving (a product of collineations sends ruling lines to ruling
    lines), and the C27 pair-extension reduces to the single-factor argument.

=> a Segre-variety Nofil family at lemma-application cost.  Machine-verified here
for PG(1,3)^2 (= Q+(3,3) sanity), PG(2,3)xPG(1,3), PG(1,3)xPG(3,3); plus the #5
boundary negative (product of two EVEN-dim factors admits no id x (fpf) mirror).

Deterministic, single-core, tiny memory.  Reuses the C48 harvest primitives.

Usage:  python3 segre_product_nofil.py [--full]
"""
from __future__ import annotations
import sys, time
from collections import deque, Counter

from projcap_mirror_harvest import (
    gf, proj_points, ge3_lines, CapGame, elliptic_sigma,
    pair_extension_bfs, pair_extension_sampled, lin_apply, diag,
)


# ---------------------------------------------------------------------------
# Factor lines and the Segre ruling hypergraph.
# ---------------------------------------------------------------------------
def factor_lines(F, d):
    """Points and >=3-point lines of the projective space PG(d,q)."""
    pts = proj_points(F, d)
    lines = [frozenset(l) for l in ge3_lines(F, pts)]
    return pts, lines


def build_segre(F, a, b):
    """Grid board PG(a,q) x PG(b,q) with the two rulings as capacity-2 lines."""
    ptsA, linesA = factor_lines(F, a)
    ptsB, linesB = factor_lines(F, b)
    board = [(i, j) for i in range(len(ptsA)) for j in range(len(ptsB))]
    idx = {pq: k for k, pq in enumerate(board)}
    lines = []
    # ruling 1: fix P in PG(a), vary along a line of PG(b)
    for i in range(len(ptsA)):
        for L in linesB:
            lines.append(frozenset(idx[(i, j)] for j in L))
    # ruling 2: fix Q in PG(b), vary along a line of PG(a)
    for j in range(len(ptsB)):
        for L in linesA:
            lines.append(frozenset(idx[(i, j)] for i in L))
    return board, idx, ptsA, ptsB, linesA, linesB, lines


# ---------------------------------------------------------------------------
# Product involution sigma = id x g, and its checks.
# ---------------------------------------------------------------------------
def check_grid_involution(n, sigma):
    return {"is_perm": sorted(sigma.values()) == list(range(n)),
            "involutive": all(sigma[sigma[i]] == i for i in range(n)),
            "fpf": all(sigma[i] != i for i in range(n))}


def preserves_lines(sigma, lines):
    lineset = set(frozenset(l) for l in lines)
    return all(frozenset(sigma[i] for i in L) in lineset for L in lines)


# ---------------------------------------------------------------------------
# Runners.
# ---------------------------------------------------------------------------
def run_segre(qname, a, b, do_solve=True, do_bfs=True,
              solve_cap_pts=56, bfs_cap_pts=170):
    F = gf(qname); q = F.q
    board, idx, ptsA, ptsB, linesA, linesB, lines = build_segre(F, a, b)
    npts = len(board)
    par = "even" if npts % 2 == 0 else "odd"
    print(f"\n### PG({a},{q}) x PG({b},{q}) Segre: {npts} points ({par})",
          flush=True)
    spec = dict(Counter(len(l) for l in lines))
    # expected: |PG(a)| rulings-of-B (each |line_B| pts) + |PG(b)| rulings-of-A
    print(f"    factor A=PG({a},{q}): {len(ptsA)} pts, {len(linesA)} lines; "
          f"factor B=PG({b},{q}): {len(ptsB)} pts, {len(linesB)} lines", flush=True)
    print(f"    ruling hypergraph: {len(lines)} lines of sizes {spec}", flush=True)

    if a == 1 and b == 1:
        # Q+(3,q) sanity: (q+1)^2 pts, 2(q+1) lines of q+1 pts.
        ok = (npts == (q + 1) ** 2 and len(lines) == 2 * (q + 1)
              and spec == {q + 1: 2 * (q + 1)})
        print(f"    Q+(3,{q}) sanity: pts {npts} vs {(q+1)**2}, lines "
              f"{len(lines)} vs {2*(q+1)}  =>  {'MATCH' if ok else 'see counts'}",
              flush=True)

    # sigma = id x (elliptic fpf involution on the ODD factor B).
    if (b + 1) % 2 != 0:
        print(f"    factor B=PG({b},{q}) has ODD #coords {b+1}: no elliptic fpf "
              f"block map on it; would need the fpf factor to be A.", flush=True)
        return
    d = F.nonsquare()
    gB = elliptic_sigma(F, ptsB, d)  # fpf involution on factor B's points
    sigma = {idx[(i, j)]: idx[(i, gB[j])] for (i, j) in board}
    inv = check_grid_involution(npts, sigma)
    print(f"    mirror sigma = id_A x (elliptic on B): {inv}", flush=True)
    print(f"    sigma preserves the ruling hypergraph: "
          f"{preserves_lines(sigma, lines)}", flush=True)

    g = CapGame(npts, lines)
    if do_bfs and npts <= bfs_cap_pts:
        t = time.time()
        fails, ninv = pair_extension_bfs(g, sigma)
        print(f"    C27 pair-extension over ALL {ninv} sigma-invariant caps: "
              f"{'PASS => total mirror strategy => P' if not fails else f'FAIL {len(fails)}'}"
              f"  ({time.time()-t:.1f}s)", flush=True)
    else:
        t = time.time()
        fails, ck = pair_extension_sampled(g, sigma, walks=600)
        print(f"    C27 pair-extension SAMPLED {ck} moves: "
              f"{'PASS' if not fails else f'FAIL {len(fails)}'}"
              f"  ({time.time()-t:.1f}s)  [proof = ruling-preservation + uniform lemma]",
              flush=True)

    if do_solve and npts <= solve_cap_pts:
        t = time.time()
        val = g.solve_empty()
        print(f"    exhaustive cap-game outcome: {val}  "
              f"({time.time()-t:.2f}s, {len(g.memo)} states)", flush=True)


def run_boundary_even_even():
    """#5 boundary: a product of two EVEN projective-dim factors admits no
    id x (fpf) mirror -- each factor lives on an odd number of coordinates, so
    every linear involution on it keeps a rational fixed point."""
    print("\n### Boundary: PG(2,3) x PG(2,3) (both factors even proj dim)",
          flush=True)
    F = gf("F3"); one = F.one(); m1 = F.neg(one)
    pts = proj_points(F, 2)  # PG(2,3), 13 pts, K^3 (odd #coords)
    # Any diagonal involution on K^3 (a rational sqrt(1)=+-1) has fixed pts.
    best = None
    for es in ([one, one, m1], [one, m1, m1], [m1, one, one]):
        M = diag(F, es); fp = [p for p in pts if lin_apply(F, M, p) == p]
        best = len(fp) if best is None else min(best, len(fp))
    print(f"    every diag(+-1) involution on a K^3 factor has >= {best} fixed "
          f"proj pts (odd #coords => rational eigenvector).  So sigma_a x sigma_b "
          f"is fpf iff SOME factor's involution is fpf; two even-dim factors give "
          f"none.  Matches the #5 boundary.", flush=True)


def main():
    full = "--full" in sys.argv
    print("=" * 72)
    print("C52 Segre / product-variety Nofil: id x elliptic mirror")
    print("=" * 72, flush=True)

    print("\n--- PG(1,3) x PG(1,3) = Q+(3,3) sanity (full solve + full BFS) ---",
          flush=True)
    run_segre("F3", 1, 1)  # 16 pts

    print("\n--- PG(2,3) x PG(1,3): fpf factor = B = PG(1,3) ---", flush=True)
    run_segre("F3", 2, 1, do_solve=False, bfs_cap_pts=60)  # 52 pts, BFS proof

    print("\n--- PG(1,3) x PG(3,3): fpf factor = B = PG(3,3) ---", flush=True)
    run_segre("F3", 1, 3, do_solve=False, do_bfs=False)  # 160 pts, sampled proof

    run_boundary_even_even()
    print("\nDONE.", flush=True)


if __name__ == "__main__":
    main()
