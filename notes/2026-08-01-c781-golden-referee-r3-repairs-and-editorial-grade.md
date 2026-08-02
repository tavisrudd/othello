# Golden referee round three repairs and editorial grade

## Outcome

The three cold-read minors are closed.  The manuscript now credits the Clebsch
source for the plane-rotation/permanent observation, the paper package owns its
spacing linter and complete acceptance gate, and the balanced-spectrum argument
is a uniform `3+3` block proof rather than a ten-support calculation.  The same
algebraic spine is kernel-checked in Lean.  A resumed cold reader found no
correctness, normalization, marking, attribution, or feasibility blocker and
graded the paper **B+ / accept after minor revision**.

The final implementation is commit `c88c4ef5`, tagged
`golden-quantum-statistics-editorial-referee-revised`.  The earlier structural
freeze is `e92f2eeb`, tagged
`golden-quantum-statistics-structural-referee-revision`.

## Repairs

- The introduction and Section 3 explicitly assign the determinant-line
  interpretation and the elementary permanent counterexample to Clebsch Paper
  III, while isolating this paper's general double-orbit classification,
  minimal-degree theorem, exact exchange-sector specialization, and
  measurement/resource package.
- `verification/lint_tex_spacing.py` is paper-local, included in the manifest,
  and used by the Makefile.  `make check` now runs all three independent source
  replays as well as the checker, build, and warning gate.  If an extracted
  package has a frozen PDF but no TeX log, the warning target forces a fresh
  build before inspecting warnings.
- For a balanced cut, reorder the conference matrix as
  `C_T = [[A,R],[R^T,E]]`.  The conference equations give
  `A^2+RR^T=5I` and `AR+RE=0`.  A signed triangle satisfies
  `A^2=2I+tau A`, so `A^2` has spectrum `4,1,1`, `RR^T` has spectrum
  `1,4,4`, and `det(R)^2=16`.  Since `R` is invertible,
  `E=-R^{-1}AR`.  Block multiplication then gives diagonal square traces
  `27`, cross contribution `-48`, and fourth-word trace `-42`; the projector
  expansion yields `tr(H^2)=33/25`.  Finally
  `det[D,C_T]=64 det(R)^2=1024`, hence `|Z_T|=8` and
  `det(H)=16/125` from the cited source normalizations.  No balanced support is
  enumerated.
- The verification prose was compressed and the reference layout tightened;
  the warning-free PDF remains thirteen pages.

## Lean boundary

`lean/RelativeConicArcs/GoldenBalancedCut.lean` proves symbolically over a
commutative ring:

- `signedTriangle_sq_entries`;
- `crossGramDet_eq_sixteen`;
- `traceContraction_eq_twelve`;
- `fourthWordTrace_from_block_formula`.

`GoldenProofSpine.lean` imports and axiom-audits all four declarations.  The
guarded module and aggregate gate pass; each new declaration reports only
`propext`.  The formal boundary is deliberately the scalar algebraic spine,
not an asserted formalization of the full paper correspondence.

## Validation

- paper-local `make check`: green, including all independent source replays;
- extracted tracked paper-only directory with no TeX auxiliaries: complete
  `make check` green, including a forced thirteen-page rebuild and warning scan;
- standalone checker: exact `20+44` masks, exchange-sector values, permanent
  values, chiral filter, decoder, and fifteen-cell compilation green;
- guarded Lean module and `GoldenProofSpine` aggregate: green;
- reverse-import search: the Golden proof-spine gate is the sole affected gate;
- visual inspection: all thirteen pages have sound layout;
- publication-hygiene scan: no internal task identifier, private report path,
  home path, or referee-round filename appears in the paper or Lean artifacts.

## Cold editorial judgment

The referee's ranked headlines are:

1. exchange statistics preserve a hierarchy of geometric information:
   unframed singular-value invariants, calibrated bosonic amplitudes, and the
   exterior amplitude as the minimal orientation carrier;
2. every balanced Boolean control has exact spectrum
   `{1/5,4/5,4/5}`, simultaneously giving the exchange-sector benchmarks and
   the sharp `20/44` boundary;
3. tomography, ordinary bosonic scattering, and direct antisymmetric emulation
   occupy three experimentally distinct levels, with the last requiring the
   additional three-qutrit resource.

For an A-minus paper, the reader would retitle and reopen around that observable
hierarchy, promote the balanced-spectrum theorem beside the orbit theorem, move
the anomaly corollary out of the body, compress the Clebsch/synthematic setup,
and move full decoder and secondary resource ledgers to the supplement.  It
would keep the structural proof in the body.  This is achievable without new
research but is a scope/editorial decision, so it was not silently applied.

An A requires new reach: either a general order-`2d` balanced-cut theorem that
characterizes cut-independent exchange spectra and explains whether `d=3` is
exceptional, or an end-to-end hardware-grounded validation propagating
realistic loss, phase, distinguishability, tomography, and detector models
through the classifier, ideally with data.  Both would make the A unambiguous.

The referee's blunt description is: this is an exact theoretical case study in
the hierarchy of observables of a multiparticle interferometer; Golden/Clebsch
geometry supplies the unusually solvable model and should support rather than
compete with that identity.

## `ej` + `tt` closeout and Mystery ledger

The cheap upgrades exposed by closeout were taken: the structural proof was
made independent of support enumeration, its reusable scalar spine was
formalized, the complete package gate was made literal, and the Verification
section was compressed enough to avoid a one-reference fourteenth page.

- **Settled:** the uniform balanced spectrum is forced by the signed-triangle
  polynomial and conference block equations, not by an accidental finite
  census.
- **Settled:** the portable package gate now checks exactly what the manuscript
  says it checks, even when exported without build auxiliaries.
- **Open research opportunity, not a defect:** determine the order-`2d`
  criterion for cut-independent exchange spectra and whether dimension six is
  exceptional.  This is new-research scope and was not allocated here.
- **Open experiment opportunity, not a defect:** place a concrete processor
  noise model inside the derived feasibility region.  This requires platform
  data or a separately scoped simulation study.

No other genuine mathematical mystery remains in the repaired six-mode proof.
The discovery-track discriminator keeps both open opportunities out of the
current discovery log: each changes the paper's research scope and needs an
explicit successor decision rather than a cheap task-local upgrade.
