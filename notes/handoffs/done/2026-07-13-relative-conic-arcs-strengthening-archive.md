# Relative-conic arcs strengthening — companion archive

Append-only companion to
[`../2026-07-13-relative-conic-arcs-strengthening.md`](../2026-07-13-relative-conic-arcs-strengthening.md).
The live handoff holds the current goal, theorem targets, gates, task statuses, and next action.
Session notes, raw validation output, source-search trails, changed conclusions, and closed-negative
routes belong here.

## 2026-07-13 — lane created and C106–C110 allocated

The completed C89–C96 lane exposed a second, downstream strengthening program rather than a gap in
the original formalization. The new lane separates three mathematical layers:

- an exact evaluation-avoidance theorem based on the fact that fewer than `q` proper hyperplanes do
  not cover a finite vector space over `F_q`;
- the standard but useful projective dictionary between plane arcs, codimension-three MDS codes,
  syndrome distance, deep holes, and one-column extensions; and
- a configuration-specific `q=11` package whose preliminary computations indicate an icosahedral
  `A5` action and unusually exact code/extension invariants.

The q11 evidence recorded before allocation is provisional until C106 reproduces it independently:

- conic-projectivity stabilizer size 60 with element-order distribution
  `1^1 2^15 3^20 5^24`;
- point-orbit sizes `6,12,10,15,30,30,30`;
- off-arc secant-index counts `(N1,N2,N3)=(90,15,10)`;
- six perfect matchings partitioning the 30 icosahedron edges;
- quadratic evaluation rank six, excluding containment in a conic;
- projective deep-hole syndrome set equal to the standard 12-point conic;
- affine syndrome/coset distances `(1,60,1150,120)`; and
- distance-two leader multiplicities `(900,150,100)`.

These observations motivated the task split but are not yet paper claims or Lean theorems. C106 is
explicitly authorized to refute or narrow them before proof engineering.

Initial literature seeds for the structured audit are Kaipa on projective syndromes/deep holes and
MDS extensions; Zhang–Wan–Kaipa on deep holes; recent non-GRS MDS construction work; finite-geometry
classifications of conic exterior sets and small arcs; the `A5 < PSL(2,11)`/Witt-design literature;
and finite-vector-space hyperplane covering theorems. The audit must search the exact conjunction,
not infer novelty from failure of one phrase search.

The final discovery review is a required C110 deliverable. It must separately classify proved
corollaries, cheap generalizations, surprising equivalences, applications to the projective-cap
program, and speculative directions; none may be silently promoted to novelty.
