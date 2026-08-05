# C866 — literature / novelty / priority audit of the exceptional code ladder

**Date:** 2026-08-05
**Task:** C866
**Lane:** `clebsch`
**Status:** complete

Audited bundle: `notes/2026-08-05-c682-e8-root-pair-ladder.md` (C682), plus the E9/affine
extension attributed to C865.

Governing conventions: `notes/literature-audit-conventions.md` (binds in full — the deliverable
is a set of absence-of-prior-work verdicts).

## Opening summary

**Four of this report's sources were read at full text.** They are: Calderbank and Kantor's 1986
survey *The Geometry of Two-Weight Codes*; the row for parameters (256,120,56,56) in Brouwer's
strongly-regular-graph tables; the row for parameters (64,28,12,12) in the same tables; and the
codetables.de best-known-linear-code page for binary length 240, dimension 10. One further source,
Moorhouse's 1991 handout on the E8 root lattice, was read at `partial`. Everything else is
`secondary only` or `abstract/metadata only`, and no verdict below rests on the content of a
metadata-only source beyond what its recorded title or abstract states. The read-depth field is
carried by every source named anywhere in this report, including sources named only to be
dismissed; the per-source table in the Search record is the authoritative list, and its `full text`
rows number four.

The audit's shape, in one paragraph. **The individual codes are not new and the individual rungs
are not new; the ladder is.** The E8 code and the E7 code are the `q = 2` instances of a
two-weight-code family that Calderbank and Kantor published in 1986 as Example RT2, whose
difference-set and bent-function readings they also give, and whose strongly regular graphs sit in
Brouwer's public tables with the exact linear parts of both our codes spelled out in the table rows
("projective binary [120,8] code with weights 56, 64"; "projective binary [28,6] code with weights
12, 16"). Against that, no work was located that presents an E6/E7/E8-indexed *series* of codes, or
that builds a code from the mod-2 reduction of an affine or hyperbolic Kac–Moody root lattice, or
that constructs quantum codes from Freudenthal triple systems or minuscule representations. One
correction the bundle should absorb: a real and different literature does connect E8 root lattices
to quantum stabilizer codes — the code-CFT programme, via even self-dual Lorentzian lattices — so a
blanket "nobody has connected E8 to quantum codes" would be false.

**Two things block a clean manuscript claim.** First, Chakravarti's 1990 IMA-volume chapter names
quadrics in projective geometry, Hadamard difference sets, and designs associated with two-weight
codes in a single title, and it was reached at metadata depth only; it must be obtained at full
text before anything is claimed about the minimum-shell design. Second, whether the
non-coordinate-transitivity of the published `[[28,14,5]]` code is recorded anywhere could not be
determined, because the discriminating query would disclose unpublished parameters — see the Query
hygiene section, which also records the one genuine hygiene incident in this audit.

## Verdict table

| # | Object audited | Verdict |
|---|---|---|
| 1 | E8 root-pair code, affine functions on the plus-type quadric complement in F_2^8 | **FOLKLORE / KNOWN-IN-SUBSTANCE** — Calderbank–Kantor 1986 Example RT2 + §12; Brouwer SRG table row (256,120,56,56) |
| 2 | E7 bitangent code on the 28-point odd quadric; E6 code by shortening | **FOLKLORE / KNOWN-IN-SUBSTANCE** — same family at `l = 3`; Brouwer SRG table row (64,28,12,12) |
| 3 | Root-link antipodal fold theorem (E8 code restricted to a root link folds to the E7 code) | **FOLKLORE / KNOWN-IN-SUBSTANCE in every ingredient; NO PREDECESSOR LOCATED for the assembled code-level statement** |
| 4a | Affine/hyperbolic Kac–Moody root lattice mod 2 as a code carrier; the level fold as a ladder step | **NO PREDECESSOR LOCATED** — the load-bearing novelty of the E9 item |
| 4b | The E9-level parameters and the Plotkin `\|u\|u+v\|` identity | **FOLKLORE / KNOWN-IN-SUBSTANCE**, and the code is two units below best known and four below the upper bound at that length and dimension |
| 5 | Minimum shell as a 2-design; dual tetrads; direct CSS construction | **FOLKLORE / KNOWN-IN-SUBSTANCE** on the general mechanism; the specific design was not located, and Chakravarti 1990 is an unresolved likely predecessor |
| 6i | Prior quantum codes from E7/E8 root systems | **NOT PRE-EMPTED for this construction**, but an adjacent E8-root-lattice / stabilizer-code literature exists (code CFTs) and must be cited |
| 6ii | Prior quantum codes from Freudenthal triple systems or minuscule representations | **NO PREDECESSOR LOCATED** |
| 6iii | Whether the non-transitivity of the published `[[28,14,5]]` code is recorded anywhere | **COULD NOT DETERMINE** — blocked by the query-hygiene constraint |
| 7 | The chain as a single exceptional series of codes indexed by E6/E7/E8 | **NO PREDECESSOR LOCATED** — including in the Deligne/Vogel exceptional-series literature |

## Per-item findings

### Item 1 — the E8 root-pair code [120,9,56]_2

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE.** The construction, the point set, the weights, the
difference-set structure, and the associated strongly regular graph are all explicitly in the
1986 Calderbank–Kantor survey and in Brouwer's strongly-regular-graph tables. The novelty that
remains is the *E8-root reading* of the point set and the affine (dimension 9) packaging, not the
code.

Evidence, in decreasing force:

1. **Calderbank–Kantor, Example RT2 and §12** (read depth: `full text`; see Search record for
   access, cache key, SHA-256). Example RT2 sets `k = 2l`, takes `Q` a nonsingular quadratic form
   on `GF(q)^k`, and puts `Ω = {v ≠ 0 : Q(v) = 0}`, with `|Ω| = (q^l − ε)(q^{l−1} + ε)`. At
   `q = 2, l = 4, ε = +1` this is `15·9 = 135`, the nonzero singular vectors of the plus-type form
   on `F_2^8`; its complement in `GF(2)^8 \ {0}` is our 120-point set. Section 12 then states
   verbatim:

   > "We obtain examples of (2^{2l}, 2^{l−1}(2^l + ε), 2^{l−1}(2^{l−1} + ε)) difference sets from
   > the complement of Example RT2 in GF(q)^{2l}\{0} when q = 2. If H is any hyperplane then
   > |H Δ Ω| = 2^{l−1}(2^l ± 1) […] The sets Ω are closely related to bent functions (MacWilliams
   > and Sloane [43, Chapter 14.5], Rothaus [47], and Dillon [23])."

   At `l = 4, ε = −1` the difference-set parameters are exactly `(256, 120, 56)` and the hyperplane
   symmetric differences are exactly `2^3(2^4 ± 1)/…` giving the sizes 56 and 64 — i.e. the two
   nonzero weights of our code. (The OCR of the surrounding formula display is degraded; the
   parameter identification above is MY arithmetic from the stated general formula, marked as my
   inference, not a quoted instance.)

2. **Brouwer's strongly regular graph tables**, row for parameters `(256, 120, 56, 56)`
   (read depth: `full text` of the table row; retrieved verbatim by `curl`). The row reads, in
   full:

   > `OA(16,8); Wallis (AR(2,4)+S(2,2,16)); from a partial spread: projective 4-ary [40,4] code
   > with weights 28, 32; from a partial spread of 4-spaces: projective binary [120,8] code with
   > weights 56, 64; RSHCD+; 2-graph`

   The clause "projective binary [120,8] code with weights 56, 64" is precisely the linear part of
   `C_{E8}`. Spectrum listed: `8^120, −8^135`. The adjacent row `(256, 135, 70, 72)` is the
   complementary (quadric) graph.

   MY inference, marked as mine: the affine code `[120,9,56]` of the C682 bundle is the
   two-weight `[120,8]` code of that row extended by the all-ones vector; the enumerator
   `1 + 255z^56 + 255z^64 + z^120` follows from the two-weight structure plus
   self-complementarity, and carries no information beyond it.

3. The bent-function / Hadamard-difference-set reading is the standard one: a quadratic form on
   `F_2^{2m}` is the canonical bent function, and its support is a Menon–Hadamard difference set.
   Calderbank–Kantor cite MacWilliams–Sloane ch. 14.5, Rothaus, and Dillon for this
   (read depth of those three: `secondary only`, via Calderbank–Kantor §12, whose own depth is
   `full text`; not independently obtained).

**What is *not* pre-empted.** No source located so far calls this point set "the 120 antipodal
pairs of E8 roots" or uses it as a term in an E6/E7/E8-indexed series. That is an identification,
not a construction; see item 7.

### Item 2 — the E7 bitangent code [28,7,12]_2 and the E6 code [27,6,12]_2

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE for the [28,7,12] code.** Same mechanism one level down,
and again catalogued explicitly.

- **Brouwer's tables**, row for `(64, 28, 12, 12)` (read depth: `full text` of the row, via
  WebFetch of `srgtab51-100.html`), lists among its constructions:
  "…from a partial spread of 3-spaces: projective binary [28,6] code with weights 12, 16…".
  That `[28,6]` two-weight code is exactly the linear part of the E7 bitangent code, and
  `1 + 63z^12 + 63z^16 + z^28` is its self-complementary affine extension. Same
  Calderbank–Kantor Example RT2 instance at `q = 2, l = 3`.
- The 28-point set as *bitangents of a plane quartic* / `Sp_6(2)` odd quadric is classical
  nineteenth-century geometry; the coding-theoretic packaging is the part at issue, and it is
  the RT2 instance above.

The `[27,6,12]` shortening: shortening a two-weight code at one coordinate is a routine operation;
no separate predecessor was sought or needed for the operation itself. Whether *this particular*
`[27,6,12]` is catalogued as "the code of the 27 lines" is treated under item 7.

### Item 5 — the minimum shell as a 2-(120,56,55) design; dual tetrads; CSS [[120,102,4]]

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE (design side); see item 6 for the quantum side.**

The arithmetic checks (`b·k = v·r`: `255·56 = 120·119`; `λ(v−1) = r(k−1)`: `55·119 = 119·55`) are
MY verification, not a source's. The substantive point is that designs carried by two-weight codes
and their difference sets are a named, surveyed topic — Calderbank–Kantor §12 already produces a
symmetric design from the same `Ω` ("The 2^{2l} subsets in B of size 2^{l−1}(2^l + ε) form a
symmetric design having the same parameters as that arising from the difference set Ω"), citing
Kantor [35]. That symmetric design lives on the 256 *vectors*, not on the 120 *coordinates*, so it
is a different design from the 2-(120,56,55); the shared point is that this family's designs are
worked ground, not that the specific 2-(120,56,55) was located as such.

Two sources are worth naming here even though they were reached only at metadata depth, because
they bound how much of item 5 is likely to be new:

- I. M. Chakravarti, "Families of Codes with Few Distinct Weights from Singular and Non-Singular
  Hermitian Varieties and Quadrics in Projective Geometries and Hadamard Difference Sets and
  Designs Associated with Two-Weight Codes", in *Coding Theory and Design Theory* (The IMA Volumes
  in Mathematics and Its Applications), Springer New York, 1990, pp. 35–50, DOI
  `10.1007/978-1-4613-8994-1_4`. Read depth: `abstract/metadata only` — Crossref metadata record
  retrieved by DOI (title, sole author, container, pages, year, publisher); Crossref carries no
  abstract for this record and the chapter text was not obtained. The title alone names quadrics
  in projective geometry, Hadamard difference sets, *and* designs associated with two-weight
  codes — i.e. exactly the three ingredients of items 1 and 5 in one 1990 chapter. MY inference,
  marked as mine: this is the single most likely explicit predecessor for the design statement,
  and it should be obtained at full text before any manuscript claim about the 2-(120,56,55)
  design is written.
- A. E. Brouwer, "Some new two-weight codes and strongly regular graphs", zbMATH record
  `https://zbmath.org/3894975`. Read depth: `abstract/metadata only` — zbMATH Open API search
  record (title and identifier only; no review text retrieved). Cited by Calderbank–Kantor as the
  source of further quadric-cut-by-quadric two-weight sets.

### Item 3 — the root-link antipodal fold theorem

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE for every ingredient; NO PREDECESSOR LOCATED for the
assembled code-level statement.**

The ingredients, separately, are standard:

- **E8 mod 2 is an O8+(2) orthogonal space, with 120 nonsingular classes.** This is explicit in
  G. Eric Moorhouse, "The E8 Root Lattice and Conway's Ovoids" (handout dated March 1991,
  `http://ericmoorhouse.org/handouts/conway.pdf`). Read depth: `partial` — PDF fetched by `curl`,
  extracted with poppler `pdftotext`, SHA-256
  `316a001f09c7fd77d56754c31745459f3bcac7fec35242f0f532858b213bf225`; I read the sections around
  the reduction mod p (the passage defining the quadratic form on `L`, the statement that
  `E = E/pE` "becomes an `O8+(p)` orthogonal space with quadratic form Q", and the count
  "`2^7 − 2^3 = 120` congruence classes with `½ v·v ≡ 1 mod 2`, total `136 + 120 = 256`"), plus the
  introduction and reference list. I did not read the ovoid constructions that are the handout's
  actual subject. This handout was NOT added to the shared literature cache — it is a personal
  handout rather than a DOI/arXiv-keyed publication, and `litcache` keys on those; the SHA-256
  above is the record.
  The handout's own reference [6] is G. E. Moorhouse, "Ovoids from the E8 root lattice",
  *Geom. Dedicata* 46 (1993), 287–297. Read depth: `secondary only` — bibliographic detail taken
  from the handout's reference list, whose own depth is `partial`; the paper itself was not
  obtained.
- **The orthogonal complement of a root in E8 is E7, and a root has exactly 56 roots at inner
  product 1 with it, pairing into 28 decompositions.** This is textbook root-system combinatorics.
  I did not locate — and did not need — a specific citation for it; it is asserted here as
  standard, not as a sourced claim.
- **Quotienting a quadratic form by a nonsingular vector yields an odd form on the symplectic
  quotient.** Standard finite orthogonal geometry over F_2.

What I could not find is anyone assembling these into the statement the C682 bundle proves: that
restricting the quadric code to the root link and folding along `u ↦ u + α` returns the E7 code on
the nose, with `Q̄(s) = Q(s) + B(u_0, s)`. Searches for the code-level form returned nothing (see
Search record: `bitangents AND "linear code"` returns 0 on OpenAlex and 0 on Semantic Scholar;
`abs:"bitangents" AND abs:"finite field"` returns 0 on arXiv).

MY inference, marked as mine: this is best positioned as a *known-in-substance derivation given
correct language* rather than a new theorem — a specialist in finite orthogonal geometry would
regard the fold as a routine consequence of the quotient construction. Its value is expository and
structural (it makes the ladder step canonical rather than a label lookup), and the manuscript
should claim it that way.

The 56-dimensional minuscule E7 representation and Freudenthal triple systems are genuinely
adjacent, but the located literature connects them to *entanglement classification*, not to codes:
`abs:"Freudenthal triple system"` on arXiv returns 36 works, whose visible cluster is
Jordan-algebra / black-hole / qubit-entanglement (e.g. arXiv:0812.3322, "Freudenthal triple
classification of three-qubit entanglement"; read depth `abstract/metadata only` — title and
identifier from the arXiv API listing, abstract not retrieved). OpenAlex
`("Freudenthal triple system" AND code)` returns 0; Semantic Scholar returns 0.

### Item 4 — the E9 / affine level code [240,10,112]_2 and the rank-10 analogue

Two sub-verdicts, as the brief asks.

**(b) The parameters and the Plotkin identity: FOLKLORE / KNOWN-IN-SUBSTANCE, and not optimal.**
The `|u|u+v|` construction of a `[2n, k+1, min(2d, n)]` code from an `[n,k,d]` code and the
repetition code is textbook (Plotkin sum / `(u|u+v)`). Independently, codetables.de records for
binary length 240, dimension 10 a best-known minimum distance of **114** with upper bound **116**,
built from a `[240,11,114]` code obtained by extending a `[239,11,113]` residue code arising from
concatenated BCH-over-GF(8) and Reed–Muller ingredients combined by a Plotkin sum. Read depth:
`full text` of the `codetables.de` BKLC page for `q=2, n=240, k=10`, retrieved by WebFetch on
2026-08-05 (before the query-hygiene constraint below took effect). So the affine-level code is
two units short of best known and four short of the upper bound; it is a structurally clean but
parameter-suboptimal ladder member, exactly as the bundle anticipates. No catalogue entry claiming
this specific code as a named object was located, and none was searched for by parameter, per the
hygiene constraint.

**(a) The affine-root-system carrier — the load-bearing question: NO PREDECESSOR LOCATED.**
This is the strongest negative in the audit, and it is a keyword negative, not a citation-graph
negative. Every service returns an empty conjunctive set:

| Query (verbatim)                                                    | Service          | Count |
|---------------------------------------------------------------------|------------------|-------|
| `title_and_abstract.search:("Kac-Moody" AND "linear code")`           | OpenAlex         | 0     |
| `"Kac-Moody" + "linear code"`                                         | Semantic Scholar | 1     |
| `Kac-Moody algebra error-correcting code`                             | zbMATH Open      | 0     |
| `title_and_abstract.search:("affine root system" AND code)`           | OpenAlex         | 1     |
| `abs:"affine root system" AND abs:"finite field"`                     | arXiv            | 0     |
| `abs:"Kac-Moody" AND abs:"error correcting"`                          | arXiv            | 0     |
| `abs:"hyperbolic lattice" AND abs:"quantum code"`                     | arXiv            | 0     |

The two nonzero hits were screened out on title alone. The Semantic Scholar hit is a conference
programme ("Rocky Mountain Discrete Math Days October 21–22, 2011, University of Wyoming"), with no
DOI; read depth `abstract/metadata only` (title and year from the API record). The single OpenAlex
hit is *Proceedings on Moonshine and Related Topics*, DOI `10.1090/crmp/030`, 2001; read depth
`abstract/metadata only` (OpenAlex work record). Neither is a code construction from an affine root
system.

So: no located work builds an error-correcting code from the mod-2 reduction of an affine or
hyperbolic Kac–Moody root lattice. This licenses a "to our knowledge" sentence, not more — see the
coverage statement and the query-hygiene note, both of which bound it.

The rank-10 overextended analogue is covered by the same negative; its parameters were not put to
any service.

### Item 6 — the quantum side

Three separate questions; three separate verdicts.

**(i) Prior quantum codes from E7/E8 root systems: NOT PRE-EMPTED for this construction, but a
real and different E8-root-lattice/quantum-code literature exists and must be cited.**

The code-CFT programme connects quantum stabilizer codes to root lattices, in a sense unrelated to
ours. A. Dymarsky and A. Shapere, "Quantum stabilizer codes, lattices, and CFTs", arXiv:2009.01244
(read depth: `abstract/metadata only` — abstract retrieved from the arXiv API by `id_list`;
the version returned by that endpoint is the latest, v4, and I did not compare it to the published
JHEP version) states that "real self-dual stabilizer codes can be associated with even self-dual
Lorentzian lattices", and reports among its examples "a non-chiral E8 theory, which is based on the
root lattice of E8 understood as an even self-dual Lorentzian lattice". A related later work,
"Code construction and ensemble holography of simply-laced WZW models at level 1",
arXiv:2503.04055 (read depth: `abstract/metadata only`, same access route), builds codes "over the
alphabet G" where G "is isomorphic to the discriminant group of the root lattice" of a simply-laced
affine Lie algebra at level 1.

MY inference, marked as mine, and kept distinct from those abstracts' own framing: this is a
different construction from ours in both the carrier and the alphabet — they code over the
discriminant group of the lattice, we code over F_2 on the *point set of root classes*; they use
the affine algebra as a CFT label, we use the affine root system as a coordinate set. But the
sentence "nobody has connected E8 root lattices to quantum codes" is false and must not appear in
any manuscript. The correct positioning sentence distinguishes carrier and alphabet.

A further adjacent cluster, screened but not promoted: OpenAlex
`title_and_abstract.search:("root system" AND "quantum code")` returns exactly 7 records, screened
over title and host venue. All 7 are 2026 Zenodo depositions, reducing to 3 distinct works after
DOI duplication ("D4-Octonion-Clifford Link to Quantum Codes and Toric Decoding — E8 Intelligence
Research"; "Phi-Floquet 864th Harmonic Induces Non-Abelian Parafermion Zero Modes in E8
Coxeter-Torus — E8 Intelligence Research"; "An Exceptional Finite Simple Group on a Quantum Code's
Logical Space: G2(3) and the [[13,7,3]]_3 Ternary Code"). Read depth for all three:
`abstract/metadata only` — titles, DOIs and years from the OpenAlex work records; no text
retrieved. Discriminator applied: *does the title indicate a stabilizer or CSS code whose
coordinates are a root-system point set?* None does. These are self-deposited, non-peer-reviewed
records; Semantic Scholar returns 0 for the same conjunction, which I read as S2 not indexing
Zenodo depositions rather than as a contradiction — that OpenAlex/S2 disagreement is itself
recorded below as a finding.

**(ii) Quantum codes from Freudenthal triple systems or minuscule representations: NO PREDECESSOR
LOCATED.** OpenAlex `("Freudenthal triple system" AND code)` = 0; Semantic Scholar
`"Freudenthal triple system" + code` = 0; OpenAlex `("minuscule representation" AND code)` = 0;
Semantic Scholar `"minuscule representation" + code` = 0; arXiv `abs:"minuscule" AND abs:"code"`
returns 16 records of which none is a coding-theory work (the mathematical one is "Perfect Codes
for Generalized Deletions from Minuscule Elements of Weyl Groups", arXiv:1810.09877 — read depth
`abstract/metadata only`, title from the arXiv API listing — which uses minuscule *Weyl group
elements* for deletion-correcting codes, an unrelated use of the word). zbMATH
`minuscule representation` alone returns 154 records, none of which were screened, so this negative
rests on the conjunctive searches only.

**(iii) The non-transitivity observation about the published [[28,14,5]] code: COULD NOT
DETERMINE.** Establishing whether this specific invariant is recorded anywhere requires either
searching by the point-degree distribution or fetching the parameter page — both forbidden by the
query-hygiene constraint (the distribution `82/86/94/98` is on the forbidden list, and the
coordinator has already fetched the relevant codetables/Grassl pages). Generic searching cannot
distinguish this observation from the general literature on automorphism groups of quantum codes.
Carried forward as an open gap, not as a negative.

Note, factored in rather than rediscovered, on the coordinator's instruction: our CSS codes sit one
below the exact records at both `[[28,14]]` and `[[120,102]]`, both of which are 5. The quantum
novelty question is therefore entirely (i)–(iii) above, not a record claim.

### Item 7 — the ladder as a whole

**Verdict: NO PREDECESSOR LOCATED for an E6/E7/E8-indexed series of error-correcting codes.**

Conjunctive searches over the natural vocabulary return empty sets:

| Query (verbatim)                                              | Service          | Count |
|---------------------------------------------------------------|------------------|-------|
| `title_and_abstract.search:("exceptional series" AND code)`     | OpenAlex         | 0     |
| `"exceptional series" + code`                                   | Semantic Scholar | 0     |
| `title_and_abstract.search:("27 lines" AND "binary code")`      | OpenAlex         | 0     |
| `title_and_abstract.search:(bitangents AND "linear code")`      | OpenAlex         | 0     |
| `abs:"27 lines" AND abs:"cubic surface" AND abs:"code"`         | arXiv            | 0     |
| `abs:"exceptional series" AND abs:"Lie"`                        | arXiv            | 20    |

The 20 arXiv hits for the Deligne/Vogel exceptional-series query were screened over title only, with
the discriminator *does the title indicate coding theory or finite geometry rather than
representation theory / VOA / quantum groups?* None passed: the set is uniformly R-matrices,
dimension formulas, intermediate/quantum exceptional series, sextonions and `E_{7½}`, universal Lie
algebra and diagrammatic categories. Named members, all read depth `abstract/metadata only`
(titles and arXiv identifiers from the arXiv API listing, abstracts not retrieved):
arXiv:2406.01348, 2403.14311, 2408.16560, 0402157, 2211.04270, 0107032, 2402.03637, 0610322,
0503151, 9703004. MY inference, marked as mine: the Deligne exceptional series literature is a
plausible *adjacent* home for such a statement but demonstrably does not contain one; citing it as
"the representation-theoretic analogue of what we do for codes" is defensible, citing it as a
predecessor is not.

The del Pezzo / exceptional-group side is real and classical — "the discovery by Cayley and Salmon
of the 27 lines on a cubic surface and the discovery by Killing and Cartan of the exceptional
simple Lie algebra of type E6 has made clear that del Pezzo surfaces and exceptional simple
algebraic groups have attached to them the same combinatorial objects" — but the located works are
about vector bundles and Springer fibres, not codes. Named, read depth `abstract/metadata only`
(titles and arXiv identifiers from a WebSearch result listing; the quoted sentence above is quoted
by the search service from one of them and I have NOT verified it against either paper's own text,
so it is attributed to the search-result rendering and marked unverified): "Exceptional groups and
del Pezzo surfaces", arXiv:math/0009155; "Del Pezzo surfaces as Springer fibres for exceptional
groups", arXiv:1507.01872.

So the ladder-as-a-whole framing appears to be new *as a coding-theoretic statement*, while every
individual rung is classical. That is the plain shape of the result and the shape the manuscript
should claim.

## Query hygiene

A constraint was imposed by the coordinator mid-task and was in force for everything from the
Semantic Scholar / OpenAlex boolean sweeps onward: no unpublished parameter tuple, weight
enumerator, tetrad count, design parameter, or construction description may appear in an outbound
query string, because third-party query strings are public and permanently logged. All searching
after that point used only generic, pre-existing vocabulary, with parameter matching done locally
against fetched material.

**Three queries issued BEFORE the constraint landed did contain parameter-level material**, and are
recorded here rather than glossed:

1. WebSearch: `binary code from nonsingular points of quadric PG(7,2) two-weight [120,8] weights 56 64`
   — discloses the two-weight parameters of the linear part. Mitigating fact: this exact string is
   a paraphrase of a *published* row in Brouwer's public strongly-regular-graph table, so it
   discloses nothing unpublished.
2. WebSearch: `bent function difference set (256,120,56) quadratic form binary code Reed-Muller` —
   `(256,120,56)` is a classical published difference-set parameter triple (Calderbank–Kantor 1986,
   §12), not ours.
3. WebSearch: `"exceptional series" codes E6 E7 E8 27 28 120 error-correcting code trinity del Pezzo lines bitangents`
   — this one *does* describe the shape of the project (the E6/E7/E8 indexing together with
   27/28/120 and "error-correcting code"). It is the one genuine hygiene incident in this audit. It
   returned no relevant mathematical results.

Also before the constraint: one `codetables.de` fetch for `q=2, n=240, k=10`. The coordinator has
since ruled that parameter lookups on that service go through them; no further ones were made.

**Verdicts weakened by the constraint.** Item 6(iii) — whether the non-transitivity of the
published `[[28,14,5]]` code is recorded anywhere — is `COULD NOT DETERMINE` specifically because
the discriminating query would disclose the point-degree distribution. Item 4(b) and items 1 and 2
carry a milder weakening: I did not ask any catalogue whether the exact parameter tuples are
already named objects, so "not catalogued under this name" is NOT claimed anywhere in this report;
only "no predecessor located for the construction/framing" is.

## Search record

### How "empty" was distinguished from "error", per service

- **OpenAlex** (`api.openalex.org/works`, `mailto` identified). An empty conjunctive set is HTTP
  200 with `meta.count = 0` and `results = []`. Any error raises an HTTP exception in the client
  script and would have printed a traceback rather than a count. Every count in this report was
  read off `meta.count` from a 200 response.
- **Semantic Scholar** (`api.semanticscholar.org/graph/v1/paper/search/bulk`). An empty set is
  HTTP 200 with `"total": 0`. Rate limiting arrives as HTTP 429 and was retried with backoff; the
  script prints `retry: <error>` on every failure and `S2_ERROR: exhausted retries` if all attempts
  fail, so a printed `S2_COUNT` is always a real response. I first tried the non-bulk
  `/paper/search` endpoint and hit sustained 429s; all reported S2 counts come from the bulk
  endpoint. Its `+` operator is conjunctive — verified by the control
  `"Kac-Moody" + "linear code"`, which returned 1 rather than the tens of thousands an OR would
  give.
- **zbMATH Open** (`api.zbmath.org/v1/document/_search`). An empty set is returned as HTTP **404**,
  not as a 200 with a zero count. This is a genuine trap and I calibrated it explicitly with
  control queries: `quantum code lattice` → 200, total 472; `quantum code root lattice` → 200,
  total 13; `Freudenthal triple system` → 200, total 84; `minuscule representation` → 200, total
  154; `root lattice code E8` → 404. Since near-identical query shapes give both 200-with-results
  and 404, I read 404 as "no documents matched", not as a malformed request. The earlier
  `zbmath.org` HTML endpoint returned HTTP 403 to WebFetch; the API is the reachable route.
- **Crossref** (`api.crossref.org/works`, `query.bibliographic`). **Crossref cannot enumerate a
  conjunctive set.** `query.bibliographic` is relevance ranking over an implicit OR, so its
  `total-results` is meaningless as a set size: `quantum error correcting codes from exceptional
  root systems E7 E8` reports 302,293 and `Freudenthal triple system quantum code minuscule
  representation` reports 4,817,699. **This is a reportable finding:** for keyword negatives of the
  kind this audit needs, Crossref licenses nothing, and the three-service requirement is discharged
  here by OpenAlex + Semantic Scholar + zbMATH, with Crossref used only for relevance screening and
  for resolving one DOI's metadata. Crossref screens were run over the top 12 titles of each of the
  two queries above; discriminator: *does the title combine an exceptional-Lie/Freudenthal/minuscule
  object with a code construction?* None did.
- **arXiv API** (`export.arxiv.org/api/query`). An empty set is a 200 Atom feed with
  `opensearch:totalResults = 0`. Caution recorded: my first three arXiv calls printed nothing
  because of a broken title regex over multi-line Atom `<title>` elements, not because the sets
  were empty; all arXiv counts in this report come from the corrected XML parser. A second caution:
  hyphenated phrases inside `abs:"…"` return 0 spuriously (`abs:"two-weight"` → 0 while
  `abs:"two weight codes"` → 47), so hyphenated phrase queries were avoided.
- **WebSearch / WebFetch.** Used for the Brouwer table rows, the codetables page, and open-web
  orientation. Not treated as an enumerating service anywhere.

### Sources named in this report, with read depth

| Source | Read depth |
|---|---|
| Calderbank & Kantor, *The Geometry of Two-Weight Codes*, Bull. London Math. Soc., 1986 | `full text` |
| Brouwer SRG table row (256,120,56,56), `aeb.win.tue.nl/graphs/srg/srgtab251-300.html` | `full text` (of the row) |
| Brouwer SRG table row (64,28,12,12), `aeb.win.tue.nl/graphs/srg/srgtab51-100.html` | `full text` (of the row) |
| codetables.de BKLC page, binary, n=240, k=10 | `full text` |
| Moorhouse, *The E8 Root Lattice and Conway's Ovoids* (handout, March 1991) | `partial` |
| Moorhouse, *Ovoids from the E8 root lattice*, Geom. Dedicata 46 (1993), 287–297 | `secondary only` |
| MacWilliams & Sloane ch. 14.5; Rothaus; Dillon (bent functions) | `secondary only` |
| Chakravarti, IMA Volumes chapter, DOI `10.1007/978-1-4613-8994-1_4` | `abstract/metadata only` |
| Brouwer, *Some new two-weight codes and strongly regular graphs*, zbMATH 3894975 | `abstract/metadata only` |
| Dymarsky & Shapere, *Quantum stabilizer codes, lattices, and CFTs*, arXiv:2009.01244 | `abstract/metadata only` |
| *Code construction and ensemble holography of simply-laced WZW models at level 1*, arXiv:2503.04055 | `abstract/metadata only` |
| *Freudenthal triple classification of three-qubit entanglement*, arXiv:0812.3322 | `abstract/metadata only` |
| *Perfect Codes for Generalized Deletions from Minuscule Elements of Weyl Groups*, arXiv:1810.09877 | `abstract/metadata only` |
| Three 2026 Zenodo depositions (D4-Octonion-Clifford; Phi-Floquet E8 Coxeter-Torus; G2(3) ternary code) | `abstract/metadata only` |
| *Proceedings on Moonshine and Related Topics*, DOI `10.1090/crmp/030` | `abstract/metadata only` |
| Rocky Mountain Discrete Math Days 2011 programme (S2 record, no DOI) | `abstract/metadata only` |
| Ten Deligne/Vogel exceptional-series arXiv items (2406.01348, 2403.14311, 2408.16560, 0402157, 2211.04270, 0107032, 2402.03637, 0610322, 0503151, 9703004) | `abstract/metadata only` |
| *Exceptional groups and del Pezzo surfaces*, arXiv:math/0009155 | `abstract/metadata only` |
| *Del Pezzo surfaces as Springer fibres for exceptional groups*, arXiv:1507.01872 | `abstract/metadata only` |
| Error Correction Zoo entry *Two-weight code*, `errorcorrectionzoo.org/c/two_weight` | `abstract/metadata only` |

**Access details for the two cached / hashed items.**

- Calderbank–Kantor: PDF fetched by `curl` from
  `https://darkwing.uoregon.edu/~kantor/PAPERS/2-WeightCodes.pdf` on 2026-08-05 and added to the
  shared literature cache. Cache key `10.1112/blms/18.2.97`; SHA-256
  `986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`; 26 pages, ~12,751 words
  extracted by poppler `pdftotext`. Version read: the author-hosted scan, which the search service
  and the Wiley/Oxford records agree corresponds to the 1986 Bulletin of the London Mathematical
  Society publication; I did NOT compare it page-for-page against the journal version, so any
  pagination-sensitive citation should be re-checked. Sections relied on: Example RT2 (nonsingular
  quadratic form on `GF(q)^k`, the count `|Ω| = (q^l − ε)(q^{l−1} + ε)`), the surrounding RT3/RT4
  discussion, and §12 (the difference-set and bent-function paragraph quoted in item 1). The OCR of
  displayed formulas in this scan is degraded and I relied on running text plus my own arithmetic
  where a display was unreadable; that arithmetic is flagged as my inference in item 1.
- Moorhouse handout: fetched by `curl` from `http://ericmoorhouse.org/handouts/conway.pdf`;
  SHA-256 `316a001f09c7fd77d56754c31745459f3bcac7fec35242f0f532858b213bf225`; extracted with
  poppler `pdftotext`. NOT added to the shared cache (no DOI or arXiv key; `litcache` keys on
  those), so the hash above is the only integrity record.

### Load-bearing queries, verbatim

Reproduced here so a later reader can re-run them. All of these were issued under the query-hygiene
constraint except where the "Query hygiene" section says otherwise.

OpenAlex (`filter=` parameter, verbatim):
```
title_and_abstract.search:("root system" AND "quantum code")            -> 7
title_and_abstract.search:("Freudenthal triple system" AND code)        -> 0
title_and_abstract.search:("Kac-Moody" AND "linear code")               -> 0
title_and_abstract.search:("affine root system" AND code)               -> 1
title_and_abstract.search:("minuscule representation" AND code)         -> 0
title_and_abstract.search:(bitangents AND "linear code")                -> 0
title_and_abstract.search:("27 lines" AND "binary code")                -> 0
title_and_abstract.search:("exceptional series" AND code)               -> 0
```

Semantic Scholar (`query=` parameter, bulk endpoint, verbatim):
```
"root system" + "quantum code"                -> 0
"Freudenthal triple system" + code            -> 0
"minuscule representation" + code             -> 0
bitangents + "linear code"                    -> 0
"exceptional series" + code                   -> 0
"Kac-Moody" + "linear code"                   -> 1
```

zbMATH Open (`search_string=` parameter, verbatim):
```
two-weight code quadric                       -> 2
bitangents plane quartic binary code          -> 1
quantum code root lattice                     -> 13   (all 13 screened, see item 6)
quantum code lattice                          -> 472  (control)
Freudenthal triple system                     -> 84   (control, not screened)
minuscule representation                      -> 154  (control, not screened)
quantum code root lattice E8                  -> 404 / empty
Freudenthal triple system code                -> 404 / empty
minuscule representation error-correcting code-> 404 / empty
Kac-Moody algebra error-correcting code       -> 404 / empty
quadric complement two-weight code GF(2)      -> 404 / empty
root lattice code E8                          -> 404 / empty
```

arXiv (`search_query=` parameter, verbatim):
```
abs:"two weight codes"                                  -> 47
cat:cs.IT AND abs:"quadric"                             -> 13
abs:"root lattice" AND abs:"code"                       -> 13
abs:"Freudenthal triple system"                         -> 36
abs:"Barnes-Wall" AND abs:"Clifford group"              -> 5
abs:"minuscule" AND abs:"code"                          -> 16
abs:"exceptional series" AND abs:"Lie"                  -> 20
abs:"Kac-Moody" AND abs:"error correcting"              -> 0
abs:"hyperbolic lattice" AND abs:"quantum code"         -> 0
abs:"bitangents" AND abs:"finite field"                 -> 0
abs:"E8 lattice" AND abs:"quantum"                      -> 1
abs:"affine root system" AND abs:"finite field"         -> 0
abs:"27 lines" AND abs:"cubic surface" AND abs:"code"   -> 0
```

Crossref (`query.bibliographic=`, relevance only, NOT enumerating):
```
exceptional Lie algebra error-correcting code                      -> 653,642 (top 8 screened)
quantum error correcting codes from exceptional root systems E7 E8 -> 302,293 (top 12 screened)
Freudenthal triple system quantum code minuscule representation    -> 4,817,699 (top 12 screened)
```

### Screened sets

1. **OpenAlex `("root system" AND "quantum code")`** — 7 records, provenance OpenAlex works API,
   screened over title + DOI host + year (not abstract; OpenAlex returned no abstracts in the
   requested field set). Discriminator: *does the title indicate a stabilizer or CSS code whose
   coordinates are a root-system point set?* Zero passed. Details in item 6.
2. **zbMATH `quantum code root lattice`** — 13 records, provenance zbMATH Open API, screened over
   title and year. Discriminator: *is this a code construction, as opposed to a conference
   proceedings volume or a lattice-cryptography paper?* Six passed as code-related, all in the
   code-CFT / Narain line; two were promoted to individual discussion in item 6
   (arXiv:2009.01244 and arXiv:2503.04055, whose zbMATH records are 7353057 and 8081118). The
   remaining seven are proceedings volumes (ISSAC 1992/1996/2013, SODA 2023, ACA 2015,
   Maximum-Entropy 1988) and lattice-cryptography papers.
3. **arXiv `abs:"exceptional series" AND abs:"Lie"`** — 20 records, provenance arXiv API,
   screened over title only. Discriminator: *does the title indicate coding theory or finite
   geometry rather than representation theory, VOAs, or quantum groups?* Zero passed.
4. **arXiv `abs:"Freudenthal triple system"`** — 36 records, provenance arXiv API, screened over
   the first 12 titles by relevance. Discriminator: *does the title indicate error-correcting
   codes?* Zero passed; the visible cluster is Jordan algebras, black holes, and qubit
   entanglement.
5. **arXiv `abs:"minuscule" AND abs:"code"`** — 16 records, provenance arXiv API, screened over
   the first 10 titles. Discriminator: *is "code" used in the coding-theory sense and "minuscule"
   in the representation-theory sense, in the same work?* One passed on the word level
   (arXiv:1810.09877) and was promoted and then dismissed in item 6(ii) — it concerns minuscule
   Weyl group elements and deletion-correcting codes, not minuscule representations.
6. **Crossref relevance screens** — three sets, top 8 / 12 / 12 titles respectively, screened over
   title only. Discriminators stated inline above. Zero passed in each.

## Coverage statement

### Searched and found nothing (licenses a negative)

- No work constructing an error-correcting code from the mod-2 reduction of an affine or hyperbolic
  Kac–Moody root lattice (OpenAlex, Semantic Scholar, zbMATH, arXiv; item 4a).
- No work constructing quantum codes from Freudenthal triple systems or from minuscule
  representations (OpenAlex, Semantic Scholar, zbMATH, arXiv; item 6ii).
- No work presenting an E6/E7/E8-indexed series of error-correcting codes, and in particular none
  in the Deligne/Vogel exceptional-series literature (OpenAlex, Semantic Scholar, arXiv; item 7).
- No work presenting the root-link antipodal fold as a code-level theorem (item 3), subject to the
  caveat that the negative rests on coding-theory vocabulary; a finite-geometry paper could state
  the same fact in orthogonal-geometry language that my queries would not surface.

### Could not access (licenses nothing; carried forward as open gaps)

- **MathSciNet — NOT COVERED.** Institutional authentication required; not attempted from this
  session. Every negative above retains "to our knowledge".
- **Google Scholar — NOT COVERED.** Blocks automated access; not attempted.
- **Chakravarti (1990), IMA Volumes chapter** — metadata only, full text not obtained. This is the
  most likely explicit predecessor for item 5's design statement and possibly for item 1's design
  framing. **Blocking gap for any manuscript claim about the 2-(120,56,55) design.**
- **Moorhouse, *Ovoids from the E8 root lattice*, Geom. Dedicata 46 (1993)** — not obtained; the
  1991 handout stood in for it. Its 1993 published form may state the mod-2 orthogonal-space
  identification more citably.
- **zbMATH via its HTML interface** — HTTP 403 to WebFetch. The JSON API was reachable and was used
  instead; zbMATH is therefore COVERED, but only through the API's search semantics, which I did not
  independently audit beyond the 404 calibration above.
- **Crossref as an enumerating service** — structurally unavailable (no boolean conjunction). The
  three-service requirement was discharged with zbMATH substituting.
- **codetables.de and MinT parameter-level priority checks** — deliberately NOT searched beyond the
  single `[240,10]` page fetched before the constraint. Per the query-hygiene constraint, parameter
  lookups would disclose unpublished tuples; the coordinator owns them. Recorded as
  *not searched: would disclose unpublished parameters.*
- **Whether the non-transitivity of the published `[[28,14,5]]` code is recorded anywhere** — same
  reason. Recorded as *not searched: would disclose unpublished parameters.* Item 6(iii) is
  `COULD NOT DETERMINE` on this basis.
- **Elkies' and Manin's del Pezzo / root-system work** — not reached at any depth beyond two arXiv
  titles surfaced by a search service. The del Pezzo side of item 7 is therefore thinner than the
  Lie-theory side.
- **The full-text of every source in the `abstract/metadata only` row block** — by construction.
  None of the verdicts above rests on the content of any of them beyond what the recorded title or
  abstract states.

## Incidental observations (candidate discovery-track entries)

Recorded here only; not written to the discovery track by this task.

1. **zbMATH Open's API answers an empty search with HTTP 404, not a zero count.** Provenance: this
   audit's control calibration, `api.zbmath.org/v1/document/_search`, 2026-08-05 — `root lattice
   code E8` → 404 while `quantum code root lattice` → 200 with 13 results. Any future audit script
   that treats non-200 as "service error" will silently convert real negatives into coverage gaps,
   or vice versa. Worth a line in the audit tooling notes.
2. **Crossref cannot discharge the three-service requirement for keyword negatives.** Provenance:
   this audit, `api.crossref.org/works?query.bibliographic=…`, three queries returning 653,642 /
   302,293 / 4,817,699 for conjunctions that OpenAlex and Semantic Scholar return 0 for. The
   conventions name Crossref as one of the three services; for *citing-set* enumeration it is fine,
   but for keyword conjunctions it has no boolean mode. Suggest the conventions distinguish the two
   uses.
3. **OpenAlex indexes 2026 Zenodo self-depositions that Semantic Scholar does not.** Provenance:
   `("root system" AND "quantum code")` → OpenAlex 7 (all Zenodo), Semantic Scholar 0. A "zero on
   S2" is therefore not evidence of absence in the grey-literature layer, and a nonzero OpenAlex
   count in an exotic area may be entirely self-published material.
4. **arXiv's `abs:"…"` phrase search returns 0 for hyphenated phrases.** Provenance: this audit —
   `abs:"two-weight"` → 0 versus `abs:"two weight codes"` → 47. A silent false negative generator
   for any audit touching hyphenated terminology (two-weight, self-dual, error-correcting).
5. **The code-CFT literature is a live adjacent field that the clebsch lane has not been tracking.**
   Provenance: arXiv:2009.01244 (Dymarsky–Shapere) and arXiv:2503.04055, both `abstract/metadata
   only` here. It connects stabilizer codes to root lattices via even self-dual Lorentzian lattices
   and to affine Lie algebras at level 1 via discriminant groups. Different carrier from ours, but
   it is the field most likely to contain a genuine pre-emption of anything in the E9/E10 direction,
   and it is where a referee from the physics side would look first.
