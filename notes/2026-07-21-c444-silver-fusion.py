#!/usr/bin/env python3
"""C444 / M4: B3 silver split and A3 inert fusion certificate.

Run from the repository root:
  uv run python3 notes/2026-07-21-c444-silver-fusion.py
  uv run python3 notes/2026-07-21-c444-silver-fusion.py --check

The generator is deterministic and uses exact arithmetic in prime fields and in
F_25 = F_5[u]/(u^2-2).  It consumes only the frozen inputs named by the C444 task card.
"""
from __future__ import annotations

from functools import reduce
from itertools import combinations, combinations_with_replacement, product
from pathlib import Path
import hashlib
import json
import sys


HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c444-silver-fusion"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
REPLAY_PATH = HERE / f"{STEM}-replay.py"
SCHEMA = "c444-silver-fusion-v1"

INPUT_NAMES = (
    "2026-07-21-c440-conventions-freeze.md",
    "2026-07-21-c440-conventions-freeze.json",
    "2026-07-21-c440-conventions-freeze.py",
    "2026-07-21-c440-conventions-freeze.sha256",
    "2026-07-21-c441-vertex-reduction-bijection.md",
    "2026-07-21-c441-vertex-reduction-bijection.json",
    "2026-07-21-c441-vertex-reduction-bijection.py",
    "2026-07-21-c441-vertex-reduction-bijection.sha256",
    "2026-07-21-c442-antipodal-singleton-reduction.md",
    "2026-07-21-c442-m2-fable-review.md",
    "2026-07-20-c406-matching-module.md",
    "2026-07-20-c406-matching-module.json",
    "2026-07-20-c406-matching-module.py",
    "2026-07-20-c406-matching-module.sha256",
    "2026-07-20-c406-matching-orbit-scout.json",
)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def frozen_inputs() -> dict[str, dict[str, object]]:
    paths = [HERE / name for name in INPUT_NAMES]
    assert all(path.exists() for path in paths)
    result = {
        path.name: {"bytes": path.stat().st_size, "sha256": sha256(path.read_bytes())}
        for path in paths
    }
    for stem in ("2026-07-21-c440-conventions-freeze", "2026-07-21-c441-vertex-reduction-bijection"):
        manifest = (HERE / f"{stem}.sha256").read_text().splitlines()
        expected = {line.split()[1]: line.split()[0] for line in manifest}
        for suffix in ("py", "json"):
            name = f"{stem}.{suffix}"
            assert result[name]["sha256"] == expected[name]
    c406 = json.loads((HERE / "2026-07-20-c406-matching-module.json").read_text())
    scout_name = "2026-07-20-c406-matching-orbit-scout.json"
    assert result[scout_name] == c406["inputs"][scout_name]
    return result


def canon_edge(a, b):
    return tuple(sorted((a, b), key=lambda x: (x == "inf", x if x != "inf" else 0)))


def canon_matching(edges):
    return tuple(sorted((canon_edge(a, b) for a, b in edges), key=str))


def all_matchings(points):
    points = tuple(points)
    if not points:
        yield ()
        return
    first = points[0]
    for index in range(1, len(points)):
        second = points[index]
        rest = points[1:index] + points[index + 1 :]
        for tail in all_matchings(rest):
            yield canon_matching(((first, second),) + tail)


def mmul(a, b, p):
    return tuple(
        sum(a[2 * row + k] * b[2 * k + column] for k in range(2)) % p
        for row in range(2) for column in range(2)
    )


def madd(*matrices, p):
    return tuple(sum(matrix[index] for matrix in matrices) % p for index in range(4))


def mscale(scalar, matrix, p):
    return tuple(scalar * value % p for value in matrix)


def minv(matrix, p):
    a, b, c, d = matrix
    det = (a * d - b * c) % p
    inv = pow(det, -1, p)
    return (d * inv % p, -b * inv % p, -c * inv % p, a * inv % p)


def pnorm(matrix, p):
    pivot = next(value for value in matrix if value % p)
    inv = pow(pivot, -1, p)
    return tuple(value * inv % p for value in matrix)


def matrix_closure(generators, p, projective=False):
    normalize = (lambda matrix: pnorm(matrix, p)) if projective else (lambda matrix: matrix)
    identity = normalize((1, 0, 0, 1))
    group = {identity}
    frontier = [identity]
    generators = [normalize(generator) for generator in generators]
    while frontier:
        left = frontier.pop()
        for right in generators:
            value = normalize(mmul(left, right, p))
            if value not in group:
                group.add(value)
                frontier.append(value)
        assert len(group) <= 120
    return group


def pact(matrix, point, p):
    a, b, c, d = matrix
    if point == "inf":
        x, y = a, c
    else:
        x, y = (a * point + b) % p, (c * point + d) % p
    return "inf" if y == 0 else x * pow(y, -1, p) % p


def matching_image(matrix, matching, p):
    return canon_matching((pact(matrix, a, p), pact(matrix, b, p)) for a, b in matching)


def full_pgl(p):
    matrices = set()
    for entries in product(range(p), repeat=4):
        a, b, c, d = entries
        if (a * d - b * c) % p:
            matrices.add(pnorm(entries, p))
    squares = {x * x % p for x in range(1, p)}
    psl = {matrix for matrix in matrices if (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % p in squares}
    return matrices, psl


def invariant_matchings(group, p):
    points = tuple(range(p)) + ("inf",)
    return sorted(
        matching for matching in set(all_matchings(points))
        if all(matching_image(matrix, matching, p) == matching for matrix in group)
    )


def orbit(group, matching, p):
    return {matching_image(matrix, matching, p) for matrix in group}


def matching_sort_key(matching, p):
    return tuple(
        tuple(p if value == "inf" else value for value in edge)
        for edge in matching
    )


def b3_spin_group(sqrt2):
    """Binary octahedral 2.S4 in SL_2(F_7), split quaternion model.

    I^2=J^2=-1 and IJ=-JI, with J depending on the chosen root sqrt(2).
    Q=(1+I+J+IJ)/2 and R=(1+I)/sqrt(2) generate the binary octahedral group.
    The frozen vertex frame is reached by the single silver projectivity C=[[1,sqrt2],[0,1]].
    """
    p = 7
    one = (1, 0, 0, 1)
    i = (0, 1, -1 % p, 0)
    j = (2, sqrt2, sqrt2, -2 % p)
    k = mmul(i, j, p)
    q = mscale(pow(2, -1, p), madd(one, i, j, k, p=p), p)
    r = mscale(pow(sqrt2, -1, p), madd(one, i, p=p), p)
    spin = matrix_closure((i, j, q, r), p, projective=False)
    assert len(spin) == 48
    assert all((a * d - b * c) % p == 1 for a, b, c, d in spin)
    c = (1, sqrt2, 0, 1)
    ci = minv(c, p)
    projective = {
        pnorm(mmul(mmul(c, matrix, p), ci, p), p)
        for matrix in spin
    }
    assert len(projective) == 24
    return spin, projective, {"I": i, "J": j, "Q": q, "R": r, "C": c}


def cube_label_table():
    p = 7
    inv2 = pow(2, -1, p)
    rows = [
        {"vertex": "v0", "char0": "0", "point_sqrt2_3": 0, "point_sqrt2_4": 0},
        {"vertex": "vinf", "char0": "inf", "point_sqrt2_3": "inf", "point_sqrt2_4": "inf"},
    ]
    for block, factor in (("upper", "sqrt2/2"), ("lower", "-sqrt2")):
        for exponent in range(3):
            values = {}
            for sqrt2 in (3, 4):
                omega = 2
                base = sqrt2 * inv2 % p if block == "upper" else -sqrt2 % p
                values[sqrt2] = base * pow(omega, exponent, p) % p
            rows.append({
                "vertex": f"{block}_{exponent}",
                "char0": f"{factor}*omega^{exponent}",
                "point_sqrt2_3": values[3],
                "point_sqrt2_4": values[4],
            })
    frozen = json.loads((HERE / "2026-07-21-c441-vertex-reduction-bijection.json").read_text())
    frozen_rows = frozen["cases"]["B3_cube"]["bijection_table"]
    assert sorted(row["point_pi"] for row in frozen_rows if row["point_pi"] != "inf") == list(range(7))
    assert sorted(row["point_pi_bar"] for row in frozen_rows if row["point_pi_bar"] != "inf") == list(range(7))
    expected_blocks = {
        "upper": ({3, 5, 6}, {1, 2, 4}),
        "lower": ({1, 2, 4}, {3, 5, 6}),
    }
    for block, (left, right) in expected_blocks.items():
        assert {row["point_sqrt2_3"] for row in rows if row["vertex"].startswith(block)} == left
        assert {row["point_sqrt2_4"] for row in rows if row["vertex"].startswith(block)} == right
    return rows


def cube_antipodal_matching(rows, sqrt2):
    by_name = {row["vertex"]: row[f"point_sqrt2_{sqrt2}"] for row in rows}
    return canon_matching(
        [(by_name["v0"], by_name["vinf"])]
        + [(by_name[f"upper_{k}"], by_name[f"lower_{k}"]) for k in range(3)]
    )


def homogeneous_basis(degree):
    return tuple(
        (x, y, degree - x - y)
        for x in range(degree + 1) for y in range(degree - x + 1)
    )


def polymul(left, right, p):
    result = {}
    for e1, c1 in left.items():
        for e2, c2 in right.items():
            exponent = tuple(e1[k] + e2[k] for k in range(3))
            result[exponent] = (result.get(exponent, 0) + c1 * c2) % p
    return {key: value for key, value in result.items() if value}


def matching_product(matching, p):
    endpoints = [(1, x) for x in range(p)] + [(0, 1)]
    result = {(0, 0, 0): 1}
    for left, right in matching:
        i = p if left == "inf" else left
        j = p if right == "inf" else right
        si, ti = endpoints[i]
        sj, tj = endpoints[j]
        line = {
            (1, 0, 0): ti * tj % p,
            (0, 1, 0): -(si * tj + ti * sj) % p,
            (0, 0, 1): si * sj % p,
        }
        result = polymul(result, line, p)
    return result


def rref(matrix, p):
    data = [[value % p for value in row] for row in matrix]
    pivots = []
    row = 0
    for column in range(len(data[0]) if data else 0):
        candidate = next((r for r in range(row, len(data)) if data[r][column]), None)
        if candidate is None:
            continue
        data[row], data[candidate] = data[candidate], data[row]
        scale = pow(data[row][column], -1, p)
        data[row] = [value * scale % p for value in data[row]]
        for other in range(len(data)):
            if other != row and data[other][column]:
                factor = data[other][column]
                data[other] = [(a - factor * b) % p for a, b in zip(data[other], data[row])]
        pivots.append(column)
        row += 1
        if row == len(data):
            break
    return data, pivots


def quotient_by_conic(difference, degree, p):
    source = homogeneous_basis(degree)
    target = homogeneous_basis(degree + 2)
    index = {monomial: i for i, monomial in enumerate(target)}
    matrix = [[0] * len(source) for _ in target]
    conic = {(1, 0, 1): 1, (0, 2, 0): -1 % p}
    for column, monomial in enumerate(source):
        for exponent, coefficient in polymul({monomial: 1}, conic, p).items():
            matrix[index[exponent]][column] = coefficient
    rhs = [difference.get(monomial, 0) for monomial in target]
    reduced, pivots = rref([row + [rhs[i]] for i, row in enumerate(matrix)], p)
    assert len(source) not in pivots
    solution = [0] * len(source)
    for row, pivot in enumerate(pivots):
        if pivot < len(source):
            solution[pivot] = reduced[row][-1]
    return solution


def symmetric_power(vector, degree, p):
    return [
        reduce(lambda a, index: a * vector[index] % p, indices, 1)
        for indices in combinations_with_replacement(range(len(vector)), degree)
    ]


def c406_b3_moments(base_matching):
    p = 7
    pgl, psl = full_pgl(p)
    target_orbit = sorted(orbit(pgl, base_matching, p), key=lambda item: matching_sort_key(item, p))
    assert len(target_orbit) == 14
    unseen = set(target_orbit)
    sheets = []
    while unseen:
        representative = min(unseen, key=lambda item: matching_sort_key(item, p))
        sheet = orbit(psl, representative, p)
        unseen -= sheet
        sheets.append(sheet)
    assert [len(sheet) for sheet in sheets] == [7, 7]

    base_product = matching_product(base_matching, p)
    vectors = []
    for matching in target_orbit:
        product_value = matching_product(matching, p)
        difference = {
            exponent: (product_value.get(exponent, 0) - base_product.get(exponent, 0)) % p
            for exponent in set(product_value) | set(base_product)
        }
        vectors.append(quotient_by_conic(difference, 2, p))
    reduced, coordinate_pivots = rref(vectors, p)
    assert len(coordinate_pivots) == 6
    reduced_vectors = [[vector[index] for index in coordinate_pivots] for vector in vectors]
    signs = [1 if matching in sheets[0] else -1 % p for matching in target_orbit]
    moments = []
    for degree in (1, 2, 3):
        powers = [symmetric_power(vector, degree, p) for vector in reduced_vectors]
        moment = [sum(sign * power[i] for sign, power in zip(signs, powers)) % p for i in range(len(powers[0]))]
        moments.append({
            "degree": degree,
            "dimension": len(moment),
            "nonzero": any(moment),
            "support": sum(value != 0 for value in moment),
            "sha256": sha256(bytes(moment)),
            "vector": moment,
        })
    c406 = json.loads((HERE / "2026-07-20-c406-matching-module.json").read_text())
    frozen = next(record for record in c406["types"] if record["type"] == "B3")
    frozen_moments = frozen["outer_sheet_sign"]["signed_moments_on_image_coordinates"]
    for actual, expected in zip(moments, frozen_moments):
        for key in ("degree", "dimension", "nonzero", "support", "sha256"):
            assert actual[key] == expected[key]
    return target_orbit, sheets, moments, coordinate_pivots


# F_25 = F_5[u]/(u^2-2), represented as a+b*u.
def f25_add(x, y):
    return ((x[0] + y[0]) % 5, (x[1] + y[1]) % 5)


def f25_neg(x):
    return (-x[0] % 5, -x[1] % 5)


def f25_mul(x, y):
    return ((x[0] * y[0] + 2 * x[1] * y[1]) % 5, (x[0] * y[1] + x[1] * y[0]) % 5)


def f25_inv(x):
    norm = (x[0] * x[0] - 2 * x[1] * x[1]) % 5
    assert norm
    n = pow(norm, -1, 5)
    return (x[0] * n % 5, -x[1] * n % 5)


def f25_frob(x):
    return (x[0], -x[1] % 5)


FZERO = (0, 0)
FONE = (1, 0)


def f25_mmul(a, b):
    return tuple(
        reduce(f25_add, (f25_mul(a[2 * row + k], b[2 * k + column]) for k in range(2)), FZERO)
        for row in range(2) for column in range(2)
    )


def f25_madd(*matrices):
    return tuple(reduce(f25_add, (matrix[i] for matrix in matrices), FZERO) for i in range(4))


def f25_scale(scalar, matrix):
    return tuple(f25_mul(scalar, value) for value in matrix)


def f25_pnorm(matrix):
    pivot = next(value for value in matrix if value != FZERO)
    return f25_scale(f25_inv(pivot), matrix)


def f25_closure(generators, projective=False):
    normalize = f25_pnorm if projective else (lambda x: x)
    identity = normalize((FONE, FZERO, FZERO, FONE))
    group = {identity}
    frontier = [identity]
    generators = [normalize(generator) for generator in generators]
    while frontier:
        left = frontier.pop()
        for right in generators:
            value = normalize(f25_mmul(left, right))
            if value not in group:
                group.add(value)
                frontier.append(value)
        assert len(group) <= 120
    return group


def a3_spin_model():
    one = (FONE, FZERO, FZERO, FONE)
    i = ((2, 0), FZERO, FZERO, (3, 0))
    j = (FZERO, FONE, (4, 0), FZERO)
    k = f25_mmul(i, j)
    half = (3, 0)
    q = f25_scale(half, f25_madd(one, i, j, k))
    u = (0, 1)
    assert f25_mul(u, u) == (2, 0)
    r_plus = f25_scale(f25_inv(u), f25_madd(one, i))
    r_minus = tuple(f25_frob(value) for value in r_plus)
    assert r_minus == tuple(f25_neg(value) for value in r_plus)
    spin = f25_closure((i, j, q, r_plus), projective=False)
    assert len(spin) == 48
    assert {tuple(f25_frob(value) for value in matrix) for matrix in spin} == spin
    projective_f25 = f25_closure((i, j, q, r_plus), projective=True)
    assert len(projective_f25) == 24
    assert all(value[1] == 0 for matrix in projective_f25 for value in matrix)
    projective = {tuple(value[0] for value in matrix) for matrix in projective_f25}
    assert len(projective) == 24
    matching = canon_matching(((0, "inf"), (1, 4), (2, 3)))
    assert invariant_matchings(projective, 5) == [matching]
    pgl, psl = full_pgl(5)
    pgl_orbit = orbit(pgl, matching, 5)
    psl_orbit = orbit(psl, matching, 5)
    assert len(pgl_orbit) == len(psl_orbit) == 5 and pgl_orbit == psl_orbit
    assert not projective <= psl
    nonsquare_determinants = sorted({(a * d - b * c) % 5 for a, b, c, d in projective - psl})
    return {
        "field": "F_25 = F_5[u]/(u^2-2)",
        "frobenius": "a+b*u -> a-b*u; u^5=-u",
        "orientation_plus_R": [[list(value) for value in r_plus[:2]], [list(value) for value in r_plus[2:]]],
        "orientation_minus_R": [[list(value) for value in r_minus[:2]], [list(value) for value in r_minus[2:]]],
        "frobenius_swaps_orientations": True,
        "binary_octahedral_order": len(spin),
        "projective_group_order": len(projective),
        "projective_group_defined_over_F5": True,
        "unique_invariant_matching": [list(edge) for edge in matching],
        "pgl_marker_orbit_size": len(pgl_orbit),
        "psl_marker_orbit_size": len(psl_orbit),
        "pgl_and_psl_marker_orbits_equal": pgl_orbit == psl_orbit,
        "parent_is_subgroup_of_psl": projective <= psl,
        "parent_nonsquare_determinants": nonsquare_determinants,
        "sheet_sign_exists": False,
    }


def a3_label_table():
    rows = [
        {"vertex": "v0", "char0": "0", "point_i_2": 0, "point_i_3": 0},
        {"vertex": "vinf", "char0": "inf", "point_i_2": "inf", "point_i_3": "inf"},
        {"vertex": "+1", "char0": "1", "point_i_2": 1, "point_i_3": 1},
        {"vertex": "-1", "char0": "-1", "point_i_2": 4, "point_i_3": 4},
        {"vertex": "+i", "char0": "i", "point_i_2": 2, "point_i_3": 3},
        {"vertex": "-i", "char0": "-i", "point_i_2": 3, "point_i_3": 2},
    ]
    frozen = json.loads((HERE / "2026-07-21-c441-vertex-reduction-bijection.json").read_text())
    frozen_rows = frozen["cases"]["A3_octahedron"]["bijection_table"]
    assert {(row["point"], row["point_iconj"]) for row in frozen_rows} == {
        (row["point_i_2"], row["point_i_3"]) for row in rows
    }
    return rows


def build_certificate():
    inputs = frozen_inputs()
    scout = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    b3_scout = next(record for record in scout["types"] if record["type"] == "B3")
    a3_scout = next(record for record in scout["types"] if record["type"] == "A3")

    b3_rows = cube_label_table()
    b3_matchings = {sqrt2: cube_antipodal_matching(b3_rows, sqrt2) for sqrt2 in (3, 4)}
    b3_groups = {}
    for sqrt2 in (3, 4):
        spin, parent, generators = b3_spin_group(sqrt2)
        invariant = invariant_matchings(parent, 7)
        assert invariant == [b3_matchings[sqrt2]]
        b3_groups[sqrt2] = (spin, parent, generators)

    b3_base = canon_matching(
        (("inf" if value == 7 else value) for value in edge)
        for edge in b3_scout["coxeter_invariant_matching"]
    )
    target_orbit, sheets, moments, pivots = c406_b3_moments(b3_base)
    assert all(b3_matchings[sqrt2] in target_orbit for sqrt2 in (3, 4))
    sheet_index = {
        sqrt2: next(index for index, sheet in enumerate(sheets) if b3_matchings[sqrt2] in sheet)
        for sqrt2 in (3, 4)
    }
    assert sheet_index == {3: 1, 4: 0}
    pgl7, psl7 = full_pgl(7)
    for sqrt2 in (3, 4):
        assert b3_groups[sqrt2][1] <= psl7
    assert len(orbit(pgl7, b3_matchings[3], 7)) == 14
    assert sorted(len(orbit(psl7, matching, 7)) for matching in b3_matchings.values()) == [7, 7]

    a3_rows = a3_label_table()
    a3_matching_i2 = canon_matching(((0, "inf"), (1, 4), (2, 3)))
    a3_matching_i3 = canon_matching(((0, "inf"), (1, 4), (3, 2)))
    assert a3_matching_i2 == a3_matching_i3
    a3_base = canon_matching(
        (("inf" if value == 5 else value) for value in edge)
        for edge in a3_scout["coxeter_invariant_matching"]
    )
    assert a3_matching_i2 == a3_base
    a3_spin = a3_spin_model()

    cubic = moments[2]["vector"]
    negative_cubic = [(-value) % 7 for value in cubic]
    cert = {
        "schema": SCHEMA,
        "task": "C444 / M4 -- B3 silver split and A3 inert fusion",
        "verdict": "GREEN -- B3 split-prime sheet criterion and cubic orientation reproduced; A3 inert Frobenius fusion certified",
        "inputs": inputs,
        "prime_ideals_and_residue_maps": {
            "B3": [
                {"ideal": "(3-sqrt2)", "norm": 7, "residue_field": "F_7", "map": "a+b*sqrt2 -> a+3b mod 7", "sqrt2": 3},
                {"ideal": "(3+sqrt2)", "norm": 7, "residue_field": "F_7", "map": "a+b*sqrt2 -> a+4b mod 7", "sqrt2": 4},
            ],
            "A3": {
                "ideal": "(5)", "norm": 25, "residue_field": "F_25=F_5[u]/(u^2-2)",
                "map": "a+b*sqrt2 -> a+b*u", "inert": True, "frobenius": "u -> -u",
            },
        },
        "B3": {
            "labeling_table": b3_rows,
            "char0_antipodal_rule": "0<->inf and (sqrt2/2)*omega^k <-> -sqrt2*omega^k for k=0,1,2",
            "reductions": {
                "sqrt2_3": {
                    "ideal": "(3-sqrt2)",
                    "matching": [list(edge) for edge in b3_matchings[3]],
                    "spin_group_order": len(b3_groups[3][0]),
                    "projective_parent_order": len(b3_groups[3][1]),
                    "c406_sheet_index": sheet_index[3],
                    "cubic_orientation": "negative",
                    "signed_cubic_vector": negative_cubic,
                },
                "sqrt2_4": {
                    "ideal": "(3+sqrt2)",
                    "matching": [list(edge) for edge in b3_matchings[4]],
                    "spin_group_order": len(b3_groups[4][0]),
                    "projective_parent_order": len(b3_groups[4][1]),
                    "c406_sheet_index": sheet_index[4],
                    "cubic_orientation": "positive",
                    "signed_cubic_vector": cubic,
                },
            },
            "spin_model": {
                "description": "I^2=J^2=-1, IJ=-JI; Q=(1+I+J+IJ)/2, R=(1+I)/sqrt2; conjugate by C=[[1,sqrt2],[0,1]] into the frozen vertex labels",
                "silver_conjugation_swaps_reductions": True,
                "each_binary_octahedral_order": 48,
                "each_projective_parent_order": 24,
            },
            "c406_split_criterion": {
                "statement": "A transitive PGL_2(q)/H marker orbit splits into two PSL_2(q) orbits iff H is contained in PSL_2(q)",
                "parent_is_subgroup_of_psl": True,
                "pgl_marker_orbit_size": 14,
                "psl_marker_orbit_sizes": [7, 7],
                "two_antipodal_reductions_are_in_opposite_psl_fibres": True,
            },
            "c406_moment_comparison": {
                "coordinate_pivots": pivots,
                "moments": moments,
                "lower_signed_moments_vanish": not moments[0]["nonzero"] and not moments[1]["nonzero"],
                "cubic_nonzero": moments[2]["nonzero"],
                "sqrt2_4_is_positive_and_sqrt2_3_is_negative": True,
            },
        },
        "A3": {
            "labeling_table": a3_rows,
            "char0_antipodal_rule": "0<->inf, 1<->-1, i<->-i",
            "matching_at_i_2": [list(edge) for edge in a3_matching_i2],
            "matching_at_i_3": [list(edge) for edge in a3_matching_i3],
            "matching_is_prime_independent": a3_matching_i2 == a3_matching_i3,
            "spin_model": a3_spin,
            "c406_fusion_criterion": {
                "statement": "The A3 parent S4 is not contained in PSL_2(5), so its PGL_2(5)/S4 marker orbit does not split on restriction to PSL_2(5)",
                "parent_is_subgroup_of_psl": False,
                "pgl_marker_orbit_size": 5,
                "psl_marker_orbit_sizes": [5],
                "one_fused_marker_fibre": True,
                "sheet_sign_exists": False,
            },
        },
        "boundary": {
            "certifies": "the full M4 split/fusion reduction theory in the frozen labeling and C406 moment convention",
            "does_not_certify": "quaternion maximal-order reduction (C457/T10), M5 gluing, or an integral tensor lift",
        },
        "trusted_boundary": "exact enumeration in F_5, F_7 and F_25; frozen M0/M1 labels and frozen C406 scout/moment certificates; standard quaternion-to-binary-octahedral formulas are verified by closure rather than assumed",
    }
    return cert


def canonical_json(value):
    return json.dumps(value, sort_keys=True, indent=2, ensure_ascii=True) + "\n"


def manifest_text(json_bytes):
    paths = [Path(__file__).resolve(), REPLAY_PATH, JSON_PATH]
    data = {
        Path(__file__).resolve(): Path(__file__).resolve().read_bytes(),
        REPLAY_PATH: REPLAY_PATH.read_bytes(),
        JSON_PATH: json_bytes,
    }
    return "".join(f"{sha256(data[path])}  {path.name}\n" for path in paths)


def main(argv):
    cert = build_certificate()
    rendered = canonical_json(cert).encode()
    if "--check" in argv:
        ok = JSON_PATH.exists() and JSON_PATH.read_bytes() == rendered
        ok = ok and SHA_PATH.exists() and SHA_PATH.read_text() == manifest_text(rendered)
        print("CHECK OK" if ok else "CHECK FAILED")
        return 0 if ok else 1
    assert REPLAY_PATH.exists(), f"missing independent replay: {REPLAY_PATH.name}"
    JSON_PATH.write_bytes(rendered)
    SHA_PATH.write_text(manifest_text(rendered))
    print(f"wrote {JSON_PATH.name} ({len(rendered)} bytes) and {SHA_PATH.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
