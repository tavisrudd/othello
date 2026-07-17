#!/usr/bin/env python3
"""Classify the first degree-drop stratum of the C210 collision curve.

The shared-``(a,b)`` two-repair trace-one condition has the rational
parametrization

``k0 = p^2 (w^2+w+1) + a*delta*p + delta*b + delta^2``
``k1 = delta*(a^2+a+1)*p + a*T0 + delta*b + delta^2``.

This checker pulls the universal seed--cross-repair resultant back to that
cover.  Singular proves that the pullback and its ``a=0`` restriction are
generically irreducible.  The coefficients in the seed parameter ``t`` show
that ``a=0`` is the first degree-drop divisor and that its only further
degree-drop intersection is ``a=b=0``, where the resultant becomes
univariate in the repair-pair sum ``u``.

The final bounded check is deliberately confined to that exceptional
intersection.  It classifies the already normalized GF(8) constant-height
layers exactly, then proves that every trace-one two-layer arc has an
odd-degree factor in one of its two seed collision polynomials.  Hence none
of those finite exceptions survives its odd scalar tower.
"""

from __future__ import annotations

import itertools
import json
import shutil
import subprocess
from collections import Counter, defaultdict

from analyze_c210_exceptional_quadratic_locus import line_key, repair_points
from analyze_c210_persistent_singletons import factor
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    NAMES,
    expected_quadratics,
    resultant,
)


def singular_term(monomial: tuple[int, ...]) -> str:
    factors = []
    for index, name in enumerate(NAMES):
        exponent = monomial[index]
        if exponent:
            factors.append(name if exponent == 1 else f"{name}^{exponent}")
    return "*".join(factors) or "1"


def symbolic_checks(polynomial: set[tuple[int, ...]]) -> None:
    used = [
        name for index, name in enumerate(NAMES)
        if any(monomial[index] for monomial in polynomial)
    ]
    source = [
        f"ring q=2,({','.join(used)},p,w,h0,h1),dp;",
        "poly R=" + "+".join(singular_term(m) for m in polynomial) + ";",
        "poly N=a^2+a+1; poly L=delta*b+delta^2;",
        "poly T0=p^2*(w^2+w+1)+a*delta*p;",
        "poly K0=T0+L; poly K1=delta*N*p+a*T0+L;",
        "R=subst(R,k0,K0); R=subst(R,k1,K1);",
        "R=subst(R,c0,h0+g0); R=subst(R,c1,h1+g1);",
        "list FG=factorize(R);",
        "if(size(FG[1])!=2 || FG[2][2]!=1){exit(1);}",
        "matrix CT=coef(R,t);",
        "poly Q=u^2+u*delta+delta^2;",
        "if(CT[1,1]!=t^4 || CT[2,1]!=a^2*Q^2){exit(2);}",
        "poly R0=subst(R,a,0); list F0=factorize(R0);",
        "if(size(F0[1])!=2 || F0[2][2]!=1){exit(3);}",
        "matrix C0=coef(R0,t);",
        "if(C0[1,1]!=t^2 || C0[2,1]!=b^2*Q^2){exit(4);}",
        "poly R00=subst(R0,b,0);",
        "if(subst(R00,t,0)!=R00){exit(5);}",
        # One degree-preserving a=0 fiber, with tau^3+tau+1=0.  Its
        # total degree is six.  A geometrically reducible base-irreducible
        # polynomial has a transitive orbit of 2, 3, or 6 factors, so the
        # three extension checks certify absolute irreducibility.
        "ring r3=(2,A),(u,t),dp; minpoly=A^3+A+1; number z=A;",
        "poly P=(z+1)*u6+z*u5t+u4t2+(z+1)*u5+(z^2+z+1)*u4t+u4"
        "+(z^2+z)*u3t+z^2*u2t2+(z^2+1)*u3+(z^2+z)*u2t+z*u2"
        "+(z^2+z+1)*ut+(z^2+z)*t2+u+(z^2+z+1)*t+(z^2+z);",
        "list F3=factorize(P);",
        "if(size(F3[1])!=2 || F3[2][2]!=1){exit(6);}",
        "ring r6=(2,A),(u,t),dp; minpoly=A^6+A^5+1;",
        "number z=A^5+A^3+A^2+A+1;",
        "if(z^3+z+1!=0){exit(7);}",
        "poly P=(z+1)*u6+z*u5t+u4t2+(z+1)*u5+(z^2+z+1)*u4t+u4"
        "+(z^2+z)*u3t+z^2*u2t2+(z^2+1)*u3+(z^2+z)*u2t+z*u2"
        "+(z^2+z+1)*ut+(z^2+z)*t2+u+(z^2+z+1)*t+(z^2+z);",
        "list F6=factorize(P);",
        "if(size(F6[1])!=2 || F6[2][2]!=1){exit(8);}",
        "ring r9=(2,A),(u,t),dp;",
        "minpoly=A^9+A^8+A^6+A^5+A^4+A^3+A^2+A+1;",
        "number z=A^8+A^7+A^6+A^2+A+1;",
        "poly P=(z+1)*u6+z*u5t+u4t2+(z+1)*u5+(z^2+z+1)*u4t+u4"
        "+(z^2+z)*u3t+z^2*u2t2+(z^2+1)*u3+(z^2+z)*u2t+z*u2"
        "+(z^2+z+1)*ut+(z^2+z)*t2+u+(z^2+z+1)*t+(z^2+z);",
        "if(z^3+z+1!=0){exit(9);}",
        "list F9=factorize(P);",
        "if(size(F9[1])!=2 || F9[2][2]!=1){exit(10);}",
        "ring r18=(2,A),(u,t),dp;",
        "minpoly=A^18+A^17+A^10+A^9+A^8+A^7+A^6+A^3+1;",
        "number z=A^16+A^15+A^14+A^13+A^12+A^11+A^10"
        "+A^8+A^7+A^4+A^2;",
        "poly P=(z+1)*u6+z*u5t+u4t2+(z+1)*u5+(z^2+z+1)*u4t+u4"
        "+(z^2+z)*u3t+z^2*u2t2+(z^2+1)*u3+(z^2+z)*u2t+z*u2"
        "+(z^2+z+1)*ut+(z^2+z)*t2+u+(z^2+z+1)*t+(z^2+z);",
        "if(z^3+z+1!=0){exit(11);}",
        "list F18=factorize(P);",
        "if(size(F18[1])!=2 || F18[2][2]!=1){exit(12);}",
        'print("symbolic checks pass");',
    ]
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else [
        "nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"
    ])
    completed = subprocess.run(
        command, input="\n".join(source), text=True, capture_output=True,
        check=True,
    )
    assert completed.stderr == ""
    assert completed.stdout.strip() == "symbolic checks pass"


def bounded_intersection_check(
    polynomial: set[tuple[int, ...]],
) -> tuple[dict[int, int], int, Counter[tuple[tuple[int, ...], tuple[int, ...]]]]:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    add, mul = field.add, field.mul
    indices = {name: NAMES.index(name) for name in NAMES}
    terms = {
        monomial for monomial in polynomial
        if monomial[indices["a"]] == monomial[indices["b"]]
        == monomial[indices["t"]] == 0
    }

    seeds = tuple(
        (parameter, height)
        for parameter in base
        for height in (context.alpha, context.beta)
    )

    def is_arc(points: tuple[tuple[int, int], ...]) -> bool:
        seen = set()
        for left, right in itertools.combinations(points, 2):
            key = line_key(context, left, right)
            if key in seen:
                return False
            seen.add(key)
        return True

    legal: dict[int, list[tuple[int, int]]] = defaultdict(list)
    for e in base[1:]:
        for c0, c1 in itertools.product(base, repeat=2):
            if c0 == c1 == 0:
                continue
            repair = tuple(repair_points(context, e, 0, 0, c0, c1))
            if is_arc(seeds + repair):
                legal[e].append((c0, c1))

    two_layer_arcs = []
    for e, delta in itertools.product(base[1:], repeat=2):
        e_prime = add(e, delta)
        if e_prime == 0:
            continue
        for left in legal[e]:
            for right in legal[e_prime]:
                points = (
                    seeds
                    + tuple(repair_points(context, e, 0, 0, *left))
                    + tuple(repair_points(context, e_prime, 0, 0, *right))
                )
                if is_arc(points):
                    two_layer_arcs.append((e, delta, left, right))

    def trace(value: int) -> int:
        out = 0
        conjugate = value
        for _ in range(3):
            out = add(out, conjugate)
            conjugate = mul(conjugate, conjugate)
        assert out in (0, 1)
        return out

    def specialize_univariate(values: dict[str, int]) -> tuple[int, ...]:
        coefficients: dict[int, int] = {}
        for monomial in terms:
            coefficient = 1
            for index, name in enumerate(NAMES):
                if name in ("r", "s", "u", "t"):
                    continue
                coefficient = mul(
                    coefficient,
                    field.power(values.get(name, 0), monomial[index]),
                )
            degree = monomial[indices["u"]]
            coefficients[degree] = add(coefficients.get(degree, 0), coefficient)
        degree = max(coefficients)
        result = tuple(coefficients.get(i, 0) for i in range(degree + 1))
        while result and result[-1] == 0:
            result = result[:-1]
        return result

    factor_profiles: Counter[tuple[tuple[int, ...], tuple[int, ...]]] = Counter()
    trace_one_arcs = 0
    for e, delta, left, right in two_layer_arcs:
        k0 = add(left[0], right[0])
        k1 = add(left[1], right[1])
        p = field.div(add(k1, mul(delta, delta)), delta)
        if p == 0:
            continue
        trace_value = trace(field.div(
            add(k0, mul(delta, delta)), mul(p, p)
        ))
        if trace_value != 1:
            continue
        trace_one_arcs += 1
        profiles = []
        for seed_height in (context.alpha, context.beta):
            g0, g1 = context.coordinates(seed_height)
            poly = specialize_univariate({
                "e": e, "delta": delta, "a": 0, "b": 0,
                "k0": k0, "k1": k1,
                "c0": left[0], "c1": left[1], "g0": g0, "g1": g1,
            })
            profiles.append(tuple(len(part) - 1 for part in factor(
                field, base, poly
            )))
        factor_profiles[tuple(profiles)] += 1
        assert any(
            any(degree % 2 == 1 for degree in profile)
            for profile in profiles
        )

    assert sum(len(rows) for rows in legal.values()) == 35
    assert len(two_layer_arcs) == 22
    assert trace_one_arcs == 12
    return ({e: len(rows) for e, rows in legal.items()}, trace_one_arcs,
            factor_profiles)


def main() -> None:
    ring = BinaryRing()
    polynomial = resultant(ring, expected_quadratics(ring))
    symbolic_checks(polynomial)
    legal_counts, trace_one_arcs, factor_profiles = bounded_intersection_check(
        polynomial
    )
    print(json.dumps({
        "trace_one_cover": {
            "parameters": "p!=0,w with q/p^2=w^2+w+1",
            "k0": "p^2*(w^2+w+1)+a*delta*p+delta*b+delta^2",
            "k1": "delta*(a^2+a+1)*p+a*T0+delta*b+delta^2",
        },
        "generic_trace_pullback_irreducible": True,
        "t_degree_strata": {
            "a_nonzero": 4,
            "a_zero_b_nonzero": 2,
            "a_zero_b_zero": 0,
        },
        "a_zero_generic_absolutely_irreducible": {
            "fiber_total_degree": 6,
            "irreducible_extension_degrees": [1, 2, 3, 6],
        },
        "gf8_a_zero_b_zero": {
            "legal_single_layers_by_coset": legal_counts,
            "two_layer_arcs": 22,
            "trace_one_two_layer_arcs": trace_one_arcs,
            "seed_factor_degree_profiles": {
                str(profile): count
                for profile, count in sorted(factor_profiles.items())
            },
            "odd_scalar_tower_survivors": 0,
        },
        "conclusion": (
            "a=0 is the first degree-drop divisor but remains generically "
            "collision-forcing; its a=b=0 intersection is univariate, and "
            "all twelve normalized GF(8) trace-one arcs collide on an odd "
            "scalar extension"
        ),
        "next_gate": (
            "compute factorization divisors on the a!=0 trace-one locus; "
            "then classify their intersections with H=J=0"
        ),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
