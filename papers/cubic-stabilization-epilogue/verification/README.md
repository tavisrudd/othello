# Verification boundary

The manuscript is intended to have a wholly human proof spine.  No certificate,
enumeration, or symbolic program is invoked as a premise.

`make check` performs the source-only Lean correspondence check, deterministic
PDF construction, and warning rejection.  The
correspondence check inventories every theorem-like manuscript environment and
records whether its current Lean coverage is absent, fragmentary, a conditional
deduction, or complete.  It does not build Lean.

At the current interim checkpoint the exact inventory is 23 manuscript claims,
with 0 absent, 13 fragmentary, 9 conditional deductions, and 1 complete.
There are 110 reviewer-facing Lean terminals.  These counts summarize the
current checked map; any change to manuscript labels, claim-map declarations,
public terminals, axiom-audit commands, or expected axiom rows must preserve
their exact correspondence.

Checked coverage snapshot: 23 claims; 0 absent; 13 fragmentary; 9 conditional;
1 complete; 110 reviewer terminals.

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

## Remaining formalization checklist

- Construct the marked finite-etale graph presentation from the geometric
  quotient and identify geometric divisor descent with entrywise integrality
  of its graph-coordinate product.  From supplied split blocks onward, Lean
  now proves the exact flattened coefficient lattice and its rank-one
  generation (`lem:graph-coefficient-lattice`).
- Construct the actual unramified splitting ring and prove that its scalar
  extension of the geometric graph lattice is the formal weighted lattice.
  The abstract coefficient extension, extended rank-one assembly,
  ordinary-product base-change containment, and faithfully-flat reflection
  are now formalized (`thm:all-degree-graph-saturation`).
- Construct the actual cohomology realizations and the isogeny pullback, prove
  its required injectivity on the torsion-free integral lattice, and match the
  geometric graph classes with the canonical elliptic-source exterior model
  (`thm:all-degree-graph-saturation`).
- Identify the actual six-axis kernel with the now-formalized explicit
  quadratic and scalar residue-field slope models, and prove persistence over
  each connected smooth component (`lem:six-axis-local-chart`).
- Supply the away-from-six comparison and local-to-global integral membership
  that specializes the graph theorem to `Theta^4/4!`
  (`thm:six-axis-divided-powers`).
- Formalize the cited Voisin criterion and its application to every smooth
  fibre (`cor:universal-ch0`), then the relative family statement
  (`lem:relative-six-axis`, currently fragmentary).
- Formalize the remaining quantum inputs: the separation family, construct the
  filtered target/associated graded and prove the now-explicit compatibility
  identifying the initial form of a geometric specialized series with its
  finite lowest-support exponential combination in divisor tagging, the
  common-field and bulk
  gauge comparisons, formal base-change comparisons, topological continuity
  and a categorical/topological universal property for the now-explicit
  coefficientwise inverse-limit presentation of numerical completion, and the
  geometric numerical base-change comparison, numerical invariance and
  Gromov--Witten identification of coefficient packets, construction of the
  geometric additive logarithmic weights and quantum connection, strict
  Novikov operations, cubic packet comparison, and the geometric/connection
  inputs that restrict monodromy eigenvalues to `{1,-1}` in dimensions at
  most two.  The exact terminal spectral vanishing implication is now
  formalized; matrix involutivity is recorded only as a stronger sufficient
  special case.  The
  headline deductions remain explicitly conditional until
  those premises are proved (`thm:every-cubic`,
  `thm:nu6-birational-invariance`, and `cor:v14-one-step`).
