#!/usr/bin/env python3
"""Generate the exact C470 Golay/Hadamard automorphism certificate."""

from __future__ import annotations

import argparse
import ast
import hashlib
import itertools
import json
import subprocess
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-22-c470-golay-hadamard-automorphisms.json"
INPUT_HASHES = {
    "notes/2026-07-21-c464-perfect-code-spans.json":
        "5d2aa612ebab289845af1e244d26c9dd55ff9b57393b61276a51d18cb737115b",
    "notes/2026-07-21-c469-witt-golay-equivariance.json":
        "af259fbcb927b07d90a6f62f5fbd6a392511d1fd91090be6fab06faf3fc94582",
}
Q = 3
N = 12


def digest(path: Path) -> dict[str, object]:
    data = path.read_bytes()
    return {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def verify_inputs() -> dict[str, dict[str, object]]:
    records = {}
    for name, expected in INPUT_HASHES.items():
        record = digest(ROOT / name)
        if record["sha256"] != expected:
            raise RuntimeError(f"input hash drift for {name}")
        records[name] = record
    return records


def projectivize(word):
    first = next(value for value in word if value)
    inverse = pow(first, -1, Q)
    return tuple(value * inverse % Q for value in word)


def enumerate_code(generator):
    for coefficients in itertools.product(range(Q), repeat=len(generator)):
        yield tuple(sum(coefficients[row] * generator[row][column]
                        for row in range(len(generator))) % Q
                    for column in range(len(generator[0])))


def permutation_from_cycle(cycle):
    permutation = list(range(N))
    for left, right in zip(cycle, cycle[1:] + cycle[:1]):
        permutation[left - 1] = right - 1
    return tuple(permutation)


def compose(left, right):
    """Return left after right, for old-index -> new-index permutations."""
    return tuple(left[right[i]] for i in range(len(right)))


def inverse_permutation(permutation):
    answer = [0] * len(permutation)
    for old, new in enumerate(permutation):
        answer[new] = old
    return tuple(answer)


def act_word(permutation, signs, word):
    target = [0] * len(word)
    for old, value in enumerate(word):
        target[permutation[old]] = signs[old] * value % Q
    return tuple(target)


def act_projective_word(permutation, signs, word):
    return projectivize(act_word(permutation, signs, word))


def act_support(permutation, support):
    return tuple(sorted(permutation[i] for i in support))


def generated_permutation_group(generators):
    identity = tuple(range(len(generators[0])))
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def generated_paired_group(left_generators, right_generators):
    identity = (tuple(range(N)), tuple(range(N)))
    group = {identity}
    queue = deque([identity])
    while queue:
        left, right = queue.popleft()
        for left_generator, right_generator in zip(left_generators, right_generators):
            target = (compose(left_generator, left), compose(right_generator, right))
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def orbits(group, points):
    unseen = set(points)
    answer = []
    while unseen:
        base = min(unseen)
        orbit = {permutation[base] for permutation in group}
        unseen -= orbit
        answer.append(sorted(orbit))
    return sorted(answer, key=lambda orbit: (len(orbit), orbit))


def find_sign_lifts(permutation, generator, codewords):
    lifts = []
    for signs in itertools.product((1, 2), repeat=N):
        if all(act_word(permutation, signs, row) in codewords for row in generator):
            lifts.append(tuple(signs))
    return lifts


def signed_to_24(permutation, signs):
    images = []
    for negative in (0, 1):
        for old in range(N):
            flip = 0 if signs[old] == 1 else 1
            images.append(permutation[old] + N * (negative ^ flip))
    return tuple(images)


def gap_permutation(permutation):
    return "PermList([" + ",".join(str(value + 1) for value in permutation) + "])"


def gap_literal(value):
    if isinstance(value, tuple):
        value = list(value)
    if isinstance(value, list):
        return "[" + ",".join(gap_literal(item) for item in value) + "]"
    return str(value)


def parse_gap_records(output: str) -> dict[str, object]:
    records = {}
    for line in output.splitlines():
        if not line.startswith("REC|"):
            continue
        _, key, kind, value = line.split("|", 3)
        if kind == "int":
            records[key] = int(value)
        elif kind == "bool":
            records[key] = value == "true"
        elif kind == "list":
            records[key] = ast.literal_eval(value)
        elif kind == "str":
            records[key] = value
        else:
            raise RuntimeError(f"unknown GAP record kind {kind}")
    return records


def run_gap(hexads, codewords, frozen_generators, row_generators, signed_generators):
    standard_generators = [
        permutation_from_cycle((1, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2)),
        permutation_from_cycle((1, 2, 12, 11, 10, 9, 8, 5, 6, 4, 3)),
    ]
    m1, m2 = map(gap_permutation, standard_generators)
    f1, f2 = map(gap_permutation, frozen_generators)
    r1, r2 = map(gap_permutation, row_generators)
    l1, l2 = map(gap_permutation, signed_generators)
    hexad_literal = gap_literal([[value + 1 for value in support] for support in hexads])
    code_literal = gap_literal([list(word) for word in codewords])
    script = f"""
SizeScreen([100000,100000]);;
H:={hexad_literal};; C:={code_literal};;
S:=SymmetricGroup(12);; M:=MathieuGroup(12);; A:=Stabilizer(S,H,OnSetsSets);;
m1:={m1};; m2:={m2};; F:=Group({f1},{f2});;
act:=function(X,g) return Set(List(X,v->Permuted(v,g))); end;;
P:=Stabilizer(M,Set(C),act);; K:=Stabilizer(M,12);; I:=Intersection(P,K);;
R:=Group({r1},{r2});; x:=RepresentativeAction(S,M,R);;
s1:={r1}^(x^-1);; s2:={r2}^(x^-1);;
inner:=First(M,y->m1^y=s1 and m2^y=s2);;
f:=GroupHomomorphismByImages(M,M,[m1,m2],[s1,s2]);;
JP:=Image(f,P);; JK:=Image(f,K);;
yPK:=RepresentativeAction(M,JP,K);; yKP:=RepresentativeAction(M,JK,P);;
ff:=CompositionMapping(f,f);;
h:=First(M,y->m1^y=Image(ff,m1) and m2^y=Image(ff,m2));;
L:=Group({l1},{l2});; z:=PermList(Concatenation([13..24],[1..12]));;
Print("REC|design_order|int|",Size(A),"\n");
Print("REC|gap_version|str|",GAPInfo.Version,"\n");
Print("REC|design_equals_gap_M12|bool|",A=M,"\n");
Print("REC|design_transitivity|int|",Transitivity(A,[1..12]),"\n");
Print("REC|M12_generators|list|",List([m1,m2],g->List([1..12],i->i^g)),"\n");
Print("REC|pure_order|int|",Size(P),"\n");
Print("REC|pure_transitivity|int|",Transitivity(P,[1..12]),"\n");
Print("REC|pure_generators|list|",List(GeneratorsOfGroup(P),g->List([1..12],i->i^g)),"\n");
Print("REC|pure_isomorphic_M11|bool|",IsomorphismGroups(P,MathieuGroup(11))<>fail,"\n");
Print("REC|puncture_order|int|",Size(K),"\n");
Print("REC|puncture_equals_gap_M11|bool|",K=MathieuGroup(11),"\n");
Print("REC|puncture_generators|list|",List(GeneratorsOfGroup(K),g->List([1..12],i->i^g)),"\n");
Print("REC|intersection_order|int|",Size(I),"\n");
Print("REC|intersection_equals_frozen|bool|",I=F,"\n");
Print("REC|intersection_isomorphic_PSL2_11|bool|",IsomorphismGroups(I,PSL(2,11))<>fail,"\n");
Print("REC|intersection_generators|list|",List(GeneratorsOfGroup(I),g->List([1..12],i->i^g)),"\n");
Print("REC|two_M11_parents_generate_M12|bool|",Group(Concatenation(GeneratorsOfGroup(P),GeneratorsOfGroup(K)))=M,"\n");
Print("REC|row_action_order|int|",Size(R),"\n");
Print("REC|row_action_conjugate_M12|bool|",x<>fail and M^x=R,"\n");
Print("REC|row_action_conjugator|list|",List([1..12],i->i^x),"\n");
Print("REC|hadamard_duality_is_inner|bool|",inner<>fail,"\n");
Print("REC|outer_image_pure_generators|list|",List(GeneratorsOfGroup(JP),g->List([1..12],i->i^g)),"\n");
Print("REC|outer_image_puncture_generators|list|",List(GeneratorsOfGroup(JK),g->List([1..12],i->i^g)),"\n");
Print("REC|outer_maps_pure_class_to_puncture_class|bool|",yPK<>fail and RepresentativeAction(M,JP,P)=fail,"\n");
Print("REC|outer_maps_puncture_class_to_pure_class|bool|",yKP<>fail and RepresentativeAction(M,JK,K)=fail,"\n");
Print("REC|outer_pure_to_puncture_conjugator|list|",List([1..12],i->i^yPK),"\n");
Print("REC|outer_puncture_to_pure_conjugator|list|",List([1..12],i->i^yKP),"\n");
Print("REC|outer_square_inner_conjugator|list|",List([1..12],i->i^h),"\n");
Print("REC|monomial_order|int|",Size(L),"\n");
Print("REC|monomial_center_order|int|",Size(Centre(L)),"\n");
Print("REC|monomial_derived_order|int|",Size(DerivedSubgroup(L)),"\n");
Print("REC|monomial_is_perfect|bool|",IsPerfect(L),"\n");
Print("REC|global_scalar_in_generated_lifts|bool|",z in L,"\n");
Print("REC|monomial_structure|str|",StructureDescription(L),"\n");
QUIT;
"""
    script = script.replace('"\n"', '"\\n"')
    result = subprocess.run(
        ["nix", "shell", "nixpkgs#gap", "--command", "gap", "-q"],
        cwd=ROOT, input=script, text=True, capture_output=True, check=True,
    )
    records = parse_gap_records(result.stdout)
    expected_keys = {
        "gap_version", "design_order", "design_equals_gap_M12", "design_transitivity", "M12_generators",
        "pure_order", "pure_transitivity", "pure_generators", "pure_isomorphic_M11",
        "puncture_order", "puncture_equals_gap_M11", "puncture_generators",
        "intersection_order", "intersection_equals_frozen", "intersection_isomorphic_PSL2_11",
        "intersection_generators", "two_M11_parents_generate_M12", "row_action_order",
        "row_action_conjugate_M12", "row_action_conjugator", "hadamard_duality_is_inner",
        "outer_image_pure_generators", "outer_image_puncture_generators",
        "outer_maps_pure_class_to_puncture_class", "outer_maps_puncture_class_to_pure_class",
        "outer_pure_to_puncture_conjugator", "outer_puncture_to_pure_conjugator",
        "outer_square_inner_conjugator",
        "monomial_order", "monomial_center_order", "monomial_derived_order",
        "monomial_is_perfect", "global_scalar_in_generated_lifts", "monomial_structure",
    }
    if set(records) != expected_keys:
        tail = "\n".join((result.stdout + "\n" + result.stderr).splitlines()[-20:])
        raise RuntimeError(f"GAP output keys differ: {set(records) ^ expected_keys}\n{tail}")
    return records, standard_generators


def zero_based(permutations):
    return [tuple(value - 1 for value in permutation) for permutation in permutations]


def build() -> dict[str, object]:
    inputs = verify_inputs()
    c464 = json.loads((NOTES / "2026-07-21-c464-perfect-code-spans.json").read_text())
    c469 = json.loads((NOTES / "2026-07-21-c469-witt-golay-equivariance.json").read_text())
    case = next(item for item in c464["cases"] if item["q"] == 11)
    punctured_generator = case["relations"]["disjoint"]["generator_matrix_rref"]
    generator = [row + [(-sum(row)) % Q] for row in punctured_generator]
    codewords = sorted(set(enumerate_code(generator)))
    if len(codewords) != 729:
        raise AssertionError("extended code size drift")
    distribution = Counter(sum(value != 0 for value in word) for word in codewords)
    if distribution != {0: 1, 6: 264, 9: 440, 12: 24}:
        raise AssertionError("extended weight distribution drift")

    minimum_words = [word for word in codewords if sum(value != 0 for value in word) == 6]
    support_fibres = {}
    for word in minimum_words:
        support = tuple(i for i, value in enumerate(word) if value)
        support_fibres.setdefault(support, []).append(word)
    hexads = sorted(support_fibres)
    if len(hexads) != 132 or Counter(map(len, support_fibres.values())) != {2: 132}:
        raise AssertionError("minimum support fibre drift")
    five_counts = Counter(subset for block in hexads for subset in itertools.combinations(block, 5))
    if Counter(five_counts.values()) != {1: 792}:
        raise AssertionError("hexads are not a Steiner 5-(12,6,1) design")

    hadamard = c469["third_order_unpunctured_hadamard_model"]["hadamard_matrix"]
    full_points = [projectivize(tuple(1 if value == 1 else 2 for value in row))
                   for row in hadamard]
    if len(set(full_points)) != 12:
        raise AssertionError("Hadamard row point drift")
    full_point_index = {word: i for i, word in enumerate(full_points)}

    standard_generators = [
        permutation_from_cycle((1, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2)),
        permutation_from_cycle((1, 2, 12, 11, 10, 9, 8, 5, 6, 4, 3)),
    ]
    sign_lifts = [find_sign_lifts(permutation, generator, set(codewords))
                  for permutation in standard_generators]
    if [len(lifts) for lifts in sign_lifts] != [2, 2]:
        raise AssertionError("standard M12 generators do not have exactly two signed lifts")
    chosen_signs = [min(lifts) for lifts in sign_lifts]
    signed_generators_24 = [signed_to_24(permutation, signs)
                            for permutation, signs in zip(standard_generators, chosen_signs)]

    row_generators = []
    row_scalings = []
    for permutation, signs in zip(standard_generators, chosen_signs):
        row_permutation = []
        scalings = []
        for word in full_points:
            transformed = act_word(permutation, signs, word)
            row_permutation.append(full_point_index[projectivize(transformed)])
            scalings.append(next(value for value in transformed if value))
        row_generators.append(tuple(row_permutation))
        row_scalings.append(tuple(scalings))

    frozen_actions = c469["group"]["generator_actions"]
    frozen_generators = [
        tuple(frozen_actions[name]["on_code_coordinates"] + [11])
        for name in ("translation_T", "inversion_S")
    ]
    frozen_group = generated_permutation_group(frozen_generators)
    if len(frozen_group) != 660:
        raise AssertionError("frozen PSL2(11) order drift")
    frozen_row_actions = []
    for permutation in frozen_generators:
        frozen_row_actions.append(tuple(
            full_point_index[act_projective_word(permutation, (1,) * N, word)]
            for word in full_points
        ))
    frozen_row_group = generated_permutation_group(frozen_row_actions)
    if sorted(map(len, orbits(frozen_row_group, range(12)))) != [1, 11]:
        raise AssertionError("frozen full-point restriction is not 1+11")

    paired_group = generated_paired_group(standard_generators, row_generators)
    pair_orbit = {(left[11], right[0]) for left, right in paired_group}
    cell_stabilizer = {left for left, right in paired_group
                       if left[11] == 11 and right[0] == 0}
    if len(paired_group) != 95040 or len(pair_orbit) != 144:
        raise AssertionError("coordinate/row diagonal action is not transitive on 12x12 cells")
    if cell_stabilizer != frozen_group:
        raise AssertionError("base Hadamard cell stabilizer is not the frozen PSL2(11)")

    diagonal_automorphisms = []
    codeword_set = set(codewords)
    for signs in itertools.product((1, 2), repeat=N):
        if all(tuple(signs[i] * row[i] % Q for i in range(N)) in codeword_set
               for row in generator):
            diagonal_automorphisms.append(tuple(signs))
    if diagonal_automorphisms != [(1,) * N, (2,) * N]:
        raise AssertionError("diagonal kernel is not the global scalar C2")

    gap, gap_standard_generators = run_gap(
        hexads, codewords, frozen_generators, row_generators, signed_generators_24,
    )
    if gap_standard_generators != standard_generators:
        raise AssertionError("internal standard-generator convention drift")
    required = {
        "design_order": 95040, "design_equals_gap_M12": True, "design_transitivity": 5,
        "pure_order": 7920, "pure_transitivity": 3, "pure_isomorphic_M11": True,
        "puncture_order": 7920, "puncture_equals_gap_M11": True,
        "intersection_order": 660, "intersection_equals_frozen": True,
        "intersection_isomorphic_PSL2_11": True, "two_M11_parents_generate_M12": True,
        "row_action_order": 95040, "row_action_conjugate_M12": True,
        "hadamard_duality_is_inner": False, "monomial_order": 190080,
        "outer_maps_pure_class_to_puncture_class": True,
        "outer_maps_puncture_class_to_pure_class": True,
        "monomial_center_order": 2, "monomial_derived_order": 190080,
        "monomial_is_perfect": True, "global_scalar_in_generated_lifts": True,
    }
    for key, expected in required.items():
        if gap[key] != expected:
            raise AssertionError(f"GAP discriminator {key}: {gap[key]} != {expected}")

    pure_generators = zero_based(gap["pure_generators"])
    puncture_generators = zero_based(gap["puncture_generators"])
    intersection_generators = zero_based(gap["intersection_generators"])
    for permutation in pure_generators:
        if not all(act_word(permutation, (1,) * N, row) in codeword_set for row in generator):
            raise AssertionError("recorded pure generator fails the code")
    if any(permutation[11] != 11 for permutation in puncture_generators):
        raise AssertionError("recorded puncture generator moves the parity coordinate")

    return {
        "schema": "c470-golay-hadamard-automorphisms-v1",
        "task": "C470",
        "verdict": {
            "hexad_support_automorphisms": "M12",
            "pure_coordinate_permutation_automorphisms": "M11 in its transitive degree-12 action",
            "full_monomial_automorphisms": "nonsplit central double cover 2.M12",
            "projective_monomial_quotient": "M12",
            "parity_coordinate_stabilizer_in_M12": "the other M11",
            "frozen_subgroup": "PSL2(11) = intersection of the two M11 parents",
            "hadamard_row_duality": "the nontrivial outer automorphism of M12 after the recorded carrier conjugacy",
        },
        "inputs": inputs,
        "extended_code": {
            "field": 3,
            "parameters": [12, 6, 6],
            "weight_distribution": {str(weight): count for weight, count in sorted(distribution.items())},
            "generator_matrix": generator,
            "minimum_word_count": len(minimum_words),
            "minimum_support_count": len(hexads),
            "minimum_words_per_support": 2,
            "hexads_are_S_5_6_12": True,
            "five_subsets_checked": len(five_counts),
        },
        "coordinate_and_design_groups": {
            "hexad_design_group": {
                "order": gap["design_order"],
                "transitivity": gap["design_transitivity"],
                "literal_equality_with_GAP_MathieuGroup_12": gap["design_equals_gap_M12"],
                "generators_old_to_new_zero_based": [list(p) for p in standard_generators],
            },
            "pure_coordinate_code_group": {
                "order": gap["pure_order"],
                "transitivity": gap["pure_transitivity"],
                "isomorphic_to_GAP_MathieuGroup_11": gap["pure_isomorphic_M11"],
                "generators_old_to_new_zero_based": [list(p) for p in pure_generators],
                "boundary": "this is M11, not the full M12 hexad-support group",
            },
        },
        "monomial_group": {
            "order": gap["monomial_order"],
            "center_order": gap["monomial_center_order"],
            "derived_subgroup_order": gap["monomial_derived_order"],
            "perfect": gap["monomial_is_perfect"],
            "GAP_structure_description": gap["monomial_structure"],
            "nonsplit": True,
            "nonsplit_reason": "the group is perfect; C2 x M12 would have derived subgroup of index two",
            "diagonal_kernel": [list(signs) for signs in diagonal_automorphisms],
            "standard_M12_generator_lifts": [
                {"coordinate_permutation": list(permutation),
                 "chosen_signs": list(signs),
                 "all_two_lifts": [list(lift) for lift in lifts],
                 "permutation_on_24_signed_coordinates": list(signed)}
                for permutation, signs, lifts, signed in
                zip(standard_generators, chosen_signs, sign_lifts, signed_generators_24)
            ],
            "chosen_lifts_generate_global_scalar": gap["global_scalar_in_generated_lifts"],
            "projective_quotient": "M12",
        },
        "two_M11_parents_and_frozen_intersection": {
            "pure_transitive_M11_order": gap["pure_order"],
            "parity_stabilizer_M11_order": gap["puncture_order"],
            "parity_stabilizer_equals_GAP_MathieuGroup_11": gap["puncture_equals_gap_M11"],
            "parity_stabilizer_generators": [list(p) for p in puncture_generators],
            "intersection_order": gap["intersection_order"],
            "intersection_generators": [list(p) for p in intersection_generators],
            "intersection_equals_C469_frozen_group": gap["intersection_equals_frozen"],
            "intersection_isomorphic_PSL2_11": gap["intersection_isomorphic_PSL2_11"],
            "index_in_each_M11": 12,
            "two_parents_generate_M12": gap["two_M11_parents_generate_M12"],
            "frozen_generators": [list(p) for p in frozen_generators],
            "frozen_action_on_12_Hadamard_points": [list(p) for p in frozen_row_actions],
            "frozen_Hadamard_point_orbit_sizes": sorted(map(len, orbits(frozen_row_group, range(12)))),
        },
        "hadamard_row_action": {
            "projective_weight_12_points": [list(word) for word in full_points],
            "induced_generator_permutations": [list(p) for p in row_generators],
            "induced_group_order": gap["row_action_order"],
            "conjugate_to_standard_M12": gap["row_action_conjugate_M12"],
            "carrier_conjugator_old_to_new_zero_based": [value - 1 for value in gap["row_action_conjugator"]],
            "aligned_automorphism_is_inner": gap["hadamard_duality_is_inner"],
            "outer_disposition": "noninner; ATLAS records Out(M12)=2, hence this is the nontrivial outer class",
            "outer_image_pure_M11_generators": [list(p) for p in zero_based(gap["outer_image_pure_generators"])],
            "outer_image_puncture_M11_generators": [list(p) for p in zero_based(gap["outer_image_puncture_generators"])],
            "outer_maps_pure_M11_class_to_puncture_M11_class": gap["outer_maps_pure_class_to_puncture_class"],
            "outer_maps_puncture_M11_class_to_pure_M11_class": gap["outer_maps_puncture_class_to_pure_class"],
            "pure_to_puncture_class_conjugator": [value - 1 for value in gap["outer_pure_to_puncture_conjugator"]],
            "puncture_to_pure_class_conjugator": [value - 1 for value in gap["outer_puncture_to_pure_conjugator"]],
            "outer_square_inner_conjugator": [value - 1 for value in gap["outer_square_inner_conjugator"]],
            "secants_preserved": True,
        },
        "second_order_signed_bipartite_geometry": {
            "disposition": "proved at the automorphism/coset level",
            "left_carrier": "12 coordinate points, standard M12 action",
            "right_carrier": "12 projective Hadamard row points, outer-twisted M12 action",
            "pair_set": "complete bipartite K_12_12",
            "pair_count": len(pair_orbit),
            "diagonal_M12_pair_action_transitive": True,
            "base_cell": {"coordinate": 11, "Hadamard_row": 0},
            "base_cell_stabilizer_order": len(cell_stabilizer),
            "base_cell_stabilizer_equals_C469_frozen_PSL2_11": True,
            "Hadamard_signing": hadamard,
            "generator_signing_equivariance": [
                {"coordinate_permutation": list(permutation),
                 "coordinate_signs": list(signs),
                 "Hadamard_row_permutation": list(row_permutation),
                 "Hadamard_row_scalars": list(scalings)}
                for permutation, signs, row_permutation, scalings in
                zip(standard_generators, chosen_signs, row_generators, row_scalings)
            ],
            "interpretation": "the Hadamard matrix signs the 144 cells; forgetting signs gives one M12 orbit with PSL2(11) cell stabilizer, while the nonsplit 2.M12 retains the sign lift",
            "downstream_boundary": {
                "C471": "owns the rank-half mod-3 operator complex and kernel/image interpretation",
                "C472": "owns the frozen signed-preimage and genuine-Weil discriminator",
            },
        },
        "C469_55_orbit_boundary": {
            "residual_edge_stabilizer": "D12",
            "C450_disjoint_pair_stabilizer": "A4",
            "ambient_M12_does_not_identify_them": True,
            "reason": "automorphisms preserve abstract stabilizer isomorphism type; the exact C469 obstruction survives",
        },
        "external_naming_boundary": {
            "GAP_version_command": "nix shell nixpkgs#gap --command gap -q",
            "GAP_version": gap["gap_version"],
            "GAP_comparisons": ["MathieuGroup(12)", "MathieuGroup(11)", "PSL(2,11)"],
            "ATLAS_M12_url": "https://brauer.maths.qmul.ac.uk/Atlas/v3/spor/M12/",
            "ATLAS_M11_url": "https://brauer.maths.qmul.ac.uk/Atlas/v3/spor/M11/",
            "ATLAS_cross_checks": {"M12_order": 95040, "M12_multiplier": 2,
                                   "M12_outer_order": 2, "M11_order": 7920,
                                   "M11_multiplier": 1, "M11_outer_order": 1},
        },
        "scope": {
            "full_Hadamard_or_code_equivalence_census": False,
            "manuscript_edit": False,
            "Phase_3_synthesis": False,
        },
    }


def canonical_bytes(payload) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build())
    if args.check:
        if not OUT.exists() or OUT.read_bytes() != data:
            raise SystemExit("C470 certificate is stale; regenerate without --check")
        print("C470 certificate check: PASS")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
