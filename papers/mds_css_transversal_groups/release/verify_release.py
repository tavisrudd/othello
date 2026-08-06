#!/usr/bin/env python3
"""Create and verify the MDS--CSS transversal-groups release manifest.

The paper's `Makefile` has called this entry point from `release-check` since the paper was split
out, and until now the file was absent, so the target could not finish and the release surface was
never content-addressed.  The design follows the AME--LU release verifier the paper was split from:
a declared list of public artifacts and a formal companion derived from the trust facts, each
recorded with bytes and a SHA-256, and each side reduced to one tree hash.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


PAPER_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = PAPER_ROOT.parents[1]
MANIFEST_PATH = PAPER_ROOT / "release" / "RELEASE-MANIFEST.json"

# The formal roots this paper claims.  The transversal-group results exit through the geometry
# gate, and its axiom audit is a separate module so the two can be elaborated independently.  The
# roots are named rather than matched by filename: a pattern would silently acquire a future module
# whose name happens to start the same way and silently drop one that is renamed.
FORMAL_ROOTS = (
    "RelativeConicArcs.Gates.MDSCSSTransversalGeometry",
    "RelativeConicArcs.Gates.MDSCSSTransversalGeometryAxioms",
)

PAPER_FILES = (
    "LICENSE",
    "Makefile",
    "main.tex",
    "mds-css-transversal-groups.pdf",
    "refs.bib",
    "release/verify_release.py",
)

SOURCE_DIRECTORIES = ("frontmatter", "sections", "figures")


def digest(path: Path) -> tuple[int, str]:
    data = path.read_bytes()
    return len(data), hashlib.sha256(data).hexdigest()


def record(path: Path, name: str) -> dict[str, object]:
    size, sha256 = digest(path)
    return {"bytes": size, "path": name, "sha256": sha256}


def paper_paths() -> list[str]:
    paths = set(PAPER_FILES)
    for directory in SOURCE_DIRECTORIES:
        paths.update(
            str(path.relative_to(PAPER_ROOT))
            for path in (PAPER_ROOT / directory).glob("*.tex")
        )
    missing = [name for name in sorted(paths) if not (PAPER_ROOT / name).is_file()]
    if missing:
        raise SystemExit("declared public artifact is absent: " + ", ".join(missing))
    return sorted(paths)


def formal_paths() -> list[str]:
    """Return the verification graph of this paper's declared formal roots.

    Each root's module closure is read from the trust facts the Lean layer extracts by elaboration,
    so the release surface and the trust spine describe one graph rather than two descriptions of
    it that can drift apart.
    """
    facts_dir = REPO_ROOT / "lean" / "trust" / "facts"
    modules: set[str] = set()
    for gate in FORMAL_ROOTS:
        artifact = facts_dir / f"{gate}.json"
        if not artifact.is_file():
            raise SystemExit(
                f"no trust facts for {gate}; extract them before running the formal profile"
            )
        facts = json.loads(artifact.read_text())
        modules.add(gate)
        modules.update(facts["closure"])
    paths = {
        "lean/flake.lock",
        "lean/flake.nix",
        "lean/lake-manifest.json",
        "lean/lakefile.toml",
        "lean/lean-toolchain",
    }
    for module in modules:
        source = REPO_ROOT / "lean" / f"{module.replace('.', '/')}.lean"
        if source.is_file():
            paths.add(str(source.relative_to(REPO_ROOT)))
    return sorted(paths)


def tree_digest(records: list[dict[str, object]]) -> str:
    hasher = hashlib.sha256()
    for item in records:
        hasher.update(f"{item['path']}\0{item['bytes']}\0{item['sha256']}\n".encode())
    return hasher.hexdigest()


def create_manifest() -> dict[str, object]:
    public = [record(PAPER_ROOT / path, path) for path in paper_paths()]
    formal = [record(REPO_ROOT / path, path) for path in formal_paths()]
    return {
        "schema": "mds-css-transversal-groups-release-manifest-v1",
        "title": (
            "Diagonal Isoduality and Transversal Clifford Groups of MDS--CSS Codes"
        ),
        "public_export": {
            "artifacts": public,
            "tree_sha256": tree_digest(public),
        },
        "formal_companion": {
            "artifacts": formal,
            "tree_sha256": tree_digest(formal),
        },
    }


def write_manifest() -> None:
    MANIFEST_PATH.parent.mkdir(parents=True, exist_ok=True)
    MANIFEST_PATH.write_text(json.dumps(create_manifest(), indent=2) + "\n")
    print(f"wrote {MANIFEST_PATH.relative_to(PAPER_ROOT)}")


def verify_manifest(require_formal: bool = False) -> dict[str, object]:
    if not MANIFEST_PATH.is_file():
        raise SystemExit(
            f"{MANIFEST_PATH.relative_to(PAPER_ROOT)} is absent; "
            "run release/verify_release.py --write to record the current surface"
        )
    expected = json.loads(MANIFEST_PATH.read_text())
    public = [record(PAPER_ROOT / path, path) for path in paper_paths()]
    actual_public = {"artifacts": public, "tree_sha256": tree_digest(public)}
    if expected["public_export"] != actual_public:
        raise SystemExit(
            "release manifest does not match current source; "
            "run release/verify_release.py --write after reviewing the diff"
        )
    print(f"verified {len(public)} public artifacts")
    print(f"public tree {actual_public['tree_sha256']}")

    formal_files = formal_paths()
    present = [(REPO_ROOT / path).exists() for path in formal_files]
    # A partly present companion is a broken checkout rather than a paper-only export, and saying
    # so is the whole reason the two cases are distinguished.
    if any(present) and not all(present):
        raise SystemExit("formal companion is only partially present")
    if all(present):
        formal = [record(REPO_ROOT / path, path) for path in formal_files]
        actual_formal = {"artifacts": formal, "tree_sha256": tree_digest(formal)}
        if expected["formal_companion"] != actual_formal:
            raise SystemExit("formal companion does not match the release manifest")
        print(f"verified {len(formal)} formal companion artifacts")
        print(f"formal tree {actual_formal['tree_sha256']}")
    elif require_formal:
        raise SystemExit("formal companion is required but not present")
    else:
        print("formal companion recorded but not present in this paper-only export")
    return expected


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--require-formal", action="store_true")
    args = parser.parse_args()
    if args.write:
        write_manifest()
    else:
        verify_manifest(require_formal=args.require_formal)


if __name__ == "__main__":
    main()
