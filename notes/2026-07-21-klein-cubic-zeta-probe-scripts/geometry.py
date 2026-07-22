from sympy import symbols, groebner, GF, Matrix, factor_list, Poly
x0,x1,x2,x3,x4 = xs = symbols('x0 x1 x2 x3 x4')
f = x0**2*x1 + x1**2*x2 + x2**2*x3 + x3**2*x4 + x4**2*x0
grads=[f.diff(v) for v in xs]
P=[1,3,9,5,4]
# Hessian at P mod 11
H=Matrix(5,5, lambda i,j: f.diff(xs[i],xs[j]).subs(dict(zip(xs,P))) % 11)
print("Hessian mod 11 at P:"); print(H)
# rank mod 11
import itertools
def rank_mod(M,p):
    M=[[int(v)%p for v in row] for row in M.tolist()]; n=len(M); r=0
    for c in range(len(M[0])):
        piv=None
        for i in range(r,n):
            if M[i][c]%p: piv=i;break
        if piv is None: continue
        M[r],M[piv]=M[piv],M[r]
        inv=pow(M[r][c],p-2,p)
        M[r]=[v*inv%p for v in M[r]]
        for i in range(n):
            if i!=r and M[i][c]%p:
                fct=M[i][c]; M[i]=[(a-fct*b)%p for a,b in zip(M[i],M[r])]
        r+=1
    return r
print("Hessian rank mod 11 at P:", rank_mod(H,11))
# Groebner basis of Jacobian ideal mod 11 (plus f, redundant by Euler)
G = groebner(grads, *xs, modulus=11, order='grevlex')
print("Jacobian ideal GB mod 11 (grevlex), num gens:", len(G.exprs))
for g in G.exprs: print("  ", g)
