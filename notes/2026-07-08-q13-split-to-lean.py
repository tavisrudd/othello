#!/usr/bin/env python3
"""Generate split Lean certificate data and assembly for anchored q=13.

The q=11 certificate data barely fits as one generated Lean module.  The q=13
anchored book is much larger, so this generator emits a shared base module, one
module per anchored class, an import aggregator, and a thin transport assembly
module mirroring the q=11 assembly.
"""

from __future__ import annotations

import argparse
import importlib.util
import sys
from dataclasses import dataclass
from itertools import permutations
from pathlib import Path


def load_anchor_gen():
    path = Path(__file__).with_name("2026-07-07-anchored-cert-to-lean.py")
    spec = importlib.util.spec_from_file_location("anchor_gen", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    return mod


def class_prefix(ci: int) -> str:
    return f"class{ci}"


def invalid_name(a: int, b: int) -> str:
    return f"invalid_{a}_{b}"


def invalid_kind(a: int, b: int) -> str:
    if (a, b) in {(0, 0), (1, 1)}:
        return "card"
    if a == 0:
        return "row0"
    if b == 0:
        return "col0"
    if a == 1:
        return "row1"
    if b == 1:
        return "col1"
    if a == b:
        return "diag"
    raise ValueError(f"unexpected invalid anchored cell {(a, b)}")


@dataclass(frozen=True)
class CanonicalTransport:
    source: tuple[int, int]
    ci: int
    target: tuple[int, int]
    swap: bool
    row_scale: int
    row_shift: int
    col_scale: int
    col_shift: int


def valid_anchored_cells(q: int) -> list[tuple[int, int]]:
    return [
        (a, b)
        for a in range(q)
        for b in range(q)
        if a not in (0, 1) and b not in (0, 1) and a != b
    ]


def mod_inv(q: int, x: int) -> int:
    x %= q
    if x == 0:
        raise ZeroDivisionError("zero has no inverse")
    return pow(x, q - 2, q)


def maybe_axis_params(
    q: int,
    src1: tuple[int, int],
    src2: tuple[int, int],
    dst1: tuple[int, int],
    dst2: tuple[int, int],
    swap: bool,
) -> tuple[int, int, int, int] | None:
    if swap:
        src1 = (src1[1], src1[0])
        src2 = (src2[1], src2[0])
    dr = (src2[0] - src1[0]) % q
    dc = (src2[1] - src1[1]) % q
    if dr == 0 or dc == 0:
        return None
    row_scale = (dst2[0] - dst1[0]) * mod_inv(q, dr) % q
    col_scale = (dst2[1] - dst1[1]) * mod_inv(q, dc) % q
    row_shift = (dst1[0] - row_scale * src1[0]) % q
    col_shift = (dst1[1] - col_scale * src1[1]) % q
    return row_scale, row_shift, col_scale, col_shift


def apply_axis(
    q: int,
    p: tuple[int, int],
    params: tuple[int, int, int, int],
    swap: bool,
) -> tuple[int, int]:
    row_scale, row_shift, col_scale, col_shift = params
    r, c = p
    if swap:
        r, c = c, r
    return ((row_scale * r + row_shift) % q, (col_scale * c + col_shift) % q)


def find_canonical_transport(
    q: int,
    source: tuple[int, int],
    reps: list[tuple[int, tuple[int, int]]],
) -> CanonicalTransport:
    source_set = [(0, 0), (1, 1), source]
    for swap in (False, True):
        for ci, target in reps:
            target_set = [(0, 0), (1, 1), target]
            target_finset = set(target_set)
            for src_i, src_j in permutations(range(3), 2):
                for dst_i, dst_j in permutations(range(3), 2):
                    params = maybe_axis_params(
                        q,
                        source_set[src_i],
                        source_set[src_j],
                        target_set[dst_i],
                        target_set[dst_j],
                        swap,
                    )
                    if params is None:
                        continue
                    image = {apply_axis(q, p, params, swap) for p in source_set}
                    if image == target_finset:
                        return CanonicalTransport(
                            source=source,
                            ci=ci,
                            target=target,
                            swap=swap,
                            row_scale=params[0],
                            row_shift=params[1],
                            col_scale=params[2],
                            col_shift=params[3],
                        )
    raise ValueError(f"no canonical transport found for anchored third cell {source}")


def canonical_transports(q: int, classes) -> dict[tuple[int, int], CanonicalTransport]:
    reps: list[tuple[int, tuple[int, int]]] = []
    for rec in sorted(classes, key=lambda c: c.ci):
        if rec.s3[:2] != [(0, 0), (1, 1)]:
            raise ValueError(f"class {rec.ci} is not anchored: {rec.s3}")
        reps.append((rec.ci, rec.s3[2]))
    transports = {
        cell: find_canonical_transport(q, cell, reps)
        for cell in valid_anchored_cells(q)
    }
    used = sorted({t.ci for t in transports.values()})
    declared = sorted(rec.ci for rec in classes)
    if used != declared:
        raise ValueError(f"canonical transport does not use all classes: used={used} declared={declared}")
    return transports


NODE_CHUNK_GROUP_SIZE = 32
NODE_CHUNK_SIZE = 10
STEPDATA_CHUNK_SIZE = 1
STEPDATA_CHUNK_GROUP_SIZE = NODE_CHUNK_GROUP_SIZE * NODE_CHUNK_SIZE
STEPDATA_SUBGROUP_SIZE = NODE_CHUNK_SIZE


def emit_base(q: int, anchor_gen) -> str:
    cells = [(r, c) for r in range(q) for c in range(q)]
    cell_chunks = anchor_gen.chunks(cells, 11)
    lines: list[str] = [
        "import ProjectiveCap.CertCheck",
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        f"namespace Q{q}",
        "",
        f"instance : Fact (Nat.Prime {q}) := Fact.mk (by decide)",
        "",
        f"abbrev K := ZMod {q}",
        "abbrev P := GridPoint K",
        "",
        "def pt (r c : Nat) : P := ((r : K), (c : K))",
        "",
    ]
    for idx, chunk in enumerate(cell_chunks):
        lines.append(f"def allCellsChunk{idx} : List P :=")
        lines.append(f"  {anchor_gen.lean_list([anchor_gen.lean_point(c) for c in chunk], 'P')}")
    lines.append("def allCellChunks : List (List P) :=")
    lines.append(
        f"  {anchor_gen.lean_list([f'allCellsChunk{idx}' for idx in range(len(cell_chunks))], 'List P')}"
    )
    lines.extend([
        "def allCells : List P :=",
        "  allCellChunks.flatten",
        "theorem allCells_mem (x : GridPoint K) : x ∈ allCells := by",
        "  rcases x with ⟨r, c⟩",
        "  fin_cases r <;> fin_cases c <;> decide",
        "",
        f"end Q{q}",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def emit_class(q: int, rec, anchor_gen) -> str:
    ns = f"Q{q}"
    pfx = class_prefix(rec.ci)
    witness_term = f"({anchor_gen.lean_point(rec.witness)})"
    lines: list[str] = [
        f"import ProjectiveCap.CertData.{ns}.Base",
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        f"namespace {ns}",
        "",
    ]
    lines.append(f"def {pfx}_s3 : List P :=")
    lines.append(f"  {anchor_gen.lean_list([anchor_gen.lean_point(c) for c in rec.s3], 'P')}")
    for nid in sorted(rec.nodes):
        lines.append(f"def {pfx}_node{nid} : List P :=")
        lines.append(f"  {anchor_gen.lean_list([anchor_gen.lean_point(c) for c in rec.nodes[nid]], 'P')}")
    node_names = [f"{pfx}_node{nid}" for nid in sorted(rec.nodes)]
    node_chunks = anchor_gen.chunks(node_names, NODE_CHUNK_SIZE)
    node_chunk_names = []
    for idx, chunk in enumerate(node_chunks):
        cname = f"{pfx}_nodeChunk{idx}"
        node_chunk_names.append(cname)
        lines.append(f"def {cname} : List (List P) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'List P')}")
    node_chunk_groups = anchor_gen.chunks(node_chunk_names, NODE_CHUNK_GROUP_SIZE)
    node_chunk_group_names = []
    for idx, chunk in enumerate(node_chunk_groups):
        cname = f"{pfx}_nodeChunkGroup{idx}"
        node_chunk_group_names.append(cname)
        lines.append(f"def {cname} : List (List (List P)) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'List (List P)')}")
    lines.append(f"def {pfx}_nodeChunkGroups : List (List (List (List P))) :=")
    lines.append(f"  {anchor_gen.lean_list(node_chunk_group_names, 'List (List (List P))')}")
    lines.append(f"def {pfx}_nodeChunks : List (List (List P)) :=")
    lines.append(f"  {pfx}_nodeChunkGroups.flatten")
    lines.append(f"def {pfx}_nodes : List (List P) :=")
    lines.append(f"  {pfx}_nodeChunks.flatten")
    row_names = []
    rows_by_node = {nid: [] for nid in sorted(rec.nodes)}
    for ridx, (nid, mover, reply, cid) in enumerate(rec.rows):
        rname = f"{pfx}_row{ridx}"
        row_names.append(rname)
        rows_by_node[nid].append(rname)
        lines.append(f"def {rname} : CertCheck.RowData K where")
        lines.append(f"  node := {pfx}_node{nid}")
        lines.append(f"  mover := {anchor_gen.lean_point(mover)}")
        lines.append(f"  reply := {anchor_gen.lean_point(reply)}")
        lines.append(f"  child := {pfx}_node{cid}")
    row_chunks = anchor_gen.chunks(row_names, 4)
    row_chunk_names = []
    for idx, chunk in enumerate(row_chunks):
        cname = f"{pfx}_rowChunk{idx}"
        row_chunk_names.append(cname)
        lines.append(f"def {cname} : List (CertCheck.RowData K) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'CertCheck.RowData K')}")
    lines.append(f"def {pfx}_rowChunks : List (List (CertCheck.RowData K)) :=")
    lines.append(f"  {anchor_gen.lean_list(row_chunk_names, 'List (CertCheck.RowData K)')}")
    lines.append(f"def {pfx}_rows : List (CertCheck.RowData K) :=")
    lines.append(f"  {pfx}_rowChunks.flatten")
    lines.append(f"def {pfx}_book : CertCheck.BookData K where")
    lines.append("  cells := allCells")
    lines.append(f"  root := {pfx}_node0")
    lines.append(f"  nodes := {pfx}_nodes")
    lines.append(f"  rows := {pfx}_rows")
    lines.append(f"theorem {pfx}_nodeChunks_flatten : {pfx}_nodeChunks.flatten = {pfx}_book.nodes := by")
    lines.append("  rfl")
    lines.append(
        f"theorem {pfx}_nodeChunkGroups_flatten : {pfx}_nodeChunkGroups.flatten.flatten = {pfx}_book.nodes := by"
    )
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_rowChunks_flatten : {pfx}_rowChunks.flatten = {pfx}_book.rows := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_cellChunks_flatten : allCellChunks.flatten = {pfx}_book.cells := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_book_cells_eq : {pfx}_book.cells = allCells := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_book_nodes_eq : {pfx}_book.nodes = {pfx}_nodes := by")
    lines.append("  rfl")
    lines.append(f"def {pfx}_data : CertCheck.ClassData K where")
    lines.append(f"  classIndex := {rec.ci}")
    lines.append(f"  sizeThree := {pfx}_s3")
    lines.append(f"  witness := {anchor_gen.lean_point(rec.witness)}")
    lines.append(f"  book := {pfx}_book")
    lines.append(f"def {pfx} : GridClassCert K :=")
    lines.append(f"  {pfx}_data.toLooseCert")
    lines.append(f"theorem {pfx}_size_check :")
    lines.append(f"    decide ({pfx}_s3.toFinset.card = 3) = true := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_s3_cap_check :")
    lines.append(f"    CertCheck.checkCap (K := K) {pfx}_s3 = true := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_witness_check :")
    lines.append(f"    CertCheck.checkMove (K := K) {pfx}_s3 {witness_term} = true := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_root_eq_check :")
    lines.append(
        f"    decide ({pfx}_book.root.toFinset = insert {witness_term} {pfx}_s3.toFinset) = true := by"
    )
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_root_node_check :")
    lines.append(
        f"    CertCheck.BookData.checkNodeMemberChunks (K := K) {pfx}_book.root.toFinset {pfx}_nodeChunks = true := by"
    )
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_root_mem : {pfx}_book.root.toFinset ∈ {pfx}_book.nodesFinset := by")
    lines.append(
        f"  exact CertCheck.BookData.checkNodeMember_of_chunks (K := K) {pfx}_nodeChunks_flatten {pfx}_root_node_check"
    )
    node_cap_names = []
    for nid in sorted(rec.nodes):
        ncap_name = f"{pfx}_node{nid}_cap_check"
        node_cap_names.append(ncap_name)
        lines.append(f"theorem {ncap_name} :")
        lines.append(f"    CertCheck.checkCap (K := K) {pfx}_node{nid} = true := by")
        lines.append("  rfl")
    node_chunk_check_names = []
    for idx, chunk in enumerate(node_chunks):
        cname = f"{pfx}_nodeChunk{idx}_check"
        node_chunk_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.allShort (fun S => CertCheck.checkCap (K := K) S) {pfx}_nodeChunk{idx} = true := by"
        )
        chunk_node_ids = [name.removeprefix(f"{pfx}_node") for name in chunk]
        simp_terms = ", ".join(
            [f"{pfx}_nodeChunk{idx}"]
            + [f"{pfx}_node{nid}_cap_check" for nid in chunk_node_ids]
        )
        lines.append(f"  simp only [CertCheck.allShort, {simp_terms}, reduceIte]")
    node_chunk_group_check_names = []
    for idx, chunk in enumerate(node_chunk_groups):
        cname = f"{pfx}_nodeChunkGroup{idx}_check"
        node_chunk_group_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.BookData.checkNodesChunks (K := K) {pfx}_book {pfx}_nodeChunkGroup{idx} = true := by"
        )
        simp_terms = ", ".join(
            ["CertCheck.BookData.checkNodesChunks", f"{pfx}_nodeChunkGroup{idx}"]
            + [f"{name}_check" for name in chunk]
        )
        lines.append(f"  simp only [CertCheck.allShort, {simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_nodeChunkGroups_check :")
    lines.append(
        f"    CertCheck.allShort (fun chunks => CertCheck.BookData.checkNodesChunks (K := K) {pfx}_book chunks) {pfx}_nodeChunkGroups = true := by"
    )
    node_group_simp_terms = ", ".join(
        ["CertCheck.allShort", f"{pfx}_nodeChunkGroups"] + node_chunk_group_check_names
    )
    lines.append(f"  simp only [{node_group_simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_nodeChunks_check :")
    lines.append(
        f"    CertCheck.BookData.checkNodesChunks (K := K) {pfx}_book {pfx}_nodeChunks = true := by"
    )
    lines.append(f"  unfold CertCheck.BookData.checkNodesChunks {pfx}_nodeChunks")
    lines.append("  exact CertCheck.allShort_flatten_true")
    lines.append(
        f"    (fun nodes => CertCheck.allShort (fun S => CertCheck.checkCap (K := K) S) nodes) {pfx}_nodeChunkGroups_check"
    )
    lines.append(f"theorem {pfx}_nodes_check :")
    lines.append(f"    CertCheck.BookData.checkNodes (K := K) {pfx}_book = true := by")
    lines.append(
        f"  exact CertCheck.BookData.checkNodes_of_chunks (K := K) {pfx}_nodeChunks_flatten {pfx}_nodeChunks_check"
    )
    step_data_names = []
    for nid in sorted(rec.nodes):
        local_rows_name = f"{pfx}_node{nid}_rows"
        lines.append(f"def {local_rows_name} : List (CertCheck.RowData K) :=")
        lines.append(
            f"  {anchor_gen.lean_list(rows_by_node[nid], 'CertCheck.RowData K')}"
        )
        step_data_name = f"{pfx}_stepData{nid}"
        step_data_names.append(step_data_name)
        lines.append(f"def {step_data_name} : CertCheck.StepData K where")
        lines.append(f"  node := {pfx}_node{nid}")
        lines.append(f"  rows := {local_rows_name}")
    step_data_chunks = anchor_gen.chunks(step_data_names, STEPDATA_CHUNK_SIZE)
    step_data_chunk_names = []
    for idx, chunk in enumerate(step_data_chunks):
        cname = f"{pfx}_stepDataChunk{idx}"
        step_data_chunk_names.append(cname)
        lines.append(f"def {cname} : List (CertCheck.StepData K) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'CertCheck.StepData K')}")
    step_data_chunk_groups = anchor_gen.chunks(step_data_chunk_names, STEPDATA_CHUNK_GROUP_SIZE)
    step_data_chunk_group_names = []
    for idx, chunk in enumerate(step_data_chunk_groups):
        cname = f"{pfx}_stepDataChunkGroup{idx}"
        step_data_chunk_group_names.append(cname)
        lines.append(f"def {cname} : List (List (CertCheck.StepData K)) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'List (CertCheck.StepData K)')}")
    lines.append(f"def {pfx}_stepDataChunkGroups : List (List (List (CertCheck.StepData K))) :=")
    lines.append(
        f"  {anchor_gen.lean_list(step_data_chunk_group_names, 'List (List (CertCheck.StepData K))')}"
    )
    lines.append(f"def {pfx}_stepDataChunks : List (List (CertCheck.StepData K)) :=")
    lines.append(f"  {pfx}_stepDataChunkGroups.flatten")
    lines.append(f"def {pfx}_stepDataList : List (CertCheck.StepData K) :=")
    lines.append(f"  {pfx}_stepDataChunks.flatten")
    lines.append(f"theorem {pfx}_stepDataChunks_flatten :")
    lines.append(f"    {pfx}_stepDataChunks.flatten = {pfx}_stepDataList := by")
    lines.append("  rfl")
    if len(step_data_chunk_groups) != len(node_chunk_groups):
        raise ValueError(
            f"class {rec.ci}: step-data groups and node groups are not aligned"
        )
    step_data_chunk_group_node_check_names = []
    for idx in range(len(step_data_chunk_groups)):
        cname = f"{pfx}_stepDataChunkGroup{idx}_nodes_check"
        step_data_chunk_group_node_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.BookData.checkStepDataNodeChunks (K := K) {pfx}_stepDataChunkGroup{idx} {pfx}_nodeChunkGroup{idx} = true := by"
        )
        lines.append("  rfl")
    lines.append(f"theorem {pfx}_stepData_nodes_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepDataNodeChunkGroups (K := K) {pfx}_stepDataChunkGroups {pfx}_nodeChunkGroups = true := by"
    )
    step_data_nodes_simp_terms = ", ".join(
        [
            "CertCheck.BookData.checkStepDataNodeChunkGroups",
            f"{pfx}_stepDataChunkGroups",
            f"{pfx}_nodeChunkGroups",
            "Bool.true_and",
        ]
        + step_data_chunk_group_node_check_names
    )
    lines.append(f"  simp only [{step_data_nodes_simp_terms}]")
    lines.append(f"theorem {pfx}_stepData_nodes_eq :")
    lines.append(
        f"    {pfx}_stepDataList.map CertCheck.StepData.node = {pfx}_book.nodes := by"
    )
    lines.append(
        f"  simpa [{pfx}_stepDataList, {pfx}_stepDataChunks, {pfx}_book, {pfx}_nodes, {pfx}_nodeChunks]"
    )
    lines.append(
        f"    using CertCheck.BookData.checkStepDataNodeChunkGroups_sound {pfx}_stepData_nodes_check"
    )
    step_data_chunk_check_names = []
    for idx, _chunk in enumerate(step_data_chunks):
        cname = f"{pfx}_stepDataChunk{idx}_check"
        step_data_chunk_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.BookData.checkStepDataList (K := K) {pfx}_book {pfx}_nodeChunks allCellChunks {pfx}_stepDataChunk{idx} = true := by"
        )
        lines.append("  rfl")
    step_data_chunk_group_check_names = []
    for idx, chunk in enumerate(step_data_chunk_groups):
        cname = f"{pfx}_stepDataChunkGroup{idx}_check"
        step_data_chunk_group_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.BookData.checkStepDataChunks (K := K) {pfx}_book {pfx}_nodeChunks allCellChunks {pfx}_stepDataChunkGroup{idx} = true := by"
        )
        simp_terms = ", ".join(
            ["CertCheck.BookData.checkStepDataChunks", f"{pfx}_stepDataChunkGroup{idx}"]
            + [f"{name}_check" for name in chunk]
        )
        lines.append(f"  simp only [CertCheck.allShort, {simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_stepDataChunkGroups_check :")
    lines.append(
        f"    CertCheck.allShort (fun chunks => CertCheck.BookData.checkStepDataChunks (K := K) {pfx}_book {pfx}_nodeChunks allCellChunks chunks) {pfx}_stepDataChunkGroups = true := by"
    )
    step_data_group_simp_terms = ", ".join(
        ["CertCheck.allShort", f"{pfx}_stepDataChunkGroups"] + step_data_chunk_group_check_names
    )
    lines.append(f"  simp only [{step_data_group_simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_stepDataChunks_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepDataChunks (K := K) {pfx}_book {pfx}_nodeChunks allCellChunks {pfx}_stepDataChunks = true := by"
    )
    lines.append(f"  unfold CertCheck.BookData.checkStepDataChunks {pfx}_stepDataChunks")
    lines.append("  exact CertCheck.allShort_flatten_true")
    lines.append(
        f"    (fun steps => CertCheck.BookData.checkStepDataList (K := K) {pfx}_book {pfx}_nodeChunks allCellChunks steps) {pfx}_stepDataChunkGroups_check"
    )
    lines.append(f"theorem {pfx}_stepDataList_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepDataList (K := K) {pfx}_book {pfx}_nodeChunks allCellChunks {pfx}_stepDataList = true := by"
    )
    lines.append(f"  unfold {pfx}_stepDataList")
    lines.append(
        f"  exact CertCheck.BookData.checkStepDataList_of_chunks (K := K) {pfx}_stepDataChunks_check"
    )
    lines.append(f"theorem {pfx}_book_valid :")
    lines.append(f"    {pfx}_book.toLooseDAG.ValidFor (GridCap (K := K)) := by")
    lines.append(f"  have hcells : ∀ x : GridPoint K, x ∈ {pfx}_book.cells := by")
    lines.append("    intro x")
    lines.append(f"    rw [{pfx}_book_cells_eq]")
    lines.append("    exact allCells_mem x")
    lines.append("  exact CertCheck.BookData.validForLoose_of_stepData (K := K)")
    lines.append(f"    {pfx}_root_mem")
    lines.append(f"    {pfx}_nodes_check")
    lines.append("    hcells")
    lines.append(f"    {pfx}_nodeChunks_flatten")
    lines.append(f"    {pfx}_cellChunks_flatten")
    lines.append(f"    {pfx}_stepData_nodes_eq")
    lines.append(f"    {pfx}_stepDataList_check")
    lines.append(f"theorem {pfx}_valid : {pfx}.Valid := by")
    lines.append(f"  unfold {pfx} CertCheck.ClassData.toLooseCert GridClassCert.Valid")
    lines.append("  refine ⟨?_, ?_, ?_, ?_, ?_⟩")
    lines.append(f"  · exact of_decide_eq_true {pfx}_size_check")
    lines.append(f"  · exact CertCheck.checkCap_sound (K := K) {pfx}_s3_cap_check")
    lines.append(
        f"  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) {pfx}_witness_check)"
    )
    lines.append(f"  · exact of_decide_eq_true {pfx}_root_eq_check")
    lines.append(f"  · exact {pfx}_book_valid")
    lines.extend([
        "",
        f"end {ns}",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def class_split_layout(rec, anchor_gen):
    pfx = class_prefix(rec.ci)
    node_ids = sorted(rec.nodes)
    node_pos = {nid: idx for idx, nid in enumerate(node_ids)}
    node_names = [f"{pfx}_node{nid}" for nid in node_ids]
    node_chunks = anchor_gen.chunks(node_names, NODE_CHUNK_SIZE)
    node_chunk_names = [f"{pfx}_nodeChunk{idx}" for idx in range(len(node_chunks))]
    node_chunk_groups = anchor_gen.chunks(node_chunk_names, NODE_CHUNK_GROUP_SIZE)
    node_chunk_group_names = [
        f"{pfx}_nodeChunkGroup{idx}" for idx in range(len(node_chunk_groups))
    ]

    row_names = []
    rows_by_node = {nid: [] for nid in node_ids}
    row_refs_by_node = {nid: [] for nid in node_ids}
    row_child_ref = {}
    group_span = NODE_CHUNK_GROUP_SIZE * NODE_CHUNK_SIZE
    for ridx, (nid, _mover, _reply, _cid) in enumerate(rec.rows):
        rname = f"{pfx}_row{ridx}"
        refname = f"{pfx}_rowRef{ridx}"
        row_names.append(rname)
        rows_by_node[nid].append(rname)
        row_refs_by_node[nid].append(refname)
        child_pos = node_pos[_cid]
        row_child_ref[rname] = (
            child_pos // group_span,
            (child_pos % group_span) // NODE_CHUNK_SIZE,
            child_pos % NODE_CHUNK_SIZE,
        )
    row_chunks = anchor_gen.chunks(row_names, 4)
    row_chunk_names = [f"{pfx}_rowChunk{idx}" for idx in range(len(row_chunks))]

    step_data_names = [f"{pfx}_stepData{nid}" for nid in node_ids]
    step_data_chunks = anchor_gen.chunks(step_data_names, STEPDATA_CHUNK_SIZE)
    step_data_chunk_names = [
        f"{pfx}_stepDataChunk{idx}" for idx in range(len(step_data_chunks))
    ]
    step_data_chunk_groups = anchor_gen.chunks(
        step_data_chunk_names, STEPDATA_CHUNK_GROUP_SIZE
    )
    step_data_chunk_group_names = [
        f"{pfx}_stepDataChunkGroup{idx}"
        for idx in range(len(step_data_chunk_groups))
    ]
    if len(step_data_chunk_groups) != len(node_chunk_groups):
        raise ValueError(
            f"class {rec.ci}: step-data groups and node groups are not aligned"
        )
    return {
        "node_ids": node_ids,
        "node_pos": node_pos,
        "node_names": node_names,
        "node_chunks": node_chunks,
        "node_chunk_names": node_chunk_names,
        "node_chunk_groups": node_chunk_groups,
        "node_chunk_group_names": node_chunk_group_names,
        "row_names": row_names,
        "rows_by_node": rows_by_node,
        "row_refs_by_node": row_refs_by_node,
        "row_child_ref": row_child_ref,
        "row_chunks": row_chunks,
        "row_chunk_names": row_chunk_names,
        "step_data_names": step_data_names,
        "step_data_chunks": step_data_chunks,
        "step_data_chunk_names": step_data_chunk_names,
        "step_data_chunk_groups": step_data_chunk_groups,
        "step_data_chunk_group_names": step_data_chunk_group_names,
    }


def emit_class_base(q: int, rec, anchor_gen, layout) -> str:
    ns = f"Q{q}"
    pfx = class_prefix(rec.ci)
    witness_term = f"({anchor_gen.lean_point(rec.witness)})"
    node_chunks = layout["node_chunks"]
    node_chunk_groups = layout["node_chunk_groups"]
    node_chunk_names = layout["node_chunk_names"]
    node_chunk_group_names = layout["node_chunk_group_names"]
    row_chunks = layout["row_chunks"]
    row_chunk_names = layout["row_chunk_names"]

    lines: list[str] = [
        f"import ProjectiveCap.CertData.{ns}.Base",
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        f"namespace {ns}",
        "",
    ]
    lines.append(f"def {pfx}_s3 : List P :=")
    lines.append(f"  {anchor_gen.lean_list([anchor_gen.lean_point(c) for c in rec.s3], 'P')}")
    for nid in layout["node_ids"]:
        lines.append(f"def {pfx}_node{nid} : List P :=")
        lines.append(f"  {anchor_gen.lean_list([anchor_gen.lean_point(c) for c in rec.nodes[nid]], 'P')}")
    for idx, chunk in enumerate(node_chunks):
        lines.append(f"def {pfx}_nodeChunk{idx} : List (List P) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'List P')}")
    for idx, chunk in enumerate(node_chunk_groups):
        lines.append(f"def {pfx}_nodeChunkGroup{idx} : List (List (List P)) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'List (List P)')}")
    lines.append(f"def {pfx}_nodeChunkGroups : List (List (List (List P))) :=")
    lines.append(f"  {anchor_gen.lean_list(node_chunk_group_names, 'List (List (List P))')}")
    lines.append(f"def {pfx}_nodeChunks : List (List (List P)) :=")
    lines.append(f"  {pfx}_nodeChunkGroups.flatten")
    lines.append(f"def {pfx}_nodes : List (List P) :=")
    lines.append(f"  {pfx}_nodeChunks.flatten")

    for ridx, (nid, mover, reply, cid) in enumerate(rec.rows):
        rname = f"{pfx}_row{ridx}"
        lines.append(f"def {rname} : CertCheck.RowData K where")
        lines.append(f"  node := {pfx}_node{nid}")
        lines.append(f"  mover := {anchor_gen.lean_point(mover)}")
        lines.append(f"  reply := {anchor_gen.lean_point(reply)}")
        lines.append(f"  child := {pfx}_node{cid}")
    for idx, chunk in enumerate(row_chunks):
        lines.append(f"def {pfx}_rowChunk{idx} : List (CertCheck.RowData K) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'CertCheck.RowData K')}")
    lines.append(f"def {pfx}_rowChunks : List (List (CertCheck.RowData K)) :=")
    lines.append(f"  {anchor_gen.lean_list(row_chunk_names, 'List (CertCheck.RowData K)')}")
    lines.append(f"def {pfx}_rows : List (CertCheck.RowData K) :=")
    lines.append(f"  {pfx}_rowChunks.flatten")
    lines.append(f"def {pfx}_book : CertCheck.BookData K where")
    lines.append("  cells := allCells")
    lines.append(f"  root := {pfx}_node0")
    lines.append(f"  nodes := {pfx}_nodes")
    lines.append(f"  rows := {pfx}_rows")
    lines.append(f"theorem {pfx}_nodeChunks_flatten : {pfx}_nodeChunks.flatten = {pfx}_book.nodes := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_rowChunks_flatten : {pfx}_rowChunks.flatten = {pfx}_book.rows := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_cellChunks_flatten : allCellChunks.flatten = {pfx}_book.cells := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_book_cells_eq : {pfx}_book.cells = allCells := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_book_nodes_eq : {pfx}_book.nodes = {pfx}_nodes := by")
    lines.append("  rfl")
    lines.append(f"def {pfx}_data : CertCheck.ClassData K where")
    lines.append(f"  classIndex := {rec.ci}")
    lines.append(f"  sizeThree := {pfx}_s3")
    lines.append(f"  witness := {anchor_gen.lean_point(rec.witness)}")
    lines.append(f"  book := {pfx}_book")
    lines.append(f"def {pfx} : GridClassCert K :=")
    lines.append(f"  {pfx}_data.toLooseCert")
    lines.append(f"theorem {pfx}_size_check :")
    lines.append(f"    decide ({pfx}_s3.toFinset.card = 3) = true := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_s3_cap_check :")
    lines.append(f"    CertCheck.checkCap (K := K) {pfx}_s3 = true := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_witness_check :")
    lines.append(f"    CertCheck.checkMove (K := K) {pfx}_s3 {witness_term} = true := by")
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_root_eq_check :")
    lines.append(
        f"    decide ({pfx}_book.root.toFinset = insert {witness_term} {pfx}_s3.toFinset) = true := by"
    )
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_root_node_check :")
    lines.append(
        f"    CertCheck.BookData.checkNodeMemberChunks (K := K) {pfx}_book.root.toFinset {pfx}_nodeChunks = true := by"
    )
    lines.append("  rfl")
    lines.append(f"theorem {pfx}_root_mem : {pfx}_book.root.toFinset ∈ {pfx}_book.nodesFinset := by")
    lines.append(
        f"  exact CertCheck.BookData.checkNodeMember_of_chunks (K := K) {pfx}_nodeChunks_flatten {pfx}_root_node_check"
    )

    lines.extend([
        "",
        f"end {ns}",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def emit_class_node_group(q: int, rec, anchor_gen, layout, group_idx: int) -> str:
    ns = f"Q{q}"
    pfx = class_prefix(rec.ci)
    chunk_names = layout["node_chunk_groups"][group_idx]
    chunk_indices = [
        int(name.removeprefix(f"{pfx}_nodeChunk")) for name in chunk_names
    ]
    lines: list[str] = [
        f"import ProjectiveCap.CertData.{ns}.Class{rec.ci}Base",
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        f"namespace {ns}",
        "",
    ]
    for chunk_idx in chunk_indices:
        chunk = layout["node_chunks"][chunk_idx]
        for node_name in chunk:
            nid = int(node_name.removeprefix(f"{pfx}_node"))
            lines.append(f"theorem {pfx}_node{nid}_cap_check :")
            lines.append(f"    CertCheck.checkCap (K := K) {pfx}_node{nid} = true := by")
            lines.append("  rfl")
        lines.append(f"theorem {pfx}_nodeChunk{chunk_idx}_check :")
        lines.append(
            f"    CertCheck.allShort (fun S => CertCheck.checkCap (K := K) S) {pfx}_nodeChunk{chunk_idx} = true := by"
        )
        chunk_node_ids = [name.removeprefix(f"{pfx}_node") for name in chunk]
        simp_terms = ", ".join(
            [f"{pfx}_nodeChunk{chunk_idx}"]
            + [f"{pfx}_node{nid}_cap_check" for nid in chunk_node_ids]
        )
        lines.append(f"  simp only [CertCheck.allShort, {simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_nodeChunkGroup{group_idx}_check :")
    lines.append(
        f"    CertCheck.BookData.checkNodesChunks (K := K) {pfx}_book {pfx}_nodeChunkGroup{group_idx} = true := by"
    )
    simp_terms = ", ".join(
        ["CertCheck.BookData.checkNodesChunks", f"{pfx}_nodeChunkGroup{group_idx}"]
        + [f"{name}_check" for name in chunk_names]
    )
    lines.append(f"  simp only [CertCheck.allShort, {simp_terms}, reduceIte]")
    lines.extend([
        "",
        f"end {ns}",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def emit_class_step_group(q: int, rec, anchor_gen, layout, group_idx: int) -> str:
    ns = f"Q{q}"
    pfx = class_prefix(rec.ci)
    chunk_names = layout["step_data_chunk_groups"][group_idx]
    chunk_indices = [
        int(name.removeprefix(f"{pfx}_stepDataChunk")) for name in chunk_names
    ]
    group_nids: list[int] = []
    for chunk_idx in chunk_indices:
        for step_name in layout["step_data_chunks"][chunk_idx]:
            group_nids.append(int(step_name.removeprefix(f"{pfx}_stepData")))

    lines: list[str] = [
        f"import ProjectiveCap.CertData.{ns}.Class{rec.ci}Base",
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        f"namespace {ns}",
        "",
    ]
    for nid in group_nids:
        local_rows_name = f"{pfx}_node{nid}_rows"
        for rname in layout["rows_by_node"][nid]:
            ridx = rname.removeprefix(f"{pfx}_row")
            refname = f"{pfx}_rowRef{ridx}"
            child_group, child_chunk, child_slot = layout["row_child_ref"][rname]
            lines.append(f"def {refname} : CertCheck.RowRefData K where")
            lines.append(f"  row := {rname}")
            lines.append(f"  childGroup := {child_group}")
            lines.append(f"  childChunk := {child_chunk}")
            lines.append(f"  childSlot := {child_slot}")
        lines.append(f"def {local_rows_name} : List (CertCheck.RowRefData K) :=")
        lines.append(
            f"  {anchor_gen.lean_list(layout['row_refs_by_node'][nid], 'CertCheck.RowRefData K')}"
        )
        step_data_name = f"{pfx}_stepData{nid}"
        lines.append(f"def {step_data_name} : CertCheck.StepRefData K where")
        lines.append(f"  node := {pfx}_node{nid}")
        lines.append(f"  rows := {local_rows_name}")
    for chunk_idx in chunk_indices:
        lines.append(f"def {pfx}_stepDataChunk{chunk_idx} : List (CertCheck.StepRefData K) :=")
        lines.append(
            f"  {anchor_gen.lean_list(layout['step_data_chunks'][chunk_idx], 'CertCheck.StepRefData K')}"
        )

    subgroup_chunks = anchor_gen.chunks(chunk_names, STEPDATA_SUBGROUP_SIZE)
    subgroup_names = []
    subgroup_node_group_terms = []
    subgroup_node_check_names = []
    for sub_idx, subgroup in enumerate(subgroup_chunks):
        sub_name = f"{pfx}_stepDataChunkGroup{group_idx}_subgroup{sub_idx}"
        subgroup_names.append(sub_name)
        first_chunk_idx = int(subgroup[0].removeprefix(f"{pfx}_stepDataChunk"))
        node_chunk_idx = first_chunk_idx // NODE_CHUNK_SIZE
        node_group_term = f"([{pfx}_nodeChunk{node_chunk_idx}] : List (List (List P)))"
        subgroup_node_group_terms.append(node_group_term)
        lines.append(f"def {sub_name} : List (List (CertCheck.StepRefData K)) :=")
        lines.append(
            f"  {anchor_gen.lean_list(subgroup, 'List (CertCheck.StepRefData K)')}"
        )
        cname = f"{sub_name}_nodes_check"
        subgroup_node_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.BookData.checkStepRefDataNodeChunks (K := K) {sub_name} {node_group_term} = true := by"
        )
        lines.append("  rfl")
    lines.append(
        f"def {pfx}_stepDataChunkGroup{group_idx}_subgroups : List (List (List (CertCheck.StepRefData K))) :="
    )
    lines.append(
        f"  {anchor_gen.lean_list(subgroup_names, 'List (List (CertCheck.StepRefData K))')}"
    )
    lines.append(
        f"def {pfx}_nodeChunkGroup{group_idx}_subgroups : List (List (List (List P))) :="
    )
    lines.append(
        f"  {anchor_gen.lean_list(subgroup_node_group_terms, 'List (List (List P))')}"
    )
    lines.append(f"def {pfx}_stepDataChunkGroup{group_idx} : List (List (CertCheck.StepRefData K)) :=")
    lines.append(f"  {pfx}_stepDataChunkGroup{group_idx}_subgroups.flatten")
    lines.append(f"theorem {pfx}_stepDataChunkGroup{group_idx}_nodeSubgroups_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepRefDataNodeChunkGroups (K := K) {pfx}_stepDataChunkGroup{group_idx}_subgroups {pfx}_nodeChunkGroup{group_idx}_subgroups = true := by"
    )
    node_subgroups_simp_terms = ", ".join(
        [
            "CertCheck.BookData.checkStepRefDataNodeChunkGroups",
            f"{pfx}_stepDataChunkGroup{group_idx}_subgroups",
            f"{pfx}_nodeChunkGroup{group_idx}_subgroups",
            "Bool.and_true",
        ]
        + subgroup_node_check_names
    )
    lines.append(f"  simp only [{node_subgroups_simp_terms}]")
    lines.append(f"theorem {pfx}_stepDataChunkGroup{group_idx}_nodes_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepRefDataNodeChunks (K := K) {pfx}_stepDataChunkGroup{group_idx} {pfx}_nodeChunkGroup{group_idx} = true := by"
    )
    lines.append("  exact CertCheck.BookData.checkStepRefDataNodeChunks_of_groups (K := K)")
    lines.append(
        f"    (show {pfx}_stepDataChunkGroup{group_idx}_subgroups.flatten = {pfx}_stepDataChunkGroup{group_idx} by rfl)"
    )
    lines.append(
        f"    (show {pfx}_nodeChunkGroup{group_idx}_subgroups.flatten = {pfx}_nodeChunkGroup{group_idx} by rfl)"
    )
    lines.append(f"    {pfx}_stepDataChunkGroup{group_idx}_nodeSubgroups_check")
    chunk_check_names = []
    for chunk_idx in chunk_indices:
        cname = f"{pfx}_stepDataChunk{chunk_idx}_check"
        chunk_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.BookData.checkStepRefDataList (K := K) {pfx}_nodeChunkGroups allCellChunks {pfx}_stepDataChunk{chunk_idx} = true := by"
        )
        lines.append("  rfl")
    subgroup_check_names = []
    for sub_idx, subgroup in enumerate(subgroup_chunks):
        sub_name = f"{pfx}_stepDataChunkGroup{group_idx}_subgroup{sub_idx}"
        cname = f"{sub_name}_check"
        subgroup_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.BookData.checkStepRefDataChunks (K := K) {pfx}_nodeChunkGroups allCellChunks {sub_name} = true := by"
        )
        simp_terms = ", ".join(
            ["CertCheck.BookData.checkStepRefDataChunks", sub_name]
            + [f"{name}_check" for name in subgroup]
        )
        lines.append(f"  simp only [CertCheck.allShort, {simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_stepDataChunkGroup{group_idx}_subgroups_check :")
    lines.append(
        f"    CertCheck.allShort (fun chunks => CertCheck.BookData.checkStepRefDataChunks (K := K) {pfx}_nodeChunkGroups allCellChunks chunks) {pfx}_stepDataChunkGroup{group_idx}_subgroups = true := by"
    )
    subgroups_simp_terms = ", ".join(
        ["CertCheck.allShort", f"{pfx}_stepDataChunkGroup{group_idx}_subgroups"]
        + subgroup_check_names
    )
    lines.append(f"  simp only [{subgroups_simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_stepDataChunkGroup{group_idx}_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepRefDataChunks (K := K) {pfx}_nodeChunkGroups allCellChunks {pfx}_stepDataChunkGroup{group_idx} = true := by"
    )
    lines.append(f"  unfold CertCheck.BookData.checkStepRefDataChunks {pfx}_stepDataChunkGroup{group_idx}")
    lines.append("  exact CertCheck.allShort_flatten_true")
    lines.append(
        f"    (fun steps => CertCheck.BookData.checkStepRefDataList (K := K) {pfx}_nodeChunkGroups allCellChunks steps) {pfx}_stepDataChunkGroup{group_idx}_subgroups_check"
    )
    lines.extend([
        "",
        f"end {ns}",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def emit_class_top(q: int, rec, anchor_gen, layout) -> str:
    ns = f"Q{q}"
    pfx = class_prefix(rec.ci)
    group_names = layout["step_data_chunk_group_names"]
    node_group_names = layout["node_chunk_group_names"]
    imports = [f"import ProjectiveCap.CertData.{ns}.Class{rec.ci}Base"]
    imports.extend(
        f"import ProjectiveCap.CertData.{ns}.Class{rec.ci}NodeGroup{idx}"
        for idx in range(len(node_group_names))
    )
    imports.extend(
        f"import ProjectiveCap.CertData.{ns}.Class{rec.ci}StepGroup{idx}"
        for idx in range(len(group_names))
    )
    lines: list[str] = [
        *imports,
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        f"namespace {ns}",
        "",
    ]
    node_chunk_group_check_names = [
        f"{pfx}_nodeChunkGroup{idx}_check" for idx in range(len(node_group_names))
    ]
    lines.append(f"theorem {pfx}_nodeChunkGroups_check :")
    lines.append(
        f"    CertCheck.allShort (fun chunks => CertCheck.BookData.checkNodesChunks (K := K) {pfx}_book chunks) {pfx}_nodeChunkGroups = true := by"
    )
    node_group_simp_terms = ", ".join(
        ["CertCheck.allShort", f"{pfx}_nodeChunkGroups"] + node_chunk_group_check_names
    )
    lines.append(f"  simp only [{node_group_simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_nodeChunks_check :")
    lines.append(
        f"    CertCheck.BookData.checkNodesChunks (K := K) {pfx}_book {pfx}_nodeChunks = true := by"
    )
    lines.append(f"  unfold CertCheck.BookData.checkNodesChunks {pfx}_nodeChunks")
    lines.append("  exact CertCheck.allShort_flatten_true")
    lines.append(
        f"    (fun nodes => CertCheck.allShort (fun S => CertCheck.checkCap (K := K) S) nodes) {pfx}_nodeChunkGroups_check"
    )
    lines.append(f"theorem {pfx}_nodes_check :")
    lines.append(f"    CertCheck.BookData.checkNodes (K := K) {pfx}_book = true := by")
    lines.append(
        f"  exact CertCheck.BookData.checkNodes_of_chunks (K := K) {pfx}_nodeChunks_flatten {pfx}_nodeChunks_check"
    )
    lines.append("")
    lines.append(f"def {pfx}_stepDataChunkGroups : List (List (List (CertCheck.StepRefData K))) :=")
    lines.append(
        f"  {anchor_gen.lean_list(group_names, 'List (List (CertCheck.StepRefData K))')}"
    )
    lines.append(f"def {pfx}_stepDataChunks : List (List (CertCheck.StepRefData K)) :=")
    lines.append(f"  {pfx}_stepDataChunkGroups.flatten")
    lines.append(f"def {pfx}_stepDataList : List (CertCheck.StepRefData K) :=")
    lines.append(f"  {pfx}_stepDataChunks.flatten")
    lines.append(f"theorem {pfx}_stepDataChunks_flatten :")
    lines.append(f"    {pfx}_stepDataChunks.flatten = {pfx}_stepDataList := by")
    lines.append("  rfl")
    group_node_checks = [
        f"{pfx}_stepDataChunkGroup{idx}_nodes_check" for idx in range(len(group_names))
    ]
    lines.append(f"theorem {pfx}_stepData_nodes_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepRefDataNodeChunkGroups (K := K) {pfx}_stepDataChunkGroups {pfx}_nodeChunkGroups = true := by"
    )
    step_data_nodes_simp_terms = ", ".join(
        [
            "CertCheck.BookData.checkStepRefDataNodeChunkGroups",
            f"{pfx}_stepDataChunkGroups",
            f"{pfx}_nodeChunkGroups",
            "Bool.true_and",
        ]
        + group_node_checks
    )
    lines.append(f"  simp only [{step_data_nodes_simp_terms}]")
    lines.append(f"theorem {pfx}_stepData_nodes_eq :")
    lines.append(
        f"    {pfx}_stepDataList.map CertCheck.StepRefData.node = {pfx}_book.nodes := by"
    )
    lines.append(
        f"  simpa [{pfx}_stepDataList, {pfx}_stepDataChunks, {pfx}_book, {pfx}_nodes, {pfx}_nodeChunks]"
    )
    lines.append(
        f"    using CertCheck.BookData.checkStepRefDataNodeChunkGroups_sound {pfx}_stepData_nodes_check"
    )
    group_checks = [
        f"{pfx}_stepDataChunkGroup{idx}_check" for idx in range(len(group_names))
    ]
    lines.append(f"theorem {pfx}_stepDataChunkGroups_check :")
    lines.append(
        f"    CertCheck.allShort (fun chunks => CertCheck.BookData.checkStepRefDataChunks (K := K) {pfx}_nodeChunkGroups allCellChunks chunks) {pfx}_stepDataChunkGroups = true := by"
    )
    step_data_group_simp_terms = ", ".join(
        ["CertCheck.allShort", f"{pfx}_stepDataChunkGroups"] + group_checks
    )
    lines.append(f"  simp only [{step_data_group_simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_stepDataChunks_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepRefDataChunks (K := K) {pfx}_nodeChunkGroups allCellChunks {pfx}_stepDataChunks = true := by"
    )
    lines.append(f"  unfold CertCheck.BookData.checkStepRefDataChunks {pfx}_stepDataChunks")
    lines.append("  exact CertCheck.allShort_flatten_true")
    lines.append(
        f"    (fun steps => CertCheck.BookData.checkStepRefDataList (K := K) {pfx}_nodeChunkGroups allCellChunks steps) {pfx}_stepDataChunkGroups_check"
    )
    lines.append(f"theorem {pfx}_stepDataList_check :")
    lines.append(
        f"    CertCheck.BookData.checkStepRefDataList (K := K) {pfx}_nodeChunkGroups allCellChunks {pfx}_stepDataList = true := by"
    )
    lines.append(f"  unfold {pfx}_stepDataList")
    lines.append(
        f"  exact CertCheck.BookData.checkStepRefDataList_of_chunks (K := K) {pfx}_stepDataChunks_check"
    )
    lines.append(f"theorem {pfx}_book_valid :")
    lines.append(f"    {pfx}_book.toLooseDAG.ValidFor (GridCap (K := K)) := by")
    lines.append(f"  have hcells : ∀ x : GridPoint K, x ∈ {pfx}_book.cells := by")
    lines.append("    intro x")
    lines.append(f"    rw [{pfx}_book_cells_eq]")
    lines.append("    exact allCells_mem x")
    lines.append("  exact CertCheck.BookData.validForLoose_of_stepRefData (K := K)")
    lines.append(f"    {pfx}_root_mem")
    lines.append(f"    {pfx}_nodes_check")
    lines.append("    hcells")
    lines.append(f"    (by simpa [{pfx}_nodeChunks] using {pfx}_nodeChunks_flatten)")
    lines.append(f"    {pfx}_cellChunks_flatten")
    lines.append(f"    {pfx}_stepData_nodes_eq")
    lines.append(f"    {pfx}_stepDataList_check")
    lines.append(f"theorem {pfx}_valid : {pfx}.Valid := by")
    lines.append(f"  unfold {pfx} CertCheck.ClassData.toLooseCert GridClassCert.Valid")
    lines.append("  refine ⟨?_, ?_, ?_, ?_, ?_⟩")
    lines.append(f"  · exact of_decide_eq_true {pfx}_size_check")
    lines.append(f"  · exact CertCheck.checkCap_sound (K := K) {pfx}_s3_cap_check")
    lines.append(
        f"  · exact GridGame.mem_legalExtensions.mpr (CertCheck.checkMove_sound (K := K) {pfx}_witness_check)"
    )
    lines.append(f"  · exact of_decide_eq_true {pfx}_root_eq_check")
    lines.append(f"  · exact {pfx}_book_valid")
    lines.extend([
        "",
        f"end {ns}",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def emit_class_files(q: int, rec, anchor_gen) -> dict[str, str]:
    layout = class_split_layout(rec, anchor_gen)
    files = {
        f"Class{rec.ci}Base.lean": emit_class_base(q, rec, anchor_gen, layout),
        f"Class{rec.ci}.lean": emit_class_top(q, rec, anchor_gen, layout),
    }
    for idx in range(len(layout["node_chunk_group_names"])):
        files[f"Class{rec.ci}NodeGroup{idx}.lean"] = emit_class_node_group(
            q, rec, anchor_gen, layout, idx
        )
    for idx in range(len(layout["step_data_chunk_group_names"])):
        files[f"Class{rec.ci}StepGroup{idx}.lean"] = emit_class_step_group(
            q, rec, anchor_gen, layout, idx
        )
    return files


def emit_aggregator(q: int, classes) -> str:
    lines = [f"import ProjectiveCap.CertData.Q{q}.Class{rec.ci}" for rec in classes]
    lines.append("")
    return "\n".join(lines)


def kterm(n: int) -> str:
    return f"({n} : K)"


def symmetry_name(a: int, b: int) -> str:
    return f"canonicalSymmetry_{a}_{b}"


def axis_affine_term(t: CanonicalTransport) -> str:
    return (
        "ConicLocalization.axisAffine (K := K) "
        f"{kterm(t.row_scale)} {kterm(t.row_shift)} "
        f"{kterm(t.col_scale)} {kterm(t.col_shift)}"
    )


def axis_affine_grid_symmetry_lines(t: CanonicalTransport) -> list[str]:
    return [
        "  exact ConicLocalization.axisAffine_gridSymmetry (K := K)",
        f"    (rowScale := {kterm(t.row_scale)}) (rowShift := {kterm(t.row_shift)})",
        f"    (colScale := {kterm(t.col_scale)}) (colShift := {kterm(t.col_shift)})",
        "    (by decide) (by decide)",
    ]


def emit_invalid_theorems(q: int, valid_cells: set[tuple[int, int]]) -> list[str]:
    invalid_cells = [
        (a, b) for a in range(q) for b in range(q) if (a, b) not in valid_cells
    ]

    def pt(cell: tuple[int, int]) -> str:
        return f"pt {cell[0]} {cell[1]}"

    def anchored_set(a: int, b: int) -> str:
        return f"({{pt 0 0, pt 1 1, {pt((a, b))}}} : Finset P)"

    lines: list[str] = []
    for a, b in invalid_cells:
        aset = anchored_set(a, b)
        kind = invalid_kind(a, b)
        card_binder = "hcard" if kind == "card" else "_hcard"
        cap_binder = "_hcap" if kind == "card" else "hcap"
        lines.extend([
            f"theorem {invalid_name(a, b)}",
            f"    ({card_binder} : {aset}.card = 3)",
            f"    ({cap_binder} : GridCap (K := K) {aset}) : False := by",
        ])
        if kind == "card":
            lines.append(f"  exact (by decide : ¬ ({aset}.card = 3)) hcard")
        elif kind in {"row0", "row1"}:
            ref = (0, 0) if kind == "row0" else (1, 1)
            lines.extend([
                f"  have hp : {pt(ref)} ∈ {aset} := by simp",
                f"  have hx : {pt((a, b))} ∈ {aset} := by simp",
                f"  have hrow : ({pt(ref)}).1 = ({pt((a, b))}).1 := by norm_num [pt]",
                "  have heq := hcap.1.1 hp hx hrow",
                f"  exact (by decide : {pt(ref)} ≠ {pt((a, b))}) heq",
            ])
        elif kind in {"col0", "col1"}:
            ref = (0, 0) if kind == "col0" else (1, 1)
            lines.extend([
                f"  have hp : {pt(ref)} ∈ {aset} := by simp",
                f"  have hx : {pt((a, b))} ∈ {aset} := by simp",
                f"  have hcol : ({pt(ref)}).2 = ({pt((a, b))}).2 := by norm_num [pt]",
                "  have heq := hcap.1.2 hp hx hcol",
                f"  exact (by decide : {pt(ref)} ≠ {pt((a, b))}) heq",
            ])
        elif kind == "diag":
            lines.extend([
                f"  have hp0 : pt 0 0 ∈ {aset} := by simp",
                f"  have hp1 : pt 1 1 ∈ {aset} := by simp",
                f"  have hx : {pt((a, b))} ∈ {aset} := by simp",
                "  have h01 : pt 0 0 ≠ pt 1 1 := by decide",
                f"  have h0x : pt 0 0 ≠ {pt((a, b))} := by decide",
                f"  have h1x : pt 1 1 ≠ {pt((a, b))} := by decide",
                f"  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) ({pt((a, b))}) := by",
                "    norm_num [Collinear, pt]",
                "  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol",
            ])
        lines.append("")
    return lines


def emit_canonical_assembly(q: int, classes, anchor_gen) -> str:
    ns = f"Q{q}"
    transports = canonical_transports(q, classes)
    valid_cells = set(transports)
    by_row: dict[int, list[tuple[int, CanonicalTransport]]] = {}
    for (a, b), t in transports.items():
        by_row.setdefault(a, []).append((b, t))

    def pt(cell: tuple[int, int]) -> str:
        return f"pt {cell[0]} {cell[1]}"

    def anchored_set(a: int, b: int) -> str:
        return f"({{pt 0 0, pt 1 1, {pt((a, b))}}} : Finset P)"

    lines: list[str] = [
        f"import ProjectiveCap.CertData.{ns}",
        "import ProjectiveCap.PlaneOutcome",
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        f"namespace {ns}",
        "",
        "set_option maxHeartbeats 4000000",
        "set_option linter.unusedTactic false",
        "set_option linter.unreachableTactic false",
        "",
    ]
    for rec in classes:
        a, b = rec.s3[2]
        lines.extend([
            f"theorem class{rec.ci}_sizeThree_eq :",
            f"    class{rec.ci}.sizeThree = ({{pt 0 0, pt 1 1, {pt((a, b))}}} : Finset P) := by",
            "  rfl",
        ])
    lines.append("")
    lines.extend([
        "def defaultSymmetry : P -> P :=",
        "  ConicLocalization.axisAffine (K := K) (1 : K) (0 : K) (1 : K) (0 : K)",
        "",
        "theorem defaultSymmetry_gridSymmetry :",
        "    ConicLocalization.GridSymmetry (K := K) defaultSymmetry := by",
        "  unfold defaultSymmetry",
    ])
    lines.extend(axis_affine_grid_symmetry_lines(
        CanonicalTransport((0, 0), 0, (0, 0), False, 1, 0, 1, 0)
    ))
    lines.append("")
    for a, b in sorted(transports):
        t = transports[(a, b)]
        name = symmetry_name(a, b)
        if t.swap:
            lines.extend([
                f"def {name} : P -> P :=",
                f"  fun p => {axis_affine_term(t)} (ConicLocalization.coordSwap (K := K) p)",
                "",
                f"theorem {name}_gridSymmetry :",
                f"    ConicLocalization.GridSymmetry (K := K) {name} := by",
                f"  unfold {name}",
                "  exact ConicLocalization.gridSymmetry_comp (K := K)",
                "    (ConicLocalization.coordSwap_gridSymmetry (K := K))",
                "    (ConicLocalization.axisAffine_gridSymmetry (K := K)",
                f"      (rowScale := {kterm(t.row_scale)}) (rowShift := {kterm(t.row_shift)})",
                f"      (colScale := {kterm(t.col_scale)}) (colShift := {kterm(t.col_shift)})",
                "      (by decide) (by decide))",
            ])
        else:
            lines.extend([
                f"def {name} : P -> P :=",
                f"  {axis_affine_term(t)}",
                "",
                f"theorem {name}_gridSymmetry :",
                f"    ConicLocalization.GridSymmetry (K := K) {name} := by",
                f"  unfold {name}",
            ])
            lines.extend(axis_affine_grid_symmetry_lines(t))
        lines.extend([
            "",
            f"theorem {name}_image :",
            f"    class{t.ci}.sizeThree = {anchored_set(a, b)}.image {name} := by",
            f"  rw [class{t.ci}_sizeThree_eq]",
            "  decide",
            "",
        ])

    lines.extend([
        "def classForThird (x : P) : GridClassCert K :=",
    ])
    for a in sorted(by_row):
        lines.append(f"  if x.1 = ({a} : K) then")
        for b, t in sorted(by_row[a]):
            lines.append(f"    if x.2 = ({b} : K) then class{t.ci} else")
        lines.append("    class0")
        lines.append("  else")
    lines.append("  class0")
    lines.append("")
    lines.extend([
        "def symmetryForThird (x : P) : P -> P :=",
    ])
    for a in sorted(by_row):
        lines.append(f"  if x.1 = ({a} : K) then")
        for b, _t in sorted(by_row[a]):
            lines.append(f"    if x.2 = ({b} : K) then {symmetry_name(a, b)} else")
        lines.append("    defaultSymmetry")
        lines.append("  else")
    lines.append("  defaultSymmetry")
    lines.append("")
    for a in range(q):
        row_classes = sorted({transports[(a, b)].ci for b in range(q) if (a, b) in transports} | {0})
        lines.extend([
            f"theorem classForThird_valid_row{a} (c : K) :",
            f"    (classForThird (({a} : K), c)).Valid := by",
            "  fin_cases c",
            "  all_goals",
            "    first",
        ])
        for ci in row_classes:
            lines.extend([
                f"    | change class{ci}.Valid",
                f"      exact class{ci}_valid",
            ])
        lines.append("")
    lines.extend([
        "theorem classForThird_valid (x : P) : (classForThird x).Valid := by",
        "  rcases x with ⟨r, c⟩",
        "  fin_cases r",
        "  all_goals",
        "    first",
    ])
    for a in range(q):
        lines.extend([
            f"    | exact classForThird_valid_row{a} c",
        ])
    lines.append("")
    for a in range(q):
        row_cells = sorted((b, transports[(a, b)]) for b in range(q) if (a, b) in transports)
        lines.extend([
            f"theorem symmetryForThird_gridSymmetry_row{a} (c : K) :",
            f"    ConicLocalization.GridSymmetry (K := K) (symmetryForThird (({a} : K), c)) := by",
            "  fin_cases c",
            "  all_goals",
            "    first",
        ])
        for b, _t in row_cells:
            name = symmetry_name(a, b)
            lines.extend([
                f"    | change ConicLocalization.GridSymmetry (K := K) {name}",
                f"      exact {name}_gridSymmetry",
            ])
        lines.extend([
            "    | change ConicLocalization.GridSymmetry (K := K) defaultSymmetry",
            "      exact defaultSymmetry_gridSymmetry",
            "",
        ])
    lines.extend([
        "theorem symmetryForThird_gridSymmetry (x : P) :",
        "    ConicLocalization.GridSymmetry (K := K) (symmetryForThird x) := by",
        "  rcases x with ⟨r, c⟩",
        "  fin_cases r",
        "  all_goals",
        "    first",
    ])
    for a in range(q):
        lines.extend([
            f"    | exact symmetryForThird_gridSymmetry_row{a} c",
        ])
    lines.append("")
    lines.extend(emit_invalid_theorems(q, valid_cells))
    for a in range(q):
        row_cells = sorted((b, transports[(a, b)]) for b in range(q) if (a, b) in transports)
        lines.extend([
            f"theorem classForThird_sizeThree_image_row{a} (c : K)",
            f"    (hcard : ({{pt 0 0, pt 1 1, (({a} : K), c)}} : Finset P).card = 3)",
            f"    (hcap : GridCap (K := K) ({{pt 0 0, pt 1 1, (({a} : K), c)}} : Finset P)) :",
            f"    (classForThird (({a} : K), c)).sizeThree =",
            f"      ({{pt 0 0, pt 1 1, (({a} : K), c)}} : Finset P).image",
            f"        (symmetryForThird (({a} : K), c)) := by",
            "  fin_cases c",
            "  all_goals",
            "    first",
        ])
        for b, t in row_cells:
            name = symmetry_name(a, b)
            lines.extend([
                f"    | change class{t.ci}.sizeThree = {anchored_set(a, b)}.image {name}",
                f"      exact {name}_image",
            ])
        for b in range(q):
            if (a, b) in valid_cells:
                continue
            lines.extend([
                "    | exfalso",
                f"      exact {invalid_name(a, b)} hcard hcap",
            ])
        lines.append("")
    lines.extend([
        "theorem classForThird_sizeThree_image_of_gridCap (x : P)",
        "    (hcard : ({pt 0 0, pt 1 1, x} : Finset P).card = 3)",
        "    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, x} : Finset P)) :",
        "    (classForThird x).sizeThree =",
        "      ({pt 0 0, pt 1 1, x} : Finset P).image (symmetryForThird x) := by",
        "  rcases x with ⟨r, c⟩",
        "  fin_cases r",
        "  all_goals",
        "    first",
    ])
    for a in range(q):
        lines.extend([
            f"    | exact classForThird_sizeThree_image_row{a} c hcard hcap",
        ])
    lines.extend([
        "",
        "structure TransportWitness (S : Finset P) where",
        "  classCert : GridClassCert K",
        "  symmetry : P -> P",
        "  gridSymmetry : ConicLocalization.GridSymmetry (K := K) symmetry",
        "  valid : classCert.Valid",
        "  representsImage : classCert.sizeThree = S.image symmetry",
        "",
        "theorem exists_transportWitness (S : Finset P) (hcard : S.card = 3)",
        "    (hcap : GridCap (K := K) S) : Nonempty (TransportWitness S) := by",
        "  classical",
        "  rcases (Finset.card_eq_three.mp hcard) with ⟨p, q, r, hpq, hpr, hqr, hS⟩",
        "  have hp : p ∈ S := by simp [hS]",
        "  have hq : q ∈ S := by simp [hS]",
        "  have hr : r ∈ S := by simp [hS]",
        "  have hrow : q.1 - p.1 ≠ 0 :=",
        "    ConicLocalization.gridCap_row_ne_of_ne (K := K) hcap hp hq hpq",
        "  have hcol : q.2 - p.2 ≠ 0 :=",
        "    ConicLocalization.gridCap_col_ne_of_ne (K := K) hcap hp hq hpq",
        "  let f0 : P -> P := ConicLocalization.anchorAxisAffine (K := K) p q",
        "  let x : P := f0 r",
        "  let g : P -> P := symmetryForThird x",
        "  let f : P -> P := fun y => g (f0 y)",
        "  have hf0 : ConicLocalization.GridSymmetry (K := K) f0 :=",
        "    ConicLocalization.anchorAxisAffine_gridSymmetry (K := K) hrow hcol",
        "  have hg : ConicLocalization.GridSymmetry (K := K) g :=",
        "    symmetryForThird_gridSymmetry x",
        "  have hf : ConicLocalization.GridSymmetry (K := K) f :=",
        "    ConicLocalization.gridSymmetry_comp (K := K) hf0 hg",
        "  have hcapImage : GridCap (K := K) (S.image f0) := (hf0.2 S).2 hcap",
        "  have himage : S.image f0 = ({pt 0 0, pt 1 1, x} : Finset P) := by",
        "    rw [hS]",
        "    simp [f0, x, pt, ConicLocalization.anchorAxisAffine_left,",
        "      ConicLocalization.anchorAxisAffine_right (K := K) hrow hcol]",
        "  have hcardImage : (S.image f0).card = S.card :=",
        "    Finset.card_image_of_injOn (fun a _ha b _hb hab => hf0.1.1 hab)",
        "  have hcardAnchor : ({pt 0 0, pt 1 1, x} : Finset P).card = 3 := by",
        "    rw [← himage, hcardImage, hcard]",
        "  have hcapAnchor : GridCap (K := K) ({pt 0 0, pt 1 1, x} : Finset P) := by",
        "    simpa [← himage] using hcapImage",
        "  refine ⟨{",
        "    classCert := classForThird x",
        "    symmetry := f",
        "    gridSymmetry := hf",
        "    valid := classForThird_valid x",
        "    representsImage := ?_",
        "  }⟩",
        "  have hcomp : S.image f = (S.image f0).image g := by",
        "    simpa [f, Function.comp_def] using",
        "      (Finset.image_comp (s := S) (f := f0) (g := g))",
        "  have htarget : S.image f = ({pt 0 0, pt 1 1, x} : Finset P).image g := by",
        "    rw [hcomp, himage]",
        "  rw [htarget]",
        "  exact classForThird_sizeThree_image_of_gridCap x hcardAnchor hcapAnchor",
        "",
        "noncomputable def transportWitness (S : Finset P) (hcard : S.card = 3)",
        "    (hcap : GridCap (K := K) S) : TransportWitness S :=",
        "  Classical.choice (exists_transportWitness S hcard hcap)",
        "",
        "noncomputable def transportBookCertificate :",
        "    GridOddEscapeTransportBookCertificate K where",
        "  classCert S hcard hcap := (transportWitness S hcard hcap).classCert",
        "  symmetry S hcard hcap := (transportWitness S hcard hcap).symmetry",
        "  gridSymmetry S hcard hcap := (transportWitness S hcard hcap).gridSymmetry",
        "  representsImage S hcard hcap := (transportWitness S hcard hcap).representsImage",
        "  valid S hcard hcap := (transportWitness S hcard hcap).valid",
        "",
        "theorem oddEscapeGameStatement :",
        "    Almost.OddEscapeGameStatement (K := K) :=",
        "  transportBookCertificate.oddEscapeGameStatement",
        "",
        "variable {V : Type*} [AddCommGroup V] [Module K V]",
        "variable [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]",
        "",
        "theorem initialPStatement_finrank (hrank : Module.finrank K V = 3) :",
        "    Projective.InitialPStatement (K := K) (V := V) :=",
        "  GridMirror.initialPStatement_of_oddEscapeStatement_finrank",
        "    (K := K) (V := V) oddEscapeGameStatement hrank",
        "",
        "#print axioms initialPStatement_finrank",
        "",
        f"end {ns}",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def emit_assembly(q: int, classes, anchor_gen) -> str:
    ns = f"Q{q}"
    rows = []
    for rec in classes:
        if rec.s3[:2] != [(0, 0), (1, 1)]:
            raise ValueError(f"class {rec.ci} is not anchored: {rec.s3}")
        rows.append((rec.s3[2][0], rec.s3[2][1], rec.ci))
    rows.sort()
    valid_cells = {(a, b) for a, b, _ci in rows}
    invalid_cells = [
        (a, b) for a in range(q) for b in range(q) if (a, b) not in valid_cells
    ]
    by_row: dict[int, list[tuple[int, int]]] = {}
    for a, b, ci in rows:
        by_row.setdefault(a, []).append((b, ci))

    def pt(cell: tuple[int, int]) -> str:
        return f"pt {cell[0]} {cell[1]}"

    def anchored_set(a: int, b: int) -> str:
        return f"({{pt 0 0, pt 1 1, {pt((a, b))}}} : Finset P)"

    lines: list[str] = [
        f"import ProjectiveCap.CertData.{ns}",
        "import ProjectiveCap.PlaneOutcome",
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        f"namespace {ns}",
        "",
        "set_option maxHeartbeats 4000000",
        "",
        "def classForThird (x : P) : GridClassCert K :=",
    ]
    for a in sorted(by_row):
        lines.append(f"  if x.1 = ({a} : K) then")
        for b, ci in sorted(by_row[a]):
            lines.append(f"    if x.2 = ({b} : K) then class{ci} else")
        lines.append("    class0")
        lines.append("  else")
    lines.append("  class0")
    lines.append("")
    for a, b, ci in rows:
        lines.extend([
            f"theorem class{ci}_sizeThree_eq :",
            f"    class{ci}.sizeThree = ({{pt 0 0, pt 1 1, {pt((a, b))}}} : Finset P) := by",
            "  rfl",
        ])
    lines.append("")
    for a, b in invalid_cells:
        aset = anchored_set(a, b)
        kind = invalid_kind(a, b)
        card_binder = "hcard" if kind == "card" else "_hcard"
        cap_binder = "_hcap" if kind == "card" else "hcap"
        lines.extend([
            f"theorem {invalid_name(a, b)}",
            f"    ({card_binder} : {aset}.card = 3)",
            f"    ({cap_binder} : GridCap (K := K) {aset}) : False := by",
        ])
        if kind == "card":
            lines.append(f"  exact (by decide : ¬ ({aset}.card = 3)) hcard")
        elif kind in {"row0", "row1"}:
            ref = (0, 0) if kind == "row0" else (1, 1)
            lines.extend([
                f"  have hp : {pt(ref)} ∈ {aset} := by simp",
                f"  have hx : {pt((a, b))} ∈ {aset} := by simp",
                f"  have hrow : ({pt(ref)}).1 = ({pt((a, b))}).1 := by norm_num [pt]",
                "  have heq := hcap.1.1 hp hx hrow",
                f"  exact (by decide : {pt(ref)} ≠ {pt((a, b))}) heq",
            ])
        elif kind in {"col0", "col1"}:
            ref = (0, 0) if kind == "col0" else (1, 1)
            lines.extend([
                f"  have hp : {pt(ref)} ∈ {aset} := by simp",
                f"  have hx : {pt((a, b))} ∈ {aset} := by simp",
                f"  have hcol : ({pt(ref)}).2 = ({pt((a, b))}).2 := by norm_num [pt]",
                "  have heq := hcap.1.2 hp hx hcol",
                f"  exact (by decide : {pt(ref)} ≠ {pt((a, b))}) heq",
            ])
        elif kind == "diag":
            lines.extend([
                f"  have hp0 : pt 0 0 ∈ {aset} := by simp",
                f"  have hp1 : pt 1 1 ∈ {aset} := by simp",
                f"  have hx : {pt((a, b))} ∈ {aset} := by simp",
                "  have h01 : pt 0 0 ≠ pt 1 1 := by decide",
                f"  have h0x : pt 0 0 ≠ {pt((a, b))} := by decide",
                f"  have h1x : pt 1 1 ≠ {pt((a, b))} := by decide",
                f"  have hcol : Collinear (K := K) (pt 0 0) (pt 1 1) ({pt((a, b))}) := by",
                "    norm_num [Collinear, pt]",
                "  exact (hcap.2 hp0 hp1 hx h01 h0x h1x) hcol",
            ])
        lines.append("")
    lines.extend([
        "",
        "theorem classForThird_valid (x : P) : (classForThird x).Valid := by",
        "  rcases x with ⟨r, c⟩",
        "  fin_cases r <;> fin_cases c",
        "  all_goals",
        "    first",
    ])
    for _a, _b, ci in rows:
        lines.extend([
            f"    | change class{ci}.Valid",
            f"      exact class{ci}_valid",
        ])
    lines.extend([
        "",
        "theorem classForThird_sizeThree_of_gridCap (x : P)",
        "    (hcard : ({pt 0 0, pt 1 1, x} : Finset P).card = 3)",
        "    (hcap : GridCap (K := K) ({pt 0 0, pt 1 1, x} : Finset P)) :",
        "    (classForThird x).sizeThree = ({pt 0 0, pt 1 1, x} : Finset P) := by",
        "  rcases x with ⟨r, c⟩",
        "  fin_cases r <;> fin_cases c",
        "  all_goals",
        "    first",
    ])
    for a, b, ci in rows:
        lines.extend([
            f"    | change class{ci}.sizeThree = ({{pt 0 0, pt 1 1, {pt((a, b))}}} : Finset P)",
            f"      exact class{ci}_sizeThree_eq",
        ])
    for a, b in invalid_cells:
        lines.extend([
            "    | exfalso",
            f"      exact {invalid_name(a, b)} hcard hcap",
        ])
    lines.extend([
        "",
        "structure TransportWitness (S : Finset P) where",
        "  classCert : GridClassCert K",
        "  symmetry : P -> P",
        "  gridSymmetry : ConicLocalization.GridSymmetry (K := K) symmetry",
        "  valid : classCert.Valid",
        "  representsImage : classCert.sizeThree = S.image symmetry",
        "",
        "theorem exists_transportWitness (S : Finset P) (hcard : S.card = 3)",
        "    (hcap : GridCap (K := K) S) : Nonempty (TransportWitness S) := by",
        "  classical",
        "  rcases (Finset.card_eq_three.mp hcard) with ⟨p, q, r, hpq, hpr, hqr, hS⟩",
        "  have hp : p ∈ S := by simp [hS]",
        "  have hq : q ∈ S := by simp [hS]",
        "  have hr : r ∈ S := by simp [hS]",
        "  have hrow : q.1 - p.1 ≠ 0 :=",
        "    ConicLocalization.gridCap_row_ne_of_ne (K := K) hcap hp hq hpq",
        "  have hcol : q.2 - p.2 ≠ 0 :=",
        "    ConicLocalization.gridCap_col_ne_of_ne (K := K) hcap hp hq hpq",
        "  let f : P -> P := ConicLocalization.anchorAxisAffine (K := K) p q",
        "  let x : P := f r",
        "  have hf : ConicLocalization.GridSymmetry (K := K) f :=",
        "    ConicLocalization.anchorAxisAffine_gridSymmetry (K := K) hrow hcol",
        "  have hcapImage : GridCap (K := K) (S.image f) := (hf.2 S).2 hcap",
        "  have himage : S.image f = ({pt 0 0, pt 1 1, x} : Finset P) := by",
        "    rw [hS]",
        "    simp [f, x, pt, ConicLocalization.anchorAxisAffine_left,",
        "      ConicLocalization.anchorAxisAffine_right (K := K) hrow hcol]",
        "  have hcardImage : (S.image f).card = S.card :=",
        "    Finset.card_image_of_injOn (fun a _ha b _hb hab => hf.1.1 hab)",
        "  have hcardAnchor : ({pt 0 0, pt 1 1, x} : Finset P).card = 3 := by",
        "    rw [← himage, hcardImage, hcard]",
        "  have hcapAnchor : GridCap (K := K) ({pt 0 0, pt 1 1, x} : Finset P) := by",
        "    simpa [← himage] using hcapImage",
        "  refine ⟨{",
        "    classCert := classForThird x",
        "    symmetry := f",
        "    gridSymmetry := hf",
        "    valid := classForThird_valid x",
        "    representsImage := ?_",
        "  }⟩",
        "  rw [himage]",
        "  exact classForThird_sizeThree_of_gridCap x hcardAnchor hcapAnchor",
        "",
        "noncomputable def transportWitness (S : Finset P) (hcard : S.card = 3)",
        "    (hcap : GridCap (K := K) S) : TransportWitness S :=",
        "  Classical.choice (exists_transportWitness S hcard hcap)",
        "",
        "noncomputable def transportBookCertificate :",
        "    GridOddEscapeTransportBookCertificate K where",
        "  classCert S hcard hcap := (transportWitness S hcard hcap).classCert",
        "  symmetry S hcard hcap := (transportWitness S hcard hcap).symmetry",
        "  gridSymmetry S hcard hcap := (transportWitness S hcard hcap).gridSymmetry",
        "  representsImage S hcard hcap := (transportWitness S hcard hcap).representsImage",
        "  valid S hcard hcap := (transportWitness S hcard hcap).valid",
        "",
        "theorem oddEscapeGameStatement :",
        "    Almost.OddEscapeGameStatement (K := K) :=",
        "  transportBookCertificate.oddEscapeGameStatement",
        "",
        "variable {V : Type*} [AddCommGroup V] [Module K V]",
        "variable [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]",
        "",
        "theorem initialPStatement_finrank (hrank : Module.finrank K V = 3) :",
        "    Projective.InitialPStatement (K := K) (V := V) :=",
        "  GridMirror.initialPStatement_of_oddEscapeStatement_finrank",
        "    (K := K) (V := V) oddEscapeGameStatement hrank",
        "",
        "#print axioms initialPStatement_finrank",
        "",
        f"end {ns}",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("cert", nargs="?", default="/tmp/c17-certs/gridcap-q13-anchored.cert")
    ap.add_argument("out_root", nargs="?", default="lean/ProjectiveCap/CertData")
    ap.add_argument("--expect-q", type=int, default=None)
    ap.add_argument(
        "--assembly-mode",
        choices=("anchored", "canonical"),
        default="anchored",
        help="anchored covers every anchored third cell directly; canonical transports anchored cells to canonical cert classes",
    )
    args = ap.parse_args()

    repo = Path(__file__).resolve().parents[1]
    cert = Path(args.cert)
    if not cert.is_absolute():
        cert = repo / cert
    out_root = Path(args.out_root)
    if not out_root.is_absolute():
        out_root = repo / out_root

    anchor_gen = load_anchor_gen()
    q, classes = anchor_gen.parse_cert(cert)
    if args.expect_q is not None and q != args.expect_q:
        raise ValueError(f"expected q={args.expect_q}, got q={q}")
    ns = f"Q{q}"
    split_dir = out_root / ns
    split_dir.mkdir(parents=True, exist_ok=True)
    (split_dir / "Base.lean").write_text(emit_base(q, anchor_gen), encoding="utf-8")
    for rec in classes:
        for rel, text in emit_class_files(q, rec, anchor_gen).items():
            (split_dir / rel).write_text(text, encoding="utf-8")
    (out_root / f"{ns}.lean").write_text(emit_aggregator(q, classes), encoding="utf-8")
    if args.assembly_mode == "canonical":
        assembly = emit_canonical_assembly(q, classes, anchor_gen)
    else:
        assembly = emit_assembly(q, classes, anchor_gen)
    (out_root / f"{ns}Assembly.lean").write_text(assembly, encoding="utf-8")
    print(
        f"wrote split {ns}: classes={len(classes)} "
        f"assembly={args.assembly_mode} dir={split_dir}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
