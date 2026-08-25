#!/usr/bin/env python3
"""Fail-closed provenance and checksum checks for the manuscript."""

import hashlib
import json
import re
import sys
from pathlib import Path

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "cubic_stabilization_irrationality.tex"
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
zenodo = json.loads((ROOT / ".zenodo.json").read_text(encoding="utf-8"))
readme = (ROOT / "README.md").read_text(encoding="utf-8")

title_match = re.search(r"\\title\{([^}]+)\}", text)
assert title_match and zenodo["title"] == title_match.group(1)
assert readme.splitlines()[0] == f"# {zenodo['title']}"
assert zenodo["upload_type"] == "publication"
assert zenodo["publication_type"] == "preprint"
assert zenodo["access_right"] == "open"
assert zenodo["license"] == "cc-by-4.0"
assert zenodo["language"] == "eng"
assert zenodo["creators"] == [{
    "name": "Rudd, Tavis",
    "orcid": "0009-0003-6405-3275",
    "affiliation": "Independent researcher",
}]
assert {item["identifier"] for item in zenodo["related_identifiers"]} == {
    "https://doi.org/10.48550/arXiv.2608.20029",
    "https://doi.org/10.5281/zenodo.21909943",
    "https://doi.org/10.48550/arXiv.2507.15704",
}
assert "cubic threefolds" in zenodo["keywords"]
assert "levels of stable rationality" in zenodo["keywords"]
assert "https://doi.org/10.5281/zenodo.21937490" not in readme
assert re.search(r"No archival DOI is claimed for this\s+revision\.", readme)
assert "(cubic_stabilization_irrationality.pdf)" in readme
for relative in (
    "cubic_stabilization_irrationality.tex",
    "cubic_stabilization_irrationality.pdf",
    "LICENSE",
    "flake.nix",
    "flake.lock",
    "verification/slice-cover-certificate.json",
    "verification/slice-cover-values.tex",
    "verification/derive_slice_cover.py",
    "verification/check_slice_cover.py",
):
    assert (ROOT / relative).is_file() and relative in readme
assert text.count(r"\input{verification/slice-cover-values}") == 1
normalized_tex = " ".join(text.split())
placed_artifacts = (
    r"is saturated and Galois stable. The two generators act on this basis by \[ \IThreeActionOne, \qquad \IThreeActionTwo. \]",
    r"Four blocks of Cox generators have the following projective \(T_3\)-weights: \begin{center} \IThreeWeightTable \end{center}",
    r"B=\PP\langle\IThreeBoundaryGenerators\rangle.",
    r"The following exact choices are used; \(e=(e_1,\ldots,e_5)\) and \(z'\) specify the second Cox point at which the evaluation matrix is tested. \begin{center} \SliceWitnessTable \end{center}",
    r"After discarding nonzero rational factors, the four evaluation determinants are \SliceDeterminants and the corresponding smoothness minors are \SliceMinors",
    r"A lexicographic Gr\"obner calculation in \(\mathbf Q[a,b,h]/(h\Delta-1)\) gives \SliceCoverArithmetic Thus \(D_4M_4\ne0\)",
)
for snippet in placed_artifacts:
    assert normalized_tex.count(snippet) == 1, snippet
stale = re.compile(r"INT[-_ ]?Psi|all[- ]m|quantum.?D|marked block|conditional", re.I)
assert not stale.search(json.dumps(zenodo))
assert not stale.search(readme)

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
        assert claims[label][key] == value, (
            label,
            key,
            claims[label][key],
            value,
        )
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
