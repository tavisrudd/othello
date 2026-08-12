# C904: residual \(C_3\) does not kill the Kunneth escape

Date: 2026-08-11

Status: theorem-grade monodromy calculation and exact descent boundary;
Paper V research only; no manuscript or Lean change

## Verdict

A horizontal algebraic class on the relative
\(\operatorname {Sym}^2M\) does have a residual-\(C_3\)-invariant
cohomology class.  In the mixed channels, however, the invariant object is
the **whole transfer tensor**, not either Lefschetz-cokernel factor by
itself.  This distinction prevents a false vanishing theorem.

Let

\[
 Q_{15}=\operatorname {coker}\left(
  \Theta\wedge:\bigwedge^5\Lambda_2\to\bigwedge^7\Lambda_2\right),
 \qquad \dim_{\mathbf F_2}Q_{15}=10,
\]

and let \(U_{24}\) and \(Q_{24}\) be the paired effective first factor and
Lefschetz cokernel in the \((2,4)\) channel, both of dimension \(44\).
For the actual residual generator:

\[
\begin{array}{c|c|c}
\text{module}&\dim&\dim(-)^{C_3}\\ \hline
\Lambda_2&10&0\\
Q_{15}&10&0\\
U_{24}&44&24\\
Q_{24}&44&24.
\end{array}
\]

Nevertheless diagonal tensor invariants are large:

\[
 \dim(\Lambda_2\otimes Q_{15})^{C_3}=50,\qquad
 \dim(U_{24}\otimes Q_{24})^{C_3}=776.
\]

The first space is \(M_5(\mathbf F_4)\) as an \(\mathbf F_2\)-space.
It contains the coefficient identity, whose unordered addition degree is
five.  The second space also contains invariant classes on which the degree
functional is odd.  Thus invariant odd cohomology cosets exist in both
residual channels.  Residual \(C_3\) cannot prove relative index two.

The odd \(p=1/5\) identity is not merely an abstract mod-two accident.  It
has a canonical rational algebraic realization: push
\(H^3(M)\) into \(H^5(J)\), apply the algebraic inverse Lefschetz operator
twice, and pull back to \(M\).  The resulting correspondence has
codimension three on \(M^2\), is polarization-canonical and
\(C_3\)-equivariant.  The exact missing datum is an **integral** algebraic
lift across the ten elementary divisors two.

There is also no hidden benefit from killing \(C_3\) by the degree-three
root-resolvent cover.  Restriction--corestriction is injective modulo two
across every odd-degree extension.  If an actual odd cycle exists after a
cyclic cubic base change, its norm has odd degree downstairs.  The only
possible base-change obstruction is therefore on the even deck, not the
residual \(C_3\).

The exotic deck is \(C_2\).  Averaging there doubles degree, and Chow
descent is governed by a Tate quotient, not by invariant cohomology.  If
that obstruction is nonzero, a quadratic cover is the parity-minimal
possible splitting cover.  Current calculations do not prove that the
obstruction is nonzero, nor that the quadratic cover already carries the
needed integral cycle.

## 1. The modules that monodromy actually sees

Work modulo two.  Put

\[
 \Lambda_2=H^1(J,\mathbf F_2),\qquad L=\Theta\wedge- .
\]

On the common twist--sign cover, a generator \(g\) of the residual
\(C_3\) acts on \(\Lambda_2\) as five copies of the irreducible
two-dimensional module

\[
 V=\mathbf F_2^2,\qquad
 g|_V=\begin{pmatrix}1&1\\1&0\end{pmatrix}.                 \tag{1.1}
\]

This action preserves \(\Theta\), hence all Lefschetz images and
cokernels.  The two residual degree pairings from the full Kunneth audit
are

\[
 \Lambda_2\otimes Q_{15}\longrightarrow\mathbf F_2,
 \qquad
 U_{24}\otimes Q_{24}\longrightarrow\mathbf F_2,          \tag{1.2}
\]

where

\[
\begin{split}
 Q_{15}&=\operatorname {coker}
       (L:\bigwedge^5\Lambda_2\to\bigwedge^7\Lambda_2),\\
 U_{24}&=L\bigwedge^2\Lambda_2\subset\bigwedge^4\Lambda_2,\\
 Q_{24}&=\operatorname {coker}
       (L:\bigwedge^4\Lambda_2\to\bigwedge^6\Lambda_2).
\end{split}                                                \tag{1.3}
\]

The first error to avoid is replacing invariance of a tensor in (1.2) by
invariance of either tensor factor.  A horizontal correspondence is fixed
under the *diagonal* action.

### Proposition 1.4 (exact residual representations)

As \(\mathbf F_2[C_3]\)-modules,

\[
 \Lambda_2\simeq Q_{15}\simeq V^5,
 \qquad
 U_{24}\simeq Q_{24}\simeq \mathbf 1^{24}\oplus V^{10}.   \tag{1.4}
\]

Consequently

\[
 \dim(\Lambda_2\otimes Q_{15})^{C_3}=50,
 \qquad
 \dim(U_{24}\otimes Q_{24})^{C_3}=776.                    \tag{1.5}
\]

**Proof.**  The deterministic exterior-power calculation attached to this
note gives the dimensions and fixed dimensions

\[
 (10,0),(10,0),(44,24),(44,24)
\]

for \(\Lambda_2,Q_{15},U_{24},Q_{24}\), respectively.  Since
\(|C_3|\) is odd, Maschke semisimplicity applies in characteristic two.
The only irreducibles are \(\mathbf 1\) and \(V\), so dimensions and fixed
dimensions force (1.4).  Also
\(\operatorname {End}_{C_3}(V)=\mathbf F_4\).  Therefore the first
invariant tensor space is \(M_5(\mathbf F_4)\), of \(\mathbf F_2\)-dimension
50.  In the second channel the trivial blocks contribute \(24^2\) and the
\(V\)-blocks contribute \(2\cdot10^2\), giving 776.  This representation
argument is an independent check of the coordinate calculation. \(\square\)

The pairings (1.2) are perfect and \(C_3\)-equivariant.  The coefficient
identity in \(M_5(\mathbf F_4)\) has unordered degree five.  In the second
channel, the perfect pairing restricts perfectly between the semisimple
trivial isotypic summands, so there are fixed tensors with pairing one.
These are statements about integral cohomology modulo two.  They do **not**
assert that every such tensor is a Hodge class or an algebraic Chow class.

## 2. What horizontality proves, and what it does not

Let \(S\) be a connected marked base carrying the relative principally
polarized abelian fivefold, theta resolution \(M/S\), and residual
\(C_3\)-monodromy.  For a horizontal class

\[
 Z\in CH^3(\operatorname {Sym}^2_S M),
\]

the integral half anti-graph class from the full Kunneth theorem is a flat
section of the corresponding integral local system.  Its reductions in the
two mixed channels therefore lie in

\[
 (\Lambda_2\otimes Q_{15})^{C_3},\qquad
 (U_{24}\otimes Q_{24})^{C_3}.                             \tag{2.1}
\]

This is a necessary cohomological condition only.  Passing successively
from invariant cohomology to an invariant integral Hodge class, to an
algebraic class on a geometric fibre, and then to a horizontal Chow class
comprises three distinct gates.  Neither group cohomology nor the
calculation above collapses them.

### Proposition 2.2 (conditional parity criterion)

Suppose that on the generic fibre:

1. every algebraic monodromy-invariant class in the two residual spaces
   (2.1) has even degree;
2. there is no odd theta-supported algebraic curve (the \((0,6)\) channel).

Then every codimension-three horizontal multisection of
\(\operatorname {Sym}^2M\to J\) has even degree.  If an independent
degree-two multisection is available, its generic index is exactly two.

**Proof.**  The \((3,3)\) contribution is always even.  The axis channel is
even by hypothesis 2.  The only remaining contributions are (2.1), and
hypothesis 1 makes both even.  The degree is their sum.  The last assertion
is the definition of the index as the gcd of degrees of closed points (or
multisections). \(\square\)

Proposition 1.4 shows that one cannot establish hypothesis 1 by showing
that the ambient \(C_3\)-fixed residual cohomology vanishes: it does not.
In fact the \((1,5)\) channel contains an odd invariant Hodge class.

## 3. The rational algebraic \((1,5)\) class

Let \(b:M\to J\) be the theta-resolution map and let \(\Lambda_J\) denote
the rational algebraic Lefschetz-lowering correspondence of the polarized
abelian fivefold.  Standard conjecture \(B(J)\) is a theorem for abelian
varieties; equivalently this lowering operator is furnished by the
Fourier--Poincare correspondence.  Consider

\[
       \Pi_{15}= {}^t\Gamma_b\circ\Lambda_J^2\circ\Gamma_b. \tag{3.1}
\]

Here \(\Gamma_b\subset M\times J\) has codimension five,
\(\Lambda_J^2\subset J\times J\) has codimension three, and
\({}^t\Gamma_b\subset J\times M\) has codimension five.  Composition over
the two intermediate copies of the fivefold gives

\[
       5+3+5-5-5=3,
\]

so (3.1) is a rational algebraic codimension-three correspondence on
\(M^2\).  On cohomology it is the composite

\[
 H^3(M)\xrightarrow{b_*}H^5(J)
 \xrightarrow{\Lambda_J^2}H^1(J)
 \xrightarrow{b^*}H^1(M).                                 \tag{3.2}
\]

It kills the primitive \(H^3(J)\) part and extracts the
\(L H^1(J)\) part, up to the explicit nonzero Lefschetz scalar.  After the
standard rational normalization it realizes the coefficient identity,
hence the odd degree-five class.  Since (3.1) is built from the
polarization and the graph of the theta inclusion, it is canonical under
polarized automorphisms and residual-\(C_3\)-equivariant.  The same
construction works relatively with rational coefficients by the relative
Poincare correspondence.  The lowering operator may be chosen
self-adjoint, so \(\Pi_{15}\) is invariant under transposition; therefore
\(\frac12q_*\Pi_{15}\) is the corresponding rational class on
\(\operatorname {Sym}^2M\).

This closes the **rational algebraicity** question.  It does not close the
integral problem: the Smith form

\[
 L:\bigwedge^5H^1(J,\mathbf Z)\longrightarrow
   \bigwedge^7H^1(J,\mathbf Z)
 \quad\text{is}\quad 1^{110}2^{10}.                        \tag{3.3}
\]

Thus the rational projector has precisely ten dyadic directions in which
an integral lift is not supplied.  Constructing a horizontal integral Chow
representative, or proving that none exists, is the original two-local
inverse-Lefschetz/minimal-theta-curve gate in another form.

## 4. Odd covers cannot remove a dyadic obstruction

Let \(K\subset L\) be a finite extension of odd degree and let \(Y/K\) be
proper.  Then

\[
 \operatorname {ind}(Y_L)\mid\operatorname {ind}(Y),\qquad
 \operatorname {ind}(Y)\mid[L:K]\operatorname {ind}(Y_L). \tag{4.1}
\]

The first divisibility is base change; the second is corestriction of
closed points.  Hence

\[
       v_2(\operatorname {ind}(Y_L))
       =v_2(\operatorname {ind}(Y)).                        \tag{4.2}
\]

The same conclusion holds for any mod-two obstruction compatible with
restriction and corestriction, since
\(\operatorname {cor}\operatorname {res}=[L:K]\) is the identity modulo
two.  In particular the degree-three root-resolvent cover that kills the
residual \(C_3\) cannot kill a genuine dyadic obstruction.  More strongly,
if it produces an odd-degree zero-cycle, its norm is already an odd-degree
zero-cycle over \(K\).

By contrast, on the exotic quadratic cover with deck involution \(\sigma\),

\[
 \operatorname {res}\operatorname {cor}=1+\sigma,
 \qquad
 \operatorname {cor}\operatorname {res}=2.                \tag{4.3}
\]

Thus averaging loses precisely the parity one needs.  For an invariant
candidate Chow class on the cover, failure to be a norm is measured by its
class in

\[
 \widehat H^0(C_2,CH^3)
 =CH^3{}^{\sigma}/(1+\sigma)CH^3.                           \tag{4.4}
\]

This Tate class is a norm-descent obstruction, not a theorem that every
invariant cohomology class is algebraic or that ordinary Chow restriction
is effective.  It correctly locates the unresolved two-primary datum.
If a nonzero obstruction is killed by finite base change, that base change
must have even degree.  The exotic quadratic cover is therefore the first
parity-minimal candidate; neither its sufficiency nor nonvanishing of the
obstruction has been proved.

## 5. Consequences and killed routes

1. **Killed: fixed vectors of \(Q_{15}\).**  Although
   \(Q_{15}^{C_3}=0\), the relevant diagonal tensor has 50 fixed
   dimensions and an odd identity class.
2. **Killed: fixed vectors of \(Q_{24}\).**  The full tensor has 776 fixed
   dimensions and odd cohomological pairings.
3. **Killed: the cubic root-resolvent as a splitting cure.**  Odd
   restriction--corestriction preserves the two-adic index exactly.
4. **Closed rationally, open integrally:** the \((1,5)\) identity has the
   rational algebraic representative (3.1); its integral denominator is
   the same ten-direction dyadic Lefschetz defect already isolated by the
   Smith form.
5. **Sole live boundary:** decide whether a horizontal integral Chow class
   realizes an odd invariant residual tensor, equivalently close the
   integral inverse-Lefschetz/minimal-theta-curve gate.  If one first passes
   to the exotic cover, the remaining descent datum is genuinely
   two-primary and is visible in (4.4).

## 6. Reproducibility and source boundary

The exact finite calculation is in
`notes/2026-08-11-c904-c3-kunneth-residuals.sage`, with canonical output in
the adjacent `.out` file.  Replay from the repository root with a Sage
shell that does not create preparsed `.sage.py` debris:

```sh
nix shell nixpkgs#sage -c sh -lc \
  'sage --nodotsage -c \
   "load(\"notes/2026-08-11-c904-c3-kunneth-residuals.sage\")" \
   > /tmp/c904-c3-kunneth-residuals.replay && \
   cmp /tmp/c904-c3-kunneth-residuals.replay \
       notes/2026-08-11-c904-c3-kunneth-residuals.out'
```

Inputs are the rank-ten symplectic \(\mathbf F_2\)-space, the standard
theta bivector, and the residual generator (1.1).  Enumeration is
deterministic and uses no randomness.  The script certifies the four module
dimensions, their fixed dimensions, and the tensor-invariant dimensions.
It does not certify Hodge or Chow algebraicity.  The semisimple
representation proof following Proposition 1.4 independently checks the
tensor counts.

The integral Kunneth lattices, half anti-graph formula, and Smith forms are
proved and certified in
`notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md` and its
adjacent replay bundle.  The residual-base identification and the limits of
odd-order descent are audited in
`notes/2026-08-10-c904-c3-descent-scope-audit.md`.  The integral symmetric
square lattice input is Nakaoka's theorem as presented in A. Gugnin,
*On integral cohomology ring of symmetric products*, arXiv:1502.01862,
Theorem 1 (cached PDF SHA-256
`74c1d9703302911afafc86c8e4c98f39392622f89be314c2c7f9e565b9a10a96`).
The use of algebraic rational inverse Lefschetz is only the classical
standard-conjecture-B theorem for abelian varieties; no integral or
two-local strengthening is imported.

The validated environment was SageMath 10.7.  Artifact ledger:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-c3-kunneth-residuals.sage` | 4126 | `060de8f2def70597db5f79afcc66ce298524915d179423dc429ebc196ffd8daa` |
| `2026-08-11-c904-c3-kunneth-residuals.out` | 440 | `b539fa90d0f15d2cfc5fc279acc3ba4a02e18102f7a53cedbea6bcc833e65442` |

## Mystery ledger (EJ + TT closeout)

- **Settled:** residual \(C_3\) does not force evenness; the missing tensor
  coupling was the source of the tempting false vanishing.
- **Settled:** the odd \((1,5)\) class is rationally algebraic by an ambient
  abelian correspondence of the correct codimension.
- **Open:** whether that rational class has an integral or
  \(\mathbf Z_{(2)}\)-algebraic representative.  Exact gap: ten elementary
  divisors two in (3.3).
- **Open:** whether the \((2,4)\) invariant residual contains an integral
  horizontal algebraic odd class.  Exact gap: invariant cohomology has not
  been intersected with the integral horizontal Chow image.
- **Open:** whether the exotic quadratic cover kills the Chow norm class
  (4.4).  It is parity-minimal, but no splitting cycle or nonvanishing
  theorem is known.

## Scope note (2026-08-11)

No correction is needed here.  The C908 normalization adjudication,
`notes/2026-08-11-c908-unordered-degree-normalization.md`, rules that the raw
\(\mathbf F_2\)-linear contraction *is* the unordered \((1,5)\) degree — there is
no second halving on passage to the symmetric quotient — and under that ruling
this note's verdict is **confirmed** for the residual \(C_3\): §5 item 1 and the
ledger line "residual \(C_3\) does not force evenness" stand, because
\(\operatorname {End}_{C_3}(V^5)\cong M_5(\mathbf F_4)\) does carry odd
contractions, namely the \(w\)-twisted cosets whose \(\mathbf F_4\)-coefficient
trace lies outside \(\mathbf F_2\); the recorded invariant dimensions 50 and 776
are untouched.  What flips is only the extension of the statement to the full
\(S_3=C_3\rtimes C_2\) obtained by adjoining the exotic deck, treated in
`notes/2026-08-11-c904-exotic-deck-kunneth-descent.md` and its correction: there
the fixed subalgebra is \(M_5(\mathbf F_2)\), on which the degree vanishes
identically, so the deck vanishing is a genuine parity obstruction for classes
defined over the unmarked base.  That obstruction does not reach the marked base
this note works over.
