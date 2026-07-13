#!/usr/bin/env python3
"""Independent verifier for the projectively completed cubic--axis seed.

This script deliberately implements its own small finite fields and projective normalization.  It
does not import the Lean development or project code.  For q=3,9,27 it checks the completed point
system, every projective plane form, the affine-deletion control, an invertible coordinate change,
and a duplicate-column mutation.
"""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
from functools import lru_cache
from itertools import combinations, product


@dataclass(frozen=True)
class GF3Extension:
    degree: int
    # Monic modulus x^degree + modulus[degree-1] x^(degree-1) + ... + modulus[0].
    modulus: tuple[int, ...]

    @property
    def q(self) -> int:
        return 3**self.degree

    def coeffs(self, a: int) -> list[int]:
        out = []
        for _ in range(self.degree):
            out.append(a % 3)
            a //= 3
        return out

    def encode(self, c: list[int]) -> int:
        return sum((x % 3) * 3**i for i, x in enumerate(c[: self.degree]))

    def add(self, a: int, b: int) -> int:
        return self.encode([(x + y) % 3 for x, y in zip(self.coeffs(a), self.coeffs(b))])

    def neg(self, a: int) -> int:
        return self.encode([(-x) % 3 for x in self.coeffs(a)])

    def sub(self, a: int, b: int) -> int:
        return self.add(a, self.neg(b))

    def mul(self, a: int, b: int) -> int:
        ac = self.coeffs(a)
        bc = self.coeffs(b)
        raw = [0] * (2 * self.degree - 1)
        for i, x in enumerate(ac):
            for j, y in enumerate(bc):
                raw[i + j] = (raw[i + j] + x * y) % 3
        for k in range(len(raw) - 1, self.degree - 1, -1):
            lead = raw[k] % 3
            if lead:
                for j, m in enumerate(self.modulus):
                    raw[k - self.degree + j] = (raw[k - self.degree + j] - lead * m) % 3
        return self.encode(raw)

    def pow(self, a: int, n: int) -> int:
        out = 1
        while n:
            if n & 1:
                out = self.mul(out, a)
            a = self.mul(a, a)
            n >>= 1
        return out

    def inv(self, a: int) -> int:
        assert a != 0
        return self.pow(a, self.q - 2)

    def div(self, a: int, b: int) -> int:
        return self.mul(a, self.inv(b))

    def dot(self, x: tuple[int, ...], y: tuple[int, ...]) -> int:
        out = 0
        for a, b in zip(x, y):
            out = self.add(out, self.mul(a, b))
        return out

    def mat_vec(self, matrix: tuple[tuple[int, ...], ...], v: tuple[int, ...]) -> tuple[int, ...]:
        return tuple(self.dot(row, v) for row in matrix)

    def normalize(self, v: tuple[int, ...]) -> tuple[int, ...]:
        for x in v:
            if x:
                scale = self.inv(x)
                return tuple(self.mul(scale, y) for y in v)
        raise AssertionError("zero projective vector")


FIELDS = (
    GF3Extension(1, (0,)),          # GF(3)
    GF3Extension(2, (1, 0)),       # x^2 + 1
    GF3Extension(3, (1, 2, 0)),    # x^3 + 2x + 1
)


def completed_points(f: GF3Extension) -> tuple[list[tuple[int, ...]], list[str]]:
    cubic = [(1, t, f.mul(t, t), f.pow(t, 3)) for t in range(f.q)]
    cubic.append((0, 0, 0, 1))
    axis = [(0, 1, u, 0) for u in range(f.q)]
    axis.append((0, 0, 1, 0))
    labels = [f"C({t})" for t in range(f.q)] + ["C(inf)"]
    labels += [f"A({u})" for u in range(f.q)] + ["A(inf)"]
    return cubic + axis, labels


def projective_forms(f: GF3Extension):
    """All normalized nonzero forms, once per projective class."""
    for first in range(4):
        for tail in product(range(f.q), repeat=3 - first):
            yield (0,) * first + (1,) + tail


def rank(f: GF3Extension, columns: list[tuple[int, ...]]) -> int:
    matrix = [[columns[j][i] for j in range(len(columns))] for i in range(4)]
    row = 0
    for col in range(len(columns)):
        pivot = next((r for r in range(row, 4) if matrix[r][col]), None)
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        inv = f.inv(matrix[row][col])
        matrix[row] = [f.mul(inv, x) for x in matrix[row]]
        for r in range(4):
            if r != row and matrix[r][col]:
                c = matrix[r][col]
                matrix[r] = [f.sub(x, f.mul(c, y)) for x, y in zip(matrix[r], matrix[row])]
        row += 1
        if row == 4:
            break
    return row


def section_distribution(f: GF3Extension, points: list[tuple[int, ...]]) -> Counter[int]:
    return Counter(sum(f.dot(a, p) == 0 for p in points) for a in projective_forms(f))


def minimal_circuits_up_to_five(
    f: GF3Extension, points: list[tuple[int, ...]]
) -> list[tuple[int, ...]]:
    """Independently enumerate all matroid circuits of size at most five."""
    circuits = []
    for size in range(3, 6):
        for support in combinations(range(len(points)), size):
            columns = [points[i] for i in support]
            if rank(f, columns) == size:
                continue
            if all(rank(f, columns[:j] + columns[j + 1 :]) == size - 1 for j in range(size)):
                circuits.append(support)
    return circuits


def matching_number(edge_masks: tuple[int, ...], vertex_mask: int) -> int:
    incident = {
        1 << v: tuple(e for e in edge_masks if e & (1 << v))
        for v in range(vertex_mask.bit_length())
    }

    @lru_cache(None)
    def solve(available: int) -> int:
        if available == 0:
            return 0
        pivot = available & -available
        best = solve(available ^ pivot)
        for edge in incident[pivot]:
            if edge & ~available == 0:
                best = max(best, 1 + solve(available & ~edge))
        return best

    return solve(vertex_mask)


def transversal_number(edge_masks: tuple[int, ...]) -> int:
    incident_bits: dict[int, int] = {}
    for i, edge in enumerate(edge_masks):
        for v in range(edge.bit_length()):
            if edge & (1 << v):
                incident_bits[v] = incident_bits.get(v, 0) | (1 << i)

    @lru_cache(None)
    def solve(remaining: int) -> int:
        if remaining == 0:
            return 0
        edge_index = (remaining & -remaining).bit_length() - 1
        edge = edge_masks[edge_index]
        return 1 + min(
            solve(remaining & ~incident_bits[v])
            for v in range(edge.bit_length())
            if edge & (1 << v)
        )

    return solve((1 << len(edge_masks)) - 1)


def zero_sum_cap_number(f: GF3Extension) -> int:
    triples = [
        sum(1 << x for x in triple)
        for triple in combinations(range(f.q), 3)
        if f.add(f.add(triple[0], triple[1]), triple[2]) == 0
    ]
    return max(
        subset.bit_count()
        for subset in range(1 << f.q)
        if all(subset & edge != edge for edge in triples)
    )


def assert_repair_rows(f: GF3Extension, points: list[tuple[int, ...]]) -> None:
    """Exhaustively check the radius-three/four clutter rows for q=3,9."""
    assert f.q <= 9
    q = f.q
    circuits = minimal_circuits_up_to_five(f, points)
    z3 = zero_sum_cap_number(f)
    expected = {
        ("cubic", 3): ((q - 1) // 2, q - 1),
        ("axis", 3): ((5 * q - 3) // 6, 2 * q - 1 - z3),
        ("cubic", 4): ((q - 1) // 2, q - 1),
        ("axis", 4): ((5 * q - 3) // 6, 2 * q - 3),
    }
    observed: dict[tuple[str, int], set[tuple[int, int]]] = {
        key: set() for key in expected
    }
    for target in range(len(points)):
        kind = "cubic" if target <= q else "axis"
        helpers = [i for i in range(len(points)) if i != target]
        bit_of = {v: i for i, v in enumerate(helpers)}
        for radius in (3, 4):
            edges = []
            for circuit in circuits:
                if target in circuit and len(circuit) - 1 <= radius:
                    mask = sum(1 << bit_of[v] for v in circuit if v != target)
                    edges.append(mask)
            edge_masks = tuple(sorted(set(edges)))
            universe = (1 << len(helpers)) - 1
            row = (matching_number(edge_masks, universe), transversal_number(edge_masks))
            observed[(kind, radius)].add(row)
    assert observed == {key: {row} for key, row in expected.items()}
    print(f"q={q}: repair_rows={expected} circuits_le_5={len(circuits)} Z3={z3}")


def assert_seed(f: GF3Extension, points: list[tuple[int, ...]]) -> Counter[int]:
    q = f.q
    assert len(points) == 2 * q + 2
    assert all(any(p) for p in points)
    assert len({f.normalize(p) for p in points}) == len(points)
    assert rank(f, points) == 4

    cubic = points[: q + 1]
    axis = points[q + 1 :]
    assert len({f.normalize(p) for p in cubic}) == q + 1
    assert len({f.normalize(p) for p in axis}) == q + 1

    distribution = section_distribution(f, points)
    expected_distribution = Counter(
        {
            1: q * (q * q - 1) // 3,
            2: q * (q * q - 1) // 2,
            3: q * (q + 1),
            4: q * (q * q - 1) // 6,
            q + 2: q + 1,
        }
    )
    assert distribution == expected_distribution
    assert max(distribution) == q + 2
    assert len(points) - max(distribution) == q

    for a in projective_forms(f):
        cubic_hits = sum(f.dot(a, p) == 0 for p in cubic)
        axis_hits = sum(f.dot(a, p) == 0 for p in axis)
        contains_axis = a[1] == 0 and a[2] == 0
        if contains_axis:
            assert axis_hits == q + 1
            assert cubic_hits == 1
        else:
            assert axis_hits <= 1
            assert cubic_hits <= 3

    # Explicit three-axis dependence A(0) - A(1) + A(infinity) = 0.
    a0, a1, ainf = axis[0], axis[1], axis[-1]
    relation = tuple(f.add(f.sub(x, y), z) for x, y, z in zip(a0, a1, ainf))
    assert relation == (0, 0, 0, 0)
    return distribution


def run_field(f: GF3Extension) -> None:
    points, _ = completed_points(f)
    distribution = assert_seed(f, points)

    # Coordinate-conjugation control: a fixed invertible upper-unitriangular map.
    matrix = (
        (1, 1, 0, 0),
        (0, 1, 1, 0),
        (0, 0, 1, 1),
        (0, 0, 0, 1),
    )
    conjugated = [f.mat_vec(matrix, p) for p in points]
    assert rank(f, conjugated) == 4
    assert len({f.normalize(p) for p in conjugated}) == len(points)
    assert section_distribution(f, conjugated) == distribution

    # Deleting cubic infinity recovers the affine seed parameters [2q+1,4,q-1].
    affine = points[: f.q] + points[f.q + 1 :]
    affine_distribution = section_distribution(f, affine)
    assert len(affine) == 2 * f.q + 1
    assert max(affine_distribution) == f.q + 2
    assert len(affine) - max(affine_distribution) == f.q - 1

    # One-column mutation to an existing axis point must be rejected projectively.
    mutated = list(points)
    mutated[f.q] = points[-1]
    assert len({f.normalize(p) for p in mutated}) == len(points) - 1

    # A nonduplicate one-column mutation remains projective but must change the section spectrum.
    spectrum_mutated = list(points)
    spectrum_mutated[f.q] = (1, 0, 0, 1)
    assert len({f.normalize(p) for p in spectrum_mutated}) == len(points)
    assert section_distribution(f, spectrum_mutated) != distribution

    if f.q <= 9:
        assert_repair_rows(f, points)

    print(
        f"q={f.q}: n={len(points)} rank=4 max_section={max(distribution)} d={f.q} "
        f"forms={sum(distribution.values())} distribution={dict(sorted(distribution.items()))}"
    )


def main() -> None:
    for field in FIELDS:
        # Irreducibility/field sanity: every nonzero element has a two-sided inverse.
        assert all(field.mul(x, field.inv(x)) == 1 for x in range(1, field.q))
        run_field(field)


if __name__ == "__main__":
    main()
