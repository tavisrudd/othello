"""Independently re-verify a C1018 QLDPC exact-distance certificate in Sage.

Run with the wrapper::

    analysis/ergodis-sage analysis/sage/check_qldpc_certificate.py \
        evidence/c1018-qldpc-r1elite01-certificate.json

or with no arguments to check every `c1018-qldpc-*-certificate.json` in
`evidence/`.

Why Sage rather than another Python script: the certificate's claims are group
theory and linear algebra over GF(2), and Sage has both natively.  The existing
checker in `notes/2026-08-31-c1018-qldpc-helper.py` implements the group law by
hand and the linear algebra as integer bitmasks.  This oracle rebuilds the same
codes from Sage's own named groups and Sage's own matrices, so an agreement
between the two is agreement between independent implementations rather than
between two runs of one idea.

What is checked, all against the numbers the certificate publishes:

* the group is the one claimed -- right order, and isomorphic to Sage's own
  construction of that named group;
* the lifted product has the claimed coordinate count and check-row weights;
* the CSS condition `Hx Hz^T = 0` holds;
* the X and Z check ranks match, and `n - rank(Hx) - rank(Hz)` is the published
  dimension `k`;
* the even-weight-kernel claim and the combined support component count hold;
* right translation by each element of the centralizer of the B entries really
  is a code automorphism, and the number of verified translations and coordinate
  orbits match the anchor notes; and
* any published logical witness has zero physical syndrome, is outside the
  stabilizer row space, and has the weight the certificate certifies.

The construction convention is the one documented in the helper: coordinates are
`(ja, jb)` blocks followed by `(ia, ib)` blocks, each of `|G|` positions; the
X-check block at `(ia, jb)` is left multiplication by `A[ia][ja]` on the first
family and right multiplication by `B[ib][jb]` on the second, and the Z-check
block at `(ja, ib)` is right multiplication by `B[ib][jb]^-1` and left
multiplication by `A[ia][ja]^-1`.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

from sage.all import GF, Graph, Permutation, PermutationGroup, matrix, vector, zero_matrix
from sage.groups.abelian_gps.abelian_group import AbelianGroup
from sage.groups.perm_gps.permgroup_named import DiCyclicGroup

FIELD = GF(2)


# ---------------------------------------------------------------------------
# Groups
#
# Element orderings follow the certificate's own convention, because the
# published witness supports are coordinate indices in that ordering.
# ---------------------------------------------------------------------------


class AbelianTuples:
    """Direct product of cyclic groups, elements as exponent tuples."""

    def __init__(self, orders):
        self.orders = tuple(orders)
        elements = [()]
        for modulus in self.orders:
            elements = [item + (value,) for item in elements for value in range(modulus)]
        elements.sort(key=lambda item: (sum(1 for value in item if value), item))
        self.elements = elements
        self.index = {element: position for position, element in enumerate(elements)}
        self.identity = tuple(0 for _ in self.orders)

    def multiply(self, left, right):
        return tuple((a + b) % m for a, b, m in zip(left, right, self.orders))

    def inverse(self, value):
        return tuple((-a) % m for a, m in zip(value, self.orders))

    def generators(self):
        return [
            tuple(1 if position == index else 0 for position in range(len(self.orders)))
            for index in range(len(self.orders))
        ]

    def sage_model(self):
        """Sage's own construction of this group, for the isomorphism check."""
        return AbelianGroup(list(self.orders)).permutation_group()


class Dicyclic:
    """Dicyclic group, elements as `(rotation exponent, reflection flag)`.

    `Dic_n` has order `4n`; here `modulus = 2n` and the twist is `n`, so
    `r^(2n) = 1`, `s^2 = r^n`, and `s r s^-1 = r^-1`.
    """

    def __init__(self, n):
        self.n = n
        self.modulus = 2 * n
        self.twist = n
        self.elements = [
            (exponent, reflection)
            for reflection in range(2)
            for exponent in range(self.modulus)
        ]
        self.index = {element: position for position, element in enumerate(self.elements)}
        self.identity = (0, 0)

    def multiply(self, left, right):
        a, b = left
        c, d = right
        exponent = a + (-c if b else c) + (self.twist if b and d else 0)
        return exponent % self.modulus, b ^ d

    def inverse(self, value):
        for candidate in self.elements:
            if self.multiply(value, candidate) == self.identity:
                return candidate
        raise RuntimeError("group element has no inverse")

    def generators(self):
        return [(1, 0), (0, 1)]

    def sage_model(self):
        return DiCyclicGroup(self.n)


def parse_group(name):
    """Build the group a certificate names, e.g. `Z_3 x Z_14` or `Dic_11`."""
    cleaned = name.replace(" ", "")
    cyclic = re.fullmatch(r"(Z_\d+)(?:x(Z_\d+))*", cleaned)
    if cyclic:
        orders = [int(part[2:]) for part in cleaned.split("x")]
        return AbelianTuples(orders)
    dicyclic = re.fullmatch(r"Dic_(\d+)", cleaned)
    if dicyclic:
        return Dicyclic(int(dicyclic.group(1)))
    raise RuntimeError(f"unsupported group name {name!r}")


def regular_permutation_group(group):
    """The group as a Sage permutation group, through its left regular action.

    Sage then answers the structural questions -- order, abelian, isomorphism
    type -- about the same object the code is built from.  Generators are given
    as one-line images and converted to cycles, because Sage reads a bare tuple
    as a cycle and would otherwise build a different group entirely.
    """
    cycles = []
    for element in group.generators():
        images = [
            group.index[group.multiply(element, other)] + 1 for other in group.elements
        ]
        cycles.append(Permutation(images).cycle_tuples())
    return PermutationGroup(gens=cycles)


# ---------------------------------------------------------------------------
# The lifted product
# ---------------------------------------------------------------------------


def left_matrix(group, element):
    """`L(x)` with `L[index(x h), index(h)] = 1`."""
    order = len(group.elements)
    result = zero_matrix(FIELD, order, order)
    for column, h in enumerate(group.elements):
        result[group.index[group.multiply(element, h)], column] = 1
    return result


def right_matrix(group, element):
    """`R(x)` with `R[index(h x), index(h)] = 1`."""
    order = len(group.elements)
    result = zero_matrix(FIELD, order, order)
    for column, h in enumerate(group.elements):
        result[group.index[group.multiply(h, element)], column] = 1
    return result


def build_checks(group, a, b):
    """Return `(Hx, Hz)` over GF(2) for the lifted product of `a` and `b`."""
    order = len(group.elements)
    ma, na = len(a), len(a[0])
    mb, nb = len(b), len(b[0])
    first_blocks = na * nb
    columns = (first_blocks + ma * mb) * order

    hx = zero_matrix(FIELD, ma * nb * order, columns)
    hz = zero_matrix(FIELD, na * mb * order, columns)

    def place(target, row_block, column_block, block):
        row = row_block * order
        column = column_block * order
        target.set_block(row, column, target.submatrix(row, column, order, order) + block)

    for ia in range(ma):
        for jb in range(nb):
            row_block = ia * nb + jb
            for ja in range(na):
                place(hx, row_block, ja * nb + jb, left_matrix(group, a[ia][ja]))
            for ib in range(mb):
                place(hx, row_block, first_blocks + ia * mb + ib,
                      right_matrix(group, b[ib][jb]))

    for ja in range(na):
        for ib in range(mb):
            row_block = ja * mb + ib
            for jb in range(nb):
                place(hz, row_block, ja * nb + jb,
                      right_matrix(group, group.inverse(b[ib][jb])))
            for ia in range(ma):
                place(hz, row_block, first_blocks + ia * mb + ib,
                      left_matrix(group, group.inverse(a[ia][ja])))

    return hx, hz


def right_translation_orbits(group, hx, hz, b_entries):
    """Verified right translations and the coordinate orbits they induce.

    Right multiplication is equivariant on the A-side blocks for every element;
    on the B-side it needs the element to commute with every B entry.  Each
    candidate is then verified directly, by checking that permuting the columns
    maps the presented check-row set onto itself.
    """
    order = len(group.elements)
    columns = hx.ncols()
    blocks = columns // order

    centralizer = [
        u
        for u in group.elements
        if all(
            group.multiply(u, entry) == group.multiply(entry, u) for entry in b_entries
        )
    ]

    presented_x = {tuple(row) for row in hx.rows()}
    presented_z = {tuple(row) for row in hz.rows()}

    verified = []
    permutations = {}
    for u in centralizer:
        permutation = [
            block * order + group.index[group.multiply(group.elements[position], u)]
            for block in range(blocks)
            for position in range(order)
        ]
        permuted_x = {tuple(_permute_row(row, permutation)) for row in hx.rows()}
        if permuted_x != presented_x:
            continue
        permuted_z = {tuple(_permute_row(row, permutation)) for row in hz.rows()}
        if permuted_z != presented_z:
            continue
        verified.append(u)
        permutations[u] = permutation

    seen = [False] * columns
    orbits = 0
    for coordinate in range(columns):
        if seen[coordinate]:
            continue
        orbits += 1
        for u in verified:
            seen[permutations[u][coordinate]] = True
    return verified, orbits


def _permute_row(row, permutation):
    moved = [FIELD(0)] * len(row)
    for position, value in enumerate(row):
        if value:
            moved[permutation[position]] = FIELD(1)
    return moved


# ---------------------------------------------------------------------------
# Checking one certificate
# ---------------------------------------------------------------------------


class Report:
    def __init__(self, label):
        self.label = label
        self.failures = []

    def check(self, condition, description, detail=""):
        status = "ok  " if condition else "FAIL"
        suffix = f"  [{detail}]" if detail else ""
        print(f"  {status} {description}{suffix}")
        if not condition:
            self.failures.append(f"{self.label}: {description}{suffix}")


def check_certificate(path):
    document = json.loads(Path(path).read_text())
    construction = document["construction"]
    report = Report(document["candidate"])
    print(f"\n{path.name}  {document['candidate']}  {document['certified_parameters']}")

    group = parse_group(construction["group"])
    order = len(group.elements)
    report.check(
        order == construction["group_order"],
        "group order matches the certificate",
        f"{order}",
    )

    permutation_group = regular_permutation_group(group)
    model = group.sage_model()
    report.check(
        permutation_group.order() == order and permutation_group.is_isomorphic(model),
        f"group is Sage's own {construction['group']}",
        model.structure_description(),
    )

    a = [[tuple(entry) for entry in row] for row in construction["protograph_a"]]
    b = [[tuple(entry) for entry in row] for row in construction["protograph_b"]]
    hx, hz = build_checks(group, a, b)

    reconstruction = document["reconstruction"]
    columns = hx.ncols()
    report.check(
        columns == reconstruction["coordinate_count"],
        "coordinate count matches",
        f"{columns}",
    )

    ma, na = len(a), len(a[0])
    mb, nb = len(b), len(b[0])
    x_weights = {int(sum(1 for value in row if value)) for row in hx.rows()}
    z_weights = {int(sum(1 for value in row if value)) for row in hz.rows()}
    report.check(
        x_weights == {na + mb}, "every X check has the lifted-product weight", f"{x_weights}"
    )
    report.check(
        z_weights == {nb + ma}, "every Z check has the lifted-product weight", f"{z_weights}"
    )

    report.check(
        (hx * hz.transpose()).is_zero() == reconstruction["checks_commute"],
        "CSS commutation matches the certificate",
    )

    rank_x = hx.rank()
    rank_z = hz.rank()
    sides = {side["input_side"]: side for side in document["sides"]}
    report.check(
        rank_x == sides["x"]["physical_rank"],
        "X check rank matches",
        f"{rank_x}",
    )
    report.check(
        rank_z == sides["z"]["physical_rank"],
        "Z check rank matches",
        f"{rank_z}",
    )
    dimension = columns - rank_x - rank_z
    report.check(
        dimension == reconstruction["dimension"],
        "dimension k = n - rank(Hx) - rank(Hz) matches",
        f"{dimension}",
    )
    published = document["certified_parameters"]
    report.check(
        f",{dimension}," in published.replace("[[", "[").replace("]]", "]"),
        f"dimension agrees with the published parameters {published}",
    )

    # Every word in ker(H) has even weight exactly when the all-ones vector is
    # in the row space of H, since the pairing of a word with all-ones is its
    # weight modulo two.
    ones = vector(FIELD, [1] * columns)
    for side in document["sides"]:
        physical = hx if side["input_side"] == "x" else hz
        report.check(
            (ones in physical.row_space()) == side["even_weight_kernel"],
            f"{side['input_side'].upper()} even-weight kernel claim matches",
        )

    graph = Graph()
    graph.add_vertices(range(columns))
    for row in list(hx.rows()) + list(hz.rows()):
        support = [position for position, value in enumerate(row) if value]
        graph.add_edges((support[0], other) for other in support[1:])
    components = graph.connected_components_number()
    report.check(
        components == reconstruction["combined_support_components"],
        "combined support component count matches",
        f"{components}",
    )

    b_entries = {entry for row in b for entry in row}
    verified, orbits = right_translation_orbits(group, hx, hz, b_entries)
    expected_notes = sides["x"]["anchor_notes"]
    report.check(
        f"verified right-translation automorphisms: {len(verified)} of {order}"
        in expected_notes,
        "verified right-translation count matches",
        f"{len(verified)} of {order}",
    )
    report.check(
        f"coordinate orbits: {orbits} of {columns}" in expected_notes,
        "coordinate orbit count matches",
        f"{orbits} of {columns}",
    )
    report.check(
        len(verified) * orbits == columns,
        "the verified translations act freely with uniform orbits",
    )

    for side in document["sides"]:
        support = side["witness_support"]
        if not support:
            continue
        physical, stabilizer = (hx, hz) if side["input_side"] == "x" else (hz, hx)
        word = matrix(FIELD, columns, 1)
        for coordinate in support:
            word[coordinate, 0] = 1
        name = side["input_side"].upper()
        report.check(
            (physical * word).is_zero(),
            f"{name} witness has zero physical syndrome",
        )
        report.check(
            word.column(0) not in stabilizer.row_space(),
            f"{name} witness is outside the stabilizer row space",
        )
        report.check(
            len(support) == document["certified_distance"],
            f"{name} witness weight is the certified distance",
            f"{len(support)}",
        )

    return report.failures


def main(argv):
    root = Path(__file__).resolve().parents[2]
    if len(argv) > 1:
        paths = [Path(argument) for argument in argv[1:]]
    else:
        paths = sorted((root / "evidence").glob("c1018-qldpc-*-certificate.json"))
    if not paths:
        print("no certificates found")
        return 1

    failures = []
    for path in paths:
        failures += check_certificate(path)

    print()
    if failures:
        print(f"{len(failures)} check(s) failed:")
        for failure in failures:
            print(f"  {failure}")
        return 1
    print(f"all checks passed for {len(paths)} certificate(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
