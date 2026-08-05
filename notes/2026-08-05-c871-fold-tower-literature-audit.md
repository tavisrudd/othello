# C871 — literature audit of the rank-generic fold tower

**Date:** 2026-08-05
**Task:** C871
**Lane:** `clebsch`
**Status:** complete. **Contains corrections to two verdicts in the C869 report — see
"Corrections to the C869 audit". One of them retracts that report's headline finding.**

Audited claim: `notes/2026-08-05-c870-fold-tower-judo.md` — the root-link antipodal fold carries the
affine code of the rank-`2l` plus-type quadric over `F2` onto the affine code of the rank-`2(l-1)`
one, at every rank, matching full weight enumerators; the previously audited four-term exceptional
ladder is its bottom.

Three questions, per the task:

1. **(load-bearing)** Has anyone related members of a two-weight code family, or the corresponding
   strongly regular graphs, by a fold or quotient across ranks — at any rank, in any language?
2. Has anyone stated the criterion for when the two biadjacency kernels of a bipartite
   arc-transitive graph give equivalent codes? Has anyone published a correction to the paper
   audited under C869?
3. (low priority) Has anyone asked which members of the two-weight quadric family admit exceptional
   root-system or Lie-theoretic descriptions?

Governing conventions: `notes/literature-audit-conventions.md`, binding in full, as in C866/C869.
zbMATH Open again replaces Crossref for keyword negatives, for the reason restated in the Search
record, with the same HTTP-404-means-empty calibration.

## Opening summary

**Four of this report's sources were read at full text**: Calderbank and Kantor's 1986 survey,
re-read this round specifically for the rank question; Conder and Potočnik's semisymmetric cubic
graph census listing; Conder's trivalent symmetric graph census listing (carried over from C869,
same bytes); and the 2022 open-access Ars Mathematica Contemporanea paper of Crnković, Rukavina and
Šimac, plus the arXiv preprint of their 2020 paper also carried over at full text — that last one at
preprint depth, which is recorded as `full text` of the preprint and **not** of the published
version. Counting the two carried-over items and the two new ones, and the 2020 preprint, the table
in the Search record shows five `full text` rows; Brouwer and Van Maldeghem's book, the single most
important source of the round, was read at `partial` and is marked so. Everything else is
`secondary only`, `review only`, or `abstract/metadata only`. The read-depth field is on every
source named, including the four named only in order to be dismissed.

**Item 1 is pre-empted, and I am saying so first because that is the outcome that changes what gets
written.** The rank-descent structure is published in general rank as Proposition 3.6.1 of Brouwer
and Van Maldeghem's *Strongly Regular Graphs*, attributed there to Brouwer and Shult (1990). It
states that in the graph on the nonsingular points of a quadratic form over the field of two
elements — the bundle's coordinate set — the vertices at distance two from a fixed vertex form the
**Taylor extension** of the corresponding graph two ranks down. A Taylor extension is by definition
an antipodal double cover, so it carries exactly the canonical fixed-point-free involution the
bundle folds by, and passing to its antipodal classes is exactly the bundle's fold. The arithmetic
matches at our rank without adjustment. The same book records the `q = 3` analogue in a subsection
headed "Tower and clique sizes", using the word tower, and cites a converse characterisation by
Pasechnik. And the bottom of the tower is named classical geometry in the same book: the graph on
the 120 root pairs is constructed from the E8 root system, its local graph is the Gosset graph, the
Gosset graph is the Taylor extension of the Schläfli graph and an antipodal double cover of the
complete graph on 28 vertices, and the Schläfli graph is labelled the E6 graph. The chain
`120 → 56 → 28 → 27` is there, with those names and those Lie labels.

Calderbank and Kantor genuinely do not relate their family's members across ranks — I verified this
at full text, and the only member-to-member operations their survey offers are duality,
complementation, and field change. That gap is real. It is simply filled somewhere else, in the
strongly-regular-graph literature, and the bundle's fold is that filling translated through the
graph-to-code dictionary Calderbank and Kantor themselves built. The C870 recommendation to lead
with the tower at general rank should be **reversed**: the general-rank tower is the occupied part.
The only residue is the statement at the level of codes and weight enumerators, and my assessment is
that it is too thin to carry a manuscript.

**Item 2 is pre-empted, and it forces me to retract the headline finding of my previous round.** The
criterion is right — the two codes are equivalent exactly when some automorphism swaps the parts —
but it is the standard fact that arc-transitive implies vertex-transitive, and Crnković, Rukavina
and Šimac use it correctly in both directions: their 2020 paper asserts equivalence for symmetric
graphs, which is true, and their 2022 follow-up on semisymmetric graphs states explicitly that the
transpose gives another code, proves distance bounds for both, and tabulates both with differing
minimum distances at equal length and dimension. **There is no error in their work and no
correction to publish.** My C869 claim that the lane held a counterexample was wrong, and it was
wrong because of a prior mistake: I had identified the lane's graph with an entry in the census of
*symmetric* cubic graphs, when the bundle's own data — two sides with non-isomorphic vertex
stabilizers — shows no part-swapping automorphism can exist, so the graph is semisymmetric. It is
catalogued, but in the semisymmetric census, as `X.182.1`. Two different cubic bipartite
girth-twelve graphs exist at that order, and I matched the wrong one.

**Item 3 is pre-empted too**, and the expectation of finding nothing is not met. The exceptional
root-system descriptions are not an unasked question about these objects; they are how the
strongly-regular-graph literature names them.

**Blocking gaps:** Brouwer and Shult's 1990 paper, held only as quoted by the book, should be
obtained before the predecessor is cited; the Hyun and Hu 2026 recursive construction is held at
review only and its relation to the fold is undetermined; and the Chakravarti chapter is still
paywalled, open since C866.

## Verdict table

| # | Question | Verdict |
|---|---|---|
| 1 | Two-weight family members / their strongly regular graphs related by a fold or quotient across ranks | **PRE-EMPTED** — Brouwer & Van Maldeghem Prop. 3.6.1, after Brouwer & Shult; general rank, with an explicit "tower" subsection at `q = 3` and a Pasechnik converse |
| 1a | The same at the bottom of the tower, in exceptional labels | **PRE-EMPTED** — E8 root-pair graph → Gosset graph → its 28 antipodal classes → Schläfli graph, all named in §10.10 and §10.39 of the same book |
| 1b | Calderbank & Kantor themselves: any relation between RT2 members at different ranks | **NO** — verified at full text; their only member-to-member operations are duality, complementation and field change. The gap is real but is filled elsewhere |
| 1c | The fold stated as a map of codes with matching weight enumerators | **NO PREDECESSOR LOCATED** — the only residue, and thin; a translation of 1 through a published dictionary |
| 2 | The criterion for equivalence of the two biadjacency kernels | **PRE-EMPTED / FOLKLORE** — it is vertex-transitivity; used correctly by Crnković–Rukavina–Šimac in both papers |
| 2a | A published correction to their 2020 paper | **NONE EXISTS AND NONE IS WARRANTED** — my C869 finding is retracted |
| 3 | Exceptional root-system or Lie-theoretic descriptions of members of this family | **PRE-EMPTED** — standard vocabulary in the strongly-regular-graph literature |
| — | C869 OC-1, the graph's identification | **CORRECTED** — it is `X.182.1` in the semisymmetric census, not `C182.4` in the symmetric one |
| — | C869 OC-2, the claimed counterexample | **RETRACTED** |

## Per-item findings

### Item 1 — relating two-weight family members by a fold or quotient across ranks

**Verdict: PRE-EMPTED.** Stated plainly and up front, as requested: the rank-descent structure is
published, in general rank, with an attributed proposition, and the specific small case at the
bottom of the tower is a named classical graph whose antipodal-double-cover structure is textbook.
The manuscript should not be written as though the fold is new.

The predecessor is **Proposition 3.6.1 of Brouwer and Van Maldeghem, *Strongly Regular Graphs*,
attributed there to Brouwer and Shult**. Read depth: `partial` — the book's author-hosted preprint
PDF was downloaded whole from `https://homepages.cwi.nl/~aeb/math/srg/rk3/srgw.pdf`, SHA-256
`fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`, extracted with poppler
`pdftotext`, and matched **entirely locally**. Sections read: §1.2.7 (Taylor graphs), §3.3 (affine
polar graphs) including §3.3.3, §3.6 (the case q = 2) and its §3.6.1 (local structure), the
"Tower and clique sizes" subsection of the NO-graph material, §10.10 (the Schläfli graph entry and
the Gosset graph passage), and the relevant bibliography entries. I did not read the rest of the
book. **Version caveat:** this is the preprint, which the publisher's page and the authors' site
both describe as not sharing page numbers with the Cambridge 2022 published edition, though
section, theorem and reference numbers are stated to agree; every citation here is by section or
proposition number for that reason, and no page number is asserted.

**The general-rank statement.** §3.6.1 is titled "Local structure" and opens "We have precise
information about the local structure of the polar graphs `O^ε_m(2)`." Proposition 3.6.1 then gives
distance partitions, of which two are the relevant ones, quoted verbatim as extracted:

```
V O^ε_{2n}(2) = 1 + O^ε_{2n}(2) + N O^ε_{2n}(2)
N O^{-ε}_{2n}(2) = 1 + O_{2n-1}(2) + T O^ε_{2n-2}(2)
O^ε_m(2)  = 1 + O^ε_{m-2}(2).2 + V O^ε_{m-2}(2)
```

The book's own gloss, quoted: "Here we indicate the subgraphs found at a given distance from a
fixed point, writing `Γ = Γ_0(x) + Γ_1(x) + Γ_2(x) + ···`. The graphs occurring here are `O^ε_m(2)`,
the graph on the singular points, adjacent when orthogonal, `N O^ε_{2n}(2)`, the graph on the
nonsingular points, adjacent when orthogonal, `V O^ε_m(2)` […] and `T O^ε_m(2)`, the Taylor
extension of `O^ε_m(2)`."

The second line is our construction. It says that in the graph on the **nonsingular points** — our
code's coordinate set — the set of vertices at distance two from a fixed vertex is the **Taylor
extension of the rank-`2n−2` graph**. The bibliography entry is `[142] A. E. Brouwer & E. E. Shult,
Graphs with odd cocliques, Europ. J. Combin. 11 (1990) 99–104`. Read depth of that paper itself:
`secondary only` — bibliographic detail taken verbatim from the book's reference list, whose own
depth is `partial`; the paper was not obtained.

**Why that is our fold, with the arithmetic.** This is MY verification, marked as mine, done
locally against the bundle:

- The book's §3.6.2(iii) gives `N O^ε_{2n}(2)` the parameters `v = 2^{2n−1} − ε·2^{n−1}`,
  `k = 2^{2n−2} − 1`. At `n = 4, ε = +1` that is 120 vertices of valency 63 — the bundle's
  coordinate set, with orthogonality as adjacency.
- The non-neighbours of a fixed vertex therefore number `120 − 1 − 63 = 56`. That is exactly the
  bundle's root link, and the link condition `B(α,u) = 1` is precisely non-orthogonality.
- Proposition 3.6.1 identifies that 56-set as `T O^−_6(2)`. Since `T Δ` is defined in §1.2.7 as the
  Taylor double of `{∞} + Δ`, and the elliptic quadric at rank six has 27 singular points, the
  count is `2 × (1 + 27) = 56`. It matches.
- A Taylor graph is defined in §1.2.7 as "an antipodal double cover of the complete graph
  `K_{k+1}`". So the 56-point link carries a canonical fixed-point-free involution with **28
  antipodal classes**, and passing to those classes is the antipodal quotient. That is the bundle's
  fold, under a different name.
- The 28 classes are `1 + 27` — one distinguished class plus the rank-six quadric's points. That is
  also, independently, the bundle's own `E7 → E6` shortening, so the two descriptions agree.

**The bottom of the tower is a named graph.** §10.10 records: "The Gosset graph is the unique
distance-regular graph with intersection array `{27, 10, 1; 1, 10, 27}`. It is distance-transitive,
an antipodal double cover of `K_28`." Its local graph is the Schläfli graph on 27 vertices, and the
book gives the double-six construction of the latter from the former. So the bundle's
`56 → 28 → 27` is, in the standard vocabulary of this field, the Gosset graph, its antipodal
quotient, and its local graph — three named classical objects with a published relationship.

**The word "tower" is already in use for this, with a converse theorem.** The book's NO-graph
material contains a subsection headed "Tower and clique sizes", stating: "The `N O^*(3)` graphs
form a tower: the graph `N O^{−ε}_{2n+2}(3)` is locally `N O^{ε⊥}_{2n+1}(3)`, and the graph
`N O^{ε⊥}_{2n+1}(3)` is locally `N O^ε_{2n}(3)`. Conversely, Pasechnik [599] shows that for `n ≥ 3`
the only locally `N O^ε_{2n}(3)` graph is `N O^{ε⊥}_{2n+1}(3)` […]". That is the `q = 3` analogue of
the bundle's claim, published as a tower, and with a converse characterisation. Reference:
`[599] D. V. Pasechnik, On some locally 3-transposition graphs, pp. 319–325 in: Finite Geometry and
Combinatorics, Proc. Deinze 1992, F. De Clerck et al. (eds.), LMS Lecture Note Ser. 191, Cambridge
Univ. Press, 1993`. Read depth: `secondary only`, via the book's bibliography; not obtained.

**What Calderbank and Kantor do and do not contain.** Read at `full text` (cache key
`10.1112/blms/18.2.97`, SHA-256
`986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`; same bytes as C866/C869). I
re-read it for this question specifically. The survey's own account of how it relates family
members to one another is given in its introduction, and it names exactly two operations: §5
Duality ("we describe the dual of a projective `(n,k,h_1,h_2)` set, and the projective dual of a
two-weight code") and §6 Field changes ("Section 6 shows how to construct new two-weight codes from
a given two-weight code by changing the underlying field", with Theorem 6.1 passing to a subfield
and the following result "(6.1) viewed backwards"). Complementation appears in §5 as well. A
mechanical search of the extracted text for `subconstituent`, `local graph`, `antipodal`, `fold`,
`quotient`, `recursion`, `induction`, and `descend` returns no occurrence in any mathematical
sense. The RT2 examples are presented as a family parameterised by `k = 2l` and `q`, with
parameters computed as functions of `l`, and **no map between members at different `l`**.

So the honest description of the situation — using the plain word, since the house style forbids
the other one — is this: **Calderbank and Kantor do not relate the levels, and that gap is real;
but the gap is filled elsewhere, in the strongly-regular-graph literature, at general rank, and the
bundle's fold is that filling translated through the graph-to-code dictionary that Calderbank and
Kantor themselves set up.**

**What, precisely, is left.** I did not locate the fold stated as a map of **codes** — that the
affine code of the rank-`2l` quadric maps onto the affine code of the rank-`2(l−1)` one with
matching weight enumerators. The book is about graphs and does not discuss these codes' weight
enumerators level by level. But this residue is thin, and MY assessment, marked as mine, is that it
will not support a manuscript: given a published rank-descent decomposition of the graphs and a
published dictionary between these graphs and these codes, the code statement is a translation
exercise, and a referee in this field will say so. The strategic recommendation in the C870 bundle —
lead with the tower at general rank, demote the exceptional identifications to a remark — should be
**reversed**: the tower at general rank is the part that is occupied.

**One thing that does survive, and is worth more than the tower.** The bundle's fold is stated as a
map on *codes* carrying *weight enumerators* to *weight enumerators*. The graph literature records
the rank-descent as a statement about subgraphs at a given distance. Whether the induced map on
codes is functorial in a way the graph decomposition does not immediately give — in particular
whether the weight-enumerator match at every rank is a corollary or an extra fact — is a question
this audit cannot settle, because it is mathematics rather than literature. If it is an extra fact,
it is small. If it is a corollary, there is nothing left. **This should be settled before any
further manuscript work, and it is cheaper than another literature round.**

### Item 1, addendum — the bottom of the tower is in the same book, by name

Reading further in Brouwer–Van Maldeghem (same source, same read depth `partial`) closes the
specific case completely. §10.39 treats the strongly regular graph with parameters
`(120, 56, 28, 24)` and gives two constructions, quoted verbatim:

> "**Construction: the E8 root system.** Let Φ be the root system of type `E8`. It has 240 vectors,
> and spans 120 lines in `R^8`. The graph Γ is the graph on these 120 lines, where lines are
> adjacent when not orthogonal. The root system graph of `E8` (with vertex set Φ, where two roots
> are adjacent when their angle is π/3) is a double cover of Γ."

> "**Construction: from the local graph.** The local graph of Γ is the Gosset graph (see §10.10)
> with 28 extra edges joining vertices at original distance 3."

MY verification, marked as mine: that graph's vertex set is the 120 root pairs — the bundle's
coordinate set — and its adjacency is non-orthogonality, which is exactly the bundle's link
condition `B(α,u) = 1`. Its valency is 56, which is exactly the link size. So the book states that
**the link is the Gosset graph** (up to the 28 noted extra edges), and §10.10 states that the
Gosset graph "is the unique graph that is locally Schläfli. It is the Taylor extension `TΓ`" of the
Schläfli graph, and that it is "an antipodal double cover of `K_28`". §10.10 further labels the
Schläfli graph "the `E6,1(1)` graph, the local graph of the `E7,7(1)` (Gosset) graph."

So the chain `120 → 56 → 28 → 27` is in this book as a chain of named objects — E8 root-pair
graph, Gosset graph, its 28 antipodal classes, Schläfli graph — carrying the Lie labels `E7,7(1)`
and `E6,1(1)` explicitly. There is nothing left of the small-rank case.

### Item 2 — the criterion for when the two biadjacency kernels give equivalent codes

**Verdict: PRE-EMPTED / FOLKLORE, and — this is the part that matters — there is no error to
correct. My C869 finding was wrong. See the corrections section below.**

The proposed criterion is right, and it is the standard fact. For a connected bipartite graph every
automorphism either preserves both parts or swaps them, so "some automorphism swaps the parts" is
equivalent to the automorphism group being vertex-transitive. And **arc-transitive implies
vertex-transitive**. Hence for a bipartite *arc-transitive* graph a part-swapping automorphism
always exists and the two codes are always equivalent — which is precisely what
Crnković–Rukavina–Šimac assert in the paper audited under C869, and it is correct.

The authors also state and use the complementary case. Their follow-up, **Dean Crnković, Sanja
Rukavina and Marina Šimac, "LDPC codes from cubic semisymmetric graphs", *Ars Mathematica
Contemporanea* 22 (2022) #P2.03, DOI `10.26493/1855-3974.2501.4c4`** (read depth: `full text` —
open-access PDF downloaded from `https://amc-journal.eu/index.php/amc/article/download/2501/1658`,
SHA-256 `833477b8b879201e21132f50845c41187a65e22ed0b3f4441beaea4ee1862ce9`, extracted with poppler
`pdftotext`; sections read: abstract, §1 preliminaries, the construction paragraph, Theorems 2.6–2.9,
and the computational-results section with Table 1; version read is the published open-access
version, received 10 December 2020, accepted 16 July 2021, published online 14 April 2022) states
verbatim:

> "A regular graph is semisymmetric if it is edge-transitive, but not vertex-transitive."

and

> "From the fact that semisymmetric graphs are edge-transitive, but not vertex-transitive, it
> follows that `H^T` determines another LDPC code `C_{H^T}(G)`."

They then develop both codes in parallel, prove distance bounds for each (their Theorem 2.8), and
**tabulate both** in Table 1 under headings `LDPC1` and `LDPC2` — with, in many rows, *different
minimum distances for the two sides of the same graph*: at order 54, `[27,8,6]` against `[27,8,8]`;
at order 112, `[56,12,14]` against `[56,12,16]`; at order 120, `[60,14,8]` against `[60,14,12]`; and
so on down the table.

So the phenomenon the C870/C869 work treated as a discovery — that the two biadjacency kernels of a
bipartite edge-transitive graph can be inequivalent, differing in minimum distance at equal length
and dimension — is published, tabulated, and correctly attributed to failure of vertex-transitivity,
by the same authors, in an open-access journal. **No correction to their work exists or is
warranted.**

I searched for any published correction, erratum, or comment on the 2020 paper and found none; see
the Search record for the queries and the coverage statement for what that negative does and does
not license.

### Item 3 — exceptional root-system or Lie-theoretic descriptions of members of this family

**Verdict: PRE-EMPTED.** The expectation that "nothing" would be found is not met; the opposite is
true, and the material is in the same book.

Beyond the §10.39 and §10.10 passages quoted above, Brouwer–Van Maldeghem carries the Lie labelling
as standard apparatus: the Schläfli graph is named "the `E6,1(1)` graph", the Gosset graph "the
`E7,7(1)` graph", and §10.39 constructs the 120-vertex graph directly from the `E8` root system,
with the root-system graph on 240 roots presented as its double cover. The book also cites
`[573] G. E. Moorhouse, Ovoids from the E8 root lattice, Geom. Dedicata 46 (1993) 287–297` (read
depth: `secondary only`, via this book's bibliography; the same paper I recorded at `secondary
only` in C866, still not obtained), and elsewhere notes a construction using "the E8 root lattice
modulo" a prime.

MY inference, marked as mine: the "first question their object was never asked" framing does not
apply here. The exceptional descriptions of the small members are not an unasked question — they
are how this literature names the objects. The two-weight-code community and the
strongly-regular-graph community have different default vocabularies, and the Lie-theoretic
descriptions live in the second one.

## Corrections to the C869 audit

Two verdicts I issued in the previous round were wrong. Both are corrected here, and the second was
the one I described as the most valuable finding of that audit, so the correction is important and
should propagate before anything is written up.

### Correction 1 — the graph is catalogued, but not as the graph I named

C869 item OC-1 identified the 182-vertex correspondence graph as `C182.4` in Conder's census of
trivalent **symmetric** graphs, on the grounds that it was the unique entry there that was bipartite
with girth twelve. **That identification is wrong.** A symmetric graph is arc-transitive, hence
vertex-transitive, hence has a part-swapping automorphism. The bundle's own data rules that out:
the two sides have vertex stabilizers of orders 24 that are **non-isomorphic** as groups (one is
the octahedral group, the other a dihedral group of the same order), and a part-swapping
automorphism would conjugate one to the other. So the bundle's graph is edge-transitive but not
vertex-transitive — it is **semisymmetric** — and it is therefore not in the symmetric census at
all. My discriminator (bipartite, girth twelve) was not the unique discriminator I took it for,
because it does not separate across the two censuses.

The correct identification is in **Conder and Potočnik's census of semisymmetric cubic graphs**,
whose summary file records exactly one graph at this order:

```
X.182.1 :  Order 182  Type G_2^1 graph  Diameter 8  Girth 12
```

Read depth: `full text` of the census listing — downloaded whole by `curl` from
`http://www.math.auckland.ac.nz/~conder/SemisymmCubic10000.txt`, SHA-256
`606b2378d9939284d3c65d8f0ea855ce1fe2ff0d179d1c770d7261a2606879b0`, and matched locally; I read the
header, the by-order listing, and the by-type listing. The file's own header states that "All such
graphs were found in 2012 by Marston Conder & Primož Potočnik, using the universal amalgams
provided by David Goldschmidt in his paper 'Automorphisms of trivalent graphs' in Annals of
Mathematics 111 (1980), 377–406, and the Magma system", defines semisymmetric as "edge-transitive
but not vertex-transitive (and then the automorphism group has two orbits on arcs)", and is dated
May 2018 with the note "Details are being written up in a paper for publication".

Note the trap explicitly: the symmetric census's `C182.4` is bipartite with girth twelve and
**diameter 9**; the semisymmetric census's `X.182.1` is girth twelve and **diameter 8**. Two
different cubic bipartite girth-twelve graphs at the same order, in two different censuses.

Two consequences. First, the substance of OC-1 survives — the graph is catalogued, and the bundle's
open question 4 is still answered in the affirmative — but the citation must change, and the
correct one is a census whose supporting paper the header says was still unpublished as of 2018.
Second, the Goldschmidt type `G_2^1` means the bundle's amalgam is one of Goldschmidt's classified
trivalent amalgams; the coset geometry the bundle describes is a Goldschmidt amalgam, which is
itself classical (Goldschmidt 1980). Read depth for Goldschmidt's paper: `secondary only`, via the
census header; not obtained.

Also relevant: the standard census of semisymmetric cubic graphs is M. Conder, A. Malnič, D.
Marušič and P. Potočnik, "A census of semisymmetric cubic graphs on up to 768 vertices", *J.
Algebraic Combin.* 23 (2006), 255–294, DOI `10.1007/s10801-006-7397-3`. Read depth:
`abstract/metadata only` — bibliographic detail taken verbatim from the reference list of the
Ars Mathematica Contemporanea paper (which I read at full text), cross-checked against an OpenAlex
title record; the census paper itself was not obtained.

### Correction 2 — there is no error in the Crnković–Rukavina–Šimac paper, and my "counterexample" was not one

C869 item OC-2 claimed that the 2020 paper's Table 1 row for the graph labelled `182D` recorded one
of the bundle's two one-frame kernels, and that the bundle's asymmetry refuted the paper's
equivalence claim. **Both halves are wrong.**

- The paper's table covers **bipartite cubic symmetric graphs**. Since the bundle's graph is
  semisymmetric, it is not in that table, and the `182D` row is a different graph. The agreement I
  found — dimension 14, and a minimum distance matching one of the bundle's two sides — was a
  parameter coincidence, and I over-weighted it because I had already made the wrong graph
  identification in Correction 1. This is the failure mode the conventions warn about: I matched on
  parameters rather than resolving the object.
- The paper's equivalence claim is **correct within its stated scope**. Arc-transitive graphs are
  vertex-transitive, so a part-swapping automorphism exists and the two codes are equivalent. The
  argument I called flawed is sound for the class the paper is about.
- The same authors' 2022 follow-up handles the semisymmetric case explicitly and correctly, and
  tabulates both codes with differing distances, as documented under item 2 above.

**Nothing in the lane's work refutes a published claim.** The C869 opening summary, verdict table,
item OC-2, and the first two incidental observations all need withdrawing or rewriting; that is a
C869 edit and is not made here, since this task owns only its own report. The lane should treat the
"publishable correction" line in the C869 report as retracted with immediate effect.

What survives from OC-2 is smaller but real: the bundle's two one-frame kernels are inequivalent,
which is expected for a semisymmetric graph and is the phenomenon the 2022 paper tabulates; and the
bundle's specific graph does not appear in either authors' tables, so its two codes are not
individually pre-empted by them.

## Search record

### Services, and why zbMATH again replaces Crossref for keyword work

Restated as instructed. Crossref's `query.bibliographic` is relevance ranking over an implicit OR,
so its `total-results` is not a set size and cannot license a keyword negative. **OpenAlex,
Semantic Scholar and zbMATH Open** carry the keyword negatives here. Crossref *is* used, correctly,
for one thing it does well: a forward-citation count, where it has real reference data. That split
— Crossref for citing sets, zbMATH for keyword conjunctions — is the one I recommend the
conventions adopt.

### Empty versus error, per service

- **OpenAlex**: empty is HTTP 200 with `meta.count = 0`; errors raise in the client and print a
  traceback.
- **Semantic Scholar**: empty is HTTP 200 with `"total": 0`; HTTP 429 is retried with backoff and a
  give-up prints `S2_ERROR`, so a printed count is always a real response.
- **zbMATH Open**: **empty is HTTP 404**, re-confirmed this round with live controls —
  `Recursive construction of projective two-weight linear codes` → 200 with 1 result, while
  `affine polar graph local graph subconstituent`, `two-weight codes quotient construction smaller
  code`, `strongly regular graph from quadratic form quotient rank reduction` and
  `folded graph quotient fixed-point-free involution code` all → 404. Same-shaped queries returning
  both outcomes is why 404 reads as "no documents matched".
- **Direct dataset and paper fetches** (the SRG book preprint, both Conder censuses, the two
  Crnković–Rukavina–Šimac papers): plain `curl` on generic URLs, **all matching done locally**.

### Forward-citation counts for Calderbank–Kantor, recorded separately

Seed pinned by DOI `10.1112/blms/18.2.97`, OpenAlex work `W1973483608`, Semantic Scholar paper
`37700a7fc501b3f3679250b4189266a214c57a0c`. Counts as retrieved:

| Service | Citing count |
|---|---|
| OpenAlex | 656 |
| Crossref (`is-referenced-by-count`) | 474 |
| Semantic Scholar | 699 |

The spread is wide — Crossref is 32% below Semantic Scholar — and that disagreement is itself the
reportable finding the conventions ask for. The largest set (Semantic Scholar, 699) was retrieved
in full and screened; see below.

### Screened sets

1. **The Calderbank–Kantor citing set, Semantic Scholar, 699 records** retrieved by paging the
   citations endpoint. Screened **over titles only** (the fields retrieved were title, year and
   external identifiers; no abstracts). Discriminator applied mechanically, verbatim, as a
   case-insensitive regular expression:
   ```
   \bfold|quotient|subconstituent|local graph|antipodal|cover|recursi|inductiv|induction|
   descend|tower|ladder|hierarch|nested|series of|family of two-weight|neighbourhood|
   neighborhood|link\b
   ```
   35 records matched. Screening those 35 by title: the "antipodal" matches are all the
   *code-theoretic* sense (a code containing the all-ones word) rather than the graph-covering
   sense — e.g. "The classification of antipodal two-weight linear codes" (DOI
   `10.1016/j.ffa.2017.12.010`, 2018) and "Antipodal two-weight rank metric codes" (DOI
   `10.1007/s10623-023-01283-9`, 2023), both read depth `abstract/metadata only` (OpenAlex and
   Semantic Scholar records; neither carries an abstract in those services and neither was
   obtained). The "cover" matches are covering radius. The "hierarch" matches are weight
   hierarchies. **One record survived as genuinely on-point** and is promoted below.
2. **OpenAlex `("semisymmetric" AND cubic)`** — 53 records, screened over title. Discriminator:
   *is this a census of semisymmetric cubic graphs, or a code construction from them?* Two passed,
   both named above (the 2006 census and the 2022 Ars Mathematica Contemporanea paper).
3. **OpenAlex `("affine polar graph")`** — 18 records, screened over title. Discriminator: *does
   this relate affine polar graphs at different ranks?* Zero passed; the set is partial difference
   sets, bent functions, and lifting constructions. Read depth for the set: covered by this record.
4. **OpenAlex `("subconstituent" AND "strongly regular")`** — 42 records, screened over title.
   Discriminator: *does this give a rank-descent relation within a family from quadratic forms?*
   Zero passed at title level; the classical entry "Strongly regular graphs having strongly regular
   subconstituents" (DOI `10.1016/0021-8693(78)90220-x`, 1978; read depth `abstract/metadata only`,
   OpenAlex record) is a classification of a property, not a family recursion. The rank-descent
   material was found in the book instead, which is the right place for it.
5. **OpenAlex `("antipodal quotient" AND "distance-regular")`** — 12 records, and
   **`("folded" AND "distance-regular graph")`** — 39 records; both screened over title.
   Discriminator: *does this construct a folded/antipodal quotient relating two members of a family
   of graphs from quadratic forms?* Zero passed in either. Read depth for both sets: covered here;
   no member named individually.

**Promoted from set 1.** Jong Yoon Hyun and Zhao Hu, "Recursive construction of projective
two-weight linear codes", *Finite Fields and their Applications* 110, Article ID 102751, 11 p.
(2026), DOI `10.1016/j.ffa.2025.102751`, zbMATH `https://zbmath.org/8133634`, MSC 94B05. Read depth:
**`review only`** — the zbMATH Open review by Peter Boyvalenkov (Sofia), retrieved through the
zbMATH API. The review reads in full:

> "A construction of projective two-weight linear codes starting from the same type of codes if
> presented. The authors provide interesting examples but do not comment whether or not all
> projective two-weight linear codes can be obtained via their method."

(The "if" is as printed in the review.) This is a second, independent construction relating
two-weight codes to two-weight codes, and it is exactly the kind of thing item 1 asked about.
Attributed to the reviewer and **unverified against the paper**: I could not obtain the text —
Unpaywall reports `is_oa: False` with no open locations, there is no arXiv preprint (checked by
author and by title terms), and Semantic Scholar's record carries no abstract. Whether their
recursion is the fold, its inverse, or unrelated is **undetermined**, and is carried in the
coverage statement as an open gap. It does not change item 1's verdict, which rests on the
graph-theoretic predecessor and is already decisive.

### Verbatim load-bearing queries

OpenAlex (`filter=`):
```
title_and_abstract.search:("affine polar graph")                          -> 18
title_and_abstract.search:("subconstituent" AND "strongly regular")       -> 42
title_and_abstract.search:("local graph" AND "strongly regular graph")    -> 4
title_and_abstract.search:("antipodal quotient" AND "distance-regular")   -> 12
title_and_abstract.search:("folded" AND "distance-regular graph")         -> 39
title_and_abstract.search:("semisymmetric" AND cubic)                     -> 53
```

zbMATH Open (`search_string=`):
```
strongly regular graphs Brouwer Van Maldeghem book                        -> 1
recursive construction projective two-weight linear codes                 -> 1
cubic semisymmetric graphs census                                         -> 3
affine polar graph local graph subconstituent                             -> 404 / empty
two-weight codes quotient construction smaller code                       -> 404 / empty
strongly regular graph from quadratic form quotient rank reduction        -> 404 / empty
folded graph quotient fixed-point-free involution code                    -> 404 / empty
```

Semantic Scholar (bulk endpoint, `query=`):
```
"semisymmetric" + cubic                                                   -> 48
```

arXiv (`search_query=`):
```
au:"Hyun, Jong Yoon"                                                      -> 12 (no match)
ti:"two-weight" AND ti:"projective"                                       -> 11 (no match)
abs:"two weight" AND abs:"recursive"                                      -> 3  (no match)
```

Local (no outbound parameters): matching of the SRG book text, both Conder censuses, and both
Crnković–Rukavina–Šimac papers was done with `grep`/`sed` on this host against downloaded files.

### Sources named in this report, with read depth

| Source | Read depth |
|---|---|
| Brouwer & Van Maldeghem, *Strongly Regular Graphs* (author-hosted **preprint**; Cambridge 2022 edition not read) | `partial` |
| Conder & Potočnik, semisymmetric cubic graph census summary (2018 file, graphs found 2012) | `full text` (of the listing) |
| Conder, trivalent symmetric graph census to 10,000 vertices (2011 listing) | `full text` (carried over from C869, same bytes) |
| Crnković, Rukavina & Šimac, *LDPC codes from cubic semisymmetric graphs*, Ars Math. Contemp. 22 (2022) #P2.03 | `full text` (published open-access version) |
| Crnković, Rukavina & Šimac, *LDPC codes constructed from cubic symmetric graphs*, arXiv:2002.06690 | `full text` (**preprint only**; carried over from C869) |
| Calderbank & Kantor, *The Geometry of Two-Weight Codes*, Bull. London Math. Soc. 18 (1986) 97–122 | `full text` (re-read this round for the rank question) |
| Hyun & Hu, *Recursive construction of projective two-weight linear codes*, Finite Fields Appl. 110 (2026), Art. 102751 | `review only` (zbMATH, reviewer Peter Boyvalenkov) |
| Brouwer & Shult, *Graphs with odd cocliques*, Europ. J. Combin. 11 (1990) 99–104 | `secondary only` (via the SRG book) |
| Pasechnik, *On some locally 3-transposition graphs*, pp. 319–325 in Finite Geometry and Combinatorics, LMS Lecture Note Ser. 191, 1993 | `secondary only` (via the SRG book) |
| Goldschmidt, *Automorphisms of trivalent graphs*, Ann. of Math. 111 (1980) 377–406 | `secondary only` (via the census header) |
| Moorhouse, *Ovoids from the E8 root lattice*, Geom. Dedicata 46 (1993) 287–297 | `secondary only` (via the SRG book bibliography; also unobtained in C866) |
| Conder, Malnič, Marušič & Potočnik, *A census of semisymmetric cubic graphs on up to 768 vertices*, J. Algebraic Combin. 23 (2006) 255–294 | `abstract/metadata only` |
| Cameron, Goethals, Seidel & Shult, *Strongly regular graphs having strongly regular subconstituents*, 1978 | `abstract/metadata only` (named only to be dismissed) |
| *The classification of antipodal two-weight linear codes*, Finite Fields Appl., 2018 | `abstract/metadata only` (named only to be dismissed) |
| *Antipodal two-weight rank metric codes*, Des. Codes Cryptogr., 2023 | `abstract/metadata only` (named only to be dismissed) |
| Chakravarti, IMA Volumes chapter, DOI 10.1007/978-1-4613-8994-1_4 | `abstract/metadata only` (still not obtained — see coverage) |

**Hashes for items fetched this round.** SRG book preprint
`fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`; semisymmetric census
`606b2378d9939284d3c65d8f0ea855ce1fe2ff0d179d1c770d7261a2606879b0`; Ars Mathematica Contemporanea
paper `833477b8b879201e21132f50845c41187a65e22ed0b3f4441beaea4ee1862ce9`. The first two are not in
the shared literature cache (a book preprint I hold at `partial`, and a plain-text dataset that
`litcache` refuses as non-PDF); the hashes above are their record. Carried over and already cached:
Calderbank–Kantor `10.1112/blms/18.2.97` /
`986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`, and arXiv:2002.06690 /
`10ee616dd9b16d2129a8b26e4da293cb7c53394debe7bd6783672fedd66b4914`.

## Query hygiene

No slip. Every outbound request was either generic published vocabulary — "affine polar graph",
"subconstituent", "antipodal quotient", "folded", "distance-regular graph", "semisymmetric",
"two-weight", "recursive construction" — or a plain URL fetch of a whole public document or dataset.
No parameter, rank, weight enumerator, length, exceptional label, or description of the tower left
this host. The two decisive identifications (Proposition 3.6.1 and the census entry) were made by
downloading a 53,000-line book and a census file and grepping them locally, which is the method the
task specified.

## Coverage statement

### Searched and found nothing (licenses a negative)

- No published statement of the fold as a map of **codes** carrying weight enumerators level by
  level. This is the only surviving residue of item 1, and the finding above is that it is thin.
- No published correction, erratum, or comment on the 2020 Crnković–Rukavina–Šimac paper. Searched
  via the citing sets and by title across OpenAlex, Semantic Scholar and zbMATH; nothing found — and
  the item-2 finding is that none is warranted, so this negative is consistent rather than load-bearing.

### Could not access (licenses nothing; carried forward as open gaps)

- **MathSciNet — NOT COVERED.** Institutional authentication required. All negatives keep "to our
  knowledge".
- **Google Scholar — NOT COVERED.** Blocks automated access.
- **Hyun & Hu (2026), *Recursive construction of projective two-weight linear codes*.** Held at
  `review only`. Not open access, no preprint located, no abstract in any service. **Whether its
  recursion is our fold is undetermined.** Given the item-1 verdict this is no longer blocking, but
  it must be read before any claim that the code-level statement is unpublished.
- **The published Cambridge edition of Brouwer & Van Maldeghem.** I read the author-hosted
  preprint. Section and proposition numbers are stated by the authors to agree with the book, but
  I did not verify Proposition 3.6.1's numbering or wording against the published edition.
- **Brouwer & Shult (1990), Pasechnik (1993), Goldschmidt (1980), Moorhouse (1993).** All at
  `secondary only`. The primary statement of the rank-descent decomposition is Brouwer & Shult; I
  have it only as quoted and attributed by the book. This should be obtained before the predecessor
  is cited in a manuscript.
- **Conder, Malnič, Marušič & Potočnik (2006) census paper**, and the unpublished write-up of the
  2012 semisymmetric enumeration referred to in the census header. Metadata only.
- **Chakravarti, IMA Volumes chapter (DOI 10.1007/978-1-4613-8994-1_4).** Still paywalled; attempted
  again in C869 and not retried this round. Open since C866.
- **The published AAECC version of the 2020 Crnković–Rukavina–Šimac paper.** Still preprint-only.
  Now much less important, since the correction that depended on it has been withdrawn.

## Incidental observations (candidate discovery-track entries)

Recorded here only; not written to the discovery track by this task.

1. **Parameter coincidence caused a false identification, and a second census caught it.** Provenance:
   this audit's Corrections 1 and 2 against C869 items OC-1 and OC-2. Two distinct cubic bipartite
   girth-twelve graphs exist at the same order, one symmetric and one semisymmetric, and I matched
   the wrong one because I checked girth and bipartiteness but not vertex-transitivity — which the
   bundle's own data (non-isomorphic vertex stabilizers on the two sides) settles in one line. The
   general lesson is worth a convention: **when identifying an object against a census, check an
   invariant that the census's defining property does not already fix.** Girth was inside the
   symmetric census's assumptions; transitivity was the discriminating invariant and was free.
2. **The strongly-regular-graph literature is the lane's real neighbourhood, not the coding
   literature.** Provenance: this audit's item 1, where three rounds of code-side searching found no
   rank relation and a single book found it in general rank, by name, with a converse theorem and
   Lie labels attached. C866 and C869 both searched primarily code-side vocabulary. Future novelty
   questions about these objects should start from Brouwer–Van Maldeghem and the distance-regular
   graph literature.
3. **Crossref and Semantic Scholar disagree by a third on a well-known 1986 survey.** Provenance:
   this audit — 474 against 699, with OpenAlex at 656. On a heavily cited paper in a well-indexed
   journal. Any forward-citation closure claim built on a single service is unsafe by a wide margin,
   and the conventions' three-service rule is doing real work here.
4. **"Tower" is taken.** Provenance: the "Tower and clique sizes" subsection of Brouwer–Van
   Maldeghem's NO-graph material. If any future write-up in this lane uses the word for a family of
   graphs from quadratic forms related by local-graph operations, it collides with existing usage
   for the same kind of object.
