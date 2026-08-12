# C909 — finite-etale graph gluings have a four-slot ambient Hodge defect

Date: 2026-08-11

Status: theorem-grade local calculation and hostile correction to the proposed
full-integral-Hodge upgrade; no manuscript, PDF, mirror, Lean, or commit change

## Verdict

Full cohomological divided-power saturation of the Neron--Severi lattice does
**not** imply that the ordinary divisor-product image is the full integral
Hodge lattice.  The failure already occurs in codimension two for a one-depth
finite-etale graph with four distinct spectral roots.  It is not a
nilpotent, collision, Chow, or divided-power phenomenon.

Let `R` be a DVR of uniformizer `pi`, let the source primary polarization have
one depth `a>0`, and let a self-adjoint graph slope become, after finite
unramified extension, diagonal with roots

\[
 t_1,\ldots,t_g,\qquad t_i-t_j\in R^\times\quad(i\ne j).
\tag{1}
\]

For the associated non-CM elliptic-power quotient write

\[
 P^2_R=\operatorname{im}\bigl(\operatorname{Sym}^2\operatorname{NS}
       \longrightarrow \operatorname{Hdg}^{4}\bigr).
\]

Then, in this split finite-etale model,

\[
 \boxed{\quad
 \operatorname{Hdg}^{4}/P^2_R
       \simeq (R/(\pi^a))^{\binom g4}.
 \quad}
\tag{2}
\]

Consequently equality with the full integral Hodge lattice is false as soon
as `g>=4`.  The same formula descends through the unramified splitting
extension; hence it applies in particular to the one-depth **irreducible**
finite-etale case.  Irreducibility is not used in the calculation: it merely
permutes the split spectral slots before descent.

Equation (2) is compatible with the C909 finite-etale theorem
`PDDef^*=0`.  That theorem compares ordinary products with the *divided-power
envelope of NS*.  Formula (2) instead compares them with the strictly larger
ambient integral Hodge lattice.

## 1. Split graph and its divisor lattice

Use source covectors `x_i,y_i` and put

\[
 q_{ii}=x_i\wedge y_i,\qquad
 q_{ij}=x_i\wedge y_j+x_j\wedge y_i\quad(i<j).
\tag{3}
\]

For the graph convention whose `i`-th fractional lift is

\[
 u_i=\pi^{-a}(e_i+t_i f_i),\qquad v_i=f_i,
\tag{4}
\]

an integral covector basis is

\[
 X_i=\pi^a x_i,\qquad Y_i=y_i-t_i x_i.
\tag{5}
\]

If the one-depth source block is `pi^a B` rather than `pi^a I`, the
self-adjoint etale splitting makes the root lines `B`-orthogonal and its
restriction to each line is a unit.  Rescaling (4) by that unit gives exactly
the same lattice calculation.  Thus this normalization does not assume an
integral diagonalization of the original unimodular form, including at two.

The graph integrality calculation gives exactly

\[
 D_i:=\pi^a q_{ii},\qquad C_{ij}:=\pi^{2a}q_{ij}
\tag{6}
\]

as the diagonal and off-diagonal divisor slots.  In particular, the diagonal
depth is `a`, and the distinct-root off-diagonal depth is `2a`.

For later use, with `delta_ij=t_j-t_i`, (5) gives the literal expansion

\[
 q_{ij}=\pi^{-2a}\delta_{ij}X_iX_j+
          \pi^{-a}(X_iY_j+X_jY_i).
\tag{7}
\]

Here and below juxtaposition is exterior product.  No diagonalization of a
bilinear form and no division by two is used.

## 2. The four-slot calculation

Fix `i<j<k<l`; write

\[
 r_1=q_{ij}q_{kl},\qquad
 r_2=q_{ik}q_{jl},\qquad
 r_3=q_{il}q_{jk}.
\tag{8}
\]

The exterior signs give the integral Plucker relation

\[
 r_1+r_2+r_3=0.
\tag{9}
\]

Thus the rational Hodge space using all four slots has rank two.  Its product
lattice using all four slots is exactly

\[
 P^2_{ijkl}=R\pi^{4a}r_1+R\pi^{4a}r_2,
\tag{10}
\]

because a product involving all four distinct slots must multiply two cross
divisors from (6).

The leading `X_iX_jX_kX_l` coefficients in (7) are respectively

\[
 \delta_{ij}\delta_{kl},\quad
 -\delta_{ik}\delta_{jl},\quad
 \delta_{il}\delta_{jk}.
\tag{11}
\]

Consequently the weighted Plucker cancellation

\[
 h_{ijkl}:=
 \delta_{ik}\delta_{jl}r_1+
 \delta_{ij}\delta_{kl}r_2
\tag{12}
\]

has no `pi^{-4a}` term.  The coefficient of `X_iX_jX_kY_l` in it is, up to
the fixed exterior sign,

\[
 \pi^{-3a}\delta_{ij}\delta_{ik}\delta_{jk},
\tag{13}
\]

which is a unit times `pi^{-3a}` by (1).  It follows at once that the exact
integral four-slot Hodge lattice is

\[
 \operatorname{Hdg}^{4}_{ijkl}
   =R\pi^{4a}r_1+R\pi^{3a}h_{ijkl}.
\tag{14}
\]

Indeed, the first generator is forced by the uncancelled `XXXX` coefficient;
after that condition has been imposed, (13) forces the second coefficient to
be divisible by `pi^{3a}`.  Conversely (7), (11), and (12) prove that both
displayed generators are integral.  Since the coefficients in (12) are
units, (10) is equivalently

\[
 P^2_{ijkl}=R\pi^{4a}r_1+R\pi^{4a}h_{ijkl}.
\tag{15}
\]

Therefore

\[
 \operatorname{Hdg}^{4}_{ijkl}/P^2_{ijkl}
       \simeq R/(\pi^a).
\tag{16}
\]

This proof works without change at `p=2`: the cancellation is between the
two displayed leading coefficients, not a polarization identity divided by
two.  In characteristic two the printed minus signs become plus signs and
the same equality holds.

## 3. From one four-set to the full codimension-two quotient

The coefficient torus supplies a direct multigrading by the set of spectral
indices occurring in a monomial.  In degree four the possible supports have
size two, three, or four.  The standard two-row straightening calculation on
supports of size at most three is unit triangular with respect to the products

\[
 D_iD_j,\qquad D_iC_{jk},\qquad C_{ij}^2,
\tag{17}
\]

so those support summands are already saturated.  A support of size four has
exactly the calculation in \S2.  Distinct four-subsets lie in distinct
multigraded summands.  Summing (16) proves (2).

Equivalently, the degree-four Hodge lattice is the integral Schur lattice for
the partition `(2,2)`, while the product lattice has one extra `pi^a` of
depth on each four-letter standard-monomial straightening channel.  The
four-slot Plucker relation is the first place where this can happen.

If the original slope algebra is irreducible finite etale, perform the
calculation after an unramified splitting extension `O/R`.  It yields

\[
 (\operatorname{Hdg}^{4}/P^2_R)\otimes_R O
 \simeq (O/(\pi^a))^{\binom g4}.
\tag{18}
\]

Invariant factors and their exponents are unchanged by finite unramified
faithfully flat extension.  Thus (18) descends to (2); root permutation can
change the labelled summands, but cannot change the free `R/(pi^a)` module.

## 4. Scope and strongest safe extension

This is the exact codimension-two classification for a *one-depth* graph with
finite-etale, residually distinct spectral roots.  It does not classify
unequal depths, colliding roots, nilpotent slopes, higher codimensions, or
Chow classes.

The safe general structural statement is that higher-degree ambient defects
are governed by the filtered integral Schur modules

\[
 S_{(2^k)}(M)
\tag{19}
\]

with the graph filtration (7), whereas `P^k` is the image of the symmetric
algebra on the filtered degree-two lattice.  For `k=2`, standard-monomial
straightening has a single new four-letter channel, and (2) is complete.
For `k>2` the four-slot class can be multiplied into larger support sectors,
so (2) supplies a canonical obstruction pattern, but a full Smith form
requires a filtered Schur/standard-monomial theorem.  It would be unsafe to
extrapolate the binomial formula to all codimensions merely from the
four-slot calculation.

## Hostile checks

* **Actual graph convention.**  (4), rather than the opposite triangular
  matrix, is essential.  It reproduces the graph commutator integrality
  condition; using the opposite convention incorrectly makes every `p`-scaled
  symmetric coefficient form integral and hides the defect.
* **Finite etale versus split.**  Only the unit property of every
  `delta_ij` enters \S2.  Therefore unramified splitting and faithful-flat
  descent are legitimate; no trace pairing or trace denominator occurs.
* **Dyadic normalization.**  Equations (12)--(16) make no use of `1/2`.
* **PD versus full Hodge.**  The rank-one/square-zero argument may still show
  `PDDef^*=0`; it cannot eliminate the ambient class
  `pi^{3a}h_{ijkl}`.  Calling (2) a divided-power defect would be false.
* **Non-CM qualification.**  It identifies the rational Hodge tensors with
  the diagonal `SL_2` invariants and the degree-two ones with NS.  Extra CM
  tensors lie outside this statement.

## Mystery ledger

* **Settled:** the proposed full integral-Hodge equality is false even in the
  clean one-depth finite-etale regime; the first exact failure is the
  four-slot Plucker channel.
* **Settled:** codimension two has the exact local quotient (2), including
  prime powers and the dyadic case.
* **Settled:** this neither weakens nor strengthens C909's full
  divided-power-saturation theorem; the two quotients have different ambient
  lattices.
* **Open successor:** determine the Smith form of the filtered Schur module
  (19) in higher codimension.  This is a finite-etale Hodge-lattice problem,
  distinct from the C908 non-etale/carry programme.

## EJ/TT closeout

The cheap upgrade was not another example but the exact separation of two
integral lattices on the same tower: finite etaleness forces
`PDDef^*=0`, yet the ambient Hodge/product quotient is already
`(R/pi^a)^(binom(g,4))`.  TT's higher-degree question led to the candidate
Dyck-height Smith filtration and exposed the precise missing theorem: nested
unit minors for the multiaffine web-jet matrix.  Exhaustive distinct-root
tests in ranks six and eight, including characteristic two, found no extra
discriminant beyond etaleness.  The first-return and ordinary confluent-
Vandermonde shortcuts were both audited and do not presently prove those
minors.  Thus no genuine mystery remains in codimension two; the only live
higher-degree mystery is the filtered-web saturation theorem, owned by the
strict-C909 successor recorded in the task card.
