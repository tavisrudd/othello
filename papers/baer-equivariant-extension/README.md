# Paper: Equivariant extension of Galois-invariant arcs

**Working title:** *Equivariant extensions of Galois-invariant arcs over finite fields.*

**Object:** extension of Frobenius/Baer-invariant arcs in PG(2,s²) (and higher-dim caps /
MDS codes) over finite fields — the unit of extension is a Galois orbit (a fixed point or a
conjugate pair). Headline = the exact quadratic-Frobenius orbit-valued conjugate-pair extension
criterion (Thm 3.1); the √2·s orbit-saturation lower bound (Cor 3.4) is a classical-scale corollary.

**Status:** source/staging directory folded into the canonical combined paper
`../equivariant-robust-completion/`. The abstract proof spine and exact coordinate quadratic
pair-extension theorem are Lean-built. Prior-art audit verdict = **SOFTEN**: the √2·s bound is the
classical Lunelli–Sce √(2q) complete-arc bound at q=s², *not* a new constant — the surviving
headline is the assembled orbit-valued criterion. The broad 2026-07-13 adversarial audit demotes
the generic application upgrades to established infrastructure. The exact invisible/support/
collision correction is now Lean-proved. The exceptional `s=5,f=2` existence theorem is also
kernel-checked in `Q25PairResult.f2_pair_extension`; a second adversarial proof audit found no
proof-validity defect, and the conclusion explicitly makes both added conjugate points fresh. The
census size and minimum 32 remain external evidence. The `f=0,4` geometry is not formalized, so
completing those profiles is the strongest open lever.

**Lean:** the proof spine is built under `lean/FiniteGeom/BaerCompletion/`, with projective-plane,
coordinate-conjugation, quadratic-Frobenius, exact line-counting, and forbidden-charge consumers
under `lean/RelativeConicArcs/`. See the lane's `TRUST.md`.

**Merge decision:** `completion-core-rigidity` is folded into this development draft as the
robustness and reconstruction layer.

**Combined development draft:**
[`paper-baer-equivariant-robust-completion.md`](../../notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md).

**Combined novelty audit:**
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
