"""Resolve actual/projective cubic normalization and test geometric restrictions.
Reads pinned committed intermediates; emits portable, explicit shadow data.
"""
import argparse
from itertools import combinations
import json
import pickle
import sys
from check import REPO,V
SOURCE=REPO/'notes/2026-09-07-c1099-cubic-phase-strengthening/paperv'
sys.path.insert(0,str(SOURCE))
from geom11 import matmul,matinv,identity
from step4_bridge import subst_cubic,pnorm,BASIS3
from finite_check import rank

def determinant(rows,p=11):
    a=[list(row) for row in rows];d=1
    for j in range(len(a)):
        k=next((i for i in range(j,len(a)) if a[i][j]%p),None)
        if k is None:return 0
        if k!=j:a[k],a[j]=a[j],a[k];d=-d
        c=a[j][j]%p;d=d*c%p;inv=pow(c,-1,p)
        for i in range(j+1,len(a)):
            b=a[i][j]*inv%p
            a[i]=[(x-b*y)%p for x,y in zip(a[i],a[j])]
    return d%p

def run():
    with (SOURCE/'out/bridge.pkl').open('rb') as f:b=pickle.load(f)
    with (SOURCE/'out/pencil.pkl').open('rb') as f:c=pickle.load(f)
    with (SOURCE/'out/action.pkl').open('rb') as f:a=pickle.load(f)
    h=list(b['cvec']);q=b['q'];psi=b['psi']
    h2=list(subst_cubic(h,q))
    other=list(next(x for x in c['chordal'] if x!=c['cN']))
    assert list(pnorm(h2))==other
    assert h2==[(2*x)%11 for x in other] and h2!=other
    assert matmul(q,q)==identity(5) and determinant(q)==10
    assert list(subst_cubic(h2,q))==h
    assert list(subst_cubic(h,[[8*x%11 for x in row] for row in q]))==other
    selected=next(rows for rows in combinations(range(10),5) if rank([psi[i] for i in rows],11)==5)
    inverse=matinv([psi[i] for i in selected]);restrictions=[];groups=[]
    for g,rho in a['rho'].items():
        image=matmul(rho,psi);r=matmul(inverse,[image[i] for i in selected])
        if matmul(psi,r)==image:groups.append(g);restrictions.append(r)
    assert len(a['rho'])==1320 and len(restrictions)==60
    assert set(groups)==set(b['rhoA'])
    assert all(determinant(r)==1 for r in restrictions)
    assert q not in restrictions
    return dict(field=11,basis3=[list(m) for m in BASIS3],augmentation_embedding=psi,
                outer_permutation=b['tau'],q=q,actual_first=h,actual_second=h2,
                normalized_second=other,normalization_scalar=2,conference=list(b['conf'][0]),
                q_squared_identity=True,q_determinant=10,geometric_actions_tested=1320,
                preserving_actions=60,preserving_determinants=[1],q_is_geometric_restriction=False,
                pullback_to_normalized_second='8*q',state_map_to_normalized_second='7*q')

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--write',action='store_true');parser.add_argument('--check',action='store_true');args=parser.parse_args()
    result=json.dumps(run(),indent=2,sort_keys=True)+'\n';target=V/'shadow-certificate.json'
    if args.write:target.write_text(result)
    else:assert target.read_text()==result,'shadow certificate drift'
    print('PASS: exact scalar 2; actual involutory exchange; all 1320 geometric actions, 60 preserving restrictions, none equals q.')
