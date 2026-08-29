"""C997 closeout: what the Z_12 x Z_6 translation group does to the gross code's
logical classes, and whether the two qubit blocks are related by a code symmetry.

Two questions, both pure combinatorics, both cheap:

1. The translation group acts linearly on the 12-dimensional logical class space
   F_2^12.  The number of orbits on the 4095 nonzero classes is the smallest
   number of integer programs any per-class pipeline could get away with, and it
   predicts a priori how much redundancy the upstream `k`-program pipeline has.

2. The symmetry-broken run solves one program per qubit block and the two came
   out very unequal (305,827 versus 704,664 nodes).  If block L and block R were
   exchanged by a code automorphism, one of the two solves would be redundant.
   Checked by asking whether the block swap preserves rowspace(hx).

Replay:
  uv run --with bposd --with numpy python logical_orbit_structure.py \
      --out results_logical_orbit_structure.json
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np

from gross_distance_experiment import ELL, M, build_gross_code, gf2_rank, translation_perm


def class_matrix(lx, lz, perm):
    """12x12 matrix over F_2 of the action induced by `perm` on logical classes.

    A Z-type operator's class is read off by its overlaps with the X logicals,
    class(c) = lx . c.  Column j is the class of the translate of lz[j].
    """
    k = lz.shape[0]
    cols = []
    for j in range(k):
        moved = np.zeros_like(lz[j])
        moved[perm] = lz[j]
        cols.append((lx @ moved) % 2)
    return np.array(cols, dtype=int).T % 2


def orbit_count(matrices, dim):
    seen = set()
    orbits = 0
    sizes = []
    for value in range(1, 1 << dim):
        if value in seen:
            continue
        vec = np.array([(value >> i) & 1 for i in range(dim)], dtype=int)
        orbit = set()
        for mat in matrices:
            image = (mat @ vec) % 2
            orbit.add(int(sum(int(b) << i for i, b in enumerate(image))))
        seen |= orbit
        orbits += 1
        sizes.append(len(orbit))
    return orbits, sorted(set(sizes))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    hx, hz, lx, lz, _, _ = build_gross_code()
    n2 = ELL * M

    matrices = []
    for u in range(ELL):
        for v in range(M):
            matrices.append(class_matrix(lx, lz, translation_perm(u, v)))
    orbits, sizes = orbit_count(matrices, lz.shape[0])

    # how many distinct linear maps the 72 translations induce on classes
    distinct = len({mat.tobytes() for mat in matrices})

    # block swap: does exchanging the two qubit blocks preserve the code?
    swap = np.concatenate([np.arange(n2, 2 * n2), np.arange(n2)])
    hx_swapped = np.zeros_like(hx)
    hx_swapped[:, swap] = hx % 2
    hz_swapped = np.zeros_like(hz)
    hz_swapped[:, swap] = hz % 2
    rank_hx = gf2_rank(hx % 2)
    rank_hz = gf2_rank(hz % 2)
    swap_preserves_hx = gf2_rank(np.vstack([hx % 2, hx_swapped])) == rank_hx
    swap_preserves_hz = gf2_rank(np.vstack([hz % 2, hz_swapped])) == rank_hz
    # does the swap exchange the X and Z check spaces instead?
    swap_exchanges = (
        gf2_rank(np.vstack([hz % 2, hx_swapped])) == rank_hz
        and gf2_rank(np.vstack([hx % 2, hz_swapped])) == rank_hx
    )

    record = {
        "translation_group_order": len(matrices),
        "distinct_induced_maps_on_classes": distinct,
        "nonzero_classes": (1 << lz.shape[0]) - 1,
        "orbits_on_nonzero_classes": orbits,
        "orbit_sizes_present": sizes,
        "block_swap_preserves_rowspace_hx": bool(swap_preserves_hx),
        "block_swap_preserves_rowspace_hz": bool(swap_preserves_hz),
        "block_swap_exchanges_hx_hz": bool(swap_exchanges),
    }
    Path(args.out).write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
    print(json.dumps(record))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
