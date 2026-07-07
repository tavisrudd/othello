# Codex C4 arc-census fill report (2026-07-07)

## Result

Partial fill completed and appended to:

```text
notes/2026-07-07-arc-census-o1.md
```

under:

```text
## C4 fill — Codex partial accessible-source pass (2026-07-07)
```

The full paywalled classification tables in [CS-2325] and [Cool-31] were still not accessible.
However, accessible sources filled several cells:

- `q=23` full spectrum: `{10, 12, 13, 14, 15, 16, 17, 24}`.
- `q=23`: no complete 11-arcs; no complete sizes outside that spectrum.
- `q=23`: `N_10 = 1` and `N_24 = 1` up to projectivity.
- `q=25`: `N_12 = 606` smallest complete 12-arcs.
- `q=25`: no complete 19-arcs and no complete 20-arcs.
- `q=31`: abstract-level correction `N_22 = 12` complete 22-arcs up to projective equivalence.

Remaining gaps are explicitly preserved: q=23 counts for `k=12..17`, q=25 full spectrum and all
counts except `k=12`/nonexistence of `19,20`, and q=31 full spectrum/count table except the `k=22`
correction.

## Sources accessed

### FMMP q<=23 spectrum paper

Accessible PDF:

```text
https://combinatorialpress.com/article/ars/Volume%20047/volume_47_paper-1.pdf
```

The PDF is a scanned image; `pdftotext` produced no text. I rendered it to PNG pages and read the
theorem statements from the page images.

Visible page facts used:

- page 1 abstract: all values `k` for which a complete `k`-arc exists in `PG(2,q)`, `17 <= q <=
  23`, are determined.
- rendered PDF page 8, Theorem 5.1: q=23 spectrum is `{10, 12, 13, 14, 15, 16, 17, 24}`.
- same proof: `n_2(2,23)=10`; up to projectivity there is a unique 10-arc; no complete 11-arcs
  were found in the exhaustive search.
- rendered PDF page 9: existence and uniqueness of the complete 24-arc.

Commands:

```bash
curl -L --fail --silent --show-error \
  "https://combinatorialpress.com/article/ars/Volume%20047/volume_47_paper-1.pdf" \
  -o /tmp/faina-spectrum-q23.pdf
nix shell nixpkgs#poppler-utils -c pdftotext \
  /tmp/faina-spectrum-q23.pdf /tmp/faina-spectrum-q23.txt
wc -l /tmp/faina-spectrum-q23.txt
mkdir -p /tmp/faina-pages
nix shell nixpkgs#poppler-utils -c pdftoppm -png -r 180 \
  /tmp/faina-spectrum-q23.pdf /tmp/faina-pages/page
```

Observed:

```text
0 /tmp/faina-spectrum-q23.txt
```

So the scan was inspected via:

```text
/tmp/faina-pages/page-1.png ... /tmp/faina-pages/page-9.png
```

### MMP q=25 ScienceDirect abstract

Accessible abstract page:

```text
https://www.sciencedirect.com/science/article/pii/S0012365X06008016
```

Visible abstract facts used:

- in `PG(2,25)`, the smallest size of a complete arc is 12;
- complete 19-arcs and 20-arcs do not exist;
- the number of non-equivalent complete 12-arcs is 606.

### MMP-min arXiv table

Accessible PDF:

```text
https://arxiv.org/pdf/1005.3412
```

Command:

```bash
curl -L --fail --silent --show-error https://arxiv.org/pdf/1005.3412 \
  -o /tmp/minimal-complete-arcs-q32.pdf
nix shell nixpkgs#poppler-utils -c pdftotext \
  /tmp/minimal-complete-arcs-q32.pdf /tmp/minimal-complete-arcs-q32.txt
sed -n '60,140p' /tmp/minimal-complete-arcs-q32.txt
```

Extracted table confirms:

- `q=23`, `t(2,q)=10`, `1` smallest class;
- `q=25`, `t(2,q)=12`, `606` smallest classes;
- `q=27`, `7` smallest classes;
- `q=29`, `708` smallest classes.

The text extraction splits the PGL/PΓL count columns awkwardly, but the q=23 and q=25 entries agree
with the spectrum/ScienceDirect sources and were used only as cross-checks for smallest-class
counts.

### q=31 Coolsaet abstract/snippet

Full Wiley page is Cloudflare-challenged from shell; Crossref has bibliographic metadata but no
abstract for DOI `10.1002/jcd.21410`.

Command:

```bash
python3 - <<'PY'
import json, urllib.request
for doi in ['10.1002/jcd.21410','10.1002/jcd.20211']:
    url='https://api.crossref.org/works/'+doi
    with urllib.request.urlopen(url, timeout=10) as r:
        data=json.load(r)['message']
    print('DOI', doi)
    for k in ['title','container-title','published-print','page','abstract']:
        print(k, data.get(k))
    print()
PY
```

Output excerpt:

```text
DOI 10.1002/jcd.21410
title ['The Complete Arcs of PG(2,31)']
container-title ['Journal of Combinatorial Designs']
published-print {'date-parts': [[2015, 12]]}
page 522-533
abstract None
```

Search-visible abstract/snippet used only for the single correction already quoted in O1's source
survey:

```text
there are 12 complete 22-arcs in PG(2,31) up to projective equivalence, and not 11
```

No other q=31 table cells were filled.

## Not filled

- [CS-2325] full q=23/q=25 per-size count tables remain inaccessible.
- [Cool-31] full q=31 spectrum/count tables remain inaccessible.
- [Keri] large-size tables remain inaccessible.

## Files touched

```text
notes/2026-07-07-arc-census-o1.md
notes/2026-07-07-codex-arc-census-fill.md
notes/2026-07-07-codex-task-queue.md
```
