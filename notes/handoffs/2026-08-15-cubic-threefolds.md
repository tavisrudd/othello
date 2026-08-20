# Cubic threefolds after stabilization

**Lane:** `cubic-threefolds`

**Date:** 2026-08-20

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

- **C931 -- C928 named-referee batch, active; dossier sealed.** The closed
  eight-page theta-lattice paper is frozen at commit `ac04f826c` and PDF hash
  `3822f928...e36e5`.  The dossier names and sources independent
  cubic/Fano, integral topology/IH, abelian/Pontryagin, integral symplectic
  lattice, closest-prior-art, and editorial-ceiling packets, with explicit
  source-adjacency and conflict cautions.  No simulated report or manuscript
  edit has yet been made.  Card:
  `../cubic-threefolds-tasks/c931-c928-referee-dossier.md`; dossier:
  `../2026-08-20-c931-c928-referee-dossier.md`.
- **C930 — corrected epilogue overlay ready for manuscript refounding.**
  C930 owns only `papers/cubic-stabilization-epilogue/`, strictly at `m=1`.
  Its common occurrence-indexed marker theorem and both specializations pass
  resumed and fresh blind review.  The complete 60-page epilogue has now been
  read and frozen, and the corrected overlay retains its 18-page cycle core
  while refounding the 34-page quantum pair through the common compiler.  The
  working target is 46--50 pages and the author's phase-2 editing authorization
  is active.  The Gamma-row manuscript is explicitly out of C930 scope and was
  not edited.  Baseline: `../2026-08-20-c930-epilogue-baseline.md`; memo:
  `../2026-08-20-c930-categorical-direct-qdm-proof-memo.md`; reports:
  `../2026-08-20-c930-independent-referee-report.md` and
  `../2026-08-20-c930-second-referee-pass.md`. Card:
  `../cubic-threefolds-tasks/c930-categorical-direct-qdm-paper-preparation.md`.
- **C925 — modular direct-QDM proof packet, active.** Write a self-contained
  alternative packet organized like a parameterized software interface: a
  caller chooses which generic even-block data to observe, which blocks to
  mark, and what commutative-monoid value to retain, while the coefficient,
  comparison, ledger, and weak-factorization modules remain reusable.  The
  first concrete instance is the minimal marker proving cubic
  one-stabilization irrationality; Guéré/BFGMP and KKPYY are audited
  specializations.  The sparse-shadow extension includes kernel profiles,
  cyclic Krylov data, Reader/indexed-State/Writer effects, optics, path
  functors, torsor holonomy, and a semilinear simple-character criterion.
  The false naked row-null ideal has been removed: comparison now lands in an
  augmented operator-row category, whose output-kernel ideal is genuinely
  two-sided.  For \(m=2\), the pointed primitive-sixth endpoint contrast and
  fivefold center reduction are exact, but no unconditional blowup provider
  is known.  Generic-point localization proves rank is the universal
  support-null \(K_0\)-character, and the whole full-rank comparison defect is
  one boundary-to-rank leakage covector.  Wall mutations and multiplicity-one
  characters kill that covector when their analytic hypotheses hold; Hodge,
  raw grading, and formal monodromy do not supply those hypotheses.  The
  conditional relative-cap route reduces the remaining rank-two-normal
  problem to a same-exposed-face cancellation against the hostile \(-1/R\)
  pilot only after identifying its scalar channel with the analytic leakage.
  The conditional Section 6 \(m=1\) argument is now an exact sibling
  specialization: it retains the small point and original \(z\)-disc, exposes
  5.7R as a reconstruction-tail certificate and the used part of 5.7T as a
  residual-tagging certificate, and keeps every center specialization
  \(\chi_j\) indexed.  Its endpoint uses the unconditional external
  \(\mathbf P^1\)-product formula, so it does not consume the conditional
  projective-bundle formula.  The non-\(m=2\) categorical dividend is now
  promoted: the indexed center-null quotient represents and detects every
  center-null marker, every small marker family has a canonical minimal
  sufficient shadow, and parallel sparse shadows satisfy an exact joint-fibre
  descent criterion without reconstructing the rich object.  The updated
  \(m=2\) roadmap now records the raw triangle/deck-orbit failures and the two
  exact replacement gates.  Any unbounded stabilization subsequence already
  implies all \(m\); the binary model
  \(X\times(\mathbf P^1)^m\) has a unique top \(J_{m+1}\), while a
  codimension-\(c\) center occurrence satisfying the indexed bound
  \(\ell_\theta(Z;\sigma)\le\dim Z-1\) contributes at most \(J_m\) after its
  exceptional \(J_{c-1}\) factor.  The minimal consumer is the Boolean
  high-length shadow, and the three conditional inputs need only exist on one
  cofinal fixed-factor family.  The strict-splitting transport gate has now
  been weakened exactly: for \(\operatorname{Top}_m=N^mV\), one canonical
  snake/Bockstein boundary is the sole extension defect.  Standard Orlov
  semiorthogonality has the variance of the opposite sequence
  \(0\to E\to B\to A\to0\); its ambient-to-exceptional Hom must vanish in an
  enriched operation-framed exact heart, not in plain \(K[N]\)-modules.  A
  left-orthogonal exact-heart adapter now makes boundary vanishing formal
  once that orientation and component typing exist; a quiver model shows
  this may preserve the top shadow without splitting the heart extension.
  A dependent typing audit packages occurrence, orientation, exponent,
  kernel/component membership, and exact QDM realization separately; it
  shows no further ExactTop source augmentation or faithful/full receiver is
  consumed, but exact \(N\)-compatible realization is load-bearing.  A
  primary-source precedent audit promotes source/target-indexed provider
  arrows and occurrence-safe lawful reindexing; types make illegal
  compositions unrepresentable but do not manufacture local geometry.
  A direct re-audit of Iritani's Theorem 5.18 isolates a cheaper formal
  target: it does not state compatibility with the current
  tensor-by-line-bundle operation, but the rank/Boolean ExactTop consumer
  needs only that the transported threshold image be a graph over the
  ambient top.  The cubic/product source needs no further point/Gamma row;
  the comparison still needs the exact divisor-cocharacter/Levelt
  realization and the independent exceptional exponent certificate.
  Gamma framing factors tensor-by-line-bundle through large-radius
  monodromy, so the comparison need not preserve the Gamma lattice.
  A hypothetical birational map supplies a canonical mobile hyperplane
  state along its factorization; its signed exceptional corrections are the
  whole path defect.  Raw correction-nullity is false by the linear
  projection \(J_3\) counterexample, so the remaining theorem must be
  primitive-character projected.  For commuting unipotent line-bundle
  actions, logarithm compresses every correction to \(X+aY\): one mixed
  cross term at \(m=2\), and finitely many mixed words for general \(m\).
  Orlov projection now identifies both correction branches: exceptional
  helix wraps and ambient-input defects lie in the thick subcategory
  generated by the actual center, with explicit symmetric normal-bundle
  coefficients.  Thus one exact whole-center-null primitive-character
  receiver kills every mobile multiplicity on the correction side, but that
  QDM/Gysin realization is still open.  Ordinary Gamma projection cannot
  supply it: a cubic point has nonzero projection to both primitive-sixth
  branches.  The same hostile point calculation proves that the surviving
  fixed-phase ambient-rank row is nonzero.  Algebraic Orlov images have rank
  zero, so the leading uniform all-\(m\) gate is now the typed sectorial
  promotion of that row, including exceptional scalars and adjacent row
  identification.
  The final consumer is only the rank quotient line: on one chosen weak
  factorization, local comparison-induced line isomorphisms and adjacent
  row reindexing compose automatically, so scalar normalization, loop
  holonomy, and path-independent coherence are unnecessary.
  Perfect dual-sector pairing compresses each local row law further to
  transport of one projective Gamma point line.  The formal comparison has
  the desired point-plus-zero shape and the full Gamma point section is
  line-bundle-monodromy invariant; the remaining local gate is commutation
  of the primitive projector and fixed-phase Gamma-to-formal point-line
  calibration.
  Picard fixed-line uniqueness is now closed negatively: every nonzero
  exceptional unipotent module has a common fixed vector for any commuting
  family.  The remaining selector must be a multiplicity-one
  filtered/semisimple/support-sensitive quotient or a genuinely non-Picard
  operation.
  A mathematical-physics Stokes detour now has an exact algebraic target:
  in a common pointed charge completion, positive-charge exceptional factors
  form an augmentation congruence and cannot alter the degree-zero rank
  quotient through any ordered product, inverse, or refactorization retained
  in that common positive congruence.  This
  could bypass local \(m=2\) boundary vanishing uniformly in \(m\), but it
  replaces it with a zero-reflecting occurrence-charge provider.  Bare
  Kontsevich--Soibelman support is insufficient; opposite charges and a
  zero-charge exceptional shear are sharp countermodels.  The hostile
  \(-1/R\) coefficient itself lies on nonzero exponent \(-1\) and therefore
  passes the finite exponential-support regression after orienting the
  one-sided cone.  That bounded charge regression is now complete.  The
  actual split toric and
  cubic-center pilots have zero exceptional point coefficient after Kummer
  normalization; the hostile negative-degree substitution has stable
  exponent \(-1\), but no audited source realizes it as an actual
  relative-cap Stokes factor.  More decisively, Iritani's codimension-two
  center has a single pointed stationary charge, while the \(r-1\) charges
  of every codimension-\(r\ge3\) full center packet form a roots-of-unity
  polygon summing to zero.  The charge route therefore remains plausible for
  the new \(m=2\) codimension-two gate only after same-receiver lower-center
  nullity; the naive all-branch all-\(m\) exponent cone is closed negative,
  though a finer charge lattice remains a separate provider possibility.
  The rank-row route now bypasses that local center problem: the audited
  one-arrow receiver handles isolated discrepant walls, so the remaining
  \(m=2\) ambiguity lies only at consecutive discrepant receiver overlaps.
  The overlap defect is a crossed Writer cocycle.  Its first gate is
  compatibility of the actual row-null supported spans; after that,
  center-image mutations are safe.  An opposite-sign fivefold two-ray face
  has one of six primitive neutral slopes up to exchange and is dangerous
  only if its mixed boundary tower couples the cubic packet to a rank-visible
  ambient target.  The slope test is necessary only; the positive analytic
  alternative retains the full \(P_6\)-faithful carrier face and
  oriented-path hypotheses.
  A generic nonresonant GKZ/window comparison cannot simply be specialized
  to the integral geometric parameter: restriction to the punctured trait
  forgets finite closed-support torsion.  Crepant toric HMS protects the
  trivial-parameter rank quotient in its stated range, but the first neutral
  discrepant model is not quasi-symmetric.  For every remaining overlap the
  exact replacement is a canonical trait realization and marked saturation
  with exact base change of the primitive-packet rank-coimage comparison; on
  a nonzero line this is one additive DVR valuation, reducible to Smith/Gamma
  pole-zero arithmetic after the actual overlap matrix is constructed.
  Raw discrepancy itself excludes quasi-symmetry, so the current
  nonresonant schober theorem cannot directly calibrate any discrepant
  overlap.  Under an effective genuine-unit \((1,1)\) two-ray pilot,
  adjoining the negative total-character coordinate yields only five
  genuine unit-wall quasi-symmetric eight-weight signatures without total
  unimodularity: one for three ordered types and two for flip--flip.  The next
  gate is to realize an actual AKMW overlap by one of those common matrices
  and descend its completed generic comparison through the marked saturation
  interface.
  Module 42 proves that the raw forward quantum-Serre bridge cannot preserve
  the marked row: its self-intersection map has rank zero and kills the point
  class.
  Equivariantly it has the universal factor \(1-q^{-1}\), and its normalized
  first normal jet is the identity on a new rank/point jet shadow; the raw
  special fibre remains zero.  Module 43 proves that common-open completed
  window comparisons contribute no further defect: all five signatures,
  including the determinant-two flip--flip pilot, have residual valuation
  zero and the same unit normalized jet.  The sharpened target is solely an
  occurrence-level fixed-phase QDM/Gamma adapter identifying that algebraic
  jet with the actual endpoint transition.  Module 44 gives a second
  augmentation: the Euler coimage is the narrow state space, the point class
  survives in that image, and its compact-support pairing recovers the source
  rank row.  A common fixed-phase paired narrow-QDM realization would bypass
  the normal derivative, but is not yet constructed.
  Shifted tensor stability and the extremal multinomial source law are
  proved, but the occurrence-indexed exact QDM sequence, actual carrier
  exponent, and boundary vanishing remain open.  The packet is split into
  bounded module companions behind a stable index.  The
  one-hundred-three-check
  finite law replay, eleven-check typed Haskell toy, and original cubic
  replay are green.  C925 remains open at fixed-phase Gamma/rank transport
  or at this ExactTop provider; the relative-cap cancellation remains one
  possible rank provider.
  Mathematics only; no manuscript or Lean edits.  Card:
  `../cubic-threefolds-tasks/c925-modular-direct-qdm-proof-packet.md`.
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
| Cubic-stabilization epilogue: `X x P^1` irrational, the `m = 1` statement | `papers/cubic-stabilization-epilogue/` | headline unconditional through the Section 4 atomic route since 2026-08-16; Hypothesis 5.7R and, since C920, Hypothesis 5.7T only for surface centers that are neither minimal nor geometrically ruled carry the Section 5 framed refinement stated as `thm:every-cubic-conditional`; Lean anchored to the atomic route, further coverage open under C910; the standalone export is synchronized and verified at `da1d8641b` | C907, C909, C910, C913 (C912 closed) |
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
