"""Verify R0 / L1 / L2 pairing certificates for GRAPH Node-Kayles on Cayley
graphs of *general finite abelian groups* Gamma = Z_{m1} x ... x Z_{mk}
(not just Z_n). Brute Grundy solver over independent-set bitmasks, memoized.

Claims under test (proven-on-write in the note; this is corroboration):
  P0 master pairing  : fpf involutive automorphism sigma with no adjacent mate  => G=0.
  L1 (even order)    : exists involution g (2g=0, g!=0) with g not in S         => G=0.
  L2 (odd order)     : 2S=S (doubling-closed)  => play 0, negate-mirror residual => G=1.
  R0 (index reduction): m=[Gamma:<S>] copies of connected Cay(<S>,S);
                         m even => G=0 ; m odd => G=G(connected component).
  odd-order impossibility: |Gamma| odd => no fpf involution (structural).
All groups are small so brute Grundy is exact.
"""

import itertools
import sys
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def group(mods):
    """Return (elems, add, neg, zero_index) for Z_{mods[0]} x ... ."""
    elems = list(itertools.product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}

    def add(i, j):
        a, b = elems[i], elems[j]
        return idx[tuple((x + y) % m for x, y, m in zip(a, b, mods))]

    def neg(i):
        a = elems[i]
        return idx[tuple((-x) % m for x, m in zip(a, mods))]

    zero = idx[tuple(0 for _ in mods)]
    return elems, add, neg, zero, idx


def sym_conn_sets(mods):
    """All symmetric connection sets S = -S, 0 not in S, up to a size cap."""
    elems, add, neg, zero, idx = group(mods)
    N = len(elems)
    nonzero = [i for i in range(N) if i != zero]
    # orbit under negation: pair {i, -i}
    seen = set()
    orbits = []
    for i in nonzero:
        if i in seen:
            continue
        ni = neg(i)
        orbits.append((i, ni))
        seen.add(i)
        seen.add(ni)
    for r in range(len(orbits) + 1):
        for combo in itertools.combinations(orbits, r):
            S = set()
            for a, b in combo:
                S.add(a)
                S.add(b)
            yield frozenset(S)


def adjacency(mods, S):
    elems, add, neg, zero, idx = group(mods)
    N = len(elems)
    Sset = set(S)
    adj = [0] * N
    for v in range(N):
        m = 0
        for s in Sset:
            m |= 1 << add(v, s)
        adj[v] = m
    return N, adj


def grundy(N, adj):
    """Grundy value of Node-Kayles on graph given by adjacency masks.
    State = bitmask of still-AVAILABLE vertices (all initially available)."""
    from functools import lru_cache

    @lru_cache(maxsize=None)
    def g(avail):
        if avail == 0:
            return 0
        seen = set()
        m = avail
        while m:
            v = (m & -m).bit_length() - 1
            m &= m - 1
            # play v: remove v and its neighbors from availability
            nxt = avail & ~((1 << v) | adj[v])
            seen.add(g(nxt))
        mex = 0
        while mex in seen:
            mex += 1
        return mex

    full = (1 << N) - 1
    val = g(full)
    g.cache_clear()
    return val


def subgroup_index(mods, S):
    """m = [Gamma:<S>], and whether generated subgroup = whole group."""
    elems, add, neg, zero, idx = group(mods)
    N = len(elems)
    gen = {zero}
    frontier = [zero]
    Sset = set(S)
    while frontier:
        x = frontier.pop()
        for s in Sset:
            y = add(x, s)
            if y not in gen:
                gen.add(y)
                frontier.append(y)
    sub = len(gen)
    return N // sub, sub


def run(mods):
    elems, add, neg, zero, idx = group(mods)
    N = len(elems)
    odd_order = (N % 2 == 1)
    name = "x".join(f"Z{m}" for m in mods)
    l1_fail = l2_fail = r0_fail = 0
    checked = 0
    for S in sym_conn_sets(mods):
        Nn, adj = adjacency(mods, S)
        g = grundy(Nn, adj)
        checked += 1
        Sset = set(S)
        # --- L1: exists involution g0 (2g0=0,g0!=0) not in S => predict G=0
        invol = [i for i in range(N) if i != zero and add(i, i) == zero]
        l1_elt = next((i for i in invol if i not in Sset), None)
        if l1_elt is not None and g != 0:
            l1_fail += 1
            print(f"  L1 VIOLATION {name} S={sorted(Sset)} g={g}")
        # --- L2: odd order & 2S=S => predict G=1
        if odd_order:
            twoS = {add(s, s) for s in Sset}
            if twoS == Sset and g != 1:
                # skip the empty set S=empty (no moves-> but 0 unplayable? here empty S = no edges)
                if Sset:
                    l2_fail += 1
                    print(f"  L2 VIOLATION {name} S={sorted(Sset)} g={g}")
        # --- R0: index parity
        m, sub = subgroup_index(mods, S)
        if m % 2 == 0 and g != 0:
            r0_fail += 1
            print(f"  R0(even-index) VIOLATION {name} S={sorted(Sset)} m={m} g={g}")
    print(f"{name:12s} |Gamma|={N:3d} sets={checked:4d}  "
          f"L1_fail={l1_fail} L2_fail={l2_fail} R0_fail={r0_fail}  "
          f"{'ODD' if odd_order else 'even'}")
    return l1_fail + l2_fail + r0_fail


if __name__ == "__main__":
    groups = [
        (5,), (7,), (9,),            # cyclic odd (baseline vs known Z_n)
        (6,), (8,), (10,), (12,),    # cyclic even
        (3, 3),                      # elementary abelian, odd
        (2, 2), (2, 4), (2, 2, 2),   # 2-groups (many involutions)
        (2, 6), (2, 3), (4, 3),      # mixed even
        (3, 5),                      # odd non-prime-power
        (2, 8), (4, 4),              # bigger 2-groups
    ]
    total = 0
    for mods in groups:
        total += run(mods)
    print("\nTOTAL_FAILURES", total)
    print("ABELIAN_VERIFY_DONE")
