"""Diagnose the coprime-peel sigma-mirror obstruction (no full-game solve needed).
For G=HxZp, center o=(oH,0) socle, sigma(y)=-o-y. Adversarially test the mirror
strategy from {o}; on failure, show WHICH triple breaks and whether it is the
off-base DOUBLING 2w = (oH+h, -2i) landing in A (my analytic prediction).
"""
from itertools import product

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

def diagnose(mods,label):
    add,neg,ELTS,Z,NZ,is_sf,order,n=make(mods)
    # socle center in base H x {0}: element with Zp-coord 0, order 3
    cand=[o for o in NZ if o[-1]==0 and order(o)==3] or [o for o in NZ if o[-1]==0]
    o=cand[0]
    def sig(y): return neg(add(o,y))
    viol=[]; seen={}
    def opp(A):
        if A in seen: return seen[A]
        S=set(A)
        for y in NZ:
            if y in S: continue
            if is_sf(A|{y}):
                w=sig(y)
                if w==y or w in S or not is_sf(A|{y,w}):
                    viol.append((frozenset(A),y,w)); seen[A]=False; return False
                if not opp(frozenset(A|{y,w})): seen[A]=False; return False
        seen[A]=True; return True
    r=opp(frozenset({o}))
    print(f"== {label} mods={mods}, o={o} ==")
    print(f"   sigma_G mirror: {'WINS' if r else 'FAILS'} ({len(viol)} violations)")
    # classify each violation: is it the off-base doubling 2w in A ?
    dbl_hits=0; other=0; examples=[]
    for (A,y,w) in viol:
        twow=add(w,w)
        Au=set(A)|{y,w}
        # find a bad triple involving w
        bad=None
        for a in Au:
            for b in Au:
                if add(a,b) in Au and w in (a,b,add(a,b)):
                    bad=(a,b,add(a,b)); break
            if bad: break
        is_dbl = (bad is not None and bad[0]==w and bad[1]==w)  # w+w=2w violation
        if is_dbl and twow in set(A): dbl_hits+=1
        else: other+=1
        if len(examples)<5:
            examples.append((y,w,twow, twow in set(A), bad))
    print(f"   violations that are off-base DOUBLING (w+w=2w, 2w in A): {dbl_hits}; other: {other}")
    for (y,w,tw,inA,bad) in examples:
        print(f"     y={y}(zp={y[-1]}) w={w} 2w={tw} 2w-in-A={inA}  bad-triple={bad}")
    print()

for mods,label in [((3,7),"Z3 x Z7"),((3,5),"Z3 x Z5"),((3,3,5),"Z3^2 x Z5")]:
    diagnose(mods,label)
