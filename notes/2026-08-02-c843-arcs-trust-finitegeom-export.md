# C843 — arcs Lean trust and `finitegeom` export closure

**Lane**: `relconic`

**Status:** COMPLETE POSITIVE

**Date:** 2026-08-02

## Result

The human-scale Lean additions used by *Arcs complete outside a prescribed
conic* now have a narrow, independently buildable public trust supplement in
`~/src/lean/finitegeom`.  It follows the Clebsch Paper I package shape:

- one import-only paper gate;
- one machine-readable area with every terminal and expected axiom set;
- one prose trust boundary and one direct axiom audit;
- content-addressed source and target closures; and
- README and provenance entries with guarded replay commands.

The immutable 77-module base arcs package was not rewritten.  The supplement
is a separate 33-module closure rooted at
`RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions`.

## Exact trust boundary

The gate exposes 23 terminals in two groups.

The nine matching-packing terminals prove the one-block leave clique theorem,
completion of a one-block-short maximum-clique packing, the exact partition of
bad concurrence edges and maximum blocks, transfer of matching-packing
deficiency to `scaledDefect`, and the implication from nonexistence of the
exact decomposition to a two-missing-block defect bound.

The fourteen small odd-order terminals check the order-13 and order-17
normalization matrices and conic pullbacks, the three rules-only relative-conic
certificates, the upper bounds

```text
rhoC (ZMod 13) <= 8
rhoC (ZMod 17) <= 9
rhoC (ZMod 19) <= 10
```

and ordinary completeness of the order-19 ten-point witness.

Every terminal has the observed axiom set

```text
[propext, Classical.choice, Quot.sound]
```

and no project-local axiom is permitted.

The exhaustive lower classifications, and hence the exact equalities at
orders 13, 17, and 19, remain external computations.  No Lean declaration in
the supplement claims them.  The Korchmaros--Nagy--Szonyi priority citation,
the proposed `(k,n)` generalization, the order-11 affine search, the proposed
classification of realizable matching designs, and the coding-theory
reconstruction audit are outside this formal boundary.

## Stable public names

The pre-existing witness modules encoded the internal identifier `C637` in
their filenames, namespaces, and public declarations.  Referee-facing Lean
rules prohibit exporting those names.  C843 therefore made a compatibility
migration to

```text
RelativeConicArcs.SmallOddRelativeConicWitnessData
RelativeConicArcs.SmallOddRelativeConicWitnesses
RelativeConicArcs.Gates.SmallOddRelativeConicWitnesses
```

and their coordinate-partitioned leaf modules.  The data and proofs are the
same; the new modules add self-contained headers and docstrings.  The combined
paper gate imports only the stable API.  The old names remain in the monorepo
for compatibility and are explicitly classified as outside the paper-facing
extraction closure.

The sixteen newly shipped mathematical source modules contain 77 public
declarations, all with adjacent docstrings.  The full 33-module transitive
closure still contains 166 inherited public declarations without adjacent
docstrings in previously shipped shared infrastructure.  C843 did not edit
those foreign/base modules.  This is documentation debt under the newest
referee-facing standard, not an axiom, build, terminal-coverage, or source
provenance gap; a blanket claim that the entire inherited closure meets the
new docstring standard would be false.

## Monorepo authority

The authoritative mathematical source state is commit
`29c8946c9eb017fc79dc3c63dc58f350b54cd29a`.  It contains:

- the stable odd-order witness API and dedicated gate;
- `RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions`;
- the complete 23-terminal registration in
  `lean/trust/areas/relconic.toml`;
- explicit informational classification of the superseded component gates;
  and
- the matching-packing theorem-map entry and stable witness names in
  `lean/RelativeConicArcs/TRUST.md`.

The extracted facts were added at commit
`92f8f04113cca73738d4b207f48537c3fbb707ff`.  The artifact SHA-256 is

```text
72dcf074ec189359478c4a747b9bfa462a95725c18efe321e36ce1deaf8a654b  lean/trust/facts/RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions.json
```

It records the exact 33-module closure and all 23 terminal axiom sets, with no
project-local axiom.  A post-extraction scoped audit reports no error for the
supplement; its only matching finding is the intentional informational
exclusion of the superseded `C637Witness**` compatibility modules.

The broad `relconic` trust portfolio has unrelated pre-existing missing facts,
unanchored external inputs, unreachable modules, and build-system-owned stale
generated regions.  C843 did not claim or attempt to repair that cross-lane
portfolio.

## Standalone export

The public forward commit is
`0b3f37d264f54b52e6c703a75e2704a3f9cbe4b4` in
`~/src/lean/finitegeom`.  It adds:

- the seventeen supplement source/gate modules;
- `trust/areas/arcs_complete_outside_conic_additions.toml`;
- `trust/ARCS_COMPLETE_OUTSIDE_CONIC_ADDITIONS.md`;
- `trust/ArcsCompleteOutsideConicAdditionsAxiomAudit.lean`;
- source and target content manifests;
- portfolio and explicit Lake-root registration; and
- README and release-provenance entries.

The source and target manifests each contain 33 modules.  Their hashes are:

```text
c807c34bbda3b3bc0eee7b34c0849f0609e1ca0321377bec2da92029323de132  trust/source-manifests/arcs_complete_outside_conic_additions.json
c9c044b851c1e46cd9a8a0ad990b0c5c6eea16cc49c47652385ad430f7d188af  trust/manifests/arcs_complete_outside_conic_additions.json
```

All source-manifest hashes reproduce from the recorded monorepo commit.  All
target-manifest hashes reproduce from the standalone commit.  The only source
and target module whose bytes differ is
`ProjectiveCap.Sym2ConicBridge`; the target retains the previously reviewed
removal of private workflow prose, with no declaration change.  No generated
q16 transition, row, leaf, step-book, or certificate module occurs in the
supplement closure.

## Validation

The authoritative source gate passed at the recorded source bytes.  The first
stable-witness build took 6:36 and peaked at 9,319,468 kB; the combined gate
then built in 0:31 with a 1,663,796 kB peak.

The standalone gate built from its own source tree in 7:19 with a 9,409,160 kB
peak.  The standalone axiom audit elaborated in 17 seconds and matched all 23
manifest entries.  A post-commit exact-target replay reported the gate current
and passed the trace-only aggregate.

The deterministic structural checks also established:

- gate, audit, and TOML terminal lists are identical and ordered identically;
- source and target manifest hashes match every listed file;
- the source/target difference set is exactly
  `ProjectiveCap.Sym2ConicBridge`;
- the generated-q16 closure check is empty; and
- the public 33-module closure contains no private task, lane, agent, session,
  internal-note, or machine-local-path reference.

The final clean detached extraction independently rebuilt the source gate in
7:04 with a 10,354,392 kB peak, generated the facts artifact, and verified
closure size 33, terminal count 23, exact expected axioms for all terminals,
and zero project axioms.  The current monorepo bytes of all 33 source modules
still reproduce the content-addressed source manifest.

## Replay

From the monorepo root:

```text
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions \
  --profile single --threads 1 --cores 20-23

python3 lean/scripts/lean-trust-extract.py run \
  --area relconic \
  --unit RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions
```

For the public package, through the canonical guarded entry points:

```text
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions \
  --lean-root /home/tavis/src/lean/finitegeom \
  --profile single --threads 1 --cores 20-23

lean/scripts/guarded-lean \
  --root /home/tavis/src/lean/finitegeom \
  trust/ArcsCompleteOutsideConicAdditionsAxiomAudit.lean
```

No incidental mathematical lead was found: the stable-name migration,
provenance split, and inherited documentation audit were direct C843
deliverables, so the discovery companion receives no entry.
