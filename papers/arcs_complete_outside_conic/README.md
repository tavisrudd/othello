# Paper: Arcs complete outside a conic: a prescribed-hole defect identity and matching-design rigidity

**Title:** *Arcs complete outside a conic: a prescribed-hole defect identity
and matching-design rigidity.* Author: Tavis Rudd.

**Status:** the most finished unit in `papers/` — a self-contained manuscript with a compiled
PDF, a proof/claim audit, an independent verifier (SHA-256 stamped), and a completed strict-trust
Lean formalization under [`lean/RelativeConicArcs/`](../../lean/RelativeConicArcs/). Related to the
projective-cap program but **separate**: it draws only on classical index equations, not on the
game machinery. The former last finite gap is closed by a kernel-checked projective
augmentation covering list and exact quadratic-rejection certificates:
**rho_C(16) = 9**.

**Object.** For a nonsingular conic 𝒞 ⊂ PG(2,q), study arcs A disjoint from 𝒞 whose secants
cover every point outside A ∪ 𝒞; ρ_𝒞(q) is the minimum size. Contributions:
- an exact **prescribed-hole defect identity** (splits the classical first/second secant-index
  equations over an exceptional set, with an exact — not estimated — remainder);
- coverage / uncovered-locus bounds, an equality criterion, and edge/vertex stability for the
  bad-concurrence graph;
- a canonical Kneser-edge decomposition by secant concurrence, with zero-defect
  maximum-matching rigidity and exact total and per-secant centre counts;
- an exact complete-affine-arc specialization: deleting a line is the line-hole case, with
  `I_L(A)=choose(|A|,2)`, a corrected capacity bound, and the full equality pattern;
- the explicit lower bound **ρ_𝒞(q) ≥ √(2q) + 3/2 − 8/√(2q)**;
- arbitrary-hole capacity and projective-averaging transfer theorems, specializing to
  ρ_𝒞(q) ≤ t₂(2,q) when t₂(2,q) ≤ q (and the Kim–Vu corollary);
- even-characteristic nucleus constraints;
- a general uncovered-evaluation obstruction for exceptional loci drawn from a finite-dimensional
  linear system of homogeneous forms, strengthened to an exact at-most-`q` finite-field
  evaluation-avoidance dichotomy for arbitrary feature maps (hence every Veronese degree);
- verified small values: ρ_𝒞(5) = 4, ρ_𝒞(8) = ρ_𝒞(9) = ρ_𝒞(11) = 6, and
  ρ_𝒞(16) = 9;
- the stronger q=16 classification theorem: no nonzero quadratic zero set, singular or
  nonsingular, contains an eight-arc's ordinary-uncovered locus while avoiding the arc.

The Lean package proves the elementary theorem chain, exact uncovered-locus reconstruction,
matching rigidity and secant-deletion stability, the conic/projective transport statements, and a
semantic bridge from a generic rules-only coordinate checker to relative completeness. Its finite
checks use kernel `decide`, never `native_decide`; the theorem and axiom manifest is
[`lean/RelativeConicArcs/TRUST.md`](../../lean/RelativeConicArcs/TRUST.md), and the manuscript's
exact import and axiom boundary is
[`Gates/ArcsCompleteOutsideConic.lean`](../../lean/RelativeConicArcs/Gates/ArcsCompleteOutsideConic.lean).

**Exact q=5 value (C188).** Clebsch C187's hardened checker verifies that the ordinary-uncovered
locus of the standard four-frame in `PG(2,5)` is exactly the six points of the nonsingular conic
`X²+Y²+Z²+XY+XZ+YZ=0`. C188 transports that frame to the standard conic, kernel-checks the
relative-completeness certificate, and combines it with `L₂(5)=4` to prove
`ρ_𝒞(5)=L₂(5)=4`. The broader `4≤k≤7` conic-filling classification remains owned by
[`C187`](../../notes/2026-07-15-c187-general-k-arc-conic-filling.md) and is cited rather than
duplicated here.

**Exact q=16 classification.** Every projective eight-arc is normalized to the standard
four-frame and extended through checked exhaustive covering lists of lengths 4, 61, 454, and
2633. The final list length matches the projective-class count of Al-Seraji--Al-Ogali (2018), so
that count is prior art. Every
transition carries an explicit invertible 3-by-3 matrix and pointwise scalar witnesses. For 2630
listed leaves, the ordinary-uncovered locus contains three collinear points
and three noncollinear points off their line, so the line-component argument
excludes every nonzero containing quadratic. A compact exact checker records
these incidence witnesses. In the remaining three leaves, the unique
quadratic kernel meets the arc explicitly. Lean independently checks
invertible six-row evaluation matrices on the 2630 generic leaves, the three
exceptional kernels and hits, and the field-uniform normalized line--triangle
mechanism. It also proves the normalization, classification, and
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

**Companion material.** The coding, coset-spectrum, and Clebsch-hexagon consequences of the q=11 witness now belong to the separate Clebsch manuscript; this paper retains only the geometric witness and exact relative value.

The manuscript body is limited to the defect mechanism, equality consequences,
and conic lower bound.  Secondary realization results, the finite \(q=16\)
classification, reconstruction, witnesses, and the formal/computational trust
contracts are appendices.  Raw generated proof objects, generators, hashes, and
replay scripts live here in the electronic companion.

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
- `check_q16_uncovered_patterns.py` / `.json` / `.sha256` — compact line--triangle witnesses for
  the 2630 generic q=16 leaves and direct arithmetic for the three exceptional kernels
- `analyze_c201_q16.py` — independent frozen-list quadratic-rank, defect, stabilizer, and orbit anatomy
- `size_c201_q64.py` — corrected-bound arithmetic and rigorous frame-normalized `q=64` census rejection
- `probe_c201_q64_baer.py` / `check_c201_q64_baer.cpp` — orbit-reduced and raw independent
  checks of the Frobenius-stable Baer-conic thirteen-arc family
- `probe_c201_q64_torus.py` — exhaustive order-13 nonsplit-torus orbit probe relative to the
  standard `q=64` conic
- `size_c201_q64_z3.py` — sizing rejection for nucleus-plus-four-orbit sets under the natural
  split `Z3` conic stabilizer
- `../../lean/RelativeConicArcs/` — standalone Lean formalization and kernel-checked certificates

## Related but separate

- The √(2q) scale coincides with `baer-equivariant-extension`'s Cor 3.4 (both are the classical
  Lunelli–Sce √(2q) complete-arc bound). Coordinate the novelty framing across the two so they
  don't appear to double-claim the same constant — see `../papers-planning.md`.
- The game-side conic-localization / off-conic "intruder calculus" (an open odd-plane research
  line, proved only q=5,7) motivated this geometry but is a **different, unfinished** candidate;
  it lives in the research track, not here.

No `../notes/` symlinks — this manuscript is self-contained.
