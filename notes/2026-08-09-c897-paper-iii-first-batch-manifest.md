# C897 Paper III first sealed cold-read batch

**Lane:** `clebsch`

**Date:** 2026-08-09

**Standalone commit:** `7208275e6b5f979fea487d2130943bbd979aed37`

**PDF SHA-256:**
`6794202d653d6908b495120c47848162a15d357c1438611e9e42f10384472622`

**Persona dossier SHA-256:**
`12fd05f3ace288282075432a303214ea37d606b658e9967540e4b316efe7f8f8`

The PDF and permitted supplement paths were clean at launch, so the readers
see the recorded commit rather than uncommitted mirror state.
The frozen Git object IDs for `README.md`, `ARTIFACT.md`,
`literature-boundaries.md`, and the `sections/` tree are respectively
`13e425081b12e5d141fdb94bf2fdde3b64c478d4`,
`c8edc87d9ed461b08599cbcfd60c90a366ddb953`,
`77a98791f07f7b51de91e973bdee37f6c89ebd02`, and
`6faefe20633d655aa88d965f939d3f73ffb42cc0`.

Before launch, `litcache.py verify` rehashed all 534 shared-cache entries and
reported zero problems.  This verifies the packet bytes; it does not enlarge
the dossier's recorded reading depth.  Every cached key named in packets H, G,
X, and R also resolved locally before dispatch.

## Isolation

The four readers receive only the frozen standalone PDF and supplement, the
shared neutral protocol in the C897 dossier, and one of packets H, G, X, or R.
They do not receive a lane handoff, task card, ordinary Paper III notes, an
earlier review, or another reader's report.  Each reader freezes a PDF-only
assessment before consulting the permitted supplement.  The supplement may
confirm or change a finding but may not serve as a human-proof premise.

On-disk reports use categorical verdicts only.  Numerical grades remain in
chat.  Reports are frozen independently before the coordinator opens them for
cross-comparison.

## Assigned reads

1. Hitchin persona: rational incidence, geometric descent, marking boundary,
   and harmonic normalization.
2. Greaves persona: conference designs, switching, exchange moments, and the
   finite sign table.
3. Snowden persona: signed outer coordinates, Segre--Igusa conventions, and
   exact versus projective normalization.
4. Si Kaddour persona: reconstruction up to complement, seven-point
   propagation, related-work comparison, and query model.

## Frozen outputs

- `notes/2026-08-09-c897-paper-iii-hitchin-cold-read.md`;
- `notes/2026-08-09-c897-paper-iii-greaves-cold-read.md`;
- `notes/2026-08-09-c897-paper-iii-snowden-cold-read.md`;
- `notes/2026-08-09-c897-paper-iii-si-kaddour-cold-read.md`; and
- `notes/2026-08-09-c897-paper-iii-cold-read-synthesis.md` after all four
  reports are frozen.

No manuscript, Lean, trust, mirror, publication, or contact action belongs to
this batch.
