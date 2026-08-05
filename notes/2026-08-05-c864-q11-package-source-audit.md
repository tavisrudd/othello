# C864 — order-eleven certificate package source audit

**Lane:** `build-sys` · **Date:** 2026-08-05

**Verdict: the package's bytes are faithful to the monorepo authority, and the one difference is the
documented gate transformation.  Two record defects and one scheduled breakage came out of the
audit, none of them in the sealed Lean payload.**

The audit compares every sealed source in `~/src/lean/finitegeom-clebsch-q11-certificates` against
the monorepo revision the sources were extracted from, against the current monorepo tree, and
against the pinned `finitegeom` base.  It runs no Lean and takes no build lock, so it is valid while
another lane holds the shared tree.

## Replay

```sh
lean/scripts/lean-package-source-audit.py \
  ~/src/lean/finitegeom-clebsch-q11-certificates \
  --authority 'ab1dc6cc^' --list still-in-monorepo
```

- Script: `lean/scripts/lean-package-source-audit.py`, sha256
  `737a0b813f2a4c86684d978785835c49da5dc5d32665d6773490784cfcc0941a`.
- Package revision audited: `c366996` (`MANIFEST.json` seals 122 sources over package revision
  `4f61b2dc`).
- Monorepo authority: `0ddbca65`, the parent of `ab1dc6cc`, which deleted the point-orbit family.
- Pinned base commit: `85dfde9e`.

## Result

| count | classification |
|-------|----------------|
| 114   | worktree matches manifest; identical to the monorepo authority; deleted from the monorepo |
| 7     | worktree matches manifest; identical to the authority; **still present in the monorepo, byte-identical** |
| 1     | worktree matches manifest; **differs from the authority**; still present in the monorepo and drifted |

No sealed source disagrees with the manifest, and no module overlaps the pinned base, so the package
introduces no duplicate module name into its own import closure.

The single differing file is the gate `RelativeConicArcs/Gates/ClebschRigidityTrust.lean`, which
each side is supposed to hold differently.  The package copy imports
`RelativeConicArcs.Q11A5PointOrbits` and audits seven point-orbit declarations — the four orbit
statements plus the three dictionary lemmas that stop the orbit statements from identifying the
witness and the conic by bare index.  The monorepo copy drops that import and those audits, and its
header explains that the order-sixty action, its orbits, and the per-row verification are the
external package's payload, consumed here as a pinned trust fact.  That is the intended split, and
it satisfies the acceptance requirement that every intentional difference be listed and justified.

The seven duplicated sources are exactly the order-eleven families whose extraction has not run yet:
`ClebschGatewayQ11Extension`, `Q11BrianchonPetersen`, `Q11CodeRigidityBridge`, `Q11DecodingSynthesis`,
`Q11DyeConsequences`, `Q11RigiditySpine`, and `SixArcDegenerateConicExclusion`.  They are byte-identical
on both sides today, so the remaining cut is a pure deletion with no reconciliation to perform.

## Finding: the declared extraction provenance names the wrong revision

`PROVENANCE.md` states that the modules were extracted from monorepo commit `10d1941a` (2026-07-28).
Audited against that commit, 70 of the 122 sources differ and four do not exist in it at all.  The
package's bytes are those of `0ddbca65` (2026-08-04); the point-orbit cut refreshed the sources to
the authority and never updated the provenance statement.  `MANIFEST.json` does not record the
monorepo revision at all — its `source_commit` is the package's own revision — so `PROVENANCE.md` is
the only place the upstream authority is written down, and it is wrong.

The fix is to correct `PROVENANCE.md` to `0ddbca65` and to carry the monorepo revision in
`MANIFEST.json` as a distinct sealed field, so that a future audit needs no external knowledge of
which commit preceded which deletion.  Both edits reseal the manifest and the trust fact, so they
belong to the next package-side sealing window rather than to a standalone commit.

## Finding: the orientation rename has not reached the base, the package, or the paper

The monorepo renamed its whole orientation development away from manuscript-relative names: eleven
`RelativeConicArcs.PaperIOrientation*` modules are now `RelativeConicArcs.SupportOrientation*`, with
the namespaces renamed to match.  Nothing downstream has followed.

- The base library still carries all eleven under the old names, at the pinned revision `85dfde9e`
  and at its own `HEAD` `a7665be`.
- The package's gate imports `RelativeConicArcs.PaperIOrientationSpine` and audits declarations under
  `RelativeConicArcs.PaperIOrientationSymmetry`.
- Both the package's `TRUST_FACT.json` and the monorepo's byte-identical pinned copy at
  `lean/trust/external/finitegeom-clebsch-q11-certificates.json` record the old fully qualified
  names throughout.
- The Clebsch-rigidity manuscript, its `verification/trust_manifest.json`, and both manifest scripts
  reference the old names.

Nothing is broken at this moment: the package is internally coherent against the base revision it
pins, and its gate is green.  The breakage is scheduled.  Whenever the base is re-exported with the
renamed modules, the package's gate imports stop resolving, its axiom audit names stop resolving,
its sealed trust fact becomes stale, the monorepo's pinned copy becomes stale with it, and the
paper's trust manifest disagrees with the Lean it describes.

The consequence for sequencing is the useful part: the base re-export and the order-eleven package
re-seal are one atomic operation, not two independent steps.  The base re-export was already
deferred so the base is exported once rather than twice; this adds the requirement that the same
window re-pin the package, refresh its gate imports and audit names, reseal the manifest and trust
fact, re-pin the monorepo copy, and reconcile the paper's trust manifest.  Doing the base export
first and the package re-seal later leaves the package unbuildable in between.

The paper-side references belong to the Paper I remediation that currently holds the tree, not to
this task.  The package, base, and pinned-fact side is owned here.

## Mystery ledger

- **Why the manifest seals no upstream revision.**  Settled: the sealing script derives
  `source_commit` from the package repository's own `HEAD`, which is what the q16 package does as
  well.  Both packages therefore record their own revision under a field name that reads as though
  it names the extraction source.  This is what made the first audit run misclassify all 122 sources
  as package-only.  The field is not wrong, but it is misnamed relative to what a reader expects,
  and the upstream revision it does not carry is exactly what an audit needs.  The remedy is the
  distinct sealed field proposed above; renaming the existing field would invalidate every published
  fact and is not proposed.
- **Why the seven pending duplicates are still byte-identical.**  Open, and it will not stay true.
  The Paper I remediation is editing this area now — it has already added a six-arc concurrence gate
  to `lean/trust/areas/relconic.toml` with eleven terminals and two untracked Lean modules.  If it
  touches any of those seven files, the package's copies drift silently, because the package builds
  from its own copies and no gate on either side compares them.  This audit is the only thing that
  detects it, and it should be re-run immediately before the remaining order-eleven cut rather than
  relying on today's result.
