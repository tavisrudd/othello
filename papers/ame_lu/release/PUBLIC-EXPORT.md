# Public export plan

Status: **local release candidate with two disclosed foreign formal-prose
blockers; no public or account action authorized**

The release has two distributions with different purposes.

## Public scholarly bundle

`release/verify_release.py` packages the manuscript source and rendered PDF,
the formal-statement adequacy ledger, and the complete deterministic evidence
supplement. `release/RELEASE-MANIFEST.json` fixes every included byte and also
fixes the exact Lean toolchain and every project-owned AME--LU module,
import gate, and axiom-audit terminal in the companion repository.
The recursive formal closure contains 80 files, including the Lean
toolchain and Lake/Nix build identities.  Two foreign-owned
dependencies still violate the formal-artifact prose standard:
`RelativeConicArcs/Plane.lean:7` reverse-references another paper directory,
and `FiniteGeom/Code.lean:16` cites an internal handoff and work phase.
The manifest pins both files, but the companion is not referee-prose ready
until their owners remove those references.

From `papers/ame_lu/`, verify and export without overwriting an existing file:

```text
python3 release/verify_release.py
python3 release/verify_release.py --export /path/ame-lu-rc1.tar.gz
```

The archive excludes drafting ledgers, task records, build intermediates,
machine-local state, and other papers. The Lean companion remains in the
repository rather than being duplicated inside the paper archive; its exact
files are bound by the release manifest. Inside a paper-only extraction, the
verifier checks every bundled byte and reports that the formal companion is
recorded but absent. In the companion repository,
`python3 release/verify_release.py --require-formal` checks both trees.

## arXiv source bundle

The arXiv profile contains only `main.tex`, `refs.bib`, and the included
section sources:

```text
python3 release/verify_release.py \
  --profile arxiv --export /path/ame-lu-arxiv-rc1.tar.gz
```

Select XeLaTeX and `main.tex` when checking the uploaded source. Do not upload
the locally generated PDF or build intermediates with TeX source. Inspect
arXiv's generated PDF before submission.

The intended primary category is `quant-ph`; `cs.IT` is a plausible
cross-list because the exact transversal-group specialization is stated for
MDS--CSS codes. Category, license, metadata, and the final submit action
require the author's decision.

## Immutable identity

The manifest identifies content, not a provisional URL. After the author
chooses an archival host, record the public identifier in the manuscript and
regenerate the manifest. A Git commit alone is not represented as an archival
DOI.
