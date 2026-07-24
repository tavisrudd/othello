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
5. R8 is unconditional for `q >= 43`.  The pointed lower package
   `LP(6,1)` now has explicit recursive rank/gcd, cyclic/wild/inseparable,
   branch, and marker-collision equations; the geometric-`S3` identity
   twist and deletion degree `30`; direct gcd-one treatments; and two
   independent adversarial passes.
6. R9 retains its contained-component, six-slice, and rational-base gates.
7. The ordered-Hessian effective corollary retains its root-compatible
   pullback and global bad-union polynomial gates.
8. The DOI route C545 remains blocked.  Do not describe the manuscript as
   proof-complete or submission-ready.

## Highest-EV next action

Close the R9 six-slice and rational-base gate.  Print the six reduced
discriminants, their Bézout identity, every multiple-root branch
polynomial, and one nonzero rational-base polynomial with its exact degree
accounting.  This is now the nearest fixed-level theorem blocker; the
ordered-Hessian global bad-union polynomial remains the other open
mathematical gate.

`LP(6,1)` is closed in
`notes/2026-07-23-c538-lp61-pointed-lower-package.md`.  Do not reopen its
generic monodromy calculation without a concrete inconsistency.

The C513 generator/replay verifies nuclei, modular supports, shallow
witnesses, thresholds, and numerical collision budgets.  The separate
`LP(6,1)` report supplies the geometric theorem; certificate regression was
not promoted into monodromy evidence.

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
