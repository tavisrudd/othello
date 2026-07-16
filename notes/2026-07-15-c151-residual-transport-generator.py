#!/usr/bin/env python3
"""Derive C151 eight-point residual-transport permutations from the checked CSV."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import sys
from collections import Counter
from pathlib import Path
from typing import NamedTuple, Sequence


HERE = Path(__file__).resolve().parent
COVER_GENERATOR = HERE / "2026-07-15-c151-residual-cover-generator.py"
EXPECTED_VALID_ROWS = 7044
TRANSPORT_ROWS_PER_MODULE = 8


def load_cover_generator():
    spec = importlib.util.spec_from_file_location("c151_residual_cover_generator", COVER_GENERATOR)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


cover = load_cover_generator()


class Point(NamedTuple):
    chart: int
    y: int
    z: int


class TransportRecord(NamedTuple):
    row: object
    forward: tuple[int, ...]
    inverse: tuple[int, ...]


class PayloadLeaf(NamedTuple):
    b: int
    first_c: int
    last_c: int
    records: tuple[object, ...]

    @property
    def module_name(self) -> str:
        return f"R_{self.b:03d}_C_{self.first_c:03d}_{self.last_c:03d}"

    @property
    def array_name(self) -> str:
        return f"residualCoverRow{self.b:03d}C{self.first_c:03d}_{self.last_c:03d}"


class TransportLeaf(NamedTuple):
    payload_leaf: PayloadLeaf
    part: int
    records: tuple[tuple[int, TransportRecord], ...]

    @property
    def module_name(self) -> str:
        leaf = self.payload_leaf
        return f"T_{leaf.b:03d}_C_{leaf.first_c:03d}_{leaf.last_c:03d}_V_{self.part:02d}"


def gf_add(a: int, b: int) -> int:
    return (a % 5 + b % 5) % 5 + 5 * ((a // 5 + b // 5) % 5)


def gf_mul(a: int, b: int) -> int:
    real = (a % 5 * (b % 5) + 2 * (a // 5 * (b // 5))) % 5
    imag = (a % 5 * (b // 5) + a // 5 * (b % 5)) % 5
    return real + 5 * imag


def gf_conj(a: int) -> int:
    return a % 5 + 5 * ((-(a // 5)) % 5)


def small_nonfixed(a: int, b: int) -> int:
    return a + 5 * (b + 1)


def orbit_representative(number: int) -> Point:
    if number < 250:
        return Point(1, small_nonfixed(number // 50, (number // 25) % 2), number % 25)
    if number < 300:
        offset = number - 250
        return Point(1, (offset // 10) % 5, small_nonfixed((offset // 2) % 5, offset % 2))
    offset = number - 300
    return Point(0, 1, small_nonfixed((offset // 2) % 5, offset % 2))


def conjugate(point: Point) -> Point:
    if point.chart == 1:
        return Point(1, gf_conj(point.y), gf_conj(point.z))
    if point.chart == 0:
        return Point(0, 1, gf_conj(point.z))
    assert point == Point(-1, 0, 1)
    return point


def config_points(b: int, c: int) -> tuple[Point, ...]:
    points = [Point(-1, 0, 1), Point(0, 1, 0)]
    for number in (5, b, c):
        representative = orbit_representative(number)
        points.extend((representative, conjugate(representative)))
    assert len(points) == 8 and len(set(points)) == 8
    return tuple(points)


def coordinate_scale(parameter: int) -> int:
    imaginary = parameter // 5
    assert imaginary != 0
    return pow(imaginary, -1, 5)


def coordinate_shift(parameter: int) -> int:
    return (-coordinate_scale(parameter) * (parameter % 5)) % 5


def residual_apply(y: int, z: int, point: Point) -> Point:
    if point.chart == 1:
        return Point(
            1,
            gf_add(coordinate_shift(y), gf_mul(coordinate_scale(y), point.y)),
            gf_add(coordinate_shift(z), gf_mul(coordinate_scale(z), point.z)),
        )
    if point.chart == 0:
        coefficient = (y // 5) * coordinate_scale(z) % 5
        return Point(0, 1, gf_mul(coefficient, point.z))
    assert point == Point(-1, 0, 1)
    return point


def transport_permutation(row) -> TransportRecord:
    assert row.valid
    source = config_points(row.b, row.c)
    target = config_points(row.canonical_b, row.canonical_c)
    target_index = {point: index for index, point in enumerate(target)}
    forward = tuple(target_index[residual_apply(row.y, row.z, point)] for point in source)
    assert sorted(forward) == list(range(8))
    inverse = tuple(forward.index(index) for index in range(8))
    assert all(forward[inverse[index]] == index for index in range(8))
    return TransportRecord(row, forward, inverse)


def transport_fnv1a64(records: tuple[TransportRecord, ...]) -> int:
    state = 14_695_981_039_346_656_037
    for record in records:
        for value in (record.row.b, record.row.c, *record.forward, *record.inverse):
            state = cover.fnv_feed(value, state)
    return state


def source_sha256() -> str:
    return hashlib.sha256(Path(__file__).read_bytes()).hexdigest()


def payload_leaves(rows: Sequence[object]) -> tuple[PayloadLeaf, ...]:
    grouped: dict[int, list[object]] = {}
    for row in rows:
        grouped.setdefault(row.b, []).append(row)
    assert set(grouped) == set(range(6, 309))
    leaves = []
    for b in range(6, 309):
        b_rows = grouped[b]
        assert [row.c for row in b_rows] == list(range(b + 1, 310))
        for start in range(0, len(b_rows), cover.ROW_PAYLOAD_CHUNK):
            chunk = tuple(b_rows[start : start + cover.ROW_PAYLOAD_CHUNK])
            leaves.append(PayloadLeaf(b, chunk[0].c, chunk[-1].c, chunk))
    assert len(leaves) == 1071
    return tuple(leaves)


def transport_leaves(
    rows: Sequence[object], transports: Sequence[TransportRecord]
) -> tuple[TransportLeaf, ...]:
    by_pair = {(record.row.b, record.row.c): record for record in transports}
    assert len(by_pair) == EXPECTED_VALID_ROWS
    leaves = []
    covered_pairs = []
    for payload_leaf in payload_leaves(rows):
        valid = tuple(
            (offset, by_pair[(row.b, row.c)])
            for offset, row in enumerate(payload_leaf.records)
            if row.valid
        )
        for start in range(0, len(valid), TRANSPORT_ROWS_PER_MODULE):
            chunk = valid[start : start + TRANSPORT_ROWS_PER_MODULE]
            leaves.append(TransportLeaf(payload_leaf, start // TRANSPORT_ROWS_PER_MODULE, chunk))
            covered_pairs.extend((record.row.b, record.row.c) for _, record in chunk)
    assert len(covered_pairs) == EXPECTED_VALID_ROWS
    assert len(set(covered_pairs)) == EXPECTED_VALID_ROWS
    assert set(covered_pairs) == set(by_pair)
    assert all(1 <= len(leaf.records) <= TRANSPORT_ROWS_PER_MODULE for leaf in leaves)
    return tuple(leaves)


def fin_array(values: tuple[int, ...]) -> str:
    return "![" + ", ".join(str(value) for value in values) + "]"


def lean_payload(row) -> str:
    return (
        "{ c := ⟨%d, by decide⟩, classIndex := ⟨%d, by decide⟩, "
        "canonicalB := ⟨%d, by decide⟩, canonicalC := ⟨%d, by decide⟩, "
        "y := GF25.ofNat %d, z := GF25.ofNat %d, legalCount := %d, orbitSize := %d }"
        % (
            row.c,
            row.class_index,
            row.canonical_b,
            row.canonical_c,
            row.y,
            row.z,
            row.legal,
            row.orbit_size,
        )
    )


def generated_header(
    csv_hash: str, transport_fnv: int, description: str
) -> str:
    return f"""/-!
# Generated C151 residual-transport certificates

DO NOT EDIT: generated by `notes/2026-07-15-c151-residual-transport-generator.py`.

* payload: {description}
* canonical CSV SHA256: `{csv_hash}`
* cover-generator SHA256: `{cover.source_sha256()}`
* transport-generator SHA256: `{source_sha256()}`
* transport FNV-1a-64: `{transport_fnv:016x}`
-/
"""


def theorem_prefix(row) -> str:
    return f"residualTransportB{row.b:03d}C{row.c:03d}"


def render_transport_theorems(
    payload_leaf: PayloadLeaf, offset: int, record: TransportRecord
) -> str:
    row = record.row
    prefix = theorem_prefix(row)
    return f"""def {prefix}Payload : ValidRowPayload :=
  {lean_payload(row)}

def {prefix}ForwardIndex : Fin 8 → Fin 8 := {fin_array(record.forward)}
def {prefix}InverseIndex : Fin 8 → Fin 8 := {fin_array(record.inverse)}

theorem {prefix}_transportValid :
    {prefix}Payload.TransportValid ⟨{row.b}, by decide⟩ := by
  apply ValidRowPayload.transportValid_of_pointTransport
    {prefix}ForwardIndex {prefix}InverseIndex (by decide) (by decide)
  · unfold ValidRowPayload.PointTransport
    intro i
    fin_cases i <;>
      simp [{prefix}Payload, {prefix}ForwardIndex, configPoint, orbitCodeOfNumber,
        codeFin5, codeFin2, smallNonfixed, orbitIdx, Q25Coordinates.conjIdx,
        Q25Coordinates.conj, residualApply, Q25Normalization.shift,
        Q25Normalization.scale, Q25Normalization.realPart, Q25Normalization.imagPart,
        GF25.ofNat, GF25.encode] <;> decide
  · intro i
    fin_cases i <;> decide

theorem {prefix}_payloadValidFor :
    ({payload_leaf.array_name}[{offset}]'(by decide)).ValidFor ⟨{row.b}, by decide⟩ := by
  simpa [ResidualRowPayload.ValidFor, {payload_leaf.array_name}, {prefix}Payload] using
    {prefix}_transportValid

"""


def render_transport_leaf(
    leaf: TransportLeaf, csv_hash: str, transport_fnv: int
) -> str:
    payload_leaf = leaf.payload_leaf
    rows = [record.row for _, record in leaf.records]
    pieces = [
        "import RelativeConicArcs.Q25ResidualCoverBridge\n",
        f"import RelativeConicArcs.Q25ResidualCoverData.{payload_leaf.module_name}\n\n",
        generated_header(
            csv_hash,
            transport_fnv,
            f"{len(rows)} valid rows ({rows[0].b},{rows[0].c}) through "
            f"({rows[-1].b},{rows[-1].c}), aligned to {payload_leaf.module_name}",
        ),
        "\nnamespace RelativeConicArcs\n",
        "namespace Q25ResidualTransportData\n\n",
        "open Q25Coordinates Q25PairCertificate Q25Normalization Q25ResidualAction\n",
        "  Q25ResidualCoverData FiniteFields\n\n",
    ]
    for offset, record in leaf.records:
        pieces.append(render_transport_theorems(payload_leaf, offset, record))
    pieces.extend(
        [
            "end Q25ResidualTransportData\n",
            "end RelativeConicArcs\n",
        ]
    )
    return "".join(pieces)


def render_import_aggregate(
    module_names: Sequence[str], csv_hash: str, transport_fnv: int, description: str
) -> str:
    imports = "".join(
        f"import RelativeConicArcs.Q25ResidualTransportData.{name}\n"
        for name in module_names
    )
    return imports + "\n" + generated_header(csv_hash, transport_fnv, description)


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


def write_lean_modules(
    output_directory: Path,
    rows: Sequence[object],
    transports: tuple[TransportRecord, ...],
    csv_hash: str,
) -> None:
    if output_directory.name != "Q25ResidualTransportData":
        raise ValueError("output directory must be named Q25ResidualTransportData")
    leaves = transport_leaves(rows, transports)
    leaf_names = tuple(leaf.module_name for leaf in leaves)
    aggregate_names = tuple(f"B_{b:03d}" for b in range(6, 309))
    expected = {f"{name}.lean" for name in (*leaf_names, *aggregate_names)} | {
        "All.lean",
        "Prototype.lean",
    }
    output_directory.mkdir(parents=True, exist_ok=True)
    unexpected = sorted(path.name for path in output_directory.iterdir() if path.name not in expected)
    if unexpected:
        raise RuntimeError(f"refusing output directory with unexpected entries: {unexpected}")

    transport_fnv = transport_fnv1a64(transports)
    written = []
    for leaf in leaves:
        path = output_directory / f"{leaf.module_name}.lean"
        path.write_text(render_transport_leaf(leaf, csv_hash, transport_fnv), encoding="utf-8")
        written.append(path)

    for b, aggregate_name in zip(range(6, 309), aggregate_names, strict=True):
        modules = tuple(leaf.module_name for leaf in leaves if leaf.payload_leaf.b == b)
        path = output_directory / f"{aggregate_name}.lean"
        path.write_text(
            render_import_aggregate(
                modules,
                csv_hash,
                transport_fnv,
                f"import-only aggregate for all valid residual transports with b = {b}",
            ),
            encoding="utf-8",
        )
        written.append(path)

    all_path = output_directory / "All.lean"
    all_path.write_text(
        render_import_aggregate(
            aggregate_names,
            csv_hash,
            transport_fnv,
            "import-only aggregate for all 7,044 valid residual transports",
        ),
        encoding="utf-8",
    )
    written.append(all_path)

    assert len(written) == len(expected) - 1
    prototype_leaf = next(
        leaf for leaf in leaves if any(record.row.b == 40 and record.row.c == 196 for _, record in leaf.records)
    )
    print(
        f"generated_files={len(written)} semantic_modules={len(leaves)} "
        f"b_aggregates={len(aggregate_names)} valid_rows={len(transports)}"
    )
    print(f"max_valid_rows_per_module={max(len(leaf.records) for leaf in leaves)}")
    print(f"generated_source_bytes={sum(path.stat().st_size for path in written)}")
    print(f"output_directory={output_directory.resolve()}")
    print(f"csv_sha256={csv_hash}")
    print(f"cover_generator_sha256={cover.source_sha256()}")
    print(f"transport_generator_sha256={source_sha256()}")
    print(f"transport_fnv1a64={transport_fnv:016x}")
    print(f"generated_tree_sha256={tree_sha256(written, output_directory)}")
    print(f"recommended_first_leaf={prototype_leaf.module_name}.lean")


def render_lean_prototype(record: TransportRecord, csv_hash: str) -> str:
    row = record.row
    return f"""import RelativeConicArcs.Q25ResidualCoverBridge

/-!
# Generated C151 residual-transport prototype

DO NOT EDIT: generated by `notes/2026-07-15-c151-residual-transport-generator.py`.
This one-row module is the semantic-certificate memory gate before bulk sharding.

* source row: `(5,{row.b},{row.c})`
* canonical row: `(5,{row.canonical_b},{row.canonical_c})`
* CSV SHA256: `{csv_hash}`
* cover-generator SHA256: `{cover.source_sha256()}`
* transport-generator SHA256: `{source_sha256()}`
-/

namespace RelativeConicArcs
namespace Q25ResidualTransportData

open Q25Coordinates Q25PairCertificate Q25Normalization Q25ResidualAction
  Q25ResidualCoverData FiniteFields

def prototypePayload : ValidRowPayload :=
  {{ c := ⟨{row.c}, by decide⟩
    classIndex := ⟨{row.class_index}, by decide⟩
    canonicalB := ⟨{row.canonical_b}, by decide⟩
    canonicalC := ⟨{row.canonical_c}, by decide⟩
    y := GF25.ofNat {row.y}
    z := GF25.ofNat {row.z}
    legalCount := {row.legal}
    orbitSize := {row.orbit_size} }}

def prototypeForwardIndex : Fin 8 → Fin 8 := {fin_array(record.forward)}
def prototypeInverseIndex : Fin 8 → Fin 8 := {fin_array(record.inverse)}

theorem prototypeTransport : prototypePayload.TransportValid ⟨{row.b}, by decide⟩ := by
  apply ValidRowPayload.transportValid_of_pointTransport
    prototypeForwardIndex prototypeInverseIndex (by decide) (by decide)
  · unfold ValidRowPayload.PointTransport
    intro i
    fin_cases i <;>
      simp [prototypePayload, prototypeForwardIndex, configPoint, orbitCodeOfNumber,
        codeFin5, codeFin2, smallNonfixed, orbitIdx, Q25Coordinates.conjIdx,
        Q25Coordinates.conj, residualApply, Q25Normalization.shift,
        Q25Normalization.scale, Q25Normalization.realPart, Q25Normalization.imagPart,
        GF25.ofNat, GF25.encode] <;> decide
  · intro i
    fin_cases i <;> decide

end Q25ResidualTransportData
end RelativeConicArcs
"""


def write_lean_prototype(path: Path, record: TransportRecord, csv_hash: str) -> None:
    if path.name != "Prototype.lean" or path.parent.name != "Q25ResidualTransportData":
        raise ValueError("prototype path must end in Q25ResidualTransportData/Prototype.lean")
    path.parent.mkdir(exist_ok=True)
    path.write_text(render_lean_prototype(record, csv_hash), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--csv", required=True, type=Path)
    parser.add_argument("--write-lean-prototype", type=Path)
    parser.add_argument("--write-lean-modules", type=Path)
    parser.add_argument("--prototype-b", type=int, default=40)
    parser.add_argument("--prototype-c", type=int, default=196)
    args = parser.parse_args()
    if args.write_lean_prototype is not None and args.write_lean_modules is not None:
        parser.error("choose only one Lean output mode")
    rows, _ = cover.read_records(args.csv)
    transports = tuple(transport_permutation(row) for row in rows if row.valid)
    assert len(transports) == EXPECTED_VALID_ROWS
    prototype = next(
        record
        for record in transports
        if (record.row.b, record.row.c) == (args.prototype_b, args.prototype_c)
    )
    if (args.prototype_b, args.prototype_c) == (40, 196):
        assert prototype.forward == (0, 1, 7, 6, 4, 5, 2, 3)
        assert prototype.inverse == (0, 1, 6, 7, 4, 5, 3, 2)
    histogram = Counter(record.forward for record in transports)
    assert sum(histogram.values()) == EXPECTED_VALID_ROWS
    print(f"valid_rows={len(transports)} distinct_point_permutations={len(histogram)}")
    print(f"transport_fnv1a64={transport_fnv1a64(transports):016x}")
    print(f"csv_sha256={hashlib.sha256(args.csv.read_bytes()).hexdigest()}")
    print(f"cover_generator_sha256={cover.source_sha256()}")
    print(f"generator_sha256={source_sha256()}")
    if args.write_lean_prototype is not None:
        write_lean_prototype(args.write_lean_prototype, prototype, cover.sha256(args.csv))
        print(f"lean_prototype={args.write_lean_prototype.resolve()}")
    if args.write_lean_modules is not None:
        write_lean_modules(
            args.write_lean_modules,
            rows,
            transports,
            cover.sha256(args.csv),
        )


if __name__ == "__main__":
    main()
