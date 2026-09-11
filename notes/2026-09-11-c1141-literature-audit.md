# C1141 — sharpness literature audit

**Lane:** cubic-threefolds. **Date:** 11 September 2026.

**Two external sources were read at full text.** This bounded audit completes
the recorded comparison and coverage work authorized after C1140, not an
exhaustive priority closure. MathSciNet, Google Scholar and Shepherd-Barron's
original chapter remain explicit access gaps. The owning claim–proof–novelty
ledger is `papers/cubic-stabilization-irrationality/LITERATURE.md`, rows N1–N4.
All novelty verdicts and the mathematical comparison belong there; this
report supplies their search provenance, access records and validation.

## Search and stop condition

Scope: uniform two-variable quartic del Pezzo rationalization; the displayed
three-parameter cubic family and pencil against existing symmetry/isogeny
families; arithmetic reduction and separation of first stabilizations.
Stop after the four pinned forward seeds, the topical queries below and
direct primary checks of the strongest adjacent candidates. No recursive
forward closure or classification of all subfamilies was attempted.

The frozen `2026-09-11-c1141-screen.json` enumerates every returned graph and
zbMATH title and web result URL. Its discriminator is recorded verbatim in
the file. Titles, identifiers and years were screened; supplied web snippets
were also read. Promotion targeted smooth cubic symmetry/isogeny families,
quartic del Pezzo stable rationalization bounds, and arithmetic isogeny
separation. Unpromoted title screens do not license full-text exclusions.

### Queries and service semantics

The four seeds are pinned by arXiv/DOI in `citation-query.py` and each raw
response records the exact URL, status and UTC time. The published order-five
DOI, 10.4310/PAMQ.2016.v12.n1.a5, was resolved from the successful zbMATH
metadata query; it is additionally queried in `vgy-published-citations.json`.
Initial 429s and Crossref 404s remain failures, never zeros. Successful
Semantic Scholar retries are frozen separately. Crossref's public API offers
counts but no citing list. The largest enumerable set for each seed was
screened, along with works unique to another graph.

| Seed | OpenAlex | Crossref | Semantic Scholar | Enumerated-set notes |
| --- | ---: | ---: | ---: | --- |
| TZ, arXiv:2608.20029 | 3 | 404, unregistered | 0 | Three own deposits; no independent confirmation. |
| Roulleau, DOI 10.1307/mmj/1310667979 | 12 | 7 | 16 | OA returned 13 rows, including a duplicate q-bic DOI. S2's 16-row list is largest and contains duplicate/variant records. |
| van Geemen–Yamauchi, arXiv DOI | 2 | 404, unregistered | Initial requests failed | Preprint OA list differs from published list. |
| Same, published DOI | 2 | 2 | 4 | S2 four rows represent three distinct titled works, with a duplicate singular-Prym record. |
| CMZ, DOI 10.1093/imrn/rnad113 | 1 | 0 | 2 | Both S2 rows screened; no inference from the Crossref zero alone. |

Raw graph metadata includes abstracts when supplied, but the full union is
only claimed as a title/identifier screen. Promoted depths are individually
recorded in the public ledger. There is no silent deduplication at query time.
The screen inventory retains service identities and aliases, so an index's
count mismatch cannot disappear into an aggregate total.

zbMATH Open: seven exact queries, 40 appearances, all returned (counts
1,1,1,10,8,18,1). Exact query strings and raw responses are in
`database-query.py` and `database-results.json`. Endpoint:
`https://api.zbmath.org/v1/document/_search`, `results_per_page=200`.
The status explicitly reports success and the total count. The title searches
resolve bibliography; no title search is used to select a citation-graph seed.

Web search: 24 exact queries in seven batches, 133 displayed appearances;
the two metadata/access batches are not counted as searches. Frozen output
is `web-results.json`; supplementary arXiv landing-page reads are in
`extra-web-results.json`.

```text
"cubic threefold" "stably rational" Tschinkel Zhang
"quartic del Pezzo" "two" "stably rational"
"cubic threefolds" "elliptic" "isogenous" Roulleau
"Fano surfaces with 12 or 30 elliptic curves" DOI
"On intermediate Jacobians" "five" DOI
"moduli space of cubic threefolds" "non-Eckardt" DOI
"Stably rational irrational varieties" Shepherd-Barron DOI
cubic threefold intermediate Jacobian "five elliptic" pencil
cubic threefold "Klein four" intermediate Jacobian
"cubic threefold" "V_4" "isogen"
"cubic threefold" "potential toric"
"cubic threefolds" "Hartlieb" automorphisms
"cubic threefold" "C2" "C2" elliptic
"cubic threefold" "isogenous" "pencil" elliptic
site.zbmath.org "Universal torsors over quartic"
site.zbmath.org "Fano surfaces with 12 or 30"
site.api.zbmath.org search documentation
"Genus 2 curve configurations on Fano surfaces" DOI
"Stably rational irrational varieties" Shepherd-Barron pdf
"quartic del Pezzo" "stabilization" "two"
"cubic threefolds" "nonisogenous"
"Shepherd-Barron" "693" "700" pdf
"Stably rational irrational varieties" filetype:pdf -site:researchgate.net
"Fano conference" "Shepherd" rational pdf
```

The search snippets also exposed a secondary book discussion of the
Shepherd-Barron slicing/rational-quotient idea. Read depth:
**abstract/metadata only** (search excerpt for Prokhorov–Shramov,
*Unramified Brauer Group and Its Applications*, §9.6); no primary attribution
or bibliographic particulars are inferred from it. It is a reason to avoid
an unsupported priority claim for the broad method, not proof of a precise
earlier theorem.

## Access and source bytes

Primary PDFs were accessed through the shared cache, with pdftotext reads at
the depths in the public ledger. The following are PDF hashes, not evidence
that unread pages were read. Generic cache keys may point to older pinned
preprint revisions; the ledger explicitly gives the actual version read.

| Cache key | SHA-256 |
| --- | --- |
| arXiv:2608.20029v2 | 4856b5b45325b56917df9c6d8c4a9341f13d7b9bf2628562c9fda0784ca07453 |
| arXiv:1001.4855 | 6cfe901586441afa6d875d17bd4c33c6675705d6658848e9b82b5bd5fbd77bec |
| arXiv:1304.4076 | 77df11128ab1456925c22a18ab969747c14ed6bbb3287052bce2a0a7c04e2aea |
| arXiv:1002.4467 | c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd |
| arXiv:0804.1861 | afc1e45e608aaad153251dd22f4f19f7d23aa082f0afb35a592d28a8ba2803b3 |
| arXiv:1506.05346 | f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed |
| arXiv:2304.03214 | 3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01 |
| arXiv:2210.14397 | 6a8ce41af47def059a90f987f65cdda22c9540357d23ba80bdccc2dc8b351874 |
| arXiv:2211.03397 | 5b947949feb6417fc35d8de13956cdb24ec61407b5d39344a1b571938ac5b0fb |
| arXiv:2106.08683 | 6058d121f53e12f5b1dbd4c015f1fb7a676bd255a341c076e8282e5fdc0718d8 |

The Roulleau Klein-four normal form was checked against rendered PDF page 13,
and van Geemen–Yamauchi Proposition 1.5 against rendered page 4,
not extraction alone. All ten listed cached PDF hashes were rechecked.
These are digital PDFs, not user-supplied OCR scans.
The reused companion and arithmetic theorem sources retain their byte pins
in the paper's imported-source registry and arithmetic verification report;
no fresh full-text read is credited for reuse. The current audit does not
revalidate the companion's comparison lemmas or its formal artifact.

MathSciNet redirected to institutional authentication; Google Scholar access
failed. Both are **NOT COVERED**. Shepherd-Barron's original eight-page
chapter was not obtained through the title/author/PDF searches. Its
zbMATH record 2135213 and Moroz review were accessed successfully. A review
statement is attributed to that reviewer and remains unverified against the
chapter. No inaccessible query supplies a negative.

## Reproduction and trust boundary

From the repository root:

```sh
python3 notes/2026-09-11-c1141-citation-query.py
python3 notes/2026-09-11-c1141-database-query.py
python3 notes/2026-09-11-c1141-screen.py
```

The first two commands refetch live services and will not reproduce frozen
counts indefinitely. `screen.py` is the offline replay against the committed
JSON inputs and emits the compact inventory and SHA-256 manifest. The
supplementary published-DOI query uses `query(('vanGeemenYamauchi-published',
'1506.05346','10.4310/PAMQ.2016.v12.n1.a5'))` from `citation-query.py`.
The final S2 retry uses the exact request URL and subsequent citations URL
stored in `vgy-s2-retry.json`. Web queries are replayable as strings above;
their displayed snippets are a frozen observation, not a stable API.

The screen generator organizes observations; it cannot certify a novelty
negative. There is no independent implementation of the search recorder.
Cross-service query independence is the triangulation check, and the
mathematical family comparison is a written argument, not a computational
certificate or a new Lean-coverage claim.

## Propagation and completion gate

Pending at the initial evidence checkpoint: add concise manuscript credit
for the Klein-four ambient family; point README, reviewer guide, public
summary and results snapshot at the owning ledger; mark the old source
ledger historical. Preserve abstract, theorem statements and AI disclosure.
Run the existing paper gate, export the committed authority, verify and
commit the complete export including PROVENANCE.md, and refresh the summary
mirror. Record final identities in the completion section below.

## Mystery ledger

The bounded comparison settles the apparent possibility that the pencil
is merely a reparametrization of the specific elliptic-product/order-five
families: ledger N3 gives a rank-three obstruction. It also identifies the
known ambient symmetry locus, so that locus is not a new contribution.
Still open: complete placement among *all* subfamilies of the known
Klein-four locus; this would require a separate moduli/classification task,
not a stronger title-screen negative. Original-source access to
Shepherd-Barron and MathSciNet coverage are literature gaps, not new
mathematical conjectures.

After the successful paper gate, the explicit **ej+tt** closeout asked
whether the separation really needed squarefreeness and whether ambient
symmetry was being mistaken for novelty. The first exclusion uses only
positive integral n prime to six, as now stated in the owning ledger;
squarefreeness is needed for the pairwise density/separation theorem, not
this prior-family exclusion. The coordinate comparison settles the second
question. No extra theorem or new assumption is needed, and no incidental
discovery-log entry is warranted: both questions were task-owned.

## Process defects

One guessed zbMATH identifier was rejected and supplied no evidence; the
actual Roulleau identifier was then resolved through the title API query.
Some citation-title output exceeded the intended 20-line display bound;
the retained raw JSON and offline compact inventory replace those displays.
An attempted read of a nonexistent verification/README.md was corrected
by using the paper's actual README and Makefile. No failed request is
represented as a successful empty result.
