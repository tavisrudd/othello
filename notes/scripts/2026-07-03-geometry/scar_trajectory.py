#!/usr/bin/env python3
"""tau-scar trajectory of the n=18 winning PV (pure arithmetic, extends pv18.py).
After each PV move: scar set Delta = {s in avail & S : tau(s) not avail},
live border arms, whether the move hit Delta / had a live tau-partner,
and whether the winner's reply is tau(opponent's move).
"""
n = 18
pv_str = "I9 K8 G10 J11 H3 M7 N16 E4 P6 D12 O13 F2 R5 L17 A14".split()
def parse(m):
    return (ord(m[0]) - ord('A'), int(m[1:]) - 1)   # (col, row)
pv = [parse(m) for m in pv_str]

def attacks(a, b):
    (c1, r1), (c2, r2) = a, b
    return c1 == c2 or r1 == r2 or c1 - r1 == c2 - r2 or c1 + r1 == c2 + r2

def tau(s): return (16 - s[0], 16 - s[1])
def in_S(s): return s[0] <= 16 and s[1] <= 16
def is_border(s): return s[0] == 17 or s[1] == 17

board = [(c, r) for c in range(n) for r in range(n)]
avail = set(board)

print("ply  move  player  region  inDelta?  tauLive?  |Delta|  border(colR,row18)  isTauOfPrev")
prev = None
for i, mv in enumerate(pv):
    player = 'W' if i % 2 == 0 else 'L'   # W = first player (winner)
    region = 'border' if is_border(mv) else 'S'
    # scar status BEFORE the move
    delta_before = {s for s in avail if in_S(s) and tau(s) not in avail}
    in_delta = mv in delta_before
    tau_live = in_S(mv) and tau(mv) in avail and tau(mv) != mv
    is_tau_prev = (prev is not None and in_S(prev) and mv == tau(prev))
    deleted = {s for s in avail if s == mv or attacks(mv, s)}
    avail -= deleted
    delta = {s for s in avail if in_S(s) and tau(s) not in avail}
    col_arm = sum(1 for s in avail if s[0] == 17)
    row_arm = sum(1 for s in avail if s[1] == 17)
    print(f"{i+1:3d}  {pv_str[i]:>4}  {player}       {region:6s}  "
          f"{str(in_delta):5s}     {str(tau_live):5s}     {len(delta):3d}      "
          f"({col_arm:2d},{row_arm:2d})            {'TAU' if is_tau_prev else ''}")
    prev = mv

print("\n(after move 1 = I9 the S-part is exactly tau-symmetric: |Delta| should be 0)")
