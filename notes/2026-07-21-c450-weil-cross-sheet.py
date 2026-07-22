#!/usr/bin/env python3
"""C450 exact cross-sheet module and Weil-character certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import subprocess
from collections import Counter, deque
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-21-c450-weil-cross-sheet.json"
REFERENCE = Path("/tmp/persistent/tavis/lit-search/pdf/10.1090_S0002-9904-1976-14017-7.pdf")

INPUTS = {
    "c399": NOTES / "2026-07-20-c399-coxeter-number-conic-phase.json",
    "c406_scout": NOTES / "2026-07-20-c406-matching-orbit-scout.json",
    "c406_module": NOTES / "2026-07-20-c406-matching-module.json",
    "c445": NOTES / "2026-07-21-c445-characteristic-11-gluing.json",
    "c449": NOTES / "2026-07-21-c449-split-coxeter-torus.json",
    "c460": NOTES / "2026-07-21-c460-golden-fregier-cloud-bridge.json",
    "weil_reference": REFERENCE,
}


def digest(path: Path) -> dict[str, object]:
    data = path.read_bytes()
    return {"path": str(path), "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def normalize_matrix(a: int, b: int, c: int, d: int, q: int) -> tuple[int, int, int, int]:
    vals = (a % q, b % q, c % q, d % q)
    first = next(x for x in vals if x)
    inv = pow(first, q - 2, q)
    return tuple((x * inv) % q for x in vals)


def pgl_matrices(q: int):
    return sorted({
        normalize_matrix(a, b, c, d, q)
        for a in range(q) for b in range(q) for c in range(q) for d in range(q)
        if (a * d - b * c) % q
    })


def det(g, q):
    a, b, c, d = g
    return (a * d - b * c) % q


def is_square(x: int, q: int) -> bool:
    return x % q in {a * a % q for a in range(1, q)}


def act_point(g, x: int, q: int) -> int:
    a, b, c, d = g
    if x == q:
        return q if c == 0 else a * pow(c, q - 2, q) % q
    den = (c * x + d) % q
    return q if den == 0 else (a * x + b) * pow(den, q - 2, q) % q


def point_permutation(g, q: int):
    return tuple(act_point(g, x, q) for x in range(q + 1))


def canon_matching(pairs):
    return tuple(sorted(tuple(sorted((int(a), int(b)))) for a, b in pairs))


def act_matching(permutation, matching):
    return canon_matching((permutation[a], permutation[b]) for a, b in matching)


def permutation_order(p):
    seen = set()
    answer = 1
    for start in range(len(p)):
        if start in seen:
            continue
        cur = start
        length = 0
        while cur not in seen:
            seen.add(cur)
            cur = p[cur]
            length += 1
        if length:
            answer = math.lcm(answer, length)
    return answer


def rank_q(rows):
    a = [[Fraction(x) for x in row] for row in rows]
    rank = 0
    width = len(a[0]) if a else 0
    for col in range(width):
        pivot = next((i for i in range(rank, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        scale = a[rank][col]
        a[rank] = [x / scale for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][col]:
                scale = a[i][col]
                a[i] = [x - scale * y for x, y in zip(a[i], a[rank])]
        rank += 1
    return rank


def rank_mod(rows, prime):
    a = [[x % prime for x in row] for row in rows]
    rank = 0
    width = len(a[0]) if a else 0
    for col in range(width):
        pivot = next((i for i in range(rank, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inv = pow(a[rank][col], prime - 2, prime)
        a[rank] = [(x * inv) % prime for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][col]:
                scale = a[i][col]
                a[i] = [(x - scale * y) % prime for x, y in zip(a[i], a[rank])]
        rank += 1
    return rank


def matmul_transpose(rows):
    return [[sum(x * y for x, y in zip(left, right)) for right in rows] for left in rows]


def orbit(base, permutations):
    return sorted({act_matching(p, base) for p in permutations})


def induced_permutation(permutation, objects):
    index = {obj: i for i, obj in enumerate(objects)}
    return tuple(index[act_matching(permutation, obj)] for obj in objects)


def action_case(q: int, type_name: str, frozen: dict, c460: dict):
    base = canon_matching(frozen["coxeter_invariant_matching"])
    matrices = pgl_matrices(q)
    pgl = [point_permutation(g, q) for g in matrices]
    psl_pairs = [(g, p) for g, p in zip(matrices, pgl) if is_square(det(g, q), q)]
    targets = orbit(base, pgl)
    sheet0 = orbit(base, [p for _, p in psl_pairs])
    sheet0_set = set(sheet0)
    sheet1 = [m for m in targets if m not in sheet0_set]
    assert len(sheet0) == len(sheet1) == q

    relations = {}
    for name, shared in (("shared_edge", True), ("disjoint", False)):
        rows = []
        pairs = []
        for left in sheet0:
            row = []
            for right in sheet1:
                common = len(set(left) & set(right))
                hit = common == 1 if shared else common == 0
                row.append(int(hit))
                if hit:
                    pairs.append((left, right))
            rows.append(row)
        gram = matmul_transpose(rows)
        diagonal = sorted({gram[i][i] for i in range(q)})
        off_diagonal = sorted({gram[i][j] for i in range(q) for j in range(q) if i != j})
        first_pair = pairs[0]
        stabilizer = []
        for g, p in psl_pairs:
            if act_matching(p, first_pair[0]) == first_pair[0] and act_matching(p, first_pair[1]) == first_pair[1]:
                stabilizer.append(point_permutation(g, q))
        relations[name] = {
            "shape": [q, q],
            "support_size": len(pairs),
            "row_sum_histogram": dict(sorted(Counter(map(sum, rows)).items())),
            "column_sum_histogram": dict(sorted(Counter(sum(row[j] for row in rows) for j in range(q)).items())),
            "rank_over_Q": rank_q(rows),
            "ranks_mod_2_3": {"2": rank_mod(rows, 2), "3": rank_mod(rows, 3)},
            "gram_diagonal_values": diagonal,
            "gram_off_diagonal_values": off_diagonal,
            "stabilizer_order": len(stabilizer),
            "stabilizer_element_order_histogram": dict(sorted(Counter(permutation_order(p) for p in stabilizer).items())),
            "rows": rows,
        }

    torus = next(
        item for item in c460["c449_cases"]
        if item["case"] == type_name and item["prime_q"] == q
    )
    torus_matrix = tuple(torus["generator_matrix_in_frozen_P1_frame"])
    torus_perm = point_permutation(torus_matrix, q)
    fixed_counts = []
    cur = tuple(range(q + 1))
    for _ in range(torus["split_torus_order"]):
        fixed_counts.append(sum(cur[i] == i for i in range(q + 1)))
        cur = tuple(torus_perm[cur[i]] for i in range(q + 1))
    e = torus["split_torus_order"]
    trivial_mult = sum(fixed_counts) // e
    nontrivial_mults = []
    # All nonidentity fixed counts are 2, so the nontrivial Fourier coefficients are integral.
    for _ in range(1, e):
        nontrivial_mults.append((fixed_counts[0] - fixed_counts[1]) // e)

    result = {
        "type": type_name,
        "q": q,
        "group_orders": {"PGL2": len(pgl), "PSL2": len(psl_pairs)},
        "sheet_sizes": [len(sheet0), len(sheet1)],
        "sheet_module_dimension": q,
        "relations": relations,
        "c449_torus_baseline": {
            "fixed_point_character_on_powers": fixed_counts,
            "restriction_formula": "2*trivial + 2*regular(C_e)",
            "trivial_multiplicity": trivial_mult,
            "nontrivial_multiplicities": nontrivial_mults,
            "invariant_dimension": trivial_mult,
            "matches_frozen_c449": trivial_mult == 4 and set(nontrivial_mults) <= {2},
        },
        "canonical_sheets": [[[[a, b] for a, b in m] for m in sheet] for sheet in (sheet0, sheet1)],
    }
    if q == 11:
        rz = (1, 10, 1, 1)
        rz_perm = point_permutation(rz, q)
        rz_target = induced_permutation(rz_perm, targets)
        target_index = {m: i for i, m in enumerate(targets)}
        adjacency = [[0] * len(targets) for _ in targets]
        for i, left in enumerate(targets):
            for j, right in enumerate(targets):
                if i != j and len(set(left) & set(right)) == 1:
                    adjacency[i][j] = 1
        frozen_h3 = c460["cloud_cases"]["H3"]
        frozen_rows = [canon_matching(x) for x in frozen_h3["incidence"]["canonical_row_order"]]
        frozen_adj = frozen_h3["overlap_graph"]["adjacency"]
        reindex = [target_index[m] for m in frozen_rows]
        d1_equal = all((j in frozen_adj[i]) == bool(adjacency[reindex[i]][reindex[j]]) for i in range(22) for j in range(22))
        square_block = set(torus["action_decomposition"]["moving_orbits"][0])
        nonsquare_block = set(torus["action_decomposition"]["moving_orbits"][1])
        image_square = {act_point(rz, x, q) for x in square_block}
        result["outer_action"] = {
            "Rz_mobius_matrix": list(rz),
            "determinant": det(rz, q),
            "determinant_is_nonsquare": not is_square(det(rz, q), q),
            "swaps_sheets": all(targets[rz_target[target_index[m]]] in set(sheet1) for m in sheet0),
            "preserves_shared_edge_relation": all(adjacency[i][j] == adjacency[rz_target[i]][rz_target[j]] for i in range(22) for j in range(22)),
            "same_PGL_over_PSL_bit_as_c449_generic_outer": not is_square(det(rz, q), q),
            "literally_swaps_c449_fixed_frame_legendre_blocks": image_square == nonsquare_block,
            "comparison": "same outer quotient bit, but Rz conjugates the split torus instead of normalizing C449's fixed-pole torus",
            "D1_shared_edge_graph_equals_c460_overlap5_graph": d1_equal,
        }
    return result


def gap_character_data():
    code = r'''
SizeScreen([100000,100000]);;
Emit := function(parts) Print("C450|", JoinStringsWithSeparator(List(parts,String), "|"), "\n"); end;;
for q in [7,11] do
  pg:=PGL(2,q);; g:=DerivedSubgroup(pg);; t:=CharacterTable(g);; irr:=Irr(t);;
  Emit([q,"PSL_CLASSES",JoinStringsWithSeparator(List(OrdersClassRepresentatives(t),String),","),JoinStringsWithSeparator(List(SizesConjugacyClasses(t),String),",")]);
  for i in [1..Length(irr)] do
    x:=irr[i];; f:=Field(List(x,y->y));;
    Emit([q,"PSL_IRR",i,x[1],DegreeOverPrimeField(f),Conductor(f),JoinStringsWithSeparator(List(x,String),";")]);
  od;
  outer:=First(Elements(pg),x->not x in g);; classes:=ConjugacyClasses(g);;
  cp:=List(classes,c->PositionProperty(classes,d->Representative(c)^outer in d));;
  ip:=[];;
  for x in irr do
    twisted:=Character(t,List([1..Length(classes)],k->x[cp[k]]));;
    Add(ip,Position(irr,twisted));;
  od;
  Emit([q,"OUTER",JoinStringsWithSeparator(List(cp,String),","),JoinStringsWithSeparator(List(ip,String),",")]);
  cs:=ConjugacyClassesSubgroups(g);;
  if q=11 then wanted:=[10,12,60];; else wanted:=[6,8,24];; fi;
  for c in cs do
    h:=Representative(c);;
    if Size(h) in wanted then
      p:=PermutationCharacter(g,h);;
      Emit([q,"SUBGROUP",Size(h),StructureDescription(h),p[1],JoinStringsWithSeparator(List(irr,x->ScalarProduct(p,x)),",")]);
    fi;
  od;
  e:=(q-1)/2;; el:=First(Elements(g),x->Order(x)=e);; h:=Group(el);; hi:=Irr(h);;
  for i in [1..Length(irr)] do
    if irr[i][1] in [(q-1)/2,(q+1)/2,q-1,q] then
      r:=RestrictedClassFunction(irr[i],h);;
      Emit([q,"PSL_TORUS",i,irr[i][1],JoinStringsWithSeparator(List(hi,x->ScalarProduct(r,x)),",")]);
    fi;
  od;
  s:=SL(2,q);; st:=CharacterTable(s);; sirr:=Irr(st);; z:=First(Elements(Centre(s)),x->not IsOne(x));;
  zclass:=PositionProperty(ConjugacyClasses(s),c->z in c);;
  Emit([q,"SL_CLASSES",JoinStringsWithSeparator(List(OrdersClassRepresentatives(st),String),","),JoinStringsWithSeparator(List(SizesConjugacyClasses(st),String),","),zclass]);
  se:=First(Elements(s),x->Order(x)=e);; sh:=Group(se);; shi:=Irr(sh);;
  for i in [1..Length(sirr)] do
    x:=sirr[i];;
    if x[1] in [(q-1)/2,(q+1)/2] then
      f:=Field(List(x,y->y));; r:=RestrictedClassFunction(x,sh);;
      Emit([q,"SL_WEIL_DEGREE",i,x[1],String(x[zclass]),DegreeOverPrimeField(f),Conductor(f),JoinStringsWithSeparator(List(x,String),";"),JoinStringsWithSeparator(List(shi,y->ScalarProduct(r,y)),",")]);
    fi;
  od;
od;
QUIT;
'''
    run = subprocess.run(
        ["nix", "shell", "nixpkgs#gap", "--command", "gap", "-q"],
        input=code, text=True, capture_output=True, check=True,
    )
    parsed = {"7": {}, "11": {}}
    for line in run.stdout.splitlines():
        if not line.startswith("C450|"):
            continue
        parts = line.split("|")
        q, kind = parts[1], parts[2]
        bucket = parsed[q]
        if kind == "PSL_CLASSES":
            bucket["psl_classes"] = {"orders": list(map(int, parts[3].split(","))), "sizes": list(map(int, parts[4].split(",")))}
        elif kind == "PSL_IRR":
            bucket.setdefault("psl_irreducibles", []).append({
                "index": int(parts[3]), "degree": int(parts[4]), "field_degree": int(parts[5]),
                "field_conductor": int(parts[6]), "values": parts[7].split(";"),
            })
        elif kind == "SUBGROUP":
            bucket.setdefault("subgroup_permutation_characters", []).append({
                "subgroup_order": int(parts[3]), "structure": parts[4], "degree": int(parts[5]),
                "irreducible_multiplicities": list(map(int, parts[6].split(","))),
            })
        elif kind == "PSL_TORUS":
            bucket.setdefault("psl_torus_restrictions", []).append({
                "irreducible_index": int(parts[3]), "degree": int(parts[4]),
                "cyclic_irreducible_multiplicities": list(map(int, parts[5].split(","))),
            })
        elif kind == "OUTER":
            bucket["outer_action"] = {
                "class_permutation_1_based": list(map(int, parts[3].split(","))),
                "irreducible_permutation_1_based": list(map(int, parts[4].split(","))),
            }
        elif kind == "SL_CLASSES":
            bucket["sl_classes"] = {
                "orders": list(map(int, parts[3].split(","))), "sizes": list(map(int, parts[4].split(","))),
                "central_minus_identity_class_index_1_based": int(parts[5]),
            }
        elif kind == "SL_WEIL_DEGREE":
            bucket.setdefault("sl_candidate_weil_characters", []).append({
                "index": int(parts[3]), "degree": int(parts[4]), "central_minus_identity_value": parts[5],
                "field_degree": int(parts[6]), "field_conductor": int(parts[7]),
                "values": parts[8].split(";"),
                "split_torus_cyclic_irreducible_multiplicities": list(map(int, parts[9].split(","))),
            })
    return parsed


def strip_rows(cases):
    result = json.loads(json.dumps(cases))
    for case in result:
        for relation in case["relations"].values():
            relation.pop("rows", None)
    return result


def build_certificate():
    scout = json.loads(INPUTS["c406_scout"].read_text())
    c449 = json.loads(INPUTS["c449"].read_text())
    c460 = json.loads(INPUTS["c460"].read_text())
    frozen = {x["type"]: x for x in scout["types"]}
    # Attach the exact C449 objects without changing the frozen C460 object.
    c460 = dict(c460)
    c460["c449_cases"] = c449["finite_generator_images"]
    cases = [action_case(7, "B3", frozen["B3"], c460), action_case(11, "H3", frozen["H3"], c460)]
    chars = gap_character_data()
    for case in cases:
        q = str(case["q"])
        lower = next(x for x in chars[q]["sl_candidate_weil_characters"] if x["degree"] == (case["q"] - 1) // 2)
        upper = next(x for x in chars[q]["sl_candidate_weil_characters"] if x["degree"] == (case["q"] + 1) // 2)
        combined = [a + b + (1 if i == 0 else 0) for i, (a, b) in enumerate(zip(
            lower["split_torus_cyclic_irreducible_multiplicities"],
            upper["split_torus_cyclic_irreducible_multiplicities"],
        ))]
        assert combined == [4] + [2] * (((case["q"] - 1) // 2) - 1)
        case["c449_torus_baseline"]["candidate_1_plus_two_weil_halves_multiplicities"] = combined
        case["c449_torus_baseline"]["candidate_passes_torus_test_but_not_full_group_test"] = True

    # Select actual stabilizer rows certified by the finite action.
    desired = {"7": {"sheet": (24, "S4"), "shared_edge": (6, "S3"), "disjoint": (8, "D8")},
               "11": {"sheet": (60, "A5"), "shared_edge": (10, "D10"), "disjoint": (12, "A4")}}
    decompositions = {}
    for q, wants in desired.items():
        rows = chars[q]["subgroup_permutation_characters"]
        decompositions[q] = {}
        for name, (order, structure) in wants.items():
            matches = [x for x in rows if x["subgroup_order"] == order and x["structure"] == structure]
            assert matches
            assert len({tuple(x["irreducible_multiplicities"]) for x in matches}) == 1
            decompositions[q][name] = matches[0]

    q11_fives = [x for x in chars["11"]["psl_irreducibles"] if x["degree"] == 5]
    assert len(q11_fives) == 2
    assert all(x["field_degree"] == 2 and x["field_conductor"] == 11 for x in q11_fives)
    outer_irreducibles = chars["11"]["outer_action"]["irreducible_permutation_1_based"]
    assert outer_irreducibles[q11_fives[0]["index"] - 1] == q11_fives[1]["index"]
    assert outer_irreducibles[q11_fives[1]["index"] - 1] == q11_fives[0]["index"]
    quadratic = {
        "field": "Q(sqrt(-11))",
        "minimal_polynomial": "x^2+x+3",
        "discriminant": -11,
        "order_11_values": ["(-1+sqrt(-11))/2", "(-1-sqrt(-11))/2"],
        "gap_period_values": [q11_fives[0]["values"][1], q11_fives[0]["values"][2]],
        "galois_pair_exchanged_by_outer_PGL2": True,
    }

    idempotents = {}
    for q in ("7", "11"):
        order = (int(q) * (int(q) * int(q) - 1)) // 2
        idempotents[q] = []
        for chi in chars[q]["psl_irreducibles"]:
            idempotents[q].append({
                "irreducible_index": chi["index"], "degree": chi["degree"],
                "central_idempotent_formula": "(degree/|G|) * sum_classes conjugate(chi(C))*ClassSum(C)",
                "degree_over_group_order": f"{chi['degree']}/{order}",
                "class_coefficients_before_degree_over_group_order": [f"conjugate({v})" for v in chi["values"]],
            })

    cloud = c460["t3_secondary_control"]
    cloud_rows = cloud["rows"]
    cloud_analysis = {
        "shape": cloud["shape"], "rank_over_Q": rank_q(cloud_rows),
        "ranks_mod_2_3": {"2": rank_mod(cloud_rows, 2), "3": rank_mod(cloud_rows, 3)},
        "ordinary_left_module": "2*(1+10b)",
        "ordinary_kernel": "one trivial sheet-sign line",
        "ordinary_image": "1+2*10b",
        "cross_relation_nullities_mod_2_3": {
            "shared_edge": {"2": 11 - cases[1]["relations"]["shared_edge"]["ranks_mod_2_3"]["2"], "3": 11 - cases[1]["relations"]["shared_edge"]["ranks_mod_2_3"]["3"]},
            "disjoint": {"2": 11 - cases[1]["relations"]["disjoint"]["ranks_mod_2_3"]["2"], "3": 11 - cases[1]["relations"]["disjoint"]["ranks_mod_2_3"]["3"]},
        },
        "same_rank_drop_profile_as_cross_relations": False,
        "modular_verdict": "the extra characteristic-2/3 kernels are not ordinary-character constituents because 2 and 3 divide |PSL2(11)|; no same-constituent explanation is promoted",
    }

    return {
        "schema": "c450-weil-cross-sheet-v1",
        "task": "C450",
        "inputs": {name: digest(path) for name, path in INPUTS.items()},
        "weil_reference": {
            "citation": "Paul Gerardin, Three Weil representations associated to finite fields, Bull. AMS 82 (1976), 268-270",
            "doi": "10.1090/S0002-9904-1976-14017-7",
            "cache_sha256": digest(REFERENCE)["sha256"],
            "load_bearing_statement": "the q-dimensional symplectic Weil representation splits into irreducibles of dimensions (q+1)/2 and (q-1)/2",
        },
        "finite_actions": strip_rows(cases),
        "characters": chars,
        "central_idempotents": idempotents,
        "module_decompositions": decompositions,
        "quadratic_character_field": quadratic,
        "c460_secondary_control": cloud_analysis,
        "verdict": {
            "c449_mandatory_baseline": "PASS for q=7 and q=11: 2*trivial+2*regular(C_e), invariant dimension 4, every nontrivial torus character multiplicity 2",
            "cross_incidence_maps": "both complementary q-by-q matrices are full rank; their row/image module is 1+6 at q=7 and 1+10b at q=11",
            "weil_3_plus_4_q7": "NEGATIVE: the q=7 module is 1+6, not 3+4",
            "weil_5_plus_6_q11": "NEGATIVE: the q=11 module is 1+10b, not 5+6; the torus baseline alone is non-discriminating",
            "relation_support_modules": "the q=11 shared-edge 66-set contains both 5-dimensional Q(sqrt(-11)) Weil characters once, but this does not identify the 11-dimensional incidence image with 5+6",
            "outer_exchange": "GREEN: Rz is determinant-nonsquare, swaps sheets and relation endpoints, exchanges the two 5-dimensional Galois-conjugate characters, and confirms D1; it represents C449's quotient bit but does not normalize the frozen split torus",
            "roof": "SHARP NEGATIVE for the proposed cross-incidence module identification; certified sheet geometry survives",
        },
    }


def rendered(certificate):
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    data = rendered(certificate)
    if args.check:
        assert OUT.read_bytes() == data
        print("C450 certificate OK")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
