# C839 — AME--LU two-paper split and extraction plan

**Lane:** `ame-lu`  
**Status:** plan frozen; implementation requires newly allocated manuscript and build-system tasks

## Decision

Split the current 58-page AME--LU bundle into two independently buildable,
independently reviewable papers.

1. **Paper I:** *Local-Unitary Rigidity and Quantitative Rounding for
   Stabilizer AME States*.
2. **Paper II:** *Diagonal Isoduality and Transversal Clifford Groups of
   MDS--CSS Codes*.

Paper I owns the general arbitrary-additive stabilizer-AME theorem package.
Paper II owns the linear MDS--CSS, coding-theoretic, and six-point geometric
specializations.  Paper I must not depend on Paper II.  Paper II may cite the
rigidity and encoder no-go theorems of Paper I.

This is not a deletion plan.  It is a theorem-ownership and release-boundary
split.  Secondary proof routes move to appendices, exact computations move to
Paper II, and operational audit detail moves out of the mathematical body.

## Frozen combined baseline

Before implementation, preserve the current combined state as the final
pre-split baseline.  At the planning checkpoint:

- authoritative monorepo commit: `3400ff6ed6056b0a5ef52512619b30dae3adafa4`;
- public paper tree:
  `2ada0216f5176543f8e7612f38e0cba62e4406bf81a36a6593a55288ea3d98cd`;
- formal-companion tree:
  `b030f559acc08ef110f5a1bbbe29f1b84c19541fab44b191703dcc827d5b4bc9`;
- standalone `ame-lu` commit:
  `a52d7ea7b0da815ae5211614c82a19fc2eed9d14`;
- public `finitegeom` checkpoint:
  `570086982b26075a71a331a81bb1b519e9a27e7f`.

The content-addressed trees, rather than the mutable monorepo commit, are the
authoritative identities of the combined paper and its formal closure.
Implementation must retain a durable record linking both successor papers to
this baseline.  Do not rewrite the existing standalone or `finitegeom` Git
histories.

## Cold-session reading order

A fresh implementation session reads, in order:

1. `AGENTS.md` and the selected lane rules;
2. `notes/handoffs/2026-07-24-ame-lu-paper.md`;
3. this plan in full;
4. `papers/style-guide.md` before manuscript work;
5. only the current paper ledgers needed for the phase being executed;
6. `lean/AGENTS.md` before any Lean source, gate, build, manifest, or public
   formal-extraction work;
7. `notes/2026-07-26-c684-paper-repository-extraction.md` before standalone
   repository extraction;
8. the build-system handoff before changing the public `finitegeom` boundary.

Do not begin by editing the 58-page source in place.  First freeze the baseline
and establish an independently building Paper II root.  Do not edit the
standalone repositories or `~/src/lean/finitegeom` as authorities: manuscript
and Lean changes land in Othello first and propagate one way.

## Repository identities and authority

| Role | Authoritative monorepo root | Downstream standalone |
|---|---|---|
| Paper I | `papers/ame_lu` | `~/src/math-papers/ame-lu` |
| Paper II | `papers/mds_css_transversal_groups` | `~/src/math-papers/mds-css-transversal-groups` |
| Shared Lean source | `lean/RelativeConicArcs/AMELU` and exact gates | `~/src/lean/finitegeom` |

Keep the existing paper ID `ame_lu` and repository name `ame-lu` for Paper I.
Register Paper II as `mds_css_transversal_groups`, with repository name
`mds-css-transversal-groups`.  No TeX input, bibliography symlink, evidence
symlink, or build command may cross the two paper roots.

The `ame-lu` standalone already has public history and advances only by normal
forward commits.  Paper II is a new physical root and may receive a fresh
history through the existing deterministic exporter.  No remote creation,
push, DOI deposit, or publication action is authorized by this plan.

## Theorem ownership

| Result family | Owner | Treatment in the other paper |
|---|---|---|
| Stabilizer-AME support squeeze and full local-label projections | Paper I | cite as input |
| Full-Weyl axis recovery and LU-to-LC rigidity | Paper I | cite the theorem |
| Partial-Weyl recognition and arbitrary-dimension extension | Paper I appendix | omit |
| Minimum-support atlas classification | Paper I | use for six-party holonomies |
| Choi/encoder factorwise Clifford no-go | Paper I | use as the converse in the exact-group theorem |
| Two-uniform discreteness and local stability | Paper I | omit |
| Cleaning-based global rounding | Paper I | omit |
| Collective post-entry estimate | Paper I | omit |
| Robust linear atlas and affine-character obstruction | Paper I | omit |
| Linear MDS--CSS and six-arc dictionary | Paper II | Paper I derives its general encoder corollary directly |
| Diagonal-multiplier line and nullity test | Paper II | omit |
| Exact diagonal-isodual transversal group | Paper II | omit |
| Six-arc self-association and logical phase | Paper II | omit |
| Pencil quotient and prime-field LU classification by `z` | Paper II | omit |
| Extension-field Frobenius-sector divisors | Paper II | omit |
| Clebsch extremal syndrome application | Paper II | omit |
| Fixed-copy generic blindness | Paper II | omit |
| H3 and q=13 scalar separators | Paper II appendices | omit |
| Transport divisor and computed party extensions | Paper II appendices/supplement | omit |

No theorem may be stated as independently proved in both papers.  A shared
definition may be restated locally, but proof ownership and novelty wording
remain unique.  Cross-paper citations name theorem content, not mutable
section or equation numbers.

## Paper I body and appendices

The Paper I body follows this order.

1. Introduction: exact rigidity, quantitative rounding, robust atlas, and the
   encoder corollary, all stated by page two.
2. Stabilizer AME support geometry: Weyl convention, stabilizer marginal
   formula, support squeeze, and coordinate bijections.
3. Exact rigidity and the minimum-support atlas:
   `support squeeze -> full-Weyl marginal -> intrinsic axes -> Clifford
   factors -> atlas classification`.
4. Encoder consequence: the Choi orientation and factorwise transversal
   Clifford no-go.
5. Quantitative global rounding, presenting the strongest route first:
   `8 eps cleaning -> Weyl Fourier rounding -> local Cliffords -> stabilizer
   overlap gap -> exact branch -> collective residual estimate`.
6. Robust symplectic-atlas compatibility and the affine stabilizer-character
   obstruction.
7. Scaling on admissible AME and Reed--Solomon families, followed by a short
   mathematical conclusion.

Paper I appendices contain:

- partial-Weyl recognition, its qubit relation, and arbitrary integer local
  dimension;
- detailed two- and k-uniform stability theory, ceiling, and Reed--Muller
  boundary example;
- the budget-free residual estimate;
- the single-marginal and aggregate alternative rounding routes, explicitly
  labeled as mechanism comparisons rather than competing headlines; and
- the 2-unitary gate corollary if it remains concise.

The compactness threshold and the superseded explicit marginal threshold do
not precede the cleaning theorem.  The body carries only the lemmas actually
needed by the strongest proof.

Expected length: 22--27 pages of body and 32--36 pages including restrained
appendices and references.

## Paper II body and appendices

The Paper II body follows this order.

1. Introduction and a precise imported statement of Paper I's rigidity and
   encoder no-go.
2. MDS--CSS/AME dictionary.
3. Diagonal-multiplier line and the exact nullity-one/nullity-zero criterion.
4. Exact fixed-party projective transversal group:
   `F_q^2 semidirect SL_2(q)` versus `F_q^2 semidirect T`.
5. Six-point self-association and the conic/GRS logical phase.
6. The non-GRS pencil and its degree-eight quotient `z`.
7. Clebsch syndrome geometry as a worked application.
8. Scalar generic blindness as the explanation for why operator-valued
   atlases retain more information.

Paper II appendices contain:

- the H3 marginal separator;
- the q=13 four-copy separator;
- the transport divisor and its exceptional characteristics; and
- the nonabelian factor-set criterion and computed party-extension rows.

The exact finite tables and replay mechanics remain in the supplement.  The
body must not become a census paper: diagonal isoduality is the headline, and
the pencil and computations are applications.

Expected length: 18--22 pages of body and 25--30 pages including appendices
and references.

## Current-source disposition

| Current source | Paper I | Paper II |
|---|---|---|
| `sections/01-introduction.tex` | rewrite around the three Paper I results | write a new introduction |
| `sections/02-geometry-ame-dictionary.tex` | retain the general Weyl/stabilizer part | retain the MDS--CSS/six-arc part with needed local setup |
| `sections/03-lu-rigidity.tex` | retain exact rigidity, atlas, encoder bridge, and quantitative material; reorganize appendices | take the exact MDS--CSS logical-image material only |
| `sections/04-pencil-classification.tex` | remove | body |
| `sections/05-logical-clifford-phase.tex` | remove | body |
| `sections/06-lu-invariants.tex` | remove | body |
| `sections/08-verification-boundary.tex` | replace by a concise Paper I trust statement | rewrite for Paper II and its certificates |
| `sections/07-conclusion.tex` | rewrite around rounding and the affine obstruction | write a coding/geometric conclusion |
| `sections/10-scalar-certificates.tex` | remove | appendix |
| `sections/07-transport-sheaf.tex` | remove | appendix |
| `sections/09-party-extensions.tex` | remove | appendix |
| figure 01, operator holonomy | body | reproduce only if essential to the pencil explanation |
| figure 02, axis recovery | body | omit |
| figure 03, symmetry groups | omit | body |
| figure 04, defect landscape | body | omit |
| figure 05, stability radius | Paper I appendix unless the shorter body needs it | omit |
| figure 06, pencil quotient | omit | body |

Each paper gets a curated bibliography.  Do not share `refs.bib` through a
symlink or a parent-relative include.

## Internal ledgers

Each paper root carries its own internal, non-exported records:

- `theorem-map.md`;
- `claim-proof-novelty-ledger.md`;
- `verification-map.md`;
- `formalization-ledger.md`;
- adversarial proof/evidence audit;
- revision plan; and
- release checklist.

Create one additional internal cross-paper ownership map under the `ame-lu`
lane.  For every current theorem label it records:

- successor paper and label;
- source report;
- conceptual proof location;
- computation/certificate dependency;
- literature audit and allowed novelty wording;
- Lean declaration and paper-facing gate;
- whether the other paper cites it or omits it; and
- the frozen combined-baseline label from which it moved.

The public repositories continue to exclude internal adoption, novelty,
formalization, adversarial-review, and revision ledgers.  Public trust
boundaries live in the manuscript, supplement, release manifest, and
`finitegeom` trust contract.

## Computational evidence boundary

The existing AME--LU evidence package moves to Paper II.  It includes the
holonomy enumeration, H3 separator, q=13 four-copy separator, transport
divisor, and party-extension computations.  Paper II owns the rewritten:

- `supplement/EVIDENCE.md`;
- `supplement/EVIDENCE-MANIFEST.json`;
- `supplement/README.md`;
- `supplement/verify.py`; and
- all eight canonical certificate/generator bundles.

Regenerate the manifest after path changes and replay every bundle.  Preserve
the exact search domains, independent implementations, hashes, and negative
scope statements.  Do not duplicate this package in Paper I.

Paper I's principal results use no computational certificate.  Its
quantitative trust surface must state that the cleaning, Fourier, scaling,
collective, and robust-atlas results are manuscript proofs with no Lean or
certificate coverage beyond the separately named exact and second-moment
cores.

## Lean source and public formal extraction

Keep the mathematical source namespace `RelativeConicArcs.AMELU`.  Create two
paper-facing gates with semantic, paper-independent names:

- `RelativeConicArcs.Gates.AMEStabilizerRigidity` and
  `RelativeConicArcs.Gates.AMEStabilizerRigidityAxioms`;
- `RelativeConicArcs.Gates.MDSCSSTransversalGeometry` and
  `RelativeConicArcs.Gates.MDSCSSTransversalGeometryAxioms`.

Paper I's gate covers the support squeeze, full-Weyl rigidity, atlas,
holonomy centralizer, Choi/encoder conversion, and the formally available
multipartite second-moment core.  It must not imply that cleaning-based
rounding, its constants, or robust affine compatibility are formalized.

Paper II's gate covers the MDS--CSS dictionary, diagonal isoduality, exact
carrier, pencil and extension-field algebra, syndrome geometry, marginal and
four-copy interfaces, transport algebra, and abstract party-extension
splitting.

Review `EncoderTransversal.lean` during the split.  It currently combines the
Choi conversion used by Paper I with exact carrier results owned by Paper II.
If a narrow Paper I import still pulls the whole companion closure, split the
module by mathematical responsibility before defining the gates.  Do not use
a filename glob as a substitute for a reviewed import boundary.

In `~/src/lean/finitegeom`:

1. preserve the existing combined `ame_lu` source/target manifests as the
   legacy combined baseline;
2. add two area contracts and two source/target manifests;
3. update `trust/portfolio.toml`, reviewer prose, terminal ledgers, axiom
   audits, `TARGET_MANIFEST.json`, `SOURCE_MANIFEST.json`, `PROVENANCE.md`,
   README, and citation metadata;
4. retain the same version-independent `finitegeom` concept DOI;
5. validate both new gates and their exact terminal axiom sets in a coordinated
   quiet Lean window; and
6. land only forward commits.

The `ame-lu` lane owns manuscript theorem/trust decisions and the monorepo
Lean source paths allowed by its handoff.  The `build-sys` lane owns the
public `finitegeom` materialization, content-addressed public manifests, and
extraction machinery.  Coordinate them through separately allocated tasks;
do not edit the downstream repository as the source of truth.

## Release-verifier correction

The current `papers/ame_lu/release/verify_release.py` computes the formal
closure by globbing all `RelativeConicArcs/AMELU/*.lean` and all
`Gates/AMELU*.lean`.  That becomes false after the split: it would make each
paper appear to depend on the entire shared namespace.

Each paper must instead carry a small formal-root contract, for example:

```json
{
  "roots": [
    "RelativeConicArcs.Gates.AMEStabilizerRigidity",
    "RelativeConicArcs.Gates.AMEStabilizerRigidityAxioms"
  ]
}
```

The release verifier computes the recursive import closure from exactly those
roots.  Paper II uses its two companion roots.  The contract, public source
tree, formal closure, toolchain, and build definitions receive separate tree
hashes.  A paper-only standalone verifies the recorded formal closure as
absent; strict mode requires and verifies the separately distributed formal
repository.

## Registries, standalone extraction, and metadata

Update these surfaces in one coordinated migration:

- `lean/trust/papers.toml`: retain `ame_lu`, add
  `mds_css_transversal_groups`;
- `papers/repositories.toml`: retain `ame-lu`, add
  `mds-css-transversal-groups` with explicit internal-ledger exclusions;
- the paper-facts registry and extracted fact records;
- generated paper index, work-summary, results-snapshot, and title-restatement
  regions;
- each paper's `README.md`, `Makefile`, release verifier, release manifest,
  `.zenodo.json`, license, and citation metadata;
- Paper I's existing standalone by forward synchronization; and
- Paper II's new standalone through deterministic exporter materialization,
  audit, clean-room validation, and first commit.

Both papers identify Tavis Rudd and retain CC BY 4.0.  Both may relate to the
same `finitegeom` concept DOI using `isSupplementedBy`.  They have different
paper titles, descriptions, keywords, release identifiers, eventual paper
DOIs, and source/public tree hashes.  Paper DOI, version, and deposit date stay
unset until publication.  Add the cross-paper bibliographic relation only
after a stable public identifier exists; do not leave a circular placeholder
as proof authority.

The existing deterministic paper exporter can handle the split without a
new copying model because the result has two physical roots.  Its registry,
mapping, private-reference audit, exact tracked-file inventory, manifest
verification, and no-overwrite rules remain mandatory.  No remote action is
part of manuscript synchronization.

## Implementation order and acceptance gates

### Phase A — freeze and map

1. Record the frozen combined identities above in the lane report and both
   successor provenance records.
2. Add the Paper II paper-registry and repository-map rows.
3. Add a cross-paper theorem-ownership ledger.
4. Produce exporter `plan` and `audit` results without materializing a new
   standalone.

Acceptance: every current theorem, figure, evidence file, and formal terminal
has exactly one owner; no source has been removed from Paper I yet.

### Phase B — establish Paper II

1. Create the new monorepo root from the frozen source bytes.
2. Make its TeX, bibliography, figures, evidence, metadata, and build
   self-contained.
3. Rewrite its abstract and introduction around diagonal isoduality.
4. Replay all computational evidence and build a warning-free PDF.

Acceptance: Paper II builds and verifies independently; its main theorem does
not depend on any unpublished statement except the explicitly cited Paper I
rigidity theorem, for which a stable local preprint record exists.

### Phase C — sharpen Paper I

1. Remove the now-owned Paper II material.
2. Reorder the exact and approximate proof spines.
3. Move secondary quantitative routes to appendices.
4. Rewrite abstract, introduction, conclusion, trust statement, title, and
   metadata.

Acceptance: a theorem-only cold read finds exact rigidity and quantitative
rounding by page two, can state the proof mechanism, and identifies the affine
character as the remaining obstruction.  Target 32--36 total pages.

### Phase D — split formal boundaries

1. Create the two semantic gates and terminal audits.
2. Refactor mixed modules only where needed to keep closures honest.
3. Generate paper-specific formal-root contracts.
4. Run the guarded gate and axiom audits in a build-system-owned quiet window.

Acceptance: each paper release manifest contains only its declared recursive
formal closure; quantitative manuscript-only claims are not mislabeled as
kernel checked; no project-local axiom or hidden certificate premise appears.

### Phase E — release and standalone synchronization

For each paper independently:

- run the warning-free clean build;
- inspect the PDF and figures;
- reconcile theorem, novelty, verification, and formalization ledgers;
- check bibliography and cross-paper citations;
- verify the public release manifest;
- verify strict formal mode against the exact formal repository state;
- audit the deterministic export plan;
- validate a clean checkout of the standalone candidate; and
- commit the downstream repository forward without pushing.

Paper II additionally replays every certificate bundle.  Paper I additionally
receives a fresh cold read focused on theorem hierarchy and the prior-art
boundary.

Acceptance: both standalone repositories are clean, independently buildable,
content addressed, free of private paths and task IDs, and related to the exact
formal companion without claiming the other's evidence.

## Rollback and failure rules

- The frozen combined baseline remains recoverable throughout.
- Do not trim Paper I until Paper II independently builds and owns every moved
  theorem and artifact.
- Do not update either standalone until its monorepo source and release
  manifest are final for that phase.
- Do not overwrite the combined formal manifest; add successor manifests.
- If a proposed narrow Lean gate still imports most of the combined closure,
  repair the semantic module boundary rather than accepting a misleading
  manifest.
- If Paper II cannot state a strong independent abstract centered on diagonal
  isoduality, stop before extraction; do not publish an applications dump.
- Never broaden this plan into remote creation, push, DOI deposit, or
  submission without explicit user authorization.

## Strength assessment

The split changes presentation, not mathematical novelty.  Paper I becomes the
flagship: one universal exact theorem, one quantitative theorem, one complete
structural invariant, and one precise obstruction.  Paper II remains an
independent exact-group paper: diagonal isoduality is an all-length iff
classification, while the pencil, Clebsch, and scalar calculations demonstrate
its reach.

The current bundle has stronger content than its hierarchy communicates.
After the split, Paper I should be materially stronger in perceived theorem
force and Paper II should be stronger than the corresponding middle third of
the bundle because its exact group theorem becomes the organizing result.
The division is not salami slicing: the state class, principal theorem, proof
mechanism, evidence type, and likely readership differ, and the dependency is
strictly one way.

## First implementation step

Implementation is intentionally not allocated by this planning task.  The
highest-value next move is an `ame-lu` manuscript task covering Phase A and
Phase B only: freeze the combined identities, create the ownership ledger,
establish the self-contained Paper II monorepo root, and stop once its build
and evidence replay pass.  Allocate the separate `build-sys` formal/extraction
task only after those manuscript roots and theorem ownership are stable.

