"""Adjudication runs for Codex's flags 1, 2, 4.
(2) Is the Brianchon 10-set a single Stab-orbit?  (needed for the repaired
    conceptual proof: an invariant 10-set inside the triple set forces c=10
    by orbit disjointness + c<=15.)
(1) Do the C5 support-partitions vary with the conic direction? (=> no
    support-determined 5-element selection; chirality = unique nontrivial
    support-determined equivariant selection.)
(4) Honest (containment, exactness) degree table per class, d=2..6.
    d<=5: exhaustive over kernel when dim<=4. d=6: kernel dim + SAMPLED search."""
from itertools import combinations, permutations, product as iproduct
import numpy as np

p = 11

def norm(v):
    for c in v:
        if c % p:
            inv = pow(c % p, p-2, p)
            return tuple((x*inv) % p for x in v)

def cross(a,b):
    return norm((a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]))

def dot(a,b): return (a[0]*b[0]+a[1]*b[1]+a[2]*b[2]) % p

def det3(P,Q,R):
    return (P[0]*(Q[1]*R[2]-Q[2]*R[1]) - P[1]*(Q[0]*R[2]-Q[2]*R[0])
            + P[2]*(Q[0]*R[1]-Q[1]*R[0])) % p

POINTS=[]; seen=set()
for a in range(p):
    for b in range(p):
        for c in range(p):
            if (a,b,c)==(0,0,0): continue
            n=norm((a,b,c))
            if n not in seen: seen.add(n); POINTS.append(n)

A=[norm(v) for v in [(1,10,0),(1,9,1),(1,4,7),(1,8,5),(0,1,4),(1,1,7)]]
CONIC=sorted(P for P in POINTS if (P[0]*P[2]-P[1]*P[1])%p==0)
secants=[cross(P,Q) for P,Q in combinations(A,2)]
sidx={P: sum(1 for L in secants if dot(L,P)==0) for P in POINTS if P not in A}
BRI=sorted(P for P,v in sidx.items() if v==3)

def solve_frame(Fr):
    P1,P2,P3,P4=Fr
    Mm=[[P1[r],P2[r],P3[r]] for r in range(3)]
    m=[Mm[r][:]+[P4[r]] for r in range(3)]; r=0
    for col in range(3):
        pr=next((i for i in range(r,3) if m[i][col]%p),None)
        if pr is None: return None
        m[r],m[pr]=m[pr],m[r]
        inv=pow(m[r][col],p-2,p); m[r]=[(x*inv)%p for x in m[r]]
        for i in range(3):
            if i!=r and m[i][col]%p:
                f=m[i][col]; m[i]=[(m[i][j]-f*m[r][j])%p for j in range(4)]
        r+=1
    x=[m[i][3] for i in range(3)]
    if any(v%p==0 for v in x): return None
    return tuple(tuple((Mm[r][c]*x[c])%p for c in range(3)) for r in range(3))

def inv3(M):
    a,b,c=M[0]; d,e,f=M[1]; g,h,i=M[2]
    det=(a*(e*i-f*h)-b*(d*i-f*g)+c*(d*h-e*g))%p
    dinv=pow(det,p-2,p)
    adj=[[(e*i-f*h),(c*h-b*i),(b*f-c*e)],
         [(f*g-d*i),(a*i-c*g),(c*d-a*f)],
         [(d*h-e*g),(b*g-a*h),(a*e-b*d)]]
    return tuple(tuple((adj[r][cc]*dinv)%p for cc in range(3)) for r in range(3))

def apply(M,P):
    return norm(tuple(sum(M[r][c]*P[c] for c in range(3))%p for r in range(3)))

M0i=inv3(solve_frame(A[:4]))
stab=set()
for T in permutations(A,4):
    MT=solve_frame(list(T))
    if MT is None: continue
    G=tuple(tuple(sum(MT[r][k]*M0i[k][cc] for k in range(3))%p for cc in range(3))
            for r in range(3))
    if set(apply(G,P) for P in A)==set(A):
        flat=[G[r][c] for r in range(3) for c in range(3)]
        for v in flat:
            if v%p:
                inv=pow(v,p-2,p); stab.add(tuple((x*inv)%p for x in flat)); break
stab=[tuple(tuple(g[3*r+c] for c in range(3)) for r in range(3)) for g in stab]
assert len(stab)==60

# ---- FLAG 2: Brianchon set is a single orbit ----
O=set(); stack=[BRI[0]]
while stack:
    Q=stack.pop()
    if Q in O: continue
    O.add(Q)
    for G in stab: stack.append(apply(G,Q))
print("Flag 2: Brianchon 10-set is one Stab-orbit:", sorted(O)==BRI)

# ---- FLAG 1: C5 support-partitions vary with direction ----
def supp_perm(G): return tuple(A.index(apply(G,P)) for P in A)
def c5_partition(direction):
    sd=[supp_perm(G) for G in stab if apply(G,direction)==direction]
    assert len(sd)==5
    orbs=[]; left=set(combinations(range(6),3))
    while left:
        S=next(iter(left)); Oo=set(); st=[S]
        while st:
            T=st.pop()
            if T in Oo: continue
            Oo.add(T)
            for g in sd: st.append(tuple(sorted(g[i] for i in T)))
        orbs.append(frozenset(Oo)); left-=Oo
    return frozenset(orbs)
parts={c5_partition(P) for P in CONIC[:4]}
print("Flag 1: distinct C5 support-partitions among first 4 conic directions:",
      len(parts), "(>1 => no direction-independent 5-support selection)")

# ---- FLAG 4: degree table on the 15 classes ----
E=[(1,0,0),(0,1,0),(0,0,1)]; U0=(1,1,1); FRAME=E+[U0]
cands=[P for P in POINTS if P[0] and P[1] and P[2]
       and P[0]!=P[1] and P[1]!=P[2] and P[0]!=P[2]]
arcs=[FRAME+[P,Q] for P,Q in combinations(cands,2)
      if all(det3(F,P,Q)%p for F in FRAME)]
def canon(arc):
    best=None
    for T in permutations(arc,4):
        MT=solve_frame(list(T))
        if MT is None: continue
        G=inv3(MT)
        key=tuple(sorted(apply(G,P) for P in arc))
        if best is None or key<best: best=key
    return best
classes={}
for arc in arcs: classes.setdefault(canon(arc),[]).append(arc)
assert len(classes)==15

def uncovered(arc):
    marked=set(arc)
    for P,Q in combinations(arc,2):
        L=cross(P,Q)
        for R in POINTS:
            if dot(L,R)==0: marked.add(R)
    return sorted(P for P in POINTS if P not in marked)

def monomials(d):
    return [(i,j,d-i-j) for i in range(d+1) for j in range(d+1-i)]

PTS=np.array(POINTS, dtype=np.int64)
def evalmat(pts, monos):
    cols=[]
    for m in monos:
        v=np.ones(len(pts),dtype=np.int64)
        for k in range(3):
            v=(v*pow_col(pts[:,k],m[k]))%p
        cols.append(v)
    return np.stack(cols,axis=1)%p
def pow_col(col,e):
    out=np.ones_like(col)
    for _ in range(e): out=(out*col)%p
    return out

def kernel_np(M):
    M=M.copy()%p; nr,nc=M.shape; piv=[]; r=0
    for col in range(nc):
        pr=None
        for i in range(r,nr):
            if M[i,col]%p: pr=i; break
        if pr is None: continue
        M[[r,pr]]=M[[pr,r]]
        M[r]=(M[r]*pow(int(M[r,col]),p-2,p))%p
        for i in range(nr):
            if i!=r and M[i,col]%p:
                M[i]=(M[i]-M[i,col]*M[r])%p
        piv.append(col); r+=1
        if r==nr: break
    free=[c for c in range(nc) if c not in piv]; basis=[]
    for fc in free:
        v=np.zeros(nc,dtype=np.int64); v[fc]=1
        for ri,pc in enumerate(piv): v[pc]=(-M[ri,fc])%p
        basis.append(v)
    return basis

rng=np.random.default_rng(7)
rows=[]
for key,members in sorted(classes.items(), key=lambda kv: len(uncovered(kv[1][0]))):
    Uset=uncovered(members[0])
    Uarr=np.array(Uset,dtype=np.int64)
    rec={"U":len(Uset),"stab":360//len(members)}
    for d in (2,3,4,5,6):
        monos=monomials(d)
        MU=evalmat(Uarr,monos)
        basis=kernel_np(MU)
        k=len(basis)
        rec[f"ker{d}"]=k
        exact=None
        if k==0:
            exact=0
        elif d<=5 and k<=4:
            B=np.stack(basis)              # k x nmon
            MP=evalmat(PTS,monos)          # 133 x nmon
            cnt=0
            for coefs in iproduct(range(p),repeat=k):
                if not any(coefs): continue
                f=(np.array(coefs)@B)%p
                z=int(np.sum((MP@f)%p==0))
                if z==len(Uset): cnt+=1
            exact=cnt//(p-1)               # projective count
        else:  # sampled search only
            B=np.stack(basis); MP=evalmat(PTS,monos)
            C=rng.integers(0,p,size=(20000,k))
            C=C[np.any(C%p!=0,axis=1)]
            F=(C@B)%p
            Z=np.sum((MP@F.T)%p==0,axis=0)
            exact=f"sampled:{int(np.sum(Z==len(Uset)))}/{len(C)}"
        rec[f"ex{d}"]=exact
    rows.append(rec)

print()
print(f"{'|U|':>4} {'|S|':>4} | " + " ".join(f"k{d}/ex{d}" for d in (2,3,4,5,6)))
for r in rows:
    print(f"{r['U']:>4} {r['stab']:>4} | " +
          " ".join(f"{r[f'ker{d}']}/{r[f'ex{d}']}" for d in (2,3,4,5,6)))
