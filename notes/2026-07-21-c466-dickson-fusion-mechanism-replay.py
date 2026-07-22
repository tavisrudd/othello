#!/usr/bin/env python3
"""Independent PGL2 replay of the C466 certificate.

Unlike the generator, this checker does not construct ternary conics, H3
reflections, or the C395 projective representation.  It starts from the
certificate's canonical Möbius groups and independently exhausts PGL2(q).
"""

from __future__ import annotations

import cmath
import itertools
import json
from collections import Counter, deque
from pathlib import Path

CERT = Path(__file__).with_name("2026-07-21-c466-dickson-fusion-mechanism.json")


def inv(a, q):
    return pow(a % q, q - 2, q)


def legendre(a, q):
    z = pow(a % q, (q - 1)//2, q)
    return 0 if z == 0 else (1 if z == 1 else -1)


def norm(g, q):
    s = inv(next(x for x in g if x % q), q)
    return tuple(s*x % q for x in g)


def mul(g, h, q):
    a,b,c,d = g
    e,f,k,l = h
    return norm(((a*e+b*k)%q, (a*f+b*l)%q, (c*e+d*k)%q, (c*f+d*l)%q), q)


def inverse(g, q):
    a,b,c,d = g
    return norm((d,-b,-c,a), q)


def closure(gens, q):
    out = {(1,0,0,1)}
    todo = deque(out)
    while todo:
        a = todo.popleft()
        for b in gens:
            c = mul(a,b,q)
            if c not in out:
                out.add(c)
                todo.append(c)
    return out


def small_generators(group, q):
    for a in sorted(group):
        for b in sorted(group):
            if closure((a,b),q) == group:
                return a,b
    raise AssertionError


def pgl2(q):
    seen = set()
    for raw in itertools.product(range(q), repeat=4):
        a,b,c,d = raw
        if (a*d-b*c) % q:
            seen.add(norm(raw,q))
    assert len(seen) == q*(q*q-1)
    return seen


def conjugators(source, target, candidates, q):
    gens = small_generators(source,q)
    answer = []
    for g in candidates:
        gi = inverse(g,q)
        if all(mul(mul(g,h,q),gi,q) in target for h in gens):
            answer.append(g)
    return answer


def det(g,q):
    return (g[0]*g[3]-g[1]*g[2]) % q


def norm3(v,q):
    s = inv(next(x for x in v if x%q),q)
    return tuple(s*x%q for x in v)


def mv3(h,v,q):
    return tuple(sum(h[i][j]*v[j] for j in range(3))%q for i in range(3))


def cross3(a,b,modulus):
    return (
        (a[1]*b[2]-a[2]*b[1])%modulus,
        (a[2]*b[0]-a[0]*b[2])%modulus,
        (a[0]*b[1]-a[1]*b[0])%modulus,
    )


def cross_rows(source,target,p):
    x,y,z = target
    r0 = (source[0],source[1],source[2],0,0,0,0,0,0)
    r1 = (0,0,0,source[0],source[1],source[2],0,0,0)
    r2 = (0,0,0,0,0,0,source[0],source[1],source[2])
    return (
        tuple((y*r2[k]-z*r1[k])%p for k in range(9)),
        tuple((z*r0[k]-x*r2[k])%p for k in range(9)),
        tuple((x*r1[k]-y*r0[k])%p for k in range(9)),
    )


def affine_profile(rows,rhs,width,p):
    a = [list(row)+[b%p] for row,b in zip(rows,rhs)]
    rank = 0
    for col in range(width):
        pivot = next((i for i in range(rank,len(a)) if a[i][col]%p),None)
        if pivot is None:
            continue
        a[rank],a[pivot] = a[pivot],a[rank]
        scale = inv(a[rank][col],p)
        a[rank] = [scale*x%p for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][col]%p:
                scale = a[i][col]
                a[i] = [(a[i][j]-scale*a[rank][j])%p for j in range(width+1)]
        rank += 1
    inconsistent = any(not any(row[:width]) and row[width] for row in a)
    return rank,rank+int(inconsistent),not inconsistent


def hensel_phi(tau,p):
    value = tau*tau-tau-1
    correction = -(value//p)*inv(2*tau-1,p)%p
    root = tau+p*correction
    assert (root*root-root-1)%(p*p)==0
    return root


def raw_golden(tau,modulus):
    return {
        tuple(x%modulus for x in v)
        for v in (
            (0,1,1-tau),(0,1,tau-1),
            (1,1-tau,0),(1,tau-1,0),
            (1,0,-tau),(1,0,tau),
        )
    }


def lift_profile_replay(comparison,p):
    tau = comparison["golden_tau"]
    modulus = p*p
    lifted_tau = hensel_phi(tau,p)
    lifted = raw_golden(lifted_tau,modulus)
    by_reduction = {tuple(x%p for x in point):point for point in lifted}
    source = tuple(tuple(point) for point in comparison["c395_six_arc"])
    profiles = Counter()
    liftable = 0
    matrices = [tuple(tuple(row) for row in matrix) for matrix in comparison["all_six_arc_projectivities"]]
    assert len(set(matrices)) == comparison["direct_six_arc_projectivity_count"] == 60
    for h in matrices:
        targets0 = tuple(norm3(mv3(h,point,p),p) for point in source)
        rows,rhs = [],[]
        for point,target0 in zip(source,targets0):
            target = by_reduction[target0]
            residual = cross3(target,mv3(h,point,modulus),modulus)
            assert all(x%p==0 for x in residual)
            rows.extend(cross_rows(point,target0,p))
            rhs.extend((-x//p)%p for x in residual)
        rank,aug,consistent = affine_profile(rows,rhs,9,p)
        profiles[(rank,aug)] += 1
        liftable += int(consistent)
    expected = comparison["first_order_lift"]
    assert liftable == expected["liftable_projectivities"] == 0
    assert [[list(key),count] for key,count in sorted(profiles.items())] == expected["rank_augmented_rank_profile"]


def gauss_replay(item):
    q = item["q"]
    coeff = [0]*q
    for t in range(q):
        coeff[t*t % q] += 1
    assert coeff == item["quadratic_residue_exponent_counts"]
    product = [0]*q
    for i,a in enumerate(coeff):
        for j,b in enumerate(coeff):
            product[(i+j)%q] += a*b
    product[0] -= q
    reduced = [x-product[-1] for x in product[:-1]]
    assert reduced == item["cyclotomic_reduction_of_G2_minus_q"] == [0]*(q-1)
    value = sum(cmath.exp(2j*cmath.pi*(t*t%q)/q) for t in range(q))
    assert value.real > 0 and abs(value/(q**0.5)-1) < 1e-12


def main():
    cert = json.loads(CERT.read_text())
    for key,item in cert["tested_primes"].items():
        q = int(key)
        universe = pgl2(q)
        roots = item["golden_roots"]
        groups = {int(t): {tuple(g) for g in gs} for t,gs in item["golden_mobius_groups"].items()}
        hinge = {tuple(g) for g in item["hinge_mobius_group"]}
        assert all(len(groups[t]) == 60 for t in roots)
        assert closure(small_generators(hinge,q),q) == hinge
        swaps = conjugators(groups[roots[0]], groups[roots[1]], universe, q)
        hinge_swaps = conjugators(groups[roots[0]], groups[roots[1]], hinge, q)
        psl_swaps = [g for g in swaps if legendre(det(g,q),q) == 1]
        hinge_psl = [g for g in hinge if legendre(det(g,q),q) == 1]
        assert len(swaps) == item["pgl2_sheet_transporter_count"] == 60
        assert len(psl_swaps) == item["psl2_sheet_transporter_count"]
        assert len(hinge_swaps) == item["hinge_sheet_swap_count"] == 12
        assert len(hinge_psl) == item["hinge_psl_intersection_order"]
        assert bool(psl_swaps) == (legendre(2,q) == 1)
        assert legendre(5,q) == 1
    q = 31
    universe = pgl2(q)
    control = cert["characteristic_31_a5_control"]
    c395 = {tuple(g) for g in control["induced_pgl2_group"]}
    golden = cert["tested_primes"]["31"]["golden_mobius_groups"]
    for comparison in control["comparisons"]:
        source = {tuple(g) for g in golden[str(comparison["golden_tau"])]}
        cs = conjugators(source,c395,universe,q)
        assert len(cs) == comparison["pgl2_conjugator_count"] == 60
        assert sum(legendre(det(g,q),q)==1 for g in cs) == comparison["psl2_conjugator_count"] == 0
        h = tuple(tuple(row) for row in comparison["canonical_six_arc_projectivity"])
        source = {tuple(p) for p in comparison["c395_six_arc"]}
        target = {tuple(p) for p in comparison["golden_six_arc"]}
        assert {norm3(mv3(h,p,q),q) for p in source} == target
        induced = tuple(comparison["induced_conic_mobius"])
        assert legendre(det(induced,q),q) == comparison["induced_conic_determinant_legendre"] == -1
        lift_profile_replay(comparison,q)
    bridge = tuple(tuple(row) for row in control["two_identifications_close_through_hinge"]["sheet_change_matrix"])
    assert bridge == ((1,0,0),(0,0,1),(0,1,0))
    targets = {item["golden_tau"]: {tuple(p) for p in item["golden_six_arc"]} for item in control["comparisons"]}
    assert {norm3(mv3(bridge,p,q),q) for p in targets[13]} == targets[19]
    template = control["integral_golden_template"]
    hphi = tuple(tuple(row) for row in template["reduction_phi_to_13"])
    source = {tuple(p) for p in control["comparisons"][0]["c395_six_arc"]}
    assert {norm3(mv3(hphi,p,q),q) for p in source} == targets[13]
    assert template["norm"] == (-8)**2 + (-8)*3 - 3**2 == 31
    bitorsor = control["two_sheet_bitorsor"]
    assert bitorsor["projectivities_per_sheet"] == 60
    assert bitorsor["total_projectivities_to_the_two_sheet_family"] == 120
    assert 8*inv(3,q)%q == 13 and (13*13-13-1)%q == 0
    for item in cert["arf_face"]:
        q = item["q"]
        assert item["genus"] == (q-1)//2
        assert item["origin_h0"] == (q+1)//4
        assert (-1 if item["arf"] else 1) == legendre(2,q)
    for item in cert["weil_gauss_faces"].values():
        gauss_replay(item)
    table = cert["three_character_frobenius_table"]
    assert table["degree"] == 8 and len(table["rows"]) == 16
    fibres = Counter((row["chi_5"],row["chi_2"],row["chi_minus_1"]) for row in table["rows"])
    assert len(fibres) == 8 and set(fibres.values()) == {2}
    print("C466 independent PGL2/Gauss replay: OK")


if __name__ == "__main__":
    main()
