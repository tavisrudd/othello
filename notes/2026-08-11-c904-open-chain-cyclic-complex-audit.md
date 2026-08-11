# C904 open-chain diagrams versus the cyclic complex

Date: 2026-08-11

Status: exact one-carry chain map and precise residual relation; Paper V
research only; no manuscript or Lean edit

## Verdict

The mixed-cofactor matching quotient is **not literally** the Hochschild or
cyclic complex of the Frobenius algebra

\[
 R=O[u]/u^h.
\]

There is, however, an exact canonical chain map explaining the observed
ghost denominator.  Under the Frobenius identification
\(\operatorname {End}_O(R)\simeq R\otimes_O R\), commutation with \(u\) is
multiplication by the equation of the diagonal \(y-x\).  Together with the
complementary factor

\[
 q_h(x,y)=\frac{y^h-x^h}{y-x}
          =\sum_{i=0}^{h-1}y^{h-1-i}x^i,
\]

this is the standard two-periodic matrix factorization resolving the
diagonal of the truncated polynomial algebra.  After restriction to the
diagonal, the second map becomes multiplication by \(h u^{h-1}\).

The marked-cycle operation is therefore the Connes operator
\(B:HH_0(R)\to HH_1(R)\), which is the universal derivative on this
commutative algebra.  It is not the Hochschild boundary.  Its cokernel is

\[
 \operatorname {coker}B
 =\Omega^1_{R/O}/dR
 \simeq\bigoplus_{n=2}^{h}O/nO.
\]

This proves the cyclic/de Rham arithmetic inside the graph carry.  It does
not prove that determinant antisymmetrization induces an isomorphism on the
principal open-chain summand.  A later exact local-switch test, recorded in
`notes/2026-08-11-c904-local-switch-cyclic-readout-counterexample.md`, shows
that the readout does not descend termwise through purported local Pluecker
switches.  The missing construction must instead be made after the complete
determinant antisymmetrizer.

The obstruction is genuine, not formal bookkeeping.  A closed Frobenius
loop evaluates to the Euler element \(h u^{h-1}\), which is nonprimitive
exactly when \(p\mid h\).  Thus closed loops cannot be split off integrally
at the first defect wall.

## 1. Exact diagonal chain map

Normalize the Frobenius trace by

\[
 \lambda(u^{h-1})=1,\qquad \lambda(u^i)=0\quad(i<h-1).
\]

The perfect pairing \(\langle a,b\rangle=\lambda(ab)\) gives

\[
 \Phi:R\otimes_O R\longrightarrow\operatorname {End}_O(R),
 \qquad
 \Phi(a\otimes b)(z)=a\lambda(bz).
 \tag{1}
\]

Adjunction on endomorphisms corresponds to the transposition
\(a\otimes b\mapsto b\otimes a\).  In particular, self-adjoint graph
divisor coefficients are the transpose-invariant tensors.

Let \(x=u\otimes1\) and \(y=1\otimes u\).  A direct calculation gives

\[
 \Phi^{-1}\!\left(\Phi(a\otimes b)m_u-m_u\Phi(a\otimes b)\right)
 =(y-x)(a\otimes b).
 \tag{2}
\]

Thus the commutator carry is exactly the diagonal equation.  Since

\[
 (y-x)q_h(x,y)=y^h-x^h=0
 \quad\text{in }R\otimes R,
\]

one obtains the two-periodic diagonal complex

\[
 \cdots\xrightarrow{q_h}R^e\xrightarrow{y-x}R^e
 \xrightarrow{q_h}R^e\xrightarrow{y-x}R^e\longrightarrow R,
 \tag{3}
\]

where \(R^e=R\otimes_O R\).  Applying multiplication
\(R^e\to R\), hence setting \(x=y=u\), turns (3) into alternating maps

\[
 0,qquad h u^{h-1}.
 \tag{4}
\]

Consequently

\[
 HH_1(R/O)\simeq
 R\,du/(h u^{h-1}du)=\Omega^1_{R/O}.
 \tag{5}
\]

Equations (1)--(5) give a precise, basis-free intertwining of the one-carry
operator with the first differential of the diagonal/Hochschild resolution.
They also respect the self-adjoint/skew-adjoint parity: transposition
interchanges \(x\) and \(y\), so \(y-x\) is anti-invariant and \(q_h\) is
invariant.  This is an exact chain map for the diagonal resolution; it is
not yet a chain map out of the determinant mixed-cofactor quotient.

## 2. Marking is Connes \(B\), not Hochschild \(b\)

For a commutative algebra, the degree-one Hochschild boundary on
\(a_0\otimes a_1\) is zero.  It therefore cannot produce the coefficient
\(n\).  The relevant map is the Connes operator

\[
 B:HH_0(R)=R\longrightarrow HH_1(R)=\Omega^1_{R/O},
 \qquad B(a)=da.
 \tag{6}
\]

On the cyclic word \(u^n\), marking each possible position gives

\[
 B(u^n)=n u^{n-1}du.
 \tag{7}
\]

This is exactly the marked-versus-unmarked cycle multiplicity in the
matching diagrams and exactly the commutator identity

\[
 [E,u^n]=\sum_{i=0}^{n-1}u^i[E,u]u^{n-1-i}.
\]

Taking the cokernel of (6) and using (5) yields

\[
 \Omega^1_{R/O}/dR
 \simeq\bigoplus_{n=2}^{h}O/nO,
 \tag{8}
\]

with \(p\)-primary exponent \(p^{\lfloor\log_p h\rfloor}\).  Thus the
Hochschild-to-cyclic interpretation is exact at the one-open-chain carry
edge.

## 3. Why this is not yet the straightening theorem

The determinant mixed cofactor is obtained by applying an exterior
antisymmetrizer to \(g-1\) divisor tensors.  Relative to the principal
reversal matching, a term decomposes into one open alternating chain and a
collection of closed alternating cycles.  Frobenius contraction evaluates
these diagrams, and the one-mark part maps to (6).

But exterior antisymmetrization forms nonzero signed sums of local matching
switches; it does not quotient each switch to zero.  Conversely, arbitrary
\(p\operatorname {Sym}\) insertions are transpose-invariant tensors in
\(R\otimes R\), not arbitrary bar chains.  Therefore the diagram evaluation
gives a morphism to the cyclic complex, not an a priori isomorphism.

The finite invariants already disprove a literal identification of the full
quotients.  For the dyadic regular-nilpotent sixfold, the complete curve
product saturation quotient has elementary divisors

\[
 [2^{\times12},4^{\times9}],
\]

whereas (8) at \(h=6\) has two-primary elementary divisors

\[
 [2,2,4].
\]

Hence the cyclic complex can describe a selected subquotient containing the
principal class, not the whole open-chain product quotient.

There is also no integral direct splitting that simply discards closed
loops.  The Frobenius dual basis to
\(1,u,\ldots,u^{h-1}\) is
\(u^{h-1},u^{h-2},\ldots,1\), so the Euler element of a closed loop is

\[
 e_R=\sum_{i=0}^{h-1}u^i u^{h-1-i}=h u^{h-1}.
 \tag{9}
\]

At \(p\mid h\), this loop value is nonprimitive.  Splitting the closed-loop
sector would require dividing precisely at the wall the theorem is meant to
explain.

## 4. First missing relation and acceptance gate

Let \(\mathcal F_{g-1}(R)\) be the free integral module on marked matching
diagrams before determinant straightening, filtered by the number of
\(p\operatorname {Sym}\) marks.  Equations (1)--(7) define a cyclic-readout
map on its one-open-chain generators to the two-term cyclic edge

\[
 HH_0(R)\xrightarrow{B}HH_1(R).
\]

The corrected load-bearing claim is global:

> **Principal-chain determinant lemma.**  On the image of the complete
> multilinear adjugate, there is a well-defined linear cyclic obstruction
> whose restriction to the one-carry associated graded is (6).  Its kernel
> on the principal chain is generated by the single ordinary-product
> relation \((g-1)!\gamma=0\); closed-loop Euler elements introduce no
> additional relation on \(\gamma\).  The image of \(\gamma\) has a unit
> component in every nonzero summand of (8).

This lemma is sufficient for the proposed height formula and is strictly
stronger than the exact diagonal chain map above.  It is also the first
place a counterexample can occur.  Proving only that diagrams evaluate into
the cyclic complex gives an upper obstruction but not primitivity or a
lower bound for the principal class.

## Mystery ledger

- **Settled:** the graph commutator carry is the diagonal differential
  \(y-x\) under the Frobenius tensor-endomorphism identification.
- **Settled:** the complementary differential is \(q_h\), and its diagonal
  value is the Euler element \(h u^{h-1}\).
- **Settled:** marking a cycle is Connes \(B=d\), not the Hochschild
  boundary, and gives the exact ghost/de Rham exponent.
- **Settled:** the whole mixed-cofactor quotient is not the cyclic quotient;
  the rank-six elementary divisors differ.
- **Settled by the follow-up local test:** square switches are nonzero
  determinant contributions, not local relations killed by cyclic readout.
- **Open, crown gate:** construct cyclic readout globally on the image of
  the complete determinant antisymmetrizer and prove principal primitivity
  modulo Euler-loop and factorial relations.

Vibe check: the bar/Hochschild idea is real but narrower than hoped.  It
canonically explains the denominator and isolates the correct cyclic edge;
the crown still rests on a global determinant-isotypic primitivity theorem
rather than on a ready-made Hochschild isomorphism.
