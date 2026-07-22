from itertools import product
# 1) verify stratum torus counts at q=11 against closed forms
p=11
def torus_count_S(p, S):
    # S subset of {0..4} of nonzero coords; f restricted
    mons=[(i,(i+1)%5) for i in range(5) if i in S and (i+1)%5 in S]
    cnt=0
    idx=sorted(S)
    for vals in product(range(1,p), repeat=len(idx)):
        x={i:v for i,v in zip(idx,vals)}
        s=sum(x[i]*x[i]*x[j] for (i,j) in mons)%p
        if s==0: cnt+=1
    return cnt
q=p
print("S=full:", torus_count_S(p,{0,1,2,3,4}), "formula", ((q-1)**5-(q-1))//q)
print("S={1,2,3,4}:", torus_count_S(p,{1,2,3,4}), "formula", ((q-1)**4-(q-1))//q)
print("S={0,1,2}:", torus_count_S(p,{0,1,2}), "formula", ((q-1)**3+(q-1))//q)
print("S={0,1,3}:", torus_count_S(p,{0,1,3}), "formula 0")
# closed form for N vs known
for k,Nk in [(1,1464),(2,1786324),(3,2359720584),(4,3138642750244),(5,4177274107001304)]:
    q=11**k
    Nf=(  ((q-1)**4+5*(q-1)**3+5*(q-1)**2-1)//q + 5*q )
    print(f"k={k}: closed form {Nf} == computed {Nk}: {Nf==Nk}  == 1+q+q^2+q^3: {Nf==1+q+q*q+q**3}")
# 2) singular points of X over F_11 (projective)
def grad(x,p):
    x0,x1,x2,x3,x4=x
    return [(2*x0*x1+x4*x4)%p,(x0*x0+2*x1*x2)%p,(x1*x1+2*x2*x3)%p,(x2*x2+2*x3*x4)%p,(x3*x3+2*x4*x0)%p]
sing=[]
for lead in range(5):
    for rest in product(range(p),repeat=4-lead):
        x=[0]*lead+[1]+list(rest)
        if all(v==0 for v in grad(x,p)): sing.append(tuple(x))
print("singular points over F_11:", sing)
# sanity: same search for p=7 and p=13 (Klein cubic should be smooth there)
for pp in (7,13,5,3,2):
    s=0
    for lead in range(5):
        for rest in product(range(pp),repeat=4-lead):
            x=[0]*lead+[1]+list(rest)
            if all(v==0 for v in grad(x,pp)): s+=1
    print(f"p={pp}: #sing(F_p) = {s}")
