# C909 — hostile audit of the Veronese inevitability mechanism

Date: 2026-08-11

Status: corrections to the structural prediction; no manuscript, PDF,
mirror, Lean, or certificate change

## Bottom line

The quadratic explanation is sound after one terminology repair: `L(a,e)` is
the degree-two piece of a **weighted monomial/Rees lattice**, not in general
the Rees lattice of a filtration of the coefficient module.  The proposed
higher-Veronese extrapolation is not yet a theorem.  Its key failure is
already visible for the flat height function on `3Delta_1` at `p=2`.

The correct separation has three independent layers:

1. a valuation (tropical) defect, present over every residue characteristic;
2. an integral pure-power/polarization-content defect, supported at primes
   dividing `d!` but depending on the chosen `Sym^d` versus `Gamma^d`
   normalization; and
3. a geometric divided-power/product comparison, which requires a separate
   realization by divisors and cannot be read from either lattice defect
   alone.

Only layer 1 is the exact C909 quadratic theorem.  At degree two its
geometric divided-square witness is specially dyadic because the product
polarization has a factor `2`.

## 1. Safe quadratic Rees formulation

For a height function `h` on the lattice points of `2Delta_{n-1}`, set

\[
 \mathcal L_h=\bigoplus_{\alpha\in2\Delta\cap\mathbf Z^n}
       \pi^{h(\alpha)}O\,x^\alpha
       \subset \operatorname{Sym}^2(O^n),
\tag{1}
\]

where the off-diagonal basis is normalized as the symmetric matrix basis
`E_ij+E_ji`.  Taking `h(2e_i)=a_i` and
`h(e_i+e_j)=e_ij` gives `L(a,e)` exactly.  This is a weighted degree-two
Veronese (or monomial Rees) lattice.  An arbitrary matrix `e_ij` need not be
induced from a one-parameter filtration of `O^n`; calling it *the* Rees
lattice of that filtered module is too strong.

Yu's condition `a_i+a_j<=2e_ij` is precisely that every edge midpoint is on
or above the affine chord and hence is absent from the lower hull.  Since
`2Delta` has only vertices and those midpoints, the signed quadratic identity

\[
 (u+v)(u+v)^t-uu^t-vv^t=uv^t+vu^t
\tag{2}
\]

gives the exact integral lift.  The rank-one *additive span* has defect

\[
 \bigoplus_{i<j}\pi^{e_{ij}}O/
 \pi^{\max(e_{ij},\lceil(a_i+a_j)/2\rceil)}O.
\tag{3}
\]

This valuation defect exists at every prime.  What is dyadic is the further
fact that a failed inequality gives a degree-two divided-square defect: the
two cross terms in an ordinary divisor product contribute a factor `2`.
Thus “the first genuine obstruction is dyadic” must be replaced by “the
first **divided-square** witness is dyadic; rank-one failure is not.”

## 2. Smallest higher-Veronese counterexample

The assertion that trivial subdivision of `dDelta` should imply integral
pure-tensor generation is false without additional arithmetic data.  Take
the flat height `h=0` on `3Delta_1`, over `O=Z_2`, and use divided powers of
the free rank-two module `V=Ze+Zf`.  In the divided-power basis

\[
 e^{[3]},\quad e^{[2]}f,\quad ef^{[2]},\quad f^{[3]},
\tag{4}
\]

the middle coordinates of a pure divided cube are

\[
 (ae+bf)^{[3]}:\qquad (a^2b,ab^2).
\tag{5}
\]

They always have the same parity because

\[
 a^2b-ab^2=ab(a-b)\equiv0\pmod2.
\tag{6}
\]

The vectors `(1,1)` and `(4,2)` show that their span is exactly the
same-parity sublattice of `Z^2`.  Hence pure divided cubes have a nonzero
`Z/2` cokernel in `Gamma^3(V)`, although the height is flat and the lower
subdivision is trivial.  This is the smallest example: quadratic divided
powers are straightened by (2), while `d=3,p=2,rank(V)=2` already fails.

It also disproves the claim that support-three lattice points are the first
source of integral trouble: `3Delta_1` is an edge and has no support-three
point.  The defect is an integer-valued-polynomial/evaluation-lattice defect
along that edge.

The analogous statement in ordinary `Sym^d` is different.  There the usual
monomial coordinates of `(ae+bf)^d` carry binomial coefficients.  The maps
between `Sym^d` and `Gamma^d`, and the pure-power spans in the two lattices,
have different contents.  The displayed identity

\[
 (x+y+z)^3-(x+y)^3-(x+z)^3-(y+z)^3+x^3+y^3+z^3=6xyz
\tag{7}
\]

is an ordinary-symmetric-power statement.  In the divided-power lattice its
counterpart isolates `xyz` with coefficient one.  It therefore cannot be
used to describe the integral defect of `Gamma^3` without first changing
lattices.  A correct general comparison is killed after inverting `d!`, but
its exact `p`-content is an evaluation/polarization-lattice problem, not
merely the list of multinomial coefficients.

## 3. Semigroup and effectivity boundaries

“Normality of the rank-one semigroup” is not a consequence of the C909
theorem and does not explain it.  The theorem concerns the `O`-linear span
of rank-one forms and uses signed subtraction in (2).  Over a DVR there is
no intrinsic positive semigroup.  If one instead means the standard toric
Veronese monoid of monomials, that monoid is normal, but its normality proves
projective normality of the monomial algebra—not integral spanning by pure
powers.  Example (4)--(6) has a normal Veronese monoid and nevertheless has
a pure-divided-cube cokernel.

Likewise no effectivity or polarization-cone decomposition follows from the
rank-one span.  Formula (2) is signed, and `p`-adic coefficient lattices have
no positivity notion.  Effectivity would require a global real/Hermitian
positivity condition and a separate claim that the selected rank-one divisor
classes are effective; neither is in the local theorem.

## 4. Precise graph repair: etale versus collision

The safe graph statement is local by depth.  After unramified splitting at a
positive depth, an etale slope block has

\[
 T_i=t_iI+p^{a_i}S_i.
\tag{8}
\]

For two blocks the graph coefficient ideal has exponent

\[
 e_{ij}=\max\{a_i,a_j,
           a_i+a_j-v_p(t_j-t_i)\}.
\tag{9}
\]

Etaleness separates different primitive roots **at the same depth**, making
the difference a unit and forcing exponent `a_i+a_j`.  It does not force
roots at distinct depths to differ by a unit; such a collision merely makes
the third term in (9) smaller, while the two-sided condition still gives
`e_ij>=max(a_i,a_j)`.  A same-depth non-etale collision is different: the
idempotent splitting can fail, so the scalar-slot formula itself is
unavailable.  Thus “etale versus collision” should mean “splitting versus
failure of splitting at a fixed truncated depth,” not simply whether two
chosen lifts are congruent.

## 5. C908 boundary

There is currently no map from a higher-Veronese cellular/evaluation complex
to C908's nilpotent carry or ghost complex.  The counterexample (4)--(6)
already has no nilpotent slope, no Jordan block, and no support-three face.
Consequently C909 does not predict the C908 ghost complex in a theorem-grade
sense.  The only safe wording is: both settings may involve integral
polarization coefficients and `p`-adic carries, suggesting a question about
a future comparison after definitions of both complexes and a chain map are
given.

## Exact repairs to the proposed note

1. Replace “degree-two Rees lattice of a filtered coefficient module” by
   “weighted degree-two monomial/Rees lattice”; retain the height model.
2. Replace “the first genuine obstruction is dyadic” by the distinction in
   §1 between rank-one defects at every `p` and the dyadic divided-square
   witness.
3. Split the ordinary `Sym^d` discussion from the divided-power `Gamma^d`
   discussion.  Delete the inference from (7) to the quotient in `Gamma^d`.
4. Replace the higher-degree cellular/ghost prediction by a stated open
   question.  Record (4)--(6) as its immediate obstruction.
5. Delete all normality/effectivity implications; standard toric normality
   is unrelated to signed rank-one straightening.
6. Replace “finite etaleness diagonalizes the associated graded slope” by
   the depthwise split formula (8)--(9), and distinguish cross-depth root
   coincidence from same-depth non-etale failure of idempotent splitting.
