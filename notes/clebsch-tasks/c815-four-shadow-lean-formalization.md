# C815 — Lean formalization of four-shadow recognition

**Lane:** `clebsch`  
**Status:** reopened after formal audit; the three Paper III gates, their axiom
reports, manifests, and all paper-local replays are green with no
compiled-evaluation axiom at any terminal, the documentation and gate-replay
obligations of the audit checklist are closed, the recognition theorem is
transported off the root gauge and the conference switching class is proved
unique, the aligned-design strengths are formalized at the manuscript's quantifier
range, the rank-14 weighted Jacobian now has a structural proof, and the
remaining work is gap class B plus the reduced weighted-Jacobian Lean bridge
before the API is handed to C823

## Objective

Formalize the reusable converse theorem behind C809: for a symmetric zero-diagonal order-six matrix with nonzero off-diagonal entries, nonzero proportionality between the triangle cubic and the commutator-Pfaffian/third-compound cubic forces the quadratic relation $A^2=\lambda I$. Formalize the root-normalized scalar-sign specialization that detects the conference square and its oriented six-test recognition packet. Reduction of arbitrary sign matrices and uniqueness modulo switching and permutation were originally excluded; the 2026-08-03 author instruction to close every gap by strengthening the formal side brought both into scope, and both are now formalized.

## Required scope

1. Reuse rather than duplicate C763's existing ring-general forward bridge from a fixed conference matrix to the commutator-Pfaffian cubic.
2. Define the triangle coefficients and prove the pair-moment identity
   
   \[
   \sum_{k\ne i,j}\tau_{ijk}=a_{ij}(A^2)_{ij}.
   \]
3. Express translation invariance of the commutator cubic and derive vanishing pair moments from nonzero proportionality.
4. Prove that nonzero edges make $A^2$ diagonal and that commutation with $A$ makes its diagonal scalar.
5. On scalar sign matrices, prove the gauge-to-pentagon classification and the converse conference square without replacing the structural argument by a 1,024-case table.
6. Formalize that five first-row balance equations plus one oriented coefficient select the labelled oriented codes. One audited finite classifier may discharge this exact labelled fibre only after the conference square and pentagon degree statement have been proved symbolically.
7. State the exact boundary: the rank-14 local weighted rigidity calculation remains an exact external certificate unless a clean existing rational-rank interface makes formalization essentially free. **Superseded 2026-08-05:** it is no longer a certificate at all. The equivariant reduction proves the rank structurally, leaving a displayed eight-by-five integer table and the ordinary constant-rank theorem; report `notes/2026-08-05-c815-rank-14-weighted-jacobian.md`. A Lean statement of the reduced linear algebra is now cheap but is not required by the gap inventory and is not yet written.

## Coordination boundary

C815 owns the new converse/recognition declarations. C800 owns the pre-existing general operator identities and final shared-manifest reconciliation; C799 owns aligned-design reconstruction. Before any Lean operation, follow `lean/AGENTS.md`, inspect the current shared package, and avoid overlapping edits with an active owner. If C800 has not yet merged manifests, land C815 as a separately gated module with an explicit handoff rather than silently taking C800's release surface.

## Acceptance

- The universal coefficient bridge used by the converse is either reused from C763 or proved once at the correct abstraction level.
- The general nonzero-edge quadratic implication, normalized scalar-sign conference-square characterization, and six-test oriented recognition theorem are kernel-checked.
- The guarded focused gate, axiom audit, hash manifest, and paper-local replay surface pass.
- Every theorem is mapped to C809's human statement and the local weighted Jacobian boundary is stated exactly.
- No manuscript prose or public release is changed; C816 owns promotion.

Acceptance has not fully passed.  The repair checklist is recorded in
`notes/2026-08-02-paper-iii-lean-audit-checklist.md`; the final declaration
map, trust boundary, replay surface, and closeout ledger belong in
`notes/2026-08-02-c815-four-shadow-lean-formalization.md` only after terminal
validation.

The formalization itself is now kernel-checked: the module elaborates without
errors or warnings, the focused gate builds through the guarded queue, its
`#print axioms` output matches the tracked report, and the paper-local replay
passes in both modes.  Validation also found that the `x₀x₁x₂` coefficient of
the commutator-Pfaffian cubic carried the wrong sign, which had made both
orientation predicates select the opposite six-code fibre; the corrected
classification is confirmed by an exact independent recomputation committed
with the report.

## OPER-3 ownership (2026-08-06)

The whole of ledger row OPER-3 is C815's, including the eigenvalue and
singular-value statements: one row has one owner, so that no piece of it can be
left for a task that does not know it holds it. Its three remaining pieces were
the support-sorted closed-four-walk count, the swap-descent form of the
inclusion-rank input, and the spectral statements resting on
`B * Bᵀ = q • 1 - A * A`. The row carries no partial-coverage carve-out; see
the lane handoff's **Formal standard for the whole series**. If the spectral
half proves large it takes a newly allocated task of its own rather than moving
into C823, whose scope is the distance, parity, moment and compression row
family.

The first two are closed. The support-sorted fourth trace, the twenty-four
traversals of a four-set's three Hamilton cycles, the `24`-or-`-8` weight
dichotomy, and the swap descent forcing the four-set weight constant when the
balanced-half sums agree are in
`RelativeConicArcs.ConferenceCutBlocks` and
`RelativeConicArcs.SubsetInclusionSums`; report
`notes/2026-08-06-c815-fourth-trace-and-swap-descent.md`. What is left in the
row is the spectral half and the assembly of the exchange-rigidity
contradiction, whose inputs are now all formalized.

The spectral half is scoped in
`notes/2026-08-06-c815-exchange-spectrum-scope.md`. It needs no new task ID: the
compression to the positive eigenspace is a two-sided characteristic-polynomial
argument rather than a singular-value decomposition, the two exchange moments do
not pass through the spectrum at all, and `√q` enters only as a hypothesis
`s * s = q`, so the load-bearing statements stay ring-general in the style of
`ConferenceCutBlocks`. One new module of roughly the size of the fourth-trace
round covers it, with the eigenvalue phrasing and the existence of the isometry
as the only analytic items. One reading question for the author is recorded
there: whether the manuscript's "unique nontrivial realized order" sentence
ranges only over the small orders, which is cheap, or over all orders, which
pulls in the classical order-`≡ 2 (mod 4)` theorem.

That scope is formalized in `RelativeConicArcs.BalancedExchangeSpectrum` and on
the golden-return gate.  The exchange operator of a balanced cut has the
characteristic polynomial and every power trace of `1 - q⁻¹ • (A * A)`, its
first two moments are `d² / q` and
`(d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c)/q²` for `c` the
number of aligned four-sets of the half, that count is not the same for every
balanced half once `4 ≤ d`, and for a half of at most three labels the
characteristic polynomial is independent of the half, being
`(X - 1/5)(X - 4/5)²` at order six.  No eigenvalue, singular value, or
square-root operation appears.  Reports:
`notes/2026-08-06-c815-exchange-spectrum-lean.md` and
`notes/2026-08-06-c815-exchange-second-moment-and-small-orders.md`.

The author's reading question is settled in the cheap direction without needing
the classical congruence theorem: the same fourth-trace count proves that no
symmetric matrix with zero diagonal and entries squaring to one on four labels
has a scalar square, so order six is the only order above two at which a
cut-independent exchange spectrum is realized.

The two analytic items are closed over the reals in
`RelativeConicArcs.BalancedExchangeEigenvalues`: the characteristic polynomial
of `1 - q⁻¹ • (A * A)` is the product of `X - (1 - αᵢ²/q)` over the eigenvalues
of the block, and both spectral isometries exist, so the spectral formula, the
second moment and the order-six spectrum hold with the isometry existentially
quantified.  Report:
`notes/2026-08-06-c815-exchange-eigenvalues-and-isometries.md`.

The final transport across `Equiv.sumCompl` is closed in
`RelativeConicArcs.BalancedExchangeHalfCut`: it identifies the principal block,
fourth trace, aligned four-subsets, second exchange moment, and order-six
spectrum for a half of a single label set.  Row OPER-3 is complete.

## OPER-4 closure (2026-08-07)

Row OPER-4 is closed.  The determinant-minus-three family of a Seidel matrix is
identified with the aligned family of its two-graph, and the principal
four-by-four minor on distinct labels is shown to take only the values `-3` and
`5`, in `RelativeConicArcs.SeidelPrincipalMinors`; the same module recovers the
signing up to diagonal switching and one global sign.  The counted query family
of a single anchor is proved sufficient in
`RelativeConicArcs.AlignedQueryFaithfulness`, whose anchor hypothesis is
discharged unconditionally on seven points by `exists_distinct_alignedAnchor`.
The passages gate audits sixty-five terminals with no compiled-evaluation
axiom, all paper-local replays and the full release gate pass, and the trust
manifest, formal map and verification section were brought into step.  Report:
`notes/2026-08-07-c815-oper4-determinant-and-query-closure.md`.

## OPER-1 and OPER-2 closure (2026-08-07)

Both rows are closed.  The coherence of the outer six-family and the
coefficientwise coloured-triangle identification are
`RelativeConicArcs.ClebschOuterJoubertFrame`; the identification of the six
coordinates with the one-factorizations of the complete graph on six labels,
including that there are exactly six such colourings, is
`RelativeConicArcs.ClebschOuterMatchingFrame`; the diagonal section and the
Segre--Igusa polar map are `RelativeConicArcs.SegreIgusaPolar`, with the Igusa
quartic proved through the characteristic polynomial and Newton's identities;
and the cross-golden determinant comparison is
`RelativeConicArcs.CrossGoldenDeterminant`, giving `Z² = 500 det (B - Bᵀ)` and
the exact `Z = 10 s Pf (B - Bᵀ)`.  A cold referee accepted the arc with repairs,
all applied; the review is
`notes/2026-08-07-c815-oper1-oper2-referee-review.md`.
The golden-return gate audits one hundred and twenty-three terminals with no
compiled-evaluation axiom, and all paper-local replays and the release gate pass
except the pre-existing tracked-PDF comparison.  One manuscript defect surfaced:
row `r = 2` of the displayed table (5.1) has its last six signs negated, which
violates both the four-point two-graph identity and the paper's own first Segre
relation; the correction is queued for C816.  Report:
`notes/2026-08-07-c815-oper1-oper2-algebraic-closure.md`.

What remains for C815 is the geometric part of gap class B: ARITH-1, ARITH-2,
ORIENT-1, HARM-1 and HARM-2.

## Harmonic rows HARM-1 and HARM-2 (2026-08-07)

The route is chosen and scoped in
`notes/2026-08-07-c815-harmonic-realization-scope.md`, whose exact-arithmetic
certificate is `notes/2026-08-07-c815-harmonic-realization-checks.py` with output
`.json` and hashes `.sha256`.  It replaces spherical harmonic analysis by
algebra: the normalized spherical average is introduced as an explicitly defined
moment functional, its orthogonal invariance follows from the integration-by-parts
recursion together with uniqueness, and the addition theorem becomes the apolar
identity `N(Z_u Z_v) = 10395 P₆(u·v)`.  One classical statement stays outside the
route and is deliberately isolated in a module of its own: that the defined
functional is the surface integral.

Five of the seven planned modules are landed and elaborate without errors or
warnings.  `RelativeConicArcs.IcosahedralFaceAxes` carries the labelled ten-axis
configuration over `ℤ√5` and transports it along a chosen square root of five to
any commutative ring: every axis has the same length and the square of the inner
product of two distinct axes takes one value on disjoint label pairs and another
on meeting ones, which is the geometric content of the labelling and fixes the
two orbit values of the degree-six kernel.  It also carries three explicit
rotations that permute the ten axes and their induced label permutations.
`RelativeConicArcs.AlternatingComparisonLine` carries the abstract comparison:
two-transitivity of the alternating group on five letters by explicit
construction, the commutant of the coordinate module, the resulting scalar action
on the sum-zero submodule, the comparison theorem identifying every equivariant
comparison with a multiple of the pair-sum map, and the normalization forcing the
scalar's cube to be one and hence the scalar to be one over an ordered field.

`RelativeConicArcs.SphericalMomentFunctional` carries the moment functional
itself: the monomial definition, the integration-by-parts recursion
`N(xᵢ p) = N(∂ᵢ p)`, the uniqueness that recursion and `N(1) = 1` force,
orthogonal invariance read off that uniqueness, the sphere relation
`N((x·x) p) = (d + 3) N(p)`, and the two apolar clauses for a harmonic `p` of
degree `d` — vanishing against any form of degree below `d`, and
`N(p (w·x)^d) = d! p(w)` — by one induction out of Euler's identity.
`RelativeConicArcs.ZonalHarmonicDegreeSix` carries the degree-six zonal form,
its homogeneity, its value `P₆(u·v)` at a unit vector, its harmonicity for a
unit axis, and the addition theorem `N(Z_u Z_v) = 10395 P₆(u·v)` with normalized
form `M(Z_u Z_v) = P₆(u·v)/13`.  Neither the general apolar identity nor any
apolar differential operator is defined; the manuscript's proof consumes only the
two clauses.  Report:
`notes/2026-08-07-c815-harmonic-moment-and-apolarity.md`.

`RelativeConicArcs.FaceAxisHarmonicGram` carries the Gram half.  Realizing the
labelled axes over the reals and rescaling them to unit length, the normalized
mean of a product of two face-axis zonal forms is
`(196 I + 47 J - 112 A)/3159`, whose three entries are `1/13`, `-65/3159` and
`47/3159` at the squared axis inner products `1`, `5/9` and `1/9`; only the
squares enter, so the sign of a chosen axis representative never has to be
determined.  The Petersen eigenvalues `3`, `-2` and `1` then give the Gram
scalars `110/1053`, `140/1053` and `28/1053`, each stated as an eigenvector
equation from hypotheses on the coefficient vector alone.  On the `(-2)`
eigenspace, where the manuscript claims injectivity, the Gram form is the
positive scalar `140/1053` times the squared norm of the coefficient vector, so
injectivity needs no spectral decomposition of the ten-dimensional space.
Pair-sum tightness `∑_p (y_i + y_j)² = 3 ∑_i y_i²` on sum-zero weights turns that
scalar into the manuscript's quadratic identity `M(F_y²) = (140/351) ∑ y_i²`,
with the marked value `2800/351`.  Report:
`notes/2026-08-07-c815-face-axis-zonal-gram.md`.

Still open in the two rows: the spherical cubic restriction, and the
measure-theoretic identification named above.  The three assertions of the
manuscript section that no inventory row covers are owned by C884.  None of the
five modules is on a gate yet.

The first cubic-restriction risk gate is green.  The new module
`RelativeConicArcs.SphericalCubicRestriction` directly expands the fifty-five
monomials of the even tetrahedral harmonic's cube and proves
`normalizedMean_tetrahedralEvenHarmonic_cube`, with value `-1280/46189`, under
the default guarded elaboration profile.  The squared-coordinate fallback in
the design note is not needed.

## Audited remaining gaps (2026-08-08)

The complete landed-work audit is
`notes/2026-08-08-c815-complete-landed-work-audit.md`.  C815 remains open for
the following task-owned obligations, in execution order:

1. **HARM-2, spherical cubic restriction.**  Complete
   `RelativeConicArcs.SphericalCubicRestriction`: define the transposition-odd
   tetrahedral harmonic, prove the second surviving degree-eighteen moment and
   the two symmetry vanishings, identify the marked zonal field with its
   odd/even split, prove rotation covariance and the explicit permutation-word
   orbit reduction, collapse the invariant cubic on sum-zero weights to
   `sigmaThree`, and derive the marked and rational corollaries.  The first risk
   gate is already green: direct normalization proves the even cube moment
   `-1280/46189` without a special squared-coordinate evaluator.  The second
   surviving moment is now also proved,
   `M(Hodd² Heven) = -1024/969969`, and the first-coordinate transposition
   proves `M(Hodd³) = M(Hodd Heven²) = 0` symbolically.  What remains in this
   item is the structure-coefficient orbit reduction, sum-zero collapse, and the rational
   general-weight corollary.  The marked odd/even combination is now assembled for
   either square root of five, and its cubic mean is proved to be the rational
   value `-15680000/1247103`.  It is also identified coefficientwise with the
   actual ten-axis zonal combination at `stabilizerFixedVertexWeight`, so the
   marked value now holds for the geometric field itself.
   The three integral golden rotations are transported to real orthogonal
   matrices, substitution by each one is proved to relabel the full ten-axis
   zonal combination by its displayed five-label permutation, and
   `faceAxisCubic_comp_faceAxisLabelPermutation` gives the resulting cubic
   invariance.
   Invariance is extended to arbitrary generator words.  Five explicit root
   movers and twelve explicit words in the root stabilizer are kernel-checked;
   reversing them with the displayed generator inverses produces
   `tripleTransportWord`, which carries any ordered triple of distinct labels to
   any other.  Thus the needed three-transitivity is proved without subgroup
   closure or an alternating-group computation.
   A continuation audit on 2026-08-08 found that the post-audit spherical-cubic
   commits had not in fact landed in an elaborating state: they contained an
   invalid binder glyph, an incorrect `Equiv.ofInjective` construction, reversed
   word composition, and several untested `decide`/polynomial proof blocks.
   Those defects are repaired.  The guarded module now elaborates with no errors,
   warnings, `sorry`, or `admit`.  The repair also replaces the thirty-case
   covariance table by a permutation of `Pair 5`, derives axis transport from the
   landed scaled-rotation theorem, and factors the marked calculation through
   weighted axis-power tensors before expanding.  The remaining HARM-2 work is
   now exactly coefficient symmetry, the three index-pattern orbits, the
   sum-zero `sigmaThree` collapse, and the general rational corollary.

   **Paused worktree handoff (2026-08-09).**  The uncommitted continuation in
   `lean/RelativeConicArcs/SphericalCubicRestriction.lean` is preserved as Git
   stash commit `30679dc4d99eb785ceaddd002659b9b651766898`, with subject
   `C815 pause SphericalCubicRestriction`.  Resume it with
   `git stash apply 30679dc4d99eb785ceaddd002659b9b651766898`; after validating
   and committing the recovered file, drop that stash explicitly.
2. **HARM-1/HARM-2 analytic bridge.**  Add
   `RelativeConicArcs.SphereIntegralMoments`, proving that the explicitly
   defined `normalizedMean` agrees with normalized surface integration.  This
   is the only measure-theoretic module in the harmonic packet.
3. **ARITH-1.**  Formalize the trace-split rank-one reflexive Stein algebra with
   multiplication `z² = 5J0`, together with the chart-descent comparison used by
   the manuscript.
4. **ARITH-2.**  Formalize the complete reduced local fibre as the residue
   algebra of the quadratic pinching at `xyz`, and replace the displayed
   spinor-norm witness by the general definition-level API the manuscript uses.
5. **ORIENT-1.**  Formalize the two-component normalization of the incidence
   pullback relative to the complete ordered golden, plane-triple, Petersen and
   chart-lift datum, including the marked geometric identification.
6. **Weighted-Jacobian promotion bridge.**  Kernel-check the reduced
   eight-by-five rank calculation and its equivariant bridge to the
   twenty-by-fifteen weighted Jacobian.  The structural human proof is sound,
   but C816 cannot promote its local weighted-rigidity assertion under the
   series-wide formal standard until this declaration exists.
7. **C815 closeout.**  Attach the seven harmonic modules and all remaining
   terminals to the appropriate Paper III gate, regenerate the source closure,
   axiom report and formal maps, replay the three gates and release verifier,
   run `ej` and `tt`, and freeze the API for C823.

Two adjacent obligations are explicitly not C815 gaps.  C884 owns the
covariant obstruction, Gaunt/Wigner interpretation and Condon--Shortley input
before C816 promotes the harmonic section.  C800 owns the single coordinated
replacement of the formal maps' hard-coded all-row `partial` coverage tokens
after C815 and C823 freeze their shared sources.

## Evidence source

Human theorem and exact certificate: `notes/2026-08-02-c809-four-shadow-characterization.md` and its adjacent `.py`/`.json` bundle.

## Complete landed-work audit (2026-08-08)

The full landed C815 surface and the remaining plan were re-audited in
`notes/2026-08-08-c815-complete-landed-work-audit.md`.  All mathematics,
certificates, elaborations, gates and the paper-local release replay pass after
repairing public docstrings and stale live-plan prose.  Before C815 freezes its
API it must also kernel-check the reduced weighted-Jacobian rank argument, so
C816 can promote that claim without creating a human-only manuscript assertion.
