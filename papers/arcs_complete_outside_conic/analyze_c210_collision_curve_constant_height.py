#!/usr/bin/env python3
"""Normalize the coefficient-varying ``a=b=0`` C210 collision locus."""

from __future__ import annotations

import json
import itertools
import shutil
import subprocess
from collections.abc import Iterable

from analyze_c210_persistent_singletons import poly_add, poly_divmod, poly_mul
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    NAMES,
    expected_quadratics,
    resultant,
)


VARIABLES = ("z", "t", "e", "delta", "p", "w", "h0", "h1", "g0", "g1")
Monomial = tuple[int, ...]
Polynomial = set[Monomial]


class SparseRing:
    def __init__(self) -> None:
        self.zero: Polynomial = set()
        self.one: Polynomial = {(0,) * len(VARIABLES)}
        self.variables = {
            name: {tuple(int(i == j) for i in range(len(VARIABLES)))}
            for j, name in enumerate(VARIABLES)
        }

    @staticmethod
    def add(*values: Polynomial) -> Polynomial:
        out: Polynomial = set()
        for value in values:
            out.symmetric_difference_update(value)
        return out

    @staticmethod
    def mul(left: Polynomial, right: Polynomial) -> Polynomial:
        out: Polynomial = set()
        for first in left:
            for second in right:
                term = tuple(x + y for x, y in zip(first, second))
                if term in out:
                    out.remove(term)
                else:
                    out.add(term)
        return out

    def product(self, values: Iterable[Polynomial]) -> Polynomial:
        out = self.one
        for value in values:
            out = self.mul(out, value)
        return out

    def power(self, value: Polynomial, exponent: int) -> Polynomial:
        out = self.one
        base = value
        while exponent:
            if exponent & 1:
                out = self.mul(out, base)
            base = self.mul(base, base)
            exponent >>= 1
        return out


def pullback(polynomial: Polynomial) -> tuple[SparseRing, Polynomial]:
    ring = SparseRing()
    v = ring.variables
    theta = ring.add(ring.power(v["w"], 2), v["w"], ring.one)
    x = ring.add(v["z"], v["w"])
    substitutions = {
        "r": ring.zero,
        "s": ring.zero,
        "u": ring.mul(v["p"], x),
        "t": v["t"],
        "e": v["e"],
        "delta": v["delta"],
        "a": ring.zero,
        "b": ring.zero,
        "k0": ring.add(ring.mul(ring.power(v["p"], 2), theta),
                       ring.power(v["delta"], 2)),
        "k1": ring.add(ring.mul(v["delta"], v["p"]),
                       ring.power(v["delta"], 2)),
        "c0": ring.add(v["h0"], v["g0"]),
        "c1": ring.add(v["h1"], v["g1"]),
        "g0": v["g0"],
        "g1": v["g1"],
    }
    out = ring.zero
    for monomial in polynomial:
        factors = []
        for name, exponent in zip(NAMES, monomial):
            if exponent:
                factors.append(ring.power(substitutions[name], exponent))
        out = ring.add(out, ring.product(factors))
    return ring, out


def singular_term(monomial: Monomial) -> str:
    factors = []
    for name, exponent in zip(VARIABLES, monomial):
        if exponent:
            factors.append(name if exponent == 1 else f"{name}^{exponent}")
    return "*".join(factors) or "1"


def coefficient(polynomial: Polynomial, variable: str, degree: int) -> Polynomial:
    index = VARIABLES.index(variable)
    out = set()
    for monomial in polynomial:
        if monomial[index] == degree:
            reduced = list(monomial)
            reduced[index] = 0
            out.add(tuple(reduced))
    return out


def derivative(polynomial: Polynomial, variable: str) -> Polynomial:
    index = VARIABLES.index(variable)
    out = set()
    for monomial in polynomial:
        if monomial[index] % 2:
            reduced = list(monomial)
            reduced[index] -= 1
            out.add(tuple(reduced))
    return out


def factor_check(polynomial: Polynomial) -> tuple[int, int]:
    used = [
        name for index, name in enumerate(VARIABLES)
        if any(monomial[index] for monomial in polynomial)
    ]
    source = "\n".join((
        f"ring q=2,({','.join(used)}),dp;",
        "poly R=" + "+".join(singular_term(m) for m in polynomial) + ";",
        "list F=factorize(R);",
        "print(size(F[1]));",
        "print(F[2][2]);",
    ))
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else [
        "nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"
    ])
    completed = subprocess.run(
        command, input=source, text=True, capture_output=True, check=True
    )
    lines = [line.strip() for line in completed.stdout.splitlines() if line.strip()]
    return int(lines[-2]), int(lines[-1])


def factor_listing(polynomial: Polynomial) -> list[dict[str, int | str]]:
    used = [
        name for index, name in enumerate(VARIABLES)
        if any(monomial[index] for monomial in polynomial)
    ]
    source = "\n".join((
        f"ring q=2,({','.join(used)}),dp;",
        "poly R=" + "+".join(singular_term(m) for m in polynomial) + ";",
        "list F=factorize(R);",
        "for(int i=2;i<=size(F[1]);i++){print(F[1][i]);print(F[2][i]);}",
    ))
    singular = shutil.which("Singular")
    command = ([singular, "-q"] if singular else [
        "nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"
    ])
    completed = subprocess.run(
        command, input=source, text=True, capture_output=True, check=True
    )
    lines = [line.strip() for line in completed.stdout.splitlines() if line.strip()]
    if len(lines) % 2:
        raise RuntimeError(f"unexpected Singular factor listing: {lines!r}")
    return [
        {"factor": lines[i], "multiplicity": int(lines[i + 1])}
        for i in range(0, len(lines), 2)
    ]


def substitute_variable(
    ring: SparseRing,
    polynomial: Polynomial,
    variable: str,
    value: Polynomial,
) -> Polynomial:
    index = VARIABLES.index(variable)
    out = ring.zero
    for monomial in polynomial:
        exponent = monomial[index]
        reduced = list(monomial)
        reduced[index] = 0
        out = ring.add(out, ring.mul({tuple(reduced)}, ring.power(value, exponent)))
    return out


def gf8_factor_census(polynomial: Polynomial) -> dict[str, object]:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    add, mul = field.add, field.mul
    indices = {name: VARIABLES.index(name) for name in VARIABLES}

    def specialize(values: dict[str, int]) -> tuple[int, ...]:
        coefficients: dict[int, int] = {}
        for monomial in polynomial:
            coefficient_value = 1
            for index, name in enumerate(VARIABLES):
                if name == "z":
                    continue
                coefficient_value = mul(
                    coefficient_value,
                    field.power(values.get(name, 0), monomial[index]),
                )
            degree = monomial[indices["z"]]
            coefficients[degree] = add(
                coefficients.get(degree, 0), coefficient_value
            )
        result = tuple(coefficients.get(i, 0) for i in range(7))
        while result and result[-1] == 0:
            result = result[:-1]
        return result

    tau = context.coordinates(field.add(context.alpha, context.beta))[1]
    def has_odd_degree_factor(poly: tuple[int, ...]) -> bool:
        residue = (0, 1)
        for _ in range(9):
            _, residue = poly_divmod(field, poly_mul(field, residue, residue), poly)
        probe = poly_add(field, residue, (0, 1))
        left, right = poly, probe
        while right:
            _, remainder = poly_divmod(field, left, right)
            left, right = right, remainder
        return len(left) > 1

    odd_factor_status = {"both": 0, "exactly_one": 0, "neither": 0}
    both_without_odd_factor = 0
    sample_count = 0
    w_representatives = tuple(x for x in base if x < add(x, 1))
    h1_representatives = tuple(x for x in base if x < add(x, tau))
    assert len(w_representatives) == len(h1_representatives) == 4
    for e, delta, p, w, h0, h1 in itertools.product(
        base[1:], base[1:], (1,), w_representatives, base,
        h1_representatives,
    ):
        if add(e, delta) == 0:
            continue
        pair = []
        for shifted_h1 in (h1, add(h1, tau)):
            specialized = specialize({
                "e": e, "delta": delta, "p": p, "w": w,
                "h0": h0, "h1": shifted_h1,
            })
            pair.append(has_odd_degree_factor(specialized))
        sample_count += 1
        status = (
            "both" if pair == [True, True]
            else "exactly_one" if any(pair)
            else "neither"
        )
        odd_factor_status[status] += 1
        if not any(pair):
            both_without_odd_factor += 1
    return {
        "both_seed_colors_without_odd_factor": both_without_odd_factor,
        "odd_factor_status": odd_factor_status,
        "normalized_quotient_parameter_tuples": sample_count,
        "seed_shift": "h1 -> h1+tau",
        "scaling_quotient": "p=1 after (e,delta,p,h0,h1)->(lambda*e,lambda*delta,lambda*p,lambda^2*h0,lambda^2*h1)",
        "trace_parameter_quotient": "w modulo w->w+1",
    }


def main() -> None:
    source_ring = BinaryRing()
    universal = resultant(source_ring, expected_quadratics(source_ring))
    ring, polynomial = pullback(universal)
    indices = {name: VARIABLES.index(name) for name in VARIABLES}

    assert all(m[indices["t"]] == m[indices["g0"]] == m[indices["g1"]] == 0
               for m in polynomial)
    degrees = {
        name: max(monomial[index] for monomial in polynomial)
        for index, name in enumerate(VARIABLES)
        if any(monomial[index] for monomial in polynomial)
    }
    weights = {"e": 1, "delta": 1, "p": 1, "h0": 2, "h1": 2}
    assert {
        sum(monomial[indices[name]] * weight for name, weight in weights.items())
        for monomial in polynomial
    } == {8}

    v = ring.variables
    reconstructed_boundary = ring.product((
        v["delta"], ring.power(v["p"], 2),
        ring.add(ring.power(v["z"], 2), v["z"], ring.one),
    ))
    assert coefficient(polynomial, "h0", 1) == ring.power(
        reconstructed_boundary, 2
    )
    assert not coefficient(polynomial, "h0", 2)
    height_zero = coefficient(polynomial, "h0", 0)
    ramification = derivative(height_zero, "z")
    critical_quartic = ring.add(
        ring.mul(ring.power(v["z"], 4), ring.power(v["p"], 2)),
        ring.product((ring.power(v["z"], 2), v["delta"], v["p"])),
        ring.mul(ring.power(v["p"], 2), ring.power(v["w"], 2)),
        ring.product((v["delta"], v["p"], v["w"])),
        ring.power(v["delta"], 2),
        ring.mul(v["delta"], v["p"]),
        ring.power(v["p"], 2),
    )
    inseparable_factor = ring.add(
        ring.power(v["e"], 2), ring.mul(v["e"], v["p"]), v["h1"]
    )
    assert ramification == ring.product((
        v["delta"], ring.power(v["p"], 3), inseparable_factor,
        critical_quartic,
    ))
    inseparable_polynomial = substitute_variable(
        ring, polynomial, "h1",
        ring.add(ring.power(v["e"], 2), ring.mul(v["e"], v["p"])),
    )
    assert max(m[indices["z"]] for m in inseparable_polynomial) == 6
    assert all(m[indices["z"]] % 2 == 0 for m in inseparable_polynomial)
    factor_count, multiplicity = factor_check(polynomial)
    ramification_factor_count, ramification_multiplicity = factor_check(
        ramification
    )
    census = gf8_factor_census(polynomial)
    assert census["normalized_quotient_parameter_tuples"] == 5376
    assert census["both_seed_colors_without_odd_factor"] == 270
    assert census["odd_factor_status"] == {
        "both": 3174, "exactly_one": 1932, "neither": 270
    }
    print(json.dumps({
        "boundary_H": "delta*p^2*(z^2+z+1)",
        "boundary_nonzero_on_odd_scalar_extensions": True,
        "factor_count_with_unit": factor_count,
        "factor_multiplicity": multiplicity,
        "gf8_census": census,
        "h0_coefficient": "H^2",
        "inseparable_divisor": "h1=e^2+e*p",
        "inseparable_divisor_odd_collision_forced": True,
        "normalized_degrees": degrees,
        "normalized_term_count": len(polynomial),
        "ramification_degrees": {
            name: max(monomial[index] for monomial in ramification)
            for index, name in enumerate(VARIABLES)
            if any(monomial[index] for monomial in ramification)
        },
        "ramification_factor_count_with_unit": ramification_factor_count,
        "ramification_factors": factor_listing(ramification),
        "ramification_factor_multiplicity": ramification_multiplicity,
        "ramification_term_count": len(ramification),
        "resultant_independent_of": ["t", "g0", "g1"],
        "symbolic_boundary_term_count": len(reconstructed_boundary),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
