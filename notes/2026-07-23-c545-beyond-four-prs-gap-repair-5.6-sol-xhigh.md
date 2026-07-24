# C545 — beyond-four PRS gap-repair report

**Date:** 2026-07-23  
**Reviewed SHA:** `494330767a3e63ca102fd56face971072243ba26`  
**Scope:** repair of the five ranked blockers in the full cold-read report,
excluding external publication, upload, archive, tag, and DOI actions  
**Verdict:** **PASS for the stated scope**

## Methodical pass/review checklist

| # | Item | Pass criterion | Result | Evidence |
|---:|---|---|---|---|
| 1 | R6 characteristic scope and components | State the correct characteristic range; print the modular, wild-cone, and binary-plane overlap calculations rather than citing a census | **PASS** | Commit `fcf3c69e`; manuscript check passed |
| 2 | Ordered Hessian | Print the universal coefficient formulas, vertical/horizontal factor mechanism, semisimple and unipotent comparisons, Plücker ideals, and constrained UFD pullback | **PASS** | `sections/08-ordered-hessian.tex`; clean 39-page isolated build |
| 3 | R8 lower package | Separate universal strata, monodromy, the two-old-marker lemma, outer selection, exhaustion, and threshold; display the recursive divisor table | **PASS** | `prop:r8-lp61` in `sections/07-fixed-level-eight-nine.tex` |
| 4 | R9 four-marker package | Prove `LP(7,1)` rather than quote budgets; cover gcd degrees 0, 1, and at least 2; prove noncontainment and marker avoidance at every recursive layer | **PASS** | `prop:r9-budgets`; cold reread returned PASS after five exact repairs |
| 5 | R9 numerical bounds | Verify bottom deletion 36; recursive bounds 22, 18, 18; top bound 17; first prime-power threshold 53 | **PASS** | Manuscript proof and Lean declarations `exact_deletion_and_parameter_degrees`, `parameter_degrees_lt_projectiveLine_cardinality`, and `fourMarker_genusOne_squared_margin` |
| 6 | R9 formal boundary | Kernel-check three pointed lifts and exact arithmetic; state explicitly that the algebraic geometry remains the printed proof | **PASS** | `RelativeConicArcs.PRSFourMarkerLowerPackage`; guarded single-file elaboration exit 0 |
| 7 | Local evidence bundle | Put every generator, certificate, replay, checksum, public supplement input, and toolchain lock under stable paper-local paths with SHA-256 and byte counts | **PASS** | 54 entries in `supplement/EVIDENCE-MANIFEST.json`; bundle checker passed |
| 8 | Self-contained classification extraction | Consume bundled R5--R7 certificates, not `notes/`; reproduce the committed public record byte for byte | **PASS** | `build_classification_records.py --check`; `sha256sum -c CLASSIFICATION-RECORDS.sha256` |
| 9 | Executable replay sweep | Run every Python replay/checker from its bundled directory | **PASS** | R5, R6, R6-NF, R7, R8, R9, Hessian, Lucas, and e7 all returned PASS |
| 10 | Export environment | Supply an export-root `flake.nix`, `flake.lock`, and `lean-toolchain`; make `../lean` the documented finitegeom repository root | **PASS** | `nix flake check --no-build` exit 0; public destinations recorded without attempting setup or publication |
| 11 | TeX integrity | Compile without undefined references, citations, overfull/underfull boxes, or package warnings while preserving the concurrently modified tracked PDF | **PASS** | Isolated output: 39 pages, 280,551 bytes; warning scan empty |
| 12 | Immutable external release | Repository publication, immutable public revisions, archive, tag, source/PDF release hashes, and DOI | **REVIEW — intentionally excluded** | Explicit external-publication fields in `supplement/RELEASE-MANIFEST.md` |

## R9 proof audit

The four-marker proof is now a theorem-sized argument rather than an
arithmetic placeholder.

1. A three-pointed quartic Hankel net is contracted to the same
   geometrically integral off-diagonal \(S_3\) \((2,2)\)-cover.  Four marker
   fibers give
   \[
   4+8+4\cdot6=36.
   \]
   Its parameter-line divisor has degree
   \[
   3+4+6+3\cdot2+3=22.
   \]
2. A two-pointed quintic series has parameter degree
   \[
   3+1+8+2\cdot2+2=18.
   \]
   In the exact-gcd-one case, the corrected candidate count is
   \((q-3)(q-4)\), and
   \[
   (q-3)(q-4)>14(q+1)
   \]
   throughout the claimed range.
3. A one-pointed sextic series has parameter degree
   \[
   3+2+10+2+1=18.
   \]
   Whole polar lines are assigned to the explicitly defined persistent,
   Lucas-nucleus, fixed-marker, or self-collision boundary rather than counted
   as finite divisors.
4. At degree eight, the transverse first-polar degree is
   \[
   3+2+12=17.
   \]
5. The characteristic-two inseparable residual quadratic pencil is normalized
   to \(\langle T^2,U^2\rangle\).  For gcd root \(z\), the overlapping Hankel
   equations force \(c_i=z^ic_0\), hence the rank-drop determinant vanishes.
   This closes the previously asserted but unproved inseparable placement.

The first adversarial reread found a candidate-count error, an omitted
whole-line scope, an unprinted inseparable calculation, an imprecise
evaluation-hyperplane conclusion, and an overbroad reference to the bottom
rank determinant.  All five were repaired.  The second reread returned:

> PASS. All five repairs are present and mathematically close the prior gaps;
> no remaining load-bearing defect found.

## Formalization boundary

`RelativeConicArcs.PRSFourMarkerLowerPackage` proves, by kernel elaboration:

- one-step and three-step pointed witness composition;
- the exact constants \(36,22,18,18,17\);
- every parameter degree is \(<q+1\) for \(q\ge53\); and
- the squared strict genus-one Hasse--Weil margin.

It does not encode algebraic varieties, geometric integrality, monodromy,
divisor calculations, or Hasse--Weil itself.  Those are proved in the
manuscript and are described as mathematical inputs in the Lean module
header.  This is an honest formal boundary, not a claim that abstract
structure fields constitute a formal proof of the geometric package.

The standalone module elaborated successfully.  An aggregate Lean gate was
not run from this lane because the shared Lean closure contained concurrent
owned modifications; this does not weaken the elaborated theorem, but the
public finitegeom export should import it in its normal aggregate gate.

## Local bundle validation

The following paper-local checks passed:

```text
python3 supplement/package_evidence_bundle.py --check
python3 supplement/build_classification_records.py --check
(cd supplement && sha256sum -c CLASSIFICATION-RECORDS.sha256)
nix flake check --no-build
```

The bundle checker verified 54 artifacts.  Independent replay/checker results:

- R5: all 19 fields PASS;
- R6: direct definition replay through \(q=16\), all PASS;
- R6-NF: all five small-field normal-form reconstructions PASS;
- R7: all 14 recorded fields PASS;
- R8, R9, ordered Hessian, Lucas arithmetic, and \(e_7\): PASS.

The R9-49 text output is hash-pinned with its sole exhaustive Rust generator.
It is deliberately not called an independent replay.

## Top five standouts after repair

1. The R9 four-marker package is now the strongest expository improvement:
   every recursive layer has a job, an exclusion domain, an exact degree, and
   a lift.
2. The ordered-Hessian section now exposes its decisive normal forms and
   Plücker ideals rather than asking the reader to reconstruct them.
3. R8's large proof reads as a sequence of named mechanisms, with its
   parameter divisor visible in one table.
4. The manuscript and Lean source agree exactly about what is formalized and
   what remains a hand proof.
5. The paper-local supplement can be checked and replayed without reaching
   back into the development `notes/` tree.

## Five remaining review sensitivities, ranked

1. The aggregate public Lean gate must import the new four-marker module when
   the finitegeom export is assembled.
2. The two future public repository revisions must be recorded immutably:
   `tavisrudd/finitegeom` at export path `../lean`, and
   `tavisrudd/finitegeom-q25-certificates`.
3. The R9-49 carrier has one exhaustive implementation, as disclosed; a second
   exhaustive implementation would strengthen assurance but is not claimed.
4. The Nix evaluation currently reports a nixpkgs deprecation notice for the
   pinned full TeX scheme; evaluation succeeds, and the lock preserves the
   working package.
5. Archive, tag, source/PDF release hashes, and DOI remain external-publication
   actions and were intentionally not performed.

## Final disposition

The mathematical HOLD caused by blockers 1--4 is lifted at the reviewed SHA.
The local/self-contained part of blocker 5 is also closed.  Only the explicitly
excluded external-publication actions and the normal public aggregate Lean
integration remain review items.

Signed,

**5.6-sol-xhigh**
