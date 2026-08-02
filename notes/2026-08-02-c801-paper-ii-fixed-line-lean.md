# C801 — Paper II table-free fixed-line Lean update

## Outcome

The reusable algebraic core of the fixed-line theorem is formalized in
`RelativeConicArcs.ClebschFixedLineRadialTranslation`.  It contains no orbit representatives,
matching census, native evaluation, generated table, `sorry`, or new axiom.

The formal interface separates the exact proof boundary cleanly:

- `TwoSheetRadialData` records the two unchanged top configurations, their unchanged first and
  second moments, and the reference outer radial constant;
- `topConfigurations_first_secondMoments_invariant` and `outerRadialConstantAt_sub` prove that
  radial translation preserves the first three data and changes the outer constant affinely with
  slope `-2`;
- `outerRadialConstantAt_eq_zero_iff` proves the unique coalescence parameter `c / 2` away from
  characteristic two;
- `RadicalHadamardFamily` states the common restriction, equal-second-moment, and nonzero-pairing
  hypotheses once, while the radial level carries the sole parameter-dependent separation;
- `hadamardSquare_eq_equalSheetSum_of_noncoalescent` transports the existing abstract
  Radical--Hadamard theorem to every noncoalescent parameter;
- `annihilates_hadamardSquare_iff_eq_sheetSignLine_of_noncoalescent` identifies the entire
  quadratic-trade annihilator with the one-dimensional sheet-sign line; and
- `nonmatchingNoncoalescentParameters_tradeLine_and_card` combines the trade conclusion with the
  exact finite-line count `|K| - 2` after deleting the matching and coalescence parameters.

The unique Chow point remains on the human side, as intended.  Lean does not claim the invariant
space dimensions, stabilizer and normalizer identifications, unique block systems, or unique
factorization argument that selects the matching placement.

## Trust integration

`RelativeConicArcs.Gates.ClebschPaperIIStructural` now imports the fixed-line module and audits six
new terminals.  The gate has twenty-eight Paper-II terminals, while the four Paper-II gates have
fifty-four audited terminals in total.  The trust manifest marks the fixed-line theorem with Lean
coverage but states that only radial inheritance, the sheet-sign annihilator, and the parameter
count are formal.  The manuscript gives the exact terminal names and retains conceptual and
classical-input modes for the geometric half.  The structural checksum manifest, statement
identity, and evidence fingerprint were regenerated.

## Validation

- Guarded single-file elaboration of
  `RelativeConicArcs/ClebschFixedLineRadialTranslation.lean`: passed.
- Guarded build queue for the new module and
  `RelativeConicArcs.Gates.ClebschPaperIIStructural`: passed, including the trace-only aggregate.
- Paper II axiom allowlist: passed with only `propext`, `Classical.choice`, and `Quot.sound`.
- Paper II aggregate verifier: passed all twenty-nine statements and fourteen evidence bundles.
- Manuscript: warning-free forty-one-page PDF.

## Extra-juice and Tao closeout

The closeout exposed one cheap strengthening: the first implementation proved inheritance and
counting separately.  The combined terminal
`nonmatchingNoncoalescentParameters_tradeLine_and_card` now states the exact table-free conclusion
at the natural reusable level: every member of a finite field outside the two distinguished
parameters has the sheet-sign trade line, and there are exactly `|K| - 2` such parameters.

The abstraction does not pretend to prove moment invariance from the concrete conic geometry.
Instead, `TwoSheetRadialData` is the quotient-coordinate interface supplied by the human proof, and
Lean proves every algebraic consequence after that interface.  This avoids both a hidden orbit
table and an inflated claim that the Chow intersection has been formalized.

## Mystery ledger

- **Settled — can the inheritance and count be stated as one theorem?** Yes.  The combined terminal
  gives precisely the nonmatching, noncoalescent sheet-sign family and its cardinality.
- **Settled — is the exceptional parameter unique without enumeration?** Yes.  The affine outer
  constant vanishes exactly at `c / 2`, distinct from the matching parameter when `c != 0`.
- **Open but outside the formal boundary — why does the coalescence point retain Schur-square
  corank one in the concrete `B3/H3` examples?** The finite evidence verifies it, but the paper does
  not use it and this task found no reusable table-free proof.
- **No further mystery remains in C801's scope.** The unique Chow intersection is deliberately the
  separately stated human finite-group and factorization theorem.

## Discovery-track review

No incidental observation arose outside the task deliverable, so the Clebsch discovery track needs
no new entry.
