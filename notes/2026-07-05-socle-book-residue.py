"""Book-style residue test for odd G with 3-torsion = N.
Base mirror = negation. Exceptions = order-3 (socle) elements only.
Hero opens socle center o (order 3). Strategy:
  - opponent plays BULK move (order != 3): hero MUST reply -y (negation).
  - opponent plays SOCLE move (order 3): hero replies adaptively (search any
    winning reply) -- this is the 'book', bounded by r3.
Question: does this win?  If bulk-negation is never blocked and only the
bounded socle needs booking, the residue shrinks to the socle game.
Report, when it FAILS, whether the failure is a BULK move whose negation is
illegal (= genuine coupling residue) or a socle move with no winning book reply.
"""
from itertools import product
import sys
sys.setrecursionlimit(1000000)

def make(mods):
    n=len(mods)
    def add(x,y): return tuple((x[k]+y[k])%mods[k] for k in range(n))
    def neg(x):   return tuple((-x[k])%mods[k] for k in range(n))
    ELTS=[t for t in product(*[range(m) for m in mods])]
    Z=tuple(0 for _ in mods); NZ=[x for x in ELTS if x!=Z]
    def is_sf(A):
        S=set(A)
        for a in A:
            for b in A:
                if add(a,b) in S: return False
        return True
    def order(x):
        c=1;y=x
        while y!=Z:y=add(y,x);c+=1
        return c
    return add,neg,ELTS,Z,NZ,is_sf,order,n

def book_wins(mods, verbose=False):
    add,neg,ELTS,Z,NZ,is_sf,order,n=make(mods)
    socle=[x for x in NZ if order(x)==3]
    o=socle[0]
    bulk_fail=[]; socle_fail=[]
    seen={}
    def opp(A):   # opp to move; True = hero (book strategy) wins
        if A in seen: return seen[A]
        S=set(A)
        for y in NZ:
            if y in S: continue
            if not is_sf(A|{y}): continue
            if order(y)!=3:
                # BULK move: hero MUST negation-mirror
                z=neg(y)
                if z==y or z in S or not is_sf(A|{y,z}):
                    bulk_fail.append((frozenset(A),y,z)); seen[A]=False; return False
                if not opp(frozenset(A|{y,z})):
                    seen[A]=False; return False
            else:
                # SOCLE move: hero books adaptively -- any reply r leading to a win
                ok=False
                for r in NZ:
                    if r in S or r==y: continue
                    if is_sf(A|{y,r}) and opp(frozenset(A|{y,r})):
                        ok=True; break
                if not ok:
                    socle_fail.append((frozenset(A),y)); seen[A]=False; return False
        seen[A]=True; return True
    r=opp(frozenset({o}))
    return r, o, bulk_fail, socle_fail

for mods in [(3,7),(3,5),(9,3),(3,3,5),(3,3,3)]:
    r,o,bf,sf=book_wins(mods)
    tag=""
    if not r:
        tag=f"  [bulk-negation-blocked fails={len(bf)}, socle-book fails={len(sf)}]"
        if bf:
            A,y,z=bf[0]; tag+=f"\n      1st bulk fail: y={y}(bulk) neg={z} blocked in A={sorted(A)}"
    print(f"{mods}: book (bulk=negation, socle=adaptive) open {o} -> {'WINS' if r else 'FAILS'}{tag}")
