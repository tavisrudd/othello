# C287 first-tag source contract

**Lane**: `build-sys`
**Status**: CANDIDATE SOURCE INVENTORY FROZEN; public prose review and rewrites remain

## Contract

The first `finitegeom` tag uses the shared-library umbrella plus the positive mirror outcomes
declared by `papers/nofil-finite-geometry-outcomes/README.md`:

- `FiniteGeom`
- `ProjectiveCap.Mirror`
- `ProjectiveCap.Binary`
- `ProjectiveCap.EllipticMirror`
- `ProjectiveCap.HyperbolicQuadricMirror`
- `ProjectiveCap.PlaneOutcome`
- `CapGame.Affine`

The content-addressed inventory is
`notes/2026-07-23-finitegeom-first-tag-source-inventory.json`. It records schema version 1, the
seven roots, every project-local source in their transitive import closure, byte counts, SHA-256
hashes, and the union of external imports. The inventory is ordered by repository-relative
destination path and contains no absolute path.

Generate it from tracked source headers with:

```sh
python3 lean/scripts/lean-blast-radius.py closure \
  FiniteGeom ProjectiveCap.Mirror ProjectiveCap.Binary \
  ProjectiveCap.EllipticMirror ProjectiveCap.HyperbolicQuadricMirror \
  ProjectiveCap.PlaneOutcome CapGame.Affine \
  --lean-root lean \
  --output notes/2026-07-23-finitegeom-first-tag-source-inventory.json \
  --replace
```

The generator refuses unknown roots, import cycles, symlinked sources, paths that escape the Lean
root, implicit overwrite, and a missing output directory. Its hermetic suite covers forward closure
through a diamond and a disconnected graph, external-import classification, source hashing,
symlink refusal, and guarded atomic replacement.

## Measured boundary

The exact union contains 51 Lean files:

| Source group | Files |
|---|---:|
| `CapGame/` | 4 |
| `FiniteGeom/` | 23 |
| `FiniteGeom.lean` | 1 |
| `ProjectiveCap/` | 19 |
| `Sumfree/` | 4 |

Tokei reports 12,987 code lines, 2,007 comment lines, and 1,336 blank lines. This is 49 files and
12,013 code lines below the first-tag limits of 100 files and 25,000 code lines.

The closure has 41 external imports, all under `Mathlib`. It has no source under `Q16/`, `Q25/`, or
`ProjectiveCap/CertData/`; no heavyweight certificate package is therefore an input to this tag.
The public Lake rewrite needs exactly the four local libraries `FiniteGeom`, `Sumfree`, `CapGame`,
and `ProjectiveCap`, plus the pinned Mathlib dependency. It must not inherit the private
portfolio-wide default target list.

## Classification and blockers

- **Candidate exact copies:** all 51 inventoried Lean sources are content-addressed candidates, but
  none is admitted as referee-ready until its whole-file public-prose review passes.
- **Required public rewrites:** 10 files cite private `notes/` or handoff paths. Three of those also
  contain task IDs: `ProjectiveCap/PlaneOutcome.lean`,
  `ProjectiveCap/IntrusionCalculus.lean`, and
  `ProjectiveCap/HyperbolicQuadricMirror.lean`. These reverse references violate the public Lean
  boundary and must be replaced with self-contained mathematical prose or stable public literature
  by the source owners before export.
- **Infrastructure rewrite:** the public `lakefile.toml` must declare only the four libraries above
  and the exact Mathlib pin. The matching `lean-toolchain` is an exact copy. README, license,
  public gate map, proof ledger, provenance document, and final source manifest are new public
  metadata. Repository visibility and license remain user decisions.
- **Excluded:** private notes, handoffs, scripts, caches, logs, build products, credentials,
  portfolio-only Lake targets, and all heavyweight generated certificate families.

No Lean source was copied or edited, no generator was run over a certificate family, and no Lean,
Lake, or build-owner action was performed. The current inventory hashes independently verify
against all 51 source files.

## Next gate

Obtain source-owner rewrites for the ten reverse-referencing modules and complete the whole-closure
referee review. Then regenerate the inventory, verify that only reviewed changes altered hashes,
stage the exact source set with its public infrastructure rewrites, and run the clean public build
only in a confirmed quiet build-owner window.
