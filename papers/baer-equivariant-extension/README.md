# Paper: Equivariant extension of Galois-invariant arcs

**Working title:** *Frobenius-equivariant pair extension of eight-arcs in `PG(2,25)`.*

**Object:** extension of Frobenius/Baer-invariant arcs in PG(2,s²) (and higher-dim caps /
MDS codes) over finite fields — the unit of extension is a Galois orbit (a fixed point or a
conjugate pair). Headline = the exact quadratic-Frobenius orbit-valued conjugate-pair extension
criterion (Thm 3.1); the √2·s orbit-saturation lower bound (Cor 3.4) is a classical-scale corollary.

**Status:** source/staging directory feeding the focused canonical manuscript
`../equivariant-robust-completion/`. The broad merge is superseded: the generic completion package
does not supply a family-specific bridge to the Q25 theorem. The exact coordinate quadratic
pair-extension theorem are Lean-built. Prior-art audit verdict = **SOFTEN**: the √2·s bound is the
classical Lunelli–Sce √(2q) complete-arc bound at q=s², *not* a new constant — the surviving
headline is the assembled orbit-valued criterion. The broad 2026-07-13 adversarial audit demotes
the generic application upgrades to established infrastructure. The exact invisible/support/
collision correction is now Lean-proved, including the generic `s+3-f-e` invisible-carrier bound
for cross-pair orbits. The exceptional `s=5,f=2` existence theorem is kernel-checked in
`Q25PairResult.f2_pair_extension`; a second adversarial proof audit found no
proof-validity defect, and the conclusion explicitly makes both added conjugate points fresh. The
census size and minimum 32 remain external evidence. The certificate-free
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
focused submission. A future alternate-orbit repair or fixed-locus resilience theorem may add a
tightly scoped robustness section without restoring the broad generic package.

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
