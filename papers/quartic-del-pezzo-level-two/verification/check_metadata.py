#!/usr/bin/env python3
"""Fail-closed provenance and checksum checks for the manuscript."""

import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "quartic_del_pezzo_level_two.tex"
text = SOURCE.read_text(encoding="utf-8")


def identifiers(macro):
    values = []
    for match in re.finditer(r"\\"+macro+r"\{([^}]*)\}", text):
        values.extend(value.strip() for value in match.group(1).split(",") if value.strip())
    return values


labels = set(re.findall(r"\\label\{([^}]+)\}", text))
bibitems = set(re.findall(r"\\bibitem\{([^}]+)\}", text))
imports = json.loads((ROOT / "verification/imported-sources.json").read_text())
evidence = json.loads((ROOT / "verification/evidence.json").read_text())
claims = json.loads((ROOT / "verification/claim-map.json").read_text())

assert set(identifiers("imports")) <= set(imports)
assert set(identifiers("evidence")) <= set(evidence)
assert set(identifiers("uses")) <= labels
for record in imports.values():
    assert record["citation"] in bibitems
    assert record["pinpoint"] and record["used"] and record["conventions"]
    for convention in record["conventions"]:
        assert set(convention) == {"aspect", "matched", "requirement"}
        assert all(convention.values())

statement_pattern = re.compile(
    r"\\begin\{(theorem|proposition|lemma|corollary|remark)\}(.*?)"
    r"\\end\{\1\}",
    re.S,
)
statements = {}
for environment, body in statement_pattern.findall(text):
    label_match = re.search(r"\\label\{([^}]+)\}", body)
    if label_match is None:
        raise AssertionError(f"unlabelled {environment}")
    label = label_match.group(1)
    coverage = re.findall(r"\\coverage\{([^}]+)\}", body)
    assert coverage == ["absent"], (label, coverage)
    assert "\\lean{" not in body
    normalized = re.sub(
        r"\\(?:coverage|lean|uses|imports|evidence|proves)\{[^}]*\}%?", "", body
    )
    normalized = " ".join(normalized.split())
    statements[label] = {
        "coverage": coverage[0],
        "digest": hashlib.sha256(normalized.encode()).hexdigest(),
        "environment": environment,
    }

assert set(statements) == set(claims)
for label, statement in statements.items():
    for key, value in statement.items():
        assert claims[label][key] == value, (label, key)
    assert claims[label]["declarations"] == []
    for key in ("objects", "hypotheses", "conclusion", "cautions"):
        assert claims[label][key]

for record in evidence.values():
    manifest = ROOT / record["checksum_manifest"]
    assert manifest.is_file() and record["role"] and record["commands"]
    for line in manifest.read_text().splitlines():
        if not line.strip():
            continue
        expected, relative = line.split(maxsplit=1)
        path = ROOT / relative.strip()
        assert path.is_file(), path
        assert hashlib.sha256(path.read_bytes()).hexdigest() == expected, path

print("metadata and checksums: ok")
