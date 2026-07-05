"""Fibered strategy test for the coprime peel HxZp:
hero opens socle center o=(oH,0); to opponent y=(h,i) hero must reply with some
(sigmaH(h), j), j in Zp, that is legal.  Does hero win (all lines) with the
H-projection pinned to the winning F3^n mirror sigmaH?  Search over the free j.
"""
from itertools import product

def make(Hmods,p):
    mods=tuple(Hmods)+(p,); n=len(mods); hn=len(Hmods)
    def add(x,y): return tuple((x[k]+y[k])%mods[k] for k in range(n))
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
    return add,ELTS,Z,NZ,is_sf,order,mods,hn,n

def fibered_wins(Hmods,p):
    add,ELTS,Z,NZ,is_sf,order,mods,hn,n=make(Hmods,p)
    Hsoc=[x for x in ELTS if x[-1]==0 and order(x)==3] or [x for x in ELTS if x[-1]==0 and x!=Z]
    o=Hsoc[0]; oHh=o[:hn]
    def sigmaH(h): return tuple((-oHh[k]-h[k])%mods[k] for k in range(hn))
    # hero-to-move game: opponent just played, hero must reply with H-part = required
    # We model: state A (opp to move). For each opp y, hero must have SOME legal reply
    # r with r[:hn]==sigmaH(y[:hn]); and recurse. Hero wins if for every opp y there is
    # such an r leading to a hero win.
    seen={}
    def opp(A):     # opp to move; True = hero (mirrorer) wins
        if A in seen: return seen[A]
        S=set(A)
        for y in NZ:
            if y in S: continue
            if is_sf(A|{y}):
                need=sigmaH(y[:hn])
                # hero needs a winning reply r with r[:hn]==need
                cands=[ (need+(j,)) for j in range(p) ]
                ok=False
                for r in cands:
                    if r in S or r==y: continue
                    if not is_sf(A|{y,r}): continue
                    if opp(frozenset(A|{y,r})):
                        ok=True; break
                if not ok:
                    seen[A]=False; return False
        seen[A]=True; return True
    return o, opp(frozenset({o}))

for Hmods,p in [((3,),5),((3,),7),((3,3),5),((3,3),7)]:
    o,r=fibered_wins(Hmods,p)
    print(f"H={Hmods} x Z{p}: fibered (H-part pinned to sigmaH) open {o} -> {'WINS' if r else 'FAILS'}")
