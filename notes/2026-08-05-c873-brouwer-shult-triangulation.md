# C873 — triangulating Brouwer & Shult (1990) through citing restatements

**Date:** 2026-08-05
**Task:** C873
**Lane:** `clebsch`
**Status:** complete

Closes the C871 blocking gap: A. E. Brouwer & E. E. Shult, "Graphs with odd cocliques",
*Europ. J. Combin.* 11 (1990) 99–104, held in C871 only as quoted by Brouwer & Van Maldeghem's
*Strongly Regular Graphs* (Proposition 3.6.1). Method as instructed: triangulate through later
works that cite it and restate the result, rather than a further attempt to obtain the 1990 paper.

Questions:

1. The precise statement and its **scope** — all types of quadratic form over the field of two
   elements, or only one type? Any rank-parity hypothesis?
2. Does any citing work state it at the level of **codes** rather than graphs?
3. Is there a **binary converse or uniqueness** result, as Pasechnik supplies in the ternary case?

Calibration received from the coordinator and applied: the belief that the code-level fold worked
only at plus type has been **retracted** as an indexing error; the affine code descends at plus,
minus and parabolic type alike. The plus-type-only story is therefore not treated as a live
hypothesis anywhere below, and the C871 verdict that the code-level residue is thin stands.

**Standing constraint honoured throughout:** a restatement in a citing work is a `secondary only`
read of Brouwer & Shult, recorded as such together with the citing work's own read depth. No chain
of restatements is allowed to become a full-text verdict.

Governing conventions: `notes/literature-audit-conventions.md`, binding in full. zbMATH Open again
replaces Crossref for keyword negatives, with the HTTP-404-means-empty calibration restated in the
Search record; Crossref is used only where it is sound, for forward-citation counts.

## Opening summary

**None of this report's sources were read at full text — the count is zero.** That is unusual
enough to lead with. The central verdict rests on two sources: one read at `partial` (the
author-hosted preprint of Brouwer and Van Maldeghem's book, where I read the relevant sections) and
one read at `review only` (the zbMATH review of Brouwer and Shult). Two further sources were read at
`partial` purely to run a negative screen, and everything else is `secondary only` or
`abstract/metadata only`. Under the conventions this is a materially weaker object than the previous
three rounds, and the scope answer below should be read with that in front of it. The per-source
table in the Search record is authoritative and has no `full text` rows.

**The instructed method mostly failed, and that is itself the first result.** Brouwer and Shult
(1990) has a citing count of 2 on OpenAlex, 2 on Crossref, and 5 on Semantic Scholar. I retrieved
the largest set in full, obtained both members that could be obtained, and searched their complete
texts: **Brouwer and Shult appears only in their bibliographies, with no in-text restatement.** So
there is no citing literature to triangulate through. What closed the gap instead was the zbMATH
review of the 1990 paper, which no other service holds.

**Item 1, the scope answer, which is what you mainly need.** The general theorem has **no type
hypothesis and no rank hypothesis, because it is not a statement about quadratic forms at all**.
Per the review, Brouwer and Shult work with arbitrary finite graphs and a coclique-parity condition,
and their main theorem is that a graph is non-empty, reduced and satisfies that condition **if and
only if** it is the Taylor double of a smaller graph with a point adjoined. Quadrics, types, fields
and ranks do not appear. Asking whether it holds at elliptic as well as hyperbolic type is asking
the wrong question of that theorem.

**Is that firm or inferred? Split, and the split matters.** That the *published result* is
type-general is **firm**: Brouwer and Van Maldeghem's Proposition 3.6.1 states the specialisation
with the type parameter free throughout, its small-cases list exhibits both types concretely, and
the book's separate citation of Brouwer and Shult in its Fischer-spaces chapter again describes the
family with the type parameter free. Odd rank is covered by a separate identity in the same
proposition. What is **not** firm is what Brouwer and Shult themselves write about quadratic forms:
their review does not mention quadrics, so the specialisation to the binary orthogonal graphs may be
the book's packaging of their general theorem rather than something they state. This does not change
the lane's position — the result is published and type-general either way — but it changes **who to
cite**. Cite Brouwer and Van Maldeghem Proposition 3.6.1, which I have read, naming Brouwer and
Shult as its source. Do not cite Brouwer and Shult directly for the identities without obtaining
the paper.

**Item 2:** no citing work states it at the level of codes, and outward searching on the relevant
generic vocabulary returns empty sets. Consistent with C871 and adding nothing to it; the code-level
residue remains a translation of a published graph statement through a published dictionary.

**Item 3:** a converse exists and is **stronger and more general** than the ternary Pasechnik
converse found in C871 — it is the biconditional that constitutes Brouwer and Shult's main theorem,
at the level of arbitrary graphs. Firm from the review, attributed to the reviewer and unverified
against the paper. This closes off "our fold has a converse the literature lacks" as a fallback.

**Open gaps:** the 1990 paper itself is still not obtained, so the gap is narrowed rather than
closed; MathSciNet, which would supply the natural second independent restatement, is not covered;
and Hyun and Hu remains unobtainable after five further retrieval routes and stays at review only,
with its content **not** inferred.

## Verdict table

| # | Question | Answer | Firmness |
|---|---|---|---|
| 1 | Scope of the theorem — types | **No type hypothesis.** The general theorem is about arbitrary graphs; the published specialisation carries the type parameter free and is used at both types | **Firm** for the published record; **inferred** as to Brouwer & Shult's own presentation |
| 1a | Scope — rank parity | **No rank hypothesis** in the general theorem. In the specialisation, even rank is the main identity and odd rank has its own | **Firm** at the level of the book's statement |
| 1b | What the theorem actually says | A graph is non-empty, reduced and satisfies the odd-coclique condition **iff** it is a Taylor double of a smaller graph plus a point | **Review only**, attributed to the reviewer, unverified against the paper |
| 2 | Any code-level statement in citing works | **NO PREDECESSOR LOCATED** — the citing set contains no restatement at all, and outward search is empty | Firm as a negative, on generic vocabulary |
| 3 | Converse or uniqueness in the binary case | **YES, and more general** — the biconditional is the paper's main theorem, at the level of arbitrary graphs, subsuming any binary instance | **Review only**, same caveat |
| — | Triangulation via citing works | **Method failed** — citing counts of 2 / 2 / 5, and no in-text restatement in either obtainable member | Firm |
| — | Hyun & Hu (2026) | **Still unobtainable**; content not inferred | Open gap |

## Per-item findings

### The triangulation method itself largely failed, and that is the first finding

The instructed method — find later works that cite Brouwer & Shult and restate the proposition —
has almost no material to work with, because the paper is barely indexed as a citation target.
Counts, recorded separately as required, for the seed pinned below:

| Service | Citing count |
|---|---|
| OpenAlex (`W2061056752`) | 2 |
| Crossref (`is-referenced-by-count`) | 2 |
| Semantic Scholar (`7d386f9566373e41d38d0021a1985a067dae05e4`) | 5 |

Seed resolution, recorded because the conventions require a pinned identifier: I resolved by title
**once**, then verified the returned record against bibliographic detail I already held from the
Brouwer–Van Maldeghem bibliography (European Journal of Combinatorics, volume 11, pages 99–104,
1990, authors Brouwer and Shult) before pinning. All three services agree on volume, issue, pages
and year. DOI `10.1016/s0195-6698(13)80062-5`.

The largest citing set (Semantic Scholar, 5 records) was retrieved in full and screened. Its members
are, with read depth `abstract/metadata only` for the three not obtained and `partial` for the two
obtained:

- "The complete classification of triply-transitive strongly regular graphs", arXiv:2510.23441 —
  `partial` (PDF fetched, SHA-256 begins `6fead1b1a04d193d`, extracted with poppler and searched
  locally).
- "Tightness of the Weight-Distribution Bound for Strongly Regular Polar Graphs", DOI
  `10.1002/jcd.22001`, arXiv:2407.02780 — `partial` (PDF fetched, SHA-256 begins
  `6ff98a990cd54b7f`, same treatment).
- "Strongly Regular Graphs", DOI `10.1007/978-1-4614-1939-6_9` — `abstract/metadata only`.
- "The Smallest Strictly Neumaier Graph and its Generalisations", DOI `10.37236/8189` —
  `abstract/metadata only`.
- "State transfer in strongly regular graphs with an edge perturbation", DOI
  `10.1016/j.jcta.2019.105181` — `abstract/metadata only`.

Screen applied to the two obtained papers: search the extracted text for `Shult`, `odd coclique`,
and `Taylor`. **In both, Brouwer & Shult appears only in the bibliography, with no in-text
restatement of any kind.** So the citing literature supplies no restatement, and the triangulation
had to be done from two other sources: the zbMATH review of the paper itself, and the second and
third places where Brouwer–Van Maldeghem cites it.

### Item 1 — the precise statement and its scope

**Answer: the general theorem has no type hypothesis and no rank hypothesis, because it is not a
statement about quadratic forms at all. This is FIRM. What remains INFERRED is the exact form in
which Brouwer & Shult themselves present the specialisation to the binary orthogonal graphs.**

The decisive new source is the **zbMATH review of Brouwer & Shult (1990)**, zbMATH record
`https://zbmath.org/4181390`, reviewer signed "Hao Li". Read depth: `review only` — the review text
was retrieved through the zbMATH Open API; the paper itself was not obtained. This is a
`secondary only`-grade window onto Brouwer & Shult and is treated as such. The review states the
paper's setting and main theorem; quoting the load-bearing portion verbatim, with the review's own
notation:

> "A subset A is called odd (even) when `|x^⊥ ∪ A|` is odd (even) for all x in X. Property `(CC)_d`
> means each (d−1)-coclique is contained in some odd d-coclique […] Γ is called reduced when the
> equivalence classes are single points, where the equivalence relation xRy is defined by
> `x^⊥ = y^⊥`. It is shown here that Γ satisfies `(CC)_1` iff its radical `rad Γ (= {x ∈ X : x^⊥ = X})`
> is empty and that Γ is non-empty, reduced and satisfies `(CC)_2` iff `Γ = f(Δ)` for some reduced
> graph Δ with radical `rad Δ` empty and without odd 2-coclique, where `f(Δ) = D(Δ ⊕ {∞})`, the
> Taylor double of `Δ ⊕ {∞}`. Some more necessary and sufficient conditions are given for a graph to
> be reduced, coconnected and satisfy `(CC)_d` and `(C1)_d`."

Three things follow, and they answer the scope question directly.

1. **The theorem quantifies over arbitrary finite graphs.** Its hypotheses are combinatorial —
   non-empty, reduced, and a coclique-parity condition. No quadratic form, no field, no type, no
   rank appears. So asking whether it "holds for elliptic as well as hyperbolic type" is asking the
   wrong question of the wrong object: the theorem is type-free because types are not in its
   statement. MY inference, marked as mine: the type-and-rank bookkeeping the lane cares about
   enters only when the theorem is *applied* to a specific family, and the application is where any
   scope restriction would have to live.
2. **The conclusion is exactly the Taylor-double construction the lane folds by.** `f(Δ) = D(Δ ⊕
   {∞})` is the Taylor double of Δ with a point adjoined — identical in form to the SRG book's
   §1.2.7 definition "given a strongly regular graph Δ with `k_Δ = 2μ_Δ`, its Taylor extension `TΔ`
   is the Taylor double of `{∞} + Δ`". So the operation is the same operation.
3. **It is an "iff".** That is item 3, and it is answered below.

**On the specialisation.** Brouwer–Van Maldeghem's Proposition 3.6.1, attributed to Brouwer & Shult
[142], is introduced by the sentence "We have precise information about the local structure of the
polar graphs `O^ε_m(2)`", and its identities carry ε as a **free parameter throughout**:

```
T O^ε_m(2)      = 1 + O^ε_m(2) + O^ε_m(2) + 1
V O^ε_{2n}(2)   = 1 + O^ε_{2n}(2) + N O^ε_{2n}(2)     and   V O_{2n+1}(2) = T O_{2n+1}(2)
N O^{-ε}_{2n}(2) = 1 + O_{2n-1}(2) + T O^ε_{2n-2}(2)
O^ε_m(2)        = 1 + O^ε_{m-2}(2).2 + V O^ε_{m-2}(2)
```

Read depth: `partial` for the book (carried from C871, same bytes, SHA-256
`fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`); `secondary only` for Brouwer &
Shult through it.

Reading the scope off this, as MY inference and marked as mine: the third identity — the one the
lane's fold instantiates — is stated with ε unquantified and therefore **covers both types at even
rank**, with the middle term `O_{2n−1}(2)` carrying no ε because odd rank over this field admits
one type. The sign flip between the left side's `−ε` and the right side's `ε` is the type
alternation between consecutive levels, which is what one expects and which matches the lane's own
computation at four ranks. Odd rank is handled by the separate identity `V O_{2n+1}(2) =
T O_{2n+1}(2)`. Corroborating detail from the same page: the small-cases list exhibits **both**
signs concretely — `O_2^−(2) = K_0`, `O_4^−(2) = K_5`, `O_2^+(2) = K_2`, `O_4^+(2) = 3 × 3`,
`N O_2^−(2) = K_3`, `N O_4^−(2) = T(5)`, `N O_2^+(2) = K_1`, `N O_4^+(2) = K_{3,3}`,
`N O_6^+(2) = T(8)` — so the book is plainly using the identities at both types.

**Firm or inferred, stated plainly as requested.** The type-generality of the *published* result is
firm at the level of the book's statement, which is a citing restatement I read directly and which
quantifies over ε. It is **not** firm at the level of Brouwer & Shult's own text, which I have not
read and whose review does not mention quadratic forms; it is possible that the specialisation to
`O^ε_m(2)` is the book's packaging of their general theorem rather than a proposition they state.
That distinction does not affect the lane's position — either way the result is published and
type-general — but it does affect **who to cite**, and on present evidence the safe citation is
Brouwer–Van Maldeghem Proposition 3.6.1, citing Brouwer & Shult as its source, rather than Brouwer
& Shult directly for the identities.

**Second and third citation sites.** The book's bibliography flags three pages for [142]. Beyond
Proposition 3.6.1, the other two are:

- In the Fischer-spaces chapter: "The '1 or 3 neighbors' of the definition of cotriangular was
  generalized to 'an odd number of neighbors' in Brouwer & Shult [142]." The surrounding theorem
  concerns cotriangular graphs and its examples are given as "`N^ε_{2n}(2)` […] the graph on the
  nonsingular vectors in a vector space of dimension `2n` over `F2` provided with a nondegenerate
  quadratic form of type ε, adjacent when orthogonal", together with `Sp_{2n}(2)` and complements of
  triangular graphs. This independently confirms the type-generality of the family in which the
  lane's carrier sits — again with ε free — and places Brouwer & Shult in the
  cotriangular-graph/Fischer-space line.
- A third mention in a graph-description entry, "See also [142]".

### Item 3 — converse and uniqueness

**Answer: yes, and it is stronger and more general than the ternary converse found in C871. FIRM,
from the review.**

Brouwer & Shult's main theorem as reported by the reviewer is a biconditional: a graph is a Taylor
double of the form `D(Δ ⊕ {∞})` **if and only if** it is non-empty, reduced and satisfies `(CC)_2`,
with Δ itself reduced, of empty radical, and without odd 2-coclique. So the converse does not need
to be sought in the binary case specifically — the characterisation is at the level of arbitrary
graphs and subsumes any binary instance. Given a level, the level above it is determined up to the
construction: the reviewer's phrasing "`Γ = f(Δ)` for some reduced graph Δ" with the stated
properties is a structure theorem, and the review adds that "some more necessary and sufficient
conditions are given" for the higher properties `(CC)_d` and `(C1)_d`.

Attributed to the reviewer and **unverified against the paper**, as the conventions require for any
claim taken from a review.

This is a strictly stronger position than the C871 finding. There, the converse was Pasechnik's,
stated for the ternary NO-graph tower. Here the converse is general-graph-theoretic and is the main
theorem of the very paper the lane's fold specialises. MY assessment, marked as mine: this closes
off "our fold has a converse that the literature lacks" as a possible fallback claim.

### Item 2 — is it ever stated at the level of codes?

**Answer: NO PREDECESSOR LOCATED, consistent with the C871 finding and adding nothing to it.**

The citing set contains no restatement of any kind, so it cannot contain a code-level one. Searching
outward on the relevant generic vocabulary returns empty conjunctive sets:

| Query (verbatim) | Service | Count |
|---|---|---|
| `title_and_abstract.search:("Taylor graph" AND code)` | OpenAlex | 0 |
| `title_and_abstract.search:("two-weight" AND "subconstituent")` | OpenAlex | 0 |
| `title_and_abstract.search:("Taylor extension" AND graph)` | OpenAlex | 1 |
| `title_and_abstract.search:("cotriangular" AND code)` | OpenAlex | 1 |
| `Taylor graph two-weight code` | zbMATH | 404 / empty |
| `codes from cotriangular graphs` | zbMATH | 404 / empty |

The two nonzero hits were screened on title and dismissed. They are "On vertex-transitive
distance-regular covers of complete graphs with an extremal smallest eigenvalue", arXiv:2412.11962,
and "Linear representations of cotriangular spaces", DOI `10.1016/0024-3795(83)90108-8` — read depth
for both: `abstract/metadata only` (OpenAlex work records, titles and identifiers; neither
obtained). The second is a linear-representation paper about cotriangular *spaces*, which is
adjacent vocabulary but not a statement about the affine-function codes.

So the code-level layer remains unoccupied, exactly as C871 concluded. MY assessment is unchanged
and I restate it rather than soften it: this is a translation of a published graph statement through
a published dictionary, and the emptiness of the code-level search does not make it a result.

### The Hyun & Hu risk — one more attempt, still unobtainable

As instructed, I made a further attempt and did not infer anything from the title.

Jong Yoon Hyun and Zhao Hu, "Recursive construction of projective two-weight linear codes",
*Finite Fields and their Applications* 110, Article ID 102751, 11 p. (2026), DOI
`10.1016/j.ffa.2025.102751`. Read depth: **`review only`**, unchanged from C871 — the zbMATH review
by Peter Boyvalenkov, quoted in full in the C871 report.

Attempts made this round, all failing: Unpaywall reports `is_oa: False` with no open locations;
ScienceDirect returns HTTP 403 to both the article and PDF endpoints; the DOI landing page resolves
(HTTP 200) but is the paywalled abstract shell; Semantic Scholar holds no abstract; an author-scoped
Semantic Scholar query returned 0; an OpenAlex query on the distinctive title terms returns only the
paywalled record itself; an arXiv author search and two arXiv title-term searches (recorded in the
Search record) find no preprint; and an open-web search surfaces no preprint, repository copy, or
conference version under this or a variant title.

**It stays an open gap.** Whether its recursion is the fold, its inverse, or unrelated is
undetermined. It does not affect this round's verdicts, which rest on the Brouwer–Shult line.

## Search record

### Services, and why zbMATH again replaces Crossref for keyword work

Restated as required. Crossref's `query.bibliographic` is relevance ranking over an implicit OR, so
it cannot enumerate a conjunctive set and licenses no keyword negative; **OpenAlex, Semantic Scholar
and zbMATH Open** carry those. Crossref is used here only for a forward-citation count, where its
reference data is sound. This round zbMATH did more than substitute — it supplied the single most
informative source in the report, the review of the 1990 paper, which no other service holds.

### Empty versus error, per service

- **OpenAlex**: empty is HTTP 200 with `meta.count = 0`; errors raise in the client.
- **Semantic Scholar**: empty is HTTP 200 with `"total": 0`; HTTP 429 is retried with backoff and a
  give-up prints `S2_ERROR`.
- **zbMATH Open**: **empty is HTTP 404**, re-confirmed live this round — `graphs with odd cocliques`
  → 200 with 5 results and `local structure polar graphs binary codes affine functions` → 200 with
  1, while `Taylor graph two-weight code` and `codes from cotriangular graphs` → 404. Same query
  shape, both outcomes, so 404 reads as "no documents matched".
- **arXiv API**: empty is a 200 Atom feed with `totalResults = 0`.
- **Direct fetches**: `curl` on plain URLs, matching done locally on this host.

### Verbatim load-bearing queries

```
OpenAlex   search:"Graphs with odd cocliques"                              -> seed resolution (verified, then pinned)
OpenAlex   cites:W2061056752                                              -> 2
OpenAlex   title_and_abstract.search:("odd cocliques")                     -> 1 (the paper itself)
OpenAlex   title_and_abstract.search:("Taylor graph" AND code)             -> 0
OpenAlex   title_and_abstract.search:("cotriangular" AND code)             -> 1
OpenAlex   title_and_abstract.search:("two-weight" AND "subconstituent")   -> 0
OpenAlex   title_and_abstract.search:("Taylor extension" AND graph)        -> 1
OpenAlex   title_and_abstract.search:("projective two-weight" AND recursive)-> 1
zbMATH     graphs with odd cocliques                                       -> 5
zbMATH     graphs with odd cocliques Brouwer Shult                         -> (review retrieved)
zbMATH     local structure polar graphs binary codes affine functions      -> 1
zbMATH     Taylor graph two-weight code                                    -> 404 / empty
zbMATH     codes from cotriangular graphs                                  -> 404 / empty
S2 bulk    "Hyun" + "two-weight" + projective                              -> 0
S2         citations of 7d386f9566373e41d38d0021a1985a067dae05e4           -> 5
arXiv      all:"odd cocliques"                                             -> 0
```

Local (no outbound parameters): all matching against the SRG book text and the two citing PDFs was
done with `grep`/`sed` on this host.

### Screened sets

1. **Semantic Scholar citing set of the seed, 5 records** (the largest of the three counts).
   Screened over title for all five, and over **full extracted text** for the two obtainable ones.
   Discriminator applied verbatim to the texts: search for `Shult`, `odd coclique`, `Taylor`.
   Result: in both obtained papers the only match is the bibliography entry. **Zero restatements.**
2. **zbMATH `graphs with odd cocliques`, 5 records.** Screened over title. Discriminator: *is this
   the 1990 paper or a work restating it?* One passed — the paper's own record, which carries the
   review. The other four are intersection-density papers matching on "coclique" and are unrelated;
   read depth `abstract/metadata only` (zbMATH title records), named here only to be dismissed:
   "On complete multipartite derangement graphs" (zbMATH 7435679), "The intersection density of
   non-quasiprimitive groups of degree 3p" (7983124), "Intersection density of imprimitive groups of
   degree pq" (7920037), "On the intersection spectrum of PSL_2(q)" (7945849).

### Sources named in this report, with read depth

| Source | Read depth |
|---|---|
| Brouwer & Shult, *Graphs with odd cocliques*, Eur. J. Comb. 11 (1990) 99–104 | `review only` (zbMATH 4181390, reviewer Hao Li) **and** `secondary only` (via Brouwer & Van Maldeghem Prop. 3.6.1) — never read directly |
| Brouwer & Van Maldeghem, *Strongly Regular Graphs* (author-hosted **preprint**) | `partial` (carried from C871, same bytes) |
| *The complete classification of triply-transitive strongly regular graphs*, arXiv:2510.23441 | `partial` |
| *Tightness of the Weight-Distribution Bound for Strongly Regular Polar Graphs*, DOI 10.1002/jcd.22001, arXiv:2407.02780 | `partial` |
| Hyun & Hu, *Recursive construction of projective two-weight linear codes*, Finite Fields Appl. 110 (2026) | `review only` (zbMATH, reviewer Peter Boyvalenkov) |
| *Strongly Regular Graphs*, DOI 10.1007/978-1-4614-1939-6_9 | `abstract/metadata only` |
| *The Smallest Strictly Neumaier Graph and its Generalisations*, DOI 10.37236/8189 | `abstract/metadata only` |
| *State transfer in strongly regular graphs with an edge perturbation*, DOI 10.1016/j.jcta.2019.105181 | `abstract/metadata only` |
| *On vertex-transitive distance-regular covers of complete graphs…*, arXiv:2412.11962 | `abstract/metadata only` (named only to be dismissed) |
| *Linear representations of cotriangular spaces*, DOI 10.1016/0024-3795(83)90108-8 | `abstract/metadata only` (named only to be dismissed) |
| Four zbMATH intersection-density records (7435679, 7983124, 7920037, 7945849) | `abstract/metadata only` (named only to be dismissed) |
| Pasechnik, *On some locally 3-transposition graphs*, LMS Lecture Note Ser. 191, 1993 | `secondary only` (via the SRG book; carried from C871) |
| Hall & Shult, and Hall, on cotriangular and locally cotriangular graphs | `secondary only` (via the SRG book's Fischer-spaces chapter; not obtained) |

**Hashes.** SRG book preprint `fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`
(carried over). The two citing PDFs fetched this round begin `6fead1b1a04d193d` (arXiv:2510.23441)
and `6ff98a990cd54b7f` (arXiv:2407.02780); neither was added to the shared literature cache, since
neither is load-bearing for a verdict — each was fetched solely to run the negative screen above.

## Query hygiene

No slip. Every outbound query used standard published vocabulary — "odd cocliques", "Taylor graph",
"Taylor extension", "cotriangular", "subconstituent", "two-weight", "projective two-weight",
"recursive" — or was a plain URL fetch by DOI or arXiv identifier. No parameter, rank, type, weight
enumerator, or description of the lane's construction left this host. The one title-search seed
resolution was performed once, verified against bibliographic detail already in hand, and then
replaced by pinned identifiers for all subsequent calls.

## Coverage statement

### Searched and found nothing (licenses a negative)

- No citing work restates the proposition, at graph level or any other level. This rests on a
  full-text screen of both obtainable members of the largest citing set and a title screen of the
  rest.
- No work states the relation at the level of the affine-function codes (item 2), on the generic
  vocabulary searched.

### Could not access (licenses nothing; carried forward as open gaps)

- **Brouwer & Shult (1990) itself — STILL NOT OBTAINED, and this gap is not closed, only narrowed.**
  Unpaywall reports no open location; ScienceDirect returns HTTP 403. The paper is now covered by a
  `review only` read and a `secondary only` restatement, which together answer the scope question at
  the level of the published record but **do not** establish what the authors themselves write about
  quadratic forms. Anyone citing them for the `O^ε_m(2)` identities specifically should obtain the
  paper first; citing Brouwer–Van Maldeghem Proposition 3.6.1 needs no such caveat.
- **MathSciNet — NOT COVERED.** Institutional authentication required. Its review of the 1990 paper
  would be the natural second independent restatement and is exactly what is missing; every claim
  about scope keeps "to our knowledge".
- **Google Scholar — NOT COVERED.** Blocks automated access. Full-text search over citing works is
  therefore unavailable, which matters more than usual here, because the citing set is small enough
  that an unindexed citation would be a large proportional gap.
- **Hyun & Hu (2026).** `review only`; five retrieval routes tried and failed this round. Open.
- **The published Cambridge edition of Brouwer & Van Maldeghem.** Preprint only, as in C871.
- **The three unobtained members of the citing set**, and the Hall/Hall–Shult cotriangular
  literature, all at metadata or secondary depth.
- **Chakravarti, IMA Volumes chapter (DOI 10.1007/978-1-4613-8994-1_4).** Not retried this round.
  Open since C866.

## Incidental observations (candidate discovery-track entries)

Recorded here only; not written to the discovery track by this task.

1. **A foundational 1990 paper in this area has a citing count of 2 to 5 across three services.**
   Provenance: this audit — OpenAlex 2, Crossref 2, Semantic Scholar 5, for a paper a 2022 Cambridge
   monograph cites three times and names a proposition after. Monograph citations are largely absent
   from these graphs, and pre-web Elsevier reference lists are patchy. **The practical consequence
   for this lane: forward-citation screening is not a usable instrument for results whose main
   downstream audience is books.** Two of the last three audits found their decisive predecessor in
   a monograph, and neither would have been reachable by citation-graph search.
2. **zbMATH reviews are carrying disproportionate weight in this lane's audits.** Provenance: this
   round, where the review supplied the actual theorem statement, and C871, where a review was the
   only window onto Hyun & Hu. zbMATH is being used as a substitute for Crossref on keyword
   negatives and, increasingly, as a primary source of statements. That is defensible under the
   conventions' `review only` depth, but it concentrates risk in one service and one reviewer per
   paper. Worth an explicit note in the conventions that a review-only verdict on a load-bearing
   statement should be flagged for a second independent restatement before manuscript use.
3. **The theorem the lane's fold specialises is a general-graph characterisation, not a fact about
   quadrics.** Provenance: the zbMATH review of Brouwer & Shult quoted above. This is worth logging
   independently of the audit verdict, because it suggests the natural generalisation of the lane's
   construction is combinatorial rather than geometric: any family of graphs satisfying the
   odd-coclique condition folds, and quadratic forms are one source of such families. If the lane
   ever wants a genuinely new tower, that is where to look — a family satisfying `(CC)_2` that is
   *not* of quadratic-form type.
