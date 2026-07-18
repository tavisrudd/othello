# C294 recursive defective-mirror obstruction: an asymmetric state is necessary

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** the first hard `PGL2(5)` gate rules out every right-regular recursive mirror that
restores an involution after each defect response; the next state must retain an asymmetric
boundary phase. The seven `q=5` root values remain unevaluated.

## Result

Let `G` be a graph with a fixed-point-free involutory automorphism `tau`. Call a mirror pair
`{v,tau(v)}` a **defect pair** when it is an edge. The natural one-exchange recursive mirror
language plays as follows:

1. away from the defect, answer `v` by `tau(v)` and restrict `tau` to the remaining induced graph;
2. at a defect move `v`, choose a legal response `w` such that the remaining graph admits some
   fixed-point-free involutory automorphism `tau'`, with arbitrary edge-colour action and preferably
   fewer defect pairs; then recurse.

Any complete strategy in this language proves a P-position by induction on the remaining vertex
count. The new exact obstruction is that this language is already too small on the first of the
seven mandatory `PGL2(5)` gates.

Take the mixed full triple with determinant classes `001`, pair-product orders `(2,4,5)`, and
canonical representative

```text
((0,1,0), (0,1,1), (1,0,2)).
```

For **each** of the two involution conjugacy classes in `PGL2(5)`, start with right multiplication
by a representative involution. There is a legal sequence of nondefect first moves and forced
mirror responses leading to a state with a defect move for which **no legal response leaves any
fixed-point-free involutory automorphism at all**:

| root mirror class | initial defect pairs | mirror rounds | terminal vertices | terminal defect pairs | legal responses excluded |
|:--|--:|--:|--:|--:|--:|
| represented once in `S` | 6 | 3 | 100 | 6 | 96 |
| represented twice in `S` | 8 | 10 | 58 | 5 | 55 |

This is stronger than the earlier colour-preserving rigidity theorem. The replacement automorphism
was allowed to be an arbitrary abstract automorphism of the response residual, so it could change
colours or patch different cut components independently. Every candidate residual is nevertheless
parity-obstructed by an intrinsic stable partition.

Consequently a recursive scar theorem cannot require symmetry restoration immediately after every
defect exchange. It must carry a genuinely asymmetric boundary state for at least the next
opponent move, or use a value-preserving quotient that does not encode its P-states by
fixed-point-free involutions. This identifies the smallest missing state shape; it does **not**
construct the needed asymmetric transition or determine the `(2,4,5)` root outcome.

## Why the obstruction is exact

The regular left Cayley graph uses edges `h -- s*h`. Every colour-preserving root automorphism is a
right translation, and an involutory one is `rho_z(h)=h*z`. `PGL2(5)` has exactly two involution
classes. The checker enumerates them as class sizes `10` and `15`, with centralizers of orders `12`
and `8`; the generator triple meets them in multiplicities one and two. Conjugating `z` corresponds
to conjugating `rho_z` by another right translation, so one canonical path for each class exhausts
all right-regular root mirrors.

At each path step, the checker verifies that the current pairing is an involutory graph
automorphism, the displayed first move is nonadjacent to its mate, and deletion of the two closed
neighbourhoods leaves the restricted pairing. The next state is canonically relabelled by the
minimum of its `120` right translates. The JSON records the move, forced response, defect count,
vertex count, and SHA-256 of every canonical state.

At the terminal defect move, the checker exhausts every legal response. It refines the response
residual by exact one-dimensional Weisfeiler--Leman colour refinement. Every graph automorphism
preserves each stable cell. A fixed-point-free involution would partition every cell into
two-cycles, so every stable cell would have even size. Instead every one of the `96+55=151`
residuals has at least one odd stable cell.

The two cases have the following checked ranges:

- in the six-pair case the residuals have `92--94` vertices, `86--92` stable cells, `80--90` odd
  cells, and largest cell size two;
- in the eight-pair case they have `51--53` vertices, `36--53` stable cells, `21--53` odd cells,
  and largest cell size at most four.

Degree parity alone excludes `42/96` and `50/55` responses. For the remainder, stable refinement
is load-bearing. An independently implemented cell-splitting refinement agrees exactly with the
existing stable-colour kernel on all 151 residuals.

## Mandatory direct base

The same checker includes the `(2,3,4)` `PGL2(3)` gate required by the live handoff. Its regular
Cayley graph has 24 vertices and exact Grundy value zero. After a first move at the identity, all
20 legal replies leave P-positions. The Grundy recursion is independently cross-checked by a
Boolean P/N recursion on the root and every one of those 20 grandchildren.

This gives a direct finite base, not a uniform mechanism. In particular, the root has no clean
abstract pairing, and the `PGL2(5)` obstruction above shows why simply placing the base below a
strict defect-descent recursion cannot close silver.

## Revised silver frontier

The alternating two-colour backbones remain the correct coordinates, but the recursive state must
now remember an asymmetric cut boundary rather than just an involution and its adjacent pairs. A
minimal next attack is:

1. encode the open boundary created by a defect move and response on the paired dihedral
   backbones;
2. allow one opponent move in that asymmetric state;
3. prove a response that either closes the boundary, splits off a direct base, or transfers to a
   strictly smaller boundary word; and
4. test that transition first on the certified `(2,4,5)` obstruction state, then on the other six
   obstructed `PGL2(5)` types.

A larger automorphism search, another right mirror, or an immediate abstract-pairing restoration
cannot solve the certified state. The current computation says nothing about whether a bounded
asymmetric depth suffices uniformly, and it does not classify any `q=5` root as P or N.

## Evidence and replay

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-17-c294-recursive-defective-mirror.py \
  --check notes/2026-07-17-c294-recursive-defective-mirror.json
sha256sum -c notes/2026-07-17-c294-recursive-defective-mirror.sha256
```

The checker uses only Python's standard library and the adjacent, pinned C294 mixed-scar group and
graph constructor. It performs deterministic exhaustive enumeration and uses no random seed. The
trusted boundary is prime-field projective arithmetic, exhaustive `PGL2(q)` generation and
conjugation, direct finite-game recursion at `q=3`, canonical right-translation relabelling, and
the stable-partition parity lemma. It does not evaluate the 120-vertex `q=5` game roots and does not
extrapolate the obstruction beyond the displayed `(2,4,5)` type.

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|:---|
| `notes/2026-07-17-c294-recursive-defective-mirror.py` | 13,198 | `2a4f7eb8e514b154a7be3fbcb18da6b6e182d7142d531266e7c62a477e8096e7` |
| `notes/2026-07-17-c294-recursive-defective-mirror.json` | 10,326 | `f0c949e5a783b9da2cf1cb32fa01e7908a2d12a271d6d1baa2920f05074e2580` |
| `notes/2026-07-17-c294-mixed-scar-obstruction.py` | 15,652 | `d3e2743a1fe7a987ffab8e924f63affc7d8e952a77abfa8ec49ce14201adb113` |
