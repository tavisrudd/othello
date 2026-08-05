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

## What is not done

The facts artifact `lean/trust/facts/RelativeConicArcs.SixArcConcurrenceSpine.json` does not exist
yet, so the check reports one further `facts-missing` finding against the new unit and the eleven
declared axiom sets are unconfirmed.  `lean/scripts/lean-trust-extract.py run` refuses while the
Lean worktree carries another lane's uncommitted work — currently
`lean/RelativeConicArcs/GoldenCommutatorDeterminant.lean` — because an extraction taken then would
describe a tree that exists at no commit.  The extraction is one command in the next quiet window,
and the declared axiom sets stand or fall by it; until then the missing artifact is itself the
error, so nothing reads green on unverified evidence.

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

The configuration's `plan` mode loads, validates the area name and gate, and passes the private-
reference audit on all its prose; it stops exactly at the missing facts artifact, so the
configuration is checked as far as the extraction gap allows.

Both configurations now describe the split.  The orientation configuration's correspondence text
names the six-arc boundary as the place the bound and classification are proved, so the two must be
exported in the same round for the base library to be self-consistent: adopting only the six-arc
boundary would leave the orientation statement in the base still disclaiming results that the base
then carries.

## What the base library and the package still need

The base library `finitegeom` carries `RelativeConicArcs.Q11DyeAxioms` as a human module stating the
two order-eleven consequences as explicit axioms, and `trust/CLEBSCH_RIGIDITY_HUMAN.md` documents it
that way.  The exported closure here does not include that module: it supplies the general theorems
the specializations need.  Replacing the base's axioms by proofs, and correcting the two base
documents that describe them as cited external inputs, is forward work in the base under the package
re-pin, not part of this export.
