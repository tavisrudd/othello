#!/usr/bin/env python3
"""Test the interleaved one-defect / two-defect recursion that the ∗1-absent proof needs.

Colored-defect count of a position A (containing order-3 p, 2p dead):
  cd(A) = #{ non-order-3 x in A : -x not in A }   (unpaired colored elements)

Codex's key lemma (L): every TWO-defect position T with G(T) != 0 has a move to a
ONE-defect ∗1 position. If (L) holds, every two-defect position is != ∗1 (it's ∗0 or has
a ∗1-child), which is exactly '1 absent from {p,e}'s children'.

We (1) characterize which ONE-defect positions are ∗1, (2) test (L) exhaustively,
(3) look for the monovariant."""
from nim_solver import Solver
from collections import Counter

def is_o3(x,p,n): return x==p%n or x==(2*p)%n

def cdefect(A,p,n):
    return [x for x in A if not is_o3(x,p,n) and (-x)%n not in A]

def analyze(p):
    n=3*p; s=Solver(n)
    s.grundy(frozenset())               # fill memo with all reachable canon positions
    P=p%n
    one=[]; two=[]
    for key,g in s.memo.items():
        A=frozenset(key)
        if P not in A: continue          # want order-3 present, its structural role
        if (2*p)%n in A: continue         # both order-3 -> not our class (2p dead)
        d=cdefect(A,p,n)
        if len(d)==1: one.append((A,g,d[0]))
        elif len(d)==2: two.append((A,g,tuple(sorted(d))))
    print(f"===== p={p} Z{n} =====")
    print(f"  one-defect positions: {len(one)}   two-defect: {len(two)}")

    # (1) one-defect *1 characterization
    one_by_g = Counter(g for (_,g,_) in one)
    print(f"  one-defect nimber histogram: {dict(sorted(one_by_g.items()))}")
    # feature: pairs = (|A| - 1[p] - 1[defect]) / 2  = #symmetric mirror-pairs in colored part
    def pairs(A):
        return (len(A) - 1 - 1)//2      # minus p, minus the single defect
    rows=Counter()
    for (A,g,d) in one:
        rows[(pairs(A), g==1)] += 1
    print("  one-defect: (#colored-pairs, is_*1) -> count")
    par_star1=Counter(); par_tot=Counter()
    for (A,g,d) in one:
        par_tot[pairs(A)]+=1
        if g==1: par_star1[pairs(A)]+=1
    for k in sorted(par_tot):
        print(f"     pairs={k:>2}: *1 = {par_star1[k]:>4} / {par_tot[k]:>4}   ({100*par_star1[k]/par_tot[k]:.0f}%)")

    # (2) test lemma (L): every two-defect T with G!=0 has a child that is one-defect and *1
    one_set = set(A for (A,g,d) in one if g==1)   # one-defect *1 positions (as frozensets)
    Lfail=0; examples=[]
    for (A,g,dd) in two:
        if g==0: continue
        # children of A
        hit=False
        for z in s.legal(A):
            C=A | {z}
            # is C one-defect and *1?
            if len(cdefect(C,p,n))==1 and s.grundy(frozenset(C))==1:
                hit=True; break
        if not hit:
            Lfail+=1
            if len(examples)<6: examples.append((sorted(A),g,dd))
    print(f"  lemma (L): two-defect (G!=0) with NO one-defect-*1 child = {Lfail} / {sum(1 for (_,g,_) in two if g!=0)}")
    for ex in examples:
        print(f"     (L)-FAIL A={ex[0]} G=*{ex[1]} defects={ex[2]}")
    # also: are all two-defect positions != *1 ? (the target)
    two_star1=[ (sorted(A),dd) for (A,g,dd) in two if g==1]
    print(f"  two-defect positions with G==*1 (should be ZERO): {len(two_star1)}")
    for x in two_star1[:6]: print(f"     TWO-DEFECT *1: {x}")
    print()

if __name__=="__main__":
    for p in [7,11,13]:
        analyze(p)
