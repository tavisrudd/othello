"""Fast bitmask randomized pair-completion-lemma check for b=4,5.
Elements indexed 0..2*3^b-1 as (eps, v). Precompute sum table & sigma.
Position = frozenset of indices. is_sumfree via precomputed pair sums.
"""
import random
from itertools import product

def setup(b):
    V=list(product(range(3),repeat=b)); Z=tuple([0]*b)
    elts=[(e,v) for e in (0,1) for v in V]  # index = position in this list
    idx={x:i for i,x in enumerate(elts)}
    N=len(elts)
    def gadd(x,y): return ((x[0]+y[0])%2, tuple((x[1][i]+y[1][i])%3 for i in range(b)))
    SUM=[[idx[gadd(elts[i],elts[j])] for j in range(N)] for i in range(N)]
    ZERO=idx[(0,Z)]
    return elts,idx,N,SUM,ZERO,V,Z

def is_sf(A, SUM):
    # A: set of indices. sum-free iff no i,j in A with SUM[i][j] in A.
    for i in A:
        Si=SUM[i]
        for j in A:
            if Si[j] in A:
                return False
    return True

def check(b, samples, seed=7):
    rng=random.Random(seed)
    elts,idx,N,SUM,ZERO,V,Z=setup(b)
    nz=[v for v in V if v!=Z]
    viol=0; pos=0; checks=0
    allidx=[i for i in range(N) if i!=ZERO]
    for _ in range(samples):
        a=rng.choice(nz)
        def sig(i):
            e,v=elts[i]
            return idx[((1-e)%2, tuple((a[k]-v[k])%3 for k in range(b)))]
        m=idx[(1,Z)]; p=idx[(0,a)]
        # sigma-pairs
        seen=set(); pairs=[]
        for i in allidx:
            si=sig(i); key=(min(i,si),max(i,si))
            if key not in seen:
                seen.add(key); pairs.append(key)
        A=set([m,p]); order=pairs[:]; rng.shuffle(order)
        path=[frozenset(A)]                       # check EVERY position along the build
        for (i,j) in order:
            if i in A or j in A: continue
            nA=A|{i,j}
            if is_sf(nA,SUM):
                A=nA; path.append(frozenset(A))
        for P in path:
            pos+=1
            for y in allidx:
                if y in P: continue
                if is_sf(P|{y},SUM):
                    z=sig(y); checks+=1
                    if z==y or z in P or not is_sf(P|{y,z},SUM):
                        viol+=1
                        if viol<=3: print("  VIOL",b,a,elts[y],elts[z])
    print(f"b={b}: {pos} random sigma-sym sumfree positions, {checks} (pos,legal-y) checks, {viol} violations")

if __name__=="__main__":
    check(4, 200)
    check(5, 60)
