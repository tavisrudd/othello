#!/usr/bin/env python3
"""Serialize the exact six-weight support refinement of T_B x T_C.

Requires Polymake 4.15 from Nix.  The homogeneous fan is intersected with
t=1; faces contained in t=0 are deliberately excluded.
"""
from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import os
import subprocess
import sys
import tempfile
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE / "2026-08-12-c907-tripod-hyperplane-refinement.json"
SUM = HERE / "2026-08-12-c907-tripod-hyperplane-refinement.sha256"
VERTICES = ("g", "0", "1", "infinity")
REPORT = {
    ("g", "g"): "2026-08-12-c907-bunit-cunit-generic-star.md",
    ("g", "0"): "2026-08-12-c907-b0-cunit-star-fan.md",
    ("g", "1"): "2026-08-12-c907-b1-cunit-star-fan.md",
    ("g", "infinity"): "2026-08-12-c907-binf-cunit-star-fan.md",
    ("0", "0"): "2026-08-12-c907-bc00-star-fan.md",
    ("0", "1"): "2026-08-12-c907-b1-c0-seam-star-fan.md",
    ("0", "infinity"): "2026-08-12-c907-b0-cinf-seam-star-fan.md",
    ("1", "1"): "2026-08-12-c907-joint-y-rees-infinity-fan.md",
    ("1", "infinity"): "2026-08-12-c907-b1-cinf-seam-star-fan.md",
    ("infinity", "infinity"): "2026-08-12-c907-binf-cinf-star-fan.md",
}


def pair(a: str, b: str) -> tuple[str, str]:
    return min((a, b), (b, a), key=lambda x: tuple(VERTICES.index(y) for y in x))


def rs(vertex: str) -> tuple[int, int]:
    return {"g": (0, 0), "0": (1, 0), "1": (0, 1), "infinity": (-1, -1)}[vertex]


def weights(a: str, b: str) -> list[list[int]]:
    rb, sb = rs(a)
    rc, sc = rs(b)
    return [[0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0],
            [0, 0, 0, 1, 0, 0], [0, -1, -1, -1, rb, rc], [2, 0, 0, 0, -sb, -sc]]


def support(a: str, b: str) -> list[list[int]]:
    rays = [[1, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0], [0, -1, 0, 0, 0, 0],
            [0, 0, 1, 0, 0, 0], [0, 0, -1, 0, 0, 0], [0, 0, 0, 1, 0, 0], [0, 0, 0, -1, 0, 0]]
    if a != "g": rays.append([0, 0, 0, 0, 1, 0])
    if b != "g": rays.append([0, 0, 0, 0, 0, 1])
    return rays


def perl(cases: list[tuple[str, str]]) -> str:
    data = [[f"{a},{b}", weights(a, b), support(a, b)] for a, b in cases]
    literal = json.dumps(data).replace("[", "[").replace("]", "]")
    # JSON arrays are valid Perl array literals; quoted strings are shared syntax.
    return f'''use application "fan";
my $cases = {literal};
for my $case (@$cases) {{
  my ($name,$w,$input) = @{{$case}}; my @h;
  for my $i (0..5) {{ for my $j (($i+1)..5) {{ push @h, [map {{$w->[$i]->[$_] - $w->[$j]->[$_]}} (0..5)]; }} }}
  my $ha = new HyperplaneArrangement(HYPERPLANES=>\\@h, "SUPPORT.INPUT_RAYS"=>$input);
  my $fan = $ha->CHAMBER_DECOMPOSITION;
  print "CASE|$name\\nRAYS\\n", $fan->RAYS, "ENDRAYS\\n";
  for my $d (1..$fan->COMBINATORIAL_DIM+1) {{ print "DIM|$d\\n", $fan->cones_of_dim($d), "ENDDIM\\n"; }}
  print "ENDCASE\\n";
}}
'''


def parse(text: str, cases: list[tuple[str, str]]) -> dict[str, dict]:
    blocks = text.split("CASE|")[1:]
    if len(blocks) != len(cases): raise RuntimeError("Polymake case count drift")
    out: dict[str, dict] = {}
    for block in blocks:
        lines = block.strip().splitlines(); name = lines.pop(0); rays: list[list[int]] = []; faces: dict[int, list[list[int]]] = {}
        mode = ""; dim = 0
        for line in lines:
            if line == "RAYS": mode = "rays"; continue
            if line == "ENDRAYS": mode = ""; continue
            if line.startswith("DIM|"): dim = int(line[4:]); faces[dim] = []; mode = "faces"; continue
            if line == "ENDDIM": mode = ""; continue
            if line == "ENDCASE": continue
            if mode == "rays": rays.append([Fraction(x) for x in line.split()])
            elif mode == "faces": faces[dim].append([int(x) for x in line.strip("{}").split()])
        out[name] = {"rays": rays, "faces": faces}
    return out


def sign_vector(ws: list[list[int]], rays: list[list[int]], face: list[int]) -> str:
    signs = []
    for i, j in itertools.combinations(range(6), 2):
        h = [x-y for x, y in zip(ws[i], ws[j])]
        values = [sum(x*y for x, y in zip(h, rays[k])) for k in face]
        if all(v == 0 for v in values): signs.append("0")
        elif all(v >= 0 for v in values): signs.append("+")
        elif all(v <= 0 for v in values): signs.append("-")
        else: raise RuntimeError("non-face crosses a hyperplane")
    return "".join(signs)


def maximum_mask(signs: str) -> str:
    """The tie support of the upper envelope, from the fixed pair order."""
    pairs = list(itertools.combinations(range(6), 2))
    maxima = []
    for weight in range(6):
        is_maximum = True
        for index, (left, right) in enumerate(pairs):
            if weight == left and signs[index] == "-": is_maximum = False
            if weight == right and signs[index] == "+": is_maximum = False
        if is_maximum: maxima.append(weight)
    if not maxima: raise RuntimeError("a sign vector has no maximal weight")
    return "".join(str(weight) for weight in maxima)


def encode(cases: list[tuple[str, str]], raw: dict[str, dict]) -> dict:
    records = []
    for a, b in cases:
        name = f"{a},{b}"; item = raw[name]; rays = item["rays"]; ws = weights(a, b); kept: dict[int, list[dict]] = {}
        for dim, faces in item["faces"].items():
            # A homogeneous face meets t=1 iff one of its rays has t>0.
            cells = [f for f in faces if any(rays[k][0] > 0 for k in f)]
            if cells:
                kept[dim-1] = [{"rays": f, "signs": sign_vector(ws, rays, f)} for f in cells]
        covers = {}
        for d in sorted(kept):
            if d+1 not in kept: continue
            n = sum(set(low["rays"]).issubset(high["rays"]) for low in kept[d] for high in kept[d+1])
            covers[f"{d}->{d+1}"] = n
        max_masks: dict[str, int] = {}
        cell_count = 0
        for cells in kept.values():
            for cell in cells:
                mask = maximum_mask(cell["signs"])
                max_masks[mask] = max_masks.get(mask, 0) + 1
                cell_count += 1
        if sum(max_masks.values()) != cell_count:
            raise RuntimeError("upper-envelope aggregation lost a slice cell")
        records.append({"ordered_type": [a, b], "unordered_orbit": list(pair(a,b)), "local_report": REPORT[pair(a,b)],
                        "weights": ws, "rays": [[str(x) for x in ray] for ray in rays], "slice_face_counts": {str(d): len(c) for d,c in kept.items()},
                        "cover_incidence_counts": covers,
                        "upper_envelope": {"maximal_weight_tie_masks": max_masks, "cell_count": cell_count,
                                           "mask_count": len(max_masks), "all_cells_assigned_once": True},
                        "slice_faces": {str(d): c for d,c in kept.items()}})
    all_masks = sorted({mask for record in records for mask in record["upper_envelope"]["maximal_weight_tie_masks"]})
    return {"schema_version": 1, "backend": "polymake 4.15 (exact rational PPL)",
            "coordinates": ["t", "p1", "p2", "p3", "beta", "gamma"],
            "hyperplanes": [f"w{i}=w{j}" for i,j in itertools.combinations(range(6),2)],
            "slice": "t=1; all homogeneous faces contained in t=0 are omitted",
            "complex_kind": "exact rational hyperplane complex; no simpliciality, regularity, or integral refinement is asserted",
            "cones": records,
            "checks": {"ordered_product_cones": len(records), "hyperplane_count": 15,
                       "all_cells_have_constant_hyperplane_sign_vector": True,
                       "all_cells_map_to_one_upper_envelope_mask": True,
                       "total_unique_upper_envelope_masks": len(all_masks),
                       "upper_envelope_masks": all_masks}}


def canonical(data: dict) -> bytes: return (json.dumps(data, sort_keys=True, separators=(",", ":")) + "\n").encode()

def sums(data: bytes) -> bytes:
    return (f"{hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}  {Path(__file__).name}\n"
            f"{hashlib.sha256(data).hexdigest()}  {OUT.name}\n").encode()

def main() -> int:
    ap = argparse.ArgumentParser(); g = ap.add_mutually_exclusive_group(required=True); g.add_argument("--write", action="store_true"); g.add_argument("--check", action="store_true"); ap.add_argument("--one", help="diagnostic ordered cone, e.g. 0,0"); args=ap.parse_args()
    cases = list(itertools.product(VERTICES, repeat=2))
    if args.one:
        cases = [tuple(args.one.split(","))]
        if len(cases[0]) != 2 or any(x not in VERTICES for x in cases[0]): ap.error("--one must name two tripod vertices")
    raw = {}
    for index, case in enumerate(cases, start=1):
        with tempfile.TemporaryDirectory() as td:
            source = Path(td)/"refinement.pl"; source.write_text(perl([case])); env=os.environ.copy(); env["POLYMAKE_USER_DIR"]=td
            run=subprocess.run(["nix","shell","nixpkgs#polymake","--command","polymake","--script",str(source)], text=True, capture_output=True, env=env)
            if run.returncode:
                raise RuntimeError("Polymake replay failed:\n" + run.stderr)
            raw.update(parse(run.stdout,[case]))
        print(f"completed {index}/{len(cases)}: {case[0]},{case[1]}", flush=True)
    data=canonical(encode(cases, raw))
    if args.one: print(f"diagnostic {args.one}: {len(data)} bytes"); return 0
    if args.write: OUT.write_bytes(data); SUM.write_bytes(sums(data)); print(f"wrote {OUT.name}: {len(data)} bytes"); return 0
    if OUT.read_bytes()!=data or SUM.read_bytes()!=sums(data): print("refinement certificate drift", file=sys.stderr); return 1
    print(f"ok {OUT.name}: {len(data)} bytes sha256={hashlib.sha256(data).hexdigest()}"); return 0
if __name__ == "__main__": raise SystemExit(main())
