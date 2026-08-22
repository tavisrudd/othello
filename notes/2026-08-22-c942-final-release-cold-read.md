# C942 final release cold read

**Artifact:** `papers/cubic-stabilization-m1/REVIEWER_GUIDE.md`  
**Verdict:** PASS, with one minor Blueprint-link qualification  
**Confidence:** high (0.96)

## Method

I formed the verdict without reading the earlier C942 reports. I read the guide
as a mathematical referee, checked its ten cited labels against the primary
paper, recomputed the primary-paper coverage census from `claims.json`, and ran
`nix run .#blueprint-web` from the paper root. Only after fixing the verdict did
I compare it with the earlier mathematical, hostile, and formal reports.

## Findings

### Fatal

None.

### Major

None.

### Minor

1. **The generated Lean declaration links need a local-use qualification.**
   The Blueprint command exits zero and produces the rendered paper and
   dependency graph. The declaration names are emitted as links of the form
   `/find/#doc/<declaration>`, but `blueprint/web/` contains no `/find/`
   declaration browser. Thus the links are suitable for a deployment that
   provides that endpoint, but do not resolve in the standalone static output.
   The guide says only that the target “writes ... Lean declaration links,” so
   this is not a false build claim. A local reader may nevertheless expect the
   links themselves to work. The least intrusive repair would be to say
   “Lean declaration names and links for a deployment with a declaration
   browser,” or simply “Lean declaration names.”

## Mathematical check

The six-check route follows the proof in the right order and keeps its
conditional interfaces visible.

- The guide correctly moves from generalized Euler eigenspaces to formal
  connection blocks before introducing the effective marker ledger.
- Its statement of the marker theorem retains the operation formulas,
  invariance conditions, and actual center occurrences. It does not repeat the
  earlier overstatement that additivity alone gives birational invariance.
- The QDM-comparison check names the load-bearing coefficient, carrier,
  regularity, suspension, and occurrence-indexing issues. The faithful center
  base-change lemma is given its proper role.
- The rank-two check identifies the real trap: nonzero residue discriminant
  does not exclude resonance. Distinct exponent classes modulo the integers are
  required.
- The cubic calculation has the correct exponents, `-1/6` and `-5/6`, and the
  correct difference, `2/3`. The low-dimensional argument has the same surface
  cases as the paper.
- The endpoint values are correct: two for `X x P^1` and zero for `P^4`.
  Weak factorization plus occurrence-level center nullity then gives the stated
  contradiction.

All ten labels cited in the guide resolve in the primary manuscript. The
primary sections have fifteen registered claims: five `fragment`, nine
`conditional_deduction`, one `absent`, and no `complete` claim. The absent row
is exactly `lem:faithful-center-base-change`, so the guide's formal census and
its account of the Lean boundary are exact.

## Blueprint check

`nix run .#blueprint-web` completed successfully in about two seconds. It
regenerated `blueprint/web/index.html` and
`blueprint/web/dep_graph_document.html`. The main theorem appears in the
rendered paper, the `\lean` declaration annotations appear, and the dependency
graph is present. The guide also gives the right trust statement: this target
renders the annotation layer; it neither builds Lean nor checks the named
declarations.

The Blueprint target is separated from the manuscript shell and PDF target in
`flake.nix`. Its command reads the paper sources, extracts the manual
bibliography into `blueprint/src/generated-references.tex`, and writes only the
ignored Blueprint outputs. I found no path by which running it alters the PDF
source or manuscript build product.

## Prose and release verdict

The guide passes the repository style guide's anti-template checks. Its six
questions have distinct mathematical jobs rather than a repeated generic
shape. The prose uses direct verbs, varies sentence length naturally, and has
no canned transitions, ornamental significance claims, chatbot vocabulary
clusters, corrective slogans, or closing flourish. Labels and filenames appear
only where they let a referee verify a step.

The text demonstrates careful production rather than claiming it. In
particular, it exposes the resonant-block failure mode, distinguishes actual
center occurrences, reports the unfavorable formal census including the absent
lemma, says exactly what `make check` omits, and limits LeanBlueprint to a
reading aid. Those choices are more persuasive than an assurance that the work
was carefully checked.

## First friction

The first substantive friction came only in the final Blueprint paragraph.
After the successful build, a declaration name looks clickable but targets a
`/find/` service absent from the local static output. The mathematical reading
route itself did not produce an earlier point of confusion.

## Strongest feature

Check 3 is the strongest passage. It tells the referee which tempting shortcut
fails and why: unequal residue eigenvalues do not by themselves give distinct
formal exponent classes modulo the integers. That one warning shows command of
the proof and materially improves the audit route.

## Mystery ledger

- **Settled:** whether the Blueprint markup actually renders. The pinned target
  exits zero and produces the paper view, declaration annotations, and graph.
- **Settled:** whether the new web target interferes with the PDF build. Its
  write set is confined to generated files under `blueprint/`.
- **Open, minor:** the repository does not supply the `/find/` service targeted
  by the generated declaration links. This is a deployment/usability gap, not a
  mathematical, formal-coverage, or PDF-build gap. The owner can close it by
  qualifying the guide's wording or by configuring a declaration browser.

No unexplained mathematical feature remains in the reviewer guide.
