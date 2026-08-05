import itertools
p=11
def norm(v):
    for c in v:
        if c%p: inv=pow(c,p-2,p); return tuple((x*inv)%p for x in v)
    return None
pts=set()
for a in range(p):
    for b in range(p):
        for c in range(p):
            if (a,b,c)!=(0,0,0): pts.add(norm((a,b,c)))
W=[(1,10,0),(1,9,1),(1,4,7),(1,8,5),(0,1,4),(1,1,7)]
W=[norm(v) for v in W]
assert len(set(W))==6
def det3(u,v,w):
    return (u[0]*(v[1]*w[2]-v[2]*w[1])-u[1]*(v[0]*w[2]-v[2]*w[0])+u[2]*(v[0]*w[1]-v[1]*w[0]))%p
# arc check
arc=all(det3(a,b,c)%p for a,b,c in itertools.combinations(W,3))
print("q11Witness is a six-arc:", arc)
def cross(u,v):
    return norm((u[1]*v[2]-u[2]*v[1], u[2]*v[0]-u[0]*v[2], u[0]*v[1]-u[1]*v[0]))
secants=[cross(a,b) for a,b in itertools.combinations(W,2)]
assert len(set(secants))==15
cnt=0
for x in pts:
    if x in W: continue
    k=sum(1 for l in secants if (x[0]*l[0]+x[1]*l[1]+x[2]*l[2])%p==0)
    if k==3: cnt+=1
print("Brianchon points of q11Witness:", cnt)
# golden hexagon phi=4 and 8
for phi in (4,8):
    G=[norm(v) for v in [(1,0,0),(phi,1,1),(0,1,0),(1,phi,1),(0,0,1),(1,1,(2-phi)%p)]]
    Garc=all(det3(a,b,c)%p for a,b,c in itertools.combinations(G,3))
    # find projectivity mapping G-set onto W-set: try mapping a frame of G to images among W
    found=None
    pass
    def solve_frame(src4, dst4):
        # find M with M*src_i ~ dst_i, i=0..3
        # M columns determined: standard frame method
        # send src frame to std frame then std to dst
        def to_std(q4):
            A=[[q4[j][i] for j in range(3)] for i in range(3)]  # columns q0,q1,q2
            # solve A*l = q3
            import fractions
            # gauss over GF(p)
            M=[row[:] for row in A]
            b=list(q4[3])
            n=3
            aug=[M[i]+[b[i]] for i in range(3)]
            # gaussian elim mod p
            r=0
            for c in range(3):
                piv=None
                for i in range(r,3):
                    if aug[i][c]%p: piv=i; break
                if piv is None: return None
                aug[r],aug[piv]=aug[piv],aug[r]
                inv=pow(aug[r][c],p-2,p)
                aug[r]=[(x*inv)%p for x in aug[r]]
                for i in range(3):
                    if i!=r and aug[i][c]%p:
                        f=aug[i][c]
                        aug[i]=[(aug[i][k]-f*aug[r][k])%p for k in range(4)]
                r+=1
            l=[aug[i][3] for i in range(3)]
            if any(x%p==0 for x in l): return None
            # matrix columns l_i * q_i
            return [[ (l[j]*q4[j][i])%p for j in range(3)] for i in range(3)]  # rows i, cols j
        A=to_std(src4); B=to_std(dst4)
        if A is None or B is None: return None
        # M = B * A^{-1}
        # invert A mod p
        def inv3(M):
            d=det3(tuple(M[0]),tuple(M[1]),tuple(M[2]))
            if d%p==0: return None
            di=pow(d,p-2,p)
            C=[[0]*3 for _ in range(3)]
            for i in range(3):
                for j in range(3):
                    m=[[M[r][c] for c in range(3) if c!=j] for r in range(3) if r!=i]
                    co=(m[0][0]*m[1][1]-m[0][1]*m[1][0])%p
                    C[j][i]=((-1)**(i+j)*co*di)%p
            return C
        Ai=inv3(A)
        if Ai is None: return None
        return [[sum(B[i][k]*Ai[k][j] for k in range(3))%p for j in range(3)] for i in range(3)]
    src4=G[:4]
    Wset=set(W)
    Gset=set(G)
    for dst4 in itertools.permutations(W,4):
        M=solve_frame(src4,list(dst4))
        if M is None: continue
        img=set(norm(tuple(sum(M[i][k]*g[k] for k in range(3))%p for i in range(3))) for g in G)
        if img==Wset:
            found=M; break
    print(f"phi={phi}: golden hexagon is arc: {Garc}; projectivity onto q11Witness found:", found is not None)
    if found: print("   matrix:", found)
