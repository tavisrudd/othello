# C653 Hitchin--Clebsch integral and novelty gate

**Lane:** `clebsch`

**Date:** 2026-07-26

## Verdict

C653 closes with a mixed positive and negative boundary.

The rational incidence extension is
\[
 \mathbf Q(\mathbf P(H_3))\bigl(\sqrt{5J_0}\bigr),
 \qquad
 J_0|_{V_I}=16\sigma_3^2.
\]
Thus its restriction to the nonbranch Clebsch chart is the constant golden
torsor.  This is now proved in Paper III from Hitchin's algebraic
Mukai--Umemura incidence construction, the irreducible sextic branch
divisor, and the golden fibre over \(xyz\).

After choosing a lattice and clearing the normalization by a square, the
abstract algebra \(z^2=5J_{\mathbf Z}\) is finite locally free over
\(\mathbf Z\).  Its ordinary etale two-sheet locus is exactly
\(D(10J_{\mathbf Z})\): characteristic \(2\) is inseparable and
characteristic \(5\) is generically nonreduced.  The \(A_5\)-invariant
presentation is proved over \(\mathbf Z[1/30]\), and the cited
binary-sextic formulas are valid fibrewise in characteristic \(0\) or
greater than \(5\).

No consulted source supplies an integral Mukai--Umemura incidence
normalization, and the available equations do not prove that the rational
incidence isomorphism extends at every prime \(p>5\).  The geometric
incidence comparison therefore remains
\[
 \mathcal I_{\mathbf Z[1/N]}\simeq
 X_{\mathbf Z[1/N]}
\]
for an unspecified nonzero \(N\), enlarged so that \(2,3,5\mid N\).  The
paper must not replace this by \(p\ne2,5\).

The audit names six individually discussed sources.  Three were read at
full text, two were read partially at the sections stated below, and the
Mukai--Umemura original was reached at metadata depth only.  It is carried
as an explicit access gap rather than silently credited with an integral
result.

## Rational cover

Let \(\mathcal Z_{\mathbf Q}\subset\operatorname{Gr}(3,H_3)\) be the
Mukai--Umemura threefold of subspaces isotropic for the three Lie-algebra
skew forms, and let
\[
 \mathcal I_{\mathbf Q}
 =\{([f],U):U\in\mathcal Z_{\mathbf Q},\ f\perp U\}.
\]
Hitchin computes \(c_3(\mathcal E^\vee)=2\).  Consequently the projection
\(\mathcal I_{\mathbf Q}\to\mathbf P(H_3)\) is generically degree two.
Hitchin's trichotomy identifies its branch hypersurface with the
geometrically irreducible invariant sextic \(J_0=0\).  Since projective
space has no two-torsion in its Picard group, the function field is
\[
 \mathbf Q(\mathbf P(H_3))(\sqrt{cJ_0})
\]
for one \(c\in\mathbf Q^\times/\mathbf Q^{\times2}\).

On the Clebsch four-space Hitchin computes
\(J_0=16\sigma_3^2\).  At \(f=xyz\), the incidence fibre consists of the
two configurations with \(t^2-t-1=0\).  Since \(J_0(xyz)\) is a nonzero
rational square, this fibre fixes \(c=5\).

This argument proves the rational square class.  It does not prove an
integral normalization comparison.

## Integral and characteristic boundary

The three relevant boundaries are different and must not be collapsed.

| object | largest explicit statement justified here | bad-prime conclusion |
|---|---|---|
| abstract algebra \(z^2=5J_{\mathbf Z}\) | finite locally free over \(\mathbf Z\); finite etale on \(D(10J_{\mathbf Z})\) | exactly \(2,5\) obstruct the ordinary etale two-sheet interpretation |
| classical invariant input | the \(A_5\) presentation over \(\mathbf Z[1/30]\), and the cited binary-sextic formulas fibrewise in characteristic \(0\) or \(p>5\) | \(2,3,5\) are excluded by the nonmodular invariant argument and the cited sextic formulas |
| geometric Mukai--Umemura incidence comparison | some \(\mathbf Z[1/N]\) by spreading out | the minimal prime support of \(N\) is unknown; no all-\(p>5\) theorem is justified |

For the Clebsch invariant algebra, set
\[
 A_R=R[y_1,\ldots,y_5]/(e_1),\qquad R=\mathbf Z[1/30].
\]
Exactness of invariants and the alternating-polynomial factorization give
\[
 A_R^{A_5}
 =R[e_2,e_3,e_4,e_5,\Delta]/(\Delta^2-\operatorname{disc}),
 \qquad
 \Delta=\prod_{i<j}(y_i-y_j).
\]
For the sign-twisted odd coset involution,
\[
 e_i\longmapsto(-1)^ie_i,\qquad \Delta\longmapsto-\Delta.
\]
Hence \(e_3=\sigma_3\) is the first nonconstant odd invariant.  After
localizing at \(e_3^2\), the elementary odd-generator lemma gives the
rank-two decomposition over the even algebra.  In characteristics \(3\)
and \(5\), exactness of invariants fails and modular invariants may appear;
the report makes no extension of this presentation there.

## Prior art and novelty boundary

The following are prior art and are not Paper III novelty:

- Hitchin's Mukai--Umemura incidence variety, its generic length-two fibre,
  its sextic branch/trichotomy, and the binary-sextic \(J_6\);
- Hitchin's restriction \(J_0|_{V_I}=16\sigma_3^2\) and his displayed two
  golden icosahedra on \(xyz=0\);
- Dye's theorem that Clebsch hexagons over a field exist exactly when the
  characteristic is not \(2\) and \(5\) is a square, together with his
  characteristic-\(5\) stabilizer degeneration and finite-field orbit
  results; and
- the classical binary-sextic invariant generators and their
  characteristic-\(>5\) presentation.

The surviving Paper III contribution is narrower:

1. identify the rational square class of Hitchin's known double cover as
   \(5J_0\);
2. state the integral boundary without promoting the abstract quadratic
   algebra to an unproved integral incidence model;
3. connect its deck exchange at \(p=11\) to the spinor
   \(\operatorname{PGL}_2/\operatorname{PSL}_2\) bit and the marked Mathieu
   torsor; and
4. identify the same integral Clebsch cubic line with Paper II's finite
   signed tensor and the degree-six harmonic channel.

The first item is a short arithmetic normalization obtained by combining
Hitchin's cover with the golden fibre.  The headline must therefore be the
arithmetic specialization and cross-characteristic orientation line, not
the existence of the degree-two cover or the square-\(5\) criterion by
itself.

## Source audit

1. **Nigel Hitchin, _Spherical harmonics and the icosahedron_.**
   Read depth: `full text`.  Cached arXiv version `arXiv:0706.0088`,
   SHA-256
   `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`;
   the cached PDF identifies itself as arXiv v1.  Sections 3--4 and 9--10
   supply the Clebsch chart, the two golden configurations, the sextic
   branch, and \(16\sigma_3^2\).  Published metadata:
   doi:10.1090/crmp/047/14.

2. **Nigel Hitchin, _Vector bundles and the icosahedron_.**
   Read depth: `full text`.  Cached arXiv version `arXiv:0906.4208`,
   SHA-256
   `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.
   Sections 4--5 give the Mukai--Umemura zero locus and
   \(c_3(\mathcal E^\vee)=2\); Sections 7--9 give the Clebsch chart,
   trichotomy, binary-sextic realization, and \(J_6\).  Published metadata:
   doi:10.1090/conm/522/10292.

3. **R. H. Dye, _Hexagons, conics, \(A_5\) and
   \(\operatorname{PSL}_2(K)\)_.**
   Read depth: `full text`.  The complete OCR reconstruction was read and
   the load-bearing statements were verified against authoritative scans
   of pages 271, 272, 275, and 279.  Reconstruction SHA-256:
   `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`;
   page-image SHA-256 values are
   `adb117e8dfbb6760f0f088df9f6868351a95f69adc00462cbfd1d7df914012ba`
   (271),
   `eb5e941178f4d5af189754fee9098d6507e98ad493ba54efda64c66180fc350f`
   (272),
   `7ceb086b10c681ba4f6ed07f197cd07c074fde4fb4566b1dbfaac753631b7a86`
   (275), and
   `c78d98da8bc8b138cea032c57e16d5735fb6bed82168b1eea49f0992cdda132b`
   (279), as recorded in the scan-set checksum manifest.  Theorem 1 gives the
   characteristic-not-\(2\), square-\(5\) criterion; Theorem 4 and
   Corollary 2 give the conic stabilizers and finite-field boundary.
   Published version: Journal of the London Mathematical Society (2) 44
   (1991), 270--286, doi:10.1112/jlms/s2-44.2.270.

4. **V. Krishnamoorthy, T. Shaska, and H. V\"olklein,
   _Invariants of Binary Forms_.**
   Read depth: `partial`, cached arXiv version `arXiv:1209.0446`, Sections
   1--3.4, SHA-256
   `33a6b9c20c469d89f21cbbc1e8e4cb3af3934332b7301d1957161dc30ec7620a`.
   Section 3 explicitly assumes characteristic different from \(2,3,5\),
   constructs \(I_2,I_4,I_6,I_{10}\), and proves the
   invariant presentation on the nonzero-discriminant locus.  Its
   historical attribution to Clebsch, Bolza, and Igusa is
   `secondary only` through this partially read modern source; those
   originals were not consulted.

5. **S. K. Donaldson, _Kähler geometry on toric manifolds, and some other
   manifolds with large symmetry_.**
   Read depth: `partial`, cached arXiv version `arXiv:0803.0985`, Section
   5.1, SHA-256
   `ffba3192501f662fb84964a0e69a08606d0bef471a957daff32d269a62dfd1fc`.
   This supplies a second account of the Grassmannian skew-form equations
   and the \(\operatorname{Sym}^6\) model, all explicitly over
   \(\mathbf C\); it supplies no integral comparison.

**Access gap.** Mukai and Umemura, _Minimal rational threefolds_,
doi:10.1007/BFb0099976, was reached at metadata level only; no full text
was available in the cache or through the consulted publisher surfaces.
Nothing in this report is attributed to it beyond the characteristic-zero
construction as reported and proved in the two full-text Hitchin sources.
MathSciNet and Google Scholar were not covered.  Semantic Scholar's API
returned HTTP 429.  zbMATH Open title/author pages were screened, but its
API terms interstitial prevented a reproducible query export.

## Search coverage

The absence claim is limited to an integral incidence comparison and to
the arithmetic \(5J_0\)/mod-\(11\) synthesis.  It is not a claim that no
other work studies the Mukai--Umemura threefold, binary sextics, or
Clebsch hexagons.

The following exact metadata queries were run on 2026-07-26:

- arXiv API:
  `all:"Mukai-Umemura" AND all:icosahedron` — one result, Hitchin's
  _Vector bundles and the icosahedron_;
- arXiv API:
  `all:"ordered icosahedron" OR all:"icosahedral incidence"` — zero
  results;
- arXiv API:
  `all:icosahedron AND all:"square root of 5"` — zero results;
- OpenAlex:
  `search=Hitchin icosahedron Mukai Umemura arithmetic cover` — one
  metadata result, unrelated to the claimed integral comparison;
- Crossref:
  `query.bibliographic=Hitchin icosahedron Mukai Umemura` — the first ten
  results were screened by title, year, and DOI and recovered the two
  Hitchin papers and the Mukai--Umemura source, with no integral-cover
  paper; and
- web title/phrase searches:
  `"Vector bundles and the icosahedron"`,
  `"Hexagons, conics, A5 and PSL2(K)"`,
  `"Minimal rational threefolds" Mukai Umemura DOI`, and
  `binary sextic invariants A5 Clebsch cubic invariant ring`.

The arXiv result sets were screened in full.  The OpenAlex and Crossref
queries were discovery screens over title/metadata, not exhaustive
citation graphs.  No forward-citation count is used in the verdict.

Outcome: no source was located that proves an integral Mukai--Umemura
incidence comparison with bad set exactly \(\{2,3,5\}\) or
\(\{2,5\}\), or that states the combined rational \(5J_0\) normalization
and \(T_{11}\) specialization.  Because MathSciNet, Google Scholar, the
Mukai--Umemura full text, and a reproducible zbMATH API export were not
covered, manuscript novelty language remains scoped to the consulted
literature rather than an unqualified priority claim.

## Reproduction boundary

No new computational claim is introduced by C653.  The rational cover,
invariant-algebra presentation, and spread-out boundary are prose proofs.
C651 and C652 continue to own the exact finite tensor, exchanger, spinor,
and Mathieu certificates.

## Extra-juice and Tao closeout

The closeout exposed one useful distinction that the earlier plan
collapsed: \(2,5\) are the exact bad primes of the abstract etale
quadratic algebra, whereas \(2,3,5\) are the safe nonmodular boundary of
the chosen invariant presentation, and the geometric incidence comparison
still has an unknown finite bad set.  Paper III now states all three
levels separately.

The same pass also makes the novelty hierarchy cleaner.  Dye pre-empts a
standalone square-\(5\) finite-field crown, and Hitchin pre-empts a
standalone degree-two-incidence crown.  The surviving theorem is the
arithmetic normalization together with its \(p=11\) orientation
specialization and cross-characteristic cubic line.

## Mystery ledger

- **Settled:** the rational twist is \(5J_0\), fixed by the golden
  \(xyz\) fibre.
- **Settled:** the first odd Clebsch invariant is \(e_3=\sigma_3\) over
  the nonmodular base \(\mathbf Z[1/30]\).
- **Settled:** the abstract quadratic algebra has forced bad primes
  \(2,5\) on its ordinary etale two-sheet locus.
- **Settled by prior art:** Dye already owns the arbitrary-field
  square-\(5\) existence criterion and its characteristic-\(5\)
  degeneration.
- **Open, retained honestly:** the minimal bad-prime set for the geometric
  Mukai--Umemura incidence comparison.  The exact gap is an explicit
  integral incidence compactification, normalization/Stein comparison,
  and fibrewise flatness/resultant check.  C579 must keep the cofinite-set
  statement unless a separately allocated integral-model task supplies
  those data.
