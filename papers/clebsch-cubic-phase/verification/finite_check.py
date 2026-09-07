"""Fresh exact draft checks, independent polynomial expansion; standard library only.
--write banks a canonical compact certificate; --check compares without mutation.
"""
import argparse
from collections import Counter
from itertools import combinations_with_replacement, product
import json
from math import factorial
import runpy
from check import REPO, V

DATA=runpy.run_path(str(REPO/'notes/2026-09-06-clebsch-quantum-replay/common.py'))

def rank(rows,p):
    a=[list(row) for row in rows]; k=0
    for j in range(len(a[0])):
        pivot=next((i for i in range(k,len(a)) if a[i][j]%p),None)
        if pivot is None: continue
        a[k],a[pivot]=a[pivot],a[k]; inv=pow(a[k][j]%p,-1,p)
        a[k]=[x*inv%p for x in a[k]]
        for i in range(k+1,len(a)):
            c=a[i][j]%p
            a[i]=[(x-c*y)%p for x,y in zip(a[i],a[k])]
        k+=1
        if k==len(a):break
    return k

def cubic(rows,signs,p):
    d={};k=len(rows[0])
    for mon in combinations_with_replacement(range(k),3):
        mult=6
        for n in Counter(mon).values():mult//=factorial(n)
        value=mult*sum(s*row[mon[0]]*row[mon[1]]*row[mon[2]] for s,row in zip(signs,rows))%p
        if value:d[mon]=value
    return d

def expected(terms,p):
    return {tuple(sorted(mon)):c%p for c,mon in terms if c%p}

def run():
    out={}
    for p in [7,11]:
        E=DATA['E7' if p==7 else 'E11'];k=p-1;n=2*p
        g=[[1]*n]+[[row[j] for row in E] for j in range(k)]
        signs=[1]*p+[-1]*p
        assert len({tuple(x) for x in E})==n and rank(g,p)==p
        sq=[[a*b%p for a,b in zip(g[i],g[j])] for i in range(p) for j in range(i,p)]
        assert rank(sq,p)==n-1
        assert all(sum(s*x for s,x in zip(signs,row))%p==0 for row in sq)
        # Substitute the coordinate matrices into each linear form before cubing.
        if p==7:
            # New order a,b,c,d,e,s.
            transform=[[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,1],
                       [0,0,1,0,0,3],[0,0,0,1,0,0],[0,0,0,0,1,0]]
            terms=[(4,(5,0,4)),(-16,(5,1,3)),(12,(5,2,2)),(3,(0,2,4)),
                   (6,(1,2,3)),(-3,(0,3,3)),(-3,(1,1,4)),(-3,(2,2,2))]
        else:
            transform=[[0]*10 for _ in range(10)]
            for old,new,c in [(0,0,1),(1,1,1),(2,2,7),(3,3,6),(4,4,6),(4,9,3),
                              (5,4,3),(5,9,1),(6,5,6),(7,6,7),(8,7,1),(9,8,1)]:transform[old][new]=c
            i2=[(2,(0,8)),(6,(1,7)),(1,(2,6)),(9,(3,5)),(4,(4,4))]
            i3=[(6,(0,4,8)),(9,(0,5,7)),(7,(0,6,6)),(9,(1,3,8)),(6,(1,4,7)),
                (7,(1,5,6)),(7,(2,2,8)),(7,(2,3,7)),(1,(2,5,5)),(1,(3,3,6)),
                (4,(3,4,5)),(2,(4,4,4))]
            terms=[(4*c,mon+(9,)) for c,mon in i2]+[(2*c,mon) for c,mon in i3]
        assert rank(transform,p)==k
        transformed=[[sum(row[i]*transform[i][j] for i in range(k))%p for j in range(k)] for row in E]
        assert cubic(transformed,signs,p)==expected(terms,p)
        out[str(p)]={'affine_rank':p,'schur_square_rank':n-1,'normal_form_coefficients_checked':True}
        if p==7:
            tensor=[[[sum(s*row[m]*row[i]*row[j] for s,row in zip(signs,E))%p
                       for j in range(k)] for i in range(k)] for m in range(k)]
            counts=Counter({0:1});lines=0
            for lead in range(k):
                for tail in product(range(p),repeat=k-lead-1):
                    vector=[0]*lead+[1]+list(tail)
                    h=[[sum(vector[m]*tensor[m][i][j] for m in range(k))%p for j in range(k)] for i in range(k)]
                    counts[rank(h,p)]+=p-1;lines+=1
            assert counts=={0:1,3:48,4:2940,5:26502,6:88158}
            out[str(p)]['projective_points']=lines
            out[str(p)]['vector_rank_counts']=dict(sorted(counts.items()))
    out['translation']={}
    for p in [5,7,11,13,17,19,23]:
        k=p-1; sheet=[[int(i==j) for j in range(k)] for i in range(k)]+[[-1]*k]
        E=sheet+[[row[j]+int(j==0) for j in range(k)] for row in sheet]
        g=[[1]*(2*p)]+[[row[j]%p for row in E] for j in range(k)]
        sq=[[a*b%p for a,b in zip(g[i],g[j])] for i in range(p) for j in range(i,p)]
        assert rank(g,p)==p and rank(sq,p)==2*p-1
        assert all((sum(row[:p])-sum(row[p:]))%p==0 for row in sq)
        out['translation'][str(p)]={'affine_rank':p,'schur_square_rank':2*p-1}
    return out

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--write',action='store_true');parser.add_argument('--check',action='store_true');args=parser.parse_args()
    data=json.dumps(run(),indent=2,sort_keys=True)+'\n';target=V/'finite-certificate.json'
    if args.write:target.write_text(data)
    else:assert target.read_text()==data,'finite certificate drift'
    print('PASS: both conic moment/rank and normal-form identities; fresh full p=7 census; seven translation controls.')
