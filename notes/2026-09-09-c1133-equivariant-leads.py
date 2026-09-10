#!/usr/bin/env python3
"""Verify pinned primary metadata snapshots; no mathematical inference or fetch."""
import hashlib
import json
from pathlib import Path

MANIFEST = Path(__file__).with_suffix(".json")
URLS = {
    "ckga-papers": "https://icms.bg/ckga/ckga-papers/",
    "lee-publications": "https://sites.google.com/site/kyoungseogleemath/publications-and-preprints",
    "equivariant-withdrawn": "https://arxiv.org/abs/2405.07322v4",
    "atoms-meet-symbols": "https://arxiv.org/abs/2509.15831v4",
}


def main():
    manifest = json.loads(MANIFEST.read_text())
    assert set(manifest["records"]) == set(URLS)
    for name, url in URLS.items():
        record = manifest["records"][name]
        assert record["url"] == url
        assert record["status"] == "retrieved"
        data = Path(record["cache"]).read_bytes()
        assert len(data) == record["bytes"]
        assert hashlib.sha256(data).hexdigest() == record["sha256"]
    print("PASS: four pinned primary HTML snapshots; metadata/abstract depth only")


if __name__ == "__main__":
    main()
