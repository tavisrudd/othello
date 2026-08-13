# Clebsch: Rigidity from Sparse Shadows

**Lane:** `clebsch`

**Date:** 2026-08-09

> **LIVE MAP ONLY.** This is the routing and state surface for the active
> five-paper numbered series. Detailed live task internals belong in C-task cards;
> completed and superseded detail belongs in the archives linked below.
>
> **ROUTING AUTHORITY.** No dated planning note, fallback-paper verdict, task
> report, or archive overrides the order and boundaries stated here.

## Formal standard for the whole series

Every numbered paper meets the same Lean standard. Paper III is held to exactly
what Papers I and II are held to, with no per-paper exception and no clause
exempted for being classical, cited, or expensive:

- no `sorry` anywhere in a paper's closure;
- no `native_decide` and no compiled-evaluation axiom at any terminal, checked
  by replays that refuse it rather than declared as a boundary;
- no project axiom and no assumed hypothesis standing in for a proof, the way
  the Dye inputs once stood in for Paper I's order-eleven classification;
- every mathematical assertion of the manuscript maps to a kernel-checked
  declaration, so no ledger row may sit permanently at partial coverage.

A manuscript step whose proof is a literature citation is not outside this
standard. It is closed by proving the statement in the form the manuscript uses
it, in whatever weaker form suffices, rather than by importing the cited theorem
in full generality. Gaps are closed by strengthening the Lean side; no
manuscript claim is narrowed to make the formal surface agree with it.

## Numbered series decision

The public series is *Clebsch: Rigidity from Sparse Shadows* and has exactly
five numbered papers:

1. Paper I — `clebsch-rigidity`;
2. Paper II — `clebsch-factorization`;
3. Paper III — alias `passages`, rooted at `clebsch-passages`;
4. Paper IV — alias `q13-passant-code`, rooted at `q13-passant-code`;
5. Paper V — the culminating recognition and marked-round-trip paper, now
   active under C904; title and manuscript root are its first freeze.

The cross-series reconstruction-profile task C905 is closed in
`../2026-08-10-c905-reconstruction-profile-theorem.md`.  Its research-only
exceptional-tower successor C906 is also closed in
`../2026-08-10-c906-exceptional-tower-judo.md`: the unmarked fold/tower is
classical, while the surviving theorem is an exact sparse marked entry through
the `E_6` carrier, reversible only with a residue flag, with bottom fibres
`432/864/1728` and exact higher residue multipliers.  That composition and its
arithmetic-lift frontier remain literature-gated and were not promoted to any
manuscript or Lean source.

The research-only C907 quantum route is active.  Its v1 theorem is now
unconditional: framed formal monodromy of the numerical small quantum
connection, followed stepwise through Iritani's blow-up comparison, proves
that `X x P^1` is irrational for every smooth cubic threefold.  The proof
does not use the retired atomwise HLT-descent claim.  The warning-free
manuscript is `papers/cubic-stabilization-epilogue/`; exact proof and source
audit: `../2026-08-11-c907-v1-framed-fractional-support.md`.

Full stability is open from `m=2`.  C909 proves that ordinary atoms are too
coarse and reduces the target to a strict cubic-isotypic Stokes/Rees/Gamma
grading.  The endpoint has `1+L+L^2`; the exact positive
Krull--Schmidt telescope only needs to exclude that endpoint `J_3` from all
threefold centers, and the clean numerical sufficient bound is length at most
two.  Thus the landed length-two formal countermodel is harmless.  In the toric pilot `Bl_(P^3)P^5`, the residual chart is exactly
`W_(P^3)+ZU`.  Saturated tangent-Jacobian certificates cover the residual
chart, a mixed-cone family, and the compact-`y` pole continuum through one
semistable incidence node.  Six hashed 31-mask replays plus two Laurent
circuit lemmas now close ten boundary-star types for arbitrary toric `y`
valuations; the translated seam incidence closure retains the four marked
residual points.  Positive pole order by itself is only a prefilter: total
normalization can recreate `L`-critical points.  The bounded `1/1` Rees chart
is closed separately: its noncompact `y` faces are empty/free and its compact
face is exactly the four residual Morse points.  The zero/infinity and two
translated/infinity seams are now empty/free (the latter over a residual
value disk in `C*`), and the full
double-translated `B=C=1` chart closes every joint support valuation:
positive-order restrictions are empty/free, while the product-zero order-zero
restriction is four residue-torus families and must not be a control stratum.
The bounded core alone contains the four marked residual points.  The formerly implicit zero/infinity and
generic/generic types are also closed, giving an exhaustive table of all ten
unordered coordinate-orbit types.  This makes the support atlas complete, not
the control-stratum ledger.  The global graph is now an explicit
multihomogeneous Cartier closure; on a regular modification its strict
transforms glue up to units.  The imbalanced coordinate `v` must stay interior,
where its unit derivative proves freeness.  An ordinary
fan in the original `(B,C)` torus cannot include the
translated divisors `B=1,C=1`; the common finite support object is instead the
product of two marked-line tropical tripods refined by six universal graph
weights.  The live analytic gate is the corresponding pair-of-pants/log
modification with separate algebraic-chart and coarser actual-boundary/control
Fitting ledgers.  That gate is now closed by a different mechanism: a direct
proper tropical exterior model has 70 logarithmic unit fields and two empty
`L=0` masks, the simultaneous ratio graph controls its entire fibre over the
double-marked locus away from the four Morse sections, and multi-model proper
pushforward localizes the intrinsic nearby value cycles to those four
sections.  Conditional only on the actual local `j_!` Morse identification,
the nearby compact-support thimble group is free of rank four.  A common fan
and Whitney collar are unnecessary.  The remaining order-zero gate is the
oriented `j_! -> Rj_*`, duality, `can/var`, and no-braid comparison that fixes
the directed `P^3` Seifert form, followed by the hyperplane-equivariant
integral Orlov/Rees comparison.
The first residual jet is
`-H^2` modulo coordinate gauge, conditionally internally isomonodromic.  The
direct threefold grading argument is closed negatively by an explicit
self-dual length-two model, but Silver no longer needs its first extension to
vanish.  The carrier gate is absence of an endpoint-type second composite for
arbitrary non-nef threefolds.  At a conic node the raw Clifford socle is only
an ordered two-branch product—every single radical action is square-zero—and
clean primitive stalk/costalk excision kills it conditionally.  At a nodal
cubic-surface fibre the stationary lattice is `A_5`, not `D_5`; equisingular
Weyl symmetry reduces the dangerous second composite to one explicit
`S_6`-module multiplicity test, but strict Stokes/Gamma descent is still open.
Every
ordinary Fano complete-intersection threefold has small-even `nu_6<=2`, so
none can realize the required length-two carrier.  Fano cyclic covers of
`P^3` also have `nu_6<=2`; the weighted degree-one del Pezzo is a non-CI
positive calibration with `nu_6=2`, not a length-two carrier.  The natural
weighted `(3,3)` candidate never gives two independent pairs: its smooth Fano
members reduce to the cubic or `P^3`.  The first raw four-packet `(3,6)` model
is non-quasismooth.  More generally, smooth coarse geometry forces the
inertia--cyclotomic inequalities for every strongly well-formed weighted
complete intersection; these cancel its factorial operator to self-dual rank
four.  Wang's published all-CI nonconvex mirror theorem supplies the full
ordinary small-even QDM bridge even for non-Cartier degrees.  Thus every such
rank-one weighted Fano CI has `nu_6<=2`.  The first non-WCI test $V_5$ is
stronger: its exact small-even framed support has `nu_6=0`; a provisional
genus-six (V_{10}) calculation also gives zero but is not yet promoted.
Prime Fanos of genera seven, nine, and ten are rational over `C` and hence
also have `nu_6=0`; genus six is the sole remaining direct prime-Fano operator
row.  Remaining universal carrier candidates lie
outside weighted CIs or outside the strong-WF ordinary sector, and weak
factorization still permits arbitrary non-Fano/non-nef centers.  Current
card: `../clebsch-tasks/c907-quantum-monodromy-stabilization.md`; plan:
`../2026-08-11-c907-moonshot-attack-plan.md`.  No Paper V or Lean promotion is
authorized.

The strict cycle-side C909 crown is now substantially stronger than the
epilogue's cofactor lemma.  Projective finite-etale spectral packets give
full ordinary cohomological saturation of the prescribed graph divisor
lattice in every degree, intrinsically on the marked self-dual elliptic-power
gluing presentation; this is full `PD(NS)` at non-CM points.  For every fixed
dimension and odd prime there are compatible unbounded-level, pairwise
nonisomorphic, polarized-indecomposable modular Hecke towers with this
property.  Their ambient integral Hodge lattice is nevertheless larger:
the exact codimension-two quotient is
`(Z/p^a)^(C(g,4))`, and codimension three is
`(Z/p^a)^(5C(g,5)+3C(g,6)) + (Z/p^(2a))^(C(g,6))`.
Primitive doubled-slot embeddings extend these formulas to every degree with
`min(k,g-k)<=3`, hence give the full graded classification through dimension
seven.  Dimension eight in middle degree is the first open case.  Exact data
through squarefree semilength six support a Dyck-height Smith formula, but it
is quarantined behind an original nested-unit-minor theorem for the filtered
web jet matrix; first-return and ordinary confluent-Vandermonde shortcuts do
not prove it.  Current card: `../clebsch-tasks/c909-epilogue-math-level-ups.md`.
The cubic unity gate is now closed on the smooth `A_5` line: subgroup norms
construct the actual relative six-axis isogeny, and the general Prym-axis
index formula forces the degree-five VGY quotient Prym to equal the primitive
`D_5` axis.  Functoriality of the exotic `P^1(F4)` packet identifies
`r^2=T`, `r=+/-9t` with the actual two-primary kernel marking.  Thus the
signed pencil is a presentation curve in the minimal sign-marked fixed-data
modular stack.  The next geometric frontier is classification of other
shared modular/cubic presentation curves; horizontal Chow remains C908.
No C907, C908, Chow, manuscript, PDF, mirror, or Lean promotion follows
automatically.

C910 owns the referee-facing Lean companion for the epilogue.  Its sole source
authority is the Mathlib-only package
`papers/cubic-stabilization-epilogue/lean/`, exported with the paper repository
under the C879 paper-facing public namespace
`TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue`, with reviewer entry
point `PaperInterface` and machine audit `Verification/AxiomAudit`; there is no
duplicate in the shared `lean/TavisRuddFiniteGeom/` tree and no second Lean
repository.  The task requires
the same source-prose, no-sorry/no-project-axiom, semantic-gate, exact-terminal,
axiom-audit, deterministic-build, stale-artifact, and manuscript-claim coverage
checks as the existing referee artifacts.  External geometry and quantum inputs
must remain visible in theorem types until proved, and conditional deductions
must not be reported as unconditional manuscript coverage.  Current card:
`../clebsch-tasks/c910-cubic-stabilization-lean-companion.md`.
The pinned package has reached a stronger publishable partial checkpoint: all
51 sources build through the guarded queue, and the rejecting audit gives an
exact bijection among all 23 manuscript claims, 96 reviewer terminals, audit
commands, and expected axiom rows.  Coverage is explicitly 0 absent, 13
fragmentary, 9 conditional deductions, and 1 complete.  The DVR rank-one
criterion is complete.  Exact fragments include flattened split-coordinate
graph lattices, invertible extension-ring basis transport between distinct
base and split axes, derivation of weighted membership from base symmetry and
formal graph-descent blocks, faithful-flat ordinary-product descent, the six-axis Smith and
local-block arithmetic, the characteristic-two slope model through scalar
extension and repeated-root diagonalization, and the exact implication from a
`{1,-1}` monodromy spectrum to primitive-sixth vanishing.  The exact fibrewise
deduction from supplied primitive-minimal-class algebraicity and Voisin's
supplied criterion to universal `CH₀`-triviality is now conditional Lean.
The separation-family headline's four conclusions are now one conditional
composition with its projective-bundle, packet, and period-map inputs exposed.
The relative-six-axis row is now an explicit fragment: an opaque organizational
signature records all named geometric assertions, while Lean independently
proves the complete integral Smith witness with two-sided inverse operations.
Low-dimensional primitive-sixth vanishing is now an exact conditional
deduction: Lean performs the classification induction through nef seeds,
points, arbitrary projective-bundle presentations, and point blowups, then
transfers intrinsic vanishing to every supplied strictly Novikov-admissible
specialization.  The full geometric and quantum inputs remain explicit.
The framed projective-bundle and blowup formulas are now exact conditional
deductions from supplied characteristic-polynomial block comparisons, including
the precise intrinsic endpoints and `c-1` specialized center summands.
The cubic packet is now an exact conditional deduction from Cai's supplied
four-factor framed characteristic polynomial: Lean proves both primitive roots
have multiplicity one and the two unit factors contribute zero.  Cai's geometric
block comparison and the numerical-Novikov bridge remain explicit inputs.
Divisor-tagging vanishing is now an exact conditional endpoint deduction from
two supplied final characteristic-polynomial equalities over `ℂ`; Lean
derives equality of primitive-sixth multiplicities and transfers intrinsic
vanishing to every strictly admissible specialization.  The source coefficient
fields, scalar-extension maps, common comparison field, completed-series
injection, and bulk-gauge witness are explicitly not represented.
The finite exponential-character substep is now independently proved: finite
root avoidance constructs the manuscript's integral one-parameter direction,
and the first `m` coefficients give the Vandermonde independence of `m` tagged
characters.  The completed-series lowest-support/associated-graded passage
was the next seam; Lean now proves existence, finiteness, and exact membership
of the lowest support and noncancellation for arbitrary nonzero leading
coefficients.  Identification of the geometric specialized initial form with
that combination remains outside the formal result.
An exact conditional detector bridge now proves nonvanishing and full
injectivity of the additive tagged map from proxy detectors, nonzero monomial
initial coefficients, and the compatibility equality.  The actual filtered
target, associated graded ring, valuation, specialization, and proof that they
produce those proxy inputs remain unrepresented.
The aggregate build, source correspondence, and 96-terminal axiom transcript
are green, and the committed standalone export verifies byte-for-byte.  The next formal gates are
the finite-etale splitting/eigenbasis and proof that geometric divisor descent
supplies the formal block conditions, then the actual six-axis kernel/persistence
bridge, cohomological realization and Voisin/relative geometry, then the
analytic and geometric construction of the supplied tagging comparisons,
low-dimensional spectral input, and full cubic-packet
geometry.  Initial interim release report:
`../2026-08-12-c910-partial-lean-release.md`.

The 2026-08-12 crown-compression pass adds two exact structural conclusions.
First, in dimension five the full one-depth finite-etale ambient
Hodge/product quotient is certificate-free and complete in every degree:
`(Z/p^a)^5` in codimensions two and three and zero otherwise; multiplication
by theta gives the canonical complement isomorphism between the two nonzero
quotients. This is the finite-dimensional crown naturally matched to cubic
intermediate Jacobians, but it is a neighboring tower theorem rather than the
numerical quotient of the actual six-axis packet, whose local lattice is
`unit line + rank-four depth-one block`. Second, over characteristic zero the
arbitrary-width web-jet filtration is exactly the moving `sl_2` conformal-
block level filtration of Rimanyi--Varchenko; over the mixed-characteristic
DVR it is the full Hasse tail and has saturated source gradeds of the Dyck
ranks. This closes the conceptual/rank mystery but not yet the primitive
leading-jet/ambient-dilation seam needed for the all-rank Smith formula.
The immediate C909 frontier is therefore the actual six-axis four-slot
quotient; the higher-rank Dyck formula is a successor, not an epilogue gate.

The first direct audit of that quotient is now positive and sharper than
expected.  The actual local profile is a unit line plus a depth-one rank-four
block.  At two the latter has two repeated rank-two roots after unramified
splitting; at three it is scalar.  In each four-slot support a same-root
matching already realizes the minimal integral scale, so the Pluecker defect
vanishes.  Hence the generic non-CM six-axis intermediate Jacobian has
`Hdg^(2k)=P^k` in every degree at both bad primes (and trivially elsewhere).
Two independent hostile/priority audits now pass. Manuscript promotion is a
separate task; special fibres with extra Hodge tensors retain only the
established minimal-class conclusion.

Papers I--III have GitHub and DOI releases at versions 1 and 2. Those public
versions are immutable predecessors; later strengthening is by forward
version. Paper IV is the active new-paper build under C761.

`golden` remains a source-development lane and unnumbered companion rather than
Paper V. The MDS--CSS and Paper-I computational companions are likewise
unnumbered. The mega-paper remains an unpublished fallback only.

The numbered-paper streams are concurrent.  An explicit selector such as
`go clebsch paper I`, `go clebsch paper III`, `go clebsch paper IV`, or
`go clebsch paper V`
selects only that paper's stream; it does not pause, reorder, or absorb work
in the other papers.  An unqualified `go clebsch` with no carried task or
paper selection must ask which paper stream the user wants rather than
silently choosing among concurrent work.

### Deterministic Paper III route

`go clebsch paper III` means: take the first unfinished task in this exact
conflict-safe sequence:

1. C799 — freeze the shared aligned-design Lean API;
2. C815 — add four-shadow recognition Lean declarations without duplicating
   the aligned-design API;
3. C823 — add robustness, distance, moment, and C822 compression declarations
   on those two frozen APIs;
4. C800 — formalize the remaining operator identities and perform the single
   shared-source/manifest reconciliation after C799/C815/C823;
5. C816 — integrate the four-shadow characterization into the manuscript;
6. C824 — integrate robustness and the order-26 separator, then perform the
   final coordinated Paper III trust/release/synchronization pass.

Skip completed tasks, but do not bypass an unfinished predecessor.  This is
an execution serialization for shared Lean/manuscript/manifest ownership;
the underlying mathematics remains the two branches
`C809 -> C815 -> C816` and `C810/C812/C822 -> C823 -> C824`, both rooted in
C792/C799 and merged through C800.  No C832 router task is required: the live
handoff resolves the selector directly.  Paper I and Paper IV continue
concurrently under their own explicit selectors and task cards.

### Active C815 repair handoff

C815 is reopened under
`notes/2026-08-02-paper-iii-lean-audit-checklist.md`.  The Paper III replay
programs and their exact transitive-closure inventories are hardened and
committed: they no longer invoke Lean or Lake, require an explicit
`--source-only` or `--axiom-log` mode, pin their own bytes, and validate
main-versus-supplemental declaration ownership.

The proof authority `lean/RelativeConicArcs/FourShadowRecognition.lean` is
committed and green.  Its mixed-difference argument uses one monomial theorem,
a reducible twenty-term coefficient table, and a small label bridge; the
heartbeat and recursion overrides are gone, the twelve labelled cubic
identities are separate declarations, and the three native orientation checks
are replaced by one closed decidable classifier with symbolic projections.
The pentagon converse is now a genuine symbolic proof: three signs summing to
a sign have product the negative of that sum, and only six derived signs are
split, never the ten free edge signs.  The module elaborates without errors or
warnings, the focused gate builds and its `#print axioms` output matches the
tracked report, and the paper-local replay passes in both source-only and
axiom-log modes.  The single finite trust boundary is the declaration-local
axiom that compiled evaluation introduces for the classifier; the weighted
converse, pentagon gauge, and conference square do not depend on it.

Validation found and corrected a sign error: `shadowCoefficient012` computed
the determinant of the lower-left three-by-three block rather than the
`x₀x₁x₂` coefficient of the commutator-Pfaffian cubic it is documented to be,
so both orientation predicates named the opposite six-code fibre.  The
corrected classification agrees with an exact independent recomputation
committed as
`notes/2026-08-02-c815-normalized-signing-classification.py` and its output.

The 2026-08-04 gate-hardening round is reported in
`notes/2026-08-04-c815-paper-iii-gate-hardening-report.md`, which is the
current state map for Paper III's formal surface.  The three gates now audit
fifty, twenty-eight and nineteen terminals and none of them carries a
compiled-evaluation axiom: every terminal depends only on `propext`,
`Classical.choice` and `Quot.sound`, `native_decide` occurs nowhere in the
pinned closures, and all three replays refuse it;
the axiom reports and closure inventories are generated by committed tools from
a tracked build log rather than maintained by hand; and the source policy now
refuses every escape two cold referees could construct, including
`set_option debug.skipKernelTC`.  All six paper-local replays and the release
gate pass, the latter now replaying all three Lean gates.

The three manuscript corrections requested of the TeX owner are discharged:
`papers/clebsch-passages/sections/08-verification.tex` now records both Ramsey
bounds as kernel-checked while keeping distinctness, the seven-set extension
and label normalization as human steps, names three gates rather than one, and
needs no compiled-evaluation disclosure because no terminal carries such an
axiom.  The audit checklist
`notes/2026-08-02-paper-iii-lean-audit-checklist.md` is refreshed to that state
and carries a dated summary of what is still open.

The four-shadow half of gap class C is closed.  Diagonal switching multiplies
the commutator-Pfaffian cubic by the product of the six switching signs and
leaves the triangle cubic unchanged, so switching by the root row reduces an
arbitrary symmetric zero-diagonal matrix with entries `±1` to the normalized
family and carries nonzero proportionality and the conference square with it;
the recognition theorem now holds at the manuscript's quantifier range.  One
relabelling together with one fixed diagonal switching carries every such
matrix with square `5 • 1` onto the displayed conference matrix, which is the
uniqueness of the conference switching class.  The four-shadow gate audits
thirty-five terminals, none carrying a compiled-evaluation axiom, and the two
paper-local replays and the release gate pass.  Report:
`notes/2026-08-04-c815-switching-reduction.md`.

The aligned-design strengths are closed.  The manuscript's faithfulness theorem
now holds in Lean at its own quantifier range: for every two-graph on a finite
point set with at least seven points the aligned four-sets determine the
triangle values on distinct triples up to one global complement bit.  Rooting at
a point of an aligned four-set whose triangle bit is zero makes the anchor's six
edges vanish, which replaces the manuscript's two switching normalizations, so
the general transport, the seven-point distinctness obligation, and the
finite-set extension all fall out of one proof.  The selected query family is
also defined explicitly and counted at `3n^2 - 23n + 45`.  A cold referee review
accepted the formalization with prose fixes only, all applied.  Reports:
`notes/2026-08-04-c815-aligned-design-faithfulness.md` and
`notes/2026-08-04-c815-aligned-faithfulness-review.md`.

Row OPER-3 now has only its spectral half open.  The polynomial core landed
first: the cut identity `B * Bᵀ = q • 1 - A * A` for a cut of arbitrary size,
the trace of the square of a zero-diagonal sign matrix, and the four-set
Hamilton-cycle dichotomy `w ∈ {3, -1}`, with the order-three block identity and
the Ramsey input `R(3,3) = 6` already proved in earlier work.  Report:
`notes/2026-08-05-c815-cut-block-core.md`, whose pessimistic closing paragraph
the 2026-08-06 author instruction withdrew along with the row's
partial-coverage carve-out.

The two combinatorial pieces are now proved.  The fourth trace is sorted by the
support of the closed four-walks it counts, `tr(A⁴) = d(d-1) + 12·C(d,3)` plus
the four-element supports' weights, each of which is `24` or `-8` — eight times
the Hamilton-cycle weight, one traversal per starting point and direction — and
this needs only a zero diagonal with `A i j * A j i = 1`, not symmetry.  The
inclusion-rank input is proved in the form the manuscript uses and by the route
proposed for it: equal four-subset weight sums over all balanced halves of a
`2d`-element label set with `4 ≤ d` force the weight constant on four-sets, by
one-element swap descent on inclusion sums, in the standalone module
`RelativeConicArcs.SubsetInclusionSums`.  The inclusion-matrix rank formula of
Gottlieb and Jolliffe is therefore attribution, not a dependency.  The
golden-return gate audits forty-nine terminals with no compiled-evaluation
axiom, and all three paper-local replays pass.  Report:
`notes/2026-08-06-c815-fourth-trace-and-swap-descent.md`.

The row's conclusion is closed as well, and by a shorter argument than the
manuscript's.  Once the four-set weight is constant, applying the closed-walk
count to the whole matrix rather than to a half pins it: the diagonal of
`C * C = q • 1` gives `q = N - 1`, and comparing the two expressions for the
fourth trace forces `(N - 3)w = -3` in the manuscript's normalization, so
`w = 3` needs `N = 2` and `w = -1` needs `N = 6`.  Hence for every order `2d`
with `4 ≤ d` the fourth trace of the principal block depends on the balanced
half, which is the theorem's substantive direction.  The switching
normalization and `R(3,3) = 6` are not used, and the same equation identifies
the exceptional order rather than only excluding the others: at order six every
four-set carries weight `-1`, so that matrix has no aligned four-set.  The
declaration is
`RelativeConicArcs.BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq`; the
gate audits fifty-one terminals with no compiled-evaluation axiom.  The prose
argument and an exact proposed replacement for the manuscript paragraph are in
`notes/2026-08-06-c815-exchange-rigidity-simplification.md`, queued for C816,
which owns manuscript promotion.

What remains in the row is every eigenvalue and singular-value statement, and
with it the passage from the fourth trace of a principal block to the second
exchange moment.  That remainder is now scoped in
`notes/2026-08-06-c815-exchange-spectrum-scope.md` and stays in C815 rather than
taking a new task ID.  The scope removes the analytic content: the compression to
the positive eigenspace is a two-sided characteristic-polynomial argument, the
two exchange moments never pass through the spectrum, and the square root of the
order enters only as a hypothesis `s * s = q`, so the load-bearing statements
stay ring-general.  One new module carries it, with the eigenvalue phrasing and
the existence of the isometry as the only analytic items.

That module, `RelativeConicArcs.BalancedExchangeSpectrum`, is committed, is on
the golden-return gate, and carries the whole spectral half except its two
analytic items.  The exchange operator of a balanced cut has the characteristic
polynomial and every power trace of `1 - q⁻¹ • (A * A)`; its first moment is
`d² / q` and its second is
`(d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c)/q²`, where `c`
counts the aligned four-sets of the chosen half — the only summand that depends
on the half.  That count is not the same for every balanced half once `4 ≤ d`,
which is the failure clause, and when a half has at most three labels the
characteristic polynomial is computed outright and does not depend on the half:
the product of the three edge signs enters the block identity
`A * A = 2 • 1 + τ • A` but cancels, leaving `(X - 1/5)(X - 4/5)²` at order six.
The same fourth-trace count also excludes order four outright, so order six is
the only order above two at which a cut-independent spectrum is realized; this
settles, in the cheap direction, the reading question the scope had left for the
manuscript owner.  The two analytic items are closed as well, over the reals and in a module of
their own, `RelativeConicArcs.BalancedExchangeEigenvalues`.  The characteristic
polynomial of `1 - q⁻¹ • (A * A)` is the product of `X - (1 - αᵢ²/q)` over the
eigenvalues of the block, which is the manuscript's spectral formula; and both
spectral isometries exist, because a real symmetric involution has an
orthonormal eigenbasis with eigenvalues `±1` and a vanishing trace — supplied by
the vanishing diagonal — makes the two eigenspaces equally large, so each is
indexed by a half of the cut.  The spectral formula, the second moment and the
order-six spectrum therefore also hold with the isometry existentially
quantified, resting on no assumed hypothesis.  Reports:
`notes/2026-08-06-c815-exchange-spectrum-lean.md`,
`notes/2026-08-06-c815-exchange-second-moment-and-small-orders.md` and
`notes/2026-08-06-c815-exchange-eigenvalues-and-isometries.md`.

Row OPER-3 is now closed.  The last item was the transport across
`Equiv.sumCompl`, which turns a subset `Y` of a single label set into cut
coordinates: the relabelling that lists the labels of `Y` first has the
submatrix on `Y` as its principal block, symmetry makes the lower-left block the
transpose of the cross block, and the scalar square carries over because
relabelling along an equivalence is a ring map on matrices.  Two invariants of
that block are then read on `Y` itself — its fourth trace is the fourfold sum
over `Y`, and its aligned four-sets are the images of the aligned four-subsets
of `Y`, since the closed four-walk weight of a four-set is preserved by
relabelling along an injection.  The second exchange moment of the cut at a half
is therefore stated in the aligned count of that half, and for order `2d` with
`4 ≤ d` no real number is the second moment of every balanced half: the
dependence on the cut is now a statement about the exchange operator rather than
about a proxy invariant.  In the same language the exchange spectrum at a half
is the product of `X - (1 - αᵢ²/q)` over the eigenvalues of the submatrix on
that half, and at order six it is `(X - 1/5)(X - 4/5)²` for every three-element
subset, so the exceptional order and the failure above are statements of the
same shape.  The module is
`RelativeConicArcs.BalancedExchangeHalfCut`; the golden-return gate audits
eighty-three terminals with no compiled-evaluation axiom, all three paper-local
replays and the release gate pass, and the verification README no longer claims
that no eigenvalue statement is formalized.  Report:
`notes/2026-08-06-c815-half-cut-transport.md`.

A cold referee reviewed the whole 2026-08-06 arc and accepted it, with repairs
that were all on the documentation side; every one is now applied.  It read the
Lean statements against the prose, recomputed each load-bearing constant, and
replayed the mechanism numerically on the order-ten Paley conference matrix
across all balanced halves, finding the arithmetic and the trust boundary
sound.  The repairs: the OPER-3 row of `trust_manifest.json` was stale and now
names the formalized route; the verification README now says that the Ramsey
exclusion is a boundary of the manuscript's *printed* proof rather than a gap in
the formal conclusion, since the Lean closes the same statement by the swap
descent and the fourth-trace pin; two docstrings that let the second moment's
variation stand for the spectrum's now say which spectrum readings follow and
which statement is proved; the artifact now records that `4 ≤ d` is what the
swap descent needs and that existence at a given order is a separate question;
and the two public names that embedded the private `walkTerm` are renamed to
`sum_closedFourWalkWeight_eq_add_sum_powersetCard` and
`not_forall_sum_closedFourWalkWeight_eq`.  The review also corrected this lane's
reading of the missing witness: the *existence* of a pair of halves with
different second moments is a short corollary of the aligned-count theorem, and
only a *named* pair would need a finite computation; the manuscript needs
neither.  Review and repair status:
`notes/2026-08-07-c815-oper3-referee-review.md`.

Two further clauses of gap class B are closed.  The Segre equations of row OPER-2 are
proved directly: the six signed translates of the conference triangle cubic
under the reorderings fixing the first three labels sum to zero and their cubes
sum to zero, over any commutative ring, which is stronger than the manuscript's
citation of them as classical.  Report:
`notes/2026-08-05-c815-segre-relations.md`.

The determinant-square clause of gap class B row OPER-1 is closed.  The
determinant of an order-six skew-symmetric matrix with vanishing diagonal is
the square of its Pfaffian over any commutative ring, so the fixed conference
bracket matrix has determinant sixteen times the square of its triangle cubic;
the golden-return gate audits both terminals with no compiled-evaluation axiom
and all three Lean gates replay.  Report:
`notes/2026-08-05-c815-determinant-square.md`.  It also records that the
release gate's manuscript-build check now fails on the tracked PDF, which no
Paper III Lean work touches.

The rank-14 weighted Jacobian of gap class C is closed, and structurally rather
than by certificate.  The Jacobian of the twenty equality equations at either
oriented golden representative is equivariant for that matrix's order-sixty
stabilizer, which is the alternating group of degree five, so its kernel is a
submodule; every irreducible constituent of such a module has a vector fixed by
an element of order three, which reduces the whole 20-by-15 rational rank to a
five-dimensional fixed space carrying eight distinct integer rows.  Euler's
relation gives the kernel vector, the displayed four-by-four minor is `-5`, and
the only external step left is the ordinary constant-rank theorem.  The same
decomposition identifies the five-dimensional tangent space of the generalized
conference locus as the trivial plus the irreducible four-dimensional
constituent, so the two ranks fourteen and eleven are one structural fact.
Report: `notes/2026-08-05-c815-rank-14-weighted-jacobian.md`.

That report's one open ledger item is closed and two of its readings are
corrected.  The splitting into the trivial and four-dimensional constituents is
an eigenspace decomposition of conjugation by the representative, from
`A₀ X A₀ = μ(X) A₀ - 5 X`, rather than a character computation.  Modulo five
the Jacobian's kernel is exactly the vanishing-multiplier hyperplane of the
conference tangent space, proved by the same order-three reduction on the same
eight-by-five table, because fixed-point dimension equals composition length
over that field; the ramification of five in the golden order is why no prime
other than two and five can be bad, and characteristic two remains unexplained.
The minor `-5` is therefore only half an artifact: its divisibility by five is
forced by the modular rank drop and is independent of the chosen rows and orbit
basis.  The earlier reading that the modular rank and the conference rank agree
for a shared reason is retracted as a cancellation of offsets.  Report:
`notes/2026-08-06-c815-characteristic-five-degeneracy.md`.  The manuscript and
Lean proposals arising from all of this are queued in C816's card and are not
owned by C815; no Lean file changed.

Manuscript row OPER-4 is closed.  Each of the three signed Hamilton-cycle
products of a four-set omits one pair of opposite edges, so it is the product of
the two triangles avoiding that pair; the cycle sum is therefore the first
triangle sign times the sum of the other three, which is `3` exactly when all
four agree.  With `det = 3 - 2w` this identifies the determinant-minus-three
family of a Seidel matrix with the aligned family of its two-graph, and the
four triangle signs' product being one leaves the minor no value but `-3` and
`5`, so the Greaves and Suda design is the `-3` fibre of a two-valued function.
The signing is then recovered up to diagonal switching and one global sign.
This assumes only symmetry, a vanishing diagonal and entries squaring to one,
not a scalar square, and it needs seven labels rather than order at least ten.
Separately, the selected query family of a single anchor is proved sufficient:
the seven-point step never read anything but the tests meeting its anchor in at
least two points, so weakening its hypothesis to exactly those lets the same
argument run along one fixed anchor, and any three points lie with the anchor in
a seven-point subset that calibrates the complement bit on the anchor's own
triple.  Count and sufficiency now name the same family, and the anchor is
unconditional on seven points.  The new modules are
`RelativeConicArcs.SeidelPrincipalMinors` and
`RelativeConicArcs.AlignedQueryFaithfulness`; the passages gate audits
sixty-five terminals with no compiled evaluation anywhere, all paper-local
replays pass, and the full release gate passes including the deterministic
manuscript build, which also clears the tracked-PDF failure recorded on
2026-08-05.  One measured negative: dropping the tests that meet the anchor in
three points collapses the 4,096 normalized seven-point data to 2,329
signatures, so that economization of the count fails.  Report:
`notes/2026-08-07-c815-oper4-determinant-and-query-closure.md`.

The row's `coverage` token and the manifest's global formal-coverage status
still say that no complete manuscript row is claimed.  Both strings are
hard-coded for all nine rows in `verify_scaffold.py`, so promoting them is a
change to the release contract and belongs with the coordinated trust and
release pass, not to a single row's closure.

Rows OPER-1 and OPER-2 are now closed as well.  Renaming the six labels along
the inverse of each of the six reorderings carries the fixed conference matrix to
a conference matrix of its own — symmetric, vanishing diagonal, unit off-diagonal
squares, square `5 • 1` — and its weighted triangle products are the twenty
coefficients of the corresponding translate; the six sign words so obtained are
pairwise distinct and each obeys the four-point two-graph identity, which is the
coherence of the outer six-family, and each translate is the coloured-triangle
cubic of its word coefficient by coefficient, which is the Joubert
identification.  Those same six words are the complementary triangle colourings
of the one-factorizations of the complete graph on the six labels: for a triple
and its complement the three matchings meeting the triple in an edge also meet
the complement in an edge, and the sign of that bijection, corrected by the
Hodge sign of the listing, is the coefficient.  Every one-factorization gives one
of the six words, so there are exactly six such colourings and the count is a
theorem rather than an attribution.  The diagonal section and the Segre--Igusa
polar map follow: a point of the Segre cubic with a vanishing coordinate has its
remaining five coordinates summing to zero with vanishing cube sum, and the
centered squares satisfy the Igusa quartic relation, proved through the
characteristic polynomial of the six coordinates and Newton's identities rather
than by a certificate and reducing to
`48 p₈ = 12 p₄² - 12 p₂² p₄ + p₂⁴ + 32 p₂ p₆`.  The cross-golden comparison holds
over any commutative ring with two invertible carrying an invertible square root
`s` of five: the commutator of the diagonal matrix with the conference matrix is
`2 s` times the antisymmetric part of the cross-golden block, so
`Z² = 500 det (B - Bᵀ)` and, exactly and with no sign ambiguity,
`Z = 10 s Pf (B - Bᵀ)`; using the other square root of five negates the Pfaffian
and the factor `10 s` together, so the manuscript's `±` belongs to the
basis-dependent three-by-three determinant rather than to this identity.  The modules are
`RelativeConicArcs.ClebschOuterJoubertFrame`,
`RelativeConicArcs.ClebschOuterMatchingFrame`,
`RelativeConicArcs.SegreIgusaPolar` and
`RelativeConicArcs.CrossGoldenDeterminant`; the golden-return gate audits
one hundred and twenty-three terminals with no compiled-evaluation axiom.  A
cold referee accepted the arc after recomputing every constant and finite table
independently; its one substantive repair — the `±` above, which had a false
justification and left a theorem weaker than provable — is applied, along with
the marked representatives, the exported one-factorization indexing, and
several prose corrections.  Review:
`notes/2026-08-07-c815-oper1-oper2-referee-review.md`.  One
manuscript defect surfaced and is queued for C816: row `r = 2` of the displayed
table (5.1) has its last six signs negated, which violates both the four-point
two-graph identity and the paper's own relation `Σ_T J_T = 0`.  Report:
`notes/2026-08-07-c815-oper1-oper2-algebraic-closure.md`.

What remains for C815 is the geometric part of gap class B in
`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md`: ARITH-1 and
ARITH-2, ORIENT-1, and HARM-1 and HARM-2.  Each is a larger piece of work than
any OPER clause.

The harmonic rows are under way.  Their route removes the analysis rather than
formalizing spherical harmonic theory: the normalized spherical average is
introduced as an explicitly defined moment functional on polynomials in three
variables, its invariance under orthogonal substitution follows from the
integration-by-parts recursion together with the uniqueness that recursion
forces, apolarity supplies the two clauses that the manuscript's proof actually
consumes for a harmonic `p` of degree `d` — that `N(p q)` vanishes when `q` has
degree below `d`, and that `N(p (w·x)^d) = d! p(w)` — and the spherical addition
theorem for the degree-six zonal harmonics follows from them in a few lines as
`N(Z_u Z_v) = 10395 P₆(u·v)`.
Exactly one classical statement stays outside — that the defined functional is
the surface integral — and it is confined to a module of its own.  The route,
its six-module plan, and an exact-arithmetic certificate for every constant it
uses are in `notes/2026-08-07-c815-harmonic-realization-scope.md`; the
certificate also verifies the target identity
`M(F_y³) = -784000/1247103 σ₃(y)` for arbitrary sum-zero `y`, not only at the
marked vector, so the manuscript's invariant-line step is a convenience rather
than a necessity.

The first four of the seven planned modules landed together and elaborate
without errors or warnings.
`RelativeConicArcs.IcosahedralFaceAxes` proves that the displayed labelling of
the ten icosahedral face axes is geometric — equal lengths, and the square of the
inner product of two distinct axes taking one value on disjoint label pairs and
another on meeting ones — over `ℤ√5` and, by transport along a chosen square
root of five, over any commutative ring; it also carries three explicit rotations
permuting the axes with their induced label permutations.
`RelativeConicArcs.AlternatingComparisonLine` proves two-transitivity of the
alternating group on five letters by explicit construction, computes its
commutant on the coordinate module, and concludes that every equivariant
comparison to the Petersen coefficient module is a multiple of the pair-sum map
whose scalar is one once the sum of cubes is preserved; the coordinate
representative that conclusion needs is constructed there, not assumed.  A cold
referee accepted the route, the certificate and those two modules with repairs,
all applied, and recorded that three assertions of the manuscript section — the
covariant obstruction, the non-arithmetic content of the Gaunt factorization,
and the Condon--Shortley remark — are owned by no row of the gap inventory.
Review: `notes/2026-08-07-c815-harmonic-route-referee-review.md`.  Those three
are now owned by C884, which runs after the harmonic rows close and before the
section is promoted.

The analysis is gone.  `RelativeConicArcs.SphericalMomentFunctional` defines the
moment functional by its monomial formula, proves the integration-by-parts
recursion `N(xᵢ p) = N(∂ᵢ p)`, proves that the recursion together with `N(1) = 1`
determines the functional, and reads invariance under an orthogonal substitution
off that uniqueness; it also proves the sphere relation
`N((x·x) p) = (d + 3) N(p)` and the two apolar clauses, both by one induction on
the degree out of Euler's identity.  `RelativeConicArcs.ZonalHarmonicDegreeSix`
defines the degree-six zonal form, proves it homogeneous, evaluates it at a unit
vector as `P₆` of the inner product, proves it harmonic for a unit axis, and
concludes `N(Z_u Z_v) = 10395 P₆(u·v)` with normalized form
`M(Z_u Z_v) = P₆(u·v)/13`.  The route is shorter than the scope note planned: no
apolar differential operator is defined and the four Leibniz evaluations are
unused, because the three terms of `Z_v` carrying `x·x` die by the sphere
relation followed by the lower-degree clause.  Report:
`notes/2026-08-07-c815-harmonic-moment-and-apolarity.md`.

The Gram half of HARM-1 is closed on top of that, together with the quadratic
identity that no module had owned.  `RelativeConicArcs.FaceAxisHarmonicGram`
realizes the labelled axes over the reals, rescales them to unit length, and
computes the Gram matrix of their zonal forms as `(196 I + 47 J - 112 A)/3159`,
which is the manuscript's `G = K/13`; its entries come from the degree-six
Legendre polynomial at the squared axis inner products `1`, `5/9` and `1/9`, and
only the squares enter, so no axis representative's sign is ever determined.  The
Petersen eigenvalues give the three Gram scalars `110/1053`, `140/1053` and
`28/1053` as eigenvector equations.  Injectivity is proved where the manuscript
claims it, on the Petersen `(-2)`-eigenspace, where the Gram form is the positive
scalar `140/1053` times the squared norm of the coefficient vector — so no
spectral decomposition of the ten-dimensional space is needed.  Pair-sum
tightness then gives `M(F_y²) = (140/351) ∑ y_i²` and the marked value
`2800/351`.  Report: `notes/2026-08-07-c815-face-axis-zonal-gram.md`.  What is
left in the two rows is the spherical cubic restriction and the surface-integral
identification.  None of the five modules is on a gate yet.

The cubic restriction is designed and its route is fixed, in
`notes/2026-08-07-c815-spherical-cubic-restriction-design.md`.  It takes the
manuscript's invariant-line route rather than the scope note's symbolic-in-`y`
route, because the direct expansion needs either a triple-zonal formula that the
apolarity clauses do not reach or tens of thousands of products: the structure
constants of the cubic form stay abstract, the icosahedral rotations make them
constant on the three index patterns, and one marked value fixes the scalar.  The
marked field splits as `a·Hodd + b·Heven` over the squared coordinates with
`a = -385√5/24` and `b = 35/12`, so its golden part is exactly the
transposition-odd component; a coordinate transposition kills every odd power of
that component, which is why the value is rational and why only two
degree-eighteen moments have to be expanded.  The design's constants and its
label-permutation word tables are certified by
`notes/2026-08-07-c815-spherical-cubic-design-checks.py`.

The design's first risk gate is passed:
`RelativeConicArcs.SphericalCubicRestriction.normalizedMean_tetrahedralEvenHarmonic_cube`
directly normalizes the fifty-five monomials of `Heven³` to
`-1280/46189` under the default guarded profile.  No squared-coordinate moment
helper is needed.

The second surviving cubic moment is green as well:
`normalizedMean_tetrahedralOddHarmonic_sq_mul_tetrahedralEvenHarmonic` gives
`-1024/969969`.  The first-coordinate swap is formalized as an orthogonal
substitution, negates `Hodd`, fixes `Heven`, and proves the two odd-power moments
zero.

The designed marked odd/even combination is now assembled.  For every real `s` with `s² = 5`,
`markedTetrahedralField s = (-385s/24)Hodd + (35/12)Heven`, and
`normalizedMean_markedTetrahedralField_cube` derives
`-15680000/1247103` from the four moment theorems.  The proof uses only the
square of the odd coefficient, making the rationality mechanism explicit.
`zonalCombination_pairSum_stabilizerFixedVertexWeight` expands the actual ten
unit-axis zonal forms and proves their weighted sum is exactly the designed
odd/even field.  Hence
`normalizedMean_zonalCombination_stabilizerFixedVertexWeight_cube` proves the
manuscript's marked value for the geometric face-axis field.  Rotation
covariance is now closed as well: the three scaled golden matrices give real
orthogonal rotations, their polynomial substitutions relabel the entire
ten-axis zonal field by the displayed label permutations, and the algebraic
moment functional makes `faceAxisCubic` invariant under all three.  The explicit
word-orbit reduction and sum-zero collapse remain.

The finite word layer is closed.  `applyRotationWord` preserves
`faceAxisCubic`; the five root-moving words and twelve sharply transitive
root-stabilizer words are kernel-checked; and explicit inverse words assemble
`tripleTransportWord`, proving three-transitivity on ordered distinct triples.
No subgroup closure, group-order calculation or compiled evaluation enters.
The structure-coefficient reduction and sum-zero collapse remain.

The C815 working tree is clean.  `AlignedTwoGraph.lean`,
`PetersenHarmonicKernel.lean` and `Gates/ClebschPassages.lean` remain shared
paths; `ClebschGoldenConference.lean` and `ClebschTwoGraph.lean` are shared
with Paper I and the golden-operator lane and need explicit permission plus
widened validation before any edit.

The complete 2026-08-08 landed-work audit is
`notes/2026-08-08-c815-complete-landed-work-audit.md`.  It found no mathematical
or trust failure, repaired the public-docstring and live-plan drift it found,
and added one pre-freeze obligation: formalize the already structural reduced
weighted-Jacobian rank argument before C816 can promote that assertion.

C756 remains the independent high-upside research task for the all-\(k\)
conic-filling theorem. Paper IV's general passant-code definitions and
weight-eight method are reusable inputs to C756, but C761 does not own or
block that theorem.

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Paper I — *Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus* | `papers/clebsch-rigidity/` | GitHub/DOI v1 and v2 released; C893's independent 2026-08-08 review found the 55-terminal axiom surface clean but issued MAJOR on the current trust/release artifact (stale README seal, accepting terminal-omission mutation, 66 stale generated outputs, obsolete Dye-assumption prose, conditional commutant interface, incomplete theorem coverage, and scholarly-documentation debt); its initially attributed guarded-gate success was a concurrent q13 run, so C855 owns both the fresh q11 replay and every repair before the next release is called theorem-complete | [C855](../clebsch-tasks/c855-paper-i-lean-referee-artifact-remediation.md) |
| Paper II — *Quadratic trade rigidity and cubic orientation in conic matching quotients* | `papers/clebsch-factorization/` | GitHub/DOI v1 and v2 released; C577's manuscript, human-proof, exposition, and local-export stream is complete at warning-free 45-page authority `9af3eb45` and clean unpushed mirror `2245993`; C892 separately owns full remediation of the formal/trust **MAJOR / NO-GO** audit | [C892](../clebsch-tasks/c892-paper-ii-lean-trust-boundary-review.md) for formal/trust closure before any public forward release |
| Paper III (`passages`) — *Golden descent and operator realizations of the Clebsch cubic* | `papers/clebsch-passages/` | GitHub/DOI v1 and v2 released unchanged; C792's B-plus integration and C799's normalized aligned-design API are complete; C815's three gates are green with no compiled-evaluation axiom at any terminal, aligned-design faithfulness is formalized at the manuscript's quantifier range, and the rank-14 weighted Jacobian is proved structurally; all four operator rows of gap class B are closed and its remaining work is the arithmetic, orientation and harmonic rows before C823.  C897's first sealed human-proof batch was **MAJOR** for a missing proof, not a demonstrated false theorem.  C897 repaired the reduced branch/complete-fibre argument and exact rational `J_0` scale, corrected Table (5.1), expanded the local proofs and rejecting checks, and obtained fresh Hitchin, Greaves, Snowden, and Si Kaddour `PASS` regrades.  Its final style-guide pass layered the complete source--shadow--return route and preserved every theorem by stable semantic ID; a post-read correction then made branch-sextic irreducibility paper-local and repaired the Haemers--Parsaei Majd metadata.  Final authority `74a73b97` synchronizes to standalone `6989cf8` with an identical warning-free 32-page PDF; C897 is complete, while Lean follow-up remains separately queued by author direction | [C815](../clebsch-tasks/c815-four-shadow-lean-formalization.md); [C897 dossier](../clebsch-tasks/c897-paper-iii-reviewer-dossier.md); `notes/2026-08-09-c897-paper-iii-layered-exposition-plan.md` |
| Paper IV — *Reconstructing \(\operatorname{PG}(2,13)\), its conic, and polarity from the minimum words of a binary conic code* | `papers/q13-passant-code/` | C831/C832 structural version complete; a manuscript-only standalone pre-release was published 2026-08-03 at DOI `10.5281/zenodo.21783971`, with the Lean companion excluded and due as a forward version; C834 must still complete the proof-producing formal closure and then C857 the exhaustive Lean standards checklist before the full release; C901 separately owns an isolated human-proof/exposition review programme and keeps its persona material outside ordinary Paper IV context | [C834](../clebsch-tasks/c834-paper-iv-full-lean-release-closure.md), then [C857](../clebsch-tasks/c857-paper-iv-lean-standards-closure.md); [C901](../clebsch-tasks/c901-paper-iv-reviewer-dossier.md) |
| Paper V — *Chordal and Conference Cubics: Reconstruction and a Residual \(C_2\)-Torsor* | `papers/chordal-conference-reconstruction/` | publishable structural authority; the original relative Chow crown and adjacent gluing-classification research remain quarantined, and Lean is deferred | [C904](../clebsch-tasks/c904-paper-v-publishable-round-trip.md) |
| 37-page mega-paper | `papers/clebsch-code/` | preserved unchanged as fallback only | C552 if explicitly reactivated |

**2026-08-11 Paper V manuscript update.** The row's frozen-surface wording is
superseded at the manuscript-first gate. *Chordal and Conference Cubics:
Reconstruction and a Residual \(C_2\)-Torsor* is the warning-free structural
authority at `papers/chordal-conference-reconstruction/`.
It proves the intrinsic selected-line equivalence, exact residual
\(uq\)-quotient, source returns, common binary heart, uniform symmetric
conference saturation, unique nonsplit order-six \(\mathbf F_4A_5\)
extension, and the geometric/residue Frobenius identification. The
reconstruction framing is now applied across Papers I--V and the computational
companion, with six independent cold/A--B reads all passing.  The five
standalone mirrors are synchronized by forward commits and their local
manuscript gates pass; nothing has been pushed.  Lean remains deferred by user
instruction.  Current reports:
notes/2026-08-11-c904-paper-v-structural-draft-closeout.md and
notes/2026-08-11-c904-series-reconstruction-framing-closeout.md.

C904's original Annals-upgrade frontier remains the relative Shen-cycle
descent gate.  Fixed-fibre lifting is closed by the unordered `2/5`
construction, but Shen's cycle is existential rather than horizontal.  The
exact obstruction lies in the geometric kernel of `CH_1(D_+)/2`, not in
`J[2]`; residual `C3` closes Picard descent only.  The ambient image on
`D_+=3 Theta` has exact minimal-class multiplier ideal `6Z`, while
six-axis norms, formal universal-sheaf expressions, Fano/Prym carriers, and
the direct conic--Prym cylinder are all proved even or otherwise dead.  The
exceptional plane-quintic route is now closed for the full saturated Fano
surface lattice: modulo two its Rosati norms generate a codimension-one
two-sided ideal, separated from the identity by a multiplicative residue
character.  No nonscalar, adjugate, or endomorphism-dressed repair escapes.
The live exit is therefore an intrinsic relative cycle, an odd-degree complete
half relation, or the exact even descent index.  The proposed charge-three
Bridgeland/anticanonical shortcut is dead: classical `M9` has nonprimitive
Kuznetsov class, cannot be a primitive nine-dimensional stable-object moduli
space, and its open-fibre canonical class is trivial by integral GRR.  The
full `Sym^2(Bl_0 Theta)` Kunneth audit instead isolates two direct two-local
targets.  The `(1,5)` channel has an odd integral Hodge coset after the
symmetric quotient, with residual lattice `(Z/2)^10`; nonsplit `(2,4)` has
dyadic residual dimension 44, while `(3,3)` is forced even.  Uniformly in
the ppav dimension, the half anti-graph of an odd symmetric-theta
multisection is an odd integral Hodge curve class whose double is algebraic.
The theta resolution has no local dyadic topological defect, but no
integral/two-local algebraic Kunneth projector is known.
The residual `C3` alone offers no parity obstruction: the full mixed invariant
spaces have dimensions 50 and 776 and do contain odd contractions.  The exotic
deck is different.  Under the 2026-08-11 C908 normalization adjudication — the
raw `F_2`-linear contraction *is* the unordered degree, invariants equal
transfers with index one in bidegree `(1,5)`, and the `1/2` of the half
anti-graph is spent exactly once — the full `S3` deck **is** a parity
obstruction in `(1,5)`: the `S3`-fixed subalgebra is `M_5(F_2)`, of dimension
25, on which the degree vanishes identically, so it contains **no** odd
contraction and no class defined over the **unmarked** base can carry odd
`(1,5)` degree.  The marked base forces only `C3`, where odd residues survive
as the `w`-twisted cosets with `F_4`-coefficient trace outside `F_2`; that is
now the construction target, and the former fixed-"coefficient identity" target
is retired as even.  The `(2,4)` channel is unchanged: the `S3`-fixed space has
dimension 396 and odd contractions exist there.  So the finite-monodromy route
is not closed but split — dead over the marked base, obstructing over the
unmarked one — and it still neither algebraizes an odd class nor proves a
quadratic splitting field.  See `notes/2026-08-11-c908-unordered-degree-normalization.md`
for the adjudication and `notes/2026-08-11-c908-unmarked-closure-and-w-twist.md`
for the closure theorem (Theorem C) and the `w`-twist scoping.
The `(1,5)` channel-population question is **closed negative**.  The earlier
passes had already made every product source even — the deformation-canonical
residues are pinned to `{0, I}` (pass-5 Theorem E), the ψ-transfer from the
Fano surface reaches the whole escape lattice only topologically, and the
entire span-incidence product library (the span map is classically the Gauss
map of `Θ` composed with the difference map, `g^*O(1) = ψ^*Θ`) realizes only
integral scalar identities `c·I_10` with `4 | c`, certified over all 72
arrangements — leaving the non-product `c_4` bit `λ` as the unique standing
route.  That bit is now zero on both models: the span-model readout matrix is
`N = 120·I` against the ten pure antisymmetric tests, so `λ_𝒢 = 0`, and the
negative transfers to the `ℰ`-model universal family of `M_X(v) ≅ Bl_0Θ`, so
`λ_ℰ = 0`.  The mechanism is that the `(3,5)` block of `c_4` is linear in the
odd `X`-legs of the Chern character, on which the Serre-functor mutation
carrying the span model to the universal family acts by `∓1` and nothing
else; the three residual even-block terms then die because `G^2 ≡ 0` (a
`Θ`-pullback square, `Θ^2/2` being integral), because `c_1(V) ≡ G` is killed
by the certificate's mod-two `t`-independence control, and because `c_2(V)`
is `σ`-symmetric mod two while the tests are `σ`-antisymmetric.  Rank three
is exactly the rank at which the universal family's base-twist ambiguity is
identically invisible to this readout, which is why the transfer is clean.
So no universal-family Chern class populates the channel, and with it every
source named in the C908 corpus — pullbacks from `J×J`, exceptional-divisor
cycles, the span/incidence dictionary, and `c_4` of either model — is
excluded.  A reusable by-product: codimension-four sheaf defects can never
affect a mod-two `c_4` readout, which dissolved the deep-stratum frontier
the pass-8 spec had carried.  Reports:
`notes/2026-08-12-c908-lambda-reduction-and-verdict.md` and
`notes/2026-08-12-c908-e-model-mutation-comparison.md` (extraction item F,
discharged).  Earlier passes:
`notes/2026-08-11-c908-universal-family-even-rigidity.md`,
`notes/2026-08-11-c908-transfer-liveness-and-span-incidence.md`,
`notes/2026-08-11-c908-span-incidence-parity-no-go.md`, and
`notes/2026-08-11-c908-fano-schubert-restriction-extraction.md`.

The substantive positive result is an integral lattice theorem for the odd
cohomology of the blown-up theta divisor `M = Bl_0Θ`, forced by pass 8's
certificate refutation of the degree-three half of pass-2 Theorem 1 (the
triple point's link enlarges `H^3(M,Z)` beyond `b^*H^3(J,Z)`) and then proved
outright.  `H^3(M,Z)` is torsion-free of rank 130 and a nonsplit extension of
`H^3(X,Z)` by `∧³Λ`, glued by an isomorphism
`ρ : H^3(X,Z)⊗F_2 → Sat/L_3∧³Λ` with the closed form
`ρ(γ) = [Θ^{[2]}∧S·w(γ)]`; `b_*H^3(M,Z)` is exactly the saturation `Sat` of
`Θ∧∧³Λ` in `∧⁵Λ`, of index `2^10`; the transfer `q_*μ^*` from `H^3(F×F,Z)`
is integrally surjective, so the entire lattice comes from the Fano surface
through the degree-six model with nothing left over; and the escape group
`E = H^5(M,Z)/(b^*H^5(J,Z)+tors)` is **free** of rank ten — pass-2's
`(Z/2)^10` identification was wrong — with the exceptional classes
`e_{X*}H^3(X,Z)` at exactly depth two, so `E/2E ≅ (Z/2)^10`.  All four
`(Z/2)^10` coincidences of the corpus are now proved natural shadows of the
single object `H^3(X,Z)⊗F_2`, under the deck action, under `Sp(Λ,S)`
monodromy, and under the `L_3`/`L_5` adjointness that makes `Q_15`
canonically dual to `Sat/L_3∧³Λ`.  A hostile proof audit ran (its one FATAL
finding, a gate congruence, had been caught and corrected before it landed;
all GAP repairs are folded in), and a bounded priority audit returned **no
prior art**: no source computes the singular, integral or intersection
cohomology of `Θ` or `Bl_0Θ` for a cubic threefold in any degree, the closest
work (Bayer–Beentjes–Feyzbakhsh–Hein–Martinelli–Rezaee–Schmidt,
arXiv:2011.12240 Theorem 7.1) supplying the object as a moduli space but no
cohomology.  **This theorem is a candidate for its own paper; that scoping
decision is pending with the user and is not taken here.**  Reports:
`notes/2026-08-12-c908-h3-lattice-adjudication.md`,
`notes/2026-08-12-c908-h3-compression.md` and
`notes/2026-08-12-c908-z2-naturality-checks.md`, with audits
`notes/2026-08-12-c908-h3-lattice-proof-audit.md` and
`notes/2026-08-12-c908-h3-lattice-priority-audit.md`; the pass-8 correction of
record is `notes/2026-08-11-c908-h3-resolution-lattice-correction.md`.

Two corrections to previously banked C908 work are live debts.  First, the
pass-5 twist lemma's rank-three branch is false on the corrected lattice: it
assumed `H^3(M,Z) = b^*∧³Λ`, and an explicit odd-capable witness
`3∫_JΘ^{[3]}∧u∧z∧τ = ±1` refutes it.  The item-F argument no longer needs
that branch — at rank three twist-invariance of the readout is an exact
identity requiring no cohomology of `M` at all — but the same lemma's other
use, the relative Ext object
`E = RHom_{π_{12}}(π_{13}^*ℰ, π_{23}^*ℰ)[1]` on `M×M`, has rank other than
three, is **not repaired**, and still rests on the refuted step; this weakens
the `{0, I}` pinning for that object, though pass-5 Theorem E itself survives
because its conclusion also follows from Theorem C for pencil-defined
classes.  Gate: an analogue of the rank-three twist lemma at the relevant
rank, or a direct check that the correction legs pair evenly through
`Sat/L_3∧³Λ`.  Second, the λ-reduction note's parenthetical that the
span-model sheaf does not descend along the degree-six map `q` is **false**:
the six points of a general `q`-fibre carry the same `E_6` root `ℓ'−ℓ` on the
same cubic surface, hence isomorphic sheaves, and the factor swap is not a
deck transformation of `q` (it covers `(−1)_J`).  Correcting it strengthens
the verdict chain rather than weakening it, but the wrong statement still
stands in `notes/2026-08-12-c908-lambda-reduction-and-verdict.md` §1 and its
audit.

What remains open, each with its gate.  Both λ verdicts are
**certificate-conditional to the same degree**: the kill of `G·c_3^{(3,3)}`
is the `t^1`-coefficient of the main-term certificate's verified mod-two
`t`-independence rather than a structural proof, and the onto half of `ρ`
(hence the exact image description of the lattice theorem) rests on the
adjudication certificate's finite integer checks, independently replayed in
PARI.  Gate: a structural proof that `∫(x⊗T_a)·G·c_3^{(3,3)}` is even.  The
values `c_1(V) = 3[I] − 12C_2` and `c_2(V) ≡ G(C_1+C_2)` are derived but not
certified; gate: a bounded extension of the main-term certificate — nothing
in the item-F verdict depends on them.  The `(1,5)` channel itself can now be
populated only by a non-deformation-canonical, deck-asymmetric cycle special
to the exotic member, or over the marked base by the `w`-twisted `C3` cosets
above; the `(2,4)` channel is untouched by all of this.

Against its own card
(`notes/clebsch-tasks/c908-annals-math-upgrades.md`), C908 has not yet
reached an acceptance criterion.  The priority-A relative Chow index
(`ind(Y) = 1` versus `2`) is undecided: no odd horizontal multisection was
constructed, and the accumulated negatives exclude named sources without
defining a canonical two-primary obstruction class and computing it on the
exotic marked base, which is what the card's negative-Chow crown requires.
Priority B, the intrinsic `p`-typical divisor-product classification, is
untouched by these passes.  The lattice theorem lands in the card's third
band of non-diluting crowns rather than in A or B, and is the strongest
result C908 currently holds.  The card's genuine-block clause has not
triggered — every pass produced theorem-level progress — but the `(1,5)`
population leg of priority A is now exhausted for every named source.
The rational `(1,5)` inverse-Lefschetz class is algebraic, but its integral
or two-local lift remains open; every canonical decomposable candidate is
now even, with scalar coefficient ideal `6Z` universally and `12Z` on the
actual invariant divisor-product lattice.  The canonical integral-Fourier
class `P^3/3!` is pure `(3,3)` and has quotient degree 80, not five.  The
entire rank-55 `NS(J x J)` mixed-cube calculation is stronger: its `(5,1)`
image is exactly `2 End(J)`, with quotient `(Z/2)^25` and identity order two.
The same remains true after adding all 375 BdGF integral divided-square
generators `D^2p_T/2`.  Hence every graph- or endomorphism-dressed divisor
cube and every available divisor divided power is dead; a successful
projector must be genuinely non-divisor.  The general ample support
surfaces sharpen the inherited degree-five channel in the opposite
direction: Lefschetz connectedness preserves the ordered-pair residue on
every support curve, so the fixed-line/Hecke/type-`(5,1)` conic has exact
index two componentwise.  That route is dead, while intrinsic charge three
and coupled correspondences remain open.

Rational simple connectedness is therefore not dimensionally dead: each
component lift is over a surface field, so the de Jong--He--Starr theorem
would apply if its strong free-line, chain-evaluation, polarization, and very
twisting hypotheses were proved.  Existing geometric unirationality does not
supply a point over that surface field, and the exact degree-five residue
shows why geometric RC alone is insufficient.  See
`notes/2026-08-11-c904-m9-bridgeland-anticanonical-obstruction.md`,
`notes/2026-08-11-c904-m9-determinant-grr-audit.md`, and
`notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md`, together with
`notes/2026-08-11-c904-c3-kunneth-descent-boundary.md`,
`notes/2026-08-11-c904-exotic-deck-kunneth-descent.md`,
`notes/2026-08-11-c904-relative-invariant-cycle-franchetta-audit.md`,
`notes/2026-08-11-c904-ample-cut-charge-two-index.md`, and
`notes/2026-08-11-c904-canonical-p15-tautological-parity.md`,
`notes/2026-08-11-c904-bdgf-symmetric-theta-descent.md`, and
`notes/2026-08-11-c904-bdgf-theta-and-full-ns-p15-audit.md`.

The standard universal-family and explicit charge-three versions of those
two exits are now closed to one sharper boundary.  The cubic middle projector
is integral at two, but the `(5,3)` component of every one-step integral
universal Chern construction retains either the gamma-filtration factor two
or the independent `Theta^2=2 Theta^[2]` Gysin factor; the Ext diagonal does
not remove it.  On the geometric side, the degree-fifteen `D_{3,3}` lines are
contracted on the Abel--Jacobi fourfold and the Hecke lines remain in its
boundary.  Only Voisin's projected residual curves remain plausible for RSC,
but their open tangent test is now negative: Voisin does not prove the
projection nonconstant or complete, and any nonconstant complete `P^1`
contained in the smooth Abel fibre has tangent degree zero by GRR, hence a
negative normal summand.  Positivity can only be created by boundary
modifications on a new proper compactification.  Thus the direct C904 gate is
now genuinely non-tautological correspondence geometry or a proper boundary
theory for `M_9`, not another universal-Chern, visible-line, or open
residual-curve calculation.  See
`notes/2026-08-11-c904-universal-pi3-gamma-parity.md` and
`notes/2026-08-11-c904-intrinsic-charge3-rsc-surface-field-audit.md`, and
`notes/2026-08-11-c904-voisin-residual-curve-freeness-obstruction.md`.

Three further cohomological shortcuts are now closed.  EFS gives the sharp
very-general image `2Z c` for curves on `Theta`, but mixed and primitive
Kunneth classes prevent that from computing the unordered-theta index, and
its full smoothing monodromy does not restrict to the special `A5` pencil.
On the generic unordered-theta quotient the invariant Picard lattice descends
completely, so `Br(K) -> Br(K(Y))` is injective and no base Brauer class can
detect the residual index.  Finally, the marked cusp component groups and log
isogeny kernels permit both parities until the actual Delaunay theta equations
and flat addition-graph closure are supplied.  These are dead paths at their
present information level, not unfinished cheap fixes.  See
`notes/2026-08-11-c904-efs-shen-symmetric-theta-index-audit.md`,
`notes/2026-08-11-c904-symmetric-theta-equivalence-specialization-picard.md`,
and `notes/2026-08-11-c904-cusp-tropical-theta-parity-audit.md`.

The genus-one support route is also closed exactly.  On the generic non-CM
exotic fivefold, the subgroup generated by every axis and non-axis elliptic
curve has quotient `(Z/2)^6` in the integral Hodge one-cycle lattice, and the
primitive minimal class has exact order two in that quotient.  The
no-eigenline theorem for the exotic `F4` graph covers every rational
coefficient line, not merely the enumerated short vectors; `2c` nevertheless
has an explicit nineteen-term elliptic expression.  Thus even perfect lifts
of all elliptic supports through `M9` or `Sym^2 Theta` cannot close the
primitive gate.  Only exceptional CM fibres remain outside this no-go.  See
`notes/2026-08-11-c904-nonaxis-elliptic-support-audit.md`.

The 2026-08-11 midnight pass compresses the charge-three version of that
exit further.  The normalization of the generic curve
`D_{3,3} -> M_9` is birational to a projective-line bundle over a finite
factorable-quadric scheme `R_{3,3}(E)` inside the Plücker wedge system of a
general charge-three bundle, and the two zero-cycle indices are equal.  The
exact model calculation now gives a reduced, prime degree-15 packet over
`QQ` (fifteen reduced geometric points).  A transverse good mod-5 point,
Hensel lifting and Galois transitivity identify all fifteen with the
type-`(3,3)` stratum.  The generic count is also conceptual on the normalized
join of two Veronese conics: the three compatibility divisors intersect in
`12+4-1=15`.  This proves odd index for the intervening `D_{3,3}` curve; it
does **not** produce an odd zero-cycle on `M_9 -> J`.  Combined with
Voisin's index-dividing-three `Sym^2(E_3)` relay, it makes the generic
charge-three fibre and unordered-theta fibre 2-equivalent.  Hence their
canonical 2-dimensions and their two-primary indices after every extension
agree.  The surviving gate is precisely index one versus two for the
unordered-theta fibre.  Equal upper motives are not licensed, and the
further Abel-quotient comparison remains non-load-bearing and unproved.  The
former Paper-V specialization caveat is closed: an exact smooth
\(A_5\)-pencil member has a finite etale all-good length-fifteen packet, a
full-rank presentation Jacobian lifts it horizontally, and Sage plus
independent Macaulay2 replay every packet condition.  See
`notes/2026-08-11-c904-d33-degree-fifteen-index-equivalence.md` and
`notes/2026-08-11-c904-a5-factorable-packet-specialization.md`.

Three successor theorems are now quarantined from the frozen paper.  First,
the five marked principal halves form the exact
`P^1(F4)` Hecke packet; its degree-`2^10` isogenies extend canonically as
polarized log one-motives across cusp widths `2,2,6,6`, whereas their
ordinary special kernels jump and cannot form a global finite-flat Néron
kernel.  Second, every Jordan-scalar principal elliptic-power quotient has
primitive minimal class in the integral divisor-product lattice, uniformly
at all primes and all type-A root--weight sizes.  Classical Weyl ppavs,
`X_0(N)`, elliptic-product decomposition, IHC, and minimal-class
algebraicity are preempted; the likely new content is primitive integral
Lefschetz saturation.  The arbitrary-gluing pass now proves that a prime-`p`
maximal-isotropic gluing has defect supported only at `p`, of order dividing
`p^v_p((g-1)!)`, and is always primitive for `p>=g`.  Exact defects two and
three occur already at `(p,g)=(2,3)` and `(3,4)`; the non-scalar exotic `F4`
gluing is instead a positive stratum.  The highest-EV next theorem is the
intrinsic carry-sensitive Tor-boundary classification, not a universal positive
extension.  Spectral stabilization now supplies exact index-two families in
every dimension at least three, index-three families in every dimension at
least four, and index-four families in every dimension at least five; the
order-four tower proves the factorial ceiling is not squarefree.  The towers
are polarized products, so arbitrary height and an indecomposable tower
remain open.  Their order-four fivefold base is nevertheless already
polarized-indecomposable: a cyclic-primary regular-nilpotent slope has local
reduced centralizer and hence no nontrivial Rosati-symmetric idempotent.  New
height-four tests also have exact index four.  The complementary graph
theorem now proves that every slope
with squarefree minimal polynomial is primitive: unramified orthogonal
splitting reduces it blockwise to the Jordan-scalar mixed-adjugate theorem,
and faithful flatness descends the result, including at two.  Complete
dyadic ranks three and four verify that nilpotent slope data is exactly the
first defect boundary; at odd primes it is necessary but not sufficient.
The adjacent crown is the resulting \(p\)-typical Jordan-height
classification.  Third, C904+C907 yields the successor contrast
`X` universally `CH_0`-trivial but `X times P^1` irrational for every
smooth `A5` cubic; no full stable-irrationality claim is licensed.  See
`notes/2026-08-10-c904-relative-shen-half-construction-attack.md`,
`notes/2026-08-10-c904-hecke-pentad-log-boundary.md`,
`notes/2026-08-10-c904-adjacent-annals-uniform-theorems.md`, and
`notes/2026-08-11-c904-semisimple-graph-slope-primitivity.md`.

The C904+C907 theorem bridge is independently GO after replacing the Boolean
sixth-root flag by the additive primitive-sixth-root formal-monodromy
multiplicity \(\nu_6\).  Cai's cubic atom has multiplicity two,
projective-bundle persistence contributes it with coefficient two, and every
fourfold weak-factorization center has dimension at most two and multiplicity
zero.  Flatness makes the formal-monodromy characteristic polynomial constant
along the connected atom.  The exact proof is in the C904/C907 enhanced-atom
bridge blueprint and the one-step-stabilization red-team note.

That adjacent crown now has an exact local model and a necessary correction.
For a cyclic-primary block, the graph minimal-curve defect is the order of the
principal element in the mixed-cofactor lattice of the congruence centralizer.
The commutator carry reduces to the truncated de Rham/necklace ghost relation
`d(u^n)=n u^(n-1)du`, with exact exponent
`p^floor(log_p h)`.  Proving the regular-primary formula is equivalent to one
explicit integral open-chain/marked-cycle straightening lemma, including
Frobenius-unit and unramified-descent control.  The full invariant is not one
scalar: a new independently replayed indecomposable dyadic sixfold has
minimal-curve order four but top divisor-product index eight.  Its graded
orders meet the universal recurrence `d_(k+1) | (k+1)d_k` sharply.  Hence an
Annals-scale result must classify the graded carry-enhanced complex, not only
the distinguished ghost exponent.  See
`notes/2026-08-11-c904-regular-primary-ghost-bridge-reduction.md`,
`notes/2026-08-11-c904-witt-ghost-exponent-source-audit.md`, and
`notes/2026-08-11-c904-regular-primary-degree-sensitive-defect.md`.

The open-chain quotient is not literally the Hochschild or cyclic complex.
Its exact standard part is the Connes `B=d` edge of the two-periodic diagonal
resolution, with diagonal Euler element `h u^(h-1)`.  A direct local-Pluecker
descent is also false: the unit-labelled four-leg switch has readouts
`(h^2,h,h)`, so its terms are genuine determinant contributions, not
relations killed separately.  Frobenius-unit invariance holds for the
diagonal/Connes/closed-loop sector, but any cyclic obstruction for the
principal class must be constructed only after the full determinant
antisymmetrizer.  Both literal cyclic-homology identification and termwise
switch cancellation are dead paths.  See
`notes/2026-08-11-c904-open-chain-cyclic-complex-audit.md` and
`notes/2026-08-11-c904-local-switch-cyclic-readout-counterexample.md`.

C898 is complete. Its sealed reviewer dossier, five independent cold reads,
synthesis, and adopted remediation produced Paper I authority commit `c8438909`
and verified standalone export `9259b39`. The characteristic-five stabilizer
correction and the human proof/exposition repairs are closed; the author
transferred the remaining formal Lean/release replay outside C898.

C703 records the title-page identity of the released I--III trilogy stage:
*The Clebsch cubic: recovering, orienting, and realizing* and a restrained
opening image, while their canonical titles, logical independence, and
paper-owned proof surfaces remain unchanged. It is historical release context,
not the current series count: Paper IV is now the fourth numbered paper. Full report:
[`../2026-07-30-c703-clebsch-trilogy-identity.md`](../2026-07-30-c703-clebsch-trilogy-identity.md).

C704 is complete with a positive functorial bridge.  The six outer
conjugates of C682's degree-ten middle-exterior operator are the signed
Joubert coordinates; they land on the Segre cubic and centered squaring is
the Segre--Igusa polar map.  The five-syntheme/Clebsch formula completes
the intrinsic commuting diagram.  The same conference operator gives the
literal Cartan restriction
\(\operatorname{Pf}[D_x,C]=4Z_T(x)\), whose square gives
\(\det[D_x,C]=16Z_T(x)^2\); hence the Segre coordinate, restricted branch
sextic, and Igusa polar coordinate are Pfaffian, determinant, and
centered-determinant shadows of one return.  The cross-golden block and
its adjugate further give a \(3\times3\) linear--quadratic matrix
factorization whose two kernel incidences are the golden-conjugate small
resolutions of the six-node cubic.  Its two conjugate rank-one Ulrich/MCM
sheaves descend to a rational rank-two MCM object carrying \(J^2=5\), so
the paired-tower descent persists in the cubic's singularity category.
Each small resolution is a \(\mathbf P^1\)-bundle over \(\mathbf P^2\);
smooth hyperplane sections are six-point blow-ups, and the two conjugate
blowdowns give the determinantal double-six.  Only its marked comparison
with C695 remains.  Later balanced slices stop at the
missing-support-lattice obstruction in the bounded census through degree
\(50\), while binary tetrahedral and octahedral sisters pass only their
first exact feasibility gates.  No split paper is reopened.  Full report:
[`../2026-07-30-c704-functorial-operator-shadows.md`](../2026-07-30-c704-functorial-operator-shadows.md).
An exhaustive, dependency-gated follow-up portfolio is staged at
[`../2026-07-30-c704-follow-up-mining-plan.md`](../2026-07-30-c704-follow-up-mining-plan.md).
No successor C-IDs are allocated; the recommended first tranche is the
adjugate-polar and marked-double-six packages as two separate future
Clebsch items.  Each promoted package is a no-early-bail exploration with
distinct `ej1`, `tt1`, `ej2`, and `tt2` passes before closeout.  Negative
outcomes are first-class mining objects and require a structural
obstruction theorem plus their nearest positive locus and adjacent crown.
C705 has completed the first tranche's adjugate-polar package under those
rules.  Its Coble conormal scalar is lifted exactly to characteristic zero:
in determinant-valued normalization the inverse-polar scalar is the source
Hessian determinant.  Its common affine-\(E_8\) parent is also exact.
A genuine Lie-\(E_8\) ambient Coble route is feasible.  The frozen
Burkhardt branch sextic has exact Galois group \(S_6\), so its one-point
Vinberg marking first exists over degree \(6\), while the ordered Joubert
marking lives on the degree-\(720\) splitting torsor.  Over the one-point
field the remaining five points have full \(S_5\) monodromy, which closes
intrinsic ordered recovery negatively; full level-\(2\) marking is the
exact repair.  That repair is now computed on all \(720\) sheets, and the
Vinberg principal-Pfaffian cubic is identified with the frozen Jacobian
Coble orbit by the Rains--Sam inverse theorem and its kernel-reconstruction
mechanism.  Exact reports:
`notes/2026-07-30-c705-burkhardt-e8-marking.md` and
`notes/2026-07-30-c705-lie-e8-completion.md`.  The
marked-double-six package remains unallocated pending an explicit
promotion decision.

C707 is complete with a positive operational verdict.  The two golden
eigenspaces are Naimark-complementary \((6,3)\) real ETFs and minimally
informationally complete real-qutrit POVMs, but are neither complex-qutrit
informationally complete nor SICs.  In the common six-path dilation the
cross-golden block is a postselected transfer Kraus operator, and its
antisymmetric three-copy success probability is exactly \(Z_T^2/500\).
Thus \(A=dZ\) is amplitude response, \(W\) is centered success-probability
contrast, and inverse polarity recovers the projective signed amplitudes
off \(e_5=0\).  Signed-moment cancellation from \(C^2=5I\) gives the sharp
physical bound \(|Z_T|\le8\), with maximum success \(16/125\) exactly on
the twenty balanced \(3+3\) phase vertices.  At every optimum the squared
singular spectrum is \(\{4/5,4/5,1/5\}\), and the three-filter protocol is
query-optimal in the coherent black-box model.  The twenty controls are
the oriented lifts of the ten Segre nodes and maximize all six protocols
simultaneously, but all optimal probability contrasts vanish: \(W=e_5=0\).
On this optimal middle layer the signed cubic map is the exceptional outer
transform: it preserves complements, exchanges intersection sizes one and
two, and realizes the two orthogonal five-dimensional Johnson constituents.
It is cubic in both directions and correlation-immune through order two.
At balanced controls it is also a lossless three-fermion interferometer and
a signed \(K_{3,3}\) Majorana family with energies \(\{2,4,4\}\) and
Pfaffian \(\pm32\).  A follow-up physics novelty audit identifies the Segre
identities as the six-Weyl \(U(1)\) anomaly equations.  The 44 nonbalanced
real phase masks have zero amplitude and the 20 balanced masks give
vectorlike nodes, whereas the admissible filter
\((-3,-2,-1,0,1,3)/3\) produces the primitive chiral anomaly-free vector
\((11,-10,-8,5,4,-2)\) projectively.  The ambient Segre/outer geometry and
anomaly variety are prior art; the exact real-golden
Slater/Majorana/outer-transform synthesis was not located in the bounded
sweep.
Full report:
`notes/2026-07-31-c707-golden-etf-quantum-measurements.md`.
Novelty and directions audit:
`notes/2026-07-31-c707-physics-novelty-and-directions-audit.md`.

By explicit paper-ownership decision on 2026-07-31, the complete C704--C710
post-700 development is assigned to the new `golden` lane and its standalone
*Golden conference operator and its shadow sisters* paper.  Review-facing
Paper III remains unchanged and ends before this material; the Golden lane
may cite it but may not edit, extract from, or reorganize it.  Golden entry
handoff: `notes/handoffs/2026-07-31-golden-operator-paper.md`.

C708 is complete.  The Segre--Igusa mixed differential realizes the
exceptional outer exchange between C706's synthematic-total Clifford-chart
action and the ordinary conference-axis action: it transports the two
classes of \(S_5\) in \(S_6\), rather than directly identifying their
elements.  Its frozen finite \(W_{10}\) exchange has order \(8\), so the
operator alone selects no involutory polarity; all \(36\) inner
normalizations remain, and the conference marking cuts them to the known
axis-indexed six-pack.  They form one twisted-conjugacy orbit with
stabilizer \(F_{20}\), explaining both \(36=720/20\) and \(6=120/20\);
the golden polarity and its indexed axis have the same stabilizer, so the
two golden six-sets are canonically \(S_5/F_{20}\).
The internal \(D_{10}\subset F_{20}\) orbit fusion
\((5+5+5,5+5)\to(5+10,10)\) is the finite-incidence form of C706's
\(A_5\subset S_5\) orientation-phase boundary.
Complete \(\mathbf F_2,\mathbf F_3,\mathbf F_5\)
incidence-code tables show that the doily ranks do not explain C705's bad
primes: \(2\) has only an incidence overlap, \(3\) is the
scalar-\(6\)/compound boundary, and \(5\) belongs to the golden sign lift.
The sole CSS output is the standard binary \([[15,5,3]]_2\) code.  Full
report: `notes/2026-07-30-c708-doily-codes-and-outer-exchange.md`.

C709 is complete with a split verdict.  The conference signing survives
diagonal Majorana gauge as nontrivial \(\mathbf Z/2\) cycle flux on \(K_6\),
but it is none of the sixteen Pauli quadratic refinements and supplies no
spin structure without extra surface-embedding data.  Total-order
antisymmetrization is noncanonical and gives three spectral classes.  The
canonical positive replacement is the chiral free-fermion family
\(A_C(x)=[D_x,C]\): it anticommutes with \(C\), exchanges the two golden
three-spaces, and satisfies
\(\operatorname{Pf}A_C(x)=4Z_C(x)\) and
\(\det A_C(x)=16Z_C(x)^2\).  Hence the Joubert cubic is exactly its
zero-mode and fermion-parity wall; its six nodes are precisely the rank-two
cross-golden dimers, each leaving four Majorana zero modes.  Full report:
`notes/2026-07-30-c709-majorana-k6-lift.md`; complete human proof companion:
`notes/2026-07-31-c709-majorana-k6-human-proofs.md`.

C710 is complete with a split verdict.  The McKay affine-Cartan quotient
and Hamming Construction-A \(E_8\) are explicitly isometric, including the
affine root determined by the \(2.A_5\) dimension vector.  No simultaneous
Clebsch marking exists: all \(180\) two-coordinate \(R_{10}\) minors miss
\(H_8\), the ten-node module has no equivariant rank-eight carrier under
\(S_6,S_5\), or \(A_5\), and \(Q_{10}\) contains no unmarked \(E_8\) root
subsystem.  The exact positive replacement is
\(L_{R_{10}}\oplus L_{R_{10}}^*\cong II_{10,10}\), where the exceptional
isodualities exchange maximal isotropic halves; self-adjointness recovers
exactly the \(36\) involutory polarities with \((5,5)\) graph eigenspaces.
Full report:
`notes/2026-07-30-c710-e8-hamming-marking.md`.

C711 is complete.  Seven manuscript-ready arguments remove certificate
dependence from the sub-700 Paper III inputs.  The golden Gram tight-frame
identity proves the conference square; triangle holonomy and pair balance
give the normalized augmentation cubic and its enumeration-free converse;
the middle-exterior square and exact diagonal follow from the two Hodge signs,
two dihedral minors, and complementation; parity reconstructs the distinguished
Johnson support lattice; and one Fischer eigenvector norm derives the exact
degree-ten return scalar.  Restriction of scalars gives the rational paired-
tower descent and its index-four integral comparison.  The C680 normalization,
bad-prime boundary, claim map, and formalization-ready C712 interface are
frozen.  The closeout further shows that, after the expected duality and
orientation choices, the full middle-exterior return reconstructs the
conference operator through the faithful rational exterior cube; consequently
its family-preserving projective stabilizer and line stabilizer are exactly
\(A_5\) and \(S_5\).  Hodge complementation closes the dual-family half: the
full line normalizer is \(S_5\times C_2\), and the exact stabilizer is the
diagonal \(S_5\) coupling outer orientation with complement duality.  Finally,
\((*,K/5)\) generates the split quaternion algebra
\((-1,5)\cong M_2(\mathbf Q)\), so the \(10+10\) golden split is Morita
multiplicity and Hodge complementation makes golden conjugation inner.  Its
normalized and primitive-return orders have exact indices \(20\) and \(500\)
in \(M_2(\mathbf Z)\); adjoining the integral golden coordinate leaves index
\(5\).  The staircase \(500\to20\to5\to1\) separates raw-return scaling,
conductor two, golden ramification, and maximal saturation, and excludes prime
\(3\) from the middle-exterior quaternion layer.  The residual index-\(5\)
order is exactly the Iwahori preserving the unique ramified golden eigenline,
with quotient the opposite-root direction.  The rational Morita factor is
\(\mathbf1\oplus\mathbf4\oplus\mathbf5\), exactly the module on the ten
complementary support pairs; only its three irreducible scalars and the two
Iwahori endpoints remain optional integral choices.  The latter form an
index-five lattice edge: the explicit normalizer \(w\), satisfying \(w^2=5I\),
exchanges its endpoints, so choosing one is precisely an orientation choice.
Point--pair incidence further gives canonical projectors onto the
\(1,4,5\) Morita channels; their denominators locate prime \(3\) in the
icosahedral integral splitting rather than the quaternion order.
Projective incidence proves that the exterior-cube kernel over every field is
exactly \(\mu_3(F)\); over \(\mathbf Q\) it is trivial, while characteristic
\(3\) requires distinguishing field points from the nonreduced group scheme.
Under the classical normalized transvectant and Bombieri--Fischer form, the
raw degree-ten scalar reduces from \(211625906798592000\) to \(64/1575\);
the intrinsic golden factor \(st^6\) is unchanged.
Full report:
`notes/2026-07-31-c711-paper-iii-sub700-human-proofs.md`.

C712 is complete.  The paper-oriented conference, triangle, two-graph,
augmentation, middle-exterior, support-recovery, and golden-descent interfaces
are formalized in Lean.  The serialized gate, exact twenty-five-declaration
axiom report, twelve-file hash manifest, paper-local replay, and complete Paper
III evidence/PDF gate are green.  Abstract classification, atom recovery,
exterior-cube faithfulness, binary transvectants, and optional quaternion-order
refinements remain explicit human-proof boundaries retained by C680.
Full report: `notes/2026-07-31-c712-paper-iii-sub700-lean.md`.

## Active and queued task cards

| task | state | next gate |
|---|---|---|
| [C855 — Paper I Lean referee-artifact standards remediation](../clebsch-tasks/c855-paper-i-lean-referee-artifact-remediation.md) | active; authority repair, exact 51-terminal rigidity and 24-terminal orientation facts, guarded replays, and exporter-only finitegeom adoption are complete at source `374d1c3e` and downstream `b871c10` | resume theorem-completeness, correspondence, distribution, and release closure; no export repair remains |
| [C792 — Paper III exchange-rigidity integration](../clebsch-tasks/c792-paper-iii-exchange-rigidity-integration.md) | complete; repaired B-plus manuscript, final independent acceptance, aggregate gates, and standalone synchronization closed | none; C815 is the current Paper III route task |
| [C799 — Paper III aligned-design Lean closure](../clebsch-tasks/c799-paper-iii-aligned-design-lean-closure.md) | complete at the normalized-core boundary; normalized cut classifier, symbolic third-point elimination, conditional overlap consistency, query-polynomial identity, determinant/switching transport, formal audits, and paper gate green | Ramsey existence, arbitrary finite-set normalization, and query-family cardinality remain human inputs; shared `AlignedTwoGraph` API is available to C815 and C823 |
| [C800 — Paper III operator and formal-release closure](../clebsch-tasks/c800-paper-iii-operator-formal-release-closure.md) | fourth Paper III route task; wait for C799/C815/C823 source freezes | formalize retained exchange and determinant identities, reconcile all Paper III formal maps onto one source closure, regenerate audits, and replay both gates |
| [C809 — four-shadow characterization](../clebsch-tasks/c809-four-shadow-characterization.md) | complete; positive math-only freeze; no paper promotion | none; nonzero triangle--Pfaffian proportionality characterizes the sign conference class, the two orientations are projectively isolated, and any manuscript/novelty integration requires a separately allocated follow-up |
| [C815 — four-shadow Lean formalization](../clebsch-tasks/c815-four-shadow-lean-formalization.md) | reopened; all three gates and every replay are green with no compiled-evaluation axiom at any terminal, the four-shadow recognition theorem holds for arbitrary sign matrices with the conference switching class proved unique, and aligned-design faithfulness is formalized at the manuscript's quantifier range | formalize gap class B and the reduced weighted-Jacobian Lean bridge, then run the closeout before handing the API to C823 |
| [C816 — Paper III four-shadow integration](../clebsch-tasks/c816-paper-iii-four-shadow-integration.md) | fifth Paper III route task; begin after C800 reconciliation; manuscript promotion authorized | complete the full precedence audit, integrate the characterization and exact weighted boundary, refresh trust/release surfaces, then run Milnor--Serre, red-team, PDF inspection, and a fresh context-free cold-read regrade |
| [C810 — aligned-certificate distance](../clebsch-tasks/c810-aligned-certificate-distance.md) | complete; exact seven-point distance two and correction radius zero; no paper promotion | none; the all-even spectrum follows from edge-toggle parity, and the conference-only multi-class question is outside the triggered cheap-stop boundary |
| [C811 — quadratic-twist specialization](../clebsch-tasks/c811-quadratic-twist-specialization.md) | queued; math only; paper promotion excluded | stress-test the fibre-recovery claim and quickly delimit standard Kummer precedence before seeking a sharper geometric lemma |
| [C812 — conference cut separation](../clebsch-tasks/c812-conference-cut-separation.md) | complete; the scalar third cut moment separates all four order-26 classes; no paper promotion | none; the triple profile certifies the four values, the full histogram is unnecessary, and quotient certificate distance remains a separate alignment problem |
| [C822 — conference moment human compression](../clebsch-tasks/c822-conference-moment-human-compression.md) | complete; conference contraction forces the two-pivot plane and four direct construction counts recover the separator; math only | none; coherent pentads and spanning aligned hexads reduce further to intercalates in the Latin classes and Pasches in the Steiner classes |
| [C823 — aligned-certificate robustness Lean](../clebsch-tasks/c823-aligned-certificate-robustness-lean.md) | next Paper III route task; C799/C815 APIs and C822 human compression frozen | formalize distance polarization, parity, bowtie equality, conference balance, moment recurrence, and C822's final compression in the shared C799/C815 API |
| [C824 — Paper III aligned-certificate upgrades](../clebsch-tasks/c824-paper-iii-aligned-certificate-upgrades.md) | sixth and final current Paper III route task; begin after C816; manuscript promotion authorized | select the smallest A/B architecture, integrate the robustness/order-26 results, perform final C800/C816 trust reconciliation, then run exposition, red-team, PDF, release, synchronization, and fresh cold-read gates |
| [C880 — aligned-design query complexity](../clebsch-tasks/c880-aligned-query-complexity.md) | active; math and computation only, no manuscript edits; seven points proved sharp with a six-point witness, the exact nonadaptive minimum at seven points is 30 of 35 tests, the eight-point bracket is 30 to 44 against 53, and the adaptive side is now closed by an explicit decoder using C(n,2)+n-4 tests on every instance against the counting bound C(n,2)-n, so the adaptive constant is exactly 1/2 and the coherence restriction costs nothing to leading order, with the separation from every fixed family proved for n>=19; item 7 is drafted as ready-to-paste LaTeX against all five audit and screen constraints, and a cold referee pass on the decoder and the drafts is applied | the nonadaptive constant is the one open quantity, still between 0.616n^2 and the exhibited 3n^2, with the difference-mask route exhausted, so the routes left are a construction sharing tests between outside pairs and a structural account of the weight-four masks at general n; items 5 and 8 are untouched, and the drafted manuscript wording waits on C816, which owns promotion |
| [C813 — harmonic restriction generalization](../clebsch-tasks/c813-harmonic-restriction-generalization.md) | queued; math only; paper promotion excluded | compute bounded $A_5$-branching, Petersen-channel eigenvalues, and exact restriction scalars before pursuing a family or isolation theorem |
| [C862 — Paper III ceiling and theorem-upgrade research](../clebsch-tasks/c862-paper-iii-ceiling-upgrade-research.md) | active advisory research; report and spectral-descent/recognition theorem packet delivered; no manuscript edit and no change to the deterministic Paper III route | test characteristic three as the cheap gate for comparison with the split Mukai--Umemura model over $\mathbf Z[1/10]$; keep the theorem packet available to C816 and keep C862 open |
| [C902 — Paper III cheap-upgrade audit and wording](../clebsch-tasks/c902-paper-iii-cheap-upgrade-audit-and-wording.md) | complete; three survivors applied, determinant-line norm sign and first-use semantics repaired, four isolated reviews plus a dossier-primed referee regrade pass, and the warning-free 33-page authority is synchronized to standalone `ac0276c`; C894 remains deferred | none; C816 retains any later full four-shadow integration |
| [C863 — Series significance exposition](../clebsch-tasks/c863-series-significance-exposition.md) | complete 2026-08-03; genre-appropriate significance is explicit in Papers I, II, and IV, and Paper-III candidate language is routed into the still-open C862 report without editing that manuscript | none; Paper IV's pre-existing evidence-manifest drift remains with its formal-release owners |
| [C802 — Paper I series-framing memo review](../clebsch-tasks/c802-paper-i-series-framing-memo-review.md) | complete; red-team and second cold-read `GO` delivered to C762 | none |
| [C713 — Paper I proof architecture](../clebsch-tasks/c713-paper-i-proof-architecture.md) | complete; causal proof order, structural determinantal six-node proof, and synchronized authoritative/standalone gates green | none |
| [C714 — Paper I companion structuralization](../clebsch-tasks/c714-paper-i-companion-structuralization.md) | complete; C721--C726 integrated and synchronized release gates green | none |
| [C751 — Paper I proof-spine tightening](../clebsch-tasks/c751-paper-i-proof-spine-tightening.md) | complete; pentagon-first hybrid won the blind A/B comparison, final referee GO, both release roots green | none |
| [C752 — Paper I Lean spine audit](../clebsch-tasks/c752-paper-i-lean-spine-audit.md) | complete; transitive prose/definition audit and exact C753 packet interfaces frozen | none |
| [C753 — Paper I Lean spine closure](../clebsch-tasks/c753-paper-i-lean-spine-closure.md) | complete; R1--R4, O1--O8, manifests, and all release replays green | none |
| [C761 — Paper IV q13 passant code](../clebsch-tasks/c761-paper-iv-q13-passant-code.md) | active; structural manuscript and local release surfaces green, but public release is blocked on C834 full-Lean closure | after C834, pin the public package, run isolated replays, insert immutable locators, and seek explicit publication authority |
| [C901 — Paper IV reviewer dossier and cold-review programme](../clebsch-tasks/c901-paper-iv-reviewer-dossier.md) | active standing programme until explicit author closure; round-one remediation and mirror green; activated upgrade assessment triaged with no new claim promoted; dossier excluded from normal Paper IV and Lean context | perform the safe layered-exposition pass and separately freeze a C894-style pre-draft matrix for the four core frame-correspondence claims; keep every upgrade and re-review under C901 |
| [C817 — Paper IV structural mathematics upgrade](../clebsch-tasks/c817-paper-iv-structural-math-upgrade.md) | complete 2026-08-02; all six subitems positive and frozen; bounded novelty boundary and ranked integration memo complete; no manuscript change made | none; any manuscript selection, claim-specific novelty closure, formalization, or integration requires later user discussion and authorization |
| [C831 — Paper IV structural version](../clebsch-tasks/c831-paper-iv-structural-version.md) | complete 2026-08-02; longer title, full structural integration, evidence/trust refresh, Milnor--Serre tightening, eleven-page visual gate, and adversarial read green | none; green version returned to C761 |
| [C832 — Paper IV structural theorem Lean](../clebsch-tasks/c832-paper-iv-structural-lean.md) | complete 2026-08-02 at the declared partial-formal boundary; shared mechanisms, concrete q13 gates, aggregate terminals, and axiom audit green | none; frozen formal surface returned to C831/C761 |
| [C834 — Paper IV full Lean release closure](../clebsch-tasks/c834-paper-iv-full-lean-release-closure.md) | active; the shared library, the paper package's minimum-word layer, the association-transport packet and algebra, the weight-ten aggregate's own leaves, the ambient-plane join and meet, the equivariance transporter with the structural upgrade's support-family leaves, row uniqueness, and now the arc property of the minimum-word supports are closed, leaving 77 of the audit's 88 terminals clean | close the remaining native decisions — the fourteen weight-ten profile shards, the automorphism anchors, and the fixed-point exhaustion, which is gated on proving that an arbitrary weight-twelve codeword meets every passant in zero or two points — then build the release surfaces and reverse the pre-release accommodations listed in the task card |
| [C857 — Paper IV Lean standards closure](../clebsch-tasks/c857-paper-iv-lean-standards-closure.md) | queued after C834; exhaustive audit checklist allocated before C761 release | consume C834's formal API, close every trust, statement, transcript, allowlist, documentation, citation, provenance, and clean-checkout gap, then run the rejecting release verifier |
| [C577 — Paper II](../clebsch-tasks/c577-factorization-paper.md) | complete; manuscript, repeated human-proof and exposition review, warning-free 45-page authority, portfolio copy, and clean unpushed standalone export closed | none; C892 owns formal/trust closure before any public forward release |
| [C895 — Paper II modular human-proof repair](../clebsch-tasks/c895-paper-ii-human-proof-repair.md) | complete; targeted detector repair, full root-action seam, Faber exhaustion, endpoint intrinsicity, load-bearing Appendix A, abstract and terminology repair, trust metadata, warning-free 43-page PDF, and fresh full-paper human-proof PASS | none; C892 owns formal/trust closure and C577 later owns publication packaging |
| [C896 — corrected universal finite-group socle theorem](../clebsch-tasks/c896-corrected-universal-socle-theorem.md) | queued future mathematics; independent of Paper II and excluded from its repair path | run \(q=9,25\) and exponent-three state reconnaissance, then attempt a carry/borrow theorem only if the bounded data support one |
| [C892 — Paper II Lean and trust-boundary review/remediation](../clebsch-tasks/c892-paper-ii-lean-trust-boundary-review.md) | reopened by explicit user instruction; prior **MAJOR / NO-GO** report is the acceptance baseline | close the cheap trust-boundary defects first, freeze exact manuscript-level formal interfaces, then prove every remaining assertion and export/synchronize one complete four-gate successor boundary before fresh referee closeout |
| [C856 — Paper II Lean standards closure](../clebsch-tasks/c856-paper-ii-lean-standards-closure.md) | complete 2026-08-02; the fixed-line premises are derived rather than assumed, every scholarly-public declaration in the fifty-six-file project-owned closure is documented, a stale expected statement count now fails verification, and the four gates and full release aggregate are green | none; the C860 shared-cap debt is cleared and C577 owns repackaging |
| [C860 — shared projective-cap closure remediation](../clebsch-tasks/c860-projective-base-dependency-inversion.md) | complete 2026-08-03; cap-game modules out of the paper closures, five residual geometry modules documented, four Paper II gates green; full base-module inversion explicitly not performed | none; the stale AME/LU release manifest predating this work awaits an `ame-lu` lane decision |
| [C746 — Paper II projective--trade reduction](../clebsch-tasks/c746-paper-ii-projective-trade-reduction.md) | complete; human proof 1/4 | sheet-sign kernel reduced invariantly to the quadratic pullback obstruction |
| [C747 — Paper II socle and first wall](../clebsch-tasks/c747-paper-ii-socle-wall-proof.md) | complete; human proof 2/4 and independent modular read green under C748 | none |
| [C748 — Paper II Serre proof integration](../clebsch-tasks/c748-paper-ii-serre-proof-integration.md) | complete; parity-specific proof has independent modular and context-free `GO` verdicts; human proof 3/4 | none; C749 owns final adversarial freeze |
| [C749 — Paper II adversarial human closure](../clebsch-tasks/c749-paper-ii-adversarial-human-proof.md) | historically complete; its theorem-surface freeze was superseded and repaired by C895 | none; C895 closed the reopened human proof |
| [C750 — Paper II structural Lean](../clebsch-tasks/c750-paper-ii-structural-lean.md) | complete; 22-terminal structural gate, axiom audit, trust map, evidence fingerprint, and authoritative aggregate green | none |
| [C797 — Paper II trade-only carrier reconstruction](../clebsch-tasks/c797-trade-only-carrier-reconstruction.md) | complete; carrier-free theorem fails sharply at \(q=7\) | none; seven \(S_4\)-fixed affine placements share the trade and only one is a matching orbit |
| [C798 — Paper II fixed-line Chow rigidity](../clebsch-tasks/c798-fixed-line-chow-rigidity.md) | complete; structural priority-judo theorem integrated and authoritative gate green | none; \(q-2\) nonmatching exact-trade orbits and the unique matching Chow point are proved without an orbit table |
| [C801 — Paper II fixed-line Lean update](../clebsch-tasks/c801-paper-ii-fixed-line-lean.md) | complete; table-free radial inheritance, sheet-sign annihilator, and \(q-2\) count are kernel-checked | none; the unique Chow point remains the human finite-group/factorization boundary |
| [C803 — Paper II fixed-line literature audit](../clebsch-tasks/c803-paper-ii-fixed-line-literature-audit.md) | complete; exceptional one-factorizations attributed, C494 boundary recorded, exposition and release gates green | none; C801 owns the Lean update |
| [C762 — Paper I forward exposition](../clebsch-tasks/c762-paper-i-forward-exposition.md) | complete; structural q11 boundary, O1--O8 alignment, 22+12-page PDFs, manifests, and standalone release green | none |
| [C763 — Paper III Golden consolidation](../clebsch-tasks/c763-paper-iii-golden-consolidation.md) | complete; selective source--operator--cubics--harmonic chain, formal bridge, cold reads, and synchronized release gates green | none |
| [C764 — Paper III “why determinant” boundary](../clebsch-tasks/c764-paper-iii-why-determinant.md) | complete; determinant-line explanation and explicit permanent gauge counterexample integrated; isolated authoritative and synchronized standalone release aggregates green | none; keep the physical companion outside Paper III until it has a stable public locator |
| [C744 — Paper III proof-spine structuralization](../clebsch-tasks/c744-paper-iii-proof-spine-structuralization.md) | complete; pinching, Gram, torsor, harmonic-scalar, blind A/B acceptance, EJ/EJ2, and synchronized release gates green | none |
| [C745 — Paper III current-theorem Lean formalization](../clebsch-tasks/c745-paper-iii-current-lean-formalization.md) | complete; Paper-III-only structural gate, 34-declaration audit, five-row honest boundary, clean replay, and standalone synchronization green | none; C287 owns later reviewed extraction/tagging only |
| [C733 — Paper III canonical orientation bridge](../clebsch-tasks/c733-paper-iii-canonical-orientation-bridge.md) | complete; strongest theorem is explicitly relative to the full marked datum, with ambiguity ledger and final `GO` | none; C763 owns any forward integration |
| [C730 — Paper III orientation source](../clebsch-tasks/c730-paper-iii-orientation-source-theorem.md) | complete; normalized-cover theorem, involution ledger, harmonic comparison, and integral boundary frozen | none; C763 owns forward manuscript integration |
| [C682 — Hitchin--Clebsch exploration](../clebsch-tasks/c682-hitchin-structural-exploration.md) | active; exact optimal finite code ladder \(E_8:[120,9,56]\to E_7:[28,7,12]\to E_6:[27,6,12]\); Paper-IV reconstruction ladder complete; the first unrestricted column-completion gate is impossible | user decision: test the signed 56-root phase fold, start the affine \(E_9/E_{10}\) transfer lift, select the optional preprojective successor, or promote the code ladder |
| [C705 — adjugate Segre--Igusa polar](../clebsch-tasks/c705-adjugate-segre-igusa-polar.md) | complete; adjugate factorization, global \(E_6\) first-normal jet, characteristic-zero Coble Hessian normalization, affine-\(E_8\) mixed potential, Lie-\(E_8\) Pfaffian parent, frozen orbit mechanism, and all \(720\) ordered sheets proved/computed | none; the residual \(S_5\)-torsor records unavoidable noncanonicity, not unfinished work |
| [C706 — equivariant Clebsch--Clifford lift](../clebsch-tasks/c706-equivariant-clebsch-clifford-lift.md) | complete; full \(S_6\) Clifford extension nonsplit, conference \(S_5\) split with two classes, golden \(A_5\) split with four classes, distinguished conference twist nonzero and nonextendable \(A_5\to S_5\), scalar multiplier trivial; six conjugate local \(S_5\) charts meet pairwise in \(S_4\) but do not glue | C708 tests the outer exchange between the chart \(1+5\) action and the transitive axis/polarity six-action; no direct bijection exists |
| [C707 — golden ETF measurements](../clebsch-tasks/c707-golden-etf-quantum-measurements.md) | complete; cubic outer phase code, lossless three-fermion scattering, signed \(K_{3,3}\) Majorana optimum, and anomaly-charge transducer proved; physics novelty audit recorded | none |
| [C708 — doily incidence codes](../clebsch-tasks/c708-doily-incidence-codes-and-bad-primes.md) | complete; outer exchange positive at representation level, no canonical involutory polarity, exact code tables closed | none |
| [C709 — six-Majorana lift](../clebsch-tasks/c709-clebsch-majorana-k6-lift.md) | complete; two-graph flux and chiral commutator family survive, quadratic refinement and intrinsic spin structure do not | none |
| [C710 — \(E_8\)--Hamming marking](../clebsch-tasks/c710-e8-hamming-code-marking.md) | complete; bare \(E_8\) isometry positive, simultaneous Clebsch marking obstructed, hyperbolic \(II_{10,10}\) repair exact | none |
| [C711 — Paper III sub-700 human proofs](../clebsch-tasks/c711-paper-iii-sub700-human-proofs.md) | complete; seven certificate-independent proofs, per-proof Tao checks, and frozen interfaces | none |
| [C756 — all-\(k\) conic-filling classification](../clebsch-tasks/c756-all-k-conic-filling.md) | active open math.  The full \(k=12,13,14\) layers are impossible over every finite field.  Saturated power rungs untwist to \(\mathbb M_R\); the only row-count-forced kernels, \(q=25,27,81\), are now closed as fields by an exhaustive oriented-coherence census covering every odd prime power \(q\le127\) and \(q=169\).  That census graph is a Cayley graph on \(\mathrm{AGL}(1,q)\) of proved degree \((q^2-1)/4\) whose clique ratio bound is \(4/3\) of the required size, so a \(25\%\) improvement of it would close the saturated-internal branch for all \(q\).  The non-shadow gate is mixed in characteristics three and five but a pure quotient quadratic for \(p\ge7\).  Nonsaturated trace splits into zero and parity carriers and is now a divisor trace on the branched quadric \(\mathscr X_\eta\). | do not open a \(k=15\) census and do not extend the coherence census; compute the \(\mathrm{AGL}(1,q)\) coherence spectrum in closed form and attack its \(4/3\) clique-bound shortfall, or prove the determinantal/quadratic saturated gates; the nonsaturated quadric divisor-trace law is unchanged |
| [C894 — unnumbered saturated-exterior/local-Paley companion](../clebsch-tasks/c894-saturated-exterior-paley-companion.md) | active; the two-theorem claim--proof--citation matrix is frozen.  Haemers--Parsaei Majd 2022 closes generic Seidel-to-conference bordering attribution; the exact mixed collision remains a qualified engine, the tournament-square/golden-sequence refinement remains attribution-only, and the \(q=11\) forgetting/reconstruction endpoint remains distinct from the open all-\(k\) branches.  No manuscript exists. | send the narrowed institutional-index and external-specialist packets, record exact coverage and verdicts, then decide title/venue; drafting stays blocked until both human safeguards return |

C756 optional stuck-state/review reading:
[`c756-proof-expert-dossier.md`](../clebsch-tasks/c756-proof-expert-dossier.md).

C321 remains conditional and is not triggered: the final Paper I review found
no missing proof obligation. C552 remains fallback-only and must not displace
the split-paper route without an explicit user decision.

## Paper I

**C855 authority invariant.**  Shared Lean is edited only in
`~/src/othello/lean`; finitegeom is exporter-only and never edited directly.
The q11 package owns only package-private certificate material.

The authority/export repair is complete: source `374d1c3e` supplies the exact
rigidity and orientation facts, finitegeom adopts their sequential exporter
deltas at `7309faa` and `b871c10`, and both final replays are zero-delta.

Paper I and its companion *Computational strengthenings of Clebsch syndrome
rigidity* form one warning-free, nineteen-row release surface with twenty-six
checks and page counts \(22+12\). C714 is complete: the companion currently
records five modes—human structural proof, published theorem, Lean theorem,
finite certificate, and trusted execution. C855 is now the live Paper I gate:
it must replace every mathematical boundary in that five-mode ledger by a
kernel-checked Lean theorem and close the complete scholarly-artifact audit
before the next release is called theorem-complete.

Both declared Dye inputs are now closed, and the Paper I rigidity gate carries no
non-standard axiom at any terminal. The ten-point bound on triple-concurrence
points is a proved theorem over any field in which two is invertible, and the
equality classification is a proved theorem at order eleven; both permitted-axiom
entries are deleted, so `lean/trust/areas/relconic.toml` permits no axiom. Two of
the classification's inputs are proved over an
arbitrary field: two triangles in double perspective are in triple perspective,
and a hexagon whose four named chord triples are concurrent has the golden
normal form `(1:0:0), (φ:1:1), (0:1:0), (1:φ:1), (0:0:1), (1:1:2−φ)` with
`φ² = φ + 1`, so the ground field contains a golden root. The shared
frame-coordinate helpers are promoted into `FrameCoordinates`, and the
perspectivity module now compiles against that compiled dependency rather than
a scratch copy. The chord-pairing dictionary is also closed: counting
triple-concurrence points of a six-arc is counting its concurrent chord
matchings, by a bijection proved in `SixArcChordMatchings` over an arbitrary
finite projective plane. The equality structure follows from that dictionary by
counting alone, without the perspectivity theorem: `SixArcOneFactorization`
proves that at ten triple-concurrence points every chord lies in exactly one
non-concurrent chord matching, that there are five of them, and that they share
no chord, so they partition the fifteen chords. An adversarial review confirms both
commits and settles the remaining route's feasibility by exhaustive
computation: the hexagonal labelling is now proved in
`SixArcHexagonalOrder`: two chord matchings of a six-element set with no common
chord close a hexagon, purely combinatorially. The plane-level assembly is also
closed. `SixArcGoldenNormalForm.exists_golden_frame` proves that a six-arc with
ten triple-concurrence points, over any finite field in which two is invertible,
is the golden hexagon `(1:0:0), (φ:1:1), (0:1:0), (1:φ:1), (0:0:1), (1:1:2−φ)`
in a suitable frame, with `φ² = φ + 1`; so the ground field contains a golden
root whenever such an arc exists. Two factors of the one-factorization give the
hexagonal labelling, the relabelling that sends the last three points to
`p₅, p₆, p₄` makes each of the four matchings the normal form consumes share a
chord with a chosen factor while differing from it — hence not a factor, hence
concurrent — and the non-collinearity hypotheses come from the arc condition
together with the fact that the line joining a chord endpoint to an off-arc point
of that chord is the chord itself. The prism-uniqueness step and the
perspectivity theorem are both off the critical path and unused. The order-eleven
step is also proved: `φ = 4` or `φ = 8` in the field of eleven elements, and each
root has its own explicit projectivity, of determinant three, carrying its golden
hexagon onto the displayed witness. All eight new modules are now reached by the
rigidity gate through the converted classification, whose build log carries no Dye
axiom, `sorry`, or compiled-evaluation axiom at any of its 201 axiom reports.
The manuscript-relative Lean names are also replaced: the eleven orientation
modules now carry a `SupportOrientation` stem, the trace-dual gauge bridge no
longer names its declarations after the paper's display, the rational-commutant
terminal names the algebra it equals, and the chosen six-point labelling no longer
claims canonicity. The rigidity gate is green after those renames and the spine's
trust fact is re-extracted under its new unit name, with 24 terminals and no
project axiom.

The extraction route for that material now exists. `RelativeConicArcs.SixArcConcurrenceSpine`
is an import-only module over the concurrence bound, the chord-matching and
one-factorization combinatorics, the golden normal form, and the order-eleven
identification; `lean/trust/areas/relconic.toml` declares it as a gate with eleven
terminals, the module elaborates, and its closure covers ten modules that no unit
reached before. It is exported as a companion boundary of its own,
`lean/trust/export/clebsch_six_arc_concurrence.toml`, rather than through the
golden-orientation boundary, which shares no module or terminal with it and whose
correspondence text now names the six-arc boundary as the place the bound and the
classification are proved; the two must therefore be exported in the same round.
The facts artifact is extracted and committed: 26 modules, eleven terminals, every one
carrying only `propext`, `Classical.choice` and `Quot.sound`, and no project axiom.
The downstream finitegeom repository's `TARGET_MANIFEST.json` disagreed with its own tree in four entries
and is repaired, and both boundaries are exported and adopted there as forward commits,
with the eleven superseded manuscript-named orientation modules removed in the same
round. Both gates build in the base and their audits carry no project axiom. One check
is outstanding: the build confirming that the four shared modules the export moved
forward break no previously green base gate has not completed, because another lane
holds the shared tree. Separately, the base does not pass its own published replay —
`ProjectiveCap.Binary` and `ProjectiveCap.EllipticMirror` fail on an
`InitialPStatement` whose defining module the base never carried — and those failures
reproduce with this round reverted, so repairing that half-migrated projective-cap
layer is its owner's work, not Paper I's. In the downstream finitegeom repository the order-eleven specializations
remain axioms of `RelativeConicArcs.Q11DyeAxioms`; replacing them by proofs of the
exported theorems is forward work under the re-pin. Seven consumer modules of the wider order-eleven rigidity development — the defect
bridge, the degenerate-conic exclusion, perspectivity, the two prism modules, and the
rigidity spine and code bridge — are still reached by no unit and are left visible as
errors rather than declared away. Report:
[`../2026-08-05-c855-six-arc-extraction-gate.md`](../2026-08-05-c855-six-arc-extraction-gate.md).

Also still open on this surface: the tracked audit
`lean/verification/clebsch_rigidity_trust/axiom-audit.txt` cannot be refreshed
here at all, because four of its 52 rows are package-only `Q11A5PointOrbits` terminals, so
it is the package gate's output, not this repository's. `trust/PORTFOLIO.md` and
`trust/graph-manifest.json` are stale against regeneration and were stale before
this work. `RelativeConicArcs/Q11DyeAxioms.lean` now declares no axiom, so its
name and the `ClebschDye` namespace remain for a rename coordinated with the
package. Records:
[`../2026-08-04-c855-dye-bound-formalization.md`](../2026-08-04-c855-dye-bound-formalization.md)
and
[`../2026-08-04-c855-dye-axiom-elimination-plan.md`](../2026-08-04-c855-dye-axiom-elimination-plan.md),
with the two new proofs reported in
[`../2026-08-04-c855-triple-perspective.md`](../2026-08-04-c855-triple-perspective.md)
and
[`../2026-08-04-c855-golden-normal-form.md`](../2026-08-04-c855-golden-normal-form.md),
the chord-pairing bijection in
[`../2026-08-04-c855-chord-pairing-bijection.md`](../2026-08-04-c855-chord-pairing-bijection.md),
the equality structure in
[`../2026-08-04-c855-one-factorization.md`](../2026-08-04-c855-one-factorization.md),
the review with its committed replay programs in
[`../2026-08-04-c855-dye-formalization-review.md`](../2026-08-04-c855-dye-formalization-review.md),
the hexagonal labelling in
[`../2026-08-04-c855-hexagonal-order.md`](../2026-08-04-c855-hexagonal-order.md),
the plane-level assembly in
[`../2026-08-04-c855-golden-hexagon-assembly.md`](../2026-08-04-c855-golden-hexagon-assembly.md),
the order-eleven identification with the axiom retirement in
[`../2026-08-04-c855-order-eleven-witness-identification.md`](../2026-08-04-c855-order-eleven-witness-identification.md),
and the name remediation in
[`../2026-08-04-c855-orientation-name-remediation.md`](../2026-08-04-c855-orientation-name-remediation.md).

The 2026-07-30 v2 referee cold-read revisions are complete.  The rational
\(A_5\)-module wording, theorem hierarchy, computational/formal boundary,
q13 and two-graph literature, opening, conclusion, and minor editorial
points are repaired.  The extracted q11 package now ships the aggregate
orientation axiom audit, and both authoritative and standalone trees pass
all eighteen release checks.  Full closeout:
[`../2026-07-30-c182-paper-i-bounded-revision.md`](../2026-07-30-c182-paper-i-bounded-revision.md).

The load-bearing theorem package reconstructs the Clebsch code from the
weight-six deep-hole syndrome locus and closes the terminal fields
q=13,17,19 by exact passant-edge-orbit searches. The shared
`deep_holes = conic` fact remains pinned to the standalone Lean repository;
the paper does not inherit trust from the fallback mega-paper gate.

C690 is complete as v2 exploration. The syndrome locus reconstructs the
unordered support-orientation torsor; on the frozen common marking its
exchange is support complementation, Gale duality, and golden conjugation,
and its first signed moment is cubic. C611 now closes the q=13 binary
minimum-distance gate by proving the exact value \(d=12\). Segre tangent
triples exclude weight eight: after one point is fixed, a cyclic 42-vertex
compatibility graph has clique number five,
while a weight-eight word would require a seven-clique. The proof is a
six-difference-set, five-row unique-closure lemma, not a support search. It
then excludes the two forced weight-ten pencil profiles and constructs a
dihedral weight-twelve word. All \(364\) minimum words split into one
\(S_4\) and three \(D_{24}\) projective orbits, and their pair concurrence
reconstructs passant versus secant join type. Triple-concurrence profiles
recover all six elliptic orbitals, and the \(78\) all-zero-triple
seven-cliques are exactly the passant incidence rows. Hence the minimum
layer self-reconstructs \(M\). Every minimum-word orbit independently spans
the full code, and the common code/hypergraph/scheme automorphism group is
exactly \(\operatorname{PGL}(2,13)\). The mod-two association algebra
identifies the four orbit Grams with \(A_9,A_9,A_{12},A_{10}\) and
conceptually forces their rank \(36\). It
does not prove the unsaturated \((7,13)\) case or the stronger maximum-six
claim, and it is not reached by C665's defining-characteristic trade
machinery. The
twelve-point Schläfli identification fails equivariantly, but both objects
map to the same six-axis \(A_5/D_5\) carrier: Paper I is its twisted
transitive two-cover and the double-six is its split two-cover. On the
twisted cover, the fibre-odd module is \(3\oplus3'\), and the difference
of the two five-orbital operators squares to \(5\) after normalization.
Thus the continuation locus intrinsically reconstructs the golden quadratic
algebra and its conjugation. Its natural fibre-odd integral commutant is
the conductor-two order \(\mathbf Z[\sqrt5]\), whose mod-\(2\) fibre is a
dual-number point and whose normalization has fibre \(\mathbf F_4\).
The signed continuation operator is exactly C682's golden Gram conference
matrix up to a signed permutation. Hence this is the same conductor defect
on the golden six-axis algebra. It is not the whole reason \(2\) is bad for
C682: the boundary operator, apolar form, and Mukai--Umemura geometry remain
bad after normalization. Locally, the \(2\)-defect and the cross-Gram
defects at \(11,23\) are the same order
\(\mathbf Z_p+p\mathcal O_p\), with inert, split, and inert normalized
fibres respectively.
The first open all-size full-conic gate is \(k=9\) over \(q=23,25\).
C691 is complete with a positive bridge.  If \(B\) is either signed
continuation orbital on the fibre-odd six-axis lattice, then
\[
 c_{ijk}=B_{ij}B_{jk}B_{ki}
\]
is exactly the support-orientation cubic.  Switching axis representatives
does not change the triangle products, orbital exchange negates them, and
the four-point two-graph identity reconstructs \(B\) up to switching.
Thus the cubic line and the golden operator \(B^2=5I\) are two
presentations of one integral orientation torsor.  Modulo \(2\), all signs
coalesce and \(B-I\) becomes rank-one square-zero, matching the
conductor-two degeneration.  More strongly,
\[
 \det(B+\operatorname{diag}x)=e_6-e_4+5e_2-125-2C_B,
\]
so the cubic is the sole nonsymmetric layer of the golden diagonal
determinant pencil, and complementary minors derive support complementation
from \(B^2=5I\).  Its homogenized conjugation-odd part is
\(F_B(x,z)-F_B(x,-z)=-4z^3C_B(x)\), while the off-diagonal equations in
\(B^2=5I\) force all signed moments below degree three to vanish and make
the cubic descend to the augmentation five-space.  Conversely, the
two-graph identities reconstruct \(B\), pair balance is equivalent to
\(B^2=5I\), and a gauge-fixed balance argument makes the positive graph on
the other five vertices a pentagon.  Hence the cubic alone forces the
unique golden conference switching class.
As a final intrinsic upgrade, the cubic threefold on the augmentation
projective four-space has exactly six singular points
\([\mathbf1-6e_a]\), all ordinary nodes.  They form a projective frame, so
the cubic itself reconstructs the six-axis carrier and its full projective
automorphism group is the computed outer \(S_5\) of order \(120\).
C693 integrates this complete package in the human paper and integrates
C611's \(q=13\) tangent-code theorem in the computational companion.  The
nineteen-row, eighteen-check Paper I trust surface is paper-owned and has no
Paper III dependency; the approved v1 baseline remains frozen.
C713 is complete.  Chord defect, the line bound, rigidity, and the
across-fields consequence now form one uninterrupted proof before the decoder
and orbit ledger.  The orientation proof exposes its six causal stages and
derives the orbital square from the exact (10,-10,0,0) common-neighbor
count.  Singular-locus completeness is no longer a Gröbner dependency: the
cross-golden determinant is ( -C), its trace dual is the smooth Clebsch
diagonal cubic surface, and Hassett--Tschinkel's determinantal converse gives
exactly six ordinary nodes.  CTZ remains exact model identification only.  The
old five-chart exhaustion is an independent replay, all q11 terminals and the
two Dye axioms are unchanged, and both authoritative and standalone
twenty-one-page release surfaces pass all eighteen checks.  Full report:
`notes/2026-07-31-c713-paper-i-proof-architecture.md`.
C751 is complete.  Its first blind comparison rejected an overcompressed
trace-dual revision; the resulting pentagon-first hybrid restored the
full trace complement, proved orbital self-pairing and fibre incidence,
expanded both golden-square cancellations, qualified Dye locally, and then
won the second blind comparison.  The same referee returned final GO,
and both authoritative and standalone twenty-six-check releases are green.
C752 is complete.  It confirms exact same-mechanism correspondence for the q11
chord-moment/equality trap, isolates the affine equality-case and degenerate-
conic seams, distinguishes displayed-witness code checks from arbitrary-arc
reconstruction, and shows that Paper I's orientation spine remains human proof
plus exact replay rather than a paper-specific Lean theorem.  Its completed
transitive prose census freezes four rigidity interfaces and eight bounded
orientation packets for active C753.  Full reports:
`notes/2026-07-31-c751-paper-i-proof-spine-tightening.md` and
`notes/2026-07-31-c752-paper-i-lean-spine-audit.md`.
C722 is complete with neither bounded clique branch promoted.  For q9 the
Sylvester distance-two graph has spectrum
(20^1,4^9,(-1)^{16},(-4)^{10}); Delsarte gives six, while equality forces
(A_3\chi=2(1-\chi)) and remains feasible in the intersection algebra.  For
q13 all fourteen character blocks of the three-orbit circulant graph are
diagonalized exactly; adjacency/complement inertias are ((19,23,0)) and
((22,20,0)), and the strongest exact dual found is a six-coloring.  The
published q9 value and q13 five-row unique-closure proof remain load-bearing.
The exact Fourier bundle passes to C723.  Full report:
`notes/2026-07-31-c722-q9-q13-clique-structure.md`.
C723 is complete with a precise finite boundary.  Pencil parity forces only
the profiles (3,1^6) with no secant neighbor or (1^7) with two secant
neighbors; globally the induced secant graph has degrees zero or two.  This
first association layer is feasible, while the two profiles respectively
lose the arc and local-clique hypotheses needed for the Segre tangent route;
binary parity also supplies no characteristic-(13) root-multiplicity bridge.
The raw (6{,}531{,}840)- and (166{,}561{,}920)-support domains are now two
canonical XOR-disjointness certificates with a separate full-fibre dynamic-
programming replay.  C725 inherits these as the frozen q13 weight-ten proof
objects; C726 alone owns trust integration.  Full report:
`notes/2026-07-31-c723-q13-weight-ten-profiles.md`.
C724 is complete.  The q11 fifteen-class census is now an orbit ledger with
canonical representatives, stabilizers, masses summing to 1548, concurrence
counts, chord-defect uncovered sizes, and conic-intersection histograms.
Fourteen nonsingular cubic minors replace the non-Clebsch row reductions, while
the Clebsch kernels are generated by (Q) and (QX,QY,QZ).  The q11/q13
size-(q+1) seven-arc leaves collapse to one and two projective orbits, with
three nonsingular quadratic minors and masses (140) and (840+840).  The
full normalized enumerations remain byte-identical audits, and the failed
first-order LP is frozen at the exact smaller-pencil optimum.  C725 inherits
these finite proof objects.  Full report:
`notes/2026-07-31-c724-paper-i-finite-census-compression.md`.
C725 is complete.  All q13/q17/q19 passant edges split into 10/13/15
projective root orbits, and their complete root-stabilizer extension DAGs have
604/4,442/11,260 nodes.  Every transition orbit, rooted/global mass identity,
and per-point terminal blocker assignment is directly checked.  The maximum
six-arcs form 2/22/94 projective orbits with 546/50,184/395,124 labelled
representatives and explicit witnesses.  A separately specified
increasing-index backtracker reproduces every labelled level without group
actions or canonical keys, while the older C++/discriminant replay remains a
third check.  The final C723/C724/C611 claim-to-proof-mode manifest is frozen
for C726; no all-field theorem is claimed.  Full report:
`notes/2026-07-31-c725-terminal-passant-orbit-dag.md`.
C726 is complete and closes C714.  The C721--C725 structural proofs and finite
leaves are integrated into the companion with a thirteen-claim five-mode
ledger.  The q11 orbit ledger, local determinant witnesses, q13 XOR
certificates, and q13/q17/q19 root-edge DAG are public paper-relative proof
objects; exhaustive normalized, conic, minimum-layer, labelled, and legacy
replays retain the trusted-execution boundary.  The q11 formal package is
pinned at `42ab1a2db30178cf23aa8393d886c63ded24bfbd` with a tracked exact axiom
audit; no finite classification or orientation theorem is mislabeled as Lean.
Both authoritative and standalone roots pass all twenty-six checks with
release-surface hash
`1ce03fc22f0a9857f3b62fd070ea3e42ad64350c6d2c01b57eeaa17c1714b04f`.
Full report: `notes/2026-07-31-c726-paper-i-companion-integration.md`.
C611 is complete.  At q=17 and q=19 the maximal passant six-arcs form
respectively 22 and 94 projective orbits, all with empty extension sets.
Pair inner distributions distinguish every q=17 orbit and 92 of 94 q=19
orbits; triple distributions separate the remaining two pairs.  This is a
finite coherent compression, not a uniform theorem.  Pair-only coherence
cannot see the ternary arc condition, and the natural root-edge rational LP
has exact feasible objectives 7--8 and 8--9 against the required bound 4.
Its uniform failure is the residual-pencil product: after fixing a passant
edge, the candidate set is the Cartesian product of the two endpoints'
remaining passant-line pencils.  The resulting feasible objective is at
least \((q-3)/2\), so this first-order dual route fails for every odd
\(q\ge13\).  Summing the line constraints in the smaller pencil gives the
matching dual bound, so the LP optimum is exactly the smaller pencil size.

Local aggregate replay:

```sh
cd papers/clebsch-rigidity
nix develop --command python3 verification/verify_release.py \
  --lean-root /absolute/path/to/finitegeom-clebsch-q11-certificates
```

## Paper II

Paper II is standalone: no proof dependency on Papers I or III.  Its frozen
v1 baseline remains unchanged, while C694 has integrated the accepted v2
arc.  A two-valued one-dimensional strength-two trade now derives the
balanced \(q+q\) one-factorization sheets; the uniform Frobenius-digit
criterion and local first-wall spill close the extension-field cases.  The
resulting exact \(B_3/\F_7\), \(H_3/\F_{11}\) classification uses only the
two-valued quadratic-trade condition.  Rodr\'iguez-Pajares--Ruano--Salizzoni
(2025) pre-empt the general self-associated/Schur-square/Gorenstein mechanism;
Paper II turns that blocker into a reverse rigidity theorem, classifying the
matching orbit and recovering the sheet-sign cubic from the two-valued trade,
with Gorensteinness stated as a credited consequence rather than a priority
claim.  The bounded extraction and source audit are recorded in
`notes/2026-08-02-c577-paper-ii-priority-extraction.md`.  The canonical replay
constructs only \(S,T,R,Y\), with q=121 and q=169 retained
as corroboration.  One edge-selected alternating cycle and Dickson
recurrence prove radial nonvanishing for both \(B_3\) and \(H_3\).  The
Paley carrier explains the cross-sheet orientation but is not used as the
Gorenstein pairing: it misses the radial/common-sum pair by one dimension.
Maximal-isotropic quotient duality gives that pairing directly.

C797 closes the stronger reverse-reconstruction question negatively.  In the
\(q=7\) affine module, the \(S_4\)-fixed locus is a line of seven points whose
seven size-\(14\) orbits all have the unique two-valued trade, while only one
lies in the matching image.  The trade recovers the homogeneous sheet module
but not its matching embedding.  Complete reducibility of one lift is the
nearest exact repair.  Full report:
`notes/2026-08-02-c797-trade-only-carrier-obstruction.md`.

C798 turns that failure into the sharp positive boundary theorem.  For both
\((q,K)=(7,S_4),(11,A_5)\), the stabilizer-fixed locus in the ambient conic
fiber is an affine line, its rational points give distinct \(G/K\)
placements, and the secant-product Chow locus meets it only at the matching
point.  Radial translation leaves the top sheet data unchanged and changes
only the outer radial constant, so Radical--Hadamard proves that all but one
parameter have the exact sheet-sign trade.  This gives \(q-2\) nonmatching
counterexamples structurally, with no seven- or eleven-orbit table in the
paper spine.  The single coalescence point is non-load-bearing.  The exact
eleven-orbit census is retained only in the C798 research bundle.  C801 is
queued for the reusable Lean abstraction after statement freeze.  Full
report: `notes/2026-08-02-c798-fixed-line-chow-rigidity.md`.

C801 is complete.  The reusable two-sheet radial interface, affine outer
constant and unique coalescence parameter, noncoalescent Radical--Hadamard
inheritance, exact sheet-sign annihilator, and \(q-2\) finite-line count are
kernel-checked without an orbit table.  The Paper II structural gate now has
twenty-nine terminals, the four-gate axiom audit has fifty-five terminals,
and the complete warning-free release aggregate is green.  The fixed-space,
stabilizer, block-system, and unique Chow-intersection arguments remain
explicitly human and classical.  Full report:
`notes/2026-08-02-c801-paper-ii-fixed-line-lean.md`.

C856 is complete.  The fixed-line family no longer assumes the three
parameterwise Radical--Hadamard premises: each evaluation space is presented as
a parameter-independent top space together with the constant function and the
radial level, the space is proved unchanged between parameters with nonzero
outer constant, and the premises are imposed at the reference parameter alone
and derived elsewhere.  Identifying the geometric evaluation spaces with that
presentation is now stated as a human input in the module header, gate header,
manuscript, and trust manifest.  Every scholarly-public declaration in the
fifty-six-file project-owned four-gate closure has a self-contained docstring,
and the release runner derives its expected metadata line and rejects a stale
statement count.  The structural gate has twenty-nine terminals and the
four-gate axiom audit fifty-five, all on the foundational allowlist; the
complete authoritative aggregate is green.  The shared-module defect recorded there is now closed: C860 (2026-08-03)
removed the cap-game modules from the paper closures and documented the five
residual `ProjectiveCap` geometry modules, so the artifact is referee-ready on
its full transitive closure.  An independent review confirmed every C856
claim: `notes/2026-08-03-c856-review-verification.md`.  Full reports:
`notes/2026-08-02-c856-paper-ii-lean-standards-closure.md` and
`notes/2026-08-03-c860-cap-closure-remediation.md`.

The paper-owned trust surface has twenty-nine statements and fourteen
evidence bundles, including independent generic-wall, shared-radial, and
q=9 small-field replays.  C749 closed the reopened human-proof gate after an
adversarial cold **MAJOR**, localized repairs, a fresh **MINOR** transparency
pass, and a final context-free **GO**.  The complete divided-power seam,
finite-torus alias elimination, affine polynomial/point-vector bridge,
transitive-dihedral and endpoint actions, exact \(p'\)-subgroup exhaustion,
and exceptional fusion locator are now explicit.  C750 and C801 already
close the corresponding structural and table-free radial Lean surfaces.
The warning-free authoritative PDF and full release aggregate are green.
The standalone repository is synchronized locally at `2245993`, verified
against authority `9af3eb45`, and unpushed.  C892 owns the separate
theorem-complete formal/trust remediation required before any public forward
release.  The opening, proof roadmap, conclusion, README, and appendix
transition have also passed a statement-preserving Milnor--Serre copy edit.
Audit and closure reports:
`notes/2026-07-31-c577-paper-ii-new-math-audit.md`,
`notes/2026-07-31-c747-paper-ii-socle-wall-proof.md`,
`notes/2026-07-31-c748-paper-ii-serre-integration.md`, and
`notes/2026-08-02-c749-paper-ii-adversarial-human-proof.md`, and
`notes/2026-08-02-c577-paper-ii-milnor-serre-copy-edit.md`.
C682 characteristic-zero work is inventory unless
explicitly promoted.

Local aggregate replay:

```sh
cd papers/clebsch-factorization
python3 verification/verify_release.py
```

## Paper III

Paper III's forward version is *Golden descent and operator realizations of
the Clebsch cubic*.  C763 inserts the selective conference,
middle-exterior, commutator-Pfaffian, cross-golden determinant,
Joubert--Segre, and Segre--Igusa chain between the square-class source and
the degree-six harmonic return.  Its exact trust surface has seven rows and
a new ring-general fixed-conference Pfaffian bridge; the broader Golden
application inventory remains excluded.  C764 adds only the local reason for
the determinant: it acts on determinant lines, while a permanent varies under
the internal orthonormal-frame gauge.  The physical companion remains a
separate Golden package and should be cited here only after it has a stable
public locator.  Full reports:
`notes/2026-08-01-c763-paper-iii-golden-consolidation.md`.
`notes/2026-08-01-c764-paper-iii-why-determinant.md`.

Paper III's corrected arithmetic statement has global square class `5J_0`;
the fixed Clebsch chart lives over `Q(sqrt(5))`, and the displayed golden
configurations are the complete reduced local fibre.  C733 proves the global
Stein algebra `O + O(-3)` with multiplication `z^2=5J_0`, so the chart
factorization is scheme-theoretic.  Its strongest orientation theorem is
explicitly relative to the ordered golden representatives, plane-triple and
Petersen labels, and normalized chart lift.  The full ambiguity ledger is
integrated, and the sheet alone is not claimed to recover those inputs.
Ordinary, isolated, visual, and fresh context-free gates are green.  The full
geometric integral localization remains unspecified; immutable artifact and
versions 1 and 2 are released.  C680 is retired; C763 owns the selective
Golden-core forward version, while the broader applications remain outside
the numbered series.  Full repair report:
`notes/2026-07-31-c733-paper-iii-relative-orientation-bridge.md`.

C682 is independent exploration. Its current crown includes the
third-transvectant inverse descriptions, the corrected mod-11 operator and
1+5+6+10 kernel section, the characteristic-zero maximal-subgroup mates and
Schlaefli double-six, and the golden D5--S3 complementary incidence fibres.
The frozen common marking identifies the stored mod-11 matrix with the
lambda-plus fibre.
The cross-Gram separator extends over both Mukai--Umemura boundary orbits
on the normalized saturated graph, but provably not as a scalar on the
coarse kernel-pair boundary.
The normalized-graph deck exchange is exactly the global extension of the
Schläfli apolar-polar row swap: inside each \(D_5\), the two five-cycle
classes give complementary pentagon-side and pentagram-diagonal relations
on the ten \(S_3\) labels.
The combined normalized operator/polar/incidence package has minimal base
\(\mathbf Z[1/30]\) and structural bad primes exactly \(2,3,5\).
An \(11\)-elementary dodecic lattice removes the apparent operator failures
at \(7,11\); the cross-Gram scalar image, but not the normalized golden
cover, has collision primes \(11,23\).
At \(23\) that scalar image is the conductor-\(23\) suborder of the inert
golden algebra: its special fibre is a dual-number point, and the divided
separator is the Frobenius-odd normalization generator over
\(\mathbf F_{529}\), not a new rational incidence sheet.  Globally the
scalar image is the conductor-\(253\) order over \(\mathbf Z[1/30]\), whose
only normalization defects are the split prime \(11\) and inert prime \(23\).
Independently, the Klein \(E_8\) cubic is now intrinsic: it is the radial
third-transvectant symbol, and on every McKay covariant block the full
principal symbol is \(10p\) times multiplication by the odd invariant
\(t\), uniformly selecting the classical \(E_8\) matrix factorizations.
Through degree \(72\), every later apparent short-return deficit is repaired
by the nearest downward return; degree \(22\) is the sole certified
full-corner failure in that bounded range.  The all-weight gate remains
open.  The fourteen strict peaks through degree \(112\) also saturate,
completing one base representative of every eventual \(60\)-periodic peak
family; only the \(1,2,3,3'\) free modules remain in the symbolic
nonvanishing gate.  The global two-sided defect is now classified in all
weights: it vanishes for every \(n>52\), and its thirteen exact exceptional
degrees are
\(0,1,2,6,10,11,12,20,21,22,32,40,52\).  Degree \(22\) is uniquely
compatible with a repeated isotypic summand.  Five exact local
four-by-four determinants prove unique continuation on the five
coefficient chains.  A noncircular lower-hyperplane propagation lemma
reduces the remaining full-corner proof to upper-support mixing at
codimension-two peaks plus off-peak propagation.
The attempted maximal-rank/multiplicity induction is now sharply audited.
Every McKay block is maximal-rank through degree \(300\) at two primary and
one replay prime, and full supported algebras on spanning nonorthogonal
subspaces generate the full matrix corner.  However the trivial module has
a recurring unanchored plateau \(1\to2^6\to3\), first in degrees
\(118,\ldots,160\); equal-rank edges only transport the unknown corner, so
bare induction is circular.  That first obstruction is now repaired:
for every \(q\ge1\), the first upward return at the trivial-module entrance
\(n=64+60q\) mixes the incoming hyperplane with its missing direction.
The fixed-width boundary witness reduces the family to one exact rational
function with a coefficientwise sign proof.  The remaining controllability
gate belongs to the \(2,3,3'\) Kostant modules.  The scalar boundary
function now has a canonical signed Bezout pencil: its boundary metric has
inertia \((8,7,0)\), while separate positive Hermite pencils derive the
numerator and pole chamber counts \(1|13|0|1\) and \(2|1|0|0\) by exact
spectral flow.  The next structural target is the block version of this
two-form package for the three remaining modules.
That block input is now complete on the first \(2,3,3'\) periodic plateau
families.  Their block three-term recurrences have sizes \(2,3,3\), with
degree-three coefficients in \((q,j)\), and their backward determinants have
no integral interior zero.  The signed block Wronskian satisfies the exact
Green identity.  Fixed endpoint-return tuples surject onto local boundary
quotients of dimensions \(3,4,4\); degree-\(83,121,120\) determinant
certificates prove stable-ray surjectivity, and direct exact boundary
determinants prove surjectivity on every shorter initial chain.  Thus full
boundary-quotient surjectivity holds for every \(q\ge1\), and all first
plateau-entry families in \(1,2,3,3'\) are controlled.  Smith-at-infinity
profiles account exactly for the apparent \(13,17,18\) determinant-degree
drops.  Exact global falling-factorial Weyl operators in the invariant
exponents \((F,h)\) now realize the third- and ninth-transvectants on the
complete \(2,3,3'\) free modules, eliminating phase-specific operator
construction.  Four further all-\(q\) Wronskians give one certified
representative of every plateau type modulo \(20\); an exact audit shows
that Hilbert translation by degree \(20\) is not transvectant linearity.
The sixteen resulting modulo-\(60\) phase quotients are now all
boundary-surjective for every integer \(q\ge1\).  Together with the prior
eight rays, they anchor every periodic plateau-entry phase.  Exact
global-Weyl two-step compositions are coefficientwise one-signed
degree-four polynomials on all twenty-one eventual strict peak families;
  combined with the all-weight defect and supported-two-subspace theorems,
  this propagates the full graded path corner through every peak.  The
  one-sided operator is now maximal-rank on every McKay block in every
  weight.  The order-three ODE bound, central parity, \(C_5\)-weights, and
  triangular \(d_1/d_{11}\) chain minors prove the exact kernel series.
  Consequently all off-peak full graded path corners in \(1,2,3,3'\) now
  propagate.  The subsequent monotone analysis closes all sixty-three
  modulo-\(60\) plateau entrances in \(2',4,4_s,5,6\).
The four exceptional modulo-\(20\) block Schur recurrences are now explicit.
The global level \(\lfloor b/3\rfloor\) makes all twelve phases block
tridiagonal, their backward blocks factor only at
\(0,\pm1/3,\pm2/3\), and exact elimination leaves complements of sizes
\(5|6|7\), \(5|6|7\), \(6|7|9\), and \(7|9|11\).  The selected endpoint
determinants are nonzero on the exact finite audit \(6\le r\le35\).
The all-\(r\) gate is now closed by scalar \(C_5\)-chain boundary
obstructions.  On chain residues \(4,2,2,0\), exact two-coordinate minors
show that \(D_n^\dagger D_n\) never preserves the incoming hyperplane in
\(4_6,4_{s,3},5_4,6_5\).  Their rational obstructions are strictly negative
on the full real ray \(r\ge6\), and the canonical Fischer endpoint has
positive Schur contraction.  Hence all sixty-three monotone entrance phases
and every graded path corner now propagate.  The local-return gate is also
closed, in a stronger form: the nearest lower and upper Gram returns already
generate every McKay block corner except the exact
\((\mathbf3,22)\) failure.  The two-step upward return is redundant.  The
signed Wronskian and complete boundary quotients give the cyclic-kernel
proof, while the rectangular endpoint system separates distinct blocks.
Thus the requested three-return algebra is the full graded path corner in
every nonexceptional degree.  On every nontrivial block this two-return
presentation is generator-minimal, and both generators are canonical
positive Fischer energy forms.
The previously unexplained virtual levels
\(0,\pm1/3,\pm2/3\) are the order-three \(h=0\) indicial roots in the
degree-\(60\) \(h^3/F^5\) level of
\(t^2=1728F^5-h^3\).  Source-chain residue counts give the exact formula
\[
\det K_-(j)=C\prod_{s=0}^2((3j+s)_3)^{c_s}.
\]
It explains every factor multiplicity, the identical normalized
\(3,3'\) determinants, and the phase-independent \(6\)-profile.
Its detailed, reorganizable lookup surface is the
[C682 working archive](2026-07-13-clebsch-c682-archive.md); none of it reopens
Paper III automatically.

C696 is complete as a Paper III v2 outreach audit. Its strongest connection
is the \(A_1\times A_5\) minuscule branching \(27=12+15\): C682 supplies the
double-six, and C695 now canonically recovers the complementary fifteen
lines from the unique cubic through those twelve embedded lines.  The full
operator-derived configuration has the exact minuscule
\((2\otimes6^\vee)\oplus\bigwedge^2 6\) weight dictionary, all \(45\)
tritangent planes, and the Cartan cubic's mixed-plus-Pfaffian monomial
support.  Row exchange is the \(A_1\) Weyl reflection, not Galois conjugation
or the outer automorphism exchanging \(27\) and \(27^\vee\).  C697 now
constructs the abstract graded Cartan carrier with its exact \(6|15|6\)
cocharacter and signed mixed-plus-Pfaffian cubic.  The row permutation
requires an order-four linear Weyl lift.  The raw Cartan tensor descends
exactly to the six-axis orientation field \(\mathbf Q(\sqrt5)\); rational
descent needs a determinant twist on one row.  KLM Hodge conjugation instead
relates \(V_L\) to \(V_{L^\vee}\), hence belongs to the outer
\(27\leftrightarrow27^\vee\) side.  With no cohomological or Higgs
realization, the operator construction is a graded Cartan model but not a
model of the KLM variation.
Krämer--Litt--Maculan's generic-monodromy theorem
is context rather than an imported result; the golden field is not their
invariant trace field.  The exact full-\(27\) Galois action preserves both
rows and realizes the definition-field tower
\(\mathbf Q(\sqrt5)\subset\mathbf Q(\zeta_5)\); it is not a monodromy
trace-field statement. A bounded invitation is drafted but remains unsent.

Local aggregate replay:

```sh
cd papers/clebsch-covers
./scripts/verify-all.sh
```

## Released-paper corrections owed

Both papers below are released with DOIs. None of these edits has been made.

**Paper IV — the operator-field paragraph is pre-empted by its own cited
source (C877).** Madison and Wu's Theorem 6.1(i) decomposes the code over an
algebraic closure of \(\mathbf F_2\) into three pairwise non-isomorphic simple
twelve-dimensional \(\operatorname{PSL}(2,13)\)-modules. Those three form one
Frobenius orbit — the lane's own scalars \(\alpha,\alpha^2,\alpha^4\) supply
this, and Madison and Wu do not state it — so the \(\mathbf F_2\)-form is a
single irreducible thirty-six-dimensional module with endomorphism field
\(\mathbf F_8\), and irreducibility makes every-family-spans immediate. The
paper credits that source only with the nullity formula. Rewrite to credit the
module decomposition and claim only what survives: the marking of \(A_9\) among
the three conjugates, and building the \(\mathbf F_8\) action from minimum-word
pair data rather than from block theory. The Frobenius-orbit step is the
auditor's inference and is marked as such in their report.
Also owed: a prior credit for the elliptic association scheme to Hollmann's 1982
Eindhoven thesis, which Hollmann and Xiang themselves cite as its first
description.

**Clebsch III — a wrong benchmark and missing two-graph attribution (C876).**
The manuscript names size five for arbitrary three-uniform hypergraphs as the
closest benchmark to its four-local reconstruction theorem. The real benchmark
is four from seven points, via Dammak, Lopez, Pouzet and Si Kaddour for
\(4\le k\le v-3\); the paper's own ledger row `OPER-4` records this correctly,
so the sentence contradicts the paper's evidence map. C878 settled that the two
theorems are independent rather than one being a corollary — the hypotheses are
incomparable, with an explicit switching witness — so only the sentence and the
attribution change, not the result. Separately, the two-graph definition and the
descendant correspondence used as the two-graph equation belong to Higman,
Taylor and Seidel via Brouwer and Van Maldeghem \S1.1.12 and are uncited.
Clebsch I under-attributes the same material.

## Paper IV series novelty position

Audited in C869, report `../2026-08-05-c869-paper-iv-series-literature-audit.md`.

- **Pre-empted, harder than first recorded (C877).** The object is the cubic
  **correspondence** graph on 182 vertices, not the passant-line/internal-point
  incidence graph, which is 7-regular on 156 vertices; earlier notes conflated
  them. It is `X.182.1` in Conder and Potocnik's semisymmetric census, and it is
  one of exactly five graphs in Iofinova and Ivanov's 1985 classification of
  biprimitive cubic semisymmetric graphs — the member with automorphism group
  \(\operatorname{PGL}(2,13)\), whose two sides are its two degree-91 primitive
  actions. The amalgam, not just the graph, is classical. This answers the
  orbit-correspondence bundle's open question 4 affirmatively.
- **Not pre-empted: the two side kernels.** \([91,14,28]\) and \([91,14,26]\)
  are unlocated. Crnkovic, Rukavina and Simac's semisymmetric paper, read at full
  text, does not contain order 182 — their graphs come from a G-graph
  construction rather than the census — and it states plainly that the two sides
  generally differ in minimum distance, confirming the retraction below from the
  primary source. The kernels prove the semisymmetry independently, since a
  part-swapping automorphism would force them to be equivalent.
- **Withdrawn.** An earlier reading of C869 held that the lane contained a
  counterexample to a published equivalence claim of Crnkovic, Rukavina and
  Simac. It does not. Their symmetric-graph paper uses the equivalence
  correctly, since arc-transitive does imply vertex-transitive, and their 2022
  follow-up on semisymmetric graphs states explicitly that the transpose gives
  another code and tabulates both sides with differing distances. The row
  originally matched belongs to a different graph. The asymmetry between our
  two sides is real; the claim that it contradicts published work is retracted.
  Full trail in `../2026-08-05-c871-fold-tower-literature-audit.md`.
- **No predecessor located, re-confirmed unrestricted (C877).** The
  parity-complement lift, the cross-orbital exhaustion, the higher shell, the
  support-XOR identities, and the colour-lift theorem. These negatives are now
  materially stronger than the first round's, having been searched with direct
  parameter, group and construction queries. The exception is the
  parity-complement lemma, which carries no parameters and gained nothing from
  lifting the restriction; state it with proof and claim nothing for it. The one
  place a support-XOR predecessor would most plausibly sit is the
  Iofinova--Ivanov 1985 primary, which was not obtained.
- **Folklore, correctly identified as such.** The frame channel, the
  dual-number frame modules and golden exchange, the \(\mathbf F_{64}\)
  exclusion, the Tanner framing, the quantum formulations, the algorithmic
  bounds, the compact representations, the Farkas certificate, the
  Clebsch-connection document, and the E7 design, tetrad and CSS residue.
- The E6 code reaches the same Calderbank--Kantor family by a second route, its
  own Cartan-cubic monomial-support derivation landing on the minus-type
  elliptic-quadric two-weight code. All three level codes are one family read
  at three ranks.
- The code-CFT root-lattice literature is **not** a predecessor for the quantum
  frame formulations and must not be cited as one; it stays relevant only to
  the E8 and E9 items.

## Exceptional code ladder

Research track, no manuscript yet. One binary code per exceptional level, each
the restriction of affine linear functions to the nonsingular vectors of a
mod-2 quadratic space, linked by one repeated operation: take the link of a
root, fold antipodal pairs, shorten.

\[
 [496,11,240]_{E_{10}}
 \to [240,10,112]
 \to [120,9,56]_{E_8}
 \to [28,7,12]_{E_7}
 \to [27,6,12]_{E_6}
\]

Attaining the exact unrestricted optimum is **not** an E-series property: C875
scored the whole family and every tabulated even-rank level of both types is
optimal, minus type included, while the parabolic levels are the sole shortfall
with a growing deficit — optimal at rank five, one below at rank seven, four
below at rank nine. The 240-point member is the root
link of an \(E_{10}\) root and coincides with the affine \(E_9\) code built
from the affine root lattice; the complementary 256-point root hyperplane is
\((E_8\oplus A_1)/2\) and gives \([256,10,120]\) against an exact record of 124.

Current state:

- Reports: `../2026-08-05-c682-e8-root-pair-ladder.md` (E8 to E6 and the
  quantum-record audit), `../2026-08-05-c865-e9-affine-level-code.md` (affine
  level, partly superseded), `../2026-08-05-c867-ladder-record-attack.md`
  (uniform ladder, symmetry obstructions, Eisenstein model),
  `../2026-08-05-c866-exceptional-code-ladder-literature-audit.md` (novelty).
- **Novelty: largely dissolved. Do not start a manuscript on this track.** A
  claim that the code-level fold works only at plus type, and so carries content
  beyond the graph statement, was withdrawn as an indexing error; the fold is
  type-general and runs exactly parallel to the graph statement (C872). What
  survives of the fold is the code-level restatement alone. Brouwer and Shult
  (1990) is still worth obtaining, now to pin the scope of a known result rather
  than to decide a claim of ours. C873 settled that by triangulation: the
  Brouwer--Shult theorem is not about quadratic forms at all. It concerns
  arbitrary finite graphs under a coclique-parity condition, and its main
  statement is a biconditional — a non-empty reduced graph satisfies that
  condition exactly when it is the Taylor double of a smaller graph with a point
  adjoined. Type and rank never arise in the theorem; they enter only on
  application to a family. Two consequences bind any write-up. **Citation rule:**
  cite Brouwer and Van Maldeghem Proposition 3.6.1, which was read, and name
  Brouwer and Shult as its source; do not cite the 1990 paper directly for the
  identities, which was never obtained. **No converse fallback:** the converse is
  the biconditional itself, at arbitrary-graph generality, so it subsumes any
  binary instance we could prove. The
  level codes are Calderbank--Kantor two-weight codes (C866). The fold itself is
  Brouwer--Shult 1990, stated at general rank as Proposition 3.6.1 of Brouwer
  and Van Maldeghem's *Strongly Regular Graphs*: in the graph on the nonsingular
  points of a quadratic form over \(\mathbf F_2\), the vertices at distance two
  from a fixed vertex form the **Taylor extension** of the graph two ranks down.
  A Taylor extension is an antipodal double cover, so it carries our involution
  and its antipodal classes are our fold. The arithmetic matches at our rank
  with no adjustment. That book also heads a subsection "Tower and clique
  sizes", and names our bottom three levels outright: the graph on the 120 root
  pairs comes from the E8 root system, its local graph is the **Gosset graph**,
  which is the Taylor extension of the **Schlafli graph**, itself labelled the
  E6 graph. Our 120-56-28-27 chain is three named classical objects with a
  published relationship, so the C870 recommendation to lead with the
  general-rank tower is **reversed**: the tower is the occupied part. Calderbank
  and Kantor genuinely contain no rank relation, but the gap is filled in the
  strongly-regular-graph literature instead. What survives is the code-level
  weight-enumerator statement and the affine-root-lattice carrier, judged too
  thin to carry a paper.
  Before any design claim, read the Chakravarti IMA chapter
  (DOI `10.1007/978-1-4613-8994-1_4`) at full text; it is still at metadata
  only. MathSciNet is NOT COVERED, so "to our knowledge" stays on every
  negative. Quantum codes from E8 root lattices do exist in the code-CFT
  literature, so no blanket absence claim is available there.
- Closed negatively, with proofs rather than failed searches: no
  \(O_8^+(2)\)-invariant dimension-ten code contains the E8 code, so the exact
  \([120,10,56]\) record dimension is incompatible with full root-pair
  symmetry; and no Plotkin \(|u|u+v|\) code at \([240,10]\) with length-120
  halves beats distance 112.
- Every unsigned lift stalls at CSS distance four, one below the exact
  \([[28,14,5]]\) and \([[120,102,5]]\) records. The alphabet needed to fix
  that is canonical and free: \(E_8/2E_8\cong\mathbf F_4^4\) over the
  Eisenstein integers, with \(Q(v)\) the parity of the \(\mathbf F_4\)-weight
  and \(\omega\) acting freely on the 120 coordinates in 40 orbits.
  C868 closed that route: the natural nine-dimensional \(\mathbf F_4\) code on
  those coordinates is Hermitian self-orthogonal at exactly the record
  dimension but still has dual distance four, because conjugation and every
  \(\mathbf F_4\)-linear functional are additive and so inherit all 32130
  tetrads as weight-four dual words. Additivity, not the alphabet, is the
  obstruction, and it explains the distance-four stall at every level at once.
- **Track closed as a paper vehicle (C874).** The code-level fold is a formal
  property of any matched Taylor double — every row has fibre-difference
  all-ones, so the fibre-constant subcode is codimension one and folds onto the
  base graph's code — certified against the quadric links, the Paley two-graphs,
  the pentagon and random graphs. No quadratic form is involved anywhere, so the
  code-level residue is empty and no judo move exists. C868's
  no-other-equivariant-code claim was re-proved exhaustively over both
  \(\mathbf F_2\) and \(\mathbf F_4\) and is now theorem-grade, which also
  strengthens C867. Do not spend further effort here.
- Live frontiers, both narrow: the parabolic deficit, which grows from zero at
  rank five to four at rank nine with no mechanism offered and is the only
  unexplained numerical pattern left; and, on the E8 carrier, whether 120 points
  of \(\mathrm{PG}(8,4)\) can sit in four-general position invariantly under a
  large proper subgroup of \(O_8^+(2)\), which is not expected to work.
- One caution carried out of C874 for the Paper IV side: the cross-orbital
  optimality certificate's Hamming exclusion at dimension forty survives by
  1.6 percent on exact volumes. It is sound as stated and must not be transferred
  to nearby parameters without recomputation.

Outbound literature queries on this track must not disclose our unpublished
parameters or constructions; verdicts blocked by that constraint are recorded
as open gaps rather than guessed.

## Companion-export chain

Paper III's formal companion is back on the guarded chain. Its gate
`RelativeConicArcs.Gates.ClebschPassages` is declared in
`lean/trust/areas/relconic.toml` with all fifty terminals and their expected
axioms, its extracted fact is committed, and
`lean/trust/export/clebsch_passages.toml` supplies the destination names and
release prose. The exporter's `plan` resolves the fifteen-module closure and the
full destination file set.

Running the export is blocked by drift in the canonical base rather than by
anything Paper III owns: `TARGET_MANIFEST.json` in `~/src/lean/finitegeom`
disagrees with its own tree at four paths — `ProjectiveCap/Sym2ConicBridge.lean`
changed, and the three `Q16` modules were moved to a certificate package —
because three base commits landed without resealing that manifest. Every
companion export refuses until the base is resealed, so the reseal is the
blocker to raise before the next export of any area.

## Release and verification policy

Each split paper owns its statement identity, claim manifest, aggregate gate,
replay entry point, toolchain pins, adequacy appendix, and AI/provenance
disclosure. Shared Lean sources stay in the pinned standalone Lean
repository. An immutable public locator and fresh isolated replay are release
requirements, not substitutes for the paper's local gates.

Paper I's current local export is the sealed C753/C762 surface. Paper II's
paper-only local mirror is synchronized at `2245993`; its next public release
still requires C892's formal/trust closure. Paper III's relative marked bridge, global Stein algebra,
mechanical artifact, isolated, visual, source-pinned Lean-boundary, and
fresh-referee gates are green.  Its locator and author metadata must still be
inserted before submission readiness.

## Lane boundaries

This lane owns the three Clebsch paper roots, the preserved mega-paper
fallback, Clebsch checkers/reports, and exact Clebsch queue rows. It does not
own Baer, alternate-orbit, gem-mining, or crowns work. Cross-lane results are
read-only until an owning split-paper task explicitly admits them.

The companion discovery log is
`notes/2026-07-14-clebsch-discovery-track.md`. Logging an observation neither
allocates work nor adds it to a paper.

## Working and historical indexes

- Trilogy venue strategy:
  [`../2026-07-30-clebsch-trilogy-venue-strategy.md`](../2026-07-30-clebsch-trilogy-venue-strategy.md).
- Live task detail: `notes/clebsch-tasks/`.
- C682 thematic lookup and chronology:
  `notes/handoffs/2026-07-13-clebsch-c682-archive.md`.
- Full accumulated handoff history:
  `notes/handoffs/done/2026-07-13-clebsch-paper-archive.md`.
- Retired mega-paper planning redirect:
  `notes/2026-07-20-clebsch-paper-planning.md`; full superseded record:
  `notes/2026-07-20-clebsch-paper-planning-archive.md`.
- Mega-paper independent cold read:
  `notes/2026-07-23-c320-independent-cold-read.md` — fallback only.
