"""
Compact Node-Kayles engine for the 3 x n strip (P_3 box P_n), OEIS A316632.

Game: G(graph) = mex_v G(graph - N[v]); disconnected -> XOR of components; empty -> 0.

Representation: a connected fragment is an induced connected subgraph of the
3 x infinity strip.  We encode geometry as a Python int bitmask:
    cell (r,c) with r in {0,1,2}  ->  bit index 3*c + r.
Column c occupies bits {3c, 3c+1, 3c+2}; its "column mask" is (g>>3c)&7.

Memo key = canonical mask-tuple (min over the strip's 4 automorphisms:
identity, vertical flip r<->2-r, horizontal reflection c<->w-1-c, and both),
shared across ALL n.  This is far more compact than a frozenset of (r,c) pairs.
"""
import sys

sys.setrecursionlimit(10**7)

# ---- bit / row masks (big enough for very wide fragments) ------------------
_MAXBITS = 3 * 400  # up to 400 columns
ROW01 = 0  # bits at positions p%3 in {0,1}  (rows 0 and 1)  -> can move UP (+1)
ROW12 = 0  # bits at positions p%3 in {1,2}  (rows 1 and 2)  -> can move DOWN (-1)
for _p in range(_MAXBITS):
    if _p % 3 in (0, 1):
        ROW01 |= 1 << _p
    if _p % 3 in (1, 2):
        ROW12 |= 1 << _p

VFLIP = [0, 4, 2, 6, 1, 5, 3, 7]  # swap bit0<->bit2 within a 3-bit column mask


def components(g):
    """Yield connected-component bitmasks of geometry int g."""
    comps = []
    rem = g
    while rem:
        low = rem & (-rem)
        comp = low
        while True:
            up = (comp & ROW01) << 1
            down = (comp & ROW12) >> 1
            left = comp >> 3
            right = comp << 3
            nxt = comp | ((up | down | left | right) & g)
            if nxt == comp:
                break
            comp = nxt
        comps.append(comp)
        rem &= ~comp
    return comps


def cols_of(g):
    """Return tuple of column masks after shifting lowest column to 0."""
    if g == 0:
        return ()
    # shift so lowest set bit's column -> column 0
    b0 = (g & -g).bit_length() - 1
    c0 = b0 // 3
    g >>= 3 * c0
    out = []
    while g:
        out.append(g & 7)
        g >>= 3
    return tuple(out)


def canon_key(g):
    """Canonical mask-tuple of a connected fragment geometry g."""
    cols = cols_of(g)
    v = tuple(VFLIP[m] for m in cols)
    rc = cols[::-1]
    rv = v[::-1]
    return min(cols, v, rc, rv)


def geom_from_cols(cols):
    g = 0
    for i, m in enumerate(cols):
        g |= m << (3 * i)
    return g


# neighbor-removal: for a move at bit b, remove b and its present nbrs.
def removal_mask(g, b):
    r = b % 3
    rm = 1 << b
    # up (r-1): bit b-1 valid if r>0
    if r > 0:
        rm |= (1 << (b - 1))
    # down (r+1): bit b+1 valid if r<2
    if r < 2:
        rm |= (1 << (b + 1))
    # left column
    rm |= (1 << (b - 3)) if b >= 3 else 0
    # right column
    rm |= (1 << (b + 3))
    return rm & (g | (1 << b))  # only actually-present cells (plus b itself)


memo = {}
_max_nimber = 0


def grundy(g):
    """Grundy value of CONNECTED fragment geometry g (single component)."""
    global _max_nimber
    key = canon_key(g)
    hit = memo.get(key)
    if hit is not None:
        return hit
    opts = set()
    m = g
    while m:
        low = m & (-m)
        b = low.bit_length() - 1
        m ^= low
        rm = removal_mask(g, b)
        g2 = g & ~rm
        if g2 == 0:
            opts.add(0)
            continue
        x = 0
        for comp in components(g2):
            x ^= grundy(comp)
        opts.add(x)
    mex = 0
    while mex in opts:
        mex += 1
    memo[key] = mex
    if mex > _max_nimber:
        _max_nimber = mex
    return mex


def grundy_grid(n):
    """G(3 x n grid).  Full strip is connected for n>=1."""
    g = 0
    for c in range(n):
        g |= 7 << (3 * c)
    if g == 0:
        return 0
    # full strip is a single component
    return grundy(g)
