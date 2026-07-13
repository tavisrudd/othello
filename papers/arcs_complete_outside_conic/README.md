# Paper: Arcs complete outside a prescribed conic

**Title:** *Arcs complete outside a prescribed conic — a secant-defect identity, lower bounds,
and verified examples.* Author: Tavis Rudd.

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
- the asymptotic lower bound **ρ_𝒞(q) ≥ √(2q) + 3/2 − O(q^{−1/2})**;
- a projective-averaging upper-bound transfer (ρ_𝒞(q) ≤ t₂(2,q) when t₂(2,q) ≤ q; Kim–Vu
  corollary);
- even-characteristic nucleus constraints;
- a general uncovered-evaluation obstruction for exceptional loci drawn from a finite-dimensional
  linear system of homogeneous forms;
- verified small values: ρ_𝒞(8) = ρ_𝒞(9) = ρ_𝒞(11) = 6 and ρ_𝒞(16) = 9.

The Lean package proves the elementary theorem chain, the conic/projective transport statements,
and a semantic bridge from a generic rules-only coordinate checker to relative completeness. Its
finite checks use kernel `decide`, never `native_decide`; the theorem and axiom manifest is
[`lean/RelativeConicArcs/TRUST.md`](../../lean/RelativeConicArcs/TRUST.md).

**Exact q=16 classification.** Every projective eight-arc is normalized to the standard
four-frame and extended through checked class lists of sizes 4, 61, 454, and 2633. The final
count independently reproduces Al-Seraji--Al-Ogali (2018), so that count is prior art. Every
transition carries an explicit invertible 3-by-3 matrix and pointwise scalar witnesses. For 2630
eight-arc classes, six ordinarily uncovered points impose six independent quadratic conditions,
so no nonzero conic equation can contain the uncovered locus. In the remaining three rank-five
classes, the forced quadratic equation also vanishes at a selected arc point, contradicting
disjointness. Lean checks all local arithmetic and proves the normalization, classification, and
conic-transport semantics; the C++ enumerator is reproducible provenance, not a trusted oracle.
From this directory, reproduce the report and emitted Lean data with
`g++ -O3 -std=c++20 search_rhoc16.cpp -o /tmp/search_rhoc16` followed by
`/tmp/search_rhoc16 --emit-lean`; the checked-in report is the combined standard output/error
stream from that run.

**Small-order structural note.** The `q=11` witness has `I_C=0`, so all 15 of its secants are
exterior to the conic. The moment equations force its 115 required points to have index distribution
`(N₁,N₂,N₃)=(90,15,10)`. In the auxiliary cap-game reading, all twelve conic points are
initially live and their conflict graph is the icosahedral graph; its antipodal involution proves
the residual position P. Lean checks every seeded continuation, applies the exact parametrized-hole
game bridge, and proves the actual six-point projective position P. At `q=9`, a strengthened
ordinary-coverage check proves that the displayed six-arc has no legal projective extension and is
therefore terminal P. These are consequences of the certified coordinates, not novelty claims,
and the game statements are not used in the paper's bounds.

**Novelty posture (self-stated):** the ordinary `PG(2,16)` count of 2633 eight-arc classes is
known. The general evaluation lemma is elementary linear algebra, and quadrics containing arcs
are classical. A targeted search did not locate the relative-completeness parameter or exact
defect identity in this form, the use of the ordinary-uncovered locus as a quadratic obstruction,
the exceptional `2630+3` rank profile, or the exact value `rho_C(16)=9`. These are bounded search
findings, not priority certificates; the paper makes no unconditional novelty claim.
The source-by-source comparison is recorded in
[`notes/2026-07-13-rhoc16-novelty-check.md`](../../notes/2026-07-13-rhoc16-novelty-check.md).

## Files here

- `arcs_complete_outside_conic.tex` / `.pdf` — the manuscript
- `arcs_complete_outside_conic_proof_audit.md` — proof/claim audit
- `verify_relative_conic_arcs.py` / `verify_relative_conic_arcs_output.txt` — the verifier + run
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
