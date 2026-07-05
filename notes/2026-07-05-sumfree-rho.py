"""NEW ATTACK: the rho-mirror.  rho = negation on the 6'-part (order coprime to 6),
identity on the {2,3}-Sylow G6.  It is an order-2 AUTOMORPHISM with fixed set = G6,
and (unlike plain negation) has NO O2/O3 bad pairs.

(1) Lemma rho: over rho-symmetric sum-free A, every non-fixed legal y has rho(y)
    legal and A U {y, rho(y)} sum-free.  0 violations => the 6'-part is fully
    mirror-neutralizable.
(2) Reduction target: outcome(G) == outcome(G6)?  (would make the outcome depend
    only on the {2,3}-Sylow subgroup.)
"""
import sys
from itertools import product
from functools import lru_cache
from math import gcd

sys.setrecursionlimit(1 << 20)


def part23(m):
    m6 = 1
    for p in (2, 3):
        while m % p == 0:
            m6 *= p
            m //= p
    return m6  # the {2,3}-part of the modulus


def make(mods):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple(0 for _ in mods)]
    N = len(elems)
    addm = [[idx[tuple((a + b) % m for a, b, m in zip(elems[i], elems[j], mods))]
             for j in range(N)] for i in range(N)]

    # rho per factor: z ≡ x (mod m6), z ≡ -x (mod m/m6)
    def rho_factor(x, m):
        m6 = part23(m)
        mp = m // m6
        for z in range(m):
            if z % m6 == x % m6 and (z % mp) == ((-x) % mp):
                return z
        raise RuntimeError

    rhotab = [rho_factor_all(e, mods, rho_factor, idx) for e in elems]
    # G6 = fixed set of rho = {2,3}-Sylow (elements whose 6'-part is 0)
    g6 = [i for i in range(N) if rhotab[i] == i]
    return elems, idx, zero, addm, rhotab, g6, N


def rho_factor_all(e, mods, rho_factor, idx):
    return idx[tuple(rho_factor(a, m) for a, m in zip(e, mods))]


def sumfree(A, addm):
    for a in A:
        for b in A:
            if addm[a][b] in A:
                return False
    return True


def outcome(mods_or_addm):
    """Outcome (P/N) of the sum-free game on the given group (mods)."""
    elems, idx, zero, addm, rhotab, g6, N = make(mods_or_addm)
    ground = [i for i in range(N) if i != zero]

    @lru_cache(maxsize=None)
    def win(A):
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sumfree(set(A2), addm) and not win(A2):
                return True
        return False
    return "N" if win(frozenset()) else "P"


def outcome_subgroup(mods, sub_idxset):
    """Outcome of the sum-free game restricted to a subgroup (given as index set,
    using the ambient addition)."""
    elems, idx, zero, addm, rhotab, g6, N = make(mods)
    ground = [i for i in sub_idxset if i != zero]

    @lru_cache(maxsize=None)
    def win(A):
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sumfree(set(A2), addm) and not win(A2):
                return True
        return False
    return "N" if win(frozenset()) else "P"


def lemma_rho(mods, cap=60000):
    elems, idx, zero, addm, rhotab, g6, N = make(mods)
    ground = [i for i in range(N) if i != zero]
    l2bad = tested = 0
    seen = {frozenset(): None}
    stack = [frozenset()]
    while stack:
        A = stack.pop()
        for y in ground:
            if y in A or rhotab[y] == y:   # skip fixed (G6) elements
                continue
            if not sumfree(set(A) | {y}, addm):
                continue
            ry = rhotab[y]
            tested += 1
            A2 = frozenset(set(A) | {y, ry})
            if ry == zero or ry == y or ry in A or not sumfree(A2, addm):
                l2bad += 1
                if l2bad <= 3:
                    print(f"    RHOFAIL {mods} A={[ ''.join(map(str,elems[a])) for a in A]}"
                          f" y={''.join(map(str,elems[y]))} ry={''.join(map(str,elems[ry]))}")
            elif A2 not in seen and len(A2) < N and len(seen) < cap:
                seen[A2] = None
                stack.append(A2)
    return l2bad, tested, len(g6)


if __name__ == "__main__":
    print("=== (1) Lemma rho: automorphism-mirror step (negate 6'-part, fix {2,3}) ===")
    for mods in [(5,), (7,), (5, 3), (7, 3), (25, 3), (5, 9), (35,), (5, 3, 3),
                 (7, 3, 3), (2, 5), (2, 5, 3), (5, 2, 2), (11, 6)]:
        bad, tested, ng6 = lemma_rho(mods)
        lbl = "x".join(f"Z{m}" for m in mods)
        print(f"  {lbl:12s} |G6|={ng6:2d}  rho-tests={tested:6d}  VIOLATIONS={bad}  "
              f"{'OK' if bad == 0 else '*** FAIL ***'}")

    print("\n=== (2) reduction target: outcome(G) vs outcome(G6 = {2,3}-Sylow) ===")
    for mods in [(5, 3), (7, 3), (25, 3), (5, 9), (5, 3, 3), (7, 3, 3),
                 (2, 5), (2, 5, 3), (5, 2, 2), (35, 3), (5, 2, 9)]:
        oG = outcome(mods)
        _, _, _, _, _, g6, _ = make(mods)
        oG6 = outcome_subgroup(mods, set(g6))
        lbl = "x".join(f"Z{m}" for m in mods)
        flag = "" if oG == oG6 else "   <<< MISMATCH"
        print(f"  {lbl:12s} outcome(G)={oG}  outcome(G6)={oG6}  |G6|={len(g6)}{flag}")
    print("RHO_DONE")
