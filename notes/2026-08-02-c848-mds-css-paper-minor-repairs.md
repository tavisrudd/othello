# C848 — Paper II C847 minor repairs

**Lane:** `ame-lu`
**Status:** local manuscript corrections complete; public companion locator remains a release gate

## Result

The three local defects behind C847's `MINOR` verdict are repaired in
*Diagonal Isoduality and Transversal Clifford Groups of MDS--CSS Codes*.
Paper II now states the exact minimum-support atlas clauses imported from Paper
I before claiming that it uses only the listed companion results.  The pencil
LC converse names that import at both points where it uses support generation
and projection bijectivity.  All six stale or unsupported hard-coded equation
references identified by C847 have been replaced by semantic labels or direct
prose.

The import is an unnumbered, cited paragraph rather than a new theorem-like
label.  It therefore closes the proof boundary without changing theorem
ownership, the frozen cross-paper theorem count, or the internal theorem and
formalization ledgers.

## Changes

- `sections/01-introduction.tex` labels the equal-phase CSS state formula and
  states the imported atlas package: minimum-support projection bijectivity,
  generation of the full label group, and classification by locally
  trace-symplectic transition maps.
- `sections/02-geometry-ame-dictionary.tex` cites the CSS state by its semantic
  label and labels the reduced-state formula.
- `sections/04-pencil-classification.tex` removes the nonexistent `(1.3)`
  reference and replaces the false `(4.2)` and `(4.4)` proof locators with the
  stated atlas import.
- `sections/06-lu-invariants.tex` and
  `sections/10-scalar-certificates.tex` replace the false “operator tensor
  (3.2)” references by the labelled reduced-operator family; the appendix's
  remaining `(2.3)` reference now uses the same semantic label.
- The rebuilt `mds-css-transversal-groups.pdf` contains the repaired text.

## Companion citation boundary

C847 also recorded a release-order gate: replace the Paper I bibliography
entry's internal frozen-tree provenance by a public Paper I locator once that
identity exists.  The monorepo metadata contains no Paper I paper DOI or public
repository URL, the local checkout has no configured origin, and a bounded web
check found no public copy under the paper title.  Creating or pushing a public
repository is outside C848 and was expressly excluded.  The manuscript retains
the honest companion-preprint citation and frozen source-tree identity; the
future release task still owns substitution of the real public locator.  No URL
was invented and the formal-companion DOI was not misrepresented as the paper.

## Validation

- `make check`: passed, including the paper-local evidence check and TeX spacing
  lint.
- XeLaTeX build: warning-free, 22 pages.
- Final log scan: no overfull/underfull boxes, LaTeX/package warnings, undefined
  references, or undefined citations.
- Full 22-page contact sweep: no clipping, overlap, malformed float, or layout
  regression.
- Affected-page inspection: the imported atlas paragraph is legible on page 2;
  the repaired pencil proof reads continuously on pages 7 and 9; the semantic
  reduced-operator references do not disturb the scalar-invariant pages.
- Source scan: no stale `(1.x)` reference remains, and the only remaining
  hard-coded `(3.2)` reference points to the actual diagonal-duality equation.

No Lean source, release manifest, standalone repository, formal repository, or
remote was changed.

## Extra-juice and Tao closeout

The cheap improvement was to use semantic labels and an unnumbered import
paragraph rather than renumbering the broken references or adding a new theorem
environment.  This makes the repaired dependency robust against another
manuscript split and avoids expanding the ownership ledger for a theorem that
still belongs exclusively to Paper I.

The skeptical closeout question was whether stating the atlas import creates a
second proof owner.  It does not: Paper II states exactly the clauses it uses,
cites Paper I, and says their proofs remain there.  The all-length exact-group
theorem remains independent of this atlas paragraph; the import enters only the
six-point pencil LC converse.

## Mystery ledger

- **Settled — hidden atlas premise:** the dependency is now explicit before the
  paper's ownership sentence and at both use sites.
- **Settled — reference fragility:** every C847 stale locator is semantic or
  removed, and the bounded neighboring scan finds no same-shaped residue.
- **Settled — theorem-count drift:** the import is unnumbered, so no new
  theorem-like owner or formal terminal is implied.
- **Open release gate — public Paper I locator:** no such identity currently
  exists in the available metadata or public search.  The release task must
  substitute the eventual real locator; remote creation or publication needs
  separate authorization.

No genuine mathematical mystery remains in the corrected manuscript.

## Acceptance

The local C847 `MINOR` corrections are complete and the manuscript is `GO` for
the separately allocated formal-extraction phase.  Public release remains
gated on the genuine Paper I locator and the already planned release work.
