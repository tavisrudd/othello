"""For the sum-free achievement game on a group G, collect the SIZES of all
inclusion-maximal sum-free sets (= game terminals; reachable since sum-free is
subset-closed). If they all share one parity, the game outcome is forced by parity:
  all sizes ODD  => first player always makes the last move => N (first-player win)
  all sizes EVEN => second player always makes the last move => P
This tests whether F3^k (conjectured N) and F2^k are parity-decided."""
import sys
from itertools import product
from sumfree_variants import is_sumfree, vec

sys.setrecursionlimit(1 << 20)


def maximal_sizes(ground, add, strong):
    ground = tuple(ground)
    seen = set()          # visited sum-free sets (frozensets)
    sizes = set()         # distinct terminal (maximal) sizes

    def dfs(A):
        if A in seen:
            return
        seen.add(A)
        extended = False
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if is_sumfree(A2, add, strong):
                extended = True
                dfs(A2)
        if not extended:      # inclusion-maximal
            sizes.add(len(A))

    dfs(frozenset())
    return sorted(sizes)


if __name__ == "__main__":
    print("group      maximal-sizes                parities")
    for (label, k, p, strong) in [
        ("F2^2", 2, 2, False), ("F2^3", 3, 2, False), ("F2^4", 4, 2, False),
        ("F3^2", 2, 3, False), ("F3^3", 3, 3, False),
    ]:
        ground, add = vec(k, p)
        sz = maximal_sizes(ground, add, strong)
        par = sorted({s % 2 for s in sz})
        pl = {0: "even", 1: "odd"}
        tag = pl[par[0]] if len(par) == 1 else "MIXED"
        print(f"{label:10s} {str(sz):28s} {tag}", flush=True)
    print("TERMINAL_PARITY_DONE")
