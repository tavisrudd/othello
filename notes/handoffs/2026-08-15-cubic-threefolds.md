# Cubic threefolds after stabilization

**Lane:** `cubic-threefolds`

**Date:** 2026-08-15

> **LIVE MAP ONLY.** This is the routing and state surface for this lane.
> Per-task detail belongs in the task cards under `notes/cubic-threefolds-tasks/`;
> proof-level detail belongs in the dated notes those cards link to.

## Origin and scope

Split off from the `clebsch` lane on 2026-08-15. This lane owns the
research-only successor program that grew out of Clebsch Paper V's
(`papers/chordal-conference-reconstruction/`) cubic-threefold epilogue:
quantum-monodromy stabilization, the relative Chow/cycle-theory frontier,
and adjacent structural research on cubic threefolds. It does **not** own
Paper V itself or the numbered Clebsch series — those stay in `clebsch`.

**C912 and C913 were re-pegged to this lane on 2026-08-15 by author
instruction**, and with them both stabilization manuscripts. C912 closed the
referee-foundation repairs to the cubic-stabilization epilogue
(`papers/cubic-stabilization-epilogue/`), the `m = 1` statement, whose headline
is now unconditional. C913 owns the referee revision pass on
*Irrationality of Cubic Threefolds after One Stabilization*
(`papers/cubic-stabilization-irrationality/`), the all-`m` statement, conditional
on the marked-threshold wall and zero-mode hypotheses. They are separate
manuscripts with separate hypotheses; this lane now covers both.

## Formal standard (when Lean-facing)

Any declaration this lane promotes to Lean (currently only C910's epilogue
companion) meets the same standard as the numbered Clebsch series: no
`sorry`, no `native_decide` or compiled-evaluation axiom at any terminal, no
project axiom or assumed hypothesis standing in for a proof, and every
promoted mathematical assertion maps to a kernel-checked declaration.

## Current status

- **C912 — closed 2026-08-18 by author instruction.** Referee-facing
  foundations for the epilogue: all twelve work packages landed, every
  implementation, review, copy-edit, detritus, build, and export gate green.
  The one-stabilization headline is unconditional through the Section 4 atomic
  route; Hypotheses 5.7R and 5.7T carry only the Section 5 framed-monodromy
  refinement. Standalone export is synchronized and unpushed. Card:
  [`c912-cubic-stabilization-referee-foundations.md`](../cubic-threefolds-tasks/c912-cubic-stabilization-referee-foundations.md).
- **C913 — referee revision pass on the all-`m` paper, active, author-close
  only.** Manuscript `papers/cubic-stabilization-irrationality/`, conditional on
  the marked-threshold wall and zero-mode hypotheses. Local frame/source repairs,
  modular hypothesis presentation and expanded proofs before the next frozen
  cold-read cycle; card:
  [`c913-cubic-stabilization-fable-revisions.md`](../cubic-threefolds-tasks/c913-cubic-stabilization-fable-revisions.md).
- **C907 — quantum monodromy stabilization, active.** v1 is unconditional:
  framed formal monodromy of the numerical small quantum connection, followed
  through Iritani's blow-up comparison, proves `X x P^1` irrational for every
  smooth cubic threefold (`papers/cubic-stabilization-epilogue/`, Silver
  tier). Gold (`m=2`) is reduced to a minimal nilpotent `K[N]` packet on the
  whole generalized `zeta_6` sector: endpoint `J_3`, strict blowup
  biproducts, and no center `J_3` imply irrationality; a `J_3` requires
  `nu_6>=6`, and the two-block strictness obstruction is one explicit
  `Ext^1_(K[N])` class. One exact localizing, Orlov-additive,
  `K_0`-linear/derived-Gysin `Phi_6` packet functor vanishing on all
  low-dimensional supports would kill every base-ideal extension and prove
  `m=2` by relative factorization; a formal-space projector is too weak, and
  linear projection shows raw `K_0` can already create `J_3`. Higher
  codimension needs a non-split exceptional string, so this Gold mechanism
  does not naively extend to Platinum (`m` arbitrary), which remains open.
  No Paper V or Lean promotion follows automatically. Card:
  `../cubic-threefolds-tasks/c907-quantum-monodromy-stabilization.md`; solver dossier:
  `../cubic-threefolds-tasks/c907-solver-dossier.md`; closed-phase archive:
  `../cubic-threefolds-tasks/c907-quantum-monodromy-stabilization-archive.md`.
- **C908 — Annals-upgrade mathematics, active.** Continues the highest-ceiling
  mathematics left by C904/Paper V after the fibrewise minimal-class theorem
  and the one-stabilization epilogue: priority A is the intrinsic relative
  Chow index of the generic unordered-theta fibre (`ind(Y)=1` vs `2`);
  priority B is the intrinsic `p`-typical divisor-product classification.
  Proved an integral lattice theorem for `H^3(Bl_0Θ,Z)` (torsion-free rank
  130, escape group free of rank ten, correcting a prior `(Z/2)^10`
  misidentification) — a candidate for its own paper, scoping pending the
  user. The priority-A `(1,5)` Chow-index channel is closed negative for
  every named source; priority A itself remains undecided. Card:
  `../cubic-threefolds-tasks/c908-annals-math-upgrades.md`.
- **C909 — cycle-side crown, active.** Extracts intrinsic cofactor-saturation
  and atom-carrier theorems from the epilogue; C907 retains higher-stabilization
  quantum work and C908 retains relative Chow / full `p`-typical
  classification. Full ordinary cohomological saturation of the prescribed
  graph divisor lattice is proved intrinsically; the actual six-axis
  four-slot quotient audit is now positive (unit line plus depth-one
  rank-four block, Pluecker defect vanishes), passing two independent
  hostile/priority audits. The higher-rank Dyck-height Smith formula is a
  successor crown, not a gate on this one. Card:
  `../cubic-threefolds-tasks/c909-epilogue-math-level-ups.md`.
- **C910 — Lean companion for the epilogue, active.** Formalizes the
  cubic-stabilization epilogue in the Mathlib-only package
  `papers/cubic-stabilization-epilogue/lean/`, under the C879 paper-facing
  namespace `TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue`, with
  reviewer entry point `PaperInterface` and machine audit
  `Verification/AxiomAudit`; no duplicate under the shared
  `lean/TavisRuddFiniteGeom/` tree or a second Lean repository. The sources
  build through the guarded queue; `make check` and the axiom-log gate green
  over 59 claims, 46 machinery rows, and 283 reviewer terminals; coverage 3
  absent / 27 fragmentary / 28 conditional / 1 complete. `thm:every-cubic` is
  anchored to the atomic route, the framed spine answers to its own manuscript
  theorem `thm:every-cubic-conditional` and is now assembled end to end on the
  product-formula signature, the small even block reduction is formalized from
  Cai's connection matrices through the modified residue, both six-point hearts
  and both product-formula corollaries have terminals, and the rank-two residue
  rigidity algebra of the atomic route is kernel checked, together with block
  diagonality of a pairing on separated spectral factors, the order comparison
  that selects the exotic gluing, and the order-by-order derivation of both
  pairing systems from horizontality, which closes the link from `lem:horiz`
  through `lem:orthogonal` to `lem:A0preserve`. The unconditional half of
  `cor:v14-one-step` is also proved: the genus-eight flop makes the two
  stabilizations birational and irrationality transports back from the cubic.
  The curve and surface exclusions are proved from premises matching the
  manuscript's citations rather than from two bundled implications. `lem:disc`
  and `lem:spectrum-transfer` are now conditional deductions: the four
  logarithmic derivatives of the quartic discriminant follow from the
  coefficient identities alone, those identities are exhibited in the universal
  root model, the vanishing half is proved in a formal power-series model of the
  germ, and the eigenvalue sets on the even algebra and on the full module
  coincide. `lem:orthogonal` is also a conditional deduction now: block
  diagonality holds for an arbitrary labelled splitting whose connection is
  block diagonal, a nondegenerate pairing stays nondegenerate on any set of
  coordinates orthogonal to its complement, which covers one factor and the even
  part of a factor, and equal leading eigenvalues admit a horizontal nonzero
  pairing. The residue discriminant is also proved invariant under conjugation,
  under a block-diagonal change of frame on one factor, and constant over a
  formal germ whose residue derivatives are commutators, which makes
  `prop:atom-invariant`, `lem:factor-glue`, and `lem:crossing` fragments. The
  three geometric rows `lem:euler-sign`, `lem:hodge-base`, and `prop:cubic-atom`
  are fragments as well, so every row of the unconditional atomic route carries
  at least a fragment. The manuscript now carries gated provenance annotations
  (`\coverage`, `\lean`, `\uses`, `\imports`, `\evidence`, `\proves`) resolved
  against the claim map, two registries, and per-row statement and terminal
  digests, with the dependency edges of the atomic route recorded and the
  annotated graph emitted and gated. Every claim-map row has now been reviewed
  against its statement and its terminals, which completes the adoption order of
  the annotation conventions; the review left the coverage labels unchanged and
  corrected nine recorded descriptions. The two clauses of
  `lem:six-axis-local-chart` that carried neither a terminal nor a fragment are
  now covered: the depth-one lift of a residue endomorphism to a self-adjoint
  integral one, and triviality of the principal quotient on the unimodular
  summand, the latter both in the chart, whose decomposition is now proved as a
  change of basis, and over the integers through the Smith reduction. The
  Section 5 framed-germ rows are covered as well: formal-germ rigidity of an
  isolated rank-two cluster and the multiplicity-one Euler block are fragments,
  formal-germ persistence of the cubic packet and the projective-space product
  formula are conditional deductions. Direct specialized low-dimensional
  vanishing is a conditional deduction as well: a weight-raising residue is
  nilpotent, the exponential of a nilpotent matrix is unipotent, a parity factor
  of square one leaves only characteristic roots of square one, and separability
  of the specialized quantum relation of a projective space makes every Euler
  block simple. The five absent rows left are the four separation corollaries and
  `lem:exact-low-degree-shifts`; neither cluster is a composition of formalized
  algebra.
  The rank-two step of the atomic route is now derived from a formal model of
  the connection rather than assumed: flatness and pairing horizontality are
  single power-series identities, the elementary modification is constructed as
  a gauge identity without inverses, flatness passes to the modified lattice,
  and the commutant computation, the vanishing of the residual base pole, the
  Lax equation, and constancy of the residue discriminant follow, over a formal
  germ as well; those terminals are registered, and the rank-two rigidity row is
  now a conditional deduction.  The normalized Sylvester gauge shared by the
  cubic block reduction and the spectral-factor gluing is formalized over a
  coefficient ring: the Sylvester operator of two separated leading operators is
  invertible, the block equation has exactly one block off-diagonal solution, a
  normalized block-off-diagonal gauge reducing a block-separated system exists
  and is unique, and for the separated small even cubic system the exhibited
  gauge and reduced coefficients are the first two coefficients of that unique
  gauge.
  The six-axis local chart now feeds the all-degree graph saturation theorem
  directly: the depth decomposition, the split coordinates, and the depth,
  scalar, and slope-error families are constructed from the chart instead of
  supplied, and the eigenblocks of a self-adjoint depth-one slope are proved
  orthogonal.  At three those data come from the slope itself; at two the
  exotic slope is proved to have no model over an ordered coefficient ring.
  The separated-variable clause of the separation theorem is also formalized,
  so the manuscript names the Fermat point instead of saying all but finitely
  many.
  Card:
  `../cubic-threefolds-tasks/c910-cubic-stabilization-lean-companion.md`; gap audit
  `../2026-08-18-c910-post-restructure-gap-audit.md`; anchor report
  `../2026-08-18-c910-atom-route-anchor.md`; block-reduction report
  `../2026-08-18-c910-block-reduction.md`; hearts and product-corollary report
  `../2026-08-18-c910-hearts-and-product-corollaries.md`; framed-route and
  rank-two rigidity report
  `../2026-08-18-c910-framed-route-and-rank-two-rigidity.md`; highest-risk-items
  report `../2026-08-18-c910-highest-risk-items.md`; pairing-horizontality
  report `../2026-08-18-c910-pairing-horizontality.md`; even-part
  orthogonality report `../2026-08-18-c910-even-part-orthogonality.md`;
  residue-discriminant invariance report
  `../2026-08-18-c910-residue-discriminant-invariance.md`; geometric-rows report
  `../2026-08-18-c910-geometric-rows-of-the-atomic-route.md`; annotation-layer
  report `../2026-08-18-c910-manuscript-formal-annotations.md`; claim-map reviews
  `../2026-08-18-c910-claim-map-review.md` and
  `../2026-08-18-c910-cycle-side-and-absent-rows-review.md`; local-chart lift and
  unit-summand report
  `../2026-08-18-c910-local-chart-lift-and-unit-summand.md`; framed-germ rows
  report `../2026-08-18-c910-framed-germ-rows.md`; direct specialized
  low-dimensional vanishing report
  `../2026-08-18-c910-direct-specialized-lowdim.md`;
  genus-eight
  unconditional report `../2026-08-18-c910-genus-eight-unconditional.md`;
  low-dimensional exclusions report
  `../2026-08-18-c910-low-dimensional-exclusions.md`; discriminant and
  spectrum-transfer report
  `../2026-08-18-c910-discriminant-and-spectrum-transfer.md`; separation and
  absent-rows report `../2026-08-19-c910-separation-and-absent-rows.md`;
  chart split-presentation report
  `../2026-08-19-c910-six-axis-chart-split-presentation.md`;
  interim release report
  `../2026-08-12-c910-partial-lean-release.md`.
- **C920 — closed 2026-08-18.** Hypothesis 5.7T of the epilogue is now used only
  for surface centers that are neither minimal nor geometrically ruled: the
  specialized primitive-sixth count vanishes for every Hirzebruch surface, by one
  deformation to index at most one, the rank-four Euler quartic and its
  discriminant, and a non-collision argument for the center specializations; the
  quadric surface goes through the Gromov--Witten product formula instead, which
  needs no relation between its two specialized values. The residual use of 5.7T
  is a single named obstruction, a support or base-change statement for the
  blowup comparison after external specialization. Card:
  `../cubic-threefolds-tasks/c920-minimal-ruled-tagging-removal.md`; report
  `../2026-08-18-c920-minimal-ruled-tagging-removal.md`. Not yet exported to the
  standalone repository.

- **C914 — both comparisons decided, restatement applied 2026-08-19.** The
  pencil contains the Fermat cubic threefold. All but finitely many of its
  members lie outside the Yang--Yu--Zhu coprime-degree locus: every member of
  their normal form carries an Eckardt point, and the generic pencil member
  carries none. Voisin's criterion is unreachable by any elliptic-product
  route: with the exotic two-primary gluing kernel, the only odd-degree product
  factorization of the intermediate Jacobian is `1 + 4`, realized at odd index
  `25`, so the pencil is not known to lie in a Voisin component. The restatement
  is in the manuscript and its registries, through four cold-read rounds. Card:
  `../cubic-threefolds-tasks/c914-a5-pencil-vs-coprime-degree-locus.md`;
  report `../2026-08-18-c914-a5-pencil-vs-voisin-and-yyz.md`; round-four reads
  `../2026-08-19-c914-round-four-mathematics.md` and
  `../2026-08-19-c914-round-four-consistency.md`.
- **C921 — residual Voisin gate, active; genus-four branch closed negative
  2026-08-19.** For all but finitely many members the four-dimensional factor
  `A_b` is not a genus-four Jacobian. What is left is the genus-five route, and
  only through an isogeny of degree greater than one. The integral glued model
  of the four-dimensional factor is derived and the Schottky count evaluated;
  that pass also corrects C914's description of the factor, which is of
  symplectic type `(1,1,1,5)` rather than principally polarized. That pass also
  located the pencil's Eckardt locus at the two Fermat members and its singular
  locus at six members, by elimination over `Q`; C923 has since reproved the
  Eckardt half structurally, so the epilogue's separation theorem keeps a
  qualifier but can name the single exceptional moduli point instead of saying
  "all but finitely many". Card:
  `../cubic-threefolds-tasks/c921-four-dimensional-factor-jacobian.md`; reports
  and evidence bundles `../2026-08-19-c921-genus-four-branch.md`,
  `../2026-08-19-c921-integral-glued-model.md` and
  `../2026-08-19-c921-pencil-level-structure-and-eckardt.md`.
- **C923 — closed 2026-08-19.** The pencil's Eckardt locus is now proved from
  complex reflection groups rather than from the elimination, and
  `prop:A5-not-coprime` is sharper for it: exactly two members, interchanged by
  the normalizer of `A_5`, each with exactly thirty Eckardt points, both the
  Fermat cubic threefold. The manuscript's only remaining premise-level
  computation is `lem:hirzebruch-euler-spectrum`. Naming the Fermat point in
  `thm:separation-family` is no longer blocked by any computation; the
  remaining gate is C910 sharpening
  `Applications.SeparationFamilyConclusion`, without which that row would drop
  to a fragment. Card:
  `../cubic-threefolds-tasks/c923-eckardt-locus-structural-proof.md`; report
  `../2026-08-19-c923-eckardt-locus-structural-proof.md`.
- **C917 — closed 2026-08-18.** The epilogue introduction now says why the
  direct Clemens--Griffiths mechanism gives no contradiction after one
  stabilization and where the result sits relative to Guéré
  (arXiv:2603.04518v1) and Benedetti--Fay--Guéré--Manivel--Perrin
  (arXiv:2607.26718v1), whose criterion assumes `b_3 = 0` and so does not
  reach `X x P^1`. Theorems and proofs unchanged; standalone repository
  synchronized and verified. Card:
  `../cubic-threefolds-tasks/c917-epilogue-hodge-and-guere-positioning.md`;
  report `../2026-08-18-c917-hodge-guere-positioning.md`.
- **C911 — closed.** Discrepancy-one flip correction, published as a
  standalone ten-page note (`papers/discrepancy-one-flips/`), DOI
  `10.5281/zenodo.21924799`. Independent cold read passed; authority and
  clean standalone gates pass; portfolio summary synchronized. Card:
  `../cubic-threefolds-tasks/c911-shen-shoemaker-flip-repair-note.md`.

No C907, C908, C909, C914, or C921 promotion into any manuscript, PDF,
mirror, or Lean source follows automatically from any of the above.

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Cubic-stabilization epilogue: `X x P^1` irrational, the `m = 1` statement | `papers/cubic-stabilization-epilogue/` | headline unconditional through the Section 4 atomic route since 2026-08-16; Hypothesis 5.7R and, since C920, Hypothesis 5.7T only for surface centers that are neither minimal nor geometrically ruled carry the Section 5 framed refinement stated as `thm:every-cubic-conditional`; Lean anchored to the atomic route, further coverage open under C910; the standalone export is synchronized and verified at `da7ec8e8f` | C907, C909, C910, C913 (C912 closed) |
| Discrepancy-one flip correction | `papers/discrepancy-one-flips/` | published standalone note, DOI `10.5281/zenodo.21924799` | C911 (closed) |
| *Irrationality of Cubic Threefolds after One Stabilization*: `X x P^m` for all `m`, the all-`m` statement | `papers/cubic-stabilization-irrationality/` | headline conditional on the marked-threshold wall and zero-mode hypotheses | C913 |

## Lane boundaries

This lane owns the cubic-threefold research program above, its task cards
under `notes/cubic-threefolds-tasks/`, and — since 2026-08-15 —
both stabilization manuscripts: `papers/cubic-stabilization-epilogue/` under
C907, C909 and C910, and `papers/cubic-stabilization-irrationality/`
under C913. It does not
own the numbered Clebsch series (Papers I–V) or any other `clebsch`-lane
surface — those remain foreign until an owning task here explicitly admits
them, per the usual cross-lane hygiene rule.

The companion discovery log is
`notes/2026-08-15-cubic-threefolds-discovery-track.md`. Logging an
observation neither allocates work nor adds it to a paper.

## Working and historical indexes

- Live task detail: `notes/cubic-threefolds-tasks/`.
- Prior lane history (pre-2026-08-15, while this program lived under
  `clebsch`): `notes/handoffs/2026-07-13-clebsch-lane.md` and its archive
  `notes/handoffs/done/2026-07-13-clebsch-lane-archive.md`.
