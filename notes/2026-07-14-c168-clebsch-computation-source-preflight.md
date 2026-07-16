# C168 preflight — Clebsch computation sources and assertion coverage

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED — CLEAN-SOURCE CLOSEOUT PASSED.** At clean source commit
`857c09c5906869c8bea814ec78ae73f37539a08f`, every cited executable artifact and Lean root was
Git-indexed and byte-identical to its recorded blob. All twelve executable commands reached their
fail-closed success markers, all five Lean roots passed guarded elaboration and their exported axiom
audits, and the final 21-page PDF passed warning, citation-key, and internal-reference audits.

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

Naming note (2026-07-16): after this dated manifest was recorded,
`check_low_degree_loci_c12.sh` and `check_low_degree_loci_c12.sing` were renamed
to `check_low_degree_loci.sh` and `check_low_degree_loci.sing` because both cover
C02, C04, and C12. The historical paths and hashes below are retained as the
exact record of the clean-source replay; C182 will record fresh hashes for the
renamed archive artifacts.

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
axiom boundaries; at that checkpoint the final C168 clean-source trace/build replay was still
outstanding.

After the C184--C187 integration and abstract repair, the repository-level `papers/Makefile`
rebuilt the checked-in manuscript with XeLaTeX to a warning-free 21-page, 176,119-byte PDF. That
checkpoint preceded, and did not substitute for, the final replay below.

## Final clean-source closeout

The final replay used source commit `857c09c5906869c8bea814ec78ae73f37539a08f`. Before execution,
`git diff --quiet`, `git diff --cached --quiet`, `git ls-files --error-unmatch`, and a working-file
SHA-256 comparison established that every manifest source below was index-visible and identical to
the recorded Git object. Commands beginning `uv run` were executed from
`papers/clebsch-hexagon-code/`; the C181 command was executed from the repository root.

| Source | Git blob | SHA-256 | Exact command | Required output |
|---|---|---|---|---|
| `check_rigidity_degenerate_conic.py` | `f5e003ac6b46bf78877423d2c14d4e0fa7cc02b0` | `deaf503932b444d03a084c1954678fa993846696350524a198ccaa1e1d47c054` | `uv run python check_rigidity_degenerate_conic.py` | `all assertions passed`; 1548 representatives, 252 concyclic, six full nonsingular-conic loci |
| `check_code_automorphisms.py` | `d4cd6e9622ea50fc2121ece4a037c40e8ed60753` | `82b0c9fd1e64f7c9950cd951450c7c85b8f752c08645a33cdcd5520e8163a3fb` | `uv run python check_code_automorphisms.py` | `all assertions passed`; projective/monomial/scalar orders `60/600/10` |
| `check_chirality.py` | `3bdfc04ba52260b89dd6f3dfe4f734421433130b` | `200cbd604c7e9aa942d1e3b54c372b97c69b8ebcb42220e710d1141131f9cca5` | `uv run python check_chirality.py` | `all assertions passed`; exact Brianchon dictionary, `10+10`, `1200+1200`, affine transitivity |
| `check_global_conic_gap.py` | `a2cb534f5d6e621eab89fae374dab348169517af` | `bb989b90c2dffe2d8bf71dce8c9b5aa879ddcf2d1abed724934dc24f4cbeea18` | `uv run python check_global_conic_gap.py` | `all assertions passed`; 15 classes, unique zero class, gap 12 |
| `check_perturbation_gap.py` | `7ec44a0a570676d3b6c4c23e29b91ddcd1dff889` | `0af4aa625539a8d317079276eacbc9364d1d0f653ea7c2362a4e59e22b7b6756` | `uv run python check_perturbation_gap.py` | `all assertions passed`; 252 neighbors in eight `A5`-orbits, none on a conic |
| `check_small_q_uniqueness.py` | `e6ae20cd4ba49c40470f443b73d3756a35c870be` | `cbe028cec3795edb8e2985c4f5aba6fb268260e6ea5183122cb1d040abb2ec01` | `uv run python check_small_q_uniqueness.py` | `all assertions passed`; prime powers 2 through 13, unique field 11 |
| `notes/2026-07-15-c181-sylvester-q9.py` | `cdc7f7f452b7beccabdff86514b854d01ffd6306` | `88a5e989aedc8adcefee21804b60264bc2c980102cca64adf6349eafdac1d9c5` | `uv run python notes/2026-07-15-c181-sylvester-q9.py` | `C181_SYLVESTER_Q9_PASS`; intersection array and clique number 5 |
| `check_q19_nonexample.py` | `be0941ebb8802e44883c7e712bc8cbda36010751` | `8a70fe91a64dab8b94d75188ab90d688a82515a016d48382fab3cecdd02d41e6` | `uv run python check_q19_nonexample.py` | `all assertions passed`; `|U|=140`, conic intersection 20, rank 6 |
| `check_decoding.py` | `d021423287d721f55755bca3769522c093439701` | `24f42397f4e2b7e32109d44fc2caeb6ec1991476c3bffc6143d61f8364305cb6` | `uv run python check_decoding.py` | `all assertions passed`; total oracle, ambiguity distribution, equivariant decoder hierarchy |
| `check_low_degree_loci.py` | `b88fabb59d667586b25ebfdb9354a02c68bc4bcc` | `fab65df95dac888758f28fae19cf1d2ce47ee2a170b73fea5a6cba61ccae16fc` | `uv run python check_low_degree_loci.py` | `all assertions passed`; exact minimal loci `C02:4,C04:5,C12:6,C15:2` |
| `check_low_degree_loci_c12.sh` | `886bd7783e9381e20b6a55312fed6fa50f51929a` | `14d262c09120cfd25f1df564da486a21bb476c997fdfd17c69ef5c1c59c76b93` | `nix shell nixpkgs#singular -c ./check_low_degree_loci_c12.sh` | `all assertions passed`; quartic/quintic/sextic geometry |
| `check_low_degree_loci_c12.sing` | `ebc85ff42f19ace9d280b151e35c090abf0aa444` | `0c18185146225a6965099e9a2bfb29e8920c8254f48c4a2f17798e870eda6081` | invoked by the preceding fail-closed wrapper | exact Singular assertions consumed by the wrapper |
| `check_small_k_conic_filling.py` | `4d2d3ac62998ea09b6ecaa9c49d5c5eb94c9fef5` | `2aa2187ce53867ea3e3f823463e71c42f9537594f4603a7091edbf063bf1b67c` | `uv run python check_small_k_conic_filling.py` | `SMALL_K_CONIC_FILLING_PASS`; q=5 equality and q=11,13 exclusions |

The five manuscript-facing Lean roots were then re-elaborated directly with the guarded wrapper,
not inferred from existing `.olean` files. Each command had zero stderr and exit zero; every
included `#print axioms` audit reported only `propext`, `Classical.choice`, and `Quot.sound`.

| Root | Git blob | SHA-256 | Exact command | Time |
|---|---|---|---|---:|
| `RelativeConicArcs/Q11Coding.lean` | `a6819d43b4948f581e43dd556139c617c0339728` | `792abde700da2fc389a9b36a85d451e2257eeb3d87244a8de2d71e99d3118054` | `scripts/guarded-lean RelativeConicArcs/Q11Coding.lean` | 1m45s |
| `RelativeConicArcs/Q11A5PointOrbits.lean` | `26453f7b2680e3733ca66a322609a018488dbc8d` | `d1bf97cf47c9c0b23f0fe73f049e3f7e42e50137b6d28e59f3954cbe779dfa0b` | `scripts/guarded-lean RelativeConicArcs/Q11A5PointOrbits.lean` | 9s |
| `RelativeConicArcs/Q11DecodingSynthesis.lean` | `049c18955eeece0c2c675b767cee10d1d817d8eb` | `d33071bdd173a2be8243167bc5350548615e0c83de6d4afc4833107394bf077d` | `scripts/guarded-lean RelativeConicArcs/Q11DecodingSynthesis.lean` | 14m16s |
| `RelativeConicArcs/SmallKChordMoments.lean` | `a41192d396bb263536c564e52a4109d1e099b05d` | `92fb60e20790401d1730b165b4fcf043cf78e42a2aae71e45663de1d9c1f0af5` | `scripts/guarded-lean RelativeConicArcs/SmallKChordMoments.lean` | 8s |
| `RelativeConicArcs/SmallKGeometricBridge.lean` | `55aea47b53d2e7ad22a2b9a6d00b53292e797c95` | `d78cb940373f546825d68b001f8d1f0e780eae99b36f1459fda80aeedad55e53` | `scripts/guarded-lean RelativeConicArcs/SmallKGeometricBridge.lean` | 6s |

Finally, `papers/Makefile` was made Nix-self-contained and
`make -B clebsch LATEXMK_FLAGS='-g -xelatex -interaction=nonstopmode -halt-on-error'` forced a fresh
XeLaTeX/BibTeX render. The result is 21 pages. The exact log contains no overfull/underfull boxes,
LaTeX or package warnings, undefined citations/references, or multiply defined labels. Independent
source-level audits found every `\cite` key in a `\bibitem` and every `\ref`/`\eqref` target in a
`\label`.

The final trust-ledger pass found eighteen theorem-like environments and eighteen proof
environments, including three proofs explicitly labeled computer-assisted/exhaustive; no proof
sketch, TODO, FIXME, unchecked, or unverified marker remains. Every executable/formal artifact path
named by the manuscript resolves to one of the tracked sources above. The companion arcs source has
six preceding theorem-like environments in Section 8 before `prop:q11-code`, so the manuscript's
cross-reference to Proposition 8.7 is consistent with the source numbering and statement.

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
- **Done:** recorded and replayed every cited computation and formal root from the clean,
  index-visible source set above; rebuilt and audited the final PDF.

C168 is complete. C182 remains the external immutable-archive/DOI gate; no DOI or archival claim is
made by this local closeout.
