# Paper: Arcs complete outside a prescribed conic

**Title:** *Arcs complete outside a prescribed conic — an exact defect identity and the case of
GF(16).* Author: Tavis Rudd.

**Status:** the most finished unit in `papers/` — a self-contained manuscript with a compiled
PDF, a proof/claim audit, an independent verifier (SHA-256 stamped), and a completed strict-trust
Lean formalization under [`lean/RelativeConicArcs/`](../../lean/RelativeConicArcs/). Related to the
projective-cap program but **separate**: it draws only on classical index equations, not on the
game machinery. The former last finite gap is closed by a kernel-checked projective
classification: **rho_C(16) = 9**.

**Object.** For a nonsingular conic 𝒞 ⊂ PG(2,q), study arcs A disjoint from 𝒞 whose secants
cover every point outside A ∪ 𝒞; ρ_𝒞(q) is the minimum size. Contributions:
- an exact **prescribed-hole defect identity** (splits the classical first/second secant-index
  equations over an exceptional set, with an exact — not estimated — remainder);
- coverage / uncovered-locus bounds, an equality criterion, and a quantitative stability bound;
- the explicit lower bound **ρ_𝒞(q) ≥ √(2q) + 3/2 − 8/√(2q)**;
- arbitrary-hole capacity and projective-averaging transfer theorems, specializing to
  ρ_𝒞(q) ≤ t₂(2,q) when t₂(2,q) ≤ q (and the Kim–Vu corollary);
- even-characteristic nucleus constraints;
- a general uncovered-evaluation obstruction for exceptional loci drawn from a finite-dimensional
  linear system of homogeneous forms, strengthened to an exact at-most-`q` finite-field
  evaluation-avoidance dichotomy for arbitrary feature maps (hence every Veronese degree);
- a coding restatement in which plane arcs are codimension-three MDS parity-check systems,
  secant index is the exact weight-two leader count, and the prescribed-hole defect is an exact
  leader-collision identity;
- verified small values: ρ_𝒞(8) = ρ_𝒞(9) = ρ_𝒞(11) = 6 and ρ_𝒞(16) = 9;
- for the `q=11` witness, a non-GRS `[6,3,4]₁₁` MDS code of covering radius three with
  exact conic deep-hole locus, coset distribution, chord decomposition, and icosahedral extension
  polynomial `1+12t+36t²+20t³`;
- the stronger q=16 classification theorem: no nonzero quadratic zero set, singular or
  nonsingular, contains an eight-arc's ordinary-uncovered locus while avoiding the arc.

The Lean package proves the elementary theorem chain, the conic/projective transport statements,
and a semantic bridge from a generic rules-only coordinate checker to relative completeness. Its
finite checks use kernel `decide`, never `native_decide`; the theorem and axiom manifest is
[`lean/RelativeConicArcs/TRUST.md`](../../lean/RelativeConicArcs/TRUST.md).

**Queued q=5 follow-up (C188).** Clebsch C187's hardened checker verifies by exhaustive exact
computation that the ordinary-uncovered locus of the standard four-frame in `PG(2,5)` is exactly
the six points of the nonsingular conic
`X²+Y²+Z²+XY+XZ+YZ=0`. Together with this paper's `L₂(5)=4` lower bound, that yields the target
`ρ_𝒞(5)=L₂(5)=4`. C188 will import the witness into the relative-conic semantics, add the theorem to
the strict-kernel result registry, and then promote it into the verified small-value table. The
broader `4≤k≤7` conic-filling classification remains owned by
[`C187`](../../notes/2026-07-15-c187-general-k-arc-conic-filling.md) and will be cited rather than
duplicated here.

**Exact q=16 classification.** Every projective eight-arc is normalized to the standard
four-frame and extended through checked exhaustive covering lists of lengths 4, 61, 454, and
2633. The final list length matches the projective-class count of Al-Seraji--Al-Ogali (2018), so
that count is prior art. Every
transition carries an explicit invertible 3-by-3 matrix and pointwise scalar witnesses. For 2630
listed leaves, six ordinarily uncovered points impose six independent quadratic conditions,
so no nonzero conic equation can contain the uncovered locus. In the remaining three leaves,
a checked span relation forces the quadratic equation to vanish at a selected arc point, contradicting
disjointness. Lean checks all local arithmetic and proves the normalization, classification, and
conic-transport semantics. In particular, each `StepBook.coverage` theorem proves that every legal
extension of its parent occurs among certified entries, `StepBooksValid` proves that the books
cover the current parent list exactly, `classifiedAt_level8_of_frame` composes the four layers,
and frame reduction transports an arbitrary eight-arc to a listed leaf. Thus exhaustiveness as a
covering list is kernel-checked; pairwise inequivalence and exact quotient-class counts are
external provenance, and the C++ enumerator is not a trusted oracle.
From this directory, reproduce the report and emitted Lean data with
`g++ -O3 -std=c++20 search_rhoc16.cpp -o /var/tmp/search_rhoc16` followed by
`/var/tmp/search_rhoc16 --emit-lean`; `/tmp` is tmpfs on the development host. The checked-in
report is the combined standard output/error
stream from that run.

**Small-order structural note.** The `q=11` witness has `I_C=0`, so all 15 of its secants are
exterior to the conic. Its associated code is a projectively non-GRS `[6,3,4]₁₁` MDS code
of covering radius three; the twelve conic directions are exactly its projective deep holes. The
affine coset-distance distribution is `(1,60,1150,120)`, and
`affine_distanceThree_iff_mem_standardConic` identifies actual distance-three affine syndrome
rays with the standard conic. The distance-two cosets have one,
two, or three actual minimum-weight coefficient words in counts `(900,150,100)`. Lean proves the
133-by-10 ray normalization is a bijection onto all nonzero affine syndromes, characterizes the
counted sets by actual parity-check distance, and identifies determinant-zero pairs with actual
word supports before counting. Simultaneous conic-column extensions form the
icosahedron independence complex, with polynomial `1+12t+36t²+20t³`, six maximal
two-extensions, and twenty maximal three-extensions; a named theorem upgrades every such maximal
set to an ordinary complete arc. The six near-perfect chord classes augment by six distinct
antipodal edges to a certified one-factorization. This six-set is a classical Clebsch hexagon and
its all-secants-exterior property overlaps the classical exterior-set setting of
Blokhuis--Seress--Wilbrink (1992). In modern uncovered-locus notation BSW and Dye supply
`C(F_11) subset U(A)`; Dye's ten-concurrence theorem plus the chord-defect count gives the
reverse inclusion by cardinality. Thus the equality is an apparently unrecorded short synthesis,
not a newly discovered classical configuration;
the exact code/extension conjunction is presented as a checked synthesis, not a novelty claim.
The two notions are now separated explicitly in the manuscript:
complete exteriority gives `C(F_q) subset U(A)`, whereas completeness outside the prescribed
conic is `U(A) subset C(F_q)`. BSW's `q=7` exterior four-arc is a strict foil, since the universal
four-arc count gives `|U(A)|=(q-2)(q-3)=20>8=|C(F_7)|`.

**Novelty posture (self-stated):** the ordinary `PG(2,16)` count of 2633 eight-arc classes is
known. The general evaluation lemma is elementary linear algebra, and quadrics containing arcs
are classical. So are the secant-index moments, the Lunelli–Sce scale, the arc↔MDS/GRS dictionary,
saturating-set theory, and complete exterior sets of conics. A targeted search did not locate the relative-completeness parameter or exact
defect identity in this form, the use of the ordinary-uncovered locus as a quadratic obstruction,
the exceptional `2630+3` rank profile, or the exact value `rho_C(16)=9`. These are bounded search
findings, not priority certificates; the paper makes no unconditional novelty claim.
The source-by-source comparison is recorded in
[`notes/2026-07-13-rhoc16-novelty-check.md`](../../notes/2026-07-13-rhoc16-novelty-check.md).

## Files here

- `arcs_complete_outside_conic.tex` / `.pdf` — the manuscript
- `arcs_complete_outside_conic_proof_audit.md` — proof/claim audit
- `verify_relative_conic_arcs.py` / `verify_relative_conic_arcs_output.txt` — the verifier + run
- `check_evaluation_dichotomy.py` — small-field sharp-threshold adversarial checker
- `check_q11_structure.py` / `.cpp` — independent q11 structure, invariance, and mutation checks
- `search_rhoc16.cpp` / `search_rhoc16_output.txt` — exact eight-arc classification generator + run
- `../../lean/RelativeConicArcs/` — standalone Lean formalization and kernel-checked certificates

## Related but separate

- The √(2q) scale coincides with `baer-equivariant-extension`'s Cor 3.4 (both are the classical
  Lunelli–Sce √(2q) complete-arc bound). Coordinate the novelty framing across the two so they
  don't appear to double-claim the same constant — see `../papers-planning.md`.
- The game-side conic-localization / off-conic "intruder calculus" (an open odd-plane research
  line, proved only q=5,7) motivated this geometry but is a **different, unfinished** candidate;
  it lives in the research track, not here.

No `../notes/` symlinks — this manuscript is self-contained.
