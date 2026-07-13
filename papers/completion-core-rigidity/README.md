# Paper: Completion-core rigidity

**Working title:** *Robust completion of finite-geometric packings and codes* (a.k.a.
"Completion-core rigidity: robustness, transversals, and new settings").

**Object:** a robustness theory for maximal feasible configurations in finite hereditary
independence systems — completion distance δ(C), its circuit-transversal characterization
(δ_x = τ), sharp values for conics/hyperovals/maximal arcs/elliptic quadrics/ovoids/spreads,
and higher-rank MDS/NRC extension resilience. Strongest new candidates = the twisted-cubic
external-orbit δ_x spectrum and the relative multiple-saturation parameter t_h(q).

**Status:** theorem-package plan, no manuscript. The abstract infrastructure is `[PROVED]`
but overlaps known defining-set / trade / saturation theory (not headline). The strongest new
pieces are `[OPEN]` — twisted-cubic transversal spectrum (§6.5), t_h(q), asymptotics of γ(q).
Gated on a MathSciNet / Storme–Szőnyi hypothesis audit plus one new headline computation.

**Swing piece:** this is the candidate most likely to collapse — its own Stage C says: if the
headline computation lands, publish standalone; if not, retain the sharp deletion theorem +
classical applications as a **companion section of `baer-equivariant-extension`**.

**Lean:** the δ_x = τ identity is landed and `sorry`-clean —
`lean/FiniteGeom/Completion.lean` (`completionDistance_eq_transversalNumber`). The full
`CompletionCore` library (Phase 2) is planned, not built.

## Files here (symlinks into ../../notes/)

- `2026-07-10-completion-core-rigidity-upgrades.md` — the theorem-package note
- `2026-07-11-twisted-cubic-axis-lrc-audit-scope.md` — audit (shared with the coding/LRC lane;
  audits §2 recovery-spectrum, §3 MDS-shortening, §6.5 twisted-cubic transversal spectrum)

See `../papers-index.md` and `../papers-planning.md`. Parent audit: Package 2 in
`../../notes/2026-07-10-codex-publishable-spinout-audit.md`.
