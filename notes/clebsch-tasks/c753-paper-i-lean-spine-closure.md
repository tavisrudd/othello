# C753 — Paper I Lean proof-spine correspondence closure

**Lane:** `clebsch`

**Status:** complete.  R1--R4 and O1--O8 are formalized, the exact axiom and
conditional-interface boundary is published, and the authoritative q11,
paper, and standalone release replays are green.

## Completion record (2026-08-03)

O8 is complete in
`RelativeConicArcs/PaperIOrientationCommutant.lean`.  The signed coset action
is transported into conference gauge, golden equivariance is kernel checked,
the reverse rational containment and integral diagonal/off-diagonal descent
are proved, and only the explicit classical conjugate `3+3'` Schur--Galois
interface remains conditional.  The aggregate orientation spine and Paper-I
trust gate print only Lean's ordinary logical axioms, except for the two named
Dye inputs on the rigidity branch.

The reusable base is committed at
`570086982b26075a71a331a81bb1b519e9a27e7f`.  The q11 certificate source is
committed at `81bae5e0eb02c26992f21b71808ef74a22e3b406`, and its 121-module
content manifest is sealed at `09d8e174880e7370966da788da3c5d303df8af4f`.
The clean standalone gate passed incrementally at
`~/.cache/othello-lean-build/run-20260803-012007-a6ce4d0c` after two
package-boundary repairs: the byte-identical `Q11DyeAxioms` duplicate was
removed in favor of the pinned base module, and the omitted q11 gateway
bridge was added to the q11 package.

The generated row, matrix, support, and fixed-point shards are now explicitly
classified as internal finite leaves of a redundant formal cross-check, not
as premises of the paper's structural orbit or decoder proofs.  Their reviewed
module headers and generator provenance are therefore the public explanatory
boundary; declaration-by-declaration prose on generated leaves is not a
release requirement.  The generator staleness check passes.

The authoritative 26-check release replay is sealed at `81163be6`; the
standalone Paper-I repository is synchronized at `58900f0`, its 58-file
export manifest verifies against authoritative commit `81163be6`, and the
same 26-check clean replay passes there.

## Current implementation state

R1 is complete at `c9dd5421`.  The committed projective normalization,
one-factorization extraction, and affine parallelism modules now feed the
terminal theorem
`RelativeConicArcs.OddSixArcPrismExtraction.sixArc_uncoveredOnLine_card_le_order_sub_five`.
Its guarded elaboration is green, and its printed axiom set contains only
`propext`, `Classical.choice`, and `Quot.sound`.

The finite source-owned prose repairs are committed.  The q11 generator emits
the correct repository-relative banner, and regeneration changed exactly 55
arithmetic leaves and 11 aggregators.  The misleading “reflected” terminology,
“opaque certificates” wording, and the status-language sentence in
`SmallKChordMoments.lean` are repaired.  `SmallKChordMoments.lean` elaborates
cleanly.  The serialized replacement run at
`~/.cache/othello-lean-build/run-20260801-211243-49eee223` finished successfully:
it built `Q11A5PointOrbitsData.lean` in 42 seconds at a measured 3,456,068 KiB
peak, built `Q11A5PointOrbits.lean` in 19 minutes 39 seconds at a measured
5,675,148 KiB peak, and passed the trace-only aggregate gate.  The reviewed q11
prose bundle was committed at `12031d32`.

R2 and R3 are complete at `04e734de`.  The final R2 conic-type interface carries
an actual nonzero `QuadraticForm`, its exact projective zero locus, and the
nonsingular-or-two-lines alternative; the resulting upper bound is proved from
R1 rather than a coordinate census.  R3 then applies Dye's lower bound, forces
the twelve-point equality, and only at that causal endpoint invokes the named
equality classification.  The serialized build at
`~/.cache/othello-lean-build/run-20260802-043209-83831e3c` built both owning
modules and passed its aggregate no-build gate.  The R3 terminal's printed
axiom set is exactly `propext`, `Classical.choice`, `Quot.sound`,
`dye1991_brianchon_bound`, and `dye1991_equality_classification`.  R4 is complete
at `a903dd2b`.  `RelativeConicArcs/Q11CodeRigidityBridge.lean` reuses the proved
canonical ray normalization to construct the `Fin 133`--projective-point
equivalence and adds symbolic uncovered/distance-three, monomial-kernel,
affine-coset, and minimum-leader bridges.  The strengthened terminal also
records the explicit transported-column equation, rather than leaving its row
equivalence existentially unused.  The owning build and aggregate gate passed
in `~/.cache/othello-lean-build/run-20260802-052520-f9e2ac88`; the printed axiom
set is exactly `propext`, `Classical.choice`, `Quot.sound`,
`dye1991_brianchon_bound`, and `dye1991_equality_classification`.

O1--O4 are complete.  O1 constructs the `A5/C5 → A5/D5` antipodal cover and
the two self-paired five-valent orbitals in
`RelativeConicArcs/PaperIOrientationCover.lean` (`716fe27a`).  O2 derives the
signed orbital matrix and golden square from the orbital pentagon in
`RelativeConicArcs/PaperIOrientationPentagon.lean` (`f22175ff`).  O3 proves
switching-invariant triangle holonomy, the support cubic, and the vanishing
lower signed moments in `RelativeConicArcs/PaperIOrientationHolonomy.lean`
(`50ff55ef`).  O4 proves the full diagonal determinant pencil and its odd part
in `RelativeConicArcs/PaperIOrientationDeterminant.lean` (`8378023a`).  Its
determinant coefficients come from multilinearity, the conference inverse,
Schur--Jacobi complementation, and a reducible ten-positive-triple evaluator;
no large determinant certificate is used.  The clean owning build and
trace-only aggregate gate passed at
`~/.cache/othello-lean-build/run-20260802-183008-bed33545`.  The two terminal
theorems print exactly `propext`, `Classical.choice`, and `Quot.sound`.

O5 is complete at `ae1ac210`.  The two displayed golden eigenspaces,
cross-golden compression, translation invariance, exact one-dimensional kernel,
five-dimensional image, perfect trace pairing, and four-dimensional trace
annihilator are formalized in
`RelativeConicArcs/PaperIOrientationTraceDual.lean`.  Its determinant is the
negative support cubic.  The Hassett--Tschinkel Proposition 10 implication is
an explicitly supplied proposition-level hypothesis with a pinpoint DOI
citation, not a global axiom.  The clean owning build and trace-only aggregate
gate passed at
`~/.cache/othello-lean-build/run-20260802-184426-cd072658`; the O5 terminals
print exactly `propext`, `Classical.choice`, and `Quot.sound`, while the abstract
citation-interface application itself prints no axioms.

O6 is complete at `fa5cdaee`.  The exact six-line singular cone is exposed in
`RelativeConicArcs/PaperIOrientationNodes.lean`.  For node type, the formal
spine now derives `Mu=0`, `M²=5I-uuᵀ`, the one-dimensional kernel, and rank four
from O4's structural rational signed-orbital square; the six-case chart
determinant is retained only as the normalization bridge to the ordinary-node
criterion.  This removes the draft's native conference-square dependency.  The
clean owning build and trace-only aggregate gate passed at
`~/.cache/othello-lean-build/run-20260802-190643-7d9c0ba5`, with no warnings;
all O6 terminals print exactly `propext`, `Classical.choice`, and `Quot.sound`.

O7 is complete in
`RelativeConicArcs/PaperIOrientationSymmetryCore.lean`,
`RelativeConicArcs/PaperIOrientationSymmetryGenerators.lean`, and
`RelativeConicArcs/PaperIOrientationSymmetry.lean`.  The support two-graph's
five distinguished perfect matchings give a faithful order-120 normalizer
action on five letters.  Explicit frame elements inducing a three-cycle and a
five-cycle generate `A₅` by element orders, Lagrange's theorem, and simplicity;
one odd element reverses every support sign.  Six distinct cubic-line cosets
bound the full line stabilizer by order 120, so it equals the matching
normalizer.  This replaces the rejected permutation-enumeration leaves with a
structural generation-and-index proof.  The clean serialized replay at
`~/.cache/othello-lean-build/run-20260802-205925-01ef7068` built all three
modules and passed the trace-only aggregate gate.  The O7 terminals print
exactly `propext`, `Classical.choice`, and `Quot.sound`.

The authoritative Paper-I proof now exposes the same O7 mechanism rather than
summarizing the stabilizer as a computation: the five distinguished matchings,
faithful five-letter normalizer action, explicit even generators, odd
orientation reverser, and six cubic-line cosets give the displayed
`A₅ \subset S₅` boundary.  The Paper-I trust gate imports the O7 aggregate and
prints the five public symmetry terminals; the axiom audit, statement identity,
and nineteen-row trust manifest have been regenerated.  The guarded trust-gate
replay at `~/.cache/othello-lean-build/run-20260802-211544-6ac6c934` and the
Lean-root-dependent manifest verifier are green.  The main and companion PDFs
remain warning-free at 21 and 12 pages.  This reconciliation claims nothing
about O8, the integral commutant, the final release-output certificate, or the
standalone replay.

The R2/R3 implementation must follow the manuscript's actual order.  A
degenerate containing quadratic first gives the upper bound `|U(A)| ≤ 12`
from a two-line rational cover and R1.  Dye's lower bound then forces equality
and identifies the arc; only afterward does the associated nonsingular conic
and the Bézout comparison exclude degeneracy of the original quadratic.  Thus
R2 owns a reviewed classical conic-type interface and the degenerate upper
bound, while R3 owns the two-branch rigidity terminal and the downstream
nonsingularity corollary.  Do not encode the stronger nonsingularity conclusion
before the Dye equality step.

The full-module prose pass found one additional source-owned defect in
`Q11A5PointOrbitsData.lean`: its two references to
`check_code_automorphisms.py` resolve only in the paper tree, not in the
standalone Lean artifact.  Remove those reverse provenance references and
describe the normalized matrix data by the kernel-checked semantics actually
shipped with the module.  The prism transitive closure also needs timeless
line-bound wording and docstrings on the public cross-module helpers before R1
is referee-ready; these are prose repairs, not theorem changes.

The same no-grandfathering pass applies to the q11 row leaves.  The regenerated
action rows and the pre-existing matrix, support, and fixed-point shards export
cross-module certificate declarations without declaration-level mathematical
docstrings.  Their module headers state the finite mechanism correctly, but the
public row declarations still need concise domain, conclusion, and kernel-check
descriptions in their owning sources before the transitive artifact prose gate
can close.

## Objective

Implement the frozen C752 interface so the Paper I Lean development follows
the same causal spine as the final human proofs, with exact bridges at every
definition and trust boundary.

## Work package

The exact declaration names, files, mechanisms, and gate order are frozen in
`notes/2026-07-31-c752-paper-i-lean-spine-audit.md`, under “Frozen C753
rigidity interface” and “Frozen C753 orientation packets.”  The implementation
order is prose-source repairs, R1--R4, O1--O8, aggregate gate, cold review, and
release synchronization.

1. Formalize the dependency-ordered same-mechanism lemmas frozen by C752;
   do not redesign the interface inside implementation.
2. Prefer structural objects used in the paper---moments, line incidence,
   orbitals, the signed pentagon, switching invariants, principal minors, and
   trace pairings---over opaque coordinate enumeration.
3. For Dye and Hassett--Tschinkel, formalize the exact conditional interfaces
   and their paper-owned deductions unless C752 explicitly admits a bounded
   proof of the imported theorem itself.
4. Prove every paper/Lean definition bridge and normalization lemma named by
   C752. Preserve projective, monomial, and code equivalence distinctions.
5. Repair every C752 prose or naming defect in the owning human source,
   generator, template, schema, or diagnostic. Do not hand-edit generated
   output. Give scholarly-public declarations self-contained mathematical
   docstrings; make headers and comments agree with elaborated statements and
   exact trust routes; remove internal workflow references and stale status
   prose; and give external inputs stable pinpoint citations at the level used.
6. Re-audit the entire touched module and its project-owned transitive
   verification closure, not only changed lines, for mathematical prose,
   names, generated banners, artifact semantics, and trust disclosures.
7. Update the paper claim map, statement identity, trust manifest, axiom audit,
   paper-local replay, and q11 gate only to the strength actually achieved.
8. Obtain an independent cold review that compares the Lean declaration graph
   and referee-facing prose with the human proof graph, and reports any
   parallel-but-unbridged theorem or misleading comment.
9. Synchronize the authoritative paper and standalone mirror only after the
   formal gate and correspondence review are green.

## Acceptance

Every C752 target is closed by a same-mechanism theorem or an exact reviewed
conditional interface. The final claim map exposes all residual axioms and
published inputs, and the human and Lean dependency graphs commute at every
language change. The guarded q11 Lean gate, axiom audit, paper aggregate,
warning-free PDFs, and standalone replay are green. The complete
referee-facing Lean closure is self-contained, mathematically accurate, free
of internal workflow prose, and generated from reviewed owning sources.

## Boundaries

Do not replace a requested structural bridge by a finite endpoint check, alter
the frozen manuscript theorem surface, weaken validation, absorb Paper II or
III, or formalize broad external algebraic geometry without an explicit scope
decision from C752.
