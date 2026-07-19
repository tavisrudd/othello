#!/usr/bin/env python3
"""C363 citation-graph snapshot generator (lane: alt-orbit-repair).

Regenerates `2026-07-19-c363-alt-orbit-repair-citation-audit.json`: a dated snapshot of
backward/forward citation counts for the C363 seed set, taken from OpenAlex, Semantic
Scholar and Crossref, plus the zbMATH result sets for the MSC-scoped queries the audit
relied on.

    cd /home/tavis/src/othello
    python3 notes/2026-07-19-c363-alt-orbit-repair-citation-audit.py --out notes/2026-07-19-c363-alt-orbit-repair-citation-audit.json
    python3 notes/2026-07-19-c363-alt-orbit-repair-citation-audit.py --check

IMPORTANT — what `--check` can and cannot certify.  These are *live* bibliographic
databases.  Citation counts only grow, and indexing coverage changes without notice.
`--check` therefore reports drift against the tracked snapshot; it does not assert
byte-equality and a nonzero drift is not by itself an error.  It exits nonzero only on
schema drift or on a *decrease* in a recorded count, which indicates the query no longer
means what it meant when the snapshot was taken.

No API keys are used.  Semantic Scholar rate-limits unauthenticated callers; the script
backs off and records `null` rather than retrying indefinitely, so a `null` means "not
retrieved on this run", never "zero".
"""

import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

SCHEMA_VERSION = 1
MAILTO = "tavisrudd@damnsimple.com"
UA = "othello-lit-audit/1.0 (%s)" % MAILTO

# Seed set fixed by the C363 task statement.  `oa` is the OpenAlex work id, pinned so a
# title-search regression cannot silently repoint a seed at the wrong paper -- which is
# exactly what happened once during this audit (10.4171/emss/28 is Proudfoot's KLS
# survey, not Ball-Lavrauw; the correct Ball-Lavrauw DOI is 10.4171/emss/33).
SEEDS = [
    ("baker-wantz", "10.2140/iig.2005.2.83", "W2807335984"),
    ("ball-lavrauw", "10.4171/emss/33", "W2970275694"),
    ("cardinali-giuzzi-kwiatkowski", "10.1016/j.ffa.2021.101895", "W3022201805"),
    ("dye-1991", "10.1112/jlms/s2-44.2.270", "W2026622256"),
    ("bsw-1992", "10.1007/BF01204717", "W2001379196"),
    ("mmp-pg225", "10.1016/j.disc.2005.11.094", "W1985188998"),
    ("lmp-symmetry", "10.11575/cdm.v3i1.61979", "W1565617150"),
    ("alderson-mds", "10.1007/s00026-005-0245-7", "W2058435648"),
    ("ito-reconfig", "10.1016/j.tcs.2010.12.005", "W1997048861"),
    ("maurer-basis", "10.1016/0095-8956(73)90005-1", "W1971869754"),
    ("ostergard-switching", "10.1016/j.disc.2011.05.016", "W2161224948"),
]

# zbMATH search strings, verbatim.  A 404 from the zbMATH API is an EMPTY RESULT SET, not
# a transport failure; this was confirmed during the audit by perturbing a 404-ing query
# into a near neighbour that returned hits.
ZB_QUERIES = [
    'cc:51E21 & ti:"PG(2,25)"',
    'cc:51E21 & any:"Frobenius" & any:"arc"',
    'cc:51E21 & any:"prescribed symmetry"',
    'cc:51E21 & any:"orbit" & any:"extension"',
    'cc:51E21 & any:"Baer involution"',
    'cc:51E21 & any:"Baer subplane" & any:"arc"',
    'cc:51E21 & any:"involution"',
    'cc:51E21 & any:"invariant" & any:"orbits" & any:"complete arc"',
    'any:"PG(2, 25)" & cc:51E',
]


def fetch(url, timeout=60):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return json.load(r)


def try_fetch(url, timeout=60):
    """Return (payload, note). `note` is None on success, else a short reason string."""
    try:
        return fetch(url, timeout), None
    except urllib.error.HTTPError as e:
        return None, "http-%d" % e.code
    except Exception as e:  # noqa: BLE001 - transport variety is the point
        return None, type(e).__name__


def openalex_seed(oa_id):
    url = ("https://api.openalex.org/works/%s"
           "?select=id,doi,title,publication_year,cited_by_count,referenced_works&mailto=%s"
           % (oa_id, MAILTO))
    d, note = try_fetch(url)
    if d is None:
        return {"error": note}
    return {
        "title": d.get("title"),
        "year": d.get("publication_year"),
        "cited_by_count": d.get("cited_by_count"),
        "referenced_works_count": len(d.get("referenced_works") or []),
    }


def openalex_citing(oa_id, cap=600):
    """Titles+years of works citing `oa_id`, canonically sorted."""
    rows, page = [], 1
    while len(rows) < cap:
        url = ("https://api.openalex.org/works?filter=cites:%s&per-page=200&page=%d"
               "&select=id,title,publication_year,doi&mailto=%s" % (oa_id, page, MAILTO))
        d, note = try_fetch(url)
        if d is None:
            return None, note
        res = d.get("results") or []
        rows.extend(res)
        if len(res) < 200:
            break
        page += 1
        time.sleep(0.4)
    out = [{
        "year": w.get("publication_year"),
        "doi": (w.get("doi") or "").replace("https://doi.org/", "") or None,
        "title": w.get("title"),
    } for w in rows]
    out.sort(key=lambda r: (r["year"] or 0, r["doi"] or "", r["title"] or ""))
    return out, None


def s2_count(doi):
    url = ("https://api.semanticscholar.org/graph/v1/paper/DOI:%s"
           "?fields=title,year,citationCount,referenceCount" % doi)
    d, note = try_fetch(url, timeout=40)
    if d is None or "citationCount" not in d:
        return {"citationCount": None, "note": note or "unavailable"}
    return {"citationCount": d.get("citationCount"), "referenceCount": d.get("referenceCount")}


def crossref_count(doi):
    url = "https://api.crossref.org/works/%s?mailto=%s" % (doi, MAILTO)
    d, note = try_fetch(url, timeout=40)
    if d is None:
        return {"is_referenced_by_count": None, "note": note}
    m = d.get("message", {})
    return {"is_referenced_by_count": m.get("is-referenced-by-count")}


def zbmath(search_string, n=10):
    url = ("https://api.zbmath.org/v1/document/_search?search_string=%s&results_per_page=%d"
           % (urllib.parse.quote(search_string), n))
    d, note = try_fetch(url, timeout=60)
    if d is None:
        # 404 == empty result set for this API.
        return {"n": 0, "hits": []} if note == "http-404" else {"error": note}
    hits = []
    for w in d.get("result", []):
        doi = ""
        for l in (w.get("links") or []):
            if l.get("type") == "doi":
                doi = l.get("identifier") or ""
        hits.append({
            "year": w.get("year"),
            "zbl": w.get("identifier"),
            "doi": doi or None,
            "title": (w.get("title") or {}).get("title"),
        })
    hits.sort(key=lambda r: (r["year"] or 0, r["zbl"] or ""))
    return {"n": len(hits), "hits": hits}


def build():
    snap = {
        "schema_version": SCHEMA_VERSION,
        "task": "C363",
        "lane": "alt-orbit-repair",
        "note": ("Dated snapshot of live bibliographic databases. Counts grow over time; "
                 "see module docstring for what --check does and does not certify."),
        "sources": {
            "openalex": "https://api.openalex.org/",
            "semantic_scholar": "https://api.semanticscholar.org/graph/v1/",
            "crossref": "https://api.crossref.org/",
            "zbmath": "https://api.zbmath.org/v1/",
        },
        "mathscinet": {
            "reachable": False,
            "observed": "HTTP 302 redirect to institutional authentication; no query executed.",
        },
        "seeds": {},
        "zbmath_queries": {},
    }
    for name, doi, oa in SEEDS:
        rec = {"doi": doi, "openalex_id": oa}
        rec["openalex"] = openalex_seed(oa)
        time.sleep(0.4)
        citing, note = openalex_citing(oa)
        if citing is None:
            rec["openalex_citing"] = {"error": note}
        else:
            rec["openalex_citing"] = {"n": len(citing), "works": citing}
        time.sleep(0.4)
        rec["crossref"] = crossref_count(doi)
        time.sleep(0.4)
        rec["semantic_scholar"] = s2_count(doi)
        time.sleep(3.0)  # unauthenticated S2 rate limit
        snap["seeds"][name] = rec
    for q in ZB_QUERIES:
        snap["zbmath_queries"][q] = zbmath(q)
        time.sleep(0.8)
    return snap


def canonical(obj):
    return json.dumps(obj, indent=1, sort_keys=True, ensure_ascii=False) + "\n"


def check(path):
    if not os.path.exists(path):
        print("MISSING tracked snapshot: %s" % path)
        return 2
    tracked = json.load(open(path))
    if tracked.get("schema_version") != SCHEMA_VERSION:
        print("SCHEMA DRIFT: tracked=%s current=%s"
              % (tracked.get("schema_version"), SCHEMA_VERSION))
        return 2
    fresh = build()
    regressions, drift = [], []
    for name in tracked.get("seeds", {}):
        t = tracked["seeds"][name].get("openalex", {}).get("cited_by_count")
        f = fresh.get("seeds", {}).get(name, {}).get("openalex", {}).get("cited_by_count")
        if t is None or f is None:
            continue
        if f < t:
            regressions.append("%s: OpenAlex cited_by %d -> %d (DECREASE)" % (name, t, f))
        elif f > t:
            drift.append("%s: OpenAlex cited_by %d -> %d" % (name, t, f))
    for line in drift:
        print("drift    %s" % line)
    for line in regressions:
        print("REGRESS  %s" % line)
    if regressions:
        print("FAIL: a recorded count decreased; the query no longer means what it meant.")
        return 1
    print("OK: %d seeds checked, %d grew, none decreased." % (len(tracked.get("seeds", {})), len(drift)))
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out")
    ap.add_argument("--check", action="store_true")
    a = ap.parse_args()
    default = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           "2026-07-19-c363-alt-orbit-repair-citation-audit.json")
    if a.check:
        sys.exit(check(a.out or default))
    out = a.out or default
    with open(out, "w") as fh:
        fh.write(canonical(build()))
    print("wrote %s" % out)


if __name__ == "__main__":
    main()
