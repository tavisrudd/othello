"""3-term-AP-free achievement game on Z_n: build A with NO 3-term arithmetic
progression (distinct a,b,c with a+c=2b, i.e. b the midpoint). Add one element per
move keeping AP-free; last to move wins. This is the translation-invariant cyclic
analog of the cap game (in F_3^d, AP-free == cap == no a+b+c=0). Translation AND
negation are automorphisms, so a clean outcome law is plausible.
"""
import sys
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def ap_free(Sset, n):
    # AP found iff exist distinct a,b,c in S with a+c=2b (b middle)
    for b in Sset:
        for a in Sset:
            if a == b:
                continue
            c = (2 * b - a) % n
            if c in Sset and c != a and c != b:
                return False
    return True


def legal_x(A, n):
    # x illegal iff A|{x} has a 3-AP involving x
    bad = set()
    Al = list(A)
    for i in range(len(Al)):
        for j in range(len(Al)):
            if i == j:
                continue
            a, b = Al[i], Al[j]
            # x as third point of AP with a,b in the two other roles:
            bad.add((2 * b - a) % n)   # a,b,x with b middle -> x=2b-a
            # x as middle: 2x = a+b
            s = a + b
            if s % 2 == 0:
                bad.add((s // 2) % n)
            if n % 2 == 0 and s % 2 == 0:
                bad.add((s // 2 + n // 2) % n)
            elif n % 2 == 1:
                inv2 = (n + 1) // 2
                bad.add((s * inv2) % n)
    return [x for x in range(n) if x not in A and x not in bad]


def solve(n, grundy=True):
    @lru_cache(maxsize=None)
    def g(A):
        opts = set()
        for x in legal_x(set(A), n):
            A2 = A | frozenset([x])
            # legal_x already guarantees AP-free; trust it (verified vs ap_free below)
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
    val = g(frozenset())
    g.cache_clear()
    return val


def _selftest():
    # cross-check legal_x against a direct ap_free rebuild on random small sets
    import itertools
    for n in range(3, 12):
        for r in range(4):
            for combo in itertools.combinations(range(n), r):
                A = frozenset(combo)
                if not ap_free(set(A), n):
                    continue
                lg = set(legal_x(set(A), n))
                for x in range(n):
                    if x in A:
                        continue
                    direct = ap_free(set(A) | {x}, n)
                    assert (x in lg) == direct, (n, sorted(A), x, x in lg, direct)
    print("legal_x self-test OK", flush=True)


if __name__ == "__main__":
    if len(sys.argv) > 2:
        lo, hi = int(sys.argv[1]), int(sys.argv[2])
    else:
        lo, hi = 1, int(sys.argv[1]) if len(sys.argv) > 1 else 24
    if len(sys.argv) <= 3:
        _selftest()
    nvals = []
    for n in range(lo, hi + 1):
        # outcome-only is much cheaper for larger n
        v = solve(n, grundy=False)
        nvals.append((n, v))
        print(f"  n={n}: {'N' if v else 'P'}", flush=True)
    Ns = [n for n, v in nvals if v]
    print("N-positions in range:", Ns, flush=True)
    print("AP_FREE_DONE")
