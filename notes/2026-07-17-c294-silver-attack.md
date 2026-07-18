# C294 Crown I silver attack: the minimal three-centre gate

**Date:** 2026-07-17
**Lane:** `crowns`
**Status:** theorem route isolated; silver remains open.

## Target and minimal size

Crown I silver asks for a tame P/N classification of every legal configuration of one fixed size,
including the proper, subfield, and full `PSL2/PGL2` cases. Three off-conic centres are the minimal
honest battlefield: two involutions generate only a cyclic/dihedral subgroup, while three can
already generate a full linear group.

For a legal triple `S`, let `R_S` be its fixed/dead-vertex-deleted conic Schreier graph. It has
maximum degree three. Define two noncircular P-certificates:

1. a **pairing reply** leaves a residual with a fixed-point-free nonadjacent involutory
   automorphism; and
2. a **degree-two reply** leaves a disjoint union of paths and cycles whose exact Dawson
   Node--Kayles nimbers xor to zero.

If every first move has a reply of the stated type, ordinary Node--Kayles semantics proves
`G(R_S)=0`; no root value is used in the certificate test.

## Exact bounded gate

Every legal off-conic triple was checked at `q=5,7,11`.

| q | legal triples | P triples | two-ply pairing | degree-two reply | union | P outside union |
|---:|---:|---:|---:|---:|---:|---:|
| 5 | 1,980 | 625 | 625 | 625 | 625 | 0 |
| 7 | 16,408 | 6,258 | 6,258 | 6,258 | 6,258 | 0 |
| 11 | 265,980 | 109,175 | 31,625 | 106,535 | 107,855 | 1,320 |

All certificate false-positive counts are zero. The path/cycle evaluator is independently
cross-checked against direct recursion at every graph size through 12 vertices.

### The exact q=11 boundary

The 2,640 P triples not certified by a degree-two reply are exactly three `PGL2(11)` conjugacy
orbits, and every representative generates the full group of order 1,320:

| orbit size | pair-product orders | residual | root pairing | role |
|---:|---|---|---|---|
| 660 | `(2,12,12)` | connected, 12 vertices, triangle-free | yes | pairing exception |
| 660 | `(6,12,12)` | connected, 12 vertices, triangle-free | yes | pairing exception |
| 1,320 | `(2,3,11)` | connected, 11 vertices, 14 edges, 2 triangles | no | sole union exception |

The last graph has degree sequence `(1,2,2,2,3,3,3,3,3,3,3)`. Thus q=11 admits a crisp finite
base theorem: degree-two response, two pairing orbits, and one named full-group `(2,3,11)` graph
requiring a bounded direct strategy certificate.

## Why the first response law is not the uniform silver mechanism

There is a simple size obstruction. If `G` is subcubic and
`G-N[v]-N[w]` has maximum degree at most two, every degree-three vertex of `G` lies in the union
of the radius-two balls about `v` and `w`. Each such ball has at most `1+3+6=10` vertices, so `G`
has at most 20 degree-three vertices.

Consequently a one-reply degree-two collapse cannot handle the large nearly cubic full-group
residuals. The q=5--11 success is a strong base layer, not an asymptotic classification theorem.
The q=11 exceptional orbit likewise does not justify a finite-template extrapolation.

## Silver attack

The remaining proof should be split by Dickson type, with no cross-stratum handwaving:

1. **Proper groups:** import the proved cyclic/dihedral/polyhedral orbit-template values and consume
   the direct-strategy layer when C199 delivers it.
2. **Subfield groups:** prove an orbit decomposition for `PSL2(q0),PGL2(q0)` acting on `P1(q)` and
   an exact value-preserving descent to the definition field, including the free-orbit parity
   contribution. A unipotent/no-common-fixed-point argument alone does not exclude this row.
3. **Full groups:** choose one generator pair and decompose the graph into its alternating
   dihedral orbits. The third involution is then a correlated matching between those path/cycle
   backbones. The needed new theorem is a recursive scar/transfer rule that preserves P/N while
   peeling these backbones; immediate pairing and immediate degree degradation are only its base
   cases.
4. **Finite exceptions:** discharge bounded trace/order classes such as the q=11 `(2,3,11)` orbit
   by compact direct certificates, never by folding them into the uniform rule rhetorically.

The natural algebraic coordinates are the three pair-product traces/orders plus the full
trace/definition field. A successful quotient must preserve legal replies and P/N, not merely
spectra, coherent-configuration data, or conjugacy.

## Relation to the strengthened bronze family

The companion C294 theorem now gives exactly `(p-5)/2` mirror-certified full-`PGL2(p)` four-centre
configurations for every eligible prime. That one-dimensional family is the first full-group
stratum and supplies the trace/subfield test bed, but it is not silver: it does not classify every
configuration at a fixed size.

## Evidence and replay

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-17-c294-silver-three-centre-gate.py 5 7 11 \
  --check notes/2026-07-17-c294-silver-three-centre-gate.json
sha256sum -c notes/2026-07-17-c294-silver-three-centre-gate.sha256
```

The checker uses the independent coordinate construction in `three_centre_probe.py`, exact direct
Grundy recursion for root classification, exact abstract-automorphism backtracking for pairing,
the path/cycle recurrence for structural certificates, and exhaustive `PGL2(q)` conjugation for
the exception-orbit audit. The computation certifies only q=5,7,11. It does not prove that the
listed certificate hierarchy remains dense, bounded-depth, or complete for larger fields.

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-17-c294-silver-three-centre-gate.py` | 11,583 | `4b85a4f7a688a3d6c98b8a4cc241d9651ee3e2ce77674000978db694a37d3549` |
| `notes/2026-07-17-c294-silver-three-centre-gate.json` | 5,737 | `a46470e0ad869275b507e2ff5358bbdaa3c103958d5347e8e72d6eb717a83827` |
