# Formal-annotation conventions: linking a manuscript to its formal record

This guide is the routed reference for the annotation layer that ties a paper's
statements to their Lean coverage, their imported literature, and the
computational evidence they rest on. Read it before adding or changing an
annotation, a claim-map row, a source or evidence registry entry, or the
checker that gates them, and before adopting the layer in another paper.

The first implementation is `papers/cubic-stabilization-m1/`. Everything
below describes the convention; that paper is the reference copy.

## Why the layer exists

A claim map that lives only beside the Lean sources records what a statement's
formal coverage is, in a file the statement never mentions. Nothing stops the
statement from being rewritten underneath it. That failure has occurred: an
atomic restructure replaced the proof of a headline theorem while its claim-map
row stayed byte-identical, so the row went on describing terminals that no
longer formalized the paper's argument.

The layer closes that gap from both ends. The correspondence is recorded inside
the environment it describes, so an author rewriting a statement sees it; and
each row is pinned by digest to the statement and to the terminals it describes,
so a rewrite fails the check until the row has been re-examined.

## The vocabulary

Six macros, defined in the paper's `formal-annotations.tex`, all typographically
empty and all taking comma-separated identifiers only. Detail never lives in a
macro argument; it lives in the file the identifier resolves in, so a citation, a
convention, or a replay command has exactly one home.

| macro | records | resolves in |
|---|---|---|
| `\coverage` | strength of formalization: `absent`, `fragment`, `conditional_deduction`, `complete` | the claim map |
| `\lean` | the reviewer terminals carrying the statement, without their common namespace | the claim map and `PaperInterface` |
| `\uses` | the statements this one depends on | the manuscript's own labels |
| `\proves` | the statement a detached proof establishes | the manuscript's own labels |
| `\imports` | the external results used | the imported-source registry |
| `\evidence` | the computational evidence bundles relied on | the evidence registry |

`\lean`, `\uses`, and `\proves` follow the Lean blueprint system of P. Massot,
whose print-mode macros are likewise empty, so a blueprint build or other
tooling can read the same source. The reading of `\uses` inside a statement as a
conceptual dependency and inside a proof as a logical one follows KnowTeX
(arXiv:2601.15294). `\coverage`, `\imports`, and `\evidence` are ours.
`\coverage` replaces blueprint's two-valued formalization flag, because a
statement may also be carried by a strictly weaker fragment or by a conditional
deduction whose imported premises are exposed in the theorem type.

### Coverage values

- `absent` — no terminal. The row registers no declarations and carries no
  `\lean`.
- `fragment` — the Lean statement is strictly weaker, typically because it is
  about surrogate objects the package can express rather than the ones the
  statement names.
- `conditional_deduction` — the Lean conclusion is the manuscript's own
  conclusion, with every imported input exposed as a typed premise.
- `complete` — formalized from the manuscript's stated hypotheses.

The distinction between the middle two is the one that matters and the one most
easily overstated. If the geometry a statement speaks about does not exist in the
package, the row is a fragment however faithful the algebra is.

### Placement

Statement annotations go in the environment body, immediately after `\label`.
Proof annotations go at the **end** of the proof, immediately before
`\end{proof}`. Placing them after `\begin{proof}` changes the typeset output: the
run-in proof header ends by skipping following spaces, and a macro token there
stops that skip. The deterministic rebuild catches it, which is how the rule was
found.

## The registries

Both live under the paper's `verification/`, so the standalone export carries
them. Field names follow `papers/clebsch-factorization/verification/trust_manifest.json`
where they overlap; do not invent a second vocabulary for the same concept.

**Imported sources** (`imported-sources.json`). Each entry records `citation`, a
bibliography key that must exist in the manuscript; `pinpoint`, the exact
theorem, lemma, section, or page; `used`, the form in which this paper uses the
result; and `conventions`, a non-empty list whose entries each give an `aspect`
(framing, coordinates, normalization, sign, hypothesis, domain), the
`requirement` the source imposes, and the `matched` clause saying how this paper
meets it.

The conventions list is the point of the registry. Misuse of an imported theorem
is rarely a wrong citation; it is an unmatched convention — a sign, a
normalization, a coordinate the source fixes differently. Record every convention
whose violation would make the use invalid, including ones you are confident
about.

**Evidence** (`evidence.json`). Each entry records `role`, what the bundle
establishes; `checksum_manifest`, a tracked path that must exist; and `commands`,
the replay commands. An evidence bundle is the manuscript-side handle on a
reproducibility bundle, so its content obeys
`notes/research-reproducibility-conventions.md`; the registry does not relax any
requirement there. A paper whose spine invokes no computation keeps an empty
registry with a recorded reason, so that the first statement which later needs
one must name a bundle rather than describe it in prose.

## The claim map and its digests

Each row carries the manuscript label, the coverage value, the declarations, the
`objects`, `hypotheses`, `conclusion`, and `cautions` prose, and two digests. The
statement digest covers the manuscript statement with its annotations removed and
its layout normalized. The terminal digest covers the elaborated signatures of
the row's terminals, excluding docstrings, so improving documentation does not
read as changing a theorem. Machinery terminals carry the second digest too,
since the reason recorded for one describes what it states.

A digest failure is not a nuisance to be cleared. It means the row must be
re-examined against what the statement now says and what the terminals now prove,
and only then:

```text
python3 lean/verification/refresh_claim_digests.py LABEL
```

`--all` records every current digest and is for establishing a baseline after a
review, never for clearing a failure.

## What the gate refuses

The paper's `verification/check_formal_artifact.py`, run by `make check` in
source-only mode and against a captured axiom log in audit mode, refuses:

- a coverage value or terminal list in the source disagreeing with the claim map;
- an annotated identifier resolving in neither registry, or a `\uses` label that
  is not a semantic label of the manuscript;
- a proof naming an unknown statement, or a statement carrying two proofs;
- an imported source whose bibliography key is absent from the manuscript, that
  records no conventions, or whose convention lacks an aspect, requirement, or
  match;
- an evidence bundle with no checksum manifest on disk or no replay command;
- a statement or terminal digest that no longer matches;
- a stale dependency graph;
- and everything it refused before: an unregistered terminal, an orphaned claim,
  a coverage snapshot that disagrees with the count, a missing docstring, a
  forbidden token, an axiom-list mismatch.

Every refusal above was tested by introducing the defect and observing the
failure. Add a gate the same way: write the check, break the tree deliberately,
confirm the message names the row, restore.

## The dependency graph

`verification/dependency_graph.py` emits `verification/dependency-graph.dot`:
statements coloured by coverage strength, imported sources and evidence bundles
as separate nodes, edges dashed for conceptual, solid for logical, dotted for
imports. Output is deterministic — sorted, with no timestamp or path — and the
checker regenerates it and rejects a stale copy.

```text
python3 verification/dependency_graph.py verification/dependency-graph.dot
```

Fill `\uses` by authoring, not by harvesting cross-references. A derived graph
looks authoritative and is wrong wherever a paper establishes a dependency in
running text between environments, which is common in a long derivation. A
statement carrying no edge has none recorded, and the paper's verification README
must say which parts have been filled.

## Adopting the layer in another paper

The standalone export copies a paper's directory, so every file the manuscript or
its gate needs must live inside it. Copy `formal-annotations.tex`, the checker,
the graph generator, the digest refresher, and both registries into the new
paper; keep the claim map, registries, and coverage snapshot per-paper. Rename
the registry schema strings to the new paper. The parsing and gate logic are the
duplicated part, and factoring them into a shared module under `papers/scripts/`
is the open improvement — it must still leave each paper's copy able to run
inside its standalone repository.

Order of adoption that keeps each step checkable:

1. Annotate every theorem-like environment with `\coverage` and, where there are
   terminals, `\lean`; make the gate require agreement with the claim map.
2. Fill `\imports` with the paper's external inputs and their conventions.
3. Fill `\evidence` for every statement resting on a computation, with each
   bundle's manifest and replay command tracked.
4. Author `\uses`, add `\proves` wherever a proof is detached from its statement,
   and emit the graph.
5. Review every claim-map row against its statement and terminals, then record
   the digest baseline.

Do not record digests before the review; the digests are only as good as the
examination they freeze.

## Known limits

The digests cover theorem-like environments and terminals, not the prose between
them. Where a derivation runs in the text between two statements, a change there
is caught by neither digest, and the proof-level `\uses` edges are what make such
a derivation visible at all. The graph is emitted as DOT only; rendering it, and
publishing it beside the paper, is not part of the gate.
