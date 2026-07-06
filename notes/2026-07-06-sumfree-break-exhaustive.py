#!/usr/bin/env python3
"""EXHAUSTIVE check of the mirror-break lemma over ALL reachable single-defect
boards (unbiased). A 'single-defect board' here: sum-free B with exactly one
element d whose negation is absent, containing an order-3 element p, 2p dead.

Lemma to verify: break-set(B) = { -w : w in {2d, d+p, d*inv2}, -w legal in B, w mirror-illegal }.
Also report the true frequency of '-d illegal' (Rita's escape blocked)."""
from nim_solver import Solver

def inv2(n): return (n+1)//2

def defects(B, n):
    return [x for x in B if (-x)%n not in B]

def is_order3(x,p,n): return x==p%n or x==(2*p)%n

def check(p):
    n=3*p; s=Solver(n)
    s.grundy(frozenset())   # enumerate all reachable canonical positions
    P=p%n; Q=(2*p)%n
    tested=0; mism=0; md_ill=0; examples=[]
    seen=set()
    for key in s.memo:
        B=frozenset(key)
        # we need an ACTUAL board (not just canonical rep) that is single-defect
        # with an order-3 element present and its partner dead. Use the canonical
        # rep directly; check structure.
        Bset=set(B)
        # order-3 present?
        o3=[x for x in B if is_order3(x,p,n)]
        if not o3: continue
        pp=o3[0]              # the present order-3 element
        # its partner must be dead (absent + illegal): for symmetric-ish boards the
        # other order-3 is (-pp)%n; require it's absent
        if (-pp)%n in Bset: continue   # both order-3 present -> not our class
        d=defects(B,n)
        # single defect besides possibly the order-3 element itself:
        # order-3 pp has partner (-pp) absent so pp is itself a 'defect' in the raw sense.
        # remove the order-3 element from defect accounting (it's structurally the p):
        nd=[x for x in d if x!=pp]
        if len(nd)!=1: continue
        dd=nd[0]
        if is_order3(dd,p,n): continue
        tested+=1
        legals=set(z for z in range(n) if s.sumfree_add_ok(B,z))
        breaks=set(z for z in legals if (-z)%n not in legals and (-z)%n not in Bset)
        pred=set()
        for w in [(2*dd)%n, (dd+pp)%n, (dd*inv2(n))%n]:
            z=(-w)%n
            if z in legals and (w not in legals) :   # w mirror-illegal (blocked)
                pred.add(z)
        if breaks!=pred:
            mism+=1
            if len(examples)<8:
                examples.append((sorted(B),pp,dd,sorted(breaks),sorted(pred),
                                 sorted(breaks-pred),sorted(pred-breaks)))
        if (-dd)%n not in legals: md_ill+=1
    print(f"p={p} Z{n}: single-defect boards tested={tested}  break-set mismatches={mism}  (-d illegal={md_ill})")
    for ex in examples:
        B,pp,dd,br,pr,extra,miss=ex
        print(f"   MISM B={B} p={pp} d={dd}")
        print(f"        breaks={br} pred={pr}  extra_in_breaks={extra} missing_from_breaks={miss}")

if __name__=="__main__":
    for p in [7,11,13]:
        check(p)
