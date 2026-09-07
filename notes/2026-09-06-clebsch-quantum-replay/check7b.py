import sys
sys.path.insert(0, "/tmp/claude-1000/-home-tavis-src-othello-rust/"
                   "936bbcce-b386-4c99-97f5-4318b618ed8d/scratchpad/"
                   "clebsch-replay")
import itertools
from common import data, rank_mod
import check7 as c7

p = 11
E, EXPS, _ = data(p)
base = frozenset(frozenset(pair) for pair in c7.BASE[p])
G = c7.pgl2(p)
orbit = {}
for g in G:
    M = frozenset(frozenset(c7.act(g, x, p) for x in pair) for pair in base)
    orbit.setdefault(M, []).append(g)
Pbase = c7.prod_matching(base, p)
ALL = [e for e in itertools.product(range(5), repeat=3) if sum(e) == 4]
ALL.sort()
rows_full = []
for M in orbit:
    q, r = c7.divide_by_Q(c7.psub(c7.prod_matching(M, p), Pbase, p), p)
    rows_full.append([q.get(e, 0) % p for e in ALL])
print("full 22x15 coefficient matrix rank over F_11 :", rank_mod(rows_full, p))
cols10 = [ALL.index(e) for e in EXPS]
sub = [[r[j] for j in cols10] for r in rows_full]
print("rank of the 10 stated columns                :", rank_mod(sub, p))
extra = [j for j in range(15) if j not in cols10]
print("stated monomials are", len(cols10), "of 15; omitted:",
      [ALL[j] for j in extra])
print("omitted columns nonzero somewhere:",
      [any(r[j] for r in rows_full) for j in extra])
