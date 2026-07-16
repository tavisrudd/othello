#!/usr/bin/env python3
"""Generate the shared Q25 point-on-line masks and conjugate-carrier witnesses.

This is an independent proposal generator, not a trusted proof checker.  It mirrors the
concrete conventions used by ``Q25Coordinates``, ``Q25PairCertificate``, and
``Q25LineMaskChecker``:

* GF(25) is F_5[w]/(w^2-2), encoded as ``a + 5*b``;
* canonical projective vectors are ``(1,y,z)``, ``(0,1,z)``, ``(0,0,1)``;
* their index is ``y*25+z``, ``625+z``, ``650`` respectively;
* orbit bits are indexed by stable Lean ``orbitNumber`` and packed little-endian into
  five 64-bit words.

For every canonical dual line, bit ``n`` is set precisely when
``orbitIdx (orbitCodeOfNumber n)`` lies on that line.  For every nonfixed conjugate pair,
the output also records the canonical carrier-line index and the nonzero GF(25) scale
``r`` for ``crossVec p (conjIdx p) = r • vec line``.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from dataclasses import dataclass
from itertools import product
from pathlib import Path
from typing import Iterable, Sequence

Vec = tuple[int, int, int]

FIELD_ORDER = 25
POINT_COUNT = 651
ORBIT_COUNT = 310
WORD_BITS = 64
WORD_COUNT = 5
LEAN_LINES_PER_MODULE = 10


def add(x: int, y: int) -> int:
    return ((x % 5 + y % 5) % 5) + 5 * ((x // 5 + y // 5) % 5)


def neg(x: int) -> int:
    return ((-x) % 5) + 5 * ((-(x // 5)) % 5)


def sub(x: int, y: int) -> int:
    return add(x, neg(y))


def mul(x: int, y: int) -> int:
    a, b, c, d = x % 5, x // 5, y % 5, y // 5
    return ((a * c + 2 * b * d) % 5) + 5 * ((a * d + b * c) % 5)


def power(x: int, exponent: int) -> int:
    result = 1
    while exponent:
        if exponent & 1:
            result = mul(result, x)
        x = mul(x, x)
        exponent >>= 1
    return result


def conjugate_scalar(x: int) -> int:
    result = (x % 5) + 5 * ((-(x // 5)) % 5)
    assert result == power(x, 5)
    return result


def smul(scale: int, vector: Vec) -> Vec:
    return tuple(mul(scale, x) for x in vector)  # type: ignore[return-value]


def raw_cross(a: Vec, b: Vec) -> Vec:
    return (
        sub(mul(a[1], b[2]), mul(a[2], b[1])),
        sub(mul(a[2], b[0]), mul(a[0], b[2])),
        sub(mul(a[0], b[1]), mul(a[1], b[0])),
    )


def canonicalize(vector: Vec) -> tuple[Vec, int]:
    """Return canonical vector and r with ``vector = r * canonical``."""

    pivot = next(x for x in vector if x != 0)
    inverse = power(pivot, 23)
    canonical = smul(inverse, vector)
    assert smul(pivot, canonical) == vector
    return canonical, pivot


def conjugate_vector(vector: Vec) -> Vec:
    raw = tuple(conjugate_scalar(x) for x in vector)
    return canonicalize(raw)[0]  # type: ignore[arg-type]


def dot(line: Vec, point: Vec) -> int:
    return add(add(mul(line[0], point[0]), mul(line[1], point[1])), mul(line[2], point[2]))


def determinant(a: Vec, b: Vec, c: Vec) -> int:
    """Expanded 3-by-3 row determinant, independent of ``raw_cross``."""

    first = mul(a[0], sub(mul(b[1], c[2]), mul(b[2], c[1])))
    second = mul(a[1], sub(mul(b[0], c[2]), mul(b[2], c[0])))
    third = mul(a[2], sub(mul(b[0], c[1]), mul(b[1], c[0])))
    return add(sub(first, second), third)


def canonical_vectors() -> tuple[Vec, ...]:
    vectors = tuple(
        [(1, y, z) for y in range(FIELD_ORDER) for z in range(FIELD_ORDER)]
        + [(0, 1, z) for z in range(FIELD_ORDER)]
        + [(0, 0, 1)]
    )
    assert len(vectors) == POINT_COUNT
    assert all(line_index(vector) == i for i, vector in enumerate(vectors))
    return vectors


def line_index(vector: Vec) -> int:
    if vector[0] == 1:
        return vector[1] * 25 + vector[2]
    if vector[1] == 1:
        return 625 + vector[2]
    assert vector == (0, 0, 1)
    return 650


def lean_orbit_number(p: Vec, q: Vec) -> int:
    representative = p if line_index(p) < line_index(q) else q
    if representative[0] == 1:
        yr, yi = representative[1] % 5, representative[1] // 5
        if yi != 0:
            assert yi in (1, 2)
            return (yr * 2 + yi - 1) * 25 + representative[2]
        zr, zi = representative[2] % 5, representative[2] // 5
        assert zi in (1, 2)
        return 250 + (yr * 5 + zr) * 2 + zi - 1
    zr, zi = representative[2] % 5, representative[2] // 5
    assert representative[1] == 1 and zi in (1, 2)
    return 300 + zr * 2 + zi - 1


def pack_bits(indices: Iterable[int]) -> tuple[int, ...]:
    words = [0] * WORD_COUNT
    for index in indices:
        assert 0 <= index < ORBIT_COUNT
        words[index // WORD_BITS] |= 1 << (index % WORD_BITS)
    assert words[-1] >> (ORBIT_COUNT % WORD_BITS) == 0
    return tuple(words)


def test_mask_bit(words: Sequence[int], index: int) -> bool:
    return bool((words[index // WORD_BITS] >> (index % WORD_BITS)) & 1)


@dataclass(frozen=True)
class CarrierWitness:
    orbit_number: int
    representative_rank: int
    conjugate_rank: int
    line_index: int
    scale: int


@dataclass(frozen=True)
class LineRecord:
    index: int
    vector: Vec
    words: tuple[int, ...]
    incidence_count: int
    spanning_point_ranks: tuple[int, int]
    spanning_scale: int
    conjugate_index: int


@dataclass(frozen=True)
class Dataset:
    lines: tuple[LineRecord, ...]
    carriers: tuple[CarrierWitness, ...]


def enumerate_orbit_representatives(points: Sequence[Vec]) -> tuple[Vec, ...]:
    numbered: dict[int, Vec] = {}
    for p in points:
        q = conjugate_vector(p)
        if line_index(p) >= line_index(q):
            continue
        number = lean_orbit_number(p, q)
        assert number not in numbered
        numbered[number] = p
    assert set(numbered) == set(range(ORBIT_COUNT))
    representatives = tuple(numbered[n] for n in range(ORBIT_COUNT))
    assert all(line_index(p) < line_index(conjugate_vector(p)) for p in representatives)
    return representatives


def build_dataset() -> Dataset:
    points = canonical_vectors()
    representatives = enumerate_orbit_representatives(points)

    lines: list[LineRecord] = []
    total_incidences = 0
    for index, line in enumerate(points):
        incident_points = tuple(i for i, point in enumerate(points) if dot(line, point) == 0)
        assert len(incident_points) == 26
        a_rank, b_rank = incident_points[:2]
        spanning_raw = raw_cross(points[a_rank], points[b_rank])
        spanning_line, spanning_scale = canonicalize(spanning_raw)
        assert spanning_line == line and spanning_scale != 0

        incident_representatives = tuple(
            n for n, point in enumerate(representatives) if dot(line, point) == 0
        )
        words = pack_bits(incident_representatives)
        for n, point in enumerate(representatives):
            by_dot = dot(line, point) == 0
            by_det = determinant(points[a_rank], points[b_rank], point) == 0
            assert test_mask_bit(words, n) == by_dot == by_det
            assert dot(spanning_raw, point) == determinant(points[a_rank], points[b_rank], point)

        conjugate_line = conjugate_vector(line)
        lines.append(
            LineRecord(
                index=index,
                vector=line,
                words=words,
                incidence_count=len(incident_representatives),
                spanning_point_ranks=(a_rank, b_rank),
                spanning_scale=spanning_scale,
                conjugate_index=line_index(conjugate_line),
            )
        )
        total_incidences += len(incident_representatives)
    assert total_incidences == ORBIT_COUNT * 26

    carriers: list[CarrierWitness] = []
    for number, p in enumerate(representatives):
        q = conjugate_vector(p)
        carrier_raw = raw_cross(p, q)
        carrier, scale = canonicalize(carrier_raw)
        carrier_index = line_index(carrier)
        assert scale != 0
        assert carrier_raw == smul(scale, carrier)
        assert conjugate_vector(carrier) == carrier
        assert dot(carrier, p) == 0 and dot(carrier, q) == 0
        assert determinant(p, q, p) == 0 and determinant(p, q, q) == 0
        assert test_mask_bit(lines[carrier_index].words, number)
        for point in points:
            assert (dot(carrier, point) == 0) == (determinant(p, q, point) == 0)
        carriers.append(
            CarrierWitness(
                orbit_number=number,
                representative_rank=line_index(p),
                conjugate_rank=line_index(q),
                line_index=carrier_index,
                scale=scale,
            )
        )

    carrier_counts = Counter(witness.line_index for witness in carriers)
    assert len(carrier_counts) == 31
    assert set(carrier_counts.values()) == {10}
    assert all(lines[index].conjugate_index == index for index in carrier_counts)
    return Dataset(tuple(lines), tuple(carriers))


def semantic_payload(dataset: Dataset) -> dict[str, object]:
    return {
        "line_masks": [record.words for record in dataset.lines],
        "carrier_line_indices": [witness.line_index for witness in dataset.carriers],
        "carrier_scales": [witness.scale for witness in dataset.carriers],
    }


def data_sha256(dataset: Dataset) -> str:
    encoded = json.dumps(semantic_payload(dataset), sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def source_sha256() -> str:
    return hashlib.sha256(Path(__file__).read_bytes()).hexdigest()


def incidence_statistics(dataset: Dataset) -> dict[str, object]:
    histogram = Counter(record.incidence_count for record in dataset.lines)
    fixed = [record for record in dataset.lines if record.conjugate_index == record.index]
    nonfixed = [record for record in dataset.lines if record.conjugate_index != record.index]
    return {
        "total": sum(record.incidence_count for record in dataset.lines),
        "minimum": min(record.incidence_count for record in dataset.lines),
        "maximum": max(record.incidence_count for record in dataset.lines),
        "histogram": dict(sorted(histogram.items())),
        "fixed_line_count": len(fixed),
        "fixed_histogram": dict(sorted(Counter(r.incidence_count for r in fixed).items())),
        "nonfixed_line_count": len(nonfixed),
        "nonfixed_histogram": dict(sorted(Counter(r.incidence_count for r in nonfixed).items())),
    }


def prototype_record(dataset: Dataset) -> LineRecord:
    # The join of fixedPair = (.vertical, .infinity 0) is line 0 and is one of the
    # 28 old secants for row (5,58,169).
    record = dataset.lines[0]
    assert record.vector == (1, 0, 0)
    fixed_cross = raw_cross((0, 0, 1), (0, 1, 0))
    fixed_line, fixed_scale = canonicalize(fixed_cross)
    assert fixed_line == record.vector and fixed_scale == 4
    assert record.words == (0, 0, 0, 0, 17996806323437568)
    return record


def emit_summary(dataset: Dataset) -> None:
    statistics = incidence_statistics(dataset)
    prototype = prototype_record(dataset)
    carrier_histogram = Counter(witness.line_index for witness in dataset.carriers)
    print(
        f"lines={len(dataset.lines)} orbits={len(dataset.carriers)} words_per_mask={WORD_COUNT} "
        f"raw_mask_bytes={len(dataset.lines) * WORD_COUNT * 8}"
    )
    print(f"source_sha256={source_sha256()}")
    print(f"data_sha256={data_sha256(dataset)}")
    print(
        "bit_convention=word[n//64],bit(n%64),little-endian,indexed_by_Lean_orbitNumber;"
        "line_index=(1,y,z)->25*y+z,(0,1,z)->625+z,(0,0,1)->650"
    )
    print(
        f"incidences={statistics['total']} min={statistics['minimum']} max={statistics['maximum']} "
        f"histogram={statistics['histogram']}"
    )
    print(
        f"conjugation_fixed_lines={statistics['fixed_line_count']} "
        f"fixed_histogram={statistics['fixed_histogram']} "
        f"nonfixed_lines={statistics['nonfixed_line_count']} "
        f"nonfixed_histogram={statistics['nonfixed_histogram']}"
    )
    print(
        f"carrier_lines={len(carrier_histogram)} carrier_multiplicities="
        f"{dict(sorted(Counter(carrier_histogram.values()).items()))} all_fixed=true"
    )
    print(
        "lean_prototype="
        f"(0, #[{', '.join(map(str, prototype.words))}], "
        "(by decide : LineWitnessValid (.vertical) (.infinity 0) (.affine 0 0) "
        "(GF25.ofNat 4)))"
    )


def emit_json(dataset: Dataset) -> None:
    payload = {
        "field_convention": "F5[w]/(w^2-2), encoded a+5*b",
        "line_index_convention": "(1,y,z)->25*y+z; (0,1,z)->625+z; (0,0,1)->650",
        "bit_convention": "word[n//64], bit(n%64), little-endian, Lean orbitNumber n",
        "line_count": POINT_COUNT,
        "orbit_count": ORBIT_COUNT,
        "word_bits": WORD_BITS,
        "words_per_mask": WORD_COUNT,
        "raw_mask_bytes": POINT_COUNT * WORD_COUNT * 8,
        "source_sha256": source_sha256(),
        "data_sha256": data_sha256(dataset),
        "incidence_statistics": incidence_statistics(dataset),
        "lines": [
            {
                "index": record.index,
                "vector": record.vector,
                "words": record.words,
                "incidence_count": record.incidence_count,
                "spanning_point_ranks": record.spanning_point_ranks,
                "spanning_scale": record.spanning_scale,
                "conjugate_index": record.conjugate_index,
            }
            for record in dataset.lines
        ],
        "carriers": [witness.__dict__ for witness in dataset.carriers],
    }
    print(json.dumps(payload, indent=2))


def lean_array(values: Sequence[int]) -> str:
    return "#[" + ", ".join(map(str, values)) + "]"


def lean_line(vector: Vec) -> str:
    if vector[0] == 1:
        return f".affine (GF25.ofNat {vector[1]}) (GF25.ofNat {vector[2]})"
    if vector[1] == 1:
        return f".infinity (GF25.ofNat {vector[2]})"
    assert vector == (0, 0, 1)
    return ".vertical"


def emit_lean(dataset: Dataset) -> None:
    prototype = prototype_record(dataset)
    print("-- Generated by notes/2026-07-15-c151-line-mask-generator.py --format lean")
    print(f"-- source_sha256: {source_sha256()}")
    print(f"-- data_sha256: {data_sha256(dataset)}")
    print("-- line n is (1,n/25,n%25) below 625, (0,1,n-625) below 650, else (0,0,1).")
    print("-- mask word k contains orbitNumber bits 64*k through 64*k+63.")
    print("def c151LineMaskWords : Array (Array Nat) := #[")
    for record in dataset.lines:
        print(f"  {lean_array(record.words)},")
    print("]")
    print(
        "def c151CarrierLineIndices : Array Nat := "
        + lean_array([witness.line_index for witness in dataset.carriers])
    )
    print(
        "def c151CarrierScales : Array Nat := "
        + lean_array([witness.scale for witness in dataset.carriers])
    )
    print(
        "-- one-line prototype for the fixed-pair secant in row (5,58,169):\n-- "
        f"(0, {lean_array(prototype.words)}, "
        "(by decide : LineWitnessValid (.vertical) (.infinity 0) (.affine 0 0) "
        "(GF25.ofNat 4)))"
    )


def generated_header(dataset: Dataset, description: str) -> str:
    return (
        "/-!\n"
        "# Generated C151 Q25 finite-certificate data\n\n"
        "DO NOT EDIT: generated by `notes/2026-07-15-c151-line-mask-generator.py`.\n\n"
        f"* payload: {description}\n"
        f"* source SHA256: `{source_sha256()}`\n"
        f"* semantic data SHA256: `{data_sha256(dataset)}`\n"
        "-/\n"
    )


def render_line_module(dataset: Dataset, records: Sequence[LineRecord]) -> str:
    first, last = records[0].index, records[-1].index
    pieces = [
        "import RelativeConicArcs.Q25LineMaskChecker\n\n",
        generated_header(dataset, f"canonical dual lines {first} through {last}"),
        "\nnamespace RelativeConicArcs\n",
        "namespace Q25LineMaskData\n\n",
        "open Q25Coordinates Q25PairCertificate Q25MinimumMask Q25LineMaskChecker FiniteFields\n\n",
        "set_option maxHeartbeats 300000000\n",
        "set_option maxRecDepth 100000\n\n",
    ]
    for record in records:
        stem = f"line{record.index:03d}"
        pieces.extend(
            [
                f"def {stem} : Idx25 := {lean_line(record.vector)}\n\n",
                f"def {stem}Mask : OrbitMask := ![{', '.join(map(str, record.words))}]\n\n",
                f"theorem {stem}Mask_exact :\n",
                "    ∀ n : Fin 310,\n",
                f"      maskBit {stem}Mask n = true ↔\n",
                f"        lineDot (vec {stem}) (vec (orbitIdx (orbitCodeOfNumber n))) = 0 := by\n",
                "  decide\n\n",
                f"theorem {stem}Mask_certificate :\n",
                f"    LineMaskCertificate {stem} {stem}Mask :=\n",
                f"  ⟨{stem}Mask_exact⟩\n\n",
            ]
        )
    pieces.extend(
        [
            "end Q25LineMaskData\n",
            "end RelativeConicArcs\n",
        ]
    )
    return "".join(pieces)


def render_aggregate_module(dataset: Dataset, leaf_names: Sequence[str]) -> str:
    imports = "".join(
        f"import RelativeConicArcs.Q25LineMaskData.{name[:-5]}\n" for name in leaf_names
    )
    return imports + "\n" + generated_header(dataset, "aggregate import for all 651 lines")


def line_leaf_name(line_number: int) -> str:
    first = (line_number // LEAN_LINES_PER_MODULE) * LEAN_LINES_PER_MODULE
    last = min(first + LEAN_LINES_PER_MODULE - 1, POINT_COUNT - 1)
    return f"L_{first:03d}_{last:03d}"


def render_carrier_module(dataset: Dataset, witnesses: Sequence[CarrierWitness]) -> str:
    first, last = witnesses[0].orbit_number, witnesses[-1].orbit_number
    required_line_leaves = sorted({line_leaf_name(witness.line_index) for witness in witnesses})
    pieces = [
        "".join(
            f"import RelativeConicArcs.Q25LineMaskData.{leaf}\n"
            for leaf in required_line_leaves
        ),
        "\n",
        generated_header(dataset, f"carrier certificates for orbit numbers {first} through {last}"),
        "\nnamespace RelativeConicArcs\n",
        "namespace Q25CarrierLineData\n\n",
        "open Q25Coordinates Q25PairCertificate Q25LineMaskChecker Q25LineMaskData FiniteFields\n\n",
        "set_option maxHeartbeats 300000000\n",
        "set_option maxRecDepth 100000\n\n",
    ]
    for witness in witnesses:
        pieces.extend(
            [
                f"theorem carrier{witness.orbit_number:03d}_certificate :\n",
                "    CarrierLineCertificate\n",
                f"      (orbitCodeOfNumber ⟨{witness.orbit_number}, by decide⟩)\n",
                f"      line{witness.line_index:03d} (GF25.ofNat {witness.scale}) := by\n",
                "  refine ⟨by decide, by decide⟩\n\n",
            ]
        )
    pieces.extend(
        [
            "end Q25CarrierLineData\n",
            "end RelativeConicArcs\n",
        ]
    )
    return "".join(pieces)


def render_carrier_aggregate_module(dataset: Dataset, leaf_names: Sequence[str]) -> str:
    del leaf_names
    return "import RelativeConicArcs.Q25CarrierLineData.Dispatch\n\n" + generated_header(
        dataset, "aggregate import for all 310 conjugate-pair carrier certificates"
    )


def render_dispatch_module(dataset: Dataset, carrier_leaf_names: Sequence[str]) -> str:
    pieces = [
        "import RelativeConicArcs.Q25LineMaskData.All\n",
        "".join(
            f"import RelativeConicArcs.Q25CarrierLineData.{name[:-5]}\n"
            for name in carrier_leaf_names
        ),
        "\n",
        generated_header(dataset, "total line-mask and carrier-certificate dispatchers"),
        "\nnamespace RelativeConicArcs\n",
        "namespace Q25CarrierLineData\n\n",
        "open Q25Coordinates Q25PairCertificate Q25MinimumMask Q25LineMaskChecker\n",
        "open Q25LineMaskData FiniteFields\n\n",
        "set_option maxHeartbeats 300000000\n",
        "set_option maxRecDepth 100000\n\n",
        "def lineOfNumber : Fin 651 → Idx25 := ![\n",
    ]
    for position, record in enumerate(dataset.lines):
        comma = "," if position + 1 < len(dataset.lines) else ""
        pieces.append(f"  line{record.index:03d}{comma}\n")
    pieces.extend(["]\n\n", "def lineMaskOfNumber : Fin 651 → OrbitMask := ![\n"])
    for position, record in enumerate(dataset.lines):
        comma = "," if position + 1 < len(dataset.lines) else ""
        pieces.append(f"  line{record.index:03d}Mask{comma}\n")
    pieces.extend(
        [
            "]\n\n",
            "theorem lineMaskCertificateOfNumber (n : Fin 651) :\n",
            "    LineMaskCertificate (lineOfNumber n) (lineMaskOfNumber n) := by\n",
            "  fin_cases n\n",
        ]
    )
    for record in dataset.lines:
        pieces.append(f"  · exact line{record.index:03d}Mask_certificate\n")

    pieces.extend(["\n", "def carrierLineNumber : Fin 310 → Fin 651 := ![\n"])
    for position, witness in enumerate(dataset.carriers):
        comma = "," if position + 1 < len(dataset.carriers) else ""
        pieces.append(f"  ⟨{witness.line_index}, by decide⟩{comma}\n")
    pieces.extend(["]\n\n", "def carrierScale : Fin 310 → K25 := ![\n"])
    for position, witness in enumerate(dataset.carriers):
        comma = "," if position + 1 < len(dataset.carriers) else ""
        pieces.append(f"  GF25.ofNat {witness.scale}{comma}\n")
    pieces.extend(
        [
            "]\n\n",
            "theorem carrierLineCertificateOfNumber (n : Fin 310) :\n",
            "    CarrierLineCertificate (orbitCodeOfNumber n)\n",
            "      (lineOfNumber (carrierLineNumber n)) (carrierScale n) := by\n",
            "  fin_cases n\n",
        ]
    )
    for witness in dataset.carriers:
        pieces.append(f"  · exact carrier{witness.orbit_number:03d}_certificate\n")
    pieces.extend(
        [
            "\nend Q25CarrierLineData\n",
            "end RelativeConicArcs\n",
        ]
    )
    return "".join(pieces)


def generated_tree_sha256(files: Sequence[Path], output_directory: Path) -> str:
    digest = hashlib.sha256()
    for path in sorted(files):
        relative = path.relative_to(output_directory).as_posix().encode()
        contents = path.read_bytes()
        digest.update(len(relative).to_bytes(4, "big"))
        digest.update(relative)
        digest.update(len(contents).to_bytes(8, "big"))
        digest.update(contents)
    return digest.hexdigest()


def write_lean_modules(dataset: Dataset, output_directory: Path) -> None:
    if output_directory.name != "Q25LineMaskData":
        raise ValueError("--write-lean-modules must name a Q25LineMaskData directory")
    output_directory.mkdir(parents=True, exist_ok=True)

    chunks = tuple(
        dataset.lines[start : start + LEAN_LINES_PER_MODULE]
        for start in range(0, len(dataset.lines), LEAN_LINES_PER_MODULE)
    )
    leaf_names = tuple(
        f"L_{chunk[0].index:03d}_{chunk[-1].index:03d}.lean" for chunk in chunks
    )
    expected_names = set(leaf_names) | {"All.lean"}
    unexpected = sorted(path.name for path in output_directory.glob("*.lean") if path.name not in expected_names)
    if unexpected:
        raise RuntimeError(f"refusing to overwrite directory with unexpected Lean files: {unexpected}")

    written: list[Path] = []
    for name, chunk in zip(leaf_names, chunks, strict=True):
        path = output_directory / name
        path.write_text(render_line_module(dataset, chunk), encoding="utf-8")
        written.append(path)
    aggregate = output_directory / "All.lean"
    aggregate.write_text(render_aggregate_module(dataset, leaf_names), encoding="utf-8")
    written.append(aggregate)

    total_bytes = sum(path.stat().st_size for path in written)
    print(
        f"generated_files={len(written)} leaf_modules={len(leaf_names)} "
        f"lines={len(dataset.lines)} lines_per_full_module={LEAN_LINES_PER_MODULE}"
    )
    print(f"output_directory={output_directory.resolve()}")
    print(f"generated_source_bytes={total_bytes}")
    print(f"source_sha256={source_sha256()}")
    print(f"data_sha256={data_sha256(dataset)}")
    print(f"generated_tree_sha256={generated_tree_sha256(written, output_directory)}")


def write_carrier_lean_modules(dataset: Dataset, output_directory: Path) -> None:
    if output_directory.name != "Q25CarrierLineData":
        raise ValueError("--write-carrier-lean-modules must name a Q25CarrierLineData directory")
    output_directory.mkdir(parents=True, exist_ok=True)

    chunks = tuple(
        dataset.carriers[start : start + LEAN_LINES_PER_MODULE]
        for start in range(0, len(dataset.carriers), LEAN_LINES_PER_MODULE)
    )
    leaf_names = tuple(
        f"C_{chunk[0].orbit_number:03d}_{chunk[-1].orbit_number:03d}.lean"
        for chunk in chunks
    )
    expected_names = set(leaf_names) | {"All.lean", "Dispatch.lean"}
    unexpected = sorted(
        path.name for path in output_directory.glob("*.lean") if path.name not in expected_names
    )
    if unexpected:
        raise RuntimeError(f"refusing to overwrite directory with unexpected Lean files: {unexpected}")

    written: list[Path] = []
    for name, chunk in zip(leaf_names, chunks, strict=True):
        path = output_directory / name
        path.write_text(render_carrier_module(dataset, chunk), encoding="utf-8")
        written.append(path)
    dispatch = output_directory / "Dispatch.lean"
    dispatch.write_text(render_dispatch_module(dataset, leaf_names), encoding="utf-8")
    written.append(dispatch)
    aggregate = output_directory / "All.lean"
    aggregate.write_text(render_carrier_aggregate_module(dataset, leaf_names), encoding="utf-8")
    written.append(aggregate)

    total_bytes = sum(path.stat().st_size for path in written)
    print(
        f"generated_files={len(written)} leaf_modules={len(leaf_names)} dispatch_modules=1 "
        f"carriers={len(dataset.carriers)} carriers_per_module={LEAN_LINES_PER_MODULE}"
    )
    print(f"output_directory={output_directory.resolve()}")
    print(f"generated_source_bytes={total_bytes}")
    print(f"source_sha256={source_sha256()}")
    print(f"data_sha256={data_sha256(dataset)}")
    print(f"generated_tree_sha256={generated_tree_sha256(written, output_directory)}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--format",
        choices=("summary", "json", "lean"),
        default="summary",
        help="output format; every format runs the same exhaustive self-checks",
    )
    parser.add_argument(
        "--write-lean-modules",
        type=Path,
        metavar="Q25LineMaskData_DIR",
        help="deterministically write 10-line certificate modules and All.lean",
    )
    parser.add_argument(
        "--write-carrier-lean-modules",
        type=Path,
        metavar="Q25CarrierLineData_DIR",
        help="deterministically write 10-candidate carrier modules and All.lean",
    )
    args = parser.parse_args()
    if args.write_lean_modules is not None and args.write_carrier_lean_modules is not None:
        parser.error("choose only one generated Lean output tree")
    dataset = build_dataset()
    if args.write_carrier_lean_modules is not None:
        write_carrier_lean_modules(dataset, args.write_carrier_lean_modules)
    elif args.write_lean_modules is not None:
        write_lean_modules(dataset, args.write_lean_modules)
    elif args.format == "summary":
        emit_summary(dataset)
    elif args.format == "json":
        emit_json(dataset)
    else:
        emit_lean(dataset)


if __name__ == "__main__":
    main()
