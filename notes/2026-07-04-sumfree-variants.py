"""Achievement-game nimbers for sum-free-set variants (impartial, normal play, last
to move wins). Position = a sum-free set; move = add an element keeping it sum-free.
Compute Grundy(empty) sequences and hunt for clean outcome laws / OEIS matches.

Variants:
  Zn-weak    : Z_n, (A+A) cap A = empty, a=b allowed (2a forbidden).  [the proven game]
  Zn-strong  : Z_n, forbid a+b=c only for a != b (2a=c allowed).
  int[1..n]  : ground {1..n} with integer addition (no wrap), a=b allowed.
  F2^k       : (Z/2)^k minus 0, sum-free (a+b=c), a=b => 2a=0 excluded so effectively strong.
  F3^k       : (Z/3)^k \ {0}, sum-free, a=b allowed.
"""
import sys
from itertools import product
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def is_sumfree(Aset, add, strong):
    A = list(Aset)
    for i in range(len(A)):
        for j in range(i if strong else i, len(A)):
            if strong and i == j:
                continue
            if add(A[i], A[j]) in Aset:
                return False
    return True


def solve(ground, add, strong, grundy=True):
    ground = tuple(ground)

    @lru_cache(maxsize=None)
    def g(A):  # A frozenset
        opts = set()
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if is_sumfree(A2, add, strong):
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


def zn(n):
    return list(range(1, n)), (lambda a, b: (a + b) % n)


def interval(n):
    # ground {1..n}; add = integer sum; sums exceeding n can't be in A so are harmless
    return list(range(1, n + 1)), (lambda a, b: a + b)


def vec(k, p):
    pts = [t for t in product(range(p), repeat=k) if any(t)]  # exclude 0
    add = lambda a, b: tuple((x + y) % p for x, y in zip(a, b))
    return pts, add


if __name__ == "__main__":
    which = sys.argv[1] if len(sys.argv) > 1 else "all"

    def run(name, seqfn, rng, strong):
        vals = []
        for n in rng:
            ground, add = seqfn(n)
            vals.append(solve(ground, add, strong, grundy=True))
        print(f"{name:12s}: {vals}", flush=True)
        # outcome string
        outc = "".join("P" if v == 0 else "N" for v in vals)
        print(f"{'  outcome':12s}: {outc}  (rng {rng.start}..{rng.stop-1})", flush=True)

    if which in ("all", "znstrong"):
        run("Zn-strong", zn, range(1, 25), True)
    if which in ("all", "interval"):
        run("int[1..n]", interval, range(1, 25), False)
    if which in ("all", "f2"):
        run("F2^k", lambda k: vec(k, 2), range(1, 6), False)  # strong is moot (2a=0)
    if which in ("all", "f3"):
        run("F3^k", lambda k: vec(k, 3), range(1, 4), False)
    # control: the proven Zn-weak game (should be P iff n mod 6 in {0,1,5})
    if which in ("all", "znweak"):
        run("Zn-weak", zn, range(1, 25), False)
    print("SUMFREE_VARIANTS_DONE")
