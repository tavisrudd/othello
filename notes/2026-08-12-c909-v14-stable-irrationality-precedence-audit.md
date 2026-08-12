# C909 bounded precedence audit: \(V_{14}\), one-step stabilization, and \(\nu_6\)

**Date:** 2026-08-12  
**Lane:** C909 / clebsch  
**Scope:** independent literature audit; no manuscript, PDF, mirror, or Lean edits.

## Short verdict

The bounded audit found no earlier theorem asserting algebraic irrationality of
\(V_{14}\times\mathbb P^1\) for every smooth genus-8 prime Fano threefold. The
classical \(V_{14}\)--cubic birationality is real and source-exact, but it only
reduces the question to stable irrationality of a cubic threefold; it does not
itself supply that obstruction. Hassett--Tschinkel still described stable
rationality of cubic threefolds and their birational equivalents as open in
2016, and a December 2020 MathOverflow question asking exactly whether
\(Z\times\mathbb P^1\) is irrational for a very general cubic still received
the answer “No, it is not known.” These are historical checks, not an
exhaustive absence proof.

Relative to the separately proved C907 formal-monodromy package, the
\(V_{14}\times\mathbb P^1\) irrationality statement is therefore a new formal
corollary of old birational geometry plus the new invariant, rather than an
old classical theorem. The \(\nu_6\) package itself also appears to have no
direct predecessor in the sources screened here: nearby quantum/Hodge-atom
papers provide decomposition and additivity machinery, but do not define the
primitive-sixth-root multiplicity, prove its low-dimensional birational
invariance, or deduce the one-step \(V_{14}\) obstruction.

## Audit protocol and coverage

I read the repository literature-audit conventions and the persistent litcache
README before searching. The source ledger below records access/version and
cache SHA. Three sources were read at full text (Kuznetsov, Hassett--Tschinkel,
and Cai); four were read at the load-bearing sections listed below; one was
read as a secondary source only (MathOverflow). The search was run on
2026-08-12 using the web index and cached primary PDFs. Search queries included
the following exact strings:

* 'formal monodromy quantum cohomology birational'
* 'primitive sixth quantum connection cubic threefold'
* 'V14 P1 irrational'
* 'V14 stably irrational'
* 'V14 P1 cubic threefold birational'
* 'degree 14 Fano stable rationality'
* 'cubic threefold times P1 irrational'

For the Kuznetsov seed, I screened both available forward-citation graphs.
The pinned OpenAlex seed is W1765317977, and the exact forward query was
https://api.openalex.org/works?filter=cites:W1765317977&per-page=200&select=id,title,publication_year,doi,authorships,abstract_inverted_index;
it returned 36 citing works. The pinned Semantic Scholar record is paper ID
746bb9c0d98d4924baef8c5ab0fbd9299bfdd5cc, with external ID
ARXIV:math/0303037 (also MAG 1765317977 and CorpusId 119594581); its forward
query was
https://api.semanticscholar.org/graph/v1/paper/746bb9c0d98d4924baef8c5ab0fbd9299bfdd5cc/citations?fields=title,year,externalIds,abstract&limit=100.
It returned 62 citing works. The larger 62-item Semantic Scholar set was
screened in full, so the verdict below rests on the largest available
forward-citation set; the OpenAlex 36-item set was an independent cross-check.
Both were screened by title, abstract, year, and external identifiers, with
the mechanical discriminator
'irrational|stable rational|stably|birational|cubic threefold|V14|degree 14|quantum|monodromy|projective bundle|blow-up'.
The hits were adjacent derived-category/rationality or cubic papers, not a
theorem on \(V_{14}\times\mathbb P^1\) irrationality or on \(\nu_6\).

Crossref was queried by pinned DOI. The published Hassett--Tschinkel DOI
10.1515/crelle-2016-0058 resolved successfully and reported 17 cited-by works.
The arXiv-issued DOI lookups
10.48550/arxiv.math/0303037, 10.48550/arxiv.2608.01577,
10.48550/arxiv.2508.05105, and 10.48550/arxiv.2409.08392 returned HTTP 404/no
record. Those are resolution failures/no-record outcomes, not Crossref
cited-by zeros, and no Crossref graph was inferred from them. MathSciNet and
Google Scholar were not accessible in this environment. No global novelty or
absence claim is made beyond this bounded coverage.

## Load-bearing source ledger

### Kuznetsov (primary, full text)

A. Kuznetsov, “Derived categories of cubic and \(V_{14}\) threefolds,”
arXiv:math/0303037v1 (submitted 2003-03-04), 24-page PDF,
<https://arxiv.org/pdf/math/0303037>. Cached PDF SHA-256:
3223183a958572759e6f8ac3a26a7801c1dd13c6e6edd04f917d1646b5ec2a74.

The exact theorem locus is already recorded in
notes/2026-08-12-c909-kuznetsov-v14-stable-birational-audit.md: §2,
Theorems 2.2, 2.17, and 2.18, and Remark 2.19. In particular, every smooth
\(V_{14}\) is represented by a regular net; its Pfaffian cubic is smooth; the
theta sheaf and associated instanton are locally free rank two; the two
projectivizations are related by a flop; and Remark 2.19 records that the
\(V_{14}\) and Pfaffian cubic are already birational. This is the classical
birational input, not a stable-irrationality theorem.

### Hassett--Tschinkel (primary, full text)

B. Hassett and Y. Tschinkel, “On stable rationality of Fano threefolds and
del Pezzo fibrations,” arXiv:1601.07074v1 (2016), 21-page PDF,
<https://arxiv.org/pdf/1601.07074>. Cached PDF SHA-256:
6f1cca9679110e2fdc0393e70dfd818f7543ce04157798b60e4c8bded26fc894.

The introduction says that stable rationality of smooth cubic threefolds was
open and that no smooth cubic threefolds were known to be stably rational. In
§6 (the degree-14 discussion, p. 9 of the arXiv PDF), they identify the
generic degree-14 Fano with the cubic side by projective duality and state that
stable rationality of cubic threefolds, and of birationally equivalent
varieties, remained open. This directly blocks the tempting priority claim
that Kuznetsov's old \(V_{14}\)--cubic birationality had already implied a
known \(V_{14}\times\mathbb P^1\) irrationality theorem.

### MathOverflow (secondary only)

Question “Is the product of a cubic threefold and the projective line
irrational?”, asked 2020-12-18, and its only visible answer dated 2020-12-19,
<https://mathoverflow.net/questions/379287/is-the-product-of-a-cubic-threefold-and-the-projective-line-irrational>.
The answer is “No, it is not known.” This is useful as a later historical
checkpoint, not as a primary-source priority proof.

### Cai (primary, full text)

J. Cai, “The cubic threefold is symplectically irrational,” arXiv:2608.01577v1
(2026), 8-page PDF, <https://arxiv.org/pdf/2608.01577>. Cached PDF SHA-256:
06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e.

The abstract and introduction prove symplectic irrationality and recover
ordinary algebraic irrationality for cubic threefolds. Section 3 and
Proposition 6 exhibit the quantum-connection formal-monodromy exponents
\(\rho\equiv\pm1/6\pmod{\mathbb Z}\), in a rank-two Jordan block. Remark 3
positions this as a formal-monodromy approach, but the paper does not prove
stable irrationality of a cubic times \(\mathbb P^1\), does not state the
\(V_{14}\) consequence, and does not package an additive \(\nu_6\) birational
invariant. It is therefore a close contemporaneous quantum predecessor, not
an exact preemption.

### KKPYY (primary, partial: §§4.1--4.3, §5.3, §6.2)

L. Katzarkov, M. Kontsevich, T. Pantev, and T. Y. Yu, “Birational Invariants
from Hodge Structures and Quantum Multiplication,” arXiv:2508.05105v2 (revised
2026-03-06), 82-page PDF, <https://arxiv.org/pdf/2508.05105>. Cached PDF SHA-256:
2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64.

Theorem 4.1 gives spectral decomposition of maximal F-bundles; Theorems 4.5
and 4.11 give blowup and projective-bundle decompositions; Definitions
5.20--5.21 and Proposition 5.22 define geometric atomic F-bundles and the
chemical formula, including additivity under disjoint union and blowup and
rank multiplication for projective bundles. Example 6.21 gives a cubic
threefold atom calculation and a rationality obstruction. None of these
sections defines the primitive sixth-root formal-monodromy count \(\nu_6\),
proves its low-dimensional birational invariance, or proves
\(\nu_6(V_{14}\times\mathbb P^1)>0\). The chemistry/atom formalism is a genuine
structural predecessor, but it is not the same invariant.

### Iritani (primary, partial: introduction/Theorem 1.1 and §5.8)

H. Iritani, “Quantum cohomology of blowups,” arXiv:2307.13555 (2023),
69-page PDF, <https://arxiv.org/pdf/2307.13555>. Cached PDF SHA-256:
c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b.

Theorem 1.1 (also Theorem 5.18) gives a formal quantum-D-module decomposition
for a blowup into the original quantum D-module plus repeated center pieces.
This supports the formal blowup comparison used by C907 but does not state a
\(\nu_6\) invariant or stable irrationality result.

### Iritani--Koto (primary, partial: introduction/Theorem 1.1 and §5.1)

H. Iritani and Y. Koto, “Quantum cohomology of projective bundles,”
arXiv:2307.03696 (2024), 40-page PDF,
<https://arxiv.org/pdf/2307.03696>. Cached PDF SHA-256:
5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624.

Theorem 1.1 / Theorem 5.1 gives the formal projective-bundle quantum-D-module
decomposition into rank-many copies of the base after the indicated pullbacks.
Again, this is a formal QDM decomposition, not a birational-invariant
\(\nu_6\) theorem and not a stable-irrationality result.

### Tschinkel--Zhang (primary, partial: introduction and §§3--5)

Y. Tschinkel and Z. Zhang, “Stable equivariant birationalities of cubic and
degree 14 Fano threefolds,” arXiv:2409.08392v1 (2024), 22-page PDF,
<https://arxiv.org/pdf/2409.08392>. Cached PDF SHA-256:
f8a72383325e8e6e9ab3113f5b9a0e2b7ea3cc5edf5d8e2f35ae2fe07b8557ab.

Theorem 1.1 / Proposition 4.1 gives a twisted equivariant stable birationality
for a Klein cubic and its degree-14 partner after extra factors
\(\mathbb P^2\times\mathbb P(V)\); Proposition 3.3 gives the analogous
Pfaffian--Grassmannian statement. This is adjacent but not a preemption of
ordinary nonequivariant irrationality for \(V_{14}\times\mathbb P^1\): the
stabilizing factors, equivariance, and assertion are different.

## Priority boundary and safe statement

The logical distinction is:

1. Kuznetsov's old result gives \(V_{14}\dashrightarrow Y\) for a smooth
   Pfaffian cubic \(Y\), hence \(V_{14}\times\mathbb P^1\) is birational to
   \(Y\times\mathbb P^1\).
2. Classical birationality alone does not say that \(Y\times\mathbb P^1\) is
   irrational. The 2016 and 2020 checkpoints explicitly show why one cannot
   call this a known classical corollary.
3. The separate C907 theorem that \(\nu_6\) is birationally invariant in the
   relevant low dimensions, scales under a rank-two projective bundle, and
   has \(\nu_6(Y)=2\), gives \(\nu_6(V_{14})=2\) and
   \(\nu_6(V_{14}\times\mathbb P^1)=4>0\). Rational fourfolds have zero
   invariant, so this yields irrationality of every such stabilized \(V_{14}\).

The source-safe wording is therefore: “A bounded primary-source and
citation-graph audit located no earlier theorem asserting irrationality of
\(V_{14}\times\mathbb P^1\) for every smooth \(V_{14}\). The \(V_{14}\)--cubic
birationality is classical; the one-step stable obstruction is a formal new
corollary of that geometry and the separately established \(\nu_6\) package.
Nearby Hodge-atom and quantum-D-module papers supply related additivity and
projective-bundle machinery, but no direct predecessor for the \(\nu_6\)
definition/equality and its one-step consequence was found in this bounded
screen.”

Do not claim an exhaustive global absence, and do not attribute the
\(\nu_6\)-equality or irrationality conclusion to Kuznetsov, Hassett--Tschinkel,
Cai, KKPYY, Iritani, or Tschinkel--Zhang individually.
