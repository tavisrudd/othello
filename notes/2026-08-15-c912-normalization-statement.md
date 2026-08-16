# The normalization statement owed to Hypothesis 4.7H

**Date:** 2026-08-15 · **Lane:** `cubic-threefolds` · **Task:** C912

**Purpose.** Resolve junction C-J1 of `2026-08-15-c912-h47h-evidence-ledger.md`:
the manuscript and its imported sources appear to use two incompatible notions
of "positive-filtration bulk displacement". This note states what is actually
true of each ring, shows that the apparent contradiction is not one, and reduces
the whole question to two named lemmas the C912 card already carries as owed.

**Status of the conclusion.** The reconciliation below is a *reduction*, not a
proof. It removes the well-posedness objection and replaces it with two concrete
obligations. It does not discharge Hypothesis 4.7H.

---

## 1. A rebuttal that does not work, recorded so it is not tried again

The tempting reply to finding F1 of `2026-08-15-c912-section10-hostile-referee.md`
is that "unit" and "topologically nilpotent" are not exclusive: in `ℂ((t))` the
element `t` is a unit and still satisfies `t^n → 0` in the `t`-adic topology, so
observing that `q^{±1/s}` is invertible would prove nothing.

**That rebuttal is wrong, and F1's word "unit" is shorthand for a stronger
argument.** F1's actual ground is the *category*, quoted from Iritani Remark 1.3
and §2.2: the completion is taken in graded rings, and the graded completion is a
**direct sum** over degrees, `M̂ = ⊕_n M̂_n`, each `M̂_n` completed `Q`-adically.
Iritani–Koto Remark 5.3 says the same, that the ring "consists of finite sums of
homogeneous elements". Since `q` has positive degree, the series `Σ_n c_n q^{n/s}`
has terms in infinitely many distinct degrees and is therefore **not an element of
that ring at all**. Topological nilpotence fails for want of the limit, not for
want of non-invertibility. F1 is correct on its own terrain.

---

## 2. The three rings, and what is true in each

| ring | definition | where it is used | status of `q^{1/s}` | status of `q^{-1/s}` |
|---|---|---|---|---|
| `Λ_T` | `ℂ[[NE^ℤ_num(T)]]`, completed monoid ring (`04-one-step.tex:21-24`) | ambient coefficient bookkeeping | topologically nilpotent | not present |
| `K_T` | algebraic closure of `Frac Λ_T` (`04-one-step.tex:32-34`) | Levelt–Turrittin, framed monodromy, memo Section 8's `Λ` | unit, no topology carried | unit, no topology carried |
| `B_j` | `lim_N R_j/J_j^N`, `J_j = (u, {Q^{i_*d}u^{ρ_C·d}}_{d≠0}, s_j)` (`04-one-step.tex:484-497`) | the comparison chart, where the displacement lives | not in `J_j` | **generator of `J_j`** |
| Iritani's `Ĥ` | graded completion, direct sum over degrees (I-Bl Remark 1.3, §2.2) | where Theorem 5.18 and Lemma 5.15 are proved | homogeneous element | homogeneous element; infinite series in it are **not elements** |

Two observations settle the apparent contradiction.

**(a) The manuscript does not work in Iritani's category, and says so by
construction.** `B_j` is an inverse limit, so infinite series with
`J_j`-adically decreasing terms *are* elements of it. `u = q^{-1/(c-1)}` is a
generator of `J_j`, hence topologically nilpotent in `B_j`. Separation
(`∩_N J_j^N = 0`) is proved from the additive weight `w` with `w(u) = 1`,
`w(s_{j,ℓ}) = 1`, `w(Q^{i_*d}u^{ρ_C·d}) = L(H·i_*d) + ρ_C·d ≥ 1`, together with
the Novikov finite-below support condition (`04-one-step.tex:499-517`). Nothing
here is in conflict with Iritani; it is a different completion of an overlapping
subring, and it is the one that admits the series the argument needs.

**(b) F1's three bullets are already answered two-thirds of the way, by exact
identities rather than by any topology.** F1 objects separately to the `H⁰`, `H²`
and `H^{≥4}` pieces of

> `ς_j(τ̃)|_{Q=τ̃=0} = -(r-1)λ_j + h_{Z,j} + O(q^{-1/(r-1)})`

and the manuscript's own three-way split lines up with it exactly:

- **`H⁰`, the term `-(r-1)λ_j ∝ q^{1/(r-1)}`** — a *positive* power of `q`, so it
  is not in `J_j` and never could be. It is disposed of by the **string
  equation**, which gives `⋆_{τ+c1} = ⋆_τ` identically for any `c` in the
  coefficient ring, unit or not. Exact, no smallness, no topology. This is the
  one place where "exact and needs no smallness" is literally true.
- **`H²`, the constant `h_{Z,j}`** — degree zero, so again not nilpotent in any
  topology. It is disposed of by the **fixed-divisor substitution**
  `Q^d ↦ e^{⟨a_2°,d⟩}Q^d`, a `z`-constant coefficient automorphism fixing `ℂ`,
  which cannot move roots-of-unity multiplicities of a characteristic polynomial.
  Exact.
- **`H^{≥4}`, the tail `O(q^{-1/(r-1)})`** — negative powers of `q`, and *this is
  the only piece for which topological nilpotence is claimed*. In `B_j` it is
  genuine, by (a).

So the manuscript's decomposition is not an accident of exposition; it is
engineered so that exactly the piece for which nilpotence can hold is the piece
for which it is asserted. **F1 refutes doing the argument inside Iritani's
category. It does not refute the manuscript's construction.** What it does show
is that the manuscript cannot import Iritani's statements by simply reading them
in `B_j` — which brings us to the two real obligations.

---

## 3. What is actually owed

### Obligation A — the base-change lemma from the graded category into `B_j`

Iritani's Theorem 5.18 and Lemma 5.15 are proved over `Ĥ`. The manuscript
consumes them over `B_j`. `R_j` is a subring of the Laurent monoid domain of the
comparison chart, so the two rings share `R_j`, but `Ĥ` and `B_j` are different
completions of it and neither contains the other. A transported statement
therefore needs:

1. a coefficient map carrying the source augmentation ideal into `J_j`, shown to
   extend continuously to the completed rings and to descend at every `J_j^N`
   stage; and
2. that the comparison matrices **and their inverses** descend modulo `J_j^N` and
   retain both the inverse and the intertwining identities.

**These are already on the C912 card, unchecked, in the Major comment 2 block**
(`notes/cubic-threefolds-tasks/c912-cubic-stabilization-referee-foundations.md`,
the two unticked items reading "Add an internal lemma: a coefficient map taking
the source augmentation ideal into `J` extends continuously…" and "Prove that
comparison matrices and their inverses descend modulo `J^N`…"). The lane
identified the right lemma and has not written it; nobody had connected it to
F1. Related open residual, WP9: "re-derive the continuity claim for the inverse
of the full coordinate map… The structure supports it; the recursion was not
written out."

**Why this is the whole ball game.** With Obligation A proved, `B_j` is a
legitimate receiver, the tail is topologically nilpotent in it, and the
displacement is a genuine point of a formal germ over `B_j` — which is the
setting in which the general formal-constancy theorem
(`2026-08-15-c912-frame-transport-memo.tex`, `thm:bulk-constancy`) already
applies unconditionally, for every smooth projective target and every block
type. Without it, the phrase "positive-filtration bulk displacement" has two
meanings and the hypothesis is not well-posed.

### Obligation B — the membership claim

`04-one-step.tex:523-527` asserts that after the unit term `-(c-1)λ_j` and the
fixed divisor `h_{C,j}` are removed, the target bulk coordinate lies in
`J_j H^*(C)`, citing Iritani (5.45), (5.47) and the initial asymptotics
(5.27)–(5.30). This is the statement that puts the residual displacement inside
the nilpotent ideal, so Obligation A is useless without it.

The evidence ledger marks it **UNRECONSTRUCTED** — unverified anywhere in the
audited set, and the most load-bearing of the four items so marked. It should be
checked at the source before anything else in this note is relied on.

---

## 4. What this changes

1. **The well-posedness objection is answered, at the level of ring theory.**
   The manuscript's `w`-topology is not a competitor to Iritani's graded
   completion and does not contradict it; it is a different completion of a
   shared subring, chosen because it admits the series the argument needs.
   Recommend saying exactly this in the manuscript, in one paragraph, at the
   point where `B_j` is introduced.
2. **Hypothesis 4.7H's remaining content shrinks, if Obligations A and B land.**
   With a legitimate receiver and the membership claim, the displacement is a
   point of a formal germ, and `thm:bulk-constancy` covers arbitrary block type
   — which would close the reconstruction sites without needing the coalesced-block
   machinery of memo Section 8 at all, and without the convergence criterion
   `e·w(Δλ) < ε` that the memo shows fails under the paper's own choice of `L`.
3. **Priority inverts.** The coalesced-block program (arbitrary Jordan size, the
   `μ`-grading route, derogatory and resonant blocks) is *not* the critical path.
   Obligations A and B are, and both are bounded, named, and previously
   identified.

## 5. Caveats on this note

- The reading of Iritani's category is taken from F1's quotations of Remark 1.3,
  §2.2 and Iritani–Koto Remark 5.3, not from a fresh read of the sources. The
  companion source-exactness audit
  (`2026-08-15-c912-h47h-source-exactness-audit.md`) should confirm them before
  this note is cited in the manuscript.
- Obligation B is unverified and could fail. If the residual coordinate does not
  lie in `J_j H^*(C)`, this note's reconciliation collapses and F1 stands against
  the manuscript's construction as well as against Iritani's category.
- Nothing here touches the divisor-tagging clause, which deforms over a formal
  power series ring on an algebraically closed field and is a separate and easier
  problem.
