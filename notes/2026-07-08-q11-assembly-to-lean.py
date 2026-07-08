#!/usr/bin/env python3
"""Generate the Q11 anchored-selector assembly Lean file.

The heavy generated file `CertData/Q11.lean` contains one checked
`GridClassCert` per anchored third cell.  This script emits the thin transport
layer that maps an arbitrary size-three grid cap to its anchored third cell and
selects the corresponding class.
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


def emit(q: int, classes) -> str:
    if q != 11:
        raise ValueError(f"expected q=11, got q={q}")
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

    def pt(cell: tuple[int, int]) -> str:
        return f"pt {cell[0]} {cell[1]}"

    def anchored_set(a: int, b: int) -> str:
        return f"({{pt 0 0, pt 1 1, {pt((a, b))}}} : Finset P)"

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

    by_row: dict[int, list[tuple[int, int]]] = {}
    for a, b, ci in rows:
        by_row.setdefault(a, []).append((b, ci))

    lines: list[str] = [
        "import ProjectiveCap.CertData.Q11",
        "import ProjectiveCap.PlaneOutcome",
        "",
        "namespace ProjectiveCap",
        "namespace Certificate",
        "namespace CertData",
        "namespace Q11",
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
        "end Q11",
        "end CertData",
        "end Certificate",
        "end ProjectiveCap",
        "",
    ])
    return "\n".join(lines)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("cert", nargs="?", default="/tmp/c17-certs/gridcap-q11-anchored.cert")
    ap.add_argument("out", nargs="?", default="lean/ProjectiveCap/CertData/Q11Assembly.lean")
    args = ap.parse_args()
    repo = Path(__file__).resolve().parents[1]
    cert = Path(args.cert)
    if not cert.is_absolute():
        cert = repo / cert
    out = Path(args.out)
    if not out.is_absolute():
        out = repo / out
    anchor_gen = load_anchor_gen()
    q, classes = anchor_gen.parse_cert(cert)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(emit(q, classes), encoding="utf-8")
    print(f"wrote {out} q={q} classes={len(classes)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
