#!/usr/bin/env python3
"""Two probes arising from the replay data itself, not from the source notes.

(1) The 16-qubit RM(1,4) coset state witnesses both halves of the rigidity
    separation at once: it is exactly 2-uniform, so the discreteness theorem
    applies and its product-symmetry group is finite; and the transversal-T
    product operator fixes it exactly, so that finite group contains a
    non-Clifford element. This is the evidence for the boundary remark the
    C776 scope review proposes adopting.

(2) A structural probe of the lift lattice's invariant factors across ten
    codes. Deterministic, exact integer arithmetic, no randomness.

Replay from the repository root:
    uv run --with numpy python \
        notes/2026-08-01-external-source-numerics-lattice.py \
        > notes/2026-08-01-external-source-numerics-lattice.json
    uv run --with numpy python \
        notes/2026-08-01-external-source-numerics-lattice.py --check
"""
import importlib.util
import json
import sys
from itertools import combinations
from pathlib import Path

import numpy as np

_DIAG = Path(__file__).with_name("2026-08-01-external-source-numerics-diagonal.py")
_spec = importlib.util.spec_from_file_location("_diag", _DIAG)
_mod = importlib.util.module_from_spec(_spec)
_src = _DIAG.read_text().split("def main()")[0]
exec(compile(_src, str(_DIAG), "exec"), _mod.__dict__)

wt, span, rank_f2 = _mod.wt, _mod.span, _mod.rank_f2
smith = _mod.smith_invariant_factors


def rm_rows(r, m):
    N = 1 << m
    out = [(1 << N) - 1]
    xs = [[(p >> i) & 1 for p in range(N)] for i in range(m)]
    for d in range(1, r + 1):
        for S in combinations(range(m), d):
            v = [1] * N
            for i in S:
                v = [x & y for x, y in zip(v, xs[i])]
            out.append(sum(b << (N - 1 - k) for k, b in enumerate(v)))
    return N, out


GOLAY = [
    0b100000000000101011100011, 0b010000000000111110010010,
    0b001000000000110101101010, 0b000100000000110011010111,
    0b000010000000110001111101, 0b000001000000011000111111,
    0b000000100000101100011111, 0b000000010000111110001101,
    0b000000001000111111000110, 0b000000000100011111100011,
    0b000000000010101111110001, 0b000000000001010111111001,
]

CODES = {
    "ExtHamming[8,4]": (8, [0b10000111, 0b01001011, 0b00101101, 0b00011110]),
    "Even[8,7]": (8, [0b11000000, 0b01100000, 0b00110000, 0b00011000,
                      0b00001100, 0b00000110, 0b00000011]),
    "Golay[24,12]": (24, GOLAY),
    "Hamming[7,4]": (7, [0b1000011, 0b0100101, 0b0010110, 0b0001111]),
    "RM(1,3)": rm_rows(1, 3),
    "RM(1,4)": rm_rows(1, 4),
    "RM(1,5)": rm_rows(1, 5),
    "RM(2,5)": rm_rows(2, 5),
    "Repetition[8,1]": (8, [0b11111111]),
    "Simplex[7,3]": (7, [0b1110100, 0b0111010, 0b0011101]),
}


def rm14_state_probe():
    n, rows = rm_rows(1, 4)
    code = span(rows)
    psi = np.zeros(1 << n, dtype=complex)
    for c in code:
        psi[c] = 1.0
    psi /= np.linalg.norm(psi)

    t = psi.reshape([2] * n)
    worst = 0.0
    for a in range(n):
        for b in range(a + 1, n):
            rest = [ax for ax in range(n) if ax not in (a, b)]
            m = np.transpose(t, [a, b] + rest).reshape(4, -1)
            worst = max(worst, float(np.abs(m @ m.conj().T - np.eye(4) / 4).max()))

    psi_t = np.zeros_like(psi)
    for c in code:
        psi_t[c] = np.exp(1j * np.pi * wt(c) / 4)
    psi_t /= np.linalg.norm(psi_t)
    return {
        "length": n,
        "codewords": len(code),
        "weights": sorted({wt(c) for c in code}),
        "pair_marginal_max_deviation": round(worst, 12),
        "two_uniform": bool(worst < 1e-12),
        "transversal_T_norm_difference": round(
            float(np.linalg.norm(psi_t - psi)), 12),
        "transversal_T_is_exact_symmetry": bool(
            np.linalg.norm(psi_t - psi) < 1e-12),
        "T_is_non_clifford": True,
        "note": ("the defect formula sqrt(2-2|<psi|U|psi>|) square-roots machine "
                 "epsilon here and reads ~1e-8; the norm difference is the "
                 "meaningful figure"),
    }


def lattice_probe():
    out = []
    for name, (n, rows) in sorted(CODES.items()):
        cw = span(rows)
        k = rank_f2(rows)
        lifts = [[(c >> (n - 1 - j)) & 1 for j in range(n)] for c in cw if c]
        divs = smith(lifts, n)
        ones = sum(1 for d in divs if d == 1)
        out.append({
            "name": name,
            "length": n,
            "dim_C": k,
            "dim_C_perp": n - k,
            "lattice_rank": len(divs),
            "unit_factors": ones,
            "nontrivial_factors": sum(1 for d in divs if d > 1),
            "torus_factors_in_symmetry_group": n - len(divs),
            "unit_factors_equals_dim_C": ones == k,
            "nontrivial_equals_dim_C_perp": (len(divs) - ones) == n - k,
        })
    return out


def build():
    lat = lattice_probe()
    return {
        "schema": "external-source-numerics-lattice/1",
        "rm14_state": rm14_state_probe(),
        "lattice": lat,
        "unit_factor_law_holds_everywhere": all(
            r["unit_factors_equals_dim_C"] for r in lat),
        "naive_dual_dimension_law_counterexamples": [
            r["name"] for r in lat if not r["nontrivial_equals_dim_C_perp"]],
    }


def main():
    doc = build()
    text = json.dumps(doc, indent=2, sort_keys=True) + "\n"
    if "--check" in sys.argv:
        tracked = Path(__file__.replace(".py", ".json")).read_text()
        if tracked != text:
            print("MISMATCH against tracked certificate", file=sys.stderr)
            sys.exit(1)
        if not (doc["unit_factor_law_holds_everywhere"]
                and doc["rm14_state"]["two_uniform"]
                and doc["rm14_state"]["transversal_T_is_exact_symmetry"]):
            print("CROSS-CHECK FAILED", file=sys.stderr)
            sys.exit(1)
        print("OK: certificate matches and all cross-checks pass")
        return
    sys.stdout.write(text)


if __name__ == "__main__":
    main()
