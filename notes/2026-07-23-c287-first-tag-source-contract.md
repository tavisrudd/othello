# C287 first-tag source contract

**Lane**: `build-sys`
**Status**: REVIEWER-SCALE 26-FILE SOURCE INVENTORY FROZEN; referee prose gate failed

The theorem-level adoption and axiom boundary are analyzed separately in
`notes/2026-07-23-c287-first-tag-theorem-ledger.md`. The selected first tag is the 26-file closure
of the terminals actually cited by the manuscript. The uncited hyperbolic-quadric module and the
disjoint 24-file `FiniteGeom` umbrella are deferred to later tags with explicit claim contracts.
The four module gates and seven exact terminals are declared in the existing trust-spine registry;
`notes/2026-07-24-c287-first-tag-trust-spine.md` records the integration and validation.

## Contract

The first `finitegeom` tag uses exactly the human-scale terminal modules cited by the manuscript:

- `CapGame.Affine`
- `ProjectiveCap.Binary`
- `ProjectiveCap.EllipticMirror`
- `ProjectiveCap.PlaneOutcome`

`ProjectiveCap.Mirror` is already imported by this union, so its generic terminal remains present
without being a redundant packaging root.

The content-addressed inventory is
`notes/2026-07-23-finitegeom-first-tag-source-inventory.json`. It records schema version 1, the
four roots, every project-local source in their transitive import closure, byte counts, SHA-256
hashes, and the union of external imports. The inventory is ordered by repository-relative
destination path and contains no absolute path.

Generate it from tracked source headers with:

```sh
python3 lean/scripts/lean-blast-radius.py closure \
  CapGame.Affine ProjectiveCap.Binary \
  ProjectiveCap.EllipticMirror ProjectiveCap.PlaneOutcome \
  --lean-root lean \
  --output notes/2026-07-23-finitegeom-first-tag-source-inventory.json \
  --replace
```

The generator refuses unknown roots, import cycles, symlinked sources, paths that escape the Lean
root, implicit overwrite, and a missing output directory. Its hermetic suite covers forward closure
through a diamond and a disconnected graph, external-import classification, source hashing,
symlink refusal, and guarded atomic replacement.

## Measured boundary

The exact union contains 26 Lean files:

| Source group | Files |
|---|---:|
| `CapGame/` | 4 |
| `ProjectiveCap/` | 18 |
| `Sumfree/` | 4 |

Tokei reports 8,954 code lines, 1,156 comment lines, and 908 blank lines. This is 74 files and
16,046 code lines below the first-tag limits of 100 files and 25,000 code lines.

The closure has 18 external imports, all under `Mathlib`. It has no source under `Q16/`, `Q25/`, or
`ProjectiveCap/CertData/`; no heavyweight certificate package is therefore an input to this tag.
The public Lake rewrite needs exactly the three local libraries `Sumfree`, `CapGame`, and
`ProjectiveCap`, plus the pinned Mathlib dependency. It must not inherit the private portfolio-wide
default target list.

## Classification and blockers

- **Candidate exact copies:** all 26 inventoried Lean sources are content-addressed candidates, but
  none is admitted as referee-ready until its whole-file public-prose review passes.
- **Required public rewrites:** the first whole-closure referee pass found that the earlier
  seven-file residue scan understated the blocker. At least 17 modules contain private provenance,
  workflow labels, status prose, or retrospective implementation language. Two of those modules
  also expose workflow-bearing public paths/namespaces that require a source-owner API decision,
  and the closure has a separate module-wide scholarly-public docstring gate. The exact rewrite
  packet and evidence boundary are in
  `notes/2026-07-24-c287-first-tag-referee-review.md`. These failures must be replaced with
  self-contained mathematical prose or stable public literature by the source owners before
  export.
- **Infrastructure rewrite:** the public `lakefile.toml` must declare only the three libraries above
  and the exact Mathlib pin. The matching `lean-toolchain` is an exact copy. README, license,
  provenance document, and final source manifest are new public metadata. The public gate map and
  proof ledger have reusable sources in `lean/trust/FIRST_TAG.md` and
  `lean/trust/areas/finitegeom_first_tag.toml`. Repository visibility and license remain user
  decisions.
- **Excluded:** private notes, handoffs, scripts, caches, logs, build products, credentials,
  portfolio-only Lake targets, the uncited hyperbolic-quadric module, the disjoint `FiniteGeom`
  umbrella, and all heavyweight generated certificate families.

No Lean source was copied or edited, no generator was run over a certificate family, and no Lean,
Lake, or build-owner action was performed. The current inventory hashes independently verify
against all 26 source files.

## Next gate

Obtain the expanded source-owner rewrite and API decisions, then complete the whole-closure
declaration/docstring review recorded in
`notes/2026-07-24-c287-first-tag-referee-review.md`. The final paper target map also still needs the
eventual sum-free terminal and the external Q11/Q13 trust manifests, but those do not enlarge this
main-repository tag. Regenerate the inventory, verify that only reviewed changes altered hashes,
stage the exact source set with its public infrastructure rewrites, and run the clean public build
only in a confirmed quiet build-owner window.
