# Cubic threefolds after stabilization

**Lane:** `cubic-threefolds`

**Date:** 2026-08-22

> **LIVE MAP ONLY.** This is the routing and state surface for this lane.
> Per-task detail belongs in the task cards under `notes/cubic-threefolds-tasks/`;
> proof-level detail belongs in the dated notes those cards link to.  Removed
> chronology is retained in `2026-08-15-cubic-threefolds-archive.md`.

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
(`papers/cubic-stabilization-m1/`), the `m = 1` statement, whose headline
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

- **C936 — accepted after cold-referee repair audit.**  The warning-free eleven-page paper
  develops the signed nonstandard \(A_5\)-cubic parameter as the
  sign/discriminant resolvent of the actual
  relative norm-axis elliptic two-division cover.  It identifies
  \(T=81t^2\), \(r=9t\), \(X_0(6)\), the sign and split level-six subgroups,
  exact \(A_3\) monodromy, cusp widths \(2,6\), and the two extra
  modular-interior cubic boundary values.  At the chordal value, an exact
  orbit-and-ideal certificate identifies the transverse divisor with the
  reduced twelve-point icosahedral orbit conditional on identifying the
  special fibre with the secant cubic of its reduced singular rational normal
  quartic.  The van Geemen-lens referee's geometric findings are now repaired:
  the paper derives the factor-five Prym pullback and axis polarizations and
  forces the comparison isogeny to have degree one; an exact Fourier transform
  proves the coordinate and twist bridges; a separate programme-input
  proposition distinguishes candidates from the actual kernel; and the
  chordal fibre is displayed as a Hankel catalecticant.  The independent
  repair audit returns Accept at confidence 0.94 with no fatal or major
  defect; its final minor wording and optional certificate points are closed.
  A final style-guide pass gives a 142-source-word abstract and exposes the
  three-step proof mechanism immediately after the main theorem.  Integrated
  `make check` passes.  The verified standalone repository is
  `~/src/math-papers/cubic-gluing-resolvent` at `92a7d79`; its rebuilt PDF is
  byte-identical to the authority PDF.  A post-close EJ pass further proves
  that golden orientation turns the rational triple into the cyclic cubic
  splitting cover and gives
  \(t=3(\eta(3\tau)/\eta(\tau))^6\).  Exact algebra and an independent subgroup
  enumeration replay under `make check`.  Referee
  report: `../2026-08-21-c936-van-geemen-cold-referee.md`; project report:
  `../2026-08-21-c936-modular-resolvent-companion.md`.  The cubic-stabilization
  epilogue now points forward to the companion from its elliptic-discriminant
  paragraph.  Its 51-page rendering passes visual inspection and `make check`;
  its abstract is now a 164-word theorem-first paragraph and it carries the
  standard AI-assistance disclosure.  The verified standalone epilogue is
  synchronized at commit `65ef31d`, with a PDF byte-identical to authority.
- **C935 — closed 2026-08-21; exotic gluing is the elliptic discriminant
  orientation.**  The epilogue now proves that monodromy on the exotic pair is
  the sign of its action on the rational two-division triple, identifies the
  resulting class with the square-root torsor of the elliptic discriminant,
  and observes that the actual kernel section cuts mod-two monodromy to
  \(A_3\).  The noncanonical deck choice is explicit; the universal modular
  resolvent is verified but a curve-level cubic identification is reserved for
  a short companion after normalization, degree, stack-marking, and cusp gates.
  The manuscript remains fifty pages and `make check` passes.  Report:
  `../2026-08-21-c935-elliptic-two-division-resolvent.md`.
- **C934 -- paper upgrade/export complete; all-degree table active.** The
  11-page paper now proves the integral derived splitting, central Smith
  factor three, canonical mod-three `delta_0`--`IC`--`delta_0` Loewy chain,
  Fano lift of the link class, and exact modular failure of relative hard
  Lefschetz.  Fresh modular, geometric, and editorial packets are unanimous A;
  the active-voice abstract is 147 tokens; *Mathematische Zeitschrift* is the
  strongest target.  The clean standalone repository is
  `~/src/math-papers/blown-up-theta-lattice` and includes `.zenodo.json`.
  DOI `10.5281/zenodo.22036586` and the standard badge are recorded in the
  paper README; the public portfolio summary is synchronized.
  Original acceptance debt remains: enumerate all local/global integral groups
  in every degree.  Full Fano-transfer surjectivity and a monodromy-equivariant
  family form remain secondary tests.  Card:
  `../cubic-threefolds-tasks/c934-integral-theta-decomposition-complex.md`.
- **C933 — closed 2026-08-20; six-page Hodge-atom marker-ledger companion.**
  The standard atom construction is now a self-contained, strictly `m=1`
  specialization of the categorical occurrence/groupoid/fold spine; the
  epilogue has one non-load-bearing cross-reference and remains fifty pages,
  Gamma-row is untouched, and both standalone repositories are synchronized
  and verified.  Report:
  `../2026-08-20-c933-hodge-atom-marker-ledger-companion.md`.
- **C931 -- closed 2026-08-20; C928 repaired, re-refereed, and submission-ready.**
  The four adopted local findings were repaired without changing a theorem or
  proof mechanism: exact FVME credit, the integral-IH truncation convention and
  citation, the dual exact-sequence bridge, and noncanonical wording for
  Krämer's rational splitting.  Six fresh mutually isolated packets all return
  A with no required finding; Theorems 1.1 and 1.2 and Corollary 1.3 survive
  integrally, the eight-page PDF is clean, and every abstract count is below
  250 words.  Submit to *Proceedings of the AMS*; do not expand the present
  focused paper merely to chase the *Algebraic Geometry* stretch venue.  Card:
  `../cubic-threefolds-tasks/c931-c928-referee-dossier.md`; dossier:
  `../2026-08-20-c931-c928-referee-dossier.md`; final synthesis:
  `../2026-08-20-c931-c928-rerun-synthesis.md`.
- **C930 — 50-page epilogue refounding passes hostile manuscript review.**
  C930 owns only `papers/cubic-stabilization-m1/`, strictly at `m=1`.
  The common occurrence-indexed marker theorem is now instantiated on distinct
  atomic and framed block types, and both specializations pass resumed, fresh
  blind, and hostile manuscript review.  The implementation retains the
  18-page cycle core and refounds the quantum pair through the common compiler,
  shortening the frozen 60-page epilogue to 50 pages.  The full integrated
  check passes.  The Gamma-row manuscript is explicitly out of C930 scope and
  was not edited.  Baseline: `../2026-08-20-c930-epilogue-baseline.md`; memo:
  `../2026-08-20-c930-categorical-direct-qdm-proof-memo.md`; reports:
  `../2026-08-20-c930-independent-referee-report.md` and
  `../2026-08-20-c930-second-referee-pass.md`. Card:
  `../cubic-threefolds-tasks/c930-categorical-direct-qdm-paper-preparation.md`.
- **C925 — every-smooth stabilization irrationality, active.**
  **Result boundary:** no unconditional every-smooth \(m=2\) or all-\(m\)
  theorem has been landed.  The separate Voisin plus
  Engel--de Gaay Fortman--Schreieder route proves all stabilizations for a
  very general cubic, conditional on the cited 2025 preprint; it does not
  cover Voisin's special universally-\(\mathrm{CH}_0\)-trivial loci.

  **Conditional finite reduction:** put \(n=m+1\).  For a connected center,
  after a native pure-Euler inner \(n\)-cycle has been placed inside one fixed
  outer correction factor, Lean's cyclic dimension consumer forces \(d=n\)
  and exhausts the residue-zero plane.  Only that inner case is codimension
  two.  Lean also checks the recurrence compression, the lower cubic
  certificate, and scalar formula regressions at \(m=1,2,3,4,13\); it does
  not derive the generic all-\(n\) recurrence or residue shapes.

  **Exact open gate:** for \(m=2\), the nonsplit outer-return law and the
  accepted point/curve/surface marker theorem exclude codimensions three
  through five at the generic numerical-reduced even base.  The sole
  remaining theorem is occurrence-wise exclusion of an exact three-cycle
  among exact-\(4/9\) marked blocks of the single outer factor attached to
  each connected codimension-two threefold-center occurrence.  A generic
  divisor-generator reduction is not enough: a pairing-preserving parabolic
  shear fixes the unit and both divisor vectors and still produces the cubic
  marker.  The sufficient provider must descend the carrier and elementary
  modification to the native effective large-radius calibration, or prove the
  exact-period exclusion directly.  A regular unital projector descent would
  force a rank-six whole-center algebra; Elias--Rossi reduce its classical
  fibre to two types.  Explicit graded self-dual orders nevertheless realize
  both types with the same generic paired \(C_3\)-algebra and marked divisor,
  so order data alone do not close the QDM residue problem.  The
  matched divisor specializes to \(J_4\oplus J_2\) and
  \(J_4\oplus J_1^{\oplus2}\), respectively, so native control of this
  special Jordan type is a narrower possible separator.  Lean now checks one
  normalized generic primary reduction for each type: the dual-number
  reduction has residue discriminant zero, while the distinct-root reduction
  does not preserve the elementary-modification line.  Thus either normalized
  native calibration excludes \(4/9\), but no source constructs such a
  calibration from the geometric occurrence.  The strict companion equality
  case is now independently replayable: exact Rust elimination solves the two
  unique normalized gauges, Lean checks their full recurrences and
  discriminants \(0,4\), and a typed `Calibration` theorem transports the
  exclusion under simultaneous intertwining of multiplication, projector,
  first gauge, grading, selected basis, and left inverse.  The geometric task
  is to construct that calibration, not another finite recurrence proof.  The
  pre-strict candidate dimensions at
  \(n=2,3,4,5,14\) are respectively \(\{1,2\}\), \(\{1,3\}\),
  \(\{1,3,4\}\), \(\{1,5\}\), and
  \(\{1,7,8,9,11,13,14\}\).  After a separate equality-case exclusion, the
  unresolved sets are empty, empty, \(\{3\}\), empty, and
  \(\{8,9,11,13\}\).  These are missing geometric data or theorems, not
  another consumer-plumbing lemma.

  **Programme-level reconstruction signal:** the smallest plausible
  enrichment of the generic marked packet is now a two-layer **marked Rees
  port**: its self-dual Kummer-coweight orbit and its first marked
  connection/Rees jet.  The layers are independently necessary.  The two explicit native
  orders differ by relative coweight \((-1,0,0,0,0,1)\), whereas the
  coweight-zero parabolic shear retains the associated grading but changes the
  marker through its first jet.  The discrete monomial enumeration is now
  landed with canonical Rust data and Lean correspondence.  A bounded raw
  Bruhat domain is now ruled out under the coarse hypotheses: the effective
  charge-(3k+1) family retains exact cubic period and has unbounded self-dual
  coweight \((0,-k,-2k,2k,k,0)\).  Lean proves this uniformly.  The source
  theorem must instead construct a primitive marked valuation or quotient the
  coweight and first jet together by loop-trivial cocharacter drift.  C924's
  modified-flatness calculation does make the marked base connection regular
  in (z), so a relative Deligne--Manin extension is conditionally applicable
  after an effective regular-singular trait has been supplied; it does not
  choose that trait or the quotient.  Reports:
  `../2026-08-22-c925-marked-rees-shadow.md` and
  `../2026-08-22-c925-deligne-rees-extension-audit.md`.
  The first exact certificate stage is now landed: Rust emits the three
  Laurent comparison blocks inside the full (6\times6) basis-change matrix
  and the parabolic first jet, while Lean independently checks the extraction,
  recovers coweight \((-1,0,0,0,0,1)\), checks self-duality and all finite jet
  identities, and certifies the two independent information-loss modes.
  A second exact certificate now exhausts the effective coweight-zero
  dual-number chart: self-duality leaves five parameters, correct transport of
  both multiplication indices makes conformality equivalent to a
  one-parameter normal family, and Lean checks the complete gauge recurrence
  and discriminant zero throughout that family.  The output-only transport
  mutation is explicitly rejected.  A third exact certificate exhausts the
  five-parameter distinct-root chart.  Its logarithmic defect vanishes
  identically, but Lean proves that the selected block's lower-left grading
  entry is always \(1/6\), so the marker's leading line is not preserved.
  Thus both normalized native-order charts are closed.  A fourth exact
  certificate now exhausts the discrete unit/top-fixed monomial Weyl layer:
  four of eight positions are divisor-generating, and the Laurent Kummer
  involution pairs them into the two already-checked zero and single-reversal
  classes.  Lean now checks the complete divisor pullback after arbitrary
  displayed effective unipotent factors on both sides: none of the four other
  Weyl cells can satisfy the cubic branch-separation fingerprint.  This does
  not control loop-trivial coweight drift outside those cells.  The next
  finite test is the induced semidirect action on the first marked jet and
  recurrence; the geometric occurrence-to-port construction remains external.

  **Closed lanes:** the common \(\epsilon M\)-row/stable-projector
  composite, raw and normalized degree-zero augmentation, ordinary
  Hodge/Hard-Lefschetz multiplicity, and algebraic-simplicity projection all
  have explicit countermodels or completion/type failures.  Do not reopen
  them without defeating the recorded falsifier.

  Card: `../cubic-threefolds-tasks/c925-modular-direct-qdm-proof-packet.md`.
  Source dossier: `../2026-08-21-c925-no-stokes-source-dossier.md`.
  Divisor/calibration report:
  `../2026-08-22-c925-kummer-divisor-generator.md`.
  Marked Rees-shadow report:
  `../2026-08-22-c925-marked-rees-shadow.md`.
  Logarithmic-extension and trait-drift audit:
  `../2026-08-22-c925-deligne-rees-extension-audit.md`.
  Indirect route report:
  `../2026-08-22-c925-indirect-rationality-predictions.md`.

  Geometric (rotation-order) route and its 2026-08-23 vetting, which voids the
  grading-multiplicity exclusion and confirms the del Pezzo refutation of the
  dimension bound: card section "Geometric route to the same gate" and
  `../2026-08-23-c925-fable-opus-vetting.md`.  Marker reformulated as a
  \(\Psi\)-invariant Levelt exponent class; the calibration gate is superseded
  and the \(m=2\) obligation now lives on the centre's own quantum connection:
  `../2026-08-23-c925-fable-marker-is-levelt-exponent.md`.  Rank-two
  confluence rule proved and the cubic's block/Kuznetsov-Serre dictionary
  made unconditional via Sanda--Shamoto:
  `../2026-08-23-c925-fable-rank-two-confluence-gamma-ii.md`.  MM 2-24
  closed: every smooth member is a \(\mathbf P^1\)-bundle over
  \(\mathbf P^2\) and Iritani--Koto Theorem 5.1 splits its ledger into two
  semisimple \(\mathbf P^2\) summands; the \(b_3=0\) tail residue is now
  the Mori--Mukai enumeration completion plus non-chain non-Fano carriers:
  `../2026-08-23-c925-fable-mm224-projective-bundle-closure.md`.

- **C924 — closed 2026-08-19.** The direct ordinary-QDM route proves
  irrationality of `X x P^1` after one mandatory local repair: compare the
  intrinsic and asymptotic projective-bundle QDMs through Iritani--Koto's
  common faithful ring `C[q][[Q,t]]`, not through a nonexistent embedding of
  the full `q`-adic completion into the `q^{-1}`-Laurent completion.  Every
  other load-bearing step and primary source passed, the finite cubic algebra
  replayed exactly, and the route compresses further to even rank two,
  nonzero nilpotent, and nonzero modified-residue discriminant.  No manuscript
  or Lean file was edited.  Report:
  [`2026-08-19-c924-direct-qdm-proof-audit.md`](../2026-08-19-c924-direct-qdm-proof-audit.md).
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
  smooth cubic threefold (`papers/cubic-stabilization-m1/`, Silver
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
- **C908 — Annals-upgrade mathematics, active.** Retains the highest-ceiling
  mathematics left by C904/Paper V after the fibrewise minimal-class theorem
  and the one-stabilization epilogue: priority A is the intrinsic relative
  Chow index of the generic unordered-theta fibre (`ind(Y)=1` vs `2`);
  priority B is the intrinsic `p`-typical divisor-product classification.
  Its integral lattice theorem for `H^3(Bl_0Θ,Z)` (torsion-free rank
  130, escape group free of rank ten, correcting a prior `(Z/2)^10`
  misidentification) and the resulting standalone paper were split to C928
  by author instruction on 2026-08-20. The priority-A `(1,5)` Chow-index channel is closed negative for
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
  [`papers/cubic-stabilization-m1/`](../../papers/cubic-stabilization-m1/),
  under the C879 paper-facing
  namespace `TavisRuddFiniteGeom.Papers.CubicStabilizationM1`, with
  reviewer entry point `PaperInterface` and machine audit
  `Verification/AxiomAudit`. The entry point is now a thin aggregator over
  semantic facades for the five proof-bearing manuscript sections, a
  declaration-free synthesis facade, and three semantic machinery facades
  containing the 83 unclaimed terminals; all 311 fully qualified terminal
  names are unchanged. The current
  main proof spine is the effective
  categorical block ledger and occurrence-indexed weak-factorization descent:
  the direct rank-two residue theorem and the finer primitive-sixth framed
  theorem are literal specializations of the same generic theorem, and their
  strict `m = 1` cubic contradictions are now the reviewer-facing headline
  terminals. QDM block construction, comparison, factorization, and geometric
  nullity remain explicit premises; Gamma-row and all-`m` work are untouched.
  A 2026-08-21 red-team repair narrows the atomic fold from nonzero residue
  discriminant to distinct formal exponent classes modulo the integers, makes
  the even carrier explicit, and closes the spectral-splitting,
  summand-separation, coefficient-ring, and grading-suspension interfaces.
  The current checked snapshot is 54 claims, 4 absent, 23 fragmentary, 26
  conditional, 1 complete, and 316 reviewer terminals, of which 83 are
  machinery. A fresh isolated cold read found no process debris, retained the
  concise theorem-first abstract, and made the formal-exponent terminology
  consistent throughout. Earlier checkpoints below record the superseded atom-route
  assembly history. No duplicate under the shared
  `lean/TavisRuddFiniteGeom/` tree or a second Lean repository. The sources
  build through the guarded queue; `make check` and the axiom-log gate are green
  at the current snapshot. `thm:every-cubic` is
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
  The discriminant group of the source polarization is now built as well, with
  its `Q/Z`-valued pairing, order `6^8`, and maximal isotropy of the order-`6^4`
  kernel subgroup of any comparison matrix satisfying the pullback identity.
  The per-prime form is proved too: the explicit cofactor `I5+J5` makes six
  annihilate the group, so it splits as `D_2 + D_3` with orthogonal, separately
  nondegenerate parts, the kernel splits the same way, and each `K_p` is a
  relative maximal isotropic subgroup of `D_p`. The two models of the
  two-primary discriminant are also identified: reduction modulo two of the
  cofactor image carries the two-torsion part of the cokernel isomorphically
  onto the kernel of the polarization reduced modulo two, hence onto four
  copies of the rank-two two-torsion module, and that identification carries the
  discriminant pairing to the normalized two-primary form, which is in turn
  isometric to the rank-eight tensor form in the standard coordinates. So the
  two-primary kernel, carried into those coordinates, is proved maximal
  isotropic and belongs to the five-member projective-line packet as soon as
  diagonal stability is granted. The same chain now runs at three: the
  reduction modulo three of the cofactor image identifies the three-primary
  part with the kernel of the polarization reduced modulo three, carries the
  discriminant pairing to minus the dot product tensored with the reduced
  elliptic pairing, and is an isometry onto the two-copy polarization form of
  the three-primary heart, where the transported kernel is maximal isotropic
  and therefore four-dimensional, hence the vertical copy or one of the three
  scalar graphs once diagonal stability is granted. The orders `2^8` and `3^8`
  of the primary parts of the discriminant group follow from those two
  comparisons. Stability is no longer an input at either prime: the six-label
  permutation group is represented on the source lattice by explicit integral
  matrices preserving the polarization, its contragredient descends to the
  discriminant group, and for a comparison matrix equivariant for the two
  displayed generators both transported primary kernels are diagonally stable
  and therefore unconditionally in their packets. Which member the two-primary
  kernel is cannot be settled that way, since every packet member is stable; the
  selecting input is now formalized as Frobenius marking. Frobenius of the
  labelling field transported to the packet is an involution fixing exactly the
  three members defined over the prime field and exchanging the two exotic
  graphs, so a marked member is exotic and its graph slope has minimal
  polynomial `t^2+t+1`, which is the slope datum the local-chart lemma states at
  two; one marked fibre over a connected base makes every fibre exotic. That
  involution is now identified with the labels themselves: scaling by a
  non-square scalar is an odd permutation of the six labels whose diagonal heart
  action is exactly the transported involution, the packet action of the group
  generated by the three displayed label permutations factors through the sign
  character, and the three prime-field members are fixed by every invertible
  diagonal action, so marking is being moved by an odd label permutation and no
  group-invariance hypothesis can replace it. The label group is now determined
  exactly: a label permutation preserves the packet precisely when conjugation
  by its heart matrix fixes the commutant root or moves it to its conjugate, the
  permutations centralizing that root form a group of order sixty which is the
  alternating image itself, and the packet-preserving permutations therefore form
  a group of order one hundred twenty that is generated by the three displayed
  permutations and equals the full normalizer of the alternating image. The
  orders `2^4` and `3^4` of the primary parts of the kernel are proved as well,
  from the splitting and Lagrange's theorem alone. What remains supplied is the
  identification of that matrix-level equivariance with equivariance of an
  actual relative isogeny, the marking of the actual geometric kernel, the
  identification of the six labels with the manuscript's dihedral axes, and the
  geometric commutator pairing.
  The fifteen nonzero heart vectors are now identified with the fifteen pairs of
  labels, the displayed one-factorization is proved to be the orbit decomposition
  of multiplication by the quadratic root `W`, and preserving that
  one-factorization is proved equal to the packet-preserving condition, with
  centralizing `W` its index-two even part.
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
  source-discriminant-group report
  `../2026-08-19-c910-source-discriminant-group.md`;
  primary-splitting report
  `../2026-08-19-c910-primary-discriminant-splitting.md`;
  two-primary lattice-model report
  `../2026-08-19-c910-two-primary-lattice-model.md`;
  two-primary pairing report
  `../2026-08-19-c910-two-primary-pairing.md`;
  two-primary standard-coordinate report
  `../2026-08-19-c910-two-primary-standard-coordinates.md`;
  three-primary analogue report
  `../2026-08-19-c910-three-primary-analogue.md`;
  six-label action and kernel-stability report
  `../2026-08-20-c910-six-label-action-and-kernel-stability.md`;
  marked-Frobenius selection report
  `../2026-08-20-c910-marked-frobenius-exotic-selection.md`;
  packet label-group and kernel-order report
  `../2026-08-20-c910-packet-label-group-and-kernel-orders.md`;
  unconditional QDM referee repair
  `../2026-08-21-c910-unconditional-qdm-referee-repair.md`;
  duad/one-factorization dictionary report
  `../2026-08-20-c910-duad-one-factorization-dictionary.md`;
  odd-label realization report
  `../2026-08-20-c910-odd-label-frobenius-realization.md`;
  interim release report
  `../2026-08-12-c910-partial-lean-release.md`.
- **C928 — closed 2026-08-20.** The integral middle lattice of the
  cubic-threefold theta divisor is now a self-contained warning-free
  eight-page paper.  Pair occupancy and complete-graph incidence replace the
  saturation certificate; the universal line and a Pontryagin endpoint formula
  replace the glue certificate; `IH^3(Theta,Z)` is free of rank 130 with the
  canonical mod-two fibre-product glue; and the dual escape lattice is free of
  rank ten with exceptional image `2E`.  Kraemer's rational decomposition is
  credited as prior art, the modern integral-Lefschetz boundary is explicit,
  and C908 retains its Chow-index and `p`-typical crowns.  Card:
  `../cubic-threefolds-tasks/c928-blown-up-theta-lattice-paper.md`; report:
  `../2026-08-20-c928-closeout.md`; paper:
  `../../papers/blown-up-theta-lattice/`.
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
| Cubic-stabilization epilogue: `X x P^1` irrational, the `m = 1` statement | `papers/cubic-stabilization-m1/` | headline unconditional through the Section 4 atomic route since 2026-08-16; Hypothesis 5.7R and, since C920, Hypothesis 5.7T only for surface centers that are neither minimal nor geometrically ruled carry the Section 5 framed refinement stated as `thm:every-cubic-conditional`; Lean anchored to the atomic route, further coverage open under C910; the standalone export is synchronized and verified at `0387c21` | C907, C909, C910, C913 (C912 closed) |
| Discrepancy-one flip correction | `papers/discrepancy-one-flips/` | published standalone note, DOI `10.5281/zenodo.21924799` | C911 (closed) |
| *Irrationality of Cubic Threefolds after One Stabilization*: `X x P^m` for all `m`, the all-`m` statement | `papers/cubic-stabilization-irrationality/` | headline conditional on the marked-threshold wall and zero-mode hypotheses | C913 |

## Lane boundaries

This lane owns the cubic-threefold research program above, its task cards
under `notes/cubic-threefolds-tasks/`, and — since 2026-08-15 —
both stabilization manuscripts: `papers/cubic-stabilization-m1/` under
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
