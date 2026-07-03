#!/usr/bin/env python3
"""Refutation geometry of the central-diagonal strike c* = (m,m), m = n/2-1, even n.
For n=8 (c* WINS): extract the winner's strategy line and its tau-structure.
For n=10, 12 (c* LOSES): enumerate ALL winning intruder replies in R_n, classify
them (border vs sub-board, tau-partner status, diag-dist), and test whether the
tau-mirror reply refutes each S-intruder move (P7 discriminator, depth-1 + PV).
"""
import sys
sys.setrecursionlimit(100000)
from small_boards import build

def popcount(x): return bin(x).count('1')

def analyze(n):
    attacks = build(n)
    N = n * n
    full = (1 << N) - 1
    memo = {}

    def win(avail):
        if avail == 0:
            return False
        v = memo.get(avail)
        if v is not None:
            return v
        moves = []
        a = avail
        while a:
            b = a & -a
            i = b.bit_length() - 1
            moves.append((popcount(avail & ~attacks[i]), avail & ~attacks[i]))
            a ^= b
        moves.sort()
        res = False
        for _, child in moves:
            if not win(child):
                res = True
                break
        memo[avail] = res
        return res

    m = n // 2 - 1
    cstar = m * n + m
    R = full & ~attacks[cstar]
    sub = 0  # sub-board S = [0..n-2]^2
    for r in range(n - 1):
        for c in range(n - 1):
            sub |= 1 << (r * n + c)

    def tau(i):
        r, c = divmod(i, n)
        tr, tc = (n - 2) - r, (n - 2) - c
        if 0 <= tr <= n - 2 and 0 <= tc <= n - 2:
            return tr * n + tc
        return None

    def name(i):
        r, c = divmod(i, n)
        return f"({r},{c})"

    def diagdist(i):
        r, c = divmod(i, n)
        return min(abs(r - c), abs(r + c - (n - 1)))

    def is_border(i):
        r, c = divmod(i, n)
        return r == n - 1 or c == n - 1

    r_is_win = win(R)
    print(f"n={n}: c*=({m},{m}) residual R ({popcount(R)} live) is "
          f"{'N (intruder wins -> c* refuted)' if r_is_win else 'P (c* WINS the board)'}")

    if not r_is_win:
        # extract winner's line: intruder plays most-forcing (all lose); responder plays a winning move
        line = []
        avail = R
        mover_is_intruder = True
        while avail:
            moves = []
            a = avail
            while a:
                b = a & -a
                i = b.bit_length() - 1
                moves.append((popcount(avail & ~attacks[i]), i, avail & ~attacks[i]))
                a ^= b
            moves.sort()
            picked = None
            if mover_is_intruder:
                picked = moves[0]  # any move loses; take most-forcing (engine-like)
            else:
                for pc, i, child in moves:
                    if not win(child):
                        picked = (pc, i, child)
                        break
                assert picked is not None
            pc, i, child = picked
            t = tau(i)
            line.append((name(i), 'intruder' if mover_is_intruder else 'RESPONDER',
                         'border' if is_border(i) else 'S', f"dd={diagdist(i)}",
                         f"tau={name(t) if t is not None else 'OFF'}"))
            avail = child
            mover_is_intruder = not mover_is_intruder
        print("  sample optimal line in R (responder = first player, winning):")
        for j, e in enumerate(line):
            print(f"   ply {j+1}: {e}")
        # tau-reply check: is responder's reply == tau(intruder's move)?
        for j in range(0, len(line) - 1, 2):
            im, rm = line[j], line[j + 1]
            print(f"   reply {j//2+1}: intruder {im[0]} -> responder {rm[0]}; tau(intruder)={im[4][4:]}"
                  + ("  TAU-MATCH" if rm[0] == im[4][4:] else ""))
        return

    # c* refuted: enumerate ALL winning intruder replies
    winners = []
    a = R
    while a:
        b = a & -a
        i = b.bit_length() - 1
        child = R & ~attacks[i]
        if not win(child):
            winners.append(i)
        a ^= b
    print(f"  winning intruder replies: {len(winners)} of {popcount(R)}")
    n_border = sum(1 for i in winners if is_border(i))
    print(f"  of which border: {n_border}; sub-board: {len(winners) - n_border}")
    for i in winners:
        t = tau(i)
        t_live = t is not None and (R >> t) & 1 and not (attacks[i] >> t) & 1
        tag = 'border' if is_border(i) else 'S'
        extra = ''
        if tag == 'S' and t_live:
            # does the tau-reply lose for the responder? (position after s, tau(s) is N = intruder wins)
            after = R & ~attacks[i] & ~attacks[t]
            extra = f" tau-reply {'FAILS (intruder still wins)' if win(after) else 'REFUTES?!'}"
        print(f"   {name(i)} [{tag}] dd={diagdist(i)} tau={'off-board' if t is None else name(t)}"
              f"{' tau-live' if t_live else ' tau-dead' if tag == 'S' else ''}{extra}")

    # PV of one refutation: intruder's winning strategy line from R
    best = winners[0]
    line = []
    avail = R
    mover_is_intruder = True
    first = True
    while avail:
        moves = []
        a = avail
        while a:
            b = a & -a
            i = b.bit_length() - 1
            moves.append((popcount(avail & ~attacks[i]), i, avail & ~attacks[i]))
            a ^= b
        moves.sort()
        picked = None
        if mover_is_intruder:
            if first:
                picked = next((mm for mm in moves if mm[1] == best))
                first = False
            else:
                for pc, i, child in moves:
                    if not win(child):
                        picked = (pc, i, child)
                        break
        else:
            picked = moves[0]  # responder lost: most-forcing
        pc, i, child = picked
        t = tau(i)
        line.append((name(i), 'INTRUDER' if mover_is_intruder else 'responder',
                     'border' if is_border(i) else 'S', f"dd={diagdist(i)}",
                     f"tau={name(t) if t is not None else 'OFF'}"))
        avail = child
        mover_is_intruder = not mover_is_intruder
    print(f"  sample refutation PV (intruder = second player, winning) from {name(best)}:")
    for j, e in enumerate(line):
        print(f"   ply {j+1}: {e}")

if __name__ == '__main__':
    for n in [8, 10, 12]:
        analyze(n)
        print()
