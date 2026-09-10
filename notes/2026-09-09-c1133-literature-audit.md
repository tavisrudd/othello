# C1133 — literature audit, active checkpoint

**Date:** 2026-09-09. **Lane:** `cubic-threefolds`.
**Status:** incomplete; no global novelty or priority verdict is issued.
**External sources read at full text: 5 — three papers and two source scripts.**
The source register contains 78 individual entries, with exact read depths,
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

## Consolidated acceptance and published mirror-note check

`2026-09-09-c1133-acceptance-map.md` consolidates A–D, F0–A1 and G1–G9,
with exact proof dependencies and remaining source/novelty boundaries. This
accepts mathematical deductions from inspected imported statements; it does
not certify novelty or replace the owning manuscript ledger.

The Lee–Przyjalkowski published short note, DOI 10.4213/rm10239e, has now been
read completely through the publisher's HTML and PDF extraction (three pages,
including references). The exact web response is cached and hashed. Local PDF
attempts returned 403 or non-PDF content; no PDF bytes were falsely ingested.
It is separately registered from the longer arXiv paper. The English version
was published 25 February 2026 in the 2025 volume, received/accepted 12 March
2025, according to the publisher. The precise comparison is general-member
ordinary rationality via mirror monodromy, not the packet's all-member
one-stabilization/Hodge-conservation statements. Its Theorem 2 is not imported
as a shortcut in our proof, and its entire mathematical proof has not been
independently reverified merely because its text was read.

Independent published-ID counts: OpenAlex **1**, Crossref **1**, Semantic
Scholar **1**. The matching titles identify the same short publication.
`2026-09-09-c1133-lp-publication-probe.py/.json` records all URLs, timestamps,
IDs, raw-cache paths and hashes; replay from repository root with
`python3 notes/2026-09-09-c1133-lp-publication-probe.py`.
The S2 set was retrieved completely (one record, no next page) and title/abstract
screened in `2026-09-09-c1133-lp-citation-set.json`. It leads to
arXiv:2510.23143, registered at abstract/metadata depth. This is closure of this
retrieved screen only, not a global absence claim. No new topical query was
needed: the publisher page was an already recorded lead.

The optional c2≥0 gate is closed by Iwai–Matsumura–Müller, published Theorem
1.2(A), DOI 10.1112/plms.70104. This is an accessible primary theorem statement;
the original Miyaoka access failure remains honestly recorded. Bittner's
Theorem 2.1 also supplies the precise projective weak-factorization statement
needed by the operation deduction, at secondary depth for original AKMW.

The outstanding final-audit work is now concentrated in exact companion-import
versions, the remaining registered citation/topical screens, and completion of
the repeating-surface inventory/owning novelty ledger. Optional source
acceptance is no longer waiting on the cone criterion, GG correction, or
minimal-surface Chern inequality.


## Completed pagination and primary lead screen

The quantum/birational zbMATH query is now fully retrieved: **274 records,
274 distinct IDs, all titles screened**. The OpenAPI schema specifies zero-based
`page` and `results_per_page`; its `last_id: null` was not an exhaustion signal.
The previously read page 0 has 100 records; pages 1 and 2 have 100 and 74.
The exact query remains `"quantum" & "birational"`. Raw response timestamps,
hashes, identifiers and URLs are recorded by `2026-09-09-c1133-zbmath-pagination.py`
and its JSON. Replay uses the persistent cached bytes. The compact tracked
records omit the database's full reviews and reference lists.

The remaining 174 records were title-screened in three bounded chunks.
Two title fields were hidden by licensing restrictions. Both are now resolved:
zbMATH 7051836 is the sheaf-moduli/Maruyama-transform article identified by
Crossref DOI 10.1080/00927872.2018.1498870; 6194734 is Gulbrandsen's
*Vector bundles and monads on abelian threefolds*, arXiv:0907.3597. The latter's
arXiv abstract was read. Neither masked field was treated as a negative hit.

Nineteen leads were followed against primary metadata; thirteen arXiv abstracts
were read. Exact accesses and errors are in `2026-09-09-c1133-zbmath-lead-probe.py`
and its JSON; dispositions for all 274 records are in
`2026-09-09-c1133-zbmath-screening.json`. This completes the finite title screen,
not theorem-level screening of every paper or the entire literature audit.

The follow-up confirms several historical strands: McLean's birational
Calabi–Yau small quantum products; Acosta–Shoemaker's discrepant toric
comparisons; Lai's blowup formulas with normal-bundle restrictions; Johnston's
punctured logarithmic comparisons; and You's relative I-functions. Those scope
summaries are at abstract depth. Gyenge's product paper and Hinault–Yu–Zhang–Zhang
are already registered; their earlier limitations are retained, not reset.

**Historical lead at this pagination checkpoint (updated by the next section):** Katzarkov–Lee–Svoboda–Petkov,
*Interpretations of Spectra*, Springer 2023, pp. 371–407,
DOI 10.1007/978-3-031-17859-7_20. The publisher abstract concerns monodromy of
categorical linear systems and noncommutative spectra, and its displayed
references include Fano irrationality and prospective blowup/atom work. The
chapter body is behind subscription access and has not been read. Its relevance
cannot be disposed of by the abstract alone. Katzarkov–Liu's categorical
base-loci chapter is another recorded body-unread precursor. These are
follow-up obligations, not claims of pre-emption.

The exact additional web queries were:

- `"Categorical base loci and spectral gaps" Katzarkov Liu`
- `"Interpretations of spectra" Katzarkov Lee Svoboda Petkov`
- `"Semisimple quantum cohomology, deformations of stability conditions" Bayer`
- `"Singular fibers and Coulomb phases" Schafer Nameki`

Primary landing accesses also inspected Springer chapter 10.1007/978-3-031-17859-7_20.
The AMS chapter URL and an Oxford direct open returned tool errors; the Bonn
repository direct open returned an anti-bot page. Author/repository search-result
summaries for Bayer and the Oxford seminar remain explicitly metadata-depth.
No extra source has been counted as fully read. The unresolved historical chapter
bodies, other citation leads, publication aliases and repeating novelty surfaces
still prevent a global novelty verdict.


## Local sharpness import: exact scope check

The current monorepo authority `papers/cubic-stabilization-irrationality/`
is titled *Sharpness of Irrationality after One Stabilization for Cubic
Threefolds*. Its last source commit is
`f879abf243ac2c02ffd16117e25b075b16e0339d`; the TeX SHA-256 inspected here is
`ec0509629e3978b5f728dcfc8b00563d87b036c43723a026e68a54197dba7274`.
Read depth for this checkpoint: README lines 1–100 and TeX lines 80–174,
not the complete manuscript or its proof/evidence bundle.

The exact usable surface statement is `thm:two-variable`: characteristic-zero
k, a smooth quartic del Pezzo surface S/k, S(k) nonempty, and geometric Picard
lattice stably permutation imply S×P² is k-rational. Its annotations expose
classical imports and the quartic-del-Pezzo slice-cover evidence bundle.
`thm:cubic-level` applies to two displayed cubics X1,X3; `cor:cubics` covers
the corresponding two Tschinkel–Zhang higher-dimensional series.

This does **not** by itself verify the packet's entire rational-parameter
pencil. An application to that pencil still needs its own generic del Pezzo
fibration and stable-permutation/rational-point hypotheses. The local toric-rank
profile and special-pencil isogeny theorem are not supplied by the inspected
statements. The sharpness theorem has now been located and pinned, but the
pencil-specific inputs remain open; neither is used in A–D.


## Historical spectra chapter: accessible author version and exact overlap

An additional search recovered an author-hosted DSc thesis containing a chapter
with the title *Interpretations of spectra*. The published Springer chapter
body remains inaccessible; no version-equivalence assertion is made. The cached
thesis PDF has SHA-256
`b3490fc8e6c93f3095ca217eb1d31e07af6623c94b8744f7dbbdc13dcac6287d`.
The separate source-register entry `Katzarkov-DSciThesis-v2` records URL, bytes,
cache paths and exact partial-read intervals. Full-text count remains five.

Additional verbatim searches:

- `"Interpretations of spectra" pdf Katzarkov 2023`
- `"Categorical base loci" "01473" pdf`

The author-hosted chapter explicitly displays the cubic threefold quantum
system and exponent representatives **−1/6 and −5/6** (printed p. 285).
Sections 2.1–2.4 develop its noncommutative spectrum and use the spectrum in
ordinary-irrationality statements for Fano hypersurfaces and complete
intersections. Theorem 2.14 includes the three-dimensional hypersurface case;
Theorem 2.15 states a weighted-complete-intersection analogue. This is concrete
historical credit, not merely a vaguely related abstract. The chapter's
`δ=5/3` for the cubic is its asymptotic-dimension quantity; it is **not** the
packet's exact squared exponent gap `δ♯=4/9`.

The chapter attributes the birational splitting theorem and further details
to [142], Katzarkov–Kontsevich–Pantev–Yu, *Blow up formulae*, **in preparation**.
Section 2.1 also discusses convergence/Gamma and decomposition conjectures;
Theorem 2.14's higher-dimensional statement has an upper-semicontinuity
condition. These qualifications belong to the source comparison. This read
neither certifies all the chapter's arguments nor dismisses them for containing
conjectures. Its explicit cubic exponents and broad method must be credited
regardless of the final evaluation of those dependencies.

Section 3's arithmetic concerns rationality over nonclosed fields subject to
restrictions on algebraic-cycle images. It is not the bounded-degree geometric
partner-finiteness deduction used in D at the inspected statement loci.
Sections 5–6 discuss multispectra and orbifoldization, with a cubic example and
further prospective birational invariants. The exact partial scope is recorded;
no full-chapter negative is inferred from a keyword search. Reference [144]
identifies the categorical base-loci precursor, whose original body remains
an open access/read obligation.

The owning claim–proof–novelty ledger now records this predecessor before any
manuscript priority language changes. The intended manuscript-phase correction
is explicit older attribution of the cubic exponents and the broad spectral
program. The one-stabilization classification, Hodge conservation, very-general
cancellation and bounded-degree finiteness still need their own complete
statement comparisons; their novelty is not settled by this partial read.

## F-bundle framing source: precise partial read

Hinault–Yu–Zhang–Zhang, arXiv:2411.02266v2 (28 March 2025), is now read at the
introduction's principal statements and at Definition 4.33/Theorem 4.34/Corollary
4.35. The exact LF-line scopes are in the register. The source supplies formal
spectral decomposition and framing results. Its nonsimple classification
requires its specific commuting-nilpotent coefficient algebra, grading and
parameter restrictions; the simpler corollary assumes simple eigenvalues.
Those statements cannot be imported as unrestricted rank-three framing
rigidity. Their projective-bundle uniqueness statements are useful precedent,
with base-point and coordinate qualifications retained. Neither reading closes
the fixed-base faithful-map construction or the regular-comparison obligations
in the present upgrade by itself.


## Repeating-surface inventory for the manuscript-review phase

The owning novelty ledger has been read completely and updated before any
new priority posture is propagated. The following are concrete surfaces,
not a claim that external releases were edited or fully inspected:

| Surface | Inspected content and required later action |
|---|---|
| `papers/cubic-stabilization-m1/claim-proof-novelty-ledger.md` | Whole file read; older cubic-exponent credit and candidate A–D boundaries updated now. Existing historical audit entries retained with the current boundary made explicit |
| `sections/01-introduction.tex` | Related-work paragraph lines 78–116 read: currently credits KKPY, Guéré and collaborators, Gyenge, Cai. Add the older spectra chapter and the published mirror note after exact bibliography/version resolution |
| `sections/02-qdm-marker.tex` | Universal-residue statement/proof lines 560–648 read: already contains the parameterized mathematical proposition. New Lean identities are related finite algebra, but do not yet construct its canonical formal block; coverage remains unchanged pending a correspondence review |
| `companions/cubic-framed-monodromy/sections/02-framed-monodromy.tex` | Targeted exponent-reference search; the discussion around lines 39–51 is a later attribution-update locus. This was a location screen, not a new full-section read |
| `README.md` and `REVIEWER_GUIDE.md` | Both read completely. Current scope is cubic, genus eight and index-two applications, not A–D. Guide must acquire the two-selector and full-fiber explanations if the upgrade is accepted |
| `.zenodo.json` | Whole local metadata file read. Its description repeats the existing theorem scope; update only with a reviewed release. No remote deposit read or changed here |
| `blueprint/src/content.tex`, `blueprint/src/generated-references.tex` | Targeted reference search only. Regenerate from accepted TeX/bibliography rather than independently editing generated claims |
| `lean/verification/claims.json`, Lean README, verification README | Exact checked formal boundary and new machinery rows updated. The 67 current manuscript statuses are unchanged. Baseline JSON is a historical snapshot and must not be rewritten as current coverage |
| `papers/summary/README.md`, `papers/summary/VERIFICATION.md` | Cubic entry and matching verification row inspected; current summary repeats the cubic/genus-eight result. Later synchronize reviewed theorem scope and partial formalization boundary |
| Lane handoff and task card | Current research frontier updated, with no global novelty verdict. Historical handoff rows contain older all-m/companion descriptions; do not use them as current theorem authorities |
| Standalone GitHub repositories, rendered PDFs/blueprint and archival release | Known repeating outputs from README links and prior export reports. Not synchronized or freshly fetched in this research checkpoint; release review must compare them with the accepted authority |

No dedicated paper file named `snapshot` was found in the bounded filename
inventory. This is not a global inventory of external summaries. The principal
open literature obligations remain the published spectra-version comparison,
the categorical base-loci body, outstanding graph/publication-alias checks,
original Narasimhan–Nori access and the already recorded MathSciNet/Scholar
coverage limits. The exact pencil hypotheses remain separate optional imports.


## Final access probes in the one-hour checkpoint

The following additional searches were run verbatim, as discovery screens of
tool-returned titles and excerpts:

- `Narasimhan Nori Polarisations on an abelian variety 1981 pdf`
- `"Categorical base loci and spectral gaps" pdf Katzarkov Liu`
- `"Narasimhan" "Nori" "Polarisations" filetype:pdf -site:researchgate.net -site:repository.ias.ac.in`
- `"Polarisations on an abelian variety" "pdf" "ias"`
- `"Categorical base loci" "Katzarkov" site:math.bas.bg pdf`

The IAS search index again returned Theorem 1.1 of Narasimhan–Nori, and browser
open identified a four-page PDF at `https://repository.ias.ac.in/36463/1/36463.pdf`,
but extraction returned zero lines and screenshots of all four pages failed
with cache misses. Cache lookup confirmed no original PDF under
`10.1007/BF02837283`. The original-facsimile read gap therefore remains; this
is not promoted to a full or partial original-paper read. Earlier secondary
statement corroboration remains available.

The plausible AMS chapter PDF URL
`https://www.ams.org/books/pspum/088/01473/pspum088-01473.pdf` and INSPIRE API
record `https://inspirehep.net/api/literature/1337888` returned browser access
errors. Neither supplies chapter text. Additional search hits were discovery
metadata only and were not used as mathematical authorities. No new source was
counted as read in full and no negative literature conclusion follows.


## Institutional and author metadata: equivariant successors

Lee's author publication list and CKGA's institutional papers list corroborate
the 2023 spectra chapter authorship, volume 409 and pages 371–407, but provide
no alternate chapter body. Their cached HTML and the following arXiv landing
snapshots are pinned by `2026-09-09-c1133-equivariant-leads.json`. These accesses
followed already identified links; no new topical query was used.

CKGA entries 28–30 list three historical preprint/in-preparation titles about
Chen–Ruan blowup, nc Hodge birational invariants and equivariant atomic contents.
They are individually registered at metadata depth. Their identifiers, current
status and possible aliases to subsequent work remain unresolved; they are
not presumed to be three distinct current papers.

Following CKGA's arXiv:2405.07322 link gives a useful version correction:
*A Gromov-Witten approach to G-equivariant birational invariants* is withdrawn.
The current v4 notice points to *Atoms meet symbols*, arXiv:2509.15831, and future
work. The current v4 abstract of the latter was read. Its Chen–Ruan atom
extension explicitly assumes the quantum Chen–Ruan blowup formula, and it also
describes a separate geometric construction for finite-group actions. This is
an equivariant/orbifold precursor requiring body-level comparison, not an
unconditional geometric QDM input for A–D. Withdrawal alone is not a correctness
verdict on the older text. The institutional list's older “submitted” label
must not override the current arXiv notice.

The register now has **78 entries**, including these five metadata/abstract
leads; full-text count stays **five**. This expansion improves the audit's
coverage and version control but leaves the listed body and alias obligations
open. No assertion of comprehensive absence is made.
