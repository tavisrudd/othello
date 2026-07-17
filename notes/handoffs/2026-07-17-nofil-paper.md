# Nofil finite-geometry outcomes paper

**Lane**: `nofil`

**Date**: 2026-07-17

## Goal

Bring `papers/nofil-finite-geometry-outcomes` (the games flagship, ship-order #1) to the
arcs/clebsch release bar: write the already-Lean-proved projective mirror outcomes into the
manuscript, complete LaTeX+PDF, a trust ledger for the finite-game Lean libraries, the recorded
sharpness-negative release gate, a cleared novelty audit, and adversarial + cold-prose review.

## Current status

- Manuscript: `notes/paper-sumfree-capgame/main.tex` (symlinked as
  `papers/nofil-finite-geometry-outcomes/paper-sumfree-capgame/`). Covers only the sum-free ℤₙ game
  and the affine AG(n,q) cap game; every paragraph flagged `DRAFT — SUBJECT TO LEAD-AUTHOR
  REVISION`; title/author block is placeholder. The Open Problems section still poses the projective
  case as open.
- Projective content: the mirror⇒P projective theorems (PG(n,2), elliptic Q⁻, even-q planes,
  hyperbolic quadrics) are already Lean-proved sorry-free in `lean/ProjectiveCap/` and
  `lean/CapGame/` but are unwritten. The write-up asset is the evidence-tagged D1 skeleton:
  `notes/2026-07-09-d1-outcome-classes-manuscript.md`,
  `notes/2026-07-09-codex-d1-manuscript-skeleton.md`,
  `notes/2026-07-08-projective-mirror-proof-kernels.md`.
- Planning rulings: `papers/papers-planning.md` ship-order #1, ruling D1 (FOLD — projective outcomes
  become the flagship's projective section; no standalone projective paper; no standalone sum-free
  paper; if the flagship balloons, cut capacity-c, never sum-free). Ruling D4 keeps the open
  odd-plane conic-localization kernel as the flagship's open-frontier section only.
- Novelty audit: `notes/2026-07-08-codex-projective-nofil-novelty-audit.md` is done and conservative;
  one diligence item is open (Clark–Mancini–Van Hook full text unread).
- No `lean/TRUST.md`-standard ledger exists for `lean/ProjectiveCap/` or `lean/CapGame/`; axiom
  profiles appear only as prose in the `cap` handoff.

## Open frontiers

- Projective mirror-outcomes section is unwritten and the manuscript still frames the projective case
  as open (C265).
- Sharpness negatives short of the recorded release gate: the elliptic Q⁻ method-negative needs a
  Scharlau/Witt-transfer lemma; the boundary negatives and capacity-2 sharpness need to reach the
  recorded internal gate (parabolic + Hermitian negatives are already rigorous) (C266).
- Novelty audit has one open read (Clark–Mancini–Van Hook) gating any hardened "first" language
  (C267).
- No trust ledger for the finite-game Lean libraries (C268).
- Manuscript has had no arcs/clebsch-bar review cycle and no PDF (C269).
- Public-artifact citation the paper depends on is not yet minted; the first extraction is C270,
  owned here.

## Next steps

- **C265** — write the projective mirror-outcomes section into `main.tex` per ruling D1: fold in the
  Lean-proved PG(n,2)/elliptic/even-q/hyperbolic mirror⇒P theorems, retire the "projective case open"
  framing, and clear the DRAFT flags and placeholder title/author block.
- **C266** — implement the recorded sharpness-negative release gate (do not re-decide it):
  Scharlau/Witt-transfer lemma for the elliptic Q⁻ method-negative, plus boundary negatives and
  capacity-2 sharpness to the recorded internal gate.
- **C267** — close the novelty audit: obtain and verify the Clark–Mancini–Van Hook full text, then
  harden or retain the qualified language per the audit's instruction.
- **C268** — create the `lean/TRUST.md`-standard ledger for `lean/ProjectiveCap/` + `lean/CapGame/`
  (axiom audit, no-`sorry`/no-`native_decide` statement, adequacy notes).
- **C269** — full-manuscript pass to the arcs/clebsch bar: complete LaTeX+PDF, adversarial review,
  repeated cold-prose review.

## Cross-lane relationships (foreign; do not re-peg without approval)

The open mathematical program under this paper's geometries is `cap`-owned, not here. This lane owns
the manuscript; the `cap` lane owns the open math:

- **C84 `[cap]`** — abundance-first conic-involution Schreier program (the open odd-plane kernel),
  `notes/2026-07-12-conic-involution-residual-graphs.md`.
- **C189 `[cap]`** — q=5 octahedral-frame game bridge (a queued cross-paper seed, not yet a
  manuscript theorem), `notes/2026-07-15-c189-q5-octahedral-frame.md`.
- **C198 `[cap]`** — bounded q=7 BSW exterior-four-arc residual scout,
  `notes/2026-07-15-c198-q7-exterior-residual-scout.md`.

The odd-plane kernel is the flagship's open-frontier section only (ruling D4); it does not gate the
projective outcomes write-up.

The public-mirror / first-extraction deliverable (C270) is owned by this lane: the first extraction
is the `FiniteGeom` base plus the Lean-complete mirror outcomes, and it gates this paper's
public-artifact citation per the *Arcs vs Nofil* ruling. Re-pegged from `[build-sys]` on user
approval, 2026-07-17.
