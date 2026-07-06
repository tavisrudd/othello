r"""Second candidate for the q-odd special-line handling: sigma_c on the bulk, and answer
a center's-ROW move with a center's-COLUMN move (and vice versa), chosen ADAPTIVELY, so
the two 1-cell special resources cancel in parity and pure bulk-mirroring resumes.

We let P2 CHOOSE the special reply (branch over all legal center-col cells for a row move,
etc.) and ask: does P2 have SOME choice that stays stuck-free? i.e. is P2's move set
{ sigma_c on bulk } U { any legal special reply on the special lines } winning?

DFS: at each P1 move, if bulk -> forced sigma_c reply (must be legal, else this line is a
LOSS for the strategy). If special -> P2 tries every legal special reply; the position is
'good' if AT LEAST ONE reply leads to an all-good continuation. Report whether every P1
first move admits a fully-good strategy tree.
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def verify(q, cap_positions=4_000_000):
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

    budget = [cap_positions]

    def run_after_first(S0, c):
        m0, m1 = c

        def sigma(x):
            return (F.sub(F.add(m0, m0), x[0]), F.sub(F.add(m1, m1), x[1]))

        memo = {}

        def good(S):
            # True if the sigma_c-on-bulk + adaptive-special strategy is stuck-free from S
            # (S is a position with P1 to move).
            key = frozenset(S)
            if key in memo:
                return memo[key]
            budget[0] -= 1
            if budget[0] < 0:
                raise TimeoutError
            ok = True
            for p in cells:
                if not legal_to_add(S, p):
                    continue
                d0 = F.sub(p[0], m0); d1 = F.sub(p[1], m1)
                S1 = S | {p}
                if d0 != 0 and d1 != 0:                     # bulk -> forced sigma reply
                    r = sigma(p)
                    if r == p or not legal_to_add(S1, r) or not good(S1 | {r}):
                        ok = False
                        break
                else:                                       # special -> P2 picks best reply
                    if d0 == 0:                              # row move -> reply on center col
                        cands = [(rr, m1) for rr in range(q) if (rr, m1) != c]
                    else:                                    # col move -> reply on center row
                        cands = [(m0, cc) for cc in range(q) if (m0, cc) != c]
                    found = False
                    for r in cands:
                        if legal_to_add(S1, r) and good(S1 | {r}):
                            found = True
                            break
                    if not found:
                        ok = False
                        break
            memo[key] = ok
            return ok

        return good(frozenset(S0))

    all_good = True
    bad_first = 0
    try:
        for p in cells:
            c = (F.add(p[0], h), F.add(p[1], h))
            x2 = (F.add(p[0], 1 % q), F.add(p[1], 1 % q))
            if not legal_to_add({p}, x2):
                all_good = False; bad_first += 1; continue
            if not run_after_first({p, x2}, c):
                all_good = False; bad_first += 1
    except TimeoutError:
        print(f"q={q}: budget exceeded", flush=True)
        return False
    print(f"q={q:>2}  bad_first_moves={bad_first:>3}  "
          f"-> {'ADAPTIVE STRATEGY WINS' if all_good else 'FAILS'}", flush=True)
    return all_good


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7]
    allok = True
    for q in qs:
        allok &= verify(q)
    print("QODD_ADAPTIVE_DONE" + ("" if allok else "  (SOME FAIL)"))
