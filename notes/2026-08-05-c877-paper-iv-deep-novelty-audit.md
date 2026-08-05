# C877 — deep, unrestricted novelty re-audit of the Paper IV material

**Date:** 2026-08-05
**Task:** C877
**Lane:** `clebsch`
**Status:** complete
**Supersedes:** `notes/2026-08-05-c869-paper-iv-series-literature-audit.md` for every verdict it
shares. C869 was run under a non-disclosure rule that forbade our parameters, constructions, group
orders and design parameters from appearing in outbound queries. That rule belonged to a different,
now-closed track; applying it here removed the single most discriminating class of query. **This
audit ran with no query restriction of any kind**, and the exact-parameter route changed three
verdicts. C869's two retracted findings (the graph is semisymmetric, and the withdrawn
counterexample claim) are settled and were not revisited.

Governing conventions: `notes/literature-audit-conventions.md`, binding in full.

## Opening summary

**Six of this report's named sources carry read depth `full text`.** They are: Madison and Wu's
*On binary codes from conics in PG(2,q)* (arXiv preprint); Ma, Liu and Tian's *The binary codes
generated from quadrics in projective spaces* (published AIMS version); Hollmann and Xiang's
*Association schemes from the action of PGL(2,q) fixing a nonsingular conic in PG(2,q)* (arXiv
preprint); Crnković, Rukavina and Šimac's *LDPC codes from cubic semisymmetric graphs* (published
open-access version); Conder and Potočnik's census listing of semisymmetric cubic graphs to 10,000
vertices (a dataset, read at full text for the header and the relevant order block); and the
`codetables.de` bounds pages for the seven length/dimension pairs queried (a database, read at full
text for the rows relied on). Every other source named below — including every source named only in
order to be dismissed — carries `abstract/metadata only` or `secondary only`, and the per-source
table in the Search record is the authoritative list. Its `full text` rows number six.

**Three findings dominate this audit.**

**First, and the largest single change: the manuscript's twelve-dimensionality over F_8, and the
spanning of the code by each minimum-word family, are already implied by Madison and Wu's published
module decomposition.** The paper's priority boundary credits Madison and Wu only with the
dimension formula. Their Theorem 6.1(i) says considerably more: for q ≡ 1 (mod 4) the code, extended
to an algebraic closure of F_2, is a direct sum of (q−1)/4 pairwise non-isomorphic simple modules of
dimension q−1 for PSL(2,q). At q = 13 that is three non-isomorphic simple modules of dimension
twelve. Given that those three are a single Frobenius orbit — which the lane's own computation
establishes, as the three Gram scalars α, α², α⁴ — the code is an irreducible F_2-module of
dimension thirty-six with endomorphism field F_8, hence twelve-dimensional over F_8, and every
nonzero orbit of codewords spans it. The F_8 structure and the spanning statement are therefore
**KNOWN IN SUBSTANCE** and the boundary paragraph must be rewritten to credit Madison and Wu for
the module decomposition, not only the nullity. What survives as the lane's own is the *marking* —
the canonical selection of A_9 among the three Frobenius conjugates — and the identification of the
scalar action with an operator constructed from minimum-word pair data. The Frobenius-orbit step is
my inference, marked as mine, and is not stated by Madison and Wu, who work only over the algebraic
closure and never pass to an F_2-form.

**Second, the 182-vertex correspondence graph has a much sharper predecessor than C869 recorded.**
It is not merely "an entry in a census". It is one of exactly five graphs in the Iofinova–Ivanov
1985 classification of cubic semisymmetric graphs whose automorphism group acts primitively on each
part, and it is the member whose automorphism group is PGL(2,13). Its two parts, of size ninety-one
each, are the two primitive degree-91 actions of PGL(2,13) — on octahedral subgroups and on the
chords of the projective line — which is exactly the lane's S_4 ← D_8 → D_24 amalgam. The graph and
its two sides have been in the literature since 1985 and no part of that construction may be
presented as new.

**Third — and this reverses a C869 pre-emption — neither one-frame kernel has a located
predecessor.** C869 read the `[91,14,26]` code as published in Crnković, Rukavina and Šimac's
cubic-*symmetric*-graph table; C871 withdrew that match, since the row belongs to a different graph.
I obtained the same authors' 2022 cubic-*semisymmetric* paper at full text — the paper that does
handle graphs of our type, and does tabulate both sides separately — and **order 182 is absent from
its Table 1**, whose orders run 54, 112, 120, 144, 216, 240, 294, 336, 378, 384, 400, 432, 448, 486,
546, 576, 672, 702, 720, 784, 798, 864, 882, 896. Their graphs come from the Bretto–Gillibert
G-graph construction rather than from the full census, and the Iofinova–Ivanov graph of order 182 is
not among them. So `[91,14,28]` and `[91,14,26]` are both **NO PREDECESSOR LOCATED**, and the
C869 verdict "PRE-EMPTED in part" is withdrawn.

**Nothing newly pre-empts any of the five priority items.** The parity-complement lift, the
cross-orbital exhaustion, the higher shell, the support-XOR identities and the colour-lift theorem
all come back NO PREDECESSOR LOCATED after direct parameter and construction queries. Two of them
are elementary enough that I recommend stating them with proof and claiming nothing.

**Blocking gaps:** the body of Droms, Mellinger and Meyer (2006), which is closed access and which I
could not obtain by any route, and whose minimum-distance section is the one place a computed value
of d at q = 13 could plausibly sit; the Iofinova–Ivanov 1985 primary; and MathSciNet's search and
review layers.

## Verdict table

Priority items first, then the released paper's claims, then the sweep.

| # | Item | Verdict |
|---|---|---|
| **P-1** | Parity-complement lift `ker(C+J) = ker C ⊕ ⟨1⟩`, and `[91,15,28]` | **NO PREDECESSOR LOCATED**; elementary, recommend claiming nothing |
| **P-2** | Cross-orbital exhaustion over all 127 orbital sums | **NO PREDECESSOR LOCATED** for the exhaustion; **FOLKLORE** for the method (codes from orbit/orbital matrices) |
| **P-3** | Higher shell `[1092,37,204]` and the `C ↦ C+J` two-cycle | **NO PREDECESSOR LOCATED**, and none expected |
| **P-4** | The two support-XOR identities | **NO PREDECESSOR LOCATED** for the identities; the underlying graph is **PRE-EMPTED** (see G-1) |
| **P-5** | A_2-transversal colour-lift theorem, and `[81,8,36]` | **NO PREDECESSOR LOCATED**; elementary, recommend claiming nothing |
| **M-1** | Parameters `[78,36,12]` and the count of 364 minimum words | **NO PREDECESSOR LOCATED** for d = 12 and for the count; the interval 8 ≤ d ≤ 12 is **PRE-EMPTED** and correctly cited |
| **M-2** | Four minimum-word families, one octahedral and three chord-indexed | **NO PREDECESSOR LOCATED** |
| **M-3** | Each family spans the code | **FOLKLORE / KNOWN IN SUBSTANCE** — immediate from Madison–Wu Theorem 6.1(i) plus Frobenius conjugacy |
| **M-4** | Twelve-dimensionality over a canonical operator field F_8 | **KNOWN IN SUBSTANCE** — Madison–Wu Theorem 6.1(i); the *marking* is not |
| **M-5** | Weighted-pair reconstruction of incidence matrix, code and six-class elliptic scheme | **NO PREDECESSOR LOCATED** |
| **M-6** | Reconstruction of PG(2,13), its conic and polarity | **NO PREDECESSOR LOCATED** |
| **M-7** | Automorphism group exactly PGL(2,13) | **NO PREDECESSOR LOCATED** |
| **M-8** | Positive-semidefinite and line-moment certificates excluding weights 8 and 10 | **NO PREDECESSOR LOCATED**; the ambient method (Segre's lemma of tangents) is classical and cited |
| **M-9** | Attribution to Droms–Mellinger–Meyer | **CORRECT**, at the evidence level the paper uses |
| **M-10** | Attribution to Ma–Liu–Tian for the interval | **CORRECT AND VERIFIED** at full text |
| **M-11** | Attribution to Madison–Wu for the dimension formula | **CORRECT BUT TOO NARROW** — see M-3, M-4 |
| **M-12** | Attribution to Hollmann–Xiang for the elliptic scheme | **CORRECT BUT NEEDS A PRIOR CREDIT** — they attribute the first description to Hollmann's 1982 thesis |
| **G-1** | The 182-vertex correspondence graph | **PRE-EMPTED** — Iofinova–Ivanov (1985); `X.182.1` in Conder–Potočnik |
| **G-2** | The one-frame kernels `[91,14,28]`, `[91,14,26]` | **NO PREDECESSOR LOCATED** (C869's partial pre-emption withdrawn) |
| **S-1** | Dual-number frame modules, golden exchange, F_64 exclusion | **FOLKLORE** — carried from C869, re-checked by parameter query, unchanged |
| **S-2** | Frame channel, Tanner framing, algorithmic bounds, compact representations | **FOLKLORE** — carried from C869, unchanged |
| **S-3** | Quantum formulations, `[[91,63,3]]`, hypergraph-product seed | **FOLKLORE** in every component; assembled instance has no located predecessor |
| **S-4** | Column-extension obstruction and its Farkas certificate | **FOLKLORE** method; present as a certificate, not a method |
| **S-5** | Clebsch-connection proposal | **FOLKLORE** — Dickson's subgroup classification; the document says so |
| **S-6** | E_7 minimum shell as a 2-(28,12,11) design | **PRE-EMPTED as a design class** — it is a quasi-symmetric 2-(28,12,11) design, a classified family |
| **S-7** | E_8 root-pair code `[120,9,56]` | **KNOWN IN SUBSTANCE** — a self-complementary code meeting the Grey–Rankin bound; such codes are characterised in the literature |
| **S-8** | E_6 code `[27,6,12]` and the A_2 lift's near-optimality | **FOLKLORE / KNOWN IN SUBSTANCE** — unchanged from C869 (Calderbank–Kantor); `codetables.de` confirms the `[81,8]` optimum is 38 |

## Priority items

### P-1 — the parity-complement lift

**Verdict: NO PREDECESSOR LOCATED. Recommendation unchanged from C869: state it with proof and
claim nothing.**

The statement is that for an n-by-n binary incidence matrix with n odd and all row and column
degrees odd, `ker(C+J) = ker C ⊕ ⟨1⟩` with
`d(ker(C+J)) = min{d(ker C), n − maxwt(ker C)}`. With the disclosure constraint lifted I was able to
query the natural homes for it directly, and found nothing: zbMATH `p-rank complementary design`
returns one 2024 record on modular representations of symmetric 2-designs, `2-rank of the
complementary design` returns one 1999 record of Tonchev on linear perfect codes, and
`codes of a design and its complement` returns twelve records of which none, screened over title,
concerns the rank or kernel relation between a matrix and its complement. OpenAlex returns zero for
each of `"complementary design" AND "binary code" AND rank`, `("all-ones matrix" AND kernel AND
"GF(2)")`, and a usable count for `("2-rank" AND complement AND design)` (one record, on chronic
pain — a false positive dismissed on title).

The natural place for a statement of this kind is Assmus and Key, *Designs and their codes* (1992),
which I located as a zbMATH record but did not obtain. Read depth: `abstract/metadata only` —
zbMATH record 53917, title, authors and year only. Because I did not read it, this report does not
assert either that it contains the lemma or that it does not; the gap is carried forward.

**MY inference, marked as mine:** this is an eight-line linear-algebra argument and I would expect
it to exist in equivalent form somewhere in the design-codes literature. A generic search cannot
reach an unnamed lemma, and an exact-parameter search cannot either, because the lemma carries no
parameters. This is the one priority item whose negative the lifted constraint did *not*
materially strengthen.

### P-2 — the cross-orbital exhaustion

**Verdict: NO PREDECESSOR LOCATED for the exhaustion; FOLKLORE for the framework.**

The claim is that among all 127 nonzero binary sums of the seven G-orbitals in
`G/S_4 × G/D_24`, none has kernel of minimum distance above 28 and none at distance 28 has dimension
above 15. Constructing codes from the binary sums of orbital matrices of a permutation group is an
established programme with a name and a school: OpenAlex `"orbit matrices" AND codes` returns 39
records, and the visible top of that set is uniformly Crnković and collaborators constructing
self-orthogonal and self-dual codes from orbit matrices of designs, Hadamard matrices, weighing
matrices, Menon designs and strongly regular graphs. The Key–Moori–Rodrigues method of building
designs and codes from a primitive permutation representation of a group is the same idea from the
group side; zbMATH `codes from primitive permutation representations of groups Key Moori` returns
five records headed by Key, Moori and Rodrigues (2003). **The framework is not new and the bundle
does not claim it is.**

What is not located is any work carrying out this exhaustion for PGL(2,13) in its two degree-91
actions, or reporting any of the resulting codes. Direct group queries return nothing on point:
OpenAlex `"PGL(2,13)"` returns one record (a thesis on monomial progenitors, dismissed on title),
`"PSL(2,13)" AND (code OR design)` returns one record on flag-transitive 4-designs, and zbMATH
`PGL(2,13) codes designs` and `designs codes PSL(2,13)` each return the same single 4-designs
record. Read depth for all three: `abstract/metadata only`, from the respective work records; none
is discussed further.

### P-3 — the higher shell and the parity-complement two-cycle

**Verdict: NO PREDECESSOR LOCATED, and none expected.** These are computations about the two
weight-38 orbits of a specific code under a specific group. Exact-parameter queries return nothing:
OpenAlex `"1092,37,204"` returns zero, and `codetables.de` has no entry at length 1092 to compare
against. The bundle states itself that it "does not claim a uniform higher-shell theorem". Nothing
here makes a claim against the literature and the verdict is unchanged from C869.

### P-4 — the support-XOR identities

**Verdict: NO PREDECESSOR LOCATED for the two identities. The graph they live on is PRE-EMPTED;
see G-1.**

The identities say that each octahedral minimum support is the symmetric difference of its three
neighbouring punctured-conic supports and conversely. Searching for the identity shape directly
returns nothing: OpenAlex gives zero for `("symmetric difference" AND "three neighbours" AND graph
AND code)` and zero for `("neighbour sum" AND "cubic graph" AND "binary code")`; zbMATH
`symmetric difference of neighbours cubic bipartite graph binary code` returns one record, Brouwer
and Van Maldeghem's *Strongly regular graphs* (read depth `abstract/metadata only`, zbMATH record
7437385, named only to be dismissed — it is a monograph on a different subject and matched on
generic vocabulary).

The caution that must accompany this negative is that the identities are statements about the
Iofinova–Ivanov graph, which has been studied since 1985 in a literature I have only reached at
secondary depth. A property of a well-studied graph is exactly the kind of thing that can sit in an
unindexed 1985 Russian-language volume. **MY inference, marked as mine:** the identities are however
not statements about the graph alone — they involve the seventy-eight-coordinate supports, which are
Paper IV's objects and not the graph's — so a predecessor would have to have made the same link
between this graph and this code, and no work linking them was located at all.

### P-5 — the A_2-transversal colour-lift theorem

**Verdict: NO PREDECESSOR LOCATED. Recommendation unchanged: state as a lemma with proof, claim no
novelty.**

Unrestricted queries for the construction return nothing usable. OpenAlex returns zero for each of
`("3-uniform hypergraph" AND "colour" AND "binary code")` and `("hypergraph" AND "colouring" AND
"lifted code" AND "minimum distance")`; zbMATH returns empty (HTTP 404) for
`lift of a binary code by colourings of hyperedges` and for `three-uniform hypergraph incidence
kernel colour transversal`. The resulting `[81,8,36]` code is not competitive and its context is
confirmed rather than contested: `codetables.de` gives lower bound 38 and upper bound 38 at
`[81,8]` over GF(2), matching the bundle's own statement that the lift misses the optimum by two.

## The released paper's own claims

The manuscript is `papers/q13-passant-code/passant_code_q13.tex`, deposited at DOI
`10.5281/zenodo.21783971`.

### M-1 — the parameters and the count of 364 minimum words

**Verdict: the distance interval is PRE-EMPTED and correctly cited; the value d = 12 and the count
of 364 minimum words are NO PREDECESSOR LOCATED, and the negative here is unusually well
supported.**

The strongest evidence is a positive statement in a 2024 survey rather than an absence. Ma, Liu and
Tian close their paper by listing open developments, the first of which is: "For the minimum
distances of C(M) and C⊥(M) in PG(2,q), the exact values need further proofs." Their Table 1 row
for dimension `(q−1)²/4` gives `(q+3)/2 ≤ d ≤ q−1` with reference [9] = Droms, Mellinger and Meyer,
which at q = 13 is exactly the interval `8 ≤ d ≤ 12` the manuscript quotes. Read depth: `full text`
of the published AIMS version — shared cache key `10.3934/math.20241421`, SHA-256
`47c0a52292517a1773a676e2422e7b5a4a7b4bae502b70c1015f8fe87c61c984`; sections relied on are the
concluding open-problems list and Table 1 with its reference column.

The forward-citation neighbourhood of Droms, Mellinger and Meyer was enumerated from all three
services as required. **OpenAlex 19, Crossref 13, Semantic Scholar 24** — a three-way disagreement,
recorded as a finding. The largest set was screened. Discriminator, applied over title:
*does this work compute or bound the minimum weight, or classify minimum-weight codewords, of the
passant-line/internal-point conic code?* Zero passed. The set divides into dimension and 2-rank
papers (Sin–Wu–Xiang, Wu, Madison–Wu, Adams–Wu), papers on adjacent but different codes (functional
codes on quadric intersections, the Hermitian dual code, orbit-conic codes), general LDPC and
network-coding items, and the 2024 survey. The same exercise on Madison and Wu (2012) gives
**OpenAlex 9, Crossref 4, Semantic Scholar 10** — again a disagreement — and the same discriminator
again passes nothing.

Crossref's counts are the lowest in both cases. Consistent with the calibration carried from C866,
Crossref's bibliographic query is relevance-ranked over an implicit OR and was used here only for
DOI-anchored citation counts, never for a keyword negative.

Exact-parameter queries add nothing and no longer need to be avoided: OpenAlex returns zero for
`"91,14,28"`, `"[91,15,28]"` and `"1092,37,204"`, and `codetables.de` shows the manuscript's code
is far from record territory — at `[78,36]` over GF(2) the best known distance is 16 with upper
bound 20, against 12 here. That is expected for a geometric LDPC code and is not a defect; it is
recorded so that no one later reads the parameters as a records claim.

### M-2 — the four minimum-word families

**Verdict: NO PREDECESSOR LOCATED.** No work located classifies the minimum-weight codewords of
this code at all, so a fortiori none identifies them as one S_4-orbit and three D_24-orbits. This
rests on the same screened citing sets as M-1.

### M-3 and M-4 — spanning, and twelve-dimensionality over F_8

**Verdict: KNOWN IN SUBSTANCE. This is the audit's most consequential finding for the released
paper, and it is a citation problem rather than a novelty loss.**

Madison and Wu, Theorem 6.1(i), states that for q ≡ 1 (mod 4) the kernel decomposes, over an
algebraic closure F of F_2, as a direct sum of (q−1)/4 pairwise non-isomorphic simple FH-modules of
dimension q−1, where H = PSL(2,q). Read depth: `full text` of the arXiv preprint (arXiv:1104.0324v1,
2 April 2011, 23 pages), shared cache key `arXiv:1104.0324`, SHA-256
`f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`; sections relied on are the
introduction and Section 6 including Theorem 6.1 and Lemma 6.2. **Version caveat:** I read the
preprint, not the published *European Journal of Combinatorics* 33 (2012) 33–48 version, so every
statement here about "Madison and Wu" is characterised from the preprint. I checked the whole
extracted text for any statement about minimum weight or about the automorphism group of the code
and found none, which is the basis for the negative at M-1 and M-7.

At q = 13 the theorem gives three pairwise non-isomorphic simple modules of dimension twelve.
**MY inference, marked as mine and kept separate from the paper's framing:** because those three are
a single orbit under the Frobenius automorphism of F over F_2 — which Madison and Wu do not state,
and which the lane's own computation supplies in the form of the three Frobenius-conjugate Gram
scalars α, α², α⁴ — the F_2-form of the code is a *single* irreducible F_2-module of dimension
thirty-six whose endomorphism ring is F_8. That is precisely "twelve-dimensional over a canonical
operator field F_8". And irreducibility over F_2 makes the spanning statement immediate: a
G-orbit of nonzero codewords spans a nonzero G-submodule, which must be everything.

**Consequence for the manuscript, stated plainly.** The priority paragraph currently reads "Madison
and Wu proved the general nullity formula (q−1)²/4". That understates what they proved and leaves
the paper claiming as its own two statements that follow from their theorem in a line each. The
paragraph should credit the module decomposition, then claim only what remains: the *marking* of
A_9 as a distinguished Frobenius conjugate, and the construction of the F_8 action from minimum-word
pair data rather than from block theory. Those two do remain unlocated.

### M-5, M-6, M-7 — reconstruction, and the automorphism group

**Verdict for all three: NO PREDECESSOR LOCATED.**

The pattern "the minimum-weight codewords of a geometric code recover the geometry" is classical —
the archetype being that the minimum-weight words of the p-ary code of PG(2,q) are the scalar
multiples of lines. I did not chase a primary citation for the archetype and no verdict rests on
one; it is asserted here as standard, in the same way the manuscript treats it. What is at stake is
the specific reconstruction: that *weighted pair concurrences alone*, with no triple data and no
coordinates, recover the passant incidence matrix, the code, the six-class elliptic scheme, and
then PG(2,13) with its conic and polarity.

Searches for a predecessor return nothing on point. OpenAlex gives zero for `("minimum weight
codewords" AND "projective plane" AND lines)` and for `("two-section" AND hypergraph AND
invariant)`; `("reconstruct" AND "projective plane" AND "association scheme")` returns one record,
*Association schemes on the set of antiflags of a projective plane* (1994), read depth
`abstract/metadata only` (OpenAlex work record), dismissed on title as constructing a scheme rather
than reconstructing a plane. zbMATH `reconstruction of the projective plane from its code` returns
one record, a conference extended-abstract volume, read depth `abstract/metadata only`, dismissed as
a container item.

On the automorphism group specifically: Hollmann and Xiang do not compute the automorphism group of
their schemes — the string "Aut" does not occur in the paper — and Madison and Wu do not compute the
automorphism group of the code. Two papers in the adjacent lineage do determine automorphism groups,
Wu's *Conics arising from internal points and their binary codes* (2013) and Madison and Wu's
*Conics arising from external points and their binary codes* (2016), but both concern the
orbit-conic block codes, whose rows are conics consisting entirely of internal or external points —
a different object, as C179 established. Read depth for both: `abstract/metadata only`, via zbMATH
records 6259548 and 6542908 for bibliographic detail (Linear Algebra Appl. 439, No. 2, 422–434
(2013); Des. Codes Cryptography 78, No. 2, 473–491 (2016)); zbMATH's summary text is unavailable
under its licence terms, neither has an arXiv preprint, and neither body was obtained. This is a
residual gap, but a narrow one: the code objects differ.

### M-8 — the weight-eight and weight-ten exclusion certificates

**Verdict: NO PREDECESSOR LOCATED for the certificates.** The ambient tool, Segre's lemma of
tangents, is classical and the manuscript already cites Ball and Lavrauw's survey for the
coordinate-free form. Positive-semidefinite and moment certificates for excluding a weight are
standard optimisation machinery. No absence claim is really at stake here; recorded so that the
omission of a search is visible rather than silent.

### M-9 to M-12 — the stated priority boundary, checked source by source

- **Droms, Mellinger and Meyer (2006), for the code and the distance bound — CORRECT at the
  evidence level used.** I could not obtain the body; see the coverage statement. The attribution is
  nonetheless safe because it is corroborated from two independent full texts: Madison and Wu open
  by stating that the code was constructed in that paper and that its dimension was conjectured
  there (their Conjecture 1.1, quoted as [4, Conjecture 4.7]), and Ma, Liu and Tian's Table 1
  attributes the distance interval to the same reference [9]. Read depth: `abstract/metadata only`
  — Semantic Scholar and Unpaywall records plus the zbMATH record 5075353 giving Des. Codes
  Cryptography 40, No. 3, 343–356 (2006). The zbMATH summary text is unavailable under its licence.
- **Ma, Liu and Tian, for the survey interval — CORRECT AND VERIFIED at full text.** See M-1.
- **Madison and Wu, for the dimension formula — CORRECT BUT TOO NARROW.** See M-3 and M-4.
- **Hollmann and Xiang, for the elliptic association scheme — CORRECT BUT NEEDS A PRIOR CREDIT.**
  Verified at full text: their Theorem 4.7(iii) gives the elliptic scheme on the elliptic
  (equivalently passant) lines with (q−1)/2 classes for q odd, which is six classes at q = 13 on 78
  lines, exactly the manuscript's six-class scheme; and they prove it pseudocyclic. But their
  introduction says the elliptic scheme "was first described in [7]", namely Hollmann's 1982 masters
  thesis at Eindhoven, and that their own contribution in the elliptic case is a new treatment plus
  the fusion results. The manuscript's "Hollmann and Xiang constructed the elliptic association
  scheme" should become something like "as treated by Hollmann and Xiang, who attribute its first
  description to Hollmann's 1982 thesis". Read depth: `full text` of the arXiv preprint
  (arXiv:math/0503573v1, 24 March 2005, 34 pages), shared cache key `arXiv:math/0503573`, SHA-256
  `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`; sections relied on are the
  abstract, the introduction, Theorem 4.7 and Theorem 6.9. **Version caveat:** the published
  *Journal of Algebraic Combinatorics* 24 (2006) 157–193 version was not read. Hollmann's 1982
  thesis: read depth `secondary only`, via Hollmann and Xiang's reference list, whose own depth is
  `full text`; the thesis was not sought.

**What the boundary misses.** Two things, both above: the Madison–Wu module decomposition (M-3,
M-4), and the prior credit inside the Hollmann–Xiang line (M-12). I looked specifically for a
predecessor among codes from conics, internal and external points, and association schemes of
PG(2,q) — that is the screened citing set at M-1 plus the C179 object ledger — and found no other.

### A manuscript-facing text error, not a literature matter

`notes/2026-07-31-results-summary-snapshot.md` § "Minimum-word reconstruction of PG(2,13) from a
binary conic code" says: "The underlying passant-line/internal-point incidence graph is the graph
`X.182.1` in Conder and Potočnik's census of semisymmetric graphs". That sentence conflates two
different graphs. At q = 13 there are 78 internal points and 78 passant lines and every row and
column of the incidence matrix has weight seven, so the passant/internal incidence graph is
7-regular on 156 vertices. `X.182.1` is cubic on 182 vertices; it is the octahedral–toric
*correspondence* graph, which is where the `[91,14,28]` and `[91,14,26]` kernels quoted in the same
sentence actually come from. The claim is right about the correspondence graph and wrong about which
graph it is. Flagged for the lane; I did not edit that file.

## The 182-vertex graph and the one-frame kernels

### G-1 — the correspondence graph is the Iofinova–Ivanov graph

**Verdict: PRE-EMPTED, and by a much older and sharper predecessor than C869 recorded.**

Iofinova and Ivanov proved in 1985 that there are exactly five cubic semisymmetric graphs whose
automorphism group acts primitively on each part of the bipartition, with 110, 126, 182, 506 and 990
vertices; the automorphism group of the 182-vertex member is PGL(2,13). Read depth for the
classification statement: `secondary only`, via Wolfram MathWorld's *Iofinova-Ivanov Graphs* article
(retrieved by WebFetch), which gives the five orders with their automorphism groups and states that
the 182- and 506-vertex graphs "can be described in terms of the projective line" over the fields of
order 13 and 23. That secondary source has read depth `full text` for the page itself. The primary,
A. A. Ivanov and M. E. Iofinova, *Biprimitive cubic graphs*, in *Investigations in the algebraic
theory of combinatorial objects* (1985), was located as zbMATH record 4158649 — read depth
`abstract/metadata only` — and was **not obtained**; it is carried forward as a gap.

The census identification is independently confirmed at full text. Conder and Potočnik's listing of
semisymmetric cubic graphs to 10,000 vertices, downloaded by `curl` from
`https://www.math.auckland.ac.nz/~conder/SemisymmCubic10000.txt`, SHA-256
`606b2378d9939284d3c65d8f0ea855ce1fe2ff0d179d1c770d7261a2606879b0`, 135,460 bytes, has exactly one
entry at that order: `X.182.1 : Order 182 Type G_2^1 graph Diameter 8 Girth 12`. Read depth:
`full text` of the header and the relevant order block, matched entirely locally. Not added to the
shared cache — it is plain text, and `litcache` refuses non-PDF bytes; the SHA-256 above is the
record. The census file credits the enumeration to Conder and Potočnik in 2012 using Goldschmidt's
universal amalgams.

**MY inference, marked as mine:** the bundle's amalgam S_4 ← D_8 → D_24 inside PGL(2,13) is the
standard presentation of this graph. The two parts are the two primitive degree-91 actions of
PGL(2,13), on the 91 self-normalising octahedral subgroups and on the 91 unordered pairs of points
of the projective line over the field of order 13; a biprimitive cubic graph on them with the full
group acting is exactly what the classification produces, and the census shows it is unique at that
order. No manuscript may present this graph, its bipartition, its girth or its automorphism group
as new.

### G-2 — the one-frame kernels

**Verdict: NO PREDECESSOR LOCATED for both. C869's "PRE-EMPTED in part" is withdrawn.**

C871 established that the `182D` row C869 matched belongs to the cubic *symmetric* graph, not to
ours. The remaining question — whether the same authors' semisymmetric-graph paper covers our graph
— is now answered negatively at full text. Crnković, Rukavina and Šimac, *LDPC codes from cubic
semisymmetric graphs*, Ars Mathematica Contemporanea 22 (2022) #P2.03, take the biadjacency block H
of a connected cubic semisymmetric graph as a parity-check matrix, note explicitly in their
Remark 4.2 that H and Hᵀ give codes of the same length and dimension and in general different
minimum distance, and tabulate both sides in Table 1 for cubic semisymmetric graphs on fewer than
1000 vertices. **Order 182 does not appear in Table 1.** The orders that do appear are 54, 112, 120,
144, 216, 240, 294, 336, 378, 384, 400, 432, 448, 486, 546, 576, 672, 702, 720, 784, 798, 864, 882
and 896. Their graphs are constructed by the Bretto–Gillibert G-graph method, not taken from the
census, which is why the Iofinova–Ivanov graph is missing.

Read depth: `full text` of the published open-access version — the definitive version, so no version
caveat applies — fetched from `https://amc-journal.eu/index.php/amc/article/view/2501/1658`, added
to the shared literature cache under key `10.26493/1855-3974.2501.4c4`, SHA-256
`833477b8b879201e21132f50845c41187a65e22ed0b3f4441beaea4ee1862ce9`, extracted by poppler
`pdftotext`. Sections relied on: the construction in Section 2, Theorems 2.8 and 2.9 on minimum
distance, Section 4 with Table 1, and Remarks 4.1 and 4.2.

Screened set: **Table 1 of that paper**, 24 rows, screened over the vertex-count column.
Discriminator, applied verbatim: *is the graph order 182?* Zero passed.

This also settles the general point C869 raised: these authors do **not** claim that the two sides
of a semisymmetric graph give equivalent codes. They state the opposite and present it as an
advantage of the construction. The C871 retraction is confirmed from the primary source.

Direct searches for the codes themselves return nothing: OpenAlex returns zero for `"Iofinova-
Ivanov"`, for `"Iofinova" AND code`, and for the exact parameter strings. OpenAlex
`"semisymmetric graphs" AND codes` returns three records: the 2022 paper just read, and two 2026
Zenodo depositions of a *Census of cubic edge-transitive graphs and their optimal LCF codes*
(read depth `abstract/metadata only`, OpenAlex work records, named only to be dismissed — "LCF code"
there means the Lederberg–Coxeter–Frucht notation for a cubic graph, not an error-correcting code).

## Sweep of the remaining bundle claims

Each item below carries a verdict, as instructed. Where C869 already reached a verdict by a route
the disclosure constraint did not affect, I re-checked it with a parameter or construction query
where one exists and carried it forward otherwise; where I carried it forward without a new query I
say so.

- **Dual-number frame modules and the golden dual-number exchange.** **FOLKLORE** at textbook level:
  an involution in characteristic two generates the dual numbers, and two ramifies in the golden
  order. Carried forward from C869 without a new query; there is no absence claim to discharge.
- **Exclusion of an equivariant F_64 repair.** **FOLKLORE** method (Schur's lemma, modular
  representation theory). The relevant module theory is now doubly anchored: Madison and Wu's
  Theorem 6.1(i) is precisely the statement that the constituents are twelve-dimensional and
  pairwise non-isomorphic, which is what forces the endomorphism ring down. The rank-143 linear
  system is a computation and needs no predecessor.
- **The frame channel.** **FOLKLORE** — weakly symmetric channel capacity is textbook. Carried
  forward from C869.
- **Tanner view and the frame metacode `[182,37,28]`.** **FOLKLORE** framing (Tanner 1981; read
  depth `abstract/metadata only`, carried from C869's zbMATH record 3745089). **NO PREDECESSOR
  LOCATED** for the code. C869 warned that this construction sits adjacent to a published one and
  must cite it; with G-2 revised, the adjacency is now to the *semisymmetric* paper rather than the
  symmetric one, and that is the paper to cite and distinguish. `codetables.de` at `[182,37]` gives
  lower bound 55 and upper bound 70 over GF(2), so the metacode's distance 28 is far from the
  record and no records claim is available.
- **Quantum formulations, the `[[91,63,3]]` CSS code, and the hypergraph-product seed.**
  **FOLKLORE** in every component (metachecks, CSS from a self-orthogonal code, Tillich–Zémor
  hypergraph product, Szegedy quantisation); **NO PREDECESSOR LOCATED** for the assembled instance.
  C869's specific finding that the code-CFT root-lattice literature is *not* a predecessor here
  stands and should not be re-opened.
- **Algorithmic bounds and compact representations.** **FOLKLORE**. No absence claim; no query run,
  recorded so the omission is visible.
- **Column-extension obstruction and Farkas certificate.** **FOLKLORE** method — the geometric
  method for optimal linear codes plus a Farkas dual of the linear-programming bound. The
  certificate is a new instance of an old method. Recommendation unchanged: present as a
  certificate, not a method.
- **The Clebsch-connection proposal.** **FOLKLORE** — Dickson's subgroup classification; the
  document says so itself.
- **E_7 minimum shell as a 2-(28,12,11) design.** **PRE-EMPTED as a design class**, and this is new
  relative to C869. Quasi-symmetric 2-(28,12,11) designs are a named and studied family: OpenAlex
  `"2-(28,12,11)"` returns three records, headed by Lam, Thiel and Tonchev, *On quasi-symmetric
  2-(28,12,11) and 2-(36,16,12) designs*, Designs Codes and Cryptography 5, No. 1, 43–55 (1995), and
  a 2023 Glasnik Matematicki paper on such designs with an automorphism of order 5. Read depth for
  both: `abstract/metadata only`, OpenAlex work records; neither obtained. The bundle's design has
  block intersections 4 and 6, which is exactly quasi-symmetry. The manuscript must present the
  E_7 minimum shell as an instance of this classified family, not as a new design.
- **E_8 root-pair code `[120,9,56]`.** **KNOWN IN SUBSTANCE.** OpenAlex `"[120,9,56]"` returns
  exactly one record: Gulliver and Harada, *Codes of lengths 120 and 136 meeting the Grey-Rankin
  bound and quasi-symmetric designs*, IEEE Transactions on Information Theory 45, No. 2, 703–706
  (1999), whose abstract characterises self-complementary codes with these parameters as optimal in
  the sense of meeting the Grey–Rankin bound and constructs quasi-symmetric designs from them. Read
  depth: `abstract/metadata only` — OpenAlex work record including the abstract; the paper was not
  obtained. **MY inference, marked as mine:** the bundle's `[120,9,56]` code is self-complementary
  with weight enumerator `1 + 255z^56 + 255z^64 + z^120`, so it lies in exactly the class that paper
  characterises, and the E_8 level of the ladder should cite it alongside Calderbank and Kantor.
- **E_6 code `[27,6,12]` and the ladder.** **FOLKLORE / KNOWN IN SUBSTANCE**, unchanged from C869's
  identification with Calderbank–Kantor Example RT2 through Brouwer's `(64,27,10,12)` row. Carried
  forward; not re-queried, since C869 reached it by a local dataset match that the constraint did
  not impair.

## Relevant to the concurrent Clebsch III / golden-operator audit

One item, routed rather than pursued: the two-graph and Seidel-matrix literature intersects the
"orbit matrices" programme surfaced at P-2 — OpenAlex `"orbit matrices" AND codes` includes
*Self-orthogonal codes from orbit matrices of Seidel and Laplacian matrices of strongly regular
graphs* (2019). If the other audit is enumerating the two-graph literature, that programme is a
place where Seidel-matrix objects and code constructions meet, and it may not surface under
two-graph vocabulary. Recorded for routing; not investigated here.

## Search record

### Services used

**OpenAlex, Semantic Scholar, zbMATH Open, and Crossref.** Crossref was used only for
DOI-anchored citation counts, never for a keyword negative: as established in C866 and carried
forward, its `query.bibliographic` parameter is relevance ranking over an implicit OR, so its
`total-results` is not a set size. Where a verdict rests on an enumerated citing set, all three
counts are recorded separately.

### How "empty" was distinguished from "error", per service

- **OpenAlex** (`api.openalex.org/works`, `mailto` identified): empty is HTTP 200 with
  `meta.count = 0`; a transport or query error raises and the helper prints `OA_ERROR` instead of a
  count. Every count below came off a 200 response.
- **Semantic Scholar** (`/graph/v1/paper/search/bulk` and `/citations`): empty is HTTP 200 with
  `"total": 0`; failures print `S2_ERROR`.
- **zbMATH Open** (`api.zbmath.org/v1/document/_search`): **empty is HTTP 404, not a zero count.**
  Re-confirmed in this session with fresh controls: `LDPC codes semisymmetric graphs` and
  `p-rank complementary design` returned 200 with results, while
  `null space complement incidence matrix all-ones matrix binary` and
  `three-uniform hypergraph incidence kernel colour transversal` returned 404. Near-identical query
  shapes returning both outcomes is why 404 is read as "no documents matched".
- **Crossref** (`api.crossref.org/works/<doi>`): used only for `is-referenced-by-count` on a
  resolved DOI; a bad DOI raises rather than returning zero.
- **`codetables.de`**: a bounds query returns an HTML page naming the lower and upper bound and the
  construction; an out-of-range query returns a page with no bound line, which is how the absence of
  a length-1092 entry was distinguished from a fetch failure.
- **Direct dataset fetches** (Conder–Potočnik census, the arXiv and journal PDFs): retrieved by
  `curl` and matched locally.

### Seeds, resolved by pinned identifier

| Seed | Identifier |
|---|---|
| Droms, Mellinger & Meyer 2006 | DOI `10.1007/s10623-006-0022-6`; OpenAlex `W1973242087`; S2 CorpusId 8873631 |
| Madison & Wu 2012 | DOI `10.1016/j.ejc.2011.08.001`; preprint arXiv:1104.0324 |
| Ma, Liu & Tian 2024 | DOI `10.3934/math.20241421` |
| Hollmann & Xiang 2006 | DOI `10.1007/s10801-006-0005-8`; preprint arXiv:math/0503573 |
| Crnković, Rukavina & Šimac 2022 | DOI `10.26493/1855-3974.2501.4c4` |
| The released paper | DOI `10.5281/zenodo.21783971` |

### Verbatim load-bearing queries

OpenAlex (`filter=title_and_abstract.search:`):

```
"passant lines" AND "internal points"                                   -> 10
"semisymmetric graphs" AND codes                                        -> 3
"semisymmetric" AND "biprimitive"                                       -> 8
"Iofinova-Ivanov"                                                       -> 0
"Iofinova" AND code                                                     -> 0
"91,14,28"                                                              -> 0
"[91,15,28]"                                                            -> 0
"1092,37,204"                                                           -> 0
"2-(28,12,11)"                                                          -> 3
"(28, 12, 11) design"                                                   -> 2
"[120,9,56]"                                                            -> 1
"[28,7,12]"                                                             -> 0
"orbit matrices" AND codes                                              -> 39
("association scheme" AND "binary codes" AND kernel)                    -> 1
("Hecke algebra" AND "linear codes" AND "permutation group")            -> 0
("orbital" AND "adjacency matrices" AND "self-orthogonal codes")        -> 2
("primitive permutation representations" AND codes)                     -> 5
("codes from" AND "PSL(2,q)")                                           -> 2
("designs and codes" AND "PGL(2,q)")                                    -> 0
"PGL(2,13)"                                                             -> 1
"PSL(2,13)" AND (code OR design)                                        -> 1
("minimum weight codewords" AND "projective plane" AND lines)           -> 0
("reconstruct" AND "projective plane" AND "association scheme")         -> 1
("automorphism group" AND "association scheme" AND "PGL(2")             -> 0
("automorphism group" AND "LDPC" AND conic)                             -> 0
("automorphism group" AND code AND conic AND "projective plane")        -> 12
("two-section" AND hypergraph AND invariant)                            -> 0
("pair" AND "concurrence" AND design AND reconstruct)                   -> 3
("symmetric difference" AND "three neighbours" AND graph AND code)      -> 0
("neighbour sum" AND "cubic graph" AND "binary code")                   -> 0
("3-uniform hypergraph" AND "colour" AND "binary code")                 -> 0
("hypergraph" AND "colouring" AND "lifted code" AND "minimum distance") -> 0
("complementary design" AND "binary code" AND rank)                     -> 0
("all-ones matrix" AND kernel AND "GF(2)")                              -> 0
("2-rank" AND complement AND design)                                    -> 1
```

Semantic Scholar (bulk endpoint, `query=`):

```
"passant lines" + "internal points"                                     -> 3
```

zbMATH Open (`search_string=`):

```
LDPC codes generated by conics in the classical projective plane        -> 1
LDPC codes semisymmetric graphs                                         -> 1
biprimitive cubic graphs Iofinova Ivanov                                -> 2
Conics arising from internal points and their binary codes              -> 2
Conics arising from external points and their binary codes              -> 1
codes of a design and its complement                                    -> 12
codes of designs Assmus Key                                             -> 20
designs and their codes                                                 -> 1207
p-rank complementary design                                             -> 1
2-rank of the complementary design                                      -> 1
code of the complementary design all-one vector                         -> 1
codes from primitive permutation representations of groups Key Moori    -> 5
PGL(2,13) codes designs                                                 -> 1
designs codes PSL(2,13)                                                 -> 1
minimum weight codewords of the code of a projective plane are lines    -> 3
reconstruction of the projective plane from its code                    -> 1
symmetric difference of neighbours cubic bipartite graph binary code    -> 1
complementary design binary code all-one vector dimension               -> 404 / empty
null space complement incidence matrix all-ones matrix binary           -> 404 / empty
rank of A+J over GF(2) incidence matrix complement                      -> 404 / empty
binary code complement of a graph incidence matrix kernel               -> 404 / empty
codes from the primitive permutation representations of PGL(2,q)        -> 404 / empty
automorphism group of the elliptic association scheme conic             -> 404 / empty
conic LDPC code minimum distance q=13                                   -> 404 / empty
lift of a binary code by colourings of hyperedges                       -> 404 / empty
three-uniform hypergraph incidence kernel colour transversal            -> 404 / empty
2-(28,12,11) design Steiner complexes bitangents                        -> 404 / empty
binary code from the 28 bitangents symplectic                           -> 404 / empty
two-weight code 27 points elliptic quadric PG(5,2)                      -> 404 / empty
```

`codetables.de` bounds queries over GF(2), all returning a bound line:

```
[91,14]   lower 36  upper 39
[91,15]   lower 36  upper 38
[78,36]   lower 16  upper 20
[182,37]  lower 55  upper 70
[182,36]  lower 56  upper 70
[81,8]    lower 38  upper 38
[1092,37] no entry
```

### Three-service citation counts, recorded separately

| Seed | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---:|---:|
| Droms, Mellinger & Meyer 2006 | 19 | 13 | 24 |
| Madison & Wu 2012 | 9 | 4 | 10 |

**The disagreements are themselves findings.** In both cases Crossref is lowest by a wide margin and
Semantic Scholar highest; Semantic Scholar's extra records over OpenAlex are largely DOI-less items
(book chapters, lecture notes, duplicate preprint records) that the other services do not index. No
verdict here rests on Crossref's count. Screening was done over the largest set in each case, as
required.

### Screened sets

1. **Semantic Scholar citing set of Droms, Mellinger and Meyer** — 24 records, provenance
   `/graph/v1/paper/DOI:10.1007/s10623-006-0022-6/citations`, screened over title and year.
   Discriminator: *does this work compute or bound the minimum weight, or classify minimum-weight
   codewords, of the passant-line/internal-point conic code?* Zero passed. Members promoted for
   individual discussion — Madison and Wu, and Ma, Liu and Tian — carry their own read-depth fields
   above; the remainder are covered by this set record.
2. **Semantic Scholar citing set of Madison and Wu** — 10 records, same provenance shape, screened
   over title. Same discriminator. Zero passed.
3. **Table 1 of Crnković, Rukavina and Šimac (2022)** — 24 rows, screened over the vertex-count
   column. Discriminator applied verbatim: *is the graph order 182?* Zero passed.
4. **Conder and Potočnik semisymmetric census, order block** — the census has exactly one entry at
   order 182, screened over the census's own recorded invariants (order, Goldschmidt type, diameter,
   girth). No discrimination was needed; uniqueness at that order is the finding.
5. **OpenAlex `"orbit matrices" AND codes`** — 39 records, screened over title only, first page of
   eight returned. Discriminator: *does this construct codes from orbital or orbit matrices of a
   permutation group action?* The screened page passed uniformly, which is the basis for calling the
   framework established; no member is named individually beyond the one routed at the end.
6. **OpenAlex `("automorphism group" AND code AND conic AND "projective plane")`** — 12 records,
   screened over title and host. Discriminator: *does this determine the automorphism group of a
   binary code arising from a conic in a projective plane?* Zero passed; the visible set is six
   Zenodo depositions of a single unrelated quantum-code preprint.
7. **OpenAlex `"semisymmetric graphs" AND codes`** — 3 records, screened over title.
   Discriminator: *does this construct error-correcting codes from semisymmetric graphs?* One
   passed and was promoted to full text; two are the *Census of cubic edge-transitive graphs and
   their optimal LCF codes* depositions, dismissed because "LCF" there is a cubic-graph notation.

### Sources named in this report, with read depth

| Source | Read depth |
|---|---|
| Madison & Wu, *On binary codes from conics in PG(2,q)*, arXiv:1104.0324v1 | `full text` (**preprint only**; published EJC 33 (2012) 33–48 not read) |
| Ma, Liu & Tian, *The binary codes generated from quadrics in projective spaces*, AIMS Math. 9 (2024) 29333–29345 | `full text` (published version) |
| Hollmann & Xiang, *Association schemes from the action of PGL(2,q) fixing a nonsingular conic in PG(2,q)*, arXiv:math/0503573v1 | `full text` (**preprint only**; published JACO 24 (2006) 157–193 not read) |
| Crnković, Rukavina & Šimac, *LDPC codes from cubic semisymmetric graphs*, Ars Math. Contemp. 22 (2022) #P2.03 | `full text` (published open-access version) |
| Conder & Potočnik, semisymmetric cubic graph census to 10,000 vertices (2012 listing) | `full text` (header and order-182 block) |
| `codetables.de` bounds rows for the seven queried length/dimension pairs over GF(2) | `full text` (of the queried rows) |
| Droms, Mellinger & Meyer, *LDPC codes generated by conics in the classical projective plane*, Des. Codes Cryptogr. 40, No. 3, 343–356 (2006) | `abstract/metadata only` (zbMATH record 5075353, Semantic Scholar and Unpaywall records; **body not obtained**) |
| Ivanov & Iofinova, *Biprimitive cubic graphs* (1985) | `abstract/metadata only` (zbMATH record 4158649; not obtained) |
| Wolfram MathWorld, *Iofinova-Ivanov Graphs* | `secondary only` — the page stands in for the 1985 primary; the page itself was read in full by WebFetch, but every claim about the classification is only as strong as that encyclopaedia entry, which cites no page or theorem number |
| Wu, *Conics arising from internal points and their binary codes*, Linear Algebra Appl. 439, No. 2, 422–434 (2013) | `abstract/metadata only` (zbMATH record 6259548; summary text unavailable under licence) |
| Madison & Wu, *Conics arising from external points and their binary codes*, Des. Codes Cryptogr. 78, No. 2, 473–491 (2016) | `abstract/metadata only` (zbMATH record 6542908; same) |
| Assmus & Key, *Designs and their codes* (1992) | `abstract/metadata only` (zbMATH record 53917; **not obtained** — named at P-1 as the place a predecessor would sit) |
| Hollmann, *Association schemes*, Masters Thesis, Eindhoven University of Technology, 1982 | `secondary only` (via Hollmann & Xiang's reference list, itself `full text`) |
| Lam, Thiel & Tonchev, *On quasi-symmetric 2-(28,12,11) and 2-(36,16,12) designs*, Des. Codes Cryptogr. 5, No. 1, 43–55 (1995) | `abstract/metadata only` (OpenAlex work record) |
| *Quasi-symmetric 2-(28,12,11) designs with an automorphism of order 5*, Glas. Mat. (2023), DOI 10.3336/gm.58.2.01 | `abstract/metadata only` (OpenAlex work record) |
| Gulliver & Harada, *Codes of lengths 120 and 136 meeting the Grey-Rankin bound and quasi-symmetric designs*, IEEE Trans. Inform. Theory 45, No. 2, 703–706 (1999) | `abstract/metadata only` (OpenAlex work record including abstract) |
| Key, Moori & Rodrigues, *On some designs and codes from primitive representations of some finite simple groups* (2003) | `abstract/metadata only` (zbMATH record 2065934) |
| *On biprimitive semisymmetric graphs*, arXiv:2412.03057 | `partial` — fetched and searched for the Iofinova–Ivanov statement; only the introduction's two citing sentences and the reference list were read |
| *Association schemes on the set of antiflags of a projective plane* (1994) | `abstract/metadata only` (OpenAlex record; named only to be dismissed at M-5) |
| Brouwer & Van Maldeghem, *Strongly regular graphs* (2022) | `abstract/metadata only` (zbMATH record 7437385; named only to be dismissed at P-4) |
| Tonchev, *Linear perfect codes and a characterization of the classical designs* (1999) | `abstract/metadata only` (zbMATH record 1392723; named only to be dismissed at P-1) |
| Two 2026 Zenodo *Census of cubic edge-transitive graphs and their optimal LCF codes* depositions | `abstract/metadata only` (OpenAlex work records; named only to be dismissed at G-2) |
| Tanner, *A recursive approach to low complexity codes* (1981) | `abstract/metadata only` (carried from C869, zbMATH record 3745089) |
| Calderbank & Kantor, *The Geometry of Two-Weight Codes*, Bull. London Math. Soc. (1986) | `full text` **in C866/C869, not re-read here**; cache key `10.1112/blms/18.2.97`, SHA-256 `986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`. Named here only to carry the E_6 verdict forward, and not counted in this report's full-text total |

### Cache additions made by this task

- `10.26493/1855-3974.2501.4c4` — SHA-256 `833477b8b879201e21132f50845c41187a65e22ed0b3f4441beaea4ee1862ce9`.
- `arXiv:2412.03057` — SHA-256 `18e30877bdd4fc5360b333324b8ddcf0f1d1103fffb80e7c2101e9f4ec91a00d`.
- `arXiv:math/0503573` was already cached with byte-identical content (SHA-256
  `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`); the cache refused a duplicate
  add, which is the intended behaviour.

## Coverage statement

### Searched and found nothing (licenses a negative)

- No work determining the exact minimum distance, or classifying the minimum-weight codewords, of
  the passant-line/internal-point conic code, in the enumerated citing sets of both its founding
  paper and its dimension paper. Reinforced by a positive statement in the 2024 survey that the
  exact values remain open.
- No work reconstructing PG(2,q), its conic or its polarity from code or scheme data of this kind,
  and no work determining the automorphism group of this code.
- No work reporting the one-frame kernels `[91,14,28]` or `[91,14,26]`, including in the one
  publication that systematically tabulates both biadjacency codes of cubic semisymmetric graphs.
- No work stating the parity-complement lift, the cross-orbital exhaustion, the higher-shell codes,
  the support-XOR identities, or the A_2-transversal colour-lift theorem.

### Could not access (licenses nothing; carried forward as open gaps)

- **Droms, Mellinger and Meyer (2006) — body not obtained.** Springer closed access; Unpaywall
  reports `oa_status: closed` with no repository copy; Semantic Scholar reports the abstract elided
  by the publisher. **This is the report's principal blocking gap**: it is the one paper whose
  minimum-distance section could plausibly contain a Magma-computed value of d at q = 13. Two
  independent full texts corroborate what the manuscript attributes to it, and the 2024 survey
  reports the exact values as open, which together make a hidden computed value unlikely — but
  unlikely is not searched.
- **MathSciNet — PARTIALLY COVERED, and the partial coverage is worth recording.** The SPA and its
  search endpoint are behind Cloudflare and institutional authentication (a plain fetch returns the
  JavaScript shell plus a Cloudflare challenge; `api/publications/search` returns 302 to an auth
  endpoint). One endpoint *is* reachable without authentication:
  `mathscinet.ams.org/mathscinet/api/publications/format?formats=bib&ids=<MR>` returns BibTeX for a
  given MR number, which I verified by retrieving a record. That gives bibliographic verification by
  known MR number but no search and no review text. Since MathSciNet reviews are the one service
  that reliably surfaces statements from older and non-English work — which is exactly the situation
  for the Iofinova–Ivanov primary — every negative above retains "to our knowledge".
- **Google Scholar — NOT COVERED.** Blocks automated access.
- **Ivanov and Iofinova (1985), *Biprimitive cubic graphs*.** Located as a zbMATH record only. The
  classification statement is taken at `secondary only` depth from MathWorld. The graph
  identification does not depend on it — the Conder–Potočnik census independently gives uniqueness
  at order 182 at full text — but the graph's *properties* as recorded in 1985, which is where a
  predecessor for the support-XOR identities would sit, were not searched.
- **The published versions of Madison–Wu (EJC 2012) and Hollmann–Xiang (JACO 2006).** Both read at
  preprint depth only. Every statement about them here is characterised from the preprint.
- **Wu (2013) and Madison–Wu (2016) bodies.** Neither has an arXiv preprint; zbMATH withholds
  summary text under licence; both are closed access. Their objects are the orbit-conic block codes,
  established as different from ours in C179, so the gap is narrow but real for the
  automorphism-group negative at M-7.
- **Assmus and Key, *Designs and their codes* (1992).** Not obtained. The natural home for a
  parity-complement statement, and the reason P-1's negative is the weakest in this report.
- **Chakravarti, IMA Volumes chapter (DOI 10.1007/978-1-4613-8994-1_4).** Carried forward from C866
  and C869; still paywalled, not re-attempted in this session. Gap not closed.

## Which C869 verdicts were revisited, and what changed

All five priority items were re-derived from scratch with unrestricted queries, and the paper's own
claims and the sweep items were audited afresh. Three verdicts changed.

**Changed:**

1. **OC-2 / PO-1, the one-frame kernels: PRE-EMPTED in part → NO PREDECESSOR LOCATED (G-2).** The
   pre-emption C869 recorded was already undermined by C871's retraction; reading the authors'
   semisymmetric-graph paper at full text closes it, since order 182 is absent from the only
   published table that covers graphs of our type.
2. **OC-1, the correspondence graph: PRE-EMPTED (census entry) → PRE-EMPTED (Iofinova–Ivanov
   1985, one of exactly five biprimitive cubic semisymmetric graphs, over PGL(2,13)) (G-1).** Same
   verdict, materially sharper and forty years older predecessor, and it identifies the two sides
   rather than only the graph.
3. **New: the manuscript's F_8 structure and spanning statement are KNOWN IN SUBSTANCE from Madison
   and Wu's module decomposition (M-3, M-4).** C869 did not audit the released paper's own claims at
   all; this is the audit's most consequential result and requires a change to the paper's priority
   paragraph.

**Unchanged after re-derivation:** the parity-complement lift, the cross-orbital exhaustion, the
higher shell, the support-XOR identities and the colour-lift theorem all remain NO PREDECESSOR
LOCATED. The exact-parameter and exact-group queries that C869 could not run were run here and
returned nothing, so these negatives are now materially stronger than C869's — with the single
exception of the parity-complement lemma, which carries no parameters and so gained nothing from
lifting the constraint.

**Newly added rather than changed:** the quasi-symmetric 2-(28,12,11) identification of the E_7
minimum shell (S-6), the Grey–Rankin characterisation of `[120,9,56]` (S-7), and the prior credit
inside the Hollmann–Xiang line (M-12).

## Incidental observations (candidate discovery-track entries)

Recorded here only; not written to the discovery track by this task.

1. **A published module decomposition was sitting one inference away from two of the paper's own
   theorems.** Provenance: Madison and Wu, arXiv:1104.0324v1, Theorem 6.1(i), against the manuscript
   `papers/q13-passant-code/passant_code_q13.tex`. The habit worth institutionalising is to read the
   cited source's *main theorem* rather than only the corollary being cited — the paper cites
   Corollary 6.3 for the nullity and never uses Theorem 6.1.
2. **A parameter query against a code table closes a "records" question in one call.** Provenance:
   the `codetables.de` rows in this report. Several bundle passages reason at length about whether a
   construction is competitive; the table answers it directly.
3. **The disclosure constraint cost the audit two of its three changed verdicts.** Both G-1 and G-2
   turned on being able to name an order, a group, and a set of code parameters. Recorded because
   the lesson is about audit tooling, not about this material.
