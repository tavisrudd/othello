#!/usr/bin/env python3
"""C210 step 0: exact GF(8) census for the a!=0 D_AS residue system.

Rebuild the universal trace-one collision polynomial, form

    W = (B0')^2 Q^4 + B0 Q^2 (D')^2,
    D = delta (a^2+a+1) G1 G2a,

and reduce W modulo the monic cubic G2a.  Its three coefficients are the
unscaled residue conditions C0,C1,C2.  On GF(8), delta != 0 implies that the
common content (delta*(a^2+a+1))^6 is nonzero, so their zero set is exactly the
zero set of the stripped conditions c0,c1,c2.

The census exploits h0-linearity but handles the all-A case explicitly.  It
compares the solution set against the union of the three known branches and
splits counts by the merged-pole boundary K1*K2=0.
"""

from __future__ import annotations

import itertools
import json

from analyze_c210_a_zero_artin_schreier_divisor import (
    A,
    B,
    DELTA,
    E,
    GF8_INV,
    GF8_POW,
    H0,
    H1,
    P,
    U,
    W,
    gf8_mul,
    h0_split,
    u_derivative,
    u_reduce,
)
from analyze_c210_a_zero_factorization_strata import (
    TVARS,
    t_coefficient,
    trace_one_pullback,
)


RAW_COEFFICIENT_SIZES = (1389, 643, 677)
STRIPPED_COEFFICIENT_SIZES = (453, 221, 185)


def u_coefficients(poly: set[tuple[int, ...]]) -> tuple[set[tuple[int, ...]], ...]:
    """Return coefficients in ascending u-degree."""
    degree = max(m[U] for m in poly)
    out = []
    for exponent in range(degree + 1):
        coefficient = set()
        for monomial in poly:
            if monomial[U] == exponent:
                reduced = list(monomial)
                reduced[U] = 0
                coefficient.add(tuple(reduced))
        out.append(coefficient)
    return tuple(out)


def divide_monic(poly, divisor, index: int):
    """Exact sparse GF(2) division by a monic univariate divisor."""
    degree = max(m[index] for m in divisor)
    lead = tuple(degree if i == index else 0 for i in range(len(TVARS)))
    assert lead in divisor
    quotient = set()
    remainder = set(poly)
    while remainder and max(m[index] for m in remainder) >= degree:
        top = max(m[index] for m in remainder)
        coefficient = set()
        for monomial in remainder:
            if monomial[index] == top:
                reduced = list(monomial)
                reduced[index] -= degree
                coefficient.add(tuple(reduced))
        quotient ^= coefficient
        product = set()
        for left in coefficient:
            for right in divisor:
                monomial = tuple(x + y for x, y in zip(left, right))
                if monomial in product:
                    product.remove(monomial)
                else:
                    product.add(monomial)
        remainder ^= product
    assert not remainder
    return quotient


def residue_conditions():
    """Build the three raw G2a residue conditions by exact GF(2) arithmetic."""
    ring, cover = trace_one_pullback()
    v = ring.v
    b0 = t_coefficient(cover, 0)
    theta = ring.add(ring.power(v["w"], 2), v["w"], ring.one)
    norm = ring.add(ring.power(v["a"], 2), v["a"], ring.one)
    q = ring.add(ring.power(v["u"], 2), ring.mul(v["u"], v["delta"]),
                 ring.power(v["delta"], 2))
    g1 = ring.add(ring.power(v["u"], 2), ring.mul(v["u"], v["p"]),
                  ring.mul(ring.power(v["p"], 2), theta))
    g2 = ring.add(
        ring.power(v["u"], 3),
        ring.mul(ring.power(v["u"], 2), v["delta"]),
        ring.product((v["u"], ring.power(v["p"], 2), theta)),
        ring.product((v["delta"], ring.power(v["p"], 2), theta)),
        ring.product((ring.power(v["delta"], 2), v["p"])),
    )
    g2a = ring.add(g2, ring.product((v["delta"], v["a"], g1)))
    d = ring.product((v["delta"], norm, g1, g2a))
    residue_polynomial = ring.add(
        ring.mul(ring.power(u_derivative(b0), 2), ring.power(q, 4)),
        ring.product((b0, ring.power(q, 2), ring.power(u_derivative(d), 2))),
    )
    remainder = u_reduce(ring, residue_polynomial, g2a)
    raw_conditions = u_coefficients(remainder)
    assert tuple(len(poly) for poly in raw_conditions) == RAW_COEFFICIENT_SIZES
    norm6 = ring.power(norm, 6)
    conditions = []
    for poly in raw_conditions:
        assert min(m[DELTA] for m in poly) >= 6
        without_delta = set()
        for monomial in poly:
            reduced = list(monomial)
            reduced[DELTA] -= 6
            without_delta.add(tuple(reduced))
        conditions.append(divide_monic(without_delta, norm6, A))
    conditions = tuple(conditions)
    assert tuple(len(poly) for poly in conditions) == STRIPPED_COEFFICIENT_SIZES
    assert all(max(m[H0] for m in poly) == 1 for poly in conditions)
    assert all(all(m[H1] == 0 for m in poly) for poly in conditions)
    return ring, conditions


def divide_variable_power(poly, index: int, power: int):
    assert min(m[index] for m in poly) >= power
    out = set()
    for monomial in poly:
        reduced = list(monomial)
        reduced[index] -= power
        out.add(tuple(reduced))
    return out


def square_root(poly, label: str):
    odd = sorted({TVARS[index] for monomial in poly for index, exponent in enumerate(monomial)
                  if exponent % 2})
    assert not odd, (label, odd, len(poly))
    return {tuple(exponent // 2 for exponent in monomial) for monomial in poly}


def residual_pairs(ring, conditions):
    """Extract the exact h0-cross-determinant residuals R01,R12,P02."""
    splits = [h0_split(ring, poly) for poly in conditions]
    cross = {}
    for label, i, j in (("R01", 0, 1), ("R12", 1, 2), ("P02", 0, 2)):
        ai, bi = splits[i]
        aj, bj = splits[j]
        cross[label] = ring.add(ring.mul(ai, bj), ring.mul(aj, bi))
    v = ring.v
    norm = ring.add(ring.power(v["a"], 2), v["a"], ring.one)
    e_shift = ring.add(v["e"], v["delta"])
    residuals = {}
    for label, poly in cross.items():
        poly = divide_variable_power(poly, E, 1)
        poly = divide_monic(poly, e_shift, E)
        if label != "P02":
            poly = divide_monic(poly, norm, A)
            poly = divide_variable_power(poly, DELTA, 4)
            poly = divide_variable_power(poly, P, 7)
        else:
            # Exact correction to the earlier exploratory factor statement:
            # E02 = e*(e+delta)*delta^2*p^6*P02, not a square residual.
            poly = divide_variable_power(poly, DELTA, 2)
            poly = divide_variable_power(poly, P, 6)
        if label == "P02":
            assert any(any(exponent % 2 for exponent in monomial) for monomial in poly)
            residuals[label] = poly
        else:
            residuals[label] = square_root(poly, label)
    allowed = {DELTA, A, P, W}
    assert all(all(all(exponent == 0 for index, exponent in enumerate(monomial)
                       if index not in allowed) for monomial in poly)
               for poly in residuals.values())
    return residuals


def add(*values: int) -> int:
    out = 0
    for value in values:
        out ^= value
    return out


def mul(*values: int) -> int:
    out = 1
    for value in values:
        out = gf8_mul(out, value)
    return out


def square(value: int) -> int:
    return gf8_mul(value, value)


def theta(w: int) -> int:
    return add(square(w), w, 1)


def known_branch(e: int, delta: int, a: int, b: int, p: int, w: int,
                 h0: int) -> tuple[bool, ...]:
    branch1 = e == 0 and h0 == 0
    h0_2 = add(mul(square(p), theta(w)), square(e), mul(e, b), mul(e, a, p))
    branch2 = e == delta and h0 == h0_2
    h0_3 = add(mul(square(e), square(a)), mul(e, square(a), p), mul(e, a, p),
                 square(e), mul(e, b), mul(e, p))
    branch3 = delta == p and w in (0, 1) and h0 == h0_3
    return branch1, branch2, branch3


def merged_pole(delta: int, p: int, w: int) -> bool:
    k1 = add(mul(square(p), square(w)), mul(delta, p, w),
             mul(square(p), w), square(delta), square(p))
    k2 = add(k1, mul(delta, p))
    return k1 == 0 or k2 == 0


GF512_MOD = (1 << 9) | (1 << 4) | 1


def gf512_mul(x: int, y: int) -> int:
    out = 0
    while y:
        if y & 1:
            out ^= x
        y >>= 1
        x <<= 1
        if x & (1 << 9):
            x ^= GF512_MOD
    return out


def gf512_power(value: int, exponent: int) -> int:
    out = 1
    while exponent:
        if exponent & 1:
            out = gf512_mul(out, value)
        value = gf512_mul(value, value)
        exponent >>= 1
    return out


# x^9+x^4+1 is primitive: x has order 511=7*73.
assert gf512_power(2, 511) == 1
assert gf512_power(2, 7) != 1 and gf512_power(2, 73) != 1
GF512_INV = {value: gf512_power(value, 510) for value in range(1, 512)}


def specialize512(poly: dict[tuple[int, ...], int], index: int, value: int):
    out = {}
    powers = [1]
    max_power = max((monomial[index] for monomial in poly), default=0)
    for _ in range(max_power):
        powers.append(gf512_mul(powers[-1], value))
    for monomial, coefficient in poly.items():
        if monomial[index]:
            coefficient = gf512_mul(coefficient, powers[monomial[index]])
            if coefficient == 0:
                continue
        reduced = list(monomial)
        reduced[index] = 0
        reduced = tuple(reduced)
        combined = out.get(reduced, 0) ^ coefficient
        if combined:
            out[reduced] = combined
        elif reduced in out:
            del out[reduced]
    return out


def specialize512_all(polys, index: int, value: int):
    return tuple(specialize512(poly, index, value) for poly in polys)


def dense_univariate(poly, index: int):
    degree = max((monomial[index] for monomial in poly), default=-1)
    if degree < 0:
        return []
    out = [0] * (degree + 1)
    for monomial, coefficient in poly.items():
        assert all(exponent == 0 for i, exponent in enumerate(monomial) if i != index)
        out[monomial[index]] ^= coefficient
    while out and out[-1] == 0:
        out.pop()
    return out


def poly_remainder(left, right):
    assert right
    out = list(left)
    inverse_lead = GF512_INV[right[-1]]
    while len(out) >= len(right):
        scale = gf512_mul(out[-1], inverse_lead)
        shift = len(out) - len(right)
        for index, coefficient in enumerate(right):
            out[index + shift] ^= gf512_mul(scale, coefficient)
        while out and out[-1] == 0:
            out.pop()
    return out


def poly_gcd(left, right):
    while right:
        left, right = right, poly_remainder(left, right)
    if not left:
        return []
    scale = GF512_INV[left[-1]]
    return [gf512_mul(coefficient, scale) for coefficient in left]


def poly_evaluate(poly, value: int) -> int:
    out = 0
    for coefficient in reversed(poly):
        out = gf512_mul(out, value) ^ coefficient
    return out


def evaluate512(poly, values: dict[int, int]) -> int:
    out = 0
    for monomial in poly:
        term = 1
        for index, exponent in enumerate(monomial):
            if exponent:
                term = gf512_mul(term, gf512_power(values[index], exponent))
        out ^= term
    return out


def merged_pole512(delta: int, w: int) -> bool:
    # p=1 chart.
    k1 = gf512_mul(w, w) ^ gf512_mul(delta, w) ^ w ^ gf512_mul(delta, delta) ^ 1
    k2 = k1 ^ delta
    return k1 == 0 or k2 == 0


def sample_excess_bases(residuals, sample_count: int = 8):
    """Deterministically sample GF(512) points of V(R01,R12,P02), p=1."""
    polys = tuple({monomial: 1 for monomial in residuals[label]}
                  for label in ("R01", "R12", "P02"))
    polys = specialize512_all(polys, P, 1)
    samples = []
    pairs_checked = 0
    candidate_roots = 0
    triple_roots = 0
    branch3_roots = 0
    merged_pole_roots = 0
    for delta in range(1, 512):
        at_delta = specialize512_all(polys, DELTA, delta)
        for w in range(512):
            pairs_checked += 1
            at_w = specialize512_all(at_delta[:2], W, w)
            left = dense_univariate(at_w[0], A)
            right = dense_univariate(at_w[1], A)
            gcd = poly_gcd(left, right)
            if not left and not right:
                roots = range(1, 512)
            elif len(gcd) > 1:
                roots = (a for a in range(1, 512) if poly_evaluate(gcd, a) == 0)
            else:
                continue
            for a in roots:
                candidate_roots += 1
                values = {DELTA: delta, A: a, P: 1, W: w}
                assert evaluate512(residuals["R01"], values) == 0
                assert evaluate512(residuals["R12"], values) == 0
                if evaluate512(residuals["P02"], values) != 0:
                    continue
                triple_roots += 1
                if delta == 1 and w in (0, 1):
                    branch3_roots += 1
                    continue
                if merged_pole512(delta, w):
                    merged_pole_roots += 1
                    continue
                samples.append((delta, a, w))
                if len(samples) == sample_count:
                    return samples, {
                        "delta_w_pairs_checked_before_stop": pairs_checked,
                        "common_R01_R12_roots_checked": candidate_roots,
                        "triple_residual_roots": triple_roots,
                        "branch3_roots": branch3_roots,
                        "other_merged_pole_roots": merged_pole_roots,
                    }
    return samples, {
        "delta_w_pairs_checked_before_stop": pairs_checked,
        "common_R01_R12_roots_checked": candidate_roots,
        "triple_residual_roots": triple_roots,
        "branch3_roots": branch3_roots,
        "other_merged_pole_roots": merged_pole_roots,
    }


def lift_probe(ring, conditions, samples):
    """Exhaust (e,b), solve h0, and count genuine lifts at sampled bases."""
    splits = [h0_split(ring, poly) for poly in conditions]
    polys = tuple({monomial: 1 for monomial in part} for split in splits for part in split)
    out = []
    for delta, a, w in samples:
        fixed = specialize512_all(polys, P, 1)
        fixed = specialize512_all(fixed, DELTA, delta)
        fixed = specialize512_all(fixed, A, a)
        fixed = specialize512_all(fixed, W, w)
        lift_bases = 0
        lift_solutions = 0
        all_a_bases = 0
        witness = None
        for e in range(1, 512):
            if e == delta:
                continue
            at_e = specialize512_all(fixed, E, e)
            for b in range(512):
                values = tuple(constant(poly) for poly in specialize512_all(at_e, B, b))
                pairs = tuple(zip(values[0::2], values[1::2]))
                if all(alpha == 0 for alpha, _ in pairs):
                    all_a_bases += 1
                    if all(beta == 0 for _, beta in pairs):
                        lift_bases += 1
                        lift_solutions += 512
                        if witness is None:
                            witness = [e, b, 0]
                    continue
                alpha, beta = next(pair for pair in pairs if pair[0])
                h0 = gf512_mul(beta, GF512_INV[alpha])
                if all(gf512_mul(al, h0) ^ be == 0 for al, be in pairs):
                    lift_bases += 1
                    lift_solutions += 1
                    if witness is None:
                        witness = [e, b, h0]
        out.append({
            "base_delta_a_p_w": [delta, a, 1, w],
            "e_b_pairs_checked": 510 * 512,
            "lifting_e_b_pairs": lift_bases,
            "lifting_h0_solutions": lift_solutions,
            "all_A_e_b_pairs": all_a_bases,
            "first_lift_e_b_h0": witness,
        })
    return out


def specialize(poly: dict[tuple[int, ...], int], index: int, value: int):
    """Specialize one variable of a sparse GF(8)-coefficient polynomial."""
    out = {}
    powers = GF8_POW[value]
    for monomial, coefficient in poly.items():
        if monomial[index]:
            coefficient = gf8_mul(coefficient, powers[monomial[index]])
            if coefficient == 0:
                continue
        reduced = list(monomial)
        reduced[index] = 0
        reduced = tuple(reduced)
        combined = out.get(reduced, 0) ^ coefficient
        if combined:
            out[reduced] = combined
        elif reduced in out:
            del out[reduced]
    return out


def specialize_all(polys, index: int, value: int):
    return tuple(specialize(poly, index, value) for poly in polys)


def constant(poly) -> int:
    assert len(poly) <= 1
    if not poly:
        return 0
    monomial, coefficient = next(iter(poly.items()))
    assert not any(monomial)
    return coefficient


def known_points() -> set[tuple[int, ...]]:
    """Construct the three-branch union without scanning the full h0 domain."""
    nonzero = range(1, 8)
    out = set()
    for delta, a, b, p, w in itertools.product(nonzero, nonzero, range(8), nonzero, range(8)):
        out.add((0, delta, a, b, p, w, 0))
    for e, a, b, p, w in itertools.product(nonzero, nonzero, range(8), nonzero, range(8)):
        h0 = add(mul(square(p), theta(w)), square(e), mul(e, b), mul(e, a, p))
        out.add((e, e, a, b, p, w, h0))
    for e, a, b, p, w in itertools.product(range(8), nonzero, range(8), nonzero, (0, 1)):
        h0 = add(mul(square(e), square(a)), mul(e, square(a), p), mul(e, a, p),
                 square(e), mul(e, b), mul(e, p))
        out.add((e, p, a, b, p, w, h0))
    return out


def census(conditions, ring) -> dict:
    splits = [h0_split(ring, poly) for poly in conditions]
    # Six polynomials ordered A0,B0,A1,B1,A2,B2, now with GF(8) coefficients.
    polys = tuple({monomial: 1 for monomial in part} for split in splits for part in split)
    nonzero = range(1, 8)
    solutions = set()
    all_a_bases = 0
    all_a_solutions = 0
    for delta in nonzero:
        at_delta = specialize_all(polys, DELTA, delta)
        for a in nonzero:
            at_a = specialize_all(at_delta, A, a)
            for p in nonzero:
                at_p = specialize_all(at_a, P, p)
                for e in range(8):
                    at_e = specialize_all(at_p, E, e)
                    for b in range(8):
                        at_b = specialize_all(at_e, B, b)
                        for w in range(8):
                            values = tuple(constant(poly) for poly in specialize_all(at_b, W, w))
                            pairs = tuple(zip(values[0::2], values[1::2]))
                            if all(alpha == 0 for alpha, _ in pairs):
                                all_a_bases += 1
                                if all(beta == 0 for _, beta in pairs):
                                    all_a_solutions += 8
                                    for h0 in range(8):
                                        solutions.add((e, delta, a, b, p, w, h0))
                                continue
                            alpha, beta = next(pair for pair in pairs if pair[0])
                            h0 = gf8_mul(beta, GF8_INV[alpha])
                            if all(gf8_mul(al, h0) ^ be == 0 for al, be in pairs):
                                solutions.add((e, delta, a, b, p, w, h0))

    expected = known_points()
    known = solutions & expected
    extra = solutions - expected
    missed_known = expected - solutions
    assert not missed_known, sorted(missed_known)[:8]

    branch_counts = [sum(flags[index] for flags in map(lambda x: known_branch(*x), solutions))
                     for index in range(3)]
    off_merged = {point for point in solutions if not merged_pole(point[1], point[4], point[5])}
    extra_off_merged = {point for point in extra if point in off_merged}
    return {
        "base_tuples_checked": 8 * 7 * 7 * 8 * 7 * 8,
        "parameter_points_covered_including_h0": 8 * 7 * 7 * 8 * 7 * 8 * 8,
        "solutions": len(solutions),
        "known_branch_union_solutions": len(expected),
        "extra_solutions": len(extra),
        "extra_off_K1K2": len(extra_off_merged),
        "solutions_off_K1K2": len(off_merged),
        "solutions_on_K1K2": len(solutions) - len(off_merged),
        "branch_incidence_counts": {
            "e_zero": branch_counts[0],
            "e_equals_delta": branch_counts[1],
            "delta_equals_p_theta_one": branch_counts[2],
        },
        "all_A_bases": all_a_bases,
        "all_A_solutions": all_a_solutions,
        "extra_samples": [list(point) for point in sorted(extra)[:8]],
    }


def main() -> None:
    ring, conditions = residue_conditions()
    residuals = residual_pairs(ring, conditions)
    result = census(conditions, ring)
    dp_degrees = {
        label: sorted({monomial[DELTA] + monomial[P] for monomial in poly})
        for label, poly in residuals.items()
    }
    assert all(len(degrees) == 1 for degrees in dp_degrees.values())
    samples, scan = sample_excess_bases(residuals)
    probes = lift_probe(ring, conditions, samples)
    extra_lift_found = any(item["lifting_e_b_pairs"] for item in probes)
    print(json.dumps({
        "context": {
            "task": "C210 a!=0 D_AS step-0 GF(8) census",
            "field": "GF(2)[x]/(x^3+x+1), elements encoded as 3-bit polynomial coefficients",
            "domain": "delta,a,p nonzero; e,b,w,h0 arbitrary",
            "conditions": "raw C0,C1,C2 coefficients of W mod G2a; common content nonzero on domain",
            "source": "B0 rebuilt from the committed universal resultant",
        },
        "raw_condition_term_counts": list(RAW_COEFFICIENT_SIZES),
        "stripped_condition_term_counts": list(STRIPPED_COEFFICIENT_SIZES),
        "cross_determinant_residual_term_counts": {
            label: len(poly) for label, poly in residuals.items()
        },
        "gf512_excess_probe": {
            "field": "GF(2)[x]/(x^9+x^4+1), elements encoded as 9-bit polynomial coefficients",
            "chart": "p=1",
            "chart_is_lossless": "yes -- each residual is (delta,p)-homogeneous and p is nonzero",
            "delta_p_homogeneous_degrees": dp_degrees,
            **scan,
            "sample_count": len(samples),
            "sample_target": 8,
            "sample_filter": "R01=R12=P02=0, delta*a*K1*K2 nonzero, off branch 3",
            "lift_domain": "e nonzero and e!=delta; b arbitrary; h0 solved exactly",
            "probes": probes,
            "extra_lift_found": extra_lift_found,
        },
        "census": result,
        "conclusion": (
            "GF(8) has no extra residue-system points, but the GF(512) excess locus has genuine "
            "lifts outside the three known branches"
            if result["extra_solutions"] == 0 and extra_lift_found else
            "the GF(8) census and GF(512) probe found no point outside the three known branches"
            if result["extra_solutions"] == 0 else
            "the exact GF(8) residue-system census contains points outside the three known branches"
        ),
        "does_not_prove": [
            "odd-tower arithmetic completeness beyond GF(8)",
            "that K1*K2=0 residue-system points factor the original cover",
            "collision-forcing or arc-legality of any branch",
            "a symbolic parametrization or irreducible decomposition of the GF(512) excess locus",
        ],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
