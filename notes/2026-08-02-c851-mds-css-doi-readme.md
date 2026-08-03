# C851 — Paper II DOI badge and PDF README link

**Lane:** `ame-lu`
**Status:** complete; authoritative source and standalone synchronized, unpushed

## Result

The Paper II README now carries the Zenodo DOI badge
`10.5281/zenodo.21766798` and a relative link to the tracked
`mds-css-transversal-groups.pdf`, using the same compact portfolio pattern as
the other released companion-paper READMEs.

The authoritative change landed in Othello commit `c0b7a0bc`.  The selected
immutable exporter plan and audit report one main manuscript, 43 source files,
zero symlinks, and zero private-reference findings.  A disposable 46-file
candidate passed canonical manifest verification.

The verified candidate differed from the existing standalone in exactly the
three expected files: `README.md`, generated `PROVENANCE.md`, and
`export-manifest.json`.  Those bytes were forward-synchronized to
`~/src/math-papers/mds-css-transversal-groups` and committed as
`1057d128172bc43e8dd404ad177c64b10a4de2e8`.

The final standalone manifest SHA-256 is
`52710853d63e13d2e34c10d6d75829065ce368ab1b68f6c1fb049d83d100a137`.
Manifest verification passes, the PDF link target exists, and both working
trees are clean on the owned paths.  The existing GitHub remote was not
contacted and nothing was pushed.

No manuscript theorem, PDF, evidence artifact, Lean source, formal gate,
release manifest, DOI deposit, or submission metadata was changed.
