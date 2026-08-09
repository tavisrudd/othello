# C895 finite-group Hom matrix specification

**Date:** 2026-08-09  
**Task:** C895  
**Status:** R1 coefficient system specified; proposed Lucas exhaustiveness
falsified at `q=9` by the extra `L(2,0)` catalecticant copy

## Objective

Compute the actual finite-group space

\[
 \operatorname{Hom}_{H}
 \bigl(L(c_0,\ldots,c_{e-1}),W\otimes W\bigr),
 \qquad W=\nabla(d),\quad d=(q-3)/2,
\]

and then take the tensor-flip `+1` eigenspace.  The purpose of this memo is to
replace the phrase “Lucas's theorem factors its coefficient matrix” by the
exact matrix that must be factored.  It does not yet claim the factorization.

## Conventions

Write

\[
 e_i^{(n)}=X^{n-i}Y^i,qquad 0\le i\le n,
\]

and let

\[
 u(t):(X,Y)\longmapsto(X,Y+tX).
\]

Then

\[
 u(t)e_i^{(n)}=
 \sum_{a=0}^{i}\binom ia t^{i-a}e_a^{(n)}.              \tag{H1}
\]

For the simple source put

\[
 V=L(c_0,\ldots,c_{e-1})
   =\bigotimes_{j=0}^{e-1}L(c_j)^{(j)},
\]

with basis `v_m`, where `m=(m_0,...,m_(e-1))` and
`0<=m_j<=c_j`.  Equation (H1) gives

\[
 u(t)v_{\mathbf m}
 =\sum_{\mathbf a\le\mathbf m}
   \left(\prod_j\binom{m_j}{a_j}\right)
   t^{\sum_jp^j(m_j-a_j)}v_{\mathbf a}.                 \tag{H2}
\]

Write a candidate linear map as

\[
 \phi(v_{\mathbf m})=
 \sum_{0\le r,s\le d}A_{r,s;\mathbf m}
          e_r^{(d)}\otimes e_s^{(d)}.                   \tag{H3}
\]

The variables of the finite-group Hom system are the scalars
`A_(r,s;m)`.

## Torus rows

For `z in F_q^*`, the diagonal element with eigenvalues `z,z^(-1)` gives the
necessary support condition

\[
 2d-2r-2s
 \equiv
 \sum_jp^j(c_j-2m_j)\pmod{q-1}.                         \tag{H4}
\]

Only variables satisfying (H4) are retained.  The interval of target weights
is `[-(q-3),q-3]`, so a finite-torus character may have two algebraic-weight
representatives.  Both are kept in the same system; neither is discarded as
an “incorrect” highest weight.

## Positive-root rows

For every source index `m`, target index `(R,S)`, and integer `N`, comparison
of the coefficient of
`t^N e_R^(d) tensor e_S^(d)` in

\[
 (u(t)\otimes u(t))\phi(v_{\mathbf m})
 =\phi(u(t)v_{\mathbf m})
\]

gives

\[
\begin{split}
 &\sum_{\substack{r\ge R,\ s\ge S\\
                   (r-R)+(s-S)=N}}
   \binom rR\binom sS A_{r,s;\mathbf m} \\
 &\qquad=
 \sum_{\substack{\mathbf a\le\mathbf m\\
          \sum_jp^j(m_j-a_j)=N}}
 \left(\prod_j\binom{m_j}{a_j}\right)
 A_{R,S;\mathbf a}.                                    \tag{H5}
\end{split}
\]

Empty sums are zero.  It is enough to take `0<=N<=q-1`.  The target degree
is at most `2d=q-3`, and the source degree is at most
`sum p^j c_j<=q-1`.  Hence every entry of the intertwining identity has
degree at most `q-1`.  A polynomial of that degree vanishing at all `q`
elements of `F_q` is zero.  Thus equality on the finite root group is
coefficientwise and (H5) is the complete positive-root system.

In particular, the constant and `t^(q-1)` rows are not identified.  The
value at `t=0` is what prevents a `t^(q-1)-1` ambiguity and couples the two
torus aliases in (H4).

## Weyl rows and negative root

Choose

\[
 w:(X,Y)\longmapsto(-Y,X).
\]

Then

\[
 we_i^{(n)}=(-1)^{n-i}e_{n-i}^{(n)},
\]

and `w phi=phi w` supplies explicit signed reversal rows relating
`A_(r,s;m)` to `A_(d-r,d-s;c-m)`.  Since the negative root group is the Weyl
conjugate of the positive root group, (H5) plus these reversal rows is the
full `SL_2(q)` intertwining system.  All modules in the Paper II application
have trivial central action, so this is also the `H=PSL_2(q)` system.

## Candidate digitwise kernel

Write the digits of `d` as

\[
 n_0=(p-3)/2,
 \qquad n_j=(p-1)/2\quad(j>0).
\]

For one digit and `h>=0`, the standard alternating vector

\[
 h_{n,h}=\sum_{m=0}^{h}(-1)^m\binom hm
          e_m^{(n)}\otimes e_{h-m}^{(n)}
\]

generates a map from `L(2n-2h)`.  Put

\[
 h_j=\delta_j+2r_j,
 \qquad \delta_j\in\{0,1\},quad r_j\ge0,
\]

and tensor the Frobenius-twisted one-digit maps.  Composing with the socle
inclusion `L(d)->W` in each target factor gives candidate maps

\[
 \Psi_{\mathbf h}:
 L(2n_0-2h_0,\ldots,2n_{e-1}-2h_{e-1})
 \longrightarrow W\otimes W.                            \tag{H6}
\]

Their tensor-flip sign is `(-1)^(sum delta_j)`.  Therefore the proposed
`Sym^2 W` basis consists of the (H6) maps with even `sum delta_j`.

Substitution in (H4)--(H5) verifies that every (H6) is a finite-group map.
Linear independence follows from their distinct leading monomial tensors.
These are the easy directions.  They do not span the kernel of the complete
system: the `q=9` calculation in
`notes/2026-08-09-c895-q9-extra-hom-and-repair.md` exhibits an additional
`L(2,0)` map.

## Failed factorization and retained diagnostic

The failed spanning claim overlooked facts hidden by the current manuscript:

1. the target indices `0<=r,s<=d` do not form a rectangular product of
   independent base-`p` digit ranges;
2. addition of the two target lowering amounts in the left side of (H5) can
   carry between digits;
3. comparison with the source exponent in the right side can introduce a
   borrow state at an aliased weight; and
4. a solution could a priori have support outside
   `L(d) tensor L(d)` inside `W tensor W`.

A proof of a corrected full-socle theorem would need a digit induction that
orders the variables by the most significant non-socle digit and shows:

- every nonzero carry/borrow state has a pivot row in (H5), so its variables
  vanish or reduce to a lower state;
- the zero-state diagonal block is the Kronecker product of the one-digit
  triangular recurrences; and
- the two weight aliases meet in one boundary block whose `N=0` and
  `N=q-1` rows have no extra kernel.

The `q=9` extra kernel shows that the proposed nonzero-state pivot assertion
is false.  C895 therefore retains (H4)--(H5) as a diagnostic but replaces the
universal R1 theorem by detector-specific Hom statements.

## Falsification order

Before attempting general prose, solve (H4)--(H5) exactly in the smallest
extension fields that exercise each state:

- `q=9` for the first two-digit and characteristic-three aliases;
- `q=25` for an odd half-digit with a square subfield; and
- one exponent `e=3` case for a genuine internal carry.

These are bounded checks of the proposed basis, not evidence for the general
theorem.  Any extra kernel is a hard stop and forces a new R1 statement before
the outer-parity or subgroup arguments can be integrated.
