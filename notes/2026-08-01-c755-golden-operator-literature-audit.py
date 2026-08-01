#!/usr/bin/env python3
"""C755 literature-audit evidence checker (lane: golden).

Replay, from the repository root:

    python3 notes/2026-08-01-c755-golden-operator-literature-audit.py --check

What --check certifies
----------------------
1. Every source the C755 report calls cached is present in the shared lit-search
   cache at the recorded SHA-256 and byte count, recomputed from the blob on disk.
   A mismatch, or a missing blob, is a HARD FAILURE.
2. Every pinned arXiv identifier still resolves to a record whose title matches
   the one recorded.  A mismatch is a HARD FAILURE (a mis-resolved seed silently
   redirects a whole forward tree).

What it reports but does not fail on
------------------------------------
3. Citation counts from OpenAlex, Crossref and Semantic Scholar.  These are not
   stable artifacts; drift from the 2026-08-01 snapshot is informational.

What it does NOT certify
------------------------
Read depth, the audit verdicts, or that any search was exhaustive.  Those live in
the prose report and are not machine-checkable.  The trusted boundary is the
shared cache's own integrity discipline plus the three service APIs.

Network steps are skipped with --offline; the cache check still runs.
"""

import argparse
import hashlib
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
EVIDENCE = os.path.join(HERE, "2026-08-01-c755-golden-operator-literature-audit.json")
UA = "c755-audit/1.0 (mailto:tavisrudd@damnsimple.com)"
TIMEOUT = 60


def key_to_path(cache_root, key):
    return os.path.join(cache_root, "pdf", key.replace("/", "_").replace(":", "_") + ".pdf")


def sha256_of(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def check_cache(ev):
    root = ev["cache_root"]
    failures = []
    for s in ev["sources"]:
        path = key_to_path(root, s["key"])
        if not os.path.exists(path):
            failures.append("MISSING blob: %s -> %s" % (s["key"], path))
            continue
        size = os.path.getsize(path)
        if size != s["bytes"]:
            failures.append("BYTES  %s: recorded %d, on disk %d" % (s["key"], s["bytes"], size))
            continue
        got = sha256_of(path)
        if got != s["sha256"]:
            failures.append("SHA256 %s: recorded %s, on disk %s" % (s["key"], s["sha256"], got))
        else:
            print("  ok   %-34s %s" % (s["key"], s["read_depth"]))
    return failures


def fetch(url, headers=None):
    req = urllib.request.Request(url, headers=headers or {"User-Agent": UA})
    return urllib.request.urlopen(req, timeout=TIMEOUT).read()


def check_arxiv(ev):
    ids = ev["arxiv_identifier_resolution"]["ids"]
    url = "https://export.arxiv.org/api/query?id_list=%s&max_results=%d" % (
        ",".join(ids), len(ids))
    try:
        root = ET.fromstring(fetch(url))
    except Exception as exc:  # noqa: BLE001 - an error is not an empty result
        return ["ARXIV QUERY ERROR (not a negative result): %r" % (exc,)]
    ns = {"a": "http://www.w3.org/2005/Atom"}
    seen = {}
    for entry in root.findall("a:entry", ns):
        eid = entry.findtext("a:id", default="", namespaces=ns)
        title = " ".join((entry.findtext("a:title", default="", namespaces=ns)).split())
        for want in ids:
            if want in eid:
                seen[want] = title
    failures = []
    for want, title in ids.items():
        got = seen.get(want)
        if got is None:
            failures.append("ARXIV %s: no record returned" % want)
        elif got.lower() != title.lower():
            failures.append("ARXIV %s: recorded %r, returned %r" % (want, title, got))
        else:
            print("  ok   arXiv:%-12s %s" % (want, title[:60]))
    return failures


def counts_for(doi):
    out = {}
    try:
        d = json.loads(fetch("https://api.openalex.org/works/doi:%s?select=cited_by_count" % doi))
        out["openalex"] = d["cited_by_count"]
    except Exception as exc:  # noqa: BLE001
        out["openalex"] = "ERROR %r" % (exc,)
    try:
        d = json.loads(fetch("https://api.crossref.org/works/%s" % doi))
        out["crossref"] = d["message"].get("is-referenced-by-count")
    except Exception as exc:  # noqa: BLE001
        out["crossref"] = "ERROR %r" % (exc,)
    try:
        d = json.loads(fetch(
            "https://api.semanticscholar.org/graph/v1/paper/DOI:%s?fields=citationCount" % doi))
        out["semantic_scholar"] = d.get("citationCount")
    except Exception as exc:  # noqa: BLE001
        out["semantic_scholar"] = "ERROR %r" % (exc,)
    return out


def report_counts(ev):
    for rec in ev["citation_counts_2026_08_01"]:
        doi = rec["seed_doi"]
        now = counts_for(doi)
        print("  seed %s" % doi)
        for svc in ("openalex", "crossref", "semantic_scholar"):
            was, is_ = rec[svc], now[svc]
            flag = "" if was == is_ else "   <- drift from the 2026-08-01 snapshot"
            print("    %-17s snapshot %-6s now %s%s" % (svc, was, is_, flag))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true", help="run the checks (default)")
    ap.add_argument("--offline", action="store_true", help="skip every network step")
    args = ap.parse_args()

    with open(EVIDENCE) as fh:
        ev = json.load(fh)

    failures = []

    print("[1/3] cached-source integrity (hard)")
    if not os.path.isdir(ev["cache_root"]):
        failures.append("CACHE ROOT MISSING: %s (this is 'could not access', not a pass)"
                        % ev["cache_root"])
    else:
        failures += check_cache(ev)

    print("[2/3] pinned arXiv identifier resolution (hard)")
    if args.offline:
        print("  skipped (--offline)")
    else:
        failures += check_arxiv(ev)

    print("[3/3] three-service citation counts (informational)")
    if args.offline:
        print("  skipped (--offline)")
    else:
        report_counts(ev)

    if failures:
        print("\nFAIL (%d)" % len(failures))
        for f in failures:
            print("  " + f)
        return 1
    print("\nPASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
