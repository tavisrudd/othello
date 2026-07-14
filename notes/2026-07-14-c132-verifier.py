#!/usr/bin/env python3
"""Independent standard-library verifier for the finite claims in the C132 spike."""

from itertools import combinations, product


def inv(a, p):
    return pow(a, -1, p)


def norm_point(v, p):
    v = tuple(x % p for x in v)
    i = next(i for i, x in enumerate(v) if x)
    scale = inv(v[i], p)
    return tuple(x * scale % p for x in v)


def norm_matrix(m, p):
    flat = [x % p for row in m for x in row]
    scale = inv(next(x for x in flat if x), p)
    return tuple(tuple(x * scale % p for x in row) for row in m)


def matmul(a, b, p):
    return tuple(
        tuple(sum(a[i][k] * b[k][j] for k in range(3)) % p for j in range(3))
        for i in range(3)
    )


def row_action(v, m, p):
    return norm_point(
        tuple(sum(v[i] * m[i][j] for i in range(3)) % p for j in range(3)), p
    )


def det3(rows, p):
    a, b, c = rows
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % p


def projective_points(p):
    return sorted(
        {norm_point(v, p) for v in product(range(p), repeat=3) if any(v)}
    )


def projective_group(generators, p):
    identity = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    seen = {identity}
    todo = [identity]
    while todo:
        a = todo.pop()
        for g in generators:
            b = norm_matrix(matmul(a, g, p), p)
            if b not in seen:
                seen.add(b)
                todo.append(b)
    return seen


def orbit(seed, generators, p):
    seen = {seed}
    todo = [seed]
    while todo:
        v = todo.pop()
        for g in generators:
            w = row_action(v, g, p)
            if w not in seen:
                seen.add(w)
                todo.append(w)
    return seen


def line_through(a, b, p):
    return norm_point(
        (
            a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0],
        ),
        p,
    )


def incident(point, line, p):
    return sum(a * b for a, b in zip(point, line)) % p == 0


def verify_valentiner():
    p = 19
    generators = [
        ((4, 13, 0), (11, 15, 0), (4, 6, 8)),
        ((4, 3, 15), (5, 3, 18), (8, 1, 12)),
        ((8, 13, 1), (1, 8, 10), (18, 10, 3)),
    ]
    group_order = len(projective_group(generators, p))
    remaining = set(projective_points(p))
    orbits = []
    while remaining:
        current = orbit(min(remaining), generators, p)
        assert current <= remaining
        remaining -= current
        orbits.append(current)
    data = sorted(
        (len(current), sum(det3(t, p) == 0 for t in combinations(current, 3)))
        for current in orbits
    )
    expected = [(36, 240), (45, 660), (60, 1260), (60, 1560), (180, 44340)]
    assert group_order == 360
    assert data == expected
    print(f"Valentiner projective group order: {group_order}")
    print(f"Valentiner (orbit size, collinear triples): {data}")


def verify_hesse():
    p = 7
    roots = [t for t in range(p) if (t**3 + 1) % p == 0]
    hesse_points = (
        {norm_point((0, 1, t), p) for t in roots}
        | {norm_point((1, 0, t), p) for t in roots}
        | {norm_point((1, t, 0), p) for t in roots}
    )
    secants = {
        line_through(a, b, p) for a, b in combinations(hesse_points, 2)
    }
    three_point_lines = {
        line
        for line in secants
        if sum(incident(x, line, p) for x in hesse_points) == 3
    }
    covered = {
        x
        for x in projective_points(p)
        if any(incident(x, line, p) for line in secants)
    }
    collinear_triples = sum(
        det3(t, p) == 0 for t in combinations(hesse_points, 3)
    )
    result = (
        len(roots),
        len(hesse_points),
        len(secants),
        len(three_point_lines),
        collinear_triples,
        len(covered),
    )
    assert result == (3, 9, 12, 12, 12, 57)
    print(
        "Hesse (cube roots, points, secants, three-point lines, "
        f"collinear triples, covered points): {result}"
    )


if __name__ == "__main__":
    verify_valentiner()
    verify_hesse()
