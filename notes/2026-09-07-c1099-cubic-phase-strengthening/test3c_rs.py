"""Test 3(c): Reed-Solomon / GRS evaluation spaces with weighted transversal cubics
(memo section 9.3 mechanism: X-space S, evaluation space L, weights w ⊥ S∘L∘L, logical
cubic nonzero iff w not ⊥ L^{o3}), compared with the trade codes.

Part 1: polynomial CSS codes on the p affine points (and on the p+1 points of P^1).
  S = RS_a (degree <= a-1), L = RS_b, 1 <= a < b <= p.  Exact d_X, d_Z by brute force
  when p^b is small, MDS formulas otherwise (marked).  Also whether a {+-1}-valued
  weight vector exists (the "signed GRS" question).
Part 2: length 2p by repeating every evaluation point twice (the only way to reach length
  2p with GRS over F_p): the admissible weights reduce to the single-copy problem with
  w-bar(alpha) = w_i + w_j, so the logical count is capped at (p-3)/2, against p-1 for the
  trade codes.  Verified numerically for p = 7, 11, 13.
"""
import itertools
import sys

from conic import rref, rank, span_products, dot


def rs_basis(p, b, points):
    return [[pow(x, j, p) if not (x == 0 and j == 0) else 1 for x in points] for j in range(b)]


def perp(rows, p, n):
    """Basis of the orthogonal complement of span(rows) in F_p^n."""
    R, piv = rref(rows, p)
    free = [c for c in range(n) if c not in piv]
    out = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, pc in enumerate(piv):
            v[pc] = (-R[i][f]) % p
        out.append(v)
    return out


def min_weight_outside(big_rows, small_rows, p, limit=2_000_000):
    """min wt(span(big) \\ span(small)); exact if p^dim(big) <= limit else None."""
    dim = len(big_rows)
    n = len(big_rows[0])
    if p ** dim > limit:
        return None
    small_rref = rref(small_rows, p)[0] if small_rows else []
    best = n + 1
    for coef in itertools.product(range(p), repeat=dim):
        if not any(coef):
            continue
        v = [0] * n
        for c, row in zip(coef, big_rows):
            if c:
                v = [(x + c * y) % p for x, y in zip(v, row)]
        if small_rref and rank(small_rref + [v], p) == len(small_rref):
            continue
        w = sum(1 for x in v if x)
        if w < best:
            best = w
    return best


def analyse(p, points, a, b, exact_limit):
    n = len(points)
    S = rs_basis(p, a, points)
    L = rs_basis(p, b, points)
    SLL = rref([[(s * x * y) % p for s, x, y in zip(S[i], L[j], L[l])]
                for i in range(a) for j in range(b) for l in range(j, b)], p)[0]
    W = perp(SLL, p, n)
    L3 = span_products(L, p, 3)
    good = [w for w in W if any(dot(w, v, p) for v in L3)]
    if not W or not good:
        return None
    # signed weight? enumerate W (small dims only)
    signed = None
    if len(W) <= 6:
        signed = False
        for coef in itertools.product(range(p), repeat=len(W)):
            if not any(coef):
                continue
            w = [0] * n
            for c, row in zip(coef, W):
                if c:
                    w = [(x + c * y) % p for x, y in zip(w, row)]
            if all(x in (1, p - 1) for x in w) and any(dot(w, v, p) for v in L3):
                signed = True
                break
    Lperp = perp(L, p, n)
    Sperp = perp(S, p, n)
    dX = min_weight_outside(L, S, p, exact_limit)
    dZ = min_weight_outside(Sperp, Lperp, p, exact_limit)
    return dict(n=n, k=b - a, dimW=len(W), dX=dX, dZ=dZ, signed=signed)


def main():
    primes = [int(x) for x in sys.argv[1:]] or [7, 11, 13]
    for p in primes:
        print(f"\n=== p = {p} ===")
        for label, points in (("affine points", list(range(p))),):
            print(f"  {label}: n = {len(points)}; rows: (a,b) -> [[n,k,d]] with d = min(d_X,d_Z); MDS values d_X = n-b+1, d_Z = a+1")
            best = {}
            for a in range(1, p):
                for b in range(a + 1, p + 1):
                    r = analyse(p, points, a, b, exact_limit=300_000)
                    if r is None:
                        continue
                    dX = r["dX"] if r["dX"] is not None else len(points) - b + 1
                    dZ = r["dZ"] if r["dZ"] is not None else a + 1
                    d = min(dX, dZ)
                    tag = "exact" if (r["dX"] is not None and r["dZ"] is not None) else "MDS"
                    key = d
                    if key not in best or r["k"] > best[key][0]:
                        best[key] = (r["k"], a, b, dX, dZ, tag, r["dimW"], r["signed"])
            for d in sorted(best):
                k, a, b, dX, dZ, tag, dimW, signed = best[d]
                print(f"    d={d}: best k={k} at (a,b)=({a},{b}) -> [[{p},{k},{d}]]_{p} (d_X={dX}, d_Z={dZ}, {tag}); "
                      f"dim of weight space={dimW}; signed (+-1) weight exists: {signed}")
        # Part 2: doubled points, length 2p
        points = list(range(p)) * 2
        maxk = None
        for b in range(2, p + 1):
            r = analyse(p, points, 1, b, exact_limit=1)
            if r is not None:
                maxk = (b - 1, b)
        print(f"  doubled affine points (n = 2p = {2*p}), S = <1>: largest b with a nonzero logical cubic gives "
              f"k = {maxk[0] if maxk else None} (b = {maxk[1] if maxk else None}); predicted cap (p-3)/2 = {(p-3)//2}; "
              f"trade codes give k = {p-1}")


if __name__ == "__main__":
    main()
