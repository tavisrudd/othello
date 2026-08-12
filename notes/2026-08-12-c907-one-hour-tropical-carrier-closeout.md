# C907 one-hour tropical/carrier closeout

**Lane:** `clebsch`

**Status:** algebraic pilot and a substantial carrier subclass closed; the
`m=2` theorem remains open.

## Accepted results

1. The toric `m=2` pilot now has a finite algebraic certificate
   specification: fix a toric/Rees compactification, take the comprehensive
   Groebner fan of the saturated graph, normalize every initial chart, and
   compute the reduced-stratum tangent Fitting ideal of `dL`.  This is the
   right finite object; the open-torus critical ideal is only a regression
   check and cannot replace it.
2. Exact tangent-Jacobian certificates cover the residual chart, imbalanced
   ends, a mixed-cone family, and the entire compact-`y` finite-pole continuum
   through one semistable incidence node.  Its only tangent-critical endpoint
   is the expected four-point residual Morse scheme.
3. The hashed Singular pilot replays both incidence saturations, the genuine
   four-point endpoint (including `S=y_1+y_2+y_3`), and the fact that all
   generic torus critical points have `B=C`.
4. Every quasismooth pairwise-coprime weighted Fano hypersurface with smooth
   coarse threefold and primitive `O_X(1)` has a full reduced rank-four
   self-dual small-even QDM.  Hence `nu_6<=2`; no threefold in this substantial
   weighted non-CI class can supply the length-two carrier sought for `m=2`.

## EJ + TT closeout

The cheap extra value was structural rather than another example.  The raw
weighted factorial order can exceed four only where stack inertia or
quasismoothness survives the cancellation.  In the isolated-stacky class,
coarse smoothness forces avoidance of every stacky point, every weight divides
the degree, and the fractional factorial sets cancel exactly to order four.
This converts the earlier `nu_6=4` search from denominator arithmetic into a
geometric stack-stratum problem.

The TT stress test also found and removed two false shortcuts.  First, a
smooth saturated graph need not make `L` submersive: the finite-pole endpoint
contains the four residual Morse points.  Second, initial ideals of the open
critical scheme do not certify boundary submersivity; normalization and the
stratumwise tangent Fitting calculation are mandatory.  Those corrections are
now built into the finite fan specification and replay.

## Mystery ledger

- **Settled by EJ/TT:** there is no off-diagonal generic `B,C` critical branch;
  the exact equations force `B=C`.  There is no hidden `nu_6>=4` carrier among
  smooth pairwise-coprime weighted hypersurfaces.
- **Open, analytic owner C907:** execute the comprehensive fan and prove every
  stratum is empty, `L`-free, or residual; then construct compatible proper
  product collars on all intersections.  The present notes specify this
  finite calculation but do not claim it has been run.
- **Open, marking owner C907:** transport the four value-localized thimbles and
  fix the monodromy-normalized central-connection seed inside the Orlov/Gamma
  subgroup.  A global rank-four Stokes block is not yet proved.
- **Open, carrier owner C907:** positive-dimensional stacky strata, weighted
  complete intersections, and arbitrary non-nef threefold centers.  The exact
  geometric question is whether smoothness again forces a reduced rank-four
  presentation or permits a genuine primitive-sixth length-two packet.
- **No additional mystery:** the ordinary-atom route remains exhausted; none
  of this changes the need for the enriched Stokes/Rees carrier theorem.

## Replays and primary notes

- `2026-08-12-c907-critical-fan-pilot.md`
- `2026-08-12-c907-tropical-critical-fan-pivot.md`
- `2026-08-12-c907-finite-pole-continuum-certificate.md`
- `2026-08-12-c907-isolated-stacky-hypersurface-rank-four.md`
