r"""Isolate the central-symmetry parity lemma from the special-line poisoning.

Claim (the lemma): if S is a GENUINELY sigma_c-symmetric legal grid position and x is a
legal P1 move OFF the center's row/column, then sigma_c(x) is a legal reply (S U {x,
sigma_c(x)} legal).

Test: pure sigma_c mirror, but restrict P1 to BULK moves only (never the center's row/col),
so S stays exactly sigma_c-symmetric throughout. Count any reply that is illegal ('sigma'
violations). If 0 for all q, the lemma holds and the q>=9 failures seen elsewhere are due
ONLY to special-line moves breaking sigma_c-symmetry, not to the lemma.
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def test(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    h = F.inv(2 % q)

    def collinear(p, a, b):
        u0, u1 = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        w0, w1 = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(u0, w1), F.mul(u1, w0)) == 0

    def legal_to_add(S, p):
        if p in S:
            return False
        for s in S:
            if s[0] == p[0] or s[1] == p[1]:
                return False
        Sl = list(S)
        for i in range(len(Sl)):
            for j in range(i + 1, len(Sl)):
                if collinear(p, Sl[i], Sl[j]):
                    return False
        return True

    bad = [0]
    checked = [0]

    def run(c):
        m0, m1 = c

        def sigma(x):
            return (F.sub(F.add(m0, m0), x[0]), F.sub(F.add(m1, m1), x[1]))

        seen = set()

        def dfs(S):
            key = frozenset(S)
            if key in seen:
                return
            seen.add(key)
            for p in cells:
                d0 = F.sub(p[0], m0); d1 = F.sub(p[1], m1)
                if d0 == 0 or d1 == 0:        # restrict P1 to BULK moves -> S stays sigma-sym
                    continue
                if not legal_to_add(S, p):
                    continue
                r = sigma(p)
                checked[0] += 1
                S1 = S | {p}
                if r == p or not legal_to_add(S1, r):
                    bad[0] += 1
                    continue
                dfs(S1 | {r})
        dfs(frozenset())

    # start from each dead center's move-then-mirror seed (bulk first move p, reply sigma(p))
    for p in cells:
        d0 = F.sub(p[0], p[0]);  # unused
        c = (F.add(p[0], h), F.add(p[1], h))
        x2 = (F.add(p[0], 1 % q), F.add(p[1], 1 % q))
        if legal_to_add({p}, x2):
            run(c)
    print(f"q={q:>2}  checked={checked[0]:>8}  sigma_lemma_violations={bad[0]:>4}  "
          f"-> {'LEMMA HOLDS' if bad[0] == 0 else 'LEMMA VIOLATED'}", flush=True)
    return bad[0] == 0


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7, 9, 11, 13]
    allok = True
    for q in qs:
        allok &= test(q)
    print("SIGMA_LEMMA_DONE" + ("" if allok else "  (VIOLATION)"))
