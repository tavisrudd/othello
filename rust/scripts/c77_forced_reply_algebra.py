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
from itertools import combinations, permutations
import argparse
import re
import subprocess

from c77_balanced_mirror_probe import root_safe_mirrors_for, run as mirror_run, transformations


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
    r"REPLYGRAPHS-PAIR root-index=(\d+) x=(\d+),(\d+) y=(\d+),(\d+) value=([PN])"
)
POINT = re.compile(r"\((\d+), (\d+)\)")


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
    ap.add_argument("--reduced-only", action="store_true")
    ap.add_argument("--no-subset-search", action="store_true")
    ap.add_argument("--collision-details", action="store_true")
    ap.add_argument("--q", type=int, default=17)
    ap.add_argument("--combinatorial", action="store_true")
    ap.add_argument("--score-search", action="store_true")
    ap.add_argument("--aligned", action="store_true")
    ap.add_argument("--group-relations", action="store_true")
    args = ap.parse_args()
    q = args.q
    if q != 17 and not args.all_roots:
        ap.error("--q other than 17 requires --all-roots")
    roots = tuple(canon for canon, _hist in mirror_run(q, root_orbits=True)) \
        if args.all_roots else ROOTS
    command = [args.solver, "replygraphs", str(q)]
    for i, root in enumerate(roots):
        if i:
            command.append("/")
        command.extend(f"{r},{c}" for r, c in root)
    if args.controls:
        command.append("--pairs")
    output = subprocess.run(command, check=True, text=True, capture_output=True).stdout
    records = parse_forced(output)
    if q == 17:
        expected_forced_roots = 20 if args.all_roots else 5
        assert len(records) == expected_forced_roots, records
    else:
        assert records, f"q={q} has no degree-one balanced-root obligations"

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

    if args.controls:
        pairs = parse_pairs(output)
        by_move = {}
        global_by_signature = {}
        for root_index, move, reply, value in pairs:
            signature_fn = group_relation_signature if args.group_relations else (
                aligned_involution_signature if args.aligned else (
                    reduced_involution_signature if args.reduced_only else involution_signature
                )
            )
            inv_signature = signature_fn(roots[root_index], move, reply, q)
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
        root_indices = {root: i for i, root in enumerate(roots)}
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
            else:
                print("FORCED-INVOLUTION-MINIMAL none")


if __name__ == "__main__":
    main()
