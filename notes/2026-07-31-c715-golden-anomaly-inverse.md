# C715 — Golden anomaly inverse

**Lane:** `golden`

**Date:** 2026-07-31

## Verdict

Every rational point of the six-charge anomaly variety has a rational golden
filter preimage.  In the frozen C707 marking the inverse is three ratios of
linear pair sums.  This is the classical inverse of the six-point Joubert map,
now written in path coordinates; its new role here is to synthesize the
postselected golden transfer and to expose its exact physical cost.

The exceptional geometry is equally explicit.  Pair collisions pull back the
fifteen vectorlike Segre planes, two triple collisions give the ten nodes, and
configurations with at least four coincident points are unstable and map to
zero.  Strictly chiral charges are the complement of the fifteen opposite-pair
planes and the six zero-charge sections.  The Segre--Igusa polar map contracts
the same fifteen pair-collision divisors.

The integral witness

\[
 r=(-3,-2,-1,0,1,3),\qquad
 q=(11,-10,-8,5,4,-2)
\]

is the unique centered integral preimage of height three up to common sign.
It is not success-maximal.  A rational reparametrization gives the normalized
filter

\[
 \left(1,\frac7{13},\frac17,-\frac15,-\frac12,-1\right)
\]

and improves every three-fermion probability by
\(236196/207025\).  On the real fibre there is a unique algebraic optimum.
Its pole is irrational, so rational filters approach the optimum but no
rational filter attains it.

## 1. The marked inverse

Write a point of \(\mathbf P^1\) as a column \(v_i\), put
\([ij]=\det(v_i,v_j)\), and for a perfect matching set

\[
 X_{ij|kl|mn}=[ij][kl][mn].
\]

In the affine chart \(v_i=(x_i,1)^{\mathsf T}\), the frozen C707 cubics are
\(Z_T(x)\).  Direct coefficient comparison gives the following complete
matching dictionary.

\[
\begin{array}{c|c@{\qquad}c|c@{\qquad}c|c}
01|23|45&-(z_0+z_1)/2&01|24|35&(z_2+z_3)/2&01|25|34&-(z_4+z_5)/2\\
02|13|45&(z_2+z_4)/2&02|14|35&-(z_0+z_5)/2&02|15|34&(z_1+z_3)/2\\
03|12|45&-(z_3+z_5)/2&03|14|25&(z_1+z_2)/2&03|15|24&-(z_0+z_4)/2\\
04|12|35&(z_1+z_4)/2&04|13|25&-(z_0+z_3)/2&04|15|23&(z_2+z_5)/2\\
05|12|34&-(z_0+z_2)/2&05|13|24&(z_1+z_5)/2&05|14|23&-(z_3+z_4)/2
\end{array}
\]

Here the left entry in each pair denotes \(X_M\).  The signs belong to the
fixed C707 orientation; reversing the common Joubert orientation reverses all
of them.

### Theorem 1 (rational golden anomaly inverse)

Let \(k\) have characteristic zero and let

\[
 [z]\in S(k),\qquad \sum_Tz_T=\sum_Tz_T^3=0.
\]

On the chart where the denominators below are nonzero, define the matching
forms \(X_M(z)\) by the table and put

\[
 a=\frac{X_{02|13|45}}{X_{03|12|45}},\qquad
 b=\frac{X_{02|14|35}}{X_{04|12|35}},\qquad
 c=\frac{X_{02|15|34}}{X_{05|12|34}}.
\]

Then the ordered sextuple

\[
 (p_0,p_1,p_2,p_3,p_4,p_5)=(\infty,0,1,a,b,c)
\]

has Joubert image \([z]\).  Permuting the path labels gives an atlas covering
the smooth Segre cubic.  Over the locus of six distinct points, the full fibre
in \((\mathbf P^1)^6\) is one \(\operatorname{PGL}_2\)-orbit with trivial
labelled stabilizer.  After restricting to finite path coordinates and
quotienting translation and scale, the remaining preimages form the rational
one-parameter family obtained by choosing the pole of a fractional linear
map.

#### Proof

For the normalized sextuple, bracket expansion gives

\[
\begin{aligned}
X_{01|23|45}&=(1-a)(b-c),&
X_{02|13|45}&=-a(b-c),\\
X_{01|24|35}&=(1-b)(a-c),&
X_{02|14|35}&=-b(a-c),\\
X_{01|25|34}&=(1-c)(a-b),&
X_{02|15|34}&=-c(a-b).
\end{aligned}
\]

The Plücker relation supplies

\[
\begin{aligned}
X_{02|13|45}-X_{01|23|45}&=X_{03|12|45},\\
X_{02|14|35}-X_{01|24|35}&=X_{04|12|35},\\
X_{02|15|34}-X_{01|25|34}&=X_{05|12|34}.
\end{aligned}
\]

The three displayed ratios therefore recover \(a,b,c\).  The first
fundamental theorem for six points on \(\mathbf P^1\) says that the matching
brackets generate the equal-weight invariant ring, and their projective image
is the Segre cubic.  The fifteen identities in the table identify that
projective image with the frozen C707 coordinates.  Hence reconstruction of
the matching point reconstructs \([z]\), without a solver or finite
certificate.

Three distinct labelled points determine the normalizing projectivity, so the
stabilizer on the distinct-point locus is trivial and the fibre assertion
follows.  A finite affine chart quotients only the two-dimensional affine
subgroup of \(\operatorname{PGL}_2\); its one remaining parameter is the pole.
\(\square\)

For the charge witness the inverse gives

\[
 (\infty,0,1,4/3,3/2,5/3).
\]

The projectivity \(s\mapsto2(s+2)/(s+3)\) sends the integral path sextuple
\((-3,-2,-1,0,1,3)\) to this normalized representative.

## 2. Exceptional and chiral strata

The GIT quotient makes every exceptional set visible in path language.

### Pair collisions and vectorlike planes

For each path pair \(i,j\), the collision divisor \([ij]=0\) annihilates the
three matching invariants containing that pair.  Under the outer dictionary
these become the three equations

\[
 z_r+z_s=z_u+z_v=z_w+z_t=0
\]

for one syntheme of the charge labels.  Thus the fifteen pair-collision
divisors map to the fifteen vectorlike Segre planes.  A general point of such a
plane is smooth and has five distinct path points.

The same fifteen planes are the exceptional divisors of the projective polar
map \(z\mapsto\operatorname{center}(z_T^2)\): each is contracted to one
singular line of the Igusa quartic.  Hence the inverse-polar exceptional
divisor pulls back to the union of the fifteen path pair-collision divisors.

There is also one scalar collision test:

\[
 \boxed{\quad e_5(Z(x))=32\prod_{i<j}(x_j-x_i).\quad}
\]

Indeed, \(e_5(Z(x))\) is an alternating polynomial of degree fifteen, so it
is a scalar multiple of the Vandermonde; evaluation at
\((0,1,2,3,4,5)\) gives the factor \(32\).  Thus \(e_5(Z)\ne0\) detects the
smooth nonvectorlike locus in one equation.  It does not detect strict
chirality, because a single coordinate \(Z_T\) may vanish while \(e_5(Z)\)
does not.

Multiplying the fifteen matching identities gives the intrinsic Segre
factorization

\[
 \boxed{\quad
   \prod_{T<U}(z_T+z_U)=-e_5(z)^3
   \quad\text{when}\quad \sum_Tz_T=\sum_Tz_T^3=0.
 \quad}
\]

The fifteen frozen matching signs have product \(+1\), every path bracket
occurs in exactly three perfect matchings, and
\(\prod_{i<j}[ij]= -\prod_{i<j}(x_j-x_i)\).  The matching dictionary and the
Vandermonde identity prove the formula on the dense six-distinct locus, hence
on the whole Segre cubic.  At a generic point of a vectorlike plane, exactly
three opposite-pair factors vanish.  Thus the product on the left cuts the
fifteen-plane divisor with multiplicity three, whereas \(e_5\) cuts its
reduced union.

### Nodes and unstable configurations

A semistable sextuple with three points at \(u\) and three at \(v\ne u\)
maps to one of the ten projective vectors with three \(+1\)'s and three
\(-1\)'s.  These are exactly the ten Segre nodes.  Its labelled stabilizer is
the one-dimensional torus fixing \(u\) and \(v\), so its orbit has dimension
two rather than three.  The fixed three-point inverse chart cannot cover a
node because only two distinct points remain.

If at least four path points coincide, every perfect matching contains a
vanishing bracket.  All fifteen invariant coordinates, and therefore all six
\(Z_T\), vanish.  These are the unstable configurations rather than points of
the projective Segre cubic.

### Strict chirality

For one \(U(1)\), strict chirality means

\[
 z_T\ne0\quad\hbox{and}\quad z_T+z_U\ne0
 \qquad(T\ne U).
\]

The second condition says that all fifteen matching brackets are nonzero, so
the path sextuple consists of six distinct points.  The first removes the six
Joubert cubic walls \(Z_T(x)=0\), equivalently the six zero-success Majorana
parity walls.  This open set is smooth because the singular nodes lie on the
vectorlike planes.

### The Boolean boundary

A real phase mask has only two path values.  If its multiplicities are not
\(3+3\), at least four entries coincide; it is unstable and maps to zero.
There are \(44\) such masks.  The remaining \(20\) oriented \(3+3\) masks map
in complementary pairs to the ten nodes.  Thus

\[
 44\longmapsto0,qquad 20\longmapsto\text{oriented vectorlike nodes}
\]

is the two-value boundary of the general GIT stratification, not a separate
finite coincidence.

## 3. Rational physical synthesis and cost

Let \(z\in\mathbb Q^6\setminus\{0\}\) satisfy the anomaly equations.  Clear
denominators and divide by the gcd to obtain a primitive integral vector
\(q\), unique up to common sign.  Apply Theorem 1, permuting path labels if a
different inverse chart is needed.  For the normalized sextuple
\((\infty,0,1,a,b,c)\), choose any rational
\(d\notin\{0,1,a,b,c\}\) and set

\[
 y_0=0,qquad y_i=\frac1{p_i-d}\quad(1\le i\le5).
\]

Put \(R=\max_i y_i-\min_i y_i\),
\(m=(\max_i y_i+\min_i y_i)/2\), and

\[
 x_i=\frac{2(y_i-m)}{R}.
\]

Then \(x\in\mathbb Q^6\), \(\|x\|_\infty=1\), and
\(Z(x)=\kappa q\) for a nonzero rational \(\kappa\).  This gives a rational
physical filter for every rational chiral charge point.  If

\[
 \tau=\frac{(1-a)(b-c)}{X_{01|23|45}(q)},\qquad
 D=(-d)(1-d)(a-d)(b-d)(c-d),
\]

then the common scale is

\[
 \boxed{\quad \kappa=-\tau\left(\frac2R\right)^3\frac1D.\quad}
\]

The formula is projectively invariant: another primitive lift changes only
the displayed common scale.

For protocol \(T\), the exact three-fermion success probability and expected
number of independent trials are

\[
 \boxed{\quad p_T^{(3)}=\frac{\kappa^2q_T^2}{500},\qquad
 C_T=\frac{500}{\kappa^2q_T^2}.\quad}
\]

If \(q_T=0\), that branch has zero success and infinite trial cost.  Under a
further attenuation \(x\mapsto\lambda x\), probabilities scale as
\(\lambda^6\) and costs as \(\lambda^{-6}\).

For a uniformly chosen protocol, the success probability is

\[
 \overline p^{(3)}=\frac{\kappa^2\lVert q\rVert_2^2}{3000}.
\]

All branch ratios \(p_T^{(3)}/p_U^{(3)}=(q_T/q_U)^2\) are independent of
the chosen preimage.  One calibrated nonzero branch therefore fixes the
other five probabilities.

For \(x=r/3\), \(\kappa=4/27\).  In charge order the six probabilities are

\[
 \left(
 \frac{484}{91125},\frac{16}{3645},\frac{256}{91125},
 \frac4{3645},\frac{64}{91125},\frac{16}{91125}
 \right).
\]

## 4. Height and fibrewise success

The primitive integral affine height is the maximum absolute entry after an
integral translation centers the representative.  Six distinct integers do
not fit in \([-2,2]\), so a chiral integral preimage has height at least three.
Exact enumeration of the \(7P6=5040\) ordered distinct sextuples in
\([-3,3]^6\) finds only \(r\) and \(-r\) above \([q]\).  The witness is
therefore the unique height-three preimage up to common sign.  This statement
does not claim minimality for every possible arithmetic height on rational
points.

Every real preimage is obtained from \(r\) by a projectivity.  Modulo the final
affine centering and scaling, write it as

\[
 y_i(t)=\frac1{r_i-t},\qquad t\in\mathbf P^1\setminus\{r_i\}.
\]

Let \(R(t)=\max_i y_i(t)-\min_i y_i(t)\).  The common charge multiplier after
normalization is

\[
 Z(\operatorname{normalize}y(t))=4\mu(t)q,qquad
 \mu(t)=\frac{(2/R(t))^3}{\prod_i|r_i-t|}.
\]

On each of the seven intervals cut out by the six \(r_i\)'s, logarithmic
differentiation gives one quartic critical equation.  Exact Sturm counts give
one critical point on each bounded interval and on \(( -\infty,-3)\), and no
critical point on \((3,\infty)\).  Rational interval bounds separate all seven
maxima.  The global maximizer is the unique root

\[
 t_*\in\left(-\frac{15407}{1000},-\frac{7703}{500}\right)
\]

of

\[
 t^4+17t^3+24t^2-9t-9=0.
\]

Numerically,

\[
 t_*=-15.4067906889\ldots,qquad
 \mu(t_*)=0.03956247006\ldots,qquad
 4\mu(t_*)=0.1582498802\ldots.
\]

The rational-root theorem shows that \(t_*\notin\mathbb Q\).  A rational
preimage has rational pole, so rational filters have this success supremum but
no maximizer.  The integral witness corresponds to \(t=\infty\), where
\(\mu=1/27\); the supremal probability gain is
\(1.1410228082\ldots\).

Since every nonzero branch probability is a positive constant times
\(\mu(t)^2\), the same \(t_*\) simultaneously maximizes every branch, their
uniform average, their minimum over nonzero charges, and any fixed positive
weighted sum.  It likewise minimizes every cost that decreases strictly with
the common success scale.

The nearby rational pole \(t=-15\) gives

\[
 \mu(-15)=\frac{18}{455},\qquad
 x(-15)=\left(1,\frac7{13},\frac17,-\frac15,-\frac12,-1\right),
\]

so \(Z(x(-15))=(72/455)q\).  Its exact probability gain over \(r/3\) is

\[
 \left(\frac{18/455}{1/27}\right)^2
   =\frac{236196}{207025}>1.
\]

### Uniform optimizer for every real chiral point

The seven-chamber reduction is not special to the displayed witness.  Let
\(r_1<\cdots<r_6\) be any six distinct real path points reconstructed from a
smooth nonvectorlike charge point.  In a pole chamber, let \(a,b\) be the two
source points whose reciprocal images are the minimum and maximum: they are
consecutive when the pole lies between source points, and are \(r_1,r_6\) on
either exterior chamber.  After centering and scaling to \([-1,1]\), the
common amplitude multiplier is, up to the fixed scale of \(Z(r)\),

\[
 \mu_{a,b}(t)=
 \frac{8|t-a|^2|t-b|^2}
 {(b-a)^3\prod_{r_i\notin\{a,b\}}|t-r_i|}.
\]

Its non-boundary critical points satisfy

\[
 \frac2{t-a}+\frac2{t-b}
   -\sum_{r_i\notin\{a,b\}}\frac1{t-r_i}=0.
\]

After denominators are cleared, the degree-five term cancels because
\(2+2-4=0\).  Each chamber is therefore optimized by a polynomial of degree
at most four.  Exact real optimization for any rational anomaly point reduces
uniformly to isolating the real roots of at most seven rational quartics and
comparing their exact algebraic values.  This defines a piecewise-algebraic
projective filter capacity; the witness calculation above is one fibre of
that general construction.

## 5. Attribution and boundary

The matching generators, the Segre quotient, the Joubert coordinates, and the
cross-ratio inverse are classical.  The six-charge anomaly variety and general
integer charge parametrizations are also prior art.  The companion literature
audit records five primary sources and the exact formula comparison.  The
paper-owned statement is the transport through the frozen golden operator:
the marked inverse becomes a diagonal filter, its determinant is an exact
three-fermion amplitude, and its normalization yields the cost and Boolean
boundary above.

The filter parametrizes charge arithmetic.  It does not supply gauge fields, a
Lagrangian, or a quantum field theory.

## 6. Exact evidence and replay

The evidence bundle is:

- `notes/2026-07-31-c715-golden-anomaly-inverse.py`;
- `notes/2026-07-31-c715-golden-anomaly-inverse.json`;
- `notes/2026-07-31-c715-golden-anomaly-inverse-replay.py`;
- `notes/2026-07-31-c715-golden-anomaly-inverse.sha256`.

From the repository root, run

```text
python3 notes/2026-07-31-c715-golden-anomaly-inverse.py --check
python3 notes/2026-07-31-c715-golden-anomaly-inverse-replay.py
```

The generator reconstructs the six frozen cubics from the conference marking,
checks all fifteen matching identities, enumerates all \(5040\) height-three
filters, and certifies the seven real pole intervals by exact Sturm sequences
and rational enclosures.  The replay hard-codes the frozen cubic coefficient
tables, independently repeats the finite enumeration, and replaces Sturm
counting by intervalwise Descartes transforms.  Computation fixes signs,
normalizations, the finite height census, and the optimization comparison.  It
does not prove the GIT quotient theorem, fibre description, or collision
stratification; those are the structural arguments above.

## 7. `ej` + `tt` closeout and mystery ledger

- **Settled by `ej`:** the fifth elementary symmetric function of the six
  amplitudes is exactly \(32\) times the path Vandermonde.  This compresses
  the fifteen nonvectorlike tests to one marked scalar without confusing them
  with the six zero-charge walls.
- **Settled by second-order `ej`:** multiplying all fifteen matching forms
  gives \(\prod_{T<U}(z_T+z_U)=-e_5(z)^3\).  This explains why every
  vectorlike plane occurs triply in the product of opposite-pair tests and
  singly in the reduced \(e_5\)-divisor.
- **Settled by `ej`:** the real pole optimum is universal across all nonzero
  protocol branches and every fixed positive aggregate, because the fibre
  changes only the common scale \(\kappa\).
- **Settled by `tt`:** rational synthesis is not obstructed by a quotient
  torsor.  The matching-ratio atlas produces a rational labelled sextuple on
  every smooth rational chart, and the ten rational nodes have explicit
  \(3+3\) representatives.
- **Settled by `tt`:** the inverse must distinguish smooth nonvectorlike from
  strict chiral.  Six distinct path points exclude opposite charge pairs;
  strict chirality additionally excludes \(Z_T=0\).
- **Settled by second-order `tt`:** physical optimization is uniformly finite
  on every real chiral fibre: seven pole chambers, quartic critical equations,
  and exact algebraic comparison.  The witness quartic is not an isolated
  numerical accident.
- **Open by design:** other arithmetic heights on rational filters may rank
  preimages differently.  The proved minimality uses centered primitive
  integral affine height; no broader height claim is made and no successor is
  needed for the paper theorem.
- **Owned by C716:** use the frozen one-parameter inverse to synthesize lines
  for two \(U(1)\) factors and separate chiral from plane components.
- **Owned by C719:** translate the exact branch and aggregate costs into a
  platform-specific circuit and feasibility budget.
- **Open, currently unallocated:** stratify the resulting projective filter
  capacity over the full real Segre cubic and determine its boundary behavior
  near the vectorlike planes and nodes.  C719 needs only the fixed witness, so
  this broader real-algebraic problem is not a gate for that task.
- **No genuine mystery remains in the frozen C715 rational inverse,
  exceptional strata, or pointwise normalization interface.**  The global
  capacity stratification is a separate optional continuation.
