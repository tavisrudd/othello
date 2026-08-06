# C864 — the order-eleven certificate package, resealed against the shared library

**Lane:** `build-sys`

**Date:** 2026-08-06

Phases 3 and 4 of the export-completion execution plan
(`2026-08-06-c864-export-completion-execution-plan.md`) are complete. The order-eleven certificate
package now takes its shared theory from the finitegeom revision it pins, its gate builds green
with an axiom audit free of any literature input, and the monorepo's pin, manifest hash, gate name
and trust-fact copy all name that state.

## What the package now is

It pins finitegeom at `dca9ce75` — the revision whose every declared target builds — in
`lakefile.toml`, in both `rev` and `inputRev` of `lake-manifest.json`, and in its README. The
guarded lock refresh prefetched that revision from the local checkout, so nothing waited on a push.
The resolved dependency checkout carries `RelativeConicArcs/ParametrizedHoles.lean`,
`Q11Residual.lean` and `Q11Coding.lean`, which the gate needs.

Seven modules the package carried only because the shared library lacked them are gone from it, and
the gate is renamed to `RelativeConicArcs.Gates.ClebschRigidityWithOrderElevenCertificates`, which
resolves the module-name collision with the gate the dependency publishes. The manifest seals 115
sources; it gained a `support_files` list covering the axiom audit and the preserved gate log, which
nothing sealed before, and an `authority_commit` field naming the monorepo revision the sources came
from, separate from the package's own `source_commit`. `PROVENANCE.md` records the extraction
revision `0ddbca65` rather than the wrong one it named.

The gate's module header and the README no longer state the ten-point Brianchon bound and the
equality classification as literature input. Both are theorems of the pinned dependency, and the
audit confirms it: all 55 terminals depend on `propext`, `Classical.choice` and `Quot.sound` alone,
with no Dye statement and no native-evaluation axiom. Dye is cited factually as where the classical
statements appear. The README also lost the manuscript-bound "aggregate Paper I gate" phrasing.

## Checkpoints

**Checkpoint 5.** The dependency checkout is at `dca9ce75`, matching both the lakefile and the lake
manifest, and carries the modules the gate needs.

**Checkpoint 6.** The gate builds green against the package root with no module ambiguity. Its
refreshed audit records 55 terminals over the three standard axioms, and stripping Lake's `info:`
prefixes from the preserved elaboration log reproduces the audit byte for byte.

**Checkpoint 7.** The source audit reports zero unexplained drift: 114 sealed sources
byte-identical to the authority revision `0ddbca65`, one absent from it — the gate, which is the
single module this package owns outright — no authority file missing from an owned family, and no
unsealed payload.

**Checkpoint 9.** `lean-certificate-boundary.py --verify-official-libraries` is green, including
the module-collision rule added in phase 2. That rule was red on eight modules before this work and
cleared exactly when the deletions and the rename were sealed, which is the behaviour it was
written for.

## Four defects this phase exposed

**The package's lakefile still rooted the seven deleted modules.** Lake resolves a root into the
package that declares it, so those names no longer reached the dependency and the build failed on
files the cut had removed. This is the same defect as the finitegeom root breakage of phase 2, in a
repository the exporter's standalone gate does not cover: that gate checks candidates the exporter
materializes, and a certificate package is not one.

**One gate terminal named a declaration that no longer exists.** The gate printed
`RelativeConicArcs.SupportOrientationCommutant.oddModule_rationalCommutant_eq_adjoin_B`; both the
authority and the pinned dependency call that theorem `oddModule_rationalCommutant_eq_adjoinGoldenOperator`.
Checking all 55 terminals against the declarations in the package and the dependency found it to be
the only one that resolved nowhere, which is cheaper than one failed build per stale name.

**The source audit crashed on a sealed source the package had deleted.** It read every sealed file
to hash it, so a package part way through a cut — exactly the state in which the audit is worth
running — ended the run on the first missing file and printed none of its other findings. Missing
sealed sources are now reported under their own label, with a test.

**The sealer would have derived the trust fact from a five-line log tail.** It requires the
preserved evidence to equal the log the run records for the gate, and the build queue now records
the output-capturing wrapper's envelope, which quotes only the last few lines of the real stream. A
fact sealed from that envelope would have described whichever terminals happened to print last and
would have said so nowhere. The sealer now follows the envelope to the output file it names, and
refuses an envelope naming a file that is missing. Two tests cover it.

A fifth thing is worth recording because it was deliberately not changed: the package's declared
`terminal` remains `RelativeConicArcs.ClebschDye.isClebschHexagon_of_uncovered_subset_conic`, which
is now proved entirely in the shared library. The gate imports and prints it, so the fact is not
false, but the field names a result this package does not itself establish. Changing what the
external fact asserts is a decision about the trust boundary, not a repair, so it is left as it
stands.

## Revisions

- finitegeom `dca9ce75` — pinned by the package.
- Package `a289097b` — the manifest and trust-fact seal, over sources committed at `82bc5581`,
  extracted from monorepo authority `0ddbca65`.
- Monorepo: the pin, manifest hash, gate name and trust-fact copy updated to match.

## Replay

```sh
python3 lean/scripts/lean-build-queue.py build \
  RelativeConicArcs.Gates.ClebschRigidityWithOrderElevenCertificates \
  --lean-root ~/src/lean/finitegeom-clebsch-q11-certificates --cores 20-23
python3 lean/scripts/lean-package-source-audit.py \
  ~/src/lean/finitegeom-clebsch-q11-certificates \
  --authority 0ddbca65 --finitegeom ~/src/lean/finitegeom
python3 lean/scripts/lean-certificate-boundary.py --verify-official-libraries
python3 lean/scripts/lean-external-fact.py check
cd lean/scripts && python3 -m unittest \
  test_lean_external_fact test_lean_package_source_audit
```
