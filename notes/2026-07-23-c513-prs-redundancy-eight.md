# C513 — PRS(q−7) redundancy-eight polar-induction theorem

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete high-field
deep-syndrome and projective-semilinear orbit classification

## Result

For every prime power `q >= 43`, the deep syndromes of `PRS(q-7)` are exactly the persistent
catalecticant rank-two tangent and conjugate-sigma families. There is no additional modular-nucleus
family. Their total number is

\[
 \frac{q(q+1)^2}{2}.
\]

The complete orbit law is uniform. On the sigma family it is

\[
 T/T^7\quad\text{modulo inversion and coefficientwise Frobenius},
\]

where `T` is the norm-one torus. On the tangent family the normalized unipotent cocycle is

\[
 u\star z=z+7u,
\]

so the tangent orbit splits into its fixed and nonzero pieces exactly in characteristic seven.

This proves the first new fixed-level application of C512. It does not classify the bounded band
`q < 43`, and it uses no ambient `PG(7,q)` census.

## 1. Pointed septic contraction

Let a redundancy-eight syndrome be the binary septic

\[
 f=(a_0,\ldots,a_7).
\]

Its Hankel kernel is the five-dimensional vector space of binary sextics

\[
 W_f=\ker
 \begin{pmatrix}
 a_0&a_1&a_2&a_3&a_4&a_5&a_6\\
 a_1&a_2&a_3&a_4&a_5&a_6&a_7
 \end{pmatrix}.
\]

For a marked affine root `r`, contraction is

\[
 b(r)=(a_1-ra_0,\ldots,a_7-ra_6),
\]

with `b(infinity)=(a_0,\ldots,a_6)`. C512's divided-power identity gives

\[
 g\in W_{b(r)}\quad\Longleftrightarrow\quad (t-r)g\in W_f.
\]

The lift is squarefree precisely when `g(r) != 0`. Thus C513 needs the pointed C509 witness
problem, not merely the unpointed redundancy-seven classification.

## 2. Three-marker lower splitting package

After three contractions, the bottom generic object is still C491's degree-three map and its
off-diagonal ordered-root fibre square

\[
 Y:\quad G(t_1,t_2)=0\subset\mathbf P^1\times\mathbf P^1.
\]

On the geometric-`S3` stratum, `Y` is geometrically integral because `S3` is transitive on ordered
pairs of distinct roots. It has bidegree `(2,2)` and arithmetic genus one. Adding markers does not
change this cover, its normalization, or its monodromy: it removes incidence divisors from the
same curve.

C491's diagonal and branch deletions have total degree at most twelve. If one forbidden root is
among the three roots of a squarefree cubic fibre, all six ordered pairs in that fibre must be
discarded; hence each marker costs at most six. At redundancy eight there are three ordered
markers, so

\[
 \delta=12+3\cdot6=30.
\]

Hasse--Weil on the geometrically integral normalization, whose genus is at most one, gives

\[
 \#\widetilde Y(\mathbf F_q)\ge q+1-2\sqrt q.
\]

The inequality

\[
 q+1-2\sqrt q>30
\]

holds for every integer `q >= 42`, and the first prime power in that range is 43. C512's convenient
closed bound is the slightly more conservative

\[
 \left\lfloor(1+\sqrt{31})^2\right\rfloor+1=44,
\]

whose first prime-power value is 47. Using the exact normalization inequality therefore improves
the forecast by one prime-power step. Every geometric-`S3` bottom fibre has a split
squarefree cubic avoiding all three markers.

The cyclic, wild, inseparable, gcd, and branch strata remain in the algebraic lower bad carrier
classified in C491--C512. The additional marker changes only the deletion divisor. It creates no
new contained component: the new consecutive-row and modular calculations are given below.
Consequently:

> **Three-marker pointed lemma.** For `q >= 43`, every nonpersistent C509 sextic outside its
> characteristic-two central component has a split squarefree quintic in its Hankel kernel
> avoiding any prescribed point, unless that point lies in the finite marked-collision divisor.

This is the lower splitting package required by C512 at `(m,s)=(6,1)`.

**Referee-facing closure (C538).**  The original paragraph above recorded the
correct generic curve and deletion count but did not itself print the
recursive cyclic, wild, inseparable, gcd-one, branch, and marker-collision
pullbacks.  `notes/2026-07-23-c538-lp61-pointed-lower-package.md` now supplies
those equations and their containment degrees, proves the geometric-`S3`
identity twist, treats the exact-gcd-one strata directly, and verifies the
two-old-marker recursion.  Thus `LP(6,1)` is proved rather than imported
from the C513 certificate.

## 3. Transverse and collision budgets

The first-polar line of a septic meets the lower catalecticant rank-at-most-two carrier in degree
at most three unless it is contained: substitute the linear contraction into any nonzero
`3 x 3` catalecticant minor. The lower characteristic-two central point contributes at most one
further parameter unless the whole line maps to it.

After fixed factors are removed, marked self-collision is ramification of a
`g^4_6`. Its degree is

\[
 (4+1)(6-4)=10.
\]

This series is separable in every characteristic. In characteristic two, the space of sixth-degree
squares has vector dimension four, smaller than the five-dimensional Hankel kernel; in larger
characteristic the `p`-th-power space is smaller still. Thus a zero differential cannot turn the
degree-ten divisor into a hidden component.

The total transverse/collision budget is therefore

\[
 3+1+10=14.
\]

For `q >= 43`, choose a contraction parameter outside these at most fourteen points. The
three-marker pointed lemma supplies a split squarefree quintic avoiding the chosen root, and the
pointed contraction identity lifts it to a split squarefree sextic in `W_f`.

## 4. Contained persistent flags

C512's consecutive-row identity specializes to

\[
 \Phi_f(\mathbf P^1)\subset
 \{\operatorname{rank} C^{(2)}\le2\}
 \quad\Longleftrightarrow\quad
 \operatorname{rank} C_f^{(2)}\le2.
\]

Over the ground field, rank two consists of a rational secant, a tangent, or a conjugate quadratic
secant. Rank one and rational secants are shallow. Tangents force a repeated common factor and
conjugate secants force an irreducible quadratic common factor, so both are deep.

Write `d=gcd(7,q+1)`. Sigma orbits are the inversion-orbits in `C_d`. A class fixed by inversion
has

\[
 (|O|,|\operatorname{Stab}|)
 =\left(\frac{q(q^2-1)}{2d},2d\right),
\]

and a paired class has

\[
 (|O|,|\operatorname{Stab}|)
 =\left(\frac{q(q^2-1)}d,d\right).
\]

Since seven is prime, there is one sigma orbit when `7` does not divide `q+1`; when it does, there
is one fixed class and three paired classes. Frobenius acts by multiplication by the
characteristic on `C_7`, followed by inversion. More explicitly, on the three nonzero inversion
classes Frobenius is trivial when `p` is congruent to `plus-or-minus 1` modulo seven and is a
three-cycle when `p` is congruent to `plus-or-minus 2` or `plus-or-minus 3`. Thus, when
`7` divides `q+1`, `PGammaL2` has four sigma orbits in the first case and two in the second
(the zero class and the fused nonzero class).

The tangent family is one orbit of size `q(q+1)` with stabilizer `q-1` when the characteristic is
not seven. In characteristic seven it splits into

\[
 (q+1,q(q-1))\quad\text{and}\quad(q^2-1,q).
\]

Consequently the total numbers of deep-syndrome orbits are exact:

\[
\begin{array}{c|c|c}
\text{arithmetic case}&PGL_2&P\Gamma L_2\\ \hline
\gcd(7,q+1)=1,\ p\ne7&2&2\\
p=7&3&3\\
7\mid q+1,\ p\equiv\pm1\pmod7&5&5\\
7\mid q+1,\ p\equiv\pm2,\pm3\pmod7&5&3.
\end{array}
\]

The sigma family has `q(q^2-1)/2` points and the tangent family has `q(q+1)` points, giving the
stated total.

## 5. Complete modular-nucleus calculation

For a degree-six normal rational curve, the order-`k` nucleus has coordinate support

\[
 J_{p,k}=\{j:\binom rj=0\pmod p\text{ for every }r=k+1,\ldots,6\}.
\]

Requiring both consecutive contractions of a degree-seven syndrome to lie in that coordinate
space gives:

\[
\begin{array}{c|c|c}
p&\text{nonempty lower nucleus supports}&\text{degree-seven lift}\\ \hline
2&\{3\},\ \{1,3,5\}&0\\
3&\{1,2,4,5\}&\langle e_2,e_5\rangle\\
5&\{2,3,4\}&\langle e_3,e_4\rangle.
\end{array}
\]

There are no other prime-characteristic lifts. In particular, C509's characteristic-two central
point `e3` has zero consecutive-row preimage, so its odd-extension arithmetic family stops at
redundancy seven.

The two nonzero nucleus lifts are shallow:

- In characteristic five, every `f` in `P<e3,e4>` annihilates the split sextic
  `t^5-t` together with its root at infinity. Its coefficient vector has
  `d2=d3=d4=0`, exactly the two Hankel conditions for the whole line.
- In characteristic three, `P<e2,e5>` is the invariant module
  `det^2 tensor E^(3)`. Projectively this is a Frobenius twist of `P1`, so
  `PGL2(q)` is transitive on its rational points. It suffices to treat `e2`.
  Choose nonzero `a,b,c` with no two equal up to sign and
  `a^2+b^2+c^2=0`. The nonsingular conic has `q+1` rational points; the three
  coordinate lines and six equality lines remove at most eighteen, so such a point exists for
  every characteristic-three field `q >= 27`. Taking reciprocal roots
  `1/(plus-or-minus a)`, `1/(plus-or-minus b)`, and
  `1/(plus-or-minus c)` gives a split squarefree sextic whose first two low coefficients vanish,
  hence lies in `W_e2`. Transitivity handles the entire line.

Thus no modular-nucleus component contributes a deep syndrome in the C513 range. Characteristic
seven affects only the tangent cocycle already included in the persistent family.

## 6. High-field theorem

Combining the three-marker lower package, the degree-fourteen transverse/collision budget, and the
contained classifications gives:

> **Redundancy-eight theorem.** For every prime power `q >= 43`, the deep syndromes of
> `PRS(q-7)` are exactly the persistent tangent and conjugate-sigma catalecticant rank-two
> syndromes. Their number is `q(q+1)^2/2`; their complete `PGL2/PGammaL2` orbit law is
> `T/T^7` modulo inversion and Frobenius, together with tangent cocycle `u*z=z+7u`.

The theorem says nothing about which additional orbits occur for `q < 43`. A bounded exceptional
classification would require a separately allocated, orbit-reduced task; it is not evidence for
the high-field proof.

## Literature boundary

The claim-specific audit `2026-07-23-c513-prs-redundancy-eight-literature-audit.md` finds no
pre-emption, subject to its explicit MathSciNet and same-day refresh limitations. Wang's splitting
framework, the classical factorization statistics, NRC nuclei, and Hasse--Weil are inputs rather
than novelty claims.

## Evidence and replay

The compact evidence bundle is:

- `2026-07-23-c513-prs-redundancy-eight.py`;
- `2026-07-23-c513-prs-redundancy-eight.json`;
- `2026-07-23-c513-prs-redundancy-eight-replay.py`; and
- `2026-07-23-c513-prs-redundancy-eight.sha256`.

From the repository root, regenerate and check with:

```text
python3 notes/2026-07-23-c513-prs-redundancy-eight.py \
  --output notes/2026-07-23-c513-prs-redundancy-eight.json --check
python3 notes/2026-07-23-c513-prs-redundancy-eight-replay.py
sha256sum -c notes/2026-07-23-c513-prs-redundancy-eight.sha256
```

The generator independently computes the Hasse threshold, all lower degree-six nuclei and their
degree-seven consecutive lifts, the collision/intersection budgets, and the characteristic-five
split witness. The replay reconstructs the relevant modular linear systems by row reduction and
checks the characteristic-three conic bound. Neither program enumerates deep syndromes or proves
geometric `S3` monodromy; that theorem input is the C491 ordered-pair argument, unchanged by deleting
marker divisors. The closeout certificate also checks the q=7 rootless-quartic count, the exact
disjoint root sets and Hankel equations for the q=49 witness, the even-extension CM count, and the
fixed-five-root residual-discriminant formula. The generator, JSON certificate, and independent replay have exact byte counts
`15003`, `9843`, and `7978`, respectively; their SHA-256 hashes are in the adjacent manifest.

## Extra-juice closeout

The semilinear quotient admits the exact fusion rule above; no field-by-field orbit computation is
needed. It gives total `PGL2/PGammaL2` orbit counts `2/2`, `3/3`, `5/5`, or `5/3` in the four
arithmetic cases displayed above. The Tao pass also replaces the conservative C512 closed
threshold 47 by the exact normalization threshold 43. A bounded look one level ahead sharpens the successor gate.
Redundancy nine would add
a fourth marker, giving deletion degree `12+4*6=36`, C512 integer threshold `51`, first
prime-power threshold `53`, and collision degree `12`.

The cheap nucleus calculation also warns that redundancy nine is not a purely formal repeat.
Degree-seven nuclei lift to a characteristic-five point `P<e4>` and a characteristic-seven
projective four-space `P<e2,e3,e4,e5,e6>`. Their arithmetic deepness is not decided by C513.
This is logged as an incidental successor lead rather than promoted into the present theorem.

The Tao pass suggests a broader re-foundation of the remaining gap. For standard PRS Hankel
systems, contracting all the way to degree four always reaches the same cubic `S3` ordered-pair
cover; at syndrome degree `n`, only `n-4` marker divisors accumulate, giving the generic bound
`delta <= 12+6(n-4)=6n-12`. Thus the generic monodromy may already be uniform in `n`. What remains
level-specific is the scheme-theoretic catalogue of polar flags contained in cyclic, wild, and
nucleus carriers, plus their arithmetic deepness. This is a reasoned opportunity, not an
all-redundancy theorem: one must still prove that the recursive bad-carrier pullbacks have no
unlisted contained components and bound every transverse degree.

### Second-order extra juice

The generic part has a closed all-degree threshold. On the geometric-`S3` bottom stratum,

\[
 \delta_n\le 12+6(n-4)=6n-12,
\]

so normalization supplies a witness once

\[
 q+1-2\sqrt q>6n-12.
\]

The first sufficient integer is

\[
 Q_n^{\rm gen}
 =\left\lfloor\left(1+\sqrt{6n-12}\right)^2\right\rfloor+1.
\]

Equivalently,

\[
 Q_n^{\rm gen}=6n-10+\left\lfloor2\sqrt{6n-12}\right\rfloor,
\]

so the generic arithmetic threshold grows linearly with redundancy, with only a square-root
correction.

This is a genuine generic-stratum corollary, but not an all-redundancy deep-hole theorem: the
contained cyclic/wild/nucleus pullbacks and their transverse degrees remain level-specific.

The redundancy-nine modular preview can also be sharpened. The characteristic-five lift is the
single point `P<e4>` and is shallow over every characteristic-five field larger than `F5`:
homogenize `t^5-t` with its infinity root and multiply by `t-a` for any `a` outside `F5`; the
resulting split septic has `d3=d4=0`, exactly the two `e4` Hankel equations.

The characteristic-seven lift

\[
 \mathbf P\langle e_2,e_3,e_4,e_5,e_6\rangle
\]

is qualitatively different. As a `PGL2`-module it is
`det^2 tensor Sym^4(E)`, so projectively it is the binary-quartic representation underlying C491.
There is no universal split witness for the whole four-space: simultaneous annihilation forces
`d1=...=d6=0`, leaving `d0+d7*t^7`, a seventh power in characteristic seven. Thus the next modular
problem has inherited quartic invariant geometry—discriminant, `j`, and cyclic/wild/`S3` strata—
rather than being a featureless large nucleus. This is the strongest cheap successor exposed by
C513.

This is the `p=7` member of an exact prime-diagonal series. In characteristic `p`, the top
osculating nucleus of the degree-`p` NRC has support
`<e1,...,e_(p-1)>`, because every interior binomial coefficient `binom(p,j)` vanishes modulo `p`.
The consecutive-row lift to syndrome degree `p+1` has support

\[
 \mathbf P\langle e_2,\ldots,e_{p-1}\rangle
 \cong \mathbf P(\det^2\otimes\operatorname{Sym}^{p-3}E).
\]

Simultaneous annihilation by this entire module forces the split-member coefficients
`d1=...=d_(p-1)=0`; its common Hankel kernel is only
`<X^p,Y^p>`, a `p`-th-power pencil. Hence no prime-diagonal module admits a universal squarefree
witness: its modular arithmetic must be resolved orbitwise.

For `p=3` this is C491's fixed nucleus point; for `p=5` it is a binary-quadratic projective plane
inside the redundancy-seven geometry, whose nonpersistent part is shallow in C509's high-field
range; for `p=7` it is the binary-quartic four-space above. The increasing invariant degree
explains why modular containment becomes structurally richer with redundancy. It also predicts
that any characteristic-seven wild enlargement should be sought as a carrier built over quartic
discriminant/monodromy strata, paralleling—but not assuming—the characteristic-three nucleus/wild
cone.

### Third-order extra juice

The two preceding patterns combine into a useful two-spine decomposition of the higher-redundancy
problem.

The generic spine is already uniform. For syndrome degree `n`, its sufficient integer threshold is

\[
 Q_n^{\rm gen}
 =6n-10+\left\lfloor2\sqrt{6n-12}\right\rfloor,
\]

so the generic field requirement grows linearly, not exponentially, with redundancy. The bottom
geometric monodromy is always the same cubic `S3` ordered-pair cover; only marker deletion grows.

The modular spine occurs on the prime diagonal: in characteristic `p`, at redundancy `p+2`, the
polar lift is

\[
 \mathbf P(\det^2\otimes\operatorname{Sym}^{p-3}E).
\]

This family has a uniform obstruction to any one-size-fits-all split witness. Simultaneous
annihilation by every syndrome in the lift forces

\[
 d_1=\cdots=d_{p-1}=0,
\]

so the common kernel is the pencil

\[
 \langle x^p,y^p\rangle.
\]

Over a finite field every member is a `p`-th power and hence is not squarefree. Thus modular
containment must be analyzed orbitwise; a universal witness cannot dispose of the whole carrier.
This explains structurally why the `p=3` nucleus, `p=5` quadratic plane, and `p=7` quartic
four-space behave differently even though they belong to one representation-theoretic series.

At the diagonal field `q=p=7`, the quartic mystery closes completely. There are only eight split
squarefree binary septics, one for each complement of a point `r` in `P1(F_7)`. Dividing the
degree-eight Moore form `X^7Y-XY^7` by the linear factor at `r` and applying the Hankel pairing
gives

\[
 g_r\in W_f\quad\Longleftrightarrow\quad h(r)=0.
\]

Hence the modular carrier is deep exactly when its binary quartic `h` has no rational root.
There are `2801` projective binary quartics, of which exactly `819` are rootless and deep; the
remaining `1982` are shallow. The count follows independently by inclusion--exclusion on the eight
evaluation hyperplanes:

\[
 \frac1{6}\sum_{k=0}^4(-1)^k\binom8k(7^{5-k}-1)=819.
\]

For `q=7^m` with `m>1`, a rational root still supplies an `F_7`-subline witness, so rootlessness is
necessary for modular deepness. It is not yet proved sufficient: larger fields have many split
septics not arising as complements inside an `F_7`-subline.

### Fourth- and fifth-order extra juice

Rootlessness already ceases to be sufficient at `q=49`. Write

\[
 \mathbf F_{49}=\mathbf F_7(\tau),\qquad \tau^2=3,\qquad \nu=\tau+3.
\]

The norm of `nu` is the nonsquare `6`, so `h=(t^2-\nu)^2` is rootless. Nevertheless

\[
 g=(t^5-t)(t^2+5)
\]

is a split squarefree septic in its Hankel kernel. Exact field arithmetic gives disjoint root sets
`{0,1,6,21,28}` and `{3,4}` in the certificate encoding; in particular, the residual roots
`plus-or-minus3` are not roots of `t^5-t`. The first Hankel row vanishes termwise and the second is
`2nu^2+2nu+5=0`.

This witness extends to an infinite family. Let `q=7^(2m)`, let `chi` be the quadratic character,
and take `h_nu=(t^2-\nu)^2` with `nu` nonsquare. The residual quadratic forced by the fixed split
quintic `t^5-t` is

\[
 t^2+\frac{2\nu}{\nu^2-1}.
\]

It splits without collision exactly when `chi(nu^2-1)=-1`. The successful-parameter count is

\[
 N_q=\frac{\#E(\mathbf F_q)}4
 =\frac{7^{2m}+1-2(-7)^m}{4},
 \qquad E:y^2=x^3-x.
\]

Thus q=49 already has sixteen rootless shallow quartics on this slice. Quartic root type is not the
persistent invariant.

### Tao audit

The correct object is the residual-quadratic discriminant cover, not a root-type census. For the
fixed quintic `P=t^5-t`, put

\[
 A=a_2-a_6,\qquad B=a_5,\qquad C=a_3,\qquad E=a_4.
\]

Writing the residual quadratic as `t^2-s t+u`, the Hankel equations are

\[
 \begin{pmatrix}A&B\\ C&-A\end{pmatrix}
 \binom{s}{u}=\binom{C}{E}.
\]

Off `D=A^2+BC=0`,

\[
 s=\frac{AC+BE}{D},\qquad
 u=\frac{C^2-AE}{D},
\]

and splitting is controlled by

\[
 K=(AC+BE)^2-4(C^2-AE)(A^2+BC).
\]

The fixed quintic is only one point of `M_0,5`. Letting the five roots vary gives, for every quartic
`h`, a quadratic cover

\[
 Z_h\longrightarrow\operatorname{Conf}_5(\mathbf P^1).
\]

A rational point off the determinant, collision, and diagonal divisors is exactly a split
squarefree septic witness. The non-census route is therefore:

1. prove geometric integrality of `Z_h` on the generic quartic stratum and apply a point-count
   bound;
2. classify the quartic orbits where the discriminant becomes square, zero, or reducible; and
3. treat only those exceptional orbit families arithmetically.

The unexplained possibility is a quartic orbit on which every residual-discriminant cover
degenerates. No present evidence shows that such an orbit exists.

This does not prove an all-redundancy classification. It isolates the two reusable components:
uniform generic splitting and prime-diagonal modular invariant theory. Other cyclic/wild contained
pullbacks still require their own scheme-theoretic exclusion.

## Mystery ledger

Settled:

- **Does the predicted threshold survive exact arithmetic?** It improves. The deletion degree is
  bounded by 30, C512's closed integer threshold is 44 with first prime power 47, but the exact
  normalized Hasse inequality starts at integer 42 and first prime power 43.
- **Does the characteristic-two central family lift again?** No. Its consecutive-row preimage is
  zero.
- **Do other NRC nuclei create new modular families?** They create two candidate projective lines,
  but the characteristic-five line has a universal split witness and the characteristic-three line
  is shallow from `q=27` onward.
- **Does the persistent exponent advance as forecast?** Yes: it is `T/T^7`, with tangent splitting
  exactly in characteristic seven. The extra-juice pass also settles the exact `PGammaL2` fusion:
  the three nonzero sigma classes remain separate for `p=plus-or-minus 1 mod 7` and otherwise fuse;
  the resulting total projective/semilinear orbit counts are `2/2`, `3/3`, `5/5`, or `5/3`.
- **Why does modular complexity recur at selected redundancies?** The prime-diagonal series
  identifies the carrier at redundancy `p+2` as
  `P(det^2 tensor Sym^(p-3) E)`. Its common kernel is the `p`-th-power pencil
  `<x^p,y^p>`, proving that no universal squarefree witness can collapse the carrier. At `p=q=7`,
  the carrier is deep exactly on the `819` rootless projective binary quartics. At q=49 the exact
  disjoint-root witness disproves larger-field rootless sufficiency, and the CM count extends it to
  an infinite even-extension shallow family.

Open:

- **What happens below 43?** No bounded census or exceptional normal-form theorem was attempted.
  Evidence gap: exact orbit-reduced classification over prime powers below the theorem threshold;
  owner: a separately allocated bounded companion, if desired.
- **Is 43 sharp?** The proof gives a sufficient threshold. Evidence gap: the actual normalized
  three-marker curve and overlap-corrected deletion count on every stratum; owner: a threshold-
  sharpening successor, not the present classification.
- **Does the lower identity twist admit a uniform all-marker genus formula beyond this level?**
  The Tao pass narrows the question: the generic standard-PRS spine always bottoms out in the same
  genus-at-most-one cubic `S3` cover with deletion bound `6n-12`. The remaining evidence gap is
  uniform control of recursive cyclic/wild/nucleus carrier pullbacks, not generic `S3` monodromy.
- **What happens to the new redundancy-nine nucleus lifts?** The next Lucas calculation produces
  a characteristic-five point and a characteristic-seven projective four-space. The second-order
  pass settles the characteristic-five point as shallow and identifies the characteristic-seven
  space with the binary-quartic representation, while proving that it has no universal split
  witness. The higher-order passes close q=7 and a CM-controlled infinite shallow slice.
  Evidence gap: geometric integrality and exceptional-orbit classification for the
  residual-quadratic cover over `Conf_5(P1)`, together with containment in the four-marker lower
  bad carrier; owner: a future fixed-redundancy-nine application.
