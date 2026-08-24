# C925: invariant rank-three boundary-peeling frontier

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Outcome

The certified stabilization interval for either explicit Tschinkel--Zhang
cubic threefold remains

\[
\boxed{2\le s(X)\le4}. \tag{1}
\]

No (m=2) rationality or irrationality claim is made here.  This pass
exhausts the direct rank-three analogue of the boundary-forced tangent slice
that proved level four:

\[
\boxed{\text{no type-}I_1\text{ invariant rank-three subtorus admits a
descended first tangent-hyperplane boundary-divisor peel}.} \tag{2}
\]

Thus a level-two result cannot come from iterating the existing OADP proof
one dimension higher with a complete Galois orbit of toric boundary
divisors.  The remaining rationality route is an intrinsic invariant-field
parametrization or a slice with a non-toric base scheme.

## Exhaustion of rank-three subtori

Over (mathbf Q), the type-(I_1) cocharacter representation is the
multiplicity-free sum of three distinct sign lines and one irreducible
two-plane (W).  Maschke's theorem therefore leaves exactly four invariant
three-planes:

\[
L_1\oplus L_2\oplus L_3,qquad L_i\oplus W\quad(1\le i\le3). \tag{3}
\]

Exact pairing with the sixteen Cox-coordinate classes gives the following
three-dimensional weight polytopes and facet-orbit data.  “Covered weights”
is the number of weight blocks in the union of the indicated Galois orbit of
facets.

| invariant three-plane | orbit degree | facet orbit sizes | covered weights |
| --- | ---: | --- | --- |
| three sign lines | 14 | (2,2,4) | (8,8,8) of 8 |
| (L_1\oplus W) | 18 | (2,3,3) | (14,12,12) of 14 |
| (L_2\oplus W) | 18 | (2,3,3) | (14,12,12) of 14 |
| (L_3\oplus W) | 18 | (6) | (8) of 8 |

The degrees are exact normalized lattice volumes, independently recovered
as six times the leading coefficients of the Ehrhart polynomials.  In the
first and fourth rows every complete facet orbit spans every Cox weight
block, so no projective hyperplane can contain it.

The two middle rows have precisely two nonspanning facet orbits apiece.
Each leaves the same two central weights and hence only the four Cox
coordinates

\[
E_3,quad E_4,quad L_{34},quad Q. \tag{4}
\]

A hyperplane containing such a facet orbit must be supported on (4).

## Exact tangent obstruction

Let (J) be the (20\times16) Cox Jacobian at the standard dense family of
universal-torsor points used in the level-three certificate.  After deleting
the four columns (4), the eight rows

\[
0,1,2,3,4,5,7,11
\]

and columns

\[
E_1,E_2,E_5,L_{12},L_{13},L_{14},L_{15},L_{23}
\]

have determinant

\[
\begin{aligned}
&-(a-1)(bz_1-z_3)
 (az_1-az_3-bz_1+bz_2-z_2+z_3)\\
&\qquad\cdot
 (abz_1z_2-abz_1z_3+az_1z_3-az_2z_3-bz_1z_2+bz_2z_3),
\end{aligned} \tag{5}
\]

which is not identically zero.  Hence the restricted Jacobian has generic
row rank eight.  Its rowspace contains no nonzero covector supported on
(4), so no tangent hyperplane can contain either of the surviving complete
facet orbits.  This closes the last two rows and proves (2).

The scope is deliberately narrow.  Equation (2) does not show that the
rank-three quotient is nonrational.  A rational quotient could still arise
from a direct computation of (K(Z)^{L}), a non-toric rational section, or
a boundary base scheme that is not a union of complete toric divisors.

## Exact certificate

- `notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.py`,
  SHA-256
  `ef13729e30b34d639a156d7a0ef313caba7b097583d1cc0d9d09b4d3517a0a75`;
- `notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json`,
  SHA-256
  `0baea0ebf4060466519b773fe9dea7bf889c5ebe1d4db597b2ea77729280b751`.

Replay from `/home/tavis/src/othello`:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json

The checker reconstructs the rational representation decomposition, proves
irreducibility of (W) against all four sign characters, enumerates the four
rank-three spaces, computes all Cox weights, enumerates supporting facets
over the integers, closes their affine Galois orbits, computes exact Ehrhart
degrees, and verifies (5).

## Sources and scope

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1. **Read depth:
  partial** — Theorem 2.4, Sections 3--4, and Proposition 5.1.  PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Invariant rank-three subtori | Exactly the four spaces (3). |
| settled | Toric orbit combinatorics | Degrees (14,18,18,18) and complete facet-orbit enumeration. |
| settled | Direct first boundary peel | Impossible by full-span or the tangent minor (5). |
| open | (m=3) rationality | Intrinsic quotient for one of the rational-residual rank-two slices. |
| open | (m=2) rationality | Intrinsic rank-three invariant field or non-toric slice. |
| open | (m=2) irrationality | Requires a factorization-specific marker beyond universal INT-(Psi). |

**Resume line:** go C925 cubic-threefolds — (2\le s(X)\le4); all ambient
rank-two slices and direct rank-three boundary peels are exhausted, so compute
the intrinsic invariant field of the sign-square quotient or a non-toric
rank-three section.
