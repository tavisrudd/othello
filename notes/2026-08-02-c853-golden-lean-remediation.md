# C853 Golden quantum-statistics Lean remediation

**Lane:** `golden`

**Status:** in progress; matrix semantics and the all-orders real rigidity
surface are gated, and the algebraic Hermitian exchange landscape is proved

## Review checkpoint

A full review of the landed C853 surface found no failed Lean proof, but the
artifact does not yet meet the task contract.

- `ConferenceExchangeCompression` elaborates, but the Golden gate, trust
  registry, generated fact, and export configuration do not import or advertise
  it.  It is therefore source code rather than part of the formal companion.
- The gate still advertises the four scalar `GoldenBalancedCut` terminals.
  Their determinant, trace-contraction, and fourth-word values are not connected
  by theorem types to an actual matrix determinant or trace.  The new normalized
  determinant theorem does not by itself close that bridge.
- The public benchmark is an algebraically valid theorem about a block matrix
  satisfying a square identity.  It does not yet expose formal conference-matrix,
  balanced-cut, or control objects, so its documentation is stronger than its
  semantic API.
- The Hermitian landscape, rigidity and stability, all-orders spectrum,
  continuous-control, balance-obstruction, and orientation layers remain
  unformalized, as the gate header correctly states.
- The export prose still describes the superseded scalar-only boundary and does
  not match the real matrix-level closure or its observed axioms.

The remediation order is:

1. prove actual matrix determinant, trace-contraction, and fourth-word bridge
   terminals and remove the scalar-only declarations from the advertised gate;
2. import and register the compression module, then close its spectral bridge to
   the normalized cross Gram operator;
3. introduce self-contained conference-matrix, balanced-cut, Hermitian, control,
   switching, and distance vocabulary and restate the benchmark through it;
4. formalize the Hermitian landscape, rigidity/stability, all-orders spectrum,
   continuous-control, balance-obstruction, and orientation terminals in that
   order;
5. refresh the claim ledger and referee prose, regenerate the exact trust fact,
   and rerun deterministic canonical export only after the theorem surface is
   stable.

The immediate acceptance gate is narrow: the Golden import-only gate must carry
the compression identities and actual matrix semantics for every retained
value `16`, `12`, and `-42`, with no scalar surrogate counted as theorem
coverage.

## First remediation checkpoint

The immediate gate now passes.  `ConferenceExchangeSpectrum` proves
`det(S Sᵀ) = 16`,
`tr(A² S Sᵀ) = 12`, and the resulting fourth-word value `-42` as actual
matrix statements.  The Golden gate no longer imports or advertises the four
scalar `GoldenBalancedCut` terminals.

The gate now imports `ConferenceExchangeCompression` and advertises its cut
commutator square, transfer Gram, and compressed squared-commutator identities.
It also imports the completed semantic theorem
`BalancedExchangeHalfCut.exists_isometry_charpoly_exchangeCompression_half_card_three`.
That theorem starts with a real symmetric conference matrix on six labels and
an actual three-element subset, constructs an orthonormal eigenframe, and proves
the characteristic polynomial `(X - 1/5)(X - 4/5)^2` of the exchange
compression.  This closes the review's conference/cut/eigenframe API defect
without duplicating the existing general half-cut development.

Guarded single-file elaboration of the new matrix terminals passes.  The
compression leaf and the Golden import-only gate then built through the guarded
queue; the aggregate gate passed.  The regenerated fact records a nine-module
closure, fifteen terminals, no project axiom, and no opaque declaration.  Every
terminal observes exactly `Classical.choice`, `Quot.sound`, and `propext`.

The remaining C853 frontier begins with the Hermitian conference vocabulary and
landscape.  General balanced-spectrum rigidity already has a reusable formal
surface in the imported half-cut closure; its exact C853 terminal selection and
paper correspondence should be reconciled before adding another proof.

## Mystery ledger

The checkpoint `ej`+`tt` pass settled the original semantic mystery: the
cross-Gram benchmark and the eigenframe exchange compression are now connected
through actual matrix and half-cut theorem types, rather than by scalar
surrogates or documentation.

One genuine coverage question remains.  The imported closure already contains
the general half-cut characteristic-polynomial formula, the second-moment
formula in terms of aligned four-sets, and the higher-order nonconstancy theorem.
It is not yet known which clauses of the manuscript's general
balanced-spectrum result are exact consequences of those declarations and
which still require order-four exclusion, inclusion-matrix, or Ramsey
terminals.  The evidence gap is an exact theorem-to-claim reconciliation of
`BalancedExchangeSpectrum`, `BalancedExchangeEigenvalues`,
`BalancedExchangeHalfCut`, and `BalancedExchangeRigidity`.  C853 owns that
reconciliation before new all-orders proof work.

No mystery remains around the retained values `16`, `12`, and `-42`, the
order-six balanced characteristic polynomial, or their current trust route.

## General balanced-spectrum reconciliation

The manuscript theorem `thm:general-exchange-rigidity` is already covered
mathematically by the C815 half-cut development, but not by one bundled Lean
declaration.  Its clauses map as follows.

- `BalancedExchangeSpectrum.cutBlock_eq` identifies the normalized cross Gram
  matrix with `1 - q⁻¹A²`.
- `BalancedExchangeSpectrum.charpoly_exchangeCompression_cut` identifies the
  exchange-compression characteristic polynomial with that principal-block
  normalization, and
  `BalancedExchangeEigenvalues.charpoly_one_sub_smul_mul_self_eq_prod` reads it
  as the factors `1 - αᵢ²/q`.
- `BalancedExchangeHalfCut.exists_isometry_charpoly_exchangeCompression_half`
  transports the formula to an actual subset of a real symmetric conference
  matrix and constructs the required eigenframe isometry.
- `BalancedExchangeHalfCut.exists_isometry_trace_pow_two_exchangeCompression_half`
  is the displayed aligned-four-set purity formula on an actual balanced half.
- `BalancedExchangeHalfCut.not_forall_trace_pow_two_exchangeCompression_half_eq`
  proves cut dependence for every half-size `d ≥ 4`.  Its proof is the
  kernel-checked support-count argument in `BalancedExchangeRigidity`; it does
  not import the manuscript's Jolliffe inclusion-rank theorem or `R(3,3)=6`.
- `BalancedExchangeSpectrum.charpoly_one_sub_smul_mul_self_of_card_one`,
  `..._of_card_two`, and `..._of_card_three` give the three small-order
  characteristic polynomials, while `ne_smul_one_of_card_four` proves that no
  order-four symmetric conference matrix exists.

These declarations cover both directions and the exceptional cases of the
manuscript theorem.  The residual is interface compression: one public theorem
should bundle the separate terminals into the exact `d ≤ 3` classification
and state the unique-nontrivial-order corollary on its realized domain.  No new
inclusion-matrix or Ramsey proof is needed for correctness.

## Second remediation checkpoint

The all-orders declarations identified above are now explicit Golden gate
terminals rather than merely transitive implementation detail.  The guarded
single-file gate elaboration and queued aggregate build both pass.  The
regenerated fact has a nine-module closure and twenty-five terminals, with no
project axiom and no opaque declaration; every terminal observes exactly
`Classical.choice`, `Quot.sound`, and `propext`.

The first Hermitian layer is also kernel checked in
`RelativeConicArcs.HermitianConferenceExchange`.  For a paired three-by-three
triangle over a commutative ring, its characteristic polynomial is proved from
the three reverse-edge product identities.  The complex specialization then
uses conjugate reverse edges and unit-modulus hypotheses to prove
`charpoly = X³ - 3X - 2r`, where `r` is the real oriented triangle holonomy.
This is supporting infrastructure and is not yet advertised as coverage of the
full Hermitian landscape theorem.

The remaining issues are now sharply separated:

- bundle the already proved all-orders directions into the manuscript-facing
  `d ≤ 3` classification interface;
- derive the Hermitian exchange eigenvalue invariants and the formulas for
  `p1`, `p2`, `e2`, `e3`, `h3`, and `s(2,1)` from the triangle polynomial and
  conference block identity;
- formalize the Hermitian phase/control domain and Pareto/equality claims,
  followed by squared-spectrum rigidity and stability;
- formalize continuous control, balance obstruction, and the orientation
  layer; and
- repeat gate, fact, claim-ledger, prose, and deterministic-export validation
  only as each complete theorem surface becomes stable.

The next implementation step is the Hermitian matrix-to-exchange bridge and
moment formulas.  Registration of the new Hermitian module is deliberately
deferred until those statements form an honest paper-facing terminal.

## Mystery ledger update

The all-orders coverage question is resolved: C815 already supplies the
spectral formula, purity formula, higher-order nonconstancy, small cases, and
order-four nonexistence through a support-count proof.  There is no missing
inclusion-rank or Ramsey dependency in the Lean route.  The sole all-orders
residual is a bundled public interface.

The active mathematical uncertainty has moved to the Hermitian control domain:
the triangle characteristic polynomial and normalized exchange moments are
established, but the admissible phase/control image and exact Pareto domain
still have to be designed and checked.

## Hermitian landscape checkpoint

`HermitianConferenceExchange` now defines the actual normalized complementary
Gram operator `I - A²/5` attached to a unit-modulus Hermitian triangle.  It
proves, at matrix level,

- `p1 = tr(H) = 9/5` and `p2 = tr(H²) = 33/25`;
- `e2 = 24/25` through Newton's trace identity;
- `e3 = det(H) = 4(5-r²)/125`;
- `h3 = (317-4r²)/125`; and
- `s(2,1) = (196+4r²)/125`.

The public `hermitianExchange_landscape` theorem bundles these formulas with
the triangle characteristic polynomial `X³ - 3X - 2r`.  Guarded elaboration of
the leaf and import-only Golden gate passes.  The shared queue built the leaf,
then correctly refused the aggregate after its fixed quiet wait because a
foreign Lean build remained live.  Consequently the gate registration is
committed but its generated fact remains to be refreshed in the next genuine
quiet window; no stale fact is being cited as validation.

The next proof target is no longer scalar algebra.  It is an explicit
admissible Hermitian phase/control domain, followed by the componentwise Pareto
segment and endpoint equality cases.  Squared-spectrum rigidity and stability
remain downstream of that domain theorem.

The abstract Pareto step is now proved as well.  `SectorPoint`, componentwise
dominance, and `hermitianFrontier` formalize the three-sector geometry.  From
the four individual bounds and two supporting inequalities used in the paper,
`exists_hermitianFrontier_dominates` constructs a parameter `t ∈ [0,1]` whose
frontier point dominates any feasible point, while
`hermitianFrontier_dominates_iff` proves that distinct frontier points are
incomparable.  This deliberately leaves two strength-bearing bridges open:
every continuous control must satisfy the six assumed inequalities, and the
Hermitian conference family must realize every `t ∈ [0,1]`.

That reduction now has its exact maximal-set wrapper.  Assuming those two
bridges, `maximalIn_iff_mem_hermitianFrontier` identifies the componentwise
maximal feasible set with precisely the image of `[0,1]`; separate terminals
prove the symmetric and exterior endpoint at `t=0` and the mixed endpoint at
`t=1`.  The manuscript's remaining three-variable analytic lemma is also
kernel checked: nonnegative spectral variables with `e1 ≤ 9/5` and
`e2 ≤ 24/25` satisfy `e1*e2-e3 ≤ 8/5`.  The proof follows the two active
branches split at the third variable `1/5`.

These five supporting results are registered in the Golden trust surface,
bringing the intended fact to thirty-one terminals.  The leaf and guarded gate
pass.  A new bounded shared-queue attempt again built the leaf and then refused
the aggregate after the fixed 120-second quiet wait because the same foreign
Lean build remained live.  The generated fact therefore remains at its prior
twenty-five-terminal checkpoint and must not be treated as current.

The matrix-to-control remediation has also begun on the correct semantic
object.  `realDiagonalControl` embeds real controls as Hermitian complex
diagonal matrices, `hermitianTransferBlock` is `Qmᴴ D Qp`, and
`hermitianTransferBlock_gram` proves its actual Gram matrix is the compression
`Qpᴴ(D Pm D)Qp` whenever `Qm Qmᴴ=Pm`.  This registered terminal raises the
intended fact to thirty-two terminals.  What remains is to specialize the
projection to a Hermitian conference involution and prove the control-cube
trace, minor, and determinant bounds.

The first of those bounds is now end to end.  The Hermitian involution
projections are complementary, idempotent, orthogonal, and Hermitian.  Trace
cycling removes the positive frame and identifies the first transfer moment
with `tr(D Pm D Pp)`.  For six labels, zero diagonal and off-diagonal pair
products `1/5` reduce this actual matrix trace to
`(6*sum(x_i^2)-sum(x_i)^2)/20`; the cube hypotheses then prove the exact
`9/5` bound.  Both the matrix formula and bounded-transfer theorem are
registered, so the intended trust fact now has thirty-four terminals.

The remaining continuous-control gap starts at `p2`: formalize the Schatten
fourth-power convexity/Boolean reduction, then the separately convex minor and
determinant bounds and equality cases.  The active mystery is no longer the
first-moment normalization or complex frame semantics.

The finite-cube completeness mechanism for the higher moments is now formal.
`CoordinatewiseConvexOnCube` uses Mathlib's `ConvexOn`; the interval maximum
principle proves coordinatewise endpoint domination, and a Finset induction
constructs a Boolean control with objective value at least that of the original
cube point.  These two registered terminals bring the intended surface to
thirty-six terminals.  For `p2`, the residual is now exactly the
Schatten-fourth coordinate-convexity theorem plus the four Boolean support-size
values; vertex completeness itself is no longer trusted prose.

The fixed-six vertex arithmetic is now partly closed on actual matrices.
One-coordinate and two-coordinate Hermitian principal blocks have second
moments `1` and `32/25`; the three-coordinate value `33/25` is the existing
landscape theorem.  A public wrapper now extends any proved uniform Boolean
bound to the full cube from coordinatewise convexity.  The intended trust
surface has thirty-nine terminals.

Two semantic steps remain before this is the manuscript's `p2` theorem: prove
coordinate convexity of the actual Schatten-fourth transfer objective, and map
every six-mode Boolean control (up to complement) to the zero-, one-, two-, or
three-coordinate fixed-six matrix just evaluated.  The order-four `1/3`
small-block theorem was explicitly rejected for this purpose because it has
the wrong conference normalization.

## Scope decision

The user requires every mathematical statement of the manuscript
*Orientation, exchange statistics, and rigidity in the Golden six-mode
conference interferometer* to be formalized to the repository's Lean standards,
using Mathlib wherever the library already has the object.  The formal artifact
therefore grows from four scalar ring identities to a theorem-level companion
covering the paper's eight labelled results, with an explicit trust route for
everything that stays outside Lean.

## Export prerequisite

The blocking guarded exporter is now `lean/scripts/lean-companion-export.py`,
covered by `lean/scripts/test_lean_companion_export.py` and configured for this
paper by `lean/trust/export/golden_quantum_statistics.toml`.  It derives a
gate's project-local closure, terminal list, and observed axioms from the
committed trust registry and generated fact, materializes a disposable
candidate on the canonical Lean base twice, requires byte-identical repeats,
verifies byte identity, manifests, terminals, base cleanliness, and prints a
read-only forward delta without committing, tagging, pushing, or editing either
repository.  Details and the seven-point contract check are in the export
preparation record.

## Landed formal content

`RelativeConicArcs.ConferenceExchangeSpectrum` is the new matrix-level module.
Over a commutative ring it proves that a two-block splitting of a matrix
satisfying `C * C = q • 1` forces `A * A + S * Sᵀ = q • 1`, hence the cross Gram
identity `S * Sᵀ = q • 1 - A * A`, and that a signed triangle block with unit
off-diagonal entries satisfies `A * A = 2 • 1 + (a * b * c) • A`.

Over the reals it defines the normalized exchange operator
`normalizedExchange q S = q⁻¹ • (S * Sᵀ)` and proves, for every three-element
cut of every order-six symmetric conference matrix and every choice of the three
edge signs:

- `Matrix.charpoly (normalizedExchange 5 S) = (X - C (1/5)) * (X - C (4/5)) ^ 2`;
- the multiset of characteristic roots is `{1/5, 4/5, 4/5}`;
- `spectrum ℝ (normalizedExchange 5 S) = {1/5, 4/5}`;
- trace `9/5`, squared trace `33/25`, determinant `16/125`; and
- the degree-three sectors `313/125`, `8/5`, `16/125` with the Schur–Weyl
  checksum `729/125`.

Elementary symmetric functions use `Multiset.esymm`; power sums are a thin
definition over a multiset.  The library has no Schur-polynomial API, so the
third complete homogeneous symmetric function and the Schur function of the
partition `(2,1)` are defined by their monomial expansions in three variables
and connected to `Multiset.esymm` by proved identities.

This is the manuscript's balanced exchange benchmark at the cross-Gram level,
proved uniformly in the edge signs rather than by a census of the twenty
balanced controls.

## Eigenframe compression bridge

The manuscript's exchange operator is `H = K*K` for the compression
`K_C(x) = Q₋* D_x Q₊` between orthonormal eigenframes of `C`.
`RelativeConicArcs.ConferenceExchangeCompression` carries the matrix half of
that bridge.  For an involution `Q` with eigenprojections `(1 ± Q)/2` and a
frame `Qp` characterized by `Qpᵀ * Qp = 1` and `Qp * Qpᵀ = (1 + Q)/2`, it
proves:

- the commutator of the cut sign involution with a block matrix is
  `fromBlocks 0 (2 • R) (-(2 • Rᵀ)) 0`, and its square is block diagonal with
  `-(4 • (R * Rᵀ))` and `-(4 • (Rᵀ * R))` on the diagonal;
- `Kᵀ * K` is the compression `Qpᵀ * (D * ((1 - Q)/2) * D) * Qp`;
- the commutator acts on a positive eigenframe as twice the complementary
  projection of the controlled frame; and
- `4 • (Kᵀ * K) = Qpᵀ * (Lᵀ * L) * Qp` for that commutator `L`.

What remains for the bridge is the spectral half: the compressions of
`Lᵀ * L` to the two eigenspaces have equal characteristic polynomials, because
the commutator intertwines them; their product is the characteristic polynomial
of the block-diagonal `Lᵀ * L`, which is the square of that of the normalized
cross Gram matrix; and two monic real polynomials with equal squares are equal.
Until that lands, the exchange results reach the manuscript's operator only
through the equality of spectra the paper proves separately, which the module
headers state as an explicit trust boundary.

Still unformalized: the all-orders exchange rigidity theorem with its aligned
four-set purity formula and inclusion/Ramsey converse; the continuous-control
optimum and its equality set; the Hermitian exchange landscape, Pareto
frontier, squared-spectrum rigidity, and stability bounds; the balance
obstruction; and the orbit and orientation layer.  Decoding schedules,
tomography, optical compilation, and every experimental threshold stay outside
Lean by design and must be recorded with their own trust routes rather than
counted as missing formal proof.

## Validation state

Every landed declaration elaborates through the guarded single-file entry point,
and the import-only gate `RelativeConicArcs.Gates.GoldenQuantumStatistics`
builds through the guarded queue with its trace-only aggregate gate passing in
the shared tree.  The trust registry now advertises the eight matrix-level
terminals alongside the four legacy scalar identities.

The gate also builds in a clean disposable worktree at the exact source commit,
and the generated fact was regenerated there because the shared tree carries
foreign uncommitted Lean edits and extraction correctly refuses in that state.
The fact records a three-module closure, no project axiom, and no opaque
declaration.  The eight matrix-level terminals observe exactly
`Classical.choice`, `Quot.sound`, and `propext`; the four legacy scalar
identities observe exactly `propext`.  The area-wide audit reports no finding
against this unit; its remaining errors are the unrelated relconic baseline.

The guarded companion exporter then produces a verified, deterministic
eleven-file candidate carrying all twelve terminals, taking the canonical
library state from 273 to 276 modules, without mutating the canonical base.
