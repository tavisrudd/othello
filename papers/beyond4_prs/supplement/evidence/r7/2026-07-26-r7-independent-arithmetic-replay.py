#!/usr/bin/env python3
"""Recompute Certificate R7 with field arithmetic independent of C509.

This imports C509's quotient enumerator but neither its JSON classification
nor any stored orbit partition.  It replaces the generator's finite-field
implementation by the separately written R5 replay field, reconstructs the
pointed complements and complete sextic split-free set, and compares the
resulting orbits with the public certificate.
"""

import argparse
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
if HERE.name == "r7" and HERE.parent.name == "evidence":
    R5_PATH = HERE / "2026-07-22-c491-prs-deep-hole-replay.py"
    C509_PATH = HERE / "2026-07-23-c509-prs-deep-hole-calibration.py"
    DATA = HERE / "2026-07-23-c509-prs-deep-hole-calibration.json"
else:
    ROOT = HERE.parent
    R5_PATH = ROOT / "notes/2026-07-22-c491-prs-deep-hole-replay.py"
    C509_PATH = ROOT / "notes/2026-07-23-c509-prs-deep-hole-calibration.py"
    DATA = ROOT / "notes/2026-07-23-c509-prs-deep-hole-calibration.json"


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


R5 = load("c656_r5_field", R5_PATH)
C509 = load("c656_c509", C509_PATH)
R5.MODULI.setdefault(32, (2, [1, 0, 1, 0, 0]))


class IndependentGF:
    def __init__(self, q):
        self.base = R5.GF(q)
        self.q, self.p, self.m = q, self.base.p, self.base.m
        self.gen = self._primitive()

    def add(self, a, b): return self.base.add(a, b)
    def mul(self, a, b): return self.base.mul(a, b)
    def neg(self, a): return self.base.neg(a)
    def sub(self, a, b): return self.base.sub(a, b)
    def inv(self, a): return self.base.inv(a)
    def intmul(self, n, a): return self.base.intmul(n, a)

    def pow(self, a, n):
        value = 1
        while n:
            if n & 1:
                value = self.mul(value, a)
            a = self.mul(a, a)
            n //= 2
        return value

    def _primitive(self):
        for candidate in range(2, self.q):
            if len({self.pow(candidate, i) for i in range(self.q - 1)}) == self.q - 1:
                return candidate
        return 1


KEYS = (
    "q", "p", "m", "pointed_method", "pointed_bad_count",
    "affine_orbit_count", "pointed_bad_affine_orbit_count",
    "pointed_bad_affine_representatives", "candidate_count", "deep_count",
    "persistent_count", "central_nucleus_expected", "exceptional_count",
    "pgl_orbit_count", "pgammal_orbit_count", "orbits",
)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--fields", default="7,8,9,11,13,16,17,19,23,25,27,29,31,32")
    args = parser.parse_args()
    fields = tuple(int(x) for x in args.fields.split(",") if x)
    expected = {
        row["q"]: row
        for row in json.loads(DATA.read_text(encoding="utf-8"))["fields"]
    }
    original = C509.C498.GF
    C509.C498.GF = IndependentGF
    try:
        for q in fields:
            actual = C509.census_field(q, verify_pointed=())
            assert {k: actual[k] for k in KEYS} == {k: expected[q][k] for k in KEYS}, q
            print(
                f"q={q}: pointed={actual['pointed_bad_count']} "
                f"deep={actual['deep_count']} PGL={actual['pgl_orbit_count']}: PASS",
                flush=True,
            )
    finally:
        C509.C498.GF = original


if __name__ == "__main__":
    main()
