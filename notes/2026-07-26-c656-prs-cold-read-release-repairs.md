# C656 — PRS cold-read release repairs

**Lane:** `reed-solomon`

**Status:** active; Version 1 narrowed to R5--R7

## Decision

The arbitrary-redundancy release gate does not pass.  Version 1 therefore
retains the complete redundancy-five and redundancy-six deep-hole
classifications and the complete redundancy-seven split-free classification,
with its separate covering-radius boundary.  It no longer claims the
all-level stable-component theorem, uniform threshold, large-characteristic
corollary, or higher-Lucas endpoint proposition.

This is the mandatory safe exit in the C656 task card, not a weakening of
trust language around the same theorem.

## Gate audit

### Modular pullback

`lem:linear-modular-pullback` proves degree at most one for the pullback of
one projective linear nucleus.  The former proof of
`prop:uniform-iterated-packages` charged degree one for the reduced union
\(\mathcal M_j\) without proving that all relevant nuclei are nested or that
their union has a common degree-one pullback.  No regression in the current
bundle detects a silently omitted second component.  The all-level budget is
therefore not adopted.

### Bottom carrier

The former `prop:exact-bottom-ledger` names the tame cyclic, binary vertical,
ordered-Hessian, ternary wild, and collision components, but does not print
the complete defining ideals, saturated primary decompositions,
multiplicities, exceptional fibres, or an embedded-component exclusion.
Certificate SC checks selected polynomial identities, saturation relations,
and vertical calculations; it is not a compact independently checkable
primary-decomposition certificate for the theorem C656 requires.

### Recursive transport

The former `lem:recursive-bottom-transport` descends a finite reduced union
on geometric points and then takes a scheme-theoretic image closure.  It does
not give the required generic-point induction through special fibres,
noninjective boundaries, nilpotent structure, and exact coherent lifts of
every lower component.  The conditional Lean interfaces correctly expose
this gap and do not close the concrete geometry.

## Version 1 repairs

- The title, abstract, introduction, proof guide, scope section, theorem map,
  claim/proof ledger, formalization ledger, verification map, adversarial
  audit, supplement statement map, and README now state the R5--R7 boundary.
- The proposed all-level proof and higher-Lucas endpoint remain in the source
  only as disabled companion material; they are not compiled or mapped to
  adopted manuscript labels.
- The one-step polar construction and the direct R6/R7 contained-component
  and point-count arguments remain in the paper.

## Fixed-field replay gate

Certificate R5 already has an independent full projective Hankel scan.
Certificate R6 already has an independent direct four-secant marking replay
with separately implemented Hankel checks and orbit reconstruction.
Certificate R7's original replay independently checks representatives,
five-secant tests, group orbits, stabilizers, and Frobenius fusion, but it
imports the generator's orbit list and aggregate absence claims.
`notes/2026-07-26-c656-r7-independent-arithmetic-replay.py` now supplies a
second end-to-end route.  It imports no stored classification or orbit
partition, replaces C509's field layer by the R5 replay's separately
implemented arithmetic, and reruns the pointed complement, marker transport,
complete sextic split-free set, projective-orbit, stabilizer, flag, and
Frobenius aggregation.  The existing replay independently checks the
syndrome test and orbit semantics.  The complete fourteen-field
cross-arithmetic run remains to be completed.

## Literature delta gate

The 2026-07-25 audit records the theorem-level Wang--Wu--Hu comparison and
its exact full-text cache record.  The C656 delta refreshes the two pinned
PRS citation graphs in OpenAlex, Crossref, and Semantic Scholar: all six
counts are unchanged.  Four exact arXiv submission-date queries returned
valid zero-result feeds, and the narrowed manuscript's remaining qualified
R5--R7 positioning is reconciled.  No new source was promoted.

## Validation so far

From the repository root:

```text
make -C papers/beyond4_prs check
```

passes on the narrowed 31-page canonical manuscript.  `make -C
papers/beyond4_prs tit-check` passes on the 23-page IEEE build.  The local
supplement consistency gate also passes before addition of the C656 replay.
Complete replay closure, refreshed hashes, the Lean gate, fresh-history
export, and two blind final readers remain open.

The deterministic exporter produced separate paper and Lean histories at
source commit `7db291a1325fd922c15ccb5dd414ddbfd82a496c`.  In the clean candidate,
the supplement consistency gate passes, the canonical PDF rebuilds
byte-for-byte with SHA-256
`81eeae9fdfec14b4518892074390fe252fa02ed8df596974bb3d53e333d31a7b`,
and the 23-page TIT build passes.

`lean/scripts/guarded-lean
RelativeConicArcs/Gates/PRSBeyondRedundancyFour.lean` passes against the
narrowed paper-facing map.  The matching axiom-audit elaboration is still
running.

## Mystery ledger

Settled:

- The former degree-one modular-union charge is not justified by the
  single-nucleus lemma.
- The current bottom evidence is not the exact primary-decomposition ledger
  required for an arbitrary-level release theorem.
- Conditional Lean density, closure, and component-selection interfaces do
  not formalize the missing concrete geometry.
- Version 1 can preserve the R5--R7 results without consuming any of those
  claims.

Open:

- The complete fourteen-field R7 cross-arithmetic run remains open.
- Final replay, build, export, and cold-reader gates.
- The exact all-level component ledger and modular-union degree belong to
  successor work, not Version 1.
