#!/usr/bin/env python3
"""Extract facts from manuscript sources and compare them with the declared paper registry.

This is the paper half of the trust spine.  `lean-trust-spine.py` compares declared Lean structure
with facts an exporter reads out of Lean; this tool compares declared paper structure with facts
read out of tracked TeX, BibTeX, generated bibliographies, and verification manifests.  The
separation of declaration from fact is identical, and so is the rule that a missing fact is a
finding rather than a silent pass.

One property drives the schema.  A paper's title exists in exactly one place: the `\\title{}`
argument of its main source.  Nothing else may restate it — not the registry, not a README, not a
sibling paper's bibliography.  Everything else either derives that string or is reported as drift.
The registry therefore declares *pointers and adoption* (which directory is a paper, which file is
its main source, which labels it advertises, which Lean terminals it cites) and never declares the
title itself.

    lean/scripts/paper-facts.py extract          # write lean/trust/paper-facts/<id>.json
    lean/scripts/paper-facts.py audit            # read-only declared-versus-observed comparison
    lean/scripts/paper-facts.py check            # audit plus tracked-artifact staleness

No mode runs Lake, LaTeX, BibTeX, or any build.  Every fact comes from bytes already on disk, so
this tool is independent of the Lean extraction window.  It reports drift in another lane's
manuscript; it never edits one.
"""

from __future__ import annotations

import argparse
import difflib
import hashlib
import importlib.util
import json
import re
import subprocess
import sys
import tomllib
import zlib
from dataclasses import dataclass
from pathlib import Path
from typing import Any

LEAN_ROOT_DEFAULT = Path(__file__).resolve().parents[1]
TRUST_DIR_NAME = "trust"
REGISTRY_FILE = "papers.toml"
FACTS_DIR_NAME = "paper-facts"

REGISTRY_SCHEMA_VERSION = 1
PAPER_FACTS_SCHEMA_VERSION = 1

EXIT_OK = 0
EXIT_FINDINGS = 1
EXIT_REFUSED = 2

# Statement environments whose labels the spine tracks.  The list is closed on purpose: a paper
# that introduces a new environment should be seen doing so, rather than having its labels quietly
# absorbed into a bucket named "other".
STATEMENT_ENVIRONMENTS = (
    "theorem",
    "lemma",
    "proposition",
    "corollary",
    "definition",
    "conjecture",
    "claim",
    "remark",
    "example",
    "problem",
    "question",
    "notation",
    "convention",
    "assumption",
    "fact",
    "observation",
)

TITLE_RE = re.compile(r"\\title\s*(\[[^\]]*\])?\s*\{")
INPUT_RE = re.compile(r"\\(?:input|include)\s*\{([^}]*)\}")
BEGIN_RE = re.compile(r"\\begin\s*\{([A-Za-z*]+)\}")
END_RE = re.compile(r"\\end\s*\{([A-Za-z*]+)\}")
LABEL_RE = re.compile(r"\\label\s*\{([^}]*)\}")
BIBITEM_RE = re.compile(r"\\bibitem\s*(?:\[[^\]]*\])?\s*\{([^}]*)\}")
BIBENTRY_RE = re.compile(r"@([A-Za-z]+)\s*\{\s*([^,\s]+)\s*,")
# A page object, never the `/Pages` node that groups them.  Counting these agrees with the root
# `/Count` on every manuscript in the tree, which is why the count needs no PDF library.
PDF_PAGE_RE = re.compile(rb"/Type\s*/Page[^s]")
# The `stream` keyword, never the `endstream` that closes one, and always with the end-of-line the
# format requires after it so the body starts where the next byte does.
PDF_STREAM_RE = re.compile(rb"(?<!end)stream(?:\r\n|\r|\n)")

# A document claims to give a paper's title when it labels one or says the paper is titled it.
TITLE_CLAIM_RE = re.compile(r"\*\*title:\*\*|\btitled\b", re.IGNORECASE)

TEXT_SUFFIXES = (".md", ".tex", ".bib", ".bbl", ".toml", ".json", ".lean", ".txt", ".yaml", ".yml")


class Refused(Exception):
    """The tool cannot run at all: bad registry, unreadable tree, malformed schema."""


def load_spine_module(lean_root: Path) -> Any:
    """Import `lean-trust-spine.py` for its finding type and Lean facts loader.

    The hyphenated filename is not importable by name.  Sharing the `Finding` record keeps both
    halves of the spine reporting in one format, and sharing `load_facts` means the paper layer
    learns about missing Lean facts through exactly the mechanism the Lean layer already uses.
    """
    path = lean_root / "scripts" / "lean-trust-spine.py"
    if not path.is_file():
        raise Refused(f"{path} is missing; the paper layer reuses its finding and facts types")
    spec = importlib.util.spec_from_file_location("lean_trust_spine", path)
    if spec is None or spec.loader is None:
        raise Refused(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules["lean_trust_spine"] = module
    # `audit` and `check` must leave the worktree byte-identical, and importing by path would
    # otherwise drop a `__pycache__` beside the script it loaded.
    previous = sys.dont_write_bytecode
    sys.dont_write_bytecode = True
    try:
        spec.loader.exec_module(module)
    finally:
        sys.dont_write_bytecode = previous
    return module


# --------------------------------------------------------------------------------------------
# TeX normalization
#
# Comparison between a title in a manuscript and the same title quoted in a bibliography, a README,
# or a handoff has to survive line breaks, `\\`, brace groups, and the difference between `--` and
# an en dash.  It must NOT survive an actual change of words, so normalization only removes
# presentation.


BRACE_TRANSPARENT = re.compile(r"[{}$]")
CONTROL_WORD = re.compile(r"\\[A-Za-z]+\s*")
DASHES = re.compile(r"[\u2010-\u2015]|---|--")
PUNCT_EDGE = re.compile(r"^[\s.,:;]+|[\s.,:;]+$")


def strip_tex_comments(text: str) -> str:
    out = []
    for line in text.splitlines():
        index = 0
        while True:
            index = line.find("%", index)
            if index == -1:
                out.append(line)
                break
            if index and line[index - 1] == "\\":
                index += 1
                continue
            out.append(line[:index])
            break
    return "\n".join(out)


def normalize_prose(text: str) -> str:
    """Reduce TeX to the words it sets, so the same title survives being typeset two ways.

    Titles are compared by containment inside whole documents, so both sides must go through this
    one function.  Normalizing a title differently from the text it is looked for in produces
    mismatches that are artifacts of the comparison rather than drift — a `\\operatorname` dropped
    on one side and kept on the other is enough.
    """
    text = text.replace("\\\\", " ").replace("~", " ")
    text = CONTROL_WORD.sub(" ", text)
    text = BRACE_TRANSPARENT.sub("", text)
    text = DASHES.sub("-", text)
    return re.sub(r"\s+", " ", text).lower()


def normalize_title(raw: str) -> str:
    """A title normalized for equality: the prose form without surrounding punctuation."""
    return PUNCT_EDGE.sub("", normalize_prose(raw))


def match_brace(text: str, open_index: int) -> tuple[str, int]:
    """Return the balanced group starting at `open_index` and the index just past its close."""
    depth = 0
    for index in range(open_index, len(text)):
        char = text[index]
        if char == "{" and (index == 0 or text[index - 1] != "\\"):
            depth += 1
        elif char == "}" and text[index - 1] != "\\":
            depth -= 1
            if depth == 0:
                return text[open_index + 1 : index], index + 1
    raise Refused("unbalanced brace group")


# --------------------------------------------------------------------------------------------
# declarations


@dataclass(frozen=True)
class PaperRow:
    ident: str
    directory: str
    main: str
    lane: str
    superseded_titles: tuple[str, ...] = ()
    adopted_labels: tuple[str, ...] = ()
    manifest: str | None = None
    manifest_labels: str | None = None
    lean_terminals: tuple[str, ...] = ()


@dataclass(frozen=True)
class ExternalCitation:
    key: str
    reason: str


@dataclass(frozen=True)
class PaperRegistry:
    self_authors: tuple[str, ...]
    paper_roots: tuple[str, ...]
    drift_scan_roots: tuple[str, ...]
    papers: tuple[PaperRow, ...]
    external_citations: tuple[ExternalCitation, ...]

    def by_id(self) -> dict[str, PaperRow]:
        return {row.ident: row for row in self.papers}


def _require(table: dict[str, Any], key: str, where: str) -> Any:
    if key not in table:
        raise Refused(f"{where}: missing required key {key!r}")
    return table[key]


def _str_tuple(value: Any, where: str) -> tuple[str, ...]:
    if not isinstance(value, list) or any(not isinstance(item, str) for item in value):
        raise Refused(f"{where}: expected a list of strings")
    return tuple(value)


def load_registry(path: Path) -> PaperRegistry:
    if not path.is_file():
        raise Refused(f"no paper registry at {path}")
    with path.open("rb") as handle:
        doc = tomllib.load(handle)

    version = _require(doc, "schema_version", path.name)
    if version != REGISTRY_SCHEMA_VERSION:
        raise Refused(
            f"{path.name}: schema_version {version} but this tool implements "
            f"{REGISTRY_SCHEMA_VERSION}"
        )
    repository = _require(doc, "repository", path.name)
    rows = tuple(_load_paper(entry, path.name) for entry in doc.get("paper", []))
    idents = [row.ident for row in rows]
    if len(set(idents)) != len(idents):
        raise Refused(f"{path.name}: duplicate paper id")
    mains = [(row.directory, row.main) for row in rows]
    if len(set(mains)) != len(mains):
        raise Refused(f"{path.name}: two rows claim the same main source")

    return PaperRegistry(
        self_authors=_str_tuple(
            _require(repository, "self_authors", "[repository]"), "[repository].self_authors"
        ),
        paper_roots=_str_tuple(
            repository.get("paper_roots", ["papers"]), "[repository].paper_roots"
        ),
        drift_scan_roots=_str_tuple(
            repository.get("drift_scan_roots", []), "[repository].drift_scan_roots"
        ),
        papers=rows,
        external_citations=tuple(
            ExternalCitation(
                key=_require(entry, "key", "[[external_citation]]"),
                reason=_require(entry, "reason", "[[external_citation]]"),
            )
            for entry in doc.get("external_citation", [])
        ),
    )


def _load_paper(entry: dict[str, Any], where: str) -> PaperRow:
    manifest = entry.get("manifest")
    manifest_labels = entry.get("manifest_labels")
    if manifest and not manifest_labels:
        raise Refused(f"{where} [[paper]]: manifest needs manifest_labels naming its claim rows")
    if manifest_labels and not manifest:
        raise Refused(f"{where} [[paper]]: manifest_labels without a manifest")
    return PaperRow(
        ident=_require(entry, "id", f"{where} [[paper]]"),
        directory=_require(entry, "dir", f"{where} [[paper]]"),
        main=_require(entry, "main", f"{where} [[paper]]"),
        lane=_require(entry, "lane", f"{where} [[paper]]"),
        superseded_titles=_str_tuple(
            entry.get("superseded_titles", []), f"{where} superseded_titles"
        ),
        adopted_labels=_str_tuple(entry.get("adopted_labels", []), f"{where} adopted_labels"),
        manifest=manifest,
        manifest_labels=manifest_labels,
        lean_terminals=_str_tuple(entry.get("lean_terminals", []), f"{where} lean_terminals"),
    )


# --------------------------------------------------------------------------------------------
# tracked tree


@dataclass(frozen=True)
class Tree:
    root: Path
    tracked: tuple[str, ...]

    def tracked_set(self) -> set[str]:
        return set(self.tracked)

    def read(self, relpath: str) -> str:
        return (self.root / relpath).read_text(encoding="utf-8", errors="replace")


def load_tree(repo_root: Path) -> Tree:
    proc = subprocess.run(
        ["git", "ls-files", "-z"],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        raise Refused(f"git ls-files failed in {repo_root}: {proc.stderr.strip()[:200]}")
    return Tree(root=repo_root, tracked=tuple(sorted(p for p in proc.stdout.split("\0") if p)))


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


# --------------------------------------------------------------------------------------------
# manuscript facts


@dataclass(frozen=True)
class BibEntry:
    key: str
    kind: str  # bibtex | bibitem
    source: str
    title: str
    text: str
    self_authored: bool


@dataclass(frozen=True)
class PaperFacts:
    ident: str
    directory: str
    main: str
    title: str
    title_normalized: str
    sources: tuple[tuple[str, str], ...]  # (relpath, sha256)
    labels: tuple[tuple[str, str], ...]  # (label, environment)
    environment_counts: tuple[tuple[str, int], ...]
    bibliography: tuple[BibEntry, ...]
    untracked_bibliography: tuple[str, ...]
    manifest_labels: tuple[str, ...] | None
    manifest_missing: str | None
    pdfs: tuple[tuple[str, int, str, int | None], ...]  # (relpath, bytes, sha256, pages)

    def as_json(self) -> dict[str, Any]:
        return {
            "schema_version": PAPER_FACTS_SCHEMA_VERSION,
            "paper": self.ident,
            "dir": self.directory,
            "main": self.main,
            "title": self.title,
            "title_normalized": self.title_normalized,
            "sources": [{"path": p, "sha256": h} for p, h in self.sources],
            "labels": [{"label": lab, "environment": env} for lab, env in self.labels],
            "environment_counts": {name: count for name, count in self.environment_counts},
            # A BibTeX entry has a title field; an item of a `thebibliography` list does not, so
            # its comparable content is its whole body.  Recording every foreign item's body would
            # make the artifact a second copy of the bibliography for no checking benefit, so a
            # body is kept only where a check reads it: the self-authored items.
            "bibliography": [
                {
                    "key": entry.key,
                    "kind": entry.kind,
                    "self_authored": entry.self_authored,
                    "source": entry.source,
                    **(
                        {"title": entry.title}
                        if entry.kind == "bibtex"
                        else {"text": entry.text} if entry.self_authored else {}
                    ),
                }
                for entry in self.bibliography
            ],
            "untracked_bibliography": list(self.untracked_bibliography),
            "manifest_labels": (
                None if self.manifest_labels is None else list(self.manifest_labels)
            ),
            "pdfs": [
                {"path": p, "bytes": n, "sha256": h, "pages": pages}
                for p, n, h, pages in self.pdfs
            ],
        }


def extract_title(text: str) -> str | None:
    body = strip_tex_comments(text)
    match = TITLE_RE.search(body)
    if match is None:
        return None
    group, _ = match_brace(body, match.end() - 1)
    return re.sub(r"\s+", " ", group.strip())


def resolve_sources(tree: Tree, directory: str, main: str) -> list[str]:
    """The main source plus every file it pulls in with `\\input`/`\\include`, depth first.

    Only tracked files are followed.  A missing input is not silently skipped: it surfaces as an
    absent source in the facts, which the audit turns into a finding.
    """
    tracked = tree.tracked_set()
    ordered: list[str] = []
    seen: set[str] = set()
    stack = [f"{directory}/{main}"]
    while stack:
        rel = stack.pop(0)
        if rel in seen or rel not in tracked:
            continue
        seen.add(rel)
        ordered.append(rel)
        body = strip_tex_comments(tree.read(rel))
        children = []
        for match in INPUT_RE.finditer(body):
            target = match.group(1).strip()
            if not target:
                continue
            if not target.endswith(".tex"):
                target += ".tex"
            children.append(f"{directory}/{target}")
        stack = children + stack
    return ordered


def scan_labels(text: str) -> list[tuple[str, str]]:
    """Every `\\label` with the innermost environment enclosing it."""
    body = strip_tex_comments(text)
    events: list[tuple[int, str, str]] = []
    for match in BEGIN_RE.finditer(body):
        events.append((match.start(), "begin", match.group(1)))
    for match in END_RE.finditer(body):
        events.append((match.start(), "end", match.group(1)))
    for match in LABEL_RE.finditer(body):
        events.append((match.start(), "label", match.group(1)))
    stack: list[str] = []
    found: list[tuple[str, str]] = []
    for _, kind, value in sorted(events, key=lambda item: item[0]):
        if kind == "begin":
            stack.append(value)
        elif kind == "end":
            if stack and stack[-1] == value:
                stack.pop()
            elif value in stack:
                del stack[len(stack) - 1 - stack[::-1].index(value) :]
        else:
            found.append((value, stack[-1] if stack else ""))
    return found


def parse_bibtex(text: str, source: str, self_authors: tuple[str, ...]) -> list[BibEntry]:
    entries: list[BibEntry] = []
    for match in BIBENTRY_RE.finditer(text):
        if match.group(1).lower() in ("comment", "preamble", "string"):
            continue
        open_index = text.rfind("{", match.start(), match.end())
        try:
            body, _ = match_brace(text, open_index)
        except Refused:
            continue
        title = _bibtex_field(body, "title")
        author = _bibtex_field(body, "author")
        entries.append(
            BibEntry(
                key=match.group(2),
                kind="bibtex",
                source=source,
                title=re.sub(r"\s+", " ", title).strip(),
                text=re.sub(r"\s+", " ", body).strip(),
                self_authored=any(name.lower() in author.lower() for name in self_authors),
            )
        )
    return entries


def _bibtex_field(body: str, name: str) -> str:
    pattern = re.compile(rf"(?:^|,)\s*{name}\s*=\s*", re.IGNORECASE)
    match = pattern.search(body)
    if match is None:
        return ""
    rest = body[match.end() :].lstrip()
    if rest.startswith("{"):
        try:
            value, _ = match_brace(rest, 0)
        except Refused:
            return ""
        return value
    if rest.startswith('"'):
        end = rest.find('"', 1)
        return rest[1:end] if end != -1 else ""
    return rest.split(",", 1)[0].strip()


def parse_bibitems(text: str, source: str, self_authors: tuple[str, ...]) -> list[BibEntry]:
    """Items of a `thebibliography` list, whether hand-written or generated into a `.bbl`.

    A generated item has no field structure, so its whole body is the comparable text; the title of
    a companion paper is a substring of it or it is not.
    """
    entries: list[BibEntry] = []
    matches = list(BIBITEM_RE.finditer(text))
    for index, match in enumerate(matches):
        stop = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        body = text[match.end() : stop]
        end_marker = body.find("\\end{thebibliography}")
        if end_marker != -1:
            body = body[:end_marker]
        flat = re.sub(r"\s+", " ", body).strip()
        entries.append(
            BibEntry(
                key=match.group(1),
                kind="bibitem",
                source=source,
                title=flat,
                text=flat,
                self_authored=any(name.lower() in flat.lower() for name in self_authors),
            )
        )
    return entries


def pdf_pages(data: bytes) -> int | None:
    """Count page objects, looking inside compressed object streams as well as the raw bytes.

    Every PDF the repository builds stores its page tree in `FlateDecode` object streams, so a
    regex over the file as written finds nothing.  Rather than report a page count of zero — which
    would read as a fact — each deflate stream is inflated and searched, and a file that yields no
    page object at all is reported as unknown.
    """
    count = len(PDF_PAGE_RE.findall(data))
    for match in PDF_STREAM_RE.finditer(data):
        stop = data.find(b"endstream", match.end())
        if stop == -1:
            break
        try:
            inflated = zlib.decompress(data[match.end() : stop])
        except zlib.error:
            continue
        count += len(PDF_PAGE_RE.findall(inflated))
    return count or None


def extract_paper(tree: Tree, row: PaperRow, registry: PaperRegistry) -> PaperFacts:
    tracked = tree.tracked_set()
    main_rel = f"{row.directory}/{row.main}"
    if main_rel not in tracked:
        raise Refused(f"paper {row.ident}: declared main source {main_rel} is not tracked")

    sources = resolve_sources(tree, row.directory, row.main)
    title = extract_title(tree.read(main_rel)) or ""

    labels: list[tuple[str, str]] = []
    counts: dict[str, int] = {}
    source_digests: list[tuple[str, str]] = []
    bibliography: list[BibEntry] = []
    for rel in sources:
        data = (tree.root / rel).read_bytes()
        source_digests.append((rel, sha256_bytes(data)))
        text = data.decode("utf-8", errors="replace")
        for label, env in scan_labels(text):
            labels.append((label, env))
        body = strip_tex_comments(text)
        for match in BEGIN_RE.finditer(body):
            env = match.group(1)
            if env.rstrip("*") in STATEMENT_ENVIRONMENTS:
                counts[env] = counts.get(env, 0) + 1
        bibliography += parse_bibitems(body, rel, registry.self_authors)

    prefix = row.directory + "/"
    untracked_bib: list[str] = []
    for path in sorted((tree.root / row.directory).rglob("*.bib")):
        rel = str(path.relative_to(tree.root))
        if rel in tracked:
            bibliography += parse_bibtex(tree.read(rel), rel, registry.self_authors)
        else:
            untracked_bib.append(rel)
    # A `.bbl` is build output and is usually untracked, yet it is the file that reaches the
    # compiled PDF.  Reading it is the only way to see drift that a reader of the paper would see,
    # so it is read where present and its trackedness is recorded rather than assumed.
    for path in sorted((tree.root / row.directory).rglob("*.bbl")):
        rel = str(path.relative_to(tree.root))
        bibliography += parse_bibitems(
            path.read_text(encoding="utf-8", errors="replace"), rel, registry.self_authors
        )
        if rel not in tracked:
            untracked_bib.append(rel)

    manifest_labels: tuple[str, ...] | None = None
    manifest_missing: str | None = None
    if row.manifest:
        manifest_rel = f"{row.directory}/{row.manifest}"
        if manifest_rel not in tracked:
            manifest_missing = manifest_rel
        else:
            manifest_labels = read_manifest_labels(
                json.loads(tree.read(manifest_rel)), row.manifest_labels or "", manifest_rel
            )

    pdfs: list[tuple[str, int, str, int | None]] = []
    for rel in tree.tracked:
        if rel.startswith(prefix) and rel.endswith(".pdf"):
            data = (tree.root / rel).read_bytes()
            pdfs.append((rel, len(data), sha256_bytes(data), pdf_pages(data)))

    return PaperFacts(
        ident=row.ident,
        directory=row.directory,
        main=main_rel,
        title=title,
        title_normalized=normalize_title(title),
        sources=tuple(source_digests),
        labels=tuple(sorted(set(labels))),
        environment_counts=tuple(sorted(counts.items())),
        bibliography=tuple(sorted(bibliography, key=lambda e: (e.source, e.key))),
        untracked_bibliography=tuple(sorted(set(untracked_bib))),
        manifest_labels=manifest_labels,
        manifest_missing=manifest_missing,
        pdfs=tuple(sorted(pdfs)),
    )


def read_manifest_labels(doc: Any, selector: str, where: str) -> tuple[str, ...]:
    """Read claim labels out of a verification manifest through a deliberately tiny selector.

    The manifests are per-paper artifacts with per-paper shapes, so the registry says where the
    claim rows live rather than the tool guessing.  The selector grammar is exactly
    `<key>[].<key>`: enough to name a list of records and one field of each, and too small to
    become a query language that hides what is being read.
    """
    match = re.fullmatch(r"([A-Za-z0-9_]+)\[\]\.([A-Za-z0-9_]+)", selector)
    if match is None:
        raise Refused(f"{where}: manifest_labels must look like 'claims[].label', got {selector!r}")
    rows = doc.get(match.group(1)) if isinstance(doc, dict) else None
    if not isinstance(rows, list):
        raise Refused(f"{where}: no list at {match.group(1)!r}")
    labels = []
    for item in rows:
        if isinstance(item, dict) and isinstance(item.get(match.group(2)), str):
            labels.append(item[match.group(2)])
    return tuple(labels)


# --------------------------------------------------------------------------------------------
# discovery


def discover_manuscripts(tree: Tree, registry: PaperRegistry) -> dict[str, list[str]]:
    """Directories under a declared paper root holding a top-level source with a `\\title`.

    Nested sources are not candidates: a `sections/` file has no title of its own, and treating one
    as a manuscript would invent papers.  This is what makes an unregistered directory visible
    without anyone remembering to register it.
    """
    found: dict[str, list[str]] = {}
    for rel in tree.tracked:
        if not rel.endswith(".tex"):
            continue
        if not any(rel.startswith(root + "/") for root in registry.paper_roots):
            continue
        parts = rel.split("/")
        if len(parts) != 3:  # <root>/<paper>/<file>.tex
            continue
        if extract_title(tree.read(rel)):
            found.setdefault("/".join(parts[:2]), []).append(parts[2])
    return {directory: sorted(names) for directory, names in sorted(found.items())}


# --------------------------------------------------------------------------------------------
# checks


def audit(
    tree: Tree,
    registry: PaperRegistry,
    facts: dict[str, PaperFacts],
    lean_facts: dict[str, Any],
    Finding: Any,
) -> list[Any]:
    findings: list[Any] = []
    findings += check_registration(tree, registry, facts, Finding)
    findings += check_titles(tree, registry, facts, Finding)
    findings += check_citations(registry, facts, Finding)
    findings += check_labels(registry, facts, Finding)
    findings += check_terminals(registry, facts, lean_facts, Finding)
    # One directory can hold several manuscripts — a preprint and a journal variant share a
    # bibliography — so the same shared artifact is examined once per row.  The finding is about
    # the artifact, not about which manuscript led the checker to it, so identical findings
    # collapse rather than being reported once per registered sibling.
    return sorted(dict.fromkeys(findings), key=lambda f: f.sort_key)


def check_registration(
    tree: Tree, registry: PaperRegistry, facts: dict[str, PaperFacts], Finding: Any
) -> list[Any]:
    findings = []
    discovered = discover_manuscripts(tree, registry)
    registered = {(row.directory, row.main) for row in registry.papers}
    for directory, names in discovered.items():
        for name in names:
            if (directory, name) not in registered:
                findings.append(
                    Finding(
                        "paper-unregistered",
                        f"{directory}/{name}",
                        "a tracked source states a title but no registry row names it, so no "
                        "cross-artifact check covers this manuscript",
                    )
                )
    for row in registry.papers:
        if row.directory not in discovered:
            findings.append(
                Finding(
                    "paper-source-missing",
                    row.ident,
                    f"{row.directory} holds no tracked top-level source with a title",
                )
            )
    for ident, paper in sorted(facts.items()):
        if not paper.title:
            findings.append(
                Finding("paper-source-missing", ident, f"{paper.main} declares no \\title")
            )
        if paper.manifest_missing:
            findings.append(
                Finding(
                    "paper-manifest-missing",
                    ident,
                    f"declared verification manifest {paper.manifest_missing} is not tracked",
                )
            )
        for rel in paper.untracked_bibliography:
            findings.append(
                Finding(
                    "bibliography-untracked",
                    rel,
                    "read as build output; it reaches the compiled PDF but is absent from every "
                    "reproducibility claim made from tracked bytes",
                    severity="warn",
                )
            )
    return findings


def check_titles(
    tree: Tree, registry: PaperRegistry, facts: dict[str, PaperFacts], Finding: Any
) -> list[Any]:
    """Superseded titles that survive anywhere in the declared scan roots.

    A retitled paper is the drift that spreads furthest, because every document that introduces the
    paper by name restates the old string.  The scan is over normalized bytes, so a title broken
    across lines or wrapped in `\\\\` is still found.
    """
    findings = check_readme_titles(tree, registry, facts, Finding)
    dead: list[tuple[str, str, str]] = []  # (paper id, raw superseded title, normalized)
    for row in registry.papers:
        paper = facts.get(row.ident)
        for old in row.superseded_titles:
            normalized = normalize_title(old)
            if paper is not None and normalized == paper.title_normalized:
                findings.append(
                    Finding(
                        "title-drift",
                        row.ident,
                        f"declared superseded title is the manuscript's current title: {old!r}",
                    )
                )
                continue
            dead.append((row.ident, old, normalized))
    if not dead:
        return findings

    for rel in tree.tracked:
        if not rel.endswith(TEXT_SUFFIXES):
            continue
        if not any(rel.startswith(root + "/") or rel == root for root in registry.drift_scan_roots):
            continue
        try:
            body = normalize_prose(tree.read(rel))
        except OSError:
            continue
        for ident, old, normalized in dead:
            if normalized and normalized in body:
                findings.append(
                    Finding(
                        "title-drift",
                        rel,
                        f"states a superseded title of {ident}: {old!r}",
                    )
                )
    return findings


def check_readme_titles(
    tree: Tree, registry: PaperRegistry, facts: dict[str, PaperFacts], Finding: Any
) -> list[Any]:
    """A paper directory's README, where it states a title, must state the manuscript's.

    This catches a retitle that nobody declared, which `superseded_titles` cannot: the dead string
    is gone from the manuscript, so the only way to notice is that a document claiming to name the
    paper names something else.  The trigger is narrow on purpose — a README that never claims to
    give a title is not drifting by staying silent — so the check reads only files carrying an
    explicit title claim, and a directory holding several manuscripts satisfies it by naming any
    one of them.
    """
    findings = []
    by_directory: dict[str, list[str]] = {}
    for row in registry.papers:
        by_directory.setdefault(row.directory, []).append(row.ident)
    tracked = tree.tracked_set()
    for directory, idents in sorted(by_directory.items()):
        readme = f"{directory}/README.md"
        if readme not in tracked:
            continue
        text = tree.read(readme)
        if not TITLE_CLAIM_RE.search(text):
            continue
        body = normalize_prose(text)
        titles = [facts[ident].title_normalized for ident in idents if ident in facts]
        if any(title and title in body for title in titles):
            continue
        findings.append(
            Finding(
                "title-drift",
                readme,
                "states a title for "
                + ", ".join(sorted(idents))
                + " that is not the manuscript's own \\title{}",
            )
        )
    return findings


def check_citations(
    registry: PaperRegistry, facts: dict[str, PaperFacts], Finding: Any
) -> list[Any]:
    """Every self-authored bibliography entry must name a registered manuscript by its real title.

    No registry row says which key cites which paper, and none should: that mapping would be one
    more restatement to maintain.  The rule is stated over the facts instead — a self-authored
    entry either quotes a title the portfolio currently has, or it is declared to be an external
    publication, or it is drift.
    """
    findings = []
    external = {entry.key for entry in registry.external_citations}
    current = {paper.title_normalized: paper.ident for paper in facts.values() if paper.title}
    if not current:
        return findings

    drifting_keys: dict[str, set[str]] = {}
    for paper in sorted(facts.values(), key=lambda p: p.ident):
        for entry in paper.bibliography:
            if not entry.self_authored or entry.key in external:
                continue
            if entry.kind == "bibtex":
                normalized = normalize_title(entry.title)
                matched = normalized in current
            else:
                body = normalize_prose(entry.text)
                matched = any(title and title in body for title in current)
            if matched:
                continue
            drifting_keys.setdefault(paper.ident, set()).add(entry.key)
            if entry.kind == "bibtex":
                findings.append(
                    Finding(
                        "citation-title-drift",
                        f"{entry.source}:{entry.key}",
                        _drift_detail(entry.title, current),
                    )
                )
            else:
                findings.append(
                    Finding(
                        "stale-bbl" if entry.source.endswith(".bbl") else "citation-title-drift",
                        f"{entry.source}:{entry.key}",
                        "a self-authored item quotes no registered manuscript's current title; a "
                        "generated bibliography carries it into the compiled PDF"
                        if entry.source.endswith(".bbl")
                        else "a self-authored item quotes no registered manuscript's current title",
                    )
                )

    # A `.bbl` that merely agrees with a stale `.bib` is reported above.  This catches the other
    # order: a `.bib` that was repaired while the generated bibliography beside it was not.
    for paper in sorted(facts.values(), key=lambda p: p.ident):
        bibtex = {e.key: e for e in paper.bibliography if e.kind == "bibtex"}
        for entry in paper.bibliography:
            if entry.kind != "bibitem" or not entry.source.endswith(".bbl"):
                continue
            source_entry = bibtex.get(entry.key)
            if source_entry is None or not source_entry.title:
                continue
            if normalize_title(source_entry.title) not in normalize_prose(entry.text):
                findings.append(
                    Finding(
                        "stale-bbl",
                        f"{entry.source}:{entry.key}",
                        f"does not contain the title its source {source_entry.source} gives for "
                        "this key; the compiled PDF and the tracked bibliography disagree",
                    )
                )
    return findings


def _drift_detail(title: str, current: dict[str, str]) -> str:
    normalized = normalize_title(title)
    close = difflib.get_close_matches(normalized, list(current), n=1, cutoff=0.6)
    hint = f"; closest registered manuscript is {current[close[0]]}" if close else ""
    return (
        f"a self-authored entry titled {title!r} matches no registered manuscript's current "
        f"title{hint}"
    )


def check_labels(
    registry: PaperRegistry, facts: dict[str, PaperFacts], Finding: Any
) -> list[Any]:
    findings = []
    for row in registry.papers:
        paper = facts.get(row.ident)
        if paper is None:
            continue
        labels = {label for label, _ in paper.labels}
        for label in row.adopted_labels:
            if label not in labels:
                findings.append(
                    Finding(
                        "label-unmapped",
                        f"{row.ident}:{label}",
                        "declared as an adopted statement label but no source in the manuscript "
                        "defines it",
                    )
                )
        if paper.manifest_labels is None:
            continue
        for label in paper.manifest_labels:
            if label not in labels:
                findings.append(
                    Finding(
                        "label-unmapped",
                        f"{row.ident}:{label}",
                        f"the verification manifest {row.manifest} carries a claim row for this "
                        "label but the manuscript defines no such label",
                    )
                )
        for label in row.adopted_labels:
            if label not in paper.manifest_labels:
                findings.append(
                    Finding(
                        "label-unmapped",
                        f"{row.ident}:{label}",
                        f"adopted by the registry but the verification manifest {row.manifest} "
                        "has no claim row for it",
                    )
                )
    return findings


def check_terminals(
    registry: PaperRegistry,
    facts: dict[str, PaperFacts],
    lean_facts: dict[str, Any],
    Finding: Any,
) -> list[Any]:
    """Lean terminals a paper cites, checked against the Lean layer's own facts.

    While no extraction has run there is nothing to check against, and saying so is the point: a
    green paper audit must never be readable as evidence that the Lean side is fine.
    """
    findings = []
    declared = {
        name for row in registry.papers for name in row.lean_terminals
    }
    if not declared:
        return findings
    if not lean_facts:
        for row in registry.papers:
            if row.lean_terminals:
                findings.append(
                    Finding(
                        "facts-missing",
                        row.ident,
                        f"{len(row.lean_terminals)} cited Lean terminal(s) cannot be checked: no "
                        "Lean facts artifact exists, so their existence is unverified",
                    )
                )
        return findings
    known: set[str] = set()
    for unit in lean_facts.values():
        known.update(unit.project_declarations)
    for row in registry.papers:
        for name in row.lean_terminals:
            if name not in known:
                findings.append(
                    Finding(
                        "terminal-unknown",
                        f"{row.ident}:{name}",
                        "the paper cites this Lean declaration but no extraction unit reports it",
                    )
                )
    return findings


# --------------------------------------------------------------------------------------------
# CLI


@dataclass
class Context:
    repo_root: Path
    trust_dir: Path
    registry: PaperRegistry
    tree: Tree
    facts: dict[str, PaperFacts]
    lean_facts: dict[str, Any]
    spine: Any


def build_context(lean_root: Path, registry_path: Path | None) -> Context:
    spine = load_spine_module(lean_root)
    trust_dir = lean_root / TRUST_DIR_NAME
    registry = load_registry(registry_path or (trust_dir / REGISTRY_FILE))
    tree = load_tree(lean_root.parent)
    facts = {row.ident: extract_paper(tree, row, registry) for row in registry.papers}
    return Context(
        repo_root=tree.root,
        trust_dir=trust_dir,
        registry=registry,
        tree=tree,
        facts=facts,
        lean_facts=spine.load_facts(trust_dir / "facts"),
        spine=spine,
    )


def facts_text(paper: PaperFacts, spine: Any) -> str:
    return spine.canonical_json(paper.as_json())


def cmd_extract(args: argparse.Namespace) -> int:
    ctx = build_context(args.lean_root, args.registry)
    out_dir = Path(args.out) if args.out else ctx.trust_dir / FACTS_DIR_NAME
    out_dir.mkdir(parents=True, exist_ok=True)
    changed = []
    for ident, paper in sorted(ctx.facts.items()):
        target = out_dir / f"{ident}.json"
        text = facts_text(paper, ctx.spine)
        if not target.is_file() or target.read_text(encoding="utf-8") != text:
            target.write_text(text, encoding="utf-8")
            changed.append(target.name)
    for name in changed:
        print(f"wrote {name}")
    if not changed:
        print("no paper facts changed")
    return EXIT_OK


def cmd_audit(args: argparse.Namespace) -> int:
    ctx = build_context(args.lean_root, args.registry)
    findings = audit(ctx.tree, ctx.registry, ctx.facts, ctx.lean_facts, ctx.spine.Finding)
    if args.paper:
        findings = [f for f in findings if args.paper in f.subject or args.paper in f.detail]
    return ctx.spine.report(findings, args.json)


def cmd_check(args: argparse.Namespace) -> int:
    """Read-only: audit, plus a comparison of the tracked facts artifacts with a fresh extraction."""
    ctx = build_context(args.lean_root, args.registry)
    Finding = ctx.spine.Finding
    findings = audit(ctx.tree, ctx.registry, ctx.facts, ctx.lean_facts, Finding)
    facts_dir = ctx.trust_dir / FACTS_DIR_NAME
    expected = {f"{ident}.json" for ident in ctx.facts}
    for ident, paper in sorted(ctx.facts.items()):
        target = facts_dir / f"{ident}.json"
        if not target.is_file():
            findings.append(
                Finding("paper-facts-missing", ident, f"no tracked facts artifact at {target.name}")
            )
        elif target.read_text(encoding="utf-8") != facts_text(paper, ctx.spine):
            findings.append(
                Finding(
                    "paper-facts-stale",
                    ident,
                    "the tracked facts artifact differs from a fresh extraction; run extract",
                    # Warn, not error.  Every check that decides anything runs against a fresh
                    # extraction, so a stale artifact never weakens a verdict — it means a lane
                    # edited its manuscript, which is the normal state of a live paper.  Making it
                    # an error would put this lane's gate at the mercy of every other lane's edits
                    # and train everyone to ignore it.
                    severity="warn",
                )
            )
    if facts_dir.is_dir():
        for path in sorted(facts_dir.glob("*.json")):
            if path.name not in expected:
                findings.append(
                    Finding(
                        "paper-facts-undeclared",
                        path.name,
                        "a facts artifact exists for a paper the registry does not declare",
                    )
                )
    return ctx.spine.report(sorted(findings, key=lambda f: f.sort_key), args.json)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--lean-root", type=Path, default=LEAN_ROOT_DEFAULT, dest="lean_root")
    parser.add_argument(
        "--registry",
        type=Path,
        help="read this paper registry instead of lean/trust/papers.toml",
    )
    sub = parser.add_subparsers(dest="mode", required=True)

    extract = sub.add_parser("extract", help="write one facts artifact per declared paper")
    extract.add_argument("--out")
    extract.set_defaults(func=cmd_extract)

    audit_cmd = sub.add_parser("audit", help="read-only comparison of declarations with facts")
    audit_cmd.add_argument("--paper")
    audit_cmd.add_argument("--json", action="store_true")
    audit_cmd.set_defaults(func=cmd_audit)

    check = sub.add_parser("check", help="audit plus tracked facts-artifact staleness")
    check.add_argument("--paper")
    check.add_argument("--json", action="store_true")
    check.set_defaults(func=cmd_check)

    args = parser.parse_args(argv)
    try:
        return args.func(args)
    except Exception as exc:  # noqa: BLE001 - narrowed immediately below
        # The spine module is loaded by path, so its `Refused` is a distinct class from this
        # module's even though it means the same thing.  Both are precondition failures that must
        # exit 2 rather than surface as a traceback; anything else is a real bug and propagates.
        if not isinstance(exc, Refused) and type(exc).__name__ != "Refused":
            raise
        print(f"refused: {exc}", file=sys.stderr)
        return EXIT_REFUSED


if __name__ == "__main__":
    sys.exit(main())
