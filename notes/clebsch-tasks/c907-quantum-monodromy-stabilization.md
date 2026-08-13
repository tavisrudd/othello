# C907 — Quantum-monodromy stabilization

**Lane:** `clebsch`

**Status:** v1 closed: `X x P^1` is irrational for every smooth cubic
threefold, proved directly from framed formal monodromy of the numerical small
quantum connection.  The `m=2` research programme is active.  Full stable
irrationality is open.  No Paper V or Lean promotion.

**Load next:** `c907-solver-dossier.md`.

**Execution plan:** `../2026-08-11-c907-moonshot-attack-plan.md`.

**Detailed closed work:**
`../2026-08-10-c907-quantum-monodromy-stabilization.md`.
Historical task-card state:
`c907-quantum-monodromy-stabilization-archive.md`.

## Goal

Prove, beginning with `m=2`, that

\[
X\times\mathbf P^m
\]

is irrational for every smooth cubic threefold `X`.  The full endpoint for all
`m` would settle stable irrationality.

## Closed v1

- The cubic quantum connection has a rank-two formal block with exponents
  `+/-1/6` modulo integers.
- Framed formal-monodromy multiplicity `nu_6` is defined over the numerical
  small quantum connection.  Iritani's blow-up and Iritani--Koto's
  projective-bundle comparisons preserve it after reconstruction-target
  normalization; divisor tagging handles noninjective center Novikov maps.
- Every point, curve, and surface has `nu_6=0` after every center
  specialization.  Weak factorization therefore proves `X x P^1`
  irrational, since the product has `2 nu_6(X)>0` while `P^4` has zero.
- The proof is in `../2026-08-11-c907-v1-framed-fractional-support.md`; the
  warning-free v1 manuscript is `papers/cubic-stabilization-epilogue/`.

## Closed moonshot inputs

- `X x P^m` has exactly `m+1` cubic packets with unchanged fractional
  exponents.
- Coarse atom multiplicity cannot work from `m=2`: explicit self-carrier
  balances reproduce the endpoint count.
- The surviving Tate polynomial is `1+T+...+T^m`.  Equivalently, the endpoint
  has enriched unipotent length `m+1`, while projective self-carriers have
  length at most `m-1`.
- Iritani's local Fourier lattice recovers the consecutive Tate levels, and
  the associated-graded formula passes transverse and nested two-blow-up
  exchanges.
- The full cubic hypergeometric module is irregular-Hodge and irreducible.
  Cai's rank-two atom is its local middle zero-exponential Stokes graded piece,
  not a global subobject.
- KKPYY Claim 6.15 is dimension-free: every smooth nef-canonical projective
  variety has formal residue classes only `0` and `1/2`.  Thus every smooth
  nef-canonical threefold, including quintic and sextic hypersurfaces, has
  empty formal cubic packet; its identification with the enriched carrier
  invariant remains part of the analytic realization gate.
- For codimension two, Iritani (5.28) gives an exact basepoint matrix whose
  `t`-adic then exceptional-first associated graded is `I_Y \oplus I_Z`.
- The exact toric pilot `Bl_(P^3)P^5` has six ambient and four escaping
  critical values; after affine rescaling, the latter are the `P^3` mirror
  spectrum.  This closes the formal spectrum check, not the residual
  four-thimble Stokes cocycle.
- Its projective-bundle exceptional collection mutates explicitly into the
  `P^3` residual plus `P^5` ambient Orlov blocks.  Hence no finite Euler-lattice
  obstruction remains; the escaping-thimble identification is still open.
- A second exact rescaling gives the local residual potential `W_(P^3)+ZU`.
  Its four local Morse sections match `P^3`, and the fixed-torus model has a
  bounded-value logarithmic gradient gap.  Exact saturated tangent-Jacobian
  certificates now cover the compact residual chart, a family of mixed
  `y,B,C` cones, and the whole compact-`y` finite-pole continuum through one
  semistable node.  The latter glues exactly to the imbalanced residual chart
  away from—not through—the Morse core.  Exact five-support certificates now
  close ten boundary-star types for arbitrary toric `y` valuations: the
  two-pole star, two generic one-pole stars, two generic infinity stars, the
  two-infinity corner, two generic translated-one stars, and the two
  translated `1/0` seams.  Two Laurent circuit lemmas compress their six
  31-mask replays; the translated stars' order-zero faces pass separate exact
  Fitting tests, and the seam incidence closure retains the four marked
  residual endpoints in its advertised chart.  Positive pole order
  alone is only a prefilter:
  `delta^2 L=x^2` shows that total normalization can recreate an `L`-critical
  special fibre.  The bounded `1/1` Rees chart is closed separately:
  noncompact `y` weights give four empty and ten free support faces, while
  the compact face is exactly `W_(P^3)+ZU` with the four marked Morse points.
  The zero/infinity and translated/infinity seams are now empty/free for
  arbitrary `y` weights;
  their only apparent hold is the constant face `L=0`, removed by choosing the
  residual path disk in `C*`.  The full double-translated `B=C=1` chart closes
  every joint support valuation: positive-order restrictions are empty/free,
  while order zero forces compact `y`.  If the product drops, the restricted
  critical scheme is four residue-torus families, not four points; these are
  avoided by keeping the imbalanced residue coordinate interior.  Thus no
  support type remains outside the exhaustive ten-unordered-type atlas;
  the formerly implicit `(0,infinity)` and `(g,g)` types are now explicit.
  This does not serialize the control strata of one global model.  An ordinary
  fan in the original `(B,C)` torus is impossible because
  `B=1,C=1` are interior translated divisors.  The finite support complex is
  instead the product of the two marked-line tropical tripods, refined by six
  universal graph weights.  Its exact replay is support-only.  Serialize a
  regular pair-of-pants/log refinement and verify every local saturated graph
  against the explicit global Cartier strict transform.  Keep the imbalanced
  residue coordinate `v` interior: `partial_v F=1` makes that full chart free,
  whereas artificially marking `v=0` manufactures false `h=0,2` packets.
  Then forget the auxiliary translated markings and audit every
  actual-boundary/control stratum before proving the separate
  fibrewise Whitney--Thom collar topology.
  The correct rank-four system is value-localized; the global group has ten
  critical contributions.
- Iritani identifies the residual Gamma lattice with the exact `P^3` Orlov
  subgroup, but not its individual directed Beilinson basis.  The remaining
  marking is one monodromy-normalized central-connection seed.
- Ordinary dimension-three grading does not prove the carrier bound: an exact
  self-dual formal model has hard Lefschetz and length two.  The geometric gate
  is vanishing of its sectorial Rees extension class on every non-nef
  threefold.
- The first toric residual Kodaira--Spencer jet is `-H^2` modulo local
  coordinate gauge.  Internal Stokes rigidity is conditional on the filtered
  analytic mirror identification; the off-diagonal ambient extension remains.
- A quartic double solid has empty primitive-sixth small-even support.  The
  `(2,3)` Fano complete intersection is the first non-cubic positive candidate
  with one primitive pair; a direct grading-operator calculation proves that
  every ordinary Fano complete-intersection threefold has `nu_6<=2`.  The same
  bound holds for every smooth Fano cyclic cover of `P^3`, with the cubic the
  only positive cyclic-cover case.  The weighted degree-one del Pezzo
  threefold is a genuine non-CI positive calibration, but again has `nu_6=2`.
  The natural weighted two-cubic candidate
  `X_(3,3) subset P(1^(6-l),3^l)` collapses in every smooth Fano case to the
  cubic or `P^3`; its apparent second primitive pair is geometrically canceled.
  The first raw four-packet, `X_(3,6) subset P(1,1,1,1,2,4)`, is never
  quasismooth.  More generally, every reduced rank-four self-dual
  hypergeometric small-even Fano-threefold connection has `nu_6<=2`.
  More strongly, inertia avoidance gives
  `#{w_i:m|w_i}<=#{d_j:m|d_j}` for every smooth strongly well-formed weighted
  complete intersection.  It cancels every fractional denominator and forces
  an order-four self-dual factorial operator.  Wang's published nonconvex
  toric-CI mirror theorem identifies its identity-sector series with the full
  ordinary small-even QDM even for non-Cartier degrees.  Hence every such
  rank-one Fano WCI has `nu_6<=2`: the entire smooth strong-WF weighted-CI
  carrier class is closed.  The first non-WCI index-two test is stronger:
  the exact $V_5$ scalar equation has four unramified irregular branches of
  framed residue zero, so `nu_6(V_5)=0`.  The exact $V_{10}$ counting-matrix
  scalarization now closes genus six at zero as well.  Together with the
  stable-birational rows below, every smooth complex prime Fano threefold has
  `nu_6<=2`, with equality exactly in genera four and eight.  Remaining
  carrier loci are non-WF/quotient mechanisms if admissible, arbitrary
  non-Fano/non-nef threefolds, and relative Mori-fibre branches.
- The v1 blow-up formula also makes `nu_6` birationally invariant for smooth
  projective varieties of dimension at most four, hence invariant under one
  `P^1` stabilization of smooth threefolds.  The landed Sarkisov links give
  `nu_6(V_22)=0`; Kuznetsov's rank-two-projectivization flop gives the cubic
  `nu_6` multiplicity on every smooth genus-eight `V_14` and proves
  `V_14 x P^1` irrational.  Kuznetsov--Prokhorov's rationality theorems close
  genera seven, nine, and ten over `C`, hence give `nu_6=0` there.  Thus the
  direct prime-Fano admission scan is complete.
  See `../2026-08-12-c907-low-dimensional-stable-birational-compression.md`
  and `../2026-08-12-c907-prime-fano-primitive-sixth-classification.md`.
- The bounded-value Laurent graph now has an exact full-initial theorem:
  filtered Koszul strictness upgrades the 552 pair-of-pants masks to the full
  initial ideal, and the 57 non-singleton masks give an intrinsic proper
  regular tropical compactification over the original DVR.  The exterior
  fixed-value audit compresses to free `L`, 70 regular unit tangent lifts, or
  the empty face `L=0`; the protected finite-ratio ends have exact strict
  Cartier equations and unit derivatives.  A common marked toroidal fan is
  impossible: its forced `(h,v)` blow-up creates an actual exceptional
  `f_Q` divisor with four false critical families.  Proper-support descent is
  the correct replacement mechanism in principle, since
  `Ra_!A=R\bar a_*j_!A` is compactification-independent and cycles commute
  with proper modification.  Its exact remaining quantifier gate is a
  whole-proper-fibre good-chart cover (or proper hypercover); one good lift
  per arc does not suffice.  See
  `../2026-08-12-c907-relative-schon-regular-model-audit.md`,
  `../2026-08-13-c907-protected-ratio-splice.md`, and
  `../2026-08-13-c907-proper-support-modification-descent.md`.
- On the carrier side, the conic primitive sheaf kills both stalk and costalk
  at a double-line node after inverting six, giving an exact conditional
  square-zero target.  The analogous finite-discriminant shortcut fails for
  del Pezzo fibrations: a nodal cubic-surface fibre retains a stationary
  primitive `A_5` summand in both stalk and costalk.  The strict Rees product
  must have zero stationary-primitive projection; finite support or block
  count cannot prove it.  See
  `../2026-08-12-c907-conic-primitive-sheaf-node-vanishing.md` and
  `../2026-08-13-c907-del-pezzo-primitive-monodromy-obstruction.md`.
- Proper-support localization is now compressed to two direct proper models.
  Conditional on the stated direct exterior strict-model hypotheses, 70
  logarithmic residue-character fields plus two `L=0` exclusions give
  `p_ext(B_ext) subset T_11`, while the simultaneous ratio graph controls its
  entire proper fibre over `T_11 minus C_Morse`.  Proper pushforward therefore
  supports `psi_delta phi_(L-u)(j_!A)` only on the four residual Morse
  sections.  With proper nearby-cycle/direct-image comparison, the intrinsic
  nearby value-disk cone has one free rank-four group in thimble degree five.
  This is a support/rank theorem: relative duality, `can/var`, orientations,
  and nonbraiding path transport are still required for the directed `P^3`
  Seifert form.  See
  `../2026-08-13-c907-order-zero-proper-support-localization.md`.
- The exact numerical carrier threshold for the positive `m=2`
  Krull--Schmidt telescope is `ell<=2`, not `ell<=1`.  More weakly, it suffices
  that no Tate shift of the endpoint `J_3` occur in any threefold-center
  packet.  Hence the landed square-zero/length-two countermodel is harmless;
  the first real threats are the nodal Clifford and stationary `A_5` second
  composites.  See `../2026-08-13-c907-sharp-m2-carrier-threshold.md`.
- The point-class shear acts trivially on the associated graded of the
  coarsened `N`-adic Rees object, but it does not preserve ordinary directed
  Stokes flags.  It is gauge only for a telescope deliberately defined in
  that coarsened category; the full Stokes/Gamma programme still needs `r=0`
  or a separate flag-invariance theorem.
- Silver admits a much smaller target category than the full marked
  Stokes/Gamma object.  After extending to `K=Q(zeta_6)`, retain only the
  whole generalized `zeta_6` eigenspace and one intrinsic nilpotent operation
  `N`.  Finite nilpotent `K[N]`-modules are Krull--Schmidt with
  indecomposables `J_r`; strict blowup biproducts, an endpoint `J_3`, and
  absence of `J_3` in every threefold center imply `m=2` irrationality.
  Gamma markings, Euler pairings, and directed flags are not used by this
  final cancellation theorem, though they may be needed to construct `N`.
- Cyclotomic rank sharpens the carrier admission screen: every nonzero
  `T`-stable Rees grade has even rank, or equivalently one generalized
  `zeta_6` eigenspace has dimension `nu_6/2`.  Therefore an endpoint `J_3`
  requires `nu_6>=6`.  All computed `nu_6<=2` classes—and any future
  `nu_6<=4` class—are conditionally excluded under the strict all-shifts
  realization.  A rank-six `rho=2` hard-Lefschetz/self-dual formal
  countermodel shows the bound is exact: unit/top classes do not reserve a
  non-cyclotomic pair.
- Formal QDM direct sums and Tate-indexed associated grades cannot select the
  nilpotent operator: the same three copies admit `J_1^3` and `J_3`.
  Finite exceptional-root monodromy is semisimple and cannot supply it.  The
  plausible source is unipotent base-hyperplane/Serre continuation, but it
  must be transported as a strict blowup operator.  With fixed formal
  component maps, the two-block obstruction is an explicit class in
  `Ext^1_(K[N])(W,V)`; multi-block splitting is recursive.
- On every connected non-turning parameter locus, the whole generalized
  `zeta_6` formal-primary sector is preserved by line-bundle Galois
  monodromy: parameter transport commutes with formal angular monodromy by
  uniqueness of the relative formal decomposition.  Iritani's Gamma formula
  identifies that parameter loop with tensor by the line bundle, so
  `N_L=1-tau_L` is already an intrinsic nilpotent on the minimal Silver
  packet.  Product naturality calibrates the endpoint as `J_3`.  The
  remaining new bridge is narrower: ambient primitive-sixth projection must
  annihilate Gamma-framed classes supported in absolute dimension at most
  two, and the general blowup comparison must be equivariant for the base
  loop.  See `../2026-08-13-c907-formal-primary-galois-stability.md`.
- A concrete conditional source is now isolated.  For a model
  `f:Y -> P^2`, tensor by `L=f^*O(1)` gives `N_L=1-tau_L`: projection formula
  makes it exactly block diagonal under Orlov blowups, its endpoint on
  `X x P^2` is `J_3`, and its square on a threefold center factors through a
  generic curve fibre (or vanishes when the image has dimension at most one).
  Hence an exact Gamma/cyclotomic projector compatible with Orlov maps,
  products, and Gysin support would close both Silver gates for arrows over
  `P^2`.  The unresolved locus is the Rees resolution of the rational
  `P^2`-map, where the hyperplane is only a movable system and arbitrary
  threefold centers can reappear.  See
  `../2026-08-13-c907-line-bundle-framed-jordan-strictness.md`.
- The base-ideal extension problem has a sharper support-local solution.  On
  a graph resolution `W -> P^5` of the rational `P^2`-map, `N_L^2` tensors
  every exceptional-divisor generator with a general base-point fibre, whose
  support has dimension at most two.  Hence a localizing, Orlov-additive,
  `K_0`-linear/derived-Gysin `Phi_6` packet functor which vanishes on all such
  supports forces `N_L^2=0` on the entire resolved packet, including all
  extension mixing.  Relative factorization retains the endpoint `J_3`, so
  this one projector theorem implies `m=2`.  An idempotent only on the formal
  solution space is insufficient because it cannot see support.  See
  `../2026-08-13-c907-divisorial-support-square-theorem.md`.
- Standard motivic candidates do not furnish this projector.  The relative
  quotient `Perf(Y)/Perf_(dim<=2)(Y)` is the correct localizing host but
  retains `Q[x]/(x^3)` on `P^5`; full categorical Serre has only `+/-1`
  spectrum; and the cubic residual Serre projector is mutation-framed and
  does not kill point support.  A global tensor-ideal quotient is impossible
  because killing `Perf(point)` kills the monoidal unit.  The exact missing
  construction is a **relative framed localizing quantum motive**.  See
  `../2026-08-13-c907-coniveau-cyclotomic-packet-spec.md`.
- A quotient by objects of relative fibre dimension at most two is also
  impossible, even though it appears tailored to the support-square proof.
  On `X x P^2`, one horizontal divisor and one mixed three-section divisor
  make the pulled-back base `O(1)` isomorphic to the tensor unit in that
  quotient.  Thus its operator is zero and the endpoint `J_3` is destroyed.
  The positive object must retain the full absolute coniveau filtration and
  kill only the primitive-sixth coefficient after `N_L^2` reaches an
  absolute surface.  See
  `../2026-08-13-c907-relative-fibre-cutoff-no-go.md`.
- Both `P^5` and `P^3` have empty primitive-sixth packets.  Consequently the
  toric `Bl_(P^3)P^5` residual theorem is valuable ordinary Stokes/Gamma
  geometry but projects to zero in the minimal Silver category.
  `Bl_X P^5` for a cubic center is nonzero but only one-dimensional, so its
  nilpotent operator is forced to vanish and it tests normalization rather
  than splitting.  The first possible extension test is
  `Bl_(X x p)(X x P^2)=X x F_1`: its conditional Kronecker-sum model gives
  `J_2 tensor J_2=J_3 direct-sum T J_1`, while the actual tensor rule and
  geometric component-map intertwiner remain open.  See
  `../2026-08-13-c907-silver-jordan-pilot-ladder.md`.
- The same projective rule cannot coexist with a naive ungraded strict
  all-codimension blowup sum: for `m>=3`, the two presentations of
  `X x Bl_p P^m` give respectively
  `J_(m+1) direct-sum J_1^(m-1)` and
  `J_m tensor J_2=J_(m+1) direct-sum J_(m-1)`.  Silver avoids the conflict
  because its only nonzero fivefold center has codimension two; Gold needs a
  non-split graded exceptional-string functor or a different projective
  operator.  See
  `../2026-08-13-c907-higher-codimension-jordan-exchange-obstruction.md`.
- The Mori-fibre carrier branches share one conditional mechanism.  If `N`
  raises base coniveau, then `N^2=0` over a curve, and over a surface its
  square lands in a point packet which clean primitive excision must kill.
  The nodal Clifford socle and stationary `A_5` square are exactly the two
  local strictness tests; they are not established counterexamples.

## Active frontier: `m=2`

The ordinary KKPYY carrier-height route is exhausted: the abstract cubic
`G`-atom already has the threefold carrier `X`, exactly the maximum center
dimension for a fivefold factorization.  An atomwise enrichment is also too
coarse: projective-bundle additivity gives `J_1^(direct sum 3)`, not the
endpoint string `J_3`.  The new object must enhance the entire atomic
composition together with its projective-bundle/blow-up operation frame.

For the fivefold `X x P^2`, prove both:

1. **Minimal analytic gate.**  Construct a presentation-independent
   nilpotent `N` on the generalized `zeta_6` formal packet, calibrate the
   projective-bundle endpoint as `J_3`, and make every codimension-two blow-up
   comparison a strict `K[N]`-module biproduct:
   \[
   gr_{1/6}A(Bl_ZY)=gr_{1/6}A(Y)\oplus T\,gr_{1/6}A(Z).
   \]
2. **Carrier gate.**  No smooth projective threefold center contains a Tate
   shift of the endpoint length-three indecomposable.  The clean numerical
   sufficient condition is `ell_(1/6)(Z) <= 2`.

The endpoint has length three; lower-dimensional centers have no cubic atom;
threefold centers have codimension two and contribute one shift.  These gates
therefore imply `X x P^2` irrational.

## Next bounded pass

For Silver, attack one exact localizing projector theorem.  Construct a
`Phi_6` packet assignment on supported perfect objects which commutes with
formal monodromy and tensor by the base hyperplane, is `K_0`-linear or
derived-Gysin compatible for the point-support square, preserves Orlov
component maps and projective Kunneth products, and vanishes on every possibly
singular or nonreduced support of dimension at most two.  The divisorial
support-square theorem then kills every base-ideal extension at once, while
relative factorization preserves the endpoint `J_3`.  Linear projection's
raw `K_0` `J_3` is the regression showing why formal-space or ordinary
`K_0` projectors are insufficient.  See
`../2026-08-13-c907-base-ideal-framing-obstruction.md`.
Relative weak factorization over `P^2` then makes every later arrow strict and
every threefold center square-zero.  Use `Bl_(X x p)(X x P^2)` as the first
ungraded extension regression and the twisted relative `P^2`-bundle section
only after its formal packet is recalibrated.  The toric `P^3` residual
theorem remains a separate high-value
Stokes leaf: finish it only through the pushed-down
self-dual pairing-excision zigzag and full tame residual-pair identification,
not as evidence for the cyclotomic Jordan biproduct.  In parallel, construct
the coniveau filtration whose strictness kills the nodal Clifford and
stationary `A_5` second composites.  The prime-Fano scan is closed and should
not be repeated.  The ranked portfolio leaves and exact non-combinations are in
`../2026-08-12-c907-portfolio-combination-leaves.md`.
Do not differentiate in
Novikov directions before the marked order-zero comparison passes.

A Fano-threefold database is reconnaissance only; weak factorization permits
arbitrary Calabi--Yau and general-type threefold centers.

Exact pilot and replay:
`../2026-08-11-c907-toric-r2-pilot.md`.
Finite mutation audit:
`../2026-08-11-c907-double-presentation-mutation-audit.md`.
Double suspension and pole obstruction:
`../2026-08-11-c907-wave-two-double-suspension-and-pole-escape.md`.
Local pole-channel model:
`../2026-08-11-c907-pole-channel-normal-crossing-excision.md`.
Toric assembly:
`../2026-08-11-c907-toric-order-zero-stokes-assembly.md`.
Tangent-Jacobian replay specification:
`../2026-08-12-c907-tangent-jacobian-fan-certificate-spec.md`.
First cone and continuum certificates:
`../2026-08-12-c907-first-tangent-jacobian-cone-certificates.md` and
`../2026-08-12-c907-finite-pole-continuum-certificate.md`.
Critical-fan pivot and replay:
`../2026-08-12-c907-tropical-critical-fan-pivot.md` and
`../2026-08-12-c907-critical-fan-pilot.md`.
Threefold grading boundary:
`../2026-08-11-c907-threefold-grading-boundary.md`.
First residual jet:
`../2026-08-12-c907-toric-residual-first-jet.md`.
Carrier regressions:
`../2026-08-12-c907-quartic-double-solid-carrier-regression.md`,
`../2026-08-12-c907-23-fano-positive-carrier-regression.md`, and
`../2026-08-12-c907-fano-complete-intersection-support-bound.md`;
cyclic-cover bound:
`../2026-08-12-c907-cyclic-cover-support-bound.md`.
Weighted non-CI calibration:
`../2026-08-12-c907-b1-weighted-del-pezzo-support.md`.
Weighted two-cubic obstruction:
`../2026-08-12-c907-33-weighted-ci-obstruction.md`.
Four-packet false positive and rank-four bound:
`../2026-08-12-c907-36-weighted-ci-false-positive.md` and
`../2026-08-12-c907-rank-four-hypergeometric-support-bound.md`.
Smooth weighted-hypersurface theorem:
`../2026-08-12-c907-isolated-stacky-hypersurface-rank-four.md`.
Class-wide WCI compression and QDM theorem:
`../2026-08-12-c907-inertia-cyclotomic-compression.md` and
`../2026-08-12-c907-smooth-wci-rank-four.md`.
Exterior-star compression and exact replays:
`../2026-08-12-c907-five-support-star-compression.md`,
`../2026-08-12-c907-bc00-star-fan.md`,
`../2026-08-12-c907-b0-cunit-star-fan.md`,
`../2026-08-12-c907-binf-cunit-star-fan.md`,
`../2026-08-12-c907-binf-cinf-star-fan.md`,
`../2026-08-12-c907-b1-cunit-star-fan.md`,
`../2026-08-12-c907-b1-c0-seam-star-fan.md`,
`../2026-08-12-c907-b0-cinf-seam-star-fan.md`,
`../2026-08-12-c907-bunit-cunit-generic-star.md`,
`../2026-08-12-c907-b1-cinf-seam-star-fan.md`, and
`../2026-08-12-c907-joint-y-rees-infinity-fan.md`.
Orbit-level completeness:
`../2026-08-12-c907-local-boundary-orbit-atlas-closeout.md`.
Common support mechanism:
`../2026-08-12-c907-tripod-common-prefan.md`.
Hostile gluing/collar boundary:
`../2026-08-12-c907-pair-of-pants-log-gluing-theorem.md` and
`../2026-08-12-c907-proper-collar-excision-theorem.md`.

## Gold architecture after `m=2`

To reach every `m`, prove:

- an intrinsic cubic-isotypic Stokes/Gamma Rees object;
- a graded non-split exceptional-string blow-up law in every codimension,
  reducing to the strict biproduct on Silver's codimension-two nonzero sector;
- product compatibility by Thom--Sebastiani; and
- the universal carrier bound `width <= dim-3`.

The higher-codimension Jordan exchange proves that a naive ungraded additive
law is incompatible with the candidate relative-projective operator.  The
remaining work is analytic functoriality, construction of the exceptional
string, and the carrier theorem, not further finite bookkeeping.

## Acceptance

- **Silver:** both `m=2` gates above, followed by a complete weak-factorization
  proof of `X x P^2` irrational.
- **Gold:** the all-codimension strict theory and universal carrier bound,
  proving irrationality for every `m`.
- **Negative progress:** an exact counterexample to either gate, with the
  minimum missing datum or corrected invariant identified.

## Boundaries

- Do not edit the frozen Paper V manuscript.  Only the closed `m=1` theorem
  belongs in its epilogue.
- Do not infer a universal theorem from finite computation.
- Do not start Lean work without separate authorization.
- Follow the literature-cache and reproducibility conventions for new source
  or computational claims.
- The queued one-step abstraction/Fano reconnaissance remains behind the
  active gold-architecture pass unless the author reorders it.
