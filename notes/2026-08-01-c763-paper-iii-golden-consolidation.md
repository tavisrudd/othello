# C763 — Paper III Golden-core consolidation

**Lane:** `clebsch`

**Status:** complete

## Result

Paper III is now the forward manuscript *Golden descent and operator
realizations of the Clebsch cubic*.  Its argument is one bounded chain:

\[
\sqrt{5J_0}\text{ incidence descent}
\longrightarrow C^2=5I
\longrightarrow
\begin{matrix}
\text{triangle and middle-exterior cubic}\\
\text{commutator Pfaffian and cross-golden determinant}\\
\text{Joubert--Segre and Segre--Igusa shadows}
\end{matrix}
\longrightarrow \text{degree-six Gaunt return}.
\]

The relative marked orientation bridge is now a proposition, and its complete
ambiguity ledger is an appendix.  The manuscript does not import the Golden
program's quantum, anomaly, Majorana, Coble--Burkhardt, exceptional-lattice,
doily, or higher-conference branches.  Released versions 1 and 2 remain
unchanged; this work is a forward version only.

## Frozen theorem and dependency map

| stage | paper statement | proof ownership | exact trust route |
|---|---|---|---|
| source | `thm:arithmetic-main` | Paper III human proof using Hitchin's incidence and chart theorems | `ARITH-1`, `ARITH-2`; arithmetic bundle and partial `ClebschPassages` Lean mechanisms |
| marked transport | `thm:orientation-source` (proposition) | Paper III split-pinching, tight-frame, exchanger, and Petersen proof | `ORIENT-1`; orientation bundle and partial `ClebschPassages` gate |
| operator identities | `thm:operator-shadows` clauses 1--2 | C711 human conference/middle-exterior proof plus the matching-Pfaffian and golden-block arguments | `OPER-1`; `ClebschGoldenReturn`, including the new fixed-conference commutator-Pfaffian bridge |
| classical cubics | `thm:operator-shadows` clauses 3--4 | Paper III recognition proof using the classical six-point matching quotient | `OPER-2`; human proof and Howard--Millson--Snowden--Vakil citations |
| harmonic return | `thm:harmonic-main` | Paper III Petersen-spectrum and one-vector Gaunt normalization | `HARM-1`, `HARM-2`; harmonic bundle and partial `ClebschPassages` gate |

The citation direction is one way.  Paper III contains the transition proofs
needed for its source--operator--cubic--harmonic chain; it does not absorb
Paper I's decoder-to-two-graph rigidity theorem or the Golden manuscript's
application inventory.

## Formal consolidation

`RelativeConicArcs.ClebschOperatorShadows` proves over every commutative ring
that the fixed conference matching evaluation is four times its triangle
cubic and hence that the order-six commutator Pfaffian is the same cubic.
`RelativeConicArcs.Gates.ClebschGoldenReturn` now imports and audits these two
declarations alongside the conference, two-graph, middle-exterior, support,
and golden-descent mechanisms.  Its pinned report has twenty-seven audited
declarations.  Native decision remains confined to the already declared
finite matrix terminals; both new bridge theorems depend only on `propext`
and `Quot.sound`.

The trust surface remains deliberately partial.  Lean does not claim the
outer-family coherence, cross-golden determinant comparison, classical
Joubert--Segre--Igusa identification, global Hitchin geometry, or raw
spherical moment.

## Cold reads and corrections

The independent theorem cold read first returned `NO-GO` because its compact
packet omitted the definition of `D_x`, the labelled nature of the six
synthematic totals, and the ambient Segre equations.  The manuscript now
states all three locally: `D_x` is the six-by-six diagonal matrix; the totals
are the six labelled one-factorizations of the fixed labelled `K_X`; and the
Segre cubic is displayed in `P^5`, with the `z_T=0` section reduced explicitly
to `P^3`.  With the proof mechanisms and constants supplied, the same reader
returned `GO` with no remaining defect.

The independent editorial read returned `GO`.  Its useful requests were to
separate data from theorem in the operator section, gloss the classical
Joubert--Segre--Igusa recognition, and state explicitly how the harmonic
section closes the operator argument.  All three edits are integrated.  Its
remaining comments relied on section names or claims absent from the actual
manuscript and required no change.

## Validation and synchronization

- `RelativeConicArcs.ClebschOperatorShadows`: guarded elaboration passed.
- `RelativeConicArcs.Gates.ClebschGoldenReturn`: serialized build and
  trace-only aggregate gate passed.
- The pinned golden-return source/toolchain replay passed, and its axiom
  report matches the guarded gate output byte for byte.
- The authoritative Paper III aggregate ended `ALL CHECKS PASS`, including
  exact statement/trust identity, three primary and independent evidence
  bundles, public vocabulary, release allowlist, and warning-free PDF.
- The standalone Paper III aggregate and pinned formal-source replay passed.
- Authoritative integration commit: `5f144ed6`.
- Standalone forward commits: `e6ff826` and final editorial refresh
  `22bb6ec`.

## Extra-juice and Tao-style closeout

The cheap structural upgrade was to make the commutator-Pfaffian bridge an
actual paper-facing Lean theorem instead of leaving it as a prose
correspondence between two previously formalized modules.  The Tao-style pass
then pressed the source/target distinction: it caught the possible confusion
between the source hypersurface `Z_T=0` and the target hyperplane section
`z_T=0`, and the manuscript now states only the latter as the diagonal
Clebsch cubic surface.  It also forced the labelled-one-factorization and
ambient-`P^5` clarifications that closed the theorem cold read.

## Mystery ledger

| feature | disposition |
|---|---|
| Why the same cubic has triangle, middle-exterior, Pfaffian, and determinant forms | settled by complementary matching minors, the fixed Hodge convention, and the golden eigenspace block matrix |
| Why the Clebsch surface appears | settled as the target section `z_T=0` of the Segre cubic, not as the source cubic threefold `Z_T=0` |
| Whether the incidence sheet determines the full outer marking | settled negatively; it supplies the orientation bit, while the coherent outer and cross-label data remain explicit inputs |
| Why the harmonic cubic belongs to the same argument | settled by the marked pair-sum transport to the Petersen four-space and the unique invariant cubic line |
| Exact integral bad primes of the geometric Hitchin comparison | still open at the pre-existing integral-model gate: choose the integral harmonic/Grassmannian model, prove flatness and normality, and commute Stein formation with base change |

No numerical or sign mystery remains inside the C763 operator consolidation.
The integral Hitchin-model boundary is an explicit older evidence gap, not a
new Golden-core obligation.

Vibe check: this is a material conceptual upgrade without breadth inflation.
Paper III now has the missing middle passage, and the formal trust surface is
stronger exactly where the headline operator identity is algebraic.
