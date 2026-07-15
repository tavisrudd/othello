#!/usr/bin/env python3
"""C191 instrument calibration — Edge 1956 citer closure across three independent indexes.

The gap-mining method (notes/2026-07-15-gems-theory-gaps-method.md, § Instruments) leads with
object-level citation closure and flags the risk that OpenAlex under-indexes mid-century citations,
so a classical seed can read empty for a real gap and for an indexing artifact alike. Its § First
steps demands a NON-CIRCULAR calibration: Edge 1956's citers by a route that does not pass through
OpenAlex, diffed against the OpenAlex closure.

Seed: W. L. Edge, "Conics and orthogonal projectivities in a finite plane",
      Canad. J. Math. 8 (1956) 362-382.
      DOI 10.4153/CJM-1956-041-6 | OpenAlex W2319208930 | Zbl 0072.38102 (internal id 3121304)

Three independent routes:
  1. OpenAlex   — the instrument under test.
  2. zbMATH Open — independent (Zentralblatt's own reference capture). NOTE: the API's `rf:` field
     keys on the INTERNAL document id (3121304), not the Zbl code (0072.38102); `rf:0072.38102`
     returns 404 "Entry not found", which is an unsupported-field error and NOT an empty result.
     Controlled: `rf:` 404s for every Zbl-code id tried, while `an:` returns 200.
  3. Semantic Scholar — independent (own PDF reference extraction).

MathSciNet is the method's other named route and is subscription-gated; not queried here.

Run: python3 notes/2026-07-15-c191-instrument-calibration.py
No dependencies beyond the stdlib. Network required; each index is queried live.
"""

import json
import sys
import urllib.parse
import urllib.request

MAILTO = "tavisrudd@damnsimple.com"
DOI = "10.4153/cjm-1956-041-6"
OPENALEX_ID = "W2319208930"
ZBMATH_INTERNAL_ID = "3121304"  # NOT the Zbl code 0072.38102 -- see module docstring
TIMEOUT = 60

# Semantic Scholar returns bibliography compilations as citers. These are BibTeX files maintained
# by N. H. F. Beebe, not documents that cite Edge in any mathematical sense. Excluded as artifacts.
S2_ARTIFACT_MARKERS = ("Title word cross-reference", "for the decade")


def get(url):
    req = urllib.request.Request(url, headers={"User-Agent": f"c191-calibration ({MAILTO})"})
    with urllib.request.urlopen(req, timeout=TIMEOUT) as r:
        return json.loads(r.read().decode())


def is_self(authors):
    """True if W. L. Edge is among the citing work's authors."""
    return "edge" in (authors or "").lower()


def openalex_citers():
    url = (
        f"https://api.openalex.org/works?filter=cites:{OPENALEX_ID}"
        f"&per-page=200&mailto={MAILTO}"
    )
    d = get(url)
    out = []
    for w in d["results"]:
        loc = w.get("primary_location") or {}
        src = loc.get("source") or {}
        authors = ", ".join(
            a["author"]["display_name"] for a in w.get("authorships", [])
        )
        out.append(
            (w.get("publication_year"), src.get("display_name"), w.get("display_name"), authors)
        )
    return d["meta"]["count"], out


def zbmath_citers():
    q = urllib.parse.quote(f"rf:{ZBMATH_INTERNAL_ID}")
    url = f"https://api.zbmath.org/v1/document/_search?search_string={q}&page=0&results_per_page=100"
    d = get(url)
    status = d.get("status", {})
    out = []
    for w in d.get("result") or []:
        series = (w.get("source") or {}).get("series") or []
        venue = series[0].get("short_title") if series else None
        authors = ", ".join(
            a.get("name", "") for a in ((w.get("contributors") or {}).get("authors") or [])
        )
        out.append((w.get("year"), venue, (w.get("title") or {}).get("title"), authors))
    return status.get("nr_total_results"), out


def s2_citers():
    url = (
        f"https://api.semanticscholar.org/graph/v1/paper/DOI:{DOI}/citations"
        f"?fields=title,year,venue,authors&limit=100"
    )
    d = get(url)
    real, artifacts = [], []
    for c in d.get("data", []):
        p = c.get("citingPaper", {})
        title = p.get("title") or ""
        authors = ", ".join(a.get("name", "") for a in (p.get("authors") or []))
        row = (p.get("year"), p.get("venue") or None, title, authors)
        if any(m in title for m in S2_ARTIFACT_MARKERS):
            artifacts.append(row)
        else:
            real.append(row)
    return real, artifacts


def main():
    print("=" * 78)
    print("C191 instrument calibration -- citers of Edge 1956 across three indexes")
    print("=" * 78)

    def show(rows):
        for y, v, t, a in sorted(rows, key=lambda r: (r[0] or 0)):
            tag = "  <-- SELF-CITATION (Edge)" if is_self(a) else ""
            print(f"    {y} | {v} | {t}  [{a}]{tag}")

    oa_count, oa = openalex_citers()
    oa_self = [r for r in oa if is_self(r[3])]
    print(f"\n[1] OpenAlex (instrument under test): {oa_count} citers")
    show(oa)

    zb_total, zb = zbmath_citers()
    zb_self = [r for r in zb if is_self(r[3])]
    print(f"\n[2] zbMATH Open (independent): {zb_total} citers  [record page reads 'Cited in 3 Documents']")
    show(zb)

    s2_real, s2_art = s2_citers()
    s2_self = [r for r in s2_real if is_self(r[3])]
    print(f"\n[3] Semantic Scholar (independent): {len(s2_real)} real + {len(s2_art)} artifacts")
    show(s2_real)
    print("    -- excluded as bibliography artifacts --")
    for y, v, t, a in s2_art:
        print(f"    {y} | {t}  [{a}]")

    print("\n" + "-" * 78)
    print("VERDICT INPUTS")
    print("-" * 78)
    print(f"  OpenAlex        : {oa_count} raw, {len(oa_self)} self-cites -> {oa_count - len(oa_self)} independent")
    print(f"  zbMATH          : {zb_total} raw, {len(zb_self)} self-cites -> {zb_total - len(zb_self)} independent")
    print(f"  SemanticScholar : {len(s2_real)} raw, {len(s2_self)} self-cites -> {len(s2_real) - len(s2_self)} independent")
    print("  No index is a superset of the others; see the report for the union table.")
    print("  Coding-venue citers found, any index: 0")


if __name__ == "__main__":
    sys.exit(main())
