# C517 — Lean boundary for the PRS redundancy-nine theorem

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Result

The load-bearing residual-quadratic algebra and the exact logical boundary of the
redundancy-nine synthesis are formalized in:

- `RelativeConicArcs.PRSResidualQuadratic`;
- `RelativeConicArcs.PRSRedundancyNine`;
- import gate `RelativeConicArcs.Gates.PRSRedundancyNine`.

There are no new axioms, finite-data imports, native evaluators, or opaque computational oracles.
The algebraic module checks:

- divided-power contraction
  `a_i ↦ a_{i+1}-r a_i`, including additivity, scalar compatibility, commuting markers, and the
  explicit two-marker formula;
- the four consecutive binary-quartic/quintic Hankel contractions;
- the determinant and the homogeneous sum/product numerators;
- both residual Hankel identities;
- identification of the branch polynomial with the quadratic discriminant;
- the inhomogeneous residual sum/product solution off `D=0`;
- both rational residual roots from `y²=K` off `2D=0`, together with their exact sum and product.

The synthesis module does not silently assert the geometric inputs proved outside Lean. It packages
them as explicit fields of `ResidualSliceInput`:

1. existence of a geometrically integral reduced genus-at-most-one slice;
2. a rational point outside the determinant, branch, diagonal, and collision deletions for
   `q≥53`;
3. conversion of that point into a split squarefree septic witness.

`redundancyNineSynthesis` then proves witness existence for every syndrome outside the persistent
set and uses the explicit witness-to-shallow implication to prove that a syndrome is deep exactly
when it belongs to the persistent tangent/sigma union. `PersistentFamilyData.deep_card` checks the exact total
`q(q+1)^2/2` from the disjoint tangent/sigma cardinalities, and `orbit_count_pair` checks the exact
projective/projective-semilinear table
`(2,2)`, `(3,3)`, `(4,4)`, `(6,6)`, or `(6,5)` for the six arithmetic cases.

This mirrors rather than strengthens the C516 boundary: geometric integrality, Hasse--Weil
point existence after deletions, identification of the geometric families with actual PRS
syndromes, and exhaustion by those families remain hypotheses. Lean proves the algebra and the
final implication from those hypotheses.

## Declaration ledger

The algebraic terminal declarations are:

- `RelativeConicArcs.PRSResidualQuadratic.dividedPowerContraction_comm`;
- `RelativeConicArcs.PRSResidualQuadratic.dividedPowerContraction_twice_apply`;
- `RelativeConicArcs.PRSResidualQuadratic.first_hankel_identity`;
- `RelativeConicArcs.PRSResidualQuadratic.second_hankel_identity`;
- `RelativeConicArcs.PRSResidualQuadratic.residual_discriminant`;
- `RelativeConicArcs.PRSResidualQuadratic.residual_sum_product_solve_hankel`;
- `RelativeConicArcs.PRSResidualQuadratic.residual_root_add`;
- `RelativeConicArcs.PRSResidualQuadratic.residual_root_sub`;
- `RelativeConicArcs.PRSResidualQuadratic.residual_roots_sum`;
- `RelativeConicArcs.PRSResidualQuadratic.residual_roots_product`.

The synthesis terminals are:

- `RelativeConicArcs.PRSRedundancyNine.ResidualSliceInput.exceptional_has_splitSquarefreeWitness`;
- `RelativeConicArcs.PRSRedundancyNine.orbit_count_pair`;
- `RelativeConicArcs.PRSRedundancyNine.PersistentFamilyData.deep_card`;
- `RelativeConicArcs.PRSRedundancyNine.redundancyNineSynthesis`.

## Validation

Both source modules pass independent guarded single-file elaboration. The exact import gate
`RelativeConicArcs.Gates.PRSRedundancyNine` passes its managed build and trace-only aggregate check.
The tracked fourteen-terminal audit
`RelativeConicArcs.Gates.PRSRedundancyNineAxiomAudit` passes its managed build and exact-target
staleness check. Its output contains only the standard `propext`, `Classical.choice`, and
`Quot.sound` dependencies already supplied by Lean/mathlib; the two purely logical/table terminals
are axiom-free. There are no project-specific axioms.

## Extra-juice closeout

The cheap algebraic upgrade was to prove more than the two root substitutions: the branch-cover
roots also have the exact prescribed sum and product. This closes a possible semantic gap between
“two zeros of the displayed quadratic” and “the residual quadratic solving the Hankel system.”

The two-marker contraction formula was also exposed as a public theorem. It makes the symmetry of
successive marked contractions explicit rather than leaving it as a bare commutation equality.

The post-gate pass found and closed one semantic gap: a split squarefree witness had been produced
outside the persistent set without an explicit bridge from that witness to shallowness. The
synthesis input now names both the coding-theoretic deep predicate and the witness-to-shallow
implication, and the terminal theorem derives `isDeep s ↔ s ∈ deep`.

## Mystery ledger

Settled:

- **Does the branch square merely produce zeros, or the correct residual factor?** The checked
  sum/product theorems identify it with the unique residual factor off `D=0`.
- **Does marker order affect the contracted syndrome?** No. Commutation and the explicit
  `(X-r)(X-s)` coordinate formula are checked over every commutative ring.
- **Could the formal theorem conceal geometric existence as an axiom?** No. Every component,
  rational-point, deletion, and exhaustion input is a visible structure field.
- **Does witness existence formally imply the advertised exact classification?** Yes. The
  witness-to-shallow bridge and persistent-deep hypothesis now yield the checked equivalence
  `isDeep s ↔ s ∈ deep`.

Open:

- **Can Lean discharge the six-slice binary-quartic component theorem itself?** Not in this
  artifact. Evidence gap: formal binary-quartic normal-form classification and the six
  discriminant-gcd certificate.
- **Can Lean derive the `q≥53` rational-point input from Hasse--Weil and the deletion degrees?**
  Not in this artifact. Evidence gap: a formal genus-at-most-one point bound with the exact
  deleted-divisor budget.
- **Does the orbit table follow from a formal `PGL₂/PΓL₂` action?** Not here. The arithmetic case
  and family cardinalities are explicit inputs; Lean checks the table and total-count synthesis.
