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
    return add,neg,ELTS,Z,NZ,is_sf,order
def book(mods):
    add,neg,ELTS,Z,NZ,is_sf,order=make(mods)
    socle=[x for x in NZ if order(x)==3]; o=socle[0]
    bulkfail=[0]; soclefail=[0]; seen={}
    def opp(A):
        if A in seen: return seen[A]
        S=set(A)
        for y in NZ:
            if y in S or not is_sf(A|{y}): 
                if y in S: continue
                else: continue
            if order(y)!=3:
                z=neg(y)
                if z==y or z in S or not is_sf(A|{y,z}) or not opp(frozenset(A|{y,z})):
                    bulkfail[0]+=1; seen[A]=False; return False
            else:
                ok=False
                for r in socle:
                    if r in S or r==y: continue
                    if is_sf(A|{y,r}) and opp(frozenset(A|{y,r})): ok=True; break
                if not ok:
                    soclefail[0]+=1; seen[A]=False; return False
        seen[A]=True; return True
    r=opp(frozenset({o}))
    return r,bulkfail[0],soclefail[0],len(seen)
for mods in [(3,5),(3,7),(3,11),(9,3),(3,3,5),(3,3,7),(3,3,11)]:
    r,bf,sf,ns=book(mods)
    print(f"{str(mods):12} socle-only book: {'WINS' if r else 'FAILS'}  bulk-fails={bf} socle-fails={sf}  (nodes {ns})")
