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

The numerical specialization explains all five fixed-level thresholds at
once:

\[
\begin{array}{c|ccccc}
r&6&7&8&9&10\\ \hline
Q_r^*&28&35&42&50&56\\
\text{next prime power}&29&37&43&53&59.
\end{array}
\]

These are exactly the current R6--R10 asymptotic entry fields.  Thus the
simultaneous theorem absorbs the separate stage-budget numerics rather than
trading their sharp fixed-level bounds for a weaker uniform constant.

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

### Pointed simultaneous-marker variant

The argument remains valid with a prescribed set `A` of `s` rational roots
which the final locator must avoid.  Choose the affine marker chart so that
any point of `A` at infinity is already avoided, and multiply `S_f Delta` by

\[
                     \prod_{i=1}^m\prod_{a\in A_{\rm aff}}(x_i-a).
\]

The degree in each marker is at most `d+m-1+s`, so a split squarefree marker
form disjoint from `A` exists when

\[
                             q>d+m-1+s.                    \tag{16}
\]

At the terminal pencil, at most `m+s` split members meet a retained or new
forbidden root.  Hence the pointed lift exists when

\[
 q+1-2\sqrt q>B_p+6(m+s).                                 \tag{17}
\]

This is a single global selection followed by one terminal count.  It is not
the former sequence of intermediate lower packages.  In particular `s=1`
is the exact interface for contracting a Lucas-carrier point once, applying
the simultaneous theorem below, and lifting a lower witness while avoiding
the contraction root.

## 5. Quantitative witness abundance

The same proof gives a fixed-`r` quantitative theorem.  In an affine marker
chart, (9) has total degree at most `6m`.  Schwartz--Zippel and deletion of
diagonals give the explicit lower bound

\[
 G_f(q)\geq (q)_m-6m q^{m-1}                              \tag{18}
\]

for good ordered marker tuples, where `(q)_m=q(q-1)...(q-m+1)`; replace the
right side by zero if it is negative.  In characteristic two, `6m` may be
replaced by `4m`.

For every good tuple, the number of terminal split cubics avoiding its roots
is at least

\[
 L_{m,p}(q)=\max\left(0,
 \left\lceil\frac{q+1-2\sqrt q-B_p}{6}\right\rceil-m
 \right).                                                  \tag{19}
\]

A projective split squarefree locator of degree `m+3` occurs in at most
`binom(m+3,m)m!=(m+3)!/6` ordered-marker/cubic decompositions.  Hence

\[
 \#\{\text{split squarefree members of }W_f\}
 \geq
 \frac{6G_f(q)L_{m,p}(q)}{(m+3)!}.                         \tag{20}
\]

In particular, for fixed `r` and `q -> infinity`,

\[
 \#\{\text{split squarefree members of }W_f\}
 \geq \frac{q^{r-4}}{(r-2)!}-O_r(q^{r-9/2}).               \tag{21}
\]

The sign in (21) is understood as the explicit lower bound obtained from
(18)--(20), not an asserted asymptotic equality.  The leading constant is the
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

**Superseded 2026-08-28.**  The strengthened containment (15') below removes
the carrier term from (15) for every odd `p` and for `p = 2` with `r >= 8`.
The crown survives only in the reduced form stated there: the carrier analysis
is still needed for the sub-threshold fields `q < Q_r^*` (resp. `Q_(r,2)^*`)
and for the two characteristic-two carriers at `r in {6,7}`.

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

Gates 1 and 5 are answered by the strengthened containment below: gate 1's
characteristic-two and characteristic-three cases were reconstructed
independently, and gate 5 is confined to `r in {6,7}` and to sub-threshold
fields.

## Strengthened containment (2026-08-28)

The carrier term in (15) is an over-approximation of the set on which the
escape mechanism actually fails.  Proposition 2.1 of
`c973-2026-08-26-two-seam-reconstruction.md` proves more than its own
statement (6) records, and once its persistent branch is repaired by the
level-uniform polar lemma, the exceptional set can be read off branch by
branch.

### The escape argument uses one hypothesis, on `f`, once

§2 above, immediately after the reduced carrier (7):

> Assume now that `f` is outside the upper carrier.  By the contrapositive of
> (6), `L_f` is not contained in (7).  Hence `D|L_f` is nonzero and at least
> one listed generator `A|L_f` is nonzero.  Since the coordinate ring of `L_f`
> is a domain, `F = D A` (8) is nonzero on `L_f`.

That is the only place a hypothesis on `f` enters §§1--4.  It is applied to
`f` itself, through the contrapositive of (6), and it constrains `L_f`, the
projectivised row space of the *composite* catalecticant `Cat_(m,4)(f)`.  No
hypothesis is ever imposed on a marker-contracted descendant of `f`: §1's
adjunction (3) "agrees with any iterated contraction after factoring `R` over
an extension field", so the stagewise picture is a consequence of the
composite object rather than an input.  The genus-one count (12) and the
threshold inequality (13) are applied to `b = kappa_f(R) in Gamma^4 E`, whose
required position outside the R5 carrier is *supplied* by the selector `S_f`
of (9) rather than assumed afresh.

Consequently `M^max_(r,p)` enters the theorem at exactly one point: as the
right-hand side of (6).  Any sharpening of (6) propagates verbatim to (15) and
(17) with no other change to §§1--4, and none of the threshold arithmetic
(1), (2), (11), (13), (14), (16), (17) moves.

### The four branches of Proposition 2.1

With `m = r-5`, the proof of Proposition 2.1 splits `L_f subset B_5^red` by
irreducibility of `L_f` into one of two components, and each branch returns a
conclusion sharper than the union (6):

1. **Persistent branch** (`L_f subset V(D)`): `f in P_r`, no carrier term.
   The level induction `(*_d)`, `4 <= d <= m+4`, lifts the terminal
   containment one level at a time using C536's integral ideal identity
   `J_n = I_n` for every `n >= 5` (C536 §2 (5)--(7); reproved in
   `c973-2026-08-28-level-uniform-polar-lemma.md` §5).  The hypothesis is
   taken coefficientwise, so a zero or rank-one polar family needs no case
   split, and it is read over the algebraic closure fixed in the two-seam
   note's §1 -- the "for every `F_q`-rational `lambda`" form of the lemma is
   false over `F_2`.
2. **Residual branch, `p` not two or three**: the projected Veronese contains
   no projective line, so `L_f` is a point, `rank T_f = 1`, and `f in P_r`.
3. **Residual branch, `p = 3`**: every positive-dimensional linear subspace of
   the wild cone is a ruling through the vertex, and C597's consecutive-row
   calculation gives rank-one upper syndrome, so `f in P_r`.
4. **Residual branch, `p = 2`**: containment in `V(c_0,c_4)` forces the first
   and last columns of `Cat_(m,4)(f)` to vanish, i.e.
   `a_0 = ... = a_m = 0` and `a_4 = ... = a_(m+4) = 0`.  For `m = 1` this
   leaves `f in P<e_2,e_3> = M^max_(6,2)`; for `m = 2` it leaves
   `f = [e_3] in M^max_(7,2)`; for `m >= 3` the two index intervals cover
   every coefficient, forcing `f = 0`, which is impossible projectively.

The two surviving carriers are the *whole* maximal Lucas carriers at those
levels, by the adjacent-zero Pascal criterion: row 4 of Pascal's triangle mod
two is `1,0,0,0,1`, with adjacent zero pairs at `j = 2,3`, giving
`M^max_(6,2) = P<e_2,e_3>`; row 5 is `1,1,0,0,1,1`, with the single adjacent
zero pair at `j = 3`, giving `M^max_(7,2) = [e_3]`.  So the union of the four
branch outputs is

\[
 \mathcal E_r:=\mathcal P_r\cup\mathcal M^{\max}_{6,2}
                    \cup\mathcal M^{\max}_{7,2},
\]

that is, `E_r = P_r` for every odd `p` and for `p = 2` with `r >= 8`, and
`E_r = P_r ∪ M^max_(r,2)` for `p = 2` with `r in {6,7}`.

### Theorem (15') — strengthened simultaneous-marker containment

> For every `r >= 6` and every prime power `q` satisfying (1) -- or (2) in
> characteristic two --
>
> \[
>  \operatorname{SplitFree}_r(\mathbf F_q)\subseteq\mathcal E_r(\mathbf F_q),
>  \qquad
>  \mathcal E_r=\begin{cases}
>   \mathcal P_r, & p\ \text{odd, or } p=2,\ r\ge8,\\[2pt]
>   \mathcal P_r\cup\mathcal M^{\max}_{r,2}, & p=2,\ r\in\{6,7\}.
>  \end{cases}
>  \tag{15'}
> \]

*Proof.*  Let `f` be a redundancy-`r` syndrome outside `E_r`.  By the
branchwise form of Proposition 2.1 just recorded, `L_f` is not contained in
`B_5^red`.  This is precisely the hypothesis the escape argument of §§2--4
uses, and it is used only once; the argument then proceeds verbatim --
selector (8)--(9), Vandermonde grid lemma under (11), terminal cubic under
(13) -- and produces a completely split squarefree degree-`r-2` member of
`W_f`.  Hence `f` is not split-free.  `∎`

### Pointed variant (17')

> Let `A subset P^1(F_q)` be a prescribed set of `s` rational points.  Assume
> `q + 1 > s`, so that some rational point lies outside `A` and the affine
> marker chart of the pointed variant can be chosen; assume (16); and assume
>
> \[
>  q+1-2\sqrt q>B_p+6(m+s).                              \tag{17'}
> \]
>
> Then every redundancy-`r` syndrome outside `E_r` admits a completely split
> squarefree degree-`r-2` member of `W_f` all of whose roots avoid `A`.

The hypothesis `q + 1 > s` was left implicit in the original pointed variant
("choose the affine marker chart so that any point of `A` at infinity is
already avoided"); it is implied by (16) in every use below, but it is a
hypothesis and is stated here as one.

### Consequences, with the arithmetic

Thresholds, from (14) with `Delta = B_p + 6m`:

    Q_11^*    = 6*11 - 16 + floor(2 sqrt(6*11-18)) = 50 + floor(2 sqrt 48)
              = 50 + 13 = 63,
    Q_{11,2}^* = 6*11 - 22 + floor(2 sqrt(6*11-24)) = 44 + floor(2 sqrt 42)
              = 44 + 12 = 56.

1. **Binary R11 closes at `q >= 56`, not `q >= 128`.**  At `r = 11`, `p = 2`,
   `m = 6`, the carrier `M^max_(11,2) = P<e_3,...,e_7>` is no longer part of
   the exceptional set, since `m = 6 >= 3`.  So (15') gives
   `SplitFree_11(F_q) ⊆ P_11(F_q)` for every binary `q >= Q_(11,2)^* = 56`.
   `c973-2026-08-26-first-lucas-boundary.md` (7) closes the same block only
   for `q >= 128`.
2. **GF(64)/R11 is closed by this theorem alone.**  Plain form: `64 >= 56`,
   and directly `q+1-2 sqrt q = 65-16 = 49 > 42 = B_2 + 6m = 6 + 6*6`.
   Pointed form, `s = 1`: `q+1 = 65 > 1`, and
   `49 > 48 = B_2 + 6(m+s) = 6 + 6*7`.  Both forms clear, the pointed one by a
   margin of one.  The trace-balance / étale-cyclic-cubic / 3-isogeny
   programme of `c973-2026-08-27-gf64-trace-balance.md` therefore re-proves a
   special case.  Its own `49`-versus-`48` margin is *not* the same inequality:
   `49` is the Hasse floor `q+1-2 sqrt q` shared by any genus-one curve over
   GF(64), while its `48` is an affine point count on the trace-one
   Artin--Schreier twist, converted by `48/2 = 24` rootless parameters against
   the C620 selector budget `23 = 22+1`, and its final closure runs on
   `#C_1 >= 52` with at most four points lost, not on `49` against `48`.
3. **GF(49) is below threshold.**  `49 < Q_11^* = 63`, and
   `M^max_(11,7) = P<e_4,e_5,e_6>` is nonempty, so (15') says nothing there.
   Characteristic-seven R11 remains closed only by the separate certificate of
   `c973-2026-08-26-first-lucas-boundary.md` (11), which claims `q >= 343`;
   `GF(49)` is open under both statements.
4. **GF(16) and GF(32) remain certificate-closed.**  `16 < 56` and `32 < 56`,
   so (15') does not reach them; they stay with the explicit orbit
   certificates (C620's 292 and 1090 Borel orbits at redundancy ten, and the
   corresponding R11 work).
5. **GF(27) remains certificate-closed.**  `27 < Q_11^* = 63`.  The pointed
   form is no help: it needs `q+1-2 sqrt q > B_3 + 6(m+s) = 12 + 42 = 54`,
   and `28 - 2 sqrt 27 ≈ 17.6`.  The GF(27) nucleus-saturation problem is
   therefore the genuine frontier; GF(64) is not.

Characteristic three and seven gain nothing at R11 beyond the bookkeeping:
`Q_11^* = 63` sits below the next prime powers `81` and `343` that the
existing certificates already cover.

### Evidence boundary

The proof of (15') is the algebraic one above: the single-hypothesis structure
of §§2--4, plus the branchwise reading of Proposition 2.1 with its persistent
branch repaired.  Nothing in it is computational.

Separately, and as corroboration only, the three nonempty R11 maximal Lucas
carriers were scanned for a point that would obstruct escape, by building
`Cat_(6,4)(f)` for `f in Gamma^10 E`, computing its row space, and testing
`L_f` for containment in `V(D)` (by symbolic expansion of `D` on a row-space
basis, so the test is exact and not a rational-point sample) and, in
characteristic two, in `V(c_0,c_4)`.  Coverage: `P<e_3,...,e_7>` exhaustively
over `GF(2)` and `GF(4)` and sampled over `GF(8)`; `P<e_2,...,e_8>`
exhaustively over `GF(3)` and sampled over `GF(9)`; `P<e_4,e_5,e_6>`
exhaustively over `GF(7)`.  No point in any of these had `L_f ⊆ B_5^red`; the
minimum catalecticant rank observed was `3` (eight points, characteristic
three) and `4` (characteristic two), against the `5` needed for `L_f = P^4`.
The scan is recorded in
`c973-2026-08-28-finding1-verification.md` §2 and is not load-bearing; per
`notes/research-reproducibility-conventions.md` it would need a committed
script, certificate, and hash manifest before any paper-facing sentence rests
on it, and no such sentence does.

A referee-facing shortcut that removes the need for the scan entirely:
`V(D)` is an irreducible cubic hypersurface in `P^4` (the chordal variety of
the rational normal quartic) and `V(c_0,c_4)` is a plane, so neither contains
a linear subspace of dimension three or more.  Hence
`rank Cat_(m,4)(f) >= 4` already forces `L_f ⊄ B_5^red` in characteristic two,
and likewise in odd characteristic once the residual component is known to
contain no `3`-plane.

### Two remaining layers of slack

`B_5^red` over-approximates the R5 split-free locus in its own right:
`D(c) = 0` says exactly that the apolar ideal of the quartic `c` contains a
quadric `q`, whence `W_c = q·<X,Y>`, and such a pencil still contains split
squarefree members whenever `q` itself splits (`q = XY` gives members `XY·l`)
-- so `V(D)` is where the *counting argument* fails, not where split witnesses
fail to exist, and (15') therefore carries independent slack at the terminal
level as well as at the top level.  A paper version should say this in one
sentence, because a referee who notices it will ask whether the sharp
statement was attempted.
