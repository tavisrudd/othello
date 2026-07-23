#!/usr/bin/env python3
"""Stable generator for the compact finite projective certificate consumed by Lean."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import deque
from itertools import product
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
LEAN = ROOT / "lean/RelativeConicArcs/ClebschArithmeticGluingData.lean"
OUT = NOTES / "2026-07-22-c503-clebsch-arithmetic-gluing-lean.json"
MANIFEST = NOTES / "2026-07-22-c503-clebsch-arithmetic-gluing-lean.sha256"
BEGIN = "/- BEGIN ARITHMETIC GLUING CERTIFICATE DATA -/"
END = "/- END ARITHMETIC GLUING CERTIFICATE DATA -/"
INPUTS = [
    NOTES / "2026-07-21-c441-vertex-reduction-bijection.json",
    NOTES / "2026-07-21-c442-antipodal-singleton-reduction.json",
    NOTES / "2026-07-21-c444-silver-fusion.json",
    NOTES / "2026-07-21-c445-characteristic-11-gluing.json",
    NOTES / "2026-07-21-c449-split-coxeter-torus.json",
    NOTES / "2026-07-21-c458-golden-sheet-frame-freeze.json",
]

Matrix = tuple[int, int, int, int]
Point = int | None
Edge = tuple[Point, Point]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalize(q: int, m: Matrix) -> Matrix:
    m = tuple(x % q for x in m)
    leading = next(x for x in m if x)
    scale = pow(leading, -1, q)
    return tuple(scale * x % q for x in m)  # type: ignore[return-value]


def det(q: int, m: Matrix) -> int:
    a, b, c, d = m
    return (a * d - b * c) % q


def mul(q: int, m: Matrix, n: Matrix) -> Matrix:
    a, b, c, d = m
    e, f, g, h = n
    return normalize(q, (a * e + b * g, a * f + b * h, c * e + d * g, c * f + d * h))


def inv(q: int, m: Matrix) -> Matrix:
    a, b, c, d = m
    return normalize(q, (d, -b, -c, a))


def act(q: int, m: Matrix, x: Point) -> Point:
    a, b, c, d = m
    if x is None:
        return None if c == 0 else a * pow(c, -1, q) % q
    denominator = (c * x + d) % q
    return None if denominator == 0 else (a * x + b) * pow(denominator, -1, q) % q


def groups(q: int) -> tuple[list[Matrix], list[Matrix]]:
    pgl = sorted({normalize(q, m) for m in product(range(q), repeat=4) if det(q, m)})
    squares = {x * x % q for x in range(q)}
    return pgl, [m for m in pgl if det(q, m) in squares]


def mate_map(edges: list[Edge]) -> dict[Point, Point]:
    result: dict[Point, Point] = {}
    for x, y in edges:
        result[x] = y
        result[y] = x
    return result


def stabilizer(q: int, pgl: list[Matrix], edges: list[Edge]) -> list[Matrix]:
    mate = mate_map(edges)
    points: list[Point] = [None, *range(q)]
    return [
        m for m in pgl
        if all(act(q, m, mate[x]) == mate[act(q, m, x)] for x in points)
    ]


def signature(q: int, m: Matrix, edges: list[Edge]) -> tuple[int, ...]:
    mate = mate_map(edges)
    points: list[Point] = [None, *range(q)]
    mi = inv(q, m)
    values = [act(q, m, mate[act(q, mi, x)]) for x in points]
    return tuple(q if x is None else x for x in values)


def orbit_representatives(q: int, group: list[Matrix], edges: list[Edge]) -> list[Matrix]:
    reps: dict[tuple[int, ...], Matrix] = {}
    for m in group:
        reps.setdefault(signature(q, m, edges), m)
    return list(reps.values())


def generation_words(q: int, psl: list[Matrix], generators: list[Matrix]) -> list[tuple[int, int, int]]:
    identity = normalize(q, (1, 0, 0, 1))
    identity_index = generators.index(identity)
    word: dict[Matrix, tuple[int, ...]] = {g: (i,) for i, g in enumerate(generators)}
    queue: deque[Matrix] = deque(word)
    while queue:
        x = queue.popleft()
        if len(word[x]) >= 3:
            continue
        for i, g in enumerate(generators):
            y = mul(q, x, g)
            if y not in word:
                word[y] = (*word[x], i)
                queue.append(y)
    assert set(word) == set(psl)
    padded = []
    for m in psl:
        w = word[m]
        padded.append(tuple((*w, *([identity_index] * (3 - len(w))))))
    return padded


def source_matching() -> tuple[list[Edge], list[Edge]]:
    raw = json.loads((NOTES / "2026-07-21-c445-characteristic-11-gluing.json").read_text())
    finite = raw["exact_gluing_theorem"]["characteristic_11"]

    def decode(rows: list[list[int]]) -> list[Edge]:
        return [(None if x == 11 else x, None if y == 11 else y) for x, y in rows]

    return decode(finite["base_matching"]), decode(finite["jmate_matching"])


def source_literal_data() -> dict:
    """Extract and schema-compare every upstream literal used by the Lean definitions."""
    def load(name: str) -> dict:
        return json.loads((NOTES / name).read_text())

    def point(x: int | str) -> Point:
        return None if x in ("inf", 11) else int(x)

    c441 = load("2026-07-21-c441-vertex-reduction-bijection.json")
    cases = c441["cases"]
    a3_rows = cases["A3_octahedron"]["bijection_table"]
    b3_rows = cases["B3_cube"]["bijection_table"]
    h3_rows = cases["H3_icosahedron"]["bijection_table"]
    reductions = {
        "a3": [
            [point(row["point"]) for row in a3_rows],
            [point(row["point_iconj"]) for row in a3_rows],
        ],
        "b3": [
            [point(row["point_pi"]) for row in b3_rows],
            [point(row["point_pi_bar"]) for row in b3_rows],
        ],
        "h3": [
            [point(row["point_pi"]) for row in h3_rows],
            [point(row["point_pi_bar"]) for row in h3_rows],
        ],
    }
    assert reductions == {
        "a3": [[0, None, 1, 4, 2, 3], [0, None, 1, 4, 3, 2]],
        "b3": [[0, None, 3, 5, 6, 1, 2, 4], [0, None, 4, 2, 1, 6, 5, 3]],
        "h3": [
            [0, None, 2, 6, 7, 8, 10, 1, 3, 4, 5, 9],
            [0, None, 9, 4, 3, 1, 5, 2, 7, 10, 6, 8],
        ],
    }

    c444 = load("2026-07-21-c444-silver-fusion.json")
    def edges(rows: list[list[int | str]]) -> list[Edge]:
        return [(point(x), point(y)) for x, y in rows]

    matchings = {
        "a3_i2": edges(c444["A3"]["matching_at_i_2"]),
        "a3_i3": edges(c444["A3"]["matching_at_i_3"]),
        "b3_negative": edges(c444["B3"]["reductions"]["sqrt2_3"]["matching"]),
        "b3_positive": edges(c444["B3"]["reductions"]["sqrt2_4"]["matching"]),
    }
    c445 = load("2026-07-21-c445-characteristic-11-gluing.json")
    base, conjugate = source_matching()
    matchings["h3_base"] = base
    matchings["h3_conjugate"] = conjugate
    assert matchings == {
        "a3_i2": [(0, None), (1, 4), (2, 3)],
        "a3_i3": [(0, None), (1, 4), (2, 3)],
        "b3_negative": [(0, None), (1, 3), (2, 6), (4, 5)],
        "b3_positive": [(0, None), (1, 5), (2, 3), (4, 6)],
        "h3_base": [(0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, None)],
        "h3_conjugate": [(0, 10), (1, None), (2, 7), (3, 5), (4, 8), (6, 9)],
    }
    silver_transporter = sum(c444["B3"]["spin_model"]["silver_conjugation_matrix"], [])
    assert silver_transporter == [1, 0, 0, 6]
    golden_transporter = c445["exact_gluing_theorem"]["characteristic_11"][
        "outer_transporter"]["matrix_mod_11"]
    assert golden_transporter == [1, 10, 1, 1]

    c449 = load("2026-07-21-c449-split-coxeter-torus.json")
    torus = []
    for row in c449["finite_generator_images"]:
        q = row["prime_q"]
        a, b, c, d = row["generator_matrix_in_frozen_P1_frame"]
        assert (a, b, c) == (1, 0, 0)
        torus.append((q, pow(d, -1, q), row["coxeter_square_order"]))
        assert row["determinant_square"] is True
        assert row["action_decomposition"]["fixed_points"] == [0, "inf"]
    assert torus == [(5, 4, 2), (7, 2, 3), (7, 2, 3), (11, 9, 5), (11, 4, 5)]

    c442 = load("2026-07-21-c442-antipodal-singleton-reduction.json")
    assert c442["clause_i_antipodal_uniqueness"]["unique"] is True
    m0 = c442["clause_ii_singleton_identification"]["binary_form_frame_M0_frozen"]
    assert (m0["M0_pgl_orbit_size"], m0["M0_psl_orbit_size"],
            m0["M0_pgl_stabilizer_order"]) == (22, 11, 60)

    c458 = load("2026-07-21-c458-golden-sheet-frame-freeze.json")
    polar = c458["golden_sheet_frame"]["polar_pair_matching"]
    assert edges(polar["reduction_at_pi_phi_to_8"]["matching"]) == base
    assert edges(polar["reduction_at_pibar_phi_to_4"]["matching"]) == conjugate

    return {
        "vertex_reductions": reductions,
        "matchings": matchings,
        "silver_transporter": silver_transporter,
        "golden_transporter": golden_transporter,
        "coxeter_square_multipliers": [[5, 4], [7, 2], [11, 9], [11, 4]],
    }


def build() -> dict:
    q = 11
    pgl, psl = groups(q)
    base, conjugate = source_matching()
    base_stab = stabilizer(q, pgl, base)
    conjugate_stab = stabilizer(q, pgl, conjugate)
    generators = sorted(set(base_stab) | set(conjugate_stab))
    result = {
        "schema": "clebsch-arithmetic-gluing-lean-v1",
        "inputs": {path.name: digest(path) for path in INPUTS},
        "literal_data": source_literal_data(),
        "h3": {
            "base_stabilizer": base_stab,
            "conjugate_stabilizer": conjugate_stab,
            "pgl_coset_representatives": orbit_representatives(q, pgl, base),
            "psl_base_coset_representatives": orbit_representatives(q, psl, base),
            "psl_conjugate_coset_representatives": orbit_representatives(q, psl, conjugate),
            "generation_generators": generators,
            "generation_words": generation_words(q, psl, generators),
        },
    }
    h3 = result["h3"]
    assert len(h3["base_stabilizer"]) == len(h3["conjugate_stabilizer"]) == 60
    assert len(set(map(tuple, h3["base_stabilizer"])) & set(map(tuple, h3["conjugate_stabilizer"]))) == 12
    assert len(h3["pgl_coset_representatives"]) == 22
    assert len(h3["psl_base_coset_representatives"]) == 11
    assert len(h3["psl_conjugate_coset_representatives"]) == 11
    assert len(h3["generation_generators"]) == 108
    assert len(h3["generation_words"]) == 660
    return result


def matrix(m: list[int] | tuple[int, ...]) -> str:
    return f"projectiveMatrix {m[0]} {m[1]} {m[2]} {m[3]}"


def lean_list(name: str, values: list, item, lean_type: str) -> str:
    body = ",\n    ".join(item(x) for x in values)
    return f"def {name} : List ({lean_type}) :=\n  [{body}]\n"


def lean_block(data: dict) -> str:
    h3 = data["h3"]
    chunks = [
        "/- Generated by `notes/clebsch-arithmetic-gluing-lean-v1.py`, schema",
        "`clebsch-arithmetic-gluing-lean-v1`. -/",
        "/-- The sixty leading-normalized matrices stabilizing the base golden matching. -/",
        lean_list("h3BaseStabilizerCertificate", h3["base_stabilizer"], matrix,
            "ProjectiveMatrix 11"),
        "/-- The sixty leading-normalized matrices stabilizing the conjugate golden matching. -/",
        lean_list("h3ConjugateStabilizerCertificate", h3["conjugate_stabilizer"], matrix,
            "ProjectiveMatrix 11"),
        "/-- Representatives for the twenty-two projective cosets of the base stabilizer. -/",
        lean_list("h3ProjectiveCosetRepresentatives", h3["pgl_coset_representatives"], matrix,
            "ProjectiveMatrix 11"),
        "/-- Representatives for the eleven square-determinant cosets of the base stabilizer. -/",
        lean_list("h3BaseSquareCosetRepresentatives", h3["psl_base_coset_representatives"], matrix,
            "ProjectiveMatrix 11"),
        "/-- Representatives for the eleven square-determinant cosets of the conjugate stabilizer. -/",
        lean_list("h3ConjugateSquareCosetRepresentatives",
            h3["psl_conjugate_coset_representatives"], matrix, "ProjectiveMatrix 11"),
        "/-- The union of the two golden matching stabilizers, in fixed matrix order. -/",
        lean_list("h3GenerationGenerators", h3["generation_generators"], matrix,
            "ProjectiveMatrix 11"),
        "/-- Length-three padded words covering every square-determinant projective matrix. -/",
        lean_list(
            "h3GenerationWords",
            h3["generation_words"],
            lambda w: f"[{w[0]}, {w[1]}, {w[2]}]",
            "List Nat",
        ),
    ]
    return "\n".join(chunks).rstrip() + "\n"


def rendered(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def updated_lean(data: dict) -> bytes:
    text = LEAN.read_text()
    before, rest = text.split(BEGIN, 1)
    _, after = rest.split(END, 1)
    return (before + BEGIN + "\n" + lean_block(data) + END + after).encode()


def manifest_bytes(data_bytes: bytes, lean_bytes: bytes) -> bytes:
    rows = [
        (hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            str(Path(__file__).relative_to(ROOT))),
        (hashlib.sha256(data_bytes).hexdigest(), str(OUT.relative_to(ROOT))),
        (hashlib.sha256(lean_bytes).hexdigest(), str(LEAN.relative_to(ROOT))),
    ]
    return "".join(f"{sha}  {name}\n" for sha, name in rows).encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    data = build()
    data_bytes = rendered(data)
    lean_bytes = updated_lean(data)
    manifest = manifest_bytes(data_bytes, lean_bytes)
    if args.write:
        OUT.write_bytes(data_bytes)
        LEAN.write_bytes(lean_bytes)
        MANIFEST.write_bytes(manifest)
        print("WROTE")
        return
    assert OUT.read_bytes() == data_bytes
    assert LEAN.read_bytes() == lean_bytes
    assert MANIFEST.read_bytes() == manifest
    print("CHECK OK")


if __name__ == "__main__":
    main()
