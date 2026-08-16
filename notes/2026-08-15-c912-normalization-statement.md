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

**STATUS, 2026-08-15, after a hostile referee pass: NOT DISCHARGED.** An attempt
to prove Obligation A was written into the memo as `sec:base-change` and then
refuted. The argument claimed that no continuity is needed because Iritani's
elements are finite sums of homogeneous pieces, so membership in `R_j` would be
decidable monomial by monomial and the identities would transport along
`R_j ↪ B_j`. That is false, and the source says so directly: Iritani §2.2 states
that a homogeneous element of `K((x))` is of the form `Σ_{n=m}^∞ a_n x^n`, so a
single homogeneous component is *itself an infinite series*. Graded finiteness is
finiteness in the grading only. Verified against arXiv:2307.13555v3 in this pass;
the source-exactness audit's §11.5 verdict of "no obstruction" is withdrawn.
Two further gaps: the argument never covered the entries of the comparison map
itself, whose entries involve variables that are not `R_j` generators, and the
power series directions are not finite in any sense. The memo section now states
what survives — the removal of the `u^{-1}` obstruction by one explicit rank-one
twist, and the separation of `R_j` — and records the rest as owed.

**Why this is the whole ball game.** With Obligation A proved, `B_j` is a
legitimate receiver, the tail is topologically nilpotent in it, and the
displacement is a genuine point of a formal germ over `B_j` — which is the
setting in which the general formal-constancy theorem
(`2026-08-15-c912-frame-transport-memo.tex`, `thm:bulk-constancy`) already
applies unconditionally, for every smooth projective target and every block
type. Without it, the phrase "positive-filtration bulk displacement" has two
meanings and the hypothesis is not well-posed.

### Obligation B — the membership claim — **DISCHARGED at the source**

`04-one-step.tex:523-527` asserts that after the unit term `-(c-1)λ_j` and the
fixed divisor `h_{C,j}` are removed, the target bulk coordinate lies in
`J_j H^*(C)`, citing Iritani (5.45), (5.47) and the initial asymptotics
(5.27)–(5.30).

**Verified against arXiv:2307.13555v3** in
`2026-08-15-c912-h47h-source-exactness-audit.md`. All six cited items exist, and
Iritani (5.30) reads verbatim

> `ς_j(0)|_{Q=0} ∈ -(r-1)λ_j + h_{Z,j} + q^{-1/(r-1)}H*(Z)[q^{-1/(r-1)}]`

The source is **stronger than the manuscript's claim**: the residual is a
*polynomial* in `q^{-1/(r-1)}` with a forced factor of `q^{-1/(r-1)}`, so it
consists of negative powers only, with no degree-zero and no positive-power
remainder. The `s_j` components enter via (5.47) and are themselves generators of
`J_j`. No term is unaccounted for.

Two consequences worth stating explicitly.

1. The membership holds, so the reconciliation of §2 stands.
2. Because the residual is a **polynomial** rather than a series, it is a finite
   sum of homogeneous elements and is therefore a legitimate element of Iritani's
   graded ring as well. The direct-sum obstruction of §1 never applied to the
   displacement itself; it applies only to *powers* of it accumulating in
   infinitely many degrees, which is what topological nilpotence would require
   and which is supplied by `B_j` and not by `Ĥ`. That narrows the gap between
   the two rings further than §2 claimed.

**One MISMATCH, harmless here.** The audit records `h_{Z,j} = (2πi/(r-1))(j + 1/2)ρ_Z`,
not `(j + r/2)`; the `r/2` belongs to the exponent of `λ_j`. This affects the
transcription in the hostile-referee report, not the membership conclusion.

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

## 5. Caveats — both of the original two are now resolved

- **Resolved.** The reading of Iritani's category was originally taken from the
  hostile-referee report rather than the sources. The source-exactness audit
  confirms it verbatim: Iritani §2.2 defines the graded completion as the direct
  sum `M̂ = ⊕_{n∈ℤ} M̂_n` with `M̂_n = lim_k M_n/N_{k,n}`, corroborated by
  Remark 1.3 and Iritani–Koto Remark 5.3. An infinite series in `q^{-1/s}` is
  genuinely not an element of his ring, and `B_j` is a different completion of a
  shared subring rather than a contradictory one.
- **Resolved.** Obligation B is discharged at the source, with the source
  statement stronger than the manuscript's. See above.
- **Still open, and an attempt on it has been refuted.** Obligation A remains the
  one thing between the reconciliation and a closed argument. See the status note
  above. The reconciliation of §2 is therefore weaker than first written: the two
  rings are still plausibly two completions of one shared subring, but the
  comparison data has not been shown to cross between them.
- **Two defects found downstream on 2026-08-15, both in the memo rather than
  here.** Its endpoint section asserted that weak factorization can be arranged
  as a roof with every arrow a blowdown; that is strong factorization, which is
  not available in the dimension at issue, and the reduction built on it is
  conditional rather than unconditional. And the rank-two rigidity chain used
  uniqueness of a block-diagonalizing gauge `g = I + O(z)` without the
  normalization that makes such a gauge unique — composing with any
  block-diagonal gauge preserves both stated properties. The repair normalizes
  the gauge as the exponential of a purely off-block generator, which also makes
  the pairing-isometry argument go through, since the relevant involution
  preserves that class. Under independent verification.
- Nothing here touches the divisor-tagging clause, which deforms over a formal
  power series ring on an algebraically closed field and is a separate and easier
  problem.

## 6. Collateral finding: the memo's proposed successor route is refuted

Outside this note's scope but decided by the same audit, and it changes what to
do next. The memo's route for extending the rank-two mechanism to arbitrary
Jordan size (lines 1846–1850) rests on `[μ, U] = U`, "which makes `H_0` for the
eigenvalue zero `μ`-invariant".

**That identity is false over a Novikov ring.** `μ` implements only the
cohomological half of the grading, while the homogeneity making `E⋆` raise degree
by two is with respect to the total grading including `deg Q^d = 2c_1(X)·d`. The
general rule is `[μ,U]_{ij} = (1 - c_1·d)U_{ij}` on the `Q^d`-part, so the
identity holds only on the Novikov-degree-zero part. The audit refutes it on the
cubic's own matrices: with `μ = diag(-3/2,-1/2,1/2,3/2)` and the manuscript's
`K_X`, entry `(2,1)` gives `[μ,U]_{21} = 2 = U_{21}` but entry `(1,2)` gives
`[μ,U]_{12} = -12q ≠ U_{12} = 12q`. And the drawn consequence fails on the same
example: `H_0 = span_Λ{P³ - 6qP, P² - 21q·1}` is **not** `μ`-invariant.

**Damage assessment (from the audit).** Section 8 Steps 1–7 do not use the
identity anywhere — they use only `[U,C_a] = 0`, `∂_aU = C_a + [C_a,μ]`, the
commutant of a regular `2×2` matrix, and the Frobenius input — so
`cor:cubic-closed` is untouched. The identity appears only in the
arbitrary-Jordan-size passage that the memo itself labels incomplete, so no
proved statement depends on it. But the passage must be corrected, and the
`μ`-grading route should be struck from the successor list rather than ranked
first.
