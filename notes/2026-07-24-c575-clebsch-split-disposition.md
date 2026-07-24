# C575 — exact Clebsch split disposition

**Date:** 2026-07-24

**Lane:** `clebsch`

**Status:** complete; C576 subsequently built and referee-tested Paper I.
The active next task is C320; this file remains the exact disposition record.

## Verdict

**GO for C576.**  The focused manuscript at `7d258dcd` is the exact 17-page
base.  Its question, proof order, abstract, and conclusion already form a
complete Paper I.  The current 37-page manuscript at `5a82e80d` remains an
unchanged fallback and a source of narrowly listed backports.

Paper I has no mathematical dependency on the factorization-memory or
passage/holonomy theorem complexes.  Its only permitted `H_3` residue is a
non-load-bearing contextual paragraph; Paper II owns the arrangement theorem
and proof.  The split therefore introduces no circular reference and no
duplicated headline claim.

C577 and C579 remain gated behind Paper I submission readiness.  This report
maps their material only to prevent accidental import into C576.

## Pinned source snapshots

| role | commit | TeX blob | TeX SHA-256 | fresh render |
|---|---|---|---|---|
| focused base | `7d258dcd6cda9f54c330d4b705d553a975749014` | `d90190af263fbcbbbd34c33d10840b5f4f4f5589` | `7e017703d26e2e3b5cbf23ea3e81d93971970a6bae025fb371f87a05135c4b4c` | pass, 17 pages |
| broad fallback | `5a82e80d72e5c7400afb07ea4f33d929fbc11259` | `a57c3cb9eb71079c6b9ac1b59dd25572aedb2fa3` | `5cfe7362b4cdbc4b4ffee6e8b3ab2e683c3fc40e78d8c6815e96e7a2a6408ad2` | pass, 37 pages |

Both renders were made from `git archive` exports with:

```text
nix shell nixpkgs#texlive.combined.scheme-full -c \
  latexmk -xelatex -interaction=nonstopmode -halt-on-error \
  clebsch_hexagon_code.tex
```

The fresh PDF SHA-256 values were
`547d659dff118e7744ae9d690109a45603e1577b0d8130806033abda7cd0da52`
and
`7baad3584ee908aa98a3c38b548e5c83efd7ea496b11234de32d1c769a0a5cd1`,
respectively.  They differ from the tracked PDF hashes because the PDF build is
not byte-reproducible across render environments; the commit, TeX blob, and
TeX SHA-256 are the source-identity pins.

The fallback evidence pins are:

- statement identity:
  `f2be08486f4233ead54e744b7d51d5fcf2e52088df2ef784f8fe84e56404f4ee`,
  29 environments;
- trust manifest:
  `f7520505f6703a349a0ed54c6ba298112ccba0a3a4d984f83f4dc365ee2d8324`,
  58 rows;
- deterministic release output:
  `bc8b58f30bb63ecae39ad42f898899fa39047f95180ab2ff419073c95da5db90`;
- shared Lean commit:
  `43c403b23e7cb6b9d66dda01bb43a91bec9ea465`.

## Section disposition

| fallback block | destination | disposition |
|---|---|---|
| Abstract and Section 1, Introduction | split | Paper I retains the 17-page abstract and opening hierarchy. Papers II and III write independent openings. Do not copy the compound headline theorem. |
| Section 2, guided tour of forgetting and memory | Paper II | Rebuild as Paper II's proof strategy. The recovery-arc figure is excluded from Paper I. |
| Section 3, Clebsch hexagon | Paper I | Use the focused base. Paper II may restate only the marked-conic notation needed to define its products. |
| Section 4, code and syndrome locus | Paper I | Use the focused base and backport the explicit parity-check matrix and complete census. |
| Section 5, rigidity theorem | Paper I | Adopt the current sharpened statements and proofs inside the older narrative order. |
| Section 6, invariant support bipartition | Paper I | Adopt, replacing every surviving use of “chirality” by “support bipartition” except in historical filenames. |
| Section 7 through the Clebsch-family formula and small-arc theorem | Paper I | Adopt the `q=11` uniqueness and `4<=k<=7` classification. |
| Section 7 `H_3` arrangement, lattice-good reduction, and uniform Coxeter code | Paper II | Paper I may keep one contextual paragraph, with no theorem, proof, checker row, or dependency. |
| Section 8, factorization memory | Paper II | Adopt. |
| Section 9, balanced sheets and cubic orientation | Paper II | Adopt. |
| Section 10, six profiles and matching-row reconstruction | Paper II | Adopt. |
| Section 11, rank-three arithmetic gluing | Paper II | Adopt. |
| Section 12, finite passages | Paper III | Adopt only if C579 finds one principal theorem. |
| Section 13, verification architecture | split | Generate a separate claim/evidence map and release entry point for each adopted paper. |
| Appendix A, relative-cubic Tate plane | Paper II | Adopt as an appendix. |
| Appendix B, statement identity | split | Regenerate separately; do not share the compound 29-statement extraction. |
| Conclusion | split | Paper I restores the focused conclusion. Papers II and III receive independent mathematical conclusions. |

## Statement and proof disposition

The focused base has 17 theorem-like environments and 17 proofs.  All remain
in Paper I, subject to the terminology and statement-strength repairs below.
The fallback has 29 theorem-like environments and 25 explicit proof
environments.  A proof follows the destination of its statement; the four
summary environments without local proofs are split into locatable theorem
blocks rather than copied as unsupported headlines.

| fallback statement | destination | action |
|---|---|---|
| `thm:headline-rigidity-phase` | split | Retire the compound environment. Its rigidity clause becomes Paper I's headline; its three Coxeter clauses become Paper II's conic-phase and gluing results. |
| `thm:headline-factorization` | Paper II | Split its four clauses across the quotient, balanced-sheet, cubic, and profile sections. |
| `prop:a5-point-orbits` through `prop:clebsch-family-uncovered` | Paper I | Adopt all statements and proofs, including the formerly unlabelled monomial corollary after giving it a stable label. |
| `prop:h3-arrangement` | Paper II | Paper II owns the theorem and proof. Paper I may retain only a contextual sentence. |
| `prop:lattice-good` | Paper II | Adopt. |
| `thm:small-k-conic-filling` | Paper I | Adopt. |
| `prop:general-matching-quotient` | Paper II | Adopt as the reusable construction before the three finite rank calculations. |
| `prop:modular-depth-plane` | Paper II | Adopt. |
| `thm:headline-gluing` and `lem:rank-three-splitting` | Paper II | Adopt and keep the three gluing clauses separately assessable. |
| `prop:mod40-reciprocity` through `thm:torsor-rosetta-close` | Paper III | Adopt only after C579 passes the standalone-value gate. |

The exact 58-row C320 disposition is
`notes/2026-07-24-c575-clebsch-trust-disposition.csv`.  Its partition is:

| destination | rows | count |
|---|---|---:|
| Paper I | 2, 11--26, 29, 58 | 19 |
| Paper II | 3--10, 27--28, 30--36, 50--52 | 20 |
| Paper III candidate | 37--49, 53--57 | 18 |
| retired compound row | 1 | 1 |

Thus every current trust row occurs exactly once.  The retired row contains no
discarded mathematics: its four clauses are rows 2--5 and are assigned
separately.

## Paper I backports

C576 starts from the complete TeX at `7d258dcd`, not from a copy of the
fallback with sections deleted.  Apply these backports in order:

1. Change the title to *Deep-hole rigidity of the Clebsch hexagon code* and
   retain the focused abstract and conclusion hierarchy.
2. Insert the explicit parity-check matrix from the fallback code section.
3. Insert the complete fifteen-class census table and its definitions before
   the quantitative-gap proof.
4. State the qualitative rigidity theorem separately from the numerical
   refinements.  Inside the gap theorem, separate `|U(A)|<=15` for
   non-Clebsch arcs from the equality `|U(A)|=12` for the Clebsch class.
5. Import the current proof-mode language locally for the principal results:
   human proof, named cited input, exact exhaustive replay, Lean-checked
   algebra, or an explicit mixture.
6. Replace “chirality” in prose, headings, labels, and theorem titles by
   “invariant support bipartition.”  Historical checker filenames may remain.
7. Filter the current trust and verification tables to the 19 Paper I rows.
   Do not mention the factorization, passage, torsor, or common-Rosetta gates.
8. State that exhaustive enumeration is load-bearing only for the numerical
   gap and low-degree strengthening.  Other finite checks audit coordinates,
   counts, or consequences.
9. Default to omitting an `H_3` theorem.  At most one short contextual
   paragraph may identify the Clebsch secants with the reduced `H_3`
   arrangement and print the compact complement formula; it must not be used
   by any Paper I proof.
10. Preserve the synthematic--Petersen figure and the older ending on decoder
    reconstruction, the isolation of `q=11`, and the open range `k>=8`.

The expected page budget is 19--21 pages:

| component | pages |
|---|---:|
| focused base | 17 |
| explicit matrix and complete census | 1.0--1.5 |
| proof-mode and Paper I trust tables | 1.0--1.5 |
| optional `H_3` context | 0--0.5 |

If the result exceeds 21 pages, remove the optional `H_3` paragraph first and
compress verification prose second.  Do not cut a proof step or the complete
census to meet the budget.

## Figures and tables

| item | destination |
|---|---|
| guided-tour matching-recovery arc | Paper II |
| synthematic--Petersen dictionary | Paper I |
| complete fifteen-class census | Paper I |
| carrier/action/bridge ledger | Paper III |
| factorization-memory verification map | Paper II |
| principal-result dependency table | regenerate separately for each paper |
| executable-check table | regenerate separately for each paper |
| small-field census | Paper I |
| headline trust-boundary summary | regenerate separately for each paper |

The focused base's three tables are dependency, executable-check, and
small-field tables.  C576 replaces the first two with Paper I-filtered current
versions and retains the small-field table.

## Checker and evidence ownership

Paper I owns these current exact checkers:

- `check_rigidity_degenerate_conic.py`;
- `check_code_automorphisms.py`;
- `check_decoding.py`;
- `check_chirality.py`;
- `check_global_conic_gap.py`;
- `check_perturbation_gap.py`;
- `check_small_q_uniqueness.py`;
- `check_q19_nonexample.py`;
- `check_low_degree_loci.py`;
- `check_small_k_conic_filling.py`.

Paper II owns `check_reflection_arrangements.py` and the factorization,
balanced-sheet, depth, and arithmetic-gluing Lean slices.  Paper III owns the
workflow-free `four_sheet_holonomy`, `passage_interfaces`, and
`torsor_dictionary` evidence bundles and their Lean interfaces.

The following legacy scripts are not Paper I release dependencies:
`check_dual_code.py`, `check_ten_arc_foil.py`, `check_mathieu_hexads.py`,
`check_q9_exclusion.py`, and the Singular wrapper/source.  In particular, the
smooth-quartic sentence remains absent, so C321 is not triggered by this
disposition.

The current `verification/` framework and aggregate
`RelativeConicArcs.Gates.ClebschPaperTrust` gate remain attached to the broad
fallback.  C320 must generate a Paper I manifest, statement extraction,
Paper I aggregate gate, and release runner from the nineteen assigned rows.
It must not weaken the fallback manifest or claim that a filtered row inherits
trust from an unexamined aggregate import.

## Citation ownership

Paper I retains the complete 17-page bibliography:
`BSW1992`, `BicharaKorchmaros1982`, `Clebsch1871`, `Edge1956`,
`DrakeKeating2004`, `ArcsCompleteOutsideConic`, `ChengMurray2007`, `DMP2021`,
`BallLavrauw2019`, `AbiadJabalAmeliReijnders2025`,
`BrouwerCohenNeumaier1989`, `JurisicVidali2019`, `Dye1991`,
`GuruswamiVardy2005`, `Hirschfeld1998`, `NgWild2001`, `SadehThesis1984`,
`StormeThas1991`, `SVM1995`, and `ZWK2020`.

The eleven later bibliography additions are assigned as follows:

| key | owner |
|---|---|
| `Athanasiadis1996`, `Calvo2024`, `Taylor1992` | Paper II |
| `JurriusPellikaan2015` | Paper II; Paper I may retain it only if the optional compact complement formula is printed |
| `Atlas1985`, `Giudici2007` | shared citation; used independently by Paper II gluing and Paper III passages |
| `ConwaySloane1999`, `MumfordThetaII`, `NebeRainsSloane2006`, `Weil1964`, `Witt1938` | Paper III |

`Giudici2007` may also remain in Paper I if required by the exact `q=11`
subgroup statement.  Sharing a citation does not share a theorem or proof.
The Drake--Keating DOI formatting repair is backported.

## Source and build layout

- `papers/clebsch-hexagon-code/` remains frozen as the broad fallback.
- `papers/clebsch-rigidity/clebsch_rigidity.tex` becomes the C576 manuscript;
  its release-local checkers and verification manifest live under that root.
- `papers/clebsch-factorization/clebsch_factorization.tex` remains a spine
  until C577 starts.
- `papers/clebsch-passages/clebsch_passages.tex` remains an exploratory spine
  until C579 starts.
- `papers/Makefile` keeps separate `clebsch`, `clebsch-rigidity`,
  `clebsch-factorization`, and `clebsch-passages` targets.

Target budgets are 19--21 pages for Paper I, 15--20 pages for Paper II, and
12--18 pages for Paper III if its standalone-value gate passes.  These are
editorial controls, not reasons to compress mathematical bottlenecks.

## No-circularity and no-duplication gate

- Paper I proves its code, rigidity, decoder, reconstruction, and small-arc
  results without invoking a Paper II or Paper III statement.
- Paper II may reuse marked-conic notation but must state its quotient
  construction independently.  It does not cite Paper I for a proof.
- Paper III may use named carriers supplied by Paper II only after restating
  the exact input theorem and making the dependency explicit.  C579 must reject
  the paper if those inputs become its only unifying question.
- The `H_3` arrangement theorem and proof occur only in Paper II.
- The compound fallback headlines are retired and regenerated; no paper
  inherits the 58-row aggregate manifest wholesale.

## `ej` + `tt` closeout

The cheap high-value upgrade was to treat the trust manifest as the invariant
of the split.  The companion CSV assigns every one of its 58 rows exactly once
and exposes the one editorially invalid object: the compound
rigidity--Coxeter headline.  Splitting that row prevents a future filtered
manifest from silently certifying a theorem that no split paper states.

The second upgrade is the strict Paper I `H_3` rule.  The reflection
identification can explain why `q=11` belongs to a small family, but its proof
and checker remain Paper II-owned.  Paper I therefore gains context without a
new dependency or a second research program.

From the standpoint of a demanding referee, the strongest Paper I is the
17-page proof order plus auditability backports, not the current proof order
with later sections removed.  The complete census earns space because it makes
the exhaustive boundary assessable; the guided tour and cross-passage ledger
do not.

## Mystery ledger

- **Settled — identity of the older manuscript.**  The exact 17-page source is
  `7d258dcd`, not the later 19-page reflection-synthesis revision
  `db69ee11`.
- **Settled — PDF hash mismatch.**  Fresh renders have the correct page counts
  but different bytes from the tracked PDFs.  Source identity is pinned by
  commit, blob, and TeX SHA-256; no byte-reproducible PDF claim is made.
- **Settled — Paper I `H_3` boundary.**  Paper II owns the theorem, proof, and
  checker.  Paper I gets at most a non-load-bearing contextual paragraph.
- **Settled — Singular dependency.**  The removed smooth-quartic claim stays
  removed, so C321 is not triggered by the focused disposition.
- **Open, C320-owned — per-paper trust gate.**  The current 58-row manifest and
  aggregate Lean gate certify the fallback.  C320 must construct and review the
  nineteen-row Paper I surface after C576 freezes the statements.
- **Open, C579-owned — Paper III unity.**  The row partition identifies its
  material but does not show that the passages have one principal theorem.

No mathematical dependency mystery blocks C576.
