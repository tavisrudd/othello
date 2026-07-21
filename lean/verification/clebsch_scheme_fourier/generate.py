#!/usr/bin/env python3
"""Generator for the Lean data module encoding the q=11 rank-eight syndrome-scheme
Fourier certificate.

This script reconstructs the frozen rank-eight Fourier tables and additive-nonclosure
witnesses from the reduced projective ``H3`` orbits on ``F_11^3`` and cross-checks every
emitted spectral/count field against the independently generated scheme certificate.
It then emits:

  * ``lean/RelativeConicArcs/ClebschSchemeFourierData.lean`` -- a definitions-only Lean
    module freezing the two eigenmatrices, the hyperplane projective-line counts, the
    projective-line relation classifier, and one additive-non-closure witness pair for
    each of the 126 proper nonempty unions of nonidentity relations; and
  * ``lean/verification/clebsch_scheme_fourier/data.json`` -- a canonical machine-readable
    copy of the same data with provenance hashes.

Lean proves an abstract character identity and checks literal consequences of this frozen
data: equality and products of the candidate matrices, their dimensions and scalar-line
formula, and successful additive-nonclosure witness classification. Identifying the data
with the geometric association scheme, hence interpreting it as Fourier self-duality or
primitivity of that scheme, remains an external exact-computation boundary.

Trusted boundary: Python 3 exact integer arithmetic, exhaustive finite enumeration over
``F_11^3``, the pinned orbit construction, and the selected spectral/count fields of the
scheme certificate pinned below by SHA-256. The separate certificate checker reconstructs
the complete intersection/Krein tensors and 877-partition fusion census; this generator
does not consume those optional fields.

Usage::

    python3 lean/verification/clebsch_scheme_fourier/generate.py
    python3 lean/verification/clebsch_scheme_fourier/generate.py --check
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]

# The pinned orbit construction (reduced projective H3 on F_11^3).
DECODER_PATH = ROOT / "orbit_construction.py"
DECODER_SHA256 = "1ea02f4a27c59a24c780d6bc6ed3eb249de829fa9f55759ddb4cf73e32d51e32"

# The frozen scheme certificate whose eigenmatrices, counts and fusion data we replay.
CERT_PATH = ROOT / "scheme_certificate.json"
CERT_CHECKER_PATH = ROOT / "check_scheme_certificate.py"

JSON_OUTPUT = ROOT / "data.json"
LEAN_OUTPUT = REPO / "lean" / "RelativeConicArcs" / "ClebschSchemeFourierData.lean"
SHA256_OUTPUT = ROOT / "SHA256SUMS"

Q = 11
SCHEMA = "clebsch-scheme-fourier-lean-v1"

# Multiplicative inverses in F_11, tabulated so the Lean projective normalization is a
# finite match rather than a modular exponentiation: inv11[k] = k^{-1} mod 11.
INV11 = [0, 1, 6, 4, 3, 9, 2, 8, 7, 5, 10]


def load_decoder():
    assert hashlib.sha256(DECODER_PATH.read_bytes()).hexdigest() == DECODER_SHA256, (
        "pinned orbit construction changed; refusing to generate against it"
    )
    spec = importlib.util.spec_from_file_location("clebsch_scheme_decoder", DECODER_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def inverse(matrix: list[list[int]]) -> list[list[Fraction]]:
    size = len(matrix)
    work = [[Fraction(matrix[i][j]) for j in range(size)] + [Fraction(i == j) for j in range(size)]
            for i in range(size)]
    for col in range(size):
        pivot = next(r for r in range(col, size) if work[r][col] != 0)
        work[col], work[pivot] = work[pivot], work[col]
        scale = work[col][col]
        work[col] = [value / scale for value in work[col]]
        for r in range(size):
            if r != col and work[r][col] != 0:
                factor = work[r][col]
                work[r] = [a - factor * b for a, b in zip(work[r], work[col])]
    return [row[size:] for row in work]


def build() -> dict[str, object]:
    """Reconstruct the scheme and return every datum the Lean module freezes."""
    decoder = load_decoder()
    tau = 8
    roots = decoder.h3_roots(Q, tau)
    columns = decoder.six_points(Q, tau)
    group = decoder.reflection_group(Q, roots)
    labelled = decoder.label_orbits(decoder.vector_orbits(group, Q), roots, columns, Q)
    labels = [label for label, _ in labelled]
    classes = [orbit for _, orbit in labelled]
    class_of = {vector: index for index, orbit in enumerate(classes) for vector in orbit}
    assert INV11 == [0] + [pow(k, Q - 2, Q) for k in range(1, Q)]

    representatives = [min(orbit) for orbit in classes]

    # First eigenmatrix P from the scalar-line character sum: an orbit of ell projective
    # lines with z of them orthogonal to the character y contributes 11 z - ell.
    first_eigenmatrix = []
    hyperplane_counts = []
    for character in representatives:
        eig_row = []
        count_row = []
        for orbit in classes:
            if orbit == {(0, 0, 0)}:
                eig_row.append(1)
                count_row.append(1)
                continue
            projective_lines = {decoder.normalize(vector, Q) for vector in orbit}
            zero_lines = sum(decoder.dot(character, line, Q) == 0 for line in projective_lines)
            eig_row.append(Q * zero_lines - len(projective_lines))
            count_row.append(zero_lines)
        first_eigenmatrix.append(eig_row)
        hyperplane_counts.append(count_row)

    order = Q ** 3
    q_fraction = [[order * value for value in row] for row in inverse(first_eigenmatrix)]
    assert all(value.denominator == 1 for row in q_fraction for value in row)
    second_eigenmatrix = [[int(value) for value in row] for row in q_fraction]

    valencies = [len(orbit) for orbit in classes]
    multiplicities = second_eigenmatrix[0]

    # Projective-line relation classifier: every nonzero relation is a union of full
    # scalar lines, so a vector's relation is that of its normalized projective point.
    line_classifier = []
    for index, orbit in enumerate(classes):
        if orbit == {(0, 0, 0)}:
            continue
        for line in {decoder.normalize(vector, Q) for vector in orbit}:
            line_classifier.append((line, index))
    line_classifier.sort()
    assert len(line_classifier) == (order - 1) // (Q - 1)  # 133 projective lines
    assert len({line for line, _ in line_classifier}) == len(line_classifier)

    # Exhaustively search for one additive-non-closure witness for each proper nonempty
    # union of nonidentity relations: x, y in the union with x + y outside it (and
    # nonzero). Finding a witness for every mask establishes the required nonclosure;
    # no subgroup classification is assumed.
    def add(x, y):
        return tuple((x[d] + y[d]) % Q for d in range(3))

    witnesses = []
    for mask in range(1, (1 << 7) - 1):
        chosen = {index + 1 for index in range(7) if mask >> index & 1}
        union = set().union(*(classes[index] for index in chosen))
        found = None
        for x in sorted(union):
            for y in sorted(union):
                total = add(x, y)
                if total != (0, 0, 0) and total not in union:
                    found = (x, y)
                    break
            if found is not None:
                break
        assert found is not None, f"union {sorted(chosen)} unexpectedly additively closed"
        witnesses.append((mask, sorted(chosen), found[0], found[1]))

    # Independent replay of the self-dual spectral identities on the reconstructed data.
    assert second_eigenmatrix == first_eigenmatrix
    assert multiplicities == valencies
    assert all(
        sum(first_eigenmatrix[i][k] * second_eigenmatrix[k][j] for k in range(8))
        == order * (i == j)
        for i in range(8)
        for j in range(8)
    )
    for i in range(8):
        for j in range(8):
            expect = 1 if j == 0 else Q * hyperplane_counts[i][j] - hyperplane_counts[0][j]
            assert first_eigenmatrix[i][j] == expect

    cert_bytes = CERT_PATH.read_bytes()
    cert = json.loads(cert_bytes)
    assert cert["first_eigenmatrix_P"] == first_eigenmatrix
    assert cert["second_eigenmatrix_Q"] == second_eigenmatrix
    assert cert["valencies"] == valencies
    assert cert["multiplicities"] == multiplicities
    assert cert["hyperplane_projective_line_counts"] == hyperplane_counts
    assert cert["relation_labels"] == labels
    assert cert["dual_orbit_labels_under_dot_product"] == labels

    return {
        "schema": SCHEMA,
        "field": Q,
        "order": order,
        "relation_labels": labels,
        "valencies": valencies,
        "multiplicities": multiplicities,
        "first_eigenmatrix_P": first_eigenmatrix,
        "second_eigenmatrix_Q": second_eigenmatrix,
        "hyperplane_projective_line_counts": hyperplane_counts,
        "inverse_table_mod_11": INV11,
        "projective_line_relation_classifier": [
            [list(line), index] for line, index in line_classifier
        ],
        "primitivity_witnesses": [
            {"mask": mask, "relations": chosen, "x": list(x), "y": list(y)}
            for mask, chosen, x, y in witnesses
        ],
        "provenance": {
            "orbit_construction": DECODER_PATH.name,
            "orbit_construction_sha256": DECODER_SHA256,
            "scheme_certificate": CERT_PATH.name,
            "scheme_certificate_sha256": hashlib.sha256(cert_bytes).hexdigest(),
        },
    }


def fmt_vector(vec) -> str:
    return f"({vec[0]}, {vec[1]}, {vec[2]})"


def fmt_int_matrix(rows) -> str:
    return ",\n    ".join("[" + ", ".join(str(v) for v in row) + "]" for row in rows)


def render_lean(data: dict[str, object]) -> str:
    p_rows = fmt_int_matrix(data["first_eigenmatrix_P"])
    q_rows = fmt_int_matrix(data["second_eigenmatrix_Q"])
    count_rows = fmt_int_matrix(data["hyperplane_projective_line_counts"])
    valencies = ", ".join(str(v) for v in data["valencies"])
    inv_entries = ", ".join(str(v) for v in data["inverse_table_mod_11"])

    classifier = ",\n    ".join(
        f"({fmt_vector(line)}, {index})" for line, index in data["projective_line_relation_classifier"]
    )
    witnesses = ",\n    ".join(
        "({mask}, [{rels}], {x}, {y})".format(
            mask=w["mask"],
            rels=", ".join(str(r) for r in w["relations"]),
            x=fmt_vector(w["x"]),
            y=fmt_vector(w["y"]),
        )
        for w in data["primitivity_witnesses"]
    )

    return f'''\
/-
Generated source -- do not edit by hand.

Frozen integer tables reconstructed from the reduced projective icosahedral action on
`F_11^3`. The tracked generator
`lean/verification/clebsch_scheme_fourier/generate.py` reads the pinned exhaustive orbit
construction `lean/verification/clebsch_scheme_fourier/orbit_construction.py`, checks its
SHA-256 digest, cross-checks the result against
`lean/verification/clebsch_scheme_fourier/scheme_certificate.json`, reproduced by
`lean/verification/clebsch_scheme_fourier/check_scheme_certificate.py`, and emits canonical
schema `{SCHEMA}` data in `lean/verification/clebsch_scheme_fourier/data.json`.

The geometric interpretation of the frozen relations, eigenmatrices, and incidence
counts is an external exact-enumeration boundary. The companion Lean development checks
the abstract character identity and literal table consequences, including matrix
products, equality of the frozen matrices, and all recorded nonclosure witnesses; it
does not construct an association scheme or prove that the tables describe the stated
group action.

Semantic content:
* `firstEigenmatrix`, `secondEigenmatrix` : frozen candidate `8 x 8` eigenmatrices `P`
  and `Q`, in the fixed relation ordering
  `0, column_D5, triple_S3, deep_hole_C5, double_V4, single_secant_C2_1..3`;
* `valencies` : frozen candidate relation valencies;
* `hyperplaneLineCounts` : entry `(i, j)` is the number of projective lines of relation
  `j` orthogonal to a representative character of relation `i`; row `0` is the number of
  projective lines in each relation;
* `inverseModEleven` : multiplicative inverses in `F_11`, used by the projective
  normalization;
* `lineRelationClassifier` : each of the `133` projective lines of `PG(2,11)`, given by
  its leading-coefficient-one representative, paired with the index of the relation
  containing it;
* `primitivityWitnesses` : for each of the `126` proper nonempty unions of the seven
  nonidentity relations (indexed by a seven-bit mask and the explicit relation list),
  a pair of scheme vectors lying in the union whose sum is nonzero and lies outside it.
-/
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Matrix.Basic

namespace RelativeConicArcs
namespace ClebschSchemeFourier

/-- A vector of the ambient translation module `F_11^3`. -/
abbrev SchemeVector : Type := ZMod {Q} × ZMod {Q} × ZMod {Q}

/-- The number of rows and columns in the frozen candidate eigenmatrices. -/
def schemeRank : Nat := 8

/-- The cardinality `11^3` used to normalize the frozen matrix product. -/
def schemeOrder : ℤ := {data["order"]}

/-- Frozen candidate first eigenmatrix `P`, with the ordering documented above. -/
def firstEigenmatrix : List (List ℤ) :=
  [{p_rows}]

/-- Frozen candidate second eigenmatrix `Q`, independently reconstructed as `1331 * P⁻¹`. -/
def secondEigenmatrix : List (List ℤ) :=
  [{q_rows}]

/-- Relation valencies in the fixed ordering. -/
def valencies : List ℤ := [{valencies}]

/-- Projective-line orthogonality counts `z(i, j)` entering the character-sum eigenvalue
`11 * z(i, j) - ℓ(j)`, where `ℓ(j)` is row `0`. -/
def hyperplaneLineCounts : List (List ℤ) :=
  [{count_rows}]

/-- Multiplicative inverse table for `F_11` (`inverseModEleven[k] = k⁻¹`, with slot `0`
unused). Consumed by the projective normalization in the companion development. -/
def inverseModEleven : List (ZMod {Q}) := [{inv_entries}]

/-- Each projective line of `PG(2,11)` (leading-coefficient-one representative) paired
with the index of the relation containing it. -/
def lineRelationClassifier : List (SchemeVector × Fin 8) :=
  [{classifier}]

/-- One additive-non-closure witness for each proper nonempty union of nonidentity
relations. Each entry is `(mask, relations, x, y)`: `mask` is the seven-bit code of the
chosen nonidentity relations, `relations` lists their indices, and `x, y` lie in the
union while `x + y` is nonzero and outside it. -/
def primitivityWitnesses : List (Nat × List (Fin 8) × SchemeVector × SchemeVector) :=
  [{witnesses}]

end ClebschSchemeFourier
end RelativeConicArcs
'''


def canonical_json(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def write_outputs(check: bool) -> int:
    data = build()
    json_bytes = canonical_json(data)
    lean_text = render_lean(data)

    targets = [(JSON_OUTPUT, json_bytes), (LEAN_OUTPUT, lean_text.encode())]
    digest_lines = []
    for path, payload in targets:
        digest_lines.append(
            f"{hashlib.sha256(payload).hexdigest()}  {path.relative_to(REPO)}"
        )
    generator_digest = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    digest_lines.append(f"{generator_digest}  {Path(__file__).relative_to(REPO)}")
    for input_path in (DECODER_PATH, CERT_PATH, CERT_CHECKER_PATH):
        digest_lines.append(
            f"{hashlib.sha256(input_path.read_bytes()).hexdigest()}  "
            f"{input_path.relative_to(REPO)}"
        )
    sha_text = "\n".join(digest_lines) + "\n"

    if check:
        problems = []
        for path, payload in targets:
            if not path.exists() or path.read_bytes() != payload:
                problems.append(str(path.relative_to(REPO)))
        if not SHA256_OUTPUT.exists() or SHA256_OUTPUT.read_bytes() != sha_text.encode():
            problems.append(str(SHA256_OUTPUT.relative_to(REPO)))
        if problems:
            print("CHECK FAILED; stale or missing: " + ", ".join(problems))
            return 1
        print("CHECK OK")
        return 0

    for path, payload in targets:
        path.write_bytes(payload)
    SHA256_OUTPUT.write_text(sha_text)
    print(f"wrote {JSON_OUTPUT.relative_to(REPO)}")
    print(f"wrote {LEAN_OUTPUT.relative_to(REPO)}")
    print(f"wrote {SHA256_OUTPUT.relative_to(REPO)}")
    return 0


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true",
                        help="verify tracked outputs match a fresh regeneration")
    args = parser.parse_args()
    sys.exit(write_outputs(args.check))


if __name__ == "__main__":
    main()
