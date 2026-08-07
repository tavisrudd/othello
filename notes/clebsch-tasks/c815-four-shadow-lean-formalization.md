# C815 — Lean formalization of four-shadow recognition

**Lane:** `clebsch`  
**Status:** reopened after formal audit; the three Paper III gates, their axiom
reports, manifests, and all paper-local replays are green with no
compiled-evaluation axiom at any terminal, the documentation and gate-replay
obligations of the audit checklist are closed, the recognition theorem is
transported off the root gauge and the conference switching class is proved
unique, the aligned-design strengths are formalized at the manuscript's quantifier
range, the rank-14 weighted Jacobian now has a structural proof, and the
remaining work is gap class B before the API is handed to C823

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
- Every theorem is mapped to C809's human statement and the local weighted Jacobian boundary remains honest.
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

Left in the row: the transport of the cut-dependence statement from the aligned
count of a half to the exchange operator of the cut that half defines, across
`Equiv.sumCompl`.  It is mechanical — the fourth trace of a principal block as a
sum over the half, and a bijection between the four-subsets of the half and
those of the block's label set — and unstarted.

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
`RelativeConicArcs.CrossGoldenDeterminant`, giving
`Z² = 500 det (B - Bᵀ) = (10 s Pf (B - Bᵀ))²` and the signed form over a domain.
The golden-return gate audits one hundred and nineteen terminals with no
compiled-evaluation axiom, and all paper-local replays and the release gate pass
except the pre-existing tracked-PDF comparison.  One manuscript defect surfaced:
row `r = 2` of the displayed table (5.1) has its last six signs negated, which
violates both the four-point two-graph identity and the paper's own first Segre
relation; the correction is queued for C816.  Report:
`notes/2026-08-07-c815-oper1-oper2-algebraic-closure.md`.

What remains for C815 is the geometric part of gap class B: ARITH-1, ARITH-2,
ORIENT-1, HARM-1 and HARM-2.

## Evidence source

Human theorem and exact certificate: `notes/2026-08-02-c809-four-shadow-characterization.md` and its adjacent `.py`/`.json` bundle.
