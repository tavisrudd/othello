from sympy import symbols, Poly, expand, Matrix, GF, linsolve, series
p=11
x0,x1,x2,x3,x4 = xs = symbols('x0 x1 x2 x3 x4')
f = x0**2*x1 + x1**2*x2 + x2**2*x3 + x3**2*x4 + x4**2*x0
P=[1,3,9,5,4]
u1,u2,u3,s = symbols('u1 u2 u3 s')
# affine chart x0=1, y = x - P; kernel direction v=(7,1,2,1) in y-coords.
# choose complement basis e1,e2,e3 = y1,y2,y3 axes (check Q restricted nondegenerate).
v=[7,1,2,1]
# y = u1*e1 + u2*e2 + u3*e3 + s*v
y=[u1 + s*v[0], u2 + s*v[1], u3 + s*v[2], s*v[3]]
sub={xs[0]:1}
for i in range(1,5): sub[xs[i]]=P[i]+y[i-1]
g = Poly(expand(f.subs(sub)), u1,u2,u3,s, modulus=p)
# check quadratic part in u alone is nondegenerate: coefficient matrix of u_i u_j at s=0
from itertools import product
def coeff(poly, mon):
    d=poly.as_dict()
    return int(d.get(mon,0))%p
Qm=[[0]*3 for _ in range(3)]
for i in range(3):
    for j in range(3):
        mon=[0,0,0,0]; mon[i]+=1; mon[j]+=1
        c=coeff(g,tuple(mon))
        Qm[i][j]=(c* (pow(2,p-2,p) if i!=j else 1))%p
# careful: coeff of u_i^2 is Q_ii; coeff of u_i u_j (i<j) is 2Q_ij
QM=[[0]*3 for _ in range(3)]
for i in range(3):
    mon=[0,0,0,0]; mon[i]=2
    QM[i][i]=coeff(g,tuple(mon))
for i in range(3):
    for j in range(i+1,3):
        mon=[0,0,0,0]; mon[i]=1; mon[j]=1
        c=coeff(g,tuple(mon))
        QM[i][j]=QM[j][i]=c*pow(2,p-2,p)%p
M=Matrix(QM)
print("Q_u matrix:",QM," det mod 11 =", M.det()%p)
# iteratively solve du g = 0: u_i = phi_i(s), power series
NMAX=12
phi=[0,0,0]
for order in range(2,NMAX):
    # substitute current phi + c_i s^order, solve linear system for c
    c1,c2,c3=cs=symbols('c1 c2 c3')
    trial=[phi[i]+cs[i]*s**order for i in range(3)]
    eqs=[]
    for i in range(3):
        dg = g.as_expr().diff([u1,u2,u3][i])
        val = dg.subs({u1:trial[0],u2:trial[1],u3:trial[2]})
        pol = Poly(expand(val), s, c1,c2,c3, modulus=p)
        # coefficient of s^order (lower orders should already vanish)
        e = expand(val)
        ser = Poly(e, s)
        # extract coefficient of s^order as linear function of c
        co = ser.as_expr().coeff(s, order)
        eqs.append(co)
        for low in range(order):
            lowco = ser.as_expr().coeff(s, low)
            lowpol = Poly(lowco, c1,c2,c3, modulus=p) if lowco != 0 else None
            if lowpol is not None and any(int(v)%p for v in lowpol.as_dict().values()):
                # lower-order coefficient must not involve c and must be 0 mod p
                const = lowpol.as_dict().get((0,0,0),0)
                # c's shouldn't appear at lower order
    sol = linsolve([Poly(e, c1,c2,c3, modulus=p).as_expr() for e in eqs], c1,c2,c3)
    solv=list(sol)[0]
    phi=[expand(phi[i]+solv[i]*s**order) for i in range(3)]
h = expand(g.as_expr().subs({u1:phi[0],u2:phi[1],u3:phi[2]}))
hp = Poly(h, s, modulus=p)
# print low-order coefficients
coeffs = {d: hp.as_expr().coeff(s,d) for d in range(0,NMAX+3)}
print("h(s) coefficients mod 11 (degree: value):")
for d in range(0,NMAX+1):
    c = Poly(coeffs[d], s, modulus=p).as_expr() if coeffs[d]!=0 else 0
    print(" ", d, ":", c)
