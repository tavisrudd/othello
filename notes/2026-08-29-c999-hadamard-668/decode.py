#!/usr/bin/env python3
"""Independent re-implementation of the Hadamard-matrix decoder that was posted
alongside the order-668 announcement.

Reads   evidence/payload.txt   (23828 characters, alphabet {+, -})
Writes  evidence/H<order>.txt  one row of +/- per line, for each of the 12 orders
Prints  order, block parameters, sha256 of the written file, sanity-check result.

Nothing from the poster's shell script is executed.  Everything below was derived
by reading the statically de-obfuscated script (evidence/decoder-deobfuscated.sh)
and re-expressing what its sed programs compute.  See README.md.

Deterministic; no network; standard library only.
"""

import hashlib
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
EVID = os.path.join(HERE, "evidence")

# ---------------------------------------------------------------------------
# Record header.  The de-obfuscated script carries this literal string and maps
# each letter a..p to four sign characters ('+' = bit 1, '-' = bit 0, a = 1111,
# p = 0000).  The resulting bit string is cut into 16-bit records: a 3-bit
# family tag followed by a 13-bit big-endian length in payload characters.
# ---------------------------------------------------------------------------
HEADER = "bnghbndhdmiddljddlcdhkkhjkhpbjhhbjbhfiipdigddifd"
FAMILY = {"+++": "h", "++-": "g", "+-+": "w", "+--": "v", "-++": "u"}

# Extra payload consumed by the three multi-block families, beyond the n data
# characters: (blocks, border width, outer iterations, border chunk, prefix chunk).
BIG = {
    #      blocks border  iters  border-chunk  prefix-chunk-per-group
    "w": dict(nb=16,  bw=12, nit=4,  bchunk=336,  pchunk=48,  nsign=16, grp=1),
    "v": dict(nb=24,  bw=20, nit=6,  bchunk=880,  pchunk=120, nsign=24, grp=3),
    "u": dict(nb=128, bw=28, nit=32, bchunk=1680, pchunk=896, nsign=32, grp=8),
}

# The four rows of the Goethals-Seidel array, as block-index/negation/transpose
# recipes over the super-blocks A, B, C, D.  "'" marks the block-transposed copy.
GS_DIRS = ["rlll", "lrll", "llrl", "lllr"]


# --------------------------- string primitives -----------------------------
def neg(s):
    return s.translate(str.maketrans("+-", "-+"))


def rev(s):
    return s[::-1]


def rotl(s):
    return s[1:] + s[:1]


def rotr(s):
    return s[-1:] + s[:-1]


def blk(s, m):
    return [s[i:i + m] for i in range(0, len(s), m)]


def tr(s):
    """Circulant transpose of a first row: X'[i] = X[(-i) mod m]."""
    return s[0] + s[:0:-1]


# ------------------------------ header parsing -----------------------------
def parse_header():
    bits = "".join(format(15 - i, "04b") for i in range(16))
    tab = {c: bits[4 * i:4 * i + 4].replace("1", "+").replace("0", "-")
           for i, c in enumerate("abcdefghijklmnop")}
    b = "".join(tab[c] for c in HEADER)
    out = []
    while b:
        tag, ln, b = b[:3], b[3:16], b[16:]
        out.append((FAMILY[tag], int(ln.replace("+", "1").replace("-", "0"), 2)))
    return out


# ---------------- family h / g : plain or bordered Goethals-Seidel ----------
def rows_hg(d, bordered):
    """n data characters -> four circulants of length m = n/4 in a Goethals-Seidel
    array (order 4m), optionally with a 4-row/4-column border (order 4m + 4)."""
    m = len(d) // 4
    A, B, C, D = (d[i * m:(i + 1) * m] for i in range(4))
    rows = []
    if bordered:
        e, f = "+" * m, "-" * m
        rows += ["-++-" + f + f + f + e,
                 "+-+-" + f + f + e + f,
                 "++--" + f + e + f + f,
                 "----" + e + f + f + f]
    slabs = [
        ("+++-", (A, rev(B), rev(C), rev(D))),
        ("--+-", (neg(rev(B)), A, rotl(D), rotl(neg(C)))),
        ("-+--", (neg(rev(C)), rotl(neg(D)), A, rotl(B))),
        ("+---", (neg(rev(D)), rotl(C), rotl(neg(B)), A)),
    ]
    for k, (border, seed) in enumerate(slabs):
        cur = list(seed)
        for _ in range(m):
            rows.append((border if bordered else "") + "".join(cur))
            cur = [rotr(s) if GS_DIRS[k][j] == "r" else rotl(s)
                   for j, s in enumerate(cur)]
    return rows


# ------------- families w / v / u : bordered multi-block GS array -----------
def permute_w(bl, nb, k, rem):
    if rem in (3, 1):                                    # s/==/\2\1/g
        bl[:] = [bl[i ^ 1] for i in range(nb)]
    elif rem == 2:                                       # s/====/\4\3\2\1/g
        bl[:] = [bl[(i // 4) * 4 + 3 - i % 4] for i in range(nb)]


def permute_v(bl, nb, k, rem):
    per = nb // 4
    def shift(i):                                        # [b0,b1,b2] -> [b1,b2,b0]
        bl[i:i + 3] = bl[i + 1:i + 3] + bl[i:i + 1]
    shift(per * k); shift(per * k + 3)                   # s/^\(Z K^k\)QQ/\1\3\2\5\4/
    for i in range(0, nb, 3):                            # s/Q/\2\1/g
        shift(i)
    if rem == 3:                                         # s/WW/\2\1/g
        for i in range(0, nb, 6):
            bl[i:i + 6] = bl[i + 3:i + 6] + bl[i:i + 3]


def permute_u(bl, nb, k, rem):
    per = nb // 4
    for i in range(per * k, per * (k + 1), 8):           # s/^\(Z K^k\)QQQQ/~/
        bl[i:i + 8] = bl[i + 6:i + 8] + bl[i:i + 6]
    for i in range(0, nb, 8):                            # s/^WWWW/M/ ...
        bl[i:i + 8] = bl[i + 1:i + 8] + bl[i:i + 1]
    if rem in (24, 16, 8):                               # V: swap adjacent octets
        for i in range(0, nb, 16):
            bl[i:i + 16] = bl[i + 8:i + 16] + bl[i:i + 8]
    if rem == 16:                                        # U: swap adjacent 16-groups
        for i in range(0, nb, 32):
            bl[i:i + 32] = bl[i + 16:i + 32] + bl[i:i + 16]


PERMUTE = {"w": permute_w, "v": permute_v, "u": permute_u}


def rows_big(fam, d, extra):
    p = BIG[fam]
    nb, bw, nit, grp = p["nb"], p["bw"], p["nit"], p["grp"]
    m = len(d) // nb                      # circulant length
    per = nb // 4                         # blocks per super-block
    q = per * m                           # super-block length in characters

    # block-transposed copy: reverse each circulant, then, inside each group of
    # `grp` consecutive blocks, keep the first and reverse the rest.
    t = [tr(b) for b in blk(d, m)]
    tt = []
    for i in range(0, nb, grp):
        tt += [t[i]] + t[i + grp - 1:i:-1]
    tt = "".join(tt)

    rows = []
    rw = bw + p["nsign"]
    for i in range(bw):                   # constant-block border rows
        rec = extra[rw * i:rw * (i + 1)]
        sg = rec[bw:rw]
        if fam == "u":                    # s/\\.\\./&&&&/g : each sign pair x4
            sg = "".join(sg[2 * j:2 * j + 2] * 4 for j in range(len(sg) // 2))
        rows.append(rec[:bw] + "".join(c * m for c in sg))

    base = bw * rw
    pre = [extra[base + bw * nit * k: base + bw * nit * (k + 1)] for k in range(4)]

    nd, nt = neg(d), neg(tt)
    data = [
        d[0:q] + tt[q:4 * q],
        nt[q:2 * q] + d[0:q] + d[3 * q:4 * q] + nd[2 * q:3 * q],
        nt[2 * q:3 * q] + nd[3 * q:4 * q] + d[0:2 * q],
        nt[3 * q:4 * q] + d[2 * q:3 * q] + nd[q:2 * q] + d[0:q],
    ]
    for k in range(4):
        bl = blk(data[k], m)
        for it in range(nit):
            cur = list(bl)
            border = pre[k][bw * it:bw * (it + 1)]
            for _ in range(m):
                rows.append(border + "".join(cur))
                cur = [rotr(s) if GS_DIRS[k][j // per] == "r" else rotl(s)
                       for j, s in enumerate(cur)]
            bl = cur                      # a full cycle returns to the start
            PERMUTE[fam](bl, nb, k, nit - it - 1)
    return rows


# --------------------------------- driver ----------------------------------
def sanity(rows, npairs=400):
    """Cheap check: square shape and a deterministic sample of orthogonal pairs."""
    n = len(rows)
    if any(len(r) != n for r in rows):
        return "NOT SQUARE"
    ok = 0
    for k in range(npairs):
        i = (37 * k) % n
        j = (i + 1 + (101 * k) % (n - 1)) % n
        if sum(1 if a == b else -1 for a, b in zip(rows[i], rows[j])) == 0:
            ok += 1
    return "%d/%d sampled row pairs orthogonal" % (ok, npairs)


def main():
    payload = open(os.path.join(EVID, "payload.txt")).read().strip()
    if set(payload) != {"+", "-"}:
        sys.exit("payload alphabet is not {+,-}")
    pos = 0
    for fam, n in parse_header():
        d = payload[pos:pos + n]; pos += n
        if fam in ("h", "g"):
            rows = rows_hg(d, bordered=(fam == "h"))
            note = "4 circulants of length %d%s" % (n // 4,
                   ", 4-row border" if fam == "h" else "")
        else:
            p = BIG[fam]
            extra = payload[pos:pos + p["bchunk"] + 4 * p["pchunk"]]
            pos += len(extra)
            rows = rows_big(fam, d, extra)
            note = "%d circulants of length %d, %d-column border" % (
                p["nb"], n // p["nb"], p["bw"])
        order = len(rows)
        path = os.path.join(EVID, "H%d.txt" % order)
        body = "\n".join(rows) + "\n"
        open(path, "w").write(body)
        print("%-5s order %-5d  %-45s sha256 %s  %s" % (
            fam, order, note, hashlib.sha256(body.encode()).hexdigest(),
            sanity(rows)))
    if pos != len(payload):
        sys.exit("payload not fully consumed: %d of %d" % (pos, len(payload)))
    print("payload fully consumed: %d characters" % pos)


if __name__ == "__main__":
    main()
