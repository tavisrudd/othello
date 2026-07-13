# Mex-consistent learning and exact compositional generalization

Status: exploratory paper agenda  
Primary source: `RIFF_25`, `RIFF_26`, `RIFF_40`  
Existing substrate: exact Grundy solvers, disjunctive-sum engine, Queens and finite-group instances,
Lean-checked recurrence

## Mathematical spine

- [`MATH_3`](math.md#math_3--mex-certificate-characterization) — coverage and exclusion characterize
  a valid Grundy labeling.
- [`MATH_4`](math.md#math_4--local-mex-consistency-gives-global-uniqueness) — local certified mex
  consistency determines the global labeling uniquely.

## Thesis

Sprague–Grundy values are structured labels, not arbitrary classes. A valid nimber obeys the mex
recurrence locally and composes by xor across genuine disjunctive sums. Architectures and losses
that encode these semantics should improve consistency and compositional generalization, while
exact non-decomposition examples test whether the model learns when xor composition is valid.

## Minimum publishable contribution

1. Define a differentiable or structured mex-consistency objective over parent/child value
   distributions.
2. Demonstrate improved held-out recurrence consistency or value prediction over flat
   classification.
3. Test exact composition on unseen sums and exact failure on coupled pseudo-decompositions.
4. Provide mechanistic evidence that at least one model represents nimbers or xor rather than only
   memorizing component identities.

## Research agenda

### Phase 1 — Benchmark construction

- Select several component families with exact nimbers.
- Generate train sums and structurally held-out component combinations.
- Include coupled states that visually resemble sums but violate nim-addition.
- Split by component family, size, and isomorphism orbit.

### Phase 2 — Objectives

- Supervised nimber classification.
- Child-set prediction followed by exact mex.
- Soft exclusion: parent and child should not share the parent nimber.
- Soft coverage: every smaller nimber should occur among children.
- Explicit xor module versus learned set composition.

### Phase 3 — Generalization and interpretation

- Unseen component combinations and larger numbers of components.
- Nimber values outside or near the edge of the training range.
- Causal interventions on suspected binary/xor representations.
- Calibration when the state is not a genuine disjunctive sum.

## Paper spine

1. **Introduction:** game values with executable semantics.
2. **Sprague–Grundy structure:** mex and disjunctive composition.
3. **Dataset and exact certificates.**
4. **Mex-consistent models and losses.**
5. **Value-prediction experiments.**
6. **Compositional generalization and false decomposition.**
7. **Mechanistic analysis.**
8. **Limits and transfer to other recursive labels.**

## Shallow literature and novelty check

Closest precedents found:

- Sprague–Grundy learning and heuristic play appear in work on reinforcement learning for impartial
  games, while the classical mex recurrence and xor composition are standard CGT.
- The shallow search found work using evolutionary or neural methods for impartial-game strategies,
  but did not locate a paper centered on a differentiable mex-consistency loss plus exact held-out
  xor composition and coupled non-decomposition controls.
- Compound-game Grundy functions are an active combinatorial topic independent of ML; for example,
  [On the Sprague-Grundy function of compound games](https://arxiv.org/abs/1903.08138).

Preliminary verdict: **one of the cleaner apparent gaps**, subject to a dedicated search in game-AI
and algorithmic-reasoning venues. The novelty is not predicting game values with a network; it is
using mex as executable structured supervision, testing extrapolative xor composition, and including
exact counterexamples where a tempting decomposition is invalid.

Required deeper audit:

- neural algorithmic reasoning for `mex`, set functions, and xor;
- ML for Nim and impartial combinatorial games, including theses and workshop papers;
- differentiable dynamic-programming consistency losses over child sets.

## Kill criteria

- Mex-aware losses add no benefit beyond child-label data augmentation.
- Models cannot extrapolate even on deliberately simple sum families.
- The benchmark leaks component identity or exact values through construction artifacts.
- Mechanistic claims exceed what intervention experiments support.
