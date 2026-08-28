# Version 2 verification map

The manuscript proves the general statements. Certificates close only the
finite or symbolic domains named below. Every public artifact is hashed in
supplement/EVIDENCE-MANIFEST.json and checked by supplement/verify.py.

| Public bundle | Exact role | Independent or separate check | Non-claim |
|---|---|---|---|
| Certificate R5 | exhaustive bounded cubic-pencil census and orbit records | separately written R5 replay | no high-field geometry or radius theorem |
| Certificate R6 | definition/Hankel equality on the declared finite fields, including the q=7 definition-level syndrome/radius scan | independent definition replay on the documented subrange | no continuation theorem |
| Certificate R6-NF | small semilinear normal forms | deterministic checker plus R6 dependency replay | not a second full census |
| Certificate R7 | finite pointed calibration and public orbit record | quotient replay, arithmetic replay, and companion exact-distance extraction | the certificate itself proves split-free classification, not the q=7,9 MDS length bounds or the q=8 external radius; at q=8 exactly the diagonal tangent and central nucleus are deep |
| Certificate R7 direct locus | complete fourteen-field direct-locus reconstruction | checker validates mass identities, orbit--stabilizer, Frobenius, and frozen comparison | shares the public direct-locus engine, R5 field layer, and R6 pointed theorem from q >= 16; checker is not a second field implementation |
| Certificate SC | bottom-factor identities, saturations, vertical reductions, and coherent-Fano elimination | dependency-free Python identities plus Singular scripts; Lean separately checks density/selection logic | does not prove a flat reduced integral carrier |
| Certificate R8 (companion) | thresholds, nuclei, witnesses, and budgets | separately written replay | not a claim of the current submission; no ambient syndrome census |
| Certificate R9 (companion) | residual-quadratic arithmetic, six-section slice data, and q=49 bridge | independent residual replay; Rust q=49 certificate | not a claim of the current submission; no unrestricted carrier theorem |
| Certificate R10 (companion) | threshold, persistent orbit arithmetic, and carrier point-count synthesis | separate prime-power/orbit replay | not a claim of the current submission; does not prove first-carrier shallowness |
| Certificate Lucas M9 (companion) | full q=16,32 carrier and q=64 invariant-block rank-two twists | independent finite-field/action/replay code | not a claim of the current submission; finite certificates do not prove the q=64 complement or all-field theorem |
| Certificate R11 binary quotients (companion) | complete degree-ten divided-power upper-Borel quotients of the R11 Lucas carrier P<e_3,...,e_7> at q=16,32, each orbit with a verified finite locator | two toolkit-free replays rebuilding field, action, orbits, and Hankel equations, each gated by a fail-closed seeded 1,000-pair equivariance test | not a claim of the current submission; fixed fields only, no interpolation to q=64 or characteristic three; the superseded 2026-08-27 artifacts used the degree-nine R10 action and give the same orbit counts, so a count never validates the group |
| Certificate R11 GF(27) sweep (companion) | all 402,321,277 projective classes of PG(6,27) admit a nine-distinct-root degree-nine locator satisfying both Hankel equations, minimum 78 two-point affine-plane switches per class | independent Python replay of the seeded witness sample, rebuilding GF(27) from scratch; the 26-minute Rust sweep is a separate rederive | not a claim of the current submission; closes the R11 carrier PG(6,27), not the ambient PG(10,27); the certificate-free switch lemma remains open |
| Certificate R11 characteristic seven (companion) | pointed locator certificates over q=49 for the seven orbit representatives of the characteristic-seven Lucas carriers, five at R11 and two at R12 | replay sharing no code with the toolkit or the generator: field rebuilt from the certificate, every locator rebuilt from its root set, zero sets recomputed exhaustively, both Hankel equations and the magnitude reconstruction re-derived | not a claim of the current submission; does not certify the exact-distance field, only the displayed witness |
| Projective Reed--Solomon Toolkit | exact structural canonicalization, trusted increasing-degree distance/decoding search, theorem-gated classification, and certificate replay | locked unit, compiled-CLI, property, and exhaustive regression layers; complete software manifest | locator replay proves the displayed upper-bound witness, not lower-degree exhaustion; generic computation beyond R10 is not a generic deep-hole theorem |

**Withdrawn 2026-08-07.**  The paper no longer draws a quantum consequence from the balanced q=8 row: a split-free direction is not a one-column MDS extension, and at covering radius r-1 no such extension exists.  The formal modules below are retained as conditional developments whose extension hypothesis is unsatisfied at these parameters; nothing in the manuscript depends on them.  See Remark `rem:q8-no-extension` and row R5-Q of `claim-proof-novelty-ledger.md`.

The withdrawn balanced q=8 quantum development introduced no computation beyond
the R5 row 1116=360+756, which stands as a deep-hole count. Its former coding
and quantum implications were cited or formalized
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
the earlier stagewise threshold arithmetic, squarefree-marker density,
closure transport, and finite-component selection. The new simultaneous
selector, point-deleted-support theorem, high-weight shell classification,
and NMDS aggregate theorem are manuscript proofs with no direct Lean
declaration. Concrete carrier primes, R8/R9 geometry, M9
arithmetic, genuine group actions, cited radius theorems, and external
certificate semantics remain explicit. The audit reports only propext,
Classical.choice, and Quot.sound.

## Release boundary

The public Version 1 commit, archive, tag, DOI, PDF hash, and source hash are
immutable fields in supplement/RELEASE-MANIFEST.md. Local Version 2 candidate
hashes and the expanded evidence map are separate mutable
candidate fields until a new reviewed release is authorized.
