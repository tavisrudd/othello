# C910 — Lean companion for cubic stabilization

**Lane:** `clebsch`

**Status:** active

## Objective

Build a referee-facing, Mathlib-only Lean companion for
`papers/cubic-stabilization-epilogue/`.  The authoritative package lives at
`papers/cubic-stabilization-epilogue/lean/` and is exported as part of the
paper repository.  Nothing is duplicated under `lean/TavisRuddFiniteGeom/` or
in a second standalone Lean repository.

The public library and namespace follow the C879 paper-facing convention:

```text
CubicStabilizationEpilogue
TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
```

## Formal standard

The companion is held to the same referee and trust standards as the existing
Lean artifacts in this repository:

- no `sorry`, `admit`, project axiom, opaque oracle, `native_decide`, unsafe
  declaration, or compiled-evaluation axiom in a paper-facing terminal closure;
- every public declaration and non-obvious definition has a self-contained
  mathematical docstring, with no workflow IDs, private paths, review history,
  or mutable manuscript numbering in the artifact;
- every manuscript claim in formal scope maps to an exact fully qualified Lean
  declaration, and every exported terminal is listed in the trust registry;
- the semantic gate imports the complete claimed closure and the axiom audit
  records the kernel-reported dependencies of every terminal;
- external literature is either proved in the exact weaker form used or stated
  as an explicit hypothesis of a conditional theorem.  Conditional scaffolding
  must never be reported as unconditional formal coverage of the manuscript;
- generated data, if any, must have a tracked generator, schema, semantic
  checker, coverage proof, replay command, and independent replay or an explicit
  reason none exists.

## Proof architecture

### Integral cycle spine

Formalize the algebraic mechanisms independently of abelian-variety machinery:

1. symmetric matrix-of-ideals lattices over a discrete valuation ring;
2. the exact midpoint criterion for rank-one generation, without division by
   two;
3. square-zero rank-one divisor calculus and integral divided-power expansion;
4. faithful-flat membership descent in the finitely generated quotient lattice;
5. local-to-global membership from the finite set of bad primes;
6. the six-axis Smith and finite-field packet calculations needed to instantiate
   the abstract theorem.

The Roulleau intersection theorem, relative intermediate-Jacobian construction,
Voisin criterion, and Torelli statement require either exact formal proofs or
explicitly typed external-premise interfaces.  Their deductive consequences are
formalized separately from those inputs.

### Quantum and birational spine

Formalize the paper's deduction at the natural abstract level:

1. an additive nonnegative packet multiplicity on smooth projective objects;
2. blow-up and projective-bundle operation formulas;
3. the low-dimensional vanishing implication for weak-factorization centers;
4. birational invariance through dimension four;
5. one-projective-line stabilization obstruction for threefolds;
6. transport across the genus-eight projective-bundle flop;
7. logical independence of universal `CH_0`-triviality and the packet invariant.

The existence and properties of framed quantum monodromy, divisor tagging,
Iritani comparison maps, Cai's cubic packet, weak factorization, and Kuznetsov's
geometric correspondence remain separately named external mathematical inputs
until formalized from foundations.  The artifact must make this boundary
visible in theorem types and in the claim map.

## Current state

The package has a pinned standalone Nix and Mathlib environment.  Its 75 Lean
sources build through the guarded queue.  The reviewer interface currently
exports 141 audited terminals.  The rejecting manuscript inventory covers all
23 labelled theorem-like environments: 0 absent, 13 fragmentary, 9 conditional
deductions, and 1 complete.

The integral algebra includes the arbitrary-size DVR rank-one criterion,
flattened split-coordinate coefficient lattices, an explicit invertible
extension-ring basis-change transport between distinct base and split axes,
derivation of transported weighted-lattice membership from base symmetry and
the three formal graph-coordinate descent conditions,
faithful-flat ordinary-product descent, square-zero divided powers, the `6I-J` Smith and local-block
calculations, and exact characteristic-two slope-model minimal polynomial,
scalar extension, and repeated-root diagonalization.  The quantum algebra
includes framed-sixth multiplicity for supplied monodromy matrices,
pro-Laurent inverse-system types, coefficient-extension and conjugacy,
formal-base-shift and block-formula deductions, numerical coefficient
pushforward, strict-Novikov data, divisor-tag separation, typed
weak-factorization telescoping, the arithmetic core of Cai's rank-two indicial
polynomial, and the exact implication from a `{1,-1}` characteristic-root
spectrum to low-dimensional sixth-root vanishing.  The cycle side now also
contains the exact fibrewise deduction from supplied primitive-minimal-class
algebraicity and Voisin's supplied equivalence to universal `CH₀`-triviality.
The four conclusions of the separation-family headline are also assembled in
one conditional theorem with every Chow, packet, and period-map input exposed.
The relative-six-axis row now has an opaque organizational signature for all
named geometric assertions and an independently proved full integral Smith
witness; this is explicitly a fragment, not a conditional proof of the
scheme-theoretic lemma.
Low-dimensional primitive-sixth vanishing is now an exact conditional
deduction: Lean performs the induction through nef seeds, the point,
arbitrary positive-rank projective-bundle presentations, and iterated point
blowups, then applies the supplied divisor-tagging transfer to every strictly
Novikov-admissible specialization.  The classification, spectral input,
operation formulas, and specialization comparison remain explicit premises.
The framed projective-bundle and blowup formulas are also exact conditional
deductions: supplied characteristic-polynomial block comparisons now imply
the rank-scaled projective-bundle multiplicity and the ambient-plus-`c-1`
specialized-center blowup multiplicity inside Lean.
The cubic packet is now an exact conditional deduction: from the supplied
four-factor framed-monodromy characteristic polynomial, Lean proves that the
two primitive-sixth roots occur once each, the two unit blocks contribute
nothing, and the multiplicity is exactly two for every smooth cubic threefold.
Divisor-tagging vanishing is now an exact conditional endpoint deduction: two
supplied final characteristic-polynomial equalities over `ℂ` imply equality
of intrinsic, tagged, and specialized primitive-sixth multiplicities and hence
transfer vanishing to every strictly admissible specialization.  The formal
signature deliberately does not model the source coefficient fields, a common
comparison field, scalar-extension maps, completed-series injection, or the
bulk-gauge witness producing those equalities.
The finite exponential-character step in its human proof is independently
kernel checked: for any finite injective family of integral pairing vectors,
Lean constructs an integral direction `(1,t,t²,...)` by avoiding the finite
root sets of the pairwise difference polynomials and proves linear
independence of the resulting formal exponentials from their first
coefficients via Vandermonde.  The support step is also kernel checked at
coefficient level: a nonzero
series with finite support below each length cutoff has a nonempty finite
lowest-length support with exact membership, and every assignment of nonzero
leading coefficients there gives a nonzero tagged exponential combination.
The remaining seam is the filtered/associated-graded identification of a
geometric specialized initial form with that combination.
An exact conditional detector bridge now isolates that seam: supplied proxy
detectors, nonzero monomial initial coefficients, and their compatibility with
the finite exponential combination imply nonvanishing, zero reflection, and
full injectivity of the additive tagged map.  The actual filtration,
associated graded ring, valuation, geometric specialization, and proof that
they induce these proxy data are not represented.
Finite-below completed coefficient families now carry the convolution
commutative-ring structure, with exact coefficientwise agreement with ordinary
additive monoid-algebra multiplication through each cutoff.  For a surjective
degree-compatible numerical quotient, finite-fiber pushforward is a unital ring
homomorphism and commutes with every finite truncation.  The formal objects
carry no topology; an explicit coefficientwise compatible-truncation family is
now proved equivalent to them, without a categorical/topological universal
property.  Gromov--Witten descent and base change of comparison maps remain
outside the result.  For
finite coefficient packets, numerical invariance now gives exact descent and a
fiber-cardinality formula.  Additive scalar weights give additive operators
  satisfying the Leibniz rule for completed convolution, and numerical
  pushforward commutes with the operator when the weight factors through the
  quotient.  The geometric
Gromov--Witten coefficients, curve-pairing weights, and quantum connection are
not constructed.

For multivariate formal power series over a commutative rational algebra, the
coefficientwise partial derivatives satisfy the Leibniz rule and commute.  Lean
proves both directions at the formal level: an invertible supplied solution
forces zero curvature, and zero curvature yields a recursively constructed
unique normalized invertible gauge, naturally under rational-algebra
coefficient homomorphisms.  This applies to ordinary Laurent-series
coefficients, but identification of the manuscript's connection and curvature
premise and a Laurent lower bound uniform in bulk monomials and levels remain
unproved.  From a supplied rational algebra, ideal filtration, base
multivariable connection, and its exact curvature proof, Lean now constructs
the connection and unique normalized invertible gauge over every actual
quotient and proves canonical adjacent-reduction compatibility.  Every
entrywise monomial gauge coefficient is packaged as a compatible quotient
family and identified with the compatible family represented by its
corresponding base-gauge coefficient.  This abstract
quotient tower is not identified with the manuscript's geometric one.
With ordinary Laurent-series coefficients over the base ring, Lean now maps
the connection into `LaurentSeries (R/F^n)` and constructs the compatible
normalized invertible gauges.  Each finite-level bulk coefficient therefore
has integral loop exponents and an individual Laurent lower bound.  No bound
uniform in bulk monomials or levels follows from this quotient-level
construction alone; the conditional base-ring lift described below requires
separate uniform lower bounds for the gauges and their chosen inverses.  Lean
separately proves that finite bulk support at one level
gives one lower bound for the entire matrix-valued series, but does not derive
that finite support from the positive filtration.  For finitely many bulk
coordinates, explicit vanishing at or above one total-degree cutoff now
supplies the finite support.  Monomials in supplied level-one parameters are
proved to map to zero in every quotient by a filtration level not exceeding
their total degree, including every coefficient-times-monomial term of a
formal series; no infinite evaluation sum is defined, and identifying those
parameters with manuscript bulk coordinates or this termwise coefficient
model with the manuscript gauge remains outside the fragment.  For a supplied
zero-curvature Laurent-valued connection and finitely many level-one
parameters, Lean now also constructs the normalized invertible formal gauge
and an actual finite sum in one cutoff quotient, proves every omitted
high-degree term zero, and gives the resulting finite evaluated matrix one
Laurent lower bound.  The finite evaluations commute with canonical adjacent
quotient reductions.  Evaluation is a ring homomorphism, so the matrices are
invertible; compatible chosen two-sided inverses package them as a pro-Laurent
gauge system.  Every entrywise loop coefficient is also packaged as a
compatible quotient family.  Identification with the manuscript gauge remains
outside the fragment.  Under separately supplied coefficientwise completeness,
separatedness, and uniform Laurent lower bounds for gauges and inverses, Lean
also assembles a two-sided-invertible Laurent matrix over the base ring whose
reductions are exactly the finite evaluations; the uniform bounds and geometric
identification are not derived.
The evaluated-gauge system now feeds the formal-base-shift matrix packet
directly: from supplied compatible small monodromy matrices and divisor
substitutions, Lean derives the bulk matrices and compatible substituted
characteristic-polynomial system.  The small/divisor inputs remain supplied,
and their geometric string/divisor origins remain unformalized.
The stronger filtered composite now derives every compatible Laurent quotient
divisor substitution from one filtration-preserving base endomorphism.  Thus
only compatible small monodromy matrices remain as finite-level matrix data;
the base endomorphism is supplied, and its geometric divisor-equation origin
remains unproved.
The strongest base-data composite now also reduces one supplied Laurent
small-monodromy matrix over the base ring to construct every compatible
quotient small matrix.  Its geometric monodromy origin remains unproved.

The explicit characteristic-two companion model now has a constructed
quadratic finite-etale splitting field, marked root, and two-sided explicit
eigenbasis, together with an algebra equivalence to the concrete `F4` gluing
field that carries the marked root into the two-element exotic Frobenius
orbit and realizes that orbit as a distinct affine-chart two-cycle in the
five-point projective packet.  Its identification with the manuscript's geometric marked
extension and principal kernel remains open.  Lean now proves the exact
connected-family persistence step for any supplied continuous map into a
finite discrete kernel packet and specializes it to the transported marked
quadratic pair in the affine `F4` chart; construction of that geometric packet and
classifying map remains open.  All other geometric
identifications and comparison theorems remain outside those
fragments unless present as explicit typed premises.  The next integral gates
are identification of the constructed finite-etale splitting and eigenbasis
with the geometric marked extension,
proof that geometric divisor descent supplies the formal block conditions,
actual six-axis kernel identification and its continuous packet classifier,
cohomological realization, and the
Voisin/relative-family bridge.  The next quantum gates are the
differential-module base-change proofs, the completed-series and comparison
semantics producing the supplied divisor-tagging equalities, operation
comparisons, the geometric argument producing the `{1,-1}` spectrum in low
dimensions, and Cai's actual integral-`z` block diagonalization.

## Package shape

```text
papers/cubic-stabilization-epilogue/lean/
  lakefile.toml
  lean-toolchain
  README.md
  TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/
    GraphLattices/RankOneGeneration.lean
    GraphLattices/DividedPowers.lean
    GraphLattices/SixAxisGram.lean
    Quantum/FramedMultiplicity.lean
    Quantum/ProLaurent.lean
    Quantum/CompatibleMonodromySystem.lean
    Quantum/ProLaurentGaugeConjugacy.lean
    Quantum/MonodromyBaseChange.lean
    Quantum/NumericalNovikov.lean
    Quantum/NumericalNovikovCompletion.lean
    Quantum/FormalBaseShift.lean
    Quantum/FormalBaseShiftSystem.lean
    Quantum/NovikovAdmissibility.lean
    Quantum/ExponentialDivisorTags.lean
    Quantum/CompletedNovikovSupport.lean
    Quantum/CompletedNovikovConvolution.lean
    Quantum/NumericalCoefficientDescent.lean
    Quantum/CompletedNovikovInverseLimit.lean
    Quantum/NumericalInverseLimitPushforward.lean
    Quantum/NovikovFiltrationContinuity.lean
    Quantum/AssociatedGradedTagging.lean
    Quantum/WeakFactorization.lean
    Quantum/CubicPacket.lean
    Quantum/PacketInvariant.lean
    Quantum/BirationalDeduction.lean
    Applications/CubicThreefold.lean
    Applications/GenusEightThreefold.lean
    Applications/RelativeSixAxis.lean
    Applications/LowDimensionalVanishing.lean
    Applications/FramedOperationFormulas.lean
    Applications/CubicPacketFormula.lean
    Applications/DivisorTaggingVanishing.lean
    PaperInterface.lean
    Verification/AxiomAudit.lean
  verification/
    claims.json
    check_formal_artifact.py
    expected_axioms.txt
```

The exact split may be compressed if a smaller module graph improves review and
build cost, but the semantic separation between proved algebra, external input,
and paper applications is fixed.  `PaperInterface` is the reviewer-facing
mathematical entry point; `Gate` is reserved for operational manifests and is
not used as a public module name.

## Verification and release gates

The aggregate paper check must:

1. lint Lean source and scholarly prose for forbidden workflow/status tokens;
2. reject `sorry`, `admit`, project axioms, unsafe declarations,
   `native_decide`, and undeclared non-kernel execution;
3. build exact targets through the guarded Lean queue;
4. run the semantic gate and capture `#print axioms` for every terminal;
5. compare the terminal set, claim map, and expected axiom output exactly;
6. reject orphaned manuscript claims and unregistered public terminals;
7. rebuild the manuscript deterministically and reject a stale tracked PDF;
8. record source/toolchain hashes and the canonical release-surface identity;
9. pass exporter audit and standalone-repository verification from the committed
   monorepo source.

## Completion gate

C910 is complete only when the package builds from a clean checkout, the
semantic and axiom gates pass, the manuscript claim map states exact coverage
without upgrading conditional results, the tracked PDF and verification output
are current, and the committed paper export verifies byte-for-byte in
`~/src/math-papers/cubic-stabilization-epilogue`.

## Mystery ledger

- **Low-dimensional deduction:** settled at the conditional level.  Once the
  classification, nef spectral restriction, projective-bundle and point-blowup
  formulas, and divisor-tagging comparison are supplied, Lean now proves the
  full quantified proposition.  The remaining gap is exactly those geometric
  and quantum premises, not the induction joining them.
- **Framed operation deduction:** settled at the conditional level.  Lean now
  derives both multiplicity formulas from the exact characteristic-polynomial
  block identities; constructing the geometry and proving Iritani's comparison
  identities in the paper's numerical coordinates remain the open inputs.
- **Cubic packet deduction:** settled at the conditional level.  Lean proves
  exact multiplicity two from Cai's supplied framed characteristic polynomial;
  the geometric connection, integral-loop block comparison, rank-one numerical
  curve lattice, and numerical-Novikov passage remain explicit missing inputs.
- **Divisor-tagging deduction:** settled at the conditional endpoint.  Lean
  transports primitive-sixth multiplicity and vanishing through two supplied
  final polynomial equalities over `ℂ`.  Its finite exponential-character
  independence step, integral separating direction, finite lowest support,
  and noncancellation for supplied leading coefficients are now proved.  A
  proxy detector/compatibility package now conditionally yields full tagged
  injectivity.  Construction of the geometric filtered target and proof that
  it supplies those proxy inputs, together with coefficient-field embeddings,
  common-closure comparison, and bulk-gauge construction remain the exact
  open inputs.
- **External-input closure:** unsettled.  The chief question is how much of the
  recent quantum comparison package can be reduced to algebraic formalism rather
  than retained as explicit premises.  The finite-level algebra is now sharper:
  compatible matrices derive their polynomial inverse system, compatible
  pro-Laurent gauges preserve it under conjugacy, and compatible divisor
  substitutions and gauges derive the bulk system.  The remaining base-shift
  gap is construction and geometric identification of the manuscript's
  coefficient rings, filtration, small monodromy, and the preserving base
  endomorphism realizing its divisor substitution, together with construction
  of its Laurent bulk connection and verification of the formal zero-curvature
  and positivity premises.
- **Closeout `ej`+`tt` pass:** settled the cheap algebraic opportunity.  The
  finite-level formal-base-shift packet now derives not only compatible bulk
  matrices and the substituted polynomial identity, but also compatibility of
  the bulk characteristic polynomials themselves.  No further low-cost
  consequence closes a manuscript row: the remaining obstructions require
  constructing geometric or differential objects rather than composing
  already formalized algebra.
- **Numerical completion:** the completed convolution ring, finite truncation
  compatibility, numerical pushforward ring homomorphism, finite invariant
  packet descent, additive-operator packaging, additive-weight Leibniz identity,
  and quotient-compatible weighted-operator commutation are settled for the
  finite-below support model.
  The coefficientwise inverse limit is explicit and equivalent to the
  completed-family model; numerical pushforward is exactly `mapDomain` at every
  finite level and commutes with reconstruction.  Addition, convolution, and
  pushforward preserve coefficient agreement with identity cutoff modulus.
  Topology and a categorical/topological universal
  property are not represented; the substantive
  missing bridges are geometric Gromov--Witten invariance, construction of the
  additive pairing weights and quantum connection, and the comparison maps.
- **Relative geometry:** unsettled.  The six-axis local-system argument and
  Voisin implication are mathematically human proofs but sit beyond Mathlib's
  present abelian-scheme and decomposition-of-diagonal APIs.
- **Reusable extraction:** deferred.  The matrix-of-ideals theorem may later
  deserve a separate general library, but the first authority remains the
  paper-bundled package.
