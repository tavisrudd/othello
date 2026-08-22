# C939 final complete-ports formal review

**Date:** 2026-08-21
**Frozen commit:** `4cd32e1a78b009f76f44dbf130eb4ebbaa19675a`
**Tracked PDF SHA-256:** `c2611c12114492b47b1af5a8ac77f5550fb11ec9eba81c54acbf6c3523f6ccc9`
**Verdict:** **GO**

## Executive finding

The prior provenance blocker is fixed.  The frozen TeX and rendered PDF now print the same source,
finitegeom-base, and finitegeom-release commits as the shipped
`verification/formal-boundary.json`.  The release verifier now reads those three JSON fields and
requires their exact `\path{...}` forms in the verification-section source, so a future manifest
repin cannot silently leave stale manuscript provenance.

The paper-only deterministic gate and the full public-formal gate both pass on the exact frozen
commit.  The tracked PDF is a warning-free, byte-reproducible 23-page build.  Rendered page 20 is
visually clean.  The formal-correspondence boundary remains honest, the `F_29` replay remains an
independent cross-check rather than a premise, the public finitegeom export is exactly pinned, and
the public disclosure surface remains clean.

No remaining formal, computational, provenance, release, or visual defect was found in the
requested scope.

## Frozen identity

The checkout `HEAD` is exactly `4cd32e1a78b009f76f44dbf130eb4ebbaa19675a`.  The tracked PDF has
SHA-256 `c2611c12114492b47b1af5a8ac77f5550fb11ec9eba81c54acbf6c3523f6ccc9`, reports 23 pages, and
was accepted byte-for-byte by the deterministic verifier.

## Provenance synchronization

The frozen `verification/formal-boundary.json` records:

```text
source_commit              bb3d7c34b0381ee1ba77ad95076959e53f742d19
finitegeom_base_commit     e69fbe7ac9e2dd6fb193f6f3c914d3831cbe806e
finitegeom_release_commit  36c83268ddaeec9ee22824cad44d6222a9e67081
```

The frozen `sections/07-verification-provenance.tex` prints those exact three values.  The old
`e45c...` and `b871...` values no longer occur in the TeX/JSON/checker surface inspected for this
claim.

`verification/verify_release.py` now:

1. parses `source_commit`, `finitegeom_base_commit`, and `finitegeom_release_commit` from the JSON;
2. requires each to be a 40-character hexadecimal revision; and
3. requires the exact `\path{<revision>}` token for each field in
   `sections/07-verification-provenance.tex`.

This directly closes the recurrence risk identified in the previous review.

## Formal-correspondence boundary

The boundary remains accurate field by field:

- the import-only Lean gate covers the general exact functional strata, pointed confinement and
  transfer, restricted concatenated parameters, represented-target density, eventual prescribed
  ports, reliability/EXIT calculus, and MDS reconstruction;
- `RepairPorts.eventually_radiusThree_prescribedPortPair` is described only as simultaneous
  eventual radius-three support/coefficient-port transfer for two inner codes through one common
  outer family;
- the quotient-plane seed construction, generic lift, represented `[10,4,6]_q` parameters, finite
  clutter invariants, and reliability laws remain explicitly human;
- random-GV or AG/TVZ outer-family existence remains explicitly classical; and
- Theorem 6.5 is explicitly the human synthesis of these layers.

The concrete `F_29` matrices are still labeled an independent exact cross-check of the structural
proof, not a premise.  The paper does not overstate the paired Lean theorem or the finite replay.

**Formal-correspondence subverdict:** **GO**.

## Verification gates

The paper-only command

```text
nix develop .#manuscript --command python3 verification/verify_release.py
```

passes with

```text
complete-repair-ports release: PASS [paper surface, 23 pages, warning-free]
```

The full public-formal command

```text
nix develop .#manuscript --command \
  python3 verification/verify_release.py \
    --require-public-formal --lean-root /home/tavis/src/lean/finitegeom
```

passes with

```text
complete-repair-ports release: PASS [full release, 23 pages, warning-free]
```

The full gate binds the paper to the clean public finitegeom checkout at
`36c83268ddaeec9ee22824cad44d6222a9e67081`, checks its public origin, exported closure and source
hashes, paired manifests, trust statement, terminal inventory, and permitted axiom names.  The
paper-only gate also replays and hashes both the field-seven and matched `F_29` certificates.

The Nix wrapper printed the shared monorepo's generic dirty-tree warning.  The verifier itself
passed on the reviewed frozen paper inputs; its deterministic build uses the explicit paper sources
in a fresh temporary directory.

## Rendered page 20

Page 20 was rendered independently to an image and inspected at full resolution.  It is visually
clean:

- the four provenance rows are present and legible;
- the three long commit hashes and gate-fact hash stay within the text block;
- there is no collision, clipping, overprint, or broken line;
- the formal terminal lists remain readable; and
- the page number, margins, and page transition are normal.

The provenance block is necessarily compact, but it is usable and does not create a visual release
defect.

## Private-disclosure and public-pin state

The passing release checker retains its scan of manuscript, metadata, verification sources and
certificates, section sources, and figures for internal task IDs, workflow terms, private notes
paths, the private repository name, and private filesystem paths.  The public formal closure remains
bound to the public `tavisrudd/finitegeom` repository.  No new private disclosure was introduced by
the synchronized provenance block: it prints bare immutable revisions and the public release
boundary, not a private repository identity or path.

## Verdict

- Formal correspondence: **GO**.
- Provenance synchronization and enforcement: **GO**.
- `F_29` independent replay: **GO**.
- Public finitegeom binding: **GO**.
- Deterministic 23-page PDF and full release gate: **GO**.
- Rendered page 20: **GO**.
- Private-disclosure boundary: **GO**.

**Overall verdict: GO.**  No fix is required in the reviewed scope.

**Vibe check:** the formal and release surfaces are now synchronized, reproducible, and ready.

## Mystery ledger

The `ej`+`tt` closeout leaves no genuine mystery.  The former question—whether the old hashes were
historical or stale—has been eliminated by exact manuscript/JSON synchronization and a verifier
gate that enforces it.
