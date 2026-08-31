#!/usr/bin/env python3
"""Summarise the certdist acceptance sweep into markdown tables."""
import json
import os
import sys

CD = os.path.expanduser("~/.cache/ergodis/certdist")
SPECS = [
    ("r1elite01", 16, 18),
    ("r1elite02", 16, 16),
    ("r3elite01", 14, 16),
    ("r3elite02", 14, 14),
    ("r3elitep01", 17, 18),
    ("r3elitep02", 19, 20),
]
# unsharded candidate counts from notes/2026-08-31-c1018-hunt-qldpc-sweep.md
UNSHARDED = {
    ("r1elite01", "x"): 764931405,
    ("r1elite01", "z"): 2019824133,
    ("r1elite02", "x"): 270913307,
    ("r1elite02", "z"): 1898939462,
    ("r3elite01", "x"): 1845032259,
    ("r3elite01", "z"): 3620460887,
    ("r3elite02", "x"): 898767944,
    ("r3elite02", "z"): 3543088140,
    ("r3elitep01", "x"): 802548070,
    ("r3elitep01", "z"): 1061591915,
    ("r3elitep02", "x"): 7948318726,
    ("r3elitep02", "z"): 13405995220,
}


def metrics(job):
    rows = [json.loads(line) for line in open(os.path.join(job, "metrics.jsonl"))]
    shard = [r for r in rows if r["step"] == "shard"]
    upper = [r for r in rows if r["step"] == "upper"]
    comp = [r for r in rows if r["step"] == "compile"]
    return shard, upper, comp


print("| code | side | radius | shards | search s | wall s | shard overhead s | peak shard RSS MiB | upper pass s | candidates (sharded) | candidates (one shot) | inflation |")
print("|:---|:--|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
for code, radius, _ in SPECS:
    for side in ("x", "z"):
        job = f"{CD}/jobs/{code}-{side}"
        shard, upper, comp = metrics(job)
        cert = json.load(open(f"{job}/certificate.json"))
        level = cert["levels"][0]
        se = sum(r["search_seconds"] for r in shard)
        wa = sum(r["wall_seconds"] for r in shard)
        rss = max(r["peak_rss_kib"] for r in shard) / 1024.0
        up = sum(r["wall_seconds"] for r in upper)
        cand = level["total_candidates"]
        one = UNSHARDED[(code, side)]
        print(
            f"| {code} | {side} | {radius} | {level['shard_count']} | {se:.1f} | {wa:.1f} | "
            f"{wa - se:.1f} | {rss:.1f} | {up:.1f} | {cand:,} | {one:,} | {100*(cand-one)/one:+.2f}% |"
        )

print()
print("| code | side | lower | upper | side verdict | witness source |")
print("|:---|:--|---:|---:|:---|:---|")
for code, radius, _ in SPECS:
    for side in ("x", "z"):
        cert = json.load(open(f"{CD}/jobs/{code}-{side}/certificate.json"))
        b = cert["bracket"]
        src = "enumeration" if "enumeration" in b["upper_provenance"] else (
            "builtin-osd" if "builtin-osd" in b["upper_provenance"] else "none")
        verdict = f"d = {b['upper']}" if b["exact"] else (
            f"{b['lower']} <= d <= {b['upper']}" if b["upper"] else f"d >= {b['lower']}")
        print(f"| {code} | {side} | {b['lower']} | {b['upper']} | {verdict} | {src} |")

print()
print("| code | published QDistRnd bound | committed exact value | certdist verdict | match |")
print("|:---|---:|---:|:---|:--|")
for code, radius, d in SPECS:
    comb = json.load(open(f"{CD}/jobs/{code}-combined.json"))
    ok = comb["exact"] and comb["upper"] == d
    print(f"| {code} | <= {d} | {d} | d = {comb['upper']} (exact) | {'yes' if ok else 'NO'} |")
