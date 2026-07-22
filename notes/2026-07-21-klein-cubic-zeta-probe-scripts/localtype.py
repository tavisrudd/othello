from sympy import symbols, Matrix, Poly, expand, factor_list, GF
p=11
x0,x1,x2,x3,x4 = xs = symbols('x0 x1 x2 x3 x4')
f = x0**2*x1 + x1**2*x2 + x2**2*x3 + x3**2*x4 + x4**2*x0
P=[1,3,9,5,4]
y1,y2,y3,y4 = ys = symbols('y1 y2 y3 y4')
# affine chart x0=1, translate: x_i = P_i + y_i
sub={xs[0]:1}
for i in range(1,5): sub[xs[i]]=P[i]+ys[i-1]
g = expand(f.subs(sub))
gp = Poly(g, *ys, modulus=p)
print("constant:", gp.subs({y:0 for y in ys}))

# build quadratic form matrix
Q = Matrix(4,4, lambda i,j: 0)
cub_terms=[]
for mon,c in gp.terms():
    d=sum(mon); c=int(c)%p
    if d==2:
        idx=[i for i,e in enumerate(mon) for _ in range(e)]
        i,j=idx
        if i==j: Q[i,i]=(Q[i,i]+c)%p
        else:
            Q[i,j]=(Q[i,j]+c*pow(2,p-2,p))%p; Q[j,i]=Q[i,j]
    if d==1: print("LINEAR TERM PRESENT", mon, c)
print("Q (symmetric matrix of quadratic part) mod 11:"); print(Q)
# kernel of Q mod 11
M=Q.tolist()
import copy
def nullspace_mod(M,p):
    M=[[int(v)%p for v in row] for row in M]; n=len(M); m=len(M[0]); piv=[]
    r=0
    for c in range(m):
        pr=None
        for i in range(r,n):
            if M[i][c]%p: pr=i;break
        if pr is None: continue
        M[r],M[pr]=M[pr],M[r]
        inv=pow(M[r][c],p-2,p); M[r]=[v*inv%p for v in M[r]]
        for i in range(n):
            if i!=r and M[i][c]%p:
                f2=M[i][c]; M[i]=[(a-f2*b)%p for a,b in zip(M[i],M[r])]
        piv.append(c); r+=1
    free=[c for c in range(m) if c not in piv]
    basis=[]
    for fc in free:
        v=[0]*m; v[fc]=1
        for ri,c in enumerate(piv):
            v[c]=(-M[ri][fc])%p
        basis.append(v)
    return basis
ker=nullspace_mod(M,p)
print("ker Q:", ker)
# cubic part evaluated on kernel direction
if len(ker)==1:
    v=ker[0]
    t=symbols('t')
    val = gp.as_expr().subs({ys[i]: v[i]*t for i in range(4)})
    print("g(t*v) =", Poly(expand(val), t, modulus=p).as_expr())
