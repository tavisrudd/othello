# C864 — external certificate closeout and portfolio audit

**Lane:** `build-sys`

**Status:** ACTIVE — q16 authority split landed; official cold build is filling the first cache

## Goal

Finish the one-way extraction of every large generated Lean certificate family from the Othello
monorepo.  Each family must have exactly one official, separately versioned library under
`~/src/lean/`; the monorepo and shared `finitegeom` base retain only human-scale definitions,
semantic certificate APIs, proved reductions suitable for reuse, package pins, and compact trust
facts.  Imported certificate libraries must be restored from guarded content-addressed caches and
must never be rebuilt merely because an unrelated monorepo leaf changed.

This item is the integrated closeout for the remaining execution in C686/C687 and the certificate
boundary portion of C287/C324.  It does not silently re-peg or discard those tasks: completion must
reconcile their live rows and reports through the normal lifecycle.

## Frozen ownership boundary

- Generated leaves, transition rows, enumerated tables, package-private checkers and reductions,
  certificate-only aggregate theorems, generators, frozen generator reports, independent replay
  programs, and their canonical outputs belong only to the relevant external certificate library.
- Human mathematical definitions, reusable theorem schemas, field-independent soundness APIs, and
  small local examples remain in the monorepo and the public `finitegeom` base.
- A paper may cite and pin an external package, but it must not carry another generator, generated
  source tree, replay output, or certificate shadow.
- The monorepo must not import an external certificate closure.  It consumes a compact pinned trust
  fact and exposes only local semantic APIs; full certificate gates are built in their owning
  package.
- “No trace outside the official library” applies to current working trees, paper mirrors, backup
  checkouts, disposable worktrees, and build artifacts.  It does not authorize Git-history
  rewriting.  Recoverable quarantines may exist only while a byte-identity migration is being
  checked and must be removed at closeout.
- No push, tag, remote creation, history rewrite, or non-fast-forward operation is part of C864.

## Current state at allocation

### Order-16 relative-conic package

- Official repository: `~/src/lean/finitegeom-q16-certificates`, current local revision
  `5bd2048cb5f0346cc43726dcfe4c42b4ea3af2e7`.
- Base library: `~/src/lean/finitegeom`, revision
  `a7665be682907cab5c99b10e3a39a9fc289e2cb3`.
- The official manifest seals 1,331 Lean modules, the local generator, focused trust gate,
  independent replay, canonical replay summary, and frozen search transcript.
- The monorepo deletion landed in `f0050f5c`: 1,328 q16 certificate-owned Lean sources and six
  paper-local certificate/replay artifacts were removed.  The human gate subsequently passed in
  8m32s at a 5.33 GiB peak without rebuilding any q16 certificate leaf.
- Shadows were also removed from `finitegeom`, the golden library, the arcs paper mirror, and three
  backup checkouts.  A bounded filename audit found no remaining q16 certificate source outside the
  official q16 library; stale monorepo q16 build artifacts were explicitly unlinked.
- The guarded build system now supports dependency-lock refresh from an exact local unpublished
  source, disk-backed `lake pack`, guarded `lake unpack`, external-root restart checkpoints, and a
  certificate-boundary verifier.  The canonical finitegeom cache is
  `/home/tavis/lean-backups/finitegeom-a7665bea-cache.tgz`.
- The clean-pin build exposed and fixed a missing direct `CapGame.BuildGame` import in
  `ProjectiveCap.Sym2ConicBridge`; the focused base target then passed.
- Active q16 cold fill:
  `/home/tavis/.cache/othello-lean-build/run-20260804-151540-87eb8c71`.
  It resumed from byte-verified `Q16CertificateLevels`, `Q16StepKernel`, and `Q16Reduction`
  sentinels with four measured workers.  Do not submit another heavy Lean build until it is
  terminal.
- Still required: focused gate success, exact axiom capture, q16 package pack, destructive-cache
  restore rehearsal, trace-only gate confirmation, and a pinned external trust fact consumed by
  monorepo trust tooling.

### Arcs trust cleanup

- The Kim--Vu hypothesis has a mechanical Lean anchor:
  `RelativeConicArcs.Averaging.rhoC_le_of_kimVuBound`.
- The Al-Seraji--Al-Ogali class count is only a consistency check; its formal anchor is the checked
  rejection-profile theorem rather than an assumption used by the q16 proof.
- The old local q16 gate is now human-only.  The exact q16 theorem and exhaustive gate live in the
  official q16 package.
- The arcs manuscript and standalone mirror now refer to the external package and contain no q16
  generator or replay payload.
- The improved external-input anchors were prepared in the detached C855 worktree but are not yet
  landed in the monorepo trust registry.  C864 must land them together with the external q16 fact
  and regenerate/check the external trust projections.

### Clebsch-rigidity cleanup

- The strong mathematical repair is prepared, uncommitted and not Lean-validated, in
  `/home/tavis/.cache/c855-grs-proof` based on `f4aba33e`.
- It introduces an actual projective/monomial GRS predicate, proves that projectively GRS implies
  the existing quadratic condition, and states the unconditional non-projectively-GRS witness
  theorem.  It also adds a focused `Q11ProjectiveGRS` gate.
- Its Python trust-spine suite passed, but the Lean gate was deliberately deferred behind q16.
- The main tree therefore still carries the NRC/GRS dictionary warning as a consistency-check
  declaration.  It is not closed until the strong theorem elaborates, its gate and axiom audit pass,
  the trust entry is removed or reclassified accordingly, and the changes are forward-committed.
- Preserve this worktree exactly until its changes are reviewed and adopted; do not recreate or
  overwrite it.

### Remaining official package candidates

- `~/src/lean/finitegeom-clebsch-q11-certificates`
- `~/src/lean/finitegeom-projective-cap-q11-certificates`
- `~/src/lean/finitegeom-projective-cap-q13-certificates`
- `~/src/lean/finitegeom-q25-certificates`

At allocation these are incomplete local package candidates rather than validated authorities.
Before any monorepo deletion, compare every candidate source byte-for-byte against the newest
authoritative monorepo source, account explicitly for intentional package-only gates/wrappers, and
commit a self-contained official source state.

## Execution order

1. Finish and seal q16: resolve build errors, capture its focused axiom fact, pack the complete
   package and dependency caches, erase disposable build state, restore only from the packs, and
   require the exact gate to be trace-current without rebuilding a generated leaf.
2. Land and validate the strong C855 projective-GRS repair.  Keep human q11 semantics in the base;
   move the Clebsch q11 exhaustive payload, private checker, generator, replay evidence, and exact
   theorem into `finitegeom-clebsch-q11-certificates`.
3. Apply the same byte-verified split independently to the ProjectiveCap q11 package.  Do not merge
   the two q11 packages merely because their field order agrees: their consumers and certificate
   semantics are distinct.
4. Externalize ProjectiveCap q13, respecting C700/C701's semantic/certificate boundary and keeping
   Segre/tangent-code foundations in `finitegeom`.
5. Externalize q25 after reconciling C318/C319's decision about the exact classification claim.
   Preserve any unresolved mathematical limitation explicitly; package extraction must not upgrade
   a theorem's strength.
6. Run a complete portfolio audit for other generated or exhaustive certificate families under
   `lean/`, paper trees, standalone mirrors, every `~/src/lean` checkout, registered worktrees,
   backup checkouts, and current build artifacts.  Classify each finding as semantic API, official
   certificate payload, stale shadow, unrelated generated scholarly data, or false positive.
7. Remove every stale shadow after byte identity and authority are established.  Never delete the
   sole current copy, foreign dirty work, or an uncommitted candidate without first preserving it
   in its official repository.
8. Extend `lean/trust/certificate-packages.toml` and the boundary checker to every adopted package.
   Add adversarial tests proving that a new owned module, import, generator, replay output, or
   generated-banner family in the monorepo is rejected.
9. Regenerate and check external trust exports from local semantic facts plus pinned external
   package facts.  The normal monorepo exporter must never attempt to elaborate an external
   certificate gate.
10. Update C287/C324/C686/C687 records and the build-sys handoff, then complete C864 through the
    archive-first lifecycle.

## Cache and build contract

- All Lean operations use the guarded queue.  No direct `lean`, `lake`, `nix ... lake`, cache copy,
  or hand-composed taskset command is allowed.
- One heavyweight build owns the host at a time.  Use measured profiles and the shared build-owner
  lock across the monorepo, official libraries, dependency checkouts, and restore rehearsals.
- Every official package records an immutable base revision, resolved `lake-manifest.json`, source
  commit, manifest hash, focused import-only trust gate, exact public terminals, and generator/replay
  hashes.
- For each package, acceptance includes both a clean cold build and a separate pack/erase/restore
  replay.  The latter must show the focused gate trace-current and must audit that no validated
  sentinel or generated leaf rebuilt.
- Store packs and run state only on disk-backed paths under the home directory.  `/tmp` is tmpfs;
  temporary large trees found there are moved to a disk-backed quarantine before review.

## Acceptance

1. Every certificate family has exactly one official library or a written determination that it is
   human-scale semantic source and not an externalization candidate.
2. Every official source and evidence copy was verified against the newest pre-deletion source;
   every intentional difference is listed and justified.
3. No certificate-owned source, generator, replay output, or private checker remains in the
   monorepo, base library, paper mirrors, unrelated libraries, backup working trees, or build trees.
4. Each official package has a clean working tree, committed manifest and dependency lock, focused
   green gate, exact axiom fact, and green deterministic replay/check command.
5. Each package has a disk-backed content-addressed cache whose guarded restore is demonstrated from
   erased disposable state; the restored exact gate performs no source build.
6. The monorepo human gates remain green after payload deletion and do not import any external
   certificate module.
7. The trust spine and external projections consume pinned external facts without asking the local
   exporter to build external gates; trust warnings reflect only genuine literature assumptions.
8. The strong Clebsch-rigidity projective-GRS theorem and focused gate pass, closing the NRC/GRS
   trust warning at theorem strength rather than by prose reclassification.
9. The permanent boundary test rejects all known return paths and includes fixtures for a novel
   generated family, an imported external leaf, a copied generator, and an edited package pin.
10. A final bounded audit reports zero unexplained certificate findings and names every official
    repository, revision, manifest hash, cache hash, gate, terminal, and remaining trusted axiom.

## Owned paths

Build-system scripts and tests; `lean/trust/`; exact certificate-owned monorepo paths being migrated;
the official certificate repositories listed above; exact downstream paper manifests/references;
the build-sys handoff and C864 report/card/queue row.  Human mathematical source remains owned by
its proof lane except for byte-preserving moves or narrowly required import/boundary repairs.  Any
nontrivial theorem change, including the C855 strong repair, retains its owning proof review and
gate even when C864 coordinates the package move.
