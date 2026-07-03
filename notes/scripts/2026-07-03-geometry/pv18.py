#!/usr/bin/env python3
# Geometric analysis of the n=18 winning PV. Pure arithmetic, no solver.
n = 18
pv_str = "I9 K8 G10 J11 H3 M7 N16 E4 P6 D12 O13 F2 R5 L17 A14".split()
def parse(m):
    c = ord(m[0]) - ord('A')
    r = int(m[1:]) - 1
    return (c, r)
pv = [parse(m) for m in pv_str]

def attacks(a, b):
    (c1, r1), (c2, r2) = a, b
    return c1 == c2 or r1 == r2 or c1 - r1 == c2 - r2 or c1 + r1 == c2 + r2

# 1. legality: mutually non-attacking, and each move available when played
board = [(c, r) for c in range(n) for r in range(n)]
avail = set(board)
traj = []
for i, m in enumerate(pv):
    assert m in avail, f"move {i+1} {pv_str[i]} not available!"
    deleted = {s for s in avail if s == m or attacks(m, s)}
    avail -= deleted
    traj.append((pv_str[i], len(deleted), len(avail)))
print("legal PV; per-move (name, deleted, avail-after):")
print(" ".join(f"{a}:-{d}={v}" for a, d, v in traj))
print("final avail:", len(avail), "(0 = game over, mover stuck)")

# 2. line membership
def lines(m):
    c, r = m
    out = []
    if c == r: out.append("mainDiag")
    if c + r == n - 1: out.append("antiDiag")
    return out
print("\nlong-diagonal members:", {pv_str[i]: lines(m) for i, m in enumerate(pv) if lines(m)})

# 3. symmetry relations: rho (180 rot), tau (point reflection through I9=(8,8))
def rho(m): return (n - 1 - m[0], n - 1 - m[1])
def tau(m): return (16 - m[0], 16 - m[1])
idx = {m: i for i, m in enumerate(pv)}
print("\nrho-pairs inside PV:", [(pv_str[i], pv_str[idx[rho(m)]]) for i, m in enumerate(pv) if rho(m) in idx and idx[rho(m)] > i])
print("tau-pairs inside PV:", [(pv_str[i], pv_str[idx[tau(m)]]) for i, m in enumerate(pv) if tau(m) in idx and idx[tau(m)] > i])

# 4. reply structure: is winner's reply tau(opponent's previous move)?
for i in range(1, len(pv), 2):
    opp, rep = pv[i], pv[i + 1] if i + 1 < len(pv) else None
    if rep:
        t = tau(opp)
        print(f"opp {pv_str[i]} -> winner {pv_str[i+1]}; tau(opp)={chr(t[0]+65)}{t[1]+1}", "MATCH" if rep == t else "")

# 5. winner vs loser move geometry: distance from board center (8.5, 8.5), diag distance
print("\nper-move: player, dist-to-center (Chebyshev, x10), min-dist-to-a-long-diagonal")
for i, (c, r) in enumerate(pv):
    dc = max(abs(c - 8.5), abs(r - 8.5))
    dd = min(abs(c - r), abs(c + r - (n - 1)))
    print(f"  {pv_str[i]:>4} P{1 + i % 2}  cheb={dc:4.1f}  diagdist={dd}")

# 6. embedded 17x17 reading: I9=(8,8) is the exact center of sub-board [0..16]^2.
#    L-border = col 17 or row 17. Which PV moves are in the border?
border = [pv_str[i] for i, (c, r) in enumerate(pv) if c == 17 or r == 17]
print("\nL-border (col R / row 18) moves:", border)
# after I9, live border squares (not attacked by I9):
live_b = [s for s in board if (s[0] == 17 or s[1] == 17) and s != (8, 8) and not attacks((8, 8), s)]
print("live L-border squares after I9:", len(live_b))
