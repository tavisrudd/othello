# Clebsch paper split trial

**Date:** 2026-07-24  
**Lane:** `clebsch`

## Active status

This document is the architecture charter, not the live task router.
`notes/handoffs/2026-07-13-clebsch-paper.md` is the single routing authority.
The three-paper program is the active publication path. The 37-page
`papers/clebsch-hexagon-code/` manuscript and its evidence surface remain
preserved unchanged as a fallback.

C575 and C576 are complete. Paper I is the warning-free 19-page candidate in
`papers/clebsch-rigidity/`; C320 has final `GO` after two repair rounds and
a fresh context-free PDF review. C182 is the current Paper I task.
C577 remains gated behind Paper I submission readiness, and C579 remains
gated behind Paper II.

## Editorial trigger

Repeated reviewer feedback identifies the current post-section-12 manuscript as too broad and
dense.  A comparison against the coherent older 17-page version changes the working diagnosis:
the rigidity/decoder paper already had a complete editorial spine, while the later
factorization-memory and passage/holonomy layers are distinct theorem complexes rather than
supporting detail.

The split assessment was completed by C575 and C576. Preserve the current
37-page manuscript as a fallback snapshot; the live handoff now governs the
C320 post-fix review and later-paper gates.

The source layout is additive:

- `papers/clebsch-hexagon-code/` remains the unchanged broad fallback;
- `papers/clebsch-rigidity/` is the C576 Paper I root;
- `papers/clebsch-factorization/` is the C577 Paper II root;
- `papers/clebsch-passages/` is the exploratory C579 Paper III root.

Do not rename, move, or repurpose the fallback.  C575 must populate the new roots from pinned
source revisions and recorded dispositions rather than treating a working-tree copy as
provenance.

## C575 — exact split specification

Identify the exact older and current source snapshots and produce a section-, theorem-, proof-,
figure-, checker-, and citation-level disposition map.

**Result:** complete with `GO` for C576.  The exact focused base is commit
`7d258dcd6cda9f54c330d4b705d553a975749014` (17 pages), and the frozen broad fallback is
`5a82e80d72e5c7400afb07ea4f33d929fbc11259` (37 pages).  The complete disposition, source
population recipe, page budgets, and mystery ledger are in
`notes/2026-07-24-c575-clebsch-split-disposition.md`; the exact 58-row trust partition is
`notes/2026-07-24-c575-clebsch-trust-disposition.csv`.

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

**Result:** complete with a fresh referee-style `GO` to C320. The candidate
has 19 pages, 17 theorem-like environments, the exact nineteen-row Paper I
claim map, no optional `H_3` paragraph, and no Paper II/III dependency. See
`notes/2026-07-24-c576-clebsch-rigidity-candidate.md`.

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

Non-goal: import the passage/holonomy comparison package merely to make Paper II comprehensive.

## C579 — passages and holonomy Paper III gate

Test the provisional title *Finite passages and holonomy in Clebsch matching geometry* against a
single-question standard.

Candidate spine:

1. carriers, orientations, and passage maps;
2. exact survival and loss statements;
3. the four-sheet cover and cycle holonomy;
4. theta, Fourier, and quantum realizations;
5. Mathieu and characteristic-zero bridges;
6. verification architecture.

Acceptance:

- identify one principal theorem that makes the other comparisons consequences or applications;
- state the common carrier and determinant-sign transport before the individual realizations;
- separate proved finite or monomial statements from broader equivalences that remain external;
- establish an independent literature and notation boundary;
- render a candidate and obtain a fresh referee-style standalone-value review.

If the first acceptance item fails, stop drafting and return the material to a disposition
inventory.  Do not lengthen Paper II to absorb it automatically.

## Decision gate

Paper I has priority.  The execution order is:

1. C575 and C576 are complete.
2. C320 remaps and closes the Paper I trust/review surface, with C321 interposed only if triggered.
3. C182 archives and releases Paper I.
4. C577 begins Paper II only after Paper I is submission-ready.
5. C579 tests Paper III only after Paper II.

If C182 is waiting only on a user-controlled DOI, licence, or repository-release input after every
local gate has passed, that external wait does not force the lane to remain idle.  Otherwise no
Paper II or Paper III drafting displaces unfinished Paper I work.

Each later candidate must state its headline theorem without circular cross-reference or
substantial proof duplication.  Compare every rendered candidate against the preserved 37-page
fallback on exposition, organization, referee assessability, verification burden, and submission
readiness.  The final architecture remains a user decision.
