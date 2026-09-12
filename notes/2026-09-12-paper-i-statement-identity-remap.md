# Paper I statement identity: census mapping, restatement guard, and the remaining release blocker

**Lane:** `clebsch` · **Paper:** I — *Reconstructing the Clebsch Code from Its
Deep-Hole Syndrome Locus* · **Date:** 2026-09-12

Owning cards: C855 owns the theorem-map repair recorded here; C943 owns the
regenerate → trust/release gate → mirror export chain that consumes it.

## What was blocked

`verification/extract_statement_identity.py` refused with "the theorem-like
statements do not match the published claim map", so neither the statement
identity nor the trust manifest could be regenerated, and Paper I's standalone
export stayed deferred.

The refusal had two independent causes, both dating from the manuscript
rewrite that reframed the series as reconstruction (`b19233879`, 2026-08-11),
which edited both manuscripts without regenerating the identity:

1. The companion gained a formal proposition, *Projective six-arc census*
   (`prop:fifteen-class-census`): there are exactly fifteen projective classes
   of six-arcs in `PG(2,11)`, with the stabilizer orders, uncovered-set sizes,
   and least degrees of containing forms of the fifteen-class table. The claim
   ledger already owned that claim as row 58, but recorded it as the bare
   sentence "Table~\ref{tab:fifteen-classes} records the complete census needed
   below" rather than as a statement.
2. The extractor merges the statements of both manuscripts into one dictionary
   keyed by label, and `lem:chord-defect` is carried by both. The collision was
   resolved silently by dictionary overwrite.

## Resolution

**Census.** `prop:fifteen-class-census` is registered as the statement of
ledger row 58, replacing the sentence form. The row keeps its ledger identity
("adopt as the complete census table") and its existing trust route; the
sentence itself survives in the proposition's proof. The claim count is
unchanged, so the trust manifest still builds its full complement of rows.

**Restatement.** The companion restates three inputs of the geometric paper
"to make every dependency in the finite arguments explicit", and
`lem:chord-defect` is the one label carried by both manuscripts. Because they
are separately compiled documents, this is legitimate LaTeX, and the recorded
statement has always been the companion's restatement. Renaming either label
would break the restatement convention and its cross-references, so the
resolution is now declared instead of accidental: `RESTATED_LABELS` names the
restated labels, the extractor requires the repeated set to equal it exactly,
and requires each such label to resolve to the companion. A future accidental
collision fails loudly rather than silently changing which statement is
recorded.

**Two further drifts from the same rewrite, now re-recorded.** Row 2 pinned an
abstract sentence that no longer exists; it is re-recorded against the current
abstract, from "For a six-arc in ..." through "... not part of its input."
Three claims had been renamed in the manuscripts while the identity still
carried the old names: `prop:golden-normal-form` → `prop:clebsch-normal-form`,
`thm:orientation-two-graph` → `thm:conference-two-graphs`, and
`cor:orientation-cubic-geometry` → `cor:conference-cubic-geometry`. This also
clears the stale "golden operator" phrase C943 recorded in the generated
identity; no occurrence of "golden" remains in that file.

Every other claim's digest is unchanged. Only the recorded `paper_location`
line numbers moved, which is the signature of manuscripts edited without
regenerating.

Hardcoded claim counts were removed from the extractor's docstring and
argument description; a stale count is what made this failure read as a
mathematical defect rather than unregenerated drift.

## Validation

`nix run .#regenerate` completes: both manuscripts deterministic and
warning-free at 29 and 14 pages, statement identity extracted, trust manifest
written with its full complement of claim rows. `extract_statement_identity.py
--check` and `build_trust_manifest.py --check` both pass against the committed
files.

## What still blocks the release attestation and the mirror

`verify-release-output.json` still describes the previous surface. Refreshing
it requires `verify_release.py --update-output`, which takes the certificate,
finitegeom, and bridge roots, a certificate pack, and a guarded finitegeom run
receipt, and validates that the receipt was made from the clean pinned
finitegeom revision. Three things stand in the way, none of them owned by the
manuscript:

- **Pins have moved.** `FORMAL_COMPANION.json` pins finitegeom at
  `b871c10b4a91200a0913644d39b9f0ce44f655ca` and the bridge at
  `a492fd8090ca5d11d68a3640b1600dbf672a11c2`. The checkouts are at
  `f7b974379b91cff98b6399312bf2030d9c2d6f1e` and
  `1d8ab14aa4edec0bfa0e709bc48230fcb1c1a067`. The certificate package matches
  its pin at `0d964975ceef7ff0ac36216ecd0e10b4b7f2a184`. Re-pinning through the
  release verifier is C855's recorded decision, not a step this repair can take
  on its own.
- **No usable guarded receipt.** The receipts C855 recorded,
  `20260809-051043-dead8cd3` and `20260809-035240-e3c87388`, are no longer in
  the build cache; the oldest retained run is from 2026-09-08. A fresh guarded
  finitegeom run at the pinned revision is required, which is a heavy build
  under host-wide ownership.
- **The finitegeom base is unresealed.** The lane handoff records that
  `TARGET_MANIFEST.json` in finitegeom disagrees with its own tree at four
  paths because three base commits landed without resealing it, and that every
  companion export refuses until the base is resealed.

Paper I's standalone mirror is therefore still at its previous state and does
not carry the retitled companion. Its exporter audit is clean, so the sync is a
single step once the attestation is refreshed.
