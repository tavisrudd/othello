#!/usr/bin/env python3
"""Test the C210 degree-3/5/7 coverage residue hypergraph.

The q=64 non-repair singleton targets have seed--repair candidates whose
closed-point degrees are at most seven.  On the ``105 | m`` subtower, every
odd closed point therefore becomes rational.  This checker constructs those
candidate hyperedges over GF(8), GF(8^3), GF(8^5), and GF(8^7), deletes every
candidate that violates a one-repair arc gate, adds the two-repair/one-seed
collision edges, and solves the resulting independent-transversal problem.

No ambient plane over GF(8^105) is constructed.  Cross-degree collision tests
run in the tensor composita GF(8^(de)); the relevant degrees 3, 5, and 7 are
pairwise coprime.
"""

from __future__ import annotations

import itertools
import json
import random
import sys
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Hashable

from analyze_c210_persistent_singletons import (
    coverage_equations,
    factor,
    quadratic_splits,
    sylvester_resultant,
    t_gcd_modulus,
)
from probe_c210_two_layer_parabolas import QuadraticField, layer, line_points

BasePoly = tuple[int, ...]
Point = tuple[int, int, int]
Element = Hashable
Poly = tuple[Element, ...]
Node = tuple[int, Element]


class BaseField:
    """The fixed GF(8) subfield in the repository's GF(64) model."""

    def __init__(self, ambient: QuadraticField, elements: tuple[int, ...]):
        self.ambient = ambient
        self.elements = elements
        self.zero = 0
        self.one = 1
        self.log2_order = 3

    def add(self, left: int, right: int) -> int:
        return self.ambient.add(left, right)

    def mul(self, left: int, right: int) -> int:
        return self.ambient.mul(left, right)

    def inv(self, value: int) -> int:
        return self.ambient.inv(value)

    def power(self, value: int, exponent: int) -> int:
        return self.ambient.power(value, exponent)

    def random_element(self, rng: random.Random) -> int:
        return self.elements[rng.randrange(len(self.elements))]


class ExtensionField:
    """A small finite extension represented by a monic quotient polynomial."""

    def __init__(self, base: Any, modulus: Poly):
        assert modulus[-1] == base.one
        self.base = base
        self.modulus = modulus
        self.degree = len(modulus) - 1
        self.zero: Element = ()
        self.one: Element = (base.one,)
        self.log2_order = base.log2_order * self.degree

    def normalize(self, coefficients: list[Element] | tuple[Element, ...]) -> Element:
        out = list(coefficients)
        while out and out[-1] == self.base.zero:
            out.pop()
        return tuple(out)

    def constant(self, value: Element) -> Element:
        return self.zero if value == self.base.zero else (value,)

    def add(self, left: Element, right: Element) -> Element:
        return self.normalize([
            self.base.add(
                left[i] if i < len(left) else self.base.zero,
                right[i] if i < len(right) else self.base.zero,
            )
            for i in range(max(len(left), len(right)))
        ])

    def mul(self, left: Element, right: Element) -> Element:
        if left == self.zero or right == self.zero:
            return self.zero
        out = [self.base.zero] * (len(left) + len(right) - 1)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                out[i + j] = self.base.add(out[i + j], self.base.mul(a, b))
        for degree in range(len(out) - 1, self.degree - 1, -1):
            coefficient = out[degree]
            if coefficient != self.base.zero:
                for i, value in enumerate(self.modulus[:-1]):
                    out[degree - self.degree + i] = self.base.add(
                        out[degree - self.degree + i],
                        self.base.mul(coefficient, value),
                    )
            out[degree] = self.base.zero
        return self.normalize(out[:self.degree])

    def power(self, value: Element, exponent: int) -> Element:
        out = self.one
        while exponent:
            if exponent & 1:
                out = self.mul(out, value)
            value = self.mul(value, value)
            exponent >>= 1
        return out

    def inv(self, value: Element) -> Element:
        if value == self.zero:
            raise ZeroDivisionError
        return self.power(value, (1 << self.log2_order) - 2)

    def random_element(self, rng: random.Random) -> Element:
        return self.normalize([
            self.base.random_element(rng) for _ in range(self.degree)
        ])


def p_trim(field: Any, poly: list[Element] | tuple[Element, ...]) -> Poly:
    out = list(poly)
    while out and out[-1] == field.zero:
        out.pop()
    return tuple(out)


def p_add(field: Any, left: Poly, right: Poly) -> Poly:
    return p_trim(field, [
        field.add(
            left[i] if i < len(left) else field.zero,
            right[i] if i < len(right) else field.zero,
        )
        for i in range(max(len(left), len(right)))
    ])


def p_mul(field: Any, left: Poly, right: Poly) -> Poly:
    if not left or not right:
        return ()
    out = [field.zero] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            out[i + j] = field.add(out[i + j], field.mul(a, b))
    return p_trim(field, out)


def p_divmod(field: Any, left: Poly, right: Poly) -> tuple[Poly, Poly]:
    remainder = list(left)
    quotient = [field.zero] * max(1, len(left) - len(right) + 1)
    while len(p_trim(field, remainder)) >= len(right):
        remainder = list(p_trim(field, remainder))
        degree = len(remainder) - len(right)
        scalar = field.mul(remainder[-1], field.inv(right[-1]))
        quotient[degree] = scalar
        for i, value in enumerate(right):
            remainder[i + degree] = field.add(
                remainder[i + degree], field.mul(scalar, value)
            )
    return p_trim(field, quotient), p_trim(field, remainder)


def p_mod(field: Any, left: Poly, modulus: Poly) -> Poly:
    return p_divmod(field, left, modulus)[1]


def p_monic(field: Any, poly: Poly) -> Poly:
    inverse = field.inv(poly[-1])
    return p_trim(field, [field.mul(value, inverse) for value in poly])


def p_gcd(field: Any, left: Poly, right: Poly) -> Poly:
    left = p_trim(field, left)
    right = p_trim(field, right)
    while right:
        left, right = right, p_mod(field, left, right)
    return p_monic(field, left) if left else ()


def p_powmod(field: Any, value: Poly, exponent: int, modulus: Poly) -> Poly:
    out: Poly = (field.one,)
    while exponent:
        if exponent & 1:
            out = p_mod(field, p_mul(field, out, value), modulus)
        value = p_mod(field, p_mul(field, value, value), modulus)
        exponent >>= 1
    return out


def p_value(field: Any, poly: Poly, value: Element) -> Element:
    out = field.zero
    for coefficient in reversed(poly):
        out = field.add(field.mul(out, value), coefficient)
    return out


def has_root_in_extension(field: Any, poly: Poly, relative_degree: int = 1) -> bool:
    """Whether ``poly`` has a root in the given finite extension of ``field``."""
    poly = p_trim(field, poly)
    if len(poly) <= 1:
        return not poly
    x: Poly = (field.zero, field.one)
    frobenius = x
    for _ in range(field.log2_order * relative_degree):
        frobenius = p_mod(field, p_mul(field, frobenius, frobenius), poly)
    return len(p_gcd(field, poly, p_add(field, frobenius, x))) > 1


def has_root_in_odd_extension(field: Any, poly: Poly, relative_degree: int) -> bool:
    """Root test using only factor degrees that can divide an odd extension."""
    degree = len(p_trim(field, poly)) - 1
    return any(
        has_root_in_extension(field, poly, factor_degree)
        for factor_degree in range(1, degree + 1)
        if relative_degree % factor_degree == 0
    )


def split_linear_roots(field: Any, poly: Poly, seed: int) -> tuple[Element, ...]:
    """Factor a known square-free split polynomial into its linear roots."""
    rng = random.Random(seed)

    def split(part: Poly) -> list[Poly]:
        if len(part) == 2:
            return [part]
        for _ in range(1000):
            probe = p_trim(field, [
                field.random_element(rng) for _ in range(len(part) - 1)
            ])
            trace: Poly = ()
            conjugate = probe
            for _ in range(field.log2_order):
                trace = p_add(field, trace, conjugate)
                conjugate = p_mod(
                    field, p_mul(field, conjugate, conjugate), part
                )
            divisor = p_gcd(field, part, trace)
            if 1 < len(divisor) < len(part):
                quotient, remainder = p_divmod(field, part, divisor)
                assert not remainder
                return split(divisor) + split(quotient)
        raise AssertionError("deterministic trace splitting failed")

    factors = split(p_monic(field, poly))
    roots = tuple(field.mul(factor[0], field.inv(factor[1])) for factor in factors)
    assert len(set(roots)) == len(poly) - 1
    assert all(p_value(field, poly, root) == field.zero for root in roots)
    return roots


@dataclass(frozen=True)
class Context:
    orbit: int
    ambient: QuadraticField
    base_values: tuple[int, ...]
    base_field: BaseField
    alpha: int
    beta: int
    tau: int
    eta0: int
    eta1: int
    a1: int
    b1: int
    c0: int
    c1: int
    g0: int
    eta: int
    a_big: int
    b_big: int
    c_big: int
    coordinates: Any


def build_context(orbit: int = 1) -> Context:
    assert orbit in (1, 2, 3)
    ambient = QuadraticField.for_subfield_order(8)
    base_values = tuple(x for x in range(ambient.q) if ambient.in_subfield(x))
    source = json.loads(Path(__file__).with_name(
        "probe_c210_quadratic_coset_repairs_output.txt"
    ).read_text().splitlines()[-1])
    alpha, beta = source["seed_offsets"]
    eta, a_big, b_big, c_big = source["nonlinear_legal_parameters"][
        4 * (orbit - 1)
    ][:4]
    tau = ambient.add(beta, ambient.power(beta, 8))
    omega = ambient.div(ambient.add(beta, 1), tau)

    def coordinates(value: int) -> tuple[int, int]:
        for second in base_values:
            first = ambient.add(value, ambient.mul(second, omega))
            if ambient.in_subfield(first):
                return first, second
        raise AssertionError(value)

    eta0, eta1 = coordinates(eta)
    a0, a1 = coordinates(a_big)
    b0, b1 = coordinates(b_big)
    c0, c1 = coordinates(c_big)
    assert a0 == b0 == 0
    return Context(
        orbit=orbit,
        ambient=ambient,
        base_values=base_values,
        base_field=BaseField(ambient, base_values),
        alpha=alpha,
        beta=beta,
        tau=tau,
        eta0=eta0,
        eta1=eta1,
        a1=a1,
        b1=b1,
        c0=c0,
        c1=c1,
        g0=c0,
        eta=eta,
        a_big=a_big,
        b_big=b_big,
        c_big=c_big,
        coordinates=coordinates,
    )


def affine_line(field: QuadraticField, left: Point, right: Point) -> set[Point]:
    return {
        point for point in line_points(field, field.cross(left, right))
        if point[0] == 1
    }


def singleton_factor_rows(context: Context) -> list[dict[str, Any]]:
    field = context.ambient
    eta = context.eta
    a_big = context.a_big
    b_big = context.b_big
    c_big = context.c_big
    seeds = tuple(
        layer(field, context.alpha, context.base_values)
        + layer(field, context.beta, context.base_values)
    )
    repairs = {
        r: (
            1,
            field.add(eta, r),
            field.add(
                field.mul(field.add(eta, r), field.add(eta, r)),
                field.add(
                    field.add(field.mul(a_big, field.mul(r, r)),
                              field.mul(b_big, r)),
                    c_big,
                ),
            ),
        )
        for r in context.base_values
    }
    affine = {(1, y, z) for y in range(field.q) for z in range(field.q)}
    seed_covered: set[Point] = set()
    for left, right in itertools.combinations(seeds, 2):
        seed_covered.update(affine_line(field, left, right))
    candidates = {point: set() for point in affine - seed_covered}
    for r, repair in repairs.items():
        for seed in seeds:
            for point in affine_line(field, repair, seed):
                if point in candidates:
                    candidates[point].add(r)

    rows = []
    for point, values in candidates.items():
        if len(values) != 1 or point in repairs.values():
            continue
        base_r = next(iter(values))
        y0, y1 = context.coordinates(point[1])
        height = field.add(point[2], field.mul(point[1], point[1]))
        h0, h1 = context.coordinates(height)
        accepted_moduli: set[BasePoly] = set()
        seed_factor_degrees = []
        for seed_height in (context.alpha, context.beta):
            equations = coverage_equations(
                field, context.coordinates,
                context.eta0, context.eta1,
                context.a1, context.b1, context.c0, context.c1,
                seed_height, y0, y1, h0, h1,
            )
            resultant = sylvester_resultant(field, *equations)
            factors = factor(field, context.base_values, resultant)
            seed_factor_degrees.append([len(modulus) - 1 for modulus in factors])
            for modulus in dict.fromkeys(factors):
                degree = len(modulus) - 1
                gcd = t_gcd_modulus(
                    field, modulus, equations[:3], equations[3:]
                )
                if len(gcd) == 1:
                    continue
                if len(gcd) == 2 or quadratic_splits(field, modulus, gcd):
                    if degree in (1, 3, 5, 7):
                        accepted_moduli.add(modulus)
        linear_roots = {
            modulus[0] for modulus in accepted_moduli if len(modulus) == 2
        }
        assert linear_roots == {base_r}
        rows.append({
            "target": (y0, y1, h0, h1),
            "base_parameter": base_r,
            "moduli": tuple(sorted(accepted_moduli, key=lambda p: (len(p), p))),
            "seed_factor_degrees": seed_factor_degrees,
        })
    assert len(rows) == 72
    return rows


def build_residue_fields(
    context: Context, rows: list[dict[str, Any]]
) -> tuple[dict[int, ExtensionField], dict[BasePoly, tuple[Node, ...]]]:
    moduli_by_degree: dict[int, set[BasePoly]] = defaultdict(set)
    for row in rows:
        for modulus in row["moduli"]:
            degree = len(modulus) - 1
            if degree > 1:
                moduli_by_degree[degree].add(modulus)

    fields: dict[int, ExtensionField] = {}
    roots_by_modulus: dict[BasePoly, tuple[Node, ...]] = {}
    for degree in (3, 5, 7):
        reference = min(moduli_by_degree[degree])
        residue_field = ExtensionField(context.base_field, reference)
        fields[degree] = residue_field
        for index, modulus in enumerate(sorted(moduli_by_degree[degree])):
            lifted = tuple(
                residue_field.constant(coefficient) for coefficient in modulus
            )
            roots = split_linear_roots(
                residue_field, lifted, seed=210000 + 100 * degree + index
            )
            roots_by_modulus[modulus] = tuple(
                (degree, root) for root in sorted(roots, key=repr)
            )
    return fields, roots_by_modulus


def constant(field: Any, value: int) -> Element:
    if isinstance(field, BaseField):
        return value
    return field.constant(constant(field.base, value))


def absolute_trace(field: Any, value: Element) -> Element:
    out = field.zero
    conjugate = value
    for _ in range(field.log2_order):
        out = field.add(out, conjugate)
        conjugate = field.mul(conjugate, conjugate)
    return out


def one_repair_failures(
    context: Context, field: Any, r: Element, total_residue_degree: int = 105
) -> tuple[str, ...]:
    c = lambda value: constant(field, value)
    eta0, eta1 = c(context.eta0), c(context.eta1)
    a1, b1 = c(context.a1), c(context.b1)
    c0, c1, tau = c(context.c0), c(context.c1), c(context.tau)
    one = field.one
    r2 = field.mul(r, r)
    graph_omega = field.add(
        field.add(field.mul(a1, r2), field.mul(b1, r)), c1
    )
    failures = []
    if c0 == field.zero and graph_omega == field.zero:
        failures.append("conic")

    y0 = field.add(eta0, r)
    eta1_sq = field.mul(eta1, eta1)
    for seed_name, seed_height in (("A", context.alpha), ("B", context.beta)):
        seed0_raw, seed1_raw = context.coordinates(seed_height)
        seed0, seed1 = c(seed0_raw), c(seed1_raw)
        p = field.mul(
            field.add(field.add(graph_omega, eta1_sq), seed1),
            field.inv(eta1),
        )
        if p != field.zero:
            q = field.add(
                field.add(
                    field.add(c0, seed0),
                    field.add(field.mul(y0, y0), eta1_sq),
                ),
                field.mul(p, y0),
            )
            ratio = field.mul(q, field.inv(field.mul(p, p)))
            if absolute_trace(field, ratio) == field.zero:
                failures.append(f"same-{seed_name}")

    h = field.add(graph_omega, eta1_sq)
    mixed = (
        field.mul(field.mul(tau, tau), field.mul(tau, eta1)),
        field.mul(field.add(c0, one), field.mul(tau, tau)),
        field.mul(eta1, field.mul(tau, tau)),
        field.add(field.mul(h, h), field.mul(tau, h)),
        field.mul(eta1, tau),
        field.mul(eta1_sq, field.one),
    )
    parameter_degree = field.log2_order // context.base_field.log2_order
    assert total_residue_degree % parameter_degree == 0
    if has_root_in_odd_extension(
        field, mixed, total_residue_degree // parameter_degree
    ):
        failures.append("mixed")
    return tuple(failures)


def embed_element(
    context: Context,
    fields: dict[int, ExtensionField],
    composites: dict[tuple[int, int], ExtensionField],
    node: Node,
    target_degrees: tuple[int, ...],
) -> tuple[Any, Element]:
    degree, value = node
    if len(target_degrees) == 1:
        target_degree = target_degrees[0]
        target = context.base_field if target_degree == 1 else fields[target_degree]
        return target, constant(target, value) if degree == 1 else value

    left_degree, right_degree = target_degrees
    key = (left_degree, right_degree)
    if key not in composites:
        left = fields[left_degree]
        right_modulus = fields[right_degree].modulus
        lifted_modulus = tuple(
            left.constant(coefficient) for coefficient in right_modulus
        )
        composites[key] = ExtensionField(left, lifted_modulus)
    target = composites[key]
    if degree == left_degree:
        return target, target.constant(value)
    assert degree == right_degree
    return target, target.normalize([
        fields[left_degree].constant(coefficient) for coefficient in value
    ])


def collision(
    context: Context,
    fields: dict[int, ExtensionField],
    composites: dict[tuple[int, int], ExtensionField],
    left: Node,
    right: Node,
) -> tuple[str, ...]:
    degrees = tuple(sorted({left[0], right[0]} - {1}))
    if not degrees:
        field: Any = context.base_field
        r, s = left[1], right[1]
    elif len(degrees) == 1:
        field = fields[degrees[0]]
        r = constant(field, left[1]) if left[0] == 1 else left[1]
        s = constant(field, right[1]) if right[0] == 1 else right[1]
    else:
        field, r = embed_element(context, fields, composites, left, degrees)
        _, s = embed_element(context, fields, composites, right, degrees)

    c = lambda value: constant(field, value)
    eta1, a1, b1 = c(context.eta1), c(context.a1), c(context.b1)
    c0, c1 = c(context.c0), c(context.c1)
    p = field.add(r, s)
    q = field.mul(r, s)
    eta1_sq = field.mul(eta1, eta1)
    v = field.add(field.mul(a1, p), b1)
    failures = []
    for seed_name, seed_height in (("A", context.alpha), ("B", context.beta)):
        _, seed1_raw = context.coordinates(seed_height)
        seed1 = c(seed1_raw)
        f = (
            field.add(
                field.add(field.add(eta1_sq, field.mul(eta1, v)), c0),
                field.add(q, field.one),
            ),
            p,
            field.one,
        )
        g = (
            field.add(
                field.add(
                    field.add(eta1_sq, field.mul(eta1, p)),
                    field.mul(eta1, v),
                ),
                field.add(field.add(c1, field.mul(a1, q)), seed1),
            ),
            v,
        )
        common = p_gcd(field, f, g)
        if len(common) > 1 and has_root_in_extension(field, common):
            failures.append(seed_name)
    return tuple(failures)


def node_key(node: Node) -> tuple[int, str]:
    return node[0], repr(node[1])


def solve_independent_transversal(
    hyperedges: list[set[Node]], adjacency: dict[Node, set[Node]]
) -> tuple[set[Node] | None, int]:
    incidence: dict[Node, set[int]] = defaultdict(set)
    for index, edge in enumerate(hyperedges):
        for node in edge:
            incidence[node].add(index)
    calls = 0
    memo: set[tuple[frozenset[int], frozenset[Node]]] = set()

    def search(
        uncovered: frozenset[int], banned: frozenset[Node], chosen: frozenset[Node]
    ) -> frozenset[Node] | None:
        nonlocal calls
        calls += 1
        if not uncovered:
            return chosen
        state = (uncovered, banned)
        if state in memo:
            return None
        available_by_edge = []
        for index in uncovered:
            available = hyperedges[index] - banned
            if not available:
                memo.add(state)
                return None
            available_by_edge.append((len(available), index, available))
        _, _, available = min(available_by_edge, key=lambda row: (row[0], row[1]))
        ordered = sorted(
            available,
            key=lambda node: (-len(incidence[node] & uncovered), node_key(node)),
        )
        for node in ordered:
            result = search(
                frozenset(uncovered - incidence[node]),
                frozenset(set(banned) | adjacency[node] | {node}),
                frozenset(set(chosen) | {node}),
            )
            if result is not None:
                return result
        memo.add(state)
        return None

    result = search(frozenset(range(len(hyperedges))), frozenset(), frozenset())
    return (set(result) if result is not None else None), calls


def analyze_orbit(orbit: int) -> dict[str, Any]:
    context = build_context(orbit)
    assert all(
        not one_repair_failures(
            context, context.base_field, r, total_residue_degree=1
        )
        for r in context.base_values
    )
    rows = singleton_factor_rows(context)
    fields, roots_by_modulus = build_residue_fields(context, rows)

    hyperedges = []
    for row in rows:
        nodes: set[Node] = {(1, row["base_parameter"])}
        for modulus in row["moduli"]:
            if len(modulus) > 2:
                nodes.update(roots_by_modulus[modulus])
        hyperedges.append(nodes)

    all_nodes = set().union(*hyperedges)
    failures: dict[Node, tuple[str, ...]] = {}
    for node in sorted(all_nodes, key=node_key):
        degree, value = node
        field: Any = context.base_field if degree == 1 else fields[degree]
        failures[node] = one_repair_failures(context, field, value)
    legal_nodes = {node for node in all_nodes if not failures[node]}
    legal_hyperedges = [edge & legal_nodes for edge in hyperedges]

    empty_indices = [
        index for index, edge in enumerate(legal_hyperedges) if not edge
    ]
    adjacency = {node: set() for node in legal_nodes}
    edge_colors: Counter[tuple[str, ...]] = Counter()
    solution: set[Node] | None = None
    calls = 0
    if not empty_indices:
        composites: dict[tuple[int, int], ExtensionField] = {}
        for left, right in itertools.combinations(sorted(legal_nodes, key=node_key), 2):
            colors = collision(context, fields, composites, left, right)
            if colors:
                adjacency[left].add(right)
                adjacency[right].add(left)
                edge_colors[colors] += 1
        solution, calls = solve_independent_transversal(legal_hyperedges, adjacency)
        if solution is not None:
            assert all(solution & edge for edge in legal_hyperedges)
            assert all(not (adjacency[node] & solution) for node in solution)

    modulus_histogram = Counter(
        len(modulus) - 1
        for row in rows for modulus in row["moduli"]
    )
    failure_histogram = Counter(
        reason for reasons in failures.values() for reason in reasons
    )
    degree_profile = Counter(node[0] for node in all_nodes)
    legal_degree_profile = Counter(node[0] for node in legal_nodes)
    selected_degree_profile = Counter(
        node[0] for node in solution
    ) if solution is not None else Counter()
    if orbit == 1:
        assert degree_profile == {1: 8, 3: 132, 5: 120, 7: 140}
        assert legal_degree_profile == {5: 20}
        assert len(empty_indices) == 68

    def base_exponent(value: int) -> int | None:
        if value == 0:
            return None
        for exponent in range(7):
            if context.ambient.power(context.tau, exponent) == value:
                return exponent
        raise AssertionError(value)

    empty_witness = None
    if empty_indices:
        index = empty_indices[0]
        row = rows[index]
        edge = hyperedges[index]
        empty_witness = {
            "target_tau_exponents": [base_exponent(value) for value in row["target"]],
            "candidate_moduli_tau_exponents": [
                [base_exponent(value) for value in modulus]
                for modulus in row["moduli"]
            ],
            "candidate_count_by_degree": dict(sorted(Counter(
                node[0] for node in edge
            ).items())),
            "rejection_profile": {
                f"degree-{degree}:{'+'.join(reasons)}": count
                for (degree, reasons), count in sorted(Counter(
                    (node[0], failures[node]) for node in edge
                ).items(), key=lambda item: (item[0][0], item[0][1]))
            },
        }

    return {
        "orbit": orbit,
        "base_field": "GF(8)",
        "residue_degrees": [3, 5, 7],
        "extension_frontier": "GF(8^m), 105|m, m odd",
        "singleton_targets": len(rows),
        "accepted_modulus_occurrences_by_degree": dict(sorted(modulus_histogram.items())),
        "candidate_vertices_by_degree": dict(sorted(degree_profile.items())),
        "one_repair_legal_vertices_by_degree": dict(sorted(legal_degree_profile.items())),
        "one_repair_failure_counts": dict(sorted(failure_histogram.items())),
        "empty_hyperedges_after_vertex_deletion": len(empty_indices),
        "first_empty_hyperedge_certificate": empty_witness,
        "collision_edges": (
            sum(len(values) for values in adjacency.values()) // 2
            if not empty_indices else None
        ),
        "collision_edge_color_profile": {
            "+".join(colors): count for colors, count in sorted(edge_colors.items())
        },
        "maximum_collision_degree": (
            max(map(len, adjacency.values()), default=0)
            if not empty_indices else None
        ),
        "independent_transversal_exists": solution is not None,
        "selected_vertices": len(solution) if solution is not None else None,
        "selected_vertices_by_degree": dict(sorted(selected_degree_profile.items())),
        "search_calls": calls,
        "method":
            "exact closed-point hyperedges and finite-field one-repair filters; "
            "collision checks are unnecessary after an empty hyperedge",
        "no_large_plane_census": True,
        "status": (
            "one-repair vertex obstruction closes the 105|m scalar-extension frontier"
            if empty_indices else (
                "residue-hypergraph compatibility gate passes"
                if solution is not None else
                "collision obstruction closes the 105|m scalar-extension frontier"
            )
        ),
    }


def main() -> None:
    if len(sys.argv) > 1:
        print(json.dumps(analyze_orbit(int(sys.argv[1])), sort_keys=True))
        return

    results = [analyze_orbit(orbit) for orbit in (1, 2, 3)]
    common_keys = (
        "singleton_targets",
        "accepted_modulus_occurrences_by_degree",
        "candidate_vertices_by_degree",
        "one_repair_legal_vertices_by_degree",
        "one_repair_failure_counts",
        "empty_hyperedges_after_vertex_deletion",
    )
    assert all(
        all(result[key] == results[0][key] for key in common_keys)
        for result in results[1:]
    )
    print(json.dumps({
        "base_field": "GF(8)",
        "extension_frontier": "GF(8^m), 105|m, m odd",
        "common_profile": {key: results[0][key] for key in common_keys},
        "orbit_empty_hyperedge_certificates": [
            {
                "orbit": result["orbit"],
                "certificate": result["first_empty_hyperedge_certificate"],
            }
            for result in results
        ],
        "all_three_orbits_closed": all(
            result["empty_hyperedges_after_vertex_deletion"] > 0
            for result in results
        ),
        "no_large_plane_census": True,
        "status":
            "one-repair vertex obstructions close all three frozen q=64 "
            "scalar-extension orbits",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
