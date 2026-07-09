#!/usr/bin/env python3
"""C48 — mirror-theorem harvest on classical varieties.

Applies the generic fixed-point-free-involution mirror lemma
(`Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution`,
instantiated in Lean once by C25 for PG(2m-1,q)) to classical varieties whose
cap/Nofil game runs on ambient projective lines.  Each board is constructed
HONESTLY from its defining form over a small finite field, so the >=3-point-line
(intersection) pattern is verified rather than trusted, then:

  * the cap game is exhaustively solved (no 3 ambient-collinear; normal play),
  * candidate fpf collinearity-preserving involutions are tested, and
  * the C27 pair-extension obligation (S u {x, sigma x} valid) is checked over
    every sigma-invariant reachable cap (== a stuck-free / total-strategy proof).

Deterministic, single-core, tiny memory.  See notes/2026-07-09-codex-mirror-harvest.md.

Usage:  python3 projcap_mirror_harvest.py [--full]
        (--full also runs the 26s Q+(3,7) exhaustive pair-extension BFS)
"""
from __future__ import annotations
import itertools, sys, time, random
from collections import deque, Counter
from functools import reduce

# ---------------------------------------------------------------------------
# Finite field GF(p^k) as coefficient tuples over F_p mod a fixed irreducible.
# ---------------------------------------------------------------------------
class GF:
    def __init__(self, p, k, irr=None):
        self.p, self.k, self.q = p, k, p**k
        self.irr = irr  # coeffs c0..c_{k-1} of monic irreducible x^k = -(c0+..+c_{k-1}x^{k-1})
        self.elems = [tuple(c) for c in itertools.product(range(p), repeat=k)]
    def zero(self): return (0,)*self.k
    def one(self):  return (1,)+(0,)*(self.k-1)
    def add(self,a,b): return tuple((x+y)%self.p for x,y in zip(a,b))
    def neg(self,a):   return tuple((-x)%self.p for x in a)
    def sub(self,a,b): return tuple((x-y)%self.p for x,y in zip(a,b))
    def mul(self,a,b):
        p,k=self.p,self.k
        if k==1: return ((a[0]*b[0])%p,)
        res=[0]*(2*k-1)
        for i,ai in enumerate(a):
            if ai:
                for j,bj in enumerate(b):
                    res[i+j]=(res[i+j]+ai*bj)%p
        for dd in range(2*k-2,k-1,-1):
            c=res[dd]
            if c:
                res[dd]=0
                for j in range(k):
                    res[dd-k+j]=(res[dd-k+j]-c*self.irr[j])%p
        return tuple(res[:k])
    def powe(self,a,n):
        r=self.one(); b=a
        while n>0:
            if n&1: r=self.mul(r,b)
            b=self.mul(b,b); n>>=1
        return r
    def inv(self,a): return self.powe(a,self.q-2)
    def is_square(self,a):
        return True if a==self.zero() else self.powe(a,(self.q-1)//2)==self.one()
    def frob(self,a,e): return self.powe(a,self.p**e)
    def nonsquare(self):
        for e in self.elems:
            if e!=self.zero() and not self.is_square(e): return e
        raise RuntimeError("no nonsquare")

def gf(name):
    return {"F3":GF(3,1),"F5":GF(5,1),"F7":GF(7,1),
            "F4":GF(2,2,(1,1)),      # x^2+x+1
            "F9":GF(3,2,(1,0))}[name]  # x^2+1 (i^2=-1)

# ---------------------------------------------------------------------------
# Projective points, collinearity, board line structure.
# ---------------------------------------------------------------------------
def normalize(F,v):
    for x in v:
        if x!=F.zero():
            iv=F.inv(x); return tuple(F.mul(iv,y) for y in v)
    return v

def proj_points(F,d):
    out=set()
    for v in itertools.product(F.elems,repeat=d+1):
        if any(x!=F.zero() for x in v): out.add(normalize(F,v))
    return sorted(out)

def det3(F,m):
    t=lambda i,j:m[i][j]
    a=F.mul(t(0,0),F.sub(F.mul(t(1,1),t(2,2)),F.mul(t(1,2),t(2,1))))
    b=F.mul(t(0,1),F.sub(F.mul(t(1,0),t(2,2)),F.mul(t(1,2),t(2,0))))
    c=F.mul(t(0,2),F.sub(F.mul(t(1,0),t(2,1)),F.mul(t(1,1),t(2,0))))
    return F.sub(F.add(a,c),b)

def collinear(F,a,b,c):
    M=[a,b,c]
    for cols in itertools.combinations(range(len(a)),3):
        if det3(F,[[M[r][cj] for cj in cols] for r in range(3)])!=F.zero():
            return False
    return True

def ge3_lines(F,board):
    n=len(board); lines=set()
    for i in range(n):
        for j in range(i+1,n):
            on=frozenset(k for k in range(n) if collinear(F,board[i],board[j],board[k]))
            if len(on)>=3: lines.add(on)
    return [tuple(sorted(l)) for l in lines]

# ---------------------------------------------------------------------------
# Cap-game solver (memoized normal-play minimax over board-index positions).
# ---------------------------------------------------------------------------
class CapGame:
    def __init__(self, n, lines):
        self.n=n; self.lines=[frozenset(l) for l in lines]
        self.point_lines=[[] for _ in range(n)]
        for li,L in enumerate(self.lines):
            for x in L: self.point_lines[x].append(li)
        self.memo={}
    def legal_moves(self,S):
        cnt={}
        for x in S:
            for li in self.point_lines[x]: cnt[li]=cnt.get(li,0)+1
        mv=[]
        for x in range(self.n):
            if x in S: continue
            if all(cnt.get(li,0)<2 for li in self.point_lines[x]): mv.append(x)
        return mv
    def is_N(self,S):
        if S in self.memo: return self.memo[S]
        r=False
        for x in self.legal_moves(S):
            if not self.is_N(S|{x}): r=True; break
        self.memo[S]=r; return r
    def solve_empty(self):
        sys.setrecursionlimit(1000000)
        return "N" if self.is_N(frozenset()) else "P"

# ---------------------------------------------------------------------------
# Involution testing (fpf, involutive, collinearity-preserving, C27).
# ---------------------------------------------------------------------------
def check_involution(F,board,sigma):
    n=len(board)
    cp=True
    for a,b,c in itertools.combinations(range(n),3):
        if collinear(F,board[a],board[b],board[c])!=collinear(F,board[sigma[a]],board[sigma[b]],board[sigma[c]]):
            cp=False; break
    return {"is_perm":sorted(sigma.values())==list(range(n)),
            "involutive":all(sigma[sigma[i]]==i for i in range(n)),
            "fpf":all(sigma[i]!=i for i in range(n)),
            "collinearity_preserving":cp}

def pair_extension_bfs(g,sigma):
    """C27 over EVERY sigma-invariant reachable cap (== stuck-free/total mirror)."""
    fails=[]; seen={frozenset()}; dq=deque([frozenset()])
    while dq:
        S=dq.popleft()
        for x in g.legal_moves(S):
            sx=sigma[x]; S1=S|{x}
            if sx==x: fails.append((S,x,sx,"fixed")); continue
            if sx in S1: fails.append((S,x,sx,"sx in S1")); continue
            if sx not in g.legal_moves(S1): fails.append((S,x,sx,"sx illegal after x")); continue
            S2=S1|{sx}
            if S2 not in seen: seen.add(S2); dq.append(S2)
    return fails,len(seen)

def pair_extension_sampled(g,sigma,walks=400,seed=12345):
    rng=random.Random(seed); fails=[]; checked=0
    for _ in range(walks):
        S=frozenset()
        while True:
            mv=g.legal_moves(S)
            if not mv: break
            x=rng.choice(mv); sx=sigma[x]; S1=S|{x}; checked+=1
            if sx==x or sx in S1 or sx not in g.legal_moves(S1):
                fails.append((S,x,sx)); break
            S=S1|{sx}
    return fails,checked

# ---------------------------------------------------------------------------
# Variety constructors.
# ---------------------------------------------------------------------------
def form_eval(F,v,terms):
    s=F.zero()
    for coef,(i,j) in terms:
        c=(coef%F.p,)+(0,)*(F.k-1)
        s=F.add(s,F.mul(c,F.mul(v[i],v[j])))
    return s

def build_quadric(F,terms,d):
    return [v for v in proj_points(F,d) if form_eval(F,v,terms)==F.zero()]

def hermitian_points(F,q,d):
    out=[]
    for v in proj_points(F,d):
        s=F.zero()
        for x in v: s=F.add(s,F.powe(x,q+1))
        if s==F.zero(): out.append(v)
    return out

def hyperbolic_terms(m): return [(1,(2*i,2*i+1)) for i in range(m)]

def elliptic_sigma(F,board,d):
    """C25 elliptic block map (a_i,b_i)->(d*b_i, a_i), projectivized.  KeyError
    if an image leaves the board (i.e. the map does not preserve the variety)."""
    idx={p:i for i,p in enumerate(board)}; sig={}; n=len(board[0])
    for p in board:
        img=list(p)
        for i in range(0,n,2):
            img[i]=F.mul(d,p[i+1]); img[i+1]=p[i]
        sig[idx[p]]=idx[normalize(F,tuple(img))]
    return sig

def matvec(F,M,v): return tuple(reduce(F.add,(F.mul(M[i][j],v[j]) for j in range(len(v))),F.zero()) for i in range(len(M)))
def lin_apply(F,M,v): return normalize(F,matvec(F,M,v))
def diag(F,es):
    n=len(es); M=[[F.zero()]*n for _ in range(n)]
    for i,e in enumerate(es): M[i][i]=e
    return M

def every_line_meets(F,board,d):
    bs=set(board); pts=proj_points(F,d); seen=set(); miss=0
    for a,b in itertools.combinations(range(len(pts)),2):
        line=frozenset(p for p in range(len(pts)) if collinear(F,pts[a],pts[b],pts[p]))
        if line in seen: continue
        seen.add(line)
        if not any(pts[p] in bs for p in line): miss+=1
    return len(seen),miss

# ---------------------------------------------------------------------------
# Board runners.
# ---------------------------------------------------------------------------
def hdr(name,board,extra=""):
    par="even" if len(board)%2==0 else "odd"
    print(f"\n### {name}: {len(board)} points ({par}){extra}",flush=True)

def solve(name,F,board):
    lines=ge3_lines(F,board); spec=dict(Counter(len(l) for l in lines))
    g=CapGame(len(board),lines); t=time.time(); val=g.solve_empty()
    print(f"    >=3-lines={len(lines)} sizes={spec}  |  cap-game outcome: {val}  "
          f"({time.time()-t:.2f}s, {len(g.memo)} states)",flush=True)
    return g,val,lines,spec

def run_hyperbolic(qname,m,full_bfs_max=64,do_solve=True):
    F=gf(qname); q=F.q; board=build_quadric(F,hyperbolic_terms(m),2*m-1); d=F.nonsquare()
    hdr(f"Q+({2*m-1},{q}) hyperbolic  sum a_i b_i=0",board,f"  d(nonsquare)={d[0] if F.k==1 else d}")
    try: sigma=elliptic_sigma(F,board,d)
    except KeyError as e:
        print(f"    elliptic block mirror does NOT preserve quadric: {e}",flush=True); return
    print(f"    elliptic mirror (a,b)->(d b,a): {check_involution(F,board,sigma)}",flush=True)
    g=CapGame(len(board),ge3_lines(F,board)); t=time.time()
    if len(board)<=full_bfs_max:
        fails,ninv=pair_extension_bfs(g,sigma)
        print(f"    C27 pair-extension over ALL {ninv} sigma-invariant caps: "
              f"{'PASS => total mirror strategy => P' if not fails else f'FAIL {len(fails)}'}"
              f"  ({time.time()-t:.1f}s)",flush=True)
    else:
        fails,ck=pair_extension_sampled(g,sigma)
        print(f"    C27 pair-extension SAMPLED {ck} moves: {'PASS' if not fails else f'FAIL {len(fails)}'}"
              f"  ({time.time()-t:.1f}s)  [proof = collinearity-preservation above + generic lemma]",flush=True)
    if do_solve and len(board)<=40:
        t=time.time(); print(f"    exhaustive cross-check outcome: {g.solve_empty()}  ({time.time()-t:.2f}s)",flush=True)

def run_qplus33_grid():
    """Verify the (q+1)x(q+1) grid model + translation mirror sigma(i,j)=(i+h,j+h)."""
    F=gf("F3"); board=build_quadric(F,hyperbolic_terms(2),3); lines=ge3_lines(F,board)
    # split generators into two rulings by disjointness -> grid coords
    L=[set(l) for l in lines]; ruling={0:0}; dq=deque([0])
    while dq:
        i=dq.popleft()
        for j in range(len(L)):
            if j==i: continue
            want=(1-ruling[i]) if (L[i]&L[j]) else ruling[i]
            if j not in ruling: ruling[j]=want; dq.append(j)
    A=[i for i in ruling if ruling[i]==0]; B=[i for i in ruling if ruling[i]==1]
    rowof={}; colof={}
    for r,li in enumerate(A):
        for p in L[li]: rowof[p]=r
    for c,li in enumerate(B):
        for p in L[li]: colof[p]=c
    n=len(A); h=n//2
    coord={p:(rowof[p],colof[p]) for p in range(len(board))}
    inv={v:k for k,v in coord.items()}
    sigma={p:inv[((coord[p][0]+h)%n,(coord[p][1]+h)%n)] for p in range(len(board))}
    hdr(f"Q+(3,3) as {n}x{n} capacity-2 rook grid (E1 line-capacity model)",board)
    print(f"    two rulings of {len(A)} generators each -> grid coords; "
          f"translation mirror (i,j)->(i+{h},j+{h}): {check_involution(F,board,sigma)}",flush=True)
    g=CapGame(len(board),lines); fails,ninv=pair_extension_bfs(g,sigma)
    print(f"    C27 pair-extension over ALL {ninv} invariant caps: "
          f"{'PASS => P' if not fails else 'FAIL'}",flush=True)

def run_ovoid():
    F=gf("F3"); board=build_quadric(F,[(1,(0,0)),(1,(1,1)),(1,(2,3))],3)
    hdr("Q-(3,3) elliptic quadric / ovoid  x0^2+x1^2+x2x3",board)
    solve("Q-(3,3)",F,board)
    print("    -> 0 long lines: FREE placement, outcome is bare parity (q^2+1 even => P). TRIVIAL row.",flush=True)

def run_unital(qname,q,label):
    F=gf(qname); board=hermitian_points(F,q,2)
    nlines,miss=every_line_meets(F,board,2)
    hdr(f"{label} Hermitian curve/unital",board,
        f"  PG(2,{F.q}) lines={nlines}, missing unital={miss} (0 => blocking set, no external line)")
    solve(label,F,board)

def unital_fixed_points():
    F=gf("F9"); q=3; board=hermitian_points(F,q,2); one=F.one(); m1=F.neg(one)
    print("\n### H(2,9) fixed-point obstruction (even ambient dim 2):",flush=True)
    M=diag(F,[one,one,m1]); ap=lambda p:lin_apply(F,M,p)
    fp=[p for p in board if ap(p)==p]
    print(f"    diag(1,1,-1) unitary involution: preserves={all(ap(p) in set(board) for p in board)}, "
          f"fixed pts on curve={len(fp)} (fpf needs 0)",flush=True)
    apB=lambda p:normalize(F,matvec(F,diag(F,[one,one,one]),tuple(F.frob(x,1) for x in p)))
    fpB=[p for p in board if apB(p)==p]
    print(f"    Baer x->x^q: preserves={all(apB(p) in set(board) for p in board)}, "
          f"fixed pts on curve={len(fpB)} (the Baer subconic)",flush=True)

def run_negatives():
    print("\n### Negatives (mirror method fails; outcome may still be P by other means):",flush=True)
    # Q-(5,3): elliptic block map leaves the quadric
    F=gf("F3"); board=build_quadric(F,[(1,(0,1)),(1,(2,3)),(1,(4,4)),(1,(5,5))],5)
    try:
        elliptic_sigma(F,board,F.nonsquare()); msg="PRESERVES (unexpected)"
    except KeyError: msg="does NOT preserve (anisotropic block factor mismatch)"
    print(f"  Q-(5,3) elliptic quadric ({len(board)} pts): elliptic block mirror {msg}; "
          f"O-(6,q) has no fpf involution.",flush=True)
    # Q(4,3): even ambient dim -> rational fixed point
    F=gf("F3"); board=build_quadric(F,[(1,(0,0)),(1,(1,2)),(1,(3,4))],4); one=F.one(); m1=F.neg(one)
    M=diag(F,[one,one,one,m1,m1]); fp=[p for p in board if lin_apply(F,M,p)==p]
    print(f"  Q(4,3) parabolic ({len(board)} pts, even ambient dim): "
          f"diag(1,1,1,-1,-1) involution has {len(fp)} fixed pts on Q.",flush=True)
    # H(3,4): unitary involutions have isotropic eigenspaces
    F=gf("F4"); board=hermitian_points(F,2,3); one=F.one()
    M=[[F.zero()]*4 for _ in range(4)]; M[0][1]=one;M[1][0]=one;M[2][3]=one;M[3][2]=one
    fp=[p for p in board if lin_apply(F,M,p)==p]
    print(f"  H(3,4) Hermitian surface ({len(board)} pts, odd dim 3): swap-block unitary "
          f"involution has {len(fp)} fixed pts (Hermitian forms isotropic in dim>=2).",flush=True)

def main():
    full = "--full" in sys.argv
    print("="*72); print("C48 mirror-theorem harvest on classical varieties"); print("="*72,flush=True)
    print("\n--- POSITIVE: hyperbolic quadrics Q+(2m-1,q), odd q (elliptic block mirror) ---",flush=True)
    run_hyperbolic("F3",2); run_hyperbolic("F5",2)
    if full: run_hyperbolic("F7",2)
    run_hyperbolic("F3",3)                      # Q+(5,3), 130 pts, mirror-only proof
    run_qplus33_grid()
    print("\n--- TRIVIAL PARITY: elliptic quadrics / ovoids ---",flush=True)
    run_ovoid()
    print("\n--- COINCIDES WITH KNOWN affine family ---",flush=True)
    run_unital("F4",2,"H(2,4)")                 # == AG(2,3)
    print("    -> 9 pts, 12 three-point lines == AG(2,3); P by the affine cap theorem (odd count, not a mirror family).",flush=True)
    print("\n--- NEGATIVE / BOUNDARY: Hermitian curve H(2,9) ---",flush=True)
    run_unital("F9",3,"H(2,9)")
    unital_fixed_points()
    run_negatives()
    print("\nDONE.",flush=True)

if __name__=="__main__":
    main()
