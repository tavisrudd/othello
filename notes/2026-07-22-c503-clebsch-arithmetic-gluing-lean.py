#!/usr/bin/env python3
"""Internal compatibility entry point for the scholarly arithmetic-gluing generator."""

from pathlib import Path
import hashlib
import runpy
import sys

ROOT = Path(__file__).resolve().parents[1]
CANONICAL = ROOT / "lean/verification/clebsch_arithmetic_gluing/certificate.json"
COMPATIBLE = Path(__file__).with_suffix(".json")
MANIFEST = Path(__file__).with_suffix(".sha256")
LEAN = ROOT / "lean/RelativeConicArcs/ClebschArithmeticGluingData.lean"

runpy.run_path(str(ROOT / "lean/verification/clebsch_arithmetic_gluing/generate.py"),
               run_name="__main__")

certificate = CANONICAL.read_bytes()
manifest = "".join(
    f"{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.relative_to(ROOT)}\n"
    for path in (Path(__file__), COMPATIBLE, LEAN)
).encode()
if "--write" in sys.argv:
    COMPATIBLE.write_bytes(certificate)
    manifest = "".join(
        f"{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.relative_to(ROOT)}\n"
        for path in (Path(__file__), COMPATIBLE, LEAN)
    ).encode()
    MANIFEST.write_bytes(manifest)
elif "--check" in sys.argv:
    assert COMPATIBLE.read_bytes() == certificate
    assert MANIFEST.read_bytes() == manifest
