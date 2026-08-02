# C814: Golden quantum-statistics mathematical ceilings

**Lane:** `golden`

**Status:** research complete; mathematics only; no manuscript edit

## Verdict

The continuous-control branch has a sharp positive result.  For every Golden
protocol and every real diagonal control (x\in[-1,1]^6), the twenty balanced
sign controls simultaneously maximize the first two squared-singular moments,
all exterior traces through degree three, and all three degree-three Schur
exchange traces.  Equality in any of the three-particle sector maxima forces a
balanced sign control.  Thus the balanced masks are the unique joint Pareto
optimum of the intrinsic three-particle exchange statistics, not merely a
special Boolean stratum.

The generalized branch gives the complementary obstruction.  Across the full
order-six Hermitian conference class, triangle Bargmann holonomy preserves the
first two balanced-cut moments but changes the full degree-three exchange
split.  Cut-independent full exchange spectrum holds exactly on the real
switching class.  Both results are retained only for later paper-inclusion
review under the qualified literature boundary below.

The unlabelled inverse and higher-moment branches are dependency-gated.  C810
owns aligned-certificate distance and C812 owns the first same-order
higher-moment separation.  Both remain queued.  C814 will consume their frozen
outputs rather than duplicate their searches.

## 1. Continuous-control theorem

Fix one Golden symmetric conference matrix (C), its spectral projectors
(P_\pm), and orthonormal spectral frames (Q_\pm).  For

\[
 K(x)=Q_-^{\mathsf T}\operatorname{diag}(x)Q_+,
 \qquad H(x)=K(x)^{\mathsf T}K(x),
\]

write

\[
 p_r=\operatorname{tr}(H^r),\qquad
 e_r=\operatorname{tr}(\bigwedge^r H).
\]

> **Golden continuous-control exchange theorem.**  If
> (x\in[-1,1]^6), then
> \[
> \begin{aligned}
> p_1&\le \frac95,&
> p_2&\le \frac{33}{25},&
> e_2&\le \frac{24}{25},&
> e_3&\le \frac{16}{125},\\
> \operatorname{tr}(\operatorname{Sym}^3H)
>   &\le\frac{313}{125},&
> \operatorname{tr}(S_{(2,1)}H)&\le\frac85.
> \end{aligned}
> \]
> The twenty balanced sign controls attain all six bounds simultaneously.
> Equality in either degree-three Schur bound occurs exactly at those twenty
> controls.  The same statement holds for each of the six Golden protocols.

The exterior bound is the frozen C707 sharp determinant theorem.  The other
bounds and their simultaneous exchange interpretation are C814's task-owned
consequences.  No priority claim is made here.

### Proof

Put (L=[D_x,C]/\sqrt5).  The positive eigenvalues of (-L^2/4), one
from each doubled pair, are the three eigenvalues of (H).  Hence

\[
 p_1=-\frac18\operatorname{tr}(L^2),\qquad
 p_2=\frac1{32}\operatorname{tr}(L^4),\qquad
 e_3=\frac{\operatorname{Pf}(L)^2}{64}.
\]

The first identity reduces directly to

\[
 p_1=\frac{6\sum_i x_i^2-(\sum_i x_i)^2}{20}\le\frac95.
\]

The function (p_2=\lVert K\rVert_{S_4}^4) is convex in (K), hence
convex in (x).  Its maximum on the cube occurs at a sign vertex.  For a
negative support of size (0,1,2,3), up to complement, the squared-singular
spectra are respectively

\[
 (0,0,0),\quad(1,0,0),\quad
 (4/5,4/5,0),\quad(4/5,4/5,1/5).
\]

This proves (p_2\le33/25).

Every (2\times2) minor of
(K(x)=\sum_i x_i u_i^- (u_i^+)^{\mathsf T}/2) is affine in each
individual (x_i): the coefficient of (x_i^2) vanishes because the
corresponding path summand has rank one.  Therefore
(e_2=\lVert\bigwedge^2K\rVert_{\rm HS}^2) is separately convex on the
cube.  Successively moving each coordinate to an endpoint reduces its maximum
to the same 64 vertices and gives (e_2\le24/25).  The identical rank-one
argument makes (det K) multi-affine; C707's signed-cubic calculation gives
(e_3\le16/125), with equality exactly at the twenty balanced vertices.

For three variables (lambda_i\), the complete-symmetric trace satisfies

\[
 h_3(\lambda)=e_3(\lambda)+p_1(\lambda)p_2(\lambda).
\]

The preceding three bounds therefore give
(h_3\le16/125+(9/5)(33/25)=313/125), and equality forces the C707
exterior equality case.

It remains to control the mixed sector.  The following elementary spectral
lemma is useful independently of the Golden coordinates.

> **Spectral lemma.**  If (0\le\lambda_i\le1),
> (e_1\le9/5), and (e_2\le24/25), then
> \[
> s_{(2,1)}(\lambda)=e_1e_2-e_3\le\frac85.
> \]
> Equality holds only at a permutation of
> ((4/5,4/5,1/5)).

To prove it, sort (a\ge b\ge c), put (s=a+b+c),
(t=ab+ac+bc), (u=a+b), and (v=ab).  The objective (st-abc)
is coordinatewise increasing, so at a maximum either (s=9/5) or
(t=24/25).  When (s=9/5), (u=9/5-c) and the objective is
(u(v+9c/5)), increasing in (v).  The two available upper bounds are

\[
 v\le \frac{u^2}{4},\qquad
 v\le\frac{24}{25}-cu.
\]

They exchange at (c=1/5).  On (0\le c\le1/5), subtraction from
(8/5) factors as

\[
 \frac{(5c-1)(25c^2+50c-71)}{500}\ge0;
\]

on (1/5\le c\le3/5) it factors as

\[
 \frac{(5c-4)^2(5c-1)}{125}\ge0.
\]

If instead (t=24/25), feasibility with (s\le9/5) forces
(c\ge1/5), and the objective is at most
((9/5-c)(24/25+c^2)), giving the second factor again.  Equality forces
(c=1/5), (u=8/5), and (v=16/25), hence
((a,b,c)=(4/5,4/5,1/5)).  Applying the lemma to the eigenvalues of (H)
gives the mixed bound.  Its equality spectrum has (e_3=16/125), so C707
again forces a balanced sign control.

### Exact evidence

The deterministic generator checks (C^2=5I), evaluates all 64 Boolean
controls using exact commutator traces and Pfaffians, and records the endpoint
maxima and spectral-lemma factors.  An independent replay uses the coordinate
cut Gram matrices (RR^{\mathsf T}/5), not the commutator/Pfaffian formulas.

Replay from the repository root:

```sh
python3 notes/2026-08-02-c814-continuous-frontier.py --check
python3 notes/2026-08-02-c814-continuous-frontier-replay.py
```

Files:

- `notes/2026-08-02-c814-continuous-frontier.py`;
- `notes/2026-08-02-c814-continuous-frontier-replay.py`;
- `notes/2026-08-02-c814-continuous-frontier.json`;
- `notes/2026-08-02-c814-continuous-frontier.sha256`.

The trusted boundary is Python integer and rational arithmetic, the displayed
conference matrix, exhaustive enumeration of 64 sign vertices, and the human
convexity reductions above.  The exploratory differential-evolution run was a
falsifier only and is not part of the certificate.  The theorem determines the
joint upper/Pareto boundary, not the complete semialgebraic image of the cube.

## 2. Pivot record

### Unlabelled inverse to continuous controls

- **`ej`:** a complete 15-graph descendant dataset exists at order 25, but
  its graphs must first be quotiented by the corresponding order-26 regular
  two-graphs; fifteen descendants cannot be treated as fifteen conference
  switching classes.
- **`tt`:** the natural object is the spectral deck of the regular two-graph,
  not a histogram attached to one arbitrarily rooted descendant.
- **`aa`:** exact two-graph incidence canonicalization, invariant-first
  collision filtering, and an inclusion/spectral-deck theorem are genuinely
  different attacks.
- **Decision:** wait for C810/C812's frozen representatives and first
  separating statistics; continue with the independent continuous branch.

### Continuous controls: `ej`/`tt`/`aa` closeout before the next pivot

- **`ej`:** the rank-one path decomposition gives the two-fermion exterior
  maximum (e_2\le24/25) for free.  Together with the C707 determinant
  maximum it closes every partition of three, not only bosonic and fermionic
  endpoints.
- **`tt`:** the correct question was the joint Schur-sector Pareto boundary,
  rather than a full algebraic parametrization of every interior point.
- **`aa`:** three attacks were tested: coordinate-curvature/SOS,
  Schur-functor convexity, and spectral inequalities from sharp (e_1,e_2)
  bounds.  The last gives the short human proof; the first served as a
  falsifier, and the second remains unnecessary.
- **Decision:** accept the joint-Pareto theorem and pivot to generalized
  conference-class rigidity.  A full semialgebraic image is deferred unless a
  later branch makes it free.

## 3. Complex Hermitian conference ceiling

Let \(C=C^*\) be any complex Hermitian conference matrix of order six:
\(C_{ii}=0\), \(|C_{ij}|=1\), and \(C^2=5I\).  For a balanced triple
\(T=\{i,j,k\}\), let \(A=C[T]\), let \(R=C[T,T^c]\), and set

\[
 H_T=RR^*/5=I-A^2/5,
 \qquad r_T=\operatorname{Re}(C_{ij}C_{jk}C_{ki}).
\]

### Theorem B — holonomy controls the entire degree-three exchange split

For every such \(C\) and every balanced triple,

\[
 p_1=\frac95,\qquad p_2=\frac{33}{25},\qquad e_2=\frac{24}{25},
\]

while

\[
 e_3=\frac{4(5-r_T^2)}{125},\qquad
 h_3=\frac{317-4r_T^2}{125},\qquad
 s_{(2,1)}=\frac{196+4r_T^2}{125}.
\]

Thus complex phase does not change one-particle mass, purity, or the
two-fermion sector, but transfers weight exactly between the symmetric and
mixed three-particle sectors; in particular
\(h_3+s_{(2,1)}=513/125\).  The real Golden spectrum is the \(|r_T|=1\)
endpoint \(\{1/5,4/5,4/5\}\), whereas \(r_T=0\) gives
\(\{2/5,2/5,1\}\), raises \(e_3\) from \(16/125\) to \(4/25\), and raises
\(h_3\) by \(4/125\).

**Proof.**  The conference block equations give \(RR^*=5I-A^2\).
The characteristic polynomial of the unit-modulus Hermitian triangle is
\(z^3-3z-2r_T\).  Newton identities therefore give the stated fixed first two
moments and determinant; the displayed Schur formulas then follow from
\(h_3=e_3+p_1p_2\) and \(s_{(2,1)}=p_1e_2-e_3\).

### Theorem C — sharp order-six rigidity

An order-six Hermitian complex conference matrix has cut-independent full
balanced exchange spectrum if and only if it is switching/permutation
equivalent to the real symmetric conference class.

For the nontrivial direction, dephase row and column zero to ones and write
the remaining block as \(S\).  Then
\(S\mathbf1=0\) and \(S^2=5I-J\).  Cut-independence is equivalent by Theorem B
to \(|r_T|=\rho\) on all triangles.  Triangles containing zero force every
off-diagonal entry of \(S\) to have real part \(\pm\rho\).

For \(0<\rho<1\), put \(t=\rho^2\) and write

\[
 S_{ij}=a_{ij}\sqrt t+i b_{ij}\sqrt{1-t}.
\]

The row sums force \(a\) to be a symmetric sign graph with two plus and two
minus neighbors at every vertex, and \(b\) to be a regular tournament.  The
positive edges of \(a\) therefore form a pentagon.  Relabel its vertices so
that those edges are
\(01,12,23,34,40\), and write \(A=(a_{ij})\), \(B=(b_{ij})\), with \(B\)
skew-symmetric.  The imaginary part of \(S^2=5I-J\) is

\[
 \sqrt{t(1-t)}(AB+BA)=0.
\]

But direct expansion of only three entries gives

\[
 (AB+BA)_{02}+(AB+BA)_{03}-(AB+BA)_{23}
   =2(b_{03}-b_{24}-b_{34}).
\]

Anticommutation would force \(b_{03}=b_{24}+b_{34}\), impossible because
the left side is odd and the right side is even.  This rules out every
\(0<t<1\) without classifying tournaments or checking triangle equations.

At \(t=0\), \(S=iB\) would give \(B\mathbf1=0\) and
\(B^2=J-5I\).  Border it by

\[
 \widetilde B=\begin{pmatrix}0&\mathbf1^{\mathsf T}\\
 -\mathbf1&B\end{pmatrix}.
\]

Then \(\widetilde B\) is an integral skew-symmetric sign matrix and
\(\widetilde B^2=-5I_6\), so \(\det\widetilde B=5^3=125\).  The determinant
of an even integral skew-symmetric matrix is the square of its integral
Pfaffian, whereas 125 is not a square.  Thus \(t=0\) is impossible as well.
Only \(t=1\) remains, which is the real conference endpoint.  The converse is
the real order-six cut rigidity already established in the Golden analysis.

Et-Taoui's exact \(C_6(i)\) supplies the sharp falsifier to any broader
complex-rigidity claim: cuts \(012\) and \(013\) have respectively
\(r=-1,0\) and squared spectra
\(\{1/5,4/5,4/5\}\), \(\{2/5,2/5,1\}\).

### Exact evidence

The human parity/Pfaffian proof above is now load-bearing.  The deterministic
certificate is retained as a non-load-bearing exhaustive cross-check: it
enumerates the 12 row-balanced real sign patterns and 24 regular tournaments,
checks all 288 interior combinations and the purely imaginary endpoint, and
records the holonomy formulas.  An independent replay fixes one canonical
five-cycle, checks all 24 relative tournaments, and independently verifies the
Gaussian-integer \(C_6(i)\) example and its two cuts.

Replay from the repository root:

```sh
python3 notes/2026-08-02-c814-complex-conference-rigidity.py --check
python3 notes/2026-08-02-c814-complex-conference-rigidity-replay.py
```

Files:

- `notes/2026-08-02-c814-complex-conference-rigidity.py`;
- `notes/2026-08-02-c814-complex-conference-rigidity-replay.py`;
- `notes/2026-08-02-c814-complex-conference-rigidity.json`;
- `notes/2026-08-02-c814-complex-conference-rigidity.sha256`.

The finite exhaustion is redundant for Theorem C and only cross-checks its
exact reduced order-six setup; neither the structural proof nor the certificate
asserts a corresponding theorem at larger orders or for nonconference
two-eigenvalue frames.

## 4. Generalized branch pivot record

- **`ej`:** triangle holonomy is the sole moving coordinate.  Purity remains
  fixed, and the identity \(h_3+s_{(2,1)}=513/125\) exposes an exact transfer
  between symmetry types rather than an overall gain.
- **`tt`:** the natural invariant is the Bargmann triangle product, and the
  theorem should cover the entire Hermitian order-six conference class rather
  than only Et-Taoui's displayed family.
- **`aa`:** three attacks were separated: an explicit-family falsifier, a full
  dephased sign/tournament classification, and an appeal to general uniform-
  subframe or spectral-monomorphy machinery.  A post-closeout compression
  reduces the finite classification to one pentagon anticommutation parity and
  one Pfaffian-square obstruction; the enumeration is now only a cross-check.
  The external frameworks are used only for positioning.
- **Decision:** stop the generalized branch at the exact obstruction and
  rigidity classification.  A broader two-eigenvalue/ETF claim would be a new
  task and is not supported by this order-six certificate.

## 5. Final synthesis and paper-review disposition

### Generalized branch to synthesis: `ej`/`tt`/`aa`

- **`ej`:** real balanced masks maximize every degree-three sector when the
  Golden operator is fixed, yet deforming that operator through complex
  conference phases raises \(e_3\).  The apparent ceiling therefore has two
  distinct axes: control generality and operator generality.
- **`tt`:** control variation is governed by cube convexity and spectral
  inequalities; operator variation is governed by gauge-invariant triangle
  holonomy.  Conflating them would conceal the exact phase-induced tradeoff.
- **`aa`:** possible next attacks are complex diagonal controls, deformation of
  the operator class, or their joint optimization.  The combined landscape is
  deferred because neither current theorem controls both axes simultaneously.
- **Decision:** close C814 with the two sharp one-axis theorems and leave the
  combined complex-control problem as an explicitly separate ceiling.

| Result | Disposition for later paper review |
|---|---|
| Full-cube simultaneous Schur-sector maxima for fixed real Golden \(C\) | **Keep as candidate.** Human proof plus dual replay; novelty audit still incomplete. |
| Complex holonomy exchange formulas and order-six uniformity classification | **Keep as candidate.** Sharp and replayable; publication-stage literature audit required. |
| Robust unlabelled inverse and higher cut-moment separation | **Defer.** Await C810/C812 frozen outputs; do not duplicate their searches. |
| Generic two-eigenvalue/ETF classification | **Reject from C814 scope.** No justified theorem yet. |
| Combined Hermitian-conference/real-control Pareto boundary | **Superseded by post-closeout request.** Section 7 settles the scalar upper frontier; the full interior image remains deferred. |

The bounded literature record is
`notes/2026-08-02-c814-quantum-statistics-literature-audit.md`.  It locates the
Et-Taoui family and the adjacent uniform-subframe/spectral-monomorphy
frameworks, but it explicitly does **not** clear either result for a priority
claim.

## Mystery ledger (final)

- **Settled:** balanced sign controls are genuine global, simultaneous
  exchange-sector optima on the full physical filter cube.
- **Settled:** the mixed (S_{(2,1)}) sector has no hidden interior maximizer.
- **Open dependency:** adversarial certificate distance and same-order
  higher-moment separation remain owned by C810 and C812.
- **Settled:** complex Hermitian phases destroy full real cut rigidity while
  preserving purity; triangle holonomy gives the exact exchange-sector split.
- **Settled:** cut-independent full balanced exchange spectrum at order six
  characterizes the real switching class inside the Hermitian conference
  class.
- **Deferred:** the complete interior semialgebraic exchange region; it is not
  needed for the sharp operational ceiling.
- **Superseded by post-closeout Section 7:** the scalar joint Pareto boundary
  for complex conference deformation and real controls is now settled.  The
  full interior image, complex controls, and higher-order analogues remain
  deferred.
- **Open audit:** both kept results require later paper-inclusion review and a
  stronger literature audit before any novelty wording.

## Final `ej` + `tt` closeout

- **`ej`:** the complex endpoint \(r_T=0\) is not merely a counterexample: it
  is the maximal filled-fermion point allowed by the exact holonomy formula,
  while the real Golden class is the minimal endpoint.  The conserved sum
  \(h_3+s_{(2,1)}\) identifies where the gain comes from.
- **`tt`:** the clean research object is a two-axis phase diagram—filter
  geometry for fixed \(C\), gauge holonomy for varying \(C\).  C814 has solved
  each coordinate axis sharply at order six; the mixed plane is the honest
  remaining mathematical ceiling.  **This historical closeout was reopened by
  the post-closeout request and is superseded by Theorem D below.**

## 6. Post-closeout `tt` + `ej`: theorem strengthening

The requested second pass removes two artificial restrictions from the
statements above.

### `tt`: natural generality and hidden hypotheses

1. The holonomy formulas are not intrinsically order-six formulas.  If \(C\)
   is a Hermitian conference matrix of order \(q+1\), \(T\) is any triple,
   \(A=C[T]\), and \(H_T=C[T,T^c]C[T,T^c]^*/q=I-A^2/q\), then, with
   \(r_T=\operatorname{Re}(C_{ij}C_{jk}C_{ki})\),
   \[
   \begin{aligned}
   p_1(H_T)&=3-\frac6q,\\
   p_2(H_T)&=3-\frac{12}{q}+\frac{18}{q^2},\\
   e_2(H_T)&=3-\frac{12}{q}+\frac9{q^2},\\
   e_3(H_T)&=\frac{(q-3)^2}{q^2}-\frac{4r_T^2}{q^3}.
   \end{aligned}
   \]
   This follows directly from
   \(\det(zI-A)=z^3-3z-2r_T\).  Order six is special only because a
   triple is then a balanced half and because the rigidity classification in
   Theorem C closes there.
2. Hermiticity is load-bearing: it supplies orthogonal \(\pm\sqrt q\)
   eigenspaces and turns the cross block into a positive Gram operator.
   Unit-modulus off-diagonal entries are load-bearing for the universal first
   two moments.  The real-sign hypothesis is *not* load-bearing for the
   continuous-control bounds through \(e_2\).
3. The cube normalization is cosmetic.  On a scalar interval \([a,b]\), the
   transfer is invariant under adding the midpoint and scales by
   \((b-a)/2\); a homogeneous degree-\(k\) statistic of \(H\) therefore scales
   by \(((b-a)/2)^{2k}\).

### `ej`: free consequences

- For every order-six Hermitian conference matrix, not merely the real Golden
  representative, and every real \(x\in[-1,1]^6\),
  \[
  p_1\le\frac95,\qquad p_2\le\frac{33}{25},\qquad
  e_2\le\frac{24}{25}.
  \]
  The \(p_1\) formula uses only \(|C_{ij}|=1\).  The fourth Schatten power
  \(p_2\) is convex in the linear commutator, hence is maximized at a cube
  vertex.  Every two-by-two minor of
  \(K=Q_-^*\operatorname{diag}(x)Q_+\) is affine in each coordinate separately,
  because changing one coordinate adds a rank-one matrix; summing their
  squared moduli makes \(e_2\) separately convex.  At Boolean support sizes
  \(0,1,2,3\), the nonzero spectra give respectively the universal endpoint
  profiles, with the displayed maxima only at size three.
- The same rank-one argument makes
  \(e_3=|\det K|^2\) separately convex.  Its Boolean boundary and Theorem B
  therefore give the phase-uniform sharp bound
  \[
  e_3\le\frac4{25},
  \]
  and balanced Boolean controls whose cut triangle has \(r_T=0\) attain it.
- Consequently
  \[
  h_3\le\frac{317}{125},\qquad
  s_{(2,1)}\le\frac85.
  \]
  The first follows from \(h_3=e_3+p_1p_2\); the second is the phase-blind
  spectral lemma from Theorem A.  Equality for \(h_3\) occurs at balanced
  Boolean controls with \(r_T=0\), while equality for the mixed sector occurs
  at balanced Boolean controls with \(|r_T|=1\).  Thus the two maxima are
  incompatible, rather than two faces of one common maximizer.

These strengthenings have not received a fresh publication-grade novelty
audit.  They inherit the qualified C814 literature boundary and remain
research candidates only.

## 7. `aa`: mixed-plane attacks and resolution

The mixed plane is

\[
 \mathcal M=\{(h_3,s_{(2,1)},e_3): C=C^*,\ C^2=5I,\ |C_{ij}|=1,
 \ x\in[-1,1]^6\}.
\]

Three genuinely different attacks are available.

1. **Coordinate convexity / rank-one minors.**  Push each control coordinate
   to an endpoint for \(p_1,p_2,e_2,e_3\), then use scalar identities to bound
   the Schur traces.  This has the shortest trust boundary and does not require
   parametrizing complex conference matrices.
2. **Spectral moment body / SOS.**  Eliminate the controls into inequalities
   for three eigenvalues in \([0,1]\), with conference identities added as
   moment constraints.  This is suited to the full semialgebraic image, but it
   forgets the rank-one coordinate mechanism and introduces a much larger
   elimination problem.
3. **Gauge-holonomy stratification.**  Classify the Boolean boundary by the
   triangle Bargmann invariant and then use Et-Taoui's \(C_6(b)\) family to
   realize the holonomy interval.  This identifies equality geometry and
   attainability, but alone does not exclude a non-Boolean interior Pareto
   point.

The first and third attacks combine to solve the upper Pareto boundary without
an SOS calculation.

### Theorem D — exact mixed-plane Pareto edge

Every point of \(\mathcal M\) satisfies

\[
\begin{aligned}
 e_3&\le\frac{20}{125},&
 h_3&\le\frac{317}{125},&
 s_{(2,1)}&\le\frac{200}{125},\\
 s_{(2,1)}+e_3&\le\frac{216}{125},&
 h_3+s_{(2,1)}&\le\frac{513}{125}.&&
\end{aligned}
\]

Its complete componentwise-maximal frontier is the line segment

\[
 (h_3,s_{(2,1)},e_3)
 =\frac1{125}(317-4t,\ 196+4t,\ 20-4t),
 \qquad 0\le t\le1.
\]

It is realized by balanced Boolean controls in Et-Taoui's continuous
order-six family, with \(t=r_T^2\).  The endpoint \(t=0\) maximizes the
symmetric and filled-fermion sectors; \(t=1\) maximizes the mixed sector.

**Proof.**  The first row of inequalities is the preceding `ej` package.  The
identities
\[
 s_{(2,1)}+e_3=p_1e_2,
 \qquad
 h_3+s_{(2,1)}=p_1(p_2+e_2)
\]
and the sharp phase-uniform bounds on \(p_1,p_2,e_2\) give the second row.
For any point satisfying these inequalities, the interval
\[
 \frac{125s_{(2,1)}-196}{4}
 \le t\le
 \min\!\left\{\frac{20-125e_3}{4},
                  \frac{317-125h_3}{4}\right\}
\]
meets \([0,1]\).  The corresponding displayed frontier point dominates it
componentwise.  Conversely, every displayed point is attained: in the
dephased \(C_6(b)\) family a fixed triangle has
\(r_T=\operatorname{Re}b\), so unit complex \(b\) realizes every
\(t=r_T^2\in[0,1]\).  Theorem B supplies the three coordinates.  Each such
point saturates both pairwise inequalities, so no distinct point can dominate
it; hence the segment is exactly the Pareto frontier.

### Decision after `aa`

The scalar mixed-plane Pareto ceiling is therefore **settled**, not merely an
open attack direction.  What remains is the complete nonmaximal semialgebraic
image, complex-valued diagonal controls, and higher-order/larger-conference
analogues.  Those are distinct future questions and are not needed for the
paper-review candidates recorded here.

## 8. Structural-compression `ej2`

The parity/Pfaffian proof yields three further theorem-level consequences at
essentially no additional cost.

### One scalar sector already detects rigidity

For an order-six Hermitian conference matrix, the following are equivalent:

1. the full balanced exchange spectrum is cut-independent;
2. the filled-fermion statistic \(e_3\) is cut-independent;
3. the symmetric statistic \(h_3\) is cut-independent;
4. the mixed statistic \(s_{(2,1)}\) is cut-independent;
5. the matrix is switching/permutation equivalent to the real symmetric
   conference class.

Indeed, Theorem B makes each statistic in items 2--4 an injective affine
function of \(r_T^2\).  Constancy of any one therefore makes \(|r_T|\)
constant, and Theorem C applies.  Conversely the real class has
\(r_T^2=1\) on every cut.  By contrast, \(p_1,p_2,e_2\) are identically
cut-independent throughout the complex class and cannot witness rigidity.

Thus the full-spectrum hypothesis in Theorem C can be replaced by any single
degree-three Schur sector.  This is the minimal operational formulation of the
complex rigidity theorem.

### Exact averaged phase-defect functional

Choose one triple from each of the ten complementary balanced-cut pairs and
define

\[
 \delta(C)=1-\frac1{10}\sum_T r_T^2.
\]

Then \(0\le\delta(C)\le1\), and the exact cut averages are

\[
\begin{aligned}
 \overline{e_3}&=\frac{16}{125}+\frac4{125}\delta(C),\\
 \overline{h_3}&=\frac{313}{125}+\frac4{125}\delta(C),\\
 \overline{s_{(2,1)}}&=\frac{200}{125}-\frac4{125}\delta(C).
\end{aligned}
\]

Moreover \(\delta(C)=0\) if and only if \(C\) is in the real switching
class.  Hence the real class simultaneously minimizes the averaged symmetric
and filled-fermion sectors and maximizes the averaged mixed sector.  The same
nonnegative holonomy defect measures all three deviations, so three landscape
averages contain only one new scalar.

### Quantitative parity gap and general Pfaffian obstruction

Let \(A\) be the pentagon sign matrix and let \(B\) be any skew sign matrix of
order five.  For \(M=AB+BA\), the three-entry identity in Theorem C has a
right side equal to twice an odd integer.  Every entry of \(M\) is even, so at
least one of \(M_{02},M_{03},M_{23}\) has absolute value at least two.  Since
\(M\) is skew,

\[
 \lVert AB+BA\rVert_F^2\ge8.
\]

Consequently an equal-holonomy ansatz
\(S=\sqrt tA+i\sqrt{1-t}B\) with \(0<t<1\) has the explicit conference-equation
defect

\[
 \left\lVert\operatorname{Im}(S^2)\right\rVert_F
 \ge \sqrt{8t(1-t)}.
\]

This is a robust falsifier for numerical near-solutions inside the ansatz, not
a global metric stability theorem for arbitrary Hermitian conference matrices.

The endpoint argument also has a reusable form: if an integral skew-symmetric
matrix \(K\) of order \(2m\) satisfies \(K^2=-qI\), then

\[
 q^m=\det K=\operatorname{Pf}(K)^2.
\]

Thus \(q^m\) must be a square; when \(m\) is odd, \(q\) itself must be a
square.  The impossible order-six endpoint is the case \((m,q)=(3,5)\).

### `ej2` disposition

- **Keep:** the single-sector rigidity equivalences and the averaged defect
  formulas; these materially simplify both theorem statement and operational
  interpretation.
- **Keep as proof support:** the three-entry parity identity and Pfaffian-square
  endpoint obstruction.
- **Defer:** a genuine stability theorem bounding distance to the real
  switching orbit from small \(\delta(C)\); compactness gives only qualitative
  control without a new quantitative argument.
