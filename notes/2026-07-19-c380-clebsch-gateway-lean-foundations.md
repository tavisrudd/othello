# C380 — Clebsch gateway Lean foundations

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `FORMALIZED; TYPED ARC/MDS BRIDGE; TERMINATING q=11 TRANSFORM; 22 FAITHFUL MATCHINGS IN TWO 11-PARENT SHEETS; FROZEN FUSION/FOURIER API`

## Result

C380 formalizes only the stable seams left by C376--C379.

1. `deepTransform A` is the finite set of projective distance-three syndrome directions.  For an
   arc `A`, membership is equivalent to being fresh and making `insert x A` an arc.  For an
   injectively indexed projective arc with at least three columns, adjoining such a direction
   produces `CodingBridge.CodimThreeMDSColumns`; its transparent kernel has dimension `n-3`,
   minimum distance at least four, and an exact weight-four word once four columns are present.
2. In the fixed q=11 parent, the typed transform is exactly the twelve-point standard conic.
   Every one of its twelve points gives a seven-column `[7,4,4]` kernel in the transparent
   parity-check model.
3. A bounded determinant/coverage leaf checks the twelve-point conic against all 133 canonical
   projective representatives.  It proves that the full conic is complete, hence its own typed
   transform is empty.  This formalizes termination, not involutivity or periodicity.
4. A generic `DecoratedTransform` records when a child and decoration faithfully recover a parent.
   The q=11 leaf checks all 22 C379 obstruction matchings as fixed-point-free involutions and proves
   that the matching map is injective.  It also proves that the binary orientation map is not
   injective: its two fibers have cardinality eleven, and each fiber is a one-factorization of
   `K_12`.  Thus a sheet selects an eleven-parent system; an individual parent still requires its
   matching.
5. `twoSheetCharacter_eq_of_ker_eq` proves that a character into `Perm (Fin 2)` is determined by
   its kernel.  The specialized `s5_quotientCharacter_inference` states C376's abstract conclusion:
   two `S5` actions on two sheets that are trivial exactly on the even permutations are equal.
   No sheet is canonically named.
6. The frozen C378 interface records the exact fusion blocks

   ```text
   {0}, {3}, {1,5,6}, {2,4,7}
   ```

   with fused sizes `1,120,660,550`, the four exchanged rank-16 relation pairs, and the signed
   `4 x 4` Fourier matrix.  Lean checks `M_odd^2 = 1331 I_4`.  A generic `OrbitClassifier.fuse`
   isolates the mathematical orbit-to-fusion seam from finite group closure.

## Module boundary

- `RelativeConicArcs.ClebschGateway` contains the reusable typed API, raw-coverage soundness,
  decorated recovery, quotient-character inference, and orbit-fusion seam.
- `ClebschGatewayQ11Extension` consumes the existing certified q=11 syndrome terminal and proves
  the twelve one-column MDS extensions.
- `ClebschGatewayQ11Conic` is the bounded `12`-point/`133`-representative termination leaf.
- `ClebschGatewayQ11Matching` is the bounded `22 x 12` matching leaf and checks both eleven-parent
  one-factorizations.
- `ClebschGatewayQ11Fusion` freezes the C378 relation data and signed matrix identity.
- `Gates.ClebschGateway` is import-only and imports every paper-facing C380 terminal.

Finite-certificate work is split across module boundaries.  The largest measured leaf was the
conic termination check at `5,453,448 KiB` maximum RSS; the extension leaf used `3,435,584 KiB`,
matching `2,255,444 KiB`, fusion `1,834,768 KiB`, and the base `1,859,556 KiB`, all under the
serialized `single` profile.

## Reproduction

From `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-19-c380-clebsch-gateway-lean-foundations.py --check
sha256sum -c notes/2026-07-19-c380-clebsch-gateway-lean-foundations.sha256
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschGateway \
  RelativeConicArcs.ClebschGatewayQ11Extension \
  RelativeConicArcs.ClebschGatewayQ11Conic \
  RelativeConicArcs.ClebschGatewayQ11Matching \
  RelativeConicArcs.ClebschGatewayQ11Fusion \
  RelativeConicArcs.Gates.ClebschGateway \
  --profile single --threads 1 --cores 20-23 \
  --aggregate RelativeConicArcs.Gates.ClebschGateway
```

The successful queue run is recorded under
`/home/tavis/.cache/othello-lean-build/run-20260720-044333-823b87ee`; its final aggregate was an
exact-target trace-only `--no-build` confirmation of `RelativeConicArcs.Gates.ClebschGateway`.

The modules contain `#print axioms` audits for every terminal family.  The aggregate replay reports
only Lean's standard `propext`, `Classical.choice`, and `Quot.sound`; no terminal depends on
`sorryAx` or a project-local axiom.

## Evidence and cross-check

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| foundation `.lean` | 15,092 | `a8f9302bce0495b396b49151ed7c441c4e66c1615d229e6766d2d9940cd286c5` |
| extension leaf `.lean` | 4,374 | `953c2a161ffb693dc2928d047e2112b39d320c87b78099d5418ec5911c62065e` |
| conic leaf `.lean` | 2,732 | `504488ef40f27e4714db84aed164027e33f259f7139497fb942f393a00db03cc` |
| matching leaf `.lean` | 3,956 | `1b2c959a5602257a303e7a16fe6c8304e507eb06453e68b7cca6610af30175b1` |
| fusion leaf `.lean` | 2,802 | `b8fa03711aaf998aa4fb436bcdcd61908bedf04703e3eeccd72f50625e891170` |
| import-only gate `.lean` | 501 | `773786e46a43adc6ea399ad52f9ad0a32842dfa173918068dad8c3d96fcc7469` |
| provenance checker `.py` | 6,921 | `a3d7e5af8350de09a095f1f369e3f3eb12e62db55c8f45917a122651b26c5291` |
| canonical cross-check `.json` | 2,099 | `6aa990676ff6ed006f37aef8d8678fdec5192fc5c33fae1288e66e1887a6fe36` |

The provenance checker parses the Lean mate/fusion/matrix tables, reconstructs the 22 matchings
from C379's frozen conic coordinates, and compares the fusion, involution, and signed matrix with
C378's frozen JSON.  It independently rechecks matching involutions, distinctness, both
one-factorizations, fusion-size sums, and the integer matrix square.  C378 and C379 already carry
separate primary and independent mathematical replays; C380 does not duplicate their full finite
group closures inside Lean.

## Trusted boundary and exclusions

The formal trusted boundary is Lean 4's kernel, Mathlib's projectivization/finite-linear-algebra
API, the existing q=11 semantic terminal, and the displayed bounded tables.  The provenance check
uses deterministic Python 3 integer/list arithmetic and the frozen C378/C379 JSON artifacts.

C380 does **not** formalize cubic surfaces, del Pezzo roots, the full order-1320 group closure, the
rank-16 intersection tensor, a general biplane or one-factorization theory, a two-parent deep-hole
quotient, a canonical tensor extension, Frobenius descent, or integral moduli.  The q=11 leaf proves
the `[7,4,4]` kernel statement; it does not add a separate formal dual-code `[7,3,5]` or AME layer.
These exclusions are part of the theorem boundary, not deferred proof holes.
