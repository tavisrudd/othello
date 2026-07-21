#!/usr/bin/env python3
"""Independent direct-plane replay for C460; imports no primary C460 code."""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import Counter, deque
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
C446 = HERE / "2026-07-21-c446-marker-matching-concurrency.json"
C458 = HERE / "2026-07-21-c458-golden-sheet-frame-freeze.json"
EXPECTED = HERE / "2026-07-21-c460-golden-fregier-cloud-bridge.json"


def norm(vector, q):
    vector = tuple(value % q for value in vector)
    pivot = next(value for value in vector if value)
    inverse = pow(pivot, -1, q)
    return tuple(value * inverse % q for value in vector)


def cross(a, b, q):
    return norm((a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]), q)


def incident(point, line, q):
    return sum(x * y for x, y in zip(point, line)) % q == 0


def image(permutation, matching):
    return tuple(sorted(tuple(sorted((permutation[a], permutation[b]))) for a, b in matching))


def pgl(q):
    labels = tuple([(1, x) for x in range(q)] + [(0, 1)])
    index = {point: i for i, point in enumerate(labels)}
    answer = set()
    for a, b, c, d in itertools.product(range(q), repeat=4):
        if (a * d - b * c) % q == 0:
            continue
        answer.add(tuple(index[norm((a * s + b * t, c * s + d * t), q)] for s, t in labels))
    assert len(answer) == q * (q * q - 1)
    return answer


def rank(rows, field=None):
    convert = (lambda x: Fraction(x)) if field is None else (lambda x: x % field)
    matrix = [[convert(value) for value in row] for row in rows]
    result = 0
    for column in range(len(matrix[0])):
        pivot = next((row for row in range(result, len(matrix)) if matrix[row][column]), None)
        if pivot is None:
            continue
        matrix[result], matrix[pivot] = matrix[pivot], matrix[result]
        value = matrix[result][column]
        inverse = Fraction(1, 1) / value if field is None else pow(value, -1, field)
        matrix[result] = [entry * inverse if field is None else entry * inverse % field for entry in matrix[result]]
        for row in range(result + 1, len(matrix)):
            factor = matrix[row][column]
            if factor:
                matrix[row] = [
                    entry - factor * pivot_value if field is None else (entry - factor * pivot_value) % field
                    for entry, pivot_value in zip(matrix[row], matrix[result])
                ]
        result += 1
    return result


def direct_case(item):
    q = item["field_order"]
    records = item["matching_records"]
    targets = [tuple(tuple(edge) for edge in record["matching"]) for record in records]
    sheets = [record["psl_sheet"] for record in records]
    edge_line = {}
    for record in records:
        for edge, line in zip(record["matching"], record["secant_lines"]):
            edge = tuple(edge)
            line = tuple(line)
            assert edge not in edge_line or edge_line[edge] == line
            edge_line[edge] = line
    assert len(edge_line) == q * (q + 1) // 2

    conic = []
    for endpoint in range(q + 1):
        lines = [line for edge, line in edge_line.items() if endpoint in edge]
        point = cross(lines[0], lines[1], q)
        assert all(incident(point, line, q) for line in lines)
        conic.append(point)
    assert len(set(conic)) == q + 1

    projective_plane = sorted({norm(vector, q) for vector in itertools.product(range(q), repeat=3) if any(vector)})
    interior = []
    pencils = {}
    for point in projective_plane:
        if point in conic:
            continue
        pencil = tuple(sorted(edge for edge, line in edge_line.items() if incident(point, line, q)))
        if len(pencil) == (q + 1) // 2:
            assert len(set().union(*map(set, pencil))) == q + 1
            interior.append(point)
            pencils[point] = pencil
    assert len(interior) == q * (q - 1) // 2

    clouds = [frozenset(point for point in interior if len(set(target) & set(pencils[point])) == 2) for target in targets]
    expected_size = len(targets[0]) * (len(targets[0]) - 1) // 2
    assert Counter(map(len, clouds)) == {expected_size: len(targets)}
    matrix = [[int(point in cloud) for point in interior] for cloud in clouds]
    overlaps = {"same_sheet": Counter(), "cross_sheet": Counter()}
    for left, right in itertools.combinations(range(len(targets)), 2):
        key = "same_sheet" if sheets[left] == sheets[right] else "cross_sheet"
        overlaps[key][len(clouds[left] & clouds[right])] += 1
    return {
        "q": q,
        "targets": targets,
        "sheets": sheets,
        "interior": interior,
        "pencils": pencils,
        "clouds": clouds,
        "matrix": matrix,
        "counts": [len(targets), expected_size, len(interior)],
        "overlaps": {key: {str(k): v for k, v in sorted(hist.items())} for key, hist in overlaps.items()},
        "ranks": {"Q": rank(matrix), **{str(p): rank(matrix, p) for p in (2, 3, 5, 7, 11, 13)}},
        "edge_line": edge_line,
    }


def h3_graph(case):
    adjacency = [[] for _ in case["targets"]]
    for left, right in itertools.combinations(range(22), 2):
        if len(case["clouds"][left] & case["clouds"][right]) == 5:
            adjacency[left].append(right)
            adjacency[right].append(left)
    assert Counter(map(len, adjacency)) == {6: 22}
    colors = {0: 0}
    queue = deque([0])
    while queue:
        vertex = queue.popleft()
        for neighbor in adjacency[vertex]:
            if neighbor not in colors:
                colors[neighbor] = 1 - colors[vertex]
                queue.append(neighbor)
            else:
                assert colors[neighbor] != colors[vertex]
    assert len(colors) == 22
    parts = {frozenset(i for i, color in colors.items() if color == side) for side in (0, 1)}
    frozen = {frozenset(i for i, sheet in enumerate(case["sheets"]) if sheet == side) for side in (0, 1)}
    assert parts == frozen
    return adjacency


def parse_phi(text):
    text = text.replace(" ", "")
    if "phi" not in text:
        return Fraction(int(text)), Fraction(0)
    prefix = text[:-4]
    split = max([i for i in range(1, len(prefix)) if prefix[i] in "+-"] or [-1])
    return ((Fraction(int(prefix[:split])), Fraction(int(prefix[split:]))) if split >= 0
            else (Fraction(0), Fraction(int(prefix))))


def mul(x, y):
    return x[0] * y[0] + x[1] * y[1], x[0] * y[1] + x[1] * y[0] + x[1] * y[1]


def dot(x, y):
    out = (Fraction(0), Fraction(0))
    for a, b in zip(x, y):
        product = mul(a, b)
        out = out[0] + product[0], out[1] + product[1]
    return out


def reduce_axis(axis, tau):
    return norm(tuple(int((a + tau * b) % 11) for a, b in axis), 11)


def golden_check(frozen, case, expected):
    gold = [tuple(parse_phi(x) for x in row) for row in frozen["golden_sheet_frame"]["six_arc_over_Q_phi"]]
    mate = [tuple(parse_phi(x) for x in row) for row in frozen["golden_sheet_frame"]["conjugate_six_arc_over_Q_phi"]]
    pairs = []
    for axis in gold:
        hits = [other for other in mate if dot(axis, other) == (0, 0)]
        assert len(hits) == 1
        pairs.append((axis, hits[0]))
    shadow = {cross(reduce_axis(a, 8), reduce_axis(b, 8), 11) for a, b in pairs}
    base = tuple(tuple(edge) for edge in expected["golden_pair"]["base_matching"])
    jmate = tuple(tuple(edge) for edge in expected["golden_pair"]["jmate_matching"])
    i = case["targets"].index(base)
    j = case["targets"].index(jmate)
    triangle = case["clouds"][i] & case["clouds"][j]
    assert len(shadow) == 3 and shadow == triangle

    actions = pgl(11)
    point_for_pencil = {pencil: point for point, pencil in case["pencils"].items()}
    def move_point(g, point):
        return point_for_pencil[image(g, case["pencils"][point])]
    stabilizer = {g for g in actions if {move_point(g, point) for point in triangle} == set(triangle)}
    common = {g for g in actions if image(g, base) == base and image(g, jmate) == jmate}
    assert len(stabilizer) == 24 and len(common) == 12
    cube = tuple(tuple(edge) for edge in expected["golden_pair"]["unique_S4_invariant_matching"]["matching"])
    assert all(image(g, cube) == cube for g in stabilizer)
    assert rank([case["edge_line"][edge] for edge in cube], 11) == 3


def main():
    source = json.loads(C446.read_text())
    frozen = json.loads(C458.read_text())
    expected = json.loads(EXPECTED.read_text())
    assert expected["consumes"]["C446"]["sha256"] == hashlib.sha256(C446.read_bytes()).hexdigest()
    assert expected["consumes"]["C458"]["sha256"] == hashlib.sha256(C458.read_bytes()).hexdigest()
    cases = {item["type"]: direct_case(item) for item in source["types"] if item["type"] in ("B3", "H3")}
    h3_graph(cases["H3"])
    golden_check(frozen, cases["H3"], expected)
    for name, case in cases.items():
        recorded = expected["cloud_cases"][name]
        assert case["counts"] == [recorded["target_matching_count"], recorded["cloud_size"], recorded["interior_point_count"]]
        assert case["overlaps"] == recorded["cloud_overlap_histograms"]
        assert case["ranks"]["Q"] == recorded["incidence"]["rank_over_Q"]
        for field in (2, 3, 5, 7, 11, 13):
            assert case["ranks"][str(field)] == recorded["incidence"]["small_field_ranks"][str(field)]["rank"]
    print("C460 independent direct-plane replay OK")


if __name__ == "__main__":
    main()
