"""Node-Kayles on the 3 x n grid (OEIS A316632) — validation + boundedness probe.

Node-Kayles: alternately pick a vertex non-adjacent to all previously picked; the
player unable to move loses. Picking v removes N[v] (closed nbhd). Grundy(G) =
mex over v of Grundy(G - N[v]); disconnected -> XOR of component Grundys.

Component memo keyed on an isomorphism-canonical form (horizontal translation +
horizontal reflection + vertical flip r<->2-r are the strip's automorphisms; row
translation is NOT a symmetry, only 3 rows). Shared across all n.
"""

import sys
import time

sys.setrecursionlimit(10**7)

STEPS = ((1, 0), (-1, 0), (0, 1), (0, -1))


def components(cells):
    cells = set(cells)
    seen = set()
    comps = []
    for start in cells:
        if start in seen:
            continue
        stack = [start]
        seen.add(start)
        comp = []
        while stack:
            v = stack.pop()
            comp.append(v)
            r, c = v
            for dr, dc in STEPS:
                w = (r + dr, c + dc)
                if w in cells and w not in seen:
                    seen.add(w)
                    stack.append(w)
        comps.append(frozenset(comp))
    return comps


def canon(cells):
    best = None
    for fv in (False, True):
        for rh in (False, True):
            pts = []
            for (r, c) in cells:
                rr = 2 - r if fv else r
                cc = -c if rh else c
                pts.append((rr, cc))
            minc = min(c for _, c in pts)
            key = tuple(sorted((r, c - minc) for (r, c) in pts))
            if best is None or key < best:
                best = key
    return best


memo = {}


def grundy_component(cells):
    key = canon(cells)
    hit = memo.get(key)
    if hit is not None:
        return hit
    cellset = set(cells)
    opts = set()
    for v in cellset:
        r, c = v
        removed = {v}
        for dr, dc in STEPS:
            w = (r + dr, c + dc)
            if w in cellset:
                removed.add(w)
        g = 0
        for comp in components(cellset - removed):
            g ^= grundy_component(comp)
        opts.add(g)
    m = 0
    while m in opts:
        m += 1
    memo[key] = m
    return m


def grundy_grid(n):
    return grundy_component(frozenset((r, c) for r in range(3) for c in range(n)))


KNOWN = [2, 1, 1, 0, 3, 3, 2, 2, 2, 3, 3, 5, 2, 4, 1, 3, 2]  # A316632, n=1..17

t0 = time.time()
seq = []
for n in range(1, 31):
    g = grundy_grid(n)
    seq.append(g)
    maxg = max(memo.values())
    tag = ""
    if n <= len(KNOWN):
        tag = "OK" if g == KNOWN[n - 1] else f"MISMATCH(exp {KNOWN[n - 1]})"
    dt = time.time() - t0
    print(f"n={n:2d}: G={g}  {tag:18s} maxG_seen={maxg}  memo={len(memo)}  {dt:.1f}s",
          flush=True)
    if dt > 480:
        print("time budget hit; stopping", flush=True)
        break

print("seq =", seq, flush=True)
