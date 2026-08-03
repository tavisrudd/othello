# C850 — MDS--CSS companion standalone export

**Lane:** `ame-lu`
**Status:** complete; local standalone validated and committed, no remote

## Result

The new companion paper now has a deterministic standalone repository at
`~/src/math-papers/mds-css-transversal-groups`.

The repository was exported from immutable Othello source commit
`b00ef32703db861d6bd4c80ba249bbbc0c09a08c`.  Its clean local `main` commit is
`15a9bf307ff12c863a91b00b2997b8f5af16d724`, and its canonical
`export-manifest.json` has SHA-256
`da001459a9f6e4e846af8a642e75f5a3c42eaa62a89e2da2e79ccb6cfe5172fd`.
No remote is configured and nothing was pushed.

## Boundary repairs exposed by clean export

The exporter refused the first materialization because the paper root's split
history used the reserved generated filename `PROVENANCE.md`.  The source record
is now `SPLIT-PROVENANCE.md`; the exporter owns the standalone
`PROVENANCE.md`.  Both records are retained publicly, with distinct jobs.

The first disposable clean-room build then exposed a parent-relative Makefile
dependency on `papers/scripts/lint_tex_spacing.py`.  Paper II now carries the
small linter at `scripts/lint_tex_spacing.py`, and its Makefile uses only that
paper-local path.  The README's monorepo-authority wording was also made neutral
so the same tracked source is accurate in both the authoritative tree and the
standalone.

These repairs landed in Othello before export as ordinary commits:

- `b5d7a4df` — separate split provenance from generated export provenance;
- `07e195d0` — make the README standalone-neutral;
- `b00ef327` — make the TeX lint gate self-contained.

## Deterministic materialization

At source commit `b00ef327` the selected exporter plan reports:

- repository: `mds-css-transversal-groups`;
- disposition: active;
- one main manuscript;
- 43 immutable source files;
- zero excluded symlinks; and
- zero private-reference findings.

All 20 hermetic exporter tests pass.  Two independently materialized disposable
candidates contain 46 tracked standalone files each, pass manifest verification,
and are byte-for-byte identical.  The three generated/export-owned files are
`.gitignore`, `PROVENANCE.md`, and `export-manifest.json`; the source payload
includes the tracked PDF, CC BY 4.0 license, Zenodo metadata, split provenance,
TeX source, bibliography, figures, self-contained build entry point, and the
complete 17-artifact evidence package.

## Validation

The disposable candidate passed:

- canonical manifest path/mode/size/SHA verification;
- `make check` from outside Othello;
- warning-free XeLaTeX/BibTeX build of the 22-page paper; and
- the complete `python3 supplement/verify.py --replay` evidence replay.

The exact candidate was committed as disposable root commit `15a9bf3` and
cloned separately.  That clean-room clone passed:

- manifest verification against the exact committed tree;
- forced `make -B check`;
- the complete evidence replay;
- post-build manifest verification; and
- post-build Git cleanliness, including byte-identical regeneration of the
  tracked PDF.

The already validated candidate repository was then promoted without rewriting
its history to `~/src/math-papers/mds-css-transversal-groups`.  Final destination
verification reports the same 46 tracked files, source commit, manifest hash,
and clean Git state.

## Scope

This task created no GitHub repository, remote, push, release, tag, DOI deposit,
or submission.  It did not change Lean, `finitegeom`, formal gates, or release
manifests.  The planned semantic formal-extraction split, strict formal release
contract, and genuine public Paper I citation locator remain separate gates.

## Extra-juice and Tao closeout

The useful extra result is that the standalone is genuinely self-contained,
not merely audit-clean.  Materialization's reserved-name refusal and the first
external build caught two independent coupling modes that the read-only text
audit did not: collision with exporter-owned provenance and an executable
parent-relative build dependency.  Repairing both in the authoritative source
means every future export inherits the correction.

The skeptical release question is whether a successful manuscript build could
mask missing evidence.  It cannot here: the evidence verifier checked all 17
artifacts, and its replay mode regenerated all eight canonical bundles in both
the disposable candidate and the separate clean-room clone.

The build-system lane may cheaply strengthen its future audit by recognizing
reserved generated filenames and parent-relative executable dependencies at
the read-only plan stage.  That tooling change is cross-lane and was not made by
C850.

## Mystery ledger

- **Settled — provenance collision:** split history and generated export
  provenance now have distinct stable filenames.
- **Settled — hidden parent dependency:** the linter is paper-local and the
  clean-room build uses no Othello file.
- **Settled — deterministic export:** two materializations are byte-identical,
  and the committed clean-room clone reproduces the tracked PDF exactly.
- **Settled — evidence portability:** every canonical replay passes in the
  isolated clone.
- **Open release gates:** public remote creation/push, Paper I's genuine public
  locator, and the semantic formal companion split remain separately owned and
  require their existing authorization and validation gates.

No genuine extraction mystery remains.

## Acceptance

The requested local standalone export is complete and `local-ready`.  It is not
claimed `remote-ready` or published.
