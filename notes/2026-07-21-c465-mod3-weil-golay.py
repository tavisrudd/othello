#!/usr/bin/env python3
"""C465 exact modular cross-sheet / Weil Brauer comparison."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-21-c465-mod3-weil-golay.json"
INPUTS = {
    "c406_scout": NOTES / "2026-07-20-c406-matching-orbit-scout.json",
    "c450": NOTES / "2026-07-21-c450-weil-cross-sheet.json",
    "c464": NOTES / "2026-07-21-c464-perfect-code-spans.json",
}


def digest(path: Path) -> dict[str, object]:
    data = path.read_bytes()
    return {"path": str(path), "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def normalize_matrix(a: int, b: int, c: int, d: int, q: int) -> tuple[int, int, int, int]:
    vals = (a % q, b % q, c % q, d % q)
    first = next(x for x in vals if x)
    inv = pow(first, q - 2, q)
    return tuple(x * inv % q for x in vals)


def pgl_matrices(q: int):
    return sorted({
        normalize_matrix(a, b, c, d, q)
        for a in range(q) for b in range(q) for c in range(q) for d in range(q)
        if (a * d - b * c) % q
    })


def determinant(g, q: int) -> int:
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


def orbit(base, permutations):
    return sorted({act_matching(p, base) for p in permutations})


def induced_permutation(permutation, objects):
    index = {obj: i for i, obj in enumerate(objects)}
    return tuple(index[act_matching(permutation, obj)] for obj in objects)


def rref(rows, p: int):
    a = [[x % p for x in row] for row in rows if any(x % p for x in row)]
    rank = 0
    width = len(rows[0]) if rows else 0
    for col in range(width):
        pivot = next((i for i in range(rank, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inv = pow(a[rank][col], p - 2, p)
        a[rank] = [x * inv % p for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][col]:
                scale = a[i][col]
                a[i] = [(x - scale * y) % p for x, y in zip(a[i], a[rank])]
        rank += 1
    return tuple(tuple(row) for row in a[:rank])


def nullspace(rows, p: int):
    rr = rref(rows, p)
    width = len(rows[0])
    pivots = [next(i for i, x in enumerate(row) if x) for row in rr]
    free = [i for i in range(width) if i not in pivots]
    basis = []
    for col in free:
        v = [0] * width
        v[col] = 1
        for row, pivot in zip(rr, pivots):
            v[pivot] = -row[col] % p
        basis.append(v)
    return rref(basis, p)


def all_vectors(basis, p: int):
    width = len(basis[0]) if basis else 0
    for coeffs in itertools.product(range(p), repeat=len(basis)):
        yield tuple(sum(c * basis[i][j] for i, c in enumerate(coeffs)) % p for j in range(width))


def in_span(v, basis, p: int) -> bool:
    return len(rref([*basis, v], p)) == len(basis)


def act_vector(v, perm):
    out = [0] * len(v)
    for i, x in enumerate(v):
        out[perm[i]] = x
    return tuple(out)


def module_closure(rows, generators, p: int):
    basis = rref(rows, p)
    while True:
        enlarged = rref([*basis, *(act_vector(v, g) for v in basis for g in generators)], p)
        if enlarged == basis:
            return basis
        basis = enlarged


def submodule_lattice(ambient, generators, p: int):
    zero: tuple[tuple[int, ...], ...] = ()
    found = {zero}
    vectors = list(all_vectors(ambient, p))
    changed = True
    while changed:
        changed = False
        for sub in list(found):
            for v in vectors:
                if in_span(v, sub, p):
                    continue
                candidate = module_closure([*sub, v], generators, p)
                if candidate not in found:
                    found.add(candidate)
                    changed = True
    ordered = sorted(found, key=lambda x: (len(x), x))
    return ordered


def coordinates(v, basis, p: int):
    # RREF basis: pivot coordinates directly give the expansion coefficients.
    pivots = [next(i for i, x in enumerate(row) if x) for row in basis]
    coeffs = tuple(v[i] % p for i in pivots)
    rebuilt = tuple(sum(coeffs[k] * basis[k][j] for k in range(len(basis))) % p for j in range(len(v)))
    assert rebuilt == tuple(x % p for x in v)
    return coeffs


def restricted_matrices(basis, generators, p: int):
    return [
        [list(coordinates(act_vector(v, g), basis, p)) for v in basis]
        for g in generators
    ]


def equivariant_retraction_test(ambient_basis, sub_basis, generators, p: int):
    """Test for an equivariant retraction ambient -> sub by one affine system."""
    a_mats = restricted_matrices(ambient_basis, generators, p)
    s_mats = restricted_matrices(sub_basis, generators, p)
    inclusion = [list(coordinates(v, ambient_basis, p)) for v in sub_basis]
    n, d = len(ambient_basis), len(sub_basis)
    equations = []
    rhs = []
    for a_mat, s_mat in zip(a_mats, s_mats):
        for i in range(n):
            for j in range(d):
                row = [0] * (n * d)
                for k in range(n):
                    row[k * d + j] = (row[k * d + j] + a_mat[i][k]) % p
                for ell in range(d):
                    row[i * d + ell] = (row[i * d + ell] - s_mat[ell][j]) % p
                equations.append(row)
                rhs.append(0)
    for a in range(d):
        for j in range(d):
            row = [0] * (n * d)
            for i in range(n):
                row[i * d + j] = inclusion[a][i]
            equations.append(row)
            rhs.append(int(a == j))
    coefficient_rank = len(rref(equations, p))
    augmented_rank = len(rref([row + [b] for row, b in zip(equations, rhs)], p))
    return {
        "unknowns": n * d,
        "equations": len(equations),
        "coefficient_rank": coefficient_rank,
        "augmented_rank": augmented_rank,
        "retraction_exists": coefficient_rank == augmented_rank,
    }


def commutant_dimension(basis, generators, p: int):
    mats = restricted_matrices(basis, generators, p)
    n = len(basis)
    equations = []
    for mat in mats:
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[k * n + j] = (row[k * n + j] + mat[i][k]) % p
                    row[i * n + k] = (row[i * n + k] - mat[k][j]) % p
                equations.append(row)
    rank = len(rref(equations, p))
    return {"unknowns": n * n, "equation_rank": rank, "dimension": n * n - rank}


def gram_matrix(basis, p: int):
    return [[sum(x * y for x, y in zip(a, b)) % p for b in basis] for a in basis]


def relation_rows(sheet0, sheet1, shared: bool):
    return [[int((len(set(left) & set(right)) == 1) if shared else (len(set(left) & set(right)) == 0))
             for right in sheet1] for left in sheet0]


def gap_list_matrix(matrix):
    return "[" + ",".join("[" + ",".join(map(str, row)) + "]" for row in matrix) + "]"


def gap_perm(perm):
    return "PermList([" + ",".join(str(x + 1) for x in perm) + "])"


def gap_brauer_data(cases):
    blocks = []
    for case in cases:
        q, p = case["q"], case["characteristic"]
        perms = case.pop("_generator_permutations")
        modules = case.pop("_module_matrices")
        module_code = []
        for name, mats in modules.items():
            module_code.append(
                f'mats:=[{gap_list_matrix(mats[0])}*One(GF({p})),{gap_list_matrix(mats[1])}*One(GF({p}))];; '
                f'mg:=Group(mats);; hom:=GroupHomomorphismByImages(g,mg,gens,mats);; '
                f'if not IsGroupHomomorphism(hom) then Error("bad module homomorphism"); fi;; '
                f'vals:=List(reg,i->BrauerCharacterValue(Image(hom,Representative(cls[i]))));; '
                f'Emit([{q},"MODULE","{name}",Length(mats[1]),JoinStringsWithSeparator(List(vals,String),";")]);;'
            )
        blocks.append(
            f'q:={q};; p:={p};; gp1:={gap_perm(perms[0])};; gp2:={gap_perm(perms[1])};; g:=Group(gp1,gp2);; gens:=[gp1,gp2];; '
            f'tcon:=CharacterTable(g);; cls:=ConjugacyClasses(g);; reg:=Filtered([1..Length(cls)],i->Order(Representative(cls[i])) mod p <> 0);; '
            f't:=CharacterTable(Concatenation("L2(",String(q),")"));; bt:=BrauerTable(t,p);; birr:=Irr(bt);; '
            f'Emit([q,"CONCRETE",JoinStringsWithSeparator(List(reg,i->String(Order(Representative(cls[i])))),","),JoinStringsWithSeparator(List(reg,i->String(Size(cls[i]))),",")]);; '
            f'Emit([q,"TABLE",Identifier(bt),JoinStringsWithSeparator(List(OrdersClassRepresentatives(bt),String),","),JoinStringsWithSeparator(List(SizesConjugacyClasses(bt),String),","),JoinStringsWithSeparator(List(birr,x->String(x[1])),",")]);; '
            f'Emit([q,"PSL_ORDINARY_DEGREES",JoinStringsWithSeparator(List(Irr(t),x->String(x[1])),",")]);; '
            f'for i in [1..Length(birr)] do Emit([q,"BRAUER",i,JoinStringsWithSeparator(List(birr[i],String),";")]); od;; '
            f'Emit([q,"BRAUER_DUALITY",JoinStringsWithSeparator(List(birr,x->String(Position(birr,ComplexConjugate(x)))),",")]);; '
            f'period:=MinimalPolynomial(Rationals,birr[2][Length(birr[2])]);; Emit([q,"LOWER_PERIOD",JoinStringsWithSeparator(List(CoefficientsOfUnivariatePolynomial(period),String),",")]);; '
            f'dm:=DecompositionMatrix(bt);; for i in [1..Length(dm)] do Emit([q,"PSL_DECOMP",i,JoinStringsWithSeparator(List(dm[i],String),",")]); od;; '
            f's:=CharacterTable(Concatenation("2.L2(",String(q),")"));; sb:=BrauerTable(s,p);; sbirr:=Irr(sb);; sdm:=DecompositionMatrix(sb);; '
            f'Emit([q,"SL_TABLE",Identifier(sb),JoinStringsWithSeparator(List(OrdersClassRepresentatives(sb),String),","),JoinStringsWithSeparator(List(SizesConjugacyClasses(sb),String),","),JoinStringsWithSeparator(List(sbirr,x->String(x[1])),",")]);; '
            f'for i in [1..Length(sbirr)] do Emit([q,"SL_BRAUER",i,JoinStringsWithSeparator(List(sbirr[i],String),";")]); od;; '
            f'for i in [1..Length(sdm)] do Emit([q,"SL_DECOMP",i,JoinStringsWithSeparator(List(sdm[i],String),",")]); od;; '
            f'z:=First([1..Length(OrdersClassRepresentatives(s))],i->OrdersClassRepresentatives(s)[i]=2 and SizesConjugacyClasses(s)[i]=1);; '
            f'for i in [1..Length(Irr(s))] do chi:=Irr(s)[i];; if chi[1] in [(q-1)/2,(q+1)/2] then Emit([q,"WEIL",i,chi[1],chi[z],JoinStringsWithSeparator(List(sdm[i],String),",")]); fi;; od;; '
            + "".join(module_code)
        )
    code = r'''SizeScreen([100000,100000]);;
Emit := function(parts) Print("C465|",JoinStringsWithSeparator(List(parts,String),"|"),"\n"); end;;
''' + "\n".join(blocks) + "\nQUIT;\n"
    run = subprocess.run(
        ["nix", "shell", "nixpkgs#gap", "--command", "gap", "-q"],
        input=code, text=True, capture_output=True, check=True,
    )
    if "C465|" not in run.stdout or "MODULE" not in run.stdout:
        raise RuntimeError(f"GAP modular-character pass failed:\n{run.stdout[-4000:]}\n{run.stderr[-4000:]}")
    parsed = {str(case["q"]): {"brauer_irreducibles": [], "psl_decomposition_matrix": [],
                                "sl_brauer_irreducibles": [], "sl_decomposition_matrix": [],
                                "weil_reductions": [], "modules": {}} for case in cases}
    for line in run.stdout.splitlines():
        if not line.startswith("C465|"):
            continue
        parts = line.split("|")
        bucket = parsed[parts[1]]
        if parts[2] == "TABLE":
            bucket["table"] = {"identifier": parts[3], "p_regular_class_orders": list(map(int, parts[4].split(","))),
                               "p_regular_class_sizes": list(map(int, parts[5].split(","))),
                               "irreducible_degrees": list(map(int, parts[6].split(",")))}
        elif parts[2] == "CONCRETE":
            bucket["concrete_p_regular_classes"] = {"orders": list(map(int, parts[3].split(","))),
                                                     "sizes": list(map(int, parts[4].split(",")))}
        elif parts[2] == "BRAUER":
            bucket["brauer_irreducibles"].append({"index": int(parts[3]), "values": parts[4].split(";")})
        elif parts[2] == "BRAUER_DUALITY":
            bucket["brauer_duality_permutation_1_based"] = list(map(int, parts[3].split(",")))
        elif parts[2] == "LOWER_PERIOD":
            bucket["lower_period_minimal_polynomial_coefficients_constant_first"] = list(map(int, parts[3].split(",")))
        elif parts[2] == "PSL_ORDINARY_DEGREES":
            bucket["psl_ordinary_degrees"] = list(map(int, parts[3].split(",")))
        elif parts[2] == "PSL_DECOMP":
            bucket["psl_decomposition_matrix"].append(list(map(int, parts[4].split(","))))
        elif parts[2] == "SL_TABLE":
            bucket["sl_table"] = {"identifier": parts[3], "p_regular_class_orders": list(map(int, parts[4].split(","))),
                                  "p_regular_class_sizes": list(map(int, parts[5].split(","))),
                                  "irreducible_degrees": list(map(int, parts[6].split(",")))}
        elif parts[2] == "SL_BRAUER":
            bucket["sl_brauer_irreducibles"].append({"index": int(parts[3]), "values": parts[4].split(";")})
        elif parts[2] == "SL_DECOMP":
            bucket["sl_decomposition_matrix"].append(list(map(int, parts[4].split(","))))
        elif parts[2] == "WEIL":
            bucket["weil_reductions"].append({"ordinary_index": int(parts[3]), "degree": int(parts[4]),
                                                "central_minus_identity_value": parts[5],
                                                "brauer_multiplicities_on_2cover": list(map(int, parts[6].split(",")))})
        elif parts[2] == "MODULE":
            bucket["modules"][parts[3]] = {"dimension": int(parts[4]), "brauer_values": parts[5].split(";"),
                                             "matching_irreducible_indices": []}
    return parsed


def identify_module_characters(data):
    concrete = data["concrete_p_regular_classes"]
    table = data["table"]
    candidates = []
    for perm in itertools.permutations(range(len(table["p_regular_class_orders"]))):
        if all(concrete["orders"][i] == table["p_regular_class_orders"][perm[i]] and
               concrete["sizes"][i] == table["p_regular_class_sizes"][perm[i]] for i in range(len(perm))):
            candidates.append(perm)
    assert candidates
    for module in data["modules"].values():
        matches = []
        for irr in data["brauer_irreducibles"]:
            if any(all(module["brauer_values"][i] == irr["values"][perm[i]] for i in range(len(perm))) for perm in candidates):
                matches.append(irr["index"])
        module["matching_irreducible_indices"] = matches
    data["class_bijections_preserving_order_size"] = [list(x) for x in candidates]


def build_case(q: int, p: int, type_name: str, frozen: dict):
    base = canon_matching(frozen["coxeter_invariant_matching"])
    matrices = pgl_matrices(q)
    pgl_perms = [point_permutation(g, q) for g in matrices]
    psl_perms = [perm for g, perm in zip(matrices, pgl_perms) if is_square(determinant(g, q), q)]
    all_matchings = orbit(base, pgl_perms)
    sheet0 = orbit(base, psl_perms)
    sheet1 = [m for m in all_matchings if m not in set(sheet0)]
    assert len(sheet0) == len(sheet1) == q

    gen_point = [point_permutation((1, 1, 0, 1), q), point_permutation((0, q - 1, 1, 0), q)]
    gen0 = [induced_permutation(g, sheet0) for g in gen_point]
    gen1 = [induced_permutation(g, sheet1) for g in gen_point]
    assert len(orbit(sheet0[0], gen_point + psl_perms)) == q

    rows = {"shared_edge": relation_rows(sheet0, sheet1, True), "disjoint": relation_rows(sheet0, sheet1, False)}
    m = (q + 1) // 4
    assert p == m
    grams = {name: [[sum(x * y for x, y in zip(a, b)) for b in matrix] for a in matrix]
             for name, matrix in rows.items()}
    assert grams["disjoint"] == [[m * int(i == j) + (m - 1) for j in range(q)] for i in range(q)]
    assert grams["shared_edge"] == [[m * (int(i == j) + 1) for j in range(q)] for i in range(q)]
    spaces = {}
    for relation, matrix in rows.items():
        span = rref(matrix, p)
        kernel = nullspace(matrix, p)
        assert module_closure(span, gen1, p) == span
        assert module_closure(kernel, gen1, p) == kernel
        spaces[f"{relation}_row_span"] = span
        spaces[f"{relation}_right_kernel"] = kernel

    assert spaces["shared_edge_row_span"] == spaces["disjoint_right_kernel"]
    assert spaces["disjoint_row_span"] == spaces["shared_edge_right_kernel"]
    small = spaces["shared_edge_row_span"]
    large = spaces["disjoint_row_span"]
    ones = tuple([1] * q)
    assert in_span(ones, large, p) and not in_span(ones, small, p)
    assert rref([*small, ones], p) == large

    lattices = {}
    for name, basis in (("simple_core", small), ("perfect_code", large)):
        lattice = submodule_lattice(basis, gen1, p)
        lattices[name] = {
            "dimension": len(basis),
            "submodule_dimensions": [len(x) for x in lattice],
            "submodule_bases": [[list(row) for row in sub] for sub in lattice],
            "is_simple": [len(x) for x in lattice] == [0, len(basis)],
        }
    assert lattices["simple_core"]["is_simple"]
    assert lattices["perfect_code"]["submodule_dimensions"] == [0, 1, len(small), len(large)]
    augmentation = rref([[int(i == j) - int(j == q - 1) for j in range(q)] for i in range(q - 1)], p)
    assert all(sum(v) % p == 0 for v in augmentation)
    assert all(in_span(v, augmentation, p) for v in small)
    retraction = equivariant_retraction_test(augmentation, small, gen1, p)
    assert not retraction["retraction_exists"]
    augmentation_gram = gram_matrix(augmentation, p)
    core_gram = gram_matrix(small, p)
    commutant = commutant_dimension(augmentation, gen1, p)
    assert len(rref(augmentation_gram, p)) == 2 * len(small)
    assert not any(any(row) for row in core_gram)
    assert commutant["dimension"] == 1

    return {
        "q": q, "characteristic": p, "type": type_name,
        "group": {"name": f"PSL_2({q})", "order": len(set(psl_perms)), "sheet_sizes": [len(sheet0), len(sheet1)]},
        "generator_point_matrices": [[1, 1, 0, 1], [0, q - 1, 1, 0]],
        "common_arithmetic_parameter": {
            "m_equals_(q+1)/4_equals_characteristic": m,
            "disjoint_gram_formula": "m*I + (m-1)*J",
            "shared_edge_gram_formula": "m*(I+J)",
            "mod_m_consequence": "disjoint Gram = -J (rank 1), shared-edge Gram = 0",
        },
        "relations": {name: {"rank": len(rref(matrix, p)), "nullity": q - len(rref(matrix, p)), "matrix": matrix}
                      for name, matrix in rows.items()},
        "spaces": {name: {"dimension": len(basis), "basis": [list(row) for row in basis]} for name, basis in spaces.items()},
        "module_structure": {
            "simple_core": lattices["simple_core"],
            "perfect_code": lattices["perfect_code"],
            "perfect_code_decomposition": "simple_core direct-sum all_one_trivial",
            "orthogonal_flag": "simple_core = perfect_code^perp",
            "socle": "whole perfect_code (semisimple)", "radical": "zero",
            "ambient_sheet": {
                "decomposition": "all_one_trivial direct-sum augmentation",
                "augmentation_dimension": len(augmentation),
                "augmentation_flag": "simple_core < augmentation with quotient dual(simple_core)",
                "extension_splits": False,
                "equivariant_retraction_test": retraction,
                "augmentation_socle": "simple_core",
                "augmentation_radical": "simple_core",
                "full_sheet_socle": "all_one_trivial direct-sum simple_core (= perfect_code)",
                "full_sheet_radical": "simple_core",
                "commutant": commutant,
                "invariant_form": {
                    "source": "coordinate dot product restricted to augmentation",
                    "rank": len(rref(augmentation_gram, p)),
                    "dimension": len(augmentation),
                    "core_gram_is_zero": True,
                    "core_is_lagrangian": True,
                    "type": "alternating symplectic" if p == 2 else "symmetric hyperbolic",
                    "unique_up_to_scalar": True,
                },
            },
        },
        "_generator_permutations": gen1,
        "_module_matrices": {
            "simple_core": restricted_matrices(small, gen1, p),
            "perfect_code": restricted_matrices(large, gen1, p),
        },
    }


def build_certificate():
    frozen_data = json.loads(INPUTS["c406_scout"].read_text())
    frozen = {x["type"]: x for x in frozen_data["types"]}
    cases = [build_case(7, 2, "B3", frozen["B3"]), build_case(11, 3, "H3", frozen["H3"])]
    brauer = gap_brauer_data(cases)
    for case in cases:
        q = str(case["q"])
        identify_module_characters(brauer[q])
        case["brauer"] = brauer[q]
        target_degree = case["q"] - 1
        candidates = [
            (i + 1, row) for i, (degree, row) in enumerate(zip(
                brauer[q]["psl_ordinary_degrees"], brauer[q]["psl_decomposition_matrix"]
            )) if degree == target_degree and sum(row) == 2
        ]
        assert len(candidates) == 1
        assert brauer[q]["brauer_duality_permutation_1_based"][1:3] == [3, 2]
        assert brauer[q]["lower_period_minimal_polynomial_coefficients_constant_first"] == [case["characteristic"], 1, 1]
        case["common_arithmetic_parameter"]["lower_period_minimal_polynomial"] = f"x^2+x+{case['characteristic']}"
        case["common_arithmetic_parameter"]["mod_characteristic_factorization"] = "x*(x+1)"
        case["ambient_permutation_cross_check"] = {
            "ordinary_sheet_character": f"1 + the degree-{target_degree} constituent selected by C450",
            "nontrivial_ordinary_row_index": candidates[0][0],
            "nontrivial_constituent_brauer_multiplicities": candidates[0][1],
            "ambient_composition_factors": "trivial plus both Galois-conjugate small simples",
            "flag_assignment": "perfect code contains trivial plus one small simple; ambient quotient is the conjugate small simple",
            "self_dual_sandwich": "simple_core < trivial+simple_core < ambient, with ambient/perfect_code isomorphic to dual(simple_core)",
            "small_simple_duality": "Brauer indices 2 and 3 are exchanged by duality",
        }

    # Exact verdicts from the computed module characters and 2-cover decomposition rows.
    q7, q11 = cases
    q7_core = q7["brauer"]["modules"]["simple_core"]["matching_irreducible_indices"]
    q11_core = q11["brauer"]["modules"]["simple_core"]["matching_irreducible_indices"]
    # The library table leaves the two equal-size p-regular classes unordered; the
    # frozen core is one member of the Galois pair, canonically determined only up
    # to that table automorphism.
    assert q7_core == [2, 3] and q11_core == [2, 3]
    for case in cases:
        case["brauer"]["modules"]["simple_core"]["composition_factors_up_to_table_galois"] = ["one of indices 2,3"]
        case["brauer"]["modules"]["perfect_code"]["composition_factors_up_to_table_galois"] = [1, "the same one of indices 2,3"]
    q7_upper = [x for x in q7["brauer"]["weil_reductions"] if x["degree"] == 4]
    q11_upper = [x for x in q11["brauer"]["weil_reductions"] if x["degree"] == 6]
    assert all(sum(x["brauer_multiplicities_on_2cover"]) == 2 for x in q7_upper)
    assert all(sum(x["brauer_multiplicities_on_2cover"]) == 1 and x["brauer_multiplicities_on_2cover"][6:] for x in q11_upper)

    verdict = {
        "q11_F3_PSL2_modules": "sharp negative: the Golay span is 1 plus a 5-dimensional simple PSL2 module, while each genuine 6-dimensional SL2 Weil reduction remains irreducible with central -1",
        "q11_lower_degree5": "positive for exactly one frozen 5-dimensional simple core, at the Brauer-character level",
        "q11_central_obstruction": "survives: -1 equals 2 in F3, so the genuine degree-6 reductions do not descend from SL2(11) to PSL2(11)",
        "q7_F2_control": "mixed positive: the 3-dimensional core matches one lower Weil reduction, and the 4-dimensional Hamming span has the same Brauer character 1+3 as one genuine upper reduction",
        "q7_central_obstruction": "dies for these lattice reductions because the scalar -I reduces to +I in F2; equivalently the central involution is invisible on every simple Brauer factor",
        "qualification": "Brauer-character equality records semisimplification; it does not identify a chosen integral Weil lattice reduction as an extension module",
    }
    return {
        "schema": "c465-mod3-weil-golay-v1",
        "inputs": {name: digest(path) for name, path in INPUTS.items()},
        "cases": cases,
        "verdict": verdict,
        "trusted_boundary": ["exact prime-field linear algebra", "exhaustive invariant-subspace generation inside dimensions at most 6",
                             "GAP 4.15 character/Brauer tables and exact BrauerCharacterValue"],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    text = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.check:
        if not OUT.exists() or OUT.read_text() != text:
            raise SystemExit("BLOCKER: tracked C465 certificate is stale")
        print("C465 check OK")
    else:
        OUT.write_text(text)
        print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
