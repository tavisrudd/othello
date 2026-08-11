# C904 regular-primary ghost bridge: exact reduction and remaining gate

Date: 2026-08-11

Status: exact structural reduction plus a conditional exponent theorem; Paper V
research only; no manuscript or Lean edit

## Verdict

The proposed regular-primary minimal-curve formula

\[
 v_p\!\left(\operatorname {ord}(\gamma_T\bmod P_T^{g-1})\right)
 \stackrel{?}{=}
 \min\{v_p((g-1)!),\lfloor\log_p h(T)\rfloor\}
 \tag{1}
\]

has not yet been proved in arbitrary height.  The exact bridge can,
however, be reduced to one sharply stated integral combinatorial lemma.

Three parts are now rigorous.

1. The graph-gluing curve problem is exactly a mixed-cofactor lattice
   problem for the congruence centralizer
   \(L_T=\{D=D^t:[D,T]\equiv0\pmod p\}\).  No exterior-algebra or
   polarization normalization remains hidden.
2. For a cyclic primary block, this congruence centralizer has a Frobenius
   Hankel normal form attached to
   \(\mathbf F_{p^d}[u]/u^h\).
3. The first carry, after cyclic reduction, is literally the truncated
   de Rham/necklace ghost differential
   \(d(u^n)=n u^{n-1}du\).  Its exact torsion exponent is
   \(p^{\lfloor\log_p h\rfloor}\).

What is not yet rigorous is that the distinguished open-chain cofactor
class sees all and only this cyclic quotient.  This is the
**open-chain/marked-cycle straightening lemma** stated in Section 4.  It must
also control the Frobenius functional (bilinear type) and unramified residue
degree.  Formula (1) follows formally once that lemma is proved.

The new dyadic regular-nilpotent sixfold is an important correction to the
scope of the bridge: its minimal-curve order is four, but its top-product
index is eight.  Thus the ghost calculation can govern the open-chain
cofactor edge without governing the determinant/top edge.  Any full theorem
must be graded by cohomological degree.

## 1. Exact graph-to-mixed-cofactor reduction

Let

\[
 B=\begin{pmatrix}p^{-1}I&p^{-1}T\\0&I\end{pmatrix}
\]

be the rational basis matrix of a graph gluing, with \(T=T^t\) modulo
\(p\).  A rational Hodge two-form on the covering elliptic power has
coefficient matrix \(A=A^t\) and alternating matrix

\[
 \Xi_A=\begin{pmatrix}0&A\\-A&0\end{pmatrix}.
\]

Direct multiplication gives

\[
 B\Xi_{pD}B^t=
 \begin{pmatrix}
  (DT-TD)/p&D\\-D&0
 \end{pmatrix}.
 \tag{2}
\]

Consequently \(pD\) descends to an integral divisor precisely when

\[
 D=D^t,\qquad DT=TD\pmod p.
 \tag{3}
\]

The principal polarization pulls back to \(p\Xi_I\).  Both a product of
\(g-1\) descended divisors and the divided minimal class therefore contain
the common factor \(p^{g-1}\).  Cancelling it and using the standard
cofactor identification of the relevant symmetric Hodge-coefficient
subspace

\[
 \operatorname {Sym}_g
 \hookrightarrow
 \bigwedge^{g-1}(V\oplus V)^*_{(g-1,g-1)}
\]

shows the following.

> **Mixed-cofactor reduction.**  Let \(C_{g-1}(L_T)\) be the integral span
> of all complete mixed adjugates
> \(\operatorname {Adj}(D_1,\ldots,D_{g-1})\), with \(D_i\in L_T\),
> normalized so that
> \(\operatorname {Adj}(I,\ldots,I)=(g-1)!I\).  Then
> \[
>  \operatorname {ord}(\gamma_T\bmod P_T^{g-1})
>  =\operatorname {ord}(I\bmod C_{g-1}(L_T)).
>  \tag{4}
> \]

This also proves the universal factorial ceiling: the right side divides
\((g-1)!\).  Formula (2) explains the role of the carry.  It is not an extra
term in (4); it is exactly the integrality condition defining \(L_T\).

The analogous top product is controlled by the polarized determinant of
\(L_T\), not by its mixed adjugate.  These are different integral lattices,
as the sixfold computation proves.

There is nevertheless a universal graded constraint.  If

\[
 d_k=\operatorname {ord}\!\left(
       \Theta^k/k!\bmod P^k\right),
\]

then multiplying a product representative for \(d_k\Theta^k/k!\) by
\(\Theta\) gives

\[
 d_{k+1}\mid (k+1)d_k.
 \tag{4a}
\]

Thus a new factor at the next graded edge can only come from \(k+1\).  The
rank-six dyadic split is sharp in this bound:
\(v_2(d_5)=2\) and \(v_2(d_6)=3=v_2(d_5)+v_2(6)\).

## 2. Cyclic-primary Frobenius/Hankel normal form

Suppose the reduced self-adjoint module is cyclic primary.  Its commutant is

\[
 R=\mathbf F_{p^d}[u]/u^h.
\]

Write \(k=\mathbf F_{p^d}\).  Choosing a cyclic vector identifies the
module with \(R\), and the self-dual \(\mathbf F_p\)-pairing has the form

\[
 \langle a,b\rangle
 =\operatorname {Tr}_{k/\mathbf F_p}(\lambda(ab)),
 \tag{5}
\]

where \(\lambda:R\to k\) is a \(k\)-linear Frobenius functional.  In the
\(k\)-basis \(1,u,\ldots,u^{h-1}\), multiplication by \(u\) is self-adjoint
and the Gram matrix before restriction of scalars is Hankel.  The symmetric
centralizer consists of the forms

\[
 H_a=(\lambda(a u^{i+j}))_{i,j},\qquad a\in R.
 \tag{6}
\]

After lifting \(k\) to its unramified integer ring and restricting scalars,
the local integral lattice has the form

\[
 L_T=H_R+p\operatorname {Sym},
 \tag{7}
\]

where \(H_R\) is the rank-\(dh\) Frobenius-Hankel lattice.  Changing the
cyclic vector or the Frobenius functional multiplies the Hankel generator by
a unit of \(R\).  This proves the normal form, but it does **not** by itself
prove that the order of the principal target is independent of that unit;
that assertion belongs in the straightening lemma below, especially at
\(p=2\).

## 3. The exact cyclic carry is de Rham/ghost arithmetic

The load-bearing integer \(n\) does not come from a numerical analogy with
Witt vectors.  It is already forced by the commutator carry.  In universal
noncommutative differentials,

\[
 d(u^n)=\sum_{i=0}^{n-1}u^i(du)u^{n-1-i}.
 \tag{8}
\]

Passing to cyclic words modulo commutators identifies all \(n\) summands and
gives

\[
 d(u^n)=n u^{n-1}du.
 \tag{9}
\]

Equation (8) is the formal version of the exact carry identity

\[
 [E,T^n]=\sum_{i=0}^{n-1}T^i[E,T]T^{n-1-i}.
 \tag{10}
\]

For the integral truncated algebra \(A_h=\mathbf Z_p[u]/u^h\), one has

\[
 \Omega^1_{A_h/\mathbf Z_p}/dA_h
 \simeq\bigoplus_{n=2}^{h}\mathbf Z_p/n\mathbf Z_p,
 \tag{11}
\]

because \(d(u^n)=n u^{n-1}du\) for \(1\le n<h\), while differentiating the
relation \(u^h=0\) gives \(h u^{h-1}du=0\).  Hence

\[
 \exp_p(\Omega^1/dA_h)=p^{\lfloor\log_p h\rfloor}.
 \tag{12}
\]

This is the same diagonal presentation obtained by Moebius inversion from
the length-\(h\) additive necklace ghost map.  The source and terminology
audit is in
`notes/2026-08-11-c904-witt-ghost-exponent-source-audit.md`.

Equations (8)--(12) prove that the proposed height exponent is the exact
cyclic first-carry denominator.  They do not prove that the full mixed-
cofactor quotient has no further relation on the distinguished class.

## 4. Sole load-bearing gate

In the determinant expansion of a mixed cofactor in the Hankel model,
compare every matching with the reversal matching supplied by the principal
Hankel form.  Their union is a collection of closed alternating cycles and
one open alternating chain joining the deleted row and column.  A
\(p\operatorname {Sym}\) insertion marks an edge; forgetting the mark on a
cycle of length \(n\) has multiplicity \(n\).  This is the concrete source
of (9) and of necklace coordinates.

The exact missing statement is:

> **Open-chain/marked-cycle straightening lemma.**  For every unimodular
> Frobenius-Hankel cyclic-primary block of radical height \(h\), integral
> straightening of the mixed-cofactor lattice (7) splits off the closed-cycle
> and nonprincipal open-chain terms.  On the cyclic summand generated by the
> principal open chain, the remaining presentation is
> \[
>  \bigoplus_{n=2}^{h}\mathbf Z_p/n\mathbf Z_p,
> \]
> the principal cofactor maps to an element with unit coordinate in every
> nonzero \(p\)-typical summand, and the only additional relation is
> \((g-1)!\) times that element.  The statement is invariant under change of
> Frobenius functional and descends from the unramified splitting ring.

If this lemma holds, the order of the principal element is

\[
 \gcd\!\left(p^{v_p((g-1)!)},
             p^{\lfloor\log_p h\rfloor}\right),
\]

which is exactly (1).  Conversely, the lemma names the possible failure
modes precisely:

- an extra integral relation among open chains could lower the order;
- a nonsplit extension between cycle-length pieces could raise it;
- the Frobenius unit/bilinear type could change which ghost coordinates the
  principal class meets;
- unramified descent could identify conjugate coordinates nonprimitively.

The existing finite data rule out these failures only in the computed
ranks.  They do not prove the lemma.

## 5. Degree-sensitive correction and proof priority

For the symmetric regular nilpotent dyadic matrix of rank six recorded in
`notes/2026-08-11-c904-regular-primary-degree-sensitive-defect.md`, exact
independent calculations give

\[
 \operatorname {ord}(\Theta^5/5!)=4,
 \qquad [H^{12}:P^6]=8.
\]

The curve value agrees with (12), since the two-primary part of
\(\operatorname {lcm}(1,\ldots,6)\) is four.  The top value does not.  The
cheap determinant-content recursion therefore cannot prove (1); it computes
a different graded edge.  This is positive structural evidence for the
open-chain formulation: cofactors have one open chain, whereas determinants
have closed cycles only.

The highest-EV next move is not a larger census.  It is to prove the
straightening lemma first for the canonical nilpotent Hankel block over
\(\mathbf Z_p\), where reversal matchings give an explicit basis, and then
check invariance under a Frobenius unit.  Only after that should one descend
from an unramified splitting ring or classify several primary blocks.

## 6. `ej` + `tt` closeout

The extra value is a corrected theorem shape.  The natural invariant is not
one scalar defect attached to a gluing but a graded defect profile.  The
minimal-curve edge is plausibly a cyclic/de Rham-Witt edge; the top edge is
a distinct determinant/closed-necklace edge.  A successful straightening
proof should therefore be written as the first case of a graded
carry-enhanced Koszul complex, not as an isolated formula for (1).

A useful falsification test is also now exact: any proposed bridge that
identifies the whole product ring with the ordinary necklace ghost cokernel
is already false on the rank-six example.  The bridge must select the
open-chain cofactor summand.

## Mystery ledger

- **Settled:** the graph curve defect is exactly the mixed-cofactor problem
  (4), including the common \(p^{g-1}\) normalization.
- **Settled:** the cyclic first carry has diagonal coefficients
  \(1,2,\ldots,h\), hence exact \(p\)-exponent
  \(p^{\lfloor\log_p h\rfloor}\).
- **Settled:** the same ghost exponent cannot classify every cohomological
  degree; the regular dyadic sixfold has curve/top values \(4/8\).
- **Open, sole crown gate:** integral open-chain/marked-cycle straightening,
  including absence of hidden extensions.
- **Open:** invariance under the Frobenius unit/bilinear type, especially in
  characteristic two.
- **Open:** primitive descent across the unramified residue-degree splitting.

Vibe check: the full formula is still unproved, but the obstruction has been
reduced from a vague Witt analogy to one explicit integral permutation-
straightening theorem.  The rank-six correction simultaneously shows why
that theorem must be graded and why a determinant-only shortcut cannot work.
