# C925 -- modular direct-QDM proof packet

**Lane:** cubic-threefolds

**Status:** the no-Stokes row providers are ruled out.  Two row-free
alternatives remain.  `LoopStabilizerPath` transports an exact source period
provided every correction packet excludes it.  For a connected native
pure-Euler **inner** cycle in one fixed outer factor, the strict
cyclic-carrier reduction forces codimension two; the all-\(n\) companion
calculation then predicts discriminants \(0\) or \(4\), not \(4/9\).
For \(m=2\), the nonsplit outer-return period law and the accepted
low-dimensional marker theorem remove codimensions three through five; the
only remaining correction theorem is exact-three exclusion in the single
outer factor attached to each connected codimension-two threefold-center
occurrence.  For general \(m\), lower-period inner
returns after a nontrivial outer orbit remain.  Neither published comparison
supplies the required occurrence-labelled primitive loop or saturated
native-effective carrier.  The row-free period argument uses the exact cubic
marker \(\delta^\sharp=4/9\), not merely \(\delta^\sharp\ne0\).  A
pairing-preserving parabolic shear gives the exact \(4/9\) block while fixing
the unit and both divisor vectors, so generic Frobenius-algebra and divisor-
generator data do not replace the missing effective large-radius
calibration.  A regular unital projector descent would force the carrier to
be the whole rank-six even cohomology.  Elias--Rossi then reduce its classical
local Gorenstein algebra to two types, but explicit graded self-dual orders
with the same generic paired \(C_3\)-algebra and marked divisor realize both
special fibres.  The missing theorem must retain the full QDM/divisor-equation
calibration, not only the native order.  Lean now checks one normalized
generic primary reduction for each type: the dual-number reduction has residue
discriminant zero, while the distinct-root reduction does not preserve the
leading nilpotent line and hence does not admit the marker's elementary
modification.  Thus either normalized calibration excludes \(4/9\); the
remaining source theorem must construct one from the geometric occurrence.
The strict companion equality case is independently certified: an exact Rust
solver finds the unique normalized gauge in both endpoint orientations, Lean
rechecks the full recurrence and discriminants \(0,4\), and a typed
`Calibration` theorem transports this exclusion to any simultaneously
intertwined native model.  This closes the finite recurrence consumer, not the
native calibration provider.
The programme-wide information-loss lens suggests a smaller candidate source
datum than the full calibration: a **marked Rees port** consisting of the
self-dual Kummer coweight and the first marked connection/Rees jet.  The two
known red modes are independent: the explicit dual and distinct-root orders
have relative coweight \((-1,0,0,0,0,1)\), while a coweight-zero parabolic
shear changes the marker through its first jet.  This is a testable
reconstruction proposal, not yet a source theorem.  The first exact
Rust-to-Lean boundary certificate now recomputes that coweight and verifies
the nonzero pairing-compatible shear jet.  It proves the two ambiguity modes
are real.  A second exact certificate exhausts the effective coweight-zero
dual-number chart.  Correct input-index transport reduces every conformal
calibration to one parameter, and Lean checks the full recurrence and residue
discriminant zero throughout that family.  It also rejects the output-only
transport mutation which produced the raw \(4/9\) shear.  Nonzero-coweight and
distinct-order charts, and the geometric occurrence-to-port theorem, remain.
The unconditional every-smooth theorem is not landed.  Independently, Voisin
plus the 2025 Engel--de Gaay Fortman--Schreieder parity theorem gives an
all-\(m\) proof for a very general cubic; that preprint result must not be
promoted to every smooth cubic.

## Goal

Land the every-smooth \(m=2\) theorem, ideally uniformly in \(m\), without a
Stokes connector.  Keep the finite consumer and the external geometric
provider separately typed.  The live source targets are exact-period
exclusion for every correction packet in every codimension, or prior
inner-orbit provenance followed by native-effective descent and pure-Euler
realization of that orbit.

## Stable entry points

- proof-packet index:
  notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md
- \(m=2\) and cofinal-index report:
  notes/2026-08-20-c925-m2-roadmap-and-unbounded-stabilizations.md
- power-image/ExactTop report:
  notes/2026-08-20-c925-power-image-leakage.md
- oriented-heart adapter:
  notes/2026-08-20-c925-oriented-heart-adapter.md
- dependent provider typing:
  notes/2026-08-20-c925-dependent-provider-typing.md
- type-level precedent audit:
  notes/2026-08-20-c925-type-level-precedents.md
- Iritani provider-gap and threshold-image audit:
  notes/2026-08-20-c925-iritani-provider-gap.md
- Gamma--monodromy detour:
  notes/2026-08-20-c925-gamma-monodromy-detour.md
- mobile hyperplane line-bundle state:
  notes/2026-08-20-c925-mobile-line-bundle-state.md
- logarithmic exceptional-correction pencil:
  notes/2026-08-20-c925-logarithmic-pencil-law.md
- Orlov helix-wrap and thickened-center leakage:
  notes/2026-08-20-c925-orlov-helix-wrap.md
- Gamma support collision and rank-row replacement:
  notes/2026-08-20-c925-gamma-support-collision-and-rank-route.md
- rank-quotient one-path compression:
  notes/2026-08-20-c925-rank-quotient-path-compression.md
- point-line duality compression:
  notes/2026-08-20-c925-point-line-duality-compression.md
- commuting-unipotent point-line no-go:
  notes/2026-08-20-c925-unipotent-point-line-no-go.md
- charge-filtered Stokes specialization:
  notes/2026-08-20-c925-charge-filtered-stokes-specialization.md
- Kummer charge regression and stationary polygon obstruction:
  notes/2026-08-20-c925-kummer-charge-regression.md
- \(m=2\) receiver-overlap localization and neutral-slope sieve:
  notes/2026-08-20-c925-m2-receiver-overlap-localization.md
- non-\(m=2\) categorical dividends:
  notes/2026-08-20-c925-non-m2-categorical-dividends.md
- conditional Section 6 specialization:
  notes/2026-08-20-c925-framed-m1-specialization.md
- saturated-confluence and normalized-primary-coimage source extension:
  notes/2026-08-20-c925-saturated-confluence-primary-coimage.md
- projected Stokes variation and middle-extension saturation:
  notes/2026-08-20-c925-projected-stokes-variation.md
- source-typed safe-overlap provider:
  notes/2026-08-20-c925-source-typed-overlap-provider.md
- double-normal projected-variation source theorem:
  notes/2026-08-20-c925-double-normal-projected-variation.md
- eigenrow image factorization and fixed-summand test:
  notes/2026-08-20-c925-eigenrow-image-factorization.md
- separable primitive-projector no-go:
  notes/2026-08-20-c925-separable-primitive-projector-no-go.md
- exact unit-window intersection enumeration:
  notes/2026-08-20-c925-unit-window-intersection-enumeration.md
- crossed-edge provenance lens and composition law:
  notes/2026-08-20-c925-crossed-edge-provenance-lens.md
- adapted diagonal coefficient trait:
  notes/2026-08-20-c925-diagonal-coefficient-trait.md
- two-layer elliptic-resolvent/Kummer descent packet:
  notes/2026-08-21-c925-two-layer-resolvent-packet.md
- outer Kummer variable and carrier boundary:
  notes/2026-08-21-c925-outer-kummer-and-carrier-boundary.md
- pointed-row compression, open-gate ledger, and route audit:
  notes/2026-08-21-c925-pointed-row-calibration.md
- no-Stokes external-source dossier and exact provider boundaries:
  notes/2026-08-21-c925-no-stokes-source-dossier.md
- indirect stable-rationality predictions and the very-general benchmark:
  notes/2026-08-22-c925-indirect-rationality-predictions.md
- cubic Kummer derivative, divisor generator, and calibration boundary:
  notes/2026-08-22-c925-kummer-divisor-generator.md
- programme-level marked Rees shadow, exact coweight calculation, and
  certificate-first experiment:
  notes/2026-08-22-c925-marked-rees-shadow.md

The packet index owns the module-to-file map.  Do not append another large
module to this card or to the index; add one focused companion file and one
index row.

## Kernel-checked mathematics and current boundary

- `RowedProjectorDecomposition` proves the one-edge row-visible-projector
  equivalence, and `RowedProjectorPath` proves the finite telescope after one
  native carrier, row, and projector are assigned to every vertex.  The
  geometric proof must still show that every edge occurrence is a faithful
  pullback of that native datum, or place the finite path over one common
  conservative coefficient field.  Without this clause, two incident edges
  may use unrelated realizations of their nominally shared vertex.
- Iritani Proposition 5.1, Theorem 5.2, Proposition 5.4, and the definition
  of the Theorem 5.18 comparison derive the exact rank-row square on the same
  completed map for an arbitrary smooth center.  Gu--Yu--Yu is now a
  simple-wall corroboration, not a source that must be fused with Iritani.
- C924/KKPYY spectral-extension uniqueness derives the full stable-projector
  square from the `z=0` coprime-factor projector.  This formal projector is
  `z`-adic, while the Iritani row uses the negative-`z` fundamental-solution
  completion.  No cited theorem yet puts them on one faithful even
  coefficient object; full big QDM also has odd nilpotent bulk coordinates.
- `TwoBaseRowedProjectorEdge` permits each vertex to retain its own native
  coefficient ring; two faithful extensions to one edge ring and explicit
  semantic endpoint identifications produce the intrinsic path edge.
  `CoprimeFactorProjector` constructs and transports the marked projector from
  explicit coprime factors, Bezout coefficients, and product annihilation.
- `StableRationalityConsequences` exposes the pre-factorization proof layer.
  A hypothetical stabilized birational parametrization forces the rational
  value of any explicitly supplied stable invariant, or transports a
  projective-space witness after an explicitly supplied projective-factor
  cancellation theorem.  Rational stabilization indices form an upper set.
  The module also rejects cancellation by a bare nonzero multiplicity over
  `ZMod (m+1)` at \(m=1,2,3,4,13\), and gives an abstract monoid/group
  countermodel showing that a signed-class identity does not formally imply
  a positive representative.
- `R10AlbaneseParity` independently checks the finite \(R_{10}\) computation
  in Engel--de Gaay Fortman--Schreieder, arXiv:2507.15704v3, Proposition 7.6.
  Ten explicit row-span masks factor the colour-profile matrix through the
  \(160\times160\) constraint matrix, so Lean proves profile vanishing for
  every admissible vector.  The tracked Python certificate independently
  reconstructs the graph and recomputes both ranks.  This strengthens the
  very-general all-stabilizations route only; the geometric reduction,
  regular-matroid theorem, and theta-class deduction remain imported.
- De Gaay Fortman--Schreieder, Compositio 161 (2025), Theorem 1.2 gives a
  refereed, independent rigidity check: no power of the intermediate Jacobian
  of a very general cubic is isogenous to a product of curve Jacobians.  This
  still has the very-general quantifier and is not a formal consequence of
  stable rationality in dimension \(m+3\), where higher-dimensional centres
  can contribute general abelian factors.
- `KummerDivisorGenerator` proves three finite implications available after a
  geometric occurrence has been constructed.  A commuting derivative with
  fixed kernel preserves an order-three fixedness fingerprint; the trace of
  a projected multiplication commutator vanishes; and three distinct divisor
  eigenvalues generate the split cubic algebra by a Vandermonde isomorphism.
  `ExactCubicPoint` packages rank two, nonzero nilpotent, and exact
  discriminant \(4/9\) as a subtype.  A geometric provider must still put the
  actual loop on that subtype.  These implications neither descend the
  occurrence nor remove the regular base gauge of a moving spectral frame.
- The modular \(m=1\) proof is sound from its stated Iritani,
  Iritani--Koto, and weak-factorization inputs.
- Guéré/BFGMP and KKPYY are lawful split specializations at the algebraic
  interface level, with their geometric provider hypotheses kept explicit.
- The augmented operator-row category has a genuine two-sided
  output-kernel ideal; the naked row-null class does not.
- Reader/indexed-State/Writer, optics, path functors, torsor holonomy,
  sparse reconstruction, and universal sufficient shadows have exact laws.
- Irrationality on any unbounded stabilization set implies irrationality at
  every index.
- Fixed-factor products have the unique extremal source line.
- The power-image functor and its snake boundary give the exact minimal
  extension leakage seen by the Jordan endpoint consumer.
- In an opposite-oriented exact heart, ambient-to-exceptional Hom
  orthogonality kills that boundary; a nonsplit quiver model shows this is
  weaker than splitting at the heart level.
- The minimal dependent provider record separates occurrence, orientation,
  exponent, component/kernel typing, and exact realization.  It proves no
  extra source augmentation is consumed and prevents those fields from
  being silently identified.
- The cubic/product source \((\chi,N,N^{m+1}=0,N^mV\ne0)\) is sufficient
  for the ExactTop endpoint.  Bare formal QDM is not yet comparison-sufficient:
  the current \(N_L=1-\tau_L\) uses tensor-by-\(L\) on \(K_0\), so the
  provider needs a compatible cyclotomic operation realization.  No extra
  point/Gamma row is consumed.
- For a fixed Iritani direct-sum comparison, rank/Boolean ExactTop transport
  needs only that the transported top image be a graph over the ambient top.
  Full \(N\)-equivariance and even strict image equality are stronger.
- Gamma framing identifies tensor-by-line-bundle with large-radius
  monodromy, so a horizontal common-loop comparison can transport the
  complex operation without preserving the Gamma lattice.  Iritani's
  Fourier projections already expose the correct local divisor directions;
  the exact cocharacter/Levelt instantiation remains typed provider work.
- A hypothetical birational map supplies its own coherent mobile hyperplane
  state.  Its strict-transform corrections form a signed
  Picard-groupoid/Cartier-\(b\)-divisor Writer law, and its source retains
  nonzero \(\operatorname{Top}_m\).  Raw exceptional corrections are not
  null—the linear-projection resolution creates a hostile \(J_3\)—so the
  open theorem must live in the common primitive-character receiver.
- For commuting unipotent pullback and exceptional actions, logarithm loses
  no Jordan data and replaces \(1-AC^a\) by \(X+aY\).  At \(m=2\) the
  correction is one mixed term after the pure exponent certificates; for
  general \(m\) it is a finite mixed-word interface.
- Orlov ambient projection makes both branches of the mobile correction
  explicit.  Exceptional helix wraps are center Gysin terms, while twisting
  an ambient input differs from the identity by a thickened-center object
  filtered by symmetric normal-bundle coefficients.  Hence one exact
  whole-center-null receiver kills every base multiplicity on the
  correction side; constructing that primitive-character receiver remains
  open.
- Ordinary Gamma projection cannot supply that receiver: the point class on
  a cubic has nonzero projection to both primitive-sixth branches.  The
  same calculation proves the fixed-phase ambient-rank row is nonzero.  On
  algebraic \(K_0\), that row kills every exceptional Orlov image; promoting
  this square through the sectorial QDM comparison is the leading uniform
  all-\(m\) gate.
- The rank consumer is only the line \(V/\ker\rho\).  Along one chosen weak
  factorization, local comparison-induced line isomorphisms and lawful
  adjacent reindexing telescope automatically.  Scalar normalization,
  trivial holonomy, and equality of unrelated paths are unnecessary.
- With the perfect \(\chi^{-1}\)-by-\(\chi\) pairing, that local row law is
  equivalent to transporting one projective Gamma point line with zero
  exceptional coordinate.  Iritani's formal comparison has the required
  point shape, and the full Gamma point section is line-bundle-monodromy
  invariant; the remaining calibration is fixed-phase Gamma-to-formal.
- Picard monodromy cannot prove that calibration by fixed-line uniqueness:
  every nonzero exceptional unipotent module, even for an arbitrary
  commuting family pointwise, has a common fixed vector.  A selector must
  instead use a multiplicity-one filtered/semisimple/support-sensitive
  quotient or a genuinely different operation.
- A common pointed charge filtration would supply such a quotient: every
  positive-charge exceptional Stokes factor acts trivially on degree zero,
  through products, inverses, and refactorizations whose factors remain in
  the same positive congruence and common receiver.  This is an
  exact uniform replacement for local zero leakage, but it requires a new
  occurrence-indexed, zero-reflecting charge realization.  Bare KS support
  and coefficientwise Stokes positivity are insufficient.  The hostile
  \(-1/R\) coefficient passes the finite exponential-support regression: it
  lies on exponent \(-1\), hence in positive degree after orienting the
  one-sided cone.  The remaining regression is whether the analytic Stokes
  factor retains this label and whether all occurrences avoid opposite or
  zero charge.
- The bounded pilot trace now separates three facts.  The actual split toric
  and \(\operatorname{Bl}_X\mathbf P^5\) point coefficients have no
  exceptional exponential after Kummer normalization.  The hostile
  negative-degree substitution has stable exponent \(-1\), but is not yet an
  actual relative-cap Stokes factor.  Iritani's codimension-two center has
  one pointed stationary charge, whereas all \(r-1\) charges of a
  codimension-\(r\ge3\) center sum to zero.  Hence this route remains
  plausible for the new \(m=2\) codimension-two gate, subject to
  same-receiver lower-center nullity, but the naive all-branch all-\(m\)
  exponent-valued charge cone is impossible; a finer charge lattice would
  require an additional lawful Stokes realization.
- The rank-row route does not consume the proposed universal
  threefold-center transport lemma.  The imported one-arrow receiver handles
  every isolated discrepant wall.  The remaining \(m=2\) defect occurs only
  between consecutive discrepant wall receivers, obeys a crossed Writer law,
  and first asks whether the actual row-null supported spans match.  After
  that typing, the remaining danger is an ambient-to-ambient rank-visible
  shear and center-image mutations are safe.  Opposite-sign fivefold two-ray
  faces have only six primitive neutral slopes up to exchange.  That
  arithmetic is only a sieve: analytic closure uses the full
  \(P_6\)-faithful \(K\)-positive carrier-face and oriented-path theorem.
- A nonresonant GKZ/window comparison does not specialize automatically to
  the geometric integral parameter.  The missing closed-support object is
  finite parameter torsion in the comparison cone.  Crepant toric HMS
  protects an independent trivial-parameter GKZ rank quotient in its own
  scope; for a discrepant QDM overlap, a canonical trait lattice and
  saturation with exact closed-fibre base change are additional gates.  On a
  nonzero marked primitive-packet rank coimage the entire defect is one
  additive DVR valuation, computable from Smith invariants or normalized
  Gamma pole/zero orders once the actual overlap matrix is available.
- Raw discrepancy rules out quasi-symmetry, even at a neutral slope, so the
  current nonresonant schober theorem cannot directly supply the generic
  calibration.  Under an effective genuine-unit \((1,1)\) two-ray pilot,
  adding the negative total-character coordinate produces five
  quasi-symmetric eight-weight signatures without total unimodularity and
  four with it.  A typed oriented chamber selects at most one for each actual
  occurrence; the occurrence model and marked saturated descent are not yet
  proved.
- The canonical completion's raw quantum-Serre map is not rank-safe: its
  K-theory self-intersection has rank zero and kills the point class.  The
  fibre-equivariant map has the universal simple factor \(1-q^{-1}\); its
  normalized first normal jet is the identity on a new marked rank/point jet
  shadow, while the raw special fibre remains zero.  A common-open completed
  window preserves generic rank, so the coordinate-wall, determinant-two,
  and all three other completed signatures have residual valuation zero and
  the same unit normalized jet.  The remaining target is an occurrence-level
  equivariant QDM/Gamma adapter identifying that algebraic jet with the
  endpoint transition.
- There is a second augmentation which needs no normal derivative.  The
  Euler coimage is the narrow state space; a shifted-point class represented
  by a compact Thom lift survives there, and its narrow pairing exactly
  reconstructs the source rank row.  A pairing-preserving narrow-QDM
  comparison carrying that shifted line would therefore close the same
  local gate.  Its occurrence and fixed-phase realization are still open.
- Proper Fourier--Mukai transport and the Coates--Iritani--Jiang Gamma gauge
  restrict to this paired narrow image under the explicit Shoemaker,
  spanning, same-map, and exact-base-change hypotheses.  Equivariant rank
  divided by the universal Thom zero \((1-q^{-1})^r\) is exactly its rank
  row, so rank and pairing transport remove a separate shifted-line scalar
  calculation.  A horizontal gauge also transports the whole generalized
  primitive sector; the remaining phase input is the actual common-loop or
  typed deck identification.
- Canonical-character completion is numerically crepant for every toric wall
  without quasi-symmetry or total unimodularity.  It nevertheless fails the
  intended total-space phase for all five admissible pilots: the added
  coordinate creates new semistable supports.  More strongly, every
  phase-safe ordinary added weight must lie in the cone opposite the chamber,
  so no finite multi-coordinate refinement can have the required total
  character.  The live alternatives are relative stability, an enlarged-group
  master space, or the independent normal-jet adapter.
- The natural completed wall equivalence does not descend to the intended
  open total spaces either: every pilot adjacency contains a common
  completed-stable point which is raw-boundary on one side and raw-open on
  the other.  Generic/divided rank kills the resulting boundary leakage, so
  this failure does not create another scalar gate; it reduces the sparse
  route to the same fixed-phase vertical row adapter as the normal jet.
- A Landau--Ginzburg potential can make the extra boundary critical-free,
  and BFK supplies crepant factorization-category wall crossing in that
  setting.  It is not a free repair: every purely added invariant
  nondegenerate quadratic fibre has total character zero, so it cannot cancel
  the nonzero discrepancy.  The obvious \(p x_\kappa\) potential deletes a
  genuine raw direction as well.  Existing \(p\)-field theorems recover
  hypersurface/complete-intersection theories, not the original overlap QDM.
- In one canonical trait receiver, the saturated closure of the generically
  row-null supported span has a finite-free quotient and stays row-null after
  specialization.  Hence the Boolean consumer does not require a full
  comparison of two Stokes splittings.  The normalized quantum-Serre or
  conormal map is also exactly a unit on the primary row coimage, with
  ramification order recorded.  The complete residual local gate is now the
  construction of that common occurrence trait receiver and faithful exact
  identification of both actual closed fixed-phase packets with its
  saturated quotient.
- Sabbah's explicit Malgrange block formula gives a strictly smaller local
  Stokes target: the normalized row consumes only
  \(\rho_j(1-T_j)|_{\operatorname{im}(1-T_i)}\), or dually one point-covector
  equation.  Full two-sided Stokes-block vanishing is stronger, and a finite
  countermodel separates the two.  For the first \((1,1)\) pilot, compute the
  directed projected variation actually crossed, or identify the normalized
  marked coimage as an intermediate extension on the resonance trait with an
  exact actual-packet reader.  Existing QDM, CDG, and nonresonant GKZ sources
  do not supply either occurrence-level identification.
- The source interface now makes every known upstream mismatch
  unrepresentable to the telescope.  A closed GADT indexes occurrence, side,
  based loop, character, direction, resonance, and raw/residual
  normalization; its only constructors consume either a projected-zero
  \(\lambda\)-line provider or an integral-trait normalized-middle-extension
  provider.  The compile-checked toy is concrete, not tagless-final.  Types
  prevent hypothesis laundering but do not create the two geometric source
  witnesses.
- A separate paper-local Lean package now formalizes the fixed-phase reader
  under the namespace
  `TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality`.  Its intrinsic
  projected-variation theorem removes independent can/variation packet maps.
  Vector crossed-coordinate equations derive the model reading; one marked
  horizontal comparison transports it to an externally supplied actual
  receiver when the induced incoming-image map is surjective.  At trait level,
  semilinear naturality and spanning of the specialized incoming image already
  transport a normal-factor reading; tensor/image base change is a stronger
  optional certificate rather than a required isomorphism.  The trait-horizontal
  reader composes those laws into the exact conditional endpoint theorem.  The
  environment-indexed endpoint API computes the QDM path and shares phase,
  character, and direction, so an endpoint pair is compatible by construction
  relative to that supplied environment and those shared labels.  The
  geometric receiver also requires invertible monodromies rather than arbitrary
  endomorphisms.  The two directed monodromies are coherently packaged with one
  comparison map; this is the same pair of equations as the prior specialization
  record.  A stronger optional based-loop representation morphism along a typed
  loop-group homomorphism can supply those equations uniformly for many loop
  pairs.  A selected-local-system adapter isolates the two remaining vertical
  equalities: the chosen trait loops and row must realize the crossed-coordinate
  model, and the chosen fibre loops and row must realize the fixed actual
  receiver.  These equalities plus incoming-image coverage construct the
  complete reader; ambient surjectivity is only one sufficient implementation.
  The identifications may be marked gauge equivalences rather than literal
  equality: conjugacy for both monodromies plus row transport suffices, and
  surjectivity survives the change of frame.  Operator-diagram equivalences
  with row factors also suffice: if their factors are `alpha` and `beta`, a
  residual target factor `c` with
  `beta = c specialize(alpha)` transports projected variation without dividing
  by either gauge factor.
  The identification frontier is now split into three gates: construct the
  crossed-coordinate monodromy model, compare its selected diagram with the
  actual fixed-phase diagram, and prove resonant incoming-image coverage.
  Gate 1 has a new kernel sieve: every coordinate model forces
  `ker(B,D)` into the kernel of the source-to-image map, while injectivity of
  the full upper-triangular window comparison makes `(B,D)` jointly injective.
  Its Lean goal is split into incoming-image, target-vector, and row-coordinate
  capability records, so the known Fourier-row pilot fills only the third.
  A trait-linear retraction of the combined `(B,D)` map now supplies all three
  records by an explicit shear-and-involution model; an integral equivalence
  realizing the full upper-triangular edge supplies such a retraction.  The
  extended Module 59 certificate proves this split condition in all thirty-two
  directed pilot transitions by recording a nonzero maximal residue minor.
  This lands algebraic model existence for every completed pilot; generic
  invertibility by itself would not have supplied the retraction over a DVR.
  The constructed target monodromy is involutive, however, so a source-faithful
  reader must either prove `T_target^2=1` on the actual incoming packet or use
  the actual selected source monodromies instead.  Gate 1 remains open at that
  precise sectorial identification.
  The non-involutive alternative is now exact in Lean.
  `CanVariationCoordinates.FixedReceiverCertificate` is indexed by an
  externally supplied actual receiver and therefore uses that receiver's own
  `T_i,T_j` and row.  It asks for signed can/variation factorizations, the
  vector wall law `T_j v_i=j_M D+j_C B`, and the three row restrictions.  It
  then constructs the full coordinates and, when the specialized edge normal
  is zero, proves the actual projected variation vanishes.  This merges the
  incoming part of Gate 1 with Gate 3 only after the occurrence-level packet
  certificate and vector wall law are supplied; it does not construct them.
  Gate 3 now has a direct can/variation closure theorem: `vc=1-T_V`,
  `cv=1-T_P`, and the exact can-coverage condition `v(c(V))=v(P)` identify the
  actual ambient incoming image with `im(v)`.  Packet-defect coverage modulo
  `ker(v)`, surjectivity of `1-T_P`, and in finite dimension absence of packet
  fixed vectors are successively stronger providers; surjectivity of the
  actual can map is another direct provider.  Thus an occurrence-level
  intermediate-extension theorem can close coverage without a packet-spectrum
  computation.  The first paragraph of Špenko--Van den Bergh's Corollary 13.2
  proof already gives the no-boundary-quotient half after specialization; on a
  transverse wall this implies can-surjectivity once the local quiver is
  identified.  This removes exact image/base-change from that route, but the
  actual can/variation quiver, signs, and QDM packet still have to be
  identified.
  A separate descent-packet module proves that
  a regular orbit differs equivariantly from three fixed points and that a unary
  correction is fixed only after its singleton summand is action-stable.  The
  coordinate realization, actual marked comparison, and any equivariant
  blowup splitting remain explicit gates.  Report:
  `../2026-08-20-c925-horizontal-fixed-phase-reader.md`.
  Module 63 separates the internal $C_3$-resolvent of elliptic two-division
  from the external $q^{1/3}$ Kummer action.  With a product action, a regular
  external coordinate cannot be equivariantly identified with any packet on
  which the external factor acts trivially, regardless of the center's
  internal action; the same remains true after adjoining externally fixed
  corrections to the source ledger.  The exact new source gate is individual
  descent of the target and codimension-two exceptional spectral idempotents
  before adjoining $q^{1/3}$, together with an oriented equivariant
  stable-ledger isomorphism for the occurrence comparisons.  Iritani's equation (5.11)
  and Theorem 5.18 close the local formal branch count: for codimension two,
  $s=1$ and there is one center summand, so its own Fourier variable needs no
  root extension.  Module 64 proves that the rank-three projective Fourier
  branches form the expected external regular orbit, but also gives the
  decisive unary-center countermodel: $K[t]/(t^3-q)$ uses only integral
  coefficients and nevertheless acquires three cyclically permuted primitive
  idempotents after adjoining $q^{1/3}$.  The exact remaining theorem is the
  three-part charged carrier-unramified Burnside lift: construct a common
  primitive external mod-three charge along the path, prove the splitting
  field of every dangerous center block algebra is linearly disjoint from its
  cubic Kummer extension, and lift the actual comparisons and reindexings to
  the coherent oriented equivariant stable ledger.  Reports:
  `../2026-08-21-c925-two-layer-resolvent-packet.md` and
  `../2026-08-21-c925-outer-kummer-and-carrier-boundary.md`.

## Open geometric providers for superseded fallback routes

None of the providers in this section is consumed by the landed
marked-projector proof.  They remain recorded to prevent a future context
compaction from confusing a valid fallback with the current closure gate.

### Rank row

Construct one coherent fixed-phase Gamma/Stokes/Orlov comparison which
preserves the rank quotient through every actual blowup occurrence.  This is
the highest-EV route because it avoids a universal threefold carrier theorem
and is uniform in \(m\).

A smaller direct endpoint formulation is now formalized.  Start with one
finite rational marked representation before chamber completion.  Each
endpoint may use its own faithfully flat coefficient extension and need only
be a selected-primary quotient of that scalar extension: the endpoint map
intertwines the selected loop, compares the rows up to a unit, and covers the
chosen generalized-primary kernel.  Then all endpoint Booleans agree through
the common core, with no adjacent comparison or exceptional direct sum.
Ordinary endpoint surjectivity supplies primary coverage at any exponent
beyond the source and endpoint Fitting thresholds.  The geometric input is
now descent of the actual Gamma/monodromy row to the rational core and the
corresponding localized quantum-Kirwan endpoint maps.

### Resonant saturation

For each consecutive-discrepant overlap, deform the integral GKZ parameter
to a generically calibrated window comparison and prove that the induced
comparison on the marked primitive-packet rank coimage has a canonical trait
lattice, torsion-free cone cohomology, and exact closed-fibre base change.
Generic acyclicity then forces the cone to vanish and the closed-fibre marker
law follows.  Generic comparison alone is insufficient: parameter torsion
is invisible away from resonance.

### Charge-filtered Stokes

Construct one occurrence-indexed pointed action/charge cone for the
master-space Fourier comparison, prove that every exceptional Stokes factor
has strictly positive charge after all lawful reindexings, and identify the
degree-zero augmentation with the fixed-phase rank row.  This may bypass
local boundary vanishing; a zero-charge exceptional shear is a sharp
countermodel.

### ExactTop

Construct, in the correct oriented enriched exact heart, an actual
operation-framed blowup sequence whose exceptional term is killed at the
threshold and whose snake boundary vanishes.  At \(m=2\), the two oriented
cross terms are

\[
\Omega_2(\delta)=N_A\delta+\delta N_E
\quad(0\to A\to B\to E\to0),
\]

and

\[
\Omega^{\mathrm{op}}_2(\delta)=N_E\delta+\delta N_A
\quad(0\to E\to B\to A\to0).
\]

Standard Orlov semiorthogonality naturally targets the second orientation.

The internal center-square condition and the ambient--exceptional boundary
are independent gates.

### Two-layer Kummer descent

The source projective-bundle orbit is source-verified, and the local $r=2$
Iritani projection has root denominator $s=1$.  Construct a faithful common
coefficient trait for the whole path with a primitive mod-three external
charge preserved by every occurrence reindexing.  Prove that the splitting
field of every dangerous codimension-two center's marked finite-etale block
algebra is linearly disjoint from the resulting cubic Kummer extension.
Equivalently, its geometric primitive idempotents must be externally fixed.
Integral monomials, saturation, and one outer summand do not imply this:
$K[t]/(t^3-q)$ is the
minimal counterexample.  A linear equivariant comparison is insufficient;
the comparison must lift to the Burnside category of the named external
$C_3$.

## Validation

Exact replay:

    nix shell nixpkgs#python3 --command \
      python3 notes/cubic-threefolds-tasks/c925-categorical-law-check.py \
      | diff -u notes/cubic-threefolds-tasks/c925-categorical-law-check.json -

Typed replay:

    nix shell nixpkgs#ghc --command \
      runghc notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs \
      | diff -u \
          notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy-output.txt -

Source-typed overlap replay:

    nix shell nixpkgs#ghc --command \
      runghc notes/cubic-threefolds-tasks/c925-source-typed-overlap-toy.hs \
      | diff -u \
          notes/cubic-threefolds-tasks/c925-source-typed-overlap-toy-output.txt -

Double-normal producer replay:

    nix shell nixpkgs#ghc --command \
      runghc notes/cubic-threefolds-tasks/c925-double-normal-source-toy.hs \
      | diff -u \
          notes/cubic-threefolds-tasks/c925-double-normal-source-toy-output.txt -

Unit-window intersection replay:

    nix shell nixpkgs#python3 --command sh -c \
      'python3 notes/cubic-threefolds-tasks/c925-unit-window-intersections.py \
       | diff -u \
           notes/cubic-threefolds-tasks/c925-unit-window-intersections.json -'

Crossed-edge provenance replay:

    nix shell nixpkgs#ghc --command sh -c \
      'runghc -inotes/cubic-threefolds-tasks \
           notes/cubic-threefolds-tasks/c925-crossed-edge-lens-toy.hs \
       | diff -u \
           notes/cubic-threefolds-tasks/c925-crossed-edge-lens-toy-output.txt -'

Final rowed-projector source/consumer sanity replay:

    nix shell --impure --expr \
      'with import <nixpkgs> {}; haskellPackages.ghcWithPackages (p: [p.QuickCheck])' \
      --command sh -c \
      'runghc notes/cubic-threefolds-tasks/c925-rowed-projector-sanity.hs \
       | diff -u \
           notes/cubic-threefolds-tasks/c925-rowed-projector-sanity-output.txt -'

Actual-loop stabilizer replay:

    nix shell --impure --expr \
      'with import <nixpkgs> {}; haskellPackages.ghcWithPackages (p: [p.QuickCheck])' \
      --command sh -c \
      'runghc -Wall notes/cubic-threefolds-tasks/c925-loop-stabilizer-sanity.hs \
       | diff -u \
           notes/cubic-threefolds-tasks/c925-loop-stabilizer-sanity-output.txt -'

This separate suite has 67 named checks: all 576 lawful two-dimensional
models over `F3`, 1,152 unit-scaled models, 104,976 polynomial cases, 55,296
two-presentation common-source cases, four hostile malformed bundles,
route-specific omission gates, a bounded endpoint sweep for `m=0,...,64`,
an explicit forward-then-reverse traversal, the finite cancellation showing
that leading-fibre visibility need not survive the normalized full row, a
nominal-vertex occurrence mismatch accepted by the name-only
telescope and rejected by the typed telescope, and 9,000 fixed-seed
QuickCheck cases.  Uniform smooth-center coverage, the common even rowed
coefficient object, cubic full-row visibility, product transport, and the
projective endpoint also have independent fail-closed omission tests.  Separate
tests show that the typed-occurrence and intrinsic-predicate path routes are
alternatives, not cumulative hypotheses.  The exact domain, hashes, dependency
versions, and trust boundary are recorded in
`../2026-08-21-c925-rowed-projector-computational-sanity.md`.  Lean's
`projectiveProductBranchCount_pos` proves positivity for every natural `m`;
the finite sweep is only a regression.

The loop-stabilizer suite separately checks 2,144 cyclic translations, 4,225
period pairs, 27,000 fixed-seed QuickCheck cases, and the named indices
(m=1,2,3,4,13).  It now also checks occurrence-tag preservation on a flattened
permutation, rejects lying period tables and occurrence-mixing loops, and
tests conjugate versus nonconjugate relabellings.  It tests the exact finite
certificate consumed by the actual-loop theorem; it does not certify the
geometric QDM-to-packet adapter.
Its trust record is
`../2026-08-22-c925-loop-stabilizer-computational-sanity.md`.
The guarded queue built the minimized `LoopStabilizerPath` with the full axiom audit in run
`20260822-160244-effd621a` and `OccurrenceLoopCertificate` with the full axiom
audit in run `20260822-155313-d281179c`; both aggregate gates passed.

Paper-local Lean is validated only through the guarded queue.  The aggregate
target `CubicStabilizationIrrationalityVerification` passed in run
`20260822-020610-0d32e5c3`.  The guarded axiom audit also exits zero and reports
only `propext`, `Classical.choice`, and `Quot.sound` where used.  Its reviewer
surface now includes the unit-scaled consumer, common-source basis
constructor, faithful base-change reflection, injective row-codomain lemma,
polynomial projector transport, the faithful scalar-edge basis and polynomial
constructors, intrinsic edge reflection, tensor endpoint witness, unbounded
branch count, and exact rational cubic-block certificate.

The focused Kummer-divisor module elaborated without diagnostics in guarded
run `20260822-133601`.  Its library target, `PaperInterface`, and
`Verification.AxiomAudit` passed together in queued run
`20260822-203654-bd8778f9`.  The guarded audit run `20260822-133914` reports
only `propext`, `Classical.choice`, and `Quot.sound` on the new terminals and
no admitted or native-evaluation axiom.

The binary-cubic Jordan module elaborated without diagnostics in guarded run
`20260822-140748`.  Its library target, `PaperInterface`, and
`Verification.AxiomAudit` passed together after the hostile field-and-Smith
repairs in queued run `20260822-212205-b2deeebb`; trace-current replay
`20260822-213623-28be379f` passed the aggregate gate.  Guarded audit run
`20260822-141651` reports only `propext`, `Classical.choice`, and `Quot.sound`
on the six new terminals.

The binary-cubic order-residue module elaborated without diagnostics in
guarded run `20260822-151428`.  Its library target, `PaperInterface`, and
`Verification.AxiomAudit` passed together in queued run
`20260822-221819-91daa41d`.  Guarded audit run `20260822-152143` reports only
`propext`, `Classical.choice`, and `Quot.sound` on every new public theorem and
certificate.  A separate hostile audit found no commit-gate defect and checked
that the normalization hypotheses imply a genuine projector, an off-block
gauge, and block-diagonal reduced grading.

The generated rank-six recurrence checker elaborated without diagnostics in
guarded run `20260822-162636`.  The generated data, checker,
`PaperInterface`, and `Verification.AxiomAudit` passed together in queued run
`20260822-232949-4c919d89`.  Guarded audit run `20260822-163436` reports only
`propext`, `Classical.choice`, and `Quot.sound` on all new terminals.  The
flake replay checks tracked hashes and regenerates byte-identical JSON and Lean
data from the exact Rust solver.

The finite model currently has one hundred twenty-two checks.  It verifies only the
advertised algebraic laws and countermodels, never an external QDM provider.
The replayed script is 117334 bytes with SHA-256
`2a51e21e3bcd5059f033d405a9ce5e6c11ad0f77e7b738bcf953e94e223986c3`;
the canonical JSON is 8111 bytes with SHA-256
`1d9bbc084f582f5a80d68736009fb32c64e7c0524c4ff9bf94bd397019750b58`.
There is no second implementation of the two scalar projector regressions;
they are transparent exact-rational assertions and are not sole evidence for
any geometric or QDM provider.

## Next

The live frontier is source-side, not another linear consumer.

1. **Exact \(m=2\) source theorem.**  Work over the generic
   numerical-reduced even base, retaining the independent center divisor and
   even-bulk coordinates.  For each connected codimension-two threefold-center
   occurrence, construct the transported product-loop action on the C924
   primitive factors with exact marker \(\delta^\sharp=4/9\) in its single
   outer correction factor and prove that no point has exact period three.
   This is the only remaining \(m=2\) correction theorem.  The sharpened
   sufficient route is saturated descent to the native effective
   large-radius lattice, including the standard cup-product grading and the
   elementary modification.  Generic cubic-etale/divisor data are
   insufficient: the parabolic-shear countermodel retains them and has
   \(\delta^\sharp=4/9\).  The resulting native-order problem has two
   Elias--Rossi classical algebra types and distinct Euler and transported
   divisor lines.  The standard dual-cubic order is not automatic, and order
   data alone do not select it.  The two explicit orders do specialize the
   matched divisor to different Jordan types, \(J_4\oplus J_2\) and
   \(J_4\oplus J_1^{\oplus2}\).  The normalized primary reductions of both
   types are now checked: the first has discriminant zero and the second fails
   to preserve the elementary-modification line.  It therefore suffices to
   identify the occurrence with either normalized reduction, but neither the
   order classification nor the Laurent comparison supplies that
   identification.
   `RankSixRecurrenceCertificate.no_cubic_discriminant_of_calibration`
   makes the smaller remaining obligation precise: construct one calibration
   intertwining multiplication, projector, first gauge, grading, selected
   basis, and left inverse.  An unordered or generic block identification is
   insufficient.  The proposed compression is to construct only a marked Rees
   port: the native self-dual Kummer coweight together with the first
   connection jet modulo integral gauges trivial on the associated graded.
   The exact Rust-to-Lean experiment enumerates bounded rank-six coweight
   charts and jets, emits elimination certificates, and derives the existing
   recurrence calibration only after each certificate is checked.  The finite
   classification can then be compressed structurally.  The experiment and
   its mandatory input-index mutation test are recorded in
   `../2026-08-22-c925-marked-rees-shadow.md`.
   The first certificate stage is landed in
   `MarkedReesShadowCertificate`: exact Rust output and Lean recomputation
   certify the relative coweight and the zero-coweight nonzero shear jet.
   `EffectiveReesCalibrationCertificate` lands the first complete chart:
   exact Rust elimination and Lean correspondence prove that every effective
   coweight-zero dual-number calibration satisfying the logarithmic divisor
   equation has discriminant zero.  The next finite chart is the nonzero
   coweight/distinct-order case; the occurrence-to-port theorem remains
   external after every finite chart.

2. **What Lean separates.**  The nonsplit outer-return theorem proves that
   total period is outer-label period times return-map period.  The pre-strict
   \(n=3\) dimension table is \(\{1,3\}\); the checked curve residue has
   discriminant zero, so the accepted low-dimensional geometric adapter
   removes \(d=1\), leaving \(d=3\).  The post-strict table is empty only
   after the still-open equality case is excluded.  Lean also checks the
   conditional cyclic dimension consumer, abstract recurrence compression,
   lower cubic certificate, and formula regressions.  It does not construct
   the geometric labels or prove the generic all-\(n\) recurrence.  The
   Kummer-derivative, cubic-orbit, and projected-trace lemmas form the finite
   part of a divisor-spectrum argument.  Its geometric adapter must still
   identify the traced block scalar with an element of one connected cubic
   etale orbit.  These lemmas do not supply the native calibration needed to
   exclude the shear.
   `BinaryCubicOrderResidues.no_classicalOrderModel_carriesCubicMarker`
   checks the final two-case finite exclusion after a normalized native
   calibration has been supplied; it does not construct that calibration.
   The generated rank-six certificate independently checks the two strict
   companion orientations and proves calibration invariance.  It does not
   classify effective orders or prove that a geometric occurrence has the
   required calibration.

3. **All-\(m\) remainder.**  Before the strict equality case, the candidate
   center dimensions at \(n=2,3,4,5,14\) are respectively
   \(\{1,2\}\), \(\{1,3\}\), \(\{1,3,4\}\), \(\{1,5\}\), and
   \(\{1,7,8,9,11,13,14\}\).  After a separate strict equality-case
   exclusion, the unresolved sets are empty, empty, \(\{3\}\), empty, and
   \(\{8,9,11,13\}\).  Composite lengths therefore retain genuine
   lower-return cases; do not infer all-\(m\) from the \(m=2\) reduction.

4. **Closed or non-provider routes.**  Do not reopen the common
   \(\epsilon M\)-row/stable-projector composite, raw or normalized
   degree-zero augmentation, ordinary Hodge/Hard-Lefschetz multiplicity, or
   global algebraic-simplicity projection.  Their countermodels and precise
   type failures are recorded in
   `../2026-08-21-c925-no-stokes-source-dossier.md`.

No unconditional every-smooth \(m=2\) or all-\(m\) theorem has been landed.
The very-general all-\(m\) theorem from Voisin plus
Engel--de Gaay Fortman--Schreieder remains a separate benchmark.

C925 remains active until the user closes it.
