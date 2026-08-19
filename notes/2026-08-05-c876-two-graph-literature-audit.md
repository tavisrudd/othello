# C876 — two-graph literature audit of Clebsch III and the golden-operator programme

**Date:** 2026-08-05
**Task:** C876
**Lane:** `clebsch`
**Status:** complete

Prompted by a gap found in C871: `papers/clebsch-passages/literature-boundaries.md` and the
manuscript's reference section cite neither Brouwer, nor Van Maldeghem, nor Taylor, although
D. E. Taylor originated regular two-graphs and Brouwer–Van Maldeghem is the standard reference for
this territory.

Targets:

1. **Primary.** Clebsch III's aligned-design faithfulness theorem and its stated benchmark, that
   "the closest general literature benchmark gave eventual reconstruction from local size five for
   arbitrary 3-uniform hypergraphs; no located result covered this constrained two-graph
   observable."
2. **Secondary.** The unpublished golden-operator items: Sylvester-graph cut frame, the Paley
   censuses and their 3-designs, the order-ten equiangular tight frame and Naimark reading, and the
   order-six cut-independence uniqueness.
3. **Light check.** Whether Clebsch I's use of the four-point identity is attributed correctly.

Governing conventions: `notes/literature-audit-conventions.md`, binding in full. zbMATH Open
replaces Crossref for keyword negatives with the HTTP-404-means-empty calibration; Crossref is used
only for forward-citation counts.

## Opening summary

**One literature source in this report was read at full text**: the Pouzet–Si Kaddour–Trotignon
preprint, which is also the source that decides the round. Brouwer and Van Maldeghem's book was read
at `partial`; everything else is `review only`, `secondary only`, or `abstract/metadata only`. Three
internal project documents were read at full text and are listed separately in the Search record,
since they are not literature. The per-source table is authoritative and has exactly one `full text`
row among the literature.

**The four-local reconstruction claim survives, but its stated benchmark does not, and the paper
must change.**

The theorem itself is not pre-empted: no two-graph or Seidel-matrix reconstruction-from-local-data
theorem was located beyond the descendant correspondence, in Taylor, Seidel, or Brouwer and Van
Maldeghem. That negative is real but bounded — the two Seidel two-graph surveys, which are exactly
where such a theorem would sit, could not be obtained, and I have kept them as could-not-access
rather than letting them license the negative.

Two things are wrong in the paper, and the second is serious.

First, the mechanism is textbook and uncited. The paper's hypothesis on its triple function — that
the four triangle values on every 4-set sum to zero — **is the definition of a two-graph**, and what
the proof calls "the two-graph equation" is the standard descendant correspondence establishing the
bijection between two-graphs and switching classes of graphs. Both are in Brouwer and Van
Maldeghem §1.1.12, which the paper does not cite, along with the attributions to Higman, Taylor and
Seidel.

Second, and this is the exposed part: the paper says the closest general literature benchmark gives
reconstruction from local size **five**, for arbitrary 3-uniform hypergraphs. The closest benchmark
is in fact **four, valid from seven points**, for ordinary graphs — Dammak, Lopez, Pouzet and Si
Kaddour prove reconstruction up to complementation for `4 ≤ k ≤ v−3`, which at `k=4` is exactly
`v ≥ 7`. The paper's own literature ledger records this correctly, so the benchmark sentence
contradicts the paper's own ledger. The wording must be replaced: name the graph result as the
closest benchmark with its four and its seven, note that the five-threshold concerns the strictly
larger class of arbitrary 3-uniform hypergraphs, and locate the contribution in the two-graph
observable being coarser than a graph's.

That leaves a mathematical question the lane should settle before revising, because it is cheaper
than another literature round: two-graph 4-hypomorphy up to complementation is a *weaker* hypothesis
than graph 4-hypomorphy, with a correspondingly weaker conclusion, so neither theorem formally
implies the other — yet both have the same two numbers. Either there is an unwritten reduction, in
which case the theorem is a corollary of cited work and must say so, or the agreement is a
coincidence worth remarking on.

**Secondary verdicts.** The `2-(10,5,16)` design's parameter family is not just known but
exhaustively enumerated — 27,121,734 resolvable designs — so no novelty attaches to the parameters;
and the same source yields a free upgrade, since every resolvable design with those parameters is
automatically a `3-(10,5,6)` design. "Biangular tight frame" is a named published concept and should
be cited as one. The three Paley 3-designs, the Sylvester quadratic identities, the cross-ratio
signature, and the order-six uniqueness have no located predecessor, now at full exact-parameter
search strength. The order-ten equiangular-tight-frame material was already recorded as pre-empted
by the programme's own priority note, and I confirm the territory is occupied without re-verifying
those attributions. Clebsch I's two-graph usage is correct but under-attributed in the same way as
Clebsch III's.

**Gap closure.** MathSciNet's review layer is genuinely unreachable — tested this time, not assumed
— but MR Lookup is freely available and supplies bibliographic records, which partly reverses four
rounds of recording it as flatly not covered. C866's item 6iii is upgraded from could-not-determine
to no-predecessor-located. Chakravarti, Hyun and Hu, and Brouwer and Shult's full text all remain
open after real attempts, and all three are now access problems rather than search problems.

## Verdict table

See the Completeness statement for the full claim-by-claim table, the claims in scope I did not
reach, and the access gaps. Headline rows:

| Claim | Verdict |
|---|---|
| Aligned-design faithfulness theorem | **NOT PRE-EMPTED**; mechanism uncited; benchmark misstated; reduction question open |
| The "benchmark is five" sentence | **INCORRECT** — closest benchmark is four at seven, for graphs |
| Clebsch I two-graph usage | **CORRECT BUT UNDER-ATTRIBUTED** |
| `2-(10,5,16)` design | **PARAMETERS PRE-EMPTED AND ENUMERATED**; free 3-design upgrade available |
| Biangular tight frame | **NAMED PUBLISHED CONCEPT — cite** |
| Three Paley 3-designs | **NO PREDECESSOR LOCATED** (exact-parameter strength) |
| Sylvester identities, cross-ratio signature, order-six uniqueness | **NO PREDECESSOR LOCATED** |
| `ETF(5,10)` / Naimark reading | **ALREADY RECORDED AS PRE-EMPTED** by the programme |
| C866 item 6iii | **NO PREDECESSOR LOCATED** (upgraded from COULD NOT DETERMINE) |

## Per-item findings

### A. PRIMARY — Clebsch III, aligned-design faithfulness

The theorem, as printed in `sections/05-golden-operator.tex`
(`thm:aligned-faithfulness`): for `τ` on triples of `V` with
`Σ_{S∈C(Q,3)} τ(S) = 0` for every 4-set `Q`, and `A(τ)` the four-sets on which all four values of
`τ` are equal, **if `|V| ≥ 7` then `A(τ)` determines `τ` up to complement**; with the conference
corollary and the `3n²−23n+45` query count.

**Verdict: NOT PRE-EMPTED as a statement about two-graphs — no two-graph reconstruction theorem was
located in Taylor, Seidel, or Brouwer–Van Maldeghem. But two things must change in the paper, and
the second is the serious one.**

#### A.1 The mechanism is textbook and is uncited — attribution defect

Brouwer & Van Maldeghem, *Strongly Regular Graphs*, §1.1.12, read at `partial` (author-hosted
preprint, SHA-256 `fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`, carried from
C871; sections read: §1.1.11 Seidel matrices and switching, §1.1.12 regular two-graphs, §8.10
regular two-graphs, §8.14 equiangular lines). Quoting:

> "A two-graph `Ω = (V, ∆)` is a finite set `V` provided with a collection `∆` of unordered triples
> from `V`, such that **every 4-subset of `V` contains an even number of triples from `∆`**."

> "Conversely, from any two-graph `Ω = (V, ∆)`, and any fixed `w ∈ V`, we can construct a graph
> `Γ = Ω_w` with vertex set `V` as follows: let `w` be an isolated vertex in `Γ`, and let any two
> other vertices `x, y` be adjacent in `Γ` if `{w, x, y} ∈ ∆`. Then `Ω` is the two-graph associated
> to `Γ`. […] Thus we have established a **one-to-one correspondence between two-graphs and
> switching classes of graphs**. […] The **descendant** of `Ω` at `w` is the graph `Ω*_w`, obtained
> from `Ω_w` by deleting the isolated vertex `w`."

The book adds: "Regular two-graphs were introduced by G. Higman. See also Taylor [677]", and its
§1.1.11 history note "The Seidel matrix was introduced in Seidel [641]."

Two observations, both mine and marked as such:

- The paper's defining hypothesis on `τ` — that the four triangle values on every 4-set sum to zero
  — **is the definition of a two-graph**, verbatim, not a derived condition.
- The paper's proof opens by fixing `r`, forming `G_r` on `V∖{r}` with `ij` an edge when
  `τ(rij)=1`, and invoking "the two-graph equation" `τ(ijk) = τ(rij)+τ(rik)+τ(rjk)`. **That is the
  descendant correspondence**, exactly as displayed above. The paper is using the standard
  two-graph/switching-class machinery under a private name and without citation.

This is an attribution defect independent of novelty. Fix: cite Brouwer–Van Maldeghem §1.1.12 (or
Seidel's survey and Taylor) for the two-graph definition, the descendant, and the correspondence
with switching classes, and call the identity the descendant relation rather than only "the
two-graph equation".

#### A.2 The stated benchmark is wrong, and this is the exposed part

The paper says the closest general literature benchmark "gave eventual reconstruction from local
size **five** for arbitrary 3-uniform hypergraphs". The actual closest benchmark is four, at seven —
the same two numbers as the theorem.

Source: Maurice Pouzet, Hamza Si Kaddour and Nicolas Trotignon, "Claw-freeness, 3-homogeneous
subsets of a graph and a reconstruction problem", *Contributions to Discrete Mathematics* 6, no. 1
(2011), 86–97, DOI `10.55016/ojs/cdm.v6i1.62075`, preprint arXiv:1309.1835. Read depth: **`full
text`** of the arXiv v2 preprint (dated 22 September 2013), fetched from
`https://arxiv.org/pdf/1309.1835`, SHA-256
`a0d71732a15b440d4658dd08eddce29cc544ccde32a5b753911ef9635cf8a39b`, extracted with poppler; I read
the whole 4-page note including §1 (results and motivation), Theorems 1.1 and 1.2, Problems 1.3–1.5,
and Proposition 1.6. Version caveat: preprint, not the published *Contributions to Discrete
Mathematics* version.

They record the state of the art directly (quoting):

> "With J. Dammak, G. Lopez [5] and [6] we proved that the conclusion is positive if:
> (i) `4 ≤ k ≤ v−3` or (ii) `4 ≤ k = v−2` and `v ≡ 2 (mod 4)`."

where the conclusion in question is Problem 1.5: "For which pairs `(k, v)` of integers, `k < v`,
every graph `G` on `v` vertices is `k`-reconstructible up to complementation?" — with
`k`-hypomorphic up to complementation defined as: for every `k`-element subset `K`, the induced
graphs `G_K` and `G'_K` are isomorphic up to complementation.

MY arithmetic, marked as mine: **at `k = 4`, condition (i) reads `4 ≤ 4 ≤ v−3`, i.e. `v ≥ 7`.** So
Dammak–Lopez–Pouzet–Si Kaddour already give **four-local reconstruction up to complementation, valid
exactly from seven points**, for ordinary graphs. Four and seven, the paper's own two numbers.

They also state the sharpness that the paper's "seven sharp" mirrors: "It is immediate to see that
if the conclusion of the problem above is positive for some `k, v`, then `v` is distinct from 3 and
4 and, with a little bit of thought, that if `v ≥ 5` then `k ≥ 4`."

**The paper's own ledger already knows this.** `literature-boundaries.md` row `OPER-4` reads
"Dammak--Lopez--Pouzet--Si Kaddour own four-local reconstruction up to complement for ordinary
graphs; Pouzet--Si Kaddour prove that arbitrary 3-uniform hypergraphs have eventual local threshold
five". So the ledger is accurate and the benchmark sentence quoted to me is **inconsistent with the
paper's own ledger**: it reports the hypergraph number, five, as "the closest general literature
benchmark", when the ledger correctly records that the closest benchmark is the graph result at
four.

**Required wording change.** The sentence should say that the closest benchmark is
Dammak–Lopez–Pouzet–Si Kaddour's four-local reconstruction up to complementation for ordinary
graphs, valid for `4 ≤ k ≤ v−3` and hence at `k=4` from `v ≥ 7`; that the five-threshold result
concerns arbitrary 3-uniform hypergraphs, a strictly larger class; and that the contribution here is
the *two-graph* observable, where the induced structure on a 4-set is coarser than a graph's.

#### A.3 What genuinely remains, and the mathematical exposure the lane must settle

MY analysis, marked as mine and kept separate from every source's framing.

The paper's observable is coarse. On a 4-set `Q`, a two-graph has 0, 2, or 4 coherent triples;
complementation swaps 0 and 4 and fixes 2; so `A(τ) = A(τ')` says exactly that for every 4-set the
induced two-graphs agree **up to complement**. The paper states this itself: "Equality of aligned
families is precisely four-hypomorphy up to complementation within the two-graph subclass."

But two-graphs on four points correspond to *switching classes* of graphs on four points, not to
graphs: there are 8 of each, against 64 labelled graphs. So two-graph 4-hypomorphy up to
complementation is a **weaker hypothesis** than graph 4-hypomorphy up to complementation, and the
conclusion (`τ' = τ` up to complement) is correspondingly weaker than `G' ≅ G` up to complement.
The Dammak–Lopez–Pouzet–Si Kaddour theorem therefore does **not** immediately imply the paper's
theorem, and the paper's theorem does not immediately imply theirs.

**This is the exposure and it is mathematical, not bibliographic: is the two-graph statement a
corollary of the graph statement, or genuinely independent of it?** The numbers coinciding exactly —
four and seven, in both — is the kind of coincidence that usually has a reason. If there is a
one-line reduction, the theorem is a corollary of cited work and must be presented as such. I could
not settle this from the literature and it should be settled before the next revision. It is
cheaper than another literature round.

Corroborating how close the two settings are: the paper's own reduction is that `{r,i,j,k}` is
aligned exactly when `ijk` is a clique or independent triple of `G_r`. Pouzet–Si Kaddour–Trotignon's
central object is precisely that: "Let `H^(3)(G)` be the hypergraph having the same vertices as `G`
and whose hyperedges are the 3-element homogeneous subsets of `G`", homogeneous meaning "a clique or
an independent set". Their Theorem 1.2 characterises exactly when two graphs share it, via the
structure of the Boolean sum `G +̇ G'`, and shows the sum need **not** be trivial — it can be any
induced subgraph of the Paley graph on 9 vertices, or a disjoint union of even cycles and paths, or
a complement of such. So in the *graph* setting the monochromatic-triple hypergraph alone does not
determine the graph up to complement; extra hypotheses are needed, which is exactly why
Dammak–Lopez–Pouzet–Si Kaddour need full 4-hypomorphy rather than just `H^(3)`. The paper's `A(τ)`
carries the 4-sets inside `V∖{r}` as well, which is the additional data playing the analogous role.

#### A.4 Was a two-graph reconstruction theorem located anywhere?

**No.** Searched at full strength (this target was never hygiene-constrained, Clebsch III being
released). Verbatim queries and counts are in the Search record. `("two-graph" AND reconstruction)`
on OpenAlex returns 88 records whose relevant entries are all about graph reconstruction in the
Ulam sense or about unrelated "two graphs"; `("switching class" AND reconstruction)` returns 1,
an engineering paper; zbMATH returns empty for a two-graph reconstruction phrasing. Brouwer–Van
Maldeghem §1.1.12 and §8.10 contain the descendant correspondence and the regularity theory but no
reconstruction-from-local-data theorem beyond it. Seidel's 1976 survey and Seidel–Taylor's 1981
second survey were located as records but could not be obtained; see the completeness statement,
where they are carried as **could not access**, not as a negative.

### B. Clebsch I — the regular two-graph identification and the four-point identity

**Verdict: correct as usage, but under-attributed in the same way as A.1.** Upgraded from the
"light check" I was originally asked for, per the completeness instruction.

Clebsch I identifies its 10+10 split of coordinate triples as a regular two-graph and uses the
four-point identity to reconstruct the operator. The objects are classical: regular two-graphs are
due to G. Higman with Taylor as the standard reference, per Brouwer–Van Maldeghem §1.1.12's own
history note; the four-point identity is the two-graph axiom; the reconstruction of the operator
from a rooted descendant is the switching-class correspondence. Nothing here is claimed as new and
nothing needs retracting. What is needed is the same citation repair: name Higman/Taylor for regular
two-graphs, Seidel for the Seidel matrix and switching, and Brouwer–Van Maldeghem §1.1.12 for the
correspondence.

MY inference, marked as mine: because Clebsch III's proof and Clebsch I's construction both run on
the descendant correspondence, a single added paragraph fixing the vocabulary would serve both, and
would also make Clebsch III's theorem statement legible to the two-graph community — which is the
community most likely to referee it and currently the one least addressed by its reference list.

### C. Golden-operator programme — items touching this territory

The programme's own record at `notes/2026-07-31-results-summary-snapshot.md` § "Priority: five
clean pre-emptions in this programme" already documents five pre-emptions, two near-verbatim, and I
did not re-audit those; they are listed in the completeness statement as **already recorded, not
re-verified**. What follows are the items in my scope that record does not cover, each searched at
full parameter strength after the hygiene lift.

#### C.1 The `2-(10,5,16)` design of the 36 extremal order-ten cut halves

**Verdict: PARAMETER FAMILY PRE-EMPTED AND FULLY ENUMERATED; the specific identification is
paper-owned.** And there is a free upgrade attached.

Luis B. Morales and Carlos Velarde, "Enumeration of resolvable 2-(10,5,16) and 3-(10,5,6) designs",
*Journal of Combinatorial Designs* 13, no. 2 (2005), 108–119, DOI `10.1002/jcd.20032`, zbMATH
`https://zbmath.org/2159925`. Read depth: `review only` — the zbMATH summary, retrieved through the
API; the paper was not obtained. The summary states: "Since every resolvable 2-(10,5,16) design is
also a resolvable 3-(10,5,6) design and vice versa, the latter designs are also enumerated. There
are 27,121,734 such designs with automorphism groups whose order range from 1 to 1,440. From these,
2,006,690 designs are simple."

Two consequences, both mine:

- The parameter set is not merely known but **exhaustively enumerated**, so no novelty attaches to
  it and none should be implied. The contribution is identifying *which* design the conference
  structure produces, which is a statement about a specific member of a 27-million-member family.
- **Free upgrade, and worth taking:** the cited equivalence says every *resolvable* 2-(10,5,16) is
  automatically a 3-(10,5,6). The programme's design has 72 blocks arising as the two halves of 36
  cuts, which is a natural candidate for resolvability. **If it is resolvable, it is automatically a
  3-design**, which strengthens the claim at no cost and connects it to the programme's other
  3-design results. This should be checked computationally — it is a small check.

#### C.2 "Biangular tight frame in dimension nine"

**Verdict: NAMED PUBLISHED CONCEPT — cite it.** Not a novelty claim in the programme, but the term
is used as if generic when it names an established object with its own literature. zbMATH
`biangular tight frame` returns 4 records, including "Constructions of biangular tight frames and
their relationships with equiangular tight frames" (2018) and "Toward the classification of
biangular harmonic frames" (2019). Read depth for both: `abstract/metadata only` (zbMATH title
records; neither obtained). Screened over title from a 4-record set; discriminator: *does the title
indicate the general theory of biangular tight frames?* Two passed, both named here.

#### C.3 The three Paley 3-designs `3-(14,7,35)`, `3-(18,9,63)`, `3-(18,9,84)`

**Verdict: NO PREDECESSOR LOCATED, now at full search strength.** zbMATH returns empty (HTTP 404)
for each of the three exact parameter sets, and OpenAlex `("Paley" AND "3-design" AND "conference")`
returns 0. These are exactly the queries the hygiene constraint would have forbidden, and they are
the discriminating ones for design parameters. The negative is therefore much stronger than it
would have been an hour ago.

#### C.4 The Sylvester-graph cut frame, `K² = 10K + 75I`, and `K = −3A₁ + A₂ − A₃`

**Verdict: SETTING CLASSICAL, SPECIFIC IDENTITIES NOT LOCATED.** The Sylvester graph appears in
Brouwer–Van Maldeghem (as the subgraph induced on the 36 vertices nonadjacent to a fixed edge in a
larger graph, and in its own right), and its association-scheme structure is standard, so the
Bose–Mesner decomposition is an application of catalogued machinery rather than a new object. No
source stating the displayed quadratic identity or the recentred reflection `(K−5I)² = 100I` was
located. OpenAlex `("Sylvester graph" AND "two-graph")` returns 2 records, both the same 2025/2026
counterexample paper on the `S₁₀`/`S₁₂` conjectures (read depth `abstract/metadata only`, OpenAlex
records, named here only to be dismissed as unrelated).

#### C.5 The order-ten `ETF(5,10)` and the Naimark–Gram reading

**Verdict: ALREADY RECORDED AS PRE-EMPTED by the programme's own priority note**, which credits
Fickus–Mixon for identifying symmetric conference matrices of order `N` with sign Gram matrices of
real equiangular tight frames in dimension `N/2`, and Bussemaker–Mathon–Seidel for the order-ten
conference two-graph's uniqueness, eigenvalues, automorphism group, and the switching class
containing the Petersen graph. I confirm the territory is occupied — Brouwer–Van Maldeghem §8.14
covers equiangular line sets and ETFs as standard material — and I did not re-verify the specific
attributions, which the programme has already made. Read depth for Fickus–Mixon and
Bussemaker–Mathon–Seidel: `secondary only`, via the programme's own priority note, which I read at
`full text`; neither paper obtained by me.

#### C.6 Order six as the unique nontrivial symmetric conference order with cut-independent balanced exchange spectrum

**Verdict: NO PREDECESSOR LOCATED.** This corresponds to `literature-boundaries.md` row `OPER-3`,
whose ledger entry already says "The balanced singular-spectral classification, its exchange
interpretation, and the inclusion/Ramsey cutoff were not located in the bounded audit." My searching
adds nothing against it. Conference matrices themselves are classical (Brouwer–Van Maldeghem §8.2).

## D. Gap closure from earlier rounds

Per the completeness instruction, every gap recorded in C866, C869, C871 and C873 was revisited.

### D.1 MathSciNet — the standing "NOT COVERED" is partly wrong, and I am correcting it

I have recorded MathSciNet as NOT COVERED in four consecutive rounds **by assumption**. Tested
properly this round, the position is more precise:

- `mathscinet-getitem` returns HTTP 200 but redirects to a relay station and serves a JavaScript
  application shell whose only text is "We're sorry but frontend doesn't work properly without
  JavaScript enabled." **Reviews remain genuinely unreachable**, and that is now a tested finding
  rather than an assumption.
- **MR Lookup (`https://mathscinet.ams.org/mrlookup`) is freely reachable and returns full
  bibliographic records without authentication.** Queried for Brouwer & Shult, it returned the
  BibTeX record `MR1044447`, "Graphs with odd cocliques", *European J. Combin.* 11 (1990), number 2
  — independently confirming the bibliographic detail I had been carrying from Brouwer–Van
  Maldeghem's reference list at `secondary only`.

**Correction to prior rounds:** MathSciNet's *bibliographic layer* is COVERED and always was; its
*review layer* is NOT COVERED. Claims those rounds gated on MathSciNet keep "to our knowledge",
because the review layer is what would have supplied restatements — but citations verified through
MR Lookup no longer need the `secondary only` qualifier on their bibliographic detail. This should
go into the conventions.

### D.2 C866 item 6iii — upgraded from COULD NOT DETERMINE

Whether the non-coordinate-transitivity of the published `[[28,14,5]]` code, witnessed by the
point-degree distribution `82⁷, 86⁷, 94⁷, 98⁷` of its 504 minimum logical supports, is recorded
anywhere. This was left COULD NOT DETERMINE in C866 **solely** because the discriminating query
would have disclosed the distribution. Run now:

| Query (verbatim) | Service | Count |
|---|---|---|
| `quantum code [[28,14,5]] automorphism coordinate transitive` | zbMATH | 404 / empty |
| `stabilizer code minimum weight logical operator support distribution invariant monomial equivalence` | zbMATH | 404 / empty |
| `title_and_abstract.search:("[[28,14,5]]" OR "28,14,5")` | OpenAlex | 0 |
| `title_and_abstract.search:("coordinate-transitive" AND "quantum code")` | OpenAlex | 0 |

**Verdict upgraded to NO PREDECESSOR LOCATED.** The observation appears to be unrecorded. Its value
is low because the ladder track is closed, as the coordinator noted, but the gap is now closed
rather than open.

### D.3 C869 — the parity-complement lemma, revisited unconstrained

C869 recorded that the parity-complement lemma (`ker(C+J) = ker C ⊕ ⟨1⟩` for odd `n` with all row
and column degrees odd) had its negative weakened by the constraint, since the discriminating query
was close to a statement of the lemma. Run now: zbMATH returns empty for two direct phrasings and
OpenAlex `("all-ones matrix" AND kernel AND "incidence matrix")` returns 0. **Verdict unchanged —
NO PREDECESSOR LOCATED — but the negative is now properly earned rather than hedged.** My
recommendation stands unchanged for a different reason: state it with proof and claim nothing,
because it is a three-line argument, not because the search was hobbled.

### D.4 C869 — the DOI-less 2019 item, identified

Now identified as "On some results about LDPC codes based on cubic symmetric graphs and µ-geodetic
graphs" (2019), sitting in a cluster of related work by the same group including "LDPC Codes from
µ-Geodetic Graphs Obtained from Block Designs", *Graphs and Combinatorics* (2019), DOI
`10.1007/s00373-019-02007-4`. Read depth for both: `abstract/metadata only` (OpenAlex work
records). Neither was obtained; the DOI-less item still has no locator and is plausibly a thesis
chapter or talk. **This no longer matters for C869**, whose relevant verdict was retracted in C871
on other grounds — the lane's graph is semisymmetric and absent from those tables either way.

### D.5 Still open after a real attempt

- **Chakravarti, IMA Volumes chapter, DOI `10.1007/978-1-4613-8994-1_4`.** Unpaywall reports
  `is_oa: False` with no open locations; Springer gates the body behind authentication. Attempted
  again this round. **Open since C866, still gating the design claim there.** With hygiene lifted
  this is not a search problem — it is an access problem, and only an institutional copy or an
  interlibrary request will close it.
- **Hyun & Hu (2026), recursive two-weight construction.** Seventh retrieval attempt this round
  (ScienceDirect article endpoint, HTTP 403). Still `review only`. Content still not inferred.
- **Brouwer & Shult (1990).** MR number now pinned as `MR1044447` and bibliographic detail
  independently confirmed, but the text remains unobtained and the MathSciNet review unreachable.
  The C873 position stands: cite Brouwer–Van Maldeghem Proposition 3.6.1, not Brouwer & Shult
  directly, for the identities.
- **Seidel (1976), "A survey of two-graphs"**, zbMATH `3547309`, in *Colloquio Internazionale sulle
  Teorie Combinatorie, Roma 1973*, Tomo I, 481–511; and **Seidel & Taylor (1981), "Two-graphs, a
  second survey"**, zbMATH `3745240`, in *Algebraic Methods in Graph Theory* Vol. II, Colloq. Math.
  Soc. János Bolyai 25, 689–711. Read depth for both: `abstract/metadata only` — zbMATH records
  giving title, authors, year and full source; **neither carries a zbMATH review**, and neither
  volume is online. These are the two sources most likely to contain a two-graph reconstruction
  statement if one exists, and **not obtaining them is the principal limitation on finding A.4's
  negative.** Carried as could not access.

## Search record

### Services, and why zbMATH replaces Crossref for keyword work

As in every prior round: Crossref's `query.bibliographic` is relevance ranking over an implicit OR
and cannot enumerate a conjunctive set, so **OpenAlex, Semantic Scholar and zbMATH Open** carry the
keyword negatives. Crossref is reserved for forward-citation counts. This round zbMATH again did
more than substitute: it supplied the `2-(10,5,16)` enumeration summary and the biangular-tight-frame
literature, and its empty responses on three exact 3-design parameter sets are the strongest
negatives in section C.

### Empty versus error, per service

- **OpenAlex**: empty is HTTP 200 with `meta.count = 0`; errors raise in the client.
- **Semantic Scholar**: empty is HTTP 200 with `"total": 0`; HTTP 429 retried with backoff, and a
  give-up prints `S2_ERROR`. One query hit sustained 429 this round and is recorded as such below.
- **zbMATH Open**: **empty is HTTP 404.** This round I rewrote the client to catch the `HTTPError`
  and print `[404] EMPTY` explicitly, after noticing that my earlier shell pipeline was silently
  swallowing tracebacks and printing nothing — which is indistinguishable from an empty result at a
  glance. That near-miss is logged as an incidental observation.
- **MathSciNet**: distinguished by content, not status code — HTTP 200 with a JavaScript shell means
  unreachable; MR Lookup returns parseable BibTeX.

### Verbatim load-bearing queries

```
OpenAlex  title_and_abstract.search:("two-graph" AND reconstruction)            -> 88
OpenAlex  title_and_abstract.search:("two-graphs" AND switching AND Seidel)     -> 10
OpenAlex  title_and_abstract.search:("monochromatic triples" AND graph)         -> 5
OpenAlex  title_and_abstract.search:("Seidel matrix" AND determined)            -> 9
OpenAlex  title_and_abstract.search:("switching class" AND reconstruction)      -> 1
OpenAlex  title_and_abstract.search:("two-graph" AND "determined by")           -> 331
OpenAlex  title_and_abstract.search:("3-homogeneous" AND reconstruction)        -> 6
OpenAlex  title_and_abstract.search:("Sylvester graph" AND "two-graph")         -> 2
OpenAlex  title_and_abstract.search:("conference matrix" AND "equiangular tight frame") -> 2
OpenAlex  title_and_abstract.search:("Paley" AND "3-design" AND "conference")   -> 0
OpenAlex  title_and_abstract.search:("[[28,14,5]]" OR "28,14,5")                -> 0
OpenAlex  title_and_abstract.search:("coordinate-transitive" AND "quantum code")-> 0
OpenAlex  title_and_abstract.search:("all-ones matrix" AND kernel AND "incidence matrix") -> 0
OpenAlex  title_and_abstract.search:("geodetic graphs" AND LDPC)                -> 6
zbMATH    Taylor regular two-graphs                                             -> 6
zbMATH    two-graphs Seidel survey switching class                              -> 1
zbMATH    reconstruction of two-graphs from subsets                             -> 11
zbMATH    graph determined by its triangles and independent triples up to complementation -> 404 / empty
zbMATH    2-(10,5,16) design                                                    -> 1
zbMATH    biangular tight frame                                                 -> 4
zbMATH    3-(14,7,35) design                                                    -> 404 / empty
zbMATH    3-(18,9,63) design                                                    -> 404 / empty
zbMATH    3-(18,9,84) design                                                    -> 404 / empty
zbMATH    Sylvester graph two-graph eigenvalue                                  -> 404 / empty
zbMATH    conference matrix equiangular tight frame Naimark                     -> 404 / empty
zbMATH    quantum code [[28,14,5]] automorphism coordinate transitive           -> 404 / empty
zbMATH    stabilizer code minimum weight logical operator support distribution invariant monomial equivalence -> 404 / empty
zbMATH    kernel of incidence matrix plus all-ones matrix odd degrees binary code -> 404 / empty
zbMATH    ker(C+J) all-ones complement kernel binary incidence odd regular       -> 404 / empty
S2 bulk   "mu-geodetic" + LDPC                                                  -> HTTP 429, then 0
```

### Screened sets

1. **OpenAlex `("two-graph" AND reconstruction)`, 88 records.** Screened over title. Discriminator:
   *does the title concern reconstruction of two-graphs (Seidel sense) rather than graph
   reconstruction in the Ulam sense or unrelated uses of "two graphs"?* **Zero passed.** The set
   divides into Ulam-style reconstruction, curve/geometry reconstruction, and machine-learning
   papers about pairs of graphs.
2. **OpenAlex `("two-graph" AND "determined by")`, 331 records.** Screened over title only, first
   page by relevance. Discriminator as above. Zero passed; the one on-topic title is "A SURVEY OF
   TWO-GRAPHS" (DOI `10.1016/b978-0-12-189420-7.50018-9`, 1991, the Selected Works reprint of
   Seidel's survey) — read depth `abstract/metadata only`, OpenAlex record; **not obtained**, and
   carried in the completeness statement as could not access rather than as a screened dismissal.
3. **OpenAlex `("monochromatic triples" AND graph)`, 5 records.** Screened over title.
   Discriminator: *does this concern determination of a graph by its monochromatic triples?* Zero
   passed; all are Ramsey-theoretic counting or edge-colouring papers. Named for the record and
   dismissed: "Large Monochromatic Triple Stars in Edge Colourings" (DOI `10.1002/jgt.21854`), "On
   the Number of Monochromatic Triples Associated with Binary Equations over Coloured Algebraic
   Groups" (DOI `10.13189/ms.2024.120502`), "Monk algebras and Ramsey theory" (DOI
   `10.1016/j.jlamp.2022.100759`) — all `abstract/metadata only`, OpenAlex records.
4. **zbMATH `Taylor regular two-graphs`, 6 records.** Screened over title. Discriminator: *is this a
   two-graph survey or a Taylor two-graph paper?* One passed, "Two-graphs, a second survey", and is
   carried as could not access. Dismissed, all `abstract/metadata only` (zbMATH records):
   "1-factorization of the composition of regular graphs", "On the metric dimension of imprimitive
   distance-regular graphs", "The CRC handbook of combinatorial designs", "On D. G. Higman's note on
   regular 3-graphs", "Weighted association schemes, fusions, and minimal coherent closures".
5. **zbMATH `biangular tight frame`, 4 records.** Screened over title; two promoted (C.2), two
   dismissed as a Gabor-frame paper and a conference volume, both `abstract/metadata only`.

### Sources named in this report, with read depth

| Source | Read depth |
|---|---|
| Pouzet, Si Kaddour & Trotignon, *Claw-freeness, 3-homogeneous subsets of a graph and a reconstruction problem*, Contrib. Discrete Math. 6 (2011) 86–97, arXiv:1309.1835 | **`full text`** (preprint v2; published version not read) |
| Brouwer & Van Maldeghem, *Strongly Regular Graphs* (author-hosted preprint) | `partial` |
| Morales & Velarde, *Enumeration of resolvable 2-(10,5,16) and 3-(10,5,6) designs*, J. Combin. Des. 13 (2005) 108–119 | `review only` (zbMATH summary) |
| Dammak, Lopez, Pouzet & Si Kaddour, four-local reconstruction up to complementation | `secondary only` (via Pouzet–Si Kaddour–Trotignon §1, read at full text) |
| Brouwer & Shult, *Graphs with odd cocliques*, Eur. J. Comb. 11 (1990), MR1044447 | `secondary only` (via the book) + bibliographic record via MR Lookup |
| Seidel, *A survey of two-graphs*, Rome 1973 (1976); and the 1991 Selected Works reprint | `abstract/metadata only` — **not obtained** |
| Seidel & Taylor, *Two-graphs, a second survey*, Bolyai 25 (1981) 689–711 | `abstract/metadata only` — **not obtained** |
| Taylor, regular two-graphs (book reference [677]) | `secondary only` (via the book's history note) |
| Higman, originator of regular two-graphs | `secondary only` (via the book's history note) |
| Fickus & Mixon; Bussemaker, Mathon & Seidel | `secondary only` (via the programme's own priority note) |
| *Constructions of biangular tight frames…* (2018); *Toward the classification of biangular harmonic frames* (2019) | `abstract/metadata only` |
| *LDPC Codes from µ-Geodetic Graphs Obtained from Block Designs*, DOI 10.1007/s00373-019-02007-4 | `abstract/metadata only` |
| *On some results about LDPC codes based on cubic symmetric graphs and µ-geodetic graphs* (2019, no DOI) | `abstract/metadata only` |
| *A counterexample to the S10- and the S12-Conjecture*, DOI 10.26493/1855-3974.3693.e38 / arXiv:2509.14184 | `abstract/metadata only` (named only to be dismissed) |
| Three monochromatic-triple Ramsey papers (set 3 above) | `abstract/metadata only` (named only to be dismissed) |
| Five zbMATH records dismissed from the Taylor query (set 4 above) | `abstract/metadata only` (named only to be dismissed) |
| Chakravarti, IMA Volumes chapter, DOI 10.1007/978-1-4613-8994-1_4 | `abstract/metadata only` — **not obtained**, open since C866 |
| Hyun & Hu, Finite Fields Appl. 110 (2026) | `review only` — open since C871 |

Internal project documents read at full text, listed separately because they are not literature:
`papers/clebsch-passages/literature-boundaries.md`, `papers/clebsch-passages/sections/05-golden-operator.tex`
(theorem statements and proof of `thm:aligned-faithfulness`), and
`notes/2026-07-31-results-summary-snapshot.md` §§ 3 and 5 including the programme's priority note.

## Query hygiene — bound for part of this round, lifted mid-round

Recorded as instructed, because a reader needs to know which findings were made with one hand tied.

**Timeline.** The round opened under the split the coordinator set: Clebsch III exempt because it is
released under a DOI, the golden-operator programme constrained. The constraint was then lifted
entirely, mid-round, and subsequently clarified as having been over-applied since C869 rather than a
policy that changed.

**Which verdicts were reached under the constraint.** Section A in its entirety — the primary
target — was reached **unconstrained**, because Clebsch III was exempt from the start. So the
round's headline finding owes nothing to the lift. Section B likewise. The searches behind sections
C.1–C.6 were **all run after the lift**, using exact design parameters, exact code parameters, and
named constructions; none of section C rests on constrained retrieval.

**Did lifting it change anything?** Yes, in three places, and all three are gains:

- **C.3, the three Paley 3-designs.** Under the constraint I could only have searched generic
  vocabulary such as "conference matrix designs". After the lift I queried `3-(14,7,35)`,
  `3-(18,9,63)` and `3-(18,9,84)` as exact parameter strings, which is by far the most
  discriminating instrument for designs. All three return empty. The negative is real now; it would
  have been hedged before.
- **C.1, the `2-(10,5,16)` design.** The exact parameter query found the Morales–Velarde enumeration
  immediately, along with the resolvable-implies-3-design equivalence that yields a free upgrade for
  the programme. Generic vocabulary would not have surfaced it.
- **D.2, C866 item 6iii.** Recorded as COULD NOT DETERMINE purely for hygiene. Now searched and
  upgraded to NO PREDECESSOR LOCATED.

**Earlier verdicts revisited on the over-application point.** Per the clarification, I walked the
coverage statements of C866, C869 and C871 for places the constraint bit on non-ladder material.
The non-ladder items were: C869's parity-complement lemma (revisited at D.3, verdict unchanged, now
properly earned) and C866 item 6iii (revisited at D.2, verdict upgraded). C869's and C871's other
hedges concerned the ladder codes themselves, which the coordinator has identified as both
legitimately constrained at the time and least worth revisiting; I did not redo them, and say so
here rather than leaving it implicit. **No earlier verdict was reversed by the lift.**

## Completeness statement

### Claims audited, with verdicts

| Claim | Verdict |
|---|---|
| Clebsch III, aligned-design faithfulness (`|V| ≥ 7`, aligned family determines `τ` up to complement) | **NOT PRE-EMPTED** as a two-graph statement; **mechanism uncited** (A.1); **stated benchmark wrong** (A.2); reduction-to-known-result question open (A.3) |
| Clebsch III, conference corollary and `3n²−23n+45` decoder | Corollary of the above; no separate predecessor sought or located |
| Clebsch III, "closest benchmark is five for arbitrary 3-uniform hypergraphs" | **INCORRECT AS STATED** — the closest is four at seven, for graphs, and the paper's own ledger says so |
| Clebsch I, regular two-graph identification and four-point identity | **CORRECT AS USAGE, UNDER-ATTRIBUTED** (B) |
| Golden operator, `2-(10,5,16)` design of the 36 cut halves | **PARAMETER FAMILY PRE-EMPTED AND ENUMERATED**; specific identification paper-owned; free 3-design upgrade available (C.1) |
| Golden operator, biangular tight frame in dimension nine | **NAMED PUBLISHED CONCEPT — cite it** (C.2) |
| Golden operator, `3-(14,7,35)`, `3-(18,9,63)`, `3-(18,9,84)` | **NO PREDECESSOR LOCATED**, at full parameter strength (C.3) |
| Golden operator, degree-four cross-ratio signature | **NO PREDECESSOR LOCATED**; searches returned only computer-vision uses of "cross-ratio invariant" |
| Golden operator, Sylvester cut frame, `K²=10K+75I`, `K=−3A₁+A₂−A₃` | **SETTING CLASSICAL, IDENTITIES NOT LOCATED** (C.4) |
| Golden operator, `ETF(5,10)` and Naimark–Gram reading | **ALREADY RECORDED AS PRE-EMPTED** by the programme's own note; territory confirmed occupied, attributions not re-verified (C.5) |
| Golden operator, order-six cut-independence uniqueness | **NO PREDECESSOR LOCATED**; consistent with ledger row `OPER-3` (C.6) |
| C866 item 6iii, `[[28,14,5]]` point-degree distribution | **NO PREDECESSOR LOCATED** — upgraded from COULD NOT DETERMINE (D.2) |
| C869 parity-complement lemma | **NO PREDECESSOR LOCATED** — unchanged, now unhedged (D.3) |

### In scope but NOT reached, and why

- **The programme's five already-recorded pre-emptions** (centered-square formula; six sisters and
  five-cycle normal form; Fano-component realization; order-ten shadow; rational anomaly inverse). I
  read the programme's priority note at full text and took its verdicts as given. **I did not
  independently re-verify any of them**, and none of their sources was obtained by me. If the lane
  wants them re-checked, that is a separate task.
- **The cubic/polar/determinantal shadow claims** (middle-exterior operator, Pfaffian identities,
  MCM/Ulrich package, small resolutions, Segre–Igusa polar map). These touch algebraic geometry
  rather than the two-graph/SRG/design territory I was asked to audit, and the programme's note
  already assigns Howard–Millson–Snowden–Vakil and Gripaios–Nguyen. Out of my scope, not audited.
- **The measurement/fermion/anomaly and Majorana-parity material**, and the symmetry/exceptional/
  lattice boundary items (Clifford extension splitting, Coble conormal scalar, McKay–Hamming `E₈`
  isometry, `II_{10,10}`). Same reason — outside the named territory. Not audited.
- **Clebsch III sections other than the golden-operator section** — the orientation cover,
  arithmetic specialization, harmonic realization, and marking-ambiguity sections. Only the
  two-graph-adjacent material was in scope. Not audited.

### Searched and found nothing (licenses a negative)

- No two-graph or Seidel-matrix reconstruction-from-local-data theorem beyond the descendant
  correspondence, in the sources reached (A.4) — **bounded by the two Seidel surveys not obtained**.
- No predecessor for the three Paley 3-design parameter sets, at exact-parameter strength (C.3).
- No predecessor for the Sylvester quadratic identities (C.4), the cross-ratio signature, the
  order-six uniqueness (C.6), the `[[28,14,5]]` degree distribution (D.2), or the parity-complement
  lemma (D.3).

### Could not access (licenses nothing; carried forward)

- **Seidel, *A survey of two-graphs* (1976), and Seidel & Taylor, *Two-graphs, a second survey*
  (1981).** Neither obtained; neither carries a zbMATH review; neither conference volume is online.
  **These are the principal limitation on the A.4 negative** and the single most valuable
  acquisition for this lane. A library copy of the Bolyai volume or of Seidel's *Geometry and
  Combinatorics: Selected Works* would close it.
  **Superseded 2026-08-19** by `2026-08-19-c876-seidel-survey-google-books-search.md`: both
  surveys were searched at snippet level inside the *Selected Works* reprint, every decisive query
  came back empty in them, and the entry now reads *searched, no predecessor located, bounded by
  OCR quality* rather than *could not access*.
- **MathSciNet review layer.** Tested, not assumed (D.1). Bibliographic layer now covered via MR
  Lookup.
- **Chakravarti IMA chapter.** Open since C866; access problem, not a search problem.
- **Hyun & Hu (2026).** Open since C871, seven attempts.
- **Brouwer & Shult (1990) full text.** Open since C873; MR number now pinned.
- **Google Scholar.** Blocks automated access; not attempted.
- **The published versions** of Pouzet–Si Kaddour–Trotignon (I read the preprint) and of
  Brouwer–Van Maldeghem (I read the author's preprint).
- **Morales & Velarde (2005) full text** — held at review only; the resolvability equivalence I rely
  on for the C.1 upgrade is the reviewer's summary sentence, unverified against the paper.

## Incidental observations (candidate discovery-track entries)

Recorded here only; not written to the discovery track by this task.

1. **A free 3-design upgrade is available for the order-ten cut design.** Provenance: Morales &
   Velarde's zbMATH summary, quoted at C.1 — every resolvable `2-(10,5,16)` design is also a
   resolvable `3-(10,5,6)` design and conversely. The programme's design arises as 36 cuts each
   contributing two halves, which is a natural resolution candidate. Checking resolvability is a
   small computation and would, if positive, promote the claim to a 3-design for free and align it
   with the programme's other 3-design results.
2. **The lane's reference lists address the wrong community.** Provenance: this round's A.1 and B,
   and C871's finding that the decisive predecessor for the fold sat in a monograph. Clebsch I and
   III run on two-graph and switching-class machinery while citing the graph-reconstruction
   literature; the two-graph community — Seidel, Taylor, Brouwer–Van Maldeghem — is the one most
   likely to referee this work and is currently unaddressed. This is a systematic pattern across
   three audits, not a single omission.
3. **My zbMATH client was silently converting errors into apparent empty results.** Provenance: this
   round — a shell pipeline of the form `python3 zb.py "$q" 2>/dev/null || echo EMPTY` never fired
   the fallback, because a downstream `head` returned exit 0 even when the Python process died. Five
   exact-parameter queries printed nothing and looked like clean negatives. I caught it and rewrote
   the client to catch `HTTPError` and print the status explicitly. **Any negative produced by that
   pipeline shape in an earlier round is suspect**; the affected shape appears in C876 only, since
   earlier rounds printed counts directly, but it is worth a convention note that a search client
   must distinguish empty from error *in its own output* rather than relying on shell control flow.
4. **MR Lookup is a free bibliographic layer of MathSciNet.** Provenance: D.1. Four rounds of
   recording MathSciNet as flatly NOT COVERED were imprecise. Bibliographic verification — which is
   what the attribution rules most often need, since they forbid asserting volume and page detail
   from memory — has been available all along without authentication.
5. **The two numbers coincide exactly, and nobody has explained why.** Provenance: A.2 and A.3 —
   Dammak–Lopez–Pouzet–Si Kaddour give four-local reconstruction up to complementation valid from
   seven points for graphs; Clebsch III proves four-local determination up to complement from seven
   points for two-graphs, by a different argument, and the two statements do not formally imply each
   other in either direction. Either there is a reduction nobody has written down, or the agreement
   is a coincidence of small numbers. That is a genuine open question and a good one.
