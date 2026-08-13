# Verification boundary

The manuscript is intended to have a wholly human proof spine.  No certificate,
enumeration, or symbolic program is invoked as a premise.

`make check` performs the source-only Lean correspondence check, deterministic
PDF construction, and warning rejection.  The
correspondence check inventories every theorem-like manuscript environment and
records whether its current Lean coverage is absent, fragmentary, a conditional
deduction, or complete.  It does not build Lean.

At the current interim checkpoint the exact inventory is 23 manuscript claims,
with 4 absent, 15 fragmentary, 3 conditional deductions, and 1 complete.
There are 62 reviewer-facing Lean terminals.  These counts summarize the
current checked map; any change to manuscript labels, claim-map declarations,
public terminals, axiom-audit commands, or expected axiom rows must preserve
their exact correspondence.

Checked coverage snapshot: 23 claims; 4 absent; 15 fragmentary; 3 conditional;
1 complete; 62 reviewer terminals.

The Lean modules and axiom audit can be built with the pinned package command
documented in `lean/README.md`.  Passing the captured audit output to
`make formal-audit` checks every reviewer terminal against the tracked exact
axiom list.  Neither a source-only pass nor a successful build substitutes for
that transcript check.

The research calculations that led to the integral gluing and divisor-product
statements are discovery evidence rather than premises.  Formal coverage of
those statements requires kernel-checked structural proofs matching the
objects, hypotheses, conclusions, and cautions recorded in
`lean/verification/claims.json`.
