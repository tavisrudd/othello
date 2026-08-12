# C909 — hostile audit of the codimension-three defect formula

Date: 2026-08-11  
Status: split finite-etale audit; no manuscript, PDF, mirror, Lean, or commit
change

## Verdict: MINOR / conditional GO

The proposed formula

\[
 I_A^3/P_A^3\cong
 (R/\pi^a)^{5\binom g5+3\binom g6}
 \oplus (R/\pi^{2a})^{\binom g6}
\tag{1}
\]

has the correct multiplicities and exponents.  The squarefree six-slot
profile is settled by the bounded symbolic nested-minor audit, including
arbitrary pairwise-distinct residue roots; it is not merely a numerical
specialization.  The remaining issue is exposition/formalization: the
repeated-support volume-factor lemma and the base-change hypotheses must be
stated explicitly.  If those standard split-chart facts are admitted, (1)
is a GO for codimension three.  If the cited symbolic minors are not included
in the proof record, the result should remain conditional rather than be
called a proved theorem.

## 1. Multidegree count

For degree `k=3`, a nonzero diagonal `SL_2` invariant multidegree has one of

```text
(1,1,1,1,1,1)       ell=3, d=0 doubled slots,
(2,1,1,1,1)         ell=2, d=1 doubled slot,
(2,2,1,1)           ell=1, d=2 doubled slots,
(2,2,2)             ell=0, d=3 doubled slots.
```

For `ell` residual pairs and `d=3-ell` doubled slots, the number of support
components is

\[
 N(g,3,\ell)=\binom g{3+\ell}\binom{3+\ell}{3-\ell}
 =\binom g{2\ell}\binom{g-2\ell}{3-\ell}.
\tag{2}
\]

Thus

```text
ell=2: N=5*C(g,5),    squarefree residual profile (0,1),
ell=3: N=C(g,6),      squarefree residual profile (0,1,1,1,2),
ell=1,0: N=6*C(g,4), C(g,3), respectively, with no defect.
```

The first line contributes one `\pi^a` class per component.  The second
contributes three `\pi^a` and one `\pi^(2a)` class per component.  This gives
(1).  The factor `5` is essential: on a five-set there are five choices of
the doubled slot.

Checks:

```text
g=4: 0,
g=5: (R/pi^a)^5,
g=6: (R/pi^a)^33 ⊕ R/pi^(2a),
g=7: (R/pi^a)^126 ⊕ (R/pi^(2a))^7.
```

## 2. Repeated-support primitive volume factor

After an unramified splitting, use the graph basis

```text
L = direct_sum_i R<X_i,Y_i>,   X_i=pi^a x_i,   Y_i=y_i-t_i x_i.
```

For a doubled-slot set `D`, put

```text
V_D = wedge_{i in D}(X_i wedge Y_i).
```

`V_D` is literally an exterior basis monomial.  Therefore

\[
 u\longmapsto V_D\wedge u
\tag{3}
\]

is a split primitive embedding of the exterior lattice on the `2ell`
single slots.  The exterior multidegree decomposition is a direct sum, so no
other multidegree can cancel a denominator in (3).  This is the missing
primitive statement that rational multidegree factorization alone does not
provide.

In rational contraction coordinates,

\[
 \Omega_{ii}=\pi^{-a}X_iY_i,
 \qquad
 C_{ij}=\pi^{2a}\Omega_{ij},
 \qquad D_i=\pi^a\Omega_{ii}=X_iY_i.
\tag{4}
\]

On a fixed type with `d=3-ell` doubled slots, a product of three NS classes
has at least `d` diagonal factors to attain the minimal scale; choosing all
of them and an `ell`-matching on the singles gives the scale

\[
 \pi^{a d}\pi^{2a\ell}=\pi^{a(3+\ell)}
\tag{5}
\]

relative to the rational volume/matching basis.  A product with fewer than
`d` diagonal factors has strictly larger scale, since replacing a diagonal
factor by cross factors changes `\pi^a` to `\pi^{2a}`.  Integral Pluecker
straightening has coefficients `\pm1` and cannot lower this valuation.
Consequently, on each fixed multidegree, writing
`\Omega_D=\prod_{i\in D}\Omega_{ii}=\pi^{-a(3-\ell)}V_D`,

\[
 I_{D,\ell}=V_D\wedge I_{\mathrm{sq},\ell}
 =\pi^{a(3-\ell)}\Omega_D\wedge I_{\mathrm{sq},\ell},
 \qquad
 P_{D,\ell}=V_D\wedge P_{\mathrm{sq},\ell}
 =\pi^{a(3-\ell)}\Omega_D\wedge P_{\mathrm{sq},\ell},
\tag{6}
\]

where the first equalities are in the exterior basis and the second in
rational `\Omega` coordinates.  The common volume factor cancels in the
quotient.  This proves the repeated-
support reduction in the split chart, including types `(2,2,1,1)` and
`(2,2,2)`, whose residual matching ranks are one and hence saturated.

The proof must not say merely that the rational invariant component is a
volume times a matching module; it must use the primitive basis monomial
argument (3) and the valuation comparison (5).

## 3. Squarefree six-slot block and arbitrary roots

For six distinct slots, the exact cumulative coefficient ranks are

\[
 (\rho_0,\rho_1,\rho_2,\rho_3)=(1,4,5,5),
\tag{7}
\]

so the Smith valuations are

\[
 0,1,1,1,2.
\tag{8}
\]

The symbolic nested-minor audit in
`notes/2026-08-11-c909-symbolic-jet-minor-audit.md` supplies witnessing
minors for ranks one through five.  Their non-graph factors are products of
root differences; hence they are units whenever every `t_i-t_j` is a unit.
This is the needed arbitrary-root statement, not just the test `t_i=i`.
The finite-field exhaustion independently checked all normalized distinct
six-tuples for `F_7,F_8,F_9,F_11`, with profile `(1,4,5,5)` in every case;
`F_8` checks the dyadic sign/factor issue.

The four-slot block has the already proved profile `(0,1)`.  Therefore the
two nonzero residual contributions are exactly

\[
 (R/\pi^a)^3\oplus R/\pi^{2a}
\tag{9}
\]

for every six-slot support with pairwise-etale roots.

Important boundary: an assertion that the all-`ell` Dyck lemma is proved is
not needed for (1), but it would be false based only on the first-return
paragraph.  Codimension three uses only `ell=2,3`; higher semilength remains
open.

## 4. Descent

Let `S/R` be a finite unramified faithfully flat extension splitting the
finite-etale root algebra.  The descent step requires the explicit
identifications

\[
 I_A^3\otimes_R S=I_{A_S}^3,
 \qquad
 P_A^3\otimes_R S=P_{A_S}^3.
\tag{10}
\]

Under the marked graph construction these are base-change identities for
the prescribed integral Hodge and NS/product lattices.  Then

\[
 (I_A^3/P_A^3)\otimes_R S
 \simeq I_{A_S}^3/P_{A_S}^3.
\tag{11}
\]

Finite unramified base change preserves Smith exponents.  The split
multidegree summands need not descend individually—the root permutation
monodromy can permute them—but the multiplicities in (1) descend because
they are determined by the `\pi`-adic torsion filtration.  No canonical
labelled decomposition over `R` should be claimed.

## 5. Poincare-duality boundary

The count is compatible with the expected codimension symmetry because

\[
 N(g,k,\ell)=\binom g{2\ell}\binom{g-2\ell}{k-\ell}
\tag{12}
\]

is invariant under `k\leftrightarrow g-k`.  In particular, the codimension
three formula agrees with its dual codimension `g-3` formula:

* `g<5`: both sides have no defect;
* `g=5`: codim 3 gives five `\pi^a` classes, matching codim 2;
* `g=6`: codim 3 is self-dual;
* `g=7`: codim 3 gives `(126,7)` for exponents `(a,2a)`, and codim 4
  gives the same pair after `ell=2,3` are interchanged.

This is a consistency check, not a proof from Poincare duality: the Hodge
sub-lattice pairing and the divisor-product sublattice are not automatically
perfect duals.  Do not infer (1) solely from unimodularity of total integral
cohomology.  Also retain the boundary that the result is ambient integral
Hodge/cohomology, not a Chow realization or a zero-cycle statement.

## Final handoff

The formula itself is correct.  Codimension three can be promoted to a
theorem once the proof record includes (i) the explicit six-slot nested
unit minors (including the dyadic unit choice), (ii) the primitive volume
embedding (3), and (iii) the base-change identities (10).  Without those
three written gates, label it `conditional`; the unresolved all-degree web
lemma is not an obstruction to this codimension-three specialization.
