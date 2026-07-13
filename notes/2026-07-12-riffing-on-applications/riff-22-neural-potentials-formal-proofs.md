# Neural potentials to formal amortized proofs

Status: exploratory paper agenda  
Primary source: `RIFF_22`, `RIFF_31`, `RIFF_44`–`RIFF_46`  
Existing substrate: exact S4 transitions, potential probes, LP fitting, conic ledger, Lean reduction
chain

## Thesis

A learned model can be useful in proof discovery without entering the trust chain. Train a potential
against exact adversarial transition obligations, search for worst violations, distill the surviving
model into a sparse symbolic expression, and prove the resulting local inequalities formally.

## Minimum publishable contribution

1. Recover a known valid potential from exact transitions using a counterexample-guided loop.
2. Discover either a sharper valid inequality, a smaller feature basis, or a new bounded-family
   certificate not supplied to the learner.
3. Translate the learned object into a human-readable symbolic potential.
4. Kernel-check at least one nontrivial terminal theorem that uses the distilled inequality.

The uniform odd-plane theorem is not required for the methods paper.

## Research agenda

### Phase 1 — Obligation semantics

- Formalize the local quantifier pattern: one-ply, two-ply, or packet-level `exists/forall/exists`.
- Export canonical transition obligations with exact state features and symmetry metadata.
- Establish train/validation splits by orbit and field order.

### Phase 2 — Interpretable potential classes

Try in increasing complexity:

- sparse integer linear forms;
- max/min of a few affine forms;
- shallow decision trees;
- low-degree symbolic expressions;
- a small neural critic used only to propose features.

### Phase 3 — Adversarial refinement

- Fit against current obligations.
- Use exact search to maximize inequality violation.
- Add the worst orbit representatives.
- Repeat until the bounded domain closes or a structural counterfamily emerges.

### Phase 4 — Distillation and Lean

- Round or synthesize simple coefficients.
- State the exact local combinatorial lemmas required.
- Prove feature-update identities and the potential inequality in Lean.
- Audit whether the formal theorem matches the empirical obligation.

## Paper spine

1. **Introduction:** learned proof discovery with zero neural trust.
2. **Game and proof obligations:** the conic residual setting.
3. **Potential synthesis classes:** interpretable models and objectives.
4. **Counterexample-guided loop:** exact adversary and symmetry quotienting.
5. **Recovery experiment:** rediscovering a known ledger.
6. **Novel discovery experiment:** sharper or new bounded certificate.
7. **Formal distillation:** Lean theorem and trust-chain account.
8. **Lessons for automated amortized analysis.**

## Shallow literature and novelty check

Closest precedents found:

- Abate et al. already combine a neural learner, SMT verifier, and counterexamples to synthesize
  formally sound Lyapunov functions:
  [Formal Synthesis of Lyapunov Neural Networks](https://www.cs.ox.ac.uk/people/alessandro.abate/publications/cAAGP20.pdf).
- Debauche et al. use a CEGIS loop for ReLU Lyapunov certificates:
  [Formal Synthesis of Lyapunov Stability Certificates](https://proceedings.mlr.press/v288/debauche25a.html).
- Counterexample-guided neural synthesis has also been applied to loop invariants and programs:
  [CounterExample Guided Neural Synthesis](https://arxiv.org/abs/2001.09245).

Preliminary verdict: **the generic learn–falsify–verify loop is not novel**. A viable contribution
must rest on the discrete adversarial combinatorics: quantified packet obligations, group-quotiented
exact counterexample search, symbolic integer-potential distillation, and a Lean theorem that
advances the cap-game mathematics. Rediscovering a known linear ledger alone is likely a workshop or
negative/control experiment, not the headline.

Required deeper audit:

- automated potential/ranking-function synthesis for amortized program analysis;
- neural invariant discovery ending in interactive-theorem-prover proofs;
- synthesis under alternating `exists/forall/exists` obligations.

## Kill criteria

- The method only memorizes finite tables and fails held-out orbit or `q` tests.
- Distillation destroys the empirical result or yields an expression too complex to formalize.
- Exact LP or enumerative synthesis dominates every learned component with no compensating insight.
- The formal endpoint is merely a restatement of exhaustive enumeration.
