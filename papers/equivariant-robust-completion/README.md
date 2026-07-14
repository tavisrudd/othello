# Paper: Equivariant extension and robust completion

**Working title:** *Equivariant extension and robust completion in finite geometry.*

**Object:** a development draft centered on orbit-valued extension of Frobenius-invariant arcs in
`PG(2,s²)`, currently accompanied by obstruction-hypergraph completion distance, secant resilience,
and robust completion cores. This is the canonical paper directory;
`baer-equivariant-extension` and `completion-core-rigidity` remain source/staging views. Final scope
is unresolved: either focus the submission on the Baer/Q25 theorem or add a genuine family-specific
robust-completion bridge before retaining the merged package.

**Formal status:** the abstract completion spine, quadratic pair-extension existence theorem,
uniform `PG(2,25)` theorem, and collision equality/excess classification are kernel-checked. The
end-to-end Lean theorem constructs a conjugate pair whose union with the invariant arc is again an
arc. The quantitative Lean count is a linewise carrier sum; its identification with the cardinality
of a separately defined global legal-pair set remains a prose mate-line argument. The classical-
family completion-radius table remains provisional pending primary citations and exact hypotheses.

**Publication status:** major revision. The checked Q25 result has no proof-validity defect in the
scoped audit, but scope, classical-family citations, specialist priority search for the general
criterion, sharpness/positioning, and submission packaging remain open release gates.

**Novelty boundary:** Hilbert 90, the Baer fixed subplane, projective point/line counts, the
occupied-line double count, and two-element involution-orbit counts are classical infrastructure,
not Discovery Track claims. The square-root constant is the classical Lunelli–Sce scale. Candidate
contributions are the exact quadratic orbit-valued criterion and its semantic coordinate coupling.
The abstract completion package is a formally verified synthesis of standard obstruction-
transversal theory; new follow-ups require family-specific collision, inverse, gap, or spectrum
theorems.

**Post-audit correction:** the classical spread example is restricted to line spreads of
`PG(3,q)`. The exact linewise refinement separates invisible centered secant orbits from genuine
charge collisions; its subtraction-free linewise and aggregate forms are Lean-proved.
The profile-independent cross-pair estimate `s+3-f-e` is also kernel-checked in
`QuadraticInvisible.lean`; the theorem derives the necessary `e≥2` from the cross-pair witness.
`Q25PairResult.f2_pair_extension` kernel-checks the full exceptional `f=2` existence statement,
and the certificate-free `Q25ProfileFour.profile_four_pair_extension` kernel-checks `f=4`. The
`f=2` statement explicitly
makes both added conjugate points fresh and has passed a second adversarial proof audit. The
external census size and observed minimum 32 remain computational evidence. The uniform `s≥5`
claim does not depend on them: `Q25ProfileZero.profile_zero_pair_extension` kernel-checks `f=0`, and
`Q25AllProfiles.pair_extension` proves the uniform order-five extension theorem.
The C135 declarations classify equality by universal visibility and collision-free charge, and
classify every first-order excess level by invisible mass plus collision redundancy. In the
quadratic instance, invisible mass is center/empty-carrier incidence. This is an algebraic inverse
theorem, not a structural classification of near-saturated arcs.

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
