# C168 preflight — Clebsch computation sources and assertion coverage

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: named-source inventory and checker hardening passed, including the later decoding,
low-degree, point-orbit, and small-arc additions. Every executable artifact cited by the current
manuscript is Git-indexed. C168 remains open for the final clean-source manifest/replay, citation
audit, and handoff pruning. C153/C161 have settled the last priority attribution.

## Inventory verdict

Every named executable artifact in the current manuscript resolves to a real file, and the exact
current version is now Git-indexed. The four new repair checkers were already fail-closed. The five
older demonstration-style scripts found by the preflight have now been hardened so every cited
numerical/algebraic verdict is asserted and successful execution ends with `all assertions passed`.

| Manuscript use | Source | Preflight state |
|---|---|---|
| q=11 rigidity census | `papers/clebsch-hexagon-code/check_rigidity_degenerate_conic.py` | indexed; exact histogram, six matches, rank, nonsingularity, and full conic equality asserted |
| code automorphisms | `.../check_code_automorphisms.py` | new source staged; exact assertions present |
| local 252-neighbor gap | `.../check_perturbation_gap.py` | new source staged; exact assertions present |
| chirality and code-level orbits | `.../check_chirality.py` | new source staged; exact assertions present after C172 |
| global conic-rigidity gap | `.../check_global_conic_gap.py` | new source staged; exact class census and sharp gap asserted |
| unconditional q≤14 theorem | `.../check_small_q_uniqueness.py` | new source staged; exact assertions present |
| conceptual q=9 Sylvester exclusion | `notes/2026-07-15-c181-sylvester-q9.py` | new source staged; from-scratch `F_9`, polarity graph, full intersection array, passant/distance-two equivalence, and exact clique bound asserted |
| q=19 foil | `.../check_q19_nonexample.py` | indexed; exact arc, `|U|=140`, intersection 20+120, and rank 6 asserted |

The previously named dual-code, Mathieu-hexad, and ten-arc scripts remain hardened and indexed, but
C167 removed their decorative manuscript paragraphs. They are no longer submission dependencies or
members of the final cited-computation manifest.

The companion Lean claims map to real, clean, tracked sources, principally:

- `lean/RelativeConicArcs/Q11Coding.lean`;
- `lean/RelativeConicArcs/Q11SemanticDistribution.lean`;
- `lean/RelativeConicArcs/Q11SemanticLeaders.lean`;
- `lean/RelativeConicArcs/Q11Residual.lean`;
- their tracked `Q11Semantic*`/`CodingBridge.lean` import closure.

C128 additionally supplies `lean/RelativeConicArcs/Q11KleinSyzygy.lean`, with exact integer forms,
canonical coefficient reductions, and a strict kernel proof. C167 then removed the non-load-bearing
Klein section, so this module is a documented provenance artifact rather than a manuscript premise.

The manuscript names `Q11Coding.lean` at the first certificate reference. The cited companion
Proposition 8.7 exists in the tracked
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`.

## Claims without a matching durable assertion

None among the current manuscript's executable computations. C128 certified the exact reduced
forms and syzygy; C167 removed the surrounding group/resolvent/diagonal claims rather than allowing
that narrower certificate to vouch for them.
The formerly uncovered concyclic-arc claim is now closed: the rigidity checker independently
asserts exactly 252 frame-normalized representatives with their six vertices on a unique
nonsingular conic and exact `|U|` histogram `{18:30,19:60,20:90,22:72}`. This is deliberately
distinct from C165's unrelated 252 local one-point replacements.

## Baseline eight-source checkpoint manifest

The first 2026-07-15 replay ran the eight computations cited before C184--C187. Every
command exited zero and reached `all assertions passed`; every path passed `git ls-files`, and each
working-tree file was byte-identical to its index entry after replay. These versions were
subsequently committed; this remains a reproducibility checkpoint rather than C168's clean-HEAD
exit gate.

Paper-package commands are run from `papers/clebsch-hexagon-code/` as `uv run python <source>`; the C181
row is run from the repository root by the command shown in its report.

| Source | Git blob | SHA-256 | Replay time | Key expected output |
|---|---|---|---:|---|
| `check_rigidity_degenerate_conic.py` | `f5e003ac6b46bf78877423d2c14d4e0fa7cc02b0` | `deaf503932b444d03a084c1954678fa993846696350524a198ccaa1e1d47c054` | 0.74 s | 1548 normalized representatives; 252 concyclic; six full nonsingular-conic loci; no degenerate containing conic |
| `check_code_automorphisms.py` | `d4cd6e9622ea50fc2121ece4a037c40e8ed60753` | `82b0c9fd1e64f7c9950cd951450c7c85b8f752c08645a33cdcd5520e8163a3fb` | 3.45 s | projective group 60; monomial group 600; scalar kernel 10; 120 conic syndromes transitive |
| `check_chirality.py` | `3bdfc04ba52260b89dd6f3dfe4f734421433130b` | `200cbd604c7e9aa942d1e3b54c372b97c69b8ebcb42220e710d1141131f9cca5` | 7.08 s | triangle-pair/Brianchon/support dictionary; exact `3^10 1^15` chord-intersection ledger; triple orbits 10+10; 2400 leaders split 1200+1200; 159720 received-word deep holes affine-transitive |
| `check_global_conic_gap.py` | `a2cb534f5d6e621eab89fae374dab348169517af` | `bb989b90c2dffe2d8bf71dce8c9b5aa879ddcf2d1abed724934dc24f4cbeea18` | 28.22 s | 15 projective classes; unique zero class; non-Clebsch gap 12 |
| `check_perturbation_gap.py` | `7ec44a0a570676d3b6c4c23e29b91ddcd1dff889` | `0af4aa625539a8d317079276eacbc9364d1d0f653ea7c2362a4e59e22b7b6756` | 1.83 s | 42 replacements per vertex; 252 distinct neighbours; eight A5-orbits; no neighbour locus on any conic |
| `check_small_q_uniqueness.py` | `e6ae20cd4ba49c40470f443b73d3756a35c870be` | `cbe028cec3795edb8e2985c4f5aba6fb268260e6ea5183122cb1d040abb2ec01` | 2.89 s | every prime power 2 through 13 checked; unique matching field 11; six normalized matches |
| `notes/2026-07-15-c181-sylvester-q9.py` | `cdc7f7f452b7beccabdff86514b854d01ffd6306` | `88a5e989aedc8adcefee21804b60264bc2c980102cca64adf6349eafdac1d9c5` | <0.1 s | 36 internal points; Sylvester array `{5,4,2;1,1,4}`; all 630 pair types; exact-distance-two clique number 5 |
| `check_q19_nonexample.py` | `be0941ebb8802e44883c7e712bc8cbda36010751` | `8a70fe91a64dab8b94d75188ab90d688a82515a016d48382fab3cecdd02d41e6` | 0.42 s | six-arc; `|U|=140`; `|U\cap C|=20`; quadratic rank 6/6 |

The baseline replay split the eight sources among three independent review agents. C173 and C176
then strengthened `check_chirality.py`; its current hash above was independently replayed by the
implementing agent and the root agent after the full Brianchon dictionary landed. In particular, the two distinct 252
assertions were re-executed independently in the same checkpoint: 252 concyclic frame-normalized
representatives in the rigidity census, and 252 distinct one-point neighbours in the local
perturbation graph.

## Current-manuscript inventory expansion

C184--C187 add five executable artifacts and four Lean roots. All nine paths are Git-indexed, and
the Python checkers were replayed from `papers/clebsch-hexagon-code/` with `uv`; each exited zero
and reached its fail-closed success marker. The Singular replay was separately run with Singular
4.4.1 and remains part of the final clean-source replay.

| Source | Git blob | SHA-256 | Current role |
|---|---|---|---|
| `check_decoding.py` | `d021423287d721f55755bca3769522c093439701` | `24f42397f4e2b7e32109d44fc2caeb6ec1991476c3bffc6143d61f8364305cb6` | total syndrome-distance oracle, ambiguity enumerator, Brianchon reconstruction, and equivariant decoder hierarchy |
| `check_low_degree_loci.py` | `b88fabb59d667586b25ebfdb9354a02c68bc4bcc` | `fab65df95dac888758f28fae19cf1d2ce47ee2a170b73fea5a6cba61ccae16fc` | complete degree-one-through-six evaluation ranks and exact minimal loci |
| `check_low_degree_loci_c12.sh` | `886bd7783e9381e20b6a55312fed6fa50f51929a` | `14d262c09120cfd25f1df564da486a21bb476c997fdfd17c69ef5c1c59c76b93` | fail-closed wrapper: rejects `ASSERTION FAILED` and requires the exact success marker |
| `check_low_degree_loci_c12.sing` | `ebc85ff42f19ace9d280b151e35c090abf0aa444` | `0c18185146225a6965099e9a2bfb29e8920c8254f48c4a2f17798e870eda6081` | factorization and Jacobian replay for the quartic, quintic, and displayed sextic; invoked through the wrapper |
| `check_small_k_conic_filling.py` | `4d2d3ac62998ea09b6ecaa9c49d5c5eb94c9fef5` | `2aa2187ce53867ea3e3f823463e71c42f9537594f4603a7091edbf063bf1b67c` | q=5 equality and exhaustive q=11,13 seven-arc exclusions |

Replay the three Python rows with `uv run python <source>` from the paper directory. The decoding
and low-degree rows require `all assertions passed`; the small-`k` row requires
`SMALL_K_CONIC_FILLING_PASS`. Replay the algebraic-geometry row with
`nix shell nixpkgs#singular -c ./check_low_degree_loci_c12.sh`; the wrapper fails on any printed
assertion failure and requires `all assertions passed`.

The corresponding Lean roots are `lean/RelativeConicArcs/Q11Coding.lean` (blob `a6819d43...`),
`Q11A5PointOrbits.lean` (`26453f7b...`),
`Q11DecodingSynthesis.lean` (`049c1895...`), `SmallKChordMoments.lean` (`a41192d3...`), and
`SmallKGeometricBridge.lean` (`55aea47b...`). Their reports record the completed narrow builds and
axiom boundaries; the final C168 pass must replay exact trace/build gates from a clean source state
rather than infer them from existing oleans.

After the C184--C187 integration and abstract repair, the repository-level `papers/Makefile`
rebuilt the checked-in manuscript with XeLaTeX to a warning-free 21-page, 176,119-byte PDF. C168 still
requires a fresh clean-HEAD replay and PDF/citation audit with the final C153/C161 priority wording;
this checkpoint is not a substitute for that exit gate.

## C168 actions

- **Done:** hardened the five print-only scripts; each cited verdict is asserted and the final line
  is `all assertions passed`.
- **Done:** extended the rigidity checker with the concyclic-arc 252 count and full histogram.
- **Done:** staged the exact current versions of every modified legacy checker, including the q=9
  semantic correction retained in the paper package.
- **Done:** pinned `lean/RelativeConicArcs/Q11Coding.lean` in the manuscript.
- **Done:** removed the non-load-bearing Valentiner orbit-size sentence rather than preserving an
  uncited memory claim.
- **Done:** closed C128 with a tracked strict-kernel certificate and removed the unsupported Klein
  remainder under C167.
- **Done:** pruned the dual, Mathieu, ten-arc, higher-redundancy, and Schreier asides, shrinking the
  final executable manifest to the computations that support the rigidity spine.
- At closeout, record for every cited computation: tracked path, blob/SHA-256, exact command, and
  expected output, then replay the manifest from a clean index-visible source set.

This preflight does not report C168 complete. It establishes the user's “all cited computation
scripts must be in Git” requirement for the current executable sources. The final manifest/replay,
PDF/citation audit, and handoff cleanup remain the explicit exit conditions.
