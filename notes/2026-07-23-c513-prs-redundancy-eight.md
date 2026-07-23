# C513 — PRS(q−7) redundancy-eight polar-induction theorem

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete high-field
deep-syndrome and projective-semilinear orbit classification

## Result

For every prime power `q >= 47`, the deep syndromes of `PRS(q-7)` are exactly the persistent
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
`q < 47`, and it uses no ambient `PG(7,q)` census.

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

Hasse--Weil on the normalization gives

\[
 \#Y(\mathbf F_q)\ge q-2\sqrt q.
\]

The inequality

\[
 q-2\sqrt q>30
\]

holds for every prime power `q >= 47`. Equivalently, C512's integer threshold is

\[
 \left\lfloor(1+\sqrt{31})^2\right\rfloor+1=44,
\]

whose first prime-power value is 47. Therefore every geometric-`S3` bottom fibre has a split
squarefree cubic avoiding all three markers.

The cyclic, wild, inseparable, gcd, and branch strata remain in the algebraic lower bad carrier
classified in C491--C512. The additional marker changes only the deletion divisor. It creates no
new contained component: the new consecutive-row and modular calculations are given below.
Consequently:

> **Three-marker pointed lemma.** For `q >= 47`, every nonpersistent C509 sextic outside its
> characteristic-two central component has a split squarefree quintic in its Hankel kernel
> avoiding any prescribed point, unless that point lies in the finite marked-collision divisor.

This is the lower splitting package required by C512 at `(m,s)=(6,1)`.

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

For `q >= 47`, choose a contraction parameter outside these at most fourteen points. The
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
characteristic on `C_7`, followed by inversion.

The tangent family is one orbit of size `q(q+1)` with stabilizer `q-1` when the characteristic is
not seven. In characteristic seven it splits into

\[
 (q+1,q(q-1))\quad\text{and}\quad(q^2-1,q).
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

> **Redundancy-eight theorem.** For every prime power `q >= 47`, the deep syndromes of
> `PRS(q-7)` are exactly the persistent tangent and conjugate-sigma catalecticant rank-two
> syndromes. Their number is `q(q+1)^2/2`; their complete `PGL2/PGammaL2` orbit law is
> `T/T^7` modulo inversion and Frobenius, together with tangent cocycle `u*z=z+7u`.

The theorem says nothing about which additional orbits occur for `q < 47`. A bounded exceptional
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
marker divisors. The generator, JSON certificate, and independent replay have exact byte counts
`5392`, `2427`, and `3027`, respectively; their SHA-256 hashes are in the adjacent manifest.

## Mystery ledger

Settled:

- **Does the predicted threshold survive exact arithmetic?** Yes. The deletion degree is exactly
  bounded by 30, C512's integer threshold is 44, and the first admissible prime power is 47.
- **Does the characteristic-two central family lift again?** No. Its consecutive-row preimage is
  zero.
- **Do other NRC nuclei create new modular families?** They create two candidate projective lines,
  but the characteristic-five line has a universal split witness and the characteristic-three line
  is shallow from `q=27` onward.
- **Does the persistent exponent advance as forecast?** Yes: it is `T/T^7`, with tangent splitting
  exactly in characteristic seven.

Open:

- **What happens below 47?** No bounded census or exceptional normal-form theorem was attempted.
  Evidence gap: exact orbit-reduced classification over prime powers below the theorem threshold;
  owner: a separately allocated bounded companion, if desired.
- **Is 47 sharp?** The proof gives a sufficient threshold. Evidence gap: the actual normalized
  three-marker curve and overlap-corrected deletion count on every stratum; owner: a threshold-
  sharpening successor, not the present classification.
- **Does the lower identity twist admit a uniform all-marker genus formula beyond this level?**
  Marker deletion leaves genus unchanged here, but a uniform theorem for every residual carrier
  still needs the arbitrary-degree monodromy theorem identified by C512.
