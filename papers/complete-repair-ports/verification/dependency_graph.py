#!/usr/bin/env python3
"""Emit the declared conceptual, logical, imported, and evidence dependencies."""
import sys
from pathlib import Path
from annotation_support import PAPER, graph

if __name__ == "__main__":
    target = Path(sys.argv[1]) if len(sys.argv) > 1 else PAPER / "verification/dependency-graph.dot"
    target.write_text(graph())
    print("recorded dependency graph")
