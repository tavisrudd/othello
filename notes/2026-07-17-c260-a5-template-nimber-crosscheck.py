#!/usr/bin/env python3
"""C260 independent cross-check of A5 (and S4/V4) regular-template Node-Kayles nimbers.

Independent recomputation of the free-orbit (regular template) Node-Kayles Grundy values
that otherwise rest on the single Rust solver rust/scripts/nodekayles_cayley.rs.

INDEPENDENCE (see companion .md for the full statement):
  * Necessarily SHARED: the graph definition. For a generating involution triple T of a
    group G acting regularly, the template is the cubic Cayley graph Cay(G,T): one vertex
    per group element, an edge {g, g*t} for each t in T. This script rebuilds that graph in
    its own code, but the mathematical object is the same one the Rust solver evaluates.
  * INDEPENDENT: (a) the solver code here is freshly written; (b) the memo canonicalization
    is graph-isomorphism canonical labelling of each connected induced subposition, computed
    by the BLISS engine inside python-igraph -- NOT the hand-built left-mult x color-perm
    group-orbit minimum used by the Rust solver. Node-Kayles Grundy value is a graph
    isomorphism invariant, so keying the memo on a per-subgraph canonical certificate is
    sound and is a strictly different (and generally stronger) dedup than the Rust path.

The Rust solver and this script are mutually independent replays of the same finite
computation; agreement of all values is the cross-check.

Determinism: enumeration is fixed (no randomness, no seeds). igraph.canonical_permutation()
is deterministic. JSON output is sorted and timestamp-free.

Usage (run from repo rust/ dir, or anywhere):
    uv run --with igraph python3 <thisfile> <target> [sig]
      <target> in {V4, S4, A5}; optional <sig> like 2,3,5 restricts to one class.
    uv run --with igraph python3 <thisfile> emit-json > out.json   # all classes, canonical

Dependencies: python-igraph (BLISS canonical labelling). Pinned version reported in the JSON.
"""
import sys
import json
import time

# ---------------------------------------------------------------------------
# Permutation group machinery. Composition convention (p*q)[i] = p[q[i]] matches
# the Rust solver so the constructed Cayley graphs are identical, not merely iso.
# ---------------------------------------------------------------------------

def mul(p, q):
    return tuple(p[q[i]] for i in range(len(q)))

def is_ident(p):
    return all(i == x for i, x in enumerate(p))

def perm_order(p):
    x = p
    o = 1
    while not is_ident(x):
        x = mul(p, x)
        o += 1
    return o

def sign(p):
    inv = 0
    n = len(p)
    for i in range(n):
        for j in range(i + 1, n):
            if p[i] > p[j]:
                inv += 1
    return 1 if inv % 2 == 0 else -1

def all_perms(n):
    """Same swap-recursion order as the Rust all_perms()."""
    v = list(range(n))
    out = []

    def rec(k):
        if k == n:
            out.append(tuple(v))
            return
        for i in range(k, n):
            v[k], v[i] = v[i], v[k]
            rec(k + 1)
            v[k], v[i] = v[i], v[k]

    rec(0)
    return out

def closure(gens, n):
    ident = tuple(range(n))
    seen = {ident}
    frontier = [ident]
    while frontier:
        g = frontier.pop()
        for s in gens:
            h = mul(g, s)
            if h not in seen:
                seen.add(h)
                frontier.append(h)
    return sorted(seen)

# ---------------------------------------------------------------------------
# Build one representative Cayley graph per pairwise-product-order signature.
# Mirrors solve_group() in the Rust solver: first triple (in the fixed element
# ordering) per signature whose closure is the whole group.
# ---------------------------------------------------------------------------

def build_classes(n, even_only):
    target = (factorial(n) // 2) if even_only else factorial(n)
    els = [p for p in all_perms(n) if (not even_only) or sign(p) == 1]
    invols = [p for p in els if (not is_ident(p)) and is_ident(mul(p, p))]
    reps = {}  # sig(tuple) -> triple
    m = len(invols)
    for i in range(m):
        for j in range(i + 1, m):
            for k in range(j + 1, m):
                tri = (invols[i], invols[j], invols[k])
                if len(closure(tri, n)) != target:
                    continue
                sig = tuple(sorted((
                    perm_order(mul(tri[0], tri[1])),
                    perm_order(mul(tri[0], tri[2])),
                    perm_order(mul(tri[1], tri[2])),
                )))
                if sig not in reps:
                    reps[sig] = tri
    return target, invols, reps

def factorial(n):
    r = 1
    for i in range(2, n + 1):
        r *= i
    return r

def cayley_graph(tri, n):
    group = closure(tri, n)
    idx = {g: i for i, g in enumerate(group)}
    v = len(group)
    adj = [0] * v
    for g in group:
        i = idx[g]
        for t in tri:
            h = mul(g, t)
            j = idx[h]
            if i != j:
                adj[i] |= 1 << j
                adj[j] |= 1 << i
    closed = [adj[x] | (1 << x) for x in range(v)]
    return v, adj, closed

def k4_graph():
    """V4 template = K4 = Cay(V4, its 3 involutions). Closed-form Grundy = 1."""
    v = 4
    adj = [0] * v
    for i in range(v):
        for j in range(v):
            if i != j:
                adj[i] |= 1 << j
    closed = [adj[x] | (1 << x) for x in range(v)]
    return v, adj, closed

# ---------------------------------------------------------------------------
# Independent Node-Kayles Grundy solver.
#   * connected-component decomposition, Grundy = XOR of component Grundies
#   * memo keyed on BLISS graph-iso canonical certificate of the induced subgraph
# ---------------------------------------------------------------------------

def bits(mask):
    out = []
    while mask:
        low = mask & (-mask)
        out.append(low.bit_length() - 1)
        mask &= mask - 1
    return out

def make_solver(adj, closed):
    import igraph

    raw_memo = {}
    canon_memo = {}
    stats = {"canon_calls": 0}

    def component(rem, start):
        comp = start
        while True:
            nb = 0
            b = comp
            while b:
                v = (b & -b).bit_length() - 1
                nb |= adj[v]
                b &= b - 1
            new = comp | (nb & rem)
            if new == comp:
                return comp
            comp = new

    def canon(comp):
        stats["canon_calls"] += 1
        verts = bits(comp)
        loc = {v: i for i, v in enumerate(verts)}
        edges = []
        for v in verts:
            nb = adj[v] & comp
            b = nb
            while b:
                w = (b & -b).bit_length() - 1
                if v < w:
                    edges.append((loc[v], loc[w]))
                b &= b - 1
        g = igraph.Graph(n=len(verts), edges=edges)
        perm = g.canonical_permutation()
        ce = sorted(
            (min(perm[a], perm[b]), max(perm[a], perm[b])) for (a, b) in edges
        )
        return (len(verts), tuple(ce))

    def grundy(mask):
        if mask == 0:
            return 0
        g = 0
        rem = mask
        while rem:
            start = rem & (-rem)
            comp = component(rem, start)
            g ^= grundy_conn(comp)
            rem &= ~comp
        return g

    def grundy_conn(comp):
        v = raw_memo.get(comp)
        if v is not None:
            return v
        key = canon(comp)
        v = canon_memo.get(key)
        if v is not None:
            raw_memo[comp] = v
            return v
        opts = set()
        b = comp
        while b:
            vv = (b & -b).bit_length() - 1
            child = comp & ~closed[vv]
            opts.add(grundy(child))
            b &= b - 1
        m = 0
        while m in opts:
            m += 1
        canon_memo[key] = m
        raw_memo[comp] = m
        return m

    def solve(nv):
        full = (1 << nv) - 1
        return grundy(full)

    return solve, canon_memo, raw_memo, stats

def graph_girth(adj, nv):
    from collections import deque
    best = None
    for s in range(nv):
        dist = [-1] * nv
        par = [-1] * nv
        dist[s] = 0
        dq = deque([s])
        while dq:
            u = dq.popleft()
            b = adj[u]
            while b:
                w = (b & -b).bit_length() - 1
                b &= b - 1
                if dist[w] == -1:
                    dist[w] = dist[u] + 1
                    par[w] = u
                    dq.append(w)
                elif w != par[u]:
                    c = dist[u] + dist[w] + 1
                    if best is None or c < best:
                        best = c
    return best

def run_target(target, sig_filter=None, verbose=True):
    results = []
    if target == "V4":
        nv, adj, closed = k4_graph()
        solve, cm, rm, st = make_solver(adj, closed)
        t0 = time.time()
        g = solve(nv)
        dt = time.time() - t0
        girth = 3
        rec = {"group": "V4", "sig": [2, 2, 2], "vertices": nv, "edges": 6,
               "girth": girth, "grundy": g, "canon_states": len(cm),
               "raw_states": len(rm), "seconds": round(dt, 3)}
        results.append(rec)
        if verbose:
            print(f"V4 sig=(2,2,2) K4: G={g} canon={len(cm)} raw={len(rm)} {dt:.2f}s")
        return results
    n = 4 if target == "S4" else 5
    even = (target == "A5")
    _, invols, reps = build_classes(n, even)
    for sig in sorted(reps):
        if sig_filter is not None and list(sig) != list(sig_filter):
            continue
        tri = reps[sig]
        nv, adj, closed = cayley_graph(tri, n)
        edges = sum(bin(adj[i]).count("1") for i in range(nv)) // 2
        girth = graph_girth(adj, nv)
        solve, cm, rm, st = make_solver(adj, closed)
        t0 = time.time()
        g = solve(nv)
        dt = time.time() - t0
        rec = {"group": target, "sig": list(sig), "vertices": nv, "edges": edges,
               "girth": girth, "grundy": g, "canon_states": len(cm),
               "raw_states": len(rm), "seconds": round(dt, 3)}
        results.append(rec)
        if verbose:
            print(f"{target} sig={sig}: G={g} vtx={nv} edges={edges} girth={girth} "
                  f"canon={len(cm)} raw={len(rm)} {dt:.1f}s")
    return results

def emit_json():
    import igraph
    out = {
        "task": "C260",
        "description": "Independent cross-check of A5/S4/V4 regular-template Node-Kayles nimbers",
        "method": "graph-iso canonical (BLISS/igraph) memoized Sprague-Grundy, "
                  "connected-component xor; independent of rust/scripts/nodekayles_cayley.rs",
        "igraph_version": igraph.__version__,
        "convention": "template = Cay(G,T) cubic; move deletes closed nbhd N[v]; "
                      "sig = sorted pairwise product orders of the generating triple",
        "results": [],
    }
    for tgt in ("V4", "S4", "A5"):
        out["results"].extend(run_target(tgt, verbose=False))
    # canonical sort
    out["results"].sort(key=lambda r: (r["group"], r["sig"]))
    for r in out["results"]:
        r.pop("seconds", None)  # timings are not canonical evidence
    print(json.dumps(out, indent=2, sort_keys=True))

def main():
    args = sys.argv[1:]
    if not args:
        print("usage: <target V4|S4|A5> [sig like 2,3,5] | emit-json")
        return
    if args[0] == "emit-json":
        emit_json()
        return
    tgt = args[0]
    sig = None
    if len(args) > 1:
        sig = [int(x) for x in args[1].split(",")]
    run_target(tgt, sig_filter=sig, verbose=True)

if __name__ == "__main__":
    main()
