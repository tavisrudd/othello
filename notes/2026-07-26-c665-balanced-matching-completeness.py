#!/usr/bin/env python3
"""Exact finite realization check for C665 balanced matching orbits."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


SCHEMA = "c665-balanced-matching-completeness-v1"
OUTPUT = Path(__file__).with_suffix(".json")


def normalize_matrix(entries, q):
    pivot = next(x for x in entries if x % q)
    scale = pow(pivot, -1, q)
    return tuple(x * scale % q for x in entries)


def mobius(entries, x, q):
    a, b, c, d = entries
    if x == q:
        return q if c == 0 else a * pow(c, -1, q) % q
    denominator = (c * x + d) % q
    return q if denominator == 0 else (a * x + b) * pow(denominator, -1, q) % q


def projective_groups(q):
    actions = {}
    for entries in itertools.product(range(q), repeat=4):
        a, b, c, d = entries
        determinant = (a * d - b * c) % q
        if determinant == 0 or normalize_matrix(entries, q) != entries:
            continue
        permutation = tuple(mobius(entries, x, q) for x in range(q + 1))
        actions[permutation] = determinant
    squares = {x * x % q for x in range(1, q)}
    pgl = set(actions)
    psl = {g for g, determinant in actions.items() if determinant in squares}
    assert len(pgl) == q * (q * q - 1)
    assert len(psl) * 2 == len(pgl)
    return pgl, psl


def perfect_matchings(vertices):
    vertices = tuple(vertices)
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for index in range(1, len(vertices)):
        second = vertices[index]
        rest = vertices[1:index] + vertices[index + 1 :]
        for matching in perfect_matchings(rest):
            yield ((first, second),) + matching


def image(g, matching):
    return tuple(sorted(tuple(sorted((g[a], g[b]))) for a, b in matching))


def orbit(generators, matching):
    return {image(g, matching) for g in generators}


def permutation_order(g):
    seen = set()
    answer = 1
    for start in range(len(g)):
        if start in seen:
            continue
        length = 0
        x = start
        while x not in seen:
            seen.add(x)
            length += 1
            x = g[x]
        answer = answer * length // gcd(answer, length)
    return answer


def gcd(a, b):
    while b:
        a, b = b, a % b
    return a


def order_histogram(group):
    result = {}
    for g in group:
        order = str(permutation_order(g))
        result[order] = result.get(order, 0) + 1
    return dict(sorted(result.items(), key=lambda item: int(item[0])))


def subgroup_orbits(group, domain):
    unseen = set(domain)
    answer = []
    while unseen:
        base = min(unseen)
        part = orbit(group, base)
        answer.append(sorted(part))
        unseen -= part
    return sorted(answer, key=lambda part: (len(part), part))


def homogeneous_basis(degree):
    return tuple(
        (i, j, degree - i - j)
        for i in range(degree + 1)
        for j in range(degree - i + 1)
    )


def multiply(left, right, q):
    answer = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(a[i] + b[i] for i in range(3))
            answer[exponent] = (answer.get(exponent, 0) + ca * cb) % q
    return {e: c for e, c in answer.items() if c}


def matching_product(matching, q):
    endpoints = tuple((x, 1) for x in range(q)) + ((1, 0),)
    answer = {(0, 0, 0): 1}
    for left, right in matching:
        si, ti = endpoints[left]
        sj, tj = endpoints[right]
        line = {
            (1, 0, 0): ti * tj % q,
            (0, 1, 0): -(si * tj + ti * sj) % q,
            (0, 0, 1): si * sj % q,
        }
        answer = multiply(answer, line, q)
    return answer


def rref(matrix, q):
    data = [[x % q for x in row] for row in matrix]
    if not data:
        return data, []
    row = 0
    pivots = []
    for column in range(len(data[0])):
        pivot = next((i for i in range(row, len(data)) if data[i][column]), None)
        if pivot is None:
            continue
        data[row], data[pivot] = data[pivot], data[row]
        scale = pow(data[row][column], -1, q)
        data[row] = [x * scale % q for x in data[row]]
        for i in range(len(data)):
            if i == row or data[i][column] == 0:
                continue
            scale = data[i][column]
            data[i] = [(x - scale * y) % q for x, y in zip(data[i], data[row])]
        pivots.append(column)
        row += 1
        if row == len(data):
            break
    return data, pivots


def rank(matrix, q):
    return len(rref(matrix, q)[1])


def nullspace(matrix, q):
    reduced, pivots = rref(matrix, q)
    columns = len(matrix[0]) if matrix else 0
    free = [column for column in range(columns) if column not in pivots]
    answer = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % q
        answer.append(vector)
    return answer


def row_basis(matrix, q):
    reduced, _ = rref(matrix, q)
    return [row for row in reduced if any(row)]


def quotient_by_conic(difference, degree, q):
    source = homogeneous_basis(degree)
    target = homogeneous_basis(degree + 2)
    target_index = {e: i for i, e in enumerate(target)}
    equations = [[0] * len(source) for _ in target]
    conic = {(1, 0, 1): 1, (0, 2, 0): -1 % q}
    for column, monomial in enumerate(source):
        for exponent, coefficient in multiply({monomial: 1}, conic, q).items():
            equations[target_index[exponent]][column] = coefficient
    augmented = [
        row + [difference.get(exponent, 0) % q]
        for row, exponent in zip(equations, target)
    ]
    reduced, pivots = rref(augmented, q)
    assert len(source) not in pivots
    answer = [0] * len(source)
    for row, pivot in enumerate(pivots):
        if pivot < len(source):
            answer[pivot] = reduced[row][-1]
    check = multiply(
        {monomial: coefficient for monomial, coefficient in zip(source, answer) if coefficient},
        conic,
        q,
    )
    assert all(check.get(e, 0) == difference.get(e, 0) % q for e in target)
    return answer


def schur_power_rank(linear_rows, power, q):
    products = []
    for indices in itertools.combinations_with_replacement(range(len(linear_rows)), power):
        row = [1] * len(linear_rows[0])
        for index in indices:
            row = [x * y % q for x, y in zip(row, linear_rows[index])]
        products.append(row)
    return rank(products, q)


def evaluation_record(full_orbit, psl_parts, q):
    ordered_orbit = sorted(full_orbit)
    base = ordered_orbit[0]
    base_product = matching_product(base, q)
    quotient_degree = (q - 3) // 2
    points = []
    for matching in ordered_orbit:
        product = matching_product(matching, q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % q
            for exponent in set(product) | set(base_product)
        }
        points.append(quotient_by_conic(difference, quotient_degree, q))
    rows = [[1] * len(points)]
    rows.extend([list(column) for column in zip(*points)])
    linear = row_basis(rows, q)
    square_rows = []
    for i in range(len(linear)):
        for j in range(i, len(linear)):
            square_rows.append([x * y % q for x, y in zip(linear[i], linear[j])])
    trades = nullspace(square_rows, q)
    result = {
        "affine_linear_rank": len(linear),
        "quotient_degree": quotient_degree,
        "schur_square_rank": rank(square_rows, q),
        "schur_cube_rank": schur_power_rank(linear, 3, q),
        "quadratic_trade_dimension": len(trades),
    }
    if len(trades) == 1:
        trade = trades[0]
        scale = pow(next(x for x in trade if x), -1, q)
        trade = [x * scale % q for x in trade]
        values = sorted(set(trade))
        levels = [[ordered_orbit[i] for i, x in enumerate(trade) if x == value] for value in values]
        edges = [tuple(pair) for pair in itertools.combinations(range(q + 1), 2)]
        multiplicities = []
        for level in levels:
            counts = {edge: 0 for edge in edges}
            for matching in level:
                for edge in matching:
                    counts[edge] += 1
            multiplicities.append(sorted(set(counts.values())))
        recovered = {frozenset(level) for level in levels}
        special = {frozenset(level) for level in psl_parts}
        result.update(
            {
                "quadratic_trade_full_support": all(trade),
                "quadratic_trade_values": values,
                "recovered_level_sizes": [len(level) for level in levels],
                "recovered_edge_multiplicities": multiplicities,
                "recovered_levels_are_one_factorizations": multiplicities == [[1], [1]],
                "recovered_partition_equals_psl_orbits": recovered == special,
            }
        )
    return result


def field_record(q):
    pgl, psl = projective_groups(q)
    matchings = sorted(perfect_matchings(range(q + 1)))
    pgl_parts = subgroup_orbits(pgl, matchings)
    records = []
    for part in pgl_parts:
        base = part[0]
        full_stabilizer = {g for g in pgl if image(g, base) == base}
        special_stabilizer = full_stabilizer & psl
        psl_parts = subgroup_orbits(psl, part)
        record = {
            "representative": [list(pair) for pair in base],
            "size": len(part),
            "full_stabilizer_order": len(full_stabilizer),
            "full_stabilizer_order_histogram": order_histogram(full_stabilizer),
            "psl_stabilizer_order": len(special_stabilizer),
            "psl_stabilizer_order_histogram": order_histogram(special_stabilizer),
            "psl_orbit_sizes": sorted(len(x) for x in psl_parts),
            "balanced_2q_split": len(part) == 2 * q
            and sorted(len(x) for x in psl_parts) == [q, q],
        }
        if record["balanced_2q_split"] or (q == 5 and len(part) == 10):
            record["evaluation"] = evaluation_record(part, psl_parts, q)
        records.append(record)
    return {
        "q": q,
        "pgl_order": len(pgl),
        "psl_order": len(psl),
        "perfect_matching_count": len(matchings),
        "orbit_count": len(records),
        "orbits": records,
    }


def certificate():
    fields = [field_record(q) for q in (5, 7, 11)]
    balanced = [
        (field["q"], orbit["size"])
        for field in fields
        for orbit in field["orbits"]
        if orbit["balanced_2q_split"]
    ]
    assert balanced == [(7, 14), (11, 22)]
    q5_ten = next(orbit for orbit in fields[0]["orbits"] if orbit["size"] == 10)
    assert q5_ten["psl_orbit_sizes"] == [10]
    assert q5_ten["evaluation"]["schur_square_rank"] == 10
    for field in fields[1:]:
        target = next(orbit for orbit in field["orbits"] if orbit["balanced_2q_split"])
        assert target["evaluation"]["affine_linear_rank"] == field["q"]
        assert target["evaluation"]["schur_square_rank"] == 2 * field["q"] - 1
        assert target["evaluation"]["schur_cube_rank"] == 2 * field["q"]
        assert target["evaluation"]["quadratic_trade_dimension"] == 1
        assert target["evaluation"]["quadratic_trade_values"] == [1, field["q"] - 1]
        assert target["evaluation"]["recovered_level_sizes"] == [field["q"], field["q"]]
        assert target["evaluation"]["recovered_levels_are_one_factorizations"]
        assert target["evaluation"]["recovered_partition_equals_psl_orbits"]
    return {
        "schema": SCHEMA,
        "scope": {
            "fields_checked": [5, 7, 11],
            "objects": "all perfect matchings of P1(F_q), partitioned by full PGL2(q)",
            "stop_condition": "the three fields surviving the human index-q subgroup reduction",
        },
        "fields": fields,
        "verdict": {
            "balanced_fields": [7, 11],
            "q5_ten_orbit_psl_split": [10],
            "q5_ten_orbit_schur_square_rank": 10,
            "recovering_balanced_fields": [7, 11],
        },
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    data = canonical_bytes(certificate())
    if arguments.write:
        OUTPUT.write_bytes(data)
        print(f"wrote {OUTPUT.name} sha256={hashlib.sha256(data).hexdigest()}")
        return
    assert OUTPUT.read_bytes() == data
    print(f"C665 primary check: OK sha256={hashlib.sha256(data).hexdigest()}")


if __name__ == "__main__":
    main()
