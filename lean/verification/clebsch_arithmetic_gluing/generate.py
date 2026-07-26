#!/usr/bin/env python3
"""Generate the rank-three arithmetic-gluing finite projective certificate.

The canonical source records reductions, matchings, transporters, and torus multipliers.
This generator exhaustively reconstructs normalized PGL(2,11), its square-determinant half,
the two matching stabilizers and their transported signatures, and a bounded word cover.
Lean kernel-checks the literal invariants stated in the generated module; this program is
the reproducibility source for stabilizer, coset, and word-coverage completeness.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import deque
from itertools import product
from pathlib import Path

HERE = Path(__file__).resolve().parent
LEAN_ROOT = HERE.parents[1]
LEAN = LEAN_ROOT / "RelativeConicArcs/ClebschArithmeticGluingData.lean"
SOURCE = HERE / "source_data.json"
OUT = HERE / "certificate.json"
MANIFEST = HERE / "manifest.sha256"
REPLAY = HERE / "replay.py"
MAIN = LEAN_ROOT / "RelativeConicArcs/ClebschArithmeticGluing.lean"
GATE = LEAN_ROOT / "RelativeConicArcs/Gates/ClebschArithmeticGluing.lean"
BEGIN = "/- BEGIN ARITHMETIC GLUING CERTIFICATE DATA -/"
END = "/- END ARITHMETIC GLUING CERTIFICATE DATA -/"

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


def source_literal_data() -> dict:
    """Load and validate the canonical literal input used by the Lean definitions."""
    raw = json.loads(SOURCE.read_text())
    assert raw["schema"] == "clebsch-arithmetic-gluing-source-v1"
    literal = raw["literal_data"]
    reductions = literal["vertex_reductions"]
    assert reductions == {
        "a3": [[0, None, 1, 4, 2, 3], [0, None, 1, 4, 3, 2]],
        "b3": [[0, None, 3, 5, 6, 1, 2, 4], [0, None, 4, 2, 1, 6, 5, 3]],
        "h3": [
            [0, None, 2, 6, 7, 8, 10, 1, 3, 4, 5, 9],
            [0, None, 9, 4, 3, 1, 5, 2, 7, 10, 6, 8],
        ],
    }

    matchings = literal["matchings"]
    assert matchings == {
        "a3_i2": [[0, None], [1, 4], [2, 3]],
        "a3_i3": [[0, None], [1, 4], [2, 3]],
        "b3_negative": [[0, None], [1, 3], [2, 6], [4, 5]],
        "b3_positive": [[0, None], [1, 5], [2, 3], [4, 6]],
        "h3_base": [[0, 1], [2, 5], [3, 7], [4, 9], [6, 8], [10, None]],
        "h3_conjugate": [[0, 10], [1, None], [2, 7], [3, 5], [4, 8], [6, 9]],
    }
    silver_transporter = literal["silver_transporter"]
    assert silver_transporter == [1, 0, 0, 6]
    golden_transporter = literal["golden_transporter"]
    assert golden_transporter == [1, 10, 1, 1]
    assert literal["coxeter_square_multipliers"] == [[5, 4], [7, 2], [11, 9], [11, 4]]
    return literal


def build() -> dict:
    q = 11
    pgl, psl = groups(q)
    literal = source_literal_data()
    base = [tuple(edge) for edge in literal["matchings"]["h3_base"]]
    conjugate = [tuple(edge) for edge in literal["matchings"]["h3_conjugate"]]
    base_stab = stabilizer(q, pgl, base)
    conjugate_stab = stabilizer(q, pgl, conjugate)
    generators = sorted(set(base_stab) | set(conjugate_stab))
    result = {
        "schema": "clebsch-arithmetic-gluing-lean-v1",
        "inputs": {SOURCE.name: digest(SOURCE)},
        "literal_data": literal,
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
        "/- Generated by `verification/clebsch_arithmetic_gluing/generate.py`, schema",
        "`clebsch-arithmetic-gluing-lean-v1`. Lean checks the literal list properties;",
        "the generator and independent replay establish the stated exhaustive semantics. -/",
        "/-- Sixty leading-normalized matrices certified externally as the base stabilizer. -/",
        lean_list("h3BaseStabilizerCertificate", h3["base_stabilizer"], matrix,
            "ProjectiveMatrix 11"),
        "/-- Sixty matrices certified externally as the conjugate stabilizer. -/",
        lean_list("h3ConjugateStabilizerCertificate", h3["conjugate_stabilizer"], matrix,
            "ProjectiveMatrix 11"),
        "/-- A list certified externally to represent the twenty-two projective cosets. -/",
        lean_list("h3ProjectiveCosetRepresentatives", h3["pgl_coset_representatives"], matrix,
            "ProjectiveMatrix 11"),
        "/-- A list certified externally to represent the eleven base-sheet cosets. -/",
        lean_list("h3BaseSquareCosetRepresentatives", h3["psl_base_coset_representatives"], matrix,
            "ProjectiveMatrix 11"),
        "/-- A list certified externally to represent the eleven conjugate-sheet cosets. -/",
        lean_list("h3ConjugateSquareCosetRepresentatives",
            h3["psl_conjugate_coset_representatives"], matrix, "ProjectiveMatrix 11"),
        "/-- A fixed generator list certified externally as the union of the two stabilizers. -/",
        lean_list("h3GenerationGenerators", h3["generation_generators"], matrix,
            "ProjectiveMatrix 11"),
        "/-- Literal padded words whose exhaustive coverage is checked by generator and replay. -/",
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
            str(Path(__file__).relative_to(LEAN_ROOT))),
        (digest(SOURCE), str(SOURCE.relative_to(LEAN_ROOT))),
        (hashlib.sha256(data_bytes).hexdigest(), str(OUT.relative_to(LEAN_ROOT))),
        (hashlib.sha256(lean_bytes).hexdigest(), str(LEAN.relative_to(LEAN_ROOT))),
        (digest(REPLAY), str(REPLAY.relative_to(LEAN_ROOT))),
        (digest(MAIN), str(MAIN.relative_to(LEAN_ROOT))),
        (digest(GATE), str(GATE.relative_to(LEAN_ROOT))),
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
