from itertools import product
def grad(x,p):
    x0,x1,x2,x3,x4=x
    return [(2*x0*x1+x4*x4)%p,(x0*x0+2*x1*x2)%p,(x1*x1+2*x2*x3)%p,(x2*x2+2*x3*x4)%p,(x3*x3+2*x4*x0)%p]
def f(x,p):
    x0,x1,x2,x3,x4=x
    return (x0*x0*x1+x1*x1*x2+x2*x2*x3+x3*x3*x4+x4*x4*x0)%p
for p in (2,3,5,7,11,13,17,19,23):
    pts=[]
    for lead in range(5):
        for rest in product(range(p),repeat=4-lead):
            x=[0]*lead+[1]+list(rest)
            if f(x,p)==0 and all(v==0 for v in grad(x,p)):
                pts.append(tuple(x))
    print(f"p={p}: singular points of X over F_p: {pts}")
# structure checks at p=11
p=11
print("3^5 mod 11 =", pow(3,5,p), "; 2*3^3+1 mod 11 =", (2*27+1)%p)
print("P=(1,3,9,5,4) equals (1,z,z^2,z^3,z^4), z=3:", [pow(3,i,p) for i in range(5)])
