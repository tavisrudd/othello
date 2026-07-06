"""Verify the TOTAL LEMMA and its proof internals.

Lemma: for every legal size-3 grid position S3 (3-cell partial-permutation cap in F_q x F_q),
the number of legal size-4 extensions is EXACTLY  q^2 - 9q + 21,  independent of S3.  (Odd for
odd q.)

Proof pieces checked here for ALL size-3 positions:
  (a) total == q^2 - 9q + 21;
  (b) the free-free grid (rows,cols not used by S3) has (q-3)^2 cells;
  (c) each of the 3 pair-lines L_ij meets the free-free grid in exactly q-4 points;
  (d) the 3 pair-lines meet pairwise only at triangle vertices (so inclusion-exclusion is
      total = (q-3)^2 - 3*(q-4)).
"""
import sys
from itertools import product, combinations
from gf import GF
sys.setrecursionlimit(1 << 20)


def check(q):
    F = GF(q)
    sub, mul = F.sub, F.mul
    cells = list(product(range(q), repeat=2))

    def collinear(p, a, b):
        u0, u1 = sub(a[0], p[0]), sub(a[1], p[1])
        w0, w1 = sub(b[0], p[0]), sub(b[1], p[1])
        return sub(mul(u0, w1), mul(u1, w0)) == 0

    def line_points(a, b):
        return [p for p in cells if collinear(a, b, p)]

    total_formula = q * q - 9 * q + 21
    ok_total = ok_ff = ok_line = ok_pair = True
    n = 0
    for tri in combinations(cells, 3):
        rows = {c[0] for c in tri}; cols = {c[1] for c in tri}
        if len(rows) != 3 or len(cols) != 3:
            continue  # not a partial permutation
        (t1, t2, t3) = tri
        if collinear(t1, t2, t3):
            continue  # not a cap
        n += 1
        # (b) free-free grid
        ff = [(r, c) for (r, c) in cells if r not in rows and c not in cols]
        if len(ff) != (q - 3) ** 2:
            ok_ff = False
        ffset = set(ff)
        # legal 4th cells
        used = set(tri)
        legal = 0
        for (r, c) in ff:
            w = (r, c)
            if w in used:
                continue
            bad = False
            for a, b in combinations(tri, 2):
                if collinear(a, b, w):
                    bad = True; break
            if not bad:
                legal += 1
        if legal != total_formula:
            ok_total = False
        # (c) each pair-line meets ff in q-4
        Ls = [set(line_points(a, b)) for a, b in combinations(tri, 2)]
        for L in Ls:
            if len(L & ffset) != q - 4:
                ok_line = False
        # (d) pairwise line intersections only at vertices
        verts = set(tri)
        for La, Lb in combinations(Ls, 2):
            if (La & Lb) - verts:
                ok_pair = False
    print(f"q={q:>2}  size-3 positions={n:>6}  total==q^2-9q+21({total_formula}): {ok_total}  "
          f"ff==(q-3)^2: {ok_ff}  line∩ff==q-4: {ok_line}  pairs-meet-at-verts: {ok_pair}",
          flush=True)
    return ok_total and ok_ff and ok_line and ok_pair


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [5, 7, 9, 11, 13]
    allok = True
    for q in qs:
        allok &= check(q)
    print("TOTAL_LEMMA_VERIFY_DONE", "ALL_OK" if allok else "FAILED")
