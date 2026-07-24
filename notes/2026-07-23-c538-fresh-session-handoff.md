# C538 fresh-session handoff

**Lane:** C538 — Beyond redundancy four PRS manuscript
**Date:** 2026-07-23
**Repository working directory:** `rust/`

## Start here

Before repository work, read `AGENTS.md` and `rust/AGENTS.md` as required by
the repository instructions.  The active paper is
`papers/beyond4_prs/main.tex`; build it from that directory with:

```text
make check
```

The development monorepo is not a publication artifact.  Every paper and the
shared Lean code will be exported to separate, reviewed fresh-history
repositories.  Do not put monorepo-relative internal paths into the eventual
public release.

## User working preferences

- Use subagents for read-only audits and ask for paragraph-by-paragraph notes.
- Never run more than two subagents concurrently.
- `ev` means: identify the highest expected-value next action.
- Preserve explicit trust boundaries; certificates and Lean implications do
  not replace missing manuscript proofs.

## Current manuscript status

The referee-fix pass expanded the original 15-page research announcement into
a 30-page integrated draft.  The build is clean.  The main architecture,
trust ledgers, statement-adequacy appendix, provenance section, diagrams,
release scaffold, and staged TeX source split are committed.

The important mathematical status is:

1. R5 and R6 remain the complete classifications stated in the manuscript,
   subject to the remaining referee-facing proof-expansion/review gates in the
   trust ledger.
2. R7 is now an unconditional all-field **split-free** classification.
   Seroussi--Roth promotes it to a deep-hole classification for `q >= 11`;
   `q=7,8,9` retain a separate covering-radius gate.
3. `CC(6,1)` is closed by a characteristic-free rank--nullity proposition:
   a full first-polar line lies in the lower rank-two carrier exactly when the
   upper catalecticant has rank at most two.
4. `CC(7,1)` is also closed.  The binary central lift is empty, an identically
   colliding five-dimensional `g^4_6` is impossible, and the characteristic
   three/five nucleus lifts are shallow in the R8 range.
5. R8 is still conditional, but **only** on the explicitly named pointed
   lower splitting package `LP(6,1)`.
6. R9 retains its contained-component, six-slice, and rational-base gates.
7. The ordered-Hessian effective corollary retains its root-compatible
   pullback and global bad-union polynomial gates.
8. The DOI route C545 remains blocked.  Do not describe the manuscript as
   proof-complete or submission-ready.

## Highest-EV next action

Close `LP(6,1)`.  This is the exact remaining R8 gate and would make the
`q >= 43` redundancy-eight classification unconditional.

The task is not another contained-line calculation.  It is to construct the
full pointed R7 lower package used after three contractions:

1. print equations for every recursive cyclic, wild, inseparable, gcd, and
   branch stratum;
2. prove the required identity-Frobenius twists are geometrically integral,
   or give the exact alternative treatment for each exceptional stratum;
3. prove the genus and total three-marker deletion bound `delta=30`;
4. show that each rational point outside the deletions gives a split
   squarefree quintic avoiding the prescribed marker;
5. update the R8 theorem from conditional to unconditional only after all
   four items survive an adversarial read.

The current C513 generator/replay verifies nuclei, modular supports, shallow
witnesses, thresholds, and numerical collision budgets.  It does **not**
provide the missing recursive equations or monodromy proofs.  Do not promote
certificate regression into that geometric theorem.

## Principal files

- `papers/beyond4_prs/main.tex`
- `papers/beyond4_prs/main.pdf`
- `papers/beyond4_prs/second-draft-fix-plan.md`
- `papers/beyond4_prs/claim-proof-novelty-ledger.md`
- `papers/beyond4_prs/adversarial-proof-evidence-audit.md`
- `papers/beyond4_prs/theorem-map.md`
- `papers/beyond4_prs/verification-map.md`
- `papers/beyond4_prs/sections/README.md`
- `notes/2026-07-23-c538-second-draft-referee-fix-implementation.md`
- `notes/2026-07-23-c509-prs-redundancy-seven.md`
- `notes/2026-07-23-c512-general-polar-flag-theorem.md`
- `notes/2026-07-23-c513-prs-redundancy-eight.md`

## Recent checkpoints

- `a1c98f69` — `Revise C538 manuscript after full-draft review`
- `5615a7f8` — `Close the redundancy-seven contained-component gate`
- `d89c784a` — `Close the redundancy-eight contained-component gate`

The scoped paper/handoff paths were clean after the last checkpoint.  The
larger worktree may contain unrelated user changes; preserve them and stage
only C538-owned files.

## Source-layout note

The TeX split is deliberately staged.  The guided overview and Hankel
dictionary are already under `papers/beyond4_prs/sections/`.  The proof-heavy
sections remain in `main.tex` until their open mathematical gates stabilize.
The target one-file-per-major-section layout is recorded in
`papers/beyond4_prs/sections/README.md`.
