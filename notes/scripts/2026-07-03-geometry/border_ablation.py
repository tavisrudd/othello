#!/usr/bin/env python3
"""Border-ablation mechanism tests for R_n = B_n after c*, even n = 8, 10, 12.
1. win(R & S): delete the live border entirely -> must be P (it IS B_{n-1} after
   center, Lemma 2). Machine-verifies the embedded-odd-center identity.
2. Modified game: intruder (mover in R) BANNED from border squares (responder free):
   does the intruder still win?  -> is the refutation's border usage essential
   *as intruder tempo*, or only as responder-scar side effects?
3. Modified game: responder banned instead (intruder free).
4. n=10: refutation PV from an S-square winning reply (does it route through border?).
"""
import sys
sys.setrecursionlimit(100000)
from small_boards import build

def popcount(x): return bin(x).count('1')

def analyze(n):
    attacks = build(n)
    N = n * n
    full = (1 << N) - 1
    m = n // 2 - 1
    cstar = m * n + m
    R = full & ~attacks[cstar]
    sub = 0
    for r in range(n - 1):
        for c in range(n - 1):
            sub |= 1 << (r * n + c)
    border = full & ~sub

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

    # banned-game: 'ban' applies to mover when flag set; flag alternates
    memo2 = {}
    def win_ban(avail, mover_banned):
        # mover_banned: current mover may not play border squares
        key = (avail, mover_banned)
        v = memo2.get(key)
        if v is not None:
            return v
        legal = avail & ~border if mover_banned else avail
        if legal == 0:
            memo2[key] = False   # mover stuck (banned squares don't count as moves)
            return False
        moves = []
        a = legal
        while a:
            b = a & -a
            i = b.bit_length() - 1
            moves.append((popcount(avail & ~attacks[i]), avail & ~attacks[i]))
            a ^= b
        moves.sort()
        res = False
        for _, child in moves:
            if not win_ban(child, not mover_banned):
                res = True
                break
        memo2[key] = res
        return res

    print(f"n={n}: R after c*=({m},{m}): {popcount(R)} live ({popcount(R & border)} border)")
    print(f"   win(R)          = {win(R)}   (True = intruder refutes c*)")
    print(f"   win(R & S)      = {win(R & sub)}   (border deleted; MUST be False by Lemma 2)")
    # win_ban(avail, X): X bans the CURRENT mover; flag alternates each ply.
    # Intruder moves first in R: intruder-ban = win_ban(R, True); responder-ban = win_ban(R, False).
    print(f"   win intruder-border-ban  = {win_ban(R, True)}   (intruder may never play border)")
    print(f"   win responder-border-ban = {win_ban(R, False)}   (responder may never play border)")

def pv_from(n, first):
    attacks = build(n)
    N = n * n
    full = (1 << N) - 1
    m = n // 2 - 1
    cstar = m * n + m
    R = full & ~attacks[cstar]
    sub = 0
    for r in range(n - 1):
        for c in range(n - 1):
            sub |= 1 << (r * n + c)
    border = full & ~sub
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
    fi = first[0] * n + first[1]
    line = []
    avail = R
    mover_intruder = True
    forced = fi
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
        if forced is not None:
            picked = next(mm for mm in moves if mm[1] == forced)
            forced = None
        elif mover_intruder:
            for pc, i, child in moves:
                if not win(child):
                    picked = (pc, i, child)
                    break
        else:
            picked = moves[0]
        pc, i, child = picked
        r, c = divmod(i, n)
        line.append((f"({r},{c})", 'INTRUDER' if mover_intruder else 'responder',
                     'border' if (border >> i) & 1 else 'S'))
        avail = child
        mover_intruder = not mover_intruder
    print(f"   n={n} refutation PV from S-square {first}: {line}")

if __name__ == '__main__':
    for n in [8, 10, 12]:
        analyze(n)
    pv_from(10, (2, 3))
