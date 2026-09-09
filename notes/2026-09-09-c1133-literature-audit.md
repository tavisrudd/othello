# C1133 — literature audit, active checkpoint

**Date:** 2026-09-09. **Lane:** `cubic-threefolds`.
**Status:** incomplete; no global novelty or priority verdict is issued.
**External sources read at full text: 4 — two papers and two source scripts.**
The source register contains 52 individual entries, with exact read depths,
versions, cache access and hashes. Most papers have partial read depth.
Iritani’s ten-page Hodge refinement has now been read completely.
The author-supplied packet has been read completely, including its checker.

## Accepted source-level findings

1. Iritani's blowup Theorem 5.18 and Iritani–Koto's projective-bundle Theorem 5.1
   are statements about the full quantum D-module with pairing and regular
   z-polynomial completed comparison maps. Iritani's Hodge Proposition 8 supplies
   equivariance of the full blowup maps, not just their invariant subspaces.
   Projective-bundle equivariance now has an explicit uniqueness proof in
   `2026-09-09-c1133-transport-vanishing-audit.md`, which also verifies surface
   vanishing. The fixed-base faithfulness adaptation is written separately in
   `2026-09-09-c1133-fixed-base-proof.md`. Its exact graded reduced domains must
   remain part of the eventual theorem.
2. Voisin's rational generic Torelli formulation has exactly the cubic/quartic
   quantifiers requested by the packet. Theorem 0.2 applies to (d,n)=(3,4),(4,4);
   Remarks 0.1 and 0.3 account for unpolarized and rational coefficients. This
   supports the cancellation deduction if the Hodge-conservation gate passes.
3. Orr v4 Theorem 5.1 explicitly gives the required bounded-degree geometric
   isogeny bound over finitely generated characteristic-zero fields. Achter's
   Theorem B explicitly constructs the arithmetic intermediate-Jacobian map.
   The primary Narasimhan–Nori text remains inaccessible in this session, so the
   polarization-finiteness source check is still at secondary depth.
4. Przyjalkowski Theorem 6.1.1 matches the displayed genus-six and genus-eight
   matrices and scalar shifts. Kuznetsov–Prokhorov Section 1.1 matches the eight
   geometrically rational families. Debarre Theorem 3.7 includes ordinary and
   special GM varieties in an irreducible moduli space. These checks are not a
   complete classification proof. The later provenance check matches all fifteen
   index-one/two archive matrices entrywise and checks their period inputs through
   degree eight. The special quartic and GM deformation bridges are written in
   `2026-09-09-c1133-geometric-source-audit.md`; KP arXiv:2312.13782v2
   now supplies explicit smooth seventeen-family exhaustion and Table 5 verifies
   all seventeen Hodge numbers. The original IP99 book remains secondary-only.
5. The packet omits two close comparison sources found through forward citations.
   Lee–Przyjalkowski, `arXiv:2510.21222v1`, Theorems 1.2 and 1.4 concern ordinary
   rationality of general Fano threefolds through mirror monodromy. They must
   enter the positioning discussion; the inspected statements do not supply a
   one-stabilization theorem. Kontsevich–Szabó, `arXiv:2607.22074v1`, concerns
   framed regular-singular quantum connections and their moduli. Its Proposition
   2.1 fails as written in rank three, as proved by the exact witness in
   `2026-09-09-c1133-framing-source-audit.md`. No blanket verdict on its main
   theorem is made. The packet's corrected rank-three argument must remain
   self-contained.

All comparisons above are the auditor's deductions from the indicated source
passages. Full access/version/read-depth details are in
`2026-09-09-c1133-literature-sources.json`. They are source checks, not claims
that the combined upgrade is new.

## Searches recorded verbatim

The web search batches used these literal queries on 2026-09-09:

```text
"one stabilization" "Fano" "quantum"
"one-stabilization" "Hodge"
"Gushel" "stabilization" irrational
"Fano threefolds" "quantum" irrationality
"Hodge atoms" birational invariants
"Schiffer variations" "rational" Torelli
"Fano threefolds" "irrationality" "quantum cohomology"
"Gushel-Mukai threefolds" "irrationality" quantum
"cubic threefold" "one stabilization"
"quartic threefold" "symplectically irrational"
"Benedetti" "Manivel" "Perrin" "threefolds" irrationality
"Quantum cohomology" "irrationality" "Gushel"
"one-stable" "Hodge" cubic
"Narasimhan" "Nori" "Polarisations" 1981 doi
"Benedetti" "Manivel" "Perrin" "all" "threefolds"
"Fano threefolds" "one-stabilization"
"cubic threefold" "cancellation" "Hodge"
```

These were discovery searches over the tool-returned titles, URLs and snippets,
not exhaustive result-set screens; no negative is licensed by them. Their
individually promoted sources are in the source register. Broad queries returned
substantial nonmathematical noise. The citation sets below provide the explicit
bounded screens; the general web batches are not being presented as substitutes.

## Independent graph counts and title screens

The pinned-seed probe script is `2026-09-09-c1133-citation-probe.py`; its recorded
output gives every request verbatim, status, resolved identity, count and raw
response hash. It uses arXiv identifiers for Semantic Scholar and corresponding
DataCite arXiv DOIs for OpenAlex/Crossref. A missing DOI record is not a zero
citation count. Publication aliases for Voisin and Orr have now been checked below; other
aliases remain open where appropriate.

| Pinned arXiv seed | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---|---|
| 2307.13555 | 0 | 404 | 429 |
| 2307.03696 | 0 | 404 | 429 |
| 2604.10028 | 0 | 404 | 429 |
| 2508.05105 | 0 | 404 | 23 |
| 2605.29143 | 0 | 404 | 429 |
| 2608.01577 | 0 | 404 | 429 |
| 2411.02266 | 404 | 404 | 429 |
| 2606.17884 | 0 | 404 | 429 |
| 2004.09310 | 1 | 404 | 10 |
| 1209.3653 | 0 | 404 | 429 |
| 2509.15831 | 0 | 404 | 1 |

HTTP 404 means the requested identifier was not resolved by that service;
HTTP 429 means the request was rate-limited. Neither means an empty citing set.
Crossref did not resolve these queried DataCite identifiers in this run;
its publication records have not thereby been excluded.

The three available larger Semantic Scholar sets were retrieved completely:
23, 10 and 1 records, with no continuation token. Their raw metadata, request
URLs, hashes, counts, and screen discriminator are stored in
`2026-09-09-c1133-citation-sets.json`. **Screen fields:** titles of all 34 entries;
abstracts were additionally inspected for the five leads below. The verbatim
title discriminator was:

> Promote titles addressing quantum or Hodge birational invariants,
> F-bundle/lattice/framing constructions, Fano rationality, or rational Torelli;
> retain ambiguous method-adjacent titles as unresolved leads rather than
> content-level negatives.

The five additionally abstract-screened leads were moduli of atoms
(`2607.22074`), intermediate Jacobians and Burnside invariants (`2511.07101`),
mirror fibers and rationality (`2510.21222`), product quantum D-modules
(`2509.07407`), and global Torelli (`2608.27441`). All five now have partial primary-text reads. Their statements and exact
read scopes are in the source register; none has a full-paper exclusion verdict.

The disagreement 0 versus 23 for the Hodge-atoms seed demonstrates an indexing
gap. None of the three graph trees is closed while the unresolved service/alias
coverage and promoted readings remain open.

## Access and remaining coverage

- Initial zbMATH browser attempts returned tool-access errors. Direct API access
  subsequently succeeded; see the bounded coverage record below. Initial URLs:
  URLs attempted: `https://zbmath.org/?q=an%3A2004.09310`,
  `https://zbmath.org/?q=ti%3A%22one-stabilization%22`, and
  `https://api.zbmath.org/v1/document/_search?search_string=2004.09310`.
  The first query used an unsuitable accession field for an arXiv identifier;
  it is not evidence of absence. The direct API was subsequently reached.
- MathSciNet: NOT COVERED. The publication-search URL with query `2004.09310`
  returned a tool-access error; no authenticated review search was available.
- Google Scholar: NOT COVERED. The query URL for `"one stabilization" "threefold"`
  returned a tool-access error. No Scholar result set was screened.
- Narasimhan–Nori: IAS PDF GET returned 404; publisher PDF GET returned non-PDF
  bytes. Browser metadata opened the four-page PDF but page rendering failed
  with cache miss. The primary text is therefore not marked read or cached.
- Unfinished source work includes classification exhaustion and remaining geometry,
  framing precedents, relevant promoted
  citation sources, the motive corrigendum and optional applications. The packet's
  Hartlieb, weak-factorization and Bittner references still need their own access
  records before those optional/presentation branches are called audited.
- The newer author-hosted GM survey lead has been checked and corrected: its
  announcement is about very general GM fourfolds, not all GM threefolds. It
  supplies no predecessor for the proposed all-member threefold assertion.

Every newly downloaded arXiv PDF was ingested into the shared cache. Failure
to access a source is recorded separately from finding no predecessor.

## Later source and zbMATH checkpoint

`2026-09-09-c1133-geometric-source-audit.md` records the exact matrix comparison,
period-input verification, special-model bridges, and corrected GM announcement.
Cai’s quartic Theorem 5.3 is a direct persistence predecessor, now checked in
Section 5. It must be credited in positioning the packet’s trace argument. Its
simple-eigenvalue typo does not change its repeated-root claim.

The direct zbMATH API returned a single record for the exact quantum-period
paper title query and then the following scope queries, recorded verbatim in
`2026-09-09-c1133-zbmath-probe.json` with URLs, timestamps, response hashes,
raw-cache paths, total counts and returned counts:

| Query | Total | Retrieved/title-screened |
|---|---:|---:|
| `"one-stabilization"` | 32 | 32 |
| `"quantum" & "birational"` | 274 | 100 |
| `ti:"Polarisations on an abelian variety"` | 1 | 1 |
| `ti:"Schiffer variations and the generic Torelli theorem for hypersurfaces"` | 1 | 1 |

The 32-title screen mainly retrieves topological stabilization and numerical
analysis; its ambiguous algebraic-variety title remains a lead. It is not a
content-level exclusion. The quantum/birational query is explicitly a **partial
100-of-274 screen**, even though its response has a null last-id field. No global
negative follows. The title discriminator is the same as the forward-citation
screen above. Existing Hodge-atom, quantum-period and irrationality entries and
method-adjacent leads remain in the reading queue. Review bodies were not used
for theorem claims. The exact-title records resolve the NN DOI and Voisin’s
published DOI `10.1112/S0010437X21007727`; publication-alias citation checks for Voisin and Orr are recorded in the
arithmetic follow-up below. MathSciNet and Scholar are still not covered.

## Transport and closest-predecessor follow-up

The written operation/surface gate is in
`2026-09-09-c1133-transport-vanishing-audit.md`. Guéré’s Example 15 already
establishes the relevant nef-surface nilpotence on the Hodge-fixed base. This
must be credited; the proposed contribution is not that surface calculation.

The inspected fourfold criterion of Benedetti–Fay–Guéré–Manivel–Perrin,
Theorem 4.1, requires b3=0, whereas the proposed detected X×P1 endpoints have
nonzero H3. Thus that theorem does not directly apply to these endpoints.
Kresch–Tanimoto–Tschinkel’s inspected introduction concerns finite-group
IJ/Burnside invariants of threefolds. Serebrennikov’s Theorems A–D assume
K-trivial varieties or Calabi–Yau pairs, rather than the Fano partners here.
These are comparisons of the inspected statements, not exclusions of all
results in the papers. Gyenge’s product Theorem 4.6 claims formal QDM
factorization, but the inspected proof refers to a leading-order proposition;
this read has not supplied the stronger faithful original-lattice contract
needed here. It is retained as a comparison source, not used as a shortcut.

Additional literal searches:

```text
Narasimhan Nori Polarisations 125 128 site:ias.ac.in
"Polarisations on an abelian variety" "pdf" -site:researchgate.net -site:scribd.com
```

These are discovery searches over returned metadata/snippets, not exhaustive
screens. The source index exposes NN Theorem 1.1, but new direct IAS requests
still return 403 and the repository download request returns 404. Exact URLs
and results are saved in `2026-09-09-c1133-nn-access.json`; no facsimile reading
or cached primary PDF is claimed.

## Arithmetic and publication-alias follow-up

`2026-09-09-c1133-arithmetic-audit.md` checks the finite-kernel argument and a
second route using Orr’s fourth-power polarized-isogeny theorems. The latter
source was found in the largest forward-citation set, not in the packet.
Milne’s Theorem 15.1 supplies additional statement-level corroboration of
polarization finiteness; NN’s original PDF remains inaccessible.

Verified publication aliases resolve to OpenAlex/Crossref/Semantic Scholar
counts **6/6/10 for Voisin** and **21/13/37 for Orr**. The former largest set
was already retrieved. Orr’s 37-record set was retrieved completely and all
titles screened; three abstracts were read, one other promoted entry has no
abstract, and the polarization-compatibility paper was promoted to partial
primary text. Exact discriminator, URLs, source identities, counts, records
and raw hashes are in `2026-09-09-c1133-orr-citation-set.json` and the
publication-alias probe files. No general citation-graph closure is claimed.

## Novelty ownership and current surface state

No new novelty sentence has been placed in the manuscript, ledger, snapshot,
README or public summary. Before any such sentence is adopted, the owning
claim–proof–novelty ledger must carry the audited verdict and evidence, and the
four required repeating surfaces must be inventoried explicitly. That inventory
is still open; it is not inferred from memory. No existing public novelty verdict
is changed by this checkpoint.

## Mystery ledger

- **Settled:** the rank-three original-frame triangularity source claim fails,
  even with distinct nonunit monodromy. The packet's corrected construction is
  not refuted by the witness.
- **Settled:** the available citation databases disagree substantially, so an
  OpenAlex zero cannot close this audit.
- **Open:** source alias/service coverage, complete promoted-source reading,
  all-family geometric inputs and final claim-by-claim novelty dispositions.
  These remain C1133 work, before manuscript and hierarchy review.

## Smooth-family source follow-up

Queries on 2026-09-09, recorded verbatim:

```text
Fano threefolds Picard rank one table h12 52 30 20 14 Kuznetsov
Fano threefolds classification genus 6 8 rational Kuznetsov Prokhorov table hodge numbers
```

These discovery queries located KP arXiv:2312.13782, then pinned to v2 through
its arXiv metadata. The publisher page
https://www.mathnet.ru/php/archive.phtml?jrnid=im&option_lang=eng&paperid=9585&wshow=paper
verifies DOI 10.4213/im9585e. Only the selected KP source was promoted for the
geometric check; this is not an exhaustive search-result screen or a negative
search. Other displayed results have not been promoted as read sources.
The arXiv PDF was cache-queried before fetching and ingested with its hash.
Web screenshot returned cache miss; local pdftoppm was unavailable. The cached
PDF p. 13 was instead rendered with PyMuPDF and visually inspected successfully.
Full-text count is unchanged. No citation-graph negative is asserted here.

## Optional-claims source pass

The mathematical dispositions and symbolic arguments are in
`2026-09-09-c1133-optional-claims-audit.md`. Beauville's cubic multiplication
inputs, GG's stated rational decomposition, and Hartlieb's explicit Fermat
isogeny are now partial-text checked. The GG corrigendum remains unread after
AMS returned 403 and the author homepage returned 502. The source register
records the SGA English reproduction's limited provenance; no original French
facsimile read is claimed. Full-text count remains three (one paper, two scripts).

Verbatim web queries on 2026-09-09:

```text
abelian varieties isogeny invariant potential good reduction toric rank semistable reduction monodromy rank
Gorchinskiy Guletskii corrigendum motives representability algebraic cycles threefolds Theorem 8
Hartlieb Fermat cubic intermediate Jacobian Remark 23 isogenous elliptic
"Gorchinskiy" "Guletskii" "corrigendum"
"S1056-3911-2013-00634-7" pdf
site:pcwww.liv.ac.uk/~guletski corrigendum
```

These were input-discovery and access queries, not exhaustive screens or
citation-graph negatives. Promoted sources are individually registered; other
search results were not promoted as read sources. Existing Beauville, GG and
Hartlieb arXiv PDFs were retrieved from the shared cache. The SGA reproduced
HTML was saved with a hash. No new PDF was fetched successfully in this pass.
The conjectural/conditional source gates in the optional report must not be
silently converted into accepted manuscript claims.

### Algebraic loci and additive extension

Voisin v3 §1.1 and introduction explicitly supply algebraic rational-Hodge
correspondence loci, closing the exceptional-locus source obligation.
Bittner arXiv:math/0111062v1 Theorem 3.1 gives smooth projective generators
with exactly the relations satisfied by the spectrum. The optional audit
now proves that its additive extension kills the whole ideal (L−1).
The packet-only Bittner entry is replaced by its pinned partial-text entry;
total sources and full-text counts are unchanged.

One discovery query, verbatim, 2026-09-09:

```text
Bittner universal Euler characteristic varieties characteristic zero blow up presentation 0111062
```

The cached Bittner PDF was used. The publisher's linked PDF metadata verifies
DOI 10.1112/S0010437X03000617, but that publication PDF was not fetched or
read. No citation-graph closure is inferred from this input check.

## Cone and rational-motive source closeout

KPZ arXiv:1212.4249v3 closes the affine-cone implication with the packet's
normality hypotheses. The full author-uploaded GG corrigendum is now read
through its ResearchGate reproduction and cached as the exact web response.
The correction preserves the paper's results. Earlier entries recording failed
AMS access describe those attempts; they no longer mean the correction is unread.
The full-text count increases to four: two papers (including this two-page
correction) and two scripts. Both newly fetched PDFs, KPZ and Efimov, were
cache-queried first and ingested with hashes. They have partial read depth.

Huybrechts Theorem 0.2 plus Efimov Corollary 3.5 already give isomorphic rational
Chow motives without L-equivalence. The packet acknowledges this broad prior
phenomenon. The optional audit now specifies the actual threefold/one-stabilization
comparison, without asserting firstness for it. Virin's g=9,10 theorem concerns
rational controls; his introduction supplies a useful all-member/general-member
scope distinction. The Miyaoka theorem text remains unavailable at the attempted
publisher routes, so the optional odd-excess inequality source gate stays open.

Verbatim discovery/access queries, 2026-09-09:

```text
"Guletskii" "corrigendum" motives pdf -site:researchgate.net -site:scispace.com
"affine cones" "cylinders" additive group action Kishimoto Prokhorov Zaidenberg
"Motives" "corrigendum" "Gorchinskiy" site:livrepository.liverpool.ac.uk
"Motives" "corrigendum" "Gorchinskiy" site:mi.ras.ru
Miyaoka second Chern class minimal surface nef canonical c2 nonnegative theorem
"The Chern Classes and Kodaira Dimension of a Minimal Variety" Miyaoka pdf
```

These queries locate inputs and access routes; no exhaustive result-set or
citation-graph negative is asserted. The promoted sources have individual
read-depth records. Other displayed titles have not been promoted as read.

### Repeating-surface inventory started

The owning novelty ledger is
`papers/cubic-stabilization-m1/claim-proof-novelty-ledger.md` (identified and
its opening current-claim rows inspected). It already rejects blanket novelty
for Hodge localization and uses qualified predecessor wording. C1133 has not
changed it or authorized new novelty text there. Intended later review surfaces:
main manuscript and bibliography; that ledger; paper README/public summary;
results/coverage snapshots (exact novelty-bearing snapshot still to identify);
and the standalone mirror copies. This inventory is not yet complete. No new
absence/firstness sentence is being promoted ahead of its owning ledger row.
