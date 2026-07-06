"""Randomized stress test of the claim:
   every MAXIMAL partial-permutation cap in the q x q grid has EVEN size.
(If true => grid game always lasts an even # of moves => P2 wins => PG(2,q)=P, all q.)

Brute enumeration explodes past q=7, so we sample: random greedy maximal fills. A single
ODD maximal position falsifies the claim. Millions of even fills = strong evidence.
Runs even q (4,8) and hard odd q (9,11,13) — the claim, if real, is char-independent.
"""
import sys
import random
from itertools import product
from collections import Counter
from gf import GF


def build(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    N = len(cells)
    rc_mask = [0] * N
    for i, (r, c) in enumerate(cells):
        m = 0
        for j, (r2, c2) in enumerate(cells):
            if i != j and (r2 == r or c2 == c):
                m |= 1 << j
        rc_mask[i] = m
    line_third = [[0] * N for _ in range(N)]

    def cross(p, a, b):
        ux, uy = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        wx, wy = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(ux, wy), F.mul(uy, wx)) == 0

    for i in range(N):
        for j in range(N):
            if i == j:
                continue
            m = 0
            for k in range(N):
                if k != i and k != j and cross(cells[i], cells[j], cells[k]):
                    m |= 1 << k
            line_third[i][j] = m
    return N, rc_mask, line_third


def sample(q, trials, seed=1):
    N, rc_mask, line_third = build(q)
    ALL = (1 << N) - 1
    rnd = random.Random(seed)
    sizes = Counter()
    odd_example = None
    for _ in range(trials):
        chosen = 0
        forbidden = 0
        size = 0
        while True:
            avail = ALL & ~chosen & ~forbidden
            if avail == 0:
                break
            # pick a random set bit
            bits = []
            a = avail
            while a:
                y = a & (-a)
                a ^= y
                bits.append(y.bit_length() - 1)
            yi = rnd.choice(bits)
            nf = forbidden | rc_mask[yi]
            c = chosen
            while c:
                b = c & (-c)
                c ^= b
                nf |= line_third[yi][b.bit_length() - 1]
            chosen |= 1 << yi
            forbidden = nf
            size += 1
        sizes[size] += 1
        if size % 2 == 1 and odd_example is None:
            odd_example = (size, chosen)
    return sizes, odd_example


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [4, 8, 9, 11]
    trials = int(sys.argv[2]) if len(sys.argv) > 2 else 200000
    for q in qs:
        sizes, odd = sample(q, trials)
        dist = " ".join(f"{k}:{v}" for k, v in sorted(sizes.items()))
        odd_ct = sum(v for k, v in sizes.items() if k % 2 == 1)
        tag = "ALL EVEN" if odd_ct == 0 else f"*** {odd_ct} ODD FOUND -> CLAIM FALSE ***"
        print(f"q={q:>2} ({trials} fills): sizes {dist}   {tag}", flush=True)
    print("SAMPLE_DONE")
