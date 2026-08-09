#!/usr/bin/env python3
"""Adversarial self-checks for the Paper II release verifier."""

from __future__ import annotations

import argparse
import json
import re
import tempfile
from pathlib import Path

import verify_release as release


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def expect_rejection(action, message: str) -> None:
    try:
        action()
    except ValueError:
        return
    raise ValueError(message)


def fingerprint_mutation_is_visible(
    repo_root: Path,
    paper_root: Path,
    manifest: dict[str, object],
    identity: dict[str, object],
    baseline: dict[str, object],
    target: Path,
) -> bool:
    original_sha256 = release.sha256

    def altered_sha256(path: Path) -> str:
        digest = original_sha256(path)
        if Path(path).resolve() != target.resolve():
            return digest
        replacement = "0" if digest[0] != "0" else "1"
        return replacement + digest[1:]

    release.sha256 = altered_sha256
    try:
        altered = release.build_fingerprint(
            repo_root, paper_root, manifest, identity
        )
    finally:
        release.sha256 = original_sha256
    return altered != baseline


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", type=Path, required=True)
    parser.add_argument("--paper-root", type=Path, required=True)
    args = parser.parse_args()
    repo_root = args.repo_root.resolve()
    paper_root = args.paper_root.resolve()
    manifest = json.loads(
        (paper_root / "verification" / "trust_manifest.json").read_text()
    )
    identity = json.loads(
        (paper_root / "verification" / "statement_identity.json").read_text()
    )
    baseline = release.build_fingerprint(
        repo_root, paper_root, manifest, identity
    )

    closure = {
        relative
        for gate in baseline["project_lean_import_closure_sha256"].values()
        for relative in gate
    }
    require(
        "lean/ProjectiveCap/Sym2ConicBridge.lean" in closure,
        "ProjectiveCap source escaped the local import closure",
    )
    require(
        "lean/CapGame/BuildGame.lean" not in closure,
        "CapGame re-entered the Paper II local import closure",
    )

    with tempfile.TemporaryDirectory() as scratch:
        root = Path(scratch)
        (root / "lean" / "Local").mkdir(parents=True)
        entry = root / "lean" / "Main.lean"
        dependency = root / "lean" / "Local" / "Dep.lean"
        entry.write_text(
            "import Local.Dep -- project-local dependency\n",
            encoding="utf-8",
        )
        dependency.write_text("theorem dependency : True := by trivial\n")
        commented_import_closure = release.lean_import_closure(
            root, entry
        )
        require(
            set(commented_import_closure)
            == {"lean/Main.lean", "lean/Local/Dep.lean"},
            "commented local import escaped the closure walker",
        )
        entry.write_text("import Local.Dep Extra\n", encoding="utf-8")
        expect_rejection(
            lambda: release.lean_import_closure(root, entry),
            "unsupported Lean import syntax was silently skipped",
        )
    for label, target in (
        (
            "ProjectiveCap source",
            repo_root / "lean" / "ProjectiveCap" / "Sym2ConicBridge.lean",
        ),
        (
            "manuscript checker",
            paper_root / "verification" / "check_manuscript_build.py",
        ),
        ("paper flake.nix", paper_root / "flake.nix"),
        ("paper flake.lock", paper_root / "flake.lock"),
    ):
        require(
            fingerprint_mutation_is_visible(
                repo_root,
                paper_root,
                manifest,
                identity,
                baseline,
                target,
            ),
            f"fingerprint ignored a mutation of the {label}",
        )

    gate_root = repo_root / "lean" / "RelativeConicArcs" / "Gates"
    declarations: list[str] = []
    for name in (
        "ClebschArithmeticGluing.lean",
        "ClebschHilbertSymmetry.lean",
        "ClebschHyperplaneSquare.lean",
        "ClebschPaperIIStructural.lean",
    ):
        declarations.extend(
            re.findall(
                r"^#print axioms\s+(\S+)\s*$",
                (gate_root / name).read_text(encoding="utf-8"),
                re.MULTILINE,
            )
        )

    def rendered(names: list[str]) -> str:
        return "\n".join(
            f"'{name}' does not depend on any axioms" for name in names
        )

    release.check_lean_axiom_audit(rendered(declarations))
    expect_rejection(
        lambda: release.check_lean_axiom_audit(
            rendered(declarations[:-1] + [declarations[0]])
        ),
        "duplicate Lean terminal was accepted",
    )
    expect_rejection(
        lambda: release.check_lean_axiom_audit(
            rendered(declarations[:-1] + ["Wrong.Terminal"])
        ),
        "substituted Lean terminal was accepted",
    )

    with tempfile.TemporaryDirectory() as scratch:
        root = Path(scratch)
        (root / "Bad.lean").write_text(
            "private axiom hidden : True\n", encoding="utf-8"
        )
        expect_rejection(
            lambda: release.check_lean_source_policy(
                {"Bad.lean": "unused"}, root
            ),
            "hidden Lean axiom was accepted",
        )
        (root / "Admit.lean").write_text(
            "theorem hidden : True := by admit\n", encoding="utf-8"
        )
        expect_rejection(
            lambda: release.check_lean_source_policy(
                {"Admit.lean": "unused"}, root
            ),
            "Lean admit tactic was accepted",
        )
        (root / "Meta.lean").write_text(
            "example : True := by run_tac pure ()\n", encoding="utf-8"
        )
        expect_rejection(
            lambda: release.check_lean_source_policy(
                {"Meta.lean": "unused"}, root
            ),
            "Lean metaprogram proof generation was accepted",
        )

    with tempfile.TemporaryDirectory() as scratch:
        root = Path(scratch)
        (root / "verification").mkdir()
        (root / release.FINGERPRINT).write_bytes(
            (paper_root / release.FINGERPRINT).read_bytes()
        )
        manuscript = (paper_root / "clebsch_factorization.tex").read_text(
            encoding="utf-8"
        )
        digest = release.displayed_fingerprint_sha256(
            paper_root / "clebsch_factorization.tex"
        )
        replacement = "0" if digest[0] != "0" else "1"
        (root / "clebsch_factorization.tex").write_text(
            manuscript.replace(digest[:8], replacement + digest[1:8], 1),
            encoding="utf-8",
        )
        expect_rejection(
            lambda: release.check_displayed_fingerprint_sha256(root),
            "stale displayed fingerprint digest was accepted",
        )

    print("clebsch release-boundary adversarial checks: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
