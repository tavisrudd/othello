# C306: dihedral paper structural LaTeX rebuild

**Lane:** `dihedral` — C264 phase 1/6

**Date:** 2026-07-18

**Status:** CLOSED. C307 (correctness integration) is next.

## What this phase delivered

The markdown submission `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md` is now a
building LaTeX manuscript on Fable's adopted eight-section spine:

- `papers/dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.tex` — the canonical source;
- `papers/dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.pdf` — the built artifact;
- `papers/Makefile` — `dihedral` target and `SOURCES` entry, so the paper joins the shared
  `all`/`check`/`warnings`/`clean` targets;
- `papers/dihedral-schreier-node-kayles/README.md` — status and file map updated.

This phase is a structural migration only. No mathematical statement was strengthened, weakened, or
newly derived, and no prose from a later report (C281, C284, C288, C289, C290, C278, C283, C261) was
integrated. Those integrations are C307/C308 work and are marked in the source by `\phasenote`
boxes.

### Filename deviation from the runbook

The runbook names the deliverable `main.tex`. The file is instead
`dihedral_schreier_node_kayles.tex`, matching the existing `papers/` convention
(`arcs_complete_outside_conic.tex`, `clebsch_hexagon_code.tex`,
`complete_repair_hypergraphs.tex`, `frobenius_pair_extension.tex`) and the shared Makefile's
explicit-source list, where four files named `main.tex` would be indistinguishable. Nothing else in
the runbook depends on the name.

## Build and validation

```
cd papers && make -B dihedral
```

Toolchain: `nix shell nixpkgs#texlive.combined.scheme-full -c latexmk -xelatex
-interaction=nonstopmode -halt-on-error` (as pinned by `papers/Makefile`).

Result: clean build. The shared `warnings` gate pattern
(`Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined`)
matches nothing in `dihedral_schreier_node_kayles.log`, so adding the paper to `SOURCES` does not
regress `make check` for the other papers. All internal `\ref`/`\eqref` resolve; all `\cite` keys
resolve.

Artifact identity at close:

| file | bytes | SHA-256 |
|---|---:|---|
| `papers/dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.tex` | 63132 | `4bbc09ab0fd6af91e93c061396e73cf1bd49e33c66c0e25358e77cff5e1db45e` |
| `papers/dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.pdf` | 177926 | `81fd9f6394b7166c86d5018759c23a5a1ecb423c175c38947e83fa0b07a72316` |

The PDF hash is not reproducible across toolchain versions; the `.tex` hash is the stable identity
for this phase. C309 owns the reproducible-build statement.

## Non-loss ledger: every source item has a destination

Old numbering is the markdown manuscript's; new numbering is the LaTeX source's labels.

| Source material | Destination | Note |
|---|---|---|
| Abstract | new abstract | Rewritten around one reduction and three applications. |
| §1 introduction, tame hypothesis, `D_{2m}` notation, conic-only value convention | §1 | Conventions kept verbatim in substance; roadmap added. |
| §2 coordinates, (2.1), Lemma 2.1, Theorem 2.2, static-graph paragraph | §2 | `eq:involution`, `lem:dead`, `thm:residual`. |
| §3 (3.1)–(3.3), Theorem 3.1 | §3 | `eq:DT`, `eq:RT`, `eq:template`, `thm:orbit-template`. |
| §11 Φ_T, Proposition 11.1, Corollary 11.2, scope caveat | §3.1 | `prop:burnside`, `cor:bulk`, `rem:burnside-scope` — corollary + remark, per Fable answer (3). |
| §4 reflection-centre collinearity paragraph | §4.1 | Promoted to `lem:collinear`; the pair taxonomy needs it. |
| §4.3 taxonomy table | §4.1 | `tab:legal`. |
| §4 Theorem 4.1 (Klein-four) | §5.1 | `thm:v4`, with the `n=1` degeneracy remark. |
| §4 `T_d` derivation, (4.4), Proposition 4.2, automorphism classes | §5.2 | `eq:Td`, `prop:Td-generates`. |
| §5 Theorems 5.1, 5.2, 5.3 | §5.3 | `thm:free-template`, `thm:mobius-value`, `thm:prism-value`. |
| §6 Propositions 6.1, 6.2 | §5.4 | `prop:stabilizers`, `prop:rotation-empty`. |
| §7 (7.1), (7.2), Lemma 7.1, Theorem 7.2, (7.5), (7.6) | §5.5 | Double-cover-of-a-tree lemma and ladder recognition preserved intact, per Fable change 2. |
| §8 (8.1), Theorem 8.1, (8.4), template table | §5.6 | `thm:triple-orbit`, `eq:orbit-equation`, `tab:templates`. |
| §14 setup and §14.1 stabilizers | §4.1–§4.2 | Two-point family now precedes the triple family. |
| §14 Theorem 14.1 | §4.2 | `thm:pair-templates`. |
| §14.2 (14.3), (14.4), Lemma 14.2 | §4.3 | `eq:dawson`, `eq:cycle-mex`, `lem:cycle-zero`. |
| §14 Theorem 14.3 | §4.3 | `thm:pair-orbit`. |
| §14 Dawson-zero paragraph | §4.3 | Kept as the closing paragraph of the section. |
| §9.1, §9.2 closed formulas; Corollary 9.1; (9.8); periodicity | §7.1 | Migrated verbatim; see the blocking hazard below. |
| §14.3 Theorem 14.4 | §7.2 | `thm:pair-closed` — moved to the arithmetic section with the triple-family formulas. |
| §14 Corollary 14.5 | §7.2 + §7.3 | Split into `cor:pair-P` (criterion) and `cor:pair-density` (density). |
| §12 periodicity paragraph and Theorem 12.1 | §7.3 | `eq:general-orbit-equation`, `thm:density` — kept as a named headline theorem, per Fable change 1. |
| §10 `D_{12}` worked example | §7.4 | `ex:d12`; the contrasting `A_5` example is owed by C307. |
| §13 Theorem 13.1 | §8.1 | `thm:realization-triple`. |
| §14 Theorem 14.6 | §8.1 | `thm:realization-pair`. |
| §14 exhaustive-simulation verification paragraph | Appendix A | Moved out of the narrative; filenames owed to C308/C309 (below). |
| §15 wild case `p` divides `2m` | §8.2 | Presented as the boundary marker, per Fable change 3. |
| §15 `A_4` impossibility | §6 opening | Now introduces the polyhedral section. |
| §15 growing full/subfield caveat | §8.3 item (3) | Boundary taxonomy. |
| §15 discussion summary | §8.4 | Rewritten last by C311. |
| Appendix A polyhedral table, computation notes, `A_5` commuting-pair remark, free-orbit caveat | §6 + Appendix B | `tab:polyhedral-regular`, `rem:a5-commuting`, `app:regular-computation`. |
| References | `thebibliography` | Keyed entries; see the uncited-reference item below. |

New material introduced by this phase, both required by the runbook migration table:

- `cor:period34` — the Dawson period-34 corollary, stated for the pair family and proved directly
  from `eq:pair-orbit` and the eventual periodicity of A002187;
- `thm:main` — a main-theorem statement in §1, at exactly the strength the migrated source proves,
  with its polyhedral extension explicitly deferred to C307.

Nothing was deleted. Two things were deliberately relocated rather than reproduced verbatim:

1. **Artifact filenames inside prose.** `scripts/dihedral_pair_templates.rs`,
   `scripts/nodekayles_cayley.rs`, and `notes/2026-07-12-polyhedral-nk-templates.md` were cited
   mid-narrative in the markdown. The style guide forbids checker filenames inside proofs, so the
   claims they support survive in Appendix A and Appendix B without the filenames. **C308/C309 owe
   the evidence map that restores them beside the exact claims they certify.**
2. **The polyhedral section is a stub with a body table.** §6 currently carries only the free-orbit
   regular-template table the source manuscript had. Its `\phasenote` states the completeness-first
   structure C307 must build from C284/C288/C289.

## Blocking item carried into C307

The §7.1 closed formulas and P-position congruences are migrated **verbatim and are known to be
incomplete**. C281 found a second `D_{4n}` conjugacy class with all-nonsplit reflections (`t=0`) for
even `h`, first at `q=7` (`D_8` acting freely, board `M_8`, value 1 against the boxed 0), and for odd
`d` exactly one of the two classes is an N-position. `cor:pn-congruences` and
`eq:split-odd`–`eq:nonsplit-even` therefore require C281's `t`-case split. This is correctness
hazard 1 of the runbook, it is a value-affecting fix rather than an appendix note, and it is marked
in the source at the point of use. The pair-family value formula is unaffected.

`thm:density` is derived from the uncorrected congruences and must be re-derived by C307 against the
corrected table, keeping the C278 single-axiom boundary sentence attached.

## Scholarly-apparatus defect found during migration

Three references carried by the markdown manuscript — Beauville (finite subgroups of `PGL_2(K)`),
Dickson, and Kobayashi — are never cited in the body text. They are retained as keyed bibliography
entries so nothing is lost, but LaTeX does not warn about uncited `\bibitem`s, so this will not
surface again on its own. **C308 owes a decision for each: cite at the point of use or drop.**
Beauville and Dickson are the natural citations for the subgroup classification underlying §6's
"the remaining polyhedral possibilities are `S_4` and `A_5`", which is currently asserted without a
reference.

## Phase-note mechanism

The source defines `\phasenote{owner}{text}`, which renders a boxed note when `\draftnotestrue` is
set. Notes are placed at the point of the owed edit and name their owning phase. **C309 must set
`\draftnotesfalse` and confirm no note survives into the release build**; a phase note left visible
in a submitted PDF is a release defect.

## What this phase does not claim

- No mathematical claim of the source manuscript was verified, corrected, or extended here.
- The §7.1 formulas are, as noted, known-incomplete pending C307.
- No Lean target was built or audited; no computational artifact was regenerated or replayed.
- The title is Fable's direction 1 as a working title; final wording remains a user call.
- Typography, float placement, reference stability, and the reproducible build are C309's gate, not
  this phase's.

## Next

**C307** — correctness-first integration. Apply the C281 `t`-case split before any polishing, then
integrate C284, C289, C290, C278, C283, and the C288/C281 validation appendices, producing the claim
ledger that traces every imported statement to its report.
