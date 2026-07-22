#!/usr/bin/env python3
"""Independent combinatorial replay of the tracked C452 certificate."""

from __future__ import annotations

import json
from collections import Counter
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("2026-07-21-c452-qr-barker.json")


def matching_image(translation, matching):
    return tuple(sorted(tuple(sorted((translation[a], translation[b]))) for a, b in matching))


def main():
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c452-qr-barker-v1"
    for case in data["cases"]:
        q = case["q"]
        sheets = [[tuple(tuple(edge) for edge in matching) for matching in sheet]
                  for sheet in case["sheets"]]
        translation = tuple(case["translation_on_p1"])
        all_edges = {edge for a in range(q + 1) for edge in [(a, b) for b in range(a + 1, q + 1)]}
        for sheet in sheets:
            assert len(sheet) == q and len(set(sheet)) == q
            assert Counter(edge for matching in sheet for edge in matching) == Counter(all_edges)
            assert all(matching_image(translation, sheet[i]) == sheet[(i + 1) % q]
                       for i in range(q))

        matrix = [[int(set(left).isdisjoint(right)) for right in sheets[1]]
                  for left in sheets[0]]
        assert matrix == case["cross_disjointness_matrix"]
        difference_set = set(case["cross_disjointness_difference_set"])
        assert all(matrix[i][j] == int((j - i) % q in difference_set)
                   for i in range(q) for j in range(q))
        counts = Counter((x - y) % q for x in difference_set for y in difference_set if x != y)
        assert set(counts) == set(range(1, q))
        assert set(counts.values()) == {(q - 3) // 4}

        residues = {x * x % q for x in range(1, q)}
        assert any({(a * x + b) % q for x in residues} == difference_set
                   for a, b in case["affine_qr_maps"])
        legendre = [1 if i in residues else -1 for i in range(q)]
        assert [sum(legendre[i] * legendre[(i + shift) % q] for i in range(q))
                for shift in range(1, q)] == case["legendre_periodic_autocorrelations"]

        word = case["barker_word"]
        correlations = [sum(word[i] * word[i + shift] for i in range(q - shift))
                        for shift in range(1, q)]
        assert correlations == case["barker_aperiodic_autocorrelations"]
        assert max(map(abs, correlations)) == 1
        assert any(tuple(sign if matrix[0][(a * i + b) % q] else -sign for i in range(q))
                   == tuple(word) for a, b, sign in case["barker_incidence_realizations"])

    print("C452 independent replay: 2 sheets, 188 matching edges, 2 QR designs, 2 Barker words OK")


if __name__ == "__main__":
    main()
