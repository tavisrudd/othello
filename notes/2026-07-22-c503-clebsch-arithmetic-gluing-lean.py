#!/usr/bin/env python3
"""Compatibility entry point for the stable arithmetic-gluing certificate generator."""

from pathlib import Path
import runpy

runpy.run_path(
    str(Path(__file__).with_name("clebsch-arithmetic-gluing-lean-v1.py")),
    run_name="__main__",
)
