# C910 — Lean companion for cubic stabilization

**Lane:** `cubic-threefolds`

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

The package has a pinned standalone Nix and Mathlib environment.  Its Lean
sources build through the guarded queue, and `make check` is green over the
reviewer interface's audited terminals.

**Post-restructure state, 2026-08-18.**  The author's 2026-08-16 atomic
restructure of the manuscript replaced the proof of the headline: Theorem 1.1
is now proved unconditionally in Section 4 through the ordinary Hodge-atom
route and the new residue-discriminant invariant, and the framed `nu_6` route
survives in Section 5 as a conditional refinement under Hypotheses 5.7R and
5.7T.  The claim map was resynchronized under C912 (schema
`cubic-stabilization-lean-claims-v3`): 26 labels added, all `absent`; three
labels dropped, freeing 46 kernel-checked terminals into an explicit
`machinery` bucket with a stated reason per row.  The partition is now 49
claims and 46 machinery rows, covering 29 absent, 10 fragmentary, 9 conditional
deductions, and 1 complete.

The gap audit against that restructure is
[`../2026-08-18-c910-post-restructure-gap-audit.md`](../2026-08-18-c910-post-restructure-gap-audit.md).
Its central finding was a mis-anchored row rather than missing coverage: the
`thm:every-cubic` entry was byte-identical before and after the restructure, so
its two terminals still formalized the packet-and-weak-factorization deduction
that is no longer the paper's proof of that theorem.

**Anchor repaired, 2026-08-18, authority `5d537f713`.**  The framed spine is now
its own manuscript theorem, `thm:every-cubic-conditional`, stated in the
introduction and proved in Section 5, and it carries the two packet terminals.
`thm:every-cubic` is anchored to four new terminals implementing the atomic
route: the residue discriminant of the cubic zero packet is `4/9`, of every
curve residue is `0`, that separation with the parity ranks excludes
representatives of dimension at most two, and the ordinary non-rationality
criterion then gives irrationality of the stabilized fourfold.  Coverage after the priority 0b pass below is
50 claims and 46 machinery rows over 179 terminals: 25 absent, 12 fragmentary,
12 conditional, 1 complete; the paper is warning-free at 49 pages.  Report:
[`../2026-08-18-c910-atom-route-anchor.md`](../2026-08-18-c910-atom-route-anchor.md).
The remaining priority is 0d below, plus the missing
unconditional half of `cor:v14-one-step` and the orphaned machinery themes.

The integral algebra includes the arbitrary-size DVR rank-one criterion,
flattened split-coordinate coefficient lattices, an explicit invertible
extension-ring basis-change transport between distinct base and split axes,
derivation of transported weighted-lattice membership from base symmetry and
the three formal graph-coordinate descent conditions,
faithful-flat ordinary-product descent, square-zero divided powers, the `6I-J` Smith and local-block
calculations, and exact characteristic-two slope-model minimal polynomial,
scalar extension, and repeated-root diagonalization.  The quantum algebra
includes framed-sixth multiplicity for supplied monodromy matrices,
pro-Laurent inverse-system types, an actual subgroup of compatible invertible
families over every fixed Laurent coefficient tower, coefficient-extension and
conjugacy, and the
flat linear-algebra theorem identifying differential constants after
coefficient extension, together with the actual tensor-extended derivation,
its Leibniz and coefficient-constancy laws, and its exact constant subalgebra,
and the canonical horizontal-kernel base-change equivalence with intertwined
and conjugate restricted monodromy and coefficientwise characteristic
polynomial, including its explicit compatible inverse system over every
supplied coefficient-algebra tower.  Canonical adjacent maps between the
scalar-extended horizontal kernels apply coefficient reduction on pure tensors
and intertwine the restricted monodromies.  Every base coefficient tensor with
an original horizontal vector also gives a compatible family over the quotient
tower of a supplied decreasing ideal filtration, and pointwise monodromy agrees
with the original restricted action.  Without stronger hypotheses, no
injectivity or surjectivity is claimed.  For finite-dimensional source space
and an explicitly coefficientwise-complete filtration with zero ideal
intersection, the canonical map is bijective, so every compatible horizontal
family has a unique base tensor.  This is a coefficientwise result, not a
topological or categorical inverse-limit theorem.  The same inverse system is now constructed
on the actual adic quotients `B/I^n` of a supplied coefficient algebra and
ideal, with canonical adjacent quotient reductions; the required completeness
and separatedness properties for the manuscript filtration, and its geometric
identification, remain unproved.  The horizontal
characteristic polynomial over `B` reduces exactly to the polynomial at every
quotient level.  Every fixed
horizontal characteristic-polynomial coefficient is now also packaged as the
compatible quotient family represented by its corresponding base coefficient.
Lean now additionally represents a formal differential module and a conditional
solution presentation with a differential solution algebra, scalar-extended
connection, framed horizontal identification, commuting continuation, and exact
ground-field constants.  From these supplied premises it constructs framed
monodromy, proves coefficientwise characteristic-polynomial base change and
linear-gauge invariance, and, under explicit adic completeness and zero ideal
intersection, identifies framed horizontal tensors bijectively with compatible
quotient-horizontal families.  The manuscript's Levelt--Turrittin algebra,
fundamental solution, continuation, geometric coefficient data, and analytic
framed-monodromy interpretation remain unconstructed or unidentified.
The quantum algebra also includes formal-base-shift and block-formula
deductions, including the exact unital endomorphism of a completed Novikov ring
defined by any supplied multiplicative curve-class character and its
coefficient formula `Q^d ↦ χ(d)Q^d`; the geometric pairing, exponential
character, and divisor equation remain outside that result.  It also includes
the scalar formal exponential `exp(aX)` and proves that its scalar matrix gauge
has inverse `exp(-aX)`, conjugates every formal-power-series matrix trivially,
and preserves its characteristic polynomial.  This does not derive the
geometric string equation or analytic single-valuedness.  The companion further includes
numerical coefficient pushforward, strict-Novikov data,
divisor-tag separation, typed
weak-factorization telescoping, the arithmetic core of Cai's rank-two indicial
polynomial, and the exact implication from a `{1,-1}` characteristic-root
spectrum to low-dimensional sixth-root vanishing.  The cycle side now also
contains the exact fibrewise deduction from supplied primitive-minimal-class
algebraicity and Voisin's supplied equivalence to universal `CH₀`-triviality.
The four conclusions of the separation-family headline are also assembled in
one conditional theorem with every Chow, packet, and period-map input exposed.
The relative-six-axis row now has an opaque organizational signature for all
named geometric assertions and independently proved algebraic content: the
full integral Smith witness and, after tensoring with any `F₂`-module `T`, an
explicit linear identification of the two-primary coefficient kernel with four
copies of `T`.  This gives order `2⁸` for a two-dimensional tensor factor and
identifies the scalar coordinates with `Aug(F₂⁶)/⟨1⟩`; their normalized dot
product is bilinear, alternating, nondegenerate, and preserved by the full
generated six-point action.  After choosing a symplectic basis of the
two-dimensional factor, the induced rank-eight tensor-product form is also
alternating and nondegenerate, and every isotropic four-dimensional subspace
is maximal.  The explicit two-heart equivalence preserves this form and
identifies the five projective-line packet members exactly with the diagonally
stable maximal-isotropic subspaces of the rank-eight discriminant.  Lean now
also gives the parallel three-primary coefficient calculation explicitly:
`H₃ = Aug(F₃⁶)/⟨1⟩`, the normalized coefficient form is minus the dot
product descended through the constant line, the quotient chart intertwines
the induced generators, both coefficient and tensor forms are invariant, and
the four stable maximal-isotropic halves are the three scalar
graphs and the vertical line in `P¹(F₃)` (made affine by changing the marked
symplectic ruling when necessary).  Identifying this model with the geometric
three-primary discriminant and kernel remains open.  From a
supplied fibrewise coordinate realization whose image is exactly the named
geometric kernel, Lean constructs a kernel-to-subspace equivalence and proves
that every fibre belongs to the five-member packet.  The coordinate
realization, stability, and maximal isotropy remain supplied.  The row remains a
fragment rather than a conditional proof of the scheme-theoretic lemma.
Independently, the concrete ten-element dihedral stabilizer of every axis has
an exactly one-dimensional fixed subspace in the rational six-label
augmentation representation, generated by the vector with coordinate `5` at
that axis and `-1` elsewhere.  The sum `N` of the ten stabilizer action
operators has exactly this line as its range, satisfies `N² = 10N`, and gives
an idempotent projector after scaling by `1/10`.  Every axis stabilizer is
self-normalizing, and an object fixed by the source stabilizer has
transporter-independent image at a fixed target label.  The six rational axis
vectors sum to zero, and their equivariant synthesis identifies the quotient
of the six-coordinate module by its constant line with the augmentation
module.  Identifying these coordinate results with the geometric
endomorphisms, elliptic axes, and primitive inclusions remains open.  Integrally,
Lean identifies `ℤ⁶/ℤ1` with five coordinates and proves that the descended
six-coordinate form has matrix `6I₅-J₅` in that chart and is invariant under
the induced full permutation action; no geometric
polarization is inferred.
The referee repair also makes the generic non-CM reduction explicit from the
positive-dimensional period image, classifies every stable half in the
semisimple two- and three-primary multiplicity modules, identifies the
two-primary invariant form with its trace-determinant model up to the stated
basis normalization, and derives the local graph-coordinate matrix from the
source and quotient lattices.  The quantum comparison audit now names the
coefficient domains, complete separated filtrations, compatible reductions,
divisor substitutions, and integral-`z` comparison maps in the cited blowup
and projective-bundle theorems.  These are proof-strengthening repairs only;
no manuscript theorem or Lean coverage status was downgraded.
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
The manuscript now states explicitly that this count is for the small even
connection, so no odd-cohomology block is being suppressed.
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
coefficient homomorphisms.  Lean also proves directly that the potentiality
identity for mixed connection derivatives together with pairwise commutativity
of the connection matrices implies zero curvature, isolating the exact
Frobenius-product bridge used in the manuscript.  This applies to ordinary Laurent-series
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

The concrete six-point characteristic-two augmentation quotient now has
explicit four coordinates modulo its constant line; translation and inversion
identify the labels with the actual `P¹(F5)`, where they are induced by the
linear maps `(x,y) ↦ (x,x+y)` and `(x,y) ↦ (y,-x)`, and preserve a displayed
one-factorization whose faithful factor action exhausts the alternating group
`A5`; the induced heart is simple and its common commutant is exactly the
quadratic four-element algebra, both for the two generators and for every word
in the full generated action.  A subspace of two heart copies is
four-dimensional and stable under the diagonal action exactly when it is the
vertical half or the graph of one of those four commutant endomorphisms; these
five subspaces are distinct.  An explicit equivalence with the actual
`P¹(F4)` sends its vertical chart point to the vertical half and the affine
labels `0,1,root,root+1` to the graphs of `0,1,W,W+1`; the explicit alternating
form on the two heart copies is nondegenerate, and the five packet members are
exactly the diagonally stable maximal-isotropic subspaces.  The chosen
symplectic coordinates identify the rank-eight tensor discriminant with this
two-heart model, preserve the form, and transport the exact classification.
All six Sylow-five subgroups of this concrete
`A5` are now constructed, and their conjugation action is exactly the original
six-point action.  The resulting Sylow-five packet is explicitly equivalent to
`P¹(F5)`.  Each ten-element normalizer is explicitly equivalent to
`D5`.  The faithful natural `PSL₂(F5)` action on this projective line is now
constructed, has proved order `60`, realizes the displayed generators by
determinant-one matrices, and is identified with the same concrete `A5` by an
isomorphism intertwining the full six-point actions.  Each natural projective
point stabilizer has order ten and is explicitly equivalent to `D5`.
Both the natural projective action and the conjugation action on Sylow-five
subgroups are two-transitive, formalizing the transitivity input used by the
six-axis intersection calculation.
Identifying this concrete
packet with the manuscript's geometric `D5`
subgroups and axes remains open.  The explicit
characteristic-two companion model now has a constructed
quadratic finite-etale splitting field, marked root, and two-sided explicit
eigenbasis, together with an algebra equivalence to the concrete `F4` gluing
field that carries the marked root into the two-element exotic Frobenius
orbit and realizes that orbit as a distinct two-cycle in both affine-chart
coordinates and the actual five-point projective line; Lean also proves that
these are exactly the two nonfixed projective points.  Its identification with the manuscript's geometric marked
extension and principal kernel remains open.  Lean now proves the exact
connected-family persistence step for any supplied continuous map into a
finite discrete kernel packet and specializes it to the transported marked
quadratic pair both in affine-chart coordinates and directly in the actual
projective line over `F4`; construction of that geometric packet and
classifying map remains open.  A nonfixed Frobenius value at one fibre now
suffices to identify and propagate the exact marked pair.  All other geometric
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

## Prioritized Lean backlog

Work in this order unless a later literature or library dependency changes the
cost materially.  Priorities 0a--0d supersede the older ordering below until
they are done; they come from the 2026-08-18 gap audit.

0a. **Re-anchor the headline — done 2026-08-18.**  The atom-route deduction is
   in `Applications/CubicAtomOneStep.lean` over the ledger in
   `Quantum/OrdinaryAtomLedger.lean`, and the residue arithmetic is in
   `Quantum/AtomicResidueDiscriminant.lean`.  Still open from this item: the
   unconditional half of `cor:v14-one-step`, which compares the two projective
   bundles birationally and applies the atomic one-step theorem.
0b. **Tier-one arithmetic — done 2026-08-18.**  The two residue computations
   landed with 0a.  The product-formula corollaries `cor:p3-nu6` and
   `cor:cubic-product-nu` are in
   `Applications/ProjectiveProductMultiplicity.lean`, conditional on the
   manuscript's product formula for a product with a projective space and on
   involutive framed monodromy at a point; the value four after one
   stabilization no longer assumes the cubic packet value, which comes from the
   block reduction.  `lem:six-point-hearts` is in
   `GraphLattices/SixPointHeartEndomorphisms.lean`, recorded as a fragment
   because the endomorphism algebras are exhibited by generators and relations
   rather than by an isomorphism with named field objects.  Report:
   [`../2026-08-18-c910-hearts-and-product-corollaries.md`](../2026-08-18-c910-hearts-and-product-corollaries.md).
0c. **`prop:cubic-block-data` — done 2026-08-18.**  The constant change of basis,
   both conjugations, the two supplied gauge orders, and the modified residue
   with its indicial polynomial are in
   `Quantum/CubicSmallEvenBlockReduction.lean`, recorded as a fragment because
   uniqueness of the normalized gauge and the orders beyond the second are not
   formalized.  `prop:cubic-packet` gained a second terminal whose premise is
   only the passage from residue exponents to framed monodromy.  Report:
   [`../2026-08-18-c910-block-reduction.md`](../2026-08-18-c910-block-reduction.md).
0d. **The rank-two invariant chain.**  `lem:horiz`, `lem:orthogonal`,
   `lem:A0preserve`, `prop:rank2-rigidity`, and
   `prop:residue-discriminant-exponents`, then `prop:no-curve` and
   `prop:no-surface` as typed deductions on top.


Completed in the current tranche: the **three-primary coefficient packet**,
including `H₃`, its normalized symmetric minus-dot-product form, the explicit
quotient action, tensor symplectic model, the exact four-half classification
`P¹(F₃)`, and maximal isotropy.  Its geometric discriminant identification remains part of
priority 2 below.

1. **Explicit six-axis local-chart bridge.**  Connect the concrete `6I-J`
   lattice and both primary packets to the abstract graph-coordinate and
   self-adjoint lifting theorems, reducing the supplied local-chart premises.
2. **Relative six-axis geometry.**  Replace opaque inputs by actual elliptic
   schemes, quotient and inclusion maps, the relative isogeny, polarization
   pullback, discriminant kernels, and continuous packet classifier.
3. **Geometric cohomology realization.**  Identify the formal graph divisor
   lattice with the intermediate-Jacobian divisor lattice and transport the
   all-degree saturation theorem to the principal minimal class.
4. **Quantum instantiation.**  Connect the formal completed-series,
   finite-quotient gauge, numerical base-change, and divisor-tagging machinery
   to genuine Gromov--Witten quantum connections and the Iritani and
   Iritani--Koto comparison maps.
5. **Cubic spectral endpoint.**  Formalize Cai's cubic block diagonalization
   and identify its characteristic polynomial with the framed-monodromy
   polynomial used by the multiplicity terminal.
6. **External theorem closure.**  Only after the paper-specific bridges above,
   formalize or import the large cited inputs needed to upgrade the nine
   conditional deductions: Voisin's criterion, weak factorization, the
   Iritani comparison theorems, the low-dimensional classification inputs,
   and related geometric results.

The submission-ready partial-companion gate does not require all remaining
items: every claim is tracked at its exact strength, and the coverage snapshot
discloses the machinery count.  This list is the route from the current
partition toward an end-to-end formalization; no item authorizes downgrading a
manuscript theorem or hiding an external premise.

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
    GraphLattices/SixPointStableHalves.lean
    GraphLattices/SixPointHeartEndomorphisms.lean
    Quantum/FramedMultiplicity.lean
    Quantum/ProLaurent.lean
    Quantum/CompatibleMonodromySystem.lean
    Quantum/ProLaurentGaugeConjugacy.lean
    Quantum/MonodromyBaseChange.lean
    Quantum/HorizontalMonodromyBaseChange.lean
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
    Applications/ProjectiveProductMultiplicity.lean
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

- **Three-primary coefficient packet:** settled algebraically.  Lean now
  constructs the literal quotient
  `Aug((ZMod 3)^6)/<1>`, proves its linear equivalence with the normalized
  four-coordinate heart, and classifies the four stable maximal-isotropic
  halves.  The remaining issue is geometric: identifying this quotient and
  form with the manuscript's discriminant module and its actual kernel.
- **Low-dimensional deduction:** settled at the conditional level.  Once the
  classification, nef spectral restriction, projective-bundle and point-blowup
  formulas, and divisor-tagging comparison are supplied, Lean now proves the
  full quantified proposition.  The remaining gap is exactly those geometric
  and quantum premises, not the induction joining them.  The manuscript also
  now points explicitly to the proof that every weak-factorization center
  specialization is strictly Novikov-admissible before applying this vanishing.
- **Framed operation deduction:** settled at the conditional level.  Lean now
  derives both multiplicity formulas from the exact characteristic-polynomial
  block identities; constructing the geometry and proving Iritani's comparison
  identities in the paper's numerical coordinates remain the open inputs.
- **Cubic packet deduction:** settled at the conditional level.  Lean proves
  exact multiplicity two from Cai's supplied framed characteristic polynomial;
  the geometric connection, integral-loop block comparison, rank-one numerical
  curve lattice, and numerical-Novikov passage remain explicit missing inputs.
  The manuscript now points to Cai's displayed scalar solutions on pp. 5--7:
  each is an exponential in \(z^{-1}\) times an integral-power series, which
  justifies the two unit framed factors rather than inferring them from the
  weaker wording of Proposition 6 alone.  This passage was checked in
  arXiv:2608.01577, cache SHA-256
  `06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e`.
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
  of its Laurent bulk connection and verification of the potentiality,
  commutative-associative product, and positivity premises.  Lean now derives formal
  zero curvature from the first two identities rather than retaining it as an
  opaque premise.  The manuscript's coefficientwise base-change lemma now
  states the exact Levelt--Turrittin solution-algebra and constant-field input,
  and its pro-Laurent definition records a compatible polynomial system before
  using completeness and separatedness to recover one polynomial over the base.
  The human base-shift proof now also writes the multivariable coefficient
  recursion explicitly and proves that \(G_\alpha\) has no loop power below
  \(-|\alpha|\); modulo \(F^N\), the evaluated gauge therefore has Laurent
  lower bound at least \(-(N-1)\), rather than taking finite-level boundedness
  as an input.
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
  The manuscript now writes the numerical coefficient pushforward explicitly
  as the finite fibre sum, states why it is a unital completed-convolution
  homomorphism, and identifies the curve pushforward, divisor weights, and
  Novikov derivations as fibrewise constant.  This aligns the human
  numerical-base-change proof with the kernel-checked algebraic terminal.
- **Relative geometry:** unsettled.  The six-axis local-system argument and
  Voisin implication are mathematically human proofs but sit beyond Mathlib's
  present abelian-scheme and decomposition-of-diagonal APIs.  The
  scheme-theoretic image step is now pinned to Achter--Casalaina-Martin--Wise,
  Theorem~A: over the characteristic-zero base the norm image is an abelian
  subscheme and its quotient factorization commutes with base change.  The
  source was checked at the theorem statement and characteristic-zero clause
  in arXiv:2312.13262v2, cache SHA-256
  `4cb31c6be7fae97742df78079b9296c6547aaa1e1b1f81706695a58cac8e7a81`.
  Generic-fibre identities are now extended by the explicit density and
  separatedness argument rather than an uncited rigidity slogan.  The
  separation-family proof now pins non-isotriviality to Hartlieb's
  one-dimensional intermediate-Jacobian image (Proposition 5.7).  The
  principal-packet exclusion no longer relies on the shorthand that the
  generic cubic has automorphism group exactly \(A_5\): Strong Torelli would
  produce a faithful \(S_6\)-action, which Hartlieb's Theorem 2.1 excludes
  because five listed ambient groups have order below \(720\), while the
  remaining group has order \(9720\), not divisible by \(720\).  The descent
  now treats the full kernel: the two-primary rational graphs and the
  three-primary scalar graphs are all \(S_6\)-stable.
  The local-chart proof now also states why the unit summand has no
  \(p\)-primary kernel and invokes the packet classification fibre by fibre:
  the two exotic slopes share the squarefree polynomial \(t^2+t+1\), while
  every three-primary half is a scalar graph.  It no longer appeals to an
  unspecified persistence of local presentations.
  The prescribed graph-divisor lattice and its product image are now defined
  from a fixed elliptic-power quotient.  A division-free matrix correction
  lifts each reduced isotropic slope to an integral dual-self-adjoint
  depth-preserving endomorphism, closing the integral graph-presentation
  hypothesis at both primes.
  The global divided-power application now names the finitely generated
  quotient in which all \(p\)-adic images vanish and identifies the principal
  polarization with a descended graph divisor via
  \(f_b^*\Theta_b=\lambda_{\mathcal A_b}\), rather than leaving both bridges
  implicit.
  The graph-lattice proof now also gives the missing splitting mechanism:
  completeness lifts the primitive idempotents of the finite-etale quotient,
  polynomial dependence on the self-adjoint slope makes their images
  orthogonal, and scalarity modulo the relevant depth gives the displayed
  block form.
  The relative six-axis proof now derives the relation \(\sum_H i_H=0\)
  directly inside \(\operatorname{Hom}^0(E,J)\simeq W_5\): coherent transport
  makes the sum \(A_5\)-invariant, and \(W_5\) has no invariant line.  This
  replaces the shorthand that the inclusions are simply the six displayed
  coefficient vectors.
  Roulleau's Albanese construction has also been checked at the exact bridge:
  Lemma 17 constructs the elliptic quotient by a four-dimensional abelian
  subvariety, and the following sentence applies the same construction to
  Theorem 11(D).  The manuscript now uses that connected kernel to identify
  the primitive Rosati dual with the norm image and to justify that the fibre
  intersections compute the actual relative maps.  The checked source is
  arXiv:1002.4467, cache SHA-256
  `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
  The manuscript now also identifies the actual two-primary discriminant
  pairing, rather than silently restricting a form that vanishes modulo two:
  on augmentation lifts it is
  \(\frac12x^{\mathsf t}(6I_6-J_6)y=\bar x\cdot\bar y\pmod2\).
  Its well-definedness, alternation, and nondegeneracy explain precisely why
  the commutator pairing is the tensor product of the formalized coefficient
  form with the Weil pairing.  The manuscript now also spells out the order
  calculation behind maximal isotropy: the polarization type gives kernel
  order \(6^8\), the pullback identity gives isogeny degree \(6^4\), and
  functoriality makes the isogeny kernel isotropic; its two-primary part
  therefore has order \(2^4\) inside the rank-eight discriminant local system.
- **Universal \(CH_0\) bridge:** source-checked.  Voisin's Corollary 4.4 states
  exactly that a smooth cubic threefold is universally \(CH_0\)-trivial if and
  only if \(\theta^4/4!\) is algebraic on its intermediate Jacobian.  The
  manuscript produces that class as an ordinary product of integral divisor
  classes, so the cited implication has no missing cycle-theoretic premise.
  The source passage was checked in arXiv:1407.7261, cache SHA-256
  `514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`.
- **Third cold-review repair (`RT3-*`):** the red-team found no fatal
  counterexample but rejected two bridges.  `RT3-001` is closed by comparing
  the normalized connection and Iritani's mutually inverse maps after the
  canonical base change at every finite quotient
  `R_j/J_j^N -> S_j/(J_j S_j)^N`, then taking the inverse limit in Iritani's
  completed comparison ring; no unproved embedding of the abstract
  completion into a Laurent field is used.  `RT3-002` is closed by recording
  explicitly in the claim inventory that the manuscript's geometric
  three-primary discriminant and maximal-isotropic kernel were not formalized.
  The coefficient heart, normalized form, tensor pairing, and four formal
  maximal-isotropic halves are now formalized; their geometric identification
  remains absent.  `RT3-003` is closed by lifting the changed
  three-primary ruling through `Sp_2(Z_3) -> Sp_2(F_3)` and retaining the
  depth-one scale `P=3I`.  `RT3-004` is closed by the Hilbert-class-polynomial
  function-field argument and by placing it after identification of the norm
  axis with Hartlieb's elliptic factor up to isogeny.  `RT3-005` is closed by
  giving the Atlas table version and exact characteristic/ring/dimension/ID
  rows.  The guarded authority gate passes after all five repairs.
- **Fourth whole-paper referee pass (`R4-*`):** general, geometry/cycle, and
  quantum referees all returned GO with no fatal or major mathematical issue.
  The accepted low-cost polish now descends the general graph expansion to
  `O` rather than prematurely to `Z_p`, states the unit-block argument away
  from two and three, places the generic non-CM argument before its first use,
  requires the divisor exponentials in the formal base-shift lemma to define
  a continuous coefficient automorphism, and uses the kernel filtration
  `F^N B_j = ker(B_j -> R_j/J_j^N)` rather than identifying it silently with
  powers of an extended ideal.  The public summary's reproduced abstract was
  already verbatim current; its two stale scope phrases were corrected to say
  that six-axis structure proves universal `CH₀`-triviality for the existing
  pencil and that the obstruction controls one projective-line stabilization,
  not arbitrary stable rationality.
- **Six-axis polarization inputs:** source-checked.  The manuscript now cites
  Roulleau's Theorem 11(D) for the dihedral fibre and, separately, Lemma 14
  together with table (3.1) for deformation-invariance and the exact
  order-two/three/five intersection values.  This prevents the Klein-fibre
  table from being used silently on the whole \(A_5\)-family.  The passage was
  checked in arXiv:1002.4467, cache SHA-256
  `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
  The polarized reduced-norm formula now also states that its trace is the
  degree-five coefficient trace, avoiding a factor-two ambiguity with rational
  first homology.
- **Reusable extraction:** deferred.  The matrix-of-ideals theorem may later
  deserve a separate general library, but the first authority remains the
  paper-bundled package.
