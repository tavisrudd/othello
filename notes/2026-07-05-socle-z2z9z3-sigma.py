"""Does ChatGPT's sigma-mirror extend to Z2 x (Z9 x Z3) (s2=1, r3=2, non-elementary)?
G = Z2 x V, V = Z9 x Z3. m=(1,(0,0)). For a in V\{0}, p=(0,a), sigma(eps,v)=(1-eps,a-v).
Test {m,p} P via sigma mirror adversarially, for a = socle vs order-9.
"""
from itertools import product
import sys
sys.setrecursionlimit(1000000)
def vadd(x,y): return ((x[0]+y[0])%9,(x[1]+y[1])%3)
def vsub(x,y): return ((x[0]-y[0])%9,(x[1]-y[1])%3)
def gadd(x,y): return ((x[0]+y[0])%2, vadd(x[1],y[1]))
V=[(i,j) for i in range(9) for j in range(3)]; ZV=(0,0)
ELTS=[(e,v) for e in (0,1) for v in V]
NZ=[x for x in ELTS if x!=(0,ZV)]
def is_sf(A):
    S=set(A)
    for a in A:
        for b in A:
            if gadd(a,b) in S: return False
    return True
def vorder(v):
    n=1;y=v
    while y!=ZV: y=vadd(y,v);n+=1
    return n

def sigma_mirror_wins(a):
    m=(1,ZV); p=(0,a)
    def sig(x):
        e,v=x
        return ((1-e)%2, vsub(a,v))
    if not is_sf({m,p}): return None
    base=frozenset({m,p}); seen={}
    def opp(A):
        if A in seen: return seen[A]
        S=set(A)
        for y in NZ:
            if y in S: continue
            if is_sf(A|{y}):
                z=sig(y)
                if z==y or z in S or not is_sf(A|{y,z}):
                    seen[A]=False; return False
                if not opp(frozenset(A|{y,z})):
                    seen[A]=False; return False
        seen[A]=True; return True
    return opp(base)

for a in [(0,1),(3,0),(3,1),(1,0),(1,1),(2,1)]:
    r=sigma_mirror_wins(a)
    print(f"  a={a} (V-order {vorder(a)}): sigma-mirror {'WINS' if r else 'FAILS'}")
