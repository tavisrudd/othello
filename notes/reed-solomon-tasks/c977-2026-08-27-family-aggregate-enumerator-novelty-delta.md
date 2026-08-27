# C977 family-aggregate NMDS enumerator novelty delta

**Date:** 2026-08-27

## Opening summary

This is a claim-specific delta to
`c975-2026-08-26-full-literature-audit.md`, whose exact audited Claim 5 is the
three family-wise minimum-support sums followed by the NMDS recurrence.  That
audit read seven sources at `full text`, eight at `partial`, and one at
`abstract/metadata only`.  This delta adds no newly promoted source and does
not upgrade any read depth.

**Verdict.**  The newly printed closed family-aggregate formula is not a new
independent mathematical ingredient.  The paper-owned input is the triple of
configuration-free incidence sums (B_{\mathcal F}), which was not located as
a published formula within the combined C975/C977 search boundary.  The
one-parameter NMDS recurrence is prior art, and summing it over a family is a
formal linearity step.  The manuscript should present the result as a derived
enumerative consequence, without a priority adjective.

## Exact object and novelty decomposition

For each of the tangent, conjugate-secant, and deleted-point-incident
split-secant families (\mathcal F), put

\[
 M_{\mathcal F}=|\mathcal F|,
 \qquad
 B_{\mathcal F}=\sum_{[f]\in\mathcal F}\mu_S(f).
\]

C975 audited the three displayed formulas for (B_{\mathcal F}).  C977 now
prints the consequence

\[
 \mathcal A_{r+i}^{\mathcal F}
 =M_{\mathcal F}\binom{L}{K-i}
   \sum_{j=0}^{i-1}(-1)^j\binom{r+i}{j}(q^{i-j}-1)
  +(-1)^i\binom Ki(q-1)B_{\mathcal F}.
\]

The ownership boundary is:

1. **Family-incidence totals (B_{\mathcal F}):** not located as published
   formulas in the recorded boundary; these are elementary double counts made
   possible by the paper's shell classification.
2. **Individual NMDS recurrence:** prior art.  Meneghetti--Pellegrini--Sala,
   Theorem 10, prints the recurrence and attributes its first proof to
   Dodunekov--Landgev (1995).
3. **Family-aggregate closed form:** direct summation of item 2 using item 1;
   a useful explicit corollary, not a separate proof idea or priority claim.
4. **Family averages:** division by (M_{\mathcal F}) when the family is
   nonempty; no claim that individual members have equal weight distributions.

## Focused delta search

On 2026-08-27 a general-web discovery screen, including indexed arXiv records,
used the following verbatim queries:

- `"family-aggregate" NMDS weight enumerator Reed Solomon`
- `"minimum supports" NMDS Reed Solomon weight distribution`
- `tangent conjugate secant NMDS code weight distribution Reed Solomon`
- `coset weight distributions generalized doubly extended Reed Solomon tangent`
- `"conjugate-secant" "weight enumerator" code`
- `"split-secant" NMDS Reed Solomon`
- `"tangent" "conjugate secant" coset weight distribution`
- `"family-average" NMDS weight enumerator`

This was a bounded title/abstract/metadata screen, not an exhaustive database
negative.  The relevant results were already in the C975 audited set:
Davydov--Marcugini--Pambianco's codimension-four coset distributions,
Blokhuis--Pellikaan--Szőnyi's twisted-cubic coset-leader enumerator, and
Davydov--Marcugini--Pambianco's 2026 weight-two GDRS preprint.  No new
candidate for the three cofinite-support family sums appeared.  False-positive
uses of “tangent,” “secant,” “family-average,” and “NMDS” outside coding theory
were discarded at title/abstract/metadata depth.  The search-engine result set
did not expose a stable total count, so no numerical screen count is claimed
and the verdict does not rest on one.

## Source and read-depth record

- M. Meneghetti, M. Pellegrini, and M. Sala, *A formula on the weight
  distribution of linear codes with applications to AMDS codes*:
  `partial` — introduction, Section 4, and Theorem 10; arXiv:2003.14063v2;
  cache key `arXiv:2003.14063`; SHA-256
  `245fb371b7afb83e629a558e4bec8786b4c67719d0c67299b120b5038e0ee2e5`.
- S. Dodunekov and I. Landgev, *On near-MDS codes* (1995): `secondary only`
  through the preceding Meneghetti--Pellegrini--Sala source at `partial`
  depth; the original paper was not independently read for this delta.
- A. Davydov, S. Marcugini, and F. Pambianco, *On cosets weight
  distributions of the doubly-extended Reed--Solomon codes of codimension 4*:
  `full text` — complete arXiv:2007.08798v2; cache key `arXiv:2007.08798`;
  SHA-256
  `c07254e4aeffada926e0738427d210a93b6c34118aa27d8fe7d474716a4060bd`.
- A. Blokhuis, R. Pellikaan, and T. Sz\H{o}nyi, *The extended coset leader
  weight enumerator of a twisted cubic code*: `full text` — complete published
  paper, especially Theorem 3.2 and the orbit count; cache key
  `10.1007/s10623-022-01060-0`; SHA-256
  `df47fa06d2beb4b626dd7b7d96ceaaba3332bc3bc0cf03bd40571e4ea3cc840f`.
- A. Davydov, S. Marcugini, and F. Pambianco, *Weight distributions of cosets
  of weight 2 of the generalized doubly extended Reed--Solomon codes*:
  `partial` — abstract, introduction, problem statement, organization, and
  main-result summary; arXiv:2605.10594v1; cache key `arXiv:2605.10594`;
  SHA-256
  `7d1263a552922d1d4e72a871db9eabd431a9a35cbcca3ece8affdacd06225e2e`.

All other source records and exact versions are inherited by explicit
reference to the C975 full audit rather than silently restated.

## Coverage and safe language

The C975 noncoverage remains unchanged: MathSciNet, Google Scholar automated
full-index search, Scopus, Web of Science, several published typesettings, and
article-body search outside the cached texts are not covered.  The negative is
therefore “not located in the recorded search boundary,” never “first.”

Manuscript-safe wording is:

> Double counting the minimum supports in each geometric family yields the
> three aggregate identities below; the standard NMDS recurrence then gives
> the complete family-aggregate weight enumerators.

Avoid “new recurrence,” “first aggregate enumerator,” and any suggestion that
individual extensions in a family have equal weight distributions.

## Surface check

- `claim-proof-novelty-ledger.md`, row `AGG`: owning novelty statement; updated
  to point to both the C975 audit and this delta.
- manuscript abstract, introduction, results map, and Section 6: factual
  consequence language only; no priority adjective.
- paper README: factual result inventory only; no independent novelty claim.

No manuscript prose change is required by this delta beyond the C977 explicit
formula and its existing standard-recurrence attribution.
