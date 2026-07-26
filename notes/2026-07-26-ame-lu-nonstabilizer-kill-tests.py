#!/usr/bin/env python3
"""Exact cheap tests on the logical sphere of the perfect five-qubit code.

Standard-library only. All ranks and spectral characteristic data are over Q.
"""

from fractions import Fraction as Q
from itertools import combinations, product

N = 5
Z0 = (Q(0), Q(0))
ONE = (Q(1), Q(0))
II = (Q(0), Q(1))
MI = (Q(0), Q(-1))


def add(x, y):
    return (x[0] + y[0], x[1] + y[1])


def mul(x, y):
    return (x[0] * y[0] - x[1] * y[1], x[0] * y[1] + x[1] * y[0])


def conj(x):
    return (x[0], -x[1])


def scale(a, x):
    return (a * x[0], a * x[1])


CW0 = {
    "00000": 1, "10010": 1, "01001": 1, "10100": 1,
    "01010": 1, "11011": -1, "00110": -1, "11000": -1,
    "11101": -1, "00011": -1, "11110": -1, "01111": -1,
    "10001": -1, "01100": -1, "10111": -1, "00101": 1,
}
v0 = [Z0] * (1 << N)
for bits, coefficient in CW0.items():
    v0[int(bits, 2)] = (Q(coefficient), Q(0))
v1 = [Z0] * (1 << N)
for j, coefficient in enumerate(v0):
    v1[j ^ ((1 << N) - 1)] = coefficient


def state(t):
    """Unnormalized |0_L> + t |1_L>, with Gaussian-rational t."""
    return [add(a, mul(t, b)) for a, b in zip(v0, v1)]


def pauli_on_basis(j, operators):
    out, phase = j, ONE
    for party, pauli in operators.items():
        bitpos = N - 1 - party
        bit = (out >> bitpos) & 1
        if pauli == "X":
            out ^= 1 << bitpos
        elif pauli == "Y":
            out ^= 1 << bitpos
            phase = mul(phase, II if bit == 0 else MI)
        elif pauli == "Z":
            if bit:
                phase = scale(Q(-1), phase)
        else:
            raise ValueError(pauli)
    return out, phase


def apply_pauli(vector, operators):
    out = [Z0] * len(vector)
    for j, amplitude in enumerate(vector):
        k, phase = pauli_on_basis(j, operators)
        out[k] = add(out[k], mul(phase, amplitude))
    return out


def inner(left, right):
    result = Z0
    for a, b in zip(left, right):
        result = add(result, mul(conj(a), b))
    return result


def corr(vector, operators):
    value = inner(vector, apply_pauli(vector, operators))
    norm = inner(vector, vector)[0]
    assert value[1] == 0
    return value[0] / norm


def real_column(vector):
    return [component for z in vector for component in z]


def mul_minus_i(vector):
    return [(z[1], -z[0]) for z in vector]


def rank(columns):
    if not columns:
        return 0
    matrix = [list(row) for row in zip(*columns)]
    rows, ncols = len(matrix), len(columns)
    r = 0
    for column in range(ncols):
        pivot = next((i for i in range(r, rows) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[r], matrix[pivot] = matrix[pivot], matrix[r]
        p = matrix[r][column]
        matrix[r] = [x / p for x in matrix[r]]
        for i in range(rows):
            if i != r and matrix[i][column]:
                factor = matrix[i][column]
                matrix[i] = [
                    x - factor * y for x, y in zip(matrix[i], matrix[r])
                ]
        r += 1
    return r


def det3(matrix):
    return (
        matrix[0][0]
        * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1]
        * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2]
        * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    )


def gram_signature(matrix):
    """(trace, second elementary symmetric function, determinant)."""
    trace = sum(matrix[i][i] for i in range(3))
    trace2 = sum(
        matrix[i][j] * matrix[j][i] for i in range(3) for j in range(3)
    )
    return (trace, (trace * trace - trace2) / 2, det3(matrix))


def triple_tensors(vector):
    tensors = {}
    paulis = "XYZ"
    for parties in combinations(range(N), 3):
        values = {}
        for indices in product(range(3), repeat=3):
            operators = dict(zip(parties, (paulis[i] for i in indices)))
            values[indices] = corr(vector, operators)
        tensors[parties] = values
    return tensors


def triple_mode_signatures(tensors):
    signatures = []
    for parties, tensor in tensors.items():
        for mode in range(3):
            gram = [[Q(0) for _ in range(3)] for _ in range(3)]
            other = [j for j in range(3) if j != mode]
            for a, b in product(range(3), repeat=2):
                for uv in product(range(3), repeat=2):
                    ia = [0, 0, 0]
                    ib = [0, 0, 0]
                    ia[mode], ib[mode] = a, b
                    ia[other[0]] = ib[other[0]] = uv[0]
                    ia[other[1]] = ib[other[1]] = uv[1]
                    gram[a][b] += tensor[tuple(ia)] * tensor[tuple(ib)]
            signatures.append((parties, mode, gram_signature(gram)))
    return signatures


def cross_triple_signatures(tensors):
    """Contract pairs of triples over their two common Pauli indices."""
    signatures = []
    keys = list(tensors)
    for first_index, first in enumerate(keys):
        for second in keys[first_index + 1:]:
            common = sorted(set(first) & set(second))
            if len(common) != 2:
                continue
            u = next(iter(set(first) - set(common)))
            v = next(iter(set(second) - set(common)))
            contracted = [[Q(0) for _ in range(3)] for _ in range(3)]
            for a, b in product(range(3), repeat=2):
                for x, y in product(range(3), repeat=2):
                    first_indices = tuple(
                        {common[0]: x, common[1]: y, u: a}[p] for p in first
                    )
                    second_indices = tuple(
                        {common[0]: x, common[1]: y, v: b}[p] for p in second
                    )
                    contracted[a][b] += (
                        tensors[first][first_indices]
                        * tensors[second][second_indices]
                    )
            gram = [
                [
                    sum(contracted[i][k] * contracted[j][k] for k in range(3))
                    for j in range(3)
                ]
                for i in range(3)
            ]
            signatures.append((first, second, gram_signature(gram)))
    return signatures


def sum_complex(values):
    result = Z0
    for value in values:
        result = add(result, value)
    return result


def marginal(vector, keep):
    keep = tuple(keep)
    drop = tuple(i for i in range(N) if i not in keep)
    dimension = 1 << len(keep)
    rho = [[Z0 for _ in range(dimension)] for _ in range(dimension)]
    norm = inner(vector, vector)[0]

    def key(j, parties):
        out = 0
        for party in parties:
            out = (out << 1) | ((j >> (N - 1 - party)) & 1)
        return out

    for j, a in enumerate(vector):
        kept_j, dropped_j = key(j, keep), key(j, drop)
        for l, b in enumerate(vector):
            if key(l, drop) == dropped_j:
                kept_l = key(l, keep)
                rho[kept_j][kept_l] = add(
                    rho[kept_j][kept_l], mul(a, conj(b))
                )
    return [[scale(Q(1) / norm, z) for z in row] for row in rho]


def rho_moments(rho, max_power=4):
    dimension = len(rho)
    current = [
        [ONE if i == j else Z0 for j in range(dimension)]
        for i in range(dimension)
    ]
    result = []
    for _ in range(max_power):
        current = [
            [
                sum_complex(mul(current[i][k], rho[k][j])
                            for k in range(dimension))
                for j in range(dimension)
            ]
            for i in range(dimension)
        ]
        result.append(sum((current[i][i][0] for i in range(dimension)), Q(0)))
    return tuple(result)


def analyze(label, t):
    vector = state(t)
    local_columns = []
    for party in range(N):
        for pauli in "XYZ":
            tangent = mul_minus_i(apply_pauli(vector, {party: pauli}))
            local_columns.append(real_column(tangent))
    phase_column = real_column([(-z[1], z[0]) for z in vector])
    scale_column = real_column(vector)
    lie_rank = rank(local_columns + [phase_column])
    lie_kernel = 16 - lie_rank

    orbit_columns = local_columns + [scale_column, phase_column]
    orbit_rank = rank(orbit_columns)
    leakage = rank(orbit_columns + [real_column(v1)]) - orbit_rank

    marginal_signatures = {}
    for size in (1, 2, 3):
        values = {
            rho_moments(marginal(vector, parties), 4)
            for parties in combinations(range(N), size)
        }
        marginal_signatures[size] = tuple(sorted(values))

    tensors = triple_tensors(vector)
    mode = tuple(x[2] for x in triple_mode_signatures(tensors))
    cross = tuple(x[2] for x in cross_triple_signatures(tensors))
    print(f"POINT {label} t={t}")
    print(f"  Lie rank={lie_rank}/16 kernel={lie_kernel}")
    print(
        f"  orbit+radial rank={orbit_rank}; "
        f"logical tangent rank increment={leakage}"
    )
    print(f"  marginal moment signatures k=1,2,3: {marginal_signatures}")
    print(f"  triple-mode unique/count: {sorted(set(mode))} / {len(mode)}")
    print(f"  cross-triple unique/count: {sorted(set(cross))} / {len(cross)}")
    return mode, cross


def main():
    points = [
        ("zeroL", (Q(0), Q(0))),
        ("half", (Q(1, 2), Q(0))),
        ("plusL", (Q(1), Q(0))),
        ("iL", (Q(0), Q(1))),
        ("complex_generic", (Q(1, 2), Q(1, 2))),
    ]
    results = {label: analyze(label, t) for label, t in points}
    for name, position in (("triple-mode", 0), ("cross-triple", 1)):
        classes = {}
        for label, result in results.items():
            classes.setdefault(result[position], []).append(label)
        print(f"{name} exact-signature classes: {list(classes.values())}")

    extra_points = [
        (Q(2, 3), Q(1, 5)),
        (Q(-3, 4), Q(2, 7)),
        (Q(5, 6), Q(-4, 9)),
    ]
    for t in extra_points:
        vector = state(t)
        signatures = {
            x[2] for x in triple_mode_signatures(triple_tensors(vector))
        }
        denominator = 1 + t[0] * t[0] + t[1] * t[1]
        bloch = (
            2 * t[0] / denominator,
            2 * t[1] / denominator,
            (1 - t[0] * t[0] - t[1] * t[1]) / denominator,
        )
        eigenvalues = tuple(x * x for x in bloch)
        expected = (
            sum(eigenvalues),
            sum(
                eigenvalues[i] * eigenvalues[j]
                for i in range(3) for j in range(i + 1, 3)
            ),
            eigenvalues[0] * eigenvalues[1] * eigenvalues[2],
        )
        assert signatures == {expected}
        print(f"extra Bloch-spectrum check t={t}: PASS {expected}")


if __name__ == "__main__":
    main()
