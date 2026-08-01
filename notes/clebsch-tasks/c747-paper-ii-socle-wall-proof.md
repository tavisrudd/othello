# C747 — Paper II socle and first-wall proof

**Lane:** `clebsch`

**Status:** queued next; C746 complete

## Objective

Give a rigorous, coordinate-light proof of the Lucas-socle criterion and the
adjacent-wall non-splitting theorem needed by Paper II's all-`q`
classification, including the characteristic-three endpoint.

Use C746's exact quadratic pullback obstruction: for every
\(\lambda>1\), produce an outer-invariant nontrivial simple submodule of the
sheet permutation module, prove the required \(G\)-parity vanishing in
\(\operatorname{Sym}^2F\), and prove that the canonical pullback along the
specific linear moment map \(i_\delta=2a|_{S^\delta}\) has nonzero
connecting class in
\(\operatorname{Ext}^1_G(S^\delta,\operatorname{Sym}^2F)\). This includes the formerly hidden
principal-projective possibility.

Prefer the pushout formula from C746:
\[
 \delta_{S^\delta}(i_\delta)
 =i_\delta^*\pi_*(F\otimes\xi),
\]
where \(\xi\) is the affine-extension class and
\(\pi:F\otimes F\twoheadrightarrow\operatorname{Sym}^2F\) is the canonical
quotient \(\pi(f\otimes f')=ff'\). Test whether
this symmetrized Yoneda product gives a uniform structural proof before
retaining any correction-row scalar.

## Proof standard

- Begin from standard highest-weight, Frobenius-twist, and
  symmetric/exterior-square functors, with exact theorem-level citations.
- Derive the digit criterion as a statement about actual Hom spaces, not a
  composition-factor heuristic.
- Express the first wall by canonical subquotients and connecting maps.
  Prove uniqueness and nonvanishing functorially; compute a scalar only when
  it is the irreducible final obstruction.
- Replace the q=9 matching census by a structural subgroup, block-system, or
  extension argument if one exists.  Retain finite verification only as an
  explicitly non-load-bearing cross-check.
- Use no field-sized matrices, coordinate packets, or case tables in the
  proof.

## Acceptance gate

The projective--trade obligation frozen by C746 is discharged for every odd
prime power by a human proof whose causal spine fits in a short sequence of
lemmas.  The generic-wall and q=9 programs are corroboration only.  An
independent modular-representation reader reports no missing identification,
parity step, exceptional case, or hidden computation.

## Boundaries

Do not generalize beyond the theorem's classified matching-orbit problem.
Do not edit Lean; C749 begins only after C748 freezes the human surface.
