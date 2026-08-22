# C909 — authenticated-access closure packet for the cycle literature audit

Date: 2026-08-12

Status: operational literature-closure plan plus an independent zbMATH Open
check.  No manuscript, bibliography, PDF, mirror, or Lean file was changed.

## Opening record and boundary

**New full-text count: 0.**  This is an access packet, not a second reading
of the source corpus.  It reuses the exact read records in
[`2026-08-12-c909-epilogue-cycle-priority-audit.md`](2026-08-12-c909-epilogue-cycle-priority-audit.md)
and the source-specific audits it names.  The named seeds below carry those
records; no characterization is inferred from a Scholar snippet or a
citation count.

The task is to close the bounded priority posture for three distinct claims,
not to prove that no predecessor exists.

* **A — marked finite-etale PD saturation:** the signed integral DVR lift
  from the exact graph coefficient lattice to all ordinary divisor products
  of its divided-power envelope.
* **B — actual six-axis rank-five equality:** the non-CM six-axis packet has
  full ambient integral Hodge/product equality in every degree.
* **C — equal-depth distinct-root sharpness:** the rank-five exact middle
  quotient is two copies of ((\mathbf Z/p^a)^5), related by theta
  complement.

The authenticated Scholar pass must preserve the distinction `PD(NS)=P`
from ambient `Hdg=P`, and must never convert a rational, Chow, or
integral-Fourier result into an ordinary integral divisor-product result.

## Pinned seeds and Scholar cited-by closures

Resolve every seed once by the identifier in the table, verify the title,
authors, venue/year, and identifier against the displayed Scholar record,
then freeze the **Scholar cluster ID** (`cites=<cluster-id>`) and use that
literal cited-by URL for export.  Do not perform cited-by closure by a title
search after the initial resolution.  The column headed “exact initial query”
is the query to enter while authenticated; selecting a record whose fields do
not match the expected seed is a hard stop, not a near match.

| Claims | Pinned seed expected on Scholar | Exact initial query | Required cited-by sweep |
|---|---|---|---|
| A, C | J. S. Milne, *Lefschetz classes on abelian varieties*, DOI `10.1215/S0012-7094-99-09620-5` | `"Lefschetz classes on abelian varieties" "10.1215/S0012-7094-99-09620-5"` | Screen every cited item for `integral`, `lattice`, `index`, `torsion`, `elliptic`, `isogeny`, `divisor`, `Lefschetz`, `Hodge`; promote any apparent integral-lattice theorem. |
| A, C | J. Yu, *The tropical positive semidefinite cone*, arXiv `1309.6011` | `"The tropical positive semidefinite cone" "1309.6011"` | Screen every cited item for `integral`, `DVR`, `valuation`, `lattice`, `rank one`, `symmetric`, `Smith`, `semigroup`; retain only work that could upgrade the tropical cone to an additive integral theorem. |
| A, C | B. Moonen and A. Polishchuk, *Divided powers in Chow rings and integral Fourier transforms*, DOI `10.1016/j.aim.2009.12.025`, arXiv `0904.3995` | `"Divided powers in Chow rings and integral Fourier transforms" "10.1016/j.aim.2009.12.025"` | Screen for `ordinary product`, `integral cohomology`, `divisor`, `minimal class`, `isogeny`, `Neron-Severi`; separate Chow or etale-divided-power results from ordinary cohomology. |
| A, B, C | T. Beckmann and O. de Gaay Fortman, *Integral Fourier transforms and the integral Hodge conjecture for one-cycles on abelian varieties*, DOI `10.1112/S0010437X23007133`, arXiv `2202.05230` | `"Integral Fourier transforms and the integral Hodge conjecture for one-cycles on abelian varieties" "10.1112/S0010437X23007133"` | Screen all citations for `product of divisors`, `elliptic power`, `isogeny`, `integral Hodge`, `minimal class`, `Fourier`; this is the most likely modern bridge but its cited-by set must not be treated as exhaustive until exported. |
| A | C. De Concini, D. Eisenbud, C. Procesi, *Hodge algebras*, zbMATH `Zbl 0509.13026` (no DOI used here) | `"Hodge algebras" "De Concini" Eisenbud Procesi 1982` | Do **not** screen its entire broad citing set by hand.  Use the scoped content queries below and screen cited-by hits returned by those queries for weighted/integral/Plücker/Smith language; this seed is an unweighted standard-monomial predecessor only. |
| A, C | S. Abdulali, *Abelian varieties and the general Hodge conjecture*, DOI `10.1023/A:1000274922979` | `"Abelian varieties and the general Hodge conjecture" "10.1023/A:1000274922979"` | Screen for `integral`, `elliptic product`, `divisor-generated`, `isogeny`, `Hodge ring`; its present role is rational Hodge-ring generation. |
| B | X. Roulleau, *The Fano surface of the Klein cubic threefold*, arXiv `1002.4467` | `"The Fano surface of the Klein cubic threefold" "1002.4467"` | Screen for `intermediate Jacobian`, `elliptic curve`, `isogeny`, `polarization`, `A5`, `integral`; promote only papers that actually calculate the six-axis/period lattice. |
| B | M. Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of cubic threefolds*, arXiv `2304.03214` | `"Special subvarieties in the locus of intermediate Jacobians of cubic threefolds" "2304.03214"` | Screen for `A5`, `Klein`, `elliptic`, `isogeny`, `polarization`, `integral Hodge`; this closes the period-locus, not the weighted Hodge/product calculation. |
| A, B | J. Jordan, A. Keeton, B. Poonen, E. Rains, N. Shepherd-Barron, J. Tate, *Abelian varieties isogenous to a power of an elliptic curve*, DOI `10.1112/S0010437X17007990`, arXiv `1602.06237` | `"Abelian varieties isogenous to a power of an elliptic curve" "10.1112/S0010437X17007990"` | Screen for `principal polarization`, `Neron-Severi`, `integral Hodge`, `divisor product`, `finite etale`; it is a kernel/module-presentation boundary check. |

For each seed, the authenticated operator must save:

1. the initial seed-result screenshot or HTML/PDF print containing title,
   authors, year, venue, link(s), and cited-by count;
2. the literal Scholar cited-by URL with the resolved cluster ID, retrieval
   date/time, displayed total, and every query/filter used;
3. a BibTeX or RIS export for the seed and for **every** citing result, plus
   CSV/JSON/TSV if the institution’s Scholar workflow provides it;
4. for each citing result, title, authors, year, venue, displayed snippet,
   direct URL, DOI/arXiv/Zbl/MathSciNet identifier if present, Scholar
   cluster ID, and a triage disposition (`exclude`, `background`,
   `promote`), with the exact discriminator above; and
5. pagination evidence that the highest displayed result was reached, or a
   recorded service/rate-limit failure.  A partial Scholar list cannot be
   called an exhaustive cited-by screen.

After the Scholar export, reproduce the count and take the **largest** of the
three independently resolved cited-by sets from OpenAlex, Crossref, and
Semantic Scholar, as required by the literature conventions.  Resolve those
three services by DOI/arXiv, never title.  Record their counts separately;
an API error is not an empty result.  Only then may the resulting union/largest
set support a forward-citation negative.

## Exact Scholar content queries, by claim

Run these separately from cited-by closure.  Save the first result page and
record its displayed result total, date, and every title/abstract/snippet
screened.  The quoted strings are intentional; do not silently remove
accents or the word `integral` when a query is sparse.

### A — marked finite-etale graph saturation

```text
"finite étale" "Néron-Severi" graph isogeny
"finite etale" self-adjoint graph "abelian variety"
"ordinary products of divisor classes" integral "abelian varieties"
"divided powers" "ordinary products" "abelian varieties"
"rank one" symmetric lattice DVR integral
"integral Lefschetz" "elliptic curves" isogeny
```

Screen title/abstract/snippet for all of
`finite etale|étale|graph|self-adjoint|isogeny` and at least one of
`integral|lattice|index|torsion|ordinary product|divisor product`.  A hit that
only proves rational divisor generation, Chow divided powers, tropical cone
membership, or abstract local-form classification is `background`, not a
predecessor.

### B — six-axis packet

```text
"6I_5-J_5" polarization
"six-axis" "intermediate Jacobian"
"Klein cubic" "E^5" polarization
"Klein cubic" "integral Hodge" "intermediate Jacobian"
"A5" "intermediate Jacobian" elliptic isogeny polarization
```

Screen for the conjunction of the six-axis (or an equivalent explicitly
identified geometric packet) **and** an integral Hodge/product statement.
Period-locus or Fano-surface sources without the integral product lattice are
geometry background only.

### C — rank-five distinct-root Smith quotient

```text
"integral Hodge lattice" "product of elliptic curves" "divisor classes"
"Smith normal form" Plücker "Hodge classes"
"integral Lefschetz classes" "elliptic curve"
"isogenous to a power of an elliptic curve" "integral Hodge"
"finite etale" "Plücker" lattice
```

Screen for an **explicit finite integral quotient** of ordinary products in
the Hodge lattice, particularly an isogeny- or valuation-weighted quotient.
The exact pattern to flag is `rank 5`, `four-slot`, `five supports`,
`p^a`, `Smith`, or a theta/Poincaré complement.  A generic integral Hodge
conjecture paper is only a candidate until it computes that smaller product
lattice.

## Independent zbMATH Open check performed now

Access: direct HTTPS requests to `https://zbmath.org/` on 2026-08-12; all
listed title queries returned HTTP 200.  This is a **review/metadata screen**,
not a full-text reading of any primary paper, and no cache SHA applies to the
HTML result pages.  The exact direct query syntax and outcomes were:

| Exact zbMATH query | Outcome | Scope consequence |
|---|---|---|
| `ti:"Lefschetz classes on abelian varieties"` | Record `Zbl 0976.14009`, with the Duke source, DOI, a review abstract, and 17 references recorded by zbMATH | Confirms the rational divisor-algebra framing; no integral product-lattice conclusion was read from the review. |
| `ti:"Hodge algebras" au:De Concini` | Record `Zbl 0509.13026` for De Concini--Eisenbud--Procesi and `Zbl 0514.13008` for the survey | Confirms the standard-monomial landmark; no weighted DVR claim arises from this metadata screen. |
| `ti:"Integral Fourier transforms and the integral Hodge conjecture for one-cycles on abelian varieties"` | Record `Zbl 1519.14005`, source and DOI `10.1112/S0010437X23007133` | Confirms the published modern integral-Fourier seed. |
| `ti:"Divided powers in Chow rings and integral Fourier transforms"` | Record `Zbl 1236.14007`, DOI `10.1016/j.aim.2009.12.025` | Confirms the published Moonen--Polishchuk seed. |
| `ti:"The Fano surface of the Klein cubic threefold"` | Record `Zbl 1207.14045` | Confirms the Roulleau geometry seed. |
| `ti:"Abelian varieties and the general Hodge conjecture"` | Records `Zbl 0891.14003` and `Zbl 0871.14009`; the first contains the DOI `10.1023/A:1000274922979` | Confirms the Abdulali rational-Hodge seed, but the duplicate-title records must be resolved by DOI/authors before use. |
| `ti:"The tropical positive semidefinite cone"` and `au:Yu ti:tropical ti:positive ti:semidefinite` | Both returned “Your query produced no results” | This is an index/search result only.  It is neither a negative about Yu’s paper nor a reason to omit the arXiv-pinned Scholar seed. |

The review entries themselves were not used as substitutes for primary
sources.  For the sources named here, the inherited primary-source records
are:

| Source | Read depth / access / version / cache SHA |
|---|---|
| De Concini--Eisenbud--Procesi, *Hodge algebras* | **full text**; Numdam scan, Astérisque 91 (1982), all 88 pages; key `AST_1982__91__1_0`; SHA-256 `fa857ea1c610f15d008f49e2b99966454ba4892b0a4d9bf34903e27731b8425f`. |
| Yu, *The tropical positive semidefinite cone* | **full text**; arXiv `1309.6011v1`, all 5 pages; key `arXiv:1309.6011`; SHA-256 `ed4e28307e5ac1815d3f391118a7a37548a4a8df070cd2aefec0bef49b6faea6`. |
| Milne, *Lefschetz classes on abelian varieties* | **partial**; author-hosted published Duke PDF, Introduction and Theorem 3.2 passage; key `10.1215/S0012-7094-99-09620-5`; SHA-256 `28ae245e58748438b7070680cac83f8b2f695c43f1643b59cde21eb94077fe53`. |
| Moonen--Polishchuk, *Divided powers in Chow rings and integral Fourier transforms* | **partial**; arXiv `0904.3995v1`, Introduction and Section 3; key `arXiv:0904.3995`; SHA-256 `ecb7b3882c96609b1c66f8012fd1adc9dd61a82c936c7fbecd17f097192007c4`. |
| Beckmann--de Gaay Fortman, *Integral Fourier transforms and the integral Hodge conjecture for one-cycles on abelian varieties* | **partial**; arXiv `2202.05230v2`, abstract, Introduction, Theorem 1.1, Theorem 3.8, Corollary 4.1; key `arXiv:2202.05230`; SHA-256 `ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc`. |
| Abdulali, *Abelian varieties and the general Hodge conjecture* | **partial**; published Cambridge Core PDF, Section 6/Theorem 6.1; key `10.1023/A:1000274922979`; SHA-256 `1030a2fbb7bec22616bd68ab72565271209ee79dfd39744e010a32a57eda48a2`. |
| Roulleau, *The Fano surface of the Klein cubic threefold* | **partial**; arXiv `1002.4467v1`, Introduction and Section 3.2/Theorem 11; key `arXiv:1002.4467`; SHA-256 `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`. |
| Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of cubic threefolds* | **partial**; arXiv `2304.03214v2`, Section 5.3, Lemma 5.5, Proposition 5.7, Remark 5.8; key `arXiv:2304.03214`; SHA-256 `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`. |
| Jordan--Keeton--Poonen--Rains--Shepherd-Barron--Tate, *Abelian varieties isogenous to a power of an elliptic curve* | **partial**; arXiv `1602.06237`, Introduction, Sections 4, 6.1--6.4, 7.1; key `arXiv:1602.06237`; SHA-256 `f3f0c86dac44d106d5f52a7709ec423e84aeed849c7055f1a127d9bd298a8e3f`. |

## Paywalled full-text targets, including the DeepDyve check list

No DeepDyve holding was tested in this agent session.  The following are
**DOI-pinned retrieval candidates**, not assertions that DeepDyve carries
them.  An authenticated operator should first search the exact DOI/title in
DeepDyve, then use the publisher, JSTOR, Cambridge, or an interlibrary route
if it is absent.  A successful download must enter the literature cache before
it is cited.

| Priority | Target and identifier | Why a full text could be load-bearing | Present access status |
|---|---|---|---|
| Conditional, outside the A--C proof as currently formulated | R. Jacobowitz, *Hermitian forms over local fields*, DOI `10.2307/2372982` | Needed only if a manuscript restores the dyadic integral trace-transfer/hyperbolic-form classification rather than using the direct finite-etale graph proof.  Read the integral/dyadic classification passages, not merely determinant facts. | **abstract/metadata only**: JSTOR/Cambridge metadata and a later reference list were consulted in the earlier C909 audit; no cached primary text or SHA. |
| Conditional, C predecessor screen | B. Moonen and Yu. G. Zarhin, *Hodge classes on abelian varieties of low dimension*, DOI `10.1007/s002090050326` | A cited-by or content hit might force a check of its low-dimensional integral versus rational boundary.  Its title alone does not establish relevance to ordinary product indices. | **abstract/metadata only** in the inherited source ledger; no cached primary text or SHA. |
| Low priority/version verification only | Milne, DOI `10.1215/S0012-7094-99-09620-5` | The author-hosted published PDF already supports the current rational-boundary reading.  Obtain a publisher/DeepDyve copy only if a material version difference is alleged by a citing work. | **partial primary text** already cached; not a current access gate. |
| Low priority/version verification only | Abdulali, DOI `10.1023/A:1000274922979` | The Cambridge Core PDF already supports the rational elliptic-product statement.  Retrieve another authenticated copy only if the Scholar sweep identifies an integral refinement in the published context. | **partial primary text** already cached; not a current access gate. |

Thus the only plausibly necessary DeepDyve-style full-text reads are
Jacobowitz (if the abandoned dyadic trace-transfer branch re-enters) and
Moonen--Zarhin (if the scholar screen promotes it).  Neither should delay
claims (A)--(C) as presently and correctly stated: (A) is trace-free, while
(B)--(C) rest on direct rank-five lattice calculations.

## Closure acceptance test and open gaps

The audit may be upgraded only after all of the following are saved in a
dated follow-up report:

1. Scholar seeded cited-by lists and exports for all nine pinned seeds above;
2. OpenAlex, Crossref, and Semantic Scholar counts, identifier resolutions,
   and the largest-set screen for every seed on which a forward negative
   relies;
3. a per-result triage ledger with promoted papers read at a declared depth;
4. separate records for no-result, login/rate-limit, and API-error outcomes;
   and
5. a refreshed ledger row in
   `papers/cubic-stabilization-m1/claim-proof-novelty-ledger.md` before
   any broadening of public priority wording.

**MathSciNet remains NOT COVERED.**  This authenticated packet reduces the
Scholar/forward-citation gap but cannot by itself justify a global priority or
``first'' sentence.  It does permit a later, accurately bounded sentence:
“no exact predecessor was located in the recorded source and cited-by
screens,” provided that sentence lives only in the paper’s claim ledger.

## Handoff

`go C909 clebsch authenticated closure packet ready: seed by identifier,
freeze Scholar clusters, export every result, then triple-check forward sets;
zbMATH is accessible but is review/metadata support only.`
