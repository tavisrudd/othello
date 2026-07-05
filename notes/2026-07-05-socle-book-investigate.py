"""Dissect the single socle-book failure of the book strategy
(bulk=negation, socle=socle-only adaptive) on Z9xZ3 and Z5xZ3^2.
At the failing position: opponent's socle move y; for each candidate socle reply r,
report whether it's bulk-blocked (illegal) or legal-but-loses; and whether a BULK
reply would have won. This tells us if the residue is closable by a slightly larger
book (e.g. allow one bulk-repair) or is a genuine obstruction.
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

def run(mods,label):
    add,neg,ELTS,Z,NZ,is_sf,order,n=make(mods)
    socle=[x for x in NZ if order(x)==3]
    o=socle[0]
    fails=[]
    seen={}
    def opp(A):
        if A in seen: return seen[A]
        S=set(A)
        for y in NZ:
            if y in S: continue
            if not is_sf(A|{y}): continue
            if order(y)!=3:
                z=neg(y)
                if z==y or z in S or not is_sf(A|{y,z}) or not opp(frozenset(A|{y,z})):
                    seen[A]=False; return False
            else:
                ok=False
                for r in socle:
                    if r in S or r==y: continue
                    if is_sf(A|{y,r}) and opp(frozenset(A|{y,r})):
                        ok=True; break
                if not ok:
                    fails.append((frozenset(A),y)); seen[A]=False; return False
        seen[A]=True; return True
    opp(frozenset({o}))
    print(f"=== {label} mods={mods} o={o}: {len(fails)} socle-book failures ===")
    for (A,y) in fails[:2]:
        S=set(A)
        print(f"  FAIL position A={sorted(A)}")
        print(f"    opponent socle move y={y}")
        # examine every candidate reply (socle AND bulk)
        legal_socle=[]; legal_bulk=[]; blocked=[]
        for r in NZ:
            if r in S or r==y: continue
            if is_sf(A|{y,r}):
                (legal_socle if order(r)==3 else legal_bulk).append(r)
            else:
                blocked.append(r)
        print(f"    legal socle replies: {legal_socle}")
        print(f"    legal BULK replies : {legal_bulk[:8]}{'...' if len(legal_bulk)>8 else ''} (count {len(legal_bulk)})")
        # does ANY legal reply (socle or bulk) actually win under full solver? try bulk repair:
        # (we can't call the full game solver cheaply, but report if a bulk reply exists at all)
        # also: is the pure socle subgame winnable here? check socle replies that are legal:
        print(f"    -> socle stuck: {'NO legal socle reply' if not legal_socle else 'legal socle replies exist but all lose under book'}")

for mods,label in [((9,3),"Z9xZ3"),((3,3,5),"Z3^2xZ5")]:
    run(mods,label)
