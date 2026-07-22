# Hilbert function of the Jacobian ideal J = (df/dx_i) mod 11: dim_F (S/J)_d for d = 0..10.
# If it stabilizes to a constant c, the projective singular scheme is 0-dimensional of degree c.
from sympy import symbols, groebner
from itertools import combinations_with_replacement
p=11
x0,x1,x2,x3,x4 = xs = symbols('x0 x1 x2 x3 x4')
f = x0**2*x1 + x1**2*x2 + x2**2*x3 + x3**2*x4 + x4**2*x0
grads=[f.diff(v) for v in xs]
G = groebner(grads, *xs, modulus=p, order='grevlex')
# leading monomials
lms=[g.LM(order='grevlex') for g in G.polys]
lm_exps=[tuple(m.exponents) if hasattr(m,'exponents') else None for m in lms]
# get exponent tuples via as_dict of LT
lts=[]
for g in G.polys:
    d=g.as_dict()
    # grevlex max monomial
    from sympy.polys.orderings import grevlex
    mx=max(d.keys(), key=lambda m: grevlex(m))
    lts.append(mx)
print("LT(J):", lts)
def divisible(m, lt):
    return all(a>=b for a,b in zip(m,lt))
for d in range(0,11):
    mons=list(combinations_with_replacement(range(5), d))
    cnt=0
    for mm in mons:
        e=[0]*5
        for i in mm: e[i]+=1
        if not any(divisible(tuple(e), lt) for lt in lts):
            cnt+=1
    print(f"d={d}: dim (S/J)_d standard monomials = {cnt}")
