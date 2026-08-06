# C864 — external certificate closeout and portfolio audit

**Lane:** `build-sys`

**Status:** ACTIVE — order-16 package sealed, pinned, and closed out: gate green, packed, and
restore-rehearsed trace-current.  The order-eleven point-orbit family is externalized and pinned;
the remaining order-eleven families, order-13, and order-25 are not yet executed.

## Goal

Finish the one-way extraction of every large generated Lean certificate family from the Othello
monorepo.  Each family must have exactly one official, separately versioned library under
`~/src/lean/`; the monorepo and shared `finitegeom` base retain only human-scale definitions,
semantic certificate APIs, proved reductions suitable for reuse, package pins, and compact trust
facts.  Imported certificate libraries must be restored from guarded content-addressed caches and
must never be rebuilt merely because an unrelated monorepo leaf changed.

After the portfolio split is complete, sanity-check every registered paper Lean export.  This is
an all-paper release-boundary pass, not a spot check of only the papers whose certificates moved.
C864 also owns the complete disposition of the Arcs and Clebsch-rigidity trust findings described
below; neither paper may retain an untriaged warning when the task closes.

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
- Complete: focused gate success, exact axiom capture (both terminals depend only on `propext`,
  `Classical.choice` and `Quot.sound`), the package pack at
  `/home/tavis/lean-backups/q16-certificates-d780520-cache.tgz` (359 MB, sha256
  `3dbbafc4c5077fd3983f49f18157886ba5a586bc295e862ebe91799756fb122a`), the destructive erase and
  restore rehearsal, and trace-only gate confirmation over 9,973 targets with no leaf rebuilt.
- The pinned external trust fact is published and consumed.  The package publishes its gate's axiom facts through `TRUST_FACT.json`; the monorepo carries a byte-identical pinned copy at
  `lean/trust/external/finitegeom-q16-certificates.json`, hash-pinned in
  `lean/trust/certificate-packages.toml`.  Sealing, pinning, and checking run through
  `lean/scripts/lean-external-fact.py` and involve no Lean run.  The package manifest also needed
  re-sealing after the umbrella-import repair; the boundary check is green again at package commit
  `1ea9caace0718c2e041662b0d39d0ec867f299cc`.  Report:
  `notes/2026-08-04-c864-external-order16-trust-fact.md`.

### Arcs trust cleanup

- The Kim--Vu hypothesis has a mechanical Lean anchor:
  `RelativeConicArcs.Averaging.rhoC_le_of_kimVuBound`.
- The Al-Seraji--Al-Ogali class count is only a consistency check; its formal anchor is the checked
  rejection-profile theorem rather than an assumption used by the q16 proof.
- The old local q16 gate is now human-only.  The exact q16 theorem and exhaustive gate live in the
  official q16 package.
- The arcs manuscript and standalone mirror now refer to the external package and contain no q16
  generator or replay payload.
- The Kim--Vu and Al-Seraji--Al-Ogali anchors are landed.  Kim--Vu points at
  `RelativeConicArcs.Averaging.rhoC_le_of_kimVuBound`, its only consumer; the class count points at
  `RelativeConicArcs.Q16Classification.rejection_profile` through the new
  `entry_package` field, and the pinned fact exhibits the required separation by recording the
  order-16 terminal's axioms.  That classification theorem is base-owned, not package-owned: the
  order-16 package lists it under `external_imports` and holds no copy, which leaves the separation
  argument intact and the earlier attribution wrong
  (`notes/2026-08-05-c864-non-lean-payload-and-build-artifact-sweep.md`).  The NRC/GRS dictionary entry stays unanchored until the strong
  projective-GRS theorem lands with its own gate.  The shared generated trust views and external
  trust projections are not yet regenerated: the tree carries a foreign lane's uncommitted facts
  artifact, so that regeneration waits for a coherent quiet tree.

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

### Required Arcs and Clebsch-rigidity trust disposition

- Replace the empty Kim--Vu entry declaration with the exact formal hypothesis-consumer anchor and
  verify that the extracted gate fact reports the intended assumption boundary.  The paper and
  trust manifest must state precisely what is imported from Kim--Vu and what Lean proves from it.
- Keep the Al-Seraji--Al-Ogali class count only as a literature consistency check, anchored to the
  formal rejection-profile theorem.  It must not appear as an axiom, hypothesis, or dependency of
  the q16 result; the external q16 fact must demonstrate that separation.
- Land the strong projective/monomial GRS theorem from the C855 worktree, validate its focused gate,
  and remove the NRC/GRS dictionary warning rather than merely renaming or suppressing it.
- The pinned fact cannot answer the Dye question: it is stale.  The monorepo's `Q11DyeAxioms` now
  declares no axioms — both Dye statements are theorems there — while the base at the pinned revision
  still declares both as axioms and the published trust fact records them as trusted inputs of the
  rigidity terminal.  Answer the audit against monorepo source after the Paper I remediation settles,
  and re-derive the axiom list from a fresh gate run rather than carrying the published one forward.
  Evidence: `notes/2026-08-05-c864-order-eleven-remaining-split-lines.md`.
- Audit the two Dye declarations used by Clebsch rigidity.  If they remain genuine literature
  inputs, give each an exact theorem-level entry declaration, stable bibliographic pinpoint,
  extracted gate occurrence, and paper statement of the residual trust boundary.  If the current
  Lean closure does not use one, remove the orphan declaration and stale prose.  C864 does not
  require re-proving a genuine Dye theorem unless the audit reveals that the existing declaration
  is stronger than the cited result.
- Re-extract all affected local gates and import the pinned external q16/q11 package facts.  Then
  regenerate `RelativeConicArcs/TRUST.md`, the machine-readable area registry/facts, dependency
  graph, external trust projections, and both papers' trust-facing prose from the reconciled state.
- Run the orphan, terminal-coverage, expected-axiom, external-input-anchor, stale-export, and
  paper/Lean reconciliation checks.  Every finding must end as proved/closed, precisely declared
  literature input, or documented external certificate fact; “warning with no entry declaration”
  is not an admissible final state.

### Base-library export defect and the order-eleven boundary

The order-16 cold fill failed after nearly three hours, at the gate, on a base-library module the
gate never needed.  The package's small result aggregator imported the base umbrella
`RelativeConicArcs.Results`, which reaches the order-eleven non-GRS module, the order-eleven coding
module, the order-eleven semantic family, and finally `RelativeConicArcs.Q11Residual`, which the
base cannot compile: it consumes a parametrized-hole validity predicate and a previous-player-win
transport lemma whose defining module was not exported into the base.  Removing that one import
drops the gate closure from 1,390 project modules to 1,358 and its base contribution from 59
modules to 27, and no order-eleven semantic module remains.  The package fix is committed as
`d780520`; the gate then passed and was confirmed trace-current after a pack, erase and restore.

The monorepo half of the first consequence is done; the second, and the base re-export itself,
remain deferred so the base is re-exported and re-pinned once rather than twice:

- **The monorepo source split is landed and gate-green.**  `RelativeConicArcs/ParametrizedHoles.lean`
  now holds the game-free validity predicate under its unchanged fully qualified name,
  `RelativeConicArcs/Q11Residual.lean` keeps the conic parametrization, the icosahedral adjacency
  and both directions of the validity dictionary with no game content, and
  `RelativeConicArcs/Q11ResidualGame.lean` holds the two game terminals.  `Q11Coding` was the second
  base module broken by the same dropped import and now takes the predicate from the new leaf.  All
  nine gates reaching the residual module are green.  This preserves the accepted game residue in
  the Paper I and arcs closures recorded in `notes/2026-08-03-c860-cap-closure-remediation.md`.
  Report: `notes/2026-08-04-c864-q11-residual-game-split.md`.
- **The base re-export and the order-eleven package re-seal are one atomic window.**  The monorepo
  renamed eleven `RelativeConicArcs.PaperIOrientation*` modules and their namespaces to
  `SupportOrientation*`; the base still carries the old names at both the pinned revision and its own
  `HEAD`, and the package's gate imports, axiom-audit names, sealed trust fact, the monorepo's pinned
  copy of that fact, and the Clebsch-rigidity trust manifest all still use them.  Exporting the
  renamed base without re-pinning and resealing the package in the same window leaves the package
  unbuildable.  Evidence: `notes/2026-08-05-c864-q11-package-source-audit.md`.
  That window also carries the two record fixes the audit found: correct `PROVENANCE.md` to the real
  extraction revision `0ddbca65`, and seal the monorepo revision in `MANIFEST.json` as a field
  distinct from the package's own `source_commit`.
- **The base is not yet re-exported.**  The batched re-export must add
  `RelativeConicArcs/ParametrizedHoles.lean` to the base module set, refresh the base copies of
  `Q11Residual.lean` and `Q11Coding.lean`, and keep `Q11ResidualGame.lean`,
  `CapGameHoleLocalization.lean` and `ProjectiveCap/ProjectiveCapGame.lean` out of it.
- **Nothing builds the base standalone before a package pins it.**  That is why a broken export
  surfaced only inside a consumer's three-hour build.  A standalone base build belongs in the export
  tooling as a gate.

Measured order-eleven payload, for the externalization pass: 148 order-eleven modules in the
monorepo, of which 66 carry generated content.  The two dominant families are the point-orbit rows
— 60 generated row leaves under 72 row aggregators, about 660 KB of source, each leaf an exhaustive
per-row action theorem with heartbeat and recursion limits raised — and the twenty-module semantic
family of exhaustive per-point presentation theorems.  Both are certificate payload under the
ownership boundary above; the orbit definitions and the arithmetic, Brianchon and conic lemmas are
human-scale and stay.  Whether the point-orbit rows form their own official package or join the
other Clebsch q11 certificates is undecided.

The point-orbit family is cut and now belongs entirely to
`finitegeom-clebsch-q11-certificates`, displayed blocks included.  The data module was first split
into a displayed-block interface and the group-action payload, which is the right internal boundary
and is preserved inside the package; but the interface does not stay monorepo-side, because its
`brianchonSet` and `triplePointSet` are built from generated Brianchon tables and
`triplePointSet_eq_brianchonSet` is proved from the exhaustive intersection ledger, and because the
base library documents itself as excluding the order-eleven orbit/action family.  The monorepo
keeps no point-orbit module and consumes the package's pinned fact; its rigidity gate no longer
audits the four orbit statements.  Verdict and declaration lists:
`notes/2026-08-04-c864-point-orbit-data-verdict.md`; ownership review:
`notes/2026-08-04-c864-point-orbit-ownership-fable-review.md`; cut record:
`notes/2026-08-04-c864-q11-package-cut-status.md`.  The full source-side boundary, including the ten
modules reached from outside the order-eleven family and the five of those that mix a semantic
interface with exhaustive work, is inventoried in
`notes/2026-08-04-c864-q11-payload-inventory.md`.

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
   The Lean-source half is done through `lean/scripts/lean-certificate-portfolio-audit.py`: no stale
   shadow survives in any paper mirror or backup working tree, and the two projective-cap candidates
   hold no payload at all.  Report: `notes/2026-08-05-c864-certificate-portfolio-audit.md`.
   Its two package-side findings are closed.  The order-25 candidate's banner rewrite is declared as
   `q25-banner-normalization-v1` and machine-checked by
   `lean-package-source-audit.py --declared-transformation`; the same pass found the candidate 1,786
   files behind across nine families, so order-25 externalization re-extracts rather than adopts it
   (`notes/2026-08-05-c864-q25-banner-transformation-declaration.md`).  The base carries one
   generated module, not three: two were false positives of a banner rule that matched prose about an
   ideal generated by `a`, and the surviving `ClebschArithmeticGluingData` is determined human-scale
   semantic source that stays, declared in the new permanent `resident_family` table
   (`notes/2026-08-05-c864-base-generated-module-classification.md`).
   The non-Lean payload and build-artifact halves are done as well
   (`notes/2026-08-05-c864-non-lean-payload-and-build-artifact-sweep.md`).  Certificate generators
   live under `notes/`, which the boundary checker never scanned, so a new rule resolves the
   generator each generated banner names and requires a declaring family; the order-25 family's ten
   generators, two replay programs, replay checker, and replay data are now declared as pending
   payload, and the two resident tables' generators as permanently resident.  The extractions left
   build residue no source rule sees: 114 point-orbit modules in the monorepo and three order-16
   modules in the base, whose deletion needs the base re-export window.  No mirror or backup working
   tree carries non-Lean payload.  Open from that sweep: the order-25 replay table exists only as an
   untracked cache file and an uncommitted candidate copy, the candidate repository has no commits at
   all, its script set and the monorepo's disagree in both directions, the adopted packages and the
   candidate seal their non-Lean payload three different ways with nothing checking it, and four
   dependency locks still resolve a base revision carrying extracted order-16 sources, so the
   re-export window must refresh those locks too.
7. Remove every stale shadow after byte identity and authority are established.  Never delete the
   sole current copy, foreign dirty work, or an uncommitted candidate without first preserving it
   in its official repository.
8. Extend `lean/trust/certificate-packages.toml` and the boundary checker to every adopted package.
   Add adversarial tests proving that a new owned module, import, generator, replay output, or
   generated-banner family in the monorepo is rejected.
9. Regenerate and check external trust exports from local semantic facts plus pinned external
   package facts.  The normal monorepo exporter must never attempt to elaborate an external
   certificate gate.
10. Complete the Arcs/Clebsch-rigidity trust disposition above, including the Kim--Vu and
    Al-Seraji--Al-Ogali anchors, the strong NRC/GRS closure, Dye input audit, fresh local/external
    facts, regenerated trust documents, and paper/Lean reconciliation with zero untriaged warning.
11. Enumerate every registered paper Lean companion export and standalone Lean-for-paper package.
    The registered companion-export areas are exactly the configurations in `lean/trust/export/`:
    Clebsch passages, Clebsch support-cubic orientation, golden quantum statistics, and MDS--CSS
    transversal groups.  Each must be re-exported here against the resealed base manifest, not
    only the areas whose certificates moved.
    For each one, run the guarded export plan, materialize two disposable candidates from the exact
    committed source/base revisions, require byte-identical outputs and complete manifests, verify
    the declared terminals and axiom facts, and run the paper's documented import-only release
    gate.  Check that every paper reference and package pin resolves to the intended local semantic
    library or official certificate package and that no export reintroduces an extracted payload.
12. Run the global paper-export audit/check commands after the individual replays, including stale
    manifest, unexpected deletion, reverse-reference, and unregistered-paper detection.  Record a
    bounded result table naming every paper/export, source revision, base/package revision, gate,
    and pass/fail disposition; no configured paper may be silently skipped.
13. Re-run the package source audit for every adopted package against its authority revision and
    require zero drift, as the final evidence step before closeout.  A package and the monorepo
    build from separate copies of any source both still carry, so nothing else detects a divergence
    between them; the audit is the only check that does.  The same re-run is required immediately
    before each remaining deletion, not only here: a duplicate that is byte-identical today can
    drift under any lane editing the area, and the pre-deletion run is what makes the deletion
    provably a deletion rather than a silent overwrite of the newer bytes.
14. Update C287/C324/C686/C687 records and the build-sys handoff, then complete C864 through the
    archive-first lifecycle.

## Near-term plan while the Paper I remediation holds the Lean tree

The Paper I theorem-complete remediation is actively rewriting `RelativeConicArcs` sources, the
`relconic` trust area, and the Clebsch-rigidity release chain.  Its uncommitted work is in the shared
tree.  Until it settles, C864 takes only steps that need neither the heavyweight build window nor a
quiet tree, and evidence that would be invalidated by its next commit is not produced.

Deferred until the tree is coherent again: the Clebsch-rigidity release-chain replay, the base
re-export and re-pin, the shared generated trust views and external trust projections, and any
further monorepo certificate deletion.

Runnable now, in order:

1. **Package/monorepo byte-identity audit for the order-eleven point-orbit package.**  Done, through
   the new `lean/scripts/lean-package-source-audit.py`, which runs no Lean and takes no lock.  The
   package's bytes are faithful to the monorepo authority `0ddbca65`; the only differing source is
   the gate, whose two sides differ exactly as intended; the seven order-eleven modules both trees
   still carry are byte-identical, so the remaining cut is a pure deletion.  The audit also found
   the stale `PROVENANCE.md` extraction revision and the unpropagated orientation rename recorded
   below.  Report: `notes/2026-08-05-c864-q11-package-source-audit.md`.  Re-run it immediately
   before the remaining order-eleven cut: nothing but this audit detects drift in those seven
   duplicated sources, and the area is under active edit.
2. **Adversarial boundary-checker fixtures.**  Done; all four of step 8's return paths are covered
   and green, and both real-tree checks pass.  Covered: the payload returning as monorepo source, an
   imported external leaf, a copied generator under a declared name and under any other name, all
   three edited-pin paths — moved commit pin, unfollowed manifest reseal, sealed source altered
   inside the official checkout — and a novel generated family.  The last needed two new rules, an
   undeclared-generated-family rule in the default check and a content-identity rule against the
   official checkouts, plus a `pending_family` table in `lean/trust/certificate-packages.toml`
   declaring each generated family still resident in the monorepo with the package that will own it.
   That table is the remaining externalization scope in machine-checked form and must be empty at
   closeout, including its four `resident-unclassified` entries.  Report:
   `notes/2026-08-05-c864-boundary-checker-fixtures.md`.
3. **Split-line planning for the remaining order-eleven families.**  Done.  The remaining cut is the
   order-16 kind, not the point-orbit kind: the definitions its statements quantify over are
   closed-form arithmetic rather than enumerated tables, so statements and definitions stay and the
   exhaustive proofs move.  Per-module dispositions, the treatment of the eight coding terminals,
   and the sequencing against the Paper I remediation are in
   `notes/2026-08-05-c864-order-eleven-remaining-split-lines.md`.  Two conditions before execution:
   the owning proof lane agrees to the eight coding terminals moving, and the remediation lands,
   since it is replacing the Dye axioms with proofs and would otherwise force an immediate reseal.
4. **Order-25 banner transformation declared.**  Done, as `q25-banner-normalization-v1` in
   `lean-package-source-audit.py` with the candidate's `PROVENANCE.md` citing the name, plus the
   corrected staleness measurement.  Report:
   `notes/2026-08-05-c864-q25-banner-transformation-declaration.md`.
5. **Classification of the generated modules the base carries.**  Done; the banner rule is tightened
   in the boundary checker and the portfolio audit, the checker now reads whole files, and the
   `resident-unclassified` entry is replaced by a `resident_family` determination.  Report:
   `notes/2026-08-05-c864-base-generated-module-classification.md`.
6. **Non-Lean payload and build-artifact sweep.**  Done; findings and the two new machine rules are
   in `notes/2026-08-05-c864-non-lean-payload-and-build-artifact-sweep.md` and summarized under
   execution step 6 above.
7. **Payload seal convention and reverse-direction audit.**  Done.  The convention is in the cache
   and build contract above; the audit now reports authority files a package lacks, payload the
   manifest does not seal, and a declared family with no sealed source at all, with `--strict`
   promoting the first two to defects.  Both adopted packages are complete against their authority
   and both carry unsealed payload to migrate at their next reseal.  Report:
   `notes/2026-08-05-c864-payload-seal-convention-and-reverse-audit.md`.
8. **Remaining without a build window:** the two banner repaths that the base re-export must carry
   (`ClebschArithmeticGluingData`, `ClebschSchemeFourierData` naming paths their exports lack).

## Cache and build contract

- All Lean operations use the guarded queue.  No direct `lean`, `lake`, `nix ... lake`, cache copy,
  or hand-composed taskset command is allowed.
- One heavyweight build owns the host at a time.  Use measured profiles and the shared build-owner
  lock across the monorepo, official libraries, dependency checkouts, and restore rehearsals.
- Every official package records an immutable base revision, resolved `lake-manifest.json`, source
  commit, manifest hash, focused import-only trust gate, and exact public terminals.
- Non-Lean payload is sealed one way: a single `support_files` list in `MANIFEST.json`, holding every
  generator, replay program, replay input, canonical output, and gate evidence file with its path,
  byte count, and SHA-256.  Packaging — flake, lakefile, licence, citation, README, the sealing
  program itself — is not payload and is not listed.  Everything under `scripts/`, `artifacts/`,
  `evidence/`, and `verification/` is payload and must appear.  `generator` and
  `verification_artifacts` are the earlier spellings; `lean-package-source-audit.py` reads all three
  and reports payload the manifest omits or no longer matches, so each adopted package migrates at
  its next reseal rather than out of band.  Determination:
  `notes/2026-08-05-c864-payload-seal-convention-and-reverse-audit.md`.
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
   generated family, an imported external leaf, a copied generator, and an edited package pin.  The
   `pending_family` table is empty, with no family left `external-pending` or
   `resident-unclassified`.  Generated data kept here permanently appears instead in
   `resident_family`, each entry naming the determination that admits it.
10. A final bounded audit reports zero unexplained certificate findings and names every official
    repository, revision, manifest hash, cache hash, gate, terminal, and remaining trusted axiom.
11. Every registered paper Lean export has a fresh two-materialization identity check, complete
    manifest and terminal/axiom agreement, and a green documented release gate after the
    certificate removals; the global audit reports no missing, stale, or unregistered export.
12. A closing source audit of every adopted package against its authority revision reports zero
    drift, with each surviving difference named and justified, and each deletion is covered by its
    own immediately preceding audit run.
13. Arcs and Clebsch rigidity have zero untriaged trust warnings: Kim--Vu and any surviving Dye
    inputs have exact theorem-level anchors and cited scope, Al-Seraji--Al-Ogali is demonstrably only
    a consistency check, the NRC/GRS gap is closed by the validated strong theorem, and all local
    and external facts, generated trust views, and paper statements agree.

## Owned paths

Build-system scripts and tests; `lean/trust/`; exact certificate-owned monorepo paths being migrated;
the official certificate repositories listed above; exact downstream paper manifests/references;
the build-sys handoff and C864 report/card/queue row.  Human mathematical source remains owned by
its proof lane except for byte-preserving moves or narrowly required import/boundary repairs.  Any
nontrivial theorem change, including the C855 strong repair, retains its owning proof review and
gate even when C864 coordinates the package move.
