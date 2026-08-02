# C814: Golden quantum-statistics mathematical ceilings

**Lane:** `golden`

**Status:** in progress; mathematics research only; no manuscript edit

## Interim verdict

The continuous-control branch has a sharp positive result.  For every Golden
protocol and every real diagonal control (x\in[-1,1]^6), the twenty balanced
sign controls simultaneously maximize the first two squared-singular moments,
all exterior traces through degree three, and all three degree-three Schur
exchange traces.  Equality in any of the three-particle sector maxima forces a
balanced sign control.  Thus the balanced masks are the unique joint Pareto
optimum of the intrinsic three-particle exchange statistics, not merely a
special Boolean stratum.

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

## Mystery ledger (interim)

- **Settled:** balanced sign controls are genuine global, simultaneous
  exchange-sector optima on the full physical filter cube.
- **Settled:** the mixed (S_{(2,1)}) sector has no hidden interior maximizer.
- **Open dependency:** adversarial certificate distance and same-order
  higher-moment separation remain owned by C810 and C812.
- **Open:** whether complex Hermitian conference matrices retain or destroy
  the real cut-rigidity cutoff is the next C814 branch.
- **Deferred:** the complete interior semialgebraic exchange region; it is not
  needed for the sharp operational ceiling.

