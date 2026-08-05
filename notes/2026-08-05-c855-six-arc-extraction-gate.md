# C855 — a declared extraction gate over the six-arc concurrence development

**Date:** 2026-08-05
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist section "Replace manuscript-relative and false-strength API names",
final bullet.

## What the gap was

The order-eleven six-arc concurrence development proves the two statements that retired the Paper I
Dye axioms: the ten-point bound on the points off a six-arc lying on three of its secants, and the
identification of an order-eleven six-arc attaining that bound with the displayed witness.  No
declared extraction unit of the `relconic` area imported any of its modules.  The area's extraction
units are what the companion export carries to the base library, so the proofs had no route
downstream, and the pinned order-eleven certificate package — whose trust fact still lists
`RelativeConicArcs.ClebschDye.dye1991_brianchon_bound` and
`RelativeConicArcs.ClebschDye.dye1991_equality_classification` as axioms — would have kept them
indefinitely.

## What was added

`lean/RelativeConicArcs/SixArcConcurrenceSpine.lean` is an import-only module over
`SixArcConcurrenceBound`, `SixArcChordMatchings`, `SixArcOneFactorization`, `SixArcHexagonalOrder`,
`SixArcGoldenNormalForm`, and `Q11GoldenHexagonWitness`.  Its header states the two endpoints of the
development, the four stages between them, the Dye pinpoints for both endpoints, and the trust
boundary: every terminal is a kernel proof and the closure contains no generated certificate, native
evaluation, imported data, user axiom, or admitted proof.

`lean/trust/areas/relconic.toml` declares it as a gate with eleven terminals — the per-secant and
ten-point bounds, the chord-pairing bijection, the three one-factorization counts, the hexagonal
order, the golden normal form of a hexagon with four concurrent chord triples, the golden frame and
golden root of an arc attaining the bound, and the order-eleven identification — each with a
matching `[[terminal]]` entry.  `lean/RelativeConicArcs/TRUST.md` gains the corresponding
theorem-map row.

The gate's import closure reaches ten modules that no unit reached before:
`SixArcConcurrence`, `SixArcConcurrenceBound`, `SixArcChordMatchings`, `SixArcOneFactorization`,
`SixArcHexagonalOrder`, `SixArcGoldenNormalForm`, `GoldenHexagonNormalForm`,
`Q11GoldenHexagonWitness`, `FrameCoordinates`, and `QuadrangleDiagonal`.

## Validation

The module elaborates: `lean/scripts/lean-build-queue.py build
RelativeConicArcs.SixArcConcurrenceSpine --cores 20-23` reports it built in 1:47 wall at a peak of
about 2.5 GB.  The same run ended in the `refused` state, because a foreign Lean build was live when
its final trace-only aggregate check ran; that refusal is about the tree's quiet state, not about
the target, which the envelope records as built.

`lean/scripts/lean-trust-spine.py check --area relconic` drops from 124 to 114
`module-unreached-by-units` findings, exactly the ten modules above, and reports no new finding kind.
The count of `gate-terminal-undeclared` findings is unchanged, so every terminal of the new gate
carries a declared expected axiom set.

The facts artifact `lean/trust/facts/RelativeConicArcs.SixArcConcurrenceSpine.json` is extracted and
committed.  It records a 26-module closure and eleven terminals, every one of them carrying exactly
`Classical.choice`, `Quot.sound`, and `propext`, and no project axiom.  The area check reports no
axiom mismatch and no absent terminal, so the eleven declared axiom sets agree with Lean.

## What is not done

The export cannot run yet, for a reason in the base library rather than here.  With the facts
artifact in place, `plan` gets through the configuration, the fact, the terminal agreement, and the
closure, and then refuses on the base's own state: `TARGET_MANIFEST.json` at the base HEAD disagrees
with the base tree in four entries.  `ProjectiveCap/Sym2ConicBridge.lean` has a digest mismatch,
and `RelativeConicArcs/Q16CertificateLevels.lean`, `RelativeConicArcs/Q16Reduction.lean`, and
`RelativeConicArcs/Q16StepKernel.lean` are listed as sources but absent from the tree.  The base
worktree is clean, so the inconsistency is in the commit.  This blocks every companion export, not
this one, and repairing it belongs to the base library's owner.

Seven further modules of the wider order-eleven rigidity development remain reached by no unit:
`SixArcDefectBridge`, `SixArcDegenerateConicExclusion`, `SixArcPerspectivity`,
`OddSixArcAffinePrism`, `OddSixArcPrismExtraction`, `Q11RigiditySpine`, and
`Q11CodeRigidityBridge`.  They are consumers of the concurrence results rather than inputs to them,
and the last four import the `Q11Dye`/`Clebsch` trees whose naming and packaging are coordinated
with the order-eleven certificate package.  They are left as undeclared reachability errors rather
than covered by a declared exclusion, so they stay visible.

## The export boundary, and why it is its own

`lean/trust/export/clebsch_six_arc_concurrence.toml` gives the gate a companion boundary of its own
rather than adding it to the golden-orientation boundary of the Clebsch support cubic.  Three
reasons, in the order they decided it.

The orientation boundary's published correspondence text states that that companion does not prove
the ten-point bound or the equality classification.  Widening it would mean editing what an already
exported and manuscript-pinned boundary claims, which is a heavier act than publishing a second
boundary beside it.

Each export configuration names exactly one gate and derives its closure, terminal list, and axiom
audit from that gate.  Widening therefore means either repointing the orientation configuration at a
different gate, which changes that boundary's identity anyway, or importing the six-arc modules into
`SupportOrientationSpine`, which fuses two developments that share no declaration: plane incidence
geometry of six points and their fifteen chords on one side, the antipodal cover, determinant
pencil, and singular locus of a cubic threefold on the other.

The consumer is the order-eleven certificate package, which pins the base library by commit and
manifest digest.  A boundary carrying exactly the concurrence development lets that package pin what
it consumes, and makes its re-pin show the two axioms being replaced by the theorems that displace
them.

The configuration's `plan` mode loads, validates the area name and gate, passes the private-
reference audit on all its prose, and agrees with the registry on the eleven terminals and the
26-module closure.  It stops only at the base-manifest inconsistency recorded below.

Both configurations now describe the split.  The orientation configuration's correspondence text
names the six-arc boundary as the place the bound and classification are proved, so the two must be
exported in the same round for the base library to be self-consistent: adopting only the six-arc
boundary would leave the orientation statement in the base still disclaiming results that the base
then carries.

## The base manifest repair

`TARGET_MANIFEST.json` in the base library described a tree that had moved under it.  Three modules,
`RelativeConicArcs/Q16CertificateLevels.lean`, `RelativeConicArcs/Q16Reduction.lean`, and
`RelativeConicArcs/Q16StepKernel.lean`, were deleted when the order-16 certificate internals moved
into their own package, and `ProjectiveCap/Sym2ConicBridge.lean` gained an import; neither change
updated the manifest.  The repair drops the three entries, refreshes the bridge's recorded size and
digest, and retargets the declared module count in `README.md` and `PROVENANCE.md` from 277 to 274.
It adds no entry, so it makes no claim about the 29 tracked sources the manifest has never listed.
The bytes are written through the companion exporter's own canonicalization, so they are what an
export would produce.  With that in place the export `plan` runs: 26 closure modules, base 274
against candidate 286.

A related condition surfaced and was deliberately left alone.  Six of the ten per-area manifests
under `trust/manifests/` already disagree with the base tree — `clebsch_rigidity_human.json` in 17
of its 27 entries — because shared modules moved forward under them in earlier exports.  Those
manifests read as historical records of what each boundary carried when it was adopted, and
refreshing their digests would assert a review that did not happen.  Whether they are snapshots or
live claims is a question for their owner.

## The export round

Both boundaries were exported against the repaired base and adopted there as ordinary forward
commits; nothing was pushed.  The six-arc delta added twelve modules and the boundary's statement,
audit, registry, and manifests, and moved four shared modules — `ProjectiveCap/Grid.lean`,
`ProjectiveCap/Sym2ConicBridge.lean`, `RelativeConicArcs/Certificate.lean`, and
`RelativeConicArcs/Conic.lean` — forward to the versions its closure needs.  Its gate builds in the
base and the exported audit elaborates to eleven terminals, each on `propext`, `Classical.choice`,
and `Quot.sound`.

The orientation boundary was re-exported in the same round so its corrected correspondence text
reaches the base.  Because the renamed modules arrive under their new names while the base still
carried the eleven manuscript-named ones, the superseded files, their library roots, and their
manifest entries were removed in a separate preceding commit, so the two sets never coexist.  The
refreshed gate builds in the base at 24 audited terminals, all on the same three axioms.

One check remains outstanding.  A build of the other paper-facing base gates — both Arcs gates, the
Clebsch rigidity human gate, the order-eleven module, the six-arc defect bridge, and the orientation
and passages gates — is meant to establish that the four shared modules break nothing that was
previously green.  It has not completed: the shared tree is held by another build, and the queued
run refused after its quiet wait.  Until it passes, the adoption is unverified beyond the two gates
named above.

## A pre-existing failure in the base

The base library does not currently pass its own published replay, for a reason unrelated to this
work.  `ProjectiveCap.Binary` and `ProjectiveCap.EllipticMirror`, both named in the base README's
replay recipe, fail in `ProjectiveCap/Binary.lean` and `ProjectiveCap/Mirror.lean`: they apply
`InitialPStatement` to a field argument, while the only definition the base carries, in
`CapGame/Affine.lean`, takes none.  The version they are written against is in
`ProjectiveCap/ProjectiveCapGame.lean`, which the base has never carried.  The failures reproduce
with every commit of this round reverted, so they predate it.  This is the same root cause as the
manifest drift: direct edits to the base that bypassed the export path, leaving a half-migrated
projective-cap layer.  Repairing it means exporting that layer forward as its own reviewed step, and
it belongs to the projective-cap material rather than to Paper I.

## What the base library and the package still need

The base library `finitegeom` carries `RelativeConicArcs.Q11DyeAxioms` as a human module stating the
two order-eleven consequences as explicit axioms, and `trust/CLEBSCH_RIGIDITY_HUMAN.md` documents it
that way.  The exported closure here does not include that module: it supplies the general theorems
the specializations need.  Replacing the base's axioms by proofs, and correcting the two base
documents that describe them as cited external inputs, is forward work in the base under the package
re-pin, not part of this export.
