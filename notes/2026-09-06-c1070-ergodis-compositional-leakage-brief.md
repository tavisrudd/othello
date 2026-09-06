# C1070 brief: exact compositional leakage analysis for hierarchical linear encodings

**Lane**: `ergodis`
**Task**: C1070 — open-ended riff on a privacy interface for the compositional recovery theory:
compile a hierarchical linear encoding into the minimum-cost coalitions that recover a *named*
secret functional, or leak at least `t` symbols of a secret subspace, with coefficient witnesses.
**Code**: `~/src/ergodis-private` (core changes, if any, in `~/src/ergodis`)
**Manuscript**: `papers/complete-repair-ports/compositional_recovery.tex` (owned by `complete-ports`;
this task reads it and does not edit it)
**Status of this file**: reference. Source brainstorm, assessment, mapping onto existing machinery,
and the probe plan. Probe reports are the result documents.

## 1. Provenance and epistemic status of the source

Section 3 condenses a brainstorm from Astra (Tavis's ChatGPT-side collaborator) supplied on
2026-09-06. As with the C1062 brief, structural claims and landscape claims are kept apart.

- **Structural claims** (the rank identity for linear leakage; the labelled-versus-unlabelled
  example; that prescribed-coset costs track named functionals through a tower). Checked below;
  all three hold.
- **Landscape claims.** Two were made. "Relative generalized Hamming weights characterize secret
  sharing is established" — true (Luo–Mitrpant–Vinck–Chen 2005; Kurihara–Uyematsu–Matsumoto 2012;
  Geil–Martin–Matsumoto–Ruano–Luo 2014), unverified here beyond memory and to be pinned by
  probe 0. "Your manuscript explicitly acknowledges it" — **false as stated**: the manuscript
  names relative generalized Hamming weights as the single-block layer but contains no occurrence
  of *secret*, *privacy*, *wiretap*, or *leak*. The secret-sharing reading is not in the paper.
  That is itself a finding: the privacy reading of the labelled cost is unstated anywhere in our
  record, so even the single-level translation is new *to the manuscript*, though not to the
  literature.

## 2. The central object, stated once

Fix `Z` uniform on `F_q^k` (message and mask variables together). A secret is `A Z` for a matrix
`A`; a coalition `H` observes `B_H Z`. Then

```
I(AZ ; B_H Z) / log_2 q = rank A + rank B_H − rank [A ; B_H] = dim( row A ∩ row B_H ).
```

So in the uniform linear model the leakage in `q`-ary symbols is an integer, equal to the number
of independent secret functionals the coalition recovers exactly, and *which* functionals leak is
the subspace `row A ∩ row B_H`. Privacy of a named functional `s ∈ row A` against `H` is the
statement `s ∉ row B_H`; recovery of `s` by `H` is `s ∈ row B_H`. Leakage is therefore the same
lattice as recovery with the secret functionals as virtual coordinates (Massey's coding view of
secret sharing). Nothing probabilistic survives that is not already rank arithmetic; the model
leaves the linear-uniform world only with non-uniform priors or noisy observations, which are out
of scope for this task.

## 3. The brainstorm, condensed

1. Do not sell "RGHW characterizes secret sharing" as new; it is known and the single-block layer
   of the manuscript already is that theorem in recovery language.
2. The opportunity is compositional analysis that keeps the **identity** of protected functionals,
   not just the count of leaked symbols. The labelled prescribed-coset costs and coefficient
   witnesses are the machinery.
3. Witness example (`q` odd): shares `(x, y, x+y)` versus `(x, y, x+2y)` for secret `S = x + y`.
   Same recovery profile of the two-dimensional message, same uniform matroid and `[3,2,2]`
   parameters; but one share reveals `S` in the first scheme and no single share is correlated
   with `S` in the second. The unlabelled summary loses this; the functional-labelled one keeps it.
4. Deliverable: a privacy interface that compiles a hierarchical linear encoding into minimum-cost
   coalitions recovering a specified functional, or leaking at least `t` symbols, with explicit
   coefficient witnesses; audience is adversarial auditing of composed secret sharing, distributed
   storage, and linear network coding.
5. Open work: represent the secret subspace, mask subspace, and permitted observation model
   explicitly; the bounded numerical-nonconfinement quotient is not automatically complete for every
   access structure, leakage statistic, or capacity-constrained observation model.

## 4. What the manuscript and the engine already have

- **Item 3 is the manuscript's opening example in privacy clothing.** The abstract's first two
  sentences say exactly that the least helper count forgets the label and can give the wrong
  finite threshold. Nothing to prove; the translation is a paragraph.
- **Single named functional through a tower is the principal theorem.** "Min-cost coalition
  recovering `s`" is the labelled recovery problem with target `s`; the min–sum formula over
  target-normalized prescribed-coset costs, associativity through finite towers, and the
  outer-dual-distance threshold all transfer verbatim with helper set renamed to coalition.
- **`t` symbols leaked** is min over `t`-dimensional subspaces `T ⊆ row A` of the labelled cost of
  recovering `T`. The manuscript already handles `t`-dimensional targets and bounds the witnessing
  context's functional-dual dimension by `min{t, r}`; the engine has `transfer-subspace` for
  arbitrary-rank targets. What is missing is the outer minimization over `T`, which is a
  Gaussian-binomial-sized enumeration unless the quotient collapses it (probe 2).
- **Witnesses** already exist: minimizing lifts propagate a coefficient witness.
- **Masks do not yet exist as a first-class notion.** The tower is deterministic concatenation:
  inner message = outer symbol. Secret sharing at each level injects fresh randomness, so the inner
  represented code has message space `L × R_inner` and the leakage question is "recover `s` modulo
  the mask functionals". The confinement classes are functional-induced classes; quotienting by a
  mask subspace is a coarser class and whether the associative min–sum survives it is the one
  theorem-shaped question here (probe 1).

## 5. What is genuinely new, ranked

1. **Mask-quotiented composition** (probe 1). Does the labelled cost compose associatively when
   each level carries a mask subspace projected out at the next level? Expected yes by the same
   proof with induced functionals taken modulo the mask, but the target-normalization step must be
   re-checked: normalizing a target that is only defined modulo masks may break the "closed but
   redundant state" property. If it holds, hierarchical (re-randomized) secret sharing and Cai–Yeung
   secure network coding with layered keys are covered by one theorem.
2. **Leakage profile without subspace enumeration** (probe 2). The `t`-symbol leakage cost is a
   relative-weight hierarchy through the tower. Question: does the finite contextual quotient at
   helper radius `r` make the min over `T` computable from the quotient states alone, so the profile
   for all `t ≤ r` is one compiled object rather than one query per subspace? A positive answer is
   the actual "compile the encoding into its leakage profile" deliverable.
3. **Per-level budgets** (probe 3). An adversary limited to `a` compromised blocks and `b`
   coordinates per block has a vector cost, not a scalar; the min–sum becomes a Pareto min–sum
   over a partially ordered monoid. Does the quotient stay finite and exact? Ergodis has dominance
   and scheduler-bound machinery (`scheduler_dominance.rs`, `frozen_shortest_path.rs`) that may
   already carry partially ordered costs; check before building.
4. **Labelled Wei duality through the tower** (probe 4, likely short negative). Single-level
   privacy-versus-recovery is Wei duality of the nested pair. Concatenation does not commute with
   duality except for the trace-dual inner code, so the labelled costs of the dual tower are
   probably not a function of the labelled costs of the primal tower. A clean counterexample or a
   sufficient condition is worth one page either way.
5. **Interface** (probe 5, engineering). A JSON input naming secret subspace, mask subspace, and
   observation model (coalitions of coordinates at any level, whole-block or partial), and an
   output of min-cost coalitions per projective class of `row A`, the `t`-profile, and witnesses.
   Reuse `transfer-subspace`; no new core unless probe 1 or 3 demands it.

## 6. Probe plan

- **Probe 0** — prior-art audit per `notes/literature-audit-conventions.md`: RGHW secret sharing
  (the three references above), hierarchical / multilevel secret sharing (Tassa 2007 is a
  different notion, hierarchical *access structure* by Birkhoff interpolation, not hierarchical
  *encoding*), secret sharing from concatenated codes (Chen–Cramer–Goldwasser–de Haan–
  Vaikuntanathan 2007; Cascudo–Cramer–Xing), rank-metric RGHW for network coding
  (Martínez-Peñas), and leakage-resilient secret sharing (Benhamouda et al.), which is a different
  leakage model and must not be conflated. Verdict wanted: is "labelled compositional leakage with
  witnesses through a tower" pre-empted?
- **Probe 1** — mask-quotiented associativity, proof or counterexample, small computational check
  in `ergodis-private`.
- **Probe 2** — leakage profile from the quotient; measure on the manuscript's existing example
  towers.
- **Probe 3** — vector costs; first check what the core's dominance machinery already supports.
- **Probe 4** — labelled duality; bounded to one session.
- **Probe 5** — interface, only after probes 1–2 settle what the object is.

Each probe gets one dated report `notes/2026-MM-DD-c1070-probeN-*.md` and an independent
adversarial review, as in C1062. Reproducibility conventions apply to any number that could reach
a paper.

## 7. Standing constraints

- No edits to the `complete-ports` manuscript; a paper-facing consequence is proposed to that lane
  as a candidate statement, not written in.
- No public-surface or Ergodis-paper claim until probe 0 returns and at least probe 1 or 2 has a
  reviewed result.
- The linear-uniform model is the scope. Non-uniform priors, noisy channels, and computational
  (as opposed to information-theoretic) privacy are out of scope and should be named as such in
  any report.
- Discovery-track discriminator as usual: leads found while looking for something else go to the
  ergodis discovery track.
