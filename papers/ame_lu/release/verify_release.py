#!/usr/bin/env python3
"""Create, verify, and export the AME--LU release manifest."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import tarfile
from pathlib import Path


PAPER_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = PAPER_ROOT.parents[1]
MANIFEST_PATH = PAPER_ROOT / "release" / "RELEASE-MANIFEST.json"

# The formal roots this paper claims.  The exact-rigidity and atlas chain exits through the
# mixed AME--CSS aggregate, which also carries the companion paper's six-party applications;
# the two-uniform and quantitative appendices exit through their own gate.  Naming both here
# keeps the release surface a declared contract rather than a filename pattern.
FORMAL_ROOTS = (
    "RelativeConicArcs.Gates.AMELUAggregate",
    "RelativeConicArcs.Gates.AMELUAggregateAxioms",
    "RelativeConicArcs.Gates.AMELUTwoUniformRigidity",
    "RelativeConicArcs.Gates.AMELUTwoUniformRigidityAxioms",
)

PAPER_FILES = (
    "Makefile",
    "ame-lu.pdf",
    "main.tex",
    "refs.bib",
    "release/verify_release.py",
)

def digest(path: Path) -> tuple[int, str]:
    data = path.read_bytes()
    return len(data), hashlib.sha256(data).hexdigest()


def record(path: Path, name: str) -> dict[str, object]:
    size, sha256 = digest(path)
    return {"bytes": size, "path": name, "sha256": sha256}


def paper_paths() -> list[str]:
    paths = set(PAPER_FILES)
    for directory in ("sections", "figures"):
        paths.update(
            str(path.relative_to(PAPER_ROOT))
            for path in (PAPER_ROOT / directory).glob("*.tex")
        )
    return sorted(paths)


def formal_paths() -> list[str]:
    """Return the verification graph of this paper's declared formal roots.

    The roots are named, not matched by filename: a glob over `AMELU*` would
    silently acquire any future module whose name happens to start that way and
    silently drop one that is renamed.  Each root's module closure is read from
    the trust facts the Lean layer extracts by elaboration, so the release
    surface and the trust spine describe the same graph.
    """
    facts_dir = REPO_ROOT / "lean" / "trust" / "facts"
    modules: set[str] = set()
    for gate in FORMAL_ROOTS:
        artifact = facts_dir / f"{gate}.json"
        if not artifact.is_file():
            raise SystemExit(
                f"no trust facts for {gate}; extract them before running the "
                "formal profile"
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
        hasher.update(
            f"{item['path']}\0{item['bytes']}\0{item['sha256']}\n".encode()
        )
    return hasher.hexdigest()


def create_manifest() -> dict[str, object]:
    public = [record(PAPER_ROOT / path, path) for path in paper_paths()]
    formal = [record(REPO_ROOT / path, path) for path in formal_paths()]
    return {
        "schema": "ame-lu-release-manifest-v1",
        "release": "ame-lu-2026-08-03",
        "date": "2026-08-03",
        "title": (
            "Local-Unitary Rigidity and Quantitative Rounding for "
            "Stabilizer AME States"
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
    manifest = create_manifest()
    MANIFEST_PATH.write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"wrote {MANIFEST_PATH.relative_to(PAPER_ROOT)}")


def verify_manifest(require_formal: bool = False) -> dict[str, object]:
    expected = json.loads(MANIFEST_PATH.read_text())
    public = [
        record(PAPER_ROOT / path, path)
        for path in paper_paths()
    ]
    actual_public = {
        "artifacts": public,
        "tree_sha256": tree_digest(public),
    }
    if expected["public_export"] != actual_public:
        raise SystemExit(
            "release manifest does not match current source; "
            "run release/verify_release.py --write after reviewing the diff"
        )
    print(f"verified {len(public)} public artifacts")
    print(f"public tree {actual_public['tree_sha256']}")

    formal_files = formal_paths()
    present = [(REPO_ROOT / path).exists() for path in formal_files]
    if any(present) and not all(present):
        raise SystemExit("formal companion is only partially present")
    if all(present):
        formal = [record(REPO_ROOT / path, path) for path in formal_files]
        actual_formal = {
            "artifacts": formal,
            "tree_sha256": tree_digest(formal),
        }
        if expected["formal_companion"] != actual_formal:
            raise SystemExit("formal companion does not match the release manifest")
        print(f"verified {len(formal)} formal companion artifacts")
        print(f"formal tree {actual_formal['tree_sha256']}")
    elif require_formal:
        raise SystemExit("formal companion is required but not present")
    else:
        print("formal companion recorded but not present in this paper-only export")
    return expected


def add_file(tar: tarfile.TarFile, source: Path, arcname: str) -> None:
    info = tar.gettarinfo(str(source), arcname)
    info.uid = info.gid = 0
    info.uname = info.gname = ""
    info.mtime = 0
    with source.open("rb") as stream:
        tar.addfile(info, stream)


def export_archive(destination: Path, profile: str) -> None:
    manifest = verify_manifest(require_formal=True)
    if profile == "arxiv":
        paths = ["main.tex", "refs.bib"]
        paths.extend(
            item["path"]
            for item in manifest["public_export"]["artifacts"]
            if str(item["path"]).startswith(("sections/", "figures/"))
        )
        prefix = ""
    else:
        paths = [
            item["path"] for item in manifest["public_export"]["artifacts"]
        ]
        paths.append("release/RELEASE-MANIFEST.json")
        prefix = "ame-lu/"

    destination = destination.resolve()
    if destination.exists():
        raise SystemExit(f"refusing to overwrite {destination}")
    destination.parent.mkdir(parents=True, exist_ok=True)
    with destination.open("wb") as raw:
        with gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=0) as zipped:
            with tarfile.open(fileobj=zipped, mode="w") as archive:
                for path in sorted(paths):
                    add_file(archive, PAPER_ROOT / path, f"{prefix}{path}")
    size, sha256 = digest(destination)
    print(f"{destination}")
    print(f"bytes {size}")
    print(f"sha256 {sha256}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--export", type=Path)
    parser.add_argument("--require-formal", action="store_true")
    parser.add_argument(
        "--profile", choices=("public", "arxiv"), default="public"
    )
    args = parser.parse_args()
    if args.write:
        if args.export:
            parser.error("--write and --export are mutually exclusive")
        write_manifest()
    elif args.export:
        export_archive(args.export, args.profile)
    else:
        verify_manifest(require_formal=args.require_formal)


if __name__ == "__main__":
    main()
