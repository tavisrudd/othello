#!/usr/bin/env python3
"""Replay illustrative recovery examples; no general theorem depends on this run."""
from __future__ import annotations

import argparse
import hashlib
import itertools as it
import json
from pathlib import Path
import random
import re

ROOT = Path(__file__).resolve().parent
P = 101
FAMILIES = {"A": [(1,5,8),(0,2,6),(0,4,5),(0,1,3),(4,7,8)],
            "B": [(1,6,8),(2,3,7),(0,7,8),(0,1,5),(1,2,4)]}


def rank(columns, p):
    if not columns:
        return 0
    a = [list(row) for row in zip(*columns)]
    r = 0
    for j in range(len(columns)):
        pivot = next((i for i in range(r, len(a)) if a[i][j] % p), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        inv = pow(a[r][j] % p, -1, p)
        a[r] = [(x * inv) % p for x in a[r]]
        for i in range(len(a)):
            if i != r:
                f = a[i][j]
                a[i] = [(x-f*y) % p for x,y in zip(a[i],a[r])]
        r += 1
        if r == len(a):
            break
    return r


def determinant(a, p):
    """Independent permutation expansion, sharing no elimination with rank()."""
    total = 0
    for perm in it.permutations(range(len(a))):
        inversions = sum(perm[i] > perm[j] for i in range(len(a)) for j in range(i+1,len(a)))
        term = (-1)**inversions
        for i,j in enumerate(perm):
            term *= a[i][j]
        total += term
    return total % p


def normalize(v):
    inv = pow(next(x for x in v if x % P) % P, -1, P)
    return tuple(x*inv % P for x in v)


def realization(name):
    lines = ([(0,0,1),(1,-1,0),(0,1,0),(1,0,0),(1,1,1)] if name == 'A'
             else [(1,0,0),(1,1,1),(0,0,1),(0,1,0),(1,-1,0)])
    fixed = ({0:(0,0,1),1:(0,1,0),4:(1,0,-1),5:(1,0,0),8:(1,-1,0)} if name=='A'
             else {1:(0,0,1),8:(0,1,0),7:(1,-1,0),0:(1,0,0),2:(1,1,-2)})
    points = {i:normalize(v) for i,v in fixed.items()}
    choices = [(2,1),(6,1),(3,3),(7,4)] if name=='A' else [(6,0),(3,1),(5,3),(4,4)]
    expected = {tuple(sorted(x)) for x in FAMILIES[name]}
    projective = [(0,0,1)]+[(0,1,x) for x in range(P)]+[(1,x,y) for x in range(P) for y in range(P)]
    for index, line in choices:
        for v in projective:
            on = [j for j,l in enumerate(lines) if sum(x*y for x,y in zip(v,l)) % P == 0]
            if on != [line] or v in points.values():
                continue
            candidate = {**points,index:v}
            if all((rank([candidate[i] for i in tri],P)==2) == (tri in expected)
                   for tri in it.combinations(sorted(candidate),3)):
                points[index]=v
                break
        else:
            raise AssertionError('finite projective-point search exhausted')
    rng = random.Random(1938 if name=='A' else 2005)
    for trial in range(10000):
        helpers = [(rng.randrange(P),)+points[i] for i in range(9)]
        if all(rank([helpers[i] for i in s],P)==len(s)
               for k in (3,4) for s in it.combinations(range(9),k)):
            break
    else:
        raise AssertionError('10000 lift trials exhausted')
    columns=[(1,0,0,0)]+helpers
    circuits=[]
    # Independently expand every square minor for triples and quadruples.
    checked=0
    for k in (3,4):
        for s in it.combinations(range(10),k):
            nonzero=any(determinant([[columns[j][i] for j in s] for i in rows],P)
                        for rows in it.combinations(range(4),k))
            assert nonzero == (rank([columns[j] for j in s],P)==k)
            if not nonzero:
                assert k==4 and s[0]==0
                circuits.append(tuple(j-1 for j in s[1:]))
            checked+=1
    assert set(circuits)==expected
    # Directly enumerate all availability sets by their size.
    counts=[0]*10
    for bits in it.product((0,1),repeat=9):
        if any(all(bits[i] for i in edge) for edge in expected):
            counts[sum(bits)]+=1
    return {'generator_rows':[list(r) for r in zip(*columns)],
            'target_column':0,'helper_order':list(range(9)),
            'target_circuits':sorted(map(list,circuits)),
            'independent_minor_crosschecks':checked,
            'successful_availability_sets_by_size':counts,'lift_trial':trial}


def hierarchy():
    columns=[1]*4+[2]*4+[3]*4
    prices=[0,1,4,4,1,4,4,4,1,4,4,4]
    result={}
    for failed in (False,True):
        best=10**9; supports=[]
        for bits in it.product((0,1),repeat=11):
            chosen=[i+1 for i,b in enumerate(bits) if b]
            if failed and 1 in chosen:
                continue
            syndrome=columns[0]
            for i in chosen: syndrome ^= columns[i]
            if syndrome: continue
            cost=sum(prices[i] for i in chosen)
            if cost<best: best,supports=cost,[]
            if cost==best: supports.append(chosen)
        local=4 if failed else 1
        assert best==min(local,1+1)
        result['failed' if failed else 'initial']={'cost':best,'helper_indices':supports}
    return result


def generate():
    data={name:realization(name) for name in ('A','B')}
    # Convert independently enumerated success counts to ordinary coefficients.
    from math import comb
    expected={'A':[0,0,0,5,0,-7,-1,5,0,-1],
              'B':[0,0,0,5,0,-7,-2,8,-3,0]}
    for name in ('A','B'):
        poly=[0]*10
        for k,count in enumerate(data[name]['successful_availability_sets_by_size']):
            for j in range(10-k): poly[k+j]+=count*comb(9-k,j)*(-1)**j
        assert poly==expected[name]
        data[name]['reliability_coefficients']=poly
    coefficients=[0]*10
    for k,(a,b) in enumerate(zip(data['A']['successful_availability_sets_by_size'],
                               data['B']['successful_availability_sets_by_size'])):
        for j in range(10-k): coefficients[k+j]+=(a-b)*comb(9-k,j)*(-1)**j
    assert coefficients==[0,0,0,0,0,0,1,-3,3,-1]
    return {'prime':P,'seeds':{'A':1938,'B':2005},'realizations':data,
            'radius_three_reliability_difference':coefficients,'hierarchy':hierarchy()}


def serialized(data):
    return (json.dumps(data,indent=2,sort_keys=True)+'\n').encode()


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--write',action='store_true')
    parser.add_argument('--check',action='store_true')
    args=parser.parse_args()
    if args.write and args.check: parser.error('choose --write or --check')
    output=ROOT/'explicit-examples.json'
    data=generate()
    source=(ROOT.parent/'sections/05-pointed-tutte.tex').read_text()
    for name in ('A','B'):
        pattern=r'G_\{\\mathcal '+name+r'\}=\\begin\{pmatrix\}(.*?)\\end\{pmatrix\}'
        match=re.search(pattern,source,re.S)
        assert match is not None,'missing displayed matrix'
        rows=[[int(x.strip()) for x in row.split('&')] for row in match[1].strip().split('\\\\')]
        assert rows==data['realizations'][name]['generator_rows'],'displayed matrix drift'
    expected=serialized(data)
    if args.write: output.write_bytes(expected)
    else: assert output.read_bytes()==expected,'example certificate drift'
    names=['replay_examples.py','explicit-examples.json','explicit-examples.md']
    manifest={name:{'sha256':hashlib.sha256((ROOT/name).read_bytes()).hexdigest(),
                    'bytes':(ROOT/name).stat().st_size} for name in names}
    checksums=ROOT/'explicit-examples.checksums.json'
    if args.write: checksums.write_bytes(serialized(manifest))
    else: assert checksums.read_bytes()==serialized(manifest),'checksum manifest drift'
    print('PASS explicit examples: two GF(101) realizations, 660 minor crosschecks, 1024 availability sets, two hierarchy scenarios')


if __name__=='__main__':
    main()
