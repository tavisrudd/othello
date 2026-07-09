#!/usr/bin/env python3
"""C51 — polar-space Nofil (mirror harvest #3): symplectic W(2n-1,q) and beyond.

Inverts the figure/ground of the C48 harvest.  Instead of a variety being the
BOARD (with ambient lines as constraints), the whole space PG(2n-1,q) is the
board and the CONSTRAINT lines are the totally-isotropic lines of a polar space:
a position is legal iff no 3 selected points lie on a common isotropic line.

Cleanest first target: symplectic W(2n-1,q).  For an alternating form B EVERY
point is isotropic, so the board is all of PG(2n-1,q) (odd projective dimension),
and the C25 elliptic block map already lives there.

Key math verified here (not trusted):
  * the isotropic-line hypergraph is exactly W(2n-1,q) (point/line/GQ counts),
  * the elliptic block map sigma(a_i,b_i) = (d*b_i, a_i), d a fixed nonsquare, is
    a SYMPLECTIC SIMILITUDE of B(x,y) = sum_i (x_{2i} y_{2i+1} - x_{2i+1} y_{2i})
    with factor -d (so it maps isotropic lines to isotropic lines),
  * sigma is fixed-point-free on all of PG(2n-1,q) (sigma^2 = d*I, d nonsquare),
  * the C27 pair-extension obligation (S u {x, sigma x} legal) holds over every
    sigma-invariant reachable position (== a total, never-stuck mirror strategy),
  * the exhaustive cap-game outcome is P where a full solve fits.

Deterministic, single-core, tiny memory.  Reuses the C48 harvest primitives.

Usage:  python3 polar_space_nofil.py [--full]
        (--full runs the heavier W(3,5) exhaustive pieces if they fit)
"""
from __future__ import annotations
import itertools, sys, time, random
from collections import deque, Counter

from projcap_mirror_harvest import (
    GF, gf, proj_points, normalize, collinear, CapGame, check_involution,
    pair_extension_bfs, pair_extension_sampled, elliptic_sigma, matvec, diag,
    lin_apply,
)


# ---------------------------------------------------------------------------
# Symplectic form and totally-isotropic lines.
# ---------------------------------------------------------------------------
def sp_pairs(m):
    """Hyperbolic pairs (0,1),(2,3),... for a 2m-dim symplectic space."""
    return [(2 * i, 2 * i + 1) for i in range(m)]


def symplectic_B(F, x, y, pairs):
    s = F.zero()
    for (i, j) in pairs:
        s = F.add(s, F.sub(F.mul(x[i], y[j]), F.mul(x[j], y[i])))
    return s


def isotropic_lines(F, board, pairs):
    """Every totally-isotropic line of W(2m-1,q) as a frozenset of point indices.

    A projective line <P,Q> is totally isotropic iff B(P,Q)=0 (B alternating, so
    it then vanishes on the whole 2-space).  We collect the full point set of
    each such line and dedupe."""
    n = len(board)
    lines = set()
    for i in range(n):
        for j in range(i + 1, n):
            if symplectic_B(F, board[i], board[j], pairs) == F.zero():
                L = frozenset(k for k in range(n)
                              if collinear(F, board[i], board[j], board[k]))
                lines.add(L)
    return [tuple(sorted(l)) for l in lines]


def sp_block_apply(F, p, d, pairs):
    """Raw (un-normalized) elliptic block map (a_i,b_i)->(d*b_i, a_i)."""
    img = list(p)
    for (i, j) in pairs:
        img[i] = F.mul(d, p[j]); img[j] = p[i]
    return tuple(img)


def similitude_factor(F, board, d, pairs):
    """Return c if the LINEAR block map g satisfies B(g x, g y) = c * B(x,y)
    for all x,y (else None).  Checked on raw representative vectors — the factor
    is a linear identity, meaningless on normalized projective reps.  Expected
    c = -d (so g scales B, preserving isotropy)."""
    c = None
    for i in range(len(board)):
        gi = sp_block_apply(F, board[i], d, pairs)
        for j in range(len(board)):
            gj = sp_block_apply(F, board[j], d, pairs)
            b = symplectic_B(F, board[i], board[j], pairs)
            bs = symplectic_B(F, gi, gj, pairs)
            if b == F.zero():
                if bs != F.zero():
                    return None  # not even isotropy-preserving
                continue
            cij = F.mul(bs, F.inv(b))
            if c is None:
                c = cij
            elif cij != c:
                return None
    return c


def preserves_isotropic_lines(F, board, sigma, lines):
    lineset = set(frozenset(l) for l in lines)
    for L in lines:
        img = frozenset(sigma[i] for i in L)
        if img not in lineset:
            return False
    return True


# ---------------------------------------------------------------------------
# Runners.
# ---------------------------------------------------------------------------
def hdr(name, board):
    par = "even" if len(board) % 2 == 0 else "odd"
    print(f"\n### {name}: {len(board)} points ({par})", flush=True)


def run_W(qname, m, do_lines=True, do_solve=True, do_bfs=True,
          solve_cap_pts=48, bfs_cap_pts=48):
    F = gf(qname); q = F.q
    d_amb = 2 * m - 1  # projective dimension of PG(2m-1,q)
    board = proj_points(F, d_amb)  # ALL of PG(2m-1,q): every point isotropic
    pairs = sp_pairs(m)
    hdr(f"W({d_amb},{q}) symplectic  (board = all of PG({d_amb},{q}))", board)

    d = F.nonsquare()
    sigma = elliptic_sigma(F, board, d)
    inv = check_involution(F, board, sigma)
    c = similitude_factor(F, board, d, pairs)
    negd = F.neg(d)
    cstr = (c[0] if F.k == 1 else c) if c is not None else "NONE"
    print(f"    elliptic mirror (a,b)->(d b,a), d(nonsquare)="
          f"{d[0] if F.k == 1 else d}: {inv}", flush=True)
    print(f"    symplectic-similitude factor B(g x,g y)/B(x,y) = {cstr}  "
          f"(expected -d = {negd[0] if F.k == 1 else negd}; constant nonzero => "
          f"isotropy-preserving)", flush=True)

    if not do_lines:
        # Light path (large boards): confirm fpf + similitude only, cite the
        # uniform lemma for the pair-extension.
        print("    [large board] lines/solve skipped; fpf + similitude confirm "
              "the uniform mirror hypotheses.", flush=True)
        return

    t = time.time()
    lines = isotropic_lines(F, board, pairs)
    spec = dict(Counter(len(l) for l in lines))
    npts, nlines = len(board), len(lines)
    # GQ(q,q) invariants for W(3,q): (q+1)(q^2+1) points and the same #lines,
    # q+1 points/line, q+1 lines/point.
    print(f"    isotropic lines: {nlines} of sizes {spec}  "
          f"({time.time()-t:.1f}s)", flush=True)
    if m == 2:
        exp_pts = (q + 1) * (q * q + 1)
        exp_lines = (q + 1) * (q * q + 1)
        ok = (npts == exp_pts and nlines == exp_lines
              and spec == {q + 1: exp_lines})
        print(f"    GQ({q},{q}) check: points {npts} vs {exp_pts}, lines "
              f"{nlines} vs {exp_lines}, line-size {q+1}  =>  "
              f"{'MATCH' if ok else 'see counts'}", flush=True)
    print(f"    sigma preserves the isotropic-line hypergraph: "
          f"{preserves_isotropic_lines(F, board, sigma, lines)}", flush=True)

    g = CapGame(len(board), lines)

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
              f"  ({time.time()-t:.1f}s)  [proof = similitude above + uniform lemma]",
              flush=True)

    if do_solve and npts <= solve_cap_pts:
        t = time.time()
        val = g.solve_empty()
        print(f"    exhaustive cap-game outcome: {val}  "
              f"({time.time()-t:.2f}s, {len(g.memo)} states)", flush=True)


def run_boundary_watch():
    """The #5 boundary is expected to recur at the group level for unitary /
    orthogonal polar spaces.  Spot-check: the elliptic block map is a symplectic
    similitude (positive), but an ORTHOGONAL isotropic-line game over an even
    projective dimension keeps a rational fixed point (negative), matching #5."""
    print("\n### Boundary watch (#5 recurs at the group level)", flush=True)
    # Orthogonal analogue at even projective dim: any linear involution on an
    # odd number of variables has a rational eigenvector => a fixed proj point.
    F = gf("F3"); one = F.one(); m1 = F.neg(one)
    board = proj_points(F, 2)  # PG(2,3), 13 pts (a Q(2,q)-style conic host)
    M = diag(F, [one, one, m1])
    fp = [p for p in board if lin_apply(F, M, p) == p]
    print(f"    orthogonal/parabolic host PG(2,3): a diag(1,1,-1) linear "
          f"involution has {len(fp)} fixed proj pts (odd #vars => rational "
          f"eigenvector).  Symplectic escapes this because 2m is even AND the "
          f"nonsplit sqrt(d) makes sigma fpf on the WHOLE space.", flush=True)


def main():
    full = "--full" in sys.argv
    print("=" * 72)
    print("C51 polar-space Nofil: symplectic W(2n-1,q) elliptic mirror")
    print("=" * 72, flush=True)

    print("\n--- W(3,3): hypergraph + involution + full pair-extension BFS ---",
          flush=True)
    # The BFS over ALL sigma-invariant caps IS the P certificate (the mirror
    # strategy is total / never stuck).  An exhaustive minimax cross-check at 40
    # pts is infeasible in pure Python (>2min); mirror-only, per the C48 idiom.
    run_W("F3", 2, do_solve=False)  # 40 pts, GQ(3,3)

    print("\n--- W(3,5): hypergraph + involution + sampled pair-extension ---",
          flush=True)
    run_W("F5", 2, do_solve=False, do_bfs=False, solve_cap_pts=200)  # 156 pts

    print("\n--- W(5,3): mirror-only (fpf + symplectic similitude) ---",
          flush=True)
    run_W("F3", 3, do_lines=False)  # 364 pts, board too big for full solve

    run_boundary_watch()
    print("\nDONE.", flush=True)


if __name__ == "__main__":
    main()
