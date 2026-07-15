# Dye and BSW primary-source audit

**Lane**: `clebsch` — cross-paper citation audit authorized for every paper except the
Baer-equivariant/alternate-orbit extensions and the gems lanes.

**Date**: 2026-07-15

## Source archive

User-supplied page scans and searchable reconstructions are preserved outside git at:

- `/tmp/persistent/tavis/lit-search/dye-1991/`
- `/tmp/persistent/tavis/lit-search/bsw-1992/`
- checksums: `/tmp/persistent/tavis/lit-search/SHA256SUMS`

The reconstructed text is a search aid; mathematical displays and page citations must be checked
against the scans.

## Priority boundary

For the Clebsch six-arc `A` and its associated conic `C` over `F_11`:

- Dye 1991, pp. 270--282, supplies the six-arc/hexagon definition, the ten-Brianchon bound and
  equality classification, projective transitivity, the five self-polar triangles, the associated
  conic and polarity, the `A5` stabilizer, and the q=11 fact that every edge is non-secant to `C`.
- BSW 1992, p. 143, defines a complete exterior set as `(q+1)/2` exterior points whose pair-joins
  are passants. Page 146 reports the q=11 six-arc example and Brouwer's up-to-isomorphism computer
  census, crediting the example itself to Korchmaros.
- Each source therefore gives the classical inclusion `C(F_11) subset U(A)`. Neither states that
  every off-conic point is covered or writes `U(A)=C(F_11)`.
- Dye's exact ten concurrences plus the chord-defect identity give `|U(A)|=22-10=12`. Since the
  conic already contributes twelve uncovered points, equality follows. Describe this as an
  apparently unrecorded short synthesis, not as a theorem of Dye/BSW and not as a mysterious new
  finite configuration.

## Other source facts used in documentation

- BSW's proved theorem concerns `q = 1 mod 4`: every complete exterior set is linear, consisting
  of the exterior points on a passant.
- BSW p. 146 reports exceptional computer examples for `q=7,11,19,23,27,31`, no other examples
  for the tested range `q=43,...,131`, and conjectures none for `q>31`. This is not the fixed-six-arc exact
  conic-filling problem and has no direct implication for the odd-q Nofil conjecture.
- Their q=31 example contains a six-arc and a ten-set: every 2-secant of the six-arc is also a
  2-secant of the ten-set, and the resulting fifteen pairs of ten-set points are the Petersen
  edges. It is a classical related occurrence, not the q=11 support-chirality graph.

## Cross-paper disposition checklist

- [x] `clebsch-hexagon-code`: direct Dye theorem/page citations; BSW definition/census; conceptual
  proof of `U=C`; q31 Petersen distinction; rigidity attribution corrected.
- [x] `arcs_complete_outside_conic`: classical inclusion versus exact synthesis made explicit in
  manuscript, README, and proof audit.
- [x] `nofil-finite-geometry-outcomes`: q11 seed/geometry assigned to Dye/BSW; only the residual-game
  interpretation remains Nofil-owned.
- [x] `papers-index.md` and `papers-planning.md`: historical priority separated from internal
  publication ownership; proof architecture and result rows updated.
- [x] `coding-repair-hypergraphs`, completion/continuation, dihedral, and cubic materials reviewed:
  no relevant claim uses this geometry, so no decorative citation added.
- [x] Excluded by instruction and untouched: Baer-equivariant extension, alternate-orbit repair
  extensions, and all gems/gem-mining materials.
- [ ] BSW 1991 primary text remains unread. Cite it only for adjacent sets-without-tangents context,
  not as evidence for exact covering.
