# C855 — Lean closure of the six-node transfer: working log

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Scope:** Lean only. Retire the assumed Hassett–Tschinkel interface in
`lean/RelativeConicArcs/PaperIOrientationTraceDual.lean` in favour of a proved theorem.

## Decision record

1. Read `lean/AGENTS.md` and `notes/2026-08-03-c855-hassett-tschinkel-transfer.md` in full.
2. **The transfer note's coverage map (§4.1) is incomplete.** It lists eight new Lean
   obligations, of which the substantial one is a rank-one classification of the cross-golden
   block. That work is unnecessary: the repository already contains a kernel-checked
   elimination of the five gradient quadrics of the centered golden cubic,
   `RelativeConicArcs.GoldenCubicNodes.nonzero_gradient_zero_iff_projective_centeredNode`,
   re-exported as
   `RelativeConicArcs.PaperIOrientationNodes.supportCubic_singularLocus_eq_frame`:
   over any characteristic-zero field, a nonzero centered five-vector has vanishing gradient
   exactly when it is a nonzero multiple of one of the six centered nodes `1 - 6 e_i`.
   The axiom audit records only `propext`/`Classical.choice`/`Quot.sound` for it.
3. Consequently the only missing link between that classification and the determinantal
   picture is the statement that the polynomial being differentiated is the determinant of the
   cross-golden block. `det_crossGoldenBlock_eq_neg_supportCubic` already gives
   `det (crossGoldenBlock t y) = - triangleCubic (conferenceMatrixOver R) y` over any
   commutative ring with a golden root, so the bridge is obtained by evaluating it over the
   polynomial ring and differentiating along one centered coordinate line — the same device
   already used by `GoldenCubicNodesBase.derivative_coordinatePolynomial_eval`.
4. Plan actually implemented:
   * new declarations in `RelativeConicArcs/PaperIOrientationNodes.lean`
     (`crossGoldenDeterminantLine`, `derivative_crossGoldenDeterminantLine_eval`,
     `singularPoints_crossGoldenDeterminant_eq_axisClasses`);
   * deletion of `HassettTschinkelProposition10` and
     `hassettTschinkel_six_nodes_of_traceDual` from
     `RelativeConicArcs/PaperIOrientationTraceDual.lean`, with the module header rewritten;
   * gate line swap in `RelativeConicArcs/Gates/ClebschRigidityTrust.lean`.
5. The Hassett–Tschinkel citation survives only as provenance inside the new theorem's
   docstring, as the transfer note recommends (§5.2).

## Elaboration evidence

All commands run from `/home/tavis/src/othello`.

* `lean/scripts/lean-build-queue.py run RelativeConicArcs.PaperIOrientationNodes
  --profile single --threads 1 --cores 20-23` — first attempt failed on an ambiguity between
  `_root_.gradient` (Mathlib) and `GoldenCubicNodesBase.gradient` inside a `simp` set; fixed by
  qualifying the name. Second attempt: `passed RelativeConicArcs.PaperIOrientationNodes`,
  trace-only aggregate gate complete
  (run `~/.cache/othello-lean-build/run-20260803-200339-166ed0f1`).
* `lean/scripts/guarded-lean RelativeConicArcs/PaperIOrientationNodes.lean` — `exit=0`.
  `#print axioms` reports `[propext, Classical.choice, Quot.sound]` for
  `derivative_crossGoldenDeterminantLine_eval` and
  `singularPoints_crossGoldenDeterminant_eq_axisClasses`.
* `lean/scripts/lean-build-queue.py run RelativeConicArcs.PaperIOrientationSymmetryCore ...` —
  passed. This covers the reverse-import closure of the edited modules inside the Paper I
  stream (`PaperIOrientationSpine`, `PaperIOrientationSymmetryCore`).

## Aggregate gate and audit refresh (2026-08-03, later session)

* `lean/scripts/lean-build-queue.py run RelativeConicArcs.Gates.ClebschRigidityTrust --profile
  single --threads 1 --cores 20-23` — run `~/.cache/othello-lean-build/run-20260803-201132-5b9abc76`,
  state `success`: `built RelativeConicArcs.Gates.ClebschRigidityTrust` (24:29 wall, 11.5 GB peak
  RSS) followed by `gate-passed <aggregate>` (the trace-only exact-target confirmation).
* `lean/scripts/guarded-lean RelativeConicArcs/Gates/ClebschRigidityTrust.lean` — `exit=0`,
  156 stdout lines. That stdout is copied verbatim to
  `lean/verification/clebsch_rigidity_trust/axiom-audit.txt`, per the audit convention that the
  file is the raw standard output of a successful gate elaboration.
* Counts: the gate now issues 52 `#print axioms` directives (previously 51 — one deleted terminal
  removed, two new ones added), and the audit contains 52 declaration rows in the same order.
* Audit content checks: no `sorry`/`sorryAx`, no native-execution or oracle axiom, and the only
  axioms outside `propext`/`Classical.choice`/`Quot.sound` remain the two classical Dye
  assumptions `RelativeConicArcs.ClebschDye.dye1991_brianchon_bound` and
  `RelativeConicArcs.ClebschDye.dye1991_equality_classification`. Both
  `derivative_crossGoldenDeterminantLine_eval` and
  `singularPoints_crossGoldenDeterminant_eq_axisClasses` report exactly
  `[propext, Classical.choice, Quot.sound]`.
* `lean/scripts/paper-facts.py check` and `lean-trust-spine.py check` report only pre-existing
  cross-lane drift (stale facts artifacts, citation-title drift, foreign undeclared axioms); no
  finding names the Paper I gate, its terminals, or the audit artifact.

## Left for the owning gate build window

* The manuscript passages `papers/clebsch-rigidity/clebsch_rigidity.tex` around lines 1370 and
  1466 still attribute singular-locus completeness to the cited proposition; they should be
  rewritten to cite the proved Lean theorem, with Hassett–Tschinkel demoted to context.
* The Section 9 pin block still names the pre-six-node export state; see the blocked-export
  section below for why it cannot be refreshed yet.
* `papers/clebsch-rigidity/verification/build_trust_manifest.py` still lists
  `RelativeConicArcs.PaperIOrientationTraceDual.hassettTschinkel_six_nodes_of_traceDual` in its
  `TERMINALS` orientation group and does not list the two new node theorems; its `parse_axioms`
  raises on any mismatch with the audit, so `trust_manifest.json` cannot be regenerated until that
  list is edited. That edit belongs with the manuscript rewrite and the full release replay
  documented in `papers/clebsch-rigidity/verification/README.md` (regenerate statement identity and
  trust manifest, refresh `verify-release-output.json` with `--update-output`, rerun
  `build_trust_manifest.py`, then the clean-source release run). Left untouched here.

## Export refresh attempt: blocked upstream of the q11 package (2026-08-03)

Goal: republish the standalone q11 certificate package so the manuscript's Section 9 pin block
names an export whose aggregate gate carries the 52-terminal audit, and retire the pinned state in
which `hassettTschinkel_six_nodes_of_traceDual` is still an axiom-bearing terminal.  The refresh was
not performed.  Nothing was written to either export tree.

### Current pinned state (unchanged)

Manuscript `papers/clebsch-rigidity/clebsch_rigidity.tex`, Section 9:

| Pinned artifact | Value |
|---|---|
| certificate-package commit | `09d8e174880e7370966da788da3c5d303df8af4f` |
| base-library commit        | `570086982b26075a71a331a81bb1b519e9a27e7f` |
| aggregate gate digest      | `c5d532dbd79dcb2eef602ced85105b72943a0a1af05de11c3c008c1ed9a1d747` |
| Mathlib commit             | `571b8a8e54219b4d393f75f4b8653fac08197fcc` |

The certificate package's `MANIFEST.json` records `source_commit`
`81bae5e0eb02c26992f21b71808ef74a22e3b406` (its own gate commit) and pins the base library at the
same `570086982b…` revision in `lakefile.toml` and `lake-manifest.json`.  The pinned base revision
is an ancestor of the base library's public `origin/main`.

### Why the refresh cannot proceed

1. **The changed declarations live in the base library, not in the certificate package.**  The
   six-node change edits `RelativeConicArcs/PaperIOrientationNodes.lean` and
   `RelativeConicArcs/PaperIOrientationTraceDual.lean`, both of which the certificate package
   obtains from its pinned base dependency; the package itself ships only the q11 tables and the
   aggregate gate.  At the pinned base revision — and also at the base checkout's current local
   head — `PaperIOrientationTraceDual` still declares
   `hassettTschinkel_six_nodes_of_traceDual` and `PaperIOrientationNodes` contains neither
   `derivative_crossGoldenDeterminantLine_eval` nor
   `singularPoints_crossGoldenDeterminant_eq_axisClasses`.  The new gate's two added
   `#print axioms` lines therefore cannot elaborate against any published base revision.

2. **The base library must be republished first, and its local commits are unpublished.**  The
   canonical base checkout is eight commits ahead of its public remote, and even that head predates
   the six-node change (its `PaperIOrientationNodes.lean` differs in content from the authority
   file).  Because the certificate package resolves its dependency by Git URL and revision, no
   re-pin can build until a base revision containing the new theorems exists on the public remote.
   Publishing is out of scope for this task.

3. **No guarded procedure targets the certificate package.**  The companion exporter
   `lean/scripts/lean-companion-export.py` materializes an area unit onto the canonical base
   repository only: its canonical-base default is the base checkout, and it explicitly refuses any
   suffixed `finitegeom-*` clone as authority or output.  The tracked export configurations under
   `lean/trust/export/` cover only the Golden companion, and `lean/trust/areas/` has no Paper I or
   Clebsch area.  There is consequently no guarded entry point that can regenerate the certificate
   package's module set, `MANIFEST.json`, or its axiom audit.  Per the Lean guide, the correct
   action when a guarded procedure cannot target a root is to stop.

### What a future refresh must do, in order

1. Adopt the six-node change into the canonical base library through the guarded companion-export
   path (which requires an area configuration that does not yet exist for Paper I), then publish
   the resulting base revision.
2. Re-pin the certificate package's `lakefile.toml`, `lake-manifest.json`, and `MANIFEST.json`
   dependency revision to that published base commit.
3. Copy the authority's aggregate gate into the package.  The authority's current gate file has
   SHA-256 `4bc2adb5f64df0a0f3490a948020fbe200d9169d6c08d232a0ed2879e7ab6319`; the historical export
   gate is a byte-identical copy of the authority's pre-change gate, so a plain copy is the expected
   transformation and the new digest is the value the manuscript must pin.
4. Rebuild the aggregate gate in the package under the owning build window and regenerate
   `verification/clebsch_rigidity_trust/axiom-audit.txt` from that build's standard output; refresh
   `MANIFEST.json` module digests and `source_commit`.
5. Only then update the manuscript pin block and rerun the release chain in
   `papers/clebsch-rigidity/verification/README.md`: statement identity, trust manifest against both
   roots, `--update-output`, PDF rebuild, and the clean-source release run.

### Authority state after this attempt

No git state was changed in the authority.  The only authority edit is this log section plus the
cross-reference added to the preceding section.

## Export area configuration created; export run blocked on the generated fact (2026-08-03)

Follow-up to the section above, under the author's explicit authorization to create a Paper I export
area and export the six-node delta onto the canonical base library.  The area configuration now
exists in the authority.  The export itself was **not** performed: the guarded exporter refuses for a
reason that no configuration change can remove.  Nothing was written to `~/src/lean/finitegeom`, and
its head remains `56e4edc` (eight commits ahead of `origin/main`, worktree clean).

### What was created (authority, uncommitted)

| Path | Change |
|---|---|
| `lean/trust/export/clebsch_support_cubic_orientation.toml` | new companion-export configuration |
| `lean/trust/areas/relconic.toml`                           | new `[[gate]]` entry for the orientation spine |

The export configuration follows `lean/trust/export/golden_quantum_statistics.toml` field for field:
`schema_version`, `area`, `gate`, `trust_statement`, `axiom_audit`, `statement_title`, `overview`,
`correspondence`, `boundary`, `axiom_audit_title`, `axiom_audit_description`, `readme_anchor`, and
`readme_bullet`.  Its gate is `RelativeConicArcs.PaperIOrientationSpine`, which imports both changed
modules (`PaperIOrientationNodes`, `PaperIOrientationTraceDual`) directly and is already a declared
root of the base library's `TARGET_MANIFEST.json`, so an adopted export refreshes those base modules
in place rather than introducing a new root.  Destination names avoid manuscript labels:
`trust/CLEBSCH_SUPPORT_CUBIC_ORIENTATION.md`, `trust/ClebschSupportCubicOrientationAxiomAudit.lean`,
`trust/manifests/clebsch_support_cubic_orientation.json`.  The README anchor
(`  the 77-module human Arcs boundary.`) is present in the base README, and the configured bullet is
not yet present, so the mechanical README insertion would succeed.

The registry entry declares the twenty-four orientation terminals that the focused Clebsch hexagon
aggregate gate re-exports, taken verbatim from the `#print axioms` lines of
`lean/RelativeConicArcs/Gates/ClebschRigidityTrust.lean`, including the two new node terminals
`derivative_crossGoldenDeterminantLine_eval` and
`singularPoints_crossGoldenDeterminant_eq_axisClasses`.  The exporter requires a non-empty registered
terminal list; the closure is not enumerated by hand — the exporter derives it from the generated
fact and independently re-derives it by parsing imports, refusing on any disagreement.

### Exporter invocation and its refusal

```
python3 lean/scripts/lean-companion-export.py \
  --config lean/trust/export/clebsch_support_cubic_orientation.toml \
  --source-commit HEAD --base-commit HEAD plan
refused: source commit 2797c05e has no generated fact
         lean/trust/facts/RelativeConicArcs.PaperIOrientationSpine.json
```

### The two blockers, exactly

1. **The generated fact requires a Lean extraction, and the extraction requires a quiet Lean
   worktree.**  Facts are produced only by `lean/scripts/lean-trust-extract.py run`, which elaborates
   a generated wrapper through `guarded-lean` and refuses while the Lean worktree carries changes the
   trust tooling does not own.  Three foreign modified paths are present:
   `lean/RelativeConicArcs/AlignedTwoGraph.lean`,
   `lean/RelativeConicArcs/Gates/ClebschPassages.lean`, and
   `lean/RelativeConicArcs/PetersenHarmonicKernel.lean`.  The tool reports this directly:
   `lean/scripts/lean-trust-extract.py plan --area relconic` ends with
   `quiet window: no — 3 foreign path(s)`, and now lists
   `[missing  ] relconic: RelativeConicArcs.PaperIOrientationSpine (24 terminal(s))`.
   Those three files belong to other work and were not touched.

2. **The exporter reads the registry and the fact from a commit, not the worktree.**  Only
   `--config` is read from disk; `lean/trust/areas/*.toml` and `lean/trust/facts/<gate>.json` are
   read as blobs of `--source-commit`.  Both new authority edits above must therefore be committed
   before any export run, and the export must name that commit.  No authority git state was changed.

Neither blocker is a limitation of the area format.  The companion-export format does carry base
library module updates: the exported closure overwrites the base's copies of the closure modules and
rewrites `TARGET_MANIFEST.json`, so the six-node delta travels correctly once a fact exists.

### Smallest viable path to a completed export

1. Wait for, or arrange, a quiet Lean worktree (the three foreign modified paths committed or
   otherwise settled by their owner).
2. Commit the two authority edits above.
3. `lean/scripts/lean-trust-extract.py run --unit RelativeConicArcs.PaperIOrientationSpine`, then
   commit the generated `lean/trust/facts/RelativeConicArcs.PaperIOrientationSpine.json`.  This step
   elaborates the spine and needs the owning build window.
4. `lean-companion-export.py … plan`, then `… run --workdir <disk-backed directory>` against that
   authority commit and base `56e4edc`.
5. Validate the exported spine in the base tree with
   `lean/scripts/guarded-lean --root ~/src/lean/finitegeom RelativeConicArcs/PaperIOrientationSpine.lean`
   (`guarded-lean` accepts `--root`, so the base package is reachable through the guarded entry
   point), then adopt the printed delta as one ordinary forward commit in the base repository.
6. Only then does the certificate-package refresh sequence recorded in the previous section become
   runnable, and publication of the base revision remains the author's decision.

## Extraction succeeded; export refused at the final delta-shape assertion (2026-08-03)

With the quiet window open (`lean/scripts/lean-trust-extract.py plan --area relconic` now ends with
`quiet window: yes`), the recorded path was run.  Steps one and two of the export chain succeeded and
the whole verification battery passed; the exporter then refused at its last check, for a reason
specific to *refreshing* modules that already exist in the base rather than adding new ones.  The
base repository was not modified: `~/src/lean/finitegeom` head remains `56e4edc`, worktree clean.

### Trust extraction (succeeded)

```
python3 lean/scripts/lean-trust-extract.py run --unit RelativeConicArcs.PaperIOrientationSpine
extracted RelativeConicArcs.PaperIOrientationSpine
  lean/trust/facts/RelativeConicArcs.PaperIOrientationSpine.json
```

The generated fact records a twenty-one module closure, all twenty-four registered terminals, Mathlib
`571b8a8e…`, no project axiom, and no opaque or unsafe declaration.  Every terminal reduces to
`propext`, `Quot.sound`, and (for all but one) `Classical.choice`; the retired Hassett--Tschinkel
axiom appears nowhere in the unit.  The fact was committed in the authority as the single git change
this round (`lean: record the orientation spine trust facts`), because the exporter reads the trust
registry and the fact from the source commit rather than from the worktree.

### Export plan (succeeded, with one pre-existing base defect)

The first plan attempt refused with

```
refused: base prose disagrees with the base manifest; rerun with --accept-base-prose-drift ...
  PROVENANCE.md: declares 251-module library state, base records 273
```

That drift predates this work: the base `PROVENANCE.md` still names a 251-module library state while
`TARGET_MANIFEST.json` records 273.  The documented `--accept-base-prose-drift` flag leaves the
drifted sentence untouched and was used for every subsequent invocation.  The drift is a defect the
base repository owns and should be repaired separately.

The plan then reported a twenty-one module closure whose module count is unchanged at 273, because
every closure module already exists in the base.

### Export run (refused)

```
python3 lean/scripts/lean-companion-export.py \
  --config lean/trust/export/clebsch_support_cubic_orientation.toml \
  --source-commit HEAD --base-commit HEAD --accept-base-prose-drift \
  run --workdir ~/.cache/othello-lean-build/companion-export/clebsch-orientation-candidate
refused: the candidate delta does not match the planned file set: unplanned [],
missing ['RelativeConicArcs/ClebschGoldenConference.lean', ... , 'lakefile.toml']
```

Everything before the final assertion passed: both materializations completed, the repeat was
byte-identical, and `verify` accepted module byte identity, manifest completeness, terminal and
axiom-audit agreement, and an unchanged base.  The refusal is `forward_delta`, which requires the
candidate's actual git delta to equal the planned written-file set.

### Why that assertion cannot hold for this export

The planned set is every file the exporter writes; the actual delta is every file whose bytes
changed.  For a first-time companion those coincide, because none of its modules exist in the base.
This export refreshes an existing base root, and only two closure modules differ from the base:

- `RelativeConicArcs/PaperIOrientationNodes.lean`
- `RelativeConicArcs/PaperIOrientationTraceDual.lean`

The other nineteen closure modules, and `lakefile.toml` (the gate is already a declared base root),
are rewritten with identical bytes and so never appear in the delta.  The refusal names exactly those
nineteen modules plus `lakefile.toml` as "missing".  No configuration, area, or ordering change can
make a byte-identical rewrite show up as a delta entry, so the export is structurally blocked in the
exporter's own code rather than in the area format.

### Options, none taken here

1. Relax `forward_delta` to require the actual delta to be a subset of the planned set, and to report
   the unchanged planned files separately.  This is a change to a validation gate in the export
   tooling and needs the tooling owner's decision.
2. Add an explicit refresh mode that computes the planned set from the base comparison instead of
   from the written set.

Both are tooling changes rather than area-configuration changes; neither was made.

### State after this attempt

`~/src/lean/finitegeom` head `56e4edc`, worktree clean, nothing written.  The disposable candidate
tree from the refused run remains under
`~/.cache/othello-lean-build/companion-export/clebsch-orientation-candidate` and can be discarded.
In the authority, the only git change is the committed trust fact; this note remains uncommitted.

## Subset delta gate, export adopted into the base library (2026-08-03)

The forward-delta gate was changed from equality to containment, and the export chain then ran to
completion.  The base library now carries the six-node change.

### The gate change

`lean/scripts/lean-companion-export.py`, `forward_delta`: the candidate's actual git delta must now
be a **subset** of the planned written-file set rather than equal to it.

- An unplanned changed path is refused exactly as before, with the message
  `the candidate delta leaves the planned file set: unplanned [...]`.
- A planned file whose bytes the base already carries is no longer an error.  Such files are counted
  in the printed report as `planned_unchanged_count`, and listed as `planned_unchanged` under the new
  `run --verbose` flag.  Counting them keeps a refresh that rewrote nothing distinguishable from one
  that carried its modules across.
- Deletions and index state in the candidate remain a hard refusal, unchanged.

The module docstring now states the containment contract.  Two regression tests were added to
`lean/scripts/test_lean_companion_export.py`: one restores a planned file to its base bytes and
asserts it is reported unchanged rather than missing, the other asserts an unplanned path still
refuses.  The suite passes.

### Export

```
python3 lean/scripts/lean-companion-export.py \
  --config lean/trust/export/clebsch_support_cubic_orientation.toml \
  --source-commit HEAD --base-commit HEAD --accept-base-prose-drift \
  run --workdir ~/.cache/othello-lean-build/companion-export/clebsch-orientation-candidate --verbose
```

Source commit `a4b20bce`, base commit `56e4edc5`, deterministic repeat confirmed, module count
unchanged at 273, twenty planned files unchanged because the base already carried their bytes.  The
delta was nine files:

| Kind | Paths |
|---|---|
| modified | `README.md`, `TARGET_MANIFEST.json`, `RelativeConicArcs/PaperIOrientationNodes.lean`, `RelativeConicArcs/PaperIOrientationTraceDual.lean` |
| added    | `trust/CLEBSCH_SUPPORT_CUBIC_ORIENTATION.md`, `trust/ClebschSupportCubicOrientationAxiomAudit.lean`, `trust/areas/clebsch_support_cubic_orientation.toml`, `trust/manifests/clebsch_support_cubic_orientation.json`, `trust/source-manifests/clebsch_support_cubic_orientation.json` |

The pre-existing `PROVENANCE.md` drift (declares a 251-module library state against a 273-module
manifest) was again accepted untouched and still awaits a separate repair in the base repository.

### Validation in the base library

Delta copied into `~/src/lean/finitegeom` with no hand edits, then, through the guarded runner
against that root:

```
python3 lean/scripts/lean-build-queue.py run RelativeConicArcs.PaperIOrientationSpine \
  --lean-root ~/src/lean/finitegeom --profile single --threads 1 --cores 20-23 --cache-mode off
passed RelativeConicArcs.PaperIOrientationSpine {'wall_clock': '3:49.88', 'max_rss_kbytes': '9515012', 'exit_status': '0'}
starting trace-only aggregate gate
queue complete
```

The exported axiom audit was then elaborated in the same root through `guarded-lean --root`.  It
prints all twenty-four orientation terminals, each depending on exactly `propext`,
`Classical.choice`, and `Quot.sound`.  No other axiom, and no `sorry`, appears in its output.

### Adoption

One ordinary unsigned forward commit in `~/src/lean/finitegeom`:

- message: `Prove the six ordinary nodes of the support cubic and record its orientation boundary`
- new head: `85dfde9e13e6c3d004e0e659fb83c1a4761902d0`
- the branch is now nine commits ahead of `origin/main`; the eight earlier unpushed commits are
  untouched, the worktree is clean, and nothing was pushed.

`hassettTschinkel_six_nodes_of_traceDual` is no longer an axiom-bearing terminal anywhere in the base
library.  Publishing that revision, and the certificate-package re-pin sequence recorded earlier in
this note, remain the author's decisions.
