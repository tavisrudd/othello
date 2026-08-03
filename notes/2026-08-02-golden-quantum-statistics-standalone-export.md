# Golden quantum-statistics standalone and Lean export preparation

**Lane:** `build-sys`

**Status:** paper repository exported and validated; Lean candidate prepared,
with real elaboration intentionally deferred to a quiet build window

## Paper repository

The authoritative source remains
`papers/golden-quantum-statistics/` in Othello.  The deterministic exporter now
maps it to `golden-quantum-statistics`, with `golden-operator` and
`q13-passant-code` recorded as gated rather than silently adopted.

Two independent materializations from source commit
`7eee6069cced17b24b6d6ee29b61354d0ed25b99` were byte-identical.  The selected
tree passed the exporter audit with zero private-reference findings and passed
the paper-local `make check` in isolation.  A separate clean clone of the exact
standalone commit repeated manifest verification and the full 14-page
`make check`.  The selected tree was committed as a fresh local repository:

- path: `/home/tavis/src/math-papers/golden-quantum-statistics`;
- branch: `main`;
- commit: `8929f2cf433355e39f6a2eb60197831463867f52`;
- tag: `golden-quantum-statistics-rigidity-referee-approved`;
- export-manifest SHA-256:
  `58c421fed689d7a4f3ea5159cf35e12551e57b3469d25815b25689ede4cbd0d8`;
- remote: none.

The source package now carries CC BY 4.0 licensing and schema-valid Zenodo
metadata.  The metadata does not yet claim a formal-companion relation because
the Lean candidate below has not passed its release gate.

## Lean candidate

The paper's narrow formal boundary is the existing symbolic module
`RelativeConicArcs.GoldenBalancedCut`.  It proves the signed-triangle square,
cross-Gram determinant `16`, trace contraction `12`, and fourth-word trace
`-42`.  It does not prove the all-orders conference-rigidity classification,
aligned-design statistics, optical compilation, tomography, or experimental
thresholds.

A candidate branch has been prepared without advancing `finitegeom/main`:

- main repository: `/home/tavis/src/lean/finitegeom` at
  `f1d81641827fd037fcbd8363a6f9cd5abf3767cf`;
- candidate worktree:
  `/home/tavis/src/lean/finitegeom-golden-quantum-statistics`;
- branch: `candidate/golden-quantum-statistics`;
- candidate commit: `1b9caa9ca119127a0d96f7760ff2d5663e7756ef`;
- one-module target-manifest SHA-256:
  `e264c54a7be5406387be56dee5cf904abe7041a661e9e9e19ac8f6ca2c9eac74`.

The candidate includes the exact source, Lake root, public trust statement,
axiom-audit entry point, area ledger, source/target manifests, and refreshed
252-module global target manifest.  Source and target bytes agree exactly;
all manifests pass size/hash checks; the scoped trust-spine audit reports zero
findings; and the referee-prose/path scan is clean.  No Lean elaboration or
Lake build was run.

## Deferred quiet-window gate

From the Othello root, after the build-owner preflight confirms a quiet tree:

```sh
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.GoldenBalancedCut \
  --lean-root /home/tavis/src/lean/finitegeom-golden-quantum-statistics \
  --profile single --threads 1 --cores 20-23 \
  --aggregate RelativeConicArcs.GoldenBalancedCut

lean/scripts/guarded-lean \
  --root /home/tavis/src/lean/finitegeom-golden-quantum-statistics \
  trust/GoldenQuantumStatisticsAxiomAudit.lean
```

Compare all four printed axiom sets with
`trust/areas/golden_quantum_statistics.toml`, then repeat the exact target and
axiom audit from a clean checkout of candidate commit `1b9caa9`.  Only after
those checks pass should `finitegeom/main` fast-forward to the candidate and
the paper's Zenodo metadata gain the formal-companion relation.

## C829 refresh preparation

The Clebsch I--III release pattern has four synchronized paper-side surfaces:

1. `FORMAL_COMPANION.json` pins an exact validated public `finitegeom`
   commit, gate, manifest, concept DOI, and honest relationship;
2. the README names that separately distributed companion and its trust
   boundary;
3. `.zenodo.json` uses `isSupplementedBy` only after the pinned commit is
   public and clean-replay-valid; and
4. the paper release gate checks the declaration rather than trusting prose.

Golden quantum statistics does not yet satisfy that pattern.  Its standalone
repository is still the fourteen-page export at `8929f2cf` from Othello
`7eee6069`, whereas the authoritative sixteen-page source and tracked PDF
are now clean at `5219da07`.  The official exporter reports 24 source files,
674,871 bytes, and zero private-reference findings at that commit.  A
disposable official materialization has 27 exported files and its complete
paper-local `make check` passes.  Relative to the live standalone history,
sixteen exported files change and none is added or removed.

The clean-room sequence also exposes one release-output issue that must be
settled in the exporter contract rather than bypassed manually.  The exported
PDF is a content-addressed `release-output`, while `make check` rebuilds the
same path with nonreproducible bytes.  Manifest verification passes before
the build and then correctly refuses the changed
`golden_quantum_statistics.pdf`.  The forward synchronization must use the
same explicit PDF disposition adopted for the Clebsch repositories; it must
not copy the rebuilt disposable output over the mirror.

The existing Lean candidate is an optional partial companion, not a full
formalization of the paper.  Its four terminals cover only:

- the signed-triangle square entries;
- cross-Gram determinant (16);
- trace contraction (12); and
- fourth-word trace (-42).

Thus it supplies scalar mechanisms inside
`thm:general-exchange-rigidity` and `thm:exchange-boundary`.  It supplies
no formal proof of `thm:orbit-boundary`,
`prop:unique-orientation-carrier`, `thm:continuous-control`,
`thm:hermitian-landscape`, `thm:squared-rigidity`, or
`prop:balance-obstruction`; nor does it formalize the aligned-design,
decoder, tomography, compilation, or experimental clauses.  The paper must
describe this as an optional formal companion for the declared symbolic
mechanisms, exactly as Clebsch I--III delimit partial coverage.  It must not
claim that the prose proofs are fully formalized or that a manuscript theorem
depends on Lean.

The original fast-forward instruction is now stale:
`finitegeom/main` and `candidate/golden-quantum-statistics` are one commit
ahead of their common base on opposite sides.  After the current foreign Lean
work releases the build window, refresh the candidate onto current
`finitegeom/main`, regenerate its target/global manifests, update the public
trust statement to the current paper title, and run the recorded target,
axiom, and clean-checkout gates.  Only after that exact candidate is validated
and publicly reachable should the paper gain `FORMAL_COMPANION.json`, the
README companion paragraph, the Zenodo relation, immutable flake pins, and a
paper-local declaration verifier.  The paper mirror then advances through the
portfolio exporter as an ordinary forward commit; no manual copy or history
replacement is permitted.

The remaining work is allocated to the paper's owning lane: C840
`[golden]` owns formal-coverage reconciliation and the refreshed validated
candidate; C841 `[golden]` owns the subsequent paper declaration and
standalone forward promotion.  Build-sys supplies the guarded tools but does
not own either paper task.
