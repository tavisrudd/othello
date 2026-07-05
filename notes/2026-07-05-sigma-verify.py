"""Verify ChatGPT's sigma-mirror: {m,p} is P in Z2 x F3^b (=> {m} is N).

  G=Z2 x V, V=F3^b, m=(1,0), a in V\\{0}, p=(0,a), k=m+p=(1,a),
  sigma(eps,v)=(1-eps, a-v)  (affine, fpf since it flips Z2).

Checks, printed incrementally per b:
  (A) brute NO-SYMMETRY outcome of {m},{m,p}   -- ground truth, b<=2 only.
  (B) EXHAUSTIVE local sweep over ALL sigma-sym sum-free A>={m,p}: for every
      legal opponent y, verify sigma(y) fresh & != y and A u {y,sigma y}
      sum-free  (== pair-completion lemma; 0 viol => proof for that b).
  (C) ADVERSARIAL all opponent lines from {m,p} under the mirror.
  Also: (B),(C) repeated for several choices of a (a-independence).
"""
import sys
from itertools import product
sys.setrecursionlimit(1000000)

def build(b):
    V=list(product(range(3),repeat=b)); Z=tuple([0]*b)
    def vsub(x,y): return tuple((x[i]-y[i])%3 for i in range(b))
    def gadd(x,y): return ((x[0]+y[0])%2, tuple((x[1][i]+y[1][i])%3 for i in range(b)))
    return V,Z,vsub,gadd

def is_sumfree(A,gadd):
    S=set(A)
    for x in A:
        for y in A:
            if gadd(x,y) in S: return False
    return True

def brute_outcome(b,start):
    V,Z,vsub,gadd=build(b)
    elts=[(e,v) for e in (0,1) for v in V if (e,v)!=(0,Z)]
    memo={}
    def win(A):
        if A in memo: return memo[A]
        S=set(A); res=False
        for x in elts:
            if x in S: continue
            nA=A|{x}
            if is_sumfree(nA,gadd) and not win(frozenset(nA)):
                res=True; break
        memo[A]=res; return res
    return win(frozenset(start))

def sigma_of(a,b):
    def sig(x):
        e,v=x
        return ((1-e)%2, tuple((a[i]-v[i])%3 for i in range(b)))
    return sig

def local_sweep(b,a):
    V,Z,vsub,gadd=build(b)
    sig=sigma_of(a,b)
    m=(1,Z); p=(0,a); base=frozenset({m,p})
    assert sig(m)==p and sig(p)==m and all(sig(sig(x))==x for x in [(e,v) for e in(0,1) for v in V])
    elts=[(e,v) for e in (0,1) for v in V if (e,v)!=(0,Z)]
    # sigma-pairs
    seen=set(); pairs=[]
    for x in elts:
        key=frozenset({x,sig(x)})
        if key not in seen:
            seen.add(key); pairs.append(tuple(sorted(key)))
    positions=[]
    def dfs(A,idx):
        positions.append(A)
        for j in range(idx,len(pairs)):
            pr=pairs[j]
            if pr[0] in A: continue
            nA=A|set(pr)
            if is_sumfree(nA,gadd):
                dfs(frozenset(nA),j+1)
    dfs(base,0)
    viol=0; checked=0
    for A in positions:
        Sset=set(A)
        for y in elts:
            if y in Sset: continue
            if is_sumfree(A|{y},gadd):
                z=sig(y); checked+=1
                if z==y or z in Sset:
                    viol+=1; print(f"    FRESHNESS viol y={y} z={z}"); continue
                if not is_sumfree(A|{y,z},gadd):
                    viol+=1
                    if viol<=3: print(f"    LEMMA viol A={sorted(A)} y={y} z={z}")
    return len(positions),checked,viol

def adversarial(b,a):
    V,Z,vsub,gadd=build(b)
    sig=sigma_of(a,b)
    m=(1,Z); p=(0,a); base=frozenset({m,p})
    elts=[(e,v) for e in (0,1) for v in V if (e,v)!=(0,Z)]
    memo={}
    def opp(A):
        if A in memo: return memo[A]
        Sset=set(A)
        for y in elts:
            if y in Sset: continue
            if is_sumfree(A|{y},gadd):
                z=sig(y)
                if z==y or z in Sset or not is_sumfree(A|{y,z},gadd):
                    memo[A]=False; return False
                if not opp(frozenset(A|{y,z})):
                    memo[A]=False; return False
        memo[A]=True; return True
    return opp(base)

def a_choices(b):
    V,Z,_,_=build(b)
    nz=[v for v in V if v!=Z]
    # pick a few distinct a: e1, all-ones, and a 'mixed' one if available
    picks=[nz[0]]
    if len(nz)>1: picks.append(nz[-1])
    if b>=2:
        mixed=tuple([1,2]+[0]*(b-2));
        if mixed in nz and mixed not in picks: picks.append(mixed)
    return picks

if __name__=="__main__":
    for b in (1,2,3,4):
        print(f"=== b={b}  (V=3^{b}={3**b}, G={2*3**b}) ===", flush=True)
        if b<=2:
            V,Z,_,_=build(b); a0=tuple([1]+[0]*(b-1))
            mo=brute_outcome(b,{(1,Z)}); mpo=brute_outcome(b,{(1,Z),(0,a0)})
            print(f"  (A) brute: {{m}} is {'N' if mo else 'P'} (want N); "
                  f"{{m,p}} is {'N' if mpo else 'P'} (want P)", flush=True)
        for a in a_choices(b):
            npos,chk,viol=local_sweep(b,a)
            adv=adversarial(b,a)
            print(f"  a={a}: (B) {npos} sig-sym sumfree pos, {chk} checks, "
                  f"{viol} viol | (C) hero {'WINS' if adv else 'LOSES'}", flush=True)
        print(flush=True)
