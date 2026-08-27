# C973 checkpoint — family-wise NMDS minimum-support counts

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** exact structural
reduction and aggregate theorem proved; arbitrary-deletion per-column counts
reduce to finite character transforms

## 1. Statistic and coding meaning

Put

\[
 m=r-1,qquad N=|S|=q+1-s,qquad S=\mathbf P^1(\mathbf F_q)\setminus A.
\]

For a projective NMDS extension column `f`, define

\[
 \mu_S(f)=\#\{T\subset S:|T|=m,\ f\in\langle\nu_m(T)\rangle\}.       \tag{1}
\]

Every `m` retained NRC columns are independent.  Consequently each set in
(1) gives one dependence on `T union {f}`, unique up to a nonzero scalar, and
minimality forces every coefficient to be nonzero.  Therefore

\[
                    A_r(\widehat C_f)=(q-1)\mu_S(f).       \tag{2}
\]

Thus `mu_S(f)` is not merely a representation count: it is the one free
parameter in the complete NMDS weight enumerator.  If `L=N+1` and
`K=L-r`, the standard NMDS relation gives, for `1<=i<=K`,

\[
\begin{split}
A_{r+i}(\widehat C_f)
={}&\binom{L}{K-i}
 \sum_{j=0}^{i-1}(-1)^j\binom{r+i}{j}(q^{i-j}-1)\\
 &+(-1)^i\binom K i A_r(\widehat C_f).                    \tag{3}
\end{split}
\]

Meneghetti--Pellegrini--Sala, arXiv:2003.14063, Theorem 10, records this NMDS
weight-distribution relation.  The C973 work below is the geometric evaluation
of its input `mu_S(f)` for the C973 extension families.

## 2. Exact aggregate theorem

Assume the large-characteristic C973 top-shell hypotheses, so the NMDS
projective columns are exactly the tangent, conjugate-secant, and
`A`-incident split-secant points.  Then

\[
\boxed{\begin{aligned}
\sum_{f\in\mathrm{Tan}}\mu_S(f)
  &=(q+1-m)\binom Nm,\\
\sum_{f\in\mathrm{Conj}}\mu_S(f)
  &=\frac{q(q-1)}2\binom Nm,\\
\sum_{f\in\mathrm{Split}_A}\mu_S(f)
  &=\left[\binom s2+s(N-m)\right]\binom Nm.
\end{aligned}}                                                   \tag{4}
\]

Multiplying any line of (4) by `q-1` gives the corresponding aggregate number
of minimum-weight codewords over the family of one-column extensions.  In
particular,

\[
 \sum_{f:\,d_S(f)=m}A_r(\widehat C_f)
 =(q-1)\left[q+1-m+\frac{q(q-1)}2+\binom s2+s(N-m)\right]
 \binom Nm.                                                       \tag{5}
\]

This determines more than the aggregate minimum coefficient.  Define

\[
 B_i=\binom{L}{K-i}
 \sum_{j=0}^{i-1}(-1)^j\binom{r+i}{j}(q^{i-j}-1).
\]

If `F` is any one of the three projective extension families, `M_F=|F|`, and
`I_F` is the corresponding right-hand side of (4), then (2)--(3) give

\[
 \sum_{f\in F}A_{r+i}(\widehat C_f)
 =M_F B_i+(-1)^i\binom K i(q-1)I_F.                       \tag{5a}
\]

Thus (4) determines the complete family-aggregate NMDS weight enumerator, not
only its minimum-weight term.  Dividing by the already known family sizes
also gives the exact family-average enumerator.  For reference, the average
support multiplicities are

\[
\begin{aligned}
 \overline\mu_{\mathrm{Tan}}
   &=\frac{(q+1-m)\binom Nm}{q(q+1)},\\
 \overline\mu_{\mathrm{Conj}}
   &=\frac{\binom Nm}{q+1},\\
 \overline\mu_{\mathrm{Split}_A}
   &=\frac{\binom s2+s(N-m)}{(q-1)(\binom s2+sN)}\binom Nm
   \quad(s>0).                                             \tag{5b}
\end{aligned}
\]

### Double-counting proof

For each `T` in `binom(S,m)`, its NRC columns span a rational hyperplane
`H_T`.

* On the tangent line at `a`, the intersection `H_T` is the curve point `a`
  when `a in T`, and is one off-curve tangent point when `a notin T`.  Hence
  each `T` contributes to exactly `q+1-m` tangent extension columns.
* Every conjugate pair in
  `P1(F_(q^2)) minus P1(F_q)` determines a rational conjugate secant.  It is
  not contained in `H_T`, because the split form defining `H_T` cannot vanish
  at either nonrational endpoint.  Thus it meets `H_T` in exactly one rational
  point.  There are `q(q-1)/2` conjugate pairs.
* A secant through two omitted points meets `H_T` in an interior point for
  every `T`, contributing `binom(s,2)` choices.  For a pair consisting of one
  omitted and one retained point, the intersection is interior exactly when
  the retained endpoint is not in `T`.  There are `s(N-m)` such pairs.

Summing these constant numbers over the `binom(N,m)` choices of `T` proves
(4).  This proof uses no character sums and is independent of the placement
of the deletion set `A`.

## 3. Why there is no single per-family number

Formula (4) is family-aggregate.  Individual columns in one geometric family
can have different values of `mu_S(f)`.  The exact invariant is additive for
tangents and multiplicative for both secant types.

For a finite abelian group `G`, a subset `U subset G`, and a target `tau`, put

\[
 E_m(U;\tau)=\#\{T\subset U:|T|=m,\ \prod_{t\in T}t=\tau\}.
\]

Character orthogonality gives the exact transform

\[
 E_m(U;\tau)=\frac1{|G|}\sum_{\chi\in\widehat G}
 \chi(\tau^{-1})[z^m]\prod_{u\in U}(1+z\chi(u)).           \tag{6}
\]

For an additive group, replace the product target by a sum target `sigma` and
`chi(tau^-1)` by `psi(-sigma)`.  Equation (6) is also an `O(m|U||G|)` dynamic
program for all targets simultaneously, rather than an enumeration of
`binom(|U|,m)` supports.

The three geometric reductions are as follows.

### Tangent columns

Send the tangent base point `a` to infinity and write the other points in an
affine coordinate `x`.  The `q` off-curve points of the tangent line are
parametrized by `sigma in F_q`.  The hyperplane polynomial of `T` is monic,
and the tangent condition reads

\[
                    \sum_{t\in T}x(t)=\sigma.              \tag{7}
\]

The support cannot contain `a`.  Hence `U=x(S minus {a})`, and `mu_S(f)` is
the additive version of (6).

### Split-secant columns

Let the endpoints be `a,b`, with at least one in `A`.  A cross-ratio
coordinate identifies `P1(F_q) minus {a,b}` with `F_q^*`.  The `q-1`
interior points of the secant are parametrized by `tau in F_q^*`, and the
hyperplane condition is

\[
                    \prod_{t\in T}x_{a,b}(t)=\tau.         \tag{8}
\]

Any valid support automatically avoids both endpoints.  Thus
`U=x_(a,b)(S minus {a,b}) subset F_q^*`, and (6) gives `mu_S(f)`.

### Conjugate-secant columns

For a conjugate pair `alpha,alpha^q`, use the Cayley bijection

\[
 x_\alpha(t)=\frac{t-\alpha}{t-\alpha^q}:
 \mathbf P^1(\mathbf F_q)\longrightarrow
 \mathbb T_{q+1}=\{u\in\mathbf F_{q^2}^*:u^{q+1}=1\}.      \tag{9}
\]

Write the rational secant point as
`f=lambda nu(alpha)+lambda^q nu(alpha^q)`.  Pairing its hyperplane form gives

\[
 \prod_{t\in T}x_\alpha(t)=-\lambda^{q-1}=:\tau_f.        \tag{10}
\]

Therefore `mu_S(f)=E_m(x_alpha(S);tau_f)` in the cyclic norm-one torus.
This is exactly the torus invariant already exposed by the C969 sigma
canonicalizer.

Changing coordinates changes `U` and the target together and leaves the
count invariant.

## 4. Closed formulas for full projective and full affine support

Let `G=C_Q=<g>` be cyclic, write `tau=g^k`, and let `c_d(k)` be the Ramanujan
sum.  For the full group, (6) becomes

\[
 P_{Q,m}(g^k)=\frac1Q
 \sum_{d\mid\gcd(Q,m)}
 (-1)^{(d+1)m/d}\binom{Q/d}{m/d}c_d(k).                  \tag{11}
\]

Indeed, a character of order `d` contributes

\[
 [z^m](1-(-z)^d)^{Q/d},
\]

which vanishes unless `d` divides `m`; summing the characters of exact order
`d` produces `c_d(k)`.

For `G minus {1}` and `0<=m<Q`, the corresponding exact formula is

\[
 P^\circ_{Q,m}(g^k)=\frac1Q\sum_{d\mid Q}
 (-1)^{m+\lfloor m/d\rfloor}
 \binom{Q/d-1}{\lfloor m/d\rfloor}c_d(k).                \tag{12}
\]

This follows by dividing the character generating polynomial by `1+z`.

### Full projective support (`s=0`)

Because `p>m`, the nontrivial additive-character terms have zero `z^m`
coefficient.  Hence every tangent column has

\[
                     \mu(f)=\frac1q\binom qm.             \tag{13}
\]

For a conjugate-secant column,

\[
                     \mu(f)=P_{q+1,m}(\tau_f).            \tag{14}
\]

In particular, (14) is uniform and equals
`binom(q+1,m)/(q+1)` whenever `gcd(m,q+1)=1`; otherwise the Ramanujan term
records the torus-orbit variation.

### Full affine support (`A={infinity}`)

On the tangent at the omitted point, (13) still holds.  At a retained tangent
base, send that base to infinity and the omitted point to zero.  If `delta_f`
is the resulting additive target, then

\[
 \mu(f)=\frac1q\left[\binom{q-1}{m}+(-1)^m v(\delta_f)\right],
 \quad
 v(0)=q-1,\quad v(\delta\ne0)=-1.                         \tag{15}
\]

Exactly one of the `q` off-curve points on that tangent has `delta_f=0`.

For an incident split secant and a conjugate secant, respectively,

\[
 \mu(f)=P_{q-1,m}(\tau_f),
 \qquad
 \mu(f)=P^\circ_{q+1,m}(\tau_f).                         \tag{16}
\]

Thus even the affine case is not generally constant inside a geometric
family.  The variation is controlled exactly by additive zero/nonzero type or
by the Ramanujan class of the torus parameter.

## 5. Exact software sanity check

The existing `projective-reed-solomon` finite-field arithmetic and
`recover_magnitudes` routine were used without modifying the software.  An
ephemeral exhaustive probe over `F_11` at `r=6` (`m=5`) compared the locator
criterion against (7)--(10):

| family/support | locator count | character-coordinate count |
|---|---:|---:|
| projective tangent, one target | 42 | `binom(11,5)/11=42` |
| affine split, `tau in {1,-1}` | 26 | 26 from (11) with `Q=10` |
| affine split, other `tau` | 25 | 25 from (11) with `Q=10` |
| projective conjugate, one target | 66 | `binom(12,5)/12=66` |
| affine conjugate, `tau=-1` | 38 | 38 from (12) with `Q=12` |

All comparisons agreed exactly.  This is bounded regression evidence only;
the proofs are the hyperplane reduction and character calculation above.  The
temporary Rust probe was removed, leaving no software-tree change.  The same
span tests and character-coordinate counts have an independent committed
replay:

```text
python3 notes/reed-solomon-tasks/c973-family-support-count-replay.py
```

It prints `C973 family minimum-support replay: PASS` after checking all rows
of the table.

## 6. Software follow-up interface

The high-value software addition is not brute-force support enumeration.  It
is a typed group-DP layer computing all targets on one rank-two line:

```text
RankTwoSupportProblem =
    Tangent(AdditiveTarget)
  | SplitSecant(MultiplicativeTarget)
  | ConjugateSecant(NormOneTarget)

MinimumSupportProfile {
    counts_by_target: Vec<ExactCount>,
    aggregate: ExactCount,
}
```

`AdditiveTarget`, `MultiplicativeTarget`, and `NormOneTarget` should be
distinct types, not strings or interchangeable field integers.  `ExactCount`
should be arbitrary precision (or checked with an explicit overflow result),
because the binomial counts quickly exceed `u64`.  The recurrence updates
subset size downward and group state by addition or multiplication, using
`O(m|G|)` memory and `O(m|U||G|)` operations.  This belongs to a separately
allocated software item, not to C973.

## 7. Literature and paper boundary

Distinct-subset sums over finite fields and their Reed--Solomon connection are
classical; Li--Wan, arXiv:0708.2456, is a direct source.  The fact that one
minimum coefficient determines an NMDS weight distribution is also prior art;
Meneghetti--Pellegrini--Sala, arXiv:2003.14063, gives a modern derivation.
Li--Sun--Zhu, arXiv:2401.04360, is adjacent recent work explicitly obtaining
NMDS weight distributions from subset-sum solutions.

No novelty is claimed for (6), (11), (12), or (3).  The candidate paper
contribution is the geometric identification (7)--(10) for all three C973
extension families and especially the configuration-free aggregate theorem
(4), which propagates by (5a) to the complete family-aggregate enumerator.  A
paper successor can add (4)--(5a) as one corollary after the shell count and
move the individual character formulas to an appendix or software note.  This
strengthens the theorem without creating a new narrative section.

## Mystery ledger

| mystery | status | next gate |
|---|---|---|
| Is `mu_S(f)` constant on a tangent/secant family? | no; already false for affine `F_11`, where split counts are 25 or 26 | state orbit/target dependence explicitly |
| Can every individual count be computed exactly? | yes; reduced to (6), with closed full/punctured formulas (11)--(16) | implement typed group DP only if software exposure is wanted |
| Is there a formula depending only on `q,r,s` for each individual column? | no in general; deleting points breaks the group symmetry and the count retains the transformed deletion set | retain `U` in theorem/API |
| Is there nevertheless a clean family theorem? | yes; the aggregate identities (4) are independent of deletion placement | claim-specific novelty audit |
| Does the minimum-support count determine the full NMDS enumerator? | yes, by (2)--(3) | cite the standard NMDS relation rather than reprove it in the main text |

The mathematical gate is closed at the exact-count level.  The remaining
gates are novelty audit, optional software packaging, and separate manuscript
integration.
