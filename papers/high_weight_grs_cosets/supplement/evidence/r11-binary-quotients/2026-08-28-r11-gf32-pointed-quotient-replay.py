#!/usr/bin/env python3
"""Independent quotient and Hankel replay for the pointed GF(32) certificate.

Repaired 2026-08-28.  This file rebinds the field constants of the sibling
GF(16) replay and reuses its verification code.  It shares nothing with either
generator and never calls the projective-Reed--Solomon toolkit, so the
verification path stays independent of the search path; the sibling it imports
is the other replay, not the generator.

The inherited fail-closed equivariance gate is what rejects the superseded v1
action (an earlier degree-nine R10 action truncated to the non-invariant slice
``e_3..e_7``).  Do not check a future change against the orbit count 1129: the
discarded wrong group has the same number of orbits.
"""

from __future__ import annotations

import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-08-28-r11-gf16-pointed-quotient-replay.py"
Q = 32
MODULUS = 0b100101

SPEC = importlib.util.spec_from_file_location("prs_gf16_replay", BASE_PATH)
assert SPEC is not None and SPEC.loader is not None
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)

BASE.Q = Q
BASE.MODULUS = MODULUS
BASE.SCHEMA = "prs-r11-gf32-pointed-quotient-v2"
BASE.CERTIFICATE = HERE / "2026-08-28-r11-gf32-pointed-quotient.json"


if __name__ == "__main__":
    BASE.main()
