#!/usr/bin/env python3
"""Generate Lean GridClassCert data from an anchored gridcap certificate.

This is a prototype generator for C17.  It targets prime-field anchored certs
and emits one `GridClassCert (ZMod q)` term plus one `by decide` validity proof
per class.
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


def class_prefix(ci: int) -> str:
    return f"class{ci}"


def generate(q: int, classes: list[ClassRec]) -> str:
    ns = f"Q{q}"
    lines: list[str] = []
    lines.append("import ProjectiveCap.Certificate")
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
    for rec in classes:
        pfx = class_prefix(rec.ci)
        lines.append(f"def {pfx}_s3 : Finset P :=")
        lines.append(f"  {lean_finset([lean_point(c) for c in rec.s3], 'P')}")
        for nid in sorted(rec.nodes):
            lines.append(f"def {pfx}_node{nid} : Finset P :=")
            lines.append(f"  {lean_finset([lean_point(c) for c in rec.nodes[nid]], 'P')}")
        node_names = [f"{pfx}_node{nid}" for nid in sorted(rec.nodes)]
        lines.append(f"def {pfx}_nodes : Finset (Finset P) :=")
        lines.append(f"  {lean_finset(node_names, 'Finset P')}")
        row_names = []
        for ridx, (nid, mover, reply, cid) in enumerate(rec.rows):
            rname = f"{pfx}_row{ridx}"
            row_names.append(f"({pfx}_node{nid}, {rname})")
            lines.append(f"def {rname} : FiniteBuildGame.ReplyBookRow P where")
            lines.append(f"  mover := {lean_point(mover)}")
            lines.append(f"  reply := {lean_point(reply)}")
            lines.append(f"  child := {pfx}_node{cid}")
        row_type = "Prod (Finset P) (FiniteBuildGame.ReplyBookRow P)"
        lines.append(f"def {pfx}_rows : Finset ({row_type}) :=")
        lines.append(f"  {lean_finset(row_names, row_type)}")
        lines.append(f"def {pfx}_book : FiniteBuildGame.ReplyBookDAG P where")
        lines.append(f"  root := {pfx}_node0")
        lines.append(f"  Node := fun S => Membership.mem S {pfx}_nodes")
        lines.append(f"  Row := fun S row => Membership.mem (S, row) {pfx}_rows")
        lines.append(f"def {pfx} : GridClassCert K where")
        lines.append(f"  classIndex := {rec.ci}")
        lines.append(f"  sizeThree := {pfx}_s3")
        lines.append(f"  witness := {lean_point(rec.witness)}")
        lines.append(f"  book := {pfx}_book")
        lines.append(f"theorem {pfx}_book_valid : {pfx}_book.ValidFor (GridCap (K := K)) := by")
        lines.append(f"  unfold {pfx}_book")
        lines.append("  exact FiniteBuildGame.ReplyBookDAG.validFor_of_finiteRows")
        lines.append("    (Valid := GridCap (K := K))")
        lines.append(f"    (root := {pfx}_node0)")
        lines.append(f"    (nodes := {pfx}_nodes)")
        lines.append(f"    (rows := {pfx}_rows)")
        lines.append("    (by decide)")
        lines.append("    (by decide)")
        lines.append("    (by decide)")
        lines.append(f"theorem {pfx}_valid : {pfx}.Valid := by")
        lines.append(f"  unfold GridClassCert.Valid {pfx}")
        lines.append("  exact And.intro (by decide) (And.intro (by decide)")
        lines.append("    (And.intro (by")
        lines.append("      exact GridGame.mem_legalExtensions.mpr (by decide))")
        lines.append(f"      (And.intro (by decide) {pfx}_book_valid)))")
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
