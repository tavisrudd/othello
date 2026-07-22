#!/usr/bin/env python3
"""Independent replay for the C465 modular module certificate."""

from __future__ import annotations

import hashlib
import itertools
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
CERT = NOTES / "2026-07-21-c465-mod3-weil-golay.json"
SCOUT = NOTES / "2026-07-20-c406-matching-orbit-scout.json"


def canon(pairs):
    return tuple(sorted(tuple(sorted(pair)) for pair in pairs))


def point_action(g, x, q):
    a, b, c, d = g
    if x == q:
        return q if c == 0 else a * pow(c, q - 2, q) % q
    den = (c * x + d) % q
    return q if den == 0 else (a * x + b) * pow(den, q - 2, q) % q


def point_perm(g, q):
    return tuple(point_action(g, x, q) for x in range(q + 1))


def image_matching(m, perm):
    return canon((perm[a], perm[b]) for a, b in m)


def orbit(seed, generators):
    seen = {seed}
    todo = [seed]
    while todo:
        x = todo.pop()
        for g in generators:
            y = image_matching(x, g)
            if y not in seen:
                seen.add(y)
                todo.append(y)
    return sorted(seen)


def induced(g, objects):
    pos = {x: i for i, x in enumerate(objects)}
    return tuple(pos[image_matching(x, g)] for x in objects)


def echelon(rows, p):
    a = [[x % p for x in row] for row in rows if any(x % p for x in row)]
    width = len(rows[0]) if rows else 0
    pivots = []
    for col in range(width):
        pivot = next((i for i in range(len(pivots), len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        k = len(pivots)
        a[k], a[pivot] = a[pivot], a[k]
        inv = pow(a[k][col], p - 2, p)
        a[k] = [x * inv % p for x in a[k]]
        for i in range(len(a)):
            if i != k and a[i][col]:
                c = a[i][col]
                a[i] = [(x - c * y) % p for x, y in zip(a[i], a[k])]
        pivots.append(col)
    return tuple(tuple(x) for x in a[:len(pivots)])


def vectors(basis, p):
    width = len(basis[0]) if basis else 0
    for cs in itertools.product(range(p), repeat=len(basis)):
        yield tuple(sum(cs[i] * basis[i][j] for i in range(len(basis))) % p for j in range(width))


def vector_image(v, perm):
    w = [0] * len(v)
    for i, x in enumerate(v):
        w[perm[i]] = x
    return tuple(w)


def cyclic(v, generators, p):
    basis = echelon([v], p)
    while True:
        nxt = echelon([*basis, *(vector_image(x, g) for x in basis for g in generators)], p)
        if nxt == basis:
            return basis
        basis = nxt


def coords(v, basis, p):
    pivots = [next(i for i, x in enumerate(row) if x) for row in basis]
    cs = tuple(v[i] for i in pivots)
    assert tuple(sum(cs[i] * basis[i][j] for i in range(len(basis))) % p for j in range(len(v))) == v
    return cs


def gap_matrix(m):
    return "[" + ",".join("[" + ",".join(map(str, row)) + "]" for row in m) + "]"


def gap_perm(p):
    return "PermList([" + ",".join(str(x + 1) for x in p) + "])"


def brauer_values(perms, bases, p, q):
    chunks = []
    for name, basis in bases.items():
        mats = []
        for g in perms:
            mats.append([list(coords(vector_image(v, g), basis, p)) for v in basis])
        chunks.append(
            f'm:=[{gap_matrix(mats[0])}*One(GF({p})),{gap_matrix(mats[1])}*One(GF({p}))];; '
            f'mg:=Group(m);; h:=GroupHomomorphismByImages(g,mg,[a,b],m);; '
            f'Print("REPLAY|{name}|",JoinStringsWithSeparator(List(reg,i->BrauerCharacterValue(Image(h,Representative(cls[i])))),";"),"\\n");;'
        )
    code = (f'SizeScreen([100000,100000]);; a:={gap_perm(perms[0])};; b:={gap_perm(perms[1])};; g:=Group(a,b);; '
            f'cls:=ConjugacyClasses(g);; reg:=Filtered([1..Length(cls)],i->Order(Representative(cls[i])) mod {p}<>0);; '
            f'Print("REPLAY|CLASSES|",JoinStringsWithSeparator(List(reg,i->String(Order(Representative(cls[i])))),","),";",JoinStringsWithSeparator(List(reg,i->String(Size(cls[i]))),","),"\\n");; '
            f'bt:=BrauerTable(CharacterTable("L2({q})"),{p});; mp:=MinimalPolynomial(Rationals,Irr(bt)[2][Length(Irr(bt)[2])]);; Print("REPLAY|PERIOD|",JoinStringsWithSeparator(List(CoefficientsOfUnivariatePolynomial(mp),String),","),"\\n");; '
            + "".join(chunks) + "QUIT;\n")
    run = subprocess.run(["nix", "shell", "nixpkgs#gap", "--command", "gap", "-q"],
                         input=code, text=True, capture_output=True, check=True)
    answer = {}
    for line in run.stdout.splitlines():
        if line.startswith("REPLAY|CLASSES|"):
            _, _, payload = line.split("|")
            orders, sizes = payload.split(";")
            answer["_classes"] = {"orders": list(map(int, orders.split(","))), "sizes": list(map(int, sizes.split(",")))}
        elif line.startswith("REPLAY|PERIOD|"):
            answer["_period"] = list(map(int, line.split("|")[2].split(",")))
        elif line.startswith("REPLAY|"):
            _, name, values = line.split("|")
            answer[name] = values.split(";")
    return answer


def no_retraction_ranks(ambient, sub, generators, p):
    def matrices(basis):
        return [[[coords(vector_image(v, g), basis, p)[j] for j in range(len(basis))]
                 for v in basis] for g in generators]
    aa, ss = matrices(ambient), matrices(sub)
    inc = [coords(v, ambient, p) for v in sub]
    n, d = len(ambient), len(sub)
    left, augmented = [], []
    for am, sm in zip(aa, ss):
        for i in range(n):
            for j in range(d):
                row = [0] * (n * d)
                for k in range(n):
                    row[k * d + j] = (row[k * d + j] + am[i][k]) % p
                for k in range(d):
                    row[i * d + k] = (row[i * d + k] - sm[k][j]) % p
                left.append(row)
                augmented.append(row + [0])
    for i in range(d):
        for j in range(d):
            row = [0] * (n * d)
            for k in range(n):
                row[k * d + j] = inc[i][k]
            left.append(row)
            augmented.append(row + [int(i == j)])
    return len(echelon(left, p)), len(echelon(augmented, p)), len(left), n * d


def commutant_rank(basis, generators, p):
    mats = [[[coords(vector_image(v, g), basis, p)[j] for j in range(len(basis))]
             for v in basis] for g in generators]
    n = len(basis)
    equations = []
    for m in mats:
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[k * n + j] = (row[k * n + j] + m[i][k]) % p
                    row[i * n + k] = (row[i * n + k] - m[k][j]) % p
                equations.append(row)
    return len(echelon(equations, p)), n * n


def main():
    cert = json.loads(CERT.read_text())
    scout = json.loads(SCOUT.read_text())
    frozen = {x["type"]: x for x in scout["types"]}
    for name, meta in cert["inputs"].items():
        path = Path(meta["path"])
        data = path.read_bytes()
        assert len(data) == meta["bytes"] and hashlib.sha256(data).hexdigest() == meta["sha256"], name

    for case in cert["cases"]:
        q, p = case["q"], case["characteristic"]
        base = canon(frozen[case["type"]]["coxeter_invariant_matching"])
        point_gens = [point_perm(tuple(x), q) for x in case["generator_point_matrices"]]
        sheet0 = orbit(base, point_gens)
        outer = point_perm((1, 0, 0, next(x for x in range(2, q) if pow(x, (q - 1) // 2, q) == q - 1)), q)
        sheet1 = sorted(image_matching(x, outer) for x in sheet0)
        assert len(sheet0) == len(sheet1) == q and not set(sheet0) & set(sheet1)
        perms = [induced(g, sheet1) for g in point_gens]

        rebuilt = {
            "shared_edge": [[int(len(set(a) & set(b)) == 1) for b in sheet1] for a in sheet0],
            "disjoint": [[int(len(set(a) & set(b)) == 0) for b in sheet1] for a in sheet0],
        }
        m = (q + 1) // 4
        assert m == p
        disjoint_gram = [[sum(x * y for x, y in zip(a, b)) for b in rebuilt["disjoint"]]
                         for a in rebuilt["disjoint"]]
        shared_gram = [[sum(x * y for x, y in zip(a, b)) for b in rebuilt["shared_edge"]]
                       for a in rebuilt["shared_edge"]]
        assert disjoint_gram == [[m * int(i == j) + m - 1 for j in range(q)] for i in range(q)]
        assert shared_gram == [[m * (int(i == j) + 1) for j in range(q)] for i in range(q)]
        for relation, matrix in rebuilt.items():
            assert matrix == case["relations"][relation]["matrix"]
            assert len(echelon(matrix, p)) == case["relations"][relation]["rank"]

        core = echelon(rebuilt["shared_edge"], p)
        code = echelon(rebuilt["disjoint"], p)
        assert [list(x) for x in core] == case["spaces"]["shared_edge_row_span"]["basis"]
        assert [list(x) for x in code] == case["spaces"]["disjoint_row_span"]["basis"]
        ones = tuple([1] * q)
        assert echelon([*core, ones], p) == code

        core_cyclic = {cyclic(v, perms, p) for v in vectors(core, p) if any(v)}
        assert core_cyclic == {core}
        code_cyclic = {cyclic(v, perms, p) for v in vectors(code, p) if any(v)}
        assert {len(x) for x in code_cyclic} == {1, len(core), len(code)}
        assert echelon([ones], p) in code_cyclic and core in code_cyclic and code in code_cyclic

        augmentation = echelon([[int(i == j) - int(j == q - 1) for j in range(q)] for i in range(q - 1)], p)
        rr, ar, eqs, unknowns = no_retraction_ranks(augmentation, core, perms, p)
        tracked_retraction = case["module_structure"]["ambient_sheet"]["equivariant_retraction_test"]
        assert (rr, ar, eqs, unknowns) == (tracked_retraction["coefficient_rank"],
                                           tracked_retraction["augmented_rank"],
                                           tracked_retraction["equations"],
                                           tracked_retraction["unknowns"])
        assert rr < ar
        cr, cu = commutant_rank(augmentation, perms, p)
        tracked_commutant = case["module_structure"]["ambient_sheet"]["commutant"]
        assert (cr, cu, cu - cr) == (tracked_commutant["equation_rank"], tracked_commutant["unknowns"],
                                     tracked_commutant["dimension"])
        aug_gram = [[sum(x * y for x, y in zip(a, b)) % p for b in augmentation] for a in augmentation]
        core_gram = [[sum(x * y for x, y in zip(a, b)) % p for b in core] for a in core]
        assert len(echelon(aug_gram, p)) == len(augmentation) and not any(any(row) for row in core_gram)

        replay_chars = brauer_values(perms, {"simple_core": core, "perfect_code": code}, p, q)
        assert replay_chars.pop("_period") == [p, 1, 1]
        replay_classes = replay_chars.pop("_classes")
        tracked_classes = case["brauer"]["concrete_p_regular_classes"]
        for name, values in replay_chars.items():
            tracked = case["brauer"]["modules"][name]["brauer_values"]
            lhs = sorted(zip(replay_classes["orders"], replay_classes["sizes"], values))
            rhs = sorted(zip(tracked_classes["orders"], tracked_classes["sizes"], tracked))
            assert lhs == rhs, (q, name, lhs, rhs)

    print("C465 replay OK: modules, nonsplit extensions, Lagrangians, period/Gram parameter")


if __name__ == "__main__":
    main()
