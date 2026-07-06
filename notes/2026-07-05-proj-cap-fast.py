"""Fast exact solver for the cap achievement game on PG(m,q).

Board = points of PG(m,q) (1-dim subspaces of F_q^{m+1}, canonical rep = scale so
first nonzero coord = 1). Legal position = a cap (no 3 collinear). Move = add a point
keeping the cap property. Normal play (no move => lose). Outcome: P (2nd-player win,
Grundy-root loss for mover) or N (1st-player win).

Speed vs the raw probe (2026-07-04-proj-cap.py):
  - points/lines indexed 0..N-1; positions are Python-int bitmasks;
  - forbidden mask carried INCREMENTALLY (adding y to cap A forbids, for each a in A,
    the whole line ya) instead of recomputed O(|A|^2) per node;
  - memo keyed on the chosen bitmask (forbidden is a function of chosen).

Axioms validated before solving (R.C. gate): every line has exactly q+1 points, and
every pair of distinct points lies on exactly one line.

q=2 cross-check: PG(k-1,2) cap game == F_2^k sum-free game (line = {a,b,a+b}).
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def canon(vec, F):
    for c in vec:
        if c != 0:
            inv = F.inv(c)
            return tuple(F.mul(inv, x) for x in vec)
    return None  # zero vector


def build(m, q):
    """Return (N, pts, line_mask) where line_mask[i][j] is the bitmask of all points
    on the projective line through points i,j (i != j)."""
    F = GF(q)
    dim = m + 1
    reps = set()
    for vec in product(range(q), repeat=dim):
        if any(vec):
            reps.add(canon(vec, F))
    pts = sorted(reps)
    idx = {p: i for i, p in enumerate(pts)}
    N = len(pts)

    # line through i,j = { canon(a*P + b*Q) : (a,b) != 0 }
    line_mask = [[0] * N for _ in range(N)]
    for i in range(N):
        P = pts[i]
        for j in range(i + 1, N):
            Q = pts[j]
            m_ij = 0
            for a in range(q):
                for b in range(q):
                    if a == 0 and b == 0:
                        continue
                    v = tuple(F.add(F.mul(a, P[k]), F.mul(b, Q[k])) for k in range(dim))
                    c = canon(v, F)
                    if c is not None:
                        m_ij |= 1 << idx[c]
            line_mask[i][j] = m_ij
            line_mask[j][i] = m_ij
    return N, pts, line_mask


def validate_axioms(N, q, line_mask):
    """Every line has q+1 points; every pair lies on exactly one line."""
    lines = set()
    for i in range(N):
        for j in range(i + 1, N):
            lm = line_mask[i][j]
            assert (lm >> i) & 1 and (lm >> j) & 1, f"pair {i},{j} not on its own line"
            assert bin(lm).count("1") == q + 1, \
                f"line {i},{j} has {bin(lm).count('1')} pts, expected {q+1}"
            lines.add(lm)
    # each pair on exactly one line: for every line L and pair in L, line_mask agrees
    for lm in lines:
        pts_on = [k for k in range(N) if (lm >> k) & 1]
        for a in range(len(pts_on)):
            for b in range(a + 1, len(pts_on)):
                assert line_mask[pts_on[a]][pts_on[b]] == lm, \
                    "pair lies on two distinct lines"
    exp_lines = N * (N - 1) // (q * (q + 1))  # (q+1 choose 2) pairs per line
    assert len(lines) == exp_lines, f"{len(lines)} lines, expected {exp_lines}"
    return len(lines)


def solve(m, q, report=False):
    N, pts, line_mask = build(m, q)
    nlines = validate_axioms(N, q, line_mask)
    ALL = (1 << N) - 1
    lm = line_mask

    memo = {}

    def g(chosen, forbidden):
        # value for the player to move: 1 = win (N-position), 0 = loss (P-position)
        v = memo.get(chosen)
        if v is not None:
            return v
        avail = ALL & ~chosen & ~forbidden
        res = 0
        a = avail
        while a:
            y = a & (-a)
            a ^= y
            yi = y.bit_length() - 1
            # adding yi: forbid every point on a line through yi and an existing pt
            nf = forbidden
            c = chosen
            while c:
                b = c & (-c)
                c ^= b
                nf |= lm[yi][b.bit_length() - 1]
            if g(chosen | y, nf) == 0:
                res = 1
                break
        memo[chosen] = res
        return res

    root = g(0, 0)
    outc = "P (2nd)" if root == 0 else "N (1st)"
    if report:
        print(f"PG({m},{q})  N={N}  lines={nlines}  states={len(memo)}  -> {outc}",
              flush=True)
    return root, N, len(memo)


if __name__ == "__main__":
    cases = eval(sys.argv[1]) if len(sys.argv) > 1 else [
        (1, 2), (2, 2), (3, 2), (1, 3), (2, 3), (2, 4), (2, 5),
    ]
    print(f"{'case':>10} {'N':>5} {'states':>11} {'outcome':>9}")
    for (m, q) in cases:
        root, N, st = solve(m, q)
        outc = "P (2nd)" if root == 0 else "N (1st)"
        print(f"{('PG(%d,%d)' % (m, q)):>10} {N:>5} {st:>11} {outc:>9}", flush=True)
    print("PROJ_CAP_FAST_DONE")
