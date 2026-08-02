# C818 — mixed-plane stability and promotion audit

**Date:** 2026-08-02

**Lane:** `golden`

**Scope:** C814's continuous-control theorem, Hermitian order-six exchange
Pareto segment, single-sector rigidity, averaged holonomy defect, and
parity/Pfaffian certificate

## Verdict

C818 closes the remaining mathematical ceiling at the level that is both
classification-free and structurally honest.

Eight individually characterized sources support this audit: **three were
read at full-text depth**, four at partial depth, and one at
abstract/metadata-only depth.  Two of the full-text reads are inherited from
recorded Golden audits.  The negative verdict is bounded further by the
screened-set and coverage statements below.

1. The averaged holonomy defect gives a **global lower bound** on Frobenius
   distance to the real conference orbit.
2. Below an explicit defect threshold it also gives a **linear upper bound**:
   dephasing and entrywise sign rounding necessarily produce an exact real
   conference matrix.  This is a genuine local stability theorem for the full
   Hermitian conference space, not merely for Et-Taoui's displayed family or
   for C814's equal-holonomy ansatz.
3. The certificate compresses to three ideas: root-triangle coordinates,
   triangle-product Lipschitz control, and even-integral parity in the rounded
   conference equation.  No family classification or finite census is
   load-bearing.
4. The literature audit finds substantial adjacent prior art.  Triangle
   products and ordinary three-uniform ETF spectra are established, and the
   full order-six Hermitian conference class has been classified.  The
   squared cross-block spectrum, its Schur-sector Pareto transfer, and the
   defect-to-real-orbit stability statement were not found in the bounded
   search.  They remain qualified research candidates, not priority-cleared
   claims.
5. **Do not promote this package into the current paper.**  The continuous
   real-control theorem is a clean strengthening but would require another
   principal result and proof.  The complex mixed-plane branch changes the
   paper's declared object from real symmetric conference matrices to the
   Hermitian conference moduli space, while its closest classification source
   was reached only at abstract/slides depth.  On a fourteen-page manuscript
   whose present spine is orientation, the exact real Boolean benchmark, and
   implementation boundaries, that is a scope and literature-trust regression.
   Preserve C814/C818 as a sequel-ready mathematical module.

No manuscript file was changed.

## 1. Metric and invariant

Let \(\mathcal H_6\) be the Hermitian conference matrices of order six:

\[
 C=C^*,\qquad C_{ii}=0,\qquad |C_{ij}|=1\ (i\ne j),\qquad C^2=5I.
\]

For an unordered triangle \(T=\{i,j,k\}\), orient it cyclically and put

\[
 z_T(C)=C_{ij}C_{jk}C_{ki},\qquad r_T(C)=\operatorname{Re}z_T(C).
\]

The square \(r_T^2\) is independent of the orientation.  Complementary
three-subsets have the same \(r_T^2\): their cross blocks have the same
nonzero squared singular spectrum, and C814's triangle formula recovers
\(r_T^2\) from that spectrum.  Hence

\[
 \delta(C)=1-\frac1{10}\sum_{T\in\mathcal P}r_T(C)^2
           =\frac1{20}\sum_{|T|=3}\bigl(1-r_T(C)^2\bigr)
\]

is well-defined for any set \(\mathcal P\) of representatives of the ten
complementary pairs.  It is invariant under diagonal unitary switching and
permutation.

Let \(\mathcal R_6\) be the real symmetric conference matrices of order six,
and define the unnormalised switching-orbit distance

\[
 d_{\mathbb R}(C)^2=
 \inf_{R\in\mathcal R_6,\,D,\,P}
 \left\|C-DPRP^{\mathsf T}D^*\right\|_F^2,
\]

where \(D\) is diagonal unitary and \(P\) is a permutation matrix.

## 2. Classification-free stability theorem

### Theorem C818

For every \(C\in\mathcal H_6\),

\[
 \boxed{\frac{10}{3}\,\delta(C)\le d_{\mathbb R}(C)^2.}
\]

Set

\[
 \delta_0=\frac{6-\sqrt{35}}{20}.
\]

If \(\delta(C)<\delta_0\), then

\[
 \boxed{d_{\mathbb R}(C)^2\le40\,\delta(C).}
\]

More precisely, dephase any chosen row and column of \(C\) to ones and round
each of the ten other upper-triangular entries to the sign of its real part.
The resulting real sign matrix is an exact order-six conference matrix.

The constants are explicit rather than claimed sharp.  Numerically,
\(\delta_0\approx0.00419601\).

### Proof: global lower bound

Fix any aligned real-orbit representative \(R\).  For every triangle,
\(w_T=z_T(R)\in\{\pm1\}\), and

\[
 1-r_T(C)^2\le |z_T(C)-w_T|^2.
\]

The inequality holds whether or not \(w_T\) is the nearer sign: for the nearer
sign it is
\((1-|r|)(1+|r|)\le2(1-|r|)\), and the farther sign only increases the
right-hand side.  Telescoping the product of three unit-modulus edge entries
and applying Cauchy--Schwarz gives

\[
 |z_T(C)-z_T(R)|^2
 \le3\sum_{e\subset T}|C_e-R_e|^2.
\]

Each of the fifteen edges belongs to four of the twenty triangles.  Therefore

\[
 20\delta(C)
 \le12\sum_e|C_e-R_e|^2
 =6\|C-R\|_F^2.
\]

Taking the infimum over the real orbit proves the lower bound.

### Proof: local upper bound

Dephase row and column zero, so \(C_{0j}=C_{j0}=1\).  The ten root triangles
\(\{0,i,j\}\) form one representative from each complementary pair, and
their real holonomies are \(\operatorname{Re}C_{ij}\).  Thus

\[
 10\delta(C)=\sum_{1\le i<j\le5}
              \bigl(1-(\operatorname{Re}C_{ij})^2\bigr).
\]

Let \(R_{0j}=1\), and for \(1\le i<j\le5\) let
\(R_{ij}=\operatorname{sgn}(\operatorname{Re}C_{ij})\), with symmetric lower
triangle and zero diagonal.  Since \(|u|=1\),

\[
 |u-\operatorname{sgn}(\operatorname{Re}u)|^2
 =2(1-|\operatorname{Re}u|)
 \le2\bigl(1-(\operatorname{Re}u)^2\bigr).
\]

Counting both matrix triangles gives

\[
 x^2:=\|C-R\|_F^2\le40\delta(C).
\]

Now \(C^2=5I\), \(\|C\|_2=\sqrt5\), and
\(\|R\|_2\le\sqrt5+x\).  Hence

\[
 \|R^2-5I\|_2
 \le x(2\sqrt5+x).
\]

Every off-diagonal entry of \(R^2\) is a sum of four signs and is therefore
an even integer; every diagonal entry is already five.  If

\[
 x(2\sqrt5+x)<2,
\]

then every off-diagonal entry has absolute value strictly below two and must
vanish.  Thus \(R^2=5I\).  The sufficient condition

\[
 40\delta(C)<(\sqrt7-\sqrt5)^2=12-2\sqrt{35}
\]

is exactly \(\delta(C)<\delta_0\).  The constructed \(R\) lies in the real
conference orbit and supplies the upper bound.

### What this does and does not close

- It proves quantitative rigidity in a neighbourhood of the real orbit and a
  global coercive lower bound.
- It does not assert that \(40\) or \(\delta_0\) is optimal.
- It does not use the published classification of Hermitian conference
  matrices of order six, so the broader equivalence convention in that source
  cannot contaminate the theorem.
- A global reverse inequality for all \(\delta\) would follow from an
  explicitly compatible exhaustive normal form, but is not needed for local
  stability and is deferred until the full classification proof is available.

## 3. Structural certificate compression

The complete mixed-plane certificate can now be presented as the following
short dependency chain.

1. **Triangle chart.**  After root dephasing, the ten non-root edge phases are
   exactly the ten projective balanced-cut holonomies.  C814's block identity
   makes each exchange statistic an affine function of their squared real
   parts.
2. **Exact extremal rigidity.**  Constant squared holonomy reduces in the
   interior to a pentagon sign matrix \(A\) and a skew sign matrix \(B\).
   Three entries of \(AB+BA\) give an odd-equals-even contradiction.  The
   purely imaginary endpoint gives the nonsquare determinant
   \(5^3=125\), impossible for an integral skew Pfaffian square.
3. **Stable rigidity.**  Small averaged phase defect makes entrywise rounding
   close in Frobenius norm.  The exact conference equation makes the rounded
   square lie within two of zero, while parity says every off-diagonal entry is
   even.  Therefore it is zero exactly.

This is the requested structural explanation of the certificate.  The
288-case enumeration remains only a replay and falsification aid.

## 4. Claim-level novelty audit

| C814/C818 claim | Closest located prior art | Audit disposition |
|---|---|---|
| Order-six Hermitian conference family/classification | Et-Taoui constructs \(C_6(b)\); Et-Taoui--Makhlouf state a full order-six Hermitian classification. | **Pre-empted as an object/classification.** Cite; never present the family as new. |
| Triangle products as switching invariants | ETF switching equivalence is characterized by triple products in the literature summarized by King. | **Pre-empted invariant language.** |
| Ordinary three-uniform ETF compression spectra | Bodmann--Paulsen introduce real three-uniformity; Hoffman--Solazzo classify complex \(3_c\)-uniform ETFs and compute the three-by-three characteristic polynomial from the real part of the phase. | **Close prior boundary.** Do not identify C814's condition with ordinary three-uniformity. |
| Squared cross-block spectrum and Schur formulas | No exact counterpart located in the bounded search.  C814 depends on \(r_T^2\), not \(r_T\), and studies \(I-C[T]^2/5\), not the principal ETF Gram compression itself. | **Qualified candidate.** |
| Single-sector squared-spectrum rigidity at order six | Hoffman--Solazzo's classification requires constant operator norm/ordinary spectrum and selects purely imaginary Seidel data; C814's condition forgets the sign of \(r_T\) and the conference equation instead forces the real endpoint. | **Qualified candidate, mathematically distinct.** |
| Exact mixed-plane Pareto segment | No counterpart located for the three Schur exchange sectors under real diagonal controls and Hermitian conference deformation. | **Qualified candidate.** |
| Averaged defect formulas | Algebraic consequence of the exact sector formulas; no counterpart located. | **Keep as packaging, not a headline novelty claim.** |
| Defect-to-real-orbit stability theorem | No counterpart located in conference/ETF searches. | **Strongest surviving candidate.** |
| Pentagon parity and Pfaffian proof | Individual parity and Pfaffian facts are classical; their order-six rigidity assembly was not located. | **Proof contribution, not an independent headline.** |
| Full real-control cube optimum | No exact counterpart located.  It is a continuous strengthening of the paper's Boolean benchmark. | **Qualified candidate; best fit for a future revision if space is created.** |

The audit supports mathematical retention but not an unqualified priority
sentence.  Safe language is “we prove” and “within the order-six Hermitian
conference class”; avoid “first”, “new”, and “to our knowledge” until the
coverage gaps below are closed.

## 5. Source records

### Hoffman--Solazzo, *Complex Equiangular Tight Frames and Erasures*

- Identifier: arXiv `1107.2267`, v1; published DOI
  `10.1016/j.laa.2012.01.024`.
- **Read depth: full text.**  All sections and references were read.
- Cache: `arXiv:1107.2267`; SHA-256
  `5f6da01f50151bda65222db553d4f76c0a01a9e064c4b06901ad5bba81d2aec1`.
- Load-bearing content: Definition 3.1, Lemma 3.12, and Theorem 3.10 define and
  classify complex \(3_c\)-uniform ETFs.  Their three-by-three characteristic
  polynomial depends on the real part of a dephased phase.  The paper does not
  study complementary cross-block squared spectra, Schur exchange functions,
  or metric stability to a real conference orbit.

### Bodmann--Paulsen, *Frames, Graphs and Erasures*

- Identifier: arXiv `math/0406134`, v3.
- **Read depth: partial.**  Abstract, introduction, switching preliminaries,
  and the complete real three-uniform argument in Section 5 were read.
- Cache: `arXiv:math/0406134`; SHA-256
  `65482f47b8e510771d9afa3a7616e43b6b7295d5e8c866384bf9d348eca514ff`.
- Load-bearing content: real three-uniformity is an established erasure/frame
  notion, and nontrivial real three-uniform ETFs do not occur.  This is
  adjacent to, but not the same as, C814's squared cross-block condition.

### King, *\(k\)-Homogeneous Equiangular Tight Frames*

- Identifier: arXiv `2505.00160`, v2, 24 December 2025.
- **Read depth: partial.**  Introduction, Proposition 1.5, Section 3's
  three-homogeneity/three-uniformity discussion, and references were read.
- Cache: `arXiv:2505.00160`; SHA-256
  `4d05a63b7c529688183be04815b95160bce6120eecb744fe6038fbe0bfb9e5a9`.
- Load-bearing content: a current primary synthesis records triple products as
  complete switching invariants for ETFs and explicitly places the
  three-by-three characteristic-polynomial calculation and \(3_c\)-uniform
  classification in prior work.

### Et-Taoui, *Complex conference matrices, complex Hadamard matrices and
complex equiangular tight frames*

- Identifier: arXiv `1409.5720`, v1.
- **Read depth: full text, inherited and re-used from C814.**
- Cache: `arXiv:1409.5720`; SHA-256
  `eb45c19abf8fb8ea10c4263c9659e1af9b80050899c38085cf8ed846e582ca66`.
- Load-bearing content: construction of the one-parameter Hermitian family
  \(C_6(b)\) and inequivalence of its parameters.

### Et-Taoui--Makhlouf, *Complex skew-symmetric conference matrices*

- Identifier: DOI `10.1080/03081087.2021.1967848`.
- **Read depth: abstract/metadata only.**  The Taylor & Francis publisher
  abstract and bibliographic page for the published article were retrieved;
  the article body was not reached and no bytes were cached.
- Version characterized: published article, *Linear and Multilinear Algebra*
  (2022); the volume, pages, online-publication date, and DOI used here come
  from the publisher page.
- Load-bearing content: the authors explicitly state that they classify all
  complex symmetric, skew-symmetric, and Hermitian conference matrices of
  order six.
- Limitation: the visible material uses a broad conference-matrix equivalence
  convention only through the separately read slides below.  Without the
  article's theorem proof C818 does not infer a normal form for diagonal
  Hermitian switching.  The stability proof above deliberately avoids that
  dependency.

### Et-Taoui, *Conference matrices* (CodEx seminar slides)

- Identifier: CodEx seminar slides dated 28 September 2021,
  `https://www.math.colostate.edu/~king/codex/slides/EtTaoui_2021_09_28.pdf`.
- **Read depth: partial.**  Slides/pages 4 and 63--64 were read: the stated
  equivalence convention, the order-six classification statement, and the
  immediately following open question.
- Cache: `codex:ettaoui-2021-09-28-slides`; SHA-256
  `6a8909a0878648834df5eede86fcfd98d1f738a18b8d21249c42bd08c0f437a1`.
- Load-bearing content: the slides define equivalence using independent left
  and right diagonal unitary factors and simultaneous permutation.  They also
  state full order-six symmetric/skew/Hermitian classification, then ask
  whether any order-six matrices lie outside the obtained classification.
  C818 treats that wording tension as an access gap rather than resolving it
  by inference.

### Attas--Boussaïri--Souktani, *Characterization of \(k\)-spectrally
monomorphic Hermitian matrices*

- Identifier: arXiv `1907.05817`, v2; DOI
  `10.1142/S1793830925500399`.
- **Read depth: full text, inherited from C788.**
- Cache: `arXiv:1907.05817`; SHA-256
  `a51abeb59f39129514f87c4f28ace738c256679bc866ad3aeb7335662993afe0`.
- Load-bearing content: equality of characteristic polynomials of Hermitian
  principal blocks is a developed classification problem.  C814 instead
  identifies spectra only after squaring and passing to complementary
  cross-block Gramians.

### Cheng--Lv--Sun, *Frames of uniform subframe bounds with applications to
erasures*

- Identifier: DOI `10.1016/j.laa.2018.05.025`.
- **Read depth: partial, inherited from C814.**  The ScienceDirect publisher
  HTML abstract, introduction, Definition 1.1, roadmap, and visible references
  were read; the later theorem body was not reached.
- Version characterized: published-paper HTML.  No PDF bytes were obtained or
  cached.
- Load-bearing content: USB frames require cardinality-dependent common
  subframe bounds.  Because the full classification sections were not read,
  this source supports only adjacency and an explicit promotion gap, not a
  negative claim about its results.

## 6. Search record and gaps

Queries on 2026-08-02 included exact and adjacent combinations of:

```text
"Hermitian conference" "squared spectrum"
"conference matrix" "Bargmann" holonomy
"conference matrix" "principal submatrix" singular values
"diagonal controls" conference matrix Pareto
"Complex equiangular tight frames and erasures"
"Frames, Graphs and Erasures"
"Complex skew-symmetric conference matrices" order 6 Hermitian
```

No exact formula or theorem match was found.  This is a bounded search result,
not evidence of absence.

### Screened sets

- **Exact/adjacent conference set:** the configured web-search service returned
  a combined top-20 result set for the first four queries above.  The screen
  covered displayed title, URL/domain, publication metadata, and result
  snippet.  The discriminator was: retain a result if those fields mentioned a
  Hermitian/complex conference matrix together with a principal-submatrix,
  squared/singular-spectrum, Bargmann/triangle-product, diagonal-control, or
  Pareto claim.  Et-Taoui--Makhlouf and the robust-Hadamard adjacency were
  promoted for inspection; no snippet stated a C814/C818 formula or stability
  theorem.
- **ETF adjacency sets:** two combined top-20 result sets were returned for the
  named-paper and three-uniform queries.  The same displayed fields were
  screened with discriminator: retain sources defining or classifying
  three-uniform ETFs, switching by triple products, or order-six conference
  matrices.  Hoffman--Solazzo, Bodmann--Paulsen, King, and Et-Taoui--Makhlouf
  were promoted to the individual records above.

These sets came from the session's configured web-search broker, not a pinned
bibliographic database, and only the returned top results were screened.  No
verdict in this report rests on an exhaustively enumerated citing-works set, so
the three-graph citation-count protocol was not invoked.

Coverage gaps:

- the Et-Taoui--Makhlouf article body was **NOT REACHED**;
- the Cheng--Lv--Sun USB-frame article body was **NOT REACHED** beyond the
  partial publisher-HTML sections recorded above;
- MathSciNet and Google Scholar were **NOT COVERED**;
- zbMATH Open was screened only at author/result level;
- citation graphs were not exhaustively traversed;
- no subject expert was consulted.

## 7. Promotion decision and future route

### Keep for a sequel or later revision

- the continuous-control joint optimum for the real Golden matrix;
- the holonomy-controlled mixed-plane Pareto segment;
- single-sector squared-spectrum rigidity;
- Theorem C818's local stability estimate;
- the three-lemma structural certificate.

### Do not add to the present manuscript

- the Hermitian conference classification discussion;
- the full mixed-plane segment;
- the defect functional and stability theorem.

The present manuscript already has a complete real symmetric-conference
classification and an operational narrative.  Adding the complex moduli
branch would demand new definitions, at least two citations, a distinction
from ordinary three-uniform ETFs, and a second rigidity proof.  Its
mathematical gain is real, but its paper-level gain is negative at the current
scope.

### Highest-value later move

If the manuscript is reopened for a theorem-strengthening revision, first
test only the continuous-control result as a replacement for the existing
Boolean-boundary paragraph.  Treat the complex Pareto/stability package as a
separate sequel module after the Et-Taoui--Makhlouf full text and the
Cheng--Lv--Sun full text have been audited.  This preserves the current paper's
spine while retaining the strongest new mathematics.
