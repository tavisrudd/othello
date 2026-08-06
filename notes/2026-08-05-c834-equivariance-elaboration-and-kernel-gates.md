# C834 — Equivariance-layer elaboration and three kernel-checked finite gates

**Date:** 2026-08-05
**Lane:** `clebsch`
**Task:** C834 — Paper IV full Lean release closure

## Outcome

The paper package `papers/q13-passant-code/lean-certificates` now elaborates end
to end: `PassantCodeQ13.Gates.Main` and `PassantCodeQ13.Gates.AxiomAudit` both
build under the pinned toolchain, and the axiom audit's terminals all report.
Three defects had to be cleared to reach that state, and three native-evaluation
endpoints were then replaced by kernel reduction.

Commits: `c9b3af49` (elaboration repairs and kernel conversions), `06b22e08`
(module inventory).

## Correction to the previous resume note

The previous round recorded the association-transport packet and the
hidden-field cubic as written but not elaborated, because the build-owner lock
was held by another lane for that whole session. That is no longer accurate and
appears to have been resolved before this session: `PackedRows`, the four
relation-mask modules, the four relation-square modules, the four orbit-mask
modules, `RelationData`, `OrbitS4`, the three dihedral orbit modules, and
`RelationCubic` all probed trace-current and were skipped. The kernel has
accepted that round's mathematics.

The genuinely unelaborated layer was the newer equivariance work.

## Defects found and repaired

**Generated transporter table overran the elaborator recursion depth.**
`PassantCodeQ13/Equivariance/TransporterData.lean` failed at
`pairTransporterIndices`, a single list literal with 78 * 78 entries; a list
literal costs one recursive elaboration step per entry. Repaired in the
generator `generate_transporter_data.py`, which now emits
`set_option maxRecDepth 20000` together with the reason. The regenerated file
differs from its predecessor only by those lines, and the generator's
byte-for-byte `--check` passes, so its exhaustive transitivity self-checks still
hold. The module elaborates in 4.15 s.

**Automorphism triple-orbit proofs could not rewrite through the indexed
action.** `PassantCodeQ13/Automorphisms/TripleOrbit.lean` failed two rewrites in
`matrixAction_bijective` and `matrixAction_preservesRho`. `matrixAction` is an
ordinary definition unfolding to `Fin.ofNat 78 (internalIndex (act M (internalAt
point)))`, and the transport lemma
`SymmetricSquare.internalAt_ofNat_internalIndex` is stated about that
re-indexing, so `rw` could not see the pattern through the definition. Adding
`simp only [matrixAction]` before each rewrite closes both proofs. These are the
relation-preservation and bijectivity leaves that the equivariance layer was
written to replace, so the failure was at the expected seam.

**A gate terminal declared data as a theorem.**
`PassantCodeQ13.Gates.Main.pairOnlyReconstruction` was declared `theorem`, but
its type `RelativeConicArcs.PassantCodeQ13.PairOnlyReconstructionCertificate`
is a structure carrying the field `unaryDegree : ℕ` and therefore lives in
`Type`. The paper package already defines the witness correctly as a definition.
The gate now declares it `def` with the same name, type, and proof term, so
nothing it claims has changed.

## The two decidability instances were load-bearing

`PassantCodeQ13/StructuralUpgrade.lean` carried two uncommitted `Decidable`
instances, for `HasEvenPassantIntersections` and for unique existence over
`PlaneCoordinate`. They read as unused scaffolding, since no proof mentions
them, but they are required: instance search will not unfold a plain
`def : Prop`, so without the stated instance `Decidable
(HasEvenPassantIntersections support)` cannot be synthesized and the module's
own `native_decide` calls do not elaborate. Confirmed directly by a scratch file
that redefines the predicate without the instance and fails to synthesize. The
same argument covers unique existence, `ExistsUnique` being likewise a plain
definition.

## Kernel reduction replacing native evaluation

Stating decidability also makes kernel reduction available, and three theorems
convert, each dropping a declaration-local native-evaluation axiom:

| theorem | domain | kernel time |
|---|---|---|
| `toricSupport_even_passants` | passant lines against twelve-point supports | 6.8 s |
| `toricSupport_cards`         | the 78 internal points                     | 5.7 s |
| `determinantConic_card`      | the 183 plane coordinates                  | 5.6 s |

The gate terminal `Gates.Main.toricMinimumSupports` is now clean as a result.
Across the audit, native-carrying terminals fall from 45 to 41 and clean
terminals rise from 49 to 53, of 94.

**The boundary is measured, not estimated.** Kernel reduction of
`unaryDegree_fiftySix` was killed by the memory guard after 66 s. Its domain is
the 364-member decoded support family, against 78 or 183 elements for the three
that convert. That places pair-only row recovery, the fused color split, and the
two plane-axiom unique-existence theorems out of reach as currently stated; they
would need the packed-mask reformulation the association-transport round used,
not a larger recursion limit. The module header now states this split as the
module's trust boundary.

## Evidence surfaces

`verification/evidence_manifest.json` records were stale for
`generate_transporter_data.py`, `Equivariance/TransporterData.lean`,
`StructuralUpgrade.lean`, and `Gates/Main.lean`; all four are refreshed and
`verify_evidence.py` passes every check. `Gates/AxiomAudit.lean` was already
current, contrary to the previous round's expectation.

`verification/README.md` listed neither the packed-row bridge and generated mask
data, nor the relation and orbit identifications, the cubic, the normalized
index and indexed incidence tables, the orbit data, the equivariance
transporters, or the concurrence and row-uniqueness blocks. It is rebuilt from
the package: every unsharded module is named, and each sharded family is
described by the mathematical partition indexing it. A coverage check confirms
every module in the package is either named or covered by a described family.

## Method note: single-file elaboration on scratch files

`lean/scripts/guarded-lean --root <package> <file>` runs one elaboration under
the same processor, thread, and memory-priority bounds as a real build, against
already-compiled dependency oleans, and refuses when a dependency olean is
missing. It is a smoke test rather than a validation gate, and every result
above was confirmed afterwards by a real queued build.

It changed the economics of this round. Reproducing the triple-orbit failure and
confirming its fix took 2.6 s each, against roughly fourteen minutes for one
real elaboration of `StructuralUpgrade`. The decidability question and all four
kernel-reduction feasibility probes were settled the same way. Scratch files
live under `~/.cache/othello-lean-scratch/`, not `/tmp`, which is tmpfs on this
host and banned for build state.

## Mystery ledger

- **Why the previous round recorded the association-transport packet as
  unelaborated.** Settled as stale rather than wrong: the modules are
  trace-current and their content matches the tracked generators. No evidence
  gap remains, but the resume note misdirected this session's first build.
- **Why the pair-only terminal was ever a `theorem`.** Unexplained. The gate
  cannot have elaborated in that state, so the declaration predates any
  successful build of `Gates.Main` in the paper package. Whether the paper
  package's gate has ever been green before this session is not established by
  anything on disk; the axiom audit's 94 terminals reporting together is, as far
  as the record shows, new.
- **Memory cost of kernel reduction.** `StructuralUpgrade` peaked at 2.67 GB
  after the conversions, against 1.82 GB before. Three small kernel checks
  carrying nearly a gigabyte is more than the domain sizes suggest, and is
  unexplained. It matters because the remaining conversions are blocked by
  memory, so the constant factor, not just the domain size, decides what is
  reachable. Owning successor: whichever task attempts the packed-mask
  reformulation of the support-family checks.

## Next

The remaining native endpoints in this package are concentrated in the
weight-ten profile certificates, the row-uniqueness transport, the automorphism
anchors, the association algebra, and the three support-family checks in the
structural upgrade. The association algebra's three native decisions prove
identities the association-transport packet has already reduced in a parallel
mask presentation, and need only a list identification and one symbolic bridge;
that is the cheapest remaining reduction.
