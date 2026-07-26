# Paper: Frobenius-equivariant pair extension and robust repair of eight-arcs

**Title:** *Frobenius-equivariant pair extension and robust repair of eight-arcs.*

**Lane:** `paper-frob-eq`.

**Object:** the focused paper on the quantitative quadratic-Frobenius pair-extension criterion, its
exact collision correction, robust orbit replacement, five-profile lower envelope, and the exact
exceptional `PG(2,25)` minimum and extremal classification. This is the canonical paper directory;
`baer-equivariant-extension` is a retired source view. The generic
`completion-core-rigidity` package is reusable library material but is not part of this submission.

**Formal status:** the quadratic pair-extension existence theorem, exact exceptional-profile
minimum `32` and five-orbit equality classification, uniform four-pair `PG(2,25)` theorem,
exact five-profile first-order envelope, 318-alternate-repair theorem, collision equality/excess
classification, parameterized `(k+2)→k` robust exchange theorem, and semantic global pair count are
kernel-checked. The
end-to-end Lean theorem constructs two distinct conjugate pairs whose separate unions with the
invariant arc are arcs. `QuadraticGlobalCount.lean` defines the semantic global finset of fresh legal Frobenius pairs
and kernel-checks its equality with the disjoint carrier union and `PairExtensionData.legalCount`.
The five parity-allowed Q25 profiles are exhausted in Lean. Every invariant eight-arc in
`PG(2,25)` has at least four distinct legal conjugate pairs, so deleting any selected nonfixed orbit
from an invariant ten-arc leaves at least three different legal orbits that repair it. In the
two-fixed-point profile, every arc has at least `32` legal pairs; equality is attained and, up to
normalization, consists exactly of five residual-group orbits of sizes `200,400,400,200,400`.
For every base order `s≥7`, the certified envelope gives at least 319 legal pairs for every
invariant eight-arc and hence at least 318 alternate repairs after arbitrary selected-orbit deletion.
More generally, a selected-orbit deletion from an invariant `(k+2)`-arc leaves at least `r`
alternatives whenever
`floor((k-1)^2/4) + r + 1 ≤ s(s-1)/2`. The obstruction term is the exact maximum over compatible
profiles. For `s≥4`, the convenient rectangle `1≤k≤s+1` always supplies at least one alternative;
the excluded point `(s,k)=(3,4)` misses by exactly one candidate.
The manuscript now also gives the exact Clebsch specialization: after
scalar extension from `GF(11)` to `GF(121)`, the Clebsch hexagon has
`76*55=4180` legal Frobenius-paired two-column MDS extensions, and any
selected extension has `4179` alternate pair repairs. This is a
manuscript-level corollary of the general carrier count, not a new Lean
terminal; the count holds for every `GF(11)`-rational six-arc.

**Publication status:** focused LaTeX submission source, bibliography, and PDF complete; bounded
general-criterion priority search and direct Dye/Blokhuis–Seress–Wilbrink checks complete. The
checked Q25 result has no proof-validity defect in
the scoped audit. Citation, label, trust-boundary, manuscript-to-Lean, TeX, BibTeX, reference, and
box-warning checks pass. The manuscript promotes the consequence for every prime-power base order
`s≥5` to a numbered corollary, displays the five Q25 profiles and their proved lower bounds in one
audit table, and records the exact Lean/mathlib pins, formal-source checkpoint, and build commands.

**Novelty boundary:** Hilbert 90, the Baer fixed subplane, projective point/line counts, the
occupied-line double count, and two-element involution-orbit counts are classical infrastructure,
not Discovery Track claims. The square-root constant is the classical Lunelli–Sce scale. Candidate
contributions are the exact quadratic orbit-valued criterion and its semantic coordinate coupling.
The generic completion/transversal library is not a contribution of this focused paper.
Dye's exact Clebsch completion geometry and shared-triangle graph and the Blokhuis–Seress–Wilbrink
classification of complete exterior sets are explicit special-family predecessors. No exact
precursor for the criterion on arbitrary quadratic-field-Frobenius-invariant arcs was located in
the bounded C139 search; this supports no historical-first claim.

**Checked strengthening:** the exact linewise refinement separates invisible centered secant orbits from genuine
charge collisions; its subtraction-free linewise and aggregate forms are Lean-proved.
The profile-independent cross-pair estimate `s+3-f-e` is also kernel-checked in
`QuadraticInvisible.lean`; the theorem derives the necessary `e≥2` from the cross-pair witness.
`Q25PairResult.f2_two_pair_extension` supplies the original two-witness baseline in the exceptional
`f=2` profile, and the certificate-free `Q25ProfileFour.profile_four_pair_extension` kernel-checks
`f=4`. The residual composition, orbit--stabilizer, strict-exhaustion, and semantic-transport
modules strengthen the `f=2` result to the exact minimum `32` and the complete five-orbit equality
classification up to normalization. The external census size remains computational context; it is
not needed for the exact theorem. The uniform `s≥5` claim also uses
`Q25ProfileZero.profile_zero_pair_extension` for `f=0`, and
`Q25AllProfiles.pair_extension` proves the uniform order-five extension theorem; the generic
criterion covers every `s≥7`, and there is no intervening prime-power base order.
`AlternateOrbitRepairProfileEnvelopeResult.profileEnvelope_le_card_globalLegalPairs_of_card_eight`
connects the five exact arithmetic profiles to the semantic legal-pair finset, and
`three_hundred_eighteen_le_alternateLegalPairs_of_seven_le` proves the uniform repair bound. The
profile-minimized envelope is a certified first-order lower bound, not an asserted attained minimum.
`ParameterizedAlternateOrbitRepair.card_alternateLegalPairs_ge_of_phase` proves the general
puncture-and-re-extend theorem, while `AlternateOrbitRepairPhaseDiagram` proves both the exact
profile obstruction and that the phase inequality itself forces an empty fixed carrier.
The C135 declarations classify equality by universal visibility and collision-free charge, and
classify every first-order excess level by invisible mass plus collision redundancy. In the
quadratic instance, invisible mass is center/empty-carrier incidence. This is an algebraic inverse
theorem, not a structural classification of near-saturated arcs.

**Open release work:** C318 adds the residual classification layer to the paper-facing trust
manifest. C319 decides whether the literal canonical-class links remain in the trusted surface or
are demoted to a checked reduction plus reproducible computation. C152's exchange graph is optional
future work and is not a release gate unless its results are later adopted.

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
