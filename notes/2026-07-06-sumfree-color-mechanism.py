#!/usr/bin/env python3
"""Hypothesis (c): a 3-element {p,d1,d2} can be ∗1 ONLY when it is F3-monochromatic
(all three elements same color mod 3 => no F3-Schur constraint couples them).
Children of {p,3} (carry color-0 elt) and {p,1} (carry color-1 elt vs p's color)
would then be excluded when they are NOT monochromatic.

Test: over all 3-element {p,d1,d2}, correlate nimber==1 with F3-monochromaticity,
and report the color multiset of every ∗1 case."""
from nim_solver import Solver
from collections import Counter

def is_o3(x,p,n): return x==p%n or x==(2*p)%n

def test(p):
    n=3*p; s=Solver(n)
    P=p%n
    elts=[x for x in range(1,n) if not is_o3(x,p,n)]
    seen=set()
    mono_star1=0; nonmono_star1=0; star1_list=[]
    mono_tot=Counter(); mono_by_g=Counter()
    for i in range(len(elts)):
        for jx in range(i+1,len(elts)):
            d1,d2=elts[i],elts[jx]
            A={P,d1,d2}
            cs=set(A)
            if any((a+b)%n in cs for a in A for b in A): continue
            key=s.canon(frozenset(A))
            if key in seen: continue
            seen.add(key)
            g=s.grundy(frozenset(A))
            colors=tuple(sorted(x%3 for x in A))
            mono = len(set(colors))==1
            mono_tot[mono]+=1
            if g==1:
                star1_list.append((sorted(A),colors,mono))
                if mono: mono_star1+=1
                else: nonmono_star1+=1
    print(f"p={p} (p mod3={p%3}) Z{n}:  #3-elt sets={sum(mono_tot.values())}  "
          f"mono={mono_tot[True]} nonmono={mono_tot[False]}")
    print(f"   ∗1: mono={mono_star1} nonmono={nonmono_star1}   "
          f"{'HYP (c) HOLDS: all ∗1 are monochromatic' if nonmono_star1==0 else 'HYP (c) FAILS'}")
    for (A,cols,mono) in star1_list:
        print(f"      ∗1 set {A}  F3-colors={cols}  mono={mono}")

if __name__=="__main__":
    for p in [7,11,13,17,19,23]:
        test(p)
