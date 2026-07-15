"""(a) Structure of the unique non-Clebsch exact-quartic locus (class |U|=18, |Stab|=6).
(b) A5-orbit decomposition of the 133 points under Stab(Clebsch) -> conceptual
    skeleton for a computation-free proof of Prop 3.1."""
from itertools import combinations, permutations, product as iproduct

p = 11

def norm(v):
    for c in v:
        if c % p:
            inv = pow(c % p, p-2, p)
            return tuple((x*inv) % p for x in v)
    return None

def cross(a, b):
    return norm((a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]))

def dot(a, b): return (a[0]*b[0]+a[1]*b[1]+a[2]*b[2]) % p

def det3(P,Q,R):
    return (P[0]*(Q[1]*R[2]-Q[2]*R[1]) - P[1]*(Q[0]*R[2]-Q[2]*R[0])
            + P[2]*(Q[0]*R[1]-Q[1]*R[0])) % p

POINTS = []
seen = set()
for a in range(p):
    for b in range(p):
        for c in range(p):
            if (a,b,c)==(0,0,0): continue
            n = norm((a,b,c))
            if n not in seen: seen.add(n); POINTS.append(n)

E1,E2,E3,Uu = (1,0,0),(0,1,0),(0,0,1),(1,1,1)
FRAME=[E1,E2,E3,Uu]
cands=[P for P in POINTS if P[0] and P[1] and P[2] and P[0]!=P[1] and P[1]!=P[2] and P[0]!=P[2]]
arcs=[]
for P,Q in combinations(cands,2):
    if all(det3(F,P,Q)%p for F in FRAME): arcs.append(FRAME+[P,Q])

def uncovered(arc):
    marked=set(arc)
    for P,Q in combinations(arc,2):
        L=cross(P,Q)
        for R in POINTS:
            if dot(L,R)==0: marked.add(R)
    return sorted(P for P in POINTS if P not in marked)

def monomials(d):
    return [(i,j,d-i-j) for i in range(d+1) for j in range(d+1-i)]

def evalmono(P,m):
    return (pow(P[0],m[0],p)*pow(P[1],m[1],p)*pow(P[2],m[2],p))%p

def kernel(rows,ncols):
    m=[r[:] for r in rows]; nrows=len(m); piv=[]; r=0
    for col in range(ncols):
        pr=next((i for i in range(r,nrows) if m[i][col]%p),None)
        if pr is None: continue
        m[r],m[pr]=m[pr],m[r]
        inv=pow(m[r][col],p-2,p); m[r]=[(x*inv)%p for x in m[r]]
        for i in range(nrows):
            if i!=r and m[i][col]%p:
                f=m[i][col]; m[i]=[(m[i][j]-f*m[r][j])%p for j in range(ncols)]
        piv.append(col); r+=1
        if r==nrows: break
    free=[c for c in range(ncols) if c not in piv]; basis=[]
    for fc in free:
        v=[0]*ncols; v[fc]=1
        for ri,pc in enumerate(piv): v[pc]=(-m[ri][fc])%p
        basis.append(v)
    return basis

# ---- (a) find the |U|=18 class whose U is exactly a quartic zero set ----
mon4 = monomials(4)
found = None
seen_keys = set()
for arc in arcs:
    Uset = uncovered(arc)
    if len(Uset) != 18: continue
    rows=[[evalmono(P,m) for m in mon4] for P in Uset]
    basis = kernel(rows, 15)
    if len(basis) != 1: continue
    F = basis[0]
    Z = [P for P in POINTS if sum(c*evalmono(P,m) for c,m in zip(F,mon4) if c)%p==0]
    if len(Z) == 18 and sorted(Z) == Uset:
        found = (arc, Uset, F)
        break
assert found, "exact-quartic class not found"
arc2, U2, F = found
print("class with U = Z(quartic): |U| =", len(U2))
print("quartic coefficients (monomial order", mon4, "):")
print(F)

# contains a full line?
has_line = False
for L in POINTS:
    pts=[P for P in POINTS if dot(L,P)==0]
    if all(P in set(U2) for P in pts): has_line=True; break
print("zero set contains a full line:", has_line)

# contains a full nonsingular-conic point set? (would witness conic factor)
# instead: check divisibility by each conic through >=6 of its points is overkill;
# a 12-point conic cannot fit in 18 points together with another conic (>=20 pts).
# check singular points of the quartic: all partials vanish
def partial(F, var):
    out=[0]*15
    for c,m in zip(F,mon4):
        if c and m[var]>0:
            m2=list(m); m2[var]-=1
            # write into degree-3 basis? just evaluate directly later
            pass
    return None

mon3 = monomials(3)
def partial_coeffs(F, var):
    d={}
    for c,m in zip(F,mon4):
        if c and m[var]>0:
            m2=list(m); coef=(c*m[var])%p; m2[var]-=1
            key=tuple(m2); d[key]=(d.get(key,0)+coef)%p
    return [d.get(m,0) for m in mon3]

PX=partial_coeffs(F,0); PY=partial_coeffs(F,1); PZ=partial_coeffs(F,2)
sing=[P for P in U2 if all(sum(c*evalmono(P,m) for c,m in zip(PC,mon3) if c)%p==0
                           for PC in (PX,PY,PZ))]
print("singular rational points on the quartic among U:", len(sing))

# ---- (b) orbit decomposition under Stab(Clebsch A5) ----
A=[norm(v) for v in [(1,10,0),(1,9,1),(1,4,7),(1,8,5),(0,1,4),(1,1,7)]]
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

M0=solve_frame(A[:4]); M0i=inv3(M0)
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

orbits=[]; left=set(POINTS)
while left:
    P=next(iter(left)); O=set(); stack=[P]
    while stack:
        Q=stack.pop()
        if Q in O: continue
        O.add(Q)
        for G in stab: stack.append(apply(G,Q))
    orbits.append(sorted(O)); left-=O
sizes=sorted(len(o) for o in orbits)
print("A5 orbit sizes on the 133 points:", sizes)

CONIC=sorted(P for P in POINTS if (P[0]*P[2]-P[1]*P[1])%p==0)
secants=[cross(P,Q) for P,Q in combinations(A,2)]
def on_secant(P): return any(dot(L,P)==0 for L in secants)
for o in orbits:
    tag=[]
    if set(o)==set(A): tag.append("ARC")
    if sorted(o)==CONIC: tag.append("CONIC")
    off=sum(1 for P in o if (P not in A) and not on_secant(P))
    print(f"  orbit size {len(o):>3}  off-all-secants points: {off:>3}  {' '.join(tag)}")

# uniqueness of the size-12 orbit and the fixed-point argument
n12=[o for o in orbits if len(o)==12]
print("number of size-12 orbits:", len(n12))
# fixed points of order-5 elements
def order(G):
    X=G; k=1
    I=((1,0,0),(0,1,0),(0,0,1))
    def mul(A,B):
        return tuple(tuple(sum(A[r][k]*B[k][c] for k in range(3))%p for c in range(3))
                     for r in range(3))
    def isproj_id(M):
        # M proportional to identity
        d=None
        for r in range(3):
            for c in range(3):
                if r==c:
                    if d is None: d=M[r][c]
                    elif M[r][c]!=d: return False
                elif M[r][c]%p: return False
        return True
    while True:
        if isproj_id(X): return k
        X=mul(X,G); k+=1
        if k>100: return None
fixed_by_5=set()
cnt5=0
for G in stab:
    if order(G)==5:
        cnt5+=1
        for P in POINTS:
            if apply(G,P)==P: fixed_by_5.add(P)
print("order-5 elements in Stab:", cnt5)
print("points fixed by some order-5 element:", len(fixed_by_5),
      "= arc(6) + conic(12)?",
      set(fixed_by_5)==set(A)|set(CONIC))
