#!/usr/bin/env python3
"""C77/C74: exact first-reply graphs of q=11 knife-edge P pencil centers.

For each distinct P-valued off-conic center on a maximum-capacity pencil of the
two q=11 knife-edge size-3 classes, query the exact Rust solver after every
legal opponent move.  Vertices are legal moves from the P root; {x,y} is an
edge when root+x+y is P.  Thus the root game equation says precisely that this
graph has no isolated vertex.  We additionally test the stronger, constructive
condition that it has a perfect matching.

The script consumes exact P/N labels only to select the already-known P roots
and to build their reply graphs.  It is a game-semantic diagnostic, not a
value-blind selector or proof of a uniform matching formula.
"""
from collections import Counter
from functools import lru_cache
from itertools import combinations
import argparse
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import DATA, PRIME_FILES, analyze, parse  # noqa: E402
from c77_pencil_value_probe import KNIFE, rows_for  # noqa: E402


REPLY = re.compile(r"y=\((\d+),(\d+)\)\s+P\s+<-- winning")


def legal_moves(q, root):
    used_r = {r for r, _c in root}
    used_c = {c for _r, c in root}
    out = []
    for z in ((r, c) for r in range(q) for c in range(q)):
        if z[0] in used_r or z[1] in used_c:
            continue
        if any(((b[0] - a[0]) * (z[1] - a[1])
                - (b[1] - a[1]) * (z[0] - a[0])) % q == 0
               for a, b in combinations(root, 2)):
            continue
        out.append(z)
    return out


def winning_replies(solver, q, root, move):
    cmd = [solver, "checkpos", str(q)]
    cmd.extend(f"{r},{c}" for r, c in root)
    cmd.extend(["/", f"{move[0]},{move[1]}"])
    output = subprocess.run(cmd, check=True, text=True, capture_output=True).stdout
    return {(int(m.group(1)), int(m.group(2))) for m in REPLY.finditer(output)}


def perfect_matching(vertices, adj):
    index = {v: i for i, v in enumerate(vertices)}
    nbr = [sum(1 << index[w] for w in adj[v]) for v in vertices]

    @lru_cache(maxsize=None)
    def rec(mask):
        if mask == 0:
            return ()
        i = (mask & -mask).bit_length() - 1
        choices = nbr[i] & mask & ~(1 << i)
        while choices:
            bit = choices & -choices
            j = bit.bit_length() - 1
            tail = rec(mask & ~(1 << i) & ~bit)
            if tail is not None:
                return ((vertices[i], vertices[j]),) + tail
            choices ^= bit
        return None

    return rec((1 << len(vertices)) - 1)


def isomorphic(graph1, graph2):
    """Small exact backtracker; graphs here have at most 20 vertices."""
    v1, a1 = graph1
    v2, a2 = graph2
    if len(v1) != len(v2) or sum(map(len, a1.values())) != sum(map(len, a2.values())):
        return False

    def signature(v, adj):
        return (len(adj[v]), tuple(sorted(len(adj[w]) for w in adj[v])))

    sig1 = {v: signature(v, a1) for v in v1}
    sig2 = {v: signature(v, a2) for v in v2}
    if sorted(sig1.values()) != sorted(sig2.values()):
        return False
    by_sig = {}
    for w in v2:
        by_sig.setdefault(sig2[w], []).append(w)
    mapping = {}
    used = set()

    def rec():
        if len(mapping) == len(v1):
            return True
        unmapped = [v for v in v1 if v not in mapping]
        x = min(unmapped, key=lambda v: sum(w not in used for w in by_sig[sig1[v]]))
        for y in by_sig[sig1[x]]:
            if y in used:
                continue
            if any((u in a1[x]) != (mapping[u] in a2[y]) for u in mapping):
                continue
            mapping[x] = y
            used.add(y)
            if rec():
                return True
            used.remove(y)
            del mapping[x]
        return False

    return rec()


def roots_for_class(q, cls):
    rec = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))[cls]
    centers = {
        row["cell"]
        for q0, c0, _key, _d, rows in rows_for(q)[1]
        if q0 == q and c0 == cls
        for row in rows
        if row["value"] == "P"
    }
    return rec["S3"], sorted(centers)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--solver", default="target/gridcap-ledger")
    args = ap.parse_args()
    q = 11
    total = matched = 0
    min_degree = 10**9
    types = []
    type_counts = Counter()
    for cls in sorted(KNIFE[q]):
        s3, centers = roots_for_class(q, cls)
        for center in centers:
            root = tuple(s3 + [center])
            vertices = legal_moves(q, root)
            adj = {v: set() for v in vertices}
            for x in vertices:
                replies = winning_replies(args.solver, q, root, x)
                assert replies <= set(vertices), (cls, center, x, replies - set(vertices))
                adj[x].update(replies)
            asymmetric = [(x, y) for x in vertices for y in adj[x] if x not in adj[y]]
            assert not asymmetric, (cls, center, asymmetric[:3])
            degrees = [len(adj[v]) for v in vertices]
            matching = perfect_matching(vertices, adj)
            graph = (tuple(vertices), adj)
            type_index = next((i for i, rep in enumerate(types) if isomorphic(graph, rep)), None)
            if type_index is None:
                type_index = len(types)
                types.append(graph)
            type_counts[type_index] += 1
            total += 1
            matched += matching is not None
            min_degree = min(min_degree, min(degrees))
            pairs = " ".join(f"{a[0]},{a[1]}-{b[0]},{b[1]}" for a, b in (matching or ()))
            print(
                f"REPLYGRAPH q={q} cls={cls} center={center[0]},{center[1]} "
                f"vertices={len(vertices)} edges={sum(degrees)//2} "
                f"mindeg={min(degrees)} maxdeg={max(degrees)} "
                f"type={type_index} perfect={int(matching is not None)} matching={pairs}"
            )
    type_hist = []
    for i, rep in enumerate(types):
        vertices, adj = rep
        type_hist.append((i, type_counts[i], len(vertices), sum(map(len, adj.values())) // 2))
    print(f"REPLYGRAPH-DONE roots={total} perfect={matched} min-degree={min_degree} "
          f"isomorphism-types={len(types)} representatives={type_hist}")
    assert matched == total


if __name__ == "__main__":
    main()
