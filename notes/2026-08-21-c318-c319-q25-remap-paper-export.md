# C318/C319 — Q25 certificate remap and standalone-paper setup

**Lane:** `paper-frob-eq` · **Date:** 2026-08-21 · **Status:** REPORTED

## Outcome

The equivariant-repair paper now points to the already sealed, Mathlib-only
`finitegeom-q25-certificates` package instead of treating the removed monorepo forest as its live
formal artifact.  No Q25 source was regenerated, re-extracted, or rebuilt.

The pinned package identity is:

- commit `d4e910cf01819a8678fd84422bb18fe23f4d6695`;
- `MANIFEST.json` SHA-256
  `4f3d252a453c7217a8a8aaf7b27374794396e2d0b4101c7c8b85683deaa52292`;
- aggregate `TavisRuddFiniteGeom.Certificates.Q25`;
- 9,511 sealed Lean modules: 9,492 generated certificate modules and 19 handwritten
  Mathlib-only modules.

This is the same separation pattern used by the adopted order-eleven and order-thirteen
certificate packages: the certificate repository owns its concrete model, checkers, generated
tables, and aggregate; a paper-facing layer records exactly which terminal it consumes.

## Trust reconciliation

`lean/RelativeConicArcs/TRUST.md` now records the normalized Q25 theorem map and inventories all
thirteen regenerated residual-data families with their module counts and consuming checker.  Its
trusted-surface statement distinguishes:

- generic leaves, where literal line, carrier, and allowed masks instantiate a shared proved
  predicate; and
- bespoke leaves, where point images, bad triples, dispatcher alternatives, and literal
  canonical-class links are checked row by row.

The second class is kernel checked but has a review surface that grows with the forest.  C319 is
therefore resolved without the measured two-hour canonicalizer rebuild: retain the exact normalized
classification as a sealed kernel-checked certificate, disclose the literal-link boundary, and do
not describe the package as proving the semantic projective transport.  The two projective
normalizations and transport back to arcs are manuscript arguments.

The two C151 reports now point their mask-spectrum replay at the package-local
`scripts/minimum-mask-spectrum.py` and `artifacts/minimum-mask-spectrum.json`.  The source-only replay
was green in the extracted working snapshot (`OK`, with the independent CSV cross-check agreeing),
and the paper pin points to the sealed package commit rather than that working snapshot.

## Paper and export

The manuscript, README, and new `verification/` directory now state the split consistently.  The
tracked PDF was rebuilt with Tectonic, warning-free, and is 15 A4 pages.  Identities are:

| Artifact | SHA-256 | Bytes |
|---|---|---:|
| `frobenius_pair_extension.tex` | `86ddf66f79fc2d6bfccb6c1eb51e40a488c5e9f76ceb6246e01337c1fde117ac` | 41,724 |
| `frobenius_pair_extension.pdf` | `bb3a76b6e028fc66062efdf49d55c35fcd590fa8cc93c2b28e81ae2a9325bec6` | 120,967 |
| `verification/q25-certificate-pin.json` | `749c230c3bd818602e5d0a2c2ebdb3e9507b0f30af012cac13fd2025f49319ef` | 1,158 |

The immutable authority commit `8e2d7568705c8aad21001db30a6e0db403ed11d7` passed the paper exporter plan
and audit with five exported authority files, zero reference findings, and the PDF excluded by the
registered source-release policy.  The exporter materialized
`~/src/math-papers/equivariant-robust-completion`; it was initialized on `main` and committed as
`3cb2c88` (`Initial standalone paper export`).  Export verification reports eight tracked files and
a clean tree.  No remote was added and nothing was pushed.

The global trust-spine audit accepted the new Q25 package fact but remains red on 100 pre-existing
portfolio findings, chiefly absent extraction facts and unreached modules; it is not represented as
a green release gate for this paper.

## Build boundary

No Lean or Lake command ran.  In particular, neither the 9,511-module package aggregate nor any
generated subtree was compiled.  A future full `nix run .#verify` in the package would include the
large certificate build and requires explicit warning to the user before it is started.  Ordinary
paper synchronization and a cheap compatibility bridge do not require regenerating or rebuilding
the Q25 forest.
