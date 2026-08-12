# C907 Wave 1: double-presentation mutation audit

**Lane:** `clebsch`

**Date:** 2026-08-11

## Verdict

The toric pilot has a second presentation

\[
Y=\operatorname{Bl}_{\mathbf P^3}\mathbf P^5
 \simeq \mathbf P_{\mathbf P^1}(\mathcal O^{\oplus4}\oplus\mathcal O(1))
\]

in the quotient-projectivization convention.  Its projective-bundle
exceptional collection mutates by four explicit one-arrow mutations and one
helix move into the blow-up Orlov collection.  Thus the desired residual
`P^3` Euler lattice is already the finite integral mutation target.  This does
not identify it with the four escaping mirror thimbles.

## Geometry and collections

Let `p:Y -> P^1`, `H=c_1(O_Y(1))`, and `F=p^*c_1(O_(P^1)(1))`.  The blowdown is

\[
([x_0:\cdots:x_3:r],[s:t])\longmapsto
[x_0:\cdots:x_3:sr:tr],
\]

so `H` pulls back the hyperplane class and the exceptional divisor is
`E=H-F`.  In the lines convention the bundle is
`O^4 \oplus O(-1)`.

Put

\[
L_k=\mathcal O(kH-F),\qquad A_k=\mathcal O(kH).
\]

The projective-bundle collection from
`<O(-F),O>` on `P^1` is

\[
\mathcal P=\langle L_0,A_0,L_1,A_1,\ldots,L_4,A_4\rangle.
\]

This base twist is part of the convention.  Starting instead from
`<O,O(F)>` globally twists the collection by `F` and produces the correspondingly
twisted exceptional-divisor objects; it should not be mixed with the
untwisted Orlov target below.

For `0 <= j <= 3`, the exceptional-divisor sequence is

\[
0\longrightarrow A_j\longrightarrow L_{j+1}\longrightarrow R_j
\longrightarrow0,
\]

where

\[
R_j=i_{E*}\bigl(p_E^*\mathcal O_{\mathbf P^3}(j)
 \otimes\mathcal O_E(-1)\bigr).
\]

Since `RHom(A_j,L_(j+1))=C`, this says literally
`R_j=L_(A_j)(L_(j+1))`.  Four such mutations and the permitted zero-Hom
swaps give

\[
\langle L_0,R_0,R_1,R_2,R_3,A_0,A_1,A_2,A_3,A_4\rangle.
\]

Here `K_Y=-5H-F`.  The helix-normalized rotation of `L_0` through the other
nine objects uses

\[
S_Y^{-1}(L_0)[5]=L_0\otimes K_Y^{-1}=\mathcal O(5H)=A_5
\]

and produces exactly

\[
\langle R_0,R_1,R_2,R_3,A_0,A_1,\ldots,A_5\rangle.
\]

## Finite Euler calculation

For `a=l-k >= 0`, the block from `(L_k,A_k)` to `(L_l,A_l)` is

\[
G_a=
\begin{pmatrix}A_a+B_a&2A_a+B_a\\B_a&A_a+B_a\end{pmatrix},
\qquad
A_a={a+4\choose4},\quad B_a={a+4\choose5}.
\]

The four integral replacements `[R_j]=[L_(j+1)]-[A_j]`, followed by the
helix replacement `L_0 -> A_5`, factor this Gram matrix into the blow-up
blocks.  The residual block is

\[
\begin{pmatrix}
1&4&10&20\\
0&1&4&10\\
0&0&1&4\\
0&0&0&1
\end{pmatrix},
\]

the Beilinson Euler matrix of `P^3`; the ambient block is the Beilinson matrix
of `P^5`.

## Acceptance boundary

This proves that there is no `K`-lattice, Euler-pairing, or finite-mutation
obstruction to the residual block being the center block.  It does not prove
that the four escaping Lefschetz thimbles form the ordered basis above, nor
that these categorical mutations are the Stokes mutations of the pilot's
Laurent polynomial.  The missing datum remains their distinguished
intersection/central-connection matrix.

Iritani, arXiv:1906.00801, Theorem 7.31 and Remark 7.32, supplies the relevant
toric `K`-group/Orlov decomposition but not the residual-center Stokes
identification; Remark 1.4(3) records that stop.

## EJ/TT closeout

- **EJ:** the second, projective-bundle presentation converts the categorical
  side of the residual comparison into five elementary integral basis moves.
- **TT:** this does not determine a Stokes matrix from critical values or an
  Euler matrix.  Any argument making that jump is rejected.

## Mystery ledger

- **Settled:** the two exceptional collections are connected by an explicit
  finite integral mutation chain.
- **Settled:** its residual Euler block is the target `P^3` matrix.
- **Open:** identify a distinguished basis of the four escaping thimbles and
  compute its intersection and central-connection matrices.
- **Open:** compare that analytic basis with the mutated Orlov--Beilinson
  basis modulo the permitted formal, lattice, and pairing gauges.
