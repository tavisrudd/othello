#!/usr/bin/env python3
"""Build the deterministic nineteen-row Clebsch rigidity trust manifest."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
from pathlib import Path


PAPER_ROOT = Path(__file__).resolve().parents[1]
REPOSITORY_ROOT = PAPER_ROOT.parents[1]
LEAN_ROOT = Path(
    os.environ.get("CLEBSCH_LEAN_ROOT", REPOSITORY_ROOT / "lean")
).resolve()
IDENTITY_PATH = PAPER_ROOT / "verification" / "statement_identity.json"
OUTPUT_PATH = PAPER_ROOT / "verification" / "trust_manifest.json"
GATE_PATH = "RelativeConicArcs/Gates/ClebschRigidityTrust.lean"
AUDIT_PATH = "verification/clebsch_rigidity_trust/axiom-audit.txt"
PINNED_LEAN_COMMIT = "9c5d474f502a5ae8e189bc9fdf0fffa7ab96e0c5"
PINNED_BASE_COMMIT = "85dfde9e13e6c3d004e0e659fb83c1a4761902d0"


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
    "rigidity_spine": [
        "RelativeConicArcs.OddSixArcPrismExtraction.sixArc_uncoveredOnLine_card_le_order_sub_five",
        "RelativeConicArcs.ClebschDye.sixArc_uncovered_card_le_twelve_of_subset_planeQuadraticLocus",
        "RelativeConicArcs.ClebschDye.isClebschHexagon_of_uncovered_subset_planeConic",
    ],
    "code_rigidity": [
        "RelativeConicArcs.ClebschDye.deepHoleLocus_rigidifies_witnessCode",
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
    "orientation_symmetry": [
        "RelativeConicArcs.PaperIOrientationSymmetry.mem_supportCubicProjectiveStabilizer_iff_cubicLine",
        "RelativeConicArcs.PaperIOrientationSymmetry.supportCubic_projectiveStabilizer_equiv_S5",
        "RelativeConicArcs.PaperIOrientationSymmetry.mem_orientedSupportCubicStabilizer_iff",
        "RelativeConicArcs.PaperIOrientationSymmetry.orientedSupportCubic_stabilizer_equiv_A5",
        "RelativeConicArcs.PaperIOrientationSymmetry.orientedSupportCubic_index_two",
    ],
    "orientation_spine": [
        "RelativeConicArcs.PaperIOrientationCover.antipodalQuotient_fiber_card_two",
        "RelativeConicArcs.PaperIOrientationCover.fiveOrbitals_selfPaired",
        "RelativeConicArcs.PaperIOrientationCover.fiveOrbital_one_mem_each_other_fiber",
        "RelativeConicArcs.PaperIOrientationPentagon.signedOrbitalMatrix_sq",
        "RelativeConicArcs.PaperIOrientationPentagon.orbitalDifference_sq_eq_ten_one_sub_deck",
        "RelativeConicArcs.PaperIOrientationHolonomy.supportSign_eq_triangleProduct",
        "RelativeConicArcs.PaperIOrientationHolonomy.fourPoint_twoGraph_identity",
        "RelativeConicArcs.PaperIOrientationHolonomy.pairBalance_iff_sq_five",
        "RelativeConicArcs.PaperIOrientationHolonomy.supportCubic_translation_invariant",
        "RelativeConicArcs.PaperIOrientationDeterminant.det_signedOrbital_add_diagonal",
        "RelativeConicArcs.PaperIOrientationDeterminant.determinantPencil_oddPart_eq_supportCubic",
        "RelativeConicArcs.PaperIOrientationTraceDual.det_crossGoldenBlock_eq_neg_supportCubic",
        "RelativeConicArcs.PaperIOrientationNodes.derivative_crossGoldenDeterminantLine_eval",
        "RelativeConicArcs.PaperIOrientationNodes.singularPoints_crossGoldenDeterminant_eq_axisClasses",
        "RelativeConicArcs.PaperIOrientationNodes.supportCubic_singularLocus_eq_frame",
        "RelativeConicArcs.PaperIOrientationNodes.supportCubic_framePoints_ordinaryNodes",
        "RelativeConicArcs.PaperIOrientationCommutant.oddModule_rationalCommutant_eq_adjoin_B",
        "RelativeConicArcs.PaperIOrientationCommutant.adjoinGolden_integralPoints_eq_ZsqrtFive",
        "RelativeConicArcs.PaperIOrientationCommutant.oddLattice_integralCommutant_eq_ZsqrtFive",
    ],
}

CLASSICAL_ODD_A5_SPLITTING = (
    "The proposition-valued interface "
    "RelativeConicArcs.PaperIOrientationCommutant."
    "ClassicalOddA5ThreePlusThreeSplitting supplies the classical conjugate "
    "3+3' decomposition, Schur-lemma upper containment, and Galois descent."
)

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
CLASSICAL_SEGRE_TANGENTS = [
    "Ball--Lavrauw 2019, Section 7, for Segre's lemma of tangents",
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


def finite_certificate(
    subclaim: str,
    commands: list[list[str]],
    proof_objects: list[str],
    coverage: str,
    bridge: str,
    independent: str,
) -> dict[str, object]:
    checker_paths = list(dict.fromkeys(command[1] for command in commands))
    return {
        "route": "finite-certificate",
        "subclaim": subclaim,
        "computation": {
            "checker_commands": [{"argv": command} for command in commands],
            "coverage": coverage,
            "soundness_bridge": bridge,
            "independent_replay": independent,
            "residual_trust": (
                "The small Python verifier and exact finite-field arithmetic, "
                "plus the manuscript's interpretation of the certificate data."
            ),
            "artifacts": [
                file_evidence("paper", path) for path in checker_paths
            ],
            "supporting_artifacts": [
                file_evidence("paper", path) for path in proof_objects
            ],
        },
    }


def conic_filling_replay() -> dict[str, object]:
    supporting_artifacts = [
        "verification/conic_filling_search.cpp",
        "verification/conic_filling_replay.py",
        "verification/conic_filling_q13.json",
        "verification/conic_filling_q17.json",
        "verification/conic_filling_q19.json",
        "verification/conic_filling_independent.json",
    ]
    return {
        "route": "exact-replay",
        "subclaim": "terminal eight-point exclusions",
        "computation": {
            "checker_commands": [
                {"argv": ["python3", "verification/conic_filling_verify.py"]}
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
                file_evidence("paper", "verification/conic_filling_verify.py")
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
    lean_evidence = {
        "gate": file_evidence("lean", GATE_PATH),
        "audit": file_evidence("lean", AUDIT_PATH),
        "terminals": terminals,
        "axioms": {terminal: axioms[terminal] for terminal in terminals},
        "validation": {
            "command": (
                "nix develop --command env LEAN_NUM_THREADS=1 lake build "
                "RelativeConicArcs.Gates.ClebschRigidityTrust"
            ),
            "toolchain": {
                "lean": "4.32.0-rc1",
                "mathlib_commit": "571b8a8e54219b4d393f75f4b8653fac08197fcc",
            },
        },
    }
    if "orientation_spine" in groups:
        lean_evidence["conditional_interfaces"] = [CLASSICAL_ODD_A5_SPLITTING]
    return {
        "route": "kernel-checked-lean",
        "subclaim": subclaim,
        "lean": lean_evidence,
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
    q13_tangent_coverage = (
        "Over F_13, the checker constructs all 78 internal points and "
        "78 passants, verifies the cyclic 42-vertex tangent graph and its "
        "five-row unique-closure certificate, exhausts both forced "
        "weight-ten pencil profiles by exact syndrome meet-in-the-middle, "
        "generates all 364 minimum words in four PGL(2,13)-orbits, and "
        "reconstructs the six elliptic orbitals and 78 incidence rows."
    )
    orientation_coverage = (
        "The checker constructs A5 as the even permutations of five "
        "letters, its A5/C5 and A5/D5 actions, both five-valent orbitals, "
        "the fibre-odd signed matrix, all twenty triangle products, the "
        "inverse switching gauge, signed moment balance, all twelve "
        "balanced gauges, every principal minor, the five chartwise gradient "
        "Groebner bases, the six Hessian ranks, both automorphism groups, and "
        "the mod-two degeneration."
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
                lean("symmetry-free rigidity implication", ["rigidity", "rigidity_spine"], axioms),
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
                conceptual("degenerate-conic reduction and Dye equality boundary", CLASSICAL_DYE, "The manuscript proves the line bound, reduces a degenerate containing conic to the same cardinality equality, proves the chord-defect identity independently, and derives the single-orbit statement relative to a fixed conic from Bezout."),
                lean("containing-quadratic rigidity implication", ["rigidity", "rigidity_spine"], axioms),
            ],
        ),
        18: (
            "Fourteen nonsingular cubic minors and the symbolic Clebsch kernel form the load-bearing finite certificate; the old complete evaluation-rank execution remains an independent audit. No Lean theorem is claimed.",
            [
                finite_certificate(
                    "degree-at-most-three orbit certificate",
                    [["python3", "verification/build_finite_census_certificates.py"]],
                    ["verification/finite_census_certificates.json"],
                    "Exactly the fifteen projective q=11 six-arc orbits: fourteen local 10-by-10 cubic minors and the Clebsch Q, QX, QY, QZ kernel record.",
                    "The orbit masses sum to all 1,548 normalized arcs, so the local rank witnesses cover every projective class.",
                    "check_low_degree_loci.py retains the complete evaluation-rank execution on every class.",
                ),
                replay("full evaluation-rank audit", ["check_low_degree_loci.py"], frame_coverage, "The replay evaluates homogeneous forms degree by degree on every uncovered locus.", frame_shared),
            ],
        ),
        19: (
            "This is a conceptual corollary of the code--arc dictionary and the preceding replay-backed proposition.",
            [
                conceptual("monomial characterization", CLASSICAL_CODE, "The manuscript reduces monomial code equivalence to projective equivalence and invokes row 18."),
                lean("projective, monomial-code, coset, and leader correspondence", ["code_rigidity"], axioms),
            ],
        ),
        20: (
            "Orbit masses, concurrence counts, and chord defect certify the fifteen uncovered sizes. Qualitative rigidity is routed separately in row 17, which makes the exhaustive conic-distance execution redundant; it is retained as reported computation over all 160,930 nonsingular conics rather than as a claim.",
            [
                finite_certificate(
                    "fifteen-orbit uncovered-size ledger",
                    [["python3", "verification/build_finite_census_certificates.py"]],
                    ["verification/finite_census_certificates.json"],
                    "All fifteen q=11 projective orbits, with stabilizers, masses, triple concurrence counts, and uncovered sizes.",
                    "The checked identities |G_A|m_A=360, sum m_A=1,548, and |U(A)|=22-c(A) prove completeness and every displayed size.",
                    "check_global_conic_gap.py reconstructs the full normalized and conic domains independently.",
                ),
                replay("global conic-distance audit", ["check_global_conic_gap.py"], frame_coverage, "The streaming exact program checks every normalized arc and all 160,930 nonsingular conics, regenerating every intersection histogram and nearest witness.", complementary_replays),
            ],
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
            "The support bipartition and intrinsic orientation theorem have complete human proofs. The exact replay checks every finite identity independently. Lean kernel-checks the eight-step orientation spine; the two commutant equalities use the explicitly recorded classical 3+3' splitting interface.",
            [
                conceptual("intrinsic support bipartition", CLASSICAL_EDGE_DYE, "The manuscript proves invariance without choosing an orientation."),
                replay("support and automorphism replay", ["check_chirality.py", "check_code_automorphisms.py"], support_coverage, "The scripts exhaust the ambiguity supports and displayed code automorphisms.", direct_coordinates),
                replay("support cubic, continuation operator, and diagonal determinant pencil", ["check_orientation_two_graph.py"], orientation_coverage, "The manuscript proves the switching invariance, inverse gauge construction, association-algebra identity, and Jacobi complementary-minor deduction.", direct_coordinates),
                lean("antipodal cover through rational and integral commutants", ["orientation_symmetry", "orientation_spine"], axioms),
            ],
        ),
        24: (
            "The manuscript proves the universal chord-defect identity, the odd-order concurrence spectrum, the quadratic barrier, the even-order oval obstruction, and the passant window, and applies the cited partial-cover theorem; Lean checks the six-arc specialization and an explicit Sylvester distance-two clique certificate.",
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
            "The golden normal form and the all-field formula are conceptual; q=19 is checked by an independent exact specialization.",
            [
                conceptual("Clebsch-family chord count and associated-conic inclusion", CLASSICAL_DYE_ASSOCIATED_CONIC, "The manuscript normalizes the equality configuration over Z[phi], derives the polynomial from the ten-Brianchon equality, and uses Dye's edge criterion for the associated-conic inclusion."),
                lean("uncovered-locus polynomial", ["clebsch_formula"], axioms),
                replay("q=19 specialization", ["check_q19_nonexample.py"], q19_coverage, "The replay independently constructs and checks the q=19 specialization.", direct_coordinates),
            ],
        ),
        29: (
            "Lean proves only the small-arc moment reductions. The named pencil-saturation lemma, the q=13 saturated weight-eight exclusion, and the orbit-span/automorphism conclusions have human structural proofs. Weight ten, the q=11/q=13 seven-arc leaves, and the sharp q=13,17,19 maximum-six assertion retain finite certificates; the minimum-layer classification remains trusted execution.",
            [
                conceptual("small-arc reductions, k=6 dependency, and k=8 field sieve", CLASSICAL_SYLVESTER + CLASSICAL_DYE + CLASSICAL_PARTIAL_COVER, "The manuscript derives the moment equations, applies the partial-cover window, and proves the q=13 passant-saturation reduction; only the k=6 branch invokes rows 25 and 17."),
                conceptual("q=13 tangent reduction", CLASSICAL_SEGRE_TANGENTS, "The manuscript reduces a weight-eight word to a seven-clique and displays the complete six-difference-set, five-row unique-closure certificate."),
                conceptual("projective MDS translation", CLASSICAL_CODE, "The length-at-most-eight code classification is the preceding arc classification transported through the standard projective parity-check-column and distance-three syndrome dictionary."),
                lean("four-, five-, and seven-arc moment consequences", ["small"], axioms),
                finite_certificate(
                    "q=13 weight-ten profile exclusions",
                    [
                        ["python3", "verification/q13_weight10_profiles.py", "--check"],
                        ["python3", "verification/q13_weight10_independent.py"],
                    ],
                    ["verification/q13_weight10_profiles.json"],
                    "The two exhaustive pencil-profile domains contain 6,531,840 and 166,561,920 supports.",
                    "Canonical disjoint sets of partial 78-bit XOR syndromes exclude zero; a differently split full-fibre dynamic program checks the same domains.",
                    "The old meet-in-the-middle branch in check_q13_tangent_code.py remains corroboration.",
                ),
                replay("q=13 minimum-layer classification and reconstruction", ["check_q13_tangent_code.py"], q13_tangent_coverage, "The replay checks the displayed cyclic certificate and independently rebuilds the binary incidence code, its 364-word minimum layer, concurrence profiles, and incidence rows. The orbit-span and automorphism conclusions are proved structurally in the companion.", direct_coordinates),
                finite_certificate(
                    "q=11 and q=13 seven-arc exclusions",
                    [["python3", "verification/build_finite_census_certificates.py"]],
                    ["verification/finite_census_certificates.json"],
                    "The 1,820 seven-arcs surviving the field and size reduction form one q=11 and two q=13 projective orbits.",
                    "Three orbit masses and three nonsingular quadratic evaluation minors cover the complete reduced domain.",
                    "The --audit mode rebuilds the 10,232 and 53,960 normalized seven-arc domains.",
                ),
                finite_certificate(
                    "q=13,17,19 maximum passant-arc size six",
                    [
                        ["python3", "verification/terminal_orbit_dag.py"],
                        ["python3", "verification/terminal_orbit_dag.py", "--check"],
                        ["python3", "verification/terminal_orbit_dag_replay.py", "--check"],
                    ],
                    [
                        "verification/terminal_orbit_dag.json.gz",
                        "verification/terminal_orbit_dag_replay.json",
                    ],
                    "The complete 604, 4,442, and 11,260-node root-edge orbit DAGs over q=13,17,19, including every transition and terminal blocker assignment.",
                    "Rooted transition masses and the global edge-coverage identity inductively cover every labelled arc; explicit six-point witnesses prove sharpness.",
                    "Increasing-index backtracking uses no group action or canonical key, and the legacy C++/discriminant route is a third check.",
                ),
                conic_filling_replay(),
            ],
        ),
        58: (
            "The orbit ledger and local witnesses are the direct finite proof surface. The complete normalized enumerations and conic audit remain independent trusted executions.",
            [
                finite_certificate(
                    "complete fifteen-class orbit ledger",
                    [["python3", "verification/build_finite_census_certificates.py"]],
                    ["verification/finite_census_certificates.json"],
                    "All fifteen q=11 projective classes with canonical representatives, stabilizers, masses, concurrence counts, conic histograms, and local evaluation minors.",
                    "The orbit-mass sum and local witnesses certify every printed table row.",
                    "The full normalized-domain programs rebuild the same canonical keys and table fields.",
                ),
                replay("complete census audit", ["check_global_conic_gap.py", "check_low_degree_loci.py"], frame_coverage, "The scripts regenerate projective classes, stabilizers, uncovered counts, and least vanishing degrees.", frame_shared),
            ],
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
        {
            "id": "computational-companion-trust",
            "repository": "paper",
            "cwd": ".",
            "argv": [
                "python3",
                "verification/verify_computational_companion.py",
            ],
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
        "check_q13_tangent_code.py",
        "check_orientation_two_graph.py",
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
    conic_filling_output = output_checks.get("verification/conic_filling_verify.py")
    if not isinstance(conic_filling_output, dict):
        raise ValueError(
            "checker-output certificate omits verification/conic_filling_verify.py"
        )
    result.append(
        {
            "id": "check-conic_filling-eight-point-exclusion",
            "repository": "paper",
            "cwd": ".",
            "argv": ["python3", "verification/conic_filling_verify.py"],
            "timeout_seconds": 120,
            "stdout_bytes": conic_filling_output["bytes"],
            "stdout_lines": conic_filling_output["lines"],
            "stdout_sha256": conic_filling_output["sha256"],
        }
    )
    for check_id, argv, timeout in (
        (
            "finite-census-direct",
            ["python3", "verification/build_finite_census_certificates.py"],
            120,
        ),
        (
            "finite-census-audit",
            ["python3", "verification/build_finite_census_certificates.py", "--audit"],
            900,
        ),
        (
            "q13-weight-ten-certificate",
            ["python3", "verification/q13_weight10_profiles.py", "--check"],
            900,
        ),
        (
            "q13-weight-ten-independent",
            ["python3", "verification/q13_weight10_independent.py"],
            900,
        ),
        (
            "terminal-orbit-dag-direct",
            ["python3", "verification/terminal_orbit_dag.py"],
            180,
        ),
        (
            "terminal-orbit-dag-regeneration",
            ["python3", "verification/terminal_orbit_dag.py", "--check"],
            900,
        ),
        (
            "terminal-orbit-dag-independent",
            ["python3", "verification/terminal_orbit_dag_replay.py", "--check"],
            900,
        ),
    ):
        output = output_checks.get(check_id)
        if not isinstance(output, dict):
            raise ValueError(f"checker-output certificate omits {check_id}")
        result.append(
            {
                "id": f"check-{check_id}",
                "repository": "paper",
                "cwd": ".",
                "argv": argv,
                "timeout_seconds": timeout,
                "stdout_bytes": output["bytes"],
                "stdout_lines": output["lines"],
                "stdout_sha256": output["sha256"],
            }
        )
    result.append(
        {
            "id": "lean-rigidity-trust-gate",
            "repository": "lean",
            "cwd": ".",
            "argv": [
                "nix",
                "develop",
                "--command",
                "env",
                "LEAN_NUM_THREADS=1",
                "lake",
                "build",
                "RelativeConicArcs.Gates.ClebschRigidityTrust",
            ],
            "timeout_seconds": 1800,
            "axiom_audit": file_evidence("lean", AUDIT_PATH),
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
        "computational_companion": {
            "manuscript": file_evidence(
                "paper", "clebsch_rigidity_computational_companion.tex"
            ),
            "pdf": file_evidence(
                "paper", "clebsch_rigidity_computational_companion.pdf"
            ),
            "trust_ledger": file_evidence(
                "paper", "verification/computational_companion_trust.json"
            ),
            "finite_boundary_manifest": file_evidence(
                "paper", "verification/finite_boundary_manifest.json"
            ),
            "evidence": [
                file_evidence("paper", f"verification/{name}")
                for name in (
                    "build_finite_census_certificates.py",
                    "finite_census_certificates.json",
                    "finite_census_certificates.sha256",
                    "q13_weight10_profiles.py",
                    "q13_weight10_profiles.json",
                    "q13_weight10_independent.py",
                    "terminal_orbit_dag.py",
                    "terminal_orbit_dag.json.gz",
                    "terminal_orbit_dag_replay.py",
                    "terminal_orbit_dag_replay.json",
                    "terminal_orbit_dag.sha256",
                )
            ],
        },
        "statement_identity": file_evidence(
            "paper", "verification/statement_identity.json"
        ),
        "public_documents": [
            file_evidence("paper", "README.md"),
            file_evidence("paper", "verification/README.md"),
        ],
        "lean_repository": {
            "distribution": "separate shared Git repository",
            "url": "https://github.com/tavisrudd/finitegeom-clebsch-q11-certificates",
            "path": ".",
            "commit": PINNED_LEAN_COMMIT,
            "finitegeom_commit": PINNED_BASE_COMMIT,
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
                    "verify_computational_companion.py",
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
