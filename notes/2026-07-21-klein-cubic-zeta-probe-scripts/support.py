from sympy import symbols, groebner, expand
from itertools import combinations_with_replacement
p=11
x0,x1,x2,x3,x4 = xs = symbols('x0 x1 x2 x3 x4')
f = x0**2*x1 + x1**2*x2 + x2**2*x3 + x3**2*x4 + x4**2*x0
grads=[f.diff(v) for v in xs]
# points at infinity: J + (x0)
Ginf = groebner(grads+[x0], *xs, modulus=p, order='grevlex')
print("GB(J + (x0)):", [g for g in Ginf.exprs])
# affine chart x0=1, translate P=(1,3,9,5,4) to origin
y1,y2,y3,y4 = ys = symbols('y1 y2 y3 y4')
P=[1,3,9,5,4]
sub={x0:1, x1:3+y1, x2:9+y2, x3:5+y3, x4:4+y4}
aff=[expand(g.subs(sub)) for g in grads]
Ga = groebner(aff, *ys, modulus=p, order='grevlex')
lts=[]
from sympy.polys.orderings import grevlex as gvl
for g in Ga.polys:
    d=g.as_dict()
    lts.append(max(d.keys(), key=lambda m: gvl(m)))
def divisible(m, lt): return all(a>=b for a,b in zip(m,lt))
# count standard monomials (total, all degrees, up to bound)
std=[]
for d in range(0,16):
    for mm in combinations_with_replacement(range(4), d):
        e=[0]*4
        for i in mm: e[i]+=1
        if not any(divisible(tuple(e), lt) for lt in lts): std.append(tuple(e))
print("affine quotient dim (#standard monomials):", len(std))
print("standard monomials:", std)
# nilpotency: reduce y_i^n mod GB for growing n
from sympy import reduced
for i,v in enumerate(ys):
    for n in range(1,15):
        _, r = reduced(v**n, Ga.polys, *ys, modulus=p, order='grevlex')
        if r == 0:
            print(f"y{i+1}^{n} = 0 mod J_aff  -> nilpotent")
            break
    else:
        print(f"y{i+1}: NOT nilpotent up to n=14")
