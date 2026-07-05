"""Zero-sum-triple achievement game on Z_n: build A with NO three DISTINCT elements
a,b,c in A summing to 0 mod n. Move = add x keeping that property; last to move
wins. This is the cyclic analog of the cap game (a+b+c=0), vs the sum-free game
(a+b=c). Compute Grundy(empty), hunt for a clean outcome law + OEIS.

Also a 'weak' variant allowing a=b (so 2a+c=0 forbidden too)."""
import sys
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def is_valid(Aset, n, allow_eq):
    A = sorted(Aset)
    L = len(A)
    S = Aset
    for i in range(L):
        for j in range((i if allow_eq else i + 1), L):
            # need a third distinct element c = -(a+b); for allow_eq, a=b permitted
            if not allow_eq and i == j:
                continue
            c = (-(A[i] + A[j])) % n
            if c in S and c != A[i] and c != A[j]:
                return False
            if allow_eq and i == j and c in S and c != A[i]:
                return False
    return True


def solve(n, allow_eq=False, grundy=True):
    ground = tuple(range(n))

    @lru_cache(maxsize=None)
    def g(A):
        opts = set()
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if is_valid(A2, n, allow_eq):
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


if __name__ == "__main__":
    rng = range(1, int(sys.argv[1]) if len(sys.argv) > 1 else 22)
    vals = [solve(n, allow_eq=False, grundy=True) for n in rng]
    print("zero-sum-triple (distinct) Z_n, n=1..:", vals, flush=True)
    print("  outcome:", "".join("P" if v == 0 else "N" for v in vals))
    # by residue mod 6 (the sum-free law modulus) and mod 3
    for mod in (2, 3, 6):
        print(f"  P-residues mod {mod}:",
              sorted({(list(rng)[i]) % mod for i, v in enumerate(vals) if v == 0}))
    print("ZEROSUM_DONE")
