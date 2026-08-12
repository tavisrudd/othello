# C909 — intake screen: five small cycle-side Scholar searches

Date: 2026-08-12

Status: complete first-pass **metadata/snippet screen** for the cycle package
(A--C); no source read is inferred, and no manuscript, claim ledger,
bibliography, PDF, mirror, or Lean file was changed.

## Opening disposition

**New full-text count: 0.**  The five exports contain **79 data rows** in
total.  Their supplied rank, title, authors, year, source, publisher, article
URL, DOI, and Scholar snippet/abstract were screened.  **No exact predecessor
for A, B, or C was located at metadata level.**  Twenty-three distinct
sources are retained as adjacent reading targets (with eight additional rows
recorded as duplicates of such targets); all remaining rows are excluded from
this intake.

The two known primary sources among the targets retain their earlier declared
depths: Abdulali is partial, and Beckmann--de Gaay Fortman is partial.  Every
other retained target is **abstract/metadata only**: only its exported
Scholar fields have been read; its version is not established and no PDF or
cache SHA is assigned.  All excluded entries are members of the screened sets,
not individually read sources.  This distinction is decisive: a phrase in a
Scholar excerpt never proves an integral ordinary divisor-product statement.

## Five finite screened sets: provenance and integrity

The exact queries below are recovered from the scioq parameter in every row's
exported RelatedURL; each set had a single QueryDate.  The filename is
recorded as a second, matching provenance field.

| Code | Export filename | Recovered exact query | Rows / QueryDate | SHA-256 |
|---|---|---|---|---|
| H | "Hodge classes" "power of an elliptic curve" integral.csv | "hodge classes" "power of an elliptic curve" integral | 11 / 2026-08-12 11:37:49 | 12dd8feeeb575bd5b3ee09c3d230adfd9dd8aeb17cd549b6e6049f1d0c35f93a |
| I | "integral Hodge conjecture" "product of elliptic curves".csv | "integral hodge conjecture" "product of elliptic curves" | 7 / 2026-08-12 11:39:21 | b5b05877a019a0e9668ac156eb7a09e43a48c20ad520fbfcc46803d5a3a39493 |
| D | "integral Hodge" "product of elliptic curves" divisor -K3 -hyperkähler.csv | "integral hodge" "product of elliptic curves" divisor -k3 -hyperkähler | 2 / 2026-08-12 11:37:15 | 5d60630fda8f26a0f481fe0e6248ba8118ad7a5292f3d1ebc51f72a89202be84 |
| L | "Lefschetz classes" "elliptic curves" integral.csv | "lefschetz classes" "elliptic curves" integral | 26 / 2026-08-12 11:38:13 | 3bd2834bad419c323ab12ff4cd53b48a2cdc7a8f8ff2bd226190ea1d391056c5 |
| P | "products of divisor classes" "abelian varieties" integral.csv | "products of divisor classes" "abelian varieties" integral | 33 / 2026-08-12 11:38:53 | ae578a7e77ee9eb9a7af4b9303ac161e0326eab4449ec7648051913381bef802 |

Each CSV has one header plus the stated data rows.  Thus the screening has a
checkable stop condition: 11+7+2+26+33=79.  No current result-set total,
retrieval-options record, or error status was provided with the four CSV-only
searches H, I, L, P.  The reports have not been located, so these sets cannot
be represented as exhaustive Google Scholar coverage.

A superficially matching RTF is **not usable** for D: the file under the D
filename has SHA-256
e544c3ee7520c7f49455e2f4d707db56d241e36f44199424b8c8b2c6fb0bfc81,
but its displayed heading and keywords are "cubic threefold" "P^1" irrational,
with 200 results.  It is a mismatched or overwritten report and is deliberately
not used for D's search options, date, or outcome.  The RelatedURL parameters
are the sole exact-query metadata used here.

## Discriminator applied

> Promote exact only where metadata plausibly combines an abelian
> elliptic-power or isogeny presentation, finite-etale/self-adjoint graph or
> comparable integral Néron--Severi lattice data, and an **ordinary integral
> divisor-product/divided-power** conclusion.  Promote adjacent where a source
> could materially delimit rational versus integral Hodge classes, integral
> cycles versus ordinary products, products of elliptic curves, or the
> six-axis/Prym graph geometry.  Exclude otherwise.  Do not infer source depth
> from the snippet.

None of the 79 rows meets the exact test.  Most hits are rational Hodge/Tate
background, finite-field or K-theoretic statements, K3/hyperkähler work,
unidentified snippets, or generic Hodge-conjecture material.

## Retained-source depth register

| Target row(s) | Read depth and source record | Why it remains in the queue |
|---|---|---|
| H:2 — Abdulali, *Abelian varieties and the general Hodge conjecture* | **partial.** Published Cambridge Core PDF, Section 6 and Theorem 6.1; cache key 10.1023/A:1000274922979, SHA-256 1030a2fbb7bec22616bd68ab72565271209ee79dfd39744e010a32a57eda48a2. | Already establishes the rational elliptic-product boundary, not integral saturation. |
| I:2 — Beckmann--de Gaay Fortman, *Integral Fourier transforms and the integral Hodge conjecture for one-cycles on abelian varieties* | **partial.** arXiv 2202.05230v2, abstract, Introduction, Theorem 1.1, Theorem 3.8, Corollary 4.1; cache key arXiv:2202.05230, SHA-256 ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc. | Integral Fourier/one-cycle boundary, not the smaller ordinary divisor-product lattice. |
| All other promote-adjacent rows in the complete ledger | **abstract/metadata only.** Access: the designated H/I/D/L/P Google Scholar CSV row, with only its export fields screened; version not established; no cached bytes/SHA. | They are reading targets, not sources characterized or cited by this audit. |

## Complete row ledger

The table preserves every requested field: source **set**, physical **row**,
Scholar **rank**, title, article URL, DOI, disposition, and reason.  — means
the export left the field blank.  URLs/DOIs are Scholar-export metadata, not
independently resolved identifiers.

| Set | Row | Rank | Title | Article URL | DOI | Disposition / reason |
|---|---:|---:|---|---|---|---|
| H | 1 | 1 | The Work of John Tate | <https://link.springer.com/chapter/10.1007/978-3-642-39449-2_15> | 10.1007/978-3-642-39449-2_15 | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| H | 2 | 2 | Abelian varieties and the general Hodge conjecture | <https://link.springer.com/article/10.1023/A:1000274922979> | 10.1023/A:1000274922979 | promote-known-partial — Abdulali is the rational elliptic-power Hodge-ring boundary; it is not an integral ordinary-product theorem. |
| H | 3 | 3 | Towards a proof of the conjecture of Langlands and Rapoport | <https://arxiv.org/pdf/0707.3177> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| H | 4 | 4 | p-adic Betti lattices | <https://link.springer.com/content/pdf/10.1007/BFb0091133.pdf> | 10.1007/BFb0091133 | promote-adjacent — “p-adic Betti lattices” may bear on integral lattice language; CM/p-adic scope is not C909 on the snippet. |
| H | 5 | 5 | Intitut H. Poincaré, 11 rue P. et M. Curie, F-75231 Paris 5, France | <https://books.google.com/books?hl=en&lr=&id=HDx8CwAAQBAJ&oi=fnd&pg=PA23&dq=%22hodge+classes%22+%22power+of+an+elliptic+curve%22+integral&ots=HTVvFwsbSl&sig=V1-YBD9oj2lbzKTaXWvleU5S860> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| H | 6 | 6 | The Tate and standard conjectures for certain abelian varieties | <https://arxiv.org/abs/2112.12815> | — | promote-adjacent — explicit Lefschetz/Hodge classes for abelian varieties; check whether its claim is only rational/Tate-standard. |
| H | 7 | 7 | Model Theory and Arithmetic | <https://ems.press/journals/owr/articles/14299908> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| H | 8 | 8 | Shimura varieties and moduli | <https://arxiv.org/pdf/1105.0887> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| H | 9 | 9 | Galois groups of low dimensional abelian varieties over finite fields | <https://arxiv.org/abs/2412.03358> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| H | 10 | 10 | A Lindemann-Weierstrass theorem for semi-abelian varieties over function fields | <https://www.ams.org/jams/2010-23-02/S0894-0347-09-00653-5/> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| H | 11 | 11 | On the essential torsion finiteness of abelian varieties over torsion fields | <https://www.cambridge.org/core/journals/nagoya-mathematical-journal/article/on-the-essential-torsion-finiteness-of-abelian-varieties-over-torsion-fields/EF834A98033244D5B0216659BD3022E0> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| I | 1 | 1 | The period-index problem and Hodge theory | <https://arxiv.org/abs/2212.12971> | — | promote-adjacent — integral-Hodge failure with a product-of-elliptic-curves phrase; determine whether the product is the variety or only a Brauer--Severi base. |
| I | 2 | 2 | Integral Fourier transforms and the integral Hodge conjecture for one-cycles on abelian varieties | <https://www.cambridge.org/core/journals/compositio-mathematica/article/integral-fourier-transforms-and-the-integral-hodge-conjecture-for-onecycles-on-abelian-varieties/AC12934E24BDAA5B2CD04372A3090416> | — | promote-known-partial — Beckmann--de Gaay Fortman is the integral-Fourier/one-cycle boundary, not a divisor-product lattice theorem. |
| I | 3 | 3 | The period-index problem for hyperk\" ahler varieties: Lower and upper bounds | <https://arxiv.org/abs/2512.15131> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| I | 4 | 4 | Hodge Classes in the Cohomology of Local Systems | <https://search.proquest.com/openview/f2ab7f738691fbd69740e6cf539d9a36/1?pq-origsite=gscholar&cbl=18750&diss=y> | — | promote-adjacent — local-systems thesis claims a product-of-elliptic-curves boundary; identify its coefficient and integrality convention. |
| I | 5 | 5 | Indecomposable Cycles on a Product of Curves | <https://search.proquest.com/openview/fb4584d5d061924914cf22fdf32c84b3/1?pq-origsite=gscholar&cbl=2026366&diss=y> | — | promote-adjacent — indecomposable cycles on products of curves/elliptic curves could delimit ordinary-product statements. |
| I | 6 | 6 | The Hodge conjecture | — | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| I | 7 | 7 | Minimal degree fibrations in curves and the asymptotic degree of irrationality of divisors | <https://arxiv.org/abs/2304.09963> | — | promote-adjacent — minimal-degree fibrations explicitly query products of elliptic curves and integral-Hodge failure; check the stated implication. |
| D | 1 | 1 | Gassmann equivalence and decompositions of Jacobians | <https://etheses.whiterose.ac.uk/id/eprint/32400/> | — | promote-adjacent — Jacobian decomposition/theta-divisor geometry can bear on graph presentations, not on A from the snippet. |
| D | 2 | 2 | Minimal degree fibrations in curves and the asymptotic degree of irrationality of divisors | <https://arxiv.org/abs/2304.09963> | — | duplicate-candidate — same title and URL as I:7; no independent promotion. |
| L | 1 | 1 | Modular forms from Noether–Lefschetz theory | <https://msp.org/ant/2020/14-9/p02.xhtml> | 10.2140/ant.2020.14.2335 | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 2 | 2 | Noncommutative geometry | <https://ems.press/journals/owr/articles/1726> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 3 | 3 | The Tate conjecture over finite fields (AIM talk) | <https://arxiv.org/abs/0709.3040> | — | promote-adjacent — Tate/Lefschetz classes on abelian varieties; check rational versus integral coefficients. |
| L | 4 | 4 | hypersurface X in P4 of degree at least 6 the Abel-Jacobi map of X has torsion | <https://books.google.com/books?hl=en&lr=&id=-MFUDwAAQBAJ&oi=fnd&pg=PA370&dq=%22lefschetz+classes%22+%22elliptic+curves%22+integral&ots=KpZGe715x6&sig=6YRY82Z9ZR7kox6-BaKPyeV7gTU> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 5 | 5 | Generic cycles, Lefschetz representations, and the generalized Hodge and Bloch conjectures for abelian varieties | <https://arxiv.org/abs/1803.00857> | — | promote-adjacent — integral Chow wording plus Lefschetz representations on abelian varieties; check its actual cycle lattice. |
| L | 6 | 6 | Indecomposable motivic cohomology classes on quartic surfaces and on cubic fourfolds | <https://www.worldscientific.com/doi/pdf/10.1142/3809#page=383> | 10.1142/3809 | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 7 | 7 | Modular Forms in Enumerative Geometry | <https://search.proquest.com/openview/53757cebd92b700dacd23fd2916aadaf/1?pq-origsite=gscholar&cbl=18750&diss=y> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 8 | 8 | The Tate and standard conjectures for certain abelian varieties | <https://arxiv.org/abs/2112.12815> | — | duplicate-candidate — same title/URL as H:6; no independent promotion. |
| L | 9 | 9 | Algebraic K-Theory and Motivic Cohomology | <https://ems.press/journals/owr/articles/14613> | — | promote-adjacent — motivic/K-theory statement explicitly mentions products of three elliptic curves; check whether it concerns ordinary cohomology. |
| L | 10 | 10 | Counting Curves on a Weierstrass Model | <https://arxiv.org/abs/1701.06596> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 11 | 11 | Hitchin fibrations, abelian surfaces, and the P= W conjecture | <https://www.ams.org/journals/jams/2022-35-03/S0894-0347-2021-00989-X/S0894-0347-2021-00989-X.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 12 | 12 | Height moduli of elliptic surfaces: Motivic height zeta rationality and Kudla-Millson modularity of Mordell-Weil rank jumps | <https://arxiv.org/abs/2601.15543> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 13 | 13 | Integral motives and special values of zeta functions | <https://www.ams.org/jams/2004-17-03/S0894-0347-04-00458-8/> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 14 | 14 | Zero-defect algebraization from first principles: A complete unconditional closure of the hodge conjecture | <https://philpapers.org/rec/BHAZAF> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 15 | 15 | Complex varieties with infinite Chow groups modulo 2 | <https://www.jstor.org/stable/24735172> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 16 | 16 | Zero-Defect Support Descent and the Algebraic Realization of Hodge Classes | <https://www.researchgate.net/profile/Deep-Bhattacharjee/publication/404472117_Zero-Defect_Support_Descent_and_the_Algebraic_Realization_of_Hodge_Classes/links/69fa9d0925fb19797b4683f1/Zero-Defect-Support-Descent-and-the-Algebraic-Realization-of-Hodge-Classes.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 17 | 17 | Hodge cycles on some moduli spaces | <https://arxiv.org/abs/math/0102070> | — | promote-adjacent — Hodge cycles on moduli spaces with an all-powers/divisor-product phrase; inspect its exact Hodge-ring scope. |
| L | 18 | 18 | Zero-Defect Support Descent for Hodge Classes | <https://www.researchgate.net/profile/Deep-Bhattacharjee/publication/404382400_Zero-Defect_Support_Descent_for_Hodge_Classes/links/69f68d0f32a2ba2b2d564e97/Zero-Defect-Support-Descent-for-Hodge-Classes.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 19 | 19 | Motivic Support Abelianization for Hodge Classes | <https://www.researchgate.net/profile/Deep-Bhattacharjee/publication/404327511_Motivic_Support_Abelianization_for_Hodge_Classes/links/69f44304a18fd41a39ee108b/Motivic-Support-Abelianization-for-Hodge-Classes.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 20 | 20 | Rational Tate classes on abelian varieties | — | — | promote-adjacent — rational Tate classes on abelian varieties; metadata is sparse, so resolve the source before use. |
| L | 21 | 21 | Intersection theory of the moduli space of elliptic K3 surfaces | <https://search.proquest.com/openview/eec0ec7cd32729b9bbd541762f6d8ab9/1?pq-origsite=gscholar&cbl=18750&diss=y> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 22 | 22 | JOURNAL OF THE AMERICAN MATHEMATICAL SOCIETY | <https://dspace.mit.edu/server/api/core/bitstreams/e11f2a6a-56cc-41ac-9f87-06fd64517f71/content> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 23 | 23 | Motives and algebraic cycles: a celebration in honour of Spencer J. Bloch | <https://books.google.com/books?hl=en&lr=&id=9Q_RDgAAQBAJ&oi=fnd&pg=PP1&dq=%22lefschetz+classes%22+%22elliptic+curves%22+integral&ots=cm_q14stYs&sig=UyhNwNh4PH09SlF5iRER6xKRbbs> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 24 | 24 | Motivic zeta functions of abelian varieties, and the monodromy conjecture | <https://www.sciencedirect.com/science/article/pii/S0001870811000612> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| L | 25 | 25 | Algebraic K-theory and motivic cohomology | <https://ems.press/journals/owr/articles/12495> | — | promote-adjacent — a second motivic/K-theory source asserts a product-of-elliptic-curves result; distinguish it from L:9 and from Hodge cohomology. |
| L | 26 | 26 | The Exponential Torsion of Superelliptic Jacobians | <https://link.springer.com/article/10.1007/s00031-026-09947-1> | 10.1007/s00031-026-09947-1 | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 1 | 1 | Flat pushforwards of Chern classes and the smoothability of cycles below the middle dimension | <https://projecteuclid.org/journals/annals-of-mathematics/volume-200/issue-2/Flat-pushforwards-of-Chern-classes-and-the-smoothability-of-cycles/10.4007/annals.2024.200.2.7.short> | 10.4007/annals.2024.200.2.7.short | promote-adjacent — title/snippet explicitly concern integral cycles and products of divisor classes, with an abelian-variety exception. |
| P | 2 | 2 | The Tate conjecture for almost ordinary abelian varieties over finite fields | <https://scholarlypublications.universiteitleiden.nl/access/item%3A2715558/download> | — | promote-adjacent — slopes and abelian varieties with a divisor-product phrase; determine finite-field/rational coefficient scope. |
| P | 3 | 3 | Flat pushforwards of Chern classes and the smoothability of cycles in the Whitney range | <https://webusers.imj-prg.fr/~claire.voisin/Articlesweb/kv1212.pdf> | — | duplicate-candidate — alternate/preprint title of the P:1 flat-pushforward work; no independent promotion. |
| P | 4 | 4 | Motivation for Hodge cycles | <https://www.sciencedirect.com/science/article/pii/S0001870806000144> | — | promote-adjacent — Hodge-cycle discussion explicitly distinguishes products/sums of divisor classes on abelian varieties. |
| P | 5 | 5 | Hodge classes on self-products of K3 surfaces | <https://bonndoc.ulb.uni-bonn.de/xmlui/handle/20.500.11811/4094> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 6 | 6 | ILLiad m: 940662 lIiIlII\| I\|\|\| III\|\| II\|\| II\|\|\| II\|\|\| I\| IIlIIII | <http://verbit.ru/tmp/ZARHIN/abelian_var_K3.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 7 | 7 | Abelian varieties having a reduction of type | <https://projecteuclid.org/journalArticle/Download?urlid=10.1215/S0012-7094-92-06520-3> | — | promote-adjacent — abelian-variety reduction source has a divisor-product assertion in the snippet; resolve exact theorem and coefficients. |
| P | 8 | 8 | Zero-defect algebraization from first principles: A complete unconditional closure of the hodge conjecture | <https://philpapers.org/rec/BHAZAF> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 9 | 9 | A Motivic-Physical Duality Approach to the Hodge Conjecture | <https://www.researchgate.net/profile/Bob-Kurban/publication/393178089_A_Motivic-Physical_Duality_Approach_to_the_Hodge_Conjecture/links/686311e2b991270ef300407f/A-Motivic-Physical-Duality-Approach-to-the-Hodge-Conjecture.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 10 | 10 | ANNALES DE L'INSTITUT FOURIER | <https://www.academia.edu/download/126021678/aif.3483.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 11 | 11 | Flat pushforwards of Chern classes and the smoothability of cycles in the Whitney range | <https://webusers.imj-prg.fr/~claire.voisin/Articlesweb/kv1212.pdf> | — | duplicate-candidate — same flat-pushforward PDF as P:3; no independent promotion. |
| P | 12 | 12 | rc vc viR= t. | — | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 13 | 13 | Zero-Defect Support Descent and the Algebraic Realization of Hodge Classes | <https://www.researchgate.net/profile/Deep-Bhattacharjee/publication/404472117_Zero-Defect_Support_Descent_and_the_Algebraic_Realization_of_Hodge_Classes/links/69fa9d0925fb19797b4683f1/Zero-Defect-Support-Descent-and-the-Algebraic-Realization-of-Hodge-Classes.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 14 | 14 | Hodge classes on self-products of K3 surfaces | <https://bonndoc.ulb.uni-bonn.de/xmlui/handle/20.500.11811/4094> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 15 | 15 | The Hodge conjecture | — | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 16 | 16 | An introduction to Mumford-Tate groups | <http://www.math.ru.nl/personal/bmoonen/Lecturenotes/MTGps.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 17 | 17 | ANNALES DE L'INSTITUT FOURIER | <https://www.academia.edu/download/126021678/aif.3483.pdf> | — | duplicate-candidate — same unidentified Annales/PDF record as P:10; no independent promotion. |
| P | 18 | 18 | Motivation for Hodge cycles | <https://www.sciencedirect.com/science/article/pii/S0001870806000144> | — | duplicate-candidate — same “Motivation for Hodge cycles” source as P:4; no independent promotion. |
| P | 19 | 19 | A Rigorous Framework for the Hodge Conjecture via Differential Algebraic and Homological Algebraic Methods | <http://www.cambridge.org/engage/coe/article-details/6917345065a54c2d4a4c8454> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 20 | 20 | Zero-Defect Support Descent for Hodge Classes | <https://www.researchgate.net/profile/Deep-Bhattacharjee/publication/404382400_Zero-Defect_Support_Descent_for_Hodge_Classes/links/69f68d0f32a2ba2b2d564e97/Zero-Defect-Support-Descent-for-Hodge-Classes.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 21 | 21 | The Tate Conjecture For Non-Simple | <https://books.google.com/books?hl=en&lr=&id=BUScMw_OlbIC&oi=fnd&pg=PA267&dq=%22products+of+divisor+classes%22+%22abelian+varieties%22+integral&ots=TTPJPnmh5Y&sig=7NN2sZNRe6ZY4qv2QYET3OR_8Rc> | — | promote-adjacent — non-simple abelian varieties and an explicit divisor-product phrase; check Tate-versus-Hodge and coefficient field. |
| P | 22 | 22 | Flat pushforwards of Chern classes and the smoothing problem for cycles in the Whitney range | <https://hal.science/hal-04275935/> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 23 | 23 | Mumford-type Shimura curves contained in the Torelli locus | <https://arxiv.org/abs/2510.00093> | — | promote-adjacent — Shimura-curve source gives a non-divisor-product contrast; check whether its setting intersects the elliptic-power locus. |
| P | 24 | 24 | Chow rings of moduli spaces of curves I: The Chow ring of ̄M_3 | <https://www.jstor.org/stable/1971525> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 25 | 25 | Hodge groups of certain superelliptic Jacobians | <https://projecteuclid.org/journalArticle/Download?urlId=10.4310%2FMRL.2010.v17.n2.a15> | — | promote-adjacent — Hodge groups of superelliptic Jacobians with rational divisor-product language; potential contrast only. |
| P | 26 | 26 | McMullen's Curve, the Weil Locus, and the Hodge Conjecture for Abelian Sixfolds | <https://arxiv.org/abs/2603.20268> | — | promote-adjacent — abelian-sixfold Weil/Hodge locus could delimit generic divisor-product claims, not A without a graph result. |
| P | 27 | 27 | Notes on Mumford-Tate groups | <http://www.math.ru.nl/~bmoonen/Lecturenotes/CEBnotesMT.pdf> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 28 | 28 | Hodge cycles on some moduli spaces | <https://arxiv.org/abs/math/0102070> | — | duplicate-candidate — same “Hodge cycles on some moduli spaces” source as L:17; no independent promotion. |
| P | 29 | 29 | Differential Algebraic Framework for Hodge Theory: Constructive Hodge Decomposition and Harmonic Forms | <http://www.cambridge.org/engage/coe/article-details/691731eaef936fb4a23d5b7a> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 30 | 30 | All in action | <https://www.mdpi.com/1099-4300/12/11/2333> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 31 | 31 | The endomorphism algebras and Hodge groups of certain superelliptic Jacobians | <https://search.proquest.com/openview/78c0b4fe54493783c041c350bba23128/1?pq-origsite=gscholar&cbl=18750> | — | duplicate-candidate — thesis/version-level companion of P:25; no independent promotion. |
| P | 32 | 32 | The Action Potential Of Principia Mathematica &Gedanke: An Analytic–Geometric Framework Bridging Hodge Theory and the Riemann ζ-Function. | <http://www.cambridge.org/engage/coe/article-details/68ff86eaef936fb4a2a1a683> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |
| P | 33 | 33 | Vanishing criteria for Ceresa cycles | <https://www.cambridge.org/core/journals/compositio-mathematica/article/vanishing-criteria-for-ceresa-cycles/051A1B2257FB703EA13086A238A279B8> | — | exclude — title/Scholar metadata does not make plausible an integral ordinary divisor-product lattice, or a sufficiently close Hodge/isogeny boundary. |

## Coverage and next action

1. The 21 metadata-only targets need source-level reading before they can
   affect the C909 priority ledger.  If the full text cannot be reached, the
   result remains an access gap rather than a negative.
2. H:2 and I:2 do not need rereading merely because they reappear: their
   prior partial records are explicit above.  Any new published-version claim
   requires a separate version check.
3. This is not a cited-by closure and makes no citation-count assertion.
   MathSciNet remains **NOT COVERED**, and Google Scholar/forward-graph
   closure remains governed by the earlier authenticated closure packet.
4. No paper-facing surface has been edited.  If a promoted source alters
   priority, change only the owning row in the epilogue claim-proof-novelty
   ledger, then point other surfaces to that row.

## Handoff

go C909 clebsch five small Scholar cycle screens complete: 79 rows, no
metadata-level exact predecessor, 23 adjacent reading targets, and the D RTF
provenance mismatch quarantined.
