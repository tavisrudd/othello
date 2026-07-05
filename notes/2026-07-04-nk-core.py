"""
Node-Kayles nimber core.

Game (exact):
  G(graph) = mex over vertices v of G(graph - N[v]), N[v] = closed nbhd (v + nbrs).
  Disconnected => XOR of component nimbers. Empty graph => 0.

Two independent solvers:
  * nimber_graph(n, adj_bits): bitmask solver for ARBITRARY graphs (validation).
    Memoizes by vertex-subset mask within a fixed graph. Correct, no isomorphism.
  * nimber_forest / nimber_tree: tree-specialized solver. A tree minus N[v] is a
    forest of trees, so the game stays inside forests-of-trees. Memoizes nimber(tree)
    by AHU unrooted canonical string across ALL trees ever seen (global cache) =>
    huge reuse for paths/caterpillars/spiders.
"""
import sys
sys.setrecursionlimit(200000)


def mex(s):
    x = 0
    while x in s:
        x += 1
    return x


# ---------------------------------------------------------------------------
# Bitmask solver (arbitrary graphs) -- ground truth for validation
# ---------------------------------------------------------------------------
def nimber_graph(n, adj_bits):
    """adj_bits[v] = int bitmask of OPEN neighbors of v (bit u set if edge u-v).
    Returns nimber of the whole graph on vertex set {0..n-1}."""
    closed = [adj_bits[v] | (1 << v) for v in range(n)]
    memo = {}

    def solve(mask):
        if mask == 0:
            return 0
        r = memo.get(mask)
        if r is not None:
            return r
        vals = set()
        m = mask
        while m:
            low = m & (-m)
            v = low.bit_length() - 1
            m ^= low
            vals.add(solve(mask & ~closed[v]))
        r = mex(vals)
        memo[mask] = r
        return r

    return solve((1 << n) - 1)


# ---------------------------------------------------------------------------
# Tree AHU canonicalization
# ---------------------------------------------------------------------------
def _rooted_canon(adj, root):
    """Iterative post-order AHU canonical string for a tree rooted at `root`."""
    parent = {root: None}
    order = [root]
    stack = [root]
    while stack:
        u = stack.pop()
        for w in adj[u]:
            if w not in parent:
                parent[w] = u
                order.append(w)
                stack.append(w)
    code = {}
    for u in reversed(order):
        kids = sorted(code[w] for w in adj[u] if w != parent[u])
        code[u] = "(" + "".join(kids) + ")"
    return code[root]


def tree_centers(adj):
    """Return the 1 or 2 center vertices of a tree (peel leaves)."""
    verts = list(adj.keys())
    if len(verts) == 1:
        return verts
    deg = {v: len(adj[v]) for v in verts}
    leaves = [v for v in verts if deg[v] <= 1]
    remaining = len(verts)
    while remaining > 2:
        new_leaves = []
        for v in leaves:
            deg[v] = -1
            remaining -= 1
            for w in adj[v]:
                if deg[w] > 0:
                    deg[w] -= 1
                    if deg[w] == 1:
                        new_leaves.append(w)
        leaves = new_leaves
    return [v for v in verts if deg[v] >= 0]


def tree_canon(adj):
    """Unrooted canonical string of a tree given as adjacency dict (set values)."""
    centers = tree_centers(adj)
    if len(centers) == 1:
        return _rooted_canon(adj, centers[0])
    a, b = _rooted_canon(adj, centers[0]), _rooted_canon(adj, centers[1])
    return a if a <= b else b


# ---------------------------------------------------------------------------
# Tree / forest nimber solver (global memo by tree canonical form)
# ---------------------------------------------------------------------------
_TREE_MEMO = {}


def _components(verts, adj):
    """Connected components of the induced subgraph on `verts` (set)."""
    seen = set()
    comps = []
    for s in verts:
        if s in seen:
            continue
        comp = []
        stack = [s]
        seen.add(s)
        while stack:
            u = stack.pop()
            comp.append(u)
            for w in adj[u]:
                if w in verts and w not in seen:
                    seen.add(w)
                    stack.append(w)
        comps.append(comp)
    return comps


def nimber_tree(adj):
    """Nimber of a CONNECTED tree given as adjacency dict (values are sets).
    Uses global canonical-form memo."""
    key = tree_canon(adj)
    r = _TREE_MEMO.get(key)
    if r is not None:
        return r
    vset = set(adj.keys())
    vals = set()
    # dedup identical moves by child-forest canonical multiset (speeds big trees)
    seen_moves = set()
    for v in list(vset):
        removed = adj[v] | {v}
        remaining = vset - removed
        if not remaining:
            vals.add(0)
            continue
        comps = _components(remaining, adj)
        # canonical signature of the resulting forest (multiset of component canons)
        sub_keys = []
        g = 0
        for comp in comps:
            sub = {u: (adj[u] & set(comp)) for u in comp}
            ck = tree_canon(sub)
            sub_keys.append(ck)
            g ^= _canon_nimber(ck, sub)
        sig = tuple(sorted(sub_keys))
        if sig in seen_moves:
            continue
        seen_moves.add(sig)
        vals.add(g)
    r = mex(vals)
    _TREE_MEMO[key] = r
    return r


def _canon_nimber(ck, sub_adj):
    r = _TREE_MEMO.get(ck)
    if r is not None:
        return r
    return nimber_tree(sub_adj)


def nimber_forest(adj):
    """Nimber of a forest (adjacency dict, possibly disconnected)."""
    vset = set(adj.keys())
    g = 0
    for comp in _components(vset, adj):
        sub = {u: (adj[u] & set(comp)) for u in comp}
        g ^= nimber_tree(sub)
    return g


# ---------------------------------------------------------------------------
# Graph builders
# ---------------------------------------------------------------------------
def path_adj(n):
    adj = {i: set() for i in range(n)}
    for i in range(n - 1):
        adj[i].add(i + 1)
        adj[i + 1].add(i)
    return adj


def star_adj(k):
    """K_{1,k}: center 0 with k leaves."""
    adj = {0: set(range(1, k + 1))}
    for i in range(1, k + 1):
        adj[i] = {0}
    return adj


def adj_to_bits(adj):
    """Relabel adjacency dict to 0..n-1 and return (n, adj_bits list)."""
    verts = sorted(adj.keys())
    idx = {v: i for i, v in enumerate(verts)}
    n = len(verts)
    bits = [0] * n
    for v in verts:
        for w in adj[v]:
            bits[idx[v]] |= (1 << idx[w])
    return n, bits


def nimber_graph_from_adj(adj):
    n, bits = adj_to_bits(adj)
    return nimber_graph(n, bits)


# ---------------------------------------------------------------------------
# Path nimber via direct DP (fast, independent of tree solver) -> A002187
# ---------------------------------------------------------------------------
def path_nimbers(N):
    """G(P_0..P_N). Move at position p (1-indexed) leaves P_{p-2} + P_{n-p-1}."""
    g = [0] * (N + 1)
    for n in range(1, N + 1):
        s = set()
        for p in range(1, n + 1):
            left = p - 2
            right = n - p - 1
            gl = g[left] if left >= 0 else 0
            gr = g[right] if right >= 0 else 0
            s.add(gl ^ gr)
        g[n] = mex(s)
    return g
