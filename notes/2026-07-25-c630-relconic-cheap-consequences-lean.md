# C630: Lean formalization of the equality consequences

**Date:** 2026-07-25

## Scope and result

`RelativeConicArcs.EqualityConsequences` formalizes the inexpensive
consequences added after the cold-read pass:

- `scaledDefect_eq_zero_or_half_sub_two_le` proves the integral discrete
  zero-or-gap alternative for scaled defect.
- `completeAffine_equality_order` derives the two complete-affine equality
  orders from relative completeness and the equality identity.
- `odd_completeOutside_zeroDefect_order_spectrum` derives the three possible
  plane orders for an odd zero-defect arc complete outside a hole set of
  cardinality \(q+1\).
- `odd_standardConic_zeroDefect_charTwo_order` collapses that spectrum over a
  finite field of characteristic two to \(q=k-1\).
- `exceptional_candidate_secant_type_cards` derives the exact
  tangent/bisecant/external split \((46,2070,2070)\) at
  \((q,k)=(4096,92)\), including the intermediate incidence value \(4186\).

The module also exposes the arithmetic helper lemmas and secant-type finsets
used by these terminals.  `RelativeConicArcs.Gates.Relconic` imports the module
and audits the five paper-facing declarations above.

## Exact boundary

The characteristic-two terminal proves the arithmetic collapse and uses the
formal nucleus geometry available for the standard conic.  It does not prove
the converse classification that identifies an arbitrary equality oval with
the prescribed conic through its nucleus, nor the parallel arbitrary-hyperoval
converse.  Those two geometric identifications remain analytic paper proofs;
the existing API has no arbitrary-oval nucleus structure from which to state
the converse honestly.

## Validation

The module elaborates with:

```text
lean/scripts/guarded-lean RelativeConicArcs/EqualityConsequences.lean
```

The lane exit is the exact aggregate target:

```text
lean/scripts/lean-build-queue.py run RelativeConicArcs.EqualityConsequences \
  --profile single --threads 1 \
  --aggregate RelativeConicArcs.Gates.Relconic --cores 20-23
```

The gate's `#print axioms` audit reports only `propext`,
`Classical.choice`, and `Quot.sound` for the new paper-facing terminals.

## `ej` + `tt` closeout and mystery ledger

- **Settled cheaply:** the exceptional theorem derives \(I_C(A)=4186\)
  internally rather than accepting it as an extra hypothesis.
- **Settled cheaply:** the characteristic-two collapse is factored through the
  reusable arithmetic statement that an odd divisor of a power of two is one.
- **Settled cheaply:** the exact three secant-type cardinalities are one
  terminal, so the manuscript does not rely on an informal final linear solve.
- **Open, exact evidence gap:** the arbitrary oval--nucleus converse needs a
  formal arbitrary-oval nucleus API and a theorem relating it to the prescribed
  standard conic.
- **Open, exact evidence gap:** the hyperoval converse likewise needs a
  geometric classification statement, not further arithmetic.

No other genuine mystery remains inside the arithmetic equality consequences.
