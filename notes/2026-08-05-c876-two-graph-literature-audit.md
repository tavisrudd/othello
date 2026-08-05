# C876 — two-graph literature audit of Clebsch III and the golden-operator programme

**Date:** 2026-08-05
**Task:** C876
**Lane:** `clebsch`
**Status:** IN PROGRESS (written incrementally; banner removed at completion)

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

*(finalised at completion; full-text count stated here)*

## Verdict table

*(filled in as items settle)*

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

## Search record

## Query hygiene — bound for part of this round, lifted mid-round

## Coverage statement

## Incidental observations (candidate discovery-track entries)
