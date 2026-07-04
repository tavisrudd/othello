#!/usr/bin/env python3
"""Strategy compiler: pairing-plus-exceptions defense extraction (S2 probe).

Given a P-position P0 whose defender is the second player to move inside P0,
compile the full defense (every intruder move at every reachable P-node):
  reply pi(s) (a fixed point-reflection pairing) when it is live and winning;
  otherwise mint or reuse an exception keyed by the intruder square s.
Measures how close the winning strategy is to "S1 pairing punctuated by
bounded repair events" (Conjecture S2 shape), and sizes the
mirror-plus-exception-table certificate (backlog item 6).

Drivers:
  n=6  : all winning opening classes (defender = first player after opening w)
  n=8  : the unique winning opening c* = (3,3)
  n=10 : the refuted diagonal openings (d,d) — defender = second player,
         book reply t, then defense of R_e minus N[t]
  n=12 : same as n=10 (six diagonal classes; heavier)
"""
import sys, os, time
from collections import Counter

sys.setrecursionlimit(1000000)
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', '2026-07-03-geometry'))
from small_boards import build          # noqa: E402
from cgtlib import closed_pairing       # noqa: E402
from d1_verify import Board, bits       # noqa: E402


def make_win(att):
    memo = {}

    def win(a):
        if a == 0:
            return False
        v = memo.get(a)
        if v is not None:
            return v
        opts = []
        x = a
        while x:
            b = x & -x
            i = b.bit_length() - 1
            ch = a & ~att[i]
            opts.append((ch.bit_count(), ch))
            x ^= b
        opts.sort()
        res = False
        for _, ch in opts:
            if not win(ch):
                res = True
                break
        memo[a] = res
        return res
    return win, memo


def make_pi(bd, a, b):
    """Point reflection about center (a/2, b/2): (r,c) -> (a-r, b-c)."""
    n = bd.n
    pi = {}
    for s in range(bd.N):
        r, c = divmod(s, n)
        r2, c2 = a - r, b - c
        if 0 <= r2 < n and 0 <= c2 < n:
            pi[s] = r2 * n + c2
    return pi


def sweep_centers(bd, win, P0, centers=None, top=6):
    """Depth-1 coverage of each candidate point-reflection center on P0:
    fraction of intruder moves s for which pi(s) is a live winning reply."""
    att = bd.att
    if centers is None:
        centers = [(a, b) for a in range(2 * bd.n - 1)
                   for b in range(2 * bd.n - 1)]
    scored = []
    live = list(bits(P0))
    for (a, b) in centers:
        pi = make_pi(bd, a, b)
        cov = 0
        for s in live:
            C = P0 & ~att[s]
            t = pi.get(s)
            if t is not None and (C >> t) & 1 and not win(C & ~att[t]):
                cov += 1
        scored.append((cov / len(live), (a, b)))
    scored.sort(reverse=True)
    return scored[:top]


class Defense:
    def __init__(self, bd, win, pi, s1_cap=26):
        self.bd = bd
        self.win = win
        self.pi = pi
        self.s1_cap = s1_cap
        self.table = {}          # s -> [replies, in mint order]
        self.stats = Counter()
        self.trig = Counter()
        self.mints = []          # (P, s, trig, r, s1_status, resid_n)
        self.memo = {}           # P-node -> max exception events below

    def reply(self, P, C, s):
        att = self.bd.att
        t = self.pi.get(s)
        if t is not None and (C >> t) & 1 and not self.win(C & ~att[t]):
            self.stats['paired'] += 1
            return t, False
        if t is None:
            trig = 'off_board'
        elif (P >> t) & 1 and (att[s] >> t) & 1:
            trig = 'self_strike'        # s kills its own partner
        elif not (P >> t) & 1:
            trig = 'scar'               # partner was already dead
        else:
            trig = 'pair_invalid'       # partner live & legal but loses
        self.trig[trig] += 1
        for r in self.table.get(s, []):
            if (C >> r) & 1 and not self.win(C & ~att[r]):
                self.stats['exc_reuse'] += 1
                return r, True
        # mint: most-forcing winning reply
        best = None
        for m in bits(C):
            ch = C & ~att[m]
            if not self.win(ch):
                k = ch.bit_count()
                if best is None or k < best[0]:
                    best = (k, m, ch)
        assert best is not None, "P-node child must be refutable"
        _, r, resid = best
        entry = self.table.setdefault(s, [])
        entry.append(r)
        self.stats['exc_mint'] += 1
        if len(entry) > 1:
            self.stats['key_conflict'] += 1
        s1 = None
        nres = resid.bit_count()
        if nres <= self.s1_cap:
            sym = resid == self.bd.mask_rho(resid)
            s1 = 'sym' if sym else (
                'pairing' if closed_pairing(list(bits(resid)), self.bd.att)
                is not None else 'none')
        self.mints.append((P, s, trig, r, s1, nres))
        return r, True

    def defend(self, P):
        if P == 0:
            return 0
        v = self.memo.get(P)
        if v is not None:
            return v
        att = self.bd.att
        best = 0
        for s in bits(P):
            C = P & ~att[s]
            r, exc = self.reply(P, C, s)
            sub = self.defend(C & ~att[r])
            ev = sub + (1 if exc else 0)
            if ev > best:
                best = ev
        self.memo[P] = best
        return best

    def report(self, tag):
        entries = sum(len(v) for v in self.table.values())
        s1c = Counter(m[4] for m in self.mints)
        print(f"  [{tag}] P-nodes={len(self.memo)} decisions="
              f"{self.stats['paired']+self.stats['exc_mint']+self.stats['exc_reuse']} "
              f"paired={self.stats['paired']} "
              f"exceptions(mint={self.stats['exc_mint']}, "
              f"reuse={self.stats['exc_reuse']}) "
              f"table: keys={len(self.table)} entries={entries} "
              f"conflicts={self.stats['key_conflict']}")
        print(f"        max exception events on a line={self.maxev}  "
              f"triggers={dict(self.trig)}  mint-residual S1 status={dict(s1c)}")

    def run(self, P0):
        self.maxev = self.defend(P0)
        return self


def compile_one(bd, win, P0, pi, tag):
    d = Defense(bd, win, pi).run(P0)
    d.report(tag)
    return d


def winner_defense(n, w_list, full_sweep=True):
    """Defender = the player who just played w (P0 = full minus N[w] is P)."""
    bd = Board(n)
    win, _ = make_win(bd.att)
    for w in w_list:
        wsq = w[0] * n + w[1]
        P0 = bd.full & ~bd.att[wsq]
        assert not win(P0), f"{w} is not a winning opening at n={n}"
        print(f"\nn={n} opening {w} (|P0|={P0.bit_count()}):")
        t0 = time.time()
        if full_sweep:
            top = sweep_centers(bd, win, P0)
            print(f"  best point-reflection centers (depth-1 coverage): "
                  f"{[(f'{c:.2f}', ab) for c, ab in top]}"
                  f"  [tau_w center = {(2*w[0], 2*w[1])}]")
            best_center = top[0][1]
        else:
            best_center = (2 * w[0], 2 * w[1])
        compile_one(bd, win, P0, make_pi(bd, *best_center),
                    f"pi=refl{best_center}")
        tw = (2 * w[0], 2 * w[1])
        if tw != best_center:
            compile_one(bd, win, P0, make_pi(bd, *tw), f"pi=tau_w{tw}")
        print(f"  [{time.time()-t0:.1f}s]")


def refuter_defense(n, d_list, full_sweep=False, t_budget=None):
    """P-board: second player refutes diagonal opening e=(d,d); book reply t,
    then compile the defense of R_e minus N[t]."""
    bd = Board(n)
    win, memo = make_win(bd.att)
    for d in d_list:
        e = d * n + d
        R = bd.full & ~bd.att[e]
        t0 = time.time()
        wr = [m for m in bits(R) if not win(R & ~bd.att[m])]
        assert wr, f"(d,d)={d} not refuted at n={n}?"
        print(f"\nn={n} diagonal opening ({d},{d}): {len(wr)} winning replies "
              f"[{time.time()-t0:.0f}s to enumerate]")
        # choose book reply: best depth-1 shortlist coverage among refuters
        er, ec = d, d
        cands = []
        for t in (wr if t_budget is None else wr[:t_budget]):
            tr, tc = divmod(t, n)
            P0 = R & ~bd.att[t]
            centers = [(2 * er, 2 * ec), (2 * tr, 2 * tc),
                       (er + tr, ec + tc), (n - 1, n - 1)]
            sc = sweep_centers(bd, win, P0, centers=centers, top=1)
            cands.append((sc[0][0], t, sc[0][1]))
        cands.sort(reverse=True)
        cov, t, center = cands[0]
        tr, tc = divmod(t, n)
        print(f"  book reply t=({tr},{tc}) center={center} "
              f"depth-1 coverage {cov:.2f} "
              f"(candidates tried: {len(cands)})")
        P0 = R & ~bd.att[t]
        if full_sweep:
            top = sweep_centers(bd, win, P0)
            print(f"  full-sweep best centers: "
                  f"{[(f'{c:.2f}', ab) for c, ab in top]}")
            if top[0][0] > cov:
                center = top[0][1]
        compile_one(bd, win, P0, make_pi(bd, *center),
                    f"e=({d},{d}) t=({tr},{tc}) pi=refl{center}")
        print(f"  [{time.time()-t0:.1f}s, win-memo {len(memo)}]")


if __name__ == '__main__':
    which = sys.argv[1] if len(sys.argv) > 1 else '6'
    if which == '6':
        winner_defense(6, [(2, 2), (1, 1), (0, 0), (1, 2), (0, 2)])
    elif which == '8':
        winner_defense(8, [(3, 3)])
    elif which == '10':
        refuter_defense(10, [4, 3, 2, 1, 0], full_sweep=True)
    elif which == '12':
        refuter_defense(12, [5, 4, 3, 2, 1, 0], t_budget=6)
