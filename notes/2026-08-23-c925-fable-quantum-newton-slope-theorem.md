# Boundary rotation order of a quantum spectral cover is a ratio of two curve-class functionals

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23
**Branch/worktree:** `c925-fable`

The loop-stabilizer route needs to know which rotation orders a boundary limit
of a quantum spectral cover can have.  A previous pass conjectured that the
order is the Fano index of a limiting variety, argued it only inside the toric
mirror picture, and left it as the single load-bearing gap
(`2026-08-22-c925-fable-loop-orbit-arithmetic-ledger.md`, §11.2c and §12.5).

This note removes the mirror.  The degree axiom of genus-zero Gromov–Witten
theory already forces the Newton polygon of the spectral cover, so the
rotation order is an explicit ratio of two integral functionals on curve
classes.  For Picard rank one this proves the identification outright: the
rotation order **is** the Fano index.  For higher Picard rank it replaces the
conjecture by a computable criterion and isolates exactly what is still
missing.

## 1. Setting

Let \(Z\) be a smooth projective variety, \(N=\operatorname{rank}H^{\rm
ev}(Z)\), and let \(c_1=c_1(T_Z)\).  Write \(\mathrm{Eff}\subset
H_2(Z,\mathbf Z)\) for the semigroup of classes of effective curves and
\(Q^\beta\) for the Novikov variables.  Let

\[
  P(\lambda,Q)\;=\;\det\bigl(\lambda-c_1\star\bigr)
  \;=\;\lambda^{N}+\sum_{j\ge1}c_j(Q)\,\lambda^{N-j}
\]

be the characteristic polynomial of quantum multiplication by \(c_1\) on
\(H^{\rm ev}(Z)\).

A **cocharacter** is a class \(b\in H^2(Z,\mathbf Z)\); it defines the
one-parameter boundary limit \(Q^\beta\mapsto t^{\,b\cdot\beta}Q^\beta\), and
the **rotation order** of a branch of the spectral cover at \(t=0\) is its
ramification index there, that is, the cycle length of the branch under the
monodromy \(t\mapsto e^{2\pi i}t\).

## 2. Quasi-homogeneity pins the polygon

**Lemma 1 (degree axiom).**  \(c_j(Q)\) is supported on curve classes
\(\beta\) with \(c_1\cdot\beta=j\).

*Proof.*  The genus-zero Gromov–Witten degree axiom makes the small quantum
product homogeneous once \(\deg Q^\beta=2\,c_1\cdot\beta\) and cohomological
degree is used on \(H^{\rm ev}(Z)\).  Hence \(c_1\star\) raises complex degree
by one, its eigenvalues are homogeneous of complex degree one, and \(P\) is
quasi-homogeneous of weight \(N\) when \(\lambda\) is given weight one and
\(Q^\beta\) weight \(c_1\cdot\beta\).  Comparing weights in
\(c_j\lambda^{N-j}\) gives the claim. ∎

Fix a cocharacter \(b\) and put

\[
  f(j)\;=\;\min\{\,b\cdot\beta\;:\;\beta\in\mathrm{Eff},\;
   c_1\cdot\beta=j,\;\text{the coefficient of }Q^\beta\text{ in }c_j
   \text{ is nonzero}\,\},
\]

the \(t\)-order of \(c_j\), with \(f(0)=0\).  The Newton polygon of
\(P(\lambda,t)\) is the lower convex hull of the points \((j,f(j))\).

**Theorem A.**  Every branch of the spectral cover has \(t\)-valuation

\[
  v \;=\; \frac{b\cdot\gamma}{c_1\cdot\gamma},
  \qquad \gamma=\beta_2-\beta_1,
\]

for two effective classes \(\beta_1,\beta_2\) realizing the endpoints of a
Newton edge, with \(c_1\cdot\gamma>0\) equal to the horizontal length of that
edge.  Consequently the rotation order of the branch is

\[
  q\;=\;\frac{c_1\cdot\gamma}{\gcd\bigl(b\cdot\gamma,\;c_1\cdot\gamma\bigr)},
\]

so \(q\) divides \(c_1\cdot\gamma\), which is at most \(N\).

*Proof.*  A Newton edge runs from \((j_1,f(j_1))\) to \((j_2,f(j_2))\) with
\(j_1<j_2\), and its slope is \((f(j_2)-f(j_1))/(j_2-j_1)\).  By Lemma 1 the
minimizers are effective classes \(\beta_1,\beta_2\) with
\(c_1\cdot\beta_i=j_i\) and \(b\cdot\beta_i=f(j_i)\).  Setting
\(\gamma=\beta_2-\beta_1\) gives \(c_1\cdot\gamma=j_2-j_1\) and
\(b\cdot\gamma=f(j_2)-f(j_1)\), so the slope is
\((b\cdot\gamma)/(c_1\cdot\gamma)\).  By the Newton–Puiseux theorem the branch
valuations are exactly the edge slopes, and the ramification index of a branch
is the denominator of its valuation in lowest terms.  Finally
\(c_1\cdot\gamma=j_2-j_1\le N\) because \(j\) indexes the coefficient of
\(\lambda^{N-j}\). ∎

Two immediate consequences worth stating separately.

**Corollary A1 (block-count bound).**  A cycle of \(\ell\) blocks of rank
\(k\) needs a Newton edge of horizontal length at least \(k\ell\), hence
\(N\ge k\ell\).  For a cycle of rank-two blocks, \(N\ge2\ell\).

**Corollary A2 (grading loop).**  Taking \(b=c_1\) gives \(v=1\) on every
edge, so the grading cocharacter produces no rotation at all.  This recovers,
with a one-line proof, the negative result recorded earlier as a closed lens.

## 3. Picard rank one: the rotation order is the Fano index

**Theorem B.**  Let \(Z\) be a Fano manifold with \(b_2(Z)=1\) and Fano index
\(r\), so that \(c_1=r\,h\) with \(h\in H^2(Z,\mathbf Z)\) primitive.  Then
for the cocharacter \(b=k\,h\) every Newton slope equals \(k/r\), and every
rotation order divides \(r\), with equality exactly when
\(\gcd(k,r)=1\).  In particular the maximal rotation order over all
cocharacters is the Fano index \(r\), attained by every primitive
cocharacter.

*Proof.*  With \(b_2=1\) the effective cone is the ray spanned by the
primitive class \(\beta_0\) with \(h\cdot\beta_0=1\), so every class is
\(\beta=d\beta_0\) with \(d\ge0\), and \(c_1\cdot\beta=rd\),
\(b\cdot\beta=kd\).  For \(\gamma=\beta_2-\beta_1=(d_2-d_1)\beta_0\), Theorem
A gives slope \((k(d_2-d_1))/(r(d_2-d_1))=k/r\), independent of the edge.
Its denominator in lowest terms is \(r/\gcd(k,r)\). ∎

So for Picard rank one the identification "rotation order equals index" is a
theorem, proved from the degree axiom alone.  It holds for every smooth
projective \(Z\) of Picard rank one, Fano or not, in the form "every rotation
order divides \(r\)", where \(c_1=rh\); Fanoness is used only to know
\(r>0\).

**Checks against known spectra.**

| \(Z\) | index \(r\) | spectral data | rotation order |
|---|---|---|---|
| \(\mathbf P^d\) | \(d+1\) | \(\lambda^{d+1}-(d+1)^{d+1}Q\) | \(d+1\) |
| cubic threefold \(B\) | 2 | \(\chi_K=T^2(T^2-108q)\) | 2 |
| quadric threefold \(Q^3\) | 3 | \(H^4=4qH\), factor \(H^3-4q\) | 3 |

Every row agrees with Theorem B.  The cubic row is the one the programme
depends on: its marked block has ramification exactly two, matching its index.

## 4. Why the source ledger has an \((m+1)\)-cycle

The marked block of the cubic threefold sits at the **zero** eigenvalue of
\(c_1\star\): the audit's factorization \(\chi_K=T^2(T^2-108q)\) has the
marked \(J_2\) as its \(T^2\) factor.  For the product,

\[
  c_1(B\times\mathbf P^m)\star
  \;=\;c_1(B)\star\otimes1\;+\;1\otimes c_1(\mathbf P^m)\star ,
\]

so the marked block of \(B\) at eigenvalue zero, tensored with the \(m+1\)
eigenvalues \((m+1)\zeta^{\,j}Q^{1/(m+1)}\) of \(\mathbf P^m\), gives exactly
\(m+1\) marked blocks at nonzero eigenvalues, cyclically permuted with
rotation order \(m+1\).  By Theorem B applied to the factor
\(\mathbf P^m\), that order is the Fano index of \(\mathbf P^m\), which by
Kobayashi–Ochiai is the largest index available in dimension \(m\).

This is the structural picture the ledger's §11.2c assumed, now derived: the
marking comes from the cubic factor at eigenvalue zero, and the rotation comes
from a separate factor whose index is the rotation order.

## 5. What Picard rank one settles, and what it does not

**Settled.**  The borderline case of the dimension bound.  A marked
three-cycle on a threefold centre, if the marked and rotating structures
coincide on one variety, needs index three in dimension three, which
Kobayashi–Ochiai forces to be the quadric.  The quadric has Picard rank one,
so Theorem B applies and gives rotation order exactly three; and the quadric
is on record as carrying rank-one semisimple sheets rather than the rank-two
marked atom (Pech–Rietsch's quantum Chevalley table, \(H^4=4qH\)).  The
borderline is therefore closed rigorously rather than by analogy.

**Settled.**  Every threefold centre of Picard rank one, by counting alone.
Its even cohomology has rank \(2+2b_2=4\), while Corollary A1 demands at least
six for a cyclic triple of rank-two blocks.  This disposes of the most natural
marked threefold centre, a cubic threefold itself: a cubic threefold centre
can contribute a marked block but can never contribute a marked three-cycle.
The same counting kills every prime Fano threefold centre.

**Not settled.**  For \(b_2(Z)\ge2\) Theorem A gives the exact criterion but
not a dimension bound: the rotation order is
\((c_1\cdot\gamma)/\gcd(b\cdot\gamma,c_1\cdot\gamma)\), and since \(b\) ranges
over all of \(H^2(Z,\mathbf Z)\) the denominator can be any divisor of
\(c_1\cdot\gamma\).  What must still be bounded is \(c_1\cdot\gamma\) on the
edge carrying the marked blocks.  Corollary A1 gives
\(N\ge2\ell\), hence \(b_2(Z)\ge\ell-1\) for a threefold, which for
\(\ell=3\) reproduces the earlier \(b_2\ge2\) and nothing stronger.

So the remaining obligation is sharper and purely numerical:

> **Residual gate.**  Let \(Z\) be a smooth projective threefold of Picard
> rank at least two carrying a cyclic triple of rank-two blocks with
> modified-residue discriminant \(4/9\).  Show that no cocharacter
> \(b\in H^2(Z,\mathbf Z)\) and no difference \(\gamma\) of effective classes
> realizing a Newton edge of length at least six satisfy
> \(3\nmid b\cdot\gamma\) and \(3\mid c_1\cdot\gamma\).

Mori's cone theorem bounds \(c_1\cdot C\le\dim Z+1\) on extremal rational
curves, which is the curve-level analogue of Kobayashi–Ochiai; it does not
directly bound \(c_1\cdot\gamma\) for a difference of effective classes, and
that is the exact hole.  Closing it needs either a positivity statement
restricting which \(\gamma\) can realize a Newton edge of the marked
sub-cover, or the marker itself.

## 6. Formal check

`Comparison/QuantumNewtonSlope.lean` records the arithmetic of Theorem A and
Theorem B, with the edge entering as its height \(|b\cdot\gamma|\) and its
positive length \(c_1\cdot\gamma\).  Checked declarations:
`rotationOrder_dvd_edgeLength` and `rotationOrder_le_edgeLength` (Theorem A's
divisibility and bound), `rotationOrder_proportional`,
`rotationOrder_dvd_index` and `rotationOrder_eq_index_of_coprime` (Theorem B
and its sharpness), `realizedOrder_dvd_index` (a realized cycle length divides
the index, the step that feeds Kobayashi–Ochiai),
`secondBetti_ge_of_rankTwo_cycle` and
`no_rankTwo_threeCycle_of_picardRankOne` (the counting bounds).  Elaboration
is clean with no warnings.  The geometry — Lemma 1, the Newton–Puiseux
theorem, and the identification of curve classes with the Novikov exponents —
is external.

## 7. Replay

- Lean: `lean/scripts/guarded-lean --root papers/cubic-stabilization-irrationality/lean papers/cubic-stabilization-irrationality/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationIrrationality/Comparison/QuantumNewtonSlope.lean`.
- The three spectral checks in §3 are quoted from
  `2026-08-19-c924-direct-qdm-proof-audit.md` (cubic) and
  `2026-08-21-c925-no-stokes-source-dossier.md`, section D12 (quadric,
  citing Pech–Rietsch, arXiv:1306.4016, equation (23)).
