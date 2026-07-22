# Formal local analysis at P = (1,3,9,5,4) on the Klein cubic mod 11.
# Coordinates: x0=1 chart, y = x-P, y = u1 e1 + u2 e2 + u3 e3 + s*v, v = (7,1,2,1) = ker Q.
# Solve grad_u g = 0 for u = phi(s) (Newton, series mod s^N), then h(s) = g(phi(s), s).
# ord_s h = m  =>  A_{m-1} singularity (corank 1).
p=11; N=16
# series in s: list of coeffs length N
def sadd(a,b): return [(x+y)%p for x,y in zip(a,b)]
def smul(a,b):
    out=[0]*N
    for i,x in enumerate(a):
        if x:
            for j,y in enumerate(b):
                if y and i+j<N: out[i+j]=(out[i+j]+x*y)%p
    return out
def sconst(c): return [c%p]+[0]*(N-1)
def svar(): return [0,1]+[0]*(N-2)  # s
# build g as polynomial in u1,u2,u3,s exactly: use sympy once to get integer coeff dict
from sympy import symbols, expand, Poly
x0,x1,x2,x3,x4 = xs = symbols('x0 x1 x2 x3 x4')
u1,u2,u3,s = symbols('u1 u2 u3 s')
f = x0**2*x1 + x1**2*x2 + x2**2*x3 + x3**2*x4 + x4**2*x0
Pt=[1,3,9,5,4]; v=[7,1,2,1]
y=[u1+s*v[0], u2+s*v[1], u3+s*v[2], s*v[3]]
sub={xs[0]:1}
for i in range(1,5): sub[xs[i]]=Pt[i]+y[i-1]
g = Poly(expand(f.subs(sub)), u1,u2,u3,s)
gd = {m:int(c)%p for m,c in g.as_dict().items() if int(c)%p}
# partial derivatives wrt u_i as dicts
def deriv(d, idx):
    out={}
    for m,c in d.items():
        if m[idx]:
            m2=list(m); m2[idx]-=1
            out[tuple(m2)]=(out.get(tuple(m2),0)+c*m[idx])%p
    return {m:c for m,c in out.items() if c}
G=[deriv(gd,i) for i in range(3)]
def evald(d, phi):
    # phi: list of 3 series for u; s series = svar
    tot=[0]*N
    sv=svar()
    for (a,b,c,e),co in d.items():
        term=sconst(co)
        for _ in range(a): term=smul(term,phi[0])
        for _ in range(b): term=smul(term,phi[1])
        for _ in range(c): term=smul(term,phi[2])
        for _ in range(e): term=smul(term,sv)
        tot=sadd(tot,term)
    return tot
# Jacobian at origin: d(G_i)/du_j constant terms
J=[[0]*3 for _ in range(3)]
for i in range(3):
    for jx in range(3):
        dd=deriv(G[i],jx)
        J[i][jx]=dd.get((0,0,0,0),0)
# invert J mod p
def matinv(M,p):
    n=len(M); A=[row[:]+[1 if i==j else 0 for j in range(n)] for i,row in enumerate(M)]
    for c in range(n):
        pr=next(i for i in range(c,n) if A[i][c]%p)
        A[c],A[pr]=A[pr],A[c]
        inv=pow(A[c][c],p-2,p); A[c]=[v*inv%p for v in A[c]]
        for i in range(n):
            if i!=c and A[i][c]%p:
                fct=A[i][c]; A[i]=[(a-fct*b)%p for a,b in zip(A[i],A[c])]
    return [row[n:] for row in A]
Ji=matinv(J,p)
phi=[sconst(0) for _ in range(3)]
for it in range(8):
    R=[evald(G[i],phi) for i in range(3)]
    # phi -= Ji * R
    for i in range(3):
        corr=[0]*N
        for jx in range(3):
            corr=sadd(corr,smul(sconst(Ji[i][jx]),R[jx]))
        phi[i]=[(a-b)%p for a,b in zip(phi[i],corr)]
R=[evald(G[i],phi) for i in range(3)]
print("residuals (should be ~0 mod s^N):", [max(i for i,c in enumerate(r) if c) if any(r) else None for r in R])
h=evald(gd,phi)
print("h(s) series coeffs mod 11:", h)
ordh=next((i for i,c in enumerate(h) if c), None)
print("ord_s h =", ordh, "=> A_%s singularity (if corank 1)" % (ordh-1 if ordh else "?"))
