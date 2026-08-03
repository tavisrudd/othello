# Version 2 verification map

The manuscript proves the general statements. Certificates close only the
finite or symbolic domains named below. Every public artifact is hashed in
supplement/EVIDENCE-MANIFEST.json and checked by supplement/verify.py.

| Public bundle | Exact role | Independent or separate check | Non-claim |
|---|---|---|---|
| Certificate R5 | exhaustive bounded cubic-pencil census and orbit records | separately written R5 replay | no high-field geometry or radius theorem |
| Certificate R6 | definition/Hankel equality on the declared finite fields | independent definition replay on the documented subrange | no continuation theorem |
| Certificate R6-NF | small semilinear normal forms | deterministic checker plus R6 dependency replay | not a second full census |
| Certificate R7 | finite pointed calibration and public orbit record | quotient replay and arithmetic replay | q=7,8,9 remain split-free rows only |
| Certificate R7 direct locus | complete fourteen-field direct-locus reconstruction | checker validates mass identities, orbit--stabilizer, Frobenius, and frozen comparison | shares the public direct-locus engine, R5 field layer, and R6 pointed theorem from q >= 16; checker is not a second field implementation |
| Certificate SC | bottom-factor identities, saturations, vertical reductions, and coherent-Fano elimination | dependency-free Python identities plus Singular scripts; Lean separately checks density/selection logic | does not prove a flat reduced integral carrier |
| Certificate R8 | thresholds, nuclei, witnesses, and budgets | separately written replay | no ambient syndrome census |
| Certificate R9 | residual-quadratic arithmetic, six-section slice data, and q=49 bridge | independent residual replay; Rust q=49 certificate | no unrestricted carrier theorem |
| Certificate R10 | threshold, persistent orbit arithmetic, and carrier point-count synthesis | separate prime-power/orbit replay | does not prove first-carrier shallowness |
| Certificate Lucas M9 | full q=16,32 carrier and q=64 invariant-block rank-two twists | independent finite-field/action/replay code | finite certificates do not prove the q=64 complement or the all-field genus-one theorem |

The balanced q=8 quantum consequence introduces no computation beyond the R5
row 1116=360+756. Its coding and quantum implications are cited or formalized
through their separately declared interfaces.

## Replay

From the standalone paper directory:

    python3 supplement/verify.py --replay

This runs every Python generator/replay listed by the public gate, checks all
classification records and manifest rows, and fails on schema or content
drift. The q=49 Rust record and Singular stable-component scripts remain
separately named exact replays in supplement/REPRODUCING.md; their outputs are
hashed even when the quick Python replay is selected.

## Lean boundary

- paper-facing aggregate:
  RelativeConicArcs.Gates.PRSBeyondRedundancyFour;
- aggregate audit:
  RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit;
- separate balanced-quantum gate and audit:
  RelativeConicArcs.Gates.PRSBalancedQuantumExtension and its axiom audit;
- label-by-label reconciliation:
  supplement/LEAN-STATEMENTS.md.

The aggregate checks R5--R7 algebra and conditional syntheses, contraction,
uniform radius arithmetic, squarefree-marker density, closure transport, and
finite-component selection. Concrete carrier primes, R8/R9 geometry, M9
arithmetic, genuine group actions, cited radius theorems, and external
certificate semantics remain explicit. The audit reports only propext,
Classical.choice, and Quot.sound.

## Release boundary

The public Version 1 commit, archive, tag, DOI, PDF hash, and source hash are
immutable fields in supplement/RELEASE-MANIFEST.md. Local Version 2 candidate
hashes and the expanded 69-artifact evidence map are separate mutable
candidate fields until a new reviewed release is authorized.
