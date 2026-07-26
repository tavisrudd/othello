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
second reconstruction route.  It imports no stored orbit partition, replaces
C509's field layer by the R5 replay's separately implemented arithmetic, and
reruns the primary quotient enumerator, pointed complement, marker transport,
complete sextic split-free set, projective-orbit, stabilizer, flag, and
Frobenius aggregation before comparison with the public record.  The existing
replay independently checks the syndrome test and orbit semantics.  Both
routes reuse the primary quotient enumerator, so bounded-field completeness
remains a trusted exact execution rather than an independently rederived
claim.

The cross-arithmetic replay passes at all fourteen fields
\(7,8,9,11,13,16,17,19,23,25,27,29,31,32\).  The first serial run printed
PASS through \(q=31\) before deliberate interruption to release memory for
the Lean gate; the remaining shard

```text
python3 notes/2026-07-26-c656-r7-independent-arithmetic-replay.py --fields 32
```

exited zero with
`q=32: pointed=18450 deep=17425 PGL=5: PASS`.

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
papers/beyond4_prs tit-check` passes on the 23-page IEEE build.
`python3 papers/beyond4_prs/supplement/package_evidence_bundle.py --check`
and `python3 papers/beyond4_prs/supplement/verify.py` pass on the refreshed
44-artifact bundle.

Two mutually blind specialist cold reads found and closed four release-facing
trust defects: an active reference to the excluded stable-component theorem,
Certificate SC presented as Version 1 evidence, R7 replay language that
overstated independent completeness, and one residual Lean-map label.  Both
readers independently confirmed the final paper commit
`b410777db313aebe378257c3bf6c04ded7422d03`, canonical PDF SHA-256
`5eb6d0c2c420cfc7cd4317e3d1ea80447288ee7666029d660410069bf29aef9b`,
and returned GREEN.  Their stable reports are
`notes/2026-07-26-c656-finite-geometry-blind-signoff.md` and
`notes/2026-07-26-c656-coding-computation-blind-signoff.md`.  These are
internal AI cold reads and do not fill the publication-independent reader
fields in `supplement/FINAL-READER-SIGNOFF.md`.

The deterministic exporter produced separate paper and Lean histories from
source commit `11cd64d72f937de745d1316ec394431042cfbf6a`.
The fresh paper commit is
`f4a714a62bff70521f48a4ce1e9ac1e68ac807d0`; the fresh Lean commit is
`1385f19d6d7c6c748bc3b779f9c5388af6e51e04`.  In the clean paper candidate,
the supplement consistency gate passes, both builds pass, and the canonical
and TIT PDFs rebuild byte-for-byte with SHA-256 values
`5eb6d0c2c420cfc7cd4317e3d1ea80447288ee7666029d660410069bf29aef9b`
and `48943b96949604cb25133c53403b4cf24ea87ec8c30ab78f4172931f1770d652`.

`lean/scripts/guarded-lean
RelativeConicArcs/Gates/PRSBeyondRedundancyFour.lean` passes against the
narrowed paper-facing map.  The serialized build of
`RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit` passes with a
trace-current aggregate gate after rebuilding the stable-component dependency.
All 74 ordered targets print only `propext`, `Classical.choice`, and
`Quot.sound`, or no axioms; no `sorryAx` or unsafe dependency appears.  Peak
resident memory was 3,372,056 KiB.  The first overlapping attempt was killed
with exit 137 while the R7 census was still live; serialization resolved that
resource conflict without a source change.

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
- The R7 reconstruction supplies independent field arithmetic and
  representative/orbit checks, not an independent completeness derivation;
  the paper and supplement now state that boundary.
- Both blind readers' scope and trust objections are closed on one byte-exact
  candidate.

Open:

- Publication-independent human readers remain a C545 external release gate;
  the internal blind reviews do not substitute for them.
- The exact all-level component ledger and modular-union degree belong to
  successor work, not Version 1.
