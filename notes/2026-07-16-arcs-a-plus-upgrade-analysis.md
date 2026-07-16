# Prescribed-conic paper: route from strong A to solid A+

**Date:** 2026-07-16
**Lane:** `relconic`

## Verdict

The present manuscript is a mature strong-A specialist paper.  Further prose
polish, isolated values of `rho_C(q)`, or additional coding translations are
unlikely to change that assessment.  A credible A+ upgrade needs a second
theorem that is mathematically inseparable from the prescribed-hole defect
identity rather than another parallel application.

The discovery-track audit shows that this route was already registered as
**C201**: turn the `q=16` uncovered-quadratic obstruction into an even-field
structural theorem, or determine precisely why it does not extend.  This is the
best bounded next experiment.  The `O(sqrt(q))` construction problem has a
higher ultimate ceiling, but it is a longer-horizon program and should follow
the C201 evidence.

## Why C201 is the right immediate probe

The paper currently has two complementary mechanisms:

1. the defect identity gives universal scalar lower bounds, equality, and
   stability information;
2. quadratic evaluation rank excludes the remaining eight-point possibility
   over `GF(16)`.

At present the second mechanism ends in a finite classification.  A family
theorem would create the missing unified chain

```text
defect bound -> bounded candidate cells -> uncovered-locus geometry
             -> quadratic-rank obstruction -> even-field conclusion.
```

This would answer the most serious significance criticism: the finite result
would become the first instance of a reusable structural theorem rather than a
well-certified isolated classification.

## Existing theorem boundary

C107 already proves the general evaluation-avoidance dichotomy.  When
`K` is the space of quadrics vanishing on the ordinary-uncovered locus and
`|A| <= q`, a quadric in `K` can avoid the arc unless either

- `K = 0` (the uncovered evaluations have full rank six), or
- evaluation at some arc point vanishes on all of `K` (a forced arc hit).

Thus C201 must **not** be credited for restating “full rank or forced hit.”
Its new mathematical content must be geometric: force one of those alternatives
from the arc/defect/incidence structure over a nontrivial even-field family, or
exhibit and explain the first obstruction to doing so.

The `GF(16)` certificate supplies the model profile: 2630 leaves have full
quadratic rank, while three rank-five leaves have a unique quadratic forced to
meet the arc.  Equality and first-excess classification should seek the
geometric meaning of this split rather than merely recounting it.

## Ranked program

1. **C201 — immediate, bounded, highest leverage.** Derive the geometric
   symbolic reduction, run a sized and orbit-reduced `q=64` falsification gate,
   and classify the rank-deficient/equality cells.
2. **C209 — gated on C201.** If the C201 data expose a stable incidence or
   polarity pattern, formulate a polarity dual and a structural
   equality/first-excess theorem.  Do not launch this as an independent census.
3. **C210 — long horizon.** Pursue `O(sqrt(q))` constructions, or an infinite
   obstruction to them, using the rank data collected by C201.  This remains the
   highest-ceiling asymptotic question.
4. **C188 — release polish only.** Add `rho_C(5)=4` with strict-trust Lean.  It
   improves completeness of the value table but is not an A+ carrier.

## Routes deliberately rejected

- Do not migrate the `4 <= k <= 7` conic-filling classification from the
  Clebsch paper; that damages theorem ownership and paper separation.
- Do not enlarge the q11 coding/icosahedral coda merely to add weight.  The
  discovery track has already extracted its natural consequences.
- Do not treat arbitrary-hole generality, the affine specialization, or more
  exact small values as substitutes for a new structural theorem.
- Do not run an infeasible all-arc `q=64` enumeration.  C201 begins with a
  symbolic and sizing gate and proceeds only on reduced candidate cells.

## Manuscript decision rule

Add C201 to the current paper only if it yields a concise family theorem or a
genuine structural stability theorem that uses the existing machinery.  A
negative `q=64` result, an isolated new value, or a large unifying computation
belongs in the discovery record or a follow-on, not in the submission.
