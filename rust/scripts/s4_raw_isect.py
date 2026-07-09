#!/usr/bin/env python3
"""Intersect GCAPRAW3 S4 raw memo dumps.

The raw record layout is documented in notes/2026-07-08-s4-memo-dump-query-manual.md
and implemented in notes/2026-07-06-grid-cap-solver.rs:

  header: 128 bytes
  record: little-endian u128 key as (lo: u64, hi: u64), bool value byte,
          then seven zero padding bytes

This script uses raw dumps only.  Compact BuRR archives intentionally have
membership false positives and are not suitable for this soundness check.
"""

from __future__ import annotations

import argparse
import heapq
import mmap
import os
import struct
import sys
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


RAW_MAGIC = b"GCAPRAW3"
RAW_VERSION = 3
RAW_HEADER = 128
RAW_RECORD = 24
S4_CANON_ID = 0x5347_4341_4E4F_4E01
S4_ROOT_KIND_ONCONIC_INV = 1
S4_VALUE_BOOL_PN = 1
S4_KEY_U128_CANON = 1


def u16(buf: mmap.mmap, off: int) -> int:
    return struct.unpack_from("<H", buf, off)[0]


def u32(buf: mmap.mmap, off: int) -> int:
    return struct.unpack_from("<I", buf, off)[0]


def u64(buf: mmap.mmap, off: int) -> int:
    return struct.unpack_from("<Q", buf, off)[0]


def record_at(buf: mmap.mmap, idx: int) -> tuple[int, int]:
    off = RAW_HEADER + idx * RAW_RECORD
    lo, hi, val = struct.unpack_from("<QQB", buf, off)
    if val > 1:
        raise ValueError(f"value byte {val} at record {idx}")
    if any(buf[off + 17 : off + RAW_RECORD]):
        raise ValueError(f"nonzero record padding at record {idx}")
    return lo | (hi << 64), val


@dataclass(frozen=True)
class DumpHeader:
    path: Path
    q: int
    t4: tuple[int, int, int, int]
    gf_hash: int
    root_key: int
    root_cells: tuple[int, int, int, int]
    cap: int
    n_records: int
    status: int

    @property
    def group_key(self) -> tuple[int, int]:
        return (self.q, self.gf_hash)

    @property
    def status_label(self) -> str:
        if self.status == 1:
            return "P"
        if self.status == 2:
            return "N"
        return "-"


class RawDump:
    def __init__(self, path: Path):
        self.path = path
        self._fh = path.open("rb")
        self.buf = mmap.mmap(self._fh.fileno(), 0, access=mmap.ACCESS_READ)
        self.header = self._read_header()

    def close(self) -> None:
        self.buf.close()
        self._fh.close()

    def _read_header(self) -> DumpHeader:
        buf = self.buf
        if len(buf) < RAW_HEADER or buf[:8] != RAW_MAGIC:
            raise ValueError(f"{self.path}: bad raw magic")
        version = u32(buf, 8)
        header_len = u32(buf, 12)
        canon_id = u64(buf, 16)
        q = u32(buf, 24)
        root_kind = u16(buf, 28)
        record_len = u32(buf, 56)
        status = buf[60]
        value_encoding = buf[61]
        key_format = buf[62]
        flags = buf[63]
        if version != RAW_VERSION:
            raise ValueError(f"{self.path}: raw version {version}, expected {RAW_VERSION}")
        if header_len != RAW_HEADER:
            raise ValueError(f"{self.path}: header {header_len}, expected {RAW_HEADER}")
        if canon_id != S4_CANON_ID:
            raise ValueError(f"{self.path}: canon id {canon_id:#x}, expected {S4_CANON_ID:#x}")
        if root_kind != S4_ROOT_KIND_ONCONIC_INV:
            raise ValueError(f"{self.path}: root kind {root_kind}, expected {S4_ROOT_KIND_ONCONIC_INV}")
        if record_len != RAW_RECORD:
            raise ValueError(f"{self.path}: record len {record_len}, expected {RAW_RECORD}")
        if status > 2:
            raise ValueError(f"{self.path}: status byte {status}")
        if value_encoding != S4_VALUE_BOOL_PN:
            raise ValueError(f"{self.path}: value encoding {value_encoding}, expected {S4_VALUE_BOOL_PN}")
        if key_format != S4_KEY_U128_CANON:
            raise ValueError(f"{self.path}: key format {key_format}, expected {S4_KEY_U128_CANON}")
        if flags != 0:
            raise ValueError(f"{self.path}: flags byte {flags}")
        n_records = u64(buf, 48)
        expected_len = RAW_HEADER + n_records * RAW_RECORD
        if len(buf) != expected_len:
            raise ValueError(f"{self.path}: size {len(buf)}, expected {expected_len}")
        return DumpHeader(
            path=self.path,
            q=q,
            t4=(u16(buf, 32), u16(buf, 34), u16(buf, 36), u16(buf, 38)),
            gf_hash=u64(buf, 64),
            root_key=u64(buf, 72) | (u64(buf, 80) << 64),
            root_cells=(u16(buf, 88), u16(buf, 90), u16(buf, 92), u16(buf, 94)),
            cap=u64(buf, 40),
            n_records=n_records,
            status=status,
        )

    def records(self) -> Iterable[tuple[int, int]]:
        prev: int | None = None
        for idx in range(self.header.n_records):
            key, val = record_at(self.buf, idx)
            if prev is not None and key <= prev:
                raise ValueError(f"{self.path}: keys not strictly sorted at record {idx}")
            prev = key
            yield key, val


def pair_intersection(a: RawDump, b: RawDump) -> tuple[int, int]:
    ia = a.records()
    ib = b.records()
    try:
        ka, va = next(ia)
        kb, vb = next(ib)
    except StopIteration:
        return (0, 0)
    shared = 0
    disagreements = 0
    while True:
        if ka == kb:
            shared += 1
            if va != vb:
                disagreements += 1
            try:
                ka, va = next(ia)
            except StopIteration:
                break
            try:
                kb, vb = next(ib)
            except StopIteration:
                break
        elif ka < kb:
            try:
                ka, va = next(ia)
            except StopIteration:
                break
        else:
            try:
                kb, vb = next(ib)
            except StopIteration:
                break
    return shared, disagreements


def union_stats(dumps: list[RawDump]) -> dict[str, int]:
    unique = 0
    multi_keys = 0
    duplicate_observations = 0
    max_multiplicity = 0
    disagreements = 0

    for _key, entries in union_items(dumps):
        vals = {val for _file_idx, val in entries}
        multiplicity = len(entries)
        unique += 1
        if multiplicity > 1:
            multi_keys += 1
            duplicate_observations += multiplicity - 1
            if len(vals) > 1:
                disagreements += 1
        max_multiplicity = max(max_multiplicity, multiplicity)

    return {
        "unique_keys": unique,
        "multi_keys": multi_keys,
        "duplicate_observations": duplicate_observations,
        "max_multiplicity": max_multiplicity,
        "disagreement_keys": disagreements,
    }


def union_items(dumps: list[RawDump]) -> Iterable[tuple[int, list[tuple[int, int]]]]:
    heap: list[tuple[int, int, int]] = []
    iters = [dump.records() for dump in dumps]
    for file_idx, it in enumerate(iters):
        try:
            key, val = next(it)
        except StopIteration:
            continue
        heapq.heappush(heap, (key, file_idx, val))

    while heap:
        key, file_idx, val = heapq.heappop(heap)
        vals = [val]
        file_idxs = [file_idx]
        while heap and heap[0][0] == key:
            _, next_file_idx, next_val = heapq.heappop(heap)
            vals.append(next_val)
            file_idxs.append(next_file_idx)

        entries = list(zip(file_idxs, vals))
        yield key, entries

        for next_file_idx in file_idxs:
            try:
                next_key, next_val = next(iters[next_file_idx])
            except StopIteration:
                continue
            heapq.heappush(heap, (next_key, next_file_idx, next_val))


def group_intersections(dumps: list[RawDump]) -> tuple[dict[str, int], dict[tuple[int, int], list[int]]]:
    stats = {
        "unique_keys": 0,
        "multi_keys": 0,
        "duplicate_observations": 0,
        "max_multiplicity": 0,
        "disagreement_keys": 0,
    }
    pair_counts: dict[tuple[int, int], list[int]] = defaultdict(lambda: [0, 0])

    for _key, entries in union_items(dumps):
        stats["unique_keys"] += 1
        multiplicity = len(entries)
        vals = {val for _file_idx, val in entries}
        stats["max_multiplicity"] = max(stats["max_multiplicity"], multiplicity)
        if multiplicity > 1:
            stats["multi_keys"] += 1
            stats["duplicate_observations"] += multiplicity - 1
            if len(vals) > 1:
                stats["disagreement_keys"] += 1
            for ai in range(multiplicity):
                file_a, val_a = entries[ai]
                for bi in range(ai + 1, multiplicity):
                    file_b, val_b = entries[bi]
                    if file_a > file_b:
                        file_a, file_b = file_b, file_a
                        val_a, val_b = val_b, val_a
                    pair = pair_counts[(file_a, file_b)]
                    pair[0] += 1
                    if val_a != val_b:
                        pair[1] += 1

    return stats, pair_counts


def cross_union_intersection(a: list[RawDump], b: list[RawDump]) -> tuple[int, int, list[str]]:
    ia = union_items(a)
    ib = union_items(b)
    examples: list[str] = []
    try:
        ka, ea = next(ia)
        kb, eb = next(ib)
    except StopIteration:
        return (0, 0, examples)

    shared = 0
    disagreements = 0
    while True:
        if ka == kb:
            va = {val for _file_idx, val in ea}
            vb = {val for _file_idx, val in eb}
            shared += 1
            if len(va | vb) > 1:
                disagreements += 1
            if len(examples) < 5:
                examples.append(
                    f"key={ka:032x}:a_vals={','.join(map(str, sorted(va)))}:"
                    f"b_vals={','.join(map(str, sorted(vb)))}:a_mult={len(ea)}:b_mult={len(eb)}"
                )
            try:
                ka, ea = next(ia)
            except StopIteration:
                break
            try:
                kb, eb = next(ib)
            except StopIteration:
                break
        elif ka < kb:
            try:
                ka, ea = next(ia)
            except StopIteration:
                break
        else:
            try:
                kb, eb = next(ib)
            except StopIteration:
                break
    return shared, disagreements, examples


def short_path(path: Path) -> str:
    try:
        return str(path.relative_to(Path.cwd()))
    except ValueError:
        return str(path)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("raw", nargs="+", type=Path, help="GCAPRAW3 raw dump files")
    parser.add_argument(
        "--cross-groups",
        action="store_true",
        help="also check pairwise intersections between different (q,gf_hash) groups",
    )
    parser.add_argument(
        "--only-cross-groups",
        action="store_true",
        help="only check intersections between different (q,gf_hash) groups",
    )
    args = parser.parse_args()

    dumps: list[RawDump] = []
    try:
        for path in args.raw:
            dumps.append(RawDump(path))

        groups: dict[tuple[int, int], list[RawDump]] = {}
        for dump in dumps:
            groups.setdefault(dump.header.group_key, []).append(dump)

        any_disagreement = False
        print(
            "RAW_LAYOUT magic=GCAPRAW3 version=3 header=128 record=24 "
            "key=u128-le(lo64,hi64) value=bool(P=0,N=1) padding=7"
        )
        for idx, dump in enumerate(dumps):
            h = dump.header
            print(
                "FILE "
                f"idx={idx} q={h.q} gf_hash={h.gf_hash:016x} "
                f"t4={','.join(map(str, h.t4))} status={h.status_label} "
                f"records={h.n_records} cap={h.cap} root_key={h.root_key:032x} "
                f"path={short_path(h.path)}"
            )

        if not args.only_cross_groups:
            for group_idx, (group_key, group) in enumerate(sorted(groups.items())):
                q, gf_hash = group_key
                print(f"GROUP idx={group_idx} q={q} gf_hash={gf_hash:016x} files={len(group)}")
                total_records = sum(d.header.n_records for d in group)
                stats, pair_counts = group_intersections(group)
                for i in range(len(group)):
                    for j in range(i + 1, len(group)):
                        shared, disagreements = pair_counts.get((i, j), [0, 0])
                        if disagreements:
                            any_disagreement = True
                        print(
                            "PAIR "
                            f"group={group_idx} a={i} b={j} shared={shared} "
                            f"disagreements={disagreements} "
                            f"a_path={short_path(group[i].path)} b_path={short_path(group[j].path)}"
                        )
                if stats["disagreement_keys"]:
                    any_disagreement = True
                print(
                    "UNION "
                    f"group={group_idx} q={q} files={len(group)} total_records={total_records} "
                    f"unique_keys={stats['unique_keys']} multi_keys={stats['multi_keys']} "
                    f"duplicate_observations={stats['duplicate_observations']} "
                    f"max_multiplicity={stats['max_multiplicity']} "
                    f"disagreement_keys={stats['disagreement_keys']}"
                )

        if args.cross_groups or args.only_cross_groups:
            ordered_groups = sorted(groups.items())
            for gi in range(len(ordered_groups)):
                for gj in range(gi + 1, len(ordered_groups)):
                    (qa, gfa), group_a = ordered_groups[gi]
                    (qb, gfb), group_b = ordered_groups[gj]
                    shared, disagreements, examples = cross_union_intersection(group_a, group_b)
                    if disagreements:
                        any_disagreement = True
                    print(
                        "CROSS "
                        f"q_a={qa} gf_a={gfa:016x} files_a={len(group_a)} "
                        f"q_b={qb} gf_b={gfb:016x} files_b={len(group_b)} "
                        f"shared_unique_keys={shared} disagreements={disagreements}"
                    )
                    for example in examples:
                        print(f"CROSS-EXAMPLE {example}")

        return 2 if any_disagreement else 0
    finally:
        for dump in dumps:
            dump.close()


if __name__ == "__main__":
    sys.exit(main())
