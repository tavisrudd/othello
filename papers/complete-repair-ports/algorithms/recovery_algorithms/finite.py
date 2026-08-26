"""Small, dependency-free linear algebra over a prime field.

Matrices are immutable tuples of rows.  The implementation is deliberately
plain: the accompanying tests compare the structured algorithms with direct
enumeration, and every arithmetic operation is visible here.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import product
from typing import Iterable, Iterator, Sequence

Matrix = tuple[tuple[int, ...], ...]


def matrix(rows: Iterable[Iterable[int]], p: int) -> Matrix:
    out = tuple(tuple(x % p for x in row) for row in rows)
    if out and any(len(row) != len(out[0]) for row in out):
        raise ValueError("matrix rows have different lengths")
    return out


def zero_matrix(nrows: int, ncols: int) -> Matrix:
    return tuple((0,) * ncols for _ in range(nrows))


def identity_matrix(n: int) -> Matrix:
    return tuple(tuple(int(i == j) for j in range(n)) for i in range(n))


def shape(a: Matrix) -> tuple[int, int]:
    return (len(a), len(a[0]) if a else 0)


def transpose(a: Matrix) -> Matrix:
    rows, cols = shape(a)
    return tuple(tuple(a[i][j] for i in range(rows)) for j in range(cols))


def mat_add(a: Matrix, b: Matrix, p: int) -> Matrix:
    if shape(a) != shape(b):
        raise ValueError("matrix shape mismatch")
    return tuple(
        tuple((x + y) % p for x, y in zip(arow, brow))
        for arow, brow in zip(a, b)
    )


def mat_sub(a: Matrix, b: Matrix, p: int) -> Matrix:
    if shape(a) != shape(b):
        raise ValueError("matrix shape mismatch")
    return tuple(
        tuple((x - y) % p for x, y in zip(arow, brow))
        for arow, brow in zip(a, b)
    )


def mat_mul(a: Matrix, b: Matrix, p: int) -> Matrix:
    ar, ac = shape(a)
    br, bc = shape(b)
    if ac != br:
        raise ValueError("matrix product shape mismatch")
    if ar == 0:
        return ()
    if bc == 0:
        return zero_matrix(ar, 0)
    bt = transpose(b)
    return tuple(
        tuple(sum(x * y for x, y in zip(row, col)) % p for col in bt)
        for row in a
    )


def flatten(a: Matrix) -> tuple[int, ...]:
    return tuple(x for row in a for x in row)


def unflatten(values: Sequence[int], nrows: int, ncols: int, p: int) -> Matrix:
    if len(values) != nrows * ncols:
        raise ValueError("flat matrix has wrong size")
    return tuple(
        tuple(values[i * ncols + j] % p for j in range(ncols))
        for i in range(nrows)
    )


def matrix_rank(a: Matrix, p: int) -> int:
    rows, cols = shape(a)
    work = [list(row) for row in a]
    rank = 0
    for col in range(cols):
        pivot = next((i for i in range(rank, rows) if work[i][col] % p), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inv = pow(work[rank][col], -1, p)
        work[rank] = [(x * inv) % p for x in work[rank]]
        for i in range(rows):
            if i != rank and work[i][col] % p:
                scalar = work[i][col]
                work[i] = [
                    (x - scalar * y) % p
                    for x, y in zip(work[i], work[rank])
                ]
        rank += 1
        if rank == rows:
            break
    return rank


def canonical_row_basis(a: Matrix, p: int) -> Matrix:
    """Return the unique reduced-row-echelon basis of the supplied row span."""

    if not a:
        return ()
    width = len(a[0])
    if any(len(row) != width for row in a):
        raise ValueError("matrix rows have different lengths")
    work = [list(x % p for x in row) for row in a]
    pivot_row = 0
    for col in range(width):
        pivot = next(
            (i for i in range(pivot_row, len(work)) if work[i][col] % p),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][col], -1, p)
        work[pivot_row] = [(x * inverse) % p for x in work[pivot_row]]
        for i in range(len(work)):
            if i != pivot_row and work[i][col] % p:
                scalar = work[i][col]
                work[i] = [
                    (x - scalar * y) % p
                    for x, y in zip(work[i], work[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == len(work):
            break
    return tuple(tuple(row) for row in work[:pivot_row])


def column_space_basis(a: Matrix, p: int) -> Matrix:
    """Represent a column space canonically as RREF rows in the ambient space."""

    return canonical_row_basis(transpose(a), p)


def subspace_contains(super_basis: Matrix, sub_basis: Matrix, p: int) -> bool:
    """Test containment of canonically or noncanonically supplied row spans."""

    if not sub_basis:
        return True
    if not super_basis:
        return False
    if len(super_basis[0]) != len(sub_basis[0]):
        raise ValueError("subspace ambient dimensions differ")
    super_canonical = canonical_row_basis(super_basis, p)
    return len(canonical_row_basis(super_canonical + sub_basis, p)) == len(
        super_canonical
    )


def binary_rank_masks(rows: Iterable[int]) -> int:
    """Rank over F_2 using Python integers as packed rows and XOR elimination."""

    pivots: dict[int, int] = {}
    for packed in rows:
        value = packed
        if value < 0:
            raise ValueError("packed binary rows must be nonnegative")
        while value:
            pivot = value.bit_length() - 1
            if pivot in pivots:
                value ^= pivots[pivot]
            else:
                pivots[pivot] = value
                break
    return len(pivots)


def gaussian_binomial(n: int, k: int, q: int) -> int:
    """Count k-subspaces of F_q^n by an exact product formula."""

    if k < 0 or k > n:
        return 0
    k = min(k, n - k)
    numerator = denominator = 1
    for i in range(k):
        numerator *= q ** (n - i) - 1
        denominator *= q ** (k - i) - 1
    return numerator // denominator


def nullspace_basis(a: Matrix, p: int) -> Matrix:
    """Return a canonical row basis of the right nullspace of a nonempty matrix."""

    rows, cols = shape(a)
    if rows == 0:
        raise ValueError("an empty matrix does not record its ambient width")
    work = [list(row) for row in a]
    pivots: list[int] = []
    pivot_row = 0
    for col in range(cols):
        pivot = next((i for i in range(pivot_row, rows) if work[i][col] % p), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inv = pow(work[pivot_row][col], -1, p)
        work[pivot_row] = [(x * inv) % p for x in work[pivot_row]]
        for i in range(rows):
            if i != pivot_row and work[i][col] % p:
                scalar = work[i][col]
                work[i] = [
                    (x - scalar * y) % p
                    for x, y in zip(work[i], work[pivot_row])
                ]
        pivots.append(col)
        pivot_row += 1
        if pivot_row == rows:
            break
    free = [col for col in range(cols) if col not in pivots]
    basis = []
    for free_col in free:
        vector = [0] * cols
        vector[free_col] = 1
        for i, pivot_col in enumerate(pivots):
            vector[pivot_col] = -work[i][free_col] % p
        basis.append(tuple(vector))
    return tuple(basis)


def row_space(basis: Matrix, p: int) -> tuple[tuple[int, ...], ...]:
    if not basis:
        return ((),)
    dimension = len(basis)
    width = len(basis[0])
    return tuple(
        tuple(
            sum(coefficients[i] * basis[i][j] for i in range(dimension)) % p
            for j in range(width)
        )
        for coefficients in product(range(p), repeat=dimension)
    )


def all_matrices(nrows: int, ncols: int, p: int) -> Iterator[Matrix]:
    for values in product(range(p), repeat=nrows * ncols):
        yield unflatten(values, nrows, ncols, p)


def column_block(a: Matrix, start: int, width: int) -> Matrix:
    return tuple(row[start : start + width] for row in a)


def concatenate_columns(blocks: Sequence[Matrix]) -> Matrix:
    if not blocks:
        return ()
    nrows = len(blocks[0])
    if any(len(block) != nrows for block in blocks):
        raise ValueError("column blocks have different heights")
    return tuple(tuple(x for block in blocks for x in block[i]) for i in range(nrows))


def row_support_size(a: Matrix) -> int:
    return sum(any(x != 0 for x in row) for row in a)


def vector_weight(v: Sequence[int]) -> int:
    return sum(x != 0 for x in v)


def extension_multiplication_matrix(
    element: Sequence[int], modulus: Sequence[int], p: int
) -> Matrix:
    """Matrix of multiplication in F_p[x]/(modulus), in the power basis."""

    degree = len(modulus) - 1
    if degree < 1 or len(element) != degree or modulus[-1] % p != 1:
        raise ValueError("need a monic degree-d modulus and a d-term element")

    def multiply(left: Sequence[int], right: Sequence[int]) -> tuple[int, ...]:
        coefficients = [0] * (2 * degree - 1)
        for i, x in enumerate(left):
            for j, y in enumerate(right):
                coefficients[i + j] = (coefficients[i + j] + x * y) % p
        for power in range(2 * degree - 2, degree - 1, -1):
            leading = coefficients[power] % p
            if not leading:
                continue
            shift = power - degree
            for j in range(degree + 1):
                coefficients[shift + j] = (
                    coefficients[shift + j] - leading * modulus[j]
                ) % p
        return tuple(coefficients[:degree])

    columns = []
    for j in range(degree):
        basis = tuple(int(i == j) for i in range(degree))
        columns.append(multiply(element, basis))
    return tuple(tuple(columns[j][i] for j in range(degree)) for i in range(degree))


@dataclass(frozen=True)
class LinearMap:
    """A matrix representing F_p^domain_dim -> F_p^codomain_dim."""

    p: int
    data: Matrix

    def __post_init__(self) -> None:
        if self.p < 2 or any(self.p % d == 0 for d in range(2, int(self.p**0.5) + 1)):
            raise ValueError("p must be prime")
        matrix(self.data, self.p)

    @property
    def codomain_dim(self) -> int:
        return len(self.data)

    @property
    def domain_dim(self) -> int:
        return len(self.data[0]) if self.data else 0

    def block(self, index: int, width: int) -> Matrix:
        return column_block(self.data, index * width, width)
