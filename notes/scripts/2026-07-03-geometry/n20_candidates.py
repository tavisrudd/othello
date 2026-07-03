#!/usr/bin/env python3
"""n=20 candidate first-move enumeration + rankings; even-n structural table."""
def closed_nbhd_size(n, r, c):
    row = n - 1; col = n - 1
    main = min(r, c) + min(n - 1 - r, n - 1 - c)
    anti = min(r, n - 1 - c) + min(n - 1 - r, c)
    return 1 + row + col + main + anti

print("=== even-n structural table (central main-diagonal strike c* = (m,m), m=n/2-1) ===")
print("  n  |N[c*]|  resid=(n-2)^2  liveL=2(n-2)  subLive=(n-2)(n-4)  L/sub   D4classes  verdict")
verd = {4: 'N (c* wins)', 6: 'N (c* wins)', 8: 'N (c* wins, unique)', 10: 'P (c* refuted 8/64)',
        12: 'P (c* refuted 100/100)', 14: 'P', 16: 'P', 18: 'N (c* wins = I9)', 20: '?', 22: '?'}
for n in range(4, 23, 2):
    m = n // 2 - 1
    cn = closed_nbhd_size(n, m, m)
    resid = (n - 2) ** 2
    liveL = 2 * (n - 2)
    sub = (n - 2) * (n - 4)
    print(f" {n:3d}   {cn:4d}      {resid:5d}          {liveL:3d}           {sub:4d}          "
          f"{liveL/sub if sub else 0:.3f}     {n*(n+2)//8:3d}      {verd.get(n,'?')}")

n = 20
print(f"\n=== n=20 diagonal root classes (all diagonal squares mod D4 = (d,d), d=0..9) ===")
print("  d  square   del=|N|  mirror-gap(19-2d)  window(2d+1)^2  liveOutsideWindow")
for d in range(10):
    cn = closed_nbhd_size(n, d, d)
    gap = n - 1 - 2 * d
    win_sz = (2 * d + 1) ** 2
    # live squares outside the tau_d window [0..2d]^2 after the strike at (d,d)
    cnt = 0
    for r in range(n):
        for c in range(n):
            if r <= 2 * d and c <= 2 * d:
                continue
            if (r, c) == (d, d) or r == d or c == d or r - c == 0 or r + c == 2 * d:
                continue
            cnt += 1
    print(f"  {d}  ({d},{d})    {cn:3d}        {gap:2d}                {win_sz:4d}           {cnt:4d}")

print("\n=== n=20 all 55 D4 classes by deletion count (root-ordering reference, top 12) ===")
seen = set()
rows = []
for r in range(n):
    for c in range(n):
        orbit = {(r, c), (c, n-1-r), (n-1-r, n-1-c), (n-1-c, r), (r, n-1-c), (n-1-r, c), (c, r), (n-1-c, n-1-r)}
        rep = min(orbit)
        if rep in seen:
            continue
        seen.add(rep)
        d = closed_nbhd_size(n, rep[0], rep[1])
        diag = rep[0] == rep[1] or rep[0] + rep[1] == n - 1
        rows.append((d, rep, diag))
rows.sort(key=lambda x: -x[0])
for d, rep, diag in rows[:12]:
    print(f"   {rep}  del={d}  {'DIAGONAL' if diag else '-'}")
print(f"   ... total classes: {len(rows)}, diagonal classes: {sum(1 for x in rows if x[2])}")
