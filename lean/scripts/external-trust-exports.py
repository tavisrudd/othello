#!/usr/bin/env python3
"""Generate compact release-facing views of the Lean trust spine.

The outputs are projections only.  The TOML registries, fresh paper-facts
extraction, and Lean facts artifacts remain authoritative.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import re
import sys
import tempfile
import tomllib
from dataclasses import dataclass
from pathlib import Path
from typing import Any


LEAN_ROOT_DEFAULT = Path(__file__).resolve().parents[1]
OUTPUTS = (
    "formalization.yaml",
    "HEADLINE_RESULTS.md",
    "headline-theorems.json",
)
FORMALIZATION_VERSION = "v0.3"
EXIT_OK = 0
EXIT_STALE = 1
EXIT_REFUSED = 2
AUTHOR_RE = re.compile(r"\\author\s*(?:\[[^]]*\]\s*)?\{")


class Refused(RuntimeError):
    """An input cannot support an honest external export."""


@dataclass(frozen=True)
class Model:
    manifest: dict[str, Any]
    theorems: dict[str, Any]
    headline_markdown: str


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def canonical_json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True) + "\n"


def _load_module(path: Path, name: str) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise Refused(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _balanced_group(text: str, open_index: int) -> str:
    depth = 0
    for index in range(open_index, len(text)):
        char = text[index]
        if char == "{" and (index == 0 or text[index - 1] != "\\"):
            depth += 1
        elif char == "}" and (index == 0 or text[index - 1] != "\\"):
            depth -= 1
            if depth == 0:
                return text[open_index + 1 : index]
    raise Refused("unbalanced author field in manuscript source")


def _authors(text: str) -> list[str]:
    match = AUTHOR_RE.search(text)
    if match is None:
        return ["not recorded"]
    raw = _balanced_group(text, match.end() - 1)
    raw = re.sub(r"\\(?:thanks|email)\s*\{[^{}]*\}", "", raw)
    raw = re.sub(r"\\and\b", ";", raw)
    raw = re.sub(r"\\(?:textsc|textbf|emph)\s*\{([^{}]*)\}", r"\1", raw)
    raw = re.sub(r"\\[A-Za-z@]+\*?(?:\[[^]]*\])?", "", raw)
    raw = raw.replace("~", " ")
    names = [" ".join(part.split()) for part in raw.split(";")]
    return [name for name in names if name] or ["not recorded"]


def _module_file(module: str) -> str:
    return module.replace(".", "/") + ".lean"


def _yaml_scalar(value: Any) -> str:
    if value is None:
        return "null"
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, (int, float)):
        return str(value)
    return json.dumps(str(value), ensure_ascii=False)


def yaml_text(value: Any) -> str:
    """Render the JSON-shaped subset used here as deterministic YAML 1.2."""

    lines: list[str] = []

    def emit(item: Any, indent: int, prefix: str = "") -> None:
        pad = " " * indent
        if isinstance(item, dict):
            if not item:
                lines.append(f"{pad}{prefix}{{}}")
                return
            if prefix:
                lines.append(f"{pad}{prefix}")
                pad = " " * (indent + 2)
                indent += 2
            for key, child in item.items():
                if isinstance(child, (dict, list)) and child:
                    lines.append(f"{pad}{key}:")
                    emit(child, indent + 2)
                elif isinstance(child, (dict, list)):
                    lines.append(f"{pad}{key}: {'{}' if isinstance(child, dict) else '[]'}")
                else:
                    lines.append(f"{pad}{key}: {_yaml_scalar(child)}")
        elif isinstance(item, list):
            if not item:
                lines.append(f"{pad}{prefix}[]")
                return
            for child in item:
                if isinstance(child, dict):
                    first, *rest = child.items()
                    key, first_value = first
                    if isinstance(first_value, (dict, list)) and first_value:
                        lines.append(f"{pad}- {key}:")
                        emit(first_value, indent + 4)
                    else:
                        rendered = (
                            "{}" if isinstance(first_value, dict) else
                            "[]" if isinstance(first_value, list) else
                            _yaml_scalar(first_value)
                        )
                        lines.append(f"{pad}- {key}: {rendered}")
                    if rest:
                        emit(dict(rest), indent + 2)
                elif isinstance(child, list):
                    lines.append(f"{pad}-")
                    emit(child, indent + 2)
                else:
                    lines.append(f"{pad}- {_yaml_scalar(child)}")
        else:
            lines.append(f"{pad}{prefix}{_yaml_scalar(item)}")

    emit(value, 0)
    return "\n".join(lines) + "\n"


def _paper_sources(lean_root: Path, paper_context: Any) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    sources: list[dict[str, Any]] = []
    details: list[dict[str, Any]] = []
    for ident, facts in sorted(paper_context.facts.items()):
        main_path = paper_context.repo_root / facts.main
        authors = _authors(main_path.read_text(encoding="utf-8"))
        source_hashes = [{"path": path, "sha256": digest} for path, digest in facts.sources]
        sources.append(
            {
                "title": facts.title,
                "authors": authors,
                "id": f"paper-facts:{ident}",
                "type": "repository manuscript",
                "license": "not recorded in paper-facts",
                "author_contacted": "n/a",
                "prior_work": "",
            }
        )
        details.append(
            {
                "id": f"paper-facts:{ident}",
                "main": facts.main,
                "source_hashes": source_hashes,
                "facts_artifact": f"trust/paper-facts/{ident}.json",
                "fresh_extraction": "lean/scripts/paper-facts.py extract",
            }
        )
    return sources, details


def _lean_facts(trust_dir: Path, gate: str) -> tuple[dict[str, Any] | None, str | None]:
    path = trust_dir / "facts" / f"{gate}.json"
    if not path.is_file():
        return None, None
    try:
        facts = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise Refused(f"cannot read Lean facts {path}: {exc}") from exc
    if facts.get("unit") != gate:
        raise Refused(f"{path}: unit does not match filename")
    return facts, sha256_file(path)


def build_model(lean_root: Path) -> Model:
    trust_dir = lean_root / "trust"
    spine = _load_module(lean_root / "scripts" / "lean-trust-spine.py", "external_export_spine")
    paper_module = _load_module(lean_root / "scripts" / "paper-facts.py", "external_export_papers")
    registry = spine.load_registry(trust_dir)
    paper_context = paper_module.build_context(lean_root, None)
    sources, paper_details = _paper_sources(lean_root, paper_context)

    graph_path = trust_dir / "graph-manifest.json"
    graph = json.loads(graph_path.read_text(encoding="utf-8"))
    toolchain = (lean_root / "lean-toolchain").read_text(encoding="utf-8").strip()
    theorem_rows: list[dict[str, Any]] = []
    area_rows: list[dict[str, Any]] = []
    gate_rows: list[dict[str, Any]] = []
    manifest_results: list[dict[str, Any]] = []
    all_observed_axioms: set[str] = set()

    for area in sorted(registry.areas, key=lambda item: item.name):
        area_start = len(theorem_rows)
        gate_facts: dict[str, tuple[dict[str, Any] | None, str | None]] = {
            gate.module: _lean_facts(trust_dir, gate.module) for gate in area.gates
        }
        verified = 0
        for terminal in sorted(area.terminals, key=lambda item: item.name):
            observations: list[list[str]] = []
            fact_refs: list[dict[str, str]] = []
            declaration_module: str | None = None
            for gate in terminal.gates:
                facts, digest = gate_facts[gate]
                if facts is None or digest is None:
                    continue
                observed = facts.get("terminal_axioms", {}).get(terminal.name)
                if observed is None:
                    continue
                observations.append(sorted(observed))
                module = facts.get("declaration_module", {}).get(terminal.name)
                if module is not None:
                    declaration_module = module
                fact_refs.append(
                    {
                        "path": f"trust/facts/{gate}.json",
                        "sha256": digest,
                    }
                )
            expected = sorted(terminal.expected_axioms)
            if observations and any(observed != expected for observed in observations):
                raise Refused(f"observed axioms disagree with {terminal.name}")
            extracted = len(observations) == len(terminal.gates)
            if extracted:
                verified += 1
                all_observed_axioms.update(expected)
                manifest_results.append(
                    {
                        "declaration": terminal.name,
                        "file": _module_file(declaration_module or terminal.gates[0]),
                        "sorry_count": 0,
                        "axioms": expected,
                    }
                )
            theorem_rows.append(
                {
                    "id": f"trust-spine:{area.name}:terminal:{terminal.name}",
                    "trust_area": area.name,
                    "declaration": terminal.name,
                    "gates": sorted(terminal.gates),
                    "expected_axioms": expected,
                    "observed_axioms": expected if extracted else None,
                    "axiom_status": "extracted-and-matched" if extracted else "declared-unextracted",
                    "declaration_module": declaration_module,
                    "facts_artifacts": fact_refs,
                }
            )
        area_theorems = theorem_rows[area_start:]
        for gate in sorted(area.gates, key=lambda item: item.module):
            if not gate.terminals:
                continue
            exported = [row for row in area_theorems if gate.module in row["gates"]]
            extracted = sum(
                row["axiom_status"] == "extracted-and-matched" for row in exported
            )
            gate_rows.append(
                {
                    "id": f"trust-spine:{area.name}:gate:{gate.module}",
                    "gate": gate.module,
                    "terminals": len(exported),
                    "axioms_extracted": extracted,
                    "review_status": (
                        "extracted and matched"
                        if extracted == len(exported)
                        else f"{len(exported) - extracted} await extraction"
                    ),
                }
            )
        area_rows.append(
            {
                "id": f"trust-spine:{area.name}",
                "area": area.name,
                "manifest": area.manifest,
                "spine": f"trust/{area.spine_path}",
                "terminals": len(area.terminals),
                "axioms_extracted": verified,
                "review_status": (
                    "all terminal axioms extracted and matched"
                    if verified == len(area.terminals)
                    else f"{len(area.terminals) - verified} terminal axiom sets await extraction"
                ),
                "replay": f"lean/scripts/lean-trust-extract.py run --area {area.name}",
                "data_trees": [
                    {
                        "id": f"trust-spine:{area.name}:data-tree:{tree.path}",
                        "path": tree.path,
                        "provenance": tree.provenance,
                        "generator": tree.generator,
                        "generator_sha256": tree.generator_sha256,
                        "input_hashes": [
                            {"path": path, "sha256": digest}
                            for path, digest in tree.inputs
                        ],
                    }
                    for tree in sorted(area.data_trees, key=lambda item: item.path)
                ],
            }
        )

    theorem_rows.sort(key=lambda row: (row["trust_area"], row["declaration"]))
    manifest_results.sort(key=lambda row: row["declaration"])
    input_paths = [
        trust_dir / "portfolio.toml",
        trust_dir / "papers.toml",
        graph_path,
        lean_root / "lean-toolchain",
        *(trust_dir / area.spine_path for area in registry.areas),
    ]
    input_hashes = [
        {
            "path": path.relative_to(lean_root).as_posix(),
            "sha256": sha256_file(path),
        }
        for path in sorted(input_paths)
    ]
    review_status = (
        "mechanically checked for extracted units; declarations remain unextracted elsewhere"
        if any(row["axiom_status"] != "extracted-and-matched" for row in theorem_rows)
        else "all adopted terminal axiom sets extracted and matched"
    )
    manifest = {
        "version": FORMALIZATION_VERSION,
        "project": {
            "name": "Othello Lean formalization portfolio",
            "authors": sorted({author for source in sources for author in source["authors"]}),
            "license": "not recorded in the trust spine",
        },
        "sources": sources,
        "status": {
            "scope": (
                "Generated portfolio view of the public terminals adopted by the trust spine; "
                "unextracted declarations are reported but are not presented as verified results."
            ),
            "sorry_count": 0,
            "sorry_in_definitions": 0,
            "axioms": sorted(all_observed_axioms),
            "main_results": manifest_results,
        },
        "automation": {
            "methods": [
                {
                    "method": "other",
                    "models": [],
                    "framework": "not recorded by the trust spine",
                    "tool_setup": "See the authoritative project history and trust manifests.",
                    "cost": {"wall_time": "not recorded", "spend_usd": "not recorded"},
                    "hardware": "not recorded",
                    "prompting_notes": "not recorded",
                }
            ],
            "spend_usd": "not recorded",
            "notes": "This generated projection does not become process provenance authority.",
        },
        "fidelity": {
            "divergences": "See the registered manuscripts and their verification manifests."
        },
        "review": {
            "status": review_status,
            "reviewers": [],
            "notes": "Per-terminal extraction status is in headline-theorems.json.",
        },
        "alignment": {
            "namespace": "portfolio",
            "statements": [
                {
                    "source": row["id"],
                    "lean": row["declaration"],
                    "module": row["declaration_module"] or row["gates"][0],
                    "status": (
                        "proved" if row["axiom_status"] == "extracted-and-matched"
                        else "declared; extraction pending"
                    ),
                }
                for row in theorem_rows
            ],
        },
        "othello_trust": {
            "schema_version": 1,
            "authority": {
                "trust_registry": "trust/portfolio.toml",
                "paper_registry": "trust/papers.toml",
                "theorem_list": "trust/external/headline-theorems.json",
            },
            "lean_toolchain": toolchain,
            "graph_manifest": {
                "path": "trust/graph-manifest.json",
                "canonical_sha256": graph["canonical_sha256"],
                "replay": graph["replay"],
            },
            "inputs": input_hashes,
            "papers": paper_details,
            "areas": area_rows,
        },
    }
    theorem_document = {
        "schema_version": 1,
        "authority": "lean/trust/portfolio.toml and its declared area spines",
        "lean_toolchain": toolchain,
        "theorems": theorem_rows,
    }
    lines = [
        "# Portfolio headline results",
        "",
        "Generated by `lean/scripts/external-trust-exports.py generate`. The trust-spine and",
        "paper-facts registries remain authoritative; this table is rejected by `check` after any",
        "manual edit or stale generation.",
        "",
        "## Headline gates",
        "",
        "| Stable trust identifier | Gate | Terminals | Axioms extracted | Review status |",
        "|---|---|---:|---:|---|",
    ]
    for row in gate_rows:
        lines.append(
            f"| `{row['id']}` | `{row['gate']}` | {row['terminals']} | "
            f"{row['axioms_extracted']} | {row['review_status']} |"
        )
    lines.extend(
        [
            "",
            "## Area coverage",
            "",
            "| Stable trust identifier | Adopted terminals | Axioms extracted | Review status |",
            "|---|---:|---:|---|",
        ]
    )
    for row in area_rows:
        lines.append(
            f"| `{row['id']}` | {row['terminals']} | {row['axioms_extracted']} | "
            f"{row['review_status']} |"
        )
    lines.extend(
        [
            "",
            f"The machine-readable list contains exactly {len(theorem_rows)} adopted public terminals.",
            "",
        ]
    )
    return Model(manifest, theorem_document, "\n".join(lines))


def rendered(model: Model) -> dict[str, str]:
    return {
        "formalization.yaml": (
            "# Generated formalization.yaml-compatible portfolio metadata.\n"
            "# Schema: https://github.com/mathlib-initiative/formalization.yaml (v0.3)\n"
            + yaml_text(model.manifest)
        ),
        "HEADLINE_RESULTS.md": model.headline_markdown,
        "headline-theorems.json": canonical_json(model.theorems),
    }


def _atomic_write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temp_name = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent, text=True)
    try:
        with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as handle:
            handle.write(text)
        os.replace(temp_name, path)
    except BaseException:
        Path(temp_name).unlink(missing_ok=True)
        raise


def cmd_generate(args: argparse.Namespace) -> int:
    expected = rendered(build_model(args.lean_root))
    changed: list[str] = []
    for name in OUTPUTS:
        target = args.out / name
        if not target.is_file() or target.read_text(encoding="utf-8") != expected[name]:
            _atomic_write(target, expected[name])
            changed.append(name)
    print("wrote " + ", ".join(changed) if changed else "no external trust export changed")
    return EXIT_OK


def cmd_check(args: argparse.Namespace) -> int:
    expected = rendered(build_model(args.lean_root))
    findings: list[str] = []
    for name in OUTPUTS:
        target = args.out / name
        if not target.is_file():
            findings.append(f"missing: {target}")
        elif target.read_text(encoding="utf-8") != expected[name]:
            findings.append(f"stale-or-edited: {target}")
    if findings:
        for finding in findings:
            print(finding)
        return EXIT_STALE
    print(f"external trust exports current: {len(model_theorems(expected))} terminals")
    return EXIT_OK


def model_theorems(expected: dict[str, str]) -> list[Any]:
    return json.loads(expected["headline-theorems.json"])["theorems"]


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--lean-root", type=Path, default=LEAN_ROOT_DEFAULT)
    parser.add_argument("--out", type=Path)
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("generate")
    sub.add_parser("check")
    args = parser.parse_args(argv)
    args.lean_root = args.lean_root.resolve()
    args.out = (args.out or args.lean_root / "trust" / "external").resolve()
    try:
        return cmd_generate(args) if args.command == "generate" else cmd_check(args)
    except (OSError, KeyError, TypeError, ValueError, Refused) as exc:
        print(f"refused: {exc}", file=sys.stderr)
        return EXIT_REFUSED


if __name__ == "__main__":
    sys.exit(main())
