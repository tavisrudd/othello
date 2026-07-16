# C203: operational boundary of coefficient-labelled repairs

**Date:** 2026-07-15
**Lane:** `repaircodes`
**Status:** IMPLEMENTED; aggregate `RepairCodes` build pending behind the foreign Q25 build

## Verdict

Retaining dual-word coefficients gives the exact local linear combination used by a repair, but it
does **not** add a code-invariant helper-access, bandwidth, or availability theorem beyond the
support hypergraph in the scalar model used by this paper.

For every repair edge `R` at target `x`, Lean now retains a witnessing dual word `y` and proves

```text
c(x) = -(y(x))⁻¹ * sum (j in R), y(j) * c(j)
```

for every codeword `c`. The induced direct scalar protocol contacts `|R|` helpers, reads one full
field symbol from each, and downloads one full field symbol from each. This is an achieved
protocol, not a lower bound on the best possible protocol after subpacketization or use of other
parity checks. Disjoint availability and failure tolerance remain exactly the matching and
transversal invariants of the coefficient supports.

Raw coefficient values are not invariant under monomial equivalence. Lean proves a concrete gauge
boundary: in the axis-pair relation, rescaling the target column by the nonzero factor `(b-a)/d`
changes its target coefficient to any prescribed `d != 0`, without changing the repair support or
any support-derived operational invariant. Consequently coefficient histograms, counts of `1`
coefficients, and multiplication-cost claims are presentation- and basis-dependent.

## Closed coefficient formulas

The new module records the three canonical completed-seed equations. Here `C(∞)` and `A(∞)` are
the projective cubic and axis points.

1. Two-axis repair of axis infinity, for `a != b`:

   ```text
   A(a) - A(b) + (b-a) A(∞) = 0.
   ```

2. Cubic-infinity repair, for `s != t`:

   ```text
   -(s-t)^3 C(∞) + C(s) - C(t) + (t-s) A(s+t) = 0.
   ```

3. Zero-sum cubic repair of axis infinity, for distinct `s,t,u` with `s+t+u=0` and
   `V=(s-t)(s-u)(t-u)`:

   ```text
   (t-u) C(s) + (u-s) C(t) + (s-t) C(u) - V A(∞) = 0.
   ```

Lean proves every displayed coefficient nonzero under the stated hypotheses. Projective shifted
inversion and monomial repair transport carry these canonical equations to every target, with the
expected coordinate scales. Thus the formulas cover every radius-two/radius-three minimal repair
shape up to the already proved target transitivity.

## Concatenation boundary

The transfer theorem identifies every bounded coefficient **support**, not a preferred normalized
dual word. This is the right invariant:

- extending an inner dual word by zero gives the identical coefficient-labelled equation in any
  chosen block;
- conversely, every bounded concatenated dual word is confined to one block and restricts to an
  inner-dual equation;
- on a circuit support the relation space is one-dimensional, so a fixed presentation determines
  coefficients only up to a common nonzero scalar;
- column rescaling changes the remaining ratios while preserving the monomially equivalent code
  and its entire repair hypergraph.

Therefore the lift inherits the same direct scalar repair equations blockwise, but complete-support
transfer alone must not be advertised as optimal-access, optimal-bandwidth, or repair-by-transfer
minimality.

## Formal boundary

The kernel-checked module is `lean/RepairCodes/OperationalCoefficients.lean`. Its principal
declarations are:

- `FiniteGeom.repair_edge_has_scalar_recovery_equation`;
- `projectiveAxisPair_coefficient_relation` and
  `projectiveAxisPair_arbitrary_targetCoefficient`;
- `projectiveCubicInfinity_coefficient_relation`;
- `projectiveAxisInfinityCubic_coefficient_relation`; and
- the three corresponding nonzero-coefficient theorems.

The focused guarded elaboration and standard-axiom audit pass without warnings. No new axiom,
finite certificate, or external mathematical input is introduced. The aggregate `RepairCodes`
build remains the final closure gate; it is intentionally deferred while the shared Lean build
tree is owned by the Q25 lane.

## Publication disposition

The manuscript draft now states the achieved direct scalar protocol and explicitly separates it from
minimum-bandwidth or minimum-access claims. This answers the operational referee question without
adding a comparison plot or an invariant that the formal model does not control. Further bandwidth
work would require a declared subpacketization/helper-message model and new information-theoretic
lower bounds; it is a new project, not a mathematical C203 obligation. C203 is reported only after
the deferred aggregate build succeeds.
