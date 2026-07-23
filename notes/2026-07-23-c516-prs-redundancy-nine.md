# C516 — PRS(q−8) redundancy-nine residual-quadratic theorem

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete high-field
deep-syndrome and projective-semilinear orbit classification

## Result

For every prime power `q >= 53`, the deep syndromes of `PRS(q-8)` are exactly the persistent
catalecticant rank-two tangent and conjugate-sigma families. Their total number is

\[
 \frac{q(q+1)^2}{2}.
\]

The complete orbit law is

\[
 T/T^8\quad\text{modulo inversion and coefficientwise Frobenius}
\]

on the sigma family, and

\[
 u\star z=z+8u
\]

on the tangent family. Thus characteristic two, and only characteristic two, splits the tangent
family into fixed and nonzero orbits.

The characteristic-seven prime-diagonal carrier is completely resolved. At `q=7` it is deep
exactly on the `819` rootless projective binary quartics. At `q=49` every one of its `5,884,901`
projective quartics has a split squarefree septic witness. For every `q=7^m >=343`, the
residual-quadratic component theorem and Hasse--Weil give such a witness uniformly. Hence the
carrier has no deep point for any characteristic-seven field except the stated `819` points at
`q=7`.

No ambient `PG(8,q)` census enters the high-field theorem. The q=49 closure is a separate exact
enumeration of the five-dimensional modular carrier after the component theorem is proved.

## 1. Four-marker generic spine

For a degree-eight syndrome `f`, contraction through four distinct marked roots reaches the same
geometric-`S3` cubic ordered-pair cover used by C491--C513. The cover and its normalization are
unchanged; the fourth marker adds one more six-point incidence deletion. Therefore

\[
 \delta=12+4\cdot6=36.
\]

The exact normalization inequality is

\[
 q+1-2\sqrt q>36.
\]

Its first integer solution is `q=50`, and its first prime-power solution is `q=53`.

The first-polar line meets the lower persistent catalecticant carrier in degree at most three.
The characteristic-specific lower nucleus loci are linear, so their total transverse contribution
is at most two more points. The moving `g^5_7` has ramification degree

\[
 (5+1)(7-5)=12.
\]

Thus the transverse/collision budget is at most `3+2+12=17`, well below 53. If the polar line is
not contained in a lower bad carrier, C512 and the four-marker package produce a split squarefree
septic in the Hankel kernel.

## 2. Exact residual-quadratic normal form

On the characteristic-seven consecutive lift, write the syndrome as the binary quartic

\[
 h=(a_0,a_1,a_2,a_3,a_4)
\]

in the projective carrier

\[
 \mathbf P\langle e_2,e_3,e_4,e_5,e_6\rangle
 \cong\mathbf P(\det^2\otimes\operatorname{Sym}^4E).
\]

Let

\[
 P(t)=p_0+p_1t+\cdots+p_5t^5
\]

be a split squarefree quintic and seek a residual quadratic

\[
 Q(t)=t^2-st+u.
\]

Put

\[
 H_j=\sum_{i=0}^4a_i p_{i+j},\qquad p_k=0\ \text{outside }0\le k\le5.
\]

The two Hankel equations for `P Q` are exactly

\[
 H_0-sH_1+uH_2=0,\qquad
 H_{-1}-sH_0+uH_1=0.
\]

Consequently

\[
\begin{aligned}
 D&=H_0H_2-H_1^2,\\
 N_s&=H_{-1}H_2-H_0H_1,\\
 N_u&=H_{-1}H_1-H_0^2.
\end{aligned}
\]

Off `D=0`, the unique residual quadratic is

\[
 D t^2-N_s t+N_u,
\]

and its branch polynomial is

\[
 K=N_s^2-4N_uD.
\]

This gives all requested divisors without coordinate ambiguity:

- determinant divisor `D=0`;
- residual double-root divisor `K=0`;
- fixed-root diagonal `Disc(P)=0`;
- fixed/residual collision divisor
  \[
  \operatorname{Res}_t(P,D t^2-N_s t+N_u)=0.
  \]

The formulas commute with `PGL2`, scalar change, and Frobenius because they are consecutive
Hankel minors and a resultant.

## 3. Component theorem on the binary-quartic quotient

Fix four distinct roots `R` and write `P=R(t)(t-x)`. Then

\[
 \deg_xD,\deg_xN_s,\deg_xN_u\le2,\qquad \deg_xK\le4.
\]

Thus the normalized residual cover

\[
 C_{h,R}:\quad y^2=K_{h,R}(x)
\]

has genus at most one after square factors are removed.

The component classification is exact over the algebraic closure of characteristic seven.

For a squarefree quartic, use the standard even normal form

\[
 h_L=[1,0,L,0,1].
\]

For the six four-root bases

\[
\{0,1,2,3\},\{0,1,2,4\},\{0,1,2,5\},\{0,1,2,6\},
\{0,1,3,4\},\{1,2,3,4\},
\]

the six quartic discriminants have gcd `1` in
\(\mathbf F_7[L]\). Hence every squarefree quartic has a geometrically integral separable slice.

The four multiple-root normal forms also have integral reduced slices:

| Root partition | Fixed roots | Reduced branch degree | Reduced discriminant |
|---|---:|---:|---:|
| `4` | `{1,2,3,4}` | `2` | `3` |
| `3+1` | `{0,2,4,6}` | `2` | `3` |
| `2+2` | `{0,1,2,3}` | `3` | `1` |
| `2+1+1` | `{0,1,2,3}` | `4` | `5` |

All entries are in `F_7`. Therefore:

> **Binary-quartic component theorem.** Every nonzero geometric binary quartic has a four-root
> slice whose reduced residual-quadratic cover is geometrically integral of genus at most one.
> There is no exceptional quartic orbit. The only exceptions are the explicit divisors inside a
> chosen slice: determinant, branch, diagonal, and fixed-root collision.

This corrects the tempting but invalid shortcut of fixing both a quartic normal form and three
quintic roots simultaneously. Those use the same `PGL2`; the quotient must retain their diagonal
transporter. The six-slice calculation respects that quotient.

## 4. Uniform characteristic-seven arithmetic

For fixed `h`, the bad-base discriminant is a nonzero polynomial in the four ordered base roots.
It has degree at most `24` in each root and total degree at most `96`. Multiplying by the
four-root Vandermonde adds degree six. Hence, when `q>102`, affine Schwartz--Zippel leaves a
distinct rational four-root base with a geometrically integral reduced cover. The first
characteristic-seven field in this range is `q=343`.

On that curve the deletion degrees are:

\[
\begin{array}{c|c}
\text{divisor}&\text{degree}\\\hline
\text{moving/fixed diagonal}&4\\
D=0&2\\
K=0&4\\
Q\text{ through one of four fixed roots}&8\\
Q\text{ through the moving root}&4.
\end{array}
\]

The total is at most 22. Since

\[
 q+1-2\sqrt q>22
\]

for every `q>=33`, the base-selection bound dominates. Every quartic in the modular carrier is
therefore shallow for `q=7^m>=343`.

At `q=7`, the only split squarefree septics are complements of one point of `P1(F_7)`, so C513's
evaluation identity gives deepness exactly when `h` has no rational root. Inclusion--exclusion
gives `819`.

At `q=49`, the exact carrier closure enumerates all

\[
 (49^5-1)/48=5,884,901
\]

projective quartics. It tests split quintics in lexicographic order and solves the displayed
two-by-two residual system. After `194,584` quintics no quartic survives. The last survivor is the
pure quartic `[1,0,0,0,0]`; it persists while every tested quintic contains zero and disappears at
roots `{1,2,3,4,8}`. This explains the long plateau and confirms that it was a base-choice
artifact, not an exceptional component.

The three possible characteristic-seven field ranges are now exhaustive: `7`, `49`, and
`q>=343`.

## 5. Other modular lifts

The degree-seven top nuclei have consecutive degree-eight lifts only in characteristics five and
seven:

\[
\begin{array}{c|c|c}
p&\text{degree-seven support}&\text{degree-eight lift}\\\hline
5&\langle e_3,e_4\rangle&\langle e_4\rangle\\
7&\langle e_1,\ldots,e_6\rangle&\langle e_2,\ldots,e_6\rangle.
\end{array}
\]

The characteristic-five point is shallow over every `q>5`: multiply the split sextic obtained
from `t^5-t` and its infinity root by `t-a` with `a` outside `F_5`. The resulting split septic has
coefficients `d_3=d_4=0`, exactly the two `e_4` Hankel equations. The characteristic-seven row is
the carrier resolved above. No other modular contained flag occurs.

## 6. Persistent orbit classification

Put

\[
 d=\gcd(8,q+1).
\]

Sigma orbits are inversion-orbits in `C_d`. An inversion-fixed class has

\[
 (|O|,|\operatorname{Stab}|)
 =\left(\frac{q(q^2-1)}{2d},2d\right),
\]

and a paired class has

\[
 (|O|,|\operatorname{Stab}|)
 =\left(\frac{q(q^2-1)}d,d\right).
\]

For `d=1,2,4,8`, the numbers of sigma `PGL2` orbits are respectively `1,2,3,5`.
Coefficientwise Frobenius acts by multiplication by the characteristic on `C_d`, modulo
inversion. It changes nothing for `d<=4`. For `d=8`, it leaves all five classes separate when
`p=plus-or-minus1 mod 8`, and swaps the two odd nontrivial pairs when
`p=plus-or-minus3 mod 8`, leaving four semilinear sigma orbits.

In odd characteristic the tangent family is one orbit of size `q(q+1)` with stabilizer `q-1`.
In characteristic two it splits into

\[
 (q+1,q(q-1))\quad\text{and}\quad(q^2-1,q).
\]

Thus the total `PGL2/PGammaL2` deep-syndrome orbit counts are:

\[
\begin{array}{c|c|c}
\text{case}&PGL_2&P\Gamma L_2\\\hline
d=1,\ p\ne2&2&2\\
p=2&3&3\\
d=2&3&3\\
d=4&4&4\\
d=8,\ p\equiv\pm1\pmod8&6&6\\
d=8,\ p\equiv\pm3\pmod8&6&5.
\end{array}
\]

The sigma family has `q(q^2-1)/2` points and the tangent family has `q(q+1)`, giving the stated
total.

## Literature boundary

The claim-specific audit `2026-07-23-c516-prs-redundancy-nine-literature-audit.md` finds no
pre-emption, subject to its explicit MathSciNet and same-day refresh limitations. Classical
binary-quartic invariant theory, NRC nuclei, Hasse--Weil, factorization statistics, and C512's
coherent induction theorem are inputs rather than novelty claims.

## Evidence and replay

The compact theorem certificate is:

- `2026-07-23-c516-prs-redundancy-nine.py`;
- `2026-07-23-c516-prs-redundancy-nine.json`;
- `2026-07-23-c516-prs-redundancy-nine-replay.py`.

The q=49 closure is:

- `2026-07-23-c516-prs-redundancy-nine-q49.rs`;
- `2026-07-23-c516-prs-redundancy-nine-q49.txt`.

From the repository root:

```text
python3 notes/2026-07-23-c516-prs-redundancy-nine.py \
  --output notes/2026-07-23-c516-prs-redundancy-nine.json --check
python3 notes/2026-07-23-c516-prs-redundancy-nine-replay.py
rustc -O notes/2026-07-23-c516-prs-redundancy-nine-q49.rs -o /tmp/c516-q49
diff <(/tmp/c516-q49) notes/2026-07-23-c516-prs-redundancy-nine-q49.txt
(cd notes && sha256sum -c 2026-07-23-c516-prs-redundancy-nine.sha256)
```

The Python generator derives the residual minors, all six normal-family discriminants, their
unit gcd, the multiple-root reduced covers, nucleus lifts, thresholds, q=7 count, and orbit table.
The independent Python replay uses a separate `F_49` implementation and dense polynomial
arithmetic; evaluation at all 49 values of `L` certifies each recorded degree-at-most-24
discriminant polynomial, and it independently checks the residual equations, thresholds, q=7
inclusion--exclusion, and Frobenius fusion.

The Rust q=49 pass is exhaustive but has no second exhaustive implementation. Its trusted boundary
is deliberately narrow: standard-library finite-field arithmetic, all canonical projective
five-vectors, lexicographic five-subsets of the 49 finite points, and the independently replayed
residual formula. A second 5.9-million-vector implementation would duplicate the only expensive
step without strengthening the algebraic component theorem; the source, compact output, and exact
rerun are committed.

## Extra-juice closeout

The first extra-juice pass replaces the anticipated high-dimensional cover by a genus-at-most-one
fibration: four fixed roots leave a quartic branch polynomial in the fifth root. This is why a
fully explicit uniform characteristic-seven proof is possible.

The second pass exposes a unit gcd across six binary-quartic normal slices. Therefore there is no
exceptional quartic orbit at all; every apparent degeneration is a choice-of-slice divisor.

The third pass closes the only missing characteristic-seven field. The q=49 carrier has no deep
point, and the last survivor is the pure quartic only because the lexicographic quintics initially
all contain its distinguished root.

The fourth pass completes the exponent-eight semilinear law. Since `d` divides eight, Frobenius
fusion has only one nontrivial case: at `d=8`, characteristics `plus-or-minus3 mod 8` merge the two
odd inversion classes. No field-by-field orbit census is needed.

The fifth pass identifies a reusable fixed-level pattern. Whenever the residual factor is
quadratic, fixing all but one marker reduces the arithmetic to genus at most one; the level-specific
work is then the invariant-theoretic proof that the finite set of normal slices has unit
discriminant gcd. This is a genuine method for a future quadratic-residual level, not an
all-redundancy theorem.

## Mystery ledger

Settled:

- **Could a quartic orbit make every residual cover degenerate?** No. Six squarefree normal slices
  have unit discriminant gcd, and each multiple-root normal form has an explicit integral reduced
  slice.
- **Was the q=49 rootless family evidence for a surviving modular component?** No. Every one of
  the `5,884,901` projective quartics is shallow. Rootlessness stops being sufficient immediately
  after `q=7`.
- **Why did one q=49 survivor persist through almost the entire `0`-root block?** It is the pure
  quartic `[1,0,0,0,0]`. Quintics through zero force the wrong residual degeneration; the first
  tested block avoiding zero supplies a witness.
- **Does the characteristic-five lift contribute?** No for every `q>5`; the
  `(t^5-t)(t-a)` witness closes it uniformly.
- **Does the generic threshold advance as forecast?** Yes. Four markers give deletion 36 and first
  prime-power threshold 53.
- **What is the exact semilinear orbit law?** `T/T^8` modulo inversion/Frobenius, with total
  counts `2/2`, `3/3`, `4/4`, `6/6`, or `6/5`, plus the characteristic-two tangent split.

Open:

- **What additional deep orbits occur for non-modular syndromes below 53?** C516 does not perform
  a bounded ambient classification. Evidence gap: orbit-reduced analysis of the transverse
  geometric-`S3`, cyclic, and wild lower strata for prime powers below 53. Owner: a separately
  allocated bounded companion, if desired.
- **Is 53 sharp?** It is the first prime power satisfying the uniform four-marker Hasse bound, not
  a necessity threshold. Evidence gap: overlap-corrected deletion divisors on every lower stratum.
- **Can the six-slice unit-gcd method be made uniform for higher residual degree?** Not from this
  result. The quadratic residual is essential to the genus-one reduction; higher residual degree
  requires its own monodromy and genus calculation.
