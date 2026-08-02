# C753 — Paper I Lean proof-spine correspondence closure

**Lane:** `clebsch`

**Status:** active; C752 is complete and its implementation interface is
frozen.  The finite prose-source repairs, R1--R4, and O1--O4 are complete;
continue with O5--O8, which must remain packet-gated.

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
prose bundle was committed at `12031d32`.  R2 is the next formal packet.

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
