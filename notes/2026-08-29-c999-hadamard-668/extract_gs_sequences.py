#!/usr/bin/env python3
"""Extract the four length-166 circulant first rows from the order-668 matrix.

Reads ``evidence/H668.txt`` (rows of ``+``/``-``), reads off the bordered
Goethals-Seidel data -- the 4x4 corner, the border-row block signs, the
per-slab column prefixes, and the four sequences A, B, C, D of length 166 --
then rebuilds the whole 668x668 matrix from that data alone and checks it
against the file byte for byte.

Prints each sequence as a ``+``/``-`` string, as the Lean ``List Int`` literal
used by ``HadamardMatrices.Order668.Sequences``, and its SHA-256.

Replay:  uv run --no-project python3 extract_gs_sequences.py
"""

import hashlib
import os
import sys

M = 166
N = 4 * M + 4


def load(path):
    rows = open(path).read().split()
    return [[1 if ch == "+" else -1 for ch in row] for row in rows]


def pm(seq):
    return "".join("+" if x == 1 else "-" for x in seq)


def rebuild(corner, border_block, prefix, a, b, c, d):
    """The bordered Goethals-Seidel array, in the same convention as the Lean
    module ``HadamardMatrices.BorderedGoethalsSeidel``.

    Rows and columns are ordered: the four border indices, then slab k = 0..3,
    each carrying offsets i = 0..M-1.  Body block (k, l) at offsets (i, j) is

        k = l                 a[(j - i) mod M]
        k = 0 or l = 0        sign * x[(-(i + j)) mod M]
        otherwise             sign * x[(i + j + 2) mod M]

    with the sign and the sequence x given by the tables below.
    """
    seq = {0: a, 1: b, 2: c, 3: d}
    # (k, l) -> (sign, which sequence), off-diagonal blocks only.
    outer = {(0, 1): (1, 1), (0, 2): (1, 2), (0, 3): (1, 3),
             (1, 0): (-1, 1), (2, 0): (-1, 2), (3, 0): (-1, 3)}
    inner = {(1, 2): (1, 3), (1, 3): (-1, 2), (2, 1): (-1, 3),
             (2, 3): (1, 1), (3, 1): (1, 2), (3, 2): (-1, 1)}

    def body(k, l, i, j):
        if k == l:
            return a[(j - i) % M]
        if (k, l) in outer:
            s, w = outer[(k, l)]
            return s * seq[w][(-(i + j)) % M]
        s, w = inner[(k, l)]
        return s * seq[w][(i + j + 2) % M]

    H = [[0] * N for _ in range(N)]
    for r in range(4):
        for s in range(4):
            H[r][s] = corner[r][s]
        for l in range(4):
            for j in range(M):
                H[r][4 + l * M + j] = border_block[r][l]
    for k in range(4):
        for i in range(M):
            row = 4 + k * M + i
            for s in range(4):
                H[row][s] = prefix[k][s]
            for l in range(4):
                for j in range(M):
                    H[row][4 + l * M + j] = body(k, l, i, j)
    return H


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(here, "evidence", "H668.txt")
    H = load(path)
    if len(H) != N or any(len(r) != N for r in H):
        sys.exit("unexpected shape")

    corner = [[H[r][s] for s in range(4)] for r in range(4)]
    border_block = [[H[r][4 + l * M] for l in range(4)] for r in range(4)]
    prefix = [[H[4 + k * M][s] for s in range(4)] for k in range(4)]

    a = [H[4][4 + j] for j in range(M)]
    # Block (0, l) is back-circulant with entry x[(-(i + j)) mod M], so its
    # first row read backwards is the sequence itself.
    b = [H[4][4 + M + (-j) % M] for j in range(M)]
    c = [H[4][4 + 2 * M + (-j) % M] for j in range(M)]
    d = [H[4][4 + 3 * M + (-j) % M] for j in range(M)]

    if rebuild(corner, border_block, prefix, a, b, c, d) != H:
        sys.exit("rebuilt matrix differs from the file")

    print("rebuild from (corner, border block signs, slab prefixes, A, B, C, D): exact match")
    print("corner            ", [pm(r) for r in corner])
    print("border block signs", [pm(r) for r in border_block])
    print("slab prefixes     ", [pm(r) for r in prefix])
    print()

    total = hashlib.sha256()
    for name, s in (("A", a), ("B", b), ("C", c), ("D", d)):
        text = pm(s)
        total.update(text.encode())
        print(f"{name} ({len(s)}) sum={sum(s)} sha256={hashlib.sha256(text.encode()).hexdigest()}")
        print(text)
    print(f"\nsha256 of the concatenation A||B||C||D: {total.hexdigest()}")

    paf = {s: sum(sum(x[i] * x[(i + s) % M] for i in range(M)) for x in (a, b, c, d))
           for s in range(M)}
    print("sum of periodic autocorrelations: at 0 -> %d, elsewhere -> %s"
          % (paf[0], sorted({paf[s] for s in range(1, M)})))
    print("row sums: %s" % [sum(x) for x in (a, b, c, d)])

    print("\nLean literals (HadamardMatrices/Order668/Sequences.lean):")
    for name, s in (("A", a), ("B", b), ("C", c), ("D", d)):
        print(f"def circulantRow{name} : List ℤ :=")
        for start in range(0, M, 24):
            chunk = ", ".join(str(x) for x in s[start:start + 24])
            lead = "  [" if start == 0 else "   "
            tail = "]" if start + 24 >= M else ","
            print(f"{lead}{chunk}{tail}")


if __name__ == "__main__":
    main()
