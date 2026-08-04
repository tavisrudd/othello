#!/usr/bin/env python3
"""Validate this paper's formal-companion pin.

The paper names its external formal artifacts in ``FORMAL_COMPANION.json`` and
nowhere else. The checks themselves live in ``formal_companion.py`` beside this
script, so every paper validates its pin the same way.
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from formal_companion import main  # noqa: E402

if __name__ == "__main__":
    raise SystemExit(main(Path(__file__).resolve().parents[1]))
