#!/usr/bin/env python3
"""Generate the exact C452 QR/Barker certificate from the frozen C406 design."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
C406_PATH = HERE / "2026-07-20-c406-matching-orbit-scout.py"
C406_JSON = HERE / "2026-07-20-c406-matching-orbit-scout.json"
C449_JSON = HERE / "2026-07-21-c449-split-coxeter-torus.json"
SCHEMA = "c452-qr-barker-v1"

BARKER = {
    7: (1, 1, 1, -1, -1, 1, -1),
    11: (1, 1, 1, -1, -1, -1, 1, -1, -1, 1, -1),
}

SOURCES = [
    {
        "key": "10.1090/S0002-9939-1961-0125026-2",
        "sha256": "8e304c23b5400dea3b6d47a2ac4c42ab043ed9f3d329b6e7b5c87883996a6083",
        "read_depth": "full text",
        "role": "original Turyn--Storer statement and listed Barker words",
    },
    {
        "key": "arXiv:1404.4833",
        "sha256": "150c8171970a6315ee8a9a369e4c831836fc365692774ca84d61fcc795adf025",
        "read_depth": "full text",
        "role": "counterexamples to Turyn--Storer Theorem 1(iv) and proof caveat",
    },
    {
        "key": "arXiv:1501.06035",
        "sha256": "f133c1c45d3ca6d13fbd33a079d069f4cee97bf27585e68229fb96a536e1e881",
        "read_depth": "full text",
        "role": "independent proof of the odd-length Barker theorem",
    },
    {
        "key": "10.1137/0124010",
        "sha256": "a6627c2b675044d3aaefbdc0cba3636d4502618bd160382b0a5476b1d554b4a4",
        "read_depth": "full text",
        "role": "Tietavainen perfect-code classification theorem",
    },
    {
        "key": "arXiv:math/0606660",
        "sha256": "80a87dddf2549f3a16feaf2fb13b859680bfafc7b78103cea95f167a0df20b11",
        "read_depth": "full text",
        "role": "Leemans--Schulte rank-four L2(q) classification",
    },
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_module():
    spec = importlib.util.spec_from_file_location("c452_c406", C406_PATH)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def encode_matching(matching):
    return [list(edge) for edge in matching]


def autocorrelations(word):
    return [sum(word[i] * word[i + shift] for i in range(len(word) - shift))
            for shift in range(1, len(word))]


def periodic_autocorrelations(word):
    q = len(word)
    return [sum(word[i] * word[(i + shift) % q] for i in range(q))
            for shift in range(1, q)]


def case_certificate(c406, name: str, q: int):
    conic, parameters = c406.C399.conic_parameterization(q)
    full_group, psl_group = c406.full_pgl(q, parameters)
    parent_group = c406.coxeter_group(name, q, conic)
    matchings = tuple(c406.perfect_matchings(tuple(range(q + 1))))
    fixed = [matching for matching in matchings
             if all(c406.matching_image(g, matching) == matching for g in parent_group)]
    assert len(fixed) == 1
    target = {c406.matching_image(g, fixed[0]) for g in full_group}

    unseen = set(target)
    sheets = []
    while unseen:
        representative = min(unseen)
        sheet = {c406.matching_image(g, representative) for g in psl_group}
        unseen -= sheet
        sheets.append(sheet)
    sheets.sort(key=min)
    assert len(sheets) == 2 and all(len(sheet) == q for sheet in sheets)

    translation = tuple(list(range(1, q)) + [0, q])
    assert translation in psl_group
    labels = []
    for sheet in sheets:
        row = []
        matching = min(sheet)
        for _ in range(q):
            row.append(matching)
            matching = c406.matching_image(translation, matching)
        assert len(set(row)) == q and set(row) == sheet
        labels.append(row)

    disjointness = [[int(set(left).isdisjoint(right)) for right in labels[1]]
                    for left in labels[0]]
    difference_set = [j for j, value in enumerate(disjointness[0]) if value]
    assert all(disjointness[i][j] == int((j - i) % q in difference_set)
               for i in range(q) for j in range(q))

    residues = sorted({x * x % q for x in range(1, q)})
    affine_qr_maps = [[a, b] for a in range(1, q) for b in range(q)
                      if sorted({(a * x + b) % q for x in residues}) == difference_set]
    assert affine_qr_maps
    difference_counts = {
        str(delta): sum(1 for x in difference_set for y in difference_set
                        if x != y and (x - y) % q == delta)
        for delta in range(1, q)
    }
    lam = (q - 3) // 4
    assert set(difference_counts.values()) == {lam}

    word = BARKER[q]
    correlations = autocorrelations(word)
    assert max(map(abs, correlations)) == 1

    legendre_realizations = []
    residue_set = set(residues)
    for a in range(1, q):
        for b in range(q):
            for zero_value in (-1, 1):
                raw = tuple(zero_value if (a * i + b) % q == 0 else
                            (1 if (a * i + b) % q in residue_set else -1)
                            for i in range(q))
                for global_sign in (-1, 1):
                    if tuple(global_sign * value for value in raw) == word:
                        legendre_realizations.append([a, b, zero_value, global_sign])
    assert legendre_realizations

    incidence_realizations = []
    for a in range(1, q):
        for b in range(q):
            for disjoint_sign in (-1, 1):
                candidate = tuple(disjoint_sign if disjointness[0][(a * i + b) % q]
                                  else -disjoint_sign for i in range(q))
                if candidate == word:
                    incidence_realizations.append([a, b, disjoint_sign])
    assert incidence_realizations

    legendre_word = tuple(1 if i in residue_set else -1 for i in range(q))
    assert set(periodic_autocorrelations(legendre_word)) == {-1}

    return {
        "type": name,
        "q": q,
        "translation_on_p1": list(translation),
        "sheets": [[encode_matching(matching) for matching in sheet] for sheet in labels],
        "cross_disjointness_matrix": disjointness,
        "cross_disjointness_difference_set": difference_set,
        "qr_residues": residues,
        "affine_qr_maps": affine_qr_maps,
        "difference_parameters": [q, (q - 1) // 2, lam],
        "ordered_difference_counts": difference_counts,
        "legendre_periodic_autocorrelations": periodic_autocorrelations(legendre_word),
        "barker_word": list(word),
        "barker_aperiodic_autocorrelations": correlations,
        "barker_legendre_realizations": legendre_realizations,
        "barker_incidence_realizations": incidence_realizations,
    }


def build_certificate():
    c406 = load_module()
    return {
        "schema": SCHEMA,
        "task": "C452",
        "inputs": {
            str(C406_PATH.relative_to(HERE.parent)): sha256(C406_PATH),
            str(C406_JSON.relative_to(HERE.parent)): sha256(C406_JSON),
            str(C449_JSON.relative_to(HERE.parent)): sha256(C449_JSON),
        },
        "cases": [case_certificate(c406, "B3", 7), case_certificate(c406, "H3", 11)],
        "sources": SOURCES,
        "walls": [
            {
                "name": "odd_length_barker",
                "status": "retained_with_repaired_proof",
                "statement": "An odd-length Barker sequence has length 3, 5, 7, 11, or 13.",
            },
            {
                "name": "perfect_hamming_codes_over_finite_fields",
                "status": "retained_with_scope_boundary",
                "statement": "There are no perfect Hamming-error-correcting codes over finite fields beyond the known single-error, trivial, and Golay parameter families.",
            },
            {
                "name": "rank_four_regular_l2_polytopes",
                "status": "retained_with_scope_boundary",
                "statement": "A rank-four regular polytope with full automorphism group L2(q) exists only for q=11 or q=19, uniquely as the 11-cell or 57-cell.",
            },
        ],
    }


def canonical_bytes(data) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.check:
        assert OUTPUT.read_bytes() == payload, f"stale certificate: {OUTPUT}"
    else:
        OUTPUT.write_bytes(payload)


if __name__ == "__main__":
    main()
