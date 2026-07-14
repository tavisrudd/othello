# Paper: Equivariant extension and robust completion

**Working title:** *Equivariant extension and robust completion in finite geometry.*

**Object:** one merged paper joining orbit-valued extension of Frobenius-invariant arcs in
`PG(2,s²)` to obstruction-hypergraph completion distance, sharp secant resilience, and robust
completion cores. This is the canonical paper directory; `baer-equivariant-extension` and
`completion-core-rigidity` remain source/staging views.

**Formal status:** the abstract completion spine and the exact coordinate quadratic pair-extension
theorem are kernel-checked. The end-to-end Lean theorem constructs a conjugate pair whose union
with the invariant arc is again an arc, from the displayed empty-line and surplus inequalities.
The exact classical-family completion-radius table remains citation-backed rather than formalized.

**Novelty boundary:** Hilbert 90, the Baer fixed subplane, projective point/line counts, the
occupied-line double count, and two-element involution-orbit counts are classical infrastructure,
not Discovery Track claims. The square-root constant is the classical Lunelli–Sce scale. Candidate
contributions are the exact quadratic orbit-valued criterion and its semantic coordinate coupling.
The abstract completion package is a formally verified synthesis of standard obstruction-
transversal theory; new follow-ups require family-specific collision, inverse, gap, or spectrum
theorems.

**Post-audit correction:** the classical spread example is restricted to line spreads of
`PG(3,q)`. The exact linewise refinement separates invisible centered secant orbits from genuine
charge collisions; its subtraction-free linewise and aggregate forms are Lean-proved. All proposed
order-five conclusion is only partial: `Q25PairResult.f2_pair_extension` kernel-checks the full
exceptional `f=2` existence statement, while the center/moment arguments for `f=0,4` remain
Lean-open. The `f=2` statement explicitly makes both added conjugate points fresh and has passed a
second adversarial proof audit. The external census size and observed minimum 32 remain
computational evidence. No
uniform `s≥5` theorem is claimed before the remaining profiles are kernel-verified.

**Development draft:**
[`paper-baer-equivariant-robust-completion.md`](../../notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md).

**Adversarial review:**
[`baer-completion-adversarial-review.md`](../../notes/2026-07-12-riffing-on-applications/baer-completion-adversarial-review.md).

**Adversarial novelty review:**
[`2026-07-13-baer-completion-adversarial-novelty-review.md`](../../notes/2026-07-13-baer-completion-adversarial-novelty-review.md).

**Lean trust manifest:** [`TRUST.md`](../../lean/FiniteGeom/BaerCompletion/TRUST.md).

**Collision proof ledger:**
[`2026-07-13-c99-baer-collision-strengthening.md`](../../notes/2026-07-13-c99-baer-collision-strengthening.md).

See `../papers-index.md` and `../papers-planning.md` for packaging and release gates.
