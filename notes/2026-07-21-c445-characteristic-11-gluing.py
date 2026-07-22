#!/usr/bin/env python3
"""Generate/check the C445 characteristic-11 gluing certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import deque
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
STEM = ROOT / "notes" / "2026-07-21-c445-characteristic-11-gluing"
OUTPUT = STEM.with_suffix(".json")
MANIFEST = STEM.with_suffix(".sha256")
P = 11
INF = 11

INPUT_STEMS = (
    "2026-07-21-c442-antipodal-singleton-reduction",
    "2026-07-21-c458-golden-sheet-frame-freeze",
    "2026-07-21-c443-commuting-with-reduction",
    "2026-07-21-c461-four-companion-weight-line",
    "2026-07-21-c460-golden-fregier-cloud-bridge",
    "2026-07-21-c444-silver-fusion",
    "2026-07-21-c457-quaternion-order-reduction",
)

BASE = ((0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, INF))
JMATE = ((0, 10), (1, INF), (2, 7), (3, 5), (4, 8), (6, 9))
TRIANGLE = ((0, 0, 1), (0, 1, 0), (1, 0, 0))


def digest(path: Path) -> dict[str, int | str]:
    data = path.read_bytes()
    return {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def canonical_pair(a: int, b: int) -> tuple[int, int]:
    return (a, b) if a < b else (b, a)


def endpoint(value: int | str) -> int:
    return INF if value == "inf" else int(value)


def canonical_matching(pairs: object) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(canonical_pair(endpoint(a), endpoint(b)) for a, b in pairs))  # type: ignore[union-attr]


def normalize_matrix(a: int, b: int, c: int, d: int) -> tuple[int, int, int, int]:
    values = [a % P, b % P, c % P, d % P]
    first = next(x for x in values if x)
    inv = pow(first, -1, P)
    return tuple((x * inv) % P for x in values)  # type: ignore[return-value]


def pgl_matrices() -> tuple[tuple[int, int, int, int], ...]:
    mats = {
        normalize_matrix(a, b, c, d)
        for a in range(P)
        for b in range(P)
        for c in range(P)
        for d in range(P)
        if (a * d - b * c) % P
    }
    assert len(mats) == 1320
    return tuple(sorted(mats))


def act_point(g: tuple[int, int, int, int], x: int) -> int:
    a, b, c, d = g
    if x == INF:
        return INF if c == 0 else (a * pow(c, -1, P)) % P
    den = (c * x + d) % P
    return INF if den == 0 else ((a * x + b) * pow(den, -1, P)) % P


def permutation(g: tuple[int, int, int, int]) -> tuple[int, ...]:
    return tuple(act_point(g, x) for x in range(P + 1))


def compose(p: tuple[int, ...], q: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(p[q[x]] for x in range(P + 1))


def inverse(p: tuple[int, ...]) -> tuple[int, ...]:
    out = [0] * len(p)
    for x, y in enumerate(p):
        out[y] = x
    return tuple(out)


def act_matching(p: tuple[int, ...], matching: tuple[tuple[int, int], ...]) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(canonical_pair(p[a], p[b]) for a, b in matching))


def determinant_is_square(g: tuple[int, int, int, int]) -> bool:
    a, b, c, d = g
    det = (a * d - b * c) % P
    return pow(det, (P - 1) // 2, P) == 1


def generated_group(generators: tuple[tuple[int, ...], ...]) -> set[tuple[int, ...]]:
    identity = tuple(range(P + 1))
    generators = generators + tuple(inverse(g) for g in generators)
    seen = {identity}
    todo = deque([identity])
    while todo:
        g = todo.popleft()
        for h in generators:
            gh = compose(g, h)
            if gh not in seen:
                seen.add(gh)
                todo.append(gh)
    return seen


def reflection(v: tuple[int, int, int]) -> tuple[tuple[int, ...], ...]:
    q = sum(x * x for x in v)
    return tuple(
        tuple((1 if i == j else 0) - 2 * v[i] * v[j] // q for j in range(3))
        for i in range(3)
    )


def matmul(a: tuple[tuple[int, ...], ...], b: tuple[tuple[int, ...], ...]) -> tuple[tuple[int, ...], ...]:
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(3)) for j in range(3)) for i in range(3))


def build_certificate() -> dict[str, object]:
    inputs: dict[str, object] = {}
    loaded: dict[str, dict[str, object]] = {}
    for stem in INPUT_STEMS:
        report = ROOT / "notes" / f"{stem}.md"
        certificate = ROOT / "notes" / f"{stem}.json"
        inputs[stem] = {"report": digest(report), "certificate": digest(certificate)}
        loaded[stem] = json.loads(certificate.read_text())

    c442 = loaded[INPUT_STEMS[0]]
    c458 = loaded[INPUT_STEMS[1]]
    c443 = loaded[INPUT_STEMS[2]]
    c461 = loaded[INPUT_STEMS[3]]
    c460 = loaded[INPUT_STEMS[4]]
    c444 = loaded[INPUT_STEMS[5]]
    c457 = loaded[INPUT_STEMS[6]]

    frozen_base = canonical_matching(
        c458["golden_sheet_frame"]["polar_pair_matching"]["reduction_at_pi_phi_to_8"]["matching"]  # type: ignore[index]
    )
    frozen_jmate = canonical_matching(
        c458["golden_sheet_frame"]["polar_pair_matching"]["reduction_at_pibar_phi_to_4"]["matching"]  # type: ignore[index]
    )
    assert frozen_base == BASE and frozen_jmate == JMATE
    assert c458["golden_sheet_frame"]["six_arcs_disjoint_over_Q_phi"] is True  # type: ignore[index]
    assert c458["bridge"]["char11_collision"]["six_arcs_disjoint_and_reduce_onto_one_P1"] is True  # type: ignore[index]
    assert c458["bridge"]["rational_transporter_Rz"]["spinor_norm"] == 2  # type: ignore[index]
    assert c460["golden_pair"]["perpendicularity_comparison"]["equals_common_triangle"] is True  # type: ignore[index]
    assert tuple(tuple(x) for x in c460["golden_pair"]["common_triangle"]) == TRIANGLE  # type: ignore[index]
    assert c460["golden_pair"]["triangle_setwise_stabilizer"]["order"] == 24  # type: ignore[index]
    assert c460["golden_pair"]["triangle_setwise_stabilizer"]["orbit_on_golden_matchings"] == 2  # type: ignore[index]
    assert c460["golden_pair"]["common_matching_stabilizer"]["order"] == 12  # type: ignore[index]
    assert c443["blocker"]["observed_one_factorizing_size_ten_orbits"] == 4  # type: ignore[index]
    assert c461["necessary_lower_moment_test"]["kernel_dimension"] == 0  # type: ignore[index]
    assert c444["verdict"].startswith("GREEN")  # type: ignore[union-attr]
    assert c457["icosian_order"]["reduced_trace_discriminant"] == [1, 0]  # type: ignore[index]
    assert all(item["order_reduction_equals"] == "M2(F_11)" for item in c457["icosian_order"]["reductions"])  # type: ignore[index]
    assert all(item["comparison_gives_exact_full_stabilizer_equality"] for item in c457["icosian_order"]["reductions"])  # type: ignore[index]
    assert c442["clause_ii_singleton_identification"]["golden_six_arc_frame_reduced"]["a5_8_a5_4_intersection_order"] == 12  # type: ignore[index]

    matrices = pgl_matrices()
    matrix_perms = {g: permutation(g) for g in matrices}
    pgl = set(matrix_perms.values())
    psl = {matrix_perms[g] for g in matrices if determinant_is_square(g)}
    h_base = {g for g in pgl if act_matching(g, BASE) == BASE}
    h_jmate = {g for g in pgl if act_matching(g, JMATE) == JMATE}
    closure = generated_group(tuple(sorted(h_base | h_jmate)))
    pgl_orbit = {act_matching(g, BASE) for g in pgl}
    psl_base_orbit = {act_matching(g, BASE) for g in psl}
    psl_jmate_orbit = {act_matching(g, JMATE) for g in psl}

    transporter_matrix = normalize_matrix(1, 10, 1, 1)
    transporter = matrix_perms[transporter_matrix]
    assert act_matching(transporter, BASE) == JMATE
    assert len(pgl) == 1320 and len(psl) == 660
    assert len(h_base) == len(h_jmate) == 60
    assert h_base <= psl and h_jmate <= psl
    assert len(h_base & h_jmate) == 12
    assert closure == psl
    assert len(pgl_orbit) == 22
    assert len(psl_base_orbit) == len(psl_jmate_orbit) == 11
    assert psl_base_orbit.isdisjoint(psl_jmate_orbit)
    assert pgl_orbit == psl_base_orbit | psl_jmate_orbit

    rz = ((0, -1, 0), (1, 0, 0), (0, 0, 1))
    ru = reflection((1, 0, 0))
    rv = reflection((1, -1, 0))
    assert matmul(ru, rv) == rz

    return {
        "schema": "c445-characteristic-11-gluing-v1",
        "task": "C445",
        "verdict": "GREEN — exact matching/orbit gluing theorem proved; C457 certifies the quaternion-splitting mechanism for paper 2",
        "inputs": inputs,
        "exact_gluing_theorem": {
            "upstairs": {
                "field": "Q(sqrt(5))",
                "object": "one golden six-arc with its unique A5-invariant polar-pair matching",
                "galois_conjugate_six_arcs_disjoint": True,
                "sigma_exchanges_prime_reductions": True,
                "rational_transporter_Rz": [list(row) for row in rz],
                "reflection_factorization": {"u": [1, 0, 0], "v": [1, -1, 0], "Rz": "r_u r_v"},
                "spinor_norm": 2,
                "boundary": "Rz exists over Q, but there is no characteristic-zero 22-point PGL2 orbit or split P1 model asserted",
            },
            "characteristic_11": {
                "common_point_set": "P1(F_11)",
                "common_point_set_size": 12,
                "base_matching": [list(pair) for pair in BASE],
                "jmate_matching": [list(pair) for pair in JMATE],
                "matching_stabilizer_orders": [60, 60],
                "stabilizers_contained_in_PSL2_11": True,
                "stabilizer_intersection_order": 12,
                "stabilizer_intersection_type": "A4",
                "PSL2_orbit_sizes": [11, 11],
                "PGL2_orbit_size": 22,
                "PGL2_orbit_is_union_of_two_PSL2_orbits": True,
                "generated_closure_order": 660,
                "generated_closure": "PSL2(11)",
                "outer_transporter": {
                    "mobius": "(x+10)/(x+1)",
                    "matrix_mod_11": list(transporter_matrix),
                    "determinant_mod_11": 2,
                    "legendre_symbol": -1,
                    "maps_base_to_jmate": True,
                },
                "gluing_statement": "The two Galois-conjugate reductions are the two PSL2(11) halves of one 22-element PGL2(11) orbit; their A5 stabilizers generate PSL2(11), while the rational spinor-norm-2 transporter reduces to the outer element exchanging the halves.",
            },
        },
        "perpendicularity_germ": {
            "common_cloud_triangle": [list(point) for point in TRIANGLE],
            "char0_perpendicular_axis_pairs": 6,
            "reduced_intersections": 3,
            "pairing_sigma_stable": True,
            "exact_strength": "the six perpendicular golden/conjugate axis pairs reduce two-by-two to exactly the common Frégier-cloud triangle",
            "does_not_prove": "the group gluing or quaternion mechanism by itself",
        },
        "exact_S4_A4_gluing_hinge": {
            "triangle_setwise_stabilizer": "S4",
            "triangle_setwise_stabilizer_order": 24,
            "common_matching_stabilizer": "A4",
            "common_matching_stabilizer_order": 12,
            "outer_transporter_lies_in_triangle_stabilizer": True,
            "deduction": "The transporter swaps the base and J-mate matchings, hence by Frégier-cloud equivariance swaps their clouds and preserves their common triangle. C460 identifies that triangle stabilizer as S4.",
            "determinant_kernel": "S4 intersection PSL2(11) = A4",
            "quotient": "S4/A4 = C2",
            "exact_diagram": "A4 = a5(8) intersection a5(4) = S4 intersection PSL2(11); the nontrivial S4/A4 coset exchanges the two golden matchings and contains Rz mod 11.",
        },
        "paper_1_closing_theorem": {
            "status": "provable now",
            "statement": "In the frozen A3, B3, and H3 vertex systems the invariant antipodal datum is controlled at matching level: A3's Frobenius-conjugate spin lifts fuse to one projective marker fibre over F5; B3's two sqrt(2)-reductions occupy opposite PSL2(7) fibres and carry opposite cubic orientations; H3's one golden polar matching reduces at the two primes above 11 to the two singleton fibres, which form one PGL2(11) orbit and whose A5 stabilizers generate PSL2(11). The H3 sheet exchange is the mod-11 shadow of the rational spinor-norm-2 rotation Rz.",
            "mandatory_cut": "No integral secant-product tensor, commuting-with-reduction mu_i theorem, or +/-6 characteristic-zero lift is asserted.",
        },
        "paper_2_boundary": {
            "provable_now": [
                "two-frame sheet/matching theorem",
                "characteristic-11 collision on one P1(F_11)",
                "11+11 PSL halves forming one 22-element PGL orbit",
                "closure <a5(8),a5(4)> = PSL2(11)",
                "rational Rz and its outer mod-11 transporter",
                "C460 perpendicularity/common-triangle shadow",
            ],
            "mechanism_status": "CERTIFIED_POST_C457",
            "mechanism_theorem": "C457 exhibits the maximal icosian order with unit reduced-trace discriminant and proves that its reductions at (11,phi-8) and (11,phi-4) are M2(F_11), with projective spin images exactly a5(8) and a5(4). Since (-1,-1) over the two real embeddings of Q(sqrt5) is Hamiltonian, this certifies the Schur-index-2 obstruction and its splitting at both primes above 11.",
            "placement": "The mechanism belongs in paper 2 and is not needed for the paper-1 matching theorem, but it is no longer merely interpretive.",
            "failed_route": "C443 found four companion sheets, not one; C461 proved the full descended lower-moment weight map has zero kernel mod 11. The secant-sheet tensor route is closed.",
        },
        "trusted_boundary": "Exact enumeration of PGL2(11), PSL2(11), matching stabilizers/orbits/closure, and an exact reflection factorization of Rz; hash-pinned C442/C458/C443/C461/C460/C444/C457 reports and certificates supply the frozen char-0, perpendicularity, failed-tensor, M4, and maximal-order splitting facts.",
    }


def rendered_json(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes() -> bytes:
    paths = [
        STEM.with_suffix(".md"),
        STEM.with_suffix(".py"),
        ROOT / "notes" / "2026-07-21-c445-characteristic-11-gluing-replay.py",
        OUTPUT,
    ]
    lines = [f"{digest(path)['sha256']}  {path.relative_to(ROOT / 'notes')}" for path in paths]
    return ("\n".join(lines) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.check == args.write:
        parser.error("choose exactly one of --check or --write")

    expected = rendered_json(build_certificate())
    if args.write:
        OUTPUT.write_bytes(expected)
        MANIFEST.write_bytes(manifest_bytes())
        return

    assert OUTPUT.read_bytes() == expected, "tracked JSON differs from regenerated certificate"
    assert MANIFEST.read_bytes() == manifest_bytes(), "manifest differs from current artifacts"
    print("C445 primary check: OK")


if __name__ == "__main__":
    main()
