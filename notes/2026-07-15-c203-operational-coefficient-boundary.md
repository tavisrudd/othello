# C203: operational boundary of coefficient-labelled repairs

**Date:** 2026-07-15
**Lane:** `repaircodes`
**Status:** REPORTED; focused and aggregate Lean, axiom, adversarial-review, and PDF gates pass

The focused [adversarial review](2026-07-15-c203-operational-coefficient-adversarial-review.md)
records the attacks, two substantive corrections, and the surviving claim boundary.

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

Coefficient ratios are not invariant under monomial equivalence. Lean proves a concrete gauge
boundary: in the axis-pair relation, rescaling one helper column by `d⁻¹` changes that helper's
coefficient to any prescribed `d != 0` while the target coefficient stays fixed, without changing
the repair support or any support-derived operational invariant. Consequently even a single
relation's coefficient histogram, count of `1` coefficients, and multiplication cost are
presentation- and basis-dependent.

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
inversion and the already proved monomial repair transport carry their relation witnesses to every
target, introducing the corresponding coordinate scales. Thus these are canonical formulas for
the three radius-two/radius-three minimal repair shapes; the transported raw formulas are not
claimed to retain the same normalization.

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
transfer alone must not be advertised as optimal access or bandwidth merely because the achieved
protocol is help-by-transfer.

## Formal boundary

The kernel-checked module is `lean/RepairCodes/OperationalCoefficients.lean`. Its principal
declarations are:

- `FiniteGeom.repair_edge_has_scalar_recovery_equation`;
- `projectiveAxisPair_coefficient_relation` and
  `projectiveAxisPair_arbitrary_helperCoefficient`;
- `projectiveCubicInfinity_coefficient_relation`;
- `projectiveAxisInfinityCubic_coefficient_relation`; and
- the three corresponding nonzero-coefficient theorems.

The focused guarded elaboration and standard-axiom audit pass without warnings. No new axiom,
finite certificate, or external mathematical input is introduced. The aggregate `RepairCodes`
build remains the final closure gate; it is intentionally deferred while the shared Lean build
tree is owned by the Q25 lane.

## Independent q=9 replay

The build-independent verifier
[`2026-07-15-c203-q9-coefficient-verifier.py`](2026-07-15-c203-q9-coefficient-verifier.py)
reconstructs every small-circuit kernel with its own Gaussian elimination and emits the committed
[`coefficient certificate`](2026-07-15-c203-q9-coefficient-certificate.json). It checks:

- all 240 size-three/four circuit supports and their everywhere-nonzero kernel vectors;
- all 840 retargeted recovery equations on the four generator rows;
- 72 ordered instances of each of the three closed formulas; and
- 576 arbitrary-helper-coefficient gauge rescalings with the target coefficient fixed.

The normalized 240-relation coefficient table has SHA-256
`c7ec1a09745e2aecb0e8a6b8d35fa145b141017ecabd51d6100064a30ff0a587`.

## Primary-source terminology audit

The operational boundary agrees with the primary repair-code models:

- [Guruswami--Wootters](https://arxiv.org/abs/1509.04764) treats exact linear repair over a
  subfield and measures downloads in bits/subsymbols, demonstrating why one full extension-field
  equation does not prove minimum bandwidth after subpacketization.
- [Ye--Barg](https://arxiv.org/abs/1604.00454) distinguishes attaining the repair-bandwidth lower
  bound from the stronger optimal-access property in MDS array codes.
- [Shah--Rashmi--Kumar--Ramchandran](https://arxiv.org/abs/1011.2361) uses “repair-by-transfer” for
  helpers forwarding stored data without arithmetic. The displayed scalar equation is such an
  achieved helper protocol, but no optimality or array-code claim follows.

Accordingly, the manuscript uses “direct scalar protocol” and states achieved access/download,
while reserving “optimal bandwidth” and “optimal access” for a declared subpacketized model with
lower bounds. It uses “help-by-transfer” only for the achieved scalar forwarding protocol, without
an optimality implication.

## Publication disposition

The manuscript draft now states the achieved direct scalar protocol and explicitly separates it from
minimum-bandwidth or minimum-access claims. This answers the operational referee question without
adding a comparison plot or an invariant that the formal model does not control. Further bandwidth
work would require a declared subpacketization/helper-message model and new information-theoretic
lower bounds; it is a new project, not a mathematical C203 obligation. C203 is reported only after
the deferred aggregate build succeeds.
