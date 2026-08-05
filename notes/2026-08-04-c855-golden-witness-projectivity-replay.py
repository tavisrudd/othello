import itertools
P=11
W=[(1,10,0),(1,9,1),(1,4,7),(1,8,5),(0,1,4),(1,1,7)]  # Examples.q11Witness
def norm(v):
    for c in v:
        if c% P: 
            inv=pow(c%P,P-2,P); return tuple((x*inv)%P for x in v)
    raise ValueError
def golden(phi):
    return [(1,0,0),(phi,1,1),(0,1,0),(1,phi,1),(0,0,1),(1,1,(2-phi)%P)]
def apply(m,v): return tuple(sum(m[i][j]*v[j] for j in range(3))%P for i in range(3))
Wn=sorted(norm(v) for v in W)
for phi in (4,8):
    assert (phi*phi-phi-1)%P==0
    G=golden(phi)
    found=None
    # search projectivities carrying G onto W as a set: fix images of first 4 points (frame)
    for img in itertools.permutations(range(6),4):
        # solve m with m*G[k] ~ W[img[k]]
        import itertools as it
        # brute force scalars for first three, fourth fixes them
        A=[G[0],G[1],G[2]]
        # matrix columns: m*A[k] = lam_k * W[img[k]]
        for lam in itertools.product(range(1,P),repeat=3):
            cols=[tuple(lam[k]*c%P for c in W[img[k]]) for k in range(3)]
            m=[[cols[k][i] for k in range(3)] for i in range(3)]  # m maps e_k -> cols[k]
            # need m * G[k] = cols in basis where G[0..2] are e0,e1,e2? G[0]=(1,0,0),G[2]=(0,1,0),G[4]=(0,0,1)
            pass
        break
    # simpler: G[0],G[2],G[4] are the standard basis vectors
    ok=[]
    for img in itertools.permutations(range(6),3):
        for lam in itertools.product(range(1,P),repeat=3):
            cols=[tuple(lam[k]*c%P for c in W[img[k]]) for k in range(3)]
            m=[[cols[k][i] for k in range(3)] for i in range(3)]
            det=(m[0][0]*(m[1][1]*m[2][2]-m[1][2]*m[2][1])-m[0][1]*(m[1][0]*m[2][2]-m[1][2]*m[2][0])+m[0][2]*(m[1][0]*m[2][1]-m[1][1]*m[2][0]))%P
            if det==0: continue
            imgs=sorted(norm(apply(m,g)) for g in G)
            if imgs==Wn:
                ok.append((img,lam,m)); break
        if ok: break
    print("phi",phi,"projectivity found:",bool(ok), ok[0][2] if ok else None)
