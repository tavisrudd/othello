# Arcs paper: post-revision Lean statement-adequacy audit

## Scope

This audit compares the revised manuscript against the paper-facing Lean
declarations after the expository rework that foregrounded the defect identity,
isolated the polynomial estimate in Theorem 4.2, qualified the liminf through
prime powers, and added the conclusion. No mathematical theorem statement was
intended to change.

## Result

The revised theorem statements remain aligned with Lean. The scoped build queue
found `RelativeConicArcs.Defect`, `RelativeConicArcs.Asymptotic`, and
`RelativeConicArcs.Q16Result` trace-current, and the trace-only aggregate gate
for `RelativeConicArcs.Results` passed. Run record:

`~/.cache/othello-lean-build/run-20260716-152600-7528fde0`

## Statement map

### Prescribed-hole defect identity

The manuscript's `m Delta_H(A)` is Lean's subtraction-safe integer
`scaledDefect A H`. The theorem `scaledDefect_eq_remainders` has the same two
local sums:

- `(r(x)-1)(m-r(x))` on covered required points; and
- `r(y)(m-r(y))` on prescribed holes.

`scaledDefect_eq_zero_iff` gives exactly the manuscript's equality extremes
`r(x) in {1,m}` and `r(y) in {0,m}`. `stability_bound` has the same coefficients
`m-2` and `m-1` on the two intermediate-index sets. The paper's standing
assumption `m >= 3` makes Lean's natural-number subtractions ordinary integer
coefficients.

### Explicit additive lower bound

`rhoC_explicit_additive_lower_bound` states exactly

```text
sqrt(2q) + 3/2 - 8/sqrt(2q) <= rho_C(q)
```

for every realized finite field. The proof of `explicit_additive_lower_bound`
contains the same polynomial expansion now isolated in the manuscript's
elementary estimate. Its blocks `hB2`, `hB1`, `hB0`, `hR`, and `hExpansion`
are respectively the three coefficient bounds, their `4s^2` aggregate, and
the exact cubic identity used in the paper. The estimate was renamed and moved
expositionally, not strengthened or weakened.

### Liminf through prime powers

Lean packages prime-power orders as indexed families of actual finite fields.
`eventually_lt_centered` proves unconditionally that every `b < 3/2` is
eventually below `rho_C(q)-sqrt(2q)` along any unbounded such family. This is
the operational content of the manuscript's liminf statement, including the
case where the centred values diverge to `+infinity`.

`realized_three_halves_le_liminf` gives the literal real-valued `Filter.liminf`
inequality under a coboundedness hypothesis. This is a representation issue:
Mathlib's real-valued liminf cannot take the value `+infinity`. The manuscript's
ordinary mathematical liminf through prime powers is therefore covered by the
unconditional eventual theorem, with the literal real-valued wrapper available
when the result is finite.

### Quadratic avoidance and `rho_C(16)=9`

`level8_quadraticAvoidance` proves the singular-or-nonsingular quadratic
obstruction for every member of the kernel-checked 2633-entry covering list.
The frame normalization and transition coverage are separately kernel-checked.
The manuscript then gives the short coordinate-change argument transporting an
arbitrary eight-arc and its quadratic to a listed leaf.

Lean's monolithic global declaration is the relative-conic specialization:
`no_completeOutside_GF16_card_eight`, followed by `rhoC_GF16`. Thus the exact
value `rho_C(16)=9` is fully kernel-checked. There is not currently a single
global Lean declaration for the stronger arbitrary-quadratic statement; its
finite leaf obstruction is kernel-checked and its final projective transport is
the explicit mathematical argument in the paper. The manuscript verification
table and `TRUST.md` now state this boundary precisely.

## Axiom and execution boundary

The audited declarations remain within the recorded accepted foundations
`propext`, `Classical.choice`, and `Quot.sound`. There is no `sorryAx`, custom
axiom, or `native_decide` dependency. No generated certificate or Lean source
was changed by this audit.
