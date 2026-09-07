# C1119: Finite-index torus slices and coprime-degree consequences

**Lane:** `cubic-threefolds`
**Status:** queued after C1116's quotient/descent audit

## Goal and scope

Establish the precise extension of the unimodular slice criterion when the
selected weight differences have finite index d, in characteristic zero.
Entry report: `notes/2026-09-07-cubic-astra-review-triage.md`.
Own `papers/cubic-stabilization-irrationality/`, this card, dated C1119
reports/evidence, and lane routing docs.

## Proof obligations

1. Keep generic freeness and all descended tangent/minor hypotheses. Construct
   the correction isogeny and its finite etale kernel of order d. Distinguish
   this effective-action ambiguity from a redundant torus parametrization.
2. Construct the k-defined geometrically integral rational slice component
   from the tangent-isomorphism open. Prove dominance and generic finiteness
   onto the Rosenlicht quotient; existence of some geometric slice point is
   insufficient by itself.
3. Prove `e | d` for its degree: generic K-torsor components after algebraic
   closure of constants, geometric integrality, and preservation of degree
   under constant extension. If only `e <= d` survives, state that weaker
   theorem and reassess every coprimality consequence.
4. Derive universal CH0-triviality for a smooth proper model from two
   coprime-index constructions only when the divisibility theorem holds.
   Resolve rational maps, justify moving and restriction/corestriction over
   every field extension, and supply a degree-one cycle as well as vanishing
   of A0. Verify the relevant primary sources.
5. Include the effective rank-one example with weights 0,d,1. Seek one bounded
   illustrative finite-index example; do not claim existence of useful
   coprime-index examples without satisfying the full geometric hypotheses.

## Acceptance

A complete theorem with all field/component hypotheses, reviewed degree and
descent arguments, meaningful examples or an explicit example-existence gate,
and the required paper checks. Present after the unimodular theorem. Feed
accepted degree/failure certificates into C963/C965 later; no new general
rationality-decision or commercial claim.
