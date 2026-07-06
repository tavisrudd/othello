#!/usr/bin/env python3
"""Independent nimber solver for the sum-free achievement game on Z_n (cyclic).
Small n only. Memoized on the multiplier-canonical form of the played set.
Cross-checks the Go engine and lets us inspect child-nimber vectors / *1-children."""
import sys
from functools import lru_cache
sys.setrecursionlimit(100000)

def make(n):
    units = [u for u in range(1, n) if _gcd(u, n) == 1]
    def _gcd(a,b):
        while b: a,b=b,a%b
        return a
    return n, units

def gcd(a,b):
    while b: a,b=b,a%b
    return a

def units_of(n):
    return tuple(u for u in range(1,n) if gcd(u,n)==1)

class Solver:
    def __init__(self, n):
        self.n = n
        self.units = units_of(n)
        self.memo = {}
    def sumfree_add_ok(self, S, z):
        # S sum-free set (frozenset). Can we add z keeping sum-free?
        n=self.n
        if z in S: return False
        # z+z in S∪{z}?  2z==z impossible; 2z in S?
        if (2*z)%n in S: return False
        if (2*z)%n == z: return False
        for a in S:
            if (z+a)%n in S: return False        # z+a = c in S
            if (z+a)%n == z: return False        # a=0 impossible in sum-free anyway
            if (a+a)%n == z: return False        # a+a = z
            # existing pair summing to z: a+b=z
        # a+b=z for a,b in S:
        for a in S:
            if (z-a)%n in S: return False
        return True
    def legal(self, S):
        return [z for z in range(self.n) if self.sumfree_add_ok(S, z)]
    def canon(self, S):
        n=self.n
        best=None
        for u in self.units:
            t=frozenset((u*x)%n for x in S)
            key=tuple(sorted(t))
            if best is None or key<best: best=key
        return best
    def grundy(self, S):
        S=frozenset(S)
        key=self.canon(S)
        if key in self.memo: return self.memo[key]
        moves=self.legal(S)
        vals=set()
        for z in moves:
            vals.add(self.grundy(S | {z}))
        m=0
        while m in vals: m+=1
        self.memo[key]=m
        return m
    def child_nimbers(self, S):
        S=frozenset(S)
        out={}
        for z in self.legal(S):
            out[z]=self.grundy(S | {z})
        return out

def hist(cn):
    h={}
    for v in cn.values(): h[v]=h.get(v,0)+1
    return dict(sorted(h.items()))

if __name__=="__main__":
    import argparse
    # quick self-check vs Go engine: {11,3} and {11,1} in Z33
    for (p,e,expect) in [(11,3,{0:7,2:4,4:1,5:6,6:5,7:1}),
                         (11,1,{0:5,2:6,5:7,6:6}),
                         (13,3,{0:10,2:7,3:2,5:1,6:2,7:5,8:3}),
                         (13,1,{0:7,2:5,3:10,5:1,7:4,8:3})]:
        n=3*p
        s=Solver(n)
        cn=s.child_nimbers({p,e})
        h=hist(cn)
        mex=0
        while mex in h: mex+=1
        ok = (h==expect)
        print(f"{{{p},{e}}} Z{n}: hist={h} mex=*{mex}  match_go={ok}")
