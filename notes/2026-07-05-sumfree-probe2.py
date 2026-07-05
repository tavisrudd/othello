"""Two decisive probes for the abelian sum-free proof:
(A) Does the affine reflection sigma_c(z)=c-z (c=2t, fixed point t) PRESERVE
    sum-freeness in the mirror sense?  Test: for all sigma-symmetric sum-free A
    and all legal z (z != sigma z), is A U {z, sigma z} sum-free?
(B) Maximal sum-free set SIZE PARITIES per group.  If a group's maximal
    sum-free sets are all one parity, the outcome is forced by parity alone.
"""
import sys
from itertools import product
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def make(mods):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple(0 for _ in mods)]

    def A(i, j):
        return idx[tuple((a + b) % m for a, b, m in zip(elems[i], elems[j], mods))]

    N = len(elems)
    addm = [[A(i, j) for j in range(N)] for i in range(N)]
    negm = [idx[tuple((-a) % m for a, m in zip(e, mods))] for e in elems]
    dbl = [addm[i][i] for i in range(N)]
    ord2 = [i for i in range(N) if i != zero and dbl[i] == zero]
    ord3 = [i for i in range(N) if i != zero and addm[dbl[i]][i] == zero]
    return elems, idx, zero, addm, negm, dbl, ord2, ord3


def sumfree(A, addm):
    for a in A:
        for b in A:
            if addm[a][b] in A:
                return False
    return True


def probeA(mods):
    """Test sigma_c preservation for every order-3 center t (c=2t)."""
    elems, idx, zero, addm, negm, dbl, ord2, ord3 = make(mods)
    N = len(elems)
    ground = [i for i in range(N) if i != zero]
    results = {}
    for t in ord3:
        c = dbl[t]  # c = 2t ; sigma(z) = c - z = addm[c][negm[z]]
        sig = [addm[c][negm[z]] for z in range(N)]
        assert sig[t] == t  # t is the fixed point
        # enumerate sigma-symmetric sum-free sets by BFS from {t}
        bad = 0
        tested = 0
        seen = set()
        stack = [frozenset([t])]
        seen.add(frozenset([t]))
        while stack:
            Aset = stack.pop()
            # try each legal z with z != sigma z
            for z in ground:
                if z in Aset:
                    continue
                sz = sig[z]
                if sz == z:  # sigma-fixed (only t here); skip
                    continue
                A1 = set(Aset) | {z}
                if not sumfree(A1, addm):
                    continue  # z not even individually legal
                A2 = frozenset(A1 | {sz})
                tested += 1
                if not sumfree(A2, addm):
                    bad += 1
                elif A2 not in seen and len(A2) < N:
                    seen.add(A2)
                    if len(seen) < 5000:
                        stack.append(A2)
        results[t] = (tested, bad)
    return results, len(ord3)


def maximal_parities(mods, cap=200000):
    elems, idx, zero, addm, negm, dbl, ord2, ord3 = make(mods)
    N = len(elems)
    ground = [i for i in range(N) if i != zero]
    sizes = set()
    seen = [0]

    # find all MAXIMAL sum-free sets, record sizes
    def extend(Aset, start):
        seen[0] += 1
        if seen[0] > cap:
            return
        maximal = True
        for i in range(start, len(ground)):
            z = ground[i]
            if z in Aset:
                continue
            A1 = Aset | {z}
            if sumfree(A1, addm):
                maximal = False
                extend(A1, i + 1)
        if maximal:
            sizes.add(len(Aset))
    # to get ALL maximal sizes we can't prune by start-order; do a cleaner search:
    # collect maximal sets via greedy-independent recursion over full ground each time.
    sizes.clear()
    seen[0] = 0
    resultsizes = set()

    @lru_cache(maxsize=None)
    def maxsizes(Aset):
        # returns frozenset of maximal-completion sizes reachable from sum-free Aset
        res = set()
        extended = False
        for z in ground:
            if z in Aset:
                continue
            A1 = Aset | frozenset([z])
            if sumfree(set(A1), addm):
                extended = True
                res |= maxsizes(A1)
        if not extended:
            res.add(len(Aset))
        return frozenset(res)

    return sorted(maxsizes(frozenset()))


if __name__ == "__main__":
    print("=== (A) sigma_c affine-reflection preservation test ===")
    for mods in [(3, 3), (9, 3), (2, 3, 3), (3, 3, 3), (7, 3)]:
        res, no3 = probeA(mods)
        lbl = "x".join(f"Z{m}" for m in mods)
        totbad = sum(b for (_, b) in res.values())
        tottest = sum(t for (t, _) in res.values())
        print(f"  {lbl:12s} ord3={no3:2d}  sigma-tests={tottest:6d}  VIOLATIONS={totbad}")
    print()
    print("=== (B) maximal sum-free set sizes per group ===")
    for mods in [(5,), (6,), (7,), (8,), (9,), (2, 2), (3, 3), (9, 3),
                 (2, 3, 3), (3, 3, 3)]:
        lbl = "x".join(f"Z{m}" for m in mods)
        try:
            szs = maximal_parities(mods)
            par = "ALL EVEN" if all(s % 2 == 0 for s in szs) else \
                  ("ALL ODD" if all(s % 2 == 1 for s in szs) else "MIXED")
            print(f"  {lbl:12s} maximal sizes={szs}  -> {par}")
        except Exception as e:
            print(f"  {lbl:12s} ERR {e}")
    print("PROBE2_DONE")
