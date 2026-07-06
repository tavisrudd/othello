r"""Test a candidate P2 winning strategy for the q-ODD grid game (= residual of PG(2,q)
after the opening pair, handoff R2). If stuck-free for all P1 lines, it is a q-odd
planar theorem candidate.

Grid = F_q x F_q, cell (a0,a1) [a0=row, a1=col]. Legal position: <=1 cell/row, <=1/col
(partial permutation) AND no 3 collinear. P1 moves first.

Candidate strategy tau (a single fixed-point-free-except-center involution PAIRING):
P1's FIRST move x1 fixes the center  c = x1 + (h,h),  h = 1/2 in F_q  (so tau(x1)=x2).
For every P1 move x, P2 replies tau(x), where with offset d = x - c:
  - d0 != 0 and d1 != 0  (off the center's row and column):  tau(x) = 2c - x   [central symmetry]
  - d0 == 0  (on center's ROW):     tau(x) = c + (d1, 0)     [transpose-through-c cross]
  - d1 == 0  (on center's COL):     tau(x) = c + (0, d0)
  - d == 0 is the center c itself (collinear with x1,x2 => dead, never played).
tau is an involution; its only fixed point is c (dead). Key grid fact: each of the
center's row / column can ever hold <=1 cell, so the cross branch fires <=2 times total.

Verify: for every P1 first move x1 and every P1 continuation, tau(x) is legal and never
stuck  =>  P2 always answers  =>  P1 runs out first  =>  P2 wins.
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def verify(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    h = F.inv(2 % q)                     # 1/2 in F_q (q odd)

    def collinear(p, a, b):
        u0, u1 = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        w0, w1 = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(u0, w1), F.mul(u1, w0)) == 0

    def legal_to_add(S, p):
        if p in S:
            return False
        for s in S:
            if s[0] == p[0] or s[1] == p[1]:       # same row or same column
                return False
        Sl = list(S)
        for i in range(len(Sl)):
            for j in range(i + 1, len(Sl)):
                if collinear(p, Sl[i], Sl[j]):
                    return False
        return True

    stats = {'illegal_reply': 0, 'positions': 0, 'cross_fires': 0, 'maxlen': 0,
             'setup_illegal': 0, 'bad_cross': 0, 'bad_sigma': 0}

    def run_after_first(S0, c):
        # continuations after P1's first move p and P2's reply tau(p); center c fixed.
        def tau(x):
            d0 = F.sub(x[0], c[0]); d1 = F.sub(x[1], c[1])
            if d0 != 0 and d1 != 0:
                return (F.sub(F.add(c[0], c[0]), x[0]), F.sub(F.add(c[1], c[1]), x[1]))
            if d0 == 0:                            # center's row -> center's col
                return (F.add(c[0], d1), c[1])
            else:                                  # center's col -> center's row
                return (c[0], F.add(c[1], d0))

        seen = set()

        def dfs(S):
            key = frozenset(S)
            if key in seen:
                return
            seen.add(key)
            stats['positions'] += 1
            stats['maxlen'] = max(stats['maxlen'], len(S))
            for p in cells:
                if not legal_to_add(S, p):
                    continue
                r = tau(p)
                S1 = S | {p}
                d0 = F.sub(p[0], c[0]); d1 = F.sub(p[1], c[1])
                is_cross = (d0 == 0 or d1 == 0)
                if is_cross:
                    stats['cross_fires'] += 1
                if r == p or not legal_to_add(S1, r):
                    stats['illegal_reply'] += 1
                    stats['bad_cross' if is_cross else 'bad_sigma'] += 1
                    continue
                dfs(S1 | {r})
        dfs(frozenset(S0))

    # P1's FIRST move p (all cells); P2 sets center c = p+(h,h) and replies tau(p)=p+(1,1).
    centers = set()
    for p in cells:
        c = (F.add(p[0], h), F.add(p[1], h))
        centers.add(c)
        x2 = (F.add(p[0], 1 % q), F.add(p[1], 1 % q))   # = 2c - p
        if not legal_to_add({p}, x2):
            stats['setup_illegal'] += 1
            continue
        run_after_first({p, x2}, c)

    ok = stats['illegal_reply'] == 0 and stats['setup_illegal'] == 0
    print(f"q={q:>2}  first-moves={len(cells):>3}  positions={stats['positions']:>7}  "
          f"maxcap={stats['maxlen']:>2}  setup_bad={stats['setup_illegal']:>3}  "
          f"illegal={stats['illegal_reply']:>4} (sigma={stats['bad_sigma']},cross={stats['bad_cross']})  "
          f"-> {'TAU WINS (verified)' if ok else 'TAU FAILS'}", flush=True)
    return ok


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7]
    allok = True
    for q in qs:
        allok &= verify(q)
    print("QODD_MIRROR_VERIFY_DONE" + ("" if allok else "  (FAILURE)"))
