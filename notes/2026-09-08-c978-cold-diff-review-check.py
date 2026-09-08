"""Cold-review finite algebra check; no geometric or formal-certification claim.
Replay: uv run --with sympy==1.14.0 python3 notes/2026-09-08-c978-cold-diff-review-check.py
"""
import json
import sympy as s

a,b,q,T,r=s.symbols('a b q T r')
U=s.Matrix([[0,a*q,0,a*a*q*q],[1,0,b*q,0],[0,1,0,a*q],[0,0,1,0]])
D=s.diag(3,1,-1,-3)/2
C=s.Matrix([[a*q,0,0,-(a+b)*q],[0,(a+b)*q,-a*q,0],[1,0,0,1],[0,1,1,0]])
def check(v):
    assert all(s.cancel(x)==0 for x in (list(v) if isinstance(v,s.MatrixBase) else [v]))
def reduce(U,C,blocks):
    J=(C.inv()*U*C).applyfunc(s.factor)
    B=(C.inv()*D*C).applyfunc(s.factor)
    X=s.zeros(4)
    for lo,hi in blocks:
        for lj,hj in blocks:
            if lo==lj: continue
            vs=s.symbols('x:'+str((hi-lo)*(hj-lj)))
            W=s.Matrix(hi-lo,hj-lj,vs)
            sol=s.solve(list(J[lo:hi,lo:hi]*W-W*J[lj:hj,lj:hj]+B[lo:hi,lj:hj]),vs,dict=True)
            assert len(sol)==1
            X[lo:hi,lj:hj]=W.subs(sol[0])
    B1=(B+J*X-X*J).applyfunc(s.factor)
    B2=(B*X-X*B1-X).applyfunc(s.factor)
    return J,B1,B2
J,B1,B2=reduce(U,C,[(0,2),(2,4)])
check(C.det()+q*q*(2*a+b)**2)
check(U.charpoly(T).as_expr()-T*T*(T*T-(2*a+b)*q))
check(J-s.diag(s.Matrix([[0,(2*a+b)*q],[1,0]]),s.Matrix([[0,1],[0,0]])))
R=s.Matrix([[B1[2,2],1],[B2[3,2],B1[3,3]-1]])
check(R-s.Matrix([[-(2*a+3*b)/(2*(2*a+b)),1],[-4*a*a/(2*a+b)**2,(b-2*a)/(2*(2*a+b))]]))
delta=s.factor(s.trace(R)**2-4*R.det())
check(delta-4*(b-2*a)/(2*a+b))
cases={}
for degree,aa,bb in [(1,240,1248),(2,48,160),(3,24,60)]:
    RR=R.subs({a:aa,b:bb})
    cases[str(degree)]={'eigenvalues':sorted(map(str,RR.eigenvals())), 'discriminant':str(delta.subs({a:aa,b:bb}))}
# Appendix uses a genuinely different 1|1|2 splitting.
CC=s.Matrix([[6*r**3,-6*r**3,0,-7*r*r],[7*r*r,7*r*r,-2*r*r,0],[3*r,-3*r,0,1],[1,1,1,0]])
UU=2*U.subs({a:6,b:15,q:r*r/3})
JJ,BB1,BB2=reduce(UU,CC,[(0,1),(1,2),(2,4)])
check(CC.det()+486*r**5)
check(BB1[2:,2:]-s.diag(-s.Rational(19,18),s.Rational(19,18)))
check(BB2[2:,2:]-s.Matrix([[0,-14/(81*r*r)],[-s.Rational(8,81),0]]))
print(json.dumps({'status':'pass','sympy':s.__version__,'domain':'Q(a,b,q), q(2a+b) != 0; appendix Q(r), r != 0', 'checks':['universal characteristic polynomial and primary split','Sylvester first jet solved from scratch','modified residue and discriminant','three Fano specializations','separate appendix split and complete printed A1'], 'cases':cases},indent=2,sort_keys=True))
