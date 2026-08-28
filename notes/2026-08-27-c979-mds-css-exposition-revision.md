# C979 MDS--CSS exposition revision

**Lane:** `ame-lu`

**Status:** running; user-held open until explicit close

## Goal

Rework *Diagonal Isoduality and Transversal Clifford Groups of MDS--CSS
Codes* as a polished, conventional paper for specialists in its intended
publication field: quantum information, with stabilizer-code knowledge
assumed.  A reader in that field should identify the main theorem, understand
its importance, and follow its proof without already knowing MDS-code
rigidity, six-arcs, Gale duality, or finite-group extension language.  This is
not a multi-audience survey: translate machinery at the disciplinary interface
only where the primary reader needs it.

The first-pass message is the all-length fixed-party classification.  For an
odd-prime linear `[2m,m,m+1]_q` MDS code, the diagonal multiplier space
`D(C,C^perp)` has dimension zero or one.  Those two cases give exactly the
projective logical groups `F_q^2 semidirect T` and
`F_q^2 semidirect SL_2(q)`.  The pencil, six-point geometry, Clebsch example,
lift refinements, scalar invariants, finite calculations, and formal evidence
are consequences, interpretations, refinements, or verification rather than
premises of that theorem.

## Frozen user requirements

- Keep C979 open until the user explicitly says to close it, even after a
  coherent revision and all validation gates pass.
- Correct `papers/mds_css_transversal_groups/README.md` so it contains no claim
  that this paper belongs to a Clebsch series or Clebsch portfolio.  The
  Clebsch code may remain accurately described as a worked application.
- Make the result read like a standard finished quantum-information paper, not
  onboarding material, a programme map, an internal audit, or a guided tour of
  several adjacent disciplines.
- Audit coined terminology and notation against standard quantum-information
  and coding-theory usage.  Replace house terms and house symbols with standard
  ones unless a term names a genuinely new object and earns an explicit
  definition.  Keep any unavoidable translation local and one-time.
- Begin from the operational quantum-information problem, define the
  fixed-party site-dependent transversal convention immediately, and explain
  why the exact logical group matters.
- Make the multiplier nullity-zero/nullity-one theorem the conceptual headline;
  move coherent lifting, Heisenberg nonsplitting, and party motion into clearly
  secondary results.
- State what was known, what gap remains, what this paper proves, what it imports
  from the companion rigidity paper, and why the site-dependent convention is
  essential.
- Expose the six proof steps from local `2 x 2` symplectic blocks through the
  MDS multiplier line to exactness by imported rigidity.
- Separate the all-length theorem, six-point applications, and refinements or
  limitations in both the introduction and the paper architecture.
- Reorganize the mathematical core into the non-isodual case, isodual case,
  and exactness, followed by separate lift and affine-nonsplitting discussions.
- Motivate the pencil before its formulas; explain the `t -> y -> z` quotient,
  the meanings of the admissibility factors, the atlas invariant, and the
  extension-field caveat before detailed arithmetic.
- Present six-point conic/self-association language as a translation of the
  coding condition already settled by the all-length theorem.  Locate the
  Clebsch example in the pencil and separate its conceptual syndrome point from
  group-theoretic bookkeeping.
- Preserve the scalar-blindness contrast while sharpening its setup.  Replace
  the verification wall with an auditable claim/status/method/input table.
- Improve appendix navigation: explain what each calculation is for, rename the
  transport party-assignment variable that conflicts with the characteristic,
  define transport terminology, and tabulate the party-extension census.
- Break paragraphs by rhetorical job, translate one specialist language at a
  time, explain why notation is introduced, and mark optional material.

## Full-read assessment

The manuscript already puts the exact dichotomy on page one and its proofs are
mathematically separated from the finite evidence.  The hierarchy nevertheless
flattens after the theorem.  The introduction moves quickly from the operational
object into a dense literature cluster, imported atlas language, six-point
geometry, pencil classification, scalar invariants, and formal tooling.  Section
3 proves the key result in one long proof that continues through propagation,
uniformization, Weil lifting, affine nonsplitting, and party motion.  Section 4
starts with four unexplained formulas and makes the reader reconstruct why the
degree-eight quotient is natural.  Section 5 partially repeats the all-length
group determination before giving its geometric interpretation.  The
verification boundary is exact but difficult to scan.  The appendices contain
useful optional results without enough first-pass navigation.

## Acceptance gates

1. A reader using only the introduction and mathematical core can answer what
   the code family is, what transversal means, why the group matters, what the
   two groups are, what test distinguishes them, why only two cases occur, and
   which exactness ingredient is imported.
2. The all-length theorem is visibly independent of the pencil, Clebsch
   application, finite census, and formal verification layer.
3. Every moved or rewritten statement preserves hypotheses, field scope,
   projectivization, fixed-party scope, and the distinction between a proved
   statement, imported theorem, formal interface, and finite certificate.
4. The README has no Clebsch-series or Clebsch-portfolio affiliation claim and
   accurately describes the paper as standalone.
5. The theorem/label maps, cross-references, figures, and verification surfaces
   remain synchronized; the warning-free paper gate and evidence replay pass.
6. Rendered before/after comparison and qualified quantum-information cold
   reads separately test mathematical confidence and first-pass readability,
   followed by a red-team of every new overview, table, and moved qualification.

## Progress

- 2026-08-27: read the complete TeX manuscript in source order, including both
  figures and all three appendices, and read the paper README in full.
- 2026-08-27: removed the README paragraph assigning the paper to a Clebsch
  portfolio.  Authority commit `cce408feb`; standalone forward commit
  `2affba3`; exporter content SHA-256
  `2f4a51a3342d3ad75ed50fa16cc607ab2c5fb37097669ef378d07a7c7e2c3330`.
  Export audit, mirror manifest verification, and the standalone `make check`
  gate pass.  Nothing was pushed.
- 2026-08-27: completed the first manuscript-wide exposition revision for a
  quantum-information audience.  The abstract and introduction now establish
  the operational transversal-gate problem, site-dependent convention,
  nullity-zero/nullity-one theorem, proof mechanism, literature gap, imported
  inputs, and paper hierarchy before the six-point material.  The main proof
  is divided into the non-isodual branch, isodual branch, and exactness; lift
  questions follow as separate refinements.  The conic interpretation now
  precedes the pencil, whose regular locus and `t -> y -> z` quotient are
  motivated before the formulas.  The verification wall is an auditable table,
  and the twelve coordinate-permutation examples are tabulated.
- 2026-08-27: replaced the conspicuous house vocabulary (`admitted` parameters,
  `logical phase`, `scalar blindness`, `anchor carrier`, and `transport
  sheaf`) with defined standard descriptions, renamed the appendix assignment
  variable from `p` to `eta`, and replaced every hard-coded equation number by
  a semantic label.  Stable theorem labels and mathematical scope are unchanged.
- 2026-08-27: the final authority build is warning-free at 26 pages; every page
  and both figures were inspected; `python3 supplement/verify.py --replay`
  verified 17 artifacts and replayed all eight bundles.  The updated abstract
  is in `papers/summary/README.md`.
- 2026-08-27: authority commit `e7eb05320` exported with zero audit findings to
  paper mirror commit `53e11c6`, exporter content SHA-256
  `7cc303ae48057c428b5a50ff970f1f38ab132c1687cfe73309175ad28182685e`.
  The independently maintained summary was copied byte-for-byte to its mirror
  and committed as `a353307`.  The standalone paper gate and exporter manifest
  verification pass.  Nothing was pushed.
- 2026-08-27: completed a second local decompression pass from referee feedback.
  The introduction now defines the split torus operationally, explains the
  physical meaning of both group branches, distinguishes multiplier inclusion
  from the MDS equality upgrade, separates prior results from the gap, and
  collects the formal imported statements under `Imported inputs`.  The
  six-point preview now translates coding, geometric, and quantum statements
  separately from lift and verification refinements.
- 2026-08-27: Section 3 now states the coherent-phasing question before the
  Weil representation and moves the qutrit uniqueness caveat to a footnote.
  Section 4 keeps only the conceptual atlas recovery of `-1/z`; the complete
  450-value multiplicity and collision bookkeeping is in the invariant-
  certificate appendix.  Section 5 removes party motion from the six-point
  theorem, isolates it in remarks, and states why the operator-pushing count
  does not enlarge the fixed-coordinate logical group.  The Lean paragraph is
  reduced to the formalized, certified, imported, and trusted boundaries;
  repository-specific entry points and toolchain details remain in repository
  documentation.
- 2026-08-27: authority commit `050c02a00` and standalone forward commit
  `255e2ed` pass warning-free 26-page builds, all-page visual inspection, both
  complete eight-bundle evidence replays, zero-finding export audit, and mirror
  manifest verification.  Exporter content SHA-256 is
  `359a93ef9bec350cb74c9c438444562ae06805d26447aaeee909e8a7960a404b`.
  Nothing was pushed, and C979 remains open.
- 2026-08-27: a fresh quantum-information cold reader returned `MINOR`, with
  no correctness blocker, theorem-level overclaim, or structural finding.  The
  local repairs now expose the encoder/state Choi bridge before the central
  block calculation, define the Gale transform at first use, introduce the
  Clebsch syndrome question before changing mathematical languages, and state
  the pencil's field scope exactly in the abstract.  The pass also separates
  compact-witness checking from deterministic recomputation, explains party-
  extension splitting operationally, and repairs four sentence-level points.
- 2026-08-27: the cold-read repairs are committed at authority `bc90ea994` and
  standalone `5573f59`.  Both warning-free 26-page builds, full rendered-page
  inspection, complete eight-bundle evidence replays, zero-finding export
  audit, and mirror manifest verification pass.  Exporter content SHA-256 is
  `ac429dfd687ac451770476708077d48eda124b315aed6dadd124e229b8780f46`.
  Nothing was pushed, and C979 remains open.

## Lifecycle gate

Passing the acceptance gates does not complete C979.  Record validated work
here and in the live handoff, but retain the live queue row until the user gives
an explicit close instruction.
