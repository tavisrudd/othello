#!/usr/bin/env python3
"""Generate shared-line composition data for all 1,189 canonical C151 rows.

This is proposal data, not a trusted proof.  It reuses the independently checked
651-line indexing and exact point-on-line masks from
``2026-07-15-c151-line-mask-generator.py``.  For each residual representative it
stores the 28 old secants with their raw-cross scales, freshness/carrier/legal
orbit masks, and the exact legal count.  A separate direct ``LegalPair`` replay
checks every one of the 1,189 * 310 Boolean decisions.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from dataclasses import dataclass
from itertools import combinations, product
from pathlib import Path
from typing import Iterable, Sequence

HERE = Path(__file__).resolve().parent
LINE_GENERATOR = HERE / "2026-07-15-c151-line-mask-generator.py"


def load_line_generator():
    spec = importlib.util.spec_from_file_location("c151_line_mask_generator", LINE_GENERATOR)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


linegen = load_line_generator()

Vec = tuple[int, int, int]
Mask = tuple[int, int, int, int, int]

ORBIT_COUNT = 310
POINT_COUNT = 651
WORD_COUNT = 5
WORD_BITS = 64
EXPECTED_VALID_ROWS = 7044
EXPECTED_CANONICAL_ROWS = 1189
PROTOTYPE_ROW = (5, 58, 169)
LEAN_ROWS_PER_MODULE = 5


@dataclass(frozen=True)
class SecantWitness:
    first_point: int
    second_point: int
    line_index: int
    scale: int


@dataclass(frozen=True)
class RowRecord:
    row: tuple[int, int, int]
    secants: tuple[SecantWitness, ...]
    freshness: Mask
    carrier: Mask
    legal: Mask
    legal_count: int
    secant_obstruction_count: int


def pack_bits(indices: Iterable[int]) -> Mask:
    words = [0] * WORD_COUNT
    for index in indices:
        assert 0 <= index < ORBIT_COUNT
        words[index // WORD_BITS] |= 1 << (index % WORD_BITS)
    assert words[-1] >> (ORBIT_COUNT % WORD_BITS) == 0
    return tuple(words)  # type: ignore[return-value]


def mask_bit(mask: Sequence[int], index: int) -> bool:
    return bool((mask[index // WORD_BITS] >> (index % WORD_BITS)) & 1)


def mask_count(mask: Sequence[int]) -> int:
    return sum(word.bit_count() for word in mask)


def mask_or(masks: Iterable[Sequence[int]]) -> Mask:
    words = [0] * WORD_COUNT
    for mask in masks:
        for i, word in enumerate(mask):
            words[i] |= word
    return tuple(words)  # type: ignore[return-value]


def field_scale(parameter: int) -> int:
    imaginary = parameter // 5
    assert imaginary != 0
    return linegen.power(imaginary, 23)


def field_shift(parameter: int) -> int:
    return linegen.neg(linegen.mul(field_scale(parameter), parameter % 5))


def residual_apply(y: int, z: int, point: Vec) -> Vec:
    if point[0] == 1:
        return (
            1,
            linegen.add(field_shift(y), linegen.mul(field_scale(y), point[1])),
            linegen.add(field_shift(z), linegen.mul(field_scale(z), point[2])),
        )
    if point[1] == 1:
        coefficient = linegen.mul(linegen.power(field_scale(y), 23), field_scale(z))
        return (0, 1, linegen.mul(coefficient, point[2]))
    assert point == (0, 0, 1)
    return point


def internal_orbit_indices(points: Sequence[Vec]) -> tuple[int, ...]:
    """Map Lean orbitNumber to the C150 internal orbit order used for canonicals."""

    ordered: list[Vec] = []
    seen: set[int] = set()
    for raw in product(range(25), repeat=3):
        if raw == (0, 0, 0):
            continue
        canonical, _ = linegen.canonicalize(raw)
        rank = linegen.line_index(canonical)
        if rank not in seen:
            seen.add(rank)
            ordered.append(canonical)
    assert len(ordered) == POINT_COUNT
    position = {linegen.line_index(point): i for i, point in enumerate(ordered)}
    internal: list[tuple[Vec, Vec]] = []
    for i, point in enumerate(ordered):
        conjugate = linegen.conjugate_vector(point)
        if i < position[linegen.line_index(conjugate)]:
            internal.append((point, conjugate))
    assert len(internal) == ORBIT_COUNT
    by_lean = [-1] * ORBIT_COUNT
    for index, (p, q) in enumerate(internal):
        number = linegen.lean_orbit_number(p, q)
        assert by_lean[number] == -1
        by_lean[number] = index
    assert set(by_lean) == set(range(ORBIT_COUNT))
    assert by_lean[5] == 65
    return tuple(by_lean)


def enumerate_canonical_rows(
    points: Sequence[Vec], representatives: Sequence[Vec]
) -> tuple[tuple[int, int, int], ...]:
    point_rank = {point: linegen.line_index(point) for point in points}
    orbit_of_point: dict[Vec, int] = {}
    for number, p in enumerate(representatives):
        orbit_of_point[p] = number
        orbit_of_point[linegen.conjugate_vector(p)] = number

    parameters = tuple((y, z) for y in range(5, 25) for z in range(5, 25))
    assert len(parameters) == 400
    action: list[tuple[int, ...]] = []
    for y, z in parameters:
        image = tuple(orbit_of_point[residual_apply(y, z, p)] for p in representatives)
        assert len(set(image)) == ORBIT_COUNT
        action.append(image)
    assert action[0] == tuple(range(ORBIT_COUNT))

    internal = internal_orbit_indices(points)
    fixed_a = (0, 0, 1)
    fixed_b = (0, 1, 0)

    def old_points(row: tuple[int, int, int]) -> tuple[Vec, ...]:
        result: list[Vec] = [fixed_a, fixed_b]
        for number in row:
            p = representatives[number]
            result.extend((p, linegen.conjugate_vector(p)))
        return tuple(result)

    def is_arc(row: tuple[int, int, int]) -> bool:
        return all(
            linegen.determinant(a, b, c) != 0
            for a, b, c in combinations(old_points(row), 3)
        )

    canonical_rows: dict[tuple[int, int, int], tuple[int, int, int]] = {}
    valid_rows = 0
    for b in range(6, 309):
        for c in range(b + 1, 310):
            source = (5, b, c)
            if not is_arc(source):
                continue
            valid_rows += 1
            best_internal = (ORBIT_COUNT, ORBIT_COUNT, ORBIT_COUNT)
            best_lean = (-1, -1, -1)
            for image in action:
                lean = tuple(sorted((image[5], image[b], image[c])))
                internal_triple = tuple(sorted(internal[n] for n in lean))
                if internal_triple < best_internal:
                    best_internal = internal_triple
                    best_lean = lean
            assert best_lean[0] == 5
            previous = canonical_rows.setdefault(best_internal, best_lean)
            assert previous == best_lean
    assert valid_rows == EXPECTED_VALID_ROWS
    assert len(canonical_rows) == EXPECTED_CANONICAL_ROWS
    assert all(row[0] == 5 for row in canonical_rows.values())
    del point_rank  # documents that canonicalization is by C150 orbit order, not point rank
    return tuple(lean for _, lean in sorted(canonical_rows.items()))


def direct_raw_extension(old: Sequence[Vec], candidate: Vec) -> bool:
    return all(linegen.determinant(a, b, candidate) != 0 for a, b in combinations(old, 2))


def direct_legal_pair(old: Sequence[Vec], p: Vec, q: Vec) -> bool:
    old_set = set(old)
    return (
        p not in old_set
        and direct_raw_extension(old, p)
        and q not in old_set | {p}
        and direct_raw_extension(tuple(old) + (p,), q)
    )


def build_rows(dataset) -> tuple[tuple[RowRecord, ...], tuple[tuple[int, int], ...]]:
    points = linegen.canonical_vectors()
    representatives = linegen.enumerate_orbit_representatives(points)
    rows = enumerate_canonical_rows(points, representatives)
    carriers = tuple((w.line_index, w.scale) for w in dataset.carriers)
    assert len(carriers) == ORBIT_COUNT

    records: list[RowRecord] = []
    decisions = 0
    for row in rows:
        old: list[Vec] = [(0, 0, 1), (0, 1, 0)]
        for number in row:
            p = representatives[number]
            old.extend((p, linegen.conjugate_vector(p)))
        assert len(old) == 8 and len(set(old)) == 8
        assert all(
            linegen.determinant(a, b, c) != 0 for a, b, c in combinations(old, 3)
        )

        secants: list[SecantWitness] = []
        for (i, a), (j, b) in combinations(enumerate(old), 2):
            raw = linegen.raw_cross(a, b)
            canonical, scale = linegen.canonicalize(raw)
            index = linegen.line_index(canonical)
            assert raw == linegen.smul(scale, dataset.lines[index].vector)
            assert scale != 0
            secants.append(SecantWitness(i, j, index, scale))
        assert len(secants) == 28
        assert len({w.line_index for w in secants}) == 28

        freshness = pack_bits(row)
        secant_mask = mask_or(dataset.lines[w.line_index].words for w in secants)
        carrier_obstructions: list[int] = []
        legal_numbers: list[int] = []
        for number, p in enumerate(representatives):
            q = linegen.conjugate_vector(p)
            carrier_index, carrier_scale = carriers[number]
            carrier_line = dataset.lines[carrier_index].vector
            assert linegen.raw_cross(p, q) == linegen.smul(carrier_scale, carrier_line)
            carrier_blocked = any(linegen.dot(carrier_line, point) == 0 for point in old)
            if carrier_blocked:
                carrier_obstructions.append(number)
            composed = not (
                mask_bit(freshness, number)
                or mask_bit(secant_mask, number)
                or carrier_blocked
            )
            direct = direct_legal_pair(old, p, q)
            assert composed == direct
            decisions += 1
            if composed:
                legal_numbers.append(number)
        carrier = pack_bits(carrier_obstructions)
        legal = pack_bits(legal_numbers)
        records.append(
            RowRecord(
                row=row,
                secants=tuple(secants),
                freshness=freshness,
                carrier=carrier,
                legal=legal,
                legal_count=len(legal_numbers),
                secant_obstruction_count=mask_count(secant_mask),
            )
        )
    assert decisions == EXPECTED_CANONICAL_ROWS * ORBIT_COUNT
    return tuple(records), carriers


def compact_bytes(
    dataset, rows: Sequence[RowRecord], carriers: Sequence[tuple[int, int]]
) -> bytes:
    result = bytearray()
    result.extend(b"C151SL01")
    result.extend(linegen.data_sha256(dataset).encode("ascii"))
    for line_index, scale in carriers:
        result.extend(line_index.to_bytes(2, "little"))
        result.append(scale)
    for record in rows:
        result.extend(record.row[1].to_bytes(2, "little"))
        result.extend(record.row[2].to_bytes(2, "little"))
        for witness in record.secants:
            result.extend(witness.line_index.to_bytes(2, "little"))
            result.append(witness.scale)
        for mask in (record.freshness, record.carrier, record.legal):
            for word in mask:
                result.extend(word.to_bytes(8, "little"))
        result.append(record.legal_count)
    return bytes(result)


def semantic_payload(dataset, rows: Sequence[RowRecord], carriers: Sequence[tuple[int, int]]):
    return {
        "upstream_line_data_sha256": linegen.data_sha256(dataset),
        "carrier_line_index_scale": carriers,
        "rows": [
            {
                "row": record.row,
                "secants": [
                    (w.first_point, w.second_point, w.line_index, w.scale)
                    for w in record.secants
                ],
                "freshness_words": record.freshness,
                "carrier_obstruction_words": record.carrier,
                "legal_words": record.legal,
                "legal_count": record.legal_count,
            }
            for record in rows
        ],
    }


def source_sha256() -> str:
    return hashlib.sha256(Path(__file__).read_bytes()).hexdigest()


def emit_summary(dataset, rows: Sequence[RowRecord], carriers: Sequence[tuple[int, int]]) -> None:
    compact = compact_bytes(dataset, rows, carriers)
    line_frequency = Counter(w.line_index for record in rows for w in record.secants)
    scale_frequency = Counter(w.scale for record in rows for w in record.secants)
    carrier_scale_frequency = Counter(scale for _, scale in carriers)
    print(
        f"canonical_rows={len(rows)} candidates_per_row={ORBIT_COUNT} "
        f"direct_comparisons={len(rows) * ORBIT_COUNT}"
    )
    print(f"source_sha256={source_sha256()}")
    print(f"upstream_line_data_sha256={linegen.data_sha256(dataset)}")
    print(f"compact_bytes={len(compact)} compact_sha256={hashlib.sha256(compact).hexdigest()}")
    print(
        "compact_components="
        f"header={8 + 64},global_carriers={ORBIT_COUNT * 3},"
        f"row_ids={len(rows) * 4},row_secants={len(rows) * 28 * 3},"
        f"row_masks={len(rows) * 3 * WORD_COUNT * 8},row_counts={len(rows)}"
    )
    print(
        f"legal_count_histogram={dict(sorted(Counter(r.legal_count for r in rows).items()))}"
    )
    print(
        "freshness_count_histogram="
        f"{dict(sorted(Counter(mask_count(r.freshness) for r in rows).items()))}"
    )
    print(
        "carrier_obstruction_histogram="
        f"{dict(sorted(Counter(mask_count(r.carrier) for r in rows).items()))}"
    )
    print(
        "secant_obstruction_histogram="
        f"{dict(sorted(Counter(r.secant_obstruction_count for r in rows).items()))}"
    )
    print(
        f"secant_line_occurrences={sum(line_frequency.values())} unique_lines={len(line_frequency)} "
        f"reuse_min={min(line_frequency.values())} reuse_max={max(line_frequency.values())}"
    )
    print(f"secant_scale_histogram={dict(sorted(scale_frequency.items()))}")
    print(f"carrier_scale_histogram={dict(sorted(carrier_scale_frequency.items()))}")


def emit_json(dataset, rows: Sequence[RowRecord], carriers: Sequence[tuple[int, int]]) -> None:
    payload = semantic_payload(dataset, rows, carriers)
    compact = compact_bytes(dataset, rows, carriers)
    payload["source_sha256"] = source_sha256()
    payload["compact_bytes"] = len(compact)
    payload["compact_sha256"] = hashlib.sha256(compact).hexdigest()
    print(json.dumps(payload, separators=(",", ":")))


def lean_mask(mask: Sequence[int]) -> str:
    return "![" + ", ".join(map(str, mask)) + "]"


def emit_lean_prototype(
    dataset, rows: Sequence[RowRecord], carriers: Sequence[tuple[int, int]]
) -> None:
    record = next(row for row in rows if row.row == PROTOTYPE_ROW)
    compact = compact_bytes(dataset, rows, carriers)
    print("-- C151 shared-line prototype; proposal data, independently checked by Lean later.")
    print(f"-- source_sha256: {source_sha256()}")
    print(f"-- compact_sha256: {hashlib.sha256(compact).hexdigest()}")
    print("-- secant entries are (configPoint i, configPoint j, canonical line index, raw-cross scale).")
    print("def c151PrototypeSecants : Array (Nat × Nat × Nat × Nat) := #[")
    for witness in record.secants:
        print(
            f"  ({witness.first_point}, {witness.second_point}, "
            f"{witness.line_index}, {witness.scale}),"
        )
    print("]")
    print(f"def c151PrototypeFreshness : OrbitMask := {lean_mask(record.freshness)}")
    print(f"def c151PrototypeCarrierObstruction : OrbitMask := {lean_mask(record.carrier)}")
    print(f"def c151PrototypeLegal : OrbitMask := {lean_mask(record.legal)}")
    print(f"theorem c151PrototypeLegalCount : (maskOrbitSet c151PrototypeLegal).card = "
          f"{record.legal_count} := by decide")
    print("def c151CandidateCarrierLineIndexScale : Array (Nat × Nat) := #[")
    for line_index, scale in carriers:
        print(f"  ({line_index}, {scale}),")
    print("]")


def lean_line_table(record: RowRecord) -> tuple[tuple[int, ...], ...]:
    table = [[0] * 8 for _ in range(8)]
    for witness in record.secants:
        table[witness.first_point][witness.second_point] = witness.line_index
        table[witness.second_point][witness.first_point] = witness.line_index
    return tuple(tuple(row) for row in table)


def lean_scale_table(record: RowRecord) -> tuple[tuple[int, ...], ...]:
    table = [[1] * 8 for _ in range(8)]
    for witness in record.secants:
        table[witness.first_point][witness.second_point] = witness.scale
        table[witness.second_point][witness.first_point] = linegen.neg(witness.scale)
    assert all(table[i][i] == 1 for i in range(8))
    return tuple(tuple(row) for row in table)


def generated_header(
    dataset, compact_hash: str, description: str
) -> str:
    return (
        "/-!\n"
        "# Generated C151 canonical row-composition certificates\n\n"
        "DO NOT EDIT: generated by "
        "`notes/2026-07-15-c151-shared-line-composition.py`.\n\n"
        f"* payload: {description}\n"
        f"* generator SHA256: `{source_sha256()}`\n"
        f"* compact payload SHA256: `{compact_hash}`\n"
        f"* shared line-data SHA256: `{linegen.data_sha256(dataset)}`\n"
        "* class order: lexicographic C150 internal-orbit canonical triples\n"
        "-/\n"
    )


def render_row(record: RowRecord, class_index: int) -> str:
    stem = f"class{class_index:04d}"
    _, b, c = record.row
    line_rows = ",\n".join(
        "  ![" + ", ".join(map(str, row)) + "]" for row in lean_line_table(record)
    )
    scale_rows = ",\n".join(
        "  ![" + ", ".join(f"GF25.ofNat {value}" for value in row) + "]"
        for row in lean_scale_table(record)
    )
    return (
        f"def {stem}A : OrbitCode := orbitCodeOfNumber ⟨5, by decide⟩\n"
        f"def {stem}B : OrbitCode := orbitCodeOfNumber ⟨{b}, by decide⟩\n"
        f"def {stem}C : OrbitCode := orbitCodeOfNumber ⟨{c}, by decide⟩\n\n"
        f"def {stem}Allowed : OrbitMask :=\n"
        f"  ![{', '.join(map(str, record.legal))}]\n\n"
        f"def {stem}LineNumber : Fin 8 → Fin 8 → Fin 651 := ![\n"
        f"{line_rows}\n]\n\n"
        f"def {stem}Scale : Fin 8 → Fin 8 → K25 := ![\n"
        f"{scale_rows}\n]\n\n"
        f"def {stem}SecantCertificate :\n"
        f"    SecantCompositionCertificate {stem}A {stem}B {stem}C {stem}Allowed where\n"
        f"  lineNumber := {stem}LineNumber\n"
        f"  scale := {stem}Scale\n"
        "  witness := by decide\n"
        "  symmetric := by decide\n"
        "  avoids := by decide\n\n"
        f"theorem {stem}FreshMaskSafe :\n"
        f"    FreshMaskSafe {stem}A {stem}B {stem}C {stem}Allowed := by\n"
        "  decide\n\n"
        f"theorem {stem}CarrierMaskSafe :\n"
        f"    CarrierMaskSafe {stem}A {stem}B {stem}C {stem}Allowed := by\n"
        "  decide\n\n"
        f"def {stem}RowCertificate :\n"
        f"    RowCompositionCertificate {stem}A {stem}B {stem}C {stem}Allowed where\n"
        "  card_le := by decide\n"
        f"  fresh := {stem}FreshMaskSafe\n"
        f"  secants := {stem}SecantCertificate\n"
        f"  carrier := {stem}CarrierMaskSafe\n\n"
        f"theorem {stem}ReflectedMaskCertificate :\n"
        f"    ReflectedMaskCertificate (normalizedConfig {stem}A {stem}B {stem}C) "
        f"{stem}Allowed :=\n"
        f"  {stem}RowCertificate.toReflectedMaskCertificate\n\n"
        f"theorem {stem}LegalOrbitSet_card_ge_32 :\n"
        f"    32 ≤ (legalOrbitSet (normalizedConfig {stem}A {stem}B {stem}C)).card :=\n"
        "  card_legalOrbitSet_ge_32\n"
        f"    (normalizedConfig_isConjInvariant {stem}A {stem}B {stem}C)\n"
        f"    {stem}ReflectedMaskCertificate\n\n"
    )


def render_leaf(
    dataset, compact_hash: str, indexed_rows: Sequence[tuple[int, RowRecord]]
) -> str:
    first, last = indexed_rows[0][0], indexed_rows[-1][0]
    pieces = [
        "import RelativeConicArcs.Q25LineMaskComposition\n\n",
        generated_header(dataset, compact_hash, f"residual classes {first} through {last}"),
        "\nnamespace RelativeConicArcs\n",
        "namespace Q25RowCompositionData\n\n",
        "open Q25Coordinates Q25PairCertificate Q25MinimumMask Q25LineMaskComposition\n",
        "open FiniteFields\n\n",
        "set_option maxHeartbeats 300000000\n",
        "set_option maxRecDepth 100000\n\n",
    ]
    pieces.extend(render_row(record, index) for index, record in indexed_rows)
    pieces.extend(
        ["end Q25RowCompositionData\n", "end RelativeConicArcs\n"]
    )
    return "".join(pieces)


def render_all(dataset, compact_hash: str, leaf_names: Sequence[str]) -> str:
    imports = "".join(
        f"import RelativeConicArcs.Q25RowCompositionData.{name[:-5]}\n"
        for name in leaf_names
    )
    return imports + "\n" + generated_header(
        dataset, compact_hash, "aggregate import for all 1,189 residual classes"
    )


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


def write_lean_modules(
    dataset, rows: Sequence[RowRecord], carriers: Sequence[tuple[int, int]],
    output_directory: Path,
) -> None:
    if output_directory.name != "Q25RowCompositionData":
        raise ValueError("--write-lean-modules must name a Q25RowCompositionData directory")
    compact_hash = hashlib.sha256(compact_bytes(dataset, rows, carriers)).hexdigest()
    indexed = tuple(enumerate(rows))
    chunks = tuple(
        indexed[start : start + LEAN_ROWS_PER_MODULE]
        for start in range(0, len(indexed), LEAN_ROWS_PER_MODULE)
    )
    leaf_names = tuple(
        f"C_{chunk[0][0]:04d}_{chunk[-1][0]:04d}.lean" for chunk in chunks
    )
    expected_names = set(leaf_names) | {"All.lean"}
    output_directory.mkdir(parents=True, exist_ok=True)
    unexpected = sorted(
        path.name for path in output_directory.iterdir() if path.name not in expected_names
    )
    if unexpected:
        raise RuntimeError(f"refusing generated directory with unexpected entries: {unexpected}")

    written: list[Path] = []
    for name, chunk in zip(leaf_names, chunks, strict=True):
        path = output_directory / name
        path.write_text(render_leaf(dataset, compact_hash, chunk), encoding="utf-8")
        written.append(path)
    aggregate = output_directory / "All.lean"
    aggregate.write_text(render_all(dataset, compact_hash, leaf_names), encoding="utf-8")
    written.append(aggregate)

    assert len(leaf_names) == 238 and len(written) == 239
    total_bytes = sum(path.stat().st_size for path in written)
    print(
        f"generated_files={len(written)} leaf_modules={len(leaf_names)} "
        f"rows={len(rows)} rows_per_full_module={LEAN_ROWS_PER_MODULE}"
    )
    print(f"output_directory={output_directory.resolve()}")
    print(f"generated_source_bytes={total_bytes}")
    print(f"source_sha256={source_sha256()}")
    print(f"compact_sha256={compact_hash}")
    print(f"generated_tree_sha256={generated_tree_sha256(written, output_directory)}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--format", choices=("summary", "json", "lean-prototype"), default="summary"
    )
    parser.add_argument(
        "--write-lean-modules",
        type=Path,
        metavar="Q25RowCompositionData_DIR",
        help="write deterministic five-row certificate leaves and All.lean",
    )
    args = parser.parse_args()
    dataset = linegen.build_dataset()
    rows, carriers = build_rows(dataset)
    if args.write_lean_modules is not None:
        write_lean_modules(dataset, rows, carriers, args.write_lean_modules)
    elif args.format == "summary":
        emit_summary(dataset, rows, carriers)
    elif args.format == "json":
        emit_json(dataset, rows, carriers)
    else:
        emit_lean_prototype(dataset, rows, carriers)


if __name__ == "__main__":
    main()
