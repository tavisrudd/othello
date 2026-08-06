# C864 — declaring the order-25 candidate's banner transformation

**Lane:** `build-sys` · **Date:** 2026-08-05

**Verdict: the order-25 candidate's rewrite of its generated comments is now declared, named
`q25-banner-normalization-v1`, and checkable by a command rather than by reading a diff.  Six
substitutions plus an added module docstring account for 9,528 of the 9,531 sealed sources exactly;
the three that remain carry a hand-rewritten module docstring, listed by name, with every changed
line inside the module's own comment block.  Nothing in the transformation touches a declaration, a
proof, or a numeral.  The same pass measured the candidate's staleness properly: it is behind the
monorepo by 1,786 files across nine generated families, not the 122 previously recorded.**

## Why a declaration is the deliverable

The portfolio audit (`notes/2026-08-05-c864-certificate-portfolio-audit.md`) found that 9,500 of the
candidate's 9,531 sealed sources differ from the monorepo authority, and that the difference is a
deliberate and correct repair: internal task identifiers out of the headings, generator paths
repointed from the private notes directory to the package's own `scripts/`.  Acceptance criterion 2
requires every intentional difference between an official source and its pre-deletion authority to
be listed and justified.  Undeclared, the largest such difference in the portfolio is
indistinguishable from corruption, and an auditor has to re-derive the rule from diffs — which is
what both the previous audit and this one had to do.

## The transformation

Applied to the authority bytes, in this order, over comment text only:

| authority text | packaged text | sources |
|---|---|---|
| `# Generated C151 `                 | `# Generated q=25 certificate `               | headings across all generated families |
| `` `notes/<date>-c151-<stem>` ``    | `` `scripts/<stem>` ``                        | every generator reference |
| `generator SHA256:`                 | `source-generator SHA256:`                    | generator-hash bullets |
| `lexicographic C150 internal-orbit` | `lexicographic normalized-row internal-orbit` | 1,310 residual-cover rows |
| `# C331 semantic`                   | `# semantic-exhaustion bridge semantic`       | one heading |
| `C151` as a whole word              | `q=25 certificate`                            | remaining prose |

The whole-word restriction on the last rule is not cosmetic.  `C151` also occurs inside declaration
names as a column index — `residualCoverRow050C151_200` — and an unrestricted substitution rewrites
twelve such declarations, which is a mathematical change disguised as a comment fix.  The first
version of the rule did exactly that, and the audit caught it as twelve unexplained files.

## What it accounts for

| class | sources |
|---|---|
| byte-identical to the authority | 31 |
| reproduced exactly by the six substitutions | 7,553 |
| substitutions plus an added module docstring | 1,944 |
| hand-rewritten module docstring | 3 |
| total sealed | 9,531 |

The 1,944 additions are a generated table gaining a banner it never had: 1,943 share one seven-line
docstring, one is bespoke.  The audit admits an insertion only when every added line lies inside an
added `/-! ... -/` block, so an addition can carry prose and nothing else.

The three hand-rewritten modules are `RelativeConicArcs/Gates/AlternateOrbitRepairQ25.lean`,
`RelativeConicArcs/Gates/AlternateOrbitRepairQ25Minimum.lean` and
`RelativeConicArcs/Q25MinimumChecker.lean`.  Each drops an internal reference — the
`alt-orbit-repair` lane, the task identifiers `C331` and `C143` — and rewraps the surrounding
sentences.  Every changed line sits inside the module docstring, verified by locating the enclosing
`/-!`/`-/` block in each file.

## How it is checked

`lean/scripts/lean-package-source-audit.py` gained `--declared-transformation`.  Named
transformations live in the script as substitution tables; a package's `PROVENANCE.md` cites the
name.  A source the rules reproduce is reported as `transformed-by-<name>`, one that also gains a
comment block as `transformed-by-<name>-plus-added-banner`, and anything else stays
`DIFFERS-from-authority` and remains a defect.  Undeclared packages are unaffected: with no
`--declared-transformation`, every difference is still a defect, which is the only safe default.

```sh
python3 lean/scripts/lean-package-source-audit.py ~/src/lean/finitegeom-q25-certificates \
  --authority HEAD --source-prefix '' --declared-transformation q25-banner-normalization-v1
```

Against monorepo `951f050b`, that reports 7,553 transformed, 1,944 transformed with an added banner,
31 identical, and 3 differing, in about eighty seconds.  It runs no Lean and takes no lock.

## Staleness, corrected

The previous audit recorded the candidate as lacking 122 files of the residual-cover family.  The
reverse comparison over all `Q25`-prefixed monorepo sources gives a much larger figure: the seal
holds 9,519 of the monorepo's 11,305, so the candidate is behind by 1,786 files.

| family | monorepo | sealed | behind |
|---|---|---|---|
| `Q25ResidualTransportData`    | 1,341 | 1,036 |   305 |
| `Q25ExhaustionConclusionData` | 1,375 | 1,071 |   304 |
| `Q25ResidualConclusionData`   | 1,375 | 1,071 |   304 |
| `Q25ResidualDispatchData`     | 1,375 | 1,071 |   304 |
| `Q25ResidualClassLinkData`    | 1,340 | 1,036 |   304 |
| `Q25ResidualCoverData`        | 1,194 | 1,072 |   122 |
| `Q25ClassBoundData`           |   122 |     0 |   122 |
| top-level `Q25*` modules      |    41 |    29 |    12 |
| `Q25ResidualCoverPrototype`   |     7 |     0 |     7 |
| `Q25RowCompositionData`       |   239 |   238 |     1 |

`Q25ClassBoundData` and `Q25ResidualCoverPrototype` are absent entirely, so the gap is not one
family drifting but a snapshot predating several.  The consequence for the execution order is that
the order-25 externalization re-extracts from the monorepo authority; this candidate is a source of
one thing only, the transformation now declared, which the re-extraction should apply as its own
declared step.

## Left open

The rewritten headings read `Generated q=25 certificate Q25 line-mask data`, naming the family
twice, because the substitution replaced the task identifier and left the family name that followed
it.  Fixing it in this snapshot would require rewriting and resealing 9,531 files for a comment; the
repair belongs in the re-extraction, as `q25-banner-normalization-v2` with the redundant word
dropped.  Both defects are recorded in the candidate's `PROVENANCE.md`, which remains uncommitted
along with the rest of the candidate: it is not an adopted authority, and adopting it is a separate
decision the execution order places after the C318/C319 reconciliation.

`lean-package-source-audit.py` still iterates the package's sealed sources, so it cannot report
authority files the package lacks; the staleness table above was computed separately.  Adding the
reverse direction remains queued for the first cut that depends on it.
