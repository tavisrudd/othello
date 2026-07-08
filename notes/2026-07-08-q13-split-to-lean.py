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
    node_chunks = anchor_gen.chunks(node_names, 10)
    node_chunk_names = []
    for idx, chunk in enumerate(node_chunks):
        cname = f"{pfx}_nodeChunk{idx}"
        node_chunk_names.append(cname)
        lines.append(f"def {cname} : List (List P) :=")
        lines.append(f"  {anchor_gen.lean_list(chunk, 'List P')}")
    lines.append(f"def {pfx}_nodeChunks : List (List (List P)) :=")
    lines.append(f"  {anchor_gen.lean_list(node_chunk_names, 'List (List P)')}")
    lines.append(f"def {pfx}_nodes : List (List P) :=")
    lines.append(f"  {pfx}_nodeChunks.flatten")
    row_names = []
    for ridx, (nid, mover, reply, cid) in enumerate(rec.rows):
        rname = f"{pfx}_row{ridx}"
        row_names.append(rname)
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
    lines.append(f"  {pfx}_data.toCert")
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
    lines.append(f"theorem {pfx}_nodeChunks_check :")
    lines.append(
        f"    CertCheck.BookData.checkNodesChunks (K := K) {pfx}_book {pfx}_nodeChunks = true := by"
    )
    node_chunk_simp_terms = ", ".join(
        ["CertCheck.BookData.checkNodesChunks", f"{pfx}_nodeChunks"] + node_chunk_check_names
    )
    lines.append(f"  simp only [CertCheck.allShort, {node_chunk_simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_nodes_check :")
    lines.append(f"    CertCheck.BookData.checkNodes (K := K) {pfx}_book = true := by")
    lines.append(
        f"  exact CertCheck.BookData.checkNodes_of_chunks (K := K) {pfx}_nodeChunks_flatten {pfx}_nodeChunks_check"
    )
    step_names = []
    for nid in sorted(rec.nodes):
        cname = f"{pfx}_step{nid}_all_chunks_check"
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.BookData.checkNodeStepChunksWithAll (K := K) {pfx}_book {pfx}_nodeChunks {pfx}_rowChunks {pfx}_node{nid} allCellChunks = true := by"
        )
        lines.append("  rfl")
        sname = f"{pfx}_step{nid}_check"
        step_names.append(sname)
        lines.append(f"theorem {sname} :")
        lines.append(
            f"    CertCheck.BookData.checkNodeStep (K := K) {pfx}_book {pfx}_node{nid} = true := by"
        )
        lines.append(
            f"  exact CertCheck.BookData.checkNodeStep_of_all_chunks (K := K) {pfx}_nodeChunks_flatten {pfx}_rowChunks_flatten {pfx}_cellChunks_flatten {cname}"
        )
    step_chunk_check_names = []
    for idx, chunk in enumerate(node_chunks):
        cname = f"{pfx}_stepChunk{idx}_check"
        step_chunk_check_names.append(cname)
        lines.append(f"theorem {cname} :")
        lines.append(
            f"    CertCheck.allShort (fun S => CertCheck.BookData.checkNodeStep (K := K) {pfx}_book S) {pfx}_nodeChunk{idx} = true := by"
        )
        chunk_node_ids = [name.removeprefix(f"{pfx}_node") for name in chunk]
        simp_terms = ", ".join(
            [f"{pfx}_nodeChunk{idx}"]
            + [f"{pfx}_step{nid}_check" for nid in chunk_node_ids]
        )
        lines.append(f"  simp only [CertCheck.allShort, {simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_stepChunks_check :")
    lines.append(f"    CertCheck.BookData.checkStepsChunks (K := K) {pfx}_book {pfx}_nodeChunks = true := by")
    step_chunk_simp_terms = ", ".join(
        ["CertCheck.BookData.checkStepsChunks", f"{pfx}_nodeChunks"] + step_chunk_check_names
    )
    lines.append(f"  simp only [CertCheck.allShort, {step_chunk_simp_terms}, reduceIte]")
    lines.append(f"theorem {pfx}_steps_check :")
    lines.append(f"    CertCheck.BookData.checkSteps (K := K) {pfx}_book = true := by")
    lines.append(
        f"  exact CertCheck.BookData.checkSteps_of_chunks (K := K) {pfx}_nodeChunks_flatten {pfx}_stepChunks_check"
    )
    lines.append(f"theorem {pfx}_book_valid :")
    lines.append(f"    {pfx}_book.toDAG.ValidFor (GridCap (K := K)) := by")
    lines.append(f"  have hcells : ∀ x : GridPoint K, x ∈ {pfx}_book.cells := by")
    lines.append("    intro x")
    lines.append(f"    rw [{pfx}_book_cells_eq]")
    lines.append("    exact allCells_mem x")
    lines.append("  unfold CertCheck.BookData.toDAG")
    lines.append("  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows")
    lines.append("    (Valid := GridCap (K := K))")
    lines.append(f"    (root := {pfx}_book.root.toFinset)")
    lines.append(f"    (nodes := {pfx}_book.nodesFinset)")
    lines.append(f"    (rows := {pfx}_book.rowsFinset)")
    lines.append(f"    {pfx}_root_mem")
    lines.append(f"    (CertCheck.BookData.checkNodes_sound (K := K) {pfx}_nodes_check)")
    lines.append(f"    (CertCheck.BookData.checkSteps_sound (K := K) hcells {pfx}_steps_check)")
    lines.append(f"theorem {pfx}_valid : {pfx}.Valid := by")
    lines.append(f"  unfold {pfx} CertCheck.ClassData.toCert GridClassCert.Valid")
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


def emit_aggregator(q: int, classes) -> str:
    lines = [f"import ProjectiveCap.CertData.Q{q}.Class{rec.ci}" for rec in classes]
    lines.append("")
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
    if q != 13:
        raise ValueError(f"expected q=13, got q={q}")
    ns = f"Q{q}"
    split_dir = out_root / ns
    split_dir.mkdir(parents=True, exist_ok=True)
    (split_dir / "Base.lean").write_text(emit_base(q, anchor_gen), encoding="utf-8")
    for rec in classes:
        (split_dir / f"Class{rec.ci}.lean").write_text(emit_class(q, rec, anchor_gen), encoding="utf-8")
    (out_root / f"{ns}.lean").write_text(emit_aggregator(q, classes), encoding="utf-8")
    (out_root / f"{ns}Assembly.lean").write_text(emit_assembly(q, classes, anchor_gen), encoding="utf-8")
    print(f"wrote split {ns}: classes={len(classes)} dir={split_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
