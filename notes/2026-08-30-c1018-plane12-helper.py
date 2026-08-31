#!/usr/bin/env python3
"""Independent verification of the C1018 order-12 projective-plane certificates.

Every check here is written from the mathematical statement, not from the Rust
driver's algorithm: exact integer arithmetic, a different search order, and a
different canonicalization.  Run:

    python3 notes/2026-08-30-c1018-plane12-helper.py --cache ~/.cache/ergodis/c1018
"""

from __future__ import annotations

import argparse
import itertools
import json
import pathlib
import sys


# ---------------------------------------------------------------- multiplier


def multiplier_check(v: int, k: int) -> dict:
    """Numerical-multiplier orbit obstruction for a planar (v, k, 1) set."""
    n = k - 1
    primes = []
    m = n
    p = 2
    while p * p <= m:
        if m % p == 0:
            primes.append(p)
            while m % p == 0:
                m //= p
        p += 1
    if m > 1:
        primes.append(m)
    primes = [p for p in primes if v % p != 0]

    orders = {}
    for p in primes:
        x, order = p % v, 1
        while x != 1:
            x = (x * p) % v
            order += 1
        orders[p] = order

    group = {1}
    frontier = [1]
    while frontier:
        g = frontier.pop()
        for p in primes:
            y = (g * p) % v
            if y not in group:
                group.add(y)
                frontier.append(y)

    seen, orbit_sizes = set(), []
    for x in range(v):
        if x in seen:
            continue
        orbit = {(g * x) % v for g in group}
        seen |= orbit
        orbit_sizes.append(len(orbit))

    reach = {0}
    for size in orbit_sizes:
        reach |= {t + size for t in reach if t + size <= k}
    return {
        "primes": primes,
        "orders": orders,
        "group_order": len(group),
        "orbit_sizes": sorted(orbit_sizes),
        "k_representable": k in reach,
    }


# ----------------------------------------------------------- difference sets


def all_difference_sets(v: int, k: int) -> list[tuple[int, ...]]:
    """Every planar difference set of Z_v containing 0, by plain backtracking.

    No gap normalization is used, so this explores a different tree from the
    Rust driver.  Sets are returned canonicalized under translation.
    """
    out: list[tuple[int, ...]] = []
    used = bytearray(v)
    chosen = [0]

    def rec() -> None:
        if len(chosen) == k:
            out.append(tuple(chosen))
            return
        start = chosen[-1] + 1
        for x in range(start, v):
            ok = True
            marked = []
            for d in chosen:
                a, b = (x - d) % v, (d - x) % v
                if used[a] or used[b]:
                    ok = False
                    break
                used[a] = used[b] = 1
                marked.append((a, b))
            if ok:
                chosen.append(x)
                rec()
                chosen.pop()
            for a, b in marked:
                used[a] = used[b] = 0

    rec()
    return out


def translation_classes(sets: list[tuple[int, ...]], v: int) -> set[tuple[int, ...]]:
    classes = set()
    for s in sets:
        best = min(tuple(sorted((x - t) % v for x in s)) for t in s)
        classes.add(best)
    return classes


def verify_difference_set(s, v: int, k: int) -> bool:
    """Exact check: the k(k-1) differences hit every nonzero residue once."""
    seen = set()
    for a, b in itertools.permutations(s, 2):
        d = (a - b) % v
        if d in seen or d == 0:
            return False
        seen.add(d)
    return len(seen) == v - 1


# ------------------------------------------------------------ orbit matrices


def orbit_matrices(n: int) -> list[tuple]:
    """All orbit matrices B for an order-(n+1) collineation of a plane of order n.

    B is (n-1) x (n-1), nonnegative integers, row sums n, row square sums 2n,
    pairwise row dot products n, column sums n.  Enumerated over unordered row
    sets with no first-row normalization, so the search differs from the Rust
    driver's.
    """
    dim = n - 1
    rows = []
    for combo in itertools.combinations_with_replacement(range(n + 1), dim):
        if sum(combo) != n or sum(c * c for c in combo) != 2 * n:
            continue
        rows.extend(set(itertools.permutations(combo)))
    rows = sorted(set(rows))
    dot = lambda a, b: sum(x * y for x, y in zip(a, b))
    solutions = []

    def rec(start: int, picked: list, colsum: list) -> None:
        if len(picked) == dim:
            if all(c == n for c in colsum):
                solutions.append(tuple(picked))
            return
        left = dim - len(picked)
        for idx in range(start, len(rows)):
            r = rows[idx]
            if any(colsum[j] + r[j] > n for j in range(dim)):
                continue
            if any(dot(r, q) != n for q in picked):
                continue
            rec(idx + 1, picked + [r], [colsum[j] + r[j] for j in range(dim)])
        _ = left

    rec(0, [], [0] * dim)
    return solutions


def check_orbit_matrix(matrix: list[list[int]], n: int) -> bool:
    dim = len(matrix)
    for i in range(dim):
        if sum(matrix[i]) != n:
            return False
        if sum(x * x for x in matrix[i]) != 2 * n:
            return False
        for j in range(i + 1, dim):
            if sum(a * b for a, b in zip(matrix[i], matrix[j])) != n:
                return False
    for j in range(dim):
        if sum(matrix[i][j] for i in range(dim)) != n:
            return False
    return True


# ------------------------------------------------------------------ starters


def starters(m: int) -> int:
    """Starters in Z_m, counted by difference multiset rather than by matching."""
    half = (m - 1) // 2
    elements = list(range(1, m))
    count = 0

    def rec(free: tuple, pairs: list) -> None:
        nonlocal count
        if not free:
            classes = set()
            for a, b in pairs:
                d = (b - a) % m
                classes.add(min(d, m - d))
            if len(classes) == half:
                count += 1
            return
        a = free[0]
        for i in range(1, len(free)):
            b = free[i]
            rec(free[1:i] + free[i + 1 :], pairs + [(a, b)])

    rec(tuple(elements), [])
    return count


# ------------------------------------------- order-(n+1) invariant plane model


def build_plane(n: int, perms: list[list[int]]):
    """Reconstruct the incidence structure from the wave-2B permutation model.

    `perms[x-1][i]` is `pi_x(i)` for `x` in `1..p-1` and rows `i` in `0..n-2`.
    Point orbits are numbered `0..n-1` with orbit 0 the point set of the fixed
    line `L`; line orbits likewise with orbit 0 the pencil through the fixed
    point `P`.  Returns (points, lines) with points as hashable labels.
    """
    p = n + 1
    r = n - 1
    # D[i][j] for i, j in 0..n-1, as sets of residues.
    D = [[set() for _ in range(n)] for _ in range(n)]
    for i in range(n):
        D[i][0] = {0}
    for j in range(n):
        D[0][j] = {0}
    for x in range(1, p):
        pi = perms[x - 1]
        for i in range(r):
            D[i + 1][pi[i] + 1].add(x)

    points = ["P"] + [(i, t) for i in range(n) for t in range(p)]
    lines = [frozenset((0, t) for t in range(p))]
    for j in range(n):
        for s in range(p):
            line = set()
            if j == 0:
                line.add("P")
            for i in range(n):
                for d in D[i][j]:
                    line.add((i, (s - d) % p))
            lines.append(frozenset(line))
    return points, lines


def verify_plane(n: int, perms: list[list[int]]) -> dict:
    """Check the projective-plane axioms directly on the reconstructed object."""
    p = n + 1
    points, lines = build_plane(n, perms)
    v = n * n + n + 1
    report = {
        "points": len(points),
        "lines": len(lines),
        "expected": v,
        "distinct_lines": len(set(lines)),
    }
    report["all_line_sizes_ok"] = all(len(l) == n + 1 for l in lines)
    counts = {}
    ok = True
    for l in lines:
        for a, b in itertools.combinations(sorted(l, key=str), 2):
            key = (str(a), str(b))
            counts[key] = counts.get(key, 0) + 1
            if counts[key] > 1:
                ok = False
    report["every_pair_at_most_once"] = ok
    report["pairs_covered"] = len(counts)
    report["pairs_expected"] = v * (v - 1) // 2
    report["is_projective_plane"] = (
        ok
        and report["all_line_sizes_ok"]
        and len(points) == v
        and len(lines) == v
        and report["distinct_lines"] == v
        and len(counts) == report["pairs_expected"]
    )
    # Hyperoval: a row whose column map is exactly two-to-one.
    r = n - 1
    hyper = []
    for i in range(r):
        fibres = {}
        for x in range(1, p):
            fibres.setdefault(perms[x - 1][i], []).append(x)
        if all(len(f) == 2 for f in fibres.values()) and len(fibres) == (p - 1) // 2:
            hyper.append(i)
    report["hyperoval_rows"] = hyper
    return report


def conjugacy_class_counts(r: int) -> dict:
    """Orbits of S_r on itself by conjugation, and by conjugation fixing point 0.

    Verifies the wave-2B level-2 symmetry reduction by brute force: the driver
    claims the class counts are the partitions of r, and the partitions of
    r - l summed over the length l of the cycle through 0.
    """
    perms = list(itertools.permutations(range(r)))
    stab = [p for p in perms if p[0] == 0]

    def orbits(group):
        seen, count = set(), 0
        for pi in perms:
            if pi in seen:
                continue
            count += 1
            for rho in group:
                inv = [0] * r
                for a in range(r):
                    inv[rho[a]] = a
                seen.add(tuple(inv[pi[rho[a]]] for a in range(r)))
        return count

    def partitions(m):
        if m == 0:
            return 1
        table = [1] + [0] * m
        for part in range(1, m + 1):
            for t in range(part, m + 1):
                table[t] += table[t - part]
        return table[m]

    return {
        "r": r,
        "full_conjugation_orbits": orbits(perms),
        "expected_full": partitions(r),
        "stabilizer_conjugation_orbits": orbits(stab),
        "expected_stabilizer": sum(partitions(r - lead) for lead in range(1, r + 1)),
    }


# ---------------------------------------------------------------------- main


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--cache", type=pathlib.Path, required=True)
    parser.add_argument("--skip-slow", action="store_true")
    args = parser.parse_args()

    report = {}

    # 1. Multiplier obstruction for the point-regular order-12 case.
    mult = multiplier_check(157, 13)
    report["multiplier_157_13"] = mult
    assert mult["orders"] == {2: 52, 3: 78}, mult["orders"]
    assert mult["group_order"] == 156
    assert mult["orbit_sizes"] == [1, 156]
    assert not mult["k_representable"]

    cert = args.cache / "multiplier-157.json"
    if cert.exists():
        rust = json.loads(cert.read_text())
        assert rust["group_order"] == mult["group_order"]
        assert sorted(rust["orbit_sizes"]) == mult["orbit_sizes"]
        assert rust["representable"] is False
        report["multiplier_agrees_with_rust"] = True

    # 2. Cross-check the exhaustive difference-set search on prime-power orders.
    cross = {}
    for v, k in ((21, 5), (31, 6), (57, 8)) if not args.skip_slow else ((21, 5), (31, 6)):
        sets = all_difference_sets(v, k)
        assert all(verify_difference_set(s, v, k) for s in sets)
        classes = translation_classes(sets, v)
        rust_path = args.cache / f"sidon-{v}.json"
        entry = {"containing_zero": len(sets), "translation_classes": len(classes)}
        if rust_path.exists():
            rust = json.loads(rust_path.read_text())
            entry["rust_canonical"] = rust["solutions"]
            entry["rust_nodes"] = rust["nodes"]
            rust_sets = [tuple(s) for s in rust["examples"]]
            if len(rust_sets) == rust["solutions"]:
                assert all(verify_difference_set(s, v, k) for s in rust_sets)
                entry["rust_classes_match"] = (
                    translation_classes(rust_sets, v) == classes
                )
        cross[f"v{v}k{k}"] = entry
    report["difference_set_cross_check"] = cross

    # 3. Orbit matrices: order 6 with an order-7 collineation is eliminated;
    #    orders 2 and 4 are realized (positive controls).
    orbit = {}
    for n in (2, 4, 6):
        sols = orbit_matrices(n)
        orbit[f"n{n}"] = len(sols)
        for s in sols:
            assert check_orbit_matrix([list(r) for r in s], n)
    assert orbit["n6"] == 0, "order-6 elimination failed"
    assert orbit["n2"] >= 1 and orbit["n4"] >= 1
    report["orbit_matrix_counts_unnormalized"] = orbit

    # 3b. Constructive witness for n = 12: twice the incidence matrix of the
    #     complement of the Paley biplane 2-(11,5,2) solves the orbit-matrix
    #     equation, so the order-13 case cannot die at this level.
    qr = sorted({(x * x) % 11 for x in range(1, 11)})
    blocks = [{(q + i) % 11 for q in qr} for i in range(11)]
    witness = [
        [2 if j not in blocks[i] else 0 for j in range(11)] for i in range(11)
    ]
    report["order12_biplane_witness_valid"] = check_orbit_matrix(witness, 12)
    assert report["order12_biplane_witness_valid"]

    # 4. Validate a Rust order-12 orbit-matrix example against the definition.
    o12 = args.cache / "orbit-n12.json"
    if o12.exists():
        rust = json.loads(o12.read_text())
        ok = [check_orbit_matrix(m, 12) for m in rust.get("examples", [])]
        report["order12_examples_valid"] = ok
        report["order12_solutions"] = rust["solutions"]
        report["order12_type_profiles"] = rust["type_profiles"]

    # 5. Starters in Z_13.
    s13 = starters(13)
    report["starters_z13"] = s13
    sp = args.cache / "starter-13.json"
    if sp.exists():
        assert json.loads(sp.read_text())["starters"] == s13
        report["starters_agree_with_rust"] = True

    # 6. Rust exhaustion for v = 157, if it has landed.
    s157 = args.cache / "sidon-157.json"
    if s157.exists():
        rust = json.loads(s157.read_text())
        report["sidon_157"] = {
            "solutions": rust["solutions"],
            "nodes": rust["nodes"],
            "hall_failures": rust["hall_failures"],
        }

    # 7. Wave 2B: reconstruct a plane from the permutation model and verify the
    #    axioms directly, which validates the model itself.
    invariant = {}
    for tag in (
        "inv-n4",
        "inv-n4-hyp",
        "inv-n6",
        "inv-n6-hyp",
        "inv-n10",
        "inv-n12-hyperoval",
        "inv-n12-general",
    ):
        path = args.cache / f"{tag}.json"
        if not path.exists():
            continue
        rust = json.loads(path.read_text())
        entry = {
            "solutions": rust["solutions"],
            "nodes": rust["nodes"],
            "exhausted": rust["exhausted"],
            "classes": rust.get("level_two_classes"),
            "classes_exhausted": rust.get("classes_exhausted"),
            "verdict": rust["verdict"],
        }
        if rust.get("example"):
            entry["reconstruction"] = verify_plane(rust["n"], rust["example"])
        invariant[tag] = entry
    if invariant:
        report["invariant_plane_model"] = invariant
        # The n = 4 solution must reconstruct a genuine projective plane, and
        # the n = 6 searches must agree with the wave-2A orbit-matrix result.
        for tag in ("inv-n4", "inv-n4-hyp"):
            if tag in invariant and "reconstruction" in invariant[tag]:
                assert invariant[tag]["reconstruction"]["is_projective_plane"]
        for tag in ("inv-n6", "inv-n6-hyp"):
            if tag in invariant:
                assert invariant[tag]["solutions"] == 0
                assert invariant[tag]["exhausted"]

    # 8. Brute-force check of the wave-2B level-2 symmetry reduction.
    sym = {}
    for r in (3, 5, 6, 7):
        counts = conjugacy_class_counts(r)
        assert counts["full_conjugation_orbits"] == counts["expected_full"]
        assert counts["stabilizer_conjugation_orbits"] == counts["expected_stabilizer"]
        sym[f"r{r}"] = counts
    report["level_two_symmetry_reduction"] = sym

    print(json.dumps(report, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    sys.exit(main())
