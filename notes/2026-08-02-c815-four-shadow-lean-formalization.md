# C815 — Four-shadow recognition in Lean

**Lane:** `clebsch`  
**Date:** 2026-08-02

## Result

The reusable converse and sign-locus recognition packet are formalized in
`RelativeConicArcs.FourShadowRecognition`.  The module reuses the existing
order-six bracket Pfaffian, matching evaluation, triangle cubic, and pair
moment declarations.  It does not create another two-graph, switching, cut,
or aligned-design API.

For a symmetric zero-diagonal matrix over an integral domain, nonzero
proportionality between the matching-evaluation form of the commutator
Pfaffian and the triangle cubic now implies

\[
  C^2=\lambda I.
\]

For normalized integral sign matrices, the five first-row balances put the
positive graph on the other five vertices in degree-two pentagon gauge and
force `C * C = 5 • 1`.  One displayed complementary-minor coefficient then
selects either proportionality scalar `4` or `-4`.  Multiplying every edge by
one nonzero scalar preserves the classification.

No manuscript, public release, or shared Paper III manifest changed.  The
new module has a separate focused gate and paper-local hash/audit replay for
the later combined reconciliation.

## Formal correspondence

| Human statement | Lean declaration |
|---|---|
| Pfaffian is the signed matching evaluation | `GoldenCommutatorPfaffian.pfaffianSix_bracketMatrix_eq_matchingEvaluation` |
| matching evaluation is translation invariant | `GoldenCommutatorPfaffian.matchingEvaluation_translate` |
| pair moment is `c_ij (C^2)_ij` | `ClebschGoldenConference.pairTriangleSum_eq_mul_mulApply` |
| nonzero cubic proportionality makes the triangle cubic translation invariant | `FourShadowRecognition.triangleCubic_translate_of_proportional` |
| translation invariance kills every pair moment | `FourShadowRecognition.pairTriangleSum_eq_zero_of_triangleCubic_translate` |
| nonzero edges make the square diagonal and then scalar | `FourShadowRecognition.exists_scalar_mul_self_of_offDiagonal_zero` |
| weighted converse `C^2 = lambda I` | `FourShadowRecognition.exists_mul_self_eq_scalar_of_cubicsProportional` |
| five balances give the degree-two pentagon gauge | `FourShadowRecognition.pentagonGauge_of_firstRowBalanced` |
| pentagon balances give `C^2 = 5I` | `FourShadowRecognition.normalizedSignMatrix_sq_of_firstRowBalanced` |
| one `012` coefficient selects the positive or negative orientation | `FourShadowRecognition.cubicsProportional_four_of_sixTests`, `FourShadowRecognition.cubicsProportional_neg_four_of_sixTests` |
| nonzero coincidence characterizes the normalized conference square | `FourShadowRecognition.exists_nonzero_cubicsProportional_iff_conferenceSquare` |
| common nonzero edge scaling preserves recognition | `FourShadowRecognition.exists_nonzero_cubicsProportional_smul_iff_conferenceSquare` |

The extraction of a pair moment uses the mixed finite difference of four
translated sparse vectors.  Once the off-diagonal entries of `C^2` vanish,
associativity gives `C(C^2)=(C^2)C`; a nonzero edge from the root then equates
every pair of diagonal entries.

The pentagon proof does not enumerate normalized signings.  Each first-row
balance says that four incident signs sum to zero, hence exactly two are
positive.  The ten off-diagonal entries of the square are then one symbolic
argument applied ten times under relabelling: three signs whose sum is again a
sign have product the negative of that sum, so the three products pairing an
edge from one chosen vertex with the opposite edge of the other multiply to
`-1`; splitting on those three products and on the three products `a*b`,
`a*c`, `a*d` forces the pair moment to be `-1`.  Only six derived signs are
split, never the ten free edge signs.

Compiled evaluation is confined to the oriented packet.  One decidable
statement ranges over all `2^10` signings and returns, under the five
balances, the six labelled codes in each Hodge orientation together with the
matching coefficient sign.  The twelve resulting cubic identities are separate
symbolic polynomial identities, one per labelled pentagon, closed by ring
normalization.

## Correction found during validation

The coefficient `shadowCoefficient012` was defined as the determinant of the
lower-left three-by-three block, while its docstring described it as the
coefficient of `x₀x₁x₂` in the commutator-Pfaffian cubic.  Those differ by a
sign, so both orientation predicates selected the opposite fibre and the
classification statement was false; compiled evaluation of the closed
statement reported it false rather than proving it.  The definition now
carries the sign of the actual coefficient, and with that correction the two
six-element fibres and both proportionality scalars agree with the frozen
human classification.

The independent recomputation of the balanced signings, their orientations,
and their proportionality scalars is
`notes/2026-08-02-c815-normalized-signing-classification.py`, with committed
output `notes/2026-08-02-c815-normalized-signing-classification.json`.  It uses
exact integer arithmetic only, checks the proportionality scalar at four
evaluation points, and reports no unclassified balanced signing.  Replay:

```sh
python3 notes/2026-08-02-c815-normalized-signing-classification.py
```

| File | SHA-256 |
|---|---|
| `notes/2026-08-02-c815-normalized-signing-classification.py` | `fa8f1893723d2616f41d01cfa42a49b3a5ac1aea3ad262b1af38c24794c38c16` |
| `notes/2026-08-02-c815-normalized-signing-classification.json` | `86406f34da12c8f700cbd62820cec849f504b9c809916d8fcb214cf81221f465` |

## Trust boundary and replay

The focused gate is
`RelativeConicArcs.Gates.FourShadowRecognition`.  Its tracked audit covers the
three reused bridge declarations and the new weighted, pentagon, orientation,
classification, and scalar-transport terminals.  The paper-local replay is

```sh
python3 papers/clebsch-passages/verification/verify_four_shadow_lean.py \
  --lean-root /home/tavis/src/othello/lean --source-only
```

Supplying the stdout of the focused gate with `--axiom-log` instead of
`--source-only` additionally checks observed axioms against the tracked
report.  Both modes pass on the committed tree.  The later combined Paper III
manifest remains owned by C800 after C823 lands its declarations.

Every symbolic terminal depends only on `propext`, `Classical.choice`, and
`Quot.sound`.  The four declarations below the orientation classifier —
`cubicsProportional_four_of_sixTests`,
`cubicsProportional_neg_four_of_sixTests`,
`exists_nonzero_cubicsProportional_iff_conferenceSquare`, and
`exists_nonzero_cubicsProportional_smul_iff_conferenceSquare` — additionally
depend on the declaration-local axiom that compiled evaluation introduces for
the classifier.  That axiom is the entire finite trust boundary of this
module; the weighted converse, the pentagon gauge, and the conference square
do not touch it.

The validated artifacts are the tracked axiom report
`papers/clebsch-passages/verification/four_shadow_axioms.txt`, the seven-file
source closure `four_shadow_source_closure.json`, and the manifest
`four_shadow_formal.json`, whose recorded source, verifier, closure, and axiom
hashes agree with the committed tree.

The exact rank-14 Jacobian calculation at the two weighted golden points
remains the external rational certificate
`notes/2026-08-02-c809-four-shadow-characterization.py` with its adjacent JSON
output.  Lean proves neither that local tangent rank nor a global
classification of remote weighted solutions.  These exclusions match the
frozen human theorem.

## Closeout: extra juice and Tao check

The cheap structural upgrades are included in the API: proportionality is
stable under a common nonzero edge scale, the five balance equations alone
produce the full conference square, and both Hodge orientations have the same
six-test interface.  These make the declarations usable without reopening the
fixed conference calculation or the aligned-design reconstruction.

The Tao-style pressure point is the orientation step.  Its mathematical reason
is already the human pentagon-stabilizer parity argument: the twelve labelled
pentagons split into two sets of six.  Formalizing the full permutation-parity
action would enlarge the API without strengthening the recognition theorem;
the bounded native selector therefore remains the explicit finite trust
boundary.

## Mystery ledger

| Feature | Status | Exact evidence or boundary |
|---|---|---|
| Why five root balances control all ten remaining inner products | settled | every row has two positive edges on five vertices; the ten symbolic identities are kernel-checked |
| Why the proportionality sign has two six-element fibres | settled mathematically, finite in Lean | pentagon-stabilizer parity in the human proof; exhaustive normalized orientation selector in the focused gate |
| Why a common scalar does not affect recognition | settled | both cubics have matrix weight three |
| Rank-14 local weighted rigidity | external boundary | exact rational Python/JSON certificate; no Lean rank interface was essentially free |
| Remote weighted components of the equality locus | outside this theorem | the converse gives generalized conference orthogonality, not a global weighted classification |

No unexplained feature remains inside the formal statement.  The last two rows
are explicit coverage boundaries, not open obligations of this task.

## Vibe check

Strong closure: the causal weighted proof is symbolic, the forbidden global
signing table is absent from the pentagon argument, and the only native step is
the small labelled orientation split that the task explicitly permitted.

