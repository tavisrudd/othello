# C713 — Paper I proof architecture and structural node proof

**Lane:** `clebsch`

**Opened:** 2026-07-31

**Status:** complete.  Report:
[`../2026-07-31-c713-paper-i-proof-architecture.md`](../2026-07-31-c713-paper-i-proof-architecture.md).

## Objective

Give the focused Paper I manuscript a Milnor--Serre proof pass without
changing its mathematical scope: make the rigidity argument arrive when the
reader expects it, expose the causal stages of the orientation theorem, and
replace the cubic singular-locus computation by a structural or precisely
cited argument if the exact published interface supports that transfer.

## Work package

1. Reorder the manuscript so chord defect, line bound, rigidity, and the
   across-fields consequences form one continuous argument before the decoder
   and orientation developments.
2. Preserve the structural (A_5)-orbit proof but subordinate or relocate its
   full ledger so that it does not delay the headline implication.
3. Split the orientation proof into orbital balance, triangle holonomy, the
   determinant pencil, and the node/frame--symmetry--commutant consequences.
   Expand the common-neighbor count yielding ((A-A')^2=10(I-R)).
4. Pinpoint-check the Cheltsov--Tschinkel--Zhang six-nodal model. If its exact
   theorem and coordinate identification transfer singular-locus completeness,
   use that structural citation and retain the Buchberger replay only as an
   independent check. Otherwise replace the five chart calculations only if a
   genuinely explanatory invariant or short human lemma is found.
5. Keep theorem statements, normalizations, and the computational/formal trust
   boundary synchronized with the statement map and pinned q11 certificate
   package. Update Lean terminals only where the adopted proof changes the
   formal interface.
6. Synchronize the authoritative manuscript and standalone mirror and rerun
   their complete release gates.

## Acceptance

The reader encounters the headline proof immediately after its machinery and
can name every causal stage of the orientation argument. No computation is
relabelled as structural: singular-locus completeness is either transferred by
an exact published theorem, proved conceptually, or remains explicitly
computer-assisted. The paper, q11 Lean gate and axiom audit, trust manifest,
PDF, and standalone mirror agree exactly and pass their release checks.

## Boundaries

Do not alter the frozen mathematical scope, import Paper II or III proof
dependencies, weaken the two declared Dye axioms, or publish external artifacts.
The shared trilogy title-page refinement is already complete.

## Closeout

The proof spine now runs continuously from chord defect through the line
bound, rigidity, and the across-fields consequence before the coding and
orientation developments.  The orientation proof exposes orbital balance,
triangle holonomy, the determinant pencil, the node frame, symmetry, and the
integral commutant as separate causal stages; the common-neighbor count behind
`(A-A')^2=10(I-R)` is explicit.

The six-node proof is structural and gap-free.  The cross-golden block has
determinant `-C`; its trace-orthogonal four-space cuts out the smooth Clebsch
diagonal cubic surface; and Hassett--Tschinkel Proposition 10 gives exactly six
ordinary nodes on the dual cubic threefold.  CTZ Proposition 7.3 remains model
identification only because it assumes the six-node hypothesis.  The former
five-chart Gröbner exhaustion remains as an independent exact replay.

All nineteen statements, the trust manifest, tracked twenty-one-page PDF,
pinned q11 gate and two-axiom audit, authoritative release certificate, and
standalone mirror pass their clean aggregate gates.  No Lean terminal changed.
