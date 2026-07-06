#!/usr/bin/env python3
"""Sharp target: is a 3-element position {p, d1, d2} (order-3 p + two non-order-3
elements, sum-free) EVER ∗1?  And what is the nimber distribution?

Also test the cleaner conjecture: a two-defect position {p}∪Sym∪{d1,d2} is ∗1 only
if Sym != empty (has >=1 colored mirror-pair)."""
from nim_solver import Solver
from collections import Counter

def is_o3(x,p,n): return x==p%n or x==(2*p)%n

def test(p):
    n=3*p; s=Solver(n)
    P=p%n
    dist=Counter()
    star1=[]
    # all unordered pairs {d1,d2} of distinct non-order-3 elements with {p,d1,d2} sum-free
    elts=[x for x in range(1,n) if not is_o3(x,p,n)]
    seen=set()
    for i in range(len(elts)):
        for jx in range(i+1,len(elts)):
            d1,d2=elts[i],elts[jx]
            A={P,d1,d2}
            # sum-free?
            cs=set(A); okB=all((a+b)%n not in cs for a in A for b in A)
            if not okB: continue
            key=s.canon(frozenset(A))
            if key in seen: continue
            seen.add(key)
            g=s.grundy(frozenset(A))
            dist[g]+=1
            if g==1: star1.append(sorted(A))
    print(f"p={p} Z{n}: 3-element {{p,d1,d2}} nimber distribution (canon-distinct): {dict(sorted(dist.items()))}")
    print(f"   #(3-element {{p,d1,d2}} that are ∗1) = {len(star1)}   {'<-- TARGET HOLDS (zero)' if not star1 else star1[:8]}")
    return dist,star1

if __name__=="__main__":
    for p in [7,11,13,17,19,23]:
        test(p)
