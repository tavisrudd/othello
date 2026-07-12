#!/usr/bin/env python3
"""Audit low-degree projective signatures of q=17 forced C77 replies.

The exact solver's ``replygraphs`` mode reports the unique winning reply at
degree-one opponent moves.  This script reruns the six coarse balanced-root
representatives and tests conic incidences among the root, move, reply, and the
two burned directions.  It is a diagnostic for an adaptive algebraic reply
lemma, not a game-value certificate.
"""

from collections import Counter
from functools import lru_cache
from itertools import combinations, permutations, product
import argparse
import re
import subprocess

from c77_balanced_mirror_probe import (
    residual_signature, root_safe_mirrors_for, run as mirror_run, transformations,
)
from c77_intruder_reply_graph import legal_moves


ROOTS = (
    ((0, 0), (1, 1), (2, 3), (3, 4)),
    ((0, 0), (1, 1), (2, 3), (12, 13)),
    ((0, 0), (1, 1), (2, 5), (5, 2)),
    ((0, 0), (1, 1), (2, 5), (5, 8)),
    ((0, 0), (1, 1), (2, 6), (6, 10)),
    ((0, 0), (1, 1), (2, 6), (6, 2)),
)

LINE = re.compile(r"REPLYGRAPHS-FORCED q=(\d+) root=\[(.*?)\] pairs=\[(.*)\]")
PAIR = re.compile(
    r"REPLYGRAPHS-PAIR root-index=(\d+) x=(\d+),(\d+) y=(\d+),(\d+) "
    r"value=([PN]) live=(\d+)"
)
POINT = re.compile(r"\((\d+), (\d+)\)")


def conflict_witnesses(q, root, a, b):
    witnesses = []
    if a[0] == b[0]:
        witnesses.append("row")
    if a[1] == b[1]:
        witnesses.append("col")
    for index, selected in enumerate(root):
        if ((a[0] - selected[0]) * (b[1] - selected[1])
                - (a[1] - selected[1]) * (b[0] - selected[0])) % q == 0:
            witnesses.append(index)
    return tuple(witnesses)


def conflict_edges(q, root, vertices):
    edges = set()
    for a, b in combinations(vertices, 2):
        witnesses = conflict_witnesses(q, root, a, b)
        assert len(witnesses) <= 1, (root, a, b, witnesses)
        if witnesses:
            edges.add(frozenset((a, b)))
    return edges


@lru_cache(maxsize=None)
def cached_conflict_state(q, root):
    vertices = tuple(legal_moves(q, root))
    return vertices, frozenset(conflict_edges(q, root, vertices))


@lru_cache(maxsize=None)
def transition_features(q, s5, reply):
    vertices5, edges5_frozen = cached_conflict_state(q, s5)
    edges5 = set(edges5_frozen)
    killed = {reply}
    killed.update(next(iter(edge - {reply})) for edge in edges5 if reply in edge)
    vertices6, edges6_frozen = cached_conflict_state(q, s5 + (reply,))
    assert set(vertices6) == set(vertices5) - killed
    edges6 = set(edges6_frozen)
    old_surviving = {edge for edge in edges5 if edge.isdisjoint(killed)}
    assert old_surviving <= edges6
    removed = len(edges5) - len(old_surviving)
    added = len(edges6 - old_surviving)
    loads = Counter(direction(reply, vertex, q) for vertex in vertices6)
    added_formula = sum(load * (load - 1) // 2 for load in loads.values())
    assert added_formula == added
    load_pattern = tuple(sorted(Counter(load % 3 for load in loads.values()).items()))
    return removed % 3, added % 3, (added - removed) % 3, load_pattern


def relative_direction_relations(q, s5, reply):
    """Field-label-free incidences between the five new rays and old secants."""
    old_by_direction = {}
    for i, j in combinations(range(len(s5)), 2):
        old_by_direction.setdefault(direction(s5[i], s5[j], q), []).append((i, j))
    incidences = tuple(
        tuple(old_by_direction.get(direction(reply, point, q), ()))
        for point in s5
    )
    indexed_loads = tuple(len(edges) for edges in incidences)
    load_profile = tuple(sorted(indexed_loads))
    reply_directions = [direction(reply, point, q) for point in s5]
    finite_nonzero = [value for value in reply_directions if value not in (0, q)]
    quotient_counts = Counter(
        left * pow(right, -1, q) % q
        for left in finite_nonzero for right in finite_nonzero if left != right
    )
    quotient_size = len(quotient_counts)
    quotient_max = max(quotient_counts.values(), default=0)
    return load_profile, indexed_loads, incidences, quotient_size, quotient_max


def projective_character_tag(value, q):
    return "inf" if value == q else quadratic_character(value, q)


def arithmetic_ray_features(q, s5, reply):
    """Small coordinate-invariant character/energy summaries of the five reply rays."""
    rays = tuple(((point[0] - reply[0]) % q, (point[1] - reply[1]) % q) for point in s5)
    secants = tuple(
        ((right[0] - left[0]) % q, (right[1] - left[1]) % q)
        for left, right in combinations(s5, 2)
    )

    vandermonde = 1
    for left, right in combinations(rays, 2):
        determinant = det2(left, right, q)
        assert determinant
        vandermonde = vandermonde * determinant % q
    vandermonde_character = quadratic_character(vandermonde, q)

    ray_cross_ratios = Counter()
    for a, b, c, d in combinations(rays, 4):
        for x, y, z, w in ((a, b, c, d), (a, c, b, d), (a, d, b, c)):
            ray_cross_ratios[projective_character_tag(
                cross_ratio_projective(x, y, z, w, q), q
            )] += 1
    ray_cross_ratio_profile = tuple(sorted(ray_cross_ratios.items(), key=repr))

    determinant_characters = Counter(
        quadratic_character(det2(ray, secant, q), q)
        for ray in rays for secant in secants
    )
    ray_secant_determinants = (
        determinant_characters[0],
        *sorted((determinant_characters[-1], determinant_characters[1])),
    )
    triangle = (
        (s5[1][0] - s5[0][0]) % q, (s5[1][1] - s5[0][1]) % q,
    ), (
        (s5[2][0] - s5[0][0]) % q, (s5[2][1] - s5[0][1]) % q,
    )
    orientation_character = quadratic_character(det2(*triangle, q), q)
    oriented_determinant_sum = orientation_character * (
        determinant_characters[1] - determinant_characters[-1]
    )

    row_vandermonde = 1
    col_vandermonde = 1
    for left, right in combinations(s5, 2):
        row_vandermonde = row_vandermonde * (right[0] - left[0]) % q
        col_vandermonde = col_vandermonde * (right[1] - left[1]) % q
    base_vandermonde_characters = (
        quadratic_character(row_vandermonde, q),
        quadratic_character(col_vandermonde, q),
    )
    relative_vandermonde = tuple(sorted(
        vandermonde_character * character
        for character in base_vandermonde_characters
    ))

    mixed_cross_ratios = Counter()
    for ray_a, ray_b in combinations(rays, 2):
        for secant_a, secant_b in combinations(secants, 2):
            mixed_cross_ratios[projective_character_tag(
                cross_ratio_projective(ray_a, ray_b, secant_a, secant_b, q), q
            )] += 1
    mixed_cross_ratio_profile = tuple(sorted(mixed_cross_ratios.items(), key=repr))
    return (
        vandermonde_character,
        ray_cross_ratio_profile,
        ray_secant_determinants,
        mixed_cross_ratio_profile,
        oriented_determinant_sum,
        relative_vandermonde,
    )


def base_parallelism_incidence(q, s5):
    """Parallel classes and a value-opaque ratio spectrum for the current S5."""
    by_direction = {}
    for i, j in combinations(range(len(s5)), 2):
        by_direction.setdefault(direction(s5[i], s5[j], q), []).append((i, j))
    finite_nonzero = [value for value in by_direction if value not in (0, q)]
    quotient_counts = Counter(
        left * pow(right, -1, q) % q
        for left in finite_nonzero for right in finite_nonzero if left != right
    )
    quotient_profile = tuple(sorted(Counter(quotient_counts.values()).items()))
    return (
        tuple(sorted(tuple(edges) for edges in by_direction.values())),
        len(quotient_counts), quotient_profile,
    )


def apply_grid_transform(q, transform, point):
    swap, a, b, d, e = transform
    r, c = point
    if swap:
        r, c = c, r
    return ((a * r + b) % q, (d * c + e) % q)


def grid_stabilizer(q, points):
    """Full independent-affine/swap stabilizer of a labelled-grid cap set."""
    target = set(points)
    target_rows = [point[0] for point in points]
    target_cols = [point[1] for point in points]
    stabilizer = set()
    for swap in (False, True):
        source = tuple((c, r) if swap else (r, c) for r, c in points)
        p0, p1 = source[:2]
        row_den_inv = pow((p1[0] - p0[0]) % q, -1, q)
        col_den_inv = pow((p1[1] - p0[1]) % q, -1, q)
        for row0, row1 in permutations(target_rows, 2):
            a = (row1 - row0) * row_den_inv % q
            b = (row0 - a * p0[0]) % q
            for col0, col1 in permutations(target_cols, 2):
                d = (col1 - col0) * col_den_inv % q
                e = (col0 - d * p0[1]) % q
                transform = (swap, a, b, d, e)
                if {apply_grid_transform(q, transform, point) for point in points} == target:
                    stabilizer.add(transform)
    return tuple(stabilizer)


def rank_mod(rows, q):
    rows = [[x % q for x in row] for row in rows]
    rank = 0
    for col in range(len(rows[0]) if rows else 0):
        pivot = next((i for i in range(rank, len(rows)) if rows[i][col]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inv = pow(rows[rank][col], -1, q)
        rows[rank] = [(x * inv) % q for x in rows[rank]]
        for i in range(len(rows)):
            if i == rank or rows[i][col] == 0:
                continue
            a = rows[i][col]
            rows[i] = [(x - a * y) % q for x, y in zip(rows[i], rows[rank])]
        rank += 1
    return rank


def solve_linear(matrix, rhs, q):
    rows = [[x % q for x in row] + [b % q] for row, b in zip(matrix, rhs)]
    for col in range(len(matrix)):
        pivot = next(i for i in range(col, len(rows)) if rows[i][col])
        rows[col], rows[pivot] = rows[pivot], rows[col]
        inv = pow(rows[col][col], -1, q)
        rows[col] = [(x * inv) % q for x in rows[col]]
        for i in range(len(rows)):
            if i == col:
                continue
            a = rows[i][col]
            rows[i] = [(x - a * y) % q for x, y in zip(rows[i], rows[col])]
    return tuple(row[-1] for row in rows)


def conic_rank(points, q):
    rows = []
    for x, y, z in points:
        rows.append((x * x, y * y, z * z, x * y, x * z, y * z))
    return rank_mod(rows, q)


def projective(point):
    return (point[0], point[1], 1)


def parse_forced(output):
    records = []
    for line in output.splitlines():
        match = LINE.fullmatch(line)
        if not match:
            continue
        root = tuple((int(a), int(b)) for a, b in POINT.findall(match.group(2)))
        flat = [(int(a), int(b)) for a, b in POINT.findall(match.group(3))]
        assert len(flat) % 2 == 0
        pairs = tuple(zip(flat[::2], flat[1::2]))
        records.append((root, pairs))
    return records


def parse_pairs(output):
    records = []
    for match in PAIR.finditer(output):
        records.append((
            int(match.group(1)),
            (int(match.group(2)), int(match.group(3))),
            (int(match.group(4)), int(match.group(5))),
            match.group(6),
            int(match.group(7)),
        ))
    return records


@lru_cache(maxsize=None)
def conic_model(root, q):
    """Return D,E,k for (x+E)(y+D)=k through root's first three points."""
    matrix = [(x, y, 1) for x, y in root[:3]]
    rhs = [(-x * y) % q for x, y in root[:3]]
    d, e, f = solve_linear(matrix, rhs, q)
    k = (d * e - f) % q
    assert k
    assert all(((x + e) * (y + d) - k) % q == 0 for x, y in root[:3])
    assert ((root[3][0] + e) * (root[3][1] + d) - k) % q != 0
    return d, e, k


def matmul(a, b, q):
    return (
        ((a[0] * b[0] + a[1] * b[2]) % q,
         (a[0] * b[1] + a[1] * b[3]) % q,
         (a[2] * b[0] + a[3] * b[2]) % q,
         (a[2] * b[1] + a[3] * b[3]) % q)
    )


def matapply(matrix, point, q):
    return ((matrix[0] * point[0] + matrix[1] * point[1]) % q,
            (matrix[2] * point[0] + matrix[3] * point[1]) % q)


def det2(a, b, q):
    return (a[0] * b[1] - a[1] * b[0]) % q


def cross_ratio_projective(a, b, c, d, q):
    numerator = det2(a, c, q) * det2(b, d, q) % q
    denominator = det2(a, d, q) * det2(b, c, q) % q
    if denominator == 0:
        return q  # infinity sentinel, ordered after field elements
    return numerator * pow(denominator, -1, q) % q


def compose(matrices, q):
    if any(matrix is None for matrix in matrices):
        return None
    product = (1, 0, 0, 1)
    for matrix in matrices:
        product = matmul(product, matrix, q)
    return product


def matinv_projective(matrix, q):
    if matrix is None:
        return None
    return (matrix[3], -matrix[1] % q, -matrix[2] % q, matrix[0])


def projectively_equal(a, b, q):
    if a is None or b is None:
        return False
    pivot = next((i for i in range(4) if a[i] or b[i]), None)
    if pivot is None or not a[pivot] or not b[pivot]:
        return False
    return all(a[i] * b[pivot] % q == b[i] * a[pivot] % q for i in range(4))


def common_torus_gate(root, move, reply, q):
    """Necessary commuting-rotation gate for three reflections in one torus normalizer."""
    model = conic_model(root, q)
    center = involution(root[3], model, q)
    x = involution(move, model, q)
    y = involution(reply, model, q)
    if x is None or y is None:
        return "boundary"
    a = compose((center, x), q)
    b = compose((center, y), q)
    return "commuting" if projectively_equal(matmul(a, b, q), matmul(b, a, q), q) \
        else "noncommuting"


def pgl_order(matrix, q):
    if matrix is None:
        return None
    power = (1, 0, 0, 1)
    for order in range(1, 2 * q + 2):
        power = matmul(power, matrix, q)
        if power[1] == 0 and power[2] == 0 and power[0] == power[3] and power[0] != 0:
            return order
    raise AssertionError((q, matrix, power))


def quadratic_character(value, q):
    value %= q
    if value == 0:
        return 0
    return 1 if pow(value, (q - 1) // 2, q) == 1 else -1


@lru_cache(maxsize=None)
def frame_action_profile(matrix, frame, q):
    if matrix is None:
        return None
    values = []
    for a, b in combinations(frame, 2):
        values.append(cross_ratio_projective(
            a, b, matapply(matrix, a, q), matapply(matrix, b, q), q
        ))
    return tuple(sorted(values))


def aligned_frame_profile(matrices, frame, q):
    if any(matrix is None for matrix in matrices):
        return None
    values = []
    for a, b in combinations(frame, 2):
        values.append(tuple(
            cross_ratio_projective(
                a, b, matapply(matrix, a, q), matapply(matrix, b, q), q
            ) for matrix in matrices
        ))
    return tuple(sorted(values))


def canonical_aligned_frame_profile(matrices, frame, q):
    if any(matrix is None for matrix in matrices):
        return None
    candidates = []
    for burned in permutations((0, 1)):
        for selected in permutations((2, 3, 4)):
            order = burned + selected
            values = []
            for i, j in combinations(range(5), 2):
                a, b = frame[order[i]], frame[order[j]]
                values.append(tuple(
                    cross_ratio_projective(
                        a, b, matapply(matrix, a, q), matapply(matrix, b, q), q
                    ) for matrix in matrices
                ))
            candidates.append(tuple(values))
    return min(candidates)


def involution(point, model, q):
    d, e, k = model
    r, c = (point[0] + e) % q, (point[1] + d) % q
    if (r * c - k) % q == 0:
        return None
    return (k, (-k * r) % q, c, -k % q)


def conic_parameter(point, model, q):
    d, e, k = model
    r, c = (point[0] + e) % q, (point[1] + d) % q
    return (r, 1) if (r * c - k) % q == 0 else None


def point_frame_profile(point, frame, q):
    if point is None:
        return None
    values = []
    for anchor in frame:
        others = [candidate for candidate in frame if candidate != anchor]
        for a, b in combinations(others, 2):
            values.append(cross_ratio_projective(point, anchor, a, b, q))
    return tuple(sorted(values))


def pair_frame_profile(a, b, frame, q):
    if a is None or b is None:
        return None
    return tuple(sorted(
        cross_ratio_projective(a, b, x, y, q) for x, y in combinations(frame, 2)
    ))


def boundary_profile(x_on, y_on, center, other_x, other_y, frame, q):
    relation = pair_frame_profile(x_on, y_on, frame, q)
    if x_on is not None and other_y is not None:
        relation = pair_frame_profile(x_on, matapply(other_y, x_on, q), frame, q)
    elif y_on is not None and other_x is not None:
        relation = pair_frame_profile(y_on, matapply(other_x, y_on, q), frame, q)
    center_x = pair_frame_profile(
        x_on, matapply(center, x_on, q) if x_on is not None else None, frame, q
    )
    center_y = pair_frame_profile(
        y_on, matapply(center, y_on, q) if y_on is not None else None, frame, q
    )
    center_quad = None
    if x_on is not None and y_on is not None:
        center_quad = cross_ratio_projective(
            x_on, y_on, matapply(center, x_on, q), matapply(center, y_on, q), q
        )
    return relation, center_x, center_y, center_quad


def word_character(matrices, q):
    if any(matrix is None for matrix in matrices):
        return None
    product = (1, 0, 0, 1)
    determinant = 1
    for matrix in matrices:
        product = matmul(product, matrix, q)
        determinant = determinant * (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % q
    trace = (product[0] + product[3]) % q
    return trace * trace * pow(determinant, -1, q) % q


def involution_signature(root, move, reply, q):
    model = conic_model(root, q)
    center = involution(root[3], model, q)
    x = involution(move, model, q)
    y = involution(reply, model, q)
    d, e, _k = model
    del d
    frame = ((1, 0), (0, 1)) + tuple(((point[0] + e) % q, 1) for point in root[:3])
    words = ((center, x), (center, y), (x, y),
             (center, x, y), (center, y, x))
    x_on = conic_parameter(move, model, q)
    y_on = conic_parameter(reply, model, q)
    boundary_relation = boundary_profile(x_on, y_on, center, x, y, frame, q)
    return tuple(word_character(word, q) for word in words) + tuple(
        frame_action_profile(compose(word, q), frame, q) for word in words
    ) + (point_frame_profile(x_on, frame, q), point_frame_profile(y_on, frame, q),
         boundary_relation)


def reduced_involution_signature(root, move, reply, q):
    """The minimal four-component q=17 signature found on coarse representatives."""
    model = conic_model(root, q)
    center = involution(root[3], model, q)
    x = involution(move, model, q)
    y = involution(reply, model, q)
    _d, e, _k = model
    frame = ((1, 0), (0, 1)) + tuple(((point[0] + e) % q, 1) for point in root[:3])
    x_on = conic_parameter(move, model, q)
    y_on = conic_parameter(reply, model, q)
    boundary_relation = boundary_profile(x_on, y_on, center, x, y, frame, q)
    return (
        frame_action_profile(compose((center, x), q), frame, q),
        frame_action_profile(compose((center, y), q), frame, q),
        frame_action_profile(compose((x, y), q), frame, q),
        boundary_relation,
    )


def aligned_involution_signature(root, move, reply, q):
    model = conic_model(root, q)
    center = involution(root[3], model, q)
    x = involution(move, model, q)
    y = involution(reply, model, q)
    _d, e, _k = model
    frame = ((1, 0), (0, 1)) + tuple(((point[0] + e) % q, 1) for point in root[:3])
    matrices = tuple(compose(word, q) for word in ((center, x), (center, y), (x, y)))
    x_on = conic_parameter(move, model, q)
    y_on = conic_parameter(reply, model, q)
    return (
        canonical_aligned_frame_profile(matrices, frame, q),
        boundary_profile(x_on, y_on, center, x, y, frame, q),
    )


def group_relation_signature(root, move, reply, q):
    model = conic_model(root, q)
    center = involution(root[3], model, q)
    x = involution(move, model, q)
    y = involution(reply, model, q)
    _d, e, _k = model
    frame = ((1, 0), (0, 1)) + tuple(((point[0] + e) % q, 1) for point in root[:3])
    a = compose((center, x), q)
    b = compose((center, y), q)
    c = compose((x, y), q)
    commutator = compose((a, b, matinv_projective(a, q), matinv_projective(b, q)), q)
    j_commutator = word_character((commutator,), q)
    commutator_type = None if j_commutator is None else (
        j_commutator, quadratic_character(j_commutator - 4, q)
    )
    x_on = conic_parameter(move, model, q)
    y_on = conic_parameter(reply, model, q)
    return (
        pgl_order(a, q), pgl_order(b, q), pgl_order(c, q),
        pgl_order(commutator, q), commutator_type,
        boundary_profile(x_on, y_on, center, x, y, frame, q),
    )


def segre_tangent_product(point, root, model, q):
    d, e, k = model
    r, c = (point[0] + e) % q, (point[1] + d) % q
    product = r * c % q  # tangents at the two burned infinite conic points
    for frame_point in root[:3]:
        t = (frame_point[0] + e) % q
        assert t != 0
        tangent_value = (c * t + r * k * pow(t, -1, q) - 2 * k) % q
        product = product * tangent_value % q
    return product


def normalize_projective(values, q):
    pivot = next((value for value in values if value % q), None)
    if pivot is None:
        return tuple(0 for _value in values)
    inverse = pow(pivot, -1, q)
    return tuple(value * inverse % q for value in values)


def segre_product_signature(root, move, reply, q):
    model = conic_model(root, q)
    products = tuple(
        segre_tangent_product(point, root, model, q)
        for point in (root[3], move, reply)
    )
    return normalize_projective(products, q) + tuple(
        quadratic_character(value, q) for value in products
    )


def direction(a, b, q):
    dr, dc = (b[0] - a[0]) % q, (b[1] - a[1]) % q
    return q if dc == 0 else dr * pow(dc, -1, q) % q


def invert_direction(value, q):
    if value == 0:
        return q
    if value == q:
        return 0
    return pow(value, -1, q)


def redei_direction_signature(root, move, reply, q):
    points = root + (move, reply)
    directions = [direction(a, b, q) for a, b in combinations(points, 2)]
    candidates = []
    for swap in (False, True):
        base = [invert_direction(value, q) for value in directions] if swap else directions
        for scale in range(1, q):
            candidates.append(tuple(sorted(
                value if value == q else value * scale % q for value in base
            )))
    return min(candidates)


def redei_support_signature(root, move, reply, q):
    points = root + (move, reply)
    directions = set(direction(a, b, q) for a, b in combinations(points, 2))
    candidates = []
    for swap in (False, True):
        base = [invert_direction(value, q) for value in directions] if swap else directions
        for scale in range(1, q):
            candidates.append(tuple(sorted(
                value if value == q else value * scale % q for value in base
            )))
    return min(candidates)


def redei_collision_signature(root, move, reply, q):
    points = root + (move, reply)
    counts = Counter(direction(a, b, q) for a, b in combinations(points, 2))
    repeated = [(value, count) for value, count in counts.items() if count >= 2]
    candidates = []
    for swap in (False, True):
        base = [(invert_direction(value, q), count) for value, count in repeated] \
            if swap else repeated
        for scale in range(1, q):
            candidates.append(tuple(sorted(
                (value if value == q else value * scale % q, count)
                for value, count in base
            )))
    return min(candidates)


def transform_direction(value, scale, swap, q):
    value = invert_direction(value, q) if swap else value
    return value if value == q else value * scale % q


def relative_redei_signature(root, move, reply, q):
    s5 = root + (move,)
    base = [direction(a, b, q) for a, b in combinations(s5, 2)]
    added = [direction(reply, point, q) for point in s5]
    candidates = []
    for swap in (False, True):
        for scale in range(1, q):
            base_t = tuple(sorted(transform_direction(value, scale, swap, q) for value in base))
            added_t = [transform_direction(value, scale, swap, q) for value in added]
            base_counts = Counter(base_t)
            added_counts = Counter(added_t)
            packet = tuple(sorted(
                (value, base_counts[value], added_counts[value]) for value in added_counts
            ))
            candidates.append((base_t, packet))
    return min(candidates)[1]


def relative_redei_simple_signature(root, move, reply, q):
    s5 = root + (move,)
    base = [direction(a, b, q) for a, b in combinations(s5, 2)]
    added = [direction(reply, point, q) for point in s5]
    candidates = []
    for swap in (False, True):
        for scale in range(1, q):
            base_t = tuple(sorted(transform_direction(value, scale, swap, q) for value in base))
            added_t = [transform_direction(value, scale, swap, q) for value in added]
            simple_packet = tuple(sorted(Counter(added_t).items()))
            candidates.append((base_t, simple_packet))
    return min(candidates)[1]


def relative_packet_count_features(packet):
    return (
        len(packet),
        sum(added for _value, base, added in packet if base > 0),
        sum(base * added for _value, base, added in packet),
        sum(added * (added - 1) // 2 for _value, _base, added in packet),
        sum(added for _value, base, added in packet if base >= 2),
    )


COMBO_FAMILIES = (
    "involution-equality",
    "aligned-exact",
    "aligned-equality",
    "group-relations",
    "segre-product",
    "redei-directions",
    "residual-live",
)


def combined_classifier_signature(root, move, reply, q):
    reduced = reduced_involution_signature(root, move, reply, q)
    aligned = aligned_involution_signature(root, move, reply, q)
    return (
        combinatorial_signature(reduced, q),
        aligned,
        aligned_combinatorial_signature(aligned, q),
        group_relation_signature(root, move, reply, q),
        segre_product_signature(root, move, reply, q),
        redei_direction_signature(root, move, reply, q),
    )


@lru_cache(maxsize=None)
def cached_residual_signature(q, follower):
    return residual_signature(q, follower)
    x_on = conic_parameter(move, model, q)
    y_on = conic_parameter(reply, model, q)
    return (
        pgl_order(a, q), pgl_order(b, q), pgl_order(c, q),
        pgl_order(commutator, q), commutator_type,
        boundary_profile(x_on, y_on, center, x, y, frame, q),
    )


def profile_shape(profile):
    if profile is None:
        return None
    return tuple(sorted(Counter(profile).values()))


def joint_multiplicities(*profiles):
    if any(profile is None for profile in profiles):
        return None
    counters = [Counter(profile) for profile in profiles]
    values = set().union(*(counter for counter in counters))
    return tuple(sorted(tuple(counter[value] for counter in counters) for value in values))


def combinatorial_signature(signature, q):
    """Forget field labels; retain only equality and multiplicity structure."""
    a, b, c, boundary = signature
    relation, center_x, center_y, quad = boundary
    quad_tag = None if quad is None else (
        "zero" if quad == 0 else "one" if quad == 1 else "inf" if quad == q else "other"
    )
    quad_counts = None if quad is None else tuple(
        0 if profile is None else Counter(profile)[quad]
        for profile in (relation, center_x, center_y)
    )
    return (
        profile_shape(a), profile_shape(b), profile_shape(c),
        joint_multiplicities(a, b, c),
        profile_shape(relation), profile_shape(center_x), profile_shape(center_y),
        joint_multiplicities(relation, center_x, center_y),
        quad_tag, quad_counts,
    )


def aligned_combinatorial_signature(signature, q):
    joint, boundary = signature
    relation, center_x, center_y, quad = boundary
    joint_pattern = None
    if joint is not None:
        counters = [Counter(row[i] for row in joint) for i in range(3)]
        rows = []
        for row in joint:
            equality = (row[0] == row[1], row[0] == row[2], row[1] == row[2])
            occurrences = tuple(
                tuple(counter[value] for counter in counters) for value in row
            )
            special = tuple(
                "zero" if value == 0 else "one" if value == 1
                else "inf" if value == q else "other" for value in row
            )
            rows.append((equality, occurrences, special))
        joint_pattern = tuple(sorted(rows))
    boundary_pattern = combinatorial_signature(
        (None, None, None, boundary), q
    )[4:]
    return joint_pattern, boundary_pattern


def profile_dot(a, b):
    if a is None or b is None:
        return -1
    ca, cb = Counter(a), Counter(b)
    return sum(ca[value] * cb[value] for value in ca.keys() & cb.keys())


def profile_energy(profile):
    if profile is None:
        return -1
    return sum(count * count for count in Counter(profile).values())


def overlap_scores(signature):
    a, b, c, boundary = signature
    relation, center_x, center_y, quad = boundary
    counters = [Counter(profile) if profile is not None else Counter()
                for profile in (a, b, c)]
    values = set().union(*(counter for counter in counters))
    return {
        "ab_dot": profile_dot(a, b),
        "ac_dot": profile_dot(a, c),
        "bc_dot": profile_dot(b, c),
        "abc_triple": sum(counters[0][v] * counters[1][v] * counters[2][v]
                          for v in values),
        "abc_union": len(values),
        "a_energy": profile_energy(a),
        "b_energy": profile_energy(b),
        "c_energy": profile_energy(c),
        "rel_cx_dot": profile_dot(relation, center_x),
        "rel_cy_dot": profile_dot(relation, center_y),
        "center_xy_dot": profile_dot(center_x, center_y),
        "boundary_quad_hits": -1 if quad is None else sum(
            Counter(profile)[quad] for profile in (relation, center_x, center_y)
            if profile is not None
        ),
    }
def signature(root, move, reply, q):
    named = [(f"r{i}", projective(point)) for i, point in enumerate(root)]
    named += [("x", projective(move)), ("y", projective(reply)),
              ("H", (1, 0, 0)), ("V", (0, 1, 0))]
    conics = []
    for subset in combinations(named, 6):
        if conic_rank([point for _name, point in subset], q) < 6:
            conics.append(tuple(name for name, _point in subset))
    return tuple(conics)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--solver", default="target/gridcap-ledger")
    ap.add_argument("--details", action="store_true")
    ap.add_argument("--mirrors", action="store_true")
    ap.add_argument("--controls", action="store_true")
    ap.add_argument("--all-roots", action="store_true")
    ap.add_argument("--coarse-representatives", action="store_true")
    ap.add_argument("--targeted", action="store_true")
    ap.add_argument("--reduced-only", action="store_true")
    ap.add_argument("--no-subset-search", action="store_true")
    ap.add_argument("--collision-details", action="store_true")
    ap.add_argument("--q", type=int, default=17)
    ap.add_argument("--combinatorial", action="store_true")
    ap.add_argument("--score-search", action="store_true")
    ap.add_argument("--aligned", action="store_true")
    ap.add_argument("--group-relations", action="store_true")
    ap.add_argument("--segre", action="store_true")
    ap.add_argument("--redei", action="store_true")
    ap.add_argument("--classifier-combos", action="store_true")
    ap.add_argument("--redei-residual", action="store_true")
    ap.add_argument("--redei-residual-components", action="store_true")
    ap.add_argument("--redei-support-residual", action="store_true")
    ap.add_argument("--redei-collision-residual", action="store_true")
    ap.add_argument("--relative-redei-residual", action="store_true")
    ap.add_argument("--relative-redei-simple", action="store_true")
    ap.add_argument("--relative-congruence", action="store_true")
    ap.add_argument("--transition-ledger", action="store_true")
    ap.add_argument("--transition-controls", action="store_true")
    ap.add_argument("--minimum-reply-symmetry", action="store_true")
    ap.add_argument("--torus-gate", action="store_true")
    args = ap.parse_args()
    q = args.q
    if q != 17 and not (args.all_roots or args.coarse_representatives):
        ap.error("--q other than 17 requires --all-roots or --coarse-representatives")
    roots = tuple(canon for canon, _hist in mirror_run(q, root_orbits=True)) \
        if (args.all_roots or args.coarse_representatives) else ROOTS
    if not roots:
        print(f"BALANCED-ROOTS-NONE q={q}")
        return
    if args.coarse_representatives:
        by_coarse_signature = {}
        for root in roots:
            by_coarse_signature.setdefault(residual_signature(q, root), root)
        roots = tuple(by_coarse_signature.values())
        print(f"COARSE-REPRESENTATIVES q={q} roots={len(roots)}")
    command = [
        args.solver,
        "replygraphs-targeted" if args.targeted else "replygraphs",
        str(q),
    ]
    for i, root in enumerate(roots):
        if i:
            command.append("/")
        command.extend(f"{r},{c}" for r, c in root)
    if args.controls:
        command.append("--pairs")
    output = subprocess.run(command, check=True, text=True, capture_output=True).stdout
    records = parse_forced(output)
    if args.minimum_reply_symmetry:
        if not args.controls:
            ap.error("--minimum-reply-symmetry requires --controls")
        by_move_values = {}
        for root_index, move, reply, value, _live in parse_pairs(output):
            by_move_values.setdefault((root_index, move), []).append((reply, value))
        winning_counts = {
            key: sum(value == "P" for _reply, value in rows)
            for key, rows in by_move_values.items()
        }
        minimum = min(winning_counts.values())
        minimum_rows = [key for key, count in winning_counts.items() if count == minimum]
        paired = 0
        trivial_stabilizers = 0
        for root_index, move in minimum_rows:
            winners = [
                reply for reply, value in by_move_values[(root_index, move)] if value == "P"
            ]
            s5 = roots[root_index] + (move,)
            stabilizer = grid_stabilizer(q, s5)
            trivial_stabilizers += len(stabilizer) == 1
            if len(winners) == 2 and any(
                    apply_grid_transform(q, transform, winners[0]) == winners[1]
                    for transform in stabilizer):
                paired += 1
        print("MINIMUM-REPLY-SYMMETRY "
              f"q={q} minimum={minimum} states={len(minimum_rows)} "
              f"paired={paired} trivial-stabilizers={trivial_stabilizers}")
    if q == 17:
        expected_forced_roots = 20 if args.all_roots else 5
        assert len(records) == expected_forced_roots, records
    elif not records:
        if args.details:
            print(output, end="")
        minimum_degrees = [
            int(match.group(1))
            for match in re.finditer(r"winning-degrees=\{(\d+):", output)
        ]
        assert len(minimum_degrees) == len(roots), (len(minimum_degrees), len(roots))
        print(f"FORCED-NONE q={q} roots={len(roots)} "
              f"minimum-winning-degree={min(minimum_degrees)} "
              f"maximum-of-minimum={max(minimum_degrees)}")
        return
    root_indices = {root: i for i, root in enumerate(roots)}
    filter_redei_fn = relative_redei_simple_signature if args.relative_redei_simple else (
        relative_redei_signature if args.relative_redei_residual else (
        redei_support_signature if args.redei_support_residual else (
            redei_collision_signature if args.redei_collision_residual else redei_direction_signature
        )
        )
    )
    forced_redei = {
        filter_redei_fn(root, move, reply, q)
        for root, forced_pairs in records for move, reply in forced_pairs
    }

    histogram = Counter()
    mirror_histogram = Counter()
    transforms = list(transformations(q)) if args.mirrors else ()
    total = 0
    for root, pairs in records:
        for move, reply in pairs:
            sig = signature(root, move, reply, q)
            histogram[sig] += 1
            mirrors = root_safe_mirrors_for(q, root + (move, reply), transforms) \
                if args.mirrors else ()
            mirror_histogram[len(mirrors)] += 1
            total += 1
            if args.details:
                print(f"FORCED-CONIC root={root} x={move} y={reply} conics={sig} "
                      f"mirrors={len(mirrors)}")
    print(f"FORCED-CONIC-DONE directed={total} signatures={len(histogram)} "
          f"multiplicities={dict(sorted(Counter(histogram.values()).items()))} "
          f"mirror-counts={dict(sorted(mirror_histogram.items()))}")

    if args.torus_gate:
        forced_gate = Counter()
        for root, forced_pairs in records:
            for move, reply in forced_pairs:
                forced_gate[common_torus_gate(root, move, reply, q)] += 1
        control_gate = Counter()
        if args.controls:
            for root_index, move, reply, value, _live in parse_pairs(output):
                control_gate[(common_torus_gate(roots[root_index], move, reply, q), value)] += 1
        print(f"TORUS-GATE forced={dict(sorted(forced_gate.items()))} "
              f"controls={dict(sorted(control_gate.items()))}")

    if args.transition_ledger:
        ledger_hist = Counter()
        load_hist = Counter()
        checked = 0
        for root, forced_pairs in records:
            for move, reply in forced_pairs:
                s5 = root + (move,)
                vertices5 = tuple(legal_moves(q, s5))
                edges5 = conflict_edges(q, s5, vertices5)
                killed = {reply}
                killed.update(next(iter(edge - {reply})) for edge in edges5 if reply in edge)
                vertices6 = tuple(legal_moves(q, s5 + (reply,)))
                assert set(vertices6) == set(vertices5) - killed
                old_surviving = {edge for edge in edges5 if edge.isdisjoint(killed)}
                edges6 = conflict_edges(q, s5 + (reply,), vertices6)
                assert old_surviving <= edges6
                removed = len(edges5) - len(old_surviving)
                added = edges6 - old_surviving
                loads = Counter(direction(reply, vertex, q) for vertex in vertices6)
                added_formula = sum(load * (load - 1) // 2 for load in loads.values())
                assert added_formula == len(added)
                delta_edges = len(edges6) - len(edges5)
                assert delta_edges == -removed + added_formula
                ledger_hist[(removed % 3, added_formula % 3, delta_edges % 3)] += 1
                load_hist[tuple(sorted(Counter(load % 3 for load in loads.values()).items()))] += 1
                checked += 1
        print(f"TRANSITION-LEDGER checked={checked} mod3={dict(sorted(ledger_hist.items()))} "
              f"line-load-mod3={dict(sorted(load_hist.items()))}")

    if args.controls:
        pairs = parse_pairs(output)
        by_move = {}
        global_by_signature = {}
        for root_index, move, reply, value, residual_live in pairs:
            signature_fn = combined_classifier_signature if args.classifier_combos else (
                segre_product_signature if args.segre else (
                redei_direction_signature if args.redei else (
                    group_relation_signature if args.group_relations else (
                aligned_involution_signature if args.aligned else (
                    reduced_involution_signature if args.reduced_only else involution_signature
                )
                    )
                )
                )
            )
            inv_signature = signature_fn(roots[root_index], move, reply, q)
            if args.redei_residual or args.redei_residual_components:
                redei = redei_direction_signature(roots[root_index], move, reply, q)
                residual = cached_residual_signature(
                    q, roots[root_index] + (move, reply)
                ) if redei in forced_redei else None
                inv_signature = (redei, residual) if not args.redei_residual_components else (
                    (redei,) + (residual if residual is not None else (None,) * 5)
                )
            if args.redei_support_residual or args.redei_collision_residual:
                redei = filter_redei_fn(roots[root_index], move, reply, q)
                residual = cached_residual_signature(
                    q, roots[root_index] + (move, reply)
                ) if redei in forced_redei else None
                inv_signature = (redei, None, None) if residual is None else (
                    redei, residual[0], residual[1]
                )
            if args.relative_redei_residual or args.relative_redei_simple:
                relative = filter_redei_fn(roots[root_index], move, reply, q)
                if relative in forced_redei:
                    before = cached_residual_signature(q, roots[root_index] + (move,))
                    after = cached_residual_signature(q, roots[root_index] + (move, reply))
                    inv_signature = (
                        relative, after[0] - before[0], after[1] - before[1]
                    )
                else:
                    inv_signature = (relative, None, None)
            if args.classifier_combos:
                inv_signature += (residual_live,)
            if args.combinatorial:
                assert args.reduced_only or args.aligned
                inv_signature = aligned_combinatorial_signature(inv_signature, q) \
                    if args.aligned else combinatorial_signature(inv_signature, q)
            by_move.setdefault((root_index, move), []).append((reply, value, inv_signature))
            global_by_signature.setdefault(inv_signature, []).append(
                (root_index, move, reply, value)
            )
        forced_unique = forced_pure = forced_total = 0
        forced_targets = []
        forced_cases = []
        collision_hist = Counter()
        for root, forced_pairs in records:
            root_index = root_indices[root]
            for move, reply in forced_pairs:
                rows = by_move[(root_index, move)]
                target = next(sig for candidate, _value, sig in rows if candidate == reply)
                forced_targets.append(target)
                forced_cases.append((target, rows))
                matches = [(candidate, value) for candidate, value, sig in rows if sig == target]
                forced_total += 1
                forced_unique += len(matches) == 1
                forced_pure += all(value == "P" for _candidate, value in matches)
                collision_hist[(len(matches), sum(value == "P" for _c, value in matches),
                                sum(value == "N" for _c, value in matches))] += 1
                if args.details:
                    print(f"FORCED-INVOLUTION root-index={root_index} x={move} y={reply} "
                          f"signature={target} matches={matches}")
        print(f"FORCED-INVOLUTION-DONE directed={forced_total} unique={forced_unique} "
              f"p-pure={forced_pure} collision-hist={dict(sorted(collision_hist.items()))}")
        if args.transition_controls:
            feature_names = (
                "ra", "delta", "loads", "ra-loads", "delta-loads", "full",
                "loads-hit-profile", "loads-indexed-hits", "loads-incidence",
                "loads-incidence-quotients",
                "loads-incidence-quotient-max",
                "context-loads-incidence-quotients",
                "context-loads-incidence-quotient-max",
                "loads-vandermonde", "loads-ray-cross-ratios",
                "loads-ray-secant-characters", "loads-mixed-cross-ratios",
                "loads-arithmetic-rays", "indexed-hits-arithmetic-rays",
                "loads-ray-secant-vandermonde", "loads-ray-secant-ray-cross-ratios",
                "loads-ray-secant-quotient-max", "loads-ray-secant-hit-profile",
                "loads-ray-secant-indexed-hits",
                "loads-ray-secant-quotient-vandermonde",
                "loads-ray-secant-quotient-ray-cross-ratios",
                "arithmetic-core", "arithmetic-core-bool",
                "arithmetic-core-mod3", "arithmetic-core-mod4",
                "arithmetic-core-mod5", "arithmetic-core-mod6",
                "arithmetic-core-bin2", "arithmetic-core-bin3",
                "arithmetic-core-bin4", "arithmetic-core-bin5",
                "arithmetic-core-bin6",
                "arithmetic-oriented-core", "arithmetic-oriented-core-mod3",
                "arithmetic-oriented-core-mod5", "arithmetic-relative-vandermonde-core",
                "delta-hit-profile", "delta-indexed-hits", "delta-incidence",
            )
            feature_rows = {name: [] for name in feature_names}
            global_features = {name: {} for name in feature_names}
            strongest_failures = []
            arithmetic_component_hist = Counter()
            arithmetic_mod5_failures = []
            arithmetic_extrema = Counter()
            for root, forced_pairs in records:
                root_index = root_indices[root]
                for move, forced_reply in forced_pairs:
                    candidates = by_move[(root_index, move)]
                    context_parallelism = base_parallelism_incidence(q, root + (move,))
                    computed = []
                    for reply, value, _signature in candidates:
                        removed, added, delta, loads = transition_features(
                            q, root + (move,), reply
                        )
                        hit_profile, indexed_hits, incidence, quotient_size, quotient_max = \
                            relative_direction_relations(q, root + (move,), reply)
                        arithmetic_rays = arithmetic_ray_features(q, root + (move,), reply)
                        determinant_zeros, determinant_low, determinant_high = arithmetic_rays[2]
                        determinant_bias = determinant_high - determinant_low
                        quotient_triple = quotient_max >= 3
                        features = {
                            "ra": (removed, added),
                            "delta": delta,
                            "loads": loads,
                            "ra-loads": (removed, added, loads),
                            "delta-loads": (delta, loads),
                            "full": (removed, added, delta, loads),
                            "loads-hit-profile": (loads, hit_profile),
                            "loads-indexed-hits": (loads, indexed_hits),
                            "loads-incidence": (loads, incidence),
                            "loads-incidence-quotients": (
                                loads, incidence, quotient_size,
                            ),
                            "loads-incidence-quotient-max": (
                                loads, incidence, quotient_max,
                            ),
                            "context-loads-incidence-quotients": (
                                context_parallelism, loads, incidence, quotient_size,
                            ),
                            "context-loads-incidence-quotient-max": (
                                context_parallelism, loads, incidence, quotient_max,
                            ),
                            "loads-vandermonde": (loads, arithmetic_rays[0]),
                            "loads-ray-cross-ratios": (loads, arithmetic_rays[1]),
                            "loads-ray-secant-characters": (loads, arithmetic_rays[2]),
                            "loads-mixed-cross-ratios": (loads, arithmetic_rays[3]),
                            "loads-arithmetic-rays": (loads, arithmetic_rays),
                            "indexed-hits-arithmetic-rays": (indexed_hits, arithmetic_rays),
                            "loads-ray-secant-vandermonde": (
                                loads, arithmetic_rays[2], arithmetic_rays[0],
                            ),
                            "loads-ray-secant-ray-cross-ratios": (
                                loads, arithmetic_rays[2], arithmetic_rays[1],
                            ),
                            "loads-ray-secant-quotient-max": (
                                loads, arithmetic_rays[2], quotient_max,
                            ),
                            "loads-ray-secant-hit-profile": (
                                loads, arithmetic_rays[2], hit_profile,
                            ),
                            "loads-ray-secant-indexed-hits": (
                                loads, arithmetic_rays[2], indexed_hits,
                            ),
                            "loads-ray-secant-quotient-vandermonde": (
                                loads, arithmetic_rays[2], quotient_max, arithmetic_rays[0],
                            ),
                            "loads-ray-secant-quotient-ray-cross-ratios": (
                                loads, arithmetic_rays[2], quotient_max, arithmetic_rays[1],
                            ),
                            "arithmetic-core": (
                                loads, determinant_zeros, determinant_bias,
                                quotient_max, arithmetic_rays[0],
                            ),
                            "arithmetic-core-bool": (
                                loads, determinant_zeros, determinant_bias,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-mod3": (
                                loads, determinant_zeros, determinant_bias % 3,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-mod4": (
                                loads, determinant_zeros, determinant_bias % 4,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-mod5": (
                                loads, determinant_zeros, determinant_bias % 5,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-mod6": (
                                loads, determinant_zeros, determinant_bias % 6,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-bin2": (
                                loads, determinant_zeros, determinant_bias // 2,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-bin3": (
                                loads, determinant_zeros, determinant_bias // 3,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-bin4": (
                                loads, determinant_zeros, determinant_bias // 4,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-bin5": (
                                loads, determinant_zeros, determinant_bias // 5,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-core-bin6": (
                                loads, determinant_zeros, determinant_bias // 6,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-oriented-core": (
                                loads, determinant_zeros, arithmetic_rays[4],
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-oriented-core-mod3": (
                                loads, determinant_zeros, arithmetic_rays[4] % 3,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-oriented-core-mod5": (
                                loads, determinant_zeros, arithmetic_rays[4] % 5,
                                quotient_triple, arithmetic_rays[0],
                            ),
                            "arithmetic-relative-vandermonde-core": (
                                loads, determinant_zeros, determinant_bias // 2,
                                quotient_triple, arithmetic_rays[5],
                            ),
                            "delta-hit-profile": (delta, hit_profile),
                            "delta-indexed-hits": (delta, indexed_hits),
                            "delta-incidence": (delta, incidence),
                        }
                        computed.append((reply, value, features))
                        for name in feature_names:
                            global_features[name].setdefault(features[name], []).append(value)
                    forced_features = next(
                        features for reply, _value, features in computed if reply == forced_reply
                    )
                    arithmetic_core = forced_features["arithmetic-core-bool"]
                    arithmetic_component_hist[(
                        arithmetic_core[1], arithmetic_core[2],
                        arithmetic_core[3], arithmetic_core[4],
                    )] += 1
                    for scope in ("all", "same-loads"):
                        scoped = computed if scope == "all" else [
                            row for row in computed
                            if row[2]["arithmetic-core-bool"][0] == arithmetic_core[0]
                        ]
                        metric_rows = []
                        for candidate, _value, features in scoped:
                            core = features["arithmetic-core-bool"]
                            z, bias = core[1], core[2]
                            oriented = features["arithmetic-oriented-core"][2]
                            metrics = {
                                "z": z,
                                "bias": bias,
                                "oriented": oriented,
                                "z-bias": (z, bias),
                                "bias-z": (bias, z),
                            }
                            for weight in range(-10, 11):
                                metrics[f"bias+{weight}z"] = bias + weight * z
                                metrics[f"oriented+{weight}z"] = oriented + weight * z
                            metric_rows.append((candidate, metrics))
                        for name in metric_rows[0][1]:
                            target_value = next(
                                metrics[name] for candidate, metrics in metric_rows
                                if candidate == forced_reply
                            )
                            values = [metrics[name] for _candidate, metrics in metric_rows]
                            if target_value == min(values) and values.count(target_value) == 1:
                                arithmetic_extrema[(scope, name, "min")] += 1
                            if target_value == max(values) and values.count(target_value) == 1:
                                arithmetic_extrema[(scope, name, "max")] += 1
                    for name in feature_names:
                        matches = [value for _reply, value, features in computed
                                   if features[name] == forced_features[name]]
                        feature_rows[name].append((
                            len(matches) == 1,
                            all(value == "P" for value in matches),
                            forced_features[name],
                        ))
                    incidence_matches = [
                        (reply, value, relative_redei_signature(root, move, reply, q))
                        for reply, value, features in computed
                        if features["loads-incidence"]
                        == forced_features["loads-incidence"]
                    ]
                    if len(incidence_matches) != 1:
                        strongest_failures.append((
                            root_index, move, forced_reply,
                            forced_features["loads-incidence"], incidence_matches,
                        ))
                    mod5_matches = [
                        (reply, value, features["arithmetic-core-bool"])
                        for reply, value, features in computed
                        if features["arithmetic-core-mod5"]
                        == forced_features["arithmetic-core-mod5"]
                    ]
                    if len(mod5_matches) != 1:
                        arithmetic_mod5_failures.append((
                            root_index, move, forced_reply,
                            forced_features["arithmetic-core-mod5"], mod5_matches,
                        ))
            results = {}
            for name in feature_names:
                rows = feature_rows[name]
                global_pure = sum(
                    all(value == "P" for value in global_features[name][feature])
                    for _unique, _pure, feature in rows
                )
                results[name] = {
                    "local_unique": sum(unique for unique, _pure, _feature in rows),
                    "local_pure": sum(pure for _unique, pure, _feature in rows),
                    "global_pure": global_pure,
                    "forced_types": len({feature for _u, _p, feature in rows}),
                }
            print(f"TRANSITION-CONTROLS results={results}")
            for name, result in results.items():
                print(f"TRANSITION-CONTROL name={name} result={result}")
            print(f"TRANSITION-INCIDENCE-FAILURES rows={strongest_failures}")
            print("ARITHMETIC-CORE-COMPONENTS "
                  f"hist={dict(sorted(arithmetic_component_hist.items()))}")
            print(f"ARITHMETIC-MOD5-FAILURES rows={arithmetic_mod5_failures}")
            print("ARITHMETIC-EXTREMA best="
                  f"{sorted(arithmetic_extrema.items(), key=lambda row: (-row[1], row[0]))[:20]}")
        local_signature_collisions = sum(
            1 for rows in by_move.values()
            for count in Counter(signature for _reply, _value, signature in rows).values()
            if count > 1
        )
        forced_global_pure = sum(
            all(row[3] == "P" for row in global_by_signature[target])
            for target in forced_targets
        )
        forced_global_hist = Counter(
            (sum(row[3] == "P" for row in global_by_signature[target]),
             sum(row[3] == "N" for row in global_by_signature[target]))
            for target in forced_targets
        )
        print(f"FORCED-INVOLUTION-SKEPTIC all-pairs={len(pairs)} "
              f"local-collision-groups={local_signature_collisions} "
              f"forced-distinct-signatures={len(set(forced_targets))} "
              f"forced-global-pure={forced_global_pure}/{forced_total} "
              f"forced-global-hist={dict(sorted(forced_global_hist.items()))}")
        if args.details or args.collision_details:
            for target in set(forced_targets):
                rows = global_by_signature[target]
                if any(row[3] == "N" for row in rows):
                    print(f"FORCED-INVOLUTION-GLOBAL-COLLISION signature={target} rows={rows}")
        prefix_rows = []
        for width in range(1, len(forced_targets[0]) + 1):
            values = {}
            for inv_sig, rows in global_by_signature.items():
                values.setdefault(inv_sig[:width], []).extend(rows)
            pure = sum(
                all(row[3] == "P" for row in values[target[:width]])
                for target in forced_targets
            )
            prefix_rows.append((width, pure, len({target[:width] for target in forced_targets})))
        ablation_rows = []
        for omitted in range(len(forced_targets[0])):
            values = {}
            for inv_sig, rows in global_by_signature.items():
                reduced = inv_sig[:omitted] + inv_sig[omitted + 1:]
                values.setdefault(reduced, []).extend(rows)
            pure = sum(
                all(row[3] == "P" for row in values[
                    target[:omitted] + target[omitted + 1:]
                ]) for target in forced_targets
            )
            ablation_rows.append((omitted, pure))
        print(f"FORCED-INVOLUTION-REDUCTION prefixes={prefix_rows} "
              f"single-component-ablation={ablation_rows}")
        if args.redei_residual_components:
            rows = []
            for component in range(1, 6):
                values = {}
                for inv_sig, labeled_rows in global_by_signature.items():
                    reduced = (inv_sig[0], inv_sig[component])
                    values.setdefault(reduced, []).extend(labeled_rows)
                pure = sum(
                    all(row[3] == "P" for row in values[(target[0], target[component])])
                    for target in forced_targets
                )
                distinct = len({(target[0], target[component]) for target in forced_targets})
                rows.append((component, pure, distinct))
            print("REDEI-RESIDUAL-COMPONENTS "
                  "fields={1:live,2:edges,3:degree-hist,4:components,5:triple-loads} "
                  f"results={rows}")
        if args.relative_redei_residual or args.relative_redei_simple:
            quantizers = {
                "sign": lambda value: (value > 0) - (value < 0),
                **{f"mod{modulus}": (lambda value, m=modulus: value % m)
                   for modulus in range(2, 13)},
                **{f"bin{width}": (lambda value, w=width: value // w)
                   for width in range(2, 11)},
            }
            quantized_rows = []
            for name, quantize in quantizers.items():
                values = {}
                for inv_sig, labeled_rows in global_by_signature.items():
                    reduced = (inv_sig[0], None if inv_sig[2] is None else quantize(inv_sig[2]))
                    values.setdefault(reduced, []).extend(labeled_rows)
                pure = sum(
                    all(row[3] == "P" for row in values[
                        (target[0], quantize(target[2]))
                    ]) for target in forced_targets
                )
                distinct = len({(target[0], quantize(target[2])) for target in forced_targets})
                local_unique = local_pure = 0
                for target, candidate_rows in forced_cases:
                    target_key = (target[0], quantize(target[2]))
                    matches = [value for _reply, value, signature in candidate_rows
                               if signature[2] is not None
                               and (signature[0], quantize(signature[2])) == target_key]
                    local_unique += len(matches) == 1
                    local_pure += all(value == "P" for value in matches)
                quantized_rows.append((name, pure, local_unique, local_pure, distinct))
            print(f"RELATIVE-REDEI-QUANTIZED results={quantized_rows}")
        if args.relative_congruence:
            assert args.relative_redei_residual and not args.relative_redei_simple
            hits = []
            for coefficients in product(range(3), repeat=6):
                if all(
                    (coefficients[0] + sum(
                        coefficient * feature for coefficient, feature in zip(
                            coefficients[1:], relative_packet_count_features(target[0])
                        )
                    ) - target[2]) % 3 == 0
                    for target in forced_targets
                ):
                    hits.append(coefficients)
            print("RELATIVE-REDEI-CONGRUENCE features="
                  "(1,n_dirs,reused_added,base_weight,added_pairs,base_ge2_added) "
                  f"mod3-hits={hits[:20]} total={len(hits)}")
        if args.score_search:
            assert args.reduced_only and not args.combinatorial
            score_names = tuple(overlap_scores(forced_targets[0]))
            score_results = []
            for name in score_names:
                counts = Counter()
                for target, rows in forced_cases:
                    target_score = overlap_scores(target)[name]
                    scores = [overlap_scores(signature)[name]
                              for _reply, _value, signature in rows]
                    minimum, maximum = min(scores), max(scores)
                    counts["at_min"] += target_score == minimum
                    counts["unique_min"] += target_score == minimum and scores.count(minimum) == 1
                    counts["at_max"] += target_score == maximum
                    counts["unique_max"] += target_score == maximum and scores.count(maximum) == 1
                score_results.append((name, dict(counts)))
            print(f"FORCED-INVOLUTION-SCORES results={score_results}")
        if not args.no_subset_search:
            minimal_subsets = []
            component_indices = range(len(forced_targets[0]))
            for width in range(1, len(forced_targets[0]) + 1):
                for subset in combinations(component_indices, width):
                    values = {}
                    for inv_sig, rows in global_by_signature.items():
                        reduced = tuple(inv_sig[i] for i in subset)
                        values.setdefault(reduced, []).extend(rows)
                    if all(all(row[3] == "P" for row in values[
                        tuple(target[i] for i in subset)
                    ]) for target in forced_targets):
                        minimal_subsets.append(subset)
                        if len(minimal_subsets) == 12:
                            break
                if minimal_subsets:
                    break
            if minimal_subsets:
                print(f"FORCED-INVOLUTION-MINIMAL width={len(minimal_subsets[0])} "
                      f"first-subsets={minimal_subsets}")
                if args.classifier_combos:
                    print("FORCED-CLASSIFIER-COMBO-NAMES subsets=" + repr([
                        tuple(COMBO_FAMILIES[i] for i in subset) for subset in minimal_subsets
                    ]))
            else:
                print("FORCED-INVOLUTION-MINIMAL none")


if __name__ == "__main__":
    main()
