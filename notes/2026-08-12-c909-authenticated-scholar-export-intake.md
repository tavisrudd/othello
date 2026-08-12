# C909 authenticated Scholar/PoP/DeepDyve intake

**Date:** 2026-08-12  
**Lane:** C909 / clebsch  
**Scope:** finite handoff protocol for the cycle and quantum priority checks; no manuscript, PDF,
mirror, or Lean edits.

## Operational verdict

An authenticated Google Scholar session is useful, but the export capabilities differ by surface:

* A normal Google Scholar search or “Cited by” result exposes a per-record “Cite” menu with
  BibTeX, EndNote, RefMan, and RefWorks. Google's search-help page does **not** document a bulk CSV
  export for ordinary search/cited-by pages.
* An authenticated Google Scholar **profile** does document bulk export: select profile articles and
  choose Export, then BibTeX, EndNote, RefMan, or CSV. This is an export of the profile's article
  list, not a general cited-by-result dump.
* Publish or Perish is the practical bulk route. Its official manual documents selection of result
  rows followed by File > Save As CSV, BibTeX, EndNote, RefMan/RIS, JSON, or a search report. It can
  also import Google Scholar/Citations CSV, EndNote, and RIS; its manual says Google BibTeX is not an
  import format. Use a human-authenticated session and the normal interface. Do not automate around
  Scholar blocks or rate limits.
* DeepDyve is an access/purchase channel, not a stable citation source. A purchased PDF is emailed
  to the account holder; a print-to-PDF of rented pages may be allowed by the interface but does not
  confer a right to share the PDF. Prefer an open-access, repository, publisher, or lawfully
  purchased PDF whose redistribution status is clear.

The smallest useful handoff is therefore: one query manifest, one raw Scholar page capture or
search-report capture, one CSV export for the complete result set, BibTeX/RIS only for records that
will be discussed individually, and a SHA-256 manifest. A full Google Scholar CSV for ordinary
cited-by pages should not be promised; if the user can produce one through PoP, record it as a PoP
export with its source and version, not as a native Scholar export.

## Finite C909 query set

Use these stable names. Keep the exact query text and date in each manifest; do not rename a
query after export.

| directory key | purpose | seed(s) |
|---|---|---|
| gs-q01-v14-p1-irrationality | V14 times P1, stable irrationality, and classical cubic reductions | arXiv:math/0303037; DOI 10.1515/crelle-2016-0058 |
| gs-q02-cubic-p1-irrationality | cubic threefold times one projective line | arXiv:2608.01577 and exact phrase search |
| gs-q03-nu6-formal-monodromy | primitive sixth-root/formal-monodromy quantum obstructions | arXiv:2608.01577; arXiv:2508.05105; arXiv:2307.13555; arXiv:2307.03696 |
| gs-q04-v14-quantum-atom | degree-14 Fano, Hodge atoms, projective-bundle and blowup quantum comparisons | arXiv:math/0303037; arXiv:2508.05105; arXiv:2409.08392 |

Suggested exact query strings, to be copied verbatim into each manifest:

* “V14” “P1” irrational
* “cubic threefold” “P1” irrational
* “primitive sixth” “formal monodromy” quantum
* “degree 14” Fano “stable rationality” quantum

The quotation marks are part of the recorded query. If Scholar rewrites or drops them, preserve
both the submitted string and the displayed result URL.

## Incoming directory layout

The user may hand off a directory or archive with this layout. It lives outside Git until the
source audit decides which metadata belongs in a dated note:

~~~
/tmp/persistent/tavis/lit-search/incoming/c909-scholar-2026-08-12/
  README.md
  queries/
    gs-q01-v14-p1-irrationality/
      query.md
      scholar-results-page-001.pdf
      scholar-results-page-001.html
      pop-results.csv
      pop-results.bib
      pop-search-report.rtf
      sha256sums.txt
    gs-q02-cubic-p1-irrationality/
      query.md
      scholar-results-page-001.pdf
      pop-results.csv
      pop-search-report.rtf
      sha256sums.txt
    gs-q03-nu6-formal-monodromy/
      query.md
      scholar-results-page-001.pdf
      pop-results.csv
      pop-results.bib
      sha256sums.txt
    gs-q04-v14-quantum-atom/
      query.md
      scholar-results-page-001.pdf
      pop-results.csv
      pop-search-report.rtf
      sha256sums.txt
  seeds/
    kuznetsov-math0303037/
      seed.txt
      cited-by-page-001.pdf
      pop-results.csv
      pop-results.bib
      sha256sums.txt
    cai-2608.01577/
      seed.txt
      cited-by-page-001.pdf
      pop-results.csv
      pop-results.bib
      sha256sums.txt
  pdf/
    Kuznetsov-2003-math0303037.pdf
    Cai-2026-2608.01577.pdf
    KKPYY-2026-2508.05105.pdf
    sha256sums.txt
~~~

Only create the files that exist; the names above are canonical when a user supplies that format.
For a large cited-by result set, one PDF/HTML capture per visible page is preferable to hundreds of
per-record screenshots. A candidate selected for individual discussion gets a separate
candidate-0001.md record with its title, authors, DOI/arXiv ID, displayed cited-by count, result
URL, and why it is load-bearing.

README.md at the intake root must record:

~~~
obtained_at: 2026-08-12T...-07:00
operator: user-supplied authenticated browser or Publish-or-Perish
scholar_account: redacted; do not store an email or session cookie
locale: ...
source: Google Scholar search / Google Scholar profile / Publish or Perish
pop_version: ...                 # omit if not used
raw_page_capture: yes/no
full_text_pdfs: open-access / publisher / DeepDyve-purchased / other
redistribution_note: ...
~~~

Each query.md must contain the exact submitted query, Scholar result URL if present, seed DOI or
arXiv ID, date/time and timezone, filters or page range, displayed result/cited-by count, whether
the user was signed in, and the export files actually supplied. Do not store cookies, access tokens,
personal email addresses, or payment receipts containing financial data.

## How the user should capture Scholar evidence

1. Sign in manually to Google Scholar in a normal browser. Search exactly one query key at a time.
2. Save the displayed URL and query timestamp in query.md.
3. For a cited-by page, save the visible result pages as browser “Print > Save as PDF”; if possible
   also use “Save Page As” for HTML. The PDF is the human-readable snapshot; the HTML preserves
   links when the browser includes them. If the page is too large, capture each page separately as
   scholar-results-page-001.pdf, -002.pdf, and so on.
4. Use the per-result “Cite” menu only for records promoted to individual discussion. Save the
   returned file as scholar-cite-0001.bib, scholar-cite-0001.ris, or the corresponding
   EndNote/RefMan file. Google Scholar's ordinary search help documents these per-record formats,
   not a native bulk CSV.
5. If a profile is the actual object being audited, select the profile articles and use its Export
   button; save the resulting file as scholar-profile.csv (and, if useful, scholar-profile.bib).
   Record that this is a profile export, not a cited-by export.
6. Never submit a password, cookie, CAPTCHA answer, or authenticated browser profile to the
   repository. The user hands off the exported files and snapshots only.

The browser PDF/HTML is evidence of what the authenticated user saw at a time. It is not a
reproducible API response and must not be described as one. Scholar's own help says that programs
which download many search results can be blocked; the handoff should therefore be manual and
bounded.

## How to use Publish or Perish

For a bulk result set, the user should:

1. Run one of the four query keys with the Google Scholar data source in the GUI, or import a
   Google Scholar/Citations CSV, EndNote, or RIS file.
2. Check the intended rows and save the exact results as pop-results.csv.
3. Save the same checked rows as pop-results.bib when bibliographic records are needed, and save
   pop-search-report.rtf or the extended search report for parameters, metrics, and result order.
4. If reproducibility across machines matters, also use PoP's “Export to Archive” and name it
   pop-archive.pop (or the extension produced by the installed version); record the software
   version and source in query.md.

PoP's documented CSV fields include citation count, authors, title, year, source, publisher,
article URL, citing URL, result rank, and query date. Preserve GSRank, CitesURL, ArticleURL,
and QueryDate; they are more useful to a later screen than a reformatted spreadsheet. PoP's
BibTeX output may use generated popxxxx keys and incomplete fields, so DOI/arXiv identifiers
must be checked separately before a source is promoted.

Use the GUI or the vendor's documented command-line tool only where the user already has a
permitted installation and access. Do not script repeated Scholar requests, rotate accounts, or
try to evade blocks. A blocked or incomplete PoP run is recorded as a coverage gap, not silently
filled from a different seed.

## DeepDyve and lawful PDF intake

DeepDyve can be used to locate an article from Scholar metadata, and its documentation distinguishes
reading/rental, printing, and purchasing. For a load-bearing source:

* Prefer the publisher or repository PDF when legally available.
* If the user purchases a PDF through DeepDyve, save the emailed PDF as
  Author-Year-DOI.pdf and add a source.md beside it with the article URL, DOI, access mode
  DeepDyve-purchased, purchase/access date, and any redistribution restriction. Redact the
  purchase email and all payment details.
* Do not treat a browser print-to-PDF of rented pages as a shareable source. DeepDyve's help says
  that printing to PDF does not itself grant copyright to use or share the document. If that is the
  only access, the user may provide bibliographic metadata and page-specific notes, while the agent
  records the source as access-limited rather than ingesting the PDF.
* A purchased or otherwise user-supplied PDF is still a user-provided source, not proof that the
  agent read it. After handoff, inspect the PDF magic bytes and run the shared cache ingest; do not
  commit the PDF to Git.

The cache intake for each lawful PDF is:

~~~
python3 /tmp/persistent/tavis/lit-search/bin/litcache.py add \
  /path/to/Author-Year-DOI.pdf \
  --key '10.xxxx/xxxxx' \
  --title 'Exact title' \
  --url 'https://publisher-or-repository.example/article' \
  --authors 'Exact authors' \
  --year 20XX
~~~

Use an arXiv key when no DOI exists. Query litcache.py get <key> before adding an existing source;
add refuses duplicate keys unless forced. Run litcache.py verify after the batch. The cache
manifest, PDF SHA-256, source URL, and read depth belong in the dated literature report; the PDF
blob remains under /tmp/persistent/tavis/lit-search/ and never enters Git.

## Intake acceptance checklist

Accept a C909 handoff only when the supplied set has:

* one root README.md and one query.md per query or seed;
* exact query strings, seed identifiers, timestamp/timezone, source surface, and displayed counts;
* raw Scholar page capture or PoP search report for every claimed result set;
* CSV for every bulk set, with BibTeX/RIS only where individual promotion needs it;
* a sha256sums.txt covering every supplied export, capture, and PDF;
* source URLs and DOI/arXiv identifiers checked against the exported rows;
* lawful PDF provenance and redistribution status, or an explicit access-limited marker;
* no credentials, cookies, payment data, or untracked “download” claimed as a source.

The agent then screens the CSV/PoP set, promotes only candidates with stable identifiers, verifies
each promoted source against a readable primary copy, and records cache key plus SHA-256. A Scholar
export alone licenses metadata and a bounded search-set statement; it does not license a theorem
claim or a “full text read” marker.

## EJ+TT closeout and mystery ledger

The extra operational value is the explicit three-way split: Scholar per-record BibTeX for promoted
items, Scholar profile CSV only for a profile inventory, and PoP CSV/search archives for a bounded
bulk cited-by set. The hostile check finds no safe shortcut around Scholar's anti-automation boundary
or DeepDyve's sharing restrictions.

No genuine mystery remains about the documented export capabilities. The remaining evidence gap is
account- and UI-state dependent: a future authenticated user must supply the actual captured page,
export, timestamp, and software version. That gap is owned by the user handoff, not by the cache
ingest or the C909 source ledger.

## Documentation sources and access depth

No scholarly PDF was fetched for this procedural note. Eight official web-documentation pages were
read at the relevant sections (partial web-page depth; no cache key/SHA because no PDF bytes were
cached):

* Google Scholar Search Help
  https://scholar.google.com/intl/us/scholar/help.html — citation export and blocked bulk-download
  sections (lines 149--184, 201--203).
* Google Scholar Profiles
  https://scholar.google.com/intl/en/scholar/citations.html — signed-in profile export section
  (lines 256--260) and profile visibility/sign-in instructions.
* Publish or Perish: Exporting your data
  https://harzing.com/resources/publish-or-perish/manual/using/query-results/exporting — supported
  formats, selection procedure, BibTeX/CSV fields and encoding.
* Publish or Perish: Commands
  https://harzing.com/resources/publish-or-perish/manual/reference/commands — GUI Save As commands
  for CSV, BibTeX, EndNote, and RIS.
* Publish or Perish: Imported data formats
  https://harzing.com/resources/publish-or-perish/manual/using/data-sources/imported-data-formats —
  Google CSV/EndNote/RIS import and BibTeX non-import.
* Publish or Perish: Archiving
  https://harzing.com/resources/publish-or-perish/manual/using/query-results/archiving — search
  parameter/results archive semantics.
* DeepDyve: purchasing PDFs
  https://help.deepdyve.com/article/56-how-do-i-purchase-a-pdf — purchased-PDF delivery and
  publisher restrictions.
* DeepDyve: printing articles
  https://help.deepdyve.com/article/22-can-i-print-articles — print-to-PDF limits and copyright
  warning.

These pages establish interface capability and intake constraints only. They do not establish any
C909 novelty or priority claim.
