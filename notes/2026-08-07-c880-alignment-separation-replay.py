#!/usr/bin/env python3
"""C880: independent replay of the alignment-test threshold and minimum.

This checks the results of 2026-08-07-c880-alignment-separation.rs by a route
that shares no code and, at six points, no canonicalization either: it
enumerates every graph on the point set, reduces to two-graphs by the value of
tau rather than by choosing a switching representative, and recomputes the
alignment data with numpy.

Run:  uv run --with numpy python3 2026-08-07-c880-alignment-separation-replay.py \
          --census <path to the n=7 census json> --out <path.json>

What it certifies
  n = 6: the number of two-graphs, the number of distinct alignment vectors,
         the number of colliding groups and of complement pairs inside them,
         and the exhibited non-complementary witness pair.
  n = 7: that the alignment vectors of the 16384 complement pairs are pairwise
         distinct; that each of the 56 five-element test sets reported optimal
         is removable; and that no six-element set is removable.  The last is
         exhaustive because removability is downward closed, so every removable
         six-set is one of the 56 extended by a single test.
"""

import argparse
import hashlib
import itertools
import json
import sys

import numpy as np


def triples(n):
    return list(itertools.combinations(range(n), 3))


def foursets(n):
    return list(itertools.combinations(range(n), 4))


def edge_bits(n, skip_zero):
    """bit position of each pair; skip_zero drops pairs meeting the point 0."""
    idx = {}
    b = 0
    for i in range(n):
        for j in range(i + 1, n):
            if skip_zero and i == 0:
                continue
            idx[(i, j)] = b
            b += 1
    return idx, b


def tau_masks(n, idx, sets):
    """edge mask of every triple of every set in `sets`."""
    out = []
    for s in sets:
        ms = []
        for t in itertools.combinations(s, 3):
            m = 0
            for i, j in itertools.combinations(t, 2):
                if (i, j) in idx:
                    m |= 1 << idx[(i, j)]
            ms.append(m)
        out.append(ms)
    return out


def popcount_table(bits):
    t = np.zeros(1 << bits, dtype=np.uint8)
    for k in range(1, 1 << bits):
        t[k] = t[k >> 1] + (k & 1)
    return t


def parity(g, mask, pop):
    return pop[np.bitwise_and(g, mask)] & 1


def alignment_vectors(n, skip_zero):
    """alignment vector of every graph on n points (as an object per graph)."""
    idx, nb = edge_bits(n, skip_zero)
    fs = foursets(n)
    masks = tau_masks(n, idx, fs)
    pop = popcount_table(nb)
    g = np.arange(1 << nb, dtype=np.int64)
    vec = np.zeros(1 << nb, dtype=np.int64)
    for k, ms in enumerate(masks):
        p0 = parity(g, ms[0], pop)
        p1 = parity(g, ms[1], pop)
        p2 = parity(g, ms[2], pop)
        p3 = parity(g, ms[3], pop)
        same = (p0 == p1) & (p1 == p2) & (p2 == p3)
        vec |= same.astype(np.int64) << k
    return g, vec, fs, idx, nb


def tau_signature(n, idx, nb):
    """tau value of every triple, for every graph on n points: one int per graph."""
    ts = triples(n)
    masks = tau_masks(n, idx, [t + (t[0],) for t in ts])  # unused padding
    del masks
    pop = popcount_table(nb)
    g = np.arange(1 << nb, dtype=np.int64)
    sig = np.zeros(1 << nb, dtype=np.int64)
    for k, t in enumerate(ts):
        m = 0
        for i, j in itertools.combinations(t, 2):
            if (i, j) in idx:
                m |= 1 << idx[(i, j)]
        sig |= (parity(g, m, pop)).astype(np.int64) << k
    return sig


def check_six():
    """Full graph enumeration on six points; no switching representative chosen."""
    n = 6
    _, vec, fs, idx, nb = alignment_vectors(n, skip_zero=False)
    sig = tau_signature(n, idx, nb)
    # two-graphs are the distinct values of tau
    uniq_sig, first = np.unique(sig, return_index=True)
    align = vec[first]                       # alignment vector per two-graph
    ntg = len(uniq_sig)
    # the complementary two-graph flips every triple
    ntrip = len(triples(n))
    comp = uniq_sig ^ ((1 << ntrip) - 1)
    pos = {int(s): k for k, s in enumerate(uniq_sig)}
    comp_idx = np.array([pos[int(c)] for c in comp])
    assert not np.any(comp_idx == np.arange(ntg))
    # alignment is invariant under complementation
    assert np.array_equal(align, align[comp_idx])
    pair_rep = np.array([k for k in range(ntg) if k < comp_idx[k]])
    pv = align[pair_rep]
    order = np.argsort(pv, kind="stable")
    groups, cur = [], [order[0]]
    for a, b in zip(order, order[1:]):
        if pv[a] == pv[b]:
            cur.append(b)
        else:
            if len(cur) > 1:
                groups.append(cur)
            cur = [b]
    if len(cur) > 1:
        groups.append(cur)
    witness = None
    for gp in groups:
        if pv[gp[0]] != 0:
            members = []
            for k in gp[:2]:
                s = int(uniq_sig[pair_rep[k]])
                members.append([list(t) for k2, t in enumerate(triples(n)) if s >> k2 & 1])
            witness = {
                "aligned_foursets": [list(fs[k]) for k in range(len(fs)) if int(pv[gp[0]]) >> k & 1],
                "coherent_triples_of_two_members": members,
            }
            break
    return {
        "n": n,
        "two_graphs": int(ntg),
        "complement_pairs": int(len(pair_rep)),
        "distinct_alignment_vectors": int(len(np.unique(pv))),
        "colliding_groups": len(groups),
        "pairs_in_collisions": int(sum(len(g) for g in groups)),
        "largest_group": max((len(g) for g in groups), default=0),
        "empty_family_pairs": int(np.sum(pv == 0)),
        "nonempty_witness": witness,
    }


def check_seven(census_path):
    n = 7
    g, vec, fs, idx, nb = alignment_vectors(n, skip_zero=True)
    full = (1 << nb) - 1
    rep = np.array([k for k in range(1 << nb) if k < (k ^ full)])
    pv = vec[rep]
    assert np.array_equal(pv, vec[rep ^ full]), "alignment is not complement invariant"
    faithful = len(np.unique(pv)) == len(pv)

    def separates(keep_mask):
        return len(np.unique(np.bitwise_and(pv, keep_mask))) == len(pv)

    ntests = len(fs)
    allbits = (1 << ntests) - 1
    census = json.load(open(census_path))
    index_of = {tuple(f): k for k, f in enumerate(fs)}

    # regenerate the 56 optimal families from the two reported orbits, so the
    # replay does not simply reread the certificate's own list
    orbit_reps = [[tuple(s) for s in o["representative"]] for o in census["orbits"]]
    removable5 = set()
    for perm in itertools.permutations(range(n)):
        for orep in orbit_reps:
            m = 0
            for s in orep:
                img = tuple(sorted(perm[x] for x in s))
                m |= 1 << index_of[img]
            removable5.add(m)
    ok5 = all(separates(allbits & ~m) for m in removable5)
    # exhaustive: every removable six-set extends a removable five-set
    any6 = False
    for m in removable5:
        for t in range(ntests):
            if m >> t & 1:
                continue
            if separates(allbits & ~(m | (1 << t))):
                any6 = True
                break
        if any6:
            break
    return {
        "n": n,
        "complement_pairs": int(len(pv)),
        "tests": ntests,
        "full_family_faithful": bool(faithful),
        "optimal_families_regenerated": len(removable5),
        "all_five_sets_removable": bool(ok5),
        "some_six_set_removable": bool(any6),
        "minimum_tests": ntests - 5 if ok5 and not any6 else None,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--census", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    six = check_six()
    seven = check_seven(args.census)
    doc = {
        "artifact": "c880-alignment-separation-replay",
        "schema": 1,
        "census_input_sha256": hashlib.sha256(open(args.census, "rb").read()).hexdigest(),
        "six": six,
        "seven": seven,
    }
    with open(args.out, "w") as fh:
        json.dump(doc, fh, indent=1, sort_keys=True)
        fh.write("\n")
    print(json.dumps(six, indent=1, sort_keys=True))
    print(json.dumps(seven, indent=1, sort_keys=True))
    if not seven["full_family_faithful"] or seven["minimum_tests"] != 30:
        sys.exit(1)


if __name__ == "__main__":
    main()
