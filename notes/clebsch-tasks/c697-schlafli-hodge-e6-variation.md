# C697 — Schläfli--Hodge model for the Litt \(E_6\) variation

**Lane:** `clebsch`

**Opened:** 2026-07-29

**Status:** complete; graded Cartan carrier passes, while arithmetic descent
and non-self-dual Hodge conjugation sharply bound the comparison, in
`notes/2026-07-29-c697-schlafli-hodge-e6.md`.

## C695 entry reduction

C695 recovers the full weight configuration and the \(45=30+15\)
mixed-plus-Pfaffian tritangent support.  Its `ej` closeout gives two sharp
first tests.

First, the order-two permutation of line labels is not itself the linear
Weyl action on the Cartan carrier.  For
\[
\mathcal C=
\sum_{i<j}(x_i y_j-x_j y_i)\omega_{ij}
+\operatorname{Pf}(\omega),
\]
the unsigned exchange \(x_i\leftrightarrow y_i\) negates the mixed summand
and fixes the Pfaffian, so it does not preserve \(\mathcal C\) even up to one
global scalar.  The \(A_1\) Weyl lift instead has
\[
x_i\longmapsto y_i,\qquad y_i\longmapsto-x_i,\qquad
\omega_{ij}\longmapsto\omega_{ij},
\]
and preserves \(\mathcal C\).  Thus the first obstruction is whether the
operator/apolar row exchange has a canonical signed lift; the unoriented
line permutation alone cannot pass the Cartan-tensor gate.

Second, extracting one nonzero coefficient from each of the \(45\)
tritangent factorizations reduces tensor matching to a finite torus-gauge
problem.  Rescaling the \(27\) weight vectors acts through the
\(45\times27\) tritangent-incidence exponent matrix.  This matrix has rank
\(21\) over characteristic zero, hence the coefficient system has \(24\)
independent multiplicative gauge invariants.  Indeed, a kernel vector
\((a_i,b_i,c_{ij})\) satisfies
\[
a_i+b_j+c_{ij}=0\quad(i\ne j),\qquad
c_{ij}+c_{k\ell}+c_{mn}=0
\]
for every perfect matching.  The cross equations give
\(a_i-b_i=d\) and \(c_{ij}=-a_i-a_j+d\); every matching then gives the
single relation \(\sum_i a_i=3d\).  The kernel therefore has dimension
\(6\), proving rank \(27-6=21\).  C697 should compare these \(24\) invariants
with the standard Cartan signs before attempting any Hodge interpretation.

## Objective

Determine whether the full twenty-seven-line operator carrier sought in C695
gives an explicit graded model of the rank-\(27\) \(E_6\) variation studied
by Krämer--Litt--Maculan:
\[
V^{2,0}\oplus V^{1,1}\oplus V^{0,2}
\longleftrightarrow
\{E_i\}_{i=1}^6\sqcup
\{L_{ij}\}_{1\leq i<j\leq6}\sqcup
\{E'_i\}_{i=1}^6.
\]
The target is a mathematical extension through an explicit Hodge tensor,
not a novelty or paper-positioning claim.

## Prerequisite

C695 owns construction of the fifteen complementary lines and the full
\(27=(2\otimes6^\vee)\oplus\bigwedge^2 6\) carrier.  Do not begin the
Hodge comparison from the double-six alone.

## Work package

1. Starting from C695's completed carrier, construct the \(E_6\) Cartan
   cubic, or the equivalent invariant tensor, intrinsically from the
   operator/apolar data.
2. Prove or kill a graded representation isomorphism with the minuscule
   \(E_6\) carrier having dimensions \(6|15|6\).  A dimension match alone
   does not count.
3. Compare the invariant cubic and grading cocharacter, not merely the
   incidence set or its Weyl-group action.
4. Test the row exchange separately against:
   - the Weyl involution of the \(A_1\) factor;
   - Hodge or Galois conjugation, including \(L\leftrightarrow L^{-1}\);
   - the outer automorphism \(27\leftrightarrow27^\vee\).
5. Only if the operator construction carries an intrinsic Galois action,
   test the conditional order-five tower
   \[
   \mathbf Q\subset\mathbf Q(\sqrt5)\subset\mathbf Q(\zeta_5).
   \]
6. Only after the graded-cubic gate passes, formulate the smallest
   possible comparison with the Krämer--Litt--Maculan Higgs or period
   tensor.  Make no family or monodromy claim without an explicit
   cohomological realization.

## Acceptance

A positive result requires:

- an explicit graded linear isomorphism;
- equality of the Cartan cubics up to a nonzero scalar;
- an exact dictionary for the two rows and the middle fifteen weights;
- a proved classification of the relevant involution or conjugation.

A negative result must identify the first invariant mismatch precisely.
Neither \(6+15+6=27\) nor a finite marking of a double-six is evidence of
a Hodge-theoretic extension.

## Boundaries

- A finite étale cover marking a double-six does not reduce connected
  monodromy; an actual Hodge or Higgs tensor is required.
- Keep the algebraic group \(E_6\), the Weyl group \(W(E_6)\), and the
  finite icosahedral \(A_5\) distinct.
- Do not contact authors or alter any manuscript in this task.
- Any computation promoted into mathematics must satisfy the repository's
  exact replay and independent-check requirements.

## Starting sources

- `notes/2026-07-28-c682-operator-schlafli.md`
- `notes/clebsch-tasks/c695-paper-iii-e6-minuscule-27.md`
- `notes/2026-07-29-c696-daniel-litt-crossover-audit.md`
- Krämer--Litt--Maculan, arXiv:2604.20970, especially Sections 1.1,
  1.3, 2, 4.3, and 4.4
- Laurent Manivel, arXiv:math/0507118
