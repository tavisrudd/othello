# C992 — AME-LU referee clarification pass

**Lane:** `ame-lu`
**Status:** complete
**Scope:** Paper I authority, paper README, and portfolio abstract; no Lean,
mirror, push, deposit, or submission action

## Objective

Implement four external review findings: expand the commutator-phase and
chord--angle bridges in the quantitative proof; make the additive prime-power
Clifford convention explicit at the headline theorem; display the determinant
weights in the six-party normalization proof; and sharpen the distinction
between main theorems and optional comparison machinery.

## Gates

1. Added inequalities reproduce the existing constants without changing a
   hypothesis or conclusion.
2. Prime-power wording names `Sp_{2e}(F_p)` without implying `F_q`-linearity.
3. The six-party display derives the row and column weights from
   `S^T J S = (det S)J` in the existing conventions.
4. Warning-free build, rendered inspection, and focused cold mathematical
   review pass.

## Result

All four findings were implemented without changing a hypothesis, constant,
or conclusion.

- Lemma 6.2 now contains the normalized Hilbert--Schmidt four-factor
  telescoping inequality and the explicit strict comparison with the least
  nontrivial `p`-th-root chord.
- A separate chords-and-centered-logarithms lemma now proves the
  Hilbert--Schmidt-to-spectral-arc and generator-norm bridge used in the
  cleaning theorem.  The existing second radius clause is exactly its
  threshold; the four radius clauses retain their original roles.
- The abstract and the paragraph immediately before the headline theorem now
  say that Clifford means the additive prime-field normalizer, acting on
  labels through `Sp_{2e}(F_p)` with no `F_q`-linearity assumption.  The paper
  README and portfolio abstract were synchronized.
- The six-party proof now derives the row and column weights explicitly from
  `S^T J S = (det S)J`, including `r_i=(det P_i)^{-1}`,
  `s_j=det Q_j`, and `t_j=s_j^{-1}`.
- The introduction now separates the exact axis/transition/endomorphism
  branch from the independent support/correctability/robust branch and marks
  Appendix B as supplementary comparison material.

Validation passed: `make check`, TeX spacing lint, warning/undefined-reference
scan, `git diff --check`, and rendered inspection of the title/abstract,
six-party normalization, commutator estimate, logarithm lemma, and global
rounding pages.  An existing context-cold referee agent returned `GO`,
independently checking all four clauses of the radius, the characteristic-two
determinant signs, and the prime-power scope.  The proof expansion changes the
paper from 37 to 38 pages.
