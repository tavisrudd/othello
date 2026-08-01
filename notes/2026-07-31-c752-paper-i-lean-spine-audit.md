# C752 — Paper I Lean proof-spine correspondence audit

**Status:** active read-only audit.

## Frozen inputs

- Final C751 source history: `66484219`, `283e3509`.
- Referee-approved source blob: `7ec1f4c1aa78f58729039ae4bd18ab4ac1c15662`.
- Paper-I certificate repository: `42ab1a2db30178cf23aa8393d886c63ded24bfbd`.
- Pinned `finitegeom` dependency: `ef6317c5e1a348a91a1928104f9c8e1831bfb03d`.
- Pinned mathlib: `571b8a8e54219b4d393f75f4b8653fac08197fcc`.
- Paper terminal gate: `RelativeConicArcs.Gates.ClebschRigidityTrust`.

The audit credits a Lean declaration as corresponding to a manuscript step
only when its definitions and causal mechanism agree, or when an explicit
bridge theorem connects the two mechanisms.

## First-pass spine verdict

| Manuscript stage | Current formal surface | Initial verdict |
|---|---|---|
| Six-arc chord moments and `|U|+c=22` over `F_11` | `SixArcDefectBridge.sixArc_uncovered_add_brianchon_card` derives the equality from the first and second secant moments and the index bound `r<=3` | Same mechanism, specialized exactly to `PG(2,11)` |
| Universal chord-defect identity | `ClebschChordDefect.chordDefect_identity_of_moments` proves only the algebraic elimination from three supplied moment/partition equations | Partial bridge; the universal geometric hypotheses are not assembled here |
| Odd six-arc line bound `|l intersect U| <= q-5` | `OddSixArcLineBound.uncoveredOnLine_card_le_order_sub_five` assumes the disjoint-line equality case is impossible | Human-only affine seam remains; the scalar contradiction alone does not construct the triangular-prism bridge |
| Exclusion of a degenerate containing conic | Not imported or stated by `ClebschRigidityTrust` | Gap relative to manuscript implication (i) to (ii) |
| Twelve-point upper/lower-bound trap inside a nonsingular conic | `Q11DyeConsequences.sixArc_cards_of_uncovered_subset_conic` combines the proved defect identity, Dye's bound, and the twelve-point conic cardinality | Same mechanism |
| Equality to the Clebsch hexagon | `Q11DyeAxioms.dye1991_equality_classification` and `isClebschHexagon_of_uncovered_subset_conic` | Exact declared classical seam, specialized to `PG(2,11)` |
| Associated conic, code equivalence, decoder, and counts | `Q11Coding`, `Q11SemanticLeaders`, `Q11DecodingSynthesis`, and the q11 certificate modules | Mostly exact finite/kernel checks of the displayed witness; definition bridges and causal ordering still under audit |
| `A5/C5 -> A5/D5`, self-paired orbitals, signed pentagon, and `B^2=5I` | No Paper-I Lean terminal; the separate `ClebschOrientationMechanisms` gate contains only generic involution splitting and the Petersen pair-sum eigenspace | Human-only at the paper-specific level |
| Holonomy, switching, determinant pencil, trace-dual complement, cubic, nodes, and integral commutant | No corresponding Paper-I Lean declarations found in either terminal gate | Human-only |

## Material findings already settled

1. The current rigidity gate proves the nonsingular-conic containment
   implication, not the manuscript theorem whose first condition permits a
   degenerate conic.  The manuscript's line-bound route is therefore not yet
   represented by the gate.
2. `OddSixArcLineBound` is unusually honest about the missing step: its final
   theorem takes `hfiveImpossible` as an argument.  C753 must formalize the
   affine triangular-prism construction, not merely reuse
   `triangularPrism_parallelism_contradiction` and call the line bound closed.
3. The q11 defect/equality trap is genuinely the same proof as the manuscript:
   the first and second secant moments give `|U|+c=22`, Dye gives `c<=10`, and
   nonsingular-conic containment gives the opposite cardinal bound.
4. The two Dye assumptions are exposed by name and downstream axiom audits.
   They are specialized to `PG(2,11)`, so the manuscript's local field
   hypotheses are discharged by specialization rather than represented as a
   general theorem.
5. The orientation trust boundary is accurately disclosed in the paper
   manifest and certificate README: exact Python replay plus human proof, with
   no claim that the Paper-I Lean gate formalizes orientation.  This is honest
   release prose, but it confirms that C753 needs a new paper-specific formal
   spine rather than a renaming pass.

## Initial C753 dependency order

1. Close the affine triangular-prism seam over odd Desarguesian planes and
   instantiate the complete six-arc line bound at `F_11`.
2. Formalize the classification/cardinality bridge for degenerate plane
   conics and prove the manuscript's possibly-degenerate containment theorem.
3. Package the q11 defect, line, twelve-point, and Dye stages into one terminal
   theorem whose implication graph matches the manuscript.
4. Freeze exact bridges from projective points and uncovered loci to syndrome
   directions, cosets, leaders, and the displayed code before changing the
   orientation surface.
5. Build the orientation spine in dependency-sized packets: coset cover and
   orbitals; pentagon and golden operator; holonomy and switching; determinant
   pencil; representation/trace complement; cubic geometry and commutant.
6. Only then extend the Paper-I gate, axiom audit, trust manifest, generated
   repository, and standalone release root.

## Prose and naming audit — open checklist

The transitive referee-facing closure includes the certificate repository,
its pinned `finitegeom` dependency, generators, manifests, axiom output, and
paper verification metadata.  Module headers and public docstrings examined
so far are strongest at the two trust seams: `Q11DyeAxioms`,
`SixArcDefectBridge`, `OddSixArcLineBound`, and both import gates state their
residual hypotheses plainly.  The full generated/private comment census and
artifact-reference check remains in progress; no prose repair is authorized
under C752.
