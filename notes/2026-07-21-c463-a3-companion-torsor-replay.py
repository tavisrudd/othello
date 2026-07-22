#!/usr/bin/env python3
"""Independent permutation replay for C463; does not import the primary checker."""
from collections import Counter
from itertools import combinations, permutations
from pathlib import Path
import hashlib
import json


HERE = Path(__file__).resolve().parent
CERT = json.loads((HERE / "2026-07-21-c463-a3-companion-torsor.json").read_text())


def key(x, q):
    return q if x == "inf" else x


def edge(a, b, q):
    return tuple(sorted((a, b), key=lambda x: key(x, q)))


def matching(es, q):
    return tuple(sorted((edge(a, b, q) for a, b in es), key=lambda e: tuple(key(x, q) for x in e)))


def matchings(points, q):
    if not points:
        yield ()
        return
    a = points[0]
    for n in range(1, len(points)):
        b = points[n]
        for tail in matchings(points[1:n] + points[n + 1 :], q):
            yield matching(((a, b),) + tail, q)


def compose(a, b, points):
    table = dict(zip(points, a))
    return tuple(table[x] for x in b)


def closure(generators, points):
    group, frontier = {points}, [points]
    while frontier:
        a = frontier.pop()
        for b in generators:
            c = compose(a, b, points)
            if c not in group:
                group.add(c)
                frontier.append(c)
    return group


def image(permutation, value, q):
    table = dict(zip(tuple(range(q)) + ("inf",), permutation))
    return matching(((table[a], table[b]) for a, b in value), q)


def matching_key(value, q):
    return tuple(key(x, q) for e in value for x in e)


def orbit_partition(group, q):
    points = tuple(range(q)) + ("inf",)
    unseen = set(matchings(points, q))
    answer = []
    while unseen:
        seed = min(unseen, key=lambda m: matching_key(m, q))
        orbit = {image(g, seed, q) for g in group}
        unseen -= orbit
        answer.append(tuple(sorted(orbit, key=lambda m: matching_key(m, q))))
    return sorted(answer, key=lambda o: (len(o), matching_key(o[0], q)))


def one_factorization(fixed, orbit, q):
    points = tuple(range(q)) + ("inf",)
    actual = [e for m in (fixed,) + tuple(orbit) for e in m]
    expected = {edge(a, b, q) for a, b in combinations(points, 2)}
    return len(actual) == len(expected) == len(set(actual)) and set(actual) == expected


def replay_case(case, q, generators, galois):
    points = tuple(range(q)) + ("inf",)
    group = closure(generators, points)
    assert len(group) == 24
    orbits = orbit_partition(group, q)
    fixed = matching(CERT[case]["fixed_matching"], q)
    fixed_orbits = [o for o in orbits if len(o) == 1]
    assert fixed_orbits == [(fixed,)]
    companions = [o for o in orbits if len(o) == q - 1 and one_factorization(fixed, o, q)]
    action = []
    for orbit in companions:
        target = tuple(sorted((image(galois, m, q) for m in orbit), key=lambda m: matching_key(m, q)))
        action.append(companions.index(target))
    assert CERT[case]["perfect_matching_count"] == sum(len(o) for o in orbits)
    assert CERT[case]["matching_orbit_size_census"] == {str(k): v for k, v in sorted(Counter(map(len, orbits)).items())}
    assert CERT[case]["companion_count"] == len(companions)
    assert CERT[case]["galois_action"]["companion_permutation"] == action
    certified = [[matching(m, q) for m in row["matchings"]] for row in CERT[case]["companions"]]
    assert certified == [list(o) for o in companions]


a3_gens = (
    ("inf", 2, 1, 4, 3, 0),
    (1, "inf", 2, 3, 0, 4),
)
b3_gens = (
    ("inf", 3, 5, 1, 6, 2, 4, 0),
    (1, 2, 0, 6, 4, 5, "inf", 3),
)
a3_galois = (0, 1, 3, 2, 4, "inf")
b3_galois = (0, 2, 1, 6, 4, 5, 3, "inf")

replay_case("A3", 5, a3_gens, a3_galois)
replay_case("B3", 7, b3_gens, b3_galois)

a3_points = tuple(range(5)) + ("inf",)
a3_group = closure(a3_gens, a3_points)
a3_extended = closure(a3_gens + (a3_galois,), a3_points)
a3_fixed = matching(CERT["A3"]["fixed_matching"], 5)
a3_full_stabilizer = {
    candidate for candidate in permutations(a3_points)
    if image(candidate, a3_fixed, 5) == a3_fixed
}
assert a3_galois not in a3_group
assert a3_extended == a3_full_stabilizer and len(a3_extended) == 48
assert CERT["A3"]["normalizer_upgrade"]["generated_group_order"] == 48

synthemes = tuple(sorted(matchings(a3_points, 5), key=lambda m: matching_key(m, 5)))
syntheme_id = {value: i for i, value in enumerate(synthemes)}
all_duads = {edge(a, b, 5) for a, b in combinations(a3_points, 2)}
pentads = tuple(
    ids for ids in combinations(range(15), 5)
    if {duad for i in ids for duad in synthemes[i]} == all_duads
)
assert len(pentads) == 6
pentad_index = {frozenset(ids): i for i, ids in enumerate(pentads)}

def pentad_action(permutation):
    return tuple(
        pentad_index[frozenset(syntheme_id[image(permutation, synthemes[i], 5)] for i in ids)]
        for ids in pentads
    )

all_outer_actions = {pentad_action(permutation) for permutation in permutations(a3_points)}
galois_outer_action = pentad_action(a3_galois)
outer = CERT["A3"]["outer_S6_upgrade"]
assert len(all_outer_actions) == 720
assert outer["pentads_as_syntheme_ids"] == [list(ids) for ids in pentads]
assert outer["galois_action_on_six_pentads"] == list(galois_outer_action)
assert sorted(Counter(galois_outer_action).values()) == [1] * 6
assert sum(galois_outer_action[i] == i for i in range(6)) == 0

assert CERT["A3"]["prime_reduction_table"][0]["reduced_companion"] == 0
assert CERT["A3"]["prime_reduction_table"][1]["reduced_companion"] == 1
assert [row["case"] for row in CERT["three_case_summary"]] == ["H3", "B3", "A3"]
for name, field in (("2026-07-21-c443-commuting-with-reduction.json", "c443_certificate_sha256"), ("2026-07-21-c462-torsor-descent.json", "c462_certificate_sha256")):
    assert hashlib.sha256((HERE / name).read_bytes()).hexdigest() == CERT["H3_hash_reference"][field]

print("REPLAY OK: independent A3/B3 permutation enumeration and H3 hash references verified")
