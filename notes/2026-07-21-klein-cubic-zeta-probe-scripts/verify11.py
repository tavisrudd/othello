# Brute force projective count of Klein cubic over F_11, no tricks.
p=11
cnt=0
pts=[]
# projective points: first nonzero coord = 1
from itertools import product
def f(x):
    x0,x1,x2,x3,x4=x
    return (x0*x0*x1 + x1*x1*x2 + x2*x2*x3 + x3*x3*x4 + x4*x4*x0) % p
N=0
for lead in range(5):
    for rest in product(range(p), repeat=4-lead):
        x=[0]*lead+[1]+list(rest)
        if f(x)==0: N+=1
print("N(11) =", N, "expected 1464 =", 1+11+121+1331)
