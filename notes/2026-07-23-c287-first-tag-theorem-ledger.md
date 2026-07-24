# C287 first-tag theorem and axiom ledger

**Lane**: `build-sys`
**Status**: SOURCE-LEVEL TERMINAL LEDGER COMPLETE; authoritative axiom extraction pending

## Evidence boundary

This ledger maps the first-release geometry claims to fully qualified Lean declarations. It uses
the declared paper claims, tracked Lean source, and the exact project-local import graph. It does
not infer trust from a successful historical build or from the absence of `sorry`.

No Lean, Lake, generator, or build command was run. Consequently the axiom column below is not an
authoritative `#print axioms` result. A source scan of the 51-file candidate main closure found no
project-owned `axiom`, `sorry`, `admit`, `unsafe`, or `native_decide`. That negative establishes
only the visible source boundary. Exact terminal axiom sets remain `facts-missing` until each
terminal is extracted under the pinned toolchain in a quiet build-owner window.

## Adopted human-scale claims

| Mathematical claim | Exact terminal declaration | Module closure | Source-visible boundary |
|---|---|---:|---|
| A fixed-point-free collinearity-preserving projective involution gives a second-player win | `ProjectiveCap.Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution` | 5 | Symbolic theorem; no project-owned axiom or computational terminal visible |
| The affine cap game on `K^n`, `n > 0`, is a second-player win | `CapGame.Affine.initialP_fin` | 2 | Symbolic mirror proof; no project-owned axiom or computational terminal visible |
| `PG(n,2)`, `n >= 1`, is a second-player win | `ProjectiveCap.Projective.initialPStatement_binary_of_projectiveDim_ge_one` | 9 | Symbolic reduction to the binary sum-free game; no project-owned axiom or computational terminal visible |
| Odd-cardinality fields in even vector rank `2n`, `n > 0`, give a second-player win on projective space | `ProjectiveCap.Projective.initialPStatement_of_odd_card_finrank_eq_two_mul` | 6 | Symbolic nonsquare-block mirror proof; no project-owned axiom or computational terminal visible |
| Every rank-three projective model over a field of even cardinality is a second-player win | `ProjectiveCap.initialPStatement_of_even_card_finrank` | 16 | Symbolic characteristic-two residual-mirror proof; no project-owned axiom or computational terminal visible |
| The projective plane of order five is a second-player win | `ProjectiveCap.ConicLocalization.initialPStatement_of_card_eq_five_finrank` | 16 | Symbolic specialization through the proved order-five no-intrusion kernel; no project-owned axiom or computational terminal visible |
| The projective plane of order seven is a second-player win | `ProjectiveCap.ConicLocalization.initialPStatement_of_card_eq_seven_finrank` | 16 | Symbolic specialization through the proved order-seven no-intrusion kernel; no project-owned axiom or computational terminal visible |

The exact union of the four terminal modules `CapGame.Affine`, `ProjectiveCap.Binary`,
`ProjectiveCap.EllipticMirror`, and `ProjectiveCap.PlaneOutcome` is 26 Lean files and 8,954 code
lines. `ProjectiveCap.Mirror` is already in that closure and need not be a separate packaging root
to include the generic theorem.

## Declared but differently adopted claims

| Claim or artifact | Exact declaration | Status |
|---|---|---|
| Hyperbolic quadric `Q+(2m-1,q)` over odd `q` is a second-player win | `ProjectiveCap.Projective.initialSubCapP_blockQuadric_of_odd_card` | Advertised by the public-artifact README but absent from the current manuscript claim skeleton. Adding its module to the adopted human closure costs one file and 122 code lines. Decide adoption before treating it as a first-tag terminal. |
| Projective plane of order nine, conditional on the intruder terminal-reply kernel | `ProjectiveCap.ConicLocalization.initialPStatement_of_intruderTerminalReply_finrank` | Correctly not an unconditional Lean claim: the theorem explicitly requires `IntruderTerminalReplyStatement`. The manuscript labels the result computed and the Lean kernel open. |
| Projective plane of order eleven | `ProjectiveCap.Certificate.CertData.Q11.initialPStatement_finrank` in `ProjectiveCap/CertData/Q11Assembly.lean` | Paper table labels this Lean-proved, but it belongs to the separate Q11 certificate package. The source contains `#print axioms` without a durable recorded output. Exact generator, schema, checker, terminal gate, clean regeneration, and public axiom extraction remain unresolved. |
| Projective plane of order thirteen | `ProjectiveCap.Certificate.CertData.Q13.initialPStatement_finrank` in `ProjectiveCap/CertData/Q13Assembly.lean` | Same external-package boundary as Q11. Generated leaves use kernel `decide` bridges (`of_decide_eq_true`) and contain no visible `native_decide`, `sorry`, or project axiom, but that does not replace the missing package provenance and authoritative axiom output. |
| `FiniteGeom` shared-library umbrella | none | `FiniteGeom.lean` contains imports and no declaration. Its 24-file closure is completely disjoint from the 27-file advertised mirror closure, so it is a library-seeding choice rather than a dependency of any terminal above. |
| Flagship sum-free outcome classification | no final terminal declared by the current seven-root contract | The first paper includes a sum-free classification whose remaining formalization gates are still open. Four `Sumfree` modules enter incidentally through the binary/projective closure, but incidental imports are not a paper terminal. The final paper target manifest is incomplete until the adopted sum-free theorem has an exact declaration. |

The computed `q = 3, 9, 17, 19, 23` rows and partial `q = 25` row are not Lean terminal claims.
They require their own reproducibility and certificate entries if adopted; they must not inherit a
Lean label from the symbolic transport modules.

## Packaging consequence

There are three distinct source sets:

1. The currently adopted human manuscript terminals: 26 files / 8,954 code lines.
2. The six advertised human mirror modules, including the README-only hyperbolic-quadric result:
   27 files / 9,076 code lines.
3. The approved candidate first tag after adding the disjoint `FiniteGeom` umbrella:
   51 files / 12,987 code lines.

The existing 17-file public-rewrite list splits along the same boundary. Nine affected files are in
the disjoint `FiniteGeom` component. Eight are in the 27-file mirror closure; omitting the
README-only hyperbolic module leaves seven definite workflow-bearing files in the 26-file adopted
claim closure.

This does not silently change the approved first-tag contract. It identifies the decision precisely:
is the first tag a claim-minimal release artifact, or is it deliberately also the seed release of
the broader `FiniteGeom` library? The latter remains within the size gate but more than doubles the
human review surface and is not justified by theorem dependence.

## Required gates

1. Decide whether the first tag is claim-minimal or deliberately library-seeding, and whether the
   hyperbolic-quadric theorem is an adopted paper claim.
2. Add the eventual sum-free terminal before calling the paper target map complete.
3. Give Q11 and Q13 separate package manifests naming their generator, semantic schema, checker,
   assembly terminal, exact gate, and source-regeneration command.
4. In a quiet window, extract authoritative `#print axioms` facts for every adopted main and
   certificate terminal. A source scan or a checked-in `#print` command is not its output.
5. Rewrite and referee-review only after the adopted source boundary is fixed; otherwise nine to
   ten files may receive public cleanup before a decision excludes them.
