# C1133 — exact missing source request

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Status:** source-access continuation exhausted for the routes below;
C1133 remains ACTIVE. No new full-text reads. The register retains eight
external full-text reads among 88 total entries.

The following concrete items are needed to finish the corresponding gates:

1. Katzarkov–Lee–Svoboda–Petkov, *Interpretations of Spectra*, published
   chapter, DOI `10.1007/978-3-031-17859-7_20`, pp. 371–407. Need the
   published body or author confirmation of the exact version relation to
   the already-read thesis chapter. The latter confirms identity/version
   only; it does not independently reverify a proof.
2. Katzarkov–Liu, *Categorical base loci and spectral gaps, via Okounkov
   bodies and Nevanlinna theory*, DOI `10.1090/pspum/088/01473`, pp. 47–118.
   Need the chapter body. AMS endmatter and the Miami thesis are not
   substitutes for this chapter.
3. The exact local path or link to the special-pencil sharpness/moduli
   companion used in packet §§30–31. Need to verify the stated toric ranks,
   squarefree-parameter separation and the special isogeny restriction.
   The known local sharpness theorem alone does not supply these inputs.

**Superseding operational decision:** the user requested triangulation rather
than paid access. `2026-09-10-c1133-triangulation.md` distinguishes proof
inputs from attribution/version limitations. The two chapters no longer
block bounded A–D assessment; the optional pencil imports remain conditional.
This historical request is not a renewed request to purchase or supply files.

## Final bounded access pass

Exact discovery queries:

```text
"Categorical base loci and spectral gaps" pdf Katzarkov Liu
"Interpretations of spectra" Katzarkov Lee Svoboda Petkov pdf
"Categorical base loci" filetype:pdf
"Katzarkov" "Liu" "01473" ams
"Interpretations of Spectra" "Svoboda" -site:researchgate.net -site:math.bas.bg
```

Returned titles/URLs/snippets were used for access discovery, not an
exhaustive novelty screen. Only primary publisher and institutional
locators were promoted. The bibliographic source entries retain their
actual metadata/partial read scopes in the source register.

Five exact requests, timestamps, statuses and hashes are recorded in
`2026-09-10-c1133-chapter-access.json`. The initially guessed AMS chapter
path returns 404. Crossref supplies the correct volume landing
`https://www.ams.org/pspum/088`, which returns 200 and links to the same
book PDF and endmatter already tested. It does not expose a separate
chapter download. Crossref confirms chapter pages and title.

The HSE institutional record
`https://publications.hse.ru/chapters/835898702` returns 200 but its external
text link points only to Springer. The Springer chapter landing returns
200 and supplies metadata, abstract and references, with body access
explicitly restricted to subscription. Its reference 29 still lists
*Blow up formulae* as in preparation. Thus that bibliography dependency
is verified on the published landing itself; no published-body or theorem
version equivalence follows. Read depth: abstract/metadata only for these
publication records; the thesis remains partial.

## Decision and EJ + TT / Mystery ledger

The cheap EJ + TT check was to resolve publisher identifiers before treating
a failed guessed URL as an inaccessible publication. The correct AMS
volume locator is now settled. It does not cure the body-access gap.
The distinction between a published bibliography and an unread published
theorem is also settled. The three missing-source obligations above remain;
no new mathematical mystery is inferred from an HTTP status.

Further identical retries have low value. Request the exact sources rather
than convert missing access into a negative or waive a gate. Missing
Crossref/MathSciNet/Google Scholar coverage remains separately recorded in
the citation followup; obtaining these bodies alone would not prove global
literature closure. No novelty or theorem status changes in this pass.

Validation: all five raw-response SHA-256 values checked against the
manifest; the existing `2026-09-10-c1133-cont-verify.py` still passes.
Source-register and handoff pointers updated and committed with this note.
No manuscript, Lean, mirror, outbound message, or publication change.
