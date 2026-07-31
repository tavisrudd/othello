# C730 — Paper III arithmetic--harmonic orientation source theorem

**Lane:** `clebsch`

**Status:** complete; frozen source interface ready for C680

> **C733 supersession.**  The normalized-cover calculation remains valid, but
> the sheet-to-source comparison below is now read relative to the frozen axis,
> plane-triple, Petersen, and chart-lift marking.  C733 proves that the sheet
> alone does not determine those data, supplies the complete ambiguity ledger,
> and proves the global Stein algebra needed for the unnormalized chart
> factorization.  The submission-facing statement and claim map are in
> `notes/2026-07-31-c733-paper-iii-relative-orientation-bridge.md`.

## Result

Paper III's arithmetic and harmonic cubics are two realizations of one
oriented Clebsch coordinate line.  The common datum is supplied by a chosen
sheet of Hitchin's incidence cover on the golden Clebsch chart.  With the
frozen six-axis marking and volume orientation, that sheet determines

\[
 ([C],[Z_C]),
 \]

where \([C]\) is the switching class of the order-six golden conference
matrix and

\[
 Z_C(x)=\sum_{i<j<k}C_{ij}C_{jk}C_{ki}x_ix_jx_k
\]

is its oriented triangle cubic.  The same choice fixes the linear lift of
Hitchin's projective Clebsch chart.  Through the primitive pair-sum map

\[
 \beta:(y_i)_{i=1}^5\longmapsto (y_i+y_j)_{i<j},
 \qquad \sum_i y_i=0,
\]

it therefore fixes the sign of the cubic line in the Petersen degree-six
harmonic realization.

The statement is an identification of orientation torsors, not an equality
between \(Z_C\) and \(\sigma _3\).  They live on different representations:
\(Z_C\) is a cubic on the five-dimensional six-axis augmentation module,
whereas \(\sigma _3\) is the unique cubic on the four-dimensional five-letter
module.  The source class \(([C],[Z_C])\) selects the sign of the latter
through the incidence odd generator and the linearized Clebsch chart.  No
ambient map between harmonic degrees three and six is constructed.

## Frozen interfaces

Let

\[
 E=\mathbf Q(t),\qquad t^2-t-1=0,\qquad s=2t-1=\sqrt5.
\]

The relevant spaces and their dimensions are:

| object | dimension | field or base | role |
|---|---:|---|---|
| harmonic cubics \(H_3\) | 7 | \(\mathbf Q\) | base of Hitchin's incidence cover |
| isotropic plane \(U_t\) | 3 | \(E\) | chosen incidence sheet |
| Clebsch chart \(V_t=U_t^\perp\) | 4 | \(E\) | degree-three realization |
| abstract Clebsch module \(V=\{\sum y_i=0\}\) | 4 | \(\mathbf Q\) | common coordinate carrier |
| six-axis permutation module | 6 | \(\mathbf Z\) after marking | carrier of \(C\) |
| six-axis augmentation quotient | 5 | \(\mathbf Z\) | carrier of \(Z_C\) |
| Petersen coefficient module | \(1+4+5\) | \(\mathbf Z\) | pair-label carrier |
| Petersen \((-2)\)-eigenspace | 4 | \(\mathbf Q\) | image of \(\beta\) |
| degree-six harmonics \(H_6\) | 13 | \(\mathbf R\) | zonal harmonic realization |

The six oriented golden axes are

\[
\begin{split}
 a_0&=(0,t,1),&a_1&=(0,t,-1),&a_2&=(1,0,t),\\
 a_3&=(-1,0,t),&a_4&=(t,-1,0),&a_5&=(-t,-1,0).
\end{split}
\]

Their Gram matrix is

\[
 G=(t+2)I+tC,
\]

with the C711 conference matrix \(C\), and the tight-frame identity gives
\(C^2=5I\).  Axis sign changes switch \(C\) to \(DCD\), while the triangle
products and \(Z_C\) remain unchanged.

## The source theorem

Let \(B=\mathbf P(V_E)\), let
\(\iota_t:B\to\mathbf P(H_E)\) be Hitchin's Clebsch chart, and let
\(u=\sigma _3\), viewed as a section of \(\mathcal O_B(3)\).  Let
\(\mathcal N\to\mathbf P(H)\) be the normal finite cover in Hitchin's
quadratic incidence field.

> **Arithmetic--harmonic orientation-source theorem.**
> The normalization of
> \(B\times_{\mathbf P(H)}\mathcal N_E\) is canonically
> \[
> B_+\amalg B_-.
> \]
> The section supplied by the fixed isotropic plane \(U_t\) identifies one
> component, and incidence deck exchange identifies the other.  After the
> odd generator is normalized on the \(U_t\)-component, the two components
> have equations
> \[
> z=4s\,u,\qquad z=-4s\,u.
> \]
> They correspond respectively to the oriented source classes
> \(([C],[Z_C])\) and \(([-C],[-Z_C])\).
>
> On \(D(u)\), this is the actual finite-etale two-sheet incidence cover and
> both points are distinct regular icosahedral configurations.  Along
> \(u=0\), the unnormalized pullback has two branches meeting, while its
> normalization remains \(B_+\amalg B_-\).  Thus \(D(u)\) is the maximal
> locus with the literal two-distinct-configuration interpretation.
>
> The primitive \(A_5\)-equivariant map
> \(\beta(y)=(y_i+y_j)\) identifies the chart's four-module with the
> Petersen \((-2)\)-eigenspace.  If
> \[
> F_y(\omega)=\sum_{i<j}(y_i+y_j)P_6(u_{ij}\mathbin\cdot\omega),
> \]
> then
> \[
> \langle F_y,F_y\rangle
>   =\frac{140}{351}\sum_i y_i^2,
> \qquad
> \frac1{4\pi}\int_{S^2}F_y^3
>   =-\frac{784000}{1247103}\sigma _3(y).
> \]
> Deck exchange negates the oriented source, the selected chart lift, and
> the resulting harmonic cubic generator.  Hence the arithmetic square
> root and the degree-six Gaunt cubic are realizations of the same
> orientation torsor.

The theorem stops at \(([C],[Z_C])\).  It asserts no outer-six, Pfaffian,
cross-golden, Segre--Igusa, Cartan, Majorana, anomaly, exceptional-parent, or
lattice shadow.

## Proof

### 1. Normalize the pulled-back incidence cover

Hitchin's branch theorem and the Paper III square-class calculation give the
quadratic field

\[
 \mathbf Q(\mathbf P(H))(\sqrt{5J_0}).
\]

On the Clebsch chart, Hitchin's identity is

\[
 \iota_t^*J_0=16\sigma _3^2.
\]

Consequently the pulled-back generic quadratic algebra factors over \(E\):

\[
 z^2-80u^2=(z-4su)(z+4su).
\]

Each factor has function field \(E(B)\), and \(B\) is normal.  The
normalization is therefore the disjoint union of two copies of \(B\).  The
map \(B\to\mathcal I_E\to\mathcal N_E\) defined by the constant isotropic
plane \(U_t\) is generically one of these components and, by normality,
identifies it globally.  Deck exchange identifies the second component.

On \(D(u)\), the two factors differ by the unit \(8su\), so the original
pullback is already their product and is finite etale.  On \(u=0\), the
two factors meet in the unnormalized algebra.  Hitchin's Clebsch-chart
classification says that off the Clebsch cubic there are exactly two
distinct icosahedra, while on it there are one or infinitely many.  This
proves both the global normalization statement and the sharp geometric open
locus.

### 2. Identify the golden involution

Let

\[
 R=\begin{pmatrix}1&0&0\\0&0&-1\\0&1&0\end{pmatrix}.
\]

Write \(a_i'\) for the conjugate axes obtained by \(t\mapsto1-t\).  Direct
substitution gives

\[
 Ra_i=t\,d_i a'_{p(i)},
\]

where

\[
 p=(0,1,5,4,2,3),\qquad
 (d_0,\ldots,d_5)=(1,-1,1,1,1,1).
\]

The identity \(t^2(1-t)=-t\) then gives

\[
 d_id_j C_{p(i)p(j)}=-C_{ij}.
\]

Thus Galois conjugation, transported by the projective orthogonal exchanger,
sends the oriented conference class to its negative.  Since every triangle
contains three conference entries,

\[
 Z_{-C}=-Z_C.
\]

The single negative representative scalar in \(d\) is a switching choice;
switching alone does not change \(Z_C\).  The minus sign above comes from
the golden conjugation of the normalized off-diagonal Gram scalar, and is
therefore not removable by changing axis representatives.

The two incidence components carry a locally constant oriented conference
class on \(D(u)\).  The equality with \(C\) and \(-C\) holds at the point
\([xyz]\) by the displayed calculation.  Since \(D(u)\) is irreducible, it
holds throughout.  Normality extends the labels to the two normalized
components over \(u=0\), where only the literal two-configuration
interpretation fails.

### 3. Fix the Clebsch chart lift

Let \(q_1,\ldots,q_5\) be Hitchin's five products of mutually orthogonal
plane triples, with \(q_1=xyz\) and \(\sum q_i=0\).  They define

\[
 \iota_t(y)=\sum_i y_iq_i.
\]

The exchanger satisfies \(R(xyz)=-xyz\).  After transporting the five
plane-triple labels, the maps from the irreducible four-module to
\(V_{1-t}\) are \(A_5\)-equivariant.  Schur's lemma and the value on \(q_1\)
therefore give

\[
 Rq_i^{(t)}=-q_i^{(1-t)}
\]

for all five labels.  Projectively the chart is unchanged by this common
minus sign, but its linear lift is reversed.  This is the sign that orients
the cubic generator \(\sigma _3\).

This point is essential: \(\sigma _3\) itself is invariant under the full
permutation group \(S_5\).  Its orientation here does not come from the
outer \(S_5/A_5\) character.  It comes from the incidence odd generator
together with the chosen linear lift of the projective chart.

### 4. Compare with the Petersen harmonic realization

Label the ten face axes by the two-subsets of five letters, with Petersen
adjacency given by disjointness.  For \(a_{ij}=y_i+y_j\),

\[
 (Aa)_{ij}=-2a_{ij},
\]

and

\[
 \sum_{i<j}a_{ij}^2=3\sum_i y_i^2,
 \qquad
 y_i=\frac13\sum_{j\ne i}a_{ij}.
\]

Thus \(\beta\) is the primitive integral comparison and becomes an
isomorphism onto the Petersen four-space after inverting \(3\).  If the
coefficient module is given the form
\(3^{-1}\sum a_{ij}^2\), then \(\beta\) preserves the invariant quadratic
forms exactly.

The degree-six zonal map has Gram eigenvalue \(140/1053\) on the Petersen
four-space.  Combining this with the factor \(3\) above gives

\[
 \langle F_y,F_y\rangle=\frac{140}{351}\sum_i y_i^2.
\]

The cubic integral is \(A_5\)-invariant and the cubic invariant line on the
four-module is one-dimensional.  At
\(y=(4,-1,-1,-1,-1)\),

\[
 \sigma _3(y)=20,qquad
 \langle F_y,F_y\rangle=\frac{2800}{351},qquad
 \frac1{4\pi}\int F_y^3=-\frac{15680000}{1247103}.
\]

One vector therefore gives the asserted scalar
\(-784000/1247103\).  Reversing the chart lift sends \(y\) and \(F_y\) to
their negatives and reverses the cubic integral.  This completes the
orientation-torsor comparison.

## Involution ledger

| operation | incidence odd generator | conference datum | triangle cubic | Clebsch/harmonic lift |
|---|---|---|---|---|
| incidence deck exchange | \(z\mapsto-z\) | \([C]\leftrightarrow[-C]\) | \(Z_C\mapsto-Z_C\) | linear lift and \(F_y\) change sign |
| golden Galois plus \(R\) | exchanges golden components | \(C\mapsto-C\) after \((p,d)\) transport | negated | \(Rq_i^{(t)}=-q_i^{(1-t)}\) |
| conference reversal | swaps source orientation | \(C\mapsto-C\) | negated | selects the opposite lift |
| axis switching | unchanged | \(C\mapsto DCD\) | unchanged | orientation must be transported |
| common chart scaling by \(-1\) | unchanged projectively | unchanged | unchanged | \(\sigma _3\) and \(F_y^3\) generators reverse |
| projective scaling of a cubic | no change to the point | no change | no change | does not erase the linearized sign |

The table separates three operations that are easy to conflate.  Switching
changes representatives but not the source orientation.  Conference
reversal changes the source orientation.  Common scaling of the five
plane-triple cubics leaves the projective chart fixed but reverses the chosen
linear cubic generator.

## Integral and bad-prime boundary

The exact boundary has four layers.

1. The conference identity \(C^2=5I\), the triangle signs, and translation
   invariance of \(Z_C\) are integral over \(\mathbf Z\).  Modulo \(2\),
   \(C\) and \(-C\) coincide and all triangle signs merge, so orientation is
   lost.  Prime \(5\) is the ramification prime of the golden algebra.
2. The factorization
   \(z^2-80u^2=(z-4su)(z+4su)\) is integral over
   \(\mathbf Z[t]/(t^2-t-1)\), and its characteristic-zero normalization is
   the product of the two normal chart components.  An ordinary separated
   etale-sheet interpretation requires \(2\), \(5\), and \(u\) invertible.
3. The pair-sum map is integral and primitive.  Its displayed inverse and
   the direct-summand identification require \(3\) invertible.  In the
   present spherical normalization the quadratic scalar is \(140/351\), and
   the cubic scalar has denominator supported at
   \(3,11,13,17,19\).  These are normalization denominators, not asserted
   bad-reduction primes of the incidence geometry.
4. The actual Mukai--Umemura/Hitchin incidence scheme has only been compared
   with the rational model in characteristic zero and after spreading out
   over some \(\mathbf Z[1/N]\).  The cited sources and current equations do
   not determine the complete prime support of \(N\).  Primes \(2,3,5\) are
   structurally forced by the two-sheet, icosahedral, and golden interfaces;
   no claim that they are the only geometric bad primes is proved.

This is the sharp C730 disposition.  Determining the minimal geometric
localization requires an explicit integral Grassmannian incidence model,
flatness and normality proofs, and comparison of its Stein algebra.  That is
an unallocated integral-model problem, not a gap that C680 may hide by
writing “away from \(2,3,5\).”

## Lean boundary

No new Lean surface is required for C730.  C712 already formalizes the
conference square, switching invariance, triangle reversal interface,
augmentation descent, and the finite golden source package.  The Petersen
and Gaunt normalizations already have primary and independent exact replays.
The new load-bearing step is normalization of a pulled-back incidence cover
and its extension across the branch divisor; representing only its scalar
factorization in Lean would not formalize that scheme-theoretic argument.
Duplicating C712 or claiming a formal global incidence theorem would weaken
the trust statement.

## Novelty audit

The audit discusses five individual sources.  Four were read at `full text`
depth and one at `partial` depth.  It carries forward C669's bounded search
and adds exact searches for the orientation-cover/conference/Petersen
combination.  No consulted source identifies the normalized pullback of
Hitchin's incidence cover with the golden conference orientation and then
transports its sign to the degree-six Petersen/Gaunt cubic.  This licenses
only a scoped statement such as “the comparison below packages these known
and exact constructions into one normalized orientation source.”  It does
not license an unqualified claim of novelty.

### Source depths

1. **Nigel Hitchin, _Spherical harmonics and the icosahedron_.**
   Read depth: `full text`, arXiv v1/published-paper text, cache key
   `10.1090/crmp/047/14`, SHA-256
   `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`.
   Sections 3--4 and 7--10 supply the five plane triples, Clebsch chart,
   two-icosahedron incidence, branch sextic, and
   \(J_0|_V=16\sigma _3^2\).  Hitchin does not introduce the conference
   orientation or degree-six Petersen harmonic comparison.
2. **Nigel Hitchin, _Vector bundles and the icosahedron_.**
   Read depth: `full text`, arXiv v1/published-paper text, cache key
   `10.1090/conm/522/10292`, SHA-256
   `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.
   Sections 3--5 establish the isotropic-plane incidence and degree two;
   Sections 7--9 give the Clebsch and invariant-sextic geometry.  It does
   not state the arithmetic orientation-source comparison.
3. **Igor Dolgachev, _Petersen Graph and Icosahedron_.**
   Read depth: `full text`, seven-page author-hosted PDF accessed
   2026-07-31 at
   `https://sites.lsa.umich.edu/idolga/wp-content/uploads/sites/1334/2024/08/petersen-Dolgachev.pdf`;
   no DOI or arXiv cache key was available.  It relates the Petersen graph,
   quintic del Pezzo surface, Clebsch cubic, its Hessian/Enriques surface,
   and icosahedral face centers.  It contains no spherical-degree-six or
   Hitchin-cover theorem.
4. **Tathagata Basak, _Petersen graph and monodromy of the 27 lines on the
   Clebsch surface_.**  Read depth: `full text`, arXiv v1, cache key
   `arXiv:2607.01878`, SHA-256
   `1bd34c5689921f5bffb24cd1cb98db41bc18ac3eba617e2daf4f2e340dd3f7aa`.
   It uses the Petersen graph to describe explicit monodromy permutations
   of the 27 lines in the Sylvester family.  Its golden quadratic formulas
   concern the twelve lines and do not identify Hitchin's harmonic-cubic
   cover, a conference orientation, or the degree-six Gaunt realization.
5. **Steinhardt--Nelson--Ronchetti, _Bond-Orientational Order in Liquids and
   Glasses_.**  Read depth: `partial`, published PDF introduction, Section
   II, equations (1.1)--(2.6), Figure 2, and Table I, as recorded by C669;
   cache key `10.1103/PhysRevB.28.784`, SHA-256
   `0efaad674f48c98b716e6732c63e2b04b0d5339c0844c733e72d09d58d041fc5`.
   It owns the standard \(Q_l,W_l\) observables and the \(l=6\)
   icosahedral channel, not the exact Petersen/Clebsch restriction.

### Search coverage

The following queries were run on 2026-07-31.

- OpenAlex `search=Hitchin incidence Clebsch orientation conference
  matrix&per-page=10` returned `meta.count=0` in a valid response.
- OpenAlex `search=Clebsch cubic Petersen degree six spherical harmonic
  icosahedron&per-page=10` returned `meta.count=0` in a valid response.
- Crossref `query.bibliographic=Hitchin incidence Clebsch orientation
  conference matrix&rows=10` reported 8,330,469 broad matches.  The first
  ten title records were screened; none concerned this combination.
- Crossref `query.bibliographic=Clebsch cubic Petersen degree six spherical
  harmonic icosahedron&rows=10` reported 611,715 broad matches.  The first
  ten title records were screened; none was close.
- Web phrase searches for `"orientation cover" icosahedron Clebsch`,
  `"Petersen" "Clebsch cubic" harmonic`, `"conference matrix"
  icosahedron "Clebsch"`, and `"degree-six" Petersen icosahedral harmonic
  cubic` recovered Dolgachev and Basak as the two close-looking sources;
  both were promoted to full-text review above.

C669's earlier OpenAlex, Crossref, arXiv, and phrase searches remain part of
the harmonic-side coverage.  MathSciNet and Google Scholar were not covered.
No forward-citation closure is claimed, so citation-graph enumeration is not
used.  The access gaps prevent an unqualified priority statement.

## Exact audit and reproducibility

From `/home/tavis/src/othello`, run:

```text
python3 notes/2026-07-31-c730-orientation-source.py --check
python3 notes/2026-07-31-c730-orientation-source-replay.py
```

The primary standard-library generator checks the golden axis Gram matrix,
\(C^2=5I\), the exact exchanger permutation and representative scalars,
\(C\mapsto-C\), all twenty triangle signs, the Petersen eigenvalue,
quadratic similarity, inverse pair-sum formula, cover scalar factorization,
and the pinned harmonic witness.  The replay implements the golden field
and all involution/Petersen checks independently and reads only the canonical
certificate.  The existing harmonic evidence has its own independent replay.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-31-c730-orientation-source.py` | 9,016 | `96f6098277c54910ea0647e7ba0d4ab7aeccce40700715accabc0236e9f63493` |
| `notes/2026-07-31-c730-orientation-source-replay.py` | 3,327 | `061235688a5631828941304bf4d76470f2c6b6190ebcba313c1eedad07cdb971` |
| `notes/2026-07-31-c730-orientation-source.json` | 3,627 | `27b68a262c22a13344646aa34c9e0931428ae7c20c7dc32e71fef7e3a1642ea6` |
| `papers/clebsch-passages/verification/evidence/harmonic_clebsch.json` | 13,406 | `ecdff5d58327b07e0a26f4bfdf83fd403c47bf5b34cdf856bfc3c9d053b9fa17` |

The programs do not prove normalization, extension across the branch
divisor, irreducibility of the open chart, or Hitchin's classification.
Those are the human and cited geometric steps above.

## Frozen claim map for C680

C680 may import only the following claims.

| Paper III claim | proof mode | C730 source |
|---|---|---|
| normalized pullback is two chart components | human scheme proof using Hitchin's branch and chart identities | Source theorem, proof step 1 |
| maximal literal two-configuration locus is \(D(\sigma _3)\) | Hitchin classification plus normalization | Source theorem, proof step 1 |
| chosen sheet determines \(([C],[Z_C])\) | C711 human theorem plus C730 exact involution | proof step 2 |
| deck/Galois/conference/cubic signs agree | human equivariance plus exact certificate | proof steps 2--3 and involution ledger |
| Petersen comparison is canonical and quadratically normalized | representation proof | proof step 4 |
| exact quadratic and cubic harmonic scalars | one-vector structural calculation, primary and replay audit | proof step 4 |
| geometric integral comparison remains over unspecified \(\mathbf Z[1/N]\) | proved evidence boundary | integral boundary |

C680 should write one short source-interface section, revise the opening and
conclusion around the theorem, and retain the existing arithmetic and harmonic
proof sections as its two realizations.  It must state explicitly that
\(Z_C\) and \(\sigma _3\) are different cubics on different modules and that
the theorem identifies their orientation source rather than their polynomial
domains.

## Extra-juice and Tao closeout

The closeout gives four cheap upgrades.

1. The comparison globalizes after normalization across
   \(\sigma _3=0\); the genuine boundary is interpretive, not algebraic.
   The unnormalized cover pinches the components there, while normalization
   remembers both orientations.
2. The exact exchanger calculation separates an odd axis-representative
   switch from golden conjugation.  Switching leaves \(Z_C\) fixed;
   conjugation is what negates it.
3. The harmonic bridge has a canonical quadratic normalization before the
   cubic is evaluated:
   \(\sum a_{ij}^2=3\sum y_i^2\) and
   \(\langle F_y,F_y\rangle=(140/351)\sum y_i^2\).
   The Gaunt coefficient is therefore a period of the same normalized
   four-module, not a basis coincidence.
4. The sharp negative is structural: no ambient \(SO_3\)-equivariant linear
   map can connect \(H_3\) and \(H_6\), since they are inequivalent
   irreducibles of dimensions 7 and 13.  The canonical map appears only
   after choosing the incidence sheet and restricting to its Clebsch
   four-space.  This explains why the theorem naturally stops at the source
   interface.

## Mystery ledger

- **Why the incidence square root and harmonic cubic have the same sign:**
  settled by the chosen normalized component, the golden exchanger
  \(C\mapsto-C\), and the common reversal of the Clebsch chart lift.
- **Whether the two cubics are literally the same polynomial:** settled
  negatively.  \(Z_C\) is on the six-axis augmentation five-space;
  \(\sigma _3\) is on the five-letter four-space.  Their common object is
  the orientation torsor.
- **What happens on \(\sigma _3=0\):** settled.  The unnormalized pullback
  branches meet, its normalization remains two copies, and the
  two-distinct-icosahedron interpretation fails exactly there.
- **Whether switching causes the sign reversal:** settled negatively.
  Switching fixes triangle holonomy; golden conjugation negates the
  normalized conference operator.
- **Why the Petersen map is canonical:** settled by multiplicity one,
  primitivity, the quadratic identity, and the explicit inverse after
  inverting \(3\).
- **Exact full geometric bad-prime set:** open.  The missing evidence is an
  integral Mukai--Umemura incidence model with flatness, normality, and Stein
  comparison.  No successor is allocated; C680 must retain the unspecified
  localization.
- **Ambient degree-three-to-degree-six covariant:** settled at the linear
  level negatively by irreducibility and dimension.  Nonlinear ambient
  covariants are outside C730 and are not needed by Paper III.

Vibe check: the source theorem is strong and clean at the normalized-cover
level.  Its best feature is the honest distinction between a global algebraic
comparison and the smaller open locus where both sheets remain two distinct
icosahedra; the unresolved integral localization is real but does not weaken
the characteristic-zero theorem.
