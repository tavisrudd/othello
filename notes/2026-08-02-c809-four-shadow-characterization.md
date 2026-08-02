# C809 — Four-shadow characterization of the golden operator

**Lane:** `clebsch`  
**Status:** complete; math-only theorem frozen; no paper promotion performed  
**Date:** 2026-08-02

## Outcome

The proposed four-shadow characterization is positive, but its correct form is sharper than “four independent coincidences.” There are only two independent cubic constructions:

1. the triangle cubic; and
2. the diagonal third-compound cubic, which is identically the commutator Pfaffian.

The cross-golden determinant is defined only after the quadratic splitting exists and is then a formal block-determinant consequence of the Pfaffian identity. Thus the actual recognition theorem is the one nontrivial comparison between the triangle and Pfaffian/compound cubics.

On the scalar sign locus, nonzero proportionality of those cubics characterizes the unique order-six symmetric conference switching class. The proportionality sign records the two outer orientations. In the full weighted ambient space, the equality is locally rigid at either golden orientation: its only infinitesimal and local deformation is overall scale.

No manuscript source or public package was changed.

## Definitions and orientation

Let (A=(a_{ij})) be a symmetric (6\times6) matrix with zero diagonal. Put

\[
T_A(x)=\sum_{|S|=3}\tau_Sx_S,
\qquad
\tau_{\{i,j,k\}}=a_{ij}a_{jk}a_{ki}.
\]

Fix the Hodge orientation used by the C704 operator package and define

\[
H_A(x)=\sum_{|S|=3}h_Sx_S,
\qquad
h_S=-\operatorname{sgn}(S^c,S)\det A[S^c,S].
\]

This differs from another standard Pfaffian orientation by one harmless global sign. With this convention, the stored golden representative satisfies (H_A=4T_A).

## Theorem A — universal collapse of two shadows

For every symmetric zero-diagonal (A),

\[
\boxed{\quad
H_A(x)=\operatorname{Pf}_{\mathrm{C704}}[D_x,A].
\quad}
\]

Hence the diagonal of (*\!\circ\!\bigwedge^3A) and the commutator Pfaffian are not two conditions.

### Proof

Expand the Pfaffian of the skew matrix

\[
[D_x,A]_{ij}=a_{ij}(x_i-x_j).
\]

The coefficient of (x_S) is the signed determinant of the bipartite (3\times3) block (A[S^c,S]). The sign is precisely the chosen Hodge orientation. This gives (h_S) coefficient by coefficient. The exact script independently expands the Pfaffian recursively on a nonspecial integer matrix and checks all twenty coefficients against the cross-minor formula.

## Theorem B — proportionality forces the quadratic operator

Work over a field where the proportionality scalar is nonzero. Suppose every off-diagonal entry of (A) is nonzero and

\[
H_A=\mu T_A,
\qquad \mu\ne0.
\]

Then

\[
\boxed{A^2=\lambda I}
\]

for some scalar (lambda).

### Proof

The commutator is unchanged by translation:

\[
[D_{x+t\mathbf1},A]=[D_x,A].
\]

Thus (H_A), and hence (T_A), is invariant under (x\mapsto x+t\mathbf1). The coefficient of (t x_i x_j) in (T_A(x+t\mathbf1)-T_A(x)) is

\[
\sum_{k\ne i,j}\tau_{ijk}
=a_{ij}\sum_k a_{ik}a_{kj}
=a_{ij}(A^2)_{ij}.
\]

Every (a_{ij}) is nonzero, so every off-diagonal entry of (A^2) vanishes. Write (A^2=\operatorname{diag}(d_1,\ldots,d_6)). Since (A) commutes with (A^2),

\[
a_{ij}(d_j-d_i)=0.
\]

Again using nonzero off-diagonal entries gives (d_1=\cdots=d_6=\lambda).

This argument is the conceptual core. It turns a cubic comparison into the golden quadratic relation without an enumeration.

## Theorem C — exact sign-locus characterization

Let (A=sB), where (s\ne0), (B) is symmetric with zero diagonal, and every off-diagonal entry of (B) is in ({\pm1}). Then

\[
H_A\text{ is a nonzero scalar multiple of }T_A
\quad\Longleftrightarrow\quad
B^2=5I.
\]

Up to switching and relabelling, this is the unique order-six symmetric conference matrix. More precisely, in the gauge (b_{0i}=1):

- exactly twelve of the (2^{10}=1024) signings are conference matrices;
- six satisfy (H_B=4T_B);
- the other six satisfy (H_B=-4T_B).

### Human classification

Theorem B gives (B^2=5I). In the gauge (b_{0i}=1), the equations ((B^2)_{0i}=0) say that every vertex of the graph of positive edges on ({1,\ldots,5}) has degree two. The graph is therefore a pentagon. There are twelve labelled pentagons and one class under (S_5).

The pentagon stabilizer (D_{10}) lies in (A_5). Hence the twelve labellings split into two sets of six under even and odd permutations. The Hodge compound acquires the permutation sign while the triangle table does not, producing (+4) and (-4). Thus the sign is an outer-orientation marker; it is not changed by multiplying the whole matrix by (-1), since both cubics have degree three.

Conversely, the standard pentagon representative squares to (5I), and direct complementary-minor expansion gives (H_B=4T_B); odd relabelling gives the other sign.

### Six-test recognition packet

The full twenty-coefficient comparison is unnecessary on the sign locus. In the gauge (b_{0i}=1), the five equations

\[
(B^2)_{0i}=0,
\qquad 1\le i\le5,
\]

force the positive graph on the remaining vertices to be a pentagon and hence force (B^2=5I). Any one coefficient equation (h_S=4\tau_S) then chooses the orientation. The exact census verifies that each of the twenty possible choices of (S) leaves precisely the same six oriented conference matrices. Thus a five-balance-plus-one-orientation packet recognizes the labelled object without comparing four full cubics.

The nonzero qualifier is essential. Exactly 172 gauge signings have (H_B=0) identically even though all 172 matrices are invertible and (T_B\ne0). They form fourteen graph-isomorphism classes under the residual (S_5). Zero is therefore a genuine degenerate component, not a rank-deficient nuisance that may be silently admitted as “proportional.”

## Theorem D — local ambient rigidity

At the displayed golden representative, the Jacobian of the twenty coefficient equations

\[
H_A-4T_A=0
\]

has rank (14) in the fifteen edge variables. Its one-dimensional kernel is the scaling direction (A) itself. The opposite oriented representative has the same rank for (H_A+4T_A=0).

Therefore the real equality locus is locally exactly the scaling line at either golden point; projectively, both points are isolated and reduced. For comparison, the generalized conference equations (A^2=\lambda I) have a five-dimensional tangent space at the same point when (lambda) is included. The cubic equality cuts the four non-scaling tight-frame deformation directions.

This is a local theorem, not a global classification of all weighted real or complex solutions.

## The fourth shadow

Once (A^2=5I), the projectors

\[
P_\pm=\frac12\left(I\pm\frac A{\sqrt5}\right)
\]

and the cross block (B_x=P_-D_xP_+) exist. The already proved block decomposition gives

\[
\det[D_x,A]=8000\det(B_x)^2,
\qquad
\operatorname{Pf}[D_x,A]^2=16T_A(x)^2,
\]

and hence, after orienting determinant lines,

\[
T_A(x)=\pm10\sqrt5\det(B_x).
\]

This fourth shadow is valuable exposition and geometry, but it supplies no extra recognition equation: defining it already uses the quadratic splitting, and its equality follows from the block determinant.

## Why order six is forced

For an even (n\times n) matrix, the Pfaffian of ([D_x,A]) has degree (n/2). The triangle polynomial has degree three. Their unhomogenized proportionality can therefore occur only at

\[
n/2=3,
\qquad n=6.
\]

The numerical order is not an accidental small case. It is the unique degree at which a commutator Pfaffian can recognize a triangle two-graph without auxiliary homogenizing data.

## Exact computation and trust boundary

The evidence bundle is:

- `notes/2026-08-02-c809-four-shadow-characterization.py` — 13,521 bytes, SHA-256 `1ebb1400614e460460805eb01378c93e8822e32a105bc11a43ae3d3518e10920`;
- `notes/2026-08-02-c809-four-shadow-characterization.json` — 3,041 bytes, SHA-256 `096af017fa14a27f19de1146ba772517a3d13f46b08d07b9e2dbc5f575698809`.

Replay from the repository root:

```sh
python3 notes/2026-08-02-c809-four-shadow-characterization.py \
  --check notes/2026-08-02-c809-four-shadow-characterization.json
```

The script uses only Python's standard library and exact integer/rational arithmetic. It checks:

- the Pfaffian/compound identity by two independent expansions on a nonspecial integer matrix;
- the translation-derivative formula on all fifteen pairs;
- all 1,024 gauge signings;
- conference membership independently by direct matrix squaring;
- the 172 zero-shadow cases, their full-rank distribution, and their fourteen (S_5)-orbits; and
- the exact rational Jacobian ranks for both orientations and the generalized conference locus.
- all twenty versions of the five-balance-plus-one-orientation recognition packet.

The computation supports the bounded census and tangent statements. Theorems A--C have the human proofs above. The local conclusion in Theorem D uses the ordinary real implicit-function/Jacobian criterion. The bundle does not classify remote weighted solutions over (mathbf R) or (mathbf C).

## Quick literature boundary

Three external sources were read at full text. This was a bounded terminology and precedence check, not a publication-grade novelty audit, and no priority conclusion is drawn.

1. J. M. Goethals and J. J. Seidel, *Orthogonal matrices with zero diagonal* — **full text**, published version, all sections; cache key `10.4153/CJM-1967-091-8`, SHA-256 `68c0ef0b8fda6d44325382a047a873d2075ed2ad3cf9d0e6ec27ba7ace60b734`. It supplies the classical symmetric conference definition and switching/permutation equivalence, but not the cubic recognition criterion.
2. P. Delsarte, J. M. Goethals, and J. J. Seidel, *Orthogonal matrices with zero diagonal II* — **full text**, published version, all sections; cache key `10.4153/CJM-1971-091-x`, SHA-256 `ff5a4a7c1deba6937a653829cb0699abfb44638eece05e021e3f131770a69a18`. Its normalization theorem shows that real ({0,\pm1}) conference matrices are essentially symmetric or skew according to order; it does not formulate the Pfaffian/triangle criterion.
3. B. Et-Taoui, *Complex conference matrices, complex Hadamard matrices and complex equiangular tight frames* — **full text**, arXiv v1, all sections; cache key `arXiv:1409.5720`, SHA-256 `eb45c19abf8fb8ea10c4263c9659e1af9b80050899c38085cf8ed846e582ca66`. It exhibits a one-parameter complex Hermitian order-six family, which warns that any eventual global complex weighted classification needs a stated real/sign boundary. It does not study the four-shadow equality.

Load-bearing web queries, run verbatim on 2026-08-02, were:

- `"Pfaffian" "conference matrix" commutator diagonal`
- `"compound matrix" "conference matrix" principal minors`
- `"symmetric orthogonal" "zero diagonal" matrix order 6`
- `"principal minors" characterization conference matrices`
- `"Pfaffian of a commutator" diagonal matrix symmetric matrix`
- `"Pfaffian" "diagonal commutator"`

The search surfaced general principal-minor reconstruction and Pfaffian-representation work but no exact match to this recognition statement. That observation licenses only the terminology boundary above. MathSciNet and Google Scholar were not covered; zbMATH was not exhaustively screened. Any manuscript novelty sentence would require a separate full audit in the promotion task.

## `ej` + `tt` closeout

The free structural upgrades are now included:

- the translation-invariance proof replaces the finite census as the causal route from a cubic equality to (A^2=\lambda I);
- the degree count explains intrinsically why order six is the unique unhomogenized triangle/Pfaffian meeting point;
- the tangent comparison quantifies exactly what the cubic equality adds beyond generalized conference orthogonality; and
- the orientation sign is identified with the outer (S_5/A_5) marking rather than global matrix negation.
- the twenty cubic comparisons compress to five row-balance tests plus any single oriented coefficient on the sign locus.

The Tao-style next question is the saturated ideal problem

\[
\langle h_S-4\tau_S:|S|=3\rangle:
\left(\prod_{i<j}a_{ij}\right)^\infty.
\]

Does its real or complex projective locus contain anything beyond the golden orbit? The present theorem proves generalized conference orthogonality everywhere on that torus and proves golden isolation locally, but does not globally eliminate remote weighted components. That is a genuinely different algebraic-classification problem, not needed for the sign-operator characterization.

## Mystery ledger

| feature | status | exact boundary |
|---|---|---|
| Why the cubic and Pfaffian can meet only at order six | settled | degree (3=n/2) |
| Why proportionality forces the conference square | settled | translation invariance plus nonzero edges |
| Why there are two sets of six oriented signings | settled | the pentagon stabilizer lies in (A_5), so odd relabelling flips the Hodge sign |
| Why the equality is stronger than generalized conference orthogonality | settled locally | tangent dimensions (1) versus (5), including scale |
| Global weighted equality locus off the golden scaling lines | open | requires saturation/elimination or a global tight-frame inequality; no paper claim |
| Intrinsic classification of the 172 invertible signings with zero Pfaffian shadow | open but bounded | fourteen residual (S_5)-orbits are certified; this is a degenerate-locus question, not needed for nonzero proportionality |

## Disposition

C809 is complete. The exact math-only result is frozen here. Its strongest defensible headline is:

> Among scalar order-six sign operators, nonzero coincidence of the triangle cubic with the commutator-Pfaffian/third-compound cubic characterizes the golden symmetric conference class; projectively the two oriented solutions remain isolated even inside the full weighted ambient space.

Promotion to Paper III, public novelty positioning, and a fresh cold read remain excluded and require a separately allocated follow-up after explicit user approval.
