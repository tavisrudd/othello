# C973 checkpoint — simultaneous-marker escape theorem

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** primary
transverse theorem proved; Lucas arithmetic and independent review remain open

## Result

Let `r >= 6`, put `m = r-5`, and let `f` be a redundancy-`r` syndrome
over `F_q`.  The stagewise choice of `m` successive markers is unnecessary.
Outside the proved reduced carrier

\[
  \mathcal P_r\cup\mathcal M^{\max}_{r,p},
\]

one terminal-carrier equation pulls back along the degree-`m` composite
contraction to a nonzero polynomial of degree at most six in each ordered
marker.  Multiplication by the Vandermonde gives a split squarefree rational
marker product as soon as `q >= m+6`.  The exact R5 split-member count then
chooses a terminal cubic avoiding all `m` roots at once.

Consequently the arbitrary-redundancy split-free containment is
unconditional for

\[
 q\geq Q_r^*
 :=6r-16+\left\lfloor2\sqrt{6r-18}\right\rfloor.       \tag{1}
\]

This is slightly stronger than retaining the current threshold
`6r-15+floor(2 sqrt(6r-17))`.  In characteristic two, the sharper R5 branch
budget gives the separate bound

\[
 q\geq Q_{r,2}^*
 :=6r-22+\left\lfloor2\sqrt{6r-24}\right\rfloor.       \tag{2}
\]

No intermediate lower package, old-marker divisor, or parameter-by-parameter
escape assertion occurs in the proof.

## 1. Composite contraction and direct lifting

Let `E` be two-dimensional over a field `k`, let
`f in Gamma^(r-1) E`, and let `R in Sym^m(E^vee)`.  Define

\[
 \langle\iota_R f,h\rangle=\langle f,Rh\rangle.
                                                               \tag{3}
\]

This definition is intrinsic, commutes with base change and `GL(E)`, and
includes a factor at infinity without a separate coordinate convention.  It
also agrees with any iterated contraction after factoring `R` over an
extension field, because multiplication in the symmetric algebra is
commutative.

For every cubic `g`, the definition of the Hankel witness system gives

\[
 g\in W_{\iota_R f}
 \quad\Longleftrightarrow\quad
 Rg\in W_f.                                                  \tag{4}
\]

Indeed, for every `lambda in E^vee`,

\[
 \langle\iota_R f,\lambda g\rangle
 =\langle f,R\lambda g\rangle.
\]

Thus all two terminal Hankel equations are exactly the two upper equations
after multiplication by `R`.  This proof also covers a zero or rank-deficient
composite contraction; projectivization is used only after nonvanishing has
been established.

If `R` is completely split and squarefree, then `Rg` is squarefree if and
only if `g` is squarefree and no root of `R` divides `g`.  This is the usual
coprimality criterion after base change to an algebraic closure.  It is the
entire lifting interface; there are no intermediate collision conditions.

## 2. A degree-six terminal selector

Write the coefficient row of `R` as `h`.  C820 proves that

\[
 \kappa_f(R)=\iota_R f=h\operatorname{Cat}_{m,4}(f),          \tag{5}
\]

and that the geometric image closure is the projectivized row space `L_f` of
this catalecticant.  It also proves the following component converse:

\[
 L_f\subseteq\mathcal B_5^{\rm red}
 \quad\Longrightarrow\quad
 f\in\mathcal P_r\cup\mathcal M^{\max}_{r,p}.               \tag{6}
\]

Here the irreducibility of `L_f` places it in one terminal component before
the characteristic-wise consecutive-row calculation is applied.

The reduced R5 terminal carrier is

\[
 \mathcal B_5^{\rm red}=V(D)\cup V(I_{A,p}),                \tag{7}
\]

where `deg D=3`.  Away from characteristics two and three, `I_A` is generated
by the seven cubics of C820.  In characteristic two it is `(c_0,c_4)`.  In
characteristic three it is generated in degrees two and three by the wild
cone equations.

Assume now that `f` is outside the upper carrier.  By the contrapositive of
(6), `L_f` is not contained in (7).  Hence `D|L_f` is nonzero and at least one
listed generator `A|L_f` is nonzero.  Since the coordinate ring of `L_f` is a
domain,

\[
                         F=D A                              \tag{8}
\]

is nonzero on `L_f`.  Its degree `d` is at most six, and is at most four in
characteristic two.  Pulling (8) back through (5) and then through the ordered
root-product map gives

\[
 S_f(\lambda_1,\ldots,\lambda_m)
 =F\!\left(\iota_{\lambda_1\cdots\lambda_m}f\right).        \tag{9}
\]

The product map `(P^1)^m -> P(Sym^m E^vee)` is geometrically surjective, so
`S_f` is nonzero.  Each coefficient of the marker product has degree one in
each root pair.  Therefore (9) is multihomogeneous of degree `d <= 6` in each
marker, not of degree growing with the number of contraction stages.

Any tuple with `S_f != 0` has nonzero terminal syndrome outside both terminal
components.  In particular its R5 pencil has trivial gcd: if every member had
a common geometric root `x`, the evaluation row
`(1,x,x^2,x^3)` would lie in the row space of the two terminal Hankel rows.
After transporting `x` to zero, the three resulting maximal minors are
`c_1c_3-c_2^2`, `c_1c_4-c_2c_3`, and `c_2c_4-c_3^2`; their vanishing forces
the Hankel determinant `D` to vanish.  This contradicts `S_f != 0`.
The pencil is therefore separable and
has geometric monodromy `S_3`.  Positive-gcd, cyclic, characteristic-two
cyclic-plane, and characteristic-three wild cases have therefore been placed
at their exact terminal-carrier boundary rather than hidden in an escape
hypothesis.

## 3. Rational distinct-root selection

### Vandermonde grid lemma

Let `P in F_q[x_1,...,x_m]` be nonzero with `deg_(x_i) P <= d` for every
`i`.  If

\[
                              q>d+m-1,                     \tag{10}
\]

there are pairwise distinct `a_1,...,a_m in F_q` with `P(a_1,...,a_m) != 0`.

To prove this, multiply by

\[
 \Delta=\prod_{i<j}(x_i-x_j).
\]

The product `P Delta` is nonzero and has degree at most `d+m-1<q` in each
variable.  A polynomial reduced to degree below `q` in every variable cannot
vanish on all of `F_q^m`: evaluation identifies these reduced polynomials with
the full algebra of functions on the grid.  Thus `P Delta` is nonzero at one
grid point, where both the desired nonvanishing and pairwise distinctness
hold.

Dehomogenizing every marker in the same affine chart preserves nonvanishing
of a multihomogeneous polynomial.  Applying the lemma to (9) therefore gives
a completely split squarefree marker form `R` with
`kappa_f(R)` outside the terminal carrier whenever

\[
 q\geq m+6=r+1,                                             \tag{11}
\]

or `q >= m+4=r-1` in characteristic two.  This linear selector bound is far
below (1) and (2), so rational marker selection costs nothing in the final
field threshold.

## 4. Terminal cubic avoiding every marker

Put `b=kappa_f(R)`.  Because `b` is outside the R5 carrier, its off-diagonal
fiber square is a geometrically integral curve of arithmetic genus one.  Let
`N_b` be the number of completely split squarefree members of `W_b`.  The
exact R5 identity and branch budget already proved in C881 give

\[
 N_b\geq\frac{q+1-2\sqrt q-B_p}{6},\qquad
 B_p=\begin{cases}6,&p=2,\\12,&p\ne2.\end{cases}            \tag{12}
\]

The pencil is base-point-free.  Hence a prescribed rational root occurs in
exactly one pencil member.  At most `m` of the split squarefree members counted
by `N_b` can contain one of the `m` marker roots.  Therefore a terminal cubic
avoiding all markers exists as soon as

\[
 q+1-2\sqrt q>B_p+6m.                                      \tag{13}
\]

This argument is sharper than adding a separate singular-point deletion:
the exact R5 count is on the possibly singular fiber square itself, and its
branch term already accounts for every nonsquarefree member.  The retained
roots cost exactly at most one pencil member each, or six ordered fiber-square
points each.  Thus the terminal deletion is `12+6m=6r-18` in general and
`6+6m=6r-24` in characteristic two.

For an integer `Delta >= 0`, the least integer bound forced by
`q+1-2 sqrt(q)>Delta` is

\[
 H(\Delta)=1+\lfloor(1+\sqrt\Delta)^2\rfloor
           =\Delta+2+\lfloor2\sqrt\Delta\rfloor.           \tag{14}
\]

Substitution of `Delta=6r-18` and `Delta=6r-24` gives (1) and (2).
Both dominate the selector bounds (11).  The cubic supplied by (13),
multiplied by `R`, is a split squarefree degree-`r-2` member of `W_f` by (4).

We have therefore proved:

### Simultaneous-marker escape theorem

For every `r >= 6`, every prime power `q` satisfying (1), and every
redundancy-`r` syndrome over `F_q`,

\[
 \operatorname{SplitFree}_r(F_q)
 \subseteq
 \mathcal P_r(F_q)\cup\mathcal M^{\max}_{r,p}(F_q).         \tag{15}
\]

In characteristic two, (1) may be replaced by (2).  The proof uses only the
proved C820 reduced-carrier/component theorem and the proved exact R5
split-witness count.  It removes every intermediate lower-package hypothesis.

If `p>r-1`, the Lucas carrier is empty.  Bound (1) implies
`r <= floor(q/2)+2`, so the existing Seroussi--Roth--Dür gate gives covering
radius `r-1`.  The existing rank-two arithmetic then promotes (15) to the
exact tangent/conjugate-secant projective deep-hole classification, with the
same cardinality and orbit law as in the current conditional theorem.

## 5. Quantitative witness abundance

The same proof gives a fixed-`r` quantitative theorem.  In an affine marker
chart, (9) has total degree at most `6m`.  Schwartz--Zippel and deletion of
diagonals give the explicit lower bound

\[
 G_f(q)\geq (q)_m-6m q^{m-1}                              \tag{16}
\]

for good ordered marker tuples, where `(q)_m=q(q-1)...(q-m+1)`; replace the
right side by zero if it is negative.  In characteristic two, `6m` may be
replaced by `4m`.

For every good tuple, the number of terminal split cubics avoiding its roots
is at least

\[
 L_{m,p}(q)=\max\left(0,
 \left\lceil\frac{q+1-2\sqrt q-B_p}{6}\right\rceil-m
 \right).                                                  \tag{17}
\]

A projective split squarefree locator of degree `m+3` occurs in at most
`binom(m+3,m)m!=(m+3)!/6` ordered-marker/cubic decompositions.  Hence

\[
 \#\{\text{split squarefree members of }W_f\}
 \geq
 \frac{6G_f(q)L_{m,p}(q)}{(m+3)!}.                         \tag{18}
\]

In particular, for fixed `r` and `q -> infinity`,

\[
 \#\{\text{split squarefree members of }W_f\}
 \geq \frac{q^{r-4}}{(r-2)!}-O_r(q^{r-9/2}).               \tag{19}
\]

The sign in (19) is understood as the explicit lower bound obtained from
(16)--(18), not an asserted asymptotic equality.  The leading constant is the
natural permutation factor for `r-2` unordered roots.

## 6. Checks, boundaries, and next gate

- Equation (4) is valid before projectivization and handles zero contraction.
  Selector nonvanishing then excludes zero at the chosen marker form.
- The selector is defined over `F_q`; the characteristic-wise generators in
  C820 are defined over the prime field and the catalecticant is defined over
  `F_q`.
- The finite-field lemma uses only affine roots.  It therefore proves the
  required projective statement without a separate infinity case.
- Fixed-gcd terminal systems lie on the `D=0` side of the terminal carrier.
  Ordinary marker incidences are handled by (12)--(13), not promoted to
  contained components.
- No novelty or priority verdict is made at this checkpoint, so no new
  literature-absence claim is licensed.
- No computation, Lean edit, manuscript edit, or software edit was used.

The remaining mathematical crown is now cleanly separated: determine the
split-free points of `M^max_(r,p)` by the adjacent-zero Pascal blocks.  It is
not needed for the unconditional containment (15), and it is the sole missing
ingredient for an all-characteristic exact deep-hole list.

## Paper-successor implications if review accepts the theorem

The eventual paper integration should replace the conditional arbitrary-`r`
escape theorem by (15), replace its threshold by (1) with the binary refinement
(2), and delete the intermediate lower-package hypotheses from the main
logical spine.  The fixed R8--R10 calculations remain valuable as sharper
small-field/Lucas arithmetic and as calibrations, but their stagewise marker
budgets are no longer inputs to the general theorem.  The exact R5 count, the
C820 reduced carrier theorem, and the separate covering-radius gate remain
load-bearing.  A full deletion map and page budget await independent proof
review and belong to C973's final report; manuscript edits remain reserved for
a separately allocated successor.

## Open review gates

1. independently reconstruct the implication (6), especially the
   characteristic-two plane and characteristic-three ruling cases;
2. independently check that `b` outside (7) is exactly the trivial-gcd
   separable `S_3` stratum required by (12);
3. referee the strict inequality and integer thresholds (1)--(2);
4. check the multiplicity divisor in (18); and
5. continue with the maximal-Lucas-carrier discriminator.
