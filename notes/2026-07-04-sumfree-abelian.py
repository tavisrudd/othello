"""Sum-free achievement game (forbid a+b=c, a=b allowed) on a general finite
abelian group G = Z_{m1} x ... x Z_{mk}, on the ground set G\\{0}. Tabulate the
outcome against the 2-torsion and 3-torsion structure, to test whether the proven
Z_n mod-6 law ("P iff even # of negation-obstructions") generalizes.

For Z_n: #order-2 elts = [2|n], #order-3 subgroup pairs = [3|n]; law P iff n=0,1,5
mod6 = even # obstructions.  General G: t2 = |{x!=0: 2x=0}|, t3 = |{x!=0: 3x=0}|.
"""
import sys
from itertools import product
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def make(mods):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple(0 for _ in mods)]

    def add(i, j):
        return idx[tuple((a + b) % m for a, b, m in zip(elems[i], elems[j], mods))]

    N = len(elems)
    # multiples
    def mul(k, i):
        r = zero
        for _ in range(k):
            r = add(r, i)
        return r
    t2 = [i for i in range(N) if i != zero and mul(2, i) == zero]
    t3 = [i for i in range(N) if i != zero and mul(3, i) == zero]
    return N, zero, add, t2, t3


def solve(mods, grundy=False):
    N, zero, add, t2, t3 = make(mods)
    ground = [i for i in range(N) if i != zero]

    def sumfree(A):
        for a in A:
            for b in A:
                if add(a, b) in A:
                    return False
        return True

    @lru_cache(maxsize=None)
    def g(A):
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sumfree(set(A2)):
                if g(A2) == 0 and not grundy:
                    return 1
        return 0
    return g(frozenset())


if __name__ == "__main__":
    groups = eval(sys.argv[1]) if len(sys.argv) > 1 else [
        (5,), (6,), (7,), (8,), (9,), (10,), (11,), (12,), (13,),
        (2, 2), (2, 4), (2, 2, 2), (3, 3), (2, 3), (2, 6), (4, 3), (2, 2, 3),
    ]
    print(f"{'G':12s} {'|G|':>4} {'t2':>3} {'t3':>3} {'obs?':>12} {'outcome':>8}")
    for mods in groups:
        N, zero, add, t2, t3 = make(mods)
        outc = solve(mods)
        # 'obstruction parity' guess: O2 present iff t2>0, O3 present iff t3>0
        nobs = (1 if t2 else 0) + (1 if t3 else 0)
        pred = "P" if nobs % 2 == 0 else "N"
        label = "x".join(f"Z{m}" for m in mods)
        tag = "P" if outc == 0 else "N"
        flag = "" if tag == pred else "  <-- mismatch"
        print(f"{label:12s} {N:>4} {len(t2):>3} {len(t3):>3} "
              f"{'nobs='+str(nobs):>12} {tag:>8}  (pred {pred}){flag}", flush=True)
    print("SUMFREE_ABELIAN_DONE")
