# C973 checkpoint — exact GF(64) trace balance

**Lane:** `reed-solomon` · **Date:** 2026-08-27 · **Status:** coefficient-space
abundance proved; conditional slope chart and its first exact obstruction identified

## 1. Balance theorem

Retain the pointed GF(64) final-pair notation.  Fix `B1,B2,B3` and vary
`u=B0`.  Put

\[
 D=B_2^2+B_1B_3,
\]

and assume `B3 D != 0`.  Then exactly 32 values of `u in GF(64)` make the
quadratic

\[
 N_u(x)=n_2x^2+n_1x+n_0
\]

rootless, where

\[
 n_0=B_1^2+uB_2,\qquad
 n_1=B_1B_2+uB_3,\qquad
 n_2=D.                                                     \tag{1}
\]

More generally, over every field `GF(2^m)`, exactly `q/2` values work.

This proves exact half-density in the coefficient direction needed by the
GF(64) trace gate.  It is not a heuristic character-sum estimate and uses no
certificate.

## 2. Proof

Set

\[
                         v=n_1=B_1B_2+uB_3.
\]

Because `B3 != 0`, varying `u` makes `v` run bijectively through the field.
For `v != 0`, solve

\[
 u=(v+B_1B_2)/B_3.
\]

Substitution in (1) gives

\[
 n_0=\frac{B_2}{B_3}v+\frac{B_1D}{B_3}.
\]

The rootlessness trace is therefore

\[
 T(v)=\frac{Dn_0}{v^2}
 =\frac{DB_2/B_3}{v}+\frac{B_1D^2/B_3}{v^2}.              \tag{2}
\]

Let `s` be the unique square root of `B1/B3`.  Since absolute trace is
invariant under squaring,

\[
 \operatorname {Tr}T(v)
 =\operatorname {Tr}\left(
   \frac{D(B_2/B_3+s)}{v}\right).                          \tag{3}
\]

The numerator in (3) is nonzero.  Indeed, if
`B2/B3+s=0`, squaring gives `B2^2=B1B3`, contrary to `D!=0`.
Thus, as `v` ranges over the nonzero field elements, the argument of the trace
ranges over all nonzero field elements.  Exactly `q/2` field elements have
absolute trace one, and none of them is zero.  Hence exactly `q/2` admissible
values have `Tr(T)=1`.  By the quadratic criterion in the preceding checkpoint,
those and only those values make `N_u` rootless.

## 3. Structural consequence

The GF(64) problem no longer asks whether the desired trace value is rare.
On every chart with `B3D != 0`, it occupies exactly half of a full affine
coefficient line.  The remaining proof obligation is geometric:

> realize enough of this `B0`-line by completely split squarefree quintics,
> while retaining the C620 nondegeneracy selector.

There is an exact realization criterion.  Let

\[
 P(t)=p_0+p_1t+p_2t^2+p_3t^3+t^4
\]

be a split squarefree quartic with four nonzero roots, and put
`h_a(t)=(t+a)P(t)`.  Define

\[
 U_j=\sum_{i=3}^7z_i p_{i+j-4},\qquad 0\le j\le4,          \tag{4}
\]

with coefficients outside `0,...,4` zero.  Direct convolution gives

\[
                         B_j(a)=B_j(0)+aU_j.               \tag{5}
\]

Hence, if

\[
                 U_1=U_2=U_3=0,\qquad U_0\ne0,            \tag{6}
\]

the parameter `a` fixes `B1,B2,B3` and runs `B0` bijectively through the
field.  The balance theorem supplies exactly 32 rootless values.

The complete C620 selector restricted to `h_a` has degree at most 22 in `a`;
this already includes collision of `a` with the four roots of `P`.  Requiring
`a!=0` costs one further value.  Therefore

\[
                             32>22+1.                      \tag{7}
\]

If the restricted selector is nonzero, some rootless `a` gives five distinct
nonzero fixed roots and the nondegenerate genus-one slice.  The preceding
49-versus-48 theorem then supplies the pointed locator.

Conditions (6) are three homogeneous linear equations on the
five-dimensional binary-quartic space.  Their kernel has vector dimension at
least two: it is a projective quartic pencil (or a larger system), not an
isolated support search.  On the strata where it contains a suitable quartic,
it gives a complete pointed proof:

> prove that this slope pencil contains a split squarefree quartic avoiding
> zero with `U0!=0`, and that the C620 selector is nonzero on its added-root
> line.

The slope chart is not universal.  For the dense syndrome

\[
                         z=(1,1,1,1,1),                    \tag{8}
\]

the three equations `U1=U2=U3=0` are

\[
\begin{aligned}
p_0+p_1+p_2+p_3+p_4&=0,\\
p_1+p_2+p_3+p_4&=0,\\
p_2+p_3+p_4&=0.
\end{aligned}
\]

They force `p0=p1=0`.  Every quartic in the slope pencil therefore contains
the forbidden root zero, so no quartic allowed by (6) can serve in this
stratum.  This is an exact structural obstruction, not a failed search.

Consequently (6) is a useful chart and a sharp diagnostic, but not the final
GF(64) theorem.  The universal proof must allow `B1,B2,B3` to move with the
added root and analyze the resulting one-variable Artin--Schreier trace
function, or introduce a second split parameter direction.  It should retain
the exact balance identity locally rather than revert to a carrier census.

The dense obstruction (8) has an explicit replacement chart.  Choose a
two-dimensional `F2`-subspace `U` whose subspace polynomial is

\[
                       L_U(t)=t^4+t^2+\beta t,qquad\beta\ne0.              \tag{9}
\]

Such a space exists.  Start from `span_F2{1,t}` with `t` outside `F4`; its
quadratic coefficient `1+t+t^2` is nonzero, and scaling by its unique inverse
square root normalizes that coefficient to one.  The linear coefficient
remains nonzero.  Since `L_U(1)=beta`, the affine coset `1+U` is disjoint from
zero and has polynomial

\[
                       t^4+t^2+\beta t+\beta.              \tag{10}
\]

Take these four roots and add the fifth root `a`.  For the dense syndrome,
direct substitution gives

\[
                 (B_0,B_1,B_2,B_3)=(a+1,1,\beta a,\beta). \tag{11}
\]

Thus

\[
\begin{aligned}
n_0&=\beta a^2+\beta a+1,\\
n_1&=\beta,\\
n_2&=\beta^2a^2+\beta,
\end{aligned}
\]

and the rootlessness trace reduces to

\[
 \operatorname {Tr}\left(
   \beta a^3+(\beta^{16}+1)a+\beta^{-1}
 \right).                                                  \tag{12}
\]

Here trace invariance under fourth powers replaces the term `beta a^4` by
`beta^16 a`.  The cubic in (12) has nonzero leading coefficient, so its
Artin--Schreier curve is geometrically integral of genus one.  The Weil bound
therefore gives at least

\[
                         (64-16)/2=24                     \tag{13}
\]

values of `a` with trace one.  The restricted C620 selector has degree at most
22 in `a`, including collision with the four coset roots, and `a=0` costs one
more value.  Hence `24>23` closes the dense chart provided the restricted
selector is not identically zero.

In fact one normalized chart closes directly.  Take `beta=1`; the linearized
polynomial `t^4+t^2+t` splits over `GF(8) subset GF(64)`, and its affine coset
has polynomial

\[
                         H(t)=t^4+t^2+t+1.                 \tag{14}
\]

Now (12) is simply `Tr(a^3)=1`, because `Tr(1)=0` in the even extension
`GF(64)/GF(2)`.  At least 24 values satisfy it.  Exclude `a=0`, the four roots
of `H`, and the at most four roots of

\[
                         a^4+a^3+1.                        \tag{15}
\]

At least 15 admissible values remain.

For any such value, the moving-root final-pair data simplify to

\[
\begin{aligned}
Q(x)&=1+ax,\\
\Delta(x)&=(a+1)^2(1+x)^2,\\
N(x)&=(a^2+1)x^2+x+(a^2+a+1).                             \tag{16}
\end{aligned}
\]

The denominator is linear and nonconstant.  At its root, the reduced
simple-pole test is

\[
 R=((N\Delta)')^2+(Q')^2N\Delta
   =\frac{(a+1)^6(a^4+a^3+1)}{a^4}\ne0.                  \tag{17}
\]

Thus the normalized Artin--Schreier curve is geometrically integral of genus
zero and has exactly 65 rational points.  Every deletion divisor is proper.
For a fixed coset root `r`, the identity
`r^2 Delta+rQ+N=0` would force `r=1/a` and then `a^4=1`, hence `a=1`, already
excluded by `H(a)=0`.  The moving-root collision polynomial is

\[
                 (a+1)^2x^4+ax^2+(a^2+a+1),              \tag{18}
\]

which is never identically zero on the selected domain.  The sharp deletion
bound is

\[
 10+1+2+20+8+2+2=45<65,                                  \tag{19}
\]

for moving/fixed collisions, the ramified `Q`-root, `Delta=0`, final/fixed
collisions, final/moving collision, infinity, and moving root zero.  Since
`N` is rootless, the final pair never contains zero.

This proves pointed shallowness for the dense syndrome (8) over GF(64).  It
replaces the failed rigid slope pencil by a moving-coefficient cubic trace and
a linear-denominator genus-zero slice, without any certificate or residual
selector hypothesis.

The complete forced-root locus of the slope pencil is also explicit.  The
three rows in (6), on quartic coordinates `(p0,...,p4)`, are

\[
\begin{pmatrix}
z_3&z_4&z_5&z_6&z_7\\
0&z_3&z_4&z_5&z_6\\
0&0&z_3&z_4&z_5
\end{pmatrix}.                                             \tag{20}
\]

Its kernel is contained in `p0=0` exactly when the first coordinate
functional lies in the row span.  If `z3=0`, this is impossible.  If
`z3!=0`, scale `z3=1` and solve the row-combination equations from left to
right.  The last two equations give precisely

\[
 z_6=z_4^3,qquad
 z_7=z_4^4+z_5^2+z_4^2z_5.                                \tag{21}
\]

Thus every rigid slope obstruction lies on the explicit two-parameter
surface

\[
 (z_3,z_4,z_5,z_6,z_7)
 =(1,u,v,u^3,u^4+v^2+u^2v).                               \tag{22}
\]

This surface has a second, stronger compression.  Solving (20) on (22), with
`lambda=p3` and `mu=p4`, gives

\[
 P(t)=tq_{u,v}(t)\bigl(\lambda+\mu(t+u)\bigr),\qquad
 q_{u,v}(t)=t^2+ut+(u^2+v).                               \tag{23}
\]

Thus the forced root zero is accompanied by a fixed quadratic factor.  The
whole normalized surface of 4096 points has the exact disjoint
stratification

| condition | quadratic type | number of `(u,v)` |
|---|---|---:|
| `u!=0`, `v!=u^2`, `Tr(v/u^2)=0` | two distinct nonzero rational roots | 1953 |
| `u!=0`, `Tr(v/u^2)=1` | irreducible | 2016 |
| `u!=0`, `v=u^2` | roots zero and `u` | 63 |
| `u=0` | one double root | 64 |

Here `Tr(1)=0` because `[GF(64):GF(2)]=6`, so the usual quadratic splitting
test for `q_{u,v}` is exactly `Tr(v/u^2)=0`.  This partition is structural;
it replaces an undifferentiated 4096-point exceptional surface by one
quadratic trace bit and two boundary lines.

The residual torus preserving the marked pair zero and infinity compresses
it further.  After projectively normalizing `z3=1`, the change `t -> ct`
acts by

\[
                         (u,v)\longmapsto(cu,c^2v).        \tag{24}
\]

Consequently every point with `u!=0` is equivalent to the unique normal form
`(u,v)=(1,tau)`, where `tau=v/u^2`; the `u=0`, `v!=0` line is one further
orbit because squaring is bijective, and `(0,0)` is the last orbit.  Thus the
surface has only 66 marked-torus orbits: 64 one-parameter normal forms and
two boundary forms.  More importantly, the whole 63-point curve `v=u^2` has
`tau=1` and is equivalent to the dense point already closed by (14)--(19).
Only the 63 values `tau!=1` and the two `u=0` boundary forms remain on (22).

The endpoint boundary also supplies an exact chart obstruction.  At
`(u,v)=(0,0)`, reuse the normalized affine plane `H` from (14).  Then

\[
 (B_0,B_1,B_2,B_3)=(0,a,a+1,a+1),
\]

and `N` is rootless exactly when

\[
                         \operatorname {Tr}(1/(a+1))=1.
\]

This still gives 32 coefficient parameters, but the final-pair cover
collapses in the wrong direction.  Directly from (2), if
`L=(a+1)^2x`, then

\[
 \frac{N\Delta}{Q^2}
 +\left(\frac LQ\right)^2+\frac LQ
 =\frac1{a+1}.
\]

Hence the Artin--Schreier change `y -> y+L/Q` makes the cover constant.
Whenever `N` is rootless, that constant has absolute trace one, so there is
no rational fibre away from the already deleted poles.  Thus the dense
affine-plane chart is provably unusable at the endpoint; this is not a failed
parameter search.  The `(0,0)` boundary must reverse the rootlessness trace
choice, as follows.

In fact the same identity closes the endpoint by reversing the trace choice.
For arbitrary fixed roots at `e3`, one has `B0=0`; write
`(B1,B2,B3)=(b,c,d)`.  Then

\[
\begin{aligned}
 \Delta&=bd+c^2+cdx+d^2x^2,\\
 Q&=bc+c^2x+cdx^2,\\
 N&=b^2+bcx+(c^2+bd)x^2.
\end{aligned}
\]

A direct polynomial identity gives

\[
 \frac{N\Delta}{Q^2}
 +\left(\frac{c^2x}{Q}\right)^2+\frac{c^2x}{Q}
 =\frac{c^2+bd}{c^2}.                                    \tag{25}
\]

The right side is exactly the quadratic rootlessness trace argument
`n0 n2/n1^2`.  Trace one therefore makes `N` rootless but the cover empty;
trace zero makes `N` split but the normalized cover the disjoint union of two
rational lines.  The latter has `2(64+1)=130` rational points, enough to pay
for the zeros of `N` rather than forbid them globally.

Use the explicit split quintic from the dense chart, so

\[
 H(t)=t^4+t^2+t+1,\qquad
 (B_0,B_1,B_2,B_3)=(0,a,a+1,a+1).
\]

Among `a!=1`, exactly 31 parameters satisfy
`Tr(1/(a+1))=0`.  Excluding `a=0` and the four roots of `H` leaves at least
26 choices.  For any such choice, `Q`, `Delta`, and `N` are proper
polynomials.  For a fixed root `r` of `H`, if
`r^2 Delta+rQ+N` were identically zero in `x`, the sum of its `x` and `x^2`
coefficients would force `a^2+1=0`, hence `a=1`; at `a=1` its constant
coefficient is one, a contradiction.  The final/moving collision polynomial
is

\[
 x^2\Delta+xQ+N=(a^2+1)x^4+(a^2+1)x^2+a^2,
\]

which cannot vanish identically because its constant and leading
coefficients cannot both vanish.

Thus no collision condition contains either rational component.  Charging
both components over each deleted base coordinate gives

\[
 10+4+4+20+8+2+2+4=54<130,
\]

for moving/fixed collisions, `Q=0`, `Delta=0`, final/fixed collisions,
final/moving collision, infinity, moving root zero, and finally `N=0`.
Therefore a valid pointed locator survives.  This closes the `(u,v)=(0,0)`
marked-torus boundary without a certificate and shows why the correct local
strategy is a reducible rational cover rather than a rootless final
quadratic.

The other `u=0` boundary, normalized to `(u,v)=(0,1)`, also closes on the
same split quintic.  Its fixed-root coefficients are

\[
                    (B_0,B_1,B_2,B_3)=(a,a+1,a+1,1).
\]

Here

\[
 \frac{n_0n_2}{n_1^2}
 =\frac{a(a+1)^2}{(a^2+a+1)^2}
 =\left(\frac{a}{a^2+a+1}\right)^2
  +\frac{a}{a^2+a+1}.                                    \tag{26}
\]

Thus `N` always splits when it is nondegenerate; rootlessness is again the
wrong local demand.  Choose `a in GF(8) subset GF(64)` with

\[
                         a^3+a+1=0.                       \tag{27}
\]

Then `a` is nonzero and is not a root of `H`, since (27) gives `H(a)=1`.
For this specialization,

\[
\begin{aligned}
 \Delta&=a^2+a+(a+1)x+x^2,\\
 Q&=a^2+a+1+(a^2+1)x+(a+1)x^2,\\
 N&=a+1+(a^2+a+1)x+(a^2+a)x^2.
\end{aligned}                                             \tag{28}
\]

The reduced odd-pole numerator modulo `Q` is the nonzero constant

\[
 \frac{a(a^9+a^8+a^7+a^4+a^3+a^2+1)}{a^2+1};
\]

modulo (27), the degree-nine factor is `a^2+a+1!=0`.  Hence the cover is
geometrically integral of genus one.

Its point count is exact and structural.  Over `GF(8)`, direct reduction with
the basis `1,a,a^2` shows that `Q` has no rational root and that the trace of
`N Delta/Q^2` is zero at

\[
       x=0,a^2,a^3,a^4,a^5,a^6,
\]

and one at `x=1,a` and at infinity.  The curve therefore has 12 points over
`GF(8)`, so its Frobenius trace is `-3`.  Quadratic base change gives

\[
 \#C(\mathbf F_{64})
 =64+1-\bigl((-3)^2-2\cdot8\bigr)=72.                    \tag{29}
\]

All deletion divisors are proper.  The final/moving polynomial is

\[
             x^4+(a^2+1)x^2+(a+1),
\]

so it is nonzero.  For final/fixed collisions it suffices by Frobenius to use
one root `a` of (27).  On the four roots
`r=1,a^3,a^6,a^5` of `H`, the coefficient triples of
`r^2 Delta+rQ+N` are respectively

\[
 (a,1,a^2),\quad(a,a^5,a^4),\quad(1,a,a^6),\quad(1,a^2,a^5),
\]

and hence never vanish identically.  Adding the at most four cover points
above the two roots of `N` to the sharp pointed table gives

\[
                         48+4=52<72.                      \tag{30}
\]

Thus a valid pointed locator survives, closing the `(0,1)` boundary without
a certificate.  The forced-root surface is now reduced to the 63 normal
forms `(u,v)=(1,tau)` with `tau!=1`.

Six of those forms constitute one more exact constant-cover stratum.  On the
chart `H(t)(t+a)`, the coefficients for `(u,v)=(1,tau)` are

\[
\begin{aligned}
B_0&=\tau a+\tau^2,\\
B_1&=(\tau^2+1)a+\tau,\\
B_2&=a+\tau^2+1,\\
B_3&=(\tau+1)a+1.
\end{aligned}
\]

If

\[
                         \tau^6+\tau^5+1=0,
\]

direct reduction gives

\[
                         n_0n_2=\tau^9n_1^2,
 \qquad \operatorname {Tr}(\tau^9)=0.
\]

These are precisely six conjugate values in `GF(64)`.  Set `a=tau`.  Then

\[
 (B_0,B_1,B_2,B_3)
 =(0,\tau^3,\tau^2+\tau+1,\tau^2+\tau+1).
\]

The polynomial `H` and `tau^6+tau^5+1` are coprime, so the five fixed roots
remain distinct and nonzero.  Identity (25) now makes the final-pair cover
the disjoint union of two rational lines, hence gives 130 rational points.
Every deletion divisor is proper: putting `b=tau^3` and
`c=tau^2+tau+1`, the difference between the `x` and `x^2` coefficients of
`r^2 Delta+rQ+N` is `c^2!=0`, while the final/moving polynomial has leading
coefficient `c^2`.  The remaining base polynomials are visibly nonzero from
`bc!=0`.  Thus the same full pointed bound gives

\[
                              54<130.
\]

This closes all six roots of `tau^6+tau^5+1` without a certificate.  The
forced-root surface is reduced to 57 normal forms.

The specialization `a=tau` is useful beyond that sextic.  It always gives

\[
 B_0=0,\qquad B_1=\tau^3,\qquad
 B_2=B_3=\tau^2+\tau+1,
\]

and, when the last coefficient is nonzero, the constant in (25) is

\[
                 T(\tau)=\tau+\frac1{\tau^2+\tau+1}.
\]

Summing the six Frobenius powers and reducing against `X^64-X` gives the
exact trace-zero factorization

\[
\begin{aligned}
 &\tau(\tau+1)(\tau^3+\tau+1)(\tau^3+\tau^2+1)\\
 &\qquad\cdot(\tau^6+\tau^5+1)
 (\tau^6+\tau^5+\tau^2+\tau+1)=0.                        \tag{31}
\end{aligned}
\]

The denominator-zero values are the two roots of `tau^2+tau+1` and do not
occur in (31).  The factor `tau+1` is the dense form already closed.  The
roots of `tau^3+tau^2+1` are exactly the three nontrivial roots of `H`, so
`a=tau` collides with the fixed affine plane there.  The two sextic factors
and the two cubic factors in (31) are pairwise coprime to the denominator;
apart from that one collision cubic, they are also coprime to `H`.

Consequently `a=tau` and the same `130>54` constant-cover proof close the
three roots of `tau^3+tau+1` and the six roots of
`tau^6+tau^5+tau^2+tau+1`, in addition to the sextic already treated.  At
`tau=0`, the coefficient tuple is the one from the `(0,0)` boundary, so its
earlier trace-zero choice with `a!=0` closes this form too.  Ten of the 57
forms are thereby removed.  The exact surface remainder has 47 forms:

| remaining stratum | size |
|---|---:|
| `Tr(T(tau))=1` | 42 |
| `tau^3+tau^2+1=0` (the `a=tau` collision cubic) | 3 |
| `tau^2+tau+1=0` (denominator zero) | 2 |

This is a theorem-derived arithmetic partition, not a list of support
certificates.

There is a further semilinear compression.  The 42 trace-one values form
seven Frobenius orbits, represented by the irreducible sextics

\[
\begin{array}{ll}
P_1=T^6+T+1,&P_2=T^6+T^4+T^2+T+1,\\
P_3=T^6+T^3+1,&P_4=T^6+T^4+T^3+T+1,\\
P_5=T^6+T^5+T^3+T^2+1,&
P_6=T^6+T^5+T^4+T^2+1,\\
P_7=T^6+T^5+T^4+T+1.&
\end{array}
\]

Frobenius preserves the pointed locator problem and the split chart, so one
specialization per polynomial suffices.  The collision cubic and denominator
quadratic are each one Frobenius orbit.  Thus the 47-value remainder is only
nine proved semilinear cases: seven generic, one cubic, and one quadratic.

The fractional-linear maps

\[
 T\longmapsto T+1,\qquad T\longmapsto 1/T,
 \qquad T\longmapsto T/(T+1)
\]

connect `P1,P2,P6,P7` in one arithmetic cluster and `P3,P4,P5` in another;
some images land in already closed trace-zero strata.  They do **not** give a
symmetry reduction of the pointed problem.  The forbidden root and
contraction marker form an ordered pair, whose projective stabilizer is the
diagonal torus.  That torus acts by `(u,v)->(cu,c^2v)` and fixes `tau=v/u^2`.
Translations move the forbidden root, while inversion exchanges the two
roles.  Renormalizing the ordered pair cancels those moves rather than
producing the displayed fractional-linear action on `tau`.

Nor can one invoke a new contraction marker at the level of `tau`: changing
the marker depends on the uncontracted parent syndrome, and contraction has
forgotten precisely the kernel data needed to recover that dependence.
There is therefore no universal marker-change map on this contracted
one-parameter quotient.  The `4+3` clustering is an arithmetic coincidence
unless a parent-level correspondence is supplied.  The sharp currently
proved symmetry quotient is nine cases.

There is also an exact warning against the most tempting seven-root padding.
On the first row of the table suppose `q=q_{u,v}` splits, and write a monic
degree-nine candidate as `g=qk`, with `k` monic of degree seven.  The two R11
Hankel equations reduce to

\[
\begin{aligned}
 k_0+uv^2k_5+(u^6+v^3)k_6&=0,\\
 k_1+uv^2k_6+(u^6+v^3)k_7&=0.                            \tag{32}
\end{aligned}
\]

Now let the seven roots of `k` be an affine three-space with one point `r`
removed.  Write the subspace polynomial as

\[
 L_U(t)=t^8+\alpha t^4+\beta t^2+\gamma t,
 \qquad \gamma\ne0.                                      \tag{33}
\]

Synthetic division of `L_U(t)+C` by `t+r` gives

\[
 k_7=1,\ k_6=r,\ k_5=r^2,\quad
 k_1=\beta+r^6+\alpha r^2,\quad
 k_0=\gamma+r\beta+r^7+\alpha r^3.                       \tag{34}
\]

Substitution of (34) into (32) first determines `beta` and then cancels every
term except `gamma`; hence (32) forces `gamma=0`, contradicting (33).
Therefore the natural `q`-support plus affine-three-space-minus-one padding
cannot close even the split-quadratic stratum.  This explains a substantial
part of the earlier support-atlas failure without appealing to its
certificates and rules out that family for the continuation.

The dense syndrome is the point `(u,v)=(1,1)` and is closed above.  Off
(22), the slope kernel contains quartics with nonzero constant term; the
remaining issue there is complete splitting and selector nonvanishing, not a
forced forbidden root.  On (22), the correct continuation is to generalize
the affine-two-space cubic-trace chart rather than retry the rigid pencil.

The nearest structured realization writes the five fixed roots as an affine
two-plane plus one point.  If

\[
 L_U(t)=t^4+At^2+Bt
\]

is the subspace polynomial of a two-dimensional `F2`-space and `C=L_U(b)` is
the nonzero value defining a coset disjoint from zero, then

\[
 h(t)=(t+a)(t^4+At^2+Bt+C)                                \tag{35}
\]

is automatically split with five distinct nonzero roots when the extra root
avoids that coset.  Its coefficients are

\[
 (g_0,g_1,g_2,g_3,g_4,g_5)
 =(aC,aB+C,aA+B,A,a,1).                                   \tag{36}
\]

Equations (35)--(36) give a four-parameter split chart on which the slope-pencil
conditions can be imposed explicitly.  The next proof should either:

1. use the slope-pencil gate (6) on the strata where its constant term is not
   forced to vanish; or
2. copy the successful dense calculation (14)--(19) across the surface (22).

The degenerate chart `B3D=0` must be treated separately.  It includes the
endpoint syndrome `e7`, for which `B3=0`, `D=1`, and

\[
 \operatorname {Tr}T
 =\operatorname {Tr}\left(1+g_3/g_4^2\right)              \tag{37}
\]

when `g4!=0`.  This is already an explicit lower-dimensional trace problem,
not evidence for a new modular family.

## 4. Boundary

This checkpoint proves coefficient-space trace abundance only.  An arbitrary
coefficient quintic need not split, so the theorem does not yet close GF(64).
Conversely, a future proof must not discard the exact half-density by paying a
generic high-degree character-sum constant.  The split chart (4) or an
equivalent rational family should preserve it directly.

No computation, manuscript edit, or software edit supports this theorem.

## 5. `ej` + `tt` and mystery ledger

The `ej` pass converts rootlessness from an opaque trace condition into an
exact balanced affine direction.  The `tt` pass asks where that affine line
lives inside the split-quintic cover; composition-factor or dimension
arguments do not answer that arithmetic question.

| mystery | status | exact next gate |
|---|---|---|
| Is trace one sparse on the generic coefficient chart? | no; exact density `1/2` | theorem above |
| Can the trace function collapse to zero? | not when `B3D!=0`; the coefficient in (3) is forced nonzero | proved by squaring |
| Why is GF(64) numerically plausible? | 32 coefficient values are rootless before selector exclusions | preserve this balance on a split chart |
| How is the balanced `B0`-line realized by split quintics? | conditionally solved by the slope pencil (6), but not universally | use it only off its forced-root strata |
| What is the first exact slope obstruction? | dense `z=(1,1,1,1,1)` forces `p0=p1=0` | settled by the cubic-trace chart (14)--(19) |
| How large is the complete forced-root locus? | the explicit surface (22) | extend the cubic-trace chart in `(u,v)` |
| Does that surface have internal structure? | yes; the fixed quadratic (23) gives exact counts `1953+2016+63+64` | treat the four quadratic strata separately |
| How many marked-torus forms remain? | 66 total; the constant-cover trace factorization (31) leaves 47 | three explicit arithmetic strata above |
| Does rootlessness close the `(0,0)` boundary? | no; (25) makes the cover empty, but the opposite trace splits it into two rational lines | closed by `130>54` |
| What closes the `(0,1)` boundary? | a `GF(8)` elliptic specialization with 72 points | closed by `72>52` |
| What happens when `tau^6+tau^5+1=0`? | `n0n2=tau^9 n1^2` with trace-zero constant | all six forms closed by `130>54` |
| How far does `a=tau` extend? | factorization (31) closes nine additional noncolliding roots; `tau=0` reuses the endpoint | ten more forms closed |
| How many semilinear cases are left? | seven sextics, one cubic, one quadratic | nine proved cases |
| Can cross-ratio transformations reduce the seven sextics? | no at the contracted pointed level; the ordered-pair torus fixes `tau` | `4+3` is not a valid symmetry quotient |
| Can the split-quadratic stratum be padded by an affine three-space minus one point? | no; (32)--(34) force the subspace-polynomial coefficient `gamma` to vanish | use a genuinely different seven-root family |
| Does the affine-plane-plus-one chart help? | yes; `beta=1` closes the dense obstruction with 65 points against 45 deletions | transfer the mechanism to the remaining forced-root strata |
| What owns `B3D=0`? | same C973 proof, by explicit lower-dimensional charts beginning with (6) | stratified trace calculation |

Vibe: the trace obstruction is abundant, not exceptional; the last binary
difficulty is now precisely the compatibility between that balanced line and
complete splitting.
