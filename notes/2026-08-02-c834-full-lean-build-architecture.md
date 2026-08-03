# C834 — Paper IV Lean build and proof architecture

**Date:** 2026-08-02

**Scope:** source-only architecture review; no Lean build was run

## Release standard

“Full Lean for public release” means a complete, public, reproducible formal
package governed by the same statement, trust, axiom, provenance, and release
ledgers as Papers I--III.  It does not require replacing a short structural
mathematical proof by a larger finite proof tree merely to increase the
kernel-checked percentage.

Every clause of the paper theorem must have one declared owner:

- a kernel-checked Lean theorem;
- a compact certificate checked by a proved Lean checker;
- a classical theorem with an exact citation and hypotheses;
- or a structural human proof whose full argument is in the manuscript.

The public theorem map must cover every clause, but it must not assemble human
or classical inputs into a declaration advertised as a completely
kernel-checked main theorem.  Release-facing Lean terminals will contain no
`native_decide` axiom.  Native evaluation and Python may remain independent
regression tests, outside the logical release gate and identified as such.

This is the series standard applied more strictly: complete correspondence and
trust accounting, without pretending that a large execution is a proof term.

## Present source shape

The paper package contains 61 Lean modules and the shared q=13 directory eight.
A source screen finds 95 `native_decide` occurrences in 52 files: 48
paper-owned files and four shared files.  This count is a source baseline, not
an axiom count; small `by decide` proofs are kernel reduction and belong to a
different trust class.

The weight of the current graph comes from four architectural choices:

1. the aggregate imports historical theorem paths after the manuscript has
   replaced them;
2. several terminals materialize large lists, products, powersets, or matrix
   products and then ask native evaluation to decide the result;
3. semantic transports and concrete finite calculations are interleaved, so a
   small change invalidates a large closure;
4. `RelativeConicArcs.PassantCodeQ13.StructuralUpgrade` imports the entire
   `Mathlib.Tactic` umbrella for four elementary tactics.

The most expensive obsolete paths are:

- fourteen weight-ten syndrome-disjointness shards;
- the seven row-extension residue modules and their triple-concurrence
  transport;
- explicit multiplication of 78-square relation matrices;
- pair/triple scans over all 364 materialized supports;
- native checks of the full 183-point incidence axioms;
- fixed-point meet-in-the-middle support materialization inside Lean.

## What becomes a structural proof

| Published claim | Replace the heavy route by | Lean responsibility |
|---|---|---|
| weight eight | the tangent reduction followed by the displayed rational positive-semidefinite form | formalize the tangent-to-clique implication and a generic Gram/LDL positive-form lemma; check one sparse rational factorization, not 111,930 subsets or all cliques |
| weight ten | the line moment, which leaves only the \(m=6\) and \(m=10\) shapes | formalize the two double counts and moment algebra; check only four line-stabilizer and thirty-three point-stabilizer obstruction records |
| geometric rows | concurrence-eight neighborhoods equal polar rows | delete the triple-signature uniqueness theorem and all seven residue leaves; prove the polar equivalence algebraically and check at most one representative per relation orbit |
| pair table | transitivity on the six elliptic relations plus orbit/stabilizer double counting | prove equivariance and intersection-number formulas; check six representatives rather than \(364\cdot78^2\) incidences |
| relation algebra | parity reduction of the integral intersection table | prove matrix identities entrywise from intersection numbers; do not multiply 78-square matrices computationally |
| automorphisms | sharp three-transitivity and the four-anchor equations | prove the group action and solve the fourth-anchor/signature equations over \(\mathbf F_{13}\); remove enumeration of all 2,184 matrices and 78 signatures |
| ambient plane | the adjoint \(\mathfrak{sl}_2\) model and trace polarity | prove line uniqueness by cross products/determinants and prove the three incidence rules algebraically; do not decide all pairs in a 183-point model |
| toric families | the punctured pencil-conic discriminant argument | formalize the nonsquare/internal-point and double-root parity identities; no twelve-point-by-78-line scan |
| octahedral family | subgroup orbit structure and incidence-orbit parity | prove invariance and reduce parity to the few line orbits; retain one small orbit table only if the subgroup calculation does not compress cleanly |
| hidden \(\mathbf F_8\) | the cubic relation and irreducibility, followed by scalar Gram operators | formalize the field action abstractly; use sparse rank/left-inverse certificates only for the two dimension statements |
| full plane recovery | the classical conic action and involution/polar-axis dictionary, with the paper's recovery argument | keep the classical dictionary and the abstract group-to-plane transport as cited/human mathematics unless a compact reusable Mathlib theorem already exists; Lean checks the coordinate/algebraic compatibility used by the code theorem |

The last row is intentionally human/classical under the series trust standard.
Formalizing Sylow theory, projective involution classification, and the entire
adjoint dictionary solely for this q=13 paper would create a large general
group-theory development with little additional assurance.  The release ledger
will not call that row fully kernel checked.

## What remains a finite certificate

Three finite endpoints are legitimate, but their checkers must be small and
proof producing.

### Sparse rank certificates

Use a common checker for an explicit pivot minor, left inverse, and column
expansion.  It proves rank 42 for the incidence map and rank 36 for the required
relation/Gram maps.  Generated data contains sparse row operations; the generic
proof connects a successful check to `LinearMap.finrank`.  No generic binary
Gaussian elimination runs in a release theorem.

### Stabilizer obstruction records

The weight-ten endpoint contains 37 records, partitioned mathematically as four
\(D_{14}\) line orbits and thirty-three \(D_{28}\) secant-pair orbits.  Each
record stores a small adjacency mask or prefix obstruction.  Lean proves the
orbit-cover and rejection-checker soundness; kernel reduction checks each
bounded record in its own module.  The aggregator contains no search.

### Minimum-layer completeness

The one genuinely nontrivial finite completeness endpoint is the 56-word slice
through a fixed point.  Do not reproduce the current meet-in-the-middle search
in Lean.  Generate four dynamic-programming tables indexed by the mathematical
pencil profiles.  A proved transition checker verifies:

1. the initial state;
2. exact coverage of every choice in the next fibre or secant-pair orbit;
3. syndrome transitions;
4. the empty terminal sets for the first three profiles;
5. equality of the fourth terminal set with the four 14-word orbit slices.

The checker consumes sorted canonical state tables and never materializes all
candidate supports.  The human profile reduction and group transitivity carry
the fixed-point result to all 364 words.  The trust ledger records the profile
reduction as conceptual proof and the table checker as formal certificate.

## Proposed module graph

The release graph should have four layers.

1. **Shared definitions and structural lemmas.** Normalized conic geometry,
   incidence code, moment identities, pair-neighborhood interface, sparse
   certificate soundness, and elementary operator-field algebra.  These modules
   contain no q=13 data and no native evaluation.
2. **Definitions-only q=13 bases.** Coordinates, group generators, relation
   representatives, sparse matrices, orbit parameters, and certificate schemas.
   No theorem imports a search implementation.
3. **Independent bounded leaves.** Rank certificates, 37 weight-ten obstruction
   records, four minimum-profile DP tables, the small octahedral orbit table,
   and any six-representative relation checks.  Each leaf imports only its base
   and the generic checker.
4. **Light theorem aggregators.** Separate distance, minimum-layer,
   reconstruction, operator-field, and ambient-geometry gates, followed by one
   release correspondence gate and one axiom audit.

The release aggregate will not import these superseded namespaces:

- `PassantCodeQ13.WeightTen.IsolatedProfile.*`;
- `PassantCodeQ13.WeightTen.CycleProfile.*`;
- `PassantCodeQ13.MinimumWords.RowUniqueness.Residue*`;
- the triple-concurrence row-uniqueness transport;
- executable 78-square matrix multiplication terminals.

Historical modules may remain in the repository until removal is safe, but
they are outside the public allowlist and release import closure.

## Import and elaboration reductions

- Replace `import Mathlib.Tactic` by the narrow modules for `omega`, `nlinarith`,
  and `ring` after confirming the exact imports by single-file elaboration.
- Keep generated data definitions-only.  Theorems and documentation import the
  data, never the generator implementation.
- Parameterize checks by relation or stabilizer representatives; transport by
  proved equivariance instead of filtering a materialized group image.
- Represent incidence and adjacency rows by fixed finite vectors or bitsets with
  one proved semantic bridge.  Do not repeatedly convert among lists, finsets,
  arrays, and natural-number encodings.
- Prove one generic checker theorem per certificate schema.  Avoid unfolding a
  large finite operation independently in every terminal.
- Shard at module boundaries and keep aggregators free of computation.

## Managed build protocol

No raw `lean`, `lake`, `nix develop`, process-table command, signal command, or
cache-cleaning command is part of this plan.

Before proof work:

1. read `lean/AGENTS.md` and `papers/style-guide.md`;
2. consult the named-expert router and load only the finite-projective-arcs and
   rank-one modular reconstruction dossiers relevant to the packet;
3. confirm the C834-owned paths and that no foreign lane owns a build;
4. use `guarded-lean` only for one changed source file at a time.

Aggregate work uses `lean/scripts/lean-build-queue.py` with the Paper-IV
certificate directory passed as `--lean-root`.  Until telemetry establishes a
Paper-IV profile, every run uses profile `single`, one thread, and the default
low-priority OOM adjustment.  The first recovery run uses cache restoration in
required mode because the local Paper-IV build artifacts were cleaned.  It
builds one definitions/checker packet at a time, then the five light gates, and
finally performs the aggregate trace-only check.  Long runs are detached; their
atomic status is read once after completion or when the user requests status.
They are never replaced by a duplicate build.

The shared `RelativeConicArcs` umbrella is not a C834 exit gate.  C834 validates
only the exact import-only q13 gate and any other lane gates found by the
build-system-owned reverse-import closure.  Regeneration occurs only in a
build-owner window and lands the checker, schema, generated leaves, and green
subtree gate in one commit.

## Build order

1. Restore the paper-local cache through the managed queue; make no source
   change during restoration.
2. Land the narrow-import and definitions-only split using guarded single-file
   elaboration.
3. Land the generic sparse-rank and finite-transition checkers.
4. Replace weight eight and weight ten; remove their obsolete imports from the
   distance gate.
5. Replace row uniqueness and pair-table scans by pair-color algebra.
6. Replace matrix multiplication and automorphism enumeration by intersection
   numbers and anchor equations.
7. Add the minimum-profile DP certificates.
8. Formalize toric parity, operator-field algebra, and coordinate compatibility
   for the adjoint plane proof.
9. Freeze the five packet gates, then the release correspondence gate and axiom
   transcript.
10. Generate the same series surfaces used by the other papers: statement
    identity, claim/trust manifest, formal theorem map, axiom transcript,
    generated-artifact provenance, release allowlist, and aggregate verifier.
11. Run the isolated public-package replay only after the in-tree managed gate
    is trace-current and the referee-facing source review is complete.

## Release acceptance

- Every manuscript theorem clause appears exactly once in the correspondence
  and trust ledgers.
- Every formal claim names an elaborated declaration and its actual axioms.
- No release-facing declaration depends on a native-decision or project-local
  axiom.
- Human and classical rows contain complete proof/citation boundaries and are
  not described as Lean theorems.
- Generated certificates have a mathematical schema, proved checker,
  deterministic generator, source identity, and independent replay.
- The public allowlist excludes operational guides, historical native-search
  modules, task records, build state, and machine-local paths.
- A managed, isolated, clean-checkout release verifier passes before C761 asks
  for publication authority.

## Principal architectural decision

Do not formalize the old computations more aggressively.  Formalize the new
mathematics more directly.  The positive form, line moment, pair-color
reconstruction, intersection algebra, anchor rigidity, conic pencils, and
adjoint polarity are the compression mechanisms.  Lean should check those
mechanisms and a small number of canonical finite records.  The manuscript
should continue to own the classical and structural arguments that would
otherwise require a disproportionate general theory library.
