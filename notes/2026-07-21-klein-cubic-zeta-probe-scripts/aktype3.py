p=11; N=20
def sadd(a,b): return [(x+y)%p for x,y in zip(a,b)]
def smul(a,b):
    out=[0]*N
    for i,x in enumerate(a):
        if x:
            for j,y in enumerate(b):
                if y and i+j<N: out[i+j]=(out[i+j]+x*y)%p
    return out
def sconst(c): return [c%p]+[0]*(N-1)
def svar(): return [0,1]+[0]*(N-2)
from sympy import symbols, expand, Poly
import random
random.seed(5)
x0,x1,x2,x3,x4 = xs = symbols('x0 x1 x2 x3 x4')
u1,u2,u3,s = symbols('u1 u2 u3 s')
f = x0**2*x1 + x1**2*x2 + x2**2*x3 + x3**2*x4 + x4**2*x0
Pt=[1,3,9,5,4]; v=[7,1,2,1]
def run(basis):
    y=[0]*4
    for i in range(4):
        y[i] = u1*basis[0][i] + u2*basis[1][i] + u3*basis[2][i] + s*v[i]
    sub={xs[0]:1}
    for i in range(1,5): sub[xs[i]]=Pt[i]+y[i-1]
    g = Poly(expand(f.subs(sub)), u1,u2,u3,s)
    gd = {m:int(c)%p for m,c in g.as_dict().items() if int(c)%p}
    def deriv(d, idx):
        out={}
        for m,c in d.items():
            if m[idx]:
                m2=list(m); m2[idx]-=1
                out[tuple(m2)]=(out.get(tuple(m2),0)+c*m[idx])%p
        return {m:c for m,c in out.items() if c}
    G=[deriv(gd,i) for i in range(3)]
    def evald(d, phi):
        tot=[0]*N; sv=svar()
        for (a,b,c,e),co in d.items():
            term=sconst(co)
            for _ in range(a): term=smul(term,phi[0])
            for _ in range(b): term=smul(term,phi[1])
            for _ in range(c): term=smul(term,phi[2])
            for _ in range(e): term=smul(term,sv)
            tot=sadd(tot,term)
        return tot
    J=[[deriv(G[i],jx).get((0,0,0,0),0) for jx in range(3)] for i in range(3)]
    det = (J[0][0]*(J[1][1]*J[2][2]-J[1][2]*J[2][1]) - J[0][1]*(J[1][0]*J[2][2]-J[1][2]*J[2][0]) + J[0][2]*(J[1][0]*J[2][1]-J[1][1]*J[2][0]))%p
    if det==0: return None
    def matinv(M,p):
        n=len(M); A=[row[:]+[1 if i==j else 0 for j in range(n)] for i,row in enumerate(M)]
        for c in range(n):
            pr=next(i for i in range(c,n) if A[i][c]%p)
            A[c],A[pr]=A[pr],A[c]
            inv=pow(A[c][c],p-2,p); A[c]=[vv*inv%p for vv in A[c]]
            for i in range(n):
                if i!=c and A[i][c]%p:
                    fct=A[i][c]; A[i]=[(a-fct*b)%p for a,b in zip(A[i],A[c])]
        return [row[n:] for row in A]
    Ji=matinv(J,p)
    phi=[sconst(0) for _ in range(3)]
    for it in range(10):
        R=[evald(G[i],phi) for i in range(3)]
        for i in range(3):
            corr=[0]*N
            for jx in range(3):
                corr=sadd(corr,smul(sconst(Ji[i][jx]),R[jx]))
            phi[i]=[(a-b)%p for a,b in zip(phi[i],corr)]
    R=[evald(G[i],phi) for i in range(3)]
    resmin=[next((i for i,c in enumerate(r) if c), 'zero') for r in R]
    h=evald(gd,phi)
    ordh=next((i for i,c in enumerate(h) if c), None)
    return resmin, ordh, h
print("standard basis:", run([[1,0,0,0],[0,1,0,0],[0,0,1,0]]))
for trial in range(3):
    b=[[random.randrange(p) for _ in range(4)] for _ in range(3)]
    r=run(b)
    print("random basis", trial, ":", None if r is None else (r[0], r[1]))
