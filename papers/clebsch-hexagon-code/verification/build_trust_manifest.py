#!/usr/bin/env python3
"""Build the deterministic claim-by-claim Clebsch trust manifest."""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = ROOT.parents[1]
LEAN_ROOT = REPOSITORY / "lean"
STATEMENTS = ROOT / "verification" / "statement_identity.json"
OUTPUT = ROOT / "verification" / "trust_manifest.json"
AUDIT_PATH = "verification/clebsch_paper_trust/axiom-audit.txt"
GATE_PATH = "RelativeConicArcs/Gates/ClebschPaperTrust.lean"
GATE_TARGET = "RelativeConicArcs.Gates.ClebschPaperTrust"
GATE_COMMAND = (
    "nix develop --command env LEAN_NUM_THREADS=1 "
    f"lake build {GATE_TARGET}"
)
PINNED_LEAN_COMMIT = "43c403b23e7cb6b9d66dda01bb43a91bec9ea465"


def digest_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def file_evidence(repository: str, path: str) -> dict[str, str]:
    base = ROOT if repository == "paper" else LEAN_ROOT
    return {
        "repository": repository,
        "path": path,
        "sha256": digest_bytes((base / path).read_bytes()),
    }


def parse_axioms() -> dict[str, list[str]]:
    text = (LEAN_ROOT / AUDIT_PATH).read_text(encoding="utf-8")
    pattern = re.compile(
        r"'([^']+)' (does not depend on any axioms|depends on axioms: \[(.*?)\])",
        re.DOTALL,
    )
    result: dict[str, list[str]] = {}
    for match in pattern.finditer(text):
        terminal = match.group(1)
        body = match.group(3)
        result[terminal] = (
            []
            if body is None
            else [part.strip() for part in body.replace("\n", " ").split(",")]
        )
    return result


AXIOMS = parse_axioms()


TERMINALS = {
    "phase": [
        "RelativeConicArcs.ClebschGateway.CoxeterPhase.conicPhase_length",
        "RelativeConicArcs.ClebschGateway.CoxeterPhase.conicPhase_distance",
        "RelativeConicArcs.ClebschGateway.CoxeterPhase.recordedFullConicOrder",
    ],
    "moments": [
        "RelativeConicArcs.ClebschMomentTrade.signedMoment_antipodal_even",
        "RelativeConicArcs.ClebschMomentTrade.signedMoment_barycentre_cancel",
        "RelativeConicArcs.ClebschMomentTrade.witness_exact_strength_two",
        "RelativeConicArcs.ClebschMomentTrade.vectorMomentForm_ne_zero_of_shadow",
    ],
    "quotient": [
        "RelativeConicArcs.ConicMatchingQuotient.secant_veronese",
        "RelativeConicArcs.ConicMatchingQuotient.secant_switch",
        "RelativeConicArcs.ConicMatchingQuotient.conicForm_dvd_secant_switch",
        "RelativeConicArcs.ConicMatchingQuotient.matchingProduct_veronese_congr",
    ],
    "harmonic": [
        "RelativeConicArcs.ConicHarmonicQuotient.decomposition_two",
        "RelativeConicArcs.ConicHarmonicQuotient.decomposition_four",
        "RelativeConicArcs.ConicHarmonicQuotient.finrank_harmonic_two_zmod5",
        "RelativeConicArcs.ConicHarmonicQuotient.finrank_harmonic_two_zmod7",
        "RelativeConicArcs.ConicHarmonicQuotient.finrank_harmonic_two_zmod11",
        "RelativeConicArcs.ConicHarmonicQuotient.finrank_harmonic_four_zmod11",
    ],
    "factorization": [
        "RelativeConicArcs.ClebschFactorization.a3_factorizationImage_finrank",
        "RelativeConicArcs.ClebschFactorization.b3_factorizationImage_finrank",
        "RelativeConicArcs.ClebschFactorization.h3_factorizationImage_finrank",
    ],
    "balanced": [
        "RelativeConicArcs.ClebschBalancedSheets.b3_balancedHalf_unique",
        "RelativeConicArcs.ClebschBalancedSheets.h3_balancedHalf_unique",
        "RelativeConicArcs.ClebschBalancedSheets.b3_signedCubic_stabilizer_eq_characterKernel",
        "RelativeConicArcs.ClebschBalancedSheets.h3_signedCubic_stabilizer_eq_characterKernel",
    ],
    "depth": [
        "RelativeConicArcs.ClebschDoubleCosetDepth.generatedOrbit_card",
        "RelativeConicArcs.ClebschDoubleCosetDepth.representativeProfile_values",
        "RelativeConicArcs.ClebschDoubleCosetDepth.profileLinearMap_range_finrank",
        "RelativeConicArcs.ClebschDoubleCosetDepth.profileLinearMap_ker_finrank",
        "RelativeConicArcs.ClebschDoubleCosetDepth.representativeProfile_injective",
        "RelativeConicArcs.ClebschDoubleCosetDepth.positiveProfiles_weightedBarycentre",
        "RelativeConicArcs.ClebschDoubleCosetDepth.cubicFirst_pushforward",
        "RelativeConicArcs.ClebschDoubleCosetDepth.singletonOrbits_recover_unordered_pair",
        "RelativeConicArcs.ClebschDoubleCosetDepth.chosenPositiveSingleton_recovers_decoratedParent",
    ],
    "gluing": [
        "RelativeConicArcs.ClebschArithmeticGluing.a3_matching_is_fused",
        "RelativeConicArcs.ClebschArithmeticGluing.b3_reductions_induce_split_matchings",
        "RelativeConicArcs.ClebschArithmeticGluing.goldenTransporter_swaps_matchings",
        "RelativeConicArcs.ClebschArithmeticGluing.h3_stabilizer_generation_word_data",
        "RelativeConicArcs.ClebschArithmeticGluing.transporters_are_outer",
        "RelativeConicArcs.ClebschArithmeticGluing.rankThree_split_fused_trichotomy",
    ],
    "witt": [
        "RelativeConicArcs.ClebschWittHadamard.residueBlocks_two_design",
        "RelativeConicArcs.ClebschWittHadamard.code_weight_distribution",
        "RelativeConicArcs.ClebschWittHadamard.hexads_steiner_five",
        "RelativeConicArcs.ClebschWittHadamard.secant_exhaustion",
        "RelativeConicArcs.ClebschWittHadamard.hadamard_gram",
        "RelativeConicArcs.ClebschWittHadamard.parent_intersection_and_join",
        "RelativeConicArcs.ClebschWittHadamard.row_column_hinge_has_no_inner_witness",
    ],
    "torsor": [
        "RelativeConicArcs.ClebschTorsorRosetta.no_invariant_point",
        "RelativeConicArcs.ClebschTorsorRosetta.fixedChildQuotient_is_t11",
        "RelativeConicArcs.ClebschTorsorRosetta.one_sign_character_three_readouts",
        "RelativeConicArcs.ClebschTorsorRosetta.rankThree_split_inert_orientation",
        "RelativeConicArcs.ClebschTorsorRosetta.q11_outer_readouts_agree",
        "RelativeConicArcs.ClebschTorsorRosetta.golden_characteristic_zero_reduction_dictionary",
    ],
    "survival": [
        "RelativeConicArcs.ClebschSurvivalBoundary.exact_mod40_residue_partition",
        "RelativeConicArcs.ClebschSurvivalBoundary.mod40_prediction_of_frozen_hypotheses",
    ],
    "passages": [
        "RelativeConicArcs.ClebschPassageInterfaces.theta_signature_erases_sheet",
        "RelativeConicArcs.ClebschPassageInterfaces.rankEightFourier_square",
        "RelativeConicArcs.ClebschPassageInterfaces.rankSixteenFourier_square",
        "RelativeConicArcs.ClebschPassageInterfaces.Fourier_restriction_traces_zero",
        "RelativeConicArcs.ClebschPassageInterfaces.monomialTransport_kernel_equivalence",
        "RelativeConicArcs.ClebschPassageInterfaces.fixedParty_fourier_support_equivalence",
    ],
}


CLASSICAL_INPUTS = [
    "Dye 1991 Theorems 1 and 3, pages 275--278",
    "Edge 1956 Sections 29--32, finite Clebsch configuration",
    "Jurrius--Pellikaan 2015 Proposition 3.11 and Theorems 5.3, 5.7",
]
MODULAR_INPUTS = [
    "Degree-eleven two-transitive permutation module commuting algebra calculation",
    "Characteristic-eleven projective-cover Loewy structure 1|9|1",
    "Exact displayed Tate-cycle and divided-transfer matrix calculations",
]
TORSOR_INPUTS = [
    "Determinant square-class character on PGL2 with kernel PSL2",
    "Quadratic-field split and inert factorization at the displayed primes",
    "Classical Mathieu group names attached after literal finite closure",
]


def lean_component(subclaim: str, groups: list[str]) -> dict[str, object]:
    terminals = list(dict.fromkeys(t for group in groups for t in TERMINALS[group]))
    missing = [terminal for terminal in terminals if terminal not in AXIOMS]
    if missing:
        raise RuntimeError(f"axiom audit omits terminals: {missing}")
    return {
        "route": "full-trust-lean",
        "subclaim": subclaim,
        "lean": {
            "gate": file_evidence("lean", GATE_PATH),
            "audit": file_evidence("lean", GATE_PATH),
            "terminals": terminals,
            "axioms": {terminal: AXIOMS[terminal] for terminal in terminals},
            "validation": {
                "command": GATE_COMMAND,
                "output": file_evidence("lean", AUDIT_PATH),
            },
        },
    }


def conceptual_component(
    subclaim: str,
    inputs: list[str],
    remainder: str,
) -> dict[str, object]:
    return {
        "route": "conceptual-cited-inputs",
        "subclaim": subclaim,
        "cited_inputs": inputs,
        "unconditional_remainder": remainder,
    }


def computation_component(
    subclaim: str,
    bundle: str,
    detail: str,
) -> dict[str, object]:
    if bundle == "torsor":
        prefix = "verification/evidence/torsor_dictionary"
        independent = (
            "Primary generators and separately written replay programs are both "
            "executed by verify.py."
        )
    elif bundle == "passages":
        prefix = "verification/evidence/passage_interfaces"
        independent = (
            "The bundle rebuilds the finite tables from frozen inputs and checks "
            "their independent transport identities."
        )
    elif bundle == "holonomy":
        prefix = "verification/evidence/four_sheet_holonomy"
        independent = (
            "A direct 24-by-21 rank-drop calculation and the reduced 9-by-9 "
            "cycle-transport calculation are both regenerated and compared."
        )
    else:
        raise ValueError(bundle)
    return {
        "route": "exact-replay-certificate",
        "subclaim": subclaim,
        "computation": {
            "checker": f"python3 {prefix}/verify.py",
            "soundness_bridge": detail,
            "coverage": "All displayed finite fields, group elements, matching orbits, and matrices are exhausted; no sampling is used.",
            "independent_replay": independent,
            "residual_trust": "Exact Python integer and finite-field arithmetic plus the classical semantic identifications stated in the manuscript.",
            "artifacts": [
                file_evidence("paper", f"{prefix}/verify.py"),
                file_evidence("paper", f"{prefix}/manifest.sha256"),
                file_evidence("paper", f"{prefix}/README.md"),
            ],
        },
    }


def baseline_component(
    subclaim: str,
    scripts: list[str],
    detail: str,
) -> dict[str, object]:
    return {
        "route": "exact-replay-certificate",
        "subclaim": subclaim,
        "computation": {
            "checker": " and ".join(f"python3 {script}" for script in scripts),
            "soundness_bridge": detail,
            "coverage": "The checker exhausts the stated frame-normalized finite domain over F_11 or the explicitly listed small fields.",
            "independent_replay": "The computation reconstructs its finite objects from coordinates and imports neither Lean proofs nor generated certificate outputs.",
            "residual_trust": "Exact Python finite-field arithmetic and the manuscript's stated coordinate-to-geometric dictionary.",
            "artifacts": [file_evidence("paper", script) for script in scripts],
        },
    }


def theorem_source(statement: dict[str, object]) -> dict[str, str]:
    return {
        "kind": "theorem-environment",
        "claim_key": str(statement["claim_key"]),
        "sha256": str(statement["sha256"]),
    }


def verbatim_source(tex: str) -> dict[str, str]:
    return {"kind": "verbatim", "tex": tex, "sha256": digest_bytes(tex.encode())}


def claim(
    claim_id: str,
    source: dict[str, str],
    location: str,
    boundary: str,
    components: list[dict[str, object]],
) -> dict[str, object]:
    if len(components) == 1:
        component = dict(components[0])
        component.pop("subclaim", None)
        return {
            "id": claim_id,
            "source": source,
            "paper_location": location,
            "trust_boundary": boundary,
            **component,
        }
    return {
        "id": claim_id,
        "source": source,
        "paper_location": location,
        "trust_boundary": boundary,
        "route": "mixed",
        "components": components,
    }


def split_items(tex: str) -> list[str]:
    body = tex.split("\\begin{enumerate}", 1)[1]
    body = body.split("\n", 1)[1].rsplit("\\end{enumerate}", 1)[0]
    return [part.strip() for part in body.split("\\item ")[1:]]


def components_for_clause(label: str, index: int) -> list[dict[str, object]]:
    key = f"{label}:{index}"
    if label == "thm:headline-rigidity-phase":
        if index == 1:
            return [
                conceptual_component("rigidity implication and classical equality boundary", CLASSICAL_INPUTS, "The line bound and chord-defect deduction are proved in the manuscript."),
                baseline_component("finite rigidity census", ["check_rigidity_degenerate_conic.py"], "The exhaustive census checks the numerical classification clause."),
            ]
        if index in (2, 3):
            return [
                lean_component("rank-three length, distance, and full-conic specialization", ["phase"]),
                conceptual_component("Coxeter coordinate semantics", CLASSICAL_INPUTS, "The displayed formulas follow after the cited coordinate identification."),
            ]
        return [
            lean_component("split-torus finite character data", ["gluing"]),
            conceptual_component("classical split maximal-torus identification", TORSOR_INPUTS, "The finite determinant and order checks are kernel checked."),
        ]
    if label == "thm:headline-factorization":
        if index == 1:
            return [
                lean_component("conic quotient and factorization ranks", ["quotient", "factorization"]),
                conceptual_component("geometric meaning of the frozen coordinates", CLASSICAL_INPUTS, "The divisibility implication and displayed finite ranks are kernel checked."),
            ]
        if index == 2:
            return [
                lean_component("balanced-sheet recovery", ["balanced"]),
                conceptual_component("geometric meaning of the frozen coordinates", CLASSICAL_INPUTS, "The uniqueness statement is kernel checked on the displayed configurations."),
            ]
        if index == 3:
            return [lean_component("signed-moment filtration", ["moments", "balanced"])]
        return [
            lean_component("six-profile compression and singleton matching-row recovery", ["depth"]),
            conceptual_component(
                "double-coset group names",
                CLASSICAL_INPUTS,
                "The orbit arrays, ranks, and label separation are kernel checked; the terminal recovers a frozen matching-table row only, with no row-to-geometric-parent bridge.",
            ),
        ]
    if label == "thm:headline-gluing":
        if index == 3:
            return [
                lean_component("fixed-child table-row quotient", ["gluing", "torsor"]),
                computation_component(
                    "finite fixed-child row replay",
                    "torsor",
                    "The bundle checks the 22-row action and its two-point quotient.",
                ),
                conceptual_component(
                    "geometric-parent boundary",
                    TORSOR_INPUTS,
                    "No equivalence between the table rows and geometric Clebsch parents is asserted.",
                ),
            ]
        return [
            lean_component("rank-three arithmetic gluing", ["gluing", "torsor"]),
            computation_component("finite gluing and fixed-child replay", "torsor", "The bundle checks the exact matching orbits, determinant swaps, and fixed-child quotient."),
            conceptual_component("classical group and number-field semantics", TORSOR_INPUTS, "The finite comparison maps are checked exactly."),
        ]
    if label == "thm:four-sheet-holonomy":
        if index == 1:
            return [
                conceptual_component("constant sections and systematic transport reduction", CLASSICAL_INPUTS, "The manuscript derives the quotient operator and equality of excess kernel dimensions."),
                computation_component("section-to-transport finite bridge", "holonomy", "The bundle compares all 720 section and transport matrices in the displayed finite fields."),
            ]
        if index == 2:
            return [
                conceptual_component("cycle obstructions and relative-frame count", CLASSICAL_INPUTS, "The manuscript derives the three localized factors and the double-coset multiplicities."),
                computation_component("divisor, cycle ledger, and multiplicity certificate", "holonomy", "The bundle checks the determinant by two arithmetic paths, excludes extra components, and classifies the exact support cells."),
            ]
        return [
            conceptual_component("boundary, merger, and ramification distinction", CLASSICAL_INPUTS, "The manuscript derives the exceptional primes from the unique nonboundary branch point and the integral mod-7 identity."),
            computation_component("exceptional-characteristic replay", "holonomy", "The bundle checks every stated finite rank histogram and boundary specialization."),
        ]
    if label == "thm:torsor-rosetta-close":
        return [
            lean_component("torsor dictionary interface", ["torsor", "gluing", "witt"]),
            computation_component("outer-equivariant torsor dictionary", "torsor", "The bundle verifies every finite and arithmetic dictionary leg used by the theorem."),
            conceptual_component("torsor, descent, and Mathieu names", TORSOR_INPUTS, "No cross-characteristic scheme or integral cubic is asserted."),
        ]
    raise KeyError(key)


def generic_components(label: str) -> list[dict[str, object]]:
    if label in {"prop:deep-holes-conic", "thm:rigidity"}:
        return [
            conceptual_component("finite-geometric rigidity proof", CLASSICAL_INPUTS, "The manuscript proves the line-bound and chord-defect remainder."),
            baseline_component("frame-normalized rigidity census", ["check_rigidity_degenerate_conic.py"], "The checker exhausts all normalized six-arcs."),
        ]
    if label in {"prop:decoding-oracle", "prop:deep-hole-orbit", "prop:brianchon-support", "cor:decoder-brianchon"}:
        return [
            conceptual_component("decoding and Brianchon geometry", CLASSICAL_INPUTS, "The syndrome-weight dictionary and deductions are in the manuscript."),
            baseline_component("decoder census", ["check_decoding.py"], "The checker exhausts syndrome and leader incidences."),
        ]
    if label == "prop:chirality":
        return [
            conceptual_component("intrinsic support bipartition", CLASSICAL_INPUTS, "The reconstruction argument is stated in the manuscript."),
            baseline_component("support bipartition replay", ["check_chirality.py", "check_code_automorphisms.py"], "The scripts exhaust the ambiguity supports and affine automorphisms."),
        ]
    if label == "prop:low-degree-rigidity":
        return [baseline_component("degree-at-most-three rank census", ["check_low_degree_loci.py"], "The checker exhausts all normalized classes and exact evaluation ranks.")]
    if label == "thm:gap":
        return [baseline_component("global and perturbation gaps", ["check_global_conic_gap.py", "check_perturbation_gap.py"], "The scripts exhaust all conics and all stated one-point perturbations.")]
    if label == "thm:why11":
        return [
            conceptual_component("chord-moment uniqueness argument", CLASSICAL_INPUTS, "The manuscript proves the all-field formula and uses the cited small-field bound."),
            baseline_component("small-field boundary replay", ["check_small_q_uniqueness.py"], "The checker verifies every stated small-field case."),
        ]
    if label == "prop:clebsch-family-uncovered":
        return [
            conceptual_component("all-field uncovered-locus formula", CLASSICAL_INPUTS, "The chord count gives the displayed polynomial."),
            baseline_component("q=19 independent specialization", ["check_q19_nonexample.py"], "The script independently checks the q=19 specialization."),
        ]
    if label == "prop:h3-arrangement":
        return [
            conceptual_component("reflection-arrangement interpretation", CLASSICAL_INPUTS, "The manuscript separates the classical arrangement names from the local transport."),
            baseline_component("reflection coordinate replay", ["check_reflection_arrangements.py"], "The script checks the exact finite projectivity and incidence spectra."),
        ]
    if label == "thm:small-k-conic-filling":
        return [
            conceptual_component("universal chord-moment reduction", CLASSICAL_INPUTS, "The proof reduces the classification to the finite leaves."),
            baseline_component("small-k finite leaves", ["check_small_k_conic_filling.py"], "The checker exhausts the displayed fields and sizes."),
        ]
    if label == "prop:modular-depth-plane":
        return [conceptual_component("modular depth quotient and Tate boundary", MODULAR_INPUTS, "Every rank, kernel, relation, and transfer calculation is printed or derived in the proof and appendix.")]
    if label == "lem:rank-three-splitting":
        return [
            conceptual_component("elementary split--inert frame proof", TORSOR_INPUTS, "The proof lists the squares and multiplies the three displayed quadratic factorizations."),
            lean_component("finite split--inert interface", ["gluing"]),
        ]
    if label == "prop:mod40-reciprocity":
        return [
            conceptual_component("quadratic reciprocity and Chinese-remainder proof", TORSOR_INPUTS, "The residue lists follow from the supplementary law for two and reciprocity for five."),
            lean_component("conditional residue-partition interface", ["survival"]),
        ]
    if label == "lem:sign-torsor-no-section":
        return [
            conceptual_component("abstract quotient-action proof", TORSOR_INPUTS, "The first isomorphism theorem identifies the transitive two-point action and proves the fixed-point obstruction."),
            lean_component("finite no-section and one-class interfaces", ["torsor"]),
        ]
    return [conceptual_component("retained conceptual statement", CLASSICAL_INPUTS, "The unconditional local deduction is supplied in the manuscript.")]


def checks() -> list[dict[str, object]]:
    result: list[dict[str, object]] = [
        {
            "id": "verification-tool-tests",
            "repository": "paper",
            "cwd": ".",
            "argv": ["python3", "verification/test_verification_tools.py"],
            "timeout_seconds": 120,
        },
        {
            "id": "statement-extraction",
            "repository": "paper",
            "cwd": ".",
            "argv": ["python3", "verification/extract_statement_identity.py", "clebsch_hexagon_code.tex"],
            "timeout_seconds": 60,
        },
    ]
    for script in (
        "check_rigidity_degenerate_conic.py",
        "check_reflection_arrangements.py",
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
        result.append(
            {
                "id": script.removesuffix(".py").replace("_", "-"),
                "repository": "paper",
                "cwd": ".",
                "argv": ["python3", script],
                "timeout_seconds": 900,
            }
        )
    result.extend(
        [
            {
                "id": "passage-interface-evidence",
                "repository": "paper",
                "cwd": "verification/evidence/passage_interfaces",
                "argv": ["python3", "verify.py"],
                "timeout_seconds": 900,
            },
            {
                "id": "torsor-dictionary-evidence",
                "repository": "paper",
                "cwd": "verification/evidence/torsor_dictionary",
                "argv": ["python3", "verify.py"],
                "timeout_seconds": 1800,
            },
            {
                "id": "four-sheet-holonomy-evidence",
                "repository": "paper",
                "cwd": "verification/evidence/four_sheet_holonomy",
                "argv": ["python3", "verify.py"],
                "timeout_seconds": 900,
            },
            {
                "id": "lean-mathlib-cache",
                "repository": "lean",
                "cwd": ".",
                "argv": [
                    "nix",
                    "develop",
                    "--command",
                    "lake",
                    "exe",
                    "cache",
                    "get",
                ],
                "timeout_seconds": 900,
            },
            {
                "id": "lean-paper-trust-gate",
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
                    GATE_TARGET,
                ],
                "timeout_seconds": 1800,
            },
        ]
    )
    return result


def main() -> None:
    extracted = json.loads(STATEMENTS.read_text(encoding="utf-8"))
    statements = extracted["statements"]
    claims: list[dict[str, object]] = []
    headlines = {
        "thm:headline-rigidity-phase",
        "thm:headline-factorization",
        "thm:headline-gluing",
        "thm:four-sheet-holonomy",
        "thm:torsor-rosetta-close",
    }
    for statement in statements:
        label = str(statement["claim_key"])
        components = (
            sum((components_for_clause(label, index) for index in range(1, len(split_items(str(statement["tex"]))) + 1)), [])
            if label in headlines
            else generic_components(label)
        )
        claims.append(
            claim(
                f"statement-{label.replace(':', '-')}",
                theorem_source(statement),
                f"{statement['environment']} at source line {statement['source_line']}",
                "The route covers the exact extracted environment; numbered clauses are split below where present.",
                components,
            )
        )
        if label in headlines:
            for index, item in enumerate(split_items(str(statement["tex"])), 1):
                claims.append(
                    claim(
                        f"{label.replace(':', '-')}-clause-{index}",
                        verbatim_source(item),
                        f"{label}, clause {index}",
                        "This row routes one separately stated numbered subclaim.",
                        components_for_clause(label, index),
                    )
                )

    survival_rows = {
        "unmarked-child": (
            "unmarked conic child&none&no preferred matching, parent, or orientation",
            [lean_component("no invariant sheet choice", ["torsor"])],
        ),
        "balanced-moments": (
            "quotient moments $1,2$&unordered sheets&unique balanced complementary",
            [lean_component("balanced-sheet recovery", ["balanced"])],
        ),
        "signed-cubic": (
            "signed cubic&orientation&first survivor among signed tensor moments and",
            [lean_component("cubic-first orientation", ["moments", "balanced"])],
        ),
        "depth-row": (
            "singleton depth profile&decorated matching row&the six displayed",
            [lean_component("singleton matching-row recovery", ["depth"])],
        ),
        "design-shadow": (
            "quadratic-residue/Witt design&finite shadow&exact incidence, code,",
            [
                lean_component("literal design and Hadamard interfaces", ["witt"]),
                computation_component("independent finite design replay", "torsor", "The torsor bundle checks the QR, Witt, Hadamard, and outer-hinge tables."),
            ],
        ),
        "mod40": (
            "golden reduction&conditional split/fusion&the exact frozen residue classes",
            [
                lean_component("conditional mod-40 interface", ["survival"]),
                conceptual_component("frozen arithmetic hypotheses", TORSOR_INPUTS, "The row is expressly conditional and makes no all-prime claim."),
            ],
        ),
        "theta": (
            "finite theta signatures&erased&equal sheet signatures in the displayed",
            [
                lean_component("theta-signature erasure", ["passages"]),
                computation_component("theta table replay", "passages", "The bundle checks every displayed quadratic-value histogram."),
            ],
        ),
        "quantum": (
            "fixed-party quantum transport&erased&complete support transport and",
            [
                lean_component("fixed-party transport interface", ["passages"]),
                computation_component("finite transport replay", "passages", "The bundle checks the displayed monomial and fixed-party equivalences."),
            ],
        ),
        "fourier": (
            "ambient Fourier matrices&finite shadow&exact square, trace, and",
            [
                lean_component("scoped Fourier identities", ["passages"]),
                computation_component("Fourier matrix replay", "passages", "The bundle checks the exact square, trace, and restriction matrices."),
                conceptual_component("ambient Weil naming boundary", TORSOR_INPUTS, "No restricted-space Weil-module identity is asserted."),
            ],
        ),
    }
    manuscript = (ROOT / "clebsch_hexagon_code.tex").read_text(encoding="utf-8")
    for name, (snippet, components) in survival_rows.items():
        if manuscript.count(snippet) != 1:
            raise RuntimeError(f"survival snippet count is not one: {name}")
        claims.append(
            claim(
                f"survival-{name}",
                verbatim_source(snippet),
                "retention and loss table",
                "The row is bounded to its displayed finite or conditional scope.",
                components,
            )
        )

    census_snippet = (
        "Table~\\ref{tab:fifteen-classes} prints the complete census at the level\n"
        "used by the rigidity and low-degree arguments."
    )
    if manuscript.count(census_snippet) != 1:
        raise RuntimeError("fifteen-class census snippet count is not one")
    claims.append(
        claim(
            "fifteen-class-census-table",
            verbatim_source(census_snippet),
            "complete fifteen-class census table",
            "The two exact replays independently regenerate the shared canonical class keys; the table prints only fields checked by those replays.",
            [
                baseline_component(
                    "projective classes, stabilizers, uncovered counts, and nearest-conic discrepancies",
                    ["check_global_conic_gap.py"],
                    "All 1,548 frame-normalized six-arcs are canonically reduced to fifteen projective classes.",
                ),
                baseline_component(
                    "least vanishing degree for each canonical class",
                    ["check_low_degree_loci.py"],
                    "The replay evaluates homogeneous forms degree by degree on every uncovered locus attached to the same fifteen canonical keys.",
                ),
            ],
        )
    )

    manifest = {
        "schema": "clebsch-trust-manifest-v1",
        "lean_repository": {
            "url": "https://github.com/tavisrudd/finitegeom",
            "commit": PINNED_LEAN_COMMIT,
        },
        "reproducibility_environment": {
            "flake": file_evidence("paper", "flake.nix"),
            "lock": file_evidence("paper", "flake.lock"),
        },
        "manuscript_sha256": digest_bytes((ROOT / "clebsch_hexagon_code.tex").read_bytes()),
        "verify_all": {
            "command": "python3 verification/verify_release.py --lean-root /path/to/shared-lean",
            "entry_point": file_evidence("paper", "verification/verify_release.py"),
            "output": file_evidence("paper", "verification/verify-release-output.json"),
            "checks": checks(),
        },
        "claims": claims,
    }
    OUTPUT.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"wrote {OUTPUT}: {len(claims)} claim rows")


if __name__ == "__main__":
    main()
