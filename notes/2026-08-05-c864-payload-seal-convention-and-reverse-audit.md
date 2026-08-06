# C864 — non-Lean payload seal convention and the reverse-direction source audit

**Lane:** `build-sys` · **Date:** 2026-08-05

**Verdict: a package's non-Lean payload is now sealed one way — a single `support_files` list
covering every generator, replay program, replay input, canonical output, and gate evidence file —
and the source audit reads all three historical shapes, so no package has to be resealed out of
band.  The audit also runs in reverse: it reports authority files inside an owned family that the
package does not seal.  Both adopted packages are complete against their authority; both carry
payload their manifests never sealed, and the order-25 candidate is 1,786 files behind, which the
audit now finds mechanically rather than by comparing counts across two reports.**

## Replay

```sh
lean/scripts/lean-package-source-audit.py ~/src/lean/finitegeom-q16-certificates \
  --authority f0050f5c~1 --source-prefix ''
lean/scripts/lean-package-source-audit.py ~/src/lean/finitegeom-clebsch-q11-certificates \
  --authority 0ddbca65
lean/scripts/lean-package-source-audit.py ~/src/lean/finitegeom-q25-certificates \
  --authority HEAD --source-prefix '' \
  --declared-transformation q25-banner-normalization-v1 \
  --family-prefix lean/RelativeConicArcs/Q25
python3 -m unittest test_lean_package_source_audit   # in lean/scripts
```

The audit reads committed Git objects and the package worktree.  No Lean, no Lake, no lock, no
writes.

## The convention

Generated Lean sources are sealed exactly, one manifest entry per file.  Everything else a
certificate package carries had been sealed by convention, and the convention differed per package:
the order-16 package records one `generator` object plus a `verification_artifacts` list, the
order-eleven package records `generator` alone, and the order-25 candidate records nineteen
`support_files`.  Nothing required any of them and nothing checked any of them, so a package could
ship a generator it never sealed, or seal one and then edit it, and every existing gate stayed
green.

The settled rule, now in the card's cache and build contract:

- One list, `support_files`, holding every payload file with its path, byte count, and SHA-256.
- Payload is what the artifact's evidence rests on: generators, replay programs, replay inputs,
  canonical outputs, gate evidence.  Everything under `scripts/`, `artifacts/`, `evidence/`, and
  `verification/` is payload and must appear.
- Packaging is not payload and is not listed: flake, lakefile, toolchain pin, licence, citation,
  README, and the manifest-sealing program itself.
- `generator` and `verification_artifacts` are earlier spellings of the same thing.
  `lean-package-source-audit.py` reads all three and folds them into one set.

Reading the legacy shapes is what makes this landable today.  Rewriting an adopted package's
manifest changes its hash, which the monorepo pins in `certificate-packages.toml` and which its
published trust fact records, so a migration would drag both packages through a reseal and a re-pin
for a bookkeeping change.  Instead the audit reports the gap and each package adopts `support_files`
at its next reseal — for the order-eleven package, the finitegeom re-export window that is already
scheduled to reseal it.

## The reverse direction

The forward audit iterates the package's sealed sources, so it can say that every file the package
holds is faithful and still not notice that the authority holds three hundred more.  That is not a
hypothetical: the order-25 candidate's shortfall was found earlier by comparing file counts printed
by two different tools, which is not evidence anyone should have to reconstruct.

`--family-prefix` names an authority path prefix the package owns, and every authority file under it
that the package does not seal is reported as `missing-from-package`.  With no flag the prefixes come
from the package's declared `owned_module_prefixes` in `certificate-packages.toml`, so a package the
boundary configuration already knows needs no second declaration of what it owns.

A module prefix is not a path, and the mapping is where this silently fails.  Packages root their
modules differently — the order-eleven package at its root, the order-16 package under `lean/` — and
a prefix built on the wrong assumption matches no authority file at all, which reports a package as
complete precisely when the audit is broken.  Each prefix is therefore anchored against a sealed
source that carries it, and a prefix anchoring nowhere is reported as an owned family with no sealed
source rather than passed over.  The first draft of this pass had exactly that bug and reported the
order-16 package complete; the fixture set now pins both layouts and the unanchored case.

## Results

| package | authority | sealed sources | missing from package | sealed payload | unsealed payload |
|---|---|---|---|---|---|
| `finitegeom-q16-certificates`         | `c361561b` (`f0050f5c~1`) | 1,331 | 0 | 5 | 0 |
| `finitegeom-clebsch-q11-certificates` | `0ddbca65`                | 122   | 0 | 1 | 2 |
| `finitegeom-q25-certificates`         | `HEAD`                    | 9,531 | 1,786 | 19 | 0 |

Both adopted packages hold every authority file in the families they own.  That is the first
positive statement of completeness either has had; until now the audit could only say that what they
hold is faithful.

The order-16 package's payload is fully sealed under the convention as it stands.  The order-eleven
package's two unsealed files are its `verification/clebsch_rigidity_trust/` axiom audit and gate log:
gate evidence, which belongs in `support_files` at its reseal.  The sealing program itself,
`scripts/seal_manifest.py` in both packages, is exempt in the tool as well as in the prose — it
produces the seal rather than being covered by it.

The order-25 candidate is the mirror image: its payload is completely sealed, in the shape the
convention adopts, and its sources are 1,786 files behind across nine families.  The externalization
already plans to re-extract rather than adopt those sources, so the number is a measurement of how
stale the candidate is, not work to do on it.

## Exit codes

Missing authority files and unsealed payload are reported always and set the exit code only under
`--strict`, because both adopted packages predate the convention and cannot be resealed outside
their release windows; making the ordinary audit red today would only teach the reader to ignore it.
Payload that is sealed and then edited, or sealed and then absent, is a defect with no flag — that
is drift, not a pending migration — as is an owned family with no sealed source.  At closeout
`--strict` becomes the required form, once both packages have migrated.

## What this leaves

The order-eleven package's reseal, in the finitegeom re-export window, adopts `support_files` and lists
its two gate-evidence files; that single change makes `--strict` passable for it.  The order-16
package's payload already satisfies the convention and only its field names change, at whatever
window next reseals it.
