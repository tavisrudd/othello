#!/usr/bin/env python3
"""Verify the tracked C151 exhaustion trees against a fresh regeneration.

Regenerates each of the three exhaustion trees into a temporary location and compares the file set
and content hashes against the tracked trees.  The worktree is never modified.

This lives outside the three generators on purpose.  Each generated header embeds its own
generator's SHA-256, so adding a `--check` mode to a generator changes that hash and invalidates
every file it has already produced -- a comment-only edit would force a full re-elaboration of the
whole closure.  Keeping the checker separate leaves the generators byte-identical to the ones that
produced the tracked trees.

Replay, from `/home/tavis/src/othello`:

    python3 notes/2026-07-18-c151-exhaustion-check.py --csv /home/tavis/.cache/c151-residual-cover.csv
"""

from __future__ import annotations

import argparse
import importlib.util
import shutil
import sys
import tempfile
from pathlib import Path
from typing import Callable


HERE = Path(__file__).resolve().parent
STRICT_GENERATOR = HERE / "2026-07-18-c151-strict-class-bound-generator.py"
CONCLUSION_GENERATOR = HERE / "2026-07-18-c151-exhaustion-conclusion-generator.py"
DISPATCH_GENERATOR = HERE / "2026-07-18-c151-exhaustion-dispatch-generator.py"
DEFAULT_LEAN_ROOT = Path("lean/RelativeConicArcs")
DEFAULT_CSV = Path("/home/tavis/.cache/c151-residual-cover.csv")


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


strict = load(STRICT_GENERATOR, "c151_strict_class_bound_generator")
conclusion = load(CONCLUSION_GENERATOR, "c151_exhaustion_conclusion_generator")
dispatch = load(DISPATCH_GENERATOR, "c151_exhaustion_dispatch_generator")


def check_tree(write: Callable[[Path], None], tracked: Path, required_name: str) -> bool:
    """Regenerate into a temporary directory and compare against the tracked tree."""
    if tracked.name != required_name:
        raise ValueError(f"tracked directory must be named {required_name}")
    if not tracked.is_dir():
        raise RuntimeError(f"tracked directory does not exist: {tracked}")
    parent = tempfile.mkdtemp(prefix="c151-exhaustion-check-")
    try:
        fresh = Path(parent) / required_name
        write(fresh)
        tracked_files = sorted(p for p in tracked.iterdir() if p.is_file())
        fresh_files = sorted(p for p in fresh.iterdir() if p.is_file())
        tracked_names = [p.name for p in tracked_files]
        fresh_names = [p.name for p in fresh_files]
        tracked_hash = strict.tree_sha256(tracked_files, tracked)
        fresh_hash = strict.tree_sha256(fresh_files, fresh)
        print(f"  tracked_files={len(tracked_names)} regenerated_files={len(fresh_names)}")
        print(f"  tracked_tree_sha256={tracked_hash}")
        print(f"  regenerated_tree_sha256={fresh_hash}")
        if tracked_names != fresh_names:
            only_tracked = sorted(set(tracked_names) - set(fresh_names))[:10]
            only_fresh = sorted(set(fresh_names) - set(tracked_names))[:10]
            print(
                f"  FAIL file sets differ; only_tracked={only_tracked} "
                f"only_regenerated={only_fresh}"
            )
            return False
        if tracked_hash != fresh_hash:
            differing = [
                name
                for name in tracked_names
                if (tracked / name).read_bytes() != (fresh / name).read_bytes()
            ]
            print(f"  FAIL contents differ in {len(differing)} files; first={differing[:10]}")
            return False
        print("  OK tracked tree matches regeneration")
        return True
    finally:
        shutil.rmtree(parent, ignore_errors=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--csv", type=Path, default=DEFAULT_CSV)
    parser.add_argument("--lean-root", type=Path, default=DEFAULT_LEAN_ROOT)
    parser.add_argument(
        "--composition-root",
        type=Path,
        default=DEFAULT_LEAN_ROOT / "Q25RowCompositionData",
    )
    args = parser.parse_args()

    checks = (
        (
            "Q25RowCompositionStrictData",
            lambda out: strict.write_modules(out, args.composition_root),
        ),
        (
            "Q25ExhaustionConclusionData",
            lambda out: conclusion.write_modules(out, args.csv, args.composition_root),
        ),
        (
            "Q25ExhaustionDispatchData",
            lambda out: dispatch.write_modules(out, args.csv),
        ),
    )

    results = []
    for name, write in checks:
        print(f"=== {name}")
        results.append(check_tree(write, args.lean_root / name, name))

    print(f"trees_checked={len(results)} passed={sum(results)}")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()
