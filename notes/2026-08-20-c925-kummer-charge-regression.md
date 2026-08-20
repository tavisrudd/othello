# Module 38. Kummer charge regression and the stationary polygon obstruction

**Packet part:** Module 38.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** split-pilot charge trace and stationary-polygon obstruction
proved; the arbitrary relative-cap Stokes lift remains open

## 38.1 Three objects which must not be conflated

The charge audit involves three different levels.

1. The split-nef point period is an actual mirror-theoretic solution.
2. Its finite exponential support records the formal large-\(R\) branches.
3. The negative-line-degree series is a hostile formal substitution used to
   test a proposed relative-cap argument.  No audited degeneration theorem
   identifies it with an actual relative-cap Stokes factor.

The third level may falsify a provider, but it cannot verify one.

## 38.2 The actual split pilots have no exceptional point coefficient

For a codimension-two complete intersection of degrees \(1\le a\le b\), the
fixed-base-degree exceptional slice is

\[
G_d(R)
=C_d\,{}_1F_1\!\left(bd+1;(b-a)d+1;R\right),
\tag{38.1}
\]

where \(C_d\ne0\) is independent of \(R\).  Kummer transformation gives

\[
G_d(R)
=C_d e^R
{}_1F_1\!\left(-ad;(b-a)d+1;-R\right).
\tag{38.2}
\]

### Proposition 38.1 -- normalized split support is punctual

For every \(d\ge0\),

\[
e^{-R}G_d(R)
\tag{38.3}
\]

is a nonzero polynomial of degree \(ad\).  Its exponential support is
therefore exactly \(\{0\}\), and the algebraic exceptional branch has
coefficient zero.

#### Proof

The first numerator parameter in the hypergeometric factor of (38.2) is the
nonpositive integer \(-ad\), so its series terminates at degree \(ad\).
Its constant coefficient is one.  The reciprocal-Gamma coefficient of the
other large-\(R\) branch is

\[
\Gamma(-ad)^{-1}=0.
\tag{38.4}
\]

This is precisely the exceptional coefficient in the split
Fourier/Kummer presentation.  \(\square\)

Two relevant instances are:

\[
\operatorname{Bl}_{\mathbf P^3}\mathbf P^5:
\quad (a,b)=(1,1),
\tag{38.5}
\]

and

\[
\operatorname{Bl}_{X}\mathbf P^5:
\quad (a,b)=(1,3).
\tag{38.6}
\]

Thus both actual pilots have **zero**, rather than merely positive-charge,
point-to-exceptional coefficient.  They calibrate point purity but supply no
nonzero exceptional Stokes arrow whose charge could be followed.

## 38.3 The hostile negative-degree support survives the displayed algebra

The formal substitution
\((a_\beta,b_\beta)=(-1,0)\) gives

\[
\sum_{k\ge0}\frac{k!}{k!(k+1)!}R^k
=\frac{e^R-1}{R}.
\tag{38.7}
\]

After universal string normalization,

\[
e^{-R}\frac{e^R-1}{R}
=\frac{1-e^{-R}}R
=\frac1R[0]-\frac1R[-1].
\tag{38.8}
\]

### Proposition 38.2 -- exact formal charge trace

The nonambient support in (38.8) has exponent difference \(-1\).  This
difference is preserved by every coordinate operation displayed in the
split calculation:

1. multiplication by the common string exponential translates all
   exponents by the same amount;
2. the monomial change in the first Novikov variable multiplies a
   fixed-degree coefficient by a power of \(R\), which changes no exponential
   support; and
3. in codimension two there is \(r-1=1\) center branch, hence no nontrivial
   deck permutation among center stationary points.

Consequently the oriented degree \(d(-n)=n\) sends the hostile term to
degree one.

#### Proof

Common translation preserves differences, polynomial multiplication
preserves exponential labels, and a singleton has trivial permutation
action.  \(\square\)

This completes the finite exponential-support trace requested in Module 37.
It does **not** complete the analytic trace: (38.7) arose from a formal
negative-degree substitution, not from a proved relative
ancestor/Gamma/Stokes comparison.

## 38.4 Iritani's stationary charges

Let a blowup center have codimension \(r\ge2\).  In Iritani's stationary
phase notation for the center fixed component,

\[
c_Z=-(r-1)
\tag{38.9}
\]

and the \(r-1\) critical points are

\[
\lambda_j=\zeta_{r-1}^{\,j}\lambda_0,
\qquad
0\le j\le r-2.
\tag{38.10}
\]

The associated exponential phases are

\[
\alpha_j=c_Z\lambda_j.
\tag{38.11}
\]

These are the closed-fibre scalar exponential labels before lower nilpotent
and formal Novikov corrections.  Iritani's stationary calculation alone does
not identify the analytic Stokes directions after those corrections.  Under
the finite-Artin/nilpotent hypotheses of the prior formal-Novikov sectorial
receiver theorem, the corrections do not change the scalar eigenvalues and
therefore do not rotate these closed-fibre anti-Stokes directions.

### Theorem 38.3 -- stationary polygon obstruction

If \(r=2\), the center has one nonzero stationary charge and generates a
pointed monoid.

If \(r\ge3\), all center stationary charges cannot lie in one strictly
positive additive cone.  Indeed,

\[
\sum_{j=0}^{r-2}\alpha_j
=c_Z\lambda_0
\sum_{j=0}^{r-2}\zeta_{r-1}^{\,j}
=0.
\tag{38.12}
\]

In particular, no additive real weight can be strictly positive on every
\(\alpha_j\).

#### Proof

For \(r=2\) there is one nonzero generator.  For \(r\ge3\), the sum of all
\((r-1)\)-st roots of unity is zero.  A weight positive on every summand
would be positive on their sum, contradicting (38.12).  The same positive
relation prevents the submonoid of \((\mathbf C,+)\) generated by all
\(\alpha_j\) from being pointed.  \(\square\)

For \(r=3\) the two charges are already opposite.  For \(r=4\) they form a
triangle.  The obstruction is not a subtle wall-crossing coefficient; it is
present in the formal stationary phases.

## 38.5 Consequences for \(m=2\) and all \(m\)

### Corollary 38.3A -- the naive exponent-valued provider is unavailable

Module 37 cannot be instantiated for all blowups merely by declaring every
Iritani center **exponent** positive in the additive subgroup of
\(\mathbf C\).  Any active codimension-\(r\ge3\) center supplies the
nonpointed family (38.11).  A finer independently constructed charge lattice
could evade this conclusion only if its completed algebra maps lawfully to
the Stokes comparison without collapsing the refinement.

A charge-filtered proof can survive such an occurrence only if:

1. the fixed-phase primitive projection kills all but a pointed subset;
2. the complementary Stokes factors independently preserve the row; or
3. a richer filtration/Levi quotient replaces the single positive cone.

### Corollary 38.3B -- why \(m=2\) remains plausible

The new top-dimensional center in a fivefold factorization has dimension
three and codimension two.  Its stationary charge is the singleton case of
Theorem 38.3, so the polygon obstruction does not occur there.

The other fivefold centers have codimension at least three.  Therefore an
\(m=2\) charge proof still requires the **same-receiver** statement that
their projected primitive-sixth correction is empty or row-stabilizing.
The older low-dimensional marker calculation does not automatically supply
that operation-framed adapter.

Thus charge filtration remains a possible bypass for the genuinely new
codimension-two threefold gate, but it is not presently a uniform all-\(m\)
bypass.

## 38.6 What the existing sectorial receiver already supplies

Import the one-arrow theorem of
notes/2026-08-13-c907-formal-novikov-sectorial-receiver.md, whose hypotheses
combine Iritani's formal gauge, finite-Artin level-one multisummation,
Shen--Shoemaker's \(Q=0\) block identification and common-sector theorem, the
separate codimension-two sector repair, and the extremal point-unit lemma.
Under exactly those imported hypotheses, its fixed-\(q_0\), formal-Novikov
receiver supplies, for one blowup arrow:

- a complete Artin-level filtration with finite support below every cutoff;
- nonzero scalar center exponents separated from the zero ambient cluster;
- a sectorial invertible comparison preserving the Novikov connections and
  pairing; and
- at \(Q=0\), the Gamma/Orlov ambient and center block identification.

That imported theorem also proves the one-arrow rank pairing law after the
point section and comparison are placed in the same receiver.  This is not a
consequence of Iritani's stationary calculation alone.  The theorem does not
supply row-compatible adjacent reindexing between independently chosen
sectorial realizations at a shared intermediate variety.  That is exactly
the Module-34/35 path-calibration gate, not a missing scalar charge
calculation.

## 38.7 Source audit

The stationary formulas (38.9)--(38.11) are from Iritani,
*Quantum cohomology of blowups*, arXiv:2307.13555, Section 4.2.3:
\(c_Z=-(r-1)\), the critical points are the deck rotations of
\(\lambda_0\), and the stationary asymptotics carry
\(e^{c_Z\lambda_j/z}\).

Preservation of those scalar directions through the formal-Novikov
corrections, the one-arrow common receiver, and its rank pairing law are
separate imported results from
notes/2026-08-13-c907-formal-novikov-sectorial-receiver.md, with the
Shen--Shoemaker, sector-window, and point-unit inputs named there.

The actual Kummer pilots and (38.7) were rederived in:

- notes/2026-08-13-c907-ci-blowup-point-purity.md; and
- notes/2026-08-13-c907-birational-normal-splitting-reduction.md.

The analytic boundary is not hidden: Lee--Lin--Qu--Wang's degeneration
framework does not state the relative ancestor-to-Gamma/Stokes lift, and the
existing fixed-\(q_0\) receiver closes one arrow rather than its adjacent
path reindexing.

## 38.8 Executable calibration

The shared replay checks:

- Kummer's terminating identity coefficientwise for the two split pilots at
  bounded degrees;
- the exact coefficients and support of the negative-degree tail;
- invariance of exponential support under the displayed monomial changes;
  and
- the singleton versus root-polygon charge dichotomy.

These are finite witnesses for the displayed algebra.  They do not verify
the relative-cap Stokes lift or path coherence.

## 38.9 EJ/TT and mystery ledger

**EJ.** The first hostile term is better than a mere non-counterexample: its
nonzero exponent survives every displayed algebraic reparametrization.  If
the relative-cap lift exists with that normalization, charge augmentation
would ignore it without cancellation.

**TT.** The roots-of-unity polygon is the decisive limitation.  Do not build
general BPS machinery before specifying which center branches survive the
primitive row consumer.  The naive all-branch positive cone is impossible.

| question | status | exact evidence or gate |
|---|---|---|
| Do the actual toric and cubic-center split pilots have a nonzero exceptional point coefficient? | **no** | Proposition 38.1 |
| Does the hostile formal tail have nonzero stable exponential charge? | **yes at finite-support level** | Proposition 38.2 |
| Is it an actual relative-cap Stokes factor? | **open** | ancestor/Gamma/Stokes lift is not in the audited degeneration source |
| Is the codimension-two stationary charge pointed? | **yes** | singleton case of Theorem 38.3 |
| Can all higher-codimension center branches share one positive cone? | **no** | root-polygon relation (38.12) |
| Does this still offer an \(m=2\) bypass? | **possibly** | requires lower-center same-receiver nullity and adjacent path calibration |
| Does it give a naive all-\(m\) bypass? | **no** | Corollary 38.3A |

## Boundary

The exponent-valued charge regression passes for the unique codimension-two
center exponent and fails uniformly for the full higher-codimension
stationary polygon.
No unconditional \(m=2\) theorem follows, and the path-calibration provider
remains open.
