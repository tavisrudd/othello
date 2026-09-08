"""C1128 exact lattice audit, independently implemented with the stdlib.

Default replay needs no SymPy. --replay-supplied additionally executes the
unchanged supplied SymPy torus checker and compares its complete result.
"""
import argparse
import ast
from fractions import Fraction as F
import importlib.util
import itertools
import json
from math import gcd
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT/'papers/cubic-stabilization-irrationality/verification/derive_slice_cover.py'
INPUTS = ROOT/'notes/cubic-threefolds-tasks/c1128-astra-feedback-inputs'


def transpose(a):
    return tuple(zip(*a))


def eye(n):
    return tuple(tuple(int(i==j) for j in range(n)) for i in range(n))


def mul(a,b):
    return tuple(tuple(sum(x*y for x,y in zip(row,col)) for col in transpose(b)) for row in a)


def vec(a,v):
    return tuple(sum(x*y for x,y in zip(row,v)) for row in a)


def inverse(a):
    n = len(a)
    rows = [[F(x) for x in row+unit] for row,unit in zip(a,eye(n))]
    for j in range(n):
        p = next(i for i in range(j,n) if rows[i][j])
        rows[j],rows[p] = rows[p],rows[j]
        d = rows[j][j]
        rows[j] = [x/d for x in rows[j]]
        for i in range(n):
            if i != j:
                d = rows[i][j]
                rows[i] = [x-d*y for x,y in zip(rows[i],rows[j])]
    result = tuple(tuple(row[n:]) for row in rows)
    assert all(x.denominator==1 for row in result for x in row)
    return tuple(tuple(int(x) for x in row) for row in result)


def determinant(a):
    n = len(a)
    return sum((-1)**sum(p[i]>p[j] for i in range(n) for j in range(i+1,n))
               *product(a[i][p[i]] for i in range(n)) for p in itertools.permutations(range(n)))


def product(values):
    value = 1
    for x in values: value *= x
    return value


def closure(generators):
    identity = eye(len(generators[0])); found={identity}; todo=[identity]
    while todo:
        a=todo.pop()
        for b in generators:
            c=mul(a,b)
            if c not in found:
                found.add(c); todo.append(c)
                assert len(found)<=100, 'unexpected group order'
    return found


def main():
    parser=argparse.ArgumentParser(); parser.add_argument('--replay-supplied',action='store_true')
    args=parser.parse_args()
    tree=ast.parse(SOURCE.read_text())
    assignment=next(node for node in tree.body if isinstance(node,ast.Assign)
                    and any(isinstance(t,ast.Name) and t.id=='CHARACTER_GENERATORS' for t in node.targets))
    generators=tuple(tuple(tuple(row) for row in ast.literal_eval(call.args[0]))
                     for call in assignment.value.elts)
    weights=((0,1,1),(1,0,1),(1,1,0),(1,1,1))
    differences=transpose(tuple(tuple(x-y for x,y in zip(w,weights[0])) for w in weights[1:]))
    assert determinant(differences)==1
    residual_vectors=((0,1),(1,-1),(-1,0))
    assert tuple(map(sum,zip(*residual_vectors)))==(0,0)
    assert abs(determinant(transpose(residual_vectors[:2])))==1
    selected_perms=[]; residuals=[]; residual_perms=[]
    group=closure(generators); image_selected=set(); image_residual=set(); combined=set()
    blocks=(frozenset((0,1)),frozenset((2,3)))
    for g in sorted(group):
        cochar=transpose(inverse(g))
        assert all(cochar[i][j]==0 for i in range(2) for j in range(2,5))
        sub=tuple(tuple(cochar[i][j] for j in range(2,5)) for i in range(2,5))
        char=transpose(inverse(sub))
        candidates=[p for p in itertools.permutations(range(4))
                    if all(vec(char,tuple(x-y for x,y in zip(weights[j],weights[0])))
                           ==tuple(x-y for x,y in zip(weights[p[j]],weights[p[0]])) for j in range(4))]
        assert len(candidates)==1
        p=candidates[0]
        # Augmentation basis e1-e0,e2-e0,e3-e0; integer intertwiner.
        action=transpose(tuple(tuple(int(p[j]==i)-int(p[0]==i) for i in range(1,4)) for j in range(1,4)))
        assert mul(differences,action)==mul(char,differences)
        residual=tuple(tuple(g[i][j] for j in range(2)) for i in range(2))
        rp=tuple(residual_vectors.index(vec(residual,v)) for v in residual_vectors)
        block_perm=tuple(blocks.index(frozenset(p[i] for i in block)) for block in blocks)
        block_sign=1 if block_perm==(0,1) else -1
        assert determinant(residual)==block_sign
        image_selected.add(p); image_residual.add(rp); combined.add((p,rp))
    for g in generators:
        cochar=transpose(inverse(g))
        sub=tuple(tuple(cochar[i][j] for j in range(2,5)) for i in range(2,5))
        char=transpose(inverse(sub))
        p=next(p for p in image_selected if all(
            vec(char,tuple(x-y for x,y in zip(weights[j],weights[0])))
            ==tuple(x-y for x,y in zip(weights[p[j]],weights[p[0]])) for j in range(4)))
        selected_perms.append(list(p))
        residual=tuple(tuple(g[i][j] for j in range(2)) for i in range(2))
        residuals.append([list(row) for row in residual])
        residual_perms.append([residual_vectors.index(vec(residual,v)) for v in residual_vectors])
    assert (len(group),len(image_selected),len(image_residual),len(combined))==(24,8,6,24)
    # The quartic's cubic-resolvent action has order 2, not 6.
    matchings=(frozenset((frozenset((0,1)),frozenset((2,3)))),
               frozenset((frozenset((0,2)),frozenset((1,3)))),
               frozenset((frozenset((0,3)),frozenset((1,2)))))
    resolvent={tuple(matchings.index(frozenset(frozenset(p[i] for i in pair) for pair in m))
                     for m in matchings) for p in image_selected}
    assert len(resolvent)==2
    # Cofactors from an actual evaluation matrix, with all entries nonzero.
    A=((1,2,3,5),(2,-1,4,1),(3,1,-2,4))
    kappa=tuple((-1)**j*determinant(tuple(tuple(row[i] for i in range(4) if i!=j) for row in A)) for j in range(4))
    assert all(kappa) and vec(A,kappa)==(0,0,0)
    t=tuple(F(kappa[3],kappa[i]) for i in range(3))
    scalars=tuple(product(ti**wi for ti,wi in zip(t,w)) for w in weights)
    assert vec(A,scalars)==(0,0,0)
    assert (t[0]/t[1],t[0]/t[2],t[0])==tuple(F(kappa[i],kappa[0]) for i in range(1,4))
    checked=0
    for a,b in itertools.product(range(-8,9),repeat=2):
        if gcd(a,b)!=1: continue
        c,d=next((c,d) for c,d in itertools.product(range(-16,17),repeat=2) if a*c+b*d==1)
        assert determinant(((b,c),(-a,d)))==1
        assert a*b+b*(-a)==0
        checked+=1
    expected=json.loads((INPUTS/'stabilization_extension_checks.json').read_text())['torus']
    # The supplied JSON serialized SymPy integers as strings in matrix entries.
    expected['difference_matrix']=[[int(x) for x in row] for row in expected['difference_matrix']]
    expected['residual_character_actions']=[[[int(x) for x in row] for row in matrix]
                                            for matrix in expected['residual_character_actions']]
    recovered=dict(difference_matrix=[list(row) for row in differences],determinant=1,
                   affine_weight_permutations=selected_perms,residual_character_actions=residuals,
                   orbit_correction=['k3/k0','k3/k1','k3/k2'])
    assert recovered==expected
    if args.replay_supplied:
        sys.dont_write_bytecode=True
        spec=importlib.util.spec_from_file_location('supplied',INPUTS/'stabilization_extension_checks.py')
        module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
        assert module.torus_checks()==recovered
    output=dict(status='pass',engine='Python stdlib exact integer and Fraction arithmetic',
                scope='Finite lattice and cofactor identities; geometric descent and linearization require the proof note',
                supplied_torus=recovered,group_order=len(group),selected_image_order=len(image_selected),
                residual_image_order=len(image_residual),combined_image_order=len(combined),
                residual_vector_permutations=residual_perms,
                residual_vectors=residual_vectors,quartic_resolvent_image_order=len(resolvent),
                common_quadratic='quartic block system {0,1}|{2,3} equals sign of residual S3 action',
                cofactor_example=dict(matrix=A,kappa=kappa,correction=list(map(str,t))),
                primitive_pairs_checked=checked)
    print(json.dumps(output,indent=2))


if __name__=='__main__': main()
