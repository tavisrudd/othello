# C855 — replacing the manuscript-relative names in the orientation development

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist section "Replace manuscript-relative and false-strength API names".

## What was renamed

The eleven `PaperIOrientation*` modules are now `SupportOrientation*`: `Commutant`, `Cover`,
`Determinant`, `Holonomy`, `Nodes`, `Pentagon`, `Spine`, `Symmetry`, `SymmetryCore`,
`SymmetryGenerators`, `TraceDual`.  Each retains the descriptive tail that names its object, and the
stem now names the mathematical subject — the support-orientation cubic of the code and its golden
conference operator — rather than a manuscript position.  Files, namespaces, imports, the rigidity
gate's import and its `#print axioms` list, the area registry's terminal list, and the export
configuration were changed together.

Three further names went with them.

`OddSixArcPrismExtraction.canonicalLabel` is now `chosenLabel`.  It is read off the noncomputably
chosen equivalence `Finset.equivFinOfCardEq`; nothing about the plane determines it and no
invariance is proved, so the old name asserted a canonicity that no theorem supplies.  Its docstring
now says exactly that.

The trace-dual module carried a cluster of declarations named after the manuscript display:
`paperGoldenEigenspaceBasis`, `paperAxisOrder`, `paperAxisSign`, `paperConferenceMatrix`,
`paperConferenceMatrix_eq_transport`, and `goldenEigenspaceBasis_eq_paper_transport`.  They are now
`displayed*`, using the sense the rest of this development already gives that word: written out
explicitly here.  The docstrings name the gauge — the axis order and switching in which the golden
eigenspace basis takes the six-by-three form written out in the module — instead of pointing at a
document.

The gate terminal `oddModule_rationalCommutant_eq_adjoin_B` named its conclusion through an
undefined letter.  The algebra in question is `adjoinGoldenOperator`, so the terminal is now
`oddModule_rationalCommutant_eq_adjoinGoldenOperator`, and its docstring says "the algebra generated
by the golden operator".  One docstring described its hypothesis as the "reviewed" classical
splitting interface; the word records a process rather than mathematics and is gone.

No compatibility alias was left behind for any of these names.

## What was checked and not changed

A scan of the renamed modules for the strength words `canonical`, `unique`, `exact`, `complete`,
`classification`, `reconstruction`, `optimal`, `minimal`, `maximal`, `sharp`, and `universal` found
one hit, `completeFourMatrixModTwo`, where "complete" is the complete graph on four vertices.  That
is standard terminology for the object, not a strength claim, so it stands.

A scan of the whole library for declaration names containing `paper` or a task-identifier shape
found nothing outside the Q25 and Baer generated data trees, whose `R_026_C_077_126`-style names are
row indices belonging to another lane.

The public theorem names in the renamed modules are hypothesis- and conclusion-shaped
(`mem_..._iff_...`, `..._eq_...`), and none asserts a uniformity or constructivity the statement
does not carry.

## Validation

`RelativeConicArcs.Gates.ClebschRigidityTrust` builds green through the build queue after the
renames, at a peak of about 9.5 GB.  It is the only gate in the reverse-import closure of every
changed module.  The trust fact for the renamed spine unit was re-extracted from the committed tree
and records 24 terminals whose axioms are exactly `propext`, `Classical.choice` and `Quot.sound`,
with no project axiom; the fact under the old unit name is deleted.

## Two things this exposed

The tracked axiom audit `lean/verification/clebsch_rigidity_trust/axiom-audit.txt` still names the
retired Dye equality axiom in eight rows, and still uses the old module names.  It cannot be
refreshed from this repository: it has 52 rows against the local gate's 48 `#print axioms`, and the
four extra rows are `Examples.Q11A5PointOrbits` terminals whose modules exist only in the pinned
order-eleven certificate package.  The tracked file is a copy of the package gate's output, so
refreshing it is part of the package re-pin, which is in turn blocked until the base library commit
is published.

Sixteen modules of the order-eleven six-arc development — the concurrence bound, the chord-matching
and one-factorization combinatorics, the golden normal form, the order-eleven identification, and the
rigidity spine and prism modules — are owned by the `relconic` area but imported by no declared
extraction unit.  Fifteen of them were already in that state; `Q11GoldenHexagonWitness` joined them.
This is not only an audit annotation: the area's extraction units are what the companion export
carries to the base library, and the export configuration for this material names
`RelativeConicArcs.SupportOrientationSpine`, which does not import any of the sixteen.  So there is
currently no route by which the newly proved concurrence bound and equality classification would
reach the certificate package at all, and the axiom would keep its downstream life indefinitely.

The fix is a declared import-only gate over the six-arc concurrence development, registered as an
area gate with its terminals, which is a validation-gate addition rather than a rename and is left
for an explicit decision.
