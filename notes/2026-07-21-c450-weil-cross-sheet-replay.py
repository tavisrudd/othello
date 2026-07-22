#!/usr/bin/env python3
"""Independent replay for C450; imports no primary C450 code."""

from __future__ import annotations

import hashlib
import json
import math
import subprocess
from collections import Counter
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
CERT = NOTES / "2026-07-21-c450-weil-cross-sheet.json"


def canonical(pairs):
    return tuple(sorted(tuple(sorted((int(a), int(b)))) for a, b in pairs))


def rank(rows, modulus=None):
    if modulus is None:
        a = [[Fraction(x) for x in row] for row in rows]
    else:
        a = [[x % modulus for x in row] for row in rows]
    r = 0
    for col in range(len(a[0])):
        pivot = next((i for i in range(r, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        inv = 1 / a[r][col] if modulus is None else pow(a[r][col], modulus - 2, modulus)
        a[r] = [(x * inv) if modulus is None else (x * inv) % modulus for x in a[r]]
        for i in range(len(a)):
            if i == r or not a[i][col]:
                continue
            scale = a[i][col]
            a[i] = [(x - scale * y) if modulus is None else (x - scale * y) % modulus for x, y in zip(a[i], a[r])]
        r += 1
    return r


def normalize(g, q):
    first = next(x % q for x in g if x % q)
    inv = pow(first, q - 2, q)
    return tuple(x * inv % q for x in g)


def point(g, x, q):
    a, b, c, d = g
    if x == q:
        return q if c == 0 else a * pow(c, q - 2, q) % q
    den = (c * x + d) % q
    return q if den == 0 else (a * x + b) * pow(den, q - 2, q) % q


def transform_matching(g, matching, q):
    return canonical((point(g, a, q), point(g, b, q)) for a, b in matching)


def relation_rows(left, right, shared):
    return [[int((len(set(a) & set(b)) == 1) if shared else (len(set(a) & set(b)) == 0)) for b in right] for a in left]


def gap_replay():
    program = r'''
SizeScreen([100000,100000]);;
for q in [7,11] do
 pg:=PGL(2,q);; g:=DerivedSubgroup(pg);; irr:=Irr(g);;
 Print("REPLAY|",q,"|DEGREES|",JoinStringsWithSeparator(List(irr,x->String(x[1])),","),"\n");
 cs:=ConjugacyClassesSubgroups(g);;
 wanted:=q=7 and [6,8,24] or [10,12,60];
 for c in cs do
  h:=Representative(c);;
  if Size(h) in wanted then
   p:=PermutationCharacter(g,h);;
   Print("REPLAY|",q,"|SUB|",Size(h),"|",StructureDescription(h),"|",JoinStringsWithSeparator(List(irr,x->String(ScalarProduct(p,x))),","),"\n");
  fi;
 od;
 outer:=First(Elements(pg),x->not x in g);; classes:=ConjugacyClasses(g);;
 cp:=List(classes,c->PositionProperty(classes,d->Representative(c)^outer in d));;
 ip:=List(irr,x->Position(irr,Character(CharacterTable(g),List([1..Length(classes)],k->x[cp[k]]))));;
 Print("REPLAY|",q,"|OUTER|",JoinStringsWithSeparator(List(ip,String),","),"\n");
od;
QUIT;
'''.replace("wanted:=q=7 and [6,8,24] or [10,12,60];", "if q=7 then wanted:=[6,8,24];; else wanted:=[10,12,60];; fi;")
    run = subprocess.run(["nix", "shell", "nixpkgs#gap", "--command", "gap", "-q"], input=program, text=True, capture_output=True, check=True)
    return [line for line in run.stdout.splitlines() if line.startswith("REPLAY|")]


def main():
    cert = json.loads(CERT.read_text())
    assert cert["schema"] == "c450-weil-cross-sheet-v1"
    for item in cert["inputs"].values():
        path = Path(item["path"])
        data = path.read_bytes()
        assert len(data) == item["bytes"]
        assert hashlib.sha256(data).hexdigest() == item["sha256"]

    for case in cert["finite_actions"]:
        q = case["q"]
        left, right = ([canonical(m) for m in sheet] for sheet in case["canonical_sheets"])
        assert len(left) == len(right) == q
        for name, shared in (("shared_edge", True), ("disjoint", False)):
            rows = relation_rows(left, right, shared)
            frozen = case["relations"][name]
            assert rank(rows) == frozen["rank_over_Q"] == q
            assert rank(rows, 2) == frozen["ranks_mod_2_3"]["2"]
            assert rank(rows, 3) == frozen["ranks_mod_2_3"]["3"]
            gram = [[sum(x * y for x, y in zip(a, b)) for b in rows] for a in rows]
            assert sorted({gram[i][i] for i in range(q)}) == frozen["gram_diagonal_values"]
            assert sorted({gram[i][j] for i in range(q) for j in range(q) if i != j}) == frozen["gram_off_diagonal_values"]
        if q == 11:
            rz = tuple(case["outer_action"]["Rz_mobius_matrix"])
            assert (rz[0] * rz[3] - rz[1] * rz[2]) % q == 2
            assert {transform_matching(rz, m, q) for m in left} == set(right)
            all_matchings = left + right
            adjacency = [[int(i != j and len(set(a) & set(b)) == 1) for j, b in enumerate(all_matchings)] for i, a in enumerate(all_matchings)]
            mapping = {m: i for i, m in enumerate(all_matchings)}
            perm = [mapping[transform_matching(rz, m, q)] for m in all_matchings]
            assert all(adjacency[i][j] == adjacency[perm[i]][perm[j]] for i in range(22) for j in range(22))

    for q in ("7", "11"):
        irreps = cert["characters"][q]["psl_irreducibles"]
        group_order = int(q) * (int(q) ** 2 - 1) // 2
        assert sum(x["degree"] ** 2 for x in irreps) == group_order
        for module in cert["module_decompositions"][q].values():
            assert sum(m * chi["degree"] for m, chi in zip(module["irreducible_multiplicities"], irreps)) == module["degree"]

    lines = gap_replay()
    assert any(line == "REPLAY|7|DEGREES|1,3,3,6,7,8" for line in lines)
    assert any(line == "REPLAY|11|DEGREES|1,5,5,10,10,11,12,12" for line in lines)
    assert any(line == "REPLAY|11|OUTER|1,3,2,4,5,6,7,8" for line in lines)
    print("C450 independent replay OK")


if __name__ == "__main__":
    main()
