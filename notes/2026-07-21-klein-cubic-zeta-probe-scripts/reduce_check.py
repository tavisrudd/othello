# Verify reduction chain over F_p (prime fields only, p=11 and p^2 via GF? here just p=11).
# Chain:
#  N(q) = 1+q+q^2+2q + q^2 + ... derived: N = q^3+q^2+2q+1 + S(q)
#  S(q) = sum_{x1,x2,x3 in F_q} chi(x3^4 - 4*(x1 + x1^2 x2 + x2^2 x3))   [x0=1]
#  S(q) = q * T(q),  T(q) = sum over curve C: x2*x3^4 - 4*x2^3*x3 + 1 = 0, x2 != 0, of chi(-4 x2)
#  tr(F^k|H^3) = -q(1+T(q))
p=11
sq=set((i*i)%p for i in range(1,p))
def chi(a):
    a%=p
    if a==0: return 0
    return 1 if a in sq else -1
S=0
for x1 in range(p):
    for x2 in range(p):
        for x3 in range(p):
            a=(x1 + x1*x1*x2 + x2*x2*x3)%p
            S+=chi(x3**4 - 4*a)
T=0
for x2 in range(1,p):
    for x3 in range(p):
        if (x2*x3**4 - 4*x2**3*x3 + 1)%p==0:
            T+=chi(-4*x2)
print("S =",S,"  q*T =",p*T,"  match:",S==p*T)
N = p**3+p**2+2*p+1+S
print("N from S:",N, " tr = ", -p*(1+T))
