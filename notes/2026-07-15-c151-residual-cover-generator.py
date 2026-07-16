#!/usr/bin/env python3
"""Validate the C151 residual-cover CSV and emit bounded Lean payload modules.

The C++ enumerator independently checks the geometry and writes one record for each of the
46,056 normalized rows containing orbit 5.  This script deliberately emits *payload only*:
the handwritten Lean bridge from a valid transporter record to
``card_legalOrbitSet_residual`` does not yet exist.  Bad records retain their explicit ordered
``BadWitnessValid`` triple, while valid records retain the residual parameter, canonical class,
and class metadata needed by that bridge.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence

EXPECTED_ROWS = 46_056
EXPECTED_BAD_ROWS = 39_012
EXPECTED_VALID_ROWS = 7_044
EXPECTED_CLASSES = 1_189
EXPECTED_CSV_SHA256 = "62aa26c98deb98cb786fa1b21957b91ec16b1e2bd2a6319129c31449eb0effe3"
EXPECTED_ENUMERATOR_SHA256 = "73d442df3be986c1082af8e3498ddd0496c09b86dd24963ea6d887a8f9b7680d"
EXPECTED_FNV1A64 = 0x37B674BFE4316EE6
MINIMUM_CLASS_IDS = (65, 267, 445, 772, 1002)
CLASS_BOUND_CHUNK = 10
ROW_PAYLOAD_CHUNK = 50
CLASS_PAYLOAD_CHUNK = 10
EXPECTED_COLUMNS = (
    "b",
    "c",
    "tag",
    "bad_i",
    "bad_j",
    "bad_k",
    "class_index",
    "canonical_b",
    "canonical_c",
    "y",
    "z",
    "legal",
    "orbit_size",
)


@dataclass(frozen=True)
class Record:
    b: int
    c: int
    valid: bool
    bad: tuple[int, int, int]
    class_index: int
    canonical_b: int
    canonical_c: int
    y: int
    z: int
    legal: int
    orbit_size: int


@dataclass(frozen=True)
class ClassRecord:
    index: int
    canonical_b: int
    canonical_c: int
    legal: int
    orbit_size: int


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_sha256() -> str:
    return sha256(Path(__file__))


def fnv_feed(value: int, state: int) -> int:
    value &= 0xFFFFFFFF
    for byte in range(4):
        state ^= (value >> (8 * byte)) & 0xFF
        state = (state * 1_099_511_628_211) & 0xFFFFFFFFFFFFFFFF
    return state


def data_fnv1a64(records: Sequence[Record]) -> int:
    state = 14_695_981_039_346_656_037
    for record in records:
        values = (
            record.b,
            record.c,
            int(record.valid),
            *record.bad,
            record.class_index,
            5 if record.valid else -1,
            record.canonical_b,
            record.canonical_c,
            record.y,
            record.z,
            record.legal,
            record.orbit_size,
        )
        for value in values:
            state = fnv_feed(value, state)
    return state


def read_records(csv_path: Path) -> tuple[tuple[Record, ...], tuple[ClassRecord, ...]]:
    csv_hash = sha256(csv_path)
    if csv_hash != EXPECTED_CSV_SHA256:
        raise ValueError(f"unexpected residual-cover CSV SHA256: {csv_hash}")

    records: list[Record] = []
    with csv_path.open(newline="", encoding="utf-8") as stream:
        reader = csv.DictReader(stream)
        if tuple(reader.fieldnames or ()) != EXPECTED_COLUMNS:
            raise ValueError(f"unexpected CSV columns: {reader.fieldnames}")
        for row in reader:
            tag = row["tag"]
            if tag not in ("B", "V"):
                raise ValueError(f"unexpected row tag: {tag}")
            records.append(
                Record(
                    b=int(row["b"]),
                    c=int(row["c"]),
                    valid=tag == "V",
                    bad=(int(row["bad_i"]), int(row["bad_j"]), int(row["bad_k"])),
                    class_index=int(row["class_index"]),
                    canonical_b=int(row["canonical_b"]),
                    canonical_c=int(row["canonical_c"]),
                    y=int(row["y"]),
                    z=int(row["z"]),
                    legal=int(row["legal"]),
                    orbit_size=int(row["orbit_size"]),
                )
            )

    expected_pairs = tuple((b, c) for b in range(6, 309) for c in range(b + 1, 310))
    if tuple((record.b, record.c) for record in records) != expected_pairs:
        raise ValueError("CSV rows are not the exact lexicographic normalized-row domain")
    if len(records) != EXPECTED_ROWS:
        raise ValueError(f"unexpected row count: {len(records)}")
    if sum(record.valid for record in records) != EXPECTED_VALID_ROWS:
        raise ValueError("unexpected valid-row count")
    if sum(not record.valid for record in records) != EXPECTED_BAD_ROWS:
        raise ValueError("unexpected bad-row count")

    classes: dict[int, ClassRecord] = {}
    for record in records:
        if record.valid:
            assert record.bad == (-1, -1, -1)
            assert 0 <= record.class_index < EXPECTED_CLASSES
            assert 5 < record.canonical_b < record.canonical_c < 310
            assert 5 <= record.y < 25 and 5 <= record.z < 25
            assert record.y // 5 != 0 and record.z // 5 != 0
            assert 32 <= record.legal <= 47
            assert record.orbit_size in (200, 400)
            class_record = ClassRecord(
                record.class_index,
                record.canonical_b,
                record.canonical_c,
                record.legal,
                record.orbit_size,
            )
            previous = classes.setdefault(record.class_index, class_record)
            assert previous == class_record
        else:
            i, j, k = record.bad
            assert 0 <= i < j < k < 8
            assert (
                record.class_index,
                record.canonical_b,
                record.canonical_c,
                record.y,
                record.z,
                record.legal,
                record.orbit_size,
            ) == (-1, -1, -1, -1, -1, -1, -1)

    assert set(classes) == set(range(EXPECTED_CLASSES))
    ordered_classes = tuple(classes[index] for index in range(EXPECTED_CLASSES))
    assert Counter(record.orbit_size for record in ordered_classes) == {200: 30, 400: 1159}
    assert tuple(record.index for record in ordered_classes if record.legal == 32) == MINIMUM_CLASS_IDS
    assert data_fnv1a64(records) == EXPECTED_FNV1A64
    return tuple(records), ordered_classes


def generated_header(csv_hash: str, enumerator_hash: str, description: str) -> str:
    return (
        "/-!\n"
        "# Generated C151 residual-cover payload\n\n"
        "DO NOT EDIT: generated by `notes/2026-07-15-c151-residual-cover-generator.py`\n"
        "from the independently checked C++ residual-cover stream.  These are payload records,\n"
        "not semantic certificates; the row-level residual transport bridge is intentionally\n"
        "handwritten downstream.\n\n"
        f"* payload: {description}\n"
        f"* generator SHA256: `{source_sha256()}`\n"
        f"* enumerator SHA256: `{enumerator_hash}`\n"
        f"* canonical CSV SHA256: `{csv_hash}`\n"
        f"* semantic FNV-1a-64: `{EXPECTED_FNV1A64:016x}`\n"
        "* class order: lexicographic C150 internal-orbit canonical triples\n"
        "-/\n"
    )


def render_schema(csv_hash: str, enumerator_hash: str) -> str:
    return (
        "import RelativeConicArcs.Q25ResidualAction\n\n"
        + generated_header(csv_hash, enumerator_hash, "definition-only payload schema")
        + "\nnamespace RelativeConicArcs\n"
        "namespace Q25ResidualCoverData\n\n"
        "open Q25Coordinates FiniteFields\n\n"
        "/-- An explicit ordered collinear triple in `configPoint 5 b c`. -/\n"
        "structure BadRowPayload where\n"
        "  c : Fin 310\n"
        "  i : Fin 8\n"
        "  j : Fin 8\n"
        "  k : Fin 8\n\n"
        "/-- A residual transporter to one canonical class. -/\n"
        "structure ValidRowPayload where\n"
        "  c : Fin 310\n"
        "  classIndex : Fin 1189\n"
        "  canonicalB : Fin 310\n"
        "  canonicalC : Fin 310\n"
        "  y : K25\n"
        "  z : K25\n"
        "  legalCount : Nat\n"
        "  orbitSize : Nat\n\n"
        "inductive ResidualRowPayload where\n"
        "  | bad (payload : BadRowPayload)\n"
        "  | valid (payload : ValidRowPayload)\n\n"
        "structure ResidualClassPayload where\n"
        "  canonicalB : Fin 310\n"
        "  canonicalC : Fin 310\n"
        "  legalCount : Nat\n"
        "  orbitSize : Nat\n\n"
        "end Q25ResidualCoverData\n"
        "end RelativeConicArcs\n"
    )


def render_class_payload_leaf(
    csv_hash: str, enumerator_hash: str, classes: Sequence[ClassRecord]
) -> str:
    first, last = classes[0].index, classes[-1].index
    pieces = [
        "import RelativeConicArcs.Q25ResidualCoverData.Schema\n\n",
        generated_header(
            csv_hash, enumerator_hash, f"canonical class records {first} through {last}"
        ),
        "\nnamespace RelativeConicArcs\n",
        "namespace Q25ResidualCoverData\n\n",
        f"def residualClassPayload{first:04d}_{last:04d} : Array ResidualClassPayload := #[\n",
    ]
    for record in classes:
        pieces.append(
            "  { canonicalB := ⟨%d, by decide⟩, canonicalC := ⟨%d, by decide⟩, "
            "legalCount := %d, orbitSize := %d },\n"
            % (record.canonical_b, record.canonical_c, record.legal, record.orbit_size)
        )
    pieces.extend(
        [
            "]\n\n",
            "end Q25ResidualCoverData\n",
            "end RelativeConicArcs\n",
        ]
    )
    return "".join(pieces)


def render_row(csv_hash: str, enumerator_hash: str, b: int, records: Sequence[Record]) -> str:
    first_c, last_c = records[0].c, records[-1].c
    pieces = [
        "import RelativeConicArcs.Q25ResidualCoverData.Schema\n\n",
        generated_header(
            csv_hash,
            enumerator_hash,
            f"{len(records)} normalized rows ({b},{first_c}) through ({b},{last_c})",
        ),
        "\nnamespace RelativeConicArcs\n",
        "namespace Q25ResidualCoverData\n\n",
        f"def residualCoverRow{b:03d}C{first_c:03d}_{last_c:03d} : "
        "Array ResidualRowPayload := #[\n",
    ]
    for record in records:
        if record.valid:
            pieces.append(
                "  .valid { c := ⟨%d, by decide⟩, classIndex := ⟨%d, by decide⟩, "
                "canonicalB := ⟨%d, by decide⟩, canonicalC := ⟨%d, by decide⟩, "
                "y := GF25.ofNat %d, z := GF25.ofNat %d, legalCount := %d, orbitSize := %d },\n"
                % (
                    record.c,
                    record.class_index,
                    record.canonical_b,
                    record.canonical_c,
                    record.y,
                    record.z,
                    record.legal,
                    record.orbit_size,
                )
            )
        else:
            i, j, k = record.bad
            pieces.append(
                "  .bad { c := ⟨%d, by decide⟩, i := ⟨%d, by decide⟩, "
                "j := ⟨%d, by decide⟩, k := ⟨%d, by decide⟩ },\n"
                % (record.c, i, j, k)
            )
    pieces.extend(
        [
            "]\n\n",
            "end Q25ResidualCoverData\n",
            "end RelativeConicArcs\n",
        ]
    )
    return "".join(pieces)


def render_payload_aggregate(
    csv_hash: str, enumerator_hash: str, module_names: Sequence[str], description: str
) -> str:
    imports = "".join(
        f"import RelativeConicArcs.Q25ResidualCoverData.{name[:-5]}\n"
        for name in module_names
    )
    return imports + "\n" + generated_header(csv_hash, enumerator_hash, description)


def render_all(csv_hash: str, enumerator_hash: str) -> str:
    return (
        "import RelativeConicArcs.Q25ResidualCoverData.Rows\n"
        "import RelativeConicArcs.Q25ResidualCoverData.Classes\n\n"
        + generated_header(
        csv_hash, enumerator_hash, "aggregate import for all 46,056 normalized-row records"
        )
    )


def row_composition_leaf(class_index: int) -> str:
    first = (class_index // 5) * 5
    last = min(first + 4, EXPECTED_CLASSES - 1)
    return f"C_{first:04d}_{last:04d}"


def render_class_bound_bridge(csv_hash: str, enumerator_hash: str) -> str:
    return (
        "import RelativeConicArcs.Q25LineMaskComposition\n\n"
        + class_bound_header(
            csv_hash, enumerator_hash, "generic sound-mask lower-bound bridge"
        )
        + "\nnamespace RelativeConicArcs\n"
        "namespace Q25ClassBoundData\n\n"
        "open Q25Coordinates Q25PairCertificate Q25MinimumMask Q25LineMaskComposition\n\n"
        "theorem card_legalOrbitSet_ge_of_rowCertificate {k : Nat} {a b c : OrbitCode}\n"
        "    {allowed : OrbitMask} (hcard : k ≤ (maskOrbitSet allowed).card)\n"
        "    (hrow : RowCompositionCertificate a b c allowed) :\n"
        "    k ≤ (legalOrbitSet (normalizedConfig a b c)).card := by\n"
        "  apply hcard.trans\n"
        "  apply Finset.card_le_card\n"
        "  intro o ho\n"
        "  have hbit : maskBit allowed (orbitNumberFin o) = true :=\n"
        "    (Finset.mem_filter.mp ho).2\n"
        "  have hreflected := hrow.toReflectedMaskCertificate.sound (orbitNumberFin o) hbit\n"
        "  exact Finset.mem_filter.mpr\n"
        "    ⟨Finset.mem_univ o,\n"
        "      (legalPair_iff_reflectedLegal (normalizedConfig_isConjInvariant a b c) o).2\n"
        "        (by simpa [orbitNumberFin] using hreflected)⟩\n\n"
        "end Q25ClassBoundData\n"
        "end RelativeConicArcs\n"
    )


def render_class_bound_leaf(
    csv_hash: str, enumerator_hash: str, class_indices: Sequence[int]
) -> str:
    required = sorted({row_composition_leaf(index) for index in class_indices})
    pieces = [
        "import RelativeConicArcs.Q25ClassBoundData.Bridge\n",
        "".join(
            f"import RelativeConicArcs.Q25RowCompositionData.{name}\n" for name in required
        ),
        "\n",
        class_bound_header(
            csv_hash,
            enumerator_hash,
            f"class lower bounds {class_indices[0]} through {class_indices[-1]}",
        ),
        "\nnamespace RelativeConicArcs\n",
        "namespace Q25ClassBoundData\n\n",
        "open Q25Coordinates Q25PairCertificate Q25MinimumMask Q25LineMaskComposition\n",
        "open Q25RowCompositionData\n\n",
    ]
    for index in class_indices:
        if index in MINIMUM_CLASS_IDS:
            continue
        stem = f"class{index:04d}"
        pieces.extend(
            [
                f"theorem {stem}Allowed_card_ge_33 :\n",
                f"    33 ≤ (maskOrbitSet {stem}Allowed).card := by\n",
                "  decide\n\n",
                f"theorem {stem}LegalOrbitSet_card_ge_33 :\n",
                f"    33 ≤ (legalOrbitSet (normalizedConfig {stem}A {stem}B {stem}C)).card :=\n",
                "  card_legalOrbitSet_ge_of_rowCertificate\n",
                f"    {stem}Allowed_card_ge_33 {stem}RowCertificate\n\n",
            ]
        )
    pieces.extend(
        [
            "end Q25ClassBoundData\n",
            "end RelativeConicArcs\n",
        ]
    )
    return "".join(pieces)


def render_class_bound_index(csv_hash: str, enumerator_hash: str) -> str:
    values = ", ".join(f"⟨{index}, by decide⟩" for index in MINIMUM_CLASS_IDS)
    return (
        "import RelativeConicArcs.Q25LineMaskComposition\n\n"
        + class_bound_header(csv_hash, enumerator_hash, "compact five-exception index")
        + "\nnamespace RelativeConicArcs\n"
        "namespace Q25ClassBoundData\n\n"
        f"def minimumClassNumber : Fin 5 → Fin 1189 := ![{values}]\n\n"
        "end Q25ClassBoundData\n"
        "end RelativeConicArcs\n"
    )


def render_class_bound_all(
    csv_hash: str, enumerator_hash: str, leaf_names: Sequence[str]
) -> str:
    imports = "import RelativeConicArcs.Q25ClassBoundData.Index\n" + "".join(
        f"import RelativeConicArcs.Q25ClassBoundData.{name[:-5]}\n" for name in leaf_names
    )
    return imports + "\n" + class_bound_header(
        csv_hash,
        enumerator_hash,
        "import-only aggregate dispatch for all 1,184 non-minimizer class bounds",
    )


def class_bound_header(csv_hash: str, enumerator_hash: str, description: str) -> str:
    return (
        "/-!\n"
        "# Generated C151 residual-class lower bounds\n\n"
        "DO NOT EDIT: generated by `notes/2026-07-15-c151-residual-cover-generator.py`.\n"
        "Each leaf combines a literal `classNNNNAllowed` cardinality check with its existing\n"
        "sound `RowCompositionCertificate`; no upper exactness claim is used.\n\n"
        f"* payload: {description}\n"
        f"* generator SHA256: `{source_sha256()}`\n"
        f"* enumerator SHA256: `{enumerator_hash}`\n"
        f"* canonical CSV SHA256: `{csv_hash}`\n"
        f"* minimum class IDs: `{','.join(f'{i:04d}' for i in MINIMUM_CLASS_IDS)}`\n"
        "-/\n"
    )


def tree_sha256(files: Sequence[Path], root: Path) -> str:
    digest = hashlib.sha256()
    for path in sorted(files):
        relative = path.relative_to(root).as_posix().encode()
        contents = path.read_bytes()
        digest.update(len(relative).to_bytes(4, "big"))
        digest.update(relative)
        digest.update(len(contents).to_bytes(8, "big"))
        digest.update(contents)
    return digest.hexdigest()


def write_modules(
    records: Sequence[Record],
    classes: Sequence[ClassRecord],
    csv_path: Path,
    enumerator_path: Path,
    output_directory: Path,
) -> None:
    if output_directory.name != "Q25ResidualCoverData":
        raise ValueError("output directory must be named Q25ResidualCoverData")
    enumerator_hash = sha256(enumerator_path)
    if enumerator_hash != EXPECTED_ENUMERATOR_SHA256:
        raise ValueError(f"unexpected C++ enumerator SHA256: {enumerator_hash}")
    csv_hash = sha256(csv_path)

    grouped: dict[int, list[Record]] = defaultdict(list)
    for record in records:
        grouped[record.b].append(record)
    assert set(grouped) == set(range(6, 309))
    row_chunks = tuple(
        (b, tuple(grouped[b][start : start + ROW_PAYLOAD_CHUNK]))
        for b in range(6, 309)
        for start in range(0, len(grouped[b]), ROW_PAYLOAD_CHUNK)
    )
    row_names = tuple(
        f"R_{b:03d}_C_{chunk[0].c:03d}_{chunk[-1].c:03d}.lean"
        for b, chunk in row_chunks
    )
    class_chunks = tuple(
        tuple(classes[start : start + CLASS_PAYLOAD_CHUNK])
        for start in range(0, len(classes), CLASS_PAYLOAD_CHUNK)
    )
    class_names = tuple(
        f"K_{chunk[0].index:04d}_{chunk[-1].index:04d}.lean" for chunk in class_chunks
    )
    expected = set(row_names) | set(class_names) | {
        "Schema.lean", "Rows.lean", "Classes.lean", "All.lean"
    }
    output_directory.mkdir(parents=True, exist_ok=True)
    unexpected = sorted(path.name for path in output_directory.iterdir() if path.name not in expected)
    if unexpected:
        raise RuntimeError(f"refusing output directory with unexpected entries: {unexpected}")

    written: list[Path] = []
    schema = output_directory / "Schema.lean"
    schema.write_text(render_schema(csv_hash, enumerator_hash), encoding="utf-8")
    written.append(schema)
    for name, chunk in zip(class_names, class_chunks, strict=True):
        path = output_directory / name
        path.write_text(
            render_class_payload_leaf(csv_hash, enumerator_hash, chunk), encoding="utf-8"
        )
        written.append(path)
    classes_aggregate = output_directory / "Classes.lean"
    classes_aggregate.write_text(
        render_payload_aggregate(
            csv_hash, enumerator_hash, class_names,
            "import-only aggregate for all 1,189 canonical class records",
        ),
        encoding="utf-8",
    )
    written.append(classes_aggregate)
    for name, (b, chunk) in zip(row_names, row_chunks, strict=True):
        path = output_directory / name
        path.write_text(render_row(csv_hash, enumerator_hash, b, chunk), encoding="utf-8")
        written.append(path)
    rows_aggregate = output_directory / "Rows.lean"
    rows_aggregate.write_text(
        render_payload_aggregate(
            csv_hash, enumerator_hash, row_names,
            "import-only aggregate for all 46,056 normalized-row records",
        ),
        encoding="utf-8",
    )
    written.append(rows_aggregate)
    aggregate = output_directory / "All.lean"
    aggregate.write_text(render_all(csv_hash, enumerator_hash), encoding="utf-8")
    written.append(aggregate)

    assert len(row_names) == 1071 and len(class_names) == 119 and len(written) == 1194
    print(
        f"generated_files={len(written)} row_modules={len(row_names)} "
        f"class_modules={len(class_names)} rows={len(records)}"
    )
    print(
        f"max_rows_per_leaf={ROW_PAYLOAD_CHUNK} "
        f"max_classes_per_leaf={CLASS_PAYLOAD_CHUNK}"
    )
    print(f"bad_rows={EXPECTED_BAD_ROWS} valid_rows={EXPECTED_VALID_ROWS} classes={len(classes)}")
    print(f"generated_source_bytes={sum(path.stat().st_size for path in written)}")
    print(f"output_directory={output_directory.resolve()}")
    print(f"generator_sha256={source_sha256()}")
    print(f"enumerator_sha256={enumerator_hash}")
    print(f"csv_sha256={csv_hash}")
    print(f"data_fnv1a64={data_fnv1a64(records):016x}")
    print(f"generated_tree_sha256={tree_sha256(written, output_directory)}")


def write_class_bound_modules(
    csv_path: Path, enumerator_path: Path, output_directory: Path
) -> None:
    if output_directory.name != "Q25ClassBoundData":
        raise ValueError("class-bound output directory must be named Q25ClassBoundData")
    csv_hash = sha256(csv_path)
    enumerator_hash = sha256(enumerator_path)
    if csv_hash != EXPECTED_CSV_SHA256 or enumerator_hash != EXPECTED_ENUMERATOR_SHA256:
        raise ValueError("class-bound inputs do not match the checked residual-cover stream")

    chunks = tuple(
        tuple(range(start, min(start + CLASS_BOUND_CHUNK, EXPECTED_CLASSES)))
        for start in range(0, EXPECTED_CLASSES, CLASS_BOUND_CHUNK)
    )
    leaf_names = tuple(f"C_{chunk[0]:04d}_{chunk[-1]:04d}.lean" for chunk in chunks)
    expected = set(leaf_names) | {"Bridge.lean", "Index.lean", "All.lean"}
    output_directory.mkdir(parents=True, exist_ok=True)
    unexpected = sorted(path.name for path in output_directory.iterdir() if path.name not in expected)
    if unexpected:
        raise RuntimeError(f"refusing class-bound directory with unexpected entries: {unexpected}")

    written: list[Path] = []
    bridge = output_directory / "Bridge.lean"
    bridge.write_text(render_class_bound_bridge(csv_hash, enumerator_hash), encoding="utf-8")
    written.append(bridge)
    for name, chunk in zip(leaf_names, chunks, strict=True):
        path = output_directory / name
        path.write_text(render_class_bound_leaf(csv_hash, enumerator_hash, chunk), encoding="utf-8")
        written.append(path)
    index = output_directory / "Index.lean"
    index.write_text(render_class_bound_index(csv_hash, enumerator_hash), encoding="utf-8")
    written.append(index)
    aggregate = output_directory / "All.lean"
    aggregate.write_text(
        render_class_bound_all(csv_hash, enumerator_hash, leaf_names), encoding="utf-8"
    )
    written.append(aggregate)

    assert len(leaf_names) == 119 and len(written) == 122
    print(
        f"generated_files={len(written)} leaf_modules={len(leaf_names)} "
        f"nonminimum_classes={EXPECTED_CLASSES - len(MINIMUM_CLASS_IDS)}"
    )
    print(f"minimum_class_ids={','.join(f'{i:04d}' for i in MINIMUM_CLASS_IDS)}")
    print(f"generated_source_bytes={sum(path.stat().st_size for path in written)}")
    print(f"output_directory={output_directory.resolve()}")
    print(f"generator_sha256={source_sha256()}")
    print(f"generated_tree_sha256={tree_sha256(written, output_directory)}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--csv", required=True, type=Path, help="canonical --csv enumerator output")
    parser.add_argument(
        "--enumerator",
        type=Path,
        default=Path(__file__).with_name("2026-07-15-c151-residual-cover.cpp"),
    )
    parser.add_argument("--write-lean-modules", type=Path, metavar="Q25ResidualCoverData_DIR")
    parser.add_argument("--write-class-bound-modules", type=Path, metavar="Q25ClassBoundData_DIR")
    args = parser.parse_args()
    if args.write_lean_modules is not None and args.write_class_bound_modules is not None:
        parser.error("choose only one generated Lean output tree")
    records, classes = read_records(args.csv)
    if args.write_class_bound_modules is not None:
        write_class_bound_modules(args.csv, args.enumerator, args.write_class_bound_modules)
    elif args.write_lean_modules is None:
        print(f"rows={len(records)} bad_rows={EXPECTED_BAD_ROWS} valid_rows={EXPECTED_VALID_ROWS}")
        print(f"classes={len(classes)} data_fnv1a64={data_fnv1a64(records):016x}")
        print(f"generator_sha256={source_sha256()}")
        print(f"enumerator_sha256={sha256(args.enumerator)}")
        print(f"csv_sha256={sha256(args.csv)}")
    else:
        write_modules(records, classes, args.csv, args.enumerator, args.write_lean_modules)


if __name__ == "__main__":
    main()
