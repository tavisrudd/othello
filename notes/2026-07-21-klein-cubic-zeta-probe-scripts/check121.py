# F_121 = F_11[t]/(t^2 - g) where g is a nonresidue mod 11. 2 is a nonresidue mod 11? squares mod 11: 1,3,4,5,9. 2 is nonresidue.
p=11; q=p*p
# element = (a,b) ~ a + b t, t^2 = 2
def mul(x,y):
    a,b=x; c,d=y
    return ((a*c+2*b*d)%p, (a*d+b*c)%p)
def add(x,y): return ((x[0]+y[0])%p,(x[1]+y[1])%p)
def neg(x): return ((-x[0])%p,(-x[1])%p)
ZERO=(0,0); ONE=(1,0)
els=[(a,b) for a in range(p) for b in range(p)]
# chi via squares set
sqs=set()
for e in els:
    if e!=ZERO: sqs.add(mul(e,e))
def chi(x):
    if x==ZERO: return 0
    return 1 if x in sqs else -1
FOUR=(4,0)
def smul(k,x): return ((k*x[0])%p,(k*x[1])%p)
# triple loop quadratic trick: S = sum_{x1,x2,x3} chi(x3^4 - 4(x1 + x1^2 x2 + x2^2 x3))
S=0
for x1 in els:
    x1s=mul(x1,x1)
    for x2 in els:
        x2s=mul(x2,x2)
        t1=add(x1,mul(x1s,x2))
        for x3 in els:
            a=add(t1,mul(x2s,x3))
            x3s=mul(x3,x3)
            D=add(mul(x3s,x3s),smul(-4,a))
            S+=chi(D)
N=q**3+q**2+2*q+1+S
print("S(121) =",S," N(121) =",N," expected 1786324; tr2 =", (1+q+q**2+q**3)-N)
# curve formula
T=0
for x2 in els:
    if x2==ZERO: continue
    x2c=mul(mul(x2,x2),x2)
    for x3 in els:
        x3_4=mul(mul(x3,x3),mul(x3,x3))
        v=add(add(mul(x2,x3_4),smul(-4,mul(x2c,x3))),ONE)
        if v==ZERO:
            T+=chi(smul(-4,x2))
print("T(121) =",T," q*T =",q*T," S==q*T:",S==q*T)
