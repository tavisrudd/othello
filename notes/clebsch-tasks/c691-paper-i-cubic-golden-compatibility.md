# C691 — Paper I cubic/golden compatibility kill test

**Lane:** `clebsch`

**Opened:** 2026-07-29

**Status:** complete; positive compatibility theorem.

## Objective

Test whether the support-orientation cubic line reconstructed in C690 and
the continuation operator \(T\) with \(T^2=5\) are canonically compatible
inside the syndrome-locus reconstruction.

## Acceptance

A positive result must give an intrinsic \(A_5\)-equivariant map or identity
that recovers both structures from one orientation torsor.  Agreement only
after choosing C682's golden marking, or the observation that both exchanges
act by sign, is insufficient.

A negative result must identify the exact missing map or representation
obstruction and justify presenting the two structures as adjacent Paper I
v2 propositions.

## Result

The positive gate is closed in
`notes/2026-07-29-c691-cubic-golden-two-graph.md`.  On the common six-axis
carrier, choose one continuation orbital and write its fibre-odd signed
matrix as \(B\).  Then
\[
 c_{ijk}=B_{ij}B_{jk}B_{ki}
\]
is switching-invariant and gives exactly the support-orientation cubic.
Orbital exchange negates both sides.  Conversely the four-point two-graph
identity reconstructs the switching class of \(B\) from the twenty cubic
signs.  Thus the cubic line and the golden operator with \(B^2=5I\) are
mutually recoverable from one orientation torsor.

The stronger determinant identity
\[
 \det(B+\operatorname{diag}x)
 =e_6-e_4+5e_2-125-2C_B
\]
makes the support cubic the sole nonsymmetric term of the golden
operator's diagonal pencil.  Jacobi complementary minors derive support
complementation from \(B^2=5I\).  After homogenization its
golden-conjugation odd part is
\[
 F_B(x,z)-F_B(x,-z)=-4z^3C_B(x).
\]
Moreover
\(\sum_kc_{ijk}=B_{ij}(B^2)_{ij}=0\), so every lower signed moment
vanishes structurally and \(C_B\) descends to the augmentation five-space.
Conversely, the two-graph identities reconstruct \(B\) from the cubic and
pair balance is equivalent to \(B^2=5I\).  In the gauge \(B_{0i}=1\), the
positive edges on the other five vertices must form a pentagon.  Thus there
is one balanced switching class, and the cubic data alone force the golden
operator.

The compatibility is integral.  Modulo \(2\), all cubic signs merge, the
symmetry jumps from \(A_5\) to \(S_6\), and \(B-I\) is rank-one
square-zero, matching the conductor-two degeneration of
\(\mathbf Z[\sqrt5]\).

## Boundaries

- Run this as a kill test before manuscript integration.
- Do not import Mukai--Umemura, the dodecic operator, \(E_8\), or the
  characteristic-zero Paper III reveal.
- Do not change or delay Paper I v1.
- Stop after one exact representation-theoretic comparison and one
  coordinate replay on the frozen common marking.

## Inputs

- `notes/2026-07-29-c690-paper-i-rigidity-upgrades.md`
- `notes/2026-07-29-c690-rigidity-fingerprints.py`
- the current Paper I reconstruction interfaces
