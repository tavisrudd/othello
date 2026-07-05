"""3-term-AP-free achievement game on a general finite abelian group
G = Z_{m1} x ... x Z_{mk}. Forbid distinct a,b,c with a+c=2b. Test the claim:
  even-order G (has an element of order 2) => P (via translation-by-t mirror).
  odd-order G => cap-like (F_q^d always P; general odd may have exceptions).
Also validate the tau_t whole-board mirror strategy for even-order G."""
import sys
from itertools import product
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def group(mods):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}

    def add(i, j):
        return idx[tuple((a + b) % m for a, b, m in zip(elems[i], elems[j], mods))]

    def dbl(i):
        return idx[tuple((2 * a) % m for a, m in zip(elems[i], mods))]

    N = len(elems)
    order2 = [i for i in range(N) if i != idx[tuple(0 for _ in mods)] and dbl(i) == idx[tuple(0 for _ in mods)]]
    return N, elems, idx, add, dbl, order2


def ap_free(Aset, add, dbl):
    A = list(Aset)
    Aset2 = set(Aset)
    for b in A:
        twob = dbl(b)
        for a in A:
            if a == b:
                continue
            # c with a+c=2b -> c = 2b - a ; find c s.t. add(a,c)=twob
            # since we only have add, scan is costly; instead precompute below
            pass
    return None  # replaced by fast version using a 'sub' map


def make_ops(mods):
    N, elems, idx, add, dbl, order2 = group(mods)

    def sub(i, j):  # i - j
        return idx[tuple((a - b) % m for a, b, m in zip(elems[i], elems[j], mods))]

    return N, idx, add, dbl, sub, order2


def apfree(Aset, dbl, sub, add):
    A = list(Aset)
    S = set(Aset)
    for b in A:
        twob = dbl(b)
        for a in A:
            if a == b:
                continue
            c = sub(twob, a)  # 2b - a
            if c in S and c != a and c != b:
                return False
    return True


def solve(mods, grundy=True):
    N, idx, add, dbl, sub, order2 = make_ops(mods)

    @lru_cache(maxsize=None)
    def g(A):
        opts = set()
        for x in range(N):
            if x in A:
                continue
            A2 = A | frozenset([x])
            if apfree(A2, dbl, sub, add):
                v = g(A2)
                if not grundy and v == 0:
                    return 1
                opts.add(v)
        if not grundy:
            return 0
        mex = 0
        while mex in opts:
            mex += 1
        return mex

    return g(frozenset())


def validate_tau(mods):
    """even-order G: check tau_t mirror (t any order-2 elt) beats all P1 play."""
    N, idx, add, dbl, sub, order2 = make_ops(mods)
    if not order2:
        return None
    t = order2[0]

    def apf(A):
        return apfree(A, dbl, sub, add)

    memo = {}
    def p1(Afs):
        if Afs in memo:
            return memo[Afs]
        A = set(Afs)
        res = True
        for y in range(N):
            if y in A:
                continue
            if not apf(A | {y}):
                continue
            yp = add(y, t)
            if yp == y or yp in A or not apf(A | {y, yp}):
                res = False; break
            if not p1(frozenset(A | {y, yp})):
                res = False; break
        memo[Afs] = res
        return res

    for x in range(N):
        xp = add(x, t)
        if xp == x:
            continue
        if not p1(frozenset({x, xp})):
            return False
    return True


if __name__ == "__main__":
    groups = eval(sys.argv[1]) if len(sys.argv) > 1 else [
        (4,), (6,), (8,), (10,), (12,), (2, 2), (2, 4), (2, 3), (2, 2, 2), (2, 6), (4, 4),
        (3, 3), (9,), (5,), (3, 5), (7,),
    ]
    for mods in groups:
        N, idx, add, dbl, sub, order2 = make_ops(mods)
        even = bool(order2)
        outc = solve(mods, grundy=False)
        tag = "P" if outc == 0 else "N"
        val = ""
        if even:
            ok = validate_tau(mods)
            val = f"  tau_t-mirror-wins={ok}"
        label = "x".join(f"Z{m}" for m in mods)
        print(f"{label:10s} |G|={N:3d} {'even' if even else 'ODD ':>4} outcome={tag}{val}", flush=True)
    print("AP_ABELIAN_DONE")
