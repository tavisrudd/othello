#!/usr/bin/env python3
"""Replay the finite checks for the C294 full-PGL mirror family.

The proof in the companion report is uniform.  This checker independently verifies
all coordinate identities, enumerates the generated projective matrix group for the
eligible primes at most 110, and exhausts the full-degree parameter count in the
fields F_(7^3) and F_(43^3).
"""

from __future__ import annotations

import argparse
import json
from collections import Counter, deque
from itertools import combinations
from pathlib import Path


STEM = "2026-07-17-c294-full-conic-continuation-crown"
TAU = (0, -1, 1, 0)  # t |-> -1/t
ELIGIBLE_PRIME_RESIDUES = (3, 7, 23, 27)


def centres_for(b: int) -> tuple[tuple[int, int], ...]:
    return ((0, 1), (-1, 0), (1, b), (-b, -1))


def is_prime(n: int) -> bool:
    if n < 2:
        return False
    d = 2
    while d * d <= n:
        if n % d == 0:
            return n == d
        d += 1
    return True


def legendre(a: int, p: int) -> int:
    z = pow(a % p, (p - 1) // 2, p)
    return -1 if z == p - 1 else z


def mat_mul(x: tuple[int, ...], y: tuple[int, ...], p: int) -> tuple[int, ...]:
    a, b, c, d = x
    e, f, g, h = y
    return ((a * e + b * g) % p, (a * f + b * h) % p,
            (c * e + d * g) % p, (c * f + d * h) % p)


def mat_normalize(x: tuple[int, ...], p: int) -> tuple[int, ...]:
    for entry in x:
        if entry % p:
            scale = pow(entry % p, p - 2, p)
            return tuple((scale * y) % p for y in x)
    raise AssertionError("zero matrix")


def projective_group_order(gens: list[tuple[int, ...]], p: int) -> int:
    gens = [mat_normalize(g, p) for g in gens]
    identity = (1, 0, 0, 1)
    seen = {identity}
    todo = deque([identity])
    while todo:
        h = todo.popleft()
        for g in gens:
            z = mat_normalize(mat_mul(g, h, p), p)
            if z not in seen:
                seen.add(z)
                todo.append(z)
    return len(seen)


class CubicField:
    """A small deterministic polynomial-basis implementation of F_(p^3)."""

    def __init__(self, p: int, modulus: tuple[int, int, int]) -> None:
        self.p = p
        self.q = p ** 3
        self.modulus = modulus

    def coefficients(self, value: int) -> tuple[int, int, int]:
        return (value % self.p, value // self.p % self.p, value // (self.p * self.p))

    def encode(self, coefficients: tuple[int, int, int]) -> int:
        a, b, c = coefficients
        return a % self.p + self.p * (b % self.p) + self.p * self.p * (c % self.p)

    def constant(self, value: int) -> int:
        return value % self.p

    def add(self, left: int, right: int) -> int:
        a = self.coefficients(left)
        b = self.coefficients(right)
        return self.encode(tuple(a[i] + b[i] for i in range(3)))

    def neg(self, value: int) -> int:
        return self.encode(tuple(-entry for entry in self.coefficients(value)))

    def sub(self, left: int, right: int) -> int:
        return self.add(left, self.neg(right))

    def mul(self, left: int, right: int) -> int:
        a = self.coefficients(left)
        b = self.coefficients(right)
        product = [0] * 5
        for i in range(3):
            for j in range(3):
                product[i + j] = (product[i + j] + a[i] * b[j]) % self.p
        for degree in (4, 3):
            leading = product[degree]
            for offset, coefficient in enumerate(self.modulus):
                product[degree - 3 + offset] -= leading * coefficient
            product[degree] = 0
        return self.encode(tuple(product[i] for i in range(3)))

    def pow(self, value: int, exponent: int) -> int:
        result = self.constant(1)
        base = value
        while exponent:
            if exponent & 1:
                result = self.mul(result, base)
            base = self.mul(base, base)
            exponent >>= 1
        return result

    def inverse(self, value: int) -> int:
        assert value
        return self.pow(value, self.q - 2)

    def character(self, value: int) -> int:
        if value == 0:
            return 0
        result = self.pow(value, (self.q - 1) // 2)
        if result == self.constant(1):
            return 1
        assert result == self.constant(-1)
        return -1

    def in_prime_field(self, value: int) -> bool:
        return self.coefficients(value)[1:] == (0, 0)


def irreducible_cubic(p: int) -> tuple[int, int, int]:
    """Return the first x^3+c2*x^2+c1*x+c0 with no F_p root."""
    for c2 in range(p):
        for c1 in range(p):
            for c0 in range(1, p):
                if all((x ** 3 + c2 * x * x + c1 * x + c0) % p for x in range(p)):
                    return (c0, c1, c2)
    raise AssertionError("no irreducible cubic found")


def extension_mat_mul(
    field: CubicField, left: tuple[int, ...], right: tuple[int, ...]
) -> tuple[int, ...]:
    a, b, c, d = left
    e, f, g, h = right
    return (
        field.add(field.mul(a, e), field.mul(b, g)),
        field.add(field.mul(a, f), field.mul(b, h)),
        field.add(field.mul(c, e), field.mul(d, g)),
        field.add(field.mul(c, f), field.mul(d, h)),
    )


def check_cubic_extension(p: int) -> dict[str, object]:
    """Exhaust the full-degree mirror parameters in a theorem extension."""
    assert p > 5 and p % 40 in ELIGIBLE_PRIME_RESIDUES
    field = CubicField(p, irreducible_cubic(p))
    one = field.constant(1)
    minus_one = field.constant(-1)
    assert field.character(minus_one) == -1
    assert field.character(field.constant(5)) == -1
    squares = {field.mul(value, value) for value in range(field.q)}
    assert len(squares) == (field.q + 1) // 2

    admissible = []
    character_crosschecks = 0
    trace_checks = 0
    for b in range(field.q):
        if field.in_prime_field(b):
            continue
        shifted = field.sub(b, one)
        mirror_test = field.add(field.mul(shifted, shifted), field.constant(4))
        character = field.character(mirror_test)
        assert mirror_test != 0
        assert (mirror_test in squares) == (character == 1)
        character_crosschecks += 1
        if character != -1:
            continue
        admissible.append(b)

        denominator = field.sub(one, b)
        trace_invariant = field.inverse(denominator)
        assert not field.in_prime_field(trace_invariant)
        assert field.sub(one, field.inverse(trace_invariant)) == b
        trace_checks += 1

    expected = (field.q - p) // 2
    assert len(admissible) == expected

    identity = (one, 0, 0, one)
    coordinate_samples = admissible[:8]
    for b in coordinate_samples:
        gens = [
            (one, 0, one, minus_one),
            (one, one, 0, minus_one),
            (one, minus_one, b, minus_one),
            (one, b, minus_one, minus_one),
        ]
        word = identity
        for index in (2, 0, 2, 0, 1, 0):
            word = extension_mat_mul(field, word, gens[index])
        expected_word = (
            field.sub(field.mul(field.constant(2), b), field.constant(3)),
            field.sub(field.constant(2), b),
            field.sub(b, field.constant(2)),
            one,
        )
        assert word == expected_word

        pair_product = extension_mat_mul(field, gens[2], gens[0])
        trace = field.add(pair_product[0], pair_product[3])
        determinant = field.sub(
            field.mul(pair_product[0], pair_product[3]),
            field.mul(pair_product[1], pair_product[2]),
        )
        assert field.mul(field.mul(trace, trace), field.inverse(determinant)) == field.inverse(
            field.sub(one, b)
        )

    return {
        "admissible_parameter_count": len(admissible),
        "character_square_membership_crosschecks": character_crosschecks,
        "coordinate_identity_samples": [
            list(field.coefficients(value)) for value in coordinate_samples
        ],
        "extension_degree": 3,
        "full_degree_element_count": field.q - p,
        "modulus_coefficients_low_to_high": list(field.modulus) + [1],
        "p": p,
        "parameter_count_formula": "(p^3-p)/2",
        "q": field.q,
        "square_set_size": len(squares),
        "trace_definition_field_checks": trace_checks,
    }


def act(m: tuple[int, ...], t: int, p: int) -> int:
    """Act on P^1(F_p), representing infinity by p."""
    a, b, c, d = (x % p for x in m)
    if t == p:
        return p if c == 0 else a * pow(c, p - 2, p) % p
    den = (c * t + d) % p
    return p if den == 0 else (a * t + b) * pow(den, p - 2, p) % p


def conic_point(t: int, p: int) -> tuple[int, int, int]:
    if t == p:
        return (1, 0, 0)
    if t == 0:
        return (0, 1, 0)
    return (t, pow(t, p - 2, p), 1)


def det3(points: tuple[tuple[int, int, int], ...], p: int) -> int:
    a, b, c = points
    return (a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])) % p


def sigma_matrix(r: int, c: int, p: int) -> tuple[int, ...]:
    return (1, -r % p, c % p, -1 % p)


def check_parameter(p: int, b: int, enumerate_group: bool) -> dict[str, object]:
    assert b not in (0, 1, 2, p - 1)
    assert legendre((b - 1) ** 2 + 4, p) == -1

    centre_pairs = centres_for(b)
    centres = tuple((r % p, c % p, 1) for r, c in centre_pairs)
    opening = ((1, 0, 0), (0, 1, 0))
    cap_dets = [det3(triple, p) for triple in combinations(opening + centres, 3)]
    assert all(cap_dets)

    gens = [sigma_matrix(r, c, p) for r, c in centre_pairs]
    conjugate_indices = []
    tau_perm = tuple(act(TAU, t, p) for t in range(p + 1))
    assert all(tau_perm[tau_perm[t]] == t for t in range(p + 1))
    assert all(tau_perm[t] != t for t in range(p + 1))
    for g in gens:
        conjugate = tuple(tau_perm[act(g, tau_perm[t], p)] for t in range(p + 1))
        conjugate_indices.append(next(i for i, h in enumerate(gens)
                                      if conjugate == tuple(act(h, t, p) for t in range(p + 1))))

    dead: set[int] = set()
    for u, v in combinations(centres, 2):
        for t in range(p + 1):
            if det3((u, v, conic_point(t, p)), p) == 0:
                dead.add(t)
    live = set(range(p + 1)) - dead
    assert {tau_perm[t] for t in dead} == dead
    adjacency = {t: {act(g, t, p) for g in gens} - {t} for t in live}
    adjacency = {t: (neighbors & live) for t, neighbors in adjacency.items()}
    assert all(tau_perm[t] in live and tau_perm[t] not in adjacency[t] for t in live)
    assert all({tau_perm[u] for u in adjacency[t]} == adjacency[tau_perm[t]] for t in live)

    word = [2, 0, 2, 0, 1, 0]
    unipotent = (1, 0, 0, 1)
    for i in word:
        unipotent = mat_mul(unipotent, gens[i], p)
    expected_unipotent = (2 * b - 3, 2 - b, b - 2, 1)
    assert unipotent == tuple(x % p for x in expected_unipotent)
    ma, mb, mc, md = unipotent
    assert (ma + md) ** 2 % p == 4 * (ma * md - mb * mc) % p
    assert mat_normalize(unipotent, p) != (1, 0, 0, 1)

    expected = p * (p * p - 1)
    return {
        "b": b,
        "cap_triples_checked": len(cap_dets),
        "conjugation_on_generators": conjugate_indices,
        "dead_conic_vertices": len(dead),
        "generated_group_order": projective_group_order(gens, p) if enumerate_group else None,
        "live_conic_vertices": len(live),
        "mirror_pairs": len(live) // 2,
        "pgl2_order": expected,
        "unipotent_word": word,
    }


def check_case(p: int) -> dict[str, object]:
    assert p > 5 and p % 40 in ELIGIBLE_PRIME_RESIDUES
    assert [legendre(x, p) for x in (-1, 5)] == [-1, -1]
    parameters = tuple(
        b for b in range(p)
        if b not in (0, 1, 2, p - 1) and legendre((b - 1) ** 2 + 4, p) == -1
    )
    eight_character = legendre(8, p)
    expected_parameter_count = (p - 5) // 2 if eight_character == -1 else (p - 3) // 2
    assert len(parameters) == expected_parameter_count
    enumerated_parameter = parameters[0]
    rows = [
        check_parameter(p, b, enumerate_group=b == enumerated_parameter) for b in parameters
    ]
    sample = next(row for row in rows if row["b"] == enumerated_parameter)
    assert sample["generated_group_order"] == sample["pgl2_order"]
    return {
        "admissible_parameter_count": len(parameters),
        "admissible_parameters": list(parameters),
        "cap_triples_checked": sum(int(row["cap_triples_checked"]) for row in rows),
        "dead_vertex_histogram": {
            str(key): value for key, value in sorted(Counter(
                int(row["dead_conic_vertices"]) for row in rows
            ).items())
        },
        "eight_character": eight_character,
        "enumerated_parameter": enumerated_parameter,
        "generated_group_order": sample["generated_group_order"],
        "live_vertex_histogram": {
            str(key): value for key, value in sorted(Counter(
                int(row["live_conic_vertices"]) for row in rows
            ).items())
        },
        "mirror_checks": len(parameters),
        "nonsquare_tests": {"-1": -1, "5": -1},
        "p": p,
        "parameter_count_formula": (
            "(p-5)/2" if eight_character == -1 else "(p-3)/2"
        ),
        "pgl2_order": sample["pgl2_order"],
        "unipotent_checks": len(parameters),
        "unipotent_word": sample["unipotent_word"],
    }


def generate() -> dict[str, object]:
    primes = [
        p for p in range(7, 111)
        if is_prime(p) and p % 40 in ELIGIBLE_PRIME_RESIDUES
    ]
    return {
        "cases": [check_case(p) for p in primes],
        "extension_cases": [check_cubic_extension(p) for p in (7, 43)],
        "family": {
            "centres": "(0,1), (-1,0), (1,b), (-b,-1)",
            "extension_condition": "q=p^e with odd e and F_p(b)=F_q",
            "parameter_condition": "(b-1)^2+4 nonsquare, plus base-field exclusions",
            "parameter_count": (
                "for e=1, (p-5)/2 in residues {3,27} and (p-3)/2 in residues "
                "{7,23}; half the full-degree elements for e>1"
            ),
            "prime_condition": "p > 5 and p mod 40 in {3,7,23,27}; e odd",
            "residual_outcome": "P by fixed-point-free nonadjacent tau pairing",
            "tau": "t -> -1/t",
            "trace_definition_field_invariant": "tr(A2*A0)^2/det(A2*A0)=1/(1-b)",
        },
        "schema": "c294-full-pgl-mirror-family-v4",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.check and args.write:
        parser.error("choose at most one of --check and --write")
    result = generate()
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        tracked = json.loads(Path(__file__).with_suffix(".json").read_text())
        if tracked != result:
            raise SystemExit("tracked JSON content differs from deterministic regeneration")
        parameters = sum(int(case["admissible_parameter_count"]) for case in result["cases"])
        extension_parameters = sum(
            int(case["admissible_parameter_count"]) for case in result["extension_cases"]
        )
        print(
            f"OK: {len(result['cases'])} prime cases, {parameters} prime parameters, "
            f"{extension_parameters} extension parameters; tracked JSON matches"
        )
    elif args.write:
        Path(__file__).with_suffix(".json").write_text(rendered)
        print(f"WROTE {Path(__file__).with_suffix('.json')}")
    else:
        print(rendered, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
