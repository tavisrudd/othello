# Paper: Completion-core rigidity

**Working title:** *Robust completion of finite-geometric packings and codes* (a.k.a.
"Completion-core rigidity: robustness, transversals, and new settings").

**Object:** a robustness theory for maximal feasible configurations in finite hereditary
independence systems — completion distance δ(C), its circuit-transversal characterization
(δ_x = τ), classical values for conics/hyperovals/maximal arcs/elliptic quadrics/ovoids and line
spreads of `PG(3,q)`,
and higher-rank MDS/NRC extension resilience. Strongest new candidates = the twisted-cubic
external-orbit δ_x spectrum and the relative multiple-saturation parameter t_h(q).

**Status:** source/staging view folded into the combined manuscript. The abstract infrastructure is
`[PROVED]` but is standard hitting-set, defining-set, and saturation theory under a checked common
interface (not headline). The strongest new
pieces are `[OPEN]` — twisted-cubic transversal spectrum (§6.5), t_h(q), asymptotics of γ(q).
The combined paper's broad novelty audit is complete; exact-formula specialist priority review and
one new family-specific strengthening remain.

**Merge decision:** retain the sharp deletion theorem and classical applications as the robustness
and reconstruction layer of the combined `baer-equivariant-extension` development draft.

**Lean:** the semantic δ_x = τ identity, completion-core radius, weighted and multi-insertion
extensions, and robust-obstruction results are landed and `sorry`-clean under
`lean/FiniteGeom/BaerCompletion/`. They are being developed as part of the combined
Baer/completion paper.

**Combined development draft:**
[`paper-baer-equivariant-robust-completion.md`](../../notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md).

**Combined novelty audit:**
[`2026-07-13-baer-completion-adversarial-novelty-review.md`](../../notes/2026-07-13-baer-completion-adversarial-novelty-review.md).

## Files here (symlinks into ../../notes/)

- `2026-07-10-completion-core-rigidity-upgrades.md` — the theorem-package note
- `2026-07-11-twisted-cubic-axis-lrc-audit-scope.md` — audit (shared with the coding/LRC lane;
  audits §2 recovery-spectrum, §3 MDS-shortening, §6.5 twisted-cubic transversal spectrum)

See `../papers-index.md` and `../papers-planning.md`. Parent audit: Package 2 in
`../../notes/2026-07-10-codex-publishable-spinout-audit.md`.
