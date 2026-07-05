"""GP(p,k): Node-Kayles on Cay(F_p, k-th power residues).

Undirected requires -1 in S. For k=3 this holds for all p=1 mod 3 (p>3);
for k=4 it holds exactly for p=1 mod 8. We verify -1 in S per prime and skip
otherwise (directed) and skip complete graphs (S = all of F_p^*).

Tabulate G against "2 is a k-th power residue mod p" (2 in S).

usage: python3 run_gp.py k NMAX
"""

import sys

from arith_cayley import (
    kth_power_residues,
    cayley_adj_mod,
    game_G,
    primes_up_to,
    MemoCap,
)

k = int(sys.argv[1]) if len(sys.argv) > 1 else 3
NMAX = int(sys.argv[2]) if len(sys.argv) > 2 else 400
# cap keyed below the 800MB ulimit; skip (not abort) a prime whose memo overflows.
CAP = int(sys.argv[3]) if len(sys.argv) > 3 else 1_800_000

print(f"== GP(p,{k}) scan, p up to {NMAX} ==", flush=True)
print(
    "  (S = nonzero k-th power residues; deg=|S|=(p-1)/gcd(k,p-1); "
    "'2 in S' = 2 is a k-th power residue)",
    flush=True,
)

rows = []  # (p, deg, two_in_S, G, memo)
exceptions = []
skipped = []
for p in primes_up_to(NMAX):
    S = kth_power_residues(p, k)
    if len(S) == p - 1:
        continue  # complete graph (gcd(k,p-1)=1): degenerate, G=1 trivially
    if (p - 1) not in S:
        continue  # -1 not a k-th power => directed graph, skip
    deg = len(S)
    two_in_S = 2 in S
    adj = cayley_adj_mod(p, S)
    try:
        G, memo = game_G(adj, p, cap=CAP)
    except MemoCap:
        skipped.append(p)
        print(f"  p={p:4d}  deg={deg:4d}  SKIPPED (memo>cap)", flush=True)
        continue
    rows.append((p, deg, two_in_S, G, memo))
    if G == 0:
        exceptions.append(p)
    print(
        f"  p={p:4d}  deg={deg:4d}  2 is {k}th-power:{str(two_in_S):5s}  "
        f"G={G}  memo={memo}",
        flush=True,
    )

print(f"\n-- GP(p,{k}) summary --", flush=True)
print(f"primes computed: {len(rows)}   skipped(memo): {skipped}", flush=True)
print(f"EXCEPTIONS (G=0): {exceptions}", flush=True)
# dichotomy split by the arithmetic condition
good = [(p, G) for (p, d, t, G, m) in rows if t]   # 2 IS a k-th power
bad = [(p, G) for (p, d, t, G, m) in rows if not t]  # 2 is NOT
print(
    f"'2 is a {k}th-power' side: {len(good)} primes, "
    f"G=0 at {[p for p, G in good if G == 0]}",
    flush=True,
)
print(
    f"'2 not a {k}th-power' side: {len(bad)} primes, "
    f"G=0 at {[p for p, G in bad if G == 0]}",
    flush=True,
)
