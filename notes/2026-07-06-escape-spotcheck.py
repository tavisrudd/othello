"""Independent spot-check of the Rust escape mode (2026-07-06-grid-cap-solver.rs `escape`).

Given q and one explicit size-3 grid position S3, directly count how many of its legal size-4
children are P-positions (= escape), with a SELF-CONTAINED naive solver: NO grid-automorphism
canonicalization, a raw per-position memo on the plain `chosen` bitmask.  This is a completely
different code path from the Rust canonical solver, so agreement on the escape COUNT validates
the (surprising) Rust result min-escape=5 at q=17.

Builds the O(q^3) line table ONCE and reuses a single global memo across all queried S3.

Usage:  python3 2026-07-06-escape-spotcheck.py q  "r0,c0 r1,c1 r2,c2"  ["..." ...]
Default checks the Rust-reported min-escape representatives at q=11,13,17.
"""
import sys
from itertools import product
from gf import GF
sys.setrecursionlimit(1 << 20)


def build(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    N = len(cells)

    def cross(p, a, b):
        ux, uy = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        wx, wy = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(ux, wy), F.mul(uy, wx)) == 0

    row_mask = [0] * N; col_mask = [0] * N
    for i, (r, c) in enumerate(cells):
        for j, (r2, c2) in enumerate(cells):
            if i == j:
                continue
            if r2 == r: row_mask[i] |= 1 << j
            if c2 == c: col_mask[i] |= 1 << j
    rc_mask = [row_mask[i] | col_mask[i] for i in range(N)]
    line_third = [[0] * N for _ in range(N)]
    for i in range(N):
        for j in range(N):
            if i == j: continue
            m = 0
            for k in range(N):
                if k != i and k != j and cross(cells[i], cells[j], cells[k]):
                    m |= 1 << k
            line_third[i][j] = m
    idx = {c: i for i, c in enumerate(cells)}
    return F, cells, idx, N, rc_mask, line_third


class Solver:
    def __init__(self, q):
        self.q = q
        (self.F, self.cells, self.idx, self.N,
         self.rc_mask, self.line_third) = build(q)
        self.ALL = (1 << self.N) - 1
        self.memo = {}

    def add_forbid(self, forbidden, chosen, yi):
        nf = forbidden | self.rc_mask[yi]
        c = chosen
        while c:
            b = c & (-c); c ^= b
            nf |= self.line_third[yi][b.bit_length() - 1]
        return nf

    def g(self, chosen, forbidden):
        v = self.memo.get(chosen)
        if v is not None:
            return v
        avail = self.ALL & ~chosen & ~forbidden
        res = 0
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            nf = self.add_forbid(forbidden, chosen, yi)
            if self.g(chosen | y, nf) == 0:
                res = 1
                break
        self.memo[chosen] = res
        return res

    def escape_of(self, s3_cells):
        chosen = 0; forbidden = 0
        for cell in s3_cells:
            yi = self.idx[cell]
            assert (forbidden >> yi) & 1 == 0 and (chosen >> yi) & 1 == 0, \
                f"illegal S3 at {cell}"
            forbidden = self.add_forbid(forbidden, chosen, yi)
            chosen |= 1 << yi
        avail = self.ALL & ~chosen & ~forbidden
        nP = 0; ntot = 0
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            ntot += 1
            nf = self.add_forbid(forbidden, chosen, yi)
            if self.g(chosen | y, nf) == 0:
                nP += 1
        return nP, ntot


def parse_s3(s):
    return [tuple(int(x) for x in tok.split(",")) for tok in s.split()]


if __name__ == "__main__":
    q = int(sys.argv[1]) if len(sys.argv) > 1 else 17
    if len(sys.argv) > 2:
        targets = [parse_s3(a) for a in sys.argv[2:]]
    else:
        # Rust-reported min-escape representatives
        default = {11: "0,0 1,1 2,3", 13: "0,0 1,1 3,4", 17: "0,0 1,1 2,5"}
        targets = [parse_s3(default.get(q, "0,0 1,1 2,3"))]
    sv = Solver(q)
    print(f"q={q}: total(q^2-9q+21)={q*q-9*q+21}")
    for s3 in targets:
        nP, ntot = sv.escape_of(s3)
        print(f"  S3={s3}  escape(#P size-4)={nP}  total={ntot}  bad={ntot-nP}", flush=True)
    print("SPOTCHECK_DONE")
