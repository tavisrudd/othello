#!/usr/bin/env python3
"""Misère Node-Kayles on small boards (2026-07-03).

Misère play: the player who makes the LAST move loses; a player with no legal
move wins. Misère Grundy value G- : mex over options with G-(terminal) = 1
(single-game outcome: position is P (mover loses) iff G- = 0). No sum theory is
implied (misère Node-Kayles has no Sprague-Grundy additivity); values recorded
per-board for the record.

Boards: plane queens (the misère A344227 analog), torus queens, knights, grid,
kings, bishops, rooks, hypercubes. Normal-play values printed alongside.
"""
import sys, time
sys.setrecursionlimit(1000000)
from involution_census import build_attacks, hypercube_att

LIMIT = 30_000_000  # memo-entry safety cap (box is busy)

class TooBig(Exception):
    pass

def mis_value(att, full):
    memo = {}
    def g(avail):
        if avail == 0:
            return 1
        v = memo.get(avail)
        if v is not None:
            return v
        if len(memo) > LIMIT:
            raise TooBig
        seen = set()
        a = avail
        while a:
            b = a & -a
            s = b.bit_length() - 1
            a ^= b
            seen.add(g(avail & ~att[s]))
        v = 0
        while v in seen:
            v += 1
        memo[avail] = v
        return v
    return g(full), len(memo)

def nrm_value(att, full):
    memo = {}
    def g(avail):
        if avail == 0:
            return 0
        v = memo.get(avail)
        if v is not None:
            return v
        if len(memo) > LIMIT:
            raise TooBig
        seen = set()
        a = avail
        while a:
            b = a & -a
            s = b.bit_length() - 1
            a ^= b
            seen.add(g(avail & ~att[s]))
        v = 0
        while v in seen:
            v += 1
        memo[avail] = v
        return v
    return g(full)

def mis_win(att, full, deadline):
    """Outcome only (mover wins?), most-forcing ordering, alpha-beta style."""
    memo = {}
    def w(avail):
        if avail == 0:
            return True
        v = memo.get(avail)
        if v is not None:
            return v
        if time.time() > deadline or len(memo) > LIMIT:
            raise TooBig
        moves = []
        a = avail
        while a:
            b = a & -a
            s = b.bit_length() - 1
            a ^= b
            ch = avail & ~att[s]
            moves.append((bin(ch).count('1'), ch))
        moves.sort()
        res = False
        for _, ch in moves:
            if not w(ch):
                res = True
                break
        memo[avail] = res
        return res
    return w(full)

def run_family(name, piece, wr, wc, ns, budget=240):
    vals_m, vals_n = [], []
    for n in ns:
        att = build_attacks(n, piece, wr, wc)
        full = (1 << (n*n)) - 1
        t0 = time.time()
        try:
            gm, sz = mis_value(att, full)
            gn = nrm_value(att, full)
            vals_m.append(str(gm))
            vals_n.append(str(gn))
            print(f'  {name} n={n}: G-={gm}  G={gn}  '
                  f'[{sz} misere positions, {time.time()-t0:.1f}s]')
        except TooBig:
            print(f'  {name} n={n}: value DAG too big; trying outcome only')
            try:
                res = mis_win(att, full, time.time() + budget)
                print(f'  {name} n={n}: misere outcome = '
                      f'{"FIRST (N)" if res else "SECOND (P)"} [outcome-only]')
            except TooBig:
                print(f'  {name} n={n}: SKIPPED (cap)')
            break
        if time.time() - t0 > budget:
            print(f'  {name}: stopping (budget)')
            break
    if vals_m:
        print(f'  {name}: G- sequence {",".join(vals_m)}   '
              f'G sequence {",".join(vals_n)}')

if __name__ == '__main__':
    print('== misere Node-Kayles values (G-) with normal values (G) alongside ==')
    run_family('plane queens', 'queen', False, False, range(1, 9))
    run_family('torus queens', 'queen', True, True, range(1, 10))
    run_family('plane knights', 'knight', False, False, range(1, 6))
    run_family('plane grid', 'grid', False, False, range(1, 6))
    run_family('plane kings', 'king', False, False, range(1, 6))
    run_family('plane bishops', 'bishop', False, False, range(1, 7))
    run_family('plane rooks', 'rook', False, False, range(1, 6))
    run_family('torus knights', 'knight', True, True, range(4, 7, 2))
    run_family('torus kings', 'king', True, True, range(4, 7, 2))
    print('  hypercubes:')
    for d in (1, 2, 3, 4):
        att = hypercube_att(d)
        full = (1 << len(att)) - 1
        gm, _ = mis_value(att, full)
        print(f'  Q_{d}: G-={gm}  G={nrm_value(att, full)}')
