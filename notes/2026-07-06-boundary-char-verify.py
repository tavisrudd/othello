"""Validate the BOUNDARY CHARACTERIZATION underpinning the reduced crux:

  a size-4 grid position W (necessarily even) is N  <=>  W is contained in an ODD grid-maximal
  cap (equivalently: from W the mover can reach an odd maximal cap, possibly in >1 move, but the
  claim to test is the clean one-shot geometric version W ⊆ some odd maximal cap).

If this holds, then bad(S3) = #{w : S3∪{w} ⊆ some odd maximal cap} is a purely arc-theoretic
quantity, and the reduced crux `escape>=1` is the arc bound "odd maximal caps through S3 don't
cover all q^2-9q+21 extensions".

Also reports, as a refinement, whether N size-4 == (W ⊆ odd maximal cap) EXACTLY, or whether the
one-shot geometric version misses some N positions (which would be N via a deeper defect).
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
            if i == j: continue
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
    return cells, N, rc_mask, line_third


def run(q):
    cells, N, rc_mask, line_third = build(q)
    ALL = (1 << N) - 1

    def add_forbid(forbidden, chosen, yi):
        nf = forbidden | rc_mask[yi]
        c = chosen
        while c:
            b = c & (-c); c ^= b
            nf |= line_third[yi][b.bit_length() - 1]
        return nf

    memo = {}
    def g(chosen, forbidden):
        v = memo.get(chosen)
        if v is not None: return v
        avail = ALL & ~chosen & ~forbidden
        res = 0
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            if g(chosen | y, add_forbid(forbidden, chosen, yi)) == 0:
                res = 1; break
        memo[chosen] = res
        return res
    g(0, 0)

    # does W extend to an ODD maximal cap?  (maximal = no avail; odd = popcount odd)
    def reaches_odd_maximal(chosen, forbidden):
        avail = ALL & ~chosen & ~forbidden
        if avail == 0:
            return bin(chosen).count("1") % 2 == 1  # maximal; odd?
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            if reaches_odd_maximal(chosen | y, add_forbid(forbidden, chosen, yi)):
                return True
        return False

    # enumerate all legal size-4 positions; compare N-ness vs reaches-odd-maximal
    mism = 0; nN = 0; nGeo = 0; tot = 0
    def dfs(chosen, forbidden, depth, start):
        nonlocal mism, nN, nGeo, tot
        if depth == 4:
            tot += 1
            isN = (g(chosen, forbidden) == 1)
            geo = reaches_odd_maximal(chosen, forbidden)
            if isN: nN += 1
            if geo: nGeo += 1
            if isN != geo:
                mism += 1
            return
        avail = ALL & ~chosen & ~forbidden
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            if yi < start: continue
            dfs(chosen | y, add_forbid(forbidden, chosen, yi), depth + 1, yi + 1)
    dfs(0, 0, 0, 0)
    print(f"q={q:>2}  size-4 positions={tot}  N={nN}  reaches-odd-maximal={nGeo}  "
          f"mismatches(N xor geo)={mism}  -> {'CHARACTERIZATION HOLDS' if mism==0 else 'MISMATCH'}",
          flush=True)
    return mism == 0


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [5, 7, 9]
    allok = True
    for q in qs:
        allok &= run(q)
    print("BOUNDARY_CHAR_VERIFY_DONE", "ALL_OK" if allok else "SOME_MISMATCH")
