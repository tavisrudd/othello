#!/usr/bin/env python3
"""Audit and benchmark the C305 normalized ``GF(512)`` collision sweep.

The checker has two deliberately separate jobs.

* It proves, in exact sparse ``GF(2)`` arithmetic, the weighted ``p=1``
  correspondence for the committed C210 collision cover and its ``H,J``
  reconstruction.  It also certifies the exact ``w -> w+1`` and layer-swap
  involutions.
* It runs a deterministic shard over the correctly counted normalized
  coefficient space.  Every reported collision is reconstructed with the
  committed ``H,J`` formula and independently checked in the quadratic
  extension by the original three-point incidence equation.

The default output is canonical and timing-free.  ``--benchmark`` adds local
wall-clock throughput measurements; those measurements are not part of the
canonical certificate.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import time
from pathlib import Path

from analyze_c210_a_nonzero_b_zero import (
    pulled_quadratics,
    trace_one_images,
)
from analyze_c210_a_zero_factorization_strata import TVARS, TargetRing


Q = 512
MODULUS = (1 << 9) | (1 << 4) | 1


def raw_mul(left: int, right: int) -> int:
    out = 0
    while right:
        if right & 1:
            out ^= left
        right >>= 1
        left <<= 1
        if left & (1 << 9):
            left ^= MODULUS
    return out


EXP = [0] * (Q - 1)
LOG = [-1] * Q
value = 1
for exponent in range(Q - 1):
    EXP[exponent] = value
    LOG[value] = exponent
    value = raw_mul(value, 2)
assert value == 1 and len(set(EXP)) == Q - 1


def mul(left: int, right: int) -> int:
    if left == 0 or right == 0:
        return 0
    return EXP[(LOG[left] + LOG[right]) % (Q - 1)]


SQUARE = [mul(x, x) for x in range(Q)]
INV = [0] + [EXP[(-LOG[x]) % (Q - 1)] for x in range(1, Q)]


def power(x: int, exponent: int) -> int:
    if exponent == 0:
        return 1
    if x == 0:
        return 0
    return EXP[(LOG[x] * exponent) % (Q - 1)]


def absolute_trace(x: int) -> int:
    out = 0
    term = x
    for _ in range(9):
        out ^= term
        term = SQUARE[term]
    assert out in (0, 1)
    return out


def polynomial_substitute(
    ring: TargetRing,
    polynomial: set[tuple[int, ...]],
    name: str,
    replacement: set[tuple[int, ...]],
) -> set[tuple[int, ...]]:
    """Exact substitution in the sparse target ring."""
    index = TVARS.index(name)
    out = ring.zero
    for monomial in polynomial:
        term = ring.one
        for position, exponent in enumerate(monomial):
            if exponent:
                factor = replacement if position == index else ring.v[TVARS[position]]
                term = ring.mul(term, ring.power(factor, exponent))
        out = ring.add(out, term)
    return out


def weighted_degrees(
    polynomial: set[tuple[int, ...]], weights: dict[str, int]
) -> list[int]:
    return sorted({
        sum(monomial[TVARS.index(name)] * weight for name, weight in weights.items())
        for monomial in polynomial
    })


def variable_coefficient(
    polynomial: set[tuple[int, ...]], name: str, exponent: int
) -> set[tuple[int, ...]]:
    index = TVARS.index(name)
    out: set[tuple[int, ...]] = set()
    for monomial in polynomial:
        if monomial[index] == exponent:
            reduced = list(monomial)
            reduced[index] = 0
            out ^= {tuple(reduced)}
    return out


def symbolic_certificate() -> dict[str, object]:
    ring, coefficients = pulled_quadratics()
    A, B, C, D, E, F = coefficients
    H = ring.add(ring.mul(D, B), ring.mul(A, E))
    J = ring.add(ring.mul(D, C), ring.mul(A, F))
    R = ring.add(
        ring.mul(ring.mul(C, C), ring.mul(D, D)),
        ring.product((B, C, D, E)),
        ring.product((ring.mul(B, B), D, F)),
        ring.product((A, C, ring.mul(E, E))),
        ring.product((A, B, E, F)),
        ring.mul(ring.mul(A, A), ring.mul(F, F)),
    )

    weights = {
        "u": 1,
        "t": 1,
        "e": 1,
        "delta": 1,
        "a": 0,
        "b": 1,
        "p": 1,
        "w": 0,
        "h0": 2,
        "h1": 2,
    }
    expected = {
        "A": 1,
        "B": 2,
        "C": 3,
        "D": 1,
        "E": 2,
        "F": 3,
        "H": 3,
        "J": 4,
        "R": 8,
    }
    actual = {
        name: weighted_degrees(poly, weights)
        for name, poly in zip(
            ("A", "B", "C", "D", "E", "F", "H", "J", "R"),
            (*coefficients, H, J, R),
        )
    }
    assert actual == {name: [degree] for name, degree in expected.items()}
    parameter_degrees = {
        name: max(monomial[TVARS.index(name)] for monomial in R)
        for name in ("e", "h0", "h1")
    }
    assert parameter_degrees == {"e": 4, "h0": 2, "h1": 2}

    # The trace parameter occurs only through theta=w^2+w+1.
    w_conjugate = ring.add(ring.v["w"], ring.one)
    assert polynomial_substitute(ring, R, "w", w_conjugate) == R
    assert polynomial_substitute(ring, H, "w", w_conjugate) == H
    assert polynomial_substitute(ring, J, "w", w_conjugate) == J

    # Reversing the two repair layers sends the new left parameter to r+u.
    images = trace_one_images(ring)
    orientation = (
        ("h0", ring.add(ring.v["h0"], images["k0"])),
        ("h1", ring.add(ring.v["h1"], images["k1"])),
        ("e", ring.add(ring.v["e"], ring.v["delta"])),
    )

    def orient(poly: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
        for name, replacement in orientation:
            poly = polynomial_substitute(ring, poly, name, replacement)
        return poly

    assert orient(R) == R
    assert orient(H) == H
    assert orient(J) == ring.add(J, ring.mul(ring.v["u"], H))

    # Before taking the resultant, the two equations are an invertible affine
    # linear system in the two free heights.  This is the algebraic route left
    # by the failed outer-parameter sweep.
    assert all(
        variable_coefficient(poly, height, 1) == ring.zero
        for poly in (A, B, D, E)
        for height in ("h0", "h1")
    )
    assert variable_coefficient(C, "h0", 1) == ring.v["u"]
    assert variable_coefficient(C, "h1", 1) == ring.v["delta"]
    assert variable_coefficient(F, "h0", 1) == ring.v["delta"]
    assert variable_coefficient(F, "h1", 1) == ring.add(
        ring.v["delta"], ring.v["u"]
    )
    assert all(
        variable_coefficient(poly, height, 2) == ring.zero
        for poly in coefficients
        for height in ("h0", "h1")
    )
    height_determinant = ring.add(
        ring.mul(ring.v["u"], ring.add(ring.v["delta"], ring.v["u"])),
        ring.mul(ring.v["delta"], ring.v["delta"]),
    )
    expected_height_determinant = ring.add(
        ring.mul(ring.v["u"], ring.v["u"]),
        ring.mul(ring.v["u"], ring.v["delta"]),
        ring.mul(ring.v["delta"], ring.v["delta"]),
    )
    assert height_determinant == expected_height_determinant

    normalized = (Q - 1) ** 3 * Q**4
    # Exact union of the three already-closed factorization branches after p=1.
    factorization_union = (
        2 * (Q - 1) ** 3 * Q**2
        + 2 * (Q - 1) ** 2 * Q**2
        - 4 * (Q - 1) ** 2 * Q
    )
    off_divisor = normalized - factorization_union
    maximum_certified_quotient = (Q // 2) * 2 * 2 * 9
    orbit_lower_bound = (
        off_divisor + maximum_certified_quotient - 1
    ) // maximum_certified_quotient

    return {
        "weighted_scaling": {
            "action": (
                "(u,t,e,delta,b,p,h0,h1)->"
                "(lambda*u,lambda*t,lambda*e,lambda*delta,lambda*b,"
                "lambda*p,lambda^2*h0,lambda^2*h1); a,w fixed"
            ),
            "degrees": expected,
            "reconstruction": "H->lambda^3*H, J->lambda^4*J, r=J/H->lambda*r",
            "lossless_chart": "p=1 via lambda=p^-1 on p!=0",
        },
        "exact_quotients": {
            "trace_parameter": "w->w+1; free involution",
            "layer_orientation": (
                "(e,h0,h1,r)->(e+delta,h0+k0,h1+k1,r+u); free involution"
            ),
            "subfield_translation": {
                "action": "h1->h1+a*d^2+b*d",
                "kernel_size_on_a*b_nonzero": 2,
                "orbit_size": Q // 2,
                "representatives": "h1 in {0,b^2/a}, indexed by Tr(a*h1/b^2)",
            },
            "frobenius": "simultaneous x->x^(2^j), j=0,...,8; orbit size at most 9",
            "maximum_combined_orbit_size_used_for_lower_bound": maximum_certified_quotient,
        },
        "scope_counts": {
            "unnormalized_a_b_delta_p_nonzero": (Q - 1) ** 4 * Q**4,
            "normalized_p_one": normalized,
            "normalized_factorization_union_already_closed": factorization_union,
            "normalized_off_factorization_divisor": off_divisor,
            "off_divisor_representative_lower_bound_after_all_certified_quotients": orbit_lower_bound,
            "advertised_q4_count": Q**4,
            "omitted_free_parameters_in_q4_count": ["e", "h0", "h1"],
        },
        "term_counts": {"R": len(R), "H": len(H), "J": len(J)},
        "nonquotiented_parameter_degrees_in_R": parameter_degrees,
        "height_plane_reduction": {
            "coefficient_matrix": [["u", "delta"], ["delta", "delta+u"]],
            "determinant": "Q(u)=u^2+u*delta+delta^2",
            "odd_tower_invertibility": (
                "Q has no rational zero because Q/delta^2=z^2+z+1 and GF(4) "
                "is absent"
            ),
            "next_exact_problem": (
                "for each fixed skeleton (e,delta,a,b,w), prove that the genuine "
                "triple-to-height map covers every (h0,h1), modulo the certified "
                "translation twist"
            ),
        },
    }


def pair_mul(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    x0, x1 = left
    y0, y1 = right
    cross = mul(x1, y1)
    return mul(x0, y0) ^ cross, mul(x0, y1) ^ mul(x1, y0) ^ cross


def pair_add(*values: tuple[int, int]) -> tuple[int, int]:
    first = second = 0
    for x0, x1 in values:
        first ^= x0
        second ^= x1
    return first, second


def direct_collinearity(
    left_x: tuple[int, int],
    left_h: tuple[int, int],
    right_x: tuple[int, int],
    right_h: tuple[int, int],
    seed_x: tuple[int, int],
) -> bool:
    difference = pair_add(left_x, right_x)
    seed_left = pair_add(seed_x, left_x)
    seed_right = pair_add(seed_x, right_x)
    value = pair_add(
        pair_mul(left_h, difference),
        pair_mul(seed_left, pair_add(right_h, left_h)),
        pair_mul(pair_mul(difference, seed_left), seed_right),
    )
    return value == (0, 0)


def branch_memberships(
    e: int, delta: int, a: int, b: int, w: int, h0: int
) -> tuple[bool, bool, bool]:
    theta = SQUARE[w] ^ w ^ 1
    branch1 = e == 0 and h0 == 0
    branch2_height = theta ^ SQUARE[e] ^ mul(e, b) ^ mul(e, a)
    branch2 = e == delta and h0 == branch2_height
    a2 = SQUARE[a]
    branch3_height = (
        mul(SQUARE[e], a2)
        ^ mul(e, a2)
        ^ mul(e, a)
        ^ SQUARE[e]
        ^ mul(e, b)
        ^ e
    )
    branch3 = delta == 1 and w in (0, 1) and h0 == branch3_height
    return branch1, branch2, branch3


def configuration_constants(
    e: int,
    delta: int,
    a: int,
    b: int,
    w: int,
    h0: int,
    h1: int,
) -> dict[str, int]:
    theta = SQUARE[w] ^ w ^ 1
    N = SQUARE[a] ^ a ^ 1
    delta2 = SQUARE[delta]
    T0 = theta ^ mul(a, delta)  # p=1
    L = mul(delta, b) ^ delta2
    k0 = T0 ^ L
    k1 = mul(delta, N) ^ mul(a, T0) ^ L
    return {
        "e": e,
        "delta": delta,
        "a": a,
        "b": b,
        "w": w,
        "h0": h0,
        "h1": h1,
        "N": N,
        "delta2": delta2,
        "T0": T0,
        "k0": k0,
        "k1": k1,
    }


def candidate_data(
    constants: dict[str, int], u: int, t: int
) -> tuple[bool, tuple[int, int, int, int, int, int, int, int]]:
    e = constants["e"]
    delta = constants["delta"]
    a = constants["a"]
    b = constants["b"]
    h0 = constants["h0"]
    h1 = constants["h1"]
    k0 = constants["k0"]
    k1 = constants["k1"]
    delta2 = constants["delta2"]
    u2 = SQUARE[u]
    e2 = SQUARE[e]

    A = u ^ mul(a, delta)
    B = constants["T0"] ^ u2
    D = delta ^ mul(a, delta) ^ mul(a, u)
    E = k1 ^ mul(delta, b) ^ delta2 ^ mul(a, u2)
    H = mul(D, B) ^ mul(A, E)
    assert H != 0

    C0 = (
        mul(e, k1)
        ^ mul(delta, h1)
        ^ mul(u, h0)
        ^ mul(e2, delta)
        ^ mul(e, delta2)
        ^ mul(mul(u, e), b)
        ^ mul(u, e2)
        ^ mul(mul(u2, e), a)
    )
    C1 = k0 ^ delta2 ^ u2
    C = C0 ^ mul(t, C1) ^ mul(SQUARE[t], u)

    F0 = (
        mul(e, k0 ^ k1)
        ^ mul(delta, h0 ^ h1)
        ^ mul(u, h1)
        ^ mul(mul(u, e), b)
        ^ mul(u, e2)
        ^ mul(u2, e)
        ^ mul(mul(u2, e), a)
    )
    F1 = k1 ^ delta2 ^ mul(u, b) ^ mul(u2, a)
    F = F0 ^ mul(t, F1) ^ mul(SQUARE[t], delta)

    J = mul(D, C) ^ mul(A, F)
    H2 = SQUARE[H]
    HJ = mul(H, J)
    if A:
        zero_test = mul(A, SQUARE[J]) ^ mul(B, HJ) ^ mul(C, H2)
    else:
        assert D
        zero_test = mul(D, SQUARE[J]) ^ mul(E, HJ) ^ mul(F, H2)
    return zero_test == 0, (A, B, C, D, E, F, H, J)


def verify_witness(
    constants: dict[str, int], u: int, t: int, data: tuple[int, ...]
) -> int:
    A, B, C, D, E, F, H, J = data
    r = mul(J, INV[H])
    r2 = SQUARE[r]
    assert mul(A, r2) ^ mul(B, r) ^ C == 0
    assert mul(D, r2) ^ mul(E, r) ^ F == 0

    e = constants["e"]
    delta = constants["delta"]
    a = constants["a"]
    b = constants["b"]
    h0 = constants["h0"]
    h1 = constants["h1"]
    k0 = constants["k0"]
    k1 = constants["k1"]
    s = r ^ u
    left_x = (r, e)
    right_x = (s, e ^ delta)
    seed_x = (t, 0)
    left_h = (h0, mul(a, r2) ^ mul(b, r) ^ h1)
    right_h = (
        h0 ^ k0,
        mul(a, SQUARE[s]) ^ mul(b, s) ^ h1 ^ k1,
    )
    assert direct_collinearity(left_x, left_h, right_x, right_h, seed_x)
    points = {
        (left_x, left_h),
        (right_x, right_h),
        (seed_x, (0, 0)),
    }
    assert len(points) == 3
    return r


def mix64(value: int) -> int:
    value = (value + 0x9E3779B97F4A7C15) & ((1 << 64) - 1)
    value = ((value ^ (value >> 30)) * 0xBF58476D1CE4E5B9) & ((1 << 64) - 1)
    value = ((value ^ (value >> 27)) * 0x94D049BB133111EB) & ((1 << 64) - 1)
    return value ^ (value >> 31)


def shard_configuration(counter: int) -> tuple[int, ...]:
    """A fixed counter-permuted shard; there is no random state or seed."""
    words = [mix64(counter + 0x100000001B3 * offset) for offset in range(6)]
    delta = EXP[words[0] % (Q - 1)]
    a = EXP[words[1] % (Q - 1)]
    b = EXP[words[2] % (Q - 1)]
    e = words[3] & (Q - 1)
    w = words[4] & (Q - 1)
    h0 = words[5] & (Q - 1)
    twist = counter & 1
    h1 = 0 if twist == 0 else mul(SQUARE[b], INV[a])
    return e, delta, a, b, w, h0, h1, twist


def run_shard(configurations: int) -> dict[str, object]:
    checked = 0
    counters_examined = 0
    candidate_pairs = 0
    maximum_search = 0
    digest = hashlib.sha256()
    first_witness = None
    while checked < configurations:
        row = shard_configuration(counters_examined)
        counters_examined += 1
        e, delta, a, b, w, h0, h1, twist = row
        if any(branch_memberships(e, delta, a, b, w, h0)):
            continue
        constants = configuration_constants(e, delta, a, b, w, h0, h1)
        found = None
        examined_here = 0
        for u in range(Q):
            for t in range(Q):
                examined_here += 1
                is_collision, data = candidate_data(constants, u, t)
                if is_collision:
                    r = verify_witness(constants, u, t, data)
                    found = (u, t, r)
                    break
            if found is not None:
                break
        assert found is not None
        candidate_pairs += examined_here
        maximum_search = max(maximum_search, examined_here)
        record = (*row, *found, examined_here)
        digest.update(b"".join(value.to_bytes(4, "big") for value in record))
        if first_witness is None:
            first_witness = {
                "configuration_e_delta_a_b_w_h0_h1_twist": list(row),
                "collision_u_t_r": list(found),
                "candidate_pairs_examined": examined_here,
            }
        checked += 1
    return {
        "construction": "fixed SplitMix64 counter permutation; no random state",
        "normalized_off_divisor_configurations_checked": checked,
        "raw_counters_examined": counters_examined,
        "collision_witnesses": checked,
        "candidate_pairs_examined": candidate_pairs,
        "maximum_candidate_pairs_for_one_configuration": maximum_search,
        "average_candidate_pairs_per_configuration": candidate_pairs / checked,
        "all_witnesses_HJ_reconstructed": True,
        "all_witnesses_directly_incident_and_genuine": True,
        "first_witness": first_witness,
        "witness_digest_sha256": digest.hexdigest(),
    }


def canonical_result(configurations: int) -> dict[str, object]:
    assert absolute_trace(1) == 1
    certificate = symbolic_certificate()
    shard = run_shard(configurations)
    return {
        "field": {
            "name": "GF(512)",
            "polynomial_basis_modulus": "x^9+x^4+1",
            "primitive_element_integer": 2,
            "absolute_trace_of_one": 1,
        },
        "symbolic_certificate": certificate,
        "deterministic_shard": shard,
        "conclusion": (
            "the p=1 chart is lossless, but it has seven free coefficient parameters; "
            "the q^4 estimate omitted e,h0,h1, and the full exact sweep is infeasible "
            "even after every certified quotient"
        ),
    }


def render(result: dict[str, object]) -> str:
    return json.dumps(result, sort_keys=True, separators=(",", ":")) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--configurations", type=int, default=512)
    parser.add_argument("--benchmark", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    assert args.configurations > 0
    started = time.perf_counter()
    output = render(canonical_result(args.configurations))
    elapsed = time.perf_counter() - started
    if args.check:
        assert args.configurations == 512, "--check uses the canonical 512-row shard"
        expected = Path(__file__).with_name(
            "analyze_c305_q512_generic_closure_output.txt"
        ).read_text()
        if output != expected:
            raise SystemExit("canonical output mismatch")
        print(json.dumps({"check": "ok", "bytes": len(output.encode())}, sort_keys=True))
    elif args.benchmark:
        result = json.loads(output)
        shard = result["deterministic_shard"]
        print(json.dumps({
            "configurations": args.configurations,
            "candidate_pairs": shard["candidate_pairs_examined"],
            "elapsed_seconds": elapsed,
            "configurations_per_second": args.configurations / elapsed,
            "candidate_pairs_per_second": shard["candidate_pairs_examined"] / elapsed,
            "witness_digest_sha256": shard["witness_digest_sha256"],
        }, sort_keys=True))
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
