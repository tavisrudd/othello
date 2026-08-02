#!/usr/bin/env python3
"""Bounded falsification tests for the C756 probability/information portfolio."""

from collections import Counter
from hashlib import sha256
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations, product
import cmath
import json
import math
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
VERIFY_PATH = HERE / "2026-08-01-c756-saturated-internal-verify.py"
OUTPUT = HERE / "2026-08-01-c756-probability-cheap-tests.json"
MASKED_AUDIT = HERE / "2026-08-01-c756-masked-rs-collision-audit.json"
SATURATED_AUDIT = HERE / "2026-08-01-c756-saturated-internal-audit.json"

spec = spec_from_file_location("c756_si_verify", VERIFY_PATH)
verify = module_from_spec(spec)
spec.loader.exec_module(verify)


def saturated_candidates(q):
    eps, add, sub, mul, conj, fpow, chi2 = verify.field(q)
    k = (q + 3) // 2
    t = (q + 1) // 2
    sigma = 1 if (t + 1) % 2 == 0 else -1
    reps = [(a, b) for b in range(1, (q - 1) // 2 + 1) for a in range(q)]
    p0 = reps.index((0, 1))

    def cond(i, j):
        zi, zj = reps[i], reps[j]
        return chi2(mul(sub(zi, zj), sub(zi, conj(zj)))) == -1

    verts = [i for i in range(len(reps)) if i != p0 and cond(p0, i)]
    adjacency = {v: set() for v in verts}
    for left, right in combinations(verts, 2):
        if cond(left, right):
            adjacency[left].add(right)
            adjacency[right].add(left)
    solutions = []

    def dfs(chosen, candidates):
        if len(chosen) == k - 1:
            solutions.append([p0] + chosen)
            return
        candidates = sorted(candidates)
        while candidates:
            vertex = candidates.pop(0)
            tail = [x for x in candidates if x in adjacency[vertex]]
            if len(chosen) + 1 + len(tail) >= k - 1:
                dfs(chosen + [vertex], tail)

    dfs([], verts)
    return [[reps[i] for i in indexes] for indexes in solutions], {
        "eps": eps, "add": add, "sub": sub, "mul": mul, "conj": conj,
        "fpow": fpow, "chi2": chi2, "sigma": sigma,
    }


def entropy(probabilities):
    return -sum(p * math.log(p) for p in probabilities if p > 0)


def saturated_uncertainty_row(q, candidate, field):
    sub, conj, chi2, sigma = field["sub"], field["conj"], field["chi2"], field["sigma"]
    k = len(candidate)
    best = None
    # Conjugating a representative is the sign choice in the double-clique model.
    for bits in product((0, 1), repeat=k):
        oriented = [conj(z) if bit else z for z, bit in zip(candidate, bits)]
        violations = sum(chi2(sub(oriented[i], conj(oriented[j]))) != sigma
                         for i, j in combinations(range(k), 2))
        key = (violations, bits)
        if best is None or key < best[0]:
            best = (key, oriented)
    violations, bits = best[0]
    oriented = best[1]
    signed = {z: 1 for z in oriented}
    signed.update({conj(z): -1 for z in oriented})
    support = set(signed)
    assert len(support) == 2 * k

    difference_counts = Counter(sub(left, right) for left in support for right in support)
    additive_energy = sum(value * value for value in difference_counts.values())
    sumset = {((left[0] + right[0]) % q, (left[1] + right[1]) % q)
              for left in support for right in support}

    root = cmath.exp(-2j * math.pi / q)
    spectrum = []
    for a in range(q):
        for b in range(q):
            value = sum(sign * root ** ((a * z[0] + b * z[1]) % q)
                        for z, sign in signed.items())
            spectrum.append(abs(value) ** 2)
    denominator = q * q * (2 * k)
    probabilities = [value / denominator for value in spectrum]
    assert abs(sum(probabilities) - 1.0) < 1e-9
    uncertainty_gap = math.log(2 * k) + entropy(probabilities) - 2 * math.log(q)

    theta = (q - 1) / 2
    residual_square = 0.0
    residual_nonsquare = 0.0
    for w in product(range(q), repeat=2):
        ax_square = sum(sign for z, sign in signed.items() if chi2(sub(w, z)) == 1)
        ax_nonsquare = sum(sign for z, sign in signed.items() if chi2(sub(w, z)) == -1)
        target = theta * signed.get(w, 0)
        residual_square += (ax_square - target) ** 2
        residual_nonsquare += (ax_nonsquare - target) ** 2

    return {
        "coherence_violations_min": violations,
        "orientation_bits": "".join(map(str, bits)),
        "uncertainty_gap_nats": round(uncertainty_gap, 12),
        "fourier_entropy_nats": round(entropy(probabilities), 12),
        "support_size": len(support),
        "sumset_size": len(sumset),
        "additive_energy": additive_energy,
        "normalized_additive_energy": round(additive_energy / len(support) ** 3, 12),
        "paley_square_eigen_residual_squared": residual_square,
        "paley_nonsquare_eigen_residual_squared": residual_nonsquare,
    }


def saturated_uncertainty_test():
    expected = {row["q"]: row for row in json.loads(SATURATED_AUDIT.read_text())["rows"]}
    rows = []
    for q in (5, 7, 11, 19, 23):
        candidates, field = saturated_candidates(q)
        diagnostics = [saturated_uncertainty_row(q, candidate, field)
                       for candidate in candidates]
        assert len(candidates) == expected[q]["candidates"]
        if q == 5:
            assert all(row["coherence_violations_min"] == 0 for row in diagnostics)
            assert all(row["paley_nonsquare_eigen_residual_squared"] == 0
                       for row in diagnostics)
        rows.append({
            "q": q,
            "candidate_count": len(candidates),
            "diagnostics": diagnostics,
        })
    return {
        "scope": "all character candidates over prime q in {5,7,11,19,23}",
        "kill_criterion": (
            "The q=5 coherent examples are not distinguished by a sharp uncertainty "
            "gap, additive-energy signature, or exact Paley eigen-residual."
        ),
        "rows": rows,
    }


def prime_normalize(vector, q):
    for value in reversed(vector):
        if value % q:
            scale = pow(value, -1, q)
            return tuple(x * scale % q for x in vector)
    raise AssertionError


def prime_cross(left, right, q):
    return prime_normalize((
        left[1] * right[2] - left[2] * right[1],
        left[2] * right[0] - left[0] * right[2],
        left[0] * right[1] - left[1] * right[0],
    ), q)


def prime_points(q):
    return ([(x, y, 1) for x in range(q) for y in range(q)]
            + [(x, 1, 0) for x in range(q)] + [(1, 0, 0)])


def rank_mod_q(matrix, q):
    matrix = [row[:] for row in matrix]
    rank = 0
    columns = len(matrix[0]) if matrix else 0
    for column in range(columns):
        pivot = next((r for r in range(rank, len(matrix)) if matrix[r][column] % q), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        scale = pow(matrix[rank][column], -1, q)
        matrix[rank] = [x * scale % q for x in matrix[rank]]
        for r in range(len(matrix)):
            if r != rank and matrix[r][column] % q:
                factor = matrix[r][column]
                matrix[r] = [(x - factor * y) % q
                             for x, y in zip(matrix[r], matrix[rank])]
        rank += 1
        if rank == len(matrix):
            break
    return rank


def monomial_exponents(degree):
    return [(a, b, degree - a - b)
            for a in range(degree + 1) for b in range(degree - a + 1)]


def split_support_row(q, witness):
    points = prime_points(q)
    chords = {prime_cross(left, right, q) for left, right in combinations(witness, 2)}
    multiplicities = {
        point: sum(sum(x * y for x, y in zip(line, point)) % q == 0 for line in chords)
        for point in points
    }
    covered = {point for point, degree in multiplicities.items() if degree}
    conic = {point for point in points if (point[1] ** 2 - point[0] * point[2]) % q == 0}
    missing = [point for point in points if point not in conic and point not in covered]
    hilbert = []
    first_unexpected = None
    for degree in range(1, 11):
        exponents = monomial_exponents(degree)
        matrix = [[pow(x, a, q) * pow(y, b, q) * pow(z, c, q) % q
                   for a, b, c in exponents] for x, y, z in missing]
        rank = rank_mod_q(matrix, q)
        generic_rank = min(len(missing), len(exponents))
        defect = generic_rank - rank
        if defect and first_unexpected is None:
            first_unexpected = degree
        hilbert.append({
            "degree": degree,
            "monomials": len(exponents),
            "rank": rank,
            "generic_rank": generic_rank,
            "rank_defect": defect,
            "vanishing_kernel_dimension": len(exponents) - rank,
        })
    line_counts = Counter()
    for line in points:
        count = sum(sum(x * y for x, y in zip(line, point)) % q == 0 for point in missing)
        line_counts[count] += 1
    return {
        "q": q,
        "k": len(witness),
        "chord_count": len(chords),
        "missing_count": len(missing),
        "missing_over_q": round(len(missing) / q, 12),
        "first_unexpected_hilbert_degree": first_unexpected,
        "hilbert": hilbert,
        "max_missing_on_line": max(line_counts),
        "line_intersection_profile": dict(sorted(line_counts.items())),
        "off_conic_chord_multiplicity_profile": dict(sorted(Counter(
            multiplicities[point] for point in points
            if (point[1] ** 2 - point[0] * point[2]) % q != 0
        ).items())),
    }


def split_support_test():
    records = json.loads(MASKED_AUDIT.read_text())["records"]
    rows = []
    for record in sorted(records, key=lambda row: row["q"]):
        q = record["q"]
        if record["p"] != q or q == 11:
            continue
        witness = [tuple(point) for point in record["extremal_max_cov_witness"]]
        row = split_support_row(q, witness)
        assert q * q - row["missing_count"] == record["extremal_max_cov_pts"]
        rows.append(row)
    return {
        "scope": (
            "maximum-coverage extremal witnesses in every audited prime field q>=13; "
            "degrees 1 through 10"
        ),
        "kill_criterion": (
            "The missing sets have generic Hilbert functions through degree 10 and no "
            "persistent line concentration beyond their O(|S|/q) scale."
        ),
        "rows": rows,
    }


def lloyd_moment_test():
    # First arithmetically live nonsaturated boundary: deleting one point gives
    # (q,n,delta)=(53,11,2), hence the original arc has k=12 and b=66 chord lines.
    q, k = 53, 12
    b = k * (k - 1) // 2
    # Exact integer covering profile N_j.  It includes k forced arc vertices at j=k-1.
    profile = {1: 2502, 2: 210, 6: 85, 11: 12}
    checks = {
        "point_count": sum(profile.values()),
        "incidence_count": sum(j * count for j, count in profile.items()),
        "line_pair_intersections": sum(j * (j - 1) // 2 * count
                                       for j, count in profile.items()),
        "forced_arc_vertices": profile.get(k - 1, 0),
    }
    targets = {
        "point_count": q * q,
        "incidence_count": b * (q + 1),
        "line_pair_intersections": b * (b - 1) // 2,
        "forced_arc_vertices": k,
    }
    assert checks == targets
    return {
        "scope": "degree-two incidence moments at the first live boundary (q,k)=(53,12)",
        "kill_criterion": (
            "An exact nonnegative integer profile with N_0=0 satisfies all universal "
            "moments and the forced arc-vertex multiplicities."
        ),
        "q": q,
        "k": k,
        "chord_count": b,
        "covering_profile_N_j": profile,
        "checks": checks,
        "targets": targets,
        "verdict": (
            "KILLED at degree two: no quadratic Lloyd/Delsarte dual polynomial using "
            "only these moments can force an uncovered point. Higher-order concurrency "
            "identities would be genuinely new input."
        ),
    }


def determinant_mod_q(left, middle, right, q):
    return (
        left[0] * (middle[1] * right[2] - middle[2] * right[1])
        - left[1] * (middle[0] * right[2] - middle[2] * right[0])
        + left[2] * (middle[0] * right[1] - middle[1] * right[0])
    ) % q


def external_join_prime(left, right, q):
    inv2 = pow(2, -1, q)
    qleft = (left[1] ** 2 - left[0] * left[2]) % q
    qright = (right[1] ** 2 - right[0] * right[2]) % q
    bilinear = (left[1] * right[1]
                - (left[0] * right[2] + left[2] * right[0]) * inv2) % q
    discriminant = (bilinear * bilinear - qleft * qright) % q
    return discriminant != 0 and pow(discriminant, (q - 1) // 2, q) == q - 1


def prefix_entropy_row(q, witness):
    off_conic = [point for point in prime_points(q)
                 if (point[1] ** 2 - point[0] * point[2]) % q]
    universe = (1 << len(off_conic)) - 1
    adjacency = []
    for vertex in witness:
        bits = 0
        for index, point in enumerate(off_conic):
            if external_join_prime(vertex, point, q):
                bits |= 1 << index
        adjacency.append(bits)
    line_bits = {}
    for i, j in combinations(range(len(witness)), 2):
        bits = 0
        for index, point in enumerate(off_conic):
            if determinant_mod_q(witness[i], witness[j], point, q) == 0:
                bits |= 1 << index
        line_bits[(i, j)] = bits

    by_depth = []
    k = len(witness)
    for depth in range(1, k + 1):
        counts = []
        for selected in combinations(range(k), depth):
            allowed = universe
            for i in selected:
                allowed &= adjacency[i]
            for i, j in combinations(selected, 2):
                allowed &= ~line_bits[(i, j)]
            counts.append(allowed.bit_count())
        histogram = Counter(counts)
        mean = sum(counts) / len(counts)
        variance = sum((value - mean) ** 2 for value in counts) / len(counts)
        label_probabilities = [count / len(counts) for count in histogram.values()]
        by_depth.append({
            "depth": depth,
            "subsets": len(counts),
            "min_extensions": min(counts),
            "max_extensions": max(counts),
            "mean_extensions": round(mean, 12),
            "coefficient_of_variation": round(math.sqrt(variance) / mean, 12) if mean else None,
            "distinct_extension_counts": len(histogram),
            "count_label_entropy_nats": round(entropy(label_probabilities), 12),
            "independent_coin_baseline": round(q * q / (2 ** depth), 12),
            "extension_count_histogram": dict(sorted(histogram.items())),
        })
    assert by_depth[-1]["max_extensions"] == 0
    return {"q": q, "k": k, "by_depth": by_depth}


def prefix_entropy_test():
    records = json.loads(MASKED_AUDIT.read_text())["records"]
    selected_q = {13, 19, 29, 31, 41, 43}
    rows = []
    for record in sorted(records, key=lambda row: row["q"]):
        q = record["q"]
        if q not in selected_q:
            continue
        witness = [tuple(point) for point in record["m_witness"]]
        rows.append(prefix_entropy_row(q, witness))
    return {
        "scope": (
            "all subsets of one exact maximum witness at q in {13,19,29,31,41,43}; "
            "extension counts impose both externality and general position"
        ),
        "kill_criterion": (
            "At fixed depth the surviving-prefix extension counts are diffuse rather "
            "than collapsing to a small, stable catalogue of plateau values."
        ),
        "rows": rows,
    }


def mutual_information(joint):
    total = sum(joint.values())
    left = Counter()
    right = Counter()
    for (a, b), count in joint.items():
        left[a] += count
        right[b] += count
    return sum((count / total) * math.log(count * total / (left[a] * right[b]))
               for (a, b), count in joint.items() if count)


def local_cumulant_row(q, size):
    points = [point for point in prime_points(q)
              if (point[1] ** 2 - point[0] * point[2]) % q]
    signs = [[0] * len(points) for _ in points]
    inv2 = pow(2, -1, q)
    for i, left in enumerate(points):
        qleft = (left[1] ** 2 - left[0] * left[2]) % q
        for j in range(i + 1, len(points)):
            right = points[j]
            qright = (right[1] ** 2 - right[0] * right[2]) % q
            bilinear = (left[1] * right[1]
                        - (left[0] * right[2] + left[2] * right[0]) * inv2) % q
            discriminant = (bilinear * bilinear - qleft * qright) % q
            sign = 0 if discriminant == 0 else (
                1 if pow(discriminant, (q - 1) // 2, q) == 1 else -1
            )
            signs[i][j] = signs[j][i] = sign

    edge_count_histogram = Counter()
    adjacent_joint = Counter()
    disjoint_joint = Counter()
    triangle_products = Counter()
    four_cycle_products = Counter()
    general_position = 0
    all_negative = 0
    for indexes in combinations(range(len(points)), size):
        if any(determinant_mod_q(points[i], points[j], points[k], q) == 0
               for i, j, k in combinations(indexes, 3)):
            continue
        general_position += 1
        edge_signs = [signs[i][j] for i, j in combinations(indexes, 2)]
        edge_count_histogram[(edge_signs.count(-1), edge_signs.count(0), edge_signs.count(1))] += 1
        all_negative += all(sign == -1 for sign in edge_signs)
        if size >= 4:
            a, b, c, d = indexes[:4]
            adjacent_joint[(signs[a][b], signs[a][c])] += 1
            disjoint_joint[(signs[a][b], signs[c][d])] += 1
            for i, j, k in combinations(indexes, 3):
                triangle_products[signs[i][j] * signs[j][k] * signs[k][i]] += 1
            cycles = [
                ((a, b), (b, c), (c, d), (d, a)),
                ((a, b), (b, d), (d, c), (c, a)),
                ((a, c), (c, b), (b, d), (d, a)),
            ]
            for cycle in cycles:
                value = 1
                for i, j in cycle:
                    value *= signs[i][j]
                four_cycle_products[value] += 1
    return {
        "q": q,
        "tuple_size": size,
        "general_position_sets": general_position,
        "all_negative_sets": all_negative,
        "all_negative_fraction": round(all_negative / general_position, 12),
        "edge_count_histogram": {str(key): value for key, value in sorted(edge_count_histogram.items())},
        "adjacent_edge_mutual_information_nats": round(mutual_information(adjacent_joint), 12),
        "disjoint_edge_mutual_information_nats": round(mutual_information(disjoint_joint), 12),
        "triangle_product_histogram": dict(sorted(triangle_products.items())),
        "four_cycle_product_histogram": dict(sorted(four_cycle_products.items())),
    }


def local_cumulant_test():
    rows = [local_cumulant_row(q, size) for q, size in ((5, 4), (5, 5), (7, 4), (7, 5))]
    q11_record = next(row for row in json.loads(MASKED_AUDIT.read_text())["records"]
                      if row["q"] == 11)
    hexagon = [tuple(point) for point in q11_record["m_witness"]]
    q11_negative_fives = sum(
        all(external_join_prime(left, right, 11) for left, right in combinations(subset, 2))
        and all(determinant_mod_q(left, middle, right, 11)
                for left, middle, right in combinations(subset, 3))
        for subset in combinations(hexagon, 5)
    )
    assert q11_negative_fives == 6
    return {
        "scope": "all general-position 4- and 5-subsets of the off-conic plane at q=5,7",
        "kill_criterion": (
            "Local all-negative patterns occur with slack and the adjacent/disjoint edge "
            "mutual information or cycle biases do not yield a stable forbidden pattern."
        ),
        "rows": rows,
        "q11_hexagon_all_negative_5_subsets": q11_negative_fives,
    }


def main():
    requested = sys.argv[1:] or [
        "saturated_uncertainty", "split_support", "lloyd_moments", "prefix_entropy",
        "local_cumulants"
    ]
    result = json.loads(OUTPUT.read_text()) if OUTPUT.exists() else {"task": "C756", "tests": {}}
    result["inputs"] = {
        VERIFY_PATH.name: sha256(VERIFY_PATH.read_bytes()).hexdigest(),
        MASKED_AUDIT.name: sha256(MASKED_AUDIT.read_bytes()).hexdigest(),
        SATURATED_AUDIT.name: sha256(SATURATED_AUDIT.read_bytes()).hexdigest(),
    }
    runners = {
        "saturated_uncertainty": saturated_uncertainty_test,
        "split_support": split_support_test,
        "lloyd_moments": lloyd_moment_test,
        "prefix_entropy": prefix_entropy_test,
        "local_cumulants": local_cumulant_test,
    }
    for name in requested:
        result["tests"][name] = runners[name]()
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
