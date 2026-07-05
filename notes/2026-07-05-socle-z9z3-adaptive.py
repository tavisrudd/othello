"""Test adaptive-mirror strategies for Z9xZ3=N from a socle center o.
Each strategy is a reply(y, A) -> element (or None). Verify it wins vs ALL
opponent lines from {o}: reply must be legal, fresh, and lead to a hero win.
"""
from itertools import product
import sys
sys.setrecursionlimit(1000000)
def gadd(x,y): return ((x[0]+y[0])%9,(x[1]+y[1])%3)
def gneg(x):   return ((-x[0])%9,(-x[1])%3)
ELTS=[(i,j) for i in range(9) for j in range(3)];Z=(0,0)
NZ=[x for x in ELTS if x!=Z]
def is_sf(A):
    S=set(A)
    for a in A:
        for b in A:
            if gadd(a,b) in S: return False
    return True
def order(x):
    n=1;y=x
    while y!=Z:y=gadd(y,x);n+=1
    return n

o=(0,1)
def negoy(y): return gneg(gadd(o,y))
def negy(y):  return gneg(y)

def make_adversary(reply):
    """reply(y,A,S) returns hero's reply element. Verify hero wins from {o}."""
    seen={}
    def opp(A):        # A: opp to move
        if A in seen: return seen[A]
        S=set(A); ok=True
        for y in NZ:
            if y in S: continue
            if is_sf(A|{y}):
                r=reply(y, A)
                if r is None or r in S or r==y or not is_sf(A|{y,r}):
                    seen[A]=False; return False
                if not opp(frozenset(A|{y,r})):
                    seen[A]=False; return False
        seen[A]=ok; return ok
    return opp(frozenset({o}))

def legalize(y,A,cands):
    S=set(A)
    for r in cands:
        if r not in S and r!=y and is_sf(A|{y,r}):
            return r
    return None

strategies = {
 "always -o-y":            lambda y,A: negoy(y),
 "always -y":              lambda y,A: negy(y),
 "socle:-o-y, ord9:-y":    lambda y,A: negoy(y) if order(y)==3 else negy(y),
 "-o-y else -y":           lambda y,A: legalize(y,A,[negoy(y),negy(y)]),
 "-y else -o-y":           lambda y,A: legalize(y,A,[negy(y),negoy(y)]),
 "socle:-o-y; ord9:-o-y else -y": lambda y,A: negoy(y) if order(y)==3 else legalize(y,A,[negoy(y),negy(y)]),
 "socle:-o-y; ord9:-y else -o-y": lambda y,A: negoy(y) if order(y)==3 else legalize(y,A,[negy(y),negoy(y)]),
}
for name,reply in strategies.items():
    r=make_adversary(reply)
    print(f"  {'WINS' if r else 'FAILS'}: {name}")
