#!/usr/bin/env python3
"""Generate Lean GridClassCert data from an anchored gridcap certificate.

This is the C19 reflection-route generator.  It targets prime-field anchored
certs and emits list-backed `CertCheck.ClassData (ZMod q)` terms plus one
`by decide` proof per class for the Boolean checker.
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass, field
from pathlib import Path


CELL_RE = re.compile(r"^(\d+),(\d+)$")


@dataclass
class ClassRec:
    ci: int
    s3: list[tuple[int, int]]
    witness: tuple[int, int]
    nodes: dict[int, list[tuple[int, int]]] = field(default_factory=dict)
    rows: list[tuple[int, tuple[int, int], tuple[int, int], int]] = field(default_factory=list)
    terms: set[int] = field(default_factory=set)


def parse_cell(tok: str) -> tuple[int, int]:
    m = CELL_RE.match(tok)
    if not m:
        raise ValueError(f"bad cell token {tok!r}")
    return int(m.group(1)), int(m.group(2))


def parse_cert(path: Path) -> tuple[int, list[ClassRec]]:
    q = None
    field_prime = False
    classes: list[ClassRec] = []
    cur: ClassRec | None = None
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        tok = line.split()
        match tok[0]:
            case "q":
                q = int(tok[1])
            case "field":
                field_prime = tok[1] == "prime"
            case "classes" | "total":
                pass
            case "CLASS":
                ci = int(tok[1])
                if tok[2] != "s3" or tok[8] != "witness" or tok[12] != "book":
                    raise ValueError(f"unexpected CLASS layout: {line}")
                if tok[9] == "none" or tok[13] != "ok":
                    raise ValueError(f"generator only handles book ok classes: {line}")
                cur = ClassRec(ci=ci, s3=[parse_cell(tok[3]), parse_cell(tok[4]), parse_cell(tok[5])],
                               witness=parse_cell(tok[9]))
                classes.append(cur)
            case "N":
                if cur is None:
                    raise ValueError("N before CLASS")
                nid = int(tok[2])
                cur.nodes[nid] = [parse_cell(t) for t in tok[3:]]
            case "R":
                if cur is None:
                    raise ValueError("R before CLASS")
                cur.rows.append((int(tok[2]), parse_cell(tok[3]), parse_cell(tok[4]), int(tok[5])))
            case "T":
                if cur is None:
                    raise ValueError("T before CLASS")
                cur.terms.add(int(tok[2]))
            case other:
                raise ValueError(f"unknown record kind {other!r}")
    if q is None:
        raise ValueError("missing q header")
    if not field_prime:
        raise ValueError("generator currently handles prime-field certs only")
    return q, classes


def lean_point(cell: tuple[int, int]) -> str:
    r, c = cell
    return f"pt {r} {c}"


def lean_finset(elems: list[str], typ: str) -> str:
    if not elems:
        return f"({{}} : Finset ({typ}))"
    return "({" + ", ".join(elems) + f"}} : Finset ({typ}))"


def lean_list(elems: list[str], typ: str) -> str:
    if not elems:
        return f"([] : List ({typ}))"
    return "([" + ", ".join(elems) + f"] : List ({typ}))"


def class_prefix(ci: int) -> str:
    return f"class{ci}"


def chunks(xs: list[tuple[int, int]], size: int) -> list[list[tuple[int, int]]]:
    return [xs[i:i + size] for i in range(0, len(xs), size)]


def generate(q: int, classes: list[ClassRec]) -> str:
    ns = f"Q{q}"
    lines: list[str] = []
    lines.append("import ProjectiveCap.CertCheck")
    lines.append("")
    lines.append("namespace ProjectiveCap")
    lines.append("namespace Certificate")
    lines.append("namespace CertData")
    lines.append(f"namespace {ns}")
    lines.append("")
    lines.append(f"instance : Fact (Nat.Prime {q}) := Fact.mk (by decide)")
    lines.append("")
    lines.append(f"abbrev K := ZMod {q}")
    lines.append("abbrev P := GridPoint K")
    lines.append("")
    lines.append("def pt (r c : Nat) : P := ((r : K), (c : K))")
    lines.append("")
    cells = [(r, c) for r in range(q) for c in range(q)]
    cell_chunks = chunks(cells, 11)
    for idx, chunk in enumerate(cell_chunks):
        lines.append(f"def allCellsChunk{idx} : List P :=")
        lines.append(f"  {lean_list([lean_point(c) for c in chunk], 'P')}")
    lines.append("def allCellChunks : List (List P) :=")
    lines.append(f"  {lean_list([f'allCellsChunk{idx}' for idx in range(len(cell_chunks))], 'List P')}")
    lines.append("def allCells : List P :=")
    lines.append("  allCellChunks.flatten")
    lines.append("theorem allCells_mem (x : GridPoint K) : x ∈ allCells := by")
    lines.append("  rcases x with ⟨r, c⟩")
    lines.append("  fin_cases r <;> fin_cases c <;> decide")
    lines.append("")
    for rec in classes:
        pfx = class_prefix(rec.ci)
        witness_term = f"({lean_point(rec.witness)})"
        lines.append(f"def {pfx}_s3 : List P :=")
        lines.append(f"  {lean_list([lean_point(c) for c in rec.s3], 'P')}")
        for nid in sorted(rec.nodes):
            lines.append(f"def {pfx}_node{nid} : List P :=")
            lines.append(f"  {lean_list([lean_point(c) for c in rec.nodes[nid]], 'P')}")
        node_names = [f"{pfx}_node{nid}" for nid in sorted(rec.nodes)]
        lines.append(f"def {pfx}_nodes : List (List P) :=")
        lines.append(f"  {lean_list(node_names, 'List P')}")
        row_names = []
        for ridx, (nid, mover, reply, cid) in enumerate(rec.rows):
            rname = f"{pfx}_row{ridx}"
            row_names.append(rname)
            lines.append(f"def {rname} : CertCheck.RowData K where")
            lines.append(f"  node := {pfx}_node{nid}")
            lines.append(f"  mover := {lean_point(mover)}")
            lines.append(f"  reply := {lean_point(reply)}")
            lines.append(f"  child := {pfx}_node{cid}")
        lines.append(f"def {pfx}_rows : List (CertCheck.RowData K) :=")
        lines.append(f"  {lean_list(row_names, 'CertCheck.RowData K')}")
        lines.append(f"def {pfx}_book : CertCheck.BookData K where")
        lines.append("  cells := allCells")
        lines.append(f"  root := {pfx}_node0")
        lines.append(f"  nodes := {pfx}_nodes")
        lines.append(f"  rows := {pfx}_rows")
        lines.append(f"theorem {pfx}_book_cells_eq : {pfx}_book.cells = allCells := by")
        lines.append("  rfl")
        lines.append(f"theorem {pfx}_book_nodes_eq : {pfx}_book.nodes = {pfx}_nodes := by")
        lines.append("  rfl")
        lines.append(f"def {pfx}_data : CertCheck.ClassData K where")
        lines.append(f"  classIndex := {rec.ci}")
        lines.append(f"  sizeThree := {pfx}_s3")
        lines.append(f"  witness := {lean_point(rec.witness)}")
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
        lines.append(f"theorem {pfx}_root_check :")
        lines.append(f"    CertCheck.BookData.checkRoot (K := K) {pfx}_book = true := by")
        lines.append("  rfl")
        node_cap_names = []
        for nid in sorted(rec.nodes):
            ncap_name = f"{pfx}_node{nid}_cap_check"
            node_cap_names.append(ncap_name)
            lines.append(f"theorem {ncap_name} :")
            lines.append(f"    CertCheck.checkCap (K := K) {pfx}_node{nid} = true := by")
            lines.append("  rfl")
        lines.append(f"theorem {pfx}_nodes_check :")
        lines.append(f"    CertCheck.BookData.checkNodes (K := K) {pfx}_book = true := by")
        node_simp_terms = ", ".join(
            ["CertCheck.BookData.checkNodes", f"{pfx}_book_nodes_eq", f"{pfx}_nodes"]
            + node_cap_names
        )
        lines.append(f"  simp [{node_simp_terms}]")
        step_names = []
        for nid in sorted(rec.nodes):
            cname = f"{pfx}_step{nid}_chunks_check"
            lines.append(f"theorem {cname} :")
            lines.append(
                f"    CertCheck.BookData.checkNodeStepChunks (K := K) {pfx}_book {pfx}_node{nid} allCellChunks = true := by"
            )
            lines.append("  rfl")
            sname = f"{pfx}_step{nid}_check"
            step_names.append(sname)
            lines.append(f"theorem {sname} :")
            lines.append(
                f"    CertCheck.BookData.checkNodeStep (K := K) {pfx}_book {pfx}_node{nid} = true := by"
            )
            lines.append("  unfold CertCheck.BookData.checkNodeStep")
            lines.append(f"  rw [{pfx}_book_cells_eq]")
            lines.append("  unfold allCells")
            lines.append(f"  exact CertCheck.BookData.checkNodeStepOn_of_chunks (K := K) {cname}")
        lines.append(f"theorem {pfx}_steps_check :")
        lines.append(f"    CertCheck.BookData.checkSteps (K := K) {pfx}_book = true := by")
        simp_terms = ", ".join(
            ["CertCheck.BookData.checkSteps", f"{pfx}_book_nodes_eq", f"{pfx}_nodes"]
            + step_names
        )
        lines.append(f"  simp [{simp_terms}]")
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
        lines.append(f"    (CertCheck.BookData.checkRoot_sound (K := K) {pfx}_root_check)")
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
        lines.append("")
    lines.append("end " + ns)
    lines.append("end CertData")
    lines.append("end Certificate")
    lines.append("end ProjectiveCap")
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} INPUT.cert OUTPUT.lean", file=sys.stderr)
        return 2
    q, classes = parse_cert(Path(sys.argv[1]))
    out = Path(sys.argv[2])
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(generate(q, classes), encoding="utf-8")
    print(f"wrote {out} q={q} classes={len(classes)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
