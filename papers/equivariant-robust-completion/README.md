# Paper: Frobenius-equivariant pair extension of eight-arcs

**Working title:** *Frobenius-equivariant pair extension of eight-arcs in `PG(2,25)`.*

**Object:** the focused paper on the quantitative quadratic-Frobenius pair-extension criterion, its
exact collision correction, and the uniform `PG(2,25)` eight-arc theorem. This is the canonical
paper directory; `baer-equivariant-extension` remains a source/staging view. The generic
`completion-core-rigidity` package is reusable library material but is not part of this submission.

**Formal status:** the quadratic pair-extension existence theorem, uniform `PG(2,25)` theorem,
collision equality/excess classification, and semantic global pair count are kernel-checked. The
end-to-end Lean theorem constructs a conjugate pair whose union with the invariant arc is again an
arc. `QuadraticGlobalCount.lean` defines the semantic global finset of fresh legal Frobenius pairs
and kernel-checks its equality with the disjoint carrier union and `PairExtensionData.legalCount`.
The five parity-allowed Q25 profiles are exhausted in Lean.

**Publication status:** focused LaTeX submission source, bibliography, and PDF complete; bounded
general-criterion priority search complete. The checked Q25 result has no proof-validity defect in
the scoped audit. Citation, label, trust-boundary, manuscript-to-Lean, TeX, BibTeX, reference, and
box-warning checks pass. The manuscript promotes the consequence for every prime-power base order
`s≥5` to a numbered corollary, displays the five Q25 profiles and their proved lower bounds in one
audit table, and records the exact Lean/mathlib pins, formal-source checkpoint, and build commands.

**Novelty boundary:** Hilbert 90, the Baer fixed subplane, projective point/line counts, the
occupied-line double count, and two-element involution-orbit counts are classical infrastructure,
not Discovery Track claims. The square-root constant is the classical Lunelli–Sce scale. Candidate
contributions are the exact quadratic orbit-valued criterion and its semantic coordinate coupling.
The generic completion/transversal library is not a contribution of this focused paper.
No exact precursor for the general quantitative criterion was located in the bounded C139
specialist-vocabulary/database search; this supports no historical-first claim.

**Checked strengthening:** the exact linewise refinement separates invisible centered secant orbits from genuine
charge collisions; its subtraction-free linewise and aggregate forms are Lean-proved.
The profile-independent cross-pair estimate `s+3-f-e` is also kernel-checked in
`QuadraticInvisible.lean`; the theorem derives the necessary `e≥2` from the cross-pair witness.
`Q25PairResult.f2_pair_extension` kernel-checks the full exceptional `f=2` existence statement,
and the certificate-free `Q25ProfileFour.profile_four_pair_extension` kernel-checks `f=4`. The
`f=2` statement explicitly
makes both added conjugate points fresh and has passed a second adversarial proof audit. The
external census size and observed minimum 32 remain computational evidence. The uniform `s≥5`
claim does not depend on them: `Q25ProfileZero.profile_zero_pair_extension` kernel-checks `f=0`, and
`Q25AllProfiles.pair_extension` proves the uniform order-five extension theorem; the generic
criterion covers every `s≥7`, and there is no intervening prime-power base order.
The C135 declarations classify equality by universal visibility and collision-free charge, and
classify every first-order excess level by invisible mass plus collision redundancy. In the
quadratic instance, invisible mass is center/empty-carrier incidence. This is an algebraic inverse
theorem, not a structural classification of near-saturated arcs.

**Submission manuscript:**
[`frobenius_pair_extension.tex`](frobenius_pair_extension.tex), with
[`refs.bib`](refs.bib), and compiled
[`frobenius_pair_extension.pdf`](frobenius_pair_extension.pdf).

**Development source:**
[`paper-baer-equivariant-robust-completion.md`](../../notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md).

**Adversarial review:**
[`baer-completion-adversarial-review.md`](../../notes/2026-07-12-riffing-on-applications/baer-completion-adversarial-review.md).

**Adversarial novelty review:**
[`2026-07-13-baer-completion-adversarial-novelty-review.md`](../../notes/2026-07-13-baer-completion-adversarial-novelty-review.md).

**Lean trust manifest:** [`TRUST.md`](../../lean/FiniteGeom/BaerCompletion/TRUST.md).

**Collision proof ledger:**
[`2026-07-13-c99-baer-collision-strengthening.md`](../../notes/2026-07-13-c99-baer-collision-strengthening.md).

See `../papers-index.md` and `../papers-planning.md` for packaging and release gates.
