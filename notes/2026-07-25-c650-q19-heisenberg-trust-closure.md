# C650 q=19 Heisenberg trust closure

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** COMPLETE.  The bounded formal sources, aggregate gate, exact-current confirmation, and
axiom audit all pass.  No paper file was edited.

## Goal

Move every fixed-coordinate claim about the exceptional q=19 Heisenberg pair into the Lean kernel.
The exhaustive C637/C643 assertion that this pair is the sole survivor among 1,053,996 tested
extensions remains external.

The fixed claims are:

1. both nine-point sets are arcs and the second is exactly the ordinary uncovered locus of the
   first;
2. the full line, secant-multiplicity, and four chord-direction profiles;
3. full projective stabilizer order nine, equality with the displayed Heisenberg subgroup, and
   projective inequivalence of the two orbits;
4. uniqueness of each orbit cubic, the common semi-invariant pencil, its rational point-count
   distribution, and its empty rational base locus;
5. all 126 five-subset conics, their 81 distinct normalized forms and five exact profiles, the
   nine-conic Heisenberg orbit, and its tangent incidences.

## Formal architecture

`RelativeConicArcs.NinePointHeisenbergIncidence` is a definitions-only base.  Its terminal checks
are split across `NinePointHeisenbergUncoveredLocus`, `NinePointHeisenbergLineProfile`, and
`NinePointHeisenbergChordProfile`.

`RelativeConicArcs.NinePointHeisenbergStabilizer` constructs the unique frame-normalized
transporter for each of the 3024 ordered target frames.  The symbolic theorem
`matrix_eq_smul_of_coordinate_frame_rays` proves that two nonsingular matrices with the same
coordinate-frame rays differ by a scalar.  This connects the finite frame enumeration to the full
projective stabilizer rather than treating its candidates as an unexplained list.

`RelativeConicArcs.NinePointHeisenbergCubicPencil` proves uniqueness of both cubics from explicit
nonzero nine-by-nine evaluation minors.  `NinePointHeisenbergCubicPencilCounts` checks all 381
projective points on all twenty rational pencil members.

`RelativeConicArcs.NinePointHeisenbergConicCensus` constructs each conic from the six signed
five-by-five minors of its five-point evaluation matrix.  Reducible fixed-size determinant
evaluators are connected to `Matrix.det` by
`NinePointHeisenbergConicCensus.determinantThree_eq_det` and
`NinePointHeisenbergConicCensus.determinantFive_eq_det`; explicit coefficient equality is
connected to function equality by
`NinePointHeisenbergConicCensus.sameQuadraticCoefficients_eq_true_iff`.

Counts, profiles, and the nine-conic orbit are divided into one-proposition leaves.  For the
more expensive discriminant-to-secant interpretation,
`RelativeConicArcs.NinePointHeisenbergConicTable.conicTable_covers_distinctConics` kernel-checks
that an explicit 81-entry evaluation cache covers every conic constructed by the census.
Twenty-seven three-conic leaves check every table entry and every selected point; symbolic list
lemmas combine those checks and transport them back to `distinctConics`.  The table is therefore
not an externally trusted classification or certificate.

`RelativeConicArcs.Gates.NinePointHeisenbergFixedProfile` is the aggregate import and axiom gate.

## Trust boundary

The fixed-profile terminals use Lean kernel reduction, including `decide +kernel` for the larger
finite propositions, and symbolic proof.  They import no generated certificate, native evaluator,
externally trusted table, axiom, or `sorry`.  The explicit conic evaluation table is accepted only
through its kernel-checked exhaustive coverage theorem.

The aggregate `#print axioms` audit reports only Lean's standard logical infrastructure:
`propext`, `Classical.choice`, and `Quot.sound`.  It reports no declaration-specific axiom, native
decision axiom, imported certificate axiom, or unproved placeholder.

The exhaustive parent-extension classification is deliberately absent.  In particular, this
formalization does not prove that the displayed pair is the unique q=19 residue and does not change
the external lower-bound status of \(\rho_{\mathcal C}(19)=10\).

## Validation

The definitions-only incidence base elaborates directly.  Monolithic incidence, secant, and
conic-type terminals exceeded the single-file memory envelope.  The current source uses
module-boundary coordinate blocks for projective points and three-entry blocks for the conic
evaluation table; their aggregators are symbolic and do not repeat the finite reductions.

The exact aggregate build
`/home/tavis/.cache/othello-lean-build/run-20260726-110239-6e6cc2ca` passed
`RelativeConicArcs.Gates.NinePointHeisenbergFixedProfile` in 6 minutes 20 seconds with a
9,164,396 kB peak.  Its output contains the complete axiom audit.  The follow-up run
`/home/tavis/.cache/othello-lean-build/run-20260726-111003-cb6a2ad4` found the exact gate
trace-current and passed the trace-only aggregate check.

## Mystery ledger

- **Kernel-checked:** the fixed pair's incidence, stabilizer, cubic, and conic data, including
  exhaustive coverage of the 81-entry conic evaluation table.
- **Formal gate:** exact-target builds, the exact-current check, and the aggregate axiom audit pass.
- **Settled by the final `ej` + `tt` pass:** fixed-size reducible determinant evaluators bridge
  symbolically to `Matrix.det`, and the repeated conic reconstructions factor through a single
  exhaustively covered evaluation table.  No unexplained fixed-coordinate mystery remains.
- **Outside this task:** exhaustive uniqueness among the parent extensions.
- **Owned by C648:** a field-uniform projective Heisenberg orbit calculus and any responsible
  collinearity-or-Heisenberg dichotomy.
