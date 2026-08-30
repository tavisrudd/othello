# C896 — Corrected universal finite-group socle theorem

**Lane:** `clebsch`

**Status:** queued future mathematics; independent of Paper II

**2026-08-30 semantic-rank spike:** the frozen `q=9` Hom computation now has
a separate provenance-preserving rank-core adapter.  For every nontrivial
central-even source, Weyl is the only individually essential generator block;
three alternative generator cores attain full rank.  For the unexpected
`L(2,0)` channel the system has 30 variables, rank 29, and an explicit
29-equation semantic basis.  This is a control extraction around the already
known catalecticant summand, not the missing carry theorem.  Next: compile
H4--H5 sparsely at `q=25`, labeling rows and variables by torus alias,
carry/borrow state, and Weyl partner.  Portfolio memo and artifact:
`notes/2026-08-30-ergodis-certificate-to-theorem-portfolio.md` and
`notes/2026-08-30-c896-q9-semantic-rank.json`.

## Objective

Determine whether the finite-group socle of
\[
 \operatorname{Sym}^{(q-3)/2}L(2)
\]
admits a corrected universal description once digit carries, borrows, and
finite-torus weight aliases are included. The former digitwise Lucas
criterion is false: at \(q=9\), the catalecticant-minor covariant supplies
an additional \(L(2,0)=L(q-7)\) copy.

## First gates

1. Solve the complete root, torus, and Weyl intertwining systems at \(q=9\),
   \(q=25\), and one exponent-three field.
2. Organize every extra kernel by a finite carry/borrow state and determine
   whether the state set stabilizes under Frobenius digit extension.
3. Search the modular plethysm and finite-\(\mathrm{SL}_2\) literature for an
   existing exhaustive formulation.
4. Attempt a most-significant-state induction only after the bounded cases
   support a precise conjecture.

## Boundary

This is research into a stronger universal theorem, not a repair dependency.
It must not restore a universal socle assertion to Paper II, alter C895's
targeted detector proof, or become general Paper/Lean routing material
without a later explicit decision.
