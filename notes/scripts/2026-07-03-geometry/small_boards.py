#!/usr/bin/env python3
"""Brute-force Node-Kayles on queen graphs, small n.
Enumerates ALL winning openings (D4 classes) and tests the max-deletion law.
Pure Python, bitmask memoized alpha-beta (win/loss). Single-threaded, CPU-light.
"""
import sys, time
sys.setrecursionlimit(100000)

def build(n):
    N = n * n
    attacks = [0] * N
    for r in range(n):
        for c in range(n):
            i = r * n + c
            m = 0
            for rr in range(n):
                for cc in range(n):
                    j = rr * n + cc
                    if rr == r or cc == c or rr - cc == r - c or rr + cc == r + c:
                        m |= 1 << j
            attacks[i] = m  # closed neighborhood (includes self)
    return attacks

def solve(n, verbose=True):
    attacks = build(n)
    N = n * n
    full = (1 << N) - 1
    memo = {}
    nodes = [0]

    def win(avail):
        if avail == 0:
            return False
        v = memo.get(avail)
        if v is not None:
            return v
        nodes[0] += 1
        # move list ordered most-forcing first (smallest child popcount)
        moves = []
        a = avail
        while a:
            b = a & -a
            i = b.bit_length() - 1
            child = avail & ~attacks[i]
            moves.append((bin(child).count('1'), child))
            a ^= b
        moves.sort()
        res = False
        for _, child in moves:
            if not win(child):
                res = True
                break
        memo[avail] = res
        return res

    # D4 orbit representatives of squares
    def sym_maps(n):
        fs = [lambda r, c: (r, c), lambda r, c: (c, n-1-r), lambda r, c: (n-1-r, n-1-c),
              lambda r, c: (n-1-c, r), lambda r, c: (r, n-1-c), lambda r, c: (n-1-r, c),
              lambda r, c: (c, r), lambda r, c: (n-1-c, n-1-r)]
        return fs
    fs = sym_maps(n)
    seen = set()
    reps = []
    for r in range(n):
        for c in range(n):
            if (r, c) in seen:
                continue
            orbit = {f(r, c) for f in fs}
            seen |= orbit
            reps.append((r, c))

    t0 = time.time()
    results = []
    for (r, c) in reps:
        i = r * n + c
        child = full & ~attacks[i]
        opp_wins = win(child)
        deleted = bin(attacks[i] & full).count('1')
        diag = ('main' if r == c else '') + ('anti' if r + c == n - 1 else '')
        results.append(((r, c), deleted, diag or '-', not opp_wins))
    board_win = any(w for _, _, _, w in results)
    dt = time.time() - t0
    print(f"n={n}: board is {'FIRST' if board_win else 'SECOND'}-player win  "
          f"({len(reps)} D4 root classes, {nodes[0]} nodes, {len(memo)} memo, {dt:.1f}s)")
    results.sort(key=lambda x: -x[1])
    maxdel = results[0][1]
    for (r, c), d, diag, w in results:
        star = ' <== MAX-DELETION' if d == maxdel else ''
        print(f"   ({r},{c}) del={d:3d} diag={diag:8s} {'WINNING' if w else 'losing '}{star}")
    return results

if __name__ == '__main__':
    for n in [4, 5, 6, 7, 8]:
        solve(n)
        print()
