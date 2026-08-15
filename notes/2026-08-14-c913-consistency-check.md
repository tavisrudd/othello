# Bookkeeping consistency pass over 86dfdd447..HEAD (C913)

Date: 2026-08-14
Range: `86dfdd447..25403b891` (HEAD). Read-only pass; nothing edited except this file.

Scope note before the items. The coordinator described the range as "all touching
papers/cubic-stabilization-irrationality plus papers/papers-index.md and
papers/summary/README.md". The range in fact also rewrites
`papers/cubic-stabilization-epilogue/` (introduction, envelope, one-step, synthesis, its
ledger, its Lean `claims.json`) and `papers/discrepancy-one-flips/`. Those are foreign to
this pass and were not audited; only their non-interference with the irrationality paper was
checked. The seven items below concern the irrationality paper only.

Verdict table:

| Item | Verdict |
|------|---------|
| 1 cross-references and build log            | PASS on the source; the tracked build log is STALE and cannot certify it |
| 2 GiventalToricCI and CoatesGivental        | PASS — every field confirmed against an authoritative source |
| 3 title agreement across seven surfaces     | PASS — all seven carry the identical string |
| 4 claim ledger row for the new lemma        | FAIL — row exists, but its power of `z` is wrong |
| 5 abstract gate in check_release_surface.py | FAIL — a passing abstract that asserts the conclusion unconditionally exists, and is given below |
| 6 EXPECTED_PAGES                            | PASS against the tracked PDF (42 pages) |
| 7 stale title / framing / counts elsewhere  | THREE STALE ITEMS, all in papers/summary/ and .zenodo.json |

---

## Item 1 — cross-references. PASS on the source; the tracked log is stale

Added references in the diff, all fifteen distinct targets:

    eqref: eq:barnes-algebraic-part, eq:cai-cubic-matrices, eq:cubic-i-function,
           eq:cubic-indicial-polynomial, eq:cubic-point-central-charge,
           eq:cubic-quantum-period, eq:flat-euler-pairing, eq:gamma-framed-section,
           eq:zero-mode-specialization
    ref:   conj:gamma-window, cor:simple-wall-rank, hyp:marked-threshold-wall,
           hyp:marked-threshold-zero, lem:cubic-central-charge, rem:verification-status

Every one resolves to exactly one `\label` in `cubic_stabilization_irrationality.tex` or
`sections/`. Counted individually: all fifteen have definition count 1.

Labels added by the diff: `eq:barnes-algebraic-part`, `eq:cubic-i-function`,
`lem:cubic-central-charge`. Labels removed or renamed by the diff: none — the diff contains
no `-` line carrying a `\label`, so no reference was orphaned by a rename.

Whole-paper check, not just the diff. Collecting every `\ref`/`\eqref` target and every
`\label` across the main file and all nine section files: the set difference
(references with no label) is empty, and there are no duplicate labels. Collecting every
`\cite` key and every `refs.bib` entry key: every cited key exists in `refs.bib`. Two
`refs.bib` entries are defined and never cited — `AcostaShoemaker` and `SpVdB` — but both
predate this range and an uncited entry is inert under a plain bibliography style.

The build log, which is what the item asked to confirm, does not support a conclusion.
`cubic_stabilization_irrationality.log` contains no `LaTeX Warning: Reference`, no
`Citation ... undefined`, no `multiply defined`, and no `There were undefined` — but it is
stale:

    cubic_stabilization_irrationality.log   2026-08-14 21:58:47   "Output written ... (41 pages"
    cubic_stabilization_irrationality.aux   2026-08-14 21:58:47
    cubic_stabilization_irrationality.xdv   2026-08-14 21:58:47
    sections/01-introduction.tex            2026-08-14 22:09:28
    cubic_stabilization_irrationality.tex   2026-08-14 22:09:33
    cubic_stabilization_irrationality.pdf   2026-08-14 22:10:09   (42 pages)

The log predates the last two source commits (`011580e55` at 22:03:43 and `25403b891` at
22:10:27) and reports a page count one lower than the tracked PDF. So the clean log is
evidence about an intermediate draft, not about the current source. The source-level checks
above are what actually certifies the current state, and they pass.

This is not a release-gate hole: `check_manuscript_build.py` runs its own deterministic
isolated build into a temporary root and reads *that* log for warnings and the page count,
then byte-compares the resulting PDF against the tracked one. The stale in-tree
`.log`/`.aux`/`.xdv` are ordinary latexmk debris. The one place it bites is `make warnings`,
which greps the in-tree log and would currently pass on stale evidence.

Recommendation: run `make manuscript-check` (or `make manuscript`) so the in-tree auxiliaries
match the committed source, or delete them. Low priority.

## Item 2 — the two new bibliography entries. PASS

Both were checked against the shared disk cache first, then against an authoritative
bibliographic record. The cache holds both blobs, fetched 2026-08-13:

    arXiv:alg-geom/9701016   sha256 b2b9a776ad8165029ec792964f357bf30ff0c80061ccead51ffac04cbda0de6b
    arXiv:math/0110142       sha256 5f5ff2b0de5d23f430374f5c3f1c234f5578307131434e3d40552c72f3bfd78e

Both are preprint versions (v2, dated 3 Mar 1997 and 19 Oct 2001) and carry no journal
reference, so the cache confirms author, title, and arXiv identifier but cannot confirm any
publication field. Those were confirmed separately, as recorded below.

### GiventalToricCI

| Field | Bib value | Confirmed against |
|-------------|-------------------------------------------------------|------------------------------------------|
| author      | Givental, Alexander                                   | cached PDF title page; Crossref; zbMATH  |
| title       | A mirror theorem for toric complete intersections     | cached PDF; Crossref; zbMATH             |
| booktitle   | Topological Field Theory, Primitive Forms and Related Topics (Kyoto, 1996) | Crossref `10.1007/978-1-4612-0705-4_5`; zbMATH |
| series      | Progress in Mathematics                               | zbMATH `Prog. Math. 160`                 |
| volume      | 160                                                   | zbMATH `Prog. Math. 160`                 |
| publisher   | Birkhäuser, Boston                                    | Crossref: Birkhäuser Boston, Boston MA   |
| year        | 1998                                                  | Crossref; zbMATH                         |
| pages       | 141--175                                              | Crossref `141-175`; zbMATH `141-175`     |
| eprint      | alg-geom/9701016                                      | cached blob; zbMATH arXiv link           |

The "(Kyoto, 1996)" parenthetical is correct and more specific than it looks. zbMATH records
the volume as "Proceedings of the 38th Taniguchi symposium, Kyoto, Japan, December 9-13, 1996
and the RIMS symposium with the same title, Kyoto, Japan, December 16-19, 1996." The book's
editors are Kashiwara, Matsuo, Saito, and Satake; the entry does not list them, which is
normal for an `@incollection` and not an error. Note the cached preprint is dated 1997 while
the volume appeared in 1998; the bib correctly carries the publication year.

Crossref alone does *not* record the series or its volume for this chapter (both come back
null), so "Progress in Mathematics, 160" rests on the zbMATH record (Zbl 0936.14031). That is
an authoritative bibliographic database, not an inference, so the field is confirmed rather
than assumed. Nothing in this entry is unconfirmed.

### CoatesGivental

| Field | Bib value | Confirmed against |
|-------------|--------------------------------------------|-------------------------------------------------|
| author      | Coates, Tom and Givental, Alexander        | cached PDF ("TOM COATES AND ALEXANDER GIVENTAL") |
| title       | Quantum Riemann--Roch, Lefschetz and Serre | cached PDF; Crossref; zbMATH                    |
| journal     | Annals of Mathematics (2)                  | Crossref "Annals of Mathematics"; zbMATH "Ann. Math. (2)" |
| volume      | 165                                        | Crossref; zbMATH                                |
| number      | 1                                          | Crossref issue 1; zbMATH "No. 1"                |
| pages       | 15--53                                     | Crossref `15-53`; zbMATH `15-53`                |
| year        | 2007                                       | Crossref; zbMATH                                |
| eprint      | math/0110142                               | cached blob                                     |

The `(2)` second-series designation is confirmed by zbMATH, which prints
"Ann. Math. (2) 165, No. 1, 15-53 (2007)". Crossref lists the first author's given name as
"Thomas"; the bib's "Tom" is how the paper itself signs it, so this is a naming variant, not
an error. Nothing unconfirmed.

Both entries carry `archivePrefix = {arXiv}` with an `eprint` but no `primaryClass`; the
neighbouring entry in the same file (the one just above `GiventalToricCI`) does carry
`primaryClass = {math.AG}`. Cosmetic inconsistency, no effect on the rendered bibliography.

## Item 3 — title agreement. PASS

The canonical string is

    Gamma Point Rows under Quantum Wall Crossing and a Criterion for Stable Irrationality

All seven surfaces carry it, character for character once line breaks are normalized:

| Surface | Form |
|---------|------|
| `cubic_stabilization_irrationality.tex` `\title` | broken with `\\` after "Crossing" |
| same file, `hypersetup{pdftitle=...}`            | broken across source lines after "Crossing", no `\\` |
| `README.md` line 1 (H1) and line 9 (`**Title:**`) | H1 on one line; the `**Title:**` copy soft-wraps after "for" |
| `.zenodo.json` `"title"`                          | one line |
| `verification/check_release_surface.py` line 175  | split as `"...Criterion for " "Stable Irrationality"` |
| `papers/papers-index.md` line 135                 | soft-wraps after "Stable" |
| `papers/summary/README.md` lines 17, 67, 152, 235, 455 | four soft-wrap variants plus two single-line copies |

No near-misses: capitalization is identical everywhere ("under" lower-case, "Gamma Point
Rows", "Criterion", "Stable Irrationality"), and no surface retains a subtitle colon. The
built PDF confirms the metadata is current:

    Title:    Gamma Point Rows under Quantum Wall Crossing and a Criterion for Stable Irrationality
    Subject:  Gamma point-row transport under quantum wall crossing and a conditional
              stable-irrationality criterion for cubic threefolds
    Keywords: ..., cubic threefold, stable irrationality

The `.zenodo.json` title and the `check_release_surface.py` literal agree, so the Zenodo gate
passes.

## Item 4 — the claim ledger. FAIL on wording

The diff adds exactly one theorem-like label, `lem:cubic-central-charge` (the other two new
labels, `eq:barnes-algebraic-part` and `eq:cubic-i-function`, are equation labels). The ledger
does have a row for it, inserted in the right position. So coverage is complete.

The row's wording does not match the lemma. Ledger:

> The unit component of the cubic Gamma point section is the regularized quantum period, up
> to a nonzero constant and an integral power of `z`.

Manuscript, `sections/09-cubic-endpoint.tex`, `lem:cubic-central-charge`:

> there are a nonzero constant \(C\) and an integer \(k\), both independent of \(z\) and fixed
> by the chosen Gamma and graph-space normalizations, such that the component of the Gamma
> point section along the unit is
> \(Z_p(z):=(s_X(\OO_p),\mathbf 1)_X = C\,z^{\,k-3/2}F(q/z^2)\).

The discrepancy is `z^{k-3/2}`, not `z^k`. The exponent is a half-integer, and the lemma is
explicit that `C` and `k` are both independent of `z`, so the `z^{-3/2}` cannot be absorbed
into the constant. The proof shows exactly where it comes from: the grading operator gives
`\mu[p] = (3 - 3/2)[p]`, hence `z^{-\mu}[p] = z^{-3/2}[p]`. So the ledger row claims a
tighter normalization than the manuscript proves. The same error is repeated in the row's
last column, "conventions absorbed into the constant and the integral power".

Suggested wording: "up to a nonzero constant and a half-integral power `z^{k-3/2}` with `k`
an integer".

Second, smaller point on the same row. "The regularized quantum period" is terminology that
appears nowhere in the manuscript — `grep` over `sections/` finds no occurrence of
"regularized", and the manuscript names `F` through the label `eq:cubic-quantum-period` and
calls it "the cubic hypergeometric period" in the introduction. Whether
`F(t) = \sum (3d)!/(d!)^5 t^d` is the regularized quantum period in the standard
Coates–Corti–Galkin–Kasprzyk normalization was not verified in this pass and is reported as
unconfirmed rather than assumed. The safe fix is to have the ledger use the manuscript's own
name for `F`.

The rest of the row is accurate: the dependency column ("grading and Gamma factors evaluated
on the top class; small `I`-function of the degree-three hypersurface with trivial mirror map
by its `z^{-2d}` degree count") matches the proof step for step, and the novelty column
correctly attributes the mirror theorem to Givental.

## Item 5 — the abstract gate. FAIL; a passing counterexample was found

The rewritten gate, `verification/check_release_surface.py`:

```python
abstract_text = abstract_match.group(1)
conclusion = abstract_text.find("is irrational")
if conclusion < 0:
    errors.append("abstract does not state the cubic conclusion")
else:
    for phrase in ("gauged-admissible", "marked threshold compatibility"):
        position = abstract_text.find(phrase)
        if position < 0 or position > conclusion:
            errors.append(...)
```

The gate tests *string order inside the abstract*, nothing else. It does not test that the
two phrases govern the conclusion, does not test for any hedging verb ("Assume", "Granting",
"conditional"), and — because it uses `find` rather than scanning all matches — looks only at
the *first* occurrence of "is irrational". Three consequences, in increasing order of how
likely they are to occur by accident.

**A passing abstract that asserts the conclusion unconditionally.** This one clears the gate:

```latex
\begin{abstract}
This paper needs neither a gauged-admissible completion nor marked threshold
compatibility.  For every smooth complex cubic threefold \(X\) and every
\(m\geq0\), the product \(X\times\mathbf P^m\) is irrational.
\end{abstract}
```

"gauged-admissible" occurs at offset 22, "marked threshold compatibility" at offset 58, and
"is irrational" at offset 218. Both assumption phrases precede the conclusion, so all three
sub-checks pass, while the abstract explicitly denies that either assumption is used. Nothing
else in `check_release_surface.py` reads the abstract, and the other checks in the file read
`sections/01-introduction.tex`, `README.md`, the ledger, and `.zenodo.json`, so leaving those
untouched makes the whole release-surface check pass.

**The realistic regression, which is worse than the adversarial one.** The gate cannot
distinguish "we assume A" from "we prove A". An abstract that opened

> We compare Gamma point rows across a gauged-admissible cobordism and prove marked threshold
> compatibility for it. ... Hence \(X\times\mathbf P^m\) is irrational for every smooth
> complex cubic threefold \(X\) and every \(m\geq0\).

passes, and is exactly the overclaim the gate exists to prevent. This is a plausible outcome
of a future rewrite that trims hedges for readability, which is precisely what the current
range did to the abstract.

**Only the first conclusion is guarded.** Because `conclusion` is a single `find`, appending
a second, unhedged restatement later in the same abstract is invisible to the gate.

What the gate does still catch: an abstract that states the conclusion and never mentions
either assumption, and an abstract that puts the conclusion in the opening sentence with the
assumptions only afterwards. That is a real, if narrow, guard, and it is weaker than the
regex it replaced, which at least required the literal frame "Assume that every smooth
projective birational map ... We prove that".

Suggested strengthening, in order of cost: require a hedging token
(`Assume|Granting|Under|Conditional`) within some window before the first "is irrational";
check *every* occurrence of "is irrational" rather than the first; and assert that the
sentence containing the conclusion, not merely the abstract, carries the dependency. None of
these is airtight either — a string gate over prose cannot be — but each closes the specific
hole demonstrated above.

## Item 6 — EXPECTED_PAGES. PASS

`verification/check_manuscript_build.py` was raised from 39 to 42 in this range. The tracked
PDF reports 42 pages (`pdfinfo`), and its embedded Title, Subject, and Keywords match the
current `\title`, `pdfsubject`, and keyword list, so the tracked artifact is current with the
source. `EXPECTED_PAGES = 42` therefore agrees with the tracked build.

Caveat on how this was verified. The gate builds fresh in an isolated root, reads the page
count out of that build's log via `Output written on ... (N pages,`, and then byte-compares
the fresh PDF with the tracked one. A full `make manuscript-check` was not run here — it needs
the `nix develop ..#manuscript` shell and a complete XeLaTeX build, and this pass is read-only
— so what is confirmed is "42 matches the tracked PDF", not "42 matches a fresh build". Those
coincide iff the tracked PDF is itself current, which its metadata and its 22:10:09 timestamp
(after the final source edit at 22:09:33) both indicate.

The stale in-tree log reports 41 pages, which is the intermediate state described in item 1
and is not evidence against 42.

## Item 7 — stale titles, framing, and counts elsewhere under papers/

Three stale items, none of them a title mismatch.

**1. `papers/summary/VERIFICATION.md` line 36 — old framing, should be fixed.** The row label
is

> | Conditional cubic stabilization via point-class rank | The [verification directory](...) checks the public conditionality boundary ... |

"Conditional cubic stabilization via point-class rank" is the pre-retitle framing; it is
almost the deleted `pdfsubject`, which this range changed from "Conditional cubic
stabilization via Gamma point-class rank and quantum wall crossing" to "Gamma point-row
transport under quantum wall crossing and a conditional stable-irrationality criterion for
cubic threefolds". Every other row in that table names its paper the way the index does
("Irrationality after one stabilization", "Discrepancy-one flips"), so this row is now the
only one pointing at a name the project no longer uses. The file was not touched in this
range.

**2. `papers/summary/README.md` lines 18–19 — residual "point-class rank".** The sentence
reads "*Gamma Point Rows under Quantum Wall Crossing and a Criterion for Stable
Irrationality* obtains this dimension-independent conclusion from point-class rank under
quantum wall crossing." The title was updated in this range but the following clause was not:
"point-class rank" is the exact phrase the retitle moved away from, and the paper now says
"Gamma point row" throughout. This is soft — the notion is still in the paper, and the flat
covector does read ordinary rank — but the sentence now names the paper one way and its
mechanism the old way in the same breath. (This escapes a naive grep because the phrase wraps
across the two lines.)

**3. `papers/cubic-stabilization-irrationality/.zenodo.json` `"description"` — mirrors the
pre-rewrite abstract.** The title field was updated; the description was not. It still opens
"Assuming a gauged-admissible marked Wlodarczyk completion and the inverse-system family of
one-object marked threshold comparisons stated in this paper, X × P^m is irrational...",
which is the old abstract's opening, and it never mentions the marked Gamma/window
continuation conjecture that the new abstract foregrounds as "the route by which we expect
them to be removed", nor the `m >= 2` counting-failure framing that this range added. Nothing
is false in the description; it is simply a snapshot of the superseded abstract. The release
gate checks only `metadata["title"]` and `metadata["license"]`, so this will not be caught
automatically. Worth refreshing before the next Zenodo deposit.

**Clean:**

- No file under `papers/` still carries the old title string. A search for "Conditional
  Irrationality", "Point-Class Rank", and "point-class rank" across `*.md`, `*.json`, `*.py`,
  `*.tex`, and `*.bib` returns only the two summary-directory hits above.
- No stale page or length count survives. `papers-index.md` previously said "externally
  circulation-ready 20-page preprint" and this range deleted the count rather than updating
  it, which matches the project convention of keeping counts out of docs. No other page or
  length figure for this paper exists under `papers/`.
- No other paper cites this one by title. The irrationality paper cites the epilogue as
  `RuddEpilogue`; no `.tex` or `.bib` under `papers/` cites the irrationality paper by a key
  or a title string, so the retitle orphaned no citation.
- The `papers-index.md` *Scope* and *Boundary* bullets remain accurate under the new title:
  they still describe the simple-wall coordinate, the ordinary-flop point-row theorem, the
  two no-go theorems, the endpoint contrast, and the conditionality of the all-stabilizations
  conclusion.

---

## Summary of what needs action

1. Ledger row `lem:cubic-central-charge`: "an integral power of `z`" should be `z^{k-3/2}`
   with `k` integral. This is the one substantive error found.
2. Abstract gate: passes an abstract that denies its own assumptions. Counterexample above.
3. `papers/summary/VERIFICATION.md` row label still uses the pre-retitle framing.
4. `.zenodo.json` description still mirrors the superseded abstract.
5. `papers/summary/README.md` line 18 still says "point-class rank".
6. Housekeeping: in-tree `.log`/`.aux`/`.xdv` are one build behind the source (41 vs 42
   pages); `make warnings` would read them.
