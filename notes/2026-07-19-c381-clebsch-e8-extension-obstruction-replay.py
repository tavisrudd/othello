#!/usr/bin/env python3
"""Independent formula-level replay of C381; imports neither the C381 primary nor C341."""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from fractions import Fraction
from pathlib import Path

Q = 11
HERE = Path(__file__).resolve().parent
REPLAY379 = HERE / "2026-07-19-c379-clebsch-deep-hole-extension-replay.py"
CERT = HERE / "2026-07-19-c381-clebsch-e8-extension-obstruction.json"
REPLAY379_SHA256 = "515d45ee2a30a9381c446c035ff7cea7ae4c919faa1a3d3db205ee40a6e522f8"


def load_geometry():
    assert hashlib.sha256(REPLAY379.read_bytes()).hexdigest() == REPLAY379_SHA256
    spec = importlib.util.spec_from_file_location("c379_replay", REPLAY379)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def rank_q(rows):
    return len(load_geometry().rref(rows)[0])


def rank_rational(rows):
    work = [[Fraction(value) for value in row] for row in rows]
    rank = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next((i for i in range(rank, len(work)) if work[i][column]), None)
        if pivot is None: continue
        work[rank], work[pivot] = work[pivot], work[rank]
        scale = work[rank][column]
        work[rank] = [value / scale for value in work[rank]]
        for i in range(len(work)):
            if i != rank and work[i][column]:
                scale = work[i][column]
                work[i] = [a - scale*b for a, b in zip(work[i], work[rank])]
        rank += 1
    return rank


def determinant_integer(matrix):
    work = [list(row) for row in matrix]
    if not work: return 1
    sign, previous = 1, 1
    for column in range(len(work)-1):
        pivot = next(i for i in range(column,len(work)) if work[i][column])
        if pivot != column:
            work[column],work[pivot]=work[pivot],work[column]; sign*=-1
        value=work[column][column]
        for i in range(column+1,len(work)):
            for j in range(column+1,len(work)):
                work[i][j]=(work[i][j]*value-work[i][column]*work[column][j])//previous
        previous=value
    return sign*work[-1][-1]


def intersection(left, right):
    return left[0]*right[0] - sum(a*b for a, b in zip(left[1:], right[1:]))


def e8_roots():
    result = set()
    for i, j in itertools.permutations(range(8), 2):
        v = [0]*9; v[i+1] = 1; v[j+1] = -1; result.add(tuple(v))
    for subset in itertools.combinations(range(8), 3):
        v = [1]+[0]*8
        for i in subset: v[i+1] = 1
        result |= {tuple(v), tuple(-x for x in v)}
    for subset in itertools.combinations(range(8), 6):
        v = [2]+[0]*8
        for i in subset: v[i+1] = 1
        result |= {tuple(v), tuple(-x for x in v)}
    for i in range(8):
        v = [3]+[1]*8; v[i+1] = 2
        result |= {tuple(v), tuple(-x for x in v)}
    assert len(result) == 240
    return frozenset(result)


ROOTS = e8_roots()


def cubic_rows(point):
    x, y, z = point
    values = (x**3,x*x*y,x*x*z,x*y*y,x*y*z,x*z*z,y**3,y*y*z,y*z*z,z**3)
    derivatives = (
        (3*x*x,2*x*y,2*x*z,y*y,y*z,z*z,0,0,0,0),
        (0,x*x,0,2*x*y,x*z,0,3*y*y,2*y*z,z*z,0),
        (0,0,x*x,0,x*y,2*x*z,0,y*y,2*y*z,3*z*z),
    )
    return tuple(v % Q for v in values), [tuple(v % Q for v in row) for row in derivatives]


def effective_roots(g, points):
    lines, conics, cubics = [], [], []
    for subset in itertools.combinations(range(8), 3):
        if g.determinant([points[i] for i in subset]) == 0:
            v=[1]+[0]*8
            for i in subset: v[i+1]=1
            lines.append(tuple(v))
    for subset in itertools.combinations(range(8), 6):
        if len(g.rref([g.conic_row(points[i]) for i in subset])[0]) < 6:
            v=[2]+[0]*8
            for i in subset: v[i+1]=1
            conics.append(tuple(v))
    values = [cubic_rows(point)[0] for point in points]
    for i, point in enumerate(points):
        if len(g.rref(values + cubic_rows(point)[1])[0]) < 10:
            v=[3]+[1]*8; v[i+1]=2; cubics.append(tuple(v))
    return lines, conics, cubics


def additive_root_closure(generators):
    """Close under root sums/differences, independently of the primary's reflections."""
    result = set(generators) | {tuple(-x for x in root) for root in generators}
    changed = True
    while changed:
        changed = False
        for left in tuple(result):
            for right in tuple(result):
                candidate = tuple(a + b for a, b in zip(left, right))
                if candidate in ROOTS and candidate not in result:
                    result.add(candidate); changed = True
    return frozenset(result)


def root_discriminant(roots):
    weights = next(
        tuple(base**i for i in range(9)) for base in range(2,20)
        if all(sum(a*base**i for i,a in enumerate(root)) != 0 for root in roots)
    )
    positive={root for root in roots if sum(a*b for a,b in zip(root,weights))>0}
    simple=[root for root in positive if not any(
        tuple(a+b for a,b in zip(left,right))==root for left in positive for right in positive
    )]
    assert len(simple)==rank_rational(list(roots))
    gram=[[intersection(left,right) for right in simple] for left in simple]
    return abs(determinant_integer(gram))


def matrix_order(g, matrix):
    power=g.I
    for order in range(1,61):
        power=g.normm(g.mm(power,matrix))
        if power==g.I: return order
    raise AssertionError("matrix order exceeds A5")


def act_pair(g, matrix, pair):
    return frozenset(g.normalize(g.mv(matrix,point)) for point in pair)


def main():
    g = load_geometry()
    plane = g.projective_points()
    conic = frozenset(point for point in plane if g.dot(point, point) == 0)
    plus = frozenset(g.six_points(8))
    a5 = g.a5(8)
    pgl = g.closure(list(a5) + [g.J])
    parents = frozenset(g.image(matrix, plus) for matrix in pgl)
    assert (len(conic), len(a5), len(pgl), len(parents)) == (12, 60, 1320, 22)
    matchings = {parent:g.obstruction_matching(parent, conic) for parent in parents}
    assert len(set(matchings.values())) == 22

    unseen_pairs={frozenset(pair) for pair in itertools.combinations(conic,2)}
    pair_characters=[]
    while unseen_pairs:
        representative=min(unseen_pairs,key=lambda pair:tuple(sorted(pair)))
        orbit=frozenset(act_pair(g,matrix,representative) for matrix in a5)
        unseen_pairs-=orbit
        by_order={}
        for matrix in a5:
            order=matrix_order(g,matrix)
            fixed=sum(act_pair(g,matrix,pair)==pair for pair in orbit)
            by_order.setdefault(order,set()).add(fixed)
        assert all(len(values)==1 for values in by_order.values())
        pair_characters.append((len(orbit),tuple(next(iter(by_order[order])) for order in (1,2,3,5))))
    assert sorted(pair_characters)==[(6,(6,2,0,1)),(30,(30,2,0,0)),(30,(30,2,0,0))]

    spectrum = Counter()
    representatives = {}
    for parent in parents:
        ppoints = sorted(parent)
        for raw_pair in itertools.combinations(conic, 2):
            pair = frozenset(raw_pair)
            points = ppoints + sorted(pair)
            lines, conics, cubics = effective_roots(g, points)
            inherited=[]
            for child in (6,7):
                candidates=[root for root in conics if root[1+child] and sum(root[1:7])==5]
                assert len(candidates)==1; inherited.append(candidates[0])
            matched = pair in matchings[parent]
            assert (intersection(*inherited)==-1) == matched
            assert (intersection(*inherited)==0) == (not matched)
            seven_conics=sum(
                len(g.rref([g.conic_row(points[i]) for i in subset])[0]) < 6
                for subset in itertools.combinations(range(8),7)
            )
            four_lines=any(
                len(g.rref([points[i] for i in subset])[0]) < 3
                for subset in itertools.combinations(range(8),4)
            )
            signature=(matched,len(lines),len(conics),len(cubics),seven_conics,four_lines)
            spectrum[signature]+=1
            representatives.setdefault(signature, lines+conics+cubics)

    assert spectrum == Counter({
        (True,0,7,7,1,False):132,
        (False,0,3,0,0,False):660,
        (False,1,3,0,0,False):660,
    })
    closed = {signature:additive_root_closure(generators) for signature,generators in representatives.items()}
    closure = {signature:len(roots) for signature,roots in closed.items()}
    expected_closure = {
        (True,0,7,7,1,False):112,
        (False,0,3,0,0,False):6,
        (False,1,3,0,0,False):8,
    }
    assert closure == expected_closure, closure
    discriminants={signature:root_discriminant(roots) for signature,roots in closed.items()}
    assert discriminants == {
        (True,0,7,7,1,False):4,
        (False,0,3,0,0,False):8,
        (False,1,3,0,0,False):16,
    }

    cert=json.loads(CERT.read_text())
    assert cert["domain"]["marked_configuration_count"]==1452
    assert cert["full_group_orbit_count"]==3
    got=Counter()
    for item in cert["classification_spectrum"]:
        p=item["properties"]
        signature=(p["matched_pair"],p["direct_effective_root_counts"]["line"],
                   p["direct_effective_root_counts"]["conic"],p["direct_effective_root_counts"]["singular_cubic"],
                   p["seven_point_conic_count"],p["has_four_collinear"])
        got[signature]=item["count"]
        assert p["generated_root_count"]==closure[signature]
        assert p["generated_root_discriminant"]==discriminants[signature]
        if signature[0]:
            assert (p["generated_root_rank"],p["ambient_e8_index"],p["ambient_e8_quotient"])==(8,2,"C2")
    assert got==spectrum
    assert cert["free_corollaries"]["root_only_parent_inversion"]
    assert cert["free_corollaries"]["matched_d8_glue"]["index_in_unimodular_e8"]==2
    assert cert["free_corollaries"]["fixed_parent_pair_permutation_characters"] == {
        "class_ordering":[1,2,3,5],
        "A5_over_D10":[6,2,0,1],
        "A5_over_C2":[30,2,0,0],
        "two_size_30_orbits_have_same_character":True,
        "character_alone_recovers_mds_status":False,
    }
    print("replayed 1452 configurations: 132 D8 worse-than-weak; 660 weak 3A1 arcs; 660 weak 4A1 non-arcs")


if __name__ == "__main__":
    main()
