# C912 WP10 — forward-citation sweep for the cubic-stabilization epilogue

Date: 2026-08-14. Bound by `notes/literature-audit-conventions.md`. The verdict
text this licenses lives in
`papers/cubic-stabilization-m1/claim-proof-novelty-ledger.md`; this file
is the search record.

## Purpose

Three pre-emptions of the paper's cycle-side framing surfaced on one day from a
single external prompt. This sweep closes the forward trees of the principal
sources so that the remaining claims rest on a recorded search rather than on
absence of a chance encounter.

Two screening targets throughout:

1. further constructions of universally `CH_0`-trivial smooth cubic
   threefolds, by any mechanism;
2. any statement about rationality or irrationality of a cubic threefold times
   a projective space.

## Seeds and resolved identifiers

Every seed was pinned by arXiv identifier and resolved to a published
identifier through identifier-based lookups, never by title search at query
time. The Colliot-Thélène journal record is the one exception: no service maps
its arXiv identifier to a DOI, so it was found by a Crossref bibliographic
query and accepted only after title, journal, year, and page range all matched
the bibliography entry.

| Seed | arXiv | Resolved | How resolved |
|---|---|---|---|
| Voisin | 1407.7261 | `10.4171/JEMS/702`, J. Eur. Math. Soc. | Semantic Scholar arXiv-to-DOI mapping |
| Colliot-Thélène | 1607.05673 | `10.14231/ag-2017-029`, Algebraic Geometry 2017, 597–602 | Crossref bibliographic query, verified on title, container, year, pages |
| Hartlieb | 2304.03214 | `10.1007/s00209-025-03745-3`, Math. Z. | Semantic Scholar arXiv-to-DOI mapping |
| Wei–Yu | 1907.00392 | OpenAlex `W1727206468` | OpenAlex arXiv-DOI record |
| Yang–Yu–Zhu | 2508.03623 | OpenAlex `W7077053026`, no journal DOI | OpenAlex arXiv-DOI record |
| Engel–de Gaay Fortman–Schreieder | 2507.15704 | OpenAlex `W4417438133`, no journal DOI | OpenAlex arXiv-DOI record |
| Cai | 2608.01577 | OpenAlex `W7172418083`, no journal DOI | OpenAlex arXiv-DOI record |
| Katzarkov–Kontsevich–Pantev–Yu | 2508.05105 | OpenAlex `W6967543441`, no journal DOI | OpenAlex arXiv-DOI record |

Note on a trap avoided: the arXiv-DOI record and the journal record are
distinct works in OpenAlex, with different citation counts. Querying the
arXiv-DOI record alone would have reported Voisin as having one citation.

## Counts, per service, recorded separately

| Seed | Semantic Scholar | Crossref | OpenAlex |
|---|---|---|---|
| Voisin | 71 (on the arXiv record) | 27 (on `10.4171/JEMS/702`) | 9 (on the journal work `W147232585`) |
| Colliot-Thélène | 8 | 1 and 2 on two duplicate DOI records | 1 (arXiv record) |
| Wei–Yu | 21 | not indexed | 4 |
| Katzarkov–Kontsevich–Pantev–Yu | 23 | not indexed | 0 |
| Engel–de Gaay Fortman–Schreieder | 14 | not indexed | 0 |
| Hartlieb | 0 | 0 | 0 |
| Yang–Yu–Zhu | 0 | not indexed | 0 |
| Cai | 0 | not indexed | 0 |

**The disagreement is itself a finding.** For Voisin the three services report
71, 27, and 9. Crossref counts only deposited reference lists, and OpenAlex
splits the preprint and journal records, so both undercount badly here. The
largest set, Semantic Scholar's 71, was the one screened. Anyone repeating this
audit on OpenAlex alone would see a ninefold smaller forward tree and could
conclude the field is far quieter than it is.

## Screened sets

Provenance: Semantic Scholar `/paper/arXiv:<id>/citations`, fields
`title,year,venue,externalIds`, paged at 100. Screening ran over the title
field only; abstracts were read for promoted members. Raw records were saved
per seed. "Screened" is not a read depth: the set record below is what covers
the non-promoted members.

Verbatim discriminator, applied case-insensitively:

    (universal\w*\s+CH_?0|CH_?0[- ]trivial|decomposition of the diagonal|
     unirational|coprime degree|stably? rational|stable rationality|
     cubic threefold|intermediate jacobian|minimal class)

| Seed | Set size | Screen hits |
|---|---|---|
| Voisin | 71 | 13 |
| Colliot-Thélène | 8 | 1 |
| Wei–Yu | 21 | 2 |
| Katzarkov–Kontsevich–Pantev–Yu | 23 | 1 |
| Engel–de Gaay Fortman–Schreieder | 14 | 2 |
| Hartlieb, Yang–Yu–Zhu, Cai | 0 | 0 |

The union of the hits, after removing duplicates and works already cited by the
manuscript, is small. Everything in it was resolved to one of the following.

### Already known to the manuscript

Yang–Yu–Zhu; Voisin's own earlier unirational-threefolds paper; the
Engel–de Gaay Fortman–Schreieder evenness theorem; Hartlieb.

### Promoted for individual reading

- **Banerjee, "Universal codimension two cycle on a very general cubic
  threefold", arXiv:2509.06013 (7 September 2025). Read depth: abstract.**
  Abstract verbatim: "In this paper, we prove that a very general cubic
  threefold does not admit a universal codimension-two cycle and hence is
  stably irrational." This is a negative result about the very general member;
  it constructs no universally `CH_0`-trivial cubic threefold and does not
  bear on a product with a projective space. It overlaps in conclusion with
  Engel–de Gaay Fortman–Schreieder Corollary 1.4, which the manuscript already
  cites. No action beyond this record.
- **Kresch–Tanimoto–Tschinkel, "Intermediate Jacobians and Burnside
  invariants", arXiv:2511.07101 (10 November 2025, revised 23 December 2025).
  Read depth: abstract.** Proposes equivariant birational invariants combining
  equivariant intermediate Jacobians with the Burnside formalism for
  rationally connected threefolds. Neither target.
- **"Stable rationality in smooth families of threefolds", arXiv:1802.06107.
  Read depth: abstract.** Families with both stably rational and non stably
  rational fibres. No cubic-threefold construction.
- **"Prelog Chow groups of self-products of degenerations of cubic
  threefolds", arXiv:1912.05363. Read depth: abstract.** Its own abstract
  states that whether smooth cubic threefolds admit a decomposition of the
  diagonal, or are stably rational, "is unknown ... in general", and it
  computes a prelog Chow group of one degeneration. No construction.
- **"Moduli spaces of 6 x 6 skew matrices of linear forms on P^4 ...",
  arXiv:2212.07235. Read depth: abstract.** Pfaffian representations and their
  compactification. Neither target.
- **"On the universal CH_0 group of cubic threefolds in positive
  characteristic", arXiv:1602.06767. Read depth: title and venue only.**
  Positive characteristic; the manuscript's statements are over the complex
  numbers. Recorded, not promoted further.

## Independent modality: topical search

Citation graphs miss work that does not cite the seeds, so four OpenAlex
keyword searches were run as a separate modality: "universally CH0 trivial
cubic threefold" (14 results), "cubic threefold decomposition of the diagonal"
(2925), "unirational parametrizations coprime degrees" (88), "cubic threefold
stably rational" (3661). The first twelve of each were screened by eye. They
surfaced nothing outside the forward trees.

zbMATH Open, which the conventions record as freely reachable, was queried
through its documented API endpoint `/v1/document/_search`. Its behaviour must
be recorded carefully: it answers a query with no matches by HTTP 404, not by
an empty result list, so a 404 here is a searched-and-found-nothing outcome
rather than an error. Results:

- "cubic threefold universally CH_0-trivial": 404, no matches;
- "cubic hypersurface universal CH_0 group": 404, no matches;
- "cubic threefold decomposition of the diagonal": 2 matches, both already
  seen (the 2013 Abel-Jacobi paper and the 2022 prelog Chow paper);
- "unirational parametrizations of coprime degrees": 1 match, Yang–Yu–Zhu.

The zbMATH web interface at `zbmath.org` returned HTTP 403 to automated
fetches; only the API was usable.

## Incidental

OpenAlex holds four separate records for this manuscript itself, all titled
"Irrationality after one stabilization of universally CH0-trivial cubic
threefolds" and dated 2026. Duplicate indexing of the released versions is
worth knowing about before any future priority or citation claim is made from
OpenAlex counts.

## Coverage statement

Searched and found nothing further:

- the forward trees of all eight seeds, in Semantic Scholar, with the largest
  set screened and the per-service counts recorded above;
- four OpenAlex topical searches;
- four zbMATH Open API queries.

Could not access, and therefore licenses nothing:

- **MathSciNet: NOT COVERED.** It needs institutional authentication, which is
  unavailable from this session. Every claim it would have gated stays at the
  weaker strength.
- **zbMATH web interface: NOT COVERED** (HTTP 403); the API was used instead.
- **Google Scholar: NOT COVERED**; it blocks automated access.
- The survey chapter "Birational Invariants and Decomposition of the Diagonal"
  (2019) appeared in the Voisin screen and is behind a publisher paywall. A
  survey of exactly this area is the most likely place for a construction the
  citation graph would otherwise hide, so this one is a real gap rather than a
  formality.

## What the sweep licenses

The sweep found no construction of universally `CH_0`-trivial smooth cubic
threefolds beyond the three the manuscript already cites, and no statement
about a cubic threefold times a projective space. The paper's current
positioning is therefore consistent with the recorded search: it claims the
one-step irrationality theorem as its own, presents the `CH_0` loci as
imported, and makes no first-example claim.

It does not license an unqualified "to our knowledge" sentence, because
MathSciNet and the survey chapter remain uncovered. Keep the manuscript's
existing practice of stating what is proved and citing the sources by name.
