# Cubic threefolds after stabilization

**Lane:** `cubic-threefolds`

**Date:** 2026-08-15

> **LIVE MAP ONLY.** This is the routing and state surface for this lane.
> Per-task detail belongs in the task cards under `notes/cubic-threefolds-tasks/`;
> proof-level detail belongs in the dated notes those cards link to.

## Origin and scope

Split off from the `clebsch` lane on 2026-08-15. This lane owns the
research-only successor program that grew out of Clebsch Paper V's
(`papers/chordal-conference-reconstruction/`) cubic-threefold epilogue:
quantum-monodromy stabilization, the relative Chow/cycle-theory frontier,
and adjacent structural research on cubic threefolds. It does **not** own
Paper V itself or the numbered Clebsch series — those stay in `clebsch`.

**C912 and C913 were re-pegged to this lane on 2026-08-15 by author
instruction**, and with them the paper root *Irrationality of Cubic Threefolds
after One Stabilization* (`papers/cubic-stabilization-irrationality/`). Both are
active and author-close only: C912 owns the referee-foundation repairs, C913 the
referee revision pass on the same manuscript, so the two must stay sequenced
against each other rather than editing it concurrently.

## Formal standard (when Lean-facing)

Any declaration this lane promotes to Lean (currently only C910's epilogue
companion) meets the same standard as the numbered Clebsch series: no
`sorry`, no `native_decide` or compiled-evaluation axiom at any terminal, no
project axiom or assumed hypothesis standing in for a proof, and every
promoted mathematical assertion maps to a kernel-checked declaration.

## Current status

- **C912 — referee-facing follow-on paper, active, author-close only.**
  *Irrationality of Cubic Threefolds after One Stabilization*
  (`papers/cubic-stabilization-irrationality/`). The owed frame-transport lemma
  for referee A is narrowed to invariance of the framed spectrum under one
  positive-filtration bulk displacement; card:
  [`c912-cubic-stabilization-referee-foundations.md`](../cubic-threefolds-tasks/c912-cubic-stabilization-referee-foundations.md),
  analysis in `notes/2026-08-15-c912-frame-transport-memo.tex` and its PDF.
- **C913 — referee revision pass, active, author-close only.** Local
  frame/source repairs, modular hypothesis presentation and expanded proofs on
  the same manuscript, before the next frozen cold-read cycle; card:
  [`c913-cubic-stabilization-fable-revisions.md`](../cubic-threefolds-tasks/c913-cubic-stabilization-fable-revisions.md).
- **C907 — quantum monodromy stabilization, active.** v1 is unconditional:
  framed formal monodromy of the numerical small quantum connection, followed
  through Iritani's blow-up comparison, proves `X x P^1` irrational for every
  smooth cubic threefold (`papers/cubic-stabilization-epilogue/`, Silver
  tier). Gold (`m=2`) is reduced to a minimal nilpotent `K[N]` packet on the
  whole generalized `zeta_6` sector: endpoint `J_3`, strict blowup
  biproducts, and no center `J_3` imply irrationality; a `J_3` requires
  `nu_6>=6`, and the two-block strictness obstruction is one explicit
  `Ext^1_(K[N])` class. One exact localizing, Orlov-additive,
  `K_0`-linear/derived-Gysin `Phi_6` packet functor vanishing on all
  low-dimensional supports would kill every base-ideal extension and prove
  `m=2` by relative factorization; a formal-space projector is too weak, and
  linear projection shows raw `K_0` can already create `J_3`. Higher
  codimension needs a non-split exceptional string, so this Gold mechanism
  does not naively extend to Platinum (`m` arbitrary), which remains open.
  No Paper V or Lean promotion follows automatically. Card:
  `../cubic-threefolds-tasks/c907-quantum-monodromy-stabilization.md`; solver dossier:
  `../cubic-threefolds-tasks/c907-solver-dossier.md`; closed-phase archive:
  `../cubic-threefolds-tasks/c907-quantum-monodromy-stabilization-archive.md`.
- **C908 — Annals-upgrade mathematics, active.** Continues the highest-ceiling
  mathematics left by C904/Paper V after the fibrewise minimal-class theorem
  and the one-stabilization epilogue: priority A is the intrinsic relative
  Chow index of the generic unordered-theta fibre (`ind(Y)=1` vs `2`);
  priority B is the intrinsic `p`-typical divisor-product classification.
  Proved an integral lattice theorem for `H^3(Bl_0Θ,Z)` (torsion-free rank
  130, escape group free of rank ten, correcting a prior `(Z/2)^10`
  misidentification) — a candidate for its own paper, scoping pending the
  user. The priority-A `(1,5)` Chow-index channel is closed negative for
  every named source; priority A itself remains undecided. Card:
  `../cubic-threefolds-tasks/c908-annals-math-upgrades.md`.
- **C909 — cycle-side crown, active.** Extracts intrinsic cofactor-saturation
  and atom-carrier theorems from the epilogue; C907 retains higher-stabilization
  quantum work and C908 retains relative Chow / full `p`-typical
  classification. Full ordinary cohomological saturation of the prescribed
  graph divisor lattice is proved intrinsically; the actual six-axis
  four-slot quotient audit is now positive (unit line plus depth-one
  rank-four block, Pluecker defect vanishes), passing two independent
  hostile/priority audits. The higher-rank Dyck-height Smith formula is a
  successor crown, not a gate on this one. Card:
  `../cubic-threefolds-tasks/c909-epilogue-math-level-ups.md`.
- **C910 — Lean companion for the epilogue, active.** Formalizes the
  cubic-stabilization epilogue in the Mathlib-only package
  `papers/cubic-stabilization-epilogue/lean/`, under the C879 paper-facing
  namespace `TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue`, with
  reviewer entry point `PaperInterface` and machine audit
  `Verification/AxiomAudit`; no duplicate under the shared
  `lean/TavisRuddFiniteGeom/` tree or a second Lean repository. 93 sources
  build through the guarded queue; exact bijection among 23 manuscript
  claims, 168 reviewer terminals, and expected axiom rows; coverage 0
  absent / 13 fragmentary / 9 conditional / 1 complete. Card:
  `../cubic-threefolds-tasks/c910-cubic-stabilization-lean-companion.md`; interim release report
  `../2026-08-12-c910-partial-lean-release.md`.
- **C914 — active.** The `A_5`-pencil is proved to contain the Fermat cubic
  threefold, so it meets the already-known universally `CH_0`-trivial
  examples; decide next whether its generic member lies in the
  Yang–Yu–Zhu coprime-degree locus (arXiv:2508.03623, Theorem 3.3) or one of
  Voisin's codimension-at-most-three components, by comparing normal forms
  and testing odd-degree isogeny of `J(X_b)` to a curve Jacobian, then
  restate the pencil's contribution at its proved strength. Card:
  `../cubic-threefolds-tasks/c914-a5-pencil-vs-coprime-degree-locus.md`.
- **C911 — closed.** Discrepancy-one flip correction, published as a
  standalone ten-page note (`papers/discrepancy-one-flips/`), DOI
  `10.5281/zenodo.21924799`. Independent cold read passed; authority and
  clean standalone gates pass; portfolio summary synchronized. Card:
  `../cubic-threefolds-tasks/c911-shen-shoemaker-flip-repair-note.md`.

No C907, C908, C909, or C914 promotion into any manuscript, PDF, mirror, or
Lean source follows automatically from any of the above.

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Cubic-stabilization epilogue (Silver: `X x P^1` irrational unconditionally) | `papers/cubic-stabilization-epilogue/` | warning-free; Lean companion in progress under C910 | C907, C909, C910 |
| Discrepancy-one flip correction | `papers/discrepancy-one-flips/` | published standalone note, DOI `10.5281/zenodo.21924799` | C911 (closed) |
| *Irrationality of Cubic Threefolds after One Stabilization* | `papers/cubic-stabilization-irrationality/` | owned by this lane since 2026-08-15; two active tasks edit it, so sequence them rather than editing concurrently | C912, C913 |

## Lane boundaries

This lane owns the cubic-threefold research program above, its task cards
under `notes/cubic-threefolds-tasks/`, and — since 2026-08-15 —
`papers/cubic-stabilization-irrationality/` under C912 and C913. It does not
own the numbered Clebsch series (Papers I–V) or any other `clebsch`-lane
surface — those remain foreign until an owning task here explicitly admits
them, per the usual cross-lane hygiene rule.

The companion discovery log is
`notes/2026-08-15-cubic-threefolds-discovery-track.md`. Logging an
observation neither allocates work nor adds it to a paper.

## Working and historical indexes

- Live task detail: `notes/cubic-threefolds-tasks/`.
- Prior lane history (pre-2026-08-15, while this program lived under
  `clebsch`): `notes/handoffs/2026-07-13-clebsch-lane.md` and its archive
  `notes/handoffs/done/2026-07-13-clebsch-lane-archive.md`.
