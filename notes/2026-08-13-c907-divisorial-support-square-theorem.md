# C907 divisorial support-square theorem

**Lane:** clebsch

**Status:** exact conditional reduction of both Silver gates to one
support-local cyclotomic projector. Unlike a projector on formal solution
spaces, the required assignment must localize on supported categories.

## The theorem

Let

\[
 r:W\longrightarrow\mathbf P^5,\qquad
 f:W\longrightarrow\mathbf P^2
\]

be a smooth projective graph resolution of a dominant rational map
\(\mathbf P^5\dashrightarrow\mathbf P^2\), chosen by a specified sequence of
smooth-center principalization blowups (and, when used below, further smooth
blowups resolving the endpoint map). Put
\(L=f^*\mathcal O(1)\) and \(N=1-\tau_L\).

Assume a universal exact cyclotomic localizing invariant \(\mathcal P_6\) of
supported perfect dg/stable categories on every smooth variety over
\(\mathbf P^2\) occurring below, with:

1. **localization/devissage:** it is exact for support triangles and vanishes
   on every object supported on a possibly singular or nonreduced set of
   dimension at most two;
2. **Orlov additivity:** it preserves the ambient and exceptional component
   maps for every blowup in a construction of \(r\) and every relative
   blowup used in the weak factorization below;
3. **tensor equivariance:** it commutes with \(\tau_L\), hence with \(N\);
4. **point-kernel action:** universally on every such \(Y\to\mathbf P^2\), it
   is linear over perfect kernels and carries the
   support-action identity saying \((1-\tau_L)^2\) is induced by tensoring
   with the derived kernel \(K_q=\mathbb Lf^*\mathcal O_q\).  For
   \(A\in\operatorname{Perf}_D(Y)\), the \(N^2\)-action factors through
   \(\mathcal P_6(A\otimes^{\mathbb L}K_q)\), with
   \(A\otimes^{\mathbb L}K_q\in
   \operatorname{Perf}_{D\cap f^{-1}(q)}(Y)\);
5. **formal identification:** its realization is the whole generalized
   \(\zeta_6\) packet, compatibly with formal monodromy and Tate shifts; and
6. **ambient-category vanishing:** the invariant is zero on the entire
   category \(\operatorname{Perf}(\mathbf P^5)\), not merely on one aggregate
   numerical class.

Then

\[
 N^2=0\quad\text{on }\mathcal P_6(W).
 \tag{1}
\]

## Proof

Choose a general point \(q\in\mathbf P^2\). The Koszul identity in rational
K-theory is

\[
 N^2(-)=(-)\otimes[\mathbb Lf^*\mathcal O_q].
 \tag{2}
\]

The specified iterated-blowup presentation gives a composite Orlov filtration
with the ambient \(\operatorname{Perf}(\mathbf P^5)\) piece and
pieces supported on finite unions of components of the total exceptional
divisor \(E\subset W\).

The ambient category has zero packet by assumption 6. By the point-kernel
action axiom, \(N^2\) of any exceptional piece factors through support on

\[
 E\cap f^{-1}(q).
 \tag{3}
\]

Choose \(q\) outside the finitely many non-dominant images of the irreducible
components of \(E\).  Every dominant component has dimension four and
general fibre dimension two. Thus (3) is a finite union of possibly
singular/nonreduced schemes of dimension at most two. Assumption 1
kills its packet. Exactness and Orlov generation then kill \(N^2\) on the
whole packet, including all intersections and nonsplit extensions among
exceptional pieces. This proves (1).

## Conditional m=2 consequence

Suppose \(X\times\mathbf P^2\) were birational to \(\mathbf P^5\).  Choose
\(W\) by smooth principalization of the induced rational map to
\(\mathbf P^2\), followed by smooth blowups resolving its birational map to
the endpoint, so \(r\) remains an iterated blowup.  On the
\(\mathbf P^5\)-resolution side, the theorem gives
\(N^2=0\) on \(\mathcal P_6(W)\).

On the endpoint side, assume a smooth relative weak factorization over
\(\mathbf P^2\), compatible with this common model and the packet functor.
The line bundle \(L\) descends at every arrow.  Assume the
packet carries strict \(N\)-linear blowup biproducts along this zigzag.  Every
relative center has dimension at most three; applying the same point-support
square to it gives support of dimension at most one for a dominant center,
and empty support after choosing \(q\) outside a non-dominant image.  Hence no
relative center contains \(J_3\).  The positive Krull--Schmidt telescope
therefore preserves the endpoint \(J_3\) multiplicity across the zigzag.
Projective/Kunneth compatibility identifies that endpoint block as the cubic
\(\zeta_6\)-line tensored with \(K_0(\mathbf P^2)\), on which \(N^2\ne0\).
Thus \(W\) contains \(J_3\), contradicting (1).

The point \(q\) may be chosen separately for each of the finitely many
support tests: the Koszul identity and axiom 4 hold for every point, while
only the resulting vanishing statement is used.

Therefore assumptions 1--6, together with a \(\mathbf P^2\)-relative weak
factorization carrying strict packet-level \(N\)-linear blowup biproducts,
the center point-support argument, and the projective compatibility just
stated, imply that
\(X\times\mathbf P^2\) is irrational.

This route bypasses a separate classification of arbitrary threefold
centers: it kills the square after intersecting every exceptional divisor
with a general base point.

## Why weaker projectors fail

An idempotent only on the finite-dimensional formal solution space cannot
see the support in (3). It may preserve an abstract direct sum while allowing
extensions through exceptional intersections. The needed object must extend
to a localizing assignment on supported perfect categories or an equivalent
support-filtered motive.  Exactness and tensor equivariance alone also do not
upgrade the \(K_0\) equality (2) to a packet operator; the point-support
square axiom 4 is load-bearing.

Nor does ordinary \(K_0\) provide the projector. Tensor by \(L\) is
unipotent, whereas \(\zeta_6\) is quantum/formal-monodromy data. The
full-category Serre action is only signed-unipotent, and the cubic residual
Serre projector is mutation-dependent rather than presently functorial and
localizing. The missing theorem is exactly the external
quantum/Stokes-to-support bridge with \([T,\tau_L]=0\).

The linear-projection raw-\(K_0\) \(J_3\) remains a useful regression: the
new theorem kills it only after applying the support-local cyclotomic
projector, not by dimension alone.

## EJ/TT and mystery ledger

- **EJ:** intersecting an exceptional divisor with one general base point
  drops its support to a surface. This kills every extension simultaneously,
  not merely each associated grade.
- **TT:** the decisive word is localizing. A projector on formal solutions
  has no access to singular/nonreduced support and cannot justify the proof.
- **Settled:** the complete formal deduction from a localizing,
  point-support-linear, Orlov-compatible cyclotomic projector to \(N^2=0\)
  and the m=2
  contradiction.
- **Open:** construct that projector and its projective/Kunneth and relative
  factorization compatibility.
