# C527 — C433/C526 modular contraction packaging for Paper 2 and Lean

**Lane:** `clebsch`

**Status:** `COMPLETE — FINAL INDEPENDENT REVIEW GO`

**Date:** 2026-07-23

## Goal

Package the C433 modular depth/Fourier theorem—and C526's final source-pairing disposition—as one
bounded Paper-2 theorem block plus one compact Lean terminal.  This is a packaging task, not a new
modular representation census, Paper-1 spine expansion, or full Paper-2 drafting campaign.

## Inputs and ownership

- `notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.md`
- `notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.md` and its completed evidence bundle
- `notes/2026-07-20-c425-clebsch-double-coset-depth-lean.md`
- `notes/2026-07-20-c426-clebsch-scheme-fourier-lean.md`
- `notes/2026-07-23-c511-weil-roof-phase-3-synthesis.md`
- the current Clebsch Paper-2 result ledger/outline named by the clebsch handoff.

The `clebsch` lane owns manuscript and Lean edits.  Before any Lean operation, read
`lean/AGENTS.md` completely and obey its guarded build, gate, axiom-audit, and process rules.

## Phase A — editorial placement

1. State the local q=11 theorem at its proved strength:

   - divided integral odd Fourier becomes a rank-two self-adjoint square-zero operator mod 11;
   - C411 depth kills the C412/C430 socle and selects a nondegenerate contracting complement;
   - matrix units and the valency metric make the ordered target flag projectively rigid;
   - the degree-5/6 `A5` interface remains semisimple.
2. Insert C526's disposition:

   - if positive, state the forced Tate/depth isometry and its exact naturality;
   - if negative, state the sharp source-pairing obstruction as the theorem boundary.
3. Place this as a local Modular Gateway model or appendix theorem in Paper 2.  Do not add it to
   Paper 1's protected replacement spine, and do not make novelty wording without a claim-specific
   literature audit.
4. Update the result ledger, proof/evidence map, and C320 adoption delta only if the theorem is
   actually adopted.

## Phase B — compact Lean terminal

Prefer generic finite-dimensional linear algebra plus frozen `Fin 4`/`Fin 3` data:

```text
F²=0,
im(F)=ker(F),
ker(D)=socle,
O=P_depth direct_sum im(F),
h²=0,
Fh+hF=1,
F self-adjoint for the valency form,
im(F) Lagrangian,
ordered target flag has projectively trivial isometric stabilizer.
```

Suggested module/gate names:

- `RelativeConicArcs.ClebschModularFourierContraction`
- `RelativeConicArcs.Gates.ClebschModularFourierContraction`

The finite leaf must recompute the identities from accepted matrices; it may not freeze the
conclusions as propositions.  Import C425/C426 terminals where useful, preserve their external
scheme-semantics boundary, use no project-local axioms, and run the exact terminal/axiom audit.
C526's source-pairing theorem is formalized only if its proof has a compact algebraic interface;
otherwise record it honestly as an external proved input.

## Acceptance and stops

Done means:

- one placement-ready Paper-2 theorem/boundary block;
- one import-only Lean gate with scoped build and axiom audit;
- exact theorem-to-evidence rows and source hashes;
- manuscript/result-ledger edits only within the adopted scope.

Stop rather than:

- drafting all of Paper 2;
- reopening C433/C526 calculations;
- formalizing Brauer-tree theory or general Tate cohomology merely to prove the frozen matrix leaf;
- importing the theorem into Paper 1;
- claiming a uniform q=7/q=11 family without C439's separate portability theorem.

## Result

C526 closed negatively, so the adopted Paper-2 package is a local theorem plus a sharp
non-identification boundary.  The divided odd Fourier operator, depth-selected contraction,
valency metric, and ordered target flag form a projectively rigid characteristic-eleven package.
The complete pairing space functorially induced on C412's source Tate plane lies in the orthogonal
ordered-flag orbit, while the target ordered flag is nonorthogonal.  Thus no natural source-to-target
isometry exists; no fitted choice among the ten projective flag maps is promoted.

This package is adopted as a local Modular Gateway model immediately after the odd-carrier theorem
in Paper 2, with the obstruction in the same theorem block.  It is not part of Paper 1 and makes no
novelty or uniform-family claim.

## Placement-ready Paper-2 theorem block

> **Theorem (local modular Fourier contraction and Tate boundary at `q=11`).**
> Let `O_odd` be the four-dimensional reduction modulo `11` of the integral odd relation lattice,
> and divide its integral odd Fourier matrix by `11` before reduction.  The resulting operator
> `Fbar` has rank two and satisfies
> `Fbar^2=0` and `im(Fbar)=ker(Fbar)=L_F`.  The weighted `1,4,6` depth map has kernel equal to the
> fixed socle, and its image `P_depth` is transverse to `L_F`.  Consequently
> `O_odd=P_depth direct_sum L_F`, and there is a unique contraction `h` that kills `P_depth` and
> inverts `Fbar:P_depth -> L_F`; it satisfies
> `h^2=0` and `Fbar h+h Fbar=1`.
>
> The operators `hFbar,h,Fbar,Fbar h` are matrix units.  For the valency form
> `G=diag(1,1,2,2)`, `Fbar` is self-adjoint, `L_F` is Lagrangian, and `P_depth` is nondegenerate.
> Adding the ordered doubled/residual target flag kills the last nontrivial projective valency
> isometry, so the target metric-plus-flag package is projectively rigid.
>
> This rigidity does not identify the target with the relative-cubic Tate plane.  Every bilinear
> form on that source plane induced functorially from the frozen invariant-form pencil makes its
> ordered rank-one/rank-nine flag orthogonal.  The target doubled/residual flag has cross-pairing
> `2` (and dual cross-pairing `5`), hence lies in the nonorthogonal orbit.  Therefore no such
> source pairing admits a projective isometry carrying the ordered source flag to the ordered
> target flag.  On restriction to the degree-`5/6` `A5` interface, characteristic `11` is
> semisimple; this ambient obstruction is not an `A5` augmentation degeneration.

The statement is deliberately local to the frozen characteristic-eleven carrier.  The geometric
meaning of the accepted matrices and the source Tate construction remain conceptual proof plus
exact replay boundaries; the compact Lean leaf checks the finite linear algebra.

## Lean terminal

The new terminal is
`RelativeConicArcs.ClebschModularFourierContraction`, with import-only gate
`RelativeConicArcs.Gates.ClebschModularFourierContraction`.  It imports the established depth
terminal and the exact integral odd-Fourier matrix.  The gate also imports the C425 and C426 gates
so their external geometric and association-scheme boundaries remain visible.

The terminal recomputes:

- multiplication of the integral quotient by `11` back to the imported odd Fourier matrix;
- the weighted depth matrix from C425's three positive profile columns and weights `1,4,6`;
- the socle relation and exact one-dimensional depth kernel, square-zero identities,
  contracting-homotopy identity, split depth basis, depth factorization, and complementary
  projectors;
- the internal matrix-unit products, grading relations, an ordered depth-plus-radical basis, and
  uniqueness of the operator that kills the depth basis and inverts Fourier on its image;
- `im(Fbar)=ker(Fbar)` with `h` supplying the reverse witness;
- valency self-adjointness, a nondegenerate depth-plane Gram matrix with two-sided inverse, and a
  rank-two zero-Gram basis with an explicit left inverse;
- projective scalarity of every target isometry fixing both ordered target lines; and
- target cross-pairings `2` and `5` in the vector and dual conventions; and
- zero source cross-pairing plus a surviving nontrivial source reflection versus the projectively
  scalar target stabilizer.

The finite leaf freezes matrices, not conclusions: every exported identity reduces from matrix
multiplication or imported depth-profile values.  It uses no project-local axiom.  The source Tate
interpretation, completeness of the invariant-form pencil, and geometric meaning of the target are
proved by the C433/C526 conceptual arguments and independently replayed certificates rather than
reformalized as general Tate or Brauer theory.

## Theorem-to-evidence map and proposed C320 delta

| Paper clause | Exact Lean terminal | Residual evidence boundary |
|:--|:--|:--|
| divided integral Fourier, `Fbar^2=0` | `eleven_smul_dividedFourierInt`, `dividedFourier_sq` | identification with the odd relation Fourier operator is the imported C425/C433 exact-data boundary |
| depth contraction and direct sum | `depthMatrix_values`, `depthMatrix_socle`, `depthMatrix_kernel`, `contraction_sq`, `contraction_identity`, `depthBasis_split`, `depthMatrix_factorization`, `complementary_projectors`, `matrixUnit_products`, `grading_relations`, `mem_range_dividedFourier_iff`, `carrierBasis_inverse`, `contraction_on_carrierBasis`, `contraction_unique` | C411/C412 interpretation of the profile kernel as the fixed socle is conceptual/external |
| valency geometry | `dividedFourier_selfAdjoint`, `depthBasis_nondegenerate`, `radicalBasis_lagrangian_certificate` | valencies and scheme semantics remain the C426/C433 external exact-enumeration boundary |
| rigid ordered target flag | `targetFlag_projectivelyRigid`, `targetMetric_inverse`, `targetFlag_crossPairing`, `targetFlag_dualCrossPairing` | coordinates of the doubled/residual flag come from the C433 certificate |
| negative Tate/source boundary | `sourceFlag_crossPairing_zero`, `sourceReflection_residual_symmetry`, `source_target_flag_orbits_disjoint` | C526's proof that the complete functorially induced source pairing space is diagonal is conceptual proof plus exact certificate |
| degree-`5/6` `A5` semisimplicity | no new Lean claim | ordinary Maschke argument; the terminal makes no abstract-group identification |

C320 should add these rows only to the Paper-2 trust ledger.  It must label the first four routes
as mixed Lean plus accepted finite/geometric input, the source completeness statement as
conceptual proof plus C526 certificate, and the `A5` clause as a cited classical argument.  No row
inherits a full-trust Lean label for scheme semantics, Tate naturality, or abstract group
identification.

## Reproducibility and validation

From `/home/tavis/src/othello`, the independent input checks are:

```bash
python3 notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.py --check
python3 notes/2026-07-23-c433-modular-depth-fourier-exact-sequence-replay.py
sha256sum -c notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.sha256
python3 notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.py --check
python3 notes/2026-07-23-c526-tate-pairing-rigid-target-bridge-replay.py
sha256sum -c notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.sha256
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschModularFourierContraction \
  RelativeConicArcs.Gates.ClebschModularFourierContraction \
  --profile single --threads 1 --cores 20-23 \
  --aggregate RelativeConicArcs.Gates.ClebschModularFourierContraction
```

The C433 and C526 primary checkers, independent replays, and checksum manifests pass.  The original
scoped terminal and gate bundle passed build queue
`/home/tavis/.cache/othello-lean-build/run-20260723-231705-ee87a9d4` built the terminal and gate,
then passed the exact trace-only aggregate gate.  Peak RSS was `1,913,600` KiB for the terminal and
`1,809,852` KiB for the gate.  All 17 selected C527 terminals report exactly `propext`,
`Classical.choice`, and `Quot.sound`; no `sorryAx`, native-decision axiom, project-local axiom, or
opaque external oracle occurs.  The validated artifact and editorial bundle is pinned at
`050120356688242b0872b928e0973b53e7ce4296`.

The subsequent `ej`+`tt` upgrade expands the gate to 27 terminals.  Exact aggregate revalidation
passed at
`/home/tavis/.cache/othello-lean-build/run-20260723-233344-56ce854d`: the terminal and gate built,
the trace-only aggregate gate passed, and peak RSS was `1,930,356` KiB and `1,811,008` KiB
respectively.  All 27 selected terminals report exactly `propext`, `Classical.choice`, and
`Quot.sound`; no `sorryAx`, native-decision axiom, project-local axiom, or opaque external oracle
occurs.  The upgraded Lean artifact is pinned at
`bf01d4156811cf0715ac6775efa0cab45d3ff818`.

The new Lean source is itself the compact kernel-checked certificate, so no generated data file is
introduced.  C433 and C526 supply independent implementations and canonical JSON evidence for the
same load-bearing matrices and flag pairings.

| source | bytes | SHA-256 |
|:--|--:|:--|
| `lean/RelativeConicArcs/ClebschModularFourierContraction.lean` | 17,168 | `850c532b1d3157fed6369960380db4cced84725d34d7df1153af0582173d9fc7` |
| `lean/RelativeConicArcs/Gates/ClebschModularFourierContraction.lean` | 3,504 | `fb4286b1c64fe90ce2399b370bf4482f5cb62151ded2bb51cf8b3de7f92de860` |
| `notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.md` | 11,337 | `3e39d37e7828f74cd95c51c34abd919c671bc313e46dbbb57ada6b4ea9513352` |
| `notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.md` | 10,518 | `a1eb543e98d86484bff3e5ce569ee2a5094eebb1c791025ba6c763a00333ca76` |

## Closeout and mystery ledger

The `ej`+`tt` pass exposed one cheap strengthening and one firm stop.

- **Settled:** the Lean leaf does not merely check `Fbar^2=0`; it checks a split depth basis,
  complementary projectors, matrix-unit and grading identities, uniqueness of the contraction from
  its depth/radical action, a nondegenerate depth Gram matrix, and an explicit Lagrangian basis with
  left inverse.
- **Settled:** metric type alone is insufficient.  The ordered flag is the decisive invariant:
  source cross-pairing is zero and retains a nontrivial projective reflection, while the target
  cross-pairings are nonzero in both vector and dual conventions and its ordered-flag stabilizer is
  projectively scalar.
- **Settled by the Tao pass:** “canonical contraction” and “automorphism mismatch” no longer rest
  only on prose.  The formal ordered carrier basis proves uniqueness of `h`, and the formal source
  reflection makes the residual-`C2` versus trivial-projective-stabilizer mismatch explicit.
- **Free portability test:** any proposed continuation or uniform-family seam can now be rejected
  by either of two one-line invariants before a module census: source/target flag cross-pairing
  `0` versus nonzero, or residual projective `C2` versus scalar stabilizer.  C439 may use either
  falsifier without reconstructing the full contraction.
- **Settled numerical curiosity:** the displayed depth-basis Gram determinant is `1`, whereas the
  C412 target-coordinate Gram determinant is `3=5^2` in `F_11`.  Their ratio is therefore a square,
  as required for two coordinate descriptions of the same anisotropic plane; the discrepancy is
  basis normalization, not another invariant.
- **Open as validation/release gates:** the queued 27-terminal aggregate gate and axiom audit must
  pass, the upgraded bundle must be pinned, and independent referee review must be recorded before
  archival.
- **No theorem-level mystery remains:** the source and target occupy different ordered-flag
  orbits.  A basis-free explanation of the polarization-space collapse is not needed for this
  theorem and is not allocated.

## Independent review

Final independent review returned `GO` on 2026-07-23 with no repair request.  The review read both
touched Lean modules in full, checked the theorem block against the C433 and C526 source boundaries,
reran both primary checkers, both independent replays, and both checksum manifests, verified the
exact source hashes, and inspected the successful 27-terminal aggregate build and axiom output.
The imported C425/C426 boundary modules were unchanged from their completed referee review.

## Closing review checklist

- [x] Placement is local to Paper 2 and contains no novelty wording.
- [x] Paper 1 and general Brauer/Tate theory are untouched.
- [x] The finite terminal recomputes identities rather than freezing propositions.
- [x] C425/C426 trust boundaries remain explicit.
- [x] C433/C526 primary and independent replays pass.
- [x] Upgraded import-only gate build and exact 27-terminal axiom audit pass.
- [x] Source hashes are recorded.
- [x] Final upgraded validated commit is recorded.
- [x] Independent referee review returns `GO`; no repair was requested.
