"""Verification for the THEOREM F3^n = N (first player wins), via move-then-mirror.

Strategy: P1 opens center o; replies to opponent y with sigma(y) = -o - y
(affine point-reflection through o, the unique fixed point).

(1) Reverse-engineering: on F3^3, extract P1's winning replies from the position
    {o} and confirm every reply equals sigma(y) = -(o+y).
(2) Lemma: over sigma-symmetric sum-free A (o in A), every legal y != o has
    A U {y, sigma y} sum-free.  0 violations => the strategy never gets stuck.
    Exhaustive for n=2,3; sampled (capped) for n=4.
"""
from itertools import product
from functools import lru_cache
import sys
sys.setrecursionlimit(1 << 20)


def build(n):
    elems = list(product(*[range(3) for _ in range(n)]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple([0] * n)]
    N = len(elems)
    add = [[idx[tuple((a + b) % 3 for a, b in zip(elems[i], elems[j]))]
            for j in range(N)] for i in range(N)]
    return elems, idx, zero, add, N


def sf_full(A, add):
    S = set(A)
    for a in A:
        for b in A:
            if add[a][b] in S:
                return False
    return True


def extract_f33():
    """Confirm P1's winning replies on F3^3 are exactly sigma(y) = -(o+y)."""
    elems, idx, zero, add, N = build(3)
    ground = [i for i in range(N) if i != zero]

    @lru_cache(maxsize=None)
    def win(A):
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sf_full(set(A2), add) and not win(A2):
                return True
        return False

    def winmove(A):
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sf_full(set(A2), add) and not win(A2):
                return x
        return None

    o = idx[(1, 0, 0)]
    assert win(frozenset()) and not win(frozenset([o]))
    mismatches = 0
    for y in ground:
        if y == o or not sf_full({o, y}, add):
            continue
        w = winmove(frozenset([o, y]))
        sig = idx[tuple((-elems[o][k] - elems[y][k]) % 3 for k in range(3))]
        if w != sig:
            mismatches += 1
    print(f"F3^3 strategy: all P1 replies == sigma(y)=-(o+y)?  "
          f"{'YES' if mismatches == 0 else f'NO ({mismatches} mismatch)'}")


def lemma(n, cap):
    elems, idx, zero, add, N = build(n)
    o = idx[tuple([1] + [0] * (n - 1))]
    sig = [idx[tuple((-elems[o][k] - elems[y][k]) % 3 for k in range(n))]
           for y in range(N)]
    fixed = sum(1 for y in range(N) if sig[y] == y)
    ground = [i for i in range(N) if i != zero]

    def stays_sf(Aset, y, sy):
        S = Aset | {y, sy}
        for nn in (y, sy):
            for a in S:
                if add[nn][a] in S or add[a][nn] in S:
                    return False
        return True

    bad = tested = 0
    seen = {frozenset([o])}
    stack = [frozenset([o])]
    while stack:
        A = stack.pop()
        Aset = set(A)
        for y in ground:
            if y in Aset or sig[y] == y:
                continue
            if not sf_full(Aset | {y}, add):
                continue
            sy = sig[y]
            tested += 1
            if sy == zero or sy == y or sy in Aset or not stays_sf(Aset, y, sy):
                bad += 1
            else:
                A2 = frozenset(Aset | {y, sy})
                if A2 not in seen and len(A2) < N and len(seen) < cap:
                    seen.add(A2)
                    stack.append(A2)
    ok = (bad == 0 and fixed == 1)
    print(f"F3^{n}: sigma fixed-pts={fixed} (want 1)  tests={tested}  "
          f"VIOLATIONS={bad}  symsets={len(seen)}  {'CLEAN' if ok else '*** FAIL ***'}")


if __name__ == "__main__":
    extract_f33()
    lemma(2, 10000)
    lemma(3, 50000)
    lemma(4, 120000)   # sampled; raise cap for more coverage
    print("MIRROR_CHECK_DONE")
