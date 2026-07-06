#!/usr/bin/env python3
"""Characterize the *1-class: enumerate all reachable positions of the Z_{3p}
sum-free game, profile which have nimber *1, and look for a structural signature
that children of {p,e} cannot have."""
from nim_solver import Solver

def profile(p):
    n=3*p
    s=Solver(n)
    P,Q = p, (2*p)%n   # order-3 elements
    # enumerate reachable canonical positions by DFS from empty, memoizing grundy fills memo
    s.grundy(frozenset())  # fills memo with all reachable canonical positions
    # classify each memoized canonical position
    byval={}
    feats1=[]   # feature rows for *1 positions
    for key,g in s.memo.items():
        A=frozenset(key)
        byval[g]=byval.get(g,0)+1
        if g==1:
            sym = (frozenset((-x)%n for x in A)==A)
            has_o3 = (P in A) or (Q in A)
            # order-3 alive: is P or Q a legal move (given not present)?
            o3_alive = s.sumfree_add_ok(A,P) or s.sumfree_add_ok(A,Q) or has_o3
            # defect: elements whose negation is absent
            defect = sorted([x for x in A if (-x)%n not in A])
            feats1.append((tuple(sorted(A)), sym, has_o3, o3_alive, len(A), len(defect)))
    print(f"===== p={p}  Z{n}   #canon positions={len(s.memo)} =====")
    print(f"  nimber histogram over all reachable canon positions: {dict(sorted(byval.items()))}")
    # summarize *1 features
    print(f"  #(*1 positions) = {len(feats1)}")
    from collections import Counter
    sig = Counter((sym,has_o3,o3_alive,dlen) for (_,sym,has_o3,o3_alive,sz,dlen) in feats1)
    print("  *1 signature (symmetric, has_order3, order3_alive, defect_size) -> count:")
    for k,v in sorted(sig.items()):
        print(f"     sym={k[0]} has_o3={k[1]} o3_alive={k[2]} defect={k[3]:>2} : {v}")
    # do ANY *1 positions contain an order-3 element AND have order-3 dead? (the Fact-B-like class)
    # sample a few *1 positions
    print("  sample *1 positions (as int sets):")
    for row in feats1[:8]:
        print(f"     {row[0]}  sym={row[1]} has_o3={row[2]} o3_alive={row[3]} |A|={row[4]} defect={row[5]}")
    return byval, feats1

if __name__=="__main__":
    for p in [7,11,13]:
        profile(p)
        print()
