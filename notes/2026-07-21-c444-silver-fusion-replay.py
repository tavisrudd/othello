#!/usr/bin/env python3
"""Independent replay for C444.

This does not import the primary C444 generator.  It uses the frozen C406 checker as an
independent implementation of the matching orbit and moment calculation, and separately rebuilds
the B3/A3 binary-octahedral reductions.
"""
from __future__ import annotations

from itertools import product
from pathlib import Path
import hashlib
import importlib.util
import json


HERE = Path(__file__).resolve().parent
CERT = json.loads((HERE / "2026-07-21-c444-silver-fusion.json").read_text())


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C406 = load_module("c444_replay_c406", HERE / "2026-07-20-c406-matching-module.py")
SCOUT = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())


def canon_edge(a, b):
    return tuple(sorted((a, b), key=lambda x: (x == "inf", x if x != "inf" else 0)))


def canon_matching(edges):
    return tuple(sorted((canon_edge(a, b) for a, b in edges), key=str))


def mmul(a, b, p):
    return tuple(sum(a[2*r+k] * b[2*k+c] for k in range(2)) % p for r in range(2) for c in range(2))


def madd(*matrices, p):
    return tuple(sum(matrix[i] for matrix in matrices) % p for i in range(4))


def scale(s, matrix, p):
    return tuple(s*x % p for x in matrix)


def inv(matrix, p):
    a,b,c,d = matrix
    z = pow((a*d-b*c) % p, -1, p)
    return (d*z%p, -b*z%p, -c*z%p, a*z%p)


def pnorm(matrix, p):
    z = pow(next(x for x in matrix if x), -1, p)
    return tuple(x*z % p for x in matrix)


def closure(generators, p, projective=False):
    norm = (lambda x: pnorm(x,p)) if projective else (lambda x:x)
    group = {norm((1,0,0,1))}
    todo = list(group)
    generators = [norm(g) for g in generators]
    while todo:
        left = todo.pop()
        for right in generators:
            value = norm(mmul(left,right,p))
            if value not in group:
                group.add(value); todo.append(value)
    return group


def act(matrix, point, p):
    a,b,c,d = matrix
    x,y = (a,c) if point == "inf" else ((a*point+b)%p,(c*point+d)%p)
    return "inf" if y == 0 else x*pow(y,-1,p)%p


def image(matrix, matching, p):
    return canon_matching((act(matrix,a,p),act(matrix,b,p)) for a,b in matching)


def b3_spin(s):
    p=7; one=(1,0,0,1); i=(0,1,6,0); j=(2,s,s,5); k=mmul(i,j,p)
    q=scale(4,madd(one,i,j,k,p=p),p); r=scale(pow(s,-1,p),madd(one,i,p=p),p)
    spin=closure((i,j,q,r),p)
    c=(1,s,0,1); ci=inv(c,p)
    parent={pnorm(mmul(mmul(c,g,p),ci,p),p) for g in spin}
    return spin,parent


def listed_matching(key):
    return canon_matching(tuple(edge) for edge in CERT["B3"]["reductions"][key]["matching"])


for s,key in ((3,"sqrt2_3"),(4,"sqrt2_4")):
    spin,parent=b3_spin(s)
    matching=listed_matching(key)
    assert len(spin)==48 and len(parent)==24
    assert all(image(g,matching,7)==matching for g in parent)


# Rebuild C406's B3 certificate with the frozen checker, including the quotient moments.
b3_record = next(record for record in SCOUT["types"] if record["type"] == "B3")
b3_rebuilt = C406.type_certificate(b3_record)
assert b3_rebuilt["psl_orbit_sizes_on_parent_markers"] == [7,7]
rebuilt_moments = b3_rebuilt["outer_sheet_sign"]["signed_moments_on_image_coordinates"]
for got,want in zip(CERT["B3"]["c406_moment_comparison"]["moments"], rebuilt_moments):
    for field in ("degree","dimension","nonzero","support","sha256"):
        assert got[field] == want[field]

# Independently locate the two listed antipodal reductions in C406's two PSL fibres.
conic,parameters=C406.C399.conic_parameterization(7)
pgl,psl=C406.full_pgl(7,parameters)
base=tuple(tuple(edge) for edge in b3_record["coxeter_invariant_matching"])
orbit=sorted({C406.matching_image(g,base) for g in pgl})
def c406_form(matching):
    return tuple(sorted(tuple(sorted((7 if a=="inf" else a,7 if b=="inf" else b))) for a,b in matching))
unseen=set(orbit); sheets=[]
while unseen:
    rep=min(unseen); sheet={C406.matching_image(g,rep) for g in psl}; unseen-=sheet; sheets.append(sheet)
indices=[]
for key in ("sqrt2_3","sqrt2_4"):
    matching=c406_form(listed_matching(key))
    indices.append(next(i for i,sheet in enumerate(sheets) if matching in sheet))
assert indices[0] != indices[1]


# Independent F25 binary-octahedral closure: u^2=2 and Frobenius sends u to -u.
def fa(x,y): return ((x[0]+y[0])%5,(x[1]+y[1])%5)
def fn(x): return (-x[0]%5,-x[1]%5)
def fm(x,y): return ((x[0]*y[0]+2*x[1]*y[1])%5,(x[0]*y[1]+x[1]*y[0])%5)
def fi(x):
    n=(x[0]*x[0]-2*x[1]*x[1])%5; z=pow(n,-1,5); return (x[0]*z%5,-x[1]*z%5)
z=(0,0); o=(1,0)
def fmm(a,b): return tuple(fa(fm(a[2*r],b[c]),fm(a[2*r+1],b[2+c])) for r in range(2) for c in range(2))
def fadd(*ms): return tuple(__import__('functools').reduce(fa,(m[i] for m in ms),z) for i in range(4))
def fsc(s,m): return tuple(fm(s,x) for x in m)
def fpn(m): return fsc(fi(next(x for x in m if x!=z)),m)
def fclosure(gs,projective=False):
    norm=fpn if projective else (lambda x:x); group={norm((o,z,z,o))}; todo=list(group); gs=[norm(g) for g in gs]
    while todo:
        a=todo.pop()
        for b in gs:
            c=norm(fmm(a,b))
            if c not in group: group.add(c);todo.append(c)
    return group
one=(o,z,z,o); ii=((2,0),z,z,(3,0)); jj=(z,o,(4,0),z); kk=fmm(ii,jj)
qq=fsc((3,0),fadd(one,ii,jj,kk)); u=(0,1); rr=fsc(fi(u),fadd(one,ii))
assert fm(u,u)==(2,0)
assert tuple((x[0],-x[1]%5) for x in rr)==tuple(fn(x) for x in rr)
spin=fclosure((ii,jj,qq,rr)); proj=fclosure((ii,jj,qq,rr),True)
assert len(spin)==48 and len(proj)==24
assert all(x[1]==0 for matrix in proj for x in matrix)

a3_record=next(record for record in SCOUT["types"] if record["type"]=="A3")
a3_rebuilt=C406.type_certificate(a3_record)
assert a3_rebuilt["parent_is_subgroup_of_psl"] is False
assert a3_rebuilt["psl_orbit_sizes_on_parent_markers"] == [5]
assert CERT["A3"]["matching_at_i_2"] == CERT["A3"]["matching_at_i_3"]
assert CERT["A3"]["spin_model"]["sheet_sign_exists"] is False

print("C444 independent replay OK")
