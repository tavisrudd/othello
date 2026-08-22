# C943 — conventional terminology across the Clebsch and conference papers

**Lane:** `clebsch`
**Paper stream:** five-paper Clebsch series and the unnumbered conference companion
**State:** active at one external trust-chain dependency; all five numbered
papers and the unnumbered conference companion have sealed cold-referee ACCEPT
verdicts and deterministic green manuscript builds. Paper III also passes the complete
local release gate, including source-only replay of all three pinned Lean closures.
Paper I’s trust projection and mirror export remain deferred behind C855’s
pre-existing unmapped `prop:fifteen-class-census`. The shared portfolio
summary has a sealed cold-reader ACCEPT. Papers II--V, the conference
companion, the arcs paper, and the portfolio summary are exported to clean
standalone repositories and verified; Paper I alone remains deferred.

## Objective

Remove paper-specific uses of “golden” as technical branding wherever standard
mathematical language states the object or ambiguity more precisely. Preserve
literal golden-ratio arithmetic, \(\varphi\), \(\sqrt5\),
\(\mathbf Q(\sqrt5)\), discriminant five, historical terminology, quotations,
and external bibliography titles.

The governing distinctions are:

- switching versus global negation \(C\mapsto-C\);
- two-graph complementation versus a choice of matrix representative;
- sheet exchange versus Galois conjugation versus the configuration exchanger;
- determinant-line elements versus oriented scalar determinants;
- the \((\pm\sqrt5)\)-eigenspace decomposition as a consequence of
  \(C^2=5I\), not a branded source object.

## Scope and allowed paths

- `papers/clebsch-rigidity/` and its public metadata;
- `papers/clebsch-factorization/` for residual terminology and the series coda;
- `papers/clebsch-passages/` and its public metadata;
- `papers/q13-passant-code/` for the series coda and updated cross-references;
- `papers/chordal-conference-reconstruction/` and its public metadata;
- `papers/conference-cut-spectra/` and its public metadata;
- shared paper indexes, summaries, repository metadata, bibliographies, and
  trust maps that quote revised titles or printed identifiers;
- exact trust and manuscript surfaces that cite legacy formal identifiers;
- this card, the Clebsch handoff, queue/archive rows, dated C943 report, and the
  Clebsch discovery track if a genuinely incidental result appears;
- matching clean standalone mirrors under `~/src/math-papers/`, only after
  authority validation and forward commits.

Historical task names, lane aliases, dated archives, bibliography keys, and
private identifiers not exposed by a paper are outside scope.

## Decisions

1. Paper I title: *Reconstructing the Clebsch Code from Its Deep-Hole Syndrome
   Locus*.
2. Paper III title: *Hitchin’s Icosahedral Incidence Double Cover and Operator
   Realizations of the Clebsch Cubic*.
3. Keep *Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and
   Hermitian Holonomy*; “squared-spectrum” is the exact invariant.
4. Keep Paper V’s title.
5. Rename the shared Paper III coda map entry to “incidence cover / conference
   cubic” and its verse to “through paired veils, the two sheets exchange”.

## Execution and acceptance

For each paper in turn:

1. classify every case-insensitive occurrence in context;
2. revise prose, headings, labels, captions, conclusions, coda, and metadata;
3. preserve exact formal declaration names where a manuscript must cite the
   existing shared API; classify them as machine-name survivors rather than
   using their terminology in mathematical prose;
4. require every surviving occurrence to be literal arithmetic, historical
   terminology, an exact quotation, or an unchanged external title;
5. rebuild the deterministic PDF and run the paper’s complete local gates;
6. send the revised source to an independent cold referee subagent, repair all
   substantive findings, and obtain a sealed reread verdict;
7. commit authority, then synchronize and validate the clean standalone mirror.

Final acceptance also requires a series-wide survivor audit, consistent titles
and bibliography entries, clean cross-references, and zero exporter findings.
Legacy formal identifiers may survive only when quoted exactly as machine names
and must not be reused as mathematical terminology.

## Rolling review record

- Paper I — *Reconstructing the Clebsch Code from Its Deep-Hole Syndrome
  Locus*: all mathematical prose uses conference, switching, global-negation,
  and spectral-block language; the only “golden” survivors are the literal
  golden-ratio keyword, Dye’s historical parameter, and three exact legacy
  Lean declaration names. Deterministic builds pass at 29 and 14 pages with
  zero warnings. Independent cold referee: MINOR, repaired, sealed ACCEPT.
  The statement extractor is independently blocked by C855’s already-present
  theorem `prop:fifteen-class-census`, which is absent from its claim map.
- Paper III — *Hitchin’s Icosahedral Incidence Double Cover and Operator
  Realizations of the Clebsch Cubic*: mathematical prose now distinguishes
  incidence deck exchange, Galois conjugation, the configuration exchanger,
  global negation, and determinant-line orientation explicitly. The only
  “golden” survivors in the manuscript are the literal keyword “golden ratio”
  and the exact frozen Lean gate name `ClebschGoldenReturn`. The renamed
  section `03-marked-sheet-transport.tex` states the marked comparison
  directly. Deterministic PDF SHA-256 is
  `245f7274caa89141669db018a2cc10b0c5716acf37270ba476134c33351760db`;
  the complete release gate passes. Independent cold referee: MINOR, repaired
  through two sealed rereads, final ACCEPT.
- Paper V — *Chordal and Conference Cubics: Reconstruction and a Residual
  \(C_2\)-Torsor*: no “golden” terminology remains in the manuscript, README,
  or Zenodo metadata. The revision distinguishes the residual chordal-line
  torsor from the global-negation torsor \(\{[B],[-B]\}\), proves that the
  latter corresponds to the Frobenius torsor \(\{\omega,\omega^2\}\), and
  states outer-normalizer transport on the commutant explicitly, including
  the mod-\(2\) triviality of diagonal switching. The coda and Paper I/III
  citations use the revised vocabulary. `make check` passes at 23 pages;
  deterministic PDF SHA-256 is
  `013ca974439dc3b5f4002d78a9df31e5db6d97b2bdb6c6438ae1474c8e9aab0d`.
  Independent cold referee: MINOR, repaired through two sealed rereads, final
  ACCEPT.
- Paper IV — *Reconstructing \(\operatorname{PG}(2,13)\), its conic, and
  polarity from the minimum words of a binary conic code*: the only
  reader-facing occurrences were stale Paper I/conference-paper names and the
  common Paper III coda; all are updated. Its coda now distinguishes Paper
  V’s global-negation/\(\F_4\) torsor from Paper IV’s \(\F_8\)
  Frobenius-orbit marking, and its verification README is external-facing
  trust-boundary documentation. The deterministic manuscript gate passes at
  16 pages; PDF SHA-256 is
  `e3667df7d90371c22f4ae4ac7236202bbebfa47eab2a11d3952633d088d5a59f`.
  The aggregate evidence gate remains pre-existingly blocked by the missing
  C834-owned shared Lean source
  `RelativeConicArcs/PassantCodeQ13/StructuralUpgrade.lean`; C943 does not
  absorb that formal-release blocker. Independent cold referee: MINOR,
  repaired, sealed ACCEPT.
- Paper II — *Quadratic Trade Rigidity and Cubic Orientation in Conic
  Matching Quotients*: the former “golden pair” is now stated as the
  ordered/unordered parent pair, and Appendix B distinguishes exactly the
  unordered pair determining \(K\), the ordered pair, the displayed
  cell-orientation convention, the signed profiles, and sheet choice. No
  reader-facing “golden” terminology remains; frozen evidence schema keys are
  unchanged. The complete release gate passes all evidence bundles, guarded
  Lean gates, the axiom allowlist, and a warning-free 47-page deterministic
  build. PDF SHA-256:
  `e045f7de81c385d59e2aa173de668485aa5bb5e313c653160d36d4dedaacbdff`.
  Independent cold referee: MINOR, repaired through two sealed rereads, final
  ACCEPT.
- Conference companion — *Balanced Cuts of Conference Matrices:
  Squared-Spectrum Rigidity and Hermitian Holonomy*: reader-facing prose now
  uses conference-matrix, order-six transfer, and explicit
  \((\pm\sqrt5)\)-eigenspace language. The only “golden” survivors are three
  frozen evidence-schema identifiers. The abstract leads with balanced-cut
  rigidity, treats the interferometer as an application, and closes with the
  arbitrary-dimensional determinant theorem. `make check` passes at 16 pages;
  PDF SHA-256 is
  `dd08311f15337cfa7e8c8d1c427318a69a120002f68447b825e2937e93678488`.
  Independent cold referee: MINOR, repaired, sealed ACCEPT.
- Portfolio summary and arcs README: every programme overview, headline,
  table row, detailed abstract, cross-paper explanation, title, alias, and
  public link is synchronized. The Paper V entry distinguishes the residual
  chordal-line torsor from the global-negation/Frobenius torsor, and the arcs
  README now leads with the universal prescribed-hole theorem rather than the
  easier small orders. No branded “golden” terminology remains in the summary.
  Independent cold reader: MINOR, repaired, sealed ACCEPT.
- Standalone exports: clean forward commits and exporter verification pass for
  Paper II (`dfb0e89`), Paper III (`7b1067b`), Paper IV (`7c5bbfa`), Paper V
  (`d4fb4bc`), the conference companion (`f0c8ab7`), the arcs paper
  (`428d067`), and the summary (`a20389d`). Paper II and Paper III pass their
  complete release gates in the mirrors; Paper IV passes its deterministic
  manuscript gate; Paper V and the conference companion pass `make check`;
  the arcs manuscript, witness replay, and rank-three certificate pass. All
  seven downstream worktrees are clean. Paper I's generated
  `verification/statement_identity.json` still contains one stale phrase,
  “golden operator”; regeneration and export remain correctly blocked by
  C855's unmapped `prop:fifteen-class-census`, so C943 does not hand-edit that
  generated trust identity.

## Mystery ledger

- **Settled by the C943 `ej` + `tt` closeout:** the repeated appearance of
  five is now presented as a consequence of conference identities and their
  \((\pm\sqrt5)\)-eigenspaces; exact title capitalization, the distinction
  between the two Paper V torsors, and the noncanonical nature of the marked
  sheet comparison are consistent across papers, summaries, and eligible
  mirrors.
- **Open evidence gap:** Paper I's generated statement identity and standalone
  export wait on C855's theorem-map repair for
  `prop:fifteen-class-census`. C855 owns the exact gate; no manuscript theorem
  or terminology judgment remains open in C943.
- **External publication state:** existing DOI/GitHub releases under former
  titles are not rewritten or pushed by this task. Forward public versioning
  remains the author's publication action.
- **Mathematical mysteries:** none introduced by the terminology revision.
  The changes preserve every theorem and ambiguity rather than creating a new
  named structure.
