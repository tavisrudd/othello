"""Independent stdlib checks: modular Macaulay/rank certificates and signed group.

A nonzero maximal minor modulo 101 proves the corresponding rank over Q.
The degree-six Jacobian Macaulay matrix has full row rank, proving smoothness
of the rational seed. No symbolic Groebner engine or supplied code is used.
"""
import itertools
import json

P=101


def monomials(n,d):
    if n==1: return [(d,)]
    return [(i,)+tail for i in range(d+1) for tail in monomials(n-1,d-i)]


def derivative(f,j):
    out={}
    for ex,c in f.items():
        if ex[j]:
            new=list(ex);new[j]-=1;out[tuple(new)]=c*ex[j]
    return out


def shift(f,m):
    return {tuple(a+b for a,b in zip(ex,m)):c for ex,c in f.items()}


def rank_certificate(columns,basis):
    rows=[[col.get(m,0)%P for col in columns] for m in basis]
    pivots=[];r=0;det=1
    for j in range(len(columns)):
        k=next((k for k in range(r,len(rows)) if rows[k][j]),None)
        if k is None: continue
        if k!=r: rows[r],rows[k]=rows[k],rows[r];det=-det
        value=rows[r][j];det=det*value%P
        inv=pow(value,-1,P)
        rows[r]=[(x*inv)%P for x in rows[r]]
        for k in range(r+1,len(rows)):
            scale=rows[k][j]
            if scale: rows[k]=[(x-scale*y)%P for x,y in zip(rows[k],rows[r])]
        pivots.append(j);r+=1
        if r==len(rows): break
    return {'rank':r,'rows':len(basis),'columns':len(columns),'pivot_columns':pivots,
            'full_row_minor_det_mod_101':det if r==len(rows) else None}


def compose(g,h):
    return tuple((1 if i>0 else -1)*g[abs(i)-1] for i in h)


def inverse(g):
    out=[0]*len(g)
    for i,v in enumerate(g): out[abs(v)-1]=(i+1)*(1 if v>0 else -1)
    return tuple(out)


def closure(gens):
    group={tuple(range(1,6))};todo=list(group)
    while todo:
        h=todo.pop()
        for g in gens:
            gh=compose(g,h)
            if gh not in group:group.add(gh);todo.append(gh)
    return group


def main():
    f={(2,0,0,1,0):4,(2,0,1,0,0):-4,(1,1,0,0,1):24,
       (0,2,0,1,0):12,(0,2,1,0,0):12,(0,0,0,3,0):-4,
       (0,0,2,1,0):3,(0,0,0,1,2):9,(0,0,0,0,3):4}
    grads=[derivative(f,j) for j in range(5)]
    unit=monomials(5,1)
    orbit=[shift(g,m) for m in unit for g in grads]
    directions=[{m:1} for m in [(0,0,3,0,0),(0,0,2,0,1),(0,0,0,0,3)]]
    orbit_cert=rank_certificate(orbit,monomials(5,3))
    augmented=rank_certificate(orbit+directions,monomials(5,3))
    macaulay=rank_certificate([shift(g,m) for g in grads for m in monomials(5,4)],monomials(5,6))
    assert (orbit_cert['rank'],augmented['rank'],macaulay['rank'])==(25,28,210)
    sextic={(6,0):-1,(4,2):-9,(2,4):-27,(0,6):-11}
    binary_orbit=[shift(derivative(sextic,j),m) for m in monomials(2,1) for j in range(2)]
    binary_dirs=[{(3,3):32},{(2,4):32},{(0,6):32}]
    genus_orbit=rank_certificate(binary_orbit,monomials(2,6))
    genus_augmented=rank_certificate(binary_orbit+binary_dirs,monomials(2,6))
    uni={(ex[0],):c for ex,c in sextic.items()}
    du=derivative(uni,0)
    sylvester=rank_certificate([shift(uni,(i,)) for i in range(5)]+[shift(du,(i,)) for i in range(6)],[(i,) for i in range(11)])
    assert (genus_orbit['rank'],genus_augmented['rank'],sylvester['rank'])==(4,7,11)
    H=closure(((1,2,3,5,4),(1,2,3,-4,-5),(2,3,1,4,5),(-1,-3,-2,4,-5)))
    allowed=set()
    for perm in itertools.permutations((1,2,3)):
        sign=(-1)**sum(perm[i]>perm[j] for i in range(3) for j in range(i+1,3))
        for last in ((4,5),(5,4)):
            for epsilon in (-1,1):
                allowed.add(tuple(sign*i for i in perm)+(epsilon*last[0],sign*epsilon*last[1]))
    assert H==allowed and len(H)==24
    # TZ Proposition 4.1 convention: rightmost permutation first, c_i on images.
    standard=closure(((-1,-5,-3,4,-2),(5,1,-4,-3,2)))
    assert len(standard)==24
    conjugator=None;searched=0
    for perm in itertools.permutations(range(1,6)):
        for signs in itertools.product((-1,1),repeat=5):
            if signs.count(-1)%2: continue
            candidate=tuple(i*s for i,s in zip(perm,signs));searched+=1
            inv=inverse(candidate)
            if {compose(candidate,compose(h,inv)) for h in H}==standard:
                conjugator=candidate;break
        if conjugator: break
    assert conjugator is not None
    print(json.dumps(dict(status='pass',engine='Python stdlib, integers modulo 101 and signed permutations',
                          scope='Modular rank lower bounds become exact using column/row upper bounds; no geometric theorem is certified',
                          cubic_orbit=orbit_cert,cubic_augmented=augmented,jacobian_degree_six=macaulay,
                          genus_two_orbit=genus_orbit,genus_two_augmented=genus_augmented,
                          sextic_sylvester=sylvester,
                          galois={'group_order':24,'equals_all_allowed_sign_patterns':True,
                                  'conjugator_to_TZ_standard':conjugator,'conjugators_tested':searched}),indent=2))


if __name__=='__main__':main()
