#!/usr/bin/env python3
"""C463: exact A3/B3 companion-orbit and Galois-action certificate."""
from __future__ import annotations

from collections import Counter
from itertools import permutations, product
from pathlib import Path
import hashlib
import json
import sys


HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c463-a3-companion-torsor"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
REPLAY_PATH = HERE / f"{STEM}-replay.py"
SCHEMA = "c463-a3-companion-torsor-v1"

INPUT_NAMES = (
    "2026-07-21-c444-silver-fusion.md",
    "2026-07-21-c444-silver-fusion.py",
    "2026-07-21-c444-silver-fusion.json",
    "2026-07-21-c443-commuting-with-reduction.md",
    "2026-07-21-c443-commuting-with-reduction.json",
    "2026-07-21-weil-roof-juice-m-chain.md",
    "2026-07-21-c442-antipodal-singleton-reduction.md",
    "2026-07-21-c462-torsor-descent.json",
)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def point_key(x, p):
    return p if x == "inf" else x


def canon_edge(a, b, p):
    return tuple(sorted((a, b), key=lambda x: point_key(x, p)))


def canon_matching(edges, p):
    return tuple(sorted((canon_edge(a, b, p) for a, b in edges), key=lambda e: tuple(point_key(x, p) for x in e)))


def all_matchings(points, p):
    points = tuple(points)
    if not points:
        yield ()
        return
    first = points[0]
    for i in range(1, len(points)):
        second = points[i]
        rest = points[1:i] + points[i + 1 :]
        for tail in all_matchings(rest, p):
            yield canon_matching(((first, second),) + tail, p)


def mmul(a, b, p):
    return tuple(sum(a[2 * r + k] * b[2 * k + c] for k in range(2)) % p for r in range(2) for c in range(2))


def minv(m, p):
    a, b, c, d = m
    z = pow((a * d - b * c) % p, -1, p)
    return (d * z % p, -b * z % p, -c * z % p, a * z % p)


def pnorm(m, p):
    z = pow(next(x for x in m if x % p), -1, p)
    return tuple(x * z % p for x in m)


def matrix_closure(generators, p):
    generators = tuple(pnorm(g, p) for g in generators)
    identity = pnorm((1, 0, 0, 1), p)
    group, frontier = {identity}, [identity]
    while frontier:
        left = frontier.pop()
        for right in generators:
            value = pnorm(mmul(left, right, p), p)
            if value not in group:
                group.add(value)
                frontier.append(value)
        assert len(group) <= 120
    return group


def pact(m, x, p):
    a, b, c, d = m
    if x == "inf":
        n, z = a, c
    else:
        n, z = (a * x + b) % p, (c * x + d) % p
    return "inf" if z == 0 else n * pow(z, -1, p) % p


def matching_image(m, matching, p):
    return canon_matching(((pact(m, a, p), pact(m, b, p)) for a, b in matching), p)


def permutation_image(permutation, matching, p):
    return canon_matching(((permutation[a], permutation[b]) for a, b in matching), p)


def permutation_compose(left, right, points):
    table = dict(zip(points, left))
    return tuple(table[x] for x in right)


def matching_orbits(group, p):
    unseen = set(all_matchings(tuple(range(p)) + ("inf",), p))
    orbits = []
    while unseen:
        seed = min(unseen, key=lambda m: tuple(point_key(x, p) for e in m for x in e))
        orbit = {matching_image(g, seed, p) for g in group}
        assert orbit <= unseen
        unseen -= orbit
        orbits.append(tuple(sorted(orbit, key=lambda m: tuple(point_key(x, p) for e in m for x in e))))
    return tuple(sorted(orbits, key=lambda o: (len(o), tuple(point_key(x, p) for e in o[0] for x in e))))


def is_one_factorization(fixed, orbit, p):
    edges = [edge for matching in (fixed,) + tuple(orbit) for edge in matching]
    complete = {canon_edge(a, b, p) for i, a in enumerate(tuple(range(p)) + ("inf",)) for b in (tuple(range(p)) + ("inf",))[i + 1 :]}
    return len(edges) == len(complete) and set(edges) == complete and len(set(edges)) == len(edges)


def serialize_matching(matching):
    return [list(edge) for edge in matching]


def serialize_orbit(orbit):
    return [serialize_matching(matching) for matching in orbit]


def b3_group():
    p, s = 7, 3
    one = (1, 0, 0, 1)
    i = (0, 1, -1 % p, 0)
    j = (2, s, s, -2 % p)
    k = mmul(i, j, p)
    add = lambda *ms: tuple(sum(m[n] for m in ms) % p for n in range(4))
    scale = lambda z, m: tuple(z * x % p for x in m)
    q = scale(pow(2, -1, p), add(one, i, j, k))
    r = scale(pow(s, -1, p), add(one, i))
    c = (1, s, 0, 1)
    ci = minv(c, p)
    return {pnorm(mmul(mmul(c, g, p), ci, p), p) for g in matrix_closure((i, j, q, r), p)}


def a3_group():
    # C444 proves that its F_25 spin model projectivizes to these F_5 matrices.
    i = (2, 0, 0, 3)
    j = (0, 1, 4, 0)
    k = mmul(i, j, 5)
    one = (1, 0, 0, 1)
    q = tuple(3 * sum(m[n] for m in (one, i, j, k)) % 5 for n in range(4))
    r = tuple((one[n] + i[n]) % 5 for n in range(4))
    return matrix_closure((i, j, q, r), 5)


def analyze_case(name, p, group, fixed, galois_name, galois_perm):
    assert len(group) == 24
    orbits = matching_orbits(group, p)
    fixed_orbits = [o for o in orbits if len(o) == 1]
    assert fixed_orbits == [(fixed,)]
    companions = [o for o in orbits if len(o) == p - 1 and is_one_factorization(fixed, o, p)]
    companion_index = {orbit: i for i, orbit in enumerate(companions)}
    action = []
    for orbit in companions:
        image = tuple(sorted((permutation_image(galois_perm, m, p) for m in orbit), key=lambda m: tuple(point_key(x, p) for e in m for x in e)))
        assert image in companion_index
        action.append(companion_index[image])
    census = dict(sorted(Counter(len(o) for o in orbits).items()))
    return {
        "field": f"F_{p}",
        "projective_group_order": len(group),
        "perfect_matching_count": sum(len(o) for o in orbits),
        "matching_orbit_count": len(orbits),
        "matching_orbit_size_census": {str(k): v for k, v in census.items()},
        "fixed_matching_orbit_count": len(fixed_orbits),
        "fixed_matching": serialize_matching(fixed),
        "fixed_matching_is_unique": len(fixed_orbits) == 1,
        "companion_orbit_size": p - 1,
        "companion_count": len(companions),
        "companions": [{"id": i, "matchings": serialize_orbit(o), "completes_fixed_matching_to_one_factorization": True} for i, o in enumerate(companions)],
        "galois_action": {
            "generator": galois_name,
            "vertex_permutation": [{"from": x, "to": galois_perm[x]} for x in tuple(range(p)) + ("inf",)],
            "companion_permutation": action,
            "fixed_companions": sum(i == j for i, j in enumerate(action)),
        },
    }, companions


def frozen_inputs():
    return {name: {"bytes": (HERE / name).stat().st_size, "sha256": sha256((HERE / name).read_bytes())} for name in INPUT_NAMES}


def build_certificate():
    c444 = json.loads((HERE / "2026-07-21-c444-silver-fusion.json").read_text())
    c443 = json.loads((HERE / "2026-07-21-c443-commuting-with-reduction.json").read_text())
    c462 = json.loads((HERE / "2026-07-21-c462-torsor-descent.json").read_text())

    a3_fixed = canon_matching(((0, "inf"), (1, 4), (2, 3)), 5)
    assert serialize_matching(a3_fixed) == c444["A3"]["matching_at_i_2"] == c444["A3"]["matching_at_i_3"]
    a3_perm = {0: 0, 1: 1, 2: 3, 3: 2, 4: 4, "inf": "inf"}
    a3_projective = a3_group()
    a3, a3_companions = analyze_case("A3", 5, a3_projective, a3_fixed, "i -> -i", a3_perm)
    assert a3["matching_orbit_size_census"] == {"1": 1, "4": 2, "6": 1}
    assert a3["companion_count"] == 2 and a3["galois_action"]["companion_permutation"] == [1, 0]
    a3_points = tuple(range(5)) + ("inf",)
    a3_permutations = {tuple(pact(matrix, x, 5) for x in a3_points) for matrix in a3_projective}
    galois_tuple = tuple(a3_perm[x] for x in a3_points)
    extended = a3_permutations | {permutation_compose(galois_tuple, g, a3_points) for g in a3_permutations}
    abstract_stabilizer = {
        candidate for candidate in permutations(a3_points)
        if permutation_image(dict(zip(a3_points, candidate)), a3_fixed, 5) == a3_fixed
    }
    assert galois_tuple not in a3_permutations and extended == abstract_stabilizer and len(extended) == 48
    a3["normalizer_upgrade"] = {
        "galois_swap_is_outside_projective_S4": True,
        "generated_group_order": 48,
        "equals_full_abstract_antipodal_matching_stabilizer": True,
        "projective_S4_index": 2,
        "interpretation": "the two companion one-factorizations are exchanged by the missing index-two symmetry",
    }

    b3_fixed = canon_matching(tuple(tuple(e) for e in c444["B3"]["reductions"]["sqrt2_3"]["matching"]), 7)
    b3_perm = {0: 0, 1: 2, 2: 1, 3: 6, 4: 4, 5: 5, 6: 3, "inf": "inf"}
    b3, _ = analyze_case("B3", 7, b3_group(), b3_fixed, "omega -> omega^2", b3_perm)
    assert b3["matching_orbit_size_census"] == {"1": 1, "3": 4, "4": 2, "6": 4, "12": 5}
    assert b3["companion_count"] == 1 and b3["galois_action"]["companion_permutation"] == [0]

    a3["torsor"] = {"group": "Z/2", "free_and_transitive": True, "galois_fixed_member_exists": False, "unordered_family_descends": True, "base_ring": "Z[i]", "good_split_prime": 5}
    a3["prime_reduction_table"] = [
        {"generic_companion": 0, "prime": "(2-i)", "i_mod_5": 2, "reduced_companion": 0, "preferred_for_canonical_companion_0": True},
        {"generic_companion": 0, "prime": "(2+i)", "i_mod_5": 3, "reduced_companion": 1, "preferred_for_canonical_companion_0": False},
        {"generic_companion": 1, "prime": "(2-i)", "i_mod_5": 2, "reduced_companion": 1, "preferred_for_canonical_companion_0": False},
        {"generic_companion": 1, "prime": "(2+i)", "i_mod_5": 3, "reduced_companion": 0, "preferred_for_canonical_companion_0": True},
    ]
    b3["torsor"] = {"group": "trivial", "galois_fixed": True, "descends": True}

    c443_hash = sha256((HERE / "2026-07-21-c443-commuting-with-reduction.json").read_bytes())
    c462_hash = sha256((HERE / "2026-07-21-c462-torsor-descent.json").read_bytes())
    h3 = {
        "copied_by_hash_reference_only": True,
        "c443_certificate_sha256": c443_hash,
        "c462_certificate_sha256": c462_hash,
        "fixed_matching_count": c443["geometry"]["fixed_matching_orbit_count"],
        "companion_count": c443["geometry"]["one_factorizing_size_ten_orbit_count"],
        "companion_orbit_size": 10,
        "galois_group": "Z/4",
        "companion_permutation": c462["acceptance"]["canonical_companion_action"]["sigma_companion_permutation"],
        "sigma_cycle": c462["acceptance"]["canonical_companion_action"]["sigma_cycle"],
        "sigma_square_is_kappa": c462["acceptance"]["canonical_companion_action"]["sigma_square"] == c462["acceptance"]["canonical_companion_action"]["kappa_companion_permutation"],
        "point_valued_companion_section_descends": c462["descent_statement"]["obstruction"]["point_valued_companion_section_descends"],
    }

    summary = [
        {"case": "H3", "antipodal_matching_behavior": "golden-prime sheet reductions", "companion_behavior": "four companions, free Z/4 action", "certified_bit_carrier": "companion family at Z/4 strength", "scope": "hash-referenced from C443/C462"},
        {"case": "B3", "antipodal_matching_behavior": "two silver reductions in opposite PSL_2(7) sheets", "companion_behavior": "one companion fixed by omega -> omega^2", "certified_bit_carrier": "antipodal-matching sheet split; companion torsor trivial", "scope": "C444 conventions plus C463 enumeration"},
        {"case": "A3", "antipodal_matching_behavior": "prime-independent fused matching", "companion_behavior": "two companions freely swapped by i -> -i", "certified_bit_carrier": "companion family at Z/2 strength", "scope": "C444 conventions plus C463 enumeration"},
    ]

    return {
        "schema": SCHEMA,
        "task": "C463",
        "verdict": "GREEN_A3_Z2_COMPANION_TORSOR_AND_THREE_CASE_BIT_CARRIER_TABLE",
        "inputs": frozen_inputs(),
        "A3": a3,
        "B3": b3,
        "H3_hash_reference": h3,
        "three_case_summary": summary,
        "boundary": "Exact facts for the frozen H3/B3/A3 cases only; no general Coxeter-group or prime law, moment claim, secant-product claim, or manuscript consequence.",
    }


def canonical_json(value):
    return json.dumps(value, sort_keys=True, indent=2, ensure_ascii=True) + "\n"


def manifest_text(json_bytes):
    data = {Path(__file__).resolve(): Path(__file__).resolve().read_bytes(), REPLAY_PATH: REPLAY_PATH.read_bytes(), JSON_PATH: json_bytes}
    return "".join(f"{sha256(data[path])}  {path.name}\n" for path in data)


def main(argv):
    rendered = canonical_json(build_certificate()).encode()
    if "--check" in argv:
        ok = JSON_PATH.exists() and JSON_PATH.read_bytes() == rendered
        ok = ok and SHA_PATH.exists() and SHA_PATH.read_text() == manifest_text(rendered)
        print("CHECK OK" if ok else "CHECK FAILED")
        return 0 if ok else 1
    assert REPLAY_PATH.exists()
    JSON_PATH.write_bytes(rendered)
    SHA_PATH.write_text(manifest_text(rendered))
    print(f"wrote {JSON_PATH.name} ({len(rendered)} bytes) and {SHA_PATH.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
