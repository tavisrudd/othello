# Clebsch Paper 1 Lean prose audit

**Date:** 2026-07-23

**Lane:** `clebsch`

**Disposition:** prose changes recommended; no Lean source changed

## Scope

This audit covers the 49 owned Lean modules in the adopted Paper 1 formalization
closure:

- C420--C428;
- C494; and
- C503--C507.

That is 9,842 lines across the signed-moment, conic-quotient, harmonic,
factorization, balanced-sheet, double-coset, Fourier, chirality, weighted-adjoint,
information-lattice, arithmetic-gluing, Witt--Hadamard, torsor, survival, and
passage-interface modules and their gates.

The optional `ClebschSchemeIntersectionTensor.lean` leaf is absent and was not
counted. The audit excludes Paper 2, optional companion packages, transitive
gateway and reflection-arrangement imports, proof scripts, and the manuscript.
C320 owns release reconciliation, so this report is read-only with respect to
that active work.

The standard applied here is `papers/style-guide.md`, especially its rules for
reader-first explanation, compact structure, trust-boundary disclosure,
individual declaration documentation, mathematical rather than workflow
language, exact citation of classical inputs, and avoidance of generic
machine-written phrasing.

## Overall assessment

The comments are mathematically serious and unusually candid about what Lean
does and does not prove. The finite-data modules generally distinguish literal
kernel checks from external geometric identification; the gates usually retain
rather than erase those boundaries. The prose avoids salesmanship and most
generic machine-written habits.

The principal weakness is editorial layering. Several module introductions try
to serve simultaneously as motivation, API inventory, verification ledger, and
exclusion list. At declaration level, the coverage is less complete: a
conservative mechanical pass found 42 public declarations without their own
docstrings. A few comments also describe repository workflow rather than stable
mathematics.

## Findings

### 1. Forty-two public declarations lack individual docstrings

This is the clearest violation of the Lean-comment rule. A nearby section
comment or a docstring on the first member of a group does not attach
documentation to the remaining declarations.

The candidates are:

- `ClebschMomentTrade.lean:168,171,174,177`:
  `witness_moment_zero`, `witness_moment_one`, `witness_moment_two`,
  `witness_moment_three`;
- `ClebschConicMatchingQuotient.lean:280,281`:
  `m0213`, `m0312`;
- `ClebschBalancedSheets.lean:84,732`:
  `hadamard_mem_hadamardSquare`,
  `signedSubgroupAction_eq_character_smul`;
- `ClebschBalancedSheetsB3.lean:214,223`:
  `b3_signedGenerator_mem_generated`,
  `b3_signedEvaluation_cubicWitness`;
- `ClebschBalancedSheetsH3.lean:243,252`:
  `h3_signedGenerator_mem_generated`,
  `h3_signedEvaluation_cubicWitness`;
- `ClebschDoubleCosetDepthData.lean:22-26`:
  `Parent`, `Endpoint`, `ProjectivePoint`, `RelationCell`, `Generator`;
- `ClebschSchemeChiralityData.lean:17,18`:
  `SchemeVector`, `NeighborIndex`;
- `ClebschInformationLatticeB3.lean:198-201,221,225,229,233`:
  the four label-surjectivity theorems and four dimension theorems;
- `ClebschInformationLatticeH3.lean:184-187,207,211,215,219`:
  the corresponding eight theorems;
- `ClebschWittHadamardData.lean:20-23`:
  `F3`, `Word12`, `SignRow12`, `Perm12`;
- `ClebschSurvivalBoundaryData.lean:26`: `F11`;
- `ClebschPassageInterfacesData.lean:27`: `F11`; and
- `ClebschPassageInterfaces.lean:286`: `rightMarkedAction`.

Recommended repair: give each declaration one sentence saying what it denotes
or proves and, where useful, why the reader needs it. Do not merely repeat the
identifier in prose. The four witness-moment lemmas can each state the value
being checked; the dimension and surjectivity families can remain terse.

### 2. Four important overviews are ordinary comments, not module docs

The opening blocks in these files use `/- ... -/`, not `/-! ... -/`:

- `ClebschSchemeFourierData.lean:1`;
- `ClebschSchemeFourier.lean:1`;
- `ClebschSchemeChiralityData.lean:1`; and
- `ClebschSchemeChirality.lean:1`.

Their content is valuable, especially the verification boundaries, but it will
not appear as module documentation. Convert the mathematical overview in each
file to a module doc. If the generated-source warning in
`ClebschSchemeFourierData.lean` must remain an ordinary comment, separate that
warning from a following `/-!` overview.

### 3. Replace task- and workflow-relative language with stable mathematics

`ClebschBalancedSheetsH3.lean:379` names an internal task in a public
docstring. Replace it with the theorem or construction name, for example the
radical--Hadamard sheet-sign trade.

Three other comments locate meaning by saying it is proved “downstream”:

- `ClebschDoubleCosetDepthData.lean:48`;
- `ClebschDoubleCosetDepthData.lean:62`; and
- `ClebschTorsorRosettaData.lean:16`.

These descriptions will become stale when files move or imports change. State
the stable boundary instead: the object is frozen data, and a named companion
theorem proves the indicated compatibility. Where practical, cite that theorem
by its fully qualified name.

### 4. Classical and semantic inputs need exact references

Several comments correctly admit that an identification is external, but stop
at phrases such as “classical input,” “standard quadratic-algebra input,” or
“cited-input boundary.” Representative locations are:

- `ArrangementWeightedAdjoint.lean:31-34`;
- `ClebschWeightedAdjointB3.lean:12-14`;
- `ClebschTorsorRosettaData.lean:12-17`;
- `Gates/ClebschArithmeticGluing.lean:10-14`; and
- `Gates/ClebschWittHadamard.lean:14-18`.

That is honest but not yet independently checkable. Each named dependency
should point to an exact theorem, paper section, book proposition, or a precise
row in the paper's claim/trust ledger. A single stable ledger reference is
preferable to duplicating bibliography throughout the Lean tree.

### 5. The longest module introductions need a second editing pass

Twenty-seven module-level blocks exceed roughly one hundred words. The most
conspicuous are:

- `ClebschMomentTrade.lean:9` — about 337 words;
- `ClebschConicMatchingQuotient.lean:4` — about 302 words;
- `ArrangementWeightedAdjoint.lean:6` — about 264 words;
- `ClebschTorsorRosetta.lean:8` — about 228 words; and
- `ClebschHarmonicQuotient.lean:8` — about 217 words.

These blocks contain good material, but long API lists and repeated negative
scope clauses obscure the central idea. Keep, in order:

1. the mathematical object;
2. the idea of the proof or calculation;
3. the exact trust boundary; and
4. only the exclusions a reader might otherwise infer.

Move exhaustive terminal inventories to the import gate or trust ledger. This
is an economy edit, not a request to delete the illuminating examples or the
honest limits.

### 6. A few titles promise more than the body should have to qualify

`ClebschTorsorRosetta.lean:9` begins “Certified orientation dictionaries,” but
the same introduction later says that the fixed-child, character, readout, and
descent identifications are external inputs. The body is candid; the title is
the part likely to be read in isolation. Prefer a neutral title such as
“Orientation dictionaries for the Clebsch close,” leaving the precise
certification claim to the following boundary paragraph.

Likewise, titles containing “checks” are suitable for literal finite
calculations, but should not be used as shorthand for the external semantic
identification of those calculations.

## What is already working

- Trust boundaries are usually explicit and local.
- Data modules generally say which facts are literal inputs and which facts
  companion theorems derive.
- Gate comments usually avoid upgrading imported certificate-backed statements
  to stronger geometric claims.
- The comments contain no obvious sales language or self-congratulation.
- The targeted phrase scan found no occurrence of the prohibited architectural
  expression and little generic machine-written filler.
- Proof comments in `ClebschSchemeFourier.lean:53-64` orient the reader at the
  genuinely nontrivial steps without narrating routine tactics.
- The Paper 1 close modules frequently state their exclusions with enough
  precision to prevent a reader from mistaking a finite model for a classical
  identification.

## Recommended edit order

1. Add the 42 declaration docstrings.
2. Promote the four opening overviews to module docs.
3. Remove the internal task reference and replace “downstream” with named
   mathematical interfaces.
4. Add exact ledger or literature references for classical inputs.
5. Compress the five longest introductions, then review the remaining long
   headers opportunistically.
6. Neutralize the one ambiguous “Certified” title.

These are prose-only changes. They should not require rebuilding proofs, though
the usual exact-target checks should follow any source edit.
