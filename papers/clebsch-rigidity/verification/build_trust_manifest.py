#!/usr/bin/env python3
"""Build the deterministic nineteen-row Clebsch rigidity trust manifest."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path


PAPER_ROOT = Path(__file__).resolve().parents[1]
REPOSITORY_ROOT = PAPER_ROOT.parents[1]
LEAN_ROOT = REPOSITORY_ROOT / "lean"
IDENTITY_PATH = PAPER_ROOT / "verification" / "statement_identity.json"
OUTPUT_PATH = PAPER_ROOT / "verification" / "trust_manifest.json"
GATE_PATH = "RelativeConicArcs/Gates/ClebschRigidityTrust.lean"
AUDIT_PATH = "verification/clebsch_rigidity_trust/axiom-audit.txt"
PINNED_LEAN_COMMIT = "6d4766d1ea5e9a36f1a507e549c223416a6b506f"


TERMINALS = {
    "orbits": [
        "RelativeConicArcs.Examples.Q11A5PointOrbits.point_orbit_partition",
        "RelativeConicArcs.Examples.Q11A5PointOrbits.unique_six_orbit",
        "RelativeConicArcs.Examples.Q11A5PointOrbits.unique_twelve_orbit",
        "RelativeConicArcs.Examples.Q11A5PointOrbits.brianchon_points_one_orbit",
    ],
    "code_locus": [
        "RelativeConicArcs.Examples.Q11Coding.witness_mds_columns",
        "RelativeConicArcs.Examples.Q11Coding.projective_distanceThreeDirections_eq_standardConic",
        "RelativeConicArcs.Examples.Q11Coding.witness_code_coveringRadius_three",
    ],
    "decoder": [
        "RelativeConicArcs.Examples.Q11Coding.totalSyndromeDistance_exact",
        "RelativeConicArcs.Examples.Q11Coding.ambiguity_strata_sound",
        "RelativeConicArcs.Examples.Q11Coding.ambiguity_strata_counts",
        "RelativeConicArcs.Examples.Q11Coding.brianchonDirectionIndices_eq_indexThree",
        "RelativeConicArcs.Examples.Q11Coding.brianchon_weightTwo_leaderSupports",
    ],
    "rigidity": [
        "RelativeConicArcs.ClebschDye.sixArc_uncovered_add_brianchon_card",
        "RelativeConicArcs.ClebschDye.sixArc_twelve_le_uncovered_card",
        "RelativeConicArcs.ClebschDye.sixArc_cards_of_uncovered_subset_conic",
        "RelativeConicArcs.ClebschDye.isClebschHexagon_of_uncovered_subset_conic",
    ],
    "defect_bridge": [
        "RelativeConicArcs.ClebschDye.sixArc_uncovered_add_brianchon_card",
    ],
    "chord_identity": [
        "RelativeConicArcs.ClebschChordDefect.chordDefect_identity_of_moments",
    ],
    "clebsch_formula": [
        "RelativeConicArcs.ClebschChordDefect.clebsch_uncovered_formula",
    ],
    "field_order": [
        "RelativeConicArcs.ClebschChordDefect.orders_of_clebsch_uncovered_conic_card",
        "RelativeConicArcs.Q9Sylvester.distanceTwo_clique_number_five",
    ],
    "small": [
        "RelativeConicArcs.SmallKGeometricBridge.fourArc_uncovered_card",
        "RelativeConicArcs.SmallKGeometricBridge.fourArc_conic_card_order",
        "RelativeConicArcs.SmallKGeometricBridge.fiveArc_not_conic_card",
        "RelativeConicArcs.SmallKGeometricBridge.sevenArc_primePower_conic_card_spectra",
    ],
}

CLASSICAL_DYE = [
    "Dye 1991, Section 2.2 and Theorem 1(ii), page 275, and "
    "Theorem 3, page 278",
]
CLASSICAL_DYE_RIGIDITY = [
    "Dye 1991, Section 2.2, page 275, for the ten-point bound, "
    "Theorem 1(ii), page 275, for equality classification, "
    "and Theorem 3, page 278, for the stabilizer",
    "Dye 1991, Theorem 2, pages 276--278, for the unique associated polarity",
]
CLASSICAL_DYE_ASSOCIATED_CONIC = [
    "Dye 1991, Theorem 1, pages 275--276, and the edge criterion in the "
    "discussion preceding Theorem 6, pages 281--282",
]
CLASSICAL_EDGE_DYE = [
    "Edge 1956, Sections 29--32",
    "Dye 1991, Section 2.2 and Theorem 1(ii), page 275, and "
    "Theorem 3, page 278",
]
CLASSICAL_CODE = [
    "Davydov--Marcugini--Pambianco 2021, Theorem 6.3",
    "Hirschfeld 1998, the plane arc/covering-radius dictionary",
]
CLASSICAL_PARTIAL_COVER = [
    "Blokhuis--Brouwer--Szonyi 2010, Proposition 1.5, for the partial-cover "
    "bound with noncollinear holes",
]
CLASSICAL_SYLVESTER = [
    "Brouwer--Cohen--Neumaier 1989, Section 13.1.2, for the Sylvester graph "
    "interpretation",
    "Abiad--Jabal Ameli--Reijnders 2025, Table 1, for the distance-two "
    "clique number five; independently formalized from the explicit finite model",
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def file_evidence(repository: str, path: str) -> dict[str, str]:
    roots = {
        "paper": PAPER_ROOT,
        "lean": LEAN_ROOT,
    }
    return {
        "repository": repository,
        "path": path,
        "sha256": sha256(roots[repository] / path),
    }


def parse_axioms() -> dict[str, list[str]]:
    text = (LEAN_ROOT / AUDIT_PATH).read_text(encoding="utf-8")
    pattern = re.compile(
        r"'([^']+)' (does not depend on any axioms|depends on axioms: \[(.*?)\])",
        re.DOTALL,
    )
    result: dict[str, list[str]] = {}
    for match in pattern.finditer(text):
        body = match.group(3)
        result[match.group(1)] = (
            []
            if body is None
            else [item.strip() for item in body.replace("\n", " ").split(",")]
        )
    expected = {terminal for group in TERMINALS.values() for terminal in group}
    if set(result) != expected:
        missing = sorted(expected - set(result))
        extra = sorted(set(result) - expected)
        raise ValueError(f"axiom audit terminal mismatch: missing={missing}, extra={extra}")
    return result


def conceptual(
    subclaim: str,
    cited_inputs: list[str],
    remainder: str,
) -> dict[str, object]:
    return {
        "route": "conceptual-cited-inputs",
        "subclaim": subclaim,
        "cited_inputs": cited_inputs,
        "unconditional_remainder": remainder,
    }


def replay(
    subclaim: str,
    scripts: list[str],
    coverage: str,
    bridge: str,
    independent: str,
) -> dict[str, object]:
    return {
        "route": "exact-replay",
        "subclaim": subclaim,
        "computation": {
            "checker_commands": [
                {"argv": ["python3", script]} for script in scripts
            ],
            "coverage": coverage,
            "soundness_bridge": bridge,
            "independent_replay": independent,
            "residual_trust": (
                "Exact Python integer and finite-field arithmetic, plus the "
                "manuscript's coordinate-to-geometric correspondence."
            ),
            "artifacts": [
                file_evidence("paper", script) for script in scripts
            ],
        },
    }


def c605_replay() -> dict[str, object]:
    supporting_artifacts = [
        "verification/c605_search.cpp",
        "verification/c605_replay.py",
        "verification/c605_q13.json",
        "verification/c605_q17.json",
        "verification/c605_q19.json",
        "verification/c605_independent.json",
    ]
    return {
        "route": "exact-replay",
        "subclaim": "terminal eight-point exclusions",
        "computation": {
            "checker_commands": [
                {"argv": ["python3", "verification/c605_verify.py"]}
            ],
            "coverage": (
                "For q=13,17,19 the primary search fixes XZ=Y^2, partitions "
                "all 7,098, 20,808, and 32,490 passant edges into 10, 13, "
                "and 15 PGL(2,q)-orbits, and exhausts arc extensions from "
                "one representative of every orbit. The maximum size is six "
                "in every field, before the forced eight-point spectra arise."
            ),
            "soundness_bridge": (
                "Every conic-filling arc is off the fixed conic and every "
                "one of its chords is passant. Every nontrivial candidate "
                "therefore contains an edge carried to a listed root."
            ),
            "independent_replay": (
                "The Python replay tests passancy by a discriminant rather "
                "than conic incidence, verifies the edge-orbit partition "
                "directly, and repeats ordered backtracking without the "
                "primary search's stabilizer deduplication."
            ),
            "residual_trust": (
                "The C++17 and Python runtimes, exact prime-field arithmetic, "
                "and the manuscript's coordinate-to-geometric correspondence. "
                "No Lean theorem covers this terminal finite exclusion."
            ),
            "artifacts": [
                file_evidence("paper", "verification/c605_verify.py")
            ],
            "supporting_artifacts": [
                file_evidence("paper", path) for path in supporting_artifacts
            ],
        },
    }


def lean(
    subclaim: str,
    groups: list[str],
    axioms: dict[str, list[str]],
) -> dict[str, object]:
    terminals = list(
        dict.fromkeys(
            terminal for group in groups for terminal in TERMINALS[group]
        )
    )
    return {
        "route": "kernel-checked-lean",
        "subclaim": subclaim,
        "lean": {
            "gate": file_evidence("lean", GATE_PATH),
            "audit": file_evidence("lean", AUDIT_PATH),
            "terminals": terminals,
            "axioms": {terminal: axioms[terminal] for terminal in terminals},
            "validation": {
                "command": (
                    "scripts/guarded-lean "
                    "RelativeConicArcs/Gates/ClebschRigidityTrust.lean"
                ),
                "toolchain": {
                    "lean": "4.32.0-rc1",
                    "mathlib_commit": "571b8a8e54219b4d393f75f4b8653fac08197fcc",
                },
            },
        },
    }


def claim(
    identity: dict[str, object],
    boundary: str,
    components: list[dict[str, object]],
) -> dict[str, object]:
    source = {
        "kind": identity["kind"],
        "id": identity["id"],
        "sha256": identity["sha256"],
    }
    base: dict[str, object] = {
        "row": identity["row"],
        "id": str(identity["id"]).replace(":", "-"),
        "source": source,
        "paper_location": f"source line {identity['source_line']}",
        "trust_boundary": boundary,
    }
    if len(components) == 1:
        component = dict(components[0])
        component.pop("subclaim", None)
        return {**base, **component}
    return {**base, "route": "mixed", "components": components}


def components_by_row(
    axioms: dict[str, list[str]],
) -> dict[int, tuple[str, list[dict[str, object]]]]:
    frame_coverage = (
        "All 1,548 frame-normalized six-arcs over F_11 are canonically "
        "reduced to the fifteen projective classes; no sampling is used."
    )
    frame_shared = (
        "The low-degree checker deliberately reuses the global checker's "
        "canonical class generator so both tables have identical keys; there "
        "is no second independent enumeration of the fifteen classes. Both "
        "programs reconstruct all coordinates and are independent of Lean."
    )
    complementary_replays = (
        "The global, one-point-neighbour, and automorphism programs use "
        "separate finite enumerations and compare invariant counts; none "
        "imports Lean output."
    )
    automorphism_coverage = (
        "Over F_11, the checker tests all 6! coordinate permutations and "
        "constructs the complete projective and monomial automorphism actions "
        "of the displayed six-column code."
    )
    decoder_coverage = (
        "Over F_11, the three checkers enumerate every projective syndrome "
        "direction, every minimum-weight leader support, all displayed "
        "Brianchon/support strata, and the complete projective and monomial "
        "automorphism actions; no sampling is used."
    )
    support_coverage = (
        "Over F_11, the two checkers enumerate every ambiguity support and "
        "its orbit under the complete displayed projective and monomial "
        "automorphism actions; no sampling is used."
    )
    small_q_coverage = (
        "For every prime power q <= 14, the checker enumerates every "
        "frame-normalized embedded six-arc, computes its full uncovered "
        "locus, and tests equality with every nonsingular conic."
    )
    q19_coverage = (
        "Over F_19, the checker constructs the displayed order-60 "
        "icosahedral action and its six-axis arc, then enumerates all 381 "
        "projective points and all fifteen secants to compute the complete "
        "uncovered locus."
    )
    small_k_coverage = (
        "The checker verifies the displayed q=5 four-frame and exhausts all "
        "frame-normalized seven-arcs obtained from the 1,548 normalized "
        "six-arcs over F_11 and 4,015 over F_13; multiplicity-three "
        "deduplication reaches 10,232 and 53,960 distinct seven-arcs, "
        "respectively."
    )
    direct_coordinates = (
        "The replay reconstructs its domain from explicit coordinates and "
        "does not import Lean output."
    )
    return {
        2: (
            "Lean proves the conic-containment implication through the explicit Dye axiom seam; the associated polarity and stabilizer identification remain cited classical consequences.",
            [
                conceptual("classical equality, polarity, and stabilizer identification", CLASSICAL_DYE_RIGIDITY, "The line bound and chord-defect deduction are proved in the manuscript."),
                lean("symmetry-free rigidity implication", ["rigidity"], axioms),
                replay("finite witness and orbit census", ["check_rigidity_degenerate_conic.py"], frame_coverage, "The replay checks the explicit Clebsch witness and normalized class census.", direct_coordinates),
            ],
        ),
        11: (
            "The gate checks the explicit order-sixty action and its point-orbit partition; its identification with the classical A5 action uses Dye.",
            [
                conceptual("classical group identification", CLASSICAL_DYE, "The displayed matrices and their finite action are checked exactly."),
                lean("explicit finite point orbits", ["orbits"], axioms),
            ],
        ),
        12: (
            "The manuscript obtains the twelve-point count from Dye's Brianchon value and the universal defect formula, then identifies the conic by chord exteriority; Lean and the exhaustive replay check the displayed witness independently.",
            [
                conceptual("Brianchon count, chord exteriority, and code--arc dictionary", CLASSICAL_DYE + CLASSICAL_CODE, "The manuscript routes the count through row 24 and proves conic equality directly from the exteriority of all fifteen chords."),
                lean("witness MDS code and projective distance-three locus", ["code_locus"], axioms),
                replay("independent coordinate witness", ["check_rigidity_degenerate_conic.py"], frame_coverage, "The replay verifies the displayed Clebsch class and uncovered conic.", direct_coordinates),
            ],
        ),
        13: (
            "This is a conceptual dictionary and exact counting corollary; it does not inherit a formalization label from adjacent rows.",
            [conceptual("directions, cosets, leaders, and received words", CLASSICAL_CODE, "The manuscript gives the exact projectivization and coset counts.")],
        ),
        14: (
            "The projective action argument is in the manuscript; the executable route checks the displayed automorphism action exactly.",
            [
                conceptual("deep-hole orbit deduction", CLASSICAL_DYE, "The manuscript transports the twelve-point action through the code--arc dictionary."),
                replay("code automorphism action", ["check_code_automorphisms.py"], automorphism_coverage, "The replay checks the displayed monomial automorphisms and syndrome action.", direct_coordinates),
            ],
        ),
        15: (
            "Lean checks the exact syndrome branches and leader-support strata; the separate replay independently exhausts every projective syndrome direction.",
            [
                conceptual("syndrome-oracle reduction", CLASSICAL_CODE, "The manuscript proves the quadratic decision rule from the code--arc dictionary."),
                lean("decoder and ambiguity strata", ["decoder"], axioms),
                replay("independent decoder census", ["check_decoding.py", "check_chirality.py", "check_code_automorphisms.py"], decoder_coverage, "The replay checks distances, leader multiplicities, and ambiguity supports; the imported support and automorphism modules are hash-pinned alongside it.", direct_coordinates),
            ],
        ),
        16: (
            "The line bound is a complete human combinatorial proof; the displayed conic-inscribed values are backed by the exact normalized census.",
            [
                conceptual("six-arc line bound", ["No external input; complete combinatorial proof in the manuscript"], "The line bound is unconditional."),
                replay("conic-inscribed subcensus", ["check_rigidity_degenerate_conic.py"], frame_coverage, "The replay enumerates every frame-normalized six-arc and filters the arcs contained in a nonsingular conic.", direct_coordinates),
            ],
        ),
        17: (
            "The manuscript handles degenerate conics by the proved line bound; Lean checks the nonsingular-conic implication relative to Dye's two declared consequences.",
            [
                conceptual("degenerate-conic reduction and Dye equality boundary", CLASSICAL_DYE, "The manuscript proves the line bound, reduces a degenerate containing conic to the same cardinality equality, and proves the chord-defect identity independently."),
                lean("nonsingular-conic rigidity implication", ["rigidity"], axioms),
            ],
        ),
        18: (
            "The statement is backed by complete exact evaluation-rank enumeration, not by a Lean theorem.",
            [replay("degree-at-most-three loci", ["check_low_degree_loci.py", "check_global_conic_gap.py"], frame_coverage, "The replay evaluates homogeneous forms degree by degree on every uncovered locus; its imported canonical-class generator is hash-pinned alongside it.", frame_shared)],
        ),
        19: (
            "This is a conceptual corollary of the code--arc dictionary and the preceding replay-backed proposition.",
            [conceptual("monomial characterization", CLASSICAL_CODE, "The manuscript reduces monomial code equivalence to projective equivalence and invokes row 18.")],
        ),
        20: (
            "The numerical gap is exact-replay-backed; the qualitative rigidity implication remains separately routed in row 17.",
            [replay("global numerical gap", ["check_global_conic_gap.py"], frame_coverage, "The script exhausts the normalized six-arcs and regenerates the displayed uncovered-locus values.", complementary_replays)],
        ),
        21: (
            "The incidence dictionary is a human consequence of the cited Edge--Dye geometry.",
            [conceptual("Brianchon--support dictionary", CLASSICAL_EDGE_DYE, "The manuscript identifies the support sets through the displayed incidence configuration.")],
        ),
        22: (
            "The manuscript gives the conceptual corollary; Lean checks the exact Brianchon leader-support rows for the displayed witness.",
            [
                conceptual("decoder reconstruction", CLASSICAL_EDGE_DYE, "The reconstruction follows from the preceding dictionary."),
                lean("Brianchon leader supports", ["decoder"], axioms),
            ],
        ),
        23: (
            "The unordered support bipartition is proved by incidence and independently replayed; no orientation or sign is claimed.",
            [
                conceptual("intrinsic support bipartition", CLASSICAL_EDGE_DYE, "The manuscript proves invariance without choosing an orientation."),
                replay("support and automorphism replay", ["check_chirality.py", "check_code_automorphisms.py"], support_coverage, "The scripts exhaust the ambiguity supports and displayed code automorphisms.", direct_coordinates),
            ],
        ),
        24: (
            "The manuscript proves the universal chord-defect identity, quadratic barrier, even-order oval obstruction, and passant window and applies the cited partial-cover theorem; Lean checks the six-arc specialization and an explicit Sylvester distance-two clique certificate.",
            [
                conceptual("universal secant moments and conic-filling window", ["Complete double count in the manuscript; the standard even-order oval nucleus is cited from Hirschfeld"] + CLASSICAL_PARTIAL_COVER, "The identity, defect bound, quadratic barrier, even-order oval obstruction, and lower field-size bound are proved for every k in the manuscript; the stronger upper bound is deduced from the cited partial-cover theorem."),
                conceptual("Clebsch q=11 specialization", CLASSICAL_DYE, "Only the displayed Clebsch specialization uses Dye's ten Brianchon points; it is not asserted for an arbitrary six-arc."),
                lean("six-arc chord-defect algebra and geometric bridge", ["defect_bridge", "chord_identity"], axioms),
                conceptual("Sylvester graph and distance-two interpretation", CLASSICAL_SYLVESTER, "The explicit distance-two clique certificate is kernel checked."),
                lean("Sylvester distance-two clique obstruction", ["field_order"], axioms),
            ],
        ),
        25: (
            "Lean checks the chord formulas and an explicit Sylvester-graph clique certificate; the q=11 classification inherits Dye's rigidity boundary.",
            [
                conceptual("Sylvester graph interpretation and q=11 rigidity dependency", CLASSICAL_SYLVESTER + CLASSICAL_DYE, "The chord arithmetic and explicit finite graph certificate are kernel checked; the manuscript invokes row 17 only for the final q=11 orbit classification."),
                lean("field-order boundary", ["field_order"], axioms),
                replay("small-field boundary", ["check_small_q_uniqueness.py"], small_q_coverage, "The replay checks every stated small-field Clebsch specialization.", direct_coordinates),
            ],
        ),
        26: (
            "The all-field formula is conceptual; q=19 is checked by an independent exact specialization.",
            [
                conceptual("Clebsch-family chord count and associated-conic inclusion", CLASSICAL_DYE_ASSOCIATED_CONIC, "The manuscript derives the polynomial from the ten-Brianchon equality and uses Dye's edge criterion for the associated-conic inclusion."),
                lean("uncovered-locus polynomial", ["clebsch_formula"], axioms),
                replay("q=19 specialization", ["check_q19_nonexample.py"], q19_coverage, "The replay independently constructs and checks the q=19 specialization.", direct_coordinates),
            ],
        ),
        29: (
            "Lean proves the small-arc moment reductions; the k=6 case inherits rows 25 and 17, the terminal k=7 and k=8 exclusions and sharp maximum-six result are exact-replayed, and the MDS statement is the projective arc--syndrome translation.",
            [
                conceptual("small-arc reductions, k=6 dependency, and k=8 field sieve", CLASSICAL_SYLVESTER + CLASSICAL_DYE + CLASSICAL_PARTIAL_COVER, "The manuscript derives the moment equations, applies the partial-cover window, and proves the q=13 passant-saturation reduction; only the k=6 branch invokes rows 25 and 17."),
                conceptual("projective MDS translation", CLASSICAL_CODE, "The length-at-most-eight code classification is the preceding arc classification transported through the standard projective parity-check-column and distance-three syndrome dictionary."),
                lean("four-, five-, and seven-arc moment consequences", ["small"], axioms),
                replay("terminal exclusions through seven points", ["check_small_k_conic_filling.py"], small_k_coverage, "The checker exhausts the displayed fields and arc sizes through k=7 after the moment reduction; it is not evidence for an eight-arc classification.", direct_coordinates),
                c605_replay(),
            ],
        ),
        58: (
            "Two exact replays share canonical class keys and regenerate every printed census field used by the proofs.",
            [replay("complete fifteen-class census", ["check_global_conic_gap.py", "check_low_degree_loci.py"], frame_coverage, "The scripts regenerate projective classes, stabilizers, uncovered counts, and least vanishing degrees.", frame_shared)],
        ),
    }


def checks() -> list[dict[str, object]]:
    output_certificate = json.loads(
        (PAPER_ROOT / "verification" / "checker_outputs.json").read_text(
            encoding="utf-8"
        )
    )
    output_checks = output_certificate.get("checks")
    if not isinstance(output_checks, dict):
        raise ValueError("checker-output certificate has no checks object")
    result = [
        {
            "id": "verification-tool-tests",
            "repository": "paper",
            "cwd": ".",
            "argv": ["python3", "verification/test_verification_tools.py"],
            "timeout_seconds": 120,
        },
        {
            "id": "statement-identity",
            "repository": "paper",
            "cwd": ".",
            "argv": [
                "python3",
                "verification/extract_statement_identity.py",
                "--output",
                "verification/statement_identity.json",
                "--check",
            ],
            "timeout_seconds": 60,
        },
        {
            "id": "manuscript-build",
            "repository": "paper",
            "cwd": ".",
            "argv": ["python3", "verification/check_manuscript_build.py"],
            "timeout_seconds": 300,
        },
        {
            "id": "trust-manifest-regeneration",
            "repository": "paper",
            "cwd": ".",
            "argv": ["python3", "verification/build_trust_manifest.py", "--check"],
            "timeout_seconds": 60,
        },
    ]
    for script in (
        "check_rigidity_degenerate_conic.py",
        "check_decoding.py",
        "check_chirality.py",
        "check_code_automorphisms.py",
        "check_global_conic_gap.py",
        "check_perturbation_gap.py",
        "check_low_degree_loci.py",
        "check_small_q_uniqueness.py",
        "check_q19_nonexample.py",
        "check_small_k_conic_filling.py",
    ):
        output = output_checks.get(script)
        if not isinstance(output, dict):
            raise ValueError(f"checker-output certificate omits {script}")
        result.append(
            {
                "id": script.removesuffix(".py").replace("_", "-"),
                "repository": "paper",
                "cwd": ".",
                "argv": ["python3", script],
                "timeout_seconds": 900,
                "stdout_bytes": output["bytes"],
                "stdout_lines": output["lines"],
                "stdout_sha256": output["sha256"],
            }
        )
    c605_output = output_checks.get("verification/c605_verify.py")
    if not isinstance(c605_output, dict):
        raise ValueError(
            "checker-output certificate omits verification/c605_verify.py"
        )
    result.append(
        {
            "id": "check-c605-eight-point-exclusion",
            "repository": "paper",
            "cwd": ".",
            "argv": ["python3", "verification/c605_verify.py"],
            "timeout_seconds": 120,
            "stdout_bytes": c605_output["bytes"],
            "stdout_lines": c605_output["lines"],
            "stdout_sha256": c605_output["sha256"],
        }
    )
    result.append(
        {
            "id": "lean-rigidity-trust-gate",
            "repository": "lean",
            "cwd": ".",
            "argv": [
                "scripts/guarded-lean",
                "RelativeConicArcs/Gates/ClebschRigidityTrust.lean",
            ],
            "timeout_seconds": 1800,
        }
    )
    return result


def build_manifest() -> dict[str, object]:
    identity = json.loads(IDENTITY_PATH.read_text(encoding="utf-8"))
    if identity.get("claim_count") != 19:
        raise ValueError("statement identity must contain exactly nineteen claims")
    axioms = parse_axioms()
    routes = components_by_row(axioms)
    claims = []
    for source in identity["claims"]:
        row = source["row"]
        boundary, components = routes[row]
        claims.append(claim(source, boundary, components))
    if len(claims) != 19 or set(routes) != {claim["row"] for claim in claims}:
        raise ValueError("claim-route map is incomplete")
    return {
        "schema": "clebsch-rigidity-trust-manifest-v1",
        "manuscript_sha256": sha256(PAPER_ROOT / "clebsch_rigidity.tex"),
        "manuscript_pdf": file_evidence("paper", "clebsch_rigidity.pdf"),
        "statement_identity": file_evidence(
            "paper", "verification/statement_identity.json"
        ),
        "public_documents": [
            file_evidence("paper", "README.md"),
            file_evidence("paper", "verification/README.md"),
        ],
        "lean_repository": {
            "distribution": "separate shared Git repository",
            "url": "https://github.com/tavisrudd/finitegeom",
            "path": ".",
            "commit": PINNED_LEAN_COMMIT,
        },
        "reproducibility_environment": {
            "platform": "x86_64-linux",
            "flake": file_evidence("paper", "flake.nix"),
            "lock": file_evidence("paper", "flake.lock"),
            "paper_toolchain": {
                "python": "3.13.14",
                "texlive": "scheme-full from the pinned nixpkgs input",
                "nix": "2.34.8",
                "git": "2.54.0",
            },
            "formal_toolchain": {
                "lean": "4.32.0-rc1",
                "mathlib_commit": "571b8a8e54219b4d393f75f4b8653fac08197fcc",
            },
        },
        "verify_all": {
            "command": (
                "nix develop --command python3 "
                "verification/verify_release.py "
                "--lean-root /absolute/path/to/finitegeom"
            ),
            "entry_point": file_evidence(
                "paper", "verification/verify_release.py"
            ),
            "output": file_evidence(
                "paper", "verification/verify-release-output.json"
            ),
            "checker_output_certificate": {
                "generator": file_evidence(
                    "paper", "verification/capture_checker_outputs.py"
                ),
                "output": file_evidence(
                    "paper", "verification/checker_outputs.json"
                ),
            },
            "verification_tools": [
                file_evidence("paper", f"verification/{name}")
                for name in (
                    "extract_statement_identity.py",
                    "build_trust_manifest.py",
                    "verify_trust_manifest.py",
                    "test_verification_tools.py",
                    "check_manuscript_build.py",
                )
            ],
            "checks": checks(),
        },
        "claims": claims,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--stdout", action="store_true")
    parser.add_argument("--output", type=Path, default=OUTPUT_PATH)
    args = parser.parse_args()
    rendered = json.dumps(build_manifest(), indent=2, sort_keys=True) + "\n"
    if args.check:
        if args.output.read_text(encoding="utf-8") != rendered:
            raise ValueError(f"stale trust manifest: {args.output}")
    elif args.stdout:
        print(rendered, end="")
    else:
        args.output.write_text(rendered, encoding="utf-8")
        print(f"wrote {args.output}: 19 claim rows", file=sys.stderr)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, UnicodeError, ValueError) as error:
        print(f"manifest construction failed: {error}")
        raise SystemExit(1)
