# C864 — point-orbit ownership review (Option C vs Option A)

**Date:** 2026-08-04
**Lane:** `build-sys`
**Reviewer:** read-only design review; no Lean source edited, no build run.

**Verdict: Option C is correct — and not merely as the cheaper route: Blocks' import closure
reaches generated Brianchon tables and an exhaustive ledger theorem, so the "displayed blocks stay"
boundary recorded in the verdict note and task card was never as clean as written, and Option A
would push generated order-eleven content into a base that documents itself as excluding exactly
that family.  Proceed, but amend the two contradicting authority documents, rewrite the "two
halves" trust story, re-anchor the paper trust manifest, and add three semantic dictionary
theorems to the package gate's audit.**

## 1. Option C versus the recorded ownership boundary

The task card's settled paragraph — "its displayed blocks, index dictionary and the five decidable
block theorems stay as the interface the rigidity gate audits" — and the verdict note
`notes/2026-08-04-c864-point-orbit-data-verdict.md` both record the stay-local decision that
Option C overturns.  Three findings justify overturning it:

- **The frozen ownership boundary does not actually protect the blocks.**  `orbitPoints` is a
  133-index enumerated table produced by the orbit computation; only `witnessIndex`,
  `standardConicIndices`, `orbitSize` and `orbitRepresentative` are human-scale.  The verdict
  classified the block half as interface because the rigidity gate audits it and the paper prints
  it — but "gate-audited" is a property of the gate, and the gate itself is re-homed: the base's
  own `Gates/ClebschRigidityHuman.lean` (lines 10–11) says the base deliberately excludes the
  generated order-eleven orbit/action family and that the downstream q11 package supplies the full
  `ClebschRigidityTrust` paper gate.  The package is not an orbit-only certificate store; it is the
  paper-gate package, and the orbit family's single natural home is there.
- **What settles Option A as wrong in design, not just in cost:** `Q11A5PointOrbitsBlocks` imports
  `Q11BrianchonPetersen`.  `brianchonSet` and `triplePointSet` are built from
  `brianchonPointCodes` and `tripleChordIntersectionCodes` (generated ten-row tables), and
  `triplePointSet_eq_brianchonSet` is proved from
  `Q11BrianchonPetersen.disjoint_chord_intersection_ledger`, the exhaustive 45-intersection ledger
  theorem.  A base export of Blocks cannot take Blocks alone; it drags generated tables and an
  exhaustive theorem into the base against the base's declared exclusion.  Option A was underpriced
  even in the cut-status note that rejected it.
- **The blocks family has exactly one non-family monorepo consumer.**  A scoped search over
  `lean/RelativeConicArcs` for `Q11A5PointOrbits`, `orbitPoints`, `brianchonSet`, `triplePointSet`
  excluding the family's own files matches only `Gates/ClebschRigidityTrust.lean`.  Deleting the
  family severs nothing structural in the monorepo.

Required hygiene: amend the task card's settled paragraph and add a superseded-by header to the
verdict note in the same commit window as the deletion.  Leaving the card asserting "the blocks
stay" after they are deleted breaks the card's status-map function.

## 2. What Option C loses, against the order-16 precedent

**Acceptable in kind.**  The q16 precedent is exactly this shape: the old local gate is human-only,
the exact theorem and exhaustive gate live in the package, and the monorepo retains no local
statement of the exact q16 result.  The referee-visible surface is the package: sealed sources,
committed manifest, focused gate, axiom fact, pinned by hash from the monorepo, citable at a
revision.  Making the four point-orbit statements external is the same move.  The one real
difference — these four are cheap `decide` statements, unlike the q16 payload — cuts both ways:
externalizing them costs nothing in checkability (anyone can rerun the package gate; the block
theorems are seconds of it), and keeping them local was only ever possible by also keeping the
Brianchon generated tables local.

**Bounded regressions that need explicit follow-up:**

- The verdict note's trust-manifest story — "full checking requires enumerating both halves: the
  local block theorems here, and the package's own import-only gate" — becomes false; there are no
  local block theorems.  The `RelativeConicArcs/TRUST.md` section and the manuscript sentence
  written for the two-halves story must be rewritten to the single-external-enumeration story,
  q16-style.
- The Clebsch-rigidity paper trust manifest names the four theorems as monorepo terminals
  (`papers/clebsch-rigidity/verification/build_trust_manifest.py` line 30 and its
  `trust_manifest.json`, plus the standalone mirror copies).  They need external-package anchors —
  the `entry_package` mechanism the q16 Al-Seraji--Al-Ogali anchor established — updated
  monorepo-first, then forward-committed to the mirror.
- **The load-bearing seam moves to the dual-copy modules.**  After the cut, the package still
  carries copies of modules the monorepo must keep (`Q11BrianchonPetersen`,
  `Q11DecodingSynthesis`, `Q11DyeConsequences`, `Q11RigiditySpine`, `Q11CodeRigidityBridge`,
  `ClebschGatewayQ11Extension`, `SixArcDegenerateConicExclusion`, the gate).  The pinned trust
  fact's meaning depends on those copies matching the monorepo authority, and drift has already
  been measured once (67 differing files, one semantic docstring divergence).  Extend the
  certificate-boundary checker or the manifest-seal step to enforce byte-identity over the declared
  overlap set against the monorepo authority, so identity is machine-checked at every reseal rather
  than re-established by hand.

## 3. Third options considered

- **Defer-and-batch** (the cut-status note's own step 1): keep the landed split, postpone the orbit
  cut until the already-mandated batched base re-export (which must add `ParametrizedHoles` and
  refresh `Q11Residual`/`Q11Coding` anyway), and add Blocks to that batch.  Rejected: the
  import-closure finding above means the batch would also take the Brianchon generated tables and
  ledger theorem into the base, against its declared exclusion; and it keeps the dominant
  elaboration payload in the monorepo longer for zero trust gain.
- **Intrinsic reformulation** of the four statements (orbits of the action rather than displayed
  blocks): a paper-facing surface redesign, outside C864's byte-preserving remit; already correctly
  priced out by the feasibility audit.
- **Unproved local display shadow** (keep the tables in the monorepo without their theorems, for
  paper legibility): worse than nothing — an unverified duplicate of package data is precisely the
  shadow class this task removes.

No third option beats Option C.  One **forward constraint** the choice creates: the future batched
base re-export must not add `Q11BrianchonPetersen` — or any module the package carries under the
same fully qualified name — to the base while the package retains its copy; the pinned base and the
package would then both provide the module and the build would collide.  When the later
decoding-synthesis interface split wants Brianchon interface declarations base-side, the package
must drop or subsume its copy and re-pin in the same window.

## 4. Defects in the Blocks/Data split

**No wrong-side declaration found.**  Every name the four Data tactic macros normalize through
(`orbitPoints`, `orbitIndex`, `orbitRepresentative`, `witnessSet`, `witnessIndex`,
`standardConicIndices`, plus Data's own action declarations) resolves through the Data → Blocks
import; `pointVec`/`canonicalIndex` sit Blocks-side as the verdict's boundary specified;
`codeIndex_injective` correctly travels with `codeEmbedding` in Blocks.  The package lakefile roots
include Blocks, Data, Partition, Brianchon and the gate.  Nothing here should fail to compile in
the package given byte-identical sources and a base pin providing `Q11Coding`.

Non-blocking observations:

1. **Forward references inside the Data macros.**  `q11_representative_orbit_norm` names
   `pointOrbit`, and `q11_fixed_union_norm` names `orderFiveFixedUnion`, `fixedPoints`,
   `OrderFive`, `supportPower` — all defined later in the same file than the macros.  This works
   because identifiers unresolvable at quotation time defer to use-site resolution, and every use
   site sits inside `namespace RelativeConicArcs.Examples.Q11A5PointOrbits`; it is fragile if a
   leaf ever invokes a macro outside that namespace.  Empirically green (the 17m18s gate rebuild),
   so informational only; moving the macros below the definitions at the next planned touch would
   remove the fragility for free.
2. **The verdict's "no raised limit" claim was wrong as written.**  `Q11A5PointOrbitsPartition` and
   `Q11A5PointOrbitsBrianchon` both carry `maxHeartbeats 100000000` / `maxRecDepth 100000`.  Under
   Option C they move to the package and the discrepancy dissolves, but do not carry the claim
   forward into the rewritten trust prose.
3. **Vestigial `open Q11Coding`** in both Blocks and Data: no `Q11Coding` name is used in either
   file.  Harmless; drop at next touch.
4. **Stale docstrings for the new home.**  Data's docstring still opens "This base module
   records..."; Blocks' docstring says the action identification is "checked in the separately
   versioned order-eleven certificate library and consumed here as a pinned trust fact" — wording
   aimed at a monorepo home that Option C abolishes.  The package copies need the docstrings
   re-aimed (the module now lives beside the checks it defers to), which is an intentional
   package-side difference to record at the byte-identity audit.
5. **The monorepo gate edit is more than dropping four `#print` lines.**  Line 1 of
   `lean/RelativeConicArcs/Gates/ClebschRigidityTrust.lean` is
   `import RelativeConicArcs.Q11A5PointOrbits` and must go, and the gate's doc comment sentence
   about the order-sixty action needs the matching rewrite.  The umbrella `RelativeConicArcs.lean`
   showed no family reference in a scoped search, but run the full deletion checklist (umbrella,
   gates, boundary checker, trust registry) as the cut-status note's step 4 already prescribes.
6. **Three semantic dictionary theorems go dark unless audited.**
   `pointVec_eq_projectiveVec` and `pointVec_witnessIndex` (`Q11A5PointOrbitsBasic`, lines 12 and
   17) and `mem_standardConicIndices_iff` (`Q11A5PointOrbitsConic`, line 13) are the tie between
   the displayed indices and the base-side semantics (`projectiveVec`, `witnessVec`, the conic
   equation).  Without them in some audited surface, `unique_six_orbit` identifies "the witness"
   only nominally — a set of six bare indices.  Their statements depend only on base-pinned names,
   so the package can audit them: add `#print axioms` lines for these three to the package gate (an
   intentional package-only gate extension, sanctioned by the task card's allowance for
   package-only gates/wrappers) and list them among the pinned fact's terminals.
7. **Record the base pin.**  The package pins base revision `85dfde9e…`, which differs from the
   q16-era base `a7665be…`.  Confirm at reseal that it is a published revision whose `Q11Coding`
   compiles standalone, and record it in `MANIFEST.json` as usual.

## Disposition summary

Proceed with Option C.  Before calling the point-orbit step closed: amend the task card and verdict
note; rewrite the TRUST.md/manuscript two-halves prose; re-anchor the four theorems in both paper
trust manifests via `entry_package`; extend the boundary check to the dual-copy overlap set; add
the three dictionary theorems to the package gate audit; drop the gate import plus doc sentence
with the deletion; and log the base-re-export module-collision constraint where the batched
re-export plan lives.
