"""Validate the 'always P' proof of the cap-set achievement game on F_3^d.

Game: build a cap (no 3 collinear = no distinct a,b,c with a+b+c=0) in F_3^d,
add one point per move, last to move wins (normal play).

Claimed P2 (responder) strategy proving G=0 for all d:
  - P1 opens with a point `a`. P2 replies any `b != a`. Let c = -(a+b) be the
    THIRD point of the opening line {a,b,c}; c is now permanently unplayable
    (the line {a,b,c} would form with a,b already down).
  - Thereafter P2 answers each P1 move y with sigma_c(y) = 2c - y (affine point
    reflection through c). sigma_c is an affine automorphism (preserves caps),
    fixed-point-free off c, and {c, y, sigma_c(y)} is always a line, so the only
    obstruction to the mirror needs c on the board -- which never happens.

This script:
  (1) brute-force Grundy G(d) for d=1,2,3 (must be 0),
  (2) SIMULATE P2's strategy against ALL P1 play (adversarial tree over P1 moves,
      P2 deterministic) for d=1,2,3 and spot-check d=4 -- verify P2's reply is
      ALWAYS legal (never stuck) and P1 is always the first stuck (P2 wins).
"""

import sys
from itertools import product
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def make(d):
    N = 3 ** d
    pts = list(product(*[range(3)] * d))
    idx = {p: i for i, p in enumerate(pts)}

    def add(i, j):
        return idx[tuple((a + b) % 3 for a, b in zip(pts[i], pts[j]))]

    def neg(i):
        return idx[tuple((-a) % 3 for a in pts[i])]

    def refl(y, c):  # 2c - y
        return idx[tuple((2 * cc - yy) % 3 for cc, yy in zip(pts[c], pts[y]))]

    # third point of the line through i,j  ( -(i+j) )
    def third(i, j):
        return idx[tuple((-(a + b)) % 3 for a, b in zip(pts[i], pts[j]))]

    return N, add, neg, refl, third


def forbidden(A, third):
    """points that would complete a line with two members of cap A."""
    f = set()
    Al = sorted(A)
    for x in range(len(Al)):
        for y in range(x + 1, len(Al)):
            f.add(third(Al[x], Al[y]))
    return f


def legal_moves(A, N, third):
    f = forbidden(A, third)
    return [y for y in range(N) if y not in A and y not in f]


def grundy_bruteforce(d):
    N, add, neg, refl, third = make(d)

    @lru_cache(maxsize=None)
    def g(A):  # A = frozenset
        opts = set()
        for y in legal_moves(set(A), N, third):
            opts.add(g(A | frozenset([y])))
        mex = 0
        while mex in opts:
            mex += 1
        return mex

    return g(frozenset())


def verify_strategy(d, test_all_b=False, p1_random_cap=None):
    """Return (ok, detail). Simulate P2's mirror strategy vs all P1 play."""
    N, add, neg, refl, third = make(d)

    # For each opening a, P2 picks b (smallest != a, or all if test_all_b),
    # sets c = third(a,b), and mirrors via reflection through c.
    def run_opening(c):
        memo = {}

        def p1_to_move(Afs):
            """Afs = frozenset, a P2-symmetric cap (mirror through c), c blocked.
            True iff P2 always replies legally and P1 is first stuck."""
            if Afs in memo:
                return memo[Afs]
            A = set(Afs)
            moves = legal_moves(A, N, third)
            res = True
            if moves:
                for y in moves:
                    yp = refl(y, c)
                    if yp == y or yp in A or yp == c:
                        res = False
                        break  # strategy broken (mate coincides / already down)
                    A2 = A | {y}
                    if yp in forbidden(A2, third):
                        res = False
                        break  # mirror reply illegal -> proof FAILS
                    if not p1_to_move(frozenset(A2 | {yp})):
                        res = False
                        break
            memo[Afs] = res
            return res

        return p1_to_move

    bad = []
    for a in range(N):
        bs = [b for b in range(N) if b != a]
        if not test_all_b:
            bs = bs[:1]
        for b in bs:
            c = third(a, b)
            solver = run_opening(c)
            if not solver(frozenset({a, b})):
                bad.append((a, b, c))
    return (len(bad) == 0, bad)


if __name__ == "__main__":
    print("=== brute Grundy G(d) (expect 0) ===")
    for d in [1, 2, 3]:
        print(f"  d={d}: G={grundy_bruteforce(d)}")
    print("=== strategy verification (P2 mirror beats ALL P1 play) ===")
    for d in [1, 2, 3]:
        ok, bad = verify_strategy(d, test_all_b=(d <= 2))
        print(f"  d={d}: P2 wins all lines = {ok}"
              + ("" if ok else f"  FAILURES: {bad[:5]}"))
    # spot-check d=4 with the smallest-b strategy (full tree; may be big)
    print("=== d=4 spot check (smallest-b strategy, full P1 tree) ===")
    ok, bad = verify_strategy(4, test_all_b=False)
    print(f"  d=4: P2 wins all lines = {ok}"
          + ("" if ok else f"  FAILURES: {bad[:5]}"))
    print("CAPSET_PROOF_DONE")
