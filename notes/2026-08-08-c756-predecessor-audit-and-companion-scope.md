# C756 — predecessor audit and partial-companion scope

**Lane**: `clebsch` · **Date**: 2026-08-08 · **Scope**: research and
publication scoping only

## Verdict

The partial-results package survives a specialist-paper coherence gate, with one
important terminology and novelty correction.

1. The established term is **exterior set of a conic**: a point set whose pairwise
   joining lines miss the conic.  The C756 term *conic-external arc* should be
   introduced as “an exterior set that is also an arc,” not as unrelated new
   vocabulary.
2. Blokhuis--Seress--Wilbrink and Van de Voorde treat complete exterior sets made
   from **exterior points**, of size \((q+1)/2\).  Their theorems do not classify
   the C756 equality supports, which consist of **internal points**, have size
   \((q+3)/2\), and are arcs.
3. Droms--Mellinger--Meyer already prove the general lower bound for the binary
   skew/passant-line versus internal-point code.  Their full author preprint gives
   the pencil proof and a \(q-1\) upper construction but neither analyzes equality
   nor classifies minimum words.
4. No inspected source or screened forward citation claims the internal equality
   classification.  This is a qualified negative, not publication-grade closure:
   Semantic Scholar returned HTTP 429 throughout, MathSciNet was inaccessible, and
   the published versions of several paywalled papers were not read.
5. The best companion is therefore **not** a paper about a newly discovered code
   bound.  Its headline should be the covering-free extremal exterior-arc orbit
   classification, with the Clebsch filling theorem as a corollary, framed by
   the all-\(k\) structural bounds.  The internal code equality, Baer-subline
   exclusion, and line holonomy remain sharp partial results and open interfaces.

Three of the thirteen individually named sources below were read at full text.
For Droms--Mellinger--Meyer this means the complete archived author preprint, not
the published version of record.  The Blokhuis--Seress--Wilbrink load-bearing
statement was checked against the authoritative page scan.

## 1. Exact novelty question

The audit asked:

> Before 2026-08-08, did a source explicitly classify, or reduce to a named
> previously solved class, the weight-\((q+3)/2\) words in the binary incidence
> code whose parity checks are the passant lines and whose coordinates are the
> internal points of a nonsingular conic in \(\mathrm{PG}(2,q)\)?

Equivalent geometric search forms were included:

- internal-point exterior sets of a conic;
- internal arcs all of whose secants are passant/external to a conic;
- minimum words of the skew/passant-line versus internal-point conic code; and
- \((q+3)/2\)-point internal sets with pairwise external joins and no three
  collinear.

The bounded search found no source answering this question.  It did find the
older exterior-*point* theory that must now be cited and used as the terminology
boundary.

## 2. Primary predecessor findings

### 2.1 Droms--Mellinger--Meyer

**Read depth: full text** of the complete 17-page author preprint dated
2005-07-25, archived from the authors' UMW page; this is not asserted to be
text-identical to the published version.  Cache key
`10.1007/s10623-006-0022-6`, SHA-256
`26ee7b8336eb6e26d5a38c97ca0735d562484e5dc59c70df634d46487fb47337`.

The preprint's Theorem 4.9 proves
\[
  (q+3)/2\le d\le q-1
\]
for the skew-line/internal-point code when \(q>3\).  The lower proof is exactly
the passant-pencil count: a support point lies on \((q+1)/2\) relevant lines,
and each needs a second support point.  The upper bound comes from a second
conic whose off-intersection points are all internal.  The paper gives small
parameters through \(q=13\), but it does not discuss saturation of the lower
bound, the arc condition forced by saturation, or minimum-word classification.
The published numbering “Theorem 7.11” may be used only after checking the
version of record.

### 2.2 Exterior sets: the closest geometric predecessor

**Blokhuis--Seress--Wilbrink.  Read depth: full text**, five-page published
scan.  OCR was used only for search; page 143's abstract, definition, and
theorem were verified visually against
`bsw-143.png`, SHA-256
`577c6d656a48d51caf83163a562c29377686938d31d7d0f`.
The full scan set and reconstruction are documented in
`/tmp/persistent/tavis/lit-search/bsw-1992/NOTES.md`.

They define a complete exterior set to be \((q+1)/2\) **exterior points** whose
pairwise joins are passants.  For \(q\equiv1\pmod4\) they prove the set is the
exterior points on a passant; for \(q\equiv3\pmod4\) they report other examples
through \(q=31\).  Their hypothesis explicitly excludes internal-point equality
supports.

**Van de Voorde.  Read depth: partial**, arXiv:1201.0484, §§1.1 and 3,
Theorems 1 and 15, plus a full-text terminology/keyword screen.  Cache SHA-256
`45891ed7688d6ab3677a57060ac69c876007104b7479944744724e69fc46f9a7`.
She defines an exterior set without restricting point type, but the recalled
classification and new extension theorem both concern exterior points on a
passant.  No internal-point classification is stated.

The publication consequence is precise: C756 may claim a new result about
**internal-point exterior arcs** only with “to our knowledge” qualification.
It should not claim to introduce exterior sets.

### 2.3 The conic-code forward line

**Madison--Wu.  Read depth: partial**, arXiv:1104.0324v1, Introduction,
Theorem 2.12, §6 and Corollary 6.3, plus a full-text screen for minimum
distance/weight, codeword, arc, and passant terminology.  Cache SHA-256
`f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`.
The paper proves \(\dim K_q=(q-1)^2/4\) through the
\(\mathrm{PSL}(2,q)\)-module structure.  It neither states nor proves a
minimum-word classification.

The six distinct published works in ScienceDirect's cited-by display, and the
nine OpenAlex records (including version duplicates), were inspected as follows.

- **Wu, _Proofs of two conjectures on the dimensions of binary codes_.**
  Read depth: partial, arXiv:1001.5077, Introduction and main theorem/corollary
  statements; cache SHA-256
  `58bc05fc0a5daebeae79ffb29624247d221ff751a7fa2b37ced5acbc10a92ff0`.
  It proves dimension conjectures for other conic incidence null spaces.
- **Adams--Wu, _2-Ranks of incidence matrices associated with conics_.**
  Read depth: abstract/metadata only, DOI
  `10.1007/s10623-012-9772-5`.  Its stated results are 2-ranks of
  secant/internal-neighbor and passant/external-neighbor incidence matrices.
- **Wu, _Conics arising from internal points and their binary codes_.**
  Read depth: abstract/metadata only, DOI
  `10.1016/j.laa.2013.04.004`.  It constructs conics made entirely of
  internal points, studies their intersections with passants, and computes a
  different incidence-code dimension.
- **Madison--Wu, _Conics arising from external points and their binary codes_.**
  Read depth: abstract/metadata only, DOI
  `10.1007/s10623-014-0013-y`.  It is the external-point analogue and computes
  row-space dimension and automorphisms.
- **Chandler--Sin--Xiang, _Incidence Matrices of Finite Quadratic Spaces_.**
  Read depth: partial, arXiv:1303.3385, abstract and all theorem/proposition
  statements.  Cache SHA-256
  `cc411db1d2bd3aa1344b7b53bae41478b09ceafd1f8963e41eaf8f42cc64671c`.
  It proves 2-ranks of quadratic-space incidence submatrices.
- **Ma--Liu--Tian, _The binary codes generated from quadrics in projective
  spaces_.**  Read depth: partial, Introduction, §4 and all minimum-distance
  theorem statements.  Cache key `10.3934/math.20241421`, SHA-256
  `47c0a52292517a1773a676e2422e7b5a4a7b4bae502b70c1015f8fe87c61c984`.
  Its code uses points versus all nondegenerate quadrics; its §4 results are
  upper bounds for that different code and its dual.

None of these statements classifies minimum words of \(K_q\).

### 2.4 Adjacent methods, not predecessors

- **Magsino--Mixon--Parshall.  Read depth: full text**, arXiv:1907.05971,
  cache SHA-256
  `901d186d28d522924086819a824b4c43d5ea62bcb9a05efafd2a49d586807588`.
  Their local Paley graph is circulant and its theta bound becomes one Fourier
  LP.  It is the correct dual-certificate template, not a theorem about the
  pointed tangent graph \(H_{q,P}\).
- **Kusejko, _Simultaneous diagonalization of conics_.  Read depth: partial**,
  abstract and all theorem/corollary statements of arXiv:1410.3954; cache
  SHA-256
  `fe0f9b09ffbb7cccf2fcb22dfeb6276934b2b7bfac808107482506340028d6f7`.
  It concerns pencils and simultaneous diagonalization, not exterior arcs.
- **Yip, _A strengthening of McConnel's theorem_.  Read depth: partial**,
  Introduction, Theorem 1.2, Corollary 1.3, and proof opening of
  arXiv:2407.21362; cache SHA-256
  `cfa65e4a7ba02ea32c6986aa4fa7a39478ec3615e12c6d7c809083b411b43422`.
  It is potentially useful for a future full-graph direction argument, but its
  hypothesis controls all \(q\) values of a function and does not directly
  apply to a half-sized internal exterior arc.

## 3. Citation-graph coverage

Counts were retrieved on 2026-08-08 from pinned DOI/OpenAlex identifiers.
OpenAlex was the largest accessible graph in every row and its complete returned
set was screened.

| seed | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---:|---:|
| Droms--Mellinger--Meyer, \(W1973242087\) | 19 | 13 | NOT COVERED: HTTP 429 |
| Madison--Wu, \(W2963386663\) | 9 | 4 | NOT COVERED: HTTP 429 |
| Blokhuis--Seress--Wilbrink, \(W2001379196\) | 9 | 3 | NOT COVERED: HTTP 429 |
| Van de Voorde, \(W1997833576\) | 6 | 3 | NOT COVERED: HTTP 429 |

OpenAlex query forms, with the seed substituted exactly, were:

```text
https://api.openalex.org/works?filter=cites:W1973242087&per-page=200&select=id,doi,title,publication_year
https://api.openalex.org/works?filter=cites:W2963386663&per-page=200&select=id,doi,title,publication_year
https://api.openalex.org/works?filter=cites:W2001379196&per-page=200&select=id,doi,title,publication_year
https://api.openalex.org/works?filter=cites:W1997833576&per-page=200&select=id,doi,title,publication_year
```

Crossref counts came from
`https://api.crossref.org/works/<percent-encoded DOI>`, field
`is-referenced-by-count`.  Semantic Scholar was queried by pinned DOI using
`https://api.semanticscholar.org/graph/v1/paper/DOI:<DOI>?fields=title,year,citationCount,openAccessPdf,externalIds`;
the service returned HTTP 429 on the initial and delayed retry, distinguishable
from an empty result.

The mechanical screen fields were publication year, OpenAlex ID, DOI, and title.
The discriminator was:

> Promote any record whose title concerns conics, quadrics, binary/incidence
> codes, minimum distance or weight, exterior sets, sets without tangents,
> Paley/Peisert graphs, or finite-field direction/permutation rigidity; dismiss
> a record only when its title places it in an unrelated application.

The promoted conic-code works are itemized in §2.3.  The exterior-set graph also
promoted the Paley square-order clique paper, Van de Voorde, Yip, the Paley/
Peisert design paper, and survey/ovoid applications.  None advertises an
internal-point exterior-arc or \(K_q\) minimum-word classification.  This is a
title/metadata screen except where §2 records a deeper read.

**Coverage gaps.**  MathSciNet was not accessible.  Google Scholar automated
coverage was not attempted because it blocks agents.  zbMATH Open located and
confirmed the Blokhuis--Seress--Wilbrink review record, but an exhaustive
zbMATH forward set for all four seeds was not obtained.  The published
Droms--Mellinger--Meyer, Adams--Wu, and internal/external-conic articles were
paywalled.  These gaps license only “we found no predecessor in the covered
sources,” never an unqualified priority claim.

## 4. Claim and theorem inventory for a companion

The coherent package is smaller than the full C756 archive.  It should contain
positive all-field statements and use finite computation only as a clearly
marked boundary.

| item | status | role in companion |
|---|---|---|
| Filling iff exterior-set arc plus off-conic covering | proved, all fields | opening dictionary; cite established exterior-set terminology |
| No even-\(q\) filling | proved | clean uniform obstruction |
| all-\(k\) chord-moment LP bound | proved | first general quantitative theorem |
| spare-passant saturation dichotomy | proved | structural spine separating generic and two saturated types |
| flat Sidon lemma and one-faithful-eigenblock criterion for cyclic Cayley digraphs | proved, elementary | reusable proof device; likely folklore, so no novelty claim without audit |
| \(\operatorname{Aut}(P(q)[S])=S\rtimes\operatorname{Gal}(\mathbb F_q/\mathbb F_p)\) for the Paley first subconstituent | proved for every \(q\equiv3\pmod4\) by one primitive eigenspace | most transferable engine; exact-statement novelty audit still required |
| normal Cayley and prime-field cyclic DRR corollaries | immediate from the exact automorphism group | include in the same focused Paley predecessor audit |
| extremal exterior-arc classification: \((q+1)/2\) exterior points occur only at \(q=3,7,11\), with one conic-stabilizer orbit in each field | proved for every odd prime power | **headline theorem**, stated without the covering condition |
| saturated-external filling corollary: only the \(q=11\) Clebsch hexagon covers | proved for every odd prime power | reconnects the headline to conic-filling |
| Droms lower bound and equality-to-internal-exterior-arc bridge | prior bound + proved bridge | intrinsic formulation of the remaining saturated-internal problem |
| coherent systems in a Baer subline force \(q=5\) | proved for every odd prime power | strongest uniform internal exclusion |
| external-line triangle holonomy | proved for every odd prime power | removes the canonical \(q\equiv3\pmod4\) line-plus-pole candidate |
| local Segre-tangent clique obstruction | proved reduction; exact sweep through \(q=49\) | evidence/open-problem section, not theorem beyond the sweep |
| invariant/crown sweeps through \(q=49\) or \(151\) | finite certificates only | optional compact table or repository supplement |
| mixed-sum rationality and negative compression mechanisms | proved but technically remote | omit from the main paper unless they shorten a proof; archive as future-work inputs |
| saturated-internal classification | open | state explicitly |
| nonsaturated masked Rédei theorem \(h\ge1\) | open | state explicitly; required for the full all-\(k\) theorem |

The paper must not imply that all saturated fillings are classified.  It
classifies the saturated-*external* type and gives uniform partial results for
the saturated-*internal* type.

## 5. Recommended paper shape

**Working title if the local Paley theorem passes its focused novelty gate:**
_Local-to-global rigidity in Paley tournaments and exterior arcs of conics_.

**Fallback title:** _Exterior arcs of conics and saturated conic-filling
configurations_.

**Series position:** an unnumbered specialist companion to the four fixed
Clebsch papers.  It may point to Paper I for the original conic-filling
question and to Paper IV for the \(q=13\) passant code, but it is not “Paper V”
and should not modify either manuscript during C756.

**Primary venue target:** _Designs, Codes and Cryptography_.  The closest
predecessors, code interface, finite geometry, and complete saturated-external
classification fit that readership.  _Discrete Mathematics_ is the natural
backup.  This is a credible specialist paper, not the A+/general-classification
paper that the full C756 theorem would have supported.

Recommended compressed spine:

1. flat Sidon one-block criterion, then the exact automorphism group of the
   Paley first subconstituent from one primitive eigenspace and the Jacobi
   collision theorem, including its local-to-global, normal-Cayley, and
   prime-field DRR corollaries;
2. established exterior-set terminology and the extremal-arc-to-matching
   reduction;
3. Segre coherence, the semilinear parameter exclusions, the exterior-arc
   orbit classification, and the Clebsch covering corollary;
4. all-\(k\) LP bound, even-field obstruction, and saturation dichotomy;
5. passant-code equality, Baer-subline exclusion, and line holonomy as the
   internal interface;
6. bounded local-graph evidence and two explicit open problems.

The anticommutator, second Paley matrix, simple-spectrum route, and
Gaussian/Pfaffian obstruction are not part of this spine.

Do not reproduce the twenty-nine-pass negative-method catalogue.  Include only
negative results that explain a theorem boundary or prevent a misleading
generalization.

## 6. Acceptance gates and next actions

Before manuscript drafting:

1. obtain the Droms--Mellinger--Meyer version of record and check theorem
   numbering/wording against the archived author preprint;
2. obtain a human MathSciNet/Scopus or institutional citation check, or retain
   “to our knowledge” and list the gap in the claim ledger;
3. replay the saturated-external proof chain end to end, including one explicit
   extension-field audit, and turn its dependencies into a claim--proof map;
4. audit every proposed theorem for whether it is human proof, exact
   certificate, or finite evidence;
5. only then open manuscript editing under a separately allocated Clebsch task.

The package passes the **scope** gate now.  It does not yet pass a release-level
novelty or proof-trust gate.

## 7. EJ + TT closeout and mystery ledger

**EJ.**  The closest predecessor did not pre-empt the internal result; it supplied
the right vocabulary and a cleaner contrast theorem.  The free upgrade is
stronger than packaging: an exterior set of \((q+1)/2\) exterior points that is
an arc already produces the saturated perfect matching, with no covering
hypothesis.  The proof classifies these extremal exterior arcs up to the conic
stabilizer at \(q=3,7,11\); covering then selects the \(q=11\) Clebsch orbit.
This covering-free orbit theorem, not the elementary code bridge, is the
publishable crown.

**TT.**  The archive is much larger than the paper.  A strong specialist paper
should expose one complete classification and one sharply formulated failure of
classification, rather than narrating every attempted compression.  The local
tangent graph belongs because it says exactly which geometric information the
global exterior-set relaxation loses; the growing SDP orbitals belong only in
the reproducibility note.

| mystery | status | exact gap / owner |
|---|---|---|
| Is “conic-external arc” new terminology? | settled negative | use established “exterior set of a conic”; add “arc” for no-three-collinear |
| Do BSW/Van de Voorde classify internal equality supports? | settled negative for inspected statements | their classification/extension hypotheses use exterior points |
| Did Droms et al. state the equality bridge? | no in full author preprint | published VOR still needs direct wording check |
| Is a \(K_q\) equality classification already published? | no predecessor located in covered sources | Semantic Scholar, MathSciNet, full paywalled follow-ups remain gaps |
| Does Yip's strengthened McConnel theorem close a C756 branch? | settled negative as a direct application | it controls a full \(q\)-point function graph, not a half-sized exterior arc |
| Is the partial package coherent enough for a paper task? | settled positive | headline is the extremal exterior-arc orbit classification; internal and nonsaturated gaps explicit |
| Is the package release-ready? | no | VOR, human citation-index, proof consolidation, and independent Jacobi-lemma audit remain |
