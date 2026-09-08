"""Shared provenance helpers for the manuscript's six empty TeX macros.

Digests bind reviewed prose to statement text and Lean source signatures.
They do not elaborate Lean or establish that a citation proves its recorded use.
"""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

PAPER = Path(__file__).resolve().parents[1]
MACROS = ("coverage", "lean", "uses", "proves", "imports", "evidence")
ENV = re.compile(r"\\begin\{(theorem|proposition|lemma|corollary)\}(.*?)\\end\{\1\}", re.S)
PROOF = re.compile(r"\\begin\{proof\}(.*?)\\end\{proof\}", re.S)


def clean(text: str) -> str:
    return re.sub(r"(?m)(?<!\\)%.*$", "", text)


def manuscript_paths() -> list[Path]:
    """Resolve the actual input tree, so an unreferenced section cannot count."""
    found: list[Path] = []
    def visit(path: Path) -> None:
        path = path.resolve()
        if not path.is_relative_to(PAPER) or not path.is_file():
            raise SystemExit("manuscript input does not resolve inside the paper")
        if path in found:
            raise SystemExit(f"repeated manuscript input: {path.name}")
        found.append(path)
        for name in re.findall(r"\\input\{([^}]+)\}", clean(path.read_text())):
            child = PAPER / name
            visit(child if child.suffix else child.with_suffix(".tex"))
    visit(PAPER / "compositional_recovery.tex")
    return found


def identifiers(body: str, macro: str) -> list[str]:
    matches = re.findall(r"\\" + macro + r"\{([^}]*)\}", clean(body), re.S)
    if len(matches) > 1:
        raise SystemExit(f"duplicate annotation: {macro}")
    if not matches:
        return []
    values = [v.strip() for v in matches[0].split(",")]
    if len(values) != len(set(values)) or any(
        not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_:.'-]*", v) for v in values
    ):
        raise SystemExit(f"invalid identifier list in {macro}")
    return values


def statement_digest(body: str) -> str:
    body = clean(body)
    for macro in MACROS:
        body = re.sub(r"\\" + macro + r"\{[^}]*\}", "", body, flags=re.S)
    return hashlib.sha256(" ".join(body.split()).encode()).hexdigest()


def terminal_digest(terminals: list[str]) -> str:
    """Hash explicit theorem signatures and their ambient variable declarations."""
    signatures: dict[str, str] = {}
    source = PAPER / "lean/TavisRuddFiniteGeom/Papers/RecoveryStructures"
    for path in sorted(source.glob("*.lean")):
        text = re.sub(r"/-.*?-/", "", path.read_text(), flags=re.S)
        variables = "\n".join(re.findall(r"(?m)^variable .*", text))
        for match in re.finditer(r"(?ms)^theorem\s+(\w+)\b(.*?)(?=:=)", text):
            signatures[match[1]] = " ".join((variables + match[0]).split())
    try:
        payload = [signatures[name.rsplit(".", 1)[1]] for name in terminals]
    except KeyError as error:
        raise SystemExit(f"missing terminal signature: {error}") from error
    return hashlib.sha256("\n".join(payload).encode()).hexdigest()


def load_registry(name: str, key: str) -> dict:
    data = json.loads((PAPER / "verification" / (name + ".json")).read_text())
    if data.get("schema") != "compositional-recovery-" + name + "-v1":
        raise SystemExit(f"invalid {name} schema")
    if not isinstance(data.get(key), dict):
        raise SystemExit(f"missing {key} registry")
    return data[key]


def graph() -> str:
    colors = {"absent": "#ffffff", "fragment": "#fde8c8",
              "conditional_deduction": "#d6e8f7", "complete": "#cdeccd"}
    nodes, edges, external = {}, set(), set()
    for path in manuscript_paths():
        text = clean(path.read_text())
        for macro in ("imports", "evidence"):
            for payload in re.findall(r"\\" + macro + r"\{([^}]+)\}", text):
                external.update(value.strip() for value in payload.split(","))
        bodies = [(m[2], False) for m in ENV.finditer(text)]
        bodies += [(m[1], True) for m in PROOF.finditer(text)]
        for body, proof in bodies:
            label = (identifiers(body, "proves")[0] if proof else
                     re.search(r"\\label\{([^}]+)\}", body)[1])
            if not proof:
                nodes[label] = colors[identifiers(body, "coverage")[0]]
            for macro in ("uses", "imports", "evidence"):
                for dep in identifiers(body, macro):
                    kind = "solid" if proof else "dashed"
                    edges.add((dep, label, kind if macro == "uses" else "dotted"))
    lines = ['digraph manuscript {', '  rankdir=BT;', '  node [shape=box, style=filled];']
    for node, color in sorted(nodes.items()):
        lines.append(f'  "{node}" [fillcolor="{color}"];')
    for dep in sorted(external):
        lines.append(f'  "{dep}" [shape=note, fillcolor="#eeeeee"];')
    for dep, label, kind in sorted(edges):
        lines.append(f'  "{dep}" -> "{label}" [style={kind}];')
    return "\n".join(lines + ["}", ""])


def check_provenance(data: dict, environments: dict[str, str]) -> None:
    definitions = clean((PAPER / "formal-annotations.tex").read_text())
    empty = re.findall(r"\\newcommand\{\\([a-z]+)\}\[1\]\{\}", definitions)
    if sorted(empty) != sorted(MACROS):
        raise SystemExit("formal macros must be six empty one-argument definitions")
    sources = load_registry("imported-sources", "sources")
    evidence = load_registry("evidence", "evidence")
    bibliography = set(re.findall(r"@\w+\{([^,]+),", (PAPER / "refs.bib").read_text()))
    for name, entry in sources.items():
        for field in ("citation", "pinpoint", "used"):
            if not isinstance(entry.get(field), str) or not entry[field].strip():
                raise SystemExit(f"source {name} missing {field}")
        if entry["citation"] not in bibliography:
            raise SystemExit(f"unknown bibliography key for {name}")
        if not entry.get("conventions"):
            raise SystemExit(f"source {name} has no conventions")
        for convention in entry["conventions"]:
            if any(not convention.get(k) for k in ("aspect", "requirement", "matched")):
                raise SystemExit(f"incomplete convention for {name}")
    for name, entry in evidence.items():
        if not entry.get("role") or not entry.get("commands"):
            raise SystemExit(f"evidence {name} missing role or commands")
        checksum = (PAPER / entry.get("checksum_manifest", "")).resolve()
        if not checksum.is_relative_to(PAPER) or not checksum.is_file():
            raise SystemExit(f"evidence {name} has no safe checksum manifest")
        if checksum.suffix == ".json":
            files = json.loads(checksum.read_text())
            if not files or not isinstance(files, dict):
                raise SystemExit(f"evidence {name} has an empty checksum manifest")
            for relative, identity in files.items():
                file = (checksum.parent / relative).resolve()
                if not file.is_relative_to(PAPER) or not file.is_file():
                    raise SystemExit(f"evidence {name} has an unsafe or missing file")
                contents = file.read_bytes()
                if (identity.get("bytes") != len(contents) or
                        identity.get("sha256") != hashlib.sha256(contents).hexdigest()):
                    raise SystemExit(f"evidence checksum mismatch: {relative}")
    for path in manuscript_paths():
        text = clean(path.read_text())
        # Definitions of the empty macros are not uses of those macros.
        if path.name == "formal-annotations.tex":
            continue
        bodies = [m[2] for m in ENV.finditer(text)] + PROOF.findall(text)
        for body in bodies:
            for macro in MACROS:
                identifiers(body, macro)
        for macro, registry in (("imports", sources), ("evidence", evidence)):
            for payload in re.findall(r"\\" + macro + r"\{([^}]+)\}", text):
                for value in payload.split(","):
                    if value.strip() not in registry:
                        raise SystemExit(f"unknown {macro} identifier: {value.strip()}")
        for body in PROOF.findall(text):
            tail = re.search(r"(?:\s*\\(?:uses|proves|imports|evidence)\{[^}]*\})+\s*$", body)
            if tail is None or any(re.search(r"\\" + m + r"\{", body[:tail.start()])
                                   for m in MACROS):
                raise SystemExit("proof annotations must be together at the end")
    for row in data["claims"]:
        label = row["manuscript_label"]
        for field in ("objects", "hypotheses", "conclusion", "cautions"):
            if not isinstance(row.get(field), str) or not row[field].strip():
                raise SystemExit(f"{label} missing correspondence field {field}")
        if row.get("statement_digest") != statement_digest(environments[label]):
            raise SystemExit(f"statement digest mismatch: {label}; review the claim row")
        if row["terminals"] and row.get("terminal_digest") != terminal_digest(row["terminals"]):
            raise SystemExit(f"terminal digest mismatch: {label}")
    if (PAPER / "verification/dependency-graph.dot").read_text() != graph():
        raise SystemExit("stale dependency graph; run verification/dependency_graph.py")
