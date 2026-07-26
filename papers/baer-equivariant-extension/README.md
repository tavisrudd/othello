# Retired source view: Frobenius-equivariant pair extension

**Canonical paper:** [`equivariant-robust-completion`](../equivariant-robust-completion/) —
*Frobenius-equivariant pair extension and robust repair of eight-arcs.*

**Lane:** `paper-frob-eq`.

This directory is a retained historical source view, not a paper candidate.
Its theorem-package notes and audits feed the canonical manuscript.  All
publication status, adopted results, title, and release gates are owned by
the canonical directory and the `paper-frob-eq` handoff.

**Status:** merged into the focused canonical manuscript. The generic completion package
does not supply a family-specific bridge to the Q25 theorem. The exact coordinate quadratic
pair-extension theorem are Lean-built. Prior-art audit verdict = **SOFTEN**: the √2·s bound is the
classical Lunelli–Sce √(2q) complete-arc bound at q=s², *not* a new constant — the surviving
headline is the assembled orbit-valued criterion. The broad 2026-07-13 adversarial audit demotes
the generic application upgrades to established infrastructure. The exact invisible/support/
collision correction is now Lean-proved, including the generic `s+3-f-e` invisible-carrier bound
for cross-pair orbits. The exceptional `s=5,f=2` existence theorem is kernel-checked in
`Q25PairResult.f2_pair_extension`; a second adversarial proof audit found no
proof-validity defect, and the conclusion explicitly makes both added conjugate points fresh. The
successor work proves the exact semantic minimum `32` and classifies its equality cases as five
residual-group orbits up to normalization. The certificate-free
`Q25ProfileFour.profile_four_pair_extension` also kernel-checks the `f=4` profile from center
incidence and exact balance. The certificate-free `Q25ProfileZero.profile_zero_pair_extension`
kernel-checks the `f=0` moment geometry and at least five legal pairs, while
`Q25AllProfiles.pair_extension` proves the uniform result. C135 kernel-checks the exact aggregate
equality/excess classification; this is algebraic bookkeeping, not the still-open structural inverse
problem.

**Lean:** the proof spine is built under `lean/FiniteGeom/BaerCompletion/`, with projective-plane,
coordinate-conjugation, quadratic-Frobenius, exact line-counting, and forbidden-charge consumers
under `lean/RelativeConicArcs/`. See the lane's `TRUST.md`.

**Scope boundary:** `completion-core-rigidity` is reusable generic infrastructure, not part of the
focused submission. Robust alternate-orbit repair and the exact Q25 extremal classification are
now adopted by the canonical manuscript; the unfinished exchange graph remains optional future
work.

**Focused development manuscript:**
[`paper-baer-equivariant-robust-completion.md`](../../notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md).

**Novelty audit:**
[`2026-07-13-baer-completion-adversarial-novelty-review.md`](../../notes/2026-07-13-baer-completion-adversarial-novelty-review.md).

**Collision proof ledger:**
[`2026-07-13-c99-baer-collision-strengthening.md`](../../notes/2026-07-13-c99-baer-collision-strengthening.md).

## Files here (symlinks into ../../notes/)

- `2026-07-10-baer-equivariant-extension-upgrades.md` — the theorem-package note
- `2026-07-11-baer-extension-audit-scope.md` — external citation audit (the SOFTEN verdict)
- `2026-07-10-codex-odd-plane-round7-generator-growth-baer.md` — origin (Baer obstruction, q=25 block)
- `2026-07-09-codex-q25-baer-census.md` — q=25 Baer census (supporting data)

See `../papers-index.md` and `../papers-planning.md`. Parent audit: Package 2 in
`../../notes/2026-07-10-codex-publishable-spinout-audit.md`.
