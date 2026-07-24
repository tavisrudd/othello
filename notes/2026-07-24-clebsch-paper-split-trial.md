# Clebsch paper split trial

**Date:** 2026-07-24  
**Lane:** `clebsch`

## Editorial trigger

Repeated reviewer feedback identifies the current post-section-12 manuscript as too broad and
dense.  A comparison against the coherent older 17-page version changes the working diagnosis:
the rigidity/decoder paper already had a complete editorial spine, while the later
factorization-memory and passage/holonomy layers are distinct theorem complexes rather than
supporting detail.

This is a reversible architecture trial.  Preserve the current 37-page manuscript as a fallback
snapshot; do not obtain the pending C320 post-fix review until the split candidates have been
assessed.

## C575 — exact split specification

Identify the exact older and current source snapshots and produce a section-, theorem-, proof-,
figure-, checker-, and citation-level disposition map.

Acceptance:

- pin both source revisions and render both without changing their content;
- classify every current-paper item as Paper I, Paper II, possible Paper III, shared prerequisite,
  or omitted;
- specify the minimal backports to the older base: explicit parity-check matrix, complete
  15-class census, separation of `|U(A)| <= 15` from `|U(A)| = 12`, proof-mode declarations,
  support-bipartition terminology, trust-boundary tables, and at most a compact
  `A_3/B_3/H_3` complement formula;
- map the existing C320 verification/adequacy rows and reproducibility artifacts to the proposed
  papers, with no duplicated or orphaned headline claim;
- give page budgets and a concrete source/build layout for the two candidates;
- end with a go/no-go recommendation for executing C576 and C577.

Non-goal: rewrite either manuscript.

## C576 — focused Paper I candidate

Using the exact older version as the base, build a submission candidate provisionally titled
*Deep-hole rigidity of the Clebsch hexagon code*.

Target spine:

1. code--arc dictionary;
2. Clebsch hexagon and explicit code;
3. syndrome locus, decoding, and automorphisms;
4. rigidity and quantitative gaps;
5. invariant support bipartition and Brianchon reconstruction;
6. uniqueness at `q=11` and the `4 <= k <= 7` classification;
7. verification architecture.

Acceptance:

- retain the older abstract/conclusion hierarchy unless a precise mathematical dependency forces
  a change;
- integrate the C575-approved auditability backports;
- keep exhaustive computation explicitly limited to the numerical gap and low-degree
  strengthening;
- include no factorization-memory machinery beyond an optional short `H_3` explanatory
  subsection;
- render a roughly 19--21 page candidate, update its claim/evidence map, and obtain a fresh
  referee-style assessability review.

Non-goal: obtain the final archive DOI or close C182/C320.

## C577 — factorization-memory Paper II candidate

Build a standalone candidate provisionally titled
*Factorization memory in a conic ideal: the `A_3`, `B_3`, and `H_3` configurations*.

Target spine:

1. conic matching products and the quotient construction;
2. general switch/divisibility theorem;
3. `A_3/B_3/H_3` configurations and ranks `3,6,10`;
4. balanced sheets and cubic-first orientation;
5. six-profile reconstruction;
6. modular depth quotient and arithmetic splitting/gluing;
7. verification architecture.

Acceptance:

- supply a standalone introduction, notation, theorem hierarchy, literature boundary, and
  conclusion rather than relying on Paper I's narrative;
- separate shared prerequisites cleanly and avoid duplicating Paper I proofs;
- remap all adopted claims to exact conceptual, Lean, or certificate evidence;
- inventory passage survival, four-sheet holonomy, theta/Fourier/quantum comparisons, carrier
  torsors, and Mathieu/characteristic-zero bridges as possible Paper III material, but do not
  import them merely to make Paper II comprehensive;
- render and obtain a fresh referee-style coherence review.

Non-goal: allocate or draft Paper III before the standalone-value gate is met.

## Decision gate

After C575, execute C576 and C577 only if the exact dependency map shows that both candidates can
state their headline theorems without circular cross-reference or substantial proof duplication.
After both candidates render, compare them against the preserved 37-page fallback on exposition,
organization, referee assessability, verification burden, and submission readiness.  The final
architecture remains a user decision.
