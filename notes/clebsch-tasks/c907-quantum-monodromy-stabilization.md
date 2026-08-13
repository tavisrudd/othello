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
  Fitting tests, and the seam incidence closure retains exactly the four
  marked residual endpoints.  Positive pole order
  alone is only a prefilter:
  `delta^2 L=x^2` shows that total normalization can recreate an `L`-critical
  special fibre.  The bounded `1/1` Rees chart is closed separately:
  noncompact `y` weights give four empty and ten free support faces, while
  the compact face is exactly `W_(P^3)+ZU` with the four marked Morse points.
  The translated/infinity seams are now empty/free for arbitrary `y` weights;
  their only apparent hold is the constant face `L=0`, removed by choosing the
  residual path disk in `C*`.  The full double-translated `B=C=1` chart also
  closes every joint `y`/Rees-infinity valuation: positive-order faces are
  empty/free, while order zero forces compact `y` and gives either the free
  `f_Q+bc` face or exactly the four marked residual Morse points.  Thus no
  local tangent circuit remains in the named atlas.  The remaining algebra is
  global: assemble one finite common normalized fan, verify all transition and
  overlap ideals and fan completeness, then prove the separate proper collar
  topology.
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
  framed residue zero, so `nu_6(V_5)=0`.  Remaining loci are the other
  non-WCI prime Fanos.  Genus-six (V_{10}) provisionally also has zero
  support, pending a tracked recurrence certificate and direct full-QDM
  scalarization;
  non-WF/quotient mechanisms if admissible, and arbitrary non-Fano or non-nef
  threefolds.
- The v1 blow-up formula also makes `nu_6` birationally invariant for smooth
  projective varieties of dimension at most four, hence invariant under one
  `P^1` stabilization of smooth threefolds.  The landed Sarkisov links give
  `nu_6(V_22)=0`; Kuznetsov's rank-two-projectivization flop gives the cubic
  `nu_6` multiplicity on every smooth genus-eight `V_14` and proves
  `V_14 x P^1` irrational.  Thus direct non-WCI prime-Fano work remains only
  for genus six `V_10` (certificate pending) and genera seven, nine, and ten.
  See `../2026-08-12-c907-low-dimensional-stable-birational-compression.md`.

## Active frontier: `m=2`

The ordinary KKPYY carrier-height route is exhausted: the abstract cubic
`G`-atom already has the threefold carrier `X`, exactly the maximum center
dimension for a fivefold factorization.  An atomwise enrichment is also too
coarse: projective-bundle additivity gives `J_1^(direct sum 3)`, not the
endpoint string `J_3`.  The new object must enhance the entire atomic
composition together with its projective-bundle/blow-up operation frame.

For the fivefold `X x P^2`, prove both:

1. **Analytic gate.**  The codimension-two blow-up comparison is strict on the
   cubic-isotypic Stokes/Rees filtration and compatible with the Gamma lattice
   and composition:
   \[
   gr_{1/6}A(Bl_ZY)=gr_{1/6}A(Y)\oplus T\,gr_{1/6}A(Z).
   \]
2. **Carrier gate.**  Every smooth projective threefold `Z` has
   cubic-isotypic enriched length `ell_(1/6)(Z) <= 1`.

The endpoint has length three; lower-dimensional centers have no cubic atom;
threefold centers have codimension two and contribute one shift.  These gates
therefore imply `X x P^2` irrational.

## Next bounded pass

Complete the toric order-zero theorem for `Bl_(P^3)P^5`: assemble the now
locally complete normalized saturated graph atlas into one finite common
tangent-Fitting fan, verify every transition and overlap ideal plus fan
completeness, and build the finite product-pair cover on all overlaps.  Then identify
the four value-localized thimbles with the `P^3` Stokes system and fix the
monodromy-normalized central-connection seed in the Orlov Gamma subgroup.  In
parallel, continue the remaining non-WCI prime Fano scan for `nu_6>=4`.
Use stable-birational compression before computing another scalar operator:
genus eight and twelve are already closed.  The ranked portfolio leaves and
the exact non-combinations are in
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
`../2026-08-12-c907-b1-cinf-seam-star-fan.md`, and
`../2026-08-12-c907-joint-y-rees-infinity-fan.md`.

## Gold architecture after `m=2`

To reach every `m`, prove:

- an intrinsic cubic-isotypic Stokes/Gamma Rees object;
- strict additive blow-up composition in every codimension;
- product compatibility by Thom--Sebastiani; and
- the universal carrier bound `width <= dim-3`.

The exact polynomial identities are already closed.  The remaining work is
analytic functoriality and the carrier theorem, not further finite
bookkeeping.

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
