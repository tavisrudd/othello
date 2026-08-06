# C864 — split lines for the remaining order-eleven families

**Lane:** `build-sys` · **Date:** 2026-08-05

**Verdict: the remaining order-eleven cut is the order-16 kind, not the point-orbit kind.  The
definitions its statements quantify over are closed-form arithmetic, not enumerated tables, so
statements and definitions can stay in the monorepo while the exhaustive proofs move.  Nothing here
forces the ownership move that the point-orbit family needed.**

This is planning against a tree that the Paper I remediation is actively editing.  Every disposition
below is a proposal; the pre-deletion source audit is what makes it safe to act on later.

## Why this cut differs from the point-orbit cut

The point-orbit family could not be split because its four surviving statements were quantified over
generated enumerated data — `orbitPoints`, `witnessSet`, `brianchonSet` — and a definition's body is
its content, so there was nothing to pin away.  The whole family had to change owner.

The coding side is built the other way.  `projectiveVec` is an arithmetic formula on the point
index, `witnessVec` reads a six-element list, `oneWord` and `twoWord` are formulas, and
`totalSyndromeDistance`, `nearestLeaderCount` and the ambiguity strata are compositional definitions
over those.  None of them is a table.  A monorepo statement mentioning them costs nothing to state
locally, and the expensive part — the exhaustive verification that the statement holds over all 133
points or all nonzero syndromes — is exactly what an external package should own.

The order-eleven semantic family already has the shape the workspace's proof-engineering rules
recommend: a definitions-carrying base, fourteen single-theorem shard modules that each raise the
heartbeat and recursion limits, and light aggregators.  The cut runs along a boundary that is
already drawn in the source.

## Dispositions

**Stays in the monorepo and finitegeom.**  Interface-shaped, no raised elaboration limits, and either
consumed from outside the family or audited by a gate other than the rigidity gate.

| module | why |
|---|---|
| `Q11SemanticBase` | the closed-form definitions the whole family is stated over |
| `Q11CodeRigidityBridge` | interface-shaped: three definitions, nine theorems, no raised limits |
| `Q11DyeConsequences`, `Q11RigiditySpine` | small theorem interfaces over the literature statements |
| `SixArcDegenerateConicExclusion` | one definition and three theorems, no raised limits |
| `Q11GoldenHexagonWitness` | now a declared terminal of the new six-arc concurrence gate |
| `Q11DyeAxioms` | the literature statements themselves; see the finding below |
| `Q11NonGRS` | reached from the results umbrella |
| `ClebschGatewayQ11Extension` | audited by the Clebsch gateway gate, a different area's surface |
| the definition halves of `Q11SemanticLeaders`, `Q11SemanticSpectrum`, `Q11SemanticRayData` | named by surviving statements |

**Moves to the certificate package.**  Exhaustive verification, and only that.

| payload | shape |
|---|---|
| the fourteen single-theorem semantic shards — distribution, index cases, one- and pair-avoidance, one-, pair- and two-representative modules and their four-way splits | one exhaustive theorem each, heartbeat and recursion limits raised |
| the theorem halves of `Q11SemanticSynthesis` and `Q11SemanticLeaders` | ten and four theorems over the same enumerations |
| the exhaustive case work behind the eight coding terminals | the rigidity gate's `Examples.Q11Coding.*` audits |
| the decoding synthesis computation | syndrome distance, ambiguity strata, leader supports |
| the matching and incidence enumeration in `Q11BrianchonPetersen` | fifty of its fifty-four declarations are unreferenced outside |

`Q11BrianchonPetersen` keeps four small declarations its reflection-arrangement consumer names —
the chord-edge constructor, the raw chord line, and the cross and dot helpers — together with the
`Edge`, `Vertex`, `Point` and `vertexVec` declarations their bodies mention.  The two vector helpers
would be better in a shared geometry module than re-exported from a certificate interface, but that
is a tidying decision for the owning proof lane, not a condition of this cut.

## What happens to the eight coding terminals

They are exact exhaustive results, so by the order-16 precedent the exact theorems live in the
package with their proofs, and the monorepo's rigidity gate drops those eight audits the way it
dropped the four orbit audits.  The monorepo keeps the definitions and the human reduction lemmas
and consumes the package's pinned fact.  The alternative — restating all eight locally and proving
them from a pinned fact — is not available, because a pinned fact is evidence about a package's
gate, not a Lean proof term.

This is the one place where the proposal changes a paper-facing surface, so it is the one place that
needs the owning proof lane's agreement before anything moves.

## Finding: the pinned trust fact overstates the Dye trust boundary

`RelativeConicArcs.Q11DyeAxioms` in the monorepo now declares no axioms at all.  Both Dye statements
— the ten-point Brianchon bound and the equality classification — are theorems there.  finitegeom
library at the pinned revision still declares both as axioms, and the pinned external trust fact
records `dye1991_brianchon_bound` and `dye1991_equality_classification` as trusted inputs of the
order-eleven rigidity terminal.

So the published fact, and the paper prose derived from it, claim a trusted base two axioms larger
than the current source actually needs.  The direction of the error is the harmless one — it
overstates what is assumed rather than understating it — but it is wrong, and it is the exact
question the Dye audit item on the task card exists to settle.

Three consequences.  The Dye audit item cannot be answered from the pinned fact, since the fact is
stale; it must be answered against the monorepo source after the remediation settles.  The reseal
must re-derive the axiom list from a fresh gate run rather than carrying the published one forward.
And the module name `Q11DyeAxioms` no longer describes its contents, which is a rename for the
owning proof lane rather than for this task.

## Sequencing

The cut cannot start while the Paper I remediation holds the tree, and it should not start before
that remediation lands, because it is replacing the Dye axioms with proofs from the six-arc
concurrence spine — which changes both the trust fact this package publishes and the statements the
package consumes.  Cutting first would guarantee an immediate reseal.

The order once it is clear: re-run the package source audit over the seven duplicated modules; agree
the eight coding terminals with the owning proof lane; then the finitegeom re-export, the package re-pin
and reseal, and the monorepo deletion in the one window the card already requires.
